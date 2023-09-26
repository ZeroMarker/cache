
		var reclocobj;
		var ReqWardObj;
		var ReqDocObj;

function BodyLoadHandler() {
	reclocobj=document.getElementById('Location');
	ReqWardObj=document.getElementById('Ward');
	ReqDocObj=document.getElementById('Doctor');
	reclocobj.onkeyup=clearreclocid;
	ReqWardObj.onkeyup=ClearReqWard;
	ReqDocObj.onkeyup=ClearReqDoctor;
	//reclocobj.onkeydown=recloclook;
	ChkUnReadWarnReport();
	//websys_setfocus('RegNo');
}

function ChkUnReadWarnReport() {
	var tbl=document.getElementById("tDHCLabWarnReportSearch");
	for (var curr_row=1; curr_row<tbl.rows.length; curr_row++) {
		var FlagValue = document.getElementById("ReadFlagz" + curr_row);
		//var FlagCode=document.getElementById("OtherFlagCodez" + curr_row);
        //alert(FlagValue);
        if (FlagValue==null){
	        //alert(FlagValue.value);
        	MarkAsAbnormal(curr_row,tbl);
        }
	}
}
function MarkAsAbnormal(CurrentRow,tableobj) {
	for (var CurrentCell=0; CurrentCell<tableobj.rows[CurrentRow].cells.length; CurrentCell++) {
		tableobj.rows[CurrentRow].cells[CurrentCell].style.color="Red";
	}
}
  	
function Find()
{   
  Find_click();
}

function clearreclocid()
{
	var obj=document.getElementById('getreclocid');
	obj.value="";
}
function ClearReqWard()
{
	var obj=document.getElementById('WardCode');
	obj.value="";
}
function ClearReqDoctor()
{
	var obj=document.getElementById('DoctorCode');
	obj.value="";
}
	
function getreclocid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('getreclocid');
	obj.value=val[1];

}
function getWardCode(value)	{
	var val=value.split("^");
	var obj=document.getElementById('WardCode');
	//alert(value);
	obj.value=val[1];
}
function getDoctorCode(value)	{
	var val=value.split("^");
	var obj=document.getElementById('DoctorCode');
	//alert(value);
	obj.value=val[1];

}

function recloclook()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  recloc_lookuphandler();
		}
}
function BodyUnLoadHandler(){

}
document.body.onload = BodyLoadHandler;
document.body.onunload = BodyUnLoadHandler;