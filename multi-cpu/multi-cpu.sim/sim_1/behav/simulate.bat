@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.3\\bin
call %xv_path%/xsim multi_Cpu_sim_behav -key {Behavioral:sim_1:Functional:multi_Cpu_sim} -tclbatch multi_Cpu_sim.tcl -view C:/Users/TAN/Desktop/multi-cpu/multi_Cpu_sim_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
