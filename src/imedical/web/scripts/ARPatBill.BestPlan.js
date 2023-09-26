// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var Gparam1="";
var Gparam2="";
var Gparam3="";
var Gparam4="";
var Gparam5="";
var Gparam6="";
var Gparam7="";
var Gparam8="";
var Gparam9="";
var Gparam10="";
var Gparam11="";
var Gparam12="";

var Aparam1="";
var Aparam2="";
var Aparam3="";
var Aparam4="";
var Aparam5="";
var Aparam6="";
var Aparam7="";
var Aparam8="";
var Aparam9="";
var Aparam10="";


var objSurname=document.getElementById("Surname");
var objFirstName=document.getElementById("FirstName");
var objDOB=document.getElementById("DOB");
var objExpAdmDate=document.getElementById("ExpAdmDate");
var objExpLenStay=document.getElementById("ExpLenStay");

function BodyLoadHandler() {
 	var obj=document.getElementById("DeletePlan");
 	if (obj) obj.onclick=DeletePlanClickHandler;

	obj=document.getElementById("Generate")
 	if (obj) obj.onclick=GenerateClickHandler;

	obj=document.getElementById("AddOrders")
	if (obj) obj.onclick=AddOrdersClickHandler;

	obj=document.getElementById("CancelQ")
	if (obj) obj.onclick=CancelQClickHandler;

	obj=document.getElementById("Close")
	if (obj) obj.onclick=CloseClickHandler;

	// Load the payor and plan from the database (for both current episode and existing quote)
	obj=document.getElementById("SavedPayorPlan")
	if ((obj)&&(obj.value!="")) LoadPayorPlanList(obj.value,"|");
}

function CancelQClickHandler(e) {

	var objQuoteID=document.getElementById("QuoteID");

	//if no quote id dont worry
	if (objQuoteID && objQuoteID.value=="") return false;

	var ret=confirm(t['CancelQuote1']+"\n"+t['CancelQuote2']);
	if (ret==false) return false;

	var QuoteID="";
	if (objQuoteID) QuoteID=objQuoteID.value;
	var UserCode="";
	var objUserCode=document.getElementById("UserCode");
	if (objUserCode) UserCode=objUserCode.value;
	var PIN="";
	var objPIN=document.getElementById("PIN");
	if (objPIN) PIN=objPIN.value;
	var url="arpatbill.bestplan.csp?DeleteQuoteID="+QuoteID+"&UserCode="+UserCode+"&PIN="+PIN;
        //Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"TRAK_main","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
}

function LoadPayorPlanList(PayorPlanStr,delim) {
	var objList=document.getElementById("SelectedPayorPlan");
	var PayorPlan="";
	if (objList) {
		for (var i=0;i<(PayorPlanStr.split(delim).length-1);i++) {
			PayorPlan=mPiece(PayorPlanStr,delim,i);
			objList.options[objList.length] = new Option(mPiece(PayorPlan,String.fromCharCode(1),0),mPiece(PayorPlan,String.fromCharCode(1),1));
		}
		//disable the payor/plan delete button if there is an EpisodeID
		var objEp = document.getElementById("EpisodeID");
		var obj=document.getElementById("DeletePlan");
		if ((objEp) && (objEp.value!="") && (obj)) {obj.onclick=""; obj.disabled=true;}
	}
}

function HiddenAddOrders_changehandler(encmeth) {
	var AQuoteStr=""
	AQuoteStr=cspRunServerMethod(encmeth,Aparam1,Aparam2,Aparam3,Aparam4,Aparam5,Aparam6,Aparam7,Aparam8,Aparam9,Aparam10);
	var adata=AQuoteStr.split("^");
	var AQuoteID=adata[0];
	var AQuoteNo=adata[1];

	//alert("AQuoteID " + AQuoteID + " AQuoteNo " + AQuoteNo);

	if (AQuoteID!="") {
		var objQuoteID=document.getElementById("QuoteID");
		if (objQuoteID) objQuoteID.value=AQuoteID;

		var objQuoteNo = document.getElementById("QuoteNo");
		if (objQuoteNo && AQuoteNo!="") objQuoteNo.innerText=AQuoteNo;

		var objOrdItm = document.getElementById("Item");
		var objOrdQty = document.getElementById("Quantity");
		var objOrdCat = document.getElementById("Category");
		var objOrdSub = document.getElementById("SubCategory");
		if (objOrdItm) objOrdItm.value="";
		if (objOrdQty) objOrdQty.value="";
		if (objOrdCat) objOrdCat.value="";
		if (objOrdSub) objOrdSub.value="";

		var obj = document.getElementById("EpisodeID");
		var EpisodeID="";
		if (obj)EpisodeID = obj.value;
		var context=session['CONTEXT'];

		var url='websys.default.csp?WEBSYS.TCOMPONENT=ARPatBill.BestPlanSelOrder.List&QuoteID='+AQuoteID+'&EpisodeID='+EpisodeID+'&CONTEXT='+context;
		//alert(url);

		websys_createWindow(url,'frmSelOrderList','');
	}
	else {
		// maybe we should display a warning message ??
	}
}

