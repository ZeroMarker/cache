/** 
 * 模块: 	 静脉配伍审核
 * 编写日期: 2018-02-11
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionGroup = session['LOGON.GROUPID'];
var PivasWayCode = tkMakeServerCall("web.DHCSTPIVAS.Common", "PivasWayCode");
var ChangeViewNum = 1;
$(function() {
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridWard();
    InitGridAdm();
    InitGridOrdItem();
    InitTreeGridReason();
    $('#btnFind').on("click", Query);
    $('#btnFindDetail').on("click", QueryDetail);
    $('#btnAuditOk').on("click", function() {
        // 审核通过
        AuditOk("SHTG");
    });
    $("#btnPackNor").on("click", function() {
        // 正常打包
        AuditOk("ZCDB");
    });
    $('#btnAuditNo').on("click", function() {
        AuditNoShow("SHJJ");
    });
    $("#btnPackUnNor").on("click", function() {
        AuditNoShow("FZCDB");
    });
    $('#btnCancelAudit').on("click", CancelAudit);
    $('#btnAnalyPresc').on("click", AnalyPresc); //合理用药
    $("#btnPrBroswer").on("click", PrbrowserHandeler);
    $('#txtPatNo').on('keypress', function(event) {
        if (event.keyCode == "13") {
            GetPatAdmList(); //调用查询
        }
    });
    $("#btnHelp").on({
        "mousemove": function() {
            $('#helpWindowDiv').window('open');
            $('#helpWindowDiv').window('move', {
                left: event.clientX - $("#helpWindowDiv").width(),
                top: event.clientY,
            });
        },
        "mouseleave": function() {
            $('#helpWindowDiv').window('close');
        }
    });
    $("#btnAuditRecord").on("click", AuditRecordLog);
    $("#btnChangeView").on("click", ChangeView);
    //$("#btnMedTips").on("click", MedicineTips)
    InitPivasSettings();
});

function InitDict() {
    // 审核状态
    PIVAS.ComboBox.Init({ Id: 'cmbPassStat', Type: 'PassStat' }, { editable: false, width: 120 });
    $('#cmbPassStat').combobox("setValue", 1);
    // 审核结果
    PIVAS.ComboBox.Init({ Id: 'cmbPassResult', Type: 'PassResult' }, { editable: false, width: 120 });
    $('#cmbPassResult').combobox("setValue", "");
    // 护士审核
    PIVAS.ComboBox.Init({ Id: 'cmbNurAudit', Type: 'NurseResult' }, { editable: false, width: 120 });
    $('#cmbNurAudit').combobox("setValue", 1);
    // 配液大类
    PIVAS.ComboBox.Init({ Id: 'cmbPivaCat', Type: 'PivaCat' }, { width: 120 });
    // 科室组
    PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, {});
    // 病区
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
    // 医嘱优先级
    PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, { width: 120 });
    // 集中配制
    PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, { width: 120 });
    // 药品
    PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, {
        width: 310
    });
}

//初始化病区列表
function InitGridWard() {
    //定义columns
    var columns = [
        [
            { field: 'select', checkbox: true },
            { field: "wardId", title: 'wardId', hidden: true },
            { field: 'wardDesc', title: '病区', width: 200 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.OeAudit",
            QueryName: "OeAuditWard"
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        onClickRow: function(rowIndex, rowData) {
            CurWardID = rowData.wardId;
            CurAdm = "";
        },
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function() {
            $("#gridOrdItem").datagrid("clear");
            $(this).datagrid("uncheckAll");
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridWard", dataGridOption);
}

function InitGridAdm() {
    var options = {
        toolbar: '#gridAdmBar',
        onClickRow: function(rowIndex, rowData) {
            QueryDetail();
        }
    };
    PIVAS.InitGridAdm({ Id: 'gridAdm' }, options);
}

//初始化明细列表
function InitGridOrdItem() {
    //定义columns
    var columnspat = [
        [
            { field: 'gridOrdItemSelect', checkbox: true },
            {
                field: 'warnFlag',
                title: '状态',
                width: 70,
                align: 'left',
                styler: function(value, row, index) {
                    // 备注为安贞客户提出的颜色,如下真实颜色与之暂时不符
                    if (row.priorityDesc == "临时医嘱") {
                        return 'background-color:#F9E701;'; //亮黄
                    } else if (row.passResultDesc == "审核通过") {
                        return 'background-color:#019BC1;color:white;'; //绿色
                    } else if (row.passResultDesc == "审核拒绝") {
                        return 'background-color:#C33A30;color:white;'; //红色
                    } else if (row.passResultDesc == "非正常打包") {
                        return 'background-color:#E46022;'; //浅黄色
                    } else if (row.passResultDesc == "正常打包") {
                        return 'background-color:#009B6B;'; //浅蓝色
                    }
                },
                formatter: function(value, row, index) {
                    if (value == undefined) {
                        value = "";
                    }
                    if (value.indexOf("手术") >= 0) {
                        return PIVAS.Grid.CSS.SurgeryImg;
                    } else {
                        return row.passResultDesc;
                    }
                }
            },
            {
                field: 'analysisResult',
                title: '合理',
                width: 45,
                halign: 'left',
                align: 'center',
                hidden: false,
                formatter: function(value, row, index) {
                    if (value == "1") { // 正常 #16BBA2
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-ok.png" >';
                    } else if (value == "2") { // 警示 #FF6356
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-warn.png" >';
                    } else if (value == "3") { //严重 black
                        return '<img src = "../scripts/pharmacy/common/image/order-pass-error.png" >';
                    }
                    return '';
                }
            },
            { field: 'ordRemark', title: '备注', width: 75 },
            { field: "patNo", title: '登记号', width: 100 },
            { field: "patName", title: '姓名', width: 75 },
            { field: 'bedNo', title: '床号', width: 75 },
            {
                field: 'oeoriSign',
                title: '组',
                width: 30,
                align: 'center',
                halign: 'left',
                styler: function(value, row, index) {
                    // 优先于formatter执行
                    var colColorArr = row.colColor.split("-");
                    var colorStyle = "";
                    if ((colColorArr[0] % 2) == 0) { // 偶数行变色,按病人的背景色
                        colorStyle = PIVAS.Grid.CSS.PersonEven;
                    }
                    return colorStyle;
                },
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            {
                field: 'incDesc',
                title: '药品',
                width: 230,
                styler: PIVAS.Grid.Styler.IncDesc
            },
            { field: 'incSpec', title: '规格', width: 100 },
            { field: 'dosage', title: '剂量', width: 75 },
            { field: 'qty', title: '数量', width: 45, align: 'right' },
            { field: 'freqDesc', title: '频次', width: 100 },
            { field: 'instrucDesc', title: '用法', width: 80 },
            { field: 'doctorName', title: '医生', width: 80 },
            { field: 'wardDesc', title: '病区', width: 200 },
            { field: 'priDesc', title: '医嘱优先级', width: 100 },
            { field: 'bUomDesc', title: '单位', width: 75 },
            { field: "passResultDesc", title: '审核结果', width: 85 },
            { field: 'pivaCatDesc', title: '配液分类', width: 100 }, //,hidden:true
            { field: "patSex", title: '性别', width: 50, hidden: true },
            { field: "patAge", title: '年龄', width: 75, hidden: true },
            { field: "patWeight", title: '体重', width: 50, hidden: true },
            { field: "patHeight", title: '身高', width: 50, hidden: true },
            { field: "diag", title: '诊断', width: 200, hidden: true },
            { field: "mOeori", title: '主医嘱Id', width: 100, hidden: true },
            { field: "admId", title: '就诊Id', width: 100, hidden: true },
            { field: "pid", title: 'pid', width: 200, hidden: true },
            { field: 'oeoriDateTime', title: '开医嘱时间', width: 115 },
            { field: "oeori", title: '医嘱ID', width: 150, hidden: false },
            { field: "colColor", title: '颜色标识', width: 40, hidden: true },
            { field: "analysisData", title: '分析结果', width: 200, hidden: true },
            { field: "doseDate", title: '用药日期', width: 75, hidden: false },
            { field: "dateMOeori", title: '主医嘱Id+日期', width: 200, hidden: false }
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
        onLoadSuccess: function() {
            $(this).datagrid("scrollTo", 0);
            var rowsData = $("#gridOrdItem").datagrid("getRows");
            if (rowsData != "") {
                // 分页数据由临时global获取
                var pid = rowsData[0].pid;
                $('#gridOrdItem').datagrid("options").queryParams.pid = pid;
            }
            GridOrdItemCellTip();
        },
        rowStyler: function(index, row) {
            /*
            var colColorArr=(row.colColor).split("-");
            var colorStyle="";
            if ((colColorArr[1]%2)==0){	// 按成组的背景色
            	colorStyle=PIVAS.Grid.CSS.SignRowEven;
            }
            return colorStyle;	
            */
        },
        onSelect: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItem',
                Field: 'dateMOeori',
                Check: true,
                Value: rowData.dateMOeori,
                Type: 'Select'
            });
        },
        onUnselect: function(rowIndex, rowData) {
            $(this).datagrid("unselectAll");
        },
        onCheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItem',
                Field: 'dateMOeori',
                Check: true,
                Value: rowData.dateMOeori
            });
        },
        onUncheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItem',
                Field: 'dateMOeori',
                Check: false,
                Value: rowData.dateMOeori
            });
        },
        onClickCell: function(rowIndex, field, value) {
            if (field == "oeoriSign") {
                var mOeori = $(this).datagrid("getRows")[rowIndex].mOeori;
                PIVASPASSTPN.Init({
                    Params: mOeori + "^" + 5, // 5 为对应审核指标的Id,此处目前为写死,对应TPN
                    Field: 'oeoriSign',
                    ClickField: field
                });
            } else if (field == "analysisResult") {
                var content = $(this).datagrid("getRows")[rowIndex].analysisData;
                DHCSTPHCMPASS.AnalysisTips({ Content: content })
            }
        },
        onDblClickCell: function(rowIndex, field, value) {
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
                    IncDesc: value
                })
            }
        },
        groupField: 'dateMOeori',
        //view: groupview,
        groupFormatter: function(value, rows) {
            var rowData = rows[0];
            var grpData = rowData.patNo + " " + rowData.bedNo + " " + rowData.patName + " " + rowData.wardDesc
            return grpData;
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrdItem", dataGridOption);
}

