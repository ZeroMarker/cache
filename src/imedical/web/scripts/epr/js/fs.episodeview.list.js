(function (win) {
	$(function () {
		//就诊列表
		var patientDG = $('#episodeListTable').datagrid({
			url: '../DHCEPRFS.web.eprajax.AjaxEpisodeView.cls',
			queryParams: {
				Action: 'mrepisodeinfolist',
				EpisodeID: episodeID,
				IDCard: idCard
			},
			method: 'post',
			fit: true,
			loadMsg: '数据装载中......',
			title: '就诊列表',
			fit: true,
			singleSelect: true,
			showHeader: true,
			rownumbers: true,
			columns: [[
				{ field: 'AdmDate', title: '就诊日期', width: 70 },
				{ field: 'DischDate', title: '出院日期', width: 70 },
				{ field: 'AdmTypeDesc', title: '类型', width: 40 },
				{ field: 'DischLoc', title: '科室', width: 120 },
				{ field: 'PatName', title: '姓名', width: 70 },
				{ field: 'RegNo', title: '登记号', width: 80 },
				{ field: 'MedRecordNo', title: '病案号', width: 80 },
				{ field: 'MainDoctor', title: '主治医生', width: 70 }
			]],
			onClickRow: function(index,row) {
				var episodeID = row.EpisodeID;
				if (enableViewFlag == '0') {
					$.messager.alert('提示','该患者当前就诊状态非在院状态，不允许浏览病案！','info');
					return;
				}
				else {
					var url = 'dhc.epr.fs.bscheckrecord.csp?EpisodeID=' + episodeID;
					$('#iframeView').attr('src', url);
				}
			}
		});
	});
}(window));