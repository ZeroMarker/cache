/**
 * ģ��:     �Ű����-�Ű����
 * ��д����: 2018-08-27
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function() {
    InitDict();
    InitGridSchedulSum();
    InitGridSchedulUser();
    $('.dhcpha-win-mask').remove();
    $('#btnFind').on('click', Query);
});

function InitDict() {
    var thisYear = (new Date()).getFullYear();
    var thisMonth = (new Date()).getMonth();
    var years = [
        { RowId: thisYear + 1, Description: thisYear - 1 + "��" },
        { RowId: thisYear, Description: thisYear + "��" },
        { RowId: thisYear + 1, Description: thisYear + 1 + "��" }
    ];
    PIVAS.ComboBox.Init({
        Id: "cmbYear",
        data: {
            data: years
        }
    }, {
        editable: false,
        multiple: false,
        mode: "local",
        placeholder: "���...",
        onSelect: function() {
            Query();
        }
    });
    $("#cmbYear").combobox("setValue", thisYear);
    var months = [];
    for (var i = 1; i < 13; i++) {
        months.push({ RowId: i, Description: i + "��" });
    }
    PIVAS.ComboBox.Init({
        Id: "cmbMonth",
        data: {
            data: months
        }
    }, {
        editable: false,
        multiple: false,
        mode: "local",
        placeholder: "�·�...",
        onSelect: function() {
            Query();
        }
    });
    $("#cmbMonth").combobox("setValue", (thisMonth + 1));
}

function InitGridSchedulSum() {
    var colsStr = tkMakeServerCall("web.DHCSTPIVAS.SchedulSum", "SchedulCols", SessionLoc)
    if (colsStr == "") {
        $.messager.alert("��ʾ", "��ʼ��ʧ��", "warning");
        return;
    }
    var columnsArr = JSON.parse(colsStr);
    // ��������
    for (var colI = 0; colI < columnsArr.length; colI++) {
        var colIObj = columnsArr[colI];
        if ((colIObj.field).substring(0, 4) != "sche") {
            continue;
        }
        colIObj.styler = function(value, rowData, rowIndex) {
            if ((value == 0) || (value == "")) {
                return "background-color:#ffe3e3;"
            }
        }
    }
    var columns = [columnsArr];
    var frozenColumns = [
        [{
            field: "scheDate",
            title: '����',
            width: 100,
            styler: function(value, rowData, rowIndex) {
                return "font-weight:bold"
            }
        }]
    ]
    var dataGridOption = {
        url: null,
        frozenColumns: frozenColumns,
        columns: columns,
        toolbar: "#gridSchedulSumBar",
        border: false,
        pagination: false,
        gridSave:false,
        onClickCell: function(index, field, value) {
            if (field == "scheDate") {
                return;
            }
            var year = $("#cmbYear").combobox("getValue") || "";
            var rowData = $("#gridSchedulSum").datagrid("getRows")[index];
            var scheDate = rowData.scheDate;
            var inputStr = SessionLoc + "^" + scheDate + "^" + field;
            $("#gridSchedulUser").datagrid('query', {
                inputStr: inputStr
            });
        },
        onLoadSuccess: function() {
            $("#gridSchedulSum").datagrid("enableCellSelecting");
            $("#gridSchedulUser").datagrid("clear");
        },
        onRowContextMenu: function(e, rowIndex, rowData) {
            e.preventDefault(); //��ֹ����ð��
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridSchedulSum", dataGridOption);
    setTimeout(Query, 100);
}

function InitGridSchedulUser() {
    var columns = [
        [{
                field: "userId",
                title: 'userId',
                width: 125,
                hidden: true
            },
            {
                field: "userCode",
                title: '��Ա����',
                width: 70,
                hidden: true
            },
            {
                field: "userName",
                title: '�������',
                width: 70
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        columns: columns,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.SchedulSum',
            QueryName: 'SchedulUser'
        },
        fitColumns: true,
        pagination: false,
    };
    DHCPHA_HUI_COM.Grid.Init("gridSchedulUser", dataGridOption);
}
// ��ѯ
function Query() {
    var year = $("#cmbYear").combobox("getValue") || "";
    var month = $("#cmbMonth").combobox("getValue") || "";
    if (year == "") {
        $.messager.alert("��ʾ", "����ѡ�����", "warning");
        return;
    }
    if (month == "") {
        $.messager.alert("��ʾ", "����ѡ���·�", "warning");
        return;
    }
    var monthDate = year + "-" + month + "-01";
    var inputStr = SessionLoc + "^" + monthDate;
    $("#gridSchedulSum").datagrid({
        url: "DHCST.METHOD.BROKER.csp?ClassName=web.DHCSTPIVAS.SchedulSum&MethodName=JsGetSchedulSum",
        queryParams: {
            inputStr: inputStr
        },
    });
}
