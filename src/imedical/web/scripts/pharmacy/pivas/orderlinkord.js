/**
 * 模块:	配液大类关联收费项
 * 编写日期:2018-03-13
 * 编写人:  yunhaibao
 */
var HospId = session['LOGON.HOSPID'];
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var ConfirmMsgInfoArr = [];
var GridCmgArc;
var GridCmbLinkOrdPack;
var GridCmbSeqFlag;
$(function () {
    InitHospCombo();
    InitGridDict();
    InitGridOrderLink();
    InitGridOrdLinkOrd();
    InitGridFeeRule();
    //收费设置
    $('#btnAddPolo').on('click', AddNewRow);
    $('#btnSavePolo').on('click', SaveOrdLinkOrd);
    $('#btnDelPolo').on('click', DeletelPolo);
    // 关联收费规则
    $('#btnAddFeeRule,#btnDeleteFeeRule').on('click', function () {
        var saveType = this.id === 'btnAddFeeRule' ? 'ADD' : 'DELETE';
        SaveFeeRule(saveType);
    });

    $('#tabsOrdLink').tabs({
        onSelect: function (title, index) {
            if (index === 1) {
                $('#lyFeeRule').layout();
                ResizePanel();
            }
        }
    });

    setTimeout(function () {
        ResizePanel();
        $('.dhcpha-win-mask').remove();
    }, 100);
});

function InitGridDict() {
    GridCmgArc = PIVAS.GridComboGrid.Init(
        {
            Type: 'ArcItmMast'
        },
        {
            required: true,
            idField: 'arcItmId',
            textField: 'arcItmDesc',
            onBeforeLoad: function (param) {
                param.HospId = HospId;
                param.filterText = param.q;
            }
        }
    );
    GridCmbLinkOrdPack = PIVAS.GridComboBox.Init(
        {
            Type: 'LinkOrdPack'
        },
        {
            panelHeight: 'auto',
            editable: false
            //required: true
        }
    );
    GridCmbSeqFlag = PIVAS.GridComboBox.Init(
        {
            data: {
                data: [
                    {
                        RowId: 'A',
                        Description: $g('全部')
                    },
                    {
                        RowId: 'Y',
                        Description: $g('关联医嘱')
                    },
                    {
                        RowId: 'N',
                        Description: $g('非关联医嘱')
                    }
                ]
            }
        },
        {
            panelHeight: 'auto',
            editable: false
            //required: true
        }
    );
}

