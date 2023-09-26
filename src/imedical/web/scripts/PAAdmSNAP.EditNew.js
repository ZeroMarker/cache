// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function SNAPBodyLoadHandler() {
	var obj= document.forms['fPAAdmSNAP_EditNew'].elements['ID'];
	var form2=document.forms['fPAAdmSNAPDetails_Edit']
	if (form2) {
	var objkid=form2.elements['ID'];
		   }
	var obj1=document.getElementById("PAADMAdmDate");
	var obj2=document.getElementById("PAADMDischgDate");
	var obj3=document.getElementById("IPATDesc");
	if (obj1) FieldShow(obj1,1);
	if (obj2) FieldShow(obj2,1);
	if (obj3) FieldShow(obj3,1);
	
	var obju1 = document.getElementById("update1");
	var obju5 = document.getElementById("update5");
		
	if (obju1) obju1.disabled=false;
	if (obju5) {
			obju5.disabled=true;
			obju5.onclick=LinkDisable;
	   	    	   }	
		
	if ((obju5)&&(obju5.disabled==false))
		{
		obju5.onclick = Update5ClickHandler;
		if (tsc['update5']) websys_sckeys[tsc['update5']]=Update5ClickHandler;	
		}
	if ((obju1)&&(obju1.disabled==false))
		{
		obju1.onclick = Update1ClickHandler;
		if (tsc['update1']) websys_sckeys[tsc['update1']]=Update1ClickHandler;	
		}
	
	//md 15/12/2003
	var obj1=document.getElementById('SNAPCTCode');
	var obj2=document.getElementById('ADLCTDesc');
	var objsnlink=document.getElementById('SNAPNumberLink');
	var obj= document.forms['fPAAdmSNAP_EditNew'].elements['ID'];
	if ((obj)&&(obj.value!="")) {
	if (obj1) {
	obj1.disabled=true;
	if (document.getElementById('ld1858iSNAPCTCode'))  var killed=document.getElementById('ld1858iSNAPCTCode').removeNode(false);
	}
	if (obj2) {
	obj2.disabled=true
	if (document.getElementById('ld1858iADLCTDesc'))  var killed=document.getElementById('ld1858iADLCTDesc').removeNode(false);
	}
	}
	if ((obj)&&(obj.value!="")&&(objsnlink)&&(objsnlink.value=="")) {
	makeReadOnly();
	if (obju1) {
			obju1.disabled=true;
			obju1.onclick=LinkDisable;
	   	    	   }	
	}
	//md 15/12/2003
	var obj=document.getElementById('SNAPCTCode');
	if (obj) obj.onblur=SNAPCTChangeHandler;
	var obj=document.getElementById('ADLCTDesc');
	if (obj) obj.onblur=SNAPCTChangeHandler;
	var obj=document.getElementById('SNAPStartDate');
	if (obj) obj.onblur=SNAPSDHandler;
	var obj=document.getElementById('SNAPEndDate');
	if (obj) obj.onblur=SNAPEDHandler;

	//md
	obj=document.getElementById('SNAPStartDate');
	if (obj) obj.onchange=CodeTableValidationDate;
	
    	obj=document.getElementById('SNAPEndDate');
	if (obj) obj.onchange=CodeTableValidationDate;
    
    //md
	
}

function Update5ClickHandler() {
	
	
	makeUpdateEnabled();
	var obj=document.forms['fPAAdmSNAP_EditNew'].elements['TWKFLI'];
	if (obj) obj.value-=1;
   	return update5_click();
}

function Update1ClickHandler() {

	//alert("update click");
	var obj1=document.getElementById("PAADMAdmDate");
	var obj2=document.getElementById("PAADMDischgDate");
	var obj3=document.getElementById("IPATDesc");
	var obj4=document.getElementById('SNAPCTCode');
	var obj5=document.getElementById('ADLCTDesc');
	if (obj1) FieldShow(obj1,2);
	if (obj2) FieldShow(obj2,2);
	if (obj3) FieldShow(obj3,2);
	if (obj4) FieldShow(obj4,2);
	if (obj5) FieldShow(obj5,2);
	//makeUpdateEnabled();
	var obj=document.forms['fPAAdmSNAP_EditNew'].elements['TWKFLI'];
	if (obj) obj.value-=1;
   	return update1_click();
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	//if (el.id=="ViewableBy") VIEWABLE=el;
	if (el.disabled) {
		return false;
	}
	return true;
}

