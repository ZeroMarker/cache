var SelectedRow = -1; ///Modify By QW 2018-10-08 HISUI改造
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	initButtonWidth();///Add By QW 2018-10-08 HISUI改造:修改按钮长度
	setButtonText();///Add By QW 2018-10-08 HISUI改造:按钮文字规范
	InitUserInfo();
	InitEvent();	//初始化
	KeyUp("Unit");
	disabled(true);//灰化
	Muilt_LookUp("Unit");
	SetElement("ExType",GetElementValue("ExTypeDR"));
	changeExDesc();
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
	//hisui改造:放大镜隐藏后触发 add by QW 2018-10-08 
	$('#ExDesc').lookup('options').onHidePanel= function(){
		ExDesc_Click();
	};
	///add by QW 2018-10-08 描述：hisui改造 隐藏/放开放大镜
	$('#ExDesc').lookup('options').onBeforeShowPanel= function(){
 			return $("#ExDesc").lookup('options').hasDownArrow
	};

}
///add by QW 2018-10-08 
///描述：hisui改造 下拉列表onchange事件更改
 $('#ExType').combobox({
    onChange: function () {
	   ExType_change();
    }
 })

function ExDesc_Click()
{
	if (GetElementValue("ExType")=="DHC-HIS")
	{
		///add by QW 2018-10-08
		///描述：hisui改造 隐藏/放开放大镜
		/// Modified BY QW20181029 需求号:590075
		$("#ExDesc").lookup({hasDownArrow:true,disable:false})
	}
}


function ExType_change()
{
	SetElement("ExTypeDR",GetElementValue("ExType"));
	changeExDesc();
	SetElement("ExID","");
	SetElement("ExDesc","");
}

function changeExDesc()
{
	if ((GetElementValue("ExType")=="DHC-LIS")||(GetElementValue("ExType")=="DHC-RIS"))
	{
		DisableElement("ExType",true)
		///add by QW 2018-10-08 
		///描述：hisui改造 隐藏/放开放大镜
		$("#ExDesc").lookup({hasDownArrow:false,disable:true}) 
	}
	if (GetElementValue("ExType")=="DHC-HIS")
	{
		DisableElement("ExType",false)
		///add by QW 2018-10-08 
		///描述：hisui改造 隐藏/放开放大镜
		$("#ExDesc").lookup({hasDownArrow:true,disable:false})
	}
	if (GetElementValue("ExType")=="")
	{
		DisableElement("ExType",false)
		///add by QW 2018-10-08 
		///描述：hisui改造 隐藏/放开放大镜
		$("#ExDesc").lookup({hasDownArrow:false,disable:false})
	}
}
///Add By QW 2018-10-08 hisui组件调整步骤
function BFind_Click()
{
	var val="&Code="+GetElementValue("Code");
	val=val+"&Desc="+GetElementValue("Desc");
	val=val+"&ExTypeDR="+GetElementValue("ExTypeDR");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCServiceItem"+val;
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
  	if ((GetElementValue("ExType")!="")&&(GetElementValue("ExID")==""))
  	{
	  	alertShow("请选择扩展描述!")
	  	return
  	}
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
	if (CheckInvalidData()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
  	if ((GetElementValue("ExType")!="")&&(GetElementValue("ExID")==""))
  	{
	  	alertShow("请选择扩展描述!")
	  	return
  	}
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
  	var flag=GetChkElementValue("ImportFlag")
  	if (flag==false)
  	{
	  	flag="N"
  	}
  	else
  	{
	  	flag="Y"
  	}
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Desc") ;//代码
  	combindata=combindata+"^"+GetElementValue("Code") ; //描述
  	combindata=combindata+"^"+GetElementValue("UnitDR") ; //单位
  	combindata=combindata+"^"+GetElementValue("Price") ; //单价
  	combindata=combindata+"^"+GetElementValue("ExType") ; //扩展类型
  	combindata=combindata+"^"+GetElementValue("ExID") ; //扩展ID
  	combindata=combindata+"^"+GetElementValue("Remark") ; //扩展ID
  	combindata=combindata+"^"+flag ; //导入标识
  	combindata=combindata+"^"+GetElementValue("MinMinutes") ; //最小分钟数
  	combindata=combindata+"^"+GetElementValue("MinutesPerTimes") ; //每次分钟数
  	combindata=combindata+"^"+GetElementValue("MaxMinutes") ; //最大分钟数
  	combindata=combindata+"^^^"+GetElementValue("ExDesc") ; //扩展描述


  	return combindata;
}
///选择表格行触发此方法
//Modify By QW 2018-10-08 HISUI改造：点击选择行后，界面无法正常填充数据
///解决方法传入index,rowdata两个参数，并修改判断逻辑
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		Clear();	
		disabled(true)//灰化
		SelectedRow=-1;	
		SetElement("RowID","");
		$('#tDHCEQCServiceItem').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	SetData(rowdata.TRowID);//调用函数
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
	SetElement("ExTypeDR","");     //modified by czf 386456
	SetElement("ExID","");
	SetElement("Remark","");
	SetElement("MinMinutes","");
	SetElement("MinutesPerTimes","");
	SetElement("MaxMinutes","");
	SetChkElement("ImportFlag",0);
	SetElement("ExDesc","");
	changeExDesc();
}
	
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var list=gbldata.split("^");
	var flag=list[8]
	if (flag=="Y")
	{
		flag=1
		DisableElement("ExType",true)
		DisableBElement("BAdd",true)
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)
		///add by QW 2018-10-08 
		///描述：hisui改造 隐藏/放开放大镜
		/// Modified BY QW20181029 需求号:590075
		$("#ExDesc").lookup({hasDownArrow:false,disable:true})
		
	}
	else
	{

		if ((list[5]=="DHC-HIS")||(list[5]==""))
		{
			DisableElement("ExType",false)
			DisableBElement("BAdd",true)
			DisableBElement("BUpdate",false)
			DisableBElement("BDelete",false)
			///add by QW 2018-10-08 
			///描述：hisui改造 隐藏/放开放大镜
			/// Modified BY QW20181029 需求号:590075
			$("#ExDesc").lookup({hasDownArrow:true,disable:false})
		}
		else
		{
			DisableElement("ExType",true)
			DisableBElement("BAdd",true)
			DisableBElement("BUpdate",true)
			DisableBElement("BDelete",true)
			///add by QW 2018-10-08 
		    ///描述：hisui改造 隐藏/放开放大镜
		    /// Modified BY QW20181029 需求号:590075
			$("#ExDesc").lookup({hasDownArrow:false,disable:true})
		}
		flag=0
	}
	SetElement("RowID",list[0]); //rowid
	SetElement("Desc",list[1]);
	SetElement("Code",list[2]);
	SetElement("UnitDR",list[3])
	SetElement("Price",list[4]);
	SetElement("ExType",list[5]);
	SetElement("ExTypeDR",list[5]);   //add by mwz 2017-11-17需求号468808
	SetElement("ExID",list[6]);
	SetElement("Remark",list[7]);
	SetElement("MinMinutes",list[9]);
	SetElement("MinutesPerTimes",list[10]);
	SetElement("MaxMinutes",list[11]);
	SetChkElement("ImportFlag",flag);
	SetElement("Unit",list[15]);
	SetElement("ExDesc",list[14]);
	InitEvent();
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
function GetExDesc(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ExDesc");
	obj.value=type[0];
	var obj=document.getElementById("ExID");
	obj.value=type[1];
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;
