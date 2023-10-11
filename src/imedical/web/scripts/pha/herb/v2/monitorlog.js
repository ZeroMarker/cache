/**
 * 模块:草药房
 * 子模块:处方审核,医嘱审核日志查询
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
			{field: 'auditDate', title: '审核日期', width: 120},
			{field: 'auditTime', title: '审核时间', width: 120},
			{field: 'auditUserName', title: '审核人', width: 80},     
			{field: 'result', title: '审核结果', width: 100},
			{field: 'factor', title: '不合格警示值', width:60, hidden:true},
			{field: 'advice', title: '药师建议', width:60, hidden:true},
			{field: 'docAdvice', title: '医生备注', width: 280},	 //医生申诉建议
			{field: 'phnote', title: '药师备注', width: 280},
			{field: 'docNote', title: '医生备注',width:60, hidden:true},
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
			{field: 'grpno', title: '组号', width: 60},
			{field: 'itmDesc', title: '原因列表', width: 920,align:'left'}
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

/// 取消审核结果
function ExecuteCancel(){
	var gridSelect = $("#gridAuditLog").datagrid("getSelected") ;
	if (gridSelect == null){
		$.messager.alert('提示',"请先选中需要取消审核的记录!","info");
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
			$.messager.alert('提示', retArr[1], 'warning');
			return;
		}
		else {
			$("#gridAuditLog").datagrid('reload')
		}
		
	});
}


