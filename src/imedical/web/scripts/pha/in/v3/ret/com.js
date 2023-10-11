/**
 * 退货 - 公共
 * @creator 云海宝
 */
// PHA_SYS_SET = undefined;
var RET_COM = {
    ApiClass: 'PHA.IN.RET.Api',
    AppCode: 'DHCSTRETURN',
    AppComCode: 'DHCSTCOMMON',
    BizCode: 'RET',
    GetChangedRows: function (domID) {
        return PHA_GridEditor.GetChangedRows(domID);
    },
    Invoke: function (apiMethod, pJson, callback) {
        this.AppendLogonData(pJson);
        PHA.CM(
            {
                pClassName: RET_COM.ApiClass,
                pMethodName: apiMethod,
                pJson: JSON.stringify(pJson)
            },
            function (retData) {
                callback(RET_COM.FmtApiReturn(retData));
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
                pClassName: RET_COM.ApiClass,
                pMethodName: apiMethod,
                pJson: JSON.stringify(pJson)
            },
            false
        );
        var apiRet = RET_COM.FmtApiReturn(retData);
        if (typeof apiRet === 'string') {
            PHA.Alert('提示', apiRet, 'error');
        }
        return apiRet;
    },
    Fmt2ApiMethod: function (pHandleCode) {
        var apiMethod = this.ApiMethods[pHandleCode];
        if (apiMethod === '') {
            PHA.Alert('致命错误', pHandleCode + '没有可供调用的程序');
        }
        return apiMethod;
    },
    ApiMethods: {
        Save: 'HandleSave',
        Finish: 'HandleFinish',
        Audit: 'HandleAudit',
        AuditCancel: 'HandleAuditCancel',
        FinishCancel: 'HandleFinishCancel',
        Delete: 'HandleDeleteMain',
        DeleteItm: 'HandleDeleteItm',
        DeleteItms: 'HandleDeleteItms',
        Save4Rec: 'HandleSave4Rec',
        AuditRefuse: 'HandleAuditRefuse',
        Destroy: 'HandleDestroy',
        GenerateCreateData: 'GenerateCreateData'
    },
    GetMainData: function (rowID) {
        return this.InvokeSyn('GetMainData', { rowID: rowID, retID: rowID });
    },
    GetItmData: function (rowID) {
        return this.InvokeSyn('GetItmData', { rowID: rowID, retItmID: rowID });
    },
    GetFullData4InputRow: function (pJson) {
        return this.InvokeSyn('GetFullData4InputRow', pJson);
    },
    GetSettings: function () {
        var appSettings = PHA_COM.ParamProp(RET_COM.AppCode);
        var comSettings = PHA_COM.ParamProp(RET_COM.AppComCode);
        return {
            App: appSettings,
            Com: comSettings,
            DefaultData: {
                startDate: PHA_UTIL.GetDate('t' + appSettings.DefStartDate),
                endDate: PHA_UTIL.GetDate('t' + appSettings.DefEndDate),
                loc: session['LOGON.CTLOCID']
            }
        };
    },
    TrimDelim: function (str) {
        return str.replace(/-\d*\^/g, '');
    },

    QueryMainGrid: function (domID, pJson) {
	    if(!pJson) return;
        var $grid = $('#' + domID);
        var pJsonStr = JSON.stringify(pJson).replace(/-q/g, '');
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: RET_COM.ApiClass,
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
            pClassName: RET_COM.ApiClass,
            pMethodName: 'GetItmDataRows',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
    },
    LoadData: function (domID, qJson) {
        qJson.pClassName = RET_COM.ApiClass;
        PHA_COM.LoadData(domID, qJson);
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
    FmtApiReturn: function (retData) {
        if (retData.success === 0 || retData.code < 0) {
            return RET_COM.TrimDelim(retData.msg);
        }
        return retData;
    },
    FmtApiInput: function (retData) {},
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
            case 'pha.in.v3.ret.audit.csp':
                PHA_COM.ResizePanel({
                    layoutId: 'layout-ret-audit',
                    region: 'north',
                    height: 0.5
                });
                break;
            case 'pha.in.v3.ret.query.csp':
                PHA_COM.ResizePanel({
                    layoutId: 'layout-ret-query',
                    region: 'north',
                    height: 0.5
                });
                break;
            case 'pha.in.v3.ret.create.csp':
                PHA_COM.SetPanel('#layout-ret-create-panel', $('#layout-ret-create-panel').panel('options').title);

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
    Top: {
        Const: ['PHA_IN_RET_ROWID'],
        Set: function (key, value) {
            if (!top.PHA_IN_RET) {
                top.PHA_IN_RET = {};
            }
            top.PHA_IN_RET[key] = value;
        },
        Get: function (key, clearFlag) {
            if (top.PHA_IN_RET) {
                var ret = top.PHA_IN_RET[key] || ''; // 对象则需要深拷贝
                if (clearFlag === true) {
                    delete top.PHA_IN_RET[key];
                }
                return ret;
            }
            return '';
        }
    },
    ControlOperation: function (handleObj) {
        PHA_COM.ControlOperation(handleObj);
    },
    ValidatePrice: function (val) {
        if (_.isLikeNumber(val) === false) {
            return '请输入数字';
        }
        if (parseFloat(val) < 0) {
            return '请输入大于或等于0的数字';
        }
        return true;
    },
    ValidateQty: function (val) {
        if (_.isLikeNumber(val) === false) {
            return '请输入数字';
        }
        if (parseFloat(val) <= 0) {
            return '数量: 请输入大于0的数字';
        }
        return true;
    },
    SumGridData: function (target, fieldArr) {
        return PHA_COM.SumGridData(target, fieldArr);
    },
    SumGridFooter: function (target, fieldArr) {
        PHA_COM.SumGridFooter(target);
    },
    GridFinalDone: function (target, field) {
        PHA_GridEditor.GridFinalDone(target, 'recItmID');
    },
    BanGridEditors: function (target, banFields) {
        PHA_GridEditor.BanGridEditors(target, banFields);
    },
    UpdateRow: function (target, rowIndex, pJson) {
        var rowData = this.InvokeSyn('GetMainData', pJson);
        $(target).datagrid('updateRow', {
            index: rowIndex,
            row: rowData
        });
    },
    Copy: function (pJson, callback) {
        RET_COM.Invoke('HandleCopy', pJson, function (retData) {
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
    },
    Print: function (retID) {
        if (retID === '') {
            PHA.Popover({
                msg: '请先选择需要打印的单据',
                type: 'info'
            });
            return;
        }
        RET_PRINT.Print(retID);
        return;
        // 如下是xml模板形式
        var printStyle = PHA_COM.PrintStyle;
        PRINTCOM.XML({
            printBy: 'lodop',
            XMLTemplate: 'PHAINRET',
            dataOptions: {
                ClassName: 'PHA.IN.RET.Api',
                MethodName: 'GetPrintData',
                pJsonStr: JSON.stringify({
                    retID: retID,
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
            aptListFields: printStyle.FixListFields(['printInfo', 'createUserName', 'auditUserName']),
            // 结束页签名
            endPageFields: printStyle.FixListFields(['printInfo', 'createUserName', 'auditUserName'])
        });
    }
};

