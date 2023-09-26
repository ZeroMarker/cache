/**
 * ģ��:     ����ҩ�ۼƲ�ѯ
 * ��д����: 2018-05-24
 * ��д��:   QianHuanjuan
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionWard = session['LOGON.WARDID'] || "";
var HospId = session['LOGON.HOSPID'] || "";
$(function() {
    InitGridWard();
    InitGridInsulinDetail();
    DHCPHA_HUI_COM.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {
        onLoadSuccess: function() {
            if (SessionWard != "") {
                var datas = $("#cmbWard").combobox("getData");
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionWard) {
                        $("#cmbWard").combobox("setValue", datas[i].RowId);
                        break;
                    }
                }
            }
        }
    });
    DHCPHA_HUI_COM.ComboBox.Init({ Id: 'cmbDocLoc', Type: 'DocLoc' }, {});
    DHCPHA_HUI_COM.ComboBox.Init({ Id: 'cmbPhaLoc', Type: 'PhaLoc' }, {
        onLoadSuccess: function() {
            var datas = $("#cmbPhaLoc").combobox("getData");
            for (var i = 0; i < datas.length; i++) {
                if (datas[i].RowId == SessionLoc) {
                    $("#cmbPhaLoc").combobox("setValue", datas[i].RowId);
                    break;
                }
            }
        }
    });
    DHCPHA_HUI_COM.ComboGrid.Init({ Id: 'cmgINCItm', Type: 'IncItm' }, {
	            QueryParams: {
                ClassName: "web.DHCSTPharmacyDict",
                QueryName: "IncItm",
                inputStr: ""
            },
            pageNumber: 0,
            panelWidth: 750,
            columns: [
                [
                    { field: 'incRowId', title: 'incItmRowId', width: 100, sortable: true, hidden: true },
                    { field: 'incCode', title: 'ҩƷ����', width: 100, sortable: true },
                    { field: 'incDesc', title: 'ҩƷ����', width: 400, sortable: true },
                    { field: 'incSpec', title: '���', width: 100, sortable: true }
                ]
            ],
            pagination:true,
            idField: 'incRowId',
            textField: 'incDesc',
			onBeforeLoad:function(params){
				params.filterText=params.q;
				params.inputStr="^"+$("#cmbPhaLoc").combobox("getValue")||"";
			}
	});
    $("#dateStart").datebox("setValue", DHCPHA_TOOLS.Today());
    $("#dateEnd").datebox("setValue", DHCPHA_TOOLS.Today());
    $("#btnFind").on("click", Query);
});

// �����б�
function InitGridWard() {
    var columns = [
        [
            { field: 'rowid', title: 'rowid', width: 100, hidden: true },
            { field: 'locdesc', title: '����/ҽ������', width: 180 },
            { field: 'incidesc', title: 'ҩƷ����', width: 240 },
            { field: 'accumqty', title: '������', width: 90, align: 'right', halign: 'left' },
            { field: 'bUomDesc', title: '��λ', width: 90, align: 'left', halign: 'left' },
        ]
    ];
    var dataGridOption = {
        url: "DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.QueryInsuliIn&MethodName=JsInsulinResQty",
        queryParams: {},
        fit: true,
        border: false,
        singleSelect: true,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        onSelect: function(rowIndex, rowData) {
            if (rowData) {
                QueryDetail();
            }
        },
        onLoadSuccess: function() {
            $("#gridInsulinDetail").datagrid("clear");
        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridWard", dataGridOption);
}

// ��ѯ
function Query() {
	var params = '';
    var stDate = $('#dateStart').datebox('getValue');
    var edDate = $('#dateEnd').datebox('getValue');
    var wardId = $('#cmbWard').combobox("getValue")||"";
    var phaLocId = $('#cmbPhaLoc').combobox("getValue")||"";
    var docLocId = $('#cmbDocLoc').combobox("getValue")||"";
    var inci=$("#cmgINCItm").combogrid("getValue")||"";
	if(phaLocId===''){
		$.messager.popover({
			msg: '��ѡ��ҩ��',
			type:'alert'
		});
		return;
	}
    params = stDate + "^" + edDate + "^" + wardId + "^" + phaLocId + "^" +docLocId + "^" + inci ;
    $('#gridWard').datagrid({
        queryParams: {
            inputStr: params
        }
    });
}

// ����ҩ�ۼ���ϸ�б�
function InitGridInsulinDetail() {
    var columns = [
        [
            { field: 'predetilid', title: '�ӱ�id', width: 80, hidden: true },
            {
                field: 'bustype',
                title: '����',
                width: 75,
                align: 'center',
                halign: 'left',
                styler: function(value, row, index) {
                    if (value.indexOf("��") >= 0) {
                        return 'background-color:#e3f7ff;color:#1278b8;';
                    } else if (value.indexOf("��") >= 0) {
                        return 'background-color:#ffe3e3;color:#ff3d2c;';
                    }
                }
            },
            { field: 'busqty', title: 'ҵ������', width: 80, halign: 'left', align: 'right' },
            { field: 'busavqty', title: '������������', width: 100, halign: 'left', align: 'right' },
            { field: 'busdate', title: 'ҵ������', width: 150 },
            { field: 'bususer', title: 'ҵ�������', width: 100 }
        ]
    ];
    var dataGridOption = {
        url: "DHCST.METHOD.BROKER.csp?ClassName=web.DHCINPHA.QueryInsuliIn&MethodName=JsInsulinDetail",
        queryParams: {},
        fit: true,
        border: false,
        singleSelect: true,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true
    }
    DHCPHA_HUI_COM.Grid.Init("gridInsulinDetail", dataGridOption);
}
// ��ѯ��ϸ
function QueryDetail() {
    var gridSelect = $('#gridWard').datagrid('getSelected');
    var stDate = $('#dateStart').datebox('getValue');
    var edDate = $('#dateEnd').datebox('getValue');
    var rowid = gridSelect.rowid;
    var params = stDate + "^" + edDate + "^" + rowid;
    $('#gridInsulinDetail').datagrid({
        queryParams: {
            inputStr: params
        }
    });
}