/**
 * 模块:住院药房
 * 子模块:住院已发药查询
 * createdate:2017-02-20
 * creator:dinghongying
 */
$(function () {
    /* 初始化插件 start*/
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
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    var stdatetime = FormatDateT("T") + " " + "00:00:00"
    var eddatetime = FormatDateT("T") + " " + "23:59:59"
    $("#date-start").data('daterangepicker').setStartDate(stdatetime);
    $("#date-start").data('daterangepicker').setEndDate(stdatetime);
    $("#date-end").data('daterangepicker').setStartDate(eddatetime);
    $("#date-end").data('daterangepicker').setEndDate(eddatetime);
    //屏蔽所有回车事件
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    InitPhaLoc();
    InitDocLoc();
    InitDispType();
    InitPhaWard();
    InitFyUser();
    InitDispWardList();
    InitDispMainList();
    InitDispDetailList();
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
    $("#btn-findselect").on("click", QuerySub);
    $("#btn-clear").on("click", ClearConditions);
    $("#a-change").on("click", ChangeDispQuery);
    $("#btn-print").on("click", PrintInDisp);
    /* 绑定按钮事件 end*/
    ;
    $("#chk-longord").on("ifClicked", function () {
        if ($(this).is(':checked')) {
            $(this).iCheck('uncheck');
        } else {
            $(this).iCheck('check');
        }
        if ($(this).is(':checked')) {
            $("#chk-shortord").iCheck('uncheck');
        }
    })
    $("#chk-shortord").on("ifClicked", function () {
        if ($(this).is(':checked')) {
            $(this).iCheck('uncheck');
        } else {
            $(this).iCheck('check');
        }
        if ($(this).is(':checked')) {
            $("#chk-longord").iCheck('uncheck');
        }
    })
    ResizeDispQuery()
    $("#div-detail").hide();
})

// 初始化药房
function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetStockPhlocDs&style=select2&groupId=" +
            DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: false,
        placeholder: '药房...'
    }
    $("#sel-phaloc").dhcphaSelect(selectoption)
    $('#sel-phaloc').on('select2:select', function (event) {
        InitDispType(event.params.data.id);
		InitPhaWard(event.params.data.id)
    });
    if (DHCPHA_CONSTANT.SESSION.GWARD_ROWID == "") {
    	var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
        $("#sel-phaloc").append(select2option);
    }
}
// 初始化医生科室
function InitDocLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
            "?action=GetCtLocDs&style=select2&custtype=DocLoc",
        allowClear: true,
        placeholder: '医生科室...'
    }
    $("#sel-docloc").dhcphaSelect(selectoption)
    $('#sel-docloc').on('select2:select', function (event) {
        //alert(event)
    });
}

//初始化发药类别
function InitDispType(recLocId) {
    if ((recLocId == undefined) || (recLocId == "undefined")) {
        recLocId = "";
    }
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetLocDispTypeDs&style=select2&locId=" +
            ((recLocId != "") ? recLocId : DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID),
        allowClear: true,
        multiple: false,
        minimumResultsForSearch: Infinity,
        //maximumSelectionLength: 3,  // 最多可选择项目数
        placeholder: "发药类别..."
    }
    $("#sel-disptype").dhcphaSelect(selectoption)
    $('#sel-disptype').on('select2:select', function (event) {
        //alert(event)
    });
}

//初始化发药人
function InitFyUser() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetInPhaUser&locId=" +
            DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "&groupId=" + DHCPHA_CONSTANT.SESSION.GROUP_ROWID + "&style=select2",
        allowClear: true,
        placeholder: '发药人...'
    }
    $("#sel-fyuser").dhcphaSelect(selectoption)
    $("#sel-fyuser").on('select2:select', function (event) {
        //alert(event)
    });
}
//改为按接收科室配置取患者病区(可满足跨院区发药的情况)  by zhaoxinlong 2022.04.22
//初始化病区
function InitPhaWard(recLocId) {
	if ((recLocId == undefined) || (recLocId == "undefined")) {
        recLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
    }
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetWardLocDsByRecLoc&style=select2"+"&reclocId="+reclocId,
        placeholder: "病区...",
        width: "390px"
    }
    $("#sel-phaward").dhcphaSelect(selectoption);
    if (DHCPHA_CONSTANT.SESSION.GWARD_ROWID != "") {
        var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.SESSION.GWARD_ROWID + "'" + 'selected>' + DHCPHA_CONSTANT.SESSION.GWARD_DESC + '</option>'
        $("#sel-phaward").append(select2option);
    }
}

