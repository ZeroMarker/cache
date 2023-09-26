/*
模块:		草药房
子模块:		草药房-草药发药界面
Creator:	丁竑莹
CreateDate:	2017-07-05
*/
var NowTAB = "#div-presc-condition"; // 记录当前tab
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 20 * 1000;

$(function () {
    InitPhaConfig();
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
    };
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    InitPhaLoc();
    InitPhaWard();
    InitGridPrescList();
    InitGridAdm();
    InitGridAdmPrescList();
    InitTrialDispTab();
    $("#monitor-condition").children().not("#div-presc-condition").hide();

    /* 表单元素事件 start*/
    //登记号回车事件
    $('#txt-patno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#txt-patno").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                QueryInPhDispList();
            }
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
    })
    /* 表单元素事件 end*/

    $("#chk-refresh").on("ifChanged", function () {
        if ($(this).is(':checked') == true) {
            DHCPHA_CONSTANT.VAR.TIMER = setInterval("QueryInPhDispList();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
        } else {
            clearTimeout(DHCPHA_CONSTANT.VAR.TIMER);
        }
    })
    InitRefuseReasonModal();
    InitBodyStyle();
})

window.onload = function () {
    setTimeout("QueryInPhDispList()", 500);
}

//申请单退药
function ReqReturn() {
    var lnk = "dhcpha/dhcpha.inpha.returnbyreq.csp";
    websys_createWindow(lnk, "申请单退药", "width=95%,height=90%")
}

//直接退药
function DirectReturn() {
    var lnk = "dhcpha/dhcpha.inpha.return.csp";
    websys_createWindow(lnk, "直接退药", "width=95%,height=90%")
}

//已发处方查询
function AuditParyQuery() {
    var lnk = "dhcpha/dhcpha.inpha.hmprescdispquery.csp";
    websys_createWindow(lnk, "_target", "width=95%,height=90%")
}

//撤销拒绝
function CancelRefuse() {
    var lnk = "dhcpha/dhcpha.inpha.hmprescrefusequery.csp";
    websys_createWindow(lnk, "_target", "width=95%,height=90%");
}

//初始化药房科室
function InitPhaConfig() {
    $.ajax({
        type: 'POST', //提交方式 post 或者get  
        url: LINK_CSP + "?ClassName=web.DHCSTPharmacyCommon&MethodName=GetInPhaConfig&locId=" + gLocId,
        data: "",
        success: function (value) {
            if (value != "") {
                SetPhaLocConfig(value)
            }
        },
        error: function () {
            alert("获取住院药房配置数据失败!");
        }
    });
}
//加载药房配置
function SetPhaLocConfig(configstr) {
    var configarr = configstr.split("^");
    var startdate = configarr[2];
    var enddate = configarr[3];
    var starttime = configarr[4];
    var endtime = configarr[5];
    if (starttime == "") {
        starttime = "00:00:00";
    }
    if (endtime == "") {
        endtime = "23:59:59";
    }
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    $("#date-start").data('daterangepicker').setStartDate(startdate + ' ' + starttime);
    $("#date-start").data('daterangepicker').setEndDate(startdate + ' ' + starttime);
    $("#date-end").data('daterangepicker').setStartDate(enddate + ' ' + endtime);
    $("#date-end").data('daterangepicker').setEndDate(enddate + ' ' + endtime);
    
    $("#sel-locinci").empty();
    if (configarr[32] != "Y") {
        $("#btn-pass").attr({
            "disabled": "disabled"
        });
        $("#btn-refuse").attr({
            "disabled": "disabled"
        });
    }
}

