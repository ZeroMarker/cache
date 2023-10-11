/**
 * ģ��:	סԺҩ����ҩ�ͻ�������
 * ��д����:2019-01-31
 * ��д��:  yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
$(function () {
    InitDict();
    InitGridConfig();
    InitGridPri();
    InitGridPriDisType();
    $('#txtUser,#txtMac').on('keypress', function (event) {
        if (event.keyCode == '13') {
            Query();
        }
    });
    InitHospCombo();
    setTimeout(function () {
        $('.dhcpha-win-mask').remove();
    }, 500);
});

function InitDict() {
    // ҩ��
    DHCPHA_HUI_COM.ComboBox.Init(
        { Id: 'cmbPhaLoc', Type: 'PhaLoc' },
        {
            editable: false,
            width: 300,
            onLoadSuccess: function () {
                var datas = $('#cmbPhaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPhaLoc').combobox('select', datas[i].RowId);
                        break;
                    }
                }
            },
            onSelect: function (selData) {
                Query();
                $('#cmbLocUser').combobox('reload');
            }
        }
    );
    // �û�
    DHCPHA_HUI_COM.ComboBox.Init(
        { Id: 'cmbLocUser', Type: 'LocUser' },
        {
            onBeforeLoad: function (param) {
                param.filterText = param.q;
                param.inputStr = $('#cmbPhaLoc').combobox('getValue') || '';
            }
        }
    );
}

function InitGridConfig() {
    var columns = [
        [
            {
                field: 'plcId',
                title: '����Id',
                width: 100,
                hidden: true
            },
            {
                field: 'plcDesc',
                title: '��������',
                width: 100
            },
            {
                field: 'userCode',
                title: '����',
                width: 100
            },
            {
                field: 'userId',
                title: '�û�Id',
                width: 100,
                hidden: true
            },
            {
                field: 'userName',
                title: '����',
                width: 100
            },
            {
                field: 'mac',
                title: 'MAC��ַ',
                width: 150
            },
            {
                field: 'priDisTypeStr',
                title: 'ҽ�����ȼ��뷢ҩ���',
                width: 360
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCINPHA.Config.Query',
            QueryName: 'DHCPhaLocConfig'
        },
        nowrap: false,
        columns: columns,
        toolbar: '#gridConfigToolbar',
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                QueryPri();
            }
        },
        onLoadSuccess: function () {
            QueryPri();
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridConfig', dataGridOption);
}

function InitGridPri() {
    var columns = [
        [
            {
                field: 'select',
                checkbox: true
            },
            {
                field: 'ppId',
                title: 'ppId',
                width: 200,
                hidden: true
            },
            {
                field: 'priId',
                title: '���ȼ�Id',
                width: 200,
                hidden: true
            },
            {
                field: 'priDesc',
                title: 'ҽ�����ȼ�',
                width: 200
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCINPHA.Config.Query',
            QueryName: 'DHCPhaPriority'
        },
        pagination: false,
        columns: columns,
        toolbar: '#gridPriToolbar',
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        fitColumns: true,
        onClickRow: function (rowIndex, rowData) {
            $('#gridPri').datagrid('unselectAll');
            $('#gridPri').datagrid('selectRow', rowIndex);
            QueryPriDisType();
        },
        onLoadSuccess: function () {
            var rows = $(this).datagrid('getRows');
            if (rows) {
                var rowsLen = rows.length;
                for (var rowI = 0; rowI < rowsLen; rowI++) {
                    var rowData = rows[rowI];
                    var ppId = rowData.ppId || '';
                    if (ppId != '') {
                        $(this).datagrid('checkRow', rowI);
                    } else {
                        $(this).datagrid('uncheckRow', rowI);
                    }
                }
            }
            QueryPriDisType();
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridPri', dataGridOption);
}

function InitGridPriDisType() {
    var columns = [
        [
            {
                field: 'select',
                checkbox: true
            },
            {
                field: 'ppdpId',
                title: 'ppdpId',
                width: 200,
                hidden: true
            },
            {
                field: 'disTypeId',
                title: '��ҩ���Id',
                width: 200,
                hidden: true
            },
            {
                field: 'disTypeDesc',
                title: '��ҩ���',
                width: 200
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        fitColumns: true,
        singleSelect: false,
        queryParams: {
            ClassName: 'web.DHCINPHA.Config.Query',
            QueryName: 'DHCPhaPriorDisType'
        },
        columns: columns,
        pagination: false,
        toolbar: '#gridPriDisTypeToolbar',
        onLoadSuccess: function () {
            var rows = $(this).datagrid('getRows');
            if (rows) {
                var rowsLen = rows.length;
                for (var rowI = 0; rowI < rowsLen; rowI++) {
                    var rowData = rows[rowI];
                    var ppdpId = rowData.ppdpId || '';
                    if (ppdpId != '') {
                        $(this).datagrid('checkRow', rowI);
                    } else {
                        $(this).datagrid('uncheckRow', rowI);
                    }
                }
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridPriDisType', dataGridOption);
}

function Query() {
    var locId = $('#cmbPhaLoc').combobox('getValue') || '';
    var userText = $('#txtUser').val();
    var macText = $('#txtMac').val();
    var inputStr = locId + '^' + userText + '^' + macText;
    $('#gridConfig').datagrid('query', {
        InputStr: inputStr
    });
}

function QueryPri() {
    $('#gridPri').datagrid('uncheckAll');
    var configSelect = $('#gridConfig').datagrid('getSelected');
    var plcId = '';
    if (configSelect) {
        plcId = configSelect.plcId;
    }
    $('#gridPri').datagrid('query', {
        InputStr: plcId
    });
}

function QueryPriDisType() {
    $('#gridPriDisType').datagrid('uncheckAll');
    var priSelect = $('#gridPri').datagrid('getSelected');
    var ppId = '';
    if (priSelect) {
        ppId = priSelect.ppId;
    }
    var locId = $('#cmbPhaLoc').combobox('getValue') || '';
    $('#gridPriDisType').datagrid('query', {
        InputStr: ppId + '^' + locId
    });
}

function AddConfigShow() {
    var locId = $('#cmbPhaLoc').combobox('getValue') || '';
    if (locId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ��ҩ��',
            type: 'alert'
        });
        return;
    }
    $('#gridConfigWin').window({ title: '��������', iconCls: 'icon-w-add' });
    $('#gridConfigWin').window('open');
    $('#cmbLocUser').combobox('clear');
    $('#txtMacAdd').val('');
    $('#txtConfig').val('');
}

function EditConfigShow() {
    var configSelect = $('#gridConfig').datagrid('getSelected') || '';
    if (configSelect == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ����Ҫ�༭�ļ�¼',
            type: 'alert'
        });
        return;
    }
    $('#gridConfigWin').window({ title: '�༭����', iconCls: 'icon-w-edit' });
    $('#gridConfigWin').window('open');
    var userId = configSelect.userId || '';
    var configDesc = configSelect.plcDesc || '';
    var mac = configSelect.mac || '';
    $('#cmbLocUser').combobox('setValue', userId);
    $('#txtMacAdd').val(mac);
    $('#txtConfig').val(configDesc);
}

function SaveConfig() {
    var winTitle = $('#gridConfigWin').window('options').title || '';
    if (winTitle == '') {
        return;
    }
    var locId = $('#cmbPhaLoc').combobox('getValue') || '';
    var mac = $('#txtMacAdd').val();
    if (mac != '') {
        if (CheckMac(mac) == false) {
            $.messager.alert('��ʾ', 'MAC��ַ��ʽ����ȷ,�� : �� - �ָ�</br>����</br>����60-57-18-D7-E6-B4</br>����60:57:18:D7:E6:B4', 'warning ');
            return;
        }
    }
    var userId = $('#cmbLocUser').combobox('getValue') || '';
    var configDesc = $('#txtConfig').val();
    if (mac != '' && userId != '') {
        $.messager.alert('��ʾ', '�û���MAC��ַֻ��ѡ��һ�ַ�ʽά��', 'warning');
        return;
    }
    if (mac == '' && userId == '') {
        $.messager.alert('��ʾ', '�û���MAC��ַ����ͬʱΪ��', 'warning');
        return;
    }
    if (configDesc == '') {
        $.messager.alert('��ʾ', '�������Ʋ���Ϊ��', 'warning');
        return;
    }
    var plcId = '';
    if (winTitle.indexOf('�༭') >= 0 || winTitle.indexOf('�޸�') >= 0) {
        var configSelect = $('#gridConfig').datagrid('getSelected') || '';
        plcId = configSelect.plcId;
    }
    var inputStr = plcId + '^' + locId + '^' + configDesc + '^' + userId + '^' + mac;
    var saveRet = tkMakeServerCall('web.DHCINPHA.Config.Save', 'SaveConfig', inputStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveMsg = saveArr[1];
    if (saveVal == 0) {
        $('#gridConfigWin').window('close');
        Query();
    } else {
        $.messager.alert('��ʾ', saveMsg, 'warning');
    }
}

function DeleteConfig() {
    var configSelect = $('#gridConfig').datagrid('getSelected') || '';
    if (configSelect == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ����Ҫɾ���ļ�¼',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function (r) {
        if (r) {
            var plcId = configSelect.plcId;
            var delRet = tkMakeServerCall('web.DHCINPHA.Config.Save', 'DeleteConfig', plcId);
            var delArr = delRet.split('^');
            if (delArr[0] < 0) {
                $.messager.alert('��ʾ', delArr[1], 'warning');
            } else {
                Query();
            }
        }
    });
}

function SavePri() {
    var configSelect = $('#gridConfig').datagrid('getSelected') || '';
    if (configSelect == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ����Ҫ�������ȼ���������ü�¼',
            type: 'alert'
        });
        return;
    }
    var plcId = configSelect.plcId;
    var priIdArr = [];
    var priChecked = $('#gridPri').datagrid('getChecked');
    for (var i = 0; i < priChecked.length; i++) {
        var priId = priChecked[i].priId;
        priIdArr.push(priId);
    }
    var saveRet = tkMakeServerCall('web.DHCINPHA.Config.Save', 'SavePri', plcId, priIdArr.join('^'));
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveMsg = saveArr[1];
    if (saveVal == 0) {
        $('#gridPri').datagrid('reload');
        UpdateGridConfig();
    } else {
        $.messager.alert('��ʾ', saveMsg, 'warning');
    }
}

function SavePriDisType() {
    var priSelect = $('#gridPri').datagrid('getSelected') || '';
    if (priSelect == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '����ѡ����Ҫ������ҩ����ҽ�����ȼ���¼',
            type: 'alert'
        });
        return;
    }
    var ppId = priSelect.ppId || '';
    if (ppId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ�е�ҽ�����ȼ���δ��������,���ȱ���',
            type: 'alert'
        });
        return;
    }
    var disTypeIdArr = [];
    var disTypeChecked = $('#gridPriDisType').datagrid('getChecked');
    for (var i = 0; i < disTypeChecked.length; i++) {
        var disTypeId = disTypeChecked[i].disTypeId;
        disTypeIdArr.push(disTypeId);
    }
    var saveRet = tkMakeServerCall('web.DHCINPHA.Config.Save', 'SavePriDisType', ppId, disTypeIdArr.join('^'));
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveMsg = saveArr[1];
    if (saveVal == 0) {
        $('#gridPriDisType').datagrid('reload');
        UpdateGridConfig();
    } else {
        $.messager.alert('��ʾ', saveMsg, 'warning');
    }
}

function CheckMac(macText) {
    var reg1 = /^[A-Fa-f\d]{2}:[A-Fa-f\d]{2}:[A-Fa-f\d]{2}:[A-Fa-f\d]{2}:[A-Fa-f\d]{2}:[A-Fa-f\d]{2}$/;
    var reg2 = /^[A-Fa-f\d]{2}-[A-Fa-f\d]{2}-[A-Fa-f\d]{2}-[A-Fa-f\d]{2}-[A-Fa-f\d]{2}-[A-Fa-f\d]{2}$/;
    var reg1Ret = reg1.test(macText);
    var reg2Ret = reg2.test(macText);
    if (reg1Ret == false && reg2Ret == false) {
        return false;
    } else {
        return true;
    }
}

function UpdateGridConfig() {
    var configSelect = $('#gridConfig').datagrid('getSelected') || '';
    var configRows = $('#gridConfig').datagrid('getRows');
    if (configSelect) {
        var rowIndex = configRows.indexOf(configSelect);
        var plcId = configSelect.plcId;
        var priDisTypeStr = tkMakeServerCall('web.DHCINPHA.Config.Query', 'GetPriDisTypeStr', plcId);
        $('#gridConfig').datagrid('updateRow', {
            index: rowIndex,
            row: {
                priDisTypeStr: priDisTypeStr
            }
        });
    }
}
function InitHospCombo() {
    var genHospObj = GenHospComp('PHA-IP-UserDispType', '', { width: 300 });
    // var genHospObj=PHA_COM.GenHospCombo({tableName:'PHA-IP-UserDispType'});
    if (typeof genHospObj === 'object') {
        //����ѡ���¼�
        genHospObj.options().onSelect = function (index, record) {
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                $('#cmbPhaLoc').combobox('clear');
                $('#cmbPhaLoc').combobox('reload');
                Query();
            }
        };
    }
}
