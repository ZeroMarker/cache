///使用页面	个人收费
///
var CurrentSel=0
var SelectedRow=-1
var admid="";

var UserId=session['LOGON.USERID']
var Gloc=session['LOGON.GROUPID']
function ShortKeyDown()
{
	if (event.keyCode==115)
	{
		obj=document.getElementById("BReadCard");
		if (obj) obj.click();
	}
}
function BodyLoadHandler()
{
	//alert('a')
	ColorTblColumn();
	
	document.onkeydown=ShortKeyDown;
	
	obj=document.getElementById("Find");
	if (obj) obj.onclick=Find_click;	
	
	obj=document.getElementById("CardNo");
	if (obj) {obj.onchange=CardNo_Change;
	obj.onkeydown=CardNo_KeyDown;}

   //added by xy 20151023
	obj=document.getElementById("RegNo");
	if (obj){ obj.onkeydown=RegNo_KeyDown;}

	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	
	initialReadCardButton()
	
	InitKeyDown();
	
	RefreshChild();
	//websys_setfocus("CardNo")
}


function ColorTblColumn(){
	var tbl=document.getElementById('tDHCPEICashier');
	var row=tbl.rows.length;
	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable=document.getElementById('TConfirmStatusz'+j);
		var sTD=sLable.parentElement;
		var strCell=sLable.innerText;
		strCell=strCell.replace(" ","")
		if ((strCell=='是')) {
			sTD.bgColor="#FF0000"
		}
		}
}

function RegNo_KeyDown(){
	var Key=websys_getKey(e);
	if ((13==Key)) {
		Find_click();
	}
}


function CardNo_Change()
{
	CardNoChangeApp("RegNo","CardNo","Find_click()","Clear_click()","0");
}
function ReadCard_Click()
{
	ReadCardApp("RegNo","Find_click()","CardNo");
	
}

function RefreshChild()
{
	var rowid =""
	var objtbl=document.getElementById('tDHCPEICashier');	
	if (objtbl)
	{
		if (objtbl.rows.length>1) rowid=GetCtlValueById("TRowIdz1");			
	}
	RefreshPayAudit(rowid);	
}

function InitKeyDown()
{
	var obj=document.getElementById("RegNo");
	if (obj) 
	{	obj.onkeydown=Find_KeyDown;
	}
	var obj=document.getElementById("Name");
	if (obj) 
	{	obj.onkeydown=Find_KeyDown;
	}
}

