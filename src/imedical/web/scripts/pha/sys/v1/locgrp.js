/**
 * ����:	 ҩ������ - ������ά��
 * ��д��:	 yunhaibao
 * ��д����: 2020-10-30
 */
$g('����');
$g('ȡ������');
PHA_COM.App.Csp = 'pha.sys.v1.locgrp.csp';
PHA_COM.App.Name = 'SYS.LOCGRP';
PHA_COM.App.Load = '';
$(function () {
    InitDict();
    InitGridLocGrp();
    InitGridLocGrpItm();
    InitGridLoc();
    InitEvents();
});

// �¼�
function InitEvents() {
    $('#btnAdd, #btnEdit').on('click', function () {
        ShowDiagLocGrp(this);
    });
    $('#btnFind').on('click', Query);
    $('#btnDel').on('click', Delete);
    $('#conNoGrp').checkbox('options').onCheckChange = QueryLoc;
    PHA.SearchBox('conAlias', {
        width: 210,
        searcher: QueryLoc,
        placeholder: '����������س���ѯ...'
    });
}

// �ֵ�
function InitDict() {
    // ��ʼ������
    PHA.ComboBox('conUserLoc', {
        width: 200,
        url: PHA_STORE.UserLoc().url + '&UserId=' + session['LOGON.USERID'],
        onLoadSuccess: function () {
            if (PHA_COM.App.Load == '') {
                var datas = $('#conUserLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == session['LOGON.CTLOCID']) {
                        $('#conUserLoc').combobox('select', datas[i].RowId);
                        break;
                    }
                }
            }
            PHA_COM.App.Load = 1;
        },
        onSelect: function () {
            Query();
        }
    });
    PHA.ComboBox('loc', {
        width:207,
        url: PHA_STORE.UserLoc().url + '&UserId=' + session['LOGON.USERID']
    });
    // ��ʼ������
    PHA.ComboBox('conAppType', {
        data: [
            {
                RowId: 'PIVASCOMMON',
                Description: $g('��Һ����')
            },
            {
                RowId: 'IPCOMMON',
                Description: $g('סԺҩ��')
            }
        ],
        panelHeight: 'auto'
    });
    PHA.ComboBox('appCode', {
        data: [
            {
                RowId: 'PIVASCOMMON',
                Description: $g('��Һ����')
            },
            {
                RowId: 'IPCOMMON',
                Description: $g('סԺҩ��')
            }
        ],
        panelHeight: 'auto'
    });
}

