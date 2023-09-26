//DHCOutPhRequest
//急诊留观退药申请
var SelectedRow = 0;
var pmiobj;
var objtbl;
var ctloc,userid;
var combo_DeptList;
var combo_RetReasList;
var EpisodeID;
function BodyLoadHandler() {
  EpisodeID = GetParam(window.parent, "EpisodeID");
  var obj=document.getElementById("EpisodeID");
  if (obj) EpisodeID=obj.value;
  SetPatientInfo(EpisodeID) ;
  var obj=document.getElementById("CardNo");
  if (obj) obj.onkeypress=GetCardInf;
  
  var objinv=document.getElementById("invno");
  if (objinv){

	  if (objinv.value!=""){
		  var objCPrtinvInfo=document.getElementById("CPrtinvInfo");
		  if (objCPrtinvInfo){
			  objCPrtinvInfo.value=objinv.value ;
		  }
	  }
	  
	  
  }
    var ReadCardobj=document.getElementById("BReadCard");
  	if (ReadCardobj) ReadCardobj.onclick=ReadHFMagCard_Click;
    var myobj=document.getElementById("CardTypeDefine");
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
    loadCardType();
    CardTypeDefine_OnChange();
	  
   objtbl=document.getElementById('tDHCOutPhRequest');
  if (objtbl) objtbl.onkeydown=GRetqty;	
  var prtobj=document.getElementById("CPrtInv");
  //if (prtobj) prtobj.onkeypress=GetReqInf;
  var obj=document.getElementById("CPmiNo");
  if (obj) obj.onkeypress=GetPatPrt;
  var BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click;
  //var BResetobj=document.getElementById("CPrtInv");
  //if (BResetobj) BResetobj.onclick=AddOption;
  
  var BResetobj=document.getElementById("BQueryReq");
  if (BResetobj) BResetobj.onclick=PrintQueryReq;

  var BReturnobj=document.getElementById("BRequest");
  if (BReturnobj) BReturnobj.onclick=Request_click;
  var BPrintobj=document.getElementById("BPrint");
  if (BPrintobj) BPrintobj.onclick=Print_click;
  pnameobj=document.getElementById("CName");
 var ctlocobj=document.getElementById("ctloc");
    ctloc=ctlocobj.value;
 var useridobj=document.getElementById("userid");
    userid=useridobj.value;
  returnphobj=document.getElementById("returnph");
  var obj=document.getElementById("CARet");
 if (obj) obj.onclick=GetChSure;
  var reqobj=document.getElementById("BRequest");
  reqobj.style.visibility="visible"
 var obj=document.getElementById("CACancel");
 if (obj) obj.onclick=GetChCancel; 
  //combo_DeptList=dhtmlXComboFromStr("CPrtInv","");
	//combo_DeptList.enableFilteringMode(true);
	//combo_DeptList.selectHandle=combo_DeptListKeydownhandler;
	//combo_DeptList.attachEvent("onKeyPressed",combo_DeptListKeyenterhandler)
  var  pmino=document.getElementById("CPmiNo").value;
  if (pmino!=''){
  	var encmeth=DHCC_GetElementData('getprt');
	var DeptStr=cspRunServerMethod(encmeth,pmino)
  
	var Arr=DHCC_StrToArray(DeptStr);
	//combo_DeptList.addOption(Arr);
  	
  }
	combo_RetReasList=dhtmlXComboFromStr("CRetReasDesc","");
	combo_RetReasList.enableFilteringMode(true);
 	var encmeth=DHCC_GetElementData('getreas');
	var DeptStr=cspRunServerMethod(encmeth )  
	var Arr=DHCC_StrToArray(DeptStr);
	combo_RetReasList.addOption(Arr);
	
 var printobj=document.getElementById("BPrint");
  printobj.style.visibility="hidden" 
  
 
 if (objtbl.rows.length>1)
  {

      DHCMZYF_setfocus('CRetReasDesc');
  }
 else
 {
      DHCMZYF_setfocus('CPmiNo')
 }
 
 
  var obj=document.getElementById("tDHCOutPhRequest")
  if (obj) {
	   obj.onkeyup=WriteRetMoney;
	 }
 
}
function AddOption()
{
	var pmiobj=document.getElementById("CPmiNo"); 
	var encmeth=DHCC_GetElementData('getprt');
	var DeptStr=cspRunServerMethod(encmeth,pmiobj.value)
  
	var Arr=DHCC_StrToArray(DeptStr);
	//combo_DeptList.addOption(Arr);
	
}
function GetPatPrt()
{
	var pmiobj=document.getElementById("CPmiNo"); 
	var key=websys_getKey(event);
	if (typeof key =="undefined"){
		key=13;
	}
	if (key==13) {	
		var plen=pmiobj.value.length
		var i
		var lszero=""
		if (plen==0){
			alert(t['inputerror']); 
			return ;
		}
		var maxlen=GetPmiLen();
		if (plen>maxlen){alert(t['01']);return;}
		for (i=1;i<=maxlen-plen;i++){
			lszero=lszero+"0"  
		}
		var lspmino=lszero+pmiobj.value;
		pmiobj.value=lspmino;
		
		GPatName(lspmino);
		
		var pnameobj=document.getElementById("CPatName"); 
		var patname=pnameobj.value
		if (patname=="") return;
		var encmeth=DHCC_GetElementData('getprt');
		var DeptStr=cspRunServerMethod(encmeth,lspmino)
		var Arr=DHCC_StrToArray(DeptStr);
		//combo_DeptList.addOption(Arr);
		DHCMZYF_setfocus('CPrtinvInfo')
	}
}

 

