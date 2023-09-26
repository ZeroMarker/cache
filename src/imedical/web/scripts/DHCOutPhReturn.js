// DHCOutPhReturn.js
//门诊药房-退药
var SelectedRow = 0;
var pmiobj,pnameobj,pageobj;
var prtobj,prtinvobj;
var LoopCount=1
var ctlocobj,useridobj;
var HospitalCode
var retseaobj,retseaidobj;
var BResetobj,BReturnobj,BPrintobj;
var returnphobj,returnphitmobj;
var GSplitStr=String.fromCharCode(1)
var cdateobj;
var objtbl=document.getElementById('tDHCOutPhReturn');
var OutPhReturnId="";
function BodyLoadHandler() {
  objtbl=document.getElementById('tDHCOutPhReturn');
  if (objtbl) objtbl.onkeydown=GRetqty;	
  BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click;
  BReturnobj=document.getElementById("BReturn");
  if (BReturnobj) BReturnobj.onclick=Return_click;
  BPrintobj=document.getElementById("BPrint");
  if (BPrintobj) BPrintobj.onclick=Print_click;
   var Bfindobj=document.getElementById("find");
  if (Bfindobj) Bfindobj.onclick=findclick;
   var obj=document.getElementById("CReqNo");
   //if (obj) obj.onclick=SelectReqNoList;
   
    if (obj) obj.onchange=SelectReqNoList;
  pmiobj=document.getElementById("CPmino");
  if (pmiobj) pmiobj.onkeypress=GetPmino;
  //if (pmiobj) pmiobj.onblur=GPmino;  //blur与keydown共存冲突
  pnameobj=document.getElementById("CName");
  pageobj=document.getElementById("CAge");
  prtobj=document.getElementById("CPrt");
  if (prtobj) prtobj.onblur=GPrtPh;
  ctlocobj=document.getElementById("ctloc");
  useridobj=document.getElementById("userid");
  returnphobj=document.getElementById("returnph");
  returnphitmobj=document.getElementById("returnphitm");
   var obj=document.getElementById("CRetReason");
 if (obj) obj.onblur=checkde;
 
 var prescobj=document.getElementById("CardNo");
 if (prescobj) prescobj.onkeypress=GetPatNoFrCard;
  
   var ReadCardobj=document.getElementById("CReadCard");
  if (ReadCardobj) ReadCardobj.onclick= ReadHFMagCard_Click;
  
  // add cardtype  by tang 2010.10.29
  var myobj=document.getElementById("CardTypeDefine");
	if (myobj){
		myobj.onchange=CardTypeDefine_OnChange;
		myobj.size=1;
		myobj.multiple=false;
	}
    loadCardType();
    CardTypeDefine_OnChange();
  

  var GetHospital=document.getElementById("GetHospital");
	if (GetHospital) {var encmeth=GetHospital.value} else {var encmeth=''};
	if (encmeth!="") {
		var HospitalStr=cspRunServerMethod(encmeth,"CurrentHospital");
		var bstr=HospitalStr.split("^");
	//HospitalCode=bstr[0];
	}
	HospitalCode="WF"
	if (HospitalCode!="WF") {
		if (objtbl.rows.length>1){
		DHCMZYF_setfocus('CRetReason');}
	else
	{
		var cardobj=document.getElementById("CReadCard");
		if (cardobj){ DHCMZYF_setfocus('CReadCard');}
	}
	cdateobj=document.getElementById("CDate");
 
  //var obj=document.getElementById("CardNo");
  //if (obj) obj.onkeypress=GetPatNoFrCard;

 BPrintobj.style.visibility = "hidden";
 document.onkeydown=OnKeyDownHandler;
  var obj=document.getElementById("CARet");
 if (obj) obj.onclick=GetChSure;
 var obj=document.getElementById("CACancel");
 if (obj) obj.onclick=GetChCancel; 
 		}
else
	{
	var cardobj=document.getElementById("CReadCard");
    if (cardobj){ DHCMZYF_setfocus('CReadCard');}
    else
    {
		DHCMZYF_setfocus('CPmino');}}

		
  var obj=document.getElementById("tDHCOutPhReturn")
  if (obj) {
	   obj.onkeyup=WriteRetMoney;
	 }	
	
 // cdate.value=($zd(+$h,3))
}
function findclick()
{
	document.getElementById("CurrReqNo").value="";
	document.getElementById("CRetReasonid").value="";
	OutPhReturnId="";
	find_click();
}
function checkde()
{
	
	var obj=document.getElementById("CRetReason")
	var objid=document.getElementById("CRetReasonid")
	if (obj.value=="")
	{objid.value=""}
}
function SelectReqNoList()
{
	var loc=document.getElementById("ctloc").value
	var ReqNoList=document.getElementById("CReqNo");
	if(ReqNoList.options.length==0){return ;}
	var i=0
	for (i=0;i<ReqNoList.options.length;i++)
	 {
	 	//ReqNoList.options[i].selected=false;
	 	if (ReqNoList.options[i].selected){
		 	//alert(i)
	 	}
	 }
	
	var ReqIndex=ReqNoList.selectedIndex;
	//wanghc 2016-02-15
	ClickReqNoList(ReqIndex);
	return ;
	
	if (ReqNoList.options.length>0)	{
		//ReqNoList.options[ReqIndex].selected=true;
		var SelectedReqRow=ReqNoList.options[ReqIndex].value;
		document.getElementById("CurrReqNo").value=SelectedReqRow;
		var curreq=SelectedReqRow
		var pmino=document.getElementById("CPmino").value;	
		var getmethod=document.getElementById('getreqinf');
		if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
		var retval=cspRunServerMethod(encmeth,curreq)
		var reqph=retval.split(GSplitStr)
		CleartTbl();
		var i=0
		for (i=0;i<=reqph.length-1;i++)
		{
			
			tAddRow(reqph[i]); 
		}
	}
	var getmethod=document.getElementById('getretreas');
  if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
  var retval=cspRunServerMethod(encmeth,curreq)
  var sstr=retval.split("^")
  document.getElementById('CRetReason').value=sstr[1]
  document.getElementById('CRetReasonid').value=sstr[0]
	//DHCMZYF_setfocus('CRetReason');
}
function CleartTbl()
{
	var objtbl=document.getElementById('tDHCOutPhReturn');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	for (var j=1;j<lastrowindex;j++) {
		objtbl.deleteRow(1);
	}
	
	var objlastrow=objtbl.rows[1];
	if (!objlastrow) return;
	var rowitems=objlastrow.all; //IE only
	if (!rowitems) rowitems=objlastrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]="1";
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].innerText="";
		}
	}
	LoopCount=1
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOutPhReturn');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;

	var SelRowObj=document.getElementById('TPhdescz'+selectrow);
	var SelRowObj1=document.getElementById('TPhUomz'+selectrow);
	var SelRowObj2=document.getElementById('TPricez'+selectrow);
	var SelRowObj3=document.getElementById('TDispQtyz'+selectrow);
    var SelRowObj4=document.getElementById('TRetQtyz'+selectrow);
    var SelRowObj5=document.getElementById('TRetMoneyz'+selectrow);
    var dispqty=SelRowObj3.innerText
	
	SelectedRow = selectrow;

	// DHCMZYF_setfocus('CRetQty');
}
function OnKeyDownHandler(e)
 {
 
 }
  function GetChSure()
{
   var fy=document.getElementById("CARet");
   var ret=document.getElementById("CACancel");
   if ((fy.checked==true)&(ret.checked==true)){fy.checked=false;}
   if (fy.checked==true){
	    var rows=objtbl.rows.length
        var i,j=0;
          for (i=1;i<=rows-1;i++){
	   	var dispqty=document.getElementById('TDispQtyz'+i)
	   	var dispmoney=document.getElementById('TDispMoneyz'+i)
	   	var retqty=document.getElementById('TRetQtyz'+i)
	   	var retmoney=document.getElementById('TRetMoneyz'+i)
	   	retqty.innerText=dispqty.innerText;
	   	retmoney.innerText=dispmoney.innerText;
	     }	
	   	}
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
			alert("此卡无效！");
			websys_setfocus('CPmino');
			return;
	}
	
	
	var myary=myrtn.split("^");
	var rtn=myary[0];
	
	
	if  (rtn=="-1"){  
		alert(t['32']);return;
	}
	else
	{
			 var ctlocobj=document.getElementById("ctloc");
			 var obj=document.getElementById("CPmino");
			 obj.value=myary[5];
			 var obj=document.getElementById("CardNo");
			 if(myary[1]=="undefined"){
				obj.value=""				
			 	return;
			 }
			 obj.value=myary[1];
			 GPatName(myary[5]);
			 GetValListbox(ctlocobj.value,myary[5]);
			 DHCMZYF_setfocus('CReqNo'); 
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
{ var key=websys_getKey(e);
  var Rows=objtbl.rows.length-1;
    CurrSrc=websys_getSrcElement();
 if (key==13) {	
 	
 	
	KeyEvents();
 

 }
}



///回车卡号   LiangQiang
function GetPatNoFrCard(e)
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
	  if(card=="") {alert("请输入卡号!");return;}
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
      var patnoobj=document.getElementById('CPmino');
      if (patnoobj)
      {
	      patnoobj.value=patno;
	      GetPmino();
      }
     
	  cardobj=document.getElementById("CardNo");
	  if (cardobj)
	  {
	   cardobj.value="";
	   
	  }

}




