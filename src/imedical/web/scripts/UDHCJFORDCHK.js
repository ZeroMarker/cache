		var Adm
		var Guser
		var RegNo
		var guserobj;
		var regnoobj;
		var nameobj;
		var admobj;
		var depositobj;
		var amountobj;
		var balanceobj;
		var ordcatobj;
		var orderobj;
		var reclocobj;
		var billobj;
		var clearobj;
		var notpaidobj;
		var selectdateobj;
		var dateobj;
		var getnotpaidobj;
		var getseldateobj;
		var findobj;
		var doclocobj;
		var printdetailobj;
		var selstatusobj;
		var getstatusobj;
		var path
		var PatMedicareObj
function BodyLoadHandler() {
	
	regnoobj=document.getElementById('RegNo');
	nameobj=document.getElementById('name');
	//admobj=document.getElementById('Adm');
	admobj=document.getElementById('EpisodeID');
	depositobj=document.getElementById('deposit');
	amountobj=document.getElementById('amount');
	balanceobj=document.getElementById('balance');
	ordcatobj=document.getElementById('ordcat');
	orderobj=document.getElementById('order');
	reclocobj=document.getElementById('recloc');
	doclocobj=document.getElementById('docloc');
	billobj=document.getElementById('Bill');
	clearobj=document.getElementById('Clear');
	notpaidobj=document.getElementById('notpaid');
	selectdateobj=document.getElementById('seldate');
	getnotpaidobj=document.getElementById('getnotpaid');
	getseldateobj=document.getElementById('getseldate');
	dateobj=document.getElementById('date');
	guserobj=document.getElementById('Guser');
	findobj=document.getElementById('Find');
	printdetailobj=document.getElementById('printdetail');
    selstatusobj=document.getElementById('selstatus');
    getstatusobj=document.getElementById('getstatus');
    var PrtOrdDetailobj=document.getElementById('PrtOrdDetail');
    if (PrtOrdDetailobj) PrtOrdDetailobj.onclick=PrtOrdDetail_click;
    PatMedicareObj=document.getElementById('PatMedicare');
    if (PatMedicareObj) {  PatMedicareObj.onkeydown=getpat  };
    Guser=guserobj.value
	regnoobj.onkeydown = getpat;
	
	clearobj.onclick=clearall;
	notpaidobj.onclick=getnotpaidfun;
	selectdateobj.onclick=getseldatefun;
	billobj.onclick=bill;
	findobj.onclick=Find;
	printdetailobj.onclick=Print;
	ordcatobj.onkeyup=clearordcatid;
	orderobj.onkeyup=clearorderid;
	reclocobj.onkeyup=clearreclocid;
	doclocobj.onkeyup=cleardoclocid;
	depositobj.readOnly=true;
	amountobj.readOnly=true;
	balanceobj.readOnly=true;
	selstatusobj.onclick=selstatusfun;
	
	//notpaidobj.checked=true;
	//getnotpaidobj.value="0";
	//getseldateobj.value="0";
	if (getnotpaidobj.value=="0") {notpaidobj.checked=true;}
	if (getnotpaidobj.value=="1") {notpaidobj.checked=false;}
	if (getseldateobj.value=="0") {selectdateobj.checked=false;}
	if (getseldateobj.value=="1") {selectdateobj.checked=true;}
	if (doclocobj.value=="") {cleardoclocid();}
	if (getstatusobj.value=="0") {selstatusobj.checked=true;}
	if (getstatusobj.value=="1") {selstatusobj.checked=false;}
	//alert(selstatusobj.value)
	//insert by cx 2006.05.26
	getstatusobj.value="1"
	orderobj.onkeydown=orderlook;
	ordcatobj.onkeydown=ordercatlook;
	reclocobj.onkeydown=recloclook;
	doclocobj.onkeydown=docloclook;
	
	if (regnoobj.value!=""){
	   p1=regnoobj.value
	   var getregno=document.getElementById('getregno');
	   if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
	   if (cspRunServerMethod(encmeth,'setpat_val','',p1)=='1'){
	   };
	}
	
	getpath();
	
	var readcard=document.getElementById('readcard');
    if (readcard) readcard.onclick=readcard_click; 
    var obj=document.getElementById('OPCardType');
    if (obj){
	   obj.size=1
	   obj.multiple=false;
	   loadCardType()
	   obj.onchange=OPCardType_OnChange;
	}
    var obj=document.getElementById('opcardno');
    if (obj) obj.onkeydown = CardNoKeydownHandler;	
	websys_setfocus('RegNo');
	
}
function Find()
{   
  Find_click()
}
function getnotpaidfun()
{
	if (notpaidobj.checked==true) 
	{getnotpaidobj.value="0"}
	else
	{getnotpaidobj.value="1"}
	}
