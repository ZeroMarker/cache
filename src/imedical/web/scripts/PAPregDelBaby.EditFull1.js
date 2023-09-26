// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var frm = document.forms["fPAPregDelBaby_EditBabyFull"];
if (document.getElementById("RESUSEntered")) {document.getElementById("RESUSEntered").tkItemPopulate=1;}
if (document.getElementById("CONGANOMEntered")) {document.getElementById("CONGANOMEntered").tkItemPopulate=1;} 
if (document.getElementById("NEOMORBEntered ")) {document.getElementById("NEOMORBEntered").tkItemPopulate=1;} 
if (document.getElementById("DELMTHEntered")) {document.getElementById("DELMTHEntered").tkItemPopulate=1;}

function Init() {
	var obj;
  
	obj=document.getElementById('Delete');
	if (obj) obj.onclick=DeleteClickHandler;

	obj=document.getElementById('DeleteResus');
	if (obj) obj.onclick=ResusDeleteClickHandler;

	obj=document.getElementById('DeleteCongAnom');
	if (obj) obj.onclick=CongAnomDeleteClickHandler;

	obj=document.getElementById('DeleteNeoMorb');
	if (obj) obj.onclick=NeoMorbDeleteClickHandler;

	obj=document.getElementById('DeleteDelMth');
	if (obj) obj.onclick=DelMthDeleteClickHandler;

	obj=document.getElementById('BABYBirthDate');
	if (obj){
		obj.onblur=DOBChangeHandler;
	}
    obj.style.background="LightBlue";
    
	obj=document.getElementById('BABYTimeOfBirth');
	if (obj){
		obj.onblur=TOBChangeHandler;
	}
    obj.style.background="LightBlue";
	obj=document.getElementById('BABYMembRuptureDate');
	if (obj) obj.onblur=MembDateChangeHandler;

	obj=document.getElementById('BABYMembRuptureTime');
	if (obj) obj.onblur=MembTimeChangeHandler;

	obj=document.getElementById('BABYBirthWeigth');
	if (obj) obj.onblur=WeightHandler;
    obj.style.background="LightBlue";
	obj=document.getElementById('BABYBirthLength');
	if (obj) obj.onblur=LengthHandler;
    obj.style.background="LightBlue";
    obj=document.getElementById('BABYSexDR');    //20090826
    obj.style.background="LightBlue";
	obj=document.getElementById('DELMTHDesc');    //20090826
    obj.style.background="LightBlue";
	obj=document.getElementById('BABYOutcomeDR');    //20090826
    obj.style.background="LightBlue";
    obj=document.getElementById('BABYGestationWeeks');    //20090901
    obj.style.background="LightBlue";
    obj=document.getElementById('BABYGestationDays');    //20090901
    obj.style.background="LightBlue";
	obj=document.getElementById('BABYOccipitoFrontalCircum');
	if (obj) obj.onblur=OfcHandler;

	obj=document.getElementById('BABYGestationDays');
	if (obj) obj.onblur=GestDaysHandler;

	obj=document.getElementById('BABYGestationWeeks');
	if (obj) obj.onblur=GestWeeksHandler;

	obj=document.getElementById('BABYApgarTime3');
	if (obj) obj.onblur=ApgarTime3Handler;

	obj=document.getElementById('BABYApgarTime4');
	if (obj) obj.onblur=ApgarTime4Handler;

	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateAll;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;

	//obj=document.getElementById('BABYActualDelivPlaceDR');
	//if (obj) obj.onblur=DelivPlaceHandler;

	obj=document.getElementById('update');
	if (obj) obj.onclick=UpdateAll;
	if (tsc['update']) websys_sckeys[tsc['update']]=UpdateAll;
	
	
	//add 2012.2.13 删除空的分娩方法
	var lst = document.getElementById("DELMTHEntered");
	if (lst) {
	    var k="";
		var lstLength=lst.options.length;
		for (var j=0; j<lstLength; j++) {
			//TN:need to pass description for reloading when update error occurs
			if (lst.options[j].text=="") {
			k=j;
			}
		}
		if(k!="") {
		lst.options.remove(k);
        
		}
	}

	DisableRegFields();	

	DisableLinks();

	DisableApgarLinks();

	//Log 49176 Chandana 9/2/05
	InitBoldLinks();
	
}

