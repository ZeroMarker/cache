//DHCOutPhRXB
var bottomFrame;
var topFrame;
var tblobj=document.getElementById("tDHCOutPhRXB");
var evtName;
var doneInit=0;
var focusat=null;
var SelectedRow = 0;
var pmiobj,pnameobj;
var stdateobj,enddateobj;
var phlobj,phwobj,locdescobj,phwdescobj,pydrobj,fydrobj,pynameobj,fynameobj;
var ctlocobj;
var BResetobj,BPrintobj;
var printobj;
var ctloc,userid;


function BodyLoadHandler() {
  BResetobj=document.getElementById("BReset");
  if (BResetobj) BResetobj.onclick=Reset_click;
 var BExportobj=document.getElementById("BExport");
  if (BExportobj) BExportobj.onclick=Export_click;
  BPrintobj=document.getElementById("BPrint");
  if (BPrintobj) BPrintobj.onclick=Print_click;
  var BRetrieveobj=document.getElementById("BRetrieve");
  if (BRetrieveobj) BRetrieveobj.onclick=Retrieve_click;
  ctlocobj=document.getElementById("ctloc");
  useridobj=document.getElementById("userid");
  ctloc=ctlocobj.value;
  userid=useridobj.value;
    var tmpfydr=document.getElementById("fydr").value;
    var tmpstkcat=document.getElementById("CIncCatID").value;
    var tmpphccat=document.getElementById("CPhCatID").value;
    var tmpmandrug=document.getElementById("CManGroupID").value;
 	combo_FyDR=dhtmlXComboFromStr("CFyName","");
	combo_FyDR.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getfyry');
	var DeptStr=cspRunServerMethod(encmeth,ctloc,userid)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_FyDR.addOption(Arr);
	combo_FyDR.setComboValue(tmpfydr)
	
  	combo_StkCat=dhtmlXComboFromStr("CIncCatDesc","");
	combo_StkCat.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getstkcat');
	var DeptStr=cspRunServerMethod(encmeth)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_StkCat.addOption(Arr);
    combo_StkCat.setComboValue(tmpstkcat)
  	combo_PhCat=dhtmlXComboFromStr("CPhCat","");
	combo_PhCat.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getphcat');
	var DeptStr=cspRunServerMethod(encmeth)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_PhCat.addOption(Arr);
    combo_PhCat.setComboValue(tmpphccat)
  	combo_ManGroup=dhtmlXComboFromStr("CManGroup","");
	combo_ManGroup.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getmangroup');
	var DeptStr=cspRunServerMethod(encmeth,ctloc)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_ManGroup.addOption(Arr);
    combo_ManGroup.setComboValue(tmpmandrug)
  /*
  	combo_WinPos=dhtmlXComboFromStr("CWinPos","");
	combo_WinPos.enableFilteringMode(true);
	var encmeth=DHCC_GetElementData('getwinpos');
	var DeptStr=cspRunServerMethod(encmeth)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_WinPos.addOption(Arr);
  */
  

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
function phcat_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		var url='websys.lookup.csp?ID=d50093iCPhCat&CONTEXT=Kweb.DHCOutPhRetrieve:QueryPhCat&TPAGCNT=1&TLUJSF=GPhCatID';
		//websys_lu(url,1,'');
		websys_lu(url,1,'top=300,left=300,width=370,height=230');
		return websys_cancel();
	}
}
	var obj=document.getElementById('CPhCat');
	if (obj) obj.onkeydown=phcat_lookuphandler;
function mangroup_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		var url= 'websys.lookup.csp';
		url += '?ID=ld50093iCManGroup';
		url += '&CONTEXT=Kweb.DHCOutPhRetrieve:QueryManGroup';
		//url += '&TPAGCNT=1';
		url += '&TLUJSF=GetGroupID';
		var obj=document.getElementById('ctloc');
		if (obj) url += '&P1=' + websys_escape(obj.value);
		//websys_lu(url,1,'');
		websys_lu(url,1,'top=300,left=500,width=370,height=230');
		return websys_cancel();
	}
}
	var obj=document.getElementById('CManGroup');
	if (obj) obj.onkeydown=mangroup_lookuphandler;

function fydr_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		var url= 'websys.lookup.csp';
		url += '?ID=ld50093iCFyName';
		url += '&CONTEXT=Kweb.DHCPhQueryTotal:QueryChFy';
		//url += '&TPAGCNT=1';
		url += '&TLUJSF=GFydr';
		var obj=document.getElementById('ctloc');
		if (obj) url += '&P1=' + websys_escape(obj.value);
		var obj=document.getElementById('userid');
		if (obj) url += '&P2=' + websys_escape(obj.value);

		//websys_lu(url,1,'');
		websys_lu(url,1,'top=400,left=200,width=370,height=230');
		return websys_cancel();
	}
}
	var obj=document.getElementById('CFyName');
	if (obj) obj.onkeydown=fydr_lookuphandler;

