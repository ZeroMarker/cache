/**
 * 名称:	 住院移动药房-物流箱查询
 * 编写人:	 yunhaibao
 * 编写日期: 2020-03-14
 */

var PHA_IP_DISPCHECK = {
    WardFlag: (session['LOGON.WARDID'] || '') !== '' ? 'Y' : 'N',
    RowStyler: function (rowIndex, rowData) {
        var needDispQty = rowData.needDispQty;
        var realDispQty = rowData.realDispQty;
        if (needDispQty > realDispQty) {
            return 'background-color:#FFE0EA';
        } else if (needDispQty < realDispQty) {
            return 'background-color:#C8F6F1';
        }
    }
};

$(function () {
    InitDict();
    InitGridPhac();
    InitGridPhacInci();
    InitGridPhacOrder();
    $('#btnFind').on('click', QueryPhac);
    $('#btnClean').on('click', CleanHandler);
    $('#btnPass').on('click', PassHandler);
    $('#btnSend').on('click', Send);
    $('#conUser').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            SetConUser();
        }
    });
    $('#conPhacNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            QueryPhac();
            FocusAndSelect('#conPhacNo');
        }
    });
    hotkeys('f1', function (e, h) {
        $('#conPhacNo').val('');
        $('#conPhacNo').focus();
        // e.stopPropagation();
        e.preventDefault();
    });
    $('.tabs-panels .datagrid-pager table').hide();
});

function InitDict() {
    $('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
    $('#conStartTime').timespinner('setValue', '00:00:00');
    $('#conEndTime').timespinner('setValue', '23:59:59');
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('IP').url,
        panelHeight: 'auto',
        onLoadSuccess: function (data) {
            if (PHA_IP_DISPCHECK.WardFlag != 'Y') {
                $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
            }
        },
        onSelect: function (data) {
            PHA.ComboBox('conDrugCat', {
                url: PHAIP_STORE.StkDrugGroup().url + '&loc=' + data.RowId,
                panelHeight: 'auto'
            });
        }
    });
    PHA.ComboBox('conWardLoc', {
        url: PHA_STORE.WardLoc().url
    });
}

function InitGridPhac() {
    var columns = [
        [
            {
                field: 'phac',
                title: 'phac',
                width: 50,
                hidden: true
            },
            {
                field: 'select',
                checkbox: true
            },
            {
                field: 'phacNo',
                title: '发药单号',
                width: 200
                // ,
                // formatter: function(value, row, index) {
                // 	return '<div style="overflow:hidden;white-space: normal;">'+value+'</div>'
                // }
            },
            {
                field: 'wardDesc',
                title: '病区',
                width: 150
            },
            {
                field: 'printDateTime',
                title: '打印时间',
                width: 155
            },
            {
                field: 'printUserName',
                title: '打印人',
                width: 100
            },
            {
                field: 'operDateTime',
                title: '配药确认时间',
                width: 155
            },
            {
                field: 'operUserName',
                title: '配药确认人',
                width: 100
            },
            {
                field: 'collectDateTime',
                title: '发药确认时间',
                width: 155
            },
            {
                field: 'collectUserName',
                title: '发药确认人',
                width: 100
            },
            {
                field: 'statusDesc',
                title: '当前状态',
                width: 100,
                styler: function (value, row, index) {
                    if (value == '已打印') {
                        return 'font-weight:bold;';
                    } else if (value == '已配药确认') {
                        return 'background-color:#e3f7ff;color:#1278b8;font-weight:bold;';
                    } else if (value == '已发药确认') {
                        return 'background-color:#e2ffde;color:#3c763d;font-weight:bold;';
                    }
                    return '';
                }
            }
        ]
    ];
    var dataGridOption = {
        exportXls: false,
        url: '',
        pagination: true,
        columns: columns,
        fitColumns: false,
        toolbar: '#gridPhacBar',
        singleSelect: false,
        onCheck: function (rowIndex, rowData) {
            QueryPhacDetail();
        },
        onUncheck: function (rowIndex, rowData) {
            QueryPhacDetail();
        },
        onCheckAll: function () {
            QueryPhacDetail();
        },
        onUncheckAll: function () {
            QueryPhacDetail();
        },
        onLoadSuccess: function (data) {
            $(this).datagrid('uncheckAll');
            if (data.rows.length === 1) {
                $(this).datagrid('checkRow', 0);
            } else {
                $('#gridPhacInci').datagrid('clear');
                $('#gridPhacOrder').datagrid('clear');
            }
            if (data.rows.length < 2) {
                FocusAndSelect('#conPhacNo');
            }
        }
    };
    PHA.Grid('gridPhac', dataGridOption);
}