//xuqy 090108 begin
function GetCTPCPId(str)
{
	var obj=document.getElementById('CTPCPid');
	var tem=str.split("^");
	obj.value=tem[1];
	//alert( tem[1]);
	var obj=document.getElementById('DHCBABYDelDoc');
	obj.value=tem[0];
	return;
}


function GetNurCTPCPId(str)
{
	var obj=document.getElementById('NurCTPCPId');
	var tem=str.split("^");
	obj.value=tem[1];
	//alert( tem[1]);
	var obj=document.getElementById('DHCBABYDelMidwife');
	obj.value=tem[0];
	return;
}

//xuqy 090108 end
function setBoldLinks(el,state) {
	obj=document.getElementById(el);
	if (obj) {
		if (state==1) {obj.style.fontWeight="bold";}
		else {obj.style.fontWeight="normal";}
	}
}

function InitBoldLinks(){
	var objBold=document.getElementById('BoldLinks');
	if (objBold) {
		var BoldLink = objBold.value.split("^");
		setBoldLinks("AllocateReg",BoldLink[0]);
		setBoldLinks("AllocateRegNoBabyDtl",BoldLink[0]);
	}
}

//Check that Gestation days is a positive integer and 0 - 6.
function GestDaysHandler(){
	var obj = document.getElementById('BABYGestationDays');
	if (obj && obj.value != ""){
		var valid = CheckPositiveInteger(obj, "BABYGestationDays");
		if (valid){
			if(obj.value > 6){
				alert(t["BABYGestationDays"] + " " + t["Gestation_Days"]);
				obj.value="";
				websys_setfocus("BABYGestationDays");
				return false;
			}
			else{
				ValidateGestation();
			}
		}
	}

}

//Check that Gestation weeks is a positive integer.
function GestWeeksHandler(){
	var obj = document.getElementById('BABYGestationWeeks');
	if (obj && obj.value != ""){
		var proceed = CheckPositiveInteger(obj, "BABYGestationWeeks");
		if(proceed) ValidateGestation();
	}

}

//Check that Gestation weeks and days are in the specified range (specified in sys params)
//Log 44150 - 19/7/04
function ValidateGestation(){
	var minWObj = document.getElementById("MinGestWeeks");
	var minDObj = document.getElementById("MinGestDays");
	var maxWObj = document.getElementById("MaxGestWeeks");
	var maxDObj = document.getElementById("MaxGestDays");
	var wObj = document.getElementById("BABYGestationWeeks");
	var dObj = document.getElementById("BABYGestationDays");
	
	if(wObj && wObj.value != "" && minWObj && minDObj && maxWObj && maxDObj){
		if(minWObj.value == ""){
			minW = 0;
		}
		else{
			minW = parseInt(minWObj.value);
		}
		if(minDObj.value == ""){
			minD = 0;
		}
		else{
			minD = parseInt(minDObj.value);
		}
		if(maxWObj.value == ""){
			maxW = 0;
		}
		else{
			maxW = parseInt(maxWObj.value);
		}
		if(maxDObj.value == ""){
			maxD = 0;
		}
		else{
			maxD = parseInt(maxDObj.value);
		}
		if(wObj.value == ""){
			wk = 0;
		}
		else{
			wk = parseInt(wObj.value);
		}

		if(wk < minW){
			if(!confirm(t['InvalidGestation'] + "  " + t['ContinueMsg'])){
				wObj.value = "";
				websys_setfocus(wObj.id);
				return false;	
			}		
		}
		else if (wk == minW){
			if(dObj && dObj.value != ""){
				dy = parseInt(dObj.value);
				if(dy < minD){
					if(!confirm(t['InvalidGestation'] + "  " + t['ContinueMsg'])){
						dObj.value = "";
						websys_setfocus(dObj.id);
						return false;
					}
				}
			}
		}
		
		if(wk > maxW){
			if(!confirm(t['InvalidGestation'] + "  " + t['ContinueMsg'])){
				wObj.value = "";
				websys_setfocus(wObj.id);
				return false;	
			}		
		}
		else if (wk == maxW){
			if(dObj && dObj.value != ""){
				dy = parseInt(dObj.value);
				if(dy > maxD){
					if(!confirm(t['InvalidGestation'] + "  " + t['ContinueMsg'])){
						dObj.value = "";
						websys_setfocus(dObj.id);
						return false;
					}
				}
			}
		}
	}
	return true;	
}

