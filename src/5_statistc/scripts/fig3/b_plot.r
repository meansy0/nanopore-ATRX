library(ggplot2)

folder_path <- '/public/home/xiayini/project/nanopore_ATRX/5_statistc/data/s31222_a509_2/fig3/b/newData'
csv_files <- list.files(folder_path, pattern="\\.csv$", full.names=TRUE)
save_path <- '/public/home/xiayini/project/nanopore_ATRX/5_statistc/results/fig3/b/s31222_a509_2/'


# 折线图
# 通过循环处理每个CSV文件
for(file_path in csv_files) {
    # 提取文件名，用于图像保存
    file_name <- basename(file_path)

    # 读取CSV文件，使用制表符作为分隔符
    data <- read.csv(file_path, sep='\t')

    # 如果 sv_name 是从文件名中提取的
    parts <- unlist(strsplit(file_name, "_"))
    start_num <- as.numeric(parts[2])
    end_num <- as.numeric(parts[3])

    # 绘制图表
    plot <- ggplot(data, aes(x=start, y=ratio)) +
        geom_area(fill="lightblue", alpha=0.5) +
        geom_line(color="blue") +
        geom_rect(aes(xmin=start_num, xmax=end_num, ymin=min(data$ratio), ymax=max(data$ratio)),
                  fill=NA, color="red", linetype="dashed") +
        theme_minimal() +
        labs(title='Ratio by Region', x='Start Position', y='Ratio') +
        theme(axis.text.x = element_text(angle = 90, hjust = 1))

    # 保存图表
    ggsave(paste0(save_path, file_name, '.png'), plot, width = 10, height = 8, dpi = 300)
}

# 曲线
for(file_path in csv_files) {
    # 提取文件名，用于图像保存
    file_name <- basename(file_path)

    # 读取CSV文件，使用制表符作为分隔符
    data <- read.csv(file_path, sep='\t')

    # 如果 sv_name 是从文件名中提取的
    parts <- unlist(strsplit(file_name, "_"))
    start_num <- as.numeric(parts[2])
    end_num <- as.numeric(parts[3])

    # 绘制图表
    plot <- ggplot(data, aes(x=start, y=ratio)) +
        geom_area(fill="lightblue", alpha=0.5) +
        geom_smooth(color="blue", method="loess",se = FALSE) +  # 使用平滑曲线
        geom_rect(aes(xmin=start_num, xmax=end_num, ymin=min(data$ratio), ymax=max(data$ratio)),
                  fill=NA, color="red", linetype="dashed") +
        theme_minimal() +
        labs(title='Ratio by Region', x='Start Position', y='Ratio') +
        theme(axis.text.x = element_text(angle = 90, hjust = 1))

    # 保存图表
    ggsave(paste0(save_path, file_name, '.png'), plot, width = 10, height = 8, dpi = 300)
}

