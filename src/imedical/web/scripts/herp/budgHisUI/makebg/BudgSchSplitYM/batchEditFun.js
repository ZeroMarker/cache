//批量处理--分解方法+调节比例
batchEditFun = function(splitmethdata) {
    var $win;
    $win = $('#BatchWin').window({
        title: '批量设置',
        width: 470,
        height: 360,
        top: ($(window).height() - 360) * 0.5,
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
            $("#ff").form("reset");
            $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
    });
    $win.window('open');
    // 表单的垂直居中
    xycenter($("#batchcenter"),$("#ff"));
    //预算年度
    var BYboxObj = $HUI.combobox("#BYbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.flag="";
            param.str = param.q;
        },
        onChange:function(n,o){
            if(n!=o){
                $('#BSchembox').combobox('clear');
                $('#BSchembox').combobox('reload'); 
            }
        }
    });
    // 预算方案的下拉框BSchembox
    var BSchemboxObj = $HUI.combobox("#BSchembox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 1;
            param.year   = $("#BYbox").combobox("getValue");
            param.str    = param.q;
        },
        onShowPanel:function(){
            if($('#BYbox').combobox('getValue')==""){
                $(this).combobox('hidePanel');
                var message="请先选择预算年度！"
                $.messager.popover({
                    msg: message,
                    type:'info',
                    showType:'show',
                    style:{
                        "position":"absolute", 
                        "z-index":"9999",
                        left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                        top:10
                    }               
                });
                return false;
            }
        }
    });
	// 预算项类别的下拉框
    var BITypeObj = $HUI.combobox("#BIType",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType",
        mode:'remote',
        delay:200,
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.flag   = 1;
            param.str    = param.q;
        }
    });
    // 分解方法
    var BSplitMethObj = $HUI.combobox("#BSplitMeth",{
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        data: splitmethdata
    });


    //复制保存 
    $("#BSave").unbind('click').click(function(){
        var year     = $("#BYbox").combobox("getValue");
        var SchemDR     = $("#BSchembox").combobox("getValue");
        var ItemType = $("#BIType").combobox("getValue");
        var SplitMeth= $("#BSplitMeth").combobox("getValue");
        var Ratio 	 = $("#BRatio").val();
        if(!year){
            var message="请先选择预算年度！"
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
            return false;
        }
        if(!SchemDR){
            var message="请先选择预算方案！"
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
            return false;
        }
        if(SplitMeth=="")
        {
            var message="分解方法不能为空！"
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
            return;
        }
        if((Ratio>=100)||(Ratio<=1))
        {
            var message="请输入大于1小于100的数！"
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
            return;
        }   
        $.m({
            ClassName:'herp.budg.udata.uBudgSpilt',MethodName:'BatchSplit',hospid:hospid,year:year,Itype:ItemType,
            dtype:"",splitmeth:SplitMeth,rate:Ratio,IsAlComp:"",flag:1,SchemDR:SchemDR},
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
                            top:10
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
                            top:10
                        }               
                    });
                }
            }
        );
        $win.window('close');
    });
    //取消 
    $("#BClose").unbind('click').click(function(){
        $win.window('close');
    });

};