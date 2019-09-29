import std;

import arsd.terminal;
import driver.impl, driver.root;

import bobthebuilder;
import runner.impl;
import runner.root : checkRunners;
import util.inform, util.colour, util.argparse;


int main(string[] args)
{
	//Are all the required tools present
	try {
		//checkRunners!(runner.impl)(true);
	} catch (Exception e) {
		alert(e.msg);
	}
	
	
	return args.argParse;

}
