/**
 * 模块:     时间规则维护
 * 编写日期: 2018-03-19
 * 编写人:   QianHuanjuan
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
            placeholder: '配液中心...',
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
                    { RowId: 'Y', Description: $g('关联医嘱') },
                    { RowId: 'N', Description: $g('非关联医嘱') }
                ]
            }
        },
        {
            panelHeight: 'auto'
        }
    );
}

/// 查询时间规则列表
function QueryPIVAFreqTime() {
    var locId = $('#cmbPivaLoc').combobox('getValue');
    var params = locId;
    $('#gridBatTime').datagrid('query', {
        inputStr: locId
    });
}
///时间规则列表
function InitGridBatTime() {
    //定义columns
    var columns = [
        [
            { field: 'pbtId', title: '时间规则id', width: 80, hidden: true, sortable: true },
            { field: 'wardId', title: '病区id', width: 80, hidden: true },
            { field: 'locId', title: '配液中心id', width: 80, hidden: true },
            { field: 'wardDesc', title: '病区', width: 120, hidden: true },
            { field: 'locDesc', title: '配液中心', width: 245 },
            { field: 'startTime', title: '开始时间', width: 100, align: 'center' },
            { field: 'endTime', title: '结束时间', width: 100, align: 'center' },
            { field: 'batNo', title: '批次', width: 100, sortable: true, align: 'center' },
            {
                field: 'packFlag',
                title: '打包批次',
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
                title: '关联医嘱',
                width: 100,
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return $g('关联医嘱');
                    } else if (value == 'N') {
                        return $g('非关联医嘱');
                    } else {
                        return '';
                    }
                }
            },
            { field: 'priId', title: '医嘱优先级Id', width: 100, hidden: true, sortable: true },
            { field: 'priDesc', title: '医嘱优先级', width: 100, sortable: true },
            { field: 'pyTime', title: '要求配送时间', width: 100, sortable: true },
            { field: 'batRemark', title: '备注', width: 200, sortable: true }
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
                msg: '请先选中需要编辑的记录',
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
                msg: '请先选择配液中心',
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
        title: type == 'A' ? '新增' : '修改',
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
        warnMsg = '请输入用药开始时间';
    }
    var endTime = $('#timeEnd').timespinner('getValue') || '';
    if (endTime == '') {
        warnMsg = '请输入用药结束时间';
    }
    var batNo = $('#txtBatNo').val();
    if (batNo == '') {
        warnMsg = '请输入批次';
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
        $.messager.alert('提示', $got(saveInfo), 'warning');
        return;
    } else if (saveVal < 0) {
        $.messager.alert('提示', $got(saveInfo), 'error');
        return;
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: ('保存成功'),
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
            msg: $g('请选择需要删除的记录'),
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('提示', '您确定删除吗？', function (r) {
        if (r) {
            var pbtId = gridSelect.pbtId;
            var delRet = tkMakeServerCall('web.DHCSTPIVAS.BatchRules', 'DeletePIVABatTime', pbtId);
            DHCPHA_HUI_COM.Msg.popover({
                msg: '删除成功',
                type: 'success'
            });
            $('#gridBatTime').datagrid('query', {});
        }
    });
}

