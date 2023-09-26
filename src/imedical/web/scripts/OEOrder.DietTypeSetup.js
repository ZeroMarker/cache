// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function BodyLoadHandler() {
	setSelectedListItems();
	var GOBJ=document.getElementById("Generate");
	if(GOBJ) GOBJ.onclick=GenerateClickHandler;
}

function GenerateClickHandler() {

	var InsertStr="";
	var ListObj=document.getElementById("MealType");
	var RtnArr=new Array();
	var InsertStr="";
	if(ListObj) RtnArr=getSelectedListItems(ListObj);
	InsertStr=RtnArr.join("^");
	if(InsertStr!="") InsertStr=InsertStr+"^";
	var MTSObj=document.getElementById("MealTypeStr");
	if (MTSObj) MTSObj.value=InsertStr;

	if(InsertStr=="") {
		alert(t['MealType']+" "+t['XMISSING']);
		return false;
	}

	return Generate_click();

	
	
}

function CheckMandatoryFields(listBox)
{
	var Msg="";
	var Proceed=true;

	var Obj=document.getElementById("DTCode");
	if(!Obj) {
		Msg=Msg+t['DTCode']+" "+t['XMISSING']+"\n";
		Proceed=false;
	}
	if((Obj)&&(Obj.value=="")) {
		Msg=Msg+t['DTCode']+" "+t['XMISSING']+"\n";
		Proceed=false;
	}
	var Obj=document.getElementById("DTDesc");
	if(!Obj) {
		Msg=Msg+t['DTDesc']+" "+t['XMISSING']+"\n";
		Proceed=false;
	}
	if((Obj)&&(Obj.value=="")) {
		Msg=Msg+t['DTDesc']+" "+t['XMISSING']+"\n";
		Proceed=false;
	}

	if(Msg!="") alert(Msg);
	
	return Proceed;
}

function HospLookup(txt) {
	var adata=txt.split("^");
	var HospID=adata[1];
	var OrigHospVal="";
	var hobj=document.getElementById("hospID");
	if (hobj) {
		OrigHospVal=hobj.value;
		hobj.value=HospID;
	}
	if(OrigHospVal!=HospID) {
		var obj=document.getElementById("Location");
		if (obj) obj.value="";
	}
}


function getSelectedListItems(listBox)
{
	var selArr = new Array();
	var count = 0;
	for (var i = 0; i < listBox.length; i++) {
		if(listBox.options[i].selected) {
			selArr[count] = listBox.options[i].text;
			count++;
		}
	}
	return selArr;
}

function mPiece(s1,sep,n) {
	delimArray = s1.split(sep);	
	if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}

//log 63538 BoC:  When 'Generate' fails due to duplicate code/desc, set MealType listbox to previously selected values. 
function setSelectedListItems() {
	var ListObj=document.getElementById("MealType");
	var MealTypeStrObj=document.getElementById("MealTypeStr");
	if ((MealTypeStrObj)&&(MealTypeStrObj.value!="")&&(ListObj)) {
		for (var i = 0; i < ListObj.length; i++) {
			if(("^"+MealTypeStrObj.value).indexOf("^"+ListObj.options[i].text+"^")<0) {
				ListObj.options[i].selected=false;
			} else {ListObj.options[i].selected=true;}
		}
	}
}

document.body.onload = BodyLoadHandler;

