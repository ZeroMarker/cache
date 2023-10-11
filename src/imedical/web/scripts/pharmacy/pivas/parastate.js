/**
 * ģ��:     ��Һ���̶���
 * ��д����: 2018-01-09
 * ��д��:   yunhaibao
 */

var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
// $.fn.pagination.defaults.layout=['prev','links','next']
$(function () {
    InitGridParaState();
    InitDict();
    $('#btnAdd').on('click', function () {
        MainTain('A');
    });
    $('#btnUpdate').on('click', function () {
        MainTain('U');
    });
    $('#btnDelete').on('click', DeleteHandler);
    $('#btnFind').on('click', Query);
    $('.dhcpha-win-mask').remove();
});

function InitDict() {
    $HUI.checkbox('#chkUse', {
        checked: true
    });
    $HUI.checkbox('#chkSingle', {
        checked: false
    });
    $HUI.checkbox('#chkDisp', {
        checked: false
    });
    $HUI.checkbox('#chkSystem', {
        checked: false,
        disabled: true
    });
    $HUI.checkbox('#chkPackIgnore', {
        checked: false
    });
    $HUI.checkbox('#chkPackDisp', {
        checked: false
    });
    $HUI.checkbox('#chkFeeFlag', {
        checked: false
    });
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaLoc', Type: 'CTLoc' },
        {
            onSelect: function (selData) {
                Query();
            },
            editable: false,
            placeholder: '��Һ����...',
            width: 217,
            onLoadSuccess: function () {
                var datas = $('#cmbPivaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPivaLoc').combobox('select', datas[i].RowId);
                        break;
                    }
                }
            }
        }
    );
    PIVAS.ComboBox.Init(
        { Id: 'conIOType', Type: 'IOType' },
        {
            editable: false,
            width: 113,
            panelHeight: 'auto',
            onSelect: function (selData) {
                Query();
            }
        }
    );
    $('#conIOType').combobox('setValue', 'I');
    PIVAS.ComboBox.Init(
        { Id: 'cmbIOType', Type: 'IOType' },
        {
            editable: false,
            width: 200,
            panelHeight: 'auto',
            disabled: true
        }
    );
    $('#cmbIOType').combobox('clear');
    PIVAS.ComboGrid.Init(
        { Id: 'cmbPsName', Type: 'PIVAStateNumber' },
        {
            editable: false,
            width: 200,
            onSelect: function (e, value) {
                var psNumber = value.psNumber;
                psNumber = parseInt(psNumber);
                $HUI.checkbox('#chkDisp', {
                    disabled: psNumber > 3 ? false : true,
                    checked: false
                });
                $HUI.checkbox('#chkPackDisp', {
                    disabled: psNumber > 3 ? false : true,
                    checked: false
                });
                $HUI.checkbox('#chkSingle', {
                    disabled: psNumber != 30 && psNumber != 60 ? true : false,
                    checked: false
                });
                $HUI.checkbox('#chkSystem', {
                    checked: psNumber == 10 || psNumber == 3 ? true : false
                });
                $HUI.checkbox('#chkPackIgnore', {
                    checked: false,
                    disabled: psNumber > 3 ? false : true
                });
            }
        }
    );
}

