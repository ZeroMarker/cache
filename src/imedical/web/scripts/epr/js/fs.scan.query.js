//全局
var FSScanQuery = FSScanQuery || {
	StartDate: '',
	EndDate: ''
};

//配置和静态
FSScanQuery.Config = FSScanQuery.Config || {
	PAGESIZE: 20,
	PAGELIST: [10, 20, 30, 50, 100],
	LOADING_INFO: '数据装载中......'
};

(function (win) {
	$(function () {
		$('#inputStartDate').datebox({
			onSelect: function() {
				FSScanQuery.StartDate = $('#inputStartDate').datebox('getValue');
			},
			onChange: function() {
				FSScanQuery.StartDate = $('#inputStartDate').datebox('getValue');
			}
		});
		$('#inputEndDate').datebox({
			onSelect: function() {
				FSScanQuery.EndDate = $('#inputEndDate').datebox('getValue');
			},
			onChange: function() {
				FSScanQuery.EndDate = $('#inputEndDate').datebox('getValue');
			}
		});
		setDefaultDate();
		
		$('#cbAdmStatus').on('click', function () {
			if ($(this).prop('checked') == true) {
				$('#cbDisStatus').attr('checked', false);
			}
			else {
				$('#cbDisStatus').attr('checked', true);
			}
		});
		
		$('#cbDisStatus').on('click', function () {
			if ($(this).prop('checked') == true) {
				$('#cbAdmStatus').attr('checked', false);
			}
			else {
				$('#cbAdmStatus').attr('checked', true);
			}
		});
		
		//查询
		$('#btnSearch').on('click', function() {
			searchEpisode();
		});
		
		//扫描
		$('#btnScan').on('click', function() {
			var row = $('#episodeListTable').datagrid('getSelected');
			if (row) {
				var episodeID = row.EpisodeID;
				var url = 'dhc.epr.fs.scan.main4chrome.csp?EpisodeID=' + episodeID;
				$('#iframeScan').attr('src', url);
			}
			else {
				$.messager.alert('提示','请先选中一条就诊','info');
				return;
			}
		});
		
		$('#inputRegNo').on('keypress', function(event) {
			if (event.keyCode == '13') {
				searchEpisode();
			}
		});
		
		$('#inputMedRecordNo').on('keypress', function(event) {
			if (event.keyCode == '13') {
				searchEpisode();
			}
		});
		
		$('#inputPatName').on('keypress', function(event) {
			if (event.keyCode == '13') {
				searchEpisode();
			}
		});
		
		$('#episodeListTable').datagrid({
			queryParams: {
				Action: 'scanepisodelist',
				AdmStatus: '',
				StartDate: '',
				EndDate: '',
				LocID: userLocID,
				RegNo: '',
				MedRecordNo: '',
				PatName: ''
			},
			method: 'post',
			fit: true,
			singleSelect: true,
			rownumbers: true,
			pagination: true,
			pageSize: FSScanQuery.Config.PAGESIZE,
			pageList: FSScanQuery.Config.PAGELIST,
			loadMsg: FSScanQuery.Config.LOADING_INFO,
			columns: [[
				{ field: 'MedRecordNo', title: '病案号', width: 80 },
				{ field: 'RegNo', title: '登记号', width: 80 },
				{ field: 'PatName', title: '病人姓名', width: 80 },
				{ field: 'DisDate', title: '出院日期', width: 80 },
				{ field: 'DisTime', title: '出院时间', width: 80 },
				{ field: 'AdmDate', title: '入院日期', width: 80 },
				{ field: 'AdmTime', title: '入院时间', width: 80 },
				{ field: 'PAAdmDocCodeDR', title: '主治医生', width: 70 },
				{ field: 'AdmLocDesc', title: '科室', width: 120 },
				{ field: 'AdmWardDesc', title: '病区', width: 120 },
				{ field: 'PatDOB', title: '出生日期', width: 80 },
				{ field: 'PatSex', title: '性别', width: 40 },
				{ field: 'PAADMReason', title: '病人费别', width: 70 },
				{ field: 'EpisodeID', title: '就诊号', width: 70 },
				{ field: 'PatientID', title: '病人号', width: 70 }
			]]
		});
		
		//查询就诊
		function searchEpisode() {
			var url = '../DHCEPRFS.web.eprajax.AjaxEpisodeView.cls';
			$('#episodeListTable').datagrid('options').url = url;
			var queryParams = $('#episodeListTable').datagrid('options').queryParams;
			var admStatus = '';
			var group = document.getElementsByName('admStatus');
			for (var i=0;i<group.length;i++) {
				if(group[i].checked == true) {
					admStatus = group[i].value;
				}
			}
			queryParams.AdmStatus = admStatus;
			queryParams.StartDate = FSScanQuery.StartDate;
			queryParams.EndDate = FSScanQuery.EndDate;
			queryParams.RegNo = $('#inputRegNo').val();
			queryParams.MedRecordNo = $('#inputMedRecordNo').val();
			queryParams.PatName = $('#inputPatName').val();
			$('#episodeListTable').datagrid('options').queryParams = queryParams;
			$('#episodeListTable').datagrid('reload');
			$('#episodeListTable').datagrid('getPager').pagination('select',1);
			if (admStatus == 'A') {
				$('#episodeListTable').datagrid('hideColumn','DisDate');
				$('#episodeListTable').datagrid('hideColumn','DisTime');
			}
			else {
				$('#episodeListTable').datagrid('showColumn','DisDate');
				$('#episodeListTable').datagrid('showColumn','DisTime');
			}
		}
		
		//设置默认时间
		function setDefaultDate() {
			var currDate = new Date();
			$('#inputStartDate').datebox('setValue', myformatter(currDate));
			$('#inputEndDate').datebox('setValue', myformatter(currDate));
			FSScanQuery.StartDate = $('#inputStartDate').datebox('getValue');
			FSScanQuery.EndDate = $('#inputEndDate').datebox('getValue');
		}
		
		function myformatter(date) {
			var y = date.getFullYear();
			var m = date.getMonth() + 1;
			var d = date.getDate();
			return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
		}
		
		function myformatter1(date,span) {
			var d = date.getDate() - span;
			var tmp = new Date();
			tmp.setDate(d);
			var y = tmp.getFullYear();
			var m = tmp.getMonth() + 1;
			d = tmp.getDate();
			return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
		}
	});
}(window));
