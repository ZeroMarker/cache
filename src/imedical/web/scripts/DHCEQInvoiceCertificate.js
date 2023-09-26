/// 创    建:ZY  2010-04-26  No.ZY0019
/// 修改描述:设备转移
/// --------------------------------
function BodyLoadHandler()
{
	InitUserInfo();	
	InitPage();	
	ChangeStatus(false);
	KeyUp("Certificate^Provider");
	Muilt_LookUp("InvoiceNo^Certificate^Provider");
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
	if (BCobj) BCobj.onclick=ClosePage;   //modified by zy 2011-02-19  ZY0062
	//if (BCobj) BCobj.onclick=CloseWindow;
	var BCobj=document.getElementById("InvoiceNo");
	if (BCobj) BCobj.onkeyup=ChangeStlye;
}
//modified by zy 2011-02-19  ZY0062
function ClosePage()
{
	opener.location.reload();
}

function ChangeStlye()
{
	SetElement("UsedFlag","1")
	DisableEdit()
}

function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BAdd",Value);
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
}

//点击表格项填充自由项,函数名称固定
var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQInvoiceCertificate'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	if (selectrow==SelectedRow)
	{
		SetElement("RowID","");
		SetElement("InvoiceUseMapDR","")
		SetElement("UsedFlag","")
		Clear()
		SelectedRow=0;
		ChangeStatus(false);
		DisableEdit()
		return;
	}
	ChangeStatus(true);
	FillData(selectrow)
	CheckInvoiceNo()
	DisableEdit()
    SelectedRow = selectrow;
}
function FillData(selectrow)
{
	var TInvoiceUseMapDR=GetElementValue("TInvoiceUseMapDRz"+selectrow);
	var InvoiceNoDR=GetElementValue("TInvoiceNoDRz"+selectrow);
	if (InvoiceNoDR=="") return;
	SetElement("InvoiceNoDR",InvoiceNoDR)
	SetElement("InvoiceUseMapDR",TInvoiceUseMapDR)
	Fill(InvoiceNoDR)
}
function Fill(rowid)
{
	if (rowid=="") return;
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,rowid);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	SetElement("InvoiceCode",list[0]);
	SetElement("InvoiceNo",list[1]);
	SetElement("Date",list[21]);
	SetElement("AmountFee",list[3]);
  	//SetElement("ProviderDR",list[4]);
  	//SetElement("Provider",list[22]);
	SetElement("InvoiceTypeDR",list[5]);
  	SetElement("Customer",list[6]);
  	SetElement("InvoiceDept",list[7]);
  	SetElement("PayedAmountFee",list[8]);
  	SetElement("Status",list[9]);
	SetElement("InvoiceType",list[23]);
  	SetElement("Remark",list[13]);
	SetElement("CertificateDR",list[14]);
	SetElement("Certificate",list[25]);
  	SetChkElement("InvalidFlag",list[15]);
  	SetElement("Hold1",list[16]);
  	SetElement("Hold2",list[17]);
  	SetElement("Hold3",list[18]);
  	SetElement("Hold4",list[19]);
  	SetElement("Hold5",list[20]);
  	SetChkElement("Flag",list[26]);  //是否是全额付款
}

//检查发票是不是被多个申请单使用
function CheckInvoiceNo()
{
	var InvoiceNo=GetElementValue("InvoiceNo")
	var InvoiceNoDR=GetElementValue("InvoiceNoDR")
	var ProviderDR=GetElementValue("ProviderDR")
	var encmeth=GetElementValue("CheckInvoiceNo");
	if (encmeth=="") return;
	//alertShow(InvoiceNoDR+"^"+InvoiceNo+"^"+ProviderDR)
	var rnt=cspRunServerMethod(encmeth,InvoiceNoDR,InvoiceNo,ProviderDR,0);		/// 20150327  Mozy0153
	//alertShow(rnt)
	//rnt=-1,多处使用,不可更新
	//rnt=1,单独使用,可更新
	//rnt="",重新选择发票
	//rnt=0,重新加一条发票
	SetElement("UsedFlag",rnt)
}

