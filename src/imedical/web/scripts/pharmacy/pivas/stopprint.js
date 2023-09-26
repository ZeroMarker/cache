/**
 * ģ��:     ��Һֹͣǩ��ӡ��¼
 * ��д����: 2018-03-02
 * ��д��:   dinghongying
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function() {
    InitDict();
    InitGridOrdExe();
    InitGridCPrint();
    $('#btnFind').bind("click", Query);
    $('#btnPrint').bind("click", PrintStopLabel);
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
        }
    });
    // ����
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, { placeholder: "����..." });
}

// ֹͣǩҽ����ϸ�б�
function InitGridOrdExe() {
    var columns = [
        [
            { field: 'gridOrdExeChk', checkbox: true },
            { field: "doseDateTime", title: '��ҩʱ��', width: 95 },
            { field: "wardDesc", title: '����', width: 150 },
            { field: 'bedNo', title: '����', width: 50 },
            { field: "patNo", title: '�ǼǺ�', width: 100 },
            { field: "patName", title: '��������', width: 70 },
            { field: "batNo", title: '����', width: 50 },
            {
                field: 'oeoriSign',
                title: '��',
                width: 30,
                styler: function(value, row, index) {
                    var colColor = row.colColor;
                    var colorStyle = "";
                    if ((colColor % 2) == 0) { // ������ı���ɫ
                        colorStyle = PIVAS.Grid.CSS.PersonEven;
                    }
                    return colorStyle;
                },
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            { field: 'incDesc', title: 'ҩƷ', width: 300 },
            { field: 'incSpec', title: '���', width: 100 },
            { field: 'dosage', title: '����', width: 75 },
            { field: 'freqDesc', title: 'Ƶ��', width: 75 },
            { field: 'instrucDesc', title: '�÷�', width: 75 },
            { field: 'priDesc', title: 'ҽ�����ȼ�', width: 80 },
            { field: 'qty', title: '����', width: 50 },
            { field: 'bUomDesc', title: '��λ', width: 50 },
            { field: 'docName', title: 'ҽ��', width: 80 },
            { field: 'pogId', title: 'pogId', width: 80, hidden: true },
            { field: "colColor", title: 'colColor', width: 100, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: PIVAS.URL.COMMON + "?action=JsGetStopOeQueryDetail",
        fitColumns: false,
        border: true,
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageSize: 100,
        pageList: [100, 300, 500],
        pagination: true,
        border: false,
        onLoadSuccess: function() {},
        onClickRow: function(rowIndex, rowData) {},
        rowStyler: function(index, row) {

        },
        onCheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId
            });
        },
        onUncheck: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: false,
                Value: rowData.pogId
            });
        },
        onSelect: function(rowIndex, rowData) {
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId,
                Type: 'Select'
            });
        },
        onUnselect: function(rowIndex, rowData) {
            $('#gridOrdExe').datagrid("unselectAll");
        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
}
// ֹͣǩ��ϸ�б�
function InitGridCPrint() {
    var columns = [
        [
            { field: 'cPrtId', title: 'PrtId', width: 125, hidden: true },
            { field: 'cPrtNo', title: 'ֹͣǩ��ӡ��', width: 125 },
            { field: 'cPrtUserName', title: '��ӡ��', width: 100 },
            { field: 'cPrtDateTime', title: '��ӡʱ��', width: 150 }
        ]
    ];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.StopPrint",
            QueryName: "CPrintList"
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        onLoadSuccess: function() {},
        onClickRow: function(rowIndex, rowData) {
            var wardId = $('#cmbWard').combobox('getValue');
            var patNo = $("#txtPatNo").val().trim();
            $('#gridOrdExe').datagrid({
                queryParams: {
                    params: rowData.cPrtId + "^" + wardId + "^" + patNo
                }
            });
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridCPrint", dataGridOption);
}
//��ѯ
function Query() {
    var params = QueryParams();
    $('#gridCPrint').datagrid("query", {
        inputStr: params
    });
}

function QueryParams() {
    var prtStDate = $('#datePrtStart').datebox('getValue'); //��ʼ����
    var prtEdDate = $('#datePrtEnd').datebox('getValue'); //��ֹ����
    var prtStTime = $('#timePrtStart').timespinner('getValue');
    var prtEdTime = $('#timePrtEnd').timespinner('getValue');
    var locId = $('#cmbPivasLoc').combobox('getValue');
    var wardId = $('#cmbWard').combobox('getValue');
    var patNo = $("#txtPatNo").val().trim();
    var params = locId + "^" + wardId + "^" + prtStDate + "^" + prtEdDate + "^" + prtStTime + "^" + prtEdTime + "^" + patNo;
    return params;
}

// ����ֹͣǩ
function PrintStopLabel() {
    $.messager.confirm('��ӡ��ʾ', '��ȷ�����´�ӡֹͣǩ��?', function(r) {
        if (r) {
            if (PIVASPRINT.CheckActiveX("DHCSTPrint.PIVALabel") == false) {
                return;
            }
            var pogArr = GetCheckedPogArr();
            var pogLen = pogArr.length;

            if (pogLen == 0) {
                return;
            }
            // ����ֹͣǩ��¼��,Ĭ���ٴδ�ӡ������
            /*
            var pCPRet = tkMakeServerCall("web.DHCSTPIVAPRTLABEL", "SaveCPrint", pogArr.join("^"));
            var pCPRetArr = pCPRet.split("^");
            var pCPId = pCPRetArr[0];
            if (pCPId < 0) {
                $.messager.alert('��ʾ', pCPRetArr[1], "warning");
                return;
            }
            */
            var count = 0;
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
                PIVASPRINT.Label({ pogId: pogId, printTask: printTask, rePrint: "(��)" })
            }

        }
    });
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