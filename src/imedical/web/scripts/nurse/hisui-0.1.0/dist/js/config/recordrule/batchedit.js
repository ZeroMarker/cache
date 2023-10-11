/*
 * @Descripttion: ������ģ�幦������
 * @Author: yaojining
 * @Date: 2021-12-29 17:09:38
 */
var GLOBAL = {
    ClassName: 'NurMp.Service.Template.Rule',
};
var init = function () {
    initBatchGrid();
    listenEvent();
};

$(init);

/**
 * @description: ����¼���б�
 */
function initBatchGrid() {
    $('#tbBatchEdit').datagrid({
        url: $URL,
        queryParams: {
            ClassName: GLOBAL.ClassName,
            QueryName: 'FindBETemplate',
            HospitalID: HospitalID,
            FilterDesc: $('#sbBatch').searchbox('getValue')
        },
        fit: true,
        nowrap: false,
        columns: [[
            { field: 'Name', title: '������', width: 300 },
            { field: 'Cols', title: '�ɱ༭��', width: 300 },
            { field: 'Codes', title: '�д���', width: 300, hidden: true },
            { field: 'Guid', title: 'Guid', width: 250 },
            { field: 'Id', title: 'ID', width: 100, hidden: true }
        ]],
        singleSelect: true,
        loadMsg: '������..',
        onDblClickRow: function (rowIndex, rowData) {
            showColumnDialog();
        }
    });
}
/**
 * @description: ˢ���б�
 */
function reloadBatchGrid() {
    $('#tbBatchEdit').datagrid('reload', {
        ClassName: GLOBAL.ClassName,
        QueryName: 'FindBETemplate',
        HospitalID: HospitalID,
        FilterDesc: $('#sbBatch').searchbox('getValue')
    });
}
/**
 * @description: ��������¼���б�
 */
function addToBatchList() {
    if (!parent.GLOBAL.Template) {
        $.messager.alert("��ʾ", "��ѡ��ģ�壡", "info");
        return;
    }
    if (!!parent.GLOBAL.Template.children) {
        $.messager.alert("��ʾ", "��ѡ���ӽڵ㣡", "info");
        return;
    }
    var dataArr = new Array();
    var dataObj = new Object();
    dataObj['BEHospDr'] = HospitalID;
    dataObj['BEGuid'] = parent.GLOBAL.Template.guid;
    dataArr.push(dataObj);
    $cm({
        ClassName: GLOBAL.ClassName,
        MethodName: 'AddToBatchList',
        Param: JSON.stringify(dataArr)
    }, function (result) {
        if (result.status >= 0) {
            $.messager.popover({
                msg: result.msg,
                type: 'success',
                style: {
                    bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
                    right: 10
                }
            });
            reloadBatchGrid();
        } else {
            $.messager.popover({
                msg: result.msg,
                type: 'error',
                style: {
                    bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
                    right: 10
                }
            });
        }
    });
}
/**
 * @description: ������¼���б��Ƴ�
 */
function removeFromList() {
    var rows = $('#tbBatchEdit').datagrid('getSelections');
    if (rows.length < 1) {
        $.messager.alert("��ʾ", "��ѡ����Ҫɾ���ı���", "info");
        return;
    }
    var ids = null;
    $.each(rows, function (index, row) {
        ids = !!ids ? ids + '^' + row.Id : row.Id;
    });
    $.messager.confirm("����", "ȷ��Ҫɾ����", function (r) {
        if (r) {
            $cm({
                ClassName: GLOBAL.ClassName,
                MethodName: 'RemoveFromList',
                Ids: ids
            }, function (result) {
                if (result.status >= 0) {
                    $.messager.popover({
                        msg: result.msg,
                        type: 'success',
                        style: {
                            bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
                            right: 10
                        }
                    });
                    reloadBatchGrid();
                } else {
                    $.messager.popover({
                        msg: result.msg,
                        type: 'error',
                        style: {
                            bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
                            right: 10
                        }
                    });
                    return;
                }
            });
        } else {
            return;
        }
    });
}
/**
 * @description: �б༭����
 */
function showColumnDialog() {
    var rows = $('#tbBatchEdit').datagrid('getSelections');
    if (rows.length < 1) {
        $.messager.alert("��ʾ", "��ѡ����Ҫά���ı���", "info");
        return;
    }
    $('#dialogColumn').dialog({
        title: '��ά��',
        buttons: [{
            text: '����',
            handler: saveCol
        }, {
            text: '�ر�',
            handler: function () {
                $('#dialogColumn').dialog("close");
            }
        }],
        width: 500,
        height: 500,
        onOpen: function (e) {
            initGridCol();
        },
        closed: false
    });
}
/**
 * @description: ��ʼ���ɱ༭�б��
 */
function initGridCol() {
    var template = $('#tbBatchEdit').datagrid('getSelected');
    if (template.length < 1) {
        return;
    }
    var editCols = template.Codes.split(',');
    $('#gridColumn').datagrid({
        url: $URL,
        queryParams: {
            ClassName: GLOBAL.ClassName,
            QueryName: 'FindColumns',
            Guid: template.Guid,
            LocId: session['LOGON.CTLOCID']
        },
        columns: [[
            { field: 'Checkbox', title: 'sel', checkbox: true },
            { field: 'Name', title: '����', width: 150 },
            { field: 'Key', title: '�ֶ�', width: 120 },
            { field: 'Code', title: '����', width: 150 }
        ]],
        nowrap: false,
        onLoadSuccess: function (data) {
            $('#gridColumn').datagrid('clearChecked');
            $.each(data.rows, function (index, row) {
                if ($.inArray(row.Code, editCols) > -1) {
                    $('#gridColumn').datagrid('selectRow', index);
                }
            });
        },
    });
}
/**
 * @description: ����ɱ༭��
 */
function saveCol() {
    var tempBatch = $('#tbBatchEdit').datagrid('getSelected');
    var id = tempBatch.Id;
    var rows = $('#gridColumn').datagrid('getSelections');
    var codes = null;
    $.each(rows, function (index, row) {
        codes = !!codes ? codes + '^' + row.Code : row.Code;
    });
    var dataArr = new Array();
    var dataObj = new Object();
    dataObj['RowID'] = id;
    dataObj['BEColumn'] = codes;
    dataArr.push(dataObj);
    $cm({
        ClassName: GLOBAL.ClassName,
        MethodName: 'AddToBatchList',
        Param: JSON.stringify(dataArr)
    }, function (result) {
        if (result.status >= 0) {
            $('#dialogColumn').dialog("close");
            $.messager.popover({
                msg: result.msg,
                type: 'success',
                style: {
                    bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
                    right: 10
                }
            });
            reloadBatchGrid();
        } else {
            $.messager.popover({
                msg: result.msg,
                type: 'error',
                style: {
                    bottom: -document.body.scrollTop - document.documentElement.scrollTop + 10,
                    right: 10
                }
            });
        }
    });
}
/**
 * @description: �¼�
 */
function listenEvent() {
    $('#btnAdd').bind('click', addToBatchList);
    $('#btnRemove').bind('click', removeFromList);
    $('#btnCol').bind('click', showColumnDialog);
    $('#sbBatch').searchbox("textbox").keydown(function (e) {
        if (e.keyCode == 13) {
            reloadBatchGrid();
        }
    });
    $('.searchbox-button').bind('click', function() {
        reloadBatchGrid();
    });
}