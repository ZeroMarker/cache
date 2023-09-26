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
var PrtDictData = {
    rows: [{
        prtWayDesc: "病区"
    }, {
        prtWayDesc: "批次"
    }, {
        prtWayDesc: "床号"
    }, {
        prtWayDesc: "登记号"
    }, {
        prtWayDesc: "主药"
    }, {
        prtWayDesc: "溶媒"
    }, {
        prtWayDesc: "数量"
    }]
};
var CanMultiAddData = ["主药", "溶媒", "药品", "辅药", "数量"];
var QtyNeedLinkData = ["主药", "溶媒", "药品", "辅药"]
$(function () {
    InitDict();
    InitPivasSettings();
    InitGridWard();
    InitGridAdm();
    InitGridWorkType();
    InitGridOrdExe();
    InitGridPrtDict();
    InitGridPrtWay();
    $("#btnFind").on("click", Query);
    $("#btnFindDetail").on("click", QueryDetail);
    $("#btnPrint").on("click", ConfirmSaveData);
    $('#btnPack').on('click', function () {
        PackSelectDsp('P');
    });
    $('#btnUnPack').on('click', function () {
        PackSelectDsp('');
    });
    $('#txtPatNo').on('keypress', function (event) {
        if (event.keyCode == "13") {
            GetPatAdmList(); //调用查询
        }
    });
    $("#tabsDetail").tabs({
        onSelect: function (title) {
            if (title.indexOf("医嘱") >= 0) {
                $("#gridOrdExe").datagrid("clear")
                QueryOrdExe();
            }
        }
    });
    setTimeout(function () {
        getLodop();
    }, 2000);
    $(".dhcpha-win-mask").remove();
});

function InitDict() {
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
    }, {});
    // 工作组
    PIVAS.ComboBox.Init({
        Id: 'cmbWorkType',
        Type: 'PIVAWorkType'
    }, {});
    // 药品
    PIVAS.ComboGrid.Init({
        Id: 'cmgIncItm',
        Type: 'IncItm'
    }, {});
    // 打包
    PIVAS.ComboBox.Init({
        Id: 'cmbPack',
        Type: 'PackType'
    }, {});
    // 用法
    PIVAS.ComboBox.Init({
        Id: 'cmbInstruc',
        Type: 'Instruc'
    }, {});
    // 批次
    PIVAS.BatchNoCheckList({
        Id: "DivBatNo",
        LocId: SessionLoc,
        Check: true,
        Pack: false
    });
    // 人员
    PIVAS.ComboBox.Init({
        Id: 'cmbNeedUser30',
        Type: 'LocUser'
    }, {});
    PIVAS.ComboBox.Init({
        Id: 'cmbNeedUser40',
        Type: 'LocUser'
    }, {});
    PIVAS.ComboBox.Init({
        Id: 'cmbNeedUser50',
        Type: 'LocUser'
    }, {});
    GridCmbBatNo = PIVAS.UpdateBatNoCombo({
        LocId: SessionLoc,
        GridId: "gridOrdExe",
        Field: "batNo",
        BatUp: "batUp",
        MDspField: "mDsp"
    });
}

