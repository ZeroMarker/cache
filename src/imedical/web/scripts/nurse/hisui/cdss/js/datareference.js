/**
 * @Author      yaojining
 * @DateTime    2021-06-15
 * @description CDSS接口数据对照
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
			valueField: 'id',
			textField: 'desc',
			url: $URL + "?ClassName=Nur.CDSS.Service.Category&MethodName=categoryList",
			onSelect: function(record) {
				$('#cbRef').combobox('clear');
				$('#cbRef').combobox('options').url = $URL + "?ClassName=Nur.CDSS.Service.Category&MethodName=categoryList&TypeDr=" + record.id;
				$('#cbRef').combobox('reload');
				
				$('#refGrid').datagrid('reload', {
					ClassName: 'Nur.CDSS.Service.Category',
		            QueryName: 'FindRefData',
					HospitalID: session['LOGON.HOSPID'],
		            ParRef: record.id,
		            ChildSub:  $('#cbRef').combobox('getValue')
				});
				$('#refGrid').datagrid('uncheckAll');
				
				$HUI.searchbox('#sbCate').setValue('');
				$('#cateGrid').datagrid('reload', {
					ClassName: 'Nur.CDSS.Service.Category',
					QueryName: 'FindData',
					HospitalID: session['LOGON.HOSPID'],
					TypeDr: record.id,
					Content: $HUI.searchbox('#sbCate').getValue()
				});
				$('#cateGrid').datagrid('uncheckAll');		
			}
		});
		$HUI.combobox('#cbRef', {
			valueField: 'id',
			textField: 'desc',
			url: $URL + "?ClassName=Nur.CDSS.Service.Category&MethodName=categoryList&TypeDr=1",
			onSelect: function(record) {
				$('#refGrid').datagrid('reload', {
					ClassName: 'Nur.CDSS.Service.Category',
					QueryName: 'FindRefData',
					HospitalID: session['LOGON.HOSPID'],
	            	ParRef: $('#category').combobox('getValue'),
	            	ChildSub:  $('#cbRef').combobox('getValue')
				});
				$('#refGrid').datagrid('uncheckAll');
				$('#cateGrid').datagrid('uncheckAll');
			}
		});
		$('#refGrid').datagrid({
			url: $URL,
	        queryParams: {
	            ClassName: 'Nur.CDSS.Service.Category',
	            QueryName: 'FindRefData',
				HospitalID: session['LOGON.HOSPID'],
	            ParRef: $('#category').combobox('getValue'),
	            ChildSub:  $('#cbRef').combobox('getValue')
	        },
			fit : true,
			columns: [[
				{field:'checkbox',checkbox:true,align:'center',width:80},
		    	{field:'Desc',title:'名称',width:300},
		    	{field:'Id',title:'ID',width:150}
	    	]],
			toolbar:"#tbReference",
			pagination : true,  //是否分页
			rownumbers : true,
			pageSize: 15,
			pageList : [15,30,50],
			singleSelect : false,
			loadMsg : '加载中..' 
		});
		$('#cateGrid').datagrid({
			url: $URL,
	        queryParams: {
	            ClassName: 'Nur.CDSS.Service.Category',
				QueryName: 'FindData',
				HospitalID: session['LOGON.HOSPID'],
				TypeDr: $('#category').combobox('getValue'),
				Content: $HUI.searchbox('#sbCate').getValue()
	        },
			fit : true,
			columns: [[
				{field:'checkbox',checkbox:true,align:'center',width:80},
	    		{field:'Desc',title:'名称',width:300},
		    	{field:'Id',title:'RowID',width:150}
	    	]],
			toolbar:"#tbCate",
			pagination : true,  //是否分页
			rownumbers : true,
			pageSize: 15,
			pageList : [15,30,50],
			singleSelect : false,
			loadMsg : '加载中..', 			
			onDblClickRow: function(rowIndex, rowData){ 
       		}  
		});
	}
	/**
	 * @description 添加分类
	 */
	function addToCat() {
		var cateValue = $("#category").combobox("getValue");
		if (!cateValue) {
       		$.messager.alert("简单提示", "请选择类型!", "info");
       		return;
     	}
     	var refValue = $("#cbRef").combobox("getValue");
     	if (!$("#cbRef").combobox("getValue")) {
       		$.messager.alert("简单提示", "请选择分类!", "info");
       		return;
     	}
     	var rows = $('#cateGrid').datagrid("getSelections");
    	if (rows.length == 0) {
       		$.messager.alert("简单提示", "请选择要添加的分类", "info");
       		return;
     	}
     	//保存
     	var parameter = {'ParRef':cateValue, 'ChildSub':refValue, 'Rows':rows};
     	$cm({
	    	ClassName: 'Nur.CDSS.Service.Category',
	    	MethodName: 'save',
	    	Parameters: JSON.stringify(parameter)
	    },function(result){
			if(result.status == '0'){
				$.messager.popover({ msg: '添加成功!', type: 'success'});
				$('#refGrid').datagrid('reload');			
			}else{
				$.messager.popover({ msg: '添加失败! 错误信息：' + result.msg, type: 'error'});
			}
		});
	}
	
	/**
	 * @description 删除
	 */
	function deleteCat() {
		var rows = $('#refGrid').datagrid("getSelections");
    	if (rows.length == 0) {
       		$.messager.alert("简单提示", "请选择要删除的数据", "info");
			return;
     	}
     	var parameter = {'Rows':rows};
     	$cm({
	    	ClassName: 'Nur.CDSS.Service.Category',
	    	MethodName: 'delete',
	    	Parameters: JSON.stringify(parameter)
	    },function(result){
			if(result.status == '0'){
				$.messager.popover({ msg: '删除成功!', type: 'success'});
				$('#refGrid').datagrid('reload');			
			}else{
				$.messager.popover({ msg: '删除失败! 错误信息：' + result.msg, type: 'error'});
			}
		});
	}
	/**
	 * @description 监听事件
	 */
	function listenEvents() {
		$("#btn-add").bind("click", addToCat);
		$("#btn-delete").bind("click", deleteCat);
		$("#btn-search").bind("click", function(){
			$('#cateGrid').datagrid('reload', {
	            ClassName: 'Nur.CDSS.Service.Category',
				QueryName: 'FindData',
				HospitalID: session['LOGON.HOSPID'],
				TypeDr: $('#category').combobox('getValue'),
				Content: $HUI.searchbox('#sbCate').getValue()
			});
		});
		$('#sbCate').searchbox({
			searcher: function(value) {
				$("#btn-search").click();
			}
		});
	}
	initPage();
});