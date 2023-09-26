//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 4.07.02

function BodyLoadHandler() {
   	if (self==top) websys_reSizeT();

    doTotal();
    
    var obj=document.getElementById("ODOMStartOdometer");
    if (obj) obj.onblur=doTotal;
    var obj=document.getElementById("ODOMEndOdometer");
    if (obj) obj.onblur=doTotal;


	obj=document.getElementById('update1');
	if (obj) obj.onclick=onUpdate;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=onUpdate;
}

function doTotal()
{
  var startO=document.getElementById("ODOMStartOdometer");
  var endO=document.getElementById("ODOMEndOdometer");
  var total=document.getElementById("Total");

  if ((endO)&&(total)) {
   if (startO) {var st=parseFloat(startO.value);}else{var st=0;}
   var end=parseFloat(endO.value);
   
   if ((st<0)&&(startO)) {startO.value=0;}
   if (end<0) endO.value=0;
   
   if ((!isNaN(st))&&(!isNaN(end))&&(st<=end)) total.value=end-st;
   else total.value="";
  }
  
 return;
}



function checkMandatory() {
	var msg="";
	
	if (msg != "") {
		alert(msg);
		return false;
	} else {
		return true;
	}

}


function onUpdate() {
	if (!checkMandatory()) return false 
	return update1_click();
}
	

document.body.onload=BodyLoadHandler;