///公共调用liangqiang 
function KeyEvents()
{
 
	if (HospitalCode=="WF"){
 		
 	if (CurrSrc.id.split("z")[0]){
 		if(CurrSrc.id.split("z")[0]=="TRetQty")
 		{
 			  if (SelectedRow==0){SelectedRow=1;}
	var disqty=document.getElementById('TDispQtyz'+SelectedRow)
	var price=document.getElementById('TPricez'+SelectedRow)
	var retqty=document.getElementById('TRetQtyz'+SelectedRow)
	var retmoney=document.getElementById('TRetMoneyz'+SelectedRow)
	var gretqty=retqty.value
	if (retqty.value!=parseInt(gretqty)) {retqty.value="";retmoney.innerText="";return;}
	if (retqty.value<=0) {alert("退药数量录入有误,请检查");retqty.value="";retmoney.innerText="";return;}
	if (eval(retqty.value)>eval(disqty.innerText)) {alert(t['02']);retqty.value="";retmoney.innerText="";return;} 
	 var sum
	 sum=(retqty.value)*(price.innerText)
	retmoney.innerText=sum.toFixed(2)

	  DHCMZYF_setfocus('TIncRetBatCodez'+SelectedRow);}
	  if(CurrSrc.id.split("z")[0]=="TIncRetBatCode")
 		{
 			var retbatcode=document.getElementById('TIncRetBatCodez'+SelectedRow).value
 			if (retbatcode==''){alert(t['nobat']);return;}
 			var phditm=document.getElementById('TPhdItmz'+SelectedRow).value
 			var GetBatCode=document.getElementById('chbat');
	   if (GetBatCode) {var encmeth=GetBatCode.value} else {var encmeth=''};
  
	   var retval=cspRunServerMethod(encmeth,phditm, retbatcode);
       
	   if (retval=="0"){
	   	alert(t['null']);
	   	document.getElementById('TRetQtyz'+SelectedRow).value="";
	   	document.getElementById('TRetMoneyz'+SelectedRow).innerText="";
	   	document.getElementById('TIncRetBatCodez'+SelectedRow).value=""
	  	return;}
	   else if (retval=="3"){
	   	alert(t['nosell']);
	   	document.getElementById('TRetQtyz'+SelectedRow).value="";
	   	document.getElementById('TRetMoneyz'+SelectedRow).innerText="";
	   	document.getElementById('TIncRetBatCodez'+SelectedRow).value=""
	  	return;}
	   else {
		    //alert(retval);
		    }
	    	if (Rows>SelectedRow){
	 var eSrc=tbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
	 RowObj.className="OldBackSelColor"; 
	 var retrow=SelectedRow+1
	 var eSrc=tbl.rows[retrow];
     var RowObj=getRow(eSrc);
     SelectedRow=retrow;
	 RowObj.className="RowSelColor";
	  DHCMZYF_setfocus('TRetQtyz'+SelectedRow);}
	 else {if (Rows==SelectedRow){DHCMZYF_setfocus('BReturn');}}
		
 			}
	  
 			
 		}
 	}
 	
 	else
 		{
	 
    if (SelectedRow==0){SelectedRow=1;}
	var disqty=document.getElementById('TDispQtyz'+SelectedRow)
	var price=document.getElementById('TPricez'+SelectedRow)
	var retqty=document.getElementById('TRetQtyz'+SelectedRow)
	var retmoney=document.getElementById('TRetMoneyz'+SelectedRow)
	var gretqty=retqty.value
	if (retqty.value!=parseInt(gretqty)) {retqty.value="";retmoney.innerText="";return;}
	if (retqty.value<=0) {alert(t['01']);retqty.value="";retmoney.innerText="";return;}
	if (eval(retqty.value)>eval(disqty.innerText)) {alert(t['02']);retqty.value="";retmoney.innerText="";return;} 
	 var sum
	 sum=(retqty.value)*(price.innerText)
	retmoney.innerText=sum.toFixed(2)
    if (Rows>SelectedRow){
	 var eSrc=tbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
	 RowObj.className="OldBackSelColor"; 
	 var retrow=SelectedRow+1
	 var eSrc=tbl.rows[retrow];
     var RowObj=getRow(eSrc);
     SelectedRow=retrow;
	 RowObj.className="RowSelColor";
	  DHCMZYF_setfocus('TRetQtyz'+SelectedRow);}
	 else {if (Rows==SelectedRow){DHCMZYF_setfocus('BReturn');}}
	}
}


