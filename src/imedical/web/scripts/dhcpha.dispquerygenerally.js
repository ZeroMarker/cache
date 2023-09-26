var oPopup;
var gNewCatId=""
function BodyLoadHandler()
{
	
	var obj=document.getElementById("DispWorkStat") ;
	if (obj) obj.onclick=DispWorkStatClick; 
	var obj=document.getElementById("Clear") ;
	if (obj) obj.onclick=ClearClick; 
	var obj=document.getElementById("Find") ;
	if (obj) obj.onclick=FindClick; 
	var obj=document.getElementById("Exit") ;
	if (obj) obj.onclick=ExitClick; 
	var obj=document.getElementById("WardPhaReturnStat") ;
	if (obj) obj.onclick=WardPhaReturnStatClick; 
	var obj=document.getElementById("Print") ;
	if (obj) obj.onclick=PrintClick; 
	var obj=document.getElementById("tdhcpha_dispquerygenerally") ;
	if (obj) 
	{
		 obj.ondblclick=RowChanged;
	}
	
	var obj=document.getElementById("DispCat") ;
	if (obj)  obj.onchange=selectDispCat;
	
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
	var obj=document.getElementById("DispOper"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popDispOper;
	 obj.onblur=DispOperCheck;
	} //2005-05-26
	var obj=document.getElementById("AdmLoc"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popAdmLoc;
	 obj.onblur=AdmLocCheck;
	} //2005-05-26
	var obj=document.getElementById("Alias"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popAlias;
	 obj.onblur=AliasCheck;
	} //2005-05-26
	var obj=document.getElementById("PhcCat"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popPhcCat;
	 obj.onblur=PhcCatCheck;
	} //2005-05-26
	var obj=document.getElementById("PhcSubCat"); //2007-03-16
	if (obj) 
	{obj.onkeydown=popPhcSubCat;
	 obj.onblur=PhcSubCatCheck;
	}
	var obj=document.getElementById("PhcMinorSubCat"); //2007-03-16
	if (obj) 
	{obj.onkeydown=popPhcMinorSubCat;
	 obj.onblur=PhcMinorSubCatCheck;
	}
	var obj=document.getElementById("PhcForm"); //2007-03-16
	if (obj) 
	{obj.onkeydown=popPhcForm;
	 obj.onblur=PhcFormCheck;
	}
	var obj=document.getElementById("DocLoc"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popDocLoc;
	 obj.onblur=DocLocCheck;
	} //2005-05-26
	
	obj=document.getElementById("RegNo") ;    //zhangdongmei 2007-3-16
 	if (obj) obj.onblur=RegNoBlur; 
 	if (obj) obj.onkeydown=RegNoEnter;
 
 	var obj=document.getElementById("CManGroup"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popCManGroup;
	 obj.onblur=CManGroupCheck;
	} //2005-05-26
    //------------------------------------
    var obj=document.getElementById("INCStkCat"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popINCStkCat;
	obj.onblur=INCStkCatCheck;
	} //lq 2007-08-02
    
    var obj=document.getElementById("Poison"); //2005-05-26
	if (obj) 
	{obj.onkeydown=popPoison;
	obj.onblur=PoisonCheck;
	} //lq 2007-08-02
    
     //------------------------------------
	var obj=document.getElementById("OnlyDoc");
	if (obj) obj.onclick=SetOnlyDoc;
	var obj=document.getElementById("OnlyOut");
	if (obj) obj.onclick=SetOnlyOut;
	var obj=document.getElementById("ExcludeDoc");
	if (obj) obj.onclick=SetQueryExclude;
	var obj=document.getElementById("ExcludeOut");
	if (obj) obj.onclick=SetQueryExclude;
	var obj=document.getElementById("ShowRecord");
	if (obj) obj.onclick=ShowRecordClick;
	var obj=document.getElementById("bCNewPhCat");
	if (obj) obj.onclick=PhcCatTreeOpen;
	var obj=document.getElementById("NewPhCatDesc");
	if (obj) obj.onkeydown=popPhCatTree;
	
    
	PopulateDispCat();
	obj=document.getElementById("BodyLoaded");
	
	if (obj.value!=1)
	{
	    //GetDefLoc();
		setDefaultDate();
	}
	//setDefaultDate();
	setBodyLoaded();
	 
    //setDisabledtrue();

}
function PhcCatCheck()
{
	// 2006-05-26
	var obj=document.getElementById("PhcCat");
	var obj2=document.getElementById("phccatrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}// 2006-05-26
function popPhcCat()
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  PhcCat_lookuphandler();
		}
}//2006-05-26

