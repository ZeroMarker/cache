var	dispsd="";
var disped="";
var bodyloaded="" ;
 var objBodyLoaded;
 
function BodyLoadHandler()
{
	var obj=document.getElementById("Find");
	if (obj) obj.onclick=FindClick ;
	var obj=document.getElementById("Clear")
	if (obj) obj.onclick=ClearClick ;
	var obj=document.getElementById("Close")
	if (obj) obj.onclick=CloseClick ;
	var obj=document.getElementById("Print")
	if (obj) obj.onclick=PrintClick ;
    var obj=document.getElementById("RetReason")
	if (obj)  obj.onblur=reasonCheck;
	
	//GetDefLoc();
	setDefaultDate();
	} 	
	 
function setDefaultDate()
{	
     objbodyloaded=document.getElementById("BodyLoaded") ;
    if (objbodyloaded) bodyloaded=objbodyloaded.value;
  if (bodyloaded=="")
  { 
    var t=today();
	var obj=document.getElementById("StartDate") ;
	if (obj) obj.value=t;
	var obj=document.getElementById("EndDate") ;
	if (obj) obj.value=t;
	objbodyloaded.value="1"
  }
}


function FindClick()
{
	if (CheckFindCondition()==false) return ;

	
	////execute query
	//var obj=document.getElementById("StartDate") ;
	//if (obj) var sd=obj.value;
	//var obj=document.getElementById("EndDate") ;
	//if (obj) var ed=obj.value;
	//var obj=document.getElementById("displocrowid") ;
	//if (obj) var displocrowid=obj.value;

	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquerywardret&StartDate="+sd+"&EndDate="+ed+"&displocrowid="+displocrowid
	////alert(lnk);
	//location.href=lnk;
	Find_click();
	}
function CheckFindCondition()
{
	var obj; 
	obj =document.getElementById("displocrowid") ;
	if ((obj)&&(obj.value=="")) 
	{alert(t['NO_DISPLOC']) ;
	 return false ;
		}
	var obj1 =document.getElementById("StartDate") ;
	if (obj1)
	{if (obj1.value=="" )
		{alert(t['NO_STARTDATE']);
		 return false ;
			} 
		}
	var obj2 =document.getElementById("EndDate") ;
	if (obj2)
	{if (obj2.value=="" )
		{alert(t['NO_ENDDATE']);
		 return false ;
			} 
		}
	if (DateStringCompare(obj1.value,obj2.value)==1)
	{alert(t['INVALID_DATESCOPE']) ;
	  return false ;
		}
	
	return true ;
	}

function ClearClick()
{
// clear the result 
// 	
	//var obj=document.getElementById("StartDate") ;
	//if (obj) obj.value="";
	//var obj=document.getElementById("EndDate") ;
	//if (obj) obj.value="";
	
	ReloadWinow();
}
function ReloadWinow()
{	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquerywardret"		  
	parent.frames['dhcpha.dispquerywardret'].document.location.href=lnk	;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquerywardretitm"		  
	parent.frames['dhcpha.dispquerywardretitm'].document.location.href=lnk	;

}
function CloseClick()
{window.parent.close();}
function PrintClick()
{PrintResult() ;}

function DispLocLookUpSelect(str)
{
	var ss=str.split("^")
	if ( ss.length>0) 
	{ 
		var obj=document.getElementById("displocrowid") ;
		if (obj) obj.value=ss[1] ; // rowid of the disp loc
	}
}