function SelectRowHandler(){  


	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEICashier');
	
	if (objtbl){ var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	var rowid=""
	if (!selectrow) return;
	
	if (selectrow!=SelectedRow) {
		//ShowCurRecord(selectrow);
		SelectedRow = selectrow;
		rowid=GetCtlValueById("TRowIdz"+selectrow);
		
	}
	else{ SelectedRow=0; }
	RefreshPayAudit(rowid)
}

function RefreshPayAudit(rowid)
{
	if (rowid=="") return;
	admid=rowid;
	parent.frames["DHCPEPreAuditPay"].location.href='dhcpepreauditpay.csp?AppType=Fee&ADMType=I&CRMADM=&GIADM='+rowid;	
}

function Find_KeyDown()
{
	if (event.keyCode==13)	Find_click();
}

function Find_click() {
	var iRegNo="";					//登记号
	var iIADMName="";				//患者姓名
	var iAuditUserDRName=""; 		//审核人姓名
	var iAuditDateBegin_Find="";	//登记起始日期
	var iAuditDateEnd="";			//登记截止日期
	var obj;
	
  	obj=document.getElementById("RegNo");
    if (obj){ iRegNo=obj.value; }
    if (iRegNo.length<8 && iRegNo.length>0) { iRegNo=RegNoMask(iRegNo); } //added by xy 20151023	
    
   	obj=document.getElementById("Name");
    if (obj){ iIADMName=obj.value; }	   
	
    
  	obj=document.getElementById("AuditDateBegin_Find");
    if (obj){ iAuditDateBegin=obj.value; } 
       
  	obj=document.getElementById("AuditDateEnd_Find");
    if (obj){ iAuditDateEnd=obj.value; } 
    
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEICashier"
			+"&PAPMINo="+iRegNo						//登记号
			+"&IADMName="+iIADMName
			+"&AuditDateBegin="+iAuditDateBegin
			+"&AuditDateEnd="+iAuditDateEnd
			;		
    location.href=lnk; 
}

///费用
function UpdatePreAudit()
{
	var Type="I";
	
	if (""==admid) return false;
	
	var obj=document.getElementById('GetPreGIAdmID');
	if (obj) {encmeth=obj.value;}
	var ID=cspRunServerMethod(encmeth,Type,admid)    
	
	if (ID=="") return false;
	var lnk="dhcpepreaudit.csp?CRMADM="+ID+"&ADMType="+Type+"&GIADM="+"&RowID=";
	var wwidth=800;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}

document.body.onload = BodyLoadHandler;


/*
// ***********************************************************
/// 页面初始化
function IntDocument(){
	var obj=document.getElementById("FactAmount");
	if (obj) {
		obj.readOnly=true;
	}
	var obj=document.getElementById("AccountAmount");
	if (obj) {
		obj.readOnly=true;
	}
	var obj=document.getElementById("DischargedAmount");
	if (obj) {
		obj.readOnly=true;
	}
	var obj=document.getElementById("PayAmount");
	if (obj) {
		obj.readOnly=true;
	}
}
// *************************************************************
// 患者列表
function SearchPAADM(value) {
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;
		obj=document.getElementById("Name");
		obj.value=aiList[0];
		//obj=document.getElementById("RowId");
		//obj.value=aiList[2];
	}		
}

/////////////////////////////////////////////////////////////////
///////		根据组合条件 查询团体的收费情况					/////////

// ******************************************************************
//结算
function BBilled_Click()
{	
	//InvPrintNew(,"");
	//return;
	//
	//
	//BillPrintNew("0^51138^");
	//return;
	
	var AdmRowId="",PAADM,FactAmount,PayAmount;
  	var obj=document.getElementById("RowId");
    if (obj){
		AdmRowId=obj.value
	}
	if (AdmRowId==""){
		alert("请选择需要结算的记录");
		return false
  	}   	
 	
	var obj=document.getElementById("FactAmount");
  	//alert("obj:"+obj);
    if (obj){
		FactAmount=obj.value
	}
	
	var obj=document.getElementById("PayAmount");
  	//alert("obj:"+obj);
    if (obj){
		PayAmount=obj.value
	}

  	var obj=document.getElementById("PAADM");
    if (obj){
		PAADM=obj.value
	}
	
	var PaymodeType="",ChequeNo="",Paymode=""
  	var obj=document.getElementById("PaymentType");
    if (obj){
		PaymodeType=obj.value
	}
  	var obj=document.getElementById("ChequeNo");
    if (obj){
		ChequeNo=obj.value
	}
	
	if (PaymodeType==""){
		alert("请选择结算方式");
		return false
  	} 
  	if((PaymodeType=="支票")&&(ChequeNo=="")){
	  	alert("请输入支票号");
	  	return false
	}
	if (PaymodeType=="现金"){
		Paymode="1"
		}
	else {
		Paymode="2"
	}
	
	var billobj=document.getElementById("BBilled");
	
	var Ins=document.getElementById('BilledBox');
    if (Ins) {var encmeth=Ins.value} 
    else {var encmeth=''};
    //alert(AdmRowId+"^"+PAADM+"^"+UserId+"^"+Paymode+"^"+ChequeNo+"^"+"1"+"^"+Gloc+"^"+FactAmount+"^"+PayAmount)
    //alert(encmeth);
    //return false;
    
    var rtnvalue=cspRunServerMethod(encmeth,'','',AdmRowId,PAADM,UserId,Paymode,ChequeNo,"1",Gloc,FactAmount,PayAmount,'N','')
    //alert("rtnvalue:"+rtnvalue);
    var billary=rtnvalue.split("^");
    if (billary[0]=="0") {
	    BillPrintNew(rtnvalue);
	    billobj.disabled=true;
	    //alert("结算成功!")	    
	    alert(t["FootOK1"]+(billary.length-2)+t["FootOK2"]);

	    }
    else{

		//alert("Update error.ErrNo="+flag)
		switch(billary[0]){
			case "103":
				alert(t[billary[0]]);
				break;
			case "101":
				alert(t[billary[0]]);
				break;
			case "102":
				alert(t[billary[0]]);
				break;
			default:
				alert(t['FootFail']+rtnvalue);
			}
    }
    location.reload();
}

///////////////////////////
function BillPrintNew(INVstr){
	//alert("BillPrintNew INVstr:"+INVstr);
	var INVtmp=INVstr.split("^");
	///
	///INVstr
	for (var invi=1;invi<INVtmp.length;invi++)
	{
		if (INVtmp[invi]!=""){
			var beforeprint=document.getElementById('getSendtoPrintinfo');
			if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
			
			var payobj=document.getElementById("PaymentType");
			if (payobj){
				var PayMode=payobj.value;
			}
			var Guser=session['LOGON.USERID'];
			var sUserCode=session['LOGON.USERCODE'];
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			//alert("PayMode:"+PayMode);
			var Printinfo=cspRunServerMethod(encmeth,"InvPrintNew",INVtmp[invi],sUserCode,PayMode);
		}
	}
}


function InvPrintNew(TxtInfo,ListInfo)
{
	////
	////DHCP_PrintFun(encmeth,PObj,inpara,inlist)
	//alert("ddddd");
	var beforeprint=document.getElementById('TestPrint');
	if (beforeprint) {var encmeth=beforeprint.value} else {var encmeth=''};
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,TxtInfo,ListInfo);	
}



// **************************************************************
//查询当前人员的检验项目 
//触发条件 点击菜单 个人项目查询
function SearchIAdmOrderList() {

	var lnk;
	var iEpisodeID="";
	
	obj=document.getElementById("PAADM");
	iEpisodeID=obj.value;	
	if (""==iEpisodeID) {
		alert("请先选择缴费人员");
		return false;
	}
	
	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIAdmOrderList"
		+"&"+"EpisodeID="+iEpisodeID;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0';

	window.open(lnk,"_blank",nwin)
}
// **************************************************************

function trim(s) {
        var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
        return (m == null) ? "" : m[1];
}

// **************************************************************
//显示当前记录的信息
function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;
	
	SelRowObj=document.getElementById('TRowId'+'z'+selectrow);
	obj=document.getElementById("RowId");
	obj.value=trim(SelRowObj.value);

	SelRowObj=document.getElementById('TPAADM'+'z'+selectrow);
	obj=document.getElementById("PAADM");
	obj.value=trim(SelRowObj.value);
	
	SelRowObj=document.getElementById('TFactAmount'+'z'+selectrow);
	obj=document.getElementById("FactAmount");
	obj.value=trim(SelRowObj.innerText);
	
	SelRowObj=document.getElementById('TAccountAmount'+'z'+selectrow);
	obj=document.getElementById("AccountAmount");
	obj.value=trim(SelRowObj.innerText);
		
	SelRowObj=document.getElementById('TDischargedAmount'+'z'+selectrow);
	obj=document.getElementById("DischargedAmount");
	obj.value=trim(SelRowObj.innerText);

	SelRowObj=document.getElementById('TPayAmount'+'z'+selectrow);
	obj=document.getElementById("PayAmount");
	obj.value=trim(SelRowObj.innerText);

	obj=document.getElementById("PaymentType");
	obj.value=trim("现金");
	
	obj=document.getElementById("ChequeNo");
	obj.value="";
	

}

// ************************************************************************
 
*/