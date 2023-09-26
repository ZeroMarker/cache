// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function ContractCareBodyLoadHandler() {
	//alert("body loader");
    //md
    obj=document.getElementById('CONTCAREDateFrom');
	if (obj) obj.onchange=CodeTableValidationDate;
	
    obj=document.getElementById('CONTCAREDateTo');
	if (obj) obj.onchange=CodeTableValidationDate;
    
    //md
	var obj = document.getElementById("update1")
	obj.onclick = UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	var obj = document.getElementById("delete1")
	obj.onclick = DeleteClickHandler;
	if (tsc['delete1']) websys_sckeys[tsc['delete1']]=DeleteClickHandler;
}

function OldUpdateClickHandler() {
	var obj=document.forms['fPAAdmContractCare_Edit'].elements['TWKFLI'];
	if (obj) obj.value-=1;
   	return update1_click();
}

function UpdateClickHandler() {
	var mok=1
	try {
		if (!(CustomUpdateClickHandler()))  { mok=0; }
	} catch(e) { 
				 
		}	finally  {
	if (!mok) return false;
	var obj=document.forms['fPAAdmContractCare_Edit'].elements['TWKFLI'];
	if (obj) obj.value-=1;
   	return update1_click();
	}
}

function DeleteClickHandler() {
	var obj=document.forms['fPAAdmContractCare_Edit'].elements['TWKFLI'];
	if (obj) obj.value-=1;
   	return delete1_click();
}

function ContractTypeSelect(str) {
	try {
		Custom_ContractTypeSelect(str);
	} catch(e) { 
		}	finally  {
	}

}	


function CodeTableValidationDate(e) {
	
	var eSrc=websys_getSrcElement(e);
	//alert(eSrc.id);
	if (eSrc.id=="CONTCAREDateFrom") {CONTCAREDateFrom_changehandler(e);}
	if (eSrc.id=="CONTCAREDateTo") {CONTCAREDateTo_changehandler(e);}
	
	
	
	var CONTCAREDateFrom;
	var CONTCAREDateTo;
	
	var obj;
	
	obj=document.getElementById('CONTCAREDateFrom');
	if ((obj)&&(obj.value!="")) {
		var CONTCAREDateFrom=DateStringTo$H(obj.value);
	}
	obj=document.getElementById('CONTCAREDateTo');
	if ((obj)&&(obj.value!="")) {
		var CONTCAREDateTo=DateStringTo$H(obj.value);
	}
	
	obj=document.getElementById('CheckDate');
	//have to initiate CTVdate to $h in case of clearing values in target date fields
	if (obj) { obj.value=DateStringTo$HToday() };
	if ((obj)&&(obj.value!="")) {
		if ((CONTCAREDateFrom)&&(CONTCAREDateFrom.value!="")) {
			obj.value=CONTCAREDateFrom;
		}
		if ((CONTCAREDateTo)&&(CONTCAREDateTo.value!="")) {
			obj.value=CONTCAREDateTo;
		}
		
	}
	
	//alert(obj.value);
	
}


document.body.onload=ContractCareBodyLoadHandler;
