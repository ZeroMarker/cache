var stdate="",enddate=""
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
	var objstdate=document.getElementById("startDate");
	var objenddate=document.getElementById("endDate");
    var today=document.getElementById("getToday").value;
    if (objstdate.value=="") {objstdate.value=today;}
    if (objenddate.value=="") {objenddate.value=today;}
    stdate=objstdate.value;
    enddate=objenddate.value;
	var obj=document.getElementById('btnSch');
	if (obj) {obj.onclick=btnSch_Click;}
	var obj=document.getElementById("needRecLocId");
	if (obj) obj.value=ctlocId;	
	var obj=document.getElementById("getCtlocDescById");
	if (obj) 
	{
		var recLocDesc=cspRunServerMethod(obj.value,ctlocId)
		var obj=document.getElementById("needRecLocDesc");
		if (obj) obj.value=recLocDesc;
	}
	//btnSch_Click();
}
function btnSch_Click()
{
	startDate=document.getElementById("startDate").value;
	endDate=document.getElementById("endDate").value;
	var needArcimId="";
	var obj=document.getElementById("needArcimId");
	if (obj) needArcimId=obj.value;
	var needPatLocId=""
	var objNeedPatLocId=document.getElementById("needPatLocId");
	if (objNeedPatLocId) needPatLocId=objNeedPatLocId.value;
	var needPatLocDesc=""
	var obj=document.getElementById("needPatLocDesc");
	if (obj) 
	{
		needPatLocDesc=obj.value;
		if (needPatLocDesc=="")
		{
			objNeedPatLocId.value="";
			needPatLocId="";
		}
	}
	var needRecLocId=""
	var objNeedRecLocId=document.getElementById("needRecLocId");
	if (objNeedRecLocId) needRecLocId=objNeedRecLocId.value;
	var needRecLocDesc=""
	var obj=document.getElementById("needRecLocDesc");
	if (obj) 
	{
		needRecLocDesc=obj.value;
		if (needRecLocDesc=="")
		{
			objNeedRecLocId.value="";
			needRecLocId="";
		}
	}
	var startTime=""
	var obj=document.getElementById("startTime");
	if (obj) startTime=obj.value;
	var endTime=""
	var obj=document.getElementById("endTime");
	if (obj) endTime=obj.value;
	var byOperation=""
	var obj=document.getElementById("byOperation");
	if (obj)
	{
		if (obj.checked) byOperation="Y" ;
	}
	var type=""
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCANOPCostDetails&startDate="+startDate+"&endDate="+endDate+"&ctlocId="+ctlocId+"&type="+type+"&needArcimId="+needArcimId+"&needPatLocId="+needPatLocId+"&needPatLocDesc="+needPatLocDesc+"&needRecLocId="+needRecLocId+"&needRecLocId="+needRecLocId+"&needRecLocDesc="+needRecLocDesc+"&startTime="+startTime+"&endTime="+endTime+"&byOperation="+byOperation;
	location.href=lnk;
}
function GetArcim(str)
{
	var arcimList=str.split("^");
	var obj=document.getElementById("needArcimId");
	if (obj) obj.value=arcimList[1];
	var obj=document.getElementById("needArcimDesc");
	if (obj) obj.value=arcimList[0];	
}

function GetPatLoc(str)
{
	var locList=str.split("^");
	var obj=document.getElementById("needPatLocId");
	if (obj) obj.value=locList[0];
	var obj=document.getElementById("needPatLocDesc");
	if (obj) obj.value=locList[1];	
}

function GetRecLoc(str)
{
	var locList=str.split("^");
	var obj=document.getElementById("needRecLocId");
	if (obj) obj.value=locList[0];
	var obj=document.getElementById("needRecLocDesc");
	if (obj) obj.value=locList[1];	
}

document.body.onload = BodyLoadHandler;