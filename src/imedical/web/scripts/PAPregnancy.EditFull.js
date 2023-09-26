// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var frm = document.forms["fPAPregnancy_EditFull"];

function Init() {

	var obj;

	obj=document.getElementById('PREGLnmp');
	if (obj){
		obj.onblur=CalcEddLmp;
	}
	obj=document.getElementById('PREGEdcAgreed');
	if (obj){
		obj.onblur=CheckEddAgreedAfterLmp;
	}
	obj=document.getElementById('PREGEdcUltrasound1');
	if (obj){
		obj.onblur=CheckEddUltra1AfterLmp;
	}
	obj=document.getElementById('PREGEdcUltrasound2');
	if (obj){
		obj.onblur=CheckEddUltra2AfterLmp;
	}
	obj=document.getElementById('PREGEdcUltrasound3');
	if (obj){
		obj.onblur=CheckEddUltra3AfterLmp;
	}

	obj=document.getElementById('PREGDateOfBooking');
	if (obj){
		obj.onblur=BookDateChangeHandler;
	}

	obj=document.getElementById('PREGTimeOfBooking');
	if (obj){
		obj.onblur=BookTimeChangeHandler;
	}

	obj=document.getElementById('DeletePreCompl');
	if (obj) obj.onclick=PreComplDeleteClickHandler;

	obj=document.getElementById('DeleteArt');
	if (obj) obj.onclick=ArtDeleteClickHandler;
	
	obj=document.getElementById('deleteMenstr');
	if (obj) obj.onclick=MenstrDeleteClickHandler;
	
	obj=document.getElementById('deleteContrMthds');
	if (obj) obj.onclick=ContrMDeleteClickHandler;

	obj=document.getElementById('Delete');
	if (obj) obj.onclick=DeleteClickHandler;

	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateAll;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;

	
	CalcCurrentGestation();
}


//check Booking date, if in the future give error message and return
//if Boking Date is today's date, then check time of booking, if in the future give error and return
function BookDateChangeHandler(){
	var dt = document.getElementById("PREGDateOfBooking");
	PREGDateOfBooking_changehandler(e)
	if(!dt)
		return true;
	if (dt.value == ""){
		ClearBookingGestation();
		return true;
	}
	var dateCmpr = DateStringCompareToday(dt.value);
	if(dateCmpr == 1) {
		alert(t['PREGDateOfBooking'] + " " + t["FutureDate"]);
    		dt.value = "";
    		websys_setfocus("PREGDateOfBooking");
		return false;
	}
	//if date is today's date, then check time to make sure that it's not in the future
	else if (dateCmpr == 0){
		var tm = document.getElementById("PREGTimeOfBooking");
		if(tm && tm.value  != ""){
			// 58524 RC 20/03/06 Modified for THAI date format
			var timeCmpr=DateTimeStringCompareToday(dt.value,tm.value)
			if(timeCmpr == 1) {
				alert(t['PREGTimeOfBooking'] + " " + t["FutureDate"]);
				tm.value = "";
				websys_setfocus("PREGTimeOfBooking");
				return false;
			}
			/*var arrDate = DateStringToArray(dt.value);
			var arrTime = TimeStringToArray(tm.value);
			var entDateTime = new Date(arrDate["yr"],arrDate["mn"]-1,arrDate["dy"],arrTime["hr"],arrTime["mn"],0);
			var nowDateTime = new Date();
			if (entDateTime.getTime() > nowDateTime.getTime()){
				alert(t['PREGTimeOfBooking'] + " " + t["FutureDate"]);
    				tm.value = "";
    				websys_setfocus("PREGTimeOfBooking");
				return false;
			}*/
		}

	}
	CalcBookingGestation();
	return true;
}

//Calculate Gestation at Booking as Booking Date - LMP Date (display as weeks.days)
function CalcBookingGestation(){
	var lmpObj = document.getElementById("PREGLnmp");
	var bookObj = document.getElementById("PREGDateOfBooking");
	var gestObj = document.getElementById("PREGBookingGestation");
	var hgestObj = document.getElementById("HBookingGestation");
	if(lmpObj==null || bookObj==null || gestObj==null || hgestObj==null)
		return;
	if(lmpObj.value==""  || bookObj.value==""){
		gestObj.value="";
		hgestObj.value="";
		return;
	}

	var arr = DateStringDifference(lmpObj.value,bookObj.value);
	var weeks = arr["wk"];
	var days = arr["dy"] % 7;
	gestObj.value = weeks + "." + days;
	hgestObj.value = gestObj.value;
}
function CalcCurrentGestation(){
	
	var EDDObj = document.getElementById("PREGEdcAgreed");
	var CurrGObj = document.getElementById("CurrentGest");
	
	if(EDDObj&&EDDObj.value==""&&CurrGObj){
		CurrGObj.value="";
		return;
	}
        if (EDDObj&&CurrGObj) {
	var arr = DateStringDifferenceToday(EDDObj.value) 
	var days = arr["dy"];
	var adddays=280-days
	var adddaysW=Math.floor(adddays/7);
	var adddaysD=adddays%7;
	
	CurrGObj.value = adddaysW + "." + adddaysD;
	
	}
}

