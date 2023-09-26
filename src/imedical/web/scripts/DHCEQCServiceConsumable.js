var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler()
{
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("Model^Unit^ServiceItem^ConsumableItem^ServDetItem");
	disabled(true);//灰化
	Muilt_LookUp("Model^Unit^ServiceItem^ConsumableItem^ServDetItem^CycleUnit");
	SetElement("SourceType",GetElementValue("SourceTypeDR"));
	SetElement("QuantityType",GetElementValue("QuantityTypeDR"))
	EnableModel();
	fillData();
	TypeSelect();  //Modefied by zc 2014-11-04 zc0019
}

function fillData()
{
	var val="";
	if (GetElementValue("SourceTypeDR")==1)
	{
		val=val+"equip=SourceID="+GetElementValue("SourceIDDR")+"^";
	}
	else
	{
		val=val+"masteritem=SourceID="+GetElementValue("SourceIDDR")+"^";
	}
	val=val+"service=ServiceItem="+GetElementValue("ServiceItemDR")+"^";
	val=val+"consumableitem=ConsumableItem="+GetElementValue("ConsumableItemDR")+"^";
	val=val+"model=Model="+GetElementValue("ModelDR");
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
	var obj=document.getElementById("SourceType");
	if (obj) obj.onchange=SourceType_change;
	var obj=document.getElementById("SourceID");
	if (obj) obj.onkeydown=SourceID_keydown;
	var obj=document.getElementById("ld"+GetElementValue("GetComponentID")+"iSourceID");
	if (obj) obj.onclick=SourceID_Click;
	var obj=document.getElementById("ConsumableItem");
	if (obj) obj.onchange=ConsumableItem_change;
	var obj=document.getElementById("QuantityType");
	if (obj) obj.onchange=QuantityType_change;
	var obj=document.getElementById("Type");
	if (obj) obj.onchange=TypeSelect;  //Modefied by zc 2014-11-04 zc0019
}

function SourceID_keydown()
{
	if (event.keyCode==13)
	{
		SourceID_Click();
	}
}

function ConsumableItem_change()
{
	SetElement("ConsumableItem","");      //modified by czf 386488
	SetElement("ConsumableItemDR","");
	SetElement("Unit","");
	SetElement("UnitDR","");
}

function SourceType_change()
{
	SetElement("SourceTypeDR",GetElementValue("SourceType"))
	EnableModel()
	SetElement("SourceID","")
	SetElement("SourceIDDR","");
	SetElement("Model","");
	SetElement("ModelDR","");
	// Mozy	2010-11-24	来源类型为非必填,其他数据不能重置
	//SetElement("ServiceItem","");
	//SetElement("ServiceItemDR","");
	//SetElement("Unit","");
	//SetElement("UnitDR","");
	//SetElement("ConsumableItem","");
	//SetElement("ConsumableItemDR","");
	//SetElement("Quantity","");
}

function EnableModel()
{
	if ((GetElementValue("SourceType")==1)||(GetElementValue("SourceType")==""))
	{
		DisableElement("Model",true)
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iModel").style.visibility="hidden"
	}
	if (GetElementValue("SourceType")==2)
	{
		DisableElement("Model",false)
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iModel").style.visibility=""
	}
}

function SourceID_Click()
{
	if (GetElementValue("SourceType")==1) //设备
	{
		LookUpSourceID("GetSourceID","SourceID,'',vNeedUseLoc,'',vBAFlag");
	}
	if (GetElementValue("SourceType")==2) //设备项
	{
		LookUpMasterItem("GetSourceID","'','',SourceID");
	}
}

function LookUpSourceID(jsfunction,paras)
{
	LookUp("","web.DHCEQEquip:GetShortEquip",jsfunction,paras);
}

