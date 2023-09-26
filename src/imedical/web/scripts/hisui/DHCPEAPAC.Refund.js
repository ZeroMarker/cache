
//名称	DHCPEAPAC.Refund.js
//功能	体检卡退费
//组件	DHCPEAPAC.Refund 	
//创建	2019.04.03
//创建人  xy

function BodyLoadHandler(){
	var obj=GetObj("BRefund");
    if (obj) obj.onclick=BRefund_click;
    
    var obj=GetObj("InvNo");
    if (obj) obj.onchange=InvNo_change;
    
    var obj=GetObj("InvNo");
    if (obj) obj.onkeydown=InvNo_keydown;
  
	//更新支付方式
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
		$.messager.alert("提示",DataArr[0],"info");
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
		$.messager.alert("提示","退费的记录不存在","info");
		return false;
	}
	var PayMode=getValueById("PayModeDR");
	
	var ret=tkMakeServerCall("web.DHCPE.AdvancePayment","UpdatePayMode",RowID,PayMode);
	var Arr=ret.split("^");
	if (Arr[0]!="0"){
		$.messager.alert("提示",Arr[1],"info");
	}else{
		//$.messager.alert("提示","更新成功","success");
		alert("更新成功")
		websys_showModal("close");
		
	}
	
}


function BRefund_click()
{
	var RowID=GetOneData("RowID");
	if (RowID=="")
	{	
		$.messager.alert("提示","退费的记录不存在","info");
		return false;
	}
	var RFee=GetOneData("RFee");
	var LFee=GetOneData("RemainAmount");
	var OldFee=GetOneData("Amount");
	if ((+RFee)>(+OldFee))
	{
		
		$.messager.alert("提示","退费金额不能大于原充值金额","info");
		return false;
	}
	if ((+RFee)>(+LFee))
	{
		$.messager.alert("提示","退费金额不能大于剩余金额","info");
		return false;
	}
	var encmeth=GetOneData("RefundClass");
	if (encmeth=="")
	{
		$.messager.alert("提示","没有获取数据的方法","info");
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
		$.messager.alert("提示",RetArr[0],"info");
		return false;
	}
	var Inv=RetArr[1];
	if (Inv!="")
	{
		PrintInv(Inv)
	}
	//$.messager.alert("提示","退费成功","success");
	alert("退费成功")
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
		$.messager.alert("提示","没有获取数据的方法","info");
		return false;
	}
	var Data=cspRunServerMethod(encmeth,InvNo);
	var DataArr=Data.split("^");
	if (DataArr[0]!=0)
	{
		$.messager.alert("提示",DataArr[0],"info");
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