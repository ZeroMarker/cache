/**
 * ����:	 סԺ�ƶ�ҩ��-��ҩ����ά��
 * ��д��:	 yunhaibao
 * ��д����: 2020-04-14
 */

$(function () {
    InitDict();
    InitGridDrawSort();
    InitGridDrawSortItm();
    PHA.SearchBox('conAlias', {
        width: 265,
        searcher: QueryDrawSortItm,
        placeholder: '������ҩƷ���ƻ��λ��س���ѯ...'
    });
    $('#btnAdd').on('click', function () {
        var loc = $('#conPhaLoc').combobox('getValue');
        if (loc === '') {
            PHA.Popover({
                msg: '����ѡ��ҩ��',
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
                title: 'ҩ��ID',
                width: 100,
                hidden: true
            },
            {
                field: 'phdwsCode',
                title: '����',
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
                title: '����',
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
                title: '��λ��',
                width: 200,
                hidden: true
            },
            {
                field: 'stkBin',
                title: '��λ��',
                width: 200,
                hidden: true
            },
            {
                field: 'stkBinDesc',
                title: '��λ��',
                width: 200
            },
            {
                field: 'sn',
                title: '��λ˳��',
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
                title: '��λ�ѹ�����ҩƷ',
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
                
                // ���¼�
                var pEvents = $._data($target[0], 'events');
                if (!pEvents.keydown) {
					$($target[0]).on('keydown', function () {});
				}
				pEvents = $._data($target[0], 'events');
				// �س�����
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
            // ���氡
        }
    };
    PHA.Grid('gridDrawSortItm', dataGridOption);
}

function QueryDrawSort() {
    var loc = $('#conPhaLoc').combobox('getValue');
    if (loc === '') {
        PHA.Popover({
            msg: '����ѡ��ҩ��',
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
            msg: '����ѡ����౸ҩ�����¼',
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
            msg: '������ɱ���������',
            type: 'alert'
        });
        return;
    }
    var gridChanges = $grid.datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        PHA.Popover({
            msg: 'û����Ҫ���������',
            type: 'alert'
        });
        return;
    }

    var repeatObj = $grid.datagrid('checkRepeat', [['phdwsCode'], ['phdwsDesc']]);
    if (typeof repeatObj.pos === 'number') {
        PHA.Popover({
            msg: '��' + (repeatObj.pos + 1) + '��' + (repeatObj.repeatPos + 1) + '��:' + repeatObj.titleArr.join('��') + '�ظ�',
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
        PHA.Alert('��ʾ', msg, 'warning');
    } else {
        $grid.datagrid('query', {});
    }
}

function Delete() {
    var gridSelect = $('#gridDrawSort').datagrid('getSelected') || '';
    if (gridSelect === '') {
        PHA.Popover({
            msg: '����ѡ����Ҫɾ���ļ�¼',
            type: 'alert'
        });
        return;
    }
    PHA.ConfirmPrompt('ɾ����ʾ', '�����ڲ��� <span style="color:red;font-weight:bold">ɾ��</span>', function () {
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
                PHA.Alert('��ʾ', retJson.message, 'warning');
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
            msg: '����ѡ����౸ҩ����',
            type: 'alert'
        });
        return;
    }
    var phdws = gridDrawSortSelect.phdws || '';
    if (phdws === '') {
        PHA.Popover({
            msg: '���ȱ�����ѡ��ı�ҩ����',
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
                warnMsg = '����������';
            } else if (parseInt(sn) < 0) {
                warnMsg = '�������븺��';
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
        PHA.Alert('��ʾ', PHAIP_COM.DataApi.Msg(retJson), 'warning');
    }
    $grid.datagrid('reload');
}
