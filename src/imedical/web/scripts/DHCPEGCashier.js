var CurrentSel=0;
var SelectedRow=0;

var UserId=session['LOGON.USERID'];
var Gloc=session['LOGON.GROUPID'];

function BodyLoadHandler()
{	
	ColorTblColumn();
	
	var obj=document.getElementById("Find");
	if (obj) { obj.onclick=Find_click; }
	
	obj=document.getElementById("CardNo");
	if (obj) {
		obj.onchange=CardNo_Change;
		//obj.onkeydown=CardNo_KeyDown;
		 obj.onkeydown=CardNo_keydown;
	}


	obj=document.getElementById("BReadCard");
	if (obj) {obj.onclick=ReadCard_Click;}
	initialReadCardButton()
	InitKeyDown();
	RefreshChild();
	Muilt_LookUp('GBI_Desc_Find');
	document.onkeydown=ShortKeyDown;
}

function ColorTblColumn(){
	var tbl=document.getElementById('tDHCPEGCashier'); 
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

function ShortKeyDown()
{
	if (event.keyCode==115)
	{
		obj=document.getElementById("BReadCard");
		if (obj) obj.click();
	}
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
	CardNoChangeApp("GADM","CardNo","Find_click()","Clear_click()","0");
}
function ReadCard_Click()
{
	ReadCardApp("GADM","Find_click()","CardNo");
	
}
function RefreshChild()
{
	var rowid =""
	var objtbl=document.getElementById('tDHCPEGCashier');	
	if (objtbl)
	{   if (objtbl.rows.length>1)  rowid=GetCtlValueById("TRowIdz1");
	}
	RefreshPayAudit(rowid);	
}

function InitKeyDown()
{
	var obj=document.getElementById("GADM");
	if (obj) 
	{	obj.onkeydown=Find_KeyDown;
	}
	var obj=document.getElementById("GBI_Desc_Find");
	if (obj) 
	{	obj.onkeydown=Find_KeyDown;
	}	
}

function Find_KeyDown()
{
	if (event.keyCode==13)	Find_click();
}

function Find_click() {
	var iGBIDesc="";  				//单位名称
	var iAuditUserName=""; 				//审核人
	var iAuditDateBegin_Find="";	//登记起始日期
	var iAuditDateEnd="";			//登记截止日期
	var GADM="";
	var obj;
	
  	obj=document.getElementById("GBI_Desc_Find");
    if (obj){ iGBIDesc=obj.value; }	
	
  	//obj=document.getElementById("AuditUserDR_Name_Find");
    //if (obj){ iAuditUserName=obj.value; }
    
  	obj=document.getElementById("AuditDateBegin_Find");
    if (obj){ iAuditDateBegin=obj.value; } 
       
  	obj=document.getElementById("AuditDateEnd_Find");
    if (obj){ iAuditDateEnd=obj.value; }    	
    obj=document.getElementById("GADM");
    if (obj){ GADM=obj.value; }
	if (GADM!="") GADM = RegNoMask(GADM); 
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEGCashier"
			+"&GBIDesc="+iGBIDesc
			+"&AuditDateBegin="+iAuditDateBegin
			+"&AuditDateEnd="+iAuditDateEnd
			+"&GADM="+GADM
			;	
	location.href=lnk; 
}

//获取单位信息 单位名称
function SearchDHCPEGBaseInfo(value) {
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;
		obj=document.getElementById("GBI_Desc_Find");
		obj.value=aiList[0];
		
		//obj=document.getElementById("GBI_RowId_Find");
		//obj.value=aiList[2];
	}	
}
//获取单位信息 单位名称
function SearchSSUSR(value) {
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;
		//obj=document.getElementById("AuditUserDR_Name_Find");
		//obj.value=aiList[0];
		
		//obj=document.getElementById("AuditUserDR_Find");
		//obj.value=aiList[1];
	}	
}


function SelectRowHandler(){  

	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEGCashier');
	
	if (objtbl){ var rows=objtbl.rows.length; }
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	var rowid=""

	if (!selectrow) return;
	if (selectrow!=SelectedRow) {
		SelectedRow = selectrow;
		var obj=document.getElementById("TRowIdz"+selectrow); //GetCtlValueById("TRowIdz"+selectrow);
		if (obj){rowid=obj.value}
	}
	else{ SelectedRow=0; }
	RefreshPayAudit(rowid);
}

function RefreshPayAudit(rowid)
{
	var ret=tkMakeServerCall("web.DHCPE.CashierEx","ReCalAmt",rowid)
	var payflag=GetCtlValueById("PayedFlag");
	parent.frames["DHCPEPreAuditPay"].location.href='dhcpepreauditpay.csp?AppType=Fee&ADMType=G&CRMADM=&GIADM='+rowid+'&PayedFlag='+payflag;
	//parent.frames["DHCPEPreAuditPay"].location.href='dhcpepreauditpay.csp?AppType=Fee&ADMType=I&CRMADM=&GIADM='+rowid;
}
function LinkGFeeCat()
{
	var obj,iRowId
	if (SelectedRow==0) return;
	obj=document.getElementById("TCRMADMz"+SelectedRow);
	//var obj=document.getElementById("TRowIdz"+selectrow); 
	if (obj){ iRowId=obj.value; }
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEGroupFeeCat&GroupID="+iRowId;
	var wwidth=560;
	var wheight=300;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}
document.body.onload = BodyLoadHandler;
