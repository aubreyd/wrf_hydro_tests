#!/bin/bash
## Example of calling standard test.
## Docker invocation using the wrfhydro/dev container. 
## Mounted volume paths will need adjusted to your machine. 

testsDir=/glade/u/home/jamesmcc/WRF_Hydro/wrf_hydro_tests/

$testsDir/take_test.sh \
    $testsDir/examples/upstream_master/candidate_jamesmcc_nwm-ana_cheyenne_sixmile_intel.sh \
    $testsDir/tests/fundamental.sh

exit $?