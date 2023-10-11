/**
 * 名称:   住院移动药房-护士药品核对
 * 编写人:  yunhaibao
 * 编写日期: 2020-03-14
 */

var PHA_IP_NURCHECK = {
    WardFlag: (session['LOGON.WARDID'] || '') != '' ? 'Y' : 'N',
    RowStyler: function (rowIndex, rowData) {
        var needDispQty = rowData.needDispQty;
        var realDispQty = rowData.realDispQty;
        if (needDispQty > realDispQty) {
            return 'background-color:#FFE0EA';
        } else if (needDispQty < realDispQty) {
            return 'background-color:#C8F6F1';
        }
    },
    USERID: ''
};

$(function () {
    InitDict();
    InitGridPhac();
    InitGridPhacInci();
    InitGridPhacPatInci();
    InitGridPhacPatInciDetail();
    $('#btnFind').on('click', QueryPhac);
    $('#btnClean').on('click', Clean);
    $('#btnPass').on('click', PassHandler);
    $('#btnPassPat').on('click', PassPatHandler);
    $('#btnChangeUser').on('click', function () {
        $('#conUserCode, #conPassWord').val('');
        $('#userDialog').dialog('open');
        $('#conUserCode').focus();
    });
    $('#conUserCode').focus();
    if (PHA_IP_NURCHECK.WardFlag === 'Y') {
        $('#btnPassPat').hide();
    }
});

function InitDict() {
    $('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('IP').url,
        panelHeight: 'auto',
        onLoadSuccess: function (data) {
            if (PHA_IP_NURCHECK.WardFlag != 'Y') {
                $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
            }
        },
        onSelect: function (data) {
            if (data){
                PHA.ComboBox('conWardLoc', {
                    url: PHA_STORE.WardLocByRecLoc("","").url+'&RecLocId='+ data.RowId
                    //width: combWidth,
                });
            }
        }
    });
    PHA.ComboBox('conWardLoc', {
        url: PHA_STORE.WardLocByRecLoc("","").url+'&RecLocId='+session['LOGON.CTLOCID'], //修改为按接收科室取病区 By zhaoxinlong 2022.04.24
        disabled: PHA_IP_NURCHECK.WardFlag === 'Y' ? true : false,
        onLoadSuccess: function (data) {
            if (PHA_IP_NURCHECK.WardFlag === 'Y') {
                $('#conWardLoc').combobox('setValue', session['LOGON.CTLOCID']);
                $('#conWardLoc').combobox('setText', App_LocDesc);
            }
        }
    });
    if (PHA_IP_NURCHECK.WardFlag === 'Y') {
        $('#conWardLoc').combobox('setValue', session['LOGON.CTLOCID']);
        $('#conWardLoc').combobox('setText', App_LocDesc);
    }
}

function InitGridPhac() {
    var columns = [
        [
            {
                field: 'phacNo',
                title: '发药单号'
                // ,
                // formatter: function(value, row, index) {
                //  return '<div style="overflow:hidden;white-space: normal;">'+value+'</div>'
                // }
            },
            {
                field: 'collectDateTime',
                title: '发药时间',
                width: 155
            },
            {
                field: 'operateUserName',
                title: '发药人',
                width: 100
            },
            {
                field: 'auditDateTime',
                title: '核对时间',
                width: 155
            },
            {
                field: 'auditUserName',
                title: '核对人',
                width: 100
            },
            {
                field: 'wardDesc',
                title: '病区'
            },
            {
                field: 'patGetDateTime',
                title: '患者领药时间',
                width: 155
            },
            {
                field: 'patGetInfo',
                title: '患者领药信息',
                width: 200
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        columns: columns,
        fitColumns: false,
        toolbar: '#gridPhacBar',
        onSelect: function (rowIndex, rowData) {
            QueryPhacInci();
        },
        onLoadSuccess: function () {
            $('#gridPhacInci').datagrid('clear');
        }
    };
    PHA.Grid('gridPhac', dataGridOption);
    $('[field="phacNo"]').css({'min-width':'150px'})
    $('[field="wardDesc"]').css({'min-width':'150px'})
}

function InitGridPhacInci() {
    var columns = [
        [
            {
                field: 'phacItmLbIDStr',
                title: '发药孙表ID串',
                width: 200,
                hidden: true
            },
            {
                field: 'inciDesc',
                title: '药品名称',
                width: 300
            },
            {
                field: 'spec',
                title: '规格',
                width: 100
            },
            {
                field: 'uomDesc',
                title: '单位',
                width: 100
            },
            {
                field: 'needDispQty',
                title: '应发数量',
                width: 100,
                align: 'right'
            },
            {
                field: 'realDispQty',
                title: '实发数量',
                width: 100,
                align: 'right'
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        columns: columns,
        fitColumns: false,
        rowStyler: PHA_IP_NURCHECK.RowStyler,
        onSelect: function (rowIndex, rowData) {
            QueryPhacPatInci();
            QueryPhacPatInciDetail();
        },
        onLoadSuccess: function (data) {
            $('#gridPhacPatInci').datagrid('clear');
            $('#gridPhacPatInciDetail').datagrid('clear');
            if (data.total > 0) {
                $('#gridPhacInci').datagrid('selectRow', 0);
            }
        }
    };
    PHA.Grid('gridPhacInci', dataGridOption);
}
function InitGridPhacPatInci() {
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
                field: 'needDispQty',
                title: '应发数量',
                width: 80,
                align: 'right'
            },
            {
                field: 'realDispQty',
                title: '实发数量',
                width: 80,
                align: 'right'
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        columns: columns,
        fitColumns: false,
        rowStyler: PHA_IP_NURCHECK.RowStyler
    };
    PHA.Grid('gridPhacPatInci', dataGridOption);
}


function InitGridPhacPatInciDetail() {
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
                field: 'doseDateTime',
                title: '用药日期',
                width: 150
            },
            {
                field: 'needDispQty',
                title: '应发数量',
                width: 80,
                align: 'right'
            },
            {
                field: 'realDispQty',
                title: '实发数量',
                width: 80,
                align: 'right'
            },
            {
                field: 'priority',
                title: '医嘱类型',
                width: 80,
                align: 'right'
            },
            {
                field: 'oeore',
                title: '执行记录Id',
                width: 100,
                align: 'right',
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        columns: columns,
        fitColumns: false,
        rowStyler: PHA_IP_NURCHECK.RowStyler
    };
    PHA.Grid('gridPhacPatInciDetail', dataGridOption);
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
    //    if (pJson.user === '') {
    //        PHA.Popover({
    //            msg: '请点击 【切换用户】，进行验证',
    //            type: 'alert'
    //        });
    //        return;
    //    }
    $('#gridPhac').datagrid('options').url = $URL;
    $('#gridPhac').datagrid('query', {
        ClassName: 'PHA.IP.NurCheck.Query',
        QueryName: 'PHACollected',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
}

/// 药品汇总
function QueryPhacInci() {
    var gridSel = $('#gridPhac').datagrid('getSelected');
    if (gridSel === null) {
        $('#gridPhacInci').datagrid('clear');
        return;
    }
    var pJson = {
        phac: gridSel.phac
    };
    $('#gridPhacInci').datagrid('options').url = $URL;
    $('#gridPhacInci').datagrid('query', {
        ClassName: 'PHA.IP.NurCheck.Query',
        QueryName: 'PHACollectedInci',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
}

/// 患者药品汇总
function QueryPhacPatInci() {
    var gridSel = $('#gridPhacInci').datagrid('getSelected') || '';
    if (gridSel === '') {
        $('#gridPhacPatInci').datagrid('clear');
        return;
    }
    var pJson = {
        phacItmLbIDStr: gridSel.phacItmLbIDStr
    };
    $('#gridPhacPatInci').datagrid('options').url = $URL;
    $('#gridPhacPatInci').datagrid('query', {
        ClassName: 'PHA.IP.NurCheck.Query',
        QueryName: 'PHACollectedPatInci',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
}

/// 患者药品明细
function QueryPhacPatInciDetail() {
    var gridSel = $('#gridPhacInci').datagrid('getSelected') || '';
    if (gridSel === '') {
        $('#gridPhacPatInciDetail').datagrid('clear');
        return;
    }
    var pJson = {
        phacItmLbIDStr: gridSel.phacItmLbIDStr
    };
    $('#gridPhacPatInciDetail').datagrid('options').url = $URL;
    $('#gridPhacPatInciDetail').datagrid('query', {
        ClassName: 'PHA.IP.NurCheck.Query',
        QueryName: 'PHACollectedPatInciDetail',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
}
// 查询条件的JSON
function GetQueryParamsJson() {
    var startDate = $('#conStartDate').datebox('getValue');
    var endDate = $('#conEndDate').datebox('getValue');
    var loc = $('#conPhaLoc').combobox('getValue');
    var auditFlag = $('#conAudit').checkbox('getValue') === true ? 'Y' : 'N';
    var user = $('#conUser').val();
    var retJson = {
        startDate: startDate,
        endDate: endDate,
        loc: loc,
        auditFlag: auditFlag,
        user: user,
        wardLoc: $('#conWardLoc').combobox('getValue') || ''
    };
    return retJson;
}

function PassHandler() {
    var gridSel = $('#gridPhac').datagrid('getSelected');
    if (gridSel === null) {
        PHA.Popover({
            msg: '请先选中需要核对的记录',
            type: 'alert'
        });
        return;
    }
    if (gridSel.auditUserName !== '') {
        PHA.Popover({
            msg: '您选中的记录已核对',
            type: 'alert'
        });
        return;
    }
    var user = PHA_IP_NURCHECK.USERID;
    if (user === '') {
        PHA.Popover({
            msg: '请点击 【选择用户】，进行验证',
            type: 'alert'
        });
        return;
    }
    var pJson = {
        phac: gridSel.phac,
        user: user
    };
    Pass(pJson);
}
function PassPat() {
    var gridSel = $('#gridPhac').datagrid('getSelected');
    var getName = $('#conGetName').val();
    var getCard = $('#conGetCard').val();
    if (getName === '') {
        $('#conGetName').focus();
        return;
    }
    if (getCard === '') {
        $('#conGetCard').focus();
        return;
    }

    var pJson = {
        phac: gridSel.phac,
        getName: getName,
        getCard: getCard,
        isPatGet: 'Y'
    };

    $('#patGetDialog').window('close');
    Pass(pJson);
}
function Pass(pJson) {
    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.Data.Api',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.IP.NurCheck.Save',
            pMethodName: 'UpdateHandler',
            pJsonStr: JSON.stringify([pJson])
        },
        false
    );
    if (retJson.success === 'N') {
        var msg = PHAIP_COM.DataApi.Msg(retJson);
        PHA.Alert('提示', msg, 'warning');
    } else {
        $('#gridPhac').datagrid('reload');
    }
}
function PassPatHandler() {
    var gridSel = $('#gridPhac').datagrid('getSelected');
    if (gridSel === null) {
        PHA.Popover({
            msg: '请先选中需要核对的记录',
            type: 'alert'
        });
        return;
    }
    if (gridSel.patGetInfo !== '') {
        PHA.Popover({
            msg: '您选中的记录已核对',
            type: 'alert'
        });
        return;
    }
    $('#patGetDialog').window('open');
    $('#conGetName,#conGetCard').val('');
}

function SetConUser() {
    var userCode = $('#conUserCode').val();
    var passWord = $('#conPassWord').val();
    var warnMsg = '';
    if (userCode === '') {
        warnMsg = '请填写工号';
    } else if (userCode === '') {
        warnMsg = '请填写密码';
    }
    if (warnMsg !== '') {
        PHA.Popover({
            msg: warnMsg,
            type: 'alert'
        });
        return;
    }

    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.NurCheck.Query',
            MethodName: 'GetUserData',
            userCode: userCode,
            passWord: passWord,
            hosp: session['LOGON.HOSPID']
        },
        false
    );

    if ((retJson.user || '') === '') {
        PHA.Popover({
            msg: retJson.msg,
            type: 'alert'
        });
    } else {
        $('#conUser').val(retJson.userCode + ' - ' + retJson.userName);
        PHA_IP_NURCHECK.USERID = retJson.user;
        $('#userDialog').window('close');
    }
}

function Clean() {
    $('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
    $('#conPhaLoc').combobox('select', (PHA_IP_NURCHECK.WardFlag || '') != 'Y' ? session['LOGON.CTLOCID'] : '');
    $('#gridPhac').datagrid('clear');
    $('#gridPhacInci').datagrid('clear');
    $('#gridPhacPatInci').datagrid('clear');
    $('#gridPhacPatInciDetail').datagrid('clear');
    $('#conUser').val('');
    $('#conUserCode,#conPassWord').text('');
    $('#conAudit').checkbox('setValue', false);
    if (PHA_IP_NURCHECK.WardFlag !== 'Y') {
        $('#conWardLoc').combobox('clear');
    }
    PHA_IP_NURCHECK.USERID = '';
}
