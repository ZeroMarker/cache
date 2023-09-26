//
//dhcpha.dispquery.js
var firstbody;

function BodyLoadHandler()
{
	
	var obj ;
	obj=document.getElementById("Clear") ;
	if (obj) obj.onclick=ClearClick; 
	obj=document.getElementById("Find") ;
	if (obj) obj.onclick=FindClick; 
	
	obj=document.getElementById("Close") ;
	if (obj) obj.onclick=CloseClick; 
	obj=document.getElementById("Print") ;
	if (obj) obj.onclick=PrintClick; 
	//obj=document.getElementById("tdhcpha_dispquery") ;
	//if (obj) obj.onclick=RowChange; 
	obj=document.getElementById("DispCat") ;
	if (obj) obj.onchange=setDispCatVal; 
	obj=document.getElementById("PrintOutDrug") ;
	if (obj) obj.onclick=PrintOutDrug;
	
	var obj=document.getElementById("SendToAuto") ;
	if (obj) obj.onclick=SendToAuto;
	
	var obj=document.getElementById("DispLoc"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popDispLoc;
	obj.onblur=DispLocCheck;
	} //2005-05-26
	
	var obj=document.getElementById("Ward"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popWard;
	 obj.onblur=wardCheck;
	} //2005-05-26

	var obj=document.getElementById("OperUser"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popOperUser;
	 obj.onblur=OperUserCheck;
	} //2005-05-26
	
	var obj=document.getElementById("DoctorLoc"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popDoctorLoc;
	 obj.onblur=DoctorLocCheck;
	}
	
	PopulateDispCat();

	obj=document.getElementById("BodyLoaded");
	if (obj.value!=1)
	{
	//	GetDefLoc();
		setDefaultDate();
	}
	obj=document.getElementById("SelAll") ;
	if (obj) obj.onclick=SelectAll;
	
	obj=document.getElementById("SelNone") ;
	if (obj) obj.onclick=SelectNone;
	
	obj=document.getElementById("Check") ;
	if (obj) obj.onclick=CheckOne;
	
	obj=document.getElementById("RegNo");
	if (obj) obj.onblur=RegNoBlur;
	
	obj=document.getElementById("ShortOrd");
	if (obj) obj.onclick=SetShortOrdFlag;
	
	obj=document.getElementById("LongOrd");
	if (obj) obj.onclick=SetLongOrdFlag;
	
	obj=document.getElementById("StartNo");
	if (obj) obj.onblur=CheckNo;
	obj=document.getElementById("EndNo");
	if (obj) obj.onblur=CheckNo;

	setBodyLoaded();
	GetUserWard();
	
	
	
	}

function CheckNo()
{
  var objstartno=document.getElementById("StartNo") ;	
  var objendno=document.getElementById("EndNo") ;
  var startno=objstartno.value
  var endno=objendno.value
  if((startno<0)){
	  alert("不能为负数")
	  objstartno.focus()
	  return;
  }
  if((endno<0)){
	  alert("不能为负数")
	  objendno.focus()
	  return;
  }
  if(((objstartno.value>objendno.value)||(startno.length>endno.length))&&(objendno.value!=""))
  {alert("开始值大于终止值")
   objendno.value=""
   objstartno.focus()
   return;}
}
function RegNoBlur()
{
	var objregno=document.getElementById("RegNo") ;
	if (objregno) regno=objregno.value ;
	if (regno=="")
	{
	 SetPamStr("RegNo")
	 return ;}
	else
	{ 
	  regno=getRegNo(regno) ;
	  objregno.value=trim(regno)
	  SetPamStr("RegNo")
		}
}
function SetShortOrdFlag()
{
   SetPamStr("ShortOrd")
}
function SetLongOrdFlag()
{
   SetPamStr("LongOrd")
}
function SetPamStr(flag)
{
	//设置参数串
	//(PamStr):RegNo+"^"+LongOrd+"^"+ShortOrd+"^"+ ...
	var objregno=document.getElementById("RegNo") ;
	var objlongord=document.getElementById("LongOrd") ;
	var objshortord=document.getElementById("ShortOrd") ;
	var objPamStr=document.getElementById("PamStr") ;
    //选中登记号时---
	if(flag=="RegNo")
	{ 
	    
	  if (objlongord.checked==true) {objlongord.value=1}
	   else{objlongord.value=0;} 
	  
	  if (objshortord.checked==true) {objshortord.value=1}
	   else{objshortord.value=0}
	  }	   
	//选中长嘱时---  	
	if (flag=="LongOrd")
	{  if (objlongord.checked==true) {objlongord.value=1}
	   else{objlongord.value=0} 
	 objshortord.checked=false
	 objshortord.value=0} 
	//选中临嘱时--- 
	if (flag=="ShortOrd")
	{objlongord.checked=false
	 objlongord.value=0
	 if (objshortord.checked==true) {objshortord.value=1}
	   else{objshortord.value=0}
	   }
	
    objPamStr.value=objregno.value+"^"+objlongord.value+"^"+objshortord.value
    
    //alert(objPamStr.value)
}
function SelectAll()
{
  var rowcnt;
  var objtbl=document.getElementById("t"+"dhcpha_dispquery")
  if (objtbl)
  {rowcnt=getRowcount(objtbl)
	  }
  if (rowcnt>0)
  {
	  for (i=1;i<=rowcnt;i++)
	  {
		  var obj=document.getElementById("TSelect"+"z"+i)
		  if (obj) obj.checked=true ;
		  
		  }
	  
	  }
	  RowChange()	  	
}

