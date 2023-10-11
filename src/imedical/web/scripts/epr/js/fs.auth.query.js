var FSAuthorization = new Object();

FSAuthorization.dateStart = '';
FSAuthorization.dateEnd = '';
FSAuthorization.typeCode = '';
FSAuthorization.spanTime = '';

FSAuthorization.opID = '1';
FSAuthorization.DATESPAN = 7;
FSAuthorization.DialogType = 'R';

(function($) {
	$(function() {
		//--------------------授权列表--------------------
		//授权列表查询 - 起始日期
		$('#inputDateStart').datebox({
			onSelect: function() {
				FSAuthorization.dateStart = $('#inputDateStart').datebox('getValue');
			},
			onChange: function() {  //避免不选择日期而采用输入的方式
				FSAuthorization.dateStart = $('#inputDateStart').datebox('getValue');
			}
		}); 
		
		//授权列表查询 - 截止日期
		$('#inputDateEnd').datebox({
			onSelect: function() {
				FSAuthorization.dateEnd = $('#inputDateEnd').datebox('getValue');
			},
			onChange: function() {  //避免不选择日期而采用输入的方式
				FSAuthorization.dateEnd = $('#inputDateEnd').datebox('getValue');
			}
		});
		
		setApplyDefaultDate();
		
		//授权列表
		$('#authorizationListTable').datagrid({
			url: '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls',
			queryParams: {
				Action: 'getlist',
				ApplyStatus: 'N',
				ApplyStartDate: '',
				ApplyEndDate: ''
			},
			method: 'post',
			loadMsg: '数据装载中......',
			singleSelect: false,
			rownumbers: true,
			//toolbar: '#authorizationListTableTBar',
			pagination: true,
			pageSize: 20,
			pageList: [10, 20, 50],
			columns: [[
				{ field: 'ck', checkbox: true },
				{ field: 'AuthorizationID', title: 'AuthorizationID', width: 80, hidden: true },
				{ field: 'RequestUserID', title: 'RequestUserID', width: 80, hidden: true },
				{ field: 'RequestUserName', title: '申请人', width: 80 },
				{ field: 'RequestDeptID', title: 'RequestDeptID', width: 80, hidden: true },
				{ field: 'RequestDept', title: '申请人科室', width: 80, hidden: true },
				{ field: 'RequestSSGroupID', title: 'RequestSSGroupID', width: 80, hidden: true },
				{ field: 'RequestSSGroup', title: '申请人安全组', width: 80, hidden: true },
				{ field: 'RequestDate', title: '申请日期', width: 80 },
				{ field: 'RequestTime', title: '申请时间', width: 80 },
				{ field: 'RequestReason', title: '申请原因', width: 150 },
				{ field: 'RequestTimeSpan', title: '申请时长(小时)', width: 90 },
				{ field: 'AppointUserID', title: 'AppointUserID', width: 80, hidden: true },
				{ field: 'AppointUserName', title: '批准人', width: 80 },
				{ field: 'AppointDate', title: '批准日期', width: 80 },
				{ field: 'AppointTime', title: '批准时间', width: 80 },
				{ field: 'AppointEndDate', title: '批准到期日期', width: 80 },
				{ field: 'AppointEndTime', title: '批准到期时间', width: 80 },
				{ field: 'RoleID', title: 'RoleID', width: 80, hidden: true },
				{ field: 'RoleCode', title: '分配角色代码', width: 80 },
				{ field: 'RoleDesc', title: '分配角色', width: 80 },
				{ field: 'OperationID', title: 'OperationID', width: 80, hidden: true },
				{ field: 'OperationCode', title: '操作类型代码', width: 80, hidden: true },
				{ field: 'OperationDesc', title: '操作类型描述', width: 80 },
				{ field: 'EPRAction', title: '分配权限类型代码', width: 80, hidden: true },
				{ field: 'EPRActionDesc', title: '分配权限类型', width: 80 },
				{ field: 'AppointType', title: 'AppointType', width: 80, hidden: true },
				{ field: 'AppointStatus', title: '授权状态代码', width: 80, hidden: true },
				{ field: 'AppointStatusDesc', title: '授权状态', width: 80, formatter: formatStatusDesc },
				{ field: 'AppointComment', title: '被拒绝或取消原因', width: 200 },
				{ field: 'HasAdvancedSecurity', title: 'HasAdvancedSecurity', width: 80, hidden: true }
			]],
			rowStyler: function(index,row) {
				if (row.HasAdvancedSecurity == 'Y') {
					return 'background-color:pink;color:blue;font-weight:bold;';
				}
			},
			view: detailview,
			detailFormatter: function(index,row) {
				return '<div style="padding:2px"><table class="ddv" id="ddv-' + index + '"></table></div>';
			},
			onClickRow: function(rowIndex, rowData) {
				//点击即展开
				$('#authorizationListTable').datagrid('expandRow',rowIndex);
			},
			onExpandRow: function(index,row) {
				//展开即选中
				$('#applyListTable').datagrid('selectRow', index);
				$('#ddv-' + index).datagrid({
					url: '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls',
					queryParams: {
						Action: 'applylistdetail',
						AuthorizationID: row.AuthorizationID
					},
					method: 'post',
					height: 'auto',
					loadMsg: '数据装载中......',
					singleSelect: true,
					rownumbers: true,
					columns:[[
						{ field: 'AuthorizationID', title:'AuthorizationID', width: 80, hidden: true },
						{ field: 'AuthorizationDetailID', title:'AuthorizationDetailID', width: 80, hidden: true },
						{ field: 'PAStatusType', title: '状态', width: 60 },
						{ field: 'PAAdmType', title: '就诊类型', width: 60 },
						{ field: 'MedRecordNo', title:'病案号', width: 80 },
						{ field: 'RegNo', title:'登记号', width: 80 },
						{ field: 'PAPMIName', title: '病人姓名', width: 80 },
						{ field: 'PADischgeDate', title: '出院日期', width: 80 },
						{ field: 'PADischgeTime', title: '出院时间', width: 80 },
						{ field: 'PAAdmLoc', title: '科室', width: 120 },
						{ field: 'PAAdmWard', title: '病区', width: 120 },
						{ field: 'PAAdmDoc', title: '医生', width: 80 },
						{ field: 'PAAdmDate', title: '入院日期', width: 80 },
						{ field: 'PAAdmTime', title: '入院时间', width: 80 },
						{ field: 'PAPMIDOB', title: '出生日期', width: 80 },
						{ field: 'PAPMIAge', title: '年龄', width: 60 },
						{ field: 'PAPMISex', title: '性别', width: 60 },
						{ field: 'PayMode', title: '付费类型', width: 120 },
						{ field: 'EpisodeID', title:'就诊号', width: 80, hidden: true },
						{ field: 'PatientID', title:'病人号', width: 80, hidden: true },
						{ field: 'IsAdvancedSecurity', title: 'IsAdvancedSecurity', width: 80, hidden: true }
					]],
					rowStyler: function(index,row) {
						if (row.IsAdvancedSecurity == '1') {
							return 'background-color:pink;color:blue;font-weight:bold;';
						}
					},
					onResize: function() {
						$('#authorizationListTable').datagrid('fixDetailRowHeight',index);
					},
					onLoadSuccess: function() {
						setTimeout(function() {
							$('#authorizationListTable').datagrid('fixDetailRowHeight',index);
						},0);
					}
				});
				$('#authorizationListTable').datagrid('fixDetailRowHeight',index);
			}
		});
		
		//授权类型
		$('#inputType').combobox({
			valueField: 'code',
			textField: 'text',
			editable: false,
			data: [{
				code: 'N',
				text: '未批准'
			}, {
				code: 'F',
				text: '已批准'
			}, {
				code: 'R',
				text: '已拒绝'
			}, {
				code: 'I',
				text: '已过期'
			}],
			onLoadSuccess: function() {
				var typeData = $('#inputType').combobox('getData');
				$('#inputType').combobox('select', typeData[0].code);
			},
			onSelect: function(rec) {
				FSAuthorization.typeCode = rec.code;
				//按钮显示隐藏
				if (rec.code == 'N') {
					$('#assignRoleBtn').show();
					$('#cancelBtn').hide();
					$('#rejectBtn').show();
				}
				else if (rec.code == 'F') {
					$('#assignRoleBtn').hide();
					$('#rejectBtn').hide();
					$('#cancelBtn').show();
				}
				else {
					$('#assignRoleBtn').hide();
					$('#rejectBtn').hide();
					$('#cancelBtn').hide();
				}
				//查询
				refreshGrid();
			}
		});
		
		//授权时长
		$('#inputSpan').combobox({
			valueField: 'code',
			textField: 'text',
			editable: false,
			data: [{
				code: 'A',
				text: '申请时长'
			},{
				code: '12',
				text: '12小时'
			}, {
				code: '24',
				text: '24小时'
			}, {
				code: '48',
				text: '48小时'
			}, {
				code: '72',
				text: '72小时'
			}, {
				code: '96',
				text: '4天'
			}, {
				code: '120',
				text: '5天'
			}, {
				code: '192',
				text: '8天'
			}, {
				code: '240',
				text: '10天'
			}, {
				code: '360',
				text: '15天'
			}],
			onLoadSuccess: function() {
				var spanData = $('#inputSpan').combobox('getData');
				$('#inputSpan').combobox('select', spanData[0].code);
			},
			onSelect: function(rec) {
				FSAuthorization.spanTime = rec.code;
			}
		});
		
		//查询
		$('#searchBtn').on('click', function() {
			refreshGrid();
		});
		
		//清空条件
		$('#resetBtn').on('click', function() {
			setApplyDefaultDate();
			$('#inputSpan').combobox('select','A');
			$('#inputType').combobox('select','N');
		});
		
		function setApplyDefaultDate() {
			var currDate = new Date();
			$('#inputDateStart').datebox('setValue',myformatter1(currDate,FSAuthorization.DATESPAN));
			$('#inputDateEnd').datebox('setValue',myformatter(currDate));
			FSAuthorization.dateStart = $('#inputDateStart').datebox('getValue');
			FSAuthorization.dateEnd = $('#inputDateEnd').datebox('getValue');
		}
		
		//刷新授权列表
		function refreshGrid() {
			var queryParams = $('#authorizationListTable').datagrid('options').queryParams;
			queryParams.Action = 'getlist';
			queryParams.ApplyStatus = FSAuthorization.typeCode;
			queryParams.ApplyStartDate = FSAuthorization.dateStart;
			queryParams.ApplyEndDate = FSAuthorization.dateEnd;
			$('#authorizationListTable').datagrid('options').queryParams = queryParams;
			$('#authorizationListTable').datagrid('reload');
			
			//隐藏列，显示列
			if (FSAuthorization.typeCode == 'N') {
				//未授权，隐藏授权人等信息
				$('#authorizationListTable').datagrid('hideColumn','AppointUserName');
				$('#authorizationListTable').datagrid('hideColumn','AppointDate');
				$('#authorizationListTable').datagrid('hideColumn','AppointTime');
				$('#authorizationListTable').datagrid('hideColumn','AppointEndDate');
				$('#authorizationListTable').datagrid('hideColumn','AppointEndTime');
				$('#authorizationListTable').datagrid('hideColumn','RoleCode');
				$('#authorizationListTable').datagrid('hideColumn','RoleDesc');
				$('#authorizationListTable').datagrid('hideColumn','OperationDesc');
				$('#authorizationListTable').datagrid('hideColumn','AppointComment');
			}
			else if(FSAuthorization.typeCode == 'F') {
				$('#authorizationListTable').datagrid('showColumn','AppointUserName');
				$('#authorizationListTable').datagrid('showColumn','AppointDate');
				$('#authorizationListTable').datagrid('showColumn','AppointTime');
				$('#authorizationListTable').datagrid('showColumn','AppointEndDate');
				$('#authorizationListTable').datagrid('showColumn','AppointEndTime');
				$('#authorizationListTable').datagrid('showColumn','RoleCode');
				$('#authorizationListTable').datagrid('showColumn','RoleDesc');
				$('#authorizationListTable').datagrid('showColumn','OperationDesc');
				$('#authorizationListTable').datagrid('hideColumn','AppointComment');
			}
			else {
				$('#authorizationListTable').datagrid('showColumn','AppointUserName');
				$('#authorizationListTable').datagrid('showColumn','AppointDate');
				$('#authorizationListTable').datagrid('showColumn','AppointTime');
				$('#authorizationListTable').datagrid('showColumn','AppointEndDate');
				$('#authorizationListTable').datagrid('showColumn','AppointEndTime');
				$('#authorizationListTable').datagrid('showColumn','RoleCode');
				$('#authorizationListTable').datagrid('showColumn','RoleDesc');
				$('#authorizationListTable').datagrid('showColumn','OperationDesc');
				$('#authorizationListTable').datagrid('showColumn','AppointComment');
			}
		}
		
		//分配角色
		$('#assignRoleBtn').on('click', function() {
			//var roleRows = $('#roleListTable').datagrid('getSelections');
			//if (roleRows.length <= 0) {
			var authorizationRows = $('#authorizationListTable').datagrid('getSelections');
			if (defaultRoleID == '') {
				$.messager.alert('错误','未设置默认角色，请联系管理员！','error');
				return;
			}
			else if (authorizationRows.length <= 0) {
				$.messager.alert('错误','请先选择一个授权！','error');
				return;
			}
			else {
				//var roleID = roleRows[0].RoleID;
				var roleID = defaultRoleID;
				var authorizationIDList = '';
				var spanTimeList = '';
				for (var i=0;i<authorizationRows.length;i++) {
					var authorizationID = authorizationRows[i].AuthorizationID;
					if (authorizationIDList == '') {
						authorizationIDList = authorizationID;
					}
					else {
						authorizationIDList = authorizationIDList + '^' + authorizationID;
					}
					var spanTime = authorizationRows[i].RequestTimeSpan;
					if (FSAuthorization.spanTime != 'A') {
						spanTime = FSAuthorization.spanTime;
					}
					if (spanTimeList == '') {
						spanTimeList = spanTime;
					}
					else {
						spanTimeList = spanTimeList + '^' + spanTime;
					}
				}
				var obj = $.ajax({
					url: '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls',
					data: {
						Action: 'adduserrole',
						RoleID: roleID,
						OpID: FSAuthorization.opID,
						AuthorizationIDList: authorizationIDList,
						UserID: appointUserID,
						SpanTimeList: spanTimeList
					},
					type: 'post',
					async: false
				});
				var ret = obj.responseText;
				if (parseInt(ret) > 0) {
					$.messager.alert('提示','分配用户角色成功！','info',function() {
						refreshGrid();
					});
				}
				else {
					$.messager.alert('错误','分配用户角色失败，请重新尝试！','error');
					return;
				}
			}
		});
		
		//拒绝申请/提前结束弹窗
		$('#rejectDialog').dialog({
			title: '拒绝申请/提前结束',
			closed: true,
			cache: false,
			modal: true,
			buttons:[{
				text: '确认',
				iconCls: 'icon-ok',
				handler: function() {
					var rejectAction = 'reject';
					var rejectText = '拒绝申请';
					if (FSAuthorization.DialogType == 'C') {
						rejectAction = 'cancel';
						rejectText = '提前结束';
					}
					var reason = $('#inputReason').val();
					if (reason == '') {
						$.messager.alert('提示','请填写' + rejectText + '原因','info');
						return;
					}
					var authorizationRows = $('#authorizationListTable').datagrid('getSelections');
					var authorizationIDList = '';
					for (var i=0;i<authorizationRows.length;i++) {
						var authorizationID = authorizationRows[i].AuthorizationID;	
						if (authorizationIDList == '') {
							authorizationIDList = authorizationID;
						}
						else {
							authorizationIDList = authorizationIDList + '^' + authorizationID;
						}
					}
					var obj = $.ajax({
						url: '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls',
						data: {
							Action: rejectAction,
							Reason: reason,
							AuthorizationIDList: authorizationIDList,
							UserID: appointUserID
						},
						type: 'post',
						async: false
					});
					var ret = obj.responseText;
					if (parseInt(ret) > 0) {
						$.messager.alert('提示',rejectText + '授权成功！','info',function() {
							refreshGrid();
							$('#rejectDialog').dialog('close');
						});
					}
					else {
						$.messager.alert('错误',rejectText + '授权失败，请重新尝试！','error');
						return;
					}
				}
			},{
				text: '取消',
				iconCls: 'icon-cancel',
				handler: function() {
					$('#rejectDialog').dialog('close');
				}
			}]
		});
		
		//拒绝申请
		$('#rejectBtn').on('click', function() {
			var authorizationRows = $('#authorizationListTable').datagrid('getSelections');
			if (authorizationRows.length <= 0) {
				$.messager.alert('错误','请先选择一个授权！','error');
				return;
			}
			FSAuthorization.DialogType = 'R';
			$('#rejectDialog').dialog('open');
		});
		
		//提前结束
		$('#cancelBtn').on('click', function() {
			var authorizationRows = $('#authorizationListTable').datagrid('getSelections');
			if (authorizationRows.length <= 0) {
				$.messager.alert('错误','请先选择一个授权！','error');
				return;
			}
			FSAuthorization.DialogType = 'C';
			$('#rejectDialog').dialog('open');
		});
				
		//--------------------formatter--------------------
		function formatStatusDesc(value,row,index) {
			var status = row.AppointStatus;
			if (status == 'N') {
				return '<font color="#AAAAFF">' + value + '</font>';
			}
			else if (status == 'F') {
				return '<font color="#00A600">' + value + '</font>';
			}
			else if (status == 'R') {
				return '<font color="#FF9797">' + value + '</font>';
			}
			else if (status == 'D') {
				return '<font color="#7B7B7B">' + value + '</font>';
			}
			else if (status == 'I') {
				return '<font color="#7B7B7B">' + value + '</font>';
			}
		}
		
		function formatPrivateDomainDesc(value,row,index) {
			var privacyDomainLevel = row.PrivateDomainLevel;
			if (privacyDomainLevel == '0') {
				return '<font color="#00A600">' + value + '</font>';
			}
			else if (privacyDomainLevel == '1') {
				return '<font color="#FF9797">' + value + '</font>';
			}
		}
		
		function myformatter(date) {
			var y = date.getFullYear();
			var m = date.getMonth()+1;
			var d = date.getDate();
			return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
		}
		
		function myformatter1(date, span) {
			var d = date.getDate() - span;
			var tmp = new Date();
			tmp.setDate(d);
			var y = tmp.getFullYear();
			var m = tmp.getMonth()+1;
			d = tmp.getDate();
			return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
		}
		
	});
})(jQuery);
