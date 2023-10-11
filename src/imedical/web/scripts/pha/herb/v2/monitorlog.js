/**
 * ģ��:��ҩ��
 * ��ģ��:�������,ҽ�������־��ѯ
 * createdate:2020-10-30
 * creator:MaYuqiang
 */
/**
 * @_options {{fromgrid,params} } 
 */

function InitAuditLogBody(_options){
	InitAuditLog(_options.params);
	InitAuditLogDetail();
	/* */
	$('#btnCancel').unbind()
	$('#btnCancel').on('click', ExecuteCancel);
	 
	
    
}

function InitAuditLog(prescNo){
	var columns=[
		[
			{field: 'auditDate', title: '�������', width: 120},
			{field: 'auditTime', title: '���ʱ��', width: 120},
			{field: 'auditUserName', title: '�����', width: 80},     
			{field: 'result', title: '��˽��', width: 100},
			{field: 'factor', title: '���ϸ�ʾֵ', width:60, hidden:true},
			{field: 'advice', title: 'ҩʦ����', width:60, hidden:true},
			{field: 'docAdvice', title: 'ҽ����ע', width: 280},	 //ҽ�����߽���
			{field: 'phnote', title: 'ҩʦ��ע', width: 280},
			{field: 'docNote', title: 'ҽ����ע',width:60, hidden:true},
			{field: 'rowid', title: 'rowid', width:60,hidden:true}
		]
	];
	
	var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.HERB.Audit.Query',
            QueryName: 'GetAuditLog',
			params: prescNo
        },      
        columns: columns,
        pagination: false,
        onClickRow:function(rowIndex,rowData){
	         var phaomId = rowData.rowid ;
			 $('#gridAuditLogDetail').datagrid('query', {
				params: phaomId
			});
		}   
    };
	PHA.Grid("gridAuditLog", dataGridOption);
	
}


function InitAuditLogDetail(){
	
	var columns=[
		[
			{field: 'grpno', title: '���', width: 60},
			{field: 'itmDesc', title: 'ԭ���б�', width: 920,align:'left'}
		]
	];
	
	var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.HERB.Audit.Query',
            QueryName: 'GetAuditLogDetail',
			params: ''
        },
        columns: columns,
        pagination: false,
        onDblClickRow:function(rowIndex,rowData){
			
		}   
    };
	PHA.Grid("gridAuditLogDetail", dataGridOption);
}

/// ȡ����˽��
function ExecuteCancel(){
	var gridSelect = $("#gridAuditLog").datagrid("getSelected") ;
	if (gridSelect == null){
		$.messager.alert('��ʾ',"����ѡ����Ҫȡ����˵ļ�¼!","info");
		return;
	}
	var logId = gridSelect.rowid ;
	var params = logId +"^"+ gUserID;
	$.m({
		ClassName: "PHA.HERB.Audit.Save",
		MethodName: "CancelResult",
		params: params 
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('��ʾ', retArr[1], 'warning');
			return;
		}
		else {
			$("#gridAuditLog").datagrid('reload')
		}
		
	});
}


