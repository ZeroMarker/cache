/// Name: dhcpha.pharetrequest.js
/// NeedSeek 为空查询
function BodyLoadHandler()
{
 GetDefaultPhaloc();
 var obj;
 var obj=document.getElementById("SetDefaultLoc");
 if (obj)  obj.onclick=SetDefaultLoc;
 obj=document.getElementById("Clear") ;
 if (obj) obj.onclick=ClearClick;
 obj=document.getElementById("Query") ;
 if (obj) obj.onclick=QueryClick;
 obj=document.getElementById("Exit") ;
 if (obj) obj.onclick=ExitClick;
 obj=document.getElementById("SeekDisp") ;
 if (obj) obj.onclick=SeekDispClick;
 //obj=document.getElementById("RegNo") ;
 //if (obj) obj.onblur=RegNoBlur; 
 //if (obj) obj.onkeydown=RegNoEnter;
 obj=document.getElementById("Adm") ;
 if (obj) obj.onchange=AdmClick; 
 obj=document.getElementById("Ok") ;
 if (obj) obj.onclick=OKClick; 
 //obj=document.getElementById("SaveRequest") ;
 // if (obj) obj.onclick=SaveClick; 
 obj=document.getElementById("AddToPhaReturn") ;
 if (obj) obj.onclick=AddClick; 
 
 obj=document.getElementById("Name")
 if (obj) obj.readOnly=true ;
 obj=document.getElementById("Age")
 if (obj) obj.readOnly=true ;
 obj=document.getElementById("Sex")
 if (obj) obj.readOnly=true ;

 var obj=document.getElementById("DispLoc"); //2005-05-26
 if (obj) 
 {obj.onkeydown=popDispLoc;
  obj.onblur=DispLocCheck;
 } //2005-05-26
    
 //var obj=document.getElementById("RegNo") ;
 //if (obj)
 //{if (obj.value!="") RegNoBlur(); }
 
 var obj=document.getElementById("t"+"dhcpha_pharetrequest")
 if (obj) {
	 obj.onkeydown=RetReasonEnter;
	 obj.onkeyup=CheckRetQTy;
	 }
 var obj=document.getElementById("SetAllQty")
 if (obj) obj.onclick=SetAllQty;
 
 var obj=document.getElementById("SetNoneQty")
 if (obj) obj.onclick=SetNoneQty;
 
 var obj=document.getElementById("RegNo"); //2005-05-26
 if (obj) 
 {
 	if (obj.value!="")
	{
			 
	}
	else
	{
		obj.value=GetRegNoByEpisodeID()
	}
	RegNoBlur();
	obj.onkeydown=popRegNo;
	obj.onblur=RegNoCheck;
 }	 
}

function SetDefaultLoc()
{
   
   var obj=document.getElementById("displocrowid");
   if (obj)
   {
	   var displocrowid =obj.value
	   if (displocrowid=="")
	   {
		   //alert("请先选择发药科室")
		   //return;
	   }
   }
    //var grpid=session['LOGON.GROUPID'] ;
    var grpid=session['LOGON.CTLOCID'] ;
    if (grpid==""){return;}
    
    var obj=document.getElementById("DispLoc");
    var locdesc=obj.value
    if (confirm("确认将 " + locdesc +" 设置成默认科室吗?")==false)  return ; 
    
    var getadm=document.getElementById("mSetDefaultPhaLoc");
	if (getadm) {var encmeth=getadm.value} else {var encmeth=''};
	var ret=cspRunServerMethod(encmeth,displocrowid,grpid)  ;
	
	if (ret==0){alert("设置成功")}
   
   
}

function GetRegNoByEpisodeID()

{
	var objadm=document.getElementById("AdmNo")
	var adm=objadm.value
	var getpa=document.getElementById('mGetRegNoByEpisodeID');
	if (getpa) {var encmeth=getpa.value} else {var encmeth=''};
	var regno=cspRunServerMethod(encmeth,adm)
	return regno
	
}
function DispLocCheck()
{
	// 2006-05-26
	var obj=document.getElementById("DispLoc");
	var obj2=document.getElementById("displocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}// 2006-05-26
function popDispLoc()
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DispLoc_lookuphandler();
		}
}//2006-05-26

