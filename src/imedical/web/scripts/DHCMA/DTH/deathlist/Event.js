//页面Event
function InitPatientAdmEvent(obj){	
    
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
		var startDate = $('#txtDateFrom').datebox('getValue')
		var endDate = $('#txtDateTo').datebox('getValue')
		if ((startDate == '')||(endDate == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!");
		}
		if (Common_CompareDate(startDate,endDate)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!");
		}
		obj.gridDeathPatientLoad();
	}
	//打开链接
	obj.OpenDeathReport = function(aReportID,aEpisodeID,aLocID) {
		var strUrl = "./dhcma.dth.report.csp?1=1&EpisodeID="+aEpisodeID+"&CTLocID="+aLocID+"&ReportID="+aReportID ;
	    websys_showModal({
			url:strUrl,
			title:'居民死亡医学证明（推断）书',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			closable:false,
			width:1320,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.gridDeathPatientLoad();  //刷新
			} 
		});
	}
	obj.gridDeathPatient_click = function(rowData) {
	
		var ReportID  = rowData["ReportID"];
        var PatientID = rowData["PatientID"];
        var EpisodeID = rowData["Paadm"];
       
        var strUrl = "./dhcma.dth.report.csp?1=1&EpisodeID="+EpisodeID+"&ReportID=" + ReportID ;
	    websys_showModal({
			url:strUrl,
			title:'居民死亡医学证明（推断）书',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			closable:false,
			width:1320,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.gridDeathPatientLoad();  //刷新
			} 
		});
	}
	
	obj.gridDeathPatientLoad = function(){	
		obj.gridDeathPatient.load({
			ClassName:"DHCMed.DTHService.ReportSrv",
			QueryName:"QryDeathPatients",
			argDateFrom: $('#txtDateFrom').datebox('getValue'), 
			argDateTo: $('#txtDateTo').datebox('getValue'), 
			arglocId: $('#cboRepLoc').combobox('getValue'),
			hospId:$('#cboSSHosp').combobox('getValue'),   
			argExamConts: obj.GetExamConditions(),
			argExamSepeare: "^"
	    });
    }
	
}