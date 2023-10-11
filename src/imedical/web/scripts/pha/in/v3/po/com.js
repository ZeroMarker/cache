/**
 * �ɹ����� - ͨ��
 * @creator �ƺ���
 */
// PHA_SYS_SET=undefined
var PO_COM = {
    ApiClass: 'PHA.IN.PO.Api',
    AppCode: 'DHCSTPO',
    AppComCode: 'DHCSTCOMMON',
    GetChangedRows: function (domID) {
        return PHA_GridEditor.GetChangedRows(domID);
    },
    Invoke: function (apiMethod, pJson, callback) {
        this.AppendLogonData(pJson);
        PHA.CM(
            {
                pClassName: PO_COM.ApiClass,
                pMethodName: apiMethod,
                pJson: JSON.stringify(pJson)
            },
            function (retData) {
                callback(PO_COM.FmtApiReturn(retData));
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
                pClassName: PO_COM.ApiClass,
                pMethodName: apiMethod,
                pJson: JSON.stringify(pJson)
            },
            false
        );
        var apiRet = PO_COM.FmtApiReturn(retData);
        if (typeof apiRet === 'string') {
            PHA.Alert('��ʾ', apiRet, 'error');
        }
        return apiRet;
    },
    ApiMethods: {
        Save: 'HandleSave',
        Delete: 'HandleDeleteMain',
        Finish: 'HandleFinish',
        FinishCancel: 'HandleFinishCancel',
        DeleteItm: 'HandleDeleteItm',
        DeleteItms: 'HandleDeleteItms',
        Audit: 'HandleAudit',
        AuditCancel: 'HandleAuditCancel',
        AuditRefuse: 'HandleAuditRefuse'
    },
    Fmt2ApiMethod: function (pHandleCode) {
        var apiMethod = this.ApiMethods[pHandleCode];
        if (apiMethod === '') {
            PHA.Alert('��������', pHandleCode + 'û�пɹ����õĳ���');
        }
        return apiMethod;
    },
    GetMainData: function (rowID) {
        return this.InvokeSyn('GetMainData', { rowID: rowID, poID: rowID });
    },
    GetItmData: function (rowID) {
        return this.InvokeSyn('GetItmData', { rowID: rowID, poItmID: rowID });
    },
    GetInciData4Input: function (pJson) {
        return this.InvokeSyn('GetInciData4Input', pJson);
    },
    /**
     * ģ�����
     */
    GetSettings: function () {
        // ����ģʽ����Ҫȫ�ֱ�����
        var appSettings = PHA_COM.ParamProp(PO_COM.AppCode);
        var comSettings = PHA_COM.ParamProp(PO_COM.AppComCode);
        return {
            App: appSettings,
            Com: comSettings,
            DefaultData: {
                startDate: PHA_UTIL.GetDate('t+' + appSettings.DefaStartDate),
                endDate: PHA_UTIL.GetDate('t+' + appSettings.DefaEndDate),
                loc: session['LOGON.CTLOCID']
            }
        };
    },
    TrimDelim: function (str) {
        return str.replace(/-\d*\^/g, '');
    },
    FmtRows4Save: function (pRows) {
        var rows4Save = [];
        pRows.forEach(function (ele) {
            ele.needDate = PHA_UTIL.GetDate('t');
            rows4Save.push(ele);
        });
        return rows4Save;
    },

    QueryMainGrid: function (domID, pJson) {
        var $grid = $('#' + domID);
        if(!pJson || pJson == undefined) return;
        var pJsonStr = JSON.stringify(pJson).replace(/-q/g, '');
        $grid.datagrid('options').url = PHA.$URL;
        $grid.datagrid('query', {
            pClassName: PO_COM.ApiClass,
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
            pClassName: PO_COM.ApiClass,
            pMethodName: 'GetItmDataRows',
            pJson: pJsonStr,
            pPlug: 'datagrid'
        });
    },
    ValidateGridData: function (data) {
        return PHA_COM.ValidateGridData(data);
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
    FmtApiReturn: function (retData) {
        if (retData.success === 0 || retData.code < 0) {
            return PO_COM.TrimDelim(retData.msg);
        }
        return retData;
    },
    FmtApiInput: function (retData) {},
    /**
     * ��������̨�ĳ���׷��session��Ϣ, ����ȡ����sessionʱ, �Դ�Ϊ׼
     * ���������Ҫ��ӭ�Ϻ�̨������session, ��session���ԺܷѾ�
     * �����ڷ��գ������Ǹ�����Ե��ˣ�ֱ���޸���session, ��������
     * @todo broker.cls ������ session��֤
     * @param {} jsonObj
     */
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
            case 'pha.in.v3.po.audit.csp':
                PHA_COM.ResizePanel({
                    layoutId: 'layout-po-audit',
                    region: 'north',
                    height: 0.5
                });
                break;
            case 'pha.in.v3.po.query.csp':
                PHA_COM.ResizePanel({
                    layoutId: 'layout-po-query',
                    region: 'north',
                    height: 0.5
                });
                break;
            case 'pha.in.v3.po.create.csp':
                PHA_COM.SetPanel('#layout-po-create-panel', $('#layout-po-create-panel').panel('options').title);
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
    LoadData: function (domID, qJson) {
        qJson.pClassName = REC_COM.ApiClass;
        PHA_COM.LoadData(domID, qJson);
    },
    GridFinalDone: function (target) {
        PHA_GridEditor.GridFinalDone(target, 'inciCode');
    },
    ValidatePrice: function (val) {
        var msg = '��������ڻ����0������'
        if (_.isLikeNumber(val) === false) {
            return msg;
        }
        if (parseFloat(val) < 0) {
            return msg;
        }
        return true;
    },
    ValidateQty: function (val) {
        var msg = '���������0������'
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
    Copy: function (pJson, callback) {
        PO_COM.Invoke('HandleCopy', pJson, function (retData) {
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
    Print: function (poID) {
        if (poID === '') {
            PHA.Popover({
                msg: '����ѡ����Ҫ��ӡ�ĵ���',
                type: 'info'
            });
            return;
        }
        PO_PRINT.Print(poID);
        return;
        // ������xmlģ����ʽ
        var printStyle = PHA_COM.PrintStyle;
        PRINTCOM.XML({
            printBy: 'lodop',
            XMLTemplate: 'PHAINPO',
            dataOptions: {
                ClassName: 'PHA.IN.PO.Api',
                MethodName: 'GetPrintData',
                pJsonStr: JSON.stringify({
                    poID: poID,
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
            aptListFields: printStyle.FixListFields(['printInfo', 'createUserName', 'auditUserName']),
            // ����ҳǩ��
            endPageFields: printStyle.FixListFields(['printInfo', 'createUserName', 'auditUserName'])
        });
    }
};

