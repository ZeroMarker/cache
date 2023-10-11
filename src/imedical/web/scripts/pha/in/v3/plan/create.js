/**
 * �ɹ��ƻ� - �Ƶ�
 * @creator �ƺ���
 */
var tipFlag = "";
$(function () {
    var biz = {
        data: {
            planID: '',
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
            switch (key) {
                case 'mouldFlag':
                    return $('#mouldFlag').checkbox('getValue');
                default:
                    break;
            }
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;
            switch (key) {
                case 'planID':
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
    var components = PLAN_COMPONENTS();
    var com = PLAN_COM;
    var settings = com.GetSettings();
    components('Loc', 'loc');
    components('StkCatGrp', 'stkCatGrp');
    components('Inci', 'inci');
    components('Vendor', 'vendor');
    components('Banner', 'planBanner');
    components('Remarks', 'remarks');
    components('OperateType', 'operateType', {}, function (rows) {
        rows.forEach(function (element) {
            if (element.DefaultFlag === 'Y') {
                biz.setData('operateType', element.RowId);
            }
        });
    });
    components('ItmGrid', 'gridItm', {
        toolbar: '#gridItmBar',
        pagination: false,
        showFooter: true,
        isAutoShowPanel: false,
        rownumbers: true,
        data: {
            rows: [],
            footer: [],
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
            tipFlag = "";
            PHA_GridEditor.Edit({
                gridID: 'gridItm',
                index: index,
                field: field,
                forceEnd: true
            });
        },
        onLoadSuccess: function () {
            $(this).datagrid('clearChecked');
            com.SumGridFooter('#' + this.id, ['rpAmt', 'spAmt']);
        },
        onAfterEdit: function (rowIndex, rowData, changes) {
            // ֱ�ӵ������ʱ, ����Ҫ��������һ�е���֤
            if(tipFlag != "") return;
            if (PHA_GridEditor.IsRowChanged('#gridItm', rowIndex) === true) {
                // �����͸ı���ļ�¼��Ҫ��֤
                ValidateSave(rowData, rowIndex);
                // У���ظ�, һ�㱾�ؼ���
                var distinctFields = $(this).datagrid('options').distinctFields;
                var distinctMsg = PHA_GridEditor.CheckDistinct({ gridID: 'gridItm', fields: distinctFields });
                if (distinctMsg !== '') {
                    components('Pop', distinctMsg + '��ҩƷ��������ҵ����Ӫ��ҵ���깺���ң�������ȫ��ͬ');
                }
                com.SumGridFooter('#' + this.id, ['rpAmt', 'spAmt']);
            }
        },
        singleSelect: true,
        shiftCheck: true,
        singleSelect: true,
        checkOnSelect: false,
        distinctFields: ['inciCode', 'manf', 'vendor', 'reqLoc']
    });
    /**
     * ע���¼�
     */
    PHA_EVENT.Bind('#btnSelect', 'click', function () {
        components('FindPlanWindow', 'winFindPlan', {
            onClose: function () {
                HandleWindowData('winFindPlan');
            }
        });
    });
    PHA_EVENT.Bind('#btnSelectMould', 'click', function () {
        components('FindPlanMouldWindow', 'winFindPlanMould', {
            onClose: function () {
                HandleWindowData('winFindPlanMould');
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
    PHA_EVENT.Bind('#btnCreateByStock', 'click', function () {
        websys_showModal({
            id: 'pha_in_v3_plan_createbystock_win',
            url: 'pha.in.v3.plan.createbystock.csp',
            title: '�����Ƶ� / ���ݱ�׼���',
            width: PHA_COM.Window.Width(),
            height: PHA_COM.Window.Height(),
            top : (screen.availHeight - PHA_COM.Window.Height())/2,
            left : (screen.availWidth  - PHA_COM.Window.Width())/2,
            closable: true,
            iconCls: "icon-w-list",
            onClose: function () {
                LoadCopyGo();
            }
        });
    });
    PHA_EVENT.Bind('#btnCreateByConsume', 'click', function () {
        websys_showModal({
            id: 'pha_in_v3_plan_createbyconsume_win',
            url: 'pha.in.v3.plan.createbyconsume.csp',
            title: '�����Ƶ� / ��������',
            width: PHA_COM.Window.Width(),
            height: PHA_COM.Window.Height(),
            top : (screen.availHeight - PHA_COM.Window.Height())/2,
            left : (screen.availWidth  - PHA_COM.Window.Width())/2,
            closable: true,
            iconCls: "icon-w-list",
            onClose: function () {
                LoadCopyGo();
            }
        });
    });
    PHA_EVENT.Bind('#btnDeleteItm', 'click', function () {
        biz.setData('handleStatus', 'DeleteItms');
        DeleteChecked();
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        biz.setData('planID', '');
        biz.setData('status', 'SAVE');
        SetDefaults();
    });
    PHA_EVENT.Bind('#btnSave', 'click', function () {
        biz.setData('handleStatus', 'Save');
        Save();
    });
    PHA_EVENT.Bind('#btnSaveAsMould', 'click', function () {
        biz.setData('handleStatus', 'SaveAsMould');
        SaveAsMould();
    });
    PHA_EVENT.Bind('#btnFinish', 'click', function () {
        biz.setData('handleStatus', 'Finish');
        Save();
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
        com.Print(biz.getData('planID'));
    });

    function HandleWindowData(winID) {
        var retData = $.data($('#' + winID)[0], 'retData');
        retData = retData || {};
        var planID = retData.planID || '';
        if (planID === '') {
            return;
        }
        biz.setData('keepInputFlag', false);
        var type = retData.type || '';
        if (type === '') {
            biz.setData('planID', planID);
            return;
        }
        if (type === 'copy' || type === 'mould') {
            biz.setData('planID', '');
            com.Copy({ planID: planID }, function (retData) {
                retData.main.mouldFlag = 'N';
                com.SetKeyValue2Null(retData.main, biz.getData('keepInputFields'));
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
        tipFlag = "1";
        PHA_GridEditor.DeleteNullRow('#gridItm', ['inciCode']);

        // �ݲ�ʹ��
        // if ($('.pha-datagrid-validate-col').length > 0) {
        //     components('Pop', '���Ƚ�����е�δУ��ͨ�������ݴ������');
        //     return
        // }
        // �����༭ & ǰ̨У��
        if (ValidateEditGrid() === false) {
            return;
        }
        // ��̨У��
        if (ValidateSave() === false) {
            return;
        }
        var mainObj = com.Condition('#qCondition', 'get', { doType: 'save' });
        if (mainObj === undefined) {
            return;
        }
        mainObj.planID = biz.getData('planID');
        mainObj.mainRowID = biz.getData('planID');
        mainObj.statusCode = biz.getData('handleStatus');
        var rows = [];
        com.GetChangedRows('gridItm').forEach(function (it) {
            var rowData = $.extend({}, it);
            rows.push(rowData);
        });

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
                biz.setData('planID', retData.data);
            }
        });
    }
    function SaveAsMould() {
        var apiMethod = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (apiMethod === '') {
            return;
        }
        com.GridFinalDone('#gridItm');
        // �����༭
        if (ValidateEditGrid() === false) {
            return;
        }
        var mainObj = com.Condition('#qCondition', 'get', { doType: 'save' });
        if (mainObj === undefined) {
            return;
        }
        mainObj.planID = '';
        mainObj.mainRowID = '';
        mainObj.statusCode = biz.getData('handleStatus');
        mainObj.mouldFlag = 'Y';
        var rows = [];
        for (const it of $('#gridItm').datagrid('getRows')) {
            var rowData = $.extend({}, it);
            rowData.planID = '';
            rowData.planItm = '';
            rowData.planItmID = '';
            rows.push(rowData);
        }
        if (rows.length > 0) {
            var msg = '��ȷ�ϱ���Ϊģ����?';
            var mouldFlag = biz.getData('mouldFlag');
            if (mouldFlag === true) {
                msg = '��ǰ�����Ѿ�Ϊģ��, ��ȷ�ϻ���Ҫ�����Ϊ�µ�ģ����?';
            }
            PHA.Confirm('��ʾ', msg, function () {
                var data4save = {
                    main: mainObj,
                    rows: rows
                };
                // ����
                com.Invoke(apiMethod, data4save, function (retData) {
                    if (typeof retData === 'string') {
                        PHA.Alert('', retData, 'warning');
                    } else {
                        components('Pop', '���ģ��ɹ�');
                        // PHA.Confirm('��ʾ', '���ģ��ɹ�, �Ƿ�����ģ�岢�޸�? </br>��ȷ����������ģ������޸� </br>��ȡ�����������޸�ԭ����', function () {
                        biz.setData('planID', retData.data);
                        // });
                    }
                });
            });
        }
    }
    function ValidateEditGrid() {
        var val = true;
        var msg = '';
        try {
            // ��֤����
            if (!PHA_GridEditor.EndCheck('gridItm')) {
                throw '';
            }
            // û��Ҫ, ��ʱ��ȫ�ɺ�̨��֤
            // msg = PHA_GridEditor.CheckValues('gridItm');
            // if (msg !== '') {
            //     throw msg;
            // }
            // msg = PHA_GridEditor.CheckDistinct({ gridID: 'gridItm', fields: ['inci', 'manf'] });
            // if (msg !== '') {
            //     throw msg + ' ( ҩƷ & ������ҵ )';
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
    /// ��֤���в�����ʾ, ���뱣���alert|pop�����ڳ�ͻ
    function ValidateSave(rowData, rowIndex) {
        var mainObj = com.Condition('#qCondition', 'get', { dotype: 'save' });
        if (mainObj === undefined) {
            return;
        }
        mainObj.planID = biz.getData('planID');
        mainObj.mainRowID = biz.getData('planID');

        var rows = [];
        if (rowData === undefined) {
            var forRows = $('#gridItm').datagrid('getRows');
            forRows.forEach(function (it) {
                var forRow = $.extend({}, it);
                rows.push(forRow);
            });
        } else {
            rowData.rowIndex = rowIndex;
            if ((rowData.inciCode || '') === '') {
                return true;
            }
            rows.push(rowData);
        }
        // �첽ֻ����΢����ôһ��, ���Ǹ��ܲ�����
        var valRet = PLAN_COM.InvokeSyn('ValidateSave', {
            main: mainObj,
            rows: rows
        });
        if (valRet.type !== '') {
            
            if (rowIndex === undefined) {
                // ������������
                PHA.ShowWarn({ warnInfo: valRet });
                if (valRet.type === 'terminate') {
                    return false;
                }
            }else{
                PHA.Warn2Grid('#gridItm', { warnInfo: valRet });
                return false;
            }
        }
        return true;
    }
    function Delete(warnMsg) {
        var planID = biz.getData('planID') || '';
        if (planID === '') {
            components('Pop', 'û����Ҫɾ������Ϣ');
            return;
        }

        PHA.Confirm('��ʾ', warnMsg || '��ȷ��ɾ��������?', function () {
            com.Invoke(com.Fmt2ApiMethod('Delete'), { planID: planID }, function (retData) {
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
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
            var inciCode = rows[rows.length - 1].inciCode || '';
            // ���һ����Ч, ֱ�Ӷ�λ�༭
            if (inciCode === '') {
                PHA_GridEditor.Edit({
                    gridID: 'gridItm',
                    index: rows.length - 1,
                    field: 'inci',
                    forceEnd: true
                });
                return;
            }
        }
        PHA_GridEditor.End('gridItm');
        var rowIndex = $('#gridItm').datagrid('getRows').indexOf($('#gridItm').datagrid('getSelected'));
        if (rowIndex < 0) {
            rowIndex = $('#gridItm').datagrid('getRows').length - 1;
        }
        var defaultRowData = GetDefaultRowData('#gridItm', rowIndex);
        PHA_GridEditor.Add({
            gridID: 'gridItm',
            field: 'inci',
            rowData: defaultRowData
        });
    }
    function DeleteChecked() {
        var $grid = $('#gridItm');
        var checkedRows = $grid.datagrid('getChecked');
        if (checkedRows.length === 0) {
            components('Pop', '�빴ѡ��Ҫɾ���ļ�¼');
            return;
        }
        var planItmArr = [];
        for (const rowData of checkedRows) {
            var planItmID = rowData.planItmID || '';
            if (planItmID !== '') {
                planItmArr.push(com.AppendLogonData({ planItmID: planItmID }));
            }
        }

        PHA.Confirm('��ʾ', '��ȷ��ɾ�� ' + checkedRows.length + ' ����ϸ��?', function () {
            PHA.Loading('Show');
            if (planItmArr.length > 0) {
                // һ��������, һ��ûɶ����
                com.InvokeSyn(com.Fmt2ApiMethod('DeleteItms'), { rows: planItmArr }, function (retData) {
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
            if ($('#gridItm').datagrid('getRows').length === 0 && biz.getData('planID') !== '') {
                Delete('��ϸ�Ѿ�û�м�¼�����Ƿ�ͬʱɾ���˵��ݣ�');
            }
        });
    }

    function Select(planID) {
        if (planID === '') {
            $('#planBanner').phabanner('reset');
            $('#gridItm').datagrid('clear');
            return;
        }
        var data = com.GetMainData(planID);
        if (biz.getData('keepInputFlag') === true) {
            com.DeleteJsonKeys(data, biz.getData('keepInputFields'));
        }else{
            com.SetKeyValue2Null(data, biz.getData('keepInputFields'));
        }
        biz.setData('keepInputFlag', true);
        PHA.SetVals([data]);
        components('Banner', 'planBanner', data);
        biz.setData('status', data.status);
        com.QueryItmGrid('gridItm', { planID: planID });
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

    function ControlOperation() {
        com.ControlOperation({
            '#btnDelete': {
                disabled: biz.getData('planID') === '' || biz.getData('status') !== 'SAVE'
            },
            '#btnAddItm': {
                disabled: biz.getData('status') !== 'SAVE'
            },
            '#btnPrint': {
                disabled: biz.getData('planID') === ''
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
                disabled: biz.getData('planID') === ''
            },
            '#btnSave': {
                disabled: biz.getData('status') !== 'SAVE'
            }
        });
    }
    function GetDefaultRowData(target, rowIndex) {
        let retObj = {};
        const rows = $(target).datagrid('getRows');
        if (rows.length === 0) {
            return retObj;
        }
        rowIndex = isNaN(rowIndex) ? rows.length - 1 : rowIndex; // ��һ��
        const rowData = rows[rowIndex];
        for (const iterator of $('#keyToolInput').keywords('getSelected')) {
            if (iterator.id === 'DefaultReqLoc') {
                retObj.reqLoc = rowData.reqLoc;
                retObj.reqLocDesc = rowData.reqLocDesc;
            }
        }
        return retObj;
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
        $('#operateType').combobox('reload');
        $('#stkCatGrp').combobox('reload');
    }

    function LoadCopyGo() {
        var topPlanData = PHA_COM.TOP.Get('pha.in.v3.plan.create.csp_copy', true);
        if (topPlanData !== '') {
            $('#btnClean').trigger('click-i');
            topPlanData.main.mouldFlag = 'N';
            PHA.SetVals([topPlanData.main]);
            var rows = topPlanData.rows;
            PHA_GridEditor.LoadChangedRows('#gridItm', { total: rows.length, rows: rows });
        }
    }
    setTimeout(function () {
        if (settings.Com.StkCatSet === 'Y') {
            PHA.DataPha.Set('stkCatGrp', { required: false });
        }
        $.extend(biz.getData('defaultData')[0], settings.DefaultData);
        SetDefaults();
        ControlOperation();
        $('body').on('click', function () {
            $('.tooltip').hide();
        });
        com.SetPage('pha.in.v3.plan.create.csp');
        var topPlanID = com.Top.Get('planID', true);
        // topPlanID = 5;
        if (topPlanID !== '') {
            biz.setData('planID', topPlanID);
        }
        LoadCopyGo();
    }, 0);
});
