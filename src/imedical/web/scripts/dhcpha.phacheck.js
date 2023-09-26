//dhcpha.phacheck
function BodyLoadHandler() {
var SelectedRow = 0;
 var BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click;
 var obj=document.getElementById("BRetrieve");
  if (obj) obj.onclick=Retrieve_click;
 var obj=document.getElementById("BExport");
  //if (obj) obj.onclick=Export_click;
 var obj=document.getElementById("BDoCheck");
  if (obj) obj.onclick=DoCheck_click;
 var  BPrintobj=document.getElementById("BPrint");
  if (BPrintobj) BPrintobj.onclick=Print_click;

 var ctlocobj=document.getElementById("ctloc");
 var useridobj=document.getElementById("userid");
 var pmiobj=document.getElementById("CPmiNo");
  if (pmiobj) pmiobj.onkeypress=GetPmino;
 var objtbl=document.getElementById("t"+"dhcpha_phacheck");
	if (objtbl) objtbl.ondblclick=setRefuse;
 var chflag=document.getElementById("ch").value;
 var checkflag=document.getElementById("CheckFlag");
 if (checkflag) checkflag.onclick=ChooseCH;
 if (chflag=="Y"){checkflag.checked=true;}
 else
 {checkflag.checked=false;}
 
 var flag=document.getElementById("chgroup").value;
 var groupflag=document.getElementById("CGroupFlag");
 if (groupflag) groupflag.onclick=ChGroup;
 if (flag=="Y"){groupflag.checked=true;}
 else
 {groupflag.checked=false;}
 
  var CWardDescObj=document.getElementById("CWardDesc");
  if (CWardDescObj)  CWardDescObj.value=unescape(CWardDescObj.value)
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
		location.href="websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phacheck";
 }
function ChooseCH()
{
  var chobj=document.getElementById("ch")
  var checkobj=document.getElementById("CheckFlag")	
  if (checkobj.checked==true){chobj.value="Y";}
  else
   {chobj.value="N";}
}

function ChGroup()
{
  var chobj=document.getElementById("chgroup")
  var checkobj=document.getElementById("CGroupFlag")	
  if (checkobj.checked==true){chobj.value="Y";}
  else
   {chobj.value="N";}
}
function GetWardID(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("CWard")
     fydrobj.value=sstr[1]
}

