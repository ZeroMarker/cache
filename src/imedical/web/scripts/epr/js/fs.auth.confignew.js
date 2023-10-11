var FSAuthConfig = new Object();

FSAuthConfig.opID = '';
FSAuthConfig.opCode = '';
FSAuthConfig.opDesc = '';
FSAuthConfig.pddID = '';
FSAuthConfig.pddDesc = '';

FSAuthConfig.roleID = '';
FSAuthConfig.RoleItems = '';
FSAuthConfig.ExpandRoleIndex = '';
FSAuthConfig.ExpandSSGroupID = '';

(function($) {
	$(function() {
		//--------------------角色列表--------------------
		//角色列表
		$HUI.datagrid('#roleListTable',{
			title: '角色列表',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			fit: true,
			toolbar: '#roleListTableTBar',
			url: '../DHCEPRRBAC.web.eprajax.Role.cls',
			queryParams: {
				Action: 'rolelist'
			},
			singleSelect: true,
			pagination: true,
			pageSize: 20,
			pageList: [10, 20, 50],
			columns: [[
				{field:'RoleID',title:'角色ID',width:80,hidden:true},
				{field:'RoleName',title:'角色名称',width:120},
				{field:'RoleCode',title:'角色代码',width:100},
				{field:'RoleDesc',title:'角色描述',width:200},
				{field:'DefaultRole',title:'默认角色',width:80}
			]],
			onSelect: function(rowIndex,rowData) {
				FSAuthConfig.roleID = rowData.RoleID;
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
				if ((FSAuthConfig.ExpandRoleIndex !== '')&&(parseInt(FSAuthConfig.ExpandRoleIndex) != index)) {  //折叠其他行已展开的子表
					var rowExpander = $('#roleListTable').datagrid('getExpander',FSAuthConfig.ExpandRoleIndex);
					if (rowExpander) {
						$('#roleListTable').datagrid('collapseRow',FSAuthConfig.ExpandRoleIndex);
					}
				}
				FSAuthConfig.ExpandRoleIndex = index;
				FSAuthConfig.ExpandSSGroupID = '';
				$('#roleListTable').datagrid('selectRow',index);  //展开即选中
				$HUI.datagrid('#ddvrole-' + index,{
					width: 'auto',
					height: 'auto',
					url:'../DHCEPRRBAC.web.eprajax.Role.cls',
					queryParams: {
						Action: 'rolelistdetail',
						RoleID: row.RoleID
					},
					rownumbers: true,
					singleSelect: true,
					columns: [[
						{field:'SSGroupID',title:'安全组ID',width:90},
						{field:'SSGroupName',title:'安全组名称',width:300}
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
						FSAuthConfig.ExpandSSGroupID = row.SSGroupID;
					}
				});
				$('#roleListTable').datagrid('fixDetailRowHeight',index);
			}
		});
		
		//角色权限内容列表
		$HUI.datagrid('#roleItemDisplayTable',{
			title: '角色权限内容',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			fit: true,
			//url: '../DHCEPRRBAC.web.eprajax.Role.cls',
			queryParams: {
				Action: 'getroleitempage',
				RoleID: FSAuthConfig.roleID
			},
			rownumbers: true,
			singleSelect: false,
			pagination: true,
			pageSize: 20,
			pageList: [10, 20, 50],
			columns: [[
				{field:'OperationDesc',title:'操作描述',width:80},
				{field:'PrivateDomainDesc',title:'隐私域',width:100,formatter:formatPrivateDomainDesc},
				{field:'PrivateDomainLevel',title:'隐私域级别',width:80,hidden:true},
				{field:'ItemID',title:'ItemID', width: 80, hidden:true},
				{field:'ItemName',title:'项目名称',width:80,hidden:true},
				{field:'ItemCode',title:'项目代码',width:80,hidden:true},
				{field:'ItemDesc',title:'项目描述',width:160},
				{field:'ItemTypeDesc',title:'项目类别',width:80}
			]]
		});
		
		//新增角色
		$('#roleAddBtn').on('click', function() {
			var roleName = $('#inputRoleName').val();
			var roleCode = $('#inputRoleCode').val();
			var roleDesc = $('#inputRoleDesc').val();
			if ((roleCode == '') || (roleCode == null)) {
				$.messager.popover({msg:'角色代码不能为空！',type:'info',timeout:1000});
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
					$.messager.popover({msg:'角色代码不能为空！',type:'info',timeout:1000});
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
				$.messager.popover({msg:'请先选择一个角色！',type:'alert',timeout:1000});
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
				$.messager.popover({msg:'请先选择一个角色！',type:'alert',timeout:1000});
				return;
			}
		});
		
		//角色权限内容维护弹窗
		$('#addWin').dialog({
			title: '角色权限内容维护',
			iconCls: 'icon-w-edit',
			closed: true,
			modal: true,
			onOpen: function() {
				var queryParams = $('#roleItemTable').datagrid('options').queryParams;
				queryParams.Action = 'getroleitem';
				queryParams.RoleID = FSAuthConfig.roleID;
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
				FSAuthConfig.roleID = row.RoleID;
				$('#addWin').window('open');
			}
			else {
				$.messager.popover({msg:'请先选择一个角色！',type:'alert',timeout:1000});
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
				FSAuthConfig.opID = rec['OperationID'];
				FSAuthConfig.opCode = rec['OpCode'];
				FSAuthConfig.opDesc = rec['OpDesc'];
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
				FSAuthConfig.pddID = rec['PrivateDomainID'];
				FSAuthConfig.pddDesc = rec['PDDDesc'];
				var queryParams = $('#itemListTable').datagrid('options').queryParams;
				queryParams.PrivateDomainID = FSAuthConfig.pddID;
				$('#itemListTable').datagrid('options').queryParams = queryParams;
				$('#itemListTable').datagrid('reload');
			}
		});
		
		//隐私域项目
		$HUI.datagrid('#itemListTable',{
			title: '隐私域项目',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			fit: true,
			toolbar: '#itemListTableTBar',
			url: '../DHCEPRRBAC.web.eprajax.PrivateDomain.cls',
			queryParams: {
				Action: 'getitem',
				PrivateDomainID: FSAuthConfig.pddID
			},
			rownumbers:true,
			singleSelect: false,
			pagination: true,
			pageSize: 50,
			pageList: [20, 30, 50, 100, 200],
			columns: [[
				{field:'ck',checkbox:true},
				{field:'PrivateDomainID',title:'PrivateDomainID',width:80,hidden:true},
				{field:'PrivateDomainDesc',title:'隐私域',width:100,formatter:formatPrivateDomainDesc},
				{field:'PrivateDomainLevel',title:'隐私域级别',width:80,hidden:true},
				{field:'ResourceItemID',title:'ResourceItemID',width:80,hidden:true},
				{field:'ItemID',title:'ItemID',width:80,hidden:true},
				{field:'ItemName',title:'项目名称',width: 80, hidden:true},
				{field:'ItemCode',title:'项目代码',width:80,hidden:true},
				{field:'ItemDesc',title:'项目描述',width:200},
				{field:'ItemType',title:'项目类别代码',width:80,hidden:true},
				{field:'ItemTypeDesc',title:'项目类别',width:80}
			]]
		});
		
		//角色权限项目
		$HUI.datagrid('#roleItemTable',{
			title: '角色权限项目',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			fit: true,
			toolbar: '#roleItemTableTBar',
			url: '../DHCEPRRBAC.web.eprajax.Role.cls',
			queryParams: {
				Action: 'getroleitem',
				RoleID: FSAuthConfig.roleID
			},
			rownumbers: true,
			singleSelect: false,
			pagination: true,
			pageSize: 50,
			pageList: [10, 20, 30, 50, 100],
			columns: [[
				{field:'ck',checkbox:true},
				{field:'OperationID',title:'OperationID',width:80,hidden:true},
				{field:'OperationCode',title:'操作代码',width:80,hidden:true},
				{field:'OperationDesc',title:'操作描述',width:80},
				{field:'PrivateDomainID',title:'PrivateDomainID',width:80,hidden:true},
				{field:'PrivateDomainDesc',title:'隐私域',width:100,formatter:formatPrivateDomainDesc},
				{field:'ResourceItemID',title:'ResourceItemID',width:80,hidden:true},
				{field:'ItemID',title:'ItemID',width:80,hidden:true},
				{field:'ItemName',title:'项目名称',width:80,hidden:true},
				{field:'ItemCode',title:'项目代码',width:80,hidden:true},
				{field:'ItemDesc',title:'项目描述',width:200},
				{field:'ItemType',title:'项目类别代码',width:80,hidden:true},
				{field:'ItemTypeDesc',title:'项目类别',width:80}
			]],
			loadFilter: pagerFilter,
			onLoadSuccess: function(data) {
				FSAuthConfig.RoleItems = $('#roleItemTable').datagrid('getData').originalRows;
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
				for (var j=0;j<FSAuthConfig.RoleItems.length;j++) {
					if ((FSAuthConfig.RoleItems[j].OperationID == FSAuthConfig.opID) && (FSAuthConfig.RoleItems[j].PrivateDomainID == rows[i].PrivateDomainID) && (FSAuthConfig.RoleItems[j].ItemID == rows[i].ItemID))
					{
						flag = true;
						break;
					}
				}
				if (!flag) {
					var row = rows[i];
					row.OperationID = FSAuthConfig.opID;
					row.OperationCode = FSAuthConfig.opCode;
					row.OperationDesc = FSAuthConfig.opDesc;
					row.PrivateDomainID = FSAuthConfig.pddID;
					row.PrivateDomainDesc = FSAuthConfig.pddDesc;
					FSAuthConfig.RoleItems.push(row);
				}
			}
			$('#roleItemTable').datagrid('loadData',FSAuthConfig.RoleItems);
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
				var index = getItemIndex(rows[i],FSAuthConfig.RoleItems);
				if (index != '-1') {
					FSAuthConfig.RoleItems.splice(index,1);
				}
			}
			$('#roleItemTable').datagrid('loadData',FSAuthConfig.RoleItems);
		});
		
		//调整角色权限项目顺序
		function move(isUp) {
			var selections = $('#roleItemTable').datagrid('getSelections');
			if (selections.length == 0) {
				return;
			}
			
			var length = FSAuthConfig.RoleItems.length;
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
				FSAuthConfig.RoleItems.splice(currentRowIdx,1);
				FSAuthConfig.RoleItems.splice(newRowIdx,0,selections[$i]);
				newIndex = newRowIdx - (currentNum - 1) * currentSize;
				if (newIndex >=0) {
					selectIndex.push(newIndex);
				}
			}
			$('#roleItemTable').datagrid('loadData', FSAuthConfig.RoleItems);
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
					RoleID: FSAuthConfig.roleID,
					OpID: FSAuthConfig.opID,
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
			queryParams.RoleID = FSAuthConfig.roleID;
			$('#roleItemDisplayTable').datagrid('options').queryParams = queryParams;
			//$('#roleItemDisplayTable').datagrid('reload');
			$('#roleItemDisplayTable').datagrid('getPager').pagination('select',1);
		}
		
		//安全组查询弹窗
		$('#addDefaultRoleDialog').dialog({
			title: '设定安全组默认角色',
			iconCls: 'icon-w-add',
			closed: true,
			cache: false,
			modal: true,
			buttons: [{
				text: '添加选中',
				handler: function() {
					var rows = $('#addDefaultRoleTable').datagrid('getSelections');
					if (rows.length <= 0) {
						$.messager.popover({msg:'请先选择一个安全组！',type:'info',timeout:1000});
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
							RoleID: FSAuthConfig.roleID,
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
				FSAuthConfig.roleID = row.RoleID;
				$('#addDefaultRoleDialog').dialog('open');
			}
			else {
				$.messager.popover({msg:'请先选择一个角色！',type:'alert',timeout:1000});
				return;
			}
		});
		
		//安全组列表
		$HUI.datagrid('#addDefaultRoleTable',{
			title: '安全组列表',
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			fit: true,
			toolbar: '#addDefaultRoleTBar',
			//url: '../DHCEPRRBAC.web.eprajax.DicList.cls',
			queryParams: {
				Action: 'ssgroup',
				Filter: ''
			},
			rownumbers: false,
			singleSelect: false,
			pagination: true,
			pageSize: 20,
			pageList: [10, 20, 50],
			columns: [[
				{field:'ID',title:'安全组ID',width:100},
				{field:'DicDesc',title:'安全组名称',width:240}
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
				FSAuthConfig.roleID = row.RoleID;
				if (FSAuthConfig.ExpandSSGroupID != '') {
					var obj = $.ajax({
						url: '../DHCEPRRBAC.web.eprajax.Role.cls',
						data: {
							Action: 'deletessgrouprole',
							RoleID: FSAuthConfig.roleID,
							SSGroupID: FSAuthConfig.ExpandSSGroupID
						},
						type: 'post',
						async: false
					});
					var ret = obj.responseText;
					if (parseInt(ret) > 0) {
						$.messager.alert('提示','删除安全组默认角色成功！','info',function() {
							FSAuthConfig.ExpandSSGroupID = ''
							$('#roleListTable').datagrid('reload');
						});
					}
					else {
						$.messager.alert('错误','删除安全组默认角色失败，请重新尝试！','error');
						return;
					}
				}
				else {
					$.messager.popover({msg:'请先选择一个安全组！',type:'info',timeout:1000});
					return;
				}
			}
			else {
				$.messager.popover({msg:'请先选择一个角色！',type:'alert',timeout:1000});
				return;
			}
		});
		
		//--------------------formatter--------------------
		function formatPrivateDomainDesc(value,row,index) {
			var privacyDomainLevel = row.PrivateDomainLevel;
			if (privacyDomainLevel == '0') {
				return '<font color="#00A600">' + value + '</font>';
			}
			else if (privacyDomainLevel == '1') {
				return '<font color="#FF9797">' + value + '</font>';
			}
		}
		
	});
})(jQuery);
