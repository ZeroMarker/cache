/**
 * 模块:     配液审核原因维护
 * 编写日期: 2018-04-19
 * 编写人:   QianHuanjuan
 */
var HospId = session['LOGON.HOSPID'];
PIVAS.VAR.CNTSWAYID = tkMakeServerCall('web.DHCSTPIVAS.Common', 'PIVASCNTSWAYID');
$(function () {
    if (PIVAS.VAR.CNTSWAYID == '') {
        $.messager.alert('提示', '配伍审核类型尚未维护,请联系信息人员添加!', 'warning');
        return;
    }
    InitTreeGridReason(); // 初始化列表
    InitGridAuditReason();
    $('#btnAdd').on('click', AddNewRow);
    $('#btnSave').on('click', SaveAuditReason);
    $('#btnDelete').on('click', DeleteHandler);
    InitHospCombo();
    PHA_UX.Translate({ buttonID: 'btnTranslate', gridID: 'gridAuditReason', idField: 'pcrRowId', sqlTableName: 'DHC_PHCNTSREASON' });
    $('.dhcpha-win-mask').remove();
});

/// 查询审核原因列表列表
function QueryAuditReason(reasonId) {
    var params = PIVAS.VAR.CNTSWAYID + '^' + reasonId;
    $('#gridAuditReason').datagrid('query', { inputStr: params });
}

function InitTreeGridReason() {
    var treeColumns = [
        [
            { field: 'reasonId', title: 'reasonId', width: 250, hidden: true },
            { field: 'reasonDesc', title: '配伍审核原因', width: 250 },
            { field: '_parentId', title: 'parentId', hidden: true }
        ]
    ];
    $('#treeGridReason').treegrid({
        animate: true,
        border: false,
        fit: true,
        checkbox: false,
        nowrap: true,
        fitColumns: true,
        singleSelect: true,
        idField: 'reasonId',
        treeField: 'reasonDesc',
        pagination: false,
        columns: treeColumns,
        url: PIVAS.URL.COMMON,
        toolbar: '#treeGridReasonBar',
        queryParams: {
            action: 'JsGetAuditReason',
            params: PIVAS.VAR.CNTSWAYID + '^0', // 固定1
            hosp: HospId
        },
        onClickRow: function (rowIndex, rowData) {
            var reasonId = rowData.reasonId;
            QueryAuditReason(reasonId);
        },
        onLoadSuccess: function (state, data) {
            if (data.total === 0) {
                tkMakeServerCall('web.DHCSTPIVAS.AuditReason', 'InitDictByHosp', PIVAS.VAR.CNTSWAYID, HospId);
                $(this).treegrid('reload');
            }
        }
    });
    $('.datagrid-header').css('display', 'none');
}

function InitGridAuditReason() {
    var columns = [
        [
            { field: 'pcrRowId', title: 'pcrRowId', width: 1, hidden: true },
            {
                field: 'pcrCode',
                title: '原因代码',
                width: 30,
                sortable: 'true',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            {
                field: 'pcrDesc',
                title: '原因内容',
                width: 70,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },
            { field: 'pcrLevel', title: '父节点', width: 1, halign: 'center', align: 'center', hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.AuditReason',
            QueryName: 'QueryAuditReason',
            hosp: HospId
        },
        columns: columns,
        fitColumns: true,
        nowrap: false,
        toolbar: '#gridAuditReasonBar',
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'pcrCode'
            });
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridAuditReason', dataGridOption);
}

function AddNewRow() {
    var gridSelect = $('#treeGridReason').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选中左侧配伍审核原因记录',
            type: 'alert'
        });
        return;
    }
    var reasonId = gridSelect.reasonId || '';
    if (reasonId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请先选中左侧配伍审核原因记录',
            type: 'alert'
        });
        return;
    }
    $('#gridAuditReason').datagrid('addNewRow', { editField: 'pcrCode' });
}

function DeleteHandler() {
    var gridSelect = $('#gridAuditReason').datagrid('getSelected');
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '请选择需要删除的记录',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('确认对话框', '您确定删除吗？', function (r) {
        if (r) {
            var pcrRowId = gridSelect.pcrRowId || '';
            if (pcrRowId == '') {
                var rowIndex = $('#gridAuditReason').datagrid('getRowIndex', gridSelect);
                $('#gridAuditReason').datagrid('deleteRow', rowIndex);
            } else {
                var pcrLevel = gridSelect.pcrLevel;
                var delRet = tkMakeServerCall('web.DHCSTPIVAS.AuditReason', 'DeleteAuditReason', PIVAS.VAR.CNTSWAYID, pcrRowId, pcrLevel, HospId);
                var delArr = delRet.split('^');
                if (delArr[0] == -1) {
                    $.messager.alert('提示', delArr[1], 'warning');
                } else {
                    DHCPHA_HUI_COM.Msg.popover({
                        msg: '删除成功',
                        type: 'success'
                    });
                }
                $('#gridAuditReason').datagrid('reload');
                $('#treeGridReason').treegrid('reload');
            }
        }
    });
}

function SaveAuditReason() {
    var treeSelect = $('#treeGridReason').datagrid('getSelected');
    if (treeSelect == null) {
        $.messager.alert('提示', '请先选中左侧配伍审核原因记录', 'warning');
        return;
    }
    var reasonLevel = treeSelect.reasonId || '';
    if (reasonLevel == '') {
        $.messager.alert('提示', '请先选中左侧配伍审核原因记录', 'warning');
        return;
    }
    $('#gridAuditReason').datagrid('endEditing');
    var gridChanges = $('#gridAuditReason').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert('提示', '没有需要保存的数据', 'warning');
        return;
    }
    var paramsStr = '';
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params = (iData.pcrRowId || '') + '^' + (iData.pcrCode || '') + '^' + (iData.pcrDesc || '') + '^' + reasonLevel + '^' + PIVAS.VAR.CNTSWAYID;
        paramsStr = paramsStr == '' ? params : paramsStr + '|@|' + params;
    }
    $.m(
        {
            ClassName: 'web.DHCSTPIVAS.AuditReason',
            MethodName: 'Save',
            inputData: paramsStr,
            hosp: HospId
        },
        function (retData) {
            if (retData.indexOf('msg') >= 0) {
                $.messager.alert('提示', JSON.parse(retData).msg, 'error');
                return;
            }
            var retArr = retData.split('^');
            if (retArr[0] == -1) {
                $.messager.alert('提示', retArr[1], 'warning');
            } else if (retArr[0] < -1) {
                $.messager.alert('提示', retArr[1], 'error');
            } else {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '保存成功',
                    type: 'success'
                });
            }
            $('#gridAuditReason').datagrid('reload');
            $('#treeGridReason').treegrid('reload');
        }
    );
}
function InitHospCombo() {
    var genHospObj = PIVAS.AddHospCom({ tableName: 'DHC_PHCNTSREASON' }, { width: 390 });
    if (typeof genHospObj === 'object') {
        genHospObj.options().onSelect = function (index, record) {
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;

                $('#treeGridReason').treegrid('options').queryParams.hosp = HospId;
                $('#treeGridReason').treegrid('load');
                $('#gridAuditReason').datagrid('options').queryParams.hosp = HospId;
                $('#gridAuditReason').datagrid('load');
            }
        };
    }
    var defHosp = $.cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'DHC_PHCNTSREASON',
            HospID: HospId
        },
        false
    );
    HospId = defHosp;
}

