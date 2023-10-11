var FSApplyPermission = new Object();

FSApplyPermission.selectPatientLocID = '';
FSApplyPermission.selectPatientWardID = '';

FSApplyPermission.ExpandAppointID = '';

FSApplyPermission.ExpandIndex = '-1';
FSApplyPermission.SubGridSelect = '-1';

FSApplyPermission.dateStart = '';
FSApplyPermission.dateEnd = '';
FSApplyPermission.typeCode = '';

FSApplyPermission.HDateStart = '';
FSApplyPermission.HDateEnd = '';

FSApplyPermission.DialogType = 'addcategory';
FSApplyPermission.selectEpisodeID = '';
FSApplyPermission.selectFavoritesCategoryID = '';
FSApplyPermission.addFavoriteType = '';
FSApplyPermission.favoritesIDS = '';
FSApplyPermission.favoritesEpisodeIDS = '';
FSApplyPermission.requestEpisodeIDS = '';
FSApplyPermission.spanTime = '';

//表明申请的为病案归档的权限
FSApplyPermission.EPRACTION = 'FS';
FSApplyPermission.DATESPAN = 7;
FSApplyPermission.DATASERVICEURL = dataServiceURL;
FSApplyPermission.WINCOUNT = 0;
FSApplyPermission.ViewRecord = null;

