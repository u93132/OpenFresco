# File: OneBayFrame_Worker.py (use with OneBayFrame_Main.tcl)
# Units: [kip,in.]
#
# Written: Andreas Schellenberg (andreas.schellenberg@gmail.com)
# Created: 08/08
# Revision: A
#
# Purpose: this file contains the python input to perform
# a hybrid simulation of a one bay frame with
# two experimental zero length elements.
# The adapter element is used to communicate with the
# main FE-software which is coordinating and executing
# the direct integration analysis.

# import the OpenSees Python module
import sys
sys.path.append("C:\\Users\\Andreas\\Documents\\OpenSees\\SourceCode\\Win64\\bin")
from opensees import *
import math

# ------------------------------
# Start of model generation
# ------------------------------
logFile("OneBayFrame_Worker.log")
defaultUnits("-force", "kip", "-length", "in", "-time", "sec", "-temp", "F")

# create ModelBuilder (with two-dimensions and 2 DOF/node)
model("BasicBuilder", "-ndm", 2, "-ndf", 2)

# Define geometry for model
# -------------------------
mass3 = 0.00
# node(tag, xCrd, yCrd, "-mass", mass)
node(1,   0.0,  0.00)
node(3,   0.0, 54.00, "-mass", mass3, mass3)

# set the boundary conditions
# fix(tag, DX, DY)
fix(1, 1, 1)
fix(3, 0, 1)

# Define materials
# ----------------
#uniaxialMaterial("Elastic", 1, 2.8)
#uniaxialMaterial("Steel01", 1, 0.95, 2.8, 0.105)
uniaxialMaterial("Steel02", 1, 1.5, 2.8, 0.01, 18.5, 0.925, 0.15, 0.0, 1.0, 0.0, 1.0)

# Define elements
# ---------------
# element("twoNodeLink", eleTag, iNode, jNode, "-mat", matTags, "-dir", dirs, "-orient", x1, x2, x3, y1, y2, y3, "-pDelta", Mratios, "-mass", m)
element("twoNodeLink", 1, 1, 3, "-mat", 1, "-dir", 2)

# element("adapter", eleTag, "-node", Ndi, Ndj, ..., "-dof", dofNdi, "-dof", dofNdj, ..., "-stif", Kij, ipPort, "-mass", Mij)
element("adapter", 10, "-node", 3, "-dof", 1, "-stif", 1E12, 44000)

# Define dynamic loads
# --------------------
# set time series to be passed to uniform excitation
dt = 0.02
scale = 1.0
timeSeries("Path", 1, "-filePath", "elcentro.txt", "-dt", dt, "-factor", 386.1*scale)

# create UniformExcitation load pattern
# pattern("UniformExcitation", tag, dir, "-accel", tsTag, "-vel0", v0)
pattern("UniformExcitation", 1, 1, "-accel", 1)

# calculate the Rayleigh damping factors for nodes & elements
alphaM    = 1.010017396536;  # D = alphaM*M
betaK     = 0.0;             # D = betaK*Kcurrent
betaKinit = 0.0;             # D = beatKinit*Kinit
betaKcomm = 0.0;             # D = betaKcomm*KlastCommit

# set the Rayleigh damping 
rayleigh(alphaM, betaK, betaKinit, betaKcomm)
# ------------------------------
# End of model generation
# ------------------------------


# ------------------------------
# Start of analysis generation
# ------------------------------
# create the system of equations
system("BandGeneral")
# create the DOF numberer
numberer("Plain")
# create the constraint handler
constraints("Plain")
# create the convergence test
test("NormDispIncr", 1.0e-12, 25)
#test("NormUnbalance", 1.0e-12, 25)
#test("EnergyIncr", 1.0e-12, 25)
# create the integration scheme
integrator("LoadControl", 1.0)
#integrator("Newmark", 0.5, 0.25)
#integrator("NewmarkExplicit", 0.5)
# create the solution algorithm
algorithm("Newton")
#algorithm("Linear")
# create the analysis object 
analysis("Static")
#analysis("Transient")
# ------------------------------
# End of analysis generation
# ------------------------------


# ------------------------------
# Start of recorder generation
# ------------------------------
# create the recorder objects
recorder("Node", "-file", "Worker_Node_Dsp.out", "-time", "-node", 4, "-dof", 1, "disp")
recorder("Node", "-file", "Worker_Node_Vel.out", "-time", "-node", 4, "-dof", 1, "vel")
recorder("Node", "-file", "Worker_Node_Acc.out", "-time", "-node", 4, "-dof", 1, "accel")

recorder("Element", "-file", "Worker_Elmt_Frc.out", "-time", "-ele", 1, 2, "forces")
recorder("Element", "-file", "Worker_Elmt_ctrlDsp.out", "-time", "-ele", 1, "forces")
recorder("Element", "-file", "Worker_Elmt_daqDsp.out", "-time", "-ele", 1, "forces")
# --------------------------------
# End of recorder generation
# --------------------------------


# ------------------------------
# Finally perform the analysis
# ------------------------------
record()
analyze(16000)
#analyze(16000, 0.02)
wipe()
exit()
# --------------------------------
# End of analysis
# --------------------------------
