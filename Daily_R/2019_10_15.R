## 2019-10-15.R
## ���� ������ ������ rename�� �����ϴ� ���.
#  match function + colnames function ����.
library(dplyr)

var1 <- colnames(iris)[c(5,4,3)] 
var2 <- c('c', 'd', 'e')
colnames(iris)[match(var1, colnames(iris), nomatch = 0)] <- var2
