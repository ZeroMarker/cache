// ��ʼ������ͨ����ҳǩ����
var PHCGENERIC_RowId = '';
var PHCGENERIC_Style = {
    ComboWidth: 537
};

function PHCGENERIC() {
    $.parser.parse('#lyPHCGeneric');
    InitDictPHCGeneric();
    InitGridPHCGeneric();
    $('#btnCleanGene').on('click', ClrPHCGeneric);
    $('#btnFindGene').on('click', QueryPHCGeneric);
    $('#conGeneAlias').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            QueryPHCGeneric();
            $('#conGeneAlias').focus().select();
        }
    });
    $('#btnSavePHCGeneric').on('click', function () {
        PHA.Confirm($g('��ʾ'), $g('��ȷ�ϸ�����?'), function () {
            SavePHCGeneric();
        });
    });
    $('#btnClearPHCGeneric').on('click', function () {
        PHA.Confirm($g('��ʾ'), $g('��ȷ��������?'), function () {
            ClearPHCGeneric();
        });
    });
    $('#btnAddPHCGeneric').on('click', function () {
        PHA.Confirm($g('��ʾ'), $g('��ȷ��������?'), function () {
            AddPHCGeneric();
        });
    });
    $('#btnDelPHCGeneric').on('click', DelPHCGeneric);
    $('#btnAddPHCGenericARCItmMast').on('click', AddPHCGenericARCItmMast);
    $('#btnMaxPHCGeneric').on('click', function () {
        PHA_UX.MaxCode(
            {
                tblName: 'PHC_Generic',
                codeName: 'PHCGE_Code',
                title: $g('��ѯ����ͨ���������')
            },
            function (code) {
                $('#geneCode').val(code);
            }
        );
    });
    MakeToolTip();
}

/**
 * @description ����
 */
function ClearPHCGeneric() {
    $('#gridPHCGeneric').datagrid('clearSelections');
    PHA.DomData('#dataPHCGeneric', {
        doType: 'clear'
    });
    $('#geneCode').focus();
    PHCGENERIC_RowId = '';
}

/**
 * @description ����
 */
function SavePHCGeneric() {
    var valsArr = PHA.DomData('#dataPHCGeneric', {
        doType: 'save'
    });
    var valsStr = valsArr.join('^');
    if (valsStr == '') {
        return;
    }
    var saveRet = $.cm(
        {
            ClassName: 'PHA.IN.PHCGeneric.Save',
            MethodName: 'Save',
            GeneId: PHCGENERIC_RowId,
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
        PHCGENERIC_RowId = '';
        $('#gridPHCGeneric').datagrid('reload');
        PHA.DomData('#dataPHCGeneric', {
            doType: 'clear'
        });
    }
}

/**
 * @description ����
 */
function AddPHCGeneric() {
    var valsArr = PHA.DomData('#dataPHCGeneric', {
        doType: 'save'
    });
    var valsStr = valsArr.join('^');
    if (valsStr == '') {
        return;
    }
    var saveRet = $.cm(
        {
            ClassName: 'PHA.IN.PHCGeneric.Save',
            MethodName: 'Save',
            GeneId: '',
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
            msg: $g('�����ɹ�'),
            type: 'success'
        });
        //PHCGENERIC_RowId = saveVal;
        PHCGENERIC_RowId = '';
        $('#gridPHCGeneric').datagrid('reload');
        PHA.DomData('#dataPHCGeneric', {
            doType: 'clear'
        });
    }
}

function DelPHCGeneric() {
    var gridSelect = $('#gridPHCGeneric').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: $g('����ѡ����Ҫɾ���Ĵ���ͨ����'),
            type: 'alert'
        });
        return;
    }
    PHA.Confirm($g('ɾ����ʾ'), $g('��ȷ��ɾ����?'), function () {
        var geneId = gridSelect.geneId;
        var saveRet = $.cm(
            {
                ClassName: 'PHA.IN.PHCGeneric.Save',
                MethodName: 'Delete',
                GeneId: geneId,
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
            PHCGENERIC_RowId = '';
            $('#gridPHCGeneric').datagrid('reload');
            PHA.DomData('#dataPHCGeneric', {
                doType: 'clear'
            });
        }
    });
}

function ClrPHCGeneric() {
    PHA.DomData('#gridPHCGenericBar', {
        doType: 'clear'
    });
}

function QueryPHCGeneric() {
    var valsArr = PHA.DomData('#gridPHCGenericBar', {
        doType: 'query'
    });
    var valsStr = valsArr.join('^');
    $('#gridPHCGeneric').datagrid('query', {
        InputStr: valsStr
    });
    PHCGENERIC_RowId = '';
}

