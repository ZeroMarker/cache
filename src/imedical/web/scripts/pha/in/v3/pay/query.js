/**
 * 付款管理 - 查询
 * @creator 云海宝
 */

$(function () {
    var biz = {
        data: {
            status: '',
            handleStatus: '',
            defaultData: [
                {
                    'startDate-q': PHA_UTIL.GetDate('t'),
                    'endDate-q': PHA_UTIL.GetDate('t'),
                    'loc-q': session['LOGON.CTLOCID']
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
    var components = PAY_COMPONENTS();
    var com = PAY_COM;
    var settings = com.GetSettings();

    components('Loc', 'loc-q');
    components('No', 'no-q');
    components('Date', 'startDate-q');
    components('Date', 'endDate-q');
    components('Vendor', 'vendor-q');
    components('Status', 'status-q');
    components('AuditStatus', 'auditStatus-q');

    components('FilterField', 'filterField-q');
    components('MainGrid', 'gridMain-q', {
        toolbar: '#gridMain-qBar',
        onClickRow: function () {
            var pJson = com.Condition('#qCondition-q', 'get');
            pJson.payID = com.GetSelectedRow('#gridMain-q', 'payID');
            com.QueryItmGrid('gridItm-q', pJson);
        },
        onDblClickRow: function () {
            if ($('.pha-pay-query-control').css('display') !== 'none') {
                $('#btnRetOk-q').click();
            }
        },
        onLoadSuccess: function (data) {
            $('#gridItm-q').datagrid('clear');
        }
    });
    var rebuildColumns = PHA_COM.RebuildColumns(components('ItmGridColmuns', 'gridItm-q'), {
        hiddenFields: ['gCheck']
    });
    components('ItmGrid', 'gridItm-q', {
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns
    });

    /**
     * 注册事件
     */
    PHA_EVENT.Bind('#btnFind-q', 'click', function () {
        com.QueryMainGrid('gridMain-q', com.Condition('#qCondition-q', 'get'));
    });
    PHA_EVENT.Bind('#btnClean-q', 'click', function () {
        com.Condition('#qCondition-q', 'clear');
        $('#gridMain-q').datagrid('clear');
        SetDefaults()
    });
    PHA_EVENT.Bind('#btnRetClose-q', 'click', function () {
        $('#winQueryPay').window('close');
    });
    PHA_EVENT.Bind('#btnRetOk-q', 'click', function () {
        PHA_IN_PAY_ID = com.GetSelectedRow('#gridMain-q', 'payID');
        $('#btnRetClose-q').click();
    });
    PHA_EVENT.Bind('#btnDelete-q', 'click', function () {
        var payID = com.GetSelectedRow('#gridMain-q', 'payID');
        if (payID === '') {
            components('Pop', '请先选择需要删除的记录');
            return;
        }
        PHA.Confirm('提示', '确认删除吗', function () {
            com.Invoke(com.Fmt2ApiMethod('Delete'), { payID: payID }, function (retData) {
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
                    $('#gridMain-q').datagrid('reload');
                }
            });
        });
    });
    PHA_EVENT.Bind('#btnPrint-q', 'click', function () {
        com.Print(com.GetSelectedRow('#gridMain-q', 'payID'));
    });
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    setTimeout(function () {
        SetDefaults();
        com.SetPage('pha.in.v3.pay.query.csp');
    }, 0);
});
