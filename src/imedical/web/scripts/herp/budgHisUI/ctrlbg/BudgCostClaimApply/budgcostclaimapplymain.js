/***报销申请主界面
csp:herp.budg.hisui.costclaimapply.csp
cls:herp.budg.hisui.udata.ubudgcostclaimapply
	herp.budg.hisui.common.ComboMethod
***/
var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
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
        },
        onSelect:FindBtn
    });
// }                
// 申请单号的下拉框
    var ApplyCboxObj = $HUI.combobox("#ApplyCbox",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.ubudgcostclaimapply&MethodName=GetBillCode",//+ '&userdr=' + userid+ '&str='+$('#ApplyCbox').combobox('getText'),
        mode:'remote',
        delay:200,
        valueField:'billcode',    
        textField:'billcode',
        onBeforeLoad:function(param){
            param.userdr = userid;
            param.str = param.q;
        },
        onSelect:FindBtn
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
        },
        onSelect:FindBtn
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
        },
        onSelect:FindBtn
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
        },
        onSelect:FindBtn
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
                    'name': "通过"
                },{
                    'rowid': 4,
                    'name': "撤销"
                },{
                    'rowid': 5,
                    'name': "不通过"
                },{
                    'rowid': 6,
                    'name': "完成"               
        }],
        onSelect:FindBtn
     });
    MainColumns=[[  
                // {field:'ck',checkbox:true},//复选框
                {field:'rowid',title:'申请表ID',width:80,hidden: true},
                {field:'CompName',title:'医疗单位',width:80,hidden: true},
                {field:'select',title:'选择',align:'center',width:130,formatter:formatselect},
                {field:'File',title:'附件图片',align:'left',width:120,formatter:formatblue},
                {field:'yearmonth',title:'核算年月',align:'center',width:80},
                {field:'billcode',title:'报销单号',width:130,formatter:formatblue},
                {field:'audeprdr',title:'归口科室ID',align:'left',width:120,hidden: true},
                {field:'audname',title:'归口科室',align:'left',width:120,hidden: true},
                {field:'deprdr',title:'报销科室ID',width:100,hidden: true},
                {field:'dname',title:'报销科室',align:'left',width:120},
                {field:'applyerdr',title:'申请人ID',align:'left',width:100,hidden: true},
                {field:'applyer',title:'申请人',align:'left',width:120},
                {field:'reqpay',title:'报销金额',align:'right',width:120},
                {field:'actpay',title:'审批金额',align:'right',width:120},
                {field:'applydate',title:'申请时间',align:'left',width:150},
                {field:'billstate',title:'单据状态',align:'center',width:70,
                    formatter:function(value,row,index){
                        var rowid=row.rowid;
                        var BillCode="";
                        if (row.billstate == "新建"||row.billstate == "撤销") {
                            return '<a href="#" class="grid-td-text-red" onclick=billstatefun('+rowid+',\'' + BillCode + '\',\'3\')>' + value + '</a>';
                        } else if (row.billstate == "提交") {
                            return '<a href="#" class="grid-td-text" onclick=billstatefun('+rowid+',\'' + BillCode + '\',\'3\')>' + value + '</a>';
                        } else {
                            return '<a href="#" class="grid-td-text-gray" onclick=billstatefun('+rowid+',\'' + BillCode + '\',\'3\')>' + value + '</a>';
                        }                        
                    }
                },
                {field:'applydecl',title:'报销说明',align:'left',width:200},
                {field:'budgetsurplus',title:'审批后结余',align:'right',width:120,hidden: true},
                {field:'budgcotrol',title:'预算控制',align:'center',width:80,
                    styler:function(value,row,index){
                        var sf = row.budgcotrol;
                        if (sf != "预算内") {
                            return 'background-color:#ee4f38;color:white';
                        }
                    }
                },
                {field:'applydr',title:'冲抵借款单ID',align:'left',width:100,hidden: true},
                {field:'applycode',title:'冲抵借款单号',align:'left',width:150,hidden: true},
                {field:'isover',title:'审核结束否',align:'left',width:100,hidden: true},
                {field:'sOver',title:'审批是否完成',align:'left',width:120,hidden: true},
                {field:'ChekFlowId',title:'审批流ID',align:'left',width:100,hidden: true},
                {field:'ChekFlowNa',title:'审批流',align:'left',width:100,hidden: true},
                {field:'CheckDesc',title:'审批意见建议',align:'left',width:100,hidden: true},
                {field:'PayMeth',title:'支付方式',align:'center',width:80,
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
                {field:'ChkSatte',title:'审核状态',align:'center',width:80,hidden: true,
                    formatter:function(value){
                        if (value== 0) {
                            return '没有通过';
                        } 
                        if (value== 1) {
                            return '审批通过';
                        } 
                        if (value== 2) {
                            return '撤销';
                        }
                    }
                },
                {field:'CurStepNO',title:'当前审批号',align:'left',width:120,hidden: true},
                {field:'StepNO',title:'登录人顺序号',align:'left',width:120,hidden: true}

            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.ubudgcostclaimapply",
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
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        striped : true,
        onClickRow: onClickRow,
        onLoadSuccess:function(data){
            if(data){
                $('.SpecialClass').linkbutton({
                    plain:true
                })
                $('#MainGrid').datagrid('getPanel').removeClass('panel-body'); 

            }
        },
        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发
            if ((field=="billcode")) {
                $('#MainGrid').datagrid('selectRow', index);
                var itemGrid = $('#MainGrid').datagrid('getSelected');
                EditFun(itemGrid); 
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
                ClassName:"herp.budg.hisui.udata.ubudgcostclaimapply",
                MethodName:"List",
                hospid :    hospid, 
                userdr :    userid,
                data   :    data
            })
    }
    //单元格加下划线--蓝色
    function formatblue(value,row,index){
        return '<span class="grid-td-text">' + value + '</span>';
    }
    //“选择”列格式化函数
    function formatselect(value,row,index){
        if (row.IsAuth == "1") {
            return '<a href="#" class="SpecialClass" title="提交" data-options="iconCls:\'icon-submit\'" onclick=submits('+index+') ></a>'
	        + '<a href="#" class="icon-gray SpecialClass" title="撤销" data-options="iconCls:\'icon-arrow-left-top\'" onclick=back('+index+') ></a>'
	        + '<a href="#" class="SpecialClass" title="删除" data-options="iconCls:\'icon-cancel\'" onclick=del('+index+')></a>'
	        + '<a href="#" class="SpecialClass" title="附件" data-options="iconCls:\'icon-attachment\'" ></a>';
        } else if (row.billstate == "提交") {
            return '<a href="#" class="icon-gray SpecialClass" title="提交" data-options="iconCls:\'icon-submit\'" onclick=submits('+index+') ></a>'
	        + '<a href="#" class="SpecialClass" title="撤销" data-options="iconCls:\'icon-arrow-left-top\'" onclick=back('+index+') ></a>'
	        + '<a href="#" class="icon-gray SpecialClass" title="删除" data-options="iconCls:\'icon-cancel\'" onclick=del('+index+')></a>'
	        + '<a href="#" class="icon-gray SpecialClass" title="附件" data-options="iconCls:\'icon-attachment\'" ></a>';
        } else {
            return '<a href="#" class="icon-gray SpecialClass" title="提交" data-options="iconCls:\'icon-submit\'" onclick=submits('+index+') ></a>'
	        + '<a href="#" class="icon-gray SpecialClass" title="撤销" data-options="iconCls:\'icon-arrow-left-top\'" onclick=back('+index+') ></a>'
	        + '<a href="#" class="icon-gray SpecialClass" title="删除" data-options="iconCls:\'icon-cancel\'" onclick=del('+index+')></a>'
	        + '<a href="#" class="icon-gray SpecialClass" title="附件" data-options="iconCls:\'icon-attachment\'" ></a>';
        }
    }
    //点击查询按钮 
    $("#FindBn").click(FindBtn);
    //点击新增差旅费报销单窗口
    $("#AddTravelBn").click(function(){
	    CostTravelPage("","","100","1")
	    }
    )
    //点击增加按钮
    $("#AddBn").click(function(){
        //远程数据访问，返回非json格式
        $.m({
            ClassName:'herp.budg.udata.uBudgCtrlFundBillMng',MethodName:'Getcheckdr'},
            function(Data){
                // console.dir(Data);
                var array=Data.split("_");
                if(array[0]!=""){                       
                    addFun(array); //创建报销单窗口
                }                                       
            }
        );
    }) 
    //提交功能
    /**当IsAuth=1（新建、撤销、不通过【第一审核人不通过】）时是可以提交的，否则不可以提交*/
    submits=function (index) {
        onClickRow(index);
        var selectedRow = $('#MainGrid').datagrid("getSelected");
        var rowid = selectedRow.rowid;
        var billstate = selectedRow.billstate;
        if (!(selectedRow.IsAuth==1)) {
            var message="单据已结束或已提交，不允许提交!"
            $.messager.popover({msg: message,type:'alert'});
            return
        }else {
            $.m({
                ClassName:'herp.budg.hisui.udata.ubudgcostclaimapply',MethodName:'submit',userid:userid,rowid:rowid},
                function(Data){
                    if(Data==0){
                        $.messager.popover({msg: '提交成功！',type:'success'});
                        $('#MainGrid').datagrid("reload");
                    }else{
                        $.messager.popover({msg: '错误信息:' +Data,type:'error'});
                    }
                }
            );
            
        }
    }; 
    //撤销功能 
    /**当IsAuth=1（新建、撤销、不通过【第一审核人不通过】）时单据是未提交状态，不可以撤销
    当单据状态billstates == "提交"时可以撤销
    其它情况。。。*/  
    back = function (index) {
        onClickRow(index);
        var selectedRow = $('#MainGrid').datagrid("getSelected");
        var rowid = selectedRow.rowid;
        var billstates = selectedRow.billstate;
        var ChkSatte = selectedRow.ChkSatte;
        var CurStepNO = selectedRow.CurStepNO;
        var StepNO = selectedRow.StepNO;
        var IsAuth=selectedRow.IsAuth;

        if (IsAuth == "1") {
            var message="申请单未提交,不能撤销!";
            $.messager.popover({msg: message,type:'alert'});
            return;
        } else if (billstates == "提交") {
            $.m({
                ClassName:'herp.budg.hisui.udata.ubudgcostclaimapply',MethodName:'backout',userid:userid,rowid:rowid},
                function(Data){
                    if(Data==0){
                        $.messager.popover({msg: '撤销成功！',type:'success'});
                        $('#MainGrid').datagrid("reload");
                    }else{
                        $.messager.popover({msg: '错误信息:' +Data,type:'error'});
                    }
                }
            );            
        } else if ((StepNO >= CurStepNO) && ((StepNO !== "") && (CurStepNO !== ""))) {
            $.m({
                ClassName:'herp.budg.hisui.udata.ubudgcostclaimapply',MethodName:'backout',userid:userid,rowid:rowid},
                function(Data){
                    if(Data==0){
                        $.messager.popover({msg: '撤销成功！',type:'success'});
                    }else{
                        $.messager.popover({msg: '错误信息:' +Data,type:'error'});
                    }
                }
            );
            $('#MainGrid').datagrid("reload");
        } else if (StepNO == "") {
            var message="已审核，不可撤销!"
            $.messager.popover({msg: message,type:'alert'});
            return;
        } else {
            var message="不是当前权限人!"
            $.messager.popover({msg: message,type:'alert'});
            return;
        }
    };
    //删除功能
    del=function (index) {
        onClickRow(index);
        var selectedRow = $('#MainGrid').datagrid("getSelected");
        var rowid = selectedRow.rowid;
        var billstate = selectedRow.billstate;
        if (!(billstate == "新建"||billstate == "撤销")) {
            var message="申请单已提交或审核，不允许删除!"
            $.messager.popover({msg: message,type:'alert'});
            return
        }else {
            $.m({
                ClassName:'herp.budg.hisui.udata.ubudgcostclaimapply',MethodName:'Delete',rowid:rowid},
                function(Data){
                    if(Data==0){
                        $.messager.popover({msg: '删除成功！',type:'success'});
                    }else{
                        $.messager.popover({msg: '错误信息:' +Data,type:'error'});
                    }
                }
            );
            $('#MainGrid').datagrid("reload");
        }
    }; 

}