function InitDictPHCGeneric() {
    PHA.ComboBox('geneForm', {
        url: PHA_STORE.PHCForm().url,
        width: PHCGENERIC_Style.ComboWidth
    });
    // Ʒ��ͨ����
    var opts = $.extend({}, PHA_STORE.DHCPHChemical(), {
        width: PHCGENERIC_Style.ComboWidth
    });
    PHA.LookUp('geneChem', opts);
    var opts = $.extend({}, PHA_STORE.DHCPHChemical(), {
        width: 200
    });
    PHA.LookUp('conGeneChem', opts);
    PHA.TriggerBox('conGenePHCCat', {
        handler: function (data) {
            PHA_UX.DHCPHCCat('conGenePHCCat', {}, function (data) {
                $('#conGenePHCCat').triggerbox('setValue', data.phcCatDescAll);
                $('#conGenePHCCat').triggerbox('setValueId', data.phcCatId);
            });
        },
        width: 391
    });
    PHA.TriggerBox('genePHCCat', {
        width: PHCGENERIC_Style.ComboWidth,
        handler: function (data) {
            PHA_UX.DHCPHCCat('genePHCCat', {}, function (data) {
                $('#genePHCCat').triggerbox('setValue', data.phcCatDescAll);
                $('#genePHCCat').triggerbox('setValueId', data.phcCatId);
            });
        }
    });
}

// ���-����ͨ����
function InitGridPHCGeneric() {
    var lastColWidth = $('#gridPHCGeneric').parent().width() - 630;
    var columns = [
        [
            {
                field: 'geneId',
                title: 'Id',
                width: 100,
                hidden: true
            },
            {
                field: 'geneCode',
                title: $g('����'),
                width: 100
            },
            {
                field: 'geneName',
                title: $g('����'),
                width: 200
            },
            {
                field: 'formDesc',
                title: $g('����'),
                width: 100
            },
            {
                field: 'chemDesc',
                title: $g('Ʒ��ͨ����'),
                width: 200
            },
            {
                field: 'phcCatDescAll',
                title: $g('ҩѧ����'),
                width: lastColWidth > 300 ? lastColWidth : 300
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.PHCGeneric.Query',
            QueryName: 'PHCGeneric'
        },
        pagination: true,
        columns: columns,
        fitColumns: false,
        toolbar: '#gridPHCGenericBar',
        enableDnd: false,
        onSelect: function (rowIndex, rowData) {
            $.cm(
                {
                    ClassName: 'PHA.IN.PHCGeneric.Query',
                    MethodName: 'SelectPHCGeneric',
                    GeneId: rowData.geneId,
                    ResultSetType: 'Array'
                },
                function (arrData) {
                    if (arrData.msg) {
                        PHA.Alert($g('������ʾ'), arrData.msg, 'error');
                    } else {
                        PHA.DomData('#dataPHCGeneric', {
                            doType: 'clear'
                        });
                        PHA.SetVals(arrData);
                        PHCGENERIC_RowId = rowData.geneId;
                    }
                }
            );
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (FORONE === '') {
                SwitchToARCItmMast(rowData.geneId, '');
            }
        },
        onLoadSuccess: function (data) {
            PHA.DomData('#dataPHCGeneric', {
                doType: 'clear'
            });
            var pageSize = $('#gridPHCGeneric').datagrid('getPager').data('pagination').options.pageSize;
            var total = data.total;
            if (total > 0 && total <= pageSize) {
                $('#gridPHCGeneric').datagrid('selectRow', 0);
            }
        }
    };

    PHA.Grid('gridPHCGeneric', dataGridOption);
}

function AddPHCGenericARCItmMast() {
    if (PHCGENERIC_RowId == '') {
        PHA.Popover({
            msg: $g('����ѡ�񴦷�ͨ����,��������������ȱ���'),
            type: 'alert'
        });
        return;
    }
    SwitchToARCItmMast(PHCGENERIC_RowId, 'AddArcim');
}

function SwitchToARCItmMast(geneId, type) {
    // �ж�ҽ�����Ƿ��ʼ����,����״�����ҽ���ѡ�е�����
    var arcimLoaded = $('#lyArcItmMast').text().trim();
    $('#tabsDrug').tabs('select', $('#tabsDrug').tabs('getTabIndex', $('#tabsDrug').tabs('getTabByOpt', { key: 'id', val: 'tabArcim' })));
    $.cm(
        {
            ClassName: 'PHA.IN.Drug.Switch',
            MethodName: 'PHCGenericToARCItmMast',
            GeneId: geneId,
            Type: type,
            ResultSetType: 'Array'
        },
        function (arrData) {
            if (arrData.msg) {
                PHA.Alert($g('������ʾ'), arrData.msg, 'error');
            } else {
                if (arcimLoaded != '') {
                    SwitchLoad();
                } else {
                    setTimeout(SwitchLoad, 500);
                }
                function SwitchLoad() {
                    ClrARCItmMast();
                    PHA.SetVals(arrData);
                    DRUG_SwitchType = type;
                    QueryARCItmMast();
                    PHA.SetVals(arrData);
                }
            }
        }
    );
}
