# retrieve apm.jl from GitHub or APMonitor.com
include("../apm.jl")

s = "http://byu.apmonitor.com"
a = "minlp"

apm(s,a,"clear all")

#  minimize    f(x)
#  subject to  h(x) > 0
#              g(x) = 0
#
# In this case:
#  f(x) = x1*x4*(x1+x2+x3) + x3
#  h(x) = x1*x2*x3*x4 - 25
#  g(x) = x1^2 + x2^2 + x3^2 + x4^2 - 40
#
# x1 and x2 are continuous variables
# int_x3 and int_x4 are integer variables

if isfile("minlp.apm")
  # Load model file (if it exists)
  apm_load(s,a,"minlp.apm")
else
  # Declare variables and equations here
  # Declare variables
  apm(s,a,"Variables")
  apm(s,a," x1 = 1, >=1, <=5")
  apm(s,a," x2 = 5, >=1, <=5")
  apm(s,a," int_x3 = 5, >=1, <=5")
  apm(s,a," int_x4 = 1, >=1, <=5")

  # Declare objective and equations
  apm(s,a,"Equations")
  apm(s,a," minimize x1*int_x4*(x1+x2+int_x3) + int_x3")
  apm(s,a," x1*x2*int_x3*int_x4 > 25")
  apm(s,a," x1^2 + x2^2 + int_x3^2 + int_x4^2 = 40")
end

# Solve optimization problem
output = apm(s,a,"solve")
println(output)

# Retrieve solution
y = apm_sol(s,a)

println("Solution Results")
println("  x1 = " * string(y["x1"]))
println("  x2 = " * string(y["x2"]))
println("  int_x3 = " * string(y["int_x3"]))
println("  int_x4 = " * string(y["int_x4"]))
