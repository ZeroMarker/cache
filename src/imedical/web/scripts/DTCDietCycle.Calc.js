// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var nRow;		// Various table stats
var table;				// Table object
var valArray = new Array();		// Inputed Values Array
var oeobj;
var hobj=document.getElementById("Hospital");
var infield=false;
function BodyLoadHandler() {
	// Setting the number of rows
	
	table = document.getElementById("tDTCDietCycle_Calc");
	if(table)
	{
		nRow = table.rows.length;
		//init valArray to 0 for all vals
		for(i=1; i<nRow; i++)
		{
			valArray[i] = 0;
		}
	}
	PopulateTallies();
	
	//for each row add a click handler to the dynamically created decrease button
	for(j=1; j<nRow; j++)
	{
		var dobj=document.getElementById("Decreasez"+j);
		if (dobj) dobj.onclick=DecreaseClick_Handler;
	}
	if (hobj) hobj.onclick=HospitalClickHandler;
}

function HospitalClickHandler() {
	if (hobj) hobj.focus();
	infield=true;
}
function NumbersChangeHandler() {
	infield=false;
}
function OrdersEntryBlur_Handler()
{
	UpdateTallies();
	if (infield==false) oeobj.focus();
}

function UpdateTallies()
{
	for(i=0; i<=oeobj.value.length; i++)
	{
		var IndexVal=oeobj.value.charAt(i);
		if(isNaN(IndexVal))
			IndexVal = IndexVal.charCodeAt(0) - 87;
		String.fromCharCode(101);
		valArray[IndexVal]++;
	}
	PopulateTallies();
	oeobj.value="";

	//var uobj=document.getElementById("Update");
	//if (uobj) uobj.onclick=UpdateClick_Handler;	

}

function ResetClick_Handler()
{

	//re init valArray to 0 for all vals
	for(i=0; i<nRow; i++)
		valArray[i] = 0;

	PopulateTallies();
}

function UpdateClick_Handler()
{
	UpdateTallies();
	var iobj=document.getElementById("ItemIds");
	var tobj=document.getElementById("ItemTallys");	
	var cobj=document.getElementById("CYCLEIDs");	
	if (iobj && tobj && cobj)
	{
		var ids="";
		var tallys="";
		var cycleids="";
		for(var i=1; i<nRow; i++)
		{
			var rowid = document.getElementById("ARCIMRowIdz"+i);		
			var cycleid = document.getElementById("CYCLERowIDz"+i);					
			ids=ids+rowid.value+",";
			tallys=tallys+valArray[i]+",";			
			cycleids=cycleids+cycleid.value+",";			
		}
		iobj.value=ids;
		tobj.value=tallys;
		cobj.value=cycleids;		
	}

	return Update_click();
}


function DecreaseClick_Handler(e)
{
	//alert("decreaseclick");
	var src=websys_getSrcElement(e);
	var tag = src.tagName;
	if (tag=="IMG")
	{
		var par = websys_getParentElement(src)
		src=par;
	}
	var updateRow = src.id.substr(9);
	if(isNaN(updateRow))
		updateRow = updateRow.charCodeAt(0) - 87;
	if (valArray[updateRow] > 0)
		valArray[updateRow]--;
	
	var setObj=document.getElementById("Tallyz"+updateRow);
	setObj.innerText = valArray[updateRow];

}

function PopulateTallies()
{
	for (i=1; i<nRow; i++) {
		var setObj=document.getElementById("Tallyz"+i);
		setObj.innerText = valArray[i];

	}
}

function LookUpMealSelect(txt){
	var adata=txt.split("^");
	
	var MDobj=document.getElementById("MEALTDesc");
	if (MDobj) MDobj.value=adata[0];
	
	var MRobj=document.getElementById("MEALTCode");	
	if (MRobj) MRobj.value=adata[1];
	//alert("MEALTCode "+MRobj.value)
}
function LookUpDaySelect(txt){
	var adata=txt.split("^");
	
	var DDobj=document.getElementById("DOWDesc");
	if (DDobj) DDobj.value=adata[0];
	
	var DOWobj=document.getElementById("DOWDay");	
	if (DOWobj) DOWobj.value=adata[1];
	
}
function LookUpOrderSetSelect(txt){
	var adata=txt.split("^");
	var DietCode;
	
	var dtobj=document.getElementById("ARCOSDesc");
	if (dtobj) dtobj.value=adata[0];
	
	var arcobj=document.getElementById("ARCOSRowId");	
	if (arcobj) arcobj.value=adata[1];

}
function SelectHospitalHandler(txt) {
	var adata=txt.split("^");
	var hospobj=document.getElementById("Hospital");
	if (hospobj) hospobj.value=adata[0];
	var hdrobj=document.getElementById("HospitalDR");	
	if (hdrobj) hdrobj.value=adata[1];
}
var oeobj=document.getElementById("Numbers");
if (oeobj) oeobj.onblur=OrdersEntryBlur_Handler;
if (oeobj) oeobj.onchange=NumbersChangeHandler;
var robj=document.getElementById("Reset");
if (robj) robj.onclick=ResetClick_Handler;
var uobj=document.getElementById("Update");
if (uobj) uobj.onclick=UpdateClick_Handler;

document.body.onload = BodyLoadHandler;

	