//Check that Gestation weeks is a positive integer.
function ApgarTime3Handler(){
	var obj = document.getElementById('BABYApgarTime3');
	if (obj && obj.value != ""){
		CheckPositiveInteger(obj, "BABYApgarTime3");
	}

}

//Check that Gestation weeks is a positive integer.
function ApgarTime4Handler(){
	var obj = document.getElementById('BABYApgarTime4');
	if (obj && obj.value != ""){
		CheckPositiveInteger(obj, "BABYApgarTime4");
	}
}


//Check that weight is a positive number
//Validate that the weight is within the min and max ranges entered in Sys Params - log 44150
function WeightHandler(){
	var obj = document.getElementById('BABYBirthWeigth');
	if (obj && obj.value != ""){
		var proceed = CheckPositiveNumber(obj, "BABYBirthWeigth");
		if(proceed){
			var minwObj = document.getElementById("MinBirthWeight");
			var maxwObj = document.getElementById("MaxBirthWeight");
			if(minwObj && maxwObj){
				var minw = 0;
				var maxw = 0;
				if(minwObj.value != "") minw = parseFloat(minwObj.value);
				if(maxwObj.value != "") maxw = parseFloat(maxwObj.value);
				//alert("min " + minw + " max " + maxw);
				var babyw = parseFloat(obj.value);
				if((babyw < minw) || (babyw > maxw)){
					var cont = confirm(t['InvalidWeight'] + "  " + t['ContinueMsg']);
					if(!cont){
						obj.value="";
						websys_setfocus(obj.id);
						return false;
					}
				}
			}
		}
	}
	return true;
}

//Check that length is a positive number
function LengthHandler(){
	var obj = document.getElementById('BABYBirthLength');
	if (obj && obj.value != "")
		CheckPositiveNumber(obj, "BABYBirthLength");

}

//Check that length is a positive number
function OfcHandler(){
	var obj = document.getElementById('BABYOccipitoFrontalCircum');
	if (obj && obj.value != "")
		CheckPositiveNumber(obj, "BABYOccipitoFrontalCircum");

}

//Function to check if the passed value is a positive number.  If not give error message and clear field.
function CheckPositiveNumber(obj, fieldName, e){
	var valid = IsPositiveNumber(obj);
	if (!valid){
		alert(t[fieldName] + " " + t['Positive_Number']);
		obj.value="";
		websys_setfocus(fieldName);
		return false;
	}
	return true;
}

//Function to check if the passed value is a positive integer.  If not give error message and clear field.
function CheckPositiveInteger(obj, fieldName, e){
	if (!(IsValidInteger(obj) && IsPositiveNumber(obj))){
		alert(t[fieldName] + " " + t['Positive_Integer']);
		obj.value="";
		websys_setfocus(fieldName);
		return false;
	}
	return true;

}


