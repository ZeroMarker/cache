
var opdate=""
var ctlocId=session['LOGON.CTLOCID'];
function BodyLoadHandler()
{
	//var myDate=new Date();
	//var myYear=myDate.getFullYear();
	//var myMonth=myDate.getMonth()+1;
	//var myDay=myDate.getDate();
	//var obj=document.getElementById('opdate');
	//if(obj.value=="") obj.value=myDay+"/"+myMonth+"/"+myYear;
	//alert(date.toLocaleDateString())
	var objopdate=document.getElementById("opdate");
    var today=document.getElementById("getToday").value;
    if (objopdate.value=="") {objopdate.value=today;}
    opdate=objopdate.value;
	var obj=document.getElementById('btnSch');
	if (obj) {obj.onclick=btnSch_Click;}
	//btnSch_Click();
}
function btnSch_Click()
{
	opdate=document.getElementById("opdate").value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPEfficiencyRecord&sdate="+opdate+"&ctlocId="+ctlocId;
	location.href=lnk; 
}
document.body.onload = BodyLoadHandler;