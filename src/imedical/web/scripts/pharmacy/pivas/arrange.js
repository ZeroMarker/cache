/**
 * ģ��: 	 ��Һ������ҩͳ��
 * ��д����: 2018-04-08
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var PIVAS_ARRANGE = {
    Setting: $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Settings',
            MethodName: 'GetAppProp',
            userId: session['LOGON.USERID'],
            locId: session['LOGON.CTLOCID'],
            appCode: 'Arrange'
        },
        false
    )
};

$(function () {
    // $('.newScroll').mCustomScrollbar({
    //     theme: 'inset-2-dark',
    //     scrollInertia: 100
    // });
    $('#btnFind').parent().parent().css('box-shadow', 'rgb(238, 238, 238) 0px -5px 10px');

    PIVAS.Session.More(session['LOGON.CTLOCID']);
    InitDict();
    InitGridInc();
    $('#btnFind').on('click', Query);
    $('#btnPrint').on('click', Print);
    $('#btnGeneQR').on('click', GeneQR);
    $('#txtPogsNo').searchbox({
        searcher: function (value, name) {
            if (event.keyCode == 13) {
                Query();
                return;
            }
            var pivaLocId = $('#cmbPivaLoc').combobox('getValue');
            var psNumber = $('#cmbPivaStat').combobox('getValue');
            PIVAS.PogsNoWindow({
                TargetId: 'txtPogsNo',
                PivaLocId: pivaLocId,
                PsNumber: psNumber
            });
        }
    });
    $('#txtPatNo').on('keypress', function (event) {
        if (event.keyCode == '13') {
            var patNo = this.value;
            patNo = PIVAS.FmtPatNo(patNo);
            $(this).val(patNo);
            Query();
        }
    });
    InitPivasSettings();
    setTimeout(function () {
        var scrollWidth = PIVAS.GetScrollBarWidth();
        $('.js-pha-layout-fit')
            .layout('panel', 'west')
            .panel('resize', { width: $('.pha-con-table').outerWidth() + 12 + scrollWidth }); // 10(split���) + 2(border��Ⱥ�)
        $('.js-pha-layout-fit').layout('resize');
        $('.dhcpha-win-mask').hide();
    }, 100);
});

function InitDict() {
    var comboWidth = 220;
    // ��Һ����
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaLoc', Type: 'PivaLoc' },
        {
            panelHeight: 'auto',
            editable: false,
            onLoadSuccess: function () {
                var datas = $('#cmbPivaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPivaLoc').combobox('setValue', datas[i].RowId);
                        break;
                    }
                }
            },
            onSelect: function (data) {},
            width: comboWidth
        }
    );

    // ������
    PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, { width: comboWidth });
    // ����
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, { width: comboWidth });
    // ҽ�����ȼ�
    PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, { width: comboWidth });
    // ��������
    PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, { width: comboWidth });
    // ����
    PIVAS.ComboBox.Init({ Id: 'cmbBatNo', Type: 'Batch' }, { width: comboWidth, multiple: true });
    // ��Һ״̬
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaStat', Type: 'PIVAState' },
        {
            editable: false,
            onLoadSuccess: function (data) {
                var Ps30Single = PIVAS_ARRANGE.Setting.Single;
                if (Ps30Single == 'Y') {
                    $(this).combobox('disable');
                }
                for (var i = 0; i < data.length; i++) {
                    var rowId = data[i].RowId;
                    if (rowId == '30') {
                        $(this).combobox('setValue', rowId);
                    }
                }
            },
            width: comboWidth,
            loadFilter: function (data) {
                var sliceNum = 0;
                for (var i = 0; i < data.length; i++) {
                    var iData = data[i];
                    if (parseInt(iData.RowId) < 30) {
                        sliceNum++;
                    }
                }
                data.splice(0, sliceNum);
                return data;
            }
        }
    );
    // �÷�
    PIVAS.ComboBox.Init({ Id: 'cmbInstruc', Type: 'Instruc' }, { width: comboWidth });
    // �������
    PIVAS.ComboBox.Init({ Id: 'cmbPassResult', Type: 'PassResult' }, { editable: false, width: comboWidth, panelHeight: 'auto' });
    $('#cmbPassResult').combobox('setValue', '');
    // ���
    PIVAS.ComboBox.Init({ Id: 'cmbPack', Type: 'PackType' }, { width: comboWidth, panelHeight: 'auto' });
    // �Ƿ�����ҩ
    PIVAS.ComboBox.Init({ Id: 'cmbArranged', Type: 'YesOrNo' }, { editable: false, width: comboWidth, panelHeight: 'auto' });
    $('#cmbArranged').combobox('setValue', 'N');
}
/// ��ʼ��ҩƷ��Ϣ���
function InitGridInc() {
    //����columns
    var columns = [
        [
            { field: 'incDesc', title: 'ҩƷ����', width: 300 },
            { field: 'incSpec', title: '���', width: 100 },
            { field: 'phManfDesc', title: '������ҵ', width: 130 },
            { field: 'qty', title: '����', width: 50 },
            { field: 'bUomDesc', title: '��λ', width: 50 },
            { field: 'stkBin', title: '��λ', width: 100 },
            { field: 'batNoQty', title: '����������', width: 200 },
            { field: 'pid', title: '���̺�', width: 200, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.Arrange',
            QueryName: 'QueryArrange'
        },
        fitColumns: true,
        rownumbers: false,
        columns: columns,
        singleSelect: true,
        striped: false,
        pageSize: 100,
        pageList: [100, 300, 500]
    };
    DHCPHA_HUI_COM.Grid.Init('gridInc', dataGridOption);
}
/// ��ѯ
function Query() {
    var params = GetParams();
    if (params == '') {
        return;
    }
    $('#gridInc').datagrid('query', { inputStr: params });
}

// ��ȡ����
function GetParams() {
    var paramsArr = [];
    var pivaLocId = $('#cmbPivaLoc').combobox('getValue'); // ��Һ����
    var dateOrdStart = $('#dateOrdStart').datebox('getValue'); // ��ʼ����
    var dateOrdEnd = $('#dateOrdEnd').datebox('getValue'); // ��ֹ����
    var locGrpId = $('#cmbLocGrp').combobox('getValue') || ''; // ������
    var wardId = $('#cmbWard').combobox('getValue') || ''; // ����
    var priority = $('#cmbPriority').combobox('getValue') || ''; // ҽ�����ȼ�
    var passResult = $('#cmbPassResult').combobox('getValue') || ''; // ҽ�����״̬
    var pivaStat = $('#cmbPivaStat').combobox('getValue') || ''; // ��Һ״̬
    var oeoreStat = ''; // ҽ��״̬-����
    var patNo = $.trim($('#txtPatNo').val()); // �ǼǺ�
    var pogsNo = $('#txtPogsNo').searchbox('getValue') || ''; // ����
    var prtPNo = ''; // ��ǩ���
    var batNoStr = $('#cmbBatNo').combobox('getValues') || ''; // ����
    var printStop = ''; // �Ƿ��Ѵ�ӡֹͣ��ǩ
    var barCode = ''; // �����
    var instruc = $('#cmbInstruc').combobox('getValue') || ''; // �÷�
    var freq = ''; // Ƶ��
    var datePrtStart = $('#datePrtStart').datebox('getValue'); // ��ǩ��ʼ����
    var datePrtEnd = $('#datePrtEnd').datebox('getValue'); // ��ǩ��ֹ����
    var incId = ''; // ҩƷ-����
    var pivaCat = ''; //; 	// ��Һ����-����
    var timePrtStart = $('#timePrtStart').timespinner('getValue'); // ��ǩ��ʼʱ��
    var timePrtEnd = $('#timePrtEnd').timespinner('getValue'); // ��ǩ����ʱ��
    var pivaRefuse = ''; // ��Һ�ܾ�
    var timeOrdStart = $('#timeOrdStart').timespinner('getValue'); // ��ҩ��ʼʱ��
    var timeOrdEnd = $('#timeOrdEnd').timespinner('getValue'); // ��ҩ����ʱ��
    var workTypeId = $('#cmbWorkType').combobox('getValue') || ''; // ��������
    var packFlag = $('#cmbPack').combobox('getValues') || ''; // �������
    var arranged = $('#cmbArranged').combobox('getValue') || ''; // �Ƿ�����ҩ
    var timeArrStart = $('#timeArrStart').timespinner('getValue'); // ��ҩ��ʼʱ��
    var timeArrEnd = $('#timeArrEnd').timespinner('getValue'); // ��ҩ����ʱ��
    paramsArr[0] = pivaLocId;
    paramsArr[1] = dateOrdStart;
    paramsArr[2] = dateOrdEnd;
    paramsArr[3] = wardId;
    paramsArr[4] = locGrpId;
    paramsArr[5] = priority;
    paramsArr[6] = passResult;
    paramsArr[7] = pivaStat;
    paramsArr[8] = oeoreStat;
    paramsArr[9] = batNoStr;
    paramsArr[10] = printStop;
    paramsArr[11] = barCode;
    paramsArr[12] = instruc;
    paramsArr[13] = freq;
    paramsArr[14] = incId;
    paramsArr[15] = datePrtStart;
    paramsArr[16] = datePrtEnd;
    paramsArr[17] = pivaCat;
    paramsArr[18] = timePrtStart;
    paramsArr[19] = timePrtEnd;
    paramsArr[20] = pogsNo;
    paramsArr[21] = pivaRefuse;
    paramsArr[22] = patNo;
    paramsArr[23] = prtPNo;
    paramsArr[24] = timeOrdStart;
    paramsArr[25] = timeOrdEnd;
    paramsArr[26] = workTypeId;
    paramsArr[27] = packFlag;
    paramsArr[28] = arranged;
    paramsArr[29] = timeArrStart;
    paramsArr[30] = timeArrEnd;
    return paramsArr.join('^');
}
// ��ӡ��ҩ��
function Print() {
    var gridRows = $('#gridInc').datagrid('getRows');
    if (gridRows == '') {
        $.messager.alert($g('��ʾ'), $g('����ϸ����'), 'warning');
        return;
    }
    var pid = gridRows[0].pid;
    if (pid == '') {
        $.messager.alert($g('��ʾ'), $g('��ȡ��������Id'), 'warning');
        return;
    }
    $.messager.confirm($g('ȷ�϶Ի���'), $g('ȷ����ӡ��'), function (r) {
        if (r) {
            var pivaLocId = $('#cmbPivaLoc').combobox('getValue');
            var arranged = $('#cmbArranged').combobox('getValue');
            var saveRet = tkMakeServerCall('web.DHCSTPIVAS.Arrange', 'SaveData', pid, SessionUser, pivaLocId, arranged);
            var saveArr = saveRet.split('^');
            if (saveArr[0] < 0) {
                $.messager.alert($g('��ʾ'), saveArr[1], 'warning');
                return;
            }
            var prtPid = saveRet;
            PIVASPRINT.Arrange('', '', prtPid);
            Query();
        }
    });
}
function GeneQR() {
    var gridRows = $('#gridInc').datagrid('getRows');
    if (gridRows == '') {
        $.messager.alert($g('��ʾ'), $g('����ϸ����'), 'warning');
        return;
    }
    var pid = gridRows[0].pid;
    if (pid == '') {
        $.messager.alert($g('��ʾ'), $g('��ȡ��������Id'), 'warning');
        return;
    }
    // ����������ʱGlobal, ���ݴ浽����ʱ����, pda��pc��������ͬ��ecp
    tkMakeServerCall('web.DHCSTPIVAS.Arrange', 'SetTmpData4Mob', pid);
    PIVAS.GeneQRCodeWindow({
        barCode: pid,
        onClose: function () {
            tkMakeServerCall('web.DHCSTPIVAS.Arrange', 'KillTmpData4Mob', pid);
        }
    });
}
// ��ʼ��Ĭ������
function InitPivasSettings() {
    var settingJson = PIVAS_ARRANGE.Setting;
    $('#dateOrdStart').datebox('setValue', settingJson.OrdStDate);
    $('#dateOrdEnd').datebox('setValue', settingJson.OrdEdDate);
    $('#datePrtStart').datebox('setValue', settingJson.PrtStDate);
    $('#datePrtEnd').datebox('setValue', settingJson.PrtEdDate);
}
