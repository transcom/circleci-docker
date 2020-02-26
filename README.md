# Transcom CircleCI Docker Images

[![CircleCI](https://circleci.com/gh/transcom/circleci-docker/tree/master.svg?style=svg)](https://circleci.com/gh/transcom/circleci-docker/tree/master)

This repository manages the custom-built docker images for use with CircleCI and development. Each image contains the minimum necessary tools to run testing and devleopment.

The base image contains Python 3.8.x.

## License Information

Works created by U.S. Federal employees as part of their jobs typically are not eligible for copyright in the United
States. In places where the contributions of U.S. Federal employees are not eligible for copyright, this work is in
the public domain. In places where it is eligible for copyright, such as some foreign jurisdictions, the remainder of
this work is licensed under [the MIT License](https://opensource.org/licenses/MIT), the full text of which is included
in the [LICENSE.txt](./LICENSE.txt) file in this repository.

## Images

Each image is specifically tailored.

For the latest stable images:

* `milmove/circleci-docker:latest`
* `milmove/circleci-docker:base`
* `milmove/circleci-docker:milmove-app`
* `milmove/circleci-docker:milmove-infra`
* `milmove/circleci-docker:milmove-orders`

For static tags, use tags including the git hash. You can find the hashes in this repo, from the [CircleCI builds page](https://circleci.com/gh/milmove/circleci-docker/tree/master), or from the [Docker Hub tags](https://hub.docker.com/r/milmove/circleci-docker/tags/) page.

### Base Image

The base image is the absolute minimum of shared dependencies across all images

* [ShellCheck](https://www.shellcheck.net/)
* [CircleCI Local CLI](https://circleci.com/docs/2.0/local-cli/)
* [AWS Command Line Interface](https://aws.amazon.com/cli/)
* [pre-commit](http://pre-commit.com/)

### MilMove App

In addition to the Base Image this contains:

* [golang](https://golang.org/)
* [go-bindata](https://github.com/kevinburke/go-bindata)
* [NodeJS](https://nodejs.org/en/) at version 10.x (required for supporting USWDS)
* [Yarn](https://yarnpkg.com/)

### MilMove Infra

In addition to the Base Image this contains:

* [Terraform](https://www.terraform.io/) at version 0.12.x
* [terraform-docs](https://github.com/segmentio/terraform-docs)

### MilMove Orders

In addition to the Base Image this contains:

* [golang](https://golang.org/)
