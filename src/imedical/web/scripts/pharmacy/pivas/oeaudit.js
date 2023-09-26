/** 
 * 模块: 	 静脉配伍审核
 * 编写日期: 2018-02-11
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionGroup = session['LOGON.GROUPID'];
var PivasWayCode = tkMakeServerCall("web.DHCSTPIVAS.Common", "PivasWayCode");
var FormulaId = "";
var ChangeViewNum = 1;
$(function () {
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridWard();
    InitGridAdm();
    InitGridOrdItem();
    InitTreeGridReason();
    $('#btnFind').on("click", Query);
    $('#btnFindDetail').on("click", QueryDetail);
    $('#btnAuditOk').on("click", function () {
        // 审核通过
        AuditOk("SHTG");
    });
    $('#btnAuditNo').on("click", function () {
	    // 审核拒绝
        AuditNoShow("SHJJ");
    });
    $("#btnPhaRemark").on("click", function () {
	    // 药师备注
        AuditRemark();
    });
    $('#btnCancelAudit').on("click", CancelAudit);
    $('#btnAnalyPresc').on("click", AnalyPresc); //合理用药
    $("#btnPrBroswer").on("click", PrbrowserHandeler);
    $('#txtPatNo').on('keypress', function (event) {
        if (event.keyCode == "13") {
            GetPatAdmList(); //调用查询
        }
    });
    $("#btnAuditRecord").on("click", AuditRecordLog);
    $("#btnChangeView").on("click", ChangeView);
    //$("#btnMedTips").on("click", MedicineTips)
    InitPivasSettings();
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
                width: 200
            }
        ]
    ];
    var dataGridOption = {
        url:"",
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
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
    var columnspat = [
        [{
                field: 'gridOrdItemSelect',
                checkbox: true
            },
            {
                field: 'warnFlag',
                title: '状态',
                width: 70,
                align: 'left',
                styler: function (value, row, index) {
                    // 备注为安贞客户提出的颜色,如下真实颜色与之暂时不符
                    if (row.priorityDesc == "临时医嘱") {
                        return 'background-color:#F9E701;'; //亮黄
                    }

                    if (value.indexOf("审核通过") >= 0) {
                        return 'background-color:#019BC1;color:white;'; //绿色
                    } else if (value.indexOf("审核拒绝") >= 0) {
                        return 'background-color:#C33A30;color:white;'; //红色
                    } else if (value.indexOf("医生申诉") >= 0) {
                        return 'background-color:#FFB63D;color:white;'; //浅黄色
                    }
                },
                formatter: function (value, row, index) {
                    if (value == undefined) {
                        value = "";
                    }
                    if (value.indexOf("手术") >= 0) {
                        return PIVAS.Grid.CSS.SurgeryImg;
                    }
                    return value;
                }
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
                field: 'ordRemark',
                title: '备注',
                width: 75
            },
            {
                field: 'wardDesc',
                title: '病区',
                width: 125
            },
            {
                field: 'bedNo',
                title: '床号',
                width: 75
            },
            {
                field: "patNo",
                title: '登记号',
                width: 100
            },
            {
                field: "patName",
                title: '姓名',
                width: 75
            },
            {
                field: 'oeoriSign',
                title: '组',
                width: 30,
                align: 'center',
                halign: 'left',
                /*
                styler: function(value, row, index) {
                    // 优先于formatter执行
                    var colColorArr = row.colColor.split("-");
                    var colorStyle = "";
                    if ((colColorArr[0] % 2) == 0) { // 偶数行变色,按病人的背景色
                        colorStyle = PIVAS.Grid.CSS.PersonEven;
                    }
                    return colorStyle;
                },*/
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            {
                field: 'incDesc',
                title: '药品',
                width: 230,
                styler: PIVAS.Grid.Styler.IncDesc
            },
            {
                field: 'incSpec',
                title: '规格',
                width: 100
            },
            {
                field: 'dosage',
                title: '剂量',
                width: 75
            },
            {
                field: 'qty',
                title: '数量',
                width: 45,
                align: 'right'
            },
            {
                field: 'freqDesc',
                title: '频次',
                width: 100
            },
            {
                field: 'instrucDesc',
                title: '用法',
                width: 80
            },
            {
                field: 'doctorName',
                title: '医生',
                width: 80
            },
            {
                field: 'priDesc',
                title: '医嘱优先级',
                width: 100
            },
            {
                field: 'bUomDesc',
                title: '单位',
                width: 75
            },
            {
                field: "passResult",
                title: '审核结果',
                width: 85,
                hidden:true
            },
            {
                field: "passResultStat",
                title: '审核状态',
                width: 85,
                hidden:true
            },
            {
                field: 'pivaCatDesc',
                title: '类型',
                width: 50
            }, //,hidden:true
            {
                field: "patSex",
                title: '性别',
                width: 50,
                hidden: true
            },
            {
                field: "patAge",
                title: '年龄',
                width: 75,
                hidden: true
            },
            {
                field: "patWeight",
                title: '体重',
                width: 50,
                hidden: true
            },
            {
                field: "patHeight",
                title: '身高',
                width: 50,
                hidden: true
            },
            {
                field: "diag",
                title: '诊断',
                width: 200,
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
                field: 'oeoriDateTime',
                title: '开医嘱时间',
                width: 115
            },
            {
                field: "oeori",
                title: '医嘱ID',
                width: 150,
                hidden: false
            },
            {
                field: "colColor",
                title: '颜色标识',
                width: 40,
                hidden: true
            },
            {
                field: "analysisData",
                title: '分析结果',
                width: 200,
                hidden: true
            },
            {
                field: "doseDate",
                title: '用药日期',
                width: 75,
                hidden: false
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
        url: '',
        fitColumns: false,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers: false,
        columns: columnspat,
        pageSize: 50,
        pageList: [50, 100, 200],
        pagination: true,
        toolbar: "#gridOrdItemBar",
        onLoadSuccess: function () {
            $(this).datagrid("options").checking = "";
            $(this).datagrid("uncheckAll");
            $(this).datagrid("scrollTo", 0);
            var rowsData = $("#gridOrdItem").datagrid("getRows");
            if (rowsData != "") {
                // 分页数据由临时global获取
                var pid = rowsData[0].pid;
                $('#gridOrdItem').datagrid("options").queryParams.pid = pid;
            }
            GridOrdItemCellTip();
        },
        rowStyler: function (index, rowData) {
            return PIVAS.Grid.RowStyler.Person(index, rowData, "patNo");
        },
        onSelect: function (rowIndex, rowData) {
            if ($(this).datagrid("options").checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItem',
                Field: 'dateMOeori',
                Check: true,
                Value: rowData.dateMOeori,
                Type: 'Select'
            });
            $(this).datagrid("options").checking = "";

        },
        onUnselect: function (rowIndex, rowData) {
			PIVAS.Grid.ClearSelections(this.id)
        },
        onCheck: function (rowIndex, rowData) {
            if ($(this).datagrid("options").checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItem',
                Field: 'dateMOeori',
                Check: true,
                Value: rowData.dateMOeori
            });
            $(this).datagrid("options").checking = "";
        },
        onUncheck: function (rowIndex, rowData) {
            if ($(this).datagrid("options").checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItem',
                Field: 'dateMOeori',
                Check: false,
                Value: rowData.dateMOeori
            });
            $(this).datagrid("options").checking = "";
        },
        onClickCell: function (rowIndex, field, value) {
            if (field == "oeoriSign") {
                if (FormulaId != "") {
                    var mOeori = $(this).datagrid("getRows")[rowIndex].mOeori;
                    PIVASPASSTPN.Init({
                        Params: mOeori + "^" + FormulaId,
                        Field: 'oeoriSign',
                        ClickField: field
                    });
                } else {
                    $.messager.alert('提示', '获取不到审核指标公式</br>请于审核指标公式查看是否维护公式</br>请于参数设置查看是否维护需要使用的指标公式', 'warning');
                }
            } else if (field == "analysisResult") {
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
        //view: groupview,
        groupFormatter: function (value, rows) {
            var rowData = rows[0];
            // 病人基本信息 / 医嘱信息 / 
            var viewDiv = "";
            var patDiv = "";
            var ordDiv = "";
            var wardDiv = "";
            patDiv += '<div id="grpViewPat" class="grpViewPat" style="padding-left:0px">';
            patDiv += '<div >' + rowData.patNo + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.bedNo + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.patName + '</div>';
            patDiv += '<div>/</div>';
            patDiv += '<div>' + rowData.patSex + '</div>';
            if (rowData.patAge != "") {
                patDiv += '<div>/</div>';
                patDiv += '<div>' + rowData.patAge + '</div>';
            }
            if (rowData.patWeight != "") {
                patDiv += '<div>/</div>';
                patDiv += '<div>' + rowData.patWeight + '</div>';
            }
            if (rowData.patHeight != "") {
                patDiv += '<div>/</div>';
                patDiv += '<div>' + rowData.patHeight + '</div>';
            }
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
    var params = patNo + '^' + session['LOGON.HOSPID'];
    $('#gridAdm').datagrid('query', {
        inputParams: params,
        rows: 9999
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
        inputStr: params,
        rows: 9999
    });
}

///查询医嘱
function QueryDetail() {
    ClearTmpGlobal();
    var params = QueryParams("QueryDetail");
    $('#gridOrdItem').datagrid({
        url: PIVAS.URL.COMMON + '?action=JsGetOeAuditDetail',
        pageNumber: 1,
        queryParams: {
            params: params,
            pid: ''
        }
    });
}

/// 获取参数
function QueryParams(queryType) {
    var wardIdStr = "";
    var startDate = $('#dateStart').datebox('getValue'); // 起始日期
    var endDate = $('#dateEnd').datebox('getValue'); // 截止日期
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
                return "";
            }
            for (var i = 0; i < wardChecked.length; i++) {
                if (wardIdStr == "") {
                    wardIdStr = wardChecked[i].wardId;
                } else {
                    wardIdStr = wardIdStr + "," + wardChecked[i].wardId;
                }
            }
        } else if (tabTitle == "按登记号") {
            var admSelected = $('#gridAdm').datagrid("getSelected");
            if (admSelected == null) {
                DHCPHA_HUI_COM.Msg.popover({
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
    var params = startDate + "^" + endDate + "^" + "" + "^" + "" + "^" + SessionLoc + "^" + admId + "^" + wardIdStr + "^" + pivaCat + "^" + passStat + "^" + passResult;
    params += "^" + nurAudit + "^" + priority + "^" + incId + "^" + locGrpId;
    return params;
}

/// 配伍审核通过
function AuditOk(passType) {
    var dateMOeoriStr = GetDateMainOeoriStr();
    if (dateMOeoriStr == "") {
        DetailAlert("SHTG");
        return;
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
        QueryDetail();
    })
}

/// 配伍审核拒绝弹窗
function AuditNoShow(passType) {
    if (PivasWayCode == "") {
        $.messager.alert('提示', '请先维护配伍审核原因', 'warning');
        return;
    }
    var dateMOeoriStr = GetDateMainOeoriStr();
    if (dateMOeoriStr == "") {
        DetailAlert("SHJJ");
        return;
    }
    $('#reasonSelectDiv').window({
        'title': "审核拒绝原因选择"
    }).dialog('open');
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
    if (passVal == 0) {
        $('#reasonSelectDiv').dialog('close');
    } else {
        $.messager.alert('提示', winTitle + '失败', 'error');
    }
    QueryDetail();
    $('#txtReasonNotes').val("");

}

///取消配伍审核
function CancelAudit() {
    var gridOrdItemChecked = $('#gridOrdItem').datagrid("getChecked") || "";
    if (gridOrdItemChecked == "") {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "请勾选需要取消审核的记录",
            type: 'alert'
        });
        return;
    }
    var dateMOeoriArr = [];
    for (var i = 0; i < gridOrdItemChecked.length; i++) {
        var checkedData = gridOrdItemChecked[i];
        var passResultStat = checkedData.passResultStat;
        if (passResultStat == "") {
            continue;
        }
        var dateMOeori = checkedData.dateMOeori;
        if (dateMOeoriArr.indexOf(dateMOeori) < 0) {
            dateMOeoriArr.push(dateMOeori);
        }
    }
    var dateMOeoriStr = dateMOeoriArr.join("^");
    if(dateMOeoriStr==""){
	    DHCPHA_HUI_COM.Msg.popover({
            msg: "没有需要取消审核的记录",
            type: 'alert'
        });	
        return;
    }
    var conditionHtml = "您确认取消审核?";
    $.messager.confirm('温馨提示', conditionHtml, function (r) {
        if (r) {
            var cancelRet = tkMakeServerCall("web.DHCSTPIVAS.OeAudit", "CancelPivasPassMulti", dateMOeoriStr, SessionUser)
            var cancelRetArr = cancelRet.toString().split("^");
            var cancelVal = cancelRetArr[0] || "";
            if (cancelVal == "-1") {
                $.messager.alert('提示', cancelRetArr[1], "warning");
            }
            QueryDetail();
        }
    });
}

/// 病例浏览
function PrbrowserHandeler() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected");
    if (gridSelect == null) {
		DHCPHA_HUI_COM.Msg.popover({
	        msg: "请先选中记录",
	        type: 'alert'
	    });
        return;
    }
    var adm = gridSelect.admId;
    PIVAS.ViewEMRWindow({}, adm);
}

