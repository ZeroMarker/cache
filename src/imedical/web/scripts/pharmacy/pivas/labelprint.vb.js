/** 
 * 模块:	配液中心标签打印(批量)
 * 编写日期:2018-02-27
 * 编写人:  yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var NeedUserArr = []; //是否录入排药,贴签,核对人配置,
var ConfirmMsgInfoArr = [];
var GridCmbBatNo;
var GridCmbPrtWay;
$(function() {
    InitDict();
    InitPivasSettings();
    InitGridWard();
    InitGridAdm();
    InitGridWorkType();
    InitGridOrdExe();
    $("#btnFind").on("click", Query);
    $("#btnFindDetail").on("click", QueryDetail);
    $("#btnPrint").on("click", ConfirmSaveData);
    $('#btnPack').on('click', function() {
        PackSelectDsp('P');
    });
    $('#btnUnPack').on('click', function() {
        PackSelectDsp('');
    });
    $('#txtPatNo').on('keypress', function(event) {
        if (event.keyCode == "13") {
            GetPatAdmList(); //调用查询
        }
    });
    $("#tabsDetail").tabs({
        onSelect: function(title) {
            if (title.indexOf("医嘱") >= 0) {
                $("#gridOrdExe").datagrid("clear")
                QueryOrdExe();
            }
        }
    });
});

function InitDict() {
    // 配液大类
    PIVAS.ComboBox.Init({ Id: 'cmbPivaCat', Type: 'PivaCat' }, {});
    // 科室组
    PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, {});
    // 病区
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
    // 医嘱优先级
    PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, {});
    // 工作组
    PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, {});
    // 药品
    PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, {});
    // 打包
    PIVAS.ComboBox.Init({ Id: 'cmbPack', Type: 'PackType' }, {});
    // 用法
    PIVAS.ComboBox.Init({ Id: 'cmbInstruc', Type: 'Instruc' }, {});
    // 批次
    PIVAS.BatchNoCheckList({ Id: "DivBatNo", LocId: SessionLoc, Check: true, Pack: false });
    // 人员
    PIVAS.ComboBox.Init({ Id: 'cmbNeedUser30', Type: 'LocUser' }, {});
    PIVAS.ComboBox.Init({ Id: 'cmbNeedUser40', Type: 'LocUser' }, {});
    PIVAS.ComboBox.Init({ Id: 'cmbNeedUser50', Type: 'LocUser' }, {});
    GridCmbBatNo = PIVAS.UpdateBatNoCombo({
        LocId: SessionLoc,
        GridId: "gridOrdExe",
        Field: "batNo",
        BatUp: "batUp",
        MDspField: "mDsp"
    });
    GridCmbPrtWay = PIVAS.PrtWayCombo({
        GridId: "gridWorkType",
        Field: "prtWayId"
    });
}

function InitGridWard() {
    var columns = [
        [
            { field: 'wardSelect', checkbox: true },
            { field: "wardId", title: 'wardId', hidden: true },
            { field: 'wardDesc', title: '病区', width: 200 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.LabelPrint",
            QueryName: "LabelPrintWard"
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        onClickRow: function(rowIndex, rowData) {},
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function() {
            $("#gridWard").datagrid("uncheckAll");
            $("#gridWorkType").datagrid("uncheckAll");
            $("#gridOrdExe").datagrid("uncheckAll");
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridWard", dataGridOption);
}

/// 初始化就诊
function InitGridAdm() {
    var options = {
        toolbar: '#gridAdmBar',
        onClickRow: function(rowIndex, rowData) {
            QueryDetail();
        }
    };
    PIVAS.InitGridAdm({ Id: 'gridAdm' }, options);
}

function InitGridWorkType() {
    var columns = [
        [
            { field: 'workTypeSelect', checkbox: true },
            { field: 'pid', title: '进程', width: 100, hidden: true },
            { field: 'workTypeId', title: '工作组Id', width: 100, hidden: true },
            { field: 'prtWayDesc', title: '打印排序描述', width: 100, hidden: true },
            { field: 'wtCode', title: '工作组代码', width: 100 },
            { field: 'wtDesc', title: '工作组名称', width: 200 },
            {
                field: 'prtWayId',
                title: '打印排序方式',
                width: 200,
                editor: GridCmbPrtWay,
                descField: 'prtWayDesc',
                formatter: function(value, row, index) {
                    return row.prtWayDesc
                }
            },
            { field: 'orderCnt', title: '组数', width: 50 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.LabelPrint",
            QueryName: "LabelPrintWorkType"
        },
        fitColumns: true,
        columns: columns,
        singleSelect: true,
        selectOnCheck: false,
        checkOnSelect: false,
        onClickCell: function(rowIndex, field, value) {
            if ((field == "prtWayId") && (value != "")) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'prtWayId'
                });
            } else {
                $(this).datagrid('endEditing');
            }
        },
        onLoadSuccess: function() {
            if ($("#gridWorkType").datagrid("getRows") != "") {
                $("#gridWorkType").datagrid("checkAll");
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridWorkType", dataGridOption);
}

//初始化明细列表
function InitGridOrdExe() {
    var columns = [
        [
            { field: 'ordExeCheck', checkbox: true },
            { field: 'warnInfo', title: '提醒', width: 50, hidden: false },
            { field: 'pid', title: 'pid', width: 50, hidden: true },
            { field: 'ordRemark', title: '备注', width: 75 },
            { field: 'doseDateTime', title: '用药日期', width: 95 },
            { field: 'bedNo', title: '床号', width: 75 },
            { field: 'patNo', title: '登记号', width: 100 },
            { field: 'patName', title: '姓名', width: 100 },
            {
                field: 'batNo',
                title: '批次',
                width: 75,
                editor: GridCmbBatNo,
                styler: function(value, row, index) {
                    var colorStyle = 'text-decoration:underline;';
                    if (row.packFlag != "") {
                        colorStyle += PIVAS.Grid.CSS.BatchPack;
                    }
                    return colorStyle;
                }
            },
            {
                field: 'oeoriSign',
                title: '组',
                width: 30,
                halign: 'left',
                align: 'center',
                styler: function(value, row, index) {
                    var colColorArr = row.colColor.split("-");
                    var colorStyle = "";
                    if ((colColorArr[0] % 2) == 0) { // 偶数行变色,按病人的背景色
                        colorStyle = PIVAS.Grid.CSS.PersonEven;
                    }
                    return colorStyle;
                },
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            { field: 'incDesc', title: '药品', width: 250 ,styler: PIVAS.Grid.Styler.IncDesc},
            { field: 'incSpec', title: '规格', width: 100 },
            { field: 'dosage', title: '剂量', width: 75 },
            { field: 'qty', title: '数量', width: 50 },
            { field: 'freqDesc', title: '频次', width: 75 },
            { field: 'instrucDesc', title: '用法', width: 80 },
            { field: 'bUomDesc', title: '单位', width: 50 },
            { field: 'docName', title: '医生', width: 75 },
            { field: "passResultDesc", title: '审核结果', width: 85 },
            { field: 'priDesc', title: '优先级', width: 75 },
            { field: "packFlag", title: '打包', width: 85, halign: 'left', align: 'center' },
            { field: "mDsp", title: 'mDsp', width: 70, hidden: true },
            { field: 'colColor', title: 'colColor', width: 50 },
            { field: "incDescStyle", title: 'incDescStyle', width: 70, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: '',
        fit: true,
        toolbar: '#gridOrdExeBar',
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageSize: 50,
        pageList: [50, 100, 200],
        pagination: true,
        rowStyler: function(index, row) {
            /*
            var colColorArr=(row.TbColColor).split("-");
            var colorStyle="";
            if ((colColorArr[1]%2)==0){	// 按成组的背景色
            	colorStyle=PIVAS.Grid.CSS.SignRowEven;
            }
            return colorStyle;	
            */
        },
        onClickRow: function(rowIndex, rowData) {

        },
        onSelect: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp,
                Type: 'Select'
            });
        },
        onUnselect: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp,
                Type: 'Select'
            });
        },
        onClickCell: function(rowIndex, field, value) {
            if ((field == "batNo") && (value != "")) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'batNo'
                });
            } else {
                $(this).datagrid('endEditing');
            }
        },
        onCheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp
            });
        },
        onUncheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: false,
                Value: rowData.mDsp
            });
        },
        onLoadSuccess: function() {
            $(this).datagrid("scrollTo", 0);
            PIVAS.Grid.CellTip({ TipArr: ['ordRemark', 'incDesc'] });
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
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

/// 查询病区
function Query() {
    ClearDetailGrid();
    var params = QueryParams("Query");
    if (params == "") {
        return;
    }
    $('#gridWard').datagrid('query', {
        inputStr: params
    });;
}
/// 查询工作组
function QueryDetail() {
    ClearTmpGlobal();
    var params = QueryParams("QueryDetail");
    if (params == "") {
        return;
    }
    $('#tabsDetail').tabs('select', '工作组');
    $('#gridWorkType').datagrid('query', {
        inputStr: params
    });
}
/// 查询工作组明细
function QueryOrdExe() {
    var rowsData = $("#gridWorkType").datagrid("getRows");
    if (rowsData == "") {
        $.messager.alert('提示', '工作组列表无数据', 'warning');
        $("#tabsDetail").tabs("select", 0);
        return;
    }
    var pid = rowsData[0].pid;
    if (pid == "") {
        $.messager.alert('提示', '获取不到PID', 'warning');
        $("#tabsDetail").tabs("select", 0);
        return;
    }
    var prtWayStr = "";
    var gridWTChecked = $('#gridWorkType').datagrid('getChecked');
    for (var i = 0; i < gridWTChecked.length; i++) {
        var checkedData = gridWTChecked[i];
        var workTypeId = checkedData.workTypeId;
        var prtWayId = checkedData.prtWayId;
        prtWayStr = (prtWayStr == "") ? workTypeId + "^" + prtWayId : prtWayStr + "!!" + workTypeId + "^" + prtWayId;
    }
    if (prtWayStr == "") {
        $.messager.alert('提示', '请选择工作组', 'warning');
        $("#tabsDetail").tabs("select", 0);
        return;
    }
    $('#gridOrdExe').datagrid({
        url: PIVAS.URL.COMMON + '?action=JsGetLabelPrintDetail',
        queryParams: {
            params: pid + "|@|" + prtWayStr
        }
    });
}
/// 查询条件
function QueryParams(queryType) {
    var startDate = $('#dateStart').datebox('getValue'); // 起始日期
    var endDate = $('#dateEnd').datebox('getValue'); // 截止日期
    var locGrpId = $('#cmbLocGrp').combobox("getValue") || ''; // 科室组
    var wardIdStr = $("#cmbWard").combobox("getValue") || ''; // 病区	
    var pivaCat = $("#cmbPivaCat").combobox("getValue") || ''; // 配液大类
    var workType = $("#cmbWorkType").combobox("getValue") || ''; // 工作组
    var priority = $("#cmbPriority").combobox("getValue") || ''; // 医嘱优先级
    var incId = $("#cmgIncItm").combobox("getValue") || ''; // 药品
    var packFlag = $("#cmbPack").combobox("getValues") || ''; // 打包类型
    var instrucId = $("#cmbInstruc").combobox("getValue") || ''; // 用法
    var batNoStr = "";
    var admId = "";
    var wardIdStr = "";
    $("input[type=checkbox][name=batbox]").each(function() {
        if ($('#' + this.id).is(':checked')) {
            if (batNoStr == "") {
                batNoStr = this.value;
            } else {
                batNoStr = batNoStr + "," + this.value;
            }
        }
    });
    if (queryType == "QueryDetail") {
        var tabTitle = $('#tabsTotal').tabs('getSelected').panel('options').title;
        if (tabTitle == "病区列表") {
            var gridWardChecked = $('#gridWard').datagrid('getChecked');
            for (var i = 0; i < gridWardChecked.length; i++) {
                var checkedData = gridWardChecked[i];
                wardIdStr = (wardIdStr == "" ? checkedData.wardId : wardIdStr + "," + checkedData.wardId)
            }
            if (wardIdStr == "") {
                $.messager.alert('提示', '请选择病区', 'warning');
                return "";
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

    }
    var params = SessionLoc + "^" + wardIdStr + "^" + startDate + "^" + endDate + "^" + locGrpId + "^" +
        pivaCat + "^" + workType + "^" + priority + "^" + incId + "^" + instrucId + "^" +
        packFlag + "^" + batNoStr + "^" + admId;
    return params;
}

/// 保存数据前操作
function ConfirmSaveData() {
    // if (PIVASPRINT.CheckActiveX("DHCSTPrint.PIVALabel") == false) {
    //   return;
    //}
    var rowsData = $("#gridWorkType").datagrid("getRows");
    if (rowsData == "") {
        $.messager.alert('提示', '工作组列表无数据', 'warning');
        return;
    }
    var pid = rowsData[0].pid;
    if (pid == "") {
        $.messager.alert('提示', '获取不到PID', 'warning');
        return;
    }
    $.messager.confirm('提示', "您确认打印标签吗?", function(r) {
        if (r) {
            var userNum = NeedUserArr.length;
            if (userNum > 0) {
                // 写死判断先
                for (var i = 0; i < userNum; i++) {
                    var needUserCode = NeedUserArr[i];
                    var cmbUserId = "cmb" + needUserCode;
                    $("#needUserWin #" + cmbUserId).closest("tr").css("display", "table")
                }
                $('#needUserWin').window({ height: 90 + (userNum * 45) });
                $('#needUserWin').window({ width: 280 });
                $('#needUserWin').window('open');
            } else {
                SaveData("", "", "");
            }
            
            
        }
    });
}

function NeedUserWinSave() {
    var user30 = "";
    var user40 = "";
    var user50 = "";
    if (NeedUserArr.indexOf("NeedUser30") >= 0) {
        user30 = $("#cmbNeedUser30").combobox("getValue") || "";
        if (user30 == "") {
            $.messager.alert('提示', '请选择排药核对人', 'warning');
            return;
        }
    }
    if (NeedUserArr.indexOf("NeedUser40") >= 0) {
        user40 = $("#cmbNeedUser40").combobox("getValue") || "";
        if (user40 == "") {
            $.messager.alert('提示', '请选择贴签核对人', 'warning');
            return;
        }
    }
    if (NeedUserArr.indexOf("NeedUser50") >= 0) {
        user50 = $("#cmbNeedUser50").combobox("getValue") || "";
        if (user50 == "") {
            $.messager.alert('提示', '请选择核对核对人', 'warning');
            return;
        }
    }
    $('#needUserWin').window('close');
    SaveData(user30, user40, user50);
}
/// 保存数据
function SaveData(user30, user40, user50) {
    var rowsData = $("#gridWorkType").datagrid("getRows");
    if (rowsData == "") {
        $.messager.alert('提示', '工作组列表无数据', 'warning');
        return;
    }
    var pid = rowsData[0].pid;
    if (pid == "") {
        $.messager.alert('提示', '获取不到PID', 'warning');
        return;
    }
    var gridChecked = $("#gridWorkType").datagrid("getChecked");
    var prtWayStr = "";
    var workTypeStr = "";
    for (var i = 0; i < gridChecked.length; i++) {
        var workTypeId = gridChecked[i].workTypeId;
        var prtWayId = gridChecked[i].prtWayId;
        prtWayStr = (prtWayStr == "") ? workTypeId + "^" + prtWayId : prtWayStr + "!!" + workTypeId + "^" + prtWayId;
        workTypeStr = (workTypeStr == "") ? workTypeId : workTypeStr + "^" + workTypeId;
    }
    if (prtWayStr == "") {
        $.messager.alert('提示', '获取不到打印方式', 'warning');
        return;
    }
    PIVAS.Progress.Show({ type: 'save', interval: 1000 });
    $.m({
        ClassName: "web.DHCSTPIVAS.LabelPrint",
        MethodName: "SaveData",
        pid: pid,
        userId: SessionUser,
        workTypeStr: workTypeStr,
        user30: user30,
        user40: user40,
        user50: user50
    }, function(retData) {
        PIVAS.Progress.Close();
        var retArr = retData.split("^");
        if (retArr[0] == -1) {
            $.messager.alert('提示', retArr[1], 'warning');
            return;
        } else if (retArr[0] < -1) {
            $.messager.alert('提示', retArr[1], 'error');
            return;
        } else {
            PIVASPRINT.CallBack = QueryDetail;
            PIVASPRINT.LabelsJsonByPogsNo({ pogsNo: retArr[0], sortWay: prtWayStr })
        }
    });
}

// 打包操作
function PackSelectDsp(packFlag) {
    $.messager.confirm('提示', "您确认" + ((packFlag == "P") ? "打包" : "取消打包") + "吗?", function(r) {
        if (r) {
            var mDspStr = GetMainDspStr();
            if (mDspStr == "") {
                $.messager.alert('提示', '请勾选需要' + ((packFlag == "P") ? "打包" : "取消打包") + '的记录', 'warning');
                return;
            }
            var retData = tkMakeServerCall("web.DHCSTPIVAS.DataHandler", "UpdateOeDspToPackMulti", mDspStr, packFlag)
            var retArr = retData.split("^");
            if (retArr[0] == -1) {
                $.messager.alert('提示', retArr[1], 'warning');
                return;
            } else if (retArr[0] < -1) {
                $.messager.alert('提示', retArr[1], 'error');
                return;
            }
            DHCPHA_HUI_COM.Msg.popover({
                msg: ((packFlag == "P") ? "打包" : "取消打包") + '成功',
                type: 'success'
            });
            QueryOrdExe();
            //$('#gridOrdExe').datagrid('reload');
        }
    })
}
/// 初始化默认条件
function InitPivasSettings() {
    $.cm({
        ClassName: "web.DHCSTPIVAS.Settings",
        MethodName: "GetAppProp",
        userId: session['LOGON.USERID'],
        locId: session['LOGON.CTLOCID'],
        appCode: "LabelPrint"
    }, function(jsonData) {
        $("#dateStart").datebox("setValue", jsonData.OrdStDate);
        $("#dateEnd").datebox("setValue", jsonData.OrdEdDate);
        // 是否录入排药,贴签,核对人配置,也就这几个
        if (jsonData.NeedUser30 == "Y") {
            NeedUserArr.push("NeedUser30");
        }
        if (jsonData.NeedUser40 == "Y") {
            NeedUserArr.push("NeedUser40");
        }
        if (jsonData.NeedUser50 == "Y") {
            NeedUserArr.push("NeedUser50");
        }
    });
}

// 获取选中记录的mdspId串
function GetMainDspStr() {
    var mDspArr = [];
    var gridOrdExeChecked = $('#gridOrdExe').datagrid('getChecked');
    for (var i = 0; i < gridOrdExeChecked.length; i++) {
        var checkedData = gridOrdExeChecked[i];
        var mDsp = checkedData.mDsp;
        if (mDspArr.indexOf(mDsp) < 0) {
            mDspArr.push(mDsp);
        }
    }
    return mDspArr.join("^");
}

/// 点击查询需清空明细
function ClearDetailGrid() {
    ClearTmpGlobal();
    $("#gridAdm").datagrid("clear");
    $("#gridWorkType").datagrid("clear");
    $("#gridOrdExe").datagrid("clear");

}
// 清除本程序涉及的所有临时global
function ClearTmpGlobal() {
    var rowsData = $("#gridWorkType").datagrid("getRows");
    if (rowsData == "") {
        return;
    }
    var pid = rowsData[0].pid;
    tkMakeServerCall("web.DHCSTPIVAS.LabelPrint", "KillLabelPrint", pid)
}

window.onbeforeunload = function() {
    ClearTmpGlobal();
};