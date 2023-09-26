///Modified By HZY 2011-7-19. Bug HZY0006
///Description:修改函数BFind_Click?在最后的链接字符串后加个RequestNo参数?以实现按申请单号查询的功能?

var selectRow=""
var tableList=new Array();
//装载页面  函数名称固定
function BodyLoadHandler() 
{
	InitUserInfo();
	InitPage();
	HiddenElement();
	InitElementValue();
	KeyUp("RequestLoc^FromLoc^Item");	//清空选择
	Muilt_LookUp("RequestLoc^FromLoc^Item"); //回车选择
	ReFresh();
}

function HiddenElement()
{
	EQCommon_HiddenElement("Time");
	if (GetElementValue("StatusDR")!="")
	{
		SetElement("Status",GetElementValue("StatusDR"))
	}
	var ColNameStr=""
	var ColIdStr=""
	var objtbl=document.getElementById('tDHCEQRentForPrint');//+组件名
	var Type=GetElementValue("Type")
	var Status=GetElementValue("Status")
	//alertShow(Type+","+Status)
	if (Type=="Apply")
	{
		EQCommon_HiddenElement("BRent");
		EQCommon_HiddenElement("BReturn");
		ColNameStr=("TStartDate^TStartTime^TRentManager^TLocReceiver^TRentStatus^TRentStatusRemark^TReturnManager^TLocReturn^TReturnDate^TReturnTime^TReturnStatus^TReturnStatusRemark^TWorkLoad^TTotalFee^TSelect")
	}
	else if (Type=="Rent")
	{
		EQCommon_HiddenElement("BAdd");
		EQCommon_HiddenElement("BReturn");
		ColNameStr=("TRequestUser^TPlanBeginDate^TPlanBeginTime^TPlanEndDate^TPlanEndTime^TReturnManager^TLocReturn^TReturnDate^TReturnTime^TReturnStatus^TReturnStatusRemark^TWorkLoad^TTotalFee")		
		ColIdStr=("TEquip^TStartDate^TStartTime^TRentManager^TLocReceiver^TRentStatus^TRentStatusRemark")
	}
	else if (Type=="Return")
	{
		EQCommon_HiddenElement("BAdd");
		EQCommon_HiddenElement("BRent");
		ColNameStr=("TRequestUser^TPlanBeginDate^TPlanBeginTime^TPlanEndDate^TPlanEndTime^TStartDate^TStartTime^TRentManager^TLocReceiver^TRentStatus^TRentStatusRemark")				
		ColIdStr=("TReturnManager^TLocReturn^TReturnDate^TReturnTime^TReturnStatus^TReturnStatusRemark^TWorkLoad^TTotalFee")
	}
	else if (Type=="LocReturn")
	{
		EQCommon_HiddenElement("BAdd");
		EQCommon_HiddenElement("BRent");
		ColNameStr=("TRequestUser^TPlanBeginDate^TPlanBeginTime^TPlanEndDate^TPlanEndTime^TStartDate^TStartTime^TRentManager^TLocReceiver^TRentStatus^TRentStatusRemark")				
		ColIdStr=("TReturnManager^TLocReturn^TReturnDate^TReturnTime^TReturnStatus^TReturnStatusRemark^TWorkLoad^TTotalFee")
	}
	else if (Type=="Find")
	{
		EQCommon_HiddenElement("BAdd");
		EQCommon_HiddenElement("BRent");
		EQCommon_HiddenElement("BReturn");
		ColNameStr=("TRequestUser^TPlanBeginDate^TPlanBeginTime^TPlanEndDate^TPlanEndTime^TRentManager^TReturnManager^TSelect")				
	}
	if (ColNameStr!="")
	{
		var list=ColNameStr.split("^");
		var num=list.length;
		for (var i=0;i<num;i++)
		{
			var ColName=list[i]
			HiddenTblColumn(objtbl,ColName);
		}
	}
}

