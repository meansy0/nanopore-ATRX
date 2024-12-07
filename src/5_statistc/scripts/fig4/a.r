library(ggplot2)

# 读取数据
data <- read.csv("/public/home/xiayini/project/nanopore_ATRX/0_add_ATAC/2.cleandata/results/merge_repeats_nor.sig.family.merged.csv", header = FALSE, stringsAsFactors = FALSE,sep='\t')
colnames(data) <- c("Feature", "Value")

# 绘制条形图
library(RColorBrewer)
color_scheme <- brewer.pal(n = 8, name = "Dark2")
plt<-ggplot(data, aes(x = reorder(Feature, Value), y = Value, fill = Value)) +
    geom_bar(stat = "identity") +
    scale_fill_gradient2(low = color_scheme[1], high = color_scheme[2], mid = "white", midpoint = 0, space = "Lab", na.value = "grey50") +
    labs(x = "Feature", y = "Value", title = "ATAC-seq Feature Analysis") +
    theme_minimal() +
    theme(legend.position = "none",  # 移除图例
          axis.text.x = element_text(angle = 45, hjust = 1),  # 调整标签角度
          axis.title.x = element_blank())  # 移除x轴标题



save_path="/public/home/xiayini/project/nanopore_ATRX/5_statistc/results/fig4"
ggsave(paste0(save_path,"/a_repeat.svg"), width = 8, height = 6)