function BFind_Click()
{
	var val="&SourceTypeDR="+GetElementValue("SourceTypeDR");
	val=val+"&SourceIDDR="+GetElementValue("SourceIDDR");
	val=val+"&ModelDR="+GetElementValue("ModelDR");
	val=val+"&ServiceItemDR="+GetElementValue("ServiceItemDR");
	val=val+"&ConsumableItemDR="+GetElementValue("ConsumableItemDR");
	val=val+"&Type="+GetElementValue("Type");
	val=val+"&TypeDR="+GetElementValue("TypeDR");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCServiceConsumable"+val;
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
	if (CheckInvalidData()) return;
	if (CheckTypeSelect())  return;  //Modefied by zc 2014-11-04 zc0019
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
	if (CheckInvalidData()) return;
	if (CheckTypeSelect())  return;   //Modefied by zc 2014-11-04 zc0019
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
    combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("SourceTypeDR");//来源类型
  	combindata=combindata+"^"+GetElementValue("SourceIDDR"); //来源名
  	combindata=combindata+"^"+GetElementValue("ServiceItemDR"); //服务
  	combindata=combindata+"^"+GetElementValue("ConsumableItemDR"); //消耗
  	combindata=combindata+"^"+GetElementValue("UnitDR"); //单位
  	combindata=combindata+"^"+GetElementValue("Quantity"); //数量
  	combindata=combindata+"^"+GetElementValue("ModelDR"); //机型
  	combindata=combindata+"^"+GetElementValue("QuantityTypeDR"); //数据类型
  	combindata=combindata+"^"+GetElementValue("ServDetItemDR"); //细项目
  	combindata=combindata+"^"+GetElementValue("MonthStatFlag"); 
  	combindata=combindata+"^"+GetElementValue("CycleNum"); //维护周期
  	combindata=combindata+"^"+GetElementValue("CycleUnitDR");
  	combindata=combindata+"^"+GetElementValue("Type"); //类型
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
	combindata=combindata+"^"+GetElementValue("Hold2") ;
	combindata=combindata+"^"+GetElementValue("Hold3") ;
	combindata=combindata+"^"+GetElementValue("Hold4") ;
	combindata=combindata+"^"+GetElementValue("Hold5") ;
  	return combindata;
}
///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCServiceConsumable');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)
	{
		Clear();	
		disabled(true)//灰化	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false);//反灰化
	}
}

function Clear()
{
	SetElement("SourceType","");
	SetElement("SourceTypeDR","");
	SetElement("SourceID","")
	SetElement("SourceIDDR","");
	SetElement("Model","");
	SetElement("ModelDR","");
	SetElement("ServiceItem","");
	SetElement("ServiceItemDR","");
	SetElement("Unit","");
	SetElement("UnitDR","");
	SetElement("ConsumableItem","");
	SetElement("ConsumableItemDR","");
	SetElement("Quantity","");
	// Mozy	2010-11-22
	SetElement("ServDetItemDR","");		// 细项
	SetElement("ServDetItem","");
	SetElement("QuantityTypeDR","");	// 数据类型
	SetElement("QuantityType","");
	SetElement("Type","");    //Modefied by zc 2014-11-04 zc0019 begin
	SetElement("TypeDR","");
	SetElement("CycleUnit","");
	SetElement("CycleUnitDR","");
	SetElement("CycleNum","");
	SetElement("MonthStatFlag","");   //Modefied by zc 2014-11-04 zc0019  end
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var list=gbldata.split("^");
	//alertShow(gbldata)
	SetElement("RowID",list[0]); //rowid
	SetElement("SourceTypeDR",list[1]);
	SetElement("SourceIDDR",list[2]);
	SetElement("ServiceItemDR",list[3]);
	SetElement("ConsumableItemDR",list[4]);
	SetElement("UnitDR",list[5]);
	SetElement("Quantity",list[6]);
	SetElement("ModelDR",list[7]);
	SetElement("SourceType",list[1]);
	SetElement("SourceID",list[20]);
	SetElement("ServiceItem",list[21]);
	SetElement("ConsumableItem",list[22]);
	SetElement("Unit",list[23]);
	SetElement("Model",list[24]);
	EnableModel();
	// Mozy	2010-11-22
	SetElement("QuantityTypeDR",list[8]);	// 数量类型
	SetElement("QuantityType",list[8]);
	SetElement("ServDetItemDR",list[9]);	// 细项
	SetElement("ServDetItem",list[26]);
	SetElement("MonthStatFlag",list[10]);   //Modefied by zc 2014-11-04 zc0019  begin
	SetElement("CycleNum",list[11]);
	SetElement("CycleUnitDR",list[12]);
	SetElement("CycleUnit",list[27]);
	SetElement("Type",list[13]);   //Modefied by zc 2014-11-04 zc0019  end
	EnableUnit();
	TypeSelect();   //Modefied by zc 2014-11-04 zc0019
}

function GetServiceItem(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ServiceItemDR");
	obj.value=type[1];
}

function GetSourceID(value)
{
	var type=value.split("^");
	var obj=document.getElementById("SourceID");
	obj.value=type[0];
	var obj=document.getElementById("SourceIDDR");
	obj.value=type[1];
}