function GetChCancelOld()
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
{ var key=websys_getKey(e);
  var Rows=objtbl.rows.length-1;
  var CurrSrc=websys_getSrcElement();
 if (key==13) {	
 	
 	if (HospitalCode=="WF"){
 		
 	if (CurrSrc.id.split("z")[0]){
 		if(CurrSrc.id.split("z")[0]=="TRetQty")
 		{
 			  if (SelectedRow==0){SelectedRow=1;}
	var disqty=document.getElementById('TDispQtyz'+SelectedRow)
	var price=document.getElementById('TPricez'+SelectedRow)
	var retqty=document.getElementById('TRetQtyz'+SelectedRow)
	var retmoney=document.getElementById('TRetMoneyz'+SelectedRow)
	var gretqty=retqty.value
	if (retqty.value!=parseInt(gretqty)) {retqty.value="";retmoney.innerText="";return;}
	if (retqty.value<=0) {alert("退药数量录入有误,请检查");retqty.value="";retmoney.innerText="";return;}
	if (eval(retqty.value)>eval(disqty.innerText)) {alert(t['02']);retqty.value="";retmoney.innerText="";return;} 
	 var sum
	 sum=(retqty.value)*(price.innerText)
	retmoney.innerText=sum.toFixed(2)
    
	  DHCMZYF_setfocus('TIncRetBatCodez'+SelectedRow);}
	  var staus=document.getElementById('TIncDispBatCodez'+SelectedRow).innerText
	  if (staus=="欠药") {
		     alert("欠药不需填写批号");
		     document.getElementById('TIncRetBatCodez'+SelectedRow).value=""
	         DHCMZYF_setfocus('TIncRetBatCodez'+SelectedRow);
	         return;
	         }
	  if((CurrSrc.id.split("z")[0]=="TIncRetBatCode")&&(staus!="欠药"))
 		{
 			var retbatcode=document.getElementById('TIncRetBatCodez'+SelectedRow).value
 			if (retbatcode==''){alert(t['nobat']);return;}
 			var phditm=document.getElementById('TPhdItmz'+SelectedRow).value
 			var GetBatCode=document.getElementById('chbat');
	   if (GetBatCode) {var encmeth=GetBatCode.value} else {var encmeth=''};
  
	   var retval=cspRunServerMethod(encmeth,phditm, retbatcode);
       
	   if (retval=="0"){
	   	alert(t['null']);
	   	document.getElementById('TRetQtyz'+SelectedRow).value="";
	   	document.getElementById('TRetMoneyz'+SelectedRow).innerText="";
	   	document.getElementById('TIncRetBatCodez'+SelectedRow).value=""
	  	return;
	  }
	   else if (retval=="3"){
	   	alert(t['nosell']);
	   	document.getElementById('TRetQtyz'+SelectedRow).value="";
	   	document.getElementById('TRetMoneyz'+SelectedRow).innerText="";
	   	document.getElementById('TIncRetBatCodez'+SelectedRow).value=""
	  	return;}
	   else {
		    //alert(retval);
		    }
	    	if (Rows>SelectedRow){
	 var eSrc=tbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
	 RowObj.className="OldBackSelColor"; 
	 var retrow=SelectedRow+1
	 var eSrc=tbl.rows[retrow];
     var RowObj=getRow(eSrc);
     SelectedRow=retrow;
	 RowObj.className="RowSelColor";
	  DHCMZYF_setfocus('TRetQtyz'+SelectedRow);}
	 else {if (Rows==SelectedRow){DHCMZYF_setfocus('BReturn');}}
		
 			}
	  
 			
 		}
 	}
 	
 	else
 		{
	 
    if (SelectedRow==0){SelectedRow=1;}
	var disqty=document.getElementById('TDispQtyz'+SelectedRow)
	var price=document.getElementById('TPricez'+SelectedRow)
	var retqty=document.getElementById('TRetQtyz'+SelectedRow)
	var retmoney=document.getElementById('TRetMoneyz'+SelectedRow)
	var gretqty=retqty.value
	if (retqty.value!=parseInt(gretqty)) {retqty.value="";retmoney.innerText="";return;}
	if (retqty.value<=0) {alert(t['01']);retqty.value="";retmoney.innerText="";return;}
	if (eval(retqty.value)>eval(disqty.innerText)) {alert(t['02']);retqty.value="";retmoney.innerText="";return;} 
	 var sum
	 sum=(retqty.value)*(price.innerText)
	retmoney.innerText=sum.toFixed(2)
    if (Rows>SelectedRow){
	 var eSrc=tbl.rows[SelectedRow];
     var RowObj=getRow(eSrc);
	 RowObj.className="OldBackSelColor"; 
	 var retrow=SelectedRow+1
	 var eSrc=tbl.rows[retrow];
     var RowObj=getRow(eSrc);
     SelectedRow=retrow;
	 RowObj.className="RowSelColor";
	  DHCMZYF_setfocus('TRetQtyz'+SelectedRow);}
	 else {if (Rows==SelectedRow){DHCMZYF_setfocus('BReturn');}}
	}
 }
}

