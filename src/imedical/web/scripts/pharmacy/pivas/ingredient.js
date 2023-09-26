/**
 * ģ��:     ҩѧ�ɷ��ֵ�ά��
 * ��д����: 2018-02-23
 * ��д��:   yunhaibao
 */
var HospId = session['LOGON.HOSPID'];
$(function() {
    // ��λ
    GridCmbCtUom = PIVAS.GridComboBox.Init({ Type: 'CtUom' }, { editable: false });
    InitGridIngredient(); //��ʼ���б�
    $('#btnAdd').on('click', function() {
        $('#gridIngredient').datagrid('addNewRow', { editField: 'ingredCode' });
    });
    $('#btnSave').on('click', function() {
        SavePhcIngredient();
    });
    $('#btnDelete').on('click', DeleteHandler);
    $('.dhcpha-win-mask').remove();
});

function InitGridIngredient() {
    var columns = [
        [
            { field: 'ingredId', title: 'ingredId', hidden: true },
            {
                field: 'ingredCode',
                title: '�ɷִ���',
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
                field: 'ingredDesc',
                title: '�ɷ�����',
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
                field: 'ingredUomDesc',
                title: '�ɷֵ�λ����',
                width: 150,
                hidden: true
            },
            {
                field: 'ingredUomId',
                title: '�ɷֵ�λ',
                width: 150,
                descField: 'ingredUomDesc',
                hidden: true,
                editor: GridCmbCtUom,
                formatter: function(value, row, index) {
                    return row.ingredUomDesc;
                }
            },
            {
                field: 'ingredDupli',
                title: '��������',
                width: 200,
                halign: 'center',
                align: 'center',
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Ingredient',
            QueryName: 'PHCIngredient'
        },
        columns: columns,
        toolbar: '#gridIngredientBar',
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
    DHCPHA_HUI_COM.Grid.Init('gridIngredient', dataGridOption);
}

function Query() {
    $('#gridIngredient').datagrid({
        queryParams: {
            StrParams: ''
        }
    });
}

function SavePhcIngredient() {
    $('#gridIngredient').datagrid('endEditing');
    var gridChanges = $('#gridIngredient').datagrid('getChanges');
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
            (iData.ingredId || '') +
            '^' +
            (iData.ingredCode || '') +
            '^' +
            (iData.ingredDesc || '') +
            '^' +
            (iData.ingredUomId || '');
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.Ingredient', 'Save', paramsStr, HospId);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('��ʾ', saveInfo, 'warning');
    }
    $('#gridIngredient').datagrid('query', {});
}

function DeleteHandler() {
    var gridSelect = $('#gridIngredient').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ����Ҫɾ���ļ�¼',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function(r) {
        if (r) {
            var ingredId = gridSelect.ingredId;
            if (ingredId == undefined || ingredId == '') {
                var rowIndex = $('#gridIngredient').datagrid('getRowIndex', gridSelect);
                $('#gridIngredient').datagrid('deleteRow', rowIndex);
            } else {
                var delRet = tkMakeServerCall(
                    'web.DHCSTPIVAS.Ingredient',
                    'DeleteIngred',
                    ingredId,
                    HospId
                );
                $('#gridIngredient').datagrid('query', {});
            }
        }
    });
}

function InitHospCombo() {
	var genHospObj=PIVAS.AddHospCom({});
	if (typeof genHospObj ==='object'){
        //����ѡ���¼�
        $('#_HospList').combogrid('options').onSelect = function(index, record) {
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                $('#gridIngredient').datagrid('load');
            }
        };
    }
}
