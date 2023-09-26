/**
 * ģ��:     ��Һ��ҩ��ѯ
 * ��д����: 2018-03-13
 * ��д��:   dinghongying
 */
var SessionLoc = session['LOGON.CTLOCID']
$(function() {
    PIVAS.Session.More(SessionLoc)
    InitDict();
    InitGridWard();
    InitDispDetail();
    $('#btnFind').on("click", Query);
    $('#btnFindDetail').on("click", QueryDetail)
    $('#btnPrint').on("click", Print);
    $('#btnClear').on('click', Clear)
    $('#txtPatNo').on('keypress', function(event) {
        if (event.keyCode == "13") {
            var patNo = $('#txtPatNo').val();
            if (patNo == "") {
                return;
            }
            var patNo = PIVAS.PadZero(patNo, PIVAS.PatNoLength());
            $('#txtPatNo').val(patNo);
            QueryDetail();
        }
    });
    $(".dhcpha-win-mask").remove();
});

function InitDict() {
    //����
    PIVAS.Date.Init({ Id: 'dateDispStart', LocId: "", Type: 'Start', QueryType: 'Query' });
    PIVAS.Date.Init({ Id: 'dateDispEnd', LocId: "", Type: 'End', QueryType: 'Query' });
    //��Һ����
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
    //����
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
    //ҩƷ����
    PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { width: 258 });
}

function InitGridWard() {
    var columns = [
        [
            { field: 'wardSelect', checkbox: true },
            { field: "wardId", title: 'wardId', width: 80, hidden: true },
            { field: 'wardDesc', title: '����', width: 150 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.DispQuery",
            QueryName: "DispQueryWard"
        },
        toolbar:[],
        fitColumns: true,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        singleSelect: false,
        onSelect: function(rowIndex, rowData) {},
        onLoadSuccess: function() {
            $("#gridDispDetail").datagrid("clear");
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridWard", dataGridOption);
}

// ��ҩ��ϸ�б�
function InitDispDetail() {
    var columns = [
        [
            { field: 'incId', title: 'incId', width: 300, hidden: true },
            { field: 'incCode', title: 'ҩƷ����', width: 100 },
            { field: 'incDesc', title: 'ҩƷ����', width: 200 },
            { field: 'incSpec', title: '���', width: 75 },
            { field: 'phManfDesc', title: '����', width: 100 },
            { field: 'bUomDesc', title: '��λ', width: 50 },
            { field: 'dispQty', title: '��ҩ����', width: 75, align: 'right' },
            { field: 'dispSpAmt', title: '��ҩ���', width: 100, align: 'right' },
            { field: 'retQty', title: '��ҩ����', width: 75, align: 'right' },
            { field: 'retSpAmt', title: '��ҩ���', width: 100, align: 'right' },
            { field: 'totalQty', title: '�ϼ�����', width: 75, align: 'right' },
            { field: 'totalSpAmt', title: '�ϼƽ��', width: 100, align: 'right' }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.DispQuery",
            QueryName: "DispQueryDetail"
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: true,
        toolbar:[],
        onLoadSuccess: function() {

        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridDispDetail", dataGridOption);
}

//��ѯ
function Query() {
    var params = QueryParams("Query");
    if (params == "") {
        return;
    }
    $('#gridWard').datagrid('query', {
        inputStr: params,
        rows:9999
    });
}

function QueryDetail() {
    var params = QueryParams("QueryDetail");
    if (params == "") {
        return;
    }
    $('#gridDispDetail').datagrid('query', {
        inputStr: params
    });
}

function QueryParams(queryType) {
    var paramsArr = [];
    var locId = $('#cmbPivasLoc').combobox('getValue') || '';
    var dispStDate = $('#dateDispStart').datebox('getValue');
    var dispEdDate = $('#dateDispEnd').datebox('getValue');
    var dispStTime = $('#timeDispStart').timespinner('getValue');
    var dispEdTime = $('#timeDispEnd').timespinner('getValue');
    var patNo = $('#txtPatNo').val().trim();
    var incItm = $('#cmgIncItm').combobox('getValue') || '';
    var wardStr = "";
    if (queryType == "QueryDetail") {
        var wardChecked = $('#gridWard').datagrid('getChecked');
        for (var i = 0; i < wardChecked.length; i++) {
            if (wardStr == "") {
                wardStr = wardChecked[i].wardId;
            } else {
                wardStr = wardStr + "," + wardChecked[i].wardId;
            }
        }
        if (wardStr == "") {
            $.messager.alert("��ʾ", "��ѡ����ಡ��", 'warning');
            return "";
        }
    } else {
        wardStr = $('#cmbWard').combobox('getValue') || '';
    }
    var onlyPiva = $('#chkOnlyPiva').checkbox('getValue');
    if (onlyPiva == false) {
        var onlyPivaFlag = 0;
    } else {
        var onlyPivaFlag = 1;
    }
    paramsArr[0] = locId;
    paramsArr[1] = dispStDate;
    paramsArr[2] = dispEdDate;
    paramsArr[3] = dispStTime;
    paramsArr[4] = dispEdTime;
    paramsArr[5] = wardStr;
    paramsArr[6] = patNo;
    paramsArr[7] = onlyPivaFlag;
    paramsArr[8] = incItm;
    return paramsArr.join("^");
}
// ����
function Clear() {
    PIVAS.Date.Init({ Id: 'dateDispStart', LocId: "", Type: 'Start', QueryType: 'Query' });
    PIVAS.Date.Init({ Id: 'dateDispEnd', LocId: "", Type: 'End', QueryType: 'Query' });
    $('#cmbPivasLoc').combobox('select',SessionLoc);
    $('#timeDispStart').timespinner('setValue',"");
    $('#timeDispEnd').timespinner('setValue',"");
    $('#txtPatNo').val("");
    $('#cmgIncItm').combobox('clear'); 
    $('#cmbWard').combobox('clear');
    $('#chkOnlyPiva').checkbox('setValue',true);
    $('#gridWard').datagrid('clear');
    $('#gridDispDetail').datagrid('clear');
}
// ��ӡ
function Print() {
    var params = QueryParams("QueryDetail");
    if (params == "") {
        return;
    }
    var startDate = $('#dateDispStart').datebox('getValue');
    var endDate = $('#dateDispEnd').datebox('getValue');
    var raqObj = {
        raqName: "DHCST_PIVAS_��ҩ��ѯͳ��.raq",
        raqParams: {
            startDate: startDate,
            endDate: endDate,
            userName: session['LOGON.USERNAME'],
            hospDesc: PIVAS.Session.HOSPDESC,
            locDesc: $('#cmbPivasLoc').combobox('getText'),
            raqFlag: 1,
            inputStr: params
        },
        isPreview: 1
    };
    PIVASPRINT.RaqPrint(raqObj)
}