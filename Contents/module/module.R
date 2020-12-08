#####################################
# dataFrame �� ��ġ�� ���� return
# Author  : ������
# version : 1.0
# date    : 2019.04.26
#####################################
# CHANGE LOG
#####################################

#' @description 
#' dataFrame �� ��ġ�� ���� return
#' 
#' @param dataset, �ʼ�, DataFrame

colnames.numeric  <- function(dataset, ...){
  variables <- names(dataset)
  variables[sapply(variables, function(.x) is.numeric(dataset[,.x]))]
  variables <- setdiff(variables, names.time(dataset)) # ��¥�� ������ ����
  variables
}

#####################################
# dataFrame �� ��¥�� ���� return
# Author  : ������
# version : 1.0
# date    : 2019.04.26
#####################################
# CHANGE LOG
#####################################

#' @description 
#' dataFrame �� ��ġ�� ���� return
#' 
#' @param dataset, �ʼ�, DataFrame
#' @param onlytime, �ʼ�, T : POSIXct class �� ������ ���� ���, F : ����
#' 
colnames.time <- function(dataset, onlytime = F){
  variables <- base::names(dataset)
  if(onlyTime){
    time_variables <- variables[sapply(variables, function(.x) inherits(dataset[,.x], "POSIXct"))]
  }else{
    # as.POSIXct ��ȯ ������ ������ ����
    # 100�� data ���� -> na ���� -> as.poSIXct ���� �� ��ȯ �Ұ��ϸ� NA, �ƴϸ� ��ȯ�ǹǷ�, all(is.na())�� �̿��ؼ� ����
    time_variables <- variables[sapply(variables, function(.x) tryCatch(!all(is.na(as.POSIXct(na.omit(head(dataset[, .x], 100)))))))]
  }
  time_variables
}

#####################################
# dataFrame �� ������ ���� return
# Author  : ������
# version : 1.0
# date    : 2019.04.26
#####################################
# CHANGE LOG
#####################################

#' @description 
#' dataFrame �� categorical ���� return
#' unique ������ 2 �̻� 5������ ��ġ�� ����. ��ġ�� ������ ����
#' 
#' 
#' @param dataset, �ʼ�, DataFrame
#' @param onlytime, �ʼ�, T : POSIXct class �� ������ ���� ���, F : ����
#'

colnames.categorical <- function(dataset, ...){
  unique_num <- apply(dataset, 2, function(x) length(unique(x[!is.na(x)])))
  variables  <- names(unique_num)[unique_num <= 5 & unique_num > 1]
  c(setdiff(names(dataset), names.numeric(dataset)), variables)
  variables
}

#####################################
# rank �Լ�(NA ó��)
# Author  : ������
# version : 1.0
# date    : 2019.04.26
#####################################
# CHANGE LOG
#####################################

#' @description 
#' rank+ NA �� ��� ���� �߰�
#' rank_index 
#' 
#' @param x, vector
#' @param ties.method, �ʼ�, max, min, 
#' @param na.last, boolean,  na -> last �� ���������� ����
#' 

rank_na <- function(x, ties.method = "max", na.last = T){
  rank.x <- rank(x, ties.method = ties.method)
  na.index <- is.na(x)
  na.len   <- sum(na.index)-1
  if(na.last){
    rank.x[na.index] <- length(x)- na.len
  }else{
    rank.x[na.index] <- NA
  }
  rank.x
}


#####################################
# apply Ȱ��
# Author  : ������
# version : 1.0
# date    : 2019.04.26
#####################################
# CHANGE LOG
#####################################

#' @description 
#' apply vector�� ���� ����
#' data �� vector �� ���, �ܼ� �Լ��� ����, DF �̸� apply �Լ� ����
#' 
#' @param x, vector
#' @param MARGIN, �ʼ�, 1 : ��, 2 : ��
#' @param FUN, ����� �Լ�
#' 
apply.adj <- function(X, MARGIN = 2, FUN){
  if(is.null(dim(X))){
    FUN(X)
  }else{
    apply(X, MARGIN, FUN, ...)
  }
}


#####################################
# �ĺ� ���� ����
# Author  : ������
# version : 1.0
# date    : 2019.04.26
#####################################
# CHANGE LOG
#####################################

