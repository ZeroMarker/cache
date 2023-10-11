/**
 * 调价 - 统一价 - 制单
 * @creator 云海宝
 */

$(function () {
    var biz = {
        data: {
            aspID: '',
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
                case 'aspID':
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
    var components = ASP_COMPONENTS();
    var com = ASP_COM;
    var settings = com.GetSettings();

    components('StkCatGrp', 'stkCatGrp');
    components('No', 'no');
    components('Inci', 'inci');
    components('Date', 'startDate');
    components('Date', 'endDate');
    components('FilterField', 'filterField');
    components('AspGrid', 'gridAsp', {
        toolbar: '#gridAspBar',
        onClickCell: function (index, field, value) {
            if (CanEdit() === false) {
                return;
            }
            PHA_GridEditor.Edit({
                gridID: 'gridAsp',
                index: index,
                field: field,
                forceEnd: true
            });
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
            if (PHA_GridEditor.IsRowChanged('#gridAsp', rowIndex) === true) {
                // 新增和改变过的记录需要验证
                ValidateSave(rowData, rowIndex);
                // 校验重复
                CheckDistinct();
            }
        },
        onLoadSuccess: function (data) {
            $(this).datagrid('uncheckAll');
            PHA_GridEditor.End(this.id);
            var tmpRows = biz.getData('tmpRows');
            if (tmpRows.length > 0) {
                for (var i = 0, length = tmpRows.length; i < length; i++) {
                    var tmpRow = tmpRows[i];
                    $('#gridAsp').datagrid('appendRow', tmpRow);

                    var lastRowIndex = $('#gridAsp').datagrid('getRows').length - 1;
                    $('#gridAsp')
                        .parent()
                        .find('.datagrid-body [datagrid-row-index=' + lastRowIndex + ']')
                        .find('[field="reason"],[field="retUomSp"],[field="retUomRp"]')
                        .addClass('datagrid-value-changed');
                }
            }
            biz.setData('tmpRows', []);
            // 暂无问题
            setTimeout(function () {
                $.data($('#gridAsp')[0], 'datagrid').insertedRows = tmpRows;
            }, 100);
        }
    },
    {
	    deleteField:['auditDate', 'auditTime', 'auditUserName', 'executeDate', 'executeTime', 'executeUserName']
    }
    );
    PHA_EVENT.Bind('#btnAdd', 'click', function () {
        var changeLen = com.GetChangedRows('gridAsp').length;
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
            $('#gridAsp').datagrid('clear');
            SetDefaults();
        });
    });
    PHA_EVENT.Bind('#btnSave', 'click', function () {
        biz.setData('handleStatus', 'Save');
        biz.setData('Saving', true);
        Save();
        biz.setData('Saving', false);
    });

    PHA_EVENT.Bind('#btnFind', 'click', function () {
        var qJson = com.Condition('#qCondition', 'get');
        qJson.aspStatus = 'No';
        com.QueryAspGrid('gridAsp', qJson);
    });

    function Save() {
        var apiMethod = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (apiMethod === '') {
            return;
        }
        // com.GridFinalDone('#gridAsp');
        PHA_GridEditor.DeleteNullRow('#gridAsp', ['inciCode'])
        if (ValidateEditGrid() === false) {
            return;
        }

        if (ValidateSave() === false) {
            return;
        }

        var changesRows = com.GetChangedRows('gridAsp');
        var allRows = $('#gridAsp').datagrid('getRows');
        var rows = [];
        for (const it of changesRows) {
            var rowIndex = allRows.indexOf(it);
            rows.push({
                aspID: it.aspID || '',
                inci: it.inci,
                uom: it.uom,
                hosp: it.hosp,
                retUomSp: it.retUomSp,
                retUomRp: it.retUomRp,
                reason: it.reason,
                remark: it.remark,
                preExecuteDate: it.preExecuteDate,
                createDate: it.createDate,
                invNo: it.invNo,
                invDate: it.invDate,
                warrentNo: it.warrentNo,
                warrentNoDate: it.warrentNoDate,
                remark: it.remark,
                rowIndex: rowIndex
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
                            if (!isNaN(msgRetRowIndex) && (msgRetRowData.aspID || '') === '') {
                                var row = allRows[msgRetRowIndex];
                                tmpRows.push(row);
                            }
                        }
                    }

                    biz.setData('tmpRows', tmpRows);
                    $('#gridAsp').datagrid('reload');
                }
            }

        });
    }
    function ValidateSave(rowData, rowIndex) {
        var eventType = 'Save';
        var mainObj = {};

        var rows = [];
        if (rowIndex === undefined) {
            var forRows = $('#gridAsp').datagrid('getRows');
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
            eventType = 'Row';
        }

        // 异步只是稍微好那么一点, 但是感受不出来
        var valRet = ASP_COM.InvokeSyn('ValidateSave', {
            main: mainObj,
            rows: rows,
            eventType: eventType
        });
        if (valRet.type !== '') {
            
            PHA.Warn2Grid('#gridAsp', { warnInfo: valRet });
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
    function CheckDistinct() {
        var distinctFields = $('#gridAsp').datagrid('options').distinctFields;
        var distinctMsg = PHA_GridEditor.CheckDistinct({ gridID: 'gridAsp', fields: distinctFields });
        if (distinctMsg !== '') {
            components('Pop', distinctMsg + '，药品不能相同');
            return false;
        }
        return true;
    }
    function ValidateEditGrid() {
        var val = true;
        var msg = '';
        try {
            if (!PHA_GridEditor.EndCheck('gridAsp')) {
                throw '';
            }
            // msg = PHA_GridEditor.CheckValues('gridAsp');
            // if (msg !== '') {
            //     throw msg;
            // }
            // msg = PHA_GridEditor.CheckDistinct({ gridID: 'gridAsp', fields: ['inci'] }); // 并列
            // if (msg !== '') {
            //     throw msg + ' ( 药品 )';
            // }
            if ($('#gridAsp').datagrid('getRows').length == 0) {
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

    function AddRow() {
        if (CanEdit() === false) {
            return;
        }
        var rows = $('#gridAsp').datagrid('getRows');
        if (rows.length > 0) {
            var inciCode = rows[rows.length - 1].inciCode || '';
            // 最后一行无效, 直接定位编辑
            if (inciCode === '') {
                PHA_GridEditor.Edit({
                    gridID: 'gridAsp',
                    index: rows.length - 1,
                    field: 'inci',
                    forceEnd: true
                });
                return;
            }
        }
        PHA_GridEditor.End('gridAsp');
        var rowIndex = $('#gridAsp').datagrid('getRows').indexOf($('#gridAsp').datagrid('getSelected'));
        if (rowIndex < 0) {
            rowIndex = $('#gridAsp').datagrid('getRows').length - 1;
        }
        var defaultRowData = GetDefaultRowData('#gridAsp', rowIndex);
        PHA_GridEditor.Add({
            gridID: 'gridAsp',
            field: 'inci',
            rowData: defaultRowData
        });
    }
    function DeleteChecked() {
        var $grid = $('#gridAsp');
        var checkedRows = $grid.datagrid('getChecked');
        if (checkedRows.length === 0) {
            components('Pop', '请勾选需要删除的记录');
            return;
        }
        var aspArr = [];
        for (const rowData of checkedRows) {
            var aspID = rowData.aspID || '';
            if (aspID !== '') {
                aspArr.push(com.AppendLogonData({ aspID: aspID }));
            }
        }

        PHA.Confirm('提示', '您确认删除 ' + checkedRows.length + ' 条明细吗?', function () {
            PHA.Loading('Show');
            if (aspArr.length > 0) {
                // 一个事务处理, 一般没啥问题
                com.InvokeSyn(com.Fmt2ApiMethod('Delete'), { main: {}, rows: aspArr }, function (retData) {
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
                $grid.datagrid('deleteRow', rowIndex);
            }
            PHA.Loading('Hide');
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

    function ControlOperation() {
        com.ControlOperation({});
    }
    function GetDefaultRowData(target, rowIndex) {
        let retObj = {
            hosp: session['LOGON.HOSPID'],
            hospDesc: App_HospDesc,
            preExecuteDate: biz.getData('defaultData')[0].preExecuteDate
        };
        const rows = $(target).datagrid('getRows');
        if (rows.length === 0) {
            return retObj;
        }
        rowIndex = isNaN(rowIndex) ? rows.length - 1 : rowIndex; // 上一行
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

    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    setTimeout(function () {
        $.extend(biz.getData('defaultData')[0], settings.DefaultValues || {});
        SetDefaults();
        ControlOperation();
        com.SetPage('pha.in.v3.asp.create.csp');
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
        // $('#btnAdd').click();
        // setTimeout(function () {
        //     $($('#gridAsp').datagrid('getEditor', { index: 0, field: 'inci' }).target).combogrid('setText', 'amxl');
        // }, 500);
    }, 0);
});

