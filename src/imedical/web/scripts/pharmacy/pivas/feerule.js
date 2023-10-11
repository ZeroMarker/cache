/**
 * 模块:     配液收费规则
 * 编写日期: 2020-01-09
 * 编写人:   yunhaibao
 */
var HospId = session['LOGON.HOSPID'];
var GridCmgArc;
$(function() {
    InitHospCombo();
    InitDict();
    InitGridDict();
    InitGridFeeRule();
    InitGridFeeRuleItm();
    InitGridFeeRuleLink();
    // 规则
    $('#btnAdd').on('click', AddRule);
    $('#btnSave').on('click', SaveRule);
    $('#btnDelete').on('click', DeleteRule);
    // 关联关系
    $('#btnAddItm,#btnEditItm').on('click', function() {
        ShowDiagRuleItm(this);
    });
    $('#btnDeleteItm').on('click', DeleteRuleItm);
    // 关联收费
    $('#btnAddLink').on('click', AddRuleLink);
    $('#btnSaveLink').on('click', SaveRuleLink);
    $('#btnDeleteLink').on('click', DeleteRuleLink);
    $('.dhcpha-win-mask').remove();
});
function InitDict() {
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbType',
            data: {
                data: [
                    {
                        RowId: 'ARCIM',
                        Description: '药品'
                    },
                    {
                        RowId: 'MLSPECMIN',
                        Description: '规格[ML]下限'
                    },
                    {
                        RowId: 'MLSPECMAX',
                        Description: '规格[ML]上限'
                    },
                    {
                        RowId: 'MLLIQUIDMIN',
                        Description: '液体总量下限'
                    },
                    {
                        RowId: 'MLLIQUIDMAX',
                        Description: '液体总量上限'
                    }
                ]
            }
        },
        {
            width: 310,
            onSelect: function(selData) {
                LoadRuleItmStore(selData.RowId);
            },
            editable: false,
            panelHeight: 'auto'
        }
    );
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbOperate',
            data: {
                data: []
            }
        },
        {
            width: 310,
            editable: false,
            panelHeight: 'auto',
            onLoadSuccess: function(data) {
                if (data.length == 1) {
                    $(this).combobox('setValue', data[0].RowId);
                }
            }
        }
    );
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbTypeVal',
            data: {
                data: []
            }
        },
        {
            width: 310,
            mode: 'remote',
            onBeforeLoad: function(params) {
                params.filterText = params.q;
				params.HospId = HospId;
            }
        }
    );
}
function InitGridDict() {
    GridCmgArc = PIVAS.GridComboGrid.Init(
        {
            Type: 'ArcItmMast'
        },
        {
            required: true,
            idField: 'arcItmId',
            textField: 'arcItmDesc',
            onBeforeLoad: function(param) {
				param.filterText=param.q||'';
                param.HospId = HospId;
            }
        }
    );
}
function InitGridFeeRule() {
    var columns = [
        [
            {
                field: 'ruleID',
                title: 'ruleID',
                width: 50,
                hidden: true
            },
            {
                field: 'ruleDesc',
                title: '名称',
                width: 200,
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
            ClassName: 'web.DHCSTPIVAS.FeeRule',
            QueryName: 'PHAPIVASFeeRule',
            rows: 999
        },
        columns: columns,
        toolbar: '#gridFeeRuleBar',
        pagination: false,
        fitColumns: true,
        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid('endEditing');
            if ($(this).datagrid('options').editIndex == undefined) {
                QueryRuleItm();
                QueryRuleLink();
            }
        },
        onDblClickRow: function(rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'ruleDesc'
            });
        },
        onLoadSuccess: function() {
            $('#gridFeeRuleItm').datagrid('clear');
            $('#gridFeeRuleLink').datagrid('clear');
        },
        onBeforeLoad: function(param) {
            param.HospId = HospId;
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridFeeRule', dataGridOption);
}
function InitGridFeeRuleItm() {
    var columns = [
        [
            {
                field: 'ruleItmID',
                title: 'ruleItmID',
                width: 50,
                hidden: true
            },
            {
                field: 'typeDesc',
                title: '类型',
                width: 200,
                align: 'left'
            },
            {
                field: 'operateDesc',
                title: '关系',
                width: 120,
                align: 'left'
            },
            {
                field: 'typeValDesc',
                title: '类型值',
                width: 600,
                align: 'left'
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.FeeRule',
            QueryName: 'PHAPIVASFeeRuleItm',
            rows: 999
        },
        columns: columns,
        toolbar: '#gridFeeRuleItmBar',
        pagination: false,
        fitColumns: true,
        onClickRow: function(rowIndex, rowData) {
            LoadRuleItmStore(rowData.type);
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridFeeRuleItm', dataGridOption);
}
function InitGridFeeRuleLink() {
    var columns = [
        [
            {
                field: 'ruleLinkID',
                title: 'ruleLinkID',
                width: 50,
                hidden: true
            },
            {
                field: 'qty',
                title: '数量',
                width: 100,
                align: 'center',
                editor: {
                    type: 'numberbox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'arcim',
                title: '医嘱项',
                width: 900,
                align: 'left',
                editor: GridCmgArc,
                descField: 'arcimDesc',
                formatter: function(value, row, index) {
                    return row.arcimDesc;
                }
            },
            {
                field: 'arcimDesc',
                title: '医嘱项描述',
                width: 100,
                align: 'left',
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.FeeRule',
            QueryName: 'PHAPIVASFeeRuleLink',
            rows: 999
        },
        columns: columns,
        toolbar: '#gridFeeRuleLinkBar',
        pagination: false,
        fitColumns: true,
        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid('endEditing');
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridFeeRuleLink', dataGridOption);
}

function AddRule() {
    $('#gridFeeRule').datagrid('addNewRow', {
        editField: 'ruleDesc'
    });
    $('#gridFeeRuleItm').datagrid('clear');
    $('#gridFeeRuleLink').datagrid('clear');
}
function SaveRule() {
    $('#gridFeeRule').datagrid('endEditing');
    var gridChanges = $('#gridFeeRule').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('没有需要保存的数据'),
            type: 'alert'
        });
        return;
    }
    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params = (iData.ruleID || '') + '^' + (iData.ruleDesc || '');
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }

    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.FeeRule', 'SaveRuleMulti', paramsStr, HospId);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert($g('提示'), saveInfo, 'warning');
    }
    $('#gridFeeRule').datagrid('reload');
}
function DeleteRule() {
    var gridSelect = $('#gridFeeRule').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('请选择需要删除的记录'),
            type: 'alert'
        });
        return;
    }
    $.messager.confirm($g('确认对话框'), $g('您确定删除吗？'), function(r) {
        if (r) {
            var ruleID = gridSelect.ruleID || '';
            if (ruleID == '') {
                var rowIndex = $('#gridFeeRule').datagrid('getRowIndex', gridSelect);
                $('#gridFeeRule').datagrid('deleteRow', rowIndex);
            } else {
                var delRet = tkMakeServerCall(
                    'web.DHCSTPIVAS.FeeRule',
                    'DeleteRule',
                    ruleID,
                    HospId
                );
                $('#gridFeeRule').datagrid('reload');
            }
        }
    });
}
function QueryRuleItm() {
    var gridSelect = $('#gridFeeRule').datagrid('getSelected');
    $('#gridFeeRuleItm').datagrid('query', {
        RuleID: gridSelect.ruleID || ''
    });
}
function QueryRuleLink() {
    var gridSelect = $('#gridFeeRule').datagrid('getSelected');
    $('#gridFeeRuleLink').datagrid('query', {
        RuleID: gridSelect.ruleID || ''
    });
}

