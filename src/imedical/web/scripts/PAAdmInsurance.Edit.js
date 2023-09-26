// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function Init() {
	var obj;
		
	obj=document.getElementById('INSDateValidFrom');
	if (obj) obj.onchange=CodeTableValidationDate;
		
	
	obj=document.getElementById('INSDateValidTo');
	if (obj) obj.onchange=CodeTableValidationDate;
	
	obj=document.getElementById('INSDateTypeFrom');
	if (obj) obj.onchange=CodeTableValidationDate;
	
	obj=document.getElementById('INSDateTypeTo');
	if (obj) obj.onchange=CodeTableValidationDate;

	obj=document.getElementById('INSTDesc');
	if (obj) obj.onBlur=PayorChangeHandler;
	if (obj) obj.onBlur=PayorChangeHandlerNew;
	
	//md 03/02/2005 Log 49500
	obj = document.getElementById("INSRank");
	if (obj) obj.onchange = ResetHiddenRank;
	
	// cjb 18/08/2003 38254 stay on the csp page when you delete
	obj = document.getElementById("delete1");
	if (obj) obj.onclick = DeleteClickHandler;
	
	// SB 03/03/04 (36744): If no payor/plan selected then disable the BillGrpLimit link
 	objAUX=document.getElementById("AUXITDesc")
	objINST=document.getElementById("INSTDesc")
	obj=document.getElementById("ID")

	if ((obj)&&(obj.value=="")&&(objAUX)&&(objINST)&&(objAUX.value=="")&&(objINST.value=="")) {
			var objBillGrpLimit=document.getElementById("BillGrpLimit");
			if (objBillGrpLimit) {
				objBillGrpLimit.disabled=true;
				objBillGrpLimit.onclick=BillGrpLimitClickHandler;
			}
 	}
	if ((obj)&&(obj.value=="")) {
			var InsuranceContacts=document.getElementById("InsuranceContacts");
			if (InsuranceContacts) {
				InsuranceContacts.disabled=true;
				InsuranceContacts.onclick=BillGrpLimitClickHandler;
			}
	}
	
	//obj = document.getElementById("update1");
	//obj.onclick = UpdateClickHandler;
	//when edit comp is used in paadinsurance.csp this update1 conflicts with update1 from paadminsurance.list
	var frm=document.forms['fPAAdmInsurance_Edit'];
	var arrEl=frm.getElementsByTagName("A");
	for (i in arrEl) {
		if (arrEl[i].id=="update1") arrEl[i].onclick = UpdateClickHandler;
	}
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	
	//SB 7/04/04: set bolding of child table links
	objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		obj=document.getElementById('BillGrpLimit');
		if ((obj) && (BoldLink[0]=="1")) obj.style.fontWeight="bold";
		obj=document.getElementById('InsuranceContacts');
		if ((obj) && (BoldLink[1]=="1")) obj.style.fontWeight="bold";
	}
}

function BillGrpLimitClickHandler() {
	return false;
}	

function UpdateClickHandler() {
	/*alert("updatehere");
	if (document.forms["fPAAdmInsurance_List"]) {
		alert("inside");
		var frm = document.forms["fPAAdmInsurance_Edit"];
		frm.target = "_parent";
	}
	*/
	
	// cjb 22/12/2004 47976 - if there are mandatory fields that are not completed, quit here (don't set the workflow item to -1)
	if (!fPAAdmInsurance_Edit_submit()) return false;
	
	var obj=document.forms['fPAAdmInsurance_Edit'].elements['TWKFLI'];
	if (obj.value!="") obj.value-=1;
	
	//19.07.05 - 49775
	if (!ValidateDateToDateFrom("INSDateValidFrom")) return false;
	if (!ValidateDateToDateFrom("INSDateValidTo")) return false;
	if (!ValidateDateToDateFrom("INSDateTypeFrom")) return false;
	if (!ValidateDateToDateFrom("INSDateTypeTo")) return false;

	return update1_click();
}

// cjb 18/08/2003 38254 stay on the csp page when you delete
function DeleteClickHandler() {
	//alert("DeleteClickHandler");
	var obj=document.forms['fPAAdmInsurance_Edit'].elements['TWKFLI'];
	if (obj.value!="") obj.value-=1;
	
	return delete1_click()
}

function PayorChangeHandler() {
	alert("PayorChangeHandler");
	var obj=document.getElementById("AUXITDesc")
	if (obj) obj.value="";
	obj=document.getElementById("INSASDesc")
	if (obj) obj.value="";
	obj=document.getElementById("INSCardNo")
	if (obj) obj.value="";
}

