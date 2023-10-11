/**
 * 调价 - 批次价 - 审核
 * @creator 云海宝
 */

$(function () {
    var biz = {
        data: {
            aspbID: '',
            status: 'SAVE',
            handleStatus: '',
            defaultData: [
                {
                    startDate: PHA_UTIL.GetDate('t-7'),
                    endDate: PHA_UTIL.GetDate('t'),
                    nextStatusResult: 'UN',
                    nextStatus: ASPBEXEFLAG === 'Y' ? 'EXE' : 'AUDIT'
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
    var components = ASPB_COMPONENTS();
    var com = ASPB_COM;
    var settings = com.GetSettings();

    components('StkCatGrp', 'stkCatGrp');
    components('No', 'no');
    components('StatusResult', 'nextStatusResult', {
        onChange: function (RowId) {
            biz.setData('nextStatusResult', RowId);
        }
    });
    components('Date', 'startDate');
    components('Date', 'endDate');
    components('FilterField', 'filterField');
    components('AspbGrid', 'gridAspb', {
        toolbar: '#gridAspbBar',
        singleSelect: false,
        onClickCell: function (index, field, value) {
            return;
        }
    },
    {
	    deleteField: (ASPBEXEFLAG === 'Y') ? [] : ['executeDate', 'executeTime', 'executeUserName']
    }
    );
    
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        $('#gridAspb').datagrid('clear');
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
        ASPB_COM.QueryAspbGrid('gridAspb', qJson);
    });
    
    /* 如果是统一价。则不允许使用批次调价生效界面 */
    if ((settings.Com.RpRule != 3) && (ASPBEXEFLAG === 'Y')){
	    components('Pop', '定价规则为非批次价情况下，禁止使用批次价调价生效界面');
    }
     

    function Audit() {
        var apiMethod = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (apiMethod === '') {
            return;
        }
        var rows = [];
        for (const it of $('#gridAspb').datagrid('getChecked')) {
            rows.push(
                com.AppendLogonData({
                    aspbID: it.aspbID
                })
            );
        }
        if (rows.length === 0) {
            components('Pop', '请先勾选数据, 再进行操作');
            return;
        }

        PHA.BizPrompt({ title: '提醒' }, function (promptRet) {
            if (promptRet !== undefined) {
                var data4save = {
                    main: {
                        statusCode: biz.getData('handleStatus'),
                        statusReason: promptRet
                    },
                    rows: rows
                };
                PHA.Loading('Show');
                com.Invoke(apiMethod, data4save, function (retData) {
                    PHA.Loading('Hide');
                    if (typeof retData === 'string') {
                        PHA.Alert('', retData, 'warning');
                    } else {
                        if (retData.failureCnt === 0) {
                            // 多行保存, 部分成功的处理
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
                hide: ASPBEXEFLAG === 'Y'
            },
            '#btnAuditCancel': {
                disabled: biz.getData('nextStatusResult') === 'UN',
                hide: ASPBEXEFLAG === 'Y'
            },
            '#btnExecute': {
                hide: (ASPBEXEFLAG !== 'Y') || (settings.Com.RpRule != 3),
                disabled: biz.getData('nextStatusResult') === 'PASS'
            }
        });
    }

    function GetAspbStatus() {
        return ASPBEXEFLAG === 'Y' ? 'Audit' : 'No';
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    setTimeout(function () {
        $.extend(biz.getData('defaultData')[0], settings.DefaultData || {});
        SetDefaults();
        com.SetPage('pha.in.v3.aspb.audit.csp');
        // @automatic
        // $('#btnFind').click();
    }, 0);
});

