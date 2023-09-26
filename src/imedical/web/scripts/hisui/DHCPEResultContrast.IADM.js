
//名称	DHCPEResultContrast.IADM.js
//功能	结果对比
//组件	DHCPEResultContrast.IADM	
//创建	2018.09.29
//创建人  xy

function BodyLoadHandler()
{
	var obj;
	
	//查询
	obj=document.getElementById("BQuery");
	if (obj) { obj.onclick=Find_Click; }
	
	obj=document.getElementById("RegNo");
	if (obj){ obj.onkeydown=RegNo_KeyDown;}
	
	obj=document.getElementById("PatName");
 	 if (obj){ obj.onkeydown=RegNo_KeyDown;}
	
	
	obj=document.getElementById("BReaultContrast");
	if (obj) { obj.onclick=BReaultContrast_Click; }
	
	obj=document.getElementById("BResultContrastList");
	if (obj) { obj.onclick=BResultContrastList_Click; }
	
}

function RegNo_KeyDown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		Find_Click();
	}
}


function Find_Click() {
	
	
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	iRegNo=getValueById("RegNo");
	if (iRegNo.length<RegNoLength&&iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}
	
    var iPatName=getValueById("PatName");
	var iDateFrom=getValueById("DateFrom");
	var iDateTo=getValueById("DateTo");
	var iReportStatus=getValueById("ReportStatus");
	
	if ((""==iRegNo)&&(""==iPatName)&&(""==iDateFrom)&&(""==iDateTo)) { return; }
	
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPEResultContrast.IADM"
			+"&RegNo="+iRegNo
			+"&PatName="+iPatName
			+"&DateFrom="+iDateFrom
			+"&DateTo="+iDateTo
			+"&ReportStatus="+iReportStatus
			;
		
		//alert(lnk)
    location.href=lnk
				
}

function BReaultContrast_Click()
{
	var ShowAbnormal="N";
	var IADM="";
	var IADMStr=""
	
	var DateFrom=getValueById("DateFrom");
	var DateTo=getValueById("DateTo");
	
	var objtbl = $("#tDHCPEResultContrast_IADM").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++)
	{
		var TSelect=getCmpColumnValue(i,"RPT_Select","DHCPEResultContrast_IADM")
	    if (TSelect=="1"){
		     var IADM=objtbl[i].RPT_PAADM_DR;
		     if (IADMStr==""){IADMStr=IADM;}
			 else {IADMStr=IADMStr+"^"+IADM;}
			 var RegNo=objtbl[i].RPT_RegNo;		   
	    } 
	}
	if(IADMStr.split("^").length>3){
	     $.messager.alert("提示","就诊记录不能超过三次","info");
    	return false;
    }

    if (IADMStr==""){
	    $.messager.alert("提示","请选择对比的就诊记录","info");
    	return false;
    	}
	var lnk="dhcpepatresulthistory.csp?AdmId="+IADMStr+"&RegNo="+RegNo+"&DateFrom="+DateFrom+"&DateTo="+DateTo+"&ShowAbnormal="+ShowAbnormal;
	//var lnk="dhcpepatresulthistorynew.hisui.csp?AdmId="+IADMStr+"&RegNo="+RegNo+"&DateFrom="+DateFrom+"&DateTo="+DateTo+"&ShowAbnormal="+ShowAbnormal;
	/*
	var wwidth=800;
	var wheight=650;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)
	*/
	websys_lu(lnk,false,'width=1300,height=800,hisui=true,title=结果对比')
	
	return true;
}

function BResultContrastList_Click()
{
	
	var RegNo=getValueById("RegNo");
	
	var lnk="dhcpepatresulthistorylist.csp?&RegNo="+RegNo;
	
	websys_lu(lnk,false,'width=1300,height=800,hisui=true,title=对比列表')
	
	return true;
	
	
}

document.body.onload = BodyLoadHandler;
