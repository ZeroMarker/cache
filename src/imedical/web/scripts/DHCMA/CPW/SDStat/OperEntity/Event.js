
function InitOperWinEvent(obj){
	// 默认加载报表文件
	ReportFrame = document.getElementById("reportFrame");
	ReportFrame.src="../scripts/DHCMA/CPW/SDStat/ItemStat/SDNoDataTips.html"
	//查询按钮
	$("#btnQuery").on('click',function(){
		var aHospID 	= $('#cboHospital').combobox('getValue');
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");		
		var QCID 	 = $("#cboQC").combobox("getValue");
		var Type  = $('input[name=type]:checked').val();
		if (Type==1){
			Item="CM-0-1-4-1"
		}else{
			Item="CM-0-1-3-1"
		}
		if (QCID==""){
			$.messager.alert("错误提示",'请选择选择病种！','info');
			return;
		}
		if ((DateFrom=="")||(DateTo=="")){
			$.messager.alert("错误提示",'请选择开始日期、结束日期！','info');
			return;
		}
		if(Common_CompareDate(DateFrom,DateTo)){
			$.messager.alert("错误提示",'开始日期应小于或等于结束日期！','info');
			return;
		}
		$cm ({
			ClassName:"DHCMA.CPW.SDS.DictionarySrv",
			QueryName:"QryDictByType",	
			aQCID: QCID,
			aVersion: "2", 
			aTypeCode:Item, 
			aIsActive: "1"
		},function(rs){
			if(rs.total==""){
				$.messager.alert("错误提示",'该病种没有手术或诊断，请重新选择','info');
				return;		
			}else{
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCMACPWOperData.raq&aHospID='+aHospID+'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aEntityID='+QCID+'&aType='+Type
				if(!ReportFrame.src){
					ReportFrame.frameElement.src=p_URL;
				}else{
					ReportFrame.src = p_URL;
				}
			}	
		});	

	});
		
}