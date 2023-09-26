// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var frm = document.forms["fPAPregEnquiry_Find"];

function Init() {
	var obj;

	obj=document.getElementById('find1');
	if (obj) obj.onclick=FindClickHandler;

	obj=document.getElementById('DeleteLabDelCompl');
	if (obj) obj.onclick=LabDelComplDeleteClickHandler;

	obj=document.getElementById('DeleteIndIndctr');
	if (obj) obj.onclick=IndIndctrDeleteClickHandler;

	obj=document.getElementById('DeletePuerp');
	if (obj) obj.onclick=PuerpDeleteClickHandler;

	obj=document.getElementById('DeleteResus');
	if (obj) obj.onclick=ResusDeleteClickHandler;

	obj=document.getElementById('DeleteCongAnom');
	if (obj) obj.onclick=CongAnomDeleteClickHandler;

	obj=document.getElementById('DeleteNeoMorb');
	if (obj) obj.onclick=NeoMorbDeleteClickHandler;

	obj=document.getElementById('DeleteDelMth');
	if (obj) obj.onclick=DelMthDeleteClickHandler;

	obj=document.getElementById('DeleteAugMth');
	if (obj) obj.onclick=AugMthDeleteClickHandler;

	obj=document.getElementById('DeleteIndMth');
	if (obj) obj.onclick=IndMthDeleteClickHandler;

	obj=document.getElementById('DeletePreCompl');
	if (obj) obj.onclick=PreComplDeleteClickHandler;

	obj=document.getElementById('MAgeFrom');
	if (obj) obj.onblur=MAgeHandler;

	obj=document.getElementById('MAgeTo');
	if (obj) obj.onblur=MAgeHandler;

	obj=document.getElementById('BBthWgtFrom');
	if (obj) obj.onblur=BBthWgtHandler;

	obj=document.getElementById('BBthWgtTo');
	if (obj) obj.onblur=BBthWgtHandler;

	obj=document.getElementById('BGestWksFrom');
	if (obj) obj.onblur=BGestWksHandler;

	obj=document.getElementById('BGestWksTo');
	if (obj) obj.onblur=BGestWksHandler;

	obj=document.getElementById('DateFrom');
	if (obj) obj.onblur=DateFromHandler;

	obj=document.getElementById('DateTo');
	if (obj) obj.onblur=DateToHandler;

	obj=document.getElementById('ApgarMin');
	if (obj) obj.onblur=ApgarMinHandler;

}

function ApgarMinHandler(){
	var obj=document.getElementById('ApgarMin');
	if (obj && obj.value!=""){
		if(obj.value != "1" && obj.value != "5"){
			alert(t['Invalid_Apgar_Min']);
			obj.value="";
			websys_setfocus(obj.id);

		}
	}

}

function MAgeHandler(){
	IntegerRangeHandler("MAgeFrom","MAgeTo");

}

function BBthWgtHandler(){
	IntegerRangeHandler("BBthWgtFrom","BBthWgtTo");

}

function BGestWksHandler(){
	IntegerRangeHandler("BGestWksFrom","BGestWksTo");

}

//The following method ensures that for a set of From and To fields, the To field value is less than or equal to the From 
//field value.
//This works for integer fields.
function IntegerRangeHandler(fromFld,toFld){
	var fromObj=document.getElementById(fromFld);
	var toObj=document.getElementById(toFld);
	if (fromObj && fromObj.value!="" && toObj && toObj.value!=""){
		//alert("from " + fromObj.value + " to " + toObj.value);
		var fromInt = parseInt(fromObj.value);
		var toInt = parseInt(toObj.value);
		if (toInt < fromInt){
			alert(t['Invalid_Range']);
			fromObj.value="";
			toObj.value="";
		}
	}

}

function DateFromHandler(){
	DateFrom_changehandler(e);
	DateRangeHandler("DateFrom","DateTo");
}

function DateToHandler(){
	DateTo_changehandler(e);
	DateRangeHandler("DateFrom","DateTo");
}

//The following method ensures that for a set of From and To fields, the To field value is less than or equal to the From 
//field value.
//This works for date fields.
function DateRangeHandler(fromFld,toFld){
	var fromObj=document.getElementById(fromFld);
	var toObj=document.getElementById(toFld);
	if (fromObj && fromObj.value!="" && toObj && toObj.value!=""){
		//alert("from " + fromObj.value + " to " + toObj.value);
		if (DateStringCompare(fromObj.value,toObj.value)==1){
			alert(t['Invalid_Range']);
			fromObj.value="";
			toObj.value="";
		}
	}

}

