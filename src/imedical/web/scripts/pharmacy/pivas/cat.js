/**
 * ģ��:     ��ҺС��ά��,��������Һ����
 * ��д����: 2019-04-02
 * ��д��:   yunhaibao
 */
var HospId = session['LOGON.HOSPID'];
$(function() {
    InitHospCombo();
    InitGridCat(); //��ʼ���б�
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
                title: '����',
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
                title: '����',
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
            msg: 'û����Ҫ���������',
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
        $.messager.alert('��ʾ', saveInfo, 'warning');
    }
    $('#gridCat').datagrid('query', {});
}

function DeleteHandler() {
    var gridSelect = $('#gridCat').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ����Ҫɾ���ļ�¼',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function(r) {
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
                    $.messager.alert('��ʾ', delInfo, 'warning');
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