//clear Gestation at Booking field
function ClearBookingGestation(){
	var bookGestObj = document.getElementById("PREGBookingGestation");
	var hbookGestObj = document.getElementById("HBookingGestation");
	if (bookGestObj && hbookGestObj){
		bookGestObj.value = "";
		hbookGestObj.value = "";
	}
}


//check Booking date, if in the future give error message and return
//if Booking Date is today's date, then check Booking Time, if in the future give error and return
function BookTimeChangeHandler(){
	var dt = document.getElementById("PREGDateOfBooking");
	PREGTimeOfBooking_changehandler(e)
	if(!dt || dt.value=="")
		return true;
	var dateCmpr = DateStringCompareToday(dt.value);
	if(dateCmpr == 1){
		alert(t['PREGDateOfBooking'] + " " + t["FutureDate"]);
		dt.value = "";
		websys_setfocus("PREGDateOfBooking");
		return false;
	}
	//if date is today's date, then check time to make sure that it's not in the future
	else if (dateCmpr == 0){
		var tm = document.getElementById("PREGTimeOfBooking");
		if(tm && tm.value  != ""){
			// 58524 RC 20/03/06 Modified for THAI date format
			var timeCmpr=DateTimeStringCompareToday(dt.value,tm.value)
			if(timeCmpr == 1) {
				alert(t['PREGTimeOfBooking'] + " " + t["FutureDate"]);
				tm.value = "";
				websys_setfocus("PREGTimeOfBooking");
				return false;
			}
			/*var arrDate = DateStringToArray(dt.value);
			var arrTime = TimeStringToArray(tm.value);
			var entDateTime = new Date(arrDate["yr"],arrDate["mn"]-1,arrDate["dy"],arrTime["hr"],arrTime["mn"],0);
			var nowDateTime = new Date();
			if (entDateTime.getTime() > nowDateTime.getTime()){
				alert(t['PREGTimeOfBooking'] + " " + t["FutureDate"]);
    				tm.value = "";
    				websys_setfocus("PREGTimeOfBooking");
				return false;
			}*/
		}

	}
	return true;
}


//if the Edd date is not after the Lmp date, give error message
function CheckEddAgreedAfterLmp(){
	var lmpObj = document.getElementById("PREGLnmp");
	var eddAgreedObj = document.getElementById("PREGEdcAgreed");
	if(lmpObj == null || eddAgreedObj == null)
		return;
	if(eddAgreedObj.value == "" || lmpObj.value == "")
		return;
	if(DateStringCompare(eddAgreedObj.value,lmpObj.value) != 1){
		alert(t['PREGEdcAgreed'] + " " + t['LmpFutureDate'] + " " + t['PREGLnmp']);
		eddAgreedObj.value="";
   		websys_setfocus("PREGEdcAgreed");
		return;
	}
	CalcCurrentGestation();
}

//if the Edd date is not after the Lmp date, give error message
function CheckEddUltra1AfterLmp(){
	var lmpObj = document.getElementById("PREGLnmp");
	var eddObj = document.getElementById("PREGEdcUltrasound1");
	if(lmpObj == null || eddObj == null)
		return;
	if(eddObj.value == "" || lmpObj.value == "")
		return;
	if(DateStringCompare(eddObj.value,lmpObj.value) != 1){
		alert(t['PREGEdcUltrasound1'] + " " + t['LmpFutureDate'] + " " + t['PREGLnmp']);
		eddObj.value="";
   		websys_setfocus("PREGEdcUltrasound1");
		return;
	}
	
}

//if the Edd date is not after the Lmp date, give error message
function CheckEddUltra2AfterLmp(){
	var lmpObj = document.getElementById("PREGLnmp");
	var eddObj = document.getElementById("PREGEdcUltrasound2");
	if(lmpObj == null || eddObj == null)
		return;
	if(eddObj.value == "" || lmpObj.value == "")
		return;
	if(DateStringCompare(eddObj.value,lmpObj.value) != 1){
		alert(t['PREGEdcUltrasound2'] + " " + t['LmpFutureDate'] + " " + t['PREGLnmp']);
		eddObj.value="";
   		websys_setfocus("PREGEdcUltrasound2");
		return;
	}

}