function combo_DeptListKeyenterhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==13) {
		combo_DeptListKeydownhandler();
	}
}
function combo_DeptListKeydownhandler(){
	var obj=combo_DeptList;
	var prt=obj.getActualValue();
    var inv=obj.getSelectedText();
    var patname=document.getElementById("CPatName").value;
	 var patno=document.getElementById("CPmiNo").value;
	 var obj=document.getElementById("inv") ;
	 obj.value=inv;
	

	   var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRequest&CPrtInv="+inv+"&CPmiNo="+patno+"&CPatName="+patname+"&inv="+inv;
 	   location.href=lnk;
 	   

 	   
}
function GPatName(pmino)
{
    
   var pid=document.getElementById('getpatname');
	if (pid) {var encmeth=pid.value} else {var encmeth=''};
	p1=pmino;
	if (cspRunServerMethod(encmeth,'SetPerName','',p1)=='0') {
	}	
}

function SetPerName(value)
{
  var patname="" ;
  if (value==""	) {alert("没有找到该病人!");
  		var pmiobj=document.getElementById("CPmiNo"); 
    	pmiobj.value="" ;
    	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRequest";
  
  }else{
	     var tstr=value.split("^")
	     var patname=tstr[0];
 		 
  }
  var pnameobj=document.getElementById("CPatName"); 
  pnameobj.value=patname
 
 
}

function GetPrtInf(value)
{
	 var patname=document.getElementById("CPatName").value;
	 var patno=document.getElementById("CPmiNo").value;
	 var sstr=value.split("^")
	 var prtinv=sstr[0]
	//  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRequest&CPrtInv="+prtinv+"&CPmiNo="+patno+"&CPatName="+patname;
 	//  location.href=lnk;
	
}
function SelectRowHandler()	{
	objtbl=document.getElementById('tDHCOutPhRequest');
	var eSrc=window.event.srcElement;
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	SelectedRow = selectrow;
    for (var i=1;i<rows;i++)
    {
    var eSrc=objtbl.rows[i];
     var RowObj=getRow(eSrc);
	 RowObj.className="OldBackSelColor"; 
    }
	 var retrow=SelectedRow
	 var eSrc=objtbl.rows[retrow];
     RowObj=getRow(eSrc);
	 RowObj.className="RowSelColor";


}