/// 初始化配液大类表格
function InitGridOrderLink() {
    var columns = [
        [
            {
                field: 'polId',
                title: 'polId',
                hidden: true,
                align: 'center'
            },
            {
                field: 'polDesc',
                title: '配液大类',
                width: 100
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.OrderLink',
            QueryName: 'QueryOrderLink',
            pNeedTrans: 'Y'
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        toolbar: '#gridOrdLinkBar',
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                QueryGridOrdLinkOrd();
                QueryGridFeeRule();
            }
        },
        onLoadSuccess: function () {
            $('#gridOrdLinkOrd').datagrid('clear');
            $('#gridFeeRule').datagrid('clear');
        },
        onBeforeLoad: function (param) {
            param.HospId = HospId;
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridOrderLink', dataGridOption);
    $('#gridOrderLink class[name=datagrid-header]').css('display', 'none');
}

/// 初始化医嘱项表格
function InitGridOrdLinkOrd() {
    var columns = [
        [
            {
                field: 'poloId',
                title: 'poloId',
                hidden: true
            },
            {
                field: 'arcItmDesc',
                title: '医嘱项描述',
                hidden: true
            },
            {
                field: 'arcItmCode',
                title: '医嘱项代码',
                width: 100
            },
            {
                field: 'arcItmId',
                title: '医嘱项名称',
                width: 200,
                editor: GridCmgArc,
                descField: 'arcItmDesc',
                formatter: function (value, row, index) {
                    return row.arcItmDesc;
                }
            },
            {
                field: 'arcItmQty',
                title: '数量',
                width: 50,
                align: 'center',
                editor: {
                    type: 'numberbox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'linkOrdPackDesc',
                title: '类型描述',
                width: 200,
                hidden: true
            },
            {
                field: 'linkOrdPack',
                title: '类型',
                width: 75,
                align: 'center',
                editor: GridCmbLinkOrdPack,
                descField: 'linkOrdPackDesc',
                formatter: function (value, row, index) {
                    return row.linkOrdPackDesc;
                }
            },
            {
                field: 'linkOrdSeqDesc',
                title: '关联医嘱描述',
                width: 200,
                hidden: true
            },
            {
                field: 'linkOrdSeq',
                title: '关联医嘱',
                width: 75,
                align: 'center',
                editor: GridCmbSeqFlag,
                descField: 'linkOrdSeqDesc',
                formatter: function (value, row, index) {
                    return row.linkOrdSeqDesc;
                }
            },
            {
                field: 'batNo',
                title: '批次',
                width: 50,
                halign: 'center',
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.OrderLink',
            QueryName: 'QueryOrdLinkOrd'
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        nowrap: false,
        toolbar: '#gridOrdLinkOrdBar',
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
        },
        onLoadSuccess: function () {}
    };
    DHCPHA_HUI_COM.Grid.Init('gridOrdLinkOrd', dataGridOption);
}

/// 增加一行
function AddNewRow() {
    var polId = GetSelectPolId();
    if (polId == '') {
        return;
    }
    $('#gridOrdLinkOrd').datagrid('addNewRow', {
        editField: 'arcItmId'
    });
}

/// 保存医嘱项
function SaveOrdLinkOrd() {
    var polId = GetSelectPolId();
    if (polId == '') {
        return;
    }
    $('#gridOrdLinkOrd').datagrid('endEditing');
    var gridChanges = $('#gridOrdLinkOrd').datagrid('getChanges');
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
        var params = polId + '^' + (iData.arcItmId || '') + '^' + (iData.arcItmQty || '') + '^' + (iData.linkOrdPack || '') + '^' + (iData.linkOrdSeq || '');
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.OrderLink', 'SaveOrdLinkOrdMulti', paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'warning');
    }
    $('#gridOrdLinkOrd').datagrid('query', {});
}

/// 获取医嘱项列表
function QueryGridOrdLinkOrd() {
    var gridPOLSelect = $('#gridOrderLink').datagrid('getSelected');
    var polId = gridPOLSelect.polId || '';
    $('#gridOrdLinkOrd').datagrid('query', {
        inputStr: polId
    });
}

function QueryGridFeeRule() {
    var gridPOLSelect = $('#gridOrderLink').datagrid('getSelected');
    polId = gridPOLSelect.polId || '';
    $('#gridFeeRule').datagrid('query', {
        POLIID: polId,
        HospId: HospId,
        LinkFlag: 1
    });
    $('#gridFeeRuleDict').datagrid('query', {
        POLIID: polId,
        HospId: HospId,
        LinkFlag: 0
    });
}
/// 删除医嘱项
function DeletelPolo() {
    var gridSelect = $('#gridOrdLinkOrd').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要删除的记录',
            type: 'alert'
        });

        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var poloId = gridSelect.poloId || '';
            if (poloId == '') {
                var rowIndex = $('#gridOrdLinkOrd').datagrid('getRowIndex', gridSelect);
                $('#gridOrdLinkOrd').datagrid('deleteRow', rowIndex);
            } else {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.OrderLink', 'DeletePIVAOrderLinkOrder', poloId);
                $('#gridOrdLinkOrd').datagrid('query', {});
            }
        }
    });
}

function GetSelectPolId() {
    var gridSelect = $('#gridOrderLink').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选中需要增加规则的配液大类记录',
            type: 'alert'
        });
        return '';
    }
    var polId = gridSelect.polId || '';
    if (polId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选中需要增加规则的配液大类记录',
            type: 'alert'
        });
        return '';
    }
    return polId;
}