function FindClickHandler(){
	if(doValidations()){
		FromListboxStrings();
		SetHFlag1();
		SetHFlag2();
		return find1_click();
	}
		
}

function doValidations(){
	var obj1=document.getElementById("ApgarFrom");
	var obj2=document.getElementById("ApgarTo");
	var obj3=document.getElementById("ApgarMin");

	if(obj1 && obj2 && obj3){
		if((obj1.value !="" || obj2.value!="") && obj3.value==""){
			alert(t['ApgarMin'] + " " + t['Is_Req']);
			return false;
		}
	}
	return true;	
}

//when Find is clicked, this methods sets the user input values to a hidden flag (hFlag1)
function SetHFlag1(){
	var hFlagObj=document.getElementById('hFlag1');
	if (hFlagObj) {
		var DateFrom=DateTo=EnqDteType=MAgeFrom=MAgeTo=AnteCare=MwTeam=DelPlnPlc=PSts=LabourOnset=Perineum=Episiotomy=DegTear=BOutcome=OpDelInd="";
		var obj1 = document.getElementById("DateFrom");
		var obj2 = document.getElementById("DateTo");
		var obj3 = document.getElementById("EnqDteType");
		var obj4 = document.getElementById("MAgeFrom");
		var obj5 = document.getElementById("MAgeTo");
		var obj6 = document.getElementById("AnteCare");
		var obj7 = document.getElementById("MwTeam");
		var obj8 = document.getElementById("DelPlnPlc");
		var obj9 = document.getElementById("PSts");
		var obj10 = document.getElementById("LabourOnset");
		var obj11 = document.getElementById("Perineum");
		var obj12 = document.getElementById("Episiotomy");
		var obj13 = document.getElementById("DegTear");
		var obj14 = document.getElementById("BOutcome");
		var obj15 = document.getElementById("OpDelInd");
		
		if (obj1) DateFrom = obj1.value;
		if (obj2) DateTo = obj2.value;
		if (obj3) EnqDteType = obj3.value;
		if (obj4) MAgeFrom = obj4.value;
		if (obj5) MAgeTo = obj5.value;
		if (obj6) AnteCare = obj6.value;
		if (obj7) MwTeam = obj7.value;
		if (obj8) DelPlnPlc = obj8.value;
		if (obj9) PSts = obj9.value;
		if (obj10) LabourOnset = obj10.value;
		if (obj11) Perineum = obj11.value;
		if (obj12) Episiotomy = obj12.value;
		if (obj13) DegTear = obj13.value;
		if (obj14) BOutcome = obj14.value;
		if (obj15) OpDelInd = obj15.value;

		hFlagObj.value = DateFrom+"^"+DateTo+"^"+EnqDteType+"^"+MAgeFrom+"^"+MAgeTo+"^"+AnteCare+"^"+MwTeam+"^"+DelPlnPlc+"^"+PSts+"^"+LabourOnset+"^"+Perineum+"^"+Episiotomy+"^"+DegTear+"^"+BOutcome+"^"+OpDelInd;
		//alert("hFlag1 " + hFlagObj.value);

	}


}

