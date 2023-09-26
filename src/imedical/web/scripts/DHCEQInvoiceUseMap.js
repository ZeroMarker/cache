var InvoiceEditFlag=1;

function BodyLoadHandler()
{
	KeyUp("Certificate^InvoiceNo","N");	
	InitUserInfo();	
	ChangeStatus(false);
	InitPage();	
	Muilt_LookUp("Certificate^InvoiceNo");
}

function InitPage(){
	var obj=document.getElementById("InvoiceNo");
	if (obj) obj.onchange=Invoice_KeyUp;
	
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	var BCobj=document.getElementById("BClose");
	if (BCobj) BCobj.onclick=CloseWindow;
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
	}
}
//�����������������,�������ƹ̶�
var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //��ǰѡ����
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
	var IUMRowID=GetElementValue("TRowIDz"+selectrow);
	if (IUMRowID=="") return;	
	SetElement("IUMRowID",IUMRowID)
	var InvoiceNoDR=GetElementValue("TInvoiceNoDRz"+selectrow);
	if (InvoiceNoDR=="") return;
	SetElement("InvoiceNoDR",InvoiceNoDR)

	var encmeth=GetElementValue("fillData");	
	var ReturnList=cspRunServerMethod(encmeth,InvoiceNoDR);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	///SetElement("InvoiceCode",list[0]);
	SetElement("InvoiceNo",list[1]);
	SetElement("InvoiceDate",list[21]);
	SetElement("InvoiceAmount",list[3]);
	SetElement("Remark",list[13]);		//��ע	Mozy	567315	201-3-19
  	var ReadOnlyFlag=CheckInvoiceTimes();
	ReadOnlyInvoice(ReadOnlyFlag);
}


//���°�ť�������
function BUpdate_click()
{
	if (CheckNull()) return;
	if (CheckInvoiceNo()) return;
	
	var val=GetValue();	
	var encmeth=GetElementValue("upd");
	///alertShow("Remark",val+"**"+AppType+"**"+invoiceinfo);	
	var rtn=cspRunServerMethod(encmeth,val);
	if (rtn==0)
	{
		//add by HHM 20150910 HHM0013
		//��Ӳ����ɹ��Ƿ���ʾ
		ShowMessage();
		//****************************
		window.location.reload();
	}
	else
	{
		alertShow(EQMsg(t["01"],rtn));
	}
}

function GetValue()
{
	var combindata="";
  	combindata=GetElementValue("IUMRowID");
  	combindata=combindata+"^"+GetElementValue("SourceType") ;
  	combindata=combindata+"^"+GetElementValue("SourceID") ;
  	combindata=combindata+"^"+GetElementValue("InvoiceNoDR") ;
  	combindata=combindata+"^"+GetElementValue("InvoiceNo") ;
  	combindata=combindata+"^"+GetElementValue("InvoiceDate") ;
  	combindata=combindata+"^"+GetElementValue("InvoiceAmount") ;
  	combindata=combindata+"^"+GetElementValue("ProviderDR") ;	
  	combindata=combindata+"^"+GetElementValue("Remark");	//��ע	Mozy	567315	201-3-19
  	return combindata;
}

//ɾ����ť�������
function BDelete_click()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	
	var IUMRowID=GetElementValue("IUMRowID");	
	var encmeth=GetElementValue("GetDeleteDate");
	var rtn=cspRunServerMethod(encmeth,IUMRowID);
		
	if (rtn<0)
	{
		alertShow(EQMsg(t['01'],rtn));
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

function GetCertificate(value)
{
	GetLookUpID("CertificateDR",value);
}

function ClearData()
{
	SetElement("CertificateDR","");
	SetElement("Remark","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	SetElement("Certificate","");
	
	//SetElement("SourceType",list[14]);
	//SetElement("SourceID",list[15]);	
	
	SetElement("IUMRowID","");
	SetElement("InvoiceNo","");
	SetElement("InvoiceNoDR","");
	SetElement("InvoiceDate","");
	SetElement("InvoiceAmount","");	
	SetElement("Remark","");		//��ע	Mozy	567315	201-3-19
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
	
	var InvoiceNo=GetElementValue("InvoiceNo")
	var InvoiceNoDR=GetElementValue("InvoiceNoDR")
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

///���Ʒ�Ʊ��Ϣ��ֻ����
///����Ʊ��Ϣֻ�ڱ���ϸ�ı������¼���õ�ʱ?���ɱ༭��Ʊ���ڼ���Ʊ���
///����ֻ��ѡ��Ʊ��
function ReadOnlyInvoice(value)
{
	DisableElement("ld"+GetElementValue("GetComponentID")+"iInvoiceDate",value);
	ReadOnlyElement("InvoiceDate",value)
	ReadOnlyElement("InvoiceAmount",value)
}

function GetInvoiceNo(value)
{
	var list=value.split("^");
	SetElement("InvoiceNo",list[0]);
	SetElement("InvoiceNoDR",list[1]);
	SetElement("InvoiceDate",list[3]);
	SetElement("InvoiceAmount",list[4]);
	var ReadOnlyFlag=CheckInvoiceTimes();
	ReadOnlyInvoice(ReadOnlyFlag);
}

function CheckInvoiceTimes()
{
	var SourceType=GetElementValue("SourceType")
	var SourceID=GetElementValue("SourceID")
	var InvoiceNoDR=GetElementValue("InvoiceNoDR");
	var encmeth=GetElementValue("CheckInvoiceTimes");
	if (encmeth=="")
	{
		return true;
	}
	else
	{
		var rtn=cspRunServerMethod(encmeth,SourceType,SourceID,InvoiceNoDR);
		var list=rtn.split("^");
		//alertShow(SourceType+"&"+SourceID);
		if (list[0]==0)		//δ��
		{
			return false;
			//ReadOnlyInvoice(false);
		}
		else if ((list[0]==1)&&(list[1]==1))		//���������¼��Ӧ�������ϸռ��
		{
			return false;
		}
	}
	return true;
}

function Invoice_KeyUp()
{
	SetElement("InvoiceNoDR","");
	ReadOnlyInvoice(false);
}

document.body.onload = BodyLoadHandler;