function GetPmino()
{
	var key=websys_getKey(event);
	if (key==13) {	
    	GetPmiInfo();
	}
}
function GetPmiInfo()
{
	var plen=pmiobj.value.length
    var i
    var lszero=""
 	if (plen>10){alert(t['03']);return;}
	for (i=1;i<=10-plen;i++)
  	{
	 	lszero=lszero+"0"  
    }
	var lspmino=lszero+pmiobj.value;
	pmiobj.value=lspmino
	GPatName(lspmino)
	CleartTbl();
	GetValListbox(ctlocobj.value,lspmino);
	DHCMZYF_setfocus('CReqNo');
	var PrtObj=document.getElementById('CPrt');
	if (PrtObj) PrtObj.value="";
	var PrtInvObj=document.getElementById('CPrtinv');
	if (PrtInvObj) PrtInvObj.value="";
	var PrescNoObj=document.getElementById('CPrescNo');
	if (PrescNoObj) PrescNoObj.value="";
	var dispdate=document.getElementById('CDispDate')
  	if (dispdate) dispdate.value="";
 	var newprt=document.getElementById('CNewPrt')
 	if (newprt) newprt.value="";
}
function GetValListbox(loc,pmino)
{
	var ReqNoList=document.getElementById('CReqNo');
	ReqNoList.options.length=0;
	var GetReqNo=document.getElementById('getreqno');
	if (GetReqNo) {var encmeth=GetReqNo.value} else {var encmeth=''};
	var myExpStr="";
	var ReqNoStr=cspRunServerMethod(encmeth,loc, pmino);
	if (ReqNoStr=='') return ;
	var ReqNoListNum=ReqNoStr.split("&");
	
	if (ReqNoListNum.length==0) {return "";}
	var DefaultIndex=0;
	for (i=0;i<ReqNoListNum.length;i++)	{
		ValReqNoList=ReqNoListNum[i].split("^");
		var ListText=ValReqNoList[0]+"."+ValReqNoList[3]+"."+ValReqNoList[4];
	 	var ListValue=ValReqNoList[1]
	 	var ListCurr=ValReqNoList[2]
		option=document.createElement("option");
		option.value=ListValue;
		option.text=ListText;		
		ReqNoList.add(option);
		if (ListCurr==1) {DefaultIndex=i;}
	}
	ReqNoList.options[0].selected=true;

	if (ReqNoListNum.length=1) ClickReqNoList(0)

}
function ClickReqNoList(currindex)
{
	CleartTbl();
	OutPhReturnId="";
	var loc=document.getElementById("ctloc").value
	var ReqNoList=document.getElementById("CReqNo");
	var ReqIndex=currindex;
	if (ReqNoList.options.length>0)	{
		var SelectedReqRow=ReqNoList.options[ReqIndex].value;
		document.getElementById("CurrReqNo").value=SelectedReqRow;
		var curreq=SelectedReqRow
	 	var pmino=document.getElementById("CPmino").value;	
	 	var getmethod=document.getElementById('getreqinf');
  		if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
		var retval=cspRunServerMethod(encmeth,curreq)
		var reqph=retval.split(GSplitStr)
		var i=0
		/*wanghc 2016-02-15*/
		tAddTable(reqph);
		/*for (i=0;i<=reqph.length-1;i++){
			tAddRow(reqph[i]);
		}*/
	}
	var getmethod=document.getElementById('getretreas');
  if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
  var retval=cspRunServerMethod(encmeth,curreq)
  var sstr=retval.split("^")
  document.getElementById('CRetReason').value=sstr[1]
  document.getElementById('CRetReasonid').value=sstr[0]
	
}

