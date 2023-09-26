/*
模块:		移动药房
子模块:		移动药房-撤销或重打封箱签
Creator:	hulihua
CreateDate:	2017-04-25
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
    //给日期控件赋初始化值！
    var configstr = tkMakeServerCall("web.DHCSTPHALOC", "GetPhaflag", gLocId);
    var configarr = configstr.split("^");
    var startdate = configarr[2];
    var enddate = configarr[3];
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    $("#date-start").data('daterangepicker').setStartDate(startdate + ' 00:00:00');
    $("#date-start").data('daterangepicker').setEndDate(startdate + ' 00:00:00');
    $("#date-end").data('daterangepicker').setStartDate(enddate + ' 23:59:59');
    $("#date-end").data('daterangepicker').setEndDate(enddate + ' 23:59:59');
    InitPhaLoc(); //药房科室
    InitLabelWardList();
    InitLabelInfoList();
    /* 初始化插件 end*/
})

window.onload = function () {
    Query();
}

//初始化标签科室列表
function InitLabelWardList() {
    //定义columns
    var columns = [{
            header: 'ProcessID',
            index: 'ProcessID',
            name: 'ProcessID',
            width: 60,
            hidden: true
        },
        {
            header: 'TWardLocId',
            index: 'TWardLocId',
            name: 'TWardLocId',
            width: 200,
            hidden: true
        },
        {
            header: '科室病区',
            index: 'TWardLoc',
            name: 'TWardLoc',
            width: 250,
            align: 'left'
        }
    ];

    var jqOptions = {
        colModel: columns, //列
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTInPhCalLabel.CalLabelQuery&MethodName=GetLabelWardList',
        recordtext: "",
        pgtext: "",
        height: GridCanUseHeight(1) - 36,
        shrinkToFit: false,
        onSelectRow: function (id, status) {
            QuerySub();
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-phboxwardloclist").clearJqGrid();
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }

    };
    //定义datagrid	
    $('#grid-phboxwardloclist').dhcphaJqGrid(jqOptions);
}

