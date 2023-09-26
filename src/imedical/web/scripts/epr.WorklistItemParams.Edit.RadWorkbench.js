//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function BodyLoadHandler() {
	var obj=document.getElementById("update1");
	if (obj) obj.onclick=UpdateClickHandler;
	var lochk=document.getElementById("WIPLogonLoc");
	var loc=document.getElementById("WIPLocationDR");
	if ((lochk) && (lochk.checked==false)) {
		loc.required=true;
	}
	var obj=document.getElementById("ARCIMDesc");
	if (obj) obj.onblur=OrderItemBlurHandler
}

function UpdateClickHandler() {
	var statuslist=document.getElementById("RadStatus");
	return update1_click();
}

function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}

function OrderItemLookup(txt) {
	var adata=txt.split("^");
	var iobj=document.getElementById("ARCIMDesc");
	if (iobj) iobj.value=adata[0];
	var obj=document.getElementById("WIPARCIMDR");
	if (obj) obj.value=adata[1];
}

function OrderItemBlurHandler(e) {
	var obj=document.getElementById("ARCIMDesc");
	if ((obj)&&(obj.value=="")) {
		var arcim=document.getElementById("WIPARCIMDR");
		if (arcim) arcim.value="";
	}
}

/*
function setRadStatList() {
 // sets selected referral statuses
 var rarysel;
 var rstat=document.getElementById("WipRadStatus");
 var RefList=document.getElementById("RadStatus");

 if ((rstat)&&(RefList)&&(rstat.value!="")) {
  var refary=rstat.value.split("^");

  for (var i=0;i<RefList.options.length;i++) {
	for (var j=0; j<refary.length; j++) {
		if(RefList.options[i].value==refary[j])
			RefList.options[i].selected=true;
  }
 }
 return;
}


function RadStatSelectHandler() {
 // builds rstat string to save multiple ref statuses
 var rstat=document.getElementById("WipRadStatus");
 var RefList=document.getElementById("RadStatus");
 var rst="";

 if ((RefList)&&(rstat)) {
    for (var i=0;i<RefList.options.length;i++) {
      if (RefList.options[i].selected==true)
	      rst=rst+RefList.options[i].value+"^";
    }
    rstat.value=rst;
    alert(rstat.value);
 }
 return;
}
*/

document.body.onload=BodyLoadHandler;