function getseldatefun()
{
	if (selectdateobj.checked==true) 
	{getseldateobj.value="1"}
	else
	{getseldateobj.value="0"}
	
	}
function clearordcatid()
{
	var obj=document.getElementById('getordcatid');
	obj.value="";
	}
function clearorderid()
{
	var obj=document.getElementById('getorderid');
	obj.value="";
	}
function clearreclocid()
{
	var obj=document.getElementById('getreclocid');
	obj.value="";
	}
function cleardoclocid()
{
	var obj=document.getElementById('getdoclocid');
	obj.value="";
	}
function clearall()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFORDCHK";
	notpaidobj.checked=true;
	}
function bill() {		
		if (admobj.value==""){alert("请选择病人就诊信息"); return;}
		Adm=admobj.value
		if (Adm&&Adm!=""){
			var WshNetwork = new ActiveXObject("WScript.NetWork");
			var computername=WshNetwork.ComputerName;
			//var computername="DHC666"
			p1=Adm;	
			var getmother=document.getElementById('getmotheradm');
			if (getmother) {var encmeth=getmother.value} else {var encmeth=''};
		   
		    if (cspRunServerMethod(encmeth,p1)=='true'){
					alert(t['03']);
					return;
				}
			p2=Guser;
			p3="";
			p4=computername;
			var getbill=document.getElementById('getbill');
			if (getbill) {var encmeth=getbill.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'','',p1,p2,p3,p4)=='0'){
					alert(t['01']);
				}
				else
				{alert(t['02']);}
			}
			Find_click()
			//window.location.reload();
			if (regnoobj.value!=""){
			   p1=regnoobj.value
			   var getregno=document.getElementById('getregno');
			   if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				   if (cspRunServerMethod(encmeth,'setpat_val','',p1)=='1'){
				   };
			}
	}
function getpat() {
	var key=websys_getKey(e);
	if (key==13) {
		
		if ((regnoobj.value!="")||(PatMedicareObj.value!="")){
			p1=regnoobj.value
			var PatMedicare=document.getElementById('PatMedicare').value  //yyx 2009-06-17
			//p2=getnotpaidobj.value
			var getregno=document.getElementById('getregno');
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setpat_val','',p1,PatMedicare)==""){
					alert("此病人信息不存在.")
				};
			
			}
		//	notpaidobj.checked=true;
			
		}
	}
function setpat_val(value)
	{
		var val=value.split("^");
		regnoobj.value=val[0];
		nameobj.value=val[1];
		admobj.value=val[2];
		Adm=admobj.value
		depositobj.value=val[3];
		amountobj.value=val[4];
		balanceobj.value=val[5];
		PatMedicareObj.value=val[6]
		
		//取医保押金自费押金医保费用自费费用医保余额自付余额
	    GetPatDepositFeeInfo(Adm)
		
		}
function getpayinfo()
{
	if (admobj.value=="") return;
	p1=admobj.value
	var obj=document.getElementById('getpayinfo');
			if (obj) {var encmeth=obj.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setpayinfo','',p1)=='1'){
				};
	}
function setpayinfo(value)
{
	var val=value.split("^");
	depositobj.value=val[0];
	amountobj.value=val[1];
	balanceobj.value=val[2];
	}
function getordcatid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('getordcatid');
	obj.value=val[1];

}
function getorderid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('getorderid');
	obj.value=val[1];

}
function getreclocid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('getreclocid');
	obj.value=val[1];

}
function getdoclocid(value)	{
	var val=value.split("^");
	var obj=document.getElementById('getdoclocid');
	obj.value=val[1];

}

