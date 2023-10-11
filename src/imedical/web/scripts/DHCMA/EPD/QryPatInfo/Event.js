//页面Event
function InitPatQryEvent(obj) {
	obj.LoadEvent = function(args){ 
	    $('#gridPatQuery').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	    
		//查询
		$('#btnQuery').on('click', function(){
			obj.PatQuery();
		});
		//科室选择事件
		$HUI.combobox("#cboLoc", {
			onSelect:function(){
				obj.PatQuery();
			}
		});
		//登记号补零 length位数
		var length=10;
		$("#txtPapmiNo").blur(function(){
			var PapmiNo	 = $("#txtPapmiNo").val();
			if(!PapmiNo) return;
			$("#txtPapmiNo").val((Array(length).join('0') + PapmiNo).slice(-length));  
　　	});		
    }
    // 病理浏览
	obj.OpenEMR =function(aEpisodeID,aPatientID) {
		var strUrl = cspUrl+"&PatientID=" + aPatientID+"&EpisodeID="+aEpisodeID + "&2=2";
		//var strUrl = "./emr.record.browse.csp?PatientID=" + aPatientID+"&EpisodeID="+aEpisodeID + "&2=2";
	    websys_showModal({
			url:strUrl,
			title:'病历浏览',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:'98%',
			height:'98%'
		});
	}
	// 打开传染病报告
	obj.btnReportEPD =function(aEpisodeID,aPatientID) {
		var strUrl = "./dhcma.epd.report.csp?1=1"+"&PatientID=" + aPatientID+"&EpisodeID="+aEpisodeID;
	    websys_showModal({
			url:strUrl,
			title:'传染病报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1320,
			height:'98%'
		});
	}
	// 打开食源性疾病报告
	obj.btnReportFBD =function(aEpisodeID,aPatientID) {
		var strUrl = "./dhcma.fbd.report.csp?1=1"+"&PatientID=" + aPatientID+"&EpisodeID="+aEpisodeID;
	    websys_showModal({
			url:strUrl,
			title:'食源性疾病报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1320,
			height:'98%'
		});
	}
	obj.PatQuery = function(){
		var HosID		= $('#cboSSHosp').combobox('getValue')
		var LocID 		= $('#cboLoc').combobox('getValue');
		var DateType	= $('#cboDateType').combobox('getValue')
		var DateFrom 	= $('#DateFrom').datebox('getValue');
		var DateTo 		= $('#DateTo').datebox('getValue');
		var PatName 	= $('#PatName').val();
		var MrNo	 	= $('#txtMrNo').val();
		var PapmiNo	 	= $('#txtPapmiNo').val();
		var RepPlace	= $('#cboRepPlace').combobox('getValue');
		
		if ((DateFrom == '')||(DateTo == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!",'info');
			return;
		}
		if (Common_CompareDate(DateFrom,DateTo)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!",'info');
			return;
		}
		$("#gridPatQuery").datagrid("loading");	
		$cm ({
			ClassName:"DHCMed.EPDService.PatInfoSrv",
			QueryName:"QryPatByDate",
			ResultSetType:"array",
			aHospID:HosID,
			aLocID:LocID,
			aDateType:DateType,
			aDateFrom:DateFrom,
			aDateTo:DateTo,
			aPatName:PatName,
			aMrNo:MrNo,
			aPampiNo:PapmiNo,
			aRepPlace:RepPlace,
			page:1,
			rows:99999
		},function(rs){
			$('#gridPatQuery').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);							
		});
	}

}