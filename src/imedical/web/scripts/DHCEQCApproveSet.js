//装载页面  函数名称固定
function BodyLoadHandler() {
	
	InitPage();
	ChangeStatus(false);
	InitUserInfo();
	//SetLink();
}
function SetLink()
{
	var SelRowObj;
	var objtbl=document.getElementById('tDHCEQCApproveSet');
	var rows=objtbl.rows.length;
	return;
	for (var i=1;i<rows;i++)
	{
		SelRowObj=document.getElementById('TApproveFlowz'+i);
		if (SelRowObj)
		{
		SelRowObj.onclick=lnk_Click;//调用
		SelRowObj.href="#";
		}
	}	
}
function lnk_Click()
{
	var eSrc=window.event.srcElement;	//获取事件源头
	var row=GetRowByColName(eSrc.id);//调用
	var lnk=GetHref(row);//调用
    window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=590,height=460,left=420,top=0');
}
function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}
function GetHref(row)
{
	var RowIDobj=document.getElementById('TRowIDz'+row);
	var RowID=RowIDobj.value;
	var lnk="";
    lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCApproveFlow&ApproveSetDR='+RowID;	
	return lnk;
}

function InitPage(){
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BUpdate_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	
	KeyUp("EquipType^PurchaseType^SpecialType^ApproveType","N");
	Muilt_LookUp("EquipType^PurchaseType^SpecialType^ApproveType");
}
//点击表格项填充自由项,函数名称固定
var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQCApproveSet'); //得到表格   t+组件名称
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	if (selectrow==SelectedRow){
		SetElement("RowID","");
		Fill("^^^^^^^^^^^^^")
		SelectedRow=0;
		ChangeStatus(false);
		return;}
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
	var sort=10;
	SetElement("ApproveTypeDR",list[0]);
	SetElement("Desc",list[1]);
	SetElement("Code",list[2]);
	SetElement("EquipTypeDR",list[3]);
	SetElement("PurchaseTypeDR",list[4]);
	SetElement("SpecialTypeDR",list[5]);
	SetElement("SingleMinFee",list[6]);
	SetElement("SingleMaxFee",list[7]);
	SetChkElement("AutoAuditFlag",list[8]);
	SetElement("YearFlag",list[9]);
	SetElement("EquipType",list[sort+0]);
	SetElement("PurchaseType",list[sort+1]);
	SetElement("SpecialType",list[sort+2]);
	SetElement("ApproveType",list[sort+3]);
	
}
//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
  	var MinFee=GetElementValue("SingleMinFee") ;
  	var MaxFee=GetElementValue("SingleMaxFee") ;
  	if ((MinFee<0)||(MaxFee<0))
  	{
	  	alertShow("请正确输入最小金额或最大金额!")
	  	return
  	}
  	if ((MinFee!="")&&(MaxFee!="")&&(MinFee>MaxFee))
  	{
	  	alertShow("最小金额大于最大金额!")
	  	return
  	}
	var val=GetValue();
	var Return=UpdateData(val,"0");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		alertShow("操作成功!")
		window.location.reload();
	}
}
function GetValue()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("ApproveTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("Desc") ;
  	combindata=combindata+"^"+GetElementValue("Code") ;
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("PurchaseTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("SpecialTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("SingleMinFee") ;
  	combindata=combindata+"^"+GetElementValue("SingleMaxFee") ;
  	combindata=combindata+"^"+GetChkElementValue("AutoAuditFlag") ;
  	combindata=combindata+"^"+GetElementValue("YearFlag") ;
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
		alertShow("删除成功!")
		window.location.reload();
	}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(2,"Desc")) return true;
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

function GetEquipType(value) {
	var user=value.split("^");
	var obj=document.getElementById("EquipTypeDR");
	obj.value=user[1];
}
function GetPurchaseType(value) {
	var user=value.split("^");
	var obj=document.getElementById("PurchaseTypeDR");
	obj.value=user[1];
}
function GetSpecialType(value) {
	var user=value.split("^");
	var obj=document.getElementById("SpecialTypeDR");
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