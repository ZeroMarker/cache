function BodyLoadHandler() 
{
	InitUserInfo();	
	KeyUp("ExObj^RequestLoc^AcceptUser");
	Muilt_LookUp("ExObj^RequestLoc^AcceptUser");
	SetStatus();
	SetTableItem();		//Add By DJ 2016-11-24
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Clicked;
}

function RequestLoc(value)		//Modify DJ 2016-11-30
{
	GetLookUpID('RequestLocDR',value);
}
function GetExObj(value)
{
	GetLookUpID('ExObjDR',value);
	
}
function GetAcceptUser(value)
{
	var val=value.split("^");
	SetElement("AcceptUser",val[2]);
	SetElement("Initials",val[6]);
	GetLookUpID('AcceptUserDR',value);
}
function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatus"))
}
///Add By DJ 2016-11-24
function SetTableItem()
{
	var objtbl=document.getElementById('tDHCEQMMaintRequestDetail');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		var obj=document.getElementById("BEvaluatez"+i);
		obj.onclick=BEvaluate_Click
	}
}
///Add By DJ 2016-11-24
function BEvaluate_Click()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;								//当前选择行
	var RowID=GetElementValue("TRowIDz"+selectrow);
	var CurRole=GetElementValue("TCurRolez"+selectrow);
	var EvaluateGroup=GetElementValue("TEvaluateGroupz"+selectrow);
	var ReturnStr=GetElementValue("CheckEvaluatez"+selectrow);
	var SourceNo=GetElementValue("TRequestNOz"+selectrow);
	var CheckEvaluate=ReturnStr.split("^");
	if (CheckEvaluate[0]<0)
	{
		alertShow(CheckEvaluate[1]);
		return
	}
	var ReadOnly=0
	if (CheckEvaluate[0]==0) ReadOnly=1;
	//打开评价窗口
	var str="dhceqevaluate.csp?&SourceType=31&SourceID="+RowID+"&CurRole="+CurRole+"&EvaluateGroup="+EvaluateGroup+"&SourceNo="+SourceNo+"&ERowID="+CheckEvaluate[1]+"&ReadOnly="+ReadOnly
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0')
}
function BFind_Clicked()
{
	var val="";
	val="&Status="+GetElementValue("Status");
	val=val+"&ExObjDR="+GetElementValue("ExObjDR");
	val=val+"&RequestLocDR="+GetElementValue("RequestLocDR");
	val=val+"&StartDate="+GetElementValue("StartDate");
	val=val+"&EndDate="+GetElementValue("EndDate");
	val=val+"&QXType="+GetElementValue("QXType");
	val=val+"&RequestNo="+GetElementValue("RequestNo");
	if (GetChkElementValue("InvalidFlag")==true)
	{
		val=val+"&InvalidFlag=Y"
	}
	else
	{
		val=val+"&InvalidFlag=N"
	}
	val=val+"&AcceptUserDR="+GetElementValue("AcceptUserDR");
	val=val+"&CurUser="+GetElementValue("CurUser");
	val=val+"&ExObj="+GetElementValue("ExObj");
	val=val+"&FinishFlag="+GetElementValue("FinishFlag");
	val=val+"&LeaderFlag="+GetElementValue("LeaderFlag");
	val=val+"&UserLocDR="+GetElementValue("UserLocDR");
	val=val+"&CurLocID="+curLocID;
	val=val+"&CurGroupID="+GetElementValue("CurGroupID");
	val=val+"&WaitAD="+GetElementValue("WaitAD");
	val=val+"&AcceptUser="+GetElementValue("AcceptUser");
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMMaintRequestDetail'+val;
}
document.body.onload = BodyLoadHandler;