//if the Edd date is not after the Lmp date, give error message
function CheckEddUltra3AfterLmp(){
	var lmpObj = document.getElementById("PREGLnmp");
	var eddObj = document.getElementById("PREGEdcUltrasound3");
	if(lmpObj == null || eddObj == null)
		return;
	if(eddObj.value == "" || lmpObj.value == "")
		return;
	if(DateStringCompare(eddObj.value,lmpObj.value) != 1){
		alert(t['PREGEdcUltrasound3'] + " " + t['LmpFutureDate'] + " " + t['PREGLnmp']);
		eddObj.value="";
   		websys_setfocus("PREGEdcUltrasound3");
		return;
	}

}

//If 'Date of LMP' and 'EDD on LMP' fields exist on the page and 'Date of LMP' is not blank,
//calculate 'EDD on LMP' as 'Date of LMP' + 280 days.  Firth check that LMP date is not a future date.
function CalcEddLmp(){
	PREGLnmp_changehandler(e)

	var dLmpObj = document.getElementById("PREGLnmp");
	var eddLmpObj = document.getElementById("PREGEdcLnmp");
	var hEddLmpObj = document.getElementById("HEdcLnmp");

	//if Date of LMP is blank, if EDD Lmp exists then set it to blank and return
	if(dLmpObj == null)
		return;
	var dLmp = dLmpObj.value;
	if(dLmp == ""){
		if (eddLmpObj == null || hEddLmpObj == null)
			return;
		//set EDD by LMP and Hidden EDD by LMP fields to blank
		eddLmpObj.value = "";
		hEddLmpObj.value = "";

		//set Booking gestation to blank
		ClearBookingGestation();

		return;
	}

	//check that Date of LMP is not a future date
	if(DateStringCompareToday(dLmp) == 1){
		alert(t['PREGLnmp'] + " " + t["FutureDate"]);
    		dLmpObj.value = "";
 		if (eddLmpObj != null && hEddLmpObj != null){
			eddLmpObj.value = "";
			hEddLmpObj.value = "";
		}
   		websys_setfocus("PREGLnmp");
		return;
	}

	//calc edd on lmp
	if (eddLmpObj == null || hEddLmpObj == null)
		return;
	var eddLmp = AddToDateStrGetDateStr(dLmp,'D',280);
	eddLmpObj.value = eddLmp;
	hEddLmpObj.value = eddLmp;

	//check that edd dates are after LMP date
	CheckEddAgreedAfterLmp();
	CheckEddUltra1AfterLmp();
	CheckEddUltra2AfterLmp();
	CheckEddUltra3AfterLmp();
	CalcBookingGestation();

}


function DeleteClickHandler() {
	//Delete items from listboxes when a "Delete" button is clicked.
	PreComplDeleteClickHandler();
	ArtDeleteClickHandler();
	MenstrDeleteClickHandler();
	ContrMDeleteClickHandler() ;
	//var obj=document.getElementById("PRECOMPLEntered")
	//if (obj) RemoveFromList(obj);
	//var obj=document.getElementById("ARTEntered")
	//if (obj) RemoveFromList(obj);
	return false;
}

function UpdateAll() {
	UpdatePreCompl();
	UpdateArt();
	UpdateMenstr();
	UpdateContrM();

	//set Updated flag to true b/c attempting to update once now
	var obj=document.getElementById('Updated');
	if (obj){
		if(obj.value == "0") obj.value = "1";
	}

	return update1_click()
}



///////////////////////////////// LIST BOXES ////////////////////////////////////////////////////////////////////////
function AddItemToList(list,code,desc) {
	//Add an item to a listbox
	code=String.fromCharCode(2)+code
	list.options[list.options.length] = new Option(desc,code);
}

function AddItemToList_Reload(list,code,desc) {
	//Add an item to a listbox
	list.options[list.options.length] = new Option(desc,code);
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
		obj.options[i]=null;
	}

}

function RemoveAllFromList(obj){
	for (var i=(obj.length-1); i>=0; i--) {
		obj.options[i]=null;
	}

}

//TN: reload listboxes with values in hidded fields.
//this is due to page being refreshed upon error message (such as invalid pin)
function ReloadListBoxes() {
	//PreComplReload();
	//ArtReload();
	ListboxReload("PRECOMPLDescString","PRECOMPLEntered");
	ListboxReload("ARTDescString","ARTEntered");
	ListboxReload("MenstrHstrStr","MenstrHstrEntrd");
	ListboxReload("ContraMthdsStr","ContraMthdsEntrd");
}

