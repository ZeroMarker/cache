//DHCPEOccuOtherDiseaseHistory.js\
//DHCPEOccuOtherDiseaseHistory

var CurrentSel=0
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }

	

	iniForm();


}

function Update_click() {
	
	//alert(8)
	var obj=document.getElementById("DHis");
	if (obj){var DHis=obj.value; } 
    
	var obj=document.getElementById("DHome");
	if (obj){var DHome=obj.value; } 
	
	var obj=document.getElementById("FirstMenstrual");
	if (obj){var FirstMenstrual=obj.value; } 
	
	var obj=document.getElementById("Period");
	if (obj){var Period=obj.value; } 
	
	var obj=document.getElementById("Cycle");
	if (obj){var Cycle=obj.value; } 
	
	var obj=document.getElementById("MenoParseAge");
	if (obj){var MenoParseAge=obj.value; } 
	
	var obj=document.getElementById("NowChild");
	if (obj){var NowChild=obj.value; } 
	
	var obj=document.getElementById("Abortion");
	if (obj){var Abortion=obj.value; } 
	
	var obj=document.getElementById("Prematurebirth");
	if (obj){var Prematurebirth=obj.value; } 
	
	var obj=document.getElementById("DeadBirth");
	if (obj){var DeadBirth=obj.value; } 
	
	var obj=document.getElementById("AbnormalFetal");
	if (obj){var AbnormalFetal=obj.value; } 
	
	var obj=document.getElementById("SmokeHis");
	if (obj){var SmokeHis=obj.value; } 
	
	var obj=document.getElementById("AlcolHis");
	if (obj){var AlcolHis=obj.value; } 
	
	var obj=document.getElementById("SmokeNo");
	if (obj){var SmokeNo=obj.value; } 
	
	var obj=document.getElementById("SmokeAge");
	if (obj){var SmokeAge=obj.value; } 
	
	var obj=document.getElementById("AlcolNo");
	if (obj){var AlcolNo=obj.value; } 
	
	var obj=document.getElementById("Alcol");
	if (obj){var Alcol=obj.value; } 
	
	var obj=document.getElementById("PreIADM");
	if (obj){var iPreIADM=obj.value; } 
	//alert(9)
	var Instring1=trim(FirstMenstrual)
				+"^"+trim(Period)
				+"^"+trim(Cycle)
				+"^"+trim(MenoParseAge)
				;
	var info1=tkMakeServerCall("web.DHCPE.OccupationalDisease","GetListDataByData",Instring1);
	//alert(7)
	var Instring3=trim(SmokeHis)
				+"^"+trim(SmokeNo)
				+"^"+trim(SmokeAge)
				;
				
	var info3=tkMakeServerCall("web.DHCPE.OccupationalDisease","GetListDataByData",Instring3);
	
	var Instring4=trim(AlcolHis)
				+"^"+trim(AlcolNo)
				+"^"+trim(Alcol)
				;
	var info4=tkMakeServerCall("web.DHCPE.OccupationalDisease","GetListDataByData",Instring4);
	
	
	var Instring2=trim(NowChild)
				+"^"+trim(Abortion)
				+"^"+trim(Prematurebirth)
				+"^"+trim(DeadBirth)
				+"^"+trim(AbnormalFetal)
				;
	var info2=tkMakeServerCall("web.DHCPE.OccupationalDisease","GetListDataByData",Instring2);
	
	var Instring1=trim(FirstMenstrual)
				+"^"+trim(Period)
				+"^"+trim(Cycle)
				+"^"+trim(MenoParseAge)
				;
	var info1=tkMakeServerCall("web.DHCPE.OccupationalDisease","GetListDataByData",Instring1);
	
	
	
	var Instring=trim(DHis)
				+"^"+trim(DHome)
				+"^"+trim(info2)
				+"^"+trim(info3)
				+"^"+trim(info4)
				+"^"+trim(info1)
				; 
	
	//GetListDataByData
	//alert("Instring"+Instring)
	var info=tkMakeServerCall("web.DHCPE.OccupationalDisease","SaveDiseaseHistory",iPreIADM,Instring);
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
	var obj=document.getElementById("PreIADM");
	if (obj){var iPreIADM=obj.value; } 
	var Data=tkMakeServerCall("web.DHCPE.OccupationalDisease","GetHisData",iPreIADM);
	//alert(Data)
	if (Data=="无信息") {return false;}
	var Datas=Data.split("^");
	
	var obj=document.getElementById("DHis");
	if (obj){obj.value=Datas[0]; } 
	var obj=document.getElementById("DHome");
	if (obj){obj.value=Datas[1]; } 
	var obj=document.getElementById("NowChild");
	if (obj){obj.value=Datas[2]; } 
	var obj=document.getElementById("Abortion");
	if (obj){obj.value=Datas[3]; } 
	var obj=document.getElementById("Prematurebirth");
	if (obj){obj.value=Datas[4]; } 
	var obj=document.getElementById("DeadBirth");
	if (obj){obj.value=Datas[5]; } 
	var obj=document.getElementById("AbnormalFetal");
	if (obj){obj.value=Datas[6]; } 
	var obj=document.getElementById("SmokeHis");
	if (obj){obj.value=Datas[7]; } 
	var obj=document.getElementById("SmokeNo");
	if (obj){obj.value=Datas[8]; } 
	var obj=document.getElementById("SmokeAge");
	if (obj){obj.value=Datas[9]; } 
	var obj=document.getElementById("AlcolHis");
	if (obj){obj.value=Datas[10]; } 
	var obj=document.getElementById("AlcolNo");
	if (obj){obj.value=Datas[11]; } 
	var obj=document.getElementById("Alcol");
	if (obj){obj.value=Datas[12]; } 
	var obj=document.getElementById("FirstMenstrual");
	if (obj){obj.value=Datas[13]; } 
	var obj=document.getElementById("Period");
	if (obj){obj.value=Datas[14]; } 
	var obj=document.getElementById("Cycle");
	if (obj){obj.value=Datas[15]; } 
	var obj=document.getElementById("MenoParseAge");
	if (obj){obj.value=Datas[16]; } 
	return true;
	
}
function ShowCurRecord(CurRecord) {
	var selectrow=CurRecord;
	
	FromTableToItem("StartDate","TStartDate",selectrow);  
	
	FromTableToItem("EndDate","TEndDate",selectrow);  
	
	FromTableToItem("WorkPlace","TWorkPlace",selectrow);  
	
	FromTableToItem("WorkShop","TWorkShop",selectrow);  
	
	FromTableToItem("WorkTeam","TWorkTeam",selectrow);
	
	FromTableToItem("Typeofwork","TWorkType",selectrow);
	
	FromTableToItem("HarmfulFactor","THarmfulFactor",selectrow);
 
 	FromTableToItem("ProtectiveMeasure","TProtectiveMeasure",selectrow);
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