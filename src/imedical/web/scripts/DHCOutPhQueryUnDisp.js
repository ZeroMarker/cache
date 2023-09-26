//DHCOutPhQueryUnDisp
var bottomFrame;
var topFrame;
var tblobj=document.getElementById("tDHCOutPhQueryUnDisp");
var f=document.getElementById("fDHCOutPhQueryUnDisp");
var evtName;
var doneInit=0;
var focusat=null;
var SelectedRow = 0;
var pmiobj,pnameobj;
var stdateobj,enddateobj;
var phlobj,phwobj,locdescobj,phwdescobj,pydrobj,fydrobj,pynameobj,fynameobj;
var ctlocobj;
var BResetobj,BDispobj,BPrintobj,BReprintobj;
var printobj,dispobj,reprintobj;
var returnphobj,returnphitmobj;
  if(parent.name=='TRAK_main') {
		topFrame=parent.frames['work_top'];
		bottomFrame=parent.frames['work_bottom'];
	} else {
		topFrame=parent.frames['TRAK_main'].frames['work_top'];
		bottomFrame=parent.frames['TRAK_main'].frames['work_bottom'];
	}
	
var subtblobj=bottomFrame.document.getElementById('tDHCOutPhQueryUnDispSub');
var fy=document.getElementById("CFyFlag");
var ret=document.getElementById("CRetFlag");
 // fy.checked=true;
var flag=document.getElementById("flag");
 if(flag.value=="2"){ret.checked=true;}
 else
 {fy.checked=true;flag.value="1";ret.checked=false }
 


function BodyLoadHandler() {
  BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click;
  var printobj=document.getElementById("BPrint");
  if (printobj) printobj.onclick=print_click;
  BRetrieveobj=document.getElementById("BRetrieve");
   if (BRetrieveobj){
	   BRetrieveobj.onclick=Retrieve_click;
	   if (tbl.rows.length>1){RowClick();}
	   else
	   { var phd=""
 	     var cflag=""
	     var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryUnDispSub&Rowid="+phd+"&flag="+cflag;
       	    bottomFrame.location.href=lnk;
	   }
	  }
  ctlocobj=document.getElementById("ctloc");
    var obj=document.getElementById("CFyFlag");
	if (obj) obj.onclick=GetChFy;
	var obj=document.getElementById("CRetFlag");
	if (obj) obj.onclick=GetChRet; 
	
	
}

function GetChFy()
{
   var fy=document.getElementById("CFyFlag");
   var ret=document.getElementById("CRetFlag");
   var flag=document.getElementById("flag");
  // if ((fy.checked==true)&(ret.checked==true)){fy.checked=false;}
  // if (fy.checked==true){flag.value="1";};
   if (fy.checked==true)
   {
	   fy.checked=true;
	   ret.checked=false;
	   flag.value="1";
   }
   else
   {
	   flag.value="2";
	   ret.checked=true;
	   fy.checked=false;
   }
}
function GetChRet()
{
   var fy=document.getElementById("CFyFlag");
   var ret=document.getElementById("CRetFlag");
   var flag=document.getElementById("flag");
   //if ((ret.checked==true)&(fy.checked==true)){ret.checked=false;}
   //if (ret.checked==true){ flag.value="2";};
    if (ret.checked==true)
   {
	   ret.checked=true;
	   fy.checked=false;
	   flag.value="2";
	   
   }
   else
   {
	   flag.value="1";
	   fy.checked=true;
	   ret.checked=false;
   }
	 
}

