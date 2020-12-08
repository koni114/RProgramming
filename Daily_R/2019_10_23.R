# 2019_10_23.R
# writen  : ������
# created : 2019.10.23
# miniCRAN, ���ͳ��� �ȵ� ��, local repo�� �̿��Ͽ� tar.gz download �ް�, �̸� ��ġ�ϴ� ��� guide


# miniCRAN ����غ���

#  miniCRAN�� Local ����� R Package ��ġ�� �����ִ� Package.
# �ٽ���, �Ϲ����� Package�� Source�� �����ϴ� ���� �ƴ� �ش� Package�� Dependency���� �ڵ����� ȹ���Ͽ� Repo�� �����ϸ�,
# �ش� Repo�� ���� Info������ ���� �� ����.
# ** Ư�� CRAN, CRAN Mirror����Ʈ �ܿ��� Bioconductor,R-forge, Repository�� ������ ���� �� ������ �� �ִ� ������ ����.

# 1. Install �ϱ�
# ���� Install�� Internet ȯ�濡�� R�� ���� �ؾ��Ѵ�.
# �ش� ������ �⺻ Repo���� �����ϰ� �� -> ���⼭ ���ϴ� repository�� �츮�� ��Ű���� �ٿ� ���� "��Ű�� �����"�� ���Ѵ�.
# ������ repository��� �ϴ� ���� ��Ű��, ���̺귯�� �ҽ��� ����Ǿ� �ִ� ��θ� ��Ī�Ѵ�.

# �⺻������ CRAN -> "http://cran.rstudio.com/" ���� �Ǿ� ���� ���̴�.

install.packages("miniCRAN")  # miniCRAN ��Ű�� ��ġ
library(miniCRAN)
getOption("repos")            # �⺻ repo Ȯ�� 

# 2. dependency package List �̾ƿ���
# Vector ���·� �̷���� �������� Package�� ���� pkgDep �Լ��� ����ϸ� Return ������ �ش� Dependency�� Tree�� �������� ������ Vector�� ��ȯ�Ѵ�.

# ���� ���, dplyr�� ���ӵ� dependency package�� �����ͺ���.
pkgs    <- c("dplyr")
pkgList <-pkgDep(pkgs, type = "source")

pkgList # dplyr package�� ���ӵ� package ����� Ȯ���� �� �ִ�.

# 3. Repository ����
# makeRepo function�� ���� pth ��ο� Source�� ������ Repository�� �����Ѵ�.

dir.create(pth <- file.path(getwd(), "miniCRAN"))
dirPkgList <- makeRepo(pkgList, path = pth, type = "source", Rversion = "3.6")

# 4. ���� : graph�� dependency ������ Ȯ��
# makeDepGraph function�� �̿��ؼ� dependency ������ ������ Ȯ���� �� ����. 

dg <- makeDepGraph(pkgList[1], enhances = TRUE, availPkgs = cranJuly2014)
set.seed(1)
plot(dg, legendPosition = c(-1, -1), vertex.size = 10, cex = 0.7)

# 5. local repository�� �̿��Ͽ� package ��ġ�غ��� -> tar.gz file�� ��ġ�Ϸ���, Rtools�� ���������� ����־�� ��.

uninstallPkg <- c()
pkgFullDirName <- dirPkgList[1]
# pkgFullDirName <- "C:/rTest/miniCRAN/src/contrib/magrittr_1.5.tar.gz"

# pkgList <- apply(data.frame(dirPkgList), 1, function(x){
#   tmpVec  <- strsplit(x, "/")[[1]]
#   pkgName <- strsplit(tmpVec[length(tmpVec)], "_")[[1]][1]
#   pkgName
# })


######################################
# InstallPack
# local package install�� dependency ������ install function
# ** uninstallPkg <- c(), pkgList vector�� ����Ǿ� �־����.
# pkgList -> packageName list
# Author     : ������
# version    : 1.3
# location   : local R
#####################################
# CHANGE LOG
# 1.0   : initial version
#####################################
#' @param pkgFullDirName, directory + PackageName + tar.gz,
#' @examples
#' InstallPack(pkgFullDirName = 'C:/rTest/miniCRAN/src/contrib/magrittr_1.5.tar.gz'")
InstallPack <- function(pkgFullDirName){
  
  print(paste0("****** ", pkgFullDirName , " start !!"))
  
  # �Ľ��� ���� packageName�� ����.
  tmpVec  <- strsplit(pkgFullDirName, "/")[[1]]
  pkgName <- strsplit(tmpVec[length(tmpVec)], "_")[[1]][1]
  
  # �̹� �ִ� package��, return
  if(any(installed.packages()[,c("Package")] %in% pkgName)){
    print(paste0("�̹� �ִ� package :", pkgName))
    return(NULL)
  }
  
  # �ش� package�� dependency package�� �ִ��� Ȯ�� 
  dependsPkg <- tools::package_dependencies(pkgName)[[1]]
  print(paste0("depends pack : ", dependsPkg))
  
  # dependency package�� ������ input param�� package�� ��ġ�ϰ� ����.
  if(length(dependsPkg) < 1){
    
    # install.packages function�� ���� package install. �� �� error �߻���, ���������� uninstallPkg vector�� append
    tryCatch({
      install.packages(pkgFullDirName, repos = NULL, type = "source")
      print(paste0("####### ", pkgName, " is installed ##########"))
    }, error = function(err) {
      uninstallPkg <- c(uninstallPkg, pkgName)
    })
    return(NULL)
    
    # dependency package�� ������, ����� ȣ���� ����, �ٽ� InstallPack function�� �Է� ������ setting
  }else{
    
    # dependency package vector�� for���� ���� ����� ȣ�� ����.
    for(tmp in dependsPkg){
      print(paste0("tmp : ", tmp))
      
      # �ش� dependency package�� dir + packageName + tar.gz �� paste �� �Լ��� �ٽ� �Է�. 
      if(any(pkgList %in% tmp)){
        InstallPack(dirPkgList[pkgList %in% tmp])
      }
    }
    
    # install.packages function�� ���� package install. �� �� error �߻���, ���������� uninstallPkg vector�� append
    tryCatch({
      install.packages(pkgFullDirName, repos = NULL, type = "source")
      print(paste0("## ", pkgName, " is installed"))
    }, error = function(err) {
      uninstallPkg <- c(uninstallPkg, pkgName)
    })
    return(NULL)
  }
}