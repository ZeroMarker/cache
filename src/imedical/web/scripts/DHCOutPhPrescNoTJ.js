//DHCOutPhPrescNoTJ
//药房处方统计
var tblobj=document.getElementById("tDHCOutPhPrescNoTJ");
var evtName;
var doneInit=0;
var focusat=null;
var SelectedRow = 0;
var pmiobj,pnameobj;
var stdateobj,enddateobj;
var phlobj,phwobj,locdescobj,phwdescobj,pydrobj,fydrobj,pynameobj,fynameobj;
var ctlocobj,useridobj;
var BResetobj,BPrintobj;
var printobj;
function BodyLoadHandler() {
  BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click;
  var BPrintobj=document.getElementById("BPrint");
  if (BPrintobj) BPrintobj.onclick=Print_click;
  ctlocobj=document.getElementById("ctloc");
  var obj=document.getElementById("CIncCatDesc")
  if (obj) {
	  obj.onkeydown=popCIncCatDesc; 
	  obj.onblur=CIncCatDescCheck; 
  }
  var obj=document.getElementById("CPhCatDesc")
  if (obj) {
	  obj.onkeydown=popCPhCatDesc;
  	  obj.onblur=CPhCatDescCheck; 
  }
  var BRetrieveobj=document.getElementById("BRetrieve");
  if (BRetrieveobj) BRetrieveobj.onclick=BRetrieve_click;
}

function SelectRowHandler()	{
	
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	SelectedRow = selectrow;

}


function Reset_click()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhPrescNoTJ";
 }

function GetTypeID(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("CPrescTypeID")
    fydrobj.value=sstr[1]
}
function GCatID(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("CIncCatID")
     fydrobj.value=sstr[1]
    
     
}
function GPhCatID(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("CPhCatID")
     fydrobj.value=sstr[1]
    

}
function popCPhCatDesc()
{ 
	if (window.event.keyCode==13) 
	{ 
	   window.event.isLookup=true
	   window.event.keyCode=117;
	   CPhCatDesc_lookuphandler(window.event);
	}
}
function CPhCatDescCheck()
{	
	var obj=document.getElementById("CPhCatDesc");
	var obj2=document.getElementById("CPhCatID");
	if (obj){
		if (obj.value==""){ 
			obj2.value="";
		}
	}
}
function CIncCatDescCheck()
{	
	var obj=document.getElementById("CIncCatDesc");
	var obj2=document.getElementById("CIncCatID");
	if (obj){
		if (obj.value==""){ 
			obj2.value="";
		}
	}
}
function popCIncCatDesc()
{ 
	if (window.event.keyCode==13) 
	{ 
	   window.event.isLookup=true
	   window.event.keyCode=117;
	   CIncCatDesc_lookuphandler(window.event);
	}
}
 function Print_click(){
	 tblobj=document.getElementById("tDHCOutPhPrescNoTJ");
	 if (tblobj.rows.length==0) {alert(t['01']);return 0;}
	 var rows,pagerow;
	 rows=tblobj.rows.length-1
	 var path
	   pagerow=35;
     var Ls_orderitemtmp,RowN,i
      var getmethod=document.getElementById('gpath');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      path=cspRunServerMethod(encmeth)
     var datest=document.getElementById('CDateSt');
	 var dateend=document.getElementById('CDateEnd');
	  var getmethod=document.getElementById('ghosname');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     var hosname=cspRunServerMethod(encmeth)

	  var xlApp,obook,osheet,xlsheet,xlBook
	    var paymoney
        var Template
        Template=path+"yfcftj.xls"
        xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet
	    xlsheet.cells(1,1).value=hosname+"处方统计"
        xlsheet.cells(2,1).value="日期范围:"+datest.value+"--"+dateend.value
    
       for(i=1;i<=rows;i++){
		  xlsheet.cells(3+i,1).value=document.getElementById("TPrescTypez"+i).innerText
		  xlsheet.cells(3+i,2).value=document.getElementById("TPrescNumz"+i).innerText
	 	  xlsheet.cells(3+i,3).value=document.getElementById("TPrescTotalz"+i).innerText
	 	  xlsheet.cells(3+i,4).value=document.getElementById("TPrescBLz"+i).innerText
	 	  xlsheet.cells(3+i,5).value=document.getElementById("TPrescMaxPmiz"+i).innerText
	 	  xlsheet.cells(3+i,6).value=document.getElementById("TPrescMinPmiz"+i).innerText
	 	  xlsheet.cells(3+i,7).value=document.getElementById("TPrescMaxMoneyz"+i).innerText
	 	  xlsheet.cells(3+i,8).value=document.getElementById("TPrescMinMoneyz"+i).innerText 
	 	  xlsheet.cells(3+i,9).value=document.getElementById("TPrescMoneyz"+i).innerText
	 	  xlsheet.cells(3+i,10).value=document.getElementById("TPrescPhNumz"+i).innerText
	 	  xlsheet.cells(3+i,11).value=document.getElementById("TCYFSz"+i).innerText
	 	  xlsheet.cells(3+i,12).value=document.getElementById("TJYFSz"+i).innerText
	 	  xlsheet.cells(3+i,13).value=document.getElementById("TJYCFz"+i).innerText

	 	  xlsheet.Range(xlsheet.Cells(3,1), xlsheet.Cells((3+i),13)).Borders(1).LineStyle=1;
	      xlsheet.Range(xlsheet.Cells(3,1), xlsheet.Cells((3+i),13)).Borders(2).LineStyle=1;
	      xlsheet.Range(xlsheet.Cells(3,1), xlsheet.Cells((3+i),13)).Borders(3).LineStyle=1;
          xlsheet.Range(xlsheet.Cells(3,1), xlsheet.Cells((3+i),13)).Borders(4).LineStyle=1;
	 }
    xlsheet.printout
	xlBook.Close(savechanges=false);
	xlApp=null;
	xlsheet=null

   }	   
