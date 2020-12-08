# 2019_07_04
# lubricate package :: parse_date_time function
# �ƹ����� �� �Է��ϴ� ��¥���� ���ڰ� ���� �� �� �ִ� ���
# -> � �������� Date format�� ������, ex) 2019-03-05, 201903-05, 2019/03/05 ..
#    ��¥ ������ �ƴ����� ������(ex) 2019-33-33) �ڵ����� Date format���� �������ִ� �Լ�

# gsub �Լ��� �����ؼ� ����ϸ� combo ~
library(lubridate)

FromDate <- "2019-04_01"

if(!is.na(FromDate)){
  if(is.na(parse_date_time(FromDate, orders = "ymd")))stop("���۳�¥ �Է� ������ Ȯ���ϼ���(yyyymmdd)")
  FromDate <- parse_date_time(FromDate, orders = "ymd")
  FromDate <- gsub("-", "", as.character(FromDate))
}

cat("FromDate :", FromDate)

test <- c(1,2,2,3,4)
df <- data.frame("cc" = test)
sum(is.na(as.numeric(df[, cc]))) == 0

sum(is.na(as.numeric(df[, "cc"]))) == 0 && !is.numeric(df[,"cc"])

# strptime() milesecond ǥ�� ����.
# �Ϲ������� ���� �����ʹ� milsecond ������ �����͸� ���� �ٷ��. 
# �׷��ٸ� � �������� �����Ͱ� �ö�ñ�? 

# ������ ���� �����̴�. -> 20190111002012812(%Y%m%d%H%M%OS)
# �׷��ٸ�, �׳� strptime �Լ��� �̿��ؼ�, ��ȯ���ָ� ���� ������? 
# �ϰ� �ߴ���.. �ڿ� milesecond ������ ©���� 

# Ȯ���غ��� 
as.POSIXct(strptime("20110327013000812", "%Y%m%d%H%M%OS"))

# �̿����� �ذ����� ..? 
# -> �ڿ� 3�ڸ��� �ν��ؼ� .(comma)�� �ٿ��־�� �Ѵ�.
as.POSIXct(strptime("20110327013000.812", "%Y%m%d%H%M%OS"))

# �׷��� Ȥ�� ���� �ʴ´ٸ�,
# getOption("digits.secs") �� ���� 3���� setting�� �Ǿ��ִ��� Ȯ���غ���.

getOption("digits.secs")
options(digits.secs = 3)

# ** �����ؾ� �� ��.
# ms ������ ����, ���ڸ� strptime() �Լ��� �̿��Ͽ� �ٲ� ��, 
# ms ���ڸ� ���ڰ� 1���� down�Ǵ� ������ ����
# ���� �������� ��쿡�� paste0(time, '1')�� ���� �ٿ��ֿ��� �ϰ�,
#        ��ġ���� ��쿡�� + 0.0001�� ���־�� ��!!