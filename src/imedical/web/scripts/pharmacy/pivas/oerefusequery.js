/**
 * ģ��:     �ܾ���Һҽ����ѯ
 * ��д����: 2018-06-25
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var hisPatNoLen = PIVAS.PatNoLength();
$(function() {
    InitDict();
    InitGridOrdExe();
    $("#btnFind").on('click', Query);
    setTimeout(Query, 500);
    $('#txtPatNo').on('keypress', function(event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#txtPatNo").val());
            if (patNo != "") {
                var patNo = PIVAS.PadZero(patNo, hisPatNoLen);
                $("#txtPatNo").val(patNo);
                Query();
            }
        }
    });
});

function InitDict() {
    // ����
    PIVAS.Date.Init({ Id: 'dateOrdStart', DateT: "t-1" });
    PIVAS.Date.Init({ Id: 'dateOrdEnd', DateT: "t+1" });
}

// ҽ����ϸ�б�
function InitGridOrdExe() {
    var columns = [
        [
            { field: 'wardDesc', title: '����', width: 150, hidden: true },
            { field: 'operReason', title: '��Һ�ܾ�ԭ��', width: 150 },
            { field: 'doseDateTime', title: '��ҩ����', width: 95 },
            { field: 'bedNo', title: '����', width: 75 },
            { field: 'patNo', title: '�ǼǺ�', width: 100 },
            { field: 'patName', title: '����', width: 100 },
            {
                field: 'batNo',
                title: '����',
                width: 50,
                styler: function(value, row, index) {
                    var colorStyle = '';
                    if (row.packFlag != "") {
                        colorStyle = PIVAS.Grid.CSS.BatchPack;
                    }
                    return colorStyle;
                }
            },
            {
                field: 'oeoriSign',
                title: '��',
                width: 30,
                align: 'center',
                styler: function(value, row, index) {
                    var colColorArr = row.colColor.split("-");
                    var colorStyle = "";
                    if ((colColorArr[0] % 2) == 0) { // ż���б�ɫ,�����˵ı���ɫ
                        colorStyle = PIVAS.Grid.CSS.PersonEven;
                    }
                    return colorStyle;
                },
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            { field: 'incDesc', title: 'ҩƷ', width: 250 },
            { field: 'incSpec', title: '���', width: 100 },
            { field: 'dosage', title: '����', width: 75 },
            { field: 'qty', title: '����', width: 50 },
            { field: 'freqDesc', title: 'Ƶ��', width: 75 },
            { field: 'instrucDesc', title: '�÷�', width: 80 },
            { field: 'bUomDesc', title: '��λ', width: 50 },
            { field: 'docName', title: 'ҽ��', width: 75 },
            { field: 'priDesc', title: '���ȼ�', width: 75 },
            { field: "packFlag", title: '���', width: 85, hidden: true },
            { field: 'ordRemark', title: '��ע', width: 75 },
            { field: "mDsp", title: 'mDsp', width: 70, hidden: false },
            { field: 'colColor', title: 'colColor', width: 50, hidden: true },
            { field: "pogId", title: 'pogId', width: 70, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: null,
        fit: true,
        border: false,
        singleSelect: true,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        view: scrollview,
        toolbar: "#gridOrdExeBar",
        onSelect: function(rowIndex, rowData) {
            /* scrollview�����谴ҳ����,�ҷ�ҳ�����������
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp,
                Type: 'Select'
            });
            */
        },
        onUnselect: function(rowIndex, rowData) {
            $('#gridOrdExe').datagrid("unselectAll");
        },
        onClickCell: function(rowIndex, field, value) {},
        rowStyler: function(index, row) {}
    }
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
}

function Query() {
    $.cm({
        ClassName: "web.DHCSTPIVAS.OeRefuseQuery",
        QueryName: "QueryOeRefuse",
        inputStr: LoadAdmId + "^" + SessionLoc + "^" + $('#dateOrdStart').datebox('getValue') + "^" + $('#dateOrdEnd').datebox('getValue')+ "^" + $.trim($("#txtPatNo").val()),
        ResultSetType: "array",
        page: 1,
        rows: 9999
    }, function(retJson) {
        $("#gridOrdExe").datagrid("loadData", retJson)
    })
}