function InitTreeGridReason() {
    var treeColumns = [
        [
            { field: 'reasonId', title: 'reasonId', width: 250, hidden: true },
            { field: 'reasonDesc', title: '原因', width: 250 },
            { field: '_parentId', title: 'parentId', hidden: true }
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
            params: PivasWayCode + "^"
        }
    });
}

///按登记号查询就诊列表
function GetPatAdmList() {
    var patNo = $('#txtPatNo').val();
    var patLen = PIVAS.PatNoLength();
    var plen = patNo.length;
    if (plen > patLen) {
        $.messager.alert('提示', '输入登记号错误!', 'warning');
        return;
    }
    for (i = 1; i <= patLen - plen; i++) {
        patNo = "0" + patNo;
    }
    $('#txtPatNo').val(patNo);
    var params = patNo;
    $('#gridAdm').datagrid('query', {
        inputParams: params
    });
}

///查询
function Query() {
    ClearTmpGlobal();
    var params = QueryParams("Query");
    $('#gridWard').datagrid('query', { inputStr: params });
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
    var locGrpId = $('#cmbLocGrp').combobox("getValue"); // 科室组
    var pivaCat = $("#cmbPivaCat").combobox("getValue"); // 配液分类
    var passStat = $("#cmbPassStat").combobox("getValue"); // 审核状态
    var passResult = $("#cmbPassResult").combobox("getValue"); // 审核结果
    var nurAudit = $("#cmbNurAudit").combobox("getValue"); // 护士审核
    var priority = $("#cmbPriority").combobox("getValue"); // 医嘱优先级	
    var locGrpId = $('#cmbLocGrp').combobox("getValue"); // 科室组	
    var admId = "";
    // 如果为查询明细,则wardId取选择的Id
    var tabTitle = $('#tabsOne').tabs('getSelected').panel('options').title;
    if (queryType == "QueryDetail") {
        if (tabTitle == "病区列表") {
            var wardChecked = $('#gridWard').datagrid('getChecked');
            if (wardChecked == "") {
                $.messager.alert('提示', '请选择病区', 'warning');
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
                $.messager.alert('提示', '请选择就诊记录', 'warning');
                return "";
            }
            wardIdStr = "";
            admId = admSelected.admId;
        }
    } else {
        wardIdStr = $("#cmbWard").combobox("getValue");
    }
    var incId = $("#cmgIncItm").combobox("getValue");
    var params = startDate + "^" + endDate + "^" + "" + "^" + "" + "^" + SessionLoc + "^" + admId + "^" + wardIdStr + "^" + pivaCat + "^" + passStat + "^" + passResult;
    params += "^" + nurAudit + "^" + priority + "^" + incId + "^" + locGrpId;
    return params;
}

