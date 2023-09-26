///UDHCJFDayRptHz.js
var Guser,gusername,stdate,enddate,jsrowid,curdate,prtflag,caption,userid,skuserid,job
var curdate,sttime,endtime,printDate
var Handinobj,ReportNoobj;
var nothandinobj,acceptobj,notacceptobj,skuseridobj,userobj
var myData = new Array()
var usergroup
var stdateobj,enddateobj,stdate1obj,enddate1obj,prtObj;
var gethospital
var hosptialname
var fyflagObj,SelectAllObj,FindObj;   ///全局变量
function BodyLoadHandler() {  

  Initialpaym();  //初始化列标题
  //Lid 2009-03-20 添加进程号
  var jobobj=document.getElementById('getcurrectjob');
  if (jobobj) {var encmeth=jobobj.value} else {var encmeth=''};
  job=cspRunServerMethod(encmeth,'','')
  document.getElementById("job").value=job 
  Guser=session['LOGON.USERID']
  gusername=session['LOGON.USERNAME'] 
  usergroup=session['LOGON.GROUPDESC']
  gethospital()
  stdateobj=document.getElementById("stdate");
  enddateobj=document.getElementById("enddate");
  stdate1obj=document.getElementById("stdate1");
  enddate1obj=document.getElementById("enddate1");
  stdate=document.getElementById("stdate").value
  enddate=document.getElementById("enddate").value
  ReportNoobj=document.getElementById("ReportNo")
  Handinobj=document.getElementById("Handin")
  nothandinobj=document.getElementById("nothandin")
  acceptobj=document.getElementById("accept")
  notacceptobj=document.getElementById("notaccept")
  skuseridobj=document.getElementById("skuserid")
  userobj=document.getElementById("newuser")
  FindObj=document.getElementById("Find");
  if (FindObj){FindObj.onclick=Find_Click;}
  SelectAllObj=document.getElementById("SelectAll");
  if (SelectAllObj){SelectAllObj.onclick=SelectAll_Click;} 
  
  userobj.onkeydown=getuser;
  stdate1obj.onkeydown=getstdate;
  enddate1obj.onkeydown=getenddate;
  if ((stdate1obj.value=="")||(stdateobj.value=="")){
    gettoday()
    }
  if ((enddate1obj.value=="")||(enddateobj.value=="")){
    gettoday()}  
  prtflag="1"
  Handinobj.onclick=gethandin
  nothandinobj.onclick=getnothandin
  acceptobj.onclick=getaccept
  notacceptobj.onclick=getnotaccept 
  var deposit=document.getElementById("DepositDetail");
  if (deposit){
      deposit.onclick=LinkDeposit_click;	  
  }
   
  var inv=document.getElementById("InvDetail");
  if (inv){
     inv.onclick=LinkInv_click;	  
  }
   
  prtObj=document.getElementById("Print");
  if (prtObj){
     prtObj.onclick=Print_click;	  
  }
  var btnaccept=document.getElementById("btnaccept");
  if (btnaccept){
	  btnaccept.onclick=btnaccept_click;
	  }
	  
  gethandin(); 
  getnothandin;
 }
 
 function Find_Click()
 {
	 GetJKDRofPrint(); //获取交款表(dhc_jfuserjk)Rowid
	 Find_click();
 }
function gettoday() {
	var gettoday=document.getElementById('gettoday');
	if (gettoday) {var encmeth=gettoday.value} else {var encmeth=''};
	
	if (cspRunServerMethod(encmeth,'setdate_val','','')=='1'){
				};
	}
function setdate_val(value)
	{
		curdate=value;
	    var curdate1=value
	    var str=curdate.split("/")
		curdate=str[2]+"-"+str[1]+"-"+str[0]
		stdate1obj.value=curdate
		enddate1obj.value=curdate
		stdateobj.value=curdate1
		enddateobj.value=curdate1
		}