/// 获取选择的主医嘱串
function GetDateMainOeoriStr() {
    var dateMOeoriArr = [];
    var gridOrdItemChecked = $('#gridOrdItem').datagrid('getChecked');
    for (var i = 0; i < gridOrdItemChecked.length; i++) {
        var checkedData = gridOrdItemChecked[i];
        var passResultStat = checkedData.passResultStat;
        // 处理过不再处理
        
        if (passResultStat!= "") {
            continue;
        }
        var warnFlag=checkedData.warnFlag;
        if (warnFlag.indexOf("护士拒绝")>=0){
	    	continue;
	    }
        if (warnFlag.indexOf("护士未处理")>=0){
	    	continue;
	    }
        var dateMOeori = checkedData.dateMOeori;
        if (dateMOeoriArr.indexOf(dateMOeori) < 0) {
            dateMOeoriArr.push(dateMOeori);
        }
    }
    return dateMOeoriArr.join("^");
}

function ClearGrid() {

}

function AuditRecordLog() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected");
    if (gridSelect == null) {
		DHCPHA_HUI_COM.Msg.popover({
	        msg: "请先选中记录",
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
        FormulaId = tkMakeServerCall("web.DHCSTPIVAS.Common", "GetDIIIdByDesc", FormulaDesc);
        if (jsonData.GroupView == "Y") {
            ChangeView();
        }
    });
}

