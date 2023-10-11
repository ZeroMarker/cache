/**
 * ģ��:	��Һ��������շ���
 * ��д����:2018-03-13
 * ��д��:  yunhaibao
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
    //�շ�����
    $('#btnAddPolo').on('click', AddNewRow);
    $('#btnSavePolo').on('click', SaveOrdLinkOrd);
    $('#btnDelPolo').on('click', DeletelPolo);
    // �����շѹ���
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
                        Description: $g('ȫ��')
                    },
                    {
                        RowId: 'Y',
                        Description: $g('����ҽ��')
                    },
                    {
                        RowId: 'N',
                        Description: $g('�ǹ���ҽ��')
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

/// ��ʼ����Һ������
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
                title: '��Һ����',
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

/// ��ʼ��ҽ������
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
                title: 'ҽ��������',
                hidden: true
            },
            {
                field: 'arcItmCode',
                title: 'ҽ�������',
                width: 100
            },
            {
                field: 'arcItmId',
                title: 'ҽ��������',
                width: 200,
                editor: GridCmgArc,
                descField: 'arcItmDesc',
                formatter: function (value, row, index) {
                    return row.arcItmDesc;
                }
            },
            {
                field: 'arcItmQty',
                title: '����',
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
                title: '��������',
                width: 200,
                hidden: true
            },
            {
                field: 'linkOrdPack',
                title: '����',
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
                title: '����ҽ������',
                width: 200,
                hidden: true
            },
            {
                field: 'linkOrdSeq',
                title: '����ҽ��',
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
                title: '����',
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

/// ����һ��
function AddNewRow() {
    var polId = GetSelectPolId();
    if (polId == '') {
        return;
    }
    $('#gridOrdLinkOrd').datagrid('addNewRow', {
        editField: 'arcItmId'
    });
}

/// ����ҽ����
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
            msg: 'û����Ҫ���������',
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
        $.messager.alert('��ʾ', saveInfo, 'warning');
    }
    $('#gridOrdLinkOrd').datagrid('query', {});
}

/// ��ȡҽ�����б�
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
/// ɾ��ҽ����
function DeletelPolo() {
    var gridSelect = $('#gridOrdLinkOrd').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ����Ҫɾ���ļ�¼',
            type: 'alert'
        });

        return;
    }
    $.messager.confirm('ȷ�϶Ի���', '��ȷ��ɾ����', function (r) {
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
            msg: '����ѡ����Ҫ���ӹ������Һ�����¼',
            type: 'alert'
        });
        return '';
    }
    var polId = gridSelect.polId || '';
    if (polId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '����ѡ����Ҫ���ӹ������Һ�����¼',
            type: 'alert'
        });
        return '';
    }
    return polId;
}

/// ��ʼ���շѹ�����
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
                title: '�շѹ���',
                width: 150
            },
            {
                field: 'ruleItmData',
                title: '������ϵ',
                width: 200,
                hidden: true
            },
            {
                field: 'ruleLinkData',
                title: '�շ�ҽ����',

                hidden: false
            },
            {
                field: 'linked',
                title: '�ѹ���',
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
                msg: '��ѡ����Ҫɾ�����ѹ���������',
                type: 'alert'
            });
            return;
        }
    } else if ((saveType = 'ADD')) {
        if (dictChked.length === 0) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: '��ѡ����Ҫ���ӵ�δ����������',
                type: 'alert'
            });
            return;
        }
    }
    $.messager.confirm('��ܰ��ʾ', '��ȷ��' + (saveType === 'ADD' ? '����' : 'ɾ��') + '��?', function (r) {
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
                $.messager.alert('��ʾ', saveInfo, 'warning');
            }
            QueryGridFeeRule();
        }
    });
}
function InitHospCombo() {
    var genHospObj = PIVAS.AddHospCom({ tableName: 'PIVA_OrderLink' }, { width: 265 });
    if (typeof genHospObj === 'object') {
        //����ѡ���¼�
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
    var timer; // ��ʱ��
    return function () {
        // ��ʱ�����ڣ��˳���˵���ϴεĻ�û������
        if (timer) {
            return;
        }
        // ��ʱ������ʱ����
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
