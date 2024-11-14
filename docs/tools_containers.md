# Tool versions and Containers

Containers are used to package tools and their dependencies. This ensures that the tools are reproducible and can be run on any system that supports the container runtime.  Our containers are built using [Docker](https://www.docker.com/) and are compatible with any container runtime that supports the OCI Image Specification, like [Singularity](https://sylabs.io/singularity/) or [Podman](https://podman.io/).

Most of our containers are built on the `pb_wdl_base` container, which includes common bioinformatics tools and libraries.  We tag our containers with a version number and build count, but the containers are referenced within the WDL files by the sha256 sum tags for reproducibility and better compatibility with Cromwell and miniwdl call caching.

Our Dockerfiles can be inspected on GitHub, and the containers can be pulled from our [Quay.io organization](https://quay.io/pacbio).

We directly use `deepvariant`, `deepvariant-gpu`, `pharmcat`, and `glnexus` containers from their respective authors, although we have mirrored some for better compatibility with Cromwell call caching.

| Container | Major tool versions | Dockerfile | Container |
| --------: | ------------------- | :---: | :---: |
| pb_wdl_base | <ul><li>htslib 1.20</li><li>bcftools 1.20</li><li>samtools 1.20</li><li>bedtools 2.31.0</li><li>python3.9</li><li>numpy 1.24.24</li><li>pandas 2.0.3</li><li>matplotlib 3.7.5</li><li>seaborn 0.13.2</li><li>pysam 0.22.1</li><li>vcfpy 0.13.8</li><li>biopython 1.83</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/6b13cc246dd44e41903d17a660bb5432cdd18dbe/docker/pb_wdl_base) | [sha256:4b889a1f21a6a7fecf18820613cf610103966a93218de772caba126ab70a8e87](https://quay.io/pacbio/pb_wdl_base/manifest/pb_wdl_base@sha256:4b889a1f21a6a7fecf18820613cf610103966a93218de772caba126ab70a8e87) |
| pbmm2 | <ul><li>pbmm2 1.16.0</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/44df87558e18ce9d3b65f3ede9c7ba1513669ccb/docker/pbmm2) | [pbmm2@sha256:24218cb5cbc68d1fd64db14a9dc38263d3d931c74aca872c998d12ef43020ef0](https://quay.io/pacbio/pbmm2/manifest/sha256:24218cb5cbc68d1fd64db14a9dc38263d3d931c74aca872c998d12ef43020ef0) |
| mosdepth | <ul><li>mosdepth 0.3.9</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/fa84fbf582738c05c750e667ff43d11552ad4183/docker/mosdepth) | [mosdepth@sha256:63f7a5d1a4a17b71e66d755d3301a951e50f6b63777d34dab3ee9e182fd7acb1](https://quay.io/pacbio/mosdepth/manifest/sha256:63f7a5d1a4a17b71e66d755d3301a951e50f6b63777d34dab3ee9e182fd7acb1) |
| pbsv | <ul><li>pbsv 2.10.0</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/e82dddf32b042e985a5d66d0ebe25ca57058e61c/docker/pbsv) | [pbsv@sha256:3a8529853c1e214809dcdaacac0079de70d0c037b41b43bb8ba7c3fc5f783e26](https://quay.io/pacbio/pbsv/manifest/sha256:3a8529853c1e214809dcdaacac0079de70d0c037b41b43bb8ba7c3fc5f783e26) |
| trgt | <ul><li>trgt 1.2.0</li><li>`/opt/scripts/check_trgt_coverage.py` 0.1.0</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/ed658e93fc51229f20415e0784dc242a8e4ef66a/docker/trgt) | [trgt@sha256:0284ff5756f8d47d9d81b515b8b1a6c81fac862ae5a7b4fe89f65235c3e5e0c9](https://quay.io/pacbio/trgt/manifest/sha256:0284ff5756f8d47d9d81b515b8b1a6c81fac862ae5a7b4fe89f65235c3e5e0c9) |
| hiphase | <ul><li>hiphase 1.4.5</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/1051d12818e165a2145526e0b58f0ed0d0dc023a/docker/hiphase) | [hiphase@sha256:47fe7d42aea6b1b2e6d3c7401bc35a184464c3f647473d0525c00f3c968b40ad](https://quay.io/pacbio/hiphase/manifest/sha256:47fe7d42aea6b1b2e6d3c7401bc35a184464c3f647473d0525c00f3c968b40ad) |
| hificnv | <ul><li>hificnv 1.0.1</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/a58f8b44cf8fd09c39c90e07076dbb418188084d/docker/hificnv) | [hificnv@sha256:c4764a70c8c2028edb1cdb4352997269947c5076ddd1aeaeef6c5076c630304d](https://quay.io/pacbio/hificnv/manifest/sha256:c4764a70c8c2028edb1cdb4352997269947c5076ddd1aeaeef6c5076c630304d) |
| paraphase | <ul><li>paraphase 3.1.1</li><li>minimap 2.28</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/6b13cc246dd44e41903d17a660bb5432cdd18dbe/docker/paraphase) | [paraphase@sha256:a114ac5b9a682d7dc0fdf25c92cfb36f80c07ab4f1fb76b2e58092521b123a4d](https://quay.io/pacbio/paraphase/manifest/sha256:a114ac5b9a682d7dc0fdf25c92cfb36f80c07ab4f1fb76b2e58092521b123a4d) |
| pbstarphase | <ul><li>pbstarphase 1.0.0</li><li>Database 20240826</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/813c7dc3143b91c34754d768c3e27a46355bb3e5/docker/pbstarphase) | [pbstarphase@sha256:6954d6f7e462c9cec7aaf7ebb66efaf13d448239aab76a3c947c1dfe24859686](https://quay.io/pacbio/pbstarphase/manifest/sha256:6954d6f7e462c9cec7aaf7ebb66efaf13d448239aab76a3c947c1dfe24859686) |
| pb-cpg-tools | <ul><li>pb-cpg-tools 2.3.2</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/6b13cc246dd44e41903d17a660bb5432cdd18dbe/docker/pb-cpg-tools) | [pb-cpg-tools@sha256:d6e63fe3f6855cfe60f573de1ca85fab27f4a68e24a7f5691a7a805a22af292d](https://quay.io/pacbio/pb-cpg-tools/manifest/sha256:d6e63fe3f6855cfe60f573de1ca85fab27f4a68e24a7f5691a7a805a22af292d) |
| wgs_tertiary | <ul><li>`/opt/scripts/calculate_phrank.py` 2.0.0</li><li>`/opt/scripts/json2ped.py` 0.5.0</li></ul>Last built 2021-09-17:<ul><li>ensembl -> HGNC</li><li>ensembl -> HPO</li><li>HGNC -> inheritance</li><li>HPO DAG</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/fd70e2872bd3c6bb705faff5bc68374116d7d62f/docker/wgs_tertiary) | [wgs_tertiary@sha256:410597030e0c85cf16eb27a877d260e7e2824747f5e8b05566a1aaa729d71136](https://quay.io/pacbio/wgs_tertiary/manifest/sha256:410597030e0c85cf16eb27a877d260e7e2824747f5e8b05566a1aaa729d71136) |
| slivar | <ul><li>slivar 0.3.1</li><li>`/opt/scripts/add_comphet_phase.py` 0.1.0</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/5e1094fd6755203b4971fdac6dcb951bbc098bed/docker/slivar) | [slivar@sha256:35be557730d3ac9e883f1c2010fb24ac02631922f9b4948b0608d3e643a46e8b](https://quay.io/pacbio/slivar/manifest/sha256:35be557730d3ac9e883f1c2010fb24ac02631922f9b4948b0608d3e643a46e8b) |
| svpack | <ul><li>svpack 54b54db</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/6fc750b0c65b4a5c1eb65791eab9eed89864d858/docker/svpack) | [svpack@sha256:628e9851e425ed8044a907d33de04043d1ef02d4d2b2667cf2e9a389bb011eba](https://quay.io/pacbio/svpack/manifest/sha256:628e9851e425ed8044a907d33de04043d1ef02d4d2b2667cf2e9a389bb011eba) |
| deepvariant | <ul><li>DeepVariant 1.6.1</li></ul> |  | [deepvariant:1.6.1](https://hub.docker.com/layers/google/deepvariant/1.6.1/images/sha256-ccab95548e6c3ec28c75232987f31209ff1392027d67732435ce1ba3d0b55c68) |
| deepvariant-gpu | <ul><li>DeepVariant 1.6.1</li></ul> |  | [deepvariant:1.6.1-gpu](https://hub.docker.com/layers/google/deepvariant/1.6.1-gpu/images/sha256-7929c55106d3739daa18d52802913c43af4ca2879db29656056f59005d1d46cb) |
| pharmcat | <ul><li>PharmCat 2.15.4</li></ul> |  | [pharmcat:2.15.4](https://hub.docker.com/layers/pgkb/pharmcat/2.15.4/images/sha256-5b58ae959b4cd85986546c2d67e3596f33097dedc40dfe57dd845b6e78781eb6) |
| glnexus | <ul><li>GLnexus 1.4.3</li></ul> |  | [glnexus:1.4.3](https://quay.io/pacbio/glnexus/manifest/sha256:ce6fecf59dddc6089a8100b31c29c1e6ed50a0cf123da9f2bc589ee4b0c69c8e) |