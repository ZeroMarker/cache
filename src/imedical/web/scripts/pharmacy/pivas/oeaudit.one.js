/** 
 * 模块: 	 静脉配伍审核
 * 编写日期: 2019-07-24
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionGroup = session['LOGON.GROUPID'];
var PivasWayCode = tkMakeServerCall("web.DHCSTPIVAS.Common", "PivasWayCode");
var FormulaId = "";
var NeedScroll = "1";
$(function () {
    $(".newScroll").mCustomScrollbar({
        theme: "inset-2-dark",
        scrollInertia: 100,
        mouseWheel: {
            scrollAmount: 100 // 滚动量
        }
    });
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridWard();
    InitGridAdm();
    InitGridOrdItem();
    InitGridOrderDrugs();
    InitTreeGridReason();
    InitTPN();
    InitMedHistory();
    InitMedInfo();
    $('#btnFind').on("click", Query);
    $('#btnFindDetail').on("click", QueryDetail);
    $('#btnAuditOk').on("click", function () {
        // 审核通过
        AuditOk("SHTG");
    });
    $('#btnAuditNo').on("click", function () {
        AuditNoShow("SHJJ");
    });
    $("#btnPhaRemark").on("click", function () {
	    // 药师备注
        AuditRemark();
    });
    $('#btnCancelAudit').on("click", CancelAudit);
    $('#btnAnalyPresc').on("click", AnalyPresc); //合理用药-预留
    $("#btnPrBroswer").on("click", PrbrowserHandeler);
    //$("#btnRemark").on("click", SaveRemark);
    $('#txtPatNo').on('keypress', function (event) {
        if (event.keyCode == "13") {
            GetPatAdmList(); //调用查询
        }
    });
    $("#btnAuditRecord").on("click", AuditRecordLog);
    //$("#btnMedTips").on("click", MedicineTips)
    InitPivasSettings();
    $("#kwMore").keywords({
        singleSelect: true,
        onClick: function (v) {
            var panelHeight = 600;
            $("#divTPN").hide();
            $("#divMedHistory").hide();
            $("#divMedInfo").hide();
            var title = v.text;
            if (title == "TPN指标") {
                $("#divTPN").show();
                $("#divTPNGrid").height(panelHeight);
                $("#gridTPN").datagrid("resize");
                LoadTPN();
            } else if (title == "历次化疗用药") {
                $("#divMedHistory").show();
                $("#divMedHistoryGrid").height(panelHeight);
                $("#gridMedHistory").datagrid("resize");
                LoadMedHistory();
            } else if (title == "审核辅助") {
                $("#divMedInfo").show();
                $("#divMedInfoGrid").height(panelHeight);
                $("#gridMedInfo").datagrid("resize");
                LoadMedInfo();
            }
        },
        items: [{
            text: "审核辅助"
        }, {
            text: "TPN指标"
        }, {
            text: "历次化疗用药"
        }]
    });
   	$("#kwMore").keywords("select", "审核辅助");
    $(".dhcpha-win-mask").remove();
});

function InitDict() {
    // 审核状态
    PIVAS.ComboBox.Init({
        Id: 'cmbPassStat',
        Type: 'PassStat'
    }, {
        editable: false
    });
    $('#cmbPassStat').combobox("setValue", 1);
    // 审核结果
    PIVAS.ComboBox.Init({
        Id: 'cmbPassResult',
        Type: 'PassResult'
    }, {
        editable: false
    });
    $('#cmbPassResult').combobox("setValue", "");
    // 护士审核
    PIVAS.ComboBox.Init({
        Id: 'cmbNurAudit',
        Type: 'NurseResult'
    }, {
        editable: false
    });
    $('#cmbNurAudit').combobox("setValue", 1);
    // 配液大类
    PIVAS.ComboBox.Init({
        Id: 'cmbPivaCat',
        Type: 'PivaCat'
    }, {});
    // 科室组
    PIVAS.ComboBox.Init({
        Id: 'cmbLocGrp',
        Type: 'LocGrp'
    }, {});
    // 病区
    PIVAS.ComboBox.Init({
        Id: 'cmbWard',
        Type: 'Ward'
    }, {});
    // 医嘱优先级
    PIVAS.ComboBox.Init({
        Id: 'cmbPriority',
        Type: 'Priority'
    }, {
        width: 150
    });
    // 集中配制
    PIVAS.ComboBox.Init({
        Id: 'cmbWorkType',
        Type: 'PIVAWorkType'
    }, {});
    // 药品
    PIVAS.ComboGrid.Init({
        Id: 'cmgIncItm',
        Type: 'IncItm'
    }, {
        width: 310
    });

}

//初始化病区列表
function InitGridWard() {
    //定义columns
    var columns = [
        [{
                field: 'select',
                checkbox: true
            },
            {
                field: "wardId",
                title: 'wardId',
                hidden: true
            },
            {
                field: 'wardDesc',
                title: '病区',
                width: 250
            },
            {
                field: 'needCnt',
                title: '未审',
                width: 50,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        fitColumns: false,
        fit: true,
        //rownumbers: false,
        columns: columns,
		queryOnSelect: false,
        onClickRow: function (rowIndex, rowData) {
            CurWardID = rowData.wardId;
            CurAdm = "";
        },
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function () {
            $("#gridOrdItem").datagrid("clear");
            $(this).datagrid("uncheckAll");
        },
        onClickCell: function (rowIndex, field, value) {
            if (field == "wardDesc") {
                $(this).datagrid("options").queryOnSelect = true;
            }
        },
        onSelect: function (rowIndex, rowData) {
            if ($(this).datagrid("options").queryOnSelect==true){
                $(this).datagrid("options").queryOnSelect = false;
                QueryDetail();
            }
        },
        onUnselect: function (rowIndex, rowData) {
            if ($(this).datagrid("options").queryOnSelect==true){
                $(this).datagrid("options").queryOnSelect = false;
                QueryDetail();
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridWard", dataGridOption);
}

function InitGridAdm() {
    var options = {
        toolbar: '#gridAdmBar',
        onClickRow: function (rowIndex, rowData) {
            QueryDetail();
        }
    };
    PIVAS.InitGridAdm({
        Id: 'gridAdm'
    }, options);
}

//初始化明细列表
function InitGridOrdItem() {
    //定义columns
    var columns = [
        [{
                field: 'passResult',
                title: '配伍审核结果',
                width: 50,
                align: 'left',
                hidden: true
            },
            {
                field: 'analysisResult',
                title: '合理',
                width: 45,
                halign: 'left',
                align: 'center',
                hidden: false,
                formatter: function (value, row, index) {
                    if ((value == "1")||(value == "0")) { // 正常 #16BBA2
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-ok.png" >';
                    } else if (value == "2") { // 警示 #FF6356
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-warn.png" >';
                    } else if (value == "3") { //严重 black
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-error.png" >';
                    }
                    return '';
                }
            },
            {
                field: 'warnFlag',
                title: '状态',
                width: 75,
                align: "center",
                styler: function (value, row, index) {
                    // 备注为安贞客户提出的颜色,如下真实颜色与之暂时不符
                    if (row.priorityDesc == "临时医嘱") {
                        return 'background-color:#F9E701;'; //亮黄
                    }
					var passResult=row.passResult;
                    if (passResult== "Y") {
                        return 'background-color:#019BC1;color:white;'; //绿色
                    } else if ((passResult== "N")||(passResult== "NY")) {
                        return 'background-color:#C33A30;color:white;'; //红色
                    } else if (passResult== "NA") {
                        return 'background-color:#FFB63D;color:white;'; //浅黄色
                    }
                },
            },
            {
                field: 'pivaCatDesc',
                title: '类型',
                width: 45,
                styler: function (value, row, index) {
                    return "font-weight:bold;font-size:16px;"
                }
            },

            {
                field: 'drugs',
                title: '医嘱',
                width: 1500
            },
            {
                field: 'wardDesc',
                title: '病区',
                width: 150,
                hidden: true
            },
            {
                field: 'bedNo',
                title: '床号',
                width: 50,
                hidden: true
            },
            {
                field: "patName",
                title: '姓名',
                width: 75,
                hidden: true
            },
            {
                field: "patSex",
                title: '性别',
                width: 45,
                align: 'center',
                hidden: true
            },
            {
                field: "patAge",
                title: '年龄',
                width: 45,
                hidden: true
            },
            {
                field: 'surfaceArea',
                title: '体表面积',
                width: 75,
                hidden: true
            },
            {
                field: "mOeori",
                title: '主医嘱Id',
                width: 100,
                hidden: true
            },
            {
                field: "admId",
                title: '就诊Id',
                width: 100,
                hidden: true
            },
            {
                field: "pid",
                title: 'pid',
                width: 200,
                hidden: true
            },
            {
                field: "analysisData",
                title: '分析结果',
                width: 200,
                hidden: true
            },
            {
                field: "dateMOeori",
                title: '主医嘱Id+日期',
                width: 200,
                hidden: true
            },
            {
                field: "wardPat",
                title: '病区患者分组',
                width: 200,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url:"",
        fitColumns: false,
        singleSelect: true,
        rownumbers: true,
        columns: columns,
        pageSize: 100,
        pageList: [100, 300, 500],
        pagination: true,
        toolbar: "#gridOrdItemBar",
        onLoadSuccess: function () {
            ClearOrderDetail();
            var rowsData = $("#gridOrdItem").datagrid("getRows");
            if (rowsData != "") {
                // 分页数据由临时global获取
                var pid = rowsData[0].pid;
                $('#gridOrdItem').datagrid("options").queryParams.pid = pid;
            }
            if (NeedScroll == 1) {
                $(this).datagrid("scrollTo", 0);
            }
            NeedScroll = 1;
        },
        onClickRow: function (rowIndex, rowData) {
            ShowOrderDetail(rowData.mOeori)
        },
        onClickCell: function (rowIndex, field, value) {
            if (field == "analysisResult") {
                var content = $(this).datagrid("getRows")[rowIndex].analysisData;
                DHCSTPHCMPASS.AnalysisTips({
                    Content: content
                })
            }
        },
        onDblClickCell: function (rowIndex, field, value) {
            if (field != "incDesc") {
                return;
            }
            var rowData = $(this).datagrid("getRows")[rowIndex];
            if (PIVAS.VAR.PASS == "DHC") {
                /// 东华知识库说明书简写
                var userInfo = SessionUser + "^" + SessionLoc + "^" + SessionGroup;
                var incDesc = rowData.incDesc;
                DHCSTPHCMPASS.MedicineTips({
                    Oeori: rowData.oeori,
                    UserInfo: userInfo,
                    IncDesc: incDesc
                })
            }
        },
        groupField: 'wardPat',
        view: groupview,
        groupFormatter: function (value, rows) {
            var rowData = rows[0];
            // 病人基本信息 / 医嘱信息 / 
            var viewDiv = "";
            var patDiv = "";
            var ordDiv = "";
            var wardDiv = "";
            patDiv += '<div id="grpViewPat" class="grpViewPat" style="padding-left:0px">';
            // patDiv += '<div >' + rowData.patNo + '</div>';
            // patDiv += '<div>/</div>';
            patDiv += '<div style="width:80px">' + rowData.patName + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.patSex + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.patAge + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.patNo + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div style="width:40px">' + rowData.bedNo + '</div>';
            patDiv += '</div>';
            wardDiv += '<div id="grpViewWard" class="grpViewWard">';
            wardDiv += '<div>' + rowData.wardDesc + '</div>';
            wardDiv += '</div>';
            viewDiv += '<div id="grpViewBase" class="grpViewBase">' + wardDiv + patDiv + '</div>';
            return viewDiv;
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrdItem", dataGridOption);
}

function InitTreeGridReason() {
    var treeColumns = [
        [{
                field: 'reasonId',
                title: 'reasonId',
                width: 250,
                hidden: true
            },
            {
                field: 'reasonDesc',
                title: '原因',
                width: 250
            },
            {
                field: '_parentId',
                title: 'parentId',
                hidden: true
            }
        ]
    ];
    $('#treeGridReason').treegrid({
        animate: true,
        border: false,
        fit: true,
        checkbox: true,
        nowrap: true,
        fitColumns: true,
        singleSelect: true,
        idField: 'reasonId',
        treeField: 'reasonDesc',
        pagination: false,
        columns: treeColumns,
        url: PIVAS.URL.COMMON + '?action=JsGetAuditReason',
        queryParams: {
            params: PivasWayCode + "^",
			hosp:session['LOGON.HOSPID']
        }
    });
}

///按登记号查询就诊列表
function GetPatAdmList() {
    var patNo = $('#txtPatNo').val();
	patNo=PIVAS.FmtPatNo(patNo);
    $('#txtPatNo').val(patNo);
    $('#gridAdm').datagrid('query', {
        inputParams: patNo + '^' + session['LOGON.HOSPID']
    });
}

///查询
function Query() {
    ClearTmpGlobal();
    var params = QueryParams("Query");
    $('#gridWard').datagrid("options").url=$URL;
    $('#gridWard').datagrid('query', {
        ClassName: "web.DHCSTPIVAS.OeAudit",
        QueryName: "OeAuditWard",
        inputStr: params
    });
}

///查询医嘱
function QueryDetail() {
    ClearTmpGlobal();
    var params = QueryParams("QueryDetail");
    $('#gridOrdItem').datagrid({
	    url:$URL + "?ClassName=web.DHCSTPIVAS.OeAudit&MethodName=JsGetOeAuditDetailOne",
        pageNumber: 1,
        queryParams: {
            inputStr: params,
            pid: ''
        }
    });
}

/// 获取参数
function QueryParams(queryType) {
    var wardIdStr = "";
    var startDate = $('#dateStart').datebox('getValue'); // 起始日期
    var endDate = $('#dateEnd').datebox('getValue'); // 截止日期
    var startTime = ""; // $('#timeOrdStart').timespinner('getValue'); // 用药开始时间
    var endTime = ""; // $('#timeOrdEnd').timespinner('getValue'); // 用药结束时间

    var locGrpId = $('#cmbLocGrp').combobox("getValue") || ''; // 科室组
    var pivaCat = $("#cmbPivaCat").combobox("getValue") || ''; // 配液分类
    var passStat = $("#cmbPassStat").combobox("getValue") || ''; // 审核状态
    var passResult = $("#cmbPassResult").combobox("getValue") || ''; // 审核结果
    var nurAudit = $("#cmbNurAudit").combobox("getValue") || ''; // 护士审核
    var priority = $("#cmbPriority").combobox("getValue") || ''; // 医嘱优先级	
    var locGrpId = $('#cmbLocGrp').combobox("getValue") || ''; // 科室组	
    var admId = "";
    // 如果为查询明细,则wardId取选择的Id
    var tabTitle = $('#tabsOne').tabs('getSelected').panel('options').title;
    if (queryType == "QueryDetail") {
        if (tabTitle == "病区列表") {

            var wardChecked = $('#gridWard').datagrid('getChecked');
            if (wardChecked == "") {
                $("#gridOrdItem").datagrid("clear");
                return "";
            }
            for (var i = 0; i < wardChecked.length; i++) {
                if (wardIdStr == "") {
                    wardIdStr = wardChecked[i].wardId;
                } else {
                    wardIdStr = wardIdStr + "," + wardChecked[i].wardId;
                }
            }
            /*
            var wardSelect = $('#gridWard').datagrid('getSelected');
            if (wardSelect == null) {
	            $.messager.popover({msg:"请选择病区",type:'alert'});
                return "";
            }
            wardIdStr = wardSelect.wardId;*/
            //admId = admSelected.admId;
        } else if (tabTitle == "按登记号") {
            var admSelected = $('#gridAdm').datagrid("getSelected");
            if (admSelected == null) {
                $.messager.popover({
                    msg: "请选择就诊记录",
                    type: 'alert'
                });
                return "";
            }
            wardIdStr = "";
            admId = admSelected.admId;
        }
    } else {
        wardIdStr = $("#cmbWard").combobox("getValue") || '';
    }
    var incId = $("#cmgIncItm").combobox("getValue") || '';
    var SkinFlag = $('#chkSkinFlag').checkbox('getValue');
    if (SkinFlag == false) {
        var SkinFlag = 0;
    } else {
        var SkinFlag = 1;
    }
    var NoFeeAuditFlag = $('#chkNoFeeAuditFlag').checkbox('getValue');
    if (NoFeeAuditFlag == false) {
        var NoFeeAuditFlag = 0;
    } else {
        var NoFeeAuditFlag = 1;
    }
    var params = startDate + "^" + endDate + "^" + startTime + "^" + endTime + "^" + SessionLoc + "^" + admId + "^" + wardIdStr + "^" + pivaCat + "^" + passStat + "^" + passResult;
    params += "^" + nurAudit + "^" + priority + "^" + incId + "^" + locGrpId + "^" + SkinFlag + "^" + NoFeeAuditFlag;
    return params;
}

