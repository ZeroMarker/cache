
//component:DHCPESelectPIADMRecord
//js£ºDHCPESelectPIADMRecord.js
//creator:xueying
//creatDate:20180502

function BodyLoadHandler() {
	var obj;
	var tbl=document.getElementById("tDHCPESelectPIADMRecord");
	if(tbl) tbl.ondblclick=DHC_SelectPat;
}

function DHC_SelectPat(){
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	//alert("selectrow:"+selectrow)
	if (selectrow !=0) {
		var PIADM="";
		
		var obj=document.getElementById("PIBIPAPMINoz"+selectrow);
		if(obj) PatNo=obj.innerText;
		var obj=document.getElementById("idz"+selectrow);
		if(obj) PIADM=obj.value;
		var PAADM=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetPAADMbyPreIADM",PIADM);
		var Flag=""
		if (PAADM!="")
		{
			var Flag=tkMakeServerCall("web.DHCPE.ResultEdit","GetUnAppedItems","",PAADM,"1","0");
		}
		if (Flag!="")
		{
			ConfirmRecPaper_click(); 
		}
		else
		{
		var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","SaveRecPaper",PIADM,"","");
		if (Return!=0)
		{   
		alert(Return);
   		}
   		window.close();
		return true;
		}
		/*
		window.returnValue=PIADM
		  window.close();
			return true;
		//}
		*/
		
	}
	
}
function ConfirmRecPaper_click()
{
  	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEReportDate"+"&RegNo="+PatNo+"&RecLabFlag=1";
	var wwidth=700;
	var wheight=600;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			; 
	 
	var cwin=window.open(lnk,"_blank",nwin);
    
}
document.body.onload = BodyLoadHandler;