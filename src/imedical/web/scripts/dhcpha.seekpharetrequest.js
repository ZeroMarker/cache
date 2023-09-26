
function BodyLoadHandler()
{
	 var obj;
	 var obj=document.getElementById("SetDefaultLoc");
     if (obj)  obj.onclick=SetDefaultLoc;
	 obj=document.getElementById("Clear") ;
	 if (obj) obj.onclick=ClearClick;
	 obj=document.getElementById("Seek") ;
	 if (obj) obj.onclick=SeekClick;
	 obj=document.getElementById("Cancel") ;
	 if (obj) obj.onclick=CancelClick;
	 obj=document.getElementById("Print") ;
	 if (obj) obj.onclick=PrintClick;
	 
	 var obj=document.getElementById("SelectAll")
	 if (obj) obj.onclick=SelectAll;
	 var obj=document.getElementById("SelectNone")
	 if (obj) obj.onclick=SelectNone;
	
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
    var obj=document.getElementById("PARegNo");
 	if (obj) 
	 {   
		 if (obj.value=="")
		 {
			 obj.value=GetRegNoByEpisodeID()
			 RegNoBlur();
		 }
  
	 }
    var obj=document.getElementById("Alias"); //2007-08-21,zdm
	if (obj) 
	{	
		obj.onkeydown=popAlias;
	 	obj.onblur=AliasCheck;
	}
	
	var RequestStatus;
	var obj=document.getElementById("RequestStatus") ;
	if (obj)  RequestStatus=obj.value
	if (RequestStatus=="P") 
	{window.document.all("Print").style.display='none' 	}
	
	obj=document.getElementById("SubmitRefund") ;
	if (obj) obj.onclick=SubmitRefundClick;
	
	setRetList();
	var obj=document.getElementById("BodyLoaded");
	if (obj.value!=1){
		GetDefaultPhaloc();
		setBodyLoaded();	
	 //	GetDefLoc();
	//	setDefaultDate();		
	//	SeekClick();
	}else{
	}
	
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
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetrequest"
	parent.frames['dhcpha.seekpharetrequest'].location.href=lnk;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetreqitm"
	parent.frames['dhcpha.seekpharetreqitm'].location.href=lnk;
		
}
function ClearField(ss)
{	var obj; 
	obj = document.getElementById(ss) ;
	if (obj) obj.value="" ;
}