/// 配伍审核通过
function AuditOk(passType) {
    var dateMOeoriStr = GetDateMainOeoriStr();
    if (dateMOeoriStr == "") {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "请选择记录",
            type: 'alert'
        });
        return;
    } else {
	    var gridSel=$('#gridOrdItem').datagrid('getSelected');
        var passResult = gridSel.passResult;
        if (passResult=="N"){
		    DHCPHA_HUI_COM.Msg.popover({
		        msg: "您选择的记录为拒绝状态",
		        type: 'alert'
		    });
		    return;
	    }else if (passResult=="NY"){
			DHCPHA_HUI_COM.Msg.popover({
		        msg: "您选择的记录为拒绝状态,且医生已接受",
		        type: 'alert'
		    });
		    return;
		}else if (passResult=="Y"){
			DHCPHA_HUI_COM.Msg.popover({
		        msg: "您选择的记录已经为通过状态",
		        type: 'alert'
		    });
		    return;
		}
		if ((gridSel.warnFlag).indexOf("护士拒绝")>=0){
			DHCPHA_HUI_COM.Msg.popover({
		        msg: "您选择的记录已经护士拒绝",
		        type: 'alert'
		    });
		    return;
		}
    }
    PIVAS.Progress.Show({
        type: 'save',
        interval: 1000
    });
    $.m({
        ClassName: "web.DHCSTPIVAS.OeAudit",
        MethodName: "PivasPass",
        dateMOeoriStr: dateMOeoriStr,
        userId: SessionUser,
        passType: passType
    }, function (passRet) {
        PIVAS.Progress.Close();
        var passRetArr = passRet.split("^");
        var passVal = passRetArr[0];
        var passInfo = passRetArr[1];
        if (passVal == 0) {
            //$.messager.alert('提示','审核通过!','info');
        } else {
            $.messager.alert('提示', passInfo, 'warning');
            return;
        }
        NeedScroll = "";
		// 不reload,可以直接updateRow,依据情况修改吧
        $("#gridOrdItem").datagrid("reload")
    })
}

