exinclude("../apm.jl")

for i = 1:119
   # build problem names (e.g. hs001.apm, hs021.apm, hs107.apm)
   n = string(i)
   # pre-pend zeros 
   if i<=9
      n = "0" * n 
   end
   if i<=99
      n = "0" * n
   end
   name = "hs" * n

   println("")
   println("Solving " * name)

   # solve Hock Schittkowski benchmark problem
   y = apm_solve(name,3)
   println(y)
end