function SeekClick()
{ if (CheckSeekCon()==false) return ;
    SetRequestStatus();
 	////execute query ;
 	
  	var sd="",ed="",returnlocrowid="",wardrowid="",bodyloaded=""
  	var returnloc="",patno="",patname="",ward="",advrefundflag=""
 	var obj=document.getElementById("StartDate") ;
 	if (obj) sd=obj.value;
 	var obj=document.getElementById("EndDate") ;
 	if (obj) ed=obj.value;
 	var obj=document.getElementById("returnlocrowid") ;
 	if (obj) returnlocrowid=obj.value;
 	var obj=document.getElementById("wardrowid") ;
 	if (obj) wardrowid=obj.value;
 	var obj=document.getElementById("BodyLoaded") ;
 	if (obj) bodyloaded=obj.value;
 	
  	var obj=document.getElementById("ReturnLoc") ;
 	if (obj) returnloc=obj.value;
  	var obj=document.getElementById("Ward") ;
 	if (obj) ward=obj.value;
  	var obj=document.getElementById("PARegNo") ;
 	if (obj) patno=obj.value;
   	var obj=document.getElementById("PAName") ;
 	if (obj) patname=obj.value;
 	var obj=document.getElementById("AdvRefundFlag");
 	if (obj.checked){
		advrefundflag="Y";
	}

 	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetrequest"+
 		"&returnlocrowid="+returnlocrowid+"&wardrowid="+wardrowid
 		+"&StartDate="+sd+"&EndDate="+ed+"&BodyLoaded="+bodyloaded
 		+"&ReturnLoc="+returnloc+"&Ward="+ward+"&PARegNo="+patno
 		+"&PAName="+patname+"&AdvRefundFlag="+advrefundflag;
 	location.href=lnk;
    
	//Seek_click();  //此方式仅能返回query中对应的入参
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetreqitm"
	parent.frames['dhcpha.seekpharetreqitm'].location.href=lnk;
		
}
function SetRequestStatus()
{
    var obj=document.getElementById("RequestStatus") ;
    if (obj){
	    
	        var retlist="";
	        var objretlist=document.getElementById("RetList") ;
	        if (objretlist){
		        if (objretlist.value==1){
			     var retlist="R" ;  
		        }
		        if (objretlist.value==0){
			     var retlist="P" ;  
		        }
		        if (objretlist.value==""){
			     var retlist="A" ;  
		        }
	        }
        
	    obj.value=retlist;
    }
}
function CheckSeekCon()
{ //check and validate the condition of seek
	var obj=document.getElementById("returnlocrowid") ;
	/*if (obj) {
		if (obj.value=="") {
			 alert(t['NO_RETLOC']) ;
			 return false ;		 
		}		
	}*/	
	
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
	return true ;
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



function SelectRowHandler()
 {  
    //lq 2007-10-30
	var row=selectedRow(window);
	if (row<1) return ; 
	
	//regnos=getCheckedRegnos();
	//if (regnos==""){alert(t['NoSel']);}
    //var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetreqitm&RetReqNo="+regnos	
    //parent.frames['dhcpha.seekpharetreqitm'].location.href=lnk;
    SelectAllToFind(); 
 } 


function getCheckedRegnos()
{
	//获取所选行的申请单号
	//lq 2007-10-30
	var i=0;
	var ReqNo="";
	var rowcnt ;
	var objtbl=document.getElementById("t"+"dhcpha_seekpharetrequest");
	if (objtbl)	rowcnt=getRowcount(objtbl)
	
	for(i=1;i<=rowcnt;i++)
	{
		var objCheck=document.getElementById("Select"+"z"+i);
		if (objCheck)
		{	
		   
			if(objCheck.checked==true)
			{  
			    
				var objReqNo=document.getElementById("TReqNo"+"z"+i);
				if(objReqNo) 
				{
					 
					 var ReqNo=ReqNo+"^"+objReqNo.innerText;
				 }
				
			}
		}
		
	}
	
	return ReqNo;//返回申请单号串
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

/*
function PrintClick()
{	
    var row ;
	var reqno ;
	var recloc;
	var ward;
    var lastreq="";
    
	var DOCU=parent.frames['dhcpha.seekpharetreqitm'].document;
	var rowcount;
	var obj=DOCU.getElementById("t"+"dhcpha_seekpharetreqitm")
	if (obj)
	{	rowcount = getRowcount(obj); }
	if (rowcount==0){
		alert(t['PLEASE_SELECT_REQ'])
		return;}
	try
	{
	if  (rowcount>0)
	{
		var i;
		var j;
		
		var prnpath=getPrnPath();		
	    var Template=prnpath+"DHCSTP_PhaRetRequest.xls";
	    var xlApp = new ActiveXObject("Excel.Application");	    
	    var xlBook = xlApp.Workbooks.Add(Template);
	    var xlsheet = xlBook.ActiveSheet ;
        var startRow=6 ;
		
		j=eval(startRow)-2 ;
		for (i=1;i<=rowcount;i++)
		{   
		    var obj=DOCU.getElementById("Treq"+"z"+i);
		    if (obj) var req=obj.value;
		    var ss=RetReqMainMsg(req) ;
	        if (ss!="") {
		        var retreqinfo=ss.split("^") ;
		        recloc=retreqinfo[0] ;
		        ward=retreqinfo[1] ;
		        }
	        else
		    { alert(t['CANNOT_RETRIEVE_REQ'] ) ;
		     return;
		    }
		       
		          xlsheet.Cells(3,6).Value=getPrintDateTime();
		          if (lastreq!== req){
			          xlsheet.Cells(j+1,1).Value=t['REQNO']+req+"   "+t['MEDGRP']+getDesc(recloc)+"   "+t['WARD']+getDesc(ward)
			          xlsheet.Cells(j+2,1).Value=t['REGNO'];
			          xlsheet.Cells(j+2,2).Value=t['NAME'];
			          xlsheet.Cells(j+2,3).Value=t['BEDNO'];
			          xlsheet.Cells(j+2,4).Value=t['PRESCNO'];
			          xlsheet.Cells(j+2,5).Value=t['MEDDESC'];
			          xlsheet.Cells(j+2,6).Value=t['UOM'];
			          xlsheet.Cells(j+2,7).Value=t['REQNUM'];
			          for (n=1;n<=7;n++){
			          xlsheet.Cells(j+2,n).Borders(9).LineStyle = 1;}    //下边
			          j=j+3
			         
			                 }
		    
		    lastreq = req
			var obj=DOCU.getElementById("RegNo"+"z"+i);
			if (obj) var regno=obj.innerText; 
			var obj=DOCU.getElementById("Name"+"z"+i);
			if (obj) var panme=obj.innerText; 
			var obj=DOCU.getElementById("PrescNo"+"z"+i);
			if (obj) var prescno=obj.innerText; 
			var obj=DOCU.getElementById("BedNo"+"z"+i);
			if (obj) var bedno=obj.innerText; 
			var obj=DOCU.getElementById("Desc"+"z"+i);
			if (obj) var desc=obj.innerText; 
			var obj=DOCU.getElementById("Uom"+"z"+i);
			if (obj) var uom=obj.innerText; 
			var obj=DOCU.getElementById("Qty"+"z"+i);
			if (obj) var qty=obj.innerText; 
			
			
			xlsheet.Cells(j,1).Value=regno;
			xlsheet.Cells(j,2).Value=panme;
			xlsheet.Cells(j,3).Value=bedno;
			xlsheet.Cells(j,4).Value=prescno;
			xlsheet.Cells(j,5).Value=desc;
			xlsheet.Cells(j,6).Value=uom;
			xlsheet.Cells(j,7).Value=qty;
			
			j++;
			}	
		}
	}
	catch(e)
	{
		alert(e.message);
	}	
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);	

}
*/

//2012-03-23,合并同一个病人同一个药的申请数量
function PrintClick()
{	
    var row ;
	var reqno ;
	var recloc;
	var ward;
    var lastreq="";
    var regnostr=""
    var obj=document.getElementById("t"+"dhcpha_seekpharetrequest")
    var rowcount = getRowcount(obj);
	if (rowcount==0){
		alert(t['PLEASE_SELECT_REQ'])
		return;
	}
	var DOCU=parent.frames['dhcpha.seekpharetreqitm'].document;
	var rowcount;
	var ArrayData=CollectPrintData();
	var obj=DOCU.getElementById("t"+"dhcpha_seekpharetreqitm");
	if (getRowcount(obj)==0){
		return;
	}
	if (ArrayData){	
		rowcount =ArrayData.length; 
	}
	if (rowcount==0){
		alert(t['PLEASE_SELECT_REQ'])
		return;
	}
	try
	{
		if  (rowcount>0)
		{
			var i;
			var j;
		
			var prnpath=getPrnPath();		
		    var Template=prnpath+"DHCSTP_PhaRetRequest.xls";
		    var xlApp = new ActiveXObject("Excel.Application");	    
		    var xlBook = xlApp.Workbooks.Add(Template);
		    var xlsheet = xlBook.ActiveSheet ;
	        var startRow=5 ;
		
			j=parseInt(startRow)-3 ;
			for (i=1;i<=rowcount;i++)
			{   
			    var ArrayItm=ArrayData[i-1];
			    var req=ArrayItm[0];
			    var ss=RetReqMainMsg(req) ;
		        if (ss!="") {
			        var retreqinfo=ss.split("^") ;
			        recloc=retreqinfo[0] ;
			        ward=retreqinfo[1] ;
			        }
		        else
			    { 
			    	alert(t['CANNOT_RETRIEVE_REQ'] ) ;
			     	return;
			    }
		       
			   // xlsheet.Cells(3,6).Value=getPrintDateTime();
		        if (lastreq!== req){
			          xlsheet.Cells(j,1).Value=t['REQNO']+req+" "+t['MEDGRP']+getDesc(recloc)+" "+"病区:"+getDesc(ward)
			          xlsheet.Cells(j+1,1).Value="打印时间:"+getPrintDateTime()
			          xlsheet.Cells(j+2,1).Value=t['REGNO'];
			          xlsheet.Cells(j+2,2).Value=t['NAME'];
			          xlsheet.Cells(j+2,3).Value=t['BEDNO'];
			          xlsheet.Cells(j+2,4).Value=t['PRESCNO'];
			          xlsheet.Cells(j+2,5).Value=t['MEDDESC'];
			          xlsheet.Cells(j+2,6).Value=t['UOM'];
			          xlsheet.Cells(j+2,7).Value=t['REQNUM'];
			          for (n=1;n<=7;n++){
			          	xlsheet.Cells(j+2,n).Borders(9).LineStyle = 1;
			          }    //下边
			          j=j+3;	         
			    }
		    
			    lastreq = req;
		    
				var regno=ArrayItm[1]; 
				var panme=ArrayItm[2]; 
				var prescno=ArrayItm[3]; 
				var bedno=ArrayItm[4]; 
				var desc=ArrayItm[5]; 
				var uom=ArrayItm[6]; 
				var qty=ArrayItm[7]; 
			
				xlsheet.Cells(j,1).Value=regno;
				xlsheet.Cells(j,2).Value=panme;
				xlsheet.Cells(j,3).Value=bedno;
				xlsheet.Cells(j,4).Value=prescno;
				xlsheet.Cells(j,5).Value=desc;
				xlsheet.Cells(j,6).Value=uom;
				xlsheet.Cells(j,7).Value=qty;
				if(regnostr==""){regnostr=regno}
				else{regnostr=regnostr+"&"+regno}
			
				j++;
			}	
		}
	}
	catch(e)
	{
		alert(e.message);
	}	
    xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet);
    
    var content=recloc+"^"+ward
	var logret=tkMakeServerCall("web.DHCSTPHARETURN2","CreateReqLog",reqno,content,regnostr);   //写打印日志		

}

function CollectPrintData()
{	
    var ArrayData=new Array();
    var newflag=1;   //不存在相同的药
    var existrow="";
	var DOCU=parent.frames['dhcpha.seekpharetreqitm'].document;
	var rowcount;
	var i,j,h;
	var obj=DOCU.getElementById("t"+"dhcpha_seekpharetreqitm")
	if (obj)
	{	rowcount = getRowcount(obj); }
	
	if (rowcount==0){
		alert(t['PLEASE_SELECT_REQ'])
		return;}
	try
	{
		if  (rowcount>0)
		{
			j=0;		
			for (i=1;i<=rowcount;i++)
			{   
			    var obj=DOCU.getElementById("Treq"+"z"+i);
			    if (obj) var req=obj.value;
				var obj=DOCU.getElementById("RegNo"+"z"+i);
				if (obj) var regno=obj.innerText; 
				var obj=DOCU.getElementById("Name"+"z"+i);
				if (obj) var panme=obj.innerText; 
				var obj=DOCU.getElementById("PrescNo"+"z"+i);
				if (obj) var prescno=obj.innerText; 
				var obj=DOCU.getElementById("BedNo"+"z"+i);
				if (obj) var bedno=obj.innerText; 
				var obj=DOCU.getElementById("Desc"+"z"+i);
				if (obj) var desc=obj.innerText; 
				var obj=DOCU.getElementById("Uom"+"z"+i);
				if (obj) var uom=obj.innerText; 
				var obj=DOCU.getElementById("Qty"+"z"+i);
				if (obj) var qty=obj.innerText;
				
				var ArrayItm=new Array();
				ArrayItm[0]=req;
				ArrayItm[1]=regno;
				ArrayItm[2]=panme;
				ArrayItm[3]=prescno;
				ArrayItm[4]=bedno; 
				ArrayItm[5]=desc; 
				ArrayItm[6]=uom; 
				ArrayItm[7]=qty; 
				
				newflag=1;
				for(h=0;h<j;h++){
					var tmpArray=new Array();
					tmpArray=ArrayData[h];
					var tmpreqno=tmpArray[1];
					var tmpdesc=tmpArray[5];
					var tmpuom=tmpArray[6];
					var tmpqty=tmpArray[7];
					if((tmpreqno==regno)&&(tmpdesc==desc)&&(tmpuom==uom))
					{
						newflag=0;    //同一个药数量合计
						existrow=h;
						break;
					}			
					
				}
				if(newflag==1){
				
					ArrayData[j]=ArrayItm;				
					j=j+1;
				}
				else{
					
					var tmpArray=ArrayData[existrow];
					tmpArray[7]=parseFloat(tmpArray[7])+parseFloat(qty);
					ArrayData[existrow]=tmpArray;
				}
			
			}	
		}
	}
	catch(e)
	{
		alert(e.message);
	}
	
	return ArrayData;	
}

function getPrnPath()
{
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	prnpath=cspRunServerMethod(encmeth,'','') ;
	return prnpath
}
function RetReqMainMsg(retreqno)
{	
	var obj=document.getElementById("mGetRetReqMainMsg") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,retreqno) ;
    return ss;
	}
