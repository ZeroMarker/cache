/**
 * ģ��:     �Ű����-��ٲ�ѯ
 * ��д����: 2018-08-28
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function() {
    InitDict();
    InitGridRestUser();
    InitGridRest();
    InitGridRestItm();
    $("#btnFind").on('click', Query);
    $('#txtAlias').on('keypress', function(event) {
        if (event.keyCode == "13") {
            Query();
        }
    });
    setTimeout(Query, 1000)
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
}

function InitGridRestUser() {
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
                title: '��Ա����',
                width: 70
            },
            {
                field: "remDays",
                title: '���',
                width: 70
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Rest',
            QueryName: 'RestUser',
            inputStr: SessionLoc
        },
        fitColumns: true,
        columns: columns,
        pagination: false,
        onDblClickRow: function(rowIndex, rowData) {

        },
        rowStyler: function(rowIndex, rowData) {},
        onSelect: function(rowIndex, rowData) {
            var year = $("#cmbYear").combobox("getValue");
            var inputStr = SessionLoc + "^" + year + "^" + rowData.userId;
            $("#gridRest").datagrid("query", {
                inputStr: inputStr
            });
        },
        onLoadSuccess: function() {
            var rowCnt = $("#gridRestUser").datagrid("getRows").length;
            if (rowCnt > 0) {
                $("#gridRestUser").datagrid("selectRow", 0);
            } else {
                $("#gridRest").datagrid("clear");
            }
        }
    };
    // ��Ա����,�ѹ�������ʾ������,û�и�λ���м�(��ɫ),������λ�����(ǳ��)
    DHCPHA_HUI_COM.Grid.Init("gridRestUser", dataGridOption);
}

function InitGridRest() {
    var columns = [
        [{
                field: "prId",
                title: 'prId',
                width: 125,
                hidden: true
            },
            {
                field: "prMonth",
                title: '�·�',
                width: 70
            },
            {
                field: "remDays",
                title: '���(����)',
                width: 70
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Rest',
            QueryName: 'Rest',
            inputStr: ""
        },
        fitColumns: true,
        columns: columns,
        pagination: false,
        onDblClickRow: function(rowIndex, rowData) {

        },
        onSelect: function(rowIndex, rowData) {
            var year = $("#cmbYear").combobox("getValue");
            var gridUserSelect = $("#gridRestUser").datagrid("getSelected");
            if (gridUserSelect == null) {
                return;
            }
            var inputStr = SessionLoc + "^" + year + "^" + (gridUserSelect.userId || "") + "^" + rowData.prMonth;
            $("#gridRestItm").datagrid("query", {
                inputStr: inputStr
            });
        },
        onLoadSuccess: function() {
            var gridUserSelect = $("#gridRestUser").datagrid("getSelected");
            if (gridUserSelect == null) {
                return;
            }
            var year = $("#cmbYear").combobox("getValue");
            var inputStr = SessionLoc + "^" + year + "^" + (gridUserSelect.userId || "") + "^" + "";
            $("#gridRestItm").datagrid("query", {
                inputStr: inputStr
            });
        }
    };
    // ��Ա����,�ѹ�������ʾ������,û�и�λ���м�(��ɫ),������λ�����(ǳ��)
    DHCPHA_HUI_COM.Grid.Init("gridRest", dataGridOption);
}

function InitGridRestItm() {
    var columns = [
        [{
            field: "prItmDate",
            title: '�������',
            width: 70
        }]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Rest',
            QueryName: 'RestItm',
            inputStr: ""
        },
        fitColumns: true,
        columns: columns,
        pagination: false
    };
    // ��Ա����,�ѹ�������ʾ������,û�и�λ���м�(��ɫ),������λ�����(ǳ��)
    DHCPHA_HUI_COM.Grid.Init("gridRestItm", dataGridOption);
}

function Query() {
    var year = $("#cmbYear").combobox("getValue");
    var alias = $("#txtAlias").val();
    var inputStr = SessionLoc + "^" + year + "^" + alias;
    $("#gridRestUser").datagrid("query", {
        inputStr: inputStr
    });
    $("#txtAlias").val("");
}