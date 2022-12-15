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

## Architecture

This repository is currently building images for both x86_64 and ARM
architectures. **The ARM architectures are highly experimental for now** and are
only built if the branch matches a certain naming convention. The naming
convention is below:

* `github_username/arm-architecture`
* `arm-architecture`
* `arm-architecture-testing-stuff`

The pattern the CircleCI filter is looking for is `arm-architecture` as long as
your branch has this name, it can be used to build ARM-based Docker images. This
aids in the building of Docker containers for the ARM architecture without the
need for the engineer doing so to have an ARM-based macOS laptop.

### Building for ARM on locally

If you have an M1 or M2 Mac, then you can run the `make build-arm` target
locally for local development. This method is undocumented so please update this
section of the documentation if you have the ability to test using this path.
Thank you in advance for your contributions to the documentation.

### Building for ARM on CirleCI

To build and experiment for ARM, you can edit the `build` file and ensure that
your code only runs after the `else` statement. You can also find Docker build
files in the `arm-arch/` directory for granular experimentation. Please reach
out in #prac-engineering and tag either @ahobson or @rogeruiz for more
information about this. If there's a need for it, create a Slack group in DP3
Slack to tag more folks whom are interested in ARM Architecture.

### Why are we concerned and experimenting with ARM Architecture

There's a document in @rogeruiz's Confluence Space that is tracking the answer
to this question. It's available for anyone with access to it to edit and
collaborate on. Please use the document to collaborate on.

[=> 💨 Speeding up the CI/CD process using ARM architecture and specific build files 🔒](https://dp3.atlassian.net/wiki/spaces/~721089227/pages/1968734312/Speeding+up+the+CI+CD+process+using+ARM+architecture+and+specific+build+files)

## Images

Each image is specifically tailored.

For the latest stable images:

* `milmove/circleci-docker:latest`
* `milmove/circleci-docker:base`
* `milmove/circleci-docker:milmove-app`
* `milmove/circleci-docker:milmove-cypress`
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
  * [NodeJS](https://nodejs.org/en/) at version 16.x (required for supporting USWDS)
  * [Yarn](https://yarnpkg.com/)
  * postgresql-client
  * entr

### MilMove App Browsers

In addition to the MilMove App Image this contains:

* [Chrome](https://www.google.com/chrome/)

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