// ���-������
function InitGridLocGrp() {
    var columns = [
        [
            {
                field: 'locGrp',
                title: '������Id',
                hidden: true,
                width: 100
            },
            {
                field: 'loc',
                title: '����',
                width: 150,
                hidden: true
            },
            {
                field: 'locDesc',
                title: '����',
                width: 150
            },
            {
                field: 'appCode',
                title: '���ʹ���',
                width: 150,
                hidden: true
            },
            {
                field: 'appDesc',
                title: '����',
                width: 100,
                hidden: true
            },
            {
                field: 'locGrpCode',
                title: '����',
                width: 150
            },
            {
                field: 'locGrpDesc',
                title: '����',
                width: 150
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        columns: columns,
        toolbar: null,
        toolbar: '#gridLocGrpBar',
        enableDnd: false,
        fitColumns: true,
        exportXls: false,
        onClickRow: function (rowIndex, rowData) {
            QueryItm();
            QueryLoc();
        },
        onDblClickRow: function (rowIndex, rowData) {
            // $('#btnEdit').click();
        },
        onLoadSuccess: function () {
            $('#gridLocGrpItm').datagrid('clear');
            $('#gridLoc').datagrid('clear');
        }
    };

    PHA.Grid('gridLocGrp', dataGridOption);
}

// ���-��������ϸ
function InitGridLocGrpItm() {
    var columns = [
        [
            {
                field: 'locGrpItmID',
                title: 'locGrpItmID',
                hidden: true,
                width: 100
            },
            {
                field: 'operate',
                title: '����',
                align: 'center',
                formatter: function (value, rowData, rowIndex) {
                    return '<img class="js-grid-no" title=' + $g('ȡ������') + ' src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare_no.png" style="border:0px;cursor:pointer">';
                }
            },
            {
                field: 'loc',
                title: '����',
                hidden: true,
                width: 100
            },
            {
                field: 'locDesc',
                title: '����',
                width: 100
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        exportXls: false,
        pagination: false,
        columns: columns,
        fitColumns: true,
        toolbar: [],
        loadMsg: null,
        loadingMessage: null,
        onDblClickRow: function (rowIndex, rowData) {
            SaveLocGrpItm({
                loc: rowData.loc,
                locGrpItmID: rowData.locGrpItmID
            });
        }
    };
    PHA.Grid('gridLocGrpItm', dataGridOption);
    PHA.GridEvent('gridLocGrpItm', 'click', ['js-grid-no'], function (rowIndex, rowData, className) {
        SaveLocGrpItm({
            loc: rowData.loc,
            locGrpItmID: rowData.locGrpItmID
        });
    });
}
function InitGridLoc() {
    var columns = [
        [
            {
                field: 'loc',
                title: '����Id',
                width: 150,
                hidden: true
            },
            {
                field: 'operate',
                title: '����',
                align: 'center',
                formatter: function (value, rowData, rowIndex) {
                    return '<img class="js-grid-yes" title=' + $g('����') + ' src="../scripts_lib/hisui-0.1.0/dist/css/icons/compare.png" style="border:0px;cursor:pointer">';
                }
            },
            {
                field: 'locDesc',
                title: '����',
                width: 175
            },
            {
                field: 'locGrpDescStr',
                title: '����������'
                //width: $('#panelLoc').width() - 240
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        columns: columns,
        toolbar: '#gridLocBar',
        enableDnd: false,
        exportXls: false,
        loadMsg: null,
        loadingMessage: null,
        onDblClickRow: function (rowIndex, rowData) {
            SaveLocGrpItm({
                loc: rowData.loc
            });
        },
        rowStyler: function (index, rowData) {
            if (rowData.locGrpDescStr !== '') {
                return 'font-weight:bold';
            }
        }
    };

    PHA.Grid('gridLoc', dataGridOption);
    PHA.GridEvent('gridLoc', 'click', ['js-grid-yes'], function (rowIndex, rowData) {
        SaveLocGrpItm({
            loc: rowData.loc
        });
    });
}

function ShowDiagLocGrp(btnOpt) {
    var ifAdd = btnOpt.id.indexOf('Add') >= 0 ? true : false;
    var locGrp = '';
    if (ifAdd == false) {
        var gridSelect = $('#gridLocGrp').datagrid('getSelected') || '';
        if (gridSelect == '') {
            PHA.Popover({
                msg: '����ѡ����Ҫ�޸ĵĿ�����',
                type: 'alert'
            });
            return;
        }
        locGrp = gridSelect.locGrp || '';
        if (locGrp == '') {
            PHA.Popover({
                msg: '���ȱ��������޸ĵĿ�����',
                type: 'alert'
            });
            return;
        }
    }
    $('#diagLocGrp').dialog({
        title: '������' + btnOpt.text,
        iconCls: ifAdd ? 'icon-w-add' : 'icon-w-edit',
        modal: true
    });
    $('#diagLocGrp').dialog('open');
    $.data($('#diagLocGrp')[0], 'operateType', ifAdd ? 'add' : 'edit');
    if (ifAdd == false) {
        $('#diagLocGrp_btnAdd').hide();
        // �༭ʱ,����̨���ݼ���
        $.cm(
            {
                ClassName: 'PHA.SYS.LocGrp.Query',
                MethodName: 'SelectDHCStkLocGroup',
                locGrp: locGrp
            },
            function (jsonData) {
                PHA.SetVals([jsonData]);
            }
        );
    } else {
        var clearValueArr = ['loc', 'locGrpCode', 'locGrpDesc', 'appCode'];
        PHA.ClearVals(clearValueArr);
        var loc = $('#conUserLoc').combobox('getValue');
        if (loc !== '') {
            $('#loc').combobox('setValue', loc);
        }
    }
}
/**
 * @param {String} type 1(��������)
 */
function SaveLocGrp(type) {
    var title = $('#diagLocGrp').panel('options').title;
    var ifAdd = $.data($('#diagLocGrp')[0], 'operateType') === 'add' ? true : false;
    var locGrp = '';
    if (ifAdd == false) {
        var gridSelect = $('#gridLocGrp').datagrid('getSelected');
        locGrp = gridSelect.locGrp || '';
    }

    var loc = $('#loc').combobox('getValue') || '';
    var code = $('#locGrpCode').val().trim();
    var desc = $('#locGrpDesc').val().trim();
    if (loc === '' || code === '' || desc === '') {
        return;
    }

    var retJson = $.cm(
        {
            ClassName: 'PHA.COM.DataApi',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.SYS.LocGrp.Save',
            pMethodName: 'SaveHandler',
            pJsonStr: JSON.stringify([
                {
                    locGrp: locGrp,
                    loc: loc,
                    code: code,
                    desc: desc
                }
            ])
        },
        false
    );
    if (retJson.success === 'N') {
        PHA.Alert('��ʾ', retJson.message, 'warning');
    } else {
        PHA.Popover({
            msg: '����ɹ�',
            type: 'success',
            timeout: 500
        });
    }
    if (type == 1) {
        PHA.ClearVals(['locGrpCode', 'locGrpDesc']);
        $('#locGrpCode').focus();
    } else {
        if (retJson.success !== 'N') {
            $('#diagLocGrp').dialog('close');
        }
    }
    $('#gridLocGrp').datagrid('reload');
}

function Query() {
    var loc = $('#conUserLoc').combobox('getValue') || '';
    if (loc === '') {
        PHA.Popover({
            msg: '��ѡ����Һ��ѯ',
            type: 'alert'
        });
        return;
    }
    var pJson = {
        loc: loc,
        appCode: 'DHCSTCOMMON'
    };

    $('#gridLocGrp').datagrid('options').url = $URL;
    $('#gridLocGrp').datagrid('query', {
        ClassName: 'PHA.SYS.LocGrp.Query',
        QueryName: 'DHCStkLocGroup',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
}

// ɾ��������
function Delete() {
    var gridSelect = $('#gridLocGrp').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '����ѡ����Ҫɾ���Ŀ�����',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var locGrp = gridSelect.locGrp || '';

    PHA.Confirm('ɾ����ʾ', '��ȷ��ɾ����', function () {
        var retJson = $.cm(
            {
                ClassName: 'PHA.COM.DataApi',
                MethodName: 'HandleInAll',
                pClassName: 'PHA.SYS.LocGrp.Save',
                pMethodName: 'Delete',
                pJsonStr: JSON.stringify([locGrp])
            },
            false
        );
        if (retJson.success === 'N') {
            PHA.Alert('��ʾ', retJson.message, 'warning');
            return;
        } else {
            PHA.Popover({
                msg: 'ɾ���ɹ�',
                type: 'success'
            });
            $('#gridLocGrp').datagrid('reload');
        }
    });
}

function SaveLocGrpItm(rowData) {
    var gridSelect = $('#gridLocGrp').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '����ѡ�п������¼',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var locGrp = gridSelect.locGrp;
    var locGrpItmID = rowData.locGrpItmID || '';
    var loc = rowData.loc;

    var retJson = $.cm(
        {
            ClassName: 'PHA.COM.DataApi',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.SYS.LocGrp.Save',
            pMethodName: 'SaveItmHandler',
            pJsonStr: JSON.stringify([
                {
                    locGrp: locGrp,
                    locGrpItmID: locGrpItmID,
                    loc: loc
                }
            ])
        },
        false
    );
    if (retJson.success === 'N') {
        PHA.Alert('��ʾ', retJson.message, 'warning');
    } else {
        PHA.Popover({
            msg: (locGrpItmID !== '' ? 'ȡ��' : '') + '�����ɹ�',
            type: 'success',
            timeout: 500
        });
    }
    $('#gridLoc').datagrid('reload');
    $('#gridLocGrpItm').datagrid('reload');
}

function QueryItm() {
    var gridSelect = $('#gridLocGrp').datagrid('getSelected');
    if (gridSelect === null) {
        PHA.Popover({
            msg: '����ѡ����������',
            type: 'alert'
        });
        return;
    }
    var locGrp = gridSelect.locGrp;
    $('#gridLocGrpItm').datagrid('options').url = $URL;
    $('#gridLocGrpItm').datagrid('query', {
        ClassName: 'PHA.SYS.LocGrp.Query',
        QueryName: 'DHCStkLocGrpItm',
        pJsonStr: JSON.stringify({ locGrp: locGrp }),
        rows: 9999
    });
}

function QueryLoc() {
    var gridSelect = $('#gridLocGrp').datagrid('getSelected');
    if (gridSelect === null) {
        PHA.Popover({
            msg: '����ѡ����������',
            type: 'alert'
        });
        return;
    }
    var locGrp = gridSelect.locGrp;
    var alias = $('#conAlias').searchbox('getValue');
    var noGrp = $('#conNoGrp').checkbox('getValue') === true ? 'Y' : '';
    var pJson = {
        locGrp: locGrp,
        alias: alias,
        noGrp: noGrp
    };
    $('#gridLoc').datagrid('options').url = $URL;
    $('#gridLoc').datagrid('query', {
        ClassName: 'PHA.SYS.LocGrp.Query',
        QueryName: 'LocData',
        pJsonStr: JSON.stringify(pJson),
        rows: 9999
    });
}
