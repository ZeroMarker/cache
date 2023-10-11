/**
 * 入库 - 制单
 * @creator 云海宝
 * @todo    - 麻精一的验证
 *              所选经营企业是否居右麻精权限, 最后保存验证即可, 没必要每行都验证
 *          - 云平台\供应链接口\HRP接口, 基本功能没问题再处理
 *          - 入库调价功能暂不提供
 *          - 历史入库记录
 *              免费药的价格直接不允许修改, 且固定为0, 是否免费取决于免费药标志, 与捐赠无关
 */

$(function () {
    /**
     * 内部全局, 数据变化全部通过set给值
     */
    var biz = {
        data: {
            recID: '',
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
                case 'recID':
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
     * 初始化
     */
    var com = REC_COM;
    var settings = com.GetSettings(); 
    var components = REC_COMPONENTS();
     components('Loc', 'loc');
    components('StkCatGrp', 'stkCatGrp');
    components('PurchUser', 'purchUser', {
        mode: 'remote',
        onBeforeLoad: function (params) {
            params.locId = $('#loc').combobox('getValue') || session['LOGON.CTLOCID'];
        }
    });
    components('Vendor', 'vendor');
    components('Date', 'createDate');
    components('Banner', 'recBanner');
    components('OperateType', 'operateType', {}, function (rows) {
        rows.forEach((element) => {
            if (element.DefaultFlag === 'Y') {
                biz.setData('operateType', element.RowId);
            }
        });
    });
    components('Remarks', 'remarks');
    components('ItmGrid', 'gridItm', {
        toolbar: '#gridItmBar',
        rownumber: true, // 可走前端参数设置, 这只是初步默认
        pagination: false,
        showFooter: true,
        data: {
            rows: [],
            footer: [{ inciCode: '合计' }],
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
                gridID: $(this)[0].id,
                index: index,
                field: field,
                forceEnd: true
            });
        },
        onLoadSuccess: function () {
            $(this).datagrid('clearChecked');
            com.SumGridFooter('#' + this.id, ['rpAmt', 'spAmt', 'invAmt']);
        },
        onAfterEdit: function (rowIndex, rowData, changes) {
            // 如果是点击保存, 则不需要触发此处
            if (biz.getData('Saving') === true) {
                return;
            }
            if (PHA_GridEditor.IsRowChanged('#gridItm', rowIndex) === true) {
                ValidateSave(rowData, rowIndex);
                CheckDistinct();
                com.SumGridFooter('#' + this.id);
            }
        }
    });

    PHA_EVENT.Bind('#btnSelect', 'click', function () {
        components('QueryWindow', 'winQueryRec', {
            onClose: function () {
                HandleWindowData('winQueryRec');
            }
        });
    });
    PHA_EVENT.Bind('#btnAddItm', 'click', function () {
        var changeLen = com.GetChangedRows('gridItm').length;
        if (changeLen >= (settings.App.MaxRows4Create || 5)) {
            components('Pop', '请及时保存数据');
        }
        AddRow();
    });
    PHA_EVENT.Bind('#btnDeleteItm', 'click', function () {
        biz.setData('handleStatus', 'DeleteItms');
        DeleteChecked();
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        com.Condition('#qCondition', 'clear');
        biz.setData('recID', '');
        biz.setData('status', 'SAVE');
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
    PHA_EVENT.Bind('#btnValidate', 'click', function () {
        ValidateSave();
    });
    PHA_EVENT.Bind('#btnPrint', 'click', function () {
        com.Print(biz.getData('recID'));
    });
    PHA_EVENT.Bind('#btnSelectPO', 'click', function () {
        websys_showModal({
            id: 'pha_in_v3_rec_createbypo_win',
            url: 'pha.in.v3.rec.createbypo.csp?openway=win',
            title: '选取订单',
            width: PHA_COM.Window.Width(),
            height: PHA_COM.Window.Height(),
            closable: true,
            onClose: function () {
                LoadCopyGo();
            }
        });
    });
    /**
     * 根据窗口的数据加载不同数据
     * @param {*} winID 弹出窗口的ID
     * @returns
     */
    function HandleWindowData(winID) {
        var retData = $.data($('#' + winID)[0], 'retData');
        retData = retData || {};
        var recID = retData.recID || '';
        if (recID === '') {
            return;
        }
        biz.setData('keepInputFlag', false);
        var type = retData.type || '';
        if (type === '') {
            biz.setData('recID', recID);
            return;
        }
        if (type === 'copy' || type === 'mould') {
            biz.setData('recID', '');
            com.Copy({ recID: recID }, function (retData) {
                com.SetKeyValue2Null(retData.main, biz.getData('keepInputFields'));
                if (retData.main.recID !== '') {
                    // 后台直接复制到表
                    biz.setData('recID', recID);
                    return;
                }
                if (type === 'copy') {
                    retData.main.dataLinkFrom = recID;
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
        PHA_GridEditor.GridFinalDone('#gridItm', ['inciCode']);
        if (biz.getData('handleStatus') !== 'FinishCancel') {
            if (ValidateEditGrid() === false) {
                return;
            }
            if (ValidateSave() === false) {
                return;
            }
        }
        var mainObj = com.Condition('#qCondition', 'get', { dotype: 'save' });
        if (mainObj === undefined) {
            return;
        }
        mainObj.recID = biz.getData('recID');
        mainObj.mainRowID = biz.getData('recID');
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
                components('Pop', '处理成功', 'success');
                biz.setData('recID', retData.data);
                /* 保存之后自动打印 */
                if (apiMethod === 'HandleSave'){
	            	if (settings.App.AutoPrintAfterSave == 'Y'){
	            		com.Print(biz.getData('recID'));
	            	}
                }
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
            // // 调用了所有的checkvalues
            // msg = PHA_GridEditor.CheckValues('gridItm');
            // if (msg !== '') {
            //     throw msg;
            // }
            // msg = PHA_GridEditor.CheckDistinct({ gridID: 'gridItm', fields: ['inci', 'batNo', 'expDate', 'rp'] }); // 并列
            // if (msg !== '') {
            //     throw msg + ' ( 药品批号 & 效期 & 进价 )';
            // }

            if ($('#gridItm').datagrid('getRows').length == 0) {
                throw '没有需要操作的数据';
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
        // 校验重复
        var distinctFields = $('#gridItm').datagrid('options').distinctFields;
        var distinctMsg = PHA_GridEditor.CheckDistinct({ gridID: 'gridItm', fields: distinctFields });
        if (distinctMsg !== '') {
            components('Pop', distinctMsg + '，药品、批号、发票号，不能完全相同');
            return false;
        }
        return true;
    }
    function ValidateSave(rowData, rowIndex) {
        var mainObj = com.Condition('#qCondition', 'get', { dotype: 'save' });
        if (mainObj === undefined) {
            return;
        }
        mainObj.recID = biz.getData('recID');
        mainObj.mainRowID = biz.getData('recID');

        var rows = [];
        if (rowData === undefined) {
            var forRows = $('#gridItm').datagrid('getRows');
            for (const it of forRows) {
                var rowData = $.extend({}, it);
                rows.push(rowData);
            }
        } else {
            rowData.rowIndex = rowIndex;
            if ((rowData.inciCode || '') === '') {
                return true;
            }
            rows.push(rowData);
        }
        // 异步只是稍微好那么一点, 但是感受不出来
        var valRet = com.InvokeSyn('ValidateSave', {
            main: mainObj,
            rows: rows
        });
        if (valRet.type !== '') {
            PHA.Warn2Grid('#gridItm', { warnInfo: valRet });
            if (rowIndex === undefined) {
                // 点击保存的提醒
                PHA.ShowWarn({ warnInfo: valRet });
                if (valRet.type === 'terminate') {
                    return false;
                }
            }
        }
        return true;
    }
    function Delete(warnMsg) {
        var recID = biz.getData('recID');
        if (recID === '') {
            components('Pop', '没有需要删除的信息');
            return;
        }
        PHA.Confirm('提示', warnMsg || '您确认删除单据吗?', function () {
            com.Invoke(com.Fmt2ApiMethod('Delete'), { recID: recID }, function (retData) {
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
                    components('Pop', '删除成功');
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
            // 最后一行无效, 直接定位编辑
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
            components('Pop', '请勾选需要删除的记录');
            return;
        }
        var recItmArr = [];
        for (const rowData of checkedRows) {
            var recItmID = rowData.recItmID || '';
            if (recItmID !== '') {
                recItmArr.push(com.AppendLogonData({ recItmID: recItmID }));
            }
        }

        PHA.Confirm('提示', '您确认删除 ' + checkedRows.length + ' 条明细吗?', function () {
            PHA.Loading('Show');
            if (recItmArr.length > 0) {
                // 一个事务处理, 一般没啥问题
                com.InvokeSyn(com.Fmt2ApiMethod('DeleteItms'), { rows: recItmArr }, function (retData) {
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
            PHA.Loading('Hide');
            components('Pop', '删除成功');
            com.SumGridFooter('#gridItm');
            $('#gridItm').datagrid('clearChecked');
            if ($('#gridItm').datagrid('getRows').length === 0 && biz.getData('recID') !== '') {
                Delete('明细已经没有记录，您是否同时删除此单据？');
            }
        });
    }

    function Select(recID) {
        if (recID === '') {
            $('#recBanner').phabanner('reset');
            $('#gridItm').datagrid('clear');
            return;
        }
        var data = com.GetMainData(recID);
        if (typeof data === 'string') {
            return;
        }
        if (biz.getData('keepInputFlag') === true) {
            com.DeleteJsonKeys(data, biz.getData('keepInputFields'));
        }else{
            com.SetKeyValue2Null(data, biz.getData('keepInputFields'));
        }
        biz.setData('keepInputFlag', true);
        data.loc = {
                RowId: data.loc,
                Description: data.locDesc,
                Select: false
            }
        setTimeout(function(){PHA.SetVals([data]);}, 500);
        components('Banner', 'recBanner', data);
        biz.setData('status', data.status);
        com.QueryItmGrid('gridItm', { recID: recID });
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
            components('Pop', '类组，不能为空', 'alert');
            return false;
        }
        return true;
    }
    function GetDefaultRowData(target, rowIndex) {
        let retObj = {};
        const rows = $(target).datagrid('getRows');
        if (rows.length === 0) {
            return retObj;
        }
        rowIndex = isNaN(rowIndex) ? rows.length - 1 : rowIndex; // 上一行
        const rowData = rows[rowIndex];
        for (const iterator of $('#keyToolInput').keywords('getSelected')) {
            if (iterator.id === 'SameInvData') {
                retObj.invNo = rowData.invNo;
                retObj.invDate = rowData.invDate;
                retObj.invCode = rowData.invCode;
            }
        }
        return retObj;
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
        $('#operateType').combobox('reload');
        $('#stkCatGrp').combobox('reload');
        $('#purchUser').combobox('reload');
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
    function LoadCopyGo() {
        var topRetData = PHA_COM.TOP.Get('pha.in.v3.rec.create.csp_copy', true);
        if (topRetData !== '') {
            $('#btnClean').trigger('click-i');
            PHA.SetVals([topRetData.main]);
            var rows = topRetData.rows;
            PHA_GridEditor.LoadChangedRows('#gridItm', { total: rows.length, rows: rows });
        }
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

        var banEditFields = [];
        if (settings.App.AllowInputRpAmt !== 'Y') {
            banEditFields.push('rpAmt');
        }
        if (settings.Com.RpRule == '2') {
            banEditFields.push('rp');
        }
        if (settings.Com.RpRule != '3') {
            banEditFields.push('sp');
        }
        com.BanGridEditors('#gridItm', banEditFields);
        if (settings.App.PurchaserNotNull !== 'Y') {
            // 采购员必填
            PHA.DataPha.Set('purchUser', { required: false });
        }
        PHA.SetRequired($('#qCondition [data-pha]'));
        com.SetPage('pha.in.v3.rec.create.csp');

        var topRecID = com.Top.Get('recID', true);
        if (topRecID !== '') {
            biz.setData('recID', topRecID);
        }
        // 由依据订单界面而来的数据, 嵌入界面的形式用此
        if (top.PHAINPO_TO_PHAINREC) {
            var topData = top.PHAINPO_TO_PHAINREC;
            PHA.SetVals([topData.main]);
            $('#gridItm').datagrid('loadData', {
                total: topData.rows.length,
                rows: topData.rows
            });
            $('#gridItm').parent().find('[datagrid-row-index] [field="qty"]').addClass('datagrid-value-changed');
            delete top.PHAINPO_TO_PHAINREC;
        }
        LoadCopyGo();
    }, 0);
});
