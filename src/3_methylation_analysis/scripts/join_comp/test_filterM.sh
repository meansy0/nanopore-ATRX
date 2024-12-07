# #!/bin/bash
# meth_file="$1"
# # out_file="$2"
# perl -lane '
#     if ($F[2] eq "c" or $F[2] eq "C") {
#         my @counts = $F[4] =~ m/\.\[\+m(\d+)/g;
#         my $valid_counts = grep { $_ >= 128 } @counts;
#         $meth = $valid_counts / $F[3];
#         print "$F[0] $F[1] $F[2] $meth $F[6]";
#     } elsif ($F[2] eq "g" or $F[2] eq "G") {
#         my @counts = $F[4] =~ m/,\[\+m(\d+)/g;
#         my $valid_counts = grep { $_ >= 128 } @counts;
#         $meth = $valid_counts / $F[3];
#         print "$F[0] $F[1] $F[2] $meth $F[6]";
#     }
# ' "$meth_file" | tr ' ' '\t' |less

#!/bin/bash
meth_file="$1"
# out_file="$2"

# 提取所有 [m*] 格式的数字，并判断是否大于等于 128
counts=$(grep -o '\[+m[0-9]*\]' "$meth_file" | sed 's/\[+m//g' | awk '$1 >= 128 {count++} END {print count}')

# 统计所有 [m*] 格式的数字
total_counts=$(grep -o '\[+m[0-9]*\]' "$meth_file" | sed 's/\[+m//g' | wc -l)

# 计算比率
ratio=$(echo "scale=3; $counts / $total_counts" | bc)

# 输出结果
echo "Ratio: $ratio"

