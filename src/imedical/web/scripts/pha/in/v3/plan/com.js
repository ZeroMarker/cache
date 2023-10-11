/**
 * �ɹ��ƻ� - ͨ��
 * @creator �ƺ���
 */
// PHA_SYS_SET=undefined // ������
var PLAN_COM = {
    ApiClass: 'PHA.IN.PLAN.Api',
    AppCode: 'DHCSTPURPLANAUDIT',
    AppComCode: 'DHCSTCOMMON',
    GetChangedRows: function (domID) {
        return PHA_GridEditor.GetChangedRows(domID);
    },
    Invoke: function (apiMethod, pJson, callback) {
        // �������ڴ�����Ȳ���
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
                callback('���ʴ���');
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
            PHA.Alert('��ʾ', apiRet, 'error');
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
            PHA.Alert('��������', pHandleCode + 'û�пɹ����õĳ���');
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
     * ģ�����
     */
    GetSettings: function () {
        // ����ģʽ����Ҫȫ�ֱ�����
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
            PHA.Alert('��ʾ', data.msg, 'error');
            return false;
        }
        return true;
    },
    /**
     * У�鷵��ֵ, �������������, ����Ϊ�쳣����, ��ҪΪalert��ʽ
     * @param {*} data ��̨��ԭʼ����ֵ
     * @returns
     */
    ValidateApiReturn: function (data) {
        var ret = this.FmtApiReturn(data);
        if (typeof ret === 'string') {
            PHA.Alert('��ʾ', ret, 'error');
            return false;
        }
        return true;
    },
    /**
     * ��������̨�ĳ���׷��session��Ϣ, ����ȡ����sessionʱ, �Դ�Ϊ׼
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
                var ret = top.PHA_IN_PLAN[key] || ''; // ������Ҫ���
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
     * ���ɴ���ĳ��ģ���ҳ����ؿ���, ��Щ�Ķ�����Ҫÿ�����涼����, �����߶ȵ�
     * @param {} cspName ҳ��cspȫ��
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
        var msg = '��������ڻ����0������';
        if (_.isLikeNumber(val) === false) {
            return msg;
        }
        if (parseFloat(val) < 0) {
            return msg;
        }
        return true;
    },
    ValidateQty: function (val) {
        var msg = '���������0������';
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
                msg: '����ѡ����Ҫ��ӡ�ĵ���',
                type: 'info'
            });
            return;
        }
        PLAN_PRINT.Print(planID);
        return;
        // ������xmlģ����ʽ, ��������ʽ������ֱ���Ǵ������Ŀ�
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
            // ��ҳλ��
            page: $.extend(printStyle.page, {}),
            // �߿���ʽ
            listBorder: $.extend(printStyle.listBorder, {}),
            // ������
            listColAlign: $.extend(printStyle.listColAlign, {}),
            // ����Ӧ�ײ�ǩ��
            aptListFields: printStyle.FixListFields(['printInfo', 'createUserName', 'auditUserName']) //,
            // ����ҳǩ��
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

// ����
$.extend($.fn.validatebox.defaults.rules, {
    planQty: {
        message: '���������0������',
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
        message: '��������ڵ���0������',
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

