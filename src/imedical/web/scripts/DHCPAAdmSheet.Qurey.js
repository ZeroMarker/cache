document.body.onload = BodyLoadHandler;
var m_RowIndex=-1

function BodyLoadHandler()
{
	var obj=document.getElementById("PapmiNo");
	if (obj) obj.onkeydown=PapmiNoEnter;
	var objCopy=document.getElementById("Copy");
	if (objCopy) objCopy.onclick=CopyClick;
	websys_setfocus('PapmiNo');	
}

function SelectRowHandler()	{
	m_RowIndex=selectrow;
	var eSrc=window.event.srcElement;
	//alert("window.name="+window.name);
	var objtbl=document.getElementById('tDHCPAAdmSheet_Qurey');
	if(!objtbl)	{
	   objtbl=document.getElementById('tDHCPAAdmSheet_Qurey0');
	}
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	//alert("selectrow="+selectrow);
	m_RowIndex=selectrow;
}

function SelectRowHandler()	{
	m_RowIndex=selectrow;
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCPAAdmSheet_Qurey');
	if(!objtbl)	{
	   objtbl=document.getElementById('tDHCPAAdmSheet_Qurey0');
	}
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	m_RowIndex=selectrow;
}

function CheckDiagnose(ordertype){
	//if ((PAAdmType=="I")&&(IPOrderPhamacyWithDiagnos!="1")) {return true;}
	//if (OrderPhamacyWithDiagnos!="1"){return true;}
	var MRDiagnoseCount=0;
	var mradm=document.getElementById('mradm').value;
	var GetMRDiagnoseCount=document.getElementById('GetMRDiagnoseCount');
	if ((GetMRDiagnoseCount)&&(mradm!='')) {
		var encmeth=GetMRDiagnoseCount.value;
		//alert("encmeth="+encmeth);
		MRDiagnoseCount=cspRunServerMethod(encmeth,mradm);
	}
	//if ((MRDiagnoseCount==0)&&(ordertype=="R")) {
	if (MRDiagnoseCount==0) {
		if ((t['NO_DIAGNOSE'])&&(t['NO_DIAGNOSE']!="")) {
		alert(t['NO_DIAGNOSE']);}
		return false;
	}
	return true;
}

function CopyClick()
{
		var EpisodeID=document.getElementById("EpisodeID").value;
		var mradm=document.getElementById("mradm").value;
		var CurrentSheetRowId=document.getElementById("CurrentSheetRowId").value;
		if ((CurrentSheetRowId!="")&&(CurrentSheetRowId!=0)){
			alert(t['Already_Sheet']);
			return;
		}
		if (!CheckDiagnose()){
			alert(t['No_Diagnose']);
			return;
		}
		if (m_RowIndex<0){
			alert(t['No_SelectedSheet']);
			return;
		}
		var CopySheetId=document.getElementById("TSheetIDz"+m_RowIndex).value;
		var Parobj=window.opener
		if (!Parobj){
			alert(t['No_Destination']);
			return;
		}
		var ObjSheetRowId=Parobj.document.getElementById("SheetRowId")
		ObjSheetRowId.value=CopySheetId
		var SheetRowId=ObjSheetRowId.value
		var CopySheetRowId=SheetRowId
		//alert("CopySheetRowId="+CopySheetRowId);
		window.opener.location.href="dhcadmsheet.edit.csp?CopySheetRowId="+CopySheetRowId+"&SheetRowId="+""+"&EpisodeID="+EpisodeID+"&mradm="+mradm;	 
		Parobj.document.body.onload
		window.close();	
}

function PapmiNoEnter(e) 
{
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	if ((obj)&&(obj.value!="")&&(key==13)) 
	{
		var obj=document.getElementById("BtnSearch");
		if (obj) 
		{
			getpatbyRegNo();
			obj.focus(); 
		}
	}
}

function getpatbyRegNo()
{
	RegNoobj=document.getElementById('PapmiNo');
    var key=websys_getKey(e);
	if (key==13) {
		if (RegNoobj.value!=""){
			getpatbyregno1(RegNoobj.value)
		}
	}
	
function getpatbyregno1(regno)
{
	if (regno=="") return;
	p1=regno
	
			var getregno=document.getElementById('getpatclass');
		
			if (getregno) {var encmeth=getregno.value} else {var encmeth=''};
				if (cspRunServerMethod(encmeth,'setpatinfo_val','',p1,"","","","")=='1'){
				}
			
			}
}
	
function setpatinfo_val(value)
	{
		var val=value.split("^");
		if (val[0]==""){
			alert("无此登记号的病人!")
			websys_setfocus('PapmiNo');
			return;
			}
		
		RegNoobj.value=val[0];
		websys_setfocus('PapmiNo');
}





