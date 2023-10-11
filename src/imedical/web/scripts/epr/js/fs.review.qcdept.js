//全局
var FSReviewQCDept = FSReviewQCDept || {
	DateStart : "",
	DateEnd : "",
	TypeCode : "QC||U",
	ReasonSelectID: "",
	Back2Doc: "0",
	Back2Nur: "0",
	FilterLocID: "",
	//公有方法声明
	SearchEpisode: null,
	QCBack: null
};

//配置和静态
FSReviewQCDept.Config = FSReviewQCDept.Config || {
	DATESPAN: 7,
	PAGESIZE: 30,
	PAGELIST: [10, 20, 30, 50, 100],
	CTLOC_PAGESIZE: 20,
	CTLOC_PAGELIST: [10, 20, 50, 100],
	ERROR_INFO: "错误",
	ERROR_INFO_REVIEW: "复核失败，请重新尝试或联系管理员",
	ERROR_INFO_NOEPISODESELECTED: "请先选中一条就诊",
	ERROR_INFO_QCBACK: "退回失败，请重新尝试或联系管理员",
	LOADING_INFO: "数据装载中......"
};

(function (win) {
	$(function () {
		//初始化公有方法
		FSReviewQCDept.SearchEpisode = searchEpisode;
		FSReviewQCDept.QCBack = qcback;
		
		$('#inputDateStart').datebox({
			onSelect: function () {
				FSReviewQCDept.DateStart = $('#inputDateStart').datebox('getValue');
			},
			onChange: function () {  //避免不选择日期而采用输入的方式
				FSReviewQCDept.DateStart = $('#inputDateStart').datebox('getValue');
			}
		});
		
		$('#inputDateEnd').datebox({
			onSelect: function () {
				FSReviewQCDept.DateEnd = $('#inputDateEnd').datebox('getValue');
			},
			onChange: function () {  //避免不选择日期而采用输入的方式
				FSReviewQCDept.DateEnd = $('#inputDateEnd').datebox('getValue');
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
				text: '是',
				selected: true
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
			$('#inputNurCommit').combobox('select','y');
			$('#inputPDFCreated').combobox('select','');
			$('#inputMedRecord').val('');
			$('#inputRegNo').val('');
			$('#inputName').val('');
			FSReviewQCDept.FilterLocID = "";
			$('#inputPatientLoc').combogrid('clear');
			$('#inputType').combobox('select','QC||U');
		});
		
		//复核通过
		$('#passBtn').on('click', function () {
			var result = getSelectEpisode();
			if (result !== "-1") {
				var obj = $.ajax({
					url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=reviewpass&ActionCode=3&EpisodeID=" + FSReviewQCDept.SelectEpisode + "&UserID=" + userID,
					type: 'post',
					async: false
				});
				FSReviewQCDept.SelectEpisode = "";
				var ret = obj.responseText;
				if (ret == "-10") {
					$.messager.alert('提示', '病案室复核未通过，不能进行操作！', 'info');
					return;
				}
				else if (ret != "1") {
					$.messager.alert(FSReviewQCDept.Config.ERROR_INFO, FSReviewQCDept.Config.ERROR_INFO_REVIEW, 'error');
					return;
				}
				else {
					searchEpisode();
				}
			}
		});
		
		//退回医生
		$('#back2DocBtn').on('click', function () {
			FSReviewQCDept.Back2Doc = "1";
			FSReviewQCDept.Back2Nur = "0";
			var ret = getSelectEpisode();
			if (ret !== "-1") {
				FSReviewCommon.OpenBackWin(FSReviewQCDept.QCBack);
			}
		});
		
		//退回护士
		$('#back2NurBtn').on('click', function () {
			FSReviewQCDept.Back2Doc = "0";
			FSReviewQCDept.Back2Nur = "1";
			var ret = getSelectEpisode();
			if (ret !== "-1") {
				FSReviewCommon.OpenBackWin(FSReviewQCDept.QCBack);
			}
		});
		
		//全部退回
		$('#back2AllBtn').on('click', function () {
			FSReviewQCDept.Back2Doc = "1";
			FSReviewQCDept.Back2Nur = "1";
			var ret = getSelectEpisode();
			if (ret !== "-1") {
				FSReviewCommon.OpenBackWin(FSReviewQCDept.QCBack);
			}
		});
		
		//患者查询列表
		var patientDG = $('#episodeListTable').datagrid({
			//url: '../DHCEPRFS.web.eprajax.AjaxReview.cls',
			queryParams: {
				Action: 'episodelist',
				UserID: userID,
				Type: FSReviewQCDept.TypeCode,
				StartDate: '',
				EndDate: '',
				MedRecordNo: '',
				RegNo: '',
				Name: '',
				FilterLocID: '',
				DocCommit: '',
				NurCommit: '',
				PDFCreated: ''
			},
			method: 'post',
			loadMsg: FSReviewQCDept.Config.LOADING_INFO,
			rownumbers: true,
			singleSelect: true,
			//fitColumns: true,
			toolbar: '#episodeListTableTBar',
			pagination: true,
			pageSize: FSReviewQCDept.Config.PAGESIZE,
			pageList: FSReviewQCDept.Config.PAGELIST,
			columns: [[
				{ field: 'ck', checkbox: true },
				{ field: 'QCDeptStatus', title: '质控科审核', width: 80, styler: cellStyler },
				{ field: 'ReviewStatus', title: '病案室审核', width: 80, styler: cellStyler, hidden: true },
				{ field: 'DeptStatus', title: '科室审核', width: 65, styler: cellStyler, hidden: true },
				{ field: 'EprDocStatus', title: 'EprDocStatus', width: 60, hidden: true },
				{ field: 'EprDocStatusDesc', title: '医生提交', width: 65, styler: cellStyler },
				{ field: 'EprNurStatus', title: 'EprNurStatus', width: 60, hidden: true },
				{ field: 'EprNurStatusDesc', title: '护士提交', width: 65, styler: cellStyler },
				{ field: 'EprPdfStatus', title: 'EprPdfStatus', width: 60, hidden: true },
				{ field: 'EprPdfStatusDesc', title: '是否生成', width: 65, styler: cellStyler },
				{ field: 'SuperURL', title: '三单一致', width: 70, formatter: superURLFormatter },
				{ field: 'MedRecordNo', title: '病案号', width: 80, sortable: true },
				{ field: 'RegNo', title: '登记号', width: 80, sortable: true },
				{ field: 'PAPMIName', title: '病人姓名', width: 80 },
				{ field: 'DisDateTime', title: '出院日期时间', width: 130 },
				{ field: 'PAAdmDepCodeDR', title: '科室', width: 120 },
				{ field: 'Warddesc', title: '病区', width: 120 },
				{ field: 'PAAdmDocCodeDR', title: '主治医生', width: 70 },
				{ field: 'AdmDateTime', title: '入院日期时间', width: 130 },
				{ field: 'PAPMIDOB', title: '出生日期', width: 80 },
				{ field: 'PAPMISex', title: '性别', width: 40 },
				{ field: 'EpisodeID', title: '就诊号', width: 70, hidden: true },
				{ field: 'PatientID', title: '病人号', width: 70, hidden: true }
			]],
			onDblClickRow: function (index, row) {
				var episodeID = row.EpisodeID;
				openWin(episodeID);
			}
		});
		
		//列表类型
		$('#inputType').combobox({
			valueField: 'code',
			textField: 'text',
			data: [{
				code: 'QC||U',
				text: '质控科未复核'
			}, {
				code: 'QC||F',
				text: '质控科已复核'
			}, {
				code: 'QC||B',
				text: '质控科已退回'
			}, {
				code: 'A',
				text: '全部'
			}],
			panelHeight: 'auto',
			editable: false,
			onSelect: function(rec) {
				FSReviewQCDept.TypeCode = rec.code;
				if ((FSReviewQCDept.TypeCode == 'QC||B')||(FSReviewQCDept.TypeCode == 'MR||B')||(FSReviewQCDept.TypeCode == 'A')) {
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
		
		//选择患者就诊科室
		$(function () {
			setTimeout(function () {
				var old = '';
				var query = '';
				var search = true;
				$('#inputPatientLocText').keyup(function () {
					//清除所有勾选
					$('#inputPatientLoc').combogrid('grid').datagrid('uncheckAll');
					var _new = $('#inputPatientLocText').val();
					if (_new != old) {
						old = _new;
						query = old;
						setTimeout(function () {
							if (query.length > 0) {
								refreshLoc(query);
							}
						}, 1500);
					}
				});
				
				$('#inputPatientLocClear').bind('click',function() {
					$('#inputPatientLoc').combogrid('grid').datagrid('uncheckAll');
					FSReviewQCDept.FilterLocID = "";
					$('#inputPatientLoc').val('');
					$('#inputPatientLocText').val('');
					refreshLoc('');
				});
			}, 1000);
		});
		
		function refreshLoc(query) {
			var url = '../DHCEPRFS.web.eprajax.AjaxDicList.cls';
			$('#inputPatientLoc').combogrid('grid').datagrid('options').url = url;
			var queryParams = $('#inputPatientLoc').combogrid('grid').datagrid('options').queryParams;
			queryParams.Filter = query;
			$('#inputPatientLoc').combogrid('grid').datagrid('options').queryParams = queryParams;
			$('#inputPatientLoc').combogrid('grid').datagrid('reload');
			$('#inputPatientLoc').combogrid('grid').datagrid('getPager').pagination('select',1);
		}
		
		$('#inputPatientLoc').combogrid({
			//url: 'DHCEPRFS.web.eprajax.AjaxDicList.cls',
			queryParams: {
				DicCode: 'S07',
				Filter: ''
			},
			panelWidth: 300,
			panelHeight: 600,
			checkOnSelect: true,
			selectOnCheck: true,
			multiple: true,
			idField: 'ID',
			textField: 'DicDesc',
			method: 'get',
			showHeader: false,
			toolbar: '#inputPatientLocTbar',
			fitColumns: true,
			columns: [[
				{ field: 'ck', checkbox: true },
				{ field: 'ID', title: 'ID', width: 80, hidden: true },
				{ field: 'DicAlias', title: 'DicAlias', width: 80, hidden: true },
				{ field: 'DicCode', title: 'DicCode', width: 80, hidden: true },
				{ field: 'DicDesc', title: 'DicDesc', width: 300 }
			]],
			pagination: true,
			pageSize: FSReviewQCDept.Config.CTLOC_PAGESIZE,
			pageList: FSReviewQCDept.Config.CTLOC_PAGELIST,
			onCheck: function(index, row) {
				//debugger;
				search = false;
				var idField = row["ID"]; 
				var textField = row["DicDesc"];
				var textFieldAll = $('#inputPatientLoc').val();
				
				if ((FSReviewQCDept.FilterLocID == "") || (typeof(FSReviewQCDept.FilterLocID) == "undefined"))
				{
					FSReviewQCDept.FilterLocID = idField;
					textFieldAll = textField;
				}
				else
				{
					//判断是否已经添加
					var arr = new Array();
					var str = FSReviewQCDept.FilterLocID;
					arr = str.split(',');
					var flag = false;
					var i=0;
					for (i;i<arr.length;i++)
					{
						if (arr[i] == idField)
						{
							flag = true;
							break;
						}
					}
					
					if (flag)
					{
						return;
					}
					else
					{
						FSReviewQCDept.FilterLocID = FSReviewQCDept.FilterLocID+","+idField;
						textFieldAll = textFieldAll+","+textField;
					}
				}
				
				$('#inputPatientLoc').val(textFieldAll);
				setTimeout(function () {
					search = true;
				}, 1000);
			},
			onShowPanel:function () {
				setTimeout(function(){
					var url = '../DHCEPRFS.web.eprajax.AjaxDicList.cls';
					$('#inputPatientLoc').combogrid('grid').datagrid('options').url = url;
					var queryParams = $('#inputPatientLoc').combogrid('grid').datagrid('options').queryParams;
					$('#inputPatientLoc').combogrid('grid').datagrid('options').queryParams = queryParams;
					$('#inputPatientLoc').combogrid('grid').datagrid('reload');
					$('#inputPatientLocText').focus();
				},100);
			}
		});
		
		$('#inputPatientLoc').combogrid('grid').datagrid('getPager').pagination({
			pageSize: FSReviewQCDept.Config.CTLOC_PAGESIZE,
			pageList: FSReviewQCDept.Config.CTLOC_PAGELIST,
			beforePageText: '第',
			afterPageText: '页/共{pages}页',
			displayMsg: '{from} - {to},共{total}'
		});
		
		//获取选中行就诊号
		function getSelectEpisode() {
			FSReviewQCDept.SelectEpisode = "";
			//取当前选中行
			var rows = $('#episodeListTable').datagrid('getSelections');
			if (rows.length !== 1) {
				$.messager.alert(FSReviewQCDept.Config.ERROR_INFO, FSReviewQCDept.Config.ERROR_INFO_NOEPISODESELECTED, 'error');
				return "-1";
			}
			else {
				var row = rows[0];
				FSReviewQCDept.SelectEpisode = row.EpisodeID;
			}
		}
		
		//退回操作
		function qcback(reason) {
			var obj = $.ajax({
				url: "../DHCEPRFS.web.eprajax.AjaxReview.cls?Action=qcback&ActionCode=3&EpisodeID=" + FSReviewQCDept.SelectEpisode + "&UserID=" + userID + "&Reason=" + encodeURI(reason) + "&Back2Nur=" + FSReviewQCDept.Back2Nur + "&Back2Doc=" + FSReviewQCDept.Back2Doc,
				type: 'post',
				async: false
			});
			FSReviewQCDept.Back2Doc = "0";
			FSReviewQCDept.Back2Nur = "0";
			FSReviewQCDept.SelectEpisode = "";
			var ret = obj.responseText;
			if (ret == "-10") {
				$.messager.alert('提示', '病案室复核未通过，不能进行操作！', 'info');
				return;
			}
			else if (ret !== "1") {
				$.messager.alert(FSReviewQCDept.Config.ERROR_INFO, FSReviewQCDept.Config.ERROR_INFO_QCBACK, 'error');
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
			return '<a href="javascript:void(0)" onclick="window.showModalDialog(\''+url+'\',{ funObj: FSReviewQCDept.SearchEpisode,ActionCode:3 },\''+style+'\');">三单一致</a>';
		}
		
		//点击三单一致弹窗
		function openWin(episodeID) {
			var iWidth = screen.availWidth - 10;                         //弹出窗口的宽度;
			var iHeight = screen.availHeight - 30;                       //弹出窗口的高度;
			var iTop = 0;       //获得窗口的垂直位置;
			var iLeft = 0;
			var url = 'dhc.epr.fs.review.view.csp?EpisodeID=' + episodeID + '&UserID=' + userID;
			window.showModalDialog(url, { funObj: FSReviewQCDept.SearchEpisode, ActionCode:'3' }, 'dialogHeight=' + iHeight + 'px;dialogWidth=' + iWidth + 'px;dialogTop=' + iTop + 'px;dialogLeft=' + iLeft + 'px;center=yes;help=no;resizable=yes;scroll=no;status=no;edge=sunken');
		}
		
		//电子病历链接
		function eprURLFormatter(value, row, index) {
			var episodeID = row.EpisodeID;
			var iWidth = screen.availWidth - 10;                         //弹出窗口的宽度;
			var iHeight = screen.availHeight - 30;                       //弹出窗口的高度;
			var iTop = 0;       //获得窗口的垂直位置;
			var iLeft = 0;
			var url = 'dhc.epr.fs.review.eprview.csp?EpisodeID=' + episodeID + '&UserID=' + userID;
			var style = 'dialogHeight=' + iHeight + 'px;dialogWidth=' + iWidth + 'px;dialogTop=' + iTop + 'px;dialogLeft=' + iLeft + 'px;center=yes;help=no;resizable=yes;scroll=no;status=no;edge=sunken';
			return '<a href="javascript:void(0)" onclick="window.showModalDialog(\''+url+'\',{ funObj: FSReviewQCDept.SearchEpisode,ActionCode:3 },\''+style+'\');">电子病历</a>';
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
			queryParams.Type = FSReviewQCDept.TypeCode;
			queryParams.StartDate = FSReviewQCDept.DateStart;
			queryParams.EndDate = FSReviewQCDept.DateEnd;
			queryParams.MedRecordNo = $('#inputMedRecord').val();
			queryParams.RegNo = $('#inputRegNo').val();
			queryParams.Name = $('#inputName').val();
			queryParams.DocCommit = $('#inputDocCommit').combobox('getValue');
			queryParams.NurCommit = $('#inputNurCommit').combobox('getValue');
			queryParams.PDFCreated = $('#inputPDFCreated').combobox('getValue');
			queryParams.FilterLocID = FSReviewQCDept.FilterLocID;
			queryParams.Action = 'episodelist';
			$('#episodeListTable').datagrid('options').queryParams = queryParams;
			$('#episodeListTable').datagrid('reload');
			$('#episodeListTable').datagrid('getPager').pagination('select',1);
		}
		
		//设置默认时间
		function setDefaultDate() {
			var currDate = new Date();
			$("#inputDateStart").datebox("setValue", myformatter1(currDate, FSReviewQCDept.Config.DATESPAN));
			$("#inputDateEnd").datebox("setValue", myformatter(currDate));
			FSReviewQCDept.DateStart = $("#inputDateStart").datebox("getValue");
			FSReviewQCDept.DateEnd = $("#inputDateEnd").datebox("getValue");
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
