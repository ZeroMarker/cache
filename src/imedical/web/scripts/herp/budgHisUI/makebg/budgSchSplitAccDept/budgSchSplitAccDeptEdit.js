//批量处理--分解方法+调节比例
EditFun = function(rows,splitmethdata) {
    var $win;
    $win = $('#BatchWin').window({
        title: '分解方法设置',
        width: 470,
        height: 216,
        top: ($(window).height() - 216) * 0.5,
        left: ($(window).width() - 470) * 0.5,
        shadow: true,
        modal: true,
        iconCls: 'icon-w-batch-cfg',
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        onClose:function(){ //关闭关闭窗口后触发
            $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
    });
    $win.window('open');
    // 表单的垂直居中
    xycenter($("#batchcenter"),$("#batchff"));
    // 分解方法
    var BSplitMethObj = $HUI.combobox("#BSplitMeth",{
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        data: splitmethdata
    });


    //复制保存 
    $("#BSave").unbind('click').click(function(){
        var SplitMeth= $("#BSplitMeth").combobox("getValue");
        if(SplitMeth=="")
        {
            $.messager.alert('错误',"分解方法不能为空!",'error');
            return;
        }
        for(var i=0; i<rows.length; i++){
            $.m({
	            ClassName:'herp.budg.udata.uBudgSchSplitAccDept',MethodName:'UpdateRec',hospid:hospid,id:rows[i].rowid,Year:rows[i].year,
	            isLast:rows[i].isLast,splitmeth:SplitMeth,code:rows[i].code},
	            function(Data){
	                if(Data==0){
	                    $.messager.popover({
                        msg: '处理成功！',
                        type:'success',
                        showType:'show',
                        style:{
                            "position":"absolute", 
                            "z-index":"9999",
                            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                            top:1
                        }               
                    });
	                }else{
	                    $.messager.popover({
                        msg: "错误:"+Data,
                        type:'error',
                        showType:'show',
                        style:{
                            "position":"absolute", 
                            "z-index":"9999",
                            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                            top:1
                        }               
                    });
	                }
	            }
	        );         
        }

        
        
        $win.window('close');
    });
    //取消 
    $("#BClose").unbind('click').click(function(){
        $win.window('close');
    });

};