function GetReqInf()
{
  var key=websys_getKey(e);
   if (key==13) 
   {
   var prtinv=document.getElementById("CPrtInv").value;
   var getmethod=document.getElementById('getpatinf');
   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
   var retval=cspRunServerMethod(encmeth,prtinv)
   if (retval==0)
      {
	    alert(t['prtiserror']);
	    document.getElementById("CPrtInv").value="";
	    return ;  
       }
  else if (retval==-1)
      {
	    alert(t['dateisthree']);
	    document.getElementById("CPrtInv").value="";
	    return ;  
       }
	else
	  {
	   var sstr=retval.split("^")
	   document.getElementById("CPmiNo").value=sstr[0];
	   document.getElementById("CPatName").value=sstr[1];
	 // var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRequest&CPrtInv="+prtinv+"&CPmiNo="+sstr[0]+"&CPatName="+sstr[1];
 	 // location.href=lnk;
   
	  }   
	}	
}
 
 

  function ReadHFMagCard_ClickOLDBAK()
{
	var myrtn=DHCACC_GetAccInfo();
	var myary=myrtn.split("^");
	var rtn=myary[0];
	
	switch (rtn){
		case "-1":
		  alert(t['32']);
		   break;
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			var obj=document.getElementById("CPmino");
			obj.value=myary[5];
			var obj=document.getElementById("CardNo");
			obj.value=myary[1];
			 GPatName(myary[5])
		 //	DHCMZYF_setfocus('CPrtinv')
		  // Retrieve_click();
			//Find_click();
			break;
		case "-200":
			alert(t['30']);
			break;
		case "-201":
			alert(t['31'])
		default:
	
	}
	

}
  
  
  
function GetChCancel()
{
  var fy=document.getElementById("CARet");
   var ret=document.getElementById("CACancel");
   if ((fy.checked==true)&(ret.checked==true)){ret.checked=false;}
   if (ret.checked==true){
	    var rows=objtbl.rows.length
        var i,j=0;
          for (i=1;i<=rows-1;i++){
	   	var dispqty=document.getElementById('TDispQtyz'+i)
	   	var dispmoney=document.getElementById('TDispMoneyz'+i)
	   	var retqty=document.getElementById('TRetQtyz'+i)
	   	var retmoney=document.getElementById('TRetMoneyz'+i)
	   	retqty.innerText="";
	   	retmoney.innerText="";
	     }	
	   	}
}		
function GRetqty()
{  
  objtbl=document.getElementById('tDHCOutPhRequest');

  var key=websys_getKey(e);
  var Rows=objtbl.rows.length-1;

 if (key==13) {	
    if (SelectedRow==0){SelectedRow=1;}
	var disqty=document.getElementById('TPhQtyz'+SelectedRow)
	var price=document.getElementById('TPhPricez'+SelectedRow)
	var retqty=document.getElementById('TReqQtyz'+SelectedRow)
	var retmoney=document.getElementById('TReqMoneyz'+SelectedRow)
	var gretqty=retqty.value
	if (retqty.value==''){ 
	 if (Rows>SelectedRow){
	 var eSrc=objtbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
	 RowObj.className="OldBackSelColor"; 
	 var retrow=SelectedRow+1
	 var eSrc=objtbl.rows[retrow];
     RowObj=getRow(eSrc);
     SelectedRow=retrow;
	 RowObj.className="RowSelColor";
	 DHCMZYF_setfocus('TReqQtyz'+SelectedRow);}
	 else {if (Rows==SelectedRow){DHCMZYF_setfocus('BRequest');}}

    return; }
    
    gretqty=retqty.value
	if (retqty.value!=parseInt(gretqty)) {retqty.value="";retmoney.innerText="";return;}
	
	if (retqty.value<=0) {alert(t['lesszero']);retqty.value="";retmoney.innerText="";return;}
	if (eval(retqty.value)>eval(disqty.innerText)) {alert(t['moredispqty']);retqty.value="";retmoney.innerText="";return;} 
	
	 
	var sum=(retqty.value)*(price.innerText)
	retmoney.innerText=sum.toFixed(2)
    if (Rows>SelectedRow){
	 var eSrc=objtbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
	 RowObj.className="OldBackSelColor"; 
	 var retrow=SelectedRow+1
	 var eSrc=objtbl.rows[retrow];
     RowObj=getRow(eSrc);
     SelectedRow=retrow;
	 RowObj.className="RowSelColor";
	  DHCMZYF_setfocus('TReqQtyz'+SelectedRow);}
	 else {if (Rows==SelectedRow){DHCMZYF_setfocus('BRequest');}}
	 
	

 }
  if (key==9) 
  {	
    var retqty=document.getElementById('TReqQtyz'+SelectedRow).value
	var retmoney=document.getElementById('TReqMoneyz'+SelectedRow).innerText
   
  if (Rows>SelectedRow){
	 var retqty=document.getElementById('TReqQtyz'+SelectedRow).value
	 var retmoney=document.getElementById('TReqMoneyz'+SelectedRow).innerText
 	 var eSrc=tbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
	 RowObj.className="OldBackSelColor"; 
	 var retrow=SelectedRow+1
	 var eSrc=tbl.rows[retrow];
     var RowObj=getRow(eSrc);
     SelectedRow=retrow;
	 RowObj.className="RowSelColor";
	  DHCMZYF_setfocus('TReqQtyz'+SelectedRow);}
	 else {if (Rows==SelectedRow){DHCMZYF_setfocus('BRequest');}}
  }
}


