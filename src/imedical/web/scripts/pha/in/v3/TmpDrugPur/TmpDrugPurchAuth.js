/**
 * 模块:     临购药品授权
 * 编写日期: 2020-09-18
 * 编写人:   yangsj
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionHosp = session['LOGON.HOSPID'];
var SessionGroup = session['LOGON.GROUPID'];
$(function () {
    InitGridDict();
    InitDict();
    InitGrid();
    InitBtnEvent();
    CheckTmpCycle();
});

function CheckTmpCycle() {
    var Params = '^^^' + SessionHosp;
    var TmpCycleFlag = tkMakeServerCall(
        'PHA.IN.TmpDrugPurAuth.Query',
        'CheckTmpDrugAndCycle',
        SessionHosp,
        "",
        ""
    );
    if (TmpCycleFlag != 'Y') {
        PHA.Popover({
            showType: 'show',
            msg: '临购药品闭环配置未开启，不能使用授权功能!',
            type: 'alert',
        });
        $('#btnAuth').addClass('l-btn-disabled');
        $('#btnAuth').css('pointer-events', 'none');
        $('#btnAuthMian').addClass('l-btn-disabled');
        $('#btnAuthMian').css('pointer-events', 'none');
        return;
    }
}

function InitBtnEvent() {
    $('#btnAuth').on('click', SaveAuth);
    $('#btnAuthMian').on('click', SaveAuthByMian);

    $('#btnFind').on('click', QuerygridTmpDrugMain);
    $('#btnClear').on('click', ClearDetail);
}

function ClearDetail() {
    $('#gridTmpDrugDetail').datagrid('clear');
}

function QuerygridTmpDrugMain() {
	ClearDetail();
    $('#gridTmpDrugMain').datagrid('query', {
        StDate: $('#dateStart').datebox('getValue'),
        EdDate: $('#dateEnd').datebox('getValue'),
        HospId: SessionHosp,
        AuthStatus: $('#cmbAuthStatus').combobox('getValue'),
    });
}

function QuerygridTmpDrugDetail() {
    var TDPRowIdStr = '';
    var gridChecked = $('#gridTmpDrugMain').datagrid('getChecked');
    for (var i = 0; i < gridChecked.length; i++) {
        TDPRowIdStr =
            TDPRowIdStr == '' ? gridChecked[i].TDP : TDPRowIdStr + '^' + gridChecked[i].TDP;
    }
    if (TDPRowIdStr == '') return;
    $('#gridTmpDrugDetail').datagrid('query', {
        TDPRowIdStr: TDPRowIdStr,
        IngdRecStatus: '',
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
    //授权状态
    $('#cmbAuthStatus').combobox('setValue', '未授权');
}

function InitGridDict() {
    // 授权状态
    PHA.ComboBox('cmbAuthStatus', {
        url: PHA_STORE.TmpDurgAuthStatus().url,
    });

    // 授权药房
    PHA.ComboBox('cmbIngdLoc', {
        url: PHA_STORE.Pharmacy('').url,
    });

    // 授权药房
    PHA.ComboBox('cmbIngdLocMain', {
        url: PHA_STORE.Pharmacy('').url,
    });

    
}

function InitGrid() {
    InitTmpDrugDetail();
    InitTmpDrugMian();
}

function InitTmpDrugDetail() {
    var columns = [
        [
            // TDPi,inci,inciDesc,tmpDesc,spec,qty,uom,uomDesc,manf,manfDesc
            { field: 'gridDetailSelect', checkbox: true },

            { field: 'TDPi', title: 'TDPi', hidden: true },
            { field: 'scgDesc', title: '类组', align: 'center', width: 55 },
            {
                field: 'statusi',
                title: '明细状态',
                align: 'center',
                width: 80,
                //formatter: Statuiformatter,
                styler:StatuiStyler,
            },

            {
                field: 'inciDesc',
                title: $g('药品名称<font color ="green">(已维护)</font>'),
                width: 300,
            },
            {
                field: 'tmpDesc',
                title: $g('药品名称<font color ="red">(未维护)</font>'),
                width: 232,
                sortable: 'true',
            },
            {
                field: 'spec',
                title: '规格',
                width: 100,
            },
            { field: 'qty', title: '申请数量', align: 'right', width: 70 },
            { field: 'RecQty', title: '入库数量', align: 'right', width: 70 },
            { field: 'useQty', title: '已用数量', align: 'right', width: 70 },
            { field: 'uomDesc', title: '单位', align: 'center', width: 80 },
            { field: 'manfDesc', title: '生产企业', width: 225 },
            { field: 'scg', title: '类组ID', width: 225, hidden: true },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        singleSelect: false,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurAuth.Query',
            QueryName: 'SelectTmpDrug',
            TDPRowIdStr: '',
            AuthStatus: '',
        },
        gridSave: false,
        columns: columns,
        toolbar: '#gridTmpDrugDetailBar',
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'configCode',
                });
            }
        },
    };
    PHA.Grid('gridTmpDrugDetail', dataGridOption);
}

function Statuiformatter(value, rowData, rowIndex) {
    var statusi = rowData.statusi;
    if (statusi == '入库保存') return "<div style='background-color:yellow;'>" + statusi + '</div>';
    else if (statusi == '未入库')
        return "<div style='background-color:yellow;'>" + statusi + '</div>';
    else if (statusi == '已授权')
        return "<div style='background-color:red;color:white'>" + statusi + '</div>';
}

function StatuiStyler(value, row, index)
{
     switch (value) {
         case '已授权':
             colorStyle = 'background:#ee4f38;color:white;';
             break;
         default:
             colorStyle = 'background:white;color:black;';
             break;
     }
     return colorStyle;
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
            { field: 'gridMainSelect', checkbox: true },
            //TDP,TDPNo,Date,Time,Creator,CreatorName,Type,TypeDese,TypeValue,TypeValueDesc,lastStateId,lastStateDesc
            { field: 'TDP', title: 'TDP', width: 225, hidden: true },
            { field: 'TDPNo', title: '单号', width: 170 },
            { field: 'CreatorName', title: '建单人', width: 70 },
            { field: 'Date', title: '建单日期', width: 100 },
            { field: 'Time', title: '建单时间', width: 80 },
            { field: 'TypeDese', title: '使用类型', width: 80 },
            { field: 'TypeValueDesc', title: '使用类型值', width: 150 },
            { field: 'lastStateDesc', title: '审核状态', width: 100 },
            { field: 'IngdStatus', title: '入库状态', width: 200 },
            { field: 'AuthStatus', title: '授权状态', width: 100 },
        ],
    ];
    var dataGridOption = {
        url: $URL,
        singleSelect: false,
        queryParams: {
            ClassName: 'PHA.IN.TmpDrugPurAuth.Query',
            QueryName: 'QueryTmpDrug',
            StDate: $('#dateStart').datebox('getValue'),
            EdDate: $('#dateEnd').datebox('getValue'),
            HospId: '',
            Status: '',
        },
        columns: columns,
        toolbar: '#gridTmpDrugMainBar',
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                //QuerygridTmpDrugDetail();
            }
        },
        onLoadSuccess: function (data) {},
        onCheck: function (rowIndex, rowData) {
            QuerygridTmpDrugDetail();
        },
        onUncheck: function (rowIndex, rowData) {
            QuerygridTmpDrugDetail();
        },
        onCheckAll: function () {
            QuerygridTmpDrugDetail();
        },
    };
    PHA.Grid('gridTmpDrugMain', dataGridOption);
}

function SaveAuth() {
    var AuthLoc = $('#cmbIngdLoc').combobox('getValue');
    var params = '',
        TDPiRowIdStr = '';
    var gridChecked = $('#gridTmpDrugDetail').datagrid('getChecked');
    var CheckedLen = gridChecked.length;
    if (CheckedLen == 0) {
        PHA.Popover({ showType: 'show', msg: '请选中需要授权的明细', type: 'alert' });
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
            msg: '您选中了不可授权的明细，请检查明细状态',
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
        PHA.Popover({ showType: 'show', msg: '授权成功', type: 'success' });
        QuerygridTmpDrugMain();
    } else {
        PHA.Popover({ showType: 'show', msg: retArr[1], type: 'alert' });
    }
    
}

function SaveAuthByMian() {
    var AuthLoc = $('#cmbIngdLocMain').combobox('getValue');
    var TDPRowIdStr = '';
    var gridChecked = $('#gridTmpDrugMain').datagrid('getChecked');
    for (var i = 0; i < gridChecked.length; i++) {
        TDPRowIdStr =
            TDPRowIdStr == '' ? gridChecked[i].TDP : TDPRowIdStr + '^' + gridChecked[i].TDP;
    }
    if (TDPRowIdStr == '') {
        PHA.Popover({ showType: 'show', msg: '请选择一张申请单', type: 'alert' });
        return;
    }
    var ret = tkMakeServerCall(
        'PHA.IN.TmpDrugPurAuth.Save',
        'TDPAuthByMian',
        SessionHosp,
        AuthLoc,
        TDPRowIdStr,
        SessionUser
    );
    var retArr = ret.split('^');
    if (retArr[0] == 0) {
        PHA.Popover({ showType: 'show', msg: '授权成功', type: 'success' });
    } else {
        PHA.Popover({ showType: 'show', msg: retArr[1], type: 'alert' });
    }
    QuerygridTmpDrugMain();
    ClearDetail();
}
