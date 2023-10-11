(function (win) {
	$(function () {
		//就诊列表
		$HUI.datagrid('#episodeListTable',{
			title: '就诊列表',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			fit: true,
			toolbar: [],
			url: '../DHCEPRFS.web.eprajax.AjaxEpisodeView.cls',
			queryParams: {
				Action: 'mrepisodeinfolist',
				EpisodeID: episodeID,
				IDCard: idCard
			},
			rownumbers: true,
			singleSelect: true,
			columns: [[
				{field:'AdmDate',title:'就诊日期',width:90},
				{field:'DischDate',title:'出院日期',width:90},
				{field:'AdmTypeDesc',title:'类型',width:50},
				{field:'DischLoc',title:'科室',width:150},
				{field:'PatName',title:'姓名',width:80},
				{field:'RegNo',title:'登记号',width:100},
				{field:'MedRecordNo',title:'病案号',width:100},
				{field:'MainDoctor',title:'主治医生',width:80}
			]],
			onClickRow: function(index,row) {
				var episodeID = row.EpisodeID;
				if (enableViewFlag == '0') {
					$.messager.alert('提示','该患者当前就诊状态非在院状态，不允许浏览病案！','info');
					return;
				}
				else {
					var url = '';
					if (controlType == 'pdfjs') {
						url = 'dhc.epr.fs.pdfview.csp?EpisodeID=' + episodeID;
					}
					else {
						url = 'dhc.epr.fs.bscheckrecord.csp?EpisodeID=' + episodeID;
					}
					$('#iframeView').attr('src', url);
				}
			}
		});
	});
}(window));