/**
 * ģ��:     �Ű����-��λ��ζ���
 * ��д����: 2018-06-27
 * ��д��:   yunhaibao
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
            $.messager.alert("��ʾ", "����ѡ����Ҫ���Ӱ�εĸ�λ", "warning");
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
        placeholder: "��Һ����...",
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
        placeholder: "���...",
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
                title: '��Һ��������',
                width: 100,
                hidden: true
            },
            {
                field: "pdLocId",
                title: '��Һ����',
                width: 150,
                hidden: true
            },
            {
                field: "pdCode",
                title: '��λ����',
                width: 100
            },
            {
                field: "pdDesc",
                title: '��λ����',
                width: 100
            },
            {
                field: "pdShortDesc",
                title: '��λ���',
                width: 100,
                hidden: true
            },
            {
                field: "pdMinDays",
                title: '�ݼ�����</br>��Сֵ',
                halign: 'center',
                align: 'right',
                width: 70,
                hidden: true
            },
            {
                field: "pdMaxDays",
                title: '�ݼ�����</br>���ֵ',
                halign: 'center',
                align: 'right',
                width: 70,
                hidden: true
            },
            {
                field: "pdWeekEndFlag",
                title: '˫����</br>����',
                halign: 'center',
                align: 'center',
                width: 70,
                hidden: true
            },
            {
                field: "pdFestivalFlag",
                title: '�ڼ���</br>����',
                halign: 'center',
                align: 'center',
                width: 70,
                hidden: true
            },
            {
                field: "pdFestExFlag",
                title: '�ڼ���</br>����',
                halign: 'center',
                align: 'center',
                width: 70,
                hidden: true
            },
            {
                field: "pdHolidayFlag",
                title: '�����</br>����',
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
            { field: "pduId", title: '��λ��ζ���Id', hidden: true, width: 100 },
            { field: "psDesc", title: '�����������', hidden: true, width: 100 },
            {
                field: "psCode",
                title: '��δ���',
                width: 100
            },
            {
                field: "psId",
                title: '�������',
                width: 150,
                editor: GridCmbSchedul,
                descField: "psDesc",
                formatter: function(value, rowData, rowIndex) {
                    return rowData.psDesc;
                }
            },
            {
                field: "psStartTime",
                title: '�ϰ�ʱ��',
                width: 80
            },
            {
                field: "psEndTime",
                title: '�°�ʱ��',
                width: 80
            },
            {
                field: 'psScheTypeDesc',
                title: '�������',
                width: 100,
                align: 'left'
            },
            {
                field: "psCustFlag",
                title: '�ֶ��Ű�',
                halign: 'left',
                align: 'center',
                width: 75
            },
            {
                field: "psDuration",
                title: '����ʱ��(Сʱ)',
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

// �̶����
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
                title: '�������',
                width: 110,
                hidden: false
            },
            {
                field: "pdsTypeDesc",
                title: '�̶���ʽ',
                width: 110
            },
            {
                field: "pdsDaysHtml",
                title: '�̶�����',
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
// ��ѯ
function Query() {
    $("#gridDuty").datagrid("reload");
}
// ��ѯ��ϸ
function QueryDutySche() {
    var gridSelect = $("#gridDuty").datagrid("getSelected");
    var pdId = gridSelect.pdId;
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("��ʾ", "����ѡ����Һ����", "warning");
        return;
    }
    $("#gridDutySche").datagrid('query', {
        inputStr: pdId + "^" + "N"
    });
}

// ��ѯ��ϸ�̶����
function QueryDutyScheFix() {
    var gridSelect = $("#gridDuty").datagrid("getSelected");
    var pdId = gridSelect.pdId;
    var pivaLocId = $("#cmbPivaLoc").combobox("getValue") || "";
    if (pivaLocId == "") {
        $.messager.alert("��ʾ", "����ѡ����Һ����", "warning");
        return;
    }
    $("#gridDutyScheFix").datagrid('query', {
        inputStr: pdId + "^" + "M,ME,W,D"
    });
}

function Save() {
    var gridSelect = $("#gridDuty").datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ���Ӱ�εĸ�λ", "warning");
        return;
    }
    var pdId = gridSelect.pdId || "";
    if (pdId == "") {
        $.messager.alert("��ʾ", "��ȡ������λId", "warning");
        return;
    }
    $('#gridDutySche').datagrid('endEditing');
    var gridChanges = $('#gridDutySche').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("��ʾ", "û����Ҫ���������", "warning");
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        if ($('#gridDutySche').datagrid('getRowIndex', iData) < 0) {
            // ��ɾ������Ҳ����change��,�˴��жϽ����Ƿ��и�����
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
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $('#gridDutySche').datagrid("reload");
}

// ɾ����λ���
function Delete(gridId) {
    var $_grid = $('#' + gridId);
    var gridSelect = $_grid.datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "��ѡ����Ҫɾ���ļ�¼!", "warning");
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function(r) {
        if (r) {
            var pdsId = gridSelect.pdsId || "";
            var rowIndex = $_grid.datagrid('getRowIndex', gridSelect);
            if (pdsId != "") {
                var delRet = tkMakeServerCall("web.DHCSTPIVAS.DutySchedul", "Delete", pdsId);
                var delRetArr = delRet.split("^");
                var delValue = delRetArr[0];
                if (delValue < 0) {
                    $.messager.alert("��ʾ", delRetArr[1], "warning");
                    return;
                }
            }
            $_grid.datagrid("deleteRow", rowIndex);
            QueryDutyScheFix();
        }
    })
}

/// ά���̶�����
function MainTainFix(type) {
    var gridSelect = $('#gridDuty').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ���ӹ̶���εĸ�λ", "warning");
        return;
    }
    var gridFixSelect = $('#gridDutyScheFix').datagrid('getSelected');
    if ((type == "U") && (gridFixSelect == null)) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ�༭�̶����", "warning");
        return;
    }
    ClearMainTain();
    if (type == "A") {

    } else {
        var inputStr = gridSelect.pdId + "^" + "M,ME,W,D" + "^" + gridFixSelect.psId;
        AddScheFixFixData(inputStr);
        $("#cmbSchedul").combobox("setValue", gridFixSelect.psId);
    }
    $('#gridDutyScheFixWin').window({ 'title': "�̶����" + ((type == "A") ? "����" : "�༭") })
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
/// ���༭��Ϣ
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
// ����
function SaveDutyScheFix() {
    var gridSelect = $('#gridDuty').datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ���յĸ�λ", "warning");
        return;
    }
    var winTitle = $("#gridDutyScheFixWin").panel('options').title;
    var pdsId = "";
    if (winTitle.indexOf("��") >= 0) {
        pdsId = "";
    } else {
        var gridFixSelect = $('#gridDutyScheFix').datagrid("getSelected");
        if (gridFixSelect == null) {
            $.messager.alert("��ʾ", "����ѡ����Ҫ�༭�Ĺ̶����", "warning");
            return;
        }
        pdsId = gridFixSelect.pdsId;
    }
    var pdId = gridSelect.pdId;
    var psId = $("#cmbSchedul").combobox("getValue") || "";
    if (psId == "") {
        $.messager.alert("��ʾ", "����ѡ����", "warning");
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
        $.messager.alert("��ʾ", "�̶��������ȫ��Ϊ��", "warning");
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
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $('#gridDutyScheFixWin').window('close');
    $('#gridDutyScheFix').datagrid("reload");
}

function InitKalendae() {
    //Kalendae.prototype.
    //Language.prototype._month = "һ��1_��1��_��1��_��1��_��1��_��1��_��1_����_����_ʮ��_ʮһ��_ʮ����".split("_")
    $("#kalSelect").kalendae({
        months: 1,
        mode: 'multiple',
        dayHeaderClickable: true,
        dayAttributeFormat: "YYYY-MM-DD",
        format: "YYYY-MM-DD"

    })
}