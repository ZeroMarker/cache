///UDHCJFPAY.js
document.write("<object ID='ClsBillBarPrint' CLASSID='CLSID:C0A5396A-E7DC-4339-8A0E-634353ECDE4A' CODEBASE='../addins/client/BillBarPrint.CAB#version=1,0,0,0'>");
document.write("</object>");


var billinvnoobj,currentinvnoobj,balanceobj,depositlistobj,depositshowobj,depositsumobj;
var paymodeobj,bankobj,chequeobj,unitobj,accountobj,amounttopayobj,PayModeRowIDObj;
var admobj,billnoobj,payobj
var SelectedRow="-1",selectrow1;
var pay,BillNo,Adm,UserLoc,Guser,GuserCode,GuserName,currinvid,Sum
var payflag,pbflag
var tmpdep="",depositsum
var returnvalue,admreason
var PatInfo = new Array();
var AdmInfo = new Array();
var PayInfo = new Array();
var PatFeeInfo = new Array();
var InPatCate = new Array();
var InPatSubCate = new Array();
var catedata = new Array();
var path,gusercode,today
var ryyear,rymon,ryday,cyyear,cymon,cyday
var pattypeobj;
var pattype;
var ybaddobj;
var PayModeList;
var flag;
var ybgbflag  
var printinvno  
var banksubobj
var yklystr,prtrowid
var Handle="0",AdmReasonNationCode,AdmReasonId   
var IRetFlag=0  
var InsuPayM="N"
function BodyLoadHandler()
{    
   sfFocus(); //Lid 2010-03-10 为所有的INPUT标签元素添加事件 调用自UDHCJFormatF.js   
   ///DHCP_GetXMLConfig("InvPrintEncrypt","DHCJFIPReceipt");	   
      
   var BtnBillBarPrintObj=document.getElementById('btnBillBarPrt')
   if(BtnBillBarPrintObj){
		BtnBillBarPrintObj.onclick=BillBarPrint;   
	}
   
   
   getzyjfconfig();   
   Guser=session['LOGON.USERID'];
   UserLoc=session['LOGON.CTLOCID'];
   GuserCode=session["LOGON.USERCODE"];
   GuserName=session["LOGON.USERNAME"];
   admobj=document.getElementById('Adm');
   Adm=admobj.value
   billnoobj=document.getElementById('BillNo');
   BillNo=billnoobj.value
   payobj=document.getElementById('pay');
   pay=payobj.value	
   paymodeobj=document.getElementById('paymode');
   PayModeRowIDObj=document.getElementById('PayModeRowID');
   bankobj=document.getElementById('bank');
   banksubobj=document.getElementById('banksub');
   chequeobj=document.getElementById('cheque');
   unitobj=document.getElementById('unit');
   accountobj=document.getElementById('account');
   amounttopayobj=document.getElementById('amounttopay');
   if(amounttopayobj)amounttopayobj.onkeyup=amounttopayobj_onkeydowm; //CheckNumber;
   billinvnoobj=document.getElementById('billinvno');
   currentinvnoobj=document.getElementById('currentinvno');
   balanceobj=document.getElementById('balance');
   
   var Addobj=document.getElementById('Add');
   var Updateobj=document.getElementById('Update');
   var Deleteobj=document.getElementById('Delete');
   var Dischargeobj=document.getElementById('Discharge');
   var Printobj=document.getElementById('Print');
   var Abortobj=document.getElementById('Abort');
   var Closeobj=document.getElementById('Close');
   var PrintDetailobj=document.getElementById('PrintDetail');
   var payamountobj=document.getElementById('payamount');
   var printreceiptobj=document.getElementById('printreceipt');  //add 2008-03-25
   
   //depositshowobj=document.getElementById('depositshow');

   depositsumobj=document.getElementById('depositsum');
   alldeposit=depositsumobj.value
   //depositshowobj.onclick=depositshow
   //depositlistobj=document.getElementById('depositlist');
   //depositlistobj.style.visibility ='hidden'
   //depositlistobj.onchange=list_change;
   //depositlistobj.className="RowEven"
   
   Addobj.onclick=Add_click
   Deleteobj.onclick=Delete_click;
   Updateobj.onclick=Update_click;
   Dischargeobj.onclick=Discharge_click;
   Printobj.onclick=Print_click;
   Abortobj.onclick=Abort_click;
   Closeobj.onclick=Close_click;
   payamountobj.onkeyup=change;   
   PrintDetailobj.onclick=LinkBillDetail;
   printreceiptobj.onclick=Prt_FYQingDan;
   paymodeobj.onclick=paymode_click
   bankobj.readOnly=true;
  
   payflag=getpbstatus();
   
   if (payflag!="B") {
	   billinvnoobj.value=parent.opener.Tinvno;
   }
  
   depositsum=depositsumobj.value
   //listselected(); 
   
   //getpath();   path=tkMakeServerCall("web.UDHCJFTITMP","getpath")
   
   gettoday();
   
   pay=balanceobj.value
   amounttopayobj.value=pay
   if (pay<0)
   {   amounttopayobj.style.color="red"   }
   currentinvnoobj.readOnly=true;
   billinvnoobj.readOnly=true;
   balanceobj.readOnly=true;
   depositsumobj.readOnly=true;
  
   //paymodeobj.value=t['21']  ;yyx 注释,修改成按安全组取默认支付方式
   //yyx 2009-11-10 根据安全组取默认支付方式
   
   GetDefPayMode()
   
   //insert by cx 2006.05.23
   pattypeobj=document.getElementById('pattype');
   pattype=pattypeobj.value
   var ReaQualifStatus=tkMakeServerCall("web.UDHCJFBaseCommon","GetReaQualifStatus",BillNo)

   if ((!getcurrentinvno())&(ReaQualifStatus==0))
   {alert(t['01'])}
   
   getpatinfo()
   
   //调用医保接口,UDHCJFIPInsu
   //alert("判断是否走医保结算")
   var ReturnValue=Transybadd(Addobj,balanceobj,Updateobj,Deleteobj,Dischargeobj,Printobj,Abortobj,Guser,BillNo,Adm);
   
   if (ReturnValue<0)
   {   alert("医保结算失败.")
       return   
   }
   
   DHCWebD_SetStatusTip()  //insert by cx 2007.04.17
   
   //var printzplyobj=document.getElementById('printzply');		
   //if (printzplyobj) printzplyobj.onclick=Printykly
   //CortrolDepositList()
   CortrolAbortBtn()
   
   websys_setfocus('amounttopay');
}
function getpatinfo()
{	  
   var infro=document.getElementById('getpatinfo');
   if (infro) {var encmeth=infro.value}else {var encmeth=''};
   returnvalue=cspRunServerMethod(encmeth,"","",Adm)
   var sub = returnvalue.split("^")
   document.getElementById('papno').value=sub[7]
   document.getElementById('name').value=sub[0]
   document.getElementById('admdate').value=sub[1]
   document.getElementById('disdate').value=sub[12]
   admreason=sub[11]
   document.getElementById('patward').value=sub[3]
   document.getElementById('patzyno').value=sub[10]
   var EncryptLevelObj=document.getElementById('EncryptLevel')
	if(EncryptLevelObj){EncryptLevelObj.innerText=sub[14]}
	  var PatLevelObj=document.getElementById('PatLevel')
	  if(PatLevelObj){PatLevelObj.innerText=sub[15]}
	  var PrtLevelObj=document.getElementById('PrtLevel')
	  if(PrtLevelObj){PrtLevelObj.value=sub[16]}
   ///modify 2012-06-05 根据账单号取发票打印住院日期和出院日期
   if ((Adm=="")||(Adm==" ")){return;}
   if ((BillNo=="")||(BillNo==" ")){return;}
   var PBDateStr=tkMakeServerCall("web.UDHCJFBaseCommon","GetPatAdmInDays",Adm,BillNo);
   if (PBDateStr!=""){
      var PBDateStr1=PBDateStr.split("^");
      document.getElementById('PBDateFrom').value=PBDateStr1[0]
      document.getElementById('PBDateTo').value=PBDateStr1[1]
   }   
}

