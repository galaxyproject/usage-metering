Artifacts used for benchmarking. This includes historic usage data, input
datasets for benchmarking, and workflows to automate the benchmarking steps.

# Input datasets

A list of datasets used for benchmarking. The human datasets were selected from
the [Genome in a Bottle](https://www.nist.gov/programs-projects/genome-bottle)
project.

## DNA Datasets

| dbkey      | Accession/source                                           | Galaxy history                                                                 | Forward reads                                                                                          | Size (GB) | Reverse reads                                                                                          | Size (GB) |
|------------|------------------------------------------------------------|--------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|-----------|--------------------------------------------------------------------------------------------------------|-----------|
| hg38/CHM13 | [SRR12898325](https://www.ncbi.nlm.nih.gov/sra/SRX9363363) | [usegalaxy.org](https://usegalaxy.org/u/eafgan/h/benchmarking-input-human-30x) | [download](https://benchmarking-inputs.s3.amazonaws.com/SRR12898325/NextSeq_LAB02_Son3_REP01-R1.fq.gz) | 16.7      | [download](https://benchmarking-inputs.s3.amazonaws.com/SRR12898325/NextSeq_LAB02_Son3_REP01-R2.fq.gz) | 17.5      |

## Reference indices

A list of organism reference indices used as input for tools that use them.

The use of appropriate reference has been pre-set in the benchmarking workflows
listed below.

| Species name | Latin name                  | db key  | Sequence file size                                                                              | Bowtie2                                                                                                                  | BWA-MEM                                                                                                                  | HISAT2                                                                                                                     | minimap2 |
|--------------|-----------------------------|---------|-------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|----------|
| Chicken      | Gallus gallus               | galGal4 | [1GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/galGal4/seq/)          | [1.4GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/managed/bowtie2_index/galGal4/)                      | [1.8GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/managed/bwa_mem_index/galGal4/)                      | [1.6GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/managed/hisat2_index/galGal4/)                         | ✔️        |
| Human        | Homo sapiens                | hg38    | [3.3GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/hg38/seq/)           | [4.1GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/hg38/hg38full/bowtie2_index/)                 | [5.3GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/hg38/hg38full/bwa_index_v0.7.10-r789/)        | [4.2GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/managed/hisat2_index/hg38/)                            | ✔️        |
| Human        | Homo sapiens                | CHM13   | [3.2GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/CHM13_T2T_v2.0/seq/) | [4.2GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/CHM13_T2T_v2.0/bowtie2_index/CHM13_T2T_v2.0/) | [5.1GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/CHM13_T2T_v2.0/bwa_mem_index/CHM13_T2T_v2.0/) | [4.5GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/CHM13_T2T_v2.0/hisat2_index/CHM13_T2T_v2.0/)ª   | ✔️        |
| Locust       | Schistocerca cancellata     | N/A     | [8.4GB](https://galaxy-benchmark-data.s3.amazonaws.com/locust.fasta)                            |  N/A; use history dataset                                                                                                | N/A; use history dataset                                                                                                 | N/A; use history dataset                                                                                                   | N/A; use history dataset |

ª Not available on usegalaxy.org

# Workflows

A list of workflows used for benchmarking.

| Name                  | Live link                                                                           | .ga file link                                                                                               |
|-----------------------|-------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| DNA mappers: hg38     | [usegalaxy.org](https://usegalaxy.org/u/eafgan/w/benchmarking-dna-mappers-hg38)     | [dna-mappers-hg38.ga](https://benchmarking-inputs.s3.amazonaws.com/benchmarking-dna-mappers-pe-hg38.ga)     |
| DNA mappers: CHM13    | N/A                                                                                 | [dna-mappers-chm13.ga](https://benchmarking-inputs.s3.amazonaws.com/benchmarking-dna-mappers-pe-chm13.ga)   |