function FieldShow(obj,way) {
			
	if (way==1) {
	if (obj) {obj.disabled=true;}
		    }	
	if (way==2) {
	if (obj) {obj.disabled=false;}
 	            }	
} 
function ADLCareTypeLookup(str) {
	var lu = str.split("^");
	var obj=document.getElementById("ADLCTDesc");
	if (obj) obj.value=lu[0];
	var obj1=document.getElementById("ADLCareType");
	if (obj1) obj1.value = lu[2];
	return true;
}
function SNAPCareTypeLookup(str) {
	var lu = str.split("^");
	var obj=document.getElementById("SNAPCTCode");
	if (obj) obj.value=lu[0];
	SNAPCareTypeHandler();	
	return true;
}


function SNAPCareTypeHandler() {
	var obj=document.getElementById('SNAPCTCode');
	var obj1=document.getElementById('ADLCTDesc');
	var obj2=document.getElementById('ADLCareType');
	
	if((obj)&&(obj.defaultValue!=obj.value)&&(obj1)&&(obj1.disabled!=true)) {
	if (obj1) obj1.value="";
	if (obj2) obj2.value="";
	obj.defaultValue=obj.value
	}
}

function SNAPCTChangeHandler(e) {
	// clear the  fields on blank.
	var obj=document.getElementById("SNAPCTCode");
	var obj1=document.getElementById("ADLCTDesc");
	var obj2=document.getElementById("ADLCareType");
	if ((obj)&&(obj1)&&(obj.value=="")&&(obj1.disabled!=true)) {
	obj1.value ="";
	obj.defaultValue=obj.value;
	}
	if ((obj1)&&(obj1.value=="")&&(obj2)) {obj2.value ="";}
}

function SNAPSDHandler(e) {
	var obj=document.getElementById("SNAPStartDate");
	var obj1=document.getElementById("PAADMAdmDate");
	if ((obj)&&(obj1)&&(obj.value=="")) {
	obj.value=obj1.value;
	obj.defaultValue=obj.value;
	CodeTableValidationDate(e);
	}
}
function SNAPEDHandler(e) {
	var obj=document.getElementById("SNAPEndDate");
	var obj1=document.getElementById("PAADMDischgDate");
	if ((obj)&&(obj1)&&(obj.value=="")) {
	obj.value=obj1.value;
	obj.defaultValue=obj.value;
	CodeTableValidationDate(e);
	}
	
}



function makeReadOnly(){
	var el=document.forms["fPAAdmSNAP_EditNew"].elements;
	for (var i=0;i<el.length;i++) {
			if (!(el[i].type=="hidden")) {
			//if (el[i].tagName=="A") {
			el[i].disabled=true
			}
	}

	var arrLookUps=document.forms["fPAAdmSNAP_EditNew"].getElementsByTagName("IMG");
	for (var i=0; i<arrLookUps.length; i++) {
			if ((arrLookUps[i].id)&&(arrLookUps[i].id.charAt(0)=="l"))
			arrLookUps[i].disabled=true;
	}

}

function makeUpdateEnabled(){
	var el=document.forms["fPAAdmSNAP_EditNew"].elements;
	for (var i=0;i<el.length;i++) {
			if (!(el[i].type=="hidden")) {
			//if (el[i].tagName=="A") {
			el[i].disabled=false
			}
	}
	
}



function CodeTableValidationDate(e) {
	
	//obj=document.getElementById('SNAPStartDate');
	//obj=document.getElementById('SNAPEndDate');


		
	var eSrc=websys_getSrcElement(e);
	//alert(eSrc.id);
	if (eSrc.id=="SNAPStartDate") {SNAPStartDate_changehandler(e);}
	if (eSrc.id=="SNAPEndDate") {SNAPEndDate_changehandler(e);}
	
	
	
	var SNAPStartDate;
	var SNAPStartDate;
	
	var obj;
	
	obj=document.getElementById('SNAPStartDate');
	if ((obj)&&(obj.value!="")) {
		var SNAPStartDate=DateStringTo$H(obj.value);
	}
	obj=document.getElementById('SNAPEndDate');
	if ((obj)&&(obj.value!="")) {
		var SNAPEndDate=DateStringTo$H(obj.value);
	}
	
	obj=document.getElementById('CheckDate');
	//have to initiate CTVdate to $h in case of clearing values in target date fields
	if (obj) { obj.value=DateStringTo$HToday() };
	if ((obj)&&(obj.value!="")) {
		if ((SNAPStartDate)&&(SNAPStartDate.value!="")) {
			obj.value=SNAPStartDate;
		}
		if ((SNAPEndDate)&&(SNAPEndDate.value!="")) {
			obj.value=SNAPEndDate;
		}
		
	}
	
	//alert(obj.value);
	
	
}

document.body.onload=SNAPBodyLoadHandler;
