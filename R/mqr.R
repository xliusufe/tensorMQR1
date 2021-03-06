
##--------------main by BIC without sparsity----------------------##
mqr <- function(Y,X,r1=NULL,r3=NULL,SUV=NULL,isSym=TRUE,eps=1e-6,max_step=20,max_step1=20){
  n <- nrow(Y)
  q <- ncol(Y)
  p <- ncol(X)
  
  if(is.null(r1)) r1 = 2
  if(is.null(r3)) r3 = 2
  if(r3>q){ 
    r3=q
    warning("r3 should be not greater than q! Reset r3=q.")
  }
  if(is.null(SUV)){
    set.seed(1)
    U = rbind(diag(r1), matrix(0,p-r1,r1))
    V = rbind(diag(r3), matrix(0,q-r3,r3))
    S = matrix(rnorm(r1^2*r3),r3,r1^2)
  }
  else{
    U = SUV$U
    V = SUV$V
    S = SUV$S
  }
  opts = list(eps=eps,eps1=eps,utol=1e-4,ftol=eps,Pitol=1e-4,tau_min=1e-3,eta=0.1,tiny=1e-13,gamma=0.85,rhols=1e-4,
              max_step=max_step,max_step1=max_step1,isLR=1,n=n,r1=2,r2=2,r3=2,p=p,q=q,onStiefel=1)
  
  Z <- produceZ(X)
  if(isSym)  fit = Estimation(Y,Z,as.matrix(S),as.matrix(U),as.matrix(V),opts)
  else fit = EstUnconstr(Y,Z,as.matrix(S),as.matrix(U),as.matrix(U),as.matrix(V),opts)
  return(list(Dnew=fit$Dnew, 
              rss=fit$likhd,
              Snew=fit$S,
              Unew=fit$U,
              Vnew=fit$V,
              Y = Y,
              X = X
  )
  )
}