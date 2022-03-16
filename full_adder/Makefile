# Makefile for simulate the full_adder.v with the simulator VCS

# --------------------------------------------------------------
# Macro variables
RTL  := ./full_adder.v
TB   += ./full_adder_tb.v
SEED ?= $(shell date +%s)

# Target : Dependency
all: compile simulate

compile:
	vcs -sverilog -debug_all timescale.v $(RTL) $(TB) -l com.log

simulate:
	./simv +ntb_random_seed=$(SEED) -l sim.log

run_dve:
	dve -vpd vcdplus.vpd &

clean:
	rm -rf *.log  csrc simv*  *.key *.vpd DVEfiles coverage *.vdb







# ---------------------------------------------------------------
# this all_cov target is used to collect the code coverage
all_cov: compile_coverage simulate_coverage

compile_coverage:
	vcs -sverilog -debug_all -cm line+cond+fsm+tgl+branch \
		  -lca timescale.v full_adder.v full_adder_tb.v -l com.log

simulate_coverage:
	./simv +ntb_random_seed=$(SEED) -cm line+cond+fsm+tgl+branch \
		     -lca -cm_log cm.log -l sim.log

report_cov:
	urg -dir simv.vdb -format both -report coverage

dve_cov:
	dve -cov -covdir simv.vdb -lca

