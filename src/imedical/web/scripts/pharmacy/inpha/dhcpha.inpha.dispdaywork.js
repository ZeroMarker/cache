/*
 *模块:住院药房
 *子模块:业务查询-发药查询-发药工作量统计
 *createdate:2016-12-13
 *creator:dinghongying
 */
$(function () {
    /* 初始化插件 start*/
    var daterangeoptions = {
        singleDatePicker: true
    };
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    //屏蔽所有回车事件
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    InitPhaLoc();
    InitStatType();
    InitDispDayWorkList();
    /* 绑定按钮事件 start*/
    $("#btn-find").on("click", Query);
    /* 绑定按钮事件 end*/
    ;
    $("#dispdayworkdg").closest(".panel-body").height(GridCanUseHeight(1));
})


//初始化药房
function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetStockPhlocDs&style=select2&groupId=" +
            DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: false
    }
    $("#sel-phaloc").dhcphaSelect(selectoption);
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
    $("#sel-phaloc").append(select2option); //设默认值,没想到好办法,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        //alert(event)
    });
}

//初始化统计方式
function InitStatType() {
    var data = [{
            id: 1,
            text: '按人员统计'
        },
        {
            id: 2,
            text: '按病区统计'
        }
    ];
    var selectoption = {
        data: data,
        width: '8.5em',
        allowClear: false,
        minimumResultsForSearch: Infinity
    };
    $("#sel-stattype").dhcphaSelect(selectoption);
    $('#sel-stattype').on('select2:select', function (event) {
        Query();
    })

}
//初始化发药工作量列表
function InitDispDayWorkList() {
    //定义columns
    var columns = [
        [{
                field: "UserCode",
                title: '发药人工号',
                width: 100,
                sortable: true
            },
            {
                field: 'UserName',
                title: '发药人姓名/病区',
                width: 140,
                sortable: true
            },
            {
                field: 'Work',
                title: '发药品种(次)统计',
                width: 110,
                align: 'right',
                sortable: true
            },
            {
                field: 'DispAmt',
                title: '发药金额合计',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'Quenum',
                title: '处方张数',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'Quefacnum',
                title: '处方剂数',
                width: 75,
                align: 'right',
                sortable: true
            },
            {
                field: 'FacSum',
                title: '代煎剂数',
                width: 75,
                align: 'right',
                sortable: true
            },
            {
                field: 'FacSum1',
                title: '代煎处方张数',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'Ws',
                title: '味数',
                width: 50,
                align: 'right',
                sortable: true
            },
            {
                field: "RetNum",
                title: '退药品种(次)统计',
                width: 110,
                align: 'right',
                sortable: true
            },
            {
                field: 'RetAmt',
                title: '退药金额合计',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'RetQue',
                title: '退药处方张数',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'RetFac',
                title: '退药处方剂数',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'OutQue',
                title: '出院带药处方张数',
                width: 120,
                align: 'right',
                sortable: true
            },
            {
                field: 'OutFac',
                title: '出院带药剂数',
                width: 110,
                align: 'right',
                sortable: true
            },
            {
                field: 'OutQueAmt',
                title: '出院带药处方金额',
                width: 150,
                align: 'right',
                sortable: true
            },
            {
                field: 'AmtTotal',
                title: '合计金额',
                width: 100,
                align: 'right',
                sortable: true
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: false
    }
    //定义datagrid	
    $('#dispdayworkdg').dhcphaEasyUIGrid(dataGridOption);
}

///查询
function Query() {
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    var phaLoc = $("#sel-phaloc").val();
    if (phaLoc == null) {
        dhcphaMsgBox.alert("请选择科室!");
        return;
    }
    var statType = $("#sel-stattype").val();
    if (statType == null) {
        statType = "";
    }
    var chkSecUser = "0";
    if ($("#chk-secuser").is(':checked')) {
        chkSecUser = "on";
    }
    if ((chkSecUser == "on") && (statType == 2)) {
        dhcphaMsgBox.alert("按病区选择无法按第二发药人统计,请您确认查询条件!");
        return;
    }
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaLoc + tmpSplit + statType + tmpSplit + chkSecUser;
    $('#dispdayworkdg').datagrid({
        queryParams: {
            ClassName: "web.DHCSTDISPSTAT",
            QueryName: "WorkStat",
            Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
        }
    });

}