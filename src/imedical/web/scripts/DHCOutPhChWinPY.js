//DHCOutPhChWinPY
var SelectedRow = 0;
var a=0
  var ctloc=document.getElementById("ctloc").value;
  var userid=document.getElementById("userid").value;
    var method=document.getElementById('getsurewin');
    if (method) {var encmeth=method.value} else {var encmeth=''};
   var winvalue=cspRunServerMethod(encmeth,ctloc)
   if (winvalue!="0"){
	  var Bstr=winvalue.split("^")
	  var chwin=document.getElementById("CChWinDesc");
	  var chwinid=document.getElementById("CChWinid");
	  var phlobj=document.getElementById("phl");
	  if (chwin)chwin.value=Bstr[0]
	  if (chwinid)chwinid.value=Bstr[1]
	  if (phlobj)phlobj.value=Bstr[2]
	  
	   
   }
   
  
  
  
  var method=document.getElementById('Bvisible');
    if (method) {var encmeth=method.value} else {var encmeth=''};
    if (cspRunServerMethod(encmeth,'ButtonVis','',ctloc)=='0') {}
var objtbl=document.getElementById('tDHCOutPhChWinPY');
var SureVal=document.getElementById("BP");
     SureVal.style.visibility = "hidden";

function BodyLoadHandler() {
	var baddobj=document.getElementById("BPass");
	if (baddobj) {baddobj.onclick=Badd_click;}
	var bupobj=document.getElementById("BUpdate");
	if (bupobj) {bupobj.onclick=Bupdate_click;}
	var cyflag=document.getElementById("cyflag");
	var CChFyName=document.getElementById("CChFyName");
    if (cyflag.value=="1"){if (CChFyName) CChFyName.innerText=t['05'];}
  var obj=document.getElementById("CStepTime")
  if (obj) obj.value=30;
  
  var ctloc=document.getElementById("ctloc").value;
  var userid=document.getElementById("userid").value;
    var method=document.getElementById('getsurewinTQ');
    if (method) {var encmeth=method.value} else {var encmeth=''};
   var winvalue=cspRunServerMethod(encmeth,ctloc,userid)
   if (winvalue!="0"){
	  var Bstr=winvalue.split("^")
	  var chwin=document.getElementById("CChWinDesc");
	  var chwinid=document.getElementById("CChWinid");
	  var phlobj=document.getElementById("phl");
	  var pyid=document.getElementById("CChFyid");
	 if (chwin)  chwin.value=Bstr[0]
	 if (chwinid) chwinid.value=Bstr[1]
	  phlobj.value=Bstr[2]
	  pyid.value=Bstr[3]
	   
   } 
  var method=document.getElementById('checkpy');
    if (method) {var encmeth=method.value} else {var encmeth=''};
   var retval=cspRunServerMethod(encmeth,ctloc,userid,"1")
   if (retval!="0"){alert(t['pyfalse']);baddobj.style.visibility = "hidden";return;}


}
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCOutPhChWinPY');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	SelectedRow=selectrow
}
function BPost_click()
{
	var pydr=document.getElementById('CChFyid').value
	var fydr=""
	//document.getElementById('pydr').value
	var fywin=document.getElementById('CPyWinID').value
	var phl=document.getElementById('phl').value
	var pos=document.getElementById('CWinPosCode').value
	var steptime=document.getElementById('CStepTime').value
	var reqstr=""
	reqstr=phl+"^"+pydr+"^"+fydr+"^"+fywin+"^"+pos+"^"+steptime
	

	var Rel='DHCOutPatienDispPY.csp?ReqStr='+reqstr
	//
	//Rel+='&ReqStr='+reqstr
	
	location.href=Rel;

	//window.open("DHCOutPatienDisp.csp")
}
function Bupdate_click()
{  
	if (SelectedRow<1) return;
	var row=SelectedRow+1
	var rows=objtbl.rows.length;
	var phwpobj=document.getElementById('TPhwpidz'+row);
	var doflagobj=document.getElementById('TDoFlagz'+row);
	if (row==rows){return ;}
	var flag;
	if (doflagobj.innerText==t['01'])
	    { flag="0"; }
	    else
	    {flag="1";}
	var phwp=phwpobj.value
       ctloc=document.getElementById("ctloc").value;
	var method=document.getElementById('update');
    if (method) {var encmeth=method.value} else {var encmeth=''};
    var retval=cspRunServerMethod(encmeth,phwp,flag,ctloc)
     window.location.reload();
	
}
function pydr_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		//brokerflag=0;  //L48722 - remove brokerflag, causing changehandler to stop running
		var url= 'websys.lookup.csp';
		url += '?ID=ld50080iCChFyName';
		url += '&CONTEXT=Kweb.DHCPhQueryTotal:QueryChFy';
		//url += '&TPAGCNT=1';
		url += '&TLUJSF=GFyid';
		var obj=document.getElementById('ctloc');
		if (obj) url += '&P1=' + websys_escape(obj.value);
		var obj=document.getElementById('userid');
		if (obj) url += '&P2=' + websys_escape(obj.value);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
	var obj=document.getElementById('CChFyName');
	if (obj) obj.onkeydown=pydr_lookuphandler;
