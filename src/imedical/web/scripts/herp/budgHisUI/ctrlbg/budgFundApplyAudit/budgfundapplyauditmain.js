var userid = session['LOGON.USERID'];
var hospid = session['LOGON.HOSPID'];
$(function () { //初始化
    Init();
});

function Init() {
	
    var YMboxObj = $HUI.combobox("#YMbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode: 'remote',
        delay: 200,
        valueField: 'year',
        textField: 'year',
        onBeforeLoad: function (param) {
            param.flag = 1;
            param.str = param.q;
        },
        onSelect:FindBtn,
    });
    // }                
    // 申请单号的下拉框
    var ApplyCboxObj = $HUI.combobox("#ApplyCbox", {
        url: $URL + "?ClassName=herp.budg.hisui.udata.ubudgAuditFundApply&MethodName=BillCodeList",
        mode: 'remote',
        delay: 200,
        valueField: 'billcode',
        textField: 'billcode',
        onBeforeLoad: function (param) {
            param.userdr = userid;
            param.str = param.q;
        },
        onSelect:FindBtn,
    });
    // 申请人的下拉框
    var ApplyerObj = $HUI.combobox("#Applyerbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
        mode: 'remote',
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onSelect:FindBtn,
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.userdr = userid;
            param.str = param.q;
        }
    });
    // 归口科室的下拉框
    var OwnDeptboxObj = $HUI.combobox("#OwnDeptbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode: 'remote',
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onSelect:FindBtn,
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.userdr = userid;
            param.flag = 1;
            param.str = param.q;
        }
    });

    // 申请科室的下拉框
    var ApplyDboxObj = $HUI.combobox("#ApplyDbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode: 'remote',
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onSelect:FindBtn,
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.userdr = userid;
            param.flag = 1;
            param.str = param.q;
        }
    });
    // 单据状态的下拉框
    var StateboxObj = $HUI.combobox("#Statebox", {
        mode: 'local',
        valueField: 'rowid',
        textField: 'name',
        onSelect:FindBtn,
        data: [{
            'rowid': 1,
            'name': "新建"
        }, {
            'rowid': 2,
            'name': "提交"
        }, {
            'rowid': 3,
            'name': "通过"
        }, {
            'rowid': 4,
            'name': "撤销"
        }, {
            'rowid': 5,
            'name': "不通过"
        }, {
            'rowid': 6,
            'name': "完成"
        }]
    });
    MainColumns = [
        [{
                field: 'rowid',
                title: '申请表ID',
                width: 80,
                hidden: true
            },
            {
                field: 'CompName',
                title: '医疗单位',
                width: 80,
                hidden: true
            },
            {
                field: 'select',
                title: '选择',
                width: 50,
                formatter: formatselect
            },
            {
                field: 'filedesc',
                title: '附件',
                align: 'left',
                width: 120,
                formatter: formatblue
            },
            {
                field: 'YearMonth',
                title: '年月',
                align: 'left',
                width: 80
            },
            {
                field: 'BillCode',
                title: '申请单号',
                align: 'left',
                width: 150,
                formatter: formatblue
            },
            {
                field: 'audname',
                title: '归口科室',
                align: 'left',
                width: 120,
                hidden: true
            },
            {
                field: 'audeprdr',
                title: '归口科室dr',
                align: 'left',
                width: 120,
                hidden: true
            },
            {
                field: 'deptID',
                title: '申请科室ID',
                width: 100,
                hidden: true
            },
            {
                field: 'Dept',
                title: '申请科室',
                align: 'left',
                width: 120
            },
            {
                field: 'UserDR',
                title: '申请人ID',
                align: 'left',
                width: 100,
                hidden: true
            },
            {
                field: 'User',
                title: '申请人',
                align: 'left',
                width: 120
            },
            {
                field: 'ReqPay',
                title: '申请额度',
                align: 'right',
                width: 120
            },
            {
                field: 'ReqPayRes',
                title: '审批额度',
                align: 'right',
                width: 120
            },
            {
                field: 'BillDate',
                title: '申请时间',
                align: 'left',
                width: 150
            },
            {
                field: 'BillState',
                title: '单据状态',
                align: 'center',
                width: 80,
                formatter: function (value, row, index) {
                    var rowid = row.rowid;
                    var BillCode = row.BillCode;
                    if (row.BillState == "新建"||(row.BillState == "待审")) {
                        return '<a href="#" class="grid-td-text-red" onclick=billstatefun(' + rowid + ',\'' + BillCode + '\',\'4\')>' + value + '</a>';
                    } else if (row.BillState == "提交") {
                        return '<a href="#" class="grid-td-text" onclick=billstatefun(' + rowid + ',\'' + BillCode + '\',\'4\')>' + value + '</a>';
                    } else {
                        return '<a href="#" class="grid-td-text-gray" onclick=billstatefun(' + rowid + ',\'' + BillCode + '\',\'4\')>' + value + '</a>';
                    }
                },
            },
            {
                field: 'Desc',
                title: '资金申请说明',
                align: 'left',
                width: 200
            },
            {
                field: 'BudgBal',
                title: '审批后结余',
                align: 'right',
                width: 120
            },
            {
                field: 'budgcotrol',
                title: '预算控制',
                align: 'left',
                width: 80,
                styler: function (value, row, index) {
                    var sf = row.budgcotrol;
                    if (sf != "预算内") {
                        return 'background-color:#ee4f38;color:white';
                    }
                }
            },
            {
                field: 'Checkdr',
                title: '审批流ID',
                align: 'left',
                width: 100,
                hidden: true
            },
            {
                field: 'CheckDR',
                title: '审批流名称',
                align: 'left',
                width: 100,
                hidden: true
            },
            {
                field: 'ChkStep',
                title: '当前审核步骤',
                align: 'left',
                width: 120,
                hidden: true
            },
            {
                field: 'StepNOC',
                title: '当前审批顺序号',
                align: 'left',
                width: 120,
                hidden: true
            },
            /*{
                field: 'StepNOF',
                title: '审批顺序号',
                align: 'left',
                width: 120,
                hidden: true
            },*/
            {
                field: 'IsCurStep',
                title: '是否当前审批',
                align: 'left',
                width: 100,
                hidden: true
            },
            {
                field: 'ChkResult1',
                title: '审核状态',
                align: 'left',
                width: 100,
                hidden: true
            },
            {
                field: 'ChkResult',
                title: '审核状态',
                align: 'left',
                width: 120,
                hidden: true
            },
            {
                field: 'PayMeth',
                title: '支付方式',
                align: 'center',
                width: 80,
                formatter: function (value) {
                    if (value == 1) {
                        return '现金';
                    }
                    if (value == 2) {
                        return '银行';
                    }
                }
            },
            {
                field: 'BKName',
                title: '开户行名称',
                align: 'left',
                width: 120
            },
            {
                field: 'BKCardNo',
                title: '银行卡号',
                align: 'left',
                width: 150
            },
            {
                field: 'CheckNo',
                title: '支票号',
                align: 'left',
                width: 100
            },
            {
                field: 'CheckDate',
                title: '支票发放日期',
                align: 'left',
                width: 120
            },
            {
                field: 'CheckUDR',
                title: '发放人',
                align: 'left',
                width: 100
            }
        ]
    ];
    var MainGridObj = $HUI.datagrid("#MainGrid", {
        url: $URL,
        queryParams: {
            ClassName: "herp.budg.hisui.udata.ubudgAuditFundApply",
            MethodName: "List",
            hospid: hospid,
            userdr: userid,
            data: ""
        },
        fitColumns: false, //列固定
        loadMsg: "正在加载，请稍等…",
        autoRowHeight: true,
        singleSelect: true,
        rownumbers: true, //行号
        singleSelect: true, //只允许选中一行
        pageSize: 20,
        pageList: [10, 20, 30, 50, 100], //页面大小选择列表
        pagination: true, //分页
        fit: true,
        idField: 'rowid',
        columns: MainColumns,
        onClickRow: onClickRow, //在用户点击一行的时候触发
        striped: true,
        onLoadSuccess: function (data) {
            if (data) {
                $('.SpecialClass').linkbutton({
                    plain: true
                })
                $('#MainGrid').datagrid('getPanel').removeClass('panel-body');
            }
        },
        onClickCell: function (index, field, value) { //在用户点击一个单元格的时候触发
            if ((field == "BillCode")) {
                $('#MainGrid').datagrid('selectRow', index);
                var mainRow = $('#MainGrid').datagrid('getSelected');
                EditFun(mainRow, 1);
            }
        },
        toolbar: '#tb'
    });

    //点击一行时触发。
    function onClickRow(index) {
        $('#MainGrid').datagrid('selectRow', index);
    }
    //查询函数
    function FindBtn() {
        var yearmonth = $('#YMbox').combobox('getValue'); // 申请年月
        var billcode = $('#ApplyCbox').combobox('getValue'); // 单据单号
        var Applyer = $('#Applyerbox').combobox('getValue'); // 申请人
        var OwnDept = $('#OwnDeptbox').combobox('getValue'); // 归口科室
        var ApplyD = $('#ApplyDbox').combobox('getValue'); // 申请科室
        var State = $('#Statebox').combobox('getValue'); // 单据状态
        if (State == undefined) {
            State = "";
        }
        var StPrice = $('#StPricebox').val(); // 审批金额范围-最小值
        var EdPrice = $('#EdPricebox').val(); // 审批金额范围-最大值
        var data = yearmonth + "^" + billcode + "^" + Applyer + "^" + OwnDept + "^" + ApplyD + "^" + State + "^" + StPrice + "^" + EdPrice;
        // alert(data)
        MainGridObj.load({
            ClassName: "herp.budg.hisui.udata.ubudgAuditFundApply",
            MethodName: "List",
            hospid: hospid,
            userdr: userid,
            data: data
        })
    }
    //单元格加下划线--绿色
    function formatblue(value, row, index) {
        return '<span class="grid-td-text">' + value + '</span>';
    }
    //“选择”列格式化函数
    function formatselect(value, row, index) {
        return '<a href="#" class="SpecialClass" title="审核" data-options="iconCls:\'icon-stamp\'" onclick=checks(' + index + ')></a>'
    }
    //点击查询按钮 
    $("#FindBn").click(FindBtn);
    // 审核功能
    checks = function (index) {
        $('#MainGrid').datagrid('selectRow', index);
        var itemGrid = $('#MainGrid').datagrid('getSelected');
        checkFun(itemGrid)
    }

}