function Print()
{ if (admobj.value==""){alert("请选择病人就诊信息"); return;}
	Adm=admobj.value
  var getnum=document.getElementById('getbillnum'); 
  if (getnum) {var encmeth=getnum.value} else {var encmeth=''};
  var str=cspRunServerMethod(encmeth,Adm)
  str=str.split("^")
  num=str[0]
  var BillNo=str[1]
  if (num==1)
  { 
    if (BillNo=="") {alert("BillNo is Null");return;}
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetail&BillNo='+BillNo
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
  }
  if (num>1)
  {	
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFPatBill&Adm='+Adm
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=780,height=520,left=0,top=0')
  }
}
 function selstatusfun()
{
	if (selstatusobj.checked==true) 
	{getstatusobj.value="0"}
	else
	{getstatusobj.value="1"}
	} 
function orderlook()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  order_lookuphandler();
		}

	}
function ordercatlook()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  ordcat_lookuphandler();
		}
	}
function recloclook()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  recloc_lookuphandler();
		}
	}
function docloclook()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  docloc_lookuphandler();
		}
}
function PrtOrdDetail_click()
{
   var Objtbl=document.getElementById('tUDHCJFORDCHK');
   var Rows=Objtbl.rows.length;
   if (eval(Rows)<3){ return;  }
   var SelRowObj=document.getElementById('Tjobz'+1);   
   var job=SelRowObj.innerText;
   var GetPrtOrdDetailNumobj=document.getElementById("GetPrtDetailNum");
   if (GetPrtOrdDetailNumobj) {var encmeth=GetPrtOrdDetailNumobj.value} else {var encmeth=''};
   var PrtOrdDetailNum=cspRunServerMethod(encmeth,job)
   PrtOrdDetail(job,PrtOrdDetailNum);	
      	
}
function UnloadHandler()
{
   var Objtbl=document.getElementById('tUDHCJFORDCHK');
   var Rows=Objtbl.rows.length;
   if (eval(Rows)<3){ return;  }
   var SelRowObj=document.getElementById('Tjobz'+1);
   
   var job=SelRowObj.innerText;
   var KillTMPPrtGlbobj=document.getElementById("KillTMPGlobe");
   if (KillTMPPrtGlbobj) {var encmeth=KillTMPPrtGlbobj.value} else {var encmeth=''};
   var mytmp=cspRunServerMethod(encmeth,job)	
}
function ListPrtOrdDetail(job,PrtNum)
{   var GetPrtOrdDetailobj=document.getElementById('GetPrtOrdDetail');
	if (GetPrtOrdDetailobj) {var encmeth=GetPrtOrdDetailobj.value} else {var encmeth=''};
	var PrtDetailInfo=cspRunServerMethod(encmeth,job,PrtNum)
	return PrtDetailInfo
}
function getpath() 
{
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};
	path=cspRunServerMethod(encmeth,'','')
}
///Lid
///2009-05-25
///医嘱数量调整事件
function link_upqty(){
	
	Adm=admobj.value
	/*
	var wardobj=document.getElementById('ward');
	if (wardobj) {var encmeth=wardobj.value} else {var encmeth=''};
    var ward=cspRunServerMethod(encmeth,WardLoc)
	var qxflag=document.getElementById('qxflag').value
	*/
	if (Adm=="") {alert(t['07']);return;}
	if (qty=="0"){alert(t['05']);return;}
	//if ((ward!=deploc)&(qxflag!="A")&(deploc!="营养部")){alert(t['08']);return;}
	if (eval(qty)<0){alert(t['06']);return;}
	if (Tbillno=="0"){alert(t['04']);return;}
	if (Tbillno=="") {alert(t['04']);return;}
	if (Tbillstatus=="P"){alert(t['09']);return;}     //lgl+
	if (ordname.indexOf(t['ahsl01'])!=-1){alert(t['ahsl02']);return;}
	
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOrdQtyUp&billno='+Tbillno+'&oeid='+ordid+'&Adm='+Adm+'&orddate='+execdate+'&prenum='+qty+'&order='+ordname
     window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=200,left=200,top=200')
}
//yyx 2009-11-02 读卡
function getpatinfo1() 
{
	if ((regnoobj.value!="")||(PatMedicareObj.value!="")){
	    p1=regnoobj.value
		var PatMedicare=document.getElementById('PatMedicare').value   // yyx 2009-06-17
		p2=getnotpaidobj.value
		var getregno=document.getElementById('getregno');
		if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
		if (cspRunServerMethod(encmeth,'setpat_val','',p1,PatMedicare)=='1'){
		};
			
	}
}
document.body.onload = BodyLoadHandler;
document.body.onbeforeunload=UnloadHandler;