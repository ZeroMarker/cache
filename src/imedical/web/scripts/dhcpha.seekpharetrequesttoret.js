 // dhcpha.seekpharetrequesttoret.js
function BodyLoadHandler()
{
	 var obj;
	
	 obj=document.getElementById("Clear") ;
	 if (obj) obj.onclick=ClearClick;
	 obj=document.getElementById("Seek") ;
	 if (obj) obj.onclick=SeekClick;
	 obj=document.getElementById("Cancel") ;
	 if (obj) obj.onclick=CancelClick;
	 obj=document.getElementById("Print") ;
	 if (obj) obj.onclick=PrintClick;

	var obj=document.getElementById("ReturnLoc"); //2005-06-06
	if (obj) 
	{obj.onkeydown=popReturnLoc;
	 obj.onblur=ReturnLocCheck;
	} //2005-06-06
	var obj=document.getElementById("Ward"); //2005-06-06
	if (obj) 
	{obj.onkeydown=popWard;
	 obj.onblur=WardCheck;
	} //2005-06-06

	 var obj=document.getElementById("PARegNo") ;
	 if (obj)
	 { 
	  obj.onblur=RegNoBlur; 
	  obj.onkeydown=RegNoEnter;
	  }

	obj=document.getElementById("BodyLoaded");
	if (obj.value!=1)
	{
	 	//GetDefLoc();
		setDefaultDate();
	}
    obj=document.getElementById("SelAll"); 
	if (obj){obj.onclick=SelALL;}
	
	obj=document.getElementById("CenAll"); 
	if (obj){obj.onclick=CenAll;}
	
	
	obj=document.getElementById("SelToRet"); 
	if (obj){obj.onclick=SelToRet;}
	
	
	setBodyLoaded();
	
	var obj=document.getElementById("DocFlag")
	if (obj) obj.onclick=SetDocFlag;
}
function SetDocFlag()
{
	var objDoc=document.getElementById("DocFlag")
	var objDocValue=document.getElementById("DocFlagValue")
	if (objDoc.checked==true){objDocValue.value=1}
	else{objDocValue.value=0}
}
function popReturnLoc()
{ // 2006-06-06
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  ReturnLoc_lookuphandler();
		}
}
function ReturnLocCheck()
{
	// 2006-06-06
	var obj=document.getElementById("ReturnLoc");
	var obj2=document.getElementById("returnlocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}// 2006-06-06
function popWard()
{ // 2006-06-06
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Ward_lookuphandler();
		}
}
function WardCheck()
{
	// 2006-06-06
	var obj=document.getElementById("Ward");
	var obj2=document.getElementById("wardrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}

}// 2006-06-06
function setBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded") ;
	if (obj) obj.value=1;
}
function setDefaultDate()
{
	var t=today();
	
	var obj=document.getElementById("StartDate") ;
	if (obj) obj.value=t;
	
	var obj=document.getElementById("EndDate") ;
	if (obj) obj.value=t;
	}

function ClearClick()
{
	ClearField("Ward") ;
	ClearField("StartDate") ;
	ClearField("EndDate") ;
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetrequesttoret"
	parent.frames['dhcpha.seekpharetrequesttoret'].location.href=lnk;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetreqitmtoret"
	parent.frames['dhcpha.seekpharetreqitmtoret'].location.href=lnk;
		
}
function ClearField(ss)
{	var obj; 
	obj = document.getElementById(ss) ;
	if (obj) obj.value="" ;
}

function SeekClick()
{ if (CheckSeekCon()==false) return ;
    
 	var obj=document.getElementById("StartDate") ;
 	if (obj) var sd=obj.value;
 	var obj=document.getElementById("EndDate") ;
 	if (obj) var ed=obj.value;
 	var obj=document.getElementById("returnlocrowid") ;
 	if (obj) var returnlocrowid=obj.value;
 	var obj=document.getElementById("wardrowid") ;
 	if (obj) var wardrowid=obj.value;
 	var obj=document.getElementById("PARegNo") ;
 	if (obj) var paregno=obj.value;
 	var obj=document.getElementById("DocFlag") ;
 	if (obj){ 
			 	if (obj.checked==true){var DocFlag="on" }
			 	else {var  DocFlag=""}
 	        }
 	var obj=document.getElementById("RequestStatus") ;
 	if (obj) var requeststatus=obj.value;
 
 	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetrequestno"+
 		"&returnlocrowid="+returnlocrowid+"&wardrowid="+wardrowid
 		+"&StartDate="+sd+"&EndDate="+ed+"&PARegNo="+paregno+"&DocFlag="+DocFlag+"&RequestStatus="+requeststatus	
 	parent.frames['dhcpha.seekpharetrequestno'].location.href=lnk;
 
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetrequestsum"
	parent.frames['dhcpha.seekpharetrequestsum'].location.href=lnk;
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetreqitmtoret"
	parent.frames['dhcpha.seekpharetreqitmtoret'].location.href=lnk;

}
function CheckSeekCon()
{ //check and validate the condition of seek
	var obj=document.getElementById("returnlocrowid") ;
	if (obj) {
		if (obj.value=="") 
			 {
			 alert(t['NO_RETLOC']) ;
			 return false ;		 }		 }	
	
	var obj1=document.getElementById("StartDate") ;
	var obj2=document.getElementById("EndDate") ;
	if (obj1) {if (obj1.value=="")
		{alert(t['NO_STARTDATE']) ;
		return false ;	}	}		
	if (obj2) {if (obj2.value=="")
		{alert(t['NO_ENDDATE']) ;
		return false ;	}	}		

	if (DateStringCompare(obj1.value,obj2.value)==1)
	{ alert(t['INVALID_DATESCOPE']) ;
		return false;	}
	
	var objid=document.getElementById("wardrowid") ;	
	//if (objid.value=="")
	//{alert("请选病区")
	//	return false;	 }
       
}	
function CancelClick()
{  window.parent.close();}


function ReturnLocLookUpSelect(str)
{
	var ss=str.split("^")
  if ( ss.length>0) 
  { 
   var obj=document.getElementById("returnlocrowid") ;
   if (obj) obj.value=ss[1] ; // rowid of the disp loc
   }
}
function WardLookUpSelect(str)
{
	var ss=str.split("^")
	  if ( ss.length>0) 
	  { 
	   var obj=document.getElementById("wardrowid") ;
	   if (obj) obj.value=ss[1] ; // rowid of the disp loc
	   }
}
function SelectRowHandler() {
	var retReqNo;
	
	var row=DHCWeb_GetRowIdx(window);
	var objitem=document.getElementById("TReqNoz"+row) ;
	if (objitem)
		{retReqNo=objitem.innerText;}
	else
		return ;
		
	var obj=document.getElementById("retReqNo") ;
	if (obj) obj.value=retReqNo	 ;
		
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetreqitmtoret&RetReqNo="+retReqNo	
	parent.frames['dhcpha.seekpharetreqitmtoret'].location.href=lnk;
}
function GetDefLoc()
{	
	var objBodyLoaded=document.getElementById("BodyLoaded") ;
	if (objBodyLoaded) BodyLoaded=objBodyLoaded.value;
	
	//alert(BodyLoaded);
	if (BodyLoaded!=1)
	{
		var userid=session['LOGON.USERID'] ;
		var obj=document.getElementById("mGetDefaultLoc") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;
		objBodyLoaded.value=1;
	}
}
function setDefLoc(value)
{
	var defloc=value.split("^");
	if (defloc.length>0)
	var locdr=defloc[0] ;
	var locdesc=defloc[1] ;
	if (locdr=="") return ;
	var obj=document.getElementById("ReturnLoc") ;
	if (obj) obj.value=locdesc
	var obj=document.getElementById("returnlocrowid") ;
	if (obj) obj.value=locdr	
}
function RegNoBlur()
{
	//when RegNo lost focus then this event fires .
	var obj=document.getElementById("PARegNo") ;
	var regno,displocrowid ;
	if (obj)
	{ 
	 regno=obj.value ;
	 if (regno=="")
	 {	
	 	var objPaName=document.getElementById("PAName")
	 	if (objPaName) objPaName.value=""
	 	return ;}
	 else
	 {obj.value=getRegNo(regno) ;
	  regno=obj.value ; }
	}
	//set patient info
    var getpa=document.getElementById('mGetPa');
	if (getpa) {var encmeth=getpa.value} else {var encmeth=''};
	if (cspRunServerMethod(encmeth,'SetPa','',regno)=='0') {}  
}
function RegNoEnter()
{  
	if (window.event.keyCode==13) 
		{RegNoBlur();}
	else
		{var obj=document.getElementById("PARegNo")
		 if(isNaN(obj.value)==true)  { obj.value="" ;}
			}
}
function SetPa(value)
{
  //set patient info of compoment
	var painfo=value.split("^")	;
	var obj;
	obj=document.getElementById("PAName");
	if (obj) obj.value=painfo[0];
//	obj=document.getElementById("Sex");
//	if (obj) obj.value=painfo[1];
//	obj=document.getElementById("Age");
//	if (obj) obj.value=painfo[2];
}
function SelALL()
{
  /// creator: lq  08-11-05
  var rowcnt;
  var docu=parent.frames['dhcpha.seekpharetrequestno'].document;
  var objtbl=docu.getElementById("t"+"dhcpha_seekpharetrequestno")
  if (objtbl){rowcnt=getRowcount(objtbl) }	
  if (rowcnt>0)
  {
	  for (i=1;i<=rowcnt;i++)
	  {
		  var obj=docu.getElementById("TSel"+"z"+i)
		  if (obj) obj.checked=true;  //!(obj.checked) ; 
		   }
		   
	  }	
	  
  
	  
  FindRetItmTatol();	
}
function CenAll()
{
	  /// creator: lq  08-11-05
  var rowcnt;
  var docu=parent.frames['dhcpha.seekpharetrequestno'].document;
  var objtbl=docu.getElementById("t"+"dhcpha_seekpharetrequestno")
  if (objtbl){rowcnt=getRowcount(objtbl) }	
  if (rowcnt>0)
  {
	  for (i=1;i<=rowcnt;i++)
	  {
		  var obj=docu.getElementById("TSel"+"z"+i)
		  if (obj) obj.checked=false ;  }
	  }
   FindRetItmTatol();	 
}
function PrintClick()
{

  var objtbl=document.getElementById("t"+"dhcpha_seekpharetrequesttoret")
  if (objtbl){rowcnt=getRowcount(objtbl) }
  if (rowcnt==0){return;}
  var reqnostr=""
	  for (i=1;i<=rowcnt;i++)
	  {
		  var obj=document.getElementById("TSel"+"z"+i)
		  if (obj.checked==true ){
			
			var objReqNo=document.getElementById("TReqNo"+"z"+i) 
			if (reqnostr==""){var reqnostr= objReqNo.innerText}
			else{reqnostr=reqnostr+"^"+objReqNo.innerText}
  
			  }
		  
	  }
 
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.printphareturn&PhaRetNo="+reqnostr
    parent.frames['dhcpha.printphareturn'].window.document.location.href=lnk;
}
function SelToRet()
{
  /// creator: lq  08-11-05
  /// description:选择退药
  var rowcnt;
  var retReqNo=""
  var sflag=""
  var RetNoStr=""
  var UserDR=session['LOGON.USERID']
  var docu=parent.frames['dhcpha.seekpharetrequestno'].document;
  var objtbl=docu.getElementById("t"+"dhcpha_seekpharetrequestno")
  if (objtbl){rowcnt=getRowcount(objtbl) }
  if (rowcnt==0){return;} 
	for (i=1;i<=rowcnt;i++)
	{
		var obj=docu.getElementById("TSel"+"z"+i)
		if (obj.checked==true )
		{
			var retReqNo="";
			var objReqNo=docu.getElementById("TReqNoz"+i) ;
			if (objReqNo) {retReqNo=objReqNo.innerText;} 
				
			var obj=docu.getElementById("mSelToRet") ;
			if (obj) {var encmeth=obj.value;} else {var encmeth='';}
			var ss=cspRunServerMethod(encmeth,retReqNo,UserDR) ;
			var retv=ss.split(",")
			if (retv.length<2)
			{
				alert("申请单:"+retReqNo+" "+"退药失败"+ss)
				return;
			}
			if (retv[0]=="success")
			{
				var RetNo=retv[1];
				if (RetNoStr==""){RetNoStr=RetNo}
				else(RetNoStr=RetNoStr+"^"+RetNo)
			}
			else
			{
				if (retv[1]==-2)
				{
					alert("申请单:"+retReqNo+"该申请单已执行退药,请在退药申请单查询核对!") ;
					return
				}
				if (retv[1]==-3)
				{
					alert("申请单:"+retReqNo+" "+"有药品 退药数量>(发药数量 - 已退药数量),请核实!");
					return;
				} 
				if (retv[1]==-4)
				{
					alert("申请单:"+retReqNo+"有病人已经结算，不能退药!");
					return;
				}
				if (retv[1]==-10)
				{
					alert("申请单:"+retReqNo+"有附加收费项目，不能部分退药!");
					return;
				}
				if ((retv[1]<0)&&(retv[1]!=-4)&&(retv[1]!=-3)&&(retv[1]!=-2)&&(retv[1]!=-10))
				{
					alert("申请单:"+retReqNo+" "+"退药失败"+ss)
					return;
				} 
			}
			sflag="1"
		}
	}
	if (sflag=="") {return;} //无一个申请单退药成功则退出
    
        
	if (confirm("退药成功,是否打印退药单?")==true)
        
	{ 
		var RetNoStr="ALL"+"@"+RetNoStr    // "ALL" --同时审N个申请单汇总打印标记,区分,单个退药,直接退药 打印方式
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.printphareturn&PhaRetNo="+RetNoStr
		parent.frames['dhcpha.printphareturn'].window.document.location.href=lnk;
	 }
        
	var obj=document.getElementById("Seek")	
	if (obj) {obj.click();}
}

function sendMessageToHX(RetNo)
{    
        ///description:传退药数量至华西老HIS
        
        var docu=parent.frames['dhcpha.seekpharetreqitmtoret'].document
        var obj=docu.getElementById("SendMssage") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		var message=cspRunServerMethod(encmeth,RetNo) ;

}

function getRetNewNo()
{
	//create and get return No 
				  
    var docu=parent.frames['dhcpha.seekpharetreqitmtoret'].document	
	if (docu){
	
	    var getRetNo=docu.getElementById('mCreateRetNo');
		if (getRetNo) {var encmeth=getRetNo.value} else {var encmeth=''};
		var newRetNo=cspRunServerMethod(encmeth,'','','RT')
		if (newRetNo=="") 
		{ alert("生成退药单号失败") ;
			return "" ;	}
		
	        }
	return newRetNo	
}
function FindRetItmTatol()
 {
	ReqStr=getCheckedRegnos();

    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetreqitmtoret&RetReqNo="+ReqStr	
	parent.frames['dhcpha.seekpharetreqitmtoret'].location.href=lnk;
 }
 function getCheckedRegnos()
{
	 var ReqStr="";
	 var docu=parent.frames['dhcpha.seekpharetrequestno'].document;
     var objtbl=docu.getElementById("t"+"dhcpha_seekpharetrequestno")
     if (objtbl){rowcnt=getRowcount(objtbl) }
     	
     if (rowcnt>0)
     {  
	     
		  for (i=1;i<=rowcnt;i++)
		  {
			  var objsel=docu.getElementById("TSel"+"z"+i)
			  if(objsel.checked==true)
			  {
		
				  var objitem=docu.getElementById("TReqNoz"+i) ;
				  retReqNo=objitem.innerText;
				  
				  if (ReqStr=="")
				  {ReqStr=retReqNo}
				  else
				  {ReqStr=ReqStr+"^"+retReqNo}
			  }
		  }
     }
     	
    return ReqStr;
} 

document.body.onload=BodyLoadHandler;