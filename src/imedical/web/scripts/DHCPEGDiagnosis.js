/// DHCPEStationSResult.js
var obj;
var DSelectedRow=0
function InitMe() {
	var Audit=document.getElementById('BSubmit');
	if (Audit) {Audit.onclick=Audit_click;}
	var Update=document.getElementById('BUpdate');
	if (Update) {Update.onclick=Update_click;}
	var Delete=document.getElementById('BDelete');
	if (Delete) {Delete.onclick=Delete_Click;}
	var InsertED=document.getElementById('BDiagnosis');
	if (InsertED) {InsertED.onclick=InsertED_click;}
	
	var GetIllness=document.getElementById('BGetIllness');
	if (GetIllness) {GetIllness.onclick=GetIllness_click;}
	//SumResult.disabled=true;
	
	//if (AddResult) {AddResult.onclick=AddResult_click;}
	var obj=document.getElementById('AddDiagnosis');
	if (obj) obj.onkeydown=AddDiagnosis_KeyDown;
	websys_setfocus("AddDiagnosis");
}
/*
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1);

}*/
function AddDiagnosis_KeyDown()
{
	var key=websys_getKey(e);
	if (13==key) {
		var obj=document.getElementById('GDComponentID');
		if (obj) var ComponentID=obj.value;
		var obj=document.getElementById('ld'+ComponentID+'iAddDiagnosis');
		if (obj) obj.click();return false;
		}
		
}
function InsertED_click()
{
	var wwidth=450;
	var wheight=500; 
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCPEIllnessStandard.New&InsertType=User";
	var nwin='toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes'
			+',height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)
	//window.open(lnk,'','',"dialogHeight:600px;dialogWidth:800px;center:yes;help:no;resizable:no;status:no;")
	
}
function AddDiagnosis(value){
	var Addobj=document.getElementById("AddDiagnosis");
	if (Addobj) Addobj.value=""
	var ID=value.split("^")[0];
	var SSIDObj=document.getElementById("GGSD");
	if (SSIDObj) var SSID=SSIDObj.value;
	var obj=document.getElementById("DSumResultBox");
	if (obj) var encmeth=obj.value;
	if (SSID=="") {alert(t["NoSS"]);return false;}
	var flag=cspRunServerMethod(encmeth,SSID,ID,"0");
	
	if (flag==0){ location.reload(); return false;}
	alert(t[flag]);return false;
}
function GetIllness_click()
{
	obj=document.getElementById("GID");
	if (obj) var GADM=obj.value;
	obj=document.getElementById("GetIllnessBox");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,GADM);
	if (flag==0){ location.reload(); return false;}
	alert(t[flag]);return false;
}
function Update_click(){
	var objtbl=document.getElementById('tDHCPEGDiagnosis');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	var lastrowindex=rows - 1;
	var i,obj,ID,Remark,Strings;
	var ID,Remark,Strings="",Advice;
	for (i=1;i<rows;i++)
	{
		obj=document.getElementById("TRowIDz"+i);
		if (obj) ID=obj.value;
		obj=document.getElementById("TDiagnoseConclusionz"+i);
		if (obj) Remark=obj.value;
		obj=document.getElementById("TAdvicez"+i);
		if (obj) Advice=obj.value;
		obj=document.getElementById("TSortz"+i);
		if (obj) Sort=obj.value;
		if (Sort=="")
		{
			alert(t["SortNull"]+i);
			return false;
		}
		if (Strings=="")
		{
			Strings=ID+"&&"+Remark+"&&"+Advice+"&&"+Sort
		}
		else
		{
			Strings=Strings+"^"+ID+"&&"+Remark+"&&"+Advice+"&&"+Sort
		}
	}
	if (Strings=="") return false;
	var obj=document.getElementById("UpdateBox");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,Strings)
	alert(t[flag]);
	return false;
		
}
function Audit_click() {
	obj=document.getElementById("GID");
	if (obj) var GADM=obj.value;
	obj=document.getElementById("AuditBox");
	if (obj) var encmeth=obj.value;
	var flag=cspRunServerMethod(encmeth,GADM,"Submit");
	alert(t[flag]);
	return false;
}
function Delete_Click()
{
	
	//if (!confirm(t['Del'])) return false;
	
	var Dobj=document;
	var obj=Dobj.getElementById("GGSD");
	if (obj) var SSID=obj.value;
	//if (DSelectedRow==0) return false;
	
	var objtbl=document.getElementById('tDHCPEGDiagnosis');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	var IDs=""
	for (i=1;i<rows;i++)
	{
		var obj=Dobj.getElementById("TDeletez"+i) ;
		if (obj&&obj.checked)
		{
			var obj=Dobj.getElementById("TRowIDz"+i);
			if (IDs=="")
			{
				IDs=obj.value;
			}
			else
			{
				IDs=IDs+"^"+obj.value;
			}
		}
		
	}
	
	
	var obj=document.getElementById("DSumResultBox");
	if (obj) var encmeth=obj.value;
	
	if (IDs=="") 
	{
		alert("请选择待删除的记录");
		return false;
	}else{
		if (!confirm(t['Del'])) return false;
	}

	
	var flag=cspRunServerMethod(encmeth,SSID,IDs,"1");
	if (flag==0){ location.reload(); return false;}
	alert(t[flag]);return false;
}
function SumResult_click(){
	if (!confirm(t['Del'])) return false;
	
	var Dobj=document;
	var obj=Dobj.getElementById("GGSD");
	if (obj) var SSID=obj.value;
	if (DSelectedRow==0) return false;
	var obj=Dobj.getElementById("DTRowIdz"+DSelectedRow);
	var ID=""
	if (obj) ID=obj.value;
	var obj=document.getElementById("DSumResultBox");
	if (obj) var encmeth=obj.value;
	if (ID=="") return false;
	var flag=cspRunServerMethod(encmeth,SSID,ID,"1");
	if (flag==0){ location.reload(); return false;}
	alert(t[flag]);return false;	
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var Dobj=document;
	var objtbl=Dobj.getElementById('tDHCPEGDiagnosis');	//取表格元素?名称
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	var obj;
	var rowObj=getRow(eSrc);
	var Row=rowObj.rowIndex;
	obj=Dobj.getElementById("DBSumResult");
	if (Row==DSelectedRow)
	{
		DSelectedRow=0
		//obj.disabled=true;
	}
	else
	{
		DSelectedRow=Row;
		//obj.disabled=false;
	}
}

