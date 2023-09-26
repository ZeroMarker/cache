/*
模块:		住院草药房
子模块:		住院草药房-草药已发药查询
Creator:	hulihua
CreateDate:	2018-12-11
*/
var NowTAB = "#div-presc-condition"; // 记录当前tab

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
    }
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    InitPhaLoc(); //药房科室
    InitPhaWard(); //病区
    InitGridPrescList(); //初始化处方列表
    InitGridAdm(); //初始化病人就诊列表
    InitGridAdmPrescList(); //初始化病人就诊处方表
    InitTrialDispTab(); //主页面tab
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
    /* 表单元素事件 end*/
    SetButAutty();
    ResizeHMPrescDispQuery();
})

window.onload = function () {
    setTimeout(QueryInPhDispList, 500);
}

//初始化药房科室
function InitPhaConfig() {
    $.ajax({
        type: 'POST', //提交方式 post 或者get  
        url: ChangeCspPathToAll(LINK_CSP) + "?ClassName=web.DHCSTPharmacyCommon&MethodName=GetInPhaConfig&locId=" + gLocId,
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
    var startdate = configarr[6] || "";
    var enddate = configarr[7] || "";
    if (startdate == "") {
        startdate = "t";
    }
    if (enddate == "") {
        enddate = "t";
    }
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    $("#date-start").data('daterangepicker').setStartDate(startdate + " 00:00:00");
    $("#date-start").data('daterangepicker').setEndDate(startdate + " 00:00:00");
    $("#date-end").data('daterangepicker').setStartDate(startdate + " 23:59:59");
    $("#date-end").data('daterangepicker').setEndDate(startdate + " 23:59:59");
    InitAgreeRetModal();
}

//权限控制是否可退按钮可操作！
function SetButAutty() {
    var Params = gGroupId + "^" + gLocId + "^" + gUserID + "^" + gHospID;
    var ParamStr = tkMakeServerCall("web.DHCINPHA.MTCommon.PublicServiceMethod", "GetParamProp", Params);
    var IfAgreeReturn = ParamStr.split("^")[4];
    if (IfAgreeReturn != "Y") {
        $("#btn-agreeret").attr({
            "disabled": "disabled"
        });
    }
}

//初始化处方列表table
function InitGridPrescList() {
    var columns = [{
            name: "TPhac",
            index: "TPhac",
            header: 'TPhac',
            width: 10,
            hidden: true
        },
        {
            name: "TWardLocId",
            index: "TWardLocId",
            header: 'TWardLocId',
            width: 10,
            hidden: true
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
            width: 100
        },
        {
            name: "TPatName",
            index: "TPatName",
            header: '姓名',
            width: 140
        },
        {
            name: "TPrescNo",
            index: "TPrescNo",
            header: '处方号',
            width: 120
        },
        {
            name: "TPrescForm",
            index: "TPrescForm",
            header: '处方剂型',
            width: 80
        },
        {
            name: "TFactor",
            index: "TFactor",
            header: '付数',
            width: 50
        },
        {
            name: "TPrescCount",
            index: "TPrescCount",
            header: '味数',
            width: 50
        },
        {
            name: "TOptorType",
            index: "TOptorType",
            header: '调剂方式',
            width: 70
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
            header: '提交日期',
            width: 150
        },
        {
            name: "TmonitorName",
            index: "TmonitorName",
            header: '审核药师',
            width: 100
        },
        {
            name: "TmonitorDateTime",
            index: "TmonitorDateTime",
            header: '审核日期',
            width: 150
        },
        {
            name: "TOperatorUser",
            index: "TOperatorUser",
            header: '调剂人',
            width: 100
        },
        {
            name: "TOperatorDate",
            index: "TOperatorDate",
            header: '调剂日期',
            width: 150
        },
        {
            name: "TCollectUser",
            index: "TCollectUser",
            header: '发药人',
            width: 100
        },
        {
            name: "TCollectDate",
            index: "TCollectDate",
            header: '发药日期',
            width: 150
        },
        {
            name: "TAgreeRetFlag",
            index: "TAgreeRetFlag",
            header: '可退标志',
            width: 70
        },
        {
            name: "TAgreeRetUser",
            index: "TAgreeRetUser",
            header: '置可退人',
            width: 100
        },
        {
            name: "TAgreeRetDate",
            index: "TAgreeRetDate",
            header: '置可退日期',
            width: 150
        },
        {
            name: "TAgreeRetRemark",
            index: "TAgreeRetRemark",
            header: '置可退备注',
            width: 200
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=jsQueryAlrDispPrescList', //查询后台	
        height: DhcphaJqGridHeight(1, 1),
        fit: true,
        multiselect: false,
        shrinkToFit: false,
        rownumbers: true,
        datatype: "local",
        pager: "#jqGridPager", //分页控件的id  
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
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=jsQueryDispAdmList', //查询后台
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
            name: "TPhac",
            index: "TPhac",
            header: 'TPhac',
            width: 10,
            hidden: true
        },
        {
            name: "TWardLocId",
            index: "TWardLocId",
            header: 'TWardLocId',
            width: 10,
            hidden: true
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
            width: 100
        },
        {
            name: "TPatName",
            index: "TPatName",
            header: '姓名',
            width: 140
        },
        {
            name: "TPrescNo",
            index: "TPrescNo",
            header: '处方号',
            width: 120
        },
        {
            name: "TPrescForm",
            index: "TPrescForm",
            header: '处方剂型',
            width: 80
        },
        {
            name: "TFactor",
            index: "TFactor",
            header: '付数',
            width: 50
        },
        {
            name: "TPrescCount",
            index: "TPrescCount",
            header: '味数',
            width: 50
        },
        {
            name: "TOptorType",
            index: "TOptorType",
            header: '调剂方式',
            width: 70
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
            header: '提交日期',
            width: 150
        },
        {
            name: "TmonitorName",
            index: "TmonitorName",
            header: '审核药师',
            width: 100
        },
        {
            name: "TmonitorDateTime",
            index: "TmonitorDateTime",
            header: '审核日期',
            width: 150
        },
        {
            name: "TOperatorUser",
            index: "TOperatorUser",
            header: '调剂人',
            width: 100
        },
        {
            name: "TOperatorDate",
            index: "TOperatorDate",
            header: '调剂日期',
            width: 150
        },
        {
            name: "TCollectUser",
            index: "TCollectUser",
            header: '发药人',
            width: 100
        },
        {
            name: "TCollectDate",
            index: "TCollectDate",
            header: '发药日期',
            width: 150
        },
        {
            name: "TAgreeRetFlag",
            index: "TAgreeRetFlag",
            header: '可退标志',
            width: 70
        },
        {
            name: "TAgreeRetUser",
            index: "TAgreeRetUser",
            header: '置可退人',
            width: 100
        },
        {
            name: "TAgreeRetDate",
            index: "TAgreeRetDate",
            header: '置可退日期',
            width: 150
        },
        {
            name: "TAgreeRetRemark",
            index: "TAgreeRetRemark",
            header: '置可退备注',
            width: 200
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery&MethodName=jsQueryAlrDispPrescList', //查询后台	
        height: DhcphaJqGridHeight(2, 3) * 0.6,
        fit: true,
        multiselect: false,
        shrinkToFit: false,
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
        }
    };
    $('#grid-admpresclist').dhcphaJqGrid(jqOptions);
}

function ClearConditons() {
    $('#grid-presclist').clearJqGrid();
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
    //ClearConditons();
    var params = GetMainCodParams();
    if (NowTAB == "#div-presc-condition") {
        var wardloc = $('#sel-phaward').val();
        if (wardloc == null) {
            wardloc = ""
        };
        params = params + "^" + wardloc;
        $("#grid-presclist").setGridParam({
            datatype: 'json',
            page: 1,
            postData: {
                'params': params
            }
        }).trigger("reloadGrid");
    } else {
        var patno = $("#txt-patno").val();
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
    var prescno = GetSelPrescNo();
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

//获取左侧选中的处方号
function GetSelPrescNo() {
    if (NowTAB == "#div-presc-condition") {
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var prescno = selrowdata.TPrescNo;
    return prescno;
}
//获取左侧选中的处方号
function GetSelAgreeRetFlag() {
    if (NowTAB == "#div-presc-condition") {
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var agreeFlag = selrowdata.TAgreeRetFlag;
    return agreeFlag;
}

//重打草药标签
function RePrintLabel() {
    var prescno = GetSelPrescNo();
    var PhacRowid = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery", "GetPhacByPres", prescno);
    if (PhacRowid != "") {
        PrintDispSheet(PhacRowid, "1");
    }
}

//填写置可退的原因
function InitAgreeRetModal() {
    $("#btn-agreeret-sure").on("click", function () {
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
            dhcphaMsgBox.alert("已发处方列表无数据!");
            return;
        }
        var phacid = selrowdata.TPhac;
        if ((phacid == "") || (phacid == null)) {
            dhcphaMsgBox.alert("请先选择需要置可退的处方!");
            return;
        }
        var agrretremark = $.trim($('#txt-agrretremark').val());
        $("#modal-agreereturn").modal('hide');
        var ParamData = phacid + "^" + gUserID + "^" + agrretremark;
        var RetResult = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery", "SaveAgreeRet", ParamData);
        var RetCode = RetResult.split("^")[0];
        var RetMessage = RetResult.split("^")[1];
        if (RetCode != "0") {
            dhcphaMsgBox.alert(RetMessage);
            return;
        } else {
            dhcphaMsgBox.alert("该处方置为可退成功!", "success");
            QueryInPhDispList();
        }

    });
}

//点击可退药按钮触发的方法
function SaveAgreeRet() {
    var prescno = GetSelPrescNo();
    if ((prescno == "") || (prescno == null)) {
        dhcphaMsgBox.alert("请先选择需要置可退的处方!");
        return;
    }
    if (GetSelAgreeRetFlag() == "Y") {
        dhcphaMsgBox.alert("该处方已经置为可退，无需再次操作!");
        return;
    }
    $('#modal-agreereturn').modal('show');
    $('#txt-agrretremark').text("");
    var timeout = setTimeout(function () {
        $(window).focus();
        $('#txt-agrretremark').focus();
    }, 500);
}

///给第三方重新推送数据
function ReSendMechine() {
    if (NowTAB == "#div-presc-condition") {
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    var pharowid = selrowdata.TPhac;
    if ((pharowid == "") || (pharowid == null)) {
        dhcphaMsgBox.alert("该处方药房还未发，不能推送!");
        return;
    }
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaLoc = ""
    }
    if (phaloc == "") {
        dhcphaMsgBox.alert("药房不允许为空!");
        return;
    }
    var configstr = tkMakeServerCall("web.DHCSTPHALOC", "GetPhaflag", phaloc);
    var configarr = configstr.split("^");
    var SendFlag = configarr[31];
    if (SendFlag == "Y") {
        var sendret = tkMakeServerCall("web.DHCSTInterfacePH", "SendOrderToMechine", pharowid);
        if (sendret != 0) {
            var retString = sendret.split("^")[1];
            dhcphaMsgBox.alert("发送包药机失败,错误代码:" + retString, "error");
            return;
        }
    }
}

function splitFormatter(cellvalue, options, rowObject) {
    if (cellvalue.indexOf("-") >= 0) {
        cellvalue = cellvalue.split("-")[1];
    }
    return cellvalue;
};
window.onresize = ResizeHMPrescDispQuery;
function ResizeHMPrescDispQuery(){
    var wardtitleheight = $("#gview_grid-presclist .ui-jqgrid-hbox").height();
    var wardheight = DhcphaJqGridHeight(1, 1) - wardtitleheight - 32;
    var prescheight = DhcphaJqGridHeight(1, 0) - 17;
    var admpressheight = DhcphaJqGridHeight(2, 1)*0.5 -47 ; ;
        //alert("admpressheight:"+admpressheight)
    $("#grid-presclist").setGridHeight(wardheight).setGridWidth("");
    $("#ifrm-presc").height(prescheight);
    $("#grid-admlist").setGridHeight(admpressheight).setGridWidth("");
    $("#grid-admpresclist").setGridHeight(admpressheight).setGridWidth("");
    
}