/// 初始化收费规则表格
function InitGridFeeRule() {
    var columns = [
        [
            {
                field: 'ruleID',
                title: 'ruleID',
                hidden: true,
                align: 'center'
            },
            {
                field: 'ruleChk',
                checkbox: true
            },
            {
                field: 'ruleDesc',
                title: '收费规则',
                width: 150
            },
            {
                field: 'ruleItmData',
                title: '关联关系',
                width: 200,
                hidden: true
            },
            {
                field: 'ruleLinkData',
                title: '收费医嘱项',

                hidden: false
            },
            {
                field: 'linked',
                title: '已关联',
                width: 200,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.OrderLink',
            QueryName: 'OrderLinkFeeRule'
        },
        pagination: false,
        fitColumns: false,
        fit: true,
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        toolbar: [],
        nowrap: false,
        onLoadSuccess: function (data) {
            $(this).datagrid('uncheckAll');
        },
        onBeforeLoad: function (param) {
            param.HospId = HospId;
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridFeeRule', dataGridOption);
    DHCPHA_HUI_COM.Grid.Init('gridFeeRuleDict', dataGridOption);
}
function SaveFeeRule(saveType) {
    var ruleChked = $('#gridFeeRule').datagrid('getChecked') || '';
    var dictChked = $('#gridFeeRuleDict').datagrid('getChecked') || '';

    var rows = $('#gridFeeRule').datagrid('getRows');
    if (saveType === 'DELETE') {
        if (ruleChked.length === 0) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: '请选择需要删除的已关联的数据',
                type: 'alert'
            });
            return;
        }
    } else if ((saveType = 'ADD')) {
        if (dictChked.length === 0) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: '请选择需要增加的未关联的数据',
                type: 'alert'
            });
            return;
        }
    }
    $.messager.confirm('温馨提示', '您确认' + (saveType === 'ADD' ? '增加' : '删除') + '吗?', function (r) {
        if (r) {
            var ruleIDArr = [];
            var ruleID = '';
            for (var i = 0, length = rows.length; i < length; i++) {
                ruleIDArr.push(rows[i].ruleID);
            }
            if (saveType === 'DELETE') {
                for (var j = 0, length = ruleChked.length; j < length; j++) {
                    ruleID = ruleChked[j].ruleID;
                    var ruleIndex = ruleIDArr.indexOf(ruleID);
                    if (ruleIndex >= 0) {
                        ruleIDArr.splice(ruleIndex, 1);
                    }
                }
            } else if (saveType === 'ADD') {
                for (var k = 0, length = dictChked.length; k < length; k++) {
                    ruleID = dictChked[k].ruleID;
                    if (ruleIDArr.indexOf(ruleID) < 0) {
                        ruleIDArr.push(ruleID);
                    }
                }
            }
            var poliID = GetSelectPolId();
            if (poliID == '') {
                return;
            }
            var ruleIDStr = ruleIDArr.join(',');
            var saveRet = $.cm(
                {
                    ClassName: 'web.DHCSTPIVAS.OrderLink',
                    MethodName: 'SaveOrderFeeRule',
                    POLIID: poliID,
                    FeeRuleIDStr: ruleIDStr,
                    dataType: 'text'
                },
                false
            );
            var saveArr = saveRet.split('^');
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal < 0) {
                $.messager.alert('提示', saveInfo, 'warning');
            }
            QueryGridFeeRule();
        }
    });
}
function InitHospCombo() {
    var genHospObj = PIVAS.AddHospCom({ tableName: 'PIVA_OrderLink' }, { width: 265 });
    if (typeof genHospObj === 'object') {
        //增加选择事件
        genHospObj.options().onSelect = function (index, record) {
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                $('#gridOrderLink').datagrid('load');
                $('#gridFeeRule').datagrid('clear');
                $('#gridFeeRuleDict').datagrid('clear');
               
                
            }
        };
    }
    var defHosp = $.cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'PIVA_OrderLink',
            HospID: HospId
        },
        false
    );
    HospId = defHosp;
}

var ResizeHandler = function (seconds) {
    var timer; // 定时器
    return function () {
        // 定时器还在，退出，说明上次的还没处理完
        if (timer) {
            return;
        }
        // 定时器，延时处理
        timer = setTimeout(function () {
            ResizePanel();
            clearTimeout(timer);

            timer = null;
        }, seconds);
    };
};
function ResizePanel() {
    var panelWidth = $('#lyFeeRule').width();
    var lyWidth = panelWidth / 2 - 40;
    $('#lyFeeRule').layout('panel', 'east').panel('resize', { width: lyWidth });
    $('#lyFeeRule').layout('panel', 'west').panel('resize', { width: lyWidth });
    $('#lyFeeRule').layout('resize');
}

window.onresize = ResizeHandler(1000);
