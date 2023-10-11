editrFun = function(splitmethdata) {
	var userid = session['LOGON.USERID'];
	var hospid=session['LOGON.HOSPID'];
	var $Addwin;
    $Addwin = $('#AddWin').window({
        title: '批量设置',
        width: 660,
        height: 320,
        top: ($(window).height() - 320) * 0.5,
        left: ($(window).width() - 660) * 0.5,
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
    $Addwin.window('open');
    // 表单的垂直居中
    xycenter($("#addcenter"),$("#ff"));
    //预算年度
    var AddYboxObj = $HUI.combobox("#AddYbox",{
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
                $('#AddSchem').combobox('clear');
                $('#AddSchem').combobox('reload'); 
            }
        }
    });
    // 预算方案的下拉框AddSchemObj
    var AddSchemObj = $HUI.combobox("#AddSchem",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 1;
            param.year   = $("#AddYbox").combobox("getValue");
            param.str    = param.q;
        },
        onShowPanel:function(){
            if($('#AddYbox').combobox('getValue')==""){
                $(this).combobox('hidePanel');
                $.messager.popover({
                    msg: "请先选择预算年度!",
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
    var AddITypeObj = $HUI.combobox("#AddIType",{
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
    // 科室类别的下拉框
    var AddDTypeObj = $HUI.combobox("#AddDType",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=deptType",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.str    = param.q;
        }
    });
    // 分解方法
    var AddSplitMethObj = $HUI.combobox("#AddSplitMeth",{
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        data: splitmethdata
    });
    // 是否独立核算
    var AddisAlCompObj = $HUI.combobox("#AddisAlComp",{
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value:0,
        data: [{
                    'rowid': 1,
                    'name': "是"
                },{
                    'rowid': 0,
                    'name': "否"                
        }]
    });


    //保存 
    $("#AddSave").unbind('click').click(function(){
        var year     = $("#AddYbox").combobox("getValue");
        var AddSchemDR    = $("#AddSchem").combobox("getValue");
        var ItemType = $("#AddIType").combobox("getValue");
        var SplitMeth= $("#AddSplitMeth").combobox("getValue");
        var DeptType= $("#AddDType").combobox("getValue");
        var Ratio 	 = $("#AddRatio").val();
        var isAlComp= $("#AddisAlComp").combobox("getValue");

        if(year=="")
        {
            $.messager.popover({
                msg: "预算年度不能为空!",
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
        if(AddSchemDR=="")
        {
            $.messager.popover({
                msg: "预算方案不能为空!",
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
        if(SplitMeth=="")
        {
            $.messager.popover({
                msg: "分解方法不能为空!",
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
        if(!((Ratio<100)&&(Ratio>0)))
        {
            $.messager.popover({
                msg: "调节比例应该大于0小于100!",
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
            dtype:DeptType,splitmeth:SplitMeth,rate:Ratio,IsAlComp:isAlComp,flag:2,SchemDR:AddSchemDR},
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
        $Addwin.window('close');
    });
    //取消 
    $("#AddClose").unbind('click').click(function(){
        $Addwin.window('close');
    });

};