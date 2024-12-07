#!/bin/bash				
#SBATCH -J fig3a_1sam
#SBATCH -N 2						
#SBATCH -p normal		
#SBATCH --mem 100g
#SBATCH -o %x.out						## 作业stdout输出文件为: 作业名_作业id.out
#SBATCH -e %x.err						## 作业stderr 输出文件为: 作业名_作业id.err



# sv
computeRateSV(){

    extend_bp=$1
    sv_type=$2
    group_name=$3
    meth_type=$4
    in_sv_bed=/public/home/xiayini/project/nanopore_ATRX/2_vcfV3_analysis/data/joint_multi/difference_${group_name}/${sv_type}.1.read.final.bed
    # for i in {1..24};do
    #     if [ $i -eq 23 ];then
    #         chr=X
    #     elif [ $i -eq 24 ];then
    #         chr=Y
    #     else
    #         chr=$i
    #     fi

    savedata_path=$fig3_path/${extend_bp}_extend_bp/${sv_type}_${meth_type}/
    mkdir -p $savedata_path
    cd $savedata_path
    extend_sv_bed=${meth_type}.sv.extend.bed
    extend_fa=${meth_type}.sv.extend.fa
    cat $in_sv_bed | awk -v "extend=$extend_bp" '{print $1,$2-extend_bp,$3+extend_bp}' |tr ' ' '\t' > $extend_sv_bed
    
    refer_fasta=/public/home/xiayini/reference/chm13v2.0.name.fa
    bedtools getfasta -fi $refer_fasta -bed $extend_sv_bed > $extend_fa
    grep -E "^>" $extend_fa | awk -F'>' '{print $2}' | while read id; do grep -A1 "$id" $extend_fa | tail -n1 | tr -d '\n' | awk -v var="$id" '{c = gsub(/[C]/, ""); c2 = gsub(/[c]/, "");g = gsub(/[G]/, "");g2 = gsub(/[g]/, ""); print var, c + g+c2+g2}' | tr ' ' '\t'| tr ':' '\t'|tr '-' '\t'; done > ${meth_type}.sv_cg_content.txt

    # done
}


methInSv(){
    meth_type=$1
    in_path=/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/${group_name}/three_locations
    new_in_path=/public/home/xiayini/project/nanopore_ATRX/6_filter_meth/data/${group_name}
    fig3_path=/public/home/xiayini/project/nanopore_ATRX/5_statistc/data/${group_name}/fig3
 
    for i in {1..24};do
        if [ $i -eq 23 ];then
            chr=X
        elif [ $i -eq 24 ];then
            chr=Y
        else
            chr=$i
        fi

        #!!!!!!!!!!!!!!edit here!!!!!!!!!!!!!!!!!!!
        # in_bed_file=$in_path/chr${chr}.filter.bed
        if [ $meth_type -eq 1 ] ;then
            in_bed_file=$in_path/chr${chr}.filter.bed
            type_name=all
        elif [ $meth_type -eq 2 ];then
            type_name=growth
            # in_bed_file=$in_path/chr${chr}.0.5.modifis_grow.bed
            in_bed_file=$in_path/chr${chr}.modifis_grow.bed
            # chr1.modifis_grow.txt
            # chr1.filter.bed
        elif [ $meth_type -eq 3 ];then
            type_name=newData
            in_bed_file=$new_in_path/chr${chr}.bed
        else
            echo "error"
        fi

        extend_sv_bed=${type_name}.sv.extend.bed
        
        bedtools intersect -a $extend_sv_bed -b $in_bed_file -wa -wb | sort |uniq >>${type_name}.meth.bed
        meth_in_sv_file=${type_name}.meth_in_sv.bed
        echo "chr svStartsvEnd allCG methStart methEnd" > $meth_in_sv_file
        LC_COLLATE=C sort -k1 ${type_name}.sv_cg_content.txt -o ${type_name}.sv_cg_content.txt
        LC_COLLATE=C sort -k1 ${type_name}.meth.bed -o ${type_name}.meth.bed
        join -1 1 -2 1 ${type_name}.sv_cg_content.txt ${type_name}.meth.bed |  awk '{if($2==$5 && $3==$6) print$0}'| cut -f 1,2,3,4,8,9,10 | tr ' ' '\t' >> $meth_in_sv_file
    done


}





                                            # !!!!!!!!!!edit here!!!!!!!!!!!!!!!!
# group_name=s31222_a509
group_name=a509_s31222



fig3_path=/public/home/xiayini/project/nanopore_ATRX/5_statistc/data/${group_name}/fig3
if [ -e "$fig3_path" ];then
    rm -r $fig3_path
fi  
# type,which means you need all(1)/growth(2) meth


                                            # !!!!!!!!!!edit here!!!!!!!!!!!!!!!!
for type in {1..3};do
# for type in {3,4};do
    echo $type
    if [ $type -eq 1 ] ;then
        me_type=all
    elif [ $type -eq 2 ];then
        me_type=growth
    elif [ $type -eq 3 ];then
        me_type=newData
        
    else
        echo "error"
    fi
    echo "$me_type"
    # $1:extend bp in sv reads,both up and down at a time
    # $2:sv type DEL/INS
    # $3:group number s31222_a509/s31222_a509_2/s31222_a509_3
    # $4:type,which means you need all/growth meth
    for extend in {0,100,200,300,400};do
        for sv_ty in {DEL,INS};do
            echo $sv_ty
            computeRateSV $extend $sv_ty $group_name $me_type

            # $1:type,which means you need all(1)/growth(2) meth
            methInSv $type
        done

    done


done
