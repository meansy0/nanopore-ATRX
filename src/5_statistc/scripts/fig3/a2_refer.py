import subprocess


def main():
    cg_bed_file='/public/home/xiayini/reference/chm12v2.0/cg_chr/chr2.c.g.bed'
    full_command = f" wc -l {cg_bed_file}"
    results=subprocess.run(full_command, check=True, shell=True,capture_output=True)
    length = int(results.stdout.split()[0])
    print(length)

    meth_bed='/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/s31222_a509_2/three_locations/chr1.filter.bed'
    
    full_command = f" wc -l {meth_bed}"
    results2=subprocess.run(full_command, check=True, shell=True,capture_output=True)
    length2 = int(results2.stdout.split()[0])  
    print(f"{length2/length:.2f}")  
    
if __name__=='__main__':
    main()
    