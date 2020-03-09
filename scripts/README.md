# Scripts

Scripts in this directory are added to the primary Dockerfile image at `/usr/local/bin`.

## CircleCI Scripts

These scripts are primarily used for CircleCI workflows.

| Script Name | Description |
| --- | --- |
| `do-exclusively` | CircleCI's current recommendation for roughly serializing a subset of build commands for a given branch |
