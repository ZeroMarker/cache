var idTmr=""
var CurrRow;
var phaflag;
function BodyLoadHandler()
{
	
	var obj ;
	obj=document.getElementById("Clear") ;
	if (obj) obj.onclick=ClearClick;
	
	obj=document.getElementById("Find") ;
	if (obj) obj.onclick=FindClick; 
	
	obj=document.getElementById("Print") ;
	if (obj) obj.onclick=PrintClick; 

	var obj=document.getElementById("ShowDetail");
	if (obj) obj.onclick=SetDetailFrame;
	
	var obj=document.getElementById("ShowTotal");
	if(obj) obj.onclick=ShowTotal;
	///if (obj) obj.onclick=SetTotalFrame;

	
	obj=document.getElementById("BodyLoaded");
	if (obj.value!=1)
	{
		setDefaultDate();
		//setDefaultValByLoc();
	}
	
	var obj=document.getElementById("Ward"); 
	if (obj) 
	{
		obj.onkeydown=popWard;
	 	obj.onblur=wardCheck;
	}
	var obj=document.getElementById("DoctorLoc")
	if (obj) {
	  obj.onkeydown=popDoctorLoc;
	  obj.onblur=DoctorLocCheck; 
	}
	
	/*var obj=document.getElementById("phaflag") ;
	if (obj)
	{
		
		if (obj.value==1)
		{
			var obj=document.getElementById("OutFlag") ;
			if (obj){
				obj.checked=true;
			}
			
		}
		else
		{
			var obj=document.getElementById("InFlag") ;
			if (obj){
				obj.checked=true;
			}
		}
	}*/
	
	
    setBodyLoaded();
    //InitWindow();
	
}


function   SetDetailFrame()   
{   
   
    parent.document.getElementById('x').cols='40,60,0';

}
  
function   SetTotalFrame()   
{   
    loadmain();
    parent.document.getElementById('x').cols='40,0,60';	   

}

function setDefaultDate()
{
	var t=today();
	var obj=document.getElementById("StartDate") ;
	if (obj) obj.value=t;
	var obj=document.getElementById("EndDate") ;
	if (obj) obj.value=t;
	
}



function getPhaLocation(loc)
{ 
 var exe
 var obj=document.getElementById("mGetPhaLocSet")
 if (obj) exe=obj.value;
 else exe='';
 var sss=cspRunServerMethod(exe,loc);
 return sss;
}

function setDefaultValByLoc()
{
 var loc
 var obj=document.getElementById("displocrowid")
 if ((obj)&&(obj.value!=""))
 {
	loc=obj.value ;
	var sets=getPhaLocation(loc)
	if (sets!="")
	{
     var ss=sets.split("^")
     var sd ;
     var ed;
     
     sd=ss[2];
     ed=ss[3] ;

     var startdate=CalcuDate(sd)
     var enddate=CalcuDate(ed)
     var obj=document.getElementById("StartDate");
     if (obj) obj.value=startdate;
     var obj=document.getElementById("EndDate");
     if (obj) obj.value=enddate;
   }
   
 }
 
 
}


function CalcuDate(ss)
{
	var obj=document.getElementById("mGetDate");
 if (obj) {var encmeth=obj.value;} else {var encmeth='';}
 var date=cspRunServerMethod(encmeth,'','',ss) ;
 return date     
}


function popWard()     
{ 
	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  Ward_lookuphandler();
		}
	}
	
function wardCheck()
{
	var obj=document.getElementById("Ward");
	var obj2=document.getElementById("wardrowid");
	if (obj) 
	{if (obj.value=="") obj2.value=""		}

}


function KillDISPMQ()
{
	 
		var obj=document.getElementById("KillDISPMQ") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		var objpid=document.getElementById("Tpidz"+1) ;
		if (objpid){pid=objpid.value;
		prthz=cspRunServerMethod(encmeth,pid) ;}
		
}


function SelectRowHandler() {

	var row=selectedRow(window);
	var obj=document.getElementById("currentRow") ;
	if (obj) obj.value=row;
	CurrRow=row;
	RowChange();
	
}


