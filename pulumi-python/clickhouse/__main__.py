import pulumi
import pulumi_random as random
import pulumiverse_clickhouse as clickhouse
from pulumi_command import local


def provision_dev_instance(prefix: str):
  config = pulumi.Config("chouse")

  clickhouse_service = clickhouse.Service(
    f"{prefix}-db",
    name=f"{prefix}-db",
    region=config.get("region"),
    cloud_provider=config.get("provider"),
    tier="development",
    idle_scaling=True,
    idle_timeout_minutes=config.get_int("idle_timeout_minutes"),
    password="default_password",
    ip_accesses=[{"source": "0.0.0.0", "description": "Allow access from anywhere"}],
  )
  pulumi.export("clickhouse.name", clickhouse_service.name)
  pulumi.export("clickhouse.tier", clickhouse_service.tier)
  pulumi.export("clickhouse.region", clickhouse_service.region)
  pulumi.export("clickhouse.endpoint", clickhouse_service.endpoints)
  pulumi.export("clickhouse.password", clickhouse_service.password)

  return clickhouse_service


def provision_prod_instance(prefix: str):
  config = pulumi.Config("chouse")

  password = random.RandomPassword(
    f"{prefix}-clickhouse-password", length=16, special=False
  )
  clickhouse_service = clickhouse.Service(
    f"{prefix}-db",
    name=f"{prefix}-db",
    region=config.get("region"),
    cloud_provider=config.get("provider"),
    tier="production",
    num_replicas=config.get_int("num_replicas"),
    min_total_memory_gb=config.get_int("min_total_memory_gb"),
    max_total_memory_gb=config.get_int("max_total_memory_gb"),
    idle_scaling=True,
    idle_timeout_minutes=config.get_int("idle_timeout_minutes"),
    password=password.result,
    ip_accesses=[{"source": "0.0.0.0", "description": "Allow access from anywhere"}],
  )
  pulumi.export("clickhouse.name", clickhouse_service.name)
  pulumi.export("clickhouse.tier", clickhouse_service.tier)
  pulumi.export("clickhouse.region", clickhouse_service.region)
  pulumi.export("clickhouse.endpoint", clickhouse_service.endpoints)
  pulumi.export("clickhouse.password", clickhouse_service.password)

  return clickhouse_service


def apply_db_migrations(clickhouse_service: clickhouse.Service):
  db_migrations_config = pulumi.Config("db-migrations")
  migrations_dir = db_migrations_config.get("migrations_dir")
  nativesecure_endpoint = clickhouse_service.endpoints.apply(
    lambda endpoints: next(
      filter(lambda endpoint: endpoint.protocol == "nativesecure", endpoints), None
    )
  )
  if nativesecure_endpoint is None:
    raise Exception("nativesecure endpoint not found")

  goose_dbstring = pulumi.Output.all(
    endpoint=nativesecure_endpoint, password=clickhouse_service.password
  ).apply(
    lambda args: f"clickhouse://default:{args['password']}@{args['endpoint']['host']}:{args['endpoint']['port']}/default?secure=true&skip_verify=false"
  )

  # goose up
  goose_dbstring.apply(
    lambda dbstring: local.Command(
      "apply-db-migrations",
      create=f'GOOSE_DRIVER=clickhouse GOOSE_DBSTRING="{dbstring}" goose -dir {migrations_dir} up',
    )
  )


if __name__ == "__main__":
  current_stack = pulumi.get_stack()
  naming_config = pulumi.Config("naming")
  prefix = naming_config.get("prefix")

  clickhouse_config = pulumi.Config("chouse")

  clickhouse_service = None
  if clickhouse_config.get("tier") == "development":
    clickhouse_service = provision_dev_instance(prefix)
  elif clickhouse_config.get("tier") == "production":
    clickhouse_service = provision_prod_instance(prefix)

  db_migrations_config = pulumi.Config("db-migrations")
  if db_migrations_config.get_bool("apply"):
    print("applying db migrations to provisioned clickhouse instance")
    apply_db_migrations(clickhouse_service)
