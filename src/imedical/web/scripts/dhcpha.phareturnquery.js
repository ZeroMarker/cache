//退药单查询
//dhcpha.phareturnquery.js
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("RegNo") ;
	if (obj) obj.onblur=RegNoBlur;
	
	obj=document.getElementById("Clear") ;
	if (obj) obj.onclick=ClearClick;
	obj=document.getElementById("Cancel") ;
	if (obj) obj.onclick=CancelClick;
	obj=document.getElementById("Find") ;
	if (obj) obj.onclick=FindRetClick;
	obj=document.getElementById("Print") ;
	if (obj) obj.onclick=PrintClick;

	var obj=document.getElementById("ReturnLoc"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popReturnLoc;
	 obj.onblur=ReturnLocCheck;
	} //2005-05-26
	var obj=document.getElementById("Ward"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popWard;
	 obj.onblur=wardCheck;
	} //2005-05-26

	obj=document.getElementById("BodyLoaded");
	if (obj.value!=1)
	{
		setDefaultDate();
		//GetDefLoc();
	}
	
    ///////////////////2007-10-13 lq
	var objInciCat=document.getElementById("INCStkCat");
	if (objInciCat) 
	{	
		objInciCat.onkeydown=popInciCat;
	 	objInciCat.onblur=InciCatCheck;
	} 
	var objInciAlias=document.getElementById("InciAlias");
	if (objInciAlias) 
	{	
		objInciAlias.onkeydown=popInciAlias;
	 	objInciAlias.onblur=InciAliasCheck;
	}
	/////////////////////
	
		
	setBodyLoaded();
}


///////////////////////////////////////////2007-10-13 lq
function popInciCat()
{ 
	//lq 2007-10-13
	if (window.event.keyCode==13) 
	{ 
		window.event.keyCode=117;
	  	INCStkCat_lookuphandler();
	}
}

function InciCatCheck()
{
	//lq 2007-10-13
	var obj=document.getElementById("INCStkCat");
	var obj2=document.getElementById("incstkcatrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}


function popInciAlias()
{ 
	//lq 2007-10-13
	if (window.event.keyCode==13) 
	{ 
		window.event.keyCode=117;
	  	InciAlias_lookuphandler();
	}
}

function InciAliasCheck()
{
	//lq 2007-10-13
	
	var obj=document.getElementById("InciAlias");
	var obj2=document.getElementById("incirowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	
}


//////////////////////////////////////////////////////////////


function setBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded") ;
	if (obj) obj.value=1;
}

function popReturnLoc()
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  ReturnLoc_lookuphandler();
		}
}//2006-05-26

function ReturnLocCheck()
{
	// 2006-05-26
	var obj=document.getElementById("ReturnLoc");
	var obj2=document.getElementById("returnlocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}// 2006-05-26

function popWard()     
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Ward_lookuphandler();
		}
	}//2006-05-26

function wardCheck()
{// 2006-05-26
	var obj=document.getElementById("Ward");
	var obj2=document.getElementById("wardrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}

	}// 2006-05-26

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
	//ClearField("ReturnLoc");
	//ClearField("returnlocrowid");
	ClearField("Ward")
	ClearField("wardrowid");
	ClearField("INCStkCat")
	ClearField("incstkcatrowid")
	ClearField("InciAlias")
	ClearField("incirowid")
	//ClearField("StartDate");
	//ClearField("EndDate");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phareturnquery"
	window.location=lnk;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phareturnqueryitm&RetNo="+""
    parent.frames['dhcpha.phareturnqueryitm'].window.document.location.href	=lnk
}
function ClearField(ss)
{	var obj; 
	obj = document.getElementById(ss) ;
	if (obj) obj.value="" ;
}

function CancelClick()
{parent.close() ;

}
function FindRetClick()
{
	if ( CheckConWhenFindingRet()==false ) return ;
	Find_click();
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phareturnqueryitm&RetNo="+""
    parent.frames['dhcpha.phareturnqueryitm'].window.document.location.href	=lnk
}