function GetPmino() {
 var key=websys_getKey(e);
 var pmiobj=document.getElementById("CPmiNo");
 if (key==13) {	
    var plen=pmiobj.value.length
    var i
    var lszero=""
    if (plen==0){return ;}
 	if (plen>8){alert(t['01']);
 	document.getElementById("CPmiNo").value="";
 	document.getElementById("CPatName").value="";
 	document.getElementById("Adm").value="";
 	return;}
	 for (i=1;i<=8-plen;i++)
  	  {
	 	 lszero=lszero+"0"  
    	 }
	 var lspmino=lszero+pmiobj.value;
	 pmiobj.value=lspmino
	var getmethod=document.getElementById('getadm');
    if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
 var retval=cspRunServerMethod(encmeth,lspmino)
 
 if (retval==0){
	 alert(t['noadm']);
    document.getElementById("CPmiNo").value="";
 	document.getElementById("CPatName").value="";
 	document.getElementById("Adm").value="";}
 else
  { var sstr=retval.split("^")
  var fydrobj=document.getElementById("CPatName")
      fydrobj.value=sstr[0]
  var fydrobj=document.getElementById("Adm")
      fydrobj.value=sstr[2]
     }

 }
}
 function DoCheck_click(){
	 var objtbl=document.getElementById("t"+"dhcpha_phacheck");
      if (objtbl.rows.length==1) {return ;}
      var rowcount=objtbl.rows.length-1
	 var ctloc=document.getElementById("ctloc").value
	 var userid=document.getElementById("userid").value
	 //var ctloc=document.getElementById("ctloc").value
  	  for (var i=1;i<=rowcount;i++)
    	{
	      var chdsp=document.getElementById("TDispz"+i).value
	      var getmethod=document.getElementById('check');
	       
	      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
    
         var retval;
         retval=cspRunServerMethod(encmeth,chdsp,ctloc,userid);
	      
	     if (retval!=0){alert(t['haveerr']);Retrieve_click();return ;}
	   
    	}
	  alert(t['chsuess']);
	   Retrieve_click();

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
  var adm=document.getElementById("Adm").value;
  var ward=document.getElementById("CWard").value;
  if (ward==""){if (adm==""){alert(t['nocon']);return;}}
  var stdate=document.getElementById("CStDate").value;
  var warddesc=document.getElementById("CWardDesc").value;
  var pmino=document.getElementById("CPmiNo").value;
  var patname=document.getElementById("CPatName").value;
  if (warddesc==""){ward="";document.getElementById("CWard").value="";}
  var enddate=document.getElementById("CEndDate").value;
  var ctloc=document.getElementById("ctloc").value;
  var userid=document.getElementById("userid").value;
  var chflag=document.getElementById("ch").value;
  var chgroupflag=document.getElementById("chgroup").value;
  warddesc=escape(warddesc)
  var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.phacheck&CStDate="+stdate+"&CEndDate="+enddate+"&ctloc="+ctloc+"&CWard="+ward+"&Adm="+adm+"&ch="+chflag+"&CPmiNo="+pmino+"&CPatName="+patname+"&CWardDesc="+warddesc+"&userid="+userid+"&chgroup="+chgroupflag;
  location.href=lnk;

}
function setRefuse()
{
	
	var refuseFlag=document.getElementById("TNoDispz"+SelectedRow).innerText
	
	var oedsp=document.getElementById("TDispz"+SelectedRow).value
	var seqno=document.getElementById("TPrescnoz"+SelectedRow).innerText
	var user=document.getElementById("userid").value
	var ctloc=document.getElementById("ctloc").value
	
	
	if (refuseFlag!="Y") {
		var ret=confirm(t['IF_REFUSE']);
		if (ret==true)
		{
		 var getmethod=document.getElementById('ins');
         if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
          var retval=cspRunServerMethod(encmeth,oedsp,ctloc,user,seqno)
		 if (retval!=0){alert(t['reffail']);return;}
		 Retrieve_click()
		 //document.getElementById("TNoDispz"+SelectedRow).innerText="Y"	
		}
	}
	else 
		{
		var ret=confirm(t['CANCEL_REFUSE']);
		if (ret==true)
		{
		var getmethod=document.getElementById('del');
         if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
         var retval=cspRunServerMethod(encmeth,ctloc,oedsp,seqno,user)
		 if (retval!=0){alert(t['canrefusefaile']);return;}
		 Retrieve_click()
		 //document.getElementById("TNoDispz"+SelectedRow).innerText=""	
		}
		}
}
 function Print_click(){
	 var tblobj=document.getElementById("t"+"dhcpha_phacheck");
	 if (tblobj.rows.length==0) {alert(t['nodata']);return 0;}
	 var rows,pagerow;
	 var ctlocobj=document.getElementById('ctloc');
	 var ctloc=ctlocobj.value
	 var userid=document.getElementById('userid').value;
	 var getmethod=document.getElementById('getrows');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var PrintRows=cspRunServerMethod(encmeth,ctloc)
      if (PrintRows==0){alert(t['printerr']);return ;}
	 var path
	   pagerow=35;
     var Ls_orderitemtmp,RowN,i
      var getmethod=document.getElementById('getpath');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var path=cspRunServerMethod(encmeth)
     var datest=document.getElementById('CStDate');
	 var dateend=document.getElementById('CEndDate');
	 
     var getmethod=document.getElementById('getlocdesc');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var locdesc=cspRunServerMethod(encmeth,ctlocobj.value)
   
	  var xlApp,obook,osheet,xlsheet,xlBook
	    var paymoney
        var Template
        Template=path+"ypsh.xls"
        xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet
	    xlsheet.cells(2,1).value=locdesc 
        xlsheet.cells(3,1).value=datest.value+t['to']+dateend.value
 var pagenum
 if (Math.floor(PrintRows/pagerow)==(PrintRows/pagerow)){pagenum=Math.floor(PrintRows/pagerow);}
	else {pagenum=Math.floor(PrintRows/pagerow)+1;}  
 var k,j,l,RowNum,count;
 var  lastnum = PrintRows-(pagenum-1)*pagerow 
    for (k=1;k<=pagenum;k++){
      if (k==pagenum){RowNum=lastnum;} else {RowNum=pagerow;}
      for (l=5;l<=pagerow+4;l++){for(j=1;j<=7;j++){xlsheet.Cells(l, j).value=""}}
      for(i=1;i<=RowNum;i++){
	      var getmethod=document.getElementById('getrowforprint');
           if (getmethod) {var encmeth=getmethod.value} else {var encmeth='';}
          var PrintSet=cspRunServerMethod(encmeth,ctloc,i+(k-1)*pagerow)
          var sstr=PrintSet.split("^")
		  xlsheet.cells(4+i,1).value=sstr[1];
		  xlsheet.cells(4+i,2).value=sstr[2];
	 	  xlsheet.cells(4+i,3).value=sstr[3];
	 	  xlsheet.cells(4+i,4).value=sstr[4];
		  xlsheet.cells(4+i,5).value=sstr[5];
		  xlsheet.cells(4+i,6).value=sstr[6];
		  xlsheet.cells(4+i,7).value=sstr[7];

		  xlsheet.cells(4+i,8).value=sstr[13];
		  xlsheet.cells(4+i,9).value=sstr[9];
		  xlsheet.cells(4+i,10).value=sstr[10];
		  xlsheet.cells(4+i,11).value=sstr[11];
		  xlsheet.cells(4+i,12).value=sstr[12];
		  xlsheet.cells(4+i,13).value=sstr[14];
		  xlsheet.cells(4+i,14).value=sstr[15];
		  xlsheet.cells(4+i,15).value=sstr[16];
		  xlsheet.cells(4+i,16).value=sstr[21];
		  xlsheet.cells(4+i,17).value=sstr[22];
	 }
    xlsheet.printout
  }
	xlBook.Close(savechanges=false);
	xlApp=null;
	xlsheet=null

  
 
   }

document.body.onload = BodyLoadHandler;
