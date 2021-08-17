# docker-gh

This particular example creates a docker image built off of CircleCI's most basic convenience image [`cimg/base`](https://hub.docker.com/r/cimg/base) with the following tools installed on top:

- AWS CLI
- CircleCI CLI
- ShellCheck
- Github CLI

## Developer Setup

```sh
brew install pre-commit docker
```
