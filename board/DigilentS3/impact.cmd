setMode -bscan
setCable -p auto
identify -inferir
assignFile -p 1 -file top.bit
#addDevice -p 1 -file top.bit
program -p 1 -onlyFpga
exit


    	
