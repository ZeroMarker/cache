/*
 *模块:			草药房
 *子模块:		草药房-揭药护士核对
 *createdate:	2017-07-07
 *creator:		dinghongying
 */
DhcphaTempBarCode = "";
$(function () {
    /* 初始化插件 start*/
    /*
    $("#date-daterange").dhcphaDateRange();
    var tmpstartdate = FormatDateT("t-2")
    $("#date-daterange").data('daterangepicker').setStartDate(tmpstartdate);
    */
    
    var daterangeoptions = {
        timePicker: false,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT		//+ ' HH:mm:ss'
        }
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
	var startdate = FormatDateT("t-2") ;
	var enddate = FormatDateT("t") ;
    //var starttime = '00:00:00';
    //var endtime = '23:59:59';
    $('#date-start').data('daterangepicker').setStartDate(startdate);		// + ' ' + starttime
    $('#date-start').data('daterangepicker').setEndDate(startdate);			// + ' ' + starttime
    $('#date-end').data('daterangepicker').setStartDate(enddate);			// + ' ' + endtime
    $('#date-end').data('daterangepicker').setEndDate(enddate);				// + ' ' + endtime

    InitGirdPreList();
    InitGirdPreOrderList();

    /* 表单元素事件 start*/
    //箱号失去焦点触发事件
    $('#txt-phboxno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            QueryGridMedBroth();
        }
    });

    //屏蔽所有回车事件
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })

    //屏蔽所有按钮事件
    $("button").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    });

    SetDefaultCode();

    $("#chk-patadm").on("ifChanged", function () {
        QueryGridMedBroth();
    })

    document.onkeydown = OnKeyDownHandler;
})

window.onload = function () {
    setTimeout("QueryGridMedBroth()", 500);
}

//显示填充界面默认值
function SetDefaultCode() {
    $('#currentnurse').text(gUserName);
    var LogLocStrInfo = tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod", "GetLocInfoById", gLocId);
    var LogLocArr = LogLocStrInfo.split("^")
    $('#currentctloc').text(LogLocArr[1]);
}

//初始化发药单列表table
function InitGirdPreList() {
    var columns = [{
            header: 'TPapmi',
            index: 'TPapmi',
            name: 'TPapmi',
            width: 30,
            hidden: true
        },
        {
            header: '床号',
            index: 'TBed',
            name: 'TBed',
            width: 60
        },
        {
            header: '姓名',
            index: 'TPatName',
            name: 'TPatName',
            width: 100
        },
        {
            header: '住院号',
            index: 'TPatCardNo',
            name: 'TPatCardNo',
            width: 100
        },
        {
            header: '登记号',
            index: 'TPatNo',
            name: 'TPatNo',
            width: 100
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: LINK_CSP + '?ClassName=PHA.MS.NurChk.Query&MethodName=GetBrothPatList',
        height: OutFYCanUseHeight() - 10,
        recordtext: "",
        pgtext: "",
        shrinkToFit: false,
        rownumbers: true, //是否显示行号
        onSelectRow: function (id, status) {
            QueryGridPatBroth();
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-patlist").clearJqGrid();
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }

    };
    $("#grid-patlist").dhcphaJqGrid(jqOptions);
}

//初始化发药单列表table
function InitGirdPreOrderList() {
    var columns = [{
            header: 'TPhmbi',
            index: 'TPhmbi',
            name: 'TPhmbi',
            width: 10,
            hidden: true
        },
        {
            header: '床号',
            index: 'TBedNo',
            name: 'TBedNo',
            width: 60
        },
        {
            header: '姓名',
            index: 'TPatName',
            name: 'TPatName',
            width: 80
        },
        {
            header: '登记号',
            index: 'TPatNo',
            name: 'TPatNo',
            width: 120
        },
        {
            header: '住院号',
            index: 'TPameNo',
            name: 'TPameNo',
            width: 60
        },
        {
            header: '处方号',
            index: 'TPrescNo',
            name: 'TPrescNo',
            width: 120
        },
        {
            header: '揭药时间',
            index: 'TActUncovMedDate',
            name: 'TActUncovMedDate',
            width: 140
        },
        {
            header: '袋数',
            index: 'TActUncovMedPocNum',
            name: 'TActUncovMedPocNum',
            width: 50,
            align: 'right'
        },
        {
            header: '接收人',
            index: 'TNurseCheckUser',
            name: 'TNurseCheckUser',
            width: 80
        },
        {
            header: '接收部门',
            index: 'TWardLoc',
            name: 'TWardLoc',
            width: 120
        },
        {
            header: '接收时间',
            index: 'TNurseCheckDate',
            name: 'TNurseCheckDate',
            width: 140
        },
        {
            header: '备注',
            index: 'TRemark',
            name: 'TRemark',
            width: 160
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: LINK_CSP + '?ClassName=PHA.MS.NurChk.Query&MethodName=GetPatBrothPreList',
        height: OutFYCanUseHeight() - 40,
        multiselect: true,
        pager: "#jqGridPager1",
        rownumbers: true, //是否显示行号
        shrinkToFit: false,
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-prescbrothdetail").clearJqGrid();
            }
        }

    };
    $("#grid-prescbrothdetail").dhcphaJqGrid(jqOptions);
}

//查询方法的总入口
function QueryGridMedBroth() {
    if ($("#chk-patadm").is(':checked')) {
        QueryGridPre();
    } else {
        QueryGridPatBroth();
    }
}