function StepTime_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
	 DHCMZYF_setfocus('CChWinDesc'); 
	}
}
	var obj=document.getElementById('CStepTime');
	if (obj) obj.onkeydown=StepTime_lookuphandler;

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



function FindWinNum(value)
{
  if (value==""){return ;}
  
  var Bstr=value.split("^");
  var ll=Bstr[1];
  var process=Bstr[0];	
  var i
  for (i=1;i<=ll;i++)
  {
	var method=document.getElementById('gwinitm');
    if (method) {var encmeth=method.value} else {var encmeth=''};
    if (cspRunServerMethod(encmeth,'Addtabrow','',process,i)=='0') {}
  }
  
  
}

function GetWinPosCode(value)
{
  if (value=="") return;
  var BStr=value.split("^");
  var winposcode=document.getElementById("CWinPosCode");
  winposcode.value=BStr[1];
  

}


function Addtabrow(value)
	{
		var objtbl=document.getElementById('tDHCOutPhChWinPY');
		tAddRow(objtbl);
		var rows=objtbl.rows.length;
		var LastRow=rows - 1;
		var Row=LastRow
		var Twindesc=document.getElementById("TWinDescz"+Row);
		var Tflag=document.getElementById("TDoFlagz"+Row);
		var Tphwpid=document.getElementById("TPhwpidz"+Row);
        var sstr=value.split("^");
		Twindesc.innerText=sstr[0];
		Tflag.innerText=sstr[1];
		Tphwpid.value=sstr[2];
	}
