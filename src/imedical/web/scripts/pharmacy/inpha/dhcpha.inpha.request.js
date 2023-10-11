/**
 * ģ��:     ��ҩ����
 * ��д����: 2018-07-02
 * ��д��:   yunhaibao
 * ����:     ��ҩ����������Ȼ�ǰ��˱���
 *           2023-02-20, �����б���û����ͳһ���, ��鿴HISV8.5.2��ʿվ�����б����˵��(����������)
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var PatNoLen = DHCPHA_STORE.Constant.PatNoLen;
var DefPhaLocInfo = tkMakeServerCall('web.DHCSTKUTIL', 'GetDefaultPhaLoc', SessionLoc);
var Loaded = ''; // �״μ���Ϊ��,����Ĭ��ҩ��
var DefPhaLocArr = DefPhaLocInfo.split('^');
var WinReason = '';
var AutoQueryTimes = 0;
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
                // ���ǼǺŲ�ѯ�ԵǼǺ�Ϊ׼
                ClearPatientTree();
                // �޸Ĳ�������
                Query();
            }
        }
    });
    $('#btnDirReq').on('click', RequestQuery);
    $('#btnDefaultLoc').on('click', SetDefaultLoc);
    $('#btnFind').on('click', Query);
    $('#btnSave').on('click', SaveHandler);
    $('#btnSetReason').on('click', AddReasonForSelect);
    $('.dhcpha-win-mask').fadeOut();
});

function LoadPatInfo() {
    var patInfo = tkMakeServerCall('web.DHCINPHA.Request', 'PatInfo', LoadAdmId);
    $('#txtPatNo').val(patInfo.split('^')[0] || '');
    $('#txtPatName').val(patInfo.split('^')[1] || '');
}

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
            },
            onSelect: function () {
                Query();
            }
        }
    );

    // ������ҩԭ��
    DHCPHA_HUI_COM.ComboBox.Init(
        {
            Id: 'cmbReason',
            Type: 'ReqRetReason'
        },
        {
            defaultFilter: 4,
            mode: 'local',
            width: 277,
            onLoadSuccess: function () {},
            onSelect: function () {
                //AddReasonForSelect();
            },
            onShowPanel: function () {
                $(this).combobox('clear');
            }
        }
    );
}

function InitGridDict() {
    var retReaData = $.cm(
        {
            ClassName: 'web.DHCINPHA.Request',
            QueryName: 'BLCReasonForRefund',
            hospId: HospId,
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

/**
 * �����б�, ��ѡ����ȡ����ѡʱ
 */