function PayorChangeHandlerNew() {
	alert("PayorChangeHandlerNew");
	var obj=document.getElementById("INSTDesc");
	var obj1=document.getElementById("CTPMDesc");
	if ((obj)&&(obj.value=="")) {
		if (obj1) obj1.innerText="";
	}
}

function PlanLookupSelect(str) {
	//alert(str);
 	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("AUXITDesc")
	if ((obj)&&(lu[0])) obj.value = lu[0];
 	obj=document.getElementById("INSTDesc")
	if ((obj)&&(lu[1])) obj.value = lu[1];
	// Uncomment the following two lines if you want the Insurance Card Number populated automatically (if it is available)
 	//obj=document.getElementById("INSCardNo")
	//if ((obj)&&(lu[4])) obj.value = lu[4];
	obj=document.getElementById("INSTRowID")
	if ((obj)&&(lu[0])) obj.value = lu[3];	

	//log 64427
	var Payor="";
	var Plan="";
	var Hospital="";
	var InsurPayorobj=document.getElementById('INSTDesc');
	var InsurPlanobj=document.getElementById('AUXITDesc');
	var HOSPDescobj=document.getElementById('HOSPDesc');
	if (InsurPayorobj) Payor=InsurPayorobj.value;
	if (InsurPlanobj) Plan=InsurPlanobj.value;
	if (HOSPDescobj) Hospital=HOSPDescobj.value;
	var office=tkMakeServerCall("web.ARCInsurAssociation","FindByPayorPlan",Payor,Plan,Hospital);

	   var InsurOfficeobj=document.getElementById('INSASDesc');
	   //Log 65113 - 05.10.2007 - assign the default office ONLY if its set up in the code tables.
	   if ((InsurOfficeobj)&&(office!="")&&(InsurOfficeobj.value=="")) InsurOfficeobj.value=office;
 }

function PayorLookupSelect(str) {
	var lu = str.split("^");
	var obj;
 	obj=document.getElementById("INSTDesc")
	if ((obj)&&(lu[0])) obj.value = lu[0];
	obj=document.getElementById("CTPMDesc")
	if (obj) obj.innerText = lu[4];
	obj=document.getElementById("INSTRowID")
	if ((obj)&&(lu[0])) obj.value = lu[1];
 }

//Log 64705 - 06.11.2007
function PayorOffLookupSelect(str) {
	var lu = str.split("^");
	var billaddress="";
	var phoneno="";
	
	if (lu[3]!="") {billaddress=lu[3];}
	if (lu[4]!="") {phoneno=lu[4];}
	
	var obj=document.getElementById("OffBillAdd");
	if (obj) obj.value = billaddress;
	var obj1=document.getElementById("OffTel");
	if (obj1) obj1.value = phoneno;
}

function payorByLookUp() {
	// a dummy function to allow a custom payorByLookUp funtion to be used
}

function BodyUnloadHandler(e) {
	if (self == top) {
		var win=window.opener;
		if (win) {

			var path="websys.default.csp?WEBSYS.TCOMPONENT=PAAdmInsurance.List&ID=";

			var obj=document.getElementById("PARREF");
			if (obj) path+="&EpisodeID="+obj.value;
			var obj=document.getElementById("PatientID");
			if (obj) path+="&PatientID="+obj.value;
			var obj=win.document.getElementById("TWKFL");
			if ((obj)&&(obj.value!="")) path+="&CONTEXT=W"+obj.value;
			if (obj) path+="&TWKFL="+obj.value;
			var obj=win.document.getElementById("TWKFLI");
			if (obj) path+="&TWKFLI="+(obj.value-1);
			//alert(path)
			win.location = path;
		}
	}
}

// cjb 07/08/2003 38067 - copied from PAPerson.Edit.js and removed other fields
// Geographic Information

function CityLookupSelect(str) {
	//zipcode^suburb^state^address
 	var lu = str.split("^");
	var obj=document.getElementById("CTZIPCode")
	if (obj) obj.value = lu[0];
 	var obj1=document.getElementById("CTCITDesc")
	if (obj1) obj1.value = lu[1];

}

function ZipLookupSelect(str) {
	//zipcode^suburb^state^address
	var lu = str.split("^");
	var obj1=document.getElementById("CTZIPCode")
	if (obj1) obj1.value = lu[0];
 	var obj=document.getElementById("CTCITDesc")
	if (obj) obj.value = lu[1];
}

