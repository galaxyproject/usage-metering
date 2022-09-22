Artifacts used for benchmarking. This includes historic usage data, input
datasets for benchmarking, and workflows to automate the benchmarking steps.

# Input datasets

A list of datasets used for benchmarking. For consistency, all the datasets
chosen were generated using the same technology and came from the same
organization, namely using Illumina NovaSeq 6000, single read layout, published
mid-2022 by the Stanford School Of Medicine. All the datasets come from human
samples.

## DNA Datasets

| File size | Accession/source                                          | Galaxy history                                                            | Bucket                                                                                     |
|-----------|-----------------------------------------------------------|---------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
| 1GB       | [ERR9856796](https://www.ncbi.nlm.nih.gov/sra/ERX9401874) | [usegalaxy.org](https://usegalaxy.org/u/eafgan/h/1gb-benchmarking-input)  | [Download](https://js2.jetstream-cloud.org:8001/swift/v1/testing-data/ERR9856796.fastq.gz) |
| 6GB       | [ERR9856694](https://www.ncbi.nlm.nih.gov/sra/ERX9401781) | [usegalaxy.org](https://usegalaxy.org/u/eafgan/h/6gb-benchmarking-input)  | [Download](https://galaxy-benchmark-data.s3.amazonaws.com/ERR9856694.fastq.gz)             |
| 12GB      | [ERR9856489](https://www.ncbi.nlm.nih.gov/sra/ERX9401697) | [usegalaxy.org](https://usegalaxy.org/u/eafgan/h/12gb-benchmarking-input) | [Download](https://galaxy-benchmark-data.s3.amazonaws.com/ERR9856489.fastq.gz)             |

## Reference indices

A list of organism reference indices used as input for tools that use them. The
canonical reference is human, specifically *hg38*. Additional references were
selected primarily based on their file size to benchmark the impact this input
has on tool performance and resource requirements.

The use of appropriate reference has been pre-set in the benchmarking workflows
listed below.

| Species name | Latin name                  | db key  | Sequence file size                                                                              | Bowtie2                                                                                                                  | BWA-MEM                                                                                                                  | HISAT2                                                                                                                     | minimap2 |
|--------------|-----------------------------|---------|-------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|----------|
| Chicken      | Gallus gallus               | galGal4 | [1GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/galGal4/seq/)          | [1.4GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/managed/bowtie2_index/galGal4/)                      | [1.8GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/managed/bwa_mem_index/galGal4/)                      | [1.6GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/managed/hisat2_index/galGal4/)                         | ✔️        |
| Human        | Homo sapiens                | hg38    | [3.3GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/hg38/seq/)           | [4.1GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/hg38/hg38full/bowtie2_index/)                 | [5.3GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/hg38/hg38full/bwa_index_v0.7.10-r789/)        | [4.2GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/managed/hisat2_index/hg38/)                            | ✔️        |
| Human        | Homo sapiens                | CHM13   | [3.2GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/CHM13_T2T_v2.0/seq/) | [4.2GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/CHM13_T2T_v2.0/bowtie2_index/CHM13_T2T_v2.0/) | [5.1GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/CHM13_T2T_v2.0/bwa_mem_index/CHM13_T2T_v2.0/) | [4.5GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/CHM13_T2T_v2.0/hisat2_index/CHM13_T2T_v2.0/)ª | ✔️        |
| Elephant     | Loxodonta africana africana | loxAfr3 | [3.3GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/byhand/loxAfr3/seq/)        | [4.2GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/managed/bowtie2_index/loxAfr3/)                      | [5.3GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/managed/bwa_mem_index/loxAfr3/)                      | [4.3GB](http://openbiorefdata.org/#galaxy/v1/data.galaxyproject.org/managed/hisat2_index/loxAfr3/)                         | ✔️        |

ª Not available on usegalaxy.org

# Workflows

A list of workflows used for benchmarking.

| Name                  | Live link                                                                           | .ga file link                                                                                               |
|-----------------------|-------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------|
| DNA mappers: chicken  | [usegalaxy.org](https://usegalaxy.org/u/eafgan/w/benchmarking-dna-mappers-chicken)  | [dna-mappers-chicken.ga](https://galaxy-benchmark-data.s3.amazonaws.com/workflows/dna-mappers-chicken.ga)   |
| DNA mappers: hg38     | [usegalaxy.org](https://usegalaxy.org/u/eafgan/w/benchmarking-dna-mappers-hg38)     | [dna-mappers-hg38.ga](https://galaxy-benchmark-data.s3.amazonaws.com/workflows/dna-mappers-hg38.ga)         |
| DNA mappers: CHM13    | [usegalaxy.org](https://usegalaxy.org/u/eafgan/w/benchmarking-dna-mappers-chm13)    | [dna-mappers-chm13.ga](https://galaxy-benchmark-data.s3.amazonaws.com/workflows/dna-mappers-chm13.ga)       |
| DNA mappers: elephant | [usegalaxy.org](https://usegalaxy.org/u/eafgan/w/benchmarking-dna-mappers-elephant) | [dna-mappers-elephant.ga](https://galaxy-benchmark-data.s3.amazonaws.com/workflows/dna-mappers-elephant.ga) |