function patientTreeCheckChangeHandle() {
    LoadAdmId = EpisodeIDStr;
    $('#txtPatNo').val('');
    $('#txtPatName').val('');
    Query();
}
function patientTreeLoadSuccessCallBack() {
    if (AutoQueryTimes > 1) {
        return;
    }
    AutoQueryTimes++;
    Query();
}
function ClearPatientTree() {
    if ($('#patientTree').tree('getSelected') !== null) {
        $('#patientTree').tree('select', $('#patientTree').tree('getSelected'));
        EpisodeIDStr = '';
    }
}
function GetPatientTreeSelectedAdm() {
    if ($('#patientTree').tree('getSelected') === null) {
        return '';
    }
    return EpisodeIDStr;
}
// �ѷ�ҩ��Ϣ
function InitGridDisped() {
    var columns = [
        [
            {
                field: 'gridRequestSelect',
                checkbox: true
            },
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
                width: 250
            },
            {
                field: 'canRetQty',
                title: '��������',
                width: 70,
                align: 'right'
            },
            {
                field: 'reqQty',
                title: '<span style="color:red">*</span>' + $g('��������'), // ��Һ�������ҩ���ɱ༭
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
                title: '������ҩԭ��',
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
                width: 150,
                align: 'left'
            },
            {
                field: 'reqHistory',
                title: '���μ�¼',
                width: 120,
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
                width: 70,
                hidden: true
            },
            {
                field: 'patLevel',
                title: '���˼���',
                width: 70,
                hidden: true
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
            },
            {
                field: 'patNo',
                title: '�ǼǺ�',
                width: 100
            },
            {
                field: 'patName',
                title: '����',
                width: 100
            }
        ]
    ];
    var dataGridOption = {
        url: null,
        fit: true,
        border: false,
        singleSelect: true,
        checkOnSelect: false,
        selectOnCheck: false,
        columns: columns,
        pageSize: 1000,
        pageList: [1000],
        pagination: false,
        toolbar: '#gridDispedBar',
        onClickRow: function (rowIndex, rowData) {
            if (rowData.canRetFlag == 'N') {
                $(this).datagrid('cancelEdit', rowIndex);
                $(this).datagrid('options').editIndex = undefined;
                return;
            }
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'reqReasonId'
            });
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
        onSelect: function (rowIndex, rowData) {
            var $grid = $(this);
            if ($grid.datagrid('options').checking == true) {
                return;
            }
            $grid.datagrid('options').checking = true;
            $('#gridDisped').prev().find('.datagrid-row').removeClass('datagrid-row-selected');
            $grid.datagrid('selectRow', rowIndex);
            $grid.datagrid('options').checking = '';
        },
        onUnselect: function (rowIndex, rowData) {
            // �˴���Ҫ����unselectAll,��������޵ݹ�
            $(this).datagrid('unselectAll');
        },
        onCheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            DHCPHA_HUI_COM.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridDisped',
                Field: 'mDspId',
                Check: true,
                Value: rowData.mDspId
            });
            $(this).datagrid('options').checking = '';
        },
        onUncheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            DHCPHA_HUI_COM.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridDisped',
                Field: 'mDspId',
                Check: false,
                Value: rowData.mDspId
            });
            $(this).datagrid('options').checking = '';
        },
        onLoadSuccess: function () {
            var $grid = $(this);
            $grid.datagrid('options').checking = '';
            $grid.datagrid('uncheckAll');
            $grid.datagrid('scrollTo', 0);
            UnBindChk();
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridDisped', dataGridOption);
}
function UnBindChk() {
    var hasDisable = false;
    var rows = $('#gridDisped').datagrid('getRows');
    $.each(rows, function (index, row) {
        var canRetFlag = row.canRetFlag;
        if (canRetFlag != 'Y') {
            //$(".datagrid-row[datagrid-row-index=" + index + "] .datagrid-cell-check")
            // ͨ���Ƴ���ʽ,ʹselectoncheck���¼���������
            var $row = $('#gridDisped')
                .prev()
                .find('.datagrid-row[datagrid-row-index=' + index + ']');
            $row.removeClass('datagrid-row-selected datagrid-row-checked');
            var $chk = $row.find("input:checkbox[name='gridRequestSelect']")[0];
            $chk.disabled = true;
            $chk.checked = false;
            hasDisable = true;
            //$chk.style = 'display:none';
        }
    });
    $('#gridDisped').datagrid('getPanel').find('.datagrid-header-row input:checkbox')[0].disabled = hasDisable;
}
// ��ѯ
function Query() {
    var admId = EpisodeIDStr;
    var patNo = $('#txtPatNo').val();
    if (admId === '' && patNo === '') {
        $.messager.popover({
            msg: '����ѡ�����б��¼��ǼǺ��ٲ�ѯ',
            type: 'info'
        });
        return;
    }
    var recLocId = $('#cmbPhaLoc').combobox('getValue');
    var params = patNo + '^' + admId + '^' + recLocId + '^' + SessionLoc;
    $('#gridDisped').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCINPHA.Request',
            QueryName: 'QueryDisped',
            inputStr: params,
            rows: 99999
        }
    });
}

function RequestQuery() {
    var lnk = 'dhcpha.inpha.hisui.queryretrequest.csp?EpisodeID=' + LoadAdmId;
    var winRadio = 85;
    var winWidth = $('body').width() * 0.85;
    if (winWidth < 1280) {
        var winRadio = 100;
    }
    websys_createWindow(lnk, '��ҩ�����ѯ', 'height=' + winRadio + '%,width=' + winRadio + '%,menubar=no,status=no,toolbar=no,resizable=yes');
}

//����
function ClearClick() {}

