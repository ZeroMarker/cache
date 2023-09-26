///filename: DHCPEIRegister.JS
///脚本名称 个人登记
///对应页面 个人登记
///-----------------
///modified by SongDeBo 2006/5/22
///Description: replace control "QueryType" whith "patName, patCertId, PatNo"
///---------------------
///modified by SongDeBo 2006/4/19
///description: add function FillQueryType
///---------------------------------

var CurrentSel=0;

var SelectedRow=-1;

var UserId=session['LOGON.USERID'];
var LocId=session['LOGON.CTLOCID'];


function BodyLoadHandler(){	
	var obj;
	
	obj=document.getElementById("BGetData");
	if (obj) { obj.onclick=BGetData_click; }
	               
	obj=document.getElementById("BRegister");
	if (obj) { obj.onclick=BRegister_Click; }
	
	obj=document.getElementById("Query");
	if (obj) { obj.onclick=Query_click; }
	
	obj=document.getElementById("SelectR");
	if (obj) {obj.onclick=Register_Select;}
	
	obj=document.getElementById("PatNo");
	if (obj) { obj.onkeydown=PatNo_KeyDown;}
	
	obj=document.getElementById("PatName");
	if (obj){ obj.onkeydown=PatNo_KeyDown;}
	
	obj=document.getElementById("BRegisterPrint");
	if (obj){ obj.onclick=RegisterPrint_Click;}
	
	obj=document.getElementById("BRegArrive");
	if (obj){ obj.onclick=BRegArrive_click;}
	
	obj=document.getElementById("CardNo");
	if (obj) {obj.onchange=CardNo_Change;
	obj.onkeydown=CardNo_keydown;}
	
	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}

    obj=document.getElementById("BRegArrivePrint");	
	if (obj){obj.onclick=BRegArrivePrint_click;}         //add by zhouli end
	
	initialReadCardButton()
	Keydown_App();
	SetSort("tDHCPEIRegister","TSort")
	Muilt_LookUp('GroupDesc'+'^'+'TeamDesc');
	
}
function CardNo_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
		CardNo_Change();
	}
}

function CardNo_Change()
{
	CardNoChangeApp("PatNo","CardNo","Query_click()","Clear_click()","0");
	var obj=document.getElementById("PatNo");
	if (obj)
	{  
		if (obj.value!="")
       {   
	       DHC_AutoArrived(obj.value)}	   
	}
	
}
function ReadCard_Click()
{
	ReadCardApp("PatNo","Query_click()","CardNo");
	var obj=document.getElementById("PatNo");
	if (obj)
	{  
		if (obj.value!="")
       {   
	       DHC_AutoArrived(obj.value)}	   
	}
}
function DHC_AutoArrived(RegNo)
{  
    var obj=document.getElementById('AutoArrivedBox');
	if (obj) {var encmeth=obj.value} else {var encmeth=''};
	
	var Return=cspRunServerMethod(encmeth,RegNo);

	if (Return!=0)
	{   
		alert("error="+Return);
        return false
    }
     else
     {  
	     location.reload();
	    }
        			
	return;
}

function BRegArrive_click()
{ 
	Arrive("1","N");
	return;
}

function PatNo_KeyDown(e)
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		Query_click("1");
	}
}
function Keydown_App()
{
	var AppFlag=GetCtlValueById('AppFlag',1);
	var objtbl=document.getElementById('tDHCPEIRegister');
		if (objtbl){
			var rows=objtbl.rows.length;
			if (rows==1){
				return;
			}
			if (AppFlag!="1") return;
	
			if (rows==2)
			{
				
				CRMId=GetCtlValueById('TRegID'+'z1',1);
				if (CRMId=="") return;
				
				Status=GetCtlValueById('TStatus'+'z1',1);
				if (Status=="REGISTERED") {	
	
    				//设置到达状态
					encmeth=GetCtlValueById('IAdmArrivedBox',1);        
    				var flag=cspRunServerMethod(encmeth,CRMId);///////////
    				if (flag!='0') {
        				alert(t['FailsArrived']+"  error="+flag);
        				return false
    				}
				}
				else if(Status=="PREREGED")
				{
					encmeth=GetCtlValueById('GetDataBox',1);
					var flag=cspRunServerMethod(encmeth,CRMId,UserId);
			
					if (flag!='') {
        				alert(t['FailsTrans']+"  error="+flag);
       					return false
    				}
    				encmeth=GetCtlValueById('IAdmArrivedBox',1); 
					var flag=cspRunServerMethod(encmeth,CRMId);///////////
					if (flag!='0') {
						alert(t['FailsArrived']+" error="+flag);
						return false}
					//BarCodePrintByCrm(CRMId);
				}
				//Query_click("0");
			}
		}
}
function Query_click(flag){
	var QueryValue="", QueryType="";
	var groupdr=GetCtlValueById("GroupDR");
	var teamdr=GetCtlValueById("TeamDR");
	var strPatName=GetCtlValueById("PatName")
	var strPatCertId=GetCtlValueById("PatCertID")
	var strPatNo=GetCtlValueById("PatNo")
	var Depart=GetCtlValueById("Depart")
	strPatName= MyReplace(strPatName," ","")
	strPatCertId= MyReplace(strPatCertId," ","")
	strPatNo= MyReplace(strPatNo," ","")	
	if (strPatName!=""){
		QueryType="PATNAME";
		QueryValue=strPatName;
	}
	else if (strPatCertId!=""){
		QueryType="CERTID";
		QueryValue=strPatCertId;
	}
	else if (strPatNo!=""){
		QueryType="HISCARDID";
		//QueryValue=FormatAdmNo(strPatNo);
		QueryValue = RegNoMask(strPatNo); 
		
	}
	else
	{	QueryType="PATNAME";
		QueryValue="";}

	var obj=document.getElementById("IncludeRegistered")
	var strIncludeRegistered=0
	if (obj.checked==1) {strIncludeRegistered=1}

	lnk= "websys.default.csp?";
	lnk=lnk	+"WEBSYS.TCOMPONENT="+"DHCPEIRegister";
	lnk=lnk	+"&"+"queryType="+QueryType;
	lnk=lnk+"&"+"queryValue="+QueryValue ;
	lnk=lnk+"&" +"IncludeRegistered="+strIncludeRegistered;
	lnk=lnk+"&gadm="+groupdr;
	lnk=lnk+"&gteam="+teamdr;
	lnk=lnk+"&AppFlag="+flag;
	lnk=lnk+"&Depart="+Depart;
	DAlert(lnk);
	location.href=lnk;
	
}

