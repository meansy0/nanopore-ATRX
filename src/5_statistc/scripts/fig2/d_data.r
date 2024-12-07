
# 需要修改 分母应该是c total，现在用的atcg total
# 加载所需的库
library(ggplot2)

# 读取数据
group_num="s31222_a509"
setwd(paste0("/public/home/xiayini/project/nanopore_ATRX/3_1_methylation_analysis/results/filter2Reads/",group_num,"/","three_locations/"))

data <- read.table("chr1.demo.filter.txt", header=FALSE, sep="\t", fileEncoding="UTF-8")

# 计算直方图的bin频率
bin_width <- 1 # 可以根据需要调整这个值
hist_data <- hist(data$V2, plot = FALSE, breaks = seq(min(data$V2), max(data$V2), by = bin_width))

# 识别符合条件的区段
dense_regions <- data.frame(start = numeric(), end = numeric(), methyl_ratio = numeric())
min_length <- 50 # 最小区段长度为50bp
for (i in 1:length(hist_data$breaks) - 1) {
    segment_start <- hist_data$breaks[i]
    segment_end <- hist_data$breaks[i+1]
    segment_length <- segment_end - segment_start
    if (segment_length >= min_length) {
        # 假设第三列表示甲基化状态，1表示甲基化，0表示非甲基化
        methyl_count <- sum(data[data$V2 >= segment_start & data$V2 < segment_end, 3])
        methyl_ratio <- methyl_count / segment_length
        if (methyl_ratio >= 0.5) {
            dense_regions <- rbind(dense_regions, c(segment_start, segment_end, methyl_ratio))
        }
    }
}
colnames(dense_regions) <- c("Start", "End", "Methyl_Ratio")

# 输出结果
save_path=paste0("/public/home/xiayini/project/nanopore_ATRX/5_statistc/results/fig2/data/",group_num,"/D_")
write.table(dense_regions, file = paste0(save_path,"methyl_dense_regions.txt"), row.names = FALSE, col.names = TRUE, sep = "\t")

# 输出到控制台
print(dense_regions)
