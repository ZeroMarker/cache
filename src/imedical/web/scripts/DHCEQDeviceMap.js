var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("Equip^DeviceDesc");
	disabled(true);//灰化
	Muilt_LookUp("Equip^DeviceDesc");
	SetElement("DeviceSource",GetElementValue("DeviceSourceDR"));
	fillData();
}

function fillData()
{
	var val="";
	val=val+"equip=Equip="+GetElementValue("EquipDR");
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("DeviceSource");
	if (obj) obj.onchange=DeviceSource_Change;
}

function DeviceSource_Change()
{
	SetElement("DeviceSourceDR",GetElementValue("DeviceSource"));
	SetElement("DeviceDesc","");
	SetElement("DeviceID","")
	
}

function BFind_Click()
{
	var val="&EquipDR="+GetElementValue("EquipDR");
	val=val+"&DeviceSourceDR="+GetElementValue("DeviceSourceDR");
	val=val+"&DeviceID="+GetElementValue("DeviceID");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDeviceMap"+val;
}

function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BDelete_Click() //删除
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	alertShow(t["02"])
	return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
function BUpdate_Click() //修改
{
	if (condition()) return;
	//增加设备与第三方仪器一对多检测提示
	var CheckEQDevResult=GetEQDevCheckFlag()
	if (CheckEQDevResult!=0) return
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
	alertShow(t["03"]);
	return
	}
	if (result>0) location.reload();	
}
///Add By DJ 2018-04-25
///描述:检测设备与第三方仪器对照关系,存在一对多关系时提示
function GetEQDevCheckFlag()
{
	var encmeth=GetElementValue("CheckEQSource");
	if (encmeth=="") return;
	var DMRowID=GetElementValue("RowID")
	var DMSourceType=GetElementValue("DeviceSourceDR")
	var DMSourceID=GetElementValue("DeviceID")
	var DMEQRowID=GetElementValue("EquipDR")
	var CheckResult=cspRunServerMethod(encmeth,DMRowID,DMSourceType,DMSourceID,DMEQRowID);
	if (CheckResult=="-2001")
	{
		alertShow("设备或仪器不能为空!")
	}
	if (CheckResult=="-2002")
	{
		alertShow("该仪器已存在对照关系!")
	}
	if (CheckResult=="-2003")
	{
		alertShow("同一设备不能与多个第三方仪器关联")
	}
	if (CheckResult=="-2004")
	{
		var truthBeTold = window.confirm("当前设备存在存在一对多关系.是否继续?");
		if (truthBeTold) return 0;
		return -1
	}
	return CheckResult
}
function BAdd_Click() //添加
{
	var DeviceID=GetElementValue("DeviceID");   //add by czf 386560 begin
	if(DeviceID=="")
	{
		alertShow("仪器不能为空");
		return;
	}                                           //add by czf 386560 end
	if (condition()) return;
	//增加设备与第三方仪器一对多检测提示
	var CheckEQDevResult=GetEQDevCheckFlag()
	if (CheckEQDevResult!=0) return
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		alertShow(t["03"])
		return
	}
	if (result>0)location.reload();	
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("EquipDR") ;//设备DR
  	combindata=combindata+"^"+GetElementValue("DeviceID") ; //仪器ID
  	combindata=combindata+"^"+GetElementValue("DeviceSourceDR") ; //仪器来源
  	combindata=combindata+"^"+GetElementValue("Remark") ; //备注
  	combindata=combindata+"^"+GetElementValue("DeviceDesc") ; //仪器描述

  	return combindata;
}
///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQDeviceMap');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		Clear();	
		disabled(true)//灰化	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false)//反灰化
		}
}

function Clear()
{
	SetElement("Equip","");
	SetElement("EquipDR","");
	SetElement("DeviceSource","")
	SetElement("DeviceSourceDR","");
	SetElement("DeviceID","");
	SetElement("Remark","");
	SetElement("DeviceDesc","");
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("EquipDR",list[1]);
	SetElement("DeviceSourceDR",list[2]);
	SetElement("DeviceID",list[3]);
	SetElement("Remark",list[4]);
	SetElement("DeviceDesc",list[6]);
	SetElement("Equip",list[7]);
	SetElement("DeviceSource",list[2]);
}

function GetEquip(value)
{
	var type=value.split("^");
	var obj=document.getElementById("EquipDR");
	obj.value=type[1];
}

function GetDeviceDesc(value)
{
	var type=value.split("^");
	var obj=document.getElementById("DeviceID");
	obj.value=type[1];
}

function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