function BRetrieve_click()
{
   var startdate="",enddate="",PrescType="",PrescTypeId="",PrescPhNum=""
   var IncCatDesc="",IncCatId="",PhCatDesc="",PhCatId="",OutPresc="",EmPresc=""
   var obj=document.getElementById("CDateSt");
   if (obj) startdate=obj.value;
   var obj=document.getElementById("CDateEnd");
   if (obj) enddate=obj.value;  
   var obj=document.getElementById("CPrescType");
   if (obj) PrescType=obj.value;   
   var obj=document.getElementById("CPrescTypeID");
   if (obj) PrescTypeId=obj.value;
   var obj=document.getElementById("CPrescPhNum");
   if (obj) PrescPhNum=obj.value;
   var obj=document.getElementById("CIncCatDesc");
   if (obj) IncCatDesc=obj.value;
   var obj=document.getElementById("CIncCatID");
   if (obj) IncCatId=obj.value;    
   var obj=document.getElementById("CPhCatDesc");
   if (obj) PhCatDesc=obj.value; 
   var obj=document.getElementById("CPhCatID");
   if (obj) PhCatId=obj.value;     
   var obj=document.getElementById("COutPresc");
   if (obj) {
	   if (obj.checked){OutPresc="Y"}
	   else{OutPresc=""}
   }
   var obj=document.getElementById("CEmPresc");
   if (obj){
	   if (obj.checked){EmPresc="Y"}
	   else{EmPresc=""}
   } 
   if ((EmPresc=="")&&(OutPresc=="")  ) 
   {
		alert("请勾选需要统计的门急诊处方!")
		return
	}
   var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhPrescNoTJ"+"&CDateSt="+startdate+"&CDateEnd="+enddate+"&CPrescType="+PrescType+"&CPrescTypeID="+PrescTypeId
      +"&CPrescPhNum="+PrescPhNum+"&CIncCatDesc="+IncCatDesc+"&CIncCatID="+IncCatId+"&CPhCatDesc="+PhCatDesc
      +"&CPhCatID="+PhCatId+"&COutPresc="+OutPresc+"&CEmPresc="+EmPresc+"&ctloc="+session['LOGON.CTLOCID']
   window.location.href=lnk;  
}

document.body.onload = BodyLoadHandler;