function gettoday() 
{
   var gettoday=document.getElementById('gettoday');
   if (gettoday) {var encmeth=gettoday.value} else {var encmeth=''};
   if (cspRunServerMethod(encmeth,'setdate_val','','')=='1'){};
}
function setdate_val(value)
{
   today=value;
}
function listselected()
{
   var num=depositlistobj.options.length
   for (i=0;i<num;i++)
   {   depositlistobj.options[i].selected=true;	}
}
function list_click()
{
   var row=depositlistobj.selectedIndex
   var selItem=obj.options[depositlistobj.selectedIndex];
}
function list_change()
{
   if (payflag=="P") {return;}
   var Objtbl=document.getElementById('tUDHCJFPAY');
   var Rows=Objtbl.rows.length;
   if (Rows>2) {return;}
   var num=depositlistobj.options.length
   var depamt=0,tmpamt=0
   tmpdep=""
   for (i=0;i<num;i++)
   {  if (depositlistobj.options[i].selected==true)
      {  var mydata = new Array();
         var str=depositlistobj.options[i].value
         mydata=str.split("^")
         tmpdep=tmpdep+"^"+mydata[5]
         depamt=eval(depamt)+eval(mydata[0])
      }		
   }
   depositsumobj.value=depamt.toFixed(2)
   tmpamt=eval(depositsum)-eval(depamt)
   pay=eval(tmpamt)+eval(payobj.value)
   pay=pay.toFixed(2)
   balanceobj.value=pay
   amounttopayobj.value=balanceobj.value
}
function depositshow()
{
   var Objtbl=document.getElementById('tUDHCJFPAY');
   var Rows=Objtbl.rows.length;
   if (Rows>2) {alert(t['02']);return;}
   if (depositshowobj.checked==false)
   {  depositlistobj.style.visibility ='hidden' }
   else
   {  depositlistobj.style.visibility ='visible'}
}
function Add_click()
{
   var ReaQualifStatus=tkMakeServerCall("web.UDHCJFBaseCommon","GetReaQualifStatus",BillNo)
   if (payflag=="P") {alert(t['03']);return;}
   if ((currentinvnoobj.value=="")&(ReaQualifStatus==0)){alert(t['11']);return;}
   //if (depositshowobj.checked==true) {alert(t['04']);return;}
   //if (balanceobj.value==0||amounttopayobj.value==0||amounttopayobj.value==""||paymodeobj.value=="") return false;
   if (amounttopayobj.value==""||paymodeobj.value=="") return false;
   var fban,fpay
   fban=Math.abs(balanceobj.value);
   fpay=Math.abs(amounttopayobj.value);
   if (SelectedRow>=0) return false;
   var reflag=document.getElementById('reflag').value
   if ((paymodeobj.value==t['jst02'])&&(reflag=="0")){
      var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFQfdetail&BillNo='+BillNo+'&Adm='+Adm
      window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0') 
      return;
   }
   Addtabrow();   
   var tmpamt=eval(balanceobj.value)-eval(amounttopayobj.value);  //*
   amounttopayobj.value=tmpamt.toFixed(2);    //*
   balanceobj.value=amounttopayobj.value;
}
function Addtabrow()
{
   var objtbl=document.getElementById('tUDHCJFPAY');
   tAddRow(objtbl);
   var rows=objtbl.rows.length;
   var LastRow=rows - 1;
   var Row=LastRow      
      
   //var rows=objtbl.rows.length;
   //var LastRow=rows - 1;
   //var Row=LastRow	  
   
   var Tpaymode=document.getElementById("Tpaymodez"+Row);   
   var Tbank=document.getElementById("Tbankz"+Row);   
   var Tcheque=document.getElementById("Tchequez"+Row);
   var Tunit=document.getElementById("Tunitz"+Row);
   var Taccount=document.getElementById("Taccountz"+Row);
   var Tamounttopay=document.getElementById("Tamounttopayz"+Row);
   var Tbanksub=document.getElementById("Tbanksubz"+Row);
   var TPayModeRowID=document.getElementById("TPayModeRowIDz"+Row);
   var TRetFalg=document.getElementById("TretFlagz"+Row);   //add by zhl 20111208
   ///mofidy 2014-06-06 增加医保支付方式标志
   var TInsuFlag=document.getElementById("TInsuFlagz"+Row);  
   
   Tpaymode.innerText=paymodeobj.value;   
   Tbank.innerText=bankobj.value;   
   Tcheque.innerText=chequeobj.value;   
   Tunit.innerText=unitobj.value;   
   Taccount.innerText=accountobj.value   
   Tamounttopay.innerText=amounttopayobj.value   
   Tbanksub.value=banksubobj.value   
   TPayModeRowID.innerText=PayModeRowIDObj.value
   var flagobj=document.getElementById("RetFlag")       //add by zhl 20111208
   if (flagobj.checked){TRetFalg.innerText="Y"} 
   else{TRetFalg.innerText="N"}
   ///mofidy 2014-06-06 增加医保支付方式标志/////////////////////////////////////////////////////////
   TInsuFlag.innerText=InsuPayM;
   
   if (InsuPayM=="Y"){
      var payAmt=payobj.value;
      var payAmtnew=eval(payAmt)-eval(Tamounttopay.innerText);
      payAmtnew=payAmtnew.toFixed(2);
      payobj.value=payAmtnew;   
   }
   ////////////////////////////////////////////////////////////////////////////////////////////////
   bankobj.value="";
   chequeobj.value="";
   unitobj.value="";
   accountobj.value="";
   banksubobj.value="";
   flagobj.checked=false;     
   GetDefPayMode();
}
function tAddRow(objtbl)
{
   tk_ResetRowItemst(objtbl);
   var row=objtbl.rows.length;
   var objlastrow=objtbl.rows[row-1];
   //make sure objtbl is the tbody element
   objtbl=websys_getParentElement(objlastrow);
   var objnewrow=objlastrow.cloneNode(true);
   var rowitems=objnewrow.all; //IE only
   if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
   for (var j=0;j<rowitems.length;j++) {
      if (rowitems[j].id) 
      {  var Id=rowitems[j].id;
         var arrId=Id.split("z");
         arrId[arrId.length-1]=row;
         rowitems[j].id=arrId.join("z");
         rowitems[j].name=arrId.join("z");
         rowitems[j].value="";
      }
   }
   objnewrow=objtbl.appendChild(objnewrow);
   if ((objnewrow.rowIndex)%2==0) 
   {objnewrow.className="RowOdd";} 
   else 
   {objnewrow.className="RowEven";}
}
function Delete_click()
{
   var objtbl=document.getElementById('tUDHCJFPAY');
   var rows=objtbl.rows.length;
   var lastrowindex=rows - 1;
   if (SelectedRow=="-1") return;
   if (lastrowindex==SelectedRow) return;
   var selectrow0=eval(SelectedRow)+1
   ///mofidy 2014-06-06 增加医保支付方式标志/////////////////////////////////////////////////////////
   var SelRowObj=document.getElementById('TInsuFlagz'+selectrow0);
   if ((SelRowObj)&&(SelRowObj.innerText=="Y")) {alert("医保支付方式不许删除");return}
   ////////////////////////////////////////////////////////////////////////////////////////////////////
   //insert by cx 2006.5.26/////////////////////////////////////////////////
   var SelRowObj=document.getElementById('Tpaymodez'+selectrow0);
   var pmname=SelRowObj.innerText;
   if (pmname==t['INSUPM05']){
      alert(t['INSUER03']);
      return;}
   if (pmname==t['INSUPM06']){
 	  alert(t['INSUER03']);
      return;}
   if (pmname==t['INSUPM07']){
      alert(t['INSUER03']);
      return;}
   if (pmname==t['INSUPM08']){
      alert(t['INSUER03']);
      return;}
	///////////////////////////////////////////////////////////////////////
   var SelRowObj=document.getElementById('Tamounttopayz'+selectrow0);
   var tmpamt=eval(balanceobj.value)+eval(SelRowObj.innerText);
   balanceobj.value=tmpamt.toFixed(2)
   objtbl.deleteRow(SelectedRow);
   tk_ResetRowItemst(objtbl);
   unselected();
}
function tk_ResetRowItemst(objtbl)
{
   for (var i=0;i<objtbl.rows.length; i++) {
      var objrow=objtbl.rows[i];
      if ((i+1)%2==0) {objrow.className="RowEven";} else {objrow.className="RowOdd";}
      var rowitems=objrow.all; //IE only
      if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
      for (var j=0;j<rowitems.length;j++) {
         if (rowitems[j].id) {
            var arrId=rowitems[j].id.split("z");
            arrId[arrId.length-1]=i+1;
            rowitems[j].id=arrId.join("z");
            rowitems[j].name=arrId.join("z");
         }
      }
   }
}
function Update_click()
{
   var objtbl=document.getElementById('tUDHCJFPAY');
   var rows=objtbl.rows.length;
   var lastrowindex=rows - 1;
   if (lastrowindex==SelectedRow) return;
   if (SelectedRow=="-1") return;
   var selectrow=eval(SelectedRow)+1
   ///mofidy 2014-06-06 增加医保支付方式标志/////////////////////////////////////////////////////////
   var SelRowObj=document.getElementById('TInsuFlagz'+selectrow);
   if ((SelRowObj)&&(SelRowObj.innerText=="Y")) {alert("医保支付方式不许修改");return}
   ////////////////////////////////////////////////////////////////////////////////////////////////////
   var SelRowObj=document.getElementById('Tamounttopayz'+selectrow);
   var amtabs=Math.abs(amounttopayobj.value)
   var selrowabs=Math.abs(SelRowObj.innerText)
   var banabs=Math.abs(balanceobj.value)
   if (eval(amtabs)-eval(selrowabs)>banabs) return false; 
   var tmpamt=eval(balanceobj.value)+eval(SelRowObj.innerText)-eval(amounttopayobj.value);
   balanceobj.value=tmpamt.toFixed(2)
   SelRowObj=document.getElementById('Tpaymodez'+selectrow);
   SelRowObj.innerText=paymodeobj.value;
   SelRowObj=document.getElementById('Tbankz'+selectrow);
   SelRowObj.innerText=bankobj.value;
   SelRowObj=document.getElementById('Tchequez'+selectrow);
   SelRowObj.innerText=chequeobj.value;
   SelRowObj=document.getElementById('Tunitz'+selectrow);
   SelRowObj.innerText=unitobj.value;
   SelRowObj=document.getElementById('Taccountz'+selectrow);
   SelRowObj.innerText=accountobj.value;
   SelRowObj=document.getElementById('Tamounttopayz'+selectrow);
   SelRowObj.innerText=amounttopayobj.value;	
}
function SelectRowHandler()	
{  
   var eSrc=window.event.srcElement;
   Objtbl=document.getElementById('tUDHCJFPAY');
   Rows=Objtbl.rows.length;
   var lastrowindex=Rows - 1;
   var RowObj=getRow(eSrc);
   var selectrow=RowObj.rowIndex;
   if (lastrowindex==selectrow){unselected();return;}
   if (selectrow!=SelectedRow) {
      var selectrow0=eval(selectrow)+1
      var SelRowObj=document.getElementById('Tpaymodez'+selectrow0);
      paymodeobj.value=SelRowObj.innerText;
      SelRowObj=document.getElementById('Tbankz'+selectrow0);
      bankobj.value=SelRowObj.innerText
      SelRowObj=document.getElementById('Tchequez'+selectrow0);
      chequeobj.value=SelRowObj.innerText
      SelRowObj=document.getElementById('Tunitz'+selectrow0);
      unitobj.value=SelRowObj.innerText
      SelRowObj=document.getElementById('Taccountz'+selectrow0);
      accountobj.value=SelRowObj.innerText;
      SelRowObj=document.getElementById('Tamounttopayz'+selectrow0);
      amounttopayobj.value=SelRowObj.innerText;
      SelRowObj=document.getElementById('TPayModeRowIDz'+selectrow0);
      PayModeRowIDObj.value=SelRowObj.innerText;
      
      SelectedRow = selectrow;
	}else
	{unselected(); }
}
function unselected()
{
   paymodeobj.value=t['21'];
   bankobj.value="";
   chequeobj.value="";
   unitobj.value="";
   accountobj.value="";
   PayModeRowIDObj.value=""
   amounttopayobj.value=balanceobj.value;
   GetDefPayMode()
   SelectedRow="-1";
}
function Discharge_click()
{  
   //test
   //PrintFP("3394")
   //return;
   //test
   /*
   if (PatFeeConfirmFlag=="Y")    //费用审核yyx
   {  var confirmflag=document.getElementById('getconfirmflag');
      if (confirmflag) {var encmeth=confirmflag.value} else {var encmeth=''};
      var retval=cspRunServerMethod(encmeth,Adm)
      var confirmflagstr=retval.split("^");
      if (confirmflagstr[1]=="N")
      {  alert(t['Confirm01']);
         return;
      }
   }
   
   var confirmflag=document.getElementById('getconfirmflag');
	if (confirmflag) {var encmeth=confirmflag.value} else {var encmeth=''};
	var retval=cspRunServerMethod(encmeth,Adm,BillNo)
	if (retval!="Y")
	{  
		alert(t['Confirm01']);
		return;
	}	
	*/   
   var ReaQualifStatus=tkMakeServerCall("web.UDHCJFBaseCommon","GetReaQualifStatus",BillNo)
   payflag=getpbstatus();
   if (payflag=="P") {alert(t['05']);return;}
   if ((currentinvnoobj.value=="")&(ReaQualifStatus==0)){alert(t['11']);return;}
    if (eval(balanceobj.value)!="0") 
   {  
      alert(t['06']);
      return;
   }
   var tmpstr=GetSum();
   //update by cx 2006.05.26
   var WshNetwork = new ActiveXObject("WScript.NetWork");
   var computername=WshNetwork.ComputerName;
   
   if (depositsum=="") {depositsum=0.00}
   if (isNaN(depositsum)){depositsum=0.00}
   var  depositsum1=depositsumobj.value
   if (depositsum1=="") {depositsum1=0.00}
   if (isNaN(depositsum1)){depositsum1=0.00}
   var depListObj=parent.frames["DHCIPBillDepList"]; 
   var SelectFlagobj=depListObj.document.getElementById('SelectFlag');
   var SelectFlag=SelectFlagobj.checked
   
   if (eval(depositsum)!=eval(depositsum1))
   {  var selecttrue=window.confirm(t['jst03'])
      if (!selecttrue) {   return  }
      var depflag="0"
   }else
   {  if (SelectFlag==true){
         var depflag="1"
         tmpdep=""
      }else{
	     var depflag="0"
	  }
   }
   var count=0,count1=0
   var qfstr=tmpstr.split("&")
   for (i=2;i<qfstr.length;i++)
   {  var qf=qfstr[i].split("^")
      if (qf[0]==t['jst02']) { count=count+1 }
      if (qf[0]!=t['jst02']) { count1=count1+1}      
   }
   if ((count>=1)&&(count1>=1)){
      alert(t['QF01']);
      return;
   }
   if (count>=1)
   {  var truthBeTold = window.confirm(t['jst01']);
      if (!truthBeTold) {return  }
   }    
   ///modify 2014-06-09 chenxi 获取需要结算的预交金金额传入结算程序中用于判断是否金额是否平///////////////
   var depListObj=parent.frames["DHCIPBillDepList"];

   var Objtbl=depListObj.document.getElementById('tDHCIPBillDepList'); 
   var Rows=Objtbl.rows.length;
   
   var PaybillDepositAmt=0.00;
   for (var i=1;i<Rows;i++){
      var TBillFlagobj=depListObj.document.getElementById("TBillFlagz"+i);      
      if (TBillFlagobj.checked==true){
	     var TDepAmtObj=depListObj.document.getElementById('TDepAmtz'+i);         
         var TDepAmt=TDepAmtObj.innerText;
         if ((TDepAmt=="")||(TDepAmt==" ")){
	        TDepAmt=0.00;
	     } 
	     if (isNaN(TDepAmt)){
		    TDepAmt=0.00;
		 }
		 PaybillDepositAmt=eval(PaybillDepositAmt)+eval(TDepAmt);
	  }
   }  
   ///alert("PaybillDepositAmt="+PaybillDepositAmt);
   ///alert("tmpdep="+tmpdep);
   var PatFee=document.getElementById('patfee').value  
   p1=BillNo+"&"+Guser+"&"+UserLoc+"&"+tmpdep+"&"+depflag+"&"+pay+"&"+Adm+"&"+computername+"&"+PatFee+"&"+depositsum+"&"+Sum+"&"+PaybillDepositAmt
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
   p2=tmpstr
   
   ///alert("p1="+p1)
   ///alert("tmpdep="+tmpdep)
   ///alert("tmpstr="+tmpstr)
   ///alert("depflag="+depflag)
   ///return;
   var getpaybillobj=document.getElementById('getpaybill');
   if (getpaybillobj) {var encmeth=getpaybillobj.value} else {var encmeth=''};
   var ren=cspRunServerMethod(encmeth,'','',p1,p2)
   ///alert("ren="+ren);
   if (ren>0)
   {  payflag="P"        
      if (pattype==t['INSUPatType']){ybgbflag="0" }   
      alert(t['08']);       
   }else {
	  if (ren==-2)
      {   alert("帐单金额不符,请重新生成帐单.") 
          return
      }
      if (ren==-3)
      {   alert("界面金额与实际账单金额不符,请重新刷新界面重新结算.")
          return
      }
      if (ren==-4)
      {   var selecttrue=window.confirm("要结算的预交金金额与实际的预交金金额不符是否结算?")
          if (!selecttrue) {   return  }
      }
      if (ren==-5)
      {   alert("支付的金额与实际要支付的金额不一致,不能结算")
          return
      }
      if (ren==-6)
      {   alert("账单已经结算,不允许结算.")
          return
      }
      alert(t['09']);
      return false;
   }
 
   Print_click()
   //自动打开交押金的界面
   LinkaddDeposit_click()
}
function getpbstatus()
{	   
   p1=BillNo
   var getpbstatusobj=document.getElementById('getpbstatus');
   if (getpbstatusobj) {var encmeth=getpbstatusobj.value} else {var encmeth=''};
   var ren=cspRunServerMethod(encmeth,'','',p1)
   return ren;
}
function GetSum()
{   
   var tempstr1,tempstr=""
   var payamt
   Sum=0;
   Objtbl=document.getElementById('tUDHCJFPAY');
   Rows=Objtbl.rows.length-1;
   for (i=2;i<=Rows;i++)
   {
	  var Tpaymode=document.getElementById("Tpaymodez"+i);
      var TPayModeID=document.getElementById("TPayModeRowIDz"+i);  //yyx 2009-11-10 修改成按支付方式rowid
      var Tbank=document.getElementById("Tbankz"+i);
      var Tbanksub=document.getElementById("Tbanksubz"+i);
      var Tcheque=document.getElementById("Tchequez"+i);
      var Tunit=document.getElementById("Tunitz"+i);
      var Taccount=document.getElementById("Taccountz"+i);
      var Tamounttopay=document.getElementById("Tamounttopayz"+i);
      var Tretflag=document.getElementById("TretFlagz"+i)             //add by  zhl 20111208  
      if (Tretflag.innerText=="Y") IRetFlag=1
      ///modify 2014-06-09 将医保标志也传进去////////////////////////////////////////////////////////
      var TInsuFlagobj=document.getElementById("TInsuFlagz"+i);
      var TInsuFlag=TInsuFlagobj.innerText;
      ///////////////////////////////////////////////////////////////////////////////////////////////
      
      payamt=Tamounttopay.innerText;
      Sum=eval(Sum)+eval(payamt);
	  tempstr1=TPayModeID.innerText+"^"+Tbank.innerText+"@"+Tbanksub.innerText+"^"+Tcheque.innerText+"^"+Tunit.innerText+"^"+Taccount.innerText+"^"+Tamounttopay.innerText+"^"+Tretflag.innerText+"^"+TInsuFlag+"^"+Tpaymode.innerText
	  tempstr=tempstr+"&"+tempstr1;
   }
   Sum=Sum.toFixed(2)
   tempstr="&"+pay+tempstr;
   return tempstr;
}

