// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var frm = document.forms["fPAPregDelPlacenta_Edit"];

//var LiquorAmtID="",LiquorAbnmID="",LiquorStatID=""

function Init() {
	var obj;

	obj=document.getElementById('Delete');
	if (obj) obj.onclick=DeleteClickHandler;

	obj=document.getElementById('DeletePlacAnom');
	if (obj) obj.onclick=PlacAnomDeleteClickHandler;

	obj=document.getElementById('PLACPlacentaWeight');
	if (obj) obj.onblur=WeightHandler;

	obj=document.getElementById('PLACDelDate');
	if (obj) obj.onblur=DelDateHandler;

	obj=document.getElementById('PLACDelTime');
	if (obj) obj.onblur=DelTimeHandler;

	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateAll;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateAll;
	//胎膜情况
    combo("MembranceCond");
	//胎膜破裂部位
    combo("MembRuptureSite");
	//机转
    combo("MachineTurn");
	//脐附着
    //combo("CordInsertion");
    
    var objPLACID=document.getElementById("ID").value;
    if (objPLACID!="") {
	  var getPlacdata=document.getElementById("getPlacdata").value;
	  ret=cspRunServerMethod(getPlacdata,objPLACID);
	  if (ret!="") {
      var PlacList=ret.split("^");
       comlist(PlacList[0],"MembranceCond");
	   document.getElementById("MembranceCond").onchange=MembranceModeChange;
      comlist(PlacList[1],"MembRuptureSite");
      comlist(PlacList[2],"MachineTurn");
	  //胎盘大小
      var PLACSize=document.getElementById("PLACSize");
      PLACSize.value=PlacList[3];
      var CordLength=document.getElementById("CordLength");
      CordLength.value=PlacList[4];
       comlist(PlacList[5],"CordInsertion");
       
       var LiquorAmout=document.getElementById('LiquorAmout'); 
       if ((LiquorAmout)&&(PlacList[6])){
	      var obj=PlacList[6].split(" ");
	      if (obj[0]) LiquorAmout.value=obj[0];
	      if (obj[1]) {
		    var LiquorAmoutID=document.getElementById('LiquorAmoutID'); 
		    LiquorAmoutID.value=obj[1];
	        }
	   }
	   
	   var LiquorAbnormal=document.getElementById('LiquorAbnormal'); 
       if ((LiquorAbnormal)&&(PlacList[7])){
	      var obj=PlacList[7].split(" ");
	      if (obj[0]) LiquorAbnormal.value=obj[0];
	      if (obj[1]) {
		    var LiquorAbnormalID=document.getElementById('LiquorAbnormalID'); 
		    LiquorAbnormalID.value=obj[1];
	        }
	   }
	   var LiquorStatus=document.getElementById('LiquorStatus'); 
       if ((LiquorStatus)&&(PlacList[8])){
	      var obj=PlacList[8].split(" ");
	      if (obj[0]) LiquorStatus.value=obj[0];
	      if (obj[1]) {
		    var LiquorStatusID=document.getElementById('LiquorStatusID'); 
		    LiquorStatusID.value=obj[1];
	        }
	    }
	   }
	   
      //listqt(PlacList);
     } 
}



function comlist(ch,cmstr)
{  
	var arrItems = new Array();
	var lst = document.getElementById(cmstr);
	if  ((lst)&&(lst.options)) {
		for (var j=0; j<lst.options.length; j++) {
			if (lst.options[j].value==ch) {
				lst.options[j].selected=true;
				break;
			}
		}

	}
	
	
	/*
	var obj=document.getElementById(cmstr);
       switch(ch)
        {
	        case "Y":
	        	obj.options[0].selected=true;
             break;
	        case "N":
	        	obj.options[1].selected=true;
            break;
	        default:
	        break;
	    }  
	    */
}

//DHC
function combo(cmstr)
{
	var obj=document.getElementById(cmstr);
	obj.size=1; 
	obj.multiple=false;
	(obj.options)&&(obj.options.length>0)&&(obj.options[0].selected=true);
	
}

function getcomdata(comb)
{ //selectedIndex
    var indx=comb.selectedIndex;
    var chdata;
   if (indx!=-1)
    {
    //chdata=comb.options[indx].text;
    chdata=combo.options?comb.options[indx].value:"";
    }
    else
    {
	    chdata="";
	}
	return chdata;
}

function getLiquorAmt(str)
{       
		var ass=str.split("^");
		//LiquorAmtID=ass[1];
		var objLiquorAmtID=document.getElementById("LiquorAmoutID");
		objLiquorAmtID.value=ass[1]; 
}

