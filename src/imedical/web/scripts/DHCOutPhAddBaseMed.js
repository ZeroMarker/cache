
var selectrow="";

function BodyLoadHandler()
{
	
	var obj=document.getElementById("arcitm"); 
	if (obj) 
	{	
		obj.onkeydown=popArcitm;
	 	
	} 
	
	var obj=document.getElementById("inst"); 
	if (obj) 
	{	
		obj.onkeydown=popInst;
		obj.onblur=InstBlur;
	 	
	} 
	
	
	var obj=document.getElementById("docloc"); 
	if (obj) 
	{	
		obj.onkeydown=popDocloc;
	 	
	}
	
	var obj=document.getElementById("useloc"); 
	if (obj) 
	{	
		obj.onkeydown=popUseloc;
	 	
	} 
	 
	obj=document.getElementById("save");
	if (obj) obj.onclick=SaveClick;
	
	obj=document.getElementById("delete");
	if (obj) obj.onclick=DelClick;
	
	obj=document.getElementById("update");
	if (obj) obj.onclick=UpdClick;
	
	
}


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('tDHCOutPhAddBaseMed');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
    selectrow=rowObj.rowIndex;
    
    WriteDataToItem(); //�����ʾ����
	
}

function WriteDataToItem()
{
	if (!(selectrow))  return;
	var arc="";
    var tbarcobj=document.getElementById('Tarcitmz'+selectrow);
    if (tbarcobj){
	    arc=tbarcobj.innerText;
    }
    var inst="";
    var tbinstobj=document.getElementById('Tinstz'+selectrow);
    if (tbinstobj){
	    inst=tbinstobj.innerText;
    }
    var instdr="";
    var tbinstdrobj=document.getElementById('Tinstrowidz'+selectrow);
    if (tbinstdrobj){
	    instdr=tbinstdrobj.value;
    }
    var docloc="";
    var tbdoclocobj=document.getElementById('Tdoclocz'+selectrow);
    if (tbdoclocobj){
	    docloc=tbdoclocobj.innerText;
    }
    var useloc="";
    var tbuselocobj=document.getElementById('Tuselocz'+selectrow);
    if (tbuselocobj){
	    useloc=tbuselocobj.innerText;
    }
    var note="";
    var tbnoteobj=document.getElementById('Tnotez'+selectrow);
    if (tbnoteobj){
	    note=tbnoteobj.innerText;
    }
	
	//
	var arcobj=document.getElementById('arcitm');
	if (arcobj){
		arcobj.value=arc;
	}
	var instdrobj=document.getElementById('instrowid');
	if (instdrobj){
		instdrobj.value=instdr;
	}
	var instobj=document.getElementById('inst');
	if (instobj){
		instobj.value=inst;
	}
	var doclocobj=document.getElementById('docloc');
	if (doclocobj){
		doclocobj.value=docloc;
	}
	var uselocobj=document.getElementById('useloc');
	if (uselocobj){
		uselocobj.value=useloc;
	}
	var noteobj=document.getElementById('note');
	if (noteobj){
		noteobj.value=note;
	}
}

function UpdClick()
{
	if (!(selectrow>0)){
		return;
	}
	var phbr=""
	var phbrobj=document.getElementById('Tphbrz'+selectrow);
	if (phbrobj){
		var phbr=phbrobj.innerText;
	}
	
	if (phbr=="") {
		alert("����ѡ���¼!");
		return;
	}
    
    var updflag=0;
	var arc="";
	var objarc=document.getElementById("arcrowid");
	if (objarc){
		arc=objarc.value;
	}
	if (arc!=""){
		updflag=1;
	}
	
	var inst="";
	var objinst=document.getElementById("instrowid");
	if (objinst){
		inst=objinst.value;
	}	
	if (inst!=""){
		updflag=1;
	}
	
	var doclocdr="";
	var objdocloc=document.getElementById("doclocdr");
	if (objdocloc){
		doclocdr=objdocloc.value;
	}
	if (doclocdr!=""){
		updflag=1;
	}
	
	var uselocdr="";
	var objuseloc=document.getElementById("uselocdr");
	if (objuseloc){
		uselocdr=objuseloc.value;
	}
	if (uselocdr!=""){
		updflag=1;
	}

	var note="";
	var objnote=document.getElementById("note");
	if (objnote){
		note=objnote.value;
	}
	if (note!=""){
		updflag=1;
	}
	if (updflag!=1){
		alert("û�и�������")
		return;
	}
	
	var xx=document.getElementById("mupdate");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,phbr,arc,inst,doclocdr,uselocdr,note) ;
	ReloadWinow();
}

function DelClick()
{
	if (!(selectrow>0)){
		return;
	}
	var phbr
	var phbrobj=document.getElementById('Tphbrz'+selectrow);
	if (phbrobj){
		var phbr=phbrobj.innerText;
	}
	
	if (phbr=="") return;
	var xx=document.getElementById("mdelete");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,phbr) ;
	ReloadWinow();
	
}