function popPhcSubCat()
{ 
	// 2007-03-16
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	  	PhcSubCat_lookuphandler();
	}
}

function PhcSubCatCheck()
{
	// 2007-03-16
	var obj=document.getElementById("PhcSubCat");
	var obj2=document.getElementById("PhcSubCatRowID");
	if (obj) 
	{if (obj.value=="") obj2.value=""; }
	
}

function popPhcMinorSubCat()
{ 
	// 2007-03-16
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	  	PhcMinorSubCat_lookuphandler();
	}
}

function PhcMinorSubCatCheck()
{
	// 2007-03-16
	var obj=document.getElementById("PhcMinorSubCat");
	var obj2=document.getElementById("PhcMinorSubCatRowID");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
}
	
function AliasCheck()
{
	// 2006-05-26
	var obj=document.getElementById("Alias");
	var obj2=document.getElementById("incirowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}// 2006-05-26
function popAlias()
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Alias_lookuphandler();
		}
}//2006-05-26

function AdmLocCheck()
{
	// 2006-05-26
	var obj=document.getElementById("AdmLoc");
	var obj2=document.getElementById("admlocrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}// 2006-05-26
function popAdmLoc()
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  AdmLoc_lookuphandler();
		}
}//2006-05-26
function DispOperCheck()
{
	// 2006-05-26
	var obj=document.getElementById("DispOper");
	var obj2=document.getElementById("dispoperrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}// 2006-05-26
function popDispOper()
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DispOper_lookuphandler();
		}
}//2006-05-26

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

function popCManGroup()     
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  CManGroup_lookuphandler();
		}
	}//2006-05-26
function CManGroupCheck()
{// 2006-05-26
	var obj=document.getElementById("CManGroup");
	var obj2=document.getElementById("CManGroupID");
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
function DocLocCheck()
{
	// 2006-05-26
	var obj=document.getElementById("DocLoc");
	var obj2=document.getElementById("DoctorLocRowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
	}// 2006-05-26
function popDocLoc()
{ // 2006-05-26
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  DocLoc_lookuphandler();
		}
}//2006-05-26

//-------------------------lq  2007-08-02

function popINCStkCat()     
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  INCStkCat_lookuphandler();
		}
}
	
function INCStkCatCheck()
{
	var obj=document.getElementById("INCStkCat");
	var obj2=document.getElementById("IncStkCatRowid");
	
	//var obj3=document.getElementById("PoisonRowid");
	//var obj4=document.getElementById("Str");
	
	if (obj) 
	{if (obj.value=="") 	 obj2.value="" 
	// obj4.value=obj3.value+"^"+""
			}	
}
	
	
	
function popPoison()     
{ 
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	  	Poison_lookuphandler();
	}
}


function PoisonCheck()
{
	
	var obj=document.getElementById("Poison");
	var obj3=document.getElementById("PoisonRowid");
	if (obj) 
	{if (obj.value=="") 	 obj3.value="" 
	 	}
}


//------------------------------

function setBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded") ;
	if (obj) obj.value=1;
}

function setDefaultDate()
{	var t=today();
	var obj=document.getElementById("StartDate") ;
	if (obj) obj.value=t;
	var obj=document.getElementById("EndDate") ;
	if (obj) obj.value=t;
}

function selectDispCat()
{
	var obj1=document.getElementById("dispcatval");
	var obj2=document.getElementById("DispCat");
	obj1.value=obj2.value;
}

function PopulateDispCat()
{ 
	setCatList();
}
function DoctorLocLookUpSelect(str)
{
	var doctorloc=str.split("^")
	if (doctorloc.length>0)
	{
		var obj=document.getElementById("DoctorLocRowid")
		if (obj) obj.value=doctorloc[1]  ;
	}
}

