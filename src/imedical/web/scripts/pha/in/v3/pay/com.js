/**
 * 付款管理 - 通用
 * @creator 云海宝
 */
// PHA_SYS_SET = undefined;

var PAY_COM = {
    ApiClass: 'PHA.IN.PAY.Api',
    AppCode: 'DHCSTPAY',
    AppComCode: 'DHCSTCOMMON',
    GetChangedRows: function (domID) {
        return PHA_GridEditor.GetChangedRows(domID);
    },
    Invoke: function (apiMethod, pJson, callback) {
        this.AppendLogonData(pJson);
        PHA.CM(
            {
                pClassName: PAY_COM.ApiClass,
                pMethodName: apiMethod,
                pJson: PAY_COM.FmtApiInput(JSON.stringify(pJson))
            },
            function (retData) {
                callback(PAY_COM.FmtApiReturn(retData));
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
                pClassName: PAY_COM.ApiClass,
                pMethodName: apiMethod,
                pJson: JSON.stringify(pJson)
            },
            false
        );
        var apiRet = PAY_COM.FmtApiReturn(retData);
        if (typeof apiRet === 'string') {
            PHA.Alert('提示', apiRet, 'error');
        }
        return apiRet;
    },
    ApiMethods: {
        Save: 'HandleSave',
        Delete: 'HandleDeleteMain',
        Finish: 'HandleFinish',
        FinishCancel: 'HandleFinishCancel',
        Audit: 'HandleAudit',
        AuditCancel: 'HandleAuditCancel',
        DeleteItm: 'HandleDeleteItm',
        DeleteItms: 'HandleDeleteItms',
        Approve: 'HandleApprove',
        ApproveCancel: 'HandleApproveCancel',
        AuditByPurch: 'HandleAudit4Purch',
        AuditByAccount: 'HandleAudit4Account',
        AuditByTreasure: 'HandleAudit4Treasure',
        CreateVoucher: 'HandleCreateVoucher'
    },
    Fmt2ApiMethod: function (pHandleCode) {
        var apiMethod = this.ApiMethods[pHandleCode];
        if (apiMethod === '') {
            PHA.Alert('致命错误', pHandleCode + '没有可供调用的程序');
        }
        return apiMethod;
    },
    GetMainData: function (payID) {
        return this.InvokeSyn('GetMainData', { payID: payID });
    },
    GetItmData: function (payItmID) {
        return this.InvokeSyn('GetItmData', { payItmID: payItmID });
    },
    QueryMainGrid: function (domID, pJson) {
        var $grid = $('#' + domID);
        var pJsonStr = JSON.stringify(pJson).replace(/-q/g, '');
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: PAY_COM.ApiClass,
            pMethodName: 'GetMainDataRows',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
    },
    QueryItmGrid: function (domID, pJson) {
        var $grid = $('#' + domID);
        var pJsonStr = JSON.stringify(pJson).replace(/-q/g, '');
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: PAY_COM.ApiClass,
            pMethodName: 'GetItmDataRows',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
    },
    LoadData: function (domID, qJson) {
        qJson.pClassName = PAY_COM.ApiClass;
        PHA_COM.LoadData(domID, qJson);
    },
    GetSettings: function () {
        var appSettings = PHA_COM.ParamProp(PAY_COM.AppCode);
        var comSettings = PHA_COM.ParamProp(PAY_COM.AppComCode);
        return {
            App: appSettings,
            Com: comSettings,
            DefaultValues: {
                startDate: PHA_UTIL.GetDate('t+' + appSettings.DefaStartDate),
                endDate: PHA_UTIL.GetDate('t+' + appSettings.DefaEndDate),
                loc: session['LOGON.CTLOCID']
            }
        };
    },
    TrimDelim: function (str) {
        return str.replace(/-\d*\^/g, '');
    },
    FmtApiReturn: function (retData) {
        if (retData.success === 0 || retData.code < 0) {
            return PAY_COM.TrimDelim(retData.msg);
        }
        return retData;
    },
    FmtApiInput: function (str) {
        str = str.replace(/-q/g, '');
        str = str.replace(/-biz/g, '');
        return str;
    },
    ValidateGridData: function (data) {
        return PHA_COM.ValidateGridData(data);
    },
    /**
     * 校验返回值, 如果错误则提醒, 此类为异常报错, 需要为alert形式
     * @param {*} data 后台的原始返回值
     * @returns
     */
    ValidateApiReturn: function (data) {
        var ret = this.FmtApiReturn(data);
        if (typeof ret === 'string') {
            PHA.Alert('提示', ret, 'error');
            return false;
        }
        return true;
    },
    Validateddd: function () {},
    Top: {
        Const: ['PHA_IN_PAY_ID'],
        Set: function (key, value) {
            if (!top.PHA_IN_PAY) {
                top.PHA_IN_PAY = {};
            }
            top.PHA_IN_PAY[key] = value;
        },
        Get: function (key, clearFlag) {
            if (top.PHA_IN_PAY) {
                var ret = top.PHA_IN_PAY[key] || ''; // 对象需要深拷贝
                if (clearFlag === true) {
                    delete top.PHA_IN_PAY[key];
                }
                return ret;
            }
            return '';
        }
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
            case 'pha.in.v3.pay.audit.csp':
                PHA_COM.ResizePanel({
                    layoutId: 'layout-pay-audit',
                    region: 'north',
                    height: 0.5
                });
                // PHA.SetRequired($('#win4Account [data-pha]'));
                break;
            case 'pha.in.v3.pay.query.csp':
                PHA_COM.ResizePanel({
                    layoutId: 'layout-pay-query',
                    region: 'north',
                    height: 0.5
                });
                break
            case 'pha.in.v3.pay.approve.csp':
                PHA_COM.ResizePanel({
                    layoutId: 'layout-pay-approve',
                    region: 'south',
                    height: 0.4
                });
                break
            case 'pha.in.v3.pay.create.csp':
                PHA_COM.SetPanel('#layout-pay-create-panel', $('#layout-pay-create-panel').panel('options').title);
                break
            default:
                break;
        }
        /**
         * 通用快捷键, 模块内的至少应该一致
         * @fix 药品下拉弹窗清除了原注册的快捷键
         * @fix 如何按按dom区域绑定, 如弹出框与原界面有类似操作
         */
        PHA_EVENT.Key([
            ['btnClean', 'alt+c'], // clean
            // [$('#btnSelect').length > 0 ? 'btnSelect' : 'btnFind', 'alt+f'], // find
            ['btnAddItm', 'alt+a'], // add
            ['btnDeleteItm', 'alt+d'], // delete
            ['btnAddItm', 'alt+='], // +
            ['btnDeleteItm', 'alt+-'], // -
            ['btnDelete', 'alt+shift+d'], // 上档delete, 加强版
            ['btnSave', 'ctrl+s'],
            ['btnClean-q', 'alt+c'],
            ['btnFind-q', 'alt+f']
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
    ValidatePrice: function (val) {
        if (_.isLikeNumber(val) === false) {
            return '请输入数字';
        }
        return true;
    },
    SumGridData: function (target, fieldArr) {
        return PHA_COM.SumGridData(target, fieldArr);
    },
    SumGridFooter: function (target, fieldArr) {
        PHA_COM.SumGridFooter(target, fieldArr);
    },

    HandleCheckStyle: function (target, method, rowIndex) {
        PHA_COM.HandleCheckStyle(target, method, rowIndex);
    },
    UpdateRow: function (target, rowIndex, pJson) {
        var rowData = this.InvokeSyn('GetMainData', pJson);
        $(target).datagrid('updateRow', {
            index: rowIndex,
            row: rowData
        });
    },
    Print: function (payID) {
        payID = payID || '';
        if (payID === '') {
            PHA.Popover({
                msg: '请先选择需要打印的单据',
                type: 'info'
            });
            return;
        }
        PAY_PRINT.Print(payID);
        return;
        // 如下是xml模板形式
        var printStyle = PHA_COM.PrintStyle;
        PRINTCOM.XML({
            printBy: 'lodop',
            XMLTemplate: 'PHAINPAY',
            dataOptions: {
                ClassName: 'PHA.IN.PAY.Api',
                MethodName: 'GetPrintData',
                pJsonStr: JSON.stringify({
                    payID: payID,
                    printUserName: session['LOGON.USERNAME']
                })
            },
            // 分页位置
            page: $.extend(printStyle.page, {}),
            // 边框样式
            listBorder: $.extend(printStyle.listBorder, {}),
            // 金额居右
            listColAlign: $.extend(printStyle.listColAlign, {}),
            // 自适应底部签名
            aptListFields: printStyle.FixListFields(['printInfo', 'createUserName', 'auditUserName', 'purchUserName', 'accountUserName', 'treasureUserName']),
            // 结束页签名
            endPageFields: printStyle.FixListFields(['printInfo', 'createUserName', 'auditUserName', 'purchUserName', 'accountUserName', 'treasureUserName'])
        });
    }
};

