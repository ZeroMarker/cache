/**
 * 名称:	 住院移动药房-备药规则维护
 * 编写人:	 yunhaibao
 * 编写日期: 2020-04-14
 */

$(function () {
    InitDict();
    InitGridDrawSort();
    InitGridDrawSortItm();
    PHA.SearchBox('conAlias', {
        width: 265,
        searcher: QueryDrawSortItm,
        placeholder: '请输入药品名称或货位码回车查询...'
    });
    $('#btnAdd').on('click', function () {
        var loc = $('#conPhaLoc').combobox('getValue');
        if (loc === '') {
            PHA.Popover({
                msg: '请先选择药房',
                type: 'alert'
            });
        } else {
            $('#gridDrawSort').datagrid('addNewRow', {
                defaultRow: { phdwsLoc: loc }
            });
            QueryDrawSortItm();
        }
    });
    $('#btnFind').on('click', QueryDrawSort);
    $('#btnSave').on('click', Save);
    $('#btnDelete').on('click', Delete);
    // $('#btnSaveItm').on('click', SaveItm);
});
function InitDict() {
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('IP').url,
        width: 223,
        editable: false,
        panelHeight: 'auto',
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
        },
        onSelect: function () {
            QueryDrawSort();
        }
    });
}

function InitGridDrawSort() {
    var columns = [
        [
            {
                field: 'phdws',
                title: 'ID',
                width: 100,
                hidden: true
            },
            {
                field: 'phdwsLoc',
                title: '药房ID',
                width: 100,
                hidden: true
            },
            {
                field: 'phdwsCode',
                title: '代码',
                width: 100,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'phdwsDesc',
                title: '名称',
                width: 100,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        pagination: false,
        columns: columns,
        fitColumns: true,
        toolbar: '#gridDrawSortBar',
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
            if ($(this).datagrid('options').editIndex == undefined) {
                QueryDrawSortItm();
            }
        },
        onDblClickRow: function (rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'phdwsCode'
            });
        }
    };
    PHA.Grid('gridDrawSort', dataGridOption);
}
function InitGridDrawSortItm() {
    var columns = [
        [
            {
                field: 'phdsi',
                title: '货位码',
                width: 200,
                hidden: true
            },
            {
                field: 'stkBin',
                title: '货位码',
                width: 200,
                hidden: true
            },
            {
                field: 'stkBinDesc',
                title: '货位码',
                width: 200
            },
            {
                field: 'sn',
                title: '货位顺序',
                width: 100,
                align: 'center',
                editor: {
                    type: 'numberbox',
                    options: {
                        required: false
                    }
                },
                formatter: function (value, row, index) {
                    return '<span style="color:#15b398;font-weight:bold;border-bottom: 5px solid #E6EEF8;font-size:16px" >' + value + '</span>';
                }
            },
            {
                field: 'inciDescStr',
                title: '货位已关联的药品',
                width: $('#panelSortItm').width() - 320
            }
        ]
    ];
    var dataGridOption = {
        pagination: true,
        pageSize: 100,
        pageList: [30, 50, 100, 300],
        columns: columns,
        fitColumns: false,
        toolbar: '#gridDrawSortItmBar',
        onClickRow: function (rowIndex, rowData) {},
        onClickCell: function (rowIndex, field, value) {
            if (field === 'sn') {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: field
                });
                var ed = $(this).datagrid('getEditor', {
                    index: rowIndex,
                    field: field
                });
                var $target = $(ed.target);
                $target.focus().select();
                
                // 绑定事件
                var pEvents = $._data($target[0], 'events');
                if (!pEvents.keydown) {
					$($target[0]).on('keydown', function () {});
				}
				pEvents = $._data($target[0], 'events');
				// 回车保存
				if (!pEvents.keydown[0].__handler) {
					pEvents.keydown[0].__handler = pEvents.keydown[0].handler;
				}
				pEvents.keydown[0].handler = function (e) {
					e.stopPropagation();
					pEvents.keydown[0].__handler.call(this, e);
					if (e.keyCode == 13) {
						SaveItm();
					}
				}
            } else {
                $(this).datagrid('endEditing');
                SaveItm();
            }
        },
        onEndEdit: function (rowIndex, rowData) {
            // 保存啊
        }
    };
    PHA.Grid('gridDrawSortItm', dataGridOption);
}

function QueryDrawSort() {
    var loc = $('#conPhaLoc').combobox('getValue');
    if (loc === '') {
        PHA.Popover({
            msg: '请先选择药房',
            type: 'alert'
        });
        return;
    }
    var pJson = {
        loc: loc
    };
    $('#gridDrawSort').datagrid('options').url = $URL;
    $('#gridDrawSort').datagrid('query', {
        ClassName: 'PHA.IP.DrawSort.Query',
        QueryName: 'PHDrawSort',
        rows: 9999,
        pJsonStr: JSON.stringify(pJson)
    });
    
    $('#gridDrawSortItm').datagrid('clear');
}

