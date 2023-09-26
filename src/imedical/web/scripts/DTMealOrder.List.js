

function UpdateClick_Handler() {


	//return Update_click();

}

function LocationLookUpSelect(str) {
	var lu=str.split("^");

	var obj=document.getElementById("SrchLoc");
	if (obj) obj.value=lu[0];
}

function DietTypeLookupSelect(txt) {
	var adata=txt.split("^");

	var dtobj=document.getElementById("SrchItem");
	if (dtobj) dtobj.value=adata[0];

	var atobj=document.getElementById("arcim");
	if (atobj) atobj.value=adata[1];

	var lobj=document.getElementById("SrchLoc");
	if (lobj) lobj.value="";
}

function MealLookUpSelect(str) {


	var lu=str.split("^");

	var mobj=document.getElementById("SRCH_Meal");
	if (mobj) mobj.value=lu[0];

}



function BodyLoadHandler() {
/*
	mTableElements=document.getElementsByTagName("Table");
	for(i=0; i<mTableElements.length; i++)
	{
		alert(mTableElements[i].id);
	}

	alert("form");
	mFormElements=document.getElementsByTagName("Form");
	for(i=0; i<mFormElements.length; i++)
	{
		alert(mFormElements[i].id);
	}	*/
}

//log 63594
var SrchItemobj=document.getElementById("SrchItem");
if (SrchItemobj) SrchItemobj.onblur=checkBlank;

function checkBlank(){
	var dtobj=document.getElementById("SrchItem");
	var atobj=document.getElementById("arcim");
	if (dtobj&&atobj&&dtobj.value=="") atobj.value=""; 
}

document.body.onload=BodyLoadHandler;