/// 配伍审核通过
function AuditOk(passType) {
    var dateMOeoriStr = GetDateMainOeoriStr();
    if (dateMOeoriStr == "") {
        $.messager.alert('提示', '请先选择记录!', 'warning');
        return;
    }
    PIVAS.Progress.Show({ type: 'save', interval: 1000 });
    $.m({
        ClassName: "web.DHCSTPIVAS.OeAudit",
        MethodName: "PivasPass",
        dateMOeoriStr: dateMOeoriStr,
        userId: SessionUser,
        passType: passType
    }, function(passRet) {
        PIVAS.Progress.Close();
        var passRetArr = passRet.split("^");
        var passVal = passRetArr[0];
        var passInfo = passRetArr[1];
        if (passVal == 0) {
            //$.messager.alert('提示','审核通过!','info');
        } else {
            $.messager.alert('提示', '审核失败!', 'error');
        }
        QueryDetail();
    })
}

/// 配伍审核拒绝弹窗
function AuditNoShow(passType) {
    if (PivasWayCode == "") {
        $.messager.alert('提示', '请先维护拒绝原因!', 'warning');
        return;
    }
    var dateMOeoriStr = GetDateMainOeoriStr();
    if (dateMOeoriStr == "") {
        $.messager.alert('提示', '请先选择未操作过的记录!', 'warning');
        return;
    }
    if (passType == "FZCDB") {
        $('#reasonSelectDiv').window({ 'title': "非正常打包原因选择" });
    } else {
        $('#reasonSelectDiv').window({ 'title': "审核拒绝原因选择" });
    }
    $('#reasonSelectDiv').dialog('open');
    $('#treeGridReason').treegrid('clearChecked');
    $('#treeGridReason').treegrid({
        queryParams: {
            params: PivasWayCode + "^1"
        }
    });
}

