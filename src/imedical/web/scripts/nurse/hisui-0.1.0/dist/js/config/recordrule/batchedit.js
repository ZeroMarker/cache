/*
 * @Descripttion: 护理病历模板功能配置
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
 * @description: 批量录入列表
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
            { field: 'Name', title: '表单名称', width: 300 },
            { field: 'Cols', title: '可编辑列', width: 300 },
            { field: 'Codes', title: '列代码', width: 300, hidden: true },
            { field: 'Guid', title: 'Guid', width: 250 },
            { field: 'Id', title: 'ID', width: 100, hidden: true }
        ]],
        singleSelect: true,
        loadMsg: '加载中..',
        onDblClickRow: function (rowIndex, rowData) {
            showColumnDialog();
        }
    });
}
/**
 * @description: 刷新列表
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
 * @description: 加入批量录入列表
 */
function addToBatchList() {
    if (!parent.GLOBAL.Template) {
        $.messager.alert("提示", "请选择模板！", "info");
        return;
    }
    if (!!parent.GLOBAL.Template.children) {
        $.messager.alert("提示", "请选择子节点！", "info");
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
 * @description: 从批量录入列表移除
 */
function removeFromList() {
    var rows = $('#tbBatchEdit').datagrid('getSelections');
    if (rows.length < 1) {
        $.messager.alert("提示", "请选择需要删除的表单！", "info");
        return;
    }
    var ids = null;
    $.each(rows, function (index, row) {
        ids = !!ids ? ids + '^' + row.Id : row.Id;
    });
    $.messager.confirm("警告", "确定要删除吗？", function (r) {
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
 * @description: 列编辑窗口
 */
function showColumnDialog() {
    var rows = $('#tbBatchEdit').datagrid('getSelections');
    if (rows.length < 1) {
        $.messager.alert("提示", "请选择需要维护的表单！", "info");
        return;
    }
    $('#dialogColumn').dialog({
        title: '列维护',
        buttons: [{
            text: '保存',
            handler: saveCol
        }, {
            text: '关闭',
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
 * @description: 初始化可编辑列表格
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
            { field: 'Name', title: '名称', width: 150 },
            { field: 'Key', title: '字段', width: 120 },
            { field: 'Code', title: '代码', width: 150 }
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
 * @description: 保存可编辑列
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
 * @description: 事件
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