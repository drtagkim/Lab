install.packages('lpSolveAPI')
#Libraries
library(magrittr)
library(lpSolveAPI)

# Maximization problem ----------------------------------------------------

N_contraints=2
N_decision_variables=2
object_value=c(1,3)
Constraint1=c(0.05,0.1,20)
Constraint2=c(0.1,0.5,50)
lp_model<-make.lp(N_contraints,N_decision_variables)
invisible({
  lp_model %>% lp.control(sense="max")
  lp_model %>% set.objfn(object_value)
  lp_model %>% add.constraint(Constraint1[1:2],"<=",Constraint1[3])
  lp_model %>% add.constraint(Constraint2[1:2],"<=",Constraint2[3])
})
ifelse(solve(lp_model)==0,'Solution found','') 
#
solution_variables<-get.variables(lp_model)
names(solution_variables)=c("star_var1","star_var2")
objective_value<-get.objective(lp_model)
names(objective_value)=c('obj_value')
sensitivity_analysis<-get.sensitivity.obj(lp_model)
shadow_price<-get.sensitivity.rhs(lp_model)
#
{
  cat("Linear programming solution:\n")
  cat("  star variable 1 =",solution_variables['star_var1'],'\n')
  cat("  star variable 2 =",solution_variables['star_var2'],'\n')
  cat("  objective value =",objective_value,'\n')
}
sensitivity_analysis
shadow_price
# Minimization problem ----------------------------------------------------

N_contraints=2
N_decision_variables=2
object_value=c(1200,800)
Constraint1=c(30,1.4,50)
Constraint2=c(1,0.9,10)
lp_model<-make.lp(N_contraints,N_decision_variables)
invisible({
  lp_model %>% lp.control(sense="min")
  lp_model %>% set.objfn(object_value)
  lp_model %>% add.constraint(Constraint1[1:2],">=",Constraint1[3])
  lp_model %>% add.constraint(Constraint2[1:2],">=",Constraint2[3])
})
ifelse(solve(lp_model)==0,'Solution found','') 
#
solution_variables<-get.variables(lp_model)
names(solution_variables)=c("star_var1","star_var2")
objective_value<-get.objective(lp_model)
names(objective_value)=c('obj_value')
sensitivity_analysis<-get.sensitivity.obj(lp_model)
shadow_price<-get.sensitivity.rhs(lp_model)
#
{
  cat("Linear programming solution:\n")
  cat("  star variable 1 =",solution_variables['star_var1'],'\n')
  cat("  star variable 2 =",solution_variables['star_var2'],'\n')
  cat("  objective value =",objective_value,'\n')
}
sensitivity_analysis
shadow_price

# Integer programming -----------------------------------------------------

N_contraints=2
N_decision_variables=2
object_value=c(1200,800)
Constraint1=c(30,1.4,50)
Constraint2=c(1,0.9,10)
lp_model<-make.lp(N_contraints,N_decision_variables)
invisible({
  lp_model %>% lp.control(sense="min")
  lp_model %>% set.objfn(object_value)
  lp_model %>% add.constraint(Constraint1[1:2],">=",Constraint1[3])
  lp_model %>% add.constraint(Constraint2[1:2],">=",Constraint2[3])
  lp_model %>% set.type(1,'integer')
  lp_model %>% set.type(2,'integer')
})
ifelse(solve(lp_model)==0,'Solution found','') 
#
solution_variables<-get.variables(lp_model)
names(solution_variables)=c("star_var1","star_var2")
objective_value<-get.objective(lp_model)
names(objective_value)=c('obj_value')
#sensitivity_analysis<-get.sensitivity.obj(lp_model)
#shadow_price<-get.sensitivity.rhs(lp_model)
#
{
  cat("Linear programming solution:\n")
  cat("  star variable 1 =",solution_variables['star_var1'],'\n')
  cat("  star variable 2 =",solution_variables['star_var2'],'\n')
  cat("  objective value =",objective_value,'\n')
}
#sensitivity_analysis
#shadow_price