function InitGridPhacInci() {
    var columns = [
        [
            {
                field: 'inciDesc',
                title: '药品名称',
                width: 300
            },
            {
                field: 'manfDesc',
                title: '生产企业',
                width: 135
            },
            {
                field: 'realQty',
                title: '实发数量',
                width: 70,
                align: 'right'
            },
            {
                field: 'dispQty',
                title: '医嘱数量',
                width: 70,
                align: 'right'
            },
            {
                field: 'resQty',
                title: '冲减数量',
                width: 70,
                align: 'right'
            },
            {
                field: 'uomDesc',
                title: '单位',
                width: 70
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: true,
        columns: columns,
        fitColumns: false,
        rowStyler: PHA_IP_DISPCHECK.RowStyler,
        onSelect: function (rowIndex, rowData) {},
        onLoadSuccess: function (data) {}
    };
    PHA.Grid('gridPhacInci', dataGridOption);
}
function InitGridPhacOrder() {
    var columns = [
        [
            {
                field: 'bedNo',
                title: '床号',
                width: 100
            },
            {
                field: 'patNo',
                title: '登记号',
                width: 100
            },
            {
                field: 'patName',
                title: '姓名',
                width: 100
            },
            {
                field: 'doseDate',
                title: '用药日期',
                width: 100
            },
            {
                field: 'inciDesc',
                title: '药品名称',
                width: 300
            },
            {
                field: 'manfDesc',
                title: '生产企业',
                width: 135
            },
            {
                field: 'realQty',
                title: '实发数量',
                width: 70,
                align: 'right'
            },
            {
                field: 'dispQty',
                title: '医嘱数量',
                width: 70,
                align: 'right'
            },
            {
                field: 'resQty',
                title: '冲减数量',
                width: 70,
                align: 'right'
            },
            {
                field: 'uomDesc',
                title: '单位',
                width: 70
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: true,
        columns: columns,
        fitColumns: false,
        rowStyler: PHA_IP_DISPCHECK.RowStyler
    };
    PHA.Grid('gridPhacOrder', dataGridOption);
}

function QueryPhac() {
    var pJson = GetQueryParamsJson();
    if (pJson.loc === '') {
        PHA.Popover({
            msg: '请选择药房',
            type: 'alert'
        });
        return;
    }
    // if (pJson.user === '') {
    //     PHA.Popover({
    //         msg: '请先输入工号确认身份',
    //         type: 'alert'
    //     });
    //     return;
    // }
    $('#gridPhac').datagrid('options').url = $URL;
    $('#gridPhac').datagrid('query', {
        ClassName: 'PHA.IP.DispCheck.Query',
        QueryName: 'PHACollected',
        pJsonStr: JSON.stringify(pJson)
    });
}
function QueryPhacDetail() {
    var gridChk = $('#gridPhac').datagrid('getChecked');
    var phacArr = [];
    for (var i = 0; i < gridChk.length; i++) {
        var phac = gridChk[i].phac;
        phacArr.push(phac);
    }
    var pJson = {
        phacStr: phacArr.join('^')
    };
    $('#gridPhacInci').datagrid('options').url = $URL;
    $('#gridPhacInci').datagrid('query', {
        ClassName: 'PHA.IP.DispCheck.Query',
        QueryName: 'PHACollectedInci',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
    $('#gridPhacOrder').datagrid('options').url = $URL;
    $('#gridPhacOrder').datagrid('query', {
        ClassName: 'PHA.IP.DispCheck.Query',
        QueryName: 'PHACollectedOrder',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
}

// 查询条件的JSON
function GetQueryParamsJson() {
    return {
        startDate: $('#conStartDate').datebox('getValue'),
        endDate: $('#conEndDate').datebox('getValue'),
        startTime: $('#conStartTime').timespinner('getValue'),
        endTime: $('#conEndTime').timespinner('getValue'),
        loc: $('#conPhaLoc').combobox('getValue'),
        user: $('#conUser').val(),
        wardLoc: $('#conWardLoc').combobox('getValue'),
        phacNo: $('#conPhacNo').val(),
        drugCat: $('#conDrugCat').combobox('getValue'),
        checkType: CHECKTYPE,
        checked: $('#conChecked').checkbox('getValue') === true ? 'Y' : 'N',
        unCheck: $('#conUnCheck').checkbox('getValue') === true ? 'Y' : 'N'
    };
}

function PassHandler() {
    var gridChk = $('#gridPhac').datagrid('getChecked');
    if (gridChk.length === 0) {
        PHA.Popover({
            msg: '请先勾选需要确认的记录',
            type: 'alert'
        });
        return;
    }
    PHA.Confirm('提示', '您确认进行' + CHECKTYPEDESC + '吗?', function () {
        Pass();
    });
}
function Pass() {
    var gridChk = $('#gridPhac').datagrid('getChecked');
    var pJson = [];
    for (var i = 0; i < gridChk.length; i++) {
        var statusDesc = gridChk[i].statusDesc;
        //        if (statusDesc.indexOf('发药') >= 0) {
        //            continue;
        //        }
        var phac = gridChk[i].phac;
        pJson.push({
            phac: phac,
            user: session['LOGON.USERID'],
            checkType: CHECKTYPE
        });
    }
    if (pJson.length === 0) {
        PHA.Popover({
            msg: '请先勾选需要确认的记录',
            type: 'alert'
        });
        return;
    }
    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.Data.Api',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.IP.DispCheck.Save',
            pMethodName: 'UpdateHandler',
            pJsonStr: JSON.stringify(pJson)
        },
        false
    );
    if (retJson.success === 'N') {
        var msg = PHAIP_COM.DataApi.Msg(retJson);
        PHA.Alert('提示', msg, 'warning');
    }
    $('#gridPhac').datagrid('reload');
}

function SetConUser() {
    var userCode = $('#conUser').val();
    if (userCode === '') {
        $('#conUserName,#conUserLoc').text('');
        return;
    }

    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.COM.Method',
            MethodName: 'GetUserDataByCode',
            userCode: userCode
        },
        false
    );
    var userName = retJson.userName || '';
    $('#conUserName').text(userName);
    $('#conUserLoc').text(retJson.userLocDesc || '');
    if (userName === '') {
        PHA.Popover({
            msg: '您的工号有误,请核实并重新输入',
            type: 'alert'
        });
    }
}

function Send() {
    return;
    var gridSel = $('#gridPhac').datagrid('getSelected');
    if (gridSel === null) {
        PHA.Popover({
            msg: '请先选中需要发送的的记录',
            type: 'alert'
        });
        return;
    }
    PHA.Confirm('提示', '您确认重新发送数据到包药机吗?', function () {
        PHA.Alert('提示', '自己调吧,哈哈', 'warning');
    });
}

function CleanHandler() {
    $('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
    $('#conStartTime').timespinner('setValue', '00:00:00');
    $('#conEndTime').timespinner('setValue', '23:59:59');
    if (PHA_IP_DISPCHECK.WardFlag != 'Y') {
        $('#conPhaLoc').combobox('selectDefault', session['LOGON.CTLOCID']);
    }
    $('#conWardLoc').combobox('clear');
    $('#conPhacNo').val('');
    $('#conDrugCat').combobox('clear');
    $('#gridPhac').datagrid('clear');
    $('#conChecked').checkbox('setValue', false);
    $('#conUnCheck').checkbox('setValue', true);
}

function FocusAndSelect(target) {
    if ($(target).val() === '') {
        return;
    }
    $(target).focus();
    $(target).select();
}
