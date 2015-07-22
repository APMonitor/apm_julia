include("../apm.jl")

# Select server
server = "http://byu.apmonitor.com"

# Set application name
app = "distill"

# Clear previous application
apm(server,app,"clear all")

# Load model file
apm_load(server,app,"distill.apm")

# Load time points for future predictions
csv_load(server,app,"horizon.csv")

# APM Variable Classification
# class = FV, MV, SV, CV
#   F or FV = Fixed value - parameter may change to a new value every cycle
#   M or MV = Manipulated variable - independent variable over time horizon
#   S or SV = State variable - model variable for viewing
#   C or CV = Controlled variable - model variable for control
FVs = ["feed","x_feed","alpha","atray","acond","areb"]
MVs = ["rr","fbot","sp_x[1]","sp_x[32]"]
SVs = ["x[2]","x[5]","x[10]","x[15]","x[20]","x[25]","x[30]","x[31]"]
CVs = ["x[1]","x[32]"]

# Set up variable classifications for data flow
for x in FVs
	apm_info(server,app,"FV",x)
end
for x in MVs
    apm_info(server,app,"MV",x)
end
for x in SVs
    apm_info(server,app,"SV",x)
end
for x in CVs
    apm_info(server,app,"CV",x)
end

# Options

# time units (1=sec,2=min,3=hrs,etc)
apm_option(server,app,"nlc.ctrl_units",2)
apm_option(server,app,"nlc.hist_units",3)

# set controlled variable error model type
apm_option(server,app,"nlc.cv_type",1)
apm_option(server,app,"nlc.ev_type",1)

# controller mode (1=simulate, 2=predict, 3=control)
apm_option(server,app,"nlc.reqctrlmode",1)

# read discretization from CSV file
apm_option(server,app,"nlc.csv_read",1)

# turn on historization to see past results
apm_option(server,app,"nlc.hist_hor",200)

# set web plot update frequency
apm_option(server,app,"nlc.web_plot_freq",10)

# Controlled variable (c)
apm_option(server,app,"x[1].sphi",0.95)
apm_option(server,app,"x[1].splo",0.94)
apm_option(server,app,"x[1].tau",20.0)
apm_option(server,app,"x[1].fstatus",0)

apm_option(server,app,"x[32].sphi",0.05)
apm_option(server,app,"x[32].splo",0.04)
apm_option(server,app,"x[32].tau",20.0)
apm_option(server,app,"x[32].fstatus",0)

# Manipulated variables (u)
apm_option(server,app,"rr.upper",10)
apm_option(server,app,"rr.dmax",0.2)
apm_option(server,app,"rr.lower",1)
apm_option(server,app,"rr.fstatus",0)

apm_option(server,app,"fbot.upper",1)
apm_option(server,app,"fbot.dmax",0.05)
apm_option(server,app,"fbot.lower",0)
apm_option(server,app,"fbot.fstatus",0)

# Measured Disturbances
apm_option(server,app,"feed.fstatus",1)
apm_option(server,app,"x_feed.fstatus",1)

# imode (1=ss, 2=mpu, 3=rto, 4=sim, 5=mhe, 6=nlc)
apm_option(server,app,"nlc.imode",1)
apm_option(server,app,"nlc.sensitivity",1)

# steady state solution
solver_output = apm(server,app,"solve")
print(solver_output)

# imode (1=ss, 2=mpu, 3=rto, 4=sim, 5=mhe, 6=nlc)
apm_option(server,app,"nlc.imode",6)
apm_option(server,app,"nlc.sensitivity",0)

# turn on controller
apm_option(server,app,"nlc.reqctrlmode",3)
# turn on overhead composition control
apm_option(server,app,"rr.status",1)
apm_option(server,app,"x[1].sphi",0.952)
apm_option(server,app,"x[1].splo",0.952)
apm_option(server,app,"x[1].status",1)
apm_meas(server,app,"sp_x[1]",0.952)
# turn on bottoms composition control
apm_option(server,app,"fbot.status",1)
apm_option(server,app,"x[32].sphi",0.019)
apm_option(server,app,"x[32].splo",0.019)
apm_option(server,app,"x[32].status",1)
apm_meas(server,app,"sp_x[32]",0.019)

# Run NLC on APM server
solver_output = apm(server,app,"solve")
println(solver_output)

# Open Web Viewer and Display Link
println("Web viewer")
url = apm_web(server,app)
