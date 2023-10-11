/**
Creator:Liu XiangSong
CreatDate:2018-08-25
Description:全面预算管理-预算编制准备-全院预算编制归口设置
CSPName:herp.budg.hisui.budgschemaudit.csp
ClassName:herp.budg.hisui.udata.uBudgSchemAudit,
herp.budg.udata.uBudgSchemAudit
**/
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
                    'name': "收支标准"
                },{
                    'rowid': 4,
                    'name': "预算结果表"
        }]
    });

    MainColumns=[[  
                {field:'ckbox',checkbox:true},//复选框
                {field:'rowid',title:'方案主键',width:80,hidden: true},
                {field:'CompName',title:'医疗单位',width:80,hidden: true},
                {field:'year',title:'年度',width:40},
                {field:'code',title:'方案编码',width:40},
                {field:'name',title:'方案名称',width:120},
                {field:'ischeck',title:'方案审核状态',width:60},
                {field:'CHKFlowdr',title:'审批流ID',align:'left',width:80,hidden: true}
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemAudit",
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
                ClassName:"herp.budg.hisui.udata.uBudgSchemAudit",
                MethodName:"ListItem",
                hospid :    hospid, 
                userdr:     userid,
                schemeDr :  schemeDr,
                DeptName:   deptstr     
            })
        },
        toolbar: '#tb'       
    });    
    // 查询函数
    var FindBtn= function()
    {
        var year    = $('#YearBox').combobox('getValue'); // 预算年度
        var SchTy  = $('#SchTyBox').combobox('getValue'); // 预算类别
        var name    =$('#SchNBox').val();//方案名称
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemAudit",
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

}