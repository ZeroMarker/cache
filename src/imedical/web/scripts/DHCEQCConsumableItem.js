var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("Unit");
	disabled(true);//灰化
	Muilt_LookUp("Unit");
	SetElement("ExType",GetElementValue("ExTypeDR"));
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
	var obj=document.getElementById("ExType");
	if (obj) obj.onchange=ExType_Change;
}

function ExType_Change()
{
	SetElement("ExTypeDR",GetElementValue("ExType"));
	SetElement("ExID","")
}

function BFind_Click()
{
	var val="&Code="+GetElementValue("Code");
	val=val+"&Desc="+GetElementValue("Desc");
	val=val+"&ExTypeDR="+GetElementValue("ExTypeDR");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCConsumableItem"+val;
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
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
  	if ((GetElementValue("ExType")!="")&&(GetElementValue("ExID")==""))
  	{
	  	alertShow("请输入扩展ID!")
	  	return
  	}
  	if (CheckInvalidData()) return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
		alertShow(t["03"]);
		return
	}
	if (result>0) 
	{
		//add by HHM 20150910 HHM0013
		//添加操作成功是否提示
		ShowMessage();
		//****************************
		location.reload();	
	}
}
function BAdd_Click() //添加
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
  	if ((GetElementValue("ExType")!="")&&(GetElementValue("ExID")==""))
  	{
	  	alertShow("请输入扩展ID!")
	  	return
  	}
  	if (CheckInvalidData()) return;
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
	combindata=combindata+"^"+GetElementValue("Desc") ;//代码
  	combindata=combindata+"^"+GetElementValue("Code") ; //描述
  	combindata=combindata+"^"+GetElementValue("Price") ; //单价
  	combindata=combindata+"^"+GetElementValue("UnitDR") ; //单位
  	combindata=combindata+"^"+GetElementValue("ExTypeDR") ; //扩展类型
  	combindata=combindata+"^"+GetElementValue("ExID") ; //扩展ID
	combindata=combindata+"^"+GetElementValue("ExDesc") ; //扩展Desc
	combindata=combindata+"^"+GetElementValue("PayPrice") ; //售价

  	return combindata;
}
///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCConsumableItem');//+组件名 就是你的组件显示 Query 结果的部分
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
	SetElement("Code","");
	SetElement("Desc","");
	SetElement("Price","")
	SetElement("Unit","");
	SetElement("UnitDR","");
	SetElement("ExType","");
	SetElement("ExTypeDR","");
	SetElement("ExID","");
	SetElement("ExDesc","");
	SetElement("PayPrice","")
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("Desc",list[1]);
	SetElement("Code",list[2]);
	SetElement("UnitDR",list[4])
	SetElement("Price",list[3]);
	SetElement("ExTypeDR",list[5]);
	SetElement("ExID",list[6]);
	SetElement("ExDesc",list[8]);
	SetElement("Unit",list[13]);
	SetElement("ExType",list[5]);
	SetElement("PayPrice",list[9]);
}

function GetUnit(value) {
	var type=value.split("^");
	var obj=document.getElementById("UnitDR");
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
//Mozy0049	2011-3-30
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("Price"),1,1,0,1)==0)
	{
		alertShow("单价异常,请修正.");
		//SetElement("Price","");
		return true;
	}
	return false;
}
//add by ZY  20140915 ZY0117
function GetIncItmInfo(value)
{
	var list=value.split("^");
	SetElement("Desc",list[0]);
	SetElement("Code",list[1]);
	SetElement("UnitDR",list[2])
	SetElement("Unit",list[3]);
	SetElement("Price",list[4]);
	SetElement("ExType",list[5]);
	SetElement("ExID",list[6]);
	SetElement("ExDesc",list[7]);
	SetElement("ExTypeDR",list[5]);
	
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
