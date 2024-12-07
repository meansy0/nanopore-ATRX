from a_sv_gcCount import read_fasta

def calculate_gc_content(sequence):
    gc_count = sum(1 for base in sequence if base in ['G', 'C','g','c'])
    return gc_count/len(sequence)*100 if sequence else 0

def main():
    refer_gasta='/public/home/xiayini/reference/chm13v2.0.name.fa'
    sequences=read_fasta(refer_gasta)
    for name, seq in sequences.items():
        gc_content = calculate_gc_content(seq)
        print(f"{name}: GC含量 = {gc_content:.2f}%")

if __name__=='__main__':
    main()