//check DOB, if in the future give error message and return
//if DOB is today's date, then check time of birth, if in the future give error and return
function DOBChangeHandler(){
	var dob = document.getElementById("BABYBirthDate");
	BABYBirthDate_changehandler(e) //??? BABYBirthDate_changehandler未定义
	if(!dob || dob.value=="")
		return true;
	var dateCmpr = DateStringCompareToday(dob.value);
	if(dateCmpr == 1){
		alert(t['BABYBirthDate'] + " " + t["FutureDate"]);
    		dob.value = "";
    		websys_setfocus("BABYBirthDate");
		return false;
	}
	//if date is today's date, then check time to make sure that it's not in the future
	else if (dateCmpr == 0){
		var tob = document.getElementById("BABYTimeOfBirth");
		/*if(tob && tob.value  != ""){
			var arrDate = DateStringToArray(dob.value);
			var arrTime = TimeStringToArray(tob.value);
			var entDateTime = new Date(arrDate["yr"],arrDate["mn"]-1,arrDate["dy"],arrTime["hr"],arrTime["mn"],0);
			var nowDateTime = new Date();
			if (entDateTime.getTime() > nowDateTime.getTime()){
				alert(t['BABYTimeOfBirth'] + " " + t["FutureDate"]);
    				tob.value = "";
    				websys_setfocus("BABYTimeOfBirth");
				return false;			
			}
		}*/
		if(tob && tob.value!="" && dob.value!=""){//need to check dt as well as it may have been set to "" above
				var dtcompare=DateTimeStringCompareToday(dob.value,tob.value) 
				if (dtcompare=="1"){
					alert(t['BABYTimeOfBirth'] + " " + t["FutureDate"]);
	    				tob.value = "";
    					websys_setfocus("BABYTimeOfBirth");
					return false;
				}
			}
		
	}
	return true;
}

//check DOB, if in the future give error message and return
//if DOB is today's date, then check time of birth, if in the future give error and return
function TOBChangeHandler(){
	var dob = document.getElementById("BABYBirthDate");
	BABYTimeOfBirth_changehandler(e)
	if(!dob || dob.value=="")
		return true;
	var dateCmpr = DateStringCompareToday(dob.value);
	if(dateCmpr == 1){
		alert(t['BABYBirthDate'] + " " + t["FutureDate"]);
    		dob.value = "";
    		websys_setfocus("BABYBirthDate");
		return false;
	}
	//if date is today's date, then check time to make sure that it's not in the future
	else if (dateCmpr == 0){
		var tob = document.getElementById("BABYTimeOfBirth");
		/*if(tob && tob.value  != ""){
			var arrDate = DateStringToArray(dob.value);
			var arrTime = TimeStringToArray(tob.value);
			var entDateTime = new Date(arrDate["yr"],arrDate["mn"]-1,arrDate["dy"],arrTime["hr"],arrTime["mn"],0);
			var nowDateTime = new Date();
			if (entDateTime.getTime() > nowDateTime.getTime()){
				alert(t['BABYTimeOfBirth'] + " " + t["FutureDate"]);
    				tob.value = "";
    				websys_setfocus("BABYTimeOfBirth");
				return false;			
			}
		}*/
		if(tob && tob.value!="" && dob.value!=""){//need to check dt as well as it may have been set to "" above
				var dtcompare=DateTimeStringCompareToday(dob.value,tob.value) 
				if (dtcompare=="1"){
					alert(t['BABYTimeOfBirth'] + " " + t["FutureDate"]);
	    				tob.value = "";
    					websys_setfocus("BABYTimeOfBirth");
					return false;
				}
			}
		
	}
	return true;
}

//check Membranes Rupture Date, if in the future give error message and return
//if Date is today's date, then check time, if in the future give error and return
function MembDateChangeHandler(){
	var dt = document.getElementById("BABYMembRuptureDate");
	BABYMembRuptureDate_changehandler(e)
	if(!dt || dt.value=="")
		return true;
	var dateCmpr = DateStringCompareToday(dt.value);
	if(dateCmpr == 1){
		alert(t['BABYMembRuptureDate'] + " " + t["FutureDate"]);
    		dt.value = "";
    		websys_setfocus("BABYMembRuptureDate");
		return false;
	}
	//if date is today's date, then check time to make sure that it's not in the future
	else if (dateCmpr == 0){
		var tm = document.getElementById("BABYMembRuptureTime");
		/*if(tm && tm.value  != ""){
			var arrDate = DateStringToArray(dt.value);
			var arrTime = TimeStringToArray(tm.value);
			var entDateTime = new Date(arrDate["yr"],arrDate["mn"]-1,arrDate["dy"],arrTime["hr"],arrTime["mn"],0);
			var nowDateTime = new Date();
			if (entDateTime.getTime() > nowDateTime.getTime()){
				alert(t['BABYMembRuptureTime'] + " " + t["FutureDate"]);
    				tm.value = "";
    				websys_setfocus("BABYMembRuptureTime");
				return false;			
			}
		}*/
		if(tm && tm.value!="" && dt.value!=""){//need to check dt as well as it may have been set to "" above
				var dtcompare=DateTimeStringCompareToday(dt.value,tm.value) 
				if (dtcompare=="1"){
					alert(t['BABYMembRuptureTime'] + " " + t["FutureDate"]);
	    				tm.value = "";
    					websys_setfocus("BABYMembRuptureTime");
					return false;
				}
			}
		
	}
	return true;
}


