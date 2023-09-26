// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function DocumentLoadHandler() {
	obj=document.getElementById("PAADMBarthelScore")
	if (obj) obj.onchange=PAADMBarthelScoreHandler

	obj=document.getElementById("PAADMDischargeBarthelScore")
	if (obj) obj.onchange=PAADMDischargeBarthelScoreHandler

	obj=document.getElementById("PAADMMiniMentalAssScore")
	if (obj) obj.onchange=PAADMMiniMentalAssScoreHandler
	
	obj = document.getElementById("Update")
   	obj.onclick = UpdateHandler;
   	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
}

function PAADMBarthelScoreHandler() {
	obj=document.getElementById("PAADMBarthelScore")
	if (obj) {
		if (obj.value=="") obj.value=0
		obj.value=CheckScoreRange(0,100,obj.value);
	}
}

function PAADMDischargeBarthelScoreHandler() {
	obj=document.getElementById("PAADMDischargeBarthelScore")
	if (obj) {
		if (obj.value=="") obj.value=0
		obj.value=CheckScoreRange(0,100,obj.value);
	}
	
	try {
		Custom_PAADMDischargeBarthelScoreHandler();
	} catch(e) { 
		}
}

function PAADMMiniMentalAssScoreHandler() {
	obj=document.getElementById("PAADMMiniMentalAssScore")
	if (obj) {
		if (obj.value=="") obj.value=0
		obj.value=CheckScoreRange(0,30,obj.value);
	}
}

function CheckScoreRange(minRange,maxRange,enteredRange) {
	var x=""
	if (isNaN(enteredRange)) {
		alert("'"+enteredRange+"'"+" is not a numeric value.")
		return x
	}
	if ((parseInt(enteredRange)<minRange)||(parseInt(enteredRange)>maxRange)) {
		alert("Range is between "+minRange+"-"+maxRange)
		return x
	}
	return enteredRange
}

function UpdateHandler(e)
{
  
 return Update_click();
}

document.body.onload=DocumentLoadHandler;