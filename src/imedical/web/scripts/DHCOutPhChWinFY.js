//DHCOutPhChWinFY
var SelectedRow = 0;
var a=0
var ctloc=document.getElementById("ctloc").value;
 
var objtbl=document.getElementById('tDHCOutPhChWinFY');
var DispVal=document.getElementById("BNewDisp");
   //  SureVal.style.visibility = "hidden";

function BodyLoadHandler() {
	
  var ctloc=document.getElementById("ctloc").value;
  var userid=document.getElementById("userid").value;
  //BDispBTN
  var obj=document.getElementById("BDispBTN")
  if (obj) obj.onclick=BPost_Click
    var method=document.getElementById('getsurewin');
    if (method) {var encmeth=method.value} else {var encmeth=''};
   var winvalue=cspRunServerMethod(encmeth,ctloc,userid)
   if (winvalue!="0"){
	  var Bstr=winvalue.split("^")
	  var chwin=document.getElementById("CChWinDesc");
	  var chwinid=document.getElementById("CChWinid");
	  var phlobj=document.getElementById("phl");
	  var pyid=document.getElementById("pydr");
	  chwin.value=Bstr[0]
	  chwinid.value=Bstr[1]
	  phlobj.value=Bstr[2]
	  pyid.value=Bstr[3]
  var method=document.getElementById('checkfy');
   var newdisp=document.getElementById("BDispBTN");     //document.getElementById("BNewDisp");
    if (method) {var encmeth=method.value} else {var encmeth=''};
   var retval=cspRunServerMethod(encmeth,ctloc,userid,"2")
   if (retval!="0"){alert(t['fyfalse']);newdisp.style.visibility = "hidden";return;}
   
   } 

	
	
}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCOutPhChWinFY');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	SelectedRow=selectrow
}
function gwin_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		var url= 'websys.lookup.csp';
		url += '?ID=ld50080iCChWinDesc';
		url += '&CONTEXT=Kweb.DHCPhQueryTotal:QueryChWin';
		//url += '&TPAGCNT=1';
		url += '&TLUJSF=GChWinid';
		var obj=document.getElementById('ctloc');
		if (obj) url += '&P1=' + websys_escape(obj.value);
		var obj=document.getElementById('userid');
		if (obj) url += '&P2=' + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	  }
    }
	var obj=document.getElementById('CChWinDesc');
	if (obj) obj.onkeydown=gwin_lookuphandler;

function BPost_Click()
{
	var pydr=document.getElementById('CChFyid').value
	var fydr=document.getElementById('pydr').value
	var fywin=document.getElementById('CChWinid').value
	var phl=document.getElementById('phl').value
	var pos=document.getElementById('CWinPosCode').value
	//var steptime=document.getElementById('CStepTime').value
	var reqstr=""
	reqstr=phl+"^"+pydr+"^"+fydr+"^"+fywin+"^"+pos
	
	//alert(reqstr)
	var Rel='DHCOutPatienDispFY.csp?ReqStr='+reqstr
	//
	//Rel+='&ReqStr='+reqstr
	
	location.href=Rel;

	//window.open("DHCOutPatienDisp.csp")
}


function GChWinid(value)
{
  var val=value.split("^") 
  var winid=document.getElementById("CChWinid");
  winid.value=val[1]
  var phlobj=document.getElementById("phl");
  phlobj.value=val[2]
 // var fyid=document.getElementById("pydr");
 // fyid.value=val[3]
//  if (fyid.value!=""){DispVal.style.visibility = "visible";}
   	  
}

function chooseok(value) 
{ 
	
	if (value=="")
	{alert(t['04']);
	return;		}
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