function ClearClick()
{  
	ClearField("StartDate");
	ClearField("EndDate");
	ClearField("Ward");
	ClearField("wardrowid");
	ClearField("AdmLoc");
	ClearField("admlocrowid");
	ClearField("PhcCat");
	ClearField("phccatrowid");
	ClearField("DispOper");
	ClearField("dispoperrowid");
	ClearField("InciDesc");
	ClearField("DispCat");
	ClearField("Poison"); //lq add
	ClearField("INCStkCat"); //lq add
	
	//clear the result 
	clearResult();
	gNewCatId=""
   var obj=document.getElementById("NewPhCatRowid");
	if (obj) obj.value=""
	}
function clearResult()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquerygenerally"		  
	parent.frames['dhcpha.dispquerygenerally'].document.location.href=lnk	;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquerygenerallyitm"		  
	parent.frames['dhcpha.dispquerygenerallyitm'].document.location.href=lnk	;

}
function FindClick()
{//at first ,check and validate the conditions for query
	if (CheckFindCondition()==false) return ;
	//var obj=document.getElementById("StartDate");
	//if (obj) var sd=obj.value ;
	//var obj=document.getElementById("EndDate");
	//if (obj) var ed=obj.value ;
	//var obj=document.getElementById("displocrowid");
	//if (obj) var displocrowid=obj.value ;
	//var obj=document.getElementById("wardrowid");
	//if (obj) var wardrowid=obj.value ;
	//var obj=document.getElementById("dispoperrowid");
	//if (obj) var dispoperrowid=obj.value ;
	//var obj=document.getElementById("dispcat");
	//if (obj) var dispcat=obj.value ;
	//var obj=document.getElementById("phccatrowid");
	//if (obj) var phccatrowid=obj.value ;
	//var obj=document.getElementById("incirowid");
	//if (obj) var incirowid=obj.value ;
	//var obj=document.getElementById("admlocrowid");
	//if (obj) var admlocrowid=obj.value ;
	
	
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquerygenerally&StartDate="+sd
	//	+"&EndDate="+ed+"&displocrowid="+displocrowid+"&wardrowid="+wardrowid+"&dispoperrowid="+dispoperrowid
	//	+"&dispcat="+dispcat+"&phccatrowid="+phccatrowid+"&incirowid="+incirowid+"&admlocrowid="+admlocrowid ;
	//alert(lnk);
	//location.href=lnk ;
	//StartDate, EndDate , displocrowid , wardrowid , dispoperrowid , dispcat , phccatrowid , incirowid , admlocrowid 	
	
    //setDisabledfalse();
	clearResult();	
	Find_click();
	
	
	
	
	}

function CheckFindCondition()
{
	
	var obj1 =document.getElementById("StartDate") ;
	if (obj1)
	{if (obj1.value=="" )
		{alert(t['NO_STARTDATE']);
		 obj1.focus();
		 return false ;
			} 
		}
	var obj2 =document.getElementById("EndDate") ;
	if (obj2)
	{if (obj2.value=="" )
		{alert(t['NO_ENDDATE']);
		 obj2.focus();
		 return false ;
			} 
		}
		
	var obj; 
	obj =document.getElementById("displocrowid") ;
	if ((obj)&&(obj.value=="")) 
	{alert(t['NO_DISPLOC']) ;
	 var obj=document.getElementById("DispLoc") 
	 if (obj) obj.focus();
	 return false ;
		}
	if (DateStringCompare(obj1.value,obj2.value)==1)
	{alert(t['INVALID_DATESCOPE']) ;
	  return false ;
		}
	//set value for pharmacy cat string
	var obj=document.getElementById("PhcCatRowidStr") ;
	if (obj){
	 var obj1=document.getElementById("phccatrowid") ;
	 var obj2=document.getElementById("PhcSubCatRowID") ;
	 //var obj3=document.getElementById("PhcMinorSubCatRowID") ;
	 var obj3=document.getElementById("PhcMinorSubCat")
	 obj.value=obj1.value+"^"+obj2.value+"^"+obj3.value; 	
	}	
	
	
	var Poison=document.getElementById("PoisonRowid");
	var stkcatrowid=document.getElementById("IncStkCatRowid");
	var Strid=document.getElementById("Str");
	if (Strid) Strid.value=Poison.value+"^"+stkcatrowid.value;


 var onlydoc=0,onlyout=0;
 var excludedoc=0,excludeout=0;
	 
 var obj1=document.getElementById("OnlyDoc") ;
 var obj2=document.getElementById("OnlyOut") ;
 var obj3=document.getElementById("ExcludeDoc") ;
 var obj4=document.getElementById("ExcludeOut") ;
 
 if (obj1.checked) onlydoc=1
 if ((obj2.checked)&&(obj2)) onlyout=1
 if (obj3.checked) excludedoc=1
 if ((obj4.checked)&&(obj4)) excludeout=1

 var NewPhCatRowid=document.getElementById("NewPhCatRowid").value;
	 
	Strid.value=Strid.value+"^"	+ onlydoc+"^"+onlyout+"^"+ excludedoc	+"^"+ excludeout +"^"+ NewPhCatRowid 	
	
	return true ;
}
	
