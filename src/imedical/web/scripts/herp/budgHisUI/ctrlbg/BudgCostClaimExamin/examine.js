checkFun = function(itemGrid) {
	// console.info(itemGrid);
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
	    iconCls: 'icon-save',
	    closed: true,
	    minimizable: false,
	    maximizable: false,
	    collapsible: false,
	    resizable: true,
	    onClose:function(){ //关闭关闭窗口后触发
	    	$("#ViewField").val("");
            $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
	});
	var rowids = itemGrid.rowid;
	var iscur = itemGrid.IsCurStep;
	// var sc = itemGrid.StepNOC;
	// var sf = itemGrid.StepNOF;
	billstate = itemGrid.billstate;
	// ChkselfResult = itemGrid.ChkselfResult;

	if (iscur == 1) {
		$win.window('open');
		// 支付方式的下拉框
	    var CheckResultObj = $HUI.combobox("#CheckResult",{ 
	        mode:'local', 
	        valueField:'rowid',    
	        textField:'name',
	        value:2,
	        data: [{
	                    'rowid': 2,
	                    'name': "通过"
	                },{
	                    'rowid': 3,
	                    'name': "不通过"
	        }]  
	    });
	    $("#CheckClose").unbind('click').click(function(){
	        $win.window('close');
	    });
	    $("#CheckSave").unbind('click').click(function(){
			var view		= $("#ViewField").val();
			var ChkResult	= $("#CheckResult").combobox('getValue');
			$.m({
                ClassName:'herp.budg.hisui.udata.ubudgcostclaimexamin',MethodName:'UpdChkRec',rowid:rowids,view:view,ChkResult:ChkResult,userdr:userdr},
                function(Data){
                    if(Data==0){
                        $.messager.alert('提示','审核成功！','info');
                        $win.window('close');
                    }else{
                        $.messager.alert('提示','错误信息:' +Data,'error');
                    }
                }
            );    	
	        
	    });


	} else if (billstate == "完成") {
		var message="不可重复审核！";
		$.messager.alert('注意',message,'warning');
	} else{
		var message="不是当前审核人！";
		$.messager.alert('注意',message,'warning');				
	}
			
};