function phdesc_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		var url= 'websys.lookup.csp';
		url += '?ID=ld50093iCPhDesc';
		url += '&CONTEXT=Kweb.DHCOutPhRetrieve:QueryPhDesc';
		//url += '&TPAGCNT=1';
		url += '&TLUJSF=GInci';
		var obj=document.getElementById('ctloc');
		if (obj) url += '&P1=' + websys_escape(obj.value);
		var obj=document.getElementById('CPhDesc');
		if (obj) url += '&P2=' + websys_escape(obj.value);

		//websys_lu(url,1,'');
		websys_lu(url,1,'top=400,left=400,width=370,height=230');
		return websys_cancel();
	}
		 
}
	var obj=document.getElementById('CPhDesc');
	if (obj) obj.onkeydown=phdesc_lookuphandler;

function inccat_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		var url= 'websys.lookup.csp';
		url += '?ID=ld50093iCIncCatDesc';
		url += '&CONTEXT=Kweb.DHCOutPhRetrieve:QueryStkCat';
		//url += '&TPAGCNT=1';
		url += '&TLUJSF=GCatID';

		//websys_lu(url,1,'');
		websys_lu(url,1,'top=400,left=500,width=370,height=230');
		return websys_cancel();
	}
}
	var obj=document.getElementById('CIncCatDesc');
	if (obj) obj.onkeydown=inccat_lookuphandler;



function Reset_click()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRXB";
 }

function GFydr(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("fyDr")
     fydrobj.value=sstr[1]
     DHCMZYF_setfocus('BRetrieve');
}
function GCatID(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("CIncCatID")
     fydrobj.value=sstr[1]
     DHCMZYF_setfocus('BRetrieve');

}
function GetWinPosCode(value)
{
 var sstr=value.split("^")
 var fydrobj=document.getElementById("CWinPosCode")
     fydrobj.value=sstr[1];
     DHCMZYF_setfocus('BRetrieve');
}

function GetGroupID(value)
{
 var sstr=value.split("^")
 var fydrobj=document.getElementById("CManGroupID")
     fydrobj.value=sstr[1];
     DHCMZYF_setfocus('BRetrieve');
}

function GPhCatID(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("CPhCatID")
     fydrobj.value=sstr[1]
     DHCMZYF_setfocus('BRetrieve');

}
function GInci(value)
{
  var sstr=value.split("^")
  var fydrobj=document.getElementById("inci")
     fydrobj.value=sstr[1]
   DHCMZYF_setfocus('BRetrieve');
}

