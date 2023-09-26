/**
 * 模块:住院药房
 * 子模块:住院药房药房-发药综合查询-病区发退药统计
 * createdate:2016-12-09
 * creator:xueshuaiyi
 */
var QUERYPID = "";
$(function () {
    /* 初始化插件 start*/
    var daterangeoptions = {
        singleDatePicker: true
    }
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    //屏蔽所有回车事件
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    InitPhaLoc();
    InitGridDispRetMain();
    InitGridDispRetDetail();
    /* 绑定按钮事件 start*/
    $("#btn-find").on("click", Query);
    $("#btn-clear").on("click", ClearConditions);
    /* 绑定按钮事件 end*/
    ;
    $("#grid-dispretmain").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
    $("#grid-dispretdetail").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
})

//初始化科室
function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetStockPhlocDs&style=select2&groupId=" +
            DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: false
    }
    $("#sel-phaloc").dhcphaSelect(selectoption)
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
    $("#sel-phaloc").append(select2option); //设默认值,没想到好办法,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        //alert(event)
    });
}

//初始化退药单列表
function InitGridDispRetMain() {
    //定义columns
    var columns = [
        [{
                field: 'Ward',
                title: '病区',
                width: 150,
                align: 'left',
                sortable: true
            },
            {
                field: 'PhaDispAmt',
                title: '发药金额',
                width: 120,
                align: 'right',
                sortable: true
            },
            {
                field: 'PhaRetAmt',
                title: '退药金额',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'PhaDispSum',
                title: '合计金额',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'ProcessID',
                title: 'ProcessID',
                width: 80,
                align: 'right',
                sortable: true,
                hidden: true
            },
            {
                field: 'WardRowid',
                title: 'WardRowid',
                width: 80,
                align: 'right',
                sortable: true,
                hidden: true
            }
        ]
    ];

    var dataGridOption = {
        //url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        url: "/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.DispRetStat.Display&MethodName=EuiGetWardStat",
        columns: columns,
        fitColumns: true,
        showFooter: true,
        onSelect: function (rowIndex, rowData) {
            QueryDetail();
        },
        onLoadSuccess: function () {
            if ($(this).datagrid("getRows").length > 0) {
                $(this).datagrid("selectRow", 0)
                QUERYPID = $(this).datagrid("getRows")[0].ProcessID;
                $(this).datagrid("options").queryParams.Pid = QUERYPID;
            } else {
                $('#grid-dispretdetail').clearEasyUIGrid();
            }
        }
    }
    //定义datagrid	
    $('#grid-dispretmain').dhcphaEasyUIGrid(dataGridOption);

}

//初始化退药单明细列表
function InitGridDispRetDetail() {
    //定义columns
    var columns = [
        [{
                field: 'RetDate',
                title: '日期',
                width: 100,
                align: 'center'
            },
            {
                field: 'RetTime',
                title: '时间',
                width: 100,
                align: 'center'
            },
            {
                field: 'Code',
                title: '代码',
                width: 120,
                align: 'left'
            },
            {
                field: 'Desc',
                title: '名称',
                width: 300,
                align: 'left'
            },
            {
                field: 'IssueType',
                title: '类型',
                width: 75,
                align: 'center',
                styler: function (value, row, index) {
                    if (value.indexOf("发") >= 0) {
                        return 'background-color:#e3f7ff;color:#1278b8;';
                    } else if (value.indexOf("退") >= 0) {
                        return 'background-color:#ffe3e3;color:#ff3d2c;';
                    }
                }
            },
            {
                field: 'RetQty',
                title: '数量',
                width: 100,
                align: 'right'
            },
            {
                field: 'Uom',
                title: '单位',
                width: 75,
                align: 'left'
            },
            {
                field: 'RetAmt',
                title: '金额',
                width: 100,
                align: 'right'
            },
            {
                field: 'IntrNo',
                title: '业务单号',
                width: 250,
                align: 'left'
            }
        ]
    ];
    var dataGridOption = {
        //url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        url: "/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.DispRetStat.Display&MethodName=EuiGetWardDetail",
        columns: columns,
        fitColumns: false
    }
    //定义datagrid
    $('#grid-dispretdetail').dhcphaEasyUIGrid(dataGridOption);

}
//查询明细
function QueryDetail() {
    var selectdata = $("#grid-dispretmain").datagrid("getSelected")
    if (selectdata == null) {
        dhcphaMsgBox.alert("选中数据异常!");
        return;
    }
    var wardrowid = selectdata["WardRowid"]
    var processid = selectdata["ProcessID"]
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = processid + tmpSplit + wardrowid
    $('#grid-dispretdetail').datagrid({
        queryParams: {
            Pid: processid,
            WardLocId: wardrowid
        }
    });
}
///病区发退药汇总查询
function Query() {
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    var phaloc = $('#sel-phaloc').select2("data")[0];
    var phaloc = $('#sel-phaloc').select2("data")[0].id;
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaloc;
    KillTmpGloal();
    $('#grid-dispretmain').datagrid({
        queryParams: {
            InputStr: params,
            Pid: ""
        }
    });

}

//清空
function ClearConditions() {
    var tDate = new Date();
    $("#date-start").data('daterangepicker').setStartDate(tDate);
    $("#date-start").data('daterangepicker').setEndDate(tDate);
    $("#date-end").data('daterangepicker').setStartDate(tDate);
    $("#date-end").data('daterangepicker').setEndDate(tDate);
    KillTmpGloal();
    $('#grid-dispretmain').clearEasyUIGrid();
    $('#grid-dispretdetail').clearEasyUIGrid();
}

// 清除临时global
function KillTmpGloal() {
    tkMakeServerCall("web.DHCINPHA.DispRetStat.Global", "Kill", QUERYPID);
}

window.onbeforeunload = function () {
    KillTmpGloal();
}