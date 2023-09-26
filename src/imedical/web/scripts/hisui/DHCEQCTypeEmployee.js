/// ***************************************
/// 修改人?ZY  2009-05-20 
/// 修改目的?增加了"设备类组"字段显示,查找
/// 修改函数?BFind_Click?CombinData?Clear? SetData
/// 增加函数?GetEquipType
/// BugNo.?ZY0003
/// ***************************************
var SelectedRow = -1;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler()
{
	initButtonWidth();  //hisui改造 add by kdf 2018-10-18
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("Employee^EquipType");	//清空选择
	KeyUp("EmployeeType");
	disabled(true);//灰化
	Muilt_LookUp("Employee^EquipType");
	Muilt_LookUp("EmployeeType");
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

function BFind_Click()
{
	var flag = GetChkElementValue("InvalidFlag")
	if (flag==false)
	{
		flag=""
	}
	else
	{
		flag="on"
	}
	var val="&Employee="+GetElementValue("Employee");
	val=val+"&EmployeeDR="+GetElementValue("EmployeeDR");
	val=val+"&EmployeeType="+GetElementValue("EmployeeType")
	val=val+"&EmployeeTypeDR="+GetElementValue("EmployeeTypeDR")
	////Modified by ZY   2009-05-21  bdgin
	val=val+"&EquipType="+GetElementValue("EquipType")
	val=val+"&EquipTypeDR="+GetElementValue("EquipTypeDR")
	////Modified by ZY   2009-05-21 end
	val=val+"&InvalidFlag="+flag
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCTypeEmployee"+val;
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
	combindata=combindata+"^"+GetElementValue("EmployeeTypeDR") ;//员工类型编码
  	combindata=combindata+"^"+GetElementValue("EmployeeDR") ; //员工编码
  	var flag=GetChkElementValue("InvalidFlag")
  	if (flag==false)
  	{
	  	flag="N"
  	}
  	else
  	{
	  	flag="Y"
  	}
  	combindata=combindata+"^"+flag ; //记录使用标识
  	combindata=combindata+"^"+GetElementValue("Remark") ; //备注
  	////Modified by ZY   2009-05-21 
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ; //设备类组DR
  	return combindata;
}
///选择表格行触发此方法
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)	{
		Clear();	
		disabled(true)//灰化	
		SelectedRow=-1;
		$('#tDHCEQCTypeEmployee').datagrid('unselectAll');  //hisui改造 add by kdf 2018-10-18
		SetElement("RowID","");
		}
	else{
		SelectedRow=index;
		rowid=rowdata.TRowID ;
		SetData(rowid);//调用函数
		disabled(false);//反灰化
		}
}

function Clear()
{
	SetElement("Rowid","");
	SetElement("Employee","");
	SetElement("EmployeeDR","")
	SetElement("EmployeeType","");
	SetElement("EmployeeTypeDR","");
	SetElement("Remark","");
	SetChkElement("InvalidFlag",0);
	////Modified by  ZY   2009-05-21 
	SetElement("EquipType","");
	SetElement("EquipTypeDR","");
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var list=gbldata.split("^");
	var flag=list[6]
	if (flag=="Y")
	{
		flag=1
	}
	else
	{
		flag=0
	}	
	SetElement("RowID",list[0]); //rowid
	SetElement("EmployeeTypeDR",list[1]); //员工类型
	SetElement("EmployeeType",list[2]); //员工类型
	SetElement("EmployeeDR",list[3]);//员工编码
	SetElement("Employee",list[4]);//员工编码解析员工名称
	SetElement("Remark",list[5]); //备注
	SetChkElement("InvalidFlag",flag); //停用标识
	////Modified by ZY   2009-05-21 
	SetElement("EquipType",list[8]);//设备类组编码
	SetElement("EquipTypeDR",list[7]);//设备类组编码解析设备类组名称
}

function GetEmployee(value) {
	var user=value.split("^");
	var obj=document.getElementById("EmployeeDR");
	obj.value=user[1];
}
////Modified by ZY   2009-05-21  bdgin
function GetEquipType(value) {
	var user=value.split("^");
	var obj=document.getElementById("EquipTypeDR");
	obj.value=user[1];
}
////Modified by ZY   2009-05-21  end

function GetEmployeeType(value) {
	var type=value.split("^");
	var obj=document.getElementById("EmployeeTypeDR");
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
