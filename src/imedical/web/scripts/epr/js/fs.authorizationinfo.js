//全局
var FSAuthInfo = FSAuthInfo || {
	TypeCode: 'N',
	StartDate: '',
	EndDate: '',
	SelectAuthInfo: '',
	SelectReasonID: ''
};
//配置和静态
FSAuthInfo.Config = FSAuthInfo.Config || {
	DATESPAN: 7,
	PAGESIZE: 20,
	PAGELIST: [10, 20, 30, 50, 100],
	ERROR_INFO: '错误',
	ERROR_INFO_ACTION: '操作失败，请重新尝试或联系管理员',
	ERROR_INFO_NOAUTHINFOSELECTED: '请先选中一条申请',
	LOADING_INFO: '数据装载中......'
};

(function(win) {
	$(function() {
		if (reasonFlag == '0') {
			$('#btnConfigReason').hide();
		}
		
		$('#inputStartDate').datebox({
			onSelect: function() {
				FSAuthInfo.StartDate = $('#inputStartDate').datebox('getValue');
			},
			onChange: function() {
				FSAuthInfo.StartDate = $('#inputStartDate').datebox('getValue');
			}
		});
		
		$('#inputEndDate').datebox({
			onSelect: function() {
				FSAuthInfo.EndDate = $('#inputEndDate').datebox('getValue');
			},
			onChange: function() {
				FSAuthInfo.EndDate = $('#inputEndDate').datebox('getValue');
			}
		});
		setDefaultDate();
		
		$('#inputRequestAct').combobox({
			valueField: 'code',
			textField: 'text',
			data: [{
				code: 'REVOKE',
				text: '病历召回',
				selected: true
			}, {
				code: 'SCAN',
				text: '病历扫描'
			}],
			panelHeight: 'auto',
			editable: false,
			onSelect: function(rec) {
				//FSAuthInfo.TypeCode = rec.code;
			}
		});
		
		$('#inputAppointStatus').combobox({
			valueField: 'code',
			textField: 'text',
			data: [{
				code: 'N',
				text: '未批准',
				selected: true
			}, {
				code: 'F',
				text: '已批准'
			}, {
				code: 'R',
				text: '已拒绝'
			}],
			panelHeight: 'auto',
			editable: false
		});
		
		$('#btnSearch').on('click', function(){
			searchAuthInfo();
		});
		
		$('#btnReset').on('click', function() {
			setDefaultDate();
			$('#inputRequestAct').combobox('select','REVOKE');
			$('#inputAppointStatus').combobox('select','N');
			$('#inputMedRecord').val('');
			$('#inputPatientName').val('');
		});
		
		$('#authListTable').datagrid({
			url: '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls',
			queryParams: {
				Action: 'applylist',
				RequestAct: '',
				AppointStatus: '',
				StartDate: '',
				EndDate: '',
				MedRecordNo: '',
				Name: '',
				UserLocID: userLocID
			},
			method: 'post',
			fit: true,
			singleSelect: true,
			rownumbers: true,
			toolbar: '#authListTableToolbar',
			loadMsg: FSAuthInfo.Config.LOADING_INFO,
			pagination: true,
			pageSize: FSAuthInfo.Config.PAGESIZE,
			pageList: FSAuthInfo.Config.PAGELIST,
			columns: [[
				{ field: 'AuthorizationID', title: 'AuthorizationID', width: 70, hidden: true },
				{ field: 'AppointStatusDesc', title: '审批状态', width: 70 },
				{ field: 'RequestTypeDesc', title: '申请类型', width: 80 },
				{ field: 'PrintStatusDesc', title: '是否打印', width: 70, hidden: true },
				{ field: 'MRCurrentStepDesc', title: '病历状态', width: 70, hidden: true },
				{ field: 'EpisodeID', title: 'EpisodeID', width: 70, hidden: true },
				{ field: 'MedRecordNo', title: '病案号', width: 80, sortable: true },
				{ field: 'RegNo', title: '登记号', width: 80, sortable: true },
				{ field: 'Name', title: '患者姓名', width: 70 },
				{ field: 'DisDate', title: '出院日期', width: 70 },
				{ field: 'DisTime', title: '出院时间', width: 70 },
				{ field: 'PAAdmDepDesc', title: '出院科室', width: 120 },
				{ field: 'RequestUserName', title: '申请人', width: 70 },
				{ field: 'RequestDept', title: '申请人科室', width: 120 },
				{ field: 'RequestDate', title: '申请日期', width: 70 },
				{ field: 'RequestTime', title: '申请时间', width: 70 },
				{ field: 'RequestComment', title: '申请原因', width: 150 },
				{ field: 'AppointUserName', title: '审批人', width: 70 },
				{ field: 'AppointDate', title: '审批日期', width: 70 },
				{ field: 'AppointTime', title: '审批时间', width: 70 },
				{ field: 'AppointComment', title: '审批内容', width: 150 }
			]],
			onSelect: function(index,row) {
				FSAuthInfo.SelectAuthInfo = row.AuthorizationID;
			}
		});
		
		$('#btnApprove').on('click', function() {
			if (FSAuthInfo.SelectAuthInfo !== '') {
				var obj = $.ajax({
					url: '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls?Action=approverecall&AuthInfoID=' + FSAuthInfo.SelectAuthInfo + '&UserID=' + userID,
					type: 'post',
					async: false
				});
				FSAuthInfo.SelectAuthInfo = '';
				var ret = obj.responseText;
				if (ret != '1') {
					$.messager.alert(FSAuthInfo.Config.ERROR_INFO,FSAuthInfo.Config.ERROR_INFO_ACTION,'error');
					return;
				}
				else {
					searchAuthInfo();
				}
			}
			else {
				$.messager.alert(FSAuthInfo.Config.ERROR_INFO,FSAuthInfo.Config.ERROR_INFO_NOAUTHINFOSELECTED,'error');
				return;
			}
		});
		
		//拒绝申请
		$('#btnReject').on('click', function () {
			if (FSAuthInfo.SelectAuthInfo !== '') {
				$('#txtAppointUser').text(userName);
				var currDate = new Date();
				$('#txtAppointDate').text(myformatter(currDate) + ' ' + timeformatter(currDate));
				$('#dlgReject').dialog('open');
			}
			else {
				$.messager.alert(FSAuthInfo.Config.ERROR_INFO,FSAuthInfo.Config.ERROR_INFO_NOAUTHINFOSELECTED,'error');
				return;
			}
		});
		
		$('#dlgReject').dialog({
			title: '拒绝申请',
			modal: true,
			closed: true,
			buttons: '#btnpanel'
		});
		
		$('#btnConfirm').on('click', function() {
			if (FSAuthInfo.SelectAuthInfo !== '') {
				var reason = $('#inputRejectReason').val();
				var obj = $.ajax({
					url: '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls',
					data: {
						Action: 'reject',
						AuthInfoID: FSAuthInfo.SelectAuthInfo,
						UserID: userID,
						Reason: reason
					},
					type: 'post',
					async: false
				});
				FSAuthInfo.SelectAuthInfo = '';
				var ret = obj.responseText;
				if (ret != '1') {
					$.messager.alert(FSAuthInfo.Config.ERROR_INFO,FSAuthInfo.Config.ERROR_INFO_ACTION,'error');
					return;
				}
				else {
					$('#dlgReject').dialog('close');
					searchAuthInfo();
				}
			}
		});
		
		//取消
		$('#btnCancel').on('click', function() {
			$('#dlgReject').dialog('close');
		});
		
		//召回原因
		$('#btnConfigReason').on('click', function() {
			$('#dlgConfigReason').dialog('open');
		});
		
		$('#dlgConfigReason').dialog({
			title: '病历召回原因维护',
			modal: true,
			closed: true
		});
		
		$('#reasonListTable').datagrid({
			url: '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls',
			queryParams: {
				Action: 'loadrecallreason',
				UserID: 'SYS',
				ReasonType: 'grid'
			},
			method: 'post',
			fit: true,
			singleSelect: true,
			rownumbers: true,
			fitColumns: true,
			toolbar: '#reasonListTableToolbar',
			columns: [[
				{ field: 'CategoryDesc', title: '标题', width: 40 },
				{ field: 'Reason', title: '内容', width: 80 }
			]],
			onSelect: function(index,row) {
				FSAuthInfo.SelectReasonID = row['CategoryID'];
				$('#inputReasonDesc').val(row['CategoryDesc']);
				var reason = decodeText(row['Reason']);
				$('#inputReason').val(reason);
			}
		});
		
		$('#btnAddReason').on('click', function() {
			var inputText = $('#inputReasonDesc').val();
			inputText = inputText.replace(/^\s*|\s*$/g,'');  //去除两端空格
			if (inputText == '') {
				$.messager.alert('提示','请填写标题。','info');
				return;
			}
			var reason = encodeText($('#inputReason').val());
			if (reason == '') {
				$.messager.alert('提示','请填写内容。','info');
				return;
			}
			var obj = $.ajax({
				url: '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls',
				data: {
					Action: 'addrecallreason',
					UserID: 'SYS',
					CategoryDesc: inputText,
					Reason: reason
				},
				type: 'post',
				async: false
			});
			var ret = obj.responseText;
			if (ret === '1') {
				FSAuthInfo.SelectReasonID = '';
				$('#inputReasonDesc').val('');
				$('#inputReason').val('');
				$('#reasonListTable').datagrid('reload');
			}
			else {
				$.messager.alert(FSAuthInfo.Config.ERROR_INFO,FSAuthInfo.Config.ERROR_INFO_ACTION,'error');
			}
		});
		
		$('#btnSaveReason').on('click', function() {
			if (FSAuthInfo.SelectReasonID == '') {
				$.messager.alert('提示','请选中一行数据。','info');
				return;
			}
			var reason = encodeText($('#inputReason').val());
			var obj = $.ajax({
				url: '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls',
				data: {
					Action: 'saverecallreason',
					CategoryID: FSAuthInfo.SelectReasonID,
					Reason: reason
				},
				type: 'post',
				async: false
			});
			var ret = obj.responseText;
			if (ret === '1') {
				FSAuthInfo.SelectReasonID = '';
				$('#inputReasonDesc').val('');
				$('#inputReason').val('');
				$('#reasonListTable').datagrid('reload');
			}
			else {
				$.messager.alert(FSAuthInfo.Config.ERROR_INFO,FSAuthInfo.Config.ERROR_INFO_ACTION,'error');
			}
		});
		
		$('#btnRemoveReason').on('click', function() {
			if (FSAuthInfo.SelectReasonID == '') {
				$.messager.alert('提示','请选中一行数据。','info');
				return;
			}
			var obj = $.ajax({
				url: '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls?Action=removerecallreason&CategoryID=' + FSAuthInfo.SelectReasonID,
				type: 'post',
				async: false
			});
			var ret = obj.responseText;
			if (ret === '1') {
				FSAuthInfo.SelectReasonID = '';
				$('#inputReasonDesc').val('');
				$('#inputReason').val('');
				$('#reasonListTable').datagrid('reload');
			}
			else {
				$.messager.alert(FSAuthInfo.Config.ERROR_INFO,FSAuthInfo.Config.ERROR_INFO_ACTION,'error');
			}
		});
		
		function searchAuthInfo() {
			var url = '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls';
			$('#authListTable').datagrid('options').url = url;
			var queryParams = $('#authListTable').datagrid('options').queryParams;
			queryParams.RequestAct = $('#inputRequestAct').combobox('getValue');
			queryParams.AppointStatus = $('#inputAppointStatus').combobox('getValue');
			queryParams.StartDate = FSAuthInfo.StartDate;
			queryParams.EndDate = FSAuthInfo.EndDate;
			queryParams.MedRecordNo = $('#inputMedRecord').val();
			queryParams.Name = $('#inputPatientName').val();
			$('#authListTable').datagrid('options').queryParams = queryParams;
			$('#authListTable').datagrid('reload');
		}
		
		//设置默认时间
		function setDefaultDate() {
			var currDate = new Date();
			$('#inputStartDate').datebox('setValue', myformatter1(currDate, FSAuthInfo.Config.DATESPAN));
			$('#inputEndDate').datebox('setValue', myformatter(currDate));
			FSAuthInfo.StartDate = $('#inputStartDate').datebox('getValue');
			FSAuthInfo.EndDate = $('#inputEndDate').datebox('getValue');
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
		
		function timeformatter(date) {
			var h = date.getHours();
			var m = date.getMinutes();
			var s = date.getSeconds();
			return (h < 10 ? ('0' + h) : h) + ':' + (m < 10 ? ('0' + m) : m) + ':' + (s < 10 ? ('0' + s) : s);
		}
		
		function encodeText(str) {
			var result = str.replace(/\n/g,'<br />');
			return result;
		}
		
		function decodeText(str) {
			var result = str.replace(/<br \/>/g,'\n');
			return result;
		}
	});
}(window));