function SelectNone()
{
  
  var rowcnt;
  var objtbl=document.getElementById("t"+"dhcpha_dispquery")
  if (objtbl)
  {rowcnt=getRowcount(objtbl)
	  }
  if (rowcnt>0)
  {
	  for (i=1;i<=rowcnt;i++)
	  {
		  var obj=document.getElementById("TSelect"+"z"+i)
		  if (obj) obj.checked=false ;
		  
		  }
		  
	  }	  	
RowChange()
}

function CheckOne()
{
       getChecked()
}

function getChecked()
{
	//获取所选行的发药单号
	var i=0;
	var PhaNo="";
	var rowcnt ;
	var objtbl=document.getElementById("t"+"dhcpha_dispquery");
	if (objtbl)	rowcnt=getRowcount(objtbl)
	if (rowcnt<1){	return; }
	var ret=confirm("是否确认已发药?");
	if (ret==false){return;}
	for(i=1;i<=rowcnt;i++)
	{
		var objCheck=document.getElementById("TSelect"+"z"+i);
		if (objCheck)
		{	
		   
			if(objCheck.checked==true)
			{  
			   
			   var objCollUser=document.getElementById("TCollectUser"+"z"+i);
			   if (objCollUser){userflag=objCollUser.innerText}
	           
	           if (trim(userflag)!=""){alert("第"+i+"行已经确认,不能再次确认")}
	           		           
			   if (trim(userflag)==""){
				   var objColl=document.getElementById("Tcoll"+"z"+i);
				   if (objColl){var coll=objColl.value}
				   var colluserid=session['LOGON.USERID']
				   var user=CheckPhaName(coll,colluserid)
				   if (objCollUser){objCollUser.innerText=user}		        
			   }
			    			
			}
		}
		
	}	
}

function CheckPhaName(coll,colluserid)
{	
    //填充第二发药人,返回姓名
	var obj=document.getElementById("mCheckPhaName") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	var ss=cspRunServerMethod(encmeth,coll,colluserid) ;
    return ss;
	}
	
function popOperUser()     
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  OperUser_lookuphandler();
		}
	}//2006-05-26
	
