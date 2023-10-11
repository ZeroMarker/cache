/**
 * 模块:     排班管理-班次维护
 * 编写日期: 2018-06-27
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var GridCmbScheType;
$(function () {
    InitDict();
    InitKalendae();
    InitGridDict();
    InitGridSchedul(); //初始化列表
    $('#btnAdd').on('click', function () {
        var pivaLocId = $('#cmbPivaLoc').combobox('getValue') || '';
        if (pivaLocId == '') {
            $.messager.alert('提示', '请先选择配液中心', 'warning');
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
            placeholder: '配液中心...',
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
            placeholder: '班次...',
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
                title: '配液中心描述',
                width: 100,
                hidden: true
            },
            {
                field: 'psLocId',
                title: '配液中心',
                width: 150,
                hidden: true
            },
            {
                field: 'psCode',
                title: '班次代码',
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
                title: '班次名称',
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
                title: '班次简称',
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
                title: '上班时间',
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
                title: '下班时间',
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
                title: '班次类型',
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
                title: '班次类型描述',
                width: 100,
                align: 'left',
                hidden: true
            },
            {
                field: 'psCustFlag',
                title: '手动排班',
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
                title: '工作时长',
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
                title: '间隔天数',
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
                title: '固定日期',
                halign: 'left',
                align: 'left',
                hidden: true,
                width: 300
            },
            {
                field: 'linkSchStr',
                title: '关联班次',
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

// 查询
function Query() {
    $('#gridSchedul').datagrid('reload');
}

/// 维护班次关联规则
function MainTainLink(type) {
    var gridSelect = $('#gridSchedul').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('提示', '请先选择需要设置日期的班次', 'warning');
        return;
    }
    var psId = gridSelect.psId || '';
    if (psId == '') {
        $.messager.alert('提示', '请先保存班次,再设置日期', 'warning');
        return;
    }
    $('#cmbLinkSche').combobox('clear');
    $('#cmbLinkSche').combobox('reload');
    var psDesc = gridSelect.psDesc || '';
    var inputStr = gridSelect.psId;
    AddLinkScheData(inputStr);
    $('#gridLinkScheWin').window('open');
}
/// 填充关联班次编辑信息
function AddLinkScheData(inputStr) {
    var psData = tkMakeServerCall('web.DHCSTPIVAS.Schedul', 'GetLinkScheById', inputStr);
    if (psData == '') {
        // 清空
    }
    $('#cmbLinkSche').combobox('setValues', psData.split(','));
}
function SaveLinkSche() {
    var gridSelect = $('#gridSchedul').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('提示', '请先选择需要设置日期的班次', 'warning');
        return;
    }
    var psId = gridSelect.psId || '';
    if (psId == '') {
        $.messager.alert('提示', '请先保存班次,再设置关联班次', 'warning');
        return;
    }
    var psLinkId = $('#cmbLinkSche').combobox('getValues') || '';
    var srtParam = psId + '^' + psLinkId;
    var saveRet = tkMakeServerCall('web.DHCSTPIVAS.Schedul', 'SaveLinkSche', srtParam);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'warning');
    }

    $('#gridLinkScheWin').window('close');
    $('#gridSchedul').datagrid('reload');
}
/// 维护固定规则
function MainTainFix(type) {
    var gridSelect = $('#gridSchedul').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('提示', '请先选择需要设置日期的班次', 'warning');
        return;
    }
    var psId = gridSelect.psId || '';
    if (psId == '') {
        $.messager.alert('提示', '请先保存班次,再设置日期', 'warning');
        return;
    }
    $('#cmbMonthDays').combobox('clear');
    $('#cmbMonthEndDays').combobox('clear');
    $('#cmbWeekDays').combobox('clear');
    $('#kalSelect').val('');
    var psDesc = gridSelect.psDesc || '';
    var inputStr = gridSelect.psId;
    AddScheFixData(inputStr);
    $('#gridScheFixWin').window({ title: psDesc + '固定日期设置' });
    $('#gridScheFixWin').window('open');
}
/// 填充编辑信息
function AddScheFixData(inputStr) {
    var psData = tkMakeServerCall('web.DHCSTPIVAS.Schedul', 'GetScheDateById', inputStr);
    if (psData == '') {
        // 清空
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
        $.messager.alert('提示', '请先选择配液中心', 'warning');
        return;
    }
    $('#gridSchedul').datagrid('endEditing');
    var gridChanges = $('#gridSchedul').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert('提示', '没有需要保存的数据', 'warning');
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
        $.messager.alert('提示', saveInfo, 'warning');
    }
    $('#gridSchedul').datagrid('reload');
}

function Delete() {
    var gridSelect = $('#gridSchedul').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert('提示', '请选择需要删除的记录!', 'warning');
        return;
    }
    $.messager.confirm('确认对话框', '确定删除吗？', function (r) {
        if (r) {
            var psId = gridSelect.psId || '';
            var rowIndex = $('#gridSchedul').datagrid('getRowIndex', gridSelect);
            if (psId != '') {
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.Schedul', 'Delete', psId);
                var delRetArr = delRet.split('^');
                var delValue = delRetArr[0];
                if (delValue < 0) {
                    $.messager.alert('提示', delRetArr[1], 'warning');
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
        $.messager.alert('提示', '请先选择需要设置日期的班次', 'warning');
        return;
    }
    var psId = gridSelect.psId || '';
    if (psId == '') {
        $.messager.alert('提示', '请先保存班次,再设置日期', 'warning');
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
        $.messager.alert('提示', saveInfo, 'warning');
    }
    $('#gridSchedul').datagrid('reload');
    $('#gridScheFixWin').window('close');
}
function InitKalendae() {
    //Kalendae.prototype.
    //Language.prototype._month = "一月1_二1月_三1月_四1月_五1月_六1月_七1_八月_九月_十月_十一月_十二月".split("_")
    $('#kalSelect').kalendae({
        months: 1,
        mode: 'multiple',
        dayHeaderClickable: true,
        dayAttributeFormat: 'YYYY-MM-DD',
        format: 'YYYY-MM-DD'
    });
}

