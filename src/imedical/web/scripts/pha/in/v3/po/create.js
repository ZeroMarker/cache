/**
 * 采购订单 - 制单
 * @creator 云海宝
 */

$(function () {
    var biz = {
        data: {
            poID: '',
            status: 'SAVE',
            handleStatus: '',
            keepInputFields: ['stkCatGrp', 'stkCatGrpDesc'],
            keepInputFlag: true,
            defaultData: [
                {
                    loc: session['LOGON.CTLOCID'],
                    reqLoc: '',
                    needDate: ''
                }
            ]
        },
        getData: function (key) {
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;
            switch (key) {
                case 'poID':
                    Select(data);
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
    var components = PO_COMPONENTS();
    var com = PO_COM;
    var settings = com.GetSettings();
    components('Loc', 'loc');
    components('Loc', 'reqLoc', { onLoadSuccess: function (data) {} });
    components('StkCatGrp', 'stkCatGrp');
    components('No', 'no');
    components('Vendor', 'vendor');
    components('Date', 'needDate');
    components('Banner', 'poBanner');
    components('Remarks', 'remarks');
    var rebuildColumns = PHA_COM.RebuildColumns(components('ItmGridColmuns', 'gridItm'), {
        hiddenFields: ['recedQty']
    });
    components('ItmGrid', 'gridItm', {
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns,
        toolbar: '#gridItmBar',
        isAutoShowPanel: false,
        rownumbers: true,
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
        },
        onLoadSuccess: function () {
            $(this).datagrid('clearChecked');
            PHA_GridEditor.End(this.id);
            com.SumGridFooter(this.id);
        },
        onAfterEdit: function (rowIndex, rowData, changes) {
            // 如果是点击保存, 则不需要触发此处
            if (biz.getData('Saving') === true) {
                return;
            }
            if (PHA_GridEditor.IsRowChanged('#gridItm', rowIndex) === true) {
                // 新增和改变过的记录需要验证
                ValidateSave(rowData, rowIndex);
                // 校验重复
                CheckDistinct();
                com.SumGridFooter(this.id);
            }
        }
    });

    /**
     * 注册事件
     */
    PHA_EVENT.Bind('#btnSelect', 'click', function () {
        components('QueryWindow', 'winQueryPO', {
            onClose: function () {
                HandleWindowData('winQueryPO');
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
        biz.setData('poID', '');
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

    PHA_EVENT.Bind('#btnDelete', 'click', function (e) {
        Delete();
    });
    PHA_EVENT.Bind('#btnPrint', 'click', function () {
        com.Print(biz.getData('poID'));
    });
    function HandleWindowData(winID) {
        var retData = $.data($('#' + winID)[0], 'retData');
        retData = retData || {};
        var poID = retData.poID || '';
        if (poID === '') {
            return;
        }
        biz.setData('keepInputFlag', false);
        var type = retData.type || '';
        if (type === '') {
            biz.setData('poID', poID);
            return;
        }
        if (type === 'copy' || type === 'mould') {
            biz.setData('poID', '');
            com.Copy({ poID: poID }, function (retData) {
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
        PHA_GridEditor.DeleteNullRow('#gridItm', ['inciCode']);
        if (['Finish', 'Save'].indexOf(biz.getData('handleStatus')) >= 0) {
            if (ValidateEditGrid() === false) {
                return;
            }
            // 后台校验
            if (ValidateSave() === false) {
                return;
            }
        }
        var mainObj = com.Condition('#qCondition', 'get', { doType: 'save' });
        if (mainObj === undefined) {
            return;
        }
        mainObj.poID = biz.getData('poID');
        mainObj.mainRowID = biz.getData('poID');
        mainObj.statusCode = biz.getData('handleStatus');
        var rows = [];
        var changedRows = com.GetChangedRows('gridItm');
        for (var i = 0, length = changedRows.length; i < length; i++) {
            var changedRow = changedRows[i];
            var rowData = $.extend({}, changedRow);
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
                biz.setData('poID', retData.data);
            }
        });
    }
    function ValidateEditGrid() {
        var val = true;
        var msg = '';
        try {
            if ($('#gridItm').datagrid('getRows').length == 0) {
                throw '没有需要操作的数据';
            }
            if (biz.getData('handleStatus') === 'Save' && biz.getData('status') !== 'SAVE') {
                // throw '订单不能修改';
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
            components('Pop', distinctMsg + '，药品、进价完全相同');
            return false
        }
        return true
    }
    function ValidateSave(rowData, rowIndex) {
        var mainObj = com.Condition('#qCondition', 'get', { dotype: 'save' });
        if (mainObj === undefined) {
            return;
        }
        mainObj.poID = biz.getData('poID');
        mainObj.mainRowID = biz.getData('poID');

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
        // 走同步 
        var valRet = PO_COM.InvokeSyn('ValidateSave', {
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
        var poID = biz.getData('poID');
        if (poID === '') {
            components('Pop', '没有需要删除的信息');
            return;
        }
        PHA.Confirm('提示', warnMsg || '您确认删除单据吗?', function () {
            com.Invoke(com.Fmt2ApiMethod('Delete'), { poID: poID }, function (retData) {
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
        PHA_GridEditor.Add({
            gridID: 'gridItm',
            field: 'inci'
        });
    }
    function DeleteChecked() {
        var $grid = $('#gridItm');
        var checkedRows = $grid.datagrid('getChecked');
        if (checkedRows.length === 0) {
            components('Pop', '请勾选需要删除的记录');
            return;
        }
        var poItmArr = [];
        for (const rowData of checkedRows) {
            var poItmID = rowData.poItmID || '';
            if (poItmID !== '') {
                poItmArr.push(com.AppendLogonData({ poItmID: poItmID }));
            }
        }

        PHA.Confirm('提示', '您确认删除 ' + checkedRows.length + ' 条明细吗?', function () {
            if (poItmArr.length > 0) {
                // 一个事务处理, 一般没啥问题
                com.InvokeSyn(com.Fmt2ApiMethod('DeleteItms'), { rows: poItmArr }, function (retData) {
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
            components('Pop', '删除成功');
            $('#gridItm').datagrid('clearChecked');
            if ($('#gridItm').datagrid('getRows').length === 0 && biz.getData('poID') !== '') {
                Delete('明细已经没有记录，您是否同时删除此单据？');
            }
        });
    }

    function Select(poID) {
        if (poID === '') {
            $('#poBanner').phabanner('reset');
            $('#gridItm').datagrid('clear');
            return;
        }
        var data = com.GetMainData(poID);
        if (biz.getData('keepInputFlag') === true) {
            com.DeleteJsonKeys(data, biz.getData('keepInputFields'));
        }else{
            com.SetKeyValue2Null(data, biz.getData('keepInputFields'));
        }
        biz.setData('keepInputFlag', true);
        PHA.SetVals([data]);
        components('Banner', 'poBanner', data);
        biz.setData('status', data.status);
        com.QueryItmGrid('gridItm', { poID: poID });
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
    function CanDeleteRow() {
        if (CanEdit() === false) {
            return false;
        }
        return true;
    }

    function ControlOperation() {
        com.ControlOperation({
            '#btnDelete': {
                disabled: biz.getData('poID') === '' || biz.getData('status') !== 'SAVE'
            },
            '#btnAddItm': {
                disabled: biz.getData('status') !== 'SAVE'
            },
            '#btnPrint': {
                disabled: biz.getData('poID') === ''
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
                disabled: biz.getData('poID') === ''
            },
            '#btnSave': {
                disabled: biz.getData('status') !== 'SAVE'
            }
        });
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }

    setTimeout(function () {
        if (settings.Com.StkCatSet === 'Y') {
            PHA.DataPha.Set('stkCatGrp', { required: false });
        }
        $.extend(biz.getData('defaultData')[0], settings.App.DefaultData);
        SetDefaults();
        ControlOperation();
        $('body').on('click',function(){
            $('.tooltip').hide()
         })
        PHA.SetRequired($('#qCondition [data-pha]'));
        com.SetPage('pha.in.v3.po.create.csp');
        // biz.setData('poID',32)
    }, 0);
});

function ShowShow() {
    $('body').append('<div id="testtest"><table id="testgrid"></table></div>');
    var columns = [
        [
            {
                field: 'fieldDesc',
                title: 'fieldDesc',
                width: 100
            },
            {
                field: 'info',
                title: '校验信息',
                width: 300
            }
        ]
    ];
    var dataGridOption = {
        url: null,
        pagination: false,
        columns: columns,
        fitColumns: true,
        data: {
            total: 10,
            rows: [{ fieldDesc: '1111', info: '大萨达所' }]
        }
    };
    PHA.Grid('testgrid', dataGridOption);
    $('#testtest')
        .window({
            iconCls: 'icon-w-paper',
            title: '选择采购订单',
            // width: $('body').width() * 0.85,
            height: $('body').height() * 0.85,
            modal: false,
            closable: true,
            maximizable: true
            // ,
            // content:
            // '<table>'+
            // '<tr>'+
            // '    <td>第 1 行信息</td>'+
            // '    <td>牛逼啊大萨达很简单 / 大萨达所大所大所多 / 大萨达所大所大所大大大萨达</td>'+
            // '    <td>提醒</td>'+
            // '</tr>'+
            // '</table>'
        })
        .dialog('open');
}

