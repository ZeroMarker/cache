// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
//
//Use filename as a prefix to identify globals and functions
var tc_expr='0';
var tc_disp='0';
var tc_tc_last='';
function tc_num(val) {
	//process number key
	if (tc_expr=='0') {
		tc_disp='';
		tc_expr='';
	}
	tc_disp=tc_disp + val;
	tc_expr=tc_expr + val;	
	document.all("myoutput").innerText=tc_disp;
	tc_last=val;
}
function tc_equals() {
	//if the tc_last character is +/-* remove it
	if ((tc_last=='/')||(tc_last=='*')) {
		alert('Invalid tc_expr \n' + tc_expr);
	} else {
		tc_expr=Math.round(eval(tc_expr)*1E12)/1E12;
		tc_disp=tc_expr;
		document.all("myoutput").innerText=tc_disp;
		tc_last='';
	}
}
function tc_operator(op) {
	if (((op=='/')||(op=='*'))&&((tc_last=='/')||(tc_last=='*'))) {
		alert('Invalid tc_expr \n' + tc_expr);
	} else {
		tc_expr=tc_expr + op;
		tc_disp='';
		tc_last=op;
	}
}
function tc_clear() {
	tc_expr='0';
	document.all("myoutput").innerText=tc_expr;
}
function tc_dot(val) {
	if (tc_disp.split(".").length==1) {
		tc_disp=tc_disp + val;
		tc_expr=tc_expr + val;	
		document.all("myoutput").innerText=tc_disp;
	}
}