function getLiquorAbnm(str)
{       
		var ass=str.split("^");
		//LiquorAbnmID=ass[1];
		var objLiquorAbnmID=document.getElementById("LiquorAbnormalID");
		objLiquorAbnmID.value=ass[1]; 
}


function GetLiquorStat(str)
{       
		var ass=str.split("^");
		//LiquorStatID=ass[1];
		var objLiquorStatID=document.getElementById("LiquorStatusID");
		objLiquorStatID.value=ass[1];
		 
}



//check Date, if in the future give error message and return
//if Date is today's date, then check time, if in the future give error and return
function DelDateHandler(){
	var dt = document.getElementById("PLACDelDate");
	PLACDelDate_changehandler(e)
	if(!dt || dt.value=="")
		return true;
	var dateCmpr = DateStringCompareToday(dt.value);
	if(dateCmpr == 1){
		alert(t['PLACDelDate'] + " " + t["FutureDate"]);
    		dt.value = "";
    		websys_setfocus("PLACDelDate");
		return false;
	}
	//if date is today's date, then check time to make sure that it's not in the future
	else if (dateCmpr == 0){
		var tm = document.getElementById("PLACDelTime");
		/*if(tm && tm.value  != ""){
			var arrDate = DateStringToArray(dt.value);
			var arrTime = TimeStringToArray(tm.value);
			var entDateTime = new Date(arrDate["yr"],arrDate["mn"]-1,arrDate["dy"],arrTime["hr"],arrTime["mn"],0);
			var nowDateTime = new Date();
			if (entDateTime.getTime() > nowDateTime.getTime()){
				alert(t['PLACDelTime'] + " " + t["FutureDate"]);
    				tm.value = "";
    				websys_setfocus("PLACDelTime");
				return false;			
			}
		}*/
		if(tm && tm.value!="" && dt.value!=""){//need to check dt as well as it may have been set to "" above
				var dtcompare=DateTimeStringCompareToday(dt.value,tm.value) 
				if (dtcompare=="1"){
					alert(t['PLACDelTime'] + " " + t["FutureDate"]);
	    				tm.value = "";
    					websys_setfocus("PLACDelTime");
					return false;
				}
			}
		
	}
	return true;
}


//check Date, if in the future give error message and return
//if Date is today's date, then check time, if in the future give error and return
function DelTimeHandler(){
	var dt = document.getElementById("PLACDelDate");
	PLACDelTime_changehandler(e)
	if(!dt || dt.value=="")
		return true;
	var dateCmpr = DateStringCompareToday(dt.value);
	if(dateCmpr == 1){
		alert(t['PLACDelDate'] + " " + t["FutureDate"]);
    		dt.value = "";
    		websys_setfocus("PLACDelDate");
		return false;
	}
	//if date is today's date, then check time to make sure that it's not in the future
	else if (dateCmpr == 0){
		var tm = document.getElementById("PLACDelTime");
		/*if(tm && tm.value  != ""){
			var arrDate = DateStringToArray(dt.value);
			var arrTime = TimeStringToArray(tm.value);
			var entDateTime = new Date(arrDate["yr"],arrDate["mn"]-1,arrDate["dy"],arrTime["hr"],arrTime["mn"],0);
			var nowDateTime = new Date();
			if (entDateTime.getTime() > nowDateTime.getTime()){
				alert(t['PLACDelTime'] + " " + t["FutureDate"]);
    				tm.value = "";
    				websys_setfocus("PLACDelTime");
				return false;			
			}
		}*/
		if(tm && tm.value!="" && dt.value!=""){//need to check dt as well as it may have been set to "" above
				var dtcompare=DateTimeStringCompareToday(dt.value,tm.value) 
				if (dtcompare=="1"){
					alert(t['PLACDelTime'] + " " + t["FutureDate"]);
	    				tm.value = "";
    					websys_setfocus("PLACDelTime");
					return false;
				}
			}
		
	}
	return true;
}

//Check that weight is a positive number
function WeightHandler(){
	var obj = document.getElementById('PLACPlacentaWeight');
	if (obj && obj.value != "")
		CheckPositiveNumber(obj, "PLACPlacentaWeight");

}

//Function to check if the passed value is a positive number.  If not give error message and clear field.
function CheckPositiveNumber(obj, fieldName){
	//var valid = IsPositiveNumber(obj);
	//正数 正浮点数
	var reg=/^(([1-9]+[0-9]*.{1}[0-9]+)|([0].{1}[1-9]+[0-9]*)|([1-9][0-9]*)|([0][.][0-9]+[1-9]*))$/;
	var valid=reg.test(obj.value);
	if (!valid){
		alert(t[fieldName] + " " + t['Positive_Number']);
		obj.value="";
		websys_setfocus(fieldName);
		return false;
	}
	return true;
	
}