//初始化发药查询列表
function InitDispWardList() {
    var columns = [
        [{
                field: "Tcoll",
                title: 'Tcoll',
                width: 40,
                hidden: true
            },
            {
                field: "Tpid",
                title: 'Tpid',
                width: 40,
                hidden: true
            },
            {
                field: "TSelect",
                title: 'TSelect',
                checkbox: true
            },
            {
                field: "TWard",
                title: '病区',
                width: 200
            },
            {
                field: "TDispCat",
                title: '类型',
                width: 80,
                align: 'center'
            },
            {
                field: "TDateScope",
                title: '日期范围',
                width: 100
            },
            {
                field: "TStatus",
                title: '状态',
                width: 60,
                align: 'center'
            },
            {
                field: "TPrintDate",
                title: '打印日期',
                width: 100,
                align: 'center'
            },
            {
                field: "TPrintTime",
                title: '打印时间',
                width: 100,
                align: 'center'
            },
            {
                field: "TCollectDate",
                title: '发药日期',
                width: 100,
                align: 'center'
            },
            {
                field: "TCollectTime",
                title: '发药时间',
                width: 100,
                align: 'center'
            },
            {
                field: "TOperUser",
                title: '操作人',
                width: 100,
                align: 'left'
            },
            {
                field: "TCollectUser",
                title: '第二发药人',
                width: 100,
                align: 'left'
            },
            {
                field: "TDispNo",
                title: '发药单号',
                width: 240,
                align: 'left'
            },
            {
                field: "TSendAutoFlag",
                title: '摆药机',
                width: 100,
                hidden: true
            }
        ]
    ];

    var dataGridOption = {
        //url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        url: "/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.DispQuery.Display&MethodName=EuiGetPHACollected",
        columns: columns,
        fitColumns: true,
        singleSelect: true,
        checkOnSelect: true,
        selectOnCheck: false,
        onSelect: function (rowIndex, rowData) {
            QuerySub();
        }
    }
    //定义datagrid	
    $('#grid-query').dhcphaEasyUIGrid(dataGridOption);
}

//初始化发药汇总列表
function InitDispMainList() {
    var columns = [
        [{
                field: "Tincicode",
                title: '药品代码',
                width: 125,
                align: 'left'
            },
            {
                field: "Tincidesc",
                title: '药品名称',
                width: 300
            },
            {
                field: "Tqty",
                title: '发药数量',
                width: 70,
                align: 'right'
            },
            {
                field: "Tuom",
                title: '单位',
                width: 50,
                align: 'center'
            },
            {
                field: "Tprice",
                title: '单价',
                width: 70,
                align: 'right'
            },
            {
                field: "Tinciamt",
                title: '发药金额',
                width: 75,
                align: 'right'
            },
            {
                field: "Tspec",
                title: '规格',
                width: 100
            },
            {
                field: "Tmanf",
                title: '生产企业',
                width: 250
            },
            {
                field: "Tresqty",
                title: '冲减数量',
                width: 70,
                align: 'right'
            },
            {
                field: "Tresdata",
                title: '冲减信息',
                width: 300
            },
            {
                field: "Tgenedesc",
                title: '处方通用名',
                width: 100,
                align: 'left',
                hidden:true
            },
            {
                field: "Tphcform",
                title: '剂型',
                width: 60,
                hidden:true
            }
        ]
    ];
    var dataGridOption = {
        //url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        url: "/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.DispQuery.Display&MethodName=EuiGetPHACollTotal",
        columns: columns,
        fitColumns: false
    }
    //定义datagrid	
    $('#grid-querytotal').dhcphaEasyUIGrid(dataGridOption);
}