function ExitClick()
{ 	history.back();	
	}
function DispWorkStatClick()
{  
   //location.href=lnk;
   var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquerydaywork";
   window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes,scrollbars=yes") ;
   //window.open(lnk,"_blank","height=800,width=800,menubar=no,status=no,toolbar=no,resizable=yes") ;
	}
function WardPhaReturnStatClick()
{  var lnk="dhcpha.dispquerywardret.csp";
   //location.href=lnk;
   window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;

}

function DispLocLookUpSelect(str)
{   var loc=str.split("^");
  var obj=document.getElementById("displocrowid");
  if (obj)
  {if (loc.length>0)   obj.value=loc[1] ;
    else
       obj.value="" ;  
  	 }
	}
function WardLookUpSelect(str)
{ var ward=str.split("^");
  var obj=document.getElementById("wardrowid");
  if (obj)
  {if (ward.length>0)   obj.value=ward[1] ;
    else
       obj.value="" ;  
  	 }
	}
function AdmLocLookUpSelect(str)
{ var loc=str.split("^");
  var obj=document.getElementById("admlocrowid");
  if (obj)
  {if (loc.length>0)   obj.value=loc[1] ;
    else
       obj.value="" ;  
  	 }}
function PhcCatLookUpSelect(str)
{
	var phccat=str.split("^");
	var obj=document.getElementById("phccatrowid");
	if (obj)
	{if (phccat.length>0)   obj.value=phccat[1] ;
		else  obj.value="" ;  
	 }
	}
	
function PhcSubCatLookUpSelect(str)
{
	var phcsubcat=str.split("^");
	var obj=document.getElementById("PhcSubCatRowID");
	if (obj)
	{
		if (phcsubcat.length>0)   
		{
			obj.value=phcsubcat[1] ;
		}
		else  
		{
			obj.value="" ;
		}  
	}
}

function PhcMinorSubCatLookUpSelect(str)
{
	var phcminorsubcat=str.split("^");
	var obj=document.getElementById("PhcMinorSubCatRowID");
	if (obj)
	{
		if (phcminorsubcat.length>0)   
		{
			obj.value=phcminorsubcat[1] ;
		}
		else  
		{
			obj.value="" ;
		}  
	}
}

function PhcFormLookUpSelect(str)
{
	var phcform=str.split("^");
	var obj=document.getElementById("PhcFormRowID");
	if (obj)
	{
		if (phcform.length>0)   
		{
			obj.value=phcform[1] ;
		}
		else  
		{
			obj.value="" ;
		}  
	}
}

function AliasLookupSelect(str)
{	var inci=str.split("^");
	var obj=document.getElementById("incirowid");
	if (obj)
	{if (inci.length>0)   obj.value=inci[2] ;
		else  obj.value="" ;  
	 }

	}
function ClearField(ss)
{	var obj; 
	obj = document.getElementById(ss) ;
	if (obj) obj.value="" ;
}


