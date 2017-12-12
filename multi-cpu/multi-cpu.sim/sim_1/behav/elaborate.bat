@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.3\\bin
call %xv_path%/xelab  -wto 6c4df1ac5ed84a39b5d834fc1e399fae -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot multi_Cpu_sim_behav xil_defaultlib.multi_Cpu_sim xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
