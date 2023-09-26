//TransAdmTest.js
var m_PatientNoLength=10;
var TLocDescobj;
var obj;
var PrtOutobj;
var getpath;
var path;
var PrtOutobj;
var locidobj;
if (document.getElementById("PatientNoLen")){
	m_PatientNoLength=document.getElementById("PatientNoLen").value;
}
function BodyLoadHandler() 
{
   var obj=document.getElementById("RegNo");
   if (obj) obj.onkeydown=RegNo_OnKeyDown;
   var obj=document.getElementById('Clear');
   if (obj) obj.onclick = Clear_Click;
   TLocDescobj=document.getElementById('TLocDesc');
   TLocDescobj.onkeydown=getTLocDesc; 
   TLocDescobj.onkeyup=clearlocid;
   var PrtOutobj=document.getElementById('PrtOut');
   if(PrtOutobj) {PrtOutobj.onclick=PrtOut_click};
   ShowTotal()   
}
function getPath() {
	var path=tkMakeServerCall("web.UDHCJFCOMMON","getpath","","");
	return path
}
function clearlocid()
{
	var locidobj=document.getElementById('locid');
	locidobj.value="";
}
function ShowTotal()
{
	/*var objtbl=document.getElementById('tTransAdmTest'); //tTransAdmTest
	var rows=objtbl.rows.length;
	if (rows>1) {
		var index=rows-1
		//var TobjTotal=document.getElementById("TTotalz"+1);	
		var objTotal=document.getElementById('Total');
    	if (objTotal) objTotal.value=index;
    	
	}*/
	var objtbl=document.getElementById('tTransAdmTest');
	var rows=objtbl.rows.length;
	if (rows>1) {
		var index=rows-1
		var TobjTotal=document.getElementById("TTotalz"+1);
		var objTotal=document.getElementById('Total');
    	if (objTotal) objTotal.value=TobjTotal.value;
	}
}

function Clear_Click()
{   
	 location.href="websys.default.csp?WEBSYS.TCOMPONENT=TransAdmTest";
}

function getTLocDesc()
{if (window.event.keyCode==13) 
	{  window.event.keyCode=117;
	   TLocDesc_lookuphandler();
		}
	}
   
function getlocid(value)	
{
	var val=value.split("^");
	var obj=document.getElementById('locid');
	obj.value=val[1];
}
function RegNo_OnKeyDown(e)	{
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='keydown')&&(key==9)) {
		var RegNo=document.getElementById('RegNo');
		if (RegNo.value.length<m_PatientNoLength) {
			for (var i=(m_PatientNoLength-RegNo.value.length-1); i>=0; i--) {
				RegNo.value="0"+RegNo.value
			}
		}
		websys_nextfocusElement(RegNo);
	}
	if ((type=='keydown')&&(key==13)) {
		var RegNo=document.getElementById('RegNo');
		if (RegNo.value.length<m_PatientNoLength) {
			for (var i=(m_PatientNoLength-RegNo.value.length-1); i>=0; i--) {
				RegNo.value="0"+RegNo.value
			}
		}
		return Find_click();
	}
}
document.body.onload = BodyLoadHandler;