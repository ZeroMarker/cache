//DHCOutPhRetDJCX
var bottomFrame;
var topFrame;
var tblobj=document.getElementById("tDHCOutPhRetDJCX");
var evtName;
var doneInit=0;
var focusat=null;
var SelectedRow = 0;
var pmiobj,pnameobj;
var stdateobj,enddateobj;
var phlobj,phwobj,locdescobj,phwdescobj,pydrobj,fydrobj,pynameobj,fynameobj;
var ctlocobj;
var BResetobj,BPrintobj;
var printobj,dispobj,reprintobj;
var returnphobj,returnphitmobj;
		if(parent.name=='TRAK_main') {
		topFrame=parent.frames['DHCOutPatienRetDJCX'];
		bottomFrame=parent.frames['DHCOutPatienRetDJCXSub'];
	} else {
		topFrame=parent.frames['TRAK_main'].frames['DHCOutPatienRetDJCX'];
		bottomFrame=parent.frames['TRAK_main'].frames['DHCOutPatienRetDJCXSub'];
	}
	

	
	
var subtblobj=bottomFrame.document.getElementById('tDHCOutPhRetDJCXSub');


function BodyLoadHandler() {
  BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click;
  BRetrieveobj=document.getElementById("BRetrieve");
  if (BRetrieveobj) 
   if (BRetrieveobj){
	   BRetrieveobj.onclick=Retrieve_click;
	   if (tbl.rows.length>1){RowClick();}
	   else
	   { var ret=""
	     var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRetDJCXSub&ret="+ret;
       	    bottomFrame.location.href=lnk;
	   }
	  }
  
  BPrintobj=document.getElementById("BPrint");
  if (BPrintobj) BPrintobj.onclick=Print_click;
  ctlocobj=document.getElementById("ctloc");
  useridobj=document.getElementById("userid");
  
  BPrintobj=document.getElementById("BCancleReturn");
  if (BPrintobj) BPrintobj.onclick=BCancleReturnClick;

}

