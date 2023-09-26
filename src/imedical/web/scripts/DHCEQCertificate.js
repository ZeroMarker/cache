/// 创    建:ZY  2010-04-26  No.ZY0019
/// 修改描述:凭证管理
/// --------------------------------
function BodyLoadHandler()
{
	InitUserInfo();
	FillData();
	InitPage();	
}

function InitPage(){
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BUpdate_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	var BDobj=document.getElementById("BClose");
	if (BDobj) BDobj.onclick=CloseWindow;
}

function FillData()
{
	var obj=document.getElementById("RowID");
	var RowID=obj.value;
	if ((RowID=="")||(RowID<1)){
		return;
	}
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	SetElement("Type",list[0]);
	SetElement("No",list[1]);
	SetElement("Date",list[11]);
	SetElement("CertificateUserDR",list[3]);
	SetElement("Fee",list[4]);
	SetElement("Remark",list[5]);
	SetElement("Hold1",list[6]);
	SetElement("Hold2",list[7]);
	SetElement("Hold3",list[8]);
	SetElement("Hold4",list[9]);
	SetElement("Hold5",list[10]);
}
//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	var val=GetValue();
	var Return=UpdateData(val,"0");
	if (Return==0)
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
  	combindata=combindata+"^"+GetElementValue("Type") ;
  	combindata=combindata+"^"+GetElementValue("No") ;
  	combindata=combindata+"^"+GetElementValue("Date") ;;
  	combindata=combindata+"^"+curUserID;
  	combindata=combindata+"^"+GetElementValue("Fee") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	combindata=combindata+"^"+GetElementValue("Hold4") ;
  	combindata=combindata+"^"+GetElementValue("Hold5") ;
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

document.body.onload = BodyLoadHandler;