function RegNoEnter()
{ 
	if (window.event.keyCode==13) 
		{RegNoBlur();}
	else
		{var obj=document.getElementById("RegNo")
		 if(isNaN(obj.value)==true)  { obj.value="" ;}
			}
}

function RegNoCheck()
{
	var obj=document.getElementById("RegNo");
    if (obj.value!="") {RegNoBlur(obj.value)}
	
}
function popRegNo()
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   var obj=document.getElementById("RegNo");
	   RegNo_lookuphandler();
		}
}
function RegNoLookUpSelect(str)
{	
	 var ss=str.split("^") ;	
	 if ( ss.length>0) 
	 { 
	    var obj=document.getElementById("RegNo") ;
	    if (obj) obj.value=ss[0] ; 
	    RegNoBlur(ss[0])
	 }
}
function popTReason()
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   TReason_lookuphandler();
		}
	
}
function ClickPopTReason()
{ 
	   TReason_lookuphandler();

}
function TReasonLookUpSelect(str)
{	

	 var ss=str.split("^") ;	
	 if ( ss.length>0) 
	 {  
	    var obj=document.getElementById("currentRow") ;
	    if (obj) row=obj.value
	    var obj=document.getElementById("TReasonDR"+"z"+row)
		if (obj) obj.value=ss[1];
		var obj=document.getElementById("TReason"+"z"+row)
		if (obj) obj.value=ss[0];
	 }
 
}