function PrintResult()
{
	var hospname=""
	var prnpath=""
	var cnt;
	var DispLoc;
	var printername=t
	
	var obj=document.getElementById("mPrtHospName") ;
	var exe=""
	if (obj) exe=obj.value;
	hospname=cspRunServerMethod(exe,'','')
	
	var obj=document.getElementById("mGetPrnPath") ;
	var exe=""
	if (obj) exe=obj.value;
	prnpath=cspRunServerMethod(exe,'','')

	var Template=prnpath+"STP_WardDispStat_SG.xls";
	var xlApp = new ActiveXObject("Excel.Application");
	var xlBook = xlApp.Workbooks.Add(Template);
	var xlsheet = xlBook.ActiveSheet ;	
    var startNo=3 ;   

	var obj=document.getElementById("t"+"dhcpha_dispquerywardret")
	if (obj) cnt=getRowcount(obj)
	var obj=document.getElementById("DispLoc")
	if (obj) DispLoc=obj.value;

	var obj=document.getElementById("StartDate")
	if (obj) dispsd=obj.value;
	var obj=document.getElementById("EndDate")
	if (obj) disped=obj.value;
		
	xlsheet.Cells(1, 1).Value = hospname+getDesc(DispLoc)+t['PRT_REPORT_NAME'];  //hospital description
	xlsheet.Cells(2, 3).Value = dispsd+"---"+disped

	//
    var i;
    for (i=1;i<=cnt;i++)
    {
		var obj=document.getElementById("PhaDispSum"+"z"+i)
		if (obj) var spamt=obj.innerText;
		var obj=document.getElementById("Ward"+"z"+i)
		if (obj) var wardname=obj.innerText;
		var rpamt=spamt/1.15
		var diffamt=spamt-rpamt
		//		
		xlsheet.Cells(startNo+i, 1).Value =i ;		// No.
		xlsheet.Cells(startNo+i, 2).Value =getDesc(wardname) ;//wardname
		xlsheet.Cells(startNo+i, 3).Value =spamt ; //spamt
		xlsheet.Cells(startNo+i, 4).Value =rpamt ; //rpamt
		xlsheet.Cells(startNo+i, 5).Value =diffamt //diffamt
		
		gridlist(xlsheet,startNo+i,startNo+i,1,5)
		
    }
     
    //xlsheet.Cells(row,1).value= ;
    xlsheet.Cells(startNo+i+2,2).value=t['PRT_MAKER']+session['LOGON.USERNAME'];
    xlsheet.Cells(startNo+i+2,3).value=t['PRT_PHAMASTER']
     xlsheet.Cells(startNo+i+2,5).value=t['PRT_PHASTAT']
   
	xlsheet.printout();
	SetNothing(xlApp,xlBook,xlsheet)
	
}
function GetDefLoc()
{	
	objBodyLoaded=document.getElementById("BodyLoaded") ;
	if (objBodyLoaded) BodyLoaded=objBodyLoaded.value;
	
	//alert(BodyLoaded);
	if (BodyLoaded!=1)
	{
		var userid=session['LOGON.USERID'] ;
		var obj=document.getElementById("mGetDefaultLoc") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		var ss=cspRunServerMethod(encmeth,'setDefLoc','',userid) ;
	   
	    var t=today();
		var obj=document.getElementById("StartDate") ;
		if (obj) obj.value=t;
		var obj=document.getElementById("EndDate") ;
		if (obj) obj.value=t;

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
	if (obj) obj.value=row
	var obj=document.getElementById("WardRowidz"+row);
	if (obj) var WardRowid=obj.value;
	//alert(WardRowid);
	var obj=document.getElementById("ProcessIDz"+row);
	if (obj) var ProcessID=obj.value;
	//alert(ProcessID);
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquerywardretitm&ProcessID="+ProcessID+"&WardRowid="+WardRowid
	//alert(lnk);
	parent.frames['dhcpha.dispquerywardretitm'].location.href=lnk;
}

function gridlist(objSheet,row1,row2,c1,c2)
 {
	   objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	   objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	   objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	   objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1;
 
 }
function SetNothing(app,book,sheet)
{
	app=null;
	book.Close(savechanges=false);
	sheet=null;
	}
	
function RetReasonLookUpSelect(str)
{
	var ss=str.split("^")
	if ( ss.length>0) 
	{
		var obj=document.getElementById("reasondr") ;
		if (obj) obj.value=ss[1] ; 
	}
}
function reasonCheck()
{
	var obj=document.getElementById("RetReason");
	var obj2=document.getElementById("reasondr");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}

}
document.body.onload=BodyLoadHandler;