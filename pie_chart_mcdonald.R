top <- read.csv("visualisation/my project/Dataset/")
site.freq <- table(sn$Country)
barplot(site.freq)


top <- read.csv("statistic_id792751_leading-foodservice-groups-in-europe-2017-based-on-sales.csv")
require("RColorBrewer")
pie(top$Sales.billion., labels = top$Group, main ="Leading food service group sales", col =brewer.pal(length(top$Group),'Spectral'))
legend("topleft",legend = top$Group,fill = brewer.pal(length(top$Group),'Spectral'))