function BCancleReturnClick()
{
      if (!(SelectedRow>0)) {
	      alert("请先选择退药单")
	      return;
      }
      var retrow=document.getElementById("TRetRowidz"+SelectedRow).value
      
      var ret=0
      var getCancleReturn=document.getElementById('mCancleReturn');
      if (getCancleReturn) {var encmeth=getCancleReturn.value} else {var encmeth=''};
      ret=cspRunServerMethod(encmeth,retrow)
      if (ret == "-1"){
	      alert("提示：非当天的退药记录,不能撤销！")
	      return;
      }
      if (ret == "-2"){
	      alert("提示：退药单据对应收费记录不存在,请核对！")
	      return;
      }
      if (ret == "-3"){
	      alert("提示：该条记录已退费,不能撤销！")
	      return;
      }
      if (ret == "-4"){
	      alert("提示：该条记录已撤销退药,请核对！")
	      return;
      }
      if (ret!=0){
	      alert("提示：撤消失败,请联系相关人员进行处理！")
	      return;
      }
      else
      {
	      alert("撤消成功")
	      Retrieve_click();
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
	var tmpobjrow=tblobj.rows[selectrow];
	if (selectrow==1)
	{
		tblobj.rows[1].className="clsRowSelected"
	}
	else
	{
		tblobj.rows[1].className="RowEven"
	}
	var retrow=document.getElementById("TRetRowidz"+selectrow).value
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRetDJCXSub&ret="+retrow;
 	bottomFrame.location.href=lnk;

}

function RowClick()
{
	var objfirstrow=tblobj.rows[1];
	objfirstrow.className="clsRowSelected"
    var ret=document.getElementById("TRetRowidz"+1).value
    SelectedRow=1
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRetDJCXSub&ret="+ret;
 	bottomFrame.location.href=lnk;

}
function Reset_click()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRetDJCX";
 	var ret=""
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRetDJCXSub&ret="+ret;
 	bottomFrame.location.href=lnk;
	 }


 function Print_click(){
	  var loc,locdesc;
      loc=document.getElementById('ctloc').value;
      var getlocdesc=document.getElementById('getlocdesc');
      if (getlocdesc) {var encmeth=getlocdesc.value} else {var encmeth=''};
      locdesc=cspRunServerMethod(encmeth,loc)
     
	 if (tblobj.rows.length==0) {alert(t['01']);return 0;}
	 subtblobj=bottomFrame.document.getElementById('tDHCOutPhRetDJCXSub');
	 var Rrow=SelectedRow;
	 if (Rrow<1){alert(t['02']);return 0;}
	 var rownum;
	 rownum=subtblobj.rows.length-1
	 if (rownum==0){alert(t['03']); return ;}
	 var patname=document.getElementById("TPatNamez"+Rrow).innerText
	 var pmino=document.getElementById("TPmiNoz"+Rrow).innerText
	 var retdate=document.getElementById("TRetDatez"+Rrow).innerText
     var username=document.getElementById("TRetUserz"+Rrow).innerText
     var tyyy=document.getElementById("TRetReasonz"+Rrow).innerText
     var dispdate=document.getElementById("TDispDatez"+Rrow).innerText
     var admloc=document.getElementById("TLocDescz"+Rrow).innerText
     var patsex="" //document.getElementById("TPatSexz"+Rrow).innerText
     var patage="" //document.getElementById("TPatAgez"+Rrow).innerText
     var prtinv="" //document.getElementById("TRetPrtInvz"+Rrow).innerText
     var xlApp,obook,osheet,xlsheet,xlBook
	  var getmethod=document.getElementById('gpath');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var path=cspRunServerMethod(encmeth)
 
      var paymoney
     
      var Template
       Template=path+"yftydnew.xls"
	    xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet 
	    
	    /*
	    xlsheet.cells(1,1).value=locdesc+t['04'];
        xlsheet.cells(2,1).value=t['05']+":  "+name+t['06']+" "+pmino;
   var i,j=0;
   var money=0,totmoney=0;
   
    for(i=1;i<=rownum;i++){
	  var phdesc=bottomFrame.document.getElementById("TPhDescz"+i).innerText
      var phuom=bottomFrame.document.getElementById("TPhUomz"+i).innerText
      var phqty=bottomFrame.document.getElementById("TRetQtyz"+i).innerText
      var money=bottomFrame.document.getElementById("TRetMoneyz"+i).innerText
	  xlsheet.cells(3+i,1).value=phdesc
	  xlsheet.cells(3+i,2).value=money/phqty 
	  xlsheet.cells(3+i,3).value=phqty
	  xlsheet.cells(3+i,4).value=money
	   totmoney=parseFloat(totmoney)+parseFloat(money)
	 }
    xlsheet.cells(4,5).value=tyyy
    xlsheet.cells(14,2).value=dispdate
    xlsheet.cells(15,2).value=retdate
    xlsheet.cells(16,2).value=totmoney
    xlsheet.cells(17,2).value=username
    xlsheet.printout
	xlBook.Close(savechanges=false);
	xlApp=null;
	xlsheet=null
	*/
	
	  
	    xlsheet.cells(1,1).value=locdesc+t['04']
	    //xlsheet.cells(3,4).value=patsex
	    //xlsheet.cells(3,5).value=admloc   
	    //xlsheet.cells(2,4).value=prtinv


	    //var dispdate=document.getElementById('CDispDate').value  
     // var tyyy=document.getElementById('CRetReason').value
      //xlsheet.cells(2,10).value=dispdate
      xlsheet.cells(3,5).value=retdate
	    xlsheet.cells(3,1).value="姓名:"+patname
      //xlsheet.cells(3,6).value=patage
      xlsheet.cells(4,1).value="退药原因:"+tyyy
	    //xlsheet.cells(2,1).value=t['15']+document.getElementById('CName').value+" "+t['13']+pmino+" "+t['14']+prtinv
   var rownum ,i,j=0;
   //var rows=objtbl.rows.length-1
   var money=0,rr=0;
   
      for (i=1;i<=rownum;i++){
	
      var phuom=bottomFrame.document.getElementById("TPhUomz"+i).innerText
      var phqty=bottomFrame.document.getElementById("TRetQtyz"+i).innerText
      var sp=bottomFrame.document.getElementById("TPhpricez"+i).innerText
      var phgg="" //bottomFrame.document.getElementById("TPhggz"+i).innerText
      var phmoney=bottomFrame.document.getElementById("TRetMoneyz"+i).innerText
	        xlsheet.cells(5+i,1).value=bottomFrame.document.getElementById("TPhDescz"+i).innerText
	        //xlsheet.cells(5+i,3).value=phgg
	        xlsheet.cells(5+i,3).value=phqty
	        xlsheet.cells(5+i,4).value=phuom
	        xlsheet.cells(5+i,2).value=sp  //phmoney/phqty
	        //xlsheet.cells(5+i,7).value=""
	        //xlsheet.cells(5+i,8).value=""	        
	        //xlsheet.cells(5+i,9).value=""
	        xlsheet.cells(5+i,5).value=phmoney
	        money=parseFloat(money)+parseFloat(phmoney)
	   
      }
    //if (rows==rr){ xlsheet.cells(1,5).value= t['16'];}
    
    xlsheet.cells(12,1).value="合计:"
    xlsheet.cells(12,5).value=money
    //xlsheet.cells(12,4).value=username
    //xlsheet.cells(12,10).value=retval
    xlsheet.printout
    //xlsheet.printout
	xlBook.Close(savechanges=false);
	xlApp=null;
	xlsheet=null
	var content=patname+"^"+tyyy+"^"+retdate
	var logret=tkMakeServerCall("web.DHCOutPhReturn","CreateOutRetLog",pmino,content);
	
	
	}


function Retrieve_click()
{
  stdateobj=document.getElementById("CDateSt")
  enddateobj=document.getElementById("CDateEnd")
  ctlocobj=document.getElementById("ctloc")
   var ctloc=ctlocobj.value;
  var stdate=stdateobj.value
  var enddate=enddateobj.value
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRetDJCX&CDateSt="+stdate+"&CDateEnd="+enddate+"&ctloc="+ctloc;
  topFrame.location.href=lnk;

}



document.body.onload = BodyLoadHandler;
