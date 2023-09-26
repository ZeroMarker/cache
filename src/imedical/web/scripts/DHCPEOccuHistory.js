//DHCPEOccuHistory.js

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
	
	var iStartDate="",iEndDate="",iWorkPlace="",iWorkTeam="",iWorkType="";
	var iWorkShop="", iHarmfulFactor="", iProtectiveMeasure="",iPreIADM="";
	
	var obj=document.getElementById("StartDate");
	if (obj){iStartDate=obj.value; } 
    
	var obj=document.getElementById("EndDate");
	if (obj){iEndDate=obj.value; } 

	var obj=document.getElementById("WorkPlace");
	if (obj){iWorkPlace=obj.value; } 

	var obj=document.getElementById("WorkShop");
	if (obj){iWorkShop=obj.value; } 

 	var obj=document.getElementById("WorkTeam");
	if (obj){iWorkTeam=obj.value; } 
	
	var obj=document.getElementById("Typeofwork");
	if (obj){iWorkType=obj.value; } 
	
	var obj=document.getElementById("HarmfulFactor");
	if (obj){iHarmfulFactor=obj.value; } 
	
	var obj=document.getElementById("ProtectiveMeasure");
	if (obj){iProtectiveMeasure=obj.value; } 
	
	var obj=document.getElementById("PreIADM");
	if (obj){iPreIADM=obj.value; } 
	
	var Instring=trim(iStartDate)
				+"^"+trim(iEndDate)
				+"^"+trim(iWorkPlace)
				+"^"+trim(iWorkShop)
				+"^"+trim(iWorkTeam)
				+"^"+trim(iWorkType)
				+"^"+trim(iHarmfulFactor)
				+"^"+trim(iProtectiveMeasure) 
				; 
	var oldinfo=tkMakeServerCall("web.DHCPE.OccupationalDisease","GetOccuHistory",iPreIADM);
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
	
	var info=tkMakeServerCall("web.DHCPE.OccupationalDisease","SaveOccuHistory",iPreIADM,NowInfo);
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
	var iStartDate="",iEndDate="",iWorkPlace="",iWorkTeam="",iWorkType="";
	var iWorkShop="", iHarmfulFactor="", iProtectiveMeasure="",iPreIADM="";
	
	var obj=document.getElementById("StartDate");
	if (obj){iStartDate=obj.value; } 
	 var iStartDate=tkMakeServerCall("web.DHCPE.OccupationalDisease","DateChangeNum",iStartDate);
    
	var obj=document.getElementById("EndDate");
	if (obj){iEndDate=obj.value; }
	var iEndDate=tkMakeServerCall("web.DHCPE.OccupationalDisease","DateChangeNum",iEndDate);

	var obj=document.getElementById("WorkPlace");
	if (obj){iWorkPlace=obj.value; } 

	var obj=document.getElementById("WorkShop");
	if (obj){iWorkShop=obj.value; } 

 	var obj=document.getElementById("WorkTeam");
	if (obj){iWorkTeam=obj.value; } 
	
	var obj=document.getElementById("Typeofwork");
	if (obj){iWorkType=obj.value; } 
	
	var obj=document.getElementById("HarmfulFactor");
	if (obj){iHarmfulFactor=obj.value; } 
	
	var obj=document.getElementById("ProtectiveMeasure");
	if (obj){iProtectiveMeasure=obj.value; } 
	
	var obj=document.getElementById("PreIADM");
	if (obj){iPreIADM=obj.value; } 
	
	var Instring=trim(iStartDate)
				+"^"+trim(iEndDate)
				+"^"+trim(iWorkPlace)
				+"^"+trim(iWorkShop)
				+"^"+trim(iWorkTeam)
				+"^"+trim(iWorkType)
				+"^"+trim(iHarmfulFactor)
				+"^"+trim(iProtectiveMeasure) 
				; 
	var oldinfo=tkMakeServerCall("web.DHCPE.OccupationalDisease","GetOccuHistory",iPreIADM);
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
	
	var info=tkMakeServerCall("web.DHCPE.OccupationalDisease","SaveOccuHistory",iPreIADM,NowInfo);
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
	
	FromTableToItem("StartDate","TStartDate",selectrow);  
	
	FromTableToItem("EndDate","TEndDate",selectrow);  
	
	FromTableToItem("WorkPlace","TWorkPlace",selectrow);  
	
	FromTableToItem("WorkShop","TWorkShop",selectrow);  
	
	FromTableToItem("WorkTeam","TWorkTeam",selectrow);
	
	FromTableToItem("Typeofwork","TWorkTypeID",selectrow);
	
	FromTableToItem("HarmfulFactor","THarmfulFactor",selectrow);
 
 	FromTableToItem("ProtectiveMeasure","TProtectiveMeasureID",selectrow);
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

	obj=document.getElementById("StartDate");
	obj.value="";

	obj=document.getElementById("EndDate");
	obj.value="";

	obj=document.getElementById("WorkPlace");
	obj.value="";

	obj=document.getElementById("WorkShop");
	obj.value="";

	obj=document.getElementById("WorkTeam");
	obj.value="";
	
	obj=document.getElementById("Typeofwork");
	obj.value="";
	
	obj=document.getElementById("HarmfulFactor");
	obj.value="";
	
	obj=document.getElementById("ProtectiveMeasure");
	obj.value="";
}

document.body.onload = BodyLoadHandler;