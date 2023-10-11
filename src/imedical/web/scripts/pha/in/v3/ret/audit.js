/**
 * 退货 - 审核
 * @creator 云海宝
 */
$(function () {
    /**
     * 内部全局
     */
    var biz = {
        data: {
            status: 'SAVE', // 单据状态
            handleStatus: '',
            defaultData: [
                {
                    loc: session['LOGON.CTLOCID'],
                    startDate: session['LOGON.CTLOCID'],
                    endDate: session['LOGON.CTLOCID'],
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
    var components = RET_COMPONENTS();
    var com = RET_COM;
    var settings = com.GetSettings();

    components('Date', 'startDate');
    components('Date', 'endDate');
    components('Loc', 'loc');
    // components('StkCatGrp', 'stkCatGrp');
    components('No', 'no');
    components('StatusResult', 'nextStatusResult', {
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
    components('FilterField', 'filterField');
    components('MainGrid', 'gridMain', {
        toolbar: '#gridMainBar',
        onClickRow: function () {
            var pJson = com.Condition('#qCondition', 'get');
            pJson.retID = com.GetSelectedRow('#gridMain', 'retID');
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
        toolbar: '#gridItmBar',
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns,
        onClickCell: function (index, field, value) {}
    });

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
    PHA_EVENT.Bind('#btnAuditPrint', 'click', function () {
        biz.setData('handleStatus', 'Audit');
        Audit({
            callbackPrint: function (retID) {
                com.Print(retID);
            }
        });
    });
    PHA_EVENT.Bind('#btnAuditRefuse', 'click', function () {
        biz.setData('handleStatus', 'AuditRefuse');
        Audit();
    });
    PHA_EVENT.Bind('#btnAuditCancel', 'click', function () {
        biz.setData('handleStatus', 'AuditCancel');
        Audit();
    });
    PHA_EVENT.Bind('#btnPrint', 'click', function () {
        com.Print(com.GetSelectedRow('#gridMain', 'retID'));
    });
    /*PHA_EVENT.Bind('#btnDestroy', 'click', function () {
        biz.setData('handleStatus', 'Destroy');
        Audit();
    });*/


    function Audit(options) {
        options = options || {};
        var apiMethod = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (apiMethod === '') {
            return;
        }
        var retID = com.GetSelectedRow('#gridMain', 'retID');
        if (retID === '') {
            components('Pop', '请先选择需要处理的单据记录');
            return;
        }
        var statusCode = $('#nextStatus').combobox('getValue') || '';
        if (statusCode === '') {
            components('Pop', '请先选择预审流程');
            return;
        }
        var btnText = $(window.event.target).parent().find('.l-btn-text').text();
        if ((biz.getData('handleStatus') === 'AuditCancel')&&(statusCode === "AUDIT") ){
            PHA.BizPrompt(
                { title: '提醒', info: '<div><b>取消后将增加已经减少的库存，并且单据将变为作废状态</b></div><div>取消后如果还需处理, 您可以在制单查询中进行复制</div>' },
                function (promptRet) {
                    if (promptRet !== undefined) {
                        if (promptRet === '') {
                            components('Pop', '请录入简要说明');
                            return;
                        }
                        ExeAudit(promptRet);
                    }
                }
            );
        } else {
            PHA.BizPrompt({ title: '确认提醒' }, function (promptRet) {
                if (promptRet !== undefined) {
                    // if (promptRet === '') {
                    //     components('Pop', '请录入简要说明');
                    //     return;
                    // }
                    ExeAudit(promptRet);
                }
            });
            // PHA.Confirm('确认提醒', '您确认' + btnText + '吗?', ExeAudit);
        }
        function ExeAudit(promptRet) {
            var statusReason = '';
            if (typeof promptRet !== 'undefined') {
                statusReason = promptRet;
            }
            var data4save = {
                retID: retID,
                statusReason: statusReason,
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
                    components('Pop', '操作成功');
                    if (options.callbackPrint) {
                        options.callbackPrint(retID);
                    }
                }
            });
        }
    }
    function ControlOperation() {
        com.ControlOperation({});
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
        $('#nextStatus').combobox('reload');
    }
    function InitBodyStyle(){
        var loadDefaultData = {};
        if((LoadStDate != "")&&(LoadStDate != undefined)){
             loadDefaultData = {
                startDate: PHA_UTIL.GetDate(LoadStDate),
                endDate: PHA_UTIL.GetDate(LoadEndDate)
            }
        }
        return loadDefaultData;
    }
    setTimeout(function () {
        $.extend(biz.getData('defaultData')[0], settings.DefaultData || {});
        $.extend(biz.getData('defaultData')[0], InitBodyStyle());
        SetDefaults();
        ControlOperation();
        com.SetPage('pha.in.v3.ret.audit.csp');
        $("#btnFind").click();
    }, 500);
});
