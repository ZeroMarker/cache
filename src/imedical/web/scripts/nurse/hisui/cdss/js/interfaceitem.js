/**
 * @Author      yaojining
 * @DateTime    2021-04-15
 * @description CDSS接口项目
 */
$(function() { 
	/**
	 * @description 初始化界面
	 */
	function initPage(){
		initGrid();
		listenEvents();
	}
	/**
	 * @description 初始化表格
	 */
	function initGrid() {
		var setFrozenColumns = [[
        	{field:'Name',title:'接口名称',width:250}
    	]];
    	var setColumns = [[
    		{field:'InterType',title:'接口类型',width:150},
			{field:'TypeCode',title:'接口类型代码',width:150,hidden:true},
        	{field:'ClsName',title:'类名称',width:350},
        	{field:'MetName',title:'方法名称',width:200},
        	{field:'MsgCode',title:'消息代码',width:280},
        	{field:'IsOldVersion', title:'是否旧版', width:80, formatter:function(value, row, index){
	        	return value == "Y" ? "是" : "否"	
	        }},
        	{field:'IsStop', title:'是否停用', width:80, formatter:function(value, row, index){
	        	return value == "Y" ? "是" : "否"	
	        }},
    	]];
		$('#interfaceItemGrid').datagrid({
			url: $URL,
	        queryParams: {
	            ClassName: 'Nur.CDSS.Service.InterfaceConfig',
	            QueryName: 'FindInterItems',
	            HospitalID: session['LOGON.HOSPID'],
	        },
			fit : true,
			frozenColumns:setFrozenColumns,
			columns: setColumns,
			toolbar:"#toolbar",
			pagination : true,  //是否分页
			rownumbers : true,
			pageSize: 15,
			pageList : [15,30,50],
			singleSelect : true,
			loadMsg : '加载中..', 
			onClickRow: function(rowIndex, rowData){
				$('#interfaceDataGrid').datagrid('reload',{
					ClassName: 'Nur.CDSS.Service.InterfaceConfig',
					QueryName: 'FindInterData',
					ParRef: rowData.Rowid,
				});
       		},		
			onDblClickRow: function(rowIndex, rowData){ 
				updateInterItem();
       		}  
		});
	}
	/**
	 * @description 修改接口
	 */
	function updateInterItem() {
		var rows = $('#interfaceItemGrid').datagrid("getSelections");
    	if (rows.length == 1) {
       		$("#add-dialog").dialog("open");
        	//清空表单数据
	 		$('#add-form').form("clear");
		 	$('#add-form').form("load",{
		 		Rowid: rows[0].Rowid,
		 		Name: rows[0].Name,
		 		InterType: rows[0].TypeCode,
		 	    ClsName: rows[0].ClsName,
		 		MetName: rows[0].MetName,
		 		MsgCode: rows[0].MsgCode
	 		});
	 		if(rows[0].IsStop == "Y"){
		 		$("#IsStop").checkbox('setValue', true);
		 	}else{
			 	$("#IsStop").checkbox("setValue", false);	
			}
			if(rows[0].IsOldVersion == "Y"){
		 		$("#IsOldVersion").checkbox('setValue', true);
		 	}else{
			 	$("#IsOldVersion").checkbox("setValue", false);	
			}
	 			
     	}else{
	    	$.messager.alert("简单提示", "请选择要修改的配置数据", "info");
     	}
	}
	/**
	 * @description 保存接口
	 */
	function saveInterItem() {
		var rowid = $("#rowid").val();
		var name = $("#Name").val();
		var interType = $("#InterType").combobox('getValue');
		var clsName = $("#ClsName").val();
		var metName = $("#MetName").val();
		var msgCode = $("#MsgCode").val();
		var isStop = $("#IsStop").radio('getValue') ? "Y" : "N";
		var isOldVersion = $("#IsOldVersion").radio('getValue') ? "Y" : "N";
		if(!name){
			$.messager.popover({ msg: '名称不能为空！', type:'error' });
        	return false;
		}
		if(!interType){
			$.messager.popover({ msg: '类型不能为空！', type:'error' });
        	return false;
		}
		if(!clsName){
			$.messager.popover({ msg: '类名不能为空！', type:'error' });
        	return false;
		}
		if(!metName){
			$.messager.popover({ msg: '方法名不能为空！', type:'error' });
        	return false;
		}
		if(!msgCode){
			$.messager.popover({ msg: '消息代码不能为空！', type:'error' });
        	return false;
		}
		var paramConfig = { 'ClsName':'CF.NUR.CDSS.InterfaceItem', 'RowID':rowid, 'CIHospDr': session['LOGON.HOSPID'], 'CIName': name, 'CIInterType': interType, 'CIClsName':clsName, 'CIMetName':metName, 'CIMsgCode':msgCode, 'CIIsOldVersion':isOldVersion, 'CIIsStop':isStop};
		$m({
			ClassName: 'Nur.CDSS.Service.InterfaceConfig',
			MethodName: 'saveItem',
			ParamConfig: JSON.stringify(paramConfig)
		},function(result){
			if(result == '0'){
				$.messager.popover({ msg: '保存成功!', type: 'success'});
				$("#add-dialog").dialog( "close" );
				$('#interfaceItemGrid').datagrid('reload');			
			}else{
				$.messager.popover({ msg: result, type: 'error'});
			}
		});
	}
	/**
	 * @description 删除接口
	 */
	function deleteInterItem() {
		var rows = $('#interfaceItemGrid').datagrid("getSelections");
    	if (rows.length == 0) {
       		$.messager.alert("简单提示", "请选择要删除的接口", "info");
			return;
     	}
     	$.messager.confirm("警告", "确定要删除吗？", function (r) {
			if (r) {
				var paramConfig = { 'ClsName':'CF.NUR.CDSS.InterfaceItem', 'RowID':rows[0].Rowid };
				$m({
					ClassName: 'Nur.CDSS.Service.InterfaceConfig',
					MethodName: 'deleteItem',
					ParamConfig: JSON.stringify(paramConfig)
				},function(result){
					if(result == '0'){
						$.messager.popover({ msg: '删除成功!', type: 'success'});
						$("#add-dialog").dialog( "close" );
						$('#interfaceItemGrid').datagrid('reload');						
					}else{
						$.messager.popover({ msg: result, type: 'error'});	
					}
				});
			} else {
				return;
			}
		});
	}
	/**
	 * @description 监听事件
	 */
	function listenEvents() {
		$('#btn-add').bind('click',function(){
			$("#add-dialog").dialog("open");
	 		//清空表单数据
	 		$('#add-form').form("clear");
		});
		$('#btn-update').bind('click', updateInterItem);
		$('#btn-delete').bind('click', deleteInterItem);
		$('#btn-dialog-save').bind('click', saveInterItem);
		$('#btn-dialog-cancel').bind('click',function(){
			$HUI.dialog('#add-dialog').close();
		});
	}
	initPage();
});