function Reset_click()	
{
   location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRequest&EpisodeID="+EpisodeID;
}




function GPrtIDOLD(value)
{
	/*
 var prt=document.getElementById('CPrt')
 var vstr=value
 var sstr=vstr.split("^")
 var yprtobj=document.getElementById('CPrtinv')
 var yprtinv=yprtobj.value
 
 
 if (prt.value!=""&prt.value!=sstr[3]){ alert(t['geterrprt']);return 0 ;}
 
 
 prt.value=sstr[3]
 //DHCMZYF_setfocus('CPrt');
 var ctloc=document.getElementById('ctloc')
 var prescno=document.getElementById('CPrescNo')
 prescno.value=sstr[4]
 var dispdate=document.getElementById('CDispDate')
  dispdate.value=sstr[2]
 var newprt=document.getElementById('CNewPrt')
 newprt.value=sstr[5]
 DHCMZYF_setfocus('find');
 */
 
}


function GPrtID(value)
{
	
	var vstr=value
    var sstr=vstr.split("^")
    var inv=sstr[5]
    var invno=sstr[0];
    document.getElementById("invno").value=invno ;
    
    var patname=document.getElementById("CPatName").value;
	var patno=document.getElementById("CPmiNo").value;
	var prescmo=sstr[4];
	//document.getElementById("CPmiNo").value=inv ;
	
	var objCPrtInv=document.getElementById("CPrtInv") ;
	if (objCPrtInv){
		objCPrtInv.value=inv ;
	}
	var objCPresc=document.getElementById("CPresc") ;
	
	if (objCPresc){
		objCPresc.value=prescmo ;
	}
	
	var objfind=document.getElementById("find");
    if (objfind){
	
	    obj.onclick();
    }

	//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRequest&CPrtInv="+inv+"&CPmiNo="+patno+"&CPatName="+patname+"&inv="+inv+"&CPresc="+prescmo+"&invno="+invno;
 	//window.location=lnk;
 	//location.href=lnk;
 	//setTimeout(function(){window.location=lnk;},100);
 	
}


