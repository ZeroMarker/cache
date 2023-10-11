var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
    Detail();
}); 

function Init(){
    //预算年度
    var YearboxObj = $HUI.combobox("#YearBox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
    // 预算类别
    var SchTyObj = $HUI.combobox("#SchTyBox",{
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        data: [{
                    'rowid': 1,
                    'name': "计划指标"
                },{
                    'rowid': 2,
                    'name': "科目预算"
                },{
                    'rowid': 3,
                    'name': "费用标准"
                },{
                    'rowid': 4,
                    'name': "预算结果表"
        }]
    });

    MainColumns=[[  
                {field:'ckbox',checkbox:true},//复选框
                {field:'select',title:'操作',align:'center',width:30,
                    formatter:function(value,row,index){
                        var rowid=row.rowid;
                            return '<a href="#"  title="复制" class="SpecialClass"  onclick=CopyFun('+rowid+')></a>'
                    }
                },
                {field:'rowid',title:'方案主键',width:80,hidden: true},
                {field:'CompName',title:'医疗单位',width:80,hidden: true},
                {field:'year',title:'年度',width:30},
                {field:'code',title:'方案编码',width:40},
                {field:'name',title:'方案名称',width:130},
                {field:'ischeck',title:'方案审核状态',width:50},
                {field:'CHKFlowdr',title:'审批流ID',align:'left',width:80,hidden: true}
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemAuditDept",
            MethodName:"List",
            hospid :    hospid, 
            userdr:     userid,
            year :      "",
            type:       "",
            name:       ""           
        },
        fitColumns: true,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        singleSelect: true, //只允许选中一行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发 
            $('#MainGrid').datagrid('selectRow',index);
            var row = $('#MainGrid').datagrid('getSelected'); 
            var schemeDr="";
            if(row!=null){
                var schemeDr=row.rowid;
            }       
            var deptstr    =$('#DeptBox').val();//科室
            $('#DetailGrid').datagrid('load',{
                ClassName:"herp.budg.hisui.udata.uBudgSchemAuditDept",
                MethodName:"ListItem",
                hospid :    hospid, 
                userdr:     userid,
                schemeDr :  schemeDr,
                DeptName:   deptstr     
            })
        },
        onLoadSuccess:function(data){
            if(data){
                $('.SpecialClass').linkbutton({
                    plain:true,
                    iconCls:'icon-copy'
                })

            }
        },
        toolbar: '#tb'       
    });    
    // 查询函数
    var FindBtn= function()
    {
        var year    = $('#YearBox').combobox('getValue'); // 预算年度
        var SchTy  = $('#SchTyBox').combobox('getValue'); // 方案类别
        var name    =$('#SchNBox').val();//方案名称
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemAuditDept",
                MethodName:"List",
                hospid :    hospid, 
                userdr:     userid,
                year :      year,
                type:       SchTy,
                name:       name   
            })
    }

    // 点击查询按钮 
    $("#FindBn").click(FindBtn);

    /**复制功能  开始**/
    CopyFun=function(fromschemdr) {
        var $win;
        $win = $('#CopyWin').window({
            title: '复制方案归口科室',
            width: 470,
            height: 240,
            top: ($(window).height() - 240) * 0.5,
            left: ($(window).width() - 470) * 0.5,
            shadow: true,
            modal: true,
            iconCls: 'icon-w-copy',
            closed: true,
            minimizable: false,
            maximizable: false,
            collapsible: false,
            resizable: true,
            onClose:function(){ //关闭关闭窗口后触发
                $("#GoalSch").combobox("disable");
                $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
            }
        });
        $win.window('open');  
        // 表单的垂直居中
        xycenter($("#copycenter"),$("#copyfm"));
        // 年度的下拉框
        var GoalYObj = $HUI.combobox("#GoalYbox",{
            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
            mode:'remote',
            delay:200,
            valueField:'year',    
            textField:'year',
            onBeforeLoad:function(param){
                param.str = param.q;
            },
            onSelect:function(rec){ 
                $("#GoalSch").combobox("enable");
                $('#GoalSch').combobox('reload');
            }
        });
        // 目标方案的下拉框
        var GoalSchObj = $HUI.combobox("#GoalSch",{
            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=BudgSchem",
            mode:'remote',
            delay:200,
            valueField:'rowid',    
            textField:'name',
            onBeforeLoad:function(param){
                param.hospid = hospid;
                param.userdr = userid;
                param.flag   = 2;
                param.year   = $("#GoalYbox").combobox("getValue");
                param.str    = param.q;
            }
        });

        //复制保存 
        $("#CopySave").unbind('click').click(function(){
            var year=$("#GoalYbox").combobox("getValue");
            var toschemdr=$("#GoalSch").combobox("getValue");

            if(year=="")
            {
                $.messager.popover({msg: '年度不能为空！',type:'alert'});
                return;
            }
            if(toschemdr=="")
            {
                $.messager.popover({msg: '方案不能为空！',type:'alert'});
                return;
            }   
            $.m({
                ClassName:'herp.budg.udata.uBudgSchemAuditDept',MethodName:'Copy',fromschemdr:fromschemdr,toschemdr:toschemdr},
                function(Data){
                    if(Data==0){
                        $.messager.popover({msg: '处理成功！',type:'success',timeout: 1000});
                    }else{
                        var message="错误!"
                        if(Data=="done"){
                            var message="表中已存在,勿重复!"
                        }else if(Data=="-1"){
                            message="预算已下达,禁止操作!"
                        }
                        $.messager.popover({msg: message,type:'error'});
                    }
                }
            );
            $win.window('close');
        });
        //关闭 
        $("#CopyClose").unbind('click').click(function(){
            $win.window('close');
        });

    }
    /**复制功能  结束**/


}