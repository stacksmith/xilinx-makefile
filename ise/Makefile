#BOARD = Nexys4ddr
#DEVICE = xc7a100tcsg324-1
#DEVICE = xc6slx9-2-ftg256 #XuLA2 lx9  
#BOARD = xula2
DEVICE = xc3s200-FT256-4
BOARD = DigilentS3

IMPACT_CMD_FILE := ../board/$(BOARD)/impact.cmd
UCF_FILE := ../board/$(BOARD)/top.ucf
UT_FILE  := ../board/$(BOARD)/top.ut
PRJ_FILE := ../src/top.prj
XST_FILE := ../board/$(BOARD)/top.xst
TOP_FILE := ../src/top.v

SOURCES := $(strip $(shell \
	cat $(PRJ_FILE) | grep -oE '[^[:blank:]]+[[:blank:]]*$$' | tr -d '"' ))

TOP := $(strip $(shell \
	cat $(XST_FILE) | grep "[-]top" | sed s/-top//g ))

ifneq "$(basename $(notdir $(TOP_FILE)))" "$(TOP)"
$(error Design top must have the same name as top-level source file)
endif

default: burn

synth: $(TOP).ngc $(TOP).srp
ngdbuild: $(TOP).ngd $(TOP).bld
map: $(TOP)_map.ncd $(TOP).pcf
par: $(TOP).ncd $(TOP).unroutes $(TOP).par $(TOP).twr
bitgen: $(TOP).bit

.SECONDARY: $(TOP).ngc $(TOP).srp $(TOP).ngd $(TOP).bld $(TOP)_map.ncd 
.SECONDARY: $(TOP).pcf $(TOP).ncd $(TOP).unroutes $(TOP).par $(TOP).twr

#-----------------------------------------------------------------------------

%.ngc %.srp: $(subst $(TOP),%,$(TOP_FILE)) $(SOURCES) $(PRJ_FILE) $(XST_FILE)
	@rm -f $*.ngc $*.srp
	mkdir -p xst/projnav.tmp
	xst -intstyle silent  -ifn $(filter %.xst,$^)

#-----------------------------------------------------------------------------

%.ngd %.bld: %.ngc $(UCF_FILE)
	@rm -f $*.ngd $*.bld
	ngdbuild -intstyle silent -dd _ngo -nt off -uc \
		$(filter %.ucf,$^) -p $(DEVICE) $< $(TOP)

#-----------------------------------------------------------------------------

%_map.ncd %.pcf: %.ngd
	@rm -f $*_map.ncd $*.pcf
	map -w -p $(DEVICE) -ir off -pr b -detail \
	-ol std -logic_opt off -c 100 -o $*_map.ncd $*.ngd $*.pcf

#-----------------------------------------------------------------------------

%.ncd %.unroutes %.par %.twr: %_map.ncd $(TOP).pcf
	@rm -f $*.ncd $*.unroutes $*.par $*.twr
	par -w -ol high $< $@ $(filter %.pcf,$^)
	trce -e $*.ncd $*.pcf

#-----------------------------------------------------------------------------

%.bit: %.ncd $(TOP).unroutes $(TOP).twr $(UT_FILE)
	@rm -f $@
	@echo "---------------------------------------------------------"
	@echo "Checking design for timing errors and unroutes..."
	@grep -i "all signals are completely routed" $(filter %.unroutes,$^) 
	@grep -iq "timing errors:" $(filter %.twr,$^); \
	if [ $$? -eq 0 ]; then \
		grep -i "timing errors: 0" $(filter %.twr,$^); \
		exit $$?; \
	fi
	@echo "Design looks good. Generating bitfile."
	@echo "---------------------------------------------------------"
	bitgen -f $(UT_FILE) $*.ncd $@

#-----------------------------------------------------------------------------

burn: $(TOP).bit $(IMPACT_CMD_FILE)
	impact -batch $(IMPACT_CMD_FILE)

#-----------------------------------------------------------------------------

CLEAN_EXTS := .bgn .bit _bitgen.xwbt .bld .drc .lso _map.map _map.mrp _map.ncd
CLEAN_EXTS += _map.ngm _map.xrpt .ncd .ngc .ngd _ngdbuild.xrpt .ngr .pad
CLEAN_EXTS += _pad.csv _pad.txt .par _par.xrpt .pcf .ptwx .srp _summary.xml
CLEAN_EXTS += .twr .twr_pad.txt .twx .unroutes _usage.xml .xpi _xst.xrpt
CLEAN_EXTS += .ngc_xst.xrpt

clean:
	rm -f $(foreach x,$(CLEAN_EXTS),$(TOP)$(x))
	rm -f par_usage_statistics.html webtalk.log
	rm -f usage_statistics_webtalk.html
	rm -f '#Makefile#' '.#Makefile'
	rm -f _impactbatch.log
	rm -rf _ngo xlnx_auto_0_xdb  _xmsgs xst
