
//名称	DHCPESelectPIADMRecord.js
//组件  DHCPESelectPIADMRecord
//功能	收表-选择就诊记录
//创建	2018.09.13
//创建人  xy

function BodyLoadHandler() {
	var obj;
	
}

//双击列表元素hisui
function DblClickRowHandler(rowIndex,rowData)
{
	if (rowData.id!=""){
	
		var PatNo=rowData.PIBIPAPMINo;
		var PIADM=rowData.id;
		var PAADM=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetPAADMbyPreIADM",PIADM);
		var Flag=""
		if (PAADM!="")
		{
			var Flag=tkMakeServerCall("web.DHCPE.ResultEdit","GetUnAppedItems","",PAADM,"1","0");
		}
		
		ConfirmRecPaper_click(PatNo,PAADM); 
	}
}
/*
function DblClickRowHandler(rowIndex,rowData)
{
	if (rowData.id!=""){
	
		var PatNo=rowData.PIBIPAPMINo;
		var PIADM=rowData.id;
		var PAADM=tkMakeServerCall("web.DHCPE.DHCPEIAdm","GetPAADMbyPreIADM",PIADM);
		var Flag=""
		if (PAADM!="")
		{
			var Flag=tkMakeServerCall("web.DHCPE.ResultEdit","GetUnAppedItems","",PAADM,"1","0");
		}
		//alert("Flag:"+Flag)
		if (Flag!="")
		{
			
			ConfirmRecPaper_click(PatNo); 
		}
		else
		{
		var Return=tkMakeServerCall("web.DHCPE.DHCPEIAdm","SaveRecPaper",PIADM,"","");
		//alert("Return:"+Return)
		if (Return!=0){   alert(Return); }
   		window.close();
		return true;
	  }
	}
}
*/
/*
function ConfirmRecPaper_click(PatNo)
{

  	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEReportDate"+"&RegNo="+PatNo+"&RecLabFlag=1";
	var wwidth=1000;
	var wheight=600;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			; 
	 
	var cwin=window.open(lnk,"_blank",nwin);   
}
*/

function ConfirmRecPaper_click(PatNo,PAADM)
{

  	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEReportDate"+"&RegNo="+PatNo+"&RecLabFlag=1"+"&PAADM="+PAADM;
	websys_lu(lnk,false,'width=1280,height=550,hisui=true,title=收表详情')
}

document.body.onload = BodyLoadHandler;