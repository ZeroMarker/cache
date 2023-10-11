//页面Event
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args){ 
		//查询
		$('#btnQuery').on('click', function(){
			obj.EpdQueryLoad();
		});
		//选择导出
		$('#btnImport').on('click', function(){
	     	obj.btnImport_click();
     	});
		
		//科室选择事件
		$HUI.combobox("#cboLoc", {
			onSelect:function(){
				obj.EpdQueryLoad();
			}
		});
	}
	obj.EpdQueryLoad = function(){
		obj.StatDataGridPanel.load({
		    ClassName:"DHCMed.EPDService.EpdStaSrv",
			QueryName:"StaEpdByDate",
			FromDate: $('#DateFrom').datebox('getValue'), 
			ToDate: $('#DateTo').datebox('getValue'),
			Loc: $('#cboLoc').combobox('getValue'),
			Hospital: $('#cboSSHosp').combobox('getValue')
	    });	
		obj.gridEpdQuery.load({
		    ClassName:"DHCMed.EPDService.EpidemicSrv",
			QueryName:"QueryEpdRepByDate",
			FromDate: $('#DateFrom').datebox('getValue'), 
			ToDate: $('#DateTo').datebox('getValue'),
			Loc: $('#cboLoc').combobox('getValue'),
			Hospital: $('#cboSSHosp').combobox('getValue')
	    });		
	}
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
}