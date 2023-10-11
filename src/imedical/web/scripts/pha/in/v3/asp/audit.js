/**
 * ���� - ͳһ�� - ���
 * @creator �ƺ���
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
                    // $('#btnFind').trigger('click-i'); // ���¼���������ʱ��������������ǲ�������Ϊ�ղ��ܲ�ѯ
                    break;
                default:
                    break;
            }
        }
    };

    /**
     * ��ʼ��
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
                        ele.Description = '����Ч';
                    }
                    if (ele.RowId === 'PASS') {
                        ele.Description = '����Ч';
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
        // qJson.aspStatus = GetAspStatus(); // û��
        qJson.nextStatus = biz.getData('defaultData')[0].nextStatus;
        ASP_COM.QueryAspGrid('gridAsp', qJson);
    });
    
    
    /* �����ͳһ�ۡ�������ʹ�����ε�����Ч���� */
    if ((settings.Com.RpRule == 3) && (ASPEXEFLAG === 'Y')){
	    components('Pop', '���۹���Ϊ���μ�����£�ͳһ������Ч�ὫҩƷ����������ȫ��һ����ۣ������ʹ�ã�');
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
            components('Pop', '���ȹ�ѡ����, �ٽ��в���');
            return;
        }

        PHA.BizPrompt({ title: '����' }, function (promptRet) {
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
                            components('Pop', '����ɹ�', 'success');
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