/// 配伍审核拒绝弹窗
function AuditNoShow(passType) {
    if (PivasWayCode == "") {
	    DHCPHA_HUI_COM.Msg.popover({
	        msg: "请先维护配伍审核原因",
            type: 'alert'	    
	    });
        return;
    }
    var dateMOeoriStr = GetDateMainOeoriStr();
    var warnMsg="";
    if (dateMOeoriStr == "") {
	    warnMsg="请选择记录";
    } else {
	    var gridSel=$('#gridOrdItem').datagrid('getSelected');
        var passResult = gridSel.passResult;
        if (passResult=="N"){
	        warnMsg="您选择的记录为拒绝状态";
	    }else if (passResult=="NY"){
		    warnMsg="您选择的记录为拒绝状态,且医生已接受";
		}else if (passResult=="Y"){
			warnMsg="您选择的记录已经为通过状态";
		}
		if (warnMsg==""){
			if ((gridSel.warnFlag).indexOf("护士拒绝")>=0){
				warnMsg="您选择的记录已经护士拒绝";
			}
			if ((gridSel.warnFlag).indexOf("护士未处理")>=0){
				warnMsg="您选择的记录护士未处理医嘱";
			}
		}
    }
	if (warnMsg!=""){
		DHCPHA_HUI_COM.Msg.popover({
	        msg: warnMsg,
	        type: 'alert'
	    });
	    return;
	}
    $('#reasonSelectDiv').window({
        'title': "审核拒绝原因选择"
    });
    $('#reasonSelectDiv').dialog('open');
    $('#treeGridReason').treegrid('clearChecked');
    $('#treeGridReason').treegrid({
        queryParams: {
            params: PivasWayCode + "^1",
			hosp:session['LOGON.HOSPID']
        }
    });
}

