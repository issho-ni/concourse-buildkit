# concourse-buildkit

[![Build Status](https://ci.issho-ni.co/api/v1/teams/main/pipelines/concourse-buildkit/badge)](https://ci.issho-ni.co/main/pipelines/concourse-buildkit)

Use [BuildKit][] to build OCI-compliant tarballs in Concourse, with support
for exporting and importing build caches as Concourse inputs, outputs, and
caches.

## Why

Because [img][] (and therefore the official [builder-task][]) doesn't support
cache loading. This uses BuildKit directly, which does allow for exporting
and importing build caches.

## Task Config

### `image`

Set the task image to `issho/concourse-buildkit`, either as an
`image_resource` or pulled as a [registry-image][] resource and loaded with
`image`.

### `params`

#### `$REPOSITORY`

**Required.** Repository to use in naming the built image, e.g.
`issho/concourse-buildkit`.

#### `$BUILD_ARGS_*`

_Optional._ Any environment variables beginning with `$BUILD_ARG_` will be
passed into BuildKit as build arguments with the prefix removed, e.g.
`BUILD_ARG_FOO=bar` becomes `FOO=bar`.

#### `$BUILD_ARGS_FILE`

_Optional._ An environment file whose values to pass into BuildKit as build
arguments.

#### `$BUILDCTL_OPTS`

_Optional._ Additional arguments to pass to the `buildctl` command.

#### `$CACHE_INPUT_DIR`

_Optional._ Directory passed as an `input` to the task from which to load a
cache image. If the directory contains an OCI-compliant tarball named
`image.py`, it will be extracted.

#### `$CACHE_MODE`

_Optional,_ default: `min`. BuildKit cache mode to use, either `min` (only
caches the layers used in the resulting image) or `max` (caches all
intermediate layers).

#### `$CACHE_REGISTRY_REF`

_Optional._ Repository to use in naming the cache, which can be packaged as
an OCI-compliant tarball and uploaded to a registy.

#### `$CONTEXT`

_Optional,_ default: `.`. Location of the build context for the image.

#### `$DOCKERFILE`

_Optional,_ default: `.`. Location (path or file) of the `Dockerfile` to
build from.

#### `$OUTPUT_TYPE`

_Optional,_ default: `docker`. Image output type, defaulting to `docker` for
use with `docker load` or pushing to Docker Hub or Hub-compatible registries.
Set to `none` to skip creating an output image.

#### `$TAG`

_Optional,_ default: `latest`. Tag name to use for the resulting image.

#### `$TAG_FILE`

_Optional._ A file containing the value to use in tagging the resulting
image.

#### `$TARGET`

_Optional._ For a multi-stage `Dockerfile`, the stage to target for build and
output.

#### `$TARGET_FILE`

_Optional._ For a multi-stage `Dockerfile`, a file containing the name of the
stage to target for build and output.

### `inputs`

There are no required inputs, other than an input containing a `Dockerfile`
and build context, with the `$CONTEXT` parameter set to the name of the
input.

If `$CACHE_INPUT_DIR` is specified and matches the name of an input, its
contents will be loaded as a build cache by BuildKit before attempting to
build the image.

### `outputs`

If an `image` output is specified, the image tarball will be written to
`image/image.tar`. This tarball can be used with `docker load` or uploaded to
a registry with [registry-image][].

If a `cache` output is specified, the cache will be written into the `cache`
directory. A tarball created from the contents of this directory will be an
OCI-compliant image tarball.

### `caches`

If a `cache` cache is specified, the build cache will be cached for the job
on the worker that runs the job.

### `run`

Your task should execute the `build` script.

## Credits

Copyright © 2019 [Issho Ni][]. Licensed under the terms of the [Apache
License version 2.0](LICENSE). Heavily inspired by [builder-task][], [img][],
and (of course) [buildkit][].

[builder-task]: https://github.com/concourse/builder-task
[buildkit]: https://github.com/moby/buildkit
[img]: https://github.com/genuinetools/img
[issho ni]: https://issho-ni.co
[registry-image]: https://github.com/concourse/registry-image-resource
