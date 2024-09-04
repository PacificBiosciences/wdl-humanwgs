# Tool versions and Containers

Containers are used to package tools and their dependencies. This ensures that the tools are reproducible and can be run on any system that supports the container runtime.  Our containers are built using [Docker](https://www.docker.com/) and are compatible with any container runtime that supports the OCI Image Specification, like [Singularity](https://sylabs.io/singularity/) or [Podman](https://podman.io/).

Most of our containers are built on the `pb_wdl_base` container, which includes common bioinformatics tools and libraries.  We tag our containers with a version number and build count, but the containers are referenced within the WDL files by the sha256 sum tags for reproducibility and better compatibility with Cromwell and miniwdl call caching.

Our Dockerfiles can be inspected on GitHub, and the containers can be pulled from our [Quay.io organization](https://quay.io/pacbio).

We directly use `deepvariant`, `deepvariant-gpu`, `pharmcat`, and `glnexus` containers from their respective authors, although we have mirrored some for better compatibility with Cromwell call caching.

| Container | Major tool versions | Dockerfile | Container |
| --------: | ------------------- | :---: | :---: |
| pb_wdl_base | <ul><li>htslib 1.20</li><li>bcftools 1.20</li><li>samtools 1.20</li><li>bedtools 2.31.0</li><li>python3.9</li><li>numpy 1.24.24</li><li>pandas 2.0.3</li><li>matplotlib 3.7.5</li><li>seaborn 0.13.2</li><li>pysam 0.22.1</li><li>vcfpy 0.13.8</li><li>biopython 1.83</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/6b13cc246dd44e41903d17a660bb5432cdd18dbe/docker/pb_wdl_base) | [sha256:4b889a1f21a6a7fecf18820613cf610103966a93218de772caba126ab70a8e87](https://quay.io/pacbio/pb_wdl_base/manifest/pb_wdl_base@sha256:4b889a1f21a6a7fecf18820613cf610103966a93218de772caba126ab70a8e87) |
| pbmm2 | <ul><li>pbmm2 1.13.1</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/6b13cc246dd44e41903d17a660bb5432cdd18dbe/docker/pbmm2) | [pbmm2@sha256:265eef770980d93b849d1ddb4a61ac449f15d96981054e91d29da89943084e0e](https://quay.io/pacbio/pbmm2/manifest/sha256:265eef770980d93b849d1ddb4a61ac449f15d96981054e91d29da89943084e0e) |
| mosdepth | <ul><li>mosdepth 0.3.8</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/6b13cc246dd44e41903d17a660bb5432cdd18dbe/docker/mosdepth) | [mosdepth@sha256:f715c11100e9bb3562cce1c5e23a185cfcc92a6fec412b16c30c0250496cc0d1](https://quay.io/pacbio/mosdepth/manifest/sha256:f715c11100e9bb3562cce1c5e23a185cfcc92a6fec412b16c30c0250496cc0d1) |
| pbsv | <ul><li>pbsv 2.9.0</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/6b13cc246dd44e41903d17a660bb5432cdd18dbe/docker/pbsv) | [pbsv@sha256:7626286e07dd185ca698efc80bd0d26cd3a139fe19781dfde5b6d07e895673cd](https://quay.io/pacbio/pbsv/manifest/sha256:7626286e07dd185ca698efc80bd0d26cd3a139fe19781dfde5b6d07e895673cd) |
| trgt | <ul><li>trgt 1.1.1</li><li>`/opt/scripts/check_trgt_coverage.py` 0.1.0</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/21935d9303dc269e817fb87c6a4975ca692dd216/docker/trgt) | [trgt@sha256:d70396273c20d74ea3ca05fc9480f9877d1665fdabd12d68423fab6fec5e0eb7](https://quay.io/pacbio/trgt/manifest/sha256:d70396273c20d74ea3ca05fc9480f9877d1665fdabd12d68423fab6fec5e0eb7) |
| hiphase | <ul><li>hiphase 1.4.4</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/0ab8c2ba1c4fead5eac00d3470e20fd09bef3517/docker/hiphase) | [hiphase@sha256:3c5029aaa38e8a6b0f9b042086691aac3747ccee60045e3e7531ae72059546b2](https://quay.io/pacbio/hiphase/manifest/sha256:3c5029aaa38e8a6b0f9b042086691aac3747ccee60045e3e7531ae72059546b2) |
| hificnv | <ul><li>hificnv 1.0.0</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/6b13cc246dd44e41903d17a660bb5432cdd18dbe/docker/hificnv) | [hificnv@sha256:c9e2d07240299cfff655ae9a96eb604934879128bd7aed9e60af6619f6c36b9a](https://quay.io/pacbio/hificnv/manifest/sha256:c9e2d07240299cfff655ae9a96eb604934879128bd7aed9e60af6619f6c36b9a) |
| paraphase | <ul><li>paraphase 3.1.1</li><li>minimap 2.28</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/6b13cc246dd44e41903d17a660bb5432cdd18dbe/docker/paraphase) | [paraphase@sha256:a114ac5b9a682d7dc0fdf25c92cfb36f80c07ab4f1fb76b2e58092521b123a4d](https://quay.io/pacbio/paraphase/manifest/sha256:a114ac5b9a682d7dc0fdf25c92cfb36f80c07ab4f1fb76b2e58092521b123a4d) |
| pbstarphase | <ul><li>pbstarphase 0.14.1</li><li>Database 20240730</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/12837903ea191a4d1781cbba0894a22f06e4c281/docker/pbstarphase) | [pbstarphase@sha256:69778a63891e741aab72edaa9c2bbebd113cf8d1cfe0fdbcb59d7d7fd5a4eecc](https://quay.io/pacbio/pbstarphase/manifest/sha256:69778a63891e741aab72edaa9c2bbebd113cf8d1cfe0fdbcb59d7d7fd5a4eecc) |
| pb-cpg-tools | <ul><li>pb-cpg-tools 2.3.2</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/6b13cc246dd44e41903d17a660bb5432cdd18dbe/docker/pb-cpg-tools) | [pb-cpg-tools@sha256:d6e63fe3f6855cfe60f573de1ca85fab27f4a68e24a7f5691a7a805a22af292d](https://quay.io/pacbio/pb-cpg-tools/manifest/sha256:d6e63fe3f6855cfe60f573de1ca85fab27f4a68e24a7f5691a7a805a22af292d) |
| wgs_tertiary | <ul><li>`/opt/scripts/calculate_phrank.py` 2.0.0</li><li>`/opt/scripts/json2ped.py` 0.1.0</li></ul>Last built 2021-09-17:<ul><li>ensembl -> HGNC</li><li>ensembl -> HPO</li><li>HGNC -> inheritance</li><li>HPO DAG</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/6b13cc246dd44e41903d17a660bb5432cdd18dbe/docker/wgs_tertiarysha256:8fc134fdf0665e14a67bf7a8b4b63f5ae891a370a1d50c9eec2059702440a3e2) | [wgs_tertiary@sha256:8fc134fdf0665e14a67bf7a8b4b63f5ae891a370a1d50c9eec2059702440a3e2](https://quay.io/pacbio/wgs_tertiary/manifest/sha256:8fc134fdf0665e14a67bf7a8b4b63f5ae891a370a1d50c9eec2059702440a3e2) |
| slivar | <ul><li>slivar 0.3.0</li><li>`/opt/scripts/add_comphet_phase.py` 0.1.0</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/6b13cc246dd44e41903d17a660bb5432cdd18dbe/docker/slivar) | [slivar@sha256:35be557730d3ac9e883f1c2010fb24ac02631922f9b4948b0608d3e643a46e8b](https://quay.io/pacbio/slivar/manifest/sha256:35be557730d3ac9e883f1c2010fb24ac02631922f9b4948b0608d3e643a46e8b) |
| svpack | <ul><li>svpack 54b54db</li></ul> | [Dockerfile](https://github.com/PacificBiosciences/wdl-dockerfiles/tree/6fc750b0c65b4a5c1eb65791eab9eed89864d858/docker/svpack) | [svpack@sha256:628e9851e425ed8044a907d33de04043d1ef02d4d2b2667cf2e9a389bb011eba](https://quay.io/pacbio/svpack/manifest/sha256:628e9851e425ed8044a907d33de04043d1ef02d4d2b2667cf2e9a389bb011eba) |
| deepvariant | <ul><li>DeepVariant 1.6.1</li></ul> |  | [deepvariant:1.6.1](https://hub.docker.com/layers/google/deepvariant/1.6.1/images/sha256-ccab95548e6c3ec28c75232987f31209ff1392027d67732435ce1ba3d0b55c68) |
| deepvariant-gpu | <ul><li>DeepVariant 1.6.1</li></ul> |  | [deepvariant:1.6.1-gpu](https://hub.docker.com/layers/google/deepvariant/1.6.1-gpu/images/sha256-7929c55106d3739daa18d52802913c43af4ca2879db29656056f59005d1d46cb) |
| pharmcat | <ul><li>PharmCat 2.15.0</li></ul> |  | [pharmcat:2.15.0](https://hub.docker.com/layers/pgkb/pharmcat/2.15.0/images/sha256-1484e0f1a3810da3e6be62d8fab83d57ea6e7abeedc58715e1685529bf8f244e) |
| glnexus | <ul><li>GLnexus 1.4.3</li></ul> |  | [glnexus:1.4.3](https://quay.io/pacbio/glnexus/manifest/sha256:ce6fecf59dddc6089a8100b31c29c1e6ed50a0cf123da9f2bc589ee4b0c69c8e) |