// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var debug="N"  //"Y" = alerts and stuff, "N" = alert free

function DocumentLoadHandler() {

	var obj=document.getElementById('totals');
	if (obj) {
		var totals=obj.value;
		var total=totals.split("^");
		var obj=document.getElementById('total');
		if (obj) {obj.innerHTML=total[0]; obj.value=total[0]} 
		var obj=document.getElementById('stotal');
		if (obj) {obj.innerHTML=total[1]+"("+total[0]+")"; } 
		var obj=document.getElementById('atotal');
		if (obj) {obj.innerHTML=total[2]+"("+total[0]+")";} 
		var obj=document.getElementById('rtotal');
		if (obj) {obj.innerHTML=total[3]+"("+total[0]+")";} 
	}
	


}

document.body.onload = DocumentLoadHandler;