function SaveHandler() {
    WinReason = '';
    $('#gridDisped').datagrid('endEditing');
    if ($('#gridDisped').datagrid('options').editIndex >= 0) {
        $.messager.popover({
            msg: '������ҩ�����Ƿ���ȷ',
            type: 'alert'
        });
        return;
    }
    if (CheckNeedReason() === true) {
        ReqReasonWindow(Save);
    } else {
        Save();
    }
}
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
            $.messager.alert('��ʾ', $g('���ɳɹ�') + '</br>' + saveRetArr[1], 'info');
            Query();
        } else {
            $.messager.alert('��ʾ', saveRetArr[2], 'warning');
        }
    }
}
// ��ȡ��Ч��¼
function GetSaveParams() {
    $('#gridDisped').datagrid('endEditing');
    var gridChked = $('#gridDisped').datagrid('getChecked');
    var gridChkedLen = gridChked.length;
    if (gridChkedLen == 0) {
        $.messager.popover({
            msg: '���ȹ�ѡ��Ҫ����ļ�¼',
            type: 'alert'
        });
        return '';
    }

    var mDspArr = [];
    var reasonObj = {};
    var paramsStr = '';
    var lastRecLocId = '';

    for (var i = 0; i < gridChkedLen; i++) {
        var rowData = gridChked[i];
        var needGrpRet = rowData.needGrpRet;
        var mDspId = rowData.mDspId;
        var reqReasonId = rowData.reqReasonId || '';

        // ������
        if (needGrpRet == 'Y') {
            var mDspIdS = 'M' + mDspId;
            if (mDspArr.indexOf(mDspIdS) >= 0) {
                reqReasonId = reasonObj[mDspIdS];
            }
            if (reqReasonId === '') {
                reqReasonId = WinReason;
            }
            if (mDspArr.indexOf(mDspIdS) < 0 && reqReasonId != '') {
                mDspArr.push(mDspIdS);
                reasonObj[mDspIdS] = reqReasonId;
            }
        } else {
            if (reqReasonId === '') {
                reqReasonId = WinReason;
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
        $.messager.popover({
            msg: '�޿�����������',
            type: 'alert'
        });
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
    var confirmText = $g('ȷ�Ͻ�') + PhaLocDesc + $g('���ó�Ĭ�Ͽ�����') + '?';
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
function ReqReasonWindow(callBack) {
    WinReason = '';
    var winDivId = 'ReqReasonWindowDiv';
    var winDiv = '<div id="' + winDivId + '" style="padding:10px"><div id="gridReqReason"></div></div>';
    $('body').append(winDiv);
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCINPHA.Request',
            QueryName: 'BLCReasonForRefund',
            hospId: HospId
        },
        border: false,
        fitColumns: true,
        singleSelect: true,
        nowrap: false,
        striped: false,
        pagination: false,
        rownumbers: false,
        columns: [
            [
                {
                    field: 'RowId',
                    title: 'RowId',
                    width: 80,
                    hidden: true
                },
                {
                    field: 'Description',
                    title: '����ԭ��',
                    width: 300,
                    align: 'left'
                }
            ]
        ],
        onClickRow: function (index, rowData) {
            WinReason = rowData.RowId;
            callBack();
            $('#ReqReasonWindowDiv').window('close');
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridReqReason', dataGridOption);
    $('#ReqReasonWindowDiv').window({
        title: 'ѡ����ҩ����ԭ��',
        collapsible: false,
        iconCls: 'icon-w-list',
        border: false,
        closed: true,
        modal: true,
        width: 600,
        height: 400,
        maximizable: false,
        onClose: function () {
            $('#ReqReasonWindowDiv').window('destroy');
        }
    });
    $('#ReqReasonWindowDiv .datagrid-header').css('display', 'none');
    $("#ReqReasonWindowDiv [class='panel datagrid']").css('border', '#cccccc solid 1px');
    $('#ReqReasonWindowDiv').window('open');
}

function CheckNeedReason() {
    var ret = false;
    $('#gridDisped').datagrid('endEditing');
    var gridChked = $('#gridDisped').datagrid('getChecked');
    var gridChkedLen = gridChked.length;
    var mDspArr = [];
    for (var i = 0; i < gridChkedLen; i++) {
        var rowData = gridChked[i];
        var needGrpRet = rowData.needGrpRet;
        var mDspId = rowData.mDspId;
        var reqReasonId = rowData.reqReasonId || '';
        if (needGrpRet === 'Y' && mDspArr.indexOf(mDspId) >= 0) {
            continue;
        }
        if (reqReasonId === '') {
            return true;
        }
        mDspArr.push(mDspId);
    }
    return ret;
}

/* ����ѡ�����ݸ�ֵ������ҩԭ�� */
function AddReasonForSelect() {
    var ret = false;
    $('#gridDisped').datagrid('endEditing');
    var gridChked = $('#gridDisped').datagrid('getChecked');
    var gridChkedLen = gridChked.length;
    if (gridChkedLen == 0) {
        $.messager.popover({
            msg: '���ȹ�ѡ��¼',
            type: 'info'
        });
        return;
    }
    var selReasonId = $('#cmbReason').combobox('getValue');
    var selReasonDesc = $('#cmbReason').combobox('getText');
    var mDspArr = [];
    for (var i = 0; i < gridChkedLen; i++) {
        var rowData = gridChked[i];
        var needGrpRet = rowData.needGrpRet;
        var mDspId = rowData.mDspId;
        if (needGrpRet === 'Y' && mDspArr.indexOf(mDspId) >= 0) {
            continue;
        }
        var rowIndex = $('#gridDisped').datagrid('getRowIndex', rowData);
        /* ����¼��������ҩԭ�� */
        $('#gridDisped').datagrid('updateRow', {
            index: rowIndex,
            row: {
                reqReasonDesc: selReasonDesc,
                reqReasonId: selReasonId
            }
        });
        mDspArr.push(mDspId);
    }
    return ret;
}