function GetModel(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ModelDR");
	obj.value=type[1];
}

function GetUnit(value)
{
	var type=value.split("^");
	var obj=document.getElementById("UnitDR");
	obj.value=type[1];
}

function GetConsumableItem(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ConsumableItemDR");
	obj.value=type[1];
	SetElement("UnitDR",type[3]);
	SetElement("Unit",type[5]);
}
// Mozy	2010-11-19
function GetServDetItem(value)
{
	//alertShow(value);
	var type=value.split("^");
	var obj=document.getElementById("ServDetItemDR");
	obj.value=type[1];
}
function EnableUnit()
{
	//alertShow(GetElementValue("QuantityType"));
	// 绝对量
	if ((GetElementValue("QuantityType")==1)||(GetElementValue("QuantityType")==""))
	{
		DisableElement("Unit",false);
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iUnit").style.visibility="";
	}
	// 相对量
	if (GetElementValue("QuantityType")==2)
	{
		DisableElement("Unit",true);
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iUnit").style.visibility="hidden";
	}
	SetElement("QuantityTypeDR",GetElementValue("QuantityType"))
}
function QuantityType_change()
{
	EnableUnit();
	SetElement("Unit","");
	SetElement("UnitDR","");
}
//Modefied by zc 2014-11-04 zc0019
function TypeSelect()
{
	var Type=GetElementValue("Type");
	if(Type=="1")  //使用
	{
		DisableElement("MonthStatFlag",true);
		SetElement("MonthStatFlag","");
		DisableElement("CycleNum",true);
		ReadOnlyElement("CycleUnit",true);
		HiddenObj(GetLookupName("CycleUnit"),true);
		ReadOnlyElement("ServiceItem",false);
		HiddenObj(GetLookupName("ServiceItem"),false);
		DisableElement("ServiceItem",false);
		ReadOnlyElement("ServDetItem",false);
		HiddenObj(GetLookupName("ServDetItem"),false);
		DisableElement("ServDetItem",false);
	}
	else if(Type=="2")  //质控
	{
		DisableElement("MonthStatFlag",false);
		SetElement("MonthStatFlag","Y");
		DisableElement("CycleNum",false);
		ReadOnlyElement("CycleUnit",false);
		HiddenObj(GetLookupName("CycleUnit"),false);
		ReadOnlyElement("ServiceItem",true);
		HiddenObj(GetLookupName("ServiceItem"),true);
		DisableElement("ServiceItem",true);
		ReadOnlyElement("ServDetItem",true);
		HiddenObj(GetLookupName("ServDetItem"),true);
		DisableElement("ServDetItem",true);
	}
}
function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BUpdate",value);
	DisableBElement("BDelete",value);	
	DisableBElement("BAdd",!value);
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	if (!GetElementValue("MonthStatFlag"))
	{
		if ((GetElementValue("ServiceItemDR")=="")&&(GetElementValue("ServDetItemDR")==""))
		{
			alertShow(t["04"]);
			return true;
		}
	}
	if ((GetElementValue("QuantityType")==1)&&(GetElementValue("UnitDR")==""))
	{
		alertShow("绝对量数据的单位不能为空!");
		return true;
	}
	return false;
}
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("Quantity"),1,0,0,1)==0)
	{
		alertShow("数量异常,请修正.");
		//SetElement("Quantity","");
		return true;
	}
	return false;
}
//Modefied by zc 2014-11-04 zc0019
function CheckTypeSelect()
{
	var Type=GetElementValue("Type");
	if(Type==1)
	{
		if ((GetElementValue("ServiceItemDR")=="")&&(GetElementValue("ServDetItemDR")==""))      //modify by lmm 2017-03-25 353590
		{
			alertShow(t["04"]);
			return true;
		}
	}
	if(Type==2)
	{
		if(GetElementValue("SourceType")=="")
		{
			alertShow("来源类型不能为空");
			return true ;
		}
		if(GetElementValue("SourceID")=="")
		{
			alertShow("来源名不能为空");
			return true;
		}
		if(GetElementValue("CycleNum")=="")
		{
			alertShow("维护周期不能为空");
			return true;
		}
		if(GetElementValue("CycleUnit")=="")
		{
			alertShow("周期单位不能为空");
			return true;
		}
	}
	return false;
}
//add by zy 20141120 ZY0117
function GetCycleUnit(value) 
{
	GetLookUpID("CycleUnitDR",value);
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