function SelectRowHandler()	{
	
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	SelectedRow = selectrow;
	var phd=document.getElementById("tphdz"+selectrow).value
	var flag=document.getElementById("flag").value
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryUnDispSub&Rowid="+phd+"&flag="+flag;
 	bottomFrame.location.href=lnk;



}
function GReasID(value)
{ if (value=="") {return;}
  var sstr=value.split("^")
  var reasid=document.getElementById("CReasID")
     reasid.value=sstr[1]
  
	
}
function RowClick()
{
  var phd=document.getElementById("tphdz"+1).value
  var flag=document.getElementById("flag").value
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryUnDispSub&Rowid="+phd+"&flag="+flag;
 	bottomFrame.location.href=lnk;

}
function print_click(){
	 var rownum,Rrow,prt,name,pmino,printflag,inv
    if(SelectedRow==0)
    {alert("请选择一行进行打印！");return;}
	var phd=document.getElementById("tphdz"+SelectedRow).value
	var flag=document.getElementById("flag").value
	
    var name=document.getElementById("TPerNamez"+SelectedRow).innerText
	var pmino=document.getElementById("TPmiNoz"+SelectedRow).innerText
	
    var reas=document.getElementById("TReasDescz"+SelectedRow).innerText
    var username=document.getElementById("TPyNamez"+SelectedRow).innerText
    var title=""
    if(flag=="1")
    {title="领药单"}
    else
    {title="退药单"}
  
	 var rows,pagerow;
	 var getmethod=document.getElementById('GetPrintRow');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     var PrintRows=cspRunServerMethod(encmeth,phd,flag)
      if (PrintRows==0){alert("没有数据,不能打印!");return ;} 
	 var pagerow=30;
	  
     var Ls_orderitemtmp,RowN,i
     var getmethod=document.getElementById('gpath');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
     var path=cspRunServerMethod(encmeth)
     var xlApp,obook,osheet,xlsheet,xlBook
	    var paymoney
        var Template
        Template=path+"YFUnDisp.xls"
        xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet
	    xlsheet.cells(1,1)=title
	    xlsheet.cells(2,6).value=name
	    xlsheet.cells(2,2).NumberFormatLocal = "@"
	    xlsheet.cells(2,2).value=pmino
	    xlsheet.cells(3,2).value=reas
	    xlsheet.cells(3,7).value=username

	    
      var pagenum
 if (Math.floor(PrintRows/pagerow)==(PrintRows/pagerow)){pagenum=Math.floor(PrintRows/pagerow);}
	else {pagenum=Math.floor(PrintRows/pagerow)+1;}  
 var k,j,l,RowNum,count;
 var  lastnum = PrintRows-(pagenum-1)*pagerow 
    for (k=1;k<=pagenum;k++){
      if (k==pagenum){RowNum=lastnum;} else {RowNum=pagerow;}
      for (l=5;l<=pagerow+4;l++){for(j=1;j<=8;j++){xlsheet.Cells(l, j).value=""}}
      for(i=1;i<=RowNum;i++){
	      var getmethod=document.getElementById('GetRowPrint');
           if (getmethod) {var encmeth=getmethod.value} else {var encmeth='';}
          var PrintSet=cspRunServerMethod(encmeth,phd,flag,i+(k-1)*pagerow)
          var sstr=PrintSet.split("^")
         
 		  xlsheet.cells(4+i,1).value=sstr[0];
		  xlsheet.cells(4+i,5).value=sstr[1];
	 	  xlsheet.cells(4+i,6).value=sstr[2];
	 	  xlsheet.cells(4+i,7).value=sstr[3];
		  xlsheet.cells(4+i,8).value=sstr[4];
	 }
    xlsheet.printout
  }
	xlBook.Close(savechanges=false);
	xlApp=null;
	xlsheet=null

	
   }	   



function Reset_click()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryUnDisp";
 	var prt=""
 	var phd=""
 	var flag=""
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryUnDispSub&Rowid="+phd+"&flag="+flag;
 	bottomFrame.location.href=lnk;
	 }
 
function Retrieve_click()
{
 var stdateobj=document.getElementById("CDateSt")
 var enddateobj=document.getElementById("CDateEnd")
 var  ctlocobj=document.getElementById("ctloc")
 var  reasid=document.getElementById("CReasID").value
 var flag=document.getElementById("flag").value;
 var fy= document.getElementById("CFyFlag")
  if(fy.checked==true){flag="1";}
  var ctloc=ctlocobj.value;
  
  var stdate=stdateobj.value
  var enddate=enddateobj.value
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhQueryUnDisp&CDateSt="+stdate+"&CDateEnd="+enddate+"&ctloc="+ctloc+"&flag="+flag+"&CReasID="+reasid;
  topFrame.location.href=lnk;

}



document.body.onload = BodyLoadHandler;