//check Membranes Rupture Date, if in the future give error message and return
//if Date is today's date, then check time, if in the future give error and return
function MembTimeChangeHandler(){
	var dt = document.getElementById("BABYMembRuptureDate");
	BABYMembRuptureTime_changehandler(e)
	if(!dt || dt.value=="")
		return true;
	var dateCmpr = DateStringCompareToday(dt.value);
	if(dateCmpr == 1){
		alert(t['BABYMembRuptureDate'] + " " + t["FutureDate"]);
    		dt.value = "";
    		websys_setfocus("BABYMembRuptureDate");
		return false;
	}
	//if date is today's date, then check time to make sure that it's not in the future
	else if (dateCmpr == 0){
		var tm = document.getElementById("BABYMembRuptureTime");
		/*if(tm && tm.value  != ""){
			var arrDate = DateStringToArray(dt.value);
			var arrTime = TimeStringToArray(tm.value);
			var entDateTime = new Date(arrDate["yr"],arrDate["mn"]-1,arrDate["dy"],arrTime["hr"],arrTime["mn"],0);
			var nowDateTime = new Date();
			if (entDateTime.getTime() > nowDateTime.getTime()){
				alert(t['BABYMembRuptureTime'] + " " + t["FutureDate"]);
    				tm.value = "";
    				websys_setfocus("BABYMembRuptureTime");
				return false;			
			}
		}*/
		if(tm && tm.value!="" && dt.value!=""){//need to check dt as well as it may have been set to "" above
				var dtcompare=DateTimeStringCompareToday(dt.value,tm.value) 
				if (dtcompare=="1"){
					alert(t['BABYMembRuptureTime'] + " " + t["FutureDate"]);
	    				tm.value = "";
    					websys_setfocus("BABYMembRuptureTime");
					return false;
				}
			}
		 
	}
	return true;
}

//有personDR 禁止修改 性别 出生日期 登记号
function DisableRegFields(){
	var obj=document.getElementById('BABYPersonDR');
	if(obj && obj.value != ""){
		var obj2=document.getElementById('BABYBirthDate');
		var obj3=document.getElementById('BABYSexDR');
		var obj5=document.getElementById('RegistrationNo');
		if(obj2) DisableGreyFldObj(obj2);
		if(obj3) DisableGreyFldObj(obj3);
		if(obj5) DisableGreyFldObj(obj5);
	}
}

function DisableFldObj(fld) {
	if (fld) {
		fld.disabled = true;
		fld.className = "clsDisabled";
	}
}

function DisableGreyFldObj(fld) {
	if (fld) {
		fld.disabled = true;
		fld.className = "disabledField";
	}
}

function DisableLinks(){
	//If BABYPersonDR exists, disable 'Allocate Registration' Link as registration already allocated
	var obj1=document.getElementById('BABYPersonDR');
	var obj2=document.getElementById('AllocateReg');
	var obj3=document.getElementById('AllocateRegNoBabyDtl');	

 	if (obj1 && obj1.value != "" && obj2) {
		DisableLink(obj2);
 	}
	if (obj1 && obj1.value != "" && obj3){
		DisableLink(obj3);
	}
}


function DisableApgarLinks(){
	//if ID is blank disable EditApgar1-4 links
	var idObj = document.getElementById('ID');
	if(idObj && idObj.value==""){
		var editObj = document.getElementById('EditApgar1');
		if (editObj) DisableLink(editObj);
		editObj = document.getElementById('EditApgar2');
		if (editObj) DisableLink(editObj);
		editObj = document.getElementById('EditApgar3');
		if (editObj) DisableLink(editObj);
		editObj = document.getElementById('EditApgar4');
		if (editObj) DisableLink(editObj);
	}
	
}