function BGetData_click()
{	
	var chkedcount=0;
	var encmeth;
	var rows;
	var objtbl=document.getElementById('tDHCPEIRegister');
	if (objtbl){
		rows=objtbl.rows.length;
	}
	
	var chkobj;
	var CRMId;
	var Status;
	for (var i=1;i<rows;i++)
	{	
		chkobj=document.getElementById('TSelect'+'z'+i);		
		if ((chkobj)&&(chkobj.checked))
		{
			chkedcount=chkedcount+1;
			CRMId=GetCtlValueById('TRegID'+'z'+i,1);
			if (CRMId=="") continue;
			
			Status=GetCtlValueById('TStatus'+'z'+i,1);
			if (Status=="REGISTERED") {	
				var ArrivedFlag=JudgeArrivedNum(CRMId);//DHCPE.Toolets.Common.js
				//if (!ArrivedFlag) continue;
    			//设置到达状态
				encmeth=GetCtlValueById('IAdmArrivedBox',1);        
    			var flag=cspRunServerMethod(encmeth,CRMId);///////////
    			if (flag!='0') {
        			alert(t['FailsArrived']+"  error="+flag);
        			return false
    			}else{
	    			var RoomDesc=tkMakeServerCall("web.DHCPE.RoomManager","GetAdmCurRoom",CRMId,"PRE")
					if (RoomDesc!=""){
						//alert("请到"+RoomDesc+"候诊");
					}
    			}
			}
		}		
	}
	if (chkedcount>0)
	{
		alert(t['Completed']);
    	location.reload();
	}
	else
	{
		alert(t['NoSelected']);
	}

}

function BRegister_Click()
{	
	Arrive("0","N");
	return;
}
//个人项目信息获取 
function Arrive(ArriveFlag,PrintFlag)
{
	var chkedcount=0;
	var encmeth;
	var rows;
	var objtbl=document.getElementById('tDHCPEIRegister');
	if (objtbl){
		rows=objtbl.rows.length;
	}
	
	//var lastrowindex=rows - 1;
	var chkobj;
	var CRMId;
	var Status;
	for (var i=1;i<rows;i++)
	{	
		chkobj=document.getElementById('TSelect'+'z'+i);		
		if ((chkobj)&&(chkobj.checked))
		{
			encmeth=GetCtlValueById('GetDataBox',1);			
			chkedcount=chkedcount+1;
			CRMId=GetCtlValueById('TRegID'+'z'+i,1);
			if (CRMId=="") continue;
			Status=GetCtlValueById('TStatus'+'z'+i,1);
			if (Status=="PREREGED") {	
				var ASCharged=GetCtlValueById('IsAsCharged',1);
				var AsChargedFlag=cspRunServerMethod(ASCharged,CRMId);
				if (AsChargedFlag=="1")
				{
					if (!confirm(t["IsAsCharged"]))
					{
						return false;
					}
				}

				var flag=cspRunServerMethod(encmeth,CRMId,UserId);
			    if ((PrintFlag=="Y")&&(ArriveFlag=="0"))    //add byzhouli start
				{     
			      PatItemPrintA4(CRMId)
		         //BarCodePrint(CRMId)
                 }                                         //add byzhouli  end
				if (flag!='') {
        			alert(t['FailsTrans']+"  error="+flag);
       				return false
    			}
    			if (ArriveFlag=="1")
				{
					var ArrivedFlag=JudgeArrivedNum(CRMId);
					if (!ArrivedFlag) continue;
	 				encmeth=GetCtlValueById('IAdmArrivedBox',1); 
					var flag=cspRunServerMethod(encmeth,CRMId);///////////
					                //add byzhouli  end
				 if (flag!='0') {
						alert(t['FailsArrived']+" error="+flag);
						return false}
					//BarCodePrintByCrm(CRMId);
				}else{
					var RoomDesc=tkMakeServerCall("web.DHCPE.RoomManager","GetAdmCurRoom",CRMId,"PRE")
					if (RoomDesc!=""){
						alert("请到"+RoomDesc+"候诊");
					}
					if (PrintFlag=="Y")               //add byzhouli start
				    {	     
			     		PatItemPrintA4(CRMId)
		         	//BarCodePrint(CRMId); 
		         	}     
				}

			}
		}		
	}
	if (chkedcount>0)
	{
		alert(t['Completed']);
    	location.reload();
	}
	else
	{
		alert(t['NoSelected']);
	}
	return true;
}