function GetSumOLD()
{   
   var tempstr1,tempstr=""
   var payamt
   Sum=0;
   Objtbl=document.getElementById('tUDHCJFPAY');
   Rows=Objtbl.rows.length-1;
   for (i=2;i<=Rows;i++)
   {  //var Tpaymode=document.getElementById("Tpaymodez"+i);
      var TPayModeID=document.getElementById("TPayModeRowIDz"+i);  //yyx 2009-11-10 修改成按支付方式rowid
      var Tbank=document.getElementById("Tbankz"+i);
      var Tbanksub=document.getElementById("Tbanksubz"+i);
      var Tcheque=document.getElementById("Tchequez"+i);
      var Tunit=document.getElementById("Tunitz"+i);
      var Taccount=document.getElementById("Taccountz"+i);
      var Tamounttopay=document.getElementById("Tamounttopayz"+i);
      payamt=Tamounttopay.innerText;
      Sum=eval(Sum)+eval(payamt);
	  tempstr1=TPayModeID.innerText+"^"+Tbank.innerText+"@"+Tbanksub.innerText+"^"+Tcheque.innerText+"^"+Tunit.innerText+"^"+Taccount.innerText+"^"+Tamounttopay.innerText
	  tempstr=tempstr+"&"+tempstr1;
   }
   Sum=Sum.toFixed(2)
   tempstr="&"+pay+tempstr;
   return tempstr;
}
function Print_click()
{  
   
   ///获取打印模板
   GetXMLName();
   var ReaQualifStatus=tkMakeServerCall("web.UDHCJFBaseCommon","GetReaQualifStatus",BillNo)
   var qfcount=getqfnum()
   var prtmoreflag1="N"
   if (payflag!="P") {alert(t['10']);return;}
  
   if ((currentinvnoobj.value=="")&(ReaQualifStatus==0)){alert(t['11']);return;}
   pbflag=getpbflag();
   var curtinvnotobj=document.getElementById("currentinvnotitle");    ///modify 2010-02-19 发票打印时增加发票首字母
   if (pbflag=="Y"){
      p1=BillNo
      var getinvprtzyrowid=document.getElementById('getinvprtzyrowid');
      if (getinvprtzyrowid) {var encmeth=getinvprtzyrowid.value} else {var encmeth=''};
      var ren=cspRunServerMethod(encmeth,'','',p1)
 	  var renstr=ren.split("^"); 
	  if (renstr[1]!="Y"){
	     alert(t['12']);return;}
	  else{
	     prtrowid=renstr[0]
	     var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFInvprtzySub&Adm='+Adm+'&BillNo='+BillNo+'&prtrowid='+prtrowid
         window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=650,left=0,top=0')   
	     return;
	  }      
   }	     
 
   if (pbflag=="N"){ 
      if (PrtFpMoreFlag=="Y"){
         if (QFPrtFPFlag=="Y"){
            if (qfcount==0){
               //var truthBeTold = window.confirm(t['PrtMoreFlag01']);
              // if (!truthBeTold) {
	          //    prtmoreflag1="Y"          
	          // }else{
                  prtmoreflag1="N"    
	          // }
            }else{
	           prtmoreflag1="N"   
	        }        
         }else{
            prtmoreflag1="N"    
	     }      
   }    
   
   var computerName=GetComputerName(); //Lid 2010-03-22 获取计算机名?UDHCJFFormat.js 
   ///modify 2011-02-19 增加发票首字母功能
   var curtinvnot=curtinvnotobj.value
   var PBDateFrom=document.getElementById('PBDateFrom').value
   var PBDateTo=document.getElementById('PBDateTo').value      
   p1=currentinvnoobj.value+"&"+curtinvnot+"^"+Guser+"^"+BillNo+"^"+t['23']+"^"+currinvid+"^"+"Y"+"^"+Adm+"^"+prtmoreflag1+"^"+QFPrtFPFlag+"^"+qfcount+"^"+computerName+"^"+PBDateFrom+"^"+PBDateTo
   printinvno=currentinvnoobj.value		
   var getsavetoinvprt=document.getElementById('getsavetoinvprt');
   if (getsavetoinvprt) {var encmeth=getsavetoinvprt.value} else {var encmeth=''};
   var ren=cspRunServerMethod(encmeth,'','',p1)	
  
   if (!ren) {alert(t['13']);return;}
   if (ren=="INV") {alert(t['18']);return;}
   if (ren=="STRIKEINV") {alert("已经取消结算不能打印收据,请重新结算");return;}
   var val=ren.split("^")
  
   if (val[4]!=0)
   {
	   alert("保存发票失败.")
	   return
   }
   prtrowid=val[3]	//wanghc 测试发现这个位置向后走了一位 val[2]->val[3]
   if (val[0]==""){
      billinvnoobj.value=curtinvnotobj.value+""+currentinvnoobj.value;    ///mdodify 2011-02-19 增加发票首字母
      currentinvnoobj.value="";
      curtinvnotobj.value=""                                             ///mdodify 2011-02-19 增加发票首字母
      printinvno=billinvnoobj.value
      currinvid="";
      //alert(t['16']);
   }else{
      if (prtmoreflag1=="N"){
          billinvnoobj.value=curtinvnotobj.value+""+currentinvnoobj.value   ///mdodify 2011-02-19 增加发票首字母
       };
      if (prtmoreflag1=="Y"){
         billinvnoobj.value=""};
      if (QFPrtFPFlag=="N"){ 
         var qfcount=getqfnum()
         if (qfcount>0){
            billinvnoobj.value=""}
      }    
      printinvno=billinvnoobj.value
      currinvid=val[1];
      currentinvnoobj.value=val[0]
      curtinvnotobj.value=val[2]                                            ///mdodify 2011-02-19 增加发票首字母
   }		
   if (prtmoreflag1=="N"){       
      if(val[5]>0) return;  //医保患者不打发票 （发票号为空）  
      if ((QFPrtFPFlag=="N")&&(qfcount==0)){	     
	     PrintFP(prtrowid+"#"+"");    
	  }
      if (QFPrtFPFlag=="Y"){ 
         PrintFP(prtrowid+"#"+"");
      }
   }
   //alert(11)
   if ((prtmoreflag1=="Y")&&(prtrowid!="")){
     var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFInvprtzySub&Adm='+Adm+'&BillNo='+BillNo+'&prtrowid='+prtrowid
     window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=650,left=0,top=0')
   }
   }
    CortrolAbortBtn()      
}
function getpath() 
{
   var getpath=document.getElementById('getpath');
   if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
   path=cspRunServerMethod(encmeth,'','')
}
function getpbflag() 
{
   p1=BillNo
   var getpbflagobj=document.getElementById('getpbflag');
   if (getpbflagobj) {var encmeth=getpbflagobj.value} else {var encmeth=''};
   var ren=cspRunServerMethod(encmeth,'','',p1)
   return ren;
}
function Abort_click()
{  var curinvno=billinvnoobj.value
   var curno=currentinvnoobj.value
   var abortflag,abourtflag1   
   abortflag="0" ,abortflag1="0"
   
   if((curinvno=="")||(curinvno==" ")){abortflag="1"}    
   if((curno=="")||(curno==" ")){abortflag1="1"}
   if ((abortflag=="0")&&(abortflag1=="0"))
   {   
      //abortnum=#server(web.DHCJFINVMAG.Abort(form1.textfield1.value,form1.textfield3.value,bill,user))#;
      p1=billinvnoobj.value+"^"+currentinvnoobj.value+"^"+BillNo+"^"+Guser
      var getabort=document.getElementById('getabort');
      if (getabort) {var encmeth=getabort.value} else {var encmeth=''};
      var abortnum=cspRunServerMethod(encmeth,'','',p1)
      if (abortnum=="1")  {   alert(t['17']);return;}
      if (abortnum=="2")  {alert(t['Abort02']);return;}
      if (abortnum=="3")  {alert(t['Abort01']);return;}
      if (abortnum=="4")  {alert(t['Abort01']);return;}
      if (abortnum=="0")
      {  billinvnoobj.value="";
         alert(t['14'])
         if ((AbortFpprtFlag=="Y")&&(PrtFpMoreFlag=="N"))  { Print_click()}   
      }else
      {alert(t['15'])}			
   }
   
}
function Close_click()
{	
   var kbzclass=document.getElementById('KPaybzclass');
   if (kbzclass) {var encmeth=kbzclass.value} else {var encmeth=''};
   
   var kbzclassbz=cspRunServerMethod(encmeth,Adm,BillNo)
   top.close();
   /*top.opener.document.getElementById("Regno").value="";
   top.opener.document.getElementById("patmedicare").value="";
    top.opener.document.getElementById("Adm").value="";
   top.opener.document.getElementById("BillNo").value="";
   top.opener.Find_click();*/
   //top.opener.clearall();
   //top.opener.location.reload();
   //location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFCASHIER";
}
function BodyunLoadHandler()
{
   
   var kbzclass=document.getElementById('KPaybzclass');
   if (kbzclass) {var encmeth=kbzclass.value} else {var encmeth=''};
   alert(Adm)
   var kbzclassbz=cspRunServerMethod(encmeth,Adm,BillNo)
   top.close();
   //top.opener.location.reload();
}
function change()
{
   CheckNumber2(this)
   var payamountobj=document.getElementById('payamount');
   var changeobj=document.getElementById('change');
   var num=payamountobj.value;
   if ((num=="")||(num=="-")) 
   {  changeobj.value="";
      return;    }
   else
   {  var tmpamt=eval(num)-eval(pay);
      changeobj.value=tmpamt.toFixed(2);
   }
}
function amounttopayobj_onkeydowm(){
	CheckNumber2(this);
	var key=event.keyCode;
	if(key===13){
		websys_setfocus('Add');
	}	
}
function getpaymodeid(value)
{
   var val=value.split("^");
   var obj=document.getElementById('paymodeid');
   obj.value=val[1];
}
function getbankid(value)
{
   var val=value.split("^");
   var obj=document.getElementById('bankid');
   obj.value=val[1];
}
//yyx2009-03-02
function getcurrentinvno() 
{
   var computerName=GetComputerName(); //Lid 2010-03-22 获取计算机名?UDHCJFFormat.js
   var p1=Guser,InsType=pattypeobj.value   //增加收费类别取发票类型按照
   var getcurrinvobj=document.getElementById('getcurrinv');
   if (getcurrinvobj) {var encmeth=getcurrinvobj.value} else {var encmeth=''};
 
   if (cspRunServerMethod(encmeth,'setinvno_val','',p1,InsType)=='1')
   {   return true;}
   else {return false;}
}
function setinvno_val(value)
{
   var val=value.split("^")
   currentinvnoobj.value=val[0];
   currinvid=val[1];
   var curtinvnotobj=document.getElementById("currentinvnotitle")     ///mdodify 2011-02-19 增加发票首字母
   curtinvnotobj.value=val[3];                                        ///mdodify 2011-02-19 增加发票首字母
}
function LinkBillDetail()
{
   if (BillNo=="") {alert("BillNo is Null");return;}
   var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetail&BillNo='+BillNo
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
}
//yyx2007-3-26
function paymode_click()
{ 
   if ((paymodeobj.value==t['24'])||(paymodeobj.value==t['jstzply']))
   {  var infro=document.getElementById('getzpinfo');
	  if (infro) {var encmeth=infro.value}else {var encmeth=''};
	  var returnvalue=cspRunServerMethod(encmeth,Adm)
	  var sub=returnvalue.split("^")
	  //bank_"^"_bankid_"^"_cardno_"^"_company_"^"_authno
	  bankobj.value=sub[0]
	  chequeobj.value=sub[2];
	  unitobj.value=sub[3]
	  accountobj.value=sub[4]
	  document.getElementById('bankid').value=sub[1]
	  document.getElementById('banksub').value=sub[5]
   }
}
function CortrolDepositList()
{
   
   if (SelYjPaylFlag=="Y"){
      depositshowobj.style.visibility ='visible'
      var obj=document.getElementById('cdepositshow');
      obj.style.visibility ='visible'
   }
   if (SelYjPaylFlag=="N"){
      depositshowobj.style.visibility ='hidden'
      var obj=document.getElementById('cdepositshow');
      obj.style.visibility ='hidden'
   }  	
}
function CortrolAbortBtn()
{
   var Abortobj=document.getElementById('Abort');
   var curinvno=billinvnoobj.value
   if((curinvno=="")||(curinvno==" "))
   {
      Abortobj.disabled=true; 
      Abortobj.onclick=""           	   
   }else{
      Abortobj.disabled=false; 
      Abortobj.onclick=Abort_click   
   }   	
}
function getqfnum(){
   var tmpstr=GetSum();
   var count=0
   var qfstr=tmpstr.split("&")
   for (i=2;i<qfstr.length;i++)
   {
	   var qf=qfstr[i].split("^")
	   qf[8]=qf[8].replace(/(^\s*)|(\s*$)/g,'')
		if (qf[8]==t['jst02']) { count=count+1 }      
   }
   return count    
}
//yyx 2009-11-10 根据安全组取支付方式和支付方式rowid
function GetDefPayMode()
{  
   var UserGrp=session['LOGON.GROUPID']
   var GetPayModeObj=document.getElementById('GetDefPayMode');
   if (GetPayModeObj) {var encmeth=GetPayModeObj.value}else {var encmeth=''};
   var PayModeInfo=cspRunServerMethod(encmeth,UserGrp)
   PayModeInfo=PayModeInfo.split("^")
   DHCWebD_SetObjValueA("paymode",PayModeInfo[1])
   DHCWebD_SetObjValueA("PayModeRowID",PayModeInfo[0])   
}
//yyx 2009-11-10 选择支付方式时?修改PayModeRowID中的支付方式
function SetPayModeID(Value)
{   var SelPayModeInfo=Value.split("^")
    DHCWebD_SetObjValueA("PayModeRowID",SelPayModeInfo[1])
	
}
function GetAdmReaNationCodeByAdm(Adm)
{
   ///var GetReasonByAdmObj=document.getElementById('GetReaNationCode');
   
   var GetReasonByAdmObj=document.getElementById('GetAdmReaNationCode');
   if (GetReasonByAdmObj) {var encmeth=GetReasonByAdmObj.value}else {var encmeth=''};
   var GetAdmReasonStr=cspRunServerMethod(encmeth,Adm)
   var GetAdmReasonStrDetail=GetAdmReasonStr.split("^")
   AdmReasonId=GetAdmReasonStrDetail[0]
   AdmReasonNationCode=GetAdmReasonStrDetail[1]
   
}
function GetPatDepType()
{
   var p1=Adm
   var getdepositobj=document.getElementById('getdeposittype');
   if (getdepositobj) {var encmeth=getdepositobj.value} else {var encmeth=''};
   var retvalue=cspRunServerMethod(encmeth,p1)
   if (retvalue=="Y"){alert("请核对自费器械收费!")}	
}
function CheckPaySumByAdm(Adm,Bill){
   if ((Adm=="")||(Bill==""))   return;
   var CheckPaySumobj=document.getElementById('CheckPaySumByAdm');
   if (CheckPaySumobj) {var encmeth=CheckPaySumobj.value} else {var encmeth=''};
   var retvalue=cspRunServerMethod(encmeth,Adm,Bill)
   retvalue=retvalue.split("^")
   var obj=document.getElementById('paymode')
   if (obj)   obj.value=retvalue[1]
   var obj=document.getElementById('account')
   if (obj)   obj.value=retvalue[0]
   Add_click();

	}