function AddRowToList(objtbl) {
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=tk_getTBody(objlastrow);
	//objtbl=websys_getParentElement(objlastrow);
	var zrow = row-1;
	var objnewrow;
	objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			//arrId[arrId.length-1]=arrId[arrId.length-1]+1;
			arrId[arrId.length-1]=eval(arrId[arrId.length-1])+1
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value="";
			//rowitems[j].innerText="";
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}
}
/*wanghc 2016-02-15*/
function tAddTable(arr){
	if (arr=="") return ;	
	var tbl = document.getElementById("tDHCOutPhReturn");
	var headhtml = '<TABLE class=tblList id="tDHCOutPhReturn" Name="tDHCOutPhReturn" CELLSPACING=0 width="100%"><THEAD ondblclick="websys_lu(\'websys.component.customiselayout.csp?ID=56250&amp;CONTEXT=\',false);"><TR>'
	+'<TH style="DISPLAY: none"></TH><TH id=1 noWrap>药品名称 </TH><TH id=2 noWrap>药品单位 </TH><TH id=3 noWrap>药品单价 </TH>'
	+'<TH id=4 noWrap>发药数量 </TH><TH id=5 noWrap>发药金额 </TH><TH id=6 noWrap>退药数量 </TH><TH id=7 noWrap>退药金额 </TH>'
	+'<TH id=10 noWrap>规格 </TH><TH id=12 noWrap>发药批号 </TH><TH id=13 noWrap>退药批号 </TH></TR></THEAD><TBODY>';
	var tmphtml = "",row=0,incRetBatCode="",tcss = "RowEven";
	for (var i =0; i<arr.length; i++){
		var Split_Value=arr[i].split("^") 
		row = i+1;
		tcss = "RowEven";
		if (row%2==1){tcss="RowOdd"};
		incRetBatCode = "";
		if (Split_Value[11]!="欠药"){  incRetBatCode = Split_Value[11];}
		tmphtml += '<TR class="'+tcss+'" NOWRAP TRAKListIndex="'+row+'"><TD style="DISPLAY:none">'
		+'<INPUT id=TPhdItmz'+row+' type=hidden name=TPhdItmz'+row+' value='+Split_Value[7]+'>'
		+'<INPUT id=TPhUomidz'+row+' type=hidden name=TPhUomidz'+row+' value='+Split_Value[8]+'>'
		+'<INPUT id=TSeqNoz'+row+' type=hidden name=TSeqNoz'+row+' value='+Split_Value[10]+'>'
		+'<INPUT id=TCPrtz'+row+' type=hidden name=TCPrtz'+row+'></TD>'
		+'<TD><LABEL id=TPhdescz'+row+' name="TPhdescz'+row+'">'+Split_Value[0]+'</LABEL></TD>'
		+'<TD><LABEL id=TPhUomz'+row+' name="TPhUomz'+row+'">'+Split_Value[1]+'</LABEL></TD>'
		+'<TD><LABEL id=TPricez'+row+' name="TPricez'+row+'">'+Split_Value[2]+'</LABEL></TD>'
		+'<TD><LABEL id=TDispQtyz'+row+' name="TDispQtyz'+row+'">'+Split_Value[3]+'</LABEL></TD>'
		+'<TD style="TEXT-ALIGN:right"><LABEL id=TDispMoneyz'+row+' name="TDispMoneyz'+row+'">'+Split_Value[4]+'</LABEL></TD>'
		+'<TD><INPUT id=TRetQtyz'+row+' style="FONT-SIZE:24px; HEIGHT:24px; WIDTH:58px" name=TRetQtyz'+row+' value='+Split_Value[5]+'></TD>'
		+'<TD><LABEL id=TRetMoneyz'+row+' name="TRetMoneyz'+row+'">'+Split_Value[6]+'</LABEL></TD>'
		+'<TD><LABEL id=TPhggz'+row+' name="TPhggz'+row+'">'+Split_Value[9]+'</LABEL></TD>'
		+'<TD><LABEL id=TIncDispBatCodez'+row+' name="TIncDispBatCodez'+row+'">'+Split_Value[11]+'</LABEL></TD>'
		+'<TD><INPUT id=TIncRetBatCodez'+row+' name=TIncRetBatCodez'+row+' value='+incRetBatCode+'></TD>'
	    tmphtml += "</TR>";
	}
	tbl.parentElement.innerHTML = headhtml + tmphtml+"</TBODY></table>";
	objtbl=document.getElementById('tDHCOutPhReturn');
	return ;	
}
function tAddRow(value){
	if (value=="") return ;	
	var tbl = document.getElementById("tDHCOutPhReturn");
	var row = tbl.rows.length;
	if (row>0){}else{row=1;}
	try {
		if (value!=""){	
		//alert("loopcount="+LoopCount);
        if (LoopCount!=1) AddRowToList(objtbl);
        LoopCount=LoopCount+1;
		var rows=objtbl.rows.length;
		var LastRow=rows - 1;
		var eSrc=objtbl.rows[LastRow];
		var RowObj=getRow(eSrc);
		var rowitems=RowObj.all;
		if (!rowitems) rowitems=RowObj.getElementsByTagName("label");
		
		for (var j=0;j<rowitems.length;j++) {
			if (rowitems[j].id) {
				var Id=rowitems[j].id;
				var arrId=Id.split("z");
				var Row=arrId[arrId.length-1];
			}
		}
		var Split_Value=value.split("^")
		
		document.getElementById("TPhdescz"+Row).innerText=(Split_Value[0]);
        document.getElementById("TPhUomz"+Row).innerText=(Split_Value[1]);
        document.getElementById("TPricez"+Row).innerText=(Split_Value[2]);
        document.getElementById("TDispQtyz"+Row).innerText=(Split_Value[3]);
        document.getElementById("TDispMoneyz"+Row).innerText=(Split_Value[4]);        
        document.getElementById("TRetMoneyz"+Row).innerText=(Split_Value[6]);
        document.getElementById("TPhggz"+Row).innerText=(Split_Value[9]);
        document.getElementById("TIncDispBatCodez"+Row).innerText=(Split_Value[11]);
        alert("Row="+Split_Value[5]);
		document.getElementById("TRetQtyz"+Row).value=(Split_Value[5]);
   	 	document.getElementById("TPhdItmz"+Row).value=(Split_Value[7]);
        document.getElementById("TPhUomidz"+Row).value=(Split_Value[8]);
        document.getElementById("TSeqNoz"+Row).value=(Split_Value[10]);
        if (Split_Value[11]=="欠药")
        {
	    	document.getElementById("TIncRetBatCodez"+Row).innerText="";
	    }
        else
        {
        	document.getElementById("TIncRetBatCodez"+Row).innerText=(Split_Value[11]);
        }
		}
	} catch(e) {};
	}

