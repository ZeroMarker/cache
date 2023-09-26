/**
 * 模块:住院药房
 * 子模块:业务查询-退药汇总
 * createdate:2016-12-09
 * creator:dinghongying
 */
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
    InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitPhaLoc();
    InitWardList();
    InitReturnTotalList();
    /* 绑定按钮事件 start*/
    $("#btn-find").on("click", Query);
    $("#btn-clear").on("click", ClearConditions);
    /* 绑定按钮事件 end*/
    ;
    $("#returntotaldg").closest(".panel-body").height(GridCanUseHeight(1));
})


//初始化药品选择
function InitThisLocInci(locrowid) {
    var locincioptions = {
        id: "#sel-locinci",
        locid: locrowid
    }
    InitLocInci(locincioptions)
}
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
    $("#sel-phaloc").append(select2option);
    $('#sel-phaloc').on('select2:select', function (event) {
        InitThisLocInci($(this).val());
    });
}
//初始化病区
function InitWardList() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetWardLocDs&style=select2",
        allowClear: true,
        width: '15em',
        placeholder: "病区..."
    }
    $("#sel-wardloc").dhcphaSelect(selectoption);
}
//初始化退药汇总列表
function InitReturnTotalList() {
    //定义columns
    var columns = [
        [{
                field: "Inci",
                title: 'Inci',
                hidden: true
            },
            {
                field: 'inciCode',
                title: '药品代码',
                width: 100,
                sortable: true
            },
            {
                field: 'inciDesc',
                title: '药品名称',
                width: 250,
                sortable: true
            },
            {
                field: 'retQty',
                title: '退药数量',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'retUomDesc',
                title: '单位',
                width: 80,
                sortable: true
            },
            {
                field: 'sp',
                title: '售价',
                width: 200,
                hidden: true,
                sortable: true
            },
            {
                field: 'spAmt',
                title: '售价金额',
                width: 150,
                align: 'right',
                sortable: true
            },
            {
                field: 'rp',
                title: '进价',
                width: 200,
                hidden: true,
                sortable: true
            },
            {
                field: 'rpAmt',
                title: '进价金额',
                width: 150,
                align: 'right',
                sortable: true
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: true
    }
    //定义datagrid	
    $('#returntotaldg').dhcphaEasyUIGrid(dataGridOption);
}


///查询
function Query() {
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    var inciRowId = $("#sel-locinci").val();
    if (inciRowId == null) {
        inciRowId = ""
    }
    var phaLoc = $("#sel-phaloc").val();
    if (phaLoc == null) {
        dhcphaMsgBox.alert("请选择药房!");
        return;
    }
    var wardLoc = $("#sel-wardloc").val();
    if (wardLoc == null) {
        wardLoc = "";
    }
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaLoc + tmpSplit + wardLoc + tmpSplit + inciRowId;
    $('#returntotaldg').datagrid({
        queryParams: {
            ClassName: "web.DHCSTPHARETURN",
            QueryName: "QueryPhaReturnTotal",
            Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
        }
    });

}

function ClearConditions() {
    $("#sel-wardloc").empty();
    $("#sel-locinci").empty();
    $('#returntotaldg').clearEasyUIGrid();
    var tDate=new Date();
    $("#date-start").data('daterangepicker').setStartDate(tDate);
    $("#date-start").data('daterangepicker').setEndDate(tDate);
    $("#date-end").data('daterangepicker').setStartDate(tDate);
    $("#date-end").data('daterangepicker').setEndDate(tDate);
}