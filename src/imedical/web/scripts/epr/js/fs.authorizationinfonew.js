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
	ERROR_INFO_NOAUTHINFOSELECTED: '请先选中一条申请'
};

(function(win) {
	$(function() {
		$g = window.$g || function(a){return a;};
		if (reasonFlag == '0') {
			$('#btnConfigReason').hide();
		}
		
		$('#dbStartDate').datebox({
			onSelect: function() {
				FSAuthInfo.StartDate = $('#dbStartDate').datebox('getValue');
			},
			onChange: function() {
				FSAuthInfo.StartDate = $('#dbStartDate').datebox('getValue');
			}
		});
		
		$('#dbEndDate').datebox({
			onSelect: function() {
				FSAuthInfo.EndDate = $('#dbEndDate').datebox('getValue');
			},
			onChange: function() {
				FSAuthInfo.EndDate = $('#dbEndDate').datebox('getValue');
			}
		});
		setDefaultDate();
		
		$('#cbbRequestAct').combobox({
			valueField: 'code',
			textField: 'text',
			data: [{
				code: 'REVOKE',
				text: $g('病历召回'),
				selected: true
			}, {
				code: 'SCAN',
				text: $g('病历扫描')
			}],
			panelHeight: 'auto',
			editable: false,
			onSelect: function(rec) {
				//FSAuthInfo.TypeCode = rec.code;
			}
		});
		
		$('#cbbAppointStatus').combobox({
			valueField: 'code',
			textField: 'text',
			data: [{
				code: 'N',
				text: $g('未批准'),
				selected: true
			}, {
				code: 'F',
				text: $g('已批准')
			}, {
				code: 'R',
				text: $g('已拒绝')
			}],
			panelHeight: 'auto',
			editable: false
		});
		
		$('#btnSearch').on('click', function(){
			searchAuthInfo();
		});
		
		$('#btnReset').on('click', function() {
			setDefaultDate();
			$('#cbbRequestAct').combobox('select','REVOKE');
			$('#cbbAppointStatus').combobox('select','N');
			$('#tbMRNo').val('');
			$('#tbPatName').val('');
		});
		
		$HUI.datagrid('#authlist',{
			fit: true,
			border: false,
			toolbar: '#authtoolbar',
			url: $URL,
			queryParams: {
				ClassName: 'DHCEPRFS.BL.BLAuthorization',
				QueryName: 'GetApplyList',
				ARequestAct: '',
				AStatus: '',
				AStartDate: '',
				AEndDate: '',
				AMedRecordNo: '',
				AName: '',
				AUserLocID: userLocID
			},
			rownumbers: true,
			singleSelect: true,
			pagination: true,
			pageSize: FSAuthInfo.Config.PAGESIZE,
			pageList: FSAuthInfo.Config.PAGELIST,
			columns: [[
				{field:'AuthorizationID',title:'AuthorizationID',width:80,hidden:true},
				{field:'AppointStatusDesc',title:'审批状态',width:80},
				{field:'RequestTypeDesc',title:'申请类型',width:80},
				{field:'PrintStatusDesc',title:'是否打印',width:80,hidden:true},
				{field:'MRCurrentStepDesc',title:'病历状态',width:80,hidden:true},
				{field:'EpisodeID',title:'EpisodeID',width:80,hidden:true},
				{field:'MedRecordNo',title:'病案号',width:100,sortable:true},
				{field:'RegNo',title:'登记号',width:100,sortable:true},
				{field:'Name',title:'患者姓名',width:80},
				{field:'DisDate',title:'出院日期',width:100},
				{field:'DisTime',title:'出院时间',width:100},
				{field:'PAAdmDepDesc',title:'出院科室',width:150},
				{field:'RequestUserName',title:'申请人',width:80},
				{field:'RequestDept',title:'申请人科室',width:150},
				{field:'RequestDate',title:'申请日期',width:100},
				{field:'RequestTime',title:'申请时间',width:100},
				{field:'RequestComment',title:'申请原因',width:200},
				{field:'AppointUserName',title:'审批人',width:80},
				{field:'AppointDate',title:'审批日期',width:100},
				{field:'AppointTime',title:'审批时间',width:100},
				{field:'AppointComment',title:'审批内容',width:200}
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
				$.messager.popover({msg:FSAuthInfo.Config.ERROR_INFO_NOAUTHINFOSELECTED,type:'alert',timeout:2000});
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
				$.messager.popover({msg:FSAuthInfo.Config.ERROR_INFO_NOAUTHINFOSELECTED,type:'alert',timeout:2000});
				return;
			}
		});
		
		$('#dlgReject').dialog({
			title: '拒绝申请',
			iconCls: 'icon-w-edit',
			closed: true,
			modal: true,
			buttons: [{
				text: '确认',
				handler: function() {
					rejectAuth();
				}
			},{
				text: '取消',
				handler: function() {
					$('#dlgReject').dialog('close');
				}
			}]
		});
		
		function rejectAuth() {
			if (FSAuthInfo.SelectAuthInfo !== '') {
				var reason = encodeText($('#taRejectReason').val());
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
		}
		
		//召回原因
		$('#btnConfigReason').on('click', function() {
			$('#dlgConfigReason').dialog('open');
		});
		
		$('#dlgConfigReason').dialog({
			title: '召回原因维护',
			iconCls: 'icon-w-config',
			closed: true,
			modal: true
		});
		
		$HUI.datagrid('#reasonlist',{
			title: '召回原因列表',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			fit: true,
			toolbar: '#reasontoolbar',
			url: '../DHCEPRFS.web.eprajax.AjaxAuthorizationInfo.cls',
			queryParams: {
				Action: 'loadrecallreason',
				UserID: 'SYS',
				ReasonType: 'grid'
			},
			rownumbers: true,
			singleSelect: true,
			fitColumns: true,
			columns: [[
				{field:'CategoryDesc',title:'标题',width:40},
				{field:'Reason',title:'内容',width:80}
			]],
			onSelect: function(index,row) {
				FSAuthInfo.SelectReasonID = row['CategoryID'];
				$('#tbReasonDesc').val(row['CategoryDesc']);
				var reason = decodeText(row['Reason']);
				$('#tbReason').val(reason);
			}
		});
		
		$('#btnAddReason').on('click', function() {
			var inputText = $('#tbReasonDesc').val();
			inputText = inputText.replace(/^\s*|\s*$/g,'');  //去除两端空格
			if (inputText == '') {
				$.messager.popover({msg:'请填写标题。',type:'info',timeout:2000});
				return;
			}
			var reason = encodeText($('#tbReason').val());
			if (reason == '') {
				$.messager.popover({msg:'请填写内容。',type:'info',timeout:2000});
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
				$('#tbReasonDesc').val('');
				$('#tbReason').val('');
				$('#reasonlist').datagrid('reload');
			}
			else {
				$.messager.alert(FSAuthInfo.Config.ERROR_INFO,FSAuthInfo.Config.ERROR_INFO_ACTION,'error');
			}
		});
		
		$('#btnSaveReason').on('click', function() {
			if (FSAuthInfo.SelectReasonID == '') {
				$.messager.popover({msg:'请选中一行数据。',type:'info',timeout:2000});
				return;
			}
			var reason = encodeText($('#tbReason').val());
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
				$('#tbReasonDesc').val('');
				$('#tbReason').val('');
				$('#reasonlist').datagrid('reload');
			}
			else {
				$.messager.alert(FSAuthInfo.Config.ERROR_INFO,FSAuthInfo.Config.ERROR_INFO_ACTION,'error');
			}
		});
		
		$('#btnRemoveReason').on('click', function() {
			if (FSAuthInfo.SelectReasonID == '') {
				$.messager.popover({msg:'请选中一行数据。',type:'info',timeout:2000});
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
				$('#tbReasonDesc').val('');
				$('#tbReason').val('');
				$('#reasonlist').datagrid('reload');
			}
			else {
				$.messager.alert(FSAuthInfo.Config.ERROR_INFO,FSAuthInfo.Config.ERROR_INFO_ACTION,'error');
			}
		});
		
		function searchAuthInfo() {
			var queryParams = $('#authlist').datagrid('options').queryParams;
			queryParams.ARequestAct = $('#cbbRequestAct').combobox('getValue');
			queryParams.AStatus = $('#cbbAppointStatus').combobox('getValue');
			queryParams.AStartDate = FSAuthInfo.StartDate;
			queryParams.AEndDate = FSAuthInfo.EndDate;
			queryParams.AMedRecordNo = $('#tbMRNo').val();
			queryParams.AName = $('#tbPatName').val();
			$('#authlist').datagrid('options').queryParams = queryParams;
			$('#authlist').datagrid('reload');
		}
		
		//设置默认时间
		function setDefaultDate() {
			var currDate = new Date();
			$('#dbStartDate').datebox('setValue', myformatter1(currDate, FSAuthInfo.Config.DATESPAN));
			$('#dbEndDate').datebox('setValue', myformatter(currDate));
			FSAuthInfo.StartDate = $('#dbStartDate').datebox('getValue');
			FSAuthInfo.EndDate = $('#dbEndDate').datebox('getValue');
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