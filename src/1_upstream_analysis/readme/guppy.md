# data说明
## 测序
+ nanopore 
  + 测序平台：PromethION48
  + 芯片：R9.4.1

# guppy
## usage
+ reference：https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8524990/
```bash
singularity exec --nv $guppy guppy_basecaller  \
--input_path $input_files --save_path $output_path --align_ref $genome/dna.fa \
--align_type auto --bam_out --config $config --model_file $model --device cuda:0 --disable_qscore_filtering 
``
  + 说明：直接在basecall的时候加入参考基因组，可以在最后的bam文件里获得甲基化的信息
  + 需要下载最新版本的samtools，不然会存在问题
  + 可以将bam文件处理为pileup文件，甲基化信息会包含在其中
  