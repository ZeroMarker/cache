/**
 * 模块:     保留药累计查询
 * 编写日期: 2018-05-24
 * 编写人:   QianHuanjuan
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
                    { field: 'incCode', title: '药品代码', width: 100, sortable: true },
                    { field: 'incDesc', title: '药品名称', width: 400, sortable: true },
                    { field: 'incSpec', title: '规格', width: 100, sortable: true }
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

// 病区列表
function InitGridWard() {
    var columns = [
        [
            { field: 'rowid', title: 'rowid', width: 100, hidden: true },
            { field: 'locdesc', title: '病区/医生科室', width: 180 },
            { field: 'incidesc', title: '药品名称', width: 240 },
            { field: 'accumqty', title: '积累数', width: 90, align: 'right', halign: 'left' },
            { field: 'bUomDesc', title: '单位', width: 90, align: 'left', halign: 'left' },
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

// 查询
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
			msg: '请选择药房',
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

// 保留药累计明细列表
function InitGridInsulinDetail() {
    var columns = [
        [
            { field: 'predetilid', title: '子表id', width: 80, hidden: true },
            {
                field: 'bustype',
                title: '类型',
                width: 75,
                align: 'center',
                halign: 'left',
                styler: function(value, row, index) {
                    if (value.indexOf("发") >= 0) {
                        return 'background-color:#e3f7ff;color:#1278b8;';
                    } else if (value.indexOf("退") >= 0) {
                        return 'background-color:#ffe3e3;color:#ff3d2c;';
                    }
                }
            },
            { field: 'busqty', title: '业务数量', width: 80, halign: 'left', align: 'right' },
            { field: 'busavqty', title: '保留结余数量', width: 100, halign: 'left', align: 'right' },
            { field: 'busdate', title: '业务日期', width: 150 },
            { field: 'bususer', title: '业务操作人', width: 100 }
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
// 查询明细
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