//初始化发药明细列表
function InitDispDetailList() {
    var columns = [
        [{
                field: "TAdmLoc",
                title: '科室',
                width: 150
            },
            {
                field: "TBedNo",
                title: '床号',
                width: 80
            },
            {
                field: "TPaName",
                title: '姓名',
                width: 80
            },
            {
                field: "TRegNo",
                title: '登记号',
                width: 90
            },
            {
                field: "TOld",
                title: '年龄',
                width: 70
            },
            {
                field: "TOrdItemDesc",
                title: '药品名称',
                width: 225
            },
            {
                field: "TQty",
                title: '数量',
                width: 70
            },
            {
                field: "TDoseQty",
                title: '剂量',
                width: 75
            },
            {
                field: "TFreq",
                title: '频次',
                width: 75
            },
            {
                field: "TInstruction",
                title: '用法',
                width: 80
            },
            {
                field: "TDuration",
                title: '疗程',
                width: 75
            },
            {
                field: "TDispCat",
                title: '类型',
                width: 75
            },
            {
                field: "TPrescno",
                title: '处方号',
                width: 115,
                align: 'center'
            },
            {
                field: "TJYType",
                title: '煎药方式',
                width: 75,
                align: 'center',
				hidden:true
            },
            {
                field: "TStatus",
                title: '状态',
                width: 75,
                align: 'center',
                hidden: true
            }, //医嘱状态,执行记录状态均无法正确显示		
            {
                field: "TBatchNo",
                title: '批号',
                width: 100
            },
            {
                field: "TDiag",
                title: '诊断',
                width: 150
            },
            {
                field: "TDoctor",
                title: '开方医生',
                width: 80,
                hidden:true
            },
            {
                field: "TOeoriDate",
                title: '开单日期',
                width: 100
            },
            {
                field: "TDoseDate",
                title: '用药日期',
                width: 100,
                align: 'left'
            },
            {
                field: "TDoseTimes",
                title: '用药时间',
                width: 120,
                align: 'left'
            },
            {
                field: "TEncryptLevel",
                title: '病人密级',
                width: 100,
                align: 'left'
            },
            {
                field: "TPatLevel",
                title: '病人级别',
                width: 100,
                align: 'left'
            },
            {
                field: "TSalePrice",
                title: '价格',
                width: 75,
                align: 'right'
            },
            {
                field: "TStotal",
                title: '金额',
                width: 75,
                align: 'right'
            },
            {
                field: "TManf",
                title: '生产企业',
                width: 150,
                align: 'left'
            }
        ]
    ];
    var dataGridOption = {
        //url:DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        url: "/imedical/web/csp/DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.DispQuery.Display&MethodName=EuiGetPHACollDetail",
        columns: columns,
        pagination: false,
        fitColumns: false
    }
    //定义datagrid	
    $('#grid-querydetail').dhcphaEasyUIGrid(dataGridOption);
}


///查询
function Query() {
    var inputStr = QueryParams();
    if (inputStr == "") {
        return;
    }
    $('#grid-query').datagrid({
        queryParams: {
            InputStr: inputStr
        }
    });
    $('#grid-querytotal').clearEasyUIGrid();
    $('#grid-querydetail').clearEasyUIGrid();
}
/// 查询明细数据
function QuerySub() {
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var selecteddata = $('#grid-query').datagrid('getSelected');
    if (selecteddata == null) {
        //return;	
    }
    var checkedItems = $('#grid-query').datagrid('getChecked');
    if ((checkedItems == null) || (checkedItems == "")) {
        dhcphaMsgBox.alert("请勾选需要统计的发药单!");
        return;
    }
    var phacIdStr = "";
    $.each(checkedItems, function (index, item) {
        if (phacIdStr == "") {
            phacIdStr = item.Tcoll;
        } else {
            phacIdStr = phacIdStr + "," + item.Tcoll;
        }
    });
    var inputStr = QueryParams();
    params = GetQueryParams("^");
    if ($("#sp-title").text() == "发药单药品汇总") {
        $('#grid-querytotal').datagrid({
            queryParams: {
                PhacIdStr: phacIdStr,
                InputStr: inputStr
            }
        });
    } else {
        $('#grid-querydetail').datagrid({
            queryParams: {
                PhacIdStr: phacIdStr,
                InputStr: inputStr
            }
        });
    }
}

// 查询参数
function QueryParams() {
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaloc = $("#sel-phaloc").val();
    if (phaloc == null) {
        dhcphaMsgBox.alert("请选择药房!")
        return "";
    }
    var wardloc = $("#sel-phaward").val();
    if (wardloc == null) {
        wardloc = "";
    }
    var dispuser = $("#sel-fyuser").val();
    if (dispuser == null) {
        dispuser = "";
    }
    var dispcatstr = $("#sel-disptype").val();
    if (dispcatstr == null) {
        dispcatstr = "";
    }
    var docloc = $("#sel-docloc").val();
    if (docloc == null) {
        docloc = "";
    }
    var dispno = $("#txt-dispno").val();
    var regno = $("#txt-patno").val();
    var chklong = "";
    if ($("#chk-longord").is(':checked')) {
        chklong = "Y";
    }
    var chkshort = "";
    if ($("#chk-shortord").is(':checked')) {
        chkshort = "Y";
    }
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaloc + tmpSplit + wardloc + tmpSplit + dispuser + tmpSplit + dispcatstr + tmpSplit + starttime + tmpSplit + endtime + tmpSplit + docloc + tmpSplit + dispno + tmpSplit + regno + tmpSplit + chklong + tmpSplit + chkshort;;
    return params;
}