#' @description 
#' �Լ��� �̿��Ͽ� �ĺ� ���� ����
#' �˰����� -> logistic, lasso, bagging
#' 
#' @param data, dataset
#' @param yvar, �ʼ�, 1 : ��, 2 : ��
#' @param xvars, yvar�� ������ ������ ����
#' @param method, logistic, lasso, bagging �� �ϳ�
#' 
rmf.detect.bin <- function(data, yvar, xvars = setdiff(names(data), yvar),
                           method = c('logistic', "lasso", "bagging")){
  
  # �������� missing ���� Ȯ��
  if(missing(yvar)){
    stop("yvar should be specified")
  }
  
  # ���� ���� unique ���� Ȯ�� 
  if(length(unique(na.omit(data[, yvar]))) <= 1){
    stop("Response variable should have two levels.")
  }
  
  # ���� ������ ���� ������ ���ԵǾ� �ִ� ��� stop
  if(yvar %in% xvars){
    stop("yvar can't be include in xvars.")
  }
  
  # ���� ��� ���� = ���� �����м� ���
  if(is.null(xvars) || length(xvars) <= 1){
    stop("xvars is not proper. (The number of xvars should more than two.)")
  }
  
  # match.args�� ���� method Ȯ��
  method <- match.args(c('logistic', "lasso", "bagging"), method, several.ok = TRUE)
  
  # �� ���� �� Inf ���� �� Inf -> NA�� ����
  if(any(is.infinite(as.metrix(data[, xvars])))){
    infinite.variables <- NULL
    for(i in 1:length(xvars)){
      x <- data[, xvars[i]]
      if(any(is.infinite(x))){
        x[is.infinite(x)] <- as.numeric(NA)
        data[,xvars[i]] <- x
        infinite.variables <- union(infinite.variables, xvars[i])
      }
    }
    # �ش� ������ Inf�� ���ԵǾ� �ִ� ���, print
    infinite.variables <- paste0(infinite.variables, collapse = ", ")
    cat(paste0("Inf, -Inf change to NA value", "\n", "( ", infinite.variables, ")\n"))
  }
  
  # ���� ���� �� ���� ������ 50% �̻��� ��
  # is.na() : 
  missing.xvars <- names(which(sapply(xvars, function(.x) mean(is.na(data[,.x])) >= 0.5)))
  
  if(length(missing.xvars) > 0){
    stop(paste0("Following variables have NA values more than fifty percent."
                , "( ", paste0(missing.xvars, collapse = ", "), ")", "\n"))
  }
  
  # ���� �������� ��� ���� ���� ���� ��, stop
  unique.xvars <- names(which(sapply(xvars, function(.x) length(unique(na.omit(data[,.x])))  <= 1 )))
  
  if(length(unique.xvars) > 0){
    stop(paste0("Following variables have only one unique values except NA values.",
                "(", paste0(missing.xvars, collapse = ", "), ")", "\n"
    ))
  }
  
  # ���� ���� factor ��ȯ
  data[, yvar] <- as.factor(data[,yvar])
  
  # ���� �м� ��� ���̺��� ����
  out <- data.frame(VARIABLE = xvars, stringsAsFactors = F)
  
  # 1. logistic 
  if("logistic" %in% method){
    logistic.result <- data.frame(t(apply.adj(subset(data, select = xvars), 2, function(x){
      logistic.fit <- glm(as.factor(data[,yvar]) ~ x, family = binomial())
      if(is.numeric(x) && nrow(summary(logistic_fit)$coefficients) == 2){
        log.tmp <- summary(logistic.fit)$coefficients["x", c("z value", "Pr(>|z|)")]        
      }else{
        log.tmp <- c(as.numeric(NA), as.numeric(NA))
      }
      log.tmp
    })))
    out$LOGISTIC_ALPHA   <- logistic_result[, 1]
    out$LOGISTIC_P_VALUE <- logistic_result[, 2]
    out$LOGISTIC_SIGN    <- cut(out$LOGISTIC_P_VALUE, breaks  = c(-Inf, 0.01, 0.05, 0.1, 1), label = c("**", "*", ".", ""))
    out$LOGISTIC_RANK    <- rank_na(out$LOGISTIC_P_VALUE)
  }
  
  if("lasso" %in% method){
    # Guide - lasso �� x�� 2�� �̻��� �� ���
    # lasso.result$beta ���� �� feature�� ���� coefficient ���� ����.
    # 
    index.na     <- (apply_adj(subset(data, select = xvars), 1, function(x) any(is.na(x)))) # x���� na�� ��� return
    lasso.result <- glmnet(as.matrix(subset(data, select = xvars)[!index.na,]), as.factor(data[,yvar][!index_na]), alpha = 1, family ='binomial')
    out$lasso_ZEROBETASOME <- apply_adj(lasso_result$beta, 1, FUN = function(x) sum(which(x==0), na.rm = T))
    out$lasso_RANK         <- rank_na(out$lasso_ZEROBETASOME)
    rm(index_na)
  }
  
  if("bagging" %in% method){
    bag.result <- bagging.tree.noprune(paste(yvar, " ~ ", paste(xvars, collapse = " + ")), data)    
    out$BAGGING <- freq.var(bag.result)[xvars, ]$relative.frequency
    out$BAGGING_RANK <- rank_na(-out$BAGGING, na.last = TRUE)
  }
  
  out$RANK_SUM <- rank_na(rowMeans(cbind(out$COR_RANK, out$LOGISTIC_RANK, out$lasso_RANK, out$BAGGING_RANK), na.rm = T), na.last = TRUE)
  
  out <- out[order(out$RANK_SUM), ]
  rownames(out) <- NULL
  
  return(out)
}


