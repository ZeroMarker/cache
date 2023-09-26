

var InvoiceDR="";
var SelectedRow = 0;
var ISLTotal=1;
function BodyLoadHandler()
{		
	InitPage();
}
function InitPage()
{
	KeyUp("Provider^Status");
	Muilt_LookUp("Provider^Status");
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Click;
	DisableBElement("BSubmit",true);
	DisableBElement("BCancelSubmit",true);
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	
	var objtbl=document.getElementById('tDHCEQInvoiceFind'); //得到表格   t+组件名称
	
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	if (selectrow==SelectedRow){
		InvoiceDR=""
		SelectedRow=0;
		ISLTotal=1;
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		return;}
	SelectedRow = selectrow;
	InvoiceDR=GetElementValue("TRowIDz"+selectrow);
	ISLTotal=GetElementValue("TISLTotalz"+selectrow);
	var Status=GetElementValue("TStatusDRz"+SelectedRow);
	if (Status=="1")
	{
		var obj=document.getElementById("BSubmit");
		if (obj) obj.onclick=BSubmit_Click;
		DisableBElement("BSubmit",false);
		DisableBElement("BCancelSubmit",true);
	}
	else
	{
		if (Status=="2")
		{
			var obj=document.getElementById("BCancelSubmit");
			if (obj) obj.onclick=BCancelSubmit_Click;
			DisableBElement("BCancelSubmit",false);
		}
		else
		{
			DisableBElement("BCancelSubmit",true);
		}
		DisableBElement("BSubmit",true);
	}
}
function BSubmit_Click()
{
	if (InvoiceDR=="")
	{
		alertShow(t["02"]);
		return;
	}
	var encmeth=GetElementValue("CheckInStockStatu");
	var Return=cspRunServerMethod(encmeth,InvoiceDR);
	if (Return<0)
	{
		alertShow(t[Return]);
		return;
	}
	if (ISLTotal>1)
	{
		try 
		{
			var result=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=DHCEQGetInStockByInvoice&Type=1&InvoiceDR='+InvoiceDR,'','')
  	 		if (result!="1") return;
		}
		catch(e)
		{
			alertShow(e.message);
		}	
	}
	var encmeth=GetElementValue("upd");
	var Return=cspRunServerMethod(encmeth,InvoiceDR,"2");
	if (Return==0)
	{
		window.location.reload();
	}
	else
	{
		alertShow(t["01"]);
	}
}
function BCancelSubmit_Click()
{
	if (InvoiceDR=="")
	{
		alertShow(t["02"]);
		return;
	}
	if (ISLTotal>1)
	{
		try 
		{
			var result=showModalDialog('websys.default.csp?WEBSYS.TCOMPONENT=DHCEQGetInStockByInvoice&Type=1&InvoiceDR='+InvoiceDR,'','')
  	 		if (result!="1") return	;
		}
		catch(e)
		{
			alertShow(e.message);
		}	
	}
	var encmeth=GetElementValue("upd");
	var Return=cspRunServerMethod(encmeth,InvoiceDR,"1");
	if (Return==0)
	{
		window.location.reload();
	}
	else
	{
		alertShow(t["01"]);
	}
}
function GetProvider (value)
{
    GetLookUpID("ProviderDR",value);
}
function GetStatus (value)
{
    GetLookUpID("StatusDR",value);
}
document.body.onload = BodyLoadHandler;