function BodyLoadHandler() 
{	
	InitUserInfo();
	SetEvent();
	SetBEnabled();	
}
function SetEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	
	var obj=document.getElementById("Bupdate");
	if (obj) obj.onclick=BUpdate_Click;
	
	var obj=document.getElementById("Bdelete");
	if (obj) obj.onclick=BDelete_Click;
	
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
}
function BClose_Click() 
{
	window.close();
}

function BAdd_Click() 
{
	if (CheckNull()) return;
	var Return=UpdateData("0");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		window.location.reload();
	}
}

function BUpdate_Click() 
{
	if (CheckNull()) return;
	var Return=UpdateData("1");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"]);
	}
	else
	{
		window.location.reload();
	}
}

function BDelete_Click() 
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	
	var Return=UpdateData("2");
	if (Return!=0)
	{
		alertShow(Return+"  "+t["01"])
	}
	else
	{
		window.location.reload();
	}
}
function UpdateData(AppType)
{
	var encmeth=GetElementValue("upd");
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("PayNo") ;
  	combindata=combindata+"^"+GetElementValue("PayFee") ;
  	combindata=combindata+"^"+GetElementValue("PayDate") ;
  	combindata=combindata+"^"+GetElementValue("ContractDR") ;
  	combindata=combindata+"^"+GetElementValue("InvoiceNo") ;
  	combindata=combindata+"^"+GetElementValue("InvoiceFee") ;
  	combindata=combindata+"^"+GetElementValue("InvoiceDate") ;
  	combindata=combindata+"^"+GetChkElementValue("InvalidFlag") ;
  	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ;
  	combindata=combindata+"^"+GetElementValue("UpdateDate") ;
  	combindata=combindata+"^"+GetElementValue("UpdateTime") ;
  	combindata=combindata+"^"+GetElementValue("PayedFee") ;
	user=curUserID;
	var Return=cspRunServerMethod(encmeth,"","",combindata,AppType,user);
	return Return;
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(2,"PayNo")) return true;
	if (CheckItemNull(2,"PayFee")) return true;
	if (CheckItemNull(2,"PayDate")) return true;
	*/
	return false;
}
var SelectedRow = 0;
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCEQContractPay'); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	SetEvent();
	if (selectrow==SelectedRow)
	{
		ValueClear("RowID^Remark^PayNo^PayFee^PayDate^InvoiceNo^InvoiceFee^InvoiceDate^UpdateUserDR^UpdateDate^UpdateTime^PayedFee");
		var obj=document.getElementById("InvalidFlag");
		obj.checked=false;
		SelectedRow=0;
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		var Status=GetElementValue("Status")
		if (Status==2)
		{
		DisableBElement("BAdd",false);}
		else
		{DisableBElement("BAdd",true);
		DisableBElement("BDelete",true);
		DisableBElement("BUpdate",true);
		}
		return;
	}
	DisableBElement("BUpdate",false);
	DisableBElement("BDelete",false);
	DisableBElement("BAdd",true);
	
	FillData(selectrow);
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
	var sort=13;
	SetElement("Remark",list[0]);
	SetElement("PayNo",list[1]);
	SetElement("PayFee",list[2]);
	SetElement("PayDate",list[3]);
	SetElement("ContractDR",list[4]);
	//SetElement("Contract",list[sort+0]);
	SetElement("InvoiceNo",list[5]);
	SetElement("InvoiceFee",list[6]);
	SetElement("InvoiceDate",list[7]);
	SetChkElement("InvalidFlag",list[8]);
	SetElement("UpdateUserDR",list[9]);
	SetElement("UpdateUser",list[sort+1]);
	SetElement("UpdateDate",list[10]);
	SetElement("UpdateTime",list[11]);
	SetElement("PayedFee",list[12]);
}
function ValueClear(Value)
{
	var value=Value.split("^");
	var i=0;
	for (i=0;i<value.length;i++)
	{
		var obj=document.getElementById(value[i]);
		if (obj) {obj.value="";}
		else{
		alertShow(value[i]);}
	}
}

function SetBEnabled()
{
	var obj=document.getElementById("Status");
	var Status=obj.value;
	if (Status!="2")
		{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BAdd",true);
		}
	else
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		}	
}
document.body.onload = BodyLoadHandler;