function tk_ResetRowItemst(objtbl) {
	for (var i=0;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		{if ((i+1)%2==0) {objrow.className="RowEven";} else {objrow.className="RowOdd";}}
		var rowitems=objrow.all; //IE only
		if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
		for (var j=0;j<rowitems.length;j++) {
			//alert(i+":"+j+":"+rowitems[j].id);
			if (rowitems[j].id) {
				var arrId=rowitems[j].id.split("z");
				//if (arrId[arrId.length-1]==i+1) break; //break out of j loop
				arrId[arrId.length-1]=i+1;
				rowitems[j].id=arrId.join("z");
				rowitems[j].name=arrId.join("z");
			}
		}
	}
}





function GPmino() {
  var plen=pmiobj.value.length
    var i
    if (plen==0) return;
    var lszero=""
 	if (plen>10){alert(t['03']);return;}
	 for (i=1;i<=10-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
	 var lspmino=lszero+pmiobj.value;
	 pmiobj.value=lspmino
	 GPatName(lspmino)
	// DHCMZYF_setfocus('CPrtinv');    

}

function GPatName(pmino)
{
    var pid=document.getElementById('gname');
	if (pid) {var encmeth=pid.value} else {var encmeth=''};
	p1=pmino;
	var ret= cspRunServerMethod(encmeth,'','',p1) ;
	if (ret==""){
		alert("无此患者")
	}
   
	SetPerName(ret);
}

function SetPerName(value)
{
	var pnameobj=document.getElementById("CName");
	var pageobj=document.getElementById("CAge");
	if (value=="")
	{
		alert(t['04']);
		pmiobj.value="";
		pnameobj.value="";
		if(pageobj){pageobj.value="";}
		return;
	}
	var tstr=value.split("^")
	
	pnameobj.value=tstr[0]
	if(pageobj)pageobj.value=tstr[1]
}

function GPrtPh()
{
 	
 var loc=ctlocobj.value
 var prt=prtobj.value
 if (prt=="") return;
 
 findobj=document.getElementById("find");
 findobj.onclick;
 
 
}

function GetWinPosCode(value)
{
  if (value=="") return;
  var BStr=value.split("^");
  var winposcode=document.getElementById("CWinPosCode");
  winposcode.value=BStr[1];
}

function GetRetMoney(objtbl,disqty,retqty,price,row)
{
var key=websys_getKey(e);
 if (key==13) {	
 } 	
}
function Reset_click()	
{
 location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhReturn";
 var retflagobj=document.getElementById('RetFlag');	
}

function GRetReasonID(value)
{
  var retreas=document.getElementById('CRetReasonid')	
  var vstr=value
  var sstr=vstr.split("^")
  retreas.value=sstr[1]
  if (objtbl.rows.length>1){
	   DHCMZYF_setfocus('TRetQtyz'+1);
	 var eSrc=tbl.rows[1];
     var RowObj=getRow(eSrc);
     SelectedRow=1;
	 RowObj.className="RowSelColor";
	   }
  else {DHCMZYF_setfocus('CPmino'); }
}
function tyyy_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		var url= 'websys.lookup.csp';
		url += '?ID=ld50091iCRetReason';
		url += '&CONTEXT=Kweb.DHCOutPhReturn:QueryRetReas';
		//url += '&TPAGCNT=1';
		url += '&TLUJSF=GRetReasonID';
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
	var obj=document.getElementById('CRetReason');
	if (obj) obj.onkeydown=tyyy_lookuphandler;

function prt_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		var url= 'websys.lookup.csp';
		url += '?ID=ld50091iCPrtinv';
		url += '&CONTEXT=Kweb.DHCOutPhReturn:QueryPRT';
		//url += '&TPAGCNT=1';
		url += '&TLUJSF=GPrtID';
		var obj=document.getElementById('ctloc');
		if (obj) url += '&P1=' + websys_escape(obj.value);
		var obj=document.getElementById('CDate');
		if (obj) url += '&P2=' + websys_escape(obj.value);
	    var obj=document.getElementById('CPmino');
		if (obj) url += '&P3=' + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
	var obj=document.getElementById('CPrtinv');
	if (obj) obj.onkeydown=prt_lookuphandler;



function GPrtID(value)
{
	
	var prt=document.getElementById('CPrt')
	var vstr=value
	var sstr=vstr.split("^")
	var yprtobj=document.getElementById('CPrtinv')
	var yprtinv=yprtobj.value
	var ReqNoList=document.getElementById('CReqNo');
	if (ReqNoList) ReqNoList.options.length=0;
	prt.value=sstr[3]
	var prescno=document.getElementById('CPrescNo')
	prescno.value=sstr[4]
	var dispdate=document.getElementById('CDispDate')
	dispdate.value=sstr[2]
	var newprt=document.getElementById('CNewPrt')
	newprt.value=sstr[5];
	CleartTbl();
	DHCMZYF_setfocus('find');
 
}

function Return_click()
{  
   var l=0
   var i,rn=0
     for (i=1;i<=objtbl.rows.length-1;i++)
     {
	   var uomdr="" ;
	   var tuomdrobj=document.getElementById('TPhdItmz'+i)
	   if (tuomdrobj)  {uomdr=tuomdrobj.value ;}
	   
	   if (uomdr=="") { alert("没有可退的药品名称");return}
	   
	   var retqty=document.getElementById('TRetQtyz'+i).value
	   var retmoney=document.getElementById('TRetMoneyz'+i).innerText
	   var price=document.getElementById('TPricez'+i).innerText
	   var retqtyobj=document.getElementById('TRetQtyz'+i)
	   var bat=""
	   var retbatobj=document.getElementById('TIncRetBatCodez'+i)
	   if (retbatobj) {var bat=retbatobj.value}
	   
	   var staus=document.getElementById('TIncDispBatCodez'+i).innerText
	   
	   if ((retqty>0)&&(staus!="欠药")){
		   
		   var totsum=parseFloat(retqty)*parseFloat(price) 
		   
		   var phditm=document.getElementById('TPhdItmz'+i).value
		   var getmethod=document.getElementById('CheckRetQty');
           if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
           var retval=cspRunServerMethod(encmeth,phditm,retqty)
           if (retval=="-1"){ rn=rn+1;}
		   
		   if (HospitalCode=="WF"){
		   	var retbat=document.getElementById('TIncRetBatCodez'+i).value
		   	//if (retbat==''){alert(t['notnull']);return;}
		  }
		   if (totsum.toFixed(2)!=parseFloat(retmoney).toFixed(2))
		   {
			    
			  // l=l+1; 
			    
		   }

			   
	     } 
     }
     if (l>0){alert(t['20']);return;}
    if (rn>0){alert(t['RetQtyMoreDisp']);return;}

  var newprt=document.getElementById('CNewPrt').value;
  var reqobj=document.getElementById('CurrReqNo')
  if (reqobj)var reqrow=document.getElementById('CurrReqNo').value;
  if (HospitalCode=="WF") {newprt=reqrow;}
  var getmethod=document.getElementById('CheckRet');
  if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
  if (cspRunServerMethod(encmeth,newprt)!='0'){alert(t['05']);return;}
  var retflag=document.getElementById('RetFlag');
	var rfr=document.getElementById('CRetReasonid').value;
	if (rfr=="") {alert(t['06']);return;}
	if (objtbl.rows.length==1){alert(t['07']);return;}
   var rows=objtbl.rows.length
   var i,j=0;
      for (i=1;i<=rows-1;i++){
	   	var retqty=document.getElementById('TRetQtyz'+i)
	   	if (retqty.value>0){j=j+1;}
	   	}
    //if (j==0) {alert(t['08']);ruturn ;}
    if (j==0) {alert("请录入退药数量后,重试.");return ;}
       for (i=1;i<=rows-1;i++){
	   	var retmoney=document.getElementById('TRetMoneyz'+i)
	   	var retqty=document.getElementById('TRetQtyz'+i)
	   	 
	   	if (retqty.value!=""){
		  
		   	if(retmoney.innerText>0){}
		   	else {alert(t['12']);return;}}
	   	}
	   	var Owflag=0
   for (i=1;i<=rows-1;i++){
		var staus=document.getElementById('TIncDispBatCodez'+i).innerText
		var RetBatCode=document.getElementById('TIncRetBatCodez'+i).value
		if ((staus=="欠药")&&(RetBatCode!="")) {
			document.getElementById('TIncRetBatCodez'+i).value=""
			Owflag=1
		}
	}
	if (Owflag==1) {alert("欠药不需填写批号"); return;}	
	var phditm=document.getElementById('TPhdItmz'+1) 
	var nprt=document.getElementById('CNewPrt').value 
	p1=ctlocobj.value;
	p2=useridobj.value;
	p3=phditm.value
	p4=rfr;
	p5=nprt
	var poscode=document.getElementById('CWinPosCode').value;
	var reqrow=""
	var retitminf=""
	retitminf=GetRetInf()
	var chowinfo=Getchowinfo()
	if ((retitminf=="")&&(chowinfo=="")){alert("请在需退药的记录中录入数量,批次,后重试");return;}
	var retrow=""
 	if (HospitalCode=="WF"){
  		reqrow=document.getElementById('CurrReqNo').value;
  	}
  	if(retitminf!=""){
		var getmethod=document.getElementById('returnph');
		if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
		var retval=cspRunServerMethod(encmeth,p1,p2,p3,p4,p5,poscode,reqrow,retitminf)
  	}
  var ret=0
  if(chowinfo!=""){
	  var ret=tkMakeServerCall("web.DHCOutPhReturn","DoChowReturn",reqrow,p2,chowinfo)
	  if (ret!=0){alert("欠药退药失败！错误代码:"+ret);return;}
	  else {alert("欠药退药成功！");}
  }
  
  if (retval=="-1"){alert(t['NoLevel']);return;}
  else if (retval=="-2"){alert(t['InsMainErr']);return;}
  else if (retval=="-3"){alert(t['ModReqErr']);return;}
  else if (retval=="-4"){alert(t['InsSubErr']);return;}
  else if (retval=="-6"){alert("发药科室与退药科室不一致，请核实！");return;}
  else if (retval=="-7"){alert("门诊配液退过一次药不允许再退！");return;}
  else {
	  OutPhReturnId=retval;
	  retrow=retval;
  }
  var retmx=0
  
  var BReturnobj=document.getElementById("BReturn"); 
  var card=document.getElementById('CardNo').value   
  var groupid=document.getElementById('groupid').value 
  var ctloc=document.getElementById('ctloc').value  
  var userid=document.getElementById('userid').value 
  var getmethod=document.getElementById('retmoney');
  if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
  var retval=cspRunServerMethod(encmeth,ctloc,userid,groupid,nprt,retrow,card)
  	switch (retval){
		case "300":
		  alert(t['21']);
		   break;
		case "200":
		   alert(t['23']);
		   break;
		case "0":
		   alert(t['22']);
		   break;
        case "100":
           alert(t['24']);
		   break;
  	}
  	 if (HospitalCode=="WF")
	 {
	 	var pmino=document.getElementById('CPmino').value
		 //GetValListbox(ctloc,pmino);
		 var ReqNoList=document.getElementById("CReqNo");
		if (ReqNoList.options.length>0)
		{
			GetPmiInfo();
		}
		DHCMZYF_setfocus('CReqNo');
	}
	DHCMZYF_setfocus('BPrint');

}
function RetRowid(value)
{
  var retval=0
  if (value==""){alert(t['09']);return;}	
  var retrowid=value
 var retinf=""
  
  var i,j=0,rows;
  rows=objtbl.rows.length-1
  for (i=1;i<=rows;i++){
   	var retqty=document.getElementById('TRetQtyz'+i).value
   	var retmoney=document.getElementById('TRetMoneyz'+i).innerText
   	if (retqty>0)
   	{
	  j=j+1;   	  
   	  var phditm=document.getElementById('TPhdItmz'+i).value   		 
      var unit=document.getElementById('TPhUomidz'+i).value    
      var getmethod=document.getElementById('returnphitm');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      p1=retrowid
      p2=phditm
      p3=retqty
      p4=retmoney
      p5=unit 
      p6=j
      if (cspRunServerMethod(encmeth,p1,p2,p3,p4,p5,p6)!='0')
      {
	  	alert(t['10']);
        retval=retval+1;
      }	
    }
      
    var retqtyobj=document.getElementById('TRetQtyz'+i)
    retqtyobj.readOnly=true
  }
   	
   return retval
   
}  	
function GetRetInf()
{
   var retinf=""
  var i,j=0,rows;
  rows=objtbl.rows.length-1
  
  for (i=1;i<=rows;i++){
   	var retqty=document.getElementById('TRetQtyz'+i).value
   	var retmoney=document.getElementById('TRetMoneyz'+i).innerText
   	if (retqty>0)
   	{
	   	var retbatcode=document.getElementById('TIncRetBatCodez'+i).value
 		if (retbatcode!="")
 		{
		   	j=j+1;
	   	    var phditm=document.getElementById('TPhdItmz'+i).value   		 
	        var unit=document.getElementById('TPhUomidz'+i).value 
	        if (retinf=="") {retinf=phditm+"^"+retqty+"^"+retmoney+"^"+unit+"^"+j;}
	        else
	      	{
	      		retinf=retinf+"&"+phditm+"^"+retqty+"^"+retmoney+"^"+unit+"^"+j;
	      	}
      	
 		}
    }
  }
   	
   return retinf
   
}

function GetPath() 
{  
   var getmethod=document.getElementById('printpath');
   if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
   if (cspRunServerMethod(encmeth,'Path','',p1)=='0'){}
   var printpath=Path
   return printpath;
}
function Path(value) 
{  
	return value;
}

function Print_click()
{   
	if(OutPhReturnId==""){
		alert("请先退药再打印");
	}
	PrintReturn(OutPhReturnId,"");

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
	 objtbl=document.getElementById('tDHCOPReturn');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	for (var j=1;j<lastrowindex+1;j++) {
		objtbl.deleteRow(1);
	//alert(j);
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
		var obj=document.getElementById("CReadCard");
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
		var obj=document.getElementById("CReadCard");
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

function loadCardType(){
	
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=document.getElementById("ReadCardTypeEncrypt").value;
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
		
	}
}

///LiangQiang 
///写入数量后自动写入金额
function WriteRetMoney(e){
	var key=websys_getKey(e);
	var Rows=objtbl.rows.length-1;
	CurrSrc=websys_getSrcElement();

	if (CurrSrc.id.split("z")[0]){
		if(CurrSrc.id.split("z")[0]=="TRetQty"){
			//////2014-12-09 ws 退药的品种有多个时特殊操作（选中输入框不松手，拖拽至其他地方）当录入数量大于发药数量时没有给出提示
			var currow=CurrSrc.id.split("z")[1]
			SelectedRow=currow;
			SelectRow(window)
			////////
			if (SelectedRow==0){SelectedRow=1;}
			var disqty=document.getElementById('TDispQtyz'+SelectedRow)
			var price=document.getElementById('TPricez'+SelectedRow)
			var retqty=document.getElementById('TRetQtyz'+SelectedRow)
			var retmoney=document.getElementById('TRetMoneyz'+SelectedRow)
			var gretqty=retqty.value
			if (retqty.value!=parseInt(gretqty)) {retqty.value="";retmoney.innerText="";return;}
			if (retqty.value<=0) {alert("退药数量录入有误,请检查");retqty.value="";retmoney.innerText="";return;}
			if (eval(retqty.value)>eval(disqty.innerText)) {alert(t['02']);retqty.value="";retmoney.innerText="";return;} 
			var sum=(retqty.value)*(price.innerText)
			retmoney.innerText=sum.toFixed(2)
			/// 按回车键时，焦点跳转到批号栏 bianshuai 2015-12-08
			if(key == "13"){
				DHCMZYF_setfocus('TIncRetBatCodez'+SelectedRow);
			}
		}
	}
}

function GetPrescNotPrtLoop(value)
{
  var prescobj=document.getElementById('CPrescNo')
  prescobj.value=value.split("^")[1]
  var notprescobj=document.getElementById('NotPrescNo')
  notprescobj.value=value.split("^")[1] 
  var dispdate=document.getElementById('CDispDate')
  dispdate.value=sstr[0]
  
  DHCMZYF_setfocus('find');	
}


function Getchowinfo()
{
  var chowinfo=""
  var i,j=0,rows;
  rows=objtbl.rows.length-1
  
  for (i=1;i<=rows;i++){
   	var retqty=document.getElementById('TRetQtyz'+i).value
   	var retmoney=document.getElementById('TRetMoneyz'+i).innerText
   	if (retqty>0)
   	{
	   	var retbatcode=document.getElementById('TIncRetBatCodez'+i).value
	   	var staus=document.getElementById('TIncDispBatCodez'+i).innerText
 		if (staus=="欠药")
 		{
		   	j=j+1;
	   	    var phditm=document.getElementById('TPhdItmz'+i).value   		 
	        var unit=document.getElementById('TPhUomidz'+i).value 
	        if (chowinfo=="") {chowinfo=phditm;}
	        else
	      	{
	      		chowinfo=chowinfo+"&"+phditm;
	      	}
      	
 		}
    }
  }
   	
   return chowinfo
   
}


document.body.onload = BodyLoadHandler;

