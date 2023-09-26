///DHCOPBillAliBalanceAcount.js
var Guser,GuserCode
var SelectedRow="-1";
function BodyLoadHandler() 
{
    Guser=session['LOGON.USERID']
	GuserCode=session["LOGON.USERCODE"];
    var ReadYJTReportobj=document.getElementById("ReadYJTReport")        
	if (ReadYJTReportobj) ReadYJTReportobj.onclick=YJTReport_Click;	
	var ReadHisTradeobj=document.getElementById("ReadHisTrade")        
	if (ReadHisTradeobj) ReadHisTradeobj.onclick=HisTrade_Click;	
}
function YJTReport_Click()
{
    var StDateobj =document.getElementById("StDate");
   if (StDateobj) {StDate=StDateobj.value}
   var EndDateobj =document.getElementById("EndDate");
   if (EndDateobj) {EndDate=EndDateobj.value}  
   var jobobj=document.getElementById("job")
   var job=jobobj.value 
   if ((Guser=="")||(Guser==" ")){
      alert("操作员不能为空!!");
	  return;
   }
   var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillAliTradeDetail&Guser=" +Guser+"&job=" +job+"&EndDate=" +EndDate+"&StDate="+StDate
   var NewWin=open(lnk,"DHCOPBIllPOSTradeDetail","scrollbars=no,resizable=no,top=50,left=50,width=1000,height=800");
}
function HisTrade_Click()
{
   var StDate="",EndDate=""
   var StDateobj =document.getElementById("StDate");
   if (StDateobj) {StDate=StDateobj.value}
   var EndDateobj =document.getElementById("EndDate");
   if (EndDateobj) {EndDate=EndDateobj.value}  
   var jobobj=document.getElementById("job")
   var job=jobobj.value 
   if ((Guser=="")||(Guser==" ")){
      alert("操作员不能为空!!");
	  return;
   }
   var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillAliHisTradeDetail&StDate="+StDate+"&EndDate=" +EndDate+"&Guser=" +Guser+"&job=" +job
   var NewWin=open(lnk,"DHCOPBillPOSHisTradeDetail","scrollbars=no,resizable=no,top=50,left=50,width=1000,height=800");
}
function SelectRowHandler()	
{   
   var eSrc=window.event.srcElement;
   var rowobj=getRow(eSrc)
   var Objtbl=document.getElementById('tDHCOPBillAliBalanceAcount');
   var Rows=Objtbl.rows.length;
   var lastrowindex=Rows - 1;
   var rowObj=getRow(eSrc);
   var selectrow=rowObj.rowIndex;
   if (!selectrow) return;
   var TradeRowidobj=document.getElementById("TradeRowid");
   if (selectrow!=SelectedRow) {      
	  var SelRowObj=document.getElementById('TTradeRowidz'+selectrow);
	  var TTradeRowid=SelRowObj.innerText;
	  TradeRowidobj.value=TTradeRowid	  
	  SelectedRow = selectrow;
   }
   else{      
      TradeRowidobj.value=""
	  SelectedRow="-1";      
   }   
}
document.body.onload = BodyLoadHandler;	