function SetNothing(app,book,sheet)
{
	app=null;
	book.Close(savechanges=false);
	sheet=null;
}
function SelectAll()
{
  //lq 2007-10-30
  var rowcnt;
  var objtbl=document.getElementById("t"+"dhcpha_seekpharetrequest")
  if (objtbl)
  {rowcnt=getRowcount(objtbl)
	  }	
  if (rowcnt>0)
  {
	  for (i=1;i<=rowcnt;i++)
	  {
		  var obj=document.getElementById("Select"+"z"+i)
		  if (obj) obj.checked=true ;
		  }
		  
	  SelectAllToFind();
		  
	  }	  	
}

function SelectNone()
{  
  //lq 2007-10-30
  var rowcnt;
  var objtbl=document.getElementById("t"+"dhcpha_seekpharetrequest")
  if (objtbl)
  {rowcnt=getRowcount(objtbl)
	  }	
  if (rowcnt>0)
  {
	  for (i=1;i<=rowcnt;i++)
	  {
		  var obj=document.getElementById("Select"+"z"+i)
		  if (obj) obj.checked=false ;
		  }
		  SelectAllToFind();
		  
	  }	  
}


function SelectAllToFind()
{
	//lq 2007-10-30
	regnos=getCheckedRegnos();
	//if (regnos==""){alert(t['NoSel']);}
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.seekpharetreqitm&RetReqNo="+regnos	
    parent.frames['dhcpha.seekpharetreqitm'].location.href=lnk;
}
function GetDefaultPhaloc()
{
 
      var objdisplocid=document.getElementById("returnlocrowid");
      if (objdisplocid.value=="")
     {
		  var str= GetDefaultPhaLocConfig()
	      DefaultStr=str.split("^")
	      var DefaultPhalocDesc=DefaultStr[1]
	      if (DefaultPhalocDesc=="") {return;} 
	      var DefaultPhalocID=DefaultStr[0]
	      if (DefaultPhalocID=="") {return;} 
		  objdisplocid.value=DefaultPhalocID
		  var obj=document.getElementById("ReturnLoc");
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

function RegNoEnter()
{  
	if (window.event.keyCode==13) 
		{RegNoBlur();}
	else
		{var obj=document.getElementById("PARegNo")
		 if(isNaN(obj.value)==true)  { obj.value="" ;}
			}
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

function AliasCheck()
{
	//2007-8-21,zdm
	var obj=document.getElementById("Alias");
	var obj2=document.getElementById("incirowid");
	if (obj) 
	{if (obj.value=="") obj2.value="";	}
	
}

function popAlias()
{ 
	// 2007-08-21,zdm
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Alias_lookuphandler();
	}
}

function AliasLookupSelect(str)
{	
	//2007-8-21,zdm
	var inci=str.split("^");
	var obj=document.getElementById("incirowid");
	if (obj)
	{if (inci.length>0)   obj.value=inci[2] ;
		else  obj.value="" ;  
	}

}
///提交退费
function SubmitRefundClick()
{
	 var objtbl=document.getElementById("t"+"dhcpha_seekpharetrequest")
     if (objtbl) rowcnt=getRowcount(objtbl)
     if (!rowcnt) return;
	 var reqnostr=getCheckedRegnos();
	 if (reqnostr=="") return;
	 if (confirm("确认要退费吗?")==false)  return ;
	 var userid=session['LOGON.USERID'] ;
	 var getpa=document.getElementById('mRefund');
	 if (getpa) {var encmeth=getpa.value} else {var encmeth=''};
	 var ret=cspRunServerMethod(encmeth,reqnostr,userid)
	 if (ret==0)  {alert("退费成功")}
	 if (ret==-97)  {alert("有附加费用,不允许退费");return;}
	 if (ret==-98)  {alert("已结算,不允许再退费,请先撤消结算");return;}
	 if (ret==-99)  {alert("不能重复退费");return;}
	 if (ret!=0) {alert("退费失败"+ret)}
	 
}


function setRetList()
{
		
	var obj = document.getElementById("RetList");
	if (obj){
		setReturnList();
		obj.onchange=RetListSelect;
	}
}

function setReturnList()
{
	var obj=document.getElementById("RetList");
	if (obj) InitRetList(obj);
	var objindex=document.getElementById("RetListIndex");
	if (objindex) obj.selectedIndex=objindex.value;
}

function InitRetList(listobj)
{

			
   if (listobj)
			{
				listobj.size=1; 
			 	listobj.multiple=false;

			 	listobj.options[1]=new Option("已退药","1");
			 	listobj.options[2]=new Option("未退药","0");
		    }
			


}


function RetListSelect()
{
	var obj=document.getElementById("RetListIndex");
	if(obj){
		var objpass=document.getElementById("RetList");
		obj.value=objpass.selectedIndex;
	}
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


function SetDefaultLoc()
{
   
   var obj=document.getElementById("returnlocrowid");
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
    
    var obj=document.getElementById("ReturnLoc");
    var locdesc=obj.value
    if (confirm("确认将 " + locdesc +" 设置成默认科室吗?")==false)  return ; 
    
    var getadm=document.getElementById("mSetDefaultPhaLoc");
	if (getadm) {var encmeth=getadm.value} else {var encmeth=''};
	var ret=cspRunServerMethod(encmeth,displocrowid,grpid)  ;
	
	if (ret==0){alert("设置成功")}
   
   
}



document.body.onload=BodyLoadHandler;

