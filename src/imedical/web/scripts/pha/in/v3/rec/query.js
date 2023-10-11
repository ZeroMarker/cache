/**
 * 入库 - 查询 & 修改
 * @creator 云海宝
 */

$(function () {
    var biz = {
        data: {
            recID: '',
            status: 'SAVE',
            handleStatus: '',
            mode: App_MenuCsp === 'pha.in.v3.rec.mod.csp' ? 'MOD' : '',
            defaultData: [
                {
                    'loc-q': session['LOGON.CTLOCID'],
                    'startDate-q': session['LOGON.CTLOCID'],
                    'endDate-q': session['LOGON.CTLOCID'],
                    'status-q': (function () {
                        if (App_MenuCsp === 'pha.in.v3.rec.create.csp') {
                            return ['SAVE', 'COMP'];
                        }
                        if (App_MenuCsp === 'pha.in.v3.rec.mod.csp') {
                            return ['AUDIT'];
                        }
                        return [];
                    })()
                }
            ]
        },
        getData: function (key) {
            return this.data[key];
        },
        setData: function (key, data) {
            this.data[key] = data;
        }
    };
    var components = REC_COMPONENTS();
    var com = REC_COM;
    var settings = com.GetSettings();

    components('Loc', 'loc-q');
    components('Inci', 'inci-q');
    components('No', 'no-q');
    components('Date', 'startDate-q');
    components('Date', 'endDate-q');
    components('Vendor', 'vendor-q');
    components('Status', 'status-q', {
        loadFilter: function (rows) {
            if (biz.getData('mode') !== 'MOD') {
                return rows;
            }
            return rows.filter(function (ele, index) {
                if (['SAVE', 'COMP', 'CANCEL'].indexOf(ele.RowId) >= 0) {
                    return false;
                }
                return true;
            });
        }
    });
    components('FilterField', 'filterField-q');
    var rebuildColumns = PHA_COM.RebuildColumns(components('MainGridColmuns', 'gridMain-q'), {
        banFields: biz.getData('mode') !== 'MOD' ? ['vendor'] : []
    });
    components('MainGrid', 'gridMain-q', {
        toolbar: '#gridMain-qBar',
        forceEnd: true,
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns,
        onClickCell: function (index, field, value) {
            PHA_GridEditor.Edit({
                gridID: 'gridMain-q',
                index: index,
                field: field,
                forceEnd: true
            });
        },
        onSelect: function (rowIndex, rowData) {
            // 控制双击, 避免双击选取时, 连续调用查询
            if (PHA_COM.GridSelecting(this.id, rowIndex) == true) {
                return;
            }
            ControlOperation();
            var pJson = com.Condition('#qCondition-q', 'get');
            pJson.recID = com.GetSelectedRow('#gridMain-q', 'recID');
            com.QueryItmGrid('gridItm-q', pJson);
        },
        onDblClickRow: function () {
            if ($('#btnRetOk-q').parent().css('display') !== 'none') {
                $('#btnRetOk-q').click();
            }
        },
        onLoadSuccess: function () {
            $('#gridItm-q').datagrid('clear');
            ControlOperation();
        }
    });
    var rebuildColumns = PHA_COM.RebuildColumns(components('ItmGridColmuns', 'gridItm-q'), {
        hiddenFields: ['gCheck'],
        editFields: biz.getData('mode') === 'MOD' ? ['batNo', 'expDate', 'manf'] : []
    });
    components('ItmGrid', 'gridItm-q', {
        columns: rebuildColumns.columns,
        frozenColumns: rebuildColumns.frozenColumns,
        toolbar: biz.getData('mode') === 'MOD' ? '#gridItm-qBar' : [],
        onClickCell: function (index, field, value) {
            if (biz.getData('mode') !== 'MOD') {
                return;
            }
            PHA_GridEditor.Edit({
                gridID: this.id,
                index: index,
                field: field,
                forceEnd: true
            });
        }
    });

    PHA_EVENT.Bind('#btnFind-q', 'click', function () {
        com.QueryMainGrid('gridMain-q', com.Condition('#qCondition-q', 'get'));
    });
    PHA_EVENT.Bind('#btnClean-q', 'click', function () {
        com.Condition('#qCondition-q', 'clear');
        $('#gridMain-q').datagrid('clear');
        $('#gridItm-q').datagrid('clear');
        SetDefaults();
    });
    PHA_EVENT.Bind('#btnRetClose-q', 'click', function () {
        $('#' + com.GetWindowId4Event()).window('close');
    });
    PHA_EVENT.Bind('#btnRetOk-q, #btnRetCopy-q', 'click', function () {
        var recID = com.GetSelectedRow('#gridMain-q', 'recID');
        if (recID === '') {
            components('Pop', '请先选择记录');
            return;
        }
        var winTarget = '#' + com.GetWindowId4Event();
        $.data($(winTarget)[0], 'retData', {
            recID: recID,
            type: this.id === 'btnRetCopy-q' ? 'copy' : ''
        });
        $(winTarget).window('close');
    });
    PHA_EVENT.Bind('#btnPrint-q', 'click', function () {
        com.Print(com.GetSelectedRow('#gridMain-q', 'recID'));
    });
    PHA_EVENT.Bind('#btnDelete-q', 'click', function () {
        var recID = com.GetSelectedRow('#gridMain-q', 'recID');
        if (recID === '') {
            components('Pop', '请先选择需要删除的记录');
            return;
        }
        PHA.Confirm('提示', '确认删除吗', function () {
            com.Invoke(com.Fmt2ApiMethod('Delete'), { recID: recID }, function (retData) {
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
                    $('#gridMain-q').datagrid('reload');
                }
            });
        });
    });
    PHA_EVENT.Bind('#btnSave-q', 'click', function () {
        biz.setData('handleStatus', 'Modify');
        Modify();
    });
    PHA_EVENT.Bind('#btnSaveItm-q', 'click', function () {
        biz.setData('handleStatus', 'ModifyItm');
        Modify();
    });
    function Modify(callback) {
        PHA_GridEditor.End('gridMain-q');
        PHA_GridEditor.End('gridItm-q');
        var apiMethod = com.Fmt2ApiMethod(biz.getData('handleStatus'));
        if (apiMethod === '') {
            return;
        }
        var rowIndex = com.GetSelectedRowIndex('#gridMain-q');
        var sel = com.GetSelectedRow('#gridMain-q');
        if (sel === null) {
            components('Pop', '请先选择需要修改保存的记录');
            return;
        }
        var recID = sel.recID;
        var mainObj = {
            recID: recID
        };
        if (PHA_GridEditor.IsCellChanged('#gridMain-q', rowIndex, 'vendor')) {
            if (biz.getData('handleStatus') === 'Modify') {
                mainObj.vendor = sel.vendor;
            }
        }

        var rows = [];
        if (biz.getData('handleStatus') === 'ModifyItm') {
            var gridRows = $('#gridItm-q').datagrid('getRows');
            var changedRows = com.GetChangedRows('gridItm-q');
            for (var i = 0, len = gridRows.length; i < len; i++) {
                var row = gridRows[i];
                if (changedRows.indexOf(row) < 0) {
                    continue;
                }
                var rowData = GetChangedCellRowData('#gridItm-q', i);
                rowData.recItmID = row.recItmID;
                rows.push(rowData);
            }
        }
        
        PHA.Confirm('提示', '您确认修改吗?', function () {
	        com.Invoke(apiMethod, { main: mainObj, rows: rows }, function (retData) {
                if (typeof retData === 'string') {
                    PHA.Alert('', retData, 'warning');
                } else {
                    // if (callback) {
                    components('Pop', '保存成功');
                    if (biz.getData('handleStatus') === 'ModifyItm') {
                        $('#gridItm-q').datagrid('reload');
                    } else {
                        $('#gridMain-q').datagrid('reload');
                    }
                    // callback(recID);
                    // }
                }
            });
	    });
        
        /*
        $.messager.prompt('确认', '请输入修改数据的原因', function (r) {
            if (r !== undefined) {
                if (r === '') {
                    components('Pop', '请输入修改数据的原因');
                    return false;
                }
                mainObj.remarks = r;
                com.Invoke(apiMethod, { main: mainObj, rows: rows }, function (retData) {
                    if (typeof retData === 'string') {
                        PHA.Alert('', retData, 'warning');
                    } else {
                        // if (callback) {
                        components('Pop', '保存成功');
                        if (biz.getData('handleStatus') === 'ModifyItm') {
                            $('#gridItm-q').datagrid('reload');
                        } else {
                            $('#gridMain-q').datagrid('reload');
                        }
                        // callback(recID);
                        // }
                    }
                });
            } else {
            }
        });
        */
        
    }

    function GetChangedCellRowData(target, index) {
        var retRow = {};
        var rowData = $(target).datagrid('getRows')[index];
        for (var field in rowData) {
            if (PHA_GridEditor.IsCellChanged(target, index, field)) {
                retRow[field] = rowData[field];
            }
        }
        return retRow;
    }
    function ControlOperation() {
        $('#btnRetOk-q,#btnDelete-q,#btnRetCopy-q').linkbutton('disable');
        var sel = com.GetSelectedRow('#gridMain-q');
        if (!sel) {
            return;
        }
        var statusCode = sel.status;
        if (statusCode === 'SAVE') {
            $('#btnDelete-q').linkbutton('enable');
        }
        if (statusCode !== 'CANCEL') {
            $('#btnRetOk-q').linkbutton('enable');
        }
        $('#btnRetCopy-q').linkbutton('enable');
    }
    function SetDefaults() {
        PHA.SetVals(biz.getData('defaultData'));
    }
    setTimeout(function () {
        var defaultData = settings.DefaultData;
        // 本应全部追加 -q
        defaultData['startDate-q'] = defaultData.startDate;
        defaultData['endDate-q'] = defaultData.endDate;
        $.extend(biz.getData('defaultData')[0], defaultData);
        SetDefaults();
        // 控修改的权限
        com.SetPage('pha.in.v3.rec.query.csp');
        ControlOperation();
    }, 0);
});

