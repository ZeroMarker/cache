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
	KeyUp("RequestLoc^FromLoc^Item");	//清空选择
	Muilt_LookUp("RequestLoc^FromLoc^Item"); //回车选择
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
	var objtbl=document.getElementById('tDHCEQRentFind');//+组件名
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
	/*
	if (ColIdStr!="")
	{
		var rows=objtbl.rows.length-1;
		var UserID=GetElementValue("User")
		if (Type=="Rent") var Id="TRentManagerDRz"
		if (Type=="Return") var Id="TReturnManagerDRz"
		var objwidth=100+"px";
		var objheight=25+"px";
		for (var i=1;i<=rows;i++)
		{
			if (((Type=="Rent")&&(Status!="1"))||((Type=="Return")&&(Status!="2")))
			{				
	    		DisableBElement("TSelectz"+i,true)
	    		continue
			}
    		tableList[i]=GetElementValue("TEquipDRz"+i)
    		if (GetElementValue("TFlagz"+i)=="1") 
    		{
	    		DisableBElement("TDetailz"+i,true)
	    		DisableBElement("TSelectz"+i,true)
	    		continue
	    	}
	    	else
	    	{		    	
    			var TSelect=document.getElementById("TSelectz"+i)
    			if (TSelect) TSelect.onclick=Select_Click;
		    }
    		var Obj=document.getElementById(Id+i)
    		if (Obj) Obj.value=UserID
			var val=ColIdStr.split("^");
			var len=val.length;
			for (var j=0;j<len;j++)
			{
				var ColId=val[j]+"z"+i
				var html="";
				if (val[j]=="TEquip")
				{
					var TEquip=GetCElementValue("TEquipz"+i)
					if (isNaN(TEquip)==false) 
					{
						html=CreatElementHtml(2,ColId,objwidth,objheight,"LookUpEquip","","","")
					}
					else 
					{
						continue
					}
				}
				else if ((val[j]=="TStartDate")||(val[j]=="TReturnDate"))
				{
					html=CreatElementHtml(3,ColId,objwidth,objheight,"LookUpTableDate","TDate_changehandler","","")
				}
				else if ((val[j]=="TStartTime")||(val[j]=="TReturnTime"))
				{
					html=CreatElementHtml(1,ColId,"50px","25px","","TTime_changehandler","","")
				}
				else if (val[j]=="TRentManager")
				{
					html=CreatElementHtml(2,ColId,objwidth,objheight,"LookUpRentManager","","","")
				}
				else if (val[j]=="TReturnManager")
				{
					html=CreatElementHtml(2,ColId,objwidth,objheight,"LookUpReturnManager","","","")
				}
				else if (val[j]=="TLocReceiver")
				{
					html=CreatElementHtml(2,ColId,objwidth,objheight,"LookUpLocReceiver","","","")
				}
				else if (val[j]=="TLocReturn")
				{
					html=CreatElementHtml(2,ColId,objwidth,objheight,"LookUpLocReturn","","","")
				}
				else if ((val[j]=="TRentStatus")||(val[j]=="TReturnStatus"))
				{
					html=CreatElementHtml(4,ColId,objwidth,objheight,"","","0^完好&1^有缺陷&2^故障","")
				}
				else if ((val[j]=="TRentStatusRemark")||(val[j]=="TReturnStatusRemark"))
				{
					objwidthXX=document.getElementById(ColId).parentNode.style.width;
					objheightXX=document.getElementById(ColId).parentNode.style.height;
					html=CreatElementHtml(1,ColId,objwidthXX,objheightXX,"","","","")
				}
				else if (val[j]=="TWorkLoad")
				{
					html=CreatElementHtml(1,ColId,"50px","25px","","","","TotalFee_Change")
				}
				else if (val[j]=="TTotalFee")
				{
					html=CreatElementHtml(1,ColId,"50px","25px","","","","")
				}
				var value=GetCElementValue(ColId);
    			document.getElementById(ColId).parentNode.innerHTML=html;
    			if (isNaN(value)==false)
    			{
	    			if ((val[j]=="TStartDate")||(val[j]=="TReturnDate"))
	    			{
		    			value=GetElementValue("EndDate")
		    		}
	    			else if ((val[j]=="TStartTime")||(val[j]=="TReturnTime"))
	    			{
		    			value=GetElementValue("Time")
		    		}
	    			else if ((val[j]=="TRentManager")||(val[j]=="TReturnManager"))
	    			{
		    			value=GetElementValue("UserName")
		    		}
	    			else if ((val[j]=="TRentStatus")||(val[j]=="TReturnStatus"))
	    			{
		    			value="0"
		    		}
	    		}
	    		document.getElementById(ColId).parentNode.firstChild.value=trim(value);
			}
		}
	}*/
}

function InitPage()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BRent");
	if (obj) obj.onclick=BRent_Click;
	var obj=document.getElementById("BReturn");
	if (obj) obj.onclick=BRent_Click;
}

function BAdd_Click()
{
	var val="&Type="+GetElementValue("Type")
	val=val+"&QXType="+GetElementValue("QXType")
	val=val+"&RequestLocDR="+GetElementValue("RequestLocDR")
	val=val+"&RequestUserDR="+GetElementValue("User")
	val=val+"&PlanBeginDate="+GetElementValue("EndDate")
	val=val+"&PlanBeginTime="+GetElementValue("Time")
	//alertShow(val)
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQRent'+val	
}

