/**
 * �˻� - �Ƶ�
 * @creator �ƺ���
 * @todo    - �龫һ��֤
 *          - ҩƷ�س�������������֤����������
 *          - ���ۻ�Ʊ�������˻�������, ��һ����ѡ���Ƕ��һ����
 *          - ����ʾ���Ϊ0��ҩƷ, ����ʾ���Ϊ��ľ�Ӫ��ҵ
 *          - �˻�������Ϊ�ջ�С��0, �Ҳ��ܴ����˻�����
 *          - ��Ʊ�� ��Ʊ����ͬʱ¼��, ����ɶ��
 *          - ����ʱ, Ҳ��֤���, ���ǲ���˵ ,����������, �ȱ�����
 *          - �ӿ�
 *              HRP
 *          - �������, �˻�ûɶ�����������
 */

$(function () {
    var biz = {
        data: {
            retID: '',
            status: 'SAVE',
            handleStatus: '',
            keepInputFields: ['stkCatGrp', 'stkCatGrpDesc'],
            keepInputFlag: true,
            defaultData: [
                {
                    loc: session['LOGON.CTLOCID']
                }
            ]
        },
        getData: function (key) {
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;
            switch (key) {
                case 'retID':
                    Select(data);
                    break;
                case 'status':
                    if (data === '') {
                        this.data[key] = 'SAVE';
                    }
                    ControlOperation();
                    break;
                case 'operateType':
                    $('#operateType').combobox('setValue', data);
                    break;
                default:
                    break;
            }
        }
    };
    /**
     * ��ʼ��
     */
    var components = RET_COMPONENTS();
    var com = RET_COM;
    var settings = com.GetSettings();
    components('Loc', 'loc');
    components('StkCatGrp', 'stkCatGrp');
    components('PurchUser', 'purchUser');
    components('Vendor', 'vendor');
    components('Date', 'createDate');
    components('Banner', 'retBanner');

    components('OperateType', 'operateType', {}, function (rows) {
        rows.forEach((element) => {
            if (element.DefaultFlag === 'Y') {
                biz.setData('operateType', element.RowId);
            }
        });
    });
    components('Remarks', 'remarks');
    var rebuildColumns = PHA_COM.RebuildColumns(components('ItmGridColmuns', 'gridItm'), {
        banFields: [settings.App.AllowModifyRp === 'Y' ? '' : 'rp', settings.App.AllowModifySp === 'Y' ? '' : 'sp']
    });

    components('ItmGrid', 'gridItm', {
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns,
        toolbar: '#gridItmBar',
        rownumber: true,
        pagination: false,
        showFooter: true,
        data: {
            rows: [],
            footer: [{ inciCode: '�ϼ�' }],
            total: 0
        },
        onNextCell: function (index, field, value, isLastRow, isLastCol) {
            if (isLastRow && isLastCol) {
                $('#btnAddItm').trigger('click-i');
            }
        },
        onClickCell: function (index, field, value) {
            if (CanEdit() === false) {
                return;
            }
            PHA_GridEditor.Edit({
                gridID: 'gridItm',
                index: index,
                field: field,
                forceEnd: true
            });
            let target = $('#gridItm').datagrid('getEditor', { index: index, field: 'inciDesc' }).target;
            $(target).lookup('disable');
            $(target).unbind();
        },
        onAfterEdit: function (rowIndex, rowData, changes) {
            // ����ǵ������, ����Ҫ�����˴�
            if (biz.getData('Saving') === true) {
                return;
            }
            if (PHA_GridEditor.IsRowChanged('#gridItm', rowIndex) === true && (rowData.recItmID || '') !== '') {
                // �����͸ı���ļ�¼��Ҫ��֤
                ValidateSave(rowData, rowIndex);
                // У���ظ�
                CheckDistinct();
                com.SumGridFooter('#' + this.id);
            }
        },
        onRecBatWinClose: function () {
            var changedIndexArr = $('#gridItm').datagrid('options').recBatRowIndexArr;
            var firstRowIndex = changedIndexArr[0] - 1;
            var defaultRowData = GetRowData4KeyToolInput('#gridItm', firstRowIndex);
            for (var i = 0, length = changedIndexArr.length; i < length; i++) {
                $('#gridItm').datagrid('updateRow', {
                    index: changedIndexArr[i],
                    row: defaultRowData
                });
            }
        },
        onLoadSuccess: function () {
            var gridID = this.id;
            PHA_GridEditor.End(gridID);
            RET_COM.SumGridFooter(gridID);
            $(this).datagrid('clearChecked');
            ControlConditionState();
        }
    });

    PHA_EVENT.Bind('#btnSelect', 'click', function () {
        components('QueryWindow', 'winQueryRet', {
            onClose: function () {
                HandleWindowData('winQueryRet');
            }
        });
    });
    PHA_EVENT.Bind('#btnAddItm', 'click', function () {
        var changeLen = com.GetChangedRows('gridItm').length;
        if (changeLen >= (settings.App.MaxRows4Create || 5)) {
            components('Pop', '�뼰ʱ��������');
        }
        AddRow();
    });
    PHA_EVENT.Bind('#btnDeleteItm', 'click', function () {
        biz.setData('handleStatus', 'DeleteItm');

        DeleteChecked();
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        biz.setData('retID', '');
        biz.setData('status', 'SAVE');
        ControlConditionState();
        SetDefaults();
    });
    PHA_EVENT.Bind('#btnSave', 'click', function () {
        biz.setData('handleStatus', 'Save');
        biz.setData('Saving', true);
        Save();
        biz.setData('Saving', false);
    });
    PHA_EVENT.Bind('#btnFinish', 'click', function () {
        biz.setData('handleStatus', 'Finish');
        biz.setData('Saving', true);
        Save();
        biz.setData('Saving', false);
    });
    PHA_EVENT.Bind('#btnFinishCancel', 'click', function () {
        biz.setData('handleStatus', 'FinishCancel');
        Save();
    });
    PHA_EVENT.Bind('#btnDelete', 'click', function () {
        biz.setData('handleStatus', 'Delete');

        Delete();
    });

    PHA_EVENT.Bind('#btnPrint', 'click', function () {
        com.Print(biz.getData('retID'));
    });
    PHA_EVENT.Bind('#btnSelectRec', 'click', function () {
        websys_showModal({
            id: 'pha_in_v3_ret_createbyrec_win',
            url: 'pha.in.v3.ret.createbyrec.csp',
            title: 'ѡȡ��ⵥ',
            width: PHA_COM.Window.Width(),
            height: PHA_COM.Window.Height(),
            top : (screen.availHeight - PHA_COM.Window.Height())/2,
            left : (screen.availWidth  - PHA_COM.Window.Width())/2,
            closable: true,
            onClose: function () {
                LoadCopyGo();
            }
        });
    });
    function HandleWindowData(winID) {
        var retData = $.data($('#' + winID)[0], 'retData');
        retData = retData || {};
        var retID = retData.retID || '';
        if (retID === '') {
            return;
        }
        biz.setData('keepInputFlag', false);

        var type = retData.type || '';
        if (type === '') {
            biz.setData('retID', retID);
            return;
        }
        if (type === 'copy' || type === 'mould') {
            biz.setData('retID', '');
            com.Copy({ retID: retID }, function (retData) {
                com.SetKeyValue2Null(retData.main, biz.getData('keepInputFields'));
                if (retData.main.retID !== '') {
                    // ��ֱ̨�Ӹ��Ƶ���
                    biz.setData('retID', retID);
                    return;
                }
                if (type === 'copy') {
                    retData.main.dataLinkFrom = retID;
                }
                PHA.SetVals([retData.main]);
                var rows = retData.rows;
                PHA_GridEditor.LoadChangedRows('#gridItm', { total: rows.length, rows: rows });
            });
            biz.setData('status', 'SAVE');
        }
    }
    function Save() {
        var apiMethod = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (apiMethod === '') {
            return;
        }

        // com.GridFinalDone('#gridItm');
        PHA_GridEditor.DeleteNullRow('#gridItm', ['inciCode']);

        if (biz.getData('handleStatus') !== 'FinishCancel') {
            if (ValidateEditGrid() === false) {
                return;
            }
            // ��̨У��
            if (ValidateSave() === false) {
                return;
            }
        }
        var mainObj = com.Condition('#qCondition', 'get', { dotype: 'save' });
        if (mainObj === undefined) {
            return;
        }
        mainObj.retID = biz.getData('retID');
        mainObj.mainRowID = biz.getData('retID');
        mainObj.statusCode = biz.getData('handleStatus');

        var rows = [];
        for (const it of com.GetChangedRows('gridItm')) {
            var rowData = $.extend({}, it);
            rows.push(rowData);
        }
        var data4save = {
            main: mainObj,
            rows: rows
        };
        PHA.Loading('Show');
        com.Invoke(apiMethod, data4save, function (retData) {
            PHA.Loading('Hide');
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                biz.setData('retID', retData.data);
            }
        });
    }

    function ValidateEditGrid() {
        var val = true;
        var msg = '';
        try {
            // if (!PHA_GridEditor.EndCheck('gridItm')) {
            //     throw '';
            // }
            // msg = PHA_GridEditor.CheckValues('gridItm');
            // if (msg !== '') {
            //     throw msg;
            // }
            // msg = PHA_GridEditor.CheckDistinct({ gridID: 'gridItm', fields: ['recItmID'] }); // ����
            // if (msg !== '') {
            //     throw msg + ' ( ����¼ )';
            // }
            // if (ValidateSave() === false) {
            //     throw '';
            // }
            if ($('#gridItm').datagrid('getRows').length == 0) {
                throw 'û����Ҫ����������';
            }
        } catch (error) {
            val = false;
            msg = error;
        } finally {
            if (msg !== '' && typeof msg === 'string') {
                components('Pop', msg);
            }
            return val;
        }
    }
    function CheckDistinct() {
        var distinctFields = $('#gridItm').datagrid('options').distinctFields;
        var distinctMsg = PHA_GridEditor.CheckDistinct({ gridID: 'gridItm', fields: distinctFields });
        if (distinctMsg !== '') {
            components('Pop', distinctMsg + '������¼��ͬ');
            return false;
        }
        return true;
    }
    function ValidateSave(rowData, rowIndex) {
        var mainObj = com.Condition('#qCondition', 'get', { dotype: 'save' });
        if (mainObj === undefined) {
            return;
        }
        mainObj.retID = biz.getData('retID');
        mainObj.mainRowID = biz.getData('retID');

        var rows = [];
        if (rowData === undefined) {
            var forRows = $('#gridItm').datagrid('getRows');
            for (const it of forRows) {
                var rowData = $.extend({}, it);
                rows.push(rowData);
            }
        } else {
            rowData.rowIndex = rowIndex;
            rows.push(rowData);
        }
        // ��Ч��, ������ǰ̨����ǰ�����
        var valRet = RET_COM.InvokeSyn('ValidateSave', {
            main: mainObj,
            rows: rows
        });
        if (valRet.type !== '') {
            PHA.Warn2Grid('#gridItm', { warnInfo: valRet });
            if (rowIndex === undefined) {
                // ������������
                PHA.ShowWarn({ warnInfo: valRet });
                if (valRet.type === 'terminate') {
                    return false;
                }
            }
        }
        return true;
    }
    function Delete(warnMsg) {
        var retID = biz.getData('retID');
        if (retID === '') {
            components('Pop', 'û����Ҫɾ������Ϣ');
            return;
        }

        PHA.Confirm('��ʾ', warnMsg || '��ȷ��ɾ��������?', function () {
            com.Invoke(com.Fmt2ApiMethod('Delete'), { retID: retID }, function (retData) {
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
                    components('Pop', 'ɾ���ɹ�');
                    $('#btnClean').trigger('click-i');
                }
            });
        });
    }
    function AddRow() {
        if (CanAddRow() === false) {
            return;
        }
        var rows = $('#gridItm').datagrid('getRows');
        if (rows.length > 0) {
            var recItmID = rows[rows.length - 1].recItmID || '';
            // ���һ����Ч, ֱ�Ӷ�λ�༭
            if (recItmID === '') {
                PHA_GridEditor.Edit({
                    gridID: 'gridItm',
                    index: rows.length - 1,
                    field: 'inciDesc',
                    forceEnd: true
                });
                return;
            }
        }
        PHA_GridEditor.Add({
            gridID: 'gridItm',
            field: 'inciDesc'
        });
        ControlConditionState();
    }

    function DeleteChecked() {
        var $grid = $('#gridItm');
        var checkedRows = $grid.datagrid('getChecked');
        if (checkedRows.length === 0) {
            components('Pop', '�빴ѡ��Ҫɾ���ļ�¼');
            return;
        }
        var retItmArr = [];
        for (const rowData of checkedRows) {
            var retItmID = rowData.retItmID || '';
            if (retItmID !== '') {
                retItmArr.push(com.AppendLogonData({ retItmID: retItmID }));
            }
        }

        PHA.Confirm('��ʾ', '��ȷ��ɾ�� ' + checkedRows.length + ' ����ϸ��?', function () {
            PHA.Loading('Show');
            if (retItmArr.length > 0) {
                // һ��������, һ��ûɶ����
                com.InvokeSyn(com.Fmt2ApiMethod('DeleteItms'), { rows: retItmArr }, function (retData) {
                    PHA.Loading('Hide');
                    if (typeof retData === 'string') {
                        PHA.Alert('', retData, 'warning');
                        return;
                    }
                });
            }
            var rows = $grid.datagrid('getRows');
            for (const chkit of checkedRows) {
                var rowIndex = rows.indexOf(chkit);
                $('#gridItm').datagrid('deleteRow', rowIndex);
            }
            com.SumGridFooter('#gridItm');
            PHA.Loading('Hide');
            components('Pop', 'ɾ���ɹ�');
            $('#gridItm').datagrid('clearChecked');
            ControlConditionState();
            if ($('#gridItm').datagrid('getRows').length === 0 && biz.getData('retID') !== '') {
                Delete('��ϸ�Ѿ�û�м�¼�����Ƿ�ͬʱɾ���˵��ݣ�');
            }
        });
    }

    function Select(retID) {
        if (retID === '') {
            $('#retBanner').phabanner('reset');
            $('#gridItm').datagrid('clear');
            return;
        }
        var data = com.GetMainData(retID);
        if (typeof data === 'string') {
            return;
        }
        data.loc = {
            RowId: data.loc,
            Description:data.locDesc,
            Select: false
        }
        if (biz.getData('keepInputFlag') === true) {
            com.DeleteJsonKeys(data, biz.getData('keepInputFields'));
        }else{
            com.SetKeyValue2Null(data, biz.getData('keepInputFields'));
        }
        biz.setData('keepInputFlag', true);
        PHA.SetVals([data]);
        components('Banner', 'retBanner', data);
        com.QueryItmGrid('gridItm', { retID: retID });
        biz.setData('status', data.status);
    }
    function CanEdit() {
        if (biz.getData('status') !== 'SAVE') {
            return false;
        }
        return true;
    }
    function CanAddRow() {
        if (CanEdit() === false) {
            return false;
        }
        var data = com.Condition('#qCondition', 'get', { doType: 'save' });
        if (data === undefined) {
            return false;
        }
        if (settings.Com.StkCatSet === 'N' && $('#stkCatGrp').combobox('getValues').toString() === '') {
            components('Pop', '���飬����Ϊ��', 'alert');
            return false;
        }
        return true;
    }

    function ControlConditionState() {
        if ($('#gridItm').datagrid('getRows').length > 0) {
            $('#vendor').combobox('disable');
            $('#loc').combobox('disable');
        } else {
            $('#vendor').combobox('enable');
            $('#loc').combobox('enable');
        }
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
        $('#operateType').combobox('reload');
        $('#stkCatGrp').combobox('reload');
    }
    function ControlOperation() {
        com.ControlOperation({
            '#btnDelete': {
                disabled: biz.getData('retID') === '' || biz.getData('status') !== 'SAVE'
            },
            '#btnAddItm': {
                disabled: biz.getData('status') !== 'SAVE'
            },
            '#btnModify': {
                disabled: biz.getData('status') !== 'SAVE'
            },
            '#btnPrint': {
                disabled: biz.getData('retID') === ''
            },
            '#btnDeleteItm': {
                disabled: biz.getData('status') !== 'SAVE'
            },
            '#btnFinish': {
                disabled: biz.getData('status') !== 'SAVE',
                hide: biz.getData('status') !== 'SAVE'
            },
            '#btnFinishCancel': {
                disabled: biz.getData('status') !== 'COMP',
                hide: biz.getData('status') == 'SAVE'
            },
            '#btnExport': {
                disabled: biz.getData('retID') === ''
            },
            '#btnSave': {
                disabled: biz.getData('status') !== 'SAVE'
            }
        });
    }
    function LoadCopyGo() {
        var topRetData = PHA_COM.TOP.Get('pha.in.v3.ret.create.csp_copy', true);
        if (topRetData !== '') {
            $('#btnClean').trigger('click-i');
            PHA.SetVals([topRetData.main]);
            var rows = topRetData.rows;
            PHA_GridEditor.LoadChangedRows('#gridItm', { total: rows.length, rows: rows });
        }
    }
    function GetRowData4KeyToolInput(target, rowIndex) {
        let retObj = {};
        if (rowIndex < 0) {
            return retObj;
        }
        const rows = $(target).datagrid('getRows');
        if (rows.length === 0) {
            return retObj;
        }
        const rowData = rows[rowIndex];
        for (const iterator of $('#keyToolInput').keywords('getSelected')) {
            if (iterator.id === 'reason') {
                retObj.reason = rowData.reason;
                retObj.reasonDesc = rowData.reasonDesc;
            }
        }
        return retObj;
    }

    setTimeout(function () {
        if (settings.Com.StkCatSet === 'Y') {
            PHA.DataPha.Set('stkCatGrp', { required: false });
        }
        $.extend(biz.getData('defaultData')[0], settings.App.DefaultData);
        SetDefaults();
        ControlOperation();
        $('body').on('click', function () {
            $('.tooltip').hide();
        });
        PHA.SetRequired($('#qCondition [data-pha]'));
        com.SetPage('pha.in.v3.ret.create.csp');
        var topRetID = com.Top.Get('retID', true);
        if (topRetID !== '') {
            biz.setData('retID', topRetID);
        }
        RET_QUICKMODIFY('gridItm', components, com);
        LoadCopyGo();
    }, 0);
});