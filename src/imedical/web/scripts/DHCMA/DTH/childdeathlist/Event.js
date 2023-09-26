//页面Event
function InitChildDeathListEvent(obj){	
    
	obj.LoadEvent = function(args){ 
		//查询
		$('#btnFind').on('click', function(){
			obj.btnFind_click();
		});
		
		//登记号回车查询事件
		$('#txtRegNo').keydown(function (e) {
			var e = e || window.event;
			if (e.keyCode == 13) {
				RegNo=$('#txtRegNo').val().replace(/(^\s*)|(\s*$)/g, "");
				if ($.trim(RegNo)=="") return;
				var Reglength=RegNo.length;
				for(var i=0;i<(10-Reglength);i++)
				{
					RegNo="0"+RegNo;
				}
				$('#txtRegNo').val(RegNo);
			}	
		});
	}
    
	obj.btnFind_click = function() {
		var startDate = $('#txtStartDate').datebox('getValue')
		var endDate = $('#txtEndDate').datebox('getValue')
		if ((startDate == '')||(endDate == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!");
		}
		if (Common_CompareDate(startDate,endDate)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!");
		}
		obj.gridChildDeathReportLoad();
	}
	
	//打开链接
	obj.OpenDeathReport = function(aEpisodeID,aReportID) {
		var strUrl = "./dhcma.dth.report.csp?1=1&EpisodeID="+aEpisodeID+"&ReportID=" + aReportID ;
	    websys_showModal({
			url:strUrl,
			title:'居民死亡医学证明（推断）书',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			closable:false,
			width:1320,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			dataRow:{RowID:aReportID},
			onBeforeClose:function(){
				obj.gridChildDeathReportLoad ();  //刷新
			} 
		});
	}
	obj.gridChildDeathReport_click = function(rowData) {
		var ReportID=rowData["ReportID"];
        var PatientID=rowData["PatientID"];
        var EpisodeID=rowData["Paadm"];
       
        var strUrl = "./dhcma.dth.report.csp?1=1&EpisodeID="+EpisodeID+"&ReportID=" + ReportID ;
	    websys_showModal({
			url:strUrl,
			title:'居民死亡医学证明（推断）书',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			closable:false,
			width:1320,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			dataRow:{RowID:rowData["ReportID"]},
			onBeforeClose:function(){
				obj.gridChildDeathReportLoad ();  //刷新
			} 
		});
	}
	
	obj.gridChildDeathReportLoad = function(){	
		obj.gridChildDeathReport.load({
			ClassName:"DHCMed.DTHService.ReportChildSrv",
			QueryName:"QryDeathPatients",
			aDateType: $('#cboDateType').combobox('getValue'), 			
			aDateFrom: $('#txtStartDate').datebox('getValue'), 
			aDateTo: $('#txtEndDate').datebox('getValue'), 
			aLocID: $('#cboRepLoc').combobox('getValue'),
			aHospID:$('#cboSSHosp').combobox('getValue'),   
			aExamConts: obj.GetExamConditions(),
			aExamSepeare: "^"
	    });
    }
	
}