function SetGroup(value)
{
	///alert(value);
	list=value.split("^");
	SetCtlValueById("GroupDR",list[1],0);
}
function SetTeam(value)
{
	///alert(value);
	list=value.split("^");
	SetCtlValueById("TeamDR",list[1],0);
	SetCtlValueById("TeamDesc",list[4],0);
}
// *****************************************************************
function ShowCurRecord(selectrow) 
{
	var SelRowObj;
	var obj;
	
	SelRowObj=document.getElementById('TRegID'+'z'+selectrow);
	obj=document.getElementById("CRMId");
	obj.value=SelRowObj.value;
	//alert(obj.value);
	SelRowObj=document.getElementById('TStatus'+'z'+selectrow);
	obj=document.getElementById("Status");
	obj.value=SelRowObj.innerText;	
	//alert("aaa:"+SelRowObj.value);
	var Status=SelRowObj.value;
	if (Status=="PREREGED"){
		obj=document.getElementById("BGetData");
		if (obj){obj.disabled=true;}
		obj=document.getElementById("BRegister");
		if (obj) obj.disabled=false;
		obj=document.getElementById("BRegArrive");
		if (obj) obj.disabled=false;
	}
	if (Status=="REGISTERED"){
		obj=document.getElementById("BGetData");
		if (obj){obj.disabled=false;}
		obj=document.getElementById("BRegister");
		if (obj) obj.disabled=true;
		obj=document.getElementById("BRegArrive");
		if (obj) obj.disabled=true;
	}
	
}

function SelectRowHandler(){  

	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEIRegister');
	if (objtbl){
		var rows=objtbl.rows.length;
	}
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	var RegId;

	if (!selectrow) return;
	
	if (selectrow!=SelectedRow) {
		ShowCurRecord(selectrow);
		SelectedRow = selectrow;
	}
	else{
		RegId="";
		SelectedRow="-1";
	}
	ChangeCheckStatus("TSelect");
}

function Register_Select()
{
var Src=window.event.srcElement;

var tbl=document.getElementById('tDHCPEIRegister');//取表格元素?名称
var row=tbl.rows.length;

for (var iLLoop=1;iLLoop<=row;iLLoop++) {
obj=document.getElementById('TSelect'+'z'+iLLoop);
if (obj) { obj.checked=!obj.checked; }
}
}

function SetSort(TableName,ItemName)
{
	var objtbl=document.getElementById(TableName);	
	
	if (objtbl) { var rows=objtbl.rows.length; }
	for (var j=1;j<rows;j++)
	{
		var obj=document.getElementById(ItemName+"z"+j);
		if (obj) obj.innerText=j;	
	}
}
function RegisterPrint_Click()
{
	//var rtn=Arrive("0");


	var rtn=Arrive("0","Y");
  
}	
function BRegArrivePrint_click()
{  	
 
	var rtn=Arrive("1","Y");

}
// 打印导检单A4
function PatItemPrintA4(CRMId)  
{
	var Instring=CRMId+"^"+""+"^CRM"+"^"+"";
	    var Ins=document.getElementById('GetOEOrdItemBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var value=cspRunServerMethod(encmeth,'','',Instring);
	 Print(value,Page);
}

function BarCodePrint(CRMId)

{	
    var obj=document.getElementById('GetIADMIDBox');
	if (obj) {var encmeth=obj.value; } else {var encmeth=''; }
	var PAADM=cspRunServerMethod(encmeth,CRMId); 
    var Ins=document.getElementById("PatOrdItemInfo");
	if (Ins) {var encmeth1=Ins.value; } else {var encmeth1=''; };
	var flag=cspRunServerMethod(encmeth1,"BarPrint","",PAADM,"Y","N");
	}

function BarPrint(value) {
 
    if (""==value) {
		alert("未找到检验项目");
		return false;
	}
	if (value=="NoPayed")
	{
		alert(t["NoPayed"])
		return false;
	}
	var ArrStr=value.split("$$");
	var Num=0
	if (ArrStr.length>1) Num=ArrStr[1];
	value=ArrStr[0];
	PrintBarApp(value,"")
	return;	
}

document.body.onload = BodyLoadHandler;