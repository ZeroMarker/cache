var InvoiceEditFlag=1;
function BodyLoadHandler()
{
	KeyUp("Certificate^PayPlan^Invoice","N");	
	InitUserInfo();	
	ChangeStatus(false);
	InitPage();
	Muilt_LookUp("Certificate^PayPlan^Invoice");
}

function InitPage(){
	var obj=document.getElementById("Invoice");
	if (obj) obj.onchange=Invoice_KeyUp;
	
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=CloseWindow;
}

function ChangeStatus(Value)
{	
	if (GetElementValue("Status")>0)
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
	}
	else
	{
		DisableBElement("BUpdate",false);		
		DisableBElement("BDelete",!Value);
		DisableBElement("BMore",!Value);
		if (Value)
		{
			var obj=document.getElementById("BMore");	
			if (obj) obj.onclick=BMore_click;
		}
	}
}
//点击表格项填充自由项,函数名称固定
var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	if (selectrow==SelectedRow)
	{
		ClearData();
		SelectedRow=0;
		ChangeStatus(false);
		ReadOnlyInvoice(false);
	}
	else
	{		
		FillData(selectrow)
    	SelectedRow = selectrow;
    	ChangeStatus(true);
	}
}
function FillData(selectrow)
{
	var TRowID=GetElementValue("TRowIDz"+selectrow);
	if (TRowID=="") return;	
	var encmeth=GetElementValue("fillData");	
	var ReturnList=cspRunServerMethod(encmeth,TRowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	
	SetElement("RowID",TRowID)
	Fill(ReturnList)
	
	var encmeth=GetElementValue("GetInvoiceInfos");	
	var ReturnList=cspRunServerMethod(encmeth,"9",TRowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	if (ReturnList!="")
	{
		var list=ReturnList.split("&");
		list=list[0].split("^");
		SetElement("IUMRowID",list[3]);
		SetElement("InvoiceDR",list[4]);
		SetElement("Invoice",list[0]);
		SetElement("InvoiceDate",list[1]);
		SetElement("InvoiceAmount",list[2]);
		var ReadOnlyFlag=CheckInvoiceTimes();
		ReadOnlyInvoice(ReadOnlyFlag);
	}
	else
	{
		SetElement("IUMRowID","");
		SetElement("InvoiceDR","");
		SetElement("Invoice","");
		SetElement("InvoiceDate","");
		SetElement("InvoiceAmount","");
	}
	
}

function Fill(ReturnList)
{
	var sort=23
	var list=ReturnList.split("^");
	SetElement("PayMode",list[1]);
	SetElement("PayFee",list[2]);
	SetElement("PayDate",list[sort+1]);
	SetElement("PayNo",list[4]);
	SetElement("CustomNo",list[5]);
	SetElement("CertificateDR",list[6]);
	SetElement("PayUserDR",list[7]);
	SetElement("Remark",list[8]);
	SetElement("Hold1",list[9]);
	SetElement("Hold2",list[10]);
	SetElement("Hold3",list[11]);
	SetElement("Hold4",list[12]);
	SetElement("Hold5",list[13]);
	SetElement("Certificate",list[sort+2]);
	SetElement("PayUser",list[sort+3]);
	
	//SetElement("SourceType",list[14]);
	//SetElement("SourceID",list[15]);
	SetElement("PayPlanDR",list[16]);
	SetElement("Status",list[17]);
	SetElement("PayPlan",list[sort+4]);
}

//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	if (CheckPayFee()) return;	
	
	var val=GetValue();
	
	if (CheckInvoiceNo()) return;	
	var invoiceinfo=GetElementValue("IUMRowID")+"^9^"+GetElementValue("RowID")+"^"+GetElementValue("InvoiceDR")+"^"+GetElementValue("Invoice")+"^"+GetElementValue("InvoiceDate")+"^"+GetElementValue("InvoiceAmount")+"^"+GetElementValue("ProviderDR")
	
	var result=UpdateData(val,"0",invoiceinfo);
	if (result==0)
	{
		window.location.reload();
	}
	else
	{
		alertShow(t["01"],result);
	}
}

function GetValue()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("InvoiceDR") ;
  	combindata=combindata+"^"+GetElementValue("PayMode") ;
  	combindata=combindata+"^"+GetElementValue("PayFee") ;
  	combindata=combindata+"^"+GetElementValue("PayDate") ;
  	combindata=combindata+"^"+GetElementValue("PayNo") ;
  	combindata=combindata+"^"+GetElementValue("CustomNo") ;
  	combindata=combindata+"^"+GetElementValue("CertificateDR") ;
  	combindata=combindata+"^"+GetElementValue("PayUserDR") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	combindata=combindata+"^"+GetElementValue("Hold4") ;
  	combindata=combindata+"^"+GetElementValue("Hold5") ;
  	
  	combindata=combindata+"^"+GetElementValue("SourceType") ;
  	combindata=combindata+"^"+GetElementValue("SourceID") ;
  	combindata=combindata+"^"+GetElementValue("PayPlanDR") ;  	
  	
  	return combindata;
}

//删除按钮点击函数
function BDelete_click()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID");
	var Return=UpdateData(RowID,"1",GetElementValue("IUMRowID"));
	if (Return<0)
	{
		alertShow(EQMsg(t['01'],Return));
	}
	else
	{
		window.location.reload();
	}
}

function CheckNull()
{
	if (CheckMustItemNull()) return true;
	if ((GetElementValue("SourceType")=="")||(GetElementValue("SourceID")==""))
	{
		alertShow(EQMsg("","03"));
		return true;
	}
	return false;
}

