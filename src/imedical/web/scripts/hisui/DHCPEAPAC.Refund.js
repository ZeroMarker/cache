
//����	DHCPEAPAC.Refund.js
//����	��쿨�˷�
//���	DHCPEAPAC.Refund 	
//����	2019.04.03
//������  xy

function BodyLoadHandler(){
	var obj=GetObj("BRefund");
    if (obj) obj.onclick=BRefund_click;
    
    var obj=GetObj("InvNo");
    if (obj) obj.onchange=InvNo_change;
    
    var obj=GetObj("InvNo");
    if (obj) obj.onkeydown=InvNo_keydown;
  
	//����֧����ʽ
    var obj=document.getElementById("BUpdatePayMode");
	if (obj) {obj.onclick=BUpdatePayMode_click;}
	
	SetInvNo(); 
    FillPatientDatabyRowID();

}


function FillPatientDatabyRowID()
{
	var obj="";
	var RowID=getValueById("RowID");   
    if (RowID==""){return false;}
	var Data=tkMakeServerCall("web.DHCPE.AdvancePayment","GetInfo",RowID);
	var DataArr=Data.split("^");
	if (DataArr[0]!=0)
	{
		$.messager.alert("��ʾ",DataArr[0],"info");
		return false;
	}
	
	setValueById("RowID",DataArr[1]);
	setValueById("RegNo",DataArr[2]);
	setValueById("Name",DataArr[3]);
	setValueById("Amount",DataArr[4]);
	setValueById("PayModeDR",DataArr[5]);
	setValueById("Remark",DataArr[6]);
	setValueById("RemainAmount",DataArr[7]);
	setValueById("InvNo",DataArr[8]);
	if ((+DataArr[7])>(+DataArr[4]))
	{
		var RFee=DataArr[4];
	}
	else
	{
		var RFee=DataArr[7]
	}
	setValueById("RFee",RFee);
	return true;
}

function SetInvNo()
{ 
	var userId=session['LOGON.USERID'];
	var ret=tkMakeServerCall("web.DHCPE.DHCPEPAY","getcurinvno",userId);
	
    var invNo=ret.split("^");
    if ((invNo[0]=="")||(invNo[1]==""))
    	{ messageShow("","","",t['NoCorrectInv']); 
    	 		}
    	 		   
    if(invNo[2]!=""){var No=invNo[2]+""+invNo[0];}
    else {var No=invNo[0];}
    var obj=document.getElementById("CurInvNo");
    if(obj){obj.value=No;}
    
    return ;
}

function BUpdatePayMode_click()
{
	var RowID=getValueById("RowID");
	if (RowID=="")
	{
		$.messager.alert("��ʾ","�˷ѵļ�¼������","info");
		return false;
	}
	var PayMode=getValueById("PayModeDR");
	
	var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","UpdatePayMode",RowID,PayMode);
	var Arr=ret.split("^");
	if (Arr[0]!="0"){
		$.messager.alert("��ʾ",Arr[1],"info");
	}else{
		//$.messager.alert("��ʾ","���³ɹ�","success");
		alert("���³ɹ�")
		websys_showModal("close");
		
	}
	
}


function BRefund_click()
{
	var RowID=GetOneData("RowID");
	if (RowID=="")
	{	
		$.messager.alert("��ʾ","�˷ѵļ�¼������","info");
		return false;
	}
	var RFee=GetOneData("RFee");
	var LFee=GetOneData("RemainAmount");
	var OldFee=GetOneData("Amount");
	if ((+RFee)>(+OldFee))
	{
		
		$.messager.alert("��ʾ","�˷ѽ��ܴ���ԭ��ֵ���","info");
		return false;
	}
	if ((+RFee)>(+LFee))
	{
		$.messager.alert("��ʾ","�˷ѽ��ܴ���ʣ����","info");
		return false;
	}
	var encmeth=GetOneData("RefundClass");
	if (encmeth=="")
	{
		$.messager.alert("��ʾ","û�л�ȡ���ݵķ���","info");
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
		$.messager.alert("��ʾ",RetArr[0],"info");
		return false;
	}
	var Inv=RetArr[1];
	if (Inv!="")
	{
		PrintInv(Inv)
	}
	//$.messager.alert("��ʾ","�˷ѳɹ�","success");
	alert("�˷ѳɹ�")
	websys_showModal("close");
	
}
function GetObj(ObjID)
{
	var obj=document.getElementById(ObjID);
	return obj;
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
		$.messager.alert("��ʾ","û�л�ȡ���ݵķ���","info");
		return false;
	}
	var Data=cspRunServerMethod(encmeth,InvNo);
	var DataArr=Data.split("^");
	if (DataArr[0]!=0)
	{
		$.messager.alert("��ʾ",DataArr[0],"info");
		return false;
	}
	setValueById("RowID",DataArr[1]);
	setValueById("RegNo",DataArr[2]);
	setValueById("Name",DataArr[3]);
	setValueById("Amount",DataArr[4]);
	setValueById("PayModeDR",DataArr[5]);
	setValueById("Remark",DataArr[6]);
	setValueById("RemainAmount",DataArr[7]);
	if ((+DataArr[7])>(+DataArr[4]))
	{
		var RFee=DataArr[4];
	}
	else
	{
		var RFee=DataArr[7]
	}
	setValueById("RFee",RFee);
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
	//alert("TxtInfo:"+TxtInfo)
	//alert("ListInfo:"+ListInfo)
	DHCP_GetXMLConfig("InvPrintEncrypt","PEInvPrint");
	var myobj=document.getElementById("ClsBillPrint");
	//messageShow("","","",myobj)
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);
}
function Clear()
{
	setValueById("RowID","");
	setValueById("RegNo","");
	setValueById("Name","");
	setValueById("Amount","");
	setValueById("PayModeDR","");
	setValueById("Remark","");
	setValueById("RemainAmount","");
	setValueById("RFee","");
}
document.body.onload = BodyLoadHandler;