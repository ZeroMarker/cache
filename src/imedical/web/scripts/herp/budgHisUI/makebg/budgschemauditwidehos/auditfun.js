auditFun = function(rowIndex) {
	var userdr = session['LOGON.USERID'];	
	var username = session['LOGON.USERNAME'];
	var $win;
	$win = $('#CheckWin').window({
	    title: '审批',
	    width: 500,
	    height: 300,
	    top: ($(window).height() - 300) * 0.5,
	    left: ($(window).width() - 500) * 0.5,
	    shadow: true,
	    modal: true,
	    iconCls: 'icon-w-stamp',
	    closed: true,
	    minimizable: false,
	    maximizable: false,
	    collapsible: false,
	    resizable: true,
	    onClose:function(){ //关闭关闭窗口后触发
	    	$("#ViewField").val("");
            $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
            $('#MainGrid').datagrid('selectRow',rowIndex);
        }
	});

	$win.window('open');
	// 支付方式的下拉框
    var CheckResultObj = $HUI.combobox("#CheckResult",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value:1,
        data: [{
                    'rowid': 1,
                    'name': "通过"
                },{
                    'rowid': 0,
                    'name': "不通过"
        }]  
    });
    $("#CheckClose").unbind('click').click(function(){
        $win.window('close');
    });
    $("#CheckSave").unbind('click').click(function(){
    	var rows = $('#MainGrid').datagrid('getRows');
    	var schemAuditDR=rows[rowIndex].schemAuditDR;
		var view		= $("#ViewField").val();
		var ChkResult	= $("#CheckResult").combobox('getValue');
		$.m({
            ClassName:'herp.budg.hisui.udata.uBudgSchemAuditWideHos',MethodName:'UpdChkRec',SchemAuditDR:schemAuditDR,view:view,ChkSatte:ChkResult,userdr:userdr},
            function(Data){
                if(Data==0){
                    $.messager.popover({msg: '审核成功！',type:'success'}); 
                    $win.window('close');
                    $('#DSaveBn').linkbutton("disable");
                	$('#DCheckBn').linkbutton("disable");
                }else{
                    $.messager.popover({msg: '错误信息:' +Data,type:'error'});
                }
            }
        );    	
        
    });

}