function UpdateData(val,AppType,invoiceinfo)
{
	var encmeth=GetElementValue("upd");
	///alertShow("Remark",val+"**"+AppType+"**"+invoiceinfo);	
	var Return=cspRunServerMethod(encmeth,val,AppType,invoiceinfo);
	return Return;
}

function GetCertificate(value)
{
	GetLookUpID("CertificateDR",value);
}

function GetPayPlan(value)
{
	var list=value.split("^");
	SetElement("PayPlan",list[3]);
	SetElement("PayPlanDR",list[2]);
	if (GetElementValue("PayFee")=="")
	{
		var Percent=list[9];
		var Percent=Percent.replace("%","");
		var PayFee=Percent*GetElementValue("Amount")/100;
		SetElement("PayFee",PayFee);
	}
}

///检查录入金额是否有异常
///返回?false无异常
///		 true 有异常
function CheckPayFee()
{
	var encmeth=GetElementValue("CheckPayFee");
	if (encmeth=="") return true;
	var RowID=GetElementValue("RowID")
	var SourceType=GetElementValue("SourceType");
	var SourceID=GetElementValue("SourceID");
	var PayFee=GetElementValue("PayFee");
	
	//Modified by jdl 2011-11-23 JDL0103
	if (PayFee==0)
	{
		alertShow(EQMsg("","05"))
		return true;
	}
	else if (PayFee<0)
	{
		var truthBeTold = window.confirm(t["08"]);
		if (!truthBeTold) return true;
	}
	var rtn=cspRunServerMethod(encmeth,SourceType,SourceID,RowID,PayFee);
	if (rtn==0)
	{
		alertShow(EQMsg("","04"))
		SetFocus("PayFee")
		return true;
	}
	return false;
}

function ClearData()
{
	SetElement("RowID","");
	SetElement("PayMode","");
	SetElement("PayFee","");
	SetElement("PayDate","");
	SetElement("PayNo","");
	SetElement("CustomNo","");
	SetElement("CertificateDR","");
	SetElement("PayUserDR","");
	SetElement("Remark","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	SetElement("Certificate","");
	SetElement("PayUser","");
	
	//SetElement("SourceType",list[14]);
	//SetElement("SourceID",list[15]);
	SetElement("PayPlanDR","");
	SetElement("Status","");
	SetElement("PayPlan","");
	
	
	SetElement("IUMRowID","");
	SetElement("Invoice","");
	SetElement("InvoiceDR","");
	SetElement("InvoiceDate","");
	SetElement("InvoiceAmount","");	
}

function CheckInvoiceNo()
{
	var InvoiceAmount=GetElementValue("InvoiceAmount");
	if ((InvoiceAmount!="")&&(InvoiceAmount<=0))
	{
		alertShow(EQMsg("","06"))
		return true;
	}
	
	var CanEdit=1;
	var ReadOnlyFlag=CheckInvoiceTimes();
	if (ReadOnlyFlag) CanEdit=0;
	
	var InvoiceNo=GetElementValue("Invoice")
	var InvoiceNoDR=GetElementValue("InvoiceDR")
	var ProviderDR=GetElementValue("ProviderDR")
	var encmeth=GetElementValue("CheckInvoiceNo");
	if (encmeth=="") return false;
	var rtn=cspRunServerMethod(encmeth,InvoiceNoDR,InvoiceNo,ProviderDR,CanEdit);
	if (rtn==0)
	{
		return false;
	}
	else
	{
		alertShow(EQMsg("",rtn));
		return true;
	}
}

///控制发票信息的只读性
///当发票信息只在本明细的本付款记录中用到时?方可编辑发票日期及发票金额
///否则只可选择发票号
function ReadOnlyInvoice(value)
{
	DisableElement("ld"+GetElementValue("GetComponentID")+"iInvoiceDate",value);
	ReadOnlyElement("InvoiceDate",value)
	ReadOnlyElement("InvoiceAmount",value)
}

function GetInvoiceNo(value)
{
	var list=value.split("^");
	SetElement("Invoice",list[0]);
	SetElement("InvoiceDR",list[1]);
	SetElement("InvoiceDate",list[3]);
	SetElement("InvoiceAmount",list[4]);
	var ReadOnlyFlag=CheckInvoiceTimes();
	ReadOnlyInvoice(ReadOnlyFlag);
}

function CheckInvoiceTimes()
{
	var RowID=GetElementValue("RowID")
	var InvoiceNoDR=GetElementValue("InvoiceDR");
	var encmeth=GetElementValue("CheckInvoiceTimes");
	if (encmeth=="")
	{
		return true;
	}
	else
	{
		var rtn=cspRunServerMethod(encmeth,"9",RowID,InvoiceNoDR);
		var list=rtn.split("^");
		if (list[0]==0)		//未用
		{
			return false;
			//ReadOnlyInvoice(false);
		}
		else if ((list[0]==1)&&(list[1]==1))		//仅被付款记录对应的入库明细占用
		{
			return false;
		}
	}
	return true;
}

function Invoice_KeyUp()
{
	SetElement("InvoiceDR","");
	ReadOnlyInvoice(false);
}

function BMore_click()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="")
	{
		alertShow(EQMsg("","07"));
		return;
	}	
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInvoiceUseMap&SourceType=9'+"&SourceID="+RowID+"&Provider="+GetElementValue("Provider")+"&ProviderDR="+GetElementValue("ProviderDR");
	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=500,left=131,top=0')
}

document.body.onload = BodyLoadHandler;