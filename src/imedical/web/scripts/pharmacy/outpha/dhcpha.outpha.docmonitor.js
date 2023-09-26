/**
 * ģ��:     ҩʦ��˲�ѯ
 * ��д����: 2018-05-22
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var PatNoLen = DHCPHA_STORE.Constant.PatNoLen;
$(function () {
    InitGridPhaOrd();
    InitGridReason();
    $('#dateStart').datebox('setValue', DHCPHA_TOOLS.Today());
    $('#dateEnd').datebox('setValue', DHCPHA_TOOLS.Today());
    $('#txtPatNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var patNo = $.trim($('#txtPatNo').val());
            if (patNo != '') {
                var newPatNo = DHCPHA_TOOLS.PadZero(patNo, PatNoLen);
                $(this).val(newPatNo);
                Query();
            }
        }
    });
    $('#btnFind').on('click', Query);
    $('#btnAgree').on('click', Agree);
    $('#btnAppeal').on('click', Appeal);
    $('#txtPatNo').val(LoadPatNo);
    if (LoadIfDoctor != 'Y') {
        $('#layoutNorth').panel('close');
        $('#layoutCenter').panel('maximize');
        $('#layoutCenter').panel('setTitle', '��ҩ��˲�ͨ��');
        setTimeout(Query, 300);
    } else {
        setTimeout(Query, 300);
    }
});

// ҽ�������ϸ�б�
function InitGridPhaOrd() {
    var columns = [
        [
            { field: 'phaOrdId', title: '���Id', width: 100, hidden: true },
            { field: 'patNo', title: '�ǼǺ�', width: 100 },
            { field: 'patName', title: '����', width: 80 },
            { field: 'incDesc', title: 'ҩƷ', width: 250 },
            { field: 'dosage', title: '����', width: 75 },
            { field: 'freqDesc', title: 'Ƶ��', width: 75 },
            { field: 'instrucDesc', title: '�÷�', width: 75 },
            { field: 'qtyDesc', title: '����', width: 100, halign: 'left', align: 'left' },
            { field: 'reasonDesc', title: '�ܾ�ԭ��', width: 200 },
            {
                field: 'phNotes',
                title: 'ҩʦ��ע',
                width: 200,
                formatter: function (value, row, index) {
                    return '<div style="width=200px;word-break:break-all;word-wrap:break-word;white-space:pre-wrap;">' + value + '</div>';
                }
            },
            { field: 'userName', title: '�����', width: 80 },
            { field: 'opDateTime', title: '���ʱ��', width: 100 },
            { field: 'passWay', title: '��˷�ʽ', width: 85 },
            { field: 'doseDate', title: '��ҩ����', width: 100, halign: 'left', hidden: true },
            { field: 'doctorName', title: 'ҽ��', width: 80, hidden: true },
            { field: 'orderStoped', title: 'ҽ��ȫ������', width: 80, hidden: false }
        ]
    ];
    var dataGridOption = {
        url: 'DHCST.METHOD.BROKER.csp?ClassName=web.DHCOUTPHA.DocMonitor&MethodName=JsGetRefuseMonitor',
        queryParams: {},
        toolbar: LoadIfDoctor == 'Y' ? '#gridPhaOrdBar' : '',
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers: false,
        columns: columns,
        nowrap: false,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        onSelect: function (rowIndex, rowData) {
            DHCPHA_HUI_COM.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridPhaOrd',
                Field: 'phaOrdId',
                Check: true,
                Value: rowData.phaOrdId,
                Type: 'Select'
            });
        },
        onUnselect: function (rowIndex, rowData) {
            $(this).datagrid('unselectAll');
        },
        onLoadSuccess: function () {
            DHCPHA_HUI_COM.Grid.MergeCell({
                GridId: 'gridPhaOrd',
                Field: 'phaOrdId',
                MergeFields: ['patNo', 'patName', 'userName', 'opDateTime', 'passWay', 'doseDate', 'phNotes']
            });
            DHCPHA_HUI_COM.Grid.CellTip({ TipArr: ['phNotes'] });
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridPhaOrd', dataGridOption);
}

// ԭ���б�
function InitGridReason() {
    var columns = [
        [
            { field: 'incDesc', title: 'ҩƷ', width: 250, halign: 'center' },
            { field: 'reasonDesc', title: '���ԭ��', width: 250, halign: 'center' }
        ]
    ];
    var dataGridOption = {
        url: '',
        fit: true,
        fitColumns: true,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false
    };
    DHCPHA_HUI_COM.Grid.Init('gridReason', dataGridOption);
}
// ��ȡ����
function QueryParams() {
    var stDate = $('#dateStart').datebox('getValue');
    var edDate = $('#dateEnd').datebox('getValue');
    var recLocId = '';
    var patNo = $('#txtPatNo').val();
    var doctorId = SessionUser;
    if (LoadIfDoctor != 'Y') {
        doctorId = '';
    }
    var admId = typeof LoadAdmId == 'undefined' ? '' : LoadAdmId;
    if (patNo != '') {
        admId = '';
    }
    return stDate + '^' + edDate + '^' + recLocId + '^' + patNo + '^' + doctorId + '^' + admId;
}
// ��ѯ
function Query() {
    var params = QueryParams();
    $('#gridPhaOrd').datagrid({
        queryParams: {
            inputStr: params
        }
    });
}
// ��ȡѡ�е��м�¼
function GetGridSelected() {
    var gridSelected = $('#gridPhaOrd').datagrid('getSelected');
    if (gridSelected == null) {
        $.messager.alert('��ʾ', '��ѡ���¼', 'warning');
        return '';
    }
    return gridSelected.phaOrdId;
}
// ͬ��
function Agree() {
    var phaOrdId = GetGridSelected();
    if (phaOrdId == '') {
        return;
    }
    // �ѷ�ҩ���ܲ���
    var agreeRet = tkMakeServerCall('web.DHCOUTPHA.DocMonitor', 'Agree', phaOrdId, SessionUser, SessionLoc);
    var agreeArr = agreeRet.split('^');
    if (agreeArr[0] < 0) {
        $.messager.alert('��ʾ', retArr[1], 'warning');
        return;
    } else {
        if (top && top.HideExecMsgWin) {
            top.HideExecMsgWin();
        }
        $('#gridPhaOrd').datagrid('reload');
    }
}
// ���ߴ���
function Appeal() {
    var gridSelections = $('#gridPhaOrd').datagrid('getSelections');
    var selLen = gridSelections.length;
    if (selLen == 0) {
        $.messager.alert('��ʾ', '��ѡ���¼', 'warning');
        return '';
    }
    var reasonArr = [];
    var phNotes = '';
    for (var selI = 0; selI < selLen; selI++) {
        var selData = gridSelections[selI];
        if (selData.orderStoped === 'Y') {
            $.messager.alert('��ʾ', 'ҽ����ȫ�����ϻ�ȡ��,�޷�����', 'warning');
            return;
        }
        var incDesc = selData.incDesc;
        var reasonDesc = selData.reasonDesc;
        var phNotes = selData.phNotes;
        var reasonObj = { incDesc: incDesc, reasonDesc: reasonDesc };
        reasonArr.push(reasonObj);
    }
    $('#gridReason').datagrid('loadData', reasonArr);
    $('#txtNotes').text(phNotes);
    $('#appealWin').dialog('open');
    $('#txtAppeal').val('');
    $('#txtAppeal').focus();
}

function SaveAppeal() {
    var phaOrdId = GetGridSelected();
    if (phaOrdId == '') {
        return;
    }
    var appealText = $('#txtAppeal').val();
    if (appealText == '') {
        $.messager.alert('��ʾ', '����д��������', 'warning');
        return;
    }
    $('#appealWin').dialog('close');
    var appealRet = tkMakeServerCall('web.DHCOUTPHA.DocMonitor', 'Appeal', phaOrdId, appealText, SessionUser, SessionLoc);
    var appealArr = appealRet.split('^');
    if (appealArr[0] < 0) {
        $.messager.alert('��ʾ', appealArr[1], 'warning');
        return;
    } else {
        if (top && top.HideExecMsgWin) {
            top.HideExecMsgWin();
        }
        $('#gridPhaOrd').datagrid('reload');
    }
}
