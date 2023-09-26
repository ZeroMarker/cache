/**
 * @description 药品维护-品种通用名
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
        placeholder: '请输入简拼或名称回车查询'
    });
    $('#btnSaveDHCPHChemical').on('click', function () {
        PHA.Confirm('提示', '您确认保存吗?', function () {
            SaveDHCPHChemical();
        });
    });
    $('#btnAddDHCPHChemical').on('click', function () {
        PHA.Confirm('提示', '您确认清屏吗?', function () {
            AddDHCPHChemical();
        });
    });
    $('#btnDelDHCPHChemical').on('click', function () {
        PHA.Confirm('提示', '您确认删除吗?', function () {
            DelDHCPHChemical();
        });
    });
    $('#btnMaxDHCPHChemical').on('click', function () {
        PHA_UX.MaxCode(
            {
                tblName: 'DHC_PHChemical',
                codeName: 'PHCM_Code',
                title: '查询品种通用名最大码'
            },
            function (code) {
                $('#chemCode').val(code);
            }
        );
    });
    MakeToolTip();
}

/**
 * @description 初始化品种通用名表格
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
                title: '类组',
                width: 200,
                hidden: true
            },
            {
                field: 'chemCode',
                title: '代码',
                width: 300
            },
            {
                field: 'chemDesc',
                title: '名称',
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
                        PHA.Alert('错误提示', arrData.msg, 'error');
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
 * @description 新增
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
 * @description 保存
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
        PHA.Alert('提示', saveInfo, 'warning');
        return;
    } else {
        PHA.Popover({
            msg: '保存成功',
            type: 'success'
        });
        DHCPHCHEMICAL_RowId = saveVal;
    }
}

/**
 * @description 删除
 */
function DelDHCPHChemical() {
    var gridSelect = $('#gridDHCPHChemical').datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '请先选中需要删除的品种通用名',
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
        PHA.Alert('提示', saveInfo, 'warning');
        return;
    } else {
        PHA.Popover({
            msg: '删除成功',
            type: 'success'
        });
        DHCPHCHEMICAL_RowId = '';
        $('#gridDHCPHChemical').datagrid('reload');
        PHA.DomData('#dataDHCPHChemical', {
            doType: 'clear'
        });
    }
}
