//装载页面  函数名称固定
function BodyLoadHandler() {
	
	InitPage();
	ChangeStatus(false);
	InitUserInfo();
	initButtonWidth()  //hisui改造:按钮长度一致 add by lmm 2018-08-20
    setRequiredElements("ApproveRole^ApproveType");   //add by wy 2019-5-25 912791
}
function InitPage(){
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BUpdate_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	
	KeyUp("ApproveRole^ApproveType");
	Muilt_LookUp("ApproveRole^ApproveType");	
}
//点击表格项填充自由项,函数名称固定
var SelectedRow = -1;  //modify by lmm 2018-10-11 hisui改造：开始行号修改
///modify by lmm 2018-08-17
///描述：hisui改造 更改值获取方式 并添加入参
///入参：selectrow 行号
///      rowdata 行json数据
function SelectRowHandler(selectrow,rowdata)	{
	
	if (selectrow==SelectedRow){
		SetElement("RowID","");
		Fill("^^^^^^^^^^^^^")
		SelectedRow=-1; //Modified By QW201812226 bug:790704
		ChangeStatus(false);
		return;}
	ChangeStatus(true);
	FillData(selectrow,rowdata)
    SelectedRow = selectrow;
}
function FillData(selectrow,rowdata)
{
	var RowID=rowdata.TRowID;
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
	SetElement("RowID",list[0]);
	SetElement("ApproveRoleDR",list[1]);
	SetElement("ApproveRole",list[2]);
	SetElement("ApproveTypeDR",list[3]);
	SetElement("ApproveType",list[4]);
	SetElement("MonthLimitFee",list[5]);
	SetElement("YearLimitFee",list[6]);
}
//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	var encmeth=GetElementValue("IsHad");
	var RowID=GetElementValue("RowID");
	var ApproveRoleID=GetElementValue("ApproveRoleDR");
	var ApproveTypeID=GetElementValue("ApproveTypeDR");
	var Flag=cspRunServerMethod(encmeth,ApproveRoleID,ApproveTypeID,RowID);
	if (Flag=="Y")
	{
		messageShow("","","",t["03"]);
		return;
	}
	var val=GetValue();
	var Return=UpdateData(val,"0");
	if (Return!=0)
	{
		messageShow("","","",Return+"  "+t["01"]);
	}
	else
	{
		window.location.reload();
	}
}
function GetValue()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("ApproveRoleDR") ;
  	combindata=combindata+"^"+GetElementValue("ApproveTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("MonthLimitFee") ;
  	combindata=combindata+"^"+GetElementValue("YearLimitFee") ;
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
		messageShow("","","",Return+"  "+t["01"]);
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
	if (CheckItemNull(1,"ApproveRole")) return true;
	if (CheckItemNull(1,"ApproveType")) return true;
	*/
	return false;
}
function UpdateData(val,AppType)
{
	var encmeth=GetElementValue("upd");
	var Return=cspRunServerMethod(encmeth,val,AppType);
	return Return;
}

function GetApproveRole(value) {
	var user=value.split("^");
	var obj=document.getElementById("ApproveRoleDR");
	obj.value=user[1];
}
function GetApproveType(value) {
	var user=value.split("^");
	var obj=document.getElementById("ApproveTypeDR");
	obj.value=user[1];
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