function UpdateAll() {
	var MembranceCond=document.getElementById("MembranceCond");
	var MembranceID=""
	if(MembranceCond)	{ 
	  var MembranceID=getcomdata(MembranceCond);
	  var obj=document.getElementById("MembID");
	  obj.value=MembranceID
	}
	var MembRuptureSite=document.getElementById("MembRuptureSite");
	var MembRuptureCode=""
	if(MembRuptureSite)	{ 
	  var MembRuptureCode=getcomdata(MembRuptureSite);
	  var obj=document.getElementById("MembRuptureCode");
	  obj.value=MembRuptureCode
	}
	var MachineTurn=document.getElementById("MachineTurn");
	var MachineTurnCode=""
	if(MachineTurn)	{ 
	  var MachineTurnCode=getcomdata(MachineTurn);
	  var obj=document.getElementById("MachineTurnCode");
	  obj.value=MachineTurnCode
	}
	var CordInsertion=document.getElementById("CordInsertion");
	var CordInsertionID=""
	if(CordInsertion)	{ 
	  var CordInsertionID=getcomdata(CordInsertion);
	  var obj=document.getElementById("CordInsertionID");
	  obj.value=CordInsertionID
	}
	
	
	UpdatePlacAnom();

	//set Updated flag to true b/c attempting to update once now
	var obj=document.getElementById('Updated');
	if (obj){
		if(obj.value == "0") obj.value = "1";
	}

	return update1_click() 
}





//PAPrDelPlacAnomalies List
function UpdatePlacAnom() {
	var arrItems = new Array();
	var lst = document.getElementById("PLACANOMEntered");
	if (lst) {
		for (var j=0; j<lst.options.length; j++) {
			//TN:need to pass description for reloading when update error occurs
			arrItems[j] = lst.options[j].value + String.fromCharCode(2) + lst.options[j].text;
		}
		var el = document.getElementById("PLACANOMDescString");
		if (el) el.value = arrItems.join(String.fromCharCode(1));
	}
}

function RemoveFromList(obj) {
	for (var i=(obj.length-1); i>=0; i--) {
		if (obj.options[i].selected)
		obj.options[i]=null;
	}

}

function DeleteClickHandler() {
	//Delete items from PAPrDelPlacAnomalies listbox when a "Delete" button is clicked.
	var obj=document.getElementById("PLACANOMEntered")
	if (obj) RemoveFromList(obj);
	return false;
}

function PlacAnomDeleteClickHandler() {
	//Delete items from PLACANOMEntered listbox when a "Delete" button is clicked.

	var obj=document.getElementById("PLACANOMEntered")
	if (obj)
		RemoveFromList(obj);
	return false;
}

function PlacAnomLookupSelect(txt) {
	//Add an item to PAPrDelPlacAnomalies list when an item is selected from
	//the Lookup, then clears the Item text field.
	var adata=txt.split("^");
	var obj=document.getElementById("PLACANOMEntered")

	if (obj) {
		//Need to check if Condition already exists in the List and alert the user
		for (var i=0; i<obj.options.length; i++) {
			if (obj.options[i].value == String.fromCharCode(2)+adata[1]) {
				alert("Placenta Anomaly has already been selected");
				var obj=document.getElementById("PLACANOMDesc")
				if (obj) obj.value="";
				return;
			}
			if  ((adata[1] != "") && (obj.options[i].text == adata[0])) {
				alert("Placenta Anomaly has already been selected");
				var obj=document.getElementById("PLACANOMDesc")
				if (obj) obj.value="";
				return;
			}
		}
	}
	AddItemToList(obj,adata[1],adata[0]);

	var obj=document.getElementById("PLACANOMDesc")
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
	ListboxReload("PLACANOMDescString","PLACANOMEntered");
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
//脐附着
function CordInsertionChange(str)
{
 CordInsertionID=str.split("^").length>0?str.split("^")[0]:"";
 document.getElementById("CordInsertionID").value=CordInsertionID;
dcoument.getElementById("CordInsertion").value=str.split("^").length>0?str.split("^")[1]:"";
}

function MembranceModeChange(str)
{

var MembranceID=window.event.srcElement.value;
document.getElementById("MembID").value=MembranceID;
 
}
//TN: call this outside onload call so it can be called straight away, and not wait till everything has loaded.
ReloadListBoxes();

document.body.onload=Init;