function InitGridParaState() {
    var columns = [
        [
            { field: 'psRowId', title: 'psRowId', width: 50, halign: 'center', align: 'center', sortable: true, hidden: true },
            { field: 'psLocId', title: 'psLocId', width: 200, hidden: true },
            { field: 'psType', title: 'psType', width: 200, hidden: true },
            { field: 'psTypeDesc', title: '����', align: 'center', width: 100, sortable: true },
            { field: 'psLocDesc', title: '��Һ����', width: 200, sortable: true },
            { field: 'psNumber', title: '��ʶ��', align: 'center', width: 100, sortable: true },
            { field: 'psName', title: '��������', align: 'center', width: 100, sortable: true },
            {
                field: 'psFlag',
                title: 'ʹ�ñ�ʶ',

                align: 'center',
                sortable: true,
                formatter: FormatterYes
            },
            {
                field: 'psSysFlag',
                title: 'ϵͳ����',

                align: 'center',
                sortable: true,
                formatter: FormatterYes
            },
            {
                field: 'psRetFlag',
                title: '��������',

                align: 'center',
                sortable: true,
                hidden: true,
                formatter: FormatterYes
            },
            {
                field: 'psDispFlag',
                title: '��Һ����',

                align: 'center',
                sortable: true,
                formatter: FormatterYes
            },
            {
                field: 'psPackDisp',
                title: '�������',

                align: 'center',
                sortable: true,
                formatter: FormatterYes
            },
            {
                field: 'psSingleFlag',
                title: '����ִ��',

                align: 'center',
                sortable: true,
                formatter: FormatterYes
            },
            {
                field: 'psPackIgnore',
                title: '�������',

                align: 'center',
                sortable: true,
                formatter: FormatterYes
            },
            {
                field: 'psFeeFlag',
                title: '��ȡ���÷�',
                align: 'center',
                sortable: true,
                formatter: FormatterYes
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        rownumbers: true,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.ParaState',
            QueryName: 'PIVAState',
            inputStr: SessionLoc
        },
        toolbar: '#gridParaStateBar',
        columns: columns,
        onDblClickRow: function (rowIndex) {
            MainTain('U');
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridParaState', dataGridOption);
}

function FormatterYes(value, row, index) {
    if (value == 'Y') {
        return PIVAS.Grid.CSS.CHNYes;
    }
}

function SaveParaState() {
    var winTitle = $('#gridParaStateWin').panel('options').title;
    var gridSelect = $('#gridParaState').datagrid('getSelected');
    var psId = '';
    var psUseFlag = $('#chkUse').is(':checked') == true ? 'Y' : 'N';
    var psDispFlag = $('#chkDisp').is(':checked') == true ? 'Y' : 'N';
    var psSingleFlag = $('#chkSingle').is(':checked') == true ? 'Y' : 'N';
    var psSysFlag = $('#chkSystem').is(':checked') == true ? 'Y' : 'N';
    var psNumber = $('#cmbPsName').combobox('getValue');
    var psNumberDesc = $('#cmbPsName').combobox('getText');
    var psLocId = $('#cmbPivaLoc').combobox('getValue');
    var psIOType = $('#cmbIOType').combobox('getValue');
    var psPackIgnore = $('#chkPackIgnore').is(':checked') == true ? 'Y' : 'N';
    var psPackDisp = $('#chkPackDisp').is(':checked') == true ? 'Y' : 'N';
    var psFeeFlag = $('#chkFeeFlag').is(':checked') == true ? 'Y' : 'N';
    if (winTitle.indexOf($g('����')) >= 0) {
    } else {
        psId = gridSelect.psRowId;
    }
    var params =
        psId + '^' + psNumber + '^' + psUseFlag + '^' + psDispFlag + '^' + psSingleFlag + '^' + psSysFlag + '^' + psLocId + '^' + psIOType + '^' + psPackIgnore + '^' + psPackDisp + '^' + psFeeFlag;
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.ParaState', 'SavePIVAState', params);
    var saveArr = saveRet.split('^');
    var saveValue = saveArr[0];
    var saveInfo = $got(saveArr[1]);
    if (saveValue < 0) {
        $.messager.alert('��ʾ', saveInfo, saveValue == '-1' ? 'warning' : 'error');
        return;
    }
    $('#gridParaStateWin').window('close');
    $('#gridParaState').datagrid('query', {});
}

function MainTain(type) {
    var gridSelect = $('#gridParaState').datagrid('getSelected');
    if (type == 'U') {
        if (gridSelect == null) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('����ѡ����Ҫ�޸ĵļ�¼'),
                type: 'alert'
            });
            return;
        }
        $('#cmbIOType').combobox('setValue', gridSelect.psType);
        $('#cmbPsName').combogrid('setValue', gridSelect.psNumber);
        $HUI.checkbox('#chkUse', { checked: gridSelect.psFlag == 'Y' ? true : false });
        $HUI.checkbox('#chkSingle', { checked: gridSelect.psSingleFlag == 'Y' ? true : false });
        $HUI.checkbox('#chkDisp', { checked: gridSelect.psDispFlag == 'Y' ? true : false });
        $HUI.checkbox('#chkSystem', { checked: gridSelect.psSysFlag == 'Y' ? true : false });
        $HUI.checkbox('#chkPackIgnore', { checked: gridSelect.psPackIgnore == 'Y' ? true : false });
        $HUI.checkbox('#chkPackDisp', { checked: gridSelect.psPackDisp == 'Y' ? true : false });
        $HUI.checkbox('#chkFeeFlag', { checked: gridSelect.psFeeFlag == 'Y' ? true : false });
    } else if ((type = 'A')) {
        $('#cmbIOType').combobox('clear').combobox('setValue', $('#conIOType').combobox('getValue'));
        $('#cmbPsName').combobox('clear');
        $HUI.checkbox('#chkUse', { checked: true });
        $HUI.checkbox('#chkSingle', { checked: false });
        $HUI.checkbox('#chkDisp', { checked: false });
        $HUI.checkbox('#chkSystem', { checked: false });
        $HUI.checkbox('#chkPackIgnore', { checked: false });
        $HUI.checkbox('#chkPackDisp', { checked: false });
        $HUI.checkbox('#chkFeeFlag', { checked: false });
    }
    $('#cmbPsName').combogrid(type == 'A' ? 'enable' : 'disable', true);
    var tmpWidth = $('#gridParaStateWin .pha-con-table').width() + 10;
    $('#gridParaStateWin').window({
        title: $g('��Һ���̶���') + (type == 'A' ? $g('����') : $g('�޸�')),
        iconCls: type == 'A' ? 'icon-w-add' : 'icon-w-edit',
        onOpen: function () {
            $('#gridParaStateWin')
                .window('resize', {
                    width: $('#gridParaStateWin .pha-con-table').width() + 10,
                    height: 'auto'
                })
                .window('center');
        }
    });

    $('#gridParaStateWin').window('open');
    /*
      $('#gridParaStateWin').window('move', {
          left: event.clientX,
          top: event.clientY,
      });
      */
}

function DeleteHandler() {
    var gridSelect = $('#gridParaState').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('��ѡ����Ҫɾ���ļ�¼'),
            type: 'alert'
        });
        return;
    }
    $.messager.confirm($g('ȷ����ʾ'), $g('��ȷ��ɾ����?'), function (r) {
        if (r) {
            var psDr = gridSelect.psRowId;
            var delRet = tkMakeServerCall('web.DHCSTPIVAS.ParaState', 'DeletePIVAState', psDr);
            if (delRet === '-100') {
                var msgInfo = $.messager.alert(
                    $g('��ʾ'),
                    '<div>' + $g('�����Ѿ���ҵ�����ݼ�¼��ʹ��') + '</div><div style="line-height:30px">' + $g('����ѡ�����á�ʹ�ñ�ʶ��Ϊ����') + '</div>',
                    'info'
                );
            }
            $('#gridParaState').datagrid('query', {});
        }
    });
}
function Query() {
    var loc = $('#cmbPivaLoc').combobox('getValue') || '';
    var ioType = $('#conIOType').combobox('getValue') || '';
    if (loc === '' || ioType === '') {
        return;
    }
    $('#gridParaState').datagrid('query', {
        inputStr: loc + '^' + ioType
    });
}
