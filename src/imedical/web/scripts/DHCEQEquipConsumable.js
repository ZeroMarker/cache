var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("Model^ResourceType^Unit");
	disabled(true);//灰化
	Muilt_LookUp("Model^ResourceType^Unit");
	SetElement("SourceType",GetElementValue("SourceTypeDR"))
	EnableModel()
	fillData();
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
	val=val+"resourcetype=ResourceType="+GetElementValue("ResourceTypeDR")+"^";
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
	var obj=document.getElementById("ResourceType");
	if (obj) obj.onchange=ResourceType_change;
	var obj=document.getElementById("Price");
	if (obj) obj.onchange=changeAmount;
	var obj=document.getElementById("Quantity");
	if (obj) obj.onchange=changeAmount;
}

function SourceID_keydown()
{
	if (event.keyCode==13)
	{
		SourceID_Click();
	}
}

function ResourceType_change()
{
	SetElement("Unit","");
	SetElement("UnitDR","");
	SetElement("Price","");
	SetElement("Amount","");
	SetElement("ResourceTypeDR","");
}

function SourceType_change()
{
	SetElement("SourceTypeDR",GetElementValue("SourceType"))
	EnableModel()
	SetElement("SourceID","")
	SetElement("SourceIDDR","");
	SetElement("Model","");
	SetElement("ModelDR","");
	SetElement("ResourceType","");
	SetElement("ResourceTypeDR","");
	SetElement("Remark","");
	SetElement("Unit","");
	SetElement("UnitDR","");
	SetElement("Price","");
	SetElement("Amount","");
	SetElement("Quantity","");
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
	val=val+"&ResourceTypeDR="+GetElementValue("ResourceTypeDR");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipConsumable"+val;
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
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	changeAmount();
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
function BAdd_Click() //添加
{
	if (condition()) return;
	if (CheckInvalidData()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	changeAmount();
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
	combindata=combindata+"^"+GetElementValue("SourceTypeDR") ;//来源类型
  	combindata=combindata+"^"+GetElementValue("SourceIDDR") ; //来源名
  	combindata=combindata+"^"+GetElementValue("ResourceTypeDR") ; //资源
  	combindata=combindata+"^"+GetElementValue("Price") ; //单价
  	combindata=combindata+"^"+GetElementValue("UnitDR") ; //单位
  	combindata=combindata+"^"+GetElementValue("Quantity") ; //数量
  	combindata=combindata+"^"+GetElementValue("Amount") ; //金额
  	combindata=combindata+"^"+GetElementValue("Remark") ; //备注  
  	combindata=combindata+"^"+GetElementValue("ModelDR") ; //机型
  	return combindata;
}
///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQEquipConsumable');//+组件名 就是你的组件显示 Query 结果的部分
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
	SetElement("SourceType","")
	SetElement("SourceTypeDR","");
	SetElement("SourceID","")
	SetElement("SourceIDDR","");
	SetElement("Model","");
	SetElement("ModelDR","");
	SetElement("ResourceType","");
	SetElement("ResourceTypeDR","");
	SetElement("Remark","");
	SetElement("Unit","");
	SetElement("UnitDR","");
	SetElement("Price","");
	SetElement("Amount","");
	SetElement("Quantity","");
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("SourceTypeDR",list[1]);
	SetElement("SourceIDDR",list[2]);
	SetElement("ResourceTypeDR",list[3])
	SetElement("Price",list[4]);
	SetElement("UnitDR",list[5]);
	SetElement("Quantity",list[6]);
	SetElement("Amount",list[7]);	
	SetElement("Remark",list[8]);
	SetElement("ModelDR",list[9]);
	SetElement("SourceType",list[1]);
	SetElement("SourceID",list[11]);
	SetElement("ResourceType",list[12])
	SetElement("Unit",list[13]);
	SetElement("Model",list[14]);
	EnableModel()
}

function GetSourceID(value) {
	var type=value.split("^");
	var obj=document.getElementById("SourceID");
	obj.value=type[0];
	var obj=document.getElementById("SourceIDDR");
	obj.value=type[1];
}

function GetModel(value) {
	var type=value.split("^");
	var obj=document.getElementById("ModelDR");
	obj.value=type[1];
}

function GetResourceType(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ResourceTypeDR");
	obj.value=type[1];
	SetElement("Unit",type[6]);
	SetElement("UnitDR",type[5]);
	SetElement("Price",type[4]);
	changeAmount()
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
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("Price"),1,1,0,1)==0)
	{
		alertShow("单价数据异常,请修正.");
		//SetElement("Price","");
		return true;
	}
	if (IsValidateNumber(GetElementValue("Quantity"),1,0,0,1)==0)
	{
		alertShow("数量异常,请修正.");
		//SetElement("Quantity","");
		return true;
	}
	
	return false;
}
function changeAmount()
{
	//计算金额
	var Quantity=+GetElementValue("Quantity")
	//Mozy0049	2011-3-30
	if (IsValidateNumber(Quantity,1,0,0,1)==0)
	{
		alertShow("数量异常,请修正.");
		//SetElement("Quantity","");
		return;
	}
	var Price=+GetElementValue("Price")
	//Mozy0049	2011-3-30
	if (IsValidateNumber(Price,1,1,0,1)==0)
	{
		alertShow("单价异常,请修正.");
		//SetElement("Price","");
		return;
	}
	if (Price=="")
	{
		Price=0
	}
	SetElement("Amount",Quantity*Price)
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;
