var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI改造
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	initButtonWidth();///Add By QW 2018-10-11 HISUI改造:修改按钮长度
	setButtonText();///Add By QW 2018-10-11 HISUI改造:按钮文字规范
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("Equip^User");
	disabled(true);//灰化
	Muilt_LookUp("Equip^User");
	fillData();
}

function fillData()
{
	var val="";
	val=val+"equip=Equip="+GetElementValue("EquipDR")+"^";
	val=val+"user=User="+GetElementValue("UserDR");
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
}
///Add By QW 2018-10-10 hisui组件调整步骤
function BFind_Click()
{
	var val="&EquipDR="+GetElementValue("EquipDR");
	val=val+"&UserDR="+GetElementValue("UserDR");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipOperator"+val;
}

function BClear_Click() 
{
	Clear();
	disabled(true);
}
function BDelete_Click() //删除
{
	///modified by ZY0215 2020-04-02
	messageShow("confirm","","",t[-4003],"",confirmFun,"")
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	rowid=GetElementValue("RowID");
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	messageShow("","","",t["02"])
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
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
		messageShow("","","",t["03"]);
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
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result=="")
	{
		messageShow("","","",t["03"])
		return
	}
	if (result>0)location.reload();	
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("EquipDR") ;//代码
  	combindata=combindata+"^"+GetElementValue("UserDR") ; //描述
  	combindata=combindata+"^"+GetElementValue("Percent") ; //单价
  	combindata=combindata+"^"+GetElementValue("Remark") ; //单位
  	combindata=combindata+"^"+GetElementValue("FromDate") ; //扩展类型
  	combindata=combindata+"^"+GetElementValue("ToDate") ; //扩展ID
  	return combindata;
}
///选择表格行触发此方法
///Modify By QW 2018-10-11 HISUI改造：点击选择行后，界面无法正常填充数据
///解决方法传入index,rowdata两个参数，并修改判断逻辑
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		Clear();	
		disabled(true)//灰化
		SelectedRow=-1;	
		SetElement("RowID","");
		$('#tDHCEQEquipOperator').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	SetData(rowdata.TRowID);//调用函数
	disabled(false);//反灰化
}

function Clear()
{
	SetElement("EquipDR","");
	SetElement("Equip","");
	SetElement("User","")
	SetElement("UserDR","");
	SetElement("Percent","");
	SetElement("Remark","");
	SetElement("FromDate","");
	SetElement("ToDate","");
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
	SetElement("UserDR",list[2]);
	SetElement("Percent",list[3])
	SetElement("Remark",list[4]);
	SetElement("FromDate",list[5]);
	SetElement("ToDate",list[6]);
	SetElement("Equip",list[7]);
	SetElement("User",list[8]);
}

function GetEquip(value) {
	var type=value.split("^");
	var obj=document.getElementById("EquipDR");
	obj.value=type[1];
}

function GetUser(value) {
	var type=value.split("^");
	var obj=document.getElementById("UserDR");
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
	if (IsValidateNumber(GetElementValue("Percent"),1,1,0,1)==0)
	{
		alertShow("占比(%)数据异常,请修正.");
		//SetElement("Price","");
		return true;
	}
	
	return false;
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
