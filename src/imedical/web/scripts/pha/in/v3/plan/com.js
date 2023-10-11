/**
 * 采购计划 - 通用
 * @creator 云海宝
 */
// PHA_SYS_SET=undefined // 测试用
var PLAN_COM = {
    ApiClass: 'PHA.IN.PLAN.Api',
    AppCode: 'DHCSTPURPLANAUDIT',
    AppComCode: 'DHCSTCOMMON',
    GetChangedRows: function (domID) {
        return PHA_GridEditor.GetChangedRows(domID);
    },
    Invoke: function (apiMethod, pJson, callback) {
        // 仅仅用于处理保存等操作
        this.AppendLogonData(pJson);
        PHA.CM(
            {
                pClassName: PLAN_COM.ApiClass,
                pMethodName: apiMethod,
                pJson: JSON.stringify(pJson)
            },
            function (retData) {
                callback(PLAN_COM.FmtApiReturn(retData));
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
                pClassName: PLAN_COM.ApiClass,
                pMethodName: apiMethod,
                pJson: JSON.stringify(pJson)
            },
            false
        );
        var apiRet = PLAN_COM.FmtApiReturn(retData);
        if (typeof apiRet === 'string') {
            PHA.Alert('提示', apiRet, 'error');
        }
        return apiRet;
    },
    ApiMethods: {
        Save: 'HandleSave',
        SaveAsMould: 'HandleSaveAsMould',
        Delete: 'HandleDeleteMain',
        Finish: 'HandleFinish',
        FinishCancel: 'HandleFinishCancel',
        Audit: 'HandleAudit',
        AuditCancel: 'HandleAuditCancel',
        AuditRefuse: 'HandleAuditRefuse',
        DeleteItm: 'HandleDeleteItm',
        DeleteItms: 'HandleDeleteItms'
    },
    Fmt2ApiMethod: function (pHandleCode) {
        var apiMethod = this.ApiMethods[pHandleCode];
        if (apiMethod === '') {
            PHA.Alert('致命错误', pHandleCode + '没有可供调用的程序');
        }
        return apiMethod;
    },
    GetMainData: function (planID) {
        return this.InvokeSyn('GetMainData', { planID: planID });
    },
    GetItmData: function (planItmID) {
        return this.InvokeSyn('GetMainData', { planItmID: planItmID });
    },
    QueryMainGrid: function (domID, pJson) {
        var $grid = $('#' + domID);
        if(!pJson || pJson == undefined) return;
        var pJsonStr = JSON.stringify(pJson).replace(/-q/g, '');
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: PLAN_COM.ApiClass,
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
            pClassName: PLAN_COM.ApiClass,
            pMethodName: 'GetItmDataRows',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
    },
    QueryGrid: function (domID, pMethodName, pJson) {
        var $grid = $('#' + domID);
        var pJsonStr = JSON.stringify(pJson).replace(/-q/g, '');
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: PLAN_COM.ApiClass,
            pMethodName: pMethodName,
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
    },
    LoadData: function (domID, qJson) {
        qJson.pClassName = PLAN_COM.ApiClass;
        PHA_COM.LoadData(domID, qJson);
    },
    /**
     * 模块参数
     */
    GetSettings: function () {
        // 单例模式就需要全局变量控
        var planSettings = PHA_COM.ParamProp('DHCSTPURPLANAUDIT');
        var comSettings = PHA_COM.ParamProp('DHCSTCOMMON');
        return {
            App: planSettings,
            Com: comSettings,
            DefaultData: {
                startDate: PHA_UTIL.GetDate('t' + planSettings.DefaStartDate),
                endDate: PHA_UTIL.GetDate('t' + planSettings.DefaEndDate),
                loc: session['LOGON.CTLOCID']
            }
        };
    },
    TrimDelim: function (str) {
        return str.replace(/-\d*\^/g, '');
    },
    FmtApiReturn: function (retData) {
        if (retData.success === 0 || retData.code < 0) {
            return PLAN_COM.TrimDelim(retData.msg);
        }
        return retData;
    },
    FmtApiInput: function (retData) {},
    ValidateGridData: function (data) {
        if (data.success === 0) {
            PHA.Alert('提示', data.msg, 'error');
            return false;
        }
        return true;
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
    /**
     * 给传到后台的程序追加session信息, 建议取不到session时, 以此为准
     * @param {} jsonObj
     */
    AppendLogonData: function (jsonObj) {
        return PHA_COM.AppendLogonData(jsonObj);
    },
    Top: {
        Const: ['PHA_IN_PLAN_ID'],
        Set: function (key, value) {
            if (!top.PHA_IN_PLAN) {
                top.PHA_IN_PLAN = {};
            }
            top.PHA_IN_PLAN[key] = value;
        },
        Get: function (key, clearFlag) {
            if (top.PHA_IN_PLAN) {
                var ret = top.PHA_IN_PLAN[key] || ''; // 对象需要深拷贝
                if (clearFlag === true) {
                    delete top.PHA_IN_PLAN[key];
                }
                return ret;
            }
            return '';
        }
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
    UpdateRow: function (target, rowIndex, pJson) {
        var rowData = this.InvokeSyn('GetMainData', pJson);
        $(target).datagrid('updateRow', {
            index: rowIndex,
            row: rowData
        });
    },
    /**
     * 集成处理某个模块的页面相关控制, 有些改动不需要每个界面都调试, 如面板高度等
     * @param {} cspName 页面csp全称
     */
    SetPage: function (cspName) {
        cspName = cspName || App_MenuCsp;
        switch (cspName) {
            case 'pha.in.v3.plan.audit.csp':
                PHA_COM.ResizePanel({
                    layoutId: 'layout-plan-audit',
                    region: 'north',
                    height: 0.5
                });
                break;
            case 'pha.in.v3.plan.query.csp':
                PHA_COM.ResizePanel({
                    layoutId: 'layout-plan-query',
                    region: 'north',
                    height: 0.5
                });

                break;
            case 'pha.in.v3.plan.create.csp':
                PHA_COM.SetPanel('#layout-plan-create-panel', $('#layout-plan-create-panel').panel('options').title);
                // $('#btnPrint-q').parent().hide()
                break;
            case 'pha.in.v3.plan.createbystock.csp':
                PHA_COM.SetPanel('#layout-plan-createbystock-panel', $('#layout-plan-createbystock-panel').panel('options').title);
                break;
            case 'pha.in.v3.plan.createbyconsume.csp':
                PHA_COM.SetPanel('#layout-plan-createbyconsume-panel', $('#layout-plan-createbyconsume-panel').panel('options').title);
                break;
            case 'pha.in.v3.plan.createbyreq.csp':
                PHA_COM.ResizePanel({
                    layoutId: 'layout-plan-createbyreq',
                    region: 'north',
                    height: 0.5
                });
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
            ['btnClean', 'alt+c'],
            ['btnFind', 'alt+f']
        ]);
        $('[id^=qCondition] a').width('100%');
        PHA.SetRequired($('[id^=qCondition] [data-pha]'));
    },
    ControlOperation: function (handleObj) {
        PHA_COM.ControlOperation(handleObj);
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
    ValidateQty: function (val) {
        var msg = '请输入大于0的数字';
        if (_.isLikeNumber(val) === false) {
            return msg;
        }
        if (parseFloat(val) <= 0) {
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
    },

    HandleCheckStyle: function (target, method, rowIndex) {
        PHA_COM.HandleCheckStyle(target, method, rowIndex);
    },
    GridFinalDone: function (target) {
        PHA_GridEditor.GridFinalDone(target, 'inciCode');
    },
    Print: function (planID) {
        planID = planID || '';
        if (planID === '') {
            PHA.Popover({
                msg: '请先选择需要打印的单据',
                type: 'info'
            });
            return;
        }
        PLAN_PRINT.Print(planID);
        return;
        // 如下是xml模板形式, 但调整格式还不如直接那代码来的快
        var printStyle = PHA_COM.PrintStyle;
        PRINTCOM.XML({
            printBy: 'lodop',
            XMLTemplate: 'PHAINPLAN',
            dataOptions: {
                ClassName: 'PHA.IN.PLAN.Api',
                MethodName: 'GetPrintData',
                pJsonStr: JSON.stringify({
                    planID: planID,
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
            aptListFields: printStyle.FixListFields(['printInfo', 'createUserName', 'auditUserName']) //,
            // 结束页签名
            // endPageFields: printStyle.FixListFields(['printInfo', 'createUserName', 'auditUserName'])
        });
    },
    Copy: function (pJson, callback) {
        PLAN_COM.Invoke('HandleCopy', pJson, function (retData) {
            callback(retData);
        });
    },
    GetWindowId4Event: function () {
        return $(window.event.target).closest('.js-pha-com-window-sign').attr('id') || '';
    },
    DeleteJsonKeys: function (dataObj, delFields) {
        for (var i = 0, length = delFields.length; i < length; i++) {
            delete dataObj[delFields[i]];
        }
    },
    SetKeyValue2Null: function (dataObj, delFields) {
        for (var i = 0, length = delFields.length; i < length; i++) {
            dataObj[delFields[i]] = '';
        }
    }
};

// 集成
$.extend($.fn.validatebox.defaults.rules, {
    planQty: {
        message: '请输入大于0的数字',
        validator: function (value) {
            if (_.isLikeNumber(value) === false) {
                return false;
            }
            if (parseFloat(value) < 0) {
                return false;
            }
            return true;
        }
    },
    planPrice: {
        message: '请输入大于等于0的数字',
        validator: function (value) {
            if (_.isLikeNumber(value) === false) {
                return false;
            }
            if (parseFloat(value) < 0) {
                return false;
            }
            return true;
        }
    }
});