function ListboxReload(strName, lstName) {
	var el = document.getElementById(strName);
	var lst = document.getElementById(lstName);
	var updated = document.getElementById("Updated");
	//don't execute this when page loads for the first time b/c first time values come from db,
	//execute for subsequent reloads (such as on error condition).
	if ((lst) && (el) && (updated.value == "1")) {
		RemoveAllFromList(lst);
		if(el.value != ""){
			var arrITEM=el.value.split(String.fromCharCode(1));
			for (var i=0; i<arrITEM.length; i++) {
				var arrITEMVAL=arrITEM[i].split(String.fromCharCode(2));
				AddItemToList_Reload(lst,arrITEMVAL[0]+String.fromCharCode(2)+arrITEMVAL[1],arrITEMVAL[2]);
			}
		}
	}
}

//this doesn't work properly
function PreComplReload_orig() {
	var el = document.getElementById("PRECOMPLDescString");
	var lst = document.getElementById("PRECOMPLEntered");
	if ((lst)&&(el.value!="")) {
		var arrITEM=el.value.split(String.fromCharCode(1));
		for (var i=0; i<arrITEM.length; i++) {
			var arrITEMVAL=arrITEM[i].split(String.fromCharCode(2));
			//don't add ones that have a child rowid as they would already be populated
			if ((arrITEMVAL[0]=="")&&(arrITEMVAL[2]!="")) {
				AddItemToList(lst,arrITEMVAL[1],arrITEMVAL[2]);
			}
		}
	}
}

//this has been replaced by ListboxReload
function PreComplReload() {
	var el = document.getElementById("PRECOMPLDescString");
	var lst = document.getElementById("PRECOMPLEntered");
	var updated = document.getElementById("Updated");
	//Skip this for first update, only execute for subsequent updates
	if ((lst) && (el) && (updated.value == "1")) {
		//alert("in reload. String is |" + el.value + "|");
		RemoveAllFromList(lst);
		if(el.value != ""){
			var arrITEM=el.value.split(String.fromCharCode(1));
			//alert("in reload.  array length " + arrITEM.length);
			for (var i=0; i<arrITEM.length; i++) {
				var arrITEMVAL=arrITEM[i].split(String.fromCharCode(2));
				//alert("adding " + arrITEMVAL[0]+String.fromCharCode(2)+arrITEMVAL[1]+arrITEMVAL[2]);
				AddItemToList_Reload(lst,arrITEMVAL[0]+String.fromCharCode(2)+arrITEMVAL[1],arrITEMVAL[2]);
			}
		}
	}
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

//PAPregAntenatalCompl List
function UpdatePreCompl() {
	var arrItems = new Array();
	var lst = document.getElementById("PRECOMPLEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("PRECOMPLDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

function PreComplDeleteClickHandler() {
	//Delete items from PRECOMPLEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("PRECOMPLEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}


function ArtLookupSelect(txt) {
	//Add an item to PAPregAntenatalCompl when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("ARTEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Artificial Reproductive Method has already been selected");
				var obj=document.getElementById("ARTDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Artificial Reproductive Method has already been selected");
				var obj=document.getElementById("ARTDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("ARTDesc")
	if (obj) obj.value="";
}


function MenstLookupSelect(txt) {
	//Add an item to PAPregAntenatalCompl when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("MenstrHstrEntrd")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Menstr Problem Method has already been selected");
				var obj=document.getElementById("MenstrHstr")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Menstr Problem Method has already been selected");
				var obj=document.getElementById("MenstrHstr")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("MenstrHstr")
	if (obj) obj.value="";
}

function ContrMLookupSelect(txt) {
	var adata=txt.split("^");
	var obj=document.getElementById("ContraMthdsEntrd")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Contrc Method has already been selected");
				var obj=document.getElementById("ContraMthds")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Contrc Method has already been selected");
				var obj=document.getElementById("ContraMthds")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("ContraMthds")
	if (obj) obj.value="";
}
//PAPregArt List
function UpdateArt() {
	var arrItems = new Array();
	var lst = document.getElementById("ARTEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("ARTDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

function ArtDeleteClickHandler() {
	//Delete items from ARTEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("ARTEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function UpdateMenstr() {
	var arrItems = new Array();
	var lst = document.getElementById("MenstrHstrEntrd");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("MenstrHstrStr");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}
function MenstrDeleteClickHandler() {
	

	var obj=document.getElementById("MenstrHstrEntrd")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function UpdateContrM() {
	var arrItems = new Array();
	var lst = document.getElementById("ContraMthdsEntrd");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("ContraMthdsStr");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

function ContrMDeleteClickHandler() {

	var obj=document.getElementById("ContraMthdsEntrd")
	if (obj)
		RemoveFromList(obj);
	return false;

}


///////////////////////////////// END LIST BOXES ////////////////////////////////////////////////////////////////////////

//TN: call this outside onload call so it can be called straight away, and not wait till everything has loaded.
ReloadListBoxes();

document.body.onload=Init;
