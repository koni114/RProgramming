# ��ǥ�� T-TEST ����

# input Data
# 1. df
# 2. ��������(��ġ��)
# ���� ���� �����,
# 3 .�ŷڼ��� �Է�
# 4. ����� �Է�
# 5. �븳���� ����(��� < �������, ��� > �������, ��� != �������)

# dplyr�� �̿��� Ư�� ���� Ÿ�� ����
# iris�� �̿��� ����
library(dplyr)
xVar <- names(iris %>% select_if(is.numeric))

# ����� Tip
# ũ�ҿ��� cashe ����� ��� -> F12 -> network -> disabled cashe üũ -> F5 ������ ĳ���� ������ 

# ** foreach �Ϻ� ����
# ����(loop)�� lapply() �Լ��� ������ ������ R�� ����ó���� �־� �ſ� �αⰡ ����
# foreach �Լ��� .combine �Ӽ��� ����� ��� ���ս�ų���� ����
# .combine �Ӽ� ����
# 1. .combine = c : vector 
# 2. .combine = rbind : matrix, cbind : �÷� ���� ����
# 3. .combine = list : list ���·� return

# �ܺο��� ���ǵ� ������ foreach�� ������ ��� ����
# �ܺ� �Լ��� ����ϰ� ������, .export  = "�Լ���" �� ���������ν� ��� ����

# iris -> 4�� ��ġ�� �÷��� ���� ��ǥ�� t-test ��� ���� dataFrame ���·� ����
library(foreach)
numeric.name <- names(iris %>% select_if(is.numeric))
ttt <- unique(iris[,5])

result.table <- data.frame( variable = character(0)
                            , t.value = character(0) 
                            , alternative = character(0)
                            , p.value = character(0)
                            , confidence.level = character(0)
)


ave(iris, iris[,5], FUN =function(x){
  print(x[1,])
})

tt <- foreach(xVar = numeric.name, .combine = function(a,b){dplyr::bind_rows(a,b)}) %do% {
  ave(iris[,xVar], iris[,ttt], FUN = function(x){
    tmp.TTest <- t.test(iris[,xVar]
                        , y = NULL
                        , alternative = c("two.sided")
                        , mu = 0
                        , paired = F
                        , var.equal = F
                        , conf.level = 0.95
    )
    d0 <- data.frame(variable = xVar
                     , t.value = tmp.TTest$statistic
                     , alternative = tmp.TTest$alternative
                     , p.value = tmp.TTest$p.value
                     , confidence.level = paste0("(",tmp.TTest$conf.int[1] , " , ",tmp.TTest$conf.int[2],") ")
                     , stringsAsFactors = F)
    d0
    result.table <- rbind(result.table, tt)
  })
}


