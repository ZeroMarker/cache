/**
 * ģ��:     ��Һҽ����ѯ
 * ��д����: 2018-03-01
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionWard = session['LOGON.WARDID'] || "";
$(function() {
    InitDict();
    InitGridPat();
    InitGridOrdItm();
    //InitGridRecord();
    $('#btnFind').bind("click", Query);
    $('#btnClear').bind("click", Clear);
    $('#txtPatNo').bind('keypress', function(event) {
        if (event.keyCode == "13") {
            var patNo = $('#txtPatNo').val();
            if (patNo == "") {
                return;
            }
            var patNo = PIVAS.PadZero(patNo, PIVAS.PatNoLength());
            $('#txtPatNo').val(patNo);
            Query();
        }
    });
});
window.onbeforeunload = function() {
    Clear();
}

function InitDict() {
    // ����
    PIVAS.Date.Init({ Id: 'dateOrdStart', LocId: "", Type: 'Start', QueryType: 'Query' });
    PIVAS.Date.Init({ Id: 'dateOrdEnd', LocId: "", Type: 'End', QueryType: 'Query' });
    PIVAS.ComboBox.Init({ Id: 'cmbPivasLoc', Type: 'PivaLoc' }, {
        placeholder: "��Һ����...",
        editable: false,
        onLoadSuccess: function() {
            var datas = $("#cmbPivasLoc").combobox("getData");
            if (datas.length == 1) {
                $("#cmbPivasLoc").combobox("select", datas[0].RowId);

            } else {
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $("#cmbPivasLoc").combobox("setValue", datas[i].RowId);
                        break;
                    }
                }
            }
        }
    });
    // ����
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {
        placeholder: "����...",
        readonly: (SessionWard != "") ? true : false,
        onLoadSuccess: function() {
	        if(SessionWard != ""){
               $("#cmbWard").combobox("setValue", SessionWard);
	        }
        }
    });
}

// ҽ����ϸ�б�
function InitGridOrdItm() {
    var columns = [
        [{
                field: 'pivaState',
                title: '״̬',
                width: 75,
                styler: PIVAS.Grid.Styler.PivaState
            },
            { field: "passResult", title: '������', width: 85,
            	 styler: function(value, row, index) {
                    if (value.indexOf("���ͨ��")>=0) {
                        return 'background-color:#019BC1;color:white;'; //��ɫ
                    } else if (value.indexOf("��˾ܾ�")>=0) {
                        return 'background-color:#C33A30;color:white;'; //��ɫ
                    } else if (value.indexOf("ҽ������")>=0) {
                        return 'background-color:#FFB63D;color:white;'; //ǳ��ɫ
                    } 
                }
            },{
                field: 'batNo',
                title: '����',
                width: 50
            },
            {
                field: 'oeoriSign',
                title: '��',
                width: 30,
                halign: 'left',
                align: 'center',
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            { field: 'incDesc', title: 'ҩƷ', width: 300 },
            { field: 'incSpec', title: '���', width: 100 },
            { field: 'dosage', title: '����', width: 75 },
            { field: 'freqDesc', title: 'Ƶ��', width: 75 },
            { field: 'instrucDesc', title: '�÷�', width: 75 },
            { field: 'doseDateTime', title: '��ҩʱ��', width: 100 },
            { field: 'priDesc', title: 'ҽ�����ȼ�', width: 80 },
            { field: 'qty', title: '����', width: 50 },
            { field: 'uomDesc', title: '��λ', width: 50 },
            { field: 'docName', title: 'ҽ��', width: 80, hidden:true },
            { field: "mOeore", title: 'mOeore', width: 100, hidden: true },
            { field: "colColor", title: 'colColor', width: 100, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        toolbar:[],
        onLoadSuccess: function() {
	    	$(this).datagrid("options").checking = "";
	    },
        onSelect: function(rowIndex, rowData) {
	        if ($(this).datagrid("options").checking == true) {
				return;
			}
			$(this).datagrid("options").checking = true;
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItm',
                Field: 'mOeore',
                Check: true,
                Value: rowData.mOeore,
                Type: 'Select'
            });
            $(this).datagrid("options").checking = "";
        },
        onUnselect: function(rowIndex, rowData) {
            PIVAS.Grid.ClearSelections(this.id);
        },
        onClickRow: function(rowIndex, rowData) {
            //var mOeore = rowData.mOeore;
            //QueryRecord(mOeore);
        },
        onClickCell: function(rowIndex, field, value) {
            var mOeore = $(this).datagrid("getRows")[rowIndex].mOeore;
            PIVASTIMELINE.Init({
                Params: mOeore,
                Field: 'oeoriSign',
                ClickField: field
            })
        },
        rowStyler: function(index, row) {
            /*
            var colColor = row.colColor;
            var colorStyle = "";
            if ((colColor % 2) == 0) { // ������ı���ɫ
                colorStyle = PIVAS.Grid.CSS.SignRowEven;
            }
            return colorStyle;
            */
        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridOrdItm", dataGridOption);
}

