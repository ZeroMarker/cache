
function InitItemStatWinEvent(obj){
	// 默认加载报表文件
	ReportFrame = document.getElementById("reportFrame");
	obj.InitSearch=function(){
		$('#sQuarter').hide();
		$('#sDateFrom').hide();
		$('#sDateTo').hide();
		}
	//病种链接
	obj.LoadItemSta=function(QCEntiyID,QCEntiyDesc,QCEntityAbbrev){
			obj.EntityID=QCEntiyID
			obj.EntiyDesc=QCEntiyDesc
			obj.EntityAbbrev=QCEntityAbbrev
			$HUI.combobox('#cboIndexSta',
			    {
					url:$URL+'?ClassName=DHCMA.CPW.SDS.QCIndexSrv&QueryName=QryEntityIndex&ResultSetType=Array'+'&aParRef='+obj.EntityID,
					valueField:'RaqName',
					textField:'BTDesc',
					editable:false,
					groupField:'IndexCat'	  
			    }) 
			$HUI.dialog('#winQCEntity').close();
			ReportFrame.src="../scripts/DHCMA/CPW/SDStat/ItemStat/SDNoDataTips.html"
		}
	//查询按钮
	$("#btnQuery").on('click',function(){
		var IndexStaUrl=$("#cboIndexSta").combobox("getValue");
		if (IndexStaUrl==""){
				$.messager.alert("错误提示",'请选择统计指标！','info');
				return;
			}
		
		var HospID 	 = $("#cboHospital").combobox("getValue");
		var DateType = $("#cboDateType").combobox("getValue");
		var Year 	 = $("#cboYear").combobox("getValue");
		var Quarter  = $("#cboQuarter").combobox("getValue");
		
	    var DateFrom = $("#DateFrom").datebox("getValue");
		var DateTo 	 = $("#DateTo").datebox("getValue");		
		var LocID 	 = $("#cboLocation").combobox("getValue");
		var QCID 	 = obj.EntityID
		var QCDesc   = obj.EntityDesc
		var QCAbbrev = obj.EntityAbbrev
		if ((DateFrom!="")&&(Common_CompareDate(DateFrom,DateTo))){
			$.messager.alert("错误提示",'开始日期应小于或等于结束日期！','info');
			return;
		}
		p_URL = 'dhccpmrunqianreport.csp?reportName='+IndexStaUrl+'&aHospID='+HospID+'&aStaType=' + DateType +'&ayear=' + Year +'&aQuarter=' + Quarter +'&aDateFrom=' + DateFrom +'&aDateTo='+ DateTo +'&aLocID='+ LocID+'&aQCEntityID='+QCID+'&EntityDesc='+QCDesc+'&aQCAbbrev='+QCAbbrev
		ReportFrame.src = p_URL;
	});
	//病种展现
	$("#btnShowEntiy").on('click',function(){
		$HUI.dialog('#winQCEntity').open();	
	});
}