function PrintClick()
{

	//var saveflag=SaveRecord();
	//if (saveflag<0){return;}

	var processid ;
	var incicode="" ;
	var moneySum=0;
	var obj=document.getElementById("TPID"+"z1")
	if (obj)  processid=obj.value;
	else
	{ return ; }
	
	if (processid=="") return;
	//
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	prnpath=cspRunServerMethod(encmeth,'','') ;
	//
	var Template=prnpath+"STP_DispStatGenerally_NX.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
	if (xlsheet==null) 
	{alert(t["CANNOT_CREATE_PRNOBJ"]);
		return ;
	}
	var startrow=5;
	var prndatetime=getPrintDateTime();
	var obj=document.getElementById("DispLoc");
	if (obj) var disploc=obj.value;
	var obj=document.getElementById("StartDate");
	if (obj) var sdate=obj.value;
	var obj=document.getElementById("EndDate");
	if (obj) var edate=obj.value;
	var HospitalDesc=tkMakeServerCall("web.DHCSTKUTIL","GetHospName",session['LOGON.HOSPID']);
	xlsheet.Cells(1,1).Value=HospitalDesc+"发药综合查询统计"
	xlsheet.Cells(3,1).Value="科室:"+getDesc(disploc);
	xlsheet.Cells(2,1).Value="统计日期:"+sdate+"--"+edate+"      "+"打印日期:"+prndatetime
	
	var obj=document.getElementById("Ward")
	if (obj.value!="")
	{
		xlsheet.Cells(3,3).Value=t['WARD']+getDesc(obj.value);	
	}
	
	var obj=document.getElementById("mListPrnData") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	
	var i=0;
	do {
		var ss=cspRunServerMethod(encmeth,'','',processid,incicode) ;
		if (ss!="")
		{  
			var data=ss.split("^") ;
			var incicode=data[0];
            //alert(incicode);
			var incidesc=data[1];
			var pakuom=data[2];
			var dispqty=data[10]
			var retqty=data[12]
			var qty=data[3];
			var money=data[4];
			var price=data[9];
			
			moneySum=moneySum+parseFloat(money);
			xlsheet.Cells(startrow+i,1).Value=incidesc;
			xlsheet.Cells(startrow+i,2).Value=pakuom;
			xlsheet.Cells(startrow+i,3).Value=dispqty;
			xlsheet.Cells(startrow+i,4).Value=retqty;
			xlsheet.Cells(startrow+i,5).Value=qty;
			xlsheet.Cells(startrow+i,6).Value=price;
			xlsheet.Cells(startrow+i,7).Value=money;
			setBottomLine(xlsheet,startrow+i,1,7)
			i=i+1;
		}
	} 
	while ((ss!="")&&(incicode!=""))
	if (i<1)
	{SetNothing(xlApp,xlBook,xlsheet);
		return ;	}

	i=i+1
	xlsheet.Cells(startrow+i,1).Value=t['SUM'];
	xlsheet.Cells(startrow+i,7).Value=moneySum;
	
	xlsheet.printout;
	
    SetNothing(xlApp,xlBook,xlsheet);
    
    
    
    
    
    	
}

function RowChanged()
{ //current row
 /// var obj=document.getElementById("t"+"dhcpha_dispquerygenerally")
  var row=selectedRow(window) ;
  if (row>0)
  {  
	  var obj=document.getElementById("TPIDz"+row) ;
	  if (obj) var pid=obj.value;
	  var obj=document.getElementById("TCodez"+row);
	  if (obj) 
	  {
		  var incicode=obj.value;
	  }
	 // alert(pid);
	  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquerygenerallyitm&ProcessID="+pid+"&Code="+incicode		  
	  parent.frames['dhcpha.dispquerygenerallyitm'].document.location.href=lnk	;
	  
	  }
	
}

