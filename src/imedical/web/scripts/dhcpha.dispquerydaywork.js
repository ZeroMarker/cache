var gPrnpath;

function BodyLoadHandler()
{	var obj ;
	obj=document.getElementById("Clear") ;
	if (obj) obj.onclick=ClearClick; 
	obj=document.getElementById("Find") ;
	if (obj) obj.onclick=FindClick; 
	obj=document.getElementById("Close") ;
	if (obj) obj.onclick=CloseClick; 
	obj=document.getElementById("Print") ;
	if (obj) obj.onclick=PirntClick; 

	PopulateDispCat();
	obj=document.getElementById("BodyLoaded");
	if (obj.value!=1)
	{
		//GetDefLoc();
		setDefaultDate();
	}
	
	
	var obj=document.getElementById("StatType");
	if (obj){
		obj.size=1; 
	 	obj.multiple=false;
	 	obj.options[0]=new Option('按人员统计',"1");
	 	obj.options[1]=new Option('按病区统计',"2");
	}
	
    GetPrintpath();
	
	setBodyLoaded();
}
function setBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded") ;
	if (obj) obj.value=1;
}
function setDefaultDate()

{	
    //lq 2007-10-13
    var t=today();
	var obj=document.getElementById("StartDate") ;
	//if (obj) obj.value=DateDemo();
	if (obj) obj.value=t ;
	var obj=document.getElementById("EndDate") ;
	//if (obj) obj.value=DateDemo();
	if (obj) obj.value=t ;
} 





function DateDemo(){
   var d, s="";           
   d = new Date();                           
   s += d.getDate() + "/";                   
   s += (d.getMonth() + 1) + "/";            
   s += d.getYear();          //取当时日期
   return(s);                 //lq 2007-10-13
}



function PopulateDispCat()
{ var obj=document.getElementById("DispCat") ;
 	if (obj)
 	{ 	var obj2=document.getElementById("dispcatvalue")
		if (obj2) 
		{ var cats=obj2.value ; }
		else {return ;}
		var data=cats.split("^") ;
		var i ;
		for (i=0;i<=data.length;i++)
		{obj.options[i]=new Option (data[i]) ; 	}
	}   
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


function CloseClick()
{  	window.close();}
function ClearClick()
{}
function FindClick()
{
	if (CheckFindCondition()==false) return  ;
	//// execute query 
	//var obj=document.getElementById("StartDate") ;
	//if (obj) var sd=obj.value;
	//var obj=document.getElementById("EndDate") ;
	//if (obj) var ed=obj.value;
	//var obj=document.getElementById("displocrowid") ;
	//if (obj) var displocrowid=obj.value;
	
	//var link="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.dispquerydaywork&StartDate="+sd+"&EndDate="+ed+"&displocrowid="+displocrowid
	//location.href=link ;
	Find_click();
}
function DispLocLookUpSelect(str)
{
	var ss=str.split("^")
  if ( ss.length>0) 
  { 
   var obj=document.getElementById("displocrowid") ;
   if (obj) obj.value=ss[1] ; // rowid of the disp loc
   }
}
function GetPrintpath()
{
	var obj=document.getElementById("mGetPrnPath") ;
	if (obj) {var encmeth=obj.value;} else {var encmeth='';}
	gPrnpath=cspRunServerMethod(encmeth,'','') ;
}

function PirntClick()
{PrintWorkStat() ;}

function PrintWorkStat()
{
	// Print the result ..
	// 

  	objtbl=document.getElementById("t"+"dhcpha_dispquerydaywork");
  	var cnt=objtbl.rows.length-1;
    if (cnt==0){return;}
    
	var Template=gPrnpath+"STP_PrintDispDayWork.xls";
    var xlApp = new ActiveXObject("Excel.Application");
    var xlBook = xlApp.Workbooks.Add(Template);
    var xlsheet = xlBook.ActiveSheet ;
    var Startrow=4 
    for (i=1;i<=cnt-1;i++)
    {   
        var username=""
	    var objUserName= document.getElementById("UserName"+"z"+i)
	    if (objUserName) var username=objUserName.innerText;
	    var quenum=0
	    var objQuenum= document.getElementById("Quenum"+"z"+i)
	    if (objQuenum) var quenum=objQuenum.innerText;
	    var quefacnum=0
	    var objQuefacnum= document.getElementById("Quefacnum"+"z"+i)
	    if (objQuefacnum) var quefacnum=objQuefacnum.innerText;
	    var dispamt=0
	    var objDispAmt= document.getElementById("DispAmt"+"z"+i)
	    if (objDispAmt)var dispamt=objDispAmt.innerText;
	    var facsum=0
	    var objFacSum= document.getElementById("FacSum"+"z"+i)
	    if (objFacSum) var facsum=objFacSum.innerText;
	    var retque=0
	    var objRetQue= document.getElementById("RetQue"+"z"+i)
	    if (objRetQue) var retque=objRetQue.innerText;
	    var retfac=0
	    var objRetFac= document.getElementById("RetFac"+"z"+i)
	    if (objRetFac) var retfac=objRetFac.innerText;
	    var retamt=0
	    var objRetAmt= document.getElementById("RetAmt"+"z"+i)
	    if (objRetAmt) var retamt=objRetAmt.innerText;
	    var outque=0
	    var objOutQue= document.getElementById("OutQue"+"z"+i)
	    if (outque) var outque=objOutQue.innerText;
	    var outfac=0
	    var objOutFac= document.getElementById("OutFac"+"z"+i)
	    if (objOutFac) var outfac=objOutFac.innerText;
	    var outqueamt=0
	    var objOutQueAmt= document.getElementById("OutQueAmt"+"z"+i)
	    if (outqueamt) var outqueamt=objOutQueAmt.innerText;
	    //
	    xlsheet.Cells(2, 10).Value = getPrintDateTime();
		xlsheet.Cells(Startrow, 1).Value = username
		xlsheet.Cells(Startrow, 2).Value = quenum
		xlsheet.Cells(Startrow, 3).Value = quefacnum
		xlsheet.Cells(Startrow, 4).Value = dispamt
		xlsheet.Cells(Startrow, 5).Value = facsum
		xlsheet.Cells(Startrow, 6).Value = retque
		xlsheet.Cells(Startrow, 7).Value = retfac
		xlsheet.Cells(Startrow, 8).Value = retamt
		xlsheet.Cells(Startrow, 9).Value = outque
		xlsheet.Cells(Startrow, 10).Value = outfac
		xlsheet.Cells(Startrow, 11).Value = outqueamt
		setBottomLine(xlsheet,Startrow,1,11);
        cellEdgeRightLine(xlsheet,Startrow,1,11)
		Startrow=Startrow+1
    }
 
	xlsheet.printout();
    SetNothing(xlApp,xlBook,xlsheet)
    
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

function SetNothing(app,book,sheet)
{
        app=null;
        book.Close(savechanges=false);
        sheet=null;
}

document.body.onload=BodyLoadHandler;