/// 拒绝
function AuditNo() {
    var winTitle = $("#reasonSelectDiv").panel('options').title;
    var passType = "SHJJ";
    if (winTitle == "非正常打包") {
        passType = "FZCDB";
    }
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


}

///取消配伍审核
function CancelAudit() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert('提示', '请选择一条记录', "warning");
        return;
    }
    /*
    var dateMOeori = gridSelect.dateMOeori;
    var cancelWarnInfo = tkMakeServerCall("web.DHCSTPIVAS.OeAudit", "GetCancelWarnInfo", dateMOeori);
    var ConfirmMsgInfoArr = [];
    if (cancelWarnInfo != "") {
        var cancelWarnArr = cancelWarnInfo.split("^");
        for (var cI = 0; cI < cancelWarnArr.length; cI++) {
            var cancelInfo = cancelWarnArr[cI].split(":");
            ConfirmMsgInfoArr.push({ title: cancelInfo[0] + ":", data: cancelInfo[1] });
        }
    } else {
        return;
    }
    var conditionHtml = PIVAS.Html.ConfirmInfo({ Data: ConfirmMsgInfoArr });
    */
    var conditionHtml = "您确认取消审核?";
    $.messager.confirm('温馨提示', conditionHtml, function(r) {
        if (r) {
            /*按勾选
            var lastoeori=""
            var dispgridselect=$('#ordtimdg').datagrid("getRows");
            var dispgridrows=dispgridselect.length;
            for(var i=0;i<dispgridrows;i++){
            	var selecteddata=dispgridselect[i];
            	var select=selecteddata["TSelect"]
            	var oeori=selecteddata["Tbtoeori"]
            	var AuditRes=selecteddata["TbAuditRes"];
            	var moeori=selecteddata["TbMOeori"];
             	if(AuditRes==""){continue}
             	if(lastoeori==moeori){continue}
             	var str=UserDr+"^"+moeori
            	if (select=="Y"){			
            		var ret=tkMakeServerCall("web.DHCSTPIVAS.OeAudit","CancelOrdAudit",str)
            		lastoeori=moeori
            	};
            }
            */
            // 按单条

            var dateMOeori = gridSelect.dateMOeori;
            var cancelRet = tkMakeServerCall("web.DHCSTPIVAS.OeAudit", "CancelPivasPass", dateMOeori, SessionUser)
            QueryDetail();
        }
    });
}