function Request_click()
{   var l=0
    var i
    
     
    var reqreason=combo_RetReasList.getActualValue()
    if (reqreason=='') {alert(t['noreas']);DHCMZYF_setfocus('CRetReasDesc');return ;}
  
    objtbl=document.getElementById('tDHCOutPhRequest');

     for (i=1;i<=objtbl.rows.length-1;i++)
     {
	       var retqtyobj=document.getElementById('TReqQtyz'+i)
		   if (retqtyobj.value!="")
		   {
			    var retqtyobj=document.getElementById('TReqQtyz'+i)
			    var retqty=document.getElementById('TReqQtyz'+i).value
			    var phqty=document.getElementById('TPhQtyz'+i).innerText
			    var retmoney=document.getElementById('TReqMoneyz'+i)
		        if (parseInt(retqty)==0){retqtyobj.value="";retmoney.innerText="";alert("录入数量错误");return;}
		        if(parseInt(retqty)<0) {retqtyobj.value="";retmoney.innerText="";alert("录入数量错误");return;}
		        if (retqty!=parseInt(retqty)) {retqtyobj.value="";retmoney.innerText="";alert("录入数量错误");return;}
				if (eval(retqty)>eval(phqty)) {alert(t['moredispqty']);retqtyobj.value="";retmoney.innerText="";return;} 
		        var phditm=document.getElementById('TPhdSubz'+i).value
		 	    l=l+1; 
		   }  
	        
     }
     
    if (l==0){alert(t['noqty']);return;}
     
  //判断申请退药总数

  var userid=document.getElementById('userid').value
  var pl=0,msg=0
   for (i=1;i<=objtbl.rows.length-1;i++)
   {
	 var reqqty=document.getElementById('TReqQtyz'+i).value
	 if (reqqty>0){
		 pl=pl+1;
		 if (pl==l){var flag="1"} else {var flag="0";}
		 var recloc=document.getElementById('TPhLocz'+i).value;
		 var phd=document.getElementById('TPhdRowidz'+i).value;
		 var prt=document.getElementById('TNewPrtz'+i).value;
		 var prescno=document.getElementById('TPrescNoz'+i).innerText;
		 var phditm=document.getElementById('TPhdSubz'+i).value;
		 var reqqty=document.getElementById('TReqQtyz'+i).value;
		 //判断发药和退药申请数量
		  var getmethod=document.getElementById('checkins');
          if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
          var retval=cspRunServerMethod(encmeth,recloc,phd,prt, prescno,phditm,reqqty,reqreason, userid, flag)
          if (retval=="-1"){msg=msg+1}
    		 }  
	   
   }
  if (msg!=0) {alert("退药数量大于发药数量,请刷新后重试!");return;}
   
  //
  var pl=0 ;
  for (i=1;i<=objtbl.rows.length-1;i++)
   {
	 var reqqty=document.getElementById('TReqQtyz'+i).value
	 if (reqqty>0){
		 pl=pl+1;
		 if (pl==l){var flag="1"} else {var flag="0";}
		 var recloc=document.getElementById('TPhLocz'+i).value;
		 var phd=document.getElementById('TPhdRowidz'+i).value;
		 var prt=document.getElementById('TNewPrtz'+i).value;
		 var prescno=document.getElementById('TPrescNoz'+i).innerText;
		 var phditm=document.getElementById('TPhdSubz'+i).value;
		 var reqqty=document.getElementById('TReqQtyz'+i).value;
		 //在申请单中插入数据
		  var getmethod=document.getElementById('dorequest');
          if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
          var reqcode=cspRunServerMethod(encmeth,recloc,phd,prt, prescno,phditm,reqqty,reqreason, userid, flag)
          if (reqcode=="-1"){alert("Insert Error");return;}
          document.getElementById('TReqCodez'+i).innerText=reqcode
		  var retqtyobj=document.getElementById('TReqQtyz'+i)
          retqtyobj.readOnly=true

		 }  
	   
   }
	  alert(t['sucess']);
	  var printobj=document.getElementById("BPrint");
	  printobj.style.visibility="visible"
	  var reqobj=document.getElementById("BRequest");
	  reqobj.style.visibility="hidden"
	  
}