#####################################
# bagging Tree
# Author  : ������
# version : 1.0
# date    : 2019.04.26
#####################################
# CHANGE LOG
#####################################

#' @description 
#' �Լ��� �̿��Ͽ� �ĺ� ���� ����
#' �˰����� -> logistic, lasso, bagging
#' 
#' @param formula, rpart�� �ʿ��� formula
#' @param x, �ʼ�, Data 
#' @param y_data, ���� ����
#' @param no.bootstrap, bootstrap Ƚ��
bagging.tree.noprune <- function(formula, x, y_data=NULL, no.bootstrap = 50){
  
  require(rpart)
  
  fun.args2  <- as.character(match.call())
  no.of.row  <- dim(x)[1]                       # �������� ��
  class.var  <- as.character(names(y_data))     # y
  save.trees <- vector(mode='list', no.bootstrap) # bootstrap ����ŭ tree�� ����� ������ Ʋ ����
  for(i in 1:no.bootstrap){
    boot.sample.index <- sample(no.of.row, no.of.row, replace = TRUE)
    save.trees[[i]]   <- rpart(formula, x[boot.sample.index, ])
    gc(reset = TRUE)
  }
  
  attr(save.trees, "class") <- 'bagging'
  attr(save.trees, "Target.Var") <- class.var
  attr(save.trees, "Exp.Var") <- as.character(formula[3])
  attr(save.trees, "no.bootstrap") <- no.bootstrap
  attr(save.trees, "Levels") <- levels(x[, class.var])
  save.trees
}


#####################################
# bagging ��� �� ����
# Author  : ������
# version : 1.0
# date    : 2019.04.26
#####################################
# CHANGE LOG
#####################################

#' @description 
#' bagging ��� �� ����
#' �˰����� -> logistic, lasso, bagging
#' 
#' @param bag.tree, bag.tree ��ü -> bagging.tree.noprune return ��
freq.var <- function(bag.tree)
{
  if(class(bag.tree) != "bagging") stop("The class of object is NOT Bagging")
  len.obj <- attributes(bag.tree)$no.bootstrap
  var.used <- c()
  var.used   <- as.character(unique(bag.tree[[1]]$frame$var[!(bag.tree[[1]]$frame$var == "<leaf>")]))
  for(m in 2:len.obj)
  {
    var.used <- c(var.used, as.character(unique(bag.tree[[m]]$frame$var[!(bag.tree[[m]]$frame$var == "<leaf>")])))
  }
  no.var.used <- table(var.used)        # ���� �� �󵵼�
  no.var.mat  <- as.matrix(no.var.used) # ������ �󵵼� matrix ���·� ����
  no.var  <- rev(sort(no.var.mat[,1]))  # ������ �� �� ���� ������ ����
  no.var2 <- round(no.var/len.obj, 2)   # �󵵼��� ���� ������ ����
  var.mat <- as.matrix(no.var)          # �� �� matrix ���·� ����
  var.mat2 <- cbind(no.var, no.var2)    # ����(�󵵼�/bootstrap Ƚ��) matrix ���·� ����
  dimnames(var.mat2) <- list(c(dimnames(var.mat)[[1]]), c("frequency", "relative frequency")) # �󵵼��� ������ �ϳ��� �����ͷ� ����
  foo.final <- data.frame(var.mat2)
  attr(foo.final, "no.bootstrap") <- len.obj
  foo.final
}

# setdiff(x,y): ������ �Լ�, x�� y�� �������� ���� 
# match.arg : args �� choices �� ���� ��ġ�ϴ� �Լ�
# gc: garbage collection, ����ڰ� ���� �����൵ �ڵ� ����
