/**
 * common.js
 * 
 * Copyright (c) 2020-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-09-02
 * 
 * 
 */
var PLObject = GlobalObj = PageLogicObj = {}

function debug(printVal,printDesc) {
	printDesc=printDesc||"";
	var mode=1
	if (mode==1) {
		if (printDesc!="") {
			var datatype= typeof printVal
			if (datatype=="object") {
				console.log("%c "+printDesc+": ",'color:red;font-size:16px')
				console.log(printVal)
				//console.table(printVal)
			} else {
				console.log(printDesc + ": " + printVal)
			}
			
		} else {
			console.log(printVal)
		}
	} else {
		//todo...	
	}
}