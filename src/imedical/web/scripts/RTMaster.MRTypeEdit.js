// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function CheckMatch(ExistingMRTypes) {
	var currMRType="";
	var currMRNo="";
	var returnval="";
	var cTypeObj=document.getElementById("TYPDesc");
	if (cTypeObj) currMRType=cTypeObj.value;
	var cMRNoObj=document.getElementById("RTMASMRNo");
	if (cMRNoObj) currMRNo=cMRNoObj.value;
	
	// cjb 25/08/2003 38372 changed delim from , to : as TYPDesc is now a string containing all the linked types separated by ,  (...)
	var TypeListArry=ExistingMRTypes.split(":");
	for (var i=0; i<TypeListArry.length; i++) {
		var ExistingTypes=mPiece(TypeListArry[i],"^",0)
		var ExistingNumber=mPiece(TypeListArry[i],"^",1)
		//alert(currMRType);

		//alert(currMRType+"-"+i);
		
		//alert(ExistingTypes+"/"+ExistingNumber+"***"+currMRType+"/"+currMRNo);
		
		// cjb 25/08/2003 38372 - ExistingTypes is now a string containing all the linked types separated by , so need to loop through them all
		var TypeArry=ExistingTypes.split(", ");
		
		for (var j=0; j<TypeArry.length; j++) {
			var ExistingType=TypeArry[j]
		
			//alert(ExistingType+"/"+ExistingNumber+"***"+currMRType+"/"+currMRNo);
			if ((currMRType!="") && (currMRNo!="")) {
				if ((ExistingType.toUpperCase()==currMRType.toUpperCase()) && (ExistingNumber.toUpperCase()==currMRNo.toUpperCase())) {
					alert(t['MRNO_EXISTS']);
					returnval="true"
					//return true;
				//}else {
				//	return false;
				}
			}
		}
	}
	if (returnval=="true") {
		return true;
	} else {
		return false;
	}
}
function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];		
    }
}

function UpdateClickHandler() {
	var Found=false;
	var mrObj=document.getElementById("MRTypes");
	if (mrObj) {
		//alert(mrObj.value);
		var str=mrObj.value;
		if (str!="") {
			var Found=CheckMatch(str);
		}

	}
	
	// cjb 09/11/2006 61230
	var obj=document.getElementById("TYPDesc");
	if ((obj)&&(obj.value=="")) {
		alert("\'" + t['TYPDesc'] + "\' " + t['XMISSING']);
		return false;
		
	}
	
	//alert(location.href);
	if (Found==false) Update_click();
	return;
}

function ActiveType() {
	
	if (confirm(t['ActiveType'])) {
		var frm=document.forms['fRTMaster_MRTypeEdit'];
		if (frm) frm.TOVERRIDE.value=1;
		var ActiveType=document.getElementById("ActiveType");
		if (ActiveType) {
			ActiveType.value=1;
		}
	}
}



var uobj=document.getElementById("Update");
if (uobj) uobj.onclick=UpdateClickHandler;

	