(function($) {
	$(function() {
		$g = window.$g || function(a){return a;};
		//$('#applyListPanel').panel('maximize');
		//$('#applyDefaultListPanel').panel('close');
		$('#applyListPanel').panel('close');
		$('#applyDefaultListPanel').panel('open');
		$('#applyDefaultListPanel').panel('maximize');
		//按钮文字描述
		if (hospitalFlag == 'BJFC') {
			$('#addNewApplyBtn').html('扫描病历浏览申请<font color="red">(需审批)</font>');
			$('#addDefaultRoleBtn').html('科研病历浏览(无需审批)');
		}
		FSApplyPermission.ViewRecord = viewRecord;
		
		//--------------------新增浏览申请--------------------
		//新增浏览申请弹窗
		$('#addApplyWin').dialog({
			title: '新增浏览申请',
			iconCls: 'icon-w-add',
			closable: false,
			closed: true,
			modal: true,
			buttons: [{
				text: '关闭',
				handler: function() {
					if ($('#addListTable').datagrid('getRows').length > 0) {  //检查是否在待申请表格中有数据
						$.messager.confirm('提示','窗口正在关闭，待申请表格中还有数据。\n 是否继续关闭窗口？',function(r) {
							if (r) {
								$('#addApplyWin').dialog('close');
							}
							else {
								return;
							}
						});
					}
					else {
						$('#addApplyWin').dialog('close');
					}
				}
			}]
		});
		
		//新增浏览申请
		$('#addApplyBtn').on('click', function() {
			//患者查询列表
			$HUI.datagrid('#patientListTable',{
				fit: true,
				border: false,
				toolbar: '#patientListTableTBar',
				//url: '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls',
				queryParams: {
					Action: 'episodelist',
					UserID: appointUserID,
					UserLocID: appointUserLoc,
					UserSSGroupID: appointUserSSGroupID,
					PatientName: '',
					PatientLocID: '',
					PatientWardID: '',
					EpisodeID: '',
					PatientID: '',
					RegNo: '',
					MedRecordID: ''
				},
				rownumbers: true,
				pagination: true,
				pageSize: 20,
				pageList: [10, 20, 50],
				columns: [[
					{field:'ck',checkbox:true},
					{field:'PAStatusType',title:'状态',width:80},
					{field:'PAAdmType',title:'就诊类型',width:80},
					{field:'PAPMIName',title:'患者姓名',width:80},
					{field:'PAPMINO',title:'登记号',width:100},
					{field:'PAPMIDOB',title:'出生日期',width:100},
					{field:'PAPMIAge',title:'年龄',width:80},
					{field:'PAPMISex',title:'性别',width:80},
					{field:'PAAdmDate',title:'入院日期',width:100},
					{field:'PAAdmTime',title:'入院时间',width:100},
					{field:'PAAdmWard',title:'病区',width:120},
					{field:'PAAdmLoc',title:'科室',width:120},
					{field:'PADischgeDate',title:'出院日期',width:100},
					{field:'PADischgeTime',title:'出院时间',width:100},
					{field:'PAAdmDoc',title:'医生',width:80},
					{field:'PayMode',title:'付费类型',width:120},
					{field:'EpisodeID',title:'就诊号',width:80},
					{field:'PatientID',title:'病人号',width:80},
					{field:'CheckNoNeedApply',title:'是否可无需申请',width:100},
					{field:'IsAdvancedSecurity',title:'IsAdvancedSecurity',width:80,hidden:true}
				]],
				rowStyler: function(index,row) {
					if (row.IsAdvancedSecurity == 'Y') {
						return 'background-color:pink;color:blue;font-weight:bold;';
					}
					if (row.CheckNoNeedApply == '1') {
						return 'background-color:lightgreen;color:black;font-weight:bold;';
					}
				}
			});
			
			//查询患者
			$('#patientSearchBtn').on('click', function() {
				searchPatient();
			});
			
			//清空条件
			$('#patientResetBtn').on('click', function() {
				$('#inputMedRecordID').val('');
				$('#inputPatientName').val('');
				$('#inputPatientRegNo').val('');
			});
			
			//输入框enter事件
			$('#inputMedRecordID').on('keypress', function(event) {
				if (event.keyCode == '13') {
					searchPatient();
				}
			});
			
			$('#inputPatientRegNo').on('keypress', function(event) {
				if (event.keyCode == '13') {
					searchPatient();
				}
			});
			
			$('#inputPatientName').on('keypress', function(event) {
				if (event.keyCode == '13') {
					searchPatient();
				}
			});
			$('#inputMedRecordID').val('');
			$('#inputPatientName').val('');
			$('#inputPatientRegNo').val('');
			$('#addApplyWin').dialog('open');
		});
		
		//查询就诊
		function searchPatient() {
			var url = '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls';
			$('#patientListTable').datagrid('options').url = url;
			var queryParams = $('#patientListTable').datagrid('options').queryParams;
			queryParams.MedRecordID = $('#inputMedRecordID').val();
			queryParams.RegNo = $('#inputPatientRegNo').val();
			queryParams.PatientName = $('#inputPatientName').val();
			$('#patientListTable').datagrid('options').queryParams = queryParams;
			$('#patientListTable').datagrid('reload');
		}
		
		//待申请列表
		$HUI.datagrid('#addListTable',{
			title: '待申请列表',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			toolbar: '#addListTableTBar',
			rownumbers: true,
			columns: [[
				{field:'ck',checkbox:true},
				{field:'PAStatusType',title:'状态',width:80},
				{field:'PAAdmType',title:'就诊类型',width:80},
				{field:'PAPMIName',title:'患者姓名',width:80},
				{field:'PAPMINO',title:'登记号',width:100},
				{field:'PAPMIDOB',title:'出生日期',width:100},
				{field:'PAPMIAge',title:'年龄',width:80},
				{field:'PAPMISex',title:'性别',width:80},
				{field:'PAAdmDate',title:'入院日期',width:100},
				{field:'PAAdmTime',title:'入院时间',width:100},
				{field:'PAAdmWard',title:'病区',width:120},
				{field:'PAAdmLoc',title:'科室',width:120},
				{field:'PADischgeDate',title:'出院日期',width:100},
				{field:'PADischgeTime',title:'出院时间',width:100},
				{field:'PAAdmDoc',title:'医生',width:80},
				{field:'PayMode',title:'付费类型',width:120},
				{field:'EpisodeID',title:'就诊号',width:80},
				{field:'PatientID',title:'病人号',width:80},
				{field:'CheckNoNeedApply',title:'是否可无需申请',width:100},
				{field:'IsAdvancedSecurity',title:'IsAdvancedSecurity',width:80,hidden:true}
			]],
			rowStyler: function(index,row) {
				if (row.IsAdvancedSecurity == 'Y') {
					return 'background-color:pink;color:blue;font-weight:bold;';
				}
				if (row.CheckNoNeedApply == '1') {
					return 'background-color:lightgreen;color:black;font-weight:bold;';
				}
			}
		});
		
		//添加到待申请列表
		//封存病历不能加到申请列表
		$('#addListBtn').on('click', function() {
			var rows = $('#patientListTable').datagrid('getSelections');
			var sealFlag = "0";
			for (var i=0;i<rows.length;i++) {
				//封存病历不能借阅申请 yangshun 2022-07-01
				if(rows[i]['IsAdvancedSecurity']=="Y")
				{
					sealFlag = "1";
					continue;
				}
				//检查是否已存在
				var addTRows = $('#addListTable').datagrid('getRows');
				var flag = false;
				for (var j=0;j<addTRows.length;j++) {
					if (addTRows[j].EpisodeID == rows[i].EpisodeID) {
						flag = true;
						break;
					}
				}
				if (!flag) {
					$('#addListTable').datagrid('appendRow',rows[i]);
				}
			}
			if(sealFlag=="1")
			{
				alert("封存病历不能借阅");
			}
		});
		
		//移除待申请列表
		$('#removeListBtn').on('click', function() {
			var rows = $('#addListTable').datagrid('getSelections');
			for (var i=0;i<rows.length;i++) {
				var index = $('#addListTable').datagrid('getRowIndex',rows[i]);
				$('#addListTable').datagrid('deleteRow', index);
			}
		});
		
		//清空待申请列表
		$('#resetListBtn').on('click', function() {
			$('#addListTable').datagrid('loadData',{total:0,rows:[]});
		});
		
		//浏览申请
		$('#addNewApplyBtn').on('click', function() {
			FSApplyPermission.requestEpisodeIDS = '';
			var episodeString = '';
			var rows = $('#addListTable').datagrid('getSelections');
			if (rows.length == 0) {
				$.messager.alert('错误','请先选择一条就诊记录再点击申请权限！','error');
				return;
			}
			else {
				for (var i=0;i<rows.length;i++) {
					var row = rows[i];
					var episodeID = row['EpisodeID'];
					if (episodeString == '') {
						episodeString = episodeID;
					}
					else {
						episodeString = episodeString + '^' + episodeID;
					}
				}
				//确认申请权限
				FSApplyPermission.requestEpisodeIDS = episodeString;
				$('#requestReasonDialog').dialog('open');
			}
		});
		
		//浏览申请弹窗
		$('#requestReasonDialog').dialog({
			title: '浏览申请',
			iconCls: 'icon-w-edit',
			closed: true,
			modal: true,
			buttons: [{
				text: '申请',
				handler: function() {
					var reason = $('#inputRequestReason').val();
					if (reason == '') {
						$.messager.alert('提示','请填写申请原因','info');
						return;
					}
					var obj = $.ajax({
						url: '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls',
						data: {
							Action: 'apply',
							EPRAction: FSApplyPermission.EPRACTION,
							EpisodeString: FSApplyPermission.requestEpisodeIDS,
							UserID: appointUserID,
							UserLocID: appointUserLoc,
							UserSSGroupID: appointUserSSGroupID,
							Reason: reason,
							SpanTime: FSApplyPermission.spanTime
						},
						type: 'post',
						async: false
					});
					var ret = obj.responseText;
					if (parseInt(ret) > 0) {
						$.messager.alert('完成','申请成功！','info',function(){
							FSApplyPermission.requestEpisodeIDS = '';
							$('#addListTable').datagrid('loadData',{total:0,rows:[]});
							refreshGrid();
							$('#addApplyWin').dialog('close');
							$('#requestReasonDialog').dialog('close');
						});
					}
					else {
						$.messager.alert('错误','申请失败，请再次尝试！','error');
						return;
					}
				}
			},{
				text: '取消',
				handler: function() {
					$('#requestReasonDialog').dialog('close');
				}
			}]
		});
		
		//申请浏览时长
		$('#inputRequestSpan').combobox({
			valueField: 'code',
			textField: 'text',
			editable: false,
			data: [{
				code: '12',
				text: $g('12小时')
			}, {
				code: '24',
				text: $g('24小时')
			}, {
				code: '48',
				text: $g('48小时')
			}, {
				code: '72',
				text: $g('72小时')
			}, {
				code: '96',
				text: $g('4天')
			}, {
				code: '120',
				text: $g('5天')
			}, {
				code: '192',
				text: $g('8天')
			}, {
				code: '240',
				text: $g('10天')
			}, {
				code: '360',
				text: $g('15天')
			}],
			onLoadSuccess: function() {
				var spanData = $('#inputRequestSpan').combobox('getData');
				$('#inputRequestSpan').combobox('select', spanData[3].code);
			},
			onSelect: function(rec) {
				FSApplyPermission.spanTime = rec.code;
			}
		});
		
		//默认角色浏览
		$('#addDefaultRoleBtn').on('click', function() {
			var rows = $('#addListTable').datagrid('getSelections');
			if (rows.length == 0) {
				$.messager.alert('错误','请先选择一条就诊记录再点击以默认浏览权限浏览就诊按钮！','error');
				return;
			}
			else {
				var episodeString = '', isAdvancedSecurity = 'N', checkNoNeedApply = '1';
				for (var i=0;i<rows.length;i++) {
					var row = rows[i];
					var episodeID = row['EpisodeID'];
					var isAdvancedSecurity = row['IsAdvancedSecurity'];
					var checkNoNeedApply = row['CheckNoNeedApply'];
					
					if (isAdvancedSecurity == 'Y') {
						break;
					}
					else if (checkNoNeedApply == '0') {
						break;
					}
					
					if (episodeString == '') {
						episodeString = episodeID;
					}
					else {
						episodeString = episodeString + '^' + episodeID;
					}
				}
				
				if (isAdvancedSecurity == 'Y') {
					$.messager.alert('错误','请取消选中敏感病历，敏感病历需审批后查看！','error');
					return;
				}
				else if (checkNoNeedApply == '0') {
					$.messager.alert('错误','请取消选中非本科病历，非本科病历需审批后查看！','error');
					return;
				}
				else {
					var obj = $.ajax({
						url: '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls',
						data: {
							Action: 'defaultrole',
							EPRAction: FSApplyPermission.EPRACTION,
							EpisodeString: episodeString,
							UserID: appointUserID,
							UserLocID: appointUserLoc,
							UserSSGroupID: appointUserSSGroupID
						},
						type: 'post',
						async: false
					});
					var ret = obj.responseText;
					if (parseInt(ret) == -3) {
						$.messager.alert('错误','获取默认角色失败，请联系管理员配置后操作！','error');
						return;
					}
					else if (parseInt(ret) > 0) {
						$.messager.alert('完成','添加成功！','info',function(){
							$('#addListTable').datagrid('loadData',{total:0,rows:[]});
							refreshGrid();
							$('#addApplyWin').dialog('close');
						});
					}
					else {
						$.messager.alert('错误','添加失败，请再次尝试！','error');
						return;
					}
				}
			}
		});
		
		//--------------------浏览申请列表--------------------
		//浏览申请列表查询 - 起始日期
		$('#inputDateStart').datebox({
			onSelect: function() {
				FSApplyPermission.dateStart = $('#inputDateStart').datebox('getValue');
			},
			onChange: function() {  //避免不选择日期而采用输入的方式
				FSApplyPermission.dateStart = $('#inputDateStart').datebox('getValue');
			}
		});
		
		//浏览申请列表查询 - 截止日期
		$('#inputDateEnd').datebox({
			onSelect: function() {
				FSApplyPermission.dateEnd = $('#inputDateEnd').datebox('getValue');
			},
			onChange: function() {  //避免不选择日期而采用输入的方式
				FSApplyPermission.dateEnd = $('#inputDateEnd').datebox('getValue');
			}
		});
		
		setApplyDefaultDate();
		
		//默认角色浏览列表
		$HUI.datagrid('#applyDefaultListTable',{
			fit: true,
			border: false,
			url: $URL,
			queryParams: {
				ClassName: 'DHCEPRRBAC.BL.BLFSAuthorization',
				QueryName: 'GetApplyDefaultByUserID',
				AUserID: appointUserID,
				AApplyStatus: 'D',
				ARequestStartDate: '',
				ARequestEndDate: ''
			},
			rownumbers: true,
			singleSelect: true,
			pagination: true,
			pageSize: 20,
			pageList: [10, 20, 50],
			columns:[[
				{field:'AuthorizationID',title:'AuthorizationID',width:80,hidden:true},
				{field:'AuthorizationDetailID',title:'AuthorizationDetailID',width:80,hidden:true},
				{field:'PAStatusType',title:'状态',width:80},
				{field:'PAAdmType',title:'就诊类型',width:80},
				{field:'MedRecordNo',title:'病案号',width:100},
				{field:'RegNo',title:'登记号',width:100},
				{field:'PAPMIName',title:'患者姓名',width:80},
				{field:'PADischgeDate',title:'出院日期',width:100},
				{field:'PADischgeTime',title:'出院时间',width:100},
				{field:'PAAdmLoc',title:'科室',width:120},
				{field:'PAAdmWard',title:'病区',width:120},
				{field:'PAAdmDoc',title:'医生',width:80},
				{field:'PAAdmDate',title:'入院日期',width:100},
				{field:'PAAdmTime',title:'入院时间',width:100},
				{field:'PAPMIDOB',title:'出生日期',width:100},
				{field:'PAPMIAge',title:'年龄',width:60},
				{field:'PAPMISex',title:'性别',width:60},
				{field:'PayMode',title:'付费类型',width:120},
				{field:'EpisodeID',title:'就诊号',width:80,hidden:true},
				{field:'PatientID',title:'病人号',width:80,hidden:true},
				{field:'LinkedParam',title:'关联',width:100,formatter:linkURLFormatter},
				{field:'IsAdvancedSecurity',title:'IsAdvancedSecurity',width:80,hidden:true}
			]],
			rowStyler: function(index,row) {
				if (row.IsAdvancedSecurity == '1') {
					return 'background-color:pink;color:blue;font-weight:bold;';
				}
			},
			onDblClickRow: function(index,row) {
				viewRecord(row.EpisodeID,row.AuthorizationID,row.AuthorizationDetailID,'main');
			}
		});
		
		//申请列表
		$HUI.datagrid('#applyListTable',{
			fit: true,
			border: false,
			url: $URL,
			queryParams: {
				ClassName: 'DHCEPRRBAC.BL.BLFSAuthorization',
				QueryName: 'GetApplyListByUserID',
				AUserID: appointUserID,
				AApplyStatus: 'N',
				ARequestStartDate: '',
				ARequestEndDate: ''
			},
			rownumbers: true,
			singleSelect: true,
			pagination: true,
			pageSize: 20,
			pageList: [10, 20, 50],
			columns: [[
				{field:'AuthorizationID',title:'AuthorizationID',width:80,hidden:true},
				{field:'RequestUserID',title:'RequestUserID',width:80,hidden:true},
				{field:'RequestUserName',title:'申请人',width:80},
				{field:'RequestDeptID',title:'RequestDeptID',width:80,hidden:true},
				{field:'RequestDept',title:'申请人科室',width:80,hidden:true},
				{field:'RequestSSGroupID',title:'RequestSSGroupID',width:80,hidden:true},
				{field:'RequestSSGroup',title:'申请人安全组',width:80,hidden:true},
				{field:'RequestDate',title:'申请日期',width:100},
				{field:'RequestTime',title:'申请时间',width:100},
				{field:'AppointUserID',title:'AppointUserID',width:80,hidden:true},
				{field:'AppointUserName',title:'批准人',width:80},
				{field:'AppointDate',title:'批准日期',width:100},
				{field:'AppointTime',title:'批准时间',width:100},
				{field:'AppointEndDate',title:'批准到期日期',width:100},
				{field:'AppointEndTime',title:'批准到期时间',width:100},
				{field:'RoleID',title:'RoleID',width:80,hidden:true},
				{field:'RoleCode',title:'分配角色代码',width:100},
				{field:'RoleDesc',title:'分配角色',width:100},
				{field:'OperationID',title:'OperationID',width:80,hidden:true},
				{field:'OperationCode',title:'操作类型代码',width:80,hidden:true},
				{field:'OperationDesc',title:'操作类型描述',width:100},
				{field:'EPRAction',title:'分配权限类型代码',width:80,hidden:true},
				{field:'EPRActionDesc',title:'分配权限类型',width:100},
				{field:'AppointType',title:'AppointType',width:80,hidden:true},
				{field:'AppointStatus',title:'授权状态代码',width:80,hidden:true},
				{field:'AppointStatusDesc',title:'授权状态',width:100,formatter:formatStatusDesc},
				{field:'AppointComment',title:'被拒绝或取消原因',width:200},
				{field:'MedRecordNoS',title:'申请病案号',width:150},
				{field:'HasAdvancedSecurity',title:'HasAdvancedSecurity',width:80,hidden:true}
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
			onClickRow: function(rowIndex,rowData) {
				//展开选中
				FSApplyPermission.ExpandIndex = rowIndex;
				$('#applyListTable').datagrid('expandRow',rowIndex);
			},
			onExpandRow: function(index,row){
				//展开即选中
				$('#applyListTable').datagrid('selectRow',index);
				FSApplyPermission.ExpandIndex = index;
				FSApplyPermission.ExpandAppointID = row.AuthorizationID;
				
				$HUI.datagrid('#ddv-' + index,{
					height: 'auto',
					bodyCls: 'panel-body-gray',
					url: $URL,
					queryParams: {
						ClassName: 'DHCEPRRBAC.BL.BLFSAuthorization',
						QueryName: 'GetApplyListDetail',
						AAuthorizationID: FSApplyPermission.ExpandAppointID
					},
					rownumbers: true,
					singleSelect: true,
					columns:[[
						{field:'AuthorizationID',title:'AuthorizationID',width:80,hidden:true},
						{field:'AuthorizationDetailID',title:'AuthorizationDetailID',width:80,hidden:true},
						{field:'PAStatusType',title:'状态',width:80},
						{field:'PAAdmType',title:'就诊类型',width:80},
						{field:'MedRecordNo',title:'病案号',width:100},
						{field:'RegNo',title:'登记号',width:100},
						{field:'PAPMIName',title:'患者姓名',width:80},
						{field:'PADischgeDate',title:'出院日期',width:100},
						{field:'PADischgeTime',title:'出院时间',width:100},
						{field:'PAAdmLoc',title:'科室',width:120},
						{field:'PAAdmWard',title:'病区',width:120},
						{field:'PAAdmDoc',title:'医生',width:80},
						{field:'PAAdmDate',title:'入院日期',width:100},
						{field:'PAAdmTime',title:'入院时间',width:100},
						{field:'PAPMIDOB',title:'出生日期',width:100},
						{field:'PAPMIAge',title:'年龄',width:60},
						{field:'PAPMISex',title:'性别',width:60},
						{field:'PayMode',title:'付费类型',width:120},
						{field:'EpisodeID',title:'就诊号',width:80,hidden:true},
						{field:'PatientID',title:'病人号',width:80,hidden:true},
						{field:'LinkedParam',title:'关联',width:100,formatter:linkURLFormatter},
						{field:'IsAdvancedSecurity',title:'IsAdvancedSecurity',width:80,hidden:true}
					]],
					rowStyler: function(index,row) {
						if (row.IsAdvancedSecurity == '1') {
							return 'background-color:pink;color:blue;font-weight:bold;';
						}
					},
					onResize: function() {
						$('#applyListTable').datagrid('fixDetailRowHeight',index);
					},
					onLoadSuccess: function() {
						setTimeout(function() {
							$('#applyListTable').datagrid('fixDetailRowHeight',index);
						},0);
					},
					onClickRow: function(rowIndex,rowData) {
						//获取父表此行的index
						var parentIdex = '';
						for (var i=0;i<$('#applyListTable').datagrid('getRows').length;i++) {
							var row = $('#applyListTable').datagrid('getRows')[i];
							if (row.AuthorizationID == rowData.AuthorizationID) {
								parentIdex = $('#applyListTable').datagrid('getRowIndex',row);
								break;
							}
						}
						FSApplyPermission.ExpandIndex = parentIdex;
						FSApplyPermission.SubGridSelect = rowIndex;
						//清空其他子表的选中
						for (var j=0;j<$('#applyListTable').datagrid('getRows').length;j++) {
							if (j != parentIdex) {
								try {
									if ($('#ddv-' + j).length > 0) {
										var ddvrows = $('#ddv-' + j).datagrid('getSelections');
										if (ddvrows.length > 0) {
											$('#ddv-' + j).datagrid('unselectAll');
										}
									}
								}
								catch(e) {
									//可能ddv-i还未渲染，即还未展开则进入此处，也不需要清空
									continue;
								}
							}
						}
					},
					onDblClickRow: function(index,row) {
						viewRecord(row.EpisodeID,row.AuthorizationID,row.AuthorizationDetailID,'main');
					}
				});
				$('#applyListTable').datagrid('fixDetailRowHeight',index);
			}
		});
		
		//申请类型
		$('#inputType').combobox({
			valueField: 'code',
			textField: 'text',
			data: [{
				code: 'D',
				text: $g('以默认角色浏览')
			}, {
				code: 'N',
				text: $g('未批准')
			}, {
				code: 'F',
				text: $g('已批准')
			}, {
				code: 'R',
				text: $g('已拒绝')
			}, {
				code: 'I',
				text: $g('已过期')
			}],
			onLoadSuccess: function() {
				var typeData = $('#inputType').combobox('getData');
				$('#inputType').combobox('select',typeData[0].code);
			},
			onSelect: function(rec) {
				FSApplyPermission.typeCode = rec.code;
				//按钮显示隐藏
				if ((rec.code == 'F')||(rec.code == 'D')) {
					$('#viewBtn').show();
					$('#reAppointBtn').hide();
				}
				else if ((rec.code == 'R')||(rec.code == 'I')) {
					$('#viewBtn').hide();
					$('#reAppointBtn').show();
				}
				else {
					$('#viewBtn').hide();
					$('#reAppointBtn').hide();
				}
				//查询
				refreshGrid();
			}
		});
		
		//查询
		$('#searchBtn').on('click', function() {
			refreshGrid();
		});
		
		//清空条件
		$('#resetBtn').on('click', function() {
			setApplyDefaultDate();
			$('#inputType').combobox('select','D');
		});
		
		function setApplyDefaultDate() {
			var currDate = new Date(); 
			$('#inputDateStart').datebox('setValue',myformatter1(currDate,FSApplyPermission.DATESPAN));
			$('#inputDateEnd').datebox('setValue',myformatter(currDate));
			FSApplyPermission.dateStart = $('#inputDateStart').datebox('getValue');
			FSApplyPermission.dateEnd = $('#inputDateEnd').datebox('getValue');
		}
		
		//刷新申请列表
		function refreshGrid() {
			if (FSApplyPermission.typeCode == 'D') {
				$('#applyListPanel').panel('close');
				$('#applyDefaultListPanel').panel('open');
				$('#applyDefaultListPanel').panel('maximize');
				
				var queryParams = $('#applyDefaultListTable').datagrid('options').queryParams;
				queryParams.AUserID = appointUserID;
				queryParams.AApplyStatus = FSApplyPermission.typeCode;
				queryParams.ARequestStartDate = FSApplyPermission.dateStart;
				queryParams.ARequestEndDate = FSApplyPermission.dateEnd;
				$('#applyDefaultListTable').datagrid('options').queryParams = queryParams;
				$('#applyDefaultListTable').datagrid('reload');
			}
			else {
				$('#applyDefaultListPanel').panel('close');
				$('#applyListPanel').panel('open');
				$('#applyListPanel').panel('maximize');
				
				var queryParams = $('#applyListTable').datagrid('options').queryParams;
				queryParams.AUserID = appointUserID;
				queryParams.AApplyStatus = FSApplyPermission.typeCode;
				queryParams.ARequestStartDate = FSApplyPermission.dateStart;
				queryParams.ARequestEndDate = FSApplyPermission.dateEnd;
				$('#applyListTable').datagrid('options').queryParams = queryParams;
				$('#applyListTable').datagrid('reload');
				
				//隐藏列，显示列
				if (FSApplyPermission.typeCode == 'N') {  //未授权，隐藏授权人等信息
					$('#applyListTable').datagrid('hideColumn','AppointUserName');
					$('#applyListTable').datagrid('hideColumn','AppointDate');
					$('#applyListTable').datagrid('hideColumn','AppointTime');
					$('#applyListTable').datagrid('hideColumn','AppointEndDate');
					$('#applyListTable').datagrid('hideColumn','AppointEndTime');
					$('#applyListTable').datagrid('hideColumn','RoleCode');
					$('#applyListTable').datagrid('hideColumn','RoleDesc');
					$('#applyListTable').datagrid('hideColumn','OperationDesc');
					$('#applyListTable').datagrid('hideColumn','AppointComment');
				}
				else if(FSApplyPermission.typeCode == 'F'){
					$('#applyListTable').datagrid('showColumn','AppointUserName');
					$('#applyListTable').datagrid('showColumn','AppointDate');
					$('#applyListTable').datagrid('showColumn','AppointTime');
					$('#applyListTable').datagrid('showColumn','AppointEndDate');
					$('#applyListTable').datagrid('showColumn','AppointEndTime');
					$('#applyListTable').datagrid('showColumn','RoleCode');
					$('#applyListTable').datagrid('showColumn','RoleDesc');
					$('#applyListTable').datagrid('showColumn','OperationDesc');
					$('#applyListTable').datagrid('hideColumn','AppointComment');
				}
				else {
					$('#applyListTable').datagrid('showColumn','AppointUserName');
					$('#applyListTable').datagrid('showColumn','AppointDate');
					$('#applyListTable').datagrid('showColumn','AppointTime');
					$('#applyListTable').datagrid('showColumn','AppointEndDate');
					$('#applyListTable').datagrid('showColumn','AppointEndTime');
					$('#applyListTable').datagrid('showColumn','RoleCode');
					$('#applyListTable').datagrid('showColumn','RoleDesc');
					$('#applyListTable').datagrid('showColumn','OperationDesc');
					$('#applyListTable').datagrid('showColumn','AppointComment');
				}
			}
		}
		
		//重新申请
		$('#reAppointBtn').on('click', function() {
			var reapplyRow = $('#applyListTable').datagrid('getSelected');
			if (reapplyRow) {
				$('#reapplyReasonDialog').dialog('open');
			}
			else {
				$.messager.alert('错误', '请先选中一条申请', 'error');
				return;
			}
		});
		
		//重新申请浏览时长
		$('#inputReapplySpan').combobox({
			valueField: 'code',
			textField: 'text',
			editable: false,
			data: [{
				code: '12',
				text: $g('12小时'),
				selected: true
			}, {
				code: '24',
				text: $g('24小时')
			}, {
				code: '48',
				text: $g('48小时')
			}, {
				code: '72',
				text: $g('72小时')
			}, {
				code: '96',
				text: $g('4天')
			}, {
				code: '120',
				text: $g('5天')
			}, {
				code: '192',
				text: $g('8天')
			}, {
				code: '240',
				text: $g('10天')
			}, {
				code: '360',
				text: $g('15天')
			}]
		});
		
		//重新申请弹窗
		$('#reapplyReasonDialog').dialog({
			title: '重新申请',
			iconCls: 'icon-w-edit',
			closed: true,
			modal: true,
			buttons: [{
				text: '申请',
				handler: function() {
					var reapplySpanTime = $('#inputReapplySpan').combobox('getValue');
					var reapplyReason = $('#inputReapplyReason').val();
					if (reapplyReason == ''){
						$.messager.alert('提示','请填写申请原因','info');
						return;
					}
					var obj = $.ajax({
						url: '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls',
						data: {
							Action: 'reapply',
							AuthorizationID: FSApplyPermission.ExpandAppointID,
							Reason: reapplyReason,
							SpanTime: reapplySpanTime
						},
						type: 'post',
						async: false
					});
					var ret = obj.responseText;
					if (parseInt(ret) > 0) {
						$.messager.alert('完成','申请成功！','info',function(){
							FSApplyPermission.requestEpisodeIDS = '';
							$('#reapplyReasonDialog').dialog('close');
						});
					}
					else {
						$.messager.alert('错误','申请失败，请再次尝试！','error');
						return;
					}
				}
			},{
				text: '取消',
				handler: function() {
					$('#reapplyReasonDialog').dialog('close');
				}
			}]
		});
		
		//浏览选中文档
		$('#viewBtn').on('click', function() {
			if (FSApplyPermission.typeCode == 'D') {
				var row = $('#applyDefaultListTable').datagrid('getSelected');
				if (row) {
					viewRecord(row.EpisodeID,row.AuthorizationID,row.AuthorizationDetailID,'main');
				}
				else {
					$.messager.alert('错误','请先选中一条就诊','error');
					return;
				}
			}
			else {
				if (FSApplyPermission.ExpandIndex == '-1') {
					$.messager.alert('错误','请先展开一条授权','error');
					return;
				}
				else if (FSApplyPermission.SubGridSelect == '-1') {
					$.messager.alert('错误','请先选中一条就诊','error');
					return;
				}
				else {
					var row = $('#ddv-' + FSApplyPermission.ExpandIndex).datagrid('getRows')[FSApplyPermission.SubGridSelect];
					viewRecord(row.EpisodeID,row.AuthorizationID,row.AuthorizationDetailID,'main');
				}
			}
		});
		
		function viewRecord(episodeID,authGroupID,authID,viewType) {
			if (((viewType == 'main')&&(FSApplyPermission.typeCode == 'D')) || ((viewType == 'dlg')&&(authGroupID == 'default'))) {
				var argAction = 'getdefaultviewparam';
				if (controlType == 'pdfjs') argAction = 'defaultviewpermission';
				var obj = $.ajax({
					url: '../DHCEPRRBAC.web.eprajax.View.cls',
					data: {
						Action: argAction,
						EpisodeID: episodeID,
						SSGroupID: appointUserSSGroupID
					},
					type: 'post',
					async: false
				});
				var ret = obj.responseText;
				if (ret == '-4') {
					$.messager.alert('错误','该病历已加入敏感病历列表，敏感病历需审批后查看','error');
					return;
				}
				else if (ret == '-3') {
					$.messager.alert('错误','获取默认角色失败，请联系管理员配置后操作！','error');
					return;
				}
				else {
					if (controlType == 'pdfjs') {
						var url = 'dhc.epr.fs.pdfview.csp?Flag=apply&EpisodeID=' + episodeID + '&RoleID=' + ret;
						FSApplyPermission.WINCOUNT = FSApplyPermission.WINCOUNT + 1;
						window.open(url,FSApplyPermission.WINCOUNT,'height=800,width=1280,top=0,left=0,toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no');
						//写入浏览记录
						var obj = $.ajax({
							url: '../DHCEPRRBAC.web.eprajax.Log.cls',
							data: {
								Action: 'addlog',
								EpisodeID: episodeID,
								UserID: appointUserID,
								LogType: 'VIEW',
								AuthorizationID: 'default',
								AuthorizationGroupID: 'default'
							},
							type: 'post',
							async: false
						});
					}
					else {
						var strs = ret.split('|');
						var operationCode = strs[1];
						var items = strs[2];
						if (operationCode == 'VIEW') {
							var obj = $.ajax({
								type: 'POST',
								url: '../DHCEPRRBAC.web.eprajax.FS.cls',
								data: {
									Action: 'getveritem',
									EpisodeID: episodeID,
									Items: items
								},
								async: false
							}); 
							var retFS = obj.responseText;
							if ((retFS != '') && (retFS != null) && (retFS != '-1')) {
								var strsFS = retFS.split('!');
								var mrEpisodeID = strsFS[0];
								var verItems = strsFS[1];
								var url = 'dhc.epr.fs.viewrecord.csp?MREpisodeID=' + mrEpisodeID + '&MRVerItemsIDs=' + verItems + '&DataServiceUrl=' + FSApplyPermission.DATASERVICEURL;
								FSApplyPermission.WINCOUNT = FSApplyPermission.WINCOUNT + 1;
								window.open(url,FSApplyPermission.WINCOUNT,'height=800,width=1280,top=0,left=0,toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no');
								//写入浏览记录
								var obj = $.ajax({
									url: '../DHCEPRRBAC.web.eprajax.Log.cls',
									data: {
										Action: 'addlog',
										EpisodeID: episodeID,
										UserID: appointUserID,
										LogType: 'VIEW',
										AuthorizationID: 'default',
										AuthorizationGroupID: 'default'
									},
									type: 'post',
									async: false
								});
							}
							else {
								$.messager.alert('错误','该病历未进入归档库','error');
								return;
							}
						}
					}
				}
			}
			else {
				var argAction = 'getviewparam';
				if (controlType == 'pdfjs') argAction = 'authviewpermission';
				var obj = $.ajax({
					url: '../DHCEPRRBAC.web.eprajax.View.cls',
					data: {
						Action: argAction,
						EpisodeID: episodeID,
						AuthorizationID: authGroupID
					},
					type: 'post',
					async: false
				});
				var ret = obj.responseText;
				if (ret == '-3') {
					$.messager.alert('错误','获取浏览参数失败','error');
					return;
				}
				else if (ret == '-2') {
					$.messager.alert('错误','所选的项目未被审批或者已被拒绝','error');
					return;
				}
				else if (ret == '-1') {
					$.messager.alert('错误','所选的项目已过期，请刷新列表，并重新申请','error');
					return;
				}
				else if ((ret != '') && (ret != null)) {
					if (controlType == 'pdfjs') {
						var url = 'dhc.epr.fs.pdfview.csp?Flag=apply&EpisodeID=' + episodeID + '&RoleID=' + ret;
						FSApplyPermission.WINCOUNT = FSApplyPermission.WINCOUNT + 1;
						window.open(url,FSApplyPermission.WINCOUNT,'height=800,width=1280,top=0,left=0,toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no');
						//写入浏览记录
						var obj = $.ajax({
							url: '../DHCEPRRBAC.web.eprajax.Log.cls',
							data: {
								Action: 'addlog',
								EpisodeID: episodeID,
								UserID: appointUserID,
								LogType: 'VIEW',
								AuthorizationID: authID,
								AuthorizationGroupID: authGroupID
							},
							type: 'post',
							async: false
						});
					}
					else {
						var strs = ret.split('|');
						var eprAction = strs[1];
						var operationCode = strs[2];
						var items = strs[3];
						if ((eprAction == 'FS')&&(operationCode == 'VIEW')) {
							var obj = $.ajax({
								type: 'POST',
								url: '../DHCEPRRBAC.web.eprajax.FS.cls',
								data: {
									Action: 'getveritem',
									EpisodeID: episodeID,
									Items: items
								},
								async: false
							});
							var retFS = obj.responseText;
							if ((retFS != '') && (retFS != null) && (retFS != '-1')) {
								var strsFS = retFS.split('!');
								var mrEpisodeID = strsFS[0];
								var verItems = strsFS[1];
								if ((verItems == '') || (verItems == null)) {
									$.messager.alert('错误','此次就诊在此权限下没有任何可浏览项目','error');
									return;
								}
								
								var url = 'dhc.epr.fs.viewrecord.csp?MREpisodeID=' + mrEpisodeID + '&MRVerItemsIDs=' + verItems + '&DataServiceUrl=' + FSApplyPermission.DATASERVICEURL;
								FSApplyPermission.WINCOUNT = FSApplyPermission.WINCOUNT + 1;
								window.open(url,FSApplyPermission.WINCOUNT,'height=800,width=1280,top=0,left=0,toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no');
								//写入浏览记录
								var obj = $.ajax({
									url: '../DHCEPRRBAC.web.eprajax.Log.cls',
									data: {
										Action: 'addlog',
										EpisodeID: episodeID,
										UserID: appointUserID,
										LogType: 'VIEW',
										AuthorizationID: authID,
										AuthorizationGroupID: authGroupID
									},
									type: 'post',
									async: false
								});
							}
							else{
								$.messager.alert('错误','该病历未进入归档库','error');
								return;
							}
						}
					}
				}
			}
		}
		
		function linkURLFormatter(value,row,index) {
			var linkFormatter = '';
			if (value && value != '') {
				var splitor = '&nbsp;&nbsp;';
				var arrLink = value.split('^');
				for (var i=0;i<arrLink.length;i++) {
					linkFormatter += splitor + '<a href="javascript:void(0)" onclick="FSApplyPermission.ViewRecord(\'' + arrLink[i] + '\',\'' + row.AuthorizationID + '\',\'' + row.AuthorizationDetailID + '\');">关联' + (i+1) + '</a>';
				}
			}
			return linkFormatter;
		}
		
		//添加收藏
		$('#addFavoriteBtn').on('click', function() {
			if (FSApplyPermission.typeCode == 'D') {
				var row = $('#applyDefaultListTable').datagrid('getSelected');
				if (row) {
					FSApplyPermission.selectEpisodeID = row.EpisodeID;
					FSApplyPermission.addFavoriteType = 'add';
					$('#addFavoriteDialog').dialog('open');
				}
				else {
					$.messager.alert('错误','请先选中一条就诊','error');
					return;
				}
			}
			else {
				if (FSApplyPermission.ExpandIndex == '-1'){
					$.messager.alert('错误','请先展开一条授权','error');
					return;
				}
				else if (FSApplyPermission.SubGridSelect == '-1') {
					$.messager.alert('错误','请先选中一条就诊','error');
					return;
				}
				else {
					var row = $('#ddv-' + FSApplyPermission.ExpandIndex).datagrid('getRows')[FSApplyPermission.SubGridSelect];
					FSApplyPermission.selectEpisodeID = row.EpisodeID;
					FSApplyPermission.addFavoriteType = 'add';
					$('#addFavoriteDialog').dialog('open');
				}
			}
		});
		
		//--------------------浏览记录--------------------
		//浏览记录弹窗
		$('#viewHistoryWin').dialog({
			title: '浏览记录',
			iconCls: 'icon-w-clock',
			closed: true,
			modal: true,
			onOpen: function() {
				var currDate = new Date();
				$('#historyDateStart').datebox('setValue',myformatter(currDate));
				$('#historyDateEnd').datebox('setValue',myformatter(currDate));
				FSApplyPermission.HDateStart = $('#historyDateStart').datebox('getValue');
				FSApplyPermission.HDateEnd = $('#historyDateEnd').datebox('getValue');
				refleshHistoryDG();
			}
		});
		
		//浏览记录
		$('#viewHistoryBtn').on('click', function() {
			//浏览记录列表
			$HUI.datagrid('#historyListTable',{
				title: '浏览记录列表',
				iconCls: 'icon-paper',
				headerCls: 'panel-header-gray',
				fit: true,
				toolbar: '#historyListTableTBar',
				url: $URL,
				queryParams: {
					ClassName: 'DHCEPRRBAC.BL.BLLog',
					QueryName: 'GetHistoryList',
					AUserID: appointUserID,
					ALogType: 'VIEW',
					AStartDate: FSApplyPermission.HDateStart,
					AEndDate: FSApplyPermission.HDateEnd,
					AViewType: 'A'
				},
				rownumbers: true,
				singleSelect: true,
				pagination: true,
				pageSize: 20,
				pageList: [10, 20, 50],
				columns: [[
					{field:'UserID',title:'UserID',width:80,hidden:true},
					{field:'UserName',title:'操作者',width:80,hidden:true},
					{field:'AppointStatus',title:'授权状态代码',width:80,hidden:true},
					{field:'AppointStatusDesc',title:'授权状态',width:100,formatter:formatStatusDesc},
					{field:'AuthorizationID',title:'AuthorizationID',width:80,hidden:true},
					{field:'AuthorizationGroupID',title:'AuthorizationGroupID',width:80,hidden:true},
					{field:'LogDate',title:'浏览日期',width:100},
					{field:'LogTime',title:'浏览时间',width:100},
					{field:'PAStatusType',title:'状态',width:80},
					{field:'PAAdmType',title:'就诊类型',width:80},
					{field:'MedRecordNo',title:'病案号',width:100},
					{field:'RegNo',title:'登记号',width:100},
					{field:'PAPMIName',title:'患者姓名',width:80},
					{field:'PADischgeDate',title:'出院日期',width:100},
					{field:'PADischgeTime',title:'出院时间',width:100},
					{field:'PAAdmLoc',title:'科室',width:120},
					{field:'PAAdmWard',title:'病区',width:120},
					{field:'PAAdmDoc',title:'医生',width:80},
					{field:'PAAdmDate',title:'入院日期',width:100},
					{field:'PAAdmTime',title:'入院时间',width:100},
					{field:'PAPMIDOB',title:'出生日期',width:100},
					{field:'PAPMIAge',title:'年龄',width:60},
					{field:'PAPMISex',title:'性别',width:60},
					{field:'PayMode',title:'付费类型',width:120},
					{field:'EpisodeID',title:'就诊号',width:80,hidden:true},
					{field:'PatientID',title:'病人号',width:80,hidden:true}
				]],
				onDblClickRow: function(index,row) {
					viewRecord(row.EpisodeID,row.AuthorizationGroupID,row.AuthorizationID,'dlg');
				}
			});
			
			//浏览记录列表查询 - 起始日期
			$('#historyDateStart').datebox({
				onSelect: function() {
					FSApplyPermission.HDateStart = $('#historyDateStart').datebox('getValue');
				},
				onChange: function() {  //避免不选择日期而采用输入的方式
					FSApplyPermission.HDateStart = $('#historyDateStart').datebox('getValue');
				}
			}); 
			
			//浏览记录列表查询 - 截止日期
			$('#historyDateEnd').datebox({
				onSelect: function() {
					FSApplyPermission.HDateEnd = $('#historyDateEnd').datebox('getValue');
				},
				onChange: function() {  //避免不选择日期而采用输入的方式
					FSApplyPermission.HDateEnd = $('#historyDateEnd').datebox('getValue');
				}
			});
			
			$('#refreshBtn').on('click', function() {
				refleshHistoryDG();
			});
			
			$('#viewHistoryWin').dialog('open');
		});
		
		//刷新浏览记录列表
		function refleshHistoryDG() {
			var queryParams = $('#historyListTable').datagrid('options').queryParams;
			queryParams.AStartDate = FSApplyPermission.HDateStart;
			queryParams.AEndDate = FSApplyPermission.HDateEnd;
			$('#historyListTable').datagrid('options').queryParams = queryParams;
			$('#historyListTable').datagrid('reload');
		}
		
		//--------------------收藏--------------------
		//收藏弹窗
		$('#viewFavoritesWin').dialog({
			title: '收藏',
			iconCls: 'icon-w-star',
			closed: true,
			modal: true,
			onOpen: function() {
				refleshCategory('categoryListTable');
			}
		});
		
		//收藏
		$('#viewFavoritesBtn').on('click', function() {
			$('#viewFavoritesWin').dialog('open');
		});
		
		//收藏分类列表
		$HUI.datagrid('#categoryListTable',{
			title: '收藏分类列表',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			fit: true,
			toolbar: '#categoryListTableTBar',
			url: $URL,
			queryParams: {
				ClassName: 'DHCEPRRBAC.BL.BLFavoritesCategory',
				QueryName: 'GetCategoryList',
				AUserID: appointUserID
			},
			singleSelect: true,
			columns: [[
				{field:'FavoritesCategoryID',title:'收藏分类ID',width:80,hidden:true},
				{field:'CategoryDesc',title:'分类',width:150}
			]],
			onSelect: function(rowIndex, rowData) {
				FSApplyPermission.selectFavoritesCategoryID = rowData.FavoritesCategoryID;
				refleshFavoritesList();
			}
		});
		
		//新增收藏分类
		$('#categoryAddBtn').on('click', function() {
			FSApplyPermission.DialogType = 'addcategory';
			$('#addCategoryDialog').dialog('open');
		});
		
		//删除收藏分类
		$('#categoryDeleteBtn').on('click', function() {
			deleteCategory('categoryListTable');
		});
		
		//收藏项列表
		$HUI.datagrid('#favoritesListTable',{
			title: '收藏项列表',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			fit: true,
			toolbar: '#favoritesListTableTBar',
			url: $URL,
			queryParams: {
				ClassName: 'DHCEPRRBAC.BL.BLFavorites',
				QueryName: 'GetList',
				AUserID: appointUserID,
				AFavoritesCategoryID: ''
			},
			singleSelect: false,
			pagination: true,
			pageSize: 20,
			pageList: [10, 20, 50],
			columns: [[
				{field:'ck',checkbox:true},
				{field:'FavoritesID',title:'FavoritesID',width:80,hidden:true},
				{field:'PAStatusType',title:'状态',width:80},
				{field:'PAAdmType',title:'就诊类型',width:80},
				{field:'MedRecordNo',title:'病案号',width:100},
				{field:'RegNo',title:'登记号',width:100},
				{field:'PAPMIName',title:'患者姓名',width:80},
				{field:'PADischgeDate',title:'出院日期',width:100},
				{field:'PADischgeTime',title:'出院时间',width:100},
				{field:'PAAdmLoc',title:'科室',width:120},
				{field:'PAAdmWard',title:'病区',width:120},
				{field:'PAAdmDoc',title:'医生',width:80},
				{field:'PAAdmDate',title:'入院日期',width:100},
				{field:'PAAdmTime',title:'入院时间',width:100},
				{field:'PAPMIDOB',title:'出生日期',width:100},
				{field:'PAPMIAge',title:'年龄',width:60},
				{field:'PAPMISex',title:'性别',width:60},
				{field:'PayMode',title:'付费类型',width:120},
				{field:'EpisodeID',title:'就诊号',width:80,hidden:true},
				{field:'PatientID',title:'病人号',width:80,hidden:true}
			]],
			onDblClickRow: function(index,row) {
				var episodeID = row.EpisodeID;
				//检查是否过期
				var obj = $.ajax({
					url: '../DHCEPRRBAC.web.eprajax.View.cls',
					data: {
						Action: 'check',
						EpisodeID: episodeID,
						UserID: appointUserID
					},
					type: 'post',
					async: false
				});
				var retCheck = obj.responseText;
				if (retCheck == '') {
					viewRecord(episodeID,'default','default','dlg');
				}
				else {
					var retCheckStrs = retCheck.split('||');
					var AuthorizationGroupID = retCheckStrs[0];
					var AuthorizationID = retCheck;
					viewRecord(episodeID,AuthorizationGroupID,AuthorizationID,'dlg');
				}
			}
		});
		
		//删除收藏项
		$('#favoritesDeleteBtn').on('click', function() {
			var rows = $('#favoritesListTable').datagrid('getSelections');
			if (rows.length <= 0) {
				$.messager.alert('错误','请先选择收藏项！','error');
				return;
			}
			else {
				$.messager.confirm('确认删除','确定要删除选中？',function(r) {
					if (r) {
						var ids = '';
						for (var i=0;i<rows.length;i++) {
							var id = rows[i].FavoritesID
							if (ids == '') {
								ids = id;
							}
							else {
								ids = ids + '^' + id;
							}
						}
						var obj = $.ajax({
							url: '../DHCEPRRBAC.web.eprajax.Favorites.cls',
							data: {
								Action: 'delete',
								FavoritesIDS: ids
							},
							type: 'post',
							async: false
						});
						var ret = obj.responseText;
						if (parseInt(ret) > 0) {
							$.messager.alert('提示','删除收藏项成功！','info',function() {
								refleshFavoritesList();
							});
						}
						else {
							$.messager.alert('错误','删除收藏项失败，请重新尝试！','error');
							return;
						}
					}
				});
			}
		});
		
		//移动收藏项
		$('#favoritesMoveBtn').on('click', function() {
			var rows = $('#favoritesListTable').datagrid('getSelections');
			if (rows.length <= 0) {
				$.messager.alert('错误','请先选择收藏项！','error');
				return;
			}
			else {
				var ids = '';
				var episodes = '';
				for (var i=0;i<rows.length;i++) {
					var id = rows[i].FavoritesID;
					var episode = rows[i].EpisodeID;
					if (ids == '') {
						ids = id;
						episodes = episode;
					}
					else {
						ids = ids + '^' + id;
						episodes = episodes + '^' + episode;
					}
				}
				FSApplyPermission.favoritesIDS = ids;
				FSApplyPermission.favoritesEpisodeIDS = episodes;
				FSApplyPermission.addFavoriteType = 'move';
				$('#addFavoriteDialog').dialog('open');
			}
		});
		
		//添加收藏弹窗
		$('#addFavoriteDialog').dialog({
			title: '添加收藏',
			iconCls: 'icon-w-star',
			closed: true,
			cache: false,
			modal: true,
			buttons: [{
				text: '保存',
				handler: function() {
					var row = $('#categoryListSelectTable').datagrid('getSelected');
					if (row) {
						var categoryID = row.FavoritesCategoryID;
						var favorData = {}, favorText = '';
						favorData.Action = FSApplyPermission.addFavoriteType;
						favorData.FavoritesCategoryID = categoryID;
						favorData.UserID = appointUserID;
						if (FSApplyPermission.addFavoriteType == 'add') {
							favorData.EpisodeID = FSApplyPermission.selectEpisodeID;
							favorText = '添加收藏项';
						}
						else {
							favorData.FavoritesIDS = FSApplyPermission.favoritesIDS;
							favorData.EpisodeIDS = FSApplyPermission.favoritesEpisodeIDS;
							favorText = '移动收藏项';
						}
						var obj = $.ajax({
							url: '../DHCEPRRBAC.web.eprajax.Favorites.cls',
							data: favorData,
							type: 'post',
							async: false
						});
						var ret = obj.responseText;
						if (ret == '-2') {
							$.messager.alert('提示','就诊已经在此收藏分类中存在，请勿重复加入','info');
							return;
						}
						else if (parseInt(ret) > 0) {
							$.messager.alert('提示',favorText + '成功！','info',function() {
								if (FSApplyPermission.addFavoriteType == 'move') {
									refleshFavoritesList();
								}
								$('#addFavoriteDialog').dialog('close');
							});
						}
						else {
							$.messager.alert('错误',favorText + '失败，请重新尝试！','error');
							return;
						}
					}
					else {
						$.messager.alert('错误','请先选择一个分类！','error');
						return;
					}
				}
			},{
				text: '取消',
				handler: function() {
					$('#addFavoriteDialog').dialog('close');
				}
			}],
			onOpen: function() {
				refleshCategory('categoryListSelectTable');
			}
		});
		
		//收藏分类列表
		$HUI.datagrid('#categoryListSelectTable',{
			title: '收藏分类列表',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			fit: true,
			toolbar: '#categoryListTableSelectTBar',
			url: $URL,
			queryParams: {
				ClassName: 'DHCEPRRBAC.BL.BLFavoritesCategory',
				QueryName: 'GetCategoryList',
				AUserID: appointUserID
			},
			singleSelect: true,
			columns: [[
				{field:'FavoritesCategoryID',title:'收藏分类ID',width:80,hidden:true},
				{field:'CategoryDesc',title:'分类',width:300}
			]]
		});
		
		//新增收藏分类
		$('#categorySelectAddBtn').on('click', function() {
			FSApplyPermission.DialogType = 'addcategory';
			$('#addCategoryDialog').dialog('open');
		});
		
		//新增收藏分类弹窗
		$('#addCategoryDialog').dialog({
			title: '新增收藏分类',
			closed: true,
			cache: false,
			modal: true,
			buttons: [{
				text: '确认',
				handler: function() {
					var categoryDesc = $('#inputCategoryDesc').val();
					if (categoryDesc == '') {
						$.messager.alert('提示','请填写分类名称','info');
						return;
					}
					else {
						var obj = $.ajax({
							url: '../DHCEPRRBAC.web.eprajax.FavoritesCategory.cls',
							data: {
								Action: FSApplyPermission.DialogType,
								Desc: categoryDesc,
								UserID: appointUserID
							},
							type: 'post',
							async: false
						});
						var ret = obj.responseText;
						if (parseInt(ret) > 0) {
							$.messager.alert('提示','新增收藏分类成功！','info',function() {
								refleshCategory('categoryListTable');
								refleshCategory('categoryListSelectTable');
								$('#addCategoryDialog').dialog('close');
							});
						}
						else {
							$.messager.alert('错误','新增收藏分类失败，请重新尝试！','error');
							return;
						}
					}
				}
			},{
				text: '取消',
				handler: function() {
					$('#addCategoryDialog').dialog('close');
				}
			}]
		});
		
		function refleshCategory(id) {
			var queryParams = $('#' + id).datagrid('options').queryParams;
			queryParams.AUserID = appointUserID;
			$('#' + id).datagrid('options').queryParams = queryParams;
			$('#' + id).datagrid('reload');
		}
		
		function deleteCategory(id) {
			var row = $('#' + id).datagrid('getSelected');
			if (row) {
				$.messager.confirm('确认删除','删除收藏分类会将其下的所有收藏项一并删除，确认要删除收藏分类？',function(r) {
					if (r) {
						var categoryID = row.FavoritesCategoryID;
						var obj = $.ajax({
							url: '../DHCEPRRBAC.web.eprajax.FavoritesCategory.cls',
							data: {
								Action: 'deletecategory',
								FavoritesCategoryID: categoryID
							},
							type: 'post',
							async: false
						});
						var ret = obj.responseText;
						if (parseInt(ret) > 0) {
							$.messager.alert('提示','删除收藏分类成功！','info',function() {
								refleshCategory('categoryListTable');
							});
						}
						else {
							$.messager.alert('错误','删除收藏分类失败，请重新尝试！','error');
							return;
						}
					}
				});
			}
			else {
				$.messager.alert('错误','请先选择一个收藏分类！','error');
				return;
			}
		}
		
		function refleshFavoritesList() {
			var queryParams = $('#favoritesListTable').datagrid('options').queryParams;
			queryParams.AUserID = appointUserID;
			queryParams.AFavoritesCategoryID = FSApplyPermission.selectFavoritesCategoryID;
			$('#favoritesListTable').datagrid('options').queryParams = queryParams;
			$('#favoritesListTable').datagrid('reload');
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