//查询发药单列表
function QueryGridPre() {
    $("#grid-patlist").jqGrid("clearGridData");
    $("#grid-prescbrothdetail").jqGrid("clearGridData");
    var currentnurse = $.trim($("#currentnurse").text());
    var currentctloc = $.trim($("#currentctloc").text());
    if (currentnurse == null || currentnurse == "" || currentctloc == null || currentctloc == "") {
        dhcphaMsgBox.alert("请先刷领药人的卡或者输入工号!");
        return;
    }
    /*
    var daterange = $("#date-daterange").val();
    daterange = FormatDateRangePicker(daterange);
    var stdate = daterange.split(" - ")[0];
    var enddate = daterange.split(" - ")[1];
    */
    var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
    var chkauit = "N";
    if ($("#chk-audit").is(':checked')) {
        chkauit = "Y";
    }
    var phboxno = $('#txt-phboxno').val();
    var params = startdate + "^" + enddate + "^" + gLocId + "^" + chkauit + "^" + phboxno;
    $("#grid-patlist").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
}

function QueryGridPatBroth() {
    if ($("#chk-patadm").is(':checked')) {
        var selectid = $("#grid-patlist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-patlist").jqGrid('getRowData', selectid);
        papmi = selrowdata.TPapmi;
    } else {
        $("#grid-patlist").jqGrid("clearGridData");
        papmi = "";
    }
    /*
    var daterange = $("#date-daterange").val();
    daterange = FormatDateRangePicker(daterange);
    var stdate = daterange.split(" - ")[0];
    var enddate = daterange.split(" - ")[1];
    */
    var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
    var chkauit = "N";
    if ($("#chk-audit").is(':checked')) {
        chkauit = "Y";
    }
    var phboxno = $('#txt-phboxno').val();
    var params = startdate + "^" + enddate + "^" + papmi + "^" + gLocId + "^" + chkauit + "^" + phboxno;

    $("#grid-prescbrothdetail").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
}

function MedBroAuitPass() {
    var selectids = $("#grid-prescbrothdetail").jqGrid('getGridParam', 'selarrrow');
    if (selectids == "") {
        dhcphaMsgBox.alert("请先选中需要审核的记录");
        return;
    }
    var chkedFlag = "";
    var PhmbiStr = "";
    $.each(selectids, function () {
        var rowdata = $('#grid-prescbrothdetail').jqGrid('getRowData', this);
        var Phmbi = rowdata.TPhmbi;
        var chkNurse = rowdata.TNurseCheckUser;
        if (rowdata.TNurseCheckUser != "") {
            chkedFlag = "Y";
        }
        if (PhmbiStr == "") {
            PhmbiStr = Phmbi;
        } else {
            PhmbiStr = PhmbiStr + "^" + Phmbi;
        }
    })
    if (chkedFlag == "Y") {
        dhcphaMsgBox.alert("已核对，不需再次操作!");
        return;
    }
    var currentnurse = $.trim($("#currentnurse").text());
    var params = PhmbiStr + "&&" + currentnurse;
    var ret = tkMakeServerCall("web.DHCINPHA.HMNurseCheck.NurseCheckQuery", "SavaBrothNurseCheck", params);
    if (ret != 0) {
        if (ret == -1) {
            dhcphaMsgBox.alert("揭药信息为空，请核实!");
            return;
        } else if (ret == -2) {
            dhcphaMsgBox.alert("核对人为空，请核实!");
            return;
        } else {
            dhcphaMsgBox.alert("核对有误" + ret);
            return;
        }
    } else {
        dhcphaMsgBox.alert("核对成功！");
        QueryGridMedBroth();
    }

}

//清空
function ClearConditions() {
    SetDefaultCode();
    $("#grid-patlist").clearJqGrid();
    $("#grid-prescbrothdetail").clearJqGrid();
    $("#date-start").data('daterangepicker').setStartDate(FormatDateT("t-2"));
	$("#date-start").data('daterangepicker').setEndDate(FormatDateT("t-2"));
	$("#date-end").data('daterangepicker').setStartDate(FormatDateT("t"));
	$("#date-end").data('daterangepicker').setEndDate(FormatDateT("t"));
    $("#txt-phboxno").val("");
    $("#chk-audit").iCheck("uncheck");
    $("#chk-patadm").iCheck("uncheck");
    return;
}

//本页面table可用高度
function OutFYCanUseHeight() {
    var height1 = $("[class='container-fluid dhcpha-condition-container']").height();
    var height3 = parseFloat($("[class='panel div_content']").css('margin-top'));
    var height4 = parseFloat($("[class='panel div_content']").css('margin-bottom'));
    var height5 = parseFloat($("[class='panel-heading']").height());
    var tableheight = $(window).height() - height1 * 2 - 2 * height3 - 2 * height4 - 2 * height5;
    return tableheight;
}

function CheckTxtFocus() {
    var txtfocus = $("#txt-phboxno").is(":focus");
    if (txtfocus != true) {
        return false;
    }
    return true;
}

//监听keydown,用于定位扫描枪扫完后给值
function OnKeyDownHandler() {
    if (CheckTxtFocus() != true) {
        if (event.keyCode == 13) {
            $("#txt-phboxno").val(DhcphaTempBarCode);
            QueryGridMedBroth();
            $("#txt-phboxno").val("");
            DhcphaTempBarCode = "";
        } else {
            DhcphaTempBarCode += String.fromCharCode(event.keyCode)
        }
    }
    if (event.keyCode == 113) {
        PhacAuitPass();
    }
}