function CodeTableValidationDate(e) {
	
	var eSrc=websys_getSrcElement(e);
	//alert(eSrc.id);
	if (eSrc.id=="INSDateValidFrom") { INSDateValidFrom_changehandler(e); }
	if (eSrc.id=="INSDateValidTo")   { INSDateValidTo_changehandler(e); }
	if (eSrc.id=="INSDateTypeFrom")  { INSDateTypeFrom_changehandler(e); }
	if (eSrc.id=="INSDateTypeTo")    { INSDateTypeTo_changehandler(e); }

	if (!ValidateDateToDateFrom(eSrc.id)) return false; //19.07.05 - 49775
	
	var INSDateValidFrom;
	var INSDateValidTo;
	var INSDateTypeFrom;
	var INSDateTypeTo;
	var obj;

	obj=document.getElementById('INSDateValidFrom');
	if ((obj)&&(obj.value!="")) {
		var INSDateValidFrom=DateStringTo$H(obj.value);
	}
	obj=document.getElementById('INSDateValidTo');
	if ((obj)&&(obj.value!="")) {
		var INSDateValidTo=DateStringTo$H(obj.value);
	}
	obj=document.getElementById('INSDateTypeFrom');
	if ((obj)&&(obj.value!="")) {
		var INSDateTypeFrom=DateStringTo$H(obj.value);
	}
	obj=document.getElementById('INSDateTypeTo');
	if ((obj)&&(obj.value!="")) {
		var INSDateTypeTo=DateStringTo$H(obj.value);
	}
	
	obj=document.getElementById('CodeTableValidationDate');
	//have to initiate CTVdate to $h in case of clearing values in target date fields
	if (obj) { obj.value=DateStringTo$HToday(); }

	if ((obj)&&(obj.value!="")) {
		if ((INSDateValidFrom)&&(INSDateValidFrom.value!="")) {
			obj.value=INSDateValidFrom;
		}
		if ((INSDateValidTo)&&(INSDateValidTo.value!="")) {
			obj.value=INSDateValidTo;
		}
		if ((INSDateTypeFrom)&&(INSDateTypeFrom.value!="")) {
			obj.value=INSDateTypeFrom;
		}
		if ((INSDateTypeTo)&&(INSDateTypeTo.value!="")) {
			obj.value=INSDateTypeTo;
		}
	}

	/*
	obj=document.getElementById('AUXITDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('INSASDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('INSTDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('CARDDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('CTRLTDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('CTCITDesc')
	if (obj) obj.onchange();
	obj=document.getElementById('CTZIPCode')
	if (obj) obj.onchange();	
       */
	
	
	// ab 10.05.04 - 43798 - go back to the original next focus
	//if (eSrc) { websys_nextfocus(eSrc.tabIndex);}
	
	
}

//19.07.05 - 49775
function ValidateDateToDateFrom(editingFieldName) {
	var isTo=false;
	var field;
	var obj=document.getElementById(editingFieldName);
	var idx=0;
	if ((idx=editingFieldName.indexOf("To"))!=-1) {
		if (idx==(editingFieldName.length-2)) {
			field=editingFieldName.substring(0,idx);
			isTo=true;
		}
	}
	else if ((idx=editingFieldName.indexOf("From"))!=-1) {
		if (idx==(editingFieldName.length-4)) {
			field=editingFieldName.substring(0,idx);
		}
	}
	else {
		return true; //dont bother
	}

	if (field==null) return true;

	var objFromField=document.getElementById(field+"From");
	var objToField=document.getElementById(field+"To");

	if (objFromField==null||objToField==null) return true; //dont bother

	var DateFrom=objFromField.value;
	var DateTo=objToField.value;

	if ((DateFrom!="")&&(DateTo!="")&&(DateStringCompare(DateFrom,DateTo)==1)) {

		var lblFrom=""; var lblTo="";
		var lbl=document.getElementById("c"+field+"From");
		if (lbl) lblFrom="'"+lbl.innerText+"'";		
		lbl=document.getElementById("c"+field+"To");
		if (lbl) lblTo="'"+lbl.innerText+"'";

		if (lblFrom=="") lblFrom="'"+field+"From'";
		if (lblTo=="") lblTo="'"+field+"To'";

		if (isTo)
			alert(lblTo + " cannot be before " + lblFrom);
		else 
			alert(lblFrom + " cannot be after " + lblTo);

		obj.className="clsInvalid";
		return false;
	}

	return true;
}

function ResetHiddenRank() {
	var obj=document.getElementById('INSRank');
	var obj1=document.getElementById('INSRankHidden');
	if ((obj)&&(obj1)) { obj1.value=obj.value; }
}



document.body.onload=Init;
//document.body.onunload=BodyUnloadHandler;


