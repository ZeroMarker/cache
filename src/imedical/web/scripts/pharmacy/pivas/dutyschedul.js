/**
 * 模块:     排班管理-岗位班次对照
 * 编写日期: 2018-06-27
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var GridCmbSchedul;
$(function() {
    InitDict();
    InitGridDict();
    InitGridDuty();
    InitGridDutySche();
    InitGridDutyScheFix();
    InitKalendae();
    $('#btnAdd').on("click", function() {
        var gridSelect = $("#gridDuty").datagrid("getSelected");
        if (gridSelect == null) {
            $.messager.alert("提示", "请先选择需要增加班次的岗位", "warning");
            return;
        }
        var pdId = gridSelect.pdId || "";
        if (pdId == "") {
            return;
        }
        $("#gridDutySche").datagrid("addNewRow", {
            editField: 'psId'
        })
    });
    $('#btnSave').on("click", Save);
    $('#btnDelete').on("click", function() {
        Delete("gridDutySche");
    });
    $("#btnAddFix").on("click", function() {
        MainTainFix("A");
    });
    $("#btnEditFix").on("click", function() {
        MainTainFix("U");
    });
    $("#btnDeleteFix").on("click", function() {
        Delete("gridDutyScheFix");
    });
});

function InitDict() {
    PIVAS.ComboBox.Init({ Id: "cmbPivaLoc", Type: "PivaLoc" }, {
        onLoadSuccess: function() {
            var datas = $("#cmbPivaLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPivaLoc").combobox("select", datas[i].RowId);
                }
            }
        },
        onSelect: function(selData) {
            $('#gridDuty').datagrid("query", { inputStr: selData.RowId });
        },
        editable: false,
        placeholder: "配液中心...",
        width: 325
    });
    var thisYear = (new Date()).getFullYear();
    var weekDays = [];
    for (var i = 1; i < 8; i++) {
        weekDays.push({ RowId: i, Description: i });
    }
    var monthDays = [];
    for (var i = 1; i < 32; i++) {
        monthDays.push({ RowId: i, Description: i });
    }
    var monthEndDays = [];
    for (var i = 1; i < 5; i++) {
        monthEndDays.push({ RowId: i, Description: i });
    }

    PIVAS.ComboBox.Init({
        Id: "cmbWeekDays",
        data: {
            data: weekDays
        }
    }, {
        editable: false,
        multiple: true,
        mode: "local",
        width: 200
    });
    PIVAS.ComboBox.Init({
        Id: "cmbMonthDays",
        data: {
            data: monthDays
        }
    }, {
        editable: false,
        multiple: true,
        mode: "local",
        width: 200
    });
    PIVAS.ComboBox.Init({
        Id: "cmbMonthEndDays",
        data: {
            data: monthEndDays
        }
    }, {
        editable: false,
        multiple: true,
        mode: "local",
        width: 200
    });
    PIVAS.ComboBox.Init({ Id: "cmbSchedul", Type: "PIVASchedul" }, {
        editable: false,
        placeholder: "班次...",
        width: 200,
        onBeforeLoad: function(param) {
            param.inputStr = $("#cmbPivaLoc").combobox("getValue") || "";
            param.filterText = param.q;
        }
    });
}

function InitGridDict() {
    GridCmbSchedul = PIVAS.GridComboBox.Init({
        Type: "PIVASchedul",
        QueryParams: { inputStr: SessionLoc }
    }, {
        required: true,
        editable: false,
        onBeforeLoad: function(param) {
            param.inputStr = $("#cmbPivaLoc").combobox("getValue") || "";
            param.filterText = param.q;
        }
    });
}

function InitGridDuty() {
    var columns = [
        [
            { field: "pdId", title: 'pdId', hidden: true, width: 100 },
            {
                field: "pdLocDesc",
                title: '配液中心描述',
                width: 100,
                hidden: true
            },
            {
                field: "pdLocId",
                title: '配液中心',
                width: 150,
                hidden: true
            },
            {
                field: "pdCode",
                title: '岗位代码',
                width: 100
            },
            {
                field: "pdDesc",
                title: '岗位名称',
                width: 100
            },
            {
                field: "pdShortDesc",
                title: '岗位简称',
                width: 100,
                hidden: true
            },
            {
                field: "pdMinDays",
                title: '休假天数</br>最小值',
                halign: 'center',
                align: 'right',
                width: 70,
                hidden: true
            },
            {
                field: "pdMaxDays",
                title: '休假天数</br>最大值',
                halign: 'center',
                align: 'right',
                width: 70,
                hidden: true
            },
            {
                field: "pdWeekEndFlag",
                title: '双休日</br>必修',
                halign: 'center',
                align: 'center',
                width: 70,
                hidden: true
            },
            {
                field: "pdFestivalFlag",
                title: '节假日</br>必修',
                halign: 'center',
                align: 'center',
                width: 70,
                hidden: true
            },
            {
                field: "pdFestExFlag",
                title: '节假日</br>倒休',
                halign: 'center',
                align: 'center',
                width: 70,
                hidden: true
            },
            {
                field: "pdHolidayFlag",
                title: '寒暑假</br>可休',
                halign: 'center',
                align: 'center',
                width: 70,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Duty',
            QueryName: 'PIVADuty'
        },
        columns: columns,
        pagination: false,
        toolbar: "#gridDutyBar",
        fitColumns: true,
        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid('endEditing');
            if ($(this).datagrid('options').editIndex == undefined) {
                $("#gridDutySche").datagrid("clear");
                var pdId = rowData.pdId || "";
                if (pdId != "") {
                    QueryDutySche();
                    QueryDutyScheFix();
                }
            }
        },
        onLoadSuccess: function() {
            $("#gridDutySche").datagrid("clear");
            $("#gridDutyScheFix").datagrid("clear");
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridDuty", dataGridOption);
}

function InitGridDutySche() {
    var columns = [
        [
            { field: "pduId", title: '岗位班次对照Id', hidden: true, width: 100 },
            { field: "psDesc", title: '班次名称描述', hidden: true, width: 100 },
            {
                field: "psCode",
                title: '班次代码',
                width: 100
            },
            {
                field: "psId",
                title: '班次名称',
                width: 150,
                editor: GridCmbSchedul,
                descField: "psDesc",
                formatter: function(value, rowData, rowIndex) {
                    return rowData.psDesc;
                }
            },
            {
                field: "psStartTime",
                title: '上班时间',
                width: 80
            },
            {
                field: "psEndTime",
                title: '下班时间',
                width: 80
            },
            {
                field: 'psScheTypeDesc',
                title: '班次类型',
                width: 100,
                align: 'left'
            },
            {
                field: "psCustFlag",
                title: '手动排班',
                halign: 'left',
                align: 'center',
                width: 75
            },
            {
                field: "psDuration",
                title: '工作时长(小时)',
                halign: 'left',
                align: 'right',
                width: 110
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.DutySchedul',
            QueryName: 'PIVADutySchedul'
        },
        fitColumns: true,
        toolbar: "#gridDutyScheBar",
        columns: columns,
        pagination: false,
        onClickRow: function(rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'psId'
                });
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridDutySche", dataGridOption);
}

// 固定班次
function InitGridDutyScheFix() {
    var columns = [
        [{
                field: "pdsId",
                title: 'pdsId',
                halign: 'center',
                width: 110,
                hidden: true
            }, {
                field: "psId",
                title: 'psId',
                halign: 'center',
                width: 110,
                hidden: true
            }, {
                field: "psDesc",
                title: '班次名称',
                width: 110,
                hidden: false
            },
            {
                field: "pdsTypeDesc",
                title: '固定方式',
                width: 110
            },
            {
                field: "pdsDaysHtml",
                title: '固定规则',
                width: 500
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.DutySchedul',
            QueryName: 'PIVADutySchedul'
        },
        //fitColumns: true,
        toolbar: "#gridDutyScheFixBar",
        columns: columns,
        pagination: false,
        nowrap: false,
        onClickRow: function(rowIndex, rowData) {},
        onLoadSuccess: function() {
            DHCPHA_HUI_COM.Grid.MergeCell({
                GridId: "gridDutyScheFix",
                MergeFields: ["psDesc"],
                Field: "psDesc"
            });
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridDutyScheFix", dataGridOption);
}
// 查询
function Query() {
    $("#gridDuty").datagrid("reload");
}
// 查询明细
function QueryDutySche() {
    var gridSelect = $("#gridDuty").datagrid("getSelected");
    var pdId = gridSelect.pdId;
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("提示", "请先选择配液中心", "warning");
        return;
    }
    $("#gridDutySche").datagrid('query', {
        inputStr: pdId + "^" + "N"
    });
}

// 查询明细固定班次
function QueryDutyScheFix() {
    var gridSelect = $("#gridDuty").datagrid("getSelected");
    var pdId = gridSelect.pdId;
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("提示", "请先选择配液中心", "warning");
        return;
    }
    $("#gridDutyScheFix").datagrid('query', {
        inputStr: pdId + "^" + "M,ME,W,D"
    });
}

function Save() {
    var gridSelect = $("#gridDuty").datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请先选择需要增加班次的岗位", "warning");
        return;
    }
    var pdId = gridSelect.pdId || "";
    if (pdId == "") {
        $.messager.alert("提示", "获取不到岗位Id", "warning");
        return;
    }
    $('#gridDutySche').datagrid('endEditing');
    var gridChanges = $('#gridDutySche').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("提示", "没有需要保存的数据", "warning");
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        if ($('#gridDutySche').datagrid('getRowIndex', iData) < 0) {
            // 被删除数据也会在change中,此处判断界面是否还有该数据
            continue;
        }
        var params = (iData.pdsId || "") + "^" + pdId + "^" + (iData.psId || "") + "^" + "N";
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.DutySchedul", "SaveMulti", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
    }
    $('#gridDutySche').datagrid("reload");
}

// 删除岗位班次
function Delete(gridId) {
    var $_grid = $('#' + gridId);
    var gridSelect = $_grid.datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请选择需要删除的记录!", "warning");
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function(r) {
        if (r) {
            var pdsId = gridSelect.pdsId || "";
            var rowIndex = $_grid.datagrid('getRowIndex', gridSelect);
            if (pdsId != "") {
                var delRet = tkMakeServerCall("web.DHCSTPIVAS.DutySchedul", "Delete", pdsId);
                var delRetArr = delRet.split("^");
                var delValue = delRetArr[0];
                if (delValue < 0) {
                    $.messager.alert("提示", delRetArr[1], "warning");
                    return;
                }
            }
            $_grid.datagrid("deleteRow", rowIndex);
            QueryDutyScheFix();
        }
    })
}

/// 维护固定规则
function MainTainFix(type) {
    var gridSelect = $('#gridDuty').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert("提示", "请先选择需要增加固定班次的岗位", "warning");
        return;
    }
    var gridFixSelect = $('#gridDutyScheFix').datagrid('getSelected');
    if ((type == "U") && (gridFixSelect == null)) {
        $.messager.alert("提示", "请先选择需要编辑固定班次", "warning");
        return;
    }
    ClearMainTain();
    if (type == "A") {

    } else {
        var inputStr = gridSelect.pdId + "^" + "M,ME,W,D" + "^" + gridFixSelect.psId;
        AddScheFixFixData(inputStr);
        $("#cmbSchedul").combobox("setValue", gridFixSelect.psId);
    }
    $('#gridDutyScheFixWin').window({ 'title': "固定班次" + ((type == "A") ? "新增" : "编辑") })
    $('#gridDutyScheFixWin').window('open');
}

function ClearMainTain() {
    $("#idMonthDays").val("");
    $("#idMonthEndDays").val("");
    $("#idWeekDays").val("");
    $("#idDays").val("");
    $("#cmbMonthDays").combobox("clear");
    $("#cmbMonthEndDays").combobox("clear");
    $("#cmbWeekDays").combobox("clear");
    $("#cmbSchedul").combobox("clear");
    $("#kalSelect").val("");
    $("#cmbSchedul").combobox("reload");
}
/// 填充编辑信息
function AddScheFixFixData(inputStr) {
    var pdsRetData = $.cm({
        ClassName: "web.DHCSTPIVAS.DutySchedul",
        QueryName: "PIVADutySchedul",
        inputStr: inputStr,
        ResultSetType: "array"
    }, false);
    var pdsLen = pdsRetData.length;
    for (var i = 0; i < pdsLen; i++) {
        var iJson = pdsRetData[i];
        var pdsId = iJson.pdsId;
        if (iJson.pdsType == "M") {
            $("#cmbMonthDays").combobox("setValues", (iJson.pdsDays).split(","));
            $("#idMonthDays").val(pdsId);
        } else if (iJson.pdsType == "ME") {
            $("#cmbMonthEndDays").combobox("setValues", (iJson.pdsDays).split(","));
            $("#idMonthEndDays").val(pdsId);
        } else if (iJson.pdsType == "W") {
            $("#cmbWeekDays").combobox("setValues", (iJson.pdsDays).split(","));
            $("#idWeekDays").val(pdsId);
        } else if (iJson.pdsType == "D") {
            $("#kalSelect").val(iJson.pdsDaysHtml);
            $("#idDays").val(pdsId);
        }
    }
}
// 保存
function SaveDutyScheFix() {
    var gridSelect = $('#gridDuty').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("提示", "请先选择需要对照的岗位", "warning");
        return;
    }
    var winTitle = $("#gridDutyScheFixWin").panel('options').title;
    var pdsId = "";
    if (winTitle.indexOf("增") >= 0) {
        pdsId = "";
    } else {
        var gridFixSelect = $('#gridDutyScheFix').datagrid("getSelected");
        if (gridFixSelect == null) {
            $.messager.alert("提示", "请先选择需要编辑的固定班次", "warning");
            return;
        }
        pdsId = gridFixSelect.pdsId;
    }
    var pdId = gridSelect.pdId;
    var psId = $("#cmbSchedul").combobox("getValue") || "";
    if (psId == "") {
        $.messager.alert("提示", "请先选择班次", "warning");
        return;
    }
    var monthDays = $("#cmbMonthDays").combobox("getValues") || "";
    monthDays = monthDays.join(",");
    var monthEndDays = $("#cmbMonthEndDays").combobox("getValues") || "";
    monthEndDays = monthEndDays.join(",");
    var weekDays = $("#cmbWeekDays").combobox("getValues") || "";
    weekDays = weekDays.join(",");
    var days = $("#kalSelect").val();
    if ((monthDays == "") && (monthEndDays == "") && (weekDays == "") && (days == "")) {
        $.messager.alert("提示", "固定班次条件全部为空", "warning");
        return;
    };
    var mParams = ($("#idMonthDays").val() || "") + "^" + pdId + "^" + psId + "^" + "M" + "^" + monthDays;
    var meParams = ($("#idMonthEndDays").val() || "") + "^" + pdId + "^" + psId + "^" + "ME" + "^" + monthEndDays;
    var wParams = ($("#idWeekDays").val() || "") + "^" + pdId + "^" + psId + "^" + "W" + "^" + weekDays;
    var dParams = ($("#idDays").val() || "") + "^" + pdId + "^" + psId + "^" + "D" + "^" + days;
    var paramsStr = mParams + "!!" + meParams + "!!" + wParams + "!!" + dParams;
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.DutySchedul", "SaveMulti", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("提示", saveInfo, "warning");
    }
    $('#gridDutyScheFixWin').window('close');
    $('#gridDutyScheFix').datagrid("reload");
}

function InitKalendae() {
    //Kalendae.prototype.
    //Language.prototype._month = "一月1_二1月_三1月_四1月_五1月_六1月_七1_八月_九月_十月_十一月_十二月".split("_")
    $("#kalSelect").kalendae({
        months: 1,
        mode: 'multiple',
        dayHeaderClickable: true,
        dayAttributeFormat: "YYYY-MM-DD",
        format: "YYYY-MM-DD"

    })
}