//when Find is clicked, this methods sets the user input values to a hidden flag (hFlag2)
function SetHFlag2(){
	var hFlagObj=document.getElementById('hFlag2');
	if (hFlagObj) {
		var Accoucheur=Receiver=DecMkr=ActDelPlace=BGestWksFrom=BGestWksTo=BBthWgtFrom=BBthWgtTo=ApgarMin=ApgarFrom=ApgarTo=Presentation="";
		var obj1 = document.getElementById("Accoucheur");
		var obj2 = document.getElementById("Receiver");
		var obj3 = document.getElementById("DecMkr");
		var obj4 = document.getElementById("ActDelPlace");
		var obj5 = document.getElementById("BGestWksFrom");
		var obj6 = document.getElementById("BGestWksTo");
		var obj7 = document.getElementById("BBthWgtFrom");
		var obj8 = document.getElementById("BBthWgtTo");
		var obj9 = document.getElementById("ApgarMin");
		var obj10 = document.getElementById("ApgarFrom");
		var obj11 = document.getElementById("ApgarTo");
		var obj12 = document.getElementById("Presentation");
		
		if (obj1) Accoucheur = obj1.value;
		if (obj2) Receiver = obj2.value;
		if (obj3) DecMkr = obj3.value;
		if (obj4) ActDelPlace = obj4.value;
		if (obj5) BGestWksFrom = obj5.value;
		if (obj6) BGestWksTo = obj6.value;
		if (obj7) BBthWgtFrom = obj7.value;
		if (obj8) BBthWgtTo = obj8.value;
		if (obj9) ApgarMin = obj9.value;
		if (obj10) ApgarFrom = obj10.value;
		if (obj11) ApgarTo = obj11.value;
		if (obj12) Presentation = obj12.value;

		hFlagObj.value = Accoucheur+"^"+Receiver+"^"+DecMkr+"^"+ActDelPlace+"^"+BGestWksFrom+"^"+BGestWksTo+"^"+BBthWgtFrom+"^"+BBthWgtTo+"^"+ApgarMin+"^"+ApgarFrom+"^"+ApgarTo+"^"+Presentation;
		//alert("hFlag2 " + hFlagObj.value);

	}


}


////////////////////////////////////// Listbox Processing Start ////////////////////////////////////////

//This method forms a String containing all the values from the listbox.  
//A seperate String is formed for each listbox.
function FromListboxStrings(){
	UpdateListboxString("LABDELCOMPLEntered","LABDELCOMPLDescString");
	UpdateListboxString("INDINDCTREntered","INDINDCTRDescString");
	UpdateListboxString("PuerpEntered","PuerpDescString");
	UpdateListboxString("DELMTHEntered","DELMTHDescString");
	UpdateListboxString("NEOMORBEntered","NEOMORBDescString");
	UpdateListboxString("CONGANOMEntered","CONGANOMDescString");
	UpdateListboxString("RESUSEntered","RESUSDescString");

	UpdateListboxString("AUGMTHEntered","AUGMTHDescString");
	UpdateListboxString("INDMTHEntered","INDMTHDescString");
	UpdateListboxString("PRECOMPLEntered","PRECOMPLDescString");

}

//PAPrDelLabDelCompl List
function UpdateListboxString(lbName, strName) {
	var strItems = "";
	var lst = document.getElementById(lbName);
	if (lst) {
		var j;
		for (j=0; j<lst.options.length; j++) {
			strItems = strItems + "^" + lst.options[j].value + "^";
			if ((j+1) < lst.options.length){
				strItems = strItems + ", ";
			}
		}		
		var el = document.getElementById(strName);
		if (el) el.value = strItems;
		//if (el.value != "")
		//	alert("string " + el.value);
	}
}

//Delete items from listboxes when a "Delete" button is clicked.
function LabDelComplDeleteClickHandler() {

	var obj=document.getElementById("LABDELCOMPLEntered");
	if (obj)
		RemoveFromList(obj);
	return false;
}

function IndIndctrDeleteClickHandler() {
	//Delete items from INDINDCTREntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("INDINDCTREntered");
	if (obj)
		RemoveFromList(obj);
	return false;
}

function PuerpDeleteClickHandler() {
	//Delete items from PuerpEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("PuerpEntered");
	if (obj)
		RemoveFromList(obj);
	return false;
}

function ResusDeleteClickHandler() {
	//Delete items from RESUSEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("RESUSEntered");
	if (obj)
		RemoveFromList(obj);
	return false;
}

function CongAnomDeleteClickHandler() {
	//Delete items from CONGANOMEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("CONGANOMEntered");
	if (obj)
		RemoveFromList(obj);
	return false;
}

function NeoMorbDeleteClickHandler() {
	//Delete items from NEOMORBEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("NEOMORBEntered");
	if (obj)
		RemoveFromList(obj);
	return false;
}


function DelMthDeleteClickHandler() {
	//Delete items from DelMthBEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("DELMTHEntered");
	if (obj)
		RemoveFromList(obj);
	return false;
}

