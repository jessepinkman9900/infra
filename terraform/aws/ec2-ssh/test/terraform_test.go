package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestTerraform(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		TerraformDir: "../terraform",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	// Get the IP of the instance
	instanceName := terraform.Output(t, terraformOptions, "instance_name")
	// todo: test ssh ingress rule

	// Verify that we get back the right instance name
	assert.Equal(t, "ApiServer", instanceName)
}