function DisableEdit()
{	
	var value=false
	if (GetElementValue("UsedFlag")=="-1")
	{
		value=true
	}
	var tableName=GetParentTable("InvoiceNo")
	var All = tableName.getElementsByTagName( "INPUT" );
	var Length = All.length;
	for(var I = 0; I < Length; I++)
	{
		if (All[I].id=="InvoiceNo") continue
		DisableElement("ld"+GetElementValue("GetComponentID")+"i"+All[I].id,value);
		ReadOnlyElement(All[I].id,value)
	}
	DisableBElement("Flag",value)
	ReadOnlyElement("Remark",value)
}
function Clear()
{
	SetElement("InvoiceNo","");
	SetElement("InvoiceNoDR","");
	SetElement("InvoiceCode","");
	SetElement("Date","");
	SetElement("AmountFee","");
	SetElement("InvoiceTypeDR","");
	SetElement("InvoiceType","");
	SetElement("CertificateDR","");
	SetElement("Certificate","");
	//SetElement("ProviderDR","");
	//SetElement("Provider","");
	SetElement("Customer","");
	SetElement("InvoiceDept","");
	SetElement("PayedAmountFee","");
	SetElement("Status","");
	SetElement("Remark","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	SetChkElement("Flag","")
}
//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	SetElement("CertificateDR",GetCertificateRowID("Certificate"))
	var val=""
	CheckInvoiceNo();
	var UsedFlag=GetElementValue("UsedFlag")
	if (UsedFlag=="")  		//重新选择发票
	{
		alertShow(t[-1000])
		return
	}
	else if (UsedFlag==-1)		//只更新发票使用对照表
	{
		val=PackageData("InvoiceUseMapDR^SourceID^SourceType^InvoiceNoDR")
	}
	else if (UsedFlag==0)		//新增一条发票
	{
		SetElement("InvoiceNoDR","")
	}
	if (val=="") val=PackageData("InvoiceUseMapDR^SourceID^SourceType^InvoiceNoDR^InvoiceCode^InvoiceNo^Date^AmountFee^ProviderDR^InvoiceTypeDR^Customer^InvoiceDept^PayedAmountFee^Status^Remark^CertificateDR^Hold1^Hold2^Hold3^Hold4^Hold5^Flag"); 
	var Rtn=UpdateData(val,"0");
	if (Rtn==0)
	{
		window.location.reload();
	}
	else
	{
		alertShow(Rtn+"  "+t["01"]);
	}
	
}
//删除按钮点击函数
function BDelete_click()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var val=PackageData("InvoiceUseMapDR");
	var Rtn=UpdateData(val,"1");
	if (Rtn<0)
	{
		alertShow(Rtn+"  "+t["01"]);
	}
	else
	{
		window.location.reload();
	}
	opener.location.reload();
}

function UpdateData(val,AppType)
{
	var encmeth=GetElementValue("upd");
	var Return=cspRunServerMethod(encmeth,val,AppType);
	return Return;
}


function CheckNull()
{
	if (CheckMustItemNull("InvoiceNo")) return true;
	return false;
}
function GetInvoiceNo(value)
{
	var list=value.split("^");
	SetElement("InvoiceNo",list[0]);
	SetElement("InvoiceNoDR",list[1]);
	SetElement("InvoiceCode",list[2]);
	SetElement("Date",list[3]);
	SetElement("AmountFee",list[4]);
	SetElement("InvoiceTypeDR",list[5]);
	SetElement("InvoiceType",list[6]);
	SetElement("CertificateDR",list[7]);
	SetElement("Certificate",list[8]);
	//SetElement("ProviderDR",list[9]);
	//SetElement("Provider",list[10]);
	SetElement("Customer",list[11]);
	SetElement("InvoiceDept",list[12]);
	SetElement("PayedAmountFee",list[13]);
	SetElement("Status",list[14]);
	SetElement("Remark",list[15]);
	SetElement("Hold1",list[16]);
	SetElement("Hold2",list[17]);
	SetElement("Hold3",list[18]);
	SetElement("Hold4",list[19]);
	SetElement("Hold5",list[20]);
	
	CheckInvoiceNo()
	if (GetElementValue("UsedFlag")=="1")
	{
		SetElement("UsedFlag","-1")
	}
	DisableEdit()
}
function GetInvoiceType(value)
{
	GetLookUpID("InvoiceTypeDR",value);
}
function GetCertificate(value)
{
	GetLookUpID("CertificateDR",value);
}

function GetProvider (value)
{
    GetLookUpID("ProviderDR",value);
}
document.body.onload = BodyLoadHandler;