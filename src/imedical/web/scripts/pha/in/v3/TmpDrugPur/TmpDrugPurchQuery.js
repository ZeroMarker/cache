/**
 * 模块:     临购药品授权
 * 编写日期: 2020-09-18
 * 编写人:   yangsj
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
var SessionGroup = session['LOGON.GROUPID'];
var lookUpWidth = 300;
$(function () {
    InitGridDict();
    InitDict();
    InitGrid();
    InitBtnEvent();
});

function InitBtnEvent() {
    $('#btnFind').on('click', QuerygridTmpDrugMain);
    $('#btnClear').on('click', ClearDetail);
}

function ClearDetail() {
    $('#gridTmpDrugDetail').datagrid('clear');
}

function ClearGrid()
{
	//$('#gridTmpDrugMain').datagrid('clearSelections');
    //$('#gridTmpDrugMain').datagrid('clear');
    $('#gridTmpDrugDetail').datagrid('clearSelections');
	$('#gridTmpDrugDetail').datagrid('clear');
	$('#gridTmpDrugDisp').datagrid('clear');
	$('#gridTmpDrugAudit').datagrid('clear');
}

function QuerygridTmpDrugMain() {
	ClearGrid();
    $('#gridTmpDrugMain').datagrid('query', {
        StDate: $('#dateStart').datebox('getValue'),
        EdDate: $('#dateEnd').datebox('getValue'),
        HospId: SessionHosp,
        Status: $('#cmbAuditStatus').combobox('getValue'),
        Inci: $('#cmbgridInci').lookup('getValue'),
    });
}

function QuerygridTmpDrugDetail() {
	$('#gridTmpDrugDisp').datagrid('clear');
    var gridSelect = $('#gridTmpDrugMain').datagrid('getSelected') || '';
    var TDP = '';
    if (gridSelect) TDP = gridSelect.TDP;
    else return;
    $('#gridTmpDrugDetail').datagrid('query', {
        TDP: TDP,
    });
    $('#gridTmpDrugAudit').datagrid('query', {
        TDP: TDP,
    });
}

function QuerygridTmpDrugDisp() {
    var gridSelect = $('#gridTmpDrugDetail').datagrid('getSelected') || '';
    var TDPI = '';
    if (gridSelect) TDPI = gridSelect.TDPi;
    else return;
    $('#gridTmpDrugDisp').datagrid('query', {
        TDPI: TDPI,
    });
}

// 初始化默认条件
function InitDict() {
    //日期
    $.cm(
        {
            ClassName: 'PHA.IN.TmpDrugPurch.Query',
            MethodName: 'GetDefaultDate',
        },
        function (retData) {
            var DateArr = retData.split('^');
            $('#dateStart').datebox('setValue', DateArr[0]);
            $('#dateEnd').datebox('setValue', DateArr[1]);
        }
    );
}

function InitGridDict() {
    //审核状态
    PHA.ComboBox('cmbAuditStatus', {
        url: PHA_STORE.TmpDurgAuditStatus('ALL').url,
    });
    //药品名称lookup
    var opts = $.extend({}, PHA_STORE.INCItmForTmp('Y'), {
        width: lookUpWidth,
    });
    PHA.LookUp('cmbgridInci', opts);
}

function InitGrid() {
    InitTmpDrugDetail();
    InitTmpDrugMian();
    InitTmpDrugAudit();
    InitTmpDrugDisp();
}

function InitTmpDrugDetail() {
    var columns = [
        [
            // TDPi,inci,inciDesc,tmpDesc,spec,qty,uom,uomDesc,manf,manfDesc

            { field: 'TDPi', title: 'TDPi', hidden: true },
            { field: 'scgDesc', title: '类组', align: 'center', width: 55 },
            { field: 'statusi', title: '明细状态', align: 'center', width: 80 },
            {
                field: 'inciDesc',
                title: $g('药品名称<font color ="green">(已维护)</font>'),
                width: 232,
                formatter: Inciformatter,
            },
            { field: 'tmpDesc', title: $g('药品名称<font color ="red">(未维护)</font>'), width: 232 },
            { field: 'spec', title: '规格', width: 100 },
            { field: 'qty', title: '申请数量', align: 'right', width: 70 },
            { field: 'useQty', title: '已用数量', align: 'right', width: 70 },
            { field: 'uomDesc', title: '单位', width: 60 },
            { field: 'manfDesc', title: '生产企业', width: 250 },
            { field: 'inci', title: 'inci', width: 250, hidden: true },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurchQuery.Query',
            QueryName: 'SelectTmpDrug',
            TDPRowIdStr: '',
            AuthStatus: '',
        },
        //fitColumns: true,
        gridSave: false,
        fit: true,
        columns: columns,
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                QuerygridTmpDrugDisp();
            }
        },
    };
    PHA.Grid('gridTmpDrugDetail', dataGridOption);
}

function Inciformatter(value, rowData, rowIndex) {
    var inci = rowData.inci;
    if (inci == $('#cmbgridInci').lookup('getValue'))
        return "<div style='background-color:green;color:white'>" + value + '</div>';
    else return value;
}
// 新增行
function AddNewRow() {
    $('#gridTmpDrugDetail').datagrid('addNewRow', {
        editField: 'inci',
    });
}

function InitTmpDrugMian() {
    var columns = [
        [
            //TDP,TDPNo,Date,Time,Creator,CreatorName,Type,TypeDese,TypeValue,TypeValueDesc,lastStateId,lastStateDesc
            { field: 'TDP', title: 'TDP', width: 225, hidden: true },
            { field: 'TDPNo', title: '单号', width: 170 },
            { field: 'CreatorName', title: '建单人', width: 70 },
            { field: 'Date', title: '建单日期', width: 100 },
            { field: 'Time', title: '建单时间', width: 80 },
            { field: 'TypeDese', title: '使用类型', width: 80 },
            { field: 'TypeValueDesc', title: '使用类型值', width: 150 },
            { field: 'lastStateDesc', title: '审核状态', width: 100 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurchQuery.Query',
            QueryName: 'QueryTmpDrug',
            StDate: $('#dateStart').datebox('getValue'),
            EdDate: $('#dateEnd').datebox('getValue'),
            HospId: '',
            Status: '',
            Inci: '',
        },
        fitColumns: true,
        fit: true,
        columns: columns,
        toolbar: '#gridTmpDrugMainBar',
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                QuerygridTmpDrugDetail();
            }
        },
        onLoadSuccess: function (data) {
            var pageSize = $('#gridTmpDrugMain').datagrid('getPager').data('pagination').options
                .pageSize;
            var total = data.total;
            if (data.curPage > 0 && total > 0 && total <= pageSize) {
                $('#gridTmpDrugMain').datagrid('selectRow', 0);
                var gridSelect = $('#gridTmpDrugMain').datagrid('getSelected') || '';
                if (gridSelect) QuerygridTmpDrugDetail();
            }
        },
    };
    PHA.Grid('gridTmpDrugMain', dataGridOption);
}

function InitTmpDrugAudit() {
    var columns = [
        [
            // ProcessDesc,UserName,Date,Time
            { field: 'ProcessDesc', title: '审核状态', width: 170 },
            { field: 'UserName', title: '审核人', width: 70 },
            { field: 'Date', title: '审核日期', width: 100 },
            { field: 'Time', title: '审核时间', width: 80 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurchQuery.Query',
            QueryName: 'TDPStatusList',
            TDP: '',
        },
        fitColumns: true,
        fit: true,
        columns: columns,
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                //QuerygridTmpDrugDetail();
            }
        },
        onLoadSuccess: function (data) {},
    };
    PHA.Grid('gridTmpDrugAudit', dataGridOption);
}

function InitTmpDrugDisp() {
    var columns = [
        [
            // DispType,patName,Prescno,qty,BuomDesc,Date,Time
            { field: 'DispType', title: '发退药类型', width: 170 },
            { field: 'patName', title: '病人', width: 170 },
            { field: 'Prescno', title: '处方号', width: 170 },
            { field: 'qty', title: '发退药数量', width: 80 },
            { field: 'BuomDesc', title: '单位', width: 120 },
            { field: 'Date', title: '发退药日期', width: 100 },
            { field: 'Time', title: '发退药时间', width: 80 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurchQuery.Query',
            QueryName: 'TDPIDispList',
            TDPI: '',
        },
        columns: columns,
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
            }
        },
        onLoadSuccess: function (data) {},
    };
    PHA.Grid('gridTmpDrugDisp', dataGridOption);
}

function SaveAuth() {
    var AuthLoc = $('#cmbIngdLoc').combobox('getValue');
    var params = '',
        TDPiRowIdStr = '';
    var gridChecked = $('#gridTmpDrugDetail').datagrid('getChecked');
    var CheckedLen = gridChecked.length;
    if (CheckedLen == 0) {
        PHA.Popover({ showType: 'show', msg: '请选中需要保存的明细', type: 'alert' });
        return;
    }
    var NotAcorrdFlag = '';
    for (var i = 0; i < CheckedLen; i++) {
        var statusi = gridChecked[i].statusi;
        if (statusi != '') {
            NotAcorrdFlag = 1;
            continue;
        }
        var inci = gridChecked[i].inci;
        if (inci == '') {
            PHA.Popover({
                showType: 'show',
                msg: '您选中了未维护库存项的明细，请先维护再进行授权！',
                type: 'alert',
            });
            return;
        }
        TDPiRowIdStr =
            TDPiRowIdStr == '' ? gridChecked[i].TDPi : TDPiRowIdStr + '^' + gridChecked[i].TDPi;
    }
    if (TDPiRowIdStr == '') {
        PHA.Popover({
            showType: 'show',
            msg: '您选中了不可保存的明细，请检查明细状态',
            type: 'alert',
        });
        return;
    }

    var ret = tkMakeServerCall(
        'PHA.IN.TmpDrugPurAuth.Save',
        'TDPAuth',
        SessionHosp,
        AuthLoc,
        TDPiRowIdStr,
        SessionUser
    );
    var retArr = ret.split('^');
    if (retArr[0] == 0) {
        PHA.Popover({ showType: 'show', msg: '保存成功', type: 'success' });
    } else {
        PHA.Popover({ showType: 'show', msg: retArr[1], type: 'alert' });
    }
    QuerygridTmpDrugDetail();
}
