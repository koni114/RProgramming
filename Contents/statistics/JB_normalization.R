# 2019_06_05, HJH
# ����ȭ ��ȯ Study
# -> ������, �α�, ������, Box-Cox
# ��л� ����
# levene, barlett, F-test

# 1. ������ ��ȯ
# �������� ������ ���� ���, -> ������ ��ȯ ex) x^2, x^3
install.packages("UsingR")
install.packages("cluster")
library(UsingR)
library(Hmisc)
library(dplyr)

data(cfb)
summary(cfb$INCOME)
str(cfb)

hist(cfb$EDUC, breaks=500, freq=TRUE)                  # �׷��� ��ü�� �������� ���� ġ������ ����
cfb <- cfb %>% mutate(INCOME_POW = (INCOME**2))        # �������� + �Ļ����� ����
hist(cfb$INCOME_POW, breaks=500, freq=TRUE)   

# 2. �α� ��ȯ
# 
# ���� 0�� ���� �� ���� �߻� -> ��� �� ���ΰ�
# log�� ������ ū ���� ���� ������ ���� ���� �ٲ� �ִ� ���̴�.

# �� �� 0���� �۰ų� ���� ���� ���� ��� log ��ȯ�� �Ұ��ؾ� �ϴ°�?
# �ƴϸ� �ּ� ���� + ���־ ��� ���־�� �ϴ°�?
# ���� �Է� �ް� �� ���ΰ�? 
# �� ������ ���� ��ȯ�� �ʿ��� ���, �Ļ����� ������Ʈ �̿�
# -> ����� ���ְų�, +(-ũ�⸸ŭ +���־ ���)

hist(cfb$INCOME, breaks=500, freq=TRUE)                  # �׷��� ��ü�� �������� ���� ġ������ ����
cfb <- cfb %>% mutate(INCOME_LOG =log(INCOME+1, exp(1))) # �������� + �Ļ����� ����

cfb <- cfb %>% mutate(INCOME_LOG =log(INCOME+1, -10)) 
hist(cfb$INCOME_LOG, breaks=500, freq=TRUE)    

# 3. ������, �������� ��ȯ
# ���������� ū ���� �� �۰� ������ִ� ȿ���� ����

hist(cfb$INCOME, breaks=500, freq=TRUE)                    # �׷��� ��ü�� �������� ���� ġ������ ����
cfb <- cfb %>% mutate(INCOME_SQRT = (INCOME**(1/2)))       # �������� + �Ļ����� ����
hist(cfb$INCOME_SQRT, breaks=500, freq=TRUE)    

# 4. Box-cox ��ȯ
# ���Ժ����� �ƴ� �ڷḦ ���Ժ����� ��ȯ�ϱ� ���Ͽ� ���
# y(����) = y^(����) - 1 / ����
# �������� ���� ���� �õ��Ͽ� ���� ���Լ��� �����ִ� ���� ã�Ƽ� ���
library(caret)
hist(cfb$INCOME, breaks=500, freq=TRUE)                    # �׷��� ��ü�� �������� ���� ġ������ ����
test <- caret::BoxCoxTrans(cfb$INCOME)
z    <- predict(test, cfb$INCOME)

# Box-Cox ��ȯ example
data(BloodBrain)
ratio <- exp(logBBB)
hist(ratio, breaks=500, freq=TRUE)      
bc <- BoxCoxTrans(ratio)
bc$lambda
predict(bc, ratio)
hist(predict(bc, ratio), breaks=500, freq=TRUE)  

# tip function
# �ΰ������� ���� tryCatch���� �˾Ƽ� �� ���غ���
# tryCatch function
tryCatch({
  
}, error = function(err){print(err)})