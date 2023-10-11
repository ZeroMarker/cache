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
        onSelect:FindBtn
    });
    // }                
    // 申请单号的下拉框
    var ApplyCboxObj = $HUI.combobox("#ApplyCbox", {
        url: $URL + "?ClassName=herp.budg.hisui.udata.uBudgCtrlPrePay&MethodName=GetBillCode",
        mode: 'remote',
        delay: 200,
        valueField: 'billcode',
        textField: 'billcode',
        onBeforeLoad: function (param) {
            param.userdr = userid;
            param.str = param.q;
        },
        onSelect:FindBtn
    });
    // 申请人的下拉框
    var ApplyerObj = $HUI.combobox("#Applyerbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
        mode: 'remote',
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.userdr = userid;
            param.str = param.q;
        },
        onSelect:FindBtn
    });
    // 归口科室的下拉框
    var OwnDeptboxObj = $HUI.combobox("#OwnDeptbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode: 'remote',
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.userdr = userid;
            param.flag = 1;
            param.str = param.q;
        },
        onSelect:FindBtn
    });

    // 申请科室的下拉框
    var ApplyDboxObj = $HUI.combobox("#ApplyDbox", {
        url: $URL + "?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode: 'remote',
        delay: 200,
        valueField: 'rowid',
        textField: 'name',
        onBeforeLoad: function (param) {
            param.hospid = hospid;
            param.userdr = userid;
            param.flag = 1;
            param.str = param.q;
        },
        onSelect:FindBtn
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
                title: 'ID',
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
                align: 'center',
                width: 130,
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
                width: 140,
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
                field: 'dName',
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
                field: 'uName',
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
                width: 70,
                formatter: function (value, row, index) {
                    var rowid = row.rowid;
                    var BillCode = row.BillCode;
                    if (row.BillState == "新建" || (row.BillState == "待审")) {
                        return '<a href="#" class="grid-td-text-red" onclick=billstatefun(' + rowid + ',\'' + BillCode + '\',\'5\')>' + value + '</a>';
                    } else if (row.BillState == "提交") {
                        return '<a href="#" class="grid-td-text" onclick=billstatefun(' + rowid + ',\'' + BillCode + '\',\'5\')>' + value + '</a>';
                    } else {
                        return '<a href="#" class="grid-td-text-gray" onclick=billstatefun(' + rowid + ',\'' + BillCode + '\',\'5\')>' + value + '</a>';
                    }
                }
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
                align: 'center',
                width: 80,
                styler: function (value, row, index) {
                    var sf = row.budgcotrol;
                    if (sf != "预算内") {
                        return 'background-color:#ee4f38;color:white';
                    }
                }
            },
            {
                field: 'sOver',
                title: '审核过程',
                align: 'left',
                width: 120,
                hidden: true
            },
            {
                field: 'Checkid',
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
                field: 'ChkSatte',
                title: '审核状态',
                align: 'left',
                width: 120,
                hidden: true
            },
            {
                field: 'CurStepNO',
                title: '当前审批号',
                align: 'left',
                width: 120,
                hidden: true
            },
            {
                field: 'StepNO',
                title: '登录人顺序号',
                align: 'left',
                width: 120,
                hidden: true
            },
            {
                field: 'CheckDesc',
                title: '审批意见建议',
                align: 'left',
                width: 100,
                hidden: true
            }
        ]
    ];
    var MainGridObj = $HUI.datagrid("#MainGrid", {
        url: $URL,
        queryParams: {
            ClassName: "herp.budg.hisui.udata.uBudgCtrlPrePay",
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
                EditFun(mainRow, 0);
            }
        },
        striped: true,
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
            ClassName: "herp.budg.hisui.udata.uBudgCtrlPrePay",
            MethodName: "List",
            hospid: hospid,
            userdr: userid,
            data: data
        })
    }
    //增加按钮
    $("#AddBn").click(function () {
        addFun(); //创建报销单窗口

    })
    //单元格加下划线--蓝色
    function formatblue(value, row, index) {
        return '<span class="grid-td-text">' + value + '</span>';
    }
    //“选择”列格式化函数
    function formatselect(value, row, index) {
        return '<a href="#" id="aa" class="SpecialClass" title="提交" data-options="iconCls:\'icon-submit\'" onclick=submits(' + index + ') ></a>' +
            '<a href="#" class="SpecialClass" title="撤销" data-options="iconCls:\'icon-arrow-left-top\'" onclick=back(' + index + ') ></a>' +
            '<a href="#"  class="SpecialClass" title="删除" data-options="iconCls:\'icon-cancel\'" onclick=del(' + index + ')></a>' +
            '<a href="#"  class="SpecialClass" title="附件" data-options="iconCls:\'icon-attachment\'" ></a>'
    }
    //点击查询按钮 
    $("#FindBn").click(FindBtn);
	//$("#aa").addClass("grayscale");
    //提交功能
    submits = function (index) {
        onClickRow(index);
        var selectedRow = $('#MainGrid').datagrid("getSelected");
        var billid = selectedRow.rowid;
        var BillState = selectedRow.BillState;
        if (BillState != "撤销" && (BillState != "新建")) {
            var message = "该单据不可提交!"
            $.messager.popover({
                msg: message,
                type: 'alert',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 1
                }
            });
            return
        } else {
            $.messager.confirm('提示', '提交后不可再编辑，是否提交？', function (r) {
                if (r) {
                    //console.log(billid, selectedRow.YearMonth, selectedRow.Checkid, userid);
                    $.m({
                            ClassName: 'herp.budg.hisui.udata.uBudgCtrlPrePay',
                            MethodName: 'prePaySubmit',
                            billid: billid,
                            yearMonth: selectedRow.YearMonth,
                            checkFlowMainDr: selectedRow.Checkid,
                            userid: userid
                        },

                        function (Data) {
                            if (Data == 0) {
                                $.messager.popover({
                                    msg: '提交成功！',
                                    type: 'success',
                                    style: {
                                        "position": "absolute",
                                        "z-index": "9999",
                                        left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                        top: 1
                                    }
                                });
                            } else {
                                $.messager.popover({
                                    msg: '错误信息:' + Data,
                                    type: 'error',
                                    style: {
                                        "position": "absolute",
                                        "z-index": "9999",
                                        left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                        top: 1
                                    }
                                });
                            }
                        }
                    );
                    $('#MainGrid').datagrid("reload");
                    $("#MainGrid").datagrid("selectRecord",billid);
                }
            });
        }
    };
    //撤销功能   
    back = function (index) {
        onClickRow(index);
        var selectedRow = $('#MainGrid').datagrid("getSelected");
        var billid = selectedRow.rowid;
        var BillState = selectedRow.BillState;
        if (BillState == "撤销" || (BillState == "完成") || (BillState == "新建")) {
            var message = "该申请单不能撤销!"
            $.messager.popover({
                msg: message,
                type: 'alert',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 1
                }
            });
            return;

        } else {
            $.m({
                    ClassName: 'herp.budg.hisui.udata.uBudgCtrlPrePay',
                    MethodName: 'getCheckStep',
                    BillDR: billid,
                    Chercker: userid
                },
                function (Data) {
                    var arr = Data.split(",");
                    //console.log(arr);
                    if (arr[0] != 1) {
                        //console.log(arr[1]);
                        var message = "该申请单不能撤销!"
                        $.messager.popover({
                            msg: message,
                            type: 'alert',
                            style: {
                                "position": "absolute",
                                "z-index": "9999",
                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                top: 1
                            }
                        });
                        return;
                    }
                    if ((arr[1] == 1) && (BillState != "提交")) {
                        var message = "该申请单不能撤销!"
                        $.messager.popover({
                            msg: message,
                            type: 'alert',
                            style: {
                                "position": "absolute",
                                "z-index": "9999",
                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                top: 1
                            }
                        });
                        return;
                    }

                    $.messager.confirm('提示', '是否撤销？', function (r) {
                        if (r) {
                            $.m({
                                    ClassName: 'herp.budg.hisui.udata.uBudgCtrlPrePay',
                                    MethodName: 'prePayBack',
                                    billid: billid,
                                    yearMonth: selectedRow.YearMonth,
                                    checkFlowMainDr: selectedRow.Checkid,
                                    userid: userid
                                },
                                function (Data) {
                                    if (Data == 0) {
                                        $.messager.popover({
                                            msg: '撤销成功！',
                                            type: 'success',
                                            style: {
                                                "position": "absolute",
                                                "z-index": "9999",
                                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                                top: 1
                                            }
                                        });
                                    } else {
                                        $.messager.popover({
                                            msg: '错误信息:' + Data,
                                            type: 'error',
                                            style: {
                                                "position": "absolute",
                                                "z-index": "9999",
                                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                                top: 1
                                            }
                                        });
                                    }
                                }
                            );
                            $('#MainGrid').datagrid("reload");
                            $("#MainGrid").datagrid("selectRecord",billid);
                        }
                    });
                })
        }
    };
    //删除功能
    del = function (index) {
        onClickRow(index);
        var selectedRow = $('#MainGrid').datagrid("getSelected");
        var rowid = selectedRow.rowid;
        var BillState = selectedRow.BillState;
        sig = 1; //  标记是否级联删除明细表
        //console.log(BillState)
        if (BillState != "新建" && (BillState != "撤销")) {
            var message = "申请单已提交或审核，不允许删除!"
            $.messager.popover({
                msg: message,
                type: 'alert',
                style: {
                    "position": "absolute",
                    "z-index": "9999",
                    left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                    top: 1
                }
            });
            return
        } else {
            $.messager.confirm('提示', '是否删除？', function (r) {
                if (r) {
                    var sig = 0;
                    $.messager.confirm('提示', '是否级联删除明细表信息', function (r) {
                        if (r) {
                            sig = 1; //  标记是否级联删除明细表
                            $.m({
                                    ClassName: 'herp.budg.hisui.udata.uBudgCtrlPrePay',
                                    MethodName: 'delPrePay',
                                    rowid: rowid,
                                    sig: sig
                                },
                                function (Data) {
                                    if (Data == 0) {
                                        $.messager.popover({
                                            msg: '删除成功！',
                                            type: 'success',
                                            style: {
                                                "position": "absolute",
                                                "z-index": "9999",
                                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                                top: 1
                                            }
                                        });
                                    } else {
                                        $.messager.popover({
                                            msg: '错误信息:' + Data,
                                            type: 'error',
                                            style: {
                                                "position": "absolute",
                                                "z-index": "9999",
                                                left: -document.body.scrollTop - document.documentElement.scrollTop / 2,
                                                top: 1
                                            }
                                        });
                                    }
                                }
                            );
                            $('#MainGrid').datagrid("reload");
                            
                        }
                    });
                }
            });

        }
    };

}