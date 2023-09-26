function BodyLoadHandler()
{
	InitUserInfo();
	FillData();
	InitPage();	
	KeyUp("InvoiceType^Provider^Certificate");
	Muilt_LookUp("InvoiceType^Provider^Certificate");
	DisableLookup("Provider",true)
}

function InitPage(){
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BUpdate_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	var BCobj=document.getElementById("BClose");
	if (BCobj) BCobj.onclick=CloseWindow;
}

function FillData()
{
	var RowID=GetElementValue("RowID");
	if ((RowID=="")||(RowID<1)){
		return;
	}
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	var sort=20
	SetElement("Code",list[0]);
	SetElement("No",list[1]);
	SetElement("AmountFee",list[3]);
	SetElement("ProviderDR",list[4]);
	SetElement("InvoiceTypeDR",list[5]);
	SetElement("Customer",list[6]);
	SetElement("InvoiceDept",list[7]);
	SetElement("PayedAmountFee",list[8]);
	SetElement("Status",list[9]);
	SetElement("SubmitUserDR",list[10]);
	SetElement("Remark",list[13]);
	SetElement("CertificateDR",list[14]);
	SetChkElement("InvalidFlag",list[15]);
	SetElement("Hold1",list[16]);
	SetElement("Hold2",list[17]);
	SetElement("Hold3",list[18]);
	SetElement("Hold4",list[19]);
	SetElement("Hold5",list[20]);
	SetElement("Date",list[sort+1]);
	SetElement("Provider",list[sort+2]);
	SetElement("InvoiceType",list[sort+3]);
	SetElement("SubmitDate",list[sort+4]);
	SetElement("Certificate",list[sort+5]);
}
//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	var val=PackageData("RowID^Code^No^Date^AmountFee^ProviderDR^InvoiceTypeDR^Customer^InvoiceDept^PayedAmountFee^Status^Remark^CertificateDR^InvalidFlag^Hold1^Hold2^Hold3^Hold4^Hold5"); 
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
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInvoice&RowID='+Return;
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
	if (encmeth=="") return;
	var Return=cspRunServerMethod(encmeth,val,AppType);
	return Return;
}

function GetProvider(value)
{
	GetLookUpID("ProviderDR",value);
}
function GetInvoiceType(value)
{
	GetLookUpID("InvoiceTypeDR",value);
}
function GetCertificate(value)
{
	GetLookUpID("CertificateDR",value);
}
document.body.onload = BodyLoadHandler;