function AugMthDeleteClickHandler() {
	//Delete items from AUGMTHEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("AUGMTHEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function IndMthDeleteClickHandler() {
	//Delete items from INDMTHEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("INDMTHEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function PreComplDeleteClickHandler() {
	//Delete items from PRECOMPLEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("PRECOMPLEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function LabDelComplLookupSelect(txt) {
	//Add an item to PAPrDelLabDelComplList when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("LABDELCOMPLEntered");

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == adata[1]) {
				alert("Labour & Delivery complication has already been selected");
				var obj=document.getElementById("LABDELCOMPLDesc");
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Labour & Delivery complication has already been selected");
				var obj=document.getElementById("LABDELCOMPLDesc");
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("LABDELCOMPLDesc");
	if (obj) obj.value="";
}

function IndIndctrsLookupSelect(txt) {
	//Add an item to PAPrDelIndIndctrsList when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("INDINDCTREntered");

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == adata[1]) {
				alert("Induction Indicator has already been selected");
				var obj=document.getElementById("INDINDCTRDesc");
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Induction Indicator has already been selected");
				var obj=document.getElementById("INDINDCTRDesc");
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("INDINDCTRDesc");
	if (obj) obj.value="";
}

function PuerpLookupSelect(txt) {
	//Add an item to PAPrDelPuerpCompl when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("PuerpEntered");

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == adata[1]) {
				alert("Puerperium Complication has already been selected");
				var obj=document.getElementById("PUERPDesc");
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Puerperium Complication has already been selected");
				var obj=document.getElementById("PUERPDesc");
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("PUERPDesc");
	if (obj) obj.value="";
}

function ResusLookupSelect(txt) {
	//Add an item to PAPrDelBabyResusMthd list when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("RESUSEntered");

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == adata[1]) {
				alert("Resuscitation Method has already been selected");
				var obj=document.getElementById("RESUSDesc");
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Resuscitation Method has already been selected");
				var obj=document.getElementById("RESUSDesc");
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("RESUSDesc");
	if (obj) obj.value="";
}


function CongAnomLookupSelect(txt) {
	//Add an item to PAPrDelBabyCongAnom list when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("CONGANOMEntered");

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == adata[1]) {
				alert("Congenital Anomaly has already been selected");
				var obj=document.getElementById("CONGANOMDesc");
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Congenital Anomaly has already been selected");
				var obj=document.getElementById("CONGANOMDesc");
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("CONGANOMDesc");
	if (obj) obj.value="";
}

function NeoMorbLookupSelect(txt) {
	//Add an item to PAPrDelBabyNeoMorb list when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("NEOMORBEntered");

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == adata[1]) {
				alert("Neonatal Morbidity has already been selected");
				var obj=document.getElementById("NEOMORBDesc");
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Neonatal Morbidity has already been selected");
				var obj=document.getElementById("NEOMORBDesc");
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("NEOMORBDesc");
	if (obj) obj.value="";
}

function DelMthLookupSelect(txt) {
	//Add an item to PAPrDelBabyDelMthd list when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("DELMTHEntered");

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == adata[1]) {
				alert("Delivery Method has already been selected");
				var obj=document.getElementById("DELMTHDesc");
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Delivery Method has already been selected");
				var obj=document.getElementById("DELMTHDesc");
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("DELMTHDesc");
	if (obj) obj.value="";
}

function AugMthLookupSelect(txt) {
	//Add an item to PAPrDelAugMethods when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("AUGMTHEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Augmentation method has already been selected");
				var obj=document.getElementById("AUGMTHDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Augmentation method has already been selected");
				var obj=document.getElementById("AUGMTHDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("AUGMTHDesc")
	if (obj) obj.value="";
}

function IndMthLookupSelect(txt) {
	//Add an item to PAPrDelIndMethods when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("INDMTHEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Induction method has already been selected");
				var obj=document.getElementById("INDMTHDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Induction method has already been selected");
				var obj=document.getElementById("INDMTHDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("INDMTHDesc")
	if (obj) obj.value="";
}

function PreComplLookupSelect(txt) {
	//Add an item to PAPregAntenatalCompl when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("PRECOMPLEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Antenatal Complication has already been selected");
				var obj=document.getElementById("PRECOMPLDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Antenatal Complication has already been selected");
				var obj=document.getElementById("PRECOMPLDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("PRECOMPLDesc")
	if (obj) obj.value="";
}


function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	//alert("in list " + list.name + " code " + code + " desc " + desc);
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
			obj.options[i]=null;
	}

}

////////////////////////////////////// Listbox Processing End ////////////////////////////////////////


document.body.onload=Init;