function Print_click()
{   
	var HospDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID'])
      var getmethod=document.getElementById('gsysdate');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var sysdate=cspRunServerMethod(encmeth)
      var getmethod=document.getElementById('printpath');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var path=cspRunServerMethod(encmeth)
      var retreas=combo_RetReasList.getSelectedText()
      
      var userid=document.getElementById('userid').value
      var getmethod=document.getElementById('getusername');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var username=cspRunServerMethod(encmeth,userid)

	    var xlApp,obook,osheet,xlsheet,xlBook
	    var Template
	    Template=path+"yftysqd.xls"
	     // Template="c:\\yftysqd.xls"
	   	var pmino=document.getElementById('CPmiNo').value
	   	var patname=document.getElementById('CPatName').value
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet 
	  	var prtinv=document.getElementById('TPrtInvz'+1).innerText
	    xlsheet.cells(1,1).value=HospDesc+"退药申请单"
	    xlsheet.cells(2,2).value=patname
	    xlsheet.cells(2,5).value=pmino
	    xlsheet.cells(3,2).value=prtinv
	    xlsheet.cells(3,5).value=retreas
	    
	    
		var rownum ,i,j=0;
		objtbl=document.getElementById('tDHCOutPhRequest');
		var rows=objtbl.rows.length-1
		var money=0,rr=0;
		var pc=new Array()
		var reqcodestr="" ;
     for (i=1;i<=rows;i++){
	    if (document.getElementById('TReqQtyz'+i).value!="")
	     {
		    j=j+1;
	        var reqcode=document.getElementById('TReqCodez'+i).innerText
	        var phadesc=document.getElementById('TPhDescz'+i).innerText
	        var phprice=document.getElementById('TPhPricez'+i).innerText
	        var reqqty=document.getElementById('TReqQtyz'+i).value
	        var phuom=document.getElementById('TPhUomDescz'+i).innerText
	        
	        if (typeof(pc[reqcode])=='undefined')
	        {
		        if (reqcodestr!=""){
			        reqcodestr=reqcodestr+","+reqcode ;
		        
		        }else
		        {
			        reqcodestr=reqcode;
		        }       
	        }
	            xlsheet.cells(4,2).value=document.getElementById('TPhLocDescz'+i).innerText
	            xlsheet.cells(4,5).value=reqcodestr
	            xlsheet.cells(5,2).value=username
	            xlsheet.cells(5,5).value=sysdate
		        
		        pc[reqcode]=1
		        
		        xlsheet.cells(7,1).value="药品名称"
		        xlsheet.cells(7,2).value="申请数量"
		        xlsheet.cells(7,3).value="单位"
		        xlsheet.cells(7,4).value="单价"
		        xlsheet.cells(7,5).value="金额"
		        
		        var amt=parseFloat(phprice)*parseFloat(reqqty)
		        var amt=amt.toFixed(2)
		        
		        xlsheet.cells(7+j,1).value=phadesc
		        xlsheet.cells(7+j,2).value=reqqty
		        xlsheet.cells(7+j,3).value=phuom
		        xlsheet.cells(7+j,4).value=phprice
		        xlsheet.cells(7+j,5).value=amt
		       
	         
	       
	      } 
      }
      
      
    xlsheet.cells(9+j,1).value="药房主任意见:"+"                  签字:        日期:" 
     
    xlsheet.printout
	xlBook.Close(savechanges=false);
	xlApp=null;
	xlsheet=null
  }
  
  
function GetListSelectText(ListName){
	var Val="";
	var obj=document.getElementById(ListName);
	if (obj) {
		if (obj.selectedIndex!=-1){Val=obj.options[obj.selectedIndex].text};
	}
	return Val;
}