//初始化封箱标签列表
function InitLabelInfoList() {
    var columns = [{
            header: 'PID',
            index: 'PID',
            name: 'PID',
            width: 10,
            align: 'left',
            hidden: true
        },
        {
            header: 'TPhbId',
            index: 'TPhbId',
            name: 'TPhbId',
            width: 10,
            align: 'left',
            hidden: true
        },
        {
            header: 'TWardLocId',
            index: 'TWardLocId',
            name: 'TWardLocId',
            width: 10,
            align: 'right',
            hidden: true
        },
        {
            header: 'TDispLoc',
            index: 'TDispLoc',
            name: 'TDispLoc',
            width: 10,
            align: 'right',
            hidden: true
        },
        {
            header: '条码',
            index: 'TBoxNo',
            name: 'TBoxNo',
            width: 80
        },
        {
            header: '病区科室',
            index: 'TWardLoc',
            name: 'TWardLoc',
            width: 100,
            align: 'left'
        },
        {
            header: '装箱时间',
            index: 'TCreateDate',
            name: 'TCreateDate',
            width: 100
        },
        {
            header: '箱数',
            index: 'TPhbNum',
            name: 'TPhbNum',
            width: 50
        },
        {
            header: '药品品种数',
            index: 'TInciNum',
            name: 'TInciNum',
            width: 50
        },
        {
            header: '备注',
            index: 'TReMark',
            name: 'TReMark',
            width: 150,
            align: 'left'
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTInPhCalLabel.CalLabelQuery&MethodName=GetLabelInfoList',
        multiselect: false,
        height: GridCanUseHeight(1) - 36,
        //pager: "#jqGridPager", //分页控件的id  
        shrinkToFit: false,
    }
    //定义datagrid	
    $('#grid-phboxdetail').dhcphaJqGrid(jqOptions);
}

///查询
function Query() {
    KillCalLabelTMP();
    $('#grid-phboxwardloclist').jqGrid("clearGridData");
    $('#grid-phboxdetail').jqGrid("clearGridData");
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaLoc = $("#sel-phaloc").val();
    if (phaLoc == null) {
        dhcphaMsgBox.alert("请选择科室!");
        return;
    }
    var chkcancel = "";
    if ($("#chk-cancel").is(':checked')) {
        chkcancel = "Y";
    }

    var params = startdate + "^" + starttime + "^" + enddate + "^" + endtime + "^" + phaLoc + "^" + chkcancel;
    $("#grid-phboxwardloclist").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
}

///查询明细
function QuerySub() {
    var selectid = $("#grid-phboxwardloclist").jqGrid('getGridParam', 'selrow');
    var selrowdata = $("#grid-phboxwardloclist").jqGrid('getRowData', selectid);
    var pid = selrowdata.ProcessID;
    var wardwardloc = selrowdata.TWardLocId;
    var params = pid + "^" + wardwardloc;

    $("#grid-phboxdetail").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
    $("#grid-phboxdetail").clearJqGrid();
}

///作废封箱签
function CanleLabel() {
    var selectid = $("#grid-phboxdetail").jqGrid('getGridParam', 'selrow');
    if ((selectid == null) || (selectid == "")) {
        dhcphaMsgBox.alert("请先选中需要撤销的装箱签信息！");
        return;
    }
    var selrowdata = $("#grid-phboxdetail").jqGrid('getRowData', selectid);
    var phboxid = selrowdata.TPhbId;
    var disploc = selrowdata.TDispLoc;
    var params = disploc + "#" + phboxid + "#" + gUserID;
    var ret = tkMakeServerCall("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery", "HandleCalPhbox", params);
    if (ret == 0) {
        dhcphaMsgBox.alert("撤销成功！");
        ClearConditions();
        Query();
        return;
    } else if (ret == -1) {
        dhcphaMsgBox.alert("未选中所需要作废的装箱签记录，请核实！");
        return;
    } else if (ret == -2) {
        dhcphaMsgBox.alert("该装箱签已经撤销，请核实！");
        return;
    } else if (ret == -3) {
        dhcphaMsgBox.alert("该装箱签已经派送或者签收，请核实！");
        return;
    } else if (ret == -4) {
        dhcphaMsgBox.alert("该装箱签没有对应的备药信息或者请领信息，请核实！");
        return;
    } else if (ret == -5) {
        dhcphaMsgBox.alert("护工已经接收或者配送完成，请核实！");
        return;
    } else {
        dhcphaMsgBox.alert("撤销失败，请联系工程师解决！");
        return;
    }
}

///打印
function BPrintHandler() {
    var selectid = $("#grid-phboxdetail").jqGrid('getGridParam', 'selrow');
    if ((selectid == null) || (selectid == "")) {
        dhcphaMsgBox.alert("请先选中需要补打的装箱签信息！");
        return;
    }
    var selrowdata = $("#grid-phboxdetail").jqGrid('getRowData', selectid);
    var phboxid = selrowdata.TPhbId;
    //var PrintLabelInfo=tkMakeServerCall("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery","GetPrintPhBoxInfo",phboxid);
    if (phboxid == "") {
        dhcphaMsgBox.alert("所需要补打的装箱签信息有误，请核实！");
        return;
    } else {
        //PrintPhBoxLabel(PrintLabelInfo);
        PrintPhBoxLabelC(phboxid)
    }
}

///清空
function ClearConditions() {
    //给日期控件赋初始化值！
    KillCalLabelTMP();
    var configstr = tkMakeServerCall("web.DHCSTPHALOC", "GetPhaflag", gLocId);
    var configarr = configstr.split("^");
    var startdate = configarr[2];
    var enddate = configarr[3];
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    $("#date-start").data('daterangepicker').setStartDate(startdate + ' 00:00:00');
    $("#date-start").data('daterangepicker').setEndDate(startdate + ' 00:00:00');
    $("#date-end").data('daterangepicker').setStartDate(enddate + ' 23:59:59');
    $("#date-end").data('daterangepicker').setEndDate(enddate + ' 23:59:59');
    $('#grid-phboxwardloclist').clearJqGrid();
    $('#grid-phboxdetail').clearJqGrid();
}

///清空临时global
function KillCalLabelTMP() {
    var Pid = "";
    if ($("#grid-phboxwardloclist").getGridParam('records') > 0) {
        var firstrowdata = $("#grid-phboxwardloclist").jqGrid("getRowData", 1);
        Pid = firstrowdata.ProcessID;
    }
    if (Pid != "") {
        var killret = tkMakeServerCall("web.DHCINPHA.MTInPhCalLabel.CalLabelQuery", "KillTmp", Pid);
    }
}

///异常关闭
window.onbeforeunload = function () {
    KillCalLabelTMP();
}