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
	var obj=document.getElementById("ExType");
	if (obj) obj.onchange=ExType_change;
	var obj=document.getElementById("ExDesc");
	if (obj) obj.onkeydown=ExDesc_keydown;
	var obj=document.getElementById("ld"+GetElementValue("GetComponentID")+"iExDesc");
	if (obj) obj.onclick=ExDesc_Click;
}

function ExDesc_keydown()
{
	if (event.keyCode==13)
	{
		ExDesc_Click();
	}
}

function ExDesc_Click()
{
	if (GetElementValue("ExType")=="DHC-HIS")
	{
		LookUpExDesc("GetExDesc","ExDesc");
	}
}

function LookUpExDesc(jsfunction,paras)
{
	LookUp("","web.DHCEQCServiceItem:GetArcitmmast",jsfunction,paras);
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
		DisableElement("ExDesc",true)
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iExDesc").style.visibility="hidden"
	}
	if (GetElementValue("ExType")=="DHC-HIS")
	{
		DisableElement("ExType",false)
		DisableElement("ExDesc",false)
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iExDesc").style.visibility=""
	}
	if (GetElementValue("ExType")=="")
	{
		DisableElement("ExType",false)
		DisableElement("ExDesc",false)
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iExDesc").style.visibility="hidden"
	}
}

function BFind_Click()
{
	var val="&Code="+GetElementValue("Code");
	val=val+"&Desc="+GetElementValue("Desc");
	val=val+"&ExTypeDR="+GetElementValue("ExTypeDR");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCServiceItem"+val;
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
		alertShow(t["03"])
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
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCServiceItem');//+组件名 就是你的组件显示 Query 结果的部分
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
		DisableElement("ExDesc",true)
		DisableBElement("BAdd",true)
		DisableBElement("BUpdate",true)
		DisableBElement("BDelete",true)
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iExDesc").style.visibility="hidden"
	}
	else
	{

		if ((list[5]=="DHC-HIS")||(list[5]==""))
		{
			DisableElement("ExType",false)
			DisableElement("ExDesc",false)
			DisableBElement("BAdd",true)
			DisableBElement("BUpdate",false)
			DisableBElement("BDelete",false)
			document.getElementById("ld"+GetElementValue("GetComponentID")+"iExDesc").style.visibility=""
		}
		else
		{
			DisableElement("ExType",true)
			DisableElement("ExDesc",true)
			DisableBElement("BAdd",true)
			DisableBElement("BUpdate",true)
			DisableBElement("BDelete",true)
			document.getElementById("ld"+GetElementValue("GetComponentID")+"iExDesc").style.visibility="hidden"
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