function GetSelectRuleID() {
    var gridSelect = $('#gridFeeRule').datagrid('getSelected') || '';
    if (gridSelect == '') {
        return '';
    }
    return gridSelect.ruleID || '';
}

function AddRuleLink() {
    var ruleID = GetSelectRuleID();
    if (ruleID == '') {
        return;
    }
    $('#gridFeeRuleLink').datagrid('addNewRow', {
        editField: 'qty'
    });
}
function SaveRuleLink() {
    var ruleID = GetSelectRuleID();
    if (ruleID == '') {
        return;
    }
    $('#gridFeeRuleLink').datagrid('endEditing');
    var gridChanges = $('#gridFeeRuleLink').datagrid('getChanges');
    var gridRows = $('#gridFeeRuleLink').datagrid('getRows');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('没有需要保存的数据'),
            type: 'alert'
        });
        return;
    }
    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        if (gridRows.indexOf(iData) < 0) {
            continue;
        }
        var params = '' + '^' + ruleID + '^' + (iData.arcim || '') + '^' + (iData.qty || '');
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    if (paramsStr == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('没有需要保存的数据'),
            type: 'alert'
        });
        return;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.FeeRule', 'SaveRuleLinkMulti', paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'warning');
    }
    $('#gridFeeRuleLink').datagrid('reload');
}