// 打印传参
function GetQueryParams(splitchar) {
    var checkedItems = $('#grid-query').datagrid('getChecked');
    var paramstr = ""
    var regno = $("#txt-patno").val();
    var chklong = "0";
    if ($("#chk-longord").is(':checked')) {
        chklong = "1";
    }
    var chkshort = "0";
    if ($("#chk-shortord").is(':checked')) {
        chkshort = "1";
    }
    var otherparams = regno + "^" + chklong + "^" + chkshort;
    $.each(checkedItems, function (index, item) {
        if (paramstr == "") {
            paramstr = item.Tcoll + splitchar + otherparams;
        } else {
            paramstr = paramstr + "A" + item.Tcoll + splitchar + otherparams;
        }
    });
    return paramstr;
}

function ChangeDispQuery() {
    var Pid = "";
    if ($("#sp-title").text() == "发药单药品汇总") {
        $("#sp-title").text("发药单明细");
        $("#div-total").hide();
        $("#div-detail").show();
        $('#grid-querydetail').clearEasyUIGrid();
    } else {
        $("#sp-title").text("发药单药品汇总")
        $("#div-detail").hide();
        $("#div-total").show(); //每次点击汇总都要重新汇总
        $('#grid-querytotal').clearEasyUIGrid();
    }
    QuerySub();
}
//清空
function ClearConditions() {
    var stdatetime = FormatDateT("T") + " " + "00:00:00"
    var eddatetime = FormatDateT("T") + " " + "23:59:59"
    $("#date-start").data('daterangepicker').setStartDate(stdatetime);
    $("#date-start").data('daterangepicker').setEndDate(stdatetime);
    $("#date-end").data('daterangepicker').setStartDate(eddatetime);
    $("#date-end").data('daterangepicker').setEndDate(eddatetime);
    $("#txt-patno").val("");
    $("#txt-dispno").val("");
    $("#sel-docloc").empty();
    $("#sel-fyuser").empty();
    $("#sel-disptype").empty();
    $("#sel-phaward").empty();
    $("#chk-shortord").iCheck("uncheck");
    $("#chk-longord").iCheck("uncheck");
    $("#chk-prtdetail").iCheck("uncheck");
    $("#chk-prttotal").iCheck("uncheck");
    $('#grid-query').clearEasyUIGrid();
    $('#grid-querytotal').clearEasyUIGrid();
    $('#grid-querydetail').clearEasyUIGrid();
    $(".datagrid-header-check input").iCheck("uncheck");
}
// 打印
function PrintInDisp() {
    var checkedItems = $('#grid-query').datagrid('getChecked');
    if ((checkedItems == null) || (checkedItems == "")) {
        dhcphaMsgBox.alert("请勾选需要打印的发药单!");
        return;
    }
    // 获取打印方式: 1-明细,2-汇总,3-明细+汇总
    var checkedItems = $('#grid-query').datagrid('getChecked');
    var phacStr = "";
    $.each(checkedItems, function (index, item) {
        if (phacStr == "") {
            phacStr = item.Tcoll;
        } else {
            phacStr = phacStr + "^" + item.Tcoll;
        }
    });
    var otherStr = "";
    var prtdetail = $("#chk-prtdetail").is(':checked') ? 1 : 0;
    var prttotal = $("#chk-prttotal").is(':checked') ? 1 : 0;
    var prttype = "";
    prttype = prtdetail == 1 ? 1 : prttype;
    prttype = prttotal == 1 ? 2 : prttype;
    prttype = (prtdetail == 1) && (prttotal == 1) ? 3 : prttype;
    IPPRINTCOM.Print({
        phacStr: phacStr,
        otherStr: otherStr,
        printType: prttype,
        reprintFlag: 1,
        pid: ''
    });
}
window.onresize = ResizeDispQuery;

function ResizeDispQuery() {
    var gridcanuse = GridCanUseHeight(1) * 0.5;
    $("#grid-query").closest(".panel-body").height(gridcanuse - 20);
    $("#grid-querytotal").closest(".panel-body").height(gridcanuse - 20);
    $("#grid-querydetail").closest(".panel-body").height(gridcanuse - 20);
    $("#grid-query,#grid-querytotal,#grid-querydetail").datagrid('resize')
}