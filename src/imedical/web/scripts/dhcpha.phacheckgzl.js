//dhcpha.phacheckgzl
function BodyLoadHandler() {
var SelectedRow = 0;
 var BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click;
 var obj=document.getElementById("BRetrieve");
  if (obj) obj.onclick=Retrieve_click;
 var obj=document.getElementById("BPrint");
  if (obj) obj.onclick=Print_Click;
 var ctlocobj=document.getElementById("ctloc");
 var useridobj=document.getElementById("userid");
 var objtbl=document.getElementById("t"+"dhcpha_phacheckgzl");
}



function Reset_click()
{
		location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phacheckgzl";
 }


 function DHCMZYF_setfocus(objName) {
	window.setTimeout('DHCMZYF_setfocus2(\''+objName+'\')',300);
}

function DHCMZYF_setfocus2(objName) {
	var obj=document.getElementById(objName);
	if (obj) {
		try {obj.focus();obj.select();	} catch(e) {}  }
    }
	   
function Retrieve_click()
{
  var stdate=document.getElementById("CStDate").value;
  var enddate=document.getElementById("CEndDate").value;
  var ctloc=document.getElementById("ctloc").value;
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phacheckgzl&CStDate="+stdate+"&CEndDate="+enddate+"&ctloc="+ctloc;
  location.href=lnk;

}
function Print_Click()
{
	var objtbl=document.getElementById("t"+"dhcpha_phacheckgzl");
	  if (objtbl.rows.length==0) {return ;}
	  var rows,pagerow;
	   rows=objtbl.rows.length-1
	   pagerow=35;
      var Ls_orderitemtmp,RowN,i
      var getmethod=document.getElementById('gpath');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var path=cspRunServerMethod(encmeth)
      var datest=document.getElementById('CStDate');
	  var dateend=document.getElementById('CEndDate');
	
	  var xlApp,obook,osheet,xlsheet,xlBook
	  var paymoney
      var Template
        Template=path+"zyyfcheckgzl.xls"
        xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet
        xlsheet.cells(1,1).value=datest.value+t['zhi']+dateend.value
    
       for(i=1;i<=rows;i++){
		  xlsheet.cells(2+i,1).value=document.getElementById("TWardDescz"+i).innerText
		  xlsheet.cells(2+i,2).value=document.getElementById("TUserNamez"+i).innerText
	 	  xlsheet.cells(2+i,3).value=document.getElementById("TGroupNumz"+i).innerText
	 	  xlsheet.cells(2+i,4).value=document.getElementById("TRefuseNumz"+i).innerText
	 	  xlsheet.cells(2+i,5).value=document.getElementById("TCancelRefz"+i).innerText
	 	  xlsheet.cells(2+i,6).value=document.getElementById("TCheckNumz"+i).innerText
	 	  xlsheet.cells(2+i,7).value=document.getElementById("TRefNumz"+i).innerText
	 	  xlsheet.cells(2+i,8).value=document.getElementById("TCanRefNumz"+i).innerText


	     }
    xlsheet.printout
	xlBook.Close(savechanges=false);
	xlApp=null;
	xlsheet=null

   }	   

document.body.onload = BodyLoadHandler;