function DeleteRuleLink() {
    var gridSelect = $('#gridFeeRuleLink').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('请选择需要删除的记录'),
            type: 'alert'
        });
        return;
    }
    $.messager.confirm($g('确认对话框'), $g('您确定删除吗？'), function(r) {
        if (r) {
            var ruleLinkID = gridSelect.ruleLinkID || '';
            if (ruleLinkID == '') {
                var rowIndex = $('#gridFeeRuleLink').datagrid('getRowIndex', gridSelect);
                $('#gridFeeRuleLink').datagrid('deleteRow', rowIndex);
            } else {
                var delRet = tkMakeServerCall(
                    'web.DHCSTPIVAS.FeeRule',
                    'DeleteRuleLink',
                    ruleLinkID
                );
                $('#gridFeeRuleLink').datagrid('reload');
            }
        }
    });
}
function DeleteRuleItm() {
    var gridSelect = $('#gridFeeRuleItm').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('请选择需要删除的记录'),
            type: 'alert'
        });
        return;
    }
    $.messager.confirm($g('确认对话框'), $g('您确定删除吗？'), function(r) {
        if (r) {
            var ruleItmID = gridSelect.ruleItmID || '';
            if (ruleItmID == '') {
                var rowIndex = $('#gridFeeRuleItm').datagrid('getRowIndex', gridSelect);
                $('#gridFeeRuleItm').datagrid('deleteRow', rowIndex);
            } else {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.FeeRule', 'DeleteRuleItm', ruleItmID);
                $('#gridFeeRuleItm').datagrid('reload');
            }
        }
    });
}

function ShowDiagRuleItm(btnOpt) {
    var ifAdd = btnOpt.id.indexOf('Add') >= 0 ? true : false;
    var ruleID = GetSelectRuleID();
    if (ruleID == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('请先选择左侧规则名称'),
            type: 'alert'
        });
        return;
    }

    var ruleItmID = '';
    if (ifAdd == false) {
        var gridSelect = $('#gridFeeRuleItm').datagrid('getSelected') || '';
        if (gridSelect == '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('请先选中需要修改的关联关系'),
                type: 'alert'
            });
            return;
        }
        ruleItmID = gridSelect.ruleItmID;
        LoadRuleItmOperate(gridSelect.type);
    } else {
    }
    $('#gridFeeRuleItmWin')
        .dialog({
            title: $g('关联关系') + btnOpt.text,
            iconCls: ifAdd ? 'icon-w-add' : 'icon-w-edit',
            modal: true,
            width: 390,
            height: 210
        })
        .dialog('open');
    $('#divCMBTypeVal,#divTXTTypeVal').hide();
    if (ifAdd == false) {
        var jsonData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.FeeRule',
                MethodName: 'SelectPHAPIVASFeeRuleItm',
                RuleItmID: ruleItmID
            },
            false
        );

        $('#cmbType').combobox('setValue', jsonData.type);
        $('#cmbOperate').combobox('setValue', jsonData.operate);
        var typeVal = jsonData.typeVal;
        if (typeVal != '') {
            $('#cmbTypeVal')
                .combobox('loadData', [typeVal])
                .combobox('setValue', typeVal.RowId);
            $('#divCMBTypeVal').show();
        } else {
            $('#cmbTypeVal').combobox('setValue', '');
            $('#divTXTTypeVal').show();
        }
        $('#txtTypeVal').val(jsonData.typeValText);
    } else {
        $('#cmbType').combobox('setValue', '');
        $('#cmbOperate').combobox('clear');
        $('#cmbTypeVal').combobox('clear');
        $('#txtTypeVal').val('');
        $('#divTXTTypeVal').show();
    }
}

