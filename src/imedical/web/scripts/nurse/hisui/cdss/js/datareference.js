/**
 * @Author      yaojining
 * @DateTime    2021-06-15
 * @description CDSS�ӿ����ݶ���
 */
$(function() { 
	/**
	 * @description ��ʼ������
	 */
	function initPage(){
		initGrid();
		listenEvents();
	}
	/**
	 * @description ��ʼ�����
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
		    	{field:'Desc',title:'����',width:300},
		    	{field:'Id',title:'ID',width:150}
	    	]],
			toolbar:"#tbReference",
			pagination : true,  //�Ƿ��ҳ
			rownumbers : true,
			pageSize: 15,
			pageList : [15,30,50],
			singleSelect : false,
			loadMsg : '������..' 
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
	    		{field:'Desc',title:'����',width:300},
		    	{field:'Id',title:'RowID',width:150}
	    	]],
			toolbar:"#tbCate",
			pagination : true,  //�Ƿ��ҳ
			rownumbers : true,
			pageSize: 15,
			pageList : [15,30,50],
			singleSelect : false,
			loadMsg : '������..', 			
			onDblClickRow: function(rowIndex, rowData){ 
       		}  
		});
	}
	/**
	 * @description ��ӷ���
	 */
	function addToCat() {
		var cateValue = $("#category").combobox("getValue");
		if (!cateValue) {
       		$.messager.alert("����ʾ", "��ѡ������!", "info");
       		return;
     	}
     	var refValue = $("#cbRef").combobox("getValue");
     	if (!$("#cbRef").combobox("getValue")) {
       		$.messager.alert("����ʾ", "��ѡ�����!", "info");
       		return;
     	}
     	var rows = $('#cateGrid').datagrid("getSelections");
    	if (rows.length == 0) {
       		$.messager.alert("����ʾ", "��ѡ��Ҫ��ӵķ���", "info");
       		return;
     	}
     	//����
     	var parameter = {'ParRef':cateValue, 'ChildSub':refValue, 'Rows':rows};
     	$cm({
	    	ClassName: 'Nur.CDSS.Service.Category',
	    	MethodName: 'save',
	    	Parameters: JSON.stringify(parameter)
	    },function(result){
			if(result.status == '0'){
				$.messager.popover({ msg: '��ӳɹ�!', type: 'success'});
				$('#refGrid').datagrid('reload');			
			}else{
				$.messager.popover({ msg: '���ʧ��! ������Ϣ��' + result.msg, type: 'error'});
			}
		});
	}
	
	/**
	 * @description ɾ��
	 */
	function deleteCat() {
		var rows = $('#refGrid').datagrid("getSelections");
    	if (rows.length == 0) {
       		$.messager.alert("����ʾ", "��ѡ��Ҫɾ��������", "info");
			return;
     	}
     	var parameter = {'Rows':rows};
     	$cm({
	    	ClassName: 'Nur.CDSS.Service.Category',
	    	MethodName: 'delete',
	    	Parameters: JSON.stringify(parameter)
	    },function(result){
			if(result.status == '0'){
				$.messager.popover({ msg: 'ɾ���ɹ�!', type: 'success'});
				$('#refGrid').datagrid('reload');			
			}else{
				$.messager.popover({ msg: 'ɾ��ʧ��! ������Ϣ��' + result.msg, type: 'error'});
			}
		});
	}
	/**
	 * @description �����¼�
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