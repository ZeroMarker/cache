/**
 * �˻� - ����
 * @creator �ƺ���
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
                callback('���ʴ���');
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
            PHA.Alert('��ʾ', apiRet, 'error');
        }
        return apiRet;
    },
    Fmt2ApiMethod: function (pHandleCode) {
        var apiMethod = this.ApiMethods[pHandleCode];
        if (apiMethod === '') {
            PHA.Alert('��������', pHandleCode + 'û�пɹ����õĳ���');
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
     * ���ɴ���ĳ��ģ���ҳ����ؿ���, ��Щ�Ķ�����Ҫÿ�����涼����, �����߶ȵ�
     * @param {} cspName ҳ��cspȫ��
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
                var ret = top.PHA_IN_RET[key] || ''; // ��������Ҫ���
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
            return '����������';
        }
        if (parseFloat(val) < 0) {
            return '��������ڻ����0������';
        }
        return true;
    },
    ValidateQty: function (val) {
        if (_.isLikeNumber(val) === false) {
            return '����������';
        }
        if (parseFloat(val) <= 0) {
            return '����: ���������0������';
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
                msg: '����ѡ����Ҫ��ӡ�ĵ���',
                type: 'info'
            });
            return;
        }
        RET_PRINT.Print(retID);
        return;
        // ������xmlģ����ʽ
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