function OperUserCheck()
{// 2006-05-26
	var obj=document.getElementById("OperUser");
	var obj2=document.getElementById("Userid");
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
function setDispCatVal()
{
	var obj1=document.getElementById("dispcatvalue");
	var obj2=document.getElementById("DispCat");
	obj1.value=obj2.value;
}

function RowChange()
{

  //retrieve the detail dispensing 
  var phacrowidStr=0
    var objtbl=document.getElementById("t"+"dhcpha_dispquery")
  if (objtbl)
  {row=getRowcount(objtbl)}
  if (row<1) return ;
  
    
   	for(i=1;i<=row;i++)
	{
		var objCheck=document.getElementById("TSelect"+"z"+i);
		
			if(objCheck.checked==true)
			{     
		         var objcoll=document.getElementById("Tcollz"+i)
			     if (objcoll) var phac=objcoll.value;
			     	var objPamStr=document.getElementById("PamStr") ;
					PamStr=objPamStr.value  

			     
		  	     if(phacrowidStr!="")
				    	phacrowidStr=phacrowidStr+"A"+phac+"^"+PamStr;		
				 else
				 	phacrowidStr=phac+"^"+PamStr;	
			}}        	     

  RetrieveDetailByCollid(phacrowidStr)
    

	}
function RetrieveDetailByCollid(phacrowidStr)
{
    
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquerytotal&phacrowidStr="+phacrowidStr;
	parent.frames['dhcpha.dispquerytotal'].location.href=lnk;

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispqueryitm&phacrowidStr="+phacrowidStr;
	parent.frames['dhcpha.dispqueryitm'].location.href=lnk;

	
	}
function PopulateDispCat()
{ 
	setCatList();
}

	
function ClearClick()
{
	var obj; 
	obj=document.getElementById("Ward") ;
	if (obj) obj.value="" ;
	obj=document.getElementById("wardrowid") ;
	if (obj) obj.value="" ;
	obj=document.getElementById("DispCat") ;
	if (obj) obj.value="" ;
	obj=document.getElementById("Userid") ;
	if (obj) obj.value="" ;
	obj=document.getElementById("OperUser") ;
	if (obj) obj.value="" ;
	
	//obj=document.getElementById("t"+"dhcpha_dispquery");
	//if (obj) DelAllRows(obj) ;
	parent.frames['dhcpha.dispquery'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquery"
	parent.frames['dhcpha.dispquerytotal'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquerytotal"
	parent.frames['dhcpha.dispqueryitm'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispqueryitm"
	
	}
function FindClick()
{
	if (CheckQueryCondition()==false) return ;
	
	//parent.frames['dhcpha.dispqueryitm'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispqueryitm"
	//execute query 
	//var obj=document.getElementById("StartDate") ;
	//if (obj) StartDate=obj.value ;
	//var obj=document.getElementById("EndDate") ;
	//if (obj) EndDate=obj.value ;
	//var obj=document.getElementById("displocrowid") ;
	//if (obj) displocrowid=obj.value ;
	//var obj=document.getElementById("wardrowid") ;
	//if (obj) wardrowid=obj.value ;
	//var obj=document.getElementById("Userid") ;
	//if (obj) Userid=obj.value ;
	//var obj=document.getElementById("DispCat") ;
	//if (obj) DispCat=obj.value ;
	//var obj=document.getElementById("DispLoc") ;
	//if (obj) disploc=obj.value ;
	//var obj=document.getElementById("Ward") ;
	//if (obj) ward=obj.value ;
//	var obj=document.getElementById("OperUser") ;
//	if (obj) operuser=obj.value ;

	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquery"+
	//"&StartDate="+StartDate+"&EndDate="+EndDate+ "&displocrowid="+displocrowid+"&wardrowid="+wardrowid+"&Userid=" +Userid+"&DispCat="+DispCat
	//+"&DispLoc="+"#"+disploc+"#"+"&Ward="+"'"+ward+"'" 	//+"&OperUser="+ operuser
	//alert(lnk);
//	location.href=lnk;
	Find_click();
	parent.frames['dhcpha.dispquerytotal'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquerytotal"
	parent.frames['dhcpha.dispqueryitm'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispqueryitm"
	}
function CheckQueryCondition()
{ 
	var obj=document.getElementById("displocrowid")
	if (obj){
	  if (obj.value==""){alert(t['NO_DISPLOC']) ;
	     document.getElementById("DispLoc").focus()
	  	return false;  } }
	var obj1=document.getElementById("StartDate")
	if (obj1){
	  if (obj1.value==""){alert(t['NO_STARTDATE']) ;
	  	return false;  } } 
	var obj2=document.getElementById("EndDate")
	if (obj2){
	  if (obj2.value==""){alert(t['NO_ENDDATE']) ;
	  	return  false;  } }
	if (DateStringCompare(obj1.value,obj2.value)==1) {
		alert(t['INVALID_DATESCOPE']);
		return  false;
		}

}


function DispLocLookUpSelect(str)
{
	var ss=str.split("^") ;
	if ( ss.length>0) 
	{ 
	var obj=document.getElementById("displocrowid") ;
	if (obj) obj.value=ss[1] ; // rowid of the disp loc
	}
}

function WardLookUpSelect(str)
{
	var ss=str.split("^") ;
	if ( ss.length>0) 
	{ 
		var obj=document.getElementById("wardrowid") ;
		if (obj) obj.value=ss[1] ; // rowid of the disp loc
	}
}
function OperUserLookUpSelect(str)
{
	var ss=str.split("^") ;
	if (ss.length>0) {
		var obj=document.getElementById("Userid");
		if (obj) obj.value=ss[1] ;
		else obj.value="" ;
		}
	}
function CloseClick()
{ 
	parent.close() ;
	}
function PrintClick()
{	
	//PrintResult()
	//
	PrintSelect()
	}
	
function PrintSelect()
{	
	
	//获取所选行的发药单号
	var i=0;
	var h=0;
	var rowcnt ;
	var phacrowidStr=""
	var objtbl=document.getElementById("t"+"dhcpha_dispquery");
	if (objtbl)	rowcnt=getRowcount(objtbl)
	

	if (rowcnt<1){	return;  }
	             
	for(i=1;i<=rowcnt;i++)
	{
		var objCheck=document.getElementById("TSelect"+"z"+i);
		if (objCheck)
		{	
				   
			if(objCheck.checked==true)
			{  
		         h=h+1;    
		         var objcoll=document.getElementById("Tcollz"+i)
			     if (objcoll) var phac=objcoll.value;//主表rowid
			         
			     var objPamStr=document.getElementById("PamStr");
			     if (objPamStr){pam=objPamStr.value}; //明细表参数串
			         
			     phac=phac+"B"+pam
		  
			     if(phacrowidStr!="")
				    {	phacrowidStr=phacrowidStr+"A"+phac;		}
					else
				 {	phacrowidStr=phac;	}
			         	
			}
		}
				
	}
	

      
	phac=phacrowidStr
	//alert(phac)

	if (phacrowidStr=="")
	{
		//如果没有打勾,序号不为空,则后台以序号取 phac 串
        phac=GetPhacStr()
	}
	
	var ret=GetDetailOrTotal()  // 获取打印方式
	var detailprn=0;totalprn=0;
	if (ret==0){return;}
	if (ret==1){var detailprn=1}
	if (ret==2){var totalprn=1}
	if (ret==3){
		var totalprn=1
		var detailprn=1
	}
	
	var prthz=""
	var pid="001"
	//add wyx 2014-11-12 调用raq
	PrintRep(phac,"1","","");  //打印
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispprintBJFC"+"&Phac="+phac+"&PrtHz="+prthz+"&RePrintFlag="+1+"&DetailPrn="+detailprn+"&TotalPrn="+totalprn+"&PID="+pid
	//parent.frames['dhcpha.dispprintBJFC'].window.document.location.href=lnk;
	
	
}

function GetPhacStr()

{
		var objSno=document.getElementById("StartNo");
		if (objSno){startno=objSno.value}
		
		var objEno=document.getElementById("EndNo");
		if (objEno){endno=objEno.value}
		
		var objpid=document.getElementById("Tpidz"+1);
		if (objpid){pid=objpid.value}
		
		var objPamStr=document.getElementById("PamStr");
	    if (objPamStr){pam=objPamStr.value}; //明细表参数串
		
		if (startno==""){return "";}
		
		var obj=document.getElementById("getPhac") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		phac=cspRunServerMethod(encmeth,pid,startno,endno,pam) ;
		
		return phac ;
	
}
function GetDetailOrTotal()

{
	 ///description:获取打印方式
	 ///return:  1--明细  2 --汇总   3 -- 明细+汇总
	 ///creator:  lq   08-10-10
		var objDetailPrn=document.getElementById("DetailPrn");
		var objTotalPrn=document.getElementById("TotalPrn");
		var objPrnLab=document.getElementById("PrnLab");
		if ((objDetailPrn) && (objTotalPrn))
		
		{   /*  ---------如必选一项则放开----
			if ((objDetailPrn.checked==false) && (objTotalPrn.checked==false)&&(objPrnLab.checked==false))
		  
		     {  
		      alert("请选择打印方式:<打印汇总> <打印明细> <打印标签(限草药)>")
		      return 0;
			  }
			*/
			if (objDetailPrn.checked==true){var ret=1} 
			if (objTotalPrn.checked==true){var ret=2}
			if ((objTotalPrn.checked==true)&&(objDetailPrn.checked==true))
			{var ret=3}
		
		}
		return ret;
		
}
	
function PrintResult()
{  
	var obj=document.getElementById("currentRow");
	if (obj) var row=obj.value;
	if (row<1) return ;
	
	var objcoll=document.getElementById("Tcollz"+row)
	if (objcoll) var phac=objcoll.value;
	
	//
	var prthz=0;		
	//
	var objdisptype=document.getElementById("TDispCatz"+row)
	if (objdisptype) var disptype=objdisptype.innerText;

	//alert("disptype:"+disptype) ;
	var obj=document.getElementById("mPrtGetPrintFmt") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	prnfmt=cspRunServerMethod(encmeth,'','',phac) ;
	alert("prnfmt:"+prnfmt)
	
	if (prnfmt!="O")
	{
		var grp=session['LOGON.GROUPID'];
		var obj=document.getElementById("mPrtHz") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		prthz=cspRunServerMethod(encmeth,'','',grp,disptype) ;
	}
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispprintHX"+"&Phac="+phac+"&PrtHz="+prthz+"&RePrintFlag=1"
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispprint2"+"&Phac="+phac+"&PrtHz="+prthz+"&RePrintFlag=1"
	//	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispprintJST"+"&Phac="+phac+"&PrtHz="+prthz
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispprintSG"+"&Phac="+phac+"&PrtHz="+prthz+"&RePrintFlag=1"

	//window.open(lnk,phac,"width=10,height=10") ;
	 
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispprintHX"+"&Phac="+phac+"&PrtHz="+prthz+"&RePrintFlag="+1
	parent.frames['dhcpha.dispprintHX'].window.document.location.href=lnk;
         
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
	var obj=document.getElementById("DispLoc") ;
	if (obj) obj.value=locdesc
	var obj=document.getElementById("displocrowid") ;
	if (obj) obj.value=locdr
	
}

function SelectRowHandler() {

	var row=selectedRow(window);
	var obj=document.getElementById("currentRow") ;
	if (obj) obj.value=row;
	
	RowChange();
	
}

function setCatList()
{   //according to definition,display the dispensing category and description
	var obj=document.getElementById("mGetDrugType") ;
	if (obj) {var encmeth=obj.value}
	else {var encmeth=''};
	
	var result=cspRunServerMethod(encmeth)  ;
	var drugGrps=result.split("!")
	var cnt=drugGrps.length
	var objDispCat=document.getElementById("DispCat") 
	objDispCat.options[0]=new Option ("","") ;
	for (i=0;i<cnt;i++) {
		
		var drugGrpCode=drugGrps[i].split("^");
		var code=drugGrpCode[0];
		var desc=drugGrpCode[1];
		
	objDispCat.options[objDispCat.options.length]=new Option (desc,code) ; 
	}
}
function PrintOutDrug()
{
	var lnk="dhcpha.dispprintoutdrug.csp" ;
    window.open(lnk,"_blank","height=500,width=700,menubar=no,status=no,toolbar=no,resizable=yes") ;
}
function DoctorLocLookUpSelect(str)
{
	var doctorloc=str.split("^")
	if (doctorloc.length>0)
	{
		var obj=document.getElementById("DoctorLocRowid")
		if (obj) obj.value=doctorloc[1]
		
		}
}
function popDoctorLoc()
{
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DoctorLoc_lookuphandler();
	}// 2006-05-26
}
function DoctorLocCheck()
{	// 2006-05-26
	var obj=document.getElementById("DoctorLoc");
	var obj2=document.getElementById("DoctorLocRowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
}
function SendToAuto()
{
	var i=0;
	var errStr="";
	var errFlag=0;
	var objtbl=document.getElementById("t"+"dhcpha_dispquery");
	if (objtbl)	rowcnt=getRowcount(objtbl)
	if (rowcnt<1){	return;  }
	             
	for(i=1;i<=rowcnt;i++)
	{
		var objCheck=document.getElementById("TSelectz"+i);
		if (objCheck)
		{	
				   
			if(objCheck.checked==true)
			{  
		         
		         var objcoll=document.getElementById("Tcollz"+i)
			     if (objcoll) var phac=objcoll.value;//主表rowid
				 ret=tkMakeServerCall("web.DHCSTInterfacePH","SendOrderToMechine",phac)
				 if (ret!=0){errStr=errStr+ret;errFlag=1}	
			         	
			}
		}
				
	}
	if (errFlag==1){alert("发送包药机失败!请注意核实!"+errStr)}	
	
}
	
	
function KillDISPMQ()
{
	 
		var obj=document.getElementById("KillDISPMQ") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		var objpid=document.getElementById("Tpidz"+1) ;
		if (objpid){pid=objpid.value;
		prthz=cspRunServerMethod(encmeth,pid) ;}
		
}


///如果登录科室到是病区则返回空如果病区返回用户病区
///2010-11-22 liang qiang
function GetUserWard()
{
	
    var loc=session['LOGON.CTLOCID'];	
    var xx=document.getElementById("getuserward");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var str=cspRunServerMethod(encmeth,loc) ;
	var tem=str.split("^");
	if (str!="")
	{
		var objWard=document.getElementById("Ward");
		objWard.value=tem[0];
		var objwardrowid=document.getElementById("wardrowid");
		objwardrowid.value=tem[1];
		DisableFieldByID("mGetComponentID","Ward");
	}

	
}

document.body.onbeforeunload=function(){

   KillDISPMQ();//清除本次^TMP("dhcpha",pid,"DISPMQ")
  } 
  
document.body.onload=BodyLoadHandler;