function RowChange()
{

  //retrieve the detail dispensing 
  var row= DHCWeb_GetRowIdx(window) ;
  if (row<1) return ;
  
  var coll=0
  var obj=document.getElementById("Tsupp"+"z"+row) ;
  if (obj) {var coll=obj.value ;
           }
  if (coll>0)
  {
  	RetrieveDetailByCollid(coll); 
         }

	}
	
function RetrieveDetailByCollid(coll)
{ 


	var pidobj=document.getElementById("Tpid"+"z"+1)
	var pid=pidobj.value;

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.supplyquerytotal&supp="+coll+"&pid="+pid ;
	parent.frames['dhcpha.supplyquerytotal'].location.href=lnk;

	
}


function ClearClick()
{
	var obj; 
	obj=document.getElementById("Ward") ;
	if (obj) obj.value="" ;
	obj=document.getElementById("wardrowid") ;
	if (obj) obj.value="" ;
    ClearMain();
    ClearSub();

	
}

function ClearMain()
{
		parent.frames['dhcpha.supplyquery'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.supplyquery"
}

function ClearSub()
{
		parent.frames['dhcpha.supplyquerytotal'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.supplyquerytotal"
	    parent.frames['dhcpha.supplyqueryitm'].location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.supplyqueryitm"
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
	
	var outflag=0
	var objOutFlag=document.getElementById("OutFlag")	
	if (objOutFlag) {
		if (objOutFlag.checked){
			outflag=1
		}
	}
	
	var inflag=0
	var objInFlag=document.getElementById("InFlag")	
	if (objInFlag) {
		if (objInFlag.checked){
			inflag=1
		}
	}
	outflag=1  //yunhaibao20160202,仅门诊收据
	var objPamStr=document.getElementById("PamStr")
	if (objPamStr) {
		objPamStr.value=outflag+"^"+inflag
	}
	
	
	if ((outflag==0)&&(inflag==0)){
		
			return  false;	
	}
	
	return true;	

}

function FindClick()
{
	if (CheckQueryCondition()==false) return ;
	ClearSub();
	Find_click();
}



function setBodyLoaded()
{
	var obj=document.getElementById("BodyLoaded") ;
	if (obj) obj.value=1;
}

function loadmain()
{
	
	var objtbl=document.getElementById("t"+"dhcpha_supplyquery");
	if (objtbl)	rowcnt=getRowcount(objtbl)
	if (rowcnt<1){ return;}
	var pid="";
	var pidobj=document.getElementById("Tpid"+"z"+1)
	if (pidobj) pid=pidobj.value;
	alert(pid)
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.supplyquerytotal&pid="+pid ;
	parent.frames['dhcpha.supplyquerytotal'].location.href=lnk;
	
}

function ShowTotal()
{
	//yunhaibao20121019,给汇总选中按钮添加汇总事件
	var objtbl=document.getElementById("t"+"dhcpha_supplyquery");
	if (objtbl)	rowcnt=getRowcount(objtbl)
	if (rowcnt<1){ return;}
	var pid="";
	var coll="";
	var str=""	
	var pidobj=document.getElementById("Tpid"+"z"+1)
	for(var row=1;row<=rowcnt;row++){	
	var ckbobj=document.getElementById("TSelect"+"z"+row);
	var obj=document.getElementById("Tsupp"+"z"+row) ;
	coll=obj.value;	
	if(ckbobj.checked==true)
	{    
	    if(str!="")
	    {
			str=str+"^"+coll;
		}
		else
		{
			str=coll;
		}
	}	
	}
	if (pidobj) pid=pidobj.value;
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.supplyquerytotal&pid="+pid+"&supp="+str;
	parent.frames['dhcpha.supplyquerytotal'].location.href=lnk;
	
	}



function DispLocLookUpSelect(str)
{
	var ss=str.split("^") ;
	if ( ss.length>0) 
	{ 
	var obj=document.getElementById("displocrowid") ;
	if (obj) obj.value=ss[1] ;  
	}
}

function WardLookUpSelect(str)
{
	var ss=str.split("^") ;
	if ( ss.length>0) 
	{ 
		var obj=document.getElementById("wardrowid") ;
		if (obj) obj.value=ss[1] ;  
	}
}


function DoctorLocLookUpSelect(str)
{
	var ss=str.split("^") ;
	if ( ss.length>0) 
	{ 
		var obj=document.getElementById("DoctorLocRowid") ;
		if (obj) obj.value=ss[1] ;  
	}
}

function InitWindow()
{
	window.document.all("Print").style.display="none"
	var obj=document.getElementById("Disped") ;
	if (obj){
		if (obj.checked){
			window.document.all("Print").style.display="inline"	
		}
	}
	
		
}

function SetNothing(app,book,sheet)
{
        app=null;
        book.Close(savechanges=false);
        sheet=null;
        Cleanup();
}

function PrintClick()
{
	var objtbl=document.getElementById("t"+"dhcpha_supplyquery");
    if (objtbl)	rowcnt=getRowcount(objtbl)
    if (rowcnt<1){ return;}
    if (!(CurrRow)){
	    alert("请先选择单号!")
	    return;
    }
    var pid="";
    var pidobj=document.getElementById("Tpid"+"z"+CurrRow)
    if (pidobj) pid=pidobj.value;
	    
		
	PrintReport(pid)
	
}

///打印区
function PrintReport(pid)
{
	
	    var gPrnpath;
		var obj=document.getElementById("mGetPrnPath") ;
		if (obj) {var encmeth=obj.value;} else {var encmeth='';}
		gPrnpath=cspRunServerMethod(encmeth,'','') ;
	
		var xx=document.getElementById("mGetDataToPrt");
		if (xx) {var encmeth=xx.value;} else {var encmeth='';}
		var cnt=cspRunServerMethod(encmeth,pid) ;
		if (!(cnt>0)) return;
		
		var Template=gPrnpath+"STP_DSY_BJXH.xls";
    	var xlApp = new ActiveXObject("Excel.Application");
    	var xlBook = xlApp.Workbooks.Add(Template);
    	var xlsheet = xlBook.ActiveSheet ;
    	
    	if (xlsheet==null)
		{ 
		   alert("模板"+Template+"不存在")
		   return;
		}
		
        var cols=3
		for (i=1;i<=cnt;i++)
		{
			var xx=document.getElementById("mListDataToPrt");
			if (xx) {var encmeth=xx.value;} else {var encmeth='';}
			var data=cspRunServerMethod(encmeth,pid,i) ;
			
			var tmpstr=data.split("^")
		    var phadate=tmpstr[0]
		    var phaloc=document.getElementById("DispLoc").value;
		    var warddesc="";
		    var incidesc=tmpstr[1]
		    var qty=tmpstr[2]
		    var spec=tmpstr[3]
			    
			var Startrow=3 
			if (i==1) {
				setBottomLine(xlsheet,Startrow,1,cols);
				xlsheet.Cells(Startrow-1, 1).Value = "发药科室:"+phaloc + " 日期:"+getPrintDateTime()+ " 发药人:"+session['LOGON.USERNAME'];
			}
			xlsheet.Cells(Startrow+i, 1).Value = incidesc
			xlsheet.Cells(Startrow+i, 2).Value = spec
			xlsheet.Cells(Startrow+i, 3).Value = qty
            
            setBottomLine(xlsheet,Startrow+i,1,cols);
	      
		}
		
		
					
		xlsheet.printout();
        SetNothing(xlApp,xlBook,xlsheet)
	
 
}
function popDoctorLoc()
{ 
	if (window.event.keyCode==13) 
	{ 
	   window.event.isLookup=true
	   window.event.keyCode=117;
	   DoctorLoc_lookuphandler(window.event);
	}
}
function DoctorLocCheck()
{	
	var obj=document.getElementById("DoctorLoc");
	var obj2=document.getElementById("DoctorLocRowid");
	if (obj){
		if (obj.value==""){ 
			obj2.value="";
		}
	}
}

function Cleanup() 
{   
    window.clearInterval(idTmr);   
    CollectGarbage();   
}



document.body.onbeforeunload=function(){

   KillDISPMQ();
  }
  

 
document.body.onload=BodyLoadHandler;