// must make sure the order item has been selected from lookup successfuly

function AddOrdersClickHandler(e) {

	//QuoteID OEOrdID OrderQty PatientID Surname FirstName DOB PayorPlan , ExpAdmDate  ExpLenStay  RoomTypeDR  HospitalDR  User
	var objQuoteID=document.getElementById("QuoteID");
	if (objQuoteID) Aparam1=objQuoteID.value;
	var objOrdId = document.getElementById("ItemMastDR");
	var objOrdQty = document.getElementById("Quantity");
	if (objOrdId && objOrdId.value!="") Aparam2=objOrdId.value;
	if (objOrdQty && objOrdQty!="") Aparam3=objOrdQty.value;
	if (Aparam1=="") {
		var objPatientID=document.getElementById("PatientID");
		if (objPatientID) Aparam4=objPatientID.value;
		if (objSurname) Aparam5=objSurname.value;
		if (objFirstName) Aparam6=objFirstName.value;
		if (objDOB) Aparam7=objDOB.value;
		Aparam8 = SetPayorPlanParam(false);
		if (Aparam8 == null) Aparam8="";
		var objPatientID=document.getElementById("PatientID");
		if (objPatientID) Aparam4=objPatientID.value;
		if (objExpAdmDate) Aparam9=objExpAdmDate.value;
		if (objExpLenStay) Aparam10=objExpLenStay.value;

	}
	if (Aparam2=="") {
		alert(t['EnterOrderFirst']);
		return false;
	}
	if (Aparam3=="") {
		alert(t['EnterQuantityFirst']);
		return false;
	}

	var objAddOrd=document.getElementById("HiddenAddOrders");
	if (objAddOrd) objAddOrd.onclick=objAddOrd.onchange;
	if (objAddOrd) objAddOrd.click();
}

function parseMarkup(str,tag) {

	var endtag="</"+tag.substring(1,tag.length);

	if (str.search(tag)!= -1) {
		var i=str.indexOf(tag);
		var j=str.indexOf(endtag);
		var value = str.substring(i+ tag.length,j);
		return value;
	}
	return null;
}

function HiddenGenerate_changehandler(encmeth) {
	// will come here only if it's not an existing episode

	var ReturnStr=cspRunServerMethod(encmeth,Gparam1,Gparam2,Gparam3,Gparam4,Gparam5,Gparam6,Gparam7,Gparam8,Gparam9,Gparam10,Gparam11,Gparam12);

	var errMsg = parseMarkup(ReturnStr,"<ERR>");
	if ((errMsg!="") && (errMsg!=null)) {
		alert(t[errMsg]);
		return false;
	}
	var objQuoteID=document.getElementById("QuoteID");
	var objQuoteNo=document.getElementById("QuoteNo");
	if (objQuoteID.value==""||objQuoteNo.innerText=="") {
		objQuoteID.value = parseMarkup(ReturnStr,"<QTID>");
		objQuoteNo.innerText = parseMarkup(ReturnStr,"<QTNO>");
	}
	var objDateTime=document.getElementById("LastQuoteDate");
	if (objDateTime) objDateTime.innerText= parseMarkup(ReturnStr,"<DATE>") + " " + parseMarkup(ReturnStr,"<TIME>");

	var obj = document.getElementById("EpisodeID");
	var EpisodeID=obj.value;
	var context=session['CONTEXT'];
	var Sort="D";
	var objSort=document.getElementById("SortLowestPatient");
	if (objSort && objSort.checked) Sort="A";

	var url='websys.default.csp?WEBSYS.TCOMPONENT=ARPatBill.BestPlanList&QuoteID='+objQuoteID.value +'&Sort='+Sort+'&EpisodeID='+EpisodeID+'&CONTEXT='+context;
	websys_createWindow(url,'frmBestPlanList','');
}

function CloseClickHandler(e) {
	window.top.close();
}

