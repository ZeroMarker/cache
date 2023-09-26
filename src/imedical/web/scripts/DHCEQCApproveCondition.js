//装载页面  函数名称固定
function BodyLoadHandler() {
	
	InitPage();
	ChangeStatus(false);
	InitUserInfo();
}

function InitPage(){
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BUpdate_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	var BDobj=document.getElementById("BClose");
	if (BDobj) BDobj.onclick=BClose_click;
	KeyUp("ConditionFields");
	Muilt_LookUp("ConditionFields");	
}
//点击表格项填充自由项,函数名称固定
var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQCApproveCondition'); //得到表格   t+组件名称
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	if (selectrow==SelectedRow)
	{
		SetElement("RowID","");
		Fill("^^^^^^^^^^^")
		SelectedRow=0;
		ChangeStatus(false);
		return;
	}
	ChangeStatus(true);
	FillData(selectrow)
    SelectedRow = selectrow;
}
function FillData(selectrow)
{
	var RowID=document.getElementById("TRowIDz"+selectrow).value;
	SetElement("RowID",RowID);
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	Fill(ReturnList)
}
function Fill(ReturnList)
{
	list=ReturnList.split("^");
	SetElement("ApproveSetDR",list[0]);
	SetElement("ConditionFieldsDR",list[1]);
	SetElement("Value",list[2]);
	SetElement("ToValue",list[3]);
	SetElement("ConditionFields",list[9]);
	SetElement("TableName",list[10]);
	SetElement("Type",list[11]);
}
function BClose_click()
{
	window.close();
}
//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	var val=GetValue();
	var Return=UpdateData(val,"0");
	if (Return!=0)
	{
		window.location.reload();
	}
	else
	{
		alertShow(Return+"  "+t["01"]);
	}
}
function GetValue()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("ApproveSetDR") ;
  	combindata=combindata+"^"+GetElementValue("ConditionFieldsDR") ;
  	combindata=combindata+"^"+GetElementValue("Value") ;
  	combindata=combindata+"^"+GetElementValue("ToValue") ;
  	return combindata;
}
//删除按钮点击函数
function BDelete_click()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID");
	var Return=UpdateData(RowID,"1");
	if (Return<0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		window.location.reload();
	}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
function UpdateData(val,AppType)
{
	var encmeth=GetElementValue("upd");
	var Return=cspRunServerMethod(encmeth,val,AppType);
	return Return;
}

function GetConditionFields(value) 
{
	var list=value.split("^");
	SetElement("ConditionFieldsDR",list[0]);
	SetElement("ConditionFields",list[1]);
	SetElement("Type",list[3]);
	if (GetElementValue("Type")==0)
	{
		ReadOnlyElement("ToValue",true)
	}
	else
	{
		ReadOnlyElement("ToValue",false)
	}
}
function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;