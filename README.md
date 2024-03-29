# Transcom CircleCI Docker Images

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/transcom/circleci-docker/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/transcom/circleci-docker/tree/main)

This repository manages the custom-built docker images for use with CircleCI and development. Each image contains the minimum necessary tools to run testing and development.

The base image contains Python 3.8.x.

## License Information

Works created by U.S. Federal employees as part of their jobs typically are not eligible for copyright in the United
States. In places where the contributions of U.S. Federal employees are not eligible for copyright, this work is in
the public domain. In places where it is eligible for copyright, such as some foreign jurisdictions, the remainder of
this work is licensed under [the MIT License](https://opensource.org/licenses/MIT), the full text of which is included
in the [LICENSE.txt](./LICENSE.txt) file in this repository.

## CI/CD

This repository uses Workflows to build the containers. The main job is a
`build` job for historical reasons. The workflows filter on certain branches
that match the releases of the Docker images. Branches that get created in this
repository with any of the following names will not build.

* `latest`
* `milmove-app`
* `milmove-cypress`
* `milmove-atlantis`
* `milmove-cypress`
* `milmove-infra-tf112`
* `milmove-infra-tf132`

The main workflow is named `build-containers` and runs `test-branch-name` to
check if the name of the branch matches any of the name of the containers that
get built. Take care naming your branches as if the `test-branch-name` job
fails, it will not allow the `build` command to run which will not allow PRs to
get merged in.

## Images

Each image is specifically tailored.

For the latest stable images:

* `milmove/circleci-docker:latest`
* `milmove/circleci-docker:base`
* `milmove/circleci-docker:milmove-app`
* `milmove/circleci-docker:milmove-cypress`
* `milmove/circleci-docker:milmove-infra-tf112`
* `milmove/circleci-docker:milmove-infra-tf132`
* `milmove/circleci-docker:milmove-atlantis`

For static tags, use tags including the git hash. You can find the hashes in this repo, from the [CircleCI builds page](https://circleci.com/gh/milmove/circleci-docker/tree/main), or from the [Docker Hub tags](https://hub.docker.com/r/milmove/circleci-docker/tags/) page.

### Base Image

The base image is the absolute minimum of shared dependencies across all images

* [ShellCheck](https://www.shellcheck.net/)
* [CircleCI Local CLI](https://circleci.com/docs/2.0/local-cli/)
* [AWS Command Line Interface](https://aws.amazon.com/cli/)
* [pre-commit](http://pre-commit.com/)

### MilMove App

In addition to the Base Image this contains:

* [golang](https://go.dev/)
* [chamber](https://github.com/segmentio/chamber)
* Apt Packages
  * [NodeJS](https://nodejs.org/en/) at version 18.x (required for supporting USWDS)
  * [Yarn](https://yarnpkg.com/)
  * postgresql-client
  * entr

### MilMove App Browsers (_deleted_)

The `Dockerfile` for `milmove/circleci-docker:milmove-app-browsers` was deleted
in [June 2022 in PR #270](https://github.com/transcom/circleci-docker/pull/270).

### MilMove Infra

In addition to the Base Image this contains:

* [Terraform](https://www.terraform.io/) at version 0.12.x
* [terraform-docs](https://github.com/segmentio/terraform-docs)

### MilMove Orders (deprecated)

The code for [milmove/circleci-docker:milmove-orders](https://github.com/transcom/circleci-docker/tree/db683d4df0175a6048e6ef97d872402fe72269dc/milmove-orders) [was deleted](https://github.com/transcom/circleci-docker/pull/85) in February 2021. It is no longer used.

In addition to the Base Image this contained:

* [golang](https://go.dev/)
* [chamber](https://github.com/segmentio/chamber)
* Apt Packages
  * postgresql-client
  * entr

## Upgrading

The aim of this repository is to always use the latest versions of project dependencies. The fastest way to check
for the latest versions is to use `brew upgrade` and compare the versions between your local macOS machine and the
docker containers. This is a bit tricky and involves manual work. Generally run these two scripts:

```sh
./scripts/brew-upgrade
./scripts/find-updates
```

`./scripts/find-updates` assumes that the above containers exists locally so you may need to download the images.

```sh
docker pull milmove/circleci-docker:latest
docker pull milmove/circleci-docker:base
docker pull milmove/circleci-docker:milmove-app
docker pull milmove/circleci-docker:milmove-cypress
docker pull milmove/circleci-docker:milmove-infra-tf132
docker pull milmove/circleci-docker:milmove-atlantis

```

This should build cleanly locally, but an updated image needs to exist to verify you have all the things.

```sh
make build
```

Scan the output for mismatched version numbers and then update the appropriate `Dockerfile`s.
