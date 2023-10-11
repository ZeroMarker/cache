/**
 * @Author      yaojining
 * @DateTime    2021-04-15
 * @description CDSS接口数据
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
		$HUI.combobox('#category', {
			valueField: 'Rowid',
			textField: 'Name',
			url: $URL + "?ClassName=Nur.CDSS.Service.InterfaceConfig&QueryName=FindInterItems&ResultSetType=array",
			onSelect: function(record) {
				$('#interfaceDataGrid').datagrid('reload', {
					ClassName: 'Nur.CDSS.Service.InterfaceConfig',
					QueryName: 'FindInterData',
					HospitalID: session['LOGON.HOSPID'],
					ParRef: record.Rowid
				});
				$('#ItemCode').combobox('clear');
				$('#ItemCode').combobox('options').url = $URL + "?ClassName=Nur.CDSS.Service.InterfaceConfig&MethodName=dictItems&HospitalID=" + session['LOGON.HOSPID'] + "&InterfaceType=" + record.TypeCode;
				$('#ItemCode').combobox('reload');
				debugToXml(record.Rowid);
			}
		});
		$('#interfaceDataGrid').datagrid({
			url: $URL,
	        queryParams: {
	            ClassName: 'Nur.CDSS.Service.InterfaceConfig',
	            QueryName: 'FindInterData',
				HospitalID: session['LOGON.HOSPID'],
	            ParRef: $('#category').combobox('getValue')
	        },
			fit : true,
			columns: [[
	    		{field:'DataName',title:'名称',width:120},
		    	{field:'DataCode',title:'代码',width:150},
	        	{field:'ItemCode',title:'关联代码',width:250}
	    	]],
			toolbar:"#toolbar",
			pagination : true,  //是否分页
			rownumbers : true,
			pageSize: 15,
			pageList : [15,30,50],
			singleSelect : true,
			loadMsg : '加载中..', 			
			onDblClickRow: function(rowIndex, rowData){ 
				updateInterData();
       		}  
		});
		
		$HUI.combobox("#ItemCode", {
			valueField: 'id',
			textField: 'desc',
			onShowPanel: function() {
				var url = $(this).combobox('options').url;
				if (!url) {
					var url = $URL + "?ClassName=Nur.CDSS.Service.InterfaceConfig&MethodName=dictItems&HospitalID=" + session['LOGON.HOSPID'] + "&InterfaceType=";
					$(this).combobox('reload', url);
				}
			},
			defaultFilter:4
		});
	}
	/**
	 * @description 修改数据
	 */
	function updateInterData() {
		var rows = $('#interfaceDataGrid').datagrid("getSelections");
    	if (rows.length == 1) {
       		$("#add-dialog").dialog("open");
        	//清空表单数据
	 		$('#add-form').form("clear");
		 	$('#add-form').form("load",{
		 		Rowid: rows[0].Rowid,
		 		DataName: rows[0].DataName,
		 		DataCode: rows[0].DataCode,
		 		ItemCode: rows[0].ItemCode
	 		});
     	}else{
	    	$.messager.alert("简单提示", "请选择要修改的数据", "info");
     	}
	}
	/**
	 * @description 保存数据
	 */
	function saveInterData() {
		var rows = $('#interfaceDataGrid').datagrid("getSelections");
		var childSub = !!$('#Rowid').val() ? rows[0].Rowid : '';
		var dataName = $("#DataName").val();
		var dataCode = $("#DataCode").val();
		var itemCode = $("#ItemCode").combobox('getValue');
		var itemDesc = $("#ItemCode").combobox('getText');
		var itemType = itemDesc.indexOf("公共数据") > -1 ? 'Common' : 'Custom';
		if (itemDesc.indexOf("全部数据") > -1) {
			itemType = "Array";
		}
 		if(!dataName){
			$.messager.popover({ msg: '名称不能为空！', type:'error' });
        	return false;
		}
		if(!dataCode){
			$.messager.popover({ msg: '代码不能为空！', type:'error' });
        	return false;
		}
		var paramConfig = { 'ClsName':'CF.NUR.CDSS.InterfaceDict', 'ParRef':$('#category').combobox('getValue'), 'ChildSub':childSub, 'CDDataName': dataName, 'CDDataCode': dataCode, 'CDItemCode': itemCode, 'CDItemType':itemType};
		$m({
			ClassName: 'Nur.CDSS.Service.InterfaceConfig',
			MethodName: 'saveData',
			ParamConfig: JSON.stringify(paramConfig)
		},function(result){
			if(result == '0') {
				$.messager.popover({ msg: '保存成功!', type: 'success', timeout:500});
				$("#add-dialog").dialog( "close" );
				$('#interfaceDataGrid').datagrid('reload');
				debugToXml($('#category').combobox('getValue'));					
			}else{
				$.messager.popover({ msg: result, type: 'error'});	
			}
		});
	}
	/**
	 * @description 删除数据
	 */
	function deleteInterData() {
		var rows = $('#interfaceDataGrid').datagrid("getSelections");
    	if (rows.length == 0) {
       		$.messager.alert("简单提示", "请选择要删除的接口", "info");
			return;
     	}
		var paramConfig = { 'ClsName':'CF.NUR.CDSS.InterfaceDict', 'RowID':$('#category').combobox('getValue') + '||' + rows[0].Rowid };
		$m({
			ClassName: 'Nur.CDSS.Service.InterfaceConfig',
			MethodName: 'deleteData',
			ParamConfig: JSON.stringify(paramConfig)
		},function(result){
			if(result == '0'){
				$.messager.popover({ msg: '删除成功!', type: 'success'});
				$("#add-dialog").dialog( "close" );
				$('#interfaceDataGrid').datagrid('reload');	
				debugToXml($('#category').combobox('getValue'));				
			}else{
				$.messager.popover({ msg: 'result', type: 'error'});	
			}
		});
	}
	/**
	 * @description 监听事件
	 */
	function listenEvents() {
		$('#btn-add').bind('click', function(){
			if (!$('#category').combobox('getValue')) {
				$.messager.alert("简单提示", "请选择接口项目！", "info");
				return;
			}
			$("#add-dialog").dialog("open");
			//清空表单数据
			$('#add-form').form("clear");
		});
		$('#btn-update').bind('click', updateInterData);
		$('#btn-delete').bind('click', deleteInterData);
		$('#btn-dialog-save').bind('click', saveInterData);
		$('#btn-dialog-cancel').bind('click',function(){
			$HUI.dialog('#add-dialog').close();
		});
		$('#search').bind('click', function() {
			$('#interfaceDataGrid').datagrid('reload', {
				ClassName: 'Nur.CDSS.Service.InterfaceConfig',
				QueryName: 'FindInterData',
				HospitalID: session['LOGON.HOSPID'],
				ParRef: $('#category').combobox('getValue')
			});
		});
	}
	/**
	 * @description 调试输出
	 */
	function debugToXml(cateID) {
		$m({
			ClassName: 'Nur.CDSS.Service.InterfaceConfig',
			MethodName: 'debugToXml',
			cateID: cateID
		},function(xml) {
			$("#textArea").val(xml);
		});
	}
	/**
	 * @description 监听事件
	 */
	function listenEvents() {
		$('#btn-add').bind('click', function(){
			if (!$('#category').combobox('getValue')) {
				$.messager.alert("简单提示", "请选择接口项目！", "info");
				return;
			}
			$("#add-dialog").dialog("open");
			//清空表单数据
			$('#add-form').form("clear");
		});
		$('#btn-update').bind('click', updateInterData);
		$('#btn-delete').bind('click', deleteInterData);
		$('#btn-dialog-save').bind('click', saveInterData);
		$('#btn-dialog-cancel').bind('click',function(){
			$HUI.dialog('#add-dialog').close();
		});
		$('#search').bind('click', function() {
			$('#interfaceDataGrid').datagrid('reload', {
				ClassName: 'Nur.CDSS.Service.InterfaceConfig',
				QueryName: 'FindInterData',
				HospitalID: session['LOGON.HOSPID'],
				ParRef: $('#category').combobox('getValue')
			});
		});
	}
	initPage();
});