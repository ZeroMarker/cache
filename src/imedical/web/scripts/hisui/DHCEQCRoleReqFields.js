/// -------------------------------
/// 创建:ZY  2010-08-03   BugNo.:ZY0027
/// 描述:编辑字段
/// --------------------------------
var SelectedRow = -1; ///Modify By QW 2018-08-31 HISUI改造
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler()
{
	hidePanelTitle(); //added by LMH 20230211 UI 极简组件界面弹框面板标题隐藏
	initPanelHeaderStyle(); //added by LMH 20230211 UI 极简组件界面标题格式
	//showBtnIcon('BAdd^BUpdate^BDelete^BFind',false); //modified by LMH 20230211 动态设置是否极简显示按钮图标
	//initButtonWidth();///Add By QW 2018-08-31 HISUI改造:修改按钮长度
	initButtonColor(); //added by LMH 20230211 UI 初始化按钮颜色
	setButtonText();///Add By QW 2018-09-29 HISUI改造:按钮文字规范
	InitUserInfo();
	InitEvent();	//初始化
	disabled(true);//灰化
  	KeyUp("Type")
  	Muilt_LookUp("Type");
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
}
//add by cjt 需求号2782419 2022-08-17
function BFind_Click()
{
	var url="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCRoleReqFields&ApproveFlowDR="+GetElementValue("ApproveFlowDR")+"&vData="+GetVData();
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href=url;
}
//add by cjt 需求号2782419 2022-08-17 拼接查询参数
function GetVData()
{
	var val="^vField="+GetElementValue("Field");
	val=val+"^vType="+GetElementValue("Type");
	val=val+"^vPosition="+GetElementValue("Position");
	val=val+"^vHold1="+GetElementValue("Hold1");
	val=val+"^vTableName="+GetElementValue("TableName");
	val=val+"^vSort="+GetElementValue("Sort");
	val=val+"^vHold2="+GetElementValue("Hold2");
	val=val+"^vMustFlag="+GetElementValue("MustFlag");
	return val;
}
function BAdd_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'0');
	result=result.replace(/\\n/g,"\n")
	if(result!=0)
	{
		messageShow("","","",t[-1000])
		return
	}
	if (result==0)location.reload();
}

function BUpdate_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'2');
	result=result.replace(/\\n/g,"\n")
	//messageShow("","","",result)
	if(result!=0)
	{
		messageShow("","","",t[-1000])
		return
	}
	if (result==0)location.reload();	
}

function BDelete_Click()
{
	var plist=CombinData(); //函数调用
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,plist,'1');
	result=result.replace(/\\n/g,"\n")
	if(result!=0)
	{
		messageShow("","","",t[-1000])
		return
	}
	if (result==0)location.reload();			
}

///选择表格行触发此方法
///Modify By QW 2018-08-31 HISUI改造：点击选择行后，界面无法正常填充数据
///解决方法传入index,rowdata两个参数，并修改判断逻辑
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		Clear();
		disabled(true)//灰化	
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
		$('#tDHCEQCRoleReqFields').datagrid('unselectAll');
		return;
	 }
	SelectedRow = index
	SetData(rowdata.TRowID);//调用函数
	disabled(false)//反灰化
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var list=gbldata.split("^");
	SetElement("RowID",rowid);
	//SetElement("ApproveFlowDR",list[0]);
	SetChkElement("MustFlag",list[13]);
	SetElement("Field",list[2])
	SetElement("Type",list[14])
	SetElement("TypeDR",list[3])
	SetElement("Position",list[4])
	SetElement("TableName",list[5])
	SetElement("Sort",list[6])
	SetChkElement("Hold1",list[7]);
	SetElement("Hold2",list[8])
	SetElement("Hold3",list[9])
	SetElement("Hold4",list[10])
	SetElement("Hold5",list[11])
}

function disabled(value)//灰化
{
	InitEvent();	
	DisableBElement("BAdd",!value)
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("ApproveFlowDR") ;
  	combindata=combindata+"^"+GetChkElementValue("MustFlag") ;
  	combindata=combindata+"^"+GetElementValue("Field") ;
  	combindata=combindata+"^"+GetElementValue("TypeDR") ;
  	combindata=combindata+"^"+GetElementValue("Position") ;
  	combindata=combindata+"^"+GetElementValue("TableName") ;
  	combindata=combindata+"^"+GetElementValue("Sort") ;
  	combindata=combindata+"^"+GetChkElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	combindata=combindata+"^"+GetElementValue("Hold4") ;
  	combindata=combindata+"^"+GetElementValue("Hold5") ;
  	return combindata;
}
function Clear()
{
	SetElement("RowID","");
	//SetElement("ApproveFlowDR","");
	SetChkElement("MustFlag","");
	SetElement("Field","")
	SetElement("Type","")
	SetElement("TypeDR","")
	SetElement("Position","")
	SetElement("TableName","")
	SetElement("Sort","")
	SetChkElement("Hold1","")
	SetElement("Hold2","")
	SetElement("Hold3","")
	SetElement("Hold4","")
	SetElement("Hold5","")
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;	
	return false;
}
function GetTypeID(value)
{
	GetLookUpID("TypeDR",value);
}

document.body.onload = BodyLoadHandler;
