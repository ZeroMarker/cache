/// DHCPEResultContrast.IADM
/// 
/// 
/// 
/// 
/// 
var TFORM="tDHCPEResultContrast_IADM";
function BodyLoadHandler()
{
	var obj;
	
	//查询按钮
	obj=document.getElementById("BQuery");
	if (obj) { obj.onclick=Find_Click; }
	
	obj=document.getElementById("RegNo");
	if (obj){ obj.onkeydown=RegNo_KeyDown;}
	
	obj=document.getElementById("PatName");
  if (obj){ obj.onkeydown=RegNo_KeyDown;}
	
	//iniForm();
		obj=document.getElementById("BReaultContrast");
	if (obj) { obj.onclick=BReaultContrast_Click; }

}
	
function RegNo_KeyDown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		Find_Click();
	}
}

function iniForm(){
	var ID=""
	var obj;
	obj=document.getElementById('TFORM');
	if (obj) { TFORM=obj.value; }	
	obj=document.getElementById('ID');	
	if (obj && ""!=obj.value) { 
		ID=obj.value;
		FindPatDetail(ID);
	}	
	websys_setfocus('Code');
}
function Find_Click() {
	var obj;
	var TFORM="";
	var iRegNo="", iPatName="", iDateFrom="", iDateTo="", iReportStatus="";
	
	/*obj=document.getElementById("TFORM");
	if (obj && ""!=obj.value) { TFORM=obj.value; }
	else { return; }*/
	
	obj=document.getElementById("RegNo");
	if (obj && ""!=obj.value) { iRegNo=obj.value; }
	
	obj=document.getElementById("PatName");
	if (obj && ""!=obj.value) { iPatName=obj.value; }
	
	obj=document.getElementById("DateFrom");
	if (obj && ""!=obj.value) { iDateFrom=obj.value; }
	
	obj=document.getElementById("DateTo");
	if (obj && ""!=obj.value) { iDateTo=obj.value; }
	
	obj=document.getElementById("ReportStatus")
	if (obj && ""!=obj.value) { iReportStatus=obj.value; }
	
	//iReportStatus="^NA^A^P^S^"; //测试
	
	if ((""==iRegNo)&&(""==iPatName)&&(""==iDateFrom)&&(""==iDateTo)) { return; }
	
	//var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+TFORM
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEResultContrast.IADM"
			+"&RegNo="+iRegNo
			+"&PatName="+iPatName
			+"&DateFrom="+iDateFrom
			+"&DateTo="+iDateTo
			+"&ReportStatus="+iReportStatus
			;
		
    location.href=lnk
				
}

function BReaultContrast_Click()
{
	var ShowAbnormal="N",DateFrom="",DateTo="",RegNo="";
	var obj;
	//var obj=document.getElementById("ShowAbnormal");
	//if ((obj)&&(obj.checked)) { ShowAbnormal="Y"; }
	var obj=document.getElementById("DateFrom");
	if (obj) { DateFrom=obj.value; }
	var obj=document.getElementById("DateTo");
	if (obj) { DateTo=obj.value; }
 	var tbl=document.getElementById(TFORM);	//取表格元素?名称

	var row=tbl.rows.length;
	var IADM="";
	var IADMStr=""
    for (var iLLoop=1;iLLoop<row;iLLoop++) {
		obj=document.getElementById('RPT_Select'+'z'+iLLoop);
		if (obj && obj.checked) 
		{
	  
		var obj=document.getElementById("RPT_PAADM_DRz"+iLLoop);
		if(obj){IADM=obj.value}
		if (IADMStr==""){IADMStr=IADM}
		else {IADMStr=IADMStr+"^"+IADM}
	    var obj=document.getElementById("RPT_RegNoz"+iLLoop);
	   	if(obj){RegNo=obj.innerText}
	   
		}
    }
    if (IADMStr==""){alert("请选择对比的就诊记录!");return false;}
	//"&AdmId="_rs.GetDataByName("RPT_PAADM_DR")_"&RegNo="_rs.GetDataByName("RPT_RegNo")_"&DateFrom="_%request.Get("DateFrom")_"&DateTo="_%request.Get("DateTo")
	var lnk="dhcpepatresulthistory.csp?AdmId="+IADMStr+"&RegNo="+RegNo+"&DateFrom="+DateFrom+"&DateTo="+DateTo+"&ShowAbnormal="+ShowAbnormal;
	var wwidth=800;
	var wheight=500;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = (screen.height - wheight) / 2;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	
	var cwin=window.open(lnk,"_blank",nwin)	
	
	return true;
}
document.body.onload = BodyLoadHandler;
