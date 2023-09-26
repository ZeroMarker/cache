/**
 * ģ��:     ��Һ���̵��ݴ�ӡ��¼
 * ��д����: 2018-04-20
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function() {
    InitDict();
    InitGridOrdExe();
    InitGridPrint();
    $('#btnFind').bind("click", Query);
    $('#btnPrint').bind("click", PrintSelect);
    $('#btnPrintAll').bind("click", PrintAll);
    $('#btnClear').bind("click", Clear);
    $('#txtPatNo').bind('keypress', function(event) {
        if (event.keyCode == "13") {
            var patNo = $('#txtPatNo').val();
            if (patNo == "") {
                return;
            }
            var patNo = PIVAS.PadZero(patNo, PIVAS.PatNoLength());
            $('#txtPatNo').val(patNo);
        }
    });
});

function InitDict() {
    // ����
    PIVAS.Date.Init({ Id: 'datePrtStart', LocId: "", Type: 'Start', QueryType: 'Query' });
    PIVAS.Date.Init({ Id: 'datePrtEnd', LocId: "", Type: 'End', QueryType: 'Query' });
    PIVAS.ComboBox.Init({ Id: 'cmbPivasLoc', Type: 'PivaLoc' }, {
        editable: false,
        onLoadSuccess: function() {
            var datas = $("#cmbPivasLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPivasLoc").combobox("setValue", datas[i].RowId);
                    break;
                }
            }
        },
        onSelect: function(data) {
            var locId = data.RowId;
            PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType', StrParams: locId }, { "placeholder": "��Һ״̬..." });
            PIVAS.ComboBox.Init({ Id: 'cmbPivaStat', Type: 'PIVAState' }, { editable: false });
        }
    });
    // ����
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, { placeholder: "����..." });
    PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, { "placeholder": "������..." });
    PIVAS.ComboBox.Init({ Id: 'cmbPivaStat', Type: 'PIVAState' }, { editable: false, "placeholder": "��Һ״̬..." });
}

// ֹͣǩҽ����ϸ�б�
function InitGridOrdExe() {
    var columns = [
        [
            { field: 'gridOrdExeChk', checkbox: true },
            { field: 'pNo', title: '���', width: 40 },
            { field: "doseDateTime", title: '��ҩʱ��', width: 100 },
            { field: "patInfo", title: '������Ϣ', width: 200 },
            { field: "batNo", title: '����', width: 50 },
            { field: 'incDescStr', title: 'ҩƷ��Ϣ', width: 300 },
            { field: 'freqDesc', title: 'Ƶ��', width: 75 },
            { field: 'instrDesc', title: '�÷�', width: 75 },
            { field: 'priDesc', title: 'ҽ�����ȼ�', width: 80 },
            { field: 'pogId', title: 'pogId', width: 80, hidden: true },
            { field: 'pid', title: 'pid', width: 40, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.PrintRecord",
            QueryName: "PrintDetail"
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        pageSize: 100,
        pageList: [100, 300, 500],
        pagination: true,
        onLoadSuccess: function() {},
        onClickRow: function(rowIndex, rowData) {},
        onBeforeLoad: function(param) {
            ClearTmpGlobal();
        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
}
// ǩ��ϸ�б�
function InitGridPrint() {
    var columns = [
        [
            { field: 'psName', title: '��Һ״̬', width: 75, styler: PIVAS.Grid.Styler.PivaState },
            { field: 'pogsNo', title: '���̵���', width: 170 },
            { field: 'pogsUserName', title: '������', width: 90 },
            { field: 'pogsDateTime', title: '����ʱ��', width: 155 }
        ]
    ];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.PrintRecord",
            QueryName: "PogsNoList"
        },
        fitColumns: true,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        onLoadSuccess: function() {
            ClearTmpGlobal();
            $("#gridOrdExe").dhcstgrideu("clear");
        },
        onClickRow: function(rowIndex, rowData) {
            var params = QueryParams();
            var pogsNo = rowData.pogsNo;
            $('#gridOrdExe').datagrid('query', { pogsNo: pogsNo, inputStr: params });
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridPrint", dataGridOption);
}
//��ѯ
function Query() {
    var params = QueryParams();
    $('#gridPrint').datagrid('query', { inputStr: params });
}

function QueryParams() {
    var prtStDate = $('#datePrtStart').datebox('getValue'); //��ʼ����
    var prtEdDate = $('#datePrtEnd').datebox('getValue'); //��ֹ����
    var prtStTime = $('#timePrtStart').timespinner('getValue');
    var prtEdTime = $('#timePrtEnd').timespinner('getValue');
    var locId = $('#cmbPivasLoc').combobox('getValue');
    var wardId = $('#cmbWard').combobox('getValue');
    var patNo = $("#txtPatNo").val().trim();
    var pNo = $("#txtPNo").val().trim();
    var workTypeId = $("#cmbWorkType").combobox("getValue");
    var psNumber = $("#cmbPivaStat").combobox("getValue");
    var params = locId + "^" + wardId + "^" + prtStDate + "^" + prtEdDate + "^" + prtStTime + "^" +
        prtEdTime + "^" + patNo + "^" + pNo + "^" + workTypeId + "^" + psNumber;
    return params;
}


function GetCheckedPogArr() {
    var pogArr = [];
    var gridChecked = $('#gridOrdExe').datagrid('getChecked');
    if (gridChecked == "") {
        $.messager.alert("��ʾ", "����ѡ���¼", "warning");
        return pogArr;
    }
    var cLen = gridChecked.length;
    for (var cI = 0; cI < cLen; cI++) {
        var pogId = gridChecked[cI].pogId;
        if (pogId == "") {
            continue;
        }
        if (pogArr.indexOf(pogId) < 0) {
            pogArr.push(pogId);
        }
    }
    return pogArr;
}

/// ��ӡ��ѡ
function PrintSelect() {
    if (PIVASPRINT.CheckActiveX("DHCSTPrint.PIVALabel") == false) {
        return;
    }
    var pogArr = GetCheckedPogArr();
    var pogLen = pogArr.length;
    if (pogLen == 0) {
        return;
    }
    var printNum = PIVASPRINT.PrintNum;
    for (var pogI = 0; pogI < pogLen; pogI++) {
        var pogId = pogArr[pogI];
        var printTask = "0";
        var count = pogI + 1;
        if (count % (printNum) == 0) {
            printTask = "1";
        }
        if (count == pogLen) {
            printTask = "1";
        }
        PIVASPRINT.Label({
            pogId: pogId,
            printTask: printTask,
            pageNumbers: pogLen,
            pageNo: count,
            rePrint: "(��)"
        })
    }
}
/// ��ӡ����
function PrintAll() {
    var gridRows = $("#gridOrdExe").datagrid("getRows");
    if (gridRows.length == 0) {
        $.messager.alert("��ʾ", "���Ȳ�ѯ����ǩ��ϸ", "warning");
        return;
    }
    var pid = gridRows[0].pid;
    $.messager.progress({
        title: "�����ĵȴ�...",
        text: '<b>{value}%</b>  ��  ӡ  ��  ��  ��  ',
        interval: 1000000
    })
    $.cm({
        ClassName: "web.DHCSTPIVAS.PrintRecord",
        MethodName: "JsonLabels",
        pid: pid
    }, function(retJson) {
        PIVASPRINT.LabelsJson = retJson;
        var retLen = retJson.length;
        if (retLen > 0) {
            PIVASPRINT.LabelsJsonPrint(retLen, 0)
        } else {
            $.messager.progress("close");
        }
    })
}
/// ����
function Clear() {
    ClearTmpGlobal();
    window.location.reload();
    /*
    InitDict();
    $("#gridPrint").datagrid("clear");
    $("#gridOrdExe").datagrid("clear");
    */
}
/// �����ʱglobal
function ClearTmpGlobal() {
    var gridRows = $("#gridOrdExe").datagrid("getRows");
    if (gridRows.length == 0) {
        return;
    }
    var pid = gridRows[0].pid;
    tkMakeServerCall("web.DHCSTPIVAS.PrintRecord", "KillPrintData", pid);
}
window.onbeforeunload = function() {
    ClearTmpGlobal();
}