function QueryDrawSortItm() {
    var gridSelect = $('#gridDrawSort').datagrid('getSelected');
    if (gridSelect === null) {
        PHA.Popover({
            msg: '请先选择左侧备药规则记录',
            type: 'alert'
        });
        return;
    }
    var alias = $('#conAlias').searchbox('getValue') || '';
    var pJson = {
        phdws: gridSelect.phdws || '',
        alias: alias
    };
    $('#gridDrawSortItm').datagrid('options').url = $URL;
    $('#gridDrawSortItm').datagrid('query', {
        ClassName: 'PHA.IP.DrawSort.Query',
        QueryName: 'PHDrawSortItm',
        pJsonStr: JSON.stringify(pJson)
    });
}

function Save() {
    var $grid = $('#gridDrawSort');
    if ($grid.datagrid('endEditing') === false) {
        PHA.Popover({
            msg: '请先完成必填项数据',
            type: 'alert'
        });
        return;
    }
    var gridChanges = $grid.datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }

    var repeatObj = $grid.datagrid('checkRepeat', [['phdwsCode'], ['phdwsDesc']]);
    if (typeof repeatObj.pos === 'number') {
        PHA.Popover({
            msg: '第' + (repeatObj.pos + 1) + '、' + (repeatObj.repeatPos + 1) + '行:' + repeatObj.titleArr.join('、') + '重复',
            type: 'alert'
        });
        return;
    }

    var dataArr = [];
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        if ($grid.datagrid('getRowIndex', iData) < 0) {
            continue;
        }
        var iJson = {
            phdws: iData.phdws || '',
            phdwsLoc: iData.phdwsLoc,
            phdwsCode: iData.phdwsCode,
            phdwsDesc: iData.phdwsDesc
        };
        dataArr.push(iJson);
    }
    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.Data.Api',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.IP.DrawSort.Save',
            pMethodName: 'SaveHandler',
            pJsonStr: JSON.stringify(dataArr)
        },
        false
    );
    if (retJson.success === 'N') {
        var msg = PHAIP_COM.DataApi.Msg(retJson);
        PHA.Alert('提示', msg, 'warning');
    } else {
        $grid.datagrid('query', {});
    }
}

function Delete() {
    var gridSelect = $('#gridDrawSort').datagrid('getSelected') || '';
    if (gridSelect === '') {
        PHA.Popover({
            msg: '请先选中需要删除的记录',
            type: 'alert'
        });
        return;
    }
    PHA.ConfirmPrompt('删除提示', '您正在操作 <span style="color:red;font-weight:bold">删除</span>', function () {
        var rowID = gridSelect.phdws || '';
        var rowIndex = $('#gridDrawSort').datagrid('getRowIndex', gridSelect);
        if (rowID != '') {
            var dataArr = [];
            dataArr.push(rowID);
            var retJson = $.cm(
                {
                    ClassName: 'PHA.IP.Data.Api',
                    MethodName: 'HandleInOne',
                    pClassName: 'PHA.IP.DrawSort.Save',
                    pMethodName: 'Delete',
                    pJsonStr: JSON.stringify(dataArr)
                },
                false
            );
            if (retJson.success === 'false') {
                PHA.Alert('提示', retJson.message, 'warning');
            }
        }
        $('#gridDrawSort').datagrid('deleteRow', rowIndex);
        $('#gridDrawSortItm').datagrid('clear');
    });
}

function SaveItm() {
    var $grid = $('#gridDrawSortItm');
    $grid.datagrid('endEditing');
    var gridDrawSortSelect = $('#gridDrawSort').datagrid('getSelected');
    if (gridDrawSortSelect === null) {
        PHA.Popover({
            msg: '请先选择左侧备药规则',
            type: 'alert'
        });
        return;
    }
    var phdws = gridDrawSortSelect.phdws || '';
    if (phdws === '') {
        PHA.Popover({
            msg: '请先保存您选择的备药规则',
            type: 'alert'
        });
        return;
    }

    var gridChanges = $grid.datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        return;
    }

    var dataArr = [];
    for (var i = 0; i < gridChangeLen; i++) {
        var warnMsg = '';
        var iData = gridChanges[i];
        var sn = iData.sn || '';
        if (sn != '') {
            if (isNaN(sn)) {
                warnMsg = '请输入数字';
            } else if (parseInt(sn) < 0) {
                warnMsg = '不能输入负数';
            }
        }
        if (warnMsg != '') {
            PHA.Popover({
                msg: warnMsg,
                type: 'alert'
            });
            return;
        }
        var iJson = {
            phdws: phdws,
            phdwsi: iData.phdwsi,
            stkBin: iData.stkBin,
            sn: sn
        };
        dataArr.push(iJson);
    }
    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.Data.Api',
            MethodName: 'HandleInOne',
            pClassName: 'PHA.IP.DrawSort.Save',
            pMethodName: 'SaveItmHandler',
            pJsonStr: JSON.stringify(dataArr)
        },
        false
    );
    if (retJson.success === 'N') {
        PHA.Alert('提示', PHAIP_COM.DataApi.Msg(retJson), 'warning');
    }
    $grid.datagrid('reload');
}