function Retrieve_click()
{
 var stdate=document.getElementById("CDateSt").value;	
 var enddate=document.getElementById("CDateEnd").value;
 ctloc=document.getElementById("ctloc").value;
 //var fyname=document.getElementById("CFyName").value;
 var fydr=combo_FyDR.getSelectedValue()
 var sttime=document.getElementById("CStTime").value;
 var endtime=document.getElementById("CEndTime").value;
 var incdesc=document.getElementById("CPhDesc").value;
 var inc=document.getElementById("inci").value;
 var inccatid=combo_StkCat.getSelectedValue();
 var incprice=document.getElementById("CIncPrice").value;
 var phcatid=combo_PhCat.getSelectedValue()
 var phdesc=document.getElementById("CPhDesc").value;
 var manflag=document.getElementById("ChManFlag").checked;
 if (manflag==true) {manflag="Y"}
 else {manflag="N"}
 var mangroupid=combo_ManGroup.getSelectedValue()
 var userid=document.getElementById("userid").value;
 //var winposcode=combo_WinPos.getSelectedValue()
  if (incdesc=="") inc=""
  //location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRXB&ctloc="+ctloc+"&CDateSt="+stdate+"&CDateEnd="+enddate+"&fydr="+fydr+"&inci="+inc+"&CIncCatID="+inccatid+"&CIncPrice="+incprice+"&CPhCatID="+phcatid+"&ChManFlag="+manflag+"&CManGroupID="+mangroupid+"&userid="+userid+"&CWinPosCode="+winposcode+"&CStTime="+sttime+"&CEndTime="+endtime;
  location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhRXB&ctloc="+ctloc+"&CDateSt="+stdate+"&CDateEnd="+enddate+"&fydr="+fydr+"&inci="+inc+"&CIncCatID="+inccatid+"&CIncPrice="+incprice+"&CPhCatID="+phcatid+"&ChManFlag="+manflag+"&CManGroupID="+mangroupid+"&userid="+userid+"&CStTime="+sttime+"&CEndTime="+endtime+"&CPhDesc="+incdesc;
}

 function Print_click(){
	 tblobj=document.getElementById("tDHCOutPhRXB");
	 if (tblobj.rows.length==0) {alert(t['01']);return 0;}
	 var rows,pagerow;
	 var getmethod=document.getElementById('GetPrintRows');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var PrintRows=cspRunServerMethod(encmeth,ctloc,userid)
      if (PrintRows==0){alert(t['03']);return ;}
	 var path
	   pagerow=35;
     var Ls_orderitemtmp,RowN,i
      var getmethod=document.getElementById('gpath');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var path=cspRunServerMethod(encmeth)
     var datest=document.getElementById('CDateSt');
	 var dateend=document.getElementById('CDateEnd');
	 var fyname=document.getElementById('CFyName').value;
	 //var winpos=document.getElementById('CWinPos').value;
	 var ctlocobj=document.getElementById('ctloc');
	 var sttime=document.getElementById('CStTime').value;
	 var endtime=document.getElementById('CEndTime').value;
	   var getmethod=document.getElementById('getlocdesc');
      if (getmethod) {var encmeth=getmethod.value} else {var encmeth=''};
      var locdesc=cspRunServerMethod(encmeth,ctlocobj.value)
   
	  var xlApp,obook,osheet,xlsheet,xlBook
	    var paymoney
        var Template
        Template=path+"yfrxb.xls"
        xlApp = new ActiveXObject("Excel.Application");
	    xlBook = xlApp.Workbooks.Add(Template);
	    xlsheet = xlBook.ActiveSheet
	    xlsheet.cells(1,1).value=locdesc +t['08']
	    xlsheet.cells(2,1).value=fyname  //+"        "+winpos
        xlsheet.cells(3,1).value=datest.value+sttime+t['02']+dateend.value+endtime
 var pagenum
 if (Math.floor(PrintRows/pagerow)==(PrintRows/pagerow)){pagenum=Math.floor(PrintRows/pagerow);}
	else {pagenum=Math.floor(PrintRows/pagerow)+1;}  
 var k,j,l,RowNum,count;
 var  lastnum = PrintRows-(pagenum-1)*pagerow 
    for (k=1;k<=pagenum;k++){
	  xlsheet.cells(3,5).value=t['04']+k+t['05']+pagenum+t['06']
      if (k==pagenum){RowNum=lastnum;} else {RowNum=pagerow;}
      for (l=5;l<=pagerow+4;l++){for(j=1;j<=7;j++){xlsheet.Cells(l, j).value=""}}
      for(i=1;i<=RowNum;i++){
	      var getmethod=document.getElementById('GRowPrint');
           if (getmethod) {var encmeth=getmethod.value} else {var encmeth='';}
          var PrintSet=cspRunServerMethod(encmeth,ctloc,userid,i+(k-1)*pagerow)
          var sstr=PrintSet.split("^")
		  xlsheet.cells(4+i,1).value=sstr[0];
		  xlsheet.cells(4+i,2).value=sstr[1];
	 	  xlsheet.cells(4+i,3).value=sstr[2];
	 	  xlsheet.cells(4+i,4).value=sstr[3];
		  xlsheet.cells(4+i,5).value=sstr[4];
		  xlsheet.cells(4+i,6).value=sstr[5];
	 }
    xlsheet.printout
  }
	xlBook.Close(savechanges=false);
	xlApp=null;
	xlsheet=null

   }	   
function Export_click() 
{ 
tblobj=document.getElementById("tDHCOutPhRXB");
var oXL = new ActiveXObject("Excel.Application"); 
var oWB = oXL.Workbooks.Add(); 
var oSheet = oWB.ActiveSheet; 
var rows = tblobj.rows.length; 
var lie = tblobj.rows(0).cells.length; 
var i,j;
// Add table headers going cell by cell. 
for (i=0;i<rows;i++){ 
    for (j=0;j<lie;j++){ 
        oSheet.Cells(i+1,j+1).value = tblobj.rows(i).cells(j).innerText; } ;
   } 
oXL.Visible = true; 
oXL.UserControl = true; 
} 

function DHCMZYF_setfocus(objName) {
	window.setTimeout('DHCMZYF_setfocus2(\''+objName+'\')',300);
}

function DHCMZYF_setfocus2(objName) {
	var obj=document.getElementById(objName);
	if (obj) {
		try {obj.focus();obj.select();	} catch(e) {}  }
    }


document.body.onload = BodyLoadHandler;