function SaveRuleItm() {
    var title = $('#gridFeeRuleItmWin').panel('options').title;
    var ifAdd = title.indexOf($g('新增')) >= 0 ? true : false;
    var ruleID = GetSelectRuleID();
    if (ruleID == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('请先选择左侧规则名称'),
            type: 'alert'
        });
        return;
    }

    var ruleItmID = '';
    if (ifAdd == false) {
        var gridSelect = $('#gridFeeRuleItm').datagrid('getSelected') || '';
        ruleItmID = gridSelect.ruleItmID;
    }
    var chkMsg = '';
    var type = $('#cmbType').combobox('getValue') || '';
    var operate = $('#cmbOperate').combobox('getValue') || '';
    var typeVal = '';
    if (type == 'ARCIM') {
        typeVal = $('#cmbTypeVal').combobox('getValue') || '';
    } else {
        typeVal = $('#txtTypeVal').val();
    }
    if (type == '') {
        chkMsg = '类型为空';
    }
    if (operate == '') {
        chkMsg = '关系为空';
    }
    if (typeVal == '') {
        chkMsg = '类型值为空';
    }
    if (chkMsg != '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g(chkMsg),
            type: 'alert'
        });
        return;
    }
    var inputData = ruleItmID + '^' + ruleID + '^' + type + '^' + operate + '^' + typeVal;
    var saveRet = $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.FeeRule',
            MethodName: 'SaveRuleItm',
            inputStr: inputData,
            dataType: 'text'
        },
        false
    );
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert($g('提示'), saveInfo, 'warning');
        return;
    }
    $('#gridFeeRuleItmWin').window('close');
    $('#gridFeeRuleItm').datagrid('reload');
}
// 选中行时重新load窗体内store
function LoadRuleItmStore(type) {
    var operateData = [];
    $('#cmbOperate').combobox('clear');
    $('#cmbTypeVal').combobox('clear');
    $('#divTXTTypeVal').hide();
    $('#divCMBTypeVal').hide();
    LoadRuleItmOperate(type);
    if (type == 'ARCIM') {
        $('#divCMBTypeVal').show();
        $('#cmbTypeVal').combobox('options').url =
            'DHCST.QUERY.BROKER.csp?DataType=Array&ClassName=web.DHCSTPIVAS.Dictionary&QueryName=ArcItmMastStore';
        $('#cmbTypeVal').combobox('reload');
    } else if (type == 'MLSPECMIN' || type == 'MLSPECMAX') {
        $('#divTXTTypeVal').show();
    } else if (type == 'MLLIQUIDMIN' || type == 'MLLIQUIDMAX') {
        $('#divTXTTypeVal').show();
    }
}
function LoadRuleItmOperate(type) {
    var operateData = [];
    $('#cmbOperate').combobox('clear');
    if (type == 'ARCIM') {
        operateData = [
            { RowId: '[', Description: '包含' },
            { RowId: ']', Description: '不包含' }
        ];
    } else if (type == 'MLSPECMIN' || type == 'MLLIQUIDMIN') {
        operateData = [{ RowId: '>=', Description: '大于等于' }];
    } else if (type == 'MLSPECMAX' || type == 'MLLIQUIDMAX') {
        operateData = [{ RowId: '<', Description: '小于' }];
    }
    $('#cmbOperate').combobox('loadData', operateData);

}
function InitHospCombo() {
	var genHospObj=PIVAS.AddHospCom({tableName:'PHAPIVAS_FeeRule'},{width:265});
	if (typeof genHospObj ==='object'){
		genHospObj.options().onSelect =  function(index, record) {
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                $('#gridFeeRule').datagrid('load');
            }
        };
    }
    var defHosp = $.cm(
		{
		    dataType: 'text',
		    ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
		    MethodName: 'GetDefHospIdByTableName',
		    tableName: 'PHAPIVAS_FeeRule',
		    HospID: HospId
		},
		false
	);
	HospId = defHosp;
}