function AnalyPresc() {
    if (PIVAS.VAR.PASS == "DHC") {
        DHCSTPHCMPASS.PassAnalysis({
            GridId: "gridOrdItem",
            MOeori: "dateMOeori",
            GridType: "EasyUI",
            Field: "analysisResult",
            CallBack: GridOrdItemCellTip
        })
    } else if (PIVAS.VAR.PASS=="DT"){
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

/// 明细表格celltip
function GridOrdItemCellTip() {
    PIVAS.Grid.CellTip({
        TipArr: ['ordRemark']
    });
    PIVAS.Grid.CellTip({
        TipArr: ['patNo'],
        ClassName: 'web.DHCSTPIVAS.Common',
        MethodName: 'PatBasicInfoHtml',
        TdField: 'mOeori'
    });
    PIVAS.Grid.CellTip({
        TipArr: ['warnFlag'],
        ClassName: 'web.DHCSTPIVAS.OeAudit',
        MethodName: 'WarnFlagInfoHtml',
        TdField: 'dateMOeori'
    });
}
// 清除本程序涉及的所有临时global
function ClearTmpGlobal() {
    var rowsData = $("#gridOrdItem").datagrid("getRows");
    if (rowsData == "") {
        return;
    }
    var pid = rowsData[0].pid;
    tkMakeServerCall("web.DHCSTPIVAS.OeAudit", "KillOeAudit", pid)
}
window.onbeforeunload = function () {
    ClearTmpGlobal();
}

function ChangeView() {
    var hsMethod = "";
    var showView = "";
    if (ChangeViewNum % 2 == 1) {
        hsMethod = "hideColumn";
        showView = groupview;
    } else {
        hsMethod = "showColumn"
        showView = $.fn.datagrid.defaults.view;
    }
    var gridOpts = $("#gridOrdItem").datagrid("options");
    $('#gridOrdItem').datagrid(hsMethod, 'patNo');
    $('#gridOrdItem').datagrid(hsMethod, 'patName');
    $('#gridOrdItem').datagrid(hsMethod, 'bedNo');
    $('#gridOrdItem').datagrid(hsMethod, 'wardDesc');
    //$('#gridOrdItem').datagrid(hsMethod, 'priDesc');
    //$('#gridOrdItem').datagrid(hsMethod, 'instrucDesc');
    //$('#gridOrdItem').datagrid(hsMethod, 'freqDesc');
    $('#gridOrdItem').datagrid('options').view = showView
    $('#gridOrdItem').datagrid("reload")
    ChangeViewNum++;
}

/// 详细提示,对应通过\拒绝,当未勾选时进入
function DetailAlert(auditType) {
    var dateMOeoriArr = [];
    var shtgArr = [];
    var shjjArr = [];
    var hsjjArr=[];
    var hswclArr=[];
    var gridOrdItemChecked = $('#gridOrdItem').datagrid('getChecked');
    for (var i = 0; i < gridOrdItemChecked.length; i++) {
        var checkedData = gridOrdItemChecked[i];
        var passResultStat = checkedData.passResultStat;
        var passResult= checkedData.passResult;
        var dateMOeori = checkedData.dateMOeori;
        var warnFlag=checkedData.warnFlag;
        // 处理过不再处理
        if (passResultStat == "") {
            if (dateMOeoriArr.indexOf(dateMOeori) < 0) {
                dateMOeoriArr.push(dateMOeori);
            }
        } else if (passResult=="Y") {
            if (shtgArr.indexOf(dateMOeori) < 0) {
                shtgArr.push(dateMOeori);
            }
        } else if ((passResult=="N")||(passResult=="NY")) {
            if (shjjArr.indexOf(dateMOeori) < 0) {
                shjjArr.push(dateMOeori);
            }
        } 
        if (warnFlag.indexOf("护士拒绝")>=0){
	       if (hsjjArr.indexOf(dateMOeori) < 0) {
               hsjjArr.push(dateMOeori);
           }	
	    }
        if (warnFlag.indexOf("护士未处理")>=0){
	       if (hswclArr.indexOf(dateMOeori) < 0) {
               hswclArr.push(dateMOeori);
           }	
	    }
    }
    var msgInfo = "请先选择记录"
    if (auditType == "SHTG") {
        if (shjjArr.length > 0) {
            msgInfo = "请先取消审核";
        } else if (shtgArr.length > 0) {
            msgInfo = "您选择的记录已审核通过";
        }
    } else if (auditType == "SHJJ") {
        if (shtgArr.length > 0) {
            msgInfo = "请先取消审核";
        } else if (shjjArr.length > 0) {
            msgInfo = "您选择的记录已审核拒绝";
        }
    }
	if (hsjjArr.length>0){
    	msgInfo = "您选择的记录已护士拒绝";
	}
	if (hswclArr.length>0){
    	msgInfo = "您选择的记录护士尚未处理医嘱";
	}
	DHCPHA_HUI_COM.Msg.popover({
        msg: msgInfo,
        type: 'alert'
    });
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
			        	newWarnFlag="药师标注";
			        }else{
				        if (oldWarnFlag.indexOf("药师标注")<0){
				    		newWarnFlag=oldWarnFlag+"</br>药师标注";
				        }
				    }
				    if (rText==""){
					    newWarnFlag=newWarnFlag.replace(/<\/br>药师标注/g,"");
						newWarnFlag=newWarnFlag.replace(/药师标注/g,"");
					}
			        $('#gridOrdItem').datagrid('updateRow',{
				    	index:rowIndex,
				    	row:{
					    	warnFlag:newWarnFlag
					    }
				    });
				    GridOrdItemCellTip();
		        } else {
		            $.messager.alert('提示', passInfo, 'warning');
		        }
		    })
		}	
	});
}