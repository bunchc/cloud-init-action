# packer-builder action

This action runs Packer Builds on Rackspace OnMetal hosts. It uploads the resulting images to Cloud Files

## Inputs

### `verbosity`

The level of verbosity in the Ansible output. Parameter is passed directly to `ansible-playbook`. Default: `-vvv`.

### `playbook`

The Ansible playbook to run. Default: `destroy.yml`.

To use in a workflow, call the playbooks in the following order:

- `create.yml`
- `provision.yml`
- `run-packer.yml`
- `destroy.yml`

### `inventory`

The inventory file to pass to Ansible. This is created at the end of `create.yml` and stored as a workflow artifact

## Outputs

### `starttime`

Timestamp from beginning of Ansible run.

### `endtime`

Timestamp from end of Ansible run.

## Example usage

uses: bunchc/ironic-factory@v3