function GetListSelectVal(ListName){
	var Val="";
	var obj=document.getElementById(ListName);
	if (obj) {
		if (obj.selectedIndex!=-1){Val=obj.options[obj.selectedIndex].value};
	}
	return Val;
}
function DHCMZYF_setfocus(objName) {
	window.setTimeout('DHCMZYF_setfocus2(\''+objName+'\')',300);
}

function DHCMZYF_setfocus2(objName) {
	var obj=document.getElementById(objName);
	if (obj) {
		try {obj.focus();obj.select();	} catch(e) {}  }
    }

function CleartDHCOPAdm()
{
	var objtbl=document.getElementById('tDHCOPReturn');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	for (var j=1;j<lastrowindex+1;j++) {
		objtbl.deleteRow(1);
	//alert(j);
	}
}




///LiangQiang 
///写入数量后自动写入金额
function WriteRetMoney(e)
{
  var obj=websys_getSrcElement(e)
  var selindex=obj.id;
  var ss
  ss=selindex.split("z")
  if (ss.length>0)
   {	
  
   if (ss[0]=="TReqQty")
   {   
        var retmoneyobj=document.getElementById('TReqMoneyz'+SelectedRow)
	 	var price=document.getElementById('TPhPricez'+SelectedRow)
	 	
	    var retqtyobj=document.getElementById('TReqQtyz'+SelectedRow)
        var retqty=retqtyobj.value
		var phaqty=0
		var phqtyobj=document.getElementById('TPhQtyz'+SelectedRow)
		if (phqtyobj) {phaqty=phqtyobj.innerText; }
		
		if ( (!(parseInt(retqty)>0)) || (parseFloat(phaqty)<parseFloat(retqty)) ){
			retqtyobj.value="";
			if (retmoneyobj) retmoneyobj.innerText="";
			return;
		}
		
		var sum=parseFloat(retqtyobj.value)*parseFloat(price.innerText)
		if (retmoneyobj) retmoneyobj.innerText=sum.toFixed(2)
		
    }
    
  }
  
  
}


function PrintQueryReq()
{
	var lnk="DHCOutQueryRequest.csp" ;
    window.open(lnk,"_blank","height=500,width=700,menubar=no,status=no,toolbar=no,resizable=yes") ;
}



function loadCardType(){
	
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=document.getElementById("ReadCardTypeEncrypt").value;
		
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
		
	}
}



function CardTypeDefine_OnChange()
{
	
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	
	var myary=myoptval.split("^");
	
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR=="")
	{
		return;
	}
	///Read Card Mode
	
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		var obj=document.getElementById("BReadCard");
		if (obj){
			obj.disabled=true;
		}
	}
	else
	{
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		var obj=document.getElementById("BReadCard");
		if (obj){
			obj.disabled=false;
			obj.onclick=ReadHFMagCard_Click;
		}
	}
	
	//Set Focus
	if (myary[16]=="Handle"){
		DHCMZYF_setfocus("CardNo");
	}else{
		DHCMZYF_setfocus("BReadCard");
	}
	
	m_CardNoLength=myary[17];
	
}


function GetCardEqRowId(){
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	
	var myary=myoptval.split("^");
	
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	
	return m_SelectCardTypeDR;
} 


function ReadHFMagCard_Click()
{

	var myCardTypeValue=DHCWeb_GetListBoxValue("CardTypeDefine");
	m_SelectCardTypeDR=GetCardEqRowId();
	
	if (m_SelectCardTypeDR==""){
		var myrtn=DHCACC_GetAccInfo();
	}else{
		var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR,myCardTypeValue);
	}
	
	if (myrtn==-200){ //卡无效
			alert(t['35']);
			websys_setfocus('CPmiNo');
			return;
	}
	
	
	var myary=myrtn.split("^");
	var rtn=myary[0];
	if (rtn=="-1") {alert("不能读卡");return ;}

	
	else
	{	    var obj=document.getElementById("CPmiNo");
			if (obj) obj.value=myary[5];
			
			var obj=document.getElementById("CardNo");
			if (obj) obj.value=myary[1];
			if(myary[5]=="") 
			{
				alert("卡信息错误,登记号为空，请检查");
				return;
			}
		    GetPatPrt();
	}

	

}




