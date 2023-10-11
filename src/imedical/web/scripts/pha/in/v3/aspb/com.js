/**
 * 调价 - 批次价 - 公共
 * @creator 云海宝
 */
// PHA_SYS_SET=undefined
var ASPB_COM = {
    ApiClass: 'PHA.IN.ASPB.Api',
    AppCode: 'DHCSTADJSPBATCH',
    AppComCode: 'DHCSTCOMMON',
    Const: {
        Code: 'DHCSTADJSPBATCH'
    },
    GetChangedRows: function (domID) {
        return PHA_GridEditor.GetChangedRows(domID);
    },
    Invoke: function (apiMethod, pJson, callback) {
        this.AppendLogonData(pJson.main);
        PHA.CM(
            {
                pClassName: ASPB_COM.ApiClass,
                pMethodName: apiMethod,
                pJson: JSON.stringify(pJson)
            },
            function (retData) {
                callback(ASPB_COM.FmtApiReturn(retData));
            },
            function () {
                callback('访问错误');
            }
        );
    },
    InvokeSyn: function (apiMethod, pJson) {
        this.AppendLogonData(pJson);
        var retData = PHA.CM(
            {
                pClassName: ASPB_COM.ApiClass,
                pMethodName: apiMethod,
                pJson: JSON.stringify(pJson)
            },
            false
        );
        var apiRet = ASPB_COM.FmtApiReturn(retData);
        if (typeof apiRet === 'string') {
            PHA.Alert('提示', apiRet, 'error');
        }
        return apiRet;
    },
    ApiMethods: {
        Save: 'HandleSave',
        Delete: 'HandleDelete',
        Audit: 'HandleAudit',
        AuditCancel: 'HandleAuditCancel',
        Execute: 'HandleExecute'
    },
    Fmt2ApiMethod: function (pHandleCode) {
        var apiMethod = this.ApiMethods[pHandleCode];
        if (apiMethod === '') {
            PHA.Alert('致命错误', pHandleCode + '没有可供调用的程序');
        }
        return apiMethod;
    },
    Settings:'',
    GetSettings: function () {
        if (ASPB_COM.Settings !== '') {
            return ASPB_COM.Settings;
        }
        // 单例模式就需要全局变量控
        var appSettings = PHA_COM.ParamProp(ASPB_COM.AppCode);
        var comSettings = PHA_COM.ParamProp(ASPB_COM.AppComCode);
        if (appSettings.Warn4PriceRate === undefined) {
            appSettings.Warn4PriceRate = 1.5;
        }
        var settings = {
            App: appSettings,
            Com: comSettings,
            DefaultValues: {
                startDate: PHA_UTIL.GetDate('t'),
                endDate: PHA_UTIL.GetDate('t')
            }
        };
        ASPB_COM.Settings = settings;
        return settings;
    },
    FmtApiReturn: function (retData) {
        if (retData.success === 0 || retData.code < 0) {
            return ASPB_COM.TrimDelim(retData.msg);
        }
        return retData;
    },
    FmtApiInput: function (retData) {},
    QueryAspbGrid: function (domID, pJson) {
        var $grid = $('#' + domID);
        var pJsonStr = JSON.stringify(pJson);
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: ASPB_COM.ApiClass,
            pMethodName: 'GetAspbDataRows',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
    },
    ValidateGridData: function (data) {
        return PHA_COM.ValidateGridData(data);
    },
    ValidateApiReturn: function (data) {
        var ret = this.FmtApiReturn(data);
        if (typeof ret === 'string') {
            PHA.Alert('提示', ret, 'error');
            return false;
        }
        return true;
    },
    TrimDelim: function (str) {
        return str.indexOf('^') >= 0 ? str.split('^')[1] : str;
    },
    FmtRows4Save: function (pRows) {
        var rows4Save = [];
        pRows.forEach(function (ele) {
            var newRow = {
                incib: ele.incib,
                inci: ele.inci,
                uom: ele.uom,
                hosp: ele.hosp,
                retUomSp: ele.retUomSp,
                retUomRp: ele.retUomRp,
                reason: ele.reason,
                remark: ele.remark,
                preExecuteDate: ele.preExecuteDate,
                createDate: ele.createDate
            };

            rows4Save.push(newRow);
        });
        return rows4Save;
    },
    QueryGrpGrid: function (domID, pJson) {
        var $grid = $('#' + domID);
        var pJsonStr = JSON.stringify(pJson);
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: ASPB_COM.ApiClass,
            pMethodName: 'GetGrpDataRows',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
    },
    LoadData: function (domID, qJson) {
        qJson.pClassName = ASPB_COM.ApiClass;
        PHA_COM.LoadData(domID, qJson);
    },
    AppendLogonData: function (jsonObj) {
        return PHA_COM.AppendLogonData(jsonObj);
    },
    GetSelectedRow: function (target, field) {
        return PHA_COM.GetSelectedRow(target, field);
    },
    GetSelectedRowIndex: function (target) {
        return PHA_COM.GetSelectedRowIndex(target);
    },
    Condition: function (target, type, options) {
        return PHA_COM.Condition(target, type, options);
    },
    /**
     * 集成处理某个模块的页面相关控制, 有些改动不需要每个界面都调试, 如面板高度等
     * @param {} cspName 页面csp全称
     */
    SetPage: function (cspName) {
        cspName = cspName || App_MenuCsp;
        switch (cspName) {
            case 'pha.in.v3.aspb.audit.csp':
                PHA_COM.SetPanel('#layout-aspb-audit-panel', $('#layout-aspb-audit-panel').panel('options').title);
                break;
            case 'pha.in.v3.aspb.create.csp':
                PHA_COM.SetPanel('#layout-aspb-create-panel', $('#layout-aspb-create-panel').panel('options').title);
                break;
            case 'pha.in.v3.aspb.query.csp':
                break;
            case 'pha.in.v3.aspb.exe.csp':
                PHA_COM.SetPanel('#layout-aspb-audit-panel', $('#layout-aspb-audit-panel').panel('options').title);
                break;
            default:
                break;
        }
        $('[id^=qCondition] a').width('100%');
        PHA.SetRequired($('[id^=qCondition] [data-pha]'));
    },
    ControlOperation: function (handleObj) {
        PHA_COM.ControlOperation(handleObj);
    },
    GridFinalDone: function (target) {
        PHA_GridEditor.GridFinalDone(target, 'inciCode');
    },
    ValidatePrice: function (val) {
        var msg = '请输入大于或等于0的数字';
        if (_.isLikeNumber(val) === false) {
            return msg;
        }
        if (parseFloat(val) < 0) {
            return msg;
        }
        return true;
    },
    SumGridData: function (target, fieldArr) {
        return PHA_COM.SumGridData(target, fieldArr);
    },
    SumGridFooter: function (target, fieldArr) {
        PHA_COM.SumGridFooter(target, fieldArr);
    }
};

