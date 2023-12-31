// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var frm = document.forms["fPAPrDelBabyApgarScore_Edit"];

function Init() {



	CheckUpdateFlag();

	setDefaults();

	var obj;

	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateClickHandler;
	
 	websys_sckeys['U']=UpdateClickHandler;
	obj=document.getElementById('delete1');
	if (obj) obj.onclick=DeleteClickHandler;
	websys_sckeys['R']=DeleteClickHandler;	
	obj=document.getElementById('PDBASHeartRate');
	if (obj) obj.onblur=HeartRateHandler;
	
	obj=document.getElementById('PDBASRespiration');
	if (obj) obj.onblur=RespirationHandler;

	obj=document.getElementById('PDBASTone');
	if (obj) obj.onblur=ToneHandler;

	obj=document.getElementById('PDBASReflex');
	if (obj) obj.onblur=ReflexHandler;

	obj=document.getElementById('PDBASColour');
	if (obj) obj.onblur=ColourHandler;

	ApgarTotalHandler();
}

//This methods checks if update is already run (updateFlag == 1).  If so, then window is closed.
function CheckUpdateFlag(){
	var flagObj = document.getElementById('updateFlag');
	if (flagObj && flagObj.value=="1"){
		window.close();
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

function LinkEnabled() {
	return true;
}

function EnableLink(obj){
	obj.disabled=false;
	obj.className="";
	obj.onclick=LinkEnabled;
}

//Validates apgar component score to make sure that they are 0,1 or 2.
function ValidateApgarScore(obj){
	if (obj && obj.value!=""){
		var intVal = parseInt(obj.value);
		if(intVal < 0 || intVal > 2){
			alert(t['Invalid_Apgar_Comp']);
			obj.value="";
			websys_setfocus(obj.id);

		}
	}	
}

//Validate Apgar and calculate total
function HeartRateHandler(){
	obj=document.getElementById('PDBASHeartRate');
	ValidateApgarScore(obj);	
	ApgarTotalHandler();
}

//Validate Apgar and calculate total
function RespirationHandler(){
	obj=document.getElementById('PDBASRespiration');
	ValidateApgarScore(obj);	
	ApgarTotalHandler();
}

//Validate Apgar and calculate total
function ToneHandler(){
	obj=document.getElementById('PDBASTone');
	ValidateApgarScore(obj);	
	ApgarTotalHandler();
}

//Validate Apgar and calculate total
function ReflexHandler(){
	obj=document.getElementById('PDBASReflex');
	ValidateApgarScore(obj);	
	ApgarTotalHandler();
}

//Validate Apgar and calculate total
function ColourHandler(){
	obj=document.getElementById('PDBASColour');
	ValidateApgarScore(obj);	
	ApgarTotalHandler();
}


//Calculates total apgar
function ApgarTotalHandler(){
	var obj1=document.getElementById('PDBASHeartRate');
	var obj2=document.getElementById('PDBASRespiration');
	var obj3=document.getElementById('PDBASTone');
	var obj4=document.getElementById('PDBASReflex');
	var obj5=document.getElementById('PDBASColour');
	var totalObj=document.getElementById('TotalApgar');
	var htotalObj=document.getElementById('HTotalApgar');
	var total = 0;
	var intVal = 0;

	if(obj1 && obj2 && obj3 && obj4 && obj5 && totalObj && htotalObj){
		var notBlank = false;
		if (obj1.value != ""){
			intVal = 0;
			intVal = parseInt(obj1.value);
			total = total + intVal;
			notBlank = true;
		}
		if (obj2.value != ""){
			intVal = 0;
			intVal = parseInt(obj2.value);
			total = total + intVal;
			notBlank = true;
		}
		if (obj3.value != ""){
			intVal = 0;
			intVal = parseInt(obj3.value);
			total = total + intVal;
			notBlank = true;
		}
		if (obj4.value != ""){
			intVal = 0;
			intVal = parseInt(obj4.value);
			total = total + intVal;
			notBlank = true;
		}
		if (obj5.value != ""){
			intVal = 0;
			intVal = parseInt(obj5.value);
			total = total + intVal;
			notBlank = true;
		}
		if(notBlank){
			totalObj.value = total;	
			htotalObj.value = total;
		}
		else{
			totalObj.value = "";	
			htotalObj.value = "";
		}
	}
	
}

function setDefaults(){
	//set some defaults from calling window (calling win should be PAPregDelBaby.EditFull1 or PAPregDelBaby.EditFull2)

	if (opener){
		if (opener.document){	
			//set BabyNo
			var doc = opener.document;		
			var babyNoObj1 = doc.getElementById('BABYBirthOrderNumber');	
			var babyNoObj2 = document.getElementById('BabyNo');
			if (babyNoObj1 && babyNoObj2){
				babyNoObj2.value = babyNoObj1.value;
			}
			
			//set Minutes at which Apgar taken
			var apgarNoObj = document.getElementById('PDBASApgarNo');
			var apgarMinObj = document.getElementById('ApgarMin');
			if(apgarNoObj && apgarNoObj.value != "" && apgarMinObj){
				var apgarNoInt = parseInt(apgarNoObj.value);
				/*if (apgarNoInt == 3){
					var min3Obj = doc.getElementById('BABYApgarTime3');
					if (min3Obj) apgarMinObj.value = min3Obj.value;
				}*/
				if (apgarNoInt == 4){
					var min4Obj = doc.getElementById('BABYApgarTime4');
					if (min4Obj) apgarMinObj.value = min4Obj.value;
				}
			}
		}
	}
	

}

function UpdateClickHandler(){
	if (fPAPrDelBabyApgarScore_Edit_submit()){
		UpdateParentApgars();
		return update1_click();
	}
	return false;
}

//Depending on the PDBASApgarNo, need to populate the appropriate field on the parent window
function UpdateParentApgars() {
	var apgarNoObj = document.getElementById('PDBASApgarNo');
	var totalObj = document.getElementById('TotalApgar');
	var doc = opener.document;		
	var editObj;
	if (apgarNoObj && apgarNoObj.value !="" && totalObj){
		var apgarNoInt = parseInt(apgarNoObj.value);
		if(apgarNoInt==1){
			var parApgarObj = doc.getElementById('BABYApgarScoreFull1min');
			if (parApgarObj) parApgarObj.value = totalObj.value;
		}
		else if(apgarNoInt==2){
			var parApgarObj = doc.getElementById('BABYApgarScoreFull5min');
			if (parApgarObj) parApgarObj.value = totalObj.value;		
		}
		else if(apgarNoInt==3){
			var parApgarObj = doc.getElementById('BABYApgarScoreFull3');
			if (parApgarObj) parApgarObj.value = totalObj.value;		
		}
		else if(apgarNoInt==4){
			var parApgarObj = doc.getElementById('BABYApgarScoreFull4');
			if (parApgarObj) parApgarObj.value = totalObj.value;		
		}
	}
}

function DeleteClickHandler(){
	DeleteParentApgars();
	return delete1_click();
}

function DeleteParentApgars(){
	var apgarNoObj = document.getElementById('PDBASApgarNo');
	var totalObj = document.getElementById('TotalApgar');
	var doc = opener.document;		
	if (apgarNoObj && apgarNoObj.value !="" && totalObj){
		var apgarNoInt = parseInt(apgarNoObj.value);
		if(apgarNoInt==1){
			var parApgarObj = doc.getElementById('BABYApgarScoreFull1min');
			if (parApgarObj) parApgarObj.value = "";
		}
		else if(apgarNoInt==2){
			var parApgarObj = doc.getElementById('BABYApgarScoreFull5min');
			if (parApgarObj) parApgarObj.value = "";		
		}
		else if(apgarNoInt==3){
			var parApgarObj = doc.getElementById('BABYApgarScoreFull3');
			if (parApgarObj) parApgarObj.value = "";		
		}
		else if(apgarNoInt==4){
			var parApgarObj = doc.getElementById('BABYApgarScoreFull4');
			if (parApgarObj) parApgarObj.value = "";		
		}
	}
}

function DoAfterUpdate(desc){
	//alert("desc is " + desc);
	UpdateParentApgars2(desc);
	var obj = document.getElementById('updateFlag');
	if (obj) obj.value="1";
}

//Depending on the PDBASApgarNo, need to populate the appropriate field on the parent window
function UpdateParentApgars2(totalDesc) {

	var apgarNoObj = document.getElementById('PDBASApgarNo');
	var doc = opener.document;		
	var editObj;
	if (apgarNoObj && apgarNoObj.value !=""){
		var apgarNoInt = parseInt(apgarNoObj.value);
		if(apgarNoInt==1){
			var parApgarObj = doc.getElementById('BABYApgarScoreFull1min');
			if (parApgarObj) parApgarObj.value = totalDesc;
		}
		else if(apgarNoInt==2){
			var parApgarObj = doc.getElementById('BABYApgarScoreFull5min');
			if (parApgarObj) parApgarObj.value = totalDesc;		
		}
		else if(apgarNoInt==3){
			var parApgarObj = doc.getElementById('BABYApgarScoreFull3');
			if (parApgarObj) parApgarObj.value = totalDesc;		
		}
		else if(apgarNoInt==4){
			var parApgarObj = doc.getElementById('BABYApgarScoreFull4');
			if (parApgarObj) parApgarObj.value = totalDesc;		
		}
	}
}

document.body.onload=Init;





















