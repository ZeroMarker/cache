/**
 * @description ҩƷά��-Ʒ��ͨ����
 */
var DHCPHCHEMICAL_RowId = '';

function DHCPHCHEMICAL() {
    $.parser.parse('#lyDHCPHChemical');
    InitGridDHCPHChemical();

    $('#conChemAlias').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
	        QueryDHCPHCHEMICAL()       
        }
    });
    $('#btnFindChem').on('click', QueryDHCPHCHEMICAL);
    $('#btnSaveDHCPHChemical').on('click', function () {
        PHA.Confirm($g('��ʾ'), $g('��ȷ�ϸ�����?'), function () {
            SaveDHCPHChemical();
        });
    });
    $('#btnClearDHCPHChemical').on('click', function () {
        PHA.Confirm($g('��ʾ'), $g('��ȷ��������?'), function () {
            ClearDHCPHChemical();
        });
    });
    $('#btnAddDHCPHChemical').on('click', function () {
        PHA.Confirm($g('��ʾ'), $g('��ȷ��������?'), function () {
            AddDHCPHChemical();
        });
    });
    $('#btnDelDHCPHChemical').on('click', function () {
        PHA.Confirm($g('��ʾ'), $g('��ȷ��ɾ����?'), function () {
            DelDHCPHChemical();
        });
    });
    $('#btnMaxDHCPHChemical').on('click', function () {
        PHA_UX.MaxCode(
            {
                tblName: 'DHC_PHChemical',
                codeName: 'PHCM_Code',
                title: $g('��ѯƷ��ͨ���������')
            },
            function (code) {
                $('#chemCode').val(code);
            }
        );
    });
    MakeToolTip();
}
function QueryDHCPHCHEMICAL(){
    $('#gridDHCPHChemical').datagrid('query', {
        InputStr: $('#conChemAlias').val(),
        page: 1
    });
  
    $('#conChemAlias').val('').focus();
    DHCPHCHEMICAL_RowId = '';
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
                title: $g('����'),
                width: 200,
                hidden: true
            },
            {
                field: 'chemCode',
                title: $g('����'),
                width: 300
            },
            {
                field: 'chemDesc',
                title: $g('����'),
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
                        PHA.Alert($g('������ʾ'), arrData.msg, 'error');
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
function ClearDHCPHChemical() {
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
        PHA.Alert($g('��ʾ'), saveInfo, 'warning');
        return;
    } else {
        PHA.Popover({
            msg: $g('���³ɹ�'),
            type: 'success'
        });
        DHCPHCHEMICAL_RowId = '';
        $('#gridDHCPHChemical').datagrid('reload');
        PHA.DomData('#dataDHCPHChemical', {
            doType: 'clear'
        });
    }
}

/**
 * @description ����
 */
function AddDHCPHChemical() {
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
            ChemId: '',
            DataStr: valsStr,
            dataType: 'text'
        },
        false
    );
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Alert($g('��ʾ'), saveInfo, 'warning');
        return;
    } else {
        PHA.Popover({
            msg: $g('����ɹ�'),
            type: 'success'
        });
        //DHCPHCHEMICAL_RowId = saveVal;
        DHCPHCHEMICAL_RowId = '';
        $('#gridDHCPHChemical').datagrid('reload');
        PHA.DomData('#dataDHCPHChemical', {
            doType: 'clear'
        });
    }
}

/**
 * @description ɾ��
 */
function DelDHCPHChemical() {
    var gridSelect = $('#gridDHCPHChemical').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: $g('����ѡ����Ҫɾ����Ʒ��ͨ����'),
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
        PHA.Alert($g('��ʾ'), saveInfo, 'warning');
        return;
    } else {
        PHA.Popover({
            msg: $g('ɾ���ɹ�'),
            type: 'success'
        });
        DHCPHCHEMICAL_RowId = '';
        $('#gridDHCPHChemical').datagrid('reload');
        PHA.DomData('#dataDHCPHChemical', {
            doType: 'clear'
        });
    }
}
