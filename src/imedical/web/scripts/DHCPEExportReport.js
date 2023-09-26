
/// DHCPEExportReport.js, 对于文件  dhcpepatresulthistory.csp

function SaveData()
{
	var ADMStr="",GSCID="",GSCDetail=""
	var obj=document.getElementById("ADMStr")
	if(obj) {ADMStr=obj.value;}
	var obj=document.getElementById("GSCID")
	if(obj) {GSCID=obj.value;}
	var obj=document.getElementById("GSCDetail")
	if(obj) {GSCDetail=obj.value;}
	var GSCId=tkMakeServerCall("web.DHCPE.ResultContrast","UpdateGSCDetail",GSCID,GSCDetail,ADMStr)
	$.messager.alert("提示", "保存成功！", "info");
}

function LisHistory_click(e)
{
	var admstr=e.id;
	var IADMStr=admstr.split("$")[1];
	var lnk="dhcpelisresulthistory.ext.csp?AdmId="+IADMStr;
	websys_lu(lnk,false,'width=1000,height=800,hisui=true,title=化验对比');
	return true;
	
}

function ShowResultHistory(e)
{
	var IADMStr=e.id;
	var lnk="dhcpepatresulthistory.csp?AdmId="+IADMStr;
	
	websys_lu(lnk,false,'width=1300,height=800,hisui=true,title=结果对比')
	
	return true;
}
function PrintData()
{
	var ADMStr=""
	var obj=document.getElementById("ADMStr")
	if(obj) {ADMStr=obj.value;}
	
	
	var lnk="dhcpeireport.constrast.csp?PatientID="+ADMStr;
	
	//var ret=window.showModalDialog(lnk, "", "dialogwidth:800px;dialogheight:600px;center:1"); 
	
	PEPrintHistoryReport("P",ADMStr,"");
	return true;
}
var init = function(){
	
	
	$("#Save").click(function() {
			
			SaveData();	
			
        });
	$("#Print").click(function() {
			
			PrintData();	
			
        });
	
}

$(init);