/// 拒绝
function AuditNo() {
    var winTitle = $("#reasonSelectDiv").panel('options').title;
    var passType = "SHJJ";
    var checkedNodes = $('#treeGridReason').treegrid("getCheckedNodes");
    if (checkedNodes == "") {
        $.messager.alert("提示", "请选择原因", "warning");
        return "";
    }
    var reasonStr = "";
    for (var nI = 0; nI < checkedNodes.length; nI++) {
        var reasonId = checkedNodes[nI].reasonId;
        if (reasonId == 0) {
            continue;
        }
        // 只需叶子结点
        if ($('#treeGridReason').treegrid('getChildren', reasonId) == "") {
            reasonStr = reasonStr == "" ? reasonId : reasonStr + "!!" + reasonId
        }
    }
    var reasonNotes = $("#txtReasonNotes").val();
    var reasonData = reasonStr + "|@|" + reasonNotes;
    var dateMOeoriStr = GetDateMainOeoriStr();
    // 同步,不需遮罩
    var passRet = tkMakeServerCall("web.DHCSTPIVAS.OeAudit", "PivasPass", dateMOeoriStr, SessionUser, passType, reasonData);
    var passRetArr = passRet.split("^");
    var passVal = passRetArr[0];
    var passInfo = passRetArr[1];
    $('#txtReasonNotes').val("");
    if (passVal == 0) {
        $('#reasonSelectDiv').dialog('close');
    } else {
        $.messager.alert('提示', passInfo, 'warning');
        return;
    }
    NeedScroll = "";
    $("#gridOrdItem").datagrid("reload")
}

