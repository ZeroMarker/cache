/*
 *模块:住院药房
 *子模块:业务查询-病区发药特定查询
 *createdate:2016-12-15
 *creator:xueshuaiyi
 */
DHCPHA_CONSTANT.VAR.NEWPHACCAT = "";
var QUERYPID = "";
$(function () {
    var daterangeoptions = {
        timePicker: true,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + " HH:mm:ss"
        }
    }
    /* 初始化插件 start*/
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    var tDate = FormatDateT("T");
    $("#date-start").data('daterangepicker').setStartDate(tDate + " " + "00:00:00");
    $("#date-start").data('daterangepicker').setEndDate(tDate + " " + "00:00:00");
    $("#date-end").data('daterangepicker').setStartDate(tDate + " " + "23:59:59");
    $("#date-end").data('daterangepicker').setEndDate(tDate + " " + "23:59:59");
    //屏蔽所有回车事件
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    InitPhaLoc();
    InitPhaWard(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitDispCat(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitPoisonCat();
    InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitWardQueryList();
    //登记号回车事件
    $('#txt-patno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#txt-patno").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                Query();
            }
        }
    });
    /* 绑定按钮事件 start*/
    $("#btn-find").on("click", Query);
    $("#btn-clear").on("click", ClearConditions);
    /* 绑定按钮事件 end*/
    ;
    $("#wardquerygrid").closest(".panel-body").height(GridCanUseHeight(1));
})


//初始化药品选择
function InitThisLocInci(locrowid) {
    var locincioptions = {
        id: "#sel-locinci",
        locid: locrowid,
        width: "390px"
    }
    InitLocInci(locincioptions)
}
//初始化科室
function InitPhaLoc() {
    var selectoption = {
        minimumResultsForSearch: Infinity,
        allowClear: false,
        width: '15em',
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetStockPhlocDs&style=select2&groupId=" +
            DHCPHA_CONSTANT.SESSION.GROUP_ROWID
    }
    $("#sel-phaloc").dhcphaSelect(selectoption)
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
    $("#sel-phaloc").append(select2option); //设默认值,没想到好办法,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        $("#sel-locinci").empty();
        InitThisLocInci($(this).val());
        InitDispCat($(this).val());
        $("#sel-phaward").empty();
        InitPhaWard($(this).val());
    });
}
//初始化病区
function InitPhaWard(locid) {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetWardLocDsByRecLoc&style=select2"+"&reclocId="+ locid,
        placeholder: "病区...",
        width: '15em'
    }
    $("#sel-phaward").dhcphaSelect(selectoption)
}
//初始化发药类别
function InitDispCat(locrowid) {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetLocDispTypeDs&style=select2&locId=" + locrowid,
        placeholder: "发药类别...",
        minimumResultsForSearch: Infinity
        //multiple: true	
    }
    $("#sel-dispcat").dhcphaSelect(selectoption)
}
//初始化管制分类
function InitPoisonCat() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
            "?action=GetPoisonCatDs&style=select2",
        allowClear: true,
        placeholder: "管制分类...",
        minimumResultsForSearch: Infinity
    }
    $("#sel-poison").dhcphaSelect(selectoption)
    $('#sel-poison').on('select2:select', function (event) {
        //alert(event)
    });
}
//初始化发药查询列表
function InitWardQueryList() {
    //定义columns
    var columns = [
        [{
                field: 'patNo',
                title: '登记号',
                width: 100,
                align: 'left'
            },
            {
                field: 'patName',
                title: '姓名',
                width: 100,
                align: 'left'
            },
            {
                field: 'incCode',
                title: '药品代码',
                width: 100,
                align: 'left'
            },
            {
                field: 'incDesc',
                title: '药品名称',
                width: 250,
                align: 'left'
            },
            {
                field: 'qty',
                title: '数量',
                width: 80,
                align: 'right',
                sortable: false
            },
            {
                field: 'uomDesc',
                title: '单位',
                width: 50,
                align: 'left'
            },
            {
                field: 'spAmt',
                title: '金额',
                width: 70,
                align: 'right'
            },
            {
                field: 'pid',
                title: '进程号',
                width: 70,
                hidden: true
            }

        ]
    ];

    var dataGridOption = {
        url: "/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.WardIncStat.Display&MethodName=EuiGetWardPatInc",
        columns: columns,
        fitColumns: true,
        showFooter: true,
        onLoadSuccess: function () {
            if ($(this).datagrid("getRows").length > 0) {
                $(this).datagrid("selectRow", 0)
                QUERYPID = $(this).datagrid("getRows")[0].pid;
                $(this).datagrid("options").queryParams.Pid = QUERYPID;
            }
        }
    }
    //定义datagrid	
    $('#wardquerygrid').dhcphaEasyUIGrid(dataGridOption);
}


///查询
function Query() {
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaloc = $("#sel-phaloc").val();
    var patno = $("#txt-patno").val();
    var patname = $("#txt-name").val();
    var ward = $("#sel-phaward").val();
    if (ward == null) {
        dhcphaMsgBox.alert("病区不能为空！");
        return;
    }
    var incirowid = $("#sel-locinci").val();
    if (incirowid == null) {
        incirowid = "";
    }
    var dispcat = $("#sel-dispcat").val();
    if (dispcat == null) {
        dispcat = "";
    }
    var poisonrowid = $("#sel-poison").val();
    if (poisonrowid == null) {
        poisonrowid = "";
    }
    KillTmpGloal();
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + starttime + tmpSplit + endtime + tmpSplit + incirowid +
        tmpSplit + patno + tmpSplit + ward + tmpSplit + phaloc + tmpSplit + dispcat + tmpSplit + poisonrowid +
        tmpSplit + patname
    $('#wardquerygrid').datagrid({
        queryParams: {
            InputStr: params,
            Pid: ""
        }
    });
}

//清空
function ClearConditions() {
    KillTmpGloal();
    var tDate = FormatDateT("T");
    $("#date-start").data('daterangepicker').setStartDate(tDate + " " + "00:00:00");
    $("#date-start").data('daterangepicker').setEndDate(tDate + " " + "00:00:00");
    $("#date-end").data('daterangepicker').setStartDate(tDate + " " + "23:59:59");
    $("#date-end").data('daterangepicker').setEndDate(tDate + " " + "23:59:59");
    $("#txt-name").val("");
    $("#txt-patno").val("");
    $("#sel-locinci").empty();
    $("#sel-poison").empty();
    $("#sel-phaward").empty();
    $("#sel-dispcat").empty();
    $('#wardquerygrid').clearEasyUIGrid();
}

// 清除临时global
function KillTmpGloal() {
    tkMakeServerCall("web.DHCINPHA.WardIncStat.Global", "Kill", QUERYPID);
}

window.onbeforeunload = function () {
    KillTmpGloal();
}