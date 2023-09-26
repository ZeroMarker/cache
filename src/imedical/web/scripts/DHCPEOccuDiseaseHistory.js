//DHCPEOccuDiseaseHistory.js

var CurrentSel=0
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }

	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	
	iniForm();


}

function Delete_click()
{
	var iDiseaseDesc="",iDiagnosisDate="",iDiagnosisPlace="",iIsRecovery="",iPreIADM="";
	
	var obj=document.getElementById("DiseaseDesc");
	if (obj){iDiseaseDesc=obj.value; } 
    
	var obj=document.getElementById("DiagnosisDate");
	if (obj){iDiagnosisDate=obj.value; } 

	var obj=document.getElementById("DiagnosisPlace");
	if (obj){iDiagnosisPlace=obj.value; } 

	var obj=document.getElementById("IsRecovery");
	
	if (obj)
	{
		
		if (obj.checked){ iIsRecovery="1"; }
		else{ iIsRecovery="0"; }
		
	}
	
	var obj=document.getElementById("PreIADM");
	if (obj){iPreIADM=obj.value; } 
	var Instring=trim(iDiseaseDesc)
				+"^"+trim(iDiagnosisDate)
				+"^"+trim(iDiagnosisPlace)
				+"^"+trim(iIsRecovery)
				; 
	var oldinfo=tkMakeServerCall("web.DHCPE.OccupationalDisease","GetOccuDiseaseHistory",iPreIADM);
	var oldinfostr=oldinfo.split("$")
	if(CurrentSel==0)
	{
		NowInfo=oldinfo
		
	}
	else
	{
		oldinfostr[CurrentSel-1]=""
		
		NowInfo=oldinfostr.join("$")
	}
	
	
	var info=tkMakeServerCall("web.DHCPE.OccupationalDisease","SaveOccuDiseaseHistory",iPreIADM,NowInfo);
	var infoData=info.split("^");
	
	if(infoData[0]<=0)
	{alert(info);
	return;}
	else
	{
	//刷新页面
	location.reload(); 
	}

	
	}
function Update_click() {
	var iDiseaseDesc="",iDiagnosisDate="",iDiagnosisPlace="",iIsRecovery="",iPreIADM="";
	
	var obj=document.getElementById("DiseaseDesc");
	if (obj){iDiseaseDesc=obj.value; } 
    
	var obj=document.getElementById("DiagnosisDate");
	if (obj){iDiagnosisDate=obj.value; } 

	var obj=document.getElementById("DiagnosisPlace");
	if (obj){iDiagnosisPlace=obj.value; } 

	var obj=document.getElementById("IsRecovery");
	
	if (obj)
	{
		
		if (obj.checked){ iIsRecovery="1"; }
		else{ iIsRecovery="0"; }
		
	}
	
	var obj=document.getElementById("PreIADM");
	if (obj){iPreIADM=obj.value; } 
	var Instring=trim(iDiseaseDesc)
				+"^"+trim(iDiagnosisDate)
				+"^"+trim(iDiagnosisPlace)
				+"^"+trim(iIsRecovery)
				; 
	var oldinfo=tkMakeServerCall("web.DHCPE.OccupationalDisease","GetOccuDiseaseHistory",iPreIADM);
	var oldinfostr=oldinfo.split("$")
	if(CurrentSel==0)
	{
		NowInfo=oldinfo+"$"+Instring
		
	}
	else
	{
		oldinfostr[CurrentSel-1]=Instring
		
		NowInfo=oldinfostr.join("$")
	}
	
	
	var info=tkMakeServerCall("web.DHCPE.OccupationalDisease","SaveOccuDiseaseHistory",iPreIADM,NowInfo);
	var infoData=info.split("^");
	
	if(infoData[0]<=0)
	{alert(info);
	return;}
	else
	{
	//刷新页面
	location.reload(); 
	}

}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

function iniForm(){
	Clear_click();
	
}
function ShowCurRecord(CurRecord) {
	var selectrow=CurRecord;
	
	FromTableToItem("DiseaseDesc","TDiseaseDesc",selectrow);  
	
	FromTableToItem("DiagnosisDate","TDiagnosisDate",selectrow);  
	
	FromTableToItem("DiagnosisPlace","TDiagnosisPlace",selectrow);  
	
	FromTableToItem("IsRecovery","TIsRecovery",selectrow);  
	
}
function FromTableToItem(Dobj,Sobj,selectrow) {

	var SelRowObj;
	var obj;
	var LabelValue="";

	SelRowObj=document.getElementById(Sobj+'z'+selectrow);
	if (!(SelRowObj)) { return null; }
	LabelValue=SelRowObj.tagName.toUpperCase();
   	obj=document.getElementById(Dobj);
   	if (!(obj)) { return null; }
   	
   	if ("LABEL"==LabelValue) {		
		obj.value=trim(SelRowObj.innerText);
		return obj;
	}
	
	if ("INPUT"==LabelValue) {
		LabelValue=SelRowObj.type.toUpperCase();
		
		if ("CHECKBOX"==LabelValue) {
			obj.checked=SelRowObj.checked;
			return obj;
		}
		
		if ("HIDDEN"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}
		
		if ("TEXT"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}

		obj.value=SelRowObj.type+trim(SelRowObj.value);
		return obj;
	}

}
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	var tForm="";
	
	var obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);	
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel)
	{	    
	    Clear_click();
	    CurrentSel=0;
	    return;
	}

	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);
	
}
function Clear_click() {
	var obj;

	var obj=document.getElementById("DiseaseDesc");
	obj.value="";
    
	var obj=document.getElementById("DiagnosisDate");
	obj.value="";

	var obj=document.getElementById("DiagnosisPlace");
	obj.value="";

	var obj=document.getElementById("IsRecovery");
	obj.checked=false;
}

document.body.onload = BodyLoadHandler;