function BFind_Click()
{
	var val="&RequestLocDR="+GetElementValue("RequestLocDR")
	val=val+"&RequestLoc="+GetElementValue("RequestLoc")
	val=val+"&FromLocDR="+GetElementValue("FromLocDR")//276756 Modify By BRB 2016-10-26 
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
	val=val+"&TMENU="+GetElementValue("TMENU");
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQRentFind'+val
}

function BRent_Click()
{
  	var Type=GetElementValue("Type")
  	var StatusDR=GetElementValue("Status")
  	if (Type=="Rent")
  	{
	  	if (StatusDR!="1")
	  	{
			alertShow("当前状态不能借出!")
			return
		}
	}
	else if (Type=="Return")
	{
		if (StatusDR!="2")
	  	{
			alertShow("当前状态不能归还!")
			return
		}
	}
  	var valList=GetTableInfo()
  	if (valList=="-1") return
  	if (valList=="")
  	{
	  	alertShow("请您选择要操作的设备!")
	  	return
  	}
  	var encmeth=GetElementValue("upd")
  	if (encmeth=="") return;
	var Return=cspRunServerMethod(encmeth,valList,Type);
    if (Return==0)
    {
		var val="&Type="+GetElementValue("Type")
		val=val+"&StatusDR="+GetElementValue("Status")
		val=val+"&RequestLocDR="+GetElementValue("RequestLocDR")
		val=val+"&RequestLoc="+GetElementValue("RequestLoc")
		val=val+"&FromLocDR="+GetElementValue("FromLocDR")
		val=val+"&FromLoc="+GetElementValue("FromLoc")
		val=val+"&ItemDR="+GetElementValue("ItemDR")
		val=val+"&Item="+GetElementValue("Item")
		val=val+"&BeginDate="+GetElementValue("BeginDate")
		val=val+"&EndDate="+GetElementValue("EndDate")
		val=val+"&Type="+GetElementValue("Type")
		val=val+"&User="+GetElementValue("User")
		val=val+"&Time="+GetElementValue("Time")
		val=val+"&QXType="+GetElementValue("QXType")
		val=val+"&vQXType="+GetElementValue("vQXType")
	    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQRentFind'+val;
	}
    else
    {
	    alertShow(Return+"   "+t["01"]);
    }
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
	var objtbl=document.getElementById('tDHCEQRentFind');//+组件名
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

function GetTableInfo()
{
	var objtbl=document.getElementById('tDHCEQRentFind');
	var rows=objtbl.rows.length;
	var valList="";
	for(var i=1;i<rows;i++)
	{
		var TSelect=GetChkElementValue('TSelectz'+i);
		if (TSelect==false) continue
		var TRowID=GetElementValue('TRowIDz'+i);
		var TEquipDR=GetElementValue('TEquipDRz'+i);
		if (TEquipDR=="")
		{				
			alertShow("第"+i+"行设备不能为空")
			return "-1"
		}
		if (GetElementValue("Type")=="Rent")  //借出操作
		{
			var TValue1=GetElementValue('TStartDatez'+i);
			if (TValue1=="")
			{
				alertShow("第"+i+"行开始时间不能为空")
				return "-1"
			}
			var TValue2=GetElementValue('TStartTimez'+i);
			var TValue3=GetElementValue('TRentManagerDRz'+i);
			if (TValue3=="")
			{
				alertShow("第"+i+"行借出管理人不能为空")
				return "-1"
			}
			var TValue4=GetElementValue('TLocReceiverDRz'+i);
			if (TValue4=="")
			{
				alertShow("第"+i+"行科室接受人不能为空")
				return "-1"
			}
			var TValue5=GetElementValue('TRentStatusz'+i);
			if (TValue5=="")
			{
				alertShow("第"+i+"行借出设备状态不能为空")
				return "-1"
			}
			var TValue6=GetElementValue('TRentStatusRemarkz'+i);
			var ColStr=TValue1+"^"+TValue2+"^"+TValue3+"^"+TValue4+"^"+TValue5+"^"+TValue6
		}
		else if (GetElementValue("Type")=="Return")  //归还操作
		{
			var TValue1=GetElementValue('TReturnDatez'+i);
			if (TValue1=="")
			{
				alertShow("第"+i+"行归还日期不能为空")
				return "-1"
			}
			var TValue2=GetElementValue('TReturnTimez'+i);
			var TValue3=GetElementValue('TReturnManagerDRz'+i);
			if (TValue3=="")
			{
				alertShow("第"+i+"行归还管理人不能为空")
				return "-1"
			}
			var TValue4=GetElementValue('TLocReturnDRz'+i);
			if (TValue4=="")
			{
				alertShow("第"+i+"行科室归还人不能为空")
				return "-1"
			}
			var TValue5=GetElementValue('TReturnStatusz'+i);
			if (TValue5=="")
			{				
				alertShow("第"+i+"行归还设备状态不能为空")
				return "-1"
			}
			var TValue6=GetElementValue('TReturnStatusRemarkz'+i);
			var TValue7=GetElementValue('TWorkLoadz'+i);
			if (TValue7=="")
			{				
				alertShow("第"+i+"行设备工作量不能为空")
				return "-1"
			}
			var TValue8=GetElementValue('TTotalFeez'+i);
			if (TValue8=="")
			{
				alertShow("第"+i+"行总费用不能为空")
				return "-1"
			}
			var ColStr=TValue1+"^"+TValue2+"^"+TValue3+"^"+TValue4+"^"+TValue5+"^"+TValue6+"^"+TValue7+"^"+TValue8;
		}
		if(valList!="") {valList=valList+"@";}
		valList=valList+TRowID+"^"+TEquipDR+"^"+ColStr
	}
	return  valList
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

//定义页面加载方法
document.body.onload = BodyLoadHandler;
