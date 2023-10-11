/**
 * 调价 - 统一价 - 审核
 * @creator 云海宝
 */

$(function () {
    var biz = {
        data: {
            aspID: '',
            handleStatus: '',
            defaultData: [
                {
                    startDate: PHA_UTIL.GetDate('t-7'),
                    endDate: PHA_UTIL.GetDate('t'),
                    nextStatusResult: 'UN',
                    nextStatus: ASPEXEFLAG === 'Y' ? 'EXE' : 'AUDIT'
                }
            ]
        },
        getData: function (key) {
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;
            switch (key) {
                case 'nextStatusResult':
                    ControlOperation();
                    // $('#btnFind').trigger('click-i'); // 此事件会在清屏时触发。但是清空是部分条件为空不能查询
                    break;
                default:
                    break;
            }
        }
    };

    /**
     * 初始化
     */
    var components = ASP_COMPONENTS();
    var com = ASP_COM;
    var settings = com.GetSettings();

    components('StkCatGrp', 'stkCatGrp');
    components('No', 'no');
    components('StatusResult', 'nextStatusResult', {
        onChange: function (RowId) {
            biz.setData('nextStatusResult', RowId);
        },
        loadFilter: function (rows) {
            if (ASPEXEFLAG === 'Y') {
                rows.forEach(function (ele) {
                    if (ele.RowId === 'UN') {
                        ele.Description = '待生效';
                    }
                    if (ele.RowId === 'PASS') {
                        ele.Description = '已生效';
                    }
                });
            }
            return rows;
        }
    });
    components('Date', 'startDate');
    components('Date', 'endDate');
    components('FilterField', 'filterField');
    // debugger
    // var rebuildColumns = PHA_COM.RebuildColumns(components('AspGridColmuns', 'gridAsp'), {
    //     frozenFields: ['gCheck', 'inciCode', 'inci', 'uom'],
    //     fields: ['priUomRp','priUomSp','retUomRp', 'retUomSp', 'marginVal', 'diffPrice', 'maxSp','reason', 'remark']
    // });
    components('AspGrid', 'gridAsp', {
        toolbar: '#gridAspBar',
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        onClickCell: function (index, field, value) {
            return;
        },
        // columns: rebuildColumns.columns,
        // frozenColumns: rebuildColumns.frozenColumns,
        onCheck: function () {},
        onUncheck: function () {},
        onUncheckAll: function () {},
        onCheckAll: function () {}
    },
    {
	    deleteField: (ASPEXEFLAG === 'Y') ? [] : ['executeDate', 'executeTime', 'executeUserName']
    });

    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        $('#gridAsp').datagrid('clear');
        SetDefaults();
        ControlOperation();
    });
    PHA_EVENT.Bind('#btnAudit', 'click', function () {
        biz.setData('handleStatus', 'Audit');
        Audit();
    });
    PHA_EVENT.Bind('#btnAuditCancel', 'click', function () {
        biz.setData('handleStatus', 'AuditCancel');
        Audit();
    });
    PHA_EVENT.Bind('#btnExecute', 'click', function () {
        biz.setData('handleStatus', 'Execute');
        Audit();
    });

    PHA_EVENT.Bind('#btnFind', 'click', function () {
        var qJson = com.Condition('#qCondition', 'get');
        // qJson.aspStatus = GetAspStatus(); // 没用
        qJson.nextStatus = biz.getData('defaultData')[0].nextStatus;
        ASP_COM.QueryAspGrid('gridAsp', qJson);
    });
    
    
    /* 如果是统一价。则不允许使用批次调价生效界面 */
    if ((settings.Com.RpRule == 3) && (ASPEXEFLAG === 'Y')){
	    components('Pop', '定价规则为批次价情况下，统一调价生效会将药品下所有批次全部一起调价，请谨慎使用！');
    }

    function Audit() {
        var apiMethod = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (apiMethod === '') {
            return;
        }
        var rows = [];
        for (const it of $('#gridAsp').datagrid('getChecked')) {
            rows.push(
                com.AppendLogonData({
                    aspID: it.aspID
                })
            );
        }
        if (rows.length === 0) {
            components('Pop', '请先勾选数据, 再进行操作');
            return;
        }

        PHA.BizPrompt({ title: '提醒' }, function (promptRet) {
            if (promptRet !== undefined) {
                var data4audit = {
                    main: {
                        statusCode: biz.getData('handleStatus'),
                        statusReason: promptRet
                    },
                    rows: rows
                };
                PHA.Loading('Show');
                ASP_COM.Invoke(apiMethod, data4audit, function (retData) {
                    PHA.Loading('Hide');
                    if (typeof retData === 'string') {
                        PHA.Alert('', retData, 'warning');
                    } else {
                        if (retData.failureCnt === 0) {
                            components('Pop', '处理成功', 'success');
                        } else {
                            PHA.DataAlert(retData, 'warning');
                        }
                        $('#btnFind').trigger('click-i');
                    }
                });
            }
        });
    }

    function ControlOperation() {
        com.ControlOperation({
            '#btnAudit': {
                disabled: biz.getData('nextStatusResult') === 'PASS',
                hide: ASPEXEFLAG === 'Y'
            },
            '#btnAuditCancel': {
                disabled: biz.getData('nextStatusResult') === 'UN',
                hide: ASPEXEFLAG === 'Y'
            },
            '#btnExecute': {
                hide: ASPEXEFLAG !== 'Y',
                disabled: biz.getData('nextStatusResult') === 'PASS'
            }
        });
    }

    function GetAspStatus() {
        return ASPEXEFLAG === 'Y' ? 'Audit' : 'No';
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    setTimeout(function () {
        $.extend(biz.getData('defaultData')[0], settings.DefaultValues || {});
        SetDefaults();
        com.SetPage('pha.in.v3.asp.audit.csp');
    }, 0);
});

