document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("LocDesc");
	if (obj) obj.onchange=LocDesc_change;
	obj=document.getElementById("Docdesc");
	if (obj) obj.onchange=Docdesc_change;
	obj=document.getElementById("TimeRange");
	if (obj) obj.onchange=TimeRange_change;
	obj=document.getElementById("SessionType");
	if (obj) obj.onchange=SessionType_change;
	
	
}
function LocDesc_change()
{
	var objLocDesc=document.getElementById("LocDesc");
	if (objLocDesc){
		if (objLocDesc.value==""){
		var obj=document.getElementById("LocID");
		if (obj) obj.value="";
		}
	}
}
function Docdesc_change()
{
	 var objDocdesc=document.getElementById("Docdesc");
	if (objDocdesc){
		if (objDocdesc.value==""){
			var obj=document.getElementById("DocID");
			if (obj) obj.value="";
		}
		}
}
function TimeRange_change()
{
	var objTimeRange=document.getElementById("TimeRange");
	if (objTimeRange){
		if (objTimeRange.value==""){
		var obj=document.getElementById("TimeRangeID");
		if (obj) obj.value="";
		}
	}
}
function SessionType_change()
{
	var objSessionType=document.getElementById("SessionType");
	if (objSessionType){
		if (objSessionType.value=="")
		{
		var obj=document.getElementById("SessionTypeID");
		if (obj) obj.value="";
		}
	}
}
function LoclookupSelect(str){
	var lu = str.split("^");
	var obj=document.getElementById("LocDesc");
	if (obj) obj.value = lu[0];
	var obj=document.getElementById("LocID");
	if (obj) obj.value = lu[1];
	
	var objDocdesc=document.getElementById("DocDesc");
	if (objDocdesc)objDocdesc.value=""
	var obj=document.getElementById("DocID");
	if (obj) obj.value="";
}

function DoclookupSelect(str){
	var lu = str.split("^");
	var obj=document.getElementById("DocDesc");
	if (obj) obj.value = lu[0];
	var obj=document.getElementById("DocID");
	if (obj) obj.value = lu[1];
}

function TimeRangelookupSelect(str){
	var lu = str.split("^");
	var obj=document.getElementById("TimeRange")
	if (obj) obj.value = lu[2];
	var obj=document.getElementById("TimeRangeID")
	if (obj) obj.value = lu[0];
}
function SessionTypelookupSelect(str){
	var lu = str.split("^");
	var obj=document.getElementById("SessionType")
	if (obj) obj.value = lu[2];
	var obj=document.getElementById("SessionTypeID")
	if (obj) obj.value = lu[0];
}