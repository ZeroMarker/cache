//装载页面  函数名称固定
function BodyLoadHandler() {
	
	InitPage();
	ChangeStatus(false);
	InitUserInfo();
}
function InitPage(){
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BAdd_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;	

	KeyUp("CheckItem^CheckResult");
	Muilt_LookUp("CheckItem^CheckResult");
}
function BClose_Click() 
{
	window.close();
}
//点击表格项填充自由项,函数名称固定
var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQCheckItem'); //得到表格   t+组件名称
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	
	var obj=document.getElementById('RowID');
	var obj1=document.getElementById('CheckDR');
	var obj2=document.getElementById('CheckItemDR');
	var obj3=document.getElementById('CheckResultDR');
	var obj4=document.getElementById('CheckItem');
	var obj5=document.getElementById('CheckResult');
	var obj6=document.getElementById('Remark');
	if (selectrow==SelectedRow){
		obj.value='';
		obj2.value='';
		obj3.value='';
		obj4.value='';
		obj5.value='';
		obj6.value='';
		SelectedRow=0;
		ChangeStatus(false)
		return;}
	ChangeStatus(true)
	FillData(selectrow)
    SelectedRow = selectrow;
}
function FillData(selectrow)
{
	var RowID=document.getElementById("TRowIDz"+selectrow).value;
	SetElement("RowID",RowID);
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,"","",RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=4;
	SetElement("CheckDR",list[0]);
	SetElement("Check",list[sort+0]);
	SetElement("CheckItemDR",list[1]);
	SetElement("CheckItem",list[sort+1]);
	SetElement("CheckResultDR",list[2]);
	SetElement("CheckResult",list[sort+2]);
	SetElement("Remark",list[3]);
}
//新增按钮点击函数
function BAdd_click()
{	
	if (CheckNull()) return;
	var Return=UpdateCheckList("0");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		window.location.reload();
	}
	
}
//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	var Return=UpdateCheckList("1");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		window.location.reload();
	}
}
//删除按钮点击函数
function BDelete_click()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	
	var Return=UpdateCheckList("2");
	if (Return!=0)
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
	/*
	if (CheckItemNull(1,"CheckItem")) return true;
	if (CheckItemNull(1,"CheckResult")) return true;
	*/
	return false;
}
function UpdateCheckList(AppType)
{
	var encmeth=GetElementValue("upd");
	var value=GetElementValue("RowID");
	value=value+"^"+GetElementValue("CheckDR");
	value=value+"^"+GetElementValue("CheckItemDR");
	value=value+"^"+GetElementValue("CheckResultDR");
	value=value+"^"+GetElementValue("Remark");
	var Return=cspRunServerMethod(encmeth,"","",value,AppType);
	return Return;
} 
function GetCheckItem(value) {
	var user=value.split("^");
	var obj=document.getElementById("CheckItemDR");
	obj.value=user[1];
}
function GetCheckResult(value) {
	var user=value.split("^");
	var obj=document.getElementById("CheckResultDR");
	obj.value=user[1];
}
function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
	SetBStatus();
}
function SetBStatus()
{
	var obj=document.getElementById("Status");
	var Status=obj.value;
	if (Status!="0")
		{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAdd",true);
		}
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;