function SelectRowHandler()	
{  	
	var eSrc=window.event.srcElement;
    var Sum=0
	Objtbl=document.getElementById('tUDHCJFDayRptHz');
	Rows=Objtbl.rows.length;
	
	var lastrowindex=Rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	//SelRowObj=document.getElementById('Tjsrowidz'+selectrow);
    //jsrowid=SelRowObj.innerText;
    SelRowObj=document.getElementById('Tjsdatez'+selectrow);
    caption=SelRowObj.innerText;
    SelRowObj=document.getElementById('Tuseridz'+selectrow);
    userid=SelRowObj.value;
       
}
function LinkDeposit_click()
{   
	if (caption==t['02']) 
	{ alert(t['01']);
	 return;}
	 
	if (jsrowid=="0")
	{  var getwjdate=document.getElementById('getwjdate');
	if (getwjdate) {var encmeth=getwjdate.value} else {var encmeth=''};
	var wjdatestr=cspRunServerMethod(encmeth,'','')
	if (wjdatestr!=""){
		var wjdatestr1=wjdatestr.split("^");
		if (wjdatestr1[0]!="") {stdate=wjdatestr1[0]}}
		if (wjdatestr1[1]!="") {enddate=wjdatestr1[1]}	
	var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDepositRpt&stdate='+stdate+'&enddate='+enddate+'&handin='+"N"+'&Guser='+userid+'&jsflag='+"N"+'&jkdr='
	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0')
	}
	if (jsrowid>0)
	{
		var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDepositRpt&stdate='+stdate+'&enddate='+enddate+'&handin='+""+'&Guser='+userid+'&jsflag='+"Y"+'&jkdr='+jsrowid
		
		window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0')
		}
    
}
function LinkInv_click()
{   
    if (caption==t['02'])  {alert(t['01']);return}
    if (jsrowid=="0")
	{  var getwjdate=document.getElementById('getwjdate');
	if (getwjdate) {var encmeth=getwjdate.value} else {var encmeth=''};
	var wjdatestr=cspRunServerMethod(encmeth,'','')
	if (wjdatestr!=""){
		var wjdatestr1=wjdatestr.split("^");
		if (wjdatestr1[0]!="") {stdate=wjdatestr1[0]}}
		if (wjdatestr1[1]!="") {enddate=wjdatestr1[1]}	
	 var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFInvRpt&stdate='+stdate+'&enddate='+enddate+'&handin='+"N"+'&Guser='+userid+'&jsflag='+"N"+'&jkdr='
     window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0')
	}
	if (jsrowid>0)
	{
		var str='websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFInvRpt&stdate='+stdate+'&enddate='+enddate+'&handin='+""+'&Guser='+userid+'&jsflag='+"Y"+'&jkdr='+jsrowid
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0')
		}	
}
function getpath() {
	var getpath=document.getElementById('getpath');
	if (getpath) {var encmeth=getpath.value} else {var encmeth=''};	
		path=cspRunServerMethod(encmeth,'','')
	}
