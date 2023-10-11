//全局
var FSEpisodeViewQuery = FSEpisodeViewQuery || {
	StartDate: "",
	EndDate: ""
};

//配置和静态
FSEpisodeViewQuery.Config = FSEpisodeViewQuery.Config || {
	PAGESIZE: 20,
	PAGELIST: [10, 20, 30, 50, 100],
	LOADING_INFO: "数据装载中......"
};

(function (win) {
	$(function () {
		$('#inputStartDate').datebox({
			onSelect: function () {
				FSEpisodeViewQuery.StartDate = $('#inputStartDate').datebox('getValue');
			},
			onChange: function () {
				FSEpisodeViewQuery.StartDate = $('#inputStartDate').datebox('getValue');
			}
		});
		
		$('#inputEndDate').datebox({
			onSelect: function () {
				FSEpisodeViewQuery.EndDate = $('#inputEndDate').datebox('getValue');
			},
			onChange: function () {
				FSEpisodeViewQuery.EndDate = $('#inputEndDate').datebox('getValue');
			}
		});
		
		$('#inputDisLoc').combobox({
			valueField: 'LocID',
			textField: 'LocDesc',
			url: '../DHCEPRFS.web.eprajax.AjaxEpisodeView.cls?Action=loclist&LocDepDR=2',
			method: 'post',
			filter: function(q, row) {
				var opts=$(this).combobox("options");
				return (row['LocDesc'].toLowerCase().indexOf(q.toLowerCase())==0)||(row['LocContactName'].toLowerCase().indexOf(q.toLowerCase())==0);
			}
		});
		
		//查询
		$('#btnSearch').on('click', function () {
			searchEpisodeInfo();
		});
		
		//重置
		$('#btnReset').on('click', function() {
			$("#inputStartDate").datebox("setValue",'');
			$("#inputEndDate").datebox("setValue",'');
			$('#inputDisLoc').combobox('select','');
			$('#inputRegNo').val('');
			$('#inputMedRecordNo').val('');
			$('#inputPatName').val('');
		});
		
		$('#inputRegNo').on('keypress', function(event) {
			if (event.keyCode == "13") {
				searchEpisodeInfo();
			}
		});
		
		$('#inputMedRecordNo').on('keypress', function(event) {
			if (event.keyCode == "13") {
				searchEpisodeInfo();
			}
		});
		
		$('#inputPatName').on('keypress', function(event) {
			if (event.keyCode == "13") {
				searchEpisodeInfo();
			}
		});
		
		$('#episodeInfoTable').datagrid({
			queryParams: {
				Action: 'episodeinfolist',
				StartDate:'',
				EndDate:'',
				LocID:'',
				RegNo: '',
				MedRecordNo:'',
				PatName:''
			},
			method: 'post',
			fit: true,
			border: false,
			singleSelect: true,
			rownumbers: true,
			pagination: true,
			pageSize: FSEpisodeViewQuery.Config.PAGESIZE,
			pageList: FSEpisodeViewQuery.Config.PAGELIST,
			loadMsg: FSEpisodeViewQuery.Config.LOADING_INFO,
			toolbar: '#episodeListTableTBar',
			columns: [[
				{ field: 'PAAdmType', title: '就诊类型', width: 60 },
				{ field: 'PAAdmLoc', title: '科室', width: 80 },
				{ field: 'PAPMINO', title: '登记号', width: 80 },
				{ field: 'PAPMIName', title: '病人姓名', width: 80 },
				{ field: 'PAAdmDateTime', title: '入院时间', width: 150 },
				{ field: 'PADischgeDateTime', title: '出院时间', width: 150 },
				{ field: 'PAStatusType', title: '状态', width: 60 },
				{ field: 'PAPMIDOB', title: '出生日期', width: 100 },
				{ field: 'PAPMIAge', title: '年龄', width: 60 },
				{ field: 'PAPMISex', title: '性别', width: 60 },
				{ field: 'PAAdmWard', title: '病区', width: 80 },
				{ field: 'PAAdmRoom', title: '病房', width: 80 },
				{ field: 'PAAdmBed', title: '病床', width: 80 },
				{ field: 'PAAdmDoc', title: '医生', width: 80 },
				{ field: 'PayMode', title: '付费类型', width: 80 },
				{ field: 'EpisodeID', title: '就诊号', width: 60 },
				{ field: 'PatientID', title: '病人号', width: 60 }
			]],
			onSelect: function (index, row){
				var episodeID = row.EpisodeID;
				var url = 'dhc.epr.fs.bscheckrecord.csp?EpisodeID=' + episodeID;
				$('#iframeView').attr("src", url);
			}
		});
		
		//查询就诊
		function searchEpisodeInfo() {
			var url = '../DHCEPRFS.web.eprajax.AjaxEpisodeView.cls';
			$('#episodeInfoTable').datagrid('options').url = url;
			var queryParams = $('#episodeInfoTable').datagrid('options').queryParams;
			queryParams.StartDate = FSEpisodeViewQuery.StartDate;
			queryParams.EndDate = FSEpisodeViewQuery.EndDate;
			queryParams.LocID = $('#inputDisLoc').combobox('getValue');
			queryParams.RegNo = $('#inputRegNo').val();
			queryParams.MedRecordNo = $('#inputMedRecordNo').val();
			queryParams.PatName = $('#inputPatName').val();
			$('#episodeInfoTable').datagrid('options').queryParams = queryParams;
			$('#episodeInfoTable').datagrid('reload');
			$('#episodeInfoTable').datagrid('getPager').pagination('select',1);
		}
		
		//设置默认时间
		function setDefaultDate() {
			var currDate = new Date();
			$("#inputStartDate").datebox("setValue", myformatter(currDate));
			$("#inputEndDate").datebox("setValue", myformatter(currDate));
			FSEpisodeViewQuery.StartDate = $("#inputStartDate").datebox("getValue");
			FSEpisodeViewQuery.EndDate = $("#inputEndDate").datebox("getValue");
		}
		
		function myformatter(date) {
			var y = date.getFullYear();
			var m = date.getMonth() + 1;
			var d = date.getDate();
			return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
		}
		
		function myformatter1(date, span) {
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