///取消配伍审核
function CancelAudit() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.popover({
            msg: "请选择记录",
            type: 'alert'
        });
        return;
    }

    var conditionHtml = "您确认取消审核?";
    $.messager.confirm('温馨提示', conditionHtml, function (r) {
        if (r) {
            var dateMOeori = gridSelect.dateMOeori;
            var cancelRet = tkMakeServerCall("web.DHCSTPIVAS.OeAudit", "CancelPivasPass", dateMOeori, SessionUser)
            var cancelRetArr = cancelRet.split("^");
            var cancelVal = cancelRetArr[0] || "";
            if (cancelVal == "-1") {
                $.messager.alert('提示', cancelRetArr[1], "warning");
                return;
            }
            NeedScroll = "";
            $("#gridOrdItem").datagrid("reload");
        }
    });
}

/// 病例浏览
function PrbrowserHandeler() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.popover({
            msg: "请选择记录",
            type: 'alert'
        });
        return;
    }
    var adm = gridSelect.admId;
    PIVAS.ViewEMRWindow({}, adm);
}

/// 获取选择的主医嘱串
function GetDateMainOeoriStr() {
    var gridSel = $('#gridOrdItem').datagrid('getSelected') || "";
    if (gridSel == "") {
        return "";
    }
    return gridSel.dateMOeori;
}


