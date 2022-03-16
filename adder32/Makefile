# Makefile for simulate the adder32.v
# Question 1. how to generate the random number?
# Solution 1. random seed generation
SEED = $(shell date +%s)

CYCLE_NUM = 200
# variable definition
#DUT = ../../../d_randomesign/verilog/adder32.v 
DUT = ./adder32.v 
#TB  =./adder32_tb.v ./timescale.v
TB  = ./adder32_tb_random.v 

# -------- run the simualtion throught the common methods --------
run: compile simulate

compile:
	vcs -timescale=1/1 +v2k -debug_all $(DUT) $(TB) -l com_$(SEED).log

simulate:
	./simv +plusargs_save +seed=$(SEED) +cycle_num=$(CYCLE_NUM) -l sim_$(SEED).log

run_dve:
	dve -vpd vcdplus.vpd &

# -------- coverage driven strategy-------------------------------
run_cov: compile_coverage simulate_coverage

compile_coverage:
	vcs -debug_all -cm line+cond+fsm+tgl+branch -lca $(DUT) $(TB) -l com_$(SEED).log

simulate_coverage:
	./simv +plusargs_save +seed=$(SEED) +cycle_num=$(CYCLE_NUM) -cm line+cond+fsm+tgl+branch -lca -cm_log \
		cm_$(SEED).log -l sim_$(SEED).log

report_cov:
	urg -dir simv.vdb -format both -report coverage

dve_cov:
	dve -cov -covdir simv.vdb -lca

clean:
	@-rm -rf *.log  csrc simv simv.daidir ucli.key DVEfiles *vpd simv.vdb coverage *.bak *.help