// ׷�ټ�¼�б�
function InitGridRecord() {
    var columns = [
        [
            { field: 'pivasState', title: '״̬', width: 80, halign: 'center' },
            { field: 'dateTime', title: 'ʱ��', width: 120, halign: 'center', align: 'center' },
            { field: 'userName', title: '������', width: 80, halign: 'center' }
        ]
    ];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'LabelExeRecords'
        },
        toolbar:[],
        fitColumns: true,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        onLoadSuccess: function() {

        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridRecord", dataGridOption);
}
// �����б�
function InitGridPat() {
    var columns = [
        [
            { field: 'patId', title: 'PatId', width: 80, halign: 'center', hidden: true },
            { field: 'bedNo', title: '����', width: 75 },
            { field: 'patName', title: '����', width: 80 },
            { field: 'patNo', title: '�ǼǺ�', width: 100 },
            { field: 'patSex', title: '�Ա�', width: 60 },
            { field: 'patAge', title: '����', width: 75 },
            { field: 'wardDesc', title: '����', width: 200 }
        ]
    ];

    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.OeQuery",
            QueryName: "OeQueryPat"
        },
        fitColumns: false,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false,
        toolbar:[],
        onSelect: function(rowIndex, rowData) {
            var paramsArr = QueryParams();
            paramsArr[5] = rowData.patNo;
            var params = paramsArr.join("^");
            $('#gridOrdItm').datagrid({
                url: PIVAS.URL.COMMON + '?action=JsGetOeQueryDetail',
                queryParams: {
                    params: params
                }
            });
            $('#gridRecord').datagrid('clear');
        },
        onLoadSuccess: function(data) {
			$('#gridOrdItm').datagrid('clear');
			if (data.rows.length==1){
				$("#gridPat").datagrid("selectRow",0);
			}
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridPat", dataGridOption);
}

function Query() {
    var paramsArr = QueryParams();
    var params = paramsArr.join("^");
    $('#gridPat').datagrid('query', {
        inputStr: params,
        rows:9999
    });
}
//���
function Clear() {
    InitDict();
    $('#txtPatNo').val("");
    $('#gridPat').datagrid('clear');
    $('#gridOrdItm').datagrid('clear');
    $('#gridRecord').datagrid('clear');
}

function QueryParams() {
    var paramsArr = [];
    var ordStDate = $('#dateOrdStart').datebox('getValue'); //��ʼ����
    var ordEdDate = $('#dateOrdEnd').datebox('getValue'); //��ֹ����
    var ordStTime = $('#timeOrdStart').timespinner('getValue');
    var ordEdTime = $('#timeOrdEnd').timespinner('getValue');
    var patNo = $('#txtPatNo').val();
    var locId = $('#cmbPivasLoc').combobox('getValue');
    var wardId = $('#cmbWard').combobox('getValue');
    paramsArr[0] = ordStDate;
    paramsArr[1] = ordEdDate;
    paramsArr[2] = ordStTime;
    paramsArr[3] = ordEdTime;
    paramsArr[4] = locId;
    paramsArr[5] = patNo;
    paramsArr[6] = wardId;
    return paramsArr;
}