function InitPage()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}


function BFind_Click()
{
	var val="&RequestLocDR="+GetElementValue("RequestLocDR")
	val=val+"&RequestLoc="+GetElementValue("RequestLoc")
	var val="&FromLocDR="+GetElementValue("FromLocDR")
	val=val+"&FromLoc="+GetElementValue("FromLoc")
	val=val+"&ItemDR="+GetElementValue("ItemDR")
	val=val+"&Item="+GetElementValue("Item")
	val=val+"&StatusDR="+GetElementValue("Status")
	val=val+"&BeginDate="+GetElementValue("BeginDate")
	val=val+"&EndDate="+GetElementValue("EndDate")
	val=val+"&Type="+GetElementValue("Type")
	val=val+"&User="+GetElementValue("User")
	val=val+"&Time="+GetElementValue("Time")
	val=val+"&QXType="+GetElementValue("QXType")
	val=val+"&vQXType="+GetElementValue("vQXType")
	
	val=val+"&RequestNo="+GetElementValue("RequestNo")	//2011-7-19 HZY. Bug HZY0001. 添加一个申请单号参数?
	val=val+"&ApproveRole="+GetElementValue("ApproveRole")   //modify by GBX  2015-12-14
	val=val+"&Action="+GetElementValue("Action")		//Add By DJ 2016-06-02
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQRentForPrint'+val
}

function GetRequestLocID(value)
{
	GetLookUpID("RequestLocDR",value);
}

function GetFromLocID(value)
{
	GetLookUpID("FromLocDR",value);
}

function GetItemID(value)
{
	GetLookUpID("ItemDR",value);
}

function LookUpEquip()
{
	if (event.keyCode==13||event.keyCode==0)
	{
		selectRow=GetTableCurRow();
		LookUp("","web.DHCEQRent:GetEquipByItem","GetEquipID","TEquipz"+selectRow+","+"TItemDRz"+selectRow+","+"TFromLocDRz"+selectRow+","+"TModelDRz"+selectRow);
	}
}
function GetEquipID(value)
{
	var val=value.split("^");
	for (var i=1;i<tableList.length;i++)
	{
		if ((val[1]==tableList[i])&&(selectRow!=i))
		{
			alertShow("申请单与第"+i+"行申请单申请了同一设备!")
			return
		}
	}
	var obj=document.getElementById("TEquipDRz"+selectRow);
	if (obj)
	{
		obj.value=val[1];	
		tableList[selectRow]=val[1];
	}
	else 	{		alertShow("TEquipDRz"+selectRow);	}
	var obj=document.getElementById("TEquipz"+selectRow);
	if (obj){obj.value=val[0];	}
	else 	{		alertShow("TEquipz"+selectRow);	}
	var obj=document.getElementById("TNoz"+selectRow);
	if (obj){obj.innerText=val[2];	}
}

function LookUpRentManager()
{
	if (event.keyCode==13||event.keyCode==0)
	{
		selectRow=GetTableCurRow();
		LookUpUser("GetRentManagerID",",TRentManagerz"+selectRow)
	}
}
function GetRentManagerID(value)
{
	GetLookUpID_Table("TRentManagerDRz"+selectRow,value);
}
function LookUpReturnManager()
{
	if (event.keyCode==13||event.keyCode==0)
	{
		selectRow=GetTableCurRow();
		LookUpUser("GetReturnManagerID",",TReturnManagerz"+selectRow)
	}
}
function GetReturnManagerID(value)
{
	GetLookUpID_Table("TReturnManagerDRz"+selectRow,value);
}
function LookUpLocReceiver()
{
	if (event.keyCode==13||event.keyCode==0)
	{
		selectRow=GetTableCurRow();
		LookUpUser("GetLocReceiverID",",TLocReceiverz"+selectRow)
	}
}