function ClearClick()
{
	//ClearField("RegNo") ;
	//ClearField("Name") ;
	//ClearField("Sex") ;
	//ClearField("Age") ;
	//ClearField("Adm") ;
	//ClearField("RetReqQty") ;
	//ClearField("displocrowid") ;
	//ClearField("DispLoc") ;
	
	//var obj=document.getElementById("Adm")
	//if (obj)	obj.options.length=0 ;

	//var objtbl=document.getElementById("t"+"dhcpha_pharetrequest") ;
	//if (objtbl) DelAllRows(objtbl) ;
	
	var obj=document.getElementById("DispLoc")
	if (obj) var disploc=obj.value;
	
	var obj=document.getElementById("displocrowid")
	if (obj) var displocrowid=obj.value;

	parent.frames['x'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.pharetrequest&DispLoc="+disploc+"&displocrowid="+displocrowid
	parent.frames['y'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.pharetrequestitm"
	
}
function AdmClick()
{
	var obj=document.getElementById("Adm");
	if (obj.selectedIndex>=0){
	//var xx=obj.options[obj.selectedIndex].text ;
	var xx=obj.value;
	var obj1=document.getElementById("AdmNo");
	if (xx!="") {
	//var ss=xx.split(" .. ");
	//if (obj1) obj1.value=ss[0];
		obj1.value=xx;
	//	alert(obj1.value);
	 } }

}

function ClearField(ss)
{	var obj; 
	obj = document.getElementById(ss) ;
	if (obj) obj.value="" ;
}

function QueryClick()
	{RetRequestQuery() ;}
function ExitClick()
	{history.back();}
function SeekDispClick(){

	if (CheckConPriorSeekDisp()==false) return ;	
	var obj=document.getElementById("RegNo") ;
	if (obj) var regno=obj.value; 
	var obj=document.getElementById("Adm") ;
	if (obj) var admno=obj.value;
	//alert(admno); 
	var obj=document.getElementById("displocrowid") ;
	if (obj) var displocrowid=obj.value; 
	
	var obj=document.getElementById("userlocid") ;
	if (obj) var userlocid=obj.value;
	//alert(userlocid);
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.pharetrequest&RegNo="+regno + "&AdmNo="+admno+"&displocrowid="+displocrowid;
	//alert(lnk) ;
	//location.href=lnk;
	//window.open(lnk) ;
	
	SeekDisp_click();
}
function CheckConPriorSeekDisp()
{// check the query condition prior finding dispen
	var obj=document.getElementById("displocrowid");
	if (obj) {
		/*if (obj.value=="") {
			alert(t['NO_RETLOC'] ) ;
			return false;  
		}*/ 
	}
	var obj=document.getElementById("RegNo");
	if (obj)
	{if (obj.value=="" ) {
	  alert(t['NO_REGNO']);
	  return false;	  
	  }	  }
	var obj=document.getElementById("Adm");
	if (obj)
	{if (obj.length==0 ) {
	  alert(t['NO_ADM']);
	  return false;	  
	  }	  }
  	
}
function RegNoBlur()
{
	//when RegNo lost focus then this event fires .
	var obj=document.getElementById("RegNo") ;
	var regno,displocrowid ;
	if (obj)
	{ 
	 regno=obj.value ;
	 if (regno=="")
	 {	
	 	ClearField("Name") ;
		ClearField("Sex") ;
		ClearField("Age") ;
		//ClearField("Adm") ;
		
	 	return ;}
	 else
	 {obj.value=getRegNo(regno) ;
	  regno=obj.value ; }
	}
	//set patient info
    var getpa=document.getElementById('mGetPa');
	if (getpa) {var encmeth=getpa.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetPa','',regno)=='0') {}  
	
	var obj=document.getElementById("Adm")
	if (obj)	obj.options.length=0 ;
	//
    var getadm=document.getElementById('mGetAdm');
	if (getadm) {var encmeth=getadm.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetAdm','',regno)=='0') {}  
		
 }	
function OKClick()
{//update the return qty 
 //get return qty
	if (ValidateReqQty()==false) return ;
	
	var obj=document.getElementById("RetReqQty") ;
	var retqty=obj.value ;
	var obj=document.getElementById("currentRow") ;
	var row=obj.value ;

	var obj=document.getElementById("TReqQtyz"+row) ;
	if (obj)
	{obj.innerText=retqty;	}   //update the return qty .
}
function ValidateReqQty()
{//
	var obj=document.getElementById("RetReqQty")
	if (obj) {
		var reqqty=obj.value ;
		if (reqqty<=0)
		{alert(t['INVALID_QTY']) ;
		 return false;		}		}
	
	var obj=document.getElementById("currentRow") ;
	if (obj)
	{
		var row=obj.value;
		if (row<1)
		{
			alert(t['NO_ROW_SELECTED'])	
			return false ;
			}
		var objitem=document.getElementById("Toedisz"+row) ;
		 if (objitem){
			 //alert(reqqty) ;
			 var oedis=objitem.value;
			 //alert(oedis)
			if (allowReturn(oedis,reqqty)==false )
			{alert(t['RETQTY_TOOLARGE']) ;
			 return false;				}
			 	}
		 else 
		 	{ 	alert(t['NO_OBJECT'])
			 	return false;
		 	}
	}
	else
		{
		alert(t['NO_OBJECT'])	
		return false ;
		}
	return true;	
}
function DHCWeb_GetRowIdx(wobj)
{
	var eSrc=wobj.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	return 	selectrow
}
function SetPa(value)
{
  //set patient info of compoment
	var painfo=value.split("^")	;
	var obj;
	obj=document.getElementById("Name");
	if (obj) obj.value=painfo[0];
	obj=document.getElementById("Sex");
	if (obj) obj.value=painfo[1];
	obj=document.getElementById("Age");
	if (obj) obj.value=painfo[2];
}
function SetAdm(value)
{ 
	var ss=value.split("^") ;
	if (ss.length<1) return ;
	var obj=document.getElementById("Adm") ;
	if (obj)  obj.options.length=0 ;

	var i;
	for (i=0;i<ss.length;i++) 
	{if (obj)
		{var admno=ss[i].split(" .. ")
			obj.options[i]=new Option (ss[i],admno[0]) ;}
	}
	if (obj.length>0) {
		obj.options.selectedIndex=0 ;
			var NeedSeek=document.getElementById("NeedSeek").value;
			if (NeedSeek!=""){
				return;
			}
			document.getElementById("NeedSeek").value=1
			SeekDispClick();

	}
	
}
function DispLocLookUpSelect(str)
{
	
	var ss=str.split("^") ;
	
 if ( ss.length>0) 
 { 
  var obj=document.getElementById("displocrowid") ;
  if (obj) obj.value=ss[1] ; // rowid of the disp loc
  ReLoadReqItm();
  }
  
}

function RetRequestQuery()
{
	var objadm=document.getElementById("AdmNo");
	var adm=objadm.value;
	var lnk="dhcpha.seekpharetrequest.csp?EpisodeID="+adm; 
	window.open(lnk,"_blank","height=500,width=800,menubar=no,status=no,toolbar=no,resizable=yes");
}

function SaveClick()
{ // Save the request into table DHC_PhaRetRequest
	
	}
function AddClick()
{
	var obj1=document.getElementById("t"+"dhcpha_pharetrequest") ;
    if (obj1)  var rowcount=getRowcount(obj1) ;
	if (rowcount<1) {
		alert(t['NO_ANYROWS']) ;
		return ;	
	}
	var chktrue=0;
	var itmobjtbl=parent.frames['y'].document.getElementById("tdhcpha_pharetrequestitm") ;
	var itmrowcount=getRowcount(itmobjtbl);
	var itmreclocdr="";
	if (itmrowcount>1){
		itmreclocdr=parent.frames['y'].document.getElementById("TRecLocDrz"+1).value;
	}
	var canreq=0,tmpreclocdr="";
	for (var i=1;i<=rowcount;i++)
	{
		if  (checkReason(i)==true)
		{	
			chktrue=1;
			var reclocdr=document.getElementById("TRecLocDrz"+i).value;
			if ((tmpreclocdr!="")&&(tmpreclocdr!=reclocdr)){
				canreq=1;
				break;
			}
			if ((itmreclocdr!="")&&(itmreclocdr!=reclocdr)){
				canreq=2;
				break;
			}
			var incicode=document.getElementById("Titmcodez"+i).value;
			var refrefuseflag=tkMakeServerCall("web.DHCST.ARCALIAS","GetRefReasonByCode",incicode);
			if (refrefuseflag!=""){
				if (refrefuseflag.split("^")[3]!=""){
					alert("第"+i+"行药品"+refrefuseflag.split("^")[1]+",在药品基础数据中目前为不可退药状态,不能申请!\n不可退药原因:"+refrefuseflag.split("^")[3]);
					canreq=4;
					break;
				}			
			}
			tmpreclocdr=reclocdr;
		}		
	}
	if (canreq==1){
		alert("第"+i+"行发药科室与其他记录不一样!");
		return;
	}else if (canreq==2){
		alert("第"+i+"行发药科室与退药申请列表发药科室不一样!");
		return;	
	}else if (canreq==4){
		return;
	}
	if (chktrue==0){
		alert("退药原因必须录入,请重试..");
		return;
	}
	for (var i=1;i<=rowcount;i++)
	{
		var obj=document.getElementById("TReqQtyz"+i);
	    var reqqty= obj.value
		
		if ((obj)&&(obj.value>0)) 
		{
			var obj=document.getElementById("Toedisz"+i);
			if (obj) oedis=obj.value;
			//if (allowAdd(oedis)==false) break ;
			//
			var obj=document.getElementById("Tdspidz"+ i) ;
	        if (obj) var dspid=obj.value;
	        // add by MaYuqiang 20171222 根据打包表判断发药类别和发药科室
	        var RequestFlag=tkMakeServerCall("web.DHCSTRETREQUEST","GetRequestFlagbyDsp",dspid)
	        if  (RequestFlag!="1")
				{
			     alert("第" + i + "行药品的发药类别在对应科室不能做退药申请，如需修改请在<住院发药科室维护下方发药类别>处修改！")
			     return;
				}
	       
			if (allowAdd(oedis,dspid)==true) 
			{   
				if (RetReqExists(dspid)==true)
					{ 
					var msg=t['RETREQ_EXISTS2'] + " RowNo : " + i ;
				    alert(msg);
					 break ;

					 }
				if  (allowReturn(dspid,reqqty)==false)
					     {   ///lq 08-11-14
						     alert("申请数量 > 退药数量 ,请刷新后再试!"+ " RowNo : " + i)
						     return;
				 }
				 
				if  (checkReason(i)==false)
				{
					continue;
				}
				 	 	
				AddRowToRetReq(i);
			} 
		}
	}
	
}


function checkReason(i)
{
	reason=""
	var obj=document.getElementById("TReason"+"z"+ i) ;
	if (obj) 	 var reason=obj.value;
    if (reason=="")
    {
	    
	    return false;
    }
    else
    {
	    return true;
    }
}
function AddRowToRetReq(sourceRowNo)
{
 	
	//get the field value of the row
	var obj=document.getElementById("TRegNo"+"z"+ sourceRowNo) ;
	if (obj) var regno=obj.innerText;
	var obj=document.getElementById("TName"+"z"+sourceRowNo) ;
	if (obj)  var name=obj.innerText;
	var obj=document.getElementById("TPrescNo"+"z"+ sourceRowNo) ;
	if (obj)  var prescno=obj.innerText;
	var obj=document.getElementById("TDesc"+"z"+ sourceRowNo) ;
	if (obj)  var desc=obj.innerText;
	var obj=document.getElementById("Titmcode"+"z"+ sourceRowNo) ;
    if (obj)  var code=obj.value;
	var obj=document.getElementById("TDispQty"+"z"+ sourceRowNo) ;
	if (obj)  var dispqty=obj.innerText;
	var obj=document.getElementById("TReqQty"+"z"+ sourceRowNo) ;
	if (obj)  var reqqty=obj.value;
	var obj=document.getElementById("TUom"+"z"+ sourceRowNo) ;
	if (obj)  var uom=obj.innerText;
	var obj=document.getElementById("TStatus"+"z"+ sourceRowNo) ;
	if (obj)  var status=obj.innerText;
	var obj=document.getElementById("Toedis"+"z"+ sourceRowNo) ;
	if (obj)  var oedis=obj.value;
	
	var obj=document.getElementById("TReason"+"z"+ sourceRowNo) ;
	if (obj) 	 var reason=obj.value;
	
	var obj=document.getElementById("TReasonDR"+"z"+ sourceRowNo) ;
	if (obj)  var reasonDr=obj.value;
	
	
	
	var obj=document.getElementById("Tdspid"+"z"+ sourceRowNo) ;
	if (obj) var dspid=obj.value;  //发药子表rowid lq add 009/09/09
	
	
  	var objtbl=parent.frames['y'].document.getElementById("tdhcpha_pharetrequestitm") ;
 
 	if (objtbl)  tAddRow(objtbl) ;
 	var cnt=getRowcount(objtbl);

 	var r=cnt-1;
 	
 	//
	var docu=parent.frames['y'].document;
	if (docu) {
		
	
		var obj=docu.getElementById("Tdspid"+"z"+ r) ;
	    if (obj) {
			        var dodis=obj.value ;
		           if (dodis!=""){var r=r+1;}
	             }
	
 		var obj=docu.getElementById("TRegNo"+"z"+ r) ;
		if (obj)  obj.innerText=regno		
		var obj=docu.getElementById("TPrescNo"+"z"+ r) ;
		if (obj) obj.innerText=prescno ;
		var obj=docu.getElementById("TDesc"+"z"+ r) ;
		if (obj) obj.innerText=desc ;
		var obj=docu.getElementById("TUom"+"z"+ r) ;
		if (obj) obj.innerText=uom ;
		var obj=docu.getElementById("TDispQty"+"z"+ r) ;
		if (obj) obj.innerText=dispqty ;
		var obj=docu.getElementById("TReqQty"+"z"+ r) ;
		if (obj) obj.innerText=trim(reqqty) ;
		var obj=docu.getElementById("TSalePrice"+"z"+ r) ;
		//var sp=getSalePrice(desc,uom)  //the sale price
		//var sp=getSalePrice(code,uom)
		
		var sp=getSalePrice(dspid) 
		if (obj) obj.innerText=sp  ;
		var spamt=accMul(sp,reqqty); //((sp*1000)*(reqqty*10))/10000;
		var spamt=spamt.toFixed(2);
		var obj=docu.getElementById("TSalePriceAmt"+"z"+ r) ;
		if (obj) obj.innerText=spamt ;
		//
		var obj=docu.getElementById("TRetReason"+"z"+ r) ;
		if (obj) obj.innerText=reason ;
		var obj=docu.getElementById("TRetReasonDR"+"z"+ r) ;
		if (obj) obj.value=reasonDr ;
		//
        
        var obj=docu.getElementById("Tdspid"+"z"+ r) ;
		if (obj) obj.value=dspid ;//发药主表rowid lq add 2007/09/29
		//
		var adm=getAdmByDsp(oedis) ;
		//
		var ss=adm.split("^") ;
		var recdeptdr=ss[0];
		var admdr=ss[1];
		var admlocdr=ss[2];
		var warddr=ss[3];
		var beddr=ss[4];
		var doctorDr=ss[5];
		//
		var obj=docu.getElementById("TDoctor"+"z"+ r) ;
		if (obj) obj.innerText=doctorDr ;
		var obj=docu.getElementById("TRecLocDr"+"z"+ r) ;
		if (obj) obj.innerText=recdeptdr ;
		var obj=docu.getElementById("TWardDr"+"z"+ r) ;
		if (obj) obj.innerText=warddr ;
		var obj=docu.getElementById("TBedDr"+"z"+ r) ;
		if (obj) obj.innerText=beddr ;
		var obj=docu.getElementById("TDspDr"+"z"+ r) ;
		if (obj) obj.innerText=oedis ;
		var obj=docu.getElementById("TAdmLocDR"+"z"+ r) ;
		if (obj) obj.innerText=admlocdr ;
		var obj=docu.getElementById("TAdmdr"+"z"+ r) ;
		if (obj) obj.innerText=admdr ;	
		}
	    //clear the last row
	  //  var cnt=getRowcount(objtbl);
}

function SelectRowHandler() {
	var row=DHCWeb_GetRowIdx(window);
	var obj=document.getElementById("currentRow") ;
	if (obj) obj.value=row
	RetReasonClick();
}
function getSalePriceOld(desc,uomdesc)
{
	var getsp=document.getElementById("mGetItmSp");
	if (getsp) {var encmeth=getsp.value} else {var encmeth=''};
	var sp=cspRunServerMethod(encmeth,'','',desc,uomdesc)  ;
	return sp;
}
function getSalePrice(pharowid)
{
	var getsp=document.getElementById("mGetItmSp");
	if (getsp) {var encmeth=getsp.value} else {var encmeth=''};
	var sp=cspRunServerMethod(encmeth,pharowid)  ;
	return sp;
}
function allowReturn(dspid,retreqqty)
	{//根据已发药和已退药情况决定是否允许此次的退药
	 //oedis : rowid of OE_Dispensing
	 //retreqqty : quantity of requiring returned
	var validQty=document.getElementById("mValidateReqQty");
	if (validQty) {var encmeth=validQty.value} else {var encmeth=''};
	var result=cspRunServerMethod(encmeth,'','',dspid,retreqqty)  ;
	
	 if (result==0)
	 	 {return false }
	 else
 		{return true };
	}
function allowAdd(oedis,phacidr)
{  //if the oedis has already existed in the returning list
	var docu=parent.frames['y'].document;
	if (docu)
	{
		var objtbl=docu.getElementById("t"+"dhcpha_pharetrequestitm");
		if (objtbl){rowcount=getRowcount(objtbl);}
		else {
			alert(t['NO_OBJECT']) ;
			return false ; }
		for (var i=1;i<=rowcount;i++)
		{
			var obj=docu.getElementById("TDspDrz"+i);
			 if (obj) {
				  dsp=obj.value ;
				  
				  var objphac=docu.getElementById("Tdspidz"+i);
				  phac=objphac.value ;

				  if ( (oedis==dsp)&&(phac==phacidr)  )
				   {	
					    return false ;}
				 }
			 else
				 {//alert(t['NO_OBJECT']) ;
				  //return false;	 
				  }
		}
	}
	else
		{alert(t['NO_OBJECT']) ;
			return false;		}
	return true ;
}
function RetReqExists(dodis)
{
	var obj=document.getElementById("mRetReqExists") ;
	if (obj) {var encmeth=obj.value} else {var encmeth=''}
	var exists=cspRunServerMethod(encmeth,dodis)  ; 
	if (exists!="") return true ;
	return false ;
}

function getAdmByDsp(oedis)
{
	var getadm=document.getElementById("mGetAdmByDsp");
	if (getadm) {var encmeth=getadm.value} else {var encmeth=''};
	var adm=cspRunServerMethod(encmeth,'','',oedis)  ;
	return adm;
}
function RetReasonEnter(e)
{
  var obj=websys_getSrcElement(e)
  var selindex=obj.id;
  var ss
  ss=selindex.split("z")

  if (ss.length>0)	  
	   {	
		    if (ss[0]=="TReason")
			 { 
	             var obj=document.getElementById("currentRow") ;
	             if (obj)  var poprow=obj.value;
	             var obj=document.getElementById("TReason"+"z"+poprow);
				 if (obj) 
				 { 
				    popTReason();
				 }
			 }
            if (ss[0]=="TReqQty")
            {
	            var row=DHCWeb_GetRowIdx(window);
	            var obj=document.getElementById("currentRow") ;
	            if (obj) obj.value=row
	        }
		 
	   }
 
}

function   dhcpha_getSrcElement(e)
{ 
    ///Liang Qiang 模仿公用
	if (window.event)
		return window.event.srcElement;
	else {
		return e.target;
	      }
}

function RetReasonClick(e)
{
  var obj=dhcpha_getSrcElement(e)
 
  var selindex=obj.id;
  var ss
  ss=selindex.split("z")
  
  if (ss.length>0)	  
	   {	
	        if (ss[0]=="TReason") { return} ;
            var findflag=ss[0].indexOf("TReason")
		    if (findflag>=0)
			   {
				   
				 var obj=document.getElementById("currentRow") ;
	             if (obj)  var poprow=obj.value;
	             
				 var obj=document.getElementById("TReason"+"z"+poprow);
				 if (obj) 
					 { 
						  ClickPopTReason();
					 }
			   }
		 
	   }
 
}
function RetReasonEnterOld(e)
{
  var obj=websys_getSrcElement(e)
  var selindex=obj.id;
  var ss
  
  ss=selindex.split("z")

  if (window.event.keyCode==13) 
  {
	  if (ss.length>0)
	   {if (ss[0]=="TReason")
		 { 
		 	var obj=document.getElementById("currentRow") ;
			if (obj) var row=obj.value;
	
			var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha_setpharetreason&MainCurrentRow="+row
			window.open(lnk,"_target","width=500,height=300")

		 }
	   }
   }
}

function CheckRetQTy(e)
{
  var obj=websys_getSrcElement(e)
  var selindex=obj.id;
  var ss;
  var dspqty=0;
  var reqqty=0;
  ss=selindex.split("z")
  if (ss.length>0)
   {
	
   if (ss[0]=="TReqQty")
   {   
	 	var obj=document.getElementById("currentRow") ;
		if (obj) var row=obj.value;
	    var objretqty=document.getElementById("TReqQty"+"z"+row) ;
	    var objdispqty=document.getElementById("TDispQty"+"z"+row) ;
	    var objdodis=document.getElementById("Tdspid"+"z"+row) ;
	    var dspid="";
	    if(objdodis)
	    { 
	    	dspid=objdodis.value;	    
	    }
	    	  
	    if (objretqty)
	    {
		    reqqty=objretqty.value;
		    if (isNaN(objretqty.value))
			{
				objretqty.value=""
				return ;
			}
	    }
	    if (objdispqty)
	    {  
	    	dspqty=objdispqty.innerText;
			if (parseFloat(dspqty)<parseFloat(reqqty))
		   {
				alert(t['RETQTY_TOOLARGE']);
				objretqty.value=""
				return ;
			}
		}
 		/*var IfONE=CheckPrioirty(dspid);
		if((IfONE!=1)&&(reqqty!=dspqty))
		{
			alert("非取药医嘱或出院带药，不能部分退药！");
		    objretqty.value=dspqty;
		}*/ //yunhaibao20161024,对于医嘱类型不控制
		//zhouyg 20150106 出院带药或取药医嘱，并且没有附加收费项目的才可以部分退药
		var PartFlag=CheckRetPart(dspid,parseFloat(reqqty))
		if (PartFlag=="0")
		{						
			alert("此记录有附加收费项目，不能部分退药!");
			objretqty.value="";
			return ;	
		}
    }
   if (ss[0]=="TReason")
   {	
    	var obj=document.getElementById("currentRow") ;
		if (obj) var row=obj.value;
	    var objreason=document.getElementById("TReason"+"z"+row) ;
	    if (objreason) objreason.value=""
    }
   }
}

function CheckPrioirty(dodis)
{
	
	var objPriority=document.getElementById("mCheckPriority") ;
	if (objPriority) {var encmeth=objPriority.value;} else {var encmeth='';}
  	var oneflag=cspRunServerMethod(encmeth,dodis)     //是否取药医嘱
  	return oneflag
}
///是否允许部分退药
///1-可以修改退药，0-不可以修改退药
function CheckRetPart(dodis)
{
	var objmPartFlag=document.getElementById("mGetRetPartFlag") ;
	if (objmPartFlag) {var encmeth=objmPartFlag.value;} else {var encmeth='';}
  	var Retflag=cspRunServerMethod(encmeth,dodis);     //是否取药医嘱
  	return Retflag;
}

function SetAllQty()
{
  	var rowcnt;
  	var obj=document.getElementById("t"+"dhcpha_pharetrequest")
  	if (obj) rowcnt=getRowcount(obj)

  	for (var i=1;i<=rowcnt;i++)
  	{
	  	var obj=document.getElementById("TDispQty"+"z"+i)
	  	var obj2=document.getElementById("TReqQty"+"z"+i)
	  	if ((obj)&&(obj2)) obj2.innerText=obj.innerText;	
	}
}
function SetNoneQty()
{
  	var rowcnt;
  	var obj=document.getElementById("t"+"dhcpha_pharetrequest")
  	if (obj) rowcnt=getRowcount(obj)
  	
  	for (var i=1;i<=rowcnt;i++)
  	{
	  	var obj2=document.getElementById("TReqQty"+"z"+i)
	  	if (obj2) obj2.innerText="";
	}
}
function ReLoadReqItm()
{
//	var xxx="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.pharetrequestitm" ;
	//parent.frames['y'].location.href=xxx;
	parent.frames['y'].location.reload();
}

function GetDefaultPhaloc()
{
 
      var objdisplocid=document.getElementById("displocrowid");
      if (objdisplocid.value=="")
     {
		  var str= GetDefaultPhaLocConfig()
	      DefaultStr=str.split("^")
	      var DefaultPhalocDesc=DefaultStr[1]
	      if (DefaultPhalocDesc=="") {return;} 
	      var DefaultPhalocID=DefaultStr[0]
	      if (DefaultPhalocID=="") {return;} 
		  objdisplocid.value=DefaultPhalocID
		  var obj=document.getElementById("DispLoc");
	      obj.value=DefaultPhalocDesc
	 }	 

}

function GetDefaultPhaLocConfig()
{
  ///Description:取默认发药药房配置
  ///Input:item
  ///Return:config
  ///Creator:LQ 2009-08-10
  //var grpid=session['LOGON.GROUPID'] ;
  var grpid=session['LOGON.CTLOCID'] ;
  var docu=parent.frames['dhcpha.getphaconfig'].document
  var obj=docu.getElementById("GetDefaulPhaLoc")
  if (obj) {var encmeth=obj.value;} else {var encmeth='';}
  var config=cspRunServerMethod(encmeth,grpid)
  return config

}
function accMul(arg1,arg2) 
{ 
	var m=0,s1=arg1.toString(),s2=arg2.toString(); 
	try{m+=s1.split(".")[1].length}catch(e){} 
	try{m+=s2.split(".")[1].length}catch(e){} 
	return Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m) 
} 
document.body.onload=BodyLoadHandler;
