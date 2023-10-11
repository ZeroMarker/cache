/**
 * ���� - ͳһ�� - �Ƶ�
 * @creator     �ƺ���
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
                callback('���ʴ���');
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
            PHA.Alert('��ʾ', apiRet, 'error');
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
            PHA.Alert('��������', pHandleCode + 'û�пɹ����õĳ���');
        }
        return apiMethod;
    },
    Settings: '',
    GetSettings: function () {
        if (ASP_COM.Settings !== '') {
            return ASP_COM.Settings;
        }
        // ����ģʽ����Ҫȫ�ֱ�����
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
            PHA.Alert('��ʾ', ret, 'error');
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
     * ���ɴ���ĳ��ģ���ҳ����ؿ���, ��Щ�Ķ�����Ҫÿ�����涼����, �����߶ȵ�
     * @param {} cspName ҳ��cspȫ��
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
         * ͨ�ÿ�ݼ�, ģ���ڵ�����Ӧ��һ��
         * @fix ҩƷ�������������ԭע��Ŀ�ݼ�
         * @fix ��ΰ���dom�����, �絯������ԭ���������Ʋ���
         */
        PHA_EVENT.Key([
            // ['btnClean', 'alt+c'], // clean
            // [$('#btnSelect').length > 0 ? 'btnSelect' : 'btnFind', 'alt+f'], // find
            ['btnAddItm', 'alt+a'], // add
            ['btnDeleteItm', 'alt+d'], // delete
            ['btnAddItm', 'alt+='], // +
            ['btnDeleteItm', 'alt+-'], // -
            ['btnDelete', 'alt+shift+d'], // �ϵ�delete, ��ǿ��
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
        var msg = '��������ڻ����0������3';
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

