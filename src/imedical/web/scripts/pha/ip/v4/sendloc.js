/**
 * ����:	 סԺ�ƶ�ҩ��-��ҩ����ά��
 * ��д��:	 yunhaibao
 * ��д����: 2020-03-14
 */

$(function () {
    InitDict();
    InitGridWardLoc();
    InitGridSendLoc();
    PHA.SearchBox('conWardAlias', {
        width: 265,
        searcher: QueryWardLoc,
        placeholder: '�������ƴ�����ƻس���ѯ...'
    });
    $('#btnFind').on('click', function () {
        QuerySendLoc();
    });
    $('#btnSave').on('click', Save);
    $('#btnDelete').on('click', Delete);
    QueryWardLoc();
});
function InitDict() {
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('IP').url,
        width: 192,
        editable: false,
        panelHeight: 'auto',
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
        },
        onSelect: function () {
            QuerySendLoc();
        }
    });
}
function InitGridSendLoc() {
    var columns = [
        [
            {
                field: 'phsl',
                title: 'phsl',
                width: 100,
                hidden: true
            },
            {
                field: 'loc',
                title: 'ҩ��',
                width: 100,
                hidden: true
            },
            {
                field: 'wardLoc',
                title: '����',
                width: 100,
                hidden: true
            },
            {
                field: 'wardLocDesc',
                title: '����',
                width: 250
            },
            {
                field: 'sendFlag',
                title: '�Ƿ���ҩ',
                width: 100,
                align: 'center',
                editor: {
                    type: 'icheckbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return '';
                    }
                }
            },
            {
                field: 'wardQue',
                title: '��ʾ���',
                width: 100,
                editor: {
                    type: 'numberbox',
                    options: {
                        required: false
                    }
                }
            },
            {
                field: 'sendFreqDesc',
                title: '��ҩƵ������',
                width: 100,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: false
                    }
                }
            },

            {
                field: 'sendFreqFac',
                title: '��ҩƵ��ϵ��',
                width: 100,
                editor: {
                    type: 'numberbox',
                    options: {
                        required: false
                    }
                }
            },
            {
                field: 'sendFac',
                title: '����ϵ��',
                width: 100,
                editor: {
                    type: 'numberbox',
                    options: {
                        required: false
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        pagination: false,
        columns: columns,
        fitColumns: false,
        rownumbers: true,
        toolbar: '#gridSendLocBar',
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
            if ($(this).datagrid('options').editIndex == undefined) {
            }
        },
        onDblClickRow: function (rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex
            });
        },
        onLoadSuccess:function(){
            QueryWardLoc();
        }
    };
    PHA.Grid('gridSendLoc', dataGridOption);
}
function InitGridWardLoc() {
    var columns = [
        [
            {
                field: 'wardLoc',
                title: '����',
                width: 200,
                hidden: true
            },
            {
                field: 'wardLocDesc',
                title: '����',
                width: 100
            },
            {
                field: 'wardOperate',
                title: '����',
                width: 20,
                align: 'center',
                formatter: function (value, rowData, rowIndex) {
                    return '<img title="���뵽��ҩ�����б�" onclick="AddToSendLoc()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/add.png" style="border:0px;cursor:pointer">';
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        pagination: false,
        columns: columns,
        fitColumns: true,
        rownumbers: true,
        toolbar: '#gridWardLocBar'
    };
    PHA.Grid('gridWardLoc', dataGridOption);
}

function AddToSendLoc() {
    var loc = $('#conPhaLoc').combobox('getValue');
    if (loc === '') {
        PHA.Popover({
            msg: '����ѡ��ҩ��',
            type: 'alert'
        });
        return;
    }
    var $target = $(event.target);
    var rowIndex = $target.closest('tr[datagrid-row-index]').attr('datagrid-row-index');
    var rowData = $('#gridWardLoc').datagrid('getRows')[rowIndex];
    var sendLocData = {
        wardLoc: rowData.wardLoc,
        wardLocDesc: rowData.wardLocDesc,
        loc: loc
    };
    $('#gridWardLoc').datagrid('deleteRow', rowIndex);
    $('#gridSendLoc').datagrid('appendRow', sendLocData);
    var rowLen = $('#gridSendLoc').datagrid('getRows').length;
    $('#gridSendLoc').datagrid('beginEditRow', {
        rowIndex: rowLen - 1
    });

    $('#gridWardLoc').datagrid('loadData', $('#gridWardLoc').datagrid('getRows'));
}

function QuerySendLoc() {
    var loc = $('#conPhaLoc').combobox('getValue');
    var pJson = {
        loc: loc
    };
    $('#gridSendLoc').datagrid('query', {
        ClassName: 'PHA.IP.SendLoc.Query',
        QueryName: 'PHSendLoc',
        rows: 9999,
        pJsonStr: JSON.stringify(pJson)
    });
}

function QueryWardLoc() {
    var loc = $('#conPhaLoc').combobox('getValue');
    var wardAlias = $('#conWardAlias').searchbox('getValue');
    var wardLocArr = [];
    var $gridSendLoc = $('#gridSendLoc');
    var rows = $gridSendLoc.datagrid('getRows');
    if (rows) {
        for (var i = 0; i < rows.length; i++) {
            var wardLoc = rows[i].wardLoc;
            wardLocArr.push(wardLoc);
        }
    }

    var pJson = {
        wardAlias: wardAlias,
        hosp: session['LOGON.HOSPID'],
        loc: loc,
        wardLocStr: wardLocArr.join(',')
    };
    $('#gridWardLoc').datagrid('query', {
        ClassName: 'PHA.IP.SendLoc.Query',
        QueryName: 'WardLoc',
        rows: 9999,
        pJsonStr: JSON.stringify(pJson)
    });
}

function Delete() {
    var $grid = $('#gridSendLoc');
    var gridSelect = $grid.datagrid('getSelected') || '';
    if (gridSelect === '') {
        PHA.Popover({
            msg: '����ѡ����Ҫɾ���ļ�¼',
            type: 'alert'
        });
        return;
    }
    PHA.Confirm('ɾ����ʾ', '�����ڲ��� <span style="color:red;font-weight:bold">ɾ��</span>', function () {
        var rowID = gridSelect.phsl || '';
        var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
        if (rowID != '') {
            var dataArr = [];
            dataArr.push(rowID);
            var retJson = $.cm(
                {
                    ClassName: 'PHA.IP.Data.Api',
                    MethodName: 'HandleInAll',
                    pClassName: 'PHA.IP.SendLoc.Save',
                    pMethodName: 'Delete',
                    pJsonStr: JSON.stringify(dataArr)
                },
                false
            );
            if (retJson.success === 'false') {
                PHA.Alert('��ʾ', retJson.message, 'warning');
            }
        }
        $grid.datagrid('deleteRow', rowIndex);
        QueryWardLoc();
    });
}

function Save() {
    var $grid = $('#gridSendLoc');
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
    var dataArr = [];
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        if ($grid.datagrid('getRowIndex', iData) < 0) {
            continue;
        }
        var iJson = {
            phsl: iData.phsl || '',
            loc: iData.loc,
            wardLoc: iData.wardLoc,
            sendFlag: iData.sendFlag,
            sendFreqDesc: iData.sendFreqDesc,
            sendFreqFac: iData.sendFreqFac,
            sendFac: iData.sendFac,
            wardQue: iData.wardQue
        };
        dataArr.push(iJson);
    }
    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.Data.Api',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.IP.SendLoc.Save',
            pMethodName: 'SaveHandler',
            pJsonStr: JSON.stringify(dataArr)
        },
        false
    );
    if (retJson.success === 'N') {
        var msg = PHAIP_COM.DataApi.Msg(retJson);
        PHA.Alert('��ʾ', msg, 'warning');
    } else {
        $grid.datagrid('reload');
    }
}
