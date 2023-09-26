/**
 * @description ҩƷά��-Ʒ��ͨ����
 */
var DHCPHCHEMICAL_RowId = '';

function DHCPHCHEMICAL() {
    $.parser.parse('#lyDHCPHChemical');
    InitGridDHCPHChemical();
    PHA.SearchBox('conChemAlias', {
        width: parseInt($('#gridDHCPHChemicalBar').width()) - 20,
        searcher: function (text) {
            $('#gridDHCPHChemical').datagrid('query', {
                InputStr: text,
                page: 1
            });
            $('#gridDHCPHChemical').datagrid('reload');
            $('#conChemAlias').next().children().select();
            DHCPHCHEMICAL_RowId = '';
        },
        placeholder: '�������ƴ�����ƻس���ѯ'
    });
    $('#btnSaveDHCPHChemical').on('click', function () {
        PHA.Confirm('��ʾ', '��ȷ�ϱ�����?', function () {
            SaveDHCPHChemical();
        });
    });
    $('#btnAddDHCPHChemical').on('click', function () {
        PHA.Confirm('��ʾ', '��ȷ��������?', function () {
            AddDHCPHChemical();
        });
    });
    $('#btnDelDHCPHChemical').on('click', function () {
        PHA.Confirm('��ʾ', '��ȷ��ɾ����?', function () {
            DelDHCPHChemical();
        });
    });
    $('#btnMaxDHCPHChemical').on('click', function () {
        PHA_UX.MaxCode(
            {
                tblName: 'DHC_PHChemical',
                codeName: 'PHCM_Code',
                title: '��ѯƷ��ͨ���������'
            },
            function (code) {
                $('#chemCode').val(code);
            }
        );
    });
    MakeToolTip();
}

/**
 * @description ��ʼ��Ʒ��ͨ�������
 */
function InitGridDHCPHChemical() {
    var columns = [
        [
            {
                field: 'chemId',
                title: 'RowId',
                width: 200,
                hidden: true
            },
            {
                field: 'chemCatGrpDesc',
                title: '����',
                width: 200,
                hidden: true
            },
            {
                field: 'chemCode',
                title: '����',
                width: 300
            },
            {
                field: 'chemDesc',
                title: '����',
                width: 500
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.DHCPHChemical.Query',
            QueryName: 'DHCPHChemical'
        },
        pagination: true,
        columns: columns,
        fitColumns: true,
        toolbar: '#gridDHCPHChemicalBar',
        enableDnd: false,
        onSelect: function (rowIndex, rowData) {
            $.cm(
                {
                    ClassName: 'PHA.IN.DHCPHChemical.Query',
                    MethodName: 'SelectDHCPHChemical',
                    ChemId: rowData.chemId,
                    ResultSetType: 'Array'
                },
                function (arrData) {
                    if (arrData.msg) {
                        PHA.Alert('������ʾ', arrData.msg, 'error');
                    } else {
                        PHA.SetVals(arrData);
                        DHCPHCHEMICAL_RowId = rowData.chemId;
                    }
                }
            );
        },
        onLoadSuccess: function (data) {
            PHA.DomData('#dataDHCPHChemical', {
                doType: 'clear'
            });
            var pageSize = $('#gridDHCPHChemical').datagrid('getPager').data('pagination').options.pageSize;
            var total = data.total;
            if (total > 0 && total <= pageSize) {
                $('#gridDHCPHChemical').datagrid('selectRow', 0);
            }
        }
    };
    PHA.Grid('gridDHCPHChemical', dataGridOption);
}

/**
 * @description ����
 */
function AddDHCPHChemical() {
    $('#gridDHCPHChemical').datagrid('clearSelections');
    PHA.DomData('#dataDHCPHChemical', {
        doType: 'clear'
    });
    $('#chemCode').focus();
    DHCPHCHEMICAL_RowId = '';
}

/**
 * @description ����
 */
function SaveDHCPHChemical() {
    var valsArr = PHA.DomData('#dataDHCPHChemical', {
        doType: 'save'
    });
    var valsStr = valsArr.join('^');
    if (valsStr == '') {
        return;
    }
    var saveRet = $.cm(
        {
            ClassName: 'PHA.IN.DHCPHChemical.Save',
            MethodName: 'Save',
            ChemId: DHCPHCHEMICAL_RowId,
            DataStr: valsStr,
            dataType: 'text'
        },
        false
    );
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Alert('��ʾ', saveInfo, 'warning');
        return;
    } else {
        PHA.Popover({
            msg: '����ɹ�',
            type: 'success'
        });
        DHCPHCHEMICAL_RowId = saveVal;
    }
}

/**
 * @description ɾ��
 */
function DelDHCPHChemical() {
    var gridSelect = $('#gridDHCPHChemical').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '����ѡ����Ҫɾ����Ʒ��ͨ����',
            type: 'alert'
        });
        return;
    }
    var chemId = gridSelect.chemId;
    var saveRet = $.cm(
        {
            ClassName: 'PHA.IN.DHCPHChemical.Save',
            MethodName: 'Delete',
            ChemId: chemId,
            dataType: 'text'
        },
        false
    );
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Alert('��ʾ', saveInfo, 'warning');
        return;
    } else {
        PHA.Popover({
            msg: 'ɾ���ɹ�',
            type: 'success'
        });
        DHCPHCHEMICAL_RowId = '';
        $('#gridDHCPHChemical').datagrid('reload');
        PHA.DomData('#dataDHCPHChemical', {
            doType: 'clear'
        });
    }
}