//自动打开交押金的界面
function LinkaddDeposit_click(){
	if (IRetFlag==0)  return  ;
	var Adm=admobj.value
	if (Adm=="") {alert("就诊不能为空.");return}
    var PayAmt=tkMakeServerCall("web.UDHCJFBaseCommon","GetTDepositByPaid",prtrowid);
	if (eval(PayAmt)==0)
	{   return
	}
	PayAmt=0-PayAmt
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDeposit&Adm='+Adm+'&deposittype='+"住院押金"+'&payamt='+PayAmt+'&transferflag=Y'
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=700,left=0,top=0')
}
function GetXMLName()
{
   if ((Adm=="")||(BillNo==""))   return;   
   GetAdmReaNationCodeByAdm(Adm)   
   var XMLName=tkMakeServerCall("web.UDHCJFBaseCommon","GetInvXMLName",AdmReasonId);   
   if (XMLName==""){
      DHCP_GetXMLConfig("InvPrintEncrypt","DHCJFIPReceipt");		   
   }else{
      DHCP_GetXMLConfig("InvPrintEncrypt",XMLName);	   
   }	
}
function TestYbAdd()
{
   paymodeobj.value="医保基金支付"; 	//和CT_PayMode表里的支付方式的描述一样
   amounttopayobj.value=600;
   PayModeRowIDObj.value=6;
   InsuPayM="Y";   
   Addtabrow();	
   var insuzfamt=1866.54
   amounttopayobj.value=eval(eval(insuzfamt)-depositsumobj.value)   //医保返回的现金支付-预交金	
   amounttopayobj.value=eval(amounttopayobj.value).toFixed(2).toString(10)
   balanceobj.value=amounttopayobj.value;
   paymodeobj.value="现金";
   PayModeRowIDObj.value="1"   //add 2012-02-10
   tmppay=amounttopayobj.value
   AddDivideFlag=true;
   if (tmppay>0)
   { 
      balanceobj.style.color="red";
   }	
   InsuPayM="N"   //add 2012-02-04  at xh
}

function BillBarPrint(){
	alert(BillNo);
	if(BillBarPrint){
		var bill=BillNo;
		
		var papno=document.getElementById('papno').value;
		var name=document.getElementById('name').value;	
		alert(BillNo);
		alert(papno);
		alert(name);
		ClsBillBarPrint.PrintWirst(papno,name,bill,"pdfFactory Pro");                  
	}
}

document.body.onload = BodyLoadHandler;
document.body.onunload = BodyunLoadHandler;