function CheckConWhenFindingRet()
{//check and valiate the condition input 
// when you want to find dispensing
	var obj ;
	/*
	obj = document.getElementById("returnlocrowid")
	if (obj) {
		if (obj.value==''){
			alert(t['NO_RETLOC']);
			return false ;
		}		
	}*/
	obj1 = document.getElementById("StartDate")
	if (obj1) {
		if (obj1.value==''){
			alert(t['NO_STARTDATE']);	
			return false ;
					}		}
	obj2 = document.getElementById("EndDate")
	if (obj2) {
		if (obj2.value==''){
			alert(t['NO_ENDDATE']);
			return false ;
					}		}

	if (DateStringCompare(obj1.value,obj2.value)==1)
	{alert(t['INVALID_DATESCOPE']) ;
		return false ;
		}
	return true ;
}

function AliasLookupSelect(str)
{	var inci=str.split("^");
	var obj=document.getElementById("incirowid");
	if (obj)
	{if (inci.length>0)   obj.value=inci[2] ;
		else  obj.value="" ;  
	 }

	}

function WardLookUpSelect(str)
{
	var ss=str.split("^") ;
	if ( ss.length>0) 
	{ 
		var obj=document.getElementById("wardrowid") ;
		if (obj) obj.value=ss[1] ; // rowid of the disp loc
		else  obj.value="" ;
	}
}
function DispLocLookUpSelect(str)
{
	var ss=str.split("^") ;
	if ( ss.length>0) 
	{ 
		var obj=document.getElementById("returnlocrowid") ;
		if (obj) obj.value=ss[1] ; // rowid of the disp loc
	}
}
function IncStkCatLookUpSelect(str)
{
	var ss=str.split("^") ;
	if ( ss.length>0) 
	{ 
		var obj=document.getElementById("incstkcatrowid") ;
		if (obj) obj.value=ss[1] ; // rowid of the disp loc
	}
}
function SelectRowHandler() 
{
	var row=selectedRow(window);
	var obj=document.getElementById("currentRow") ;
	if (obj) obj.value=row
	
	if (row>0) {
		var obj=document.getElementById("tPhaRetNo"+"z"+row) ;
		if (obj) var retno=obj.innerText;
		//alert(retno)
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phareturnqueryitm&RetNo="+retno
		parent.frames['dhcpha.phareturnqueryitm'].window.document.location.href	=lnk
	}
}
function PrintClick()
{
	var obj=document.getElementById("currentRow") ;
 	if (obj) var row=obj.value;
	if  (row<1) return ;
	var obj=document.getElementById("tPhaRetNoz"+row)	;
	if (obj) { var retno=obj.innerText;
	}
	else
		{return ; }
		
	if (retno=="")
	{	alert(t['PLEASE_SELECT_REQ']);
		return ;		}
	//
	var answer=confirm(t["ASKPRINT"]+retno)
	//if (answer==true)	PrintRet(retno);
	if (answer==true)  
	{   
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.printphareturn&PhaRetNo="+retno+"&RePrintFlag=1"
        parent.frames['dhcpha.printphareturn'].window.document.location.href=lnk; 

	 }  	
}

function getPrnPath()
{
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var prnpath=cspRunServerMethod(encmeth,'','') ;
	return prnpath
	}
function hospitalName()
{	var obj=document.getElementById("mPrtHospName") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var hospname=cspRunServerMethod(encmeth,'','') ;
	//alert("hospname:"+hospname);
	return hospname
	}
function getRetByNo(retno)
{	var obj=document.getElementById("mGetRetByNo") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var data=cspRunServerMethod(encmeth,'','',retno) ;
	return data
	}

function getRetDetail(pid,i)
{ 	var obj=document.getElementById("mListRet") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var data=cspRunServerMethod(encmeth,'','',pid,i) ;
	return data	
	}
