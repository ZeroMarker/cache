/**
 * 调价 - 批次价 - 制单
 * @creator 云海宝
 * @todo    多选批次的逻辑有待改进,
 */

$(function () {
    var biz = {
        data: {
            aspbID: '',
            status: 'SAVE',
            handleStatus: '',
            tmpRows: [],
            defaultData: [
                {
                    startDate: PHA_UTIL.GetDate('t'),
                    endDate: PHA_UTIL.GetDate('t'),
                    preExecuteDate: PHA_UTIL.GetDate('t+1'),
                    status: 'SAVE'
                }
            ]
        },
        getData: function (key) {
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;
            switch (key) {
                case 'aspbID':
                    break;
                case 'status':
                    if (data === '') {
                        this.data[key] = 'SAVE';
                    }
                    ControlOperation();
                    break;
                default:
                    break;
            }
        }
    };

    /**
     * 初始化
     */
    var components = ASPB_COMPONENTS();
    var com = ASPB_COM;
    var settings = com.GetSettings();

    components('StkCatGrp', 'stkCatGrp');
    components('No', 'no');
    // components('Inci', 'inci');
    components('Date', 'startDate');
    components('Date', 'endDate');
    components('FilterField', 'filterField');
    var rebuildColumns = PHA_COM.RebuildColumns(components('AspbGridColmuns', 'gridAspb'), {
        hiddenFields: ['executeDate', 'executeTime', 'executeUserName', 'auditDate', 'auditTime', 'auditUserName']
    });
    components('AspbGrid', 'gridAspb', {
        toolbar: '#gridAspbBar',
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns,
        singleSelect: true,
        checkOnSelect: false,
        selectOnCheck: false,
        onClickCell: function (index, field, value) {
            if (CanEdit() === false) {
                return;
            }
            PHA_GridEditor.Edit({
                gridID: 'gridAspb',
                index: index,
                field: field,
                forceEnd: true
            });
            var inciCode = $('#gridAspb').datagrid('getRow', index).inciCode
			if( inciCode != "" && inciCode != undefined){
				let target = $('#gridAspb').datagrid('getEditor', { index: index, field: 'inciDesc' }).target;
            	$(target).lookup('disable');
				$(target).unbind();
			}
        },
        onNextCell: function (index, field, value, isLastRow, isLastCol) {
            if (isLastRow && isLastCol) {
                $('#btnAdd').trigger('click-i');
            }
        },
        onAfterEdit: function (rowIndex, rowData, changes) {
            // 如果是点击保存, 则不需要触发此处
            if (biz.getData('Saving') === true) {
                return;
            }
            if (PHA_GridEditor.IsRowChanged('#gridAspb', rowIndex) === true) {
                // 新增和改变过的记录需要验证
                ValidateSave(rowData, rowIndex);
                // 校验重复
                CheckDistinct()
            }
        },
        onBatWinClose: function () {
            var $grid = $('#gridAspb');
            var changedIndexArr = $grid.datagrid('options').winSelecedIndexArr;
            var firstRowIndex = changedIndexArr[0] - 1;
            if (firstRowIndex < 0) {
                firstRowIndex = 0;
            }
            var defaultRowData = GetRowData4KeyToolInput('#gridAspb', firstRowIndex);
            for (var i = 0, length = changedIndexArr.length; i < length; i++) {
                $grid.datagrid('updateRow', {
                    index: changedIndexArr[i],
                    row: defaultRowData
                });
            }
        },
        onLoadSuccess: function (data) {
            $(this).datagrid('uncheckAll');
            PHA_GridEditor.End(this.id);
            var tmpRows = biz.getData('tmpRows');
            if (tmpRows.length > 0) {
                for (var i = 0, length = tmpRows.length; i < length; i++) {
                    var tmpRow = tmpRows[i];
                    $('#gridAspb').datagrid('appendRow', tmpRow);

                    var lastRowIndex = $('#gridAspb').datagrid('getRows').length - 1;
                    $('#gridAspb')
                        .parent()
                        .find('.datagrid-body [datagrid-row-index=' + lastRowIndex + ']')
                        .find('[field="reason"],[field="retUomSp"],[field="retUomRp"]')
                        .addClass('datagrid-value-changed');
                }
            }
            biz.setData('tmpRows', []);
            // 暂无问题
            setTimeout(function () {
                $.data($('#gridAspb')[0], 'datagrid').insertedRows = tmpRows;
            }, 100);
        }
    },
    {
	    deleteField:['auditDate', 'auditTime', 'auditUserName', 'executeDate', 'executeTime', 'executeUserName']
    }
    );

    PHA_EVENT.Bind('#btnAdd', 'click', function () {
        var changeLen = com.GetChangedRows('gridAspb').length;
        if (changeLen >= (settings.App.MaxRows4Create || 5)) {
            components('Pop', '请及时保存数据');
        }
        AddRow();
    });
    PHA_EVENT.Bind('#btnDelete', 'click', function () {
        biz.setData('handleStatus', 'Delete');
        DeleteChecked();
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        PHA.Confirm('温馨提示', '您确认清屏吗?', function () {
            com.Condition('#qCondition', 'clear');
            biz.setData('status', 'SAVE');
            $('#gridAspb').datagrid('clear');
            SetDefaults();
            ControlOperation();
        });
    });
    PHA_EVENT.Bind('#btnSave', 'click', function () {
        biz.setData('handleStatus', 'Save');
        biz.setData('Saving', true);
        Save();
        biz.setData('Saving', false);
    });

    PHA_EVENT.Bind('#btnFind', 'click', function () {
        // @wanttodo 如果有编辑行, 点击查询时, 给予提示, 避免未保存
        var qJson = com.Condition('#qCondition', 'get');
        qJson.aspbStatus = 'N';
        com.QueryAspbGrid('gridAspb', qJson);
    });

    function Save() {
        var apiMethod = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (apiMethod === '') {
            return;
        }
        // com.GridFinalDone('#gridAspb');
        PHA_GridEditor.DeleteNullRow('#gridAspb', ['inciCode']);
        if (ValidateEditGrid() === false) {
            return;
        }
        if (ValidateSave() === false) {
            return;
        }
        var changesRows = com.GetChangedRows('gridAspb');
        var allRows = $('#gridAspb').datagrid('getRows');

        var rows = [];
        for (const it of changesRows) {
            var rowIndex = allRows.indexOf(it);
            rows.push({
                rowIndex: rowIndex,
                aspbID: it.aspbID || '',
                incib: it.incib,
                inci: it.inci,
                uom: it.uom,
                hosp: it.hosp,
                retUomSp: it.retUomSp,
                retUomRp: it.retUomRp,
                reason: it.reason,
                remark: it.remark,
                preExecuteDate: it.preExecuteDate,
                createDate: it.createDate,
                invNo: it.invNo || '',
                invDate: it.invDate || '',
                warrentNo: it.warrentNo || '',
                warrentNoDate: it.warrentNoDate || ''
                
            });
        }
        if (rows.length === 0) {
            components('Pop', '没有需要保存的数据');
            return;
        }
        var saveJson = {
            main: {},
            rows: rows
        };
        PHA.Loading('Show');
        com.Invoke(apiMethod, saveJson, function (retData) {
            PHA.Loading('Hide');
            if (typeof retData === 'string') {
                PHA.Alert('', retData, 'warning');
            } else {
                if (retData.failureCnt === 0) {
                    // 多行保存, 部分成功的处理
                    components('Pop', '保存成功', 'success');
                    $('#btnFind').trigger('click-i');
                } else {
                    PHA.DataAlert(retData, 'warning');
                    var messageArr = retData.message || [];
                    var tmpRows = [];
                    for (var i = 0, length = messageArr.length; i < length; i++) {
                        var messageData = messageArr[i];
                        if (typeof messageData === 'object') {
                            var msgRetRowData = messageData.data;
                            var msgRetRowIndex = msgRetRowData.rowIndex;
                            if (!isNaN(msgRetRowIndex) && (msgRetRowData.aspbID || '') === '') {
                                var row = allRows[msgRetRowIndex];
                                tmpRows.push(row);
                            }
                        }
                    }

                    biz.setData('tmpRows', tmpRows);
                    $('#gridAspb').datagrid('reload');
                }
            }
        });
    }
    function ValidateSave(rowData, rowIndex) {
        var mainObj = {};

        var rows = [];
        if (rowIndex === undefined) {
            var forRows = $('#gridAspb').datagrid('getRows');
            forRows.forEach(function (it) {
                var forRow = $.extend({}, it);
                rows.push(forRow);
            });
        } else {
            // rowData = $('#gridAsp').datagrid('getRows')[rowIndex]
            rowData.rowIndex = rowIndex;
            if ((rowData.inciCode || '') === '') {
                return true;
            }
            rows.push(rowData);
        }
        // 异步只是稍微好那么一点, 但是感受不出来
        var valRet = ASPB_COM.InvokeSyn('ValidateSave', {
            main: mainObj,
            rows: rows
        });
        if (valRet.type !== '') {
            PHA.Warn2Grid('#gridAspb', { warnInfo: valRet });
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
    function ValidateEditGrid() {
        var val = true;
        var msg = '';
        try {
            // if (!PHA_GridEditor.EndCheck('gridAspb')) {
            //     throw '请先完成编辑';
            // }
            // msg = PHA_GridEditor.CheckValues('gridAspb');
            // if (msg !== '') {
            //     throw msg;
            // }
            // msg = PHA_GridEditor.CheckDistinct({ gridID: 'gridAspb', fields: ['incib'] }); // 并列

            // if (msg !== '') {
            //     throw msg + ' ( 药品批次 )';
            // }
            if ($('#gridAspb').datagrid('getRows').length == 0) {
                throw '没有需要操作的数据';
            }
        } catch (error) {
            val = false;
            msg = error;
            if (typeof error === 'object') {
                PHA.Alert('提示', error.message, 'error');
            }
        } finally {
            if (msg !== '' && typeof msg === 'string') {
                components('Pop', msg);
            }
            return val;
        }
    }
    function CheckDistinct() {
        var distinctFields = $('#gridAspb').datagrid('options').distinctFields;
        var distinctMsg = PHA_GridEditor.CheckDistinct({ gridID: 'gridAspb', fields: distinctFields });
        if (distinctMsg !== '') {
            components('Pop', distinctMsg + '，药品批次不能相同');
            return false;
        }
        return true;
    }

    function AddRow() {
        if (CanEdit() === false) {
            return;
        }
        var rows = $('#gridAspb').datagrid('getRows');
        if (rows.length > 0) {
            var incib = rows[rows.length - 1].incib || '';
            // 最后一行无效, 直接定位编辑
            if (incib === '') {
                PHA_GridEditor.Edit({
                    gridID: 'gridAspb',
                    index: rows.length - 1,
                    field: 'inciDesc',
                    forceEnd: true
                });
                return;
            }
        }
        var rowIndex = $('#gridAspb').datagrid('getRows').indexOf($('#gridAspb').datagrid('getSelected'));
        if (rowIndex < 0) {
            rowIndex = $('#gridAspb').datagrid('getRows').length - 1;
        }
        var defaultRowData = GetDefaultRowData('#gridAspb', rowIndex);
        PHA_GridEditor.Add({
            gridID: 'gridAspb',
            field: 'inciDesc',
            rowData: defaultRowData
        });
    }
    function DeleteChecked() {
        var $grid = $('#gridAspb');
        var checkedRows = $grid.datagrid('getChecked');
        if (checkedRows.length === 0) {
            components('Pop', '请勾选需要删除的记录');
            return;
        }
        var aspbArr = [];
        for (const rowData of checkedRows) {
            var aspbID = rowData.aspbID || '';
            if (aspbID !== '') {
                aspbArr.push(com.AppendLogonData({ aspbID: aspbID }));
            }
        }

        PHA.Confirm('提示', '您确认删除 ' + checkedRows.length + ' 条明细吗?', function () {
            if (aspbArr.length > 0) {
                // 一个事务处理, 一般没啥问题
                com.Invoke(com.Fmt2ApiMethod('Delete'), { main: {}, rows: aspbArr }, function (retData) {
                    if (typeof retData === 'string') {
                        PHA.Alert('', retData, 'warning');
                        return;
                    }
                });
            }
            var rows = $grid.datagrid('getRows');
            for (const chkit of checkedRows) {
                var rowIndex = rows.indexOf(chkit);
                $grid.datagrid('deleteRow', rowIndex);
            }
            components('Pop', '删除成功');
            $grid.datagrid('clearChecked');
        });
    }

    function CanEdit() {
        if (biz.getData('status') !== 'SAVE') {
            components('Pop', '记录不可修改, 无法操作');
            return false;
        }
        return true;
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    function ControlOperation() {
        com.ControlOperation({});
    }

    function GetDefaultRowData(target, rowIndex) {
        var retObj = {
            hosp: session['LOGON.HOSPID'],
            hospDesc: App_HospDesc,
            createDate: PHA_UTIL.GetDate('t'),
            preExecuteDate: biz.getData('defaultData')[0].preExecuteDate
        };
        return $.extend({}, retObj, GetRowData4KeyToolInput(target, rowIndex));
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
            if (iterator.id === 'DefaAspReason') {
                retObj.reason = rowData.reason;
                retObj.reasonDesc = rowData.reasonDesc;
            }
            if (iterator.id === 'DefaPreExeDate') {
                retObj.preExecuteDate = rowData.preExecuteDate;
            }
        }
        return retObj;
    }

    setTimeout(function () {
        $.extend(biz.getData('defaultData')[0], settings.DefaultValues || {});
        SetDefaults();
        ControlOperation();
        com.SetPage('pha.in.v3.aspb.create.csp');
        for (const it of ['DefaAspReason', 'DefaPreExeDate']) {
            if (settings.App[it] === 'Y') {
                $('#keyToolInput').keywords('select', it);
            }
        }
        $('#btnFind').trigger('click-i');
        $('body').on('click',function(){
            $('.tooltip').hide()
         })
        // @automatic
        // setTimeout(function () {
        //     var editor = $('#gridAspb').datagrid('getEditor', { index: 0, field: 'inci' });
        //     $(editor.target).val('amxl');
        //     $('.triggerbox-button')[0].click();
        // }, 500);
    }, 0);
});