function GetDefLoc()
{	
	var objBodyLoaded=document.getElementById("BodyLoaded") ;
	if (objBodyLoaded) BodyLoaded=objBodyLoaded.value;
	
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
function OperUserLookUpSelect(str)
{
	var ss=str.split("^") ;
	if (ss.length>0) {
		var obj=document.getElementById("dispoperrowid");
		if (obj) obj.value=ss[1] ;
		else obj.value="" ;
		}
}

function SetNothing(app,book,sheet)
{
	app=null;
	book.Close(savechanges=false);
	sheet=null;
	}
function setBottomLine(objSheet,row,startcol,colnum)
{
    objSheet.Range(objSheet.Cells(row, startcol), objSheet.Cells(row, startcol + colnum - 1)).Borders(9).LineStyle=1 ;

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

function RegNoBlur()
{
	//when RegNo lost focus then this event fires .
	
	var obj=document.getElementById("RegNo") ;
	var regno ;
	if (obj)
	{ 
	 	regno=obj.value ;
	 	if (regno=="")
	 	{	
	 		ClearField("Name") ;		
	 		return ;
	 	}
	 	else
	 	{
		 	obj.value=getRegNo(regno) ;
	  		regno=obj.value ; 
	  		
	  	}
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
	obj=document.getElementById("Name");
	if (obj) obj.value=painfo[0];
}

function RegNoEnter()
{ 
	if (window.event.keyCode==13) 
		{RegNoBlur();}
	else
		{var obj=document.getElementById("RegNo")
		 if(isNaN(obj.value)==true)  { obj.value="" ;}
			}
}

function popPhcForm()
{ 
	// 2007-03-16
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	  	PhcForm_lookuphandler();
	}
}

function PhcFormCheck()
{
	// 2007-03-16
	var obj=document.getElementById("PhcForm");
	var obj2=document.getElementById("PhcFormRowID");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}
	
}
function GetGroupID(value)
{
 var sstr=value.split("^")
 var fydrobj=document.getElementById("CManGroupID")
     fydrobj.value=sstr[1];
}

function IncStkCatLookUpSelect(str)  
{ 
    //取库存分类rowid    by lq  2007/08/02
 var IncStkCat=str.split("^");
	var obj=document.getElementById("IncStkCatRowid");
	
	if (obj)
	{
		if (IncStkCat.length>0)   
		{			obj.value=IncStkCat[1] ;		}
		else  
		{			obj.value="" ;		}  
	}
}

function PoisonLookUpSelect(str)
{ 
	 //取管制分类rowid  by lq  2007/08/02
	var Poison=str.split("^");
	var obj=document.getElementById("PoisonRowid");
	if (obj)
	{
		if (Poison.length>0)   
		{
			obj.value=Poison[1] ;
		}
		else  
		{
			obj.value="" ;
		}  
	}
 }
function SetOnlyDoc()
{ var obj=document.getElementById("OnlyDoc")
 if (obj.checked)
 {
	 var obj2=document.getElementById("OnlyOut")
	 var obj3=document.getElementById("ExcludeDoc")
	 var obj4=document.getElementById("ExcludeOut")
	 
	 obj2.checked=false
	 obj3.checked=false
	 obj4.checked=false
 }
}
function SetOnlyOut()
{var obj=document.getElementById("OnlyOut")
 if (obj.checked)
 {
 var obj2=document.getElementById("OnlyDoc")
 var obj3=document.getElementById("ExcludeDoc")
 var obj4=document.getElementById("ExcludeOut")
 
 obj2.checked=false
 obj3.checked=false
 obj4.checked=false
}
}
	
function SetQueryExclude()
{
	 var obj1=document.getElementById("OnlyDoc")
	 var obj2=document.getElementById("OnlyOut")
		obj1.checked=false
		obj2.checked=false
	}
/*	
function SupplyClick()
{
	
	var obj=document.getElementById("Supply");
	
	if (obj.checked) 
	{ 
		var obj=document.getElementById("StartDate");
		if (obj) obj.disabled=true;
		if ((obj)&&(obj.value=="")){ alert("开始日期不能为空")}
		var obj=document.getElementById("ld51083iStartDate");
		if (obj) obj.disabled=true;
		
		var obj=document.getElementById("EndDate");
		if (obj) obj.disabled=true;
		if ((obj)&&(obj.value=="")){ alert("结束日期不能为空")}
		
		var obj=document.getElementById("ld51083iEndDate");
		if (obj) obj.disabled=true;
		var obj=document.getElementById("StartTime");
		if (obj) obj.disabled=true;
		var obj=document.getElementById("EndTime");
		if (obj) obj.disabled=true;
		
		var obj=document.getElementById("DispLoc");
		if (obj) obj.disabled=true;
		if ((obj)&&(obj.value==""))	{ alert("发药科室不能为空")}
		
		var obj=document.getElementById("ld51083iDispLoc");
		if (obj) obj.disabled=true;
		var obj=document.getElementById("Ward");
		if (obj) obj.disabled=true;
		if ( (obj)&&(obj.value=="") ){ alert("病区不能为空")}
		var obj=document.getElementById("ld51083iWard");
		if (obj) obj.disabled=true;
		var obj=document.getElementById("Find") ;
	    if (obj) obj.disabled = true; 
		
	}
	
	else
	{
		var obj=document.getElementById("StartDate");
		if (obj) obj.disabled=false;
		var obj=document.getElementById("ld51083iStartDate");
		if (obj) obj.disabled=false;
		var obj=document.getElementById("EndDate");
		if (obj) obj.disabled=false;
		var obj=document.getElementById("ld51083iEndDate");
		if (obj) obj.disabled=false;
		var obj=document.getElementById("StartTime");
		if (obj) obj.disabled=false;
		var obj=document.getElementById("EndTime");
		if (obj) obj.disabled=false;
		var obj=document.getElementById("DispLoc");
		if (obj) obj.disabled=false;
		var obj=document.getElementById("ld51083iDispLoc");
		if (obj) obj.disabled=false;
		var obj=document.getElementById("Ward");
		if (obj) obj.disabled=false;
		var obj=document.getElementById("ld51083iWard");
		if (obj) obj.disabled=false;
		var obj=document.getElementById("Find") ;
	    if (obj) obj.disabled=false;
	}
	
}	
*/
function SaveRecord()
{

       var obj=document.getElementById("t"+"dhcpha_dispquerygenerally")
	   var row=obj.rows.length-2 ;
	   
       if (row>0)
       {
	       var obj=document.getElementById("Supply");
	       if ((obj.checked)&&(obj))
				{
						var obj=document.getElementById("StartDate");
						if (obj) var sdate=obj.value;
						var obj=document.getElementById("EndDate");
						if (obj) var edate=obj.value;
						if  (edate<sdate) {alert("结束日期不能小于开始日期");return -4;}	
						var obj=document.getElementById("StartTime");
						if (obj) var stime=obj.value;
						var obj=document.getElementById("EndTime");
						if (obj) var etime=obj.value;
						if ((edate==sdate)&&(etime<stime)) {alert("结束时间不能小于开始时间");return -5;}
						var obj=document.getElementById("wardrowid");
						if (obj) var warddr=obj.value;
						var obj=document.getElementById("displocrowid");
						if (obj) var displocrowid=obj.value;
						
						if (warddr=="") {alert("病区为空,保存打印记录失败,请重新打印!");return -1;}
						
						userid=session['LOGON.USERID'];
				
						var saverecord=document.getElementById('mSaveRecord');
						if (saverecord) {var encmeth=saverecord.value} else {var encmeth=''};
						var ret=cspRunServerMethod(encmeth,displocrowid,sdate,stime,edate,etime,warddr,userid) ; 
						
						if (ret!=1){ alert("保存打印记录失败,请重新打印!") ;return -2; }
						
						if (ret==1) {alert("保存补给记录成功")}
						
						return 0
				}
       }
		else
		
			{alert("无记录");return -3;}
}
function ShowRecordClick()
{ 
        var obj=document.getElementById("ShowRecord")
        if (obj.disabled) {return;}
   		var obj=document.getElementById("StartDate");
		if (obj) var sdate=obj.value;
		var obj=document.getElementById("EndDate");
		if (obj) var edate=obj.value;
		var obj=document.getElementById("StartTime");
		if (obj) var stime=obj.value;
		var obj=document.getElementById("EndTime");
		if (obj) var etime=obj.value;
		var obj=document.getElementById("wardrowid");
		if (obj) var warddr=obj.value;
		var obj=document.getElementById("displocrowid");
		if (obj) var displocrowid=obj.value;
		
		var str=sdate+"^"+edate+"^"+stime+"^"+etime+"^"+warddr+"^"+displocrowid

        var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.supplyrecord&Str="+str;
        window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes,scrollbars=yes") ;

}

function popPhCatTree(){
	if (window.event.keyCode==13) 
    {  
        window.event.keyCode=117;
        PhcCatTreeOpen();
    }
	}
/*function PhcCatTreeOpen(){
	var lnk="dhcst.cattree.csp";
	var data=document.getElementById("NewPhCatDesc").value;
	 
	var CatStr=showModalDialog(lnk,data,"dialogWidth=500px;dialogHeight=600px;resizable=yes");
	if(CatStr!=""){
	var CatArr=CatStr.split("^")
	var CatDesc=CatArr[0]
	var CatRowid=CatArr[1]
	var obj=document.getElementById("NewPhCatRowid");
	if (obj) obj.value=CatRowid;
	var obj=document.getElementById("NewPhCatDesc");
	if (obj) obj.value=CatDesc;
	}
}
*/
//GetAllCatNew("kkk");
function GetAllCatNew(catdescstr,newcatid){
	//if ((catdescstr=="")&&(newcatid=="")) {return;}
	//Ext.getCmp("PHCCATALL").setValue(catdescstr);
	var obj=document.getElementById("PHCCATALL");
	if (obj) obj.value=catdescstr
	gNewCatId=newcatid;
	var obj=document.getElementById("NewPhCatRowid");
	if (obj) obj.value=gNewCatId
	
	
}
//add wyx 2015-02-11
 function PhcCatTreeOpen() {	
       //var lnk="dhcst.phccatall.csp?gNewCatId="+gNewCatId;
       //window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
    
     var retstr=showModalDialog('dhcst.phccatall.csp?gNewCatId='+gNewCatId,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')

       if (!(retstr)){
          return;
        }
        
        if (retstr==""){
          return;
        }
     
	var phacstr=retstr.split("^")
	GetAllCatNew(phacstr[0],phacstr[1])

    }

/*
function setDisabledfalse()
{ 

			var obj=document.getElementById("StartDate");
			if (obj) obj.disabled=false;
			var obj=document.getElementById("ld51083iStartDate");
			if (obj) obj.disabled=false;
			var obj=document.getElementById("EndDate");
			if (obj) obj.disabled=false;
			var obj=document.getElementById("ld51083iEndDate");
			if (obj) obj.disabled=false;
			var obj=document.getElementById("StartTime");
			if (obj) obj.disabled=false;
			var obj=document.getElementById("EndTime");
			if (obj) obj.disabled=false;
			var obj=document.getElementById("DispLoc");
			if (obj) obj.disabled=false;
			var obj=document.getElementById("ld51083iDispLoc");
			if (obj) obj.disabled=false;
			var obj=document.getElementById("Ward");
			if (obj) obj.disabled=false;
			var obj=document.getElementById("ld51083iWard");
			if (obj) obj.disabled=false;
			
			var obj=document.getElementById("Supply")
		  	if (obj) obj.disabled=false;
	  		
}
function setDisabledtrue()
{ 
	   var obj=document.getElementById("Supply");
       if ((obj.checked)&&(obj))
       { 
			var obj=document.getElementById("StartDate");
			if (obj) obj.disabled=true;
			var obj=document.getElementById("ld51083iStartDate");
			if (obj) obj.disabled=true;
			var obj=document.getElementById("StartTime");
			if (obj) obj.disabled=true;
			
			var obj=document.getElementById("t"+"dhcpha_dispquerygenerally")
	        var row=obj.rows.length-2 ;
            if (row>0)
            {
				var obj=document.getElementById("EndDate");
				if (obj) obj.disabled=true;
				var obj=document.getElementById("ld51083iEndDate");
				if (obj) obj.disabled=true;

				var obj=document.getElementById("EndTime");
				if (obj) obj.disabled=true;
				var obj=document.getElementById("DispLoc");
				if (obj) obj.disabled=true;
				var obj=document.getElementById("ld51083iDispLoc");
				if (obj) obj.disabled=true;
				var obj=document.getElementById("Ward");
				if (obj) obj.disabled=true;
				var obj=document.getElementById("ld51083iWard");
				if (obj) obj.disabled=true;
			  }	
				var obj=document.getElementById("Supply")
		  	    if (obj) obj.disabled=true;	
				var obj=document.getElementById("ShowRecord")
		  	    if (obj) obj.disabled=true;
            
       }	
}
*/




document.body.onload=BodyLoadHandler;
document.body.onbeforeunload=function(){
   var objtbl=document.getElementById("t"+"dhcpha_dispquerygenerally")
   if(objtbl){
	   var cnt=objtbl.rows.length-1;
	   if (cnt>0){
	   var objPid= document.getElementById("TPID"+"z"+1)
	   pid=objPid.value
       var exe
	   var obj=document.getElementById("mKillTmpGlobal")
	   if (obj) {exe=obj.value;} else {exe='';}
	   var sss=cspRunServerMethod(exe,pid)
	            }
       }
  } 