function DisableLink(obj){
	obj.disabled=true;
	obj.className="clsDisabled";
	obj.onclick=LinkDisabled;
	obj.style.cursor='default';

}


function LinkDisabled() {
	return false;
}

function UpdateAll() {
	//If 'Allocate to Registered Baby' link is used to select a Patient, then the PatientID is replaced with 
	//the selected baby's PatientID.  Therefore, set the patientid back to mother's patientid.
	var pid = document.getElementById('PatientID');
	var mid = document.getElementById('MotherPatID');
	if (pid && mid){
		//alert("pid " + pid.value + " mid " + mid.value);
		if(pid.value != mid.value){
			pid.value = mid.value;
		}
	}

	var bRegObj = document.getElementById("RegistrationNo");
	var boldlinksObj = document.getElementById("BoldLinks");
	if (bRegObj && boldlinksObj){
		arrBLinks = boldlinksObj.value.split("^");
		if (arrBLinks[0] =="1" && bRegObj.value==""){
			if (!confirm(t['Reg_Lnk_NoBabyDtl'])){
				return false;
			}
		}
	}	
	
       var curDate = document.getElementById("BABYBirthDate").value;         //20090901
       var curTime= document.getElementById("BABYTimeOfBirth").value;
       var ret=tkMakeServerCall("web.DHCCLCom","IfValidDateTime",curDate,curTime)
       if(ret==1){
	       alert("出生日期不能大于当前日期!");
	       return;
       }
	   if(ret==2){
	       alert("出生时间不能大于当前时间!");
	       return;
       }
	   if(ret==3){
	       alert("出生日期不能为空!");
	       return;
       }
	   if(ret==4){
	       alert("出生时间不能为空!");
	       return;
       }
	var cursex = document.getElementById("BABYSexDR").value;
	var con=confirm("出生日期: "+curDate+"  性别:"+cursex+" OK?")
	if (con!=true){
	 return false;
	}
       
	if(checkMandatoryFields()) {
		UpdateResus();
		UpdateCongAnom();
		UpdateNeoMorb();
		UpdateDelMth();
		
       //var obj23=document.getElementById('ID');
       //if (obj23) { alert(obj23.value)}  
         
		//set Updated flag to true b/c attempting to update once now
		var obj=document.getElementById('Updated');
		if (obj){
			if(obj.value == "0") obj.value = "1";
		}
		var obj=document.getElementById('update1');
		if (obj) return update1_click();
		var obj=document.getElementById('update');
		if (obj) return update_click();
	}
	
}

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "clsRequired";
	}
}

function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "";
	}
}

//checks that mandatory fields are filled in
function checkMandatoryFields(){
	var valid = checkMandatoryListBoxes();
	if (valid)
		valid = checkDelivPlace();
		
	return valid;
}

//If Planned Delivery Places is not the same as Actual Delivery Place, then check that the 'When Birth Place Changed' 
//field is filled in.
function checkDelivPlace(){
	var planObj = document.getElementById('PlanDelivPlace');
	var actualObj = document.getElementById('BABYActualDelivPlaceDR');
	var changeObj = document.getElementById('BABYBirthPlaceChangeWhenDR');
	
	if(planObj==null || actualObj==null || changeObj==null)
		return true;

	if(planObj.value != "" && actualObj.value != "" && planObj.value != actualObj.value){
		if(changeObj.value == ""){
			alert(t['BABYBirthPlaceChangeWhenDR'] + " " + t['XMISSING']);
   			websys_setfocus("BABYBirthPlaceChangeWhenDR");			
			return false;
		}
	}	
	return true;
}

//checks that the mandatory listboxes are filled in
function checkMandatoryListBoxes(){
	//check delivery methods
	var obj = document.getElementById('DELMTHEntered');
	var lbl = document.getElementById("cDELMTHEntered");
	//if ((obj)&&(lbl)&&(obj.options.length==0)) {	//Log 47100 26/10/04 - don't chk for the label as well	
	if ((obj)&&(obj.options.length==0)) {
		alert(t['DELMTHEntered'] + " " + t['XMISSING']);
		return false;
	}
	return true;
}