function AuditRecordLog() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.popover({
            msg: "请选择记录",
            type: 'alert'
        });
        return;
    }
    var dateMOeori = gridSelect.dateMOeori;
    PIVAS.AuditRecordWindow({
        dateMOeori: dateMOeori
    });
}

/// 初始化默认条件
function InitPivasSettings() {
    $.cm({
        ClassName: "web.DHCSTPIVAS.Settings",
        MethodName: "GetAppProp",
        userId: session['LOGON.USERID'],
        locId: session['LOGON.CTLOCID'],
        appCode: "OeAudit"
    }, function (jsonData) {
        $("#dateStart").datebox("setValue", jsonData.OrdStDate);
        $("#dateEnd").datebox("setValue", jsonData.OrdEdDate);
        PIVAS.VAR.PASS = jsonData.Pass;
        var FormulaDesc = jsonData.Formula;
        FormulaId = tkMakeServerCall("web.DHCSTPIVAS.Common", "GetDIIIdByDesc", FormulaDesc)

    });
}

function AnalyPresc() {
    if (PIVAS.VAR.PASS == "DHC") {
        DHCSTPHCMPASS.PassAnalysis({
            GridId: "gridOrdItem",
            MOeori: "mOeori",
            GridType: "EasyUI",
            Field: "analysisResult",
            CallBack: function () {}
        })
    }else if (PIVAS.VAR.PASS=="DT"){
		DHCPHA_HUI_COM.Msg.popover({
            msg: "大通接口未开放,请联系相关产品组调试接口",
            type: 'alert'
        });	
        return;
		StartDaTongDll(); 
		DaTongPrescAnalyse();  
	}else if (PIVAS.VAR.PASS=="MK"){
		DHCPHA_HUI_COM.Msg.popover({
            msg: "美康接口未开放,请联系相关产品组调试接口",
            type: 'alert'
        });	
        return;
		MKPrescAnalyse(); 
	}else{
		DHCPHA_HUI_COM.Msg.popover({
            msg: "无此类型合理用药接口,请检查药品系统管理->参数设置->配液中心->合理用药参数",
            type: 'alert'
        });	
        return;
	}
}


// 清除本程序涉及的所有临时global
function ClearTmpGlobal() {
    var rowsData = $("#gridOrdItem").datagrid("getRows") || "";
    if (rowsData == "") {
        return;
    }
    var pid = rowsData[0].pid;
    tkMakeServerCall("web.DHCSTPIVAS.OeAudit", "KillOeAudit", pid)
}
window.onbeforeunload = function () {
    ClearTmpGlobal();
}