function Print_click()
{   
	      var prtObj=document.getElementById('getDetailPrtInfo');
	      if (prtObj) {var encmeth=prtObj.value} else {var encmeth=''};
	      var detailInfo=cspRunServerMethod(encmeth,job,Guser);
	      var titleInfo=t['title']
	      PrintDaily(detailInfo,titleInfo);
}
function getuserid(value)	{

	var str=value.split("^");
	skuserid=document.getElementById('skuserid');
	skuserid.value=str[1];
}	 
function getuser()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  newuser_lookuphandler();
	  websys_setfocus('find')
	}
	else if(window.event.keyCode==8)
	{
		skuserid=document.getElementById('skuserid');
		skuserid.value=""	
	}
}
function getstdate(){
   var key=websys_getKey(e);
	if (key==13) {
   var mybirth=DHCWebD_GetObjValue("stdate1");
	if ((mybirth=="")||((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("stdate1");
		obj.className='clsInvalid';
		websys_setfocus("stdate1");
		return websys_cancel();
	}else{
		var obj=document.getElementById("stdate1");
		obj.className='clsvalid';
	}
	if ((mybirth.length==8)){
		var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		DHCWebD_SetObjValueA("stdate1",mybirth);
	}
	////alert(mybirth);
	var myrtn=DHCWeb_IsDate(mybirth,"-")
	if (!myrtn){
		var obj=document.getElementById("stdate1");
		obj.className='clsInvalid';
		websys_setfocus("stdate1");
		return websys_cancel();
	}else{
		var obj=document.getElementById("stdate1");
		obj.className='clsvalid';
	}
	var str1=stdate1obj.value.split("-")
	var str2=str1[2]+"/"+str1[1]+"/"+str1[0]
	stdateobj.value=str2
	websys_setfocus('enddate1')
	}		
	}
function getenddate(){
	var key=websys_getKey(e);
	if (key==13) {
	var mybirth=DHCWebD_GetObjValue("enddate1");
	if ((mybirth=="")||((mybirth.length!=8)&&((mybirth.length!=10)))){
		var obj=document.getElementById("enddate1");
		obj.className='clsInvalid';
		websys_setfocus("enddate1");
		return websys_cancel();
	}else{
		var obj=document.getElementById("enddate1");
		obj.className='clsvalid';
	}
	if ((mybirth.length==8)){
		var mybirth=mybirth.substring(0,4)+"-"+mybirth.substring(4,6)+"-"+mybirth.substring(6,8)
		DHCWebD_SetObjValueA("enddate1",mybirth);
	}
	////alert(mybirth);
	var myrtn=DHCWeb_IsDate(mybirth,"-")
	if (!myrtn){
		var obj=document.getElementById("enddate1");
		obj.className='clsInvalid';
		websys_setfocus("enddate1");
		return websys_cancel();
	}else{
		var obj=document.getElementById("enddate1");
		obj.className='clsvalid';
	}
	var str1=enddate1obj.value.split("-")
	var str2=str1[2]+"/"+str1[1]+"/"+str1[0]
	enddateobj.value=str2
	websys_setfocus('newuser')
	}	
}

function gethandin()
{if (Handinobj.checked==false)
  { Handinobj.checked=false
    nothandinobj.checked=true
    acceptobj.checked=false
    notacceptobj.checked=false
    Handinobj.value=""
    nothandinobj.value="on"
    acceptobj.value=""
    notacceptobj.value=""  
    DHCWeb_DisBtn(prtObj)   
  }else{
	Handinobj.checked=true
    nothandinobj.checked=false
    acceptobj.checked=false
    notacceptobj.checked=true
    Handinobj.value="on"
    nothandinobj.value=""
    acceptobj.value=""
    notacceptobj.value="on"  
    DHCWeb_AvailabilityBtn(prtObj); //在DHCWeb.OPCommon.js文件中  
	prtObj.onclick=Print_click;   
  }	
}
function getnothandin()
{

  if (nothandinobj.checked==false)
  { Handinobj.checked=true
    nothandinobj.checked=false
    acceptobj.checked=false
    notacceptobj.checked=true
    Handinobj.value="on"
    nothandinobj.value=""
    acceptobj.value=""
    notacceptobj.value="on" 
	DHCWeb_AvailabilityBtn(prtObj); //在DHCWeb.OPCommon.js文件中  
	prtObj.onclick=Print_click;
	  
  }else{
    Handinobj.checked=false
    nothandinobj.checked=true
    acceptobj.checked=false
    notacceptobj.checked=false
    Handinobj.value=""
    nothandinobj.value="on"
    acceptobj.value=""
    notacceptobj.value="" 
    DHCWeb_DisBtn(prtObj)    
  }
  		
}
function getaccept()
{if (acceptobj.checked==false)
  { Handinobj.checked=true
    nothandinobj.checked=false
    acceptobj.checked=false
    notacceptobj.checked=true
    Handinobj.value="on"
    nothandinobj.value=""
    acceptobj.value=""
    notacceptobj.value="on"     
  }else{
    Handinobj.checked=true
    nothandinobj.checked=false
    acceptobj.checked=true
    notacceptobj.checked=false
    Handinobj.value="on"
    nothandinobj.value=""
    acceptobj.value="on"
    notacceptobj.value=""     
  }  		
}
function getnotaccept()
{if (notacceptobj.checked==false)
  { Handinobj.checked=true
    nothandinobj.checked=false
    acceptobj.checked=true
    notacceptobj.checked=false
    Handinobj.value="on"
    nothandinobj.value=""
    acceptobj.value="on"
    notacceptobj.value=""     
  }else{
    Handinobj.checked=true
    nothandinobj.checked=false
    acceptobj.checked=false
    notacceptobj.checked=true
    Handinobj.value="on"
    nothandinobj.value=""
    acceptobj.value=""
    notacceptobj.value="on"    
  }		
}
function btnaccept_click()
{ if (userobj.value==""){
	skuseridobj.value=""
	}
  if (skuseridobj.value==""){
	alert(t['ahsl01']);
	return;}
 
 var i,reportstr
 var Objtbl=document.getElementById('tUDHCJFDayRptHz');
 var Rows=Objtbl.rows.length;
 var hzrow=Rows-2
 if (eval(hzrow)<1){
	 alert(t['hxey01']);
	 return;
 }
   
 reportstr=""
 for (i=1;i<=Rows-2;i++)
 {  var SelRowObj=document.getElementById('Tjsuserz'+i);
    var jsuser=SelRowObj.innerText;    
    if (jsuser!=userobj.value){
	    alert(t['ahsl04']);
	    return;}
	var SelRowObj=document.getElementById('Tinceptflagz'+i);
	var jiesflag=SelRowObj.innerText;
	if (jiesflag==t['ahsl06']){
		alert(t['ahsl07']);
		return;}
	var SelRowObj=document.getElementById('Tjsrowidz'+i);
    var reportno=SelRowObj.innerText;
    reportstr=reportstr+"^"+reportno    	 
 }
 var p0=skuseridobj.value
 var p1=reportstr
 var getinceptreport=document.getElementById("getinceptreport");
 if (getinceptreport) {var encmeth=getinceptreport.value} else {var encmeth=''};
 var str=cspRunServerMethod(encmeth,'','',p0,p1)
 
 var str1=str.split("^");
 if (eval(str1[0])==0){
    if (eval(str1[1])>0){
	   alert(t['hxey01']);
	   return;
	}
	if (eval(str1[2])>0) {
	   alert(t['ahsl04']);
	   return;   
	}
	if (eval(str1[3])>0) {
	   alert(t['ahsl07']);
	   return;   
	}
	if (eval(str1[4])>0) {
	   alert(t['hxey02']);
	   return;
	} 
 }else{
    if (eval(str1[0])==1){
	   alert(t['ahsl01']);
	   return;
	}
	if (eval(str1[0])==2){
	   alert(t['hxey01']);
	   return;
	} 
 } 
 var p1=reportstr
 var inceptdave=document.getElementById("inceptdave");
 if (inceptdave) {var encmeth=inceptdave.value} else {var encmeth=''};
 var str=cspRunServerMethod(encmeth,'','',p1,Guser)
 
 if (str=="1"){
	 alert(t['ahsl01']);
	 return;}
 else if (str=="2"){
	 alert(t['ahsl05']);
	 return;}
 else if (str=="0"){
	 alert(t['ahsl02']);
	 return;
	 }
else{
	alert(t['ahsl03']);
	 return;}	 
}
function gethospital()
{
	gethospital=document.getElementById('gethospital');
	if (gethospital) {var encmeth=gethospital.value} else {var encmeth=''};
	var str=cspRunServerMethod(encmeth)
	var str1=str.split("^");
	hosptialname=str1[1];	
}	

function SelectAll_Click()
{
  var obj=document.getElementById("SelectAll");
  var Objtbl=document.getElementById('tUDHCJFDayRptHz');
  var Rows=Objtbl.rows.length;
  for (var i=1;i<Rows;i++){
	var selobj=document.getElementById('Tselectz'+i);  
	selobj.checked=obj.checked;  
	}
}

function GetJKDRofPrint() 
{
  var objtbl=document.getElementById('tUDHCJFDayRptHz');	
  var rows=objtbl.rows.length;
  var i=0;
  var SColObj,RColObj;
  var JKDRList=""
  for (i=1;i<rows;i++)
  {
		SColObj=document.getElementById('Tselectz'+i);  
		if (SColObj)
		{
		  if (SColObj.checked){
			   
			    var jkdr=GetColumnData('Tjsrowid',i);
				if (JKDRList==""){JKDRList=jkdr;}else{JKDRList=JKDRList + "^" + jkdr; } 
			} 
	  }   
	}
   document.getElementById('JKDRList').value= JKDRList
   ;return JKDRList; 	
}  	

function getStDateAndEndDate()
{
    stdate=document.getElementById("stdate").value;
    enddate=document.getElementById("enddate").value;  
    //sttime=document.getElementById("sttime").value; 
    //endtime=document.getElementById("endtime").value;	
}
function getPrintDate() {
	var getPrtDateObj=document.getElementById('getcurdate');
	if (getPrtDateObj) {var encmeth=getPrtDateObj.value} else {var encmeth=''};
	
	printDate=cspRunServerMethod(encmeth)
}
function GetColumnData(ColName,Row){
	
	var CellObj=document.getElementById(ColName+"z"+Row);
	if (CellObj){
		//alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else{
			if (CellObj.type=="checkbox"){
				return CellObj.checked;
			}else{
				return CellObj.value;
			}
		}
	}
	return "";
}

function Initialpaym()
{
	///unescape
 
	var catobj=document.getElementById("getpaym");
	 
	if (catobj) {var encmeth=catobj.value} else {var encmeth=''};
	
	var payminfo=cspRunServerMethod(encmeth);
	
	var objtbl=document.getElementById("tUDHCJFDayRptHz");
	var Rows=objtbl.rows.length;
	var firstRow=objtbl.rows[0];

	var RowItems=firstRow.all;
	///alert(catinfo);
	var paymtmp =payminfo.split("^");
	var paymnum=paymtmp.length;

	for (var i=1;i<=paymnum-1;i++)
	{
		var ColName="Tpaym"+i;
		for (var j=0;j<RowItems.length;j++) 
		{
			if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH'))
			{
				RowItems[j].innerHTML=paymtmp[i];
			}
		}
	}
	
	for (var i=paymnum;i<=16;i++){
		HiddenTblColumn(objtbl,"Tpaym"+i,i);
	}
}

function HiddenTblColumn(tbl,ColName,ColIdx){
	///
	///
	var row=tbl.rows.length;
	var firstRow=tbl.rows[0];
	var RowItems=firstRow.all;
	
	for (var j=0;j<RowItems.length;j++) {
		if ((RowItems[j].innerHTML==ColName+" ")&(RowItems[j].tagName=='TH')) {
			RowItems[j].style.display="none";
		} else {
		}
	}

	row=row-1;
	for (var j=1;j<row+1;j++) {
		var sLable=document.getElementById("Tpaym"+ColIdx+'z'+j);
		var sTD=sLable.parentElement;
		sTD.style.display="none";
	}
}

document.body.onload = BodyLoadHandler;