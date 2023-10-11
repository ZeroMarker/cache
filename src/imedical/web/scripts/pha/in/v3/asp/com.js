/**
 * 调价 - 统一价 - 制单
 * @creator     云海宝
 */
// PHA_SYS_SET=undefined
var ASP_COM = {
    ApiClass: 'PHA.IN.ASP.Api',
    AppCode: 'DHCSTADJSP',
    AppComCode: 'DHCSTCOMMON',
    GetChangedRows: function (domID) {
        return PHA_GridEditor.GetChangedRows(domID);
    },
    Invoke: function (apiMethod, pJson, callback) {
        this.AppendLogonData(pJson);
        PHA.CM(
            {
                pClassName: ASP_COM.ApiClass,
                pMethodName: apiMethod,
                pJson: JSON.stringify(pJson)
            },
            function (retData) {
                callback(ASP_COM.FmtApiReturn(retData));
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
                pClassName: ASP_COM.ApiClass,
                pMethodName: apiMethod,
                pJson: JSON.stringify(pJson)
            },
            false
        );
        var apiRet = ASP_COM.FmtApiReturn(retData);
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
    Settings: '',
    GetSettings: function () {
        if (ASP_COM.Settings !== '') {
            return ASP_COM.Settings;
        }
        // 单例模式就需要全局变量控
        var appSettings = PHA_COM.ParamProp(ASP_COM.AppCode);
        var comSettings = PHA_COM.ParamProp(ASP_COM.AppComCode);
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
        ASP_COM.Settings = settings;
        return settings;
    },
    FmtApiReturn: function (retData) {
        if (retData.success === 0 || retData.code < 0) {
            return ASP_COM.TrimDelim(retData.msg);
        }
        return retData;
    },
    FmtApiInput: function (retData) {},
    QueryAspGrid: function (domID, pJson) {
        var $grid = $('#' + domID);
        var pJsonStr = JSON.stringify(pJson);
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: ASP_COM.ApiClass,
            pMethodName: 'GetAspDataRows',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
    },
    QueryGrpGrid: function (domID, pJson) {
        var $grid = $('#' + domID);
        var pJsonStr = JSON.stringify(pJson);
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: ASP_COM.ApiClass,
            pMethodName: 'GetGrpDataRows',
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
    QueryAspGrid: function (domID, pJson) {
        var $grid = $('#' + domID);
        var pJsonStr = JSON.stringify(pJson);
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: ASP_COM.ApiClass,
            pMethodName: 'GetAspDataRows',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
    },
    LoadData: function (domID, qJson) {
        qJson.pClassName = ASP_COM.ApiClass;
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
            case 'pha.in.v3.asp.audit.csp':
                PHA_COM.SetPanel('#layout-asp-audit-panel', $('#layout-asp-audit-panel').panel('options').title);
                break;
            case 'pha.in.v3.asp.create.csp':
                PHA_COM.SetPanel('#layout-asp-create-panel', $('#layout-asp-create-panel').panel('options').title);
                break;
            case 'pha.in.v3.asp.query.csp':
                break;
            case 'pha.in.v3.asp.exe.csp':
                PHA_COM.SetPanel('#layout-asp-audit-panel', $('#layout-asp-audit-panel').panel('options').title);
                break;
            default:
                break;
        }
        /**
         * 通用快捷键, 模块内的至少应该一致
         * @fix 药品下拉弹窗清除了原注册的快捷键
         * @fix 如何按按dom区域绑定, 如弹出框与原界面有类似操作
         */
        PHA_EVENT.Key([
            // ['btnClean', 'alt+c'], // clean
            // [$('#btnSelect').length > 0 ? 'btnSelect' : 'btnFind', 'alt+f'], // find
            ['btnAddItm', 'alt+a'], // add
            ['btnDeleteItm', 'alt+d'], // delete
            ['btnAddItm', 'alt+='], // +
            ['btnDeleteItm', 'alt+-'], // -
            ['btnDelete', 'alt+shift+d'], // 上档delete, 加强版
            ['btnSave', 'ctrl+s'],
            ['btnFind', 'alt+f']
        ]);
        $('[id^=qCondition] a').width('100%');
        PHA.SetRequired($('[id^=qCondition] [data-pha]'));
    },
    ControlOperation: function (handleObj) {
        PHA_COM.ControlOperation(handleObj);
    },
    GridFinalDone: function (target) {
        PHA_GridEditor.GridFinalDone(target, 'inciCode');
    },
    ValidatePrice: function (val, field) {
        var msg = '请输入大于或等于0的数字3';
        if (_.isLikeNumber(val) === false) {
            return msg;
        }
        if (parseFloat(val) < 0) {
            return msg;
        }
        return true;
    },
    Calc: function () {},
    SumGridData: function (target, fieldArr) {
        return PHA_COM.SumGridData(target, fieldArr);
    },

    SumGridFooter: function (target, fieldArr) {
        PHA_COM.SumGridFooter(target, fieldArr);
    }
};

