// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function SNAPDetailsBodyLoadHandler() {
	CheckForPaliative();
	var obj=document.getElementById('ADLSubType');
	if (obj) obj.onblur=ADLSubTypeChangeHandler;
	var obj1=document.getElementById('SNAPDScore');
	//if ((obj1)&&(obj1.value=="")&&(obj)&&(obj.value=="")) obj1.disabled=true;
	if ((obj1)&&(obj1.value!="")) { SNAPDScoreChangeHandler(null);}		
	if (obj1) obj1.onblur=SNAPDScoreChangeHandler;
	if ((obj)&&(obj1)&&(obj.value!="")) {labelMandatory('SNAPDScore')};
	
	obj=document.getElementById('updateD');
	if (obj) obj.onclick = UpdateSNAPDetail;
	if (tsc['updateD']) websys_sckeys[tsc['updateD']]=UpdateSNAPDetail;

	obj=document.getElementById('Next');
	if (obj) obj.onclick = NextSNAPDetail;
	if (tsc['updateD']) websys_sckeys[tsc['Next']]=NextSNAPDetail;

	//md
	obj=document.getElementById('SNAPDDate');
	if (obj) obj.onchange=DetailsCodeTableValidationDate;
	//
	
			
}

function ADLSubTypeSelect(str) {
	var lu = str.split("^");
	var obj=document.getElementById("ADLSubType");
	if (obj) obj.value=lu[0];
	var obj1=document.getElementById("ADLMinScore");
	if (obj1) obj1.value = lu[3];
	var obj2=document.getElementById("ADLMaxScore");
	if (obj2) obj2.value = lu[4];
	var obj3=document.getElementById('SNAPDScore'); 
	if (obj3) {
	obj3.value=""
	obj3.disabled=false;
	labelMandatory('SNAPDScore')
	//websys_nextfocus(obj1.sourceIndex);
	//websys_setfocus('SNAPDScore')
	//websys_setfocus(obj3.id) 
		  }
	//return true;
}

function ADLSubTypeChangeHandler(e) {
	// clear max/min score if ADLSubType is blank
	var obj=document.getElementById("ADLSubType");
	if ((obj)&&(obj.value=="")) {
	obj=document.getElementById("ADLMinScore")
	if (obj) obj.value ="";
	obj=document.getElementById("ADLMaxScore");
	if (obj) obj.value ="";
	var obj3=document.getElementById('SNAPDScore');
	if (obj3) {
	obj3.value="";
	//obj3.disabled=true;
	//labelNormal('SNAPDScore')
		  }
	var obj4=document.getElementById('Conversion');
	if (obj4) obj4.value ="";
 	}

}

function SNAPDScoreChangeHandler(e) {
	var obj=document.getElementById("SNAPDScore");
	var objc=document.getElementById("Conversion");
	var objmins=document.getElementById("ADLMinScore");
	var objmaxs=document.getElementById("ADLMaxScore");
	if ((obj)&&(obj.value!="")) {
	 if ((objmins)&&(objmaxs))
	  {
	    if (((objmins.value!="")&&(eval(obj.value)<eval(objmins.value)))||((objmaxs.value!="")&&(eval(obj.value)>eval(objmaxs.value))))
	    {alert(t['OutOfRange']);
	    obj.className='clsInvalid';
	    return false;
	    }
	  }
	 var obj1=document.getElementById("converttoFIM")
	 var obj2=document.getElementById("displayconverted");
	 if ((obj1)&&(obj2)&&(obj1.value=="Y")&&(obj2.value=="Y")&&(objc))  {objc.value=Math.round(18+(0.67*obj.value));}
		}
 	 if ((obj)&&(obj.value=="")&&(objc)) {objc.value="";}
	   			    
	  return true;
}
function CheckForPaliative() {
//dummy function for custom
}
function UpdateSNAPDetail(evt) {
	if (!CheckMandatorySNAPDetails()) { return false; }
	if (!SNAPDScoreChangeHandler(null)) return false;
	makeUpdateEnabled();
	return updateD_click();
	
}

function NextSNAPDetail(evt) {
	if (!CheckMandatorySNAPDetails()) { return false; }
	if (!SNAPDScoreChangeHandler(null)) return false;
	makeUpdateEnabled();
	return Next_click();
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		}
}
function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";
		if (lbl) lbl = lbl.className = "";
	}
}
function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl=lbl.className = "";
	}
}


function makeUpdateEnabled(){
	var el=document.forms["fPAAdmSNAPDetails_Edit"].elements;
	for (var i=0;i<el.length;i++) {
			if (!(el[i].type=="hidden")) {
			//if (el[i].tagName=="A") {
			el[i].disabled=false
			}
	}
	return true;

}

function CheckMandatorySNAPDetails() {
	var msg="";
	var objph=document.getElementById('SNAPDPhase');
	var objphl = document.getElementById('cSNAPDPhase')
	var objsc=document.getElementById('SNAPDScore');
	var objscl=document.getElementById('cSNAPDScore');
	
	if ((objph)&&(objphl)&&(objph.value=="")&&(objphl.className=="clsRequired")) {
	msg += "\'" + t['SNAPDPhase'] + "\' " + t['XMISSING'] + "\n";
	}

	if ((objsc)&&(objscl)&&(objsc.value=="")&&(objscl.className=="clsRequired")) {
	msg += "\'" + t['SNAPDScore'] + "\' " + t['XMISSING'] + "\n";
	}

	
	
	if (msg != "") {
		alert(msg)
		return false;
	} else {
		return true;
	}
}


function DetailsCodeTableValidationDate(e) {
	
	
		
	var eSrc=websys_getSrcElement(e);
	//alert(eSrc.id);
	if (eSrc.id=="SNAPDDate") {SNAPDDate_changehandler(e);}
		
	
	var SNAPDDate;
	
	
	var obj;
	
	obj=document.getElementById('SNAPDDate');
	if ((obj)&&(obj.value!="")) {
		var SNAPDDate=DateStringTo$H(obj.value);
	}
	
	
	obj=document.getElementById('CheckDate');
	//have to initiate CTVdate to $h in case of clearing values in target date fields
	if (obj) { obj.value=DateStringTo$HToday() };
	if ((obj)&&(obj.value!="")) {
		if ((SNAPDDate)&&(SNAPDDate.value!="")) {
			obj.value=SNAPDDate;
		}

	}
	
	//alert(obj.value);
	
	
}


document.body.onload=SNAPDetailsBodyLoadHandler;
