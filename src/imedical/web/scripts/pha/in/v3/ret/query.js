/**
 * 退货 - 查询
 * @creator 云海宝
 */

$(function () {
    var biz = {
        data: {
            retID: '',
            handleStatus: '',
            defaultData: [
                {
                    'startDate-q': PHA_UTIL.GetDate('t-7'),
                    'endDate-q': PHA_UTIL.GetDate('t'),
                    'loc-q': session['LOGON.CTLOCID'],
                    'status-q': App_MenuCsp !== 'pha.in.v3.ret.query.csp' ? ['SAVE', 'COMP'] : []
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
    var components = RET_COMPONENTS();
    var com = RET_COM;
    var settings = com.GetSettings();
    aaa = 0;
    components('Loc', 'loc-q');
    components('Inci', 'inci-q');
    components('No', 'no-q');
    components('Date', 'startDate-q');
    components('Date', 'endDate-q');
    components('Vendor', 'vendor-q');
    components('Status', 'status-q');
    components('FilterField', 'filterField-q');
    components('MainGrid', 'gridMain-q', {
        toolbar: '#gridMain-qBar',
        onSelect: function (rowIndex, rowData) {
            // 控制双击, 避免双击选取时, 连续调用查询
            if (PHA_COM.GridSelecting(this.id, rowIndex) == true) {
                return;
            }
            ControlOperation();
            var pJson = com.Condition('#qCondition-q', 'get');
            pJson.retID = com.GetSelectedRow('#gridMain-q', 'retID');
            com.QueryItmGrid('gridItm-q', pJson);
        },
        onDblClickRow: function () {
            if ($('#btnRetOk-q').parent().css('display') !== 'none') {
                $('#btnRetOk-q').click();
            }
        },
        onLoadSuccess: function () {
            $('#gridItm-q').datagrid('clear');
            ControlOperation();
        }
    });
    var rebuildColumns = PHA_COM.RebuildColumns(components('ItmGridColmuns', 'gridItm'), {
        hiddenFields: ['gCheck']
    });
    components('ItmGrid', 'gridItm-q', {
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns
    });

    $('#btnFind-q').on('click', function () {
        com.QueryMainGrid('gridMain-q', com.Condition('#qCondition-q', 'get'));
    });
    $('#btnClean-q').on('click', function () {
        com.Condition('#qCondition-q', 'clear');
        $('#gridMain-q').datagrid('clear');
        $('#gridItm-q').datagrid('clear');
        SetDefaults();
    });
    $('#btnRetClose-q').on('click', function () {
        var winTarget = '#' + com.GetWindowId4Event();
        $.data($(winTarget), 'retData', {});
        $(winTarget).window('close');
    });
    PHA_EVENT.Bind('#btnRetOk-q,#btnRetCopy-q', 'click', function () {
        var retID = com.GetSelectedRow('#gridMain-q', 'retID');
        if (retID === '') {
            components('Pop', '请先选择记录');
            return;
        }
        var winTarget = '#' + com.GetWindowId4Event();
        $.data($(winTarget)[0], 'retData', {
            retID: retID,
            type: this.id === 'btnRetCopy-q' ? 'copy' : ''
        });
        $(winTarget).window('close');
    });
    PHA_EVENT.Bind('#btnPrint-q', 'click', function () {
        com.Print(com.GetSelectedRow('#gridMain-q', 'retID'));
    });
    PHA_EVENT.Bind('#btnDelete-q', 'click', function () {
        var retID = com.GetSelectedRow('#gridMain-q', 'retID');
        if (retID === '') {
            components('Pop', '请先选择需要删除的记录');
            return;
        }
        PHA.Confirm('提示', '确认删除吗', function () {
            com.Invoke(com.Fmt2ApiMethod('Delete'), { retID: retID }, function (retData) {
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
                    $('#gridMain-q').datagrid('reload');
                }
            });
        });
    });
    function ControlOperation() {
        $('#btnRetOk-q,#btnDelete-q,#btnRetCopy-q').linkbutton('disable');
        var sel = com.GetSelectedRow('#gridMain-q');
        if (!sel) {
            return;
        }
        var statusCode = sel.status;
        if (statusCode === 'SAVE') {
            $('#btnDelete-q').linkbutton('enable');
        }
        if (statusCode !== 'CANCEL') {
            $('#btnRetOk-q').linkbutton('enable');
        }
        $('#btnRetCopy-q').linkbutton('enable');
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    setTimeout(function () {
        var defaultData = settings.DefaultData;
        // 本应全部追加 -q
        defaultData['startDate-q'] = defaultData.startDate;
        defaultData['endDate-q'] = defaultData.endDate;
        $.extend(biz.getData('defaultData')[0], defaultData || {});
        SetDefaults();
        // ControlOperation();
        com.SetPage('pha.in.v3.ret.query.csp');
        ControlOperation();
    }, 0);
});

