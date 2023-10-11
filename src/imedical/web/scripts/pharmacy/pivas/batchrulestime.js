/**
 * ģ��:     ʱ�����ά��
 * ��д����: 2018-03-19
 * ��д��:   QianHuanjuan
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
    InitDict();
    InitGridBatTime();
    $('#btnAdd').on('click', function () {
        MainTain('A');
    });
    $('#btnUpdate').on('click', function () {
        MainTain('U');
    });
    $('#btnDelete').on('click', Delete);
    $('#btnFind').on('click', function () {
        QueryPIVAFreqTime();
    });
    $('.dhcpha-win-mask').remove();
});

function InitDict() {
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaLoc', Type: 'PivaLoc' },
        {
            placeholder: '��Һ����...',
            editable: false,
            width: 250,
            onSelect: function (selData) {
                QueryPIVAFreqTime();
            },
            onLoadSuccess: function () {
                var datas = $('#cmbPivaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPivaLoc').combobox('setValue', datas[i].RowId);
                        break;
                    }
                }
            }
        }
    );

    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
    PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, {});
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbSeqType',
            data: {
                data: [
                    { RowId: 'Y', Description: $g('����ҽ��') },
                    { RowId: 'N', Description: $g('�ǹ���ҽ��') }
                ]
            }
        },
        {
            panelHeight: 'auto'
        }
    );
}

/// ��ѯʱ������б�
function QueryPIVAFreqTime() {
    var locId = $('#cmbPivaLoc').combobox('getValue');
    var params = locId;
    $('#gridBatTime').datagrid('query', {
        inputStr: locId
    });
}
///ʱ������б�
function InitGridBatTime() {
    //����columns
    var columns = [
        [
            { field: 'pbtId', title: 'ʱ�����id', width: 80, hidden: true, sortable: true },
            { field: 'wardId', title: '����id', width: 80, hidden: true },
            { field: 'locId', title: '��Һ����id', width: 80, hidden: true },
            { field: 'wardDesc', title: '����', width: 120, hidden: true },
            { field: 'locDesc', title: '��Һ����', width: 245 },
            { field: 'startTime', title: '��ʼʱ��', width: 100, align: 'center' },
            { field: 'endTime', title: '����ʱ��', width: 100, align: 'center' },
            { field: 'batNo', title: '����', width: 100, sortable: true, align: 'center' },
            {
                field: 'packFlag',
                title: '�������',
                align: 'center',
                sortable: true,
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return PIVAS.Grid.CSS.CHNYes;
                    }
                }
            },
            {
                field: 'seqFlag',
                title: '����ҽ��',
                width: 100,
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return $g('����ҽ��');
                    } else if (value == 'N') {
                        return $g('�ǹ���ҽ��');
                    } else {
                        return '';
                    }
                }
            },
            { field: 'priId', title: 'ҽ�����ȼ�Id', width: 100, hidden: true, sortable: true },
            { field: 'priDesc', title: 'ҽ�����ȼ�', width: 100, sortable: true },
            { field: 'pyTime', title: 'Ҫ������ʱ��', width: 100, sortable: true },
            { field: 'batRemark', title: '��ע', width: 200, sortable: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.BatchRules',
            QueryName: 'QueryPIVABatTime',
            inputStr: SessionLoc
        },
        columns: columns,
        rownumbers: true,
        toolbar: '#gridBatTimeBar',
        onClickRow: function (rowIndex, rowData) {},
        onLoadSuccess: function () {}
    };
    DHCPHA_HUI_COM.Grid.Init('gridBatTime', dataGridOption);
}

function MainTain(type) {
    var gridSelect = $('#gridBatTime').datagrid('getSelected');
    if (type == 'U') {
        if (gridSelect == null) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: '����ѡ����Ҫ�༭�ļ�¼',
                type: 'alert'
            });
            return;
        }

        $('#timePY').timespinner('clear');
        $('#txtBatNo').val('');
        $('#cmbSeqType').combobox('clear');

        $('#cmbWard').combobox('setValue', gridSelect.wardId);
        $('#cmbPriority').combobox('setValue', gridSelect.priId);
        $('#timeStart').timespinner('setValue', gridSelect.startTime);
        $('#timeEnd').timespinner('setValue', gridSelect.endTime);
        $('#timePY').timespinner('setValue', gridSelect.pyTime);
        $('#cmbSeqType').combobox('setValue', gridSelect.seqFlag);
        $('#txtBatNo').val(gridSelect.batNo);
        $('#txtBatRemark').val(gridSelect.batRemark);
        $('#chkPack').checkbox('setValue', gridSelect.packFlag == 'Y' ? true : false);
    } else if ((type = 'A')) {
        if ($('#cmbPivaLoc').combobox('getValue') == '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: '����ѡ����Һ����',
                type: 'alert'
            });
            return;
        }
        $('#cmbWard').combobox('clear');
        $('#cmbPriority').combobox('clear');
        $('#timeStart').timespinner('clear');
        $('#timeEnd').timespinner('clear');
        $('#timePY').timespinner('clear');
        $('#cmbSeqType').combobox('clear');
        $('#txtBatNo').val('');
        $('#txtBatRemark').val();
        $('#chkPack').checkbox('setValue', false);
    }
    $('#gridBatTimeWin').window({
        title: type == 'A' ? '����' : '�޸�',
        iconCls: type == 'A' ? 'icon-w-add' : 'icon-w-edit',
        onOpen: function () {
            $('#gridBatTimeWin').window('resize',{
              width:$('#gridBatTimeWin .pha-con-table').outerWidth(),
              height:'auto'
            }).window('center')
          }
    });
    $('#gridBatTimeWin').window('open');
    $.data($('#gridBatTimeWin')[0], 'operateType', type == 'A' ? 'add' : 'edit');
}

function SavePIVABatTime() {
    var winTitle = $('#gridBatTimeWin').panel('options').title;
    var gridSelect = $('#gridBatTime').datagrid('getSelected');
    var wardId = $('#cmbWard').combobox('getValue') || '';
    var locId = $('#cmbPivaLoc').combobox('getValue') || '';
    var startTime = $('#timeStart').timespinner('getValue') || '';
    var warnMsg = '';
    if (startTime == '') {
        warnMsg = '��������ҩ��ʼʱ��';
    }
    var endTime = $('#timeEnd').timespinner('getValue') || '';
    if (endTime == '') {
        warnMsg = '��������ҩ����ʱ��';
    }
    var batNo = $('#txtBatNo').val();
    if (batNo == '') {
        warnMsg = '����������';
    }
    if (warnMsg !== '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: warnMsg,
            type: 'alert'
        });
        return;
    }

    var seqFlag = $('#cmbSeqType').combobox('getValue') || '';
    var priId = $('#cmbPriority').combobox('getValue') || '';
    var pyTime = $('#timePY').timespinner('getValue') || '';
    var pbtId = '';
    if ($.data($('#gridBatTimeWin')[0], 'operateType') === 'edit'){
        pbtId = gridSelect.pbtId;
    }
    var batRemark = $('#txtBatRemark').val().replace(/\^/g, '');
    var packFlag = $('#chkPack').checkbox('getValue') == true ? 'Y' : 'N';
    var paramsArr = [pbtId, wardId, locId, startTime, endTime, batNo, seqFlag, priId, pyTime, batRemark, packFlag];
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'SavePIVABatTime', paramsArr.join('^'));
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal == '-1') {
        $.messager.alert('��ʾ', $got(saveInfo), 'warning');
        return;
    } else if (saveVal < 0) {
        $.messager.alert('��ʾ', $got(saveInfo), 'error');
        return;
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: ('����ɹ�'),
            type: 'success'
        });
    }
    $('#gridBatTimeWin').window('close');
    $('#gridBatTime').datagrid('reload');
}

function Delete() {
    var gridSelect = $('#gridBatTime').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: $g('��ѡ����Ҫɾ���ļ�¼'),
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('��ʾ', '��ȷ��ɾ����', function (r) {
        if (r) {
            var pbtId = gridSelect.pbtId;
            var delRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'DeletePIVABatTime', pbtId);
            DHCPHA_HUI_COM.Msg.popover({
                msg: 'ɾ���ɹ�',
                type: 'success'
            });
            $('#gridBatTime').datagrid('query', {});
        }
    });
}

