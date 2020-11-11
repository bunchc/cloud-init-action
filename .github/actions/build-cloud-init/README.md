# cloud-init-action

This action builds `cloud-init` from source.

## Inputs

### `cloud-init-repo`

Git repository for cloud-init. Default: "https://github.com/canonical/cloud-init.git"

## Outputs

### `starttime`

Timestamp from beginning of Ansible run.

### `endtime`

Timestamp from end of Ansible run.

## Example usage

uses: actions/vib-builder-action@v1
