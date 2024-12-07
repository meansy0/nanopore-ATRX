

setwd("/public/home/xiayini/project/nanopore_ATRX/5_statistc/results/fig2/")
# group_name="s31222_a509_3"
# sam_na="ATRX-P16"
group_name="a509_s31222"
sam_na="Control-P0"
# Load necessary libraries
library(ggplot2)
library(readr)
library(tidyverse)
library(dplyr)

# Load the data
df <- read_csv(paste0("data/",group_name,"/0.5.chrMeth.growth.loss.csv"), show_col_types = FALSE)

# Perform the paired t-test
t_test_result <- t.test(df$Growth, df$Loss, paired = TRUE)

# Print the t-test result
print(t_test_result)

# Reshape data for plotting
df_long <- pivot_longer(df, cols = c(Growth, Loss), names_to = "Type", values_to = "Count")

# Improved plot aesthetics
plt<-ggplot(df_long, aes(x = Chromosome, y = Count, fill = Type)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  scale_fill_brewer(palette = "Dark2") + # A more sophisticated color palette
  theme_minimal(base_size = 14) + # Increase the base font size for readability
  theme(
    plot.title = element_text(face = "bold", size = 16),
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
    axis.title = element_text(size = 14),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12)
  ) +
  labs(
    title = paste0(" Methylation Numbers in ",sam_na),
    x = "Chromosome",
    y = "Number of Methyltion"
  )
plt
ggsave(paste0("B_",group_name,"_growth_loss.svg"), plot = plt, width = 6, height = 4)
