//全局
var FSScanQuery = FSScanQuery || {
	StartDate: '',
	EndDate: ''
};

//配置和静态
FSScanQuery.Config = FSScanQuery.Config || {
	PAGESIZE: 20,
	PAGELIST: [10, 20, 30, 50, 100]
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
				$.messager.popover({msg:'请先选中一条就诊',type:'alert',timeout:1000});
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
		
		$HUI.datagrid('#episodeListTable',{
			title: '科室患者列表',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			fit: true,
			toolbar: '#episodeListTableTBar',
			url: $URL,
			queryParams: {
				ClassName: 'DHCEPRFS.BL.BLMREpisodeView',
				QueryName: 'GetScanEpisodeList',
				AAdmStatus: '',
				AStartDate: '',
				AEndDate: '',
				ALocID: userLocID,
				ARegNo: '',
				AMedRecordNo: '',
				APatName: ''
			},
			rownumbers: true,
			singleSelect: true,
			pagination: true,
			pageSize: FSScanQuery.Config.PAGESIZE,
			pageList: FSScanQuery.Config.PAGELIST,
			columns: [[
				{field:'MedRecordNo',title:'病案号',width:100},
				{field:'RegNo',title:'登记号',width:100},
				{field:'PatName',title:'患者姓名',width:80},
				{field:'DisDate',title:'出院日期',width:100},
				{field:'DisTime',title:'出院时间',width:100},
				{field:'AdmDate',title:'入院日期',width:100},
				{field:'AdmTime',title:'入院时间',width:100},
				{field:'PAAdmDocCodeDR',title:'主治医生',width:80},
				{field:'AdmLocDesc',title:'科室',width:150},
				{field:'AdmWardDesc',title:'病区',width:150},
				{field:'PatDOB',title:'出生日期',width:100},
				{field:'PatSex',title:'性别',width:50},
				{field:'PAADMReason',title:'患者费别',width:80},
				{field:'EpisodeID',title:'就诊号',width:80},
				{field:'PatientID',title:'病人号',width:80}
			]]
		});
		
		//查询就诊
		function searchEpisode() {
			var queryParams = $('#episodeListTable').datagrid('options').queryParams;
			var admStatus = '';
			var group = document.getElementsByName('admStatus');
			for (var i=0;i<group.length;i++) {
				if(group[i].checked == true) {
					admStatus = group[i].value;
				}
			}
			queryParams.AAdmStatus = admStatus;
			queryParams.AStartDate = FSScanQuery.StartDate;
			queryParams.AEndDate = FSScanQuery.EndDate;
			queryParams.ARegNo = $('#inputRegNo').val();
			queryParams.AMedRecordNo = $('#inputMedRecordNo').val();
			queryParams.APatName = $('#inputPatName').val();
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
