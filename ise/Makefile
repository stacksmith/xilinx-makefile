# Don't forget to source the Xilinx settings file
#
DEVICE = xc3s200-FT256-4
BOARD = DigilentS3

default: burn
#-----------------------------------------------------------------------------
top.ngc: ../src/top.v ../board/$(BOARD)/top.ucf ../src/top.prj 
	xst -intstyle silent  -ifn ../board/$(BOARD)/top.xst 
#-----------------------------------------------------------------------------
top.ngd: top.ngc
	ngdbuild -intstyle silent -dd _ngo -nt off -uc ../board/$(BOARD)/top.ucf -p $(DEVICE) top.ngc top
#-----------------------------------------------------------------------------
top.pcf: top.ngd top.ngc
	map  -p $(DEVICE) -timing -logic_opt off   \
	-ol high -t 1 -register_duplication off -cm area -detail -ir off -pr b \
	-power off -o top_map.ncd top.ngd top.pcf 
#-----------------------------------------------------------------------------
top.ncd: top.ngd top.ngc top.pcf top_map.ncd
	par -intstyle silent -w  -ol high -t 1 top_map.ncd top.ncd top.pcf
#-----------------------------------------------------------------------------
top.bit: top.ncd
	bitgen -intstyle silent -w -g DebugBitstream:No -g Binary:no -g CRC:Enable -g ConfigRate:6 \
	-g CclkPin:PullUp \
	-g DonePin:PullUp  -g TckPin:PullUp -g TdiPin:PullUp -g TdoPin:PullUp \
	-g TmsPin:PullUp -g UnusedPin:PullDown -g UserID:0xFFFFFFFF \
	-g StartUpClk:CClk -g DONE_cycle:4 -g GTS_cycle:5 \
	-g GWE_cycle:6 -g LCK_cycle:NoWait  -g Security:None -g DonePipe:No \
	-g DriveDone:No top.ncd
#-----------------------------------------------------------------------------
burn:	top.bit 
	impact -batch ../board/$(BOARD)/impact.cmd
#-----------------------------------------------------------------------------
clean:
	rm -rf *~ src/*~ *.bgn *.bin *.bit *.xwbt *.bld *.drc *log *.html \
 *.ncd *.ngc *.ngd *.map *.mrp *.xrpt *.ngr *.syr *.twr *.twx *.unroutes \
  webtalk* *_map* *.pad *.lso *.par *.xdl *_summary* *_usage* *.xpi *.stx *.srp \
*.ptwx *.pcf _ngo planAhead* iseconfig* _xmsgs xlnx_auto* xst/dump.xst xst/work \
*.prm *.cfi *.hex *.csv top_pad.txt 
	rm -rf xst; mkdir xst; mkdir xst/projnav.tmp

