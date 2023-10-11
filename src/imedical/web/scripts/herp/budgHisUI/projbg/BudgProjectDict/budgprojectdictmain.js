var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
}); 

function Init(){
	// 年度的下拉框
	var YMboxObj = $HUI.combobox("#YMbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
    // 责任科室的下拉框
    var DutyDeptObj = $HUI.combobox("#DutyDeptbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 3;
            param.str = param.q;
        }
    });
    // 预算科室的下拉框
    var ApplyDboxObj = $HUI.combobox("#ApplyDbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 1;
            param.str = param.q;
        }
    });
    // 项目性质的下拉框
    var ProjTyboxObj = $HUI.combobox("#ProjTybox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        data: [{
                    'rowid': 1,
                    'name': "一般性项目"
                },{
                    'rowid': 2,
                    'name': "基建项目"
                },{
                    'rowid': 3,
                    'name': "科研项目"
        }]
     });
    // 项目状态的下拉框
    var ProjStateboxObj = $HUI.combobox("#ProjStatebox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        data: [{
                    'rowid': 1,
                    'name': "新建"
                },{
                    'rowid': 2,
                    'name': "执行"
                },{
                    'rowid': 3,
                    'name': "完成"
                },{
                    'rowid': 4,
                    'name': "取消"
        }]
    });
    // 政府采购的下拉框
    var GovBuyboxObj = $HUI.combobox("#GovBuybox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        data: [{
                    'rowid': 1,
                    'name': "是"
                },{
                    'rowid': 2,
                    'name': "否"
        }]
     });
    MainColumns=[[  
                {field:'ck',checkbox:true},//复选框
                {field:'rowid',title:'申请表ID',width:80,hidden: true},
                {field:'CompName',title:'医疗单位',width:80,hidden: true},
                {field:'code',title:'项目编号',width:150},
                {field:'name',title:'项目名称',width:200},
                {field:'spellcode',title:'拼音码',width:100},
                {field:'year',title:'年度',width:80},
                {field:'budgDeptDR',title:'预算科室ID',width:80,hidden: true},
                {field:'bdeptname',title:'预算科室',width:120},
                {field:'deprdr',title:'责任科室ID',width:100,hidden: true},
                {field:'deptname',title:'责任科室',width:120},
                {field:'userdr',title:'负责人ID',width:80,hidden: true},
                {field:'username',title:'负责人',width:120},
                {field:'pretype',title:'编制方式',width:100,
                    formatter:function(value){
                        if (value== 1) {
                            return '自上而下';
                        } 
                        if (value== 2) {
                            return '自下而上';
                        } 
                    }
                },
                {field:'blancetype',title:'结余方式',width:120,
                    formatter:function(value){
                        if (value== 1) {
                            return '按总预算计算';
                        } 
                        if (value== 2) {
                            return '按明细项计算';
                        } 
                    }
                },
                {field:'property',title:'项目性质',width:100,
                    formatter:function(value){
                        if (value== 1) {
                            return '一般性项目';
                        } 
                        if (value== 2) {
                            return '基建项目';
                        } 
                        if (value== 3) {
                            return '科研项目';
                        } 
                    }
                },
                {field:'state',title:'项目状态',width:100,
                    formatter:function(value){
                        if (value== 1) {
                            return '新建';
                        } 
                        if (value== 2) {
                            return '执行';
                        } 
                        if (value== 3) {
                            return '完成';
                        } 
                        if (value== 4) {
                            return '取消';
                        }
                    }
                },
                {field:'isgovbuy',title:'政府采购',width:100,
                    formatter:function(value){
                        if (value== 1) {
                            return '是';
                        } 
                        if (value== 2) {
                            return '否';
                        } 
                    }
                },
                {field:'goal',title:'项目说明',width:200},
                {field:'budgvalue',title:'项目总预算',width:60,hidden: true},
                {field:'plansdate',title:'计划启动时间',align:'left',width:120},
                {field:'planedate',title:'计划结束时间',align:'left',width:120},
                {field:'realsdate',title:'实际开始时间',align:'left',width:120},
                {field:'realedate',title:'实际结束时间',align:'left',width:120},
                {field:'alert',title:'预警线%',width:80,hidden: true},
                {field:'filedesc',title:'图片预览',width:150}
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgProjectDict",
            MethodName:"List",
            hospid :    hospid, 
            userid :    userid,
            year   : 	"",
            deptdr : 	"",
            property: 	"",
            state : 	"",
            isgovbuy: 	"",
            budgdept: 	""
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        singleSelect: true, //只允许选中一行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        rowStyler: function(index,row){
            if(index%2==1){
                return 'background-color:#FAFAFA;';
            }
        },
        toolbar: [{
            id: 'Add',
            iconCls: 'icon-add',
            text: '增加',
            handler: function(){
                projAddFun();
            }
        },{
            id: 'Edit',
            iconCls: 'icon-edit',
            text: '修改',
            handler: function(){
                var row = $('#MainGrid').datagrid('getSelected');
                if(row==null){
                    $.messager.alert('提示','请选择需要修改的数据!','info');
                }else{
                    projEditFun(row);
                }
            }
        },{
            id: 'Del',
            iconCls: 'icon-del-diag',
            text: '删除',
            handler: function(){
                if (ChkBefDel() == true) {
                    del()
                } else {
                    return;
                }
            }
        }]       
    });
    //查询函数
    var FindBtn= function()
    {
        var Year = $('#YMbox').combobox('getValue'); // 年度
        var DutyDept  = $('#DutyDeptbox').combobox('getValue'); // 责任科室
        var ApplyD    = $('#ApplyDbox').combobox('getValue'); // 预算科室
        var ProjTy    = $('#ProjTybox').combobox('getValue'); // 项目性质
        var ProjState = $('#ProjStatebox').combobox('getValue');  // 项目状态
        var GovBuy    = $('#GovBuybox').combobox('getValue');  // 政府采购
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgProjectDict",
                MethodName:"List",
                hospid :    hospid, 
	            userid :    userid,
	            year   : 	Year,
	            deptdr : 	DutyDept,
	            property: 	ProjTy,
	            state : 	ProjState,
	            isgovbuy: 	GovBuy,
	            budgdept: 	ApplyD
            })
    }
    //点击查询按钮 
    $("#FindBn").click(FindBtn);
    //删除项目信息之前检查
    function ChkBefDel() {
        var row = $('#MainGrid').datagrid('getSelected');
        if(row==null){ 
            $.messager.alert('提示','请选择需要删除的数据!','info');
            return false;
        }else{
            //检查是否是"新建"记录
            if (row.state !== "1") {
                $.messager.alert('警告','只允许删除未审核单据!','warning');
                return false;
            }
            return true;
        }
    };
    //删除项目信息
    function del() {
        $.messager.confirm('确定','确定要删除选定的数据吗？',function(t){
           if(t){
            var rowid = "";
            var row = $('#MainGrid').datagrid("getSelected");
            rowid=row.rowid;
            $.m({
                ClassName:'herp.budg.udata.uBudgProjectDict',MethodName:'Delete',rowId:rowid},
                function(Data){
                    if(Data==0){
                        $.messager.alert('提示','删除成功！','info',function(){$('#MainGrid').datagrid("reload")});
                    }else{
                        $.messager.alert('提示','错误信息:' +Data,'error',function(){$('#MainGrid').datagrid("reload")});
                    }
                }
            );
           } 
        })  
    }  

}