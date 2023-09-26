/**
 * 模块:	移动药房
 * 子模块:	移动药房-护士取药发药界面
 * Creator:	hulihua
 * CreateDate:	2017-04-06
 */
var takenurseid = ""; //取药护士工号
var collectuserid = ""; //发药人工号
var phdrrowidstr = ""; //左侧选择的备药ID串
var wardrowidstr = ""; //左侧选择的备药病区串
DhcphaTempBarCode = "";

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
    InitThisLocInci(); //药品
    InitGridDispWardDraw(); //初始化备药单列表
    InitDispTotalList(); //初始化发药汇总
    InitDispDetailList(); //初始化发药明细

    /* 表单元素事件 start*/
    //卡号回车触发事件
    $('#txt-cardno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            SetUserInfo();
        }
    });

    //关联单号回车触发查询事件
    $('#txt-connectno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            QueryInPhDrawDispList();
            $('#txt-connectno').val("");
            DhcphaTempBarCode = "";
        }
    });

    //护士工号回车触发事件
    $('#txt-nurseno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            SetNurseInfo();
        }
    });

    //登记号回车事件
    $('#txt-regno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#txt-regno").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                QueryInDrawDetail();
            }
        }
    });

    //屏蔽所有回车事件
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })

    InitBodyStyle();
    document.onkeydown = OnKeyDownHandler;
})

window.onload = function () {
    setTimeout("QueryInPhDrawDispList()", 200);
    DhcphaTempBarCode = "";
}

//扫描或者输入工号之后验证以及填充界面
function SetUserInfo() {
    var cardno = $.trim($("#txt-cardno").val());
    $('#fyusername').text("");
    if (cardno != "") {
        var defaultinfo = tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod", "GetUserDefaultInfo", cardno);
        if (defaultinfo == null || defaultinfo == "") {
            dhcphaMsgBox.alert("输入工号有误，请核实!");
            $('#txt-cardno').val("");
            return;
        }
        var ss = defaultinfo.split("^");
        collectuserid = ss[0];
        $('#fyusername').text(ss[2]);
        $('#txt-cardno').val("");
        ConfirmDisp();
    }
}

//扫描护士工号之后验证以及填充界面
function SetNurseInfo() {
    var nurseno = $.trim($("#txt-nurseno").val());
    takenurseid = "";
    $('#currentnurse').text("");
    $('#currentctloc').text("");
    if (nurseno != "") {
        var defaultinfo = tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod", "GetUserDefaultInfo", nurseno);
        if (defaultinfo == null || defaultinfo == "") {
            dhcphaMsgBox.alert("输入工号有误，请核实!");
            $('#txt-nurseno').val("");
            return;
        }
        var ss = defaultinfo.split("^");
        takenurseid = ss[0];
        $('#currentnurse').text(ss[2]);
        $('#currentctloc').text(ss[4]);
        $('#txt-nurseno').val("");
    }
}

function DispQuery() {
    var lnk = "dhcpha/dhcpha.inpha.dispquery.csp";
    websys_createWindow(lnk, "已发药查询", "width=95%,height=90%")
}

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
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    $("#date-start").data('daterangepicker').setStartDate(startdate + ' 00:00:00');
    $("#date-start").data('daterangepicker').setEndDate(startdate + ' 00:00:00');
    $("#date-end").data('daterangepicker').setStartDate(enddate + ' 23:59:59');
    $("#date-end").data('daterangepicker').setEndDate(enddate + ' 23:59:59');
    InitTakeDrugUserModal();
    $("#sel-locinci").empty();
}

//初始病区备药单列表table
function InitGridDispWardDraw() {
    var columns = [{
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
            name: "TPhdrID",
            index: "TPhdrID",
            header: 'TPhdrID',
            width: 10,
            hidden: true
        },
        {
            name: "TPhdrNo",
            index: "TPhdrNo",
            header: '备药单号',
            width: 120
        },
        {
            name: "TPhdrDateComp",
            index: "TPhdrDateComp",
            header: '完成日期',
            width: 140
        },
        {
            name: "TPhdrUserComp",
            index: "TPhdrUserComp",
            header: '备药完成人',
            width: 120
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery&MethodName=GetInPhDrawDispList', //查询后台	
        height: DhcphaJqGridHeight(1, 1) - 35,
        multiselect: false,
        shrinkToFit: false,
        datatype: "local",
        onSelectRow: function (id, status) {
            var id = $(this).jqGrid('getGridParam', 'selrow');
            KillDetailTmp();
            $('#usercompname').text("");
            $("#grid-dispdetail").jqGrid("clearGridData");
            if (id == null) {
                $('#grid-disptotal').clearJqGrid();
                $('#grid-dispdetail').clearJqGrid();
            } else {
                QueryInDispTotal();
            }
        }
    };
    $('#grid-wardinphreqlist').dhcphaJqGrid(jqOptions);
}

//初始化发药汇总table
function InitDispTotalList() {
    var columns = [{
            name: "TPID",
            index: "TPID",
            header: 'TPID',
            width: 100,
            align: 'left',
            hidden: true
        },
        {
            name: 'TCollStat',
            index: 'TCollStat',
            header: '数量状态',
            width: 80,
            cellattr: addCollStatCellAttr
        },
        {
            name: "TDesc",
            index: "TDesc",
            header: '药品名称',
            width: 200,
            align: 'left'
        },
        {
            name: "TActDispQty",
            name: "TActDispQty",
            header: '实发数量',
            width: 80,
            align: 'right'
        },
        {
            name: "TDspQty",
            name: "TDspQty",
            header: '申请数量',
            width: 80,
            align: 'right'
        },
        {
            name: "TPhdQty",
            name: "TPhdQty",
            header: '备药数量',
            width: 80,
            align: 'right'
        },
        {
            name: "TRefuseQty",
            name: "TRefuseQty",
            header: '拒绝数量',
            width: 80,
            align: 'right'
        },
        {
            name: "TDspQty",
            name: "TCalDspQty",
            header: '撤销数量',
            width: 80,
            align: 'right'
        },
        {
            name: "TReturnQty",
            name: "TReturnQty",
            header: '撤回数量',
            width: 80,
            align: 'right'
        },
        {
            name: "TUom",
            name: "TUom",
            header: '单位',
            width: 60
        },
        {
            name: "TDrugForm",
            name: "TDrugForm",
            header: '剂型',
            width: 100
        },
        {
            name: "TSpec",
            name: "TSpec",
            header: '规格',
            width: 100
        },
        {
            name: "TManf",
            name: "TManf",
            header: '厂家',
            width: 150,
            align: 'left',
            formatter: splitFormatter
        },
        {
            name: "TStkBin",
            name: "TStkBin",
            header: '货位',
            width: 100,
            align: 'left'
        },
        {
            name: "TGeneric",
            name: "TGeneric",
            header: '通用名',
            width: 150,
            align: 'left'
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery&MethodName=GetQueryDispList&querytype=total',
        height: DhcphaJqGridHeight(2, 1) - 42,
        multiselect: false,
        shrinkToFit: false,
        datatype: 'local',
        onSelectRow: function (id, status) {

        }
    };
    $('#grid-disptotal').dhcphaJqGrid(jqOptions);
}

//初始化发药明细table
function InitDispDetailList() {
    var columns = [{
            name: "TPID",
            index: "TPID",
            header: 'TPID',
            width: 80,
            hidden: true
        },
        {
            name: 'TCollStat',
            index: 'TCollStat',
            header: '数量状态',
            width: 65,
            cellattr: addCollStatCellAttr
        },
        {
            name: "TAdmLoc",
            index: "TAdmLoc",
            header: '科室',
            width: 125,
            formatter: splitFormatter,
            align: 'left'
        },
        {
            name: "TBedNo",
            index: "TBedNo",
            header: '床号',
            width: 80
        },
        {
            name: "TPatName",
            index: "TPatName",
            header: '姓名',
            width: 80
        },
        {
            name: "TPatNo",
            index: "TPatNo",
            header: '登记号',
            width: 80
        },
        {
            name: "TPatAge",
            index: "TPatAge",
            header: '年龄',
            width: 60
        },
        {
            name: "TPatSex",
            index: "TPatSex",
            header: '性别',
            width: 60
        },
        {
            name: "TArcimDesc",
            index: "TArcimDesc",
            header: '药品名称',
            width: 200,
            align: 'left'
        },
        {
            name: "TActDispQty",
            name: "TActDispQty",
            header: '实发数量',
            width: 50,
            align: 'right'
        },
        {
            name: "TDspQty",
            index: "TDspQty",
            header: '申请数量',
            width: 50,
            align: 'right'
        },
        {
            name: "TPhdQty",
            index: "TPhdQty",
            header: '备药数量',
            width: 50,
            align: 'right'
        },
        {
            name: "TRefuseQty",
            index: "TRefuseQty",
            header: '拒绝数量',
            width: 50,
            align: 'right'
        },
        {
            name: "TCancelQty",
            index: "TCancelQty",
            header: '撤销数量',
            width: 50,
            align: 'right'
        },
        {
            name: "TUom",
            index: "TUom",
            header: '单位',
            width: 50
        },
        {
            name: "TOrdStatus",
            index: "TOrdStatus",
            header: '医嘱状态',
            width: 60
        },
        {
            name: "TDoseQty",
            index: "TDoseQty",
            header: '剂量',
            width: 60
        },
        {
            name: "TFreq",
            index: "TFreq",
            header: '频率',
            width: 60
        },
        {
            name: "TInstruction",
            index: "TInstruction",
            header: '用法',
            width: 80
        },
        {
            name: "TDuration",
            index: "TDuration",
            header: '疗程',
            width: 80
        },
        {
            name: "TPrescNo",
            index: "TPrescNo",
            header: '处方号',
            width: 90
        },
        {
            name: "TOrdAuditResult",
            index: "TOrdAuditResult",
            header: '医嘱审核',
            width: 80
        },
        {
            name: "TGeneric",
            index: "TGeneric",
            header: '通用名',
            width: 150
        },
        {
            name: "TForm",
            index: "TForm",
            header: '剂型',
            width: 100
        },
        {
            name: "TSpec",
            index: "TSpec",
            header: '规格',
            width: 80
        },
        {
            name: "TManf",
            index: "TManf",
            header: '厂家',
            width: 150,
            align: 'left',
            formatter: splitFormatter
        },
        {
            name: "TStkBin",
            index: "TStkBin",
            header: '货位码',
            width: 100
        },
        {
            name: "TUserAdd",
            index: "TUserAdd",
            header: '开方医生',
            width: 60
        },
        {
            name: "TDiagnose",
            index: "TDiagnose",
            header: '诊断',
            width: 300,
            align: 'left'
        },
        {
            name: "TSkinTest",
            index: "Taction",
            header: '备注',
            width: 80
        },
        {
            name: "TDataDosing",
            index: "TDataDosing",
            header: '分发日期',
            width: 80
        },
        {
            name: "TTimeDosing",
            index: "TTimeDosing",
            header: '分发时间',
            width: 120
        },
        {
            name: "TCookType",
            index: "TCookType",
            header: '煎药方式',
            width: 80,
            hidden: true
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery&MethodName=GetQueryDispList&querytype=detail',
        height: DhcphaJqGridHeight(2, 2) - 58,
        multiselect: false,
        shrinkToFit: false,
        datatype: 'local',
        pager: "#jqGridPager1", //分页控件的id  
        onSelectRow: function (id, status) {

        }
    };
    $('#grid-dispdetail').dhcphaJqGrid(jqOptions);
    $("#refresh_grid-dispdetail").hide(); //此处刷新先屏蔽
}

//初始化药品选择
function InitThisLocInci() {
    var phaloc = $('#sel-phaloc').val();
    var locincioptions = {
        id: "#sel-locinci",
        locid: phaloc
    }
    InitLocInci(locincioptions)
}

function ChangeDispQuery() {
    var Pid = "";
    if ($("#sp-title").text() == "发药汇总") {
        $("#sp-title").text("发药明细");
        $("#div-total").hide();
        $("#div-detail").show();
        if ($("#grid-dispdetail").getGridParam('records') == 0) {
            if ($("#grid-disptotal").getGridParam('records') > 0) {
                var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
                Pid = firstrowdata.TPID
            }
            QueryInDispTotal(Pid);
        }
    } else {
        $("#sp-title").text("发药汇总")
        $("#div-detail").hide();
        $("#div-total").show(); //每次点击汇总都要重新汇总
        if ($("#grid-dispdetail").getGridParam('records') > 0) {
            var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
            Pid = firstrowdata.TPID
        }
        QueryInDispTotal(Pid);
    }
}

//查询待发药备药单
function QueryInPhDrawDispList() {

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
    var wardloc = $('#sel-phaward').val();
    if (wardloc == null) {
        wardloc = ""
    }
    var phrstatus = "30"; //药房备药完成
    var phrtypestr = "2"; //2-取药
    var connectno = $('#txt-connectno').val();
    if (connectno != "") {
        var checkconnectno = tkMakeServerCall("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery", "CheckConnectNo", connectno, phaloc);
        if (checkconnectno == "") {
            dhcphaMsgBox.alert("该标签还未完成备药或者已经作废，请核实!");
            return;
        }
    }

    var params = startdate + "^" + starttime + "^" + enddate + "^" + endtime + "^" + phaloc + "^" + wardloc + "^" + phrstatus + "^" + phrtypestr + "^" + connectno;
    $("#grid-wardinphreqlist").setGridParam({
        datatype: 'json',
        page: 1,
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
    ClearConditons();
}

function QueryInDrawDetail() {
    KillDetailTmp();
    QueryInDispTotal("");
    //$("#txt-regno").val("");
}

function QueryInDispTotal(Pid) {
    if (Pid == undefined) {
        Pid = "";
    }
    var params = GetQueryDispParams();
    if (params != "") {
        if ($("#div-detail").is(":hidden") == false) {
            $("#grid-dispdetail").setGridParam({
                datatype: 'json',
                page: 1,
                postData: {
                    params: params,
                    ProcessId: Pid
                }
            }).trigger("reloadGrid");
        } else {
            $("#grid-disptotal").setGridParam({
                datatype: 'json',
                page: 1,
                postData: {
                    params: params,
                    ProcessId: Pid
                }
            }).trigger("reloadGrid");
        }
    }
}

//发药人,摆药人选择
function InitTakeDrugUserModal() {
    $("#btn-takenurse-sure").on("click", function () {
        if ((takenurseid == "") || (takenurseid == null)) {
            dhcphaMsgBox.alert("取药人不能为空，请扫描取药人!");
            return;
        }
        $("#modal-inphaphauser").modal('hide');
        var dispoptions = {
            takenurseid: takenurseid
        }
        ExecuteDisp(dispoptions);
    });
}

//发药
function ConfirmDisp() {
    DhcphaTempBarCode = "";
    var warnflag = "";
    if ($("#sp-title").text() == "发药明细") {
        if (DhcphaGridIsEmpty("#grid-dispdetail") == true) {
            return;
        } else {
            var dispgridrows = $("#grid-dispdetail").getGridParam('records');
            if (dispgridrows < 1) {
                dhcphaMsgBox.alert("请先选择需要发药的备药单!");
                return;
            }
            for (var i = 1; i <= dispgridrows; i++) {
                var tmpselecteddata = $("#grid-dispdetail").jqGrid('getRowData', i);
                var tmpcollstat = tmpselecteddata["TCollStat"];
                if (tmpcollstat.indexOf("撤销") >= 0) {
                    warnflag = "1";
                    break;
                }
            }
        }
    } else if ($("#sp-title").text() == "发药汇总") {
        if (DhcphaGridIsEmpty("#grid-disptotal") == true) {
            return;
        } else {
            var dispgridrows = $("#grid-disptotal").getGridParam('records');
            if (dispgridrows < 1) {
                dhcphaMsgBox.alert("请先选择需要发药的备药单!");
                return;
            }
            for (var i = 1; i <= dispgridrows; i++) {
                var tmpselecteddata = $("#grid-disptotal").jqGrid('getRowData', i);
                var tmpcollstat = tmpselecteddata["TCollStat"];
                if (tmpcollstat.indexOf("撤销") >= 0) {
                    warnflag = "1";
                    break;
                }
            }

        }
    }
    if (collectuserid == "") {
        dhcphaMsgBox.alert("发药人不能为空，请扫描发药人!");
        if (CheckTxtFocus() == true) {
            $("#txt-cardno").focus();
        }
        return;
    }
    if (warnflag == "1") {
        if (confirm("所选备药单申请数量与备药数量不符，请核实是否有撤销请领或拒绝发药的药品") == false) {
            return;
        }
    }
    dhcphaMsgBox.confirm("发药人为  <b><font color=#CC1B04 size=6 >" + $('#fyusername').text() + "</font></b>，是否确认发药?", DoDisp);
}

function DoDisp(result) {
    if (result == true) {
        $('#modal-inphaphauser').modal('show');
        $('#currentnurse').text("");
        $('#currentctloc').text("");
        takenurseid = "";
        var timeout = setTimeout(function () {
            $(window).focus();
            if (CheckTxtFocus() != true) {
                $("#txt-nurseno").focus();
                return true;
            }
        }, 500);
    }
}

function ExecuteDisp(dispoptions) {
    var pid = "";
    var phacrowidStr = ""
    if ($("#sp-title").text() == "发药明细") {
        var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
        pid = firstrowdata.TPID
    } else if ($("#sp-title").text() == "发药汇总") {
        var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
        pid = firstrowdata.TPID
    }
    var phaloc = $("#sel-phaloc").val();
    var takedruguserid = dispoptions.takenurseid;
    var pwardrowidstr = filterRepeatStr(wardrowidstr);
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var enddate = enddatetime.split(" ")[0];
    var phactype = "2"; //1-送药，2-取药
    var params = phaloc + "^" + collectuserid + "^" + takedruguserid + "^" + startdate + "^" + enddate + "^" + phactype;

    var wardArr = pwardrowidstr.split(",");
    for (var wardi = 0; wardi < wardArr.length; wardi++) {
        var wardid = wardArr[wardi];
        var wardphdrstr = tkMakeServerCall("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery", "GetWardPhdrStr", wardid, phdrrowidstr);
        if (wardphdrstr == "") {
            continue;
        }
        var PhacRowid = tkMakeServerCall("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery", "SaveDispData", pid, wardid, params, wardphdrstr);
        if (PhacRowid > 0) {
            if (phacrowidStr != "") {
                phacrowidStr = phacrowidStr + "A" + PhacRowid;
            } else {
                phacrowidStr = PhacRowid;
            }
        } else if (PhacRowid < 0) {
            alert("发药失败," + PhacRowid);
        }
    }
    if ((phacrowidStr == "") || (phacrowidStr == 0)) {
        dhcphaMsgBox.alert("未发出药品!");
        return;
    }
    KillDetailTmp();
    QueryInPhDrawDispList();
    QueryInDispTotal();
}

function ClearConditons() {
    //$('#grid-wardinphreqlist').clearJqGrid(); 
    KillDetailTmp();
    $('#grid-disptotal').clearJqGrid();
    $('#grid-dispdetail').clearJqGrid();
    DhcphaTempBarCode = "";
}

function InitBodyStyle() {
    $('#div-conditions').collapse('show');
    $('#div-conditions').on('hide.bs.collapse', function () {
        var tmpheight = DhcphaJqGridHeight(2, 1) - 40;
        tmpheight = tmpheight + $("#div-conditions").height();
        $("#grid-disptotal").setGridHeight(tmpheight);
    })
    $('#div-conditions').on('show.bs.collapse', function () {
        var tmpheight = DhcphaJqGridHeight(2, 1) - 40;
        $("#grid-disptotal").setGridHeight(tmpheight);
    })
    $("#grid-disptotal").setGridWidth("");
    $("#grid-dispdetail").setGridWidth("");
    $("#div-detail").hide();
    var wardtitleheight = $("#gview_grid-wardinphreqlist .ui-jqgrid-hbox").height();
    var wardheight = DhcphaJqGridHeight(1, 0) - wardtitleheight - 10;
    $("#grid-wardinphreqlist").setGridHeight(wardheight);
    $("#tab-patno").hide();
}

//病区单选
function GetQueryDispParams() {
    phdrrowidstr = "";
    wardrowidstr = "";
    if ($("div-wardinphreq-condition").is(":hidden") == false) {
        var selectid = $("#grid-wardinphreqlist").jqGrid('getGridParam', 'selrow');
        if ((selectid == "") || (selectid == null)) {
            $('#grid-disptotal').clearJqGrid();
            $('#grid-dispdetail').clearJqGrid();
            return "";
        }

        var selrowdata = $("#grid-wardinphreqlist").jqGrid('getRowData', selectid);
        var usercomp = selrowdata.TPhdrUserComp;
        $('#usercompname').text(usercomp);
        phdrrowidstr = selrowdata.TPhdrID;
        wardrowidstr = selrowdata.TWardLocId;
    } else {
        dhcphaMsgBox.alert("请刷新界面后重试!");
        return "";
    }
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaloc = ""
    }
    if (phaloc == "") {
        dhcphaMsgBox.alert("药房不允许为空!");
        return "";
    }
    var incirowid = $("#sel-locinci").val()
    if (incirowid == null) {
        incirowid = ""
    }
    var phrstatus = "30";
    var patno = $("#txt-regno").val();

    var params = phdrrowidstr + "^" + phrstatus + "^" + incirowid + "^" + phaloc + "^" + patno;
    return params;
}

//病区多选
function GetQueryDispParamsD() {
    phdrrowidstr = "";
    wardrowidstr = "";
    if ($("div-wardinphreq-condition").is(":hidden") == false) {
        var selectids = $("#grid-wardinphreqlist").jqGrid('getGridParam', 'selarrrow');
        if ((selectids == "") || (selectids == null)) {
            $('#grid-disptotal').clearJqGrid();
            $('#grid-dispdetail').clearJqGrid();
            return "";
        }
        $.each(selectids, function () {
            var selrowdata = $("#grid-wardinphreqlist").jqGrid('getRowData', this);
            var usercomp = selrowdata.TPhdrUserComp;
            $('#usercompname').text(usercomp);
            var phdrrowid = selrowdata.TPhdrID;
            var wardrowid = selrowdata.TWardLocId;
            if (phdrrowidstr == "") {
                phdrrowidstr = phdrrowid;
                wardrowidstr = wardrowid;
            } else {
                phdrrowidstr = phdrrowidstr + "#" + phdrrowid;
                wardrowidstr = wardrowidstr + "," + wardrowid;
            }
        })
    } else {
        dhcphaMsgBox.alert("请刷新界面后重试!");
        return "";
    }
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaloc = ""
    }
    if (phaloc == "") {
        dhcphaMsgBox.alert("药房不允许为空!");
        return "";
    }
    var incirowid = $("#sel-locinci").val()
    if (incirowid == null) {
        incirowid = ""
    }
    var phrstatus = "30";
    var patno = $("#txt-regno").val();

    var params = phdrrowidstr + "^" + phrstatus + "^" + incirowid + "^" + phaloc + "^" + patno;
    return params;
}

function splitFormatter(cellvalue, options, rowObject) {
    if (cellvalue.indexOf("-") >= 0) {
        cellvalue = cellvalue.split("-")[1];
    }
    return cellvalue;
}

//字符串去重！
function filterRepeatStr(str) {
    var ar2 = str.split(",");
    var array = new Array();
    var j = 0
    for (var i = 0; i < ar2.length; i++) {
        if ((array == "" || array.toString().match(new RegExp(ar2[i], "g")) == null) && ar2[i] != "") {
            array[j] = ar2[i];
            array.sort();
            j++;
        }
    }
    return array.toString();
}

function addCollStatCellAttr(rowId, val, rawObject, cm, rdata) {
    if (val.indexOf("撤销") >= 0) {
        return "class=dhcpha-record-dispense";
    } else if (val.indexOf("拒撤互抵") >= 0) {
        return "class=dhcpha-record-appeal";
    } else if (val.indexOf("仅拒绝") >= 0) {
        return "class=dhcpha-record-refused";
    } else {
        return "";
    }
}

function KillDetailTmp() {
    var Pid = "";
    if ($("#sp-title").text() == "发药汇总") {
        if ($("#grid-disptotal").getGridParam('records') > 0) {
            var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
            Pid = firstrowdata.TPID;
        }
    } else {
        if ($("#grid-dispdetail").getGridParam('records') > 0) {
            var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
            Pid = firstrowdata.TPID
        }
    }
    if (Pid != "") {
        tkMakeServerCall("web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery", "KillTmp", Pid);
    }
}

function CheckTxtFocus() {
    var txtfocus1 = $("#txt-cardno").is(":focus");
    var txtfocus2 = $("#txt-connectno").is(":focus");
    var txtfocus3 = $("#txt-nurseno").is(":focus");
    if ((txtfocus1 != true) && (txtfocus2 != true) && (txtfocus3 != true)) {
        return false;
    }
    return true;
}

//监听keydown,用于定位扫描枪扫完后给值
function OnKeyDownHandler() {
    if (CheckTxtFocus() != true) {
        if (event.keyCode == 13) {
            var BarCode = tkMakeServerCall("web.DHCST.Common.JsonObj", "GetData", DhcphaTempBarCode);
            if (BarCode.indexOf("Y") > -1) {
                $("#txt-connectno").val(BarCode);
                QueryInPhDrawDispList();
                $("#txt-connectno").val("");
            } else {
                $("#txt-cardno").val(BarCode);
                SetUserInfo();
            }
            DhcphaTempBarCode = "";
        } else {
            DhcphaTempBarCode += String.fromCharCode(event.keyCode);
        }
    }
}

window.onbeforeunload = function () {
    KillDetailTmp();
}