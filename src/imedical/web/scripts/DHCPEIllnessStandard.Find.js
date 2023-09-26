
//DHCPEIllnessStandard.Find.js
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("Find");
	if (obj) obj.onclick=Find_click;
	
}
function Find_click()
{
	var obj;
	var iCode="",iDiagnoseConclusion="",iAlias=""
	obj=document.getElementById("Code");
	if (obj) iCode=obj.value;
	obj=document.getElementById("DiagnoseConclusion");
	if (obj) iDiagnoseConclusion=obj.value;
	obj=document.getElementById("Alias");
	if (obj) iAlias=obj.value;
	/*
	var width=screen.width-300;
	var height=screen.height-200;
	var nwin='toolbar=no,alwaysLowered=yes,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+width+',height='+height+',left=30,top=5';
 	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIllnessStandard.List"
			+"&Code="+iCode
			+"&DiagnoseConclusion="+iDiagnoseConclusion
			;
	open(lnk,"_blank",nwin);	
	*/
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIllnessStandard.Find"
			+"&Code="+iCode
			+"&DiagnoseConclusion="+iDiagnoseConclusion
			+"&Alias="+iAlias
			;
			
	  location.href=lnk; 

}


document.body.onload = BodyLoadHandler;