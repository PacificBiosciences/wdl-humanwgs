version 1.0

import "humanwgs_structs.wdl"
import "wdl-common/wdl/workflows/backend_configuration/backend_configuration.wdl" as BackendConfiguration
import "upstream/upstream.wdl" as Upstream
import "downstream/downstream.wdl" as Downstream
import "wdl-common/wdl/tasks/write_ped_phrank.wdl" as Write_ped_phrank
import "tertiary/tertiary.wdl" as TertiaryAnalysis


workflow humanwgs_singleton {
  meta {
    description: "PacBio HiFi human whole genome sequencing pipeline for individual samples."
  }

  parameter_meta {
    sample_id: {
      name: "Unique identifier for the sample"
    }
    sex: {
      name: "Sample sex",
      choices: ["MALE", "FEMALE", ""]
    }
    hifi_reads: {
      name: "Array of paths to HiFi reads in unaligned BAM format."
    }
    ref_map_file: {
      name: "TSV containing reference genome file paths; must match backend"
    }
    deepvariant_version: {
      name: "DeepVariant version"
    }
    custom_deepvariant_model_tar: {
      name: "Custom DeepVariant model tarball"
    }
    pharmcat_min_coverage: {
      name: "Minimum coverage for PharmCAT"
    }
    phenotypes: {
      name: "Comma-delimited list of HPO codes for phenotypes"
    }
    tertiary_map_file: {
      name: "TSV containing tertiary analysis file paths and thresholds; must match backend"
    }
    gpu: {
      name: "Use GPU when possible"
    }
    backend: {
      name: "Backend where the workflow will be executed",
      choices: ["GCP", "Azure", "AWS-HealthOmics", "HPC"]
    }
    zones: {
      name: "Zones where compute will take place; required if backend is set to 'GCP'"
    }
    gpuType: {
      name: "GPU type to use; required if gpu is set to `true` for cloud backends; must match backend"
    }
    container_registry: {
      name: "Container registry where workflow images are hosted. If left blank, PacBio's public Quay.io registry will be used. Must be set if backend is set to 'AWS-HealthOmics'",
      default: "quay.io/pacbio"
    }
    container_namespace: {
      name: "AWS ECRs have the format REGISTRY/NAMESPACE/CONTAINER. Must be set if backend is set to 'AWS-HealthOmics'"
    }
    preemptible: {
      name: "Where possible, run tasks preemptibly"
    }
  }

  input {
    String sample_id
    String? sex
    Array[File] hifi_reads

    File ref_map_file

    # These options are only intended for testing purposes.
    # There is no guarantee that the pipeline will work with
    # other version of DeepVariant or with custom models.
    String deepvariant_version = "1.6.1"
    File? custom_deepvariant_model_tar

    Int pharmcat_min_coverage = 10

    String? phenotypes
    File? tertiary_map_file

    Boolean gpu = false

    # Backend configuration
    String backend
    String? zones
    String? gpuType
    String? container_registry
    String? container_namespace

    Boolean preemptible = true
  }

  call BackendConfiguration.backend_configuration {
    input:
      backend                 = backend,
      zones                   = zones,
      gpuType                 = gpuType,
      container_registry      = if defined(container_namespace) then select_first([container_registry]) + "/" + select_first([container_namespace]) else container_registry
  }

  RuntimeAttributes default_runtime_attributes = if preemptible then backend_configuration.spot_runtime_attributes else backend_configuration.on_demand_runtime_attributes

  call Upstream.upstream {
    input:
      sample_id                    = sample_id,
      sex                          = sex,
      hifi_reads                   = hifi_reads,
      ref_map_file                 = ref_map_file,
      deepvariant_version          = deepvariant_version,
      custom_deepvariant_model_tar = custom_deepvariant_model_tar,
      single_sample                = true,
      gpu                          = gpu,
      default_runtime_attributes   = default_runtime_attributes
  }

  call Downstream.downstream {
    input:
      sample_id                  = sample_id,
      small_variant_vcf          = upstream.small_variant_vcf,
      small_variant_vcf_index    = upstream.small_variant_vcf_index,
      sv_vcf                     = select_first([upstream.sv_vcf]),
      sv_vcf_index               = select_first([upstream.sv_vcf_index]),
      trgt_vcf                   = upstream.trgt_vcf,
      trgt_vcf_index             = upstream.trgt_vcf_index,
      aligned_bam                = upstream.out_bam,
      aligned_bam_index          = upstream.out_bam_index,
      pharmcat_min_coverage      = pharmcat_min_coverage,
      ref_map_file               = ref_map_file,
      default_runtime_attributes = default_runtime_attributes
  }

  if (defined(phenotypes) && defined(tertiary_map_file)) {
    call Write_ped_phrank.write_ped_phrank {
      input:
        id                 = sample_id,
        sex                = select_first([sex, upstream.inferred_sex]),
        phenotypes         = select_first([phenotypes]),
        runtime_attributes = default_runtime_attributes
    }

    call TertiaryAnalysis.tertiary_analysis {
      input:
        pedigree                   = write_ped_phrank.pedigree,
        phrank_lookup              = write_ped_phrank.phrank_lookup,
        small_variant_vcf          = downstream.phased_small_variant_vcf,
        small_variant_vcf_index    = downstream.phased_small_variant_vcf_index,
        sv_vcf                     = downstream.phased_sv_vcf,
        sv_vcf_index               = downstream.phased_sv_vcf_index,
        ref_map_file               = ref_map_file,
        tertiary_map_file          = select_first([tertiary_map_file]),
        default_runtime_attributes = default_runtime_attributes
    }
  }

  output {
    # bam stats
    File   bam_stats                = upstream.read_length_and_quality
    File   read_length_histogram    = upstream.read_length_histogram
    File   read_quality_histogram   = upstream.read_quality_histogram
    File   read_length_plot         = upstream.read_length_plot
    File   read_quality_plot        = upstream.read_quality_plot
    String stat_num_reads           = upstream.stat_num_reads
    String stat_read_length_mean    = upstream.stat_read_length_mean
    String stat_read_length_median  = upstream.stat_read_length_median
    String stat_read_quality_mean   = upstream.stat_read_quality_mean
    String stat_read_quality_median = upstream.stat_read_quality_median

    # merged, haplotagged alignments
    File   merged_haplotagged_bam       = downstream.merged_haplotagged_bam
    File   merged_haplotagged_bam_index = downstream.merged_haplotagged_bam_index
    String stat_mapped_fraction         = downstream.stat_mapped_fraction

    # mosdepth outputs
    File   mosdepth_summary    = upstream.mosdepth_summary
    File   mosdepth_region_bed = upstream.mosdepth_region_bed
    String inferred_sex        = upstream.inferred_sex
    String stat_mean_depth     = upstream.stat_mean_depth

    # phasing stats
    File   phase_stats           = downstream.phase_stats
    File   phase_blocks          = downstream.phase_blocks
    File   phase_haplotags       = downstream.phase_haplotags
    String stat_phased_basepairs = downstream.stat_phased_basepairs
    String stat_phase_block_ng50 = downstream.stat_phase_block_ng50

    # cpg_pileup outputs
    File   cpg_combined_bed        = downstream.cpg_combined_bed
    File   cpg_hap1_bed            = downstream.cpg_hap1_bed
    File   cpg_hap2_bed            = downstream.cpg_hap2_bed
    File   cpg_combined_bw         = downstream.cpg_combined_bw
    File   cpg_hap1_bw             = downstream.cpg_hap1_bw
    File   cpg_hap2_bw             = downstream.cpg_hap2_bw
    String stat_hap1_cpg_count     = downstream.stat_hap1_cpg_count
    String stat_hap2_cpg_count     = downstream.stat_hap2_cpg_count
    String stat_combined_cpg_count = downstream.stat_combined_cpg_count

    # sv outputs
    File phased_sv_vcf       = downstream.phased_sv_vcf
    File phased_sv_vcf_index = downstream.phased_sv_vcf_index

    # sv stats
    String stat_sv_DUP_count = downstream.stat_sv_DUP_count
    String stat_sv_DEL_count = downstream.stat_sv_DEL_count
    String stat_sv_INS_count = downstream.stat_sv_INS_count
    String stat_sv_INV_count = downstream.stat_sv_INV_count
    String stat_sv_BND_count = downstream.stat_sv_BND_count

    # small variant outputs
    File phased_small_variant_vcf       = downstream.phased_small_variant_vcf
    File phased_small_variant_vcf_index = downstream.phased_small_variant_vcf_index
    File small_variant_gvcf             = upstream.small_variant_gvcf
    File small_variant_gvcf_index       = upstream.small_variant_gvcf_index

    # small variant stats
    File   small_variant_stats = downstream.small_variant_stats
    File   bcftools_roh_out    = downstream.bcftools_roh_out
    File   bcftools_roh_bed    = downstream.bcftools_roh_bed
    String stat_SNV_count      = downstream.stat_SNV_count
    String stat_INDEL_count    = downstream.stat_INDEL_count
    String stat_TSTV_ratio     = downstream.stat_TSTV_ratio
    String stat_HETHOM_ratio   = downstream.stat_HETHOM_ratio

    # trgt outputs
    File   phased_trgt_vcf           = downstream.phased_trgt_vcf
    File   phased_trgt_vcf_index     = downstream.phased_trgt_vcf_index
    File   trgt_spanning_reads       = upstream.trgt_spanning_reads
    File   trgt_spanning_reads_index = upstream.trgt_spanning_reads_index
    File   trgt_coverage_dropouts    = upstream.trgt_coverage_dropouts
    String stat_trgt_genotyped_count = upstream.stat_trgt_genotyped_count
    String stat_trgt_uncalled_count  = upstream.stat_trgt_uncalled_count

    # paraphase outputs
    File  paraphase_output_json         = upstream.paraphase_output_json
    File  paraphase_realigned_bam       = upstream.paraphase_realigned_bam
    File  paraphase_realigned_bam_index = upstream.paraphase_realigned_bam_index
    File? paraphase_vcfs                = upstream.paraphase_vcfs

    # per sample cnv outputs
    File cnv_vcf              = upstream.cnv_vcf
    File cnv_vcf_index        = upstream.cnv_vcf_index
    File cnv_copynum_bedgraph = upstream.cnv_copynum_bedgraph
    File cnv_depth_bw         = upstream.cnv_depth_bw
    File cnv_maf_bw           = upstream.cnv_maf_bw
    String stat_cnv_DUP_count = upstream.stat_cnv_DUP_count
    String stat_cnv_DEL_count = upstream.stat_cnv_DEL_count
    String stat_cnv_DUP_sum   = upstream.stat_cnv_DUP_sum
    String stat_cnv_DEL_sum   = upstream.stat_cnv_DEL_sum

    # PGx outputs
    File  pbstarphase_json                   = downstream.pbstarphase_json
    File? pharmcat_missing_pgx_vcf           = downstream.pharmcat_missing_pgx_vcf
    File  pharmcat_preprocessed_filtered_vcf = downstream.pharmcat_preprocessed_filtered_vcf
    File  pharmcat_match_json                = downstream.pharmcat_match_json
    File  pharmcat_phenotype_json            = downstream.pharmcat_phenotype_json
    File  pharmcat_report_html               = downstream.pharmcat_report_html
    File  pharmcat_report_json               = downstream.pharmcat_report_json

    # tertiary analysis outputs
    File? filtered_small_variant_vcf           = tertiary_analysis.filtered_small_variant_vcf
    File? filtered_small_variant_vcf_index     = tertiary_analysis.filtered_small_variant_vcf_index
    File? filtered_small_variant_tsv           = tertiary_analysis.filtered_small_variant_tsv
    File? compound_het_small_variant_vcf       = tertiary_analysis.compound_het_small_variant_vcf
    File? compound_het_small_variant_vcf_index = tertiary_analysis.compound_het_small_variant_vcf_index
    File? compound_het_small_variant_tsv       = tertiary_analysis.compound_het_small_variant_tsv
    File? filtered_svpack_vcf                  = tertiary_analysis.filtered_svpack_vcf
    File? filtered_svpack_vcf_index            = tertiary_analysis.filtered_svpack_vcf_index
    File? filtered_svpack_tsv                  = tertiary_analysis.filtered_svpack_tsv
  }
}