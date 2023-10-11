var SelectedRow = -1; ///Modify By QW 2018-10-08 HISUI改造
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	initButtonWidth();///Add By QW 2018-10-10 HISUI改造:修改按钮长度
	setButtonText();///Add By QW 2018-10-10 HISUI改造:按钮文字规范
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
}
///add by QW 2018-10-10
///描述：hisui改造 下拉列表onchange事件更改
///Modified By QW20181026需求号:724635
 $('#ExType').combobox({
    onSelect: function () {
	   ExType_Change();
    }
 })
function ExType_Change()
{
	SetElement("ExTypeDR",GetElementValue("ExType"));
	SetElement("ExID","")
}
///Add By QW 2018-10-08 hisui组件调整步骤
function BFind_Click()
{
	var val="&Code="+GetElementValue("Code");
	val=val+"&Desc="+GetElementValue("Desc");
	val=val+"&ExTypeDR="+GetElementValue("ExTypeDR");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCConsumableItem"+val;
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
		messageShow("","","",t["03"]);
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
		messageShow("","","",t["03"])
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

    //add by sjh 2020-01-20 start
	combindata=combindata+"^^^^^"+GetElementValue("ChargeType") ; //收费类型
	combindata=combindata+"^"+GetElementValue("ExpenseType") ; //医保报销
	combindata=combindata+"^"+GetElementValue("AdditionRate") ; //加成率
	combindata=combindata+"^"+GetElementValue("BillItemNo") ; //收费项目编号
	combindata=combindata+"^"+GetElementValue("RegistrationNo") ; //注册证号
	combindata=combindata+"^"+GetElementValue("ExpenseRate") ; //医保报销比例
	combindata=combindata+"^"+GetElementValue("DisposableFlag") ; //是否为一次性
    //add by sjh 2020-01-20 end
  	return combindata;
}
///选择表格行触发此方法
//Modify By QW 2018-10-10 HISUI改造：点击选择行后，界面无法正常填充数据
///解决方法传入index,rowdata两个参数，并修改判断逻辑
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		Clear();	
		disabled(true)//灰化
		SelectedRow=-1;	
		SetElement("RowID","");
		$('#tDHCEQCConsumableItem').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	SetData(rowdata.TRowID);//调用函数
	disabled(false);//反灰化
}

function Clear()
{
	SetElement("RowID","");  //add hly 2019-10-21 bug:1041273
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
	SetElement("IncItmID",""); //Add By QW20181029 需求号:590106
	//add by sjh 2020-01-20 start
	SetElement("ChargeType","");
	SetElement("ExpenseType","");
	SetElement("AdditionRate","");
	SetElement("BillItemNo","");
	SetElement("RegistrationNo","");
	SetElement("ExpenseRate","");
	SetElement("DisposableFlag","");
	//add by sjh 2020-01-20 end
}
	
function SetData(rowid)
{
	if (rowid=="") return; //modified by ZY0248 2020-12-21
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
	SetElement("Unit",list[21]); //modified by sjh SJH0031 2020-08-03
	SetElement("ExType",list[5]);
	SetElement("PayPrice",list[9]);
	//add by sjh 2020-01-20 start
	SetElement("ChargeType",list[14]);
	SetElement("ExpenseType",list[15]);
	SetElement("AdditionRate",list[16]);
	SetElement("BillItemNo",list[17]);
	SetElement("RegistrationNo",list[18]);
	SetElement("ExpenseRate",list[19]);
	SetElement("DisposableFlag",list[20]);
	//add by sjh 2020-01-20 end
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