//PAPrDeBabyResusMthd List
function UpdateResus() {
	var arrItems = new Array();
	var lst = document.getElementById("RESUSEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("RESUSDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

//PAPrDelBabyCongAnom List
function UpdateCongAnom() {
	var arrItems = new Array();
	var lst = document.getElementById("CONGANOMEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("CONGANOMDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

//PAPrDelBabyNeoMorb List
function UpdateNeoMorb() {
	var arrItems = new Array();
	var lst = document.getElementById("NEOMORBEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("NEOMORBDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

//PAPrDelBabyDelMthd List
function UpdateDelMth() {
	var arrItems = new Array();
	var lst = document.getElementById("DELMTHEntered");
	if (lst) {
	    var k=0;
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			if (lst.options[j].text=="")
			continue;
			arrItems[k] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
			k++;
		}
		var el = document.getElementById("DELMTHDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

function DeleteClickHandler() {
	//If baby reg exists give msg DEL_REGEXISTS, else give msg DEL_BABYDETAILS
	var obj=document.getElementById('HiddenBabyReg');
	var proceed;
	if(obj && obj.value != ""){
		proceed = confirm(t['DEL_REGEXISTS']);
	}
	else{
		proceed = confirm(t['DEL_BABYDETAILS']);
	}
	
	if (proceed){
		//Delete items from listboxes when a "Delete" button is clicked.
		var obj=document.getElementById("RESUSEntered")
		if (obj) RemoveFromList(obj);
		var obj=document.getElementById("CONGANOMEntered")
		if (obj) RemoveFromList(obj);
		var obj=document.getElementById("NEOMORBEntered")
		if (obj) RemoveFromList(obj);
		var obj=document.getElementById("DELMTHEntered")
		if (obj) RemoveFromList(obj);
	}
	return proceed;
	
}

function ResusDeleteClickHandler() {
	//Delete items from RESUSEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("RESUSEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function CongAnomDeleteClickHandler() {
	//Delete items from CONGANOMEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("CONGANOMEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function NeoMorbDeleteClickHandler() {
	//Delete items from NEOMORBEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("NEOMORBEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}


function DelMthDeleteClickHandler() {
	//Delete items from DelMthBEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("DELMTHEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function ResusLookupSelect(txt) {
	//Add an item to PAPrDelBabyResusMthd list when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("RESUSEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Resuscitation Method has already been selected");
				var obj=document.getElementById("RESUSDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Resuscitation Method has already been selected");
				var obj=document.getElementById("RESUSDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("RESUSDesc")
	if (obj) obj.value="";
}


function CongAnomLookupSelect(txt) {
	//Add an item to PAPrDelBabyCongAnom list when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("CONGANOMEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Congenital Anomaly has already been selected");
				var obj=document.getElementById("CONGANOMDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Congenital Anomaly has already been selected");
				var obj=document.getElementById("CONGANOMDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("CONGANOMDesc")
	if (obj) obj.value="";
}

function NeoMorbLookupSelect(txt) {
	//Add an item to PAPrDelBabyNeoMorb list when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("NEOMORBEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Neonatal Morbidity has already been selected");
				var obj=document.getElementById("NEOMORBDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Neonatal Morbidity has already been selected");
				var obj=document.getElementById("NEOMORBDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("NEOMORBDesc")
	if (obj) obj.value="";
}

function DelMthLookupSelect(txt) {
	//Add an item to PAPrDelBabyDelMthd list when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("DELMTHEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Delivery Method has already been selected");
				var obj=document.getElementById("DELMTHDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Delivery Method has already been selected");
				var obj=document.getElementById("DELMTHDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("DELMTHDesc")
	if (obj) obj.value="";
}

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
	//ListboxReload("DELMTHDescString","DELMTHEntered");
	ListboxReload("NEOMORBDescString","NEOMORBEntered");
	ListboxReload("CONGANOMDescString","CONGANOMEntered");
	ListboxReload("RESUSDescString","RESUSEntered");

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


//TN: call this outside onload call so it can be called straight away, and not wait till everything has loaded.
ReloadListBoxes();

document.body.onload=Init;