// 显示右侧明细
function ShowOrderDetail(mOeori) {
    $("#lyOrdDetail [id^='oe']").html("");
    var retData = $.cm({
        ClassName: "web.DHCSTPIVAS.OrderInfo",
        MethodName: "GetOrderJson",
        MOeori: mOeori
    }, false)
    var orderObj = retData.order;
    $("#lyOrdDetail [id^='oe']").each(function () {
        if (this.id == "oePIVASRemark") {
            $(this).val(orderObj[this.id] || "");
        } else {
            $(this).html(orderObj[this.id] || "");
        }
    });

    $('#gridOrderDrugs').datagrid('loadData', retData.drugs);
    $("#oeDiag").tooltip({
        content: $("#oeDiag").text(),
        position: 'left',
        showDelay: 500
    });
    // 触发默认关键字
    var kwWord = "" //orderObj.kwWord||"";
    if (kwWord != "") {
        $("#kwMore").keywords("select", kwWord);
    } else {
        var curKW = $("#kwMore").keywords("getSelected");
        if (curKW[0]) {
            var title = curKW[0].text;
            $("#kwMore").keywords("select", title);
        }
    }
}

function ClearOrderDetail() {

    $("#lyOrdDetail [id^='oe']").text("");
    $("#lyOrdDetail [id^='oe']").val("");
    $('#gridOrderDrugs').datagrid('clear');
    $("#gridMedHistory").datagrid("clear");
    $("#gridTPN").datagrid("clear");
    $("#gridMedInfo").datagrid("clear");
}

