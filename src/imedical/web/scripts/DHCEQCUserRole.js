// DHCEQCUserRole.js
var SelectedRow = 0;
var SelectRow = 0;
var rowid=0;
var rows;
function BodyLoadHandler()
{
	InitUserInfo();
	InitEvent();
	disabled(true);
	SetElement("SourceTypeDR","");
	SetElement("SourceType","");
	KeyUp("Source^Role^BussType");
	Muilt_LookUp("Source^Role^BussType");
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
	var obj=document.getElementById("BFind")
	if (obj) obj.onclick=BFind_Click;
	
	var obj=document.getElementById("SourceType");
	if (obj) obj.onchange=SourceType_change;
	var obj=document.getElementById("Source");
	if (obj) obj.onkeydown=Source_keydown;
	var obj=document.getElementById("ld"+GetElementValue("GetComponentID")+"iSource");
	if (obj) obj.onclick=Source_Click;
}
function BAdd_Click() //增加
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth==""){return;}
	var plist=CombinData(); //函数调用
	//alertShow("plist="+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'0');
	result=result.replace(/\\n/g,"\n");
	if (result>0)
	{
		location.reload();
	}
	else if (result=="")
	{
		alertShow("记录已存在,不能重复添加!");
	}
	else if (result=="")
	{
		alertShow(t[-2201]);
	}
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;	
	var plist=CombinData(); //函数调用
	//alertShow("plist="+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n");
	if (result>0)
	{
		location.reload();
	}
	else if (result=="")
	{
		alertShow("记录已存在,不能重复添加!");
	}
	else if (result=="")
	{
		alertShow(t[-2201]);
	}
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID");//1
	combindata=combindata+"^"+GetElementValue("SourceTypeDR");//来源类型
  	combindata=combindata+"^"+GetElementValue("SourceDR");//来源
  	combindata=combindata+"^"+GetElementValue("RoleDR");//用户
  	combindata=combindata+"^"+GetElementValue("BussTypeDR");//地址5
  	
  	return combindata;
}
function BFind_Click()
{
	var link="&SourceTypeDR="+GetElementValue("SourceTypeDR")+"&SourceDR="+GetElementValue("SourceDR");
	link=link+"&SourceType="+GetElementValue("SourceType")+"&Source="+GetElementValue("Source");
	link=link+"&RoleDR="+GetElementValue("RoleDR")+"&BussTypeDR="+GetElementValue("BussTypeDR");
	link=link+"&Role="+GetElementValue("Role")+"&BussType="+GetElementValue("BussType");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCUserRole"+link;
}
function BClear_Click()
{
	Clear();
	disabled(true);
}
function BDelete_Click()
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") {return;}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n");
	//alertShow("result"+result);
	if (result>0) {location.reload();}	
}
///选择表格行触发此方法
var SelectedRow = 0;
var rowid=0;
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCUserRole');
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
		disabled(false)//反灰化
	}
}
function Clear()
{
	SetElement("RowID","");
	SetElement("SourceDR","");
	SetElement("RoleDR","");
	SetElement("BussTypeDR","");
	SetElement("Source","");
	SetElement("Role","");
	SetElement("BussType","");
	SetElement("SourceType","");
	SetElement("SourceTypeDR","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth==""){return;}
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	//alertShow("gbldata="+gbldata);
	var list=gbldata.split("^");
	SetElement("RowID",list[0]);//rowid
	SetElement("SourceTypeDR",list[1]); //来源类型1
	SetElement("SourceDR",list[2]);//来源2
	SetElement("RoleDR",list[3]);//角色3
	SetElement("BussTypeDR",list[4]);//业务4
	SetElement("SourceType",list[1]);
	SetElement("Source",list[6]);
	SetElement("Role",list[7]);
	SetElement("BussType",list[8]);
}
function disabled(value)
{
	InitEvent();
	DisableBElement("BAdd",!value);
	DisableBElement("BUpdate",value);
	DisableBElement("BDelete",value);
}
function GetSourceDR(value)
{
	//alertShow(value)
	var type=value.split("^");
	var obj=document.getElementById("Source");
	obj.value=type[0];
	var obj=document.getElementById("SourceDR");
	obj.value=type[1];
}
function GetRole(value)
{
	//alertShow(value)
	var type=value.split("^");
	var obj=document.getElementById("RoleDR");
	obj.value=type[1];
}
function GetBussType(value)
{
	//alertShow(value)
	var type=value.split("^");
	var obj=document.getElementById("BussTypeDR");
	obj.value=type[1];
}
function SourceType_change()
{
	SetElement("SourceTypeDR",GetElementValue("SourceType"));
	
	SetElement("Source","");
	SetElement("SourceDR","");
}
function Source_keydown()
{
	if (event.keyCode==13)
	{
		Source_Click();
	}
}
function Source_Click()
{
	//alertShow(GetElementValue("SourceType"));
	if (GetElementValue("SourceType")==2) //安全组
	{
		LookUpGroup("GetSourceDR","Source");
	}
	if (GetElementValue("SourceType")==1) //用户名
	{
		LookUpCTUser("GetSourceDR","Source");
	}
}
function LookUpGroup(jsfunction,paras)
{
	LookUp("","web.DHCEQCGroupCTable:Group",jsfunction,paras);
}
function condition()
{
	if (CheckMustItemNull()) return true;
	/*if (CheckItemNull(0,"Name")) return true;
	if (CheckItemNull(0,"Code")) return true;*/
	return false;
}
document.body.onload = BodyLoadHandler;