//初始化处方列表table
function InitGridPrescList() {
    var columns = [{
            name: "TWardLocId",
            index: "TWardLocId",
            header: 'TWardLocId',
            width: 10,
            hidden: true
        },
        {
            name: "TPrescEmergen",
            index: "TPrescEmergen",
            header: '是否加急',
            width: 70
        },
        {
            name: "TWardLoc",
            index: "TWardLoc",
            header: '病区',
            width: 140,
            align: 'left',
            formatter: splitFormatter
        },
        {
            name: "TBedNo",
            index: "TBedNo",
            header: '床号',
            width: 60
        },
        {
            name: "TPatNo",
            index: "TPatNo",
            header: '登记号',
            width: 90
        },
        {
            name: "TPatName",
            index: "TPatName",
            header: '姓名',
            width: 80
        },
        {
            name: "TPrescNo",
            index: "TPrescNo",
            header: '处方号',
            width: 120
        },
        {
            name: "TAuditResult",
            index: "TAuditResult",
            header: '审方结果',
            width: 62
        },
        {
            name: "TPrescForm",
            index: "TPrescForm",
            header: '处方剂型',
            width: 60
        },
        {
            name: "TFactor",
            index: "TFactor",
            header: '付数',
            width: 50
        },
        {
            name: "TSeekUserName",
            index: "TSeekUserName",
            header: '提交护士',
            width: 100
        },
        {
            name: "TSeekDate",
            index: "TSeekDate",
            header: '提交时间',
            width: 140
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: LINK_CSP + '?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=jsQueryDispPrescList', //查询后台	
        pager: "#jqGridPager", //分页控件的id
        fit: true,
        multiselect: false,
        shrinkToFit: false,
        rownumbers: true,
        datatype: "local",
        onSelectRow: function (id, status) {
            QueryGridDispSub()
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#ifrm-presc").attr("src", "");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        },
        gridComplete: function () {
            var ids = $("#grid-presclist").jqGrid("getDataIDs");
            var rowDatas = $("#grid-presclist").jqGrid("getRowData");
            for (var i = 0; i < rowDatas.length; i++) {
                var rowData = rowDatas[i];
                var prescemergen = rowData.TPrescEmergen;
                if (prescemergen == "Y") {
                    $("#grid-presclist" + " #" + ids[i] + " td").css({
                        color: '#EE7600',
                        'font-weight': 'bold'
                    });
                }
            }
            return true;
        }
    };
    $('#grid-presclist').dhcphaJqGrid(jqOptions);
}

//初始病人就诊table
function InitGridAdm() {
    var columns = [{
            name: "TAdm",
            index: "TAdm",
            header: 'TAdm',
            width: 10,
            hidden: true
        },
        {
            name: "TCurrWard",
            index: "TCurrWard",
            header: '病区',
            width: 100,
            align: 'left',
            formatter: splitFormatter
        },
        {
            name: "TPatNo",
            index: "TPatNo",
            header: '登记号',
            width: 80
        },
        {
            name: "TCurrentBed",
            index: "TCurrentBed",
            header: '床号',
            width: 60
        },
        {
            name: "TDoctor",
            index: "TDoctor",
            header: '医生',
            width: 60
        },
        {
            name: "TAdmDate",
            index: "TAdmDate",
            header: '就诊日期',
            width: 80
        },
        {
            name: "TAdmTime",
            index: "TAdmTime",
            header: '就诊时间',
            width: 80
        },
        {
            name: "TAdmLoc",
            index: "TAdmLoc",
            header: '就诊科室',
            width: 80,
            align: 'left',
            formatter: splitFormatter
        }
    ];

    var jqOptions = {
        colModel: columns, //列
        url: LINK_CSP + '?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=jsQueryDispAdmList', //查询后台
        height: DhcphaJqGridHeight(2, 3) * 0.35,
        multiselect: false,
        onSelectRow: function (id, status) {
            var id = $(this).jqGrid('getGridParam', 'selrow');
            if (id) {
                var selrowdata = $(this).jqGrid('getRowData', id);
                var adm = selrowdata.TAdm;
                $("#grid-admpresclist").jqGrid("clearGridData");
                var params = GetMainCodParams();
                params = params + "^^" + adm;
                $("#grid-admpresclist").setGridParam({
                    datatype: 'json',
                    page: 1,
                    postData: {
                        'params': params
                    }
                }).trigger("reloadGrid");
            }
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-admpresclist").jqGrid("clearGridData");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }
    };
    $('#grid-admlist').dhcphaJqGrid(jqOptions);
}

//初始化病人就诊处方列表table
function InitGridAdmPrescList() {
    var columns = [{
            name: "TWardLocId",
            index: "TWardLocId",
            header: 'TWardLocId',
            width: 10,
            hidden: true
        },
        {
            name: "TPrescEmergen",
            index: "TPrescEmergen",
            header: '是否加急',
            width: 70
        },
        {
            name: "TWardLoc",
            index: "TWardLoc",
            header: '病区',
            width: 150,
            align: 'left',
            formatter: splitFormatter
        },
        {
            name: "TBedNo",
            index: "TBedNo",
            header: '床号',
            width: 60
        },
        {
            name: "TPatNo",
            index: "TPatNo",
            header: '登记号',
            width: 80
        },
        {
            name: "TPatName",
            index: "TPatName",
            header: '姓名',
            width: 80
        },
        {
            name: "TPrescNo",
            index: "TPrescNo",
            header: '处方号',
            width: 120
        },
        {
            name: "TAuditResult",
            index: "TAuditResult",
            header: '审方结果',
            width: 62
        },
        {
            name: "TPrescForm",
            index: "TPrescForm",
            header: '处方剂型',
            width: 60
        },
        {
            name: "TFactor",
            index: "TFactor",
            header: '付数',
            width: 50
        },
        {
            name: "TSeekUserName",
            index: "TSeekUserName",
            header: '提交护士',
            width: 100
        },
        {
            name: "TSeekDate",
            index: "TSeekDate",
            header: '提交时间',
            width: 100
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: LINK_CSP + '?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=jsQueryDispPrescList', //查询后台	
        height: DhcphaJqGridHeight(2, 3) * 0.55,
        fit: true,
        multiselect: false,
        shrinkToFit: false,
        datatype: "local",
        pager: "#jqGridPager1",
        onSelectRow: function (id, status) {
            QueryGridDispSub()
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#ifrm-presc").attr("src", "");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        },
        gridComplete: function () {
            var ids = $("#grid-admpresclist").jqGrid("getDataIDs");
            var rowDatas = $("#grid-admpresclist").jqGrid("getRowData");
            for (var i = 0; i < rowDatas.length; i++) {
                var rowData = rowDatas[i];
                var prescemergen = rowData.TPrescEmergen;
                if (prescemergen == "Y") {
                    $("#grid-admpresclist" + " #" + ids[i] + " td").css({
                        color: '#EE7600',
                        'font-weight': 'bold'
                    });
                }
            }
            return true;
        }
    };
    $('#grid-admpresclist').dhcphaJqGrid(jqOptions);
}

function ClearConditons() {
    $('#grid-presclist').clearJqGrid();
}

function InitBodyStyle() {

    var wardtitleheight = $("#gview_grid-presclist .ui-jqgrid-hbox").height();
    var wardheight = DhcphaJqGridHeight(1, 0) - wardtitleheight - 48;
    var prescheight = DhcphaJqGridHeight(1, 0) - 15;
    $("#grid-presclist").setGridHeight(wardheight);
    $("#ifrm-presc").height(prescheight);
}

function InitTrialDispTab() {
    $("#tab-ipmonitor a").on('click', function () {
        $("#ifrm-presc").empty();
        var tabId = $(this).attr("id");
        var tmpTabId = "#div-" + tabId.split("-")[1] + "-condition";
        $(tmpTabId).show();
        $("#monitor-condition").children().not(tmpTabId).hide();
        NowTAB = tmpTabId;
        QueryInPhDispList();
    })
}

function QueryInPhDispList() {
    var params = GetMainCodParams();
    if (NowTAB == "#div-presc-condition") {
        var wardloc = $('#sel-phaward').val();
        if (wardloc == null) {
            wardloc = ""
        };
        var Input = params + "^" + wardloc + "^";
        var WardStr = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery", "GetDispWardStr", Input);
        params = params + "^" + WardStr + "^";
        $("#grid-presclist").setGridParam({
            datatype: 'json',
            page: 1,
            postData: {
                'params': params
            }
        }).trigger("reloadGrid");
    } else {
        var patno = $("#txt-patno").val();
        if (patno == "") {
            var selectid = $("#grid-admlist").jqGrid('getGridParam', 'selrow');
            var selrowdata = $("#grid-admlist").jqGrid('getRowData', selectid);
            patno = selrowdata.TPatNo;
        }
        $("#grid-admlist").setGridParam({
            page: 1,
            datatype: 'json',
            postData: {
                'params': patno,
                'logonLocId': DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID
            }
        }).trigger("reloadGrid");
    }
    $("#txt-patno").val("");
    return true;
}

//查询发药明细
function QueryGridDispSub() {
    if (NowTAB == "#div-presc-condition") {
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescno = selrowdata.TPrescNo;
    var prescform = selrowdata.TPrescForm;
    QueryPrescDetail(prescno);
}

function QueryPrescDetail(prescno) {
    $("#ifrm-presc").empty();
    var htmlstr = GetPrescHtml(prescno);
    $("#ifrm-presc").append(htmlstr);
}

function GetPrescHtml(prescno) {
    var cyflag = "Y";
    var phartype = "DHCINPHA";
    var paramsstr = phartype + "^" + prescno + "^" + cyflag;
    $("#ifrm-presc").attr("src", ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp") + "?paramsstr=" + paramsstr + "&PrtType=DISPPREVIEW");
}

//获取查询条件
function GetMainCodParams() {
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaLoc = ""
    }
    if (phaloc == "") {
        dhcphaMsgBox.alert("药房不允许为空!");
        return;
    }
    var params = startdate + "^" + starttime + "^" + enddate + "^" + endtime + "^" + phaloc;
    return params;
}

//全发按钮
function AllConfirmDisp() {
    if (NowTAB == "#div-presc-condition") {
        var prescrowdata = $("#grid-presclist").jqGrid('getRowData');
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var prescrowdata = $("#grid-admpresclist").jqGrid('getRowData');
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescridrows = prescrowdata.length;
    if (prescridrows <= 0) {
        dhcphaMsgBox.alert("待发处方列表没有数据!");
        return;
    }
    dhcphaMsgBox.confirm("确认全发吗?系统将全部发放查询出的所有处方!", ConfirmDispAll);
}

//确认全发
function ConfirmDispAll(result) {
    if (result == true) {
        if (NowTAB == "#div-presc-condition") {
            var prescrowdata = $("#grid-presclist").jqGrid('getRowData');
        } else {
            var prescrowdata = $("#grid-admpresclist").jqGrid('getRowData');
        }
        var prescridrows = prescrowdata.length;
        for (var rowi = 1; rowi <= prescridrows; rowi++) {
            ExecuteDisp(rowi);
        }
        QueryInPhDispList();
    }
}

//发药按钮
function ConfirmDisp() {
    if (NowTAB == "#div-presc-condition") {
        var prescrowdata = $("#grid-presclist").jqGrid('getRowData');
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var prescrowdata = $("#grid-admpresclist").jqGrid('getRowData');
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescridrows = prescrowdata.length;
    if (prescridrows <= 0) {
        dhcphaMsgBox.alert("审方发药列表无数据!");
        return;
    }
    ExecuteDisp(selectid);

    QueryInPhDispList();
}

//执行发药
function ExecuteDisp(selectid) {
    if (NowTAB == "#div-presc-condition") {
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescno = selrowdata.TPrescNo;
    if ((selectid == null) || (prescno == "") || (prescno == null)) {
        dhcphaMsgBox.alert("请选择处方再发药!");
        return;
    }
    var phaLoc = $('#sel-phaloc').val();
    if (phaLoc == null) {
        phaLoc = ""
    }
    if (phaLoc == "") {
        dhcphaMsgBox.alert('错误提示', "药房不允许为空!");
        return;
    }

    var urgentFlag = "N"
    if ($("#chk-urgent").is(':checked')) {
        urgentFlag = "Y";
    }

    var params = prescno + "^" + phaLoc + "^" + gUserID + "^" + urgentFlag;
    var retStr = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp", "SaveData", params);
    var PhacRowid = retStr.split("^")[0];
    var retMessage = retStr.split("^")[1];
    if (PhacRowid > 0) {
        PrintInphaCom(prescno, PhacRowid)
        SendOrderToMachine(PhacRowid);
        $("#ifrm-presc").empty(); //初始化处方预览	 
    } else {
        dhcphaMsgBox.alert("发药失败,失败原因:" + retMessage);
    }
    return;
}

function InitRefuseReasonModal() {
    $('#modal-inpharefusedispreason').on('show.bs.modal', function () {
        var option = {
            url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + "?action=GetRefuseDispReason&style=select2",
            minimumResultsForSearch: Infinity,
            width: 200,
            allowClear: false
        }
        $("#sel-refusedispreason").dhcphaSelect(option);
        $("#sel-refusedispreason").empty();
    })
    $("#btn-refusereason-sure").on("click", function () {
        var refusereason = $("#sel-refusedispreason").val();
        if ((refusereason == "") || (refusereason == null)) {
            dhcphaMsgBox.alert("请选择拒绝原因!");
            return;
        }
        $("#modal-inpharefusedispreason").modal('hide');
        ExecuteRefuse(refusereason);
    });
}

//拒绝发药按钮执行方法
function RefuseDisp() {
    if (NowTAB == "#div-presc-condition") {
        var prescrowdata = $("#grid-presclist").jqGrid('getRowData');
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var prescrowdata = $("#grid-admpresclist").jqGrid('getRowData');
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescridrows = prescrowdata.length;
    if (prescridrows <= 0) {
        dhcphaMsgBox.alert("审方发药列表无数据，无法拒绝发药!");
        return;
    }

    var prescno = selrowdata.TPrescNo;
    if ((selectid == null) || (prescno == "")) {
        dhcphaMsgBox.alert("请选择处方后再拒绝发药!");
        return;
    }
    $('#modal-inpharefusedispreason').modal('show');
}

function ExecuteRefuse(resondr) {
    if ((resondr == "") || (resondr == null)) {
        return;
    }
    if (NowTAB == "#div-presc-condition") {
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescno = selrowdata.TPrescNo;
    var ret = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp", "RefusetDrug", prescno, gUserID, resondr);
    if (ret == 0) {
        QueryInPhDispList();
        $("#ifrm-presc").empty(); //初始化处方预览
    } else {
        dhcphaMsgBox.alert('错误提示', "拒绝发药失败,错误代码:" + ret);
        return;
    }
}

function splitFormatter(cellvalue, options, rowObject) {
    if (cellvalue.indexOf("-") >= 0) {
        cellvalue = cellvalue.split("-")[1];
    }
    return cellvalue;
};


//发送到包药机
function SendOrderToMachine(pharowid) {
    var SendFlag = tkMakeServerCall("web.DHCSTPharmacyCommon", "GetSendMachineFlag", gLocId);
    if (SendFlag == "Y") {
        var sendret = tkMakeServerCall("web.DHCSTInterfacePH", "SendOrderToMechine", pharowid);
        if (sendret != "0") {
            var retString = sendret.split("^")[1];
            dhcphaMsgBox.alert("给第三方发送数据失败,错误代码:" + retString, "error");
            return;
        }
    }
}