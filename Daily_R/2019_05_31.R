# ** R������ ���� ����
#' R���� �����Լ����� ���� ���� �����ϰų�
#' ���� ������ ���� �����ϰ� ���� ��,
#' get, assign function + parent.frame ���

# ex) vSubs ���� ������ test ���� �Լ����� ���� ��, ȣ���ϰ� ������
# ȣ�� ���� ��쿡�� ����. but python ���� �ٸ��� ������ �Ұ�
# -> parent.frame parameter�� ���� setting

vSubs <- "hello"

test <- function(x){
  # vSubs = get("vSubs", parent.frame(n = 1)) 
  print(vSubs)
  vSubs <- x
  # assign("vSubs", vSubs, parent.frame(n = 1))
}

test("world")
print(vSubs)

# type convert function
# -> ������ �÷��� �ڵ����� �ν��ؼ� ��ġ�� �÷����� �������ִ� function
#    ������ ����!
# but, �������� ��쿡�� �ν��Ѵ�. ��ġ�� �÷��� �־�� �ȵ�
# ������ ���� ���� ���ִ� ���� ����

if(sum(is.na(as.numeric(df[, cc]))) == 0){
  df[, cc] <- type.convert(df[, cc], na.strings = 'NA', as.is = T)
}


# plyr::revalue function
# ����(factor) ������ �������� ���� �����ϴ� �������, plyr ��Ű�� �ȿ� �ִ� revalue() �Լ��� �̿�
#  revalue(���� ������, replace("������" = "���ο� ��"))
smoke = factor(c(1, 2, 1, 1, 2))
levels(smoke)  # ����� : 1, 2

# 1 -> Smoking, 2 -> No Smoking ���� ����
install.packages("plyr")
library(plyr)
smoke = revalue(smoke, replace = c("1" = "Smoking", "2" = "No Smoking"))
levels(smoke)

# step function ���� �̽�
# �⺻������ step �Լ��� ������ ���� ���� �̽��� �����Ѵ�(Ư�� ������ƽ ���� ��)
# stackoverFlow �� 30���� ������ stepwise �ϴµ� 6 �ð� ���� �ɸ��ٰ� �Ǿ� ����.

# kable function
# �����͸� ǥ�������� �����ִ� �Լ�
# dataFrame�� ������, ǥ�������� return







