function BodyLoadHandler(){
	var obj=GetObj("BRefund");
    if (obj) obj.onclick=BRefund_click;
    var obj=GetObj("InvNo");
    if (obj) obj.onchange=InvNo_change;
    var obj=GetObj("InvNo");
    if (obj) obj.onkeydown=InvNo_keydown;
    var obj=GetObj("PayModeDR");
    //if (obj) obj.disabled=true;
	
	//更新支付方式
    var obj=document.getElementById("BUpdatePayMode");
	if (obj) {obj.onclick=BUpdatePayMode_click;}
	SetInvNo(); 
    FillPatientDatabyRowID();
	Inti();
}
function Inti()
{
	var obj=GetObj("Type");
	if(obj){var Type=obj.value;}
	var obj=GetObj("cTitle");
	if (obj)
	{
		if (Type=="C") obj.innerText="退代金卡";
	}

}

function FillPatientDatabyRowID()
{
	var obj="";
	var obj=GetObj("RowID");
	if (obj) RowID=obj.value;   
    if (RowID==""){return false;}
	var Data=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInfo",RowID);
	var DataArr=Data.split("^");
	if (DataArr[0]!=0)
	{
		AL(DataArr[0])
		return false;
	}
	SetOneData("RowID",DataArr[1]);
	SetOneData("RegNo",DataArr[2]);
	SetOneData("Name",DataArr[3]);
	SetOneData("Amount",DataArr[4]);
	SetOneData("PayModeDR",DataArr[5]);
	SetOneData("Remark",DataArr[6]);
	SetOneData("RemainAmount",DataArr[7]);
	SetOneData("InvNo",DataArr[8]);
	if ((+DataArr[7])>(+DataArr[4]))
	{
		var RFee=DataArr[4];
	}
	else
	{
		var RFee=DataArr[7]
	}
	SetOneData("RFee",RFee);
	return true;
}
function SetInvNo()
{ 
	var userId=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId);
	
    var invNo=ret.split("^");
    if ((invNo[0]=="")||(invNo[1]==""))
    	{ alert(t['NoCorrectInv']); 
    	 		}
    	 		   
    if(invNo[2]!=""){var No=invNo[2]+""+invNo[0];}
    else {var No=invNo[0];}
    var obj=document.getElementById("CurInvNo");
    if(obj){obj.value=No;}
    
    return ;
}

function BUpdatePayMode_click()
{
	var RowID=GetOneData("RowID");
	if (RowID=="")
	{
		AL(t["03"]);
		return false;
	}
	var PayMode=GetOneData("PayModeDR");
	var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","UpdatePayMode",RowID,PayMode);
	var Arr=ret.split("^");
	if (Arr[0]!="0"){
		alert(Arr[1]);
	}else{
		alert("更新成功");
	}
}


function BRefund_click()
{
	var RowID=GetOneData("RowID");
	if (RowID=="")
	{
		AL(t["03"]);
		return false;
	}
	var RFee=GetOneData("RFee");
	var LFee=GetOneData("RemainAmount");
	var OldFee=GetOneData("Amount");
	if ((+RFee)>(+OldFee))
	{
		AL(t["04"])
		return false;
	}
	if ((+RFee)>(+LFee))
	{
		AL(t["05"])
		return false;
	}
	var encmeth=GetOneData("RefundClass");
	if (encmeth=="")
	{
		AL(t['01']);
		return false;
	}
	var RRemark=GetOneData("RRemark");
	var InvID=GetOneData("CurInvNo");
    var InvID=tkMakeServerCall("web.DHCPE.DHCPECommon","GetInvnoNotZM",InvID);
	var PayMode=GetOneData("PayModeDR");
	var Strings=RowID+"^"+RFee+"^"+InvID+"^"+PayMode+"^"+RRemark
	var ret=cspRunServerMethod(encmeth,Strings);
	var RetArr=ret.split("^");
	if (RetArr[0]!=0)
	{
		AL(RetArr[0]);
		return false;
	}
	var Inv=RetArr[1];
	if (Inv!="")
	{
		PrintInv(Inv)
	}
	AL(t["Sussess"])
}
function GetObj(ObjID)
{
	var obj=document.getElementById(ObjID);
	return obj;
}
function AL(String)
{
	alert(String)
}

function SetOneData(ElementName,DataStr)
{
	var obj=GetObj(ElementName);
	if (obj)
	{
		obj.value=DataStr;
	}
}
function GetOneData(ElementName)
{
	var DataStr="";
	var obj=GetObj(ElementName);
	if (obj) DataStr=obj.value;
	return DataStr;
}
function InvNo_change()
{
	FillPatientData();
	
}
function FillPatientData()
{
	Clear();
	var InvNo=GetOneData("InvNo");
	if (InvNo=="") return false;
	var encmeth=GetOneData("GetDataClass");
	if (encmeth=="")
	{
		AL(t['01']);
		return false;
	}
	var Data=cspRunServerMethod(encmeth,InvNo);
	var DataArr=Data.split("^");
	if (DataArr[0]!=0)
	{
		AL(DataArr[0])
		return false;
	}
	SetOneData("RowID",DataArr[1]);
	SetOneData("RegNo",DataArr[2]);
	SetOneData("Name",DataArr[3]);
	SetOneData("Amount",DataArr[4]);
	SetOneData("PayModeDR",DataArr[5]);
	SetOneData("Remark",DataArr[6]);
	SetOneData("RemainAmount",DataArr[7]);
	if ((+DataArr[7])>(+DataArr[4]))
	{
		var RFee=DataArr[4];
	}
	else
	{
		var RFee=DataArr[7]
	}
	SetOneData("RFee",RFee);
	return true;
}
function InvNo_keydown(e)
{
	var key=websys_getKey(e);
	if ( 13==key) {
		FillPatientData();
	}
}
function PrintInv(InvID)
{
	var encmeth=GetOneData("GetInvoiceInfo")
	var TxtInfo=cspRunServerMethod(encmeth,InvID,"1")
	var ListInfo=cspRunServerMethod(encmeth,InvID,"2")
	///xml print requird
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}
function Clear()
{
	SetOneData("RowID","");
	SetOneData("RegNo","");
	SetOneData("Name","");
	SetOneData("Amount","");
	SetOneData("PayModeDR","");
	SetOneData("Remark","");
	SetOneData("RemainAmount","");
	SetOneData("RFee","");
}
document.body.onload = BodyLoadHandler;