/**
 * ģ��:     ��ҩ����
 * ��д����: 2018-07-02
 * ��д��:   yunhaibao
 * ����:     ��ҩ����������Ȼ�ǰ��˱���
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var PatNoLen = DHCPHA_STORE.Constant.PatNoLen;
var DefPhaLocInfo = tkMakeServerCall('web.DHCSTKUTIL', 'GetDefaultPhaLoc', SessionLoc);
var Loaded = ''; // �״μ���Ϊ��,����Ĭ��ҩ��
var DefPhaLocArr = DefPhaLocInfo.split('^');
DefPhaLocId = DefPhaLocArr[0] || '';
DefPhaLocDesc = DefPhaLocArr[1] || '';
var GridCmbRetReason;
$(function () {
    InitExtend();
    InitDict();
    InitGridDict();
    InitGridDisped();
    $('#txtPatNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var patNo = $.trim($('#txtPatNo').val());
            if (patNo != '') {
                var newPatNo = DHCPHA_TOOLS.PadZero(patNo, PatNoLen);
                $(this).val(newPatNo);
                // �޸Ĳ�������
                Query();
            }
        }
    });
    $('#btnDirReq').on('click', RequestQuery);
    $('#btnDefaultLoc').on('click', SetDefaultLoc);
    $('#btnFind').on('click', Query);
    if (LoadAdmId != '') {
        var patInfo = tkMakeServerCall('web.DHCINPHA.Request', 'PatInfo', LoadAdmId);
        $('#txtPatNo').val(patInfo.split('^')[0] || '');
        $('#txtPatName').val(patInfo.split('^')[1] || '');
    }
    $('#btnSave').on('click', Save);
    setTimeout(Query, 500);
});

function InitDict() {
    // ����
    DHCPHA_HUI_COM.ComboBox.Init(
        {
            Id: 'cmbPhaLoc',
            Type: 'PhaLoc'
        },
        {
            defaultFilter: 4,
            mode: 'local',
            onLoadSuccess: function () {
                if (Loaded == '') {
                    $('#cmbPhaLoc').combobox('setValue', DefPhaLocId);
                    Loaded = 1;
                }
            }
        }
    );
}

function InitGridDict() {
    var retReaData = $.cm(
        {
            ClassName: 'web.DHCINPHA.Request',
            QueryName: 'BLCReasonForRefund',
			hospId:HospId,
            ResultSetType: 'array'
        },
        false
    );
    GridCmbRetReason = DHCPHA_HUI_COM.GridComboBox.Init(
        {
            data: {
                data: retReaData
            }
        },
        {
            editable: true,
            mode: 'local'
        }
    );
}
// �ѷ�ҩ��Ϣ
function InitGridDisped() {
    var columns = [
        [
            {
                field: 'recLocId',
                title: '��ҩ����Id',
                width: 120,
                hidden: true
            },
            {
                field: 'recLocDesc',
                title: '��ҩ����',
                width: 120
            },
            {
                field: 'oeoriSign',
                title: '��',
                width: 35,
                align: 'center',
                formatter: DHCPHA_HUI_COM.Grid.Formatter.OeoriSign
            },
            {
                field: 'incCode',
                title: 'ҩƷ����',
                width: 100,
                hidden: true
            },
            {
                field: 'incDesc',
                title: 'ҩƷ����',
                width: 200
            },
            {
                field: 'canRetQty',
                title: '��������',
                width: 70,
                align: 'right'
            },
            {
                field: 'reqQty',
                title: '<span style="color:red">*</span>��������', // ��Һ�������ҩ���ɱ༭
                width: 80,
                align: 'right',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                        validType: 'CheckNumber'
                    }
                }
            },
            {
                field: 'reqReasonId',
                title: '<span style="color:red">*</span>������ҩԭ��',
                width: 160,
                editor: GridCmbRetReason,
                descField: 'reqReasonDesc',
                formatter: function (value, row, index) {
                    return row.reqReasonDesc;
                }
            },
            {
                field: 'reqReasonDesc',
                title: '��ҩԭ������',
                width: 160,
                hidden: true
            },
            {
                field: 'dspQty',
                title: '��ҩ����',
                width: 70,
                align: 'right'
            },
            {
                field: 'bUomDesc',
                title: '��λ',
                width: 60
            },
            {
                field: 'doseDateTime',
                title: '��ҩʱ��',
                width: 100,
                align: 'left'
            },
            {
                field: 'reqHistory',
                title: '���μ�¼',
                width: 100,
                align: 'left'
            },
            {
                field: 'docLocDesc',
                title: '��������',
                width: 140
            },
            {
                field: 'encryptLevel',
                title: '�����ܼ�',
                width: 70
            },
            {
                field: 'patLevel',
                title: '���˼���',
                width: 70
            },
            {
                field: 'dspId',
                title: '�����Id',
                width: 60,
                hidden: true
            },
            {
                field: 'wardLocId',
                title: '��������Id',
                width: 120,
                hidden: true
            },
            {
                field: 'phacLbRowId',
                title: '��ҩ���Id',
                width: 60,
                hidden: true
            },
            {
                field: 'dspSubRowId',
                title: '����ӱ�Id',
                width: 60,
                hidden: true
            },
            {
                field: 'inclb',
                title: '�������ο����Id',
                width: 60,
                hidden: true
            },
            {
                field: 'cantretreason',
                title: '������ҩԭ��',
                width: 100,
                align: 'left'
            },
            {
                field: 'cyFlag',
                title: '��ҩ������־',
                width: 60,
                hidden: true
            },
            {
                field: 'prescNo',
                title: '������',
                width: 125,
                hidden: false
            },
            {
                field: 'needGrpRet',
                title: '������ҩ',
                width: 60,
                hidden: true
            },
            {
                field: 'canRetFlag',
                title: '�Ƿ������',
                width: 60,
                hidden: true
            }, // ��ҩ����Һ
            {
                field: 'mDspId',
                title: '�����Id',
                width: 60,
                hidden: true
            },
            {
                field: 'firstRow',
                title: '��һ��',
                width: 60,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: null,
        fit: true,
        border: false,
        singleSelect: true,
        columns: columns,
        pageSize: 1000,
        pageList: [1000],
        pagination: false,
        toolbar: '#gridDispedBar',
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'reqReasonId'
            });
            if (rowData.canRetFlag == 'N') {
                $(this).datagrid('cancelEdit', rowIndex);
                $(this).datagrid('options').editIndex = undefined;
                return;
            }
            // ������,�����޸�����,��һ����¼��ѡ��ԭ��
            if (rowData.needGrpRet == 'Y') {
                var $ed = $(this).datagrid('getEditor', {
                    index: rowIndex,
                    field: 'reqQty'
                });
                if ($ed.target) {
                    $ed.target.attr('disabled', true);
                }
                if (rowData.firstRow != 'Y') {
                    $(this).datagrid('cancelEdit', rowIndex);
                    $(this).datagrid('options').editIndex = undefined;
                }
            }
        },
        onSelect: function (rowIndex, rowData) {},
        onUnselect: function (rowIndex, rowData) {
			// �˴���Ҫ����unselectAll,��������޵ݹ�
            // $(this).datagrid('unselectAll');
        },
        onLoadSuccess: function () {}
    };
    DHCPHA_HUI_COM.Grid.Init('gridDisped', dataGridOption);
}

// ��ѯ
function Query() {
    var admId = LoadAdmId;
    var patNo = $('#txtPatNo').val();
    var recLocId = $('#cmbPhaLoc').combobox('getValue');
    var params = patNo + '^' + admId + '^' + recLocId + '^' + SessionLoc;
    $('#gridDisped').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCINPHA.Request',
            QueryName: 'QueryDisped',
            inputStr: params
        }
    });
}

function RequestQuery() {
    var lnk = 'dhcpha.inpha.hisui.queryretrequest.csp?EpisodeID=' + LoadAdmId;
    websys_createWindow(lnk, '��ҩ�����ѯ', 'height=85%,width=85%,menubar=no,status=no,toolbar=no,resizable=yes');
}

//����
function ClearClick() {}
// ����
function Save() {
    var paramsStr = GetSaveParams();
    if (paramsStr == '') {
        return;
    }
    var saveRet = tkMakeServerCall('web.DHCINPHA.Request', 'SaveMulti', paramsStr, SessionUser, SessionLoc);
    var saveRetArr = saveRet.split('^');
    if (saveRetArr[0] != '') {
        $.messager.alert('��ʾ', saveRetArr[1], 'warning');
        return;
    } else {
        if (saveRetArr[1] != '') {
            $.messager.alert('��ʾ', '���ɳɹ�' + '</br>' + saveRetArr[1], 'info');
            Query();
        } else {
            $.messager.alert('��ʾ', saveRetArr[2], 'warning');
        }
    }
}
// ��ȡ��Ч��¼
function GetSaveParams() {
    $('#gridDisped').datagrid('endEditing');
    var gridChanges = $('#gridDisped').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert('��ʾ', 'û����Ҫ���������', 'warning');
        return '';
    }
    var mDspArr = [];
    var reasonObj = {};
    var paramsStr = '';
    var lastRecLocId = '';
    var gridRows = $('#gridDisped').datagrid('getRows');
    var rowsLen = gridRows.length;
    for (var i = 0; i < rowsLen; i++) {
        var rowData = gridRows[i];
        var needGrpRet = rowData.needGrpRet;
        var mDspId = rowData.mDspId;
        var mDspIdS = 'M' + mDspId;
        var reqReasonId = rowData.reqReasonId || '';
        if (needGrpRet == 'Y') {
            if (reqReasonId == '') {
                if (mDspArr.indexOf(mDspIdS) >= 0) {
                    reqReasonId = reasonObj[mDspIdS];
                }
            }
            if (mDspArr.indexOf(mDspId) < 0 && reqReasonId != '') {
                mDspArr.push(mDspIdS);
                reasonObj[mDspIdS] = reqReasonId;
            }
        }
        if (reqReasonId == '') {
            continue;
        }
        var reqQty = rowData.reqQty || '';
        if (reqQty == '' || reqQty == 0) {
            continue;
        }
        var dspQty = rowData.dspQty || '';
        var prescNo = rowData.prescNo;
        var recLocId = rowData.recLocId || '';
        var phacLbRowId = rowData.phacLbRowId || '';
        var cantretreason = rowData.cantretreason || '';
        var dspId = rowData.dspId || '';
        if (cantretreason != '') {
            $.messager.alert('��ʾ', '��' + (i + 1) + '��ҩƷά���˲�����ҩԭ��,������ҩ����', 'warning');
            return '';
        }
        var chkRet = tkMakeServerCall('web.DHCINPHA.Request', 'CheckBeforeSave', phacLbRowId, reqQty);
        if (chkRet.split('^')[0] < 0) {
            $.messager.alert('��ʾ', rowData.incDesc + ':' + chkRet.split('^')[1], 'warning');
            return '';
        }
        if (lastRecLocId != '' && lastRecLocId != recLocId) {
            $.messager.alert('��ʾ', '��ѡ����ͬ��ҩ����������ҩ����', 'warning');
            return '';
        }
        lastRecLocId = recLocId;
        var iParams = dspId + '^' + reqQty + '^' + reqReasonId + '^' + phacLbRowId;
        paramsStr = paramsStr == '' ? iParams : paramsStr + ',' + iParams;
    }
    if (paramsStr == '') {
        $.messager.alert('��ʾ', '�޿�����������', 'warning');
        return '';
    }
    return paramsStr;
}

// ����Ĭ�Ͽ��ҹ���
function SetDefaultLoc() {
    var PhaLoc = $('#cmbPhaLoc').combobox('getValue') || '';
    var PhaLocDesc = $('#cmbPhaLoc').combobox('getText') || '';
    if (PhaLoc == '') {
        //$.messager.alert("��ʾ", "����ѡ��ҩ����", "warning");
        //return;
    }
    if (SessionLoc == '') {
        return;
    }
    var confirmText = 'ȷ�Ͻ� ' + PhaLocDesc + ' ���ó�Ĭ�Ͽ�����?';
    if (PhaLoc == '') {
        confirmText = 'ȷ��Ĭ�Ͽ�������Ϊ����?';
    }
    $.messager.confirm('ȷ����ʾ', confirmText, function (r) {
        if (r) {
            var saveRet = tkMakeServerCall('web.DHCSTRETREQUEST', 'SetDefaultPhaLoc', PhaLoc, SessionLoc);
            var saveArr = saveRet.split('^');
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal == 0) {
                $.messager.alert('��ʾ', '���óɹ�', 'info');
                return;
            }
        }
    });
}

// ������ʹ����չ
function InitExtend() {
    $.extend($.fn.validatebox.defaults.rules, {
        // �Ƿ�����
        CheckNumber: {
            validator: function (value, param) {
                var regTxt = /^[0-9]+\.?[0-9]{0,20}$/; // 20λ,��Ȼ������֧���벻��ȥ
                if (regTxt.test(value) == false) {
                    return false;
                } else {
                    // ������getSelected
                    var curRow = $("[class='datagrid-editable-input validatebox-text']").parents('.datagrid-row').attr('datagrid-row-index') || '';
                    if (curRow == '') {
                        return true;
                    }
                    var rowData = $('#gridDisped').datagrid('getRows')[curRow];
                    var cyFlag = rowData.cyFlag;
                    var canRetQty = rowData.canRetQty;
                    if (cyFlag == 'Y' && 1 * value != 1 * canRetQty) {
                        return false;
                    }
                    if (1 * value > 1 * canRetQty) {
                        return false;
                    }
                    // �ж��ܷ�¼��С��
                    var dspQty = rowData.dspQty;
                    if (value.toString().indexOf('.') >= 0) {
                        if (dspQty.toString().indexOf('.') < 0) {
                            $.messager.popover({
                                msg: '��������С��',
                                type: 'alert'
                            });
                            return false;
                        }
                    }
                    return true;
                }
            },
            message: '�������ܴ��ڿ�������,�ҵ���������ΪС��ʱ,������С��'
        }
    });
}