function SaveClick()
{
	var arc="";
	var objarc=document.getElementById("arcrowid");
	if (objarc){
		arc=objarc.value;
	}
	var arcdesc="";
	var objarcdesc=document.getElementById("arcitm");
	if (objarcdesc){
		arcdesc=objarcdesc.value;
	}
	if ((arcdesc!="")&&(arc=="")){
		alert("�ü�¼�Ѵ���!");
		return;
	}
	if (arc==""){
		alert("����ѡ��ҩƷ����!");
		return;
	}
	
	var inst="";
	var objinst=document.getElementById("instrowid");
	if (objinst){
		inst=objinst.value;
	}
	if (inst==""){
		//alert("����ѡ���÷�!");
		//return;
	}
	
	var doclocdr="";
	var objdocloc=document.getElementById("doclocdr");
	if (objdocloc){
		doclocdr=objdocloc.value;
	}
	if (doclocdr==""){
		alert("����ѡ��ҽ������!");
		return;
	}
	
	var uselocdr="";
	var objuseloc=document.getElementById("uselocdr");
	if (objuseloc){
		uselocdr=objuseloc.value;
	}
	if (uselocdr==""){
		alert("����ѡ��ʹ�ÿ���!");
		return;
	}
	
	var note="";
	var objnote=document.getElementById("note");
	if (objnote){
		note=objnote.value;
	}

	
	var xx=document.getElementById("minsert");
	if (xx) {var encmeth=xx.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,arc,inst,doclocdr,uselocdr,note) ;
	
	ReloadWinow();
	
	
}

function popInst()
{ 

	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  inst_lookuphandler();
	}
}

function instLookupSelect(str)
{	
    
	var tmp=str.split("^");
	var obj=document.getElementById("instrowid");
	if (obj)
	{
		if (tmp.length>0)   obj.value=tmp[1] ;
		else  obj.value="" ;  
	}

}
function inst_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var url= 'websys.lookup.csp';
		url += '?ID=inst';
		url += '&CONTEXT=Kweb.DHCOutPhCommon:GetInstDs';  //��Ӧquery
		url += '&TLUJSF=instLookupSelect';			  //��Ӧjsѡ��
		var obj=document.getElementById('inst');
		if (obj) url += '&P1=' + websys_escape(obj.value);  //��Ӧ����
		websys_lu(url,1);
		return websys_cancel();
	}
		 
}


function popArcitm()
{ 

	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  arcitm_lookuphandler();
	}
}

function arcitmLookupSelect(str)
{	
	var tmp=str.split("^");
	var obj=document.getElementById("arcrowid");
	if (obj)
	{
		if (tmp.length>0)   obj.value=tmp[1] ;
		else  obj.value="" ;  
	}

}
///�س�����,yunhaibao20151109,IE11,����ƽ̨����
function arcitm_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var url= 'websys.lookup.csp';
		url += '?ID=arcitm';
		url += '&CONTEXT=Kweb.DHCOutPhCommon:GetDrugDs';  //��Ӧquery
		url += '&TLUJSF=arcitmLookupSelect';			  //��Ӧjsѡ��
		var obj=document.getElementById('arcitm');
		if (obj) url += '&P1=' + websys_escape(obj.value);  //��Ӧ����
		websys_lu(url,1);
		return websys_cancel();
	}
		 
}



function popDocloc()
{ 

	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  docloc_lookuphandler();
	}
}

function doclocLookupSelect(str)
{	
    
	var tmp=str.split("^");
	var obj=document.getElementById("doclocdr");
	if (obj)
	{
		if (tmp.length>0)   obj.value=tmp[1] ;
		else  obj.value="" ;  
	}

}
function docloc_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var url= 'websys.lookup.csp';
		url += '?ID=docloc';
		url += '&CONTEXT=Kweb.DHCOutPhCommon:QueryDept';  //��Ӧquery
		url += '&TLUJSF=doclocLookupSelect';			  //��Ӧjsѡ��
		var obj=document.getElementById('docloc');
		if (obj) url += '&P1=' + websys_escape(obj.value);  //��Ӧ����
		websys_lu(url,1);
		return websys_cancel();
	}
		 
}


function popUseloc()
{ 

	if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	  useloc_lookuphandler();
	}
}

function uselocLookupSelect(str)
{	
    
	var tmp=str.split("^");
	var obj=document.getElementById("uselocdr");
	if (obj)
	{
		if (tmp.length>0)   obj.value=tmp[1] ;
		else  obj.value="" ;  
	}

}
function useloc_lookuphandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))) {
		var url= 'websys.lookup.csp';
		url += '?ID=useloc';
		url += '&CONTEXT=Kweb.DHCOutPhCommon:QueryDept';  //��Ӧquery
		url += '&TLUJSF=uselocLookupSelect';			  //��Ӧjsѡ��
		var obj=document.getElementById('useloc');
		if (obj) url += '&P1=' + websys_escape(obj.value);  //��Ӧ����
		websys_lu(url,1);
		return websys_cancel();
	}
		 
}


function ReloadWinow()
{	
    var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCOutPhAddBaseMed" ;
	location.href=lnk;
}

function InstBlur()
{
    var inst="" ;
	var instobj=document.getElementById('inst');
	if (instobj){
		inst=instobj.value;
	}
	
	var instdrobj=document.getElementById('instrowid');
	if (instdrobj){
		if (inst==""){
			instdrobj.value="";
		}
		
	}
}


document.body.onload=BodyLoadHandler;