/**
 * @Author      yaojining
 * @DateTime    2021-04-15
 * @description CDSS�ӿ�����
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
	    		{field:'DataName',title:'����',width:120},
		    	{field:'DataCode',title:'����',width:150},
	        	{field:'ItemCode',title:'��������',width:250}
	    	]],
			toolbar:"#toolbar",
			pagination : true,  //�Ƿ��ҳ
			rownumbers : true,
			pageSize: 15,
			pageList : [15,30,50],
			singleSelect : true,
			loadMsg : '������..', 			
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
	 * @description �޸�����
	 */
	function updateInterData() {
		var rows = $('#interfaceDataGrid').datagrid("getSelections");
    	if (rows.length == 1) {
       		$("#add-dialog").dialog("open");
        	//��ձ�����
	 		$('#add-form').form("clear");
		 	$('#add-form').form("load",{
		 		Rowid: rows[0].Rowid,
		 		DataName: rows[0].DataName,
		 		DataCode: rows[0].DataCode,
		 		ItemCode: rows[0].ItemCode
	 		});
     	}else{
	    	$.messager.alert("����ʾ", "��ѡ��Ҫ�޸ĵ�����", "info");
     	}
	}
	/**
	 * @description ��������
	 */
	function saveInterData() {
		var rows = $('#interfaceDataGrid').datagrid("getSelections");
		var childSub = !!$('#Rowid').val() ? rows[0].Rowid : '';
		var dataName = $("#DataName").val();
		var dataCode = $("#DataCode").val();
		var itemCode = $("#ItemCode").combobox('getValue');
		var itemDesc = $("#ItemCode").combobox('getText');
		var itemType = itemDesc.indexOf("��������") > -1 ? 'Common' : 'Custom';
		if (itemDesc.indexOf("ȫ������") > -1) {
			itemType = "Array";
		}
 		if(!dataName){
			$.messager.popover({ msg: '���Ʋ���Ϊ�գ�', type:'error' });
        	return false;
		}
		if(!dataCode){
			$.messager.popover({ msg: '���벻��Ϊ�գ�', type:'error' });
        	return false;
		}
		var paramConfig = { 'ClsName':'CF.NUR.CDSS.InterfaceDict', 'ParRef':$('#category').combobox('getValue'), 'ChildSub':childSub, 'CDDataName': dataName, 'CDDataCode': dataCode, 'CDItemCode': itemCode, 'CDItemType':itemType};
		$m({
			ClassName: 'Nur.CDSS.Service.InterfaceConfig',
			MethodName: 'saveData',
			ParamConfig: JSON.stringify(paramConfig)
		},function(result){
			if(result == '0') {
				$.messager.popover({ msg: '����ɹ�!', type: 'success', timeout:500});
				$("#add-dialog").dialog( "close" );
				$('#interfaceDataGrid').datagrid('reload');
				debugToXml($('#category').combobox('getValue'));					
			}else{
				$.messager.popover({ msg: result, type: 'error'});	
			}
		});
	}
	/**
	 * @description ɾ������
	 */
	function deleteInterData() {
		var rows = $('#interfaceDataGrid').datagrid("getSelections");
    	if (rows.length == 0) {
       		$.messager.alert("����ʾ", "��ѡ��Ҫɾ���Ľӿ�", "info");
			return;
     	}
		var paramConfig = { 'ClsName':'CF.NUR.CDSS.InterfaceDict', 'RowID':$('#category').combobox('getValue') + '||' + rows[0].Rowid };
		$m({
			ClassName: 'Nur.CDSS.Service.InterfaceConfig',
			MethodName: 'deleteData',
			ParamConfig: JSON.stringify(paramConfig)
		},function(result){
			if(result == '0'){
				$.messager.popover({ msg: 'ɾ���ɹ�!', type: 'success'});
				$("#add-dialog").dialog( "close" );
				$('#interfaceDataGrid').datagrid('reload');	
				debugToXml($('#category').combobox('getValue'));				
			}else{
				$.messager.popover({ msg: 'result', type: 'error'});	
			}
		});
	}
	/**
	 * @description �����¼�
	 */
	function listenEvents() {
		$('#btn-add').bind('click', function(){
			if (!$('#category').combobox('getValue')) {
				$.messager.alert("����ʾ", "��ѡ��ӿ���Ŀ��", "info");
				return;
			}
			$("#add-dialog").dialog("open");
			//��ձ�����
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
	 * @description �������
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
	 * @description �����¼�
	 */
	function listenEvents() {
		$('#btn-add').bind('click', function(){
			if (!$('#category').combobox('getValue')) {
				$.messager.alert("����ʾ", "��ѡ��ӿ���Ŀ��", "info");
				return;
			}
			$("#add-dialog").dialog("open");
			//��ձ�����
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