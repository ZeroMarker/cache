//全局
var FSReviewDept = FSReviewDept || {
	DateStart : "",
	DateEnd : "",
	TypeCode : "U",
	ReasonSelectID: "",
	Back2Doc: "0",
	Back2Nur: "0",
	//公有方法声明
	SearchEpisode: null,
	QCBack: null
};

//配置和静态
FSReviewDept.Config = FSReviewDept.Config || {
	DATESPAN: 7,
	PAGESIZE: 30,
	PAGELIST: [10, 20, 30, 50, 100],
	ERROR_INFO: "错误",
	ERROR_INFO_REVIEW: "复核失败，请重新尝试或联系管理员",
	ERROR_INFO_NOEPISODESELECTED: "请先选中一条就诊",
	ERROR_INFO_QCBACK: "退回失败，请重新尝试或联系管理员",
	LOADING_INFO: "数据装载中......"
};

(function (win) {
	$(function () {
		//初始化公有方法
		FSReviewDept.SearchEpisode = searchEpisode;
		FSReviewDept.QCBack = qcback;
		
		$('#inputDateStart').datebox({
			onSelect: function () {
				FSReviewDept.DateStart = $('#inputDateStart').datebox('getValue');
			},
			onChange: function () {
				FSReviewDept.DateStart = $('#inputDateStart').datebox('getValue');
			}
		});
		$('#inputDateEnd').datebox({
			onSelect: function () {
				FSReviewDept.DateEnd = $('#inputDateEnd').datebox('getValue');
			},
			onChange: function () {
				FSReviewDept.DateEnd = $('#inputDateEnd').datebox('getValue');
			}
		});
		setDefaultDate();
		
		//设置是否显示退回按钮
		if (enableAction == "N") {
			$("#back2DocBtn").hide();
			$("#back2NurBtn").hide();
			$("#back2AllBtn").hide();
		}
		
		$('#inputDocCommit').combobox({
			valueField: 'id',
			textField: 'text',
			panelHeight: 'auto',
			data: [{
				id: 'a',
				text: '全部'
			}, {
				id: 'y',
				text: '是',
				selected: true
			}, {
				id: 'n',
				text: '否'
			}]
		});
		
		$('#inputNurCommit').combobox({
			valueField: 'id',
			textField: 'text',
			panelHeight: 'auto',
			data: [{
				id: 'a',
				text: '全部'
			}, {
				id: 'y',
				text: '是'
			}, {
				id: 'n',
				text: '否'
			}]
		});
		
		$('#inputPDFCreated').combobox({
			valueField: 'id',
			textField: 'text',
			panelHeight: 'auto',
			data: [{
				id: 'a',
				text: '全部'
			}, {
				id: 'y',
				text: '是'
			}, {
				id: 'n',
				text: '否'
			}]
		});
		
		$('#inputMedRecord').on('keypress', function (event) {
			if (event.keyCode == "13") {
				searchEpisode();
			}
		});
		
		$('#inputRegNo').on('keypress', function (event) {
			if (event.keyCode == "13") {
				searchEpisode();
			}
		});
		
		$('#inputName').on('keypress', function (event) {
			if (event.keyCode == "13") {
				searchEpisode();
			}
		});
		
		//查询
		$('#searchBtn').on('click', function () {
			searchEpisode();
		});
		
		//重置
		$('#resetBtn').on('click', function () {
			setDefaultDate();
			$('#inputDocCommit').combobox('select','y');
			$('#inputNurCommit').combobox('select','');
			$('#inputPDFCreated').combobox('select','');
			$('#inputMedRecord').val('');
			$('#inputRegNo').val('');
			$('#inputName').val('');
			$('#inputType').combobox('select','U');
		});
		
		//复核通过
		$('#passBtn').on('click', function () {
			var result = getSelectEpisode();
			if (result !== "-1") {
				var obj = $.ajax({
					url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=reviewpass&ActionCode=2&EpisodeID=" + FSReviewDept.SelectEpisode + "&UserID=" + userID,
					type: 'post',
					async: false
				});
				FSReviewDept.SelectEpisode = "";
				var ret = obj.responseText;
				if (ret == "-10") {
					$.messager.alert('提示', '医生提交或护士提交未完成，不能进行操作！', 'info');
					return;
				}
				else if (ret != "1") {
					$.messager.alert(FSReviewDept.Config.ERROR_INFO, FSReviewDept.Config.ERROR_INFO_REVIEW, 'error');
					return;
				}
				else {
					searchEpisode();
				}
			}
		});
		
		//退回医生
		$('#back2DocBtn').on('click', function () {
			FSReviewDept.Back2Doc = "1";
			FSReviewDept.Back2Nur = "0";
			var ret = getSelectEpisode();
			if (ret !== "-1") {
				FSReviewCommon.OpenBackWin(FSReviewDept.QCBack);
			}
		});
		
		//退回护士
		$('#back2NurBtn').on('click', function () {
			FSReviewDept.Back2Doc = "0";
			FSReviewDept.Back2Nur = "1";
			var ret = getSelectEpisode();
			if (ret !== "-1") {
				FSReviewCommon.OpenBackWin(FSReviewDept.QCBack);
			}
		});
		
		//全部退回
		$('#back2AllBtn').on('click', function () {
			FSReviewDept.Back2Doc = "1";
			FSReviewDept.Back2Nur = "1";
			var ret = getSelectEpisode();
			if (ret !== "-1") {
				FSReviewCommon.OpenBackWin(FSReviewDept.QCBack);
			}
		});
		
		//患者查询列表
		var patientDG = $('#episodeListTable').datagrid({
			//url: '../DHCEPRFS.web.eprajax.AjaxReview.cls',
			queryParams: {
				Action: 'deptepisodelist',
				UserID: userID,
				Type: FSReviewDept.TypeCode,
				StartDate: '',
				EndDate: '',
				MedRecordNo: '',
				RegNo: '',
				Name: '',
				FilterLocID: userLocID,
				DocCommit: '',
				NurCommit: '',
				PDFCreated: ''
			},
			method: 'post',
			loadMsg: FSReviewDept.Config.LOADING_INFO,
			rownumbers: true,
			singleSelect: true,
			//fitColumns: true,
			toolbar: '#episodeListTableTBar',
			pagination: true,
			pageSize: FSReviewDept.Config.PAGESIZE,
			pageList: FSReviewDept.Config.PAGELIST,
			columns: [[
				{ field: 'ck', checkbox: true },
				{ field: 'QCDeptStatus', title: '质控科审核', width: 70, styler: cellStyler, hidden: true },
				{ field: 'ReviewStatus', title: '病案室审核', width: 70, styler: cellStyler, hidden: true },
				{ field: 'DeptStatus', title: '科室审核', width: 65, styler: cellStyler },
				{ field: 'EprDocStatus', title: 'EprDocStatus', width: 60, hidden: true },
				{ field: 'EprDocStatusDesc', title: '医生提交', width: 65, styler: cellStyler },
				{ field: 'EprNurStatus', title: 'EprNurStatus', width: 60, hidden: true },
				{ field: 'EprNurStatusDesc', title: '护士提交', width: 65, styler: cellStyler },
				{ field: 'EprPdfStatus', title: 'EprPdfStatus', width: 60, hidden: true },
				{ field: 'EprPdfStatusDesc', title: '是否生成', width: 65, styler: cellStyler },
				{ field: 'EPRURL', title: '电子病历', width: 70, formatter: eprURLFormatter },
				{ field: 'MedRecordNo', title: '病案号', width: 80, sortable: true },
				{ field: 'RegNo', title: '登记号', width: 80, sortable: true },
				{ field: 'PAPMIName', title: '病人姓名', width: 80 },
				{ field: 'DisDate', title: '出院日期', width: 80 },
				{ field: 'DisTime', title: '出院时间', width: 80 },
				{ field: 'PAAdmDepCodeDR', title: '科室', width: 120 },
				{ field: 'Warddesc', title: '病区', width: 130 },
				{ field: 'PAAdmDocCodeDR', title: '主治医生', width: 70 },
				{ field: 'AdmDate', title: '入院日期', width: 80 },
				{ field: 'AdmTime', title: '入院时间', width: 80 },
				{ field: 'PAPMIDOB', title: '出生日期', width: 80 },
				{ field: 'PAPMISex', title: '性别', width: 40 },
				{ field: 'EpisodeID', title: '就诊号', width: 70, hidden: true },
				{ field: 'PatientID', title: '病人号', width: 70, hidden: true },
				{ field: 'SubmitDocID', title: '提交医生ID', width: 70 },
				{ field: 'SubmitNurID', title: '提交护士ID', width: 70 }
			]]
		});
		
		//列表类型
		$('#inputType').combobox({
			valueField: 'code',
			textField: 'text',
			data: [{
				code: 'U',
				text: '科室未复核'
			}, {
				code: 'F',
				text: '科室已复核'
			}, {
				code: 'B',
				text: '科室已退回'
			}, {
				code: 'A',
				text: '全部'
			}],
			panelHeight: 'auto',
			editable: false,
			onSelect: function(rec) {
				FSReviewDept.TypeCode = rec.code;
				if ((FSReviewDept.TypeCode == 'B')||(FSReviewDept.TypeCode == 'A')) {
					$('#inputDocCommit').combobox('select','');
					$('#inputNurCommit').combobox('select','');
					$('#inputPDFCreated').combobox('select','');
				}
				searchEpisode();
			},
			onLoadSuccess: function() {
				var typeData = $('#inputType').combobox('getData');
				$('#inputType').combobox('select', typeData[0].code);
			}
		});
		
		//获取选中行就诊号
		function getSelectEpisode() {
			FSReviewDept.SelectEpisode = "";
			//取当前选中行
			var rows = $('#episodeListTable').datagrid('getSelections');
			if (rows.length !== 1) {
				$.messager.alert(FSReviewDept.Config.ERROR_INFO, FSReviewDept.Config.ERROR_INFO_NOEPISODESELECTED, 'error');
				return "-1";
			}
			else {
				var row = rows[0];
				FSReviewDept.SelectEpisode = row.EpisodeID;
				FSReviewDept.SelectDocID = row.SubmitDocID;
				FSReviewDept.SelectNurID = row.SubmitNurID;
			}
		}
		
		//退回操作
		function qcback(reason) {
			var obj = $.ajax({
				url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=qcback&ActionCode=2&EpisodeID=" + FSReviewDept.SelectEpisode + "&UserID=" + userID + "&Reason=" + encodeURI(reason) + "&Back2Nur=" + FSReviewDept.Back2Nur + "&Back2Doc=" + FSReviewDept.Back2Doc+ "&SubmitDocID="+FSReviewDept.SubmitDocID+ "&SubmitNurID="+FSReviewDept.SubmitNurID,
				type: 'post',
				async: false
			});
			FSReviewDept.Back2Doc = "0";
			FSReviewDept.Back2Nur = "0";
			FSReviewDept.SelectEpisode = "";
			var ret = obj.responseText;
			if (ret !== "1") {
				$.messager.alert(FSReviewDept.Config.ERROR_INFO, FSReviewDept.Config.ERROR_INFO_QCBACK, 'error');
				return;
			}
			else {
				searchEpisode();
			}
		} 
		
		//三单一致链接
		function superURLFormatter(value, row, index) {
			var episodeID = row.EpisodeID;
			var iWidth = screen.availWidth - 10;                         //弹出窗口的宽度;
			var iHeight = screen.availHeight - 30;                       //弹出窗口的高度;
			var iTop = 0;       //获得窗口的垂直位置;
			var iLeft = 0;
			var url = 'dhc.epr.fs.review.view.csp?EpisodeID=' + episodeID + '&UserID=' + userID;
			var style = 'dialogHeight=' + iHeight + 'px;dialogWidth=' + iWidth + 'px;dialogTop=' + iTop + 'px;dialogLeft=' + iLeft + 'px;center=yes;help=no;resizable=yes;scroll=no;status=no;edge=sunken';
			return '<a href="javascript:void(0)" onclick="window.showModalDialog(\''+url+'\',{ funObj: FSReviewDept.SearchEpisode,ActionCode:2 },\''+style+'\');">三单一致</a>';
		}
		
		//点击三单一致弹窗
		function openWin(episodeID) {
			var iWidth = screen.availWidth - 10;                         //弹出窗口的宽度;
			var iHeight = screen.availHeight - 30;                       //弹出窗口的高度;
			var iTop = 0;       //获得窗口的垂直位置;
			var iLeft = 0;
			var url = 'dhc.epr.fs.review.view.csp?EpisodeID=' + episodeID + '&UserID=' + userID;
			window.showModalDialog(url, { funObj: FSReviewDept.SearchEpisode, ActionCode:'2' }, 'dialogHeight=' + iHeight + 'px;dialogWidth=' + iWidth + 'px;dialogTop=' + iTop + 'px;dialogLeft=' + iLeft + 'px;center=yes;help=no;resizable=yes;scroll=no;status=no;edge=sunken');
		}
		
		//电子病历链接
		function eprURLFormatter(value, row, index) {
			var episodeID = row.EpisodeID;
			var iWidth = screen.availWidth - 10;                         //弹出窗口的宽度;
			var iHeight = screen.availHeight - 30;                       //弹出窗口的高度;
			var iTop = 0;       //获得窗口的垂直位置;
			var iLeft = 0;
			var url = 'epr.newfw.main.csp?EpisodeID=' + episodeID;
			var style = 'dialogHeight=' + iHeight + 'px;dialogWidth=' + iWidth + 'px;dialogTop=' + iTop + 'px;dialogLeft=' + iLeft + 'px;center=yes;help=no;resizable=yes;scroll=no;status=no;edge=sunken';
			return '<a href="javascript:void(0)" onclick="window.showModalDialog(\''+url+'\',{},\''+style+'\');">电子病历</a>';
		}
		
		//医生确认，护士确认，是否生成单元格染色
		function cellStyler(value, row, index) {
			if (value === "否") {
				return 'background-color:red;color:white;';
			}
			else if (value === "是") {
				return 'background-color:darkgreen;color:white;';
			}
			else {
				return 'background-color:darkblue;color:white;';
			}
		}
		
		//查询就诊
		function searchEpisode() {
			var url = '../DHCEPRFS.web.eprajax.AjaxReview.cls';
			$('#episodeListTable').datagrid('options').url = url;
			var queryParams = $('#episodeListTable').datagrid('options').queryParams;
			queryParams.Type = FSReviewDept.TypeCode;
			queryParams.StartDate = FSReviewDept.DateStart;
			queryParams.EndDate = FSReviewDept.DateEnd;
			queryParams.MedRecordNo = $('#inputMedRecord').val();
			queryParams.RegNo = $('#inputRegNo').val();
			queryParams.Name = $('#inputName').val();
			queryParams.DocCommit = $('#inputDocCommit').combobox('getValue');
			queryParams.NurCommit = $('#inputNurCommit').combobox('getValue');
			queryParams.PDFCreated = $('#inputPDFCreated').combobox('getValue');
			queryParams.Action = 'deptepisodelist';
			$('#episodeListTable').datagrid('options').queryParams = queryParams;
			$('#episodeListTable').datagrid('reload');
			$('#episodeListTable').datagrid('getPager').pagination('select',1);
		}
		
		//设置默认时间
		function setDefaultDate() {
			var currDate = new Date();
			$("#inputDateStart").datebox("setValue", myformatter1(currDate, FSReviewDept.Config.DATESPAN));
			$("#inputDateEnd").datebox("setValue", myformatter(currDate));
			FSReviewDept.DateStart = $("#inputDateStart").datebox("getValue");
			FSReviewDept.DateEnd = $("#inputDateEnd").datebox("getValue");
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