function InitGridOrderDrugs() {
    //定义columns
    var columns = [
        [{
                field: "oeoriName",
                title: '药品名称',
                width: 250,
                styler: PIVAS.Grid.Styler.IncDesc
            },
            {
                field: 'spec',
                title: '规格',
                width: 80
            },
            {
                field: 'dosage',
                title: '剂量',
                width: 75
            },
            {
                field: 'arcim',
                title: '医嘱项ID',
                width: 75,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: null,
        pagination: false,
        fit: true,
        rownumbers: true,
        columns: columns,
        onSelect: function (rowIndex, rowData) {},
        onLoadSuccess: function (data) {
            var rows = data.rows;
            if (rows) {
                if (rows.length > 0) {
                    //	$(this).datagrid("selectRow",0);
                }
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrderDrugs", dataGridOption);
}

function InitTPN() {
    $("#divTPNGrid").height($("#divMoreCenter").height());
	$("#divTPNGrid").width($("#divMedInfoGrid").width());
    var dataGridOption = {
        url: "",
        border: true,
        fitColumns: true,
        singleSelect: true,
        nowrap: false,
        striped: false,
        pagination: false,
        rownumbers: false,
        columns: [
            [{
                    field: 'ingIndItmDesc',
                    title: '指标',
                    width: 100,
                    align: 'left',
                    halign: 'center',
                },
                {
                    field: 'ingIndItmValue',
                    title: '值',
                    width: 50,
                    align: 'center'
                },
                {
                    field: 'ingIndItmRange',
                    title: '范围(~)',
                    width: 75,
                    align: 'left',
                    formatter: function (value, row, index) {
                        return (row.ingIndItmMin || "") + "~" + (row.ingIndItmMax || "");
                    }
                }, {
                    field: 'ingIndItmOk',
                    title: '合理',
                    width: 75,
                    hidden: true
                }
            ]
        ],
        rowStyler: function (index, row) {
            var isOk = row.ingIndItmOk;
            if (isOk == "1") {
                return {
                    class: "grid-form-high"
                }
            } else if (isOk == "-1") {
                return {
                    class: "grid-form-low"
                }
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridTPN", dataGridOption);
}


function InitMedHistory() {
	$("#divMedHistoryGrid").width($("#divMedInfoGrid").width());
    var columns = [
        [{
                field: 'doseDate',
                title: '日期',
                width: 100
            },
            {
                field: 'oeoriInfo',
                title: '医嘱',
                width: 333
            }
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        rownumbers: false,
        columns: columns,
        pagination: false,
        border: true,
        singleSelect: true,
        nowrap: false
    };
    DHCPHA_HUI_COM.Grid.Init("gridMedHistory", dataGridOption);

}

function LoadMedHistory() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected") || "";
    if (gridSelect == "") {
        $.messager.popover({
            msg: "请选择记录",
            type: 'alert'
        });
        $("#gridMedHistory").datagrid("clear");
        return;
    }
    $('#gridMedHistory').datagrid("options").url=$URL;
    $('#gridMedHistory').datagrid("load", {
        page: 1,
        ClassName: 'web.DHCSTPIVAS.OrderInfo',
        QueryName: 'MedHistory',
        InputStr: gridSelect.admId + "^" + "Chemotherapeutic",
    });
}

function LoadTPN() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected") || "";
    if (gridSelect == "") {
        $.messager.popover({
            msg: "请选择记录",
            type: 'alert'
        });
        $("#gridTPN").datagrid("clear");
        return;
    }
    $('#gridTPN').datagrid("options").url=$URL;
    $('#gridTPN').datagrid("load", {
        page: 1,
        ClassName: 'web.DHCSTPIVAS.Formula',
        QueryName: 'OeoriIngrIndItm',
        inputStr: gridSelect.mOeori + "^" + FormulaId
    });
}


function LoadMedInfo() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected") || "";
    if (gridSelect == "") {
        //$.messager.popover({msg:"请选择记录",type:'alert'});
        $("#gridMedInfo").datagrid("clear");
        return;
    }
    $('#gridMedInfo').datagrid("options").url=$URL;
    $('#gridMedInfo').datagrid("load", {
        page: 1,
        ClassName: 'web.DHCSTPIVAS.OrderInfo',
        QueryName: 'OrderMedInfo',
        MOeori: gridSelect.mOeori,
        LocId: session['LOGON.CTLOCID']
    });
}

function InitMedInfo() {
    var columns = [
        [{
                field: 'arcimDesc',
                title: '医嘱名称',
                width: 100,
                hidden: true
            },
            {
                field: 'drugInfo',
                title: '辅助信息',
                width: 430
            }
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        fitColumns: true,
        rownumbers: false,
        columns: columns,
        pagination: false,
        border: true,
        singleSelect: true,
        nowrap: false,
        groupField: 'arcimDesc',
        view: groupview,
        groupFormatter: function (value, rows) {
            // var sameCnt=rows[0].sameCnt;
            // if (sameCnt>1){
            // }
            return value;
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridMedInfo", dataGridOption);
}
/// 标注无限制,按选择行,可能在勾选过程中标注某一条医嘱
function AuditRemark(){
	var gridSelect = $('#gridOrdItem').datagrid('getSelected');
	if (gridSelect==null){
	    DHCPHA_HUI_COM.Msg.popover({
	        msg: "请选中需要标注的记录",
	        type: 'alert'
	    });
	    return;
	}
	
	var rowIndex=$('#gridOrdItem').datagrid("getRows").indexOf(gridSelect);
	var dateMOeori=gridSelect.dateMOeori;
	$.messager.prompt("提示", "请输入标注内容", function (rText) {
		if (rText!=undefined){
			$.cm({
		        ClassName: "web.DHCSTPIVAS.OeAudit",
		        MethodName: "PivasRemark",
		        dateMOeoriStr: dateMOeori,
		        userId: SessionUser,
		        phaRemark: rText,
		        dataType:"text"
		    }, function (passRet) {
		        var passRetArr = passRet.split("^");
		        var passVal = passRetArr[0];
		        var passInfo = passRetArr[1];
		        if (passVal == 0) {
				    DHCPHA_HUI_COM.Msg.popover({
				        msg: "标注成功",
				        type: 'success'
				    });
		            var oldWarnFlag=gridSelect.warnFlag;
		            var newWarnFlag=oldWarnFlag;
		            if (oldWarnFlag==""){
			        	newWarnFlag="标注";
			        }else{
				        if (oldWarnFlag.indexOf("标注")<0){
				    		newWarnFlag=oldWarnFlag+"</br>标注";
				        }
				    }
				    if (rText==""){
					    newWarnFlag=newWarnFlag.replace(/<\/br>标注/g,"");
						newWarnFlag=newWarnFlag.replace(/标注/g,"");
					}
			        $('#gridOrdItem').datagrid('updateRow',{
				    	index:rowIndex,
				    	row:{
					    	warnFlag:newWarnFlag
					    }
				    });
				    $("#oePhaRemark").text(rText);
		        } else {
		            $.messager.alert('提示', passInfo, 'warning');
		        }
		    })
		}	
	});
}
