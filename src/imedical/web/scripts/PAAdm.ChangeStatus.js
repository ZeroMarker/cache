var newStatusCode="";
var presentStatusCode="";
var updated=0;

function bodyLoadHandler() {
	var objPresent=document.getElementById("presentStatusCode");
	if (objPresent) presentStatusCode=objPresent.value;
	var obj=document.getElementById('update1');
	if (obj) obj.onclick=updateHandler;
   	if (self==top) websys_reSizeT();
}

function StatusLookUp(val) {
	ary=val.split("^");
	if (ary[1]==presentStatusCode) {
        var objStat=document.getElementById("Status");
		if (objStat) objStat.value="";
		newStatusCode=""
	} else {newStatusCode=ary[1];}
	try {
		Custom_StatusLookUp(val);
	} catch(e) { 
		}	finally  {
	}
}
function updateHandler() {
	var message="";
	var objStatus=document.getElementById("Status");

	try { 
		if((CheckHasPaymentTransaction()=="Y")&&(newStatusCode=="C")) {
			alert(t['HAS_TRANS']);
			return false;
		} 
	} catch(e) {}


	if (message=="")
	{
		//KK 16/5/03 L:34531
		if (newStatusCode=="C") {
			var objDRGDR=document.getElementById("DRGDR");
			if ((objDRGDR)&&(objDRGDR.value!="")) alert(t["DELETEDRG"]);
		}
       	updated=1;
	   	return update1_click();
     }else{
       	alert(message);
       	return false;
    }
}

document.body.onload=bodyLoadHandler;
