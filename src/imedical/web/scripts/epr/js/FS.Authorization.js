var FSAuthorization = new Object();

FSAuthorization.dateStart = '';
FSAuthorization.dateEnd = '';
FSAuthorization.typeCode = '';
FSAuthorization.spanTime = '';

FSAuthorization.opID = '';
FSAuthorization.opCode = '';
FSAuthorization.opDesc = '';
FSAuthorization.pddID = '';
FSAuthorization.pddDesc = '';

FSAuthorization.HDateStart = '';
FSAuthorization.HDateEnd = '';
FSAuthorization.ViewType = 'A';

FSAuthorization.ADateStart = '';
FSAuthorization.ADateEnd = '';

FSAuthorization.roleID = '';
FSAuthorization.RoleItems = '';
FSAuthorization.ExpandRoleIndex = '';
FSAuthorization.ExpandSSGroupID = '';

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
			toolbar: '#authorizationListTableTBar',
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
			var roleRows = $('#roleListTable').datagrid('getSelections');
			var authorizationRows = $('#authorizationListTable').datagrid('getSelections');
			if (roleRows.length <= 0) {
				$.messager.alert('错误','请先选择一个角色！','error');
				return;
			}
			else if (authorizationRows.length <= 0) {
				$.messager.alert('错误','请先选择一个授权！','error');
				return;
			}
			else {
				var roleID = roleRows[0].RoleID;
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
		
		//--------------------角色列表--------------------
		//角色列表
		$('#roleListTable').datagrid({
			url: '../DHCEPRRBAC.web.eprajax.Role.cls',
			queryParams: {
				Action: 'rolelist'
			},
			method: 'post',
			loadMsg: '数据装载中......',
			singleSelect: true,
			toolbar: '#roleListTableTBar',
			pagination: true,
			pageSize: 20,
			pageList: [10, 20, 50],
			columns: [[
				{ field: 'RoleID', title: '角色ID', width: 80, hidden: true },
				{ field: 'RoleName', title: '角色名称', width: 100 },
				{ field: 'RoleCode', title: '角色代码', width: 80 },
				{ field: 'RoleDesc', title: '角色描述', width: 160 },
				{ field: 'DefaultRole', title: '默认角色', width: 60 }
			]],
			onSelect: function(rowIndex,rowData) {
				FSAuthorization.roleID = rowData.RoleID;
				$('#inputRoleName').val(rowData.RoleName);
				$('#inputRoleCode').val(rowData.RoleCode);
				$('#inputRoleDesc').val(rowData.RoleDesc);
				refreshItemDisplayTable();
			},
			view: detailview,
			detailFormatter: function(index,row) {
				return '<div style="padding:2px"><table class="ddvrole" id="ddvrole-' + index + '"></table></div>';
			},
			onExpandRow: function(index,row) {
				if (parseInt(FSAuthorization.ExpandRoleIndex) != index) {  //折叠其他行已展开的子表
					var rowExpander = $('#roleListTable').datagrid('getExpander',FSAuthorization.ExpandRoleIndex);
					if (rowExpander) {
						$('#roleListTable').datagrid('collapseRow',FSAuthorization.ExpandRoleIndex);
					}
				}
				FSAuthorization.ExpandRoleIndex = index;
				FSAuthorization.ExpandSSGroupID = '';
				$('#roleListTable').datagrid('selectRow',index);  //展开即选中
				$('#ddvrole-' + index).datagrid({
					url:'../DHCEPRRBAC.web.eprajax.Role.cls',
					queryParams: {
						Action: 'rolelistdetail',
						RoleID: row.RoleID
					},
					method: 'post',
					width: 'auto',
					height: 'auto',
					loadMsg: '数据装载中......',
					singleSelect: true,
					rownumbers: true,
					columns: [[
						{ field: 'SSGroupID', title: '安全组ID', width: 70 },
						{ field: 'SSGroupName', title: '安全组名称', width: 240 }
					]],
					onResize: function() {
						$('#roleListTable').datagrid('fixDetailRowHeight',index);
					},
					onLoadSuccess: function() {
						setTimeout(function() {
							$('#roleListTable').datagrid('fixDetailRowHeight',index);
						},0);
					},
					onSelect: function(index,row) {
						FSAuthorization.ExpandSSGroupID = row.SSGroupID;
					}
				});
				$('#roleListTable').datagrid('fixDetailRowHeight',index);
			}
		});
		
		//角色权限内容列表
		$('#roleItemDisplayTable').datagrid({
			//url: '../DHCEPRRBAC.web.eprajax.Role.cls',
			queryParams: {
				Action: 'getroleitempage',
				RoleID: FSAuthorization.roleID
			},
			method: 'post',
			loadMsg: '数据装载中......',
			singleSelect: false,
			rownumbers: true,
			pagination: true,
			pageSize: 20,
			pageList: [10, 20, 50],
			columns: [[
				{ field: 'OperationDesc', title: '操作描述', width: 60 },
				{ field: 'PrivateDomainDesc', title: '隐私域', width: 80, formatter: formatPrivateDomainDesc },
				{ field: 'PrivateDomainLevel', title: '隐私域级别', width: 80, hidden: true },
				{ field: 'ItemID', title: 'ItemID', width: 80, hidden: true },
				{ field: 'ItemName', title: '项目名称', width: 80, hidden: true },
				{ field: 'ItemCode', title: '项目代码', width: 80, hidden: true },
				{ field: 'ItemDesc', title: '项目描述', width: 160 },
				{ field: 'ItemTypeDesc', title: '项目类别', width: 60 }
			]]
		});
		
		//新增角色
		$('#roleAddBtn').on('click', function() {
			var roleName = $('#inputRoleName').val();
			var roleCode = $('#inputRoleCode').val();
			var roleDesc = $('#inputRoleDesc').val();
			if ((roleCode == '') || (roleCode == null)) {
				$.messager.alert('错误','角色代码不能为空！','error');
				return;
			}
			else {
				var obj = $.ajax({
					url: '../DHCEPRRBAC.web.eprajax.Role.cls',
					data: {
						Action: 'addrole',
						RoleName: roleName,
						RoleCode: roleCode,
						RoleDesc: roleDesc
					},
					type: 'post',
					async: false
				});
				var ret = obj.responseText;
				if (ret == '-2') {
					$.messager.alert('错误','角色代码已存在，请修改后重新操作！','error');
					return;
				}
				else if (parseInt(ret) > 0) {
					$.messager.alert('提示','新增角色成功！','info',function() {
						$('#roleListTable').datagrid('reload');
					});
				}
				else {
					$.messager.alert('错误','新增角色失败，请重新尝试！','error');
					return;
				}
				
			}
		});
		
		//修改角色
		$('#roleSaveBtn').on('click', function() {
			var row = $('#roleListTable').datagrid('getSelected');
			if (row) {
				var roleID = row.RoleID;
				var roleName = $('#inputRoleName').val();
				var roleCode = $('#inputRoleCode').val();
				var roleDesc = $('#inputRoleDesc').val();
				if ((roleCode == '') || (roleCode == null)) {
					$.messager.alert('错误','角色代码不能为空！','error');
					return;
				}
				else {
					var obj = $.ajax({
						url: '../DHCEPRRBAC.web.eprajax.Role.cls',
						data: {
							Action: 'modifyrole',
							RoleID: roleID,
							RoleName: roleName,
							RoleCode: roleCode,
							RoleDesc: roleDesc
						},
						type: 'post',
						async: false
					});
					var ret = obj.responseText;
					if (ret == '-2') {
						$.messager.alert('错误','角色代码已存在，请修改后重新操作！','error');
						return;
					}
					else if (parseInt(ret) > 0) {
						$.messager.alert('提示','修改角色成功！','info',function() {
							$('#roleListTable').datagrid('reload');
						});
					}
					else {
						$.messager.alert('错误','修改角色失败，请重新尝试！','error');
						return;
					}
				}
			}
			else {
				$.messager.alert('错误','请先选择一个角色！','error');
				return;
			}
		});
		
		//设定默认角色
		$('#defaultRoleBtn').on('click', function() {
			var row = $('#roleListTable').datagrid('getSelected');
			if (row) {
				var roleID = row.RoleID;
				var obj = $.ajax({
					url: '../DHCEPRRBAC.web.eprajax.Role.cls',
					data: {
						Action: 'defaultrole',
						RoleID: roleID
					},
					type: 'post',
					async: false
				});
				var ret = obj.responseText;
				if (parseInt(ret) > 0) {
					$.messager.alert('提示','设定默认角色成功！','info',function() {
						$('#roleListTable').datagrid('reload');
					});
				}
				else {
					$.messager.alert('错误','设定默认角色失败，请重新尝试！','error');
					return;
				}
			}
			else {
				$.messager.alert('错误','请先选择一个角色！','error');
				return;
			}
		});
		
		//角色权限内容维护弹窗
		$('#addWin').window({
			title: '角色权限内容维护',
			collapsible: false,
			minimizable: false,
			maximizable: false,
			closed: true,
			modal: true,
			inline: true,
			onOpen: function() {
				var queryParams = $('#roleItemTable').datagrid('options').queryParams;
				queryParams.Action = 'getroleitem';
				queryParams.RoleID = FSAuthorization.roleID;
				$('#roleItemTable').datagrid('options').queryParams = queryParams;
				$('#roleItemTable').datagrid('reload');
				$('#roleItemTable').datagrid('getPager').pagination('select',1);
				$('#itemListTable').datagrid('getPager').pagination('select',1);
			}
		});
		
		//角色权限内容维护
		$('#addItemBtn').on('click', function() {
			var row = $('#roleListTable').datagrid('getSelected');
			if (row) {
				FSAuthorization.roleID = row.RoleID;
				$('#addWin').window('open');
			}
			else {
				$.messager.alert('错误','请先选择一个角色！','error');
				return;
			}
		});
		
		//操作类别
		$('#inputOperationType').combobox({
			valueField: 'OperationID',
			textField: 'OpDesc',
			url: '../DHCEPRRBAC.web.eprajax.Operation.cls?Action=getop',
			method: 'post',
			panelHeight: 'auto',
			editable: false,
			onLoadSuccess: function() {
				var operData = $('#inputOperationType').combobox('getData');
				$('#inputOperationType').combobox('select',operData[0].OperationID);
			},
			onSelect: function(rec) {
				FSAuthorization.opID = rec['OperationID'];
				FSAuthorization.opCode = rec['OpCode'];
				FSAuthorization.opDesc = rec['OpDesc'];
			}
		});
		
		//隐私级别
		$('#inputPrivacyLevel').combobox({
			valueField: 'PrivateDomainID',
			textField: 'PDDDesc',
			url: '../DHCEPRRBAC.web.eprajax.PrivateDomain.cls?Action=getprivatelevel',
			method: 'post',
			panelHeight: 'auto',
			editable: false,
			onLoadSuccess: function() {
				var pddData = $('#inputPrivacyLevel').combobox('getData');
				$('#inputPrivacyLevel').combobox('select',pddData[0].PrivateDomainID);
			},
			onSelect: function(rec) {
				FSAuthorization.pddID = rec['PrivateDomainID'];
				FSAuthorization.pddDesc = rec['PDDDesc'];
				var queryParams = $('#itemListTable').datagrid('options').queryParams;
				queryParams.PrivateDomainID = FSAuthorization.pddID;
				$('#itemListTable').datagrid('options').queryParams = queryParams;
				$('#itemListTable').datagrid('reload');
			}
		});
		
		//隐私域项目
		$('#itemListTable').datagrid({
			url: '../DHCEPRRBAC.web.eprajax.PrivateDomain.cls',
			queryParams: {
				Action: 'getitem',
				PrivateDomainID: FSAuthorization.pddID
			},
			method: 'post',
			title: '隐私域项目',
			loadMsg: '数据装载中......',
			singleSelect: false,
			rownumbers:true,
			toolbar: '#itemListTableTBar',
			pagination: true,
			pageSize: 50,
			pageList: [20, 30, 50, 100, 200],
			columns: [[
				{ field: 'ck', checkbox: true},
				{ field: 'PrivateDomainID', title: 'PrivateDomainID', width: 80, hidden:true },
				{ field: 'PrivateDomainDesc', title: '隐私域', width: 80, formatter: formatPrivateDomainDesc },
				{ field: 'PrivateDomainLevel', title: '隐私域级别', width: 80, hidden:true },
				{ field: 'ResourceItemID', title: 'ResourceItemID', width: 80, hidden:true },
				{ field: 'ItemID', title: 'ItemID', width: 80, hidden:true },
				{ field: 'ItemName', title: '项目名称', width: 80, hidden:true },
				{ field: 'ItemCode', title: '项目代码', width: 80, hidden:true },
				{ field: 'ItemDesc', title: '项目描述', width: 200 },
				{ field: 'ItemType', title: '项目类别代码', width: 80, hidden:true },
				{ field: 'ItemTypeDesc', title: '项目类别', width: 70 }
			]]
		});
		
		//角色权限项目
		$('#roleItemTable').datagrid({
			url: '../DHCEPRRBAC.web.eprajax.Role.cls',
			queryParams: {
				Action: 'getroleitem',
				RoleID: FSAuthorization.roleID
			},
			method: 'post',
			title: '角色权限项目',
			loadMsg: '数据装载中......',
			singleSelect: false,
			rownumbers: true,
			toolbar: '#roleItemTableTBar',
			pagination: true,
			pageSize: 50,
			pageList: [10, 20, 30, 50, 100],
			columns: [[
				{ field: 'ck', checkbox: true },
				{ field: 'OperationID', title: 'OperationID', width: 80, hidden: true },
				{ field: 'OperationCode', title: '操作代码', width: 80, hidden: true },
				{ field: 'OperationDesc', title: '操作描述', width: 60 },
				{ field: 'PrivateDomainID', title: 'PrivateDomainID', width: 80, hidden: true },
				{ field: 'PrivateDomainDesc', title: '隐私域', width: 80, formatter: formatPrivateDomainDesc },
				{ field: 'ResourceItemID', title: 'ResourceItemID', width: 80, hidden: true },
				{ field: 'ItemID', title: 'ItemID', width: 80, hidden: true },
				{ field: 'ItemName', title: '项目名称', width: 80, hidden: true },
				{ field: 'ItemCode', title: '项目代码', width: 80, hidden: true },
				{ field: 'ItemDesc', title: '项目描述', width: 200 },
				{ field: 'ItemType', title: '项目类别代码', width: 80, hidden: true },
				{ field: 'ItemTypeDesc', title: '项目类别', width: 70 }
			]],
			loadFilter: pagerFilter,
			onLoadSuccess: function(data) {
				FSAuthorization.RoleItems = $('#roleItemTable').datagrid('getData').originalRows;
			}
		});
		
		function pagerFilter(data) {
			if ($.isArray(data)) {
				data = {
					total: data.length,
					rows: data
				}
			}
			if (!data.originalRows) {
				data.originalRows = (data.rows);
			}
			var opts = $('#roleItemTable').datagrid('options');
			var pager = $('#roleItemTable').datagrid('getPager');
			pager.pagination({
				onSelectPage: function(pageNum,pageSize) {
					opts.pageNumber = pageNum;
					opts.pageSize = pageSize;
					pager.pagination('refresh',{
						pageNumber:pageNum,
						pageSize:pageSize
					});
					$('#roleItemTable').datagrid('loadData',data);
				}
			});
			var start = (opts.pageNumber-1)*parseInt(opts.pageSize);
			var end = start + parseInt(opts.pageSize);
			data.rows = (data.originalRows.slice(start,end));
			return data;
		}
		
		//增加角色权限项目
		$('#itemAddBtn').on('click', function() {
			var rows = $('#itemListTable').datagrid('getSelections');
			for (var i=0;i<rows.length;i++) {
				//检查是否已存在
				var flag = false;
				for (var j=0;j<FSAuthorization.RoleItems.length;j++) {
					if ((FSAuthorization.RoleItems[j].OperationID == FSAuthorization.opID) && (FSAuthorization.RoleItems[j].PrivateDomainID == rows[i].PrivateDomainID) && (FSAuthorization.RoleItems[j].ItemID == rows[i].ItemID))
					{
						flag = true;
						break;
					}
				}
				if (!flag) {
					var row = rows[i];
					row.OperationID = FSAuthorization.opID;
					row.OperationCode = FSAuthorization.opCode;
					row.OperationDesc = FSAuthorization.opDesc;
					row.PrivateDomainID = FSAuthorization.pddID;
					row.PrivateDomainDesc = FSAuthorization.pddDesc;
					FSAuthorization.RoleItems.push(row);
				}
			}
			$('#roleItemTable').datagrid('loadData',FSAuthorization.RoleItems);
		});
		
		function getItemIndex(item,array) {
			if (array.length == 0) {
				return '-1';
			}
			for (var i=0;i<array.length;i++) {
				if (item == array[i]) {
					return i;
				}
			}
			return '-1';
		}
		
		//移除角色权限项目
		$('#itemDeleteBtn').on('click', function() {
			var rows = $('#roleItemTable').datagrid('getSelections');
			if (rows.length == 0) {
				return;
			}
			for (var i=0;i<rows.length;i++) {
				var index = getItemIndex(rows[i],FSAuthorization.RoleItems);
				if (index != '-1') {
					FSAuthorization.RoleItems.splice(index,1);
				}
			}
			$('#roleItemTable').datagrid('loadData',FSAuthorization.RoleItems);
		});
		
		//调整角色权限项目顺序
		function move(isUp) {
			var selections = $('#roleItemTable').datagrid('getSelections');
			if (selections.length == 0) {
				return;
			}
			
			var length = FSAuthorization.RoleItems.length;
			var currentNum = $('#roleItemTable').datagrid('options').pageNumber;
			var currentSize = $('#roleItemTable').datagrid('options').pageSize;
			var selectIndex = new Array();
			for (var i=0;i<selections.length;i++) {
				var index, $i, newIndex, currentRowIdx, newRowIdx;
				if (isUp) {
					$i = i;
					index = $('#roleItemTable').datagrid('getRowIndex',selections[$i]);
					currentRowIdx = (currentNum - 1) * currentSize + index;
					if (currentRowIdx <= 0) return;
					newRowIdx = currentRowIdx - 1;
				}
				else {
					var $i = selections.length - 1 - i;
					index = $('#roleItemTable').datagrid('getRowIndex',selections[$i]);
					currentRowIdx = (currentNum - 1) * currentSize + index;
					if (currentRowIdx >= length-1) return;
					newRowIdx = currentRowIdx + 1;
				}
				FSAuthorization.RoleItems.splice(currentRowIdx,1);
				FSAuthorization.RoleItems.splice(newRowIdx,0,selections[$i]);
				newIndex = newRowIdx - (currentNum - 1) * currentSize;
				if (newIndex >=0) {
					selectIndex.push(newIndex);
				}
			}
			$('#roleItemTable').datagrid('loadData', FSAuthorization.RoleItems);
			for (var i=0;i<selectIndex.length;i++) {
				$('#roleItemTable').datagrid('selectRow',selectIndex[i]);
			}
		}
		
		//向下移动
		$('#itemDownBtn').on('click', function() {
			move(false);
		});
		
		//向上移动
		$('#itemUpBtn').on('click', function() {
			move(true);
		});
		
		//保存角色权限项目
		$('#itemSaveBtn').on('click', function() {
			var roleRows = $('#roleItemTable').datagrid('getData').originalRows;
			//角色为单选
			var privateDomainIDList = '';
			var resourceItemIDList = '';
			for (var i=0;i<roleRows.length;i++) {
				privateDomainID = roleRows[i].PrivateDomainID;
				resourceItemID = roleRows[i].ResourceItemID;
				if (privateDomainIDList == '') {
					privateDomainIDList = privateDomainID;
					resourceItemIDList = resourceItemID;
				}
				else {
					privateDomainIDList = privateDomainIDList + '^' + privateDomainID;
					resourceItemIDList = resourceItemIDList + '^' + resourceItemID;
				}
			}
			var obj = $.ajax({
				url: '../DHCEPRRBAC.web.eprajax.Role.cls', 
				type: 'post',
				data: { 
					Action: 'addroleitem',
					RoleID: FSAuthorization.roleID,
					OpID: FSAuthorization.opID,
					PrivateDomainIDList: privateDomainIDList,
					ResourceItemIDList: resourceItemIDList
				},
				async: false
			});
			var ret = obj.responseText;
			if (parseInt(ret) > 0) {
				$.messager.alert('提示','保存角色权限成功！','info',function() {
					refreshItemDisplayTable();
					$('#addWin').window('close');
				});
			}
			else {
				$.messager.alert('错误','保存角色权限失败，请重新尝试！','error');
				return;
			}
		});
		
		//刷新角色权限内容列表
		function refreshItemDisplayTable() {
			var url = '../DHCEPRRBAC.web.eprajax.Role.cls';
			$('#roleItemDisplayTable').datagrid('options').url = url;
			var queryParams = $('#roleItemDisplayTable').datagrid('options').queryParams;
			queryParams.Action = 'getroleitempage';
			queryParams.RoleID = FSAuthorization.roleID;
			$('#roleItemDisplayTable').datagrid('options').queryParams = queryParams;
			//$('#roleItemDisplayTable').datagrid('reload');
			$('#roleItemDisplayTable').datagrid('getPager').pagination('select',1);
		}
		
		//安全组查询弹窗
		$('#addDefaultRoleDialog').dialog({
			title: '安全组查询',
			closed: true,
			cache: false,
			modal: true,
			buttons: [{
				text: '添加选中',
				handler: function() {
					var rows = $('#addDefaultRoleTable').datagrid('getSelections');
					if (rows.length <= 0) {
						$.messager.alert('错误','请先选择一个安全组！','error');
						return;
					}
					var ssgroupIDS = '';
					for (var i=0;i<rows.length;i++) {
						if (ssgroupIDS == '') {
							ssgroupIDS = rows[i].ID;
						}
						else {
							ssgroupIDS = ssgroupIDS + '^' + rows[i].ID;
						}
					}
					
					var obj = $.ajax({
						url: '../DHCEPRRBAC.web.eprajax.Role.cls',
						data: {
							Action: 'defaultrolessgroup',
							RoleID: FSAuthorization.roleID,
							SSGroupIDS: ssgroupIDS
						},
						type: 'post',
						async: false
					});
					var ret = obj.responseText;
					if (parseInt(ret) > 0) {
						$.messager.alert('提示','设定默认角色成功！','info',function() {
							$('#roleListTable').datagrid('reload');
							$('#addDefaultRoleDialog').dialog('close');
						});
					}
					else {
						$.messager.alert('错误','设定默认角色失败，请重新尝试！','error');
						return;
					}
				}
			},{
				text: '关闭',
				handler: function() {
					$('#addDefaultRoleDialog').dialog('close');
				}
			}],
			onOpen: function() {
				$('#inputAddDefaultRoleFilter').searchbox('setValue','');
				refleshSSGroup('');
			}
		});
		
		//设定安全组默认角色
		$('#defaultRoleSSGroupBtn').on('click', function() {
			var row = $('#roleListTable').datagrid('getSelected');
			if (row) {
				FSAuthorization.roleID = row.RoleID;
				$('#addDefaultRoleDialog').dialog('open');
			}
			else {
				$.messager.alert('错误','请先选择一个角色！','error');
				return;
			}
		});
		
		//安全组列表
		var ssgroupDG = $('#addDefaultRoleTable').datagrid({
			//url: '../DHCEPRRBAC.web.eprajax.DicList.cls',
			queryParams: {
				Action: 'ssgroup',
				Filter: ''
			},
			method: 'post',
			loadMsg: '数据装载中......',
			singleSelect: false,
			rownumbers: false,
			toolbar: '#addDefaultRoleTBar',
			pagination: true,
			pageSize: 20,
			pageList: [10, 20, 50],
			columns: [[
				{ field: 'ID', title: '安全组ID', width: 80 },
				{ field: 'DicDesc', title: '安全组名称', width: 160 }
			]]
		});
		
		//安全组搜索框
		$('#inputAddDefaultRoleFilter').searchbox({
			searcher: function(value,name) {
				refleshSSGroup(value);
			}
		});
		
		//刷新安全组列表
		function refleshSSGroup(filter) {
			var url = '../DHCEPRRBAC.web.eprajax.DicList.cls';
			$('#addDefaultRoleTable').datagrid('options').url = url;
			var queryParams = $('#addDefaultRoleTable').datagrid('options').queryParams;
			queryParams.Action = 'ssgroup';
			queryParams.Filter = filter;
			$('#addDefaultRoleTable').datagrid('options').queryParams = queryParams;
			$('#addDefaultRoleTable').datagrid('reload');
		}
		
		//删除安全组默认角色
		$('#deleteSSGroupRoleBtn').on('click', function() {
			var row = $('#roleListTable').datagrid('getSelected');
			if (row) {
				FSAuthorization.roleID = row.RoleID;
				if (FSAuthorization.ExpandSSGroupID != '') {
					var obj = $.ajax({
						url: '../DHCEPRRBAC.web.eprajax.Role.cls',
						data: {
							Action: 'deletessgrouprole',
							RoleID: FSAuthorization.roleID,
							SSGroupID: FSAuthorization.ExpandSSGroupID
						},
						type: 'post',
						async: false
					});
					var ret = obj.responseText;
					if (parseInt(ret) > 0) {
						$.messager.alert('提示','删除安全组默认角色成功！','info',function() {
							FSAuthorization.ExpandSSGroupID = ''
							$('#roleListTable').datagrid('reload');
						});
					}
					else {
						$.messager.alert('错误','删除安全组默认角色失败，请重新尝试！','error');
						return;
					}
				}
				else {
					$.messager.alert('错误','请先选择一个安全组！','error');
					return;
				}
			}
			else {
				$.messager.alert('错误','请先选择一个角色！','error');
				return;
			}
		});
		
		//--------------------特殊病历维护--------------------
		//特殊病历维护弹窗
		var winInline = $('#advancedSecurityWin').window({
			title: '特殊病历维护',
			iconCls: 'icon-add',
			collapsible: false,
			minimizable: false,
			maximizable: false,
			closed: true,
			modal: true,
			inline: true
		});
		
		//特殊病历维护
		$('#advancedSecurityBtn').on('click', function() {
			//患者查询列表
			var patientDG = $('#patientListTable').datagrid({
				//url: '',
				queryParams: {
					Action: 'episodelist',
					PatientName: '',
					PatientLocID: '',
					PatientWardID: '',
					EpisodeID: '',
					PatientID: '',
					RegNo: '',
					MedRecordID: ''
				},
				method: 'post',
				title: '患者查询',
				loadMsg: '数据装载中......',
				singleSelect: true,
				rownumbers: true,
				toolbar: '#patientListTableTBar',
				pagination: true,
				pageSize: 20,
				pageList: [10, 20, 50],
				columns: [[
					{ field: 'ck', checkbox: true},
					{ field: 'PAStatusType', title: '状态', width: 80 },
					{ field: 'PAAdmType', title: '就诊类型', width: 80 },
					{ field: 'PAPMIName', title: '病人姓名', width: 80 },
					{ field: 'PAPMINO', title: '登记号', width: 80 },
					{ field: 'PAPMIDOB', title: '出生日期', width: 80 },
					{ field: 'PAPMIAge', title: '年龄', width: 80 },
					{ field: 'PAPMISex', title: '性别', width: 80 },
					{ field: 'PAAdmDate', title: '入院日期', width: 80 },
					{ field: 'PAAdmTime', title: '入院时间', width: 80 },
					{ field: 'PAAdmWard', title: '病区', width: 120 },
					{ field: 'PAAdmLoc', title: '科室', width: 120 },
					{ field: 'PADischgeDate', title: '出院日期', width: 80 },
					{ field: 'PADischgeTime', title: '出院时间', width: 80 },
					{ field: 'PAAdmDoc', title: '医生', width: 80 },
					{ field: 'PayMode', title: '付费类型', width: 80 },
					{ field: 'EpisodeID', title: '就诊号', width: 80 },
					{ field: 'PatientID', title: '病人号', width: 80 },
					{ field: 'IsAdvancedSecurity', title: 'IsAdvancedSecurity', width: 80, hidden:true }
				]],
				rowStyler: function(index,row) {
					if (row.IsAdvancedSecurity == 'Y') {
						return 'background-color:pink;color:blue;font-weight:bold;';
					}
				}
			});
			
			//查询患者
			$('#patientSearchBtn').on('click', function() {
				searchPatient();
			});
			
			//清空条件
			$('#patientResetBtn').on('click', function() {
				$('#inputPatientName').val('');
				$('#inputPatientEpisodeID').val('');
				$('#inputPatientRegNo').val('');
				$('#inputPatientID').val('');
				$('#inputMedRecordID').val('');
				$('#inputPatientLoc').combogrid('setValue','');
				$('#inputPatientWard').combogrid('setValue','');
			});
			
			//输入框enter事件
			$('#inputPatientName').on('keypress', function(event) {
				if (event.keyCode == '13') {
					searchPatient();
				}
			});
			
			$('#inputPatientEpisodeID').on('keypress', function(event) {
				if (event.keyCode == '13') {
					searchPatient();
				}
			});
			
			$('#inputPatientID').on('keypress', function(event) {
				if (event.keyCode == '13') {
					searchPatient();
				}
			});
			
			$('#inputPatientRegNo').on('keypress', function(event) {
				if (event.keyCode == '13') {
					searchPatient();
				}
			});
			
			$('#inputMedRecordID').on('keypress', function(event) {
				if (event.keyCode == '13') {
					searchPatient();
				}
			});
			
			//查询就诊
			function searchPatient() {
				var url = '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls';
				$('#patientListTable').datagrid('options').url = url;
				var queryParams = $('#patientListTable').datagrid('options').queryParams;
				queryParams.PatientName = $('#inputPatientName').val();
				queryParams.EpisodeID = $('#inputPatientEpisodeID').val();
				queryParams.PatientID = $('#inputPatientID').val();
				queryParams.RegNo = $('#inputPatientRegNo').val();
				queryParams.MedRecordID = $('#inputMedRecordID').val();
				$('#patientListTable').datagrid('options').queryParams = queryParams;
				$('#patientListTable').datagrid('reload');
			}
			
			$('#advancedSecurityWin').window('open');
			loadAdvancedSecurityList();
		});
		
		//特殊病历列表
		$('#advancedSecurityListTable').datagrid({
			//url: '',
			queryParams: {
				Action: 'episodelist' 
			},
			method: 'post',
			title: '特殊病历列表',
			loadMsg: '数据装载中......',
			singleSelect: true,
			rownumbers: true,
			toolbar: '#advancedSecurityListTableTBar',
			pagination: true,
			pageSize: 20,
			pageList: [10, 20, 50],
			columns: [[
				{ field: 'ck', checkbox: true},
				{ field: 'UserID', title: 'UserID', width: 80, hidden:true },
				{ field: 'UserName', title: '加入用户名', width: 80 },
				{ field: 'ActDate', title: '加入日期', width: 80 },
				{ field: 'ActTime', title: '加入时间', width: 80 },
				{ field: 'PAStatusType', title: '状态', width: 80 },
				{ field: 'PAAdmType', title: '就诊类型', width: 80 },
				{ field: 'PAPMIName', title: '病人姓名', width: 80 },
				{ field: 'PAPMINO', title: '登记号', width: 80 },
				{ field: 'PAPMIDOB', title: '出生日期', width: 80 },
				{ field: 'PAPMIAge', title: '年龄', width: 80 },
				{ field: 'PAPMISex', title: '性别', width: 80 },
				{ field: 'PAAdmDate', title: '入院日期', width: 80 },
				{ field: 'PAAdmTime', title: '入院时间', width: 80 },
				{ field: 'PAAdmWard', title: '病区', width: 120 },
				{ field: 'PAAdmLoc', title: '科室', width: 120 },
				{ field: 'PADischgeDate', title: '出院日期', width: 80 },
				{ field: 'PADischgeTime', title: '出院时间', width: 80 },
				{ field: 'PAAdmDoc', title: '医生', width: 80 },
				{ field: 'PayMode', title: '付费类型', width: 80 },
				{ field: 'EpisodeID', title: '就诊号', width: 80 },
				{ field: 'PatientID', title: '病人号', width: 80 }
			]],
			rowStyler: function(index,row) {
				return 'background-color:pink;color:blue;font-weight:bold;';
			}
		});
		
		//添加到特殊病历列表
		$('#addListBtn').on('click', function() {
			var rows = $('#patientListTable').datagrid('getSelections');
			if (rows.length != 1) {
				$.messager.alert('错误','请选择一条就诊！','error');
				return;
			}
			else {
				var obj = $.ajax({
					url: '../DHCEPRRBAC.web.eprajax.AdvancedSecurity.cls',
					data: {
						Action: 'add',
						SysCode: 'DHC',
						EpisodeID: rows[0].EpisodeID,
						UserID: appointUserID
					},
					type: 'post',
					async: false
				});
				var ret = obj.responseText;
				if (ret == '-2') {
					$.messager.alert('错误','已存在此就诊！','error');
					return;
				}
				else if (ret == '-1') {
					$.messager.alert('错误','增加失败，请重新尝试！','error');
					return;
				}
				else if ((ret != '') && (ret != null) && (parseInt(ret) > 0)) {
					$.messager.alert('提示','增加成功！','info');
					loadAdvancedSecurityList();
				}
			}
		});
		
		//移除特殊病历列表
		$('#removeListBtn').on('click', function() {
			var rows = $('#advancedSecurityListTable').datagrid('getSelections');
			if (rows.length != 1) {
				$.messager.alert('错误','请选择一条就诊！','error');
				return;
			}
			else {
				var obj = $.ajax({
					url: '../DHCEPRRBAC.web.eprajax.AdvancedSecurity.cls',
					data: {
						Action: 'remove',
						SysCode: 'DHC',
						EpisodeID: rows[0].EpisodeID,
						UserID: appointUserID
					},
					type: 'post',
					async: false
				});
				var ret = obj.responseText;
				if (ret == '-1') {
					$.messager.alert('错误','移除失败，请重新尝试！','error');
					return;
				}
				else if ((ret != '') && (ret != null) && (parseInt(ret) > 0)) {
					$.messager.alert('提示','移除成功！','info');
					loadAdvancedSecurityList();
				}
			}
		});
		
		//刷新
		$('#resetListBtn').on('click', function() {
			loadAdvancedSecurityList();
		});
		
		//刷新特殊病历列表
		function loadAdvancedSecurityList() {
			var url = '../DHCEPRRBAC.web.eprajax.AdvancedSecurity.cls';
			$('#advancedSecurityListTable').datagrid('options').url = url;
			var queryParams = $('#advancedSecurityListTable').datagrid('options').queryParams;
			queryParams.Action = 'episodelist'; 
			$('#advancedSecurityListTable').datagrid('options').queryParams = queryParams;
			$('#advancedSecurityListTable').datagrid('reload');
		}
		
		//--------------------浏览记录汇总--------------------
		//浏览记录汇总弹窗
		$('#viewHistorySummaryWin').window({
			title: '浏览记录汇总',
			collapsible: false,
			minimizable: false,
			maximizable: false,
			closed: true,
			modal: true,
			inline: true,
			onOpen: function() {
				var currDate = new Date();
				$('#historyDateStart').datebox('setValue',myformatter(currDate));
				$('#historyDateEnd').datebox('setValue',myformatter(currDate));
				FSAuthorization.HDateStart = $('#historyDateStart').datebox('getValue');
				FSAuthorization.HDateEnd = $('#historyDateEnd').datebox('getValue');
			}
		});
		
		//浏览记录汇总
		$('#viewHistorySummaryBtn').on('click', function() {
			//浏览记录汇总列表
			$('#historyListTable').datagrid({
				//url: '',
				queryParams: {
					Action: 'historylistsummary',
					LogType: 'VIEW',
					ViewType: FSAuthorization.ViewType,
					StartDate: FSAuthorization.HDateStart,
					EndDate: FSAuthorization.HDateEnd
				},
				method: 'post',
				title: '浏览记录汇总列表',
				loadMsg: '数据装载中......',
				singleSelect: true,
				rownumbers: true,
				toolbar: '#historyListTableTBar',
				pagination: true,
				pageSize: 20,
				pageList: [10, 20, 50],
				columns: [[
					{ field: 'UserID', title: 'UserID', width: 80, hidden: true },
					{ field: 'UserName', title: '操作者', width: 80 },
					{ field: 'AppointStatus', title: '授权状态代码', width: 80, hidden: true },
					{ field: 'AppointStatusDesc', title: '授权状态', width: 80, formatter: formatStatusDesc },
					{ field: 'AuthorizationID', title: 'AuthorizationID', width: 80, hidden: true },
					{ field: 'AuthorizationGroupID', title: 'AuthorizationGroupID', width: 80, hidden: true },
					{ field: 'LogDate', title: '浏览日期', width: 80 },
					{ field: 'LogTime', title: '浏览时间', width: 80 },
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
					{ field: 'EpisodeID', title: '就诊号', width: 80, hidden: true },
					{ field: 'PatientID', title: '病人号', width: 80, hidden: true }
				]]
			});
			
			//浏览记录汇总查询 - 起始日期
			$('#historyDateStart').datebox({
				onSelect: function() {
					FSAuthorization.HDateStart = $('#historyDateStart').datebox('getValue');
				},
				onChange: function() {  //避免不选择日期而采用输入的方式
					FSAuthorization.HDateStart = $('#historyDateStart').datebox('getValue');
				}
			});
			
			//浏览记录汇总查询 - 截止日期
			$('#historyDateEnd').datebox({
				onSelect: function() {
					FSAuthorization.HDateEnd = $('#historyDateEnd').datebox('getValue');
				},
				onChange: function() {  //避免不选择日期而采用输入的方式
					FSAuthorization.HDateEnd = $('#historyDateEnd').datebox('getValue');
				}
			});
			
			//浏览记录汇总查询
			$('#refreshBtn').on('click', function() {
				refleshHistoryDG();
			});
			
			$('#viewHistorySummaryWin').window('open');
		});
		
		//浏览类型
		$('#historyViewType').combobox({
			valueField: 'code',
			textField: 'text',
			data: [{
				code: 'A',
				text: '全部'
			}, {
				code: 'N',
				text: '授权浏览'
			}, {
				code: 'D',
				text: '默认角色浏览'
			}],
			panelHeight: 'auto',
			editable: false,
			onLoadSuccess: function() {
				var viewTypeData = $('#historyViewType').combobox('getData');
				$('#historyViewType').combobox('select', viewTypeData[0].code);
			},
			onSelect: function(rec) {
				FSAuthorization.ViewType = rec.code;
			}
		});
		
		//刷新浏览记录汇总列表
		function refleshHistoryDG() {
			var url = '../DHCEPRRBAC.web.eprajax.Log.cls';
			$('#historyListTable').datagrid('options').url = url;
			var queryParams = $('#historyListTable').datagrid('options').queryParams;
			queryParams.Action = 'historylistsummary';
			queryParams.LogType = 'VIEW';
			queryParams.StartDate = FSAuthorization.HDateStart;
			queryParams.EndDate = FSAuthorization.HDateEnd;
			queryParams.ViewType = FSAuthorization.ViewType;
			$('#historyListTable').datagrid('options').queryParams = queryParams;
			$('#historyListTable').datagrid('reload');
		}
		
		//--------------------授权记录汇总--------------------
		//授权记录汇总弹窗
		$('#authorizationSummaryWin').window({
			title: '授权记录汇总',
			collapsible: false,
			minimizable: false,
			maximizable: false,
			closed: true,
			modal: true,
			inline: true,
			onOpen: function() {
				var currDate = new Date();
				$('#authorizationDateStart').datebox('setValue',myformatter(currDate));
				$('#authorizationDateEnd').datebox('setValue',myformatter(currDate));
				FSAuthorization.ADateStart = $('#authorizationDateStart').datebox('getValue');
				FSAuthorization.ADateEnd = $('#authorizationDateEnd').datebox('getValue');
			}
		});
		
		//授权记录汇总
		$('#authorizationSummaryBtn').on('click', function() {
			//授权记录汇总列表
			$('#authorizationSummaryListTable').datagrid({
				//url: '',
				queryParams: {
					Action: 'authorizationlist',
					AStartDate: FSAuthorization.ADateStart,
					AEndDate: FSAuthorization.ADateEnd
				},
				method: 'post',
				title: '授权记录汇总列表',
				loadMsg: '数据装载中......',
				singleSelect: true,
				rownumbers: true,
				toolbar: '#authorizationSummaryListTableTBar',
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
				}
			});
			
			//授权记录汇总查询 - 起始日期
			$('#authorizationDateStart').datebox({
				onSelect: function() {
					FSAuthorization.ADateStart = $('#authorizationDateStart').datebox('getValue');
				},
				onChange: function() {  //避免不选择日期而采用输入的方式
					FSAuthorization.ADateStart = $('#authorizationDateStart').datebox('getValue');
				}
			});
			
			//授权记录汇总查询 - 截止日期
			$('#authorizationDateEnd').datebox({
				onSelect: function() {
					FSAuthorization.ADateEnd = $('#authorizationDateEnd').datebox('getValue');
				},
				onChange: function() {  //避免不选择日期而采用输入的方式
					FSAuthorization.ADateEnd = $('#authorizationDateEnd').datebox('getValue');
				}
			});
			
			$('#authorizationRefreshBtn').on('click', function() {
				refleshAuthorizationDG();
			});
			
			$('#authorizationSummaryWin').window('open');
		});
		
		//刷新授权记录汇总列表
		function refleshAuthorizationDG(){
			var url = '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls';
			$('#authorizationSummaryListTable').datagrid('options').url = url;
			var queryParams = $('#authorizationSummaryListTable').datagrid('options').queryParams;
			queryParams.Action = 'authorizationlist';
			queryParams.AStartDate = FSAuthorization.ADateStart;
			queryParams.AEndDate = FSAuthorization.ADateEnd;
			$('#authorizationSummaryListTable').datagrid('options').queryParams = queryParams;
			$('#authorizationSummaryListTable').datagrid('reload');
		}
		
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