function GetLocReceiverID(value)
{
	GetLookUpID_Table("TLocReceiverDRz"+selectRow,value);
}

function LookUpLocReturn()
{
	if (event.keyCode==13||event.keyCode==0)
	{
		selectRow=GetTableCurRow();
		LookUpUser("GetLocReturnID",",TLocReturnz"+selectRow)
	}
}
function GetLocReturnID(value)
{
	GetLookUpID_Table("TLocReturnDRz"+selectRow,value);
}

function TStartDate_lookupSelect(dateval)
{
	var obj=document.getElementById('TStartDatez'+selectRow);
	obj.value=dateval;
}
function TReturnDate_lookupSelect(dateval)
{
	var obj=document.getElementById('TReturnDatez'+selectRow);
	obj.value=dateval;
}

function LookUpUser(jsfunction,paras)
{
	LookUp("","web.DHCEQFind:EQUser",jsfunction,paras);
}
///选择表格行触发此方法
function SelectRowHandler()
	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQRentForPrint');//+组件名
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (selectRow==selectrow)
	{
		selectRow=0;
	}
	else
	{
		selectRow=selectrow;
	}
}

function Select_Click()
{
	selectRow=GetTableCurRow();
	var TSelect=document.getElementById("TSelectz"+selectRow).checked
	if (tableList[selectRow]=="") return
	for (var i=1;i<tableList.length;i++)
	{
		if ((tableList[selectRow]==tableList[i])&&(selectRow!=i))
		{
			if (TSelect==true)
			{
				alertShow("申请单与第"+i+"行申请单申请了同一设备!")
				DisableBElement("TSelectz"+i,true)
			}
			if (TSelect==false)
			{
				DisableBElement("TSelectz"+i,false)
				var TSelect=document.getElementById("TSelectz"+i)
				if (TSelect) TSelect.onclick=Select_Click;
			}	
		}
	}

}
function InitElementValue()
{
	var objtbl=document.getElementById('tDHCEQRentForPrint');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{	
		var TMode=GetElementValue("TModez"+i);
		if (TMode==1)
		{
			var TStartDate=GetElementValue("TStartDatez"+i);
			var TStartTime=GetElementValue("TStartTimez"+i);
			var TReturnDate=GetElementValue("TReturnDatez"+i);
			var TReturnTime=GetElementValue("TReturnTimez"+i);
			var UsedHour=(DateDiff(TReturnDate,TStartDate))*24+TimeDiff(TReturnTime,TStartTime)
			if (UsedHour==0) UsedHour=""
			SetElement("TWorkLoadz"+i,UsedHour)
			var TPrice=GetElementValue("TPricez"+i)
			var TWorkLoad=parseInt(GetElementValue("TWorkLoadz"+i))
			if (isNaN(TPrice)||isNaN(TWorkLoad))
			{
				SetElement('TTotalFeez'+i,'');
			}
			else
			{
				var TotalFee=TPrice*TWorkLoad
				if (TotalFee<=0)
				{
					SetElement('TTotalFeez'+i,'');
				}
				else
				{
					SetElement('TTotalFeez'+i,TotalFee.toFixed(2));
				}
			}
		}
	}
}
function ReFresh()
{
	Printing();
	setTimeout(Reload,60000);
}
function Reload()
{
	location.reload();	
}
function Printing()
{
	var encmeth=GetElementValue("GetPrintRowIDs");	
	if (encmeth=="") return;
	var ReturnData=cspRunServerMethod(encmeth);
	if (ReturnData=="") return;
	var listRowIDs=ReturnData.split("^");
	for(var i=1;i<listRowIDs.length;i++)
	{
		BEquipRentPrint(listRowIDs[i]);		//DHCEQEquipRentPrint.js
		var encmethOL=GetElementValue("SaveOperateLog");
		if (encmethOL=="") return;
		cspRunServerMethod(encmethOL,"^64^"+listRowIDs[i],1);
	}	
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;