function GenerateClickHandler(e) {
	var currEpisode=true;

	var objEpId = document.getElementById("EpisodeID");
	if (objEpId && objEpId.value=="") currEpisode=false;
	var objPat = document.getElementById("PatientID");
	var PatientID=objPat.value;

	var payor = SetPayorPlanParam(true);
	if (payor == null) return false;

	if  (currEpisode) {
		var context=session['CONTEXT'];
		var EpisodeID="";
		if (objEpId) EpisodeID= objEpId.value;

		var Sort="D";
		var objSort=document.getElementById("SortLowestPatient");
		if (objSort && objSort.checked) Sort="A";

		var url='websys.default.csp?WEBSYS.TCOMPONENT=ARPatBill.BestPlanList&Sort='+Sort+'&PatientID='+PatientID+'&EpisodeID='+EpisodeID+'&CONTEXT='+context;
		websys_createWindow(url,'frmBestPlanList','');

		return false;
	}
	else {

		Gparam6 = payor;
		var qidObj =document.getElementById("QuoteID");
		Gparam1 = qidObj.value;
		Gparam2 = document.getElementById("PatientID").value;

		if (objSurname) {
			Gparam3 = objSurname.value;
			if (Gparam3=="") {
				alert(t['EnterSurnameFirst']);
				return false;
			}
		}
		if (objFirstName) {
			Gparam4 = objFirstName.value;
			if (Gparam4 =="") {
				alert(t['EnterFirstnameFirst']);
				return false;
			}
		}
		if (objDOB) {
			Gparam5 = objDOB.value;
			if (Gparam5 =="") {
				alert(t['EnterDOBFirst']);
				return false;
			}
		}
		if (objExpAdmDate) {
			Gparam7 = objExpAdmDate.value;
			if (Gparam7=="") {
				alert(t['EnterExpAdmDateFirst']);
				return false;
			}
		}
		if (objExpLenStay) {
			Gparam8 = objExpLenStay.value;
			if (Gparam8=="") {
				alert(t['EnterExpLenStayFirst']);
				return false;
			}
		}
		var objRoomTypeDR=document.getElementById("RoomTypeDR");
		if (objRoomTypeDR) Gparam9=objRoomTypeDR.value;
		var objHospitalDR=document.getElementById("HospitalDR");
		if (objHospitalDR) Gparam10=objHospitalDR.value;
		var objUser=document.getElementById("UserCode");
		if (objUser) Gparam11=objUser.value;
		var objPIN=document.getElementById("PIN");
		if (objPIN) Gparam12=objPIN.value;

		var objHiddenGenerate=document.getElementById("HiddenGenerate");
		if (objHiddenGenerate) objHiddenGenerate.onclick=objHiddenGenerate.onchange;
		if (objHiddenGenerate) objHiddenGenerate.click();
	}

}

function LookUpCatSelect(txt) {
	var adata=txt.split("^");
	var catDesc=adata[0];
	var catID=adata[1];
	var catCode=adata[2];
	var cobj=document.getElementById("catID");
	if (cobj) cobj.value=catID;
	var scobj=document.getElementById("SubCategory");
	if (scobj) scobj.value="";
	var iobj=document.getElementById("Item");
	if (iobj) iobj.value="";
}

function LookUpSubCatSelect(txt) {
	var adata=txt.split("^");
	var subCatDesc=adata[0];
	var subCatID=adata[1];
	var subCatCode=adata[2];
	var subcatobj=document.getElementById("subCatID");
	if (subcatobj) subcatobj.value=subCatID;
	var iobj=document.getElementById("Item");
	if (iobj) iobj.value="";
}

function ItemLookupHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("Item");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("ItemMastDR");
	if (obj) obj.value=lu[1];
}

function HospitalLookupHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById('Hospital')
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('HospitalDR')
	if (obj) obj.value=lu[1];
}

function RoomTypeLookupHandler(str) {
	var lu = str.split("^");
	var obj=document.getElementById('RoomType')
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('RoomTypeDR')
	if (obj) obj.value=lu[1];
}

function PayorLookupHandler(str) {
 	var lu = str.split("^");
	var obj=document.getElementById('Payor')
	if (obj) obj.value=lu[0];
	var obj=document.getElementById('InsurPlan')
	if (obj) obj.value="";
}

function InsurPlanLookupSelect(str) {
	var lu = str.split("^");
 	var obj=document.getElementById("InsurPlan")
	if (obj) obj.value = "";
 	objList=document.getElementById("SelectedPayorPlan")

	if (objList) {
		for (var i=0; i<objList.options.length; i++) {
			if (objList.options[i].value == (lu[3]+"&"+lu[2])) {
				alert("Plan " + lu[1] + " / " + lu[0] + " is already selected");
				return false;
			}
		}
		var objPayor=document.getElementById('Payor')
		if (objPayor) objPayor.value="";

		objList.options[objList.length] = new Option(lu[1]+" / "+lu[0],lu[3]+"&"+lu[2]);

		websys_setfocus("Payor");
	}
}

function DeletePlanClickHandler() {
	var objList=document.getElementById("SelectedPayorPlan");
	if (objList) {
		for (var i=(objList.length-1); i>=0; i--) {
			if (objList.options[i].selected) objList.options[i]=null;
		}
	}
}

/**
 * Get all items from SelectedPayorPlan list and construct a series of hospID delimited by a pipe
 * PayorPlan param is always sent in the format payorid&planid|payorid2&planid2|
 */
function SetPayorPlanParam(needalert) {

	var strPayorPlan="";
	var lstPayPlan = document.getElementById("SelectedPayorPlan");
	var numberchosen=0;
	if (lstPayPlan ) {
		if (lstPayPlan.options.length == 0) {
			if (needalert) alert(t['EnterPayorPlanFirst']);
			return null;
		}

		for (var j=0; j<lstPayPlan.options.length; j++) {
			strPayorPlan = strPayorPlan+ lstPayPlan.options[j].value + "|"
		}
		var objSel = document.getElementById("PayorPlanParam");
		if (objSel) {
			objSel.value=strPayorPlan ;
		}
	}
	return strPayorPlan;
}

document.body.onload=BodyLoadHandler;