function InitGridWard() {
    var columns = [
        [{
                field: 'wardSelect',
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
        onClickRow: function (rowIndex, rowData) {},
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        queryOnSelect: false,
        onLoadSuccess: function () {
            $("#gridWard").datagrid("uncheckAll");
            $("#gridWorkType").datagrid("uncheckAll");
            $("#gridOrdExe").datagrid("uncheckAll");
        },
        onClickCell: function (rowIndex, field, value) {
            if (field == "wardDesc") {
                $(this).datagrid("options").queryOnSelect = true;
            }
        },
        onSelect: function (rowIndex, rowData) {
            if ($(this).datagrid("options").queryOnSelect == true) {
                $(this).datagrid("options").queryOnSelect = false;
                QueryDetail();
            }
        },
        onUnselect: function (rowIndex, rowData) {
            if ($(this).datagrid("options").queryOnSelect == true) {
                $(this).datagrid("options").queryOnSelect = false;
                QueryDetail();
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridWard", dataGridOption);
}

/// 初始化就诊
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

function InitGridWorkType() {
    var columns = [
        [{
                field: 'workTypeSelect',
                checkbox: true
            },
            {
                field: 'pid',
                title: '进程',
                width: 1,
                hidden: true
            },
            {
                field: 'workTypeId',
                title: '工作组Id',
                width: 1,
                hidden: true
            },
            {
                field: 'wtCode',
                title: '工作组代码',
                width: 1
            },
            {
                field: 'wtDesc',
                title: '工作组名称',
                width: 1
            }, {
                field: 'prtWayDesc',
                title: '打印排序方式',
                width: 3,
                styler: function (value, row, index) {
                    return 'cursor:pointer';
                },
                formatter: function (value, row, index) {
					return value;
				}
            },
            {
                field: 'orderCnt',
                title: '组数',
                width: 1
            }
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
        toolbar: "#gridWorkTypeBar",
        onClickCell: function (rowIndex, field, value) {
            if ((field == "prtWayDesc")) {
                ShowDiagPrtWay(value);
            }
        },
        onLoadSuccess: function () {
            if ($("#gridWorkType").datagrid("getRows") != "") {
                $("#gridWorkType").datagrid("checkAll");
            } else {
                $("#gridWorkType").datagrid("uncheckAll");
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridWorkType", dataGridOption);
}

//初始化明细列表
function InitGridOrdExe() {
    var columns = [
        [{
                field: 'ordExeCheck',
                checkbox: true
            },
            {
                field: 'warnInfo',
                title: '提醒',
                width: 50,
                hidden: false
            },
            {
                field: 'pid',
                title: 'pid',
                width: 50,
                hidden: true
            },
            {
                field: 'ordRemark',
                title: '备注',
                width: 75
            },
            {
                field: 'doseDateTime',
                title: '用药日期',
                width: 95
            },
            {
                field: 'bedNo',
                title: '床号',
                width: 75
            },
            {
                field: 'patNo',
                title: '登记号',
                width: 100
            },
            {
                field: 'patName',
                title: '姓名',
                width: 100
            },
            {
                field: 'batNo',
                title: '批次',
                width: 75,
                editor: GridCmbBatNo,
                styler: function (value, row, index) {
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
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            {
                field: 'incDesc',
                title: '药品',
                width: 250,
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
                width: 50
            },
            {
                field: 'freqDesc',
                title: '频次',
                width: 75
            },
            {
                field: 'instrucDesc',
                title: '用法',
                width: 80
            },
            {
                field: 'bUomDesc',
                title: '单位',
                width: 50
            },
            {
                field: 'docName',
                title: '医生',
                width: 75,
				hidden: true
            },
            {
                field: "passResultDesc",
                title: '审核结果',
                width: 85
            },
            {
                field: 'priDesc',
                title: '优先级',
                width: 75
            },
            {
                field: "packFlag",
                title: '打包',
                width: 85,
                halign: 'left',
                align: 'center',
                hidden: true
            },
            {
                field: "mDsp",
                title: 'mDsp',
                width: 70,
                hidden: true
            },
            {
                field: 'colColor',
                title: 'colColor',
                width: 50,
                hidden: true
            },
            {
                field: "incDescStyle",
                title: 'incDescStyle',
                width: 70,
                hidden: true
            }
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
        rowStyler: function (index, rowData) {
			return PIVAS.Grid.RowStyler.Person(index, rowData, "patNo");
        },
        onClickRow: function (rowIndex, rowData) {

        },
        onSelect: function (rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp,
                Type: 'Select'
            });
        },
        onUnselect: function (rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp,
                Type: 'Select'
            });
        },
        onClickCell: function (rowIndex, field, value) {
            if ((field == "batNo") && (value != "")) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'batNo'
                });
            } else {
                $(this).datagrid('endEditing');
            }
        },
        onCheck: function (rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp
            });
        },
        onUncheck: function (rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: false,
                Value: rowData.mDsp
            });
        },
        onLoadSuccess: function () {
            $(this).datagrid("scrollTo", 0);
            PIVAS.Grid.CellTip({
                TipArr: ['ordRemark', 'incDesc']
            });
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
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

/// 查询病区
function Query() {
    ClearDetailGrid();
    var params = QueryParams("Query");
    if (params == "") {
        return;
    }
    $('#gridWard').datagrid('query', {
        inputStr: params,
        rows: 9999
    });;
}
/// 查询工作组
function QueryDetail() {
    ClearTmpGlobal();
    var params = QueryParams("QueryDetail");
    if (params == "") {
        $("#gridWorkType").datagrid("clear");
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
        var prtWayDesc = checkedData.prtWayDesc;
        prtWayStr = (prtWayStr == "") ? workTypeId + "^" + prtWayDesc : prtWayStr + "!!" + workTypeId + "^" + prtWayDesc;
    }
    if (prtWayStr == "") {
        $.messager.alert('提示', '请选择工作组', 'warning');
        $("#tabsDetail").tabs("select", 0);
        return;
    }
    var prtGrp = $("input[name=wtSortGrp]:checked").val();
    prtWayStr = prtWayStr + "@" + prtGrp;
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
    $("input[type=checkbox][name=batbox]").each(function () {
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
                //$.messager.alert('提示', '请选择病区', 'warning');
                return "";
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

    }
    var params = SessionLoc + "^" + wardIdStr + "^" + startDate + "^" + endDate + "^" + locGrpId + "^" +
        pivaCat + "^" + workType + "^" + priority + "^" + incId + "^" + instrucId + "^" +
        packFlag + "^" + batNoStr + "^" + admId;
    return params;
}

/// 保存数据前操作
function ConfirmSaveData() {
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
    $.messager.confirm('提示', "您确认打印标签吗?", function (r) {
        if (r) {
            var userNum = NeedUserArr.length;
            if (userNum > 0) {
                // 写死判断先
                for (var i = 0; i < userNum; i++) {
                    var needUserCode = NeedUserArr[i];
                    var cmbUserId = "cmb" + needUserCode;
                    $("#needUserWin #" + cmbUserId).closest("tr").css("display", "table")
                }
                $('#needUserWin').window({
                    height: 90 + (userNum * 45)
                });
                $('#needUserWin').window({
                    width: 280
                });
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
        var prtWayDesc = gridChecked[i].prtWayDesc;
        prtWayStr = (prtWayStr == "") ? workTypeId + "^" + prtWayDesc : prtWayStr + "!!" + workTypeId + "^" + prtWayDesc;
        workTypeStr = (workTypeStr == "") ? workTypeId : workTypeStr + "^" + workTypeId;
    }
    if (prtWayStr == "") {
        $.messager.alert('提示', '获取不到打印排序方式', 'warning');
        return;
    }
    var prtGrp = $("input[name=wtSortGrp]:checked").val();
    prtWayStr = prtWayStr + "@" + prtGrp;
    PIVAS.Progress.Show({
        type: 'save',
        interval: 1000
    });
    $.m({
        ClassName: "web.DHCSTPIVAS.LabelPrint",
        MethodName: "SaveData",
        pid: pid,
        userId: SessionUser,
        workTypeStr: workTypeStr,
        user30: user30,
        user40: user40,
        user50: user50
    }, function (retData) {
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
            PIVASPRINT.LabelsJsonByPogsNo({
                pogsNo: retArr[0],
                sortWay: prtWayStr
            });
        }
    });
}

// 打包操作
function PackSelectDsp(packFlag) {
    $.messager.confirm('提示', "您确认" + ((packFlag == "P") ? "打包" : "取消打包") + "吗?", function (r) {
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
    }, function (jsonData) {
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



// 修改排序
function ShowDiagPrtWay(prtWayStr) {
    $('#gridPrtWayWin').dialog({
        iconCls: 'icon-w-edit',
        modal: true,
        width: 360,
        height: 400
    }).dialog('open');
    var wtPrtWayRowsData = [];
    var wtPrtWay = prtWayStr;
    if (wtPrtWay != "") {
        var wtPrtWayArr = wtPrtWay.split(">");
        for (var i = 0; i < wtPrtWayArr.length; i++) {
            wtPrtWayRowsData.push({
                prtWayDesc: wtPrtWayArr[i]
            })
        }
    }
    var wtPrtWayData = {
        rows: wtPrtWayRowsData
    }
    $("#gridPrtWay").datagrid("loadData", wtPrtWayData);
}
/// 工作组列表
function InitGridPrtDict() {
    //定义columns
    var columns = [
        [{
            field: "prtWayDesc",
            title: '标签顺序字典',
            width: 3,
            hidden: false
        }, {
            field: "dictOperate",
            title: '操作',
            width: 1,
            align: "center",
            formatter: function (value, rowData, rowIndex) {
                return '<img title="授权" onclick="AddPrtWay()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" style="border:0px;cursor:pointer">'
            }
        }]
    ];
    var dataGridOption = {
        url: "",
        data: PrtDictData,
        pagination: false,
        columns: columns,
        rownumbers: false,
        fitColumns: true
    };
    DHCPHA_HUI_COM.Grid.Init("gridPrtDict", dataGridOption);
}
/// 工作组列表
function InitGridPrtWay() {
    //定义columns
    var columns = [
        [{
            field: "prtWayDesc",
            title: '标签打印顺序',
            width: 3,
            hidden: false
        }, {
            field: "wayOperate",
            title: '操作',
            width: 1,
            align: "center",
            formatter: function (value, rowData, rowIndex) {
                return '<img title="删除" onclick="DeletePrtWay()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png" style="border:0px;cursor:pointer">'
            }
        }]
    ];
    var dataGridOption = {
        url: "",
        data: {
            rows: []
        },
        pagination: false,
        columns: columns,
        fitColumns: true,
        onLoadSuccess: function () {
            $("#gridPrtWay").datagrid("enableDnd");
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridPrtWay", dataGridOption);
}

function AddPrtWay() {
    var $target = $(event.target);
    var rowIndex = $target.closest("tr[datagrid-row-index]").attr("datagrid-row-index");
    var rowData = $("#gridPrtDict").datagrid("getRows")[rowIndex];
    var prtWayDesc = rowData.prtWayDesc;
    var gridPrtWayRows = $("#gridPrtWay").datagrid("getRows");
    for (var i = 0; i < gridPrtWayRows.length; i++) {
        var tmpPrtWay = gridPrtWayRows[i].prtWayDesc;
        if ((tmpPrtWay == prtWayDesc) && (CanMultiAddData.indexOf(prtWayDesc) < 0)) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: "已存在该顺序,不需要再增加",
                type: 'alert'
            });
            return;
        }
    }
    var newData = {
        prtWayDesc: prtWayDesc
    };
    $("#gridPrtWay").datagrid("appendRow", newData);
    $("#gridPrtWay").datagrid('loadData', $("#gridPrtWay").datagrid('getRows'));
}

function DeletePrtWay() {
    var $target = $(event.target);
    var rowIndex = $target.closest("tr[datagrid-row-index]").attr("datagrid-row-index");
    $("#gridPrtWay").datagrid("deleteRow", rowIndex);
    $("#gridPrtWay").datagrid('loadData', $("#gridPrtWay").datagrid('getRows'));
}

function UpdateWorkTypePrtWay() {

    var gridPrtWayRows = $('#gridPrtWay').datagrid('getRows');
    var gridLen = gridPrtWayRows.length;
    if (gridLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "标签打印顺序为空",
            type: 'alert'
        });
        return;
    }
    var prtWayArr = [];
    for (var i = 0; i < gridLen; i++) {
        var rowData = gridPrtWayRows[i];
        var prtWayDesc = rowData.prtWayDesc;
        if (prtWayDesc == "数量") {
            var chkPre = "";
            var chkNext = "";
            var preI = i - 1;
            var nextI = i + 1;
            if (preI >= 0) {
                var preWayDesc = gridPrtWayRows[preI].prtWayDesc;
                if (QtyNeedLinkData.indexOf(preWayDesc) >= 0) {
                    chkPre = "Y";
                }
            }
            if (nextI < gridLen) {
                var nextWayDesc = gridPrtWayRows[nextI].prtWayDesc;
                if (QtyNeedLinkData.indexOf(nextWayDesc) >= 0) {
                    chkNext = "Y";
                }
            }
            if ((chkPre == "") && (chkNext == "")) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: "请核实第" + (i + 1) + "行,其数量的前或后必须为主药、溶媒的一种",
                    type: 'alert'
                });
                return;
            }
        }
        // 验证数量前或后必须有药品
        prtWayArr.push(prtWayDesc);
    }
    var prtWayStr = prtWayArr.join(">");
    var gridWorkTypeSelect = $("#gridWorkType").datagrid("getSelected");
    var gridSelectIndex = $("#gridWorkType").datagrid("getRows").indexOf(gridWorkTypeSelect);
    $("#gridWorkType").datagrid("updateRow", {
        index: gridSelectIndex,
        row: {
            prtWayDesc: prtWayStr
        }
    });
    $('#gridPrtWayWin').window('close');
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

window.onbeforeunload = function () {
    ClearTmpGlobal();
};