function PrintRet(retno)
{
	var prnpath=getPrnPath();
	if (prnpath=="") {
		alert(t['CANNOT_FIND_PRNPATH']) ;
		return ;
	}
	var Template=prnpath+"STP_PhaRet.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
	var startrow=5 ; //从第五行开始打印明细
	if (xlsheet==null)
		{ alert(t['CANNOT_CREATE_PRNOBJECT']) ;
		return ;		  }
	  //  登记号	姓名	床号	处方号	药品名称	单位	退药数量	退药日期
	var hospname=hospitalName();
	xlsheet.Cells(1,1)=hospname ;  //hospital标题
	var s=getRetByNo(retno);
	data=s.split("^") ;
	var pid=data[0] ;
	var cnt=data[1] ;
	if (pid=="") return;
	if (cnt<1) return ;
	  
	var pano,paname,bed,prescno,incidesc,uomdesc,retqty,retdate;
	for ( var i=1;i<=cnt;i++)
	{
		var tmps=getRetDetail(pid,i);
		//alert(tmps) ;
		data=tmps.split("^");
		//s a1=Retno_"^"_DD_"^"_TT_"^"_UserDR_"^"_UserName
		//s a2=RetRqDR_"^"_RetRqNo_"^"_OEDISDR_"^"_INCLBDR_"^"_AdmLocDR
		//s a3=AdmLoc_"^"_RecLocDR_"^"_RecLoc_"^"_DeptDR_"^"_Dept
		//s a4=AdmDR_"^"_Prescno_"^"_Qty_"^"_Price_"^"_Amount
		//s a5=BedDR_"^"_Bed_"^"_InciCode_"^"_InciDesc_"^"_Pano
		//s a6=Paname_"^"_RetReqQty_"^"_Uom
		
		pano=data[24] ;
		paname=data[25] ;
		bed=data[21] ;
		prescno=data[16] ;
		incidesc=data[23] ;
		uomdesc=data[27] ;
		retqty=data[17] ;
		retdate=data[1] ;
		recloc=data[12] ;
		
		xlsheet.Cells(startrow+i-1,1)= pano;
		xlsheet.Cells(startrow+i-1,2)= paname;
		xlsheet.Cells(startrow+i-1,3)= bed;
		xlsheet.Cells(startrow+i-1,4)=prescno ;
		xlsheet.Cells(startrow+i-1,5)=incidesc ;
		xlsheet.Cells(startrow+i-1,6)= uomdesc;
		xlsheet.Cells(startrow+i-1,7)= retqty;
		xlsheet.Cells(startrow+i-1,8)= retdate;
	}
	//alert(pt)
 //  d = new Date();
 //  s += d.getHours() + c;
 //  s += d.getMinutes() + c;
 //  s += d.getSeconds() + c;
//   s += d.getMilliseconds();
	
	xlsheet.Cells(3,2)=getDesc(recloc);
	xlsheet.Cells(3,5)=retno;
	xlsheet.Cells(3,7)=getPrintDateTime();
	
	xlsheet.printout();
	//打印后的处理
	xlApp=null;
	xlsheet=null;
	xlBook.Close(savechanges=false);  
}	

function RetAudit()
{ 

	 // Audit Return ...
	var currrow ;
	var obj=document.getElementById("currentRow") ;
	if (obj) currrow=obj.value
	if (currrow<1)
	{alert(t['RETNO_NEEDED'])
	 return ;  }
	
	var retno="";	
	var obj=document.getElementById("tPhaRetNo"+"z"+currrow) ;
	if (obj) 
	{
	  retno=obj.innerText;
	}
	var ackdate="" ;
	var obj=document.getElementById("tAckDate"+"z"+currrow) ;
	if (obj)
	{ackdate=obj.innerText;	}
	
	if (retno=="")
	{alert(t['RETNO_NEEDED']);
	 return ;  }
	 	 
	if (ackdate.length==10)
	{alert(t['AUDITED']);
	 return ;	}

	var exe1;
	var obj=document.getElementById("mRetUser")	
	if (obj) exe1=obj.value;
	else exe1=""     
	var opuser=cspRunServerMethod(exe1,retno)
	
	if (opuser==session['LOGON.USERID']) 
	{ alert(t['INVALID_AUDITUSER'])
	 return ;	}
	 	
	var yesno=confirm(t['IF_AUDITRET'])
	if (yesno==true)
	{
		var exe2;
		var obj=document.getElementById("mRetAudit")	
		if (obj) exe2=obj.value;
		else exe2=""     
		if (exe2!="")
		{var result=cspRunServerMethod(exe2,retno,session['LOGON.USERID'])
		 alert(result)
		 if (result<0) 
		 {alert(t['AUDIT_FAILED']) ;
		  return ;	 }
		 else self.location.reload();
		   
		}
	}

}
document.body.onload=BodyLoadHandler;