/// 病例浏览
function PrbrowserHandeler() {
    var gridSelect = $('#gridOrdItem').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert('提示', '请选择一条记录', "warning");
        return;
    }
    var adm = gridSelect.admId;
    var wWidth = document.body.clientWidth * 0.9;
    var wHeight = document.body.clientHeight * 0.9;
    var lnk = "emr.record.browse.csp?EpisodeID=" + adm;
    window.open(lnk, "_blank", "width=" + wWidth + ",height=" + wHeight + ",menubar=no,status=yes,toolbar=no,resizable=yes");
}

/// 获取选择的主医嘱串
function GetDateMainOeoriStr() {
    var dateMOeoriArr = [];
    var gridOrdItemChecked = $('#gridOrdItem').datagrid('getChecked');
    for (var i = 0; i < gridOrdItemChecked.length; i++) {
        var checkedData = gridOrdItemChecked[i];
        var passResultDesc = checkedData.passResultDesc;
        // 处理过不再处理
        if (passResultDesc != "") {
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
        $.messager.alert('提示', '请选择一条记录', "warning");
        return;
    }
    var dateMOeori = gridSelect.dateMOeori;
    var winDivId = 'OeAuditWindowDiv';
    var winDiv = '<div id="OeAuditWindowDiv"><div id="gridOeAuditRecord"></div></div>'
    $("body").append(winDiv);
    //定义表格
    var columns = [
        [
            { field: 'passResult', title: '审核状态', width: 100 },
            { field: 'userName', title: '操作人', width: 100 },
            { field: 'dateTime', title: '操作时间', width: 160 },
            { field: 'reasonDesc', title: '处理原因', width: 250 },
            { field: 'docAgree', title: '医生接受', width: 80 },
            { field: 'docNotes', title: '医生申诉', width: 80 },
            { field: 'oeoriStat', title: '医嘱状态', width: 80 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.OeAudit',
            QueryName: 'OeAuditRecord',
            dateMOeori: dateMOeori
        },
        fit: true,
        rownumbers: false,
        columns: columns,
        pagination: false,
        singleSelect: true,
        nowrap: false
    };
    DHCPHA_HUI_COM.Grid.Init("gridOeAuditRecord", dataGridOption);
    $('#OeAuditWindowDiv').window({
        title: ' 配伍审核记录',
        collapsible: false,
        iconCls: "icon-history-rec",
        border: false,
        closed: true,
        modal: true,
        width: 900,
        height: 500,
        onBeforeClose: function() {
            $("#OeAuditWindowDiv").remove()
        }
    });
    $('#OeAuditWindowDiv').window('open');
}

/// 初始化默认条件
function InitPivasSettings() {
    $.cm({
        ClassName: "web.DHCSTPIVAS.Settings",
        MethodName: "GetAppProp",
        userId: session['LOGON.USERID'],
        locId: session['LOGON.CTLOCID'],
        appCode: "OeAudit"
    }, function(jsonData) {
        $("#dateStart").datebox("setValue", jsonData.OrdStDate);
        $("#dateEnd").datebox("setValue", jsonData.OrdEdDate);
        PIVAS.VAR.PASS = jsonData.Pass;
    });
}

function AnalyPresc() {
    if (PIVAS.VAR.PASS == "DHC") {
        DHCSTPHCMPASS.PassAnalysis({ GridId: "gridOrdItem", MOeori: "mOeori", GridType: "EasyUI", Field: "analysisResult", CallBack: GridOrdItemCellTip })
    }
}

/// 明细表格celltip
function GridOrdItemCellTip() {
    PIVAS.Grid.CellTip({ TipArr: ['ordRemark', 'incDesc'] });
    PIVAS.Grid.CellTip({
        TipArr: ['patNo'],
        ClassName: 'web.DHCSTPIVAS.Common',
        MethodName: 'PatBasicInfoHtml',
        TdField: 'mOeori'
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
window.onbeforeunload = function() {
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
    $('#gridOrdItem').datagrid('options').view = showView
    $('#gridOrdItem').datagrid("reload")
    ChangeViewNum++;
}