function GetPatPrtReadCard()
{
	
	var pmiobj=document.getElementById("CPmiNo"); 
    var plen=pmiobj.value.length
    var i
    var lszero=""
    if (plen==0){
	     alert(t['inputerror']); return ;}
	     
	 var pmilen=GetPmiLen()    
	     
 	if (plen<pmilen){
	 	
	 for (i=1;i<=pmilen-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
    	 
 	}
 		 
	var lspmino=lszero+pmiobj.value;

	pmiobj.value=lspmino
	
    //GPatName(lspmino)
    
    GPatName(pmiobj.value)
 
	var encmeth=DHCC_GetElementData('getprt');
	var DeptStr=cspRunServerMethod(encmeth,lspmino)
  
	var Arr=DHCC_StrToArray(DeptStr);
	//combo_DeptList.addOption(Arr);
    DHCMZYF_setfocus('CPrtinvInfo')
   

}

function GetPmiLen()
{var getmethod=document.getElementById('getpmilen');
   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
 var pmilen=cspRunServerMethod(encmeth)
 return pmilen 
} 

function GetParam(obj, key)
	{
		var url = obj.location.href;
	  
		var strParams = "";
		var pos = url.indexOf("?");
		var tmpArry = null;
		var strValue = "";
		var tmp = "";
		if( pos < 0)
		{
			return "";
		}
		else
		{
		
			strParams = url.substring(pos + 1, url.length);
			tmpArry = strParams.split("&");
			for(var i = 0; i < tmpArry.length; i++)
			{
				tmp = tmpArry[i];
				if(tmp.indexOf("=") < 0)
					continue;
				if(tmp.substring(0, tmp.indexOf("=")) == key)
					strValue = tmp.substring(tmp.indexOf("=") + 1, tmp.length);
			}
			return strValue;
		}
	}  

function SetPatientInfo(EpisodeID){
	if (EpisodeID=="")return;
	var PatInfo=tkMakeServerCall("web.DHCOPBillOERefundQty","GetPatientInfo",EpisodeID);
	var TMPAry=PatInfo.split("^");
	document.getElementById("CPmiNo").value=TMPAry[0];
	document.getElementById("CPatName").value=TMPAry[1];
}


function GetCardInf()
{
	
	GetPatNoFrCard();
	
}


///回车卡号
function GetPatNoFrCard()
{
	  var key=websys_getKey(event);
	  if (key!=13) {return;}
	  var prescno=""
	  var card=""
	  cardobj=document.getElementById("CardNo");
	  if (cardobj)
	  {
		 card= cardobj.value;
	  }
	  
	  lscard=card;
	  cardlen=card.length
      if (m_CardNoLength>cardlen){
	      var lszero="";
		  for (i=1;i<=m_CardNoLength-cardlen;i++)
	  	  {
		 	 lszero=lszero+"0"  
	      }
	      var lscard=lszero+card;
      }
	  var getmethod=document.getElementById('getpatnofrcard');
      if (getmethod) {var encmeth=getmethod.value;} else {var encmeth=''};
      var patno=cspRunServerMethod(encmeth,lscard)
      if (patno=="-1") {alert("卡号错误");return;}
      var patnoobj=document.getElementById('CPmiNo');
      if (patnoobj)
      {
	      patnoobj.value=patno;
	      GPatName(patno);
      }

	  //Find_click();
	  //patnoobj.value="";
	  cardobj.value="";

}



document.body.onload = BodyLoadHandler;

