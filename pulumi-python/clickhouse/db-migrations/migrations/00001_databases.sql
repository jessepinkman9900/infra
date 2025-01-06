-- +goose Up
-- +goose StatementBegin
CREATE DATABASE IF NOT EXISTS database1;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP DATABASE IF EXISTS database1;
-- +goose StatementEnd
