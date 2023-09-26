var FSAuthorization = new Object();

FSAuthorization.dateStart = "";
FSAuthorization.dateEnd = "";
FSAuthorization.typeCode = "";
FSAuthorization.spanTime = "";

FSAuthorization.opID = "";
FSAuthorization.opCode = "";
FSAuthorization.opDesc = "";
FSAuthorization.pddID = "";
FSAuthorization.pddCode = "";
FSAuthorization.pddDesc = "";
FSAuthorization.pddDesc = "";
FSAuthorization.pddLevel = "";

FSAuthorization.HDateStart = "";
FSAuthorization.HDateEnd = "";
FSAuthorization.ViewType = "A";

FSAuthorization.ADateStart = "";
FSAuthorization.ADateEnd = "";

FSAuthorization.roleID = "";

FSAuthorization.ExpandAppointID = "";
FSAuthorization.DATESPAN = 7;
FSAuthorization.DialogType = "R";
FSAuthorization.RoleItems = "";

(function($) {
    $(function() {
		//设置系统标识
		var sysDesc = systemName + '&nbsp;&nbsp;&nbsp;&nbsp;' + systemVersion;
		$('#systemDesc').html(sysDesc);
	//菜单栏-------------------------------------------------------------------------------------------------------------------------
        //特殊病历维护---------------------------------------------------------------------------------------------------------------------------
		var winInline = $('#advancedSecurityWin').window({
			modal:true,
			inline:true,
			closed:true,
			iconCls:'icon-add',
			title: '特殊病历维护'
		});
		
		//点击弹窗
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
	                MedRecordID:''
	            },
	            method: 'post',
	            loadMsg: '数据装载中......',
	            singleSelect: true,
	            showHeader: true,
	            //fitColumns: true,
				rownumbers:true,
	            columns: [[
					{ field: 'ck', checkbox: true},
	                { field: 'PAStatusType', title: '状态', width: 80, sortable: true },
	                { field: 'PAAdmType', title: '就诊类型', width: 80, sortable: true },
	                { field: 'PAPMIName', title: '病人姓名', width: 80, sortable: true },
	                { field: 'PAPMINO', title: '登记号', width: 80, sortable: true },
	                { field: 'PAPMIDOB', title: '出生日期', width: 100, sortable: true },
	                { field: 'PAPMIAge', title: '年龄', width: 80, sortable: true },
	                { field: 'PAPMISex', title: '性别', width: 80, sortable: true },
	                { field: 'PAAdmDateTime', title: '入院时间', width: 150, sortable: true },
	                { field: 'PAAdmWard', title: '病区', width: 80, sortable: true },
	                { field: 'PAAdmRoom', title: '病房', width: 80, sortable: true },
	                { field: 'PAAdmBed', title: '病床', width: 80, sortable: true },
	                { field: 'PAAdmLoc', title: '科室', width: 80, sortable: true },
	                { field: 'PADischgeDateTime', title: '出院时间', width: 150, sortable: true },
	                { field: 'PAAdmDoc', title: '医生', width: 80, sortable: true },
	                { field: 'PayMode', title: '付费类型', width: 80, sortable: true },
	                { field: 'EpisodeID', title: '就诊号', width: 80, sortable: true },
	                { field: 'PatientID', title: '病人号', width: 80, sortable: true },
                    { field: 'IsAdvancedSecurity', title: 'IsAdvancedSecurity', width: 80, sortable: true, hidden:true }
	            ]],
                rowStyler:function(index,row){
                    if (row.IsAdvancedSecurity == "Y")
                    {
                        return 'background-color:pink;color:blue;font-weight:bold;';
                    }
                },
	            pagination: true,
	            pageSize: 20,
	            pageList: [10, 20, 50],
	            pagePosition: 'bottom',
	            toolbar: '#patientListTableTBar',
	            title: '特殊病历查询'
	        });

			//查询患者
	        $('#patientSearchBtn').on('click', function() {
	            searchPatient();
	        });
	
	        //清空患者查询条件
	        $('#patientResetBtn').on('click', function() {
	            $('#inputPatientName').val('');
	            $('#inputPatientEpisodeID').val('');
	            $('#inputPatientRegNo').val('');
	            $('#inputPatientID').val('');
	            $('#inputMedRecordID').val('');
	            $('#inputPatientLoc').combogrid("setValue", '');
	            $('#inputPatientWard').combogrid("setValue", '');
	        });
	
	        //输入框enter事件
	        $('#inputPatientName').on('keypress', function(event) {
	            if (event.keyCode == "13") {
	                searchPatient();
	            }
	        });
	
	        $('#inputPatientEpisodeID').on('keypress', function(event) {
	            if (event.keyCode == "13") {
	                searchPatient();
	            }
	        });
	
	        $('#inputPatientID').on('keypress', function(event) {
	            if (event.keyCode == "13") {
	                searchPatient();
	            }
	        });
	
	        $('#inputPatientRegNo').on('keypress', function(event) {
	            if (event.keyCode == "13") {
	                searchPatient();
	            }
	        });
	        
	        $('#inputMedRecordID').on('keypress', function(event) {
	            if (event.keyCode == "13") {
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
		
		//待申请列表
		$('#advancedSecurityListTable').datagrid({
            //url: '',
	        queryParams: {
			    Action: 'episodelist' 
            },
	        method: 'post',
	        loadMsg: '数据装载中......',
		    showHeader: true,
            singleSelect: true,
            //fitColumns: true,
			rownumbers:true,
            columns: [[
				{ field: 'ck', checkbox: true},
                { field: 'UserID', title: 'UserID', width: 80, sortable: true, hidden:true },
                { field: 'UserName', title: '加入用户名', width: 80, sortable: true },
                { field: 'ActDateTime', title: '加入日期时间', width: 80, sortable: true },
                { field: 'PAStatusType', title: '状态', width: 80, sortable: true },
                { field: 'PAAdmType', title: '就诊类型', width: 80, sortable: true },
                { field: 'PAPMIName', title: '病人姓名', width: 80, sortable: true },
                { field: 'PAPMINO', title: '登记号', width: 80, sortable: true },
                { field: 'PAPMIDOB', title: '出生日期', width: 100, sortable: true },
                { field: 'PAPMIAge', title: '年龄', width: 80, sortable: true },
                { field: 'PAPMISex', title: '性别', width: 80, sortable: true },
                { field: 'PAAdmDateTime', title: '入院时间', width: 150, sortable: true },
                { field: 'PAAdmWard', title: '病区', width: 80, sortable: true },
                { field: 'PAAdmRoom', title: '病房', width: 80, sortable: true },
                { field: 'PAAdmBed', title: '病床', width: 80, sortable: true },
                { field: 'PAAdmLoc', title: '科室', width: 80, sortable: true },
                { field: 'PADischgeDateTime', title: '出院时间', width: 150, sortable: true },
                { field: 'PAAdmDoc', title: '医生', width: 80, sortable: true },
                { field: 'PayMode', title: '付费类型', width: 80, sortable: true },
                { field: 'EpisodeID', title: '就诊号', width: 80, sortable: true },
                { field: 'PatientID', title: '病人号', width: 80, sortable: true }
            ]],
            rowStyler:function(index,row){
                return 'background-color:pink;color:blue;font-weight:bold;';
            },
            pagination: true,
	        pageSize: 20,
	        pageList: [10, 20, 50],
	        pagePosition: 'bottom',
	        toolbar: '#advancedSecurityListTableTBar',
	        title: '特殊病历查询'
		});
		
		//将就诊添加到特殊病历列表
		$('#addListBtn').on('click', function() {
			var rows = $('#patientListTable').datagrid("getSelections");
				
			if (rows.length != 1){
				$.messager.alert('错误', '请选择一条就诊！', 'error');
			}
			else {			
				var obj = $.ajax({
					url: "../DHCEPRRBAC.web.eprajax.AdvancedSecurity.cls?Action=add&SysCode=DHC&EpisodeID=" + rows[0].EpisodeID + "&UserID=" +  appointUserID,
					type: 'post',
					async: false
				});

				var ret = obj.responseText;
				if (ret == "-2") {
					$.messager.alert('错误', '已存在此就诊！', 'error');
				}
				else if (ret == "-1") {
					$.messager.alert('错误', '增加失败，请重新尝试！', 'error');
				}
				else if ((ret != "") && (ret != null) && (parseInt(ret) > 0)) {
					$.messager.alert('提示', '增加成功！', 'info');
					loadAdvancedSecurityList();
				}
			}

		});
		
		//将就诊从特殊病历列表中删除
		$('#removeListBtn').on('click', function() {
			var rows = $('#advancedSecurityListTable').datagrid("getSelections");
						
			if (rows.length != 1){
				$.messager.alert('错误', '请选择一条就诊！', 'error');
			}
			else {			
				var obj = $.ajax({
					url: "../DHCEPRRBAC.web.eprajax.AdvancedSecurity.cls?Action=remove&SysCode=DHC&EpisodeID=" + rows[0].EpisodeID + "&UserID=" +  appointUserID,
					type: 'post',
					async: false
				});

				var ret = obj.responseText;
                if (ret == "-1") {
					$.messager.alert('错误', '移除失败，请重新尝试！', 'error');
				}
				else if ((ret != "") && (ret != null) && (parseInt(ret) > 0)) {
					$.messager.alert('提示', '移除成功！', 'info');
					loadAdvancedSecurityList();
				}
			}
		});

        $('#resetListBtn').on('click', function() {
	         loadAdvancedSecurityList();
	    });

        function loadAdvancedSecurityList()
        {
  	        var url = '../DHCEPRRBAC.web.eprajax.AdvancedSecurity.cls';
	        $('#advancedSecurityListTable').datagrid('options').url = url;
	        var queryParams = $('#advancedSecurityListTable').datagrid('options').queryParams;
	        queryParams.Action = 'episodelist'; 
	        $('#advancedSecurityListTable').datagrid('options').queryParams = queryParams;
	        $('#advancedSecurityListTable').datagrid('reload');          
        }

		//浏览历史记录-------------------------------------------------------------------------------
        //浏览类型
        $('#historyViewType').combogrid({
            idField: 'id',
            textField: 'text',
            data: [{
                id: '0',
                text: '全部',
				code: 'A'
            }, {
                id: '1',
                text: '授权浏览',
				code: 'N'
            }, {
                id: '2',
                text: '默认角色浏览',
				code: 'D'
			}],
            panelWidth: 300,
            showHeader: false,
			singleSelect: true,
            columns: [[
                { field: 'id', title: 'id', width: 80, hidden: true },
                { field: 'code', title: 'code', width: 80, hidden: true },
                { field: 'text', title: '浏览类型', width: 250 }
            ]],
			onSelect: function() {
                var rows = $('#historyViewType').combogrid('grid').datagrid('getSelections');
                var row = rows[0];
                FSAuthorization.ViewType = row["code"];
				
				//refleshHistoryDG();	
            },
			onLoadSuccess: function() {
                $('#historyViewType').combogrid('grid').datagrid('selectRow', 0);
            }
        });


		function refleshHistoryDG(){
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
		
        //浏览记录按钮
        $('#viewHistorySummaryBtn').on('click', function() {
        	//浏览记录列表
	        var historyDG = $('#historyListTable').datagrid({
	            //url: '',
	            queryParams: {
					Action: 'historylistsummary',
	                LogType: 'VIEW',
                    ViewType: FSAuthorization.ViewType,
	                StartDate: FSAuthorization.HDateStart,
	                EndDate: FSAuthorization.HDateEnd
	            },
	            method: 'post',
	            loadMsg: '数据装载中......',
	            singleSelect: true,
	            showHeader: true,
	            //fitColumns: true,
				rownumbers:true,
	            columns: [[
                    { field: 'UserID', title: 'UserID', width: 80, sortable: true, hidden: true },
                    { field: 'UserName', title: '操作者', width: 80, sortable: true },
			        { field: 'AppointStatus', title: '授权情况', width: 80, sortable: true, hidden: true },
			        { field: 'AppointStatusDesc', title: '授权情况', width: 80, sortable: true, formatter: formatStatusDesc },
			        { field: 'AuthorizationID', title: '状态', width: 80, sortable: true, hidden: true },
			        { field: 'AuthorizationGroupID', title: '状态', width: 80, sortable: true, hidden: true },
			        { field: 'OperationDateTime', title: '操作日期时间', width: 150, sortable: true },
	                { field: 'PAStatusType', title: '状态', width: 80, sortable: true },
	                { field: 'PAAdmType', title: '就诊类型', width: 80, sortable: true },
	                { field: 'PAPMIName', title: '病人姓名', width: 80, sortable: true },
	                { field: 'RegNo', title: '登记号', width: 80, sortable: true },
	                { field: 'PAPMIDOB', title: '出生日期', width: 100, sortable: true },
	                { field: 'PAPMIAge', title: '年龄', width: 80, sortable: true },
	                { field: 'PAPMISex', title: '性别', width: 80, sortable: true },
	                { field: 'PAAdmDateTime', title: '入院时间', width: 150, sortable: true },
	                { field: 'PAAdmWard', title: '病区', width: 80, sortable: true },
	                { field: 'PAAdmRoom', title: '病房', width: 80, sortable: true },
	                { field: 'PAAdmBed', title: '病床', width: 80, sortable: true },
	                { field: 'PAAdmLoc', title: '科室', width: 80, sortable: true },
	                { field: 'PADischgeDateTime', title: '出院时间', width: 150, sortable: true },
	                { field: 'PAAdmDoc', title: '医生', width: 80, sortable: true },
	                { field: 'PayMode', title: '付费类型', width: 80, sortable: true },
	                { field: 'EpisodeID', title: '就诊号', width: 80, sortable: true },
	                { field: 'PatientID', title: '病人号', width: 80, sortable: true }
	            ]],
	            pagination: true,
	            pageSize: 20,
	            pageList: [10, 20, 50],
	            pagePosition: 'bottom',
	            toolbar: '#historyListTableTBar',
	            title: '浏览记录汇总列表'
	        });
			
			//浏览记录列表时间过滤 - 起始日期
			$('#historyDateStart').datebox({    
				onSelect: function() {
					FSAuthorization.HDateStart = $('#historyDateStart').datebox('getValue');
	            }			
			}); 
	
			//浏览记录列表时间过滤 - 截止日期
			$('#historyDateEnd').datebox({    
				onSelect: function() {
					FSAuthorization.HDateEnd = $('#historyDateEnd').datebox('getValue');
	            }			
			});
        	
			var currDate = new Date();     
 　 			$("#historyDateStart").datebox("setValue",myformatter(currDate));  
 　 			$("#historyDateEnd").datebox("setValue",myformatter(currDate));  
			FSAuthorization.HDateStart = $('#historyDateStart').datebox('getValue');
			FSAuthorization.HDateEnd = $('#historyDateEnd').datebox('getValue');
 
	        $('#refreshBtn').on('click', function() {
				refleshHistoryDG();	
	        });	
 			
 			//refleshHistoryDG();	
			$('#viewHistorySummaryWin').window('open');	
        });	 
		
		//浏览记录弹窗
		var winHistory = $('#viewHistorySummaryWin').window({
			modal:true,
			inline:true,
			closed:true,
			iconCls:'icon-search',
			title: '浏览记录汇总'
		});
	
    	//授权记录汇总-------------------------------------------------------------------------------
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
		
        //授权记录按钮
        $('#authorizationSummaryBtn').on('click', function() {
        	//浏览记录列表
	        var authorizationSummaryDG = $('#authorizationSummaryListTable').datagrid({
	            //url: '',
	            queryParams: {
                    Action: 'authorizationlist',
	                AStartDate: FSAuthorization.ADateStart,
	                AEndDate: FSAuthorization.ADateEnd
	            },
	            method: 'post',
	            loadMsg: '数据装载中......',
	            singleSelect: true,
	            showHeader: true,
	            //fitColumns: true,
				rownumbers:true,
                columns: [[
		            { field: 'ck', checkbox: true },
		            { field: 'AuthorizationID', title: 'AuthorizationID', width: 80, sortable: true, hidden:true },
                    { field: 'RequestUserID', title: 'RequestUserID', width: 80, sortable: true, hidden:true },
                    { field: 'RequestUserName', title: '申请人', width: 80, sortable: true },
                    { field: 'RequestDeptID', title: 'RequestDeptID', width: 80, sortable: true, hidden:true },			
                    { field: 'RequestDept', title: '申请人科室', width: 80, sortable: true, hidden:true },
		            { field: 'RequestSSGroupID', title: '申请人安全组', width: 80, sortable: true, hidden:true },		
                    { field: 'RequestDateTime', title: '申请日期时间', width: 150, sortable: true },
		            { field: 'RequestReason', title: '申请原因', width: 150, sortable: true },
		            { field: 'RequestTimeSpan', title: '申请时间(小时)', width: 80, sortable: true },
                    { field: 'AppointUserID', title: 'AppointUserID', width: 80, sortable: true, hidden:true },
                    { field: 'AppointUserName', title: '批准人', width: 80, sortable: true },
                    { field: 'AppointDateTime', title: '批准日期时间', width: 150, sortable: true },
		            { field: 'AppointEndDateTime', title: '批准到期日期时间', width: 150, sortable: true },
                    { field: 'RoleID', title: 'RoleID', width: 80, sortable: true, hidden:true },
		            { field: 'RoleCode', title: '分配角色代码', width: 80, sortable: true },
                    { field: 'RoleDesc', title: '分配角色', width: 80, sortable: true },
		            { field: 'OperationID', title: 'OperationID', width: 80, sortable: true, hidden:true },
		            { field: 'OperationCode', title: '操作类型代码', width: 80, sortable: true, hidden:true },
                    { field: 'OperationDesc', title: '操作类型描述', width: 80, sortable: true },
                    { field: 'EPRAction', title: '分配权限类型代码', width: 80, sortable: true, hidden:true },
		            { field: 'EPRActionDesc', title: '分配权限类型', width: 80, sortable: true },
                    { field: 'AppointType', title: 'AppointType', width: 80, sortable: true, hidden:true },
                    { field: 'AppointStatus', title: '授权状态代码', width: 80, sortable: true, hidden:true },
		            { field: 'AppointStatusDesc', title: '授权状态', width: 80, sortable: true, formatter: formatStatusDesc },
		            { field: 'AppointComment', title: '被拒绝或取消原因', width: 200, sortable: true },
                    { field: 'HasAdvancedSecurity', title: 'HasAdvancedSecurity', width: 80, sortable: true, hidden:true }
	            ]],
                rowStyler:function(index,row){
                    if (row.HasAdvancedSecurity == "Y")
                    {
                        return 'background-color:pink;color:blue;font-weight:bold;';
                    }
                },
	            pagination: true,
	            pageSize: 20,
	            pageList: [10, 20, 50],
	            pagePosition: 'bottom',
	            toolbar: '#authorizationSummaryListTableTBar',
	            title: '授权记录汇总列表'
	        });
			
			//浏览记录列表时间过滤 - 起始日期
			$('#authorizationDateStart').datebox({    
				onSelect: function() {
					FSAuthorization.ADateStart = $('#authorizationDateStart').datebox('getValue');
	            }			
			}); 
	
			//浏览记录列表时间过滤 - 截止日期
			$('#authorizationDateEnd').datebox({    
				onSelect: function() {
					FSAuthorization.ADateEnd = $('#authorizationDateEnd').datebox('getValue');
	            }			
			});
        	
			var currDate = new Date();     
 　 			$("#authorizationDateStart").datebox("setValue",myformatter(currDate));  
 　 			$("#authorizationDateEnd").datebox("setValue",myformatter(currDate));  
			FSAuthorization.ADateStart = $('#authorizationDateStart').datebox('getValue');
			FSAuthorization.ADateEnd = $('#authorizationDateEnd').datebox('getValue');
 
	        $('#authorizationRefreshBtn').on('click', function() {
				refleshAuthorizationDG();	
	        });	
 			
 			//refleshHistoryDG();	
			$('#authorizationSummaryWin').window('open');	
        });	 
		
		//浏览记录弹窗
		var winHistory = $('#authorizationSummaryWin').window({
			modal:true,
			inline:true,
			closed:true,
			iconCls:'icon-search',
			title: '授权记录汇总'
		});
    	
	//角色---------------------------------------------------------------------------------------------------------------------------
        var roleDG = $('#roleListTable').datagrid({
            url: '../DHCEPRRBAC.web.eprajax.Role.cls',
            queryParams: {
                Action: 'rolelist'
            },
            method: 'post',
            loadMsg: '数据装载中......',
            singleSelect: true,
            showHeader: true,
            //fitColumns: true,
            columns: [[
                { field: 'RoleID', title: '用户ID', width: 80, sortable: true, hidden:true },
                { field: 'RoleName', title: '角色名称', width: 80, sortable: true },
                { field: 'RoleCode', title: '角色代码', width: 80, sortable: true },
                { field: 'RoleDesc', title: '角色描述', width: 80, sortable: true },
                { field: 'DefaultRole', title: '默认角色', width: 80, sortable: true }
            ]],
            pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            pagePosition: 'bottom',
            toolbar: '#roleListTableTBar',
			onSelect: function(rowIndex, rowData) {
				FSAuthorization.roleID = "";
				$('#inputRoleName').val(rowData.RoleName);
				$('#inputRoleDesc').val(rowData.RoleDesc);
				$('#inputRoleCode').val(rowData.RoleCode);
				FSAuthorization.roleID = rowData.RoleID;

				$('#roleItemDisplayTable').datagrid('loadData',{total:0,rows:[]});
				var url = '../DHCEPRRBAC.web.eprajax.Role.cls';
				$('#roleItemDisplayTable').datagrid('options').url = url;
				var queryParams = $('#roleItemDisplayTable').datagrid('options').queryParams;
				queryParams.Action = 'getroleitempage';
				queryParams.RoleID = FSAuthorization.roleID;

				$('#roleItemDisplayTable').datagrid('options').queryParams = queryParams;
				$('#roleItemDisplayTable').datagrid('reload');
            },
            view: detailview,
			detailFormatter:function(index,row){
                return '<div style="padding:2px"><table class="ddvrole" id="ddvrole-' + index + '"></table></div>';
            },
			onExpandRow: function(index,row){	
				//展开即选中
				$('#roleListTable').datagrid('selectRow', index);

				$('#ddvrole-' + index).datagrid({
					url:'../DHCEPRRBAC.web.eprajax.Role.cls',
					queryParams: {
						Action: 'rolelistdetail',
						RoleID: row.RoleID
					},
					method: 'post',
					loadMsg: '数据装载中......',
					//fitColumns:true,
					singleSelect:true,
					rownumbers:true,
					height:'auto',
					columns:[[
					    { field: 'SSGroupID', title: '安全组ID', width: 80, sortable: true },
						{ field: 'SSGroupName', title: '安全组名称', width: 150, sortable: true },
						{ field: 'RoleID', title: '角色ID', width: 150, sortable: true, hidden:true }
					]],
					onResize:function(){
						$('#roleListTable').datagrid('fixDetailRowHeight',index);
					},
					onLoadSuccess:function(){
						setTimeout(function(){
							$('#roleListTable').datagrid('fixDetailRowHeight',index);
						},0);
					}
				});
				$('#roleListTable').datagrid('fixDetailRowHeight',index);
			}
        });		
		
		//新增角色
        $('#roleAddBtn').on('click', function() {
            var roleName = $('#inputRoleName').val();
            var roleDesc = $('#inputRoleDesc').val();
            var roleCode = $('#inputRoleCode').val();
			
			if ((roleCode == "") || (roleCode == null)){
				$.messager.alert('错误', '角色代码不能为空！', 'error');
			}
			else {
				//用户码必须唯一，检查用户码是否存在			
				var obj = $.ajax({
					url: "../DHCEPRRBAC.web.eprajax.Role.cls?Action=addrole&RoleName=" +  encodeURI(roleName) + "&RoleCode=" + roleCode + "&RoleDesc=" +  encodeURI(roleDesc),
					type: 'post',
					async: false
				});

				var ret = obj.responseText;
				if (ret == "-2") {
					$.messager.alert('错误', '已存在此角色码，请修改后重新新增，角色码要唯一！', 'error');
				}
				else if (ret == "-1") {
					$.messager.alert('错误', '新增角色失败，请重新尝试！', 'error');
				}
				else if ((ret != "") && (ret != null) && (parseInt(ret) > 0)) {
					$.messager.alert('提示', '新增角色成功！', 'info');
					$('#roleListTable').datagrid('reload');
				}
			}
        });
		
		//修改角色
        $('#roleSaveBtn').on('click', function() {
            var roleName = $('#inputRoleName').val();
            var roleDesc = $('#inputRoleDesc').val();
            var roleCode = $('#inputRoleCode').val();
			
			var rows = $('#roleListTable').datagrid("getSelections");
			var roleID = rows[0].RoleID
			
			if (rows.length != 1){
				$.messager.alert('错误', '请先选择一个角色！', 'error');
			}
			
			if ((roleCode == "") || (roleCode == null)){
				$.messager.alert('错误', '角色代码不能为空！', 'error');
			}
			else {			
				var obj = $.ajax({
					url: "../DHCEPRRBAC.web.eprajax.Role.cls?Action=modifyrole&RoleID=" + roleID + "&RoleName=" +  encodeURI(roleName) + "&RoleCode=" + roleCode + "&RoleDesc=" +  encodeURI(roleDesc),
					type: 'post',
					async: false
				});

				var ret = obj.responseText;
				if (ret == "-2") {
					$.messager.alert('错误', '已存在此角色码，请修改后重新修改，角色码要唯一！', 'error');
				}
				else if (ret == "-1") {
					$.messager.alert('错误', '修改角色失败，请重新尝试！', 'error');
				}
				else if ((ret != "") && (ret != null) && (parseInt(ret) > 0)) {
					$.messager.alert('提示', '修改角色成功！', 'info');
					$('#roleListTable').datagrid('reload');
				}
			}
        });
		
		//角色添加权限弹窗
		var winInline = $('#addWin').window({
			modal:true,
			inline:true,
			closed:true,
			iconCls:'icon-add',
			title: '角色添加权限'
		});
		
		//点击弹窗
        $('#addItemBtn').on('click', function() {
			var rows = $('#roleListTable').datagrid("getSelections");
			
			if (rows.length != 1){
				$.messager.alert('错误', '请先选择一个角色！', 'error');
			}
			else {
				FSAuthorization.roleID = rows[0].RoleID;
				
				var queryParams = $('#roleItemTable').datagrid('options').queryParams;
				queryParams.Action = 'getroleitem';
				queryParams.RoleID = FSAuthorization.roleID;

				$('#roleItemTable').datagrid('options').queryParams = queryParams;
				$('#roleItemTable').datagrid('reload');
				$('#itemListTable').datagrid('getPager').pagination('select',1);
				$('#roleItemTable').datagrid('getPager').pagination('select',1);
				
				$('#addWin').window('open');
			}
        });
		
	//待授权列表-------------------------------------------------------------------------------------------------------------------
        var authorizationlistDG = $('#authorizationListTable').datagrid({
            url: '../DHCEPRRBAC.web.eprajax.ApplyPermission.cls',
            queryParams: {
                Action: 'getlist',
                ApplyStatus: 'N',
		        UserID: appointUserID,
                ApplyStartDate: '',
                ApplyEndDate: ''
            },
            method: 'post',
            loadMsg: '数据装载中......',
            singleSelect: false,
	        rownumbers:true,
            showHeader: true,
            //fitColumns: true,
            columns: [[
		        { field: 'ck', checkbox: true },
		        { field: 'AuthorizationID', title: 'AuthorizationID', width: 80, sortable: true, hidden:true },
                { field: 'RequestUserID', title: 'RequestUserID', width: 80, sortable: true, hidden:true },
                { field: 'RequestUserName', title: '申请人', width: 80, sortable: true },
                { field: 'RequestDeptID', title: 'RequestDeptID', width: 80, sortable: true, hidden:true },			
                { field: 'RequestDept', title: '申请人科室', width: 80, sortable: true, hidden:true },
		        { field: 'RequestSSGroupID', title: '申请人安全组', width: 80, sortable: true, hidden:true },		
                { field: 'RequestDateTime', title: '申请日期时间', width: 150, sortable: true },
		        { field: 'RequestReason', title: '申请原因', width: 150, sortable: true },
		        { field: 'RequestTimeSpan', title: '申请时间(小时)', width: 80, sortable: true },
                { field: 'AppointUserID', title: 'AppointUserID', width: 80, sortable: true, hidden:true },
                { field: 'AppointUserName', title: '批准人', width: 80, sortable: true },
                { field: 'AppointDateTime', title: '批准日期时间', width: 150, sortable: true },
		        { field: 'AppointEndDateTime', title: '批准到期日期时间', width: 150, sortable: true },
                { field: 'RoleID', title: 'RoleID', width: 80, sortable: true, hidden:true },
		        { field: 'RoleCode', title: '分配角色代码', width: 80, sortable: true },
                { field: 'RoleDesc', title: '分配角色', width: 80, sortable: true },
		        { field: 'OperationID', title: 'OperationID', width: 80, sortable: true, hidden:true },
		        { field: 'OperationCode', title: '操作类型代码', width: 80, sortable: true, hidden:true },
                { field: 'OperationDesc', title: '操作类型描述', width: 80, sortable: true },
                { field: 'EPRAction', title: '分配权限类型代码', width: 80, sortable: true, hidden:true },
		        { field: 'EPRActionDesc', title: '分配权限类型', width: 80, sortable: true },
                { field: 'AppointType', title: 'AppointType', width: 80, sortable: true, hidden:true },
                { field: 'AppointStatus', title: '授权状态代码', width: 80, sortable: true, hidden:true },
		        { field: 'AppointStatusDesc', title: '授权状态', width: 80, sortable: true, formatter: formatStatusDesc },
		        { field: 'AppointComment', title: '被拒绝或取消原因', width: 200, sortable: true },
                { field: 'HasAdvancedSecurity', title: 'HasAdvancedSecurity', width: 80, sortable: true, hidden:true }
	        ]],
            rowStyler:function(index,row){
                if (row.HasAdvancedSecurity == "Y")
                {
                    return 'background-color:pink;color:blue;font-weight:bold;';
                }
            },
            pagination: true,
            pageSize: 20,
            pageList: [10, 20, 50],
            pagePosition: 'bottom',
            toolbar: '#authorizationListTableTBar',
	        view: detailview,
	        detailFormatter:function(index,row){
                return '<div style="padding:2px"><table class="ddv" id="ddv-' + index + '"></table></div>';
            },
	        onClickRow:function(rowIndex, rowData){
		    //点击即展开
		    $('#authorizationListTable').datagrid('expandRow',rowIndex);
	     },
	     onExpandRow: function(index,row){
		    //展开即选中
		    $('#applyListTable').datagrid('selectRow', index);
		    FSAuthorization.ExpandAppointID = row.AuthorizationID;
				
		    $('#ddv-' + index).datagrid({
			    url:'../DHCEPRRBAC.web.eprajax.ApplyPermission.cls',
			    queryParams: {
				    Action: 'applylistdetail',
				    AuthorizationID: row.AuthorizationID
			    },
			    method: 'post',
			    loadMsg: '数据装载中......',
			    //fitColumns:true,
			    singleSelect:true,
			    rownumbers:true,
			    height:'auto',
			    columns:[[
				    { field: 'AuthorizationID', title:'AuthorizationID', width:80, sortable: false, hidden:true },
				    { field: 'AuthorizationDetailID', title:'AuthorizationDetailID', width:80, sortable: false, hidden:true },
				    { field: 'PAStatusType', title: '状态', width: 80, sortable: true },
				    { field: 'PAAdmType', title: '就诊类型', width: 80, sortable: true },
				    { field: 'PAPMIName', title: '病人姓名', width: 80, sortable: true },
				    { field: 'PAPMIDOB', title: '出生日期', width: 80, sortable: true },
				    { field: 'PAPMIAge', title: '年龄', width: 80, sortable: true },
			    	{ field: 'PAPMISex', title: '性别', width: 80, sortable: true },
				    { field: 'PAAdmDateTime', title: '入院时间', width: 80, sortable: true },
				    { field: 'PAAdmWard', title: '病区', width: 80, sortable: true },
				    { field: 'PAAdmRoom', title: '病房', width: 80, sortable: true },
			    	{ field: 'PAAdmBed', title: '病床', width: 80, sortable: true },
				    { field: 'PAAdmLoc', title: '科室', width: 80, sortable: true },
				    { field: 'PADischgeDateTime', title: '出院时间', width: 80, sortable: true },
				    { field: 'PAAdmDoc', title: '医生', width: 80, sortable: true },
				    { field: 'PayMode', title: '付费类型', width: 80, sortable: true },
				    { field: 'EpisodeID', title:'就诊号', width:80, sortable: false },
				    { field: 'PatientID', title:'病人号', width:80, sortable: false },
				    { field: 'MedRecordNo', title:'病案号', width:80, sortable: false },
				    { field: 'RegNo', title:'登记号', width:80, sortable: false },
                    { field: 'IsAdvancedSecurity', title: 'IsAdvancedSecurity', width: 80, sortable: true, hidden:true }
	            ]],
                rowStyler:function(index,row){
                    if (row.IsAdvancedSecurity == "1")
                    {
                        return 'background-color:pink;color:blue;font-weight:bold;';
                    }
                },
			    onResize:function(){
				    $('#authorizationListTable').datagrid('fixDetailRowHeight',index);
			    },
			    onLoadSuccess:function(){
				    setTimeout(function(){
					    $('#authorizationListTable').datagrid('fixDetailRowHeight',index);
				    },0);
			    }
		    });
		    $('#authorizationListTable').datagrid('fixDetailRowHeight',index);
	        }
        });		

	//列表类型
        $('#inputType').combogrid({
            idField: 'id',
            textField: 'text',
            data: [{
                id: '1',
                text: '未批准',
		code: 'N'
            }, {
                id: '2',
                text: '已批准',
                code: 'F'
            }, {
                id: '3',
                text: '已拒绝',
                code: 'R'
			}, {
                id: '4',
                text: '已过期',
                code: 'I'
	    }],
            panelWidth: 300,
            showHeader: false,
	    singleSelect: true,
            columns: [[
                { field: 'id', title: 'id', width: 80, hidden: true },
                { field: 'code', title: 'code', width: 80, hidden: true },
                { field: 'text', title: '列表类型', width: 250 }
            ]],
	    onSelect: function() {
                var rows = $('#inputType').combogrid('grid').datagrid('getSelections');
                var row = rows[0];
                FSAuthorization.typeCode = row["code"];
				
		//按钮显示隐藏
		if (row.code == "N"){
			$('#cancelBtn').hide();
			$('#assignRoleBtn').show();
			$('#rejectBtn').show();
		}
		else if (row.code == "F"){
			$('#cancelBtn').show();
		}
		else {
			$('#assignRoleBtn').hide();
			$('#rejectBtn').hide();
			$('#cancelBtn').hide();
		}
				
		//隐藏列，显示列
		if (FSAuthorization.typeCode == "N"){
			//未授权，隐藏授权人等信息
			$('#authorizationListTable').datagrid('hideColumn','AppointUserName');
			$('#authorizationListTable').datagrid('hideColumn','AppointDateTime');
			$('#authorizationListTable').datagrid('hideColumn','AppointEndDateTime');
			$('#authorizationListTable').datagrid('hideColumn','RoleCode');
			$('#authorizationListTable').datagrid('hideColumn','RoleDesc');
			$('#authorizationListTable').datagrid('hideColumn','OperationDesc');
			$('#authorizationListTable').datagrid('hideColumn','AppointComment');	
		}
		else if(FSAuthorization.typeCode == "F"){
			$('#authorizationListTable').datagrid('showColumn','AppointUserName');
			$('#authorizationListTable').datagrid('showColumn','AppointDateTime');
			$('#authorizationListTable').datagrid('showColumn','AppointEndDateTime');
			$('#authorizationListTable').datagrid('showColumn','RoleCode');
			$('#authorizationListTable').datagrid('showColumn','RoleDesc');
			$('#authorizationListTable').datagrid('showColumn','OperationDesc');	
			$('#authorizationListTable').datagrid('hideColumn','AppointComment');			
		}
		else {
			$('#authorizationListTable').datagrid('showColumn','AppointUserName');
			$('#authorizationListTable').datagrid('showColumn','AppointDateTime');
			$('#authorizationListTable').datagrid('showColumn','AppointEndDateTime');
			$('#authorizationListTable').datagrid('showColumn','RoleCode');
			$('#authorizationListTable').datagrid('showColumn','RoleDesc');
			$('#authorizationListTable').datagrid('showColumn','OperationDesc');		
			$('#authorizationListTable').datagrid('showColumn','AppointComment');						
		}
				
		refreshGrid();
            },
	    onLoadSuccess: function() {
                $('#inputType').combogrid('grid').datagrid('selectRow', 0);
            }
        });
		
	//授权时间
        $('#inputSpan').combogrid({
            idField: 'id',
            textField: 'text',
            data: [{
                id: '1',
                text: '12小时',
		code: '12'
            }, {
                id: '2',
                text: '24小时',
                code: '24'
            }, {
                id: '3',
                text: '48小时',
                code: '48'
	    }, {
                id: '4',
                text: '72小时',
                code: '72'
	    }, {
                id: '5',
                text: '4天',
                code: '96'
	    }, {
                id: '6',
                text: '5天',
                code: '120'
	    }, {
                id: '7',
                text: '8天',
                code: '192'
	    }, {
                id: '8',
                text: '10天',
                code: '240'
	    }, {
                id: '9',
                text: '15天',
                code: '360'
	    }],
            panelWidth: 300,
            showHeader: false,
	    singleSelect: true,
            columns: [[
                { field: 'id', title: 'id', width: 80, hidden: true },
                { field: 'code', title: 'code', width: 80, hidden: true },
                { field: 'text', title: '授权时间', width: 250 }
            ]],
	    onSelect: function() {
                var rows = $('#inputSpan').combogrid('grid').datagrid('getSelections');
                var row = rows[0];
                FSAuthorization.spanTime = row["code"];
		//refreshGrid();	
            },
	    onLoadSuccess: function() {
                //$('#inputSpan').combogrid('grid').datagrid('selectRow', 0);
            }
        });

	//时间过滤 - 起始日期
	$('#inputDateStart').datebox({    
	    onSelect: function() {
		FSAuthorization.dateStart = $('#inputDateStart').datebox('getValue');
		//refreshGrid();
            },
		onChange: function() {
			//避免不选择日期而采用输入的方式
			FSAuthorization.dateStart = $('#inputDateStart').datebox('getValue');
		}			
	}); 

	//时间过滤 - 截止日期
	$('#inputDateEnd').datebox({    
	    onSelect: function() {
		FSAuthorization.dateEnd = $('#inputDateEnd').datebox('getValue');
		//refreshGrid();
            },
		onChange: function() {
			//避免不选择日期而采用输入的方式
			FSAuthorization.dateEnd = $('#inputDateEnd').datebox('getValue');
		}			
	});

	var currDate = new Date(); 
 　 $("#inputDateStart").datebox("setValue",myformatter1(currDate,FSAuthorization.DATESPAN));  
 　 $("#inputDateEnd").datebox("setValue",myformatter(currDate));  
	FSAuthorization.dateStart = $("#inputDateStart").datebox("getValue");
	FSAuthorization.dateEnd = $("#inputDateEnd").datebox("getValue");



	//刷新申请列表
	function refreshGrid(){
	    var queryParams = $('#authorizationListTable').datagrid('options').queryParams;
            queryParams.Action = 'getlist';
            queryParams.UserID = appointUserID;
	    queryParams.ApplyStatus = FSAuthorization.typeCode;
	    queryParams.ApplyStartDate = FSAuthorization.dateStart;
	    queryParams.ApplyEndDate = FSAuthorization.dateEnd;

            $('#authorizationListTable').datagrid('options').queryParams = queryParams;
            $('#authorizationListTable').datagrid('reload');			
	} 	
		
	//查询
        $('#searchBtn').on('click', function() {
            //debugger;
            refreshGrid();
        });

        //清空查询条件
        $('#resetBtn').on('click', function() {
	    $('#inputType').combogrid('grid').datagrid('selectRow', 0);
	    $('#inputSpan').combogrid('grid').datagrid('selectRow', 0);
            $('#inputDateStart').datebox("setValue","");
            $('#inputDateEnd').datebox("setValue","");
	    FSAuthorization.dateStart = "";
	    FSAuthorization.dateEnd = "";
	    $('#inputSpan').combo("setValue","").combo("setText","");
	    FSAuthorization.spanTime = "";
        });	

	//分配角色
        $('#assignRoleBtn').on('click', function() {
	    var roleRows = $('#roleListTable').datagrid("getSelections");

	    var authorizationRows = $('#authorizationListTable').datagrid("getSelections");
			
	    if (roleRows.length <= 0){
		$.messager.alert('错误', '请先选择一个角色！', 'error');
	    }
	    else if (authorizationRows.length <= 0){
		$.messager.alert('错误', '请先选择一个授权！', 'error');
	    }
	    else {
		//角色为单选
		var roleID = roleRows[0].RoleID;
		var authorizationIDList = "";
		var spanTimeList = "";
		for (var i=0;i<authorizationRows.length;i++)
		{
			authorizationID = authorizationRows[i].AuthorizationID;	
			if (authorizationIDList == "")
			{
				authorizationIDList = authorizationID;
			}
			else
			{
				authorizationIDList = authorizationIDList + "^" + authorizationID;
			}

			if (FSAuthorization.spanTime == "")
			{
				spanTime = authorizationRows[i].RequestTimeSpan;	
			}
			else
			{
				spanTime = FSAuthorization.spanTime;
			}

			if (spanTimeList == "")
			{
				spanTimeList = spanTime;
			}
			else
			{
				spanTimeList = spanTimeList + "^" + spanTime;
			}
		}		

		var obj = $.ajax({
			url: "../DHCEPRRBAC.web.eprajax.ApplyPermission.cls?Action=adduserrole&RoleID=" + roleID + "&OpID=" + FSAuthorization.opID + "&AuthorizationIDList=" + authorizationIDList + "&UserID=" + appointUserID + "&SpanTimeList=" + spanTimeList, 
			type: 'post',
			async: false
		});

		var ret = obj.responseText;
		if (ret == "-1") {
			$.messager.alert('错误', '分配用户角色失败，请重新尝试！', 'error');
		}
		else if ((ret != "") && (ret != null) && (parseInt(ret) > 0)) {
			$.messager.alert('提示', '分配用户角色成功！', 'info');
			refreshGrid();
		}
	    }
        });
		
	$('#rejectDialog').dialog({    
	    title: '确定拒绝或取消',    
	    closed: true,    
	    cache: false,     
	    modal: true,
	    buttons:[{
		text:'保存',
		handler:function(){
			var reason = $('#inputReason').val();
					
			if (reason == ""){
				$.messager.alert('提示', text + '请填写拒绝或取消的原因', 'info');
			}
			else {
				var action = 'reject';
				var text = '拒绝';
				if (FSAuthorization.DialogType == "C"){
					var action = 'cancel';
					var text = '提前结束';		
				}
						
				var authorizationRows = $('#authorizationListTable').datagrid("getSelections");
						
				var authorizationIDList = "";
				for (var i=0;i<authorizationRows.length;i++)
				{
					authorizationID = authorizationRows[i].AuthorizationID;	
					if (authorizationIDList == "")
					{
						authorizationIDList = authorizationID;
					}
					else
					{
						authorizationIDList = authorizationIDList + "^" + authorizationID;
					}
				}
				var obj = $.ajax({
					url: "../DHCEPRRBAC.web.eprajax.ApplyPermission.cls?Action=" + action + "&Reason=" + encodeURI(reason) + "&AuthorizationIDList=" + authorizationIDList + "&UserID=" + appointUserID, 
					type: 'post',
					async: false
				});

				var ret = obj.responseText;
				if (ret == "-1") {
					$.messager.alert('错误', text + '授权失败，请重新尝试！', 'error');
				}
				else if ((ret != "") && (ret != null) && (parseInt(ret) > 0)) {
					$('#rejectDialog').dialog('close');
					$.messager.alert('提示', text + '授权成功！', 'info');
					refreshGrid();
				}
			}
		    }
	    },{
		text:'关闭',
		handler:function(){
			$('#rejectDialog').dialog('close');
		}
	    }]		
	});    	
		
	//拒绝
        $('#rejectBtn').on('click', function() {
			FSAuthorization.DialogType = "R";
			$('#rejectDialog').dialog('open');
        });
		
	//提前收回
        $('#cancelBtn').on('click', function() {
			FSAuthorization.DialogType = "C";
			$('#rejectDialog').dialog('open');
        });
		
	//隐私查询列表-------------------------------------------------------------------------------------------------------------------
	//选择操作类别
        $('#inputOperationType').combogrid({
            url: '../DHCEPRRBAC.web.eprajax.Operation.cls',
            queryParams: {
                Action: 'getop'
            },
            panelWidth: 300,
            idField: 'OperationID',
            textField: 'OpDesc',
            method: 'get',
            showHeader: false,
            //fitColumns: true,
            columns: [[
                { field: 'OperationID', title: 'OperationID', width: 80, hidden: true },
				{ field: 'OpName', title: 'OpName', width: 80, hidden: true },
				{ field: 'OpCode', title: 'OpCode', width: 80, hidden: true },
                { field: 'OpDesc', title: 'OpDesc', width: 250 }
            ]],
            onSelect: function() {
                FSAuthorization.opID = "";
                var rows = $('#inputOperationType').combogrid('grid').datagrid('getSelections');
                var row = rows[0];
                FSAuthorization.opID = row["OperationID"];
				FSAuthorization.opCode = row["OpCode"];
				FSAuthorization.opDesc = row["OpDesc"];
            },
			onLoadSuccess: function() {
                $('#inputOperationType').combogrid('grid').datagrid('selectRow', 0);
            }
        });
		
		//选择隐私类别
        $('#inputPrivacyLevel').combogrid({
            url: '../DHCEPRRBAC.web.eprajax.PrivateDomain.cls',
            queryParams: {
                Action: 'getprivatelevel'
            },
            panelWidth: 300,
            idField: 'PrivateDomainID',
            textField: 'PDDDesc',
            method: 'get',
            showHeader: false,
            //fitColumns: true,
            columns: [[
                { field: 'PrivateDomainID', title: 'PrivateDomainID', width: 80, hidden: true },
		{ field: 'PDDName', title: 'PDDName', width: 80, hidden: true },
		{ field: 'PDDCode', title: 'PDDCode', width: 80, hidden: true },
		{ field: 'PDDLevel', title: 'PDDLevel', width: 80, hidden: true },
                { field: 'PDDDesc', title: 'PDDDesc', width: 250 }
            ]],
            onSelect: function() {
                FSAuthorization.pddID = "";
		FSAuthorization.pddCode = "";
		FSAuthorization.pddDesc= "";
		FSAuthorization.pddLevel= "";
                var rows = $('#inputPrivacyLevel').combogrid('grid').datagrid('getSelections');
                var row = rows[0];
                FSAuthorization.pddID = row["PrivateDomainID"];
		FSAuthorization.pddCode = row["PDDCode"];
		FSAuthorization.pddDesc = row["PDDDesc"];
		FSAuthorization.pddLevel = row["PDDLevel"];
				
		var queryParams = $('#itemListTable').datagrid('options').queryParams;
		queryParams.PrivateDomainID = FSAuthorization.pddID;
		$('#itemListTable').datagrid('options').queryParams = queryParams;
		$('#itemListTable').datagrid('reload');
            },
	    onLoadSuccess: function() {
                $('#inputPrivacyLevel').combogrid('grid').datagrid('selectRow', 0);
            }
        });
		
		//隐私域下项目
		var itemListDG = $('#itemListTable').datagrid({
            url: '../DHCEPRRBAC.web.eprajax.PrivateDomain.cls',
            queryParams: {
                Action: 'getitem',
				PrivateDomainID: FSAuthorization.pddID
            },
            method: 'post',
            loadMsg: '数据装载中......',
            singleSelect: false,
            showHeader: true,
			rownumbers:true,
            //fitColumns: true,
            columns: [[
				{ field: 'ck', checkbox: true},
                { field: 'PrivateDomainID', title: 'PrivateDomainID', width: 80, sortable: true, hidden:true },
				{ field: 'PrivateDomainDesc', title: '隐私域', width: 80, sortable: true, formatter: formatPrivateDomainDesc },
				{ field: 'PrivateDomainLevel', title: '隐私域级别', width: 80, sortable: true, hidden:true },
				{ field: 'ResourceItemID', title: 'ResourceItemID', width: 80, sortable: true, hidden:true },
				{ field: 'ItemID', title: 'ItemID', width: 80, sortable: true, hidden:true },
                { field: 'ItemName', title: '项目名称', width: 80, sortable: true },
                { field: 'ItemCode', title: '项目代码', width: 80, sortable: true, hidden:true },
                { field: 'ItemDesc', title: '项目描述', width: 80, sortable: true },
				{ field: 'ItemType', title: '项目类别代码', width: 80, sortable: true, hidden:true },
				{ field: 'ItemTypeDesc', title: '项目类别', width: 80, sortable: true }
            ]],
			pagination: true,
            pageSize: 50,
            pageList: [20, 30, 50, 100, 200],
            pagePosition: 'bottom',
            toolbar: '#itemListTableTBar'
        });

		//角色下的项目
		var roleItemTableDG = $('#roleItemTable').datagrid({
            url: '../DHCEPRRBAC.web.eprajax.Role.cls',
            queryParams: {
                Action: 'getroleitem',
				RoleID: FSAuthorization.roleID
            },
            method: 'post',
            loadMsg: '数据装载中......',
            singleSelect: false,
            showHeader: true,
            //fitColumns: true,
			rownumbers:true,
            columns: [[
				{ field: 'ck', checkbox: true },
				{ field: 'OperationID', title: 'OperationID', width: 80, sortable: true, hidden:true },
				{ field: 'OperationCode', title: '操作代码', width: 80, sortable: true, hidden:true },
				{ field: 'OperationDesc', title: '操作描述', width: 80, sortable: true },
                { field: 'PrivateDomainID', title: 'PrivateDomainID', width: 80, sortable: true, hidden:true },
				{ field: 'PrivateDomainDesc', title: '隐私域', width: 80, sortable: true, formatter: formatPrivateDomainDesc },
				{ field: 'ResourceItemID', title: 'ResourceItemID', width: 80, sortable: true, hidden:true },
				{ field: 'ItemID', title: 'ItemID', width: 80, sortable: true, hidden:true },
                { field: 'ItemName', title: '项目名称', width: 80, sortable: true },
                { field: 'ItemCode', title: '项目代码', width: 80, sortable: true, hidden:true },
                { field: 'ItemDesc', title: '项目描述', width: 80, sortable: true },
				{ field: 'ItemType', title: '项目类别代码', width: 80, sortable: true, hidden:true },
				{ field: 'ItemTypeDesc', title: '项目类别', width: 80, sortable: true }
            ]],
			loadFilter: pagerFilter,
			pagination: true,
            pageSize: 50,
            pageList: [10, 20, 30, 50, 100],
            pagePosition: 'bottom',
            toolbar: '#roleItemTableTBar',
			onLoadSuccess:function(data) {
				FSAuthorization.RoleItems = $('#roleItemTable').datagrid('getData').originalRows;
			}
        });

		function pagerFilter(data)  
		{
			if ($.isArray(data)){
				data = {
					total: data.length,
					rows: data
				}
			}
			if(!data.originalRows){
				data.originalRows =(data.rows);
			}
			var opts = $('#roleItemTable').datagrid('options');
			var pager = $('#roleItemTable').datagrid('getPager');
			pager.pagination({
				onSelectPage:function(pageNum, pageSize){
					opts.pageNumber = pageNum;
					opts.pageSize = pageSize;
					pager.pagination('refresh',{
						pageNumber:pageNum,
						pageSize:pageSize
					});
					$('#roleItemTable').datagrid('loadData',data);
				}
			});
			var start =(opts.pageNumber-1)*parseInt(opts.pageSize);
			var end = start + parseInt(opts.pageSize);
			data.rows =(data.originalRows.slice(start, end));
			return data;
		}		

		//将选中项目增加到角色项目中
		$('#itemAddBtn').on('click', function() {
			var rows = $('#itemListTable').datagrid('getSelections');
			for (var i=0;i<rows.length;i++)
			{
				//检查是否已存在
				var flag = false;
				for (var j=0;j<FSAuthorization.RoleItems.length;j++)
				{
					if ((FSAuthorization.RoleItems[j].OperationID == FSAuthorization.opID) && (FSAuthorization.RoleItems[j].PrivateDomainID == rows[i].PrivateDomainID) && (FSAuthorization.RoleItems[j].ItemID == rows[i].ItemID))
					{
						flag = true;
						break;
					}
				}
				if (!flag){
					var row = rows[i];
					row.OperationID = FSAuthorization.opID;
					row.OperationCode = FSAuthorization.opCode;
					row.OperationDesc = FSAuthorization.opDesc;
					row.PrivateDomainID = FSAuthorization.pddID;
					row.PrivateDomainDesc = FSAuthorization.pddDesc;
					FSAuthorization.RoleItems.push(row);
				}
			}
			$('#roleItemTable').datagrid('loadData', FSAuthorization.RoleItems);
		});
		
		function getItemIndex(item, array) {
			if (array.length == 0) {
				return "-1";
			}
			for (var i = 0;i<array.length;i++) {
				if (item == array[i]) {
					return i;
				}
			}
			return "-1";
		}
		
		//将选中项目从角色项目中移除
		$('#itemDeleteBtn').on('click', function() {
			var rows = $('#roleItemTable').datagrid('getSelections');
			if (rows.length == 0) {
				return;
			}
			for (var i=0;i<rows.length;i++) {
				var index = getItemIndex(rows[i], FSAuthorization.RoleItems)
				if (index != "-1") {
					FSAuthorization.RoleItems.splice(index,1);
				}
			}
			$('#roleItemTable').datagrid('loadData', FSAuthorization.RoleItems);
		});
		
		//调整角色项目的顺序
		function move(isUp) {
			var selections = $('#roleItemTable').datagrid("getSelections");
			if(selections.length == 0){
				return;
			}

			var length = FSAuthorization.RoleItems.length;
			var currentNum = $('#roleItemTable').datagrid('options').pageNumber;
			var currentSize = $('#roleItemTable').datagrid('options').pageSize;
			var selectIndex = new Array();
			for(var i = 0; i < selections.length; i++){
				var index, $i, newIndex, currentRowIdx, newRowIdx;
				if(isUp){
					$i = i;
					index = $('#roleItemTable').datagrid('getRowIndex',selections[$i]);
					currentRowIdx = (currentNum - 1) * currentSize + index;
					if(currentRowIdx <= 0)return;
					newRowIdx = currentRowIdx - 1;
				}else{
						var $i = selections.length-1-i;
						index = $('#roleItemTable').datagrid('getRowIndex',selections[$i]);
						currentRowIdx = (currentNum - 1) * currentSize + index;
						if(currentRowIdx >= length-1)return;
						newRowIdx = currentRowIdx + 1;
				}
				FSAuthorization.RoleItems.splice(currentRowIdx,1);
				FSAuthorization.RoleItems.splice(newRowIdx,0,selections[$i]);
				newIndex = newRowIdx - (currentNum - 1) * currentSize;
				if (newIndex >=0)
				{
					selectIndex.push(newIndex);
				}
			}
			$('#roleItemTable').datagrid('loadData', FSAuthorization.RoleItems);
			for(var i = 0; i < selectIndex.length; i++){
				$('#roleItemTable').datagrid("selectRow",selectIndex[i]);
			}
		}
		
		//向下移动选中的角色项目
		$('#itemDownBtn').on('click', function() {
			move(false);
		});
		
		//向上移动选中的角色项目
		$('#itemUpBtn').on('click', function() {
			move(true);
		});
		
		//保存角色项目
		$('#itemSaveBtn').on('click', function() {
			var roleRows = $('#roleItemTable').datagrid("getData").originalRows;
			//角色为单选
			var privateDomainIDList = "";
			var resourceItemIDList = "";
			for (var i=0;i<roleRows.length;i++)
			{
				privateDomainID = roleRows[i].PrivateDomainID;	
				resourceItemID = roleRows[i].ResourceItemID;	
				if (privateDomainIDList == "")
				{
					privateDomainIDList = privateDomainID;
					resourceItemIDList = resourceItemID;
				}
				else
				{
					privateDomainIDList = privateDomainIDList + "^" + privateDomainID;
					resourceItemIDList = resourceItemIDList + "^" + resourceItemID;
				}
			}

			var obj = $.ajax({
				url: "../DHCEPRRBAC.web.eprajax.Role.cls", 
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
			if (ret == "-1") {
				$.messager.alert('错误', '保存角色权限失败，请重新尝试！', 'error');
			}
			else if ((ret != "") && (ret != null) && (parseInt(ret) > 0)) {
				$.messager.alert('提示', '保存角色权限成功！', 'info');
				
				refreshGrid();
				
				$('#roleItemDisplayTable').datagrid('loadData',{total:0,rows:[]});
				var url = '../DHCEPRRBAC.web.eprajax.Role.cls';
				$('#roleItemDisplayTable').datagrid('options').url = url;
				var queryParams = $('#roleItemDisplayTable').datagrid('options').queryParams;
				queryParams.Action = 'getroleitempage';
				queryParams.RoleID = FSAuthorization.roleID;
				$('#roleItemDisplayTable').datagrid('options').queryParams = queryParams;
				$('#roleItemDisplayTable').datagrid('reload');	
				
				$('#addWin').window('close');
			}			
		});
		
	//选中角色时显示角色的项目表格
	var roleItemDisplayTableDG = $('#roleItemDisplayTable').datagrid({
            	//url: '../DHCEPRRBAC.web.eprajax.Role.cls',
            	queryParams: {
                	Action: 'getroleitempage',
			RoleID: FSAuthorization.roleID
            	},
            	method: 'post',
            	loadMsg: '数据装载中......',
            	singleSelect: false,
            	showHeader: true,
            	//fitColumns: true,
		rownumbers:true,
            	columns: [[
			{ field: 'OperationID', title: 'OperationID', width: 80, sortable: true, hidden:true },
			{ field: 'OperationCode', title: '操作代码', width: 80, sortable: true, hidden:true },
			{ field: 'OperationDesc', title: '操作描述', width: 80, sortable: true },
                	{ field: 'PrivateDomainID', title: 'PrivateDomainID', width: 80, sortable: true, hidden:true },
			{ field: 'PrivateDomainDesc', title: '隐私域', width: 80, sortable: true, formatter: formatPrivateDomainDesc },
			{ field: 'PrivateDomainLevel', title: '隐私域级别', width: 80, sortable: true, hidden:true },
			{ field: 'ItemID', title: 'ItemID', width: 80, sortable: true, hidden:true },
               	 	{ field: 'ItemName', title: '项目名称', width: 80, sortable: true },
                	{ field: 'ItemCode', title: '项目代码', width: 80, sortable: true, hidden:true },
                	{ field: 'ItemDesc', title: '项目描述', width: 80, sortable: true },
			{ field: 'ItemType', title: '项目类别代码', width: 80, sortable: true, hidden:true },
			{ field: 'ItemTypeDesc', title: '项目类别', width: 80, sortable: true }
            	]],
	        pagination: true,
	        pageSize: 20,
	        pageList: [10, 20, 50],
	        pagePosition: 'bottom'
        });	
        
        //默认角色---------------------------------------------------------------------------------------------------
       	//设定默认角色
       	$('#defaultRoleBtn').on('click', function() {
			var rows = $('#roleListTable').datagrid("getSelections");
			var roleID = rows[0].RoleID
			
			if (rows.length != 1){
				$.messager.alert('错误', '请先选择一个角色！', 'error');
			}
				
			var obj = $.ajax({
				url: "../DHCEPRRBAC.web.eprajax.Role.cls?Action=defaultrole&RoleID=" + roleID,
				type: 'post',
				async: false
			});

			var ret = obj.responseText;
			if (ret == "-1") {
				$.messager.alert('错误', '设定默认角色失败，请重新尝试！', 'error');
			}
			else if ((ret != "") && (ret != null) && (parseInt(ret) > 0)) {
				$.messager.alert('提示', '设定默认角色成功！', 'info');
				$('#roleListTable').datagrid('reload');
			}
        });
       	
        $('#defaultRoleSSGroupBtn').on('click', function() {
			refleshSSGroup();	
			$('#addDefaultRoleDialog').dialog('open');
        });
        
        $('#inputAddDefaultRoleFilter').searchbox({
        	searcher:function(value,name){
    			var url = '../DHCEPRRBAC.web.eprajax.DicList.cls';
				$('#addDefaultRoleTable').datagrid('options').url = url;
				var queryParams = $('#addDefaultRoleTable').datagrid('options').queryParams;
				queryParams.Action = 'ssgroup';
				queryParams.Filter = value;
	
				$('#addDefaultRoleTable').datagrid('options').queryParams = queryParams;
				$('#addDefaultRoleTable').datagrid('reload');     			
        	}	
        });
        
        function refleshSSGroup(){
        	var filter = $('#inputAddDefaultRole').val();
        	
 			var url = '../DHCEPRRBAC.web.eprajax.DicList.cls';
			$('#addDefaultRoleTable').datagrid('options').url = url;
			var queryParams = $('#addDefaultRoleTable').datagrid('options').queryParams;
			queryParams.Action = 'ssgroup';
			queryParams.Filter = filter;

			$('#addDefaultRoleTable').datagrid('options').queryParams = queryParams;
			$('#addDefaultRoleTable').datagrid('reload');		       	
        }
        
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
            showHeader: true,
            //fitColumns: false,
			rownumbers:false,
            columns: [[
			    { field: 'ID', title: '安全组ID', width: 80, sortable: true },
				{ field: 'DicDesc', title: '安全组名称', width: 120, sortable: true }
            ]],
            toolbar: '#addDefaultRoleTable',
           	pagination: true,
	  		pageSize: 20,
			pageList: [10, 20, 50],
	 		pagePosition: 'bottom'
        });	
        
        $('#addDefaultRoleDialog').dialog({    
			title: '安全组查询',    
			closed: true,    
			cache: false,     
			modal: true,
			buttons:[{
				text:'添加选中',
				handler:function(){
					var rows = $('#addDefaultRoleTable').datagrid('getSelections'); 
					var rowsRole = $('#roleListTable').datagrid("getSelections");
					var roleID = rows[0].RoleID
			
					if (rowsRole.length != 1){
						$.messager.alert('错误', '请先选择一个角色！', 'error');
						return;
					}
					
					if (rows.length <= 0){
						$.messager.alert('错误', '请先选择一个安全组！', 'error');
						return;
					}
					
					var ssgroupIDS = ""
					for (var i=0;i<rows.length;i++){
						if (ssgroupIDS == ""){
							ssgroupIDS = rows[i].ID;
						}
						else{
							ssgroupIDS = ssgroupIDS + '^' + rows[i].ID;
						}
					}

					var obj = $.ajax({
						url: "../DHCEPRRBAC.web.eprajax.Role.cls?Action=defaultrolessgroup&RoleID=" + rowsRole[0].RoleID + "&SSGroupIDS=" + ssgroupIDS,
						type: 'post',
						async: false
					});
		
					var ret = obj.responseText;
		
					if (ret == "-1") {
						$.messager.alert('错误', '设定默认角色失败，请重新尝试！', 'error');
					}
					else if ((ret != "") && (ret != null) && (parseInt(ret) > 0)) {
						$.messager.alert('提示', '设定默认角色成功！', 'info');
						$('#roleListTable').datagrid('reload');
						$('#addDefaultRoleDialog').dialog('close');
					}
				}
			},{
				text:'关闭',
				handler:function(){
					$('#addDefaultRoleDialog').dialog('close');
				}
			}]		
		});  
		
		//formatter--------------------------------------------------------------------------------
		function formatStatusDesc(value,row,index){
			var status = row.AppointStatus;
			if (status == "N"){
				return '<font color="#AAAAFF">' + value + '</font>';
			}
			else if (status == "F"){
				return '<font color="#00A600">' + value + '</font>';
			}
			else if (status == "R"){
				return '<font color="#FF9797">' + value + '</font>';
			}
            else if (status == "D"){
				return '<font color="#7B7B7B">' + value + '</font>';
			}
			else if (status == "I"){
				return '<font color="#7B7B7B">' + value + '</font>';
			}
		}
		
		function formatPrivateDomainDesc(value,row,index){
			var privacyDomainLevel = row.PrivateDomainLevel;
			if (privacyDomainLevel == "0"){
				return '<font color="#00A600">' + value + '</font>';
			}
			else if (privacyDomainLevel == "1"){
				return '<font color="#FF9797">' + value + '</font>';
			}
		}

        function myformatter(date){  
			var y = date.getFullYear();  
			var m = date.getMonth()+1;  
			var d = date.getDate();  
			return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);  
		} 
		
		function myformatter1(date, span){  
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
