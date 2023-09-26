var SelectedRow = -1; ///Modify By QW 2018-10-11 HISUI改造
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	initButtonWidth();///Add By QW 2018-10-11 HISUI改造:修改按钮长度
	setButtonText();///Add By QW 2018-10-11 HISUI改造:按钮文字规范
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("Model^Service");
	disabled(true);//灰化
	Muilt_LookUp("Model^Service");
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
	val=val+"service=Service="+GetElementValue("ServiceDR")+"^";
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
	//hisui改造:放大镜触发前响应 add by QW 2018-10-11 
	$('#Service').lookup('options').onBeforeShowPanel= function(){
		Service_change();
	};
	///add by QW 2018-10-11 描述：hisui改造 隐藏/放开放大镜
	$('#Model').lookup('options').onBeforeShowPanel= function(){
 			return $("#Model").lookup('options').hasDownArrow
	};
}

///add by QW 2018-10-10
///描述：hisui改造 下拉列表onchange事件更改
 $('#SourceType').combobox({
     onSelect:function () {
	   SourceType_change();
    },
     onChange:function () {
	   SourceID_Click();
    }
 })


function Service_change()
{
	SetElement("MinMinutes","");
	SetElement("MinutesPerTimes","");
	SetElement("MaxMinutes","");
	SetElement("ServiceDR","");
}

function SourceType_change()
{
	SetElement("SourceTypeDR",GetElementValue("SourceType"))
	EnableModel()
	SetElement("SourceID","")
	SetElement("SourceIDDR","");
	SetElement("Model","");
	SetElement("ModelDR","");
	SetElement("Service","");
	SetElement("ServiceDR","");
	SetElement("Remark","");
	SetElement("MinMinutes","");
	SetElement("MinutesPerTimes","");
	SetElement("MaxMinutes","");
}

function EnableModel()
{
	if ((GetElementValue("SourceType")==1)||(GetElementValue("SourceType")==""))
	{
		///add by QW 2018-10-10 描述：hisui改造 隐藏/放开放大镜
		$("#Model").lookup({hasDownArrow:false,disable:true})
	}
	if (GetElementValue("SourceType")==2)
	{
		///add by QW 2018-10-10 描述：hisui改造 隐藏/放开放大镜
		$("#Model").lookup({hasDownArrow:true,disable:false})
	}
}
///hisui改造:放大镜不能根据不同的值调用不同的query Modified by QW 2018-10-11
function SourceID_Click()
{
	if (GetElementValue("SourceType")==1) //设备
	{
		singlelookup("SourceID","EM.L.Equip","",GetSourceID);
	}
	if (GetElementValue("SourceType")==2) //设备项
	{
		singlelookup("SourceID","EM.L.GetMasterItem","",GetSourceID);
	}
}

///Add By QW 2018-10-10 hisui组件调整步骤
function BFind_Click()
{
	var val="&SourceTypeDR="+GetElementValue("SourceTypeDR");
	val=val+"&SourceIDDR="+GetElementValue("SourceIDDR");
	val=val+"&ModelDR="+GetElementValue("ModelDR");
	val=val+"&ServiceDR="+GetElementValue("ServiceDR");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQEquipService"+val;
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
	var result=cspRunServerMethod(encmeth,rowid,'1');
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
	var result=cspRunServerMethod(encmeth,plist);
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
	var result=cspRunServerMethod(encmeth,plist,'2');
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
	combindata=combindata+"^"+GetElementValue("SourceTypeDR") ;//来源类型
  	combindata=combindata+"^"+GetElementValue("SourceIDDR") ; //来源名
  	combindata=combindata+"^"+GetElementValue("ModelDR") ; //机型
  	combindata=combindata+"^"+GetElementValue("ServiceDR") ; //服务
  	combindata=combindata+"^"+GetElementValue("MinMinutes") ; //最小分钟数
  	combindata=combindata+"^"+GetElementValue("MinutesPerTimes") ; //每次分钟数
  	combindata=combindata+"^"+GetElementValue("MaxMinutes") ; //最大分钟数  
  	combindata=combindata+"^"+GetElementValue("Remark") ; //扩展ID
  	return combindata;
}
///选择表格行触发此方法
//Modify By QW 2018-10-11 HISUI改造：点击选择行后，界面无法正常填充数据
///解决方法传入index,rowdata两个参数，并修改判断逻辑
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		Clear();	
		disabled(true)//灰化
		SelectedRow=-1;	
		SetElement("RowID","");
		$('#tDHCEQEquipService').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	SetData(rowdata.TRowID);//调用函数
	disabled(false);//反灰化
}

function Clear()
{
	setElement("RowID","")  //add hly 2019-10-15
	SetElement("SourceType","");
	SetElement("SourceTypeDR","");
	SetElement("SourceID","")
	SetElement("SourceIDDR","");
	SetElement("Model","");
	SetElement("ModelDR","");
	SetElement("Service","");
	SetElement("ServiceDR","");
	SetElement("Remark","");
	SetElement("MinMinutes","");
	SetElement("MinutesPerTimes","");
	SetElement("MaxMinutes","");
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
	SetElement("ModelDR",list[3])
	SetElement("ServiceDR",list[4]);
	SetElement("MinMinutes",list[5]);
	SetElement("MinutesPerTimes",list[6]);
	SetElement("MaxMinutes",list[7]);	
	SetElement("Remark",list[8]);
	SetElement("SourceType",list[1]);
	SetElement("SourceID",list[11]);
	SetElement("Model",list[12])
	SetElement("Service",list[13]);
	EnableModel()
}

function GetService(value) {
	var type=value.split("^");
	var obj=document.getElementById("ServiceDR");
	obj.value=type[1];
	SetElement("MinMinutes",type[5]);
	SetElement("MinutesPerTimes",type[6]);
	SetElement("MaxMinutes",type[7]);
}
///add by QW 2018-10-11
///描述：hisui改造 根据下拉列表重新定义设备名称下拉框
function GetSourceID(item) {
	SourceType = $("#SourceType").combobox('getValue')
	if(SourceType==1)
	{
		SetElement('SourceIDDR',item.TRowID)
		SetElement('SourceID',item.TName)
		// Add By Qw20181025 需求号:725075
		SetElement('Model',item.TModel)
		SetElement('ModelDR',item.TModelDR)
		//End By Qw20181025 需求号:725075
	}
	else if(SourceType==2)
	{
		SetElement('SourceIDDR',item.TRowID)
		SetElement('SourceID',item.TName)
	}
}

function GetModel(value) {
	var type=value.split("^");
	var obj=document.getElementById("ModelDR");
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
	if (IsValidateNumber(GetElementValue("MinMinutes"),1,0,0,1)==0)
	{
		alertShow("最小分钟数异常,请修正.");
		//SetElement("MinMinutes","");
		return true;
	}
	if (IsValidateNumber(GetElementValue("MaxMinutes"),1,0,0,1)==0)
	{
		alertShow("最大分钟数异常,请修正.");
		//SetElement("MaxMinutes","");
		return true;
	}
	if (IsValidateNumber(GetElementValue("MinutesPerTimes"),1,0,0,1)==0)
	{
		alertShow("每次分钟数异常,请修正.");
		//SetElement("MinutesPerTimes","");
		return true;
	}
	return false;
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