function tAddRow(objtbl) {
	tk_ResetRowItemst(objtbl);
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=websys_getParentElement(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			arrId[arrId.length-1]=row;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value="";
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	
	//
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowOdd";} else {objnewrow.className="RowEven";}}
}
function Delete_click()
{
	
	//var eSrc=window.event.srcElement;
	//if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCOutPhChWinPY');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	if (SelectedRow=="-1") return;
	//if (!selectrow) return;
	if (lastrowindex==SelectedRow) return;
	var selectrow0=eval(SelectedRow)+1
	var SelRowObj=document.getElementById('Tamounttopayz'+selectrow0);
	var tmpamt=eval(balanceobj.value)+eval(SelRowObj.innerText);
    
    balanceobj.value=tmpamt.toFixed(2)

	objtbl.deleteRow(SelectedRow);
	tk_ResetRowItemst(objtbl);
	
	unselected();
		
	}
function tk_ResetRowItemst(objtbl) {
	for (var i=0;i<objtbl.rows.length; i++) {
		var objrow=objtbl.rows[i];
		{if ((i+1)%2==0) {objrow.className="RowEven";} else {objrow.className="RowOdd";}}
		var rowitems=objrow.all; //IE only
		if (!rowitems) rowitems=objrow.getElementsByTagName("*"); //N6
		for (var j=0;j<rowitems.length;j++) {
			//alert(i+":"+j+":"+rowitems[j].id);
			if (rowitems[j].id) {
				var arrId=rowitems[j].id.split("z");
				//if (arrId[arrId.length-1]==i+1) break; //break out of j loop
				arrId[arrId.length-1]=i+1;
				rowitems[j].id=arrId.join("z");
				rowitems[j].name=arrId.join("z");
			}
		}
	}
}

function ButtonVis(value)
{
 var CChFyName=document.getElementById("CChFyName");
 var BSure=document.getElementById("BPass");
 var update=document.getElementById("BUpdate");
 var objtbl=document.getElementById('tDHCOutPhChWinPY');
 var sstr=value.split("^")
  if (sstr[0]=="1"){ 
  BSure.style.visibility = "visible";
  objtbl.style.visibility = "visible";
  update.style.visibility = "visible";
 var ctloc=document.getElementById("ctloc").value;
   var method=document.getElementById('BFind');
    if (method) {var encmeth=method.value} else {var encmeth=''};
    if (cspRunServerMethod(encmeth,'FindWinNum','',ctloc)=='0') {}

 }
  else {
	  BSure.style.visibility="hidden";
      update.style.visibility = "hidden";
      objtbl.style.visibility = "hidden";
    }
 if (sstr[1]=="1")
  {var cyflag=document.getElementById("cyflag");
    cyflag.value="1";
  }
}

function GChWinid(value)
{
 
  var val=value.split("^") 
  var winid=document.getElementById("CChWinid");
  winid.value=val[1]
  var phlobj=document.getElementById("phl");
  phlobj.value=val[2]
  var SureVal=document.getElementById("BP");
  var BSure=document.getElementById("BPass");
  var fyid=document.getElementById("CChFyid");
  if ((fyid.value!="")&&(phlobj.value!="")&&(BSure.style.visibility=="hidden")){SureVal.style.visibility = "visible";}
  DHCMZYF_setfocus('BPass'); 
  	  
}
//

function GFyid(value)
{
  var val=value.split("^") 
  var fyid=document.getElementById("CChFyid");
  var SureVal=document.getElementById("BP");
  fyid.value=val[1];
  var BSure=document.getElementById("BPass");
  var pydrobj=document.getElementById("pydr");
  pydrobj.value=val[2];
  var phlobj=document.getElementById("phl");
  if ((fyid.value!="")&&(phlobj.value!="")&&(BSure.style.visibility=="hidden")){SureVal.style.visibility = "visible";
  DHCMZYF_setfocus('BP');}
}

function Badd_click()	
{
  var bdispobj=document.getElementById("BP");	
  var fyid=document.getElementById("CChFyid").value;
  var pyusr=document.getElementById("userid").value;
  var ctloc=document.getElementById("ctloc").value;
 // var phw= document.getElementById("CChWinid").value;
  var pywin= document.getElementById("CPyWinID").value;
 if (pywin==""){alert(t['03']);return;}
 var phl=document.getElementById("phl").value;
  
  var method=document.getElementById('sure');
  if (method) {var encmeth=method.value} else {var encmeth=''};
 
 var retval=cspRunServerMethod(encmeth,ctloc,pyusr,pywin)
 if (retval==""){alert(t['02']);return;}
 else
    {
	    var sstr=retval.split("^")
	document.getElementById("phl").value=sstr[0]
	document.getElementById("pydr").value=sstr[1]
	    }		
		
	BPost_click()	
 // var BSure=document.getElementById("BPass");
 // var SureVal=document.getElementById("BP");
 //     BSure.style.visibility = "hidden";
 //    SureVal.style.visibility = "visible";
 //      DHCMZYF_setfocus('BP');
}

function pywin(value) 
{ 
	var sstr=value.split("^")
	var phlidobj=document.getElementById('CPyWinID');
	phlidobj.value=sstr[1]
	
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