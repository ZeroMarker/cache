/**
 * ģ��:     �Ű����-���ά��
 * ��д����: 2018-06-27
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var GridCmbScheType;
$(function () {
    InitDict();
    InitKalendae();
    InitGridDict();
    InitGridSchedul(); //��ʼ���б�
    $('#btnAdd').on('click', function () {
        var pivaLocId = $('#cmbPivaLoc').combobox('getValue') || '';
        if (pivaLocId == '') {
            $.messager.alert('��ʾ', '����ѡ����Һ����', 'warning');
            return;
        }
        $('#gridSchedul').datagrid('addNewRow', {
            editField: 'psCode'
        });
    });
    $('#btnSave').on('click', Save);
    $('#btnDelete').on('click', Delete);
    $('#btnFind').on('click', function () {
        $('#gridSchedul').datagrid('query', { inputStr: $('#cmbPivaLoc').combobox('getValue') });
    });
    $('.dhcpha-win-mask').remove();

    //$('#btnConfig').on("click", MainTainFix);
    //$('#btnLinkSche').on("click", MainTainLink);
});

function InitDict() {
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaLoc', Type: 'PivaLoc' },
        {
            onLoadSuccess: function () {
                var datas = $('#cmbPivaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPivaLoc').combobox('select', datas[i].RowId);
                    }
                }
            },
            onSelect: function (selData) {
                $('#gridSchedul').datagrid('query', { inputStr: selData.RowId });
            },
            editable: false,
            placeholder: '��Һ����...',
            width: 275
        }
    );
    var thisYear = new Date().getFullYear();
    var weekDays = [];
    for (var i = 1; i < 8; i++) {
        weekDays.push({ RowId: i, Description: i });
    }
    var monthDays = [];
    for (var i = 1; i < 32; i++) {
        monthDays.push({ RowId: i, Description: i });
    }
    var monthEndDays = [];
    for (var i = 1; i < 5; i++) {
        monthEndDays.push({ RowId: i, Description: i });
    }

    PIVAS.ComboBox.Init(
        {
            Id: 'cmbWeekDays',
            data: {
                data: weekDays
            }
        },
        {
            editable: false,
            multiple: true,
            mode: 'local',
            width: 200
        }
    );
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbMonthDays',
            data: {
                data: monthDays
            }
        },
        {
            editable: false,
            multiple: true,
            mode: 'local',
            width: 200
        }
    );
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbMonthEndDays',
            data: {
                data: monthEndDays
            }
        },
        {
            editable: false,
            multiple: true,
            mode: 'local',
            width: 200
        }
    );
    PIVAS.ComboBox.Init(
        { Id: 'cmbLinkSche', Type: 'PIVASchedul' },
        {
            editable: false,
            placeholder: '���...',
            width: 200,
            multiple: true,
            onBeforeLoad: function (param) {
                param.inputStr = $('#cmbPivaLoc').combobox('getValue') || '';
                param.filterText = param.q;
            }
        }
    );
}

function InitGridDict() {
    GridCmbScheType = PIVAS.GridComboBox.Init(
        {
            Type: 'PIVASchedulType',
            QueryParams: { inputStr: SessionLoc }
        },
        {
            required: true,
            editable: false,
            onBeforeLoad: function (param) {
                param.inputStr = $('#cmbPivaLoc').combobox('getValue') || '';
            }
        }
    );
}

function InitGridSchedul() {
    var columns = [
        [
            { field: 'psId', title: 'psId', hidden: true, width: 100 },
            {
                field: 'psLocDesc',
                title: '��Һ��������',
                width: 100,
                hidden: true
            },
            {
                field: 'psLocId',
                title: '��Һ����',
                width: 150,
                hidden: true
            },
            {
                field: 'psCode',
                title: '��δ���',
                width: 100,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'psDesc',
                title: '�������',
                width: 100,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'psShortDesc',
                title: '��μ��',
                width: 80,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'psStartTime',
                title: '�ϰ�ʱ��',
                width: 100,
                editor: {
                    type: 'timespinner',
                    options: {
                        required: false,
                        showSeconds: true
                    }
                }
            },
            {
                field: 'psEndTime',
                title: '�°�ʱ��',
                width: 100,
                editor: {
                    type: 'timespinner',
                    options: {
                        required: false,
                        showSeconds: true
                    }
                }
            },
            {
                field: 'psScheTypeId',
                title: '�������',
                width: 100,
                align: 'left',
                descField: 'psScheTypeDesc',
                editor: GridCmbScheType,
                formatter: function (value, rowData, rowIndex) {
                    return rowData.psScheTypeDesc;
                }
            },
            {
                field: 'psScheTypeDesc',
                title: '�����������',
                width: 100,
                align: 'left',
                hidden: true
            },
            {
                field: 'psCustFlag',
                title: '�ֶ��Ű�',
                align: 'center',
                width: 75,
                editor: {
                    type: 'icheckbox',
                    options: {
                        required: false,
                        on: 'Y',
                        off: 'N'
                    }
                }
            },
            {
                field: 'psDuration',
                title: '����ʱ��',
                align: 'right',
                width: 75,
                editor: {
                    type: 'numberbox',
                    options: {
                        required: false
                    }
                }
            },
            {
                field: 'psInterval',
                title: '�������',
                align: 'right',
                width: 75,
                hidden: true,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: false
                    }
                }
            },
            {
                field: 'psDays',
                title: '�̶�����',
                halign: 'left',
                align: 'left',
                hidden: true,
                width: 300
            },
            {
                field: 'linkSchStr',
                title: '�������',
                halign: 'left',
                align: 'left',
                hidden: true,
                width: 300
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Schedul',
            QueryName: 'PIVASchedul'
        },
        columns: columns,
        fitColumns: true,
        toolbar: '#gridSchedulBar',
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'psCode'
                });
            }
        },
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridSchedul', dataGridOption);
}

// ��ѯ
function Query() {
    $('#gridSchedul').datagrid('reload');
}

/// ά����ι�������
function MainTainLink(type) {
    var gridSelect = $('#gridSchedul').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('��ʾ', '����ѡ����Ҫ�������ڵİ��', 'warning');
        return;
    }
    var psId = gridSelect.psId || '';
    if (psId == '') {
        $.messager.alert('��ʾ', '���ȱ�����,����������', 'warning');
        return;
    }
    $('#cmbLinkSche').combobox('clear');
    $('#cmbLinkSche').combobox('reload');
    var psDesc = gridSelect.psDesc || '';
    var inputStr = gridSelect.psId;
    AddLinkScheData(inputStr);
    $('#gridLinkScheWin').window('open');
}
/// ��������α༭��Ϣ
function AddLinkScheData(inputStr) {
    var psData = tkMakeServerCall('web.DHCSTPIVAS.Schedul', 'GetLinkScheById', inputStr);
    if (psData == '') {
        // ���
    }
    $('#cmbLinkSche').combobox('setValues', psData.split(','));
}
function SaveLinkSche() {
    var gridSelect = $('#gridSchedul').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('��ʾ', '����ѡ����Ҫ�������ڵİ��', 'warning');
        return;
    }
    var psId = gridSelect.psId || '';
    if (psId == '') {
        $.messager.alert('��ʾ', '���ȱ�����,�����ù������', 'warning');
        return;
    }
    var psLinkId = $('#cmbLinkSche').combobox('getValues') || '';
    var srtParam = psId + '^' + psLinkId;
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.Schedul', 'SaveLinkSche', srtParam);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('��ʾ', saveInfo, 'warning');
    }

    $('#gridLinkScheWin').window('close');
    $('#gridSchedul').datagrid('reload');
}
/// ά���̶�����
function MainTainFix(type) {
    var gridSelect = $('#gridSchedul').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('��ʾ', '����ѡ����Ҫ�������ڵİ��', 'warning');
        return;
    }
    var psId = gridSelect.psId || '';
    if (psId == '') {
        $.messager.alert('��ʾ', '���ȱ�����,����������', 'warning');
        return;
    }
    $('#cmbMonthDays').combobox('clear');
    $('#cmbMonthEndDays').combobox('clear');
    $('#cmbWeekDays').combobox('clear');
    $('#kalSelect').val('');
    var psDesc = gridSelect.psDesc || '';
    var inputStr = gridSelect.psId;
    AddScheFixData(inputStr);
    $('#gridScheFixWin').window({ title: psDesc + '�̶���������' });
    $('#gridScheFixWin').window('open');
}
/// ���༭��Ϣ
function AddScheFixData(inputStr) {
    var psData = tkMakeServerCall('web.DHCSTPIVAS.Schedul', 'GetScheDateById', inputStr);
    if (psData == '') {
        // ���
    }
    var psDataArr = psData.split('!!');
    var psDataLen = psDataArr.length;
    for (var i = 0; i < psDataLen; i++) {
        var iData = psDataArr[i];
        if (iData == '') {
            continue;
        }
        var iDataArr = iData.split(':');
        var daysType = iDataArr[0];
        var days = iDataArr[1].toString();
        if (daysType == 'M') {
            $('#cmbMonthDays').combobox('setValues', days.split(','));
        } else if (daysType == 'ME') {
            $('#cmbMonthEndDays').combobox('setValues', days.split(','));
        } else if (daysType == 'W') {
            $('#cmbWeekDays').combobox('setValues', days.split(','));
        } else if (daysType == 'D') {
            $('#kalSelect').val(days);
        }
    }
}

function Save() {
    var pivaLocId = $('#cmbPivaLoc').combobox('getValue') || '';
    if (pivaLocId == '') {
        $.messager.alert('��ʾ', '����ѡ����Һ����', 'warning');
        return;
    }
    $('#gridSchedul').datagrid('endEditing');
    var gridChanges = $('#gridSchedul').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert('��ʾ', 'û����Ҫ���������', 'warning');
        return;
    }
    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        if ($('#gridSchedul').datagrid('getRowIndex', iData) < 0) {
            continue;
        }
        var params =
            (iData.psId || '') +
            '^' +
            pivaLocId +
            '^' +
            (iData.psCode || '') +
            '^' +
            (iData.psDesc || '') +
            '^' +
            (iData.psShortDesc || '') +
            '^' +
            (iData.psStartTime || '') +
            '^' +
            (iData.psEndTime || '') +
            '^' +
            (iData.psScheTypeId || '') +
            '^' +
            (iData.psCustFlag || '') +
            '^' +
            (iData.psDuration || '') +
            '^' +
            (iData.psInterval || '');
        paramsStr = paramsStr == '' ? params : paramsStr + '!!' + params;
    }
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.Schedul', 'SaveMulti', paramsStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('��ʾ', saveInfo, 'warning');
    }
    $('#gridSchedul').datagrid('reload');
}

function Delete() {
    var gridSelect = $('#gridSchedul').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('��ʾ', '��ѡ����Ҫɾ���ļ�¼!', 'warning');
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function (r) {
        if (r) {
            var psId = gridSelect.psId || '';
            var rowIndex = $('#gridSchedul').datagrid('getRowIndex', gridSelect);
            if (psId != '') {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.Schedul', 'Delete', psId);
                var delRetArr = delRet.split('^');
                var delValue = delRetArr[0];
                if (delValue < 0) {
                    $.messager.alert('��ʾ', delRetArr[1], 'warning');
                    return;
                }
            }
            $('#gridSchedul').datagrid('deleteRow', rowIndex);
        }
    });
}

function SaveScheFix() {
    var gridSelect = $('#gridSchedul').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('��ʾ', '����ѡ����Ҫ�������ڵİ��', 'warning');
        return;
    }
    var psId = gridSelect.psId || '';
    if (psId == '') {
        $.messager.alert('��ʾ', '���ȱ�����,����������', 'warning');
        return;
    }
    var monthDays = $('#cmbMonthDays').combobox('getValues') || '';
    monthDays = monthDays.join(',');
    var monthEndDays = $('#cmbMonthEndDays').combobox('getValues') || '';
    monthEndDays = monthEndDays.join(',');
    var weekDays = $('#cmbWeekDays').combobox('getValues') || '';
    weekDays = weekDays.join(',');
    var days = $('#kalSelect').val();
    var daysStr = 'M:' + monthDays + '!!' + 'D:' + days + '!!' + 'W:' + weekDays + '!!' + 'ME:' + monthEndDays;
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.Schedul', 'SaveDays', psId, daysStr);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('��ʾ', saveInfo, 'warning');
    }
    $('#gridSchedul').datagrid('reload');
    $('#gridScheFixWin').window('close');
}
function InitKalendae() {
    //Kalendae.prototype.
    //Language.prototype._month = "һ��1_��1��_��1��_��1��_��1��_��1��_��1_����_����_ʮ��_ʮһ��_ʮ����".split("_")
    $('#kalSelect').kalendae({
        months: 1,
        mode: 'multiple',
        dayHeaderClickable: true,
        dayAttributeFormat: 'YYYY-MM-DD',
        format: 'YYYY-MM-DD'
    });
}

