var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){
    Init();//初始化
}); 

function Init(){
    var YMboxObj = $HUI.combobox("#YMbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.flag = 1;
            param.str = param.q;
        }
    });
// }                
// 申请单号的下拉框
    var ApplyCboxObj = $HUI.combobox("#ApplyCbox",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.ubudgcostclaimexamin&MethodName=GetBillCode",//+ '&userdr=' + userid+ '&str='+$('#ApplyCbox').combobox('getText'),
        mode:'remote',
        delay:200,
        valueField:'billcode',    
        textField:'displayinfo',
        onBeforeLoad:function(param){
            param.userdr = userid;
            param.str = param.q;
        }
    });
// 申请人的下拉框
    var ApplyerObj = $HUI.combobox("#Applyerbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.str = param.q;
        }
    });
// 归口科室的下拉框
    var OwnDeptboxObj = $HUI.combobox("#OwnDeptbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 1;
            param.str    = param.q;
        }
    });

// 申请科室的下拉框
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
// 单据状态的下拉框
    var StateboxObj = $HUI.combobox("#Statebox",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        data: [{
                    'rowid': 1,
                    'name': "新建"
                },{
                    'rowid': 2,
                    'name': "提交"
                },{
                    'rowid': 3,
                    'name': "完成"
        }]
     });
    MainColumns=[[  
                // {field:'ck',checkbox:true},//复选框
                {field:'rowid',title:'申请表ID',width:80,hidden: true},
                {field:'CompName',title:'医疗单位',width:80,hidden: true},
                {field:'select',title:'选择',width:50,formatter:formatselect},
                {field:'File',title:'附件图片',align:'left',width:120,formatter:formatblue},
                {field:'checkyearmonth',title:'核算年月',align:'left',width:80},
                {field:'billcode',title:'报销单号',align:'left',width:150,formatter:formatblue},
                {field:'audeprdr',title:'归口科室ID',align:'left',width:120,hidden: true},
                {field:'audname',title:'归口科室',align:'left',width:120},
                {field:'deprdr',title:'报销科室ID',width:100,hidden: true},
                {field:'dname',title:'报销科室',align:'left',width:120},
                {field:'applyerdr',title:'申请人ID',align:'left',width:100,hidden: true},
                {field:'applyer',title:'申请人',align:'left',width:120},
                {field:'reqpay',title:'报销金额',align:'right',width:120},
                {field:'actpay',title:'审批金额',align:'right',width:120},
                {field:'applydate',title:'申请时间',align:'left',width:150},
                {field:'billstate',title:'单据状态',align:'left',width:100,
                    formatter:function(value,row,index){
                        var rowid=row.rowid;                       
                        return '<a href="#" class="grid-td-text" onclick=billstatefun('+rowid+')>' + value + '</a>';                     
                    }
                },
                {field:'checkstate',title:'审核状态',align:'left',width:80},
                {field:'applydecl',title:'报销说明',align:'left',width:200},
                {field:'budgetsurplus',title:'审批后结余',align:'right',width:120},
                {field:'budgcotrol',title:'预算控制',align:'left',width:80,
                    styler:function(value,row,index){
                        var sf = row.budgcotrol;
                        if (sf != "预算内") {
                            return 'background-color:#ee4f38;color:white';
                        }
                    }
                },
                {field:'IsCurStep',title:'是否当前审批',align:'left',width:80,hidden: true},
                {field:'checkStep',title:'审批步骤',align:'left',width:80,hidden: true},
                {field:'applydr',title:'资金申请单号id',align:'left',width:100,hidden: true},
                {field:'CheckDR',title:'审批流ID',align:'left',width:100,hidden: true},
                {field:'ChekFlowNa',title:'审批流',align:'left',width:120},
                {field:'PayMeth',title:'支付方式',align:'left',width:80,
                    formatter:function(value){
                        if (value== 1) {
                            return '现金';
                        } 
                        if (value== 2) {
                            return '银行';
                        } 
                    }
                },
                {field:'BKName',title:'开户行名称',align:'left',width:120},
                {field:'BKCardNo',title:'银行卡号',align:'left',width:150},
                {field:'ChkFstDR',title:'权限提交人',align:'left',width:120,hidden: true},
                {field:'StepNOF',title:'审批流顺序号',align:'left',width:120,hidden: true},
                {field:'StepNOC',title:'当前顺序号',align:'left',width:120,hidden: true},
                {field:'ChkselfResult',title:'登录人审核状态',align:'left',width:120,hidden: true}

            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.ubudgcostclaimexamin",
            MethodName:"List",
            hospid :    hospid, 
            userdr :    userid,
            data   : ""
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        singleSelect: true, //只允许选中一行
        pageSize:20,
        //pageNumber:1,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onClickRow: onClickRow,  //在用户点击一行的时候触发
        striped : true,
        onLoadSuccess:function(data){
            if(data){
                $('.SpecialClass').linkbutton({
                    plain:true
                })
                $('#MainGrid').datagrid('getPanel').removeClass('panel-body');
            }
        },
        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发
            if ((field=="billcode")||(field=="select")) {
                $('#MainGrid').datagrid('selectRow', index);
                var itemGrid = $('#MainGrid').datagrid('getSelected');
                if(field=="billcode"){
                    EditFun(itemGrid);
                }
            }    
        },
        toolbar: '#tb'      
    });    

    //点击一行时触发。
    function onClickRow(index){
        $('#MainGrid').datagrid('selectRow', index);                
    }
    //查询函数
    var FindBtn= function()
    {
        var yearmonth = $('#YMbox').combobox('getValue'); // 申请年月
        var billcode  = $('#ApplyCbox').combobox('getValue'); // 单据单号
        var Applyer   = $('#Applyerbox').combobox('getValue'); // 申请人
        var OwnDept   = $('#OwnDeptbox').combobox('getValue'); // 归口科室
        var ApplyD    = $('#ApplyDbox').combobox('getValue');  // 申请科室
        var State    = $('#Statebox').combobox('getValue');  // 单据状态
        if (State==undefined){ State ="";}
        var StPrice    = $('#StPricebox').val(); // 审批金额范围-最小值
        var EdPrice    = $('#EdPricebox').val(); // 审批金额范围-最大值
        var data = yearmonth+ "^" + billcode+ "^" +Applyer+ "^" +OwnDept+ "^" +ApplyD+ "^" +State+ "^" +StPrice+ "^" +EdPrice;
        // alert(data)
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.ubudgcostclaimexamin",
                MethodName:"List",
                hospid :    hospid, 
                userdr :    userid,
                data   :    data
            })
    }
    //单元格加下划线--绿色
    function formatblue(value,row,index){
        return '<span class="grid-td-text">' + value + '</span>';
    }
    //“选择”列格式化函数
    function formatselect(value,row,index){
        return '<a href="#" class="SpecialClass" title="审核" data-options="iconCls:\'icon-stamp\'" onclick=checks('+index+')></a>'
    }
    //点击查询按钮 
    $("#FindBn").click(FindBtn);
    // 审核功能
    checks=function(index) {
        $('#MainGrid').datagrid('selectRow', index);
        var itemGrid = $('#MainGrid').datagrid('getSelected');
        checkFun(itemGrid)                                  
    }

}