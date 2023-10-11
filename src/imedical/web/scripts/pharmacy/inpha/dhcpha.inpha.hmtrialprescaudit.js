/*
模块:		中药房
子模块:		中药房-住院草药审方
Creator:	hulihua
CreateDate:	2018-12-19
*/
var NowTAB = "#div-presc-condition"; // 记录当前tab
var AppType = "IA";
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 20 * 1000;
DHCPHA_CONSTANT.URL.THIS_URL = ChangeCspPathToAll("dhcpha.outpha.outmonitor.save.csp");

var MONITOR_PROP_STR=tkMakeServerCall("web.DHCINPHA.InfoCommon", "GetMonitorPropStr", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
var MONITOR_PROP_ARR=MONITOR_PROP_STR.split("^");
var RePassNeedCancle = MONITOR_PROP_ARR[1];
var PatientInfo = {
    adm: 0,
    patientID: 0,
    episodeID: 0,
    admType: "I",
    prescno: 0,
    orditem: 0,
    wardid: 0
};
$(function () {
    InitPhaConfig();
    /* 初始化插件 start*/
    var daterangeoptions = {
        singleDatePicker: true
    }
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
                QueryGridPrescAudit();
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

    $("#chk-audit").on("ifChanged", function () {
        QueryGridPrescAudit()
    })

    InitIPOrderModalTab();
    InitBodyStyle();
})

window.onload = function () {
    if (LoadPatNo == "") {
        // 菜单进入
        setTimeout("QueryGridPrescAudit()", 500);
    } else {
        // 消息进入
        $("#tab-ipmonitor a").click();
        $("#txt-patno").val(LoadPatNo);
        InitParams();
        setTimeout("QueryGridPrescAudit()", 500);
    }
}
function InitParams(){
	if(LoadOrdItmId==""){return;}
	var retVal=tkMakeServerCall("PHA.COM.Method","GetOrdItmInfoForTipMess",LoadOrdItmId);
    if(retVal!="{}"){
	    var retJson=JSON.parse(retVal)
		var ordDate=retJson.ordDate;
		 $("#date-start").data('daterangepicker').setStartDate(ordDate);
		 $("#date-start").data('daterangepicker').setEndDate(ordDate);
	}
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
    var startdate = configarr[2];
    var enddate = configarr[3];
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    $("#date-start").data('daterangepicker').setStartDate(startdate);
    $("#date-start").data('daterangepicker').setEndDate(startdate);
    $("#date-end").data('daterangepicker').setStartDate(enddate);
    $("#date-end").data('daterangepicker').setEndDate(enddate);
    $("#sel-locinci").empty();
}

//初始化处方列表table
function InitGridPrescList() {
    var columns = [{
            name: 'druguse',
            index: 'druguse',
            header: '分析结果',
            width: 65,
            formatter: druguseFormatter
        },
        {
            name: "TAuditResult",
            index: "TAuditResult",
            header: '审方结果',
            width: 62,
            cellattr: addPhDispStatCellAttr
        },{
            name: "TDispState",
            index: "TDispState",
            header: '发药状态',
            width: 62,
            hidden: true
        },
        {
            name: "TPrescEmergen",
            index: "TPrescEmergen",
            header: '是否加急',
            width: 70,
            cellattr: addStatCellAttr,
            formatter: function(value, options, rowdata){
				if(value == "Y"){
					return "是";	
				}else{
					return "否";	
				}
			}
        },
        {
            name: "TWardLoc",
            index: "TWardLoc",
            header: '病区',
            width: 160,
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
            width: 155
        },
        {
            name: "TPhaomName",
            index: "TPhaomName",
            header: '审核药师',
            width: 100
        },
        {
            name: "TPhaomDate",
            index: "TPhaomDate",
            header: '审核时间',
            width: 155
        },
        {
            name: "TRefResult",
            index: "TRefResult",
            header: '拒绝理由',
            width: 300,
            align: 'left'
        },
        {
            name: "TDocNote",
            index: "TDocNote",
            header: '申诉理由',
            width: 300,
            align: 'left'
        },
        {
            name: "TWardLocId",
            index: "TWardLocId",
            header: 'TWardLocId',
            width: 10,
            hidden: true
        },
        {
            name: "TAdmDr",
            index: "TAdmDr",
            header: 'TAdmDr',
            width: 10,
            hidden: true
        },
        {
            name: "TPapmiDr",
            index: "TPapmiDr",
            header: 'TPapmiDr',
            width: 10,
            hidden: true
        },
        {
            name: "TMoeori",
            index: "TMoeori",
            header: 'TMoeori',
            width: 10,
            hidden: true
        },
        {
            name: 'druguseresult',
            index: 'druguseresult',
            header: '合理分析结果',
            width: 65,
            hidden: true
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.HMPrescPhaAudit.PrescPhaAuditQuery&MethodName=jsGetInAuditPrescList', //查询后台	
        fit: true,
        multiselect: false,
        pager: "#jqGridPager", //分页控件的id
        shrinkToFit: false,
        rownumbers: true,
        datatype: "local",
        onSelectRow: function (id, status) {
            if (id) {
                var selrowdata = $(this).jqGrid('getRowData', id);
                PatientInfo.adm = selrowdata.TAdmDr;
                PatientInfo.patientID = selrowdata.TPapmiDr;
            }
            QueryGridDispSub()
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#ifrm-cypresc").attr("src", "");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        },
        gridComplete: function () {
            var ids = $("#grid-presclist").jqGrid("getDataIDs");
            var rowDatas = $("#grid-presclist").jqGrid("getRowData");
            for (var i = 0; i < rowDatas.length; i++) {
                var rowData = rowDatas[i];
                var warnLevel = rowData.TAuditResult;
                if (warnLevel.indexOf("申诉") >= 0) {
                    $("#grid-presclist" + " #" + ids[i] + " td").css({
                        color: '#FF0000',
                        'font-weight': 'bold'
                    });
                }
                var prescemergen = rowData.TPrescEmergen;
                if (prescemergen == "Y") {
                    $("#grid-presclist" + " #" + ids[i] + " td").css({
                        'color': '#000000',
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
        },
        {
            name: "TPapmi",
            index: "TPapmi",
            header: 'papmi',
            width: 80,
            align: 'left',
            hidden: true
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
                PatientInfo.adm = selrowdata.TAdm;
                PatientInfo.patientID = selrowdata.TPapmi;
                $("#grid-admpresclist").jqGrid("clearGridData");
                var params = GetMainCodParams();
                params = params + "^" + adm;
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
            name: 'druguse',
            index: 'druguse',
            header: '分析结果',
            width: 65,
            formatter: druguseFormatter
        },
        {
            name: "TAuditResult",
            index: "TAuditResult",
            header: '审方结果',
            width: 62
        },{
            name: "TDispState",
            index: "TDispState",
            header: '发药状态',
            width: 62,
            hidden: true
        },
        {
            name: "TPrescEmergen",
            index: "TPrescEmergen",
            header: '是否加急',
            width: 70,
            cellattr: addStatCellAttr,
            formatter: function(value, options, rowdata){
				if(value == "Y"){
					return "是";	
				}else{
					return "否";	
				}
			}
        },
        {
            name: "TWardLoc",
            index: "TWardLoc",
            header: '病区',
            width: 160,
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
            width: 155
        },
        {
            name: "TPhaomName",
            index: "TPhaomName",
            header: '审核药师',
            width: 100
        },
        {
            name: "TPhaomDate",
            index: "TPhaomDate",
            header: '审核时间',
            width: 155
        },
        {
            name: "TRefResult",
            index: "TRefResult",
            header: '拒绝理由',
            width: 300,
            align: 'left'
        },
        {
            name: "TDocNote",
            index: "TDocNote",
            header: '申诉理由',
            width: 300,
            align: 'left'
        },
        {
            name: "TWardLocId",
            index: "TWardLocId",
            header: 'TWardLocId',
            width: 10,
            hidden: true
        },
        {
            name: "TAdmDr",
            index: "TAdmDr",
            header: 'TAdmDr',
            width: 10,
            hidden: true
        },
        {
            name: "TPapmiDr",
            index: "TPapmiDr",
            header: 'TPapmiDr',
            width: 10,
            hidden: true
        },
        {
            name: "TMoeori",
            index: "TMoeori",
            header: 'TMoeori',
            width: 10,
            hidden: true
        },
        {
            name: 'druguseresult',
            index: 'druguseresult',
            header: '合理分析结果',
            width: 65,
            hidden: true
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.HMPrescPhaAudit.PrescPhaAuditQuery&MethodName=jsGetInAuditPrescList', //查询后台	
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
                $("#ifrm-cypresc").attr("src", "");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        },
        gridComplete: function () {
            var ids = $("#grid-admpresclist").jqGrid("getDataIDs");
            var rowDatas = $("#grid-admpresclist").jqGrid("getRowData");
            for (var i = 0; i < rowDatas.length; i++) {
                var rowData = rowDatas[i];
                var warnLevel = rowData.TAuditResult;
                if (warnLevel.indexOf("申诉") >= 0) {
                    $("#grid-admpresclist" + " #" + ids[i] + " td").css({
                        color: '#FF0000',
                        'font-weight': 'bold'
                    });
                }
                var prescemergen = rowData.TPrescEmergen;
                if (prescemergen == "Y") {
                    $("#grid-admpresclist" + " #" + ids[i] + " td").css({
                        color: '#000000',
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

function InitTrialDispTab() {
    $("#tab-ipmonitor a").on('click', function () {
        $("#ifrm-cypresc").empty();
        var tabId = $(this).attr("id");
        var tmpTabId = "#div-" + tabId.split("-")[1] + "-condition";
        $(tmpTabId).show();
        $("#monitor-condition").children().not(tmpTabId).hide();
        NowTAB = tmpTabId;
        QueryGridPrescAudit();
    })
}

function QueryGridPrescAudit() {
    if (NowTAB == "#div-presc-condition") {
        var params = GetMainCodParams();
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
    $("#ifrm-cypresc").empty();
    //var htmlstr = GetPrescHtml(prescno);
    //$("#ifrm-cypresc").append(htmlstr);
    GetPrescHtml(prescno);
}

function GetPrescHtml(prescNo) {
	var phartype = "IP";		// 住院类型
	var zfFlag = "底方"
	var useFlag = "2" 			// 处方审核
	var cyflag = "Y"

    PHA_PRESC.PREVIEW({
		prescNo: prescNo,			
		preAdmType: phartype,
		zfFlag: zfFlag,
		prtType: 'DISPPREVIEW',
		useFlag: useFlag,
		iframeID: 'ifrm-cypresc',
		cyFlag: cyflag
	});
    //$("#ifrm-cypresc").attr("src", ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp") + "?paramsstr=" + paramsstr + "&PrtType=DISPPREVIEW");
}

//获取查询条件
function GetMainCodParams() {
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
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
    };
    var chkaudit = "";
    if ($("#chk-audit").is(':checked')) {
        chkaudit = "Y";
    } else {
        chkaudit = "";
    }
    var params = startdate + "^" + enddate + "^" + phaloc + "^" + wardloc + "^" + chkaudit;
    return params;
}

function splitFormatter(cellvalue, options, rowObject) {
    if (cellvalue.indexOf("-") >= 0) {
        cellvalue = cellvalue.split("-")[1];
    }
    return cellvalue;
};

//审方通过
function PassIPOrder() {
    if (NowTAB == "#div-presc-condition") {
        var grid_records = $("#grid-presclist").getGridParam('records');
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var grid_records = $("#grid-admpresclist").getGridParam('records');
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    if (grid_records == 0) {
        dhcphaMsgBox.alert("处方列表没有数据!");
        return;
    }
    if ((selectid == "") || (selectid == null)) {
        dhcphaMsgBox.alert("请先选择需要审方通过的处方!");
        return;
    }
    var dispStatus = selrowdata.TDispState;
    if (dispStatus.indexOf("已发药")>-1) {
        dhcphaMsgBox.alert("该处方已经发药,不能审核通过!");
        return;
    }
    var auditresult = selrowdata.TAuditResult;
    if (auditresult.indexOf("接受")>-1) {
        dhcphaMsgBox.alert("该处方审方已经接受,不能审核通过!");
        return;
    }
    if(RePassNeedCancle=="Y"){
	    if (auditresult == "通过") {
	        dhcphaMsgBox.alert("您选择的处方已通过,不能再次审核通过 !");
	        return;
	    }
	    else if (auditresult.indexOf("拒绝") != "-1"){
		    dhcphaMsgBox.alert("您选择的处方已拒绝,需撤消之前的审核记录才能再次审核 !");
	        return;
		}
    }
    var PrescNo = selrowdata.TPrescNo;
    var resultstr = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery", "GetOrdStrByPrescno", PrescNo);
    var orditmstr = resultstr.split("&&")[0];
    if (orditmstr == "") {
        dhcphaMsgBox.alert("该处方没有有效明细信息!");
        return;
    }
    var orditemStr = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery", "GetOrdStrByPrescno", PrescNo);
    var orditem = orditemStr.split("&&")[1];
    var ret = "Y";
    var reasondr = "";
    var advicetxt = "";
    var factxt = "";
    var phnote = "";
    var guser = session['LOGON.USERID'];
    var ggroup = session['LOGON.GROUPID'];
    var input = ret + "^" + guser + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + ggroup + "^" + orditem;
    var input = input + "^" + AppType;
    SaveCommontResult(reasondr, input, PrescNo);
}

//审核拒绝
function RefuseIPOrder() {
    if (NowTAB == "#div-presc-condition") {
        var grid_records = $("#grid-presclist").getGridParam('records');
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var grid_records = $("#grid-admpresclist").getGridParam('records');
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    if (grid_records == 0) {
        dhcphaMsgBox.alert("处方列表没有数据!");
        return;
    }
    if ((selectid == "") || (selectid == null)) {
        dhcphaMsgBox.alert("请先选择需要拒绝的处方!");
        return;
    }
    var dispStatus = selrowdata.TDispState;
    if (dispStatus.indexOf("已发药")>-1) {
        dhcphaMsgBox.alert("该处方已经发药,不能审核拒绝!");
        return;
    }
    var auditresult = selrowdata.TAuditResult;
    if (auditresult.indexOf("接受")>-1) {
        dhcphaMsgBox.alert("该处方审方已经接受,不能审核拒绝!");
        return;
    }
    if(RePassNeedCancle=="Y"){
	    if (auditresult == "通过") {
	        dhcphaMsgBox.alert("您选择的处方已通过,需撤消之前的审核记录才能再次审核 !");
	        return;
	    }
	    else if (auditresult.indexOf("拒绝") != "-1"){
		    dhcphaMsgBox.alert("您选择的处方已拒绝,需撤消之前的审核记录才能再次审核 !");
	        return;
		}
    }
    var PrescNo = selrowdata.TPrescNo;
    var resultstr = tkMakeServerCall("web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery", "GetOrdStrByPrescno", PrescNo);
    //console.log(resultstr)
    var orditmstr = resultstr.split("&&")[0];
    if (orditmstr == "") {
        dhcphaMsgBox.alert("该处方没有有效明细信息!");
        return;
    }else if(orditmstr == "-1"){
	    dhcphaMsgBox.alert(resultstr.split("&&")[1]);
        return;
	}
    var waycode = InPhaWay;
    ShowPHAPRASelReason({
		wayId:waycode,
		oeori:"",
		prescNo:PrescNo,
		selType:"PRESCNO"
	},SaveCommontResultEX,{PrescNo:PrescNo,resultstr:resultstr});   
}
function SaveCommontResultEX(reasonStr,origOpts){
	if (reasonStr==""){
		return;
	}
	var resultstr=origOpts.resultstr;
    var retarr = reasonStr.split("@");
    var ret = "N";
    var reasondr = retarr[0];
    var advicetxt = retarr[2];
    var factxt = retarr[1];
    var phnote = retarr[3];
    var APPTYPE = "IA";
    var mainorditm = resultstr.split("&&")[1];
    var input = ret + "^" + gUserID + "^" + advicetxt + "^" + factxt + "^" + phnote + "^" + gGroupId + "^" + mainorditm + "^" + APPTYPE;
    SaveCommontResult(reasondr, input, origOpts.PrescNo)
}

//审核通过/拒绝
function SaveCommontResult(reasondr, input, prescno) {
    $.ajax({
        url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=SaveItmResultIPMo&Input=' + encodeURI(input) + '&ReasonDr=' + encodeURI(reasondr) + '&PrescNo=' + encodeURI(prescno),
        type: 'post',
        success: function (data) {
            var retjson = JSON.parse(data);
            if (retjson.retvalue == 0) {
                QueryGridPrescAudit();
                if (top && top.HideExecMsgWin) {
                    top.HideExecMsgWin();
                }
            } else {
                dhcphaMsgBox.alert(retjson.retinfo);
                return
            }
        },
        error: function () {}
    })
}

//医嘱审核扩展信息modal
function ViewIPOrderAddInfo() {
    if (NowTAB == "#div-presc-condition") {
        var grid_records = $("#grid-presclist").getGridParam('records');
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var grid_records = $("#grid-admpresclist").getGridParam('records');
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    if (grid_records == 0) {
        dhcphaMsgBox.alert("处方列表没有数据!");
        return;
    }
    if ((selectid == "") || (selectid == null)) {
        dhcphaMsgBox.alert("请先选中需要查看的处方记录!");
        return;
    }
    $("#modal-prescinfo").modal('show');
}

//查看日志
function ViewIPOrderMonitorLog() {
    if (NowTAB == "#div-presc-condition") {
        var grid_records = $("#grid-presclist").getGridParam('records');
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    } else {
        var grid_records = $("#grid-admpresclist").getGridParam('records');
        var selectid = $("#grid-admpresclist").jqGrid('getGridParam', 'selrow');
        var selrowdata = $("#grid-admpresclist").jqGrid('getRowData', selectid);
    }
    if (grid_records == 0) {
        dhcphaMsgBox.alert("处方列表没有数据!");
        return;
    }
    if ((selectid == "") || (selectid == null)) {
        dhcphaMsgBox.alert("请先选中需要查看的处方记录!");
        return;
    }
    var orditm = selrowdata.TMoeori;
    var logoptions = {
        id: "#modal-monitorlog",
        orditm: orditm,
        fromgrid: "#grid-cypresc",
        fromgridselid: selectid
    };
    InitOutMonitorLogBody(logoptions)
}

//处方分析
function PrescAnalyse() {
    var passType = tkMakeServerCall("web.DHCINPHA.InfoCommon", "GetPassProp", gGroupId, gLocId, gUserID);
    if (passType == "") {
        dhcphaMsgBox.alert("未设置处方分析接口，请在参数设置-住院药房-合理用药厂商中添加相应厂商");
        return;
    }
    if (passType == "DHC") {
        if (NowTAB == "#div-presc-condition") {
            var grid = "grid-presclist";
        } else {
            var grid = "grid-admpresclist";
        }
        // 东华知识库
        DHCSTPHCMPASS.PassAnalysis({
            GridId: grid,
            MOeori: "TMoeori",
            PrescNo: "TPrescNo",
            GridType: "JqGrid",
            Field: "druguse",
            ResultField: "druguseresult"
        });
    } else if (passType == "DT") {
        // 大通
        // StartDaTongDll(); 
        // DaTongPrescAnalyse();  
    } else if (passType == "MK") {
        // 美康
        //MKPrescAnalyse(); 
    } else if (passType == "YY") {}
}

//自动刷新
function AutoRefreshMonitor() {
    if ($("#btn-autorefresh").children("strong").text().indexOf("自动")) {
        $("#btn-autorefresh").css("color", "#727272");
        $("#btn-autorefresh").children("i").css("color", "#999999");
        $("#btn-autorefresh").children("strong").css("color", "#727272");
        $("#btn-autorefresh").children("strong").text("自动刷新");
        clearInterval(DHCPHA_CONSTANT.VAR.TIMER);
    } else {
        $("#btn-autorefresh").css("color", "#40A2DE");
        $("#btn-autorefresh").children("i").css("color", "#40A2DE");
        $("#btn-autorefresh").children("strong").css("color", "#40A2DE");
        $("#btn-autorefresh").children("strong").text("停止刷新");
        DHCPHA_CONSTANT.VAR.TIMER = setInterval("QueryGridPrescAudit();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
    }
}

function addPhDispStatCellAttr(rowId, val, rawObject, cm, rdata) {
    if (val == "通过") {
        return "class=dhcpha-record-passed";
    } else if (val == "申诉") {
        return "class=dhcpha-record-appeal";
    } else if (val == "拒绝") {
        return "class=dhcpha-record-refused";
    } else if (val == "拒绝(接受)") {
        return "class=dhcpha-record-reaccept";
    } else {
        return "";
    }
}

function addStatCellAttr(rowId, val, rawObject, cm, rdata) {
    if (val == "Y") {
        return "class=dhcpha-record-refused";
    } else {
        return "";
    }
}

function InitBodyStyle() {

    var wardtitleheight = $("#gview_grid-presclist .ui-jqgrid-hbox").height();
    var wardheight = DhcphaJqGridHeight(1, 0) - wardtitleheight - 48;
    var prescheight = DhcphaJqGridHeight(1, 0) - 15;
    $("#grid-presclist").setGridHeight(wardheight);
    $("#ifrm-cypresc").height(prescheight);
}

//注册modaltab事件
function InitIPOrderModalTab() {
    $("#ul-monitoraddinfo a").on('click', function () {
        var adm = PatientInfo.adm;
        var patientID = PatientInfo.patientID;
        var tabId = $(this).attr("id")
        /* MaYuqiang 20220517 将患者信息传至头菜单，避免引用界面串患者 */
        var menuWin = websys_getMenuWin();  // 获得头菜单Window对象
        if (menuWin){		
            var frm = dhcsys_getmenuform(); //menuWin.document.forms['fEPRMENU'];
            if((frm) &&(frm.EpisodeID.value != adm)){
                if (menuWin.MainClearEpisodeDetails) menuWin.MainClearEpisodeDetails();  //清除头菜单上所有病人相关信息
                frm.EpisodeID.value = adm; 
                frm.PatientID.value = patientID;
            }
        }
        if (tabId == "tab-allergy") {
            $('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('dhcdoc.allergyenter.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm + "&IsOnlyShowPAList=Y");
        }
        if (tabId == "tab-risquery") {
            $('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('dhcapp.inspectrs.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm);
        }
        if (tabId == "tab-libquery") {
            $('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('dhcapp.seepatlis.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&NoReaded=' + '1');
        }
        if (tabId == "tab-eprquery") {
        	$('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('emr.browse.manage.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + gLocId);
            //$('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('emr.interface.browse.episode.csp') + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + gLocId);
        }
        if (tabId == "tab-orderquery") {
            $('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('ipdoc.patorderview.csp')  +'?EpisodeID=' + adm + '&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL');
            //$('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('oeorder.opbillinfo.csp'+'?EpisodeID=' +adm)); 
        }
        if (tabId == "tab-beforeindrug") {
            $('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('dhcpha.comment.othmedquery.csp') + '?EpisodeID=' + adm);
        }
    })

    $('#modal-prescinfo').on('show.bs.modal', function () {
        $("#modal-prescinfo .modal-dialog").width($(window).width() * 0.9);
        $("#modal-prescinfo .modal-body").height($(window).height() * 0.85);
        var tmpiframeheight = $(window).height() * 0.85 -
            $("#modal-prescinfo .modal-header").height() -
            $("#modal-prescinfo #ul-monitoraddinfo").height() -
            50
        $("#ifrm-outmonitor").height(tmpiframeheight)
        //$("#ifrm-outmonitor").attr('src', ChangeCspPathToAll("dhcpha.comment.queryorditemds.csp") + "?EpisodeID=" + PatientInfo.adm);
        $('#ifrm-outmonitor').attr('src', ChangeCspPathToAll('dhcdoc.allergyenter.csp') + '?PatientID=' + PatientInfo.patientID + '&EpisodeID=' + PatientInfo.adm + "&IsOnlyShowPAList=Y");
        var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
        var selectdata = $('#grid-presclist').jqGrid('getRowData', selectid);
        var orditem = selectdata.TMoeori;
        var patoptions = {
            id: "#dhcpha-patinfo",
            orditem: orditem
        };
        AppendPatientOrdInfo(patoptions);
        var tabId = $(this).attr("id");
        if (tabId != "tab-allergy") {
            setTimeout("ClickAllergy()",100);
        }
    })
    $("#modal-prescinfo").on("hidden.bs.modal", function () {
        //$(this).removeData("bs.modal");
    });
    $("#tab-viewpresc").hide();
}

function ClickAllergy()
{
	$("#tab-allergy").click();
}

//格式化列
function druguseFormatter(cellvalue, options, rowdata) {
    if (cellvalue == undefined) {
        cellvalue = "";
    }
    var imageid = "";
    if (cellvalue == "0") {
        imageid = "warning0.gif";
    } else if (cellvalue == "1") {
        imageid = "yellowlight.gif";
    } else if (cellvalue == "2") {
        imageid = "warning2.gif"
    } else if (cellvalue == "3") {
        imageid = "warning3.gif"
    } else if (cellvalue == "4") {
        imageid = "warning4.gif"
    }
    if (imageid == "") {
        return cellvalue;
    }
    return '<img src="'+DHCPHA_CONSTANT.URL.PATH+'/scripts/pharmacy/images/'+imageid+'" alt="' + cellvalue + '" ></img>'
    //return '<img src="../scripts/pharmacy/images/' + imageid + '" ></img>'
}

/***********************美康相关 start****************************/
// add by MaYuqiang 20181025	
function MKPrescAnalyse() {

    var mainrows = $("#grid-presc").getGridParam('records');
    if (mainrows == 0) {
        dhcphaMsgBox.alert("没有明细记录!");
        return;
    }

    for (var i = 1; i <= mainrows; i++) {
        var tmprowdata = $('#grid-presc').jqGrid('getRowData', i);
        var orditem = tmprowdata.orditem;
        var prescno = tmprowdata.prescno;

        var myrtn = HLYYPreseCheck(prescno, 0);

        var newdata = {
            druguse: myrtn
        };
        $("#grid-presc").jqGrid('setRowData', i, newdata);
    }
}


function HLYYPreseCheck(prescno, flag) {
    var XHZYRetCode = 0 //处方检查返回代码
    MKXHZY1(prescno, flag);
    //若为同步处理,取用McPASS.ScreenHighestSlcode
    //若为异步处理,需调用回调函数处理.
    //同步异步为McConfig.js MC_Is_SyncCheck true-同步;false-异步
    XHZYRetCode = McPASS.ScreenHighestSlcode;
    return XHZYRetCode
}

function MKXHZY1(prescno, flag) {
    MCInit1(prescno);
    HisScreenData1(prescno);
    MDC_DoCheck(HIS_dealwithPASSCheck, flag);
}

function MCInit1(prescno) {
    var PrescStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
    var prescdetail = PrescStr.split("^")
    var pass = new Params_MC_PASSclient_In();
    pass.HospID = prescdetail[0];
    pass.UserID = prescdetail[1];
    pass.UserName = prescdetail[2];
    pass.DeptID = prescdetail[3];
    pass.DeptName = prescdetail[4];
    pass.CheckMode = "zyf" //MC_global_CheckMode;
    MCPASSclient = pass;
}

function HIS_dealwithPASSCheck(result) {
    if (result > 0) {} else {
        //alert("没问题");
    }

    return result;
}


function HisScreenData1(prescno) {
    var Orders = "";
    var Para1 = ""

    var PrescMStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
    var PrescMInfo = PrescMStr.split("^")
    var Orders = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescDetailInfo", prescno);
    if (Orders == "") {
        return;
    }
    var DocName = PrescMInfo[2];
    var EpisodeID = PrescMInfo[5];
    if (EpisodeID == "") {
        return
    }
    var ret = tkMakeServerCall("web.DHCHLYY", "GetPrescInfo", EpisodeID, Orders, DocName);
    var TempArr = ret.split(String.fromCharCode(2));
    var PatInfo = TempArr[0];
    var MedCondInfo = TempArr[1];
    var AllergenInfo = TempArr[2];
    var OrderInfo = TempArr[3];
    var PatArr = PatInfo.split("^");


    var ppi = new Params_MC_Patient_In();
    ppi.PatCode = PatArr[0]; // 病人编码
    ppi.InHospNo = PatArr[11]
    ppi.VisitCode = PatArr[7] // 住院次数
    ppi.Name = PatArr[1]; // 病人姓名
    ppi.Sex = PatArr[2]; // 性别
    ppi.Birthday = PatArr[3]; // 出生年月

    ppi.HeightCM = PatArr[5]; // 身高
    ppi.WeighKG = PatArr[6]; // 体重
    ppi.DeptCode = PatArr[8]; // 住院科室
    ppi.DeptName = PatArr[12]
    ppi.DoctorCode = PatArr[13]; // 医生
    ppi.DoctorName = PatArr[9]
    ppi.PatStatus = 1
    ppi.UseTime = PatArr[4]; // 使用时间
    ppi.CheckMode = MC_global_CheckMode
    ppi.IsDoSave = 1
    MCpatientInfo = ppi;
    var arrayDrug = new Array();
    var pri;
    var OrderInfoArr = OrderInfo.split(String.fromCharCode(1));
    //alert(OrderInfo)
    McRecipeCheckLastLightStateArr = new Array();
    for (var i = 0; i < OrderInfoArr.length; i++) {
        var OrderArr = OrderInfoArr[i].split("^");
        //传给core的，并且由core返回变灯的唯一编号，构造的灯div的id也应该和这个相关联
        drug = new Params_Mc_Drugs_In();

        drug.Index = OrderArr[0]; //药品序号
        drug.OrderNo = OrderArr[0]; //医嘱号
        drug.DrugUniqueCode = OrderArr[1]; //药品编码
        drug.DrugName = OrderArr[2]; //药品名称
        drug.DosePerTime = OrderArr[3]; //单次用量
        drug.DoseUnit = OrderArr[4]; //给药单位      
        drug.Frequency = OrderArr[5]; //用药频次
        drug.RouteCode = OrderArr[8]; //给药途径编码
        drug.RouteName = OrderArr[8]; //给药途径名称
        drug.StartTime = OrderArr[6]; //开嘱时间
        drug.EndTime = OrderArr[7]; //停嘱时间
        drug.ExecuteTime = ""; //执行时间
        drug.GroupTag = OrderArr[10]; //成组标记
        drug.IsTempDrug = OrderArr[11]; //是否临时用药 0-长期 1-临时
        drug.OrderType = 0; //医嘱类别标记 0-在用(默认);1-已作废;2-已停嘱;3-出院带药
        drug.DeptCode = PrescMInfo[7].split("-")[1]; //开嘱科室编码
        drug.DeptName = PrescMInfo[4]; //开嘱科室名称
        drug.DoctorCode = PrescMInfo[6]; //开嘱医生编码
        drug.DoctorName = PrescMInfo[2]; //开嘱医生姓名
        drug.RecipNo = ""; //处方号
        drug.Num = ""; //药品开出数量
        drug.NumUnit = ""; //药品开出数量单位          
        drug.Purpose = 0; //用药目的(1预防，2治疗，3预防+治疗, 0默认)  
        drug.OprCode = ""; //手术编号,如对应多手术,用','隔开,表示该药为该编号对应的手术用药
        drug.MediTime = ""; //用药时机(术前,术中,术后)(0-未使用1- 0.5h以内,2-0.5-2h,3-于2h)
        drug.Remark = ""; //医嘱备注 
        arrayDrug[arrayDrug.length] = drug;

    }
    McDrugsArray = arrayDrug;
    var arrayAllergen = new Array();
    var pai;
    var AllergenInfoArr = AllergenInfo.split(String.fromCharCode(1));
    for (var i = 0; i < AllergenInfoArr.length; i++) {
        var AllergenArr = AllergenInfoArr[i].split("^");

        var allergen = new Params_Mc_Allergen_In();
        allergen.Index = i; //序号  
        allergen.AllerCode = AllergenArr[0]; //编码
        allergen.AllerName = AllergenArr[1]; //名称  
        allergen.AllerSymptom = AllergenArr[3]; //过敏症状 

        arrayAllergen[arrayAllergen.length] = allergen;
    }
    McAllergenArray = arrayAllergen;
    //病生状态类数组
    var arrayMedCond = new Array();
    var pmi;
    var MedCondInfoArr = MedCondInfo.split(String.fromCharCode(1));
    for (var i = 0; i < MedCondInfoArr.length; i++) {
        var MedCondArr = MedCondInfoArr[i].split("^");

        var medcond;
        medcond = new Params_Mc_MedCond_In();
        medcond.Index = i; //诊断序号
        medcond.DiseaseCode = MedCondArr[0]; //诊断编码
        medcond.DiseaseName = MedCondArr[1]; //诊断名称
        medcond.RecipNo = ""; //处方号
        arrayMedCond[arrayMedCond.length] = medcond;

    }
    var arrayoperation = new Array();
    McOperationArray = arrayoperation;
}

/***********************美康相关 end  ****************************/
