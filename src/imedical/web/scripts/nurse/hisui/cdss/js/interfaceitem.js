/**
 * @Author      yaojining
 * @DateTime    2021-04-15
 * @description CDSS�ӿ���Ŀ
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
		var setFrozenColumns = [[
        	{field:'Name',title:'�ӿ�����',width:250}
    	]];
    	var setColumns = [[
    		{field:'InterType',title:'�ӿ�����',width:150},
			{field:'TypeCode',title:'�ӿ����ʹ���',width:150,hidden:true},
        	{field:'ClsName',title:'������',width:350},
        	{field:'MetName',title:'��������',width:200},
        	{field:'MsgCode',title:'��Ϣ����',width:280},
        	{field:'IsOldVersion', title:'�Ƿ�ɰ�', width:80, formatter:function(value, row, index){
	        	return value == "Y" ? "��" : "��"	
	        }},
        	{field:'IsStop', title:'�Ƿ�ͣ��', width:80, formatter:function(value, row, index){
	        	return value == "Y" ? "��" : "��"	
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
			pagination : true,  //�Ƿ��ҳ
			rownumbers : true,
			pageSize: 15,
			pageList : [15,30,50],
			singleSelect : true,
			loadMsg : '������..', 
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
	 * @description �޸Ľӿ�
	 */
	function updateInterItem() {
		var rows = $('#interfaceItemGrid').datagrid("getSelections");
    	if (rows.length == 1) {
       		$("#add-dialog").dialog("open");
        	//��ձ�����
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
	    	$.messager.alert("����ʾ", "��ѡ��Ҫ�޸ĵ���������", "info");
     	}
	}
	/**
	 * @description ����ӿ�
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
			$.messager.popover({ msg: '���Ʋ���Ϊ�գ�', type:'error' });
        	return false;
		}
		if(!interType){
			$.messager.popover({ msg: '���Ͳ���Ϊ�գ�', type:'error' });
        	return false;
		}
		if(!clsName){
			$.messager.popover({ msg: '��������Ϊ�գ�', type:'error' });
        	return false;
		}
		if(!metName){
			$.messager.popover({ msg: '����������Ϊ�գ�', type:'error' });
        	return false;
		}
		if(!msgCode){
			$.messager.popover({ msg: '��Ϣ���벻��Ϊ�գ�', type:'error' });
        	return false;
		}
		var paramConfig = { 'ClsName':'CF.NUR.CDSS.InterfaceItem', 'RowID':rowid, 'CIHospDr': session['LOGON.HOSPID'], 'CIName': name, 'CIInterType': interType, 'CIClsName':clsName, 'CIMetName':metName, 'CIMsgCode':msgCode, 'CIIsOldVersion':isOldVersion, 'CIIsStop':isStop};
		$m({
			ClassName: 'Nur.CDSS.Service.InterfaceConfig',
			MethodName: 'saveItem',
			ParamConfig: JSON.stringify(paramConfig)
		},function(result){
			if(result == '0'){
				$.messager.popover({ msg: '����ɹ�!', type: 'success'});
				$("#add-dialog").dialog( "close" );
				$('#interfaceItemGrid').datagrid('reload');			
			}else{
				$.messager.popover({ msg: result, type: 'error'});
			}
		});
	}
	/**
	 * @description ɾ���ӿ�
	 */
	function deleteInterItem() {
		var rows = $('#interfaceItemGrid').datagrid("getSelections");
    	if (rows.length == 0) {
       		$.messager.alert("����ʾ", "��ѡ��Ҫɾ���Ľӿ�", "info");
			return;
     	}
     	$.messager.confirm("����", "ȷ��Ҫɾ����", function (r) {
			if (r) {
				var paramConfig = { 'ClsName':'CF.NUR.CDSS.InterfaceItem', 'RowID':rows[0].Rowid };
				$m({
					ClassName: 'Nur.CDSS.Service.InterfaceConfig',
					MethodName: 'deleteItem',
					ParamConfig: JSON.stringify(paramConfig)
				},function(result){
					if(result == '0'){
						$.messager.popover({ msg: 'ɾ���ɹ�!', type: 'success'});
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
	 * @description �����¼�
	 */
	function listenEvents() {
		$('#btn-add').bind('click',function(){
			$("#add-dialog").dialog("open");
	 		//��ձ�����
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