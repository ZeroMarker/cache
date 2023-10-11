/**
 * 采购计划 - 审核
 * @creator     云海宝
 */
$(function () {
    var biz = {
        data: {
            loaded: false,
            status: 'SAVE',
            handleStatus: '',
            defaultData: [
                {
                    startDate: 't',
                    endDate: 't',
                    loc: session['LOGON.CTLOCID'],
                    nextStatusResult: 'SHOULD'
                }
            ]
        },
        getData: function (key) {
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;
        }
    };
    var components = PLAN_COMPONENTS();
    var com = PLAN_COM;
    var settings = com.GetSettings();

    components('Date', 'startDate');
    components('Date', 'endDate');
    components('Loc', 'loc');
    components('No', 'no');
    components('NextStatus', 'nextStatus', {
        onLoadSuccess: function (data) {
            if (data.length > 0) {
                $(this).combobox('setValue', data[0].RowId);
            }
        },
        onChange: function (oldData, newData) {
            $.data($(this)[0], 'find', true);
        },
        onHidePanel: function (ee) {
            if ($.data($(this)[0], 'find') == true) {
                $('#btnFind').trigger('click-i');
            }
            $.data($(this)[0], 'find', false);
        }
    });
    components('Vendor', 'vendor');
    components('StatusResult', 'nextStatusResult', {
        onChange: function (oldData, newData) {
            $.data($(this)[0], 'find', true);
        },
        onHidePanel: function (e) {
            if ($.data($(this)[0], 'find') == true) {
                $('#btnFind').trigger('click-i');
            }
            $.data($(this)[0], 'find', false);
        }
    });
    components('MainGrid', 'gridMain', {
        toolbar: '#gridMainBar',
        onSelect: function () {
            var pJson = com.Condition('#qCondition', 'get');
            pJson.planID = com.GetSelectedRow('#gridMain', 'planID');
            com.QueryItmGrid('gridItm', pJson);
        },
        onLoadSuccess: function (data) {
            com.ValidateGridData(data);
            $('#gridItm').datagrid('clear');
        }
    });
    var rebuildColumns = PHA_COM.RebuildColumns(components('ItmGridColmuns', 'gridItm'), {
        hiddenFields: ['gCheck']
    });
    components('ItmGrid', 'gridItm', {
        onClickCell: function (index, field, value) {},
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns
    });
    components('FilterField', 'filterField');

    PHA_EVENT.Bind('#btnFind', 'click', function () {
        com.QueryMainGrid('gridMain', com.Condition('#qCondition', 'get'));
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        $('#gridMain').datagrid('clear');
        $('#gridItm').datagrid('clear');
        SetDefaults();
    });
    PHA_EVENT.Bind('#btnAudit', 'click', function () {
        biz.setData('handleStatus', 'Audit');
        Audit();
    });
    PHA_EVENT.Bind('#btnAuditCancel', 'click', function () {
        biz.setData('handleStatus', 'AuditCancel');
        Audit();
    });
    PHA_EVENT.Bind('#btnAuditRefuse', 'click', function () {
        biz.setData('handleStatus', 'AuditRefuse');
        Audit();
    });
    PHA_EVENT.Bind('#btnPrint', 'click', function () {
        com.Print(com.GetSelectedRow('#gridMain', 'planID'));
    });
    function Audit() {
        var apiMethod = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (apiMethod === '') {
            return;
        }
        var planID = com.GetSelectedRow('#gridMain', 'planID');
        if (planID === '') {
            components('Pop', '请先选择需要操作的记录');
            return;
        }
        var statusCode = $('#nextStatus').combobox('getValue') || '';
        if (statusCode === '') {
            components('Pop', '请先选择预执行状态');
            return;
        }
        PHA.BizPrompt({ title: '提醒' }, function (promptRet) {
            if (promptRet !== undefined) {
                var data4save = {
                    planID: planID,
                    statusReason: promptRet,
                    statusCode: statusCode
                };
                PHA.Loading('Show');
                com.Invoke(apiMethod, data4save, function (retData) {
                    PHA.Loading('Hide');
                    if (typeof retData === 'string') {
                        PHA.Alert('', retData, 'warning');
                    } else {
                        if (!PHA_COM.SelectAfterDeleteRow('#gridMain') >= 0) {
                            $('#gridItm').datagrid('clear');
                        }
                        components('Pop', '操作成功', 'success');
                    }
                });
            }
        });
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
        $('#nextStatus').combobox('reload');
    }
    setTimeout(function () {
        $.extend(biz.getData('defaultData')[0], settings.DefaultData);
        SetDefaults();
        com.SetPage('pha.in.v3.plan.audit.csp');
    }, 0);
});

