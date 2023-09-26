/**
 * 模块:     配液小类维护,归属于配液中心
 * 编写日期: 2019-04-02
 * 编写人:   yunhaibao
 */
var HospId = session['LOGON.HOSPID'];
$(function() {
    InitHospCombo();
    InitGridCat(); //初始化列表
    $('#btnAdd').on('click', function() {
        $('#gridCat').datagrid('addNewRow', {
            editField: 'catCode'
        });
    });
    $('#btnSave').on('click', function() {
        Save();
    });
    $('#btnDelete').on('click', DeleteHandler);
    $('.dhcpha-win-mask').remove();
});

function InitGridCat() {
    var columns = [
        [
            {
                field: 'catId',
                title: 'catId',
                hidden: true
            },
            {
                field: 'catCode',
                title: '代码',
                width: 225,
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'catDesc',
                title: '名称',
                width: 225,
                align: 'left',
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
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Cat',
            QueryName: 'DHCPHCPivaCat',
            HospId: HospId
        },
        columns: columns,
        toolbar: '#gridCatBar',
        onClickRow: function(rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'ingredCode'
                });
            }
        },
        onBeforeLoad: function(param) {
            param.HospId = HospId;
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridCat', dataGridOption);
}

function Save() {
    $('#gridCat').datagrid('endEditing');
    var gridChanges = $('#gridCat').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }
    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params =
            (iData.catId || '') + '^' + (iData.catCode || '') + '^' + (iData.catDesc || '');
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.Cat', 'SaveMulti', paramsStr, HospId);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'warning');
    }
    $('#gridCat').datagrid('query', {});
}

function DeleteHandler() {
    var gridSelect = $('#gridCat').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要删除的记录',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function(r) {
        if (r) {
            var catId = gridSelect.catId;
            if (catId == undefined || catId == '') {
                var rowIndex = $('#gridCat').datagrid('getRowIndex', gridSelect);
                $('#gridCat').datagrid('deleteRow', rowIndex);
            } else {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.Cat', 'Delete', catId, HospId);
                var delArr = delRet.split('^');
                var delVal = delArr[0];
                var delInfo = delArr[1];
                if (delVal < 0) {
                    $.messager.alert('提示', delInfo, 'warning');
                } else {
                    $('#gridCat').datagrid('query', {});
                }
            }
        }
    });
}

function InitHospCombo() {
	var genHospObj=PIVAS.AddHospCom({tableName:'DHC_PHCPivaCat'});
	if (typeof genHospObj ==='object'){
        genHospObj.options().onSelect =  function(index, record) {	
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                $('#gridCat').datagrid('load');
            }
        }
    }
}
