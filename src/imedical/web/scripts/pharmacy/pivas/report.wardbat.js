/**
 * ģ��:   ��Һ���Ĳ������ӵ�
 * ��д����: 2018-03-27
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
    PIVAS.Session.More(session['LOGON.CTLOCID']);
    InitDict();
    $('#btnFind').on('click', Query);
    // ���̵���
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
            var patNo = $('#txtPatNo').val();
            if (patNo == '') {
                return;
            }
            var patNo = PIVAS.PadZero(patNo, PIVAS.PatNoLength());
            $('#txtPatNo').val(patNo);
        }
    });
    InitPivasSettings();
    $('iframe').attr('src', PIVAS.RunQianBG);
    $('#tabsWardBat').tabs({
        onSelect: function (title) {
            // IE�л�Tab��Ҫ������
            $('#tabWardBatGrp').width('1000px');
            $('#tabWardBatTbl').width('1000px');
            $('#tabWardBatIncTbl').width('1000px');
            $('#tabWardBatOrdDetail').width('1000px');
        }
    });
    setTimeout(function () {
        var scrollWidth = PIVAS.GetScrollBarWidth();
        $('.js-pha-layout-fit')
            .layout('panel', 'west')
            .panel('resize', { width: $('.pha-con-table').outerWidth() + 12 + scrollWidth }); // 10(split���) + 2(border��Ⱥ�)
        $('.js-pha-layout-fit').layout('resize');
        $('.hisui-tabs').tabs('scrollBy', 0);
        $('.dhcpha-win-mask').hide();
    }, 100);
});

function InitDict() {
    var comboWidth = 230;
    // ����
    // ��Һ����
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaLoc', Type: 'PivaLoc' },
        {
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
    // ҩƷ
    PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { width: comboWidth });
    // ����
    PIVAS.ComboBox.Init({ Id: 'cmbBatNo', Type: 'Batch' }, { width: comboWidth, multiple: true });
    // ��Һ״̬
    PIVAS.ComboBox.Init(
        { Id: 'cmbPivaStat', Type: 'PIVAState' },
        {
            editable: true,
            onLoadSuccess: function () {
                //$(this).combobox('showPanel');
            },
            width: comboWidth
        }
    );
    // �÷�
    PIVAS.ComboBox.Init({ Id: 'cmbInstruc', Type: 'Instruc' }, { width: comboWidth });
    // ִ�м�¼״̬
    PIVAS.ComboBox.Init({ Id: 'cmbOeoreStat', Type: 'OrdStatus' }, { width: comboWidth, panelHeight: 'auto' });
    // ���
    PIVAS.ComboBox.Init({ Id: 'cmbPack', Type: 'PackType' }, { width: comboWidth, panelHeight: 'auto' });
    // �������
    PIVAS.ComboBox.Init({ Id: 'cmbPassResult', Type: 'PassResult' }, { width: comboWidth, panelHeight: 'auto', editable: false });
    // ��Һ�ܾ�
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaRefuse',
            Type: 'YesOrNo',
            data: {
                data: [
                    { RowId: 'Y', Description: $g('����Һ�ܾ�') },
                    { RowId: 'N', Description: $g('δ��Һ�ܾ�') }
                ]
            }
        },
        {
            width: comboWidth,
            panelHeight: 'auto',
            editable: true
        }
    );
    // ¥��
    PIVAS.ComboBox.Init({ Id: 'cmbFloor', Type: 'Floor' }, { width: comboWidth });
}

/// ��ѯ
function Query() {
    var params = GetParams();
    if (params == '') {
        return;
    }
    var pogsNo = $('#txtPogsNo').searchbox('getValue');
    if (pogsNo == '') {
        pogsNo = '��';
    }
    var tabTitleCode = $('#tabsWardBat').tabs('getSelected').panel('options').code;

    if (tabTitleCode == '�������ӵ�') {
        var raqObj = {
            raqName: 'DHCST_PIVAS_�������ӵ�.raq',
            raqParams: {
                startDate: $('#dateOrdStart').datebox('getValue'),
                endDate: $('#dateOrdEnd').datebox('getValue'),
                userName: session['LOGON.USERNAME'],
                pivaLoc: session['LOGON.CTLOCID'],
                hospDesc: PIVAS.Session.HOSPDESC,
                locDesc: $('#cmbPivaLoc').combobox('getText'),
                pogsNo: pogsNo,
                inputStr: params,
                pid: ''
            },
            isPreview: 1,
            isPath: 1
        };
        var raqSrc = PIVASPRINT.RaqPrint(raqObj);
        $('#tabWardBatGrp iframe').attr('src', raqSrc);
    } else if (tabTitleCode == '����������ϸ��') {
        var raqObj = {
            raqName: 'DHCST_PIVAS_����������ϸ��.raq',
            raqParams: {
                startDate: $('#dateOrdStart').datebox('getValue'),
                endDate: $('#dateOrdEnd').datebox('getValue'),
                userName: session['LOGON.USERNAME'],
                pivaLoc: session['LOGON.CTLOCID'],
                hospDesc: PIVAS.Session.HOSPDESC,
                locDesc: $('#cmbPivaLoc').combobox('getText'),
                pogsNo: pogsNo,
                inputStr: params,
                pid: ''
            },
            isPreview: 1,
            isPath: 1
        };
        var raqSrc = PIVASPRINT.RaqPrint(raqObj);
        $('#tabWardBatOrdDetail iframe').attr('src', raqSrc);
    } else if (tabTitleCode == '�������λ���') {
        var raqObj = {
            raqName: 'DHCST_PIVAS_�������λ���.raq',
            raqParams: {
                startDate: $('#dateOrdStart').datebox('getValue'),
                endDate: $('#dateOrdEnd').datebox('getValue'),
                userName: session['LOGON.USERNAME'],
                pivaLoc: session['LOGON.CTLOCID'],
                hospDesc: PIVAS.Session.HOSPDESC,
                locDesc: $('#cmbPivaLoc').combobox('getText'),
                inputStr: params,
                pogsNo: pogsNo
            },
            isPreview: 1,
            isPath: 1
        };
        var raqSrc = PIVASPRINT.RaqPrint(raqObj);
        $('#tabWardBatTbl iframe').attr('src', raqSrc);
    } else if (tabTitleCode == '��������ҩƷ����') {
        var raqObj = {
            raqName: 'DHCST_PIVAS_��������ҩƷ����.raq',
            raqParams: {
                startDate: $('#dateOrdStart').datebox('getValue'),
                endDate: $('#dateOrdEnd').datebox('getValue'),
                userName: session['LOGON.USERNAME'],
                pivaLoc: session['LOGON.CTLOCID'],
                hospDesc: PIVAS.Session.HOSPDESC,
                locDesc: $('#cmbPivaLoc').combobox('getText'),
                inputStr: params,
                pogsNo: pogsNo
            },
            isPreview: 1,
            isPath: 1
        };
        var raqSrc = PIVASPRINT.RaqPrint(raqObj);
        $('#tabWardBatIncTbl iframe').attr('src', raqSrc);
    }
}

// ��ȡ����
function GetParams() {
    var paramsArr = [];
    var pivaLocId = $('#cmbPivaLoc').combobox('getValue') || ''; // ��Һ����
    var dateOrdStart = $('#dateOrdStart').datebox('getValue'); // ��ʼ����
    var dateOrdEnd = $('#dateOrdEnd').datebox('getValue'); // ��ֹ����
    var locGrpId = $('#cmbLocGrp').combobox('getValue'); // ������
    var wardId = $('#cmbWard').combobox('getValue') || ''; // ����
    var priority = $('#cmbPriority').combobox('getValue') || ''; // ҽ�����ȼ�
    var passResult = $('#cmbPassResult').combobox('getValue') || ''; // ҽ�����״̬
    var pivaStat = $('#cmbPivaStat').combobox('getValue') || ''; // ��Һ״̬
    var oeoreStat = $('#cmbOeoreStat').combobox('getValue') || ''; // ҽ��״̬
    var patNo = $.trim($('#txtPatNo').val()); // �ǼǺ�
    var pogsNo = $('#txtPogsNo').searchbox('getValue'); // ����
    var prtPNo = ''; // ��ǩ���
    var batNoStr = $('#cmbBatNo').combobox('getValues'); // ����
    var printStop = ''; // �Ƿ��Ѵ�ӡֹͣ��ǩ
    var barCode = ''; // �����
    var instruc = $('#cmbInstruc').combobox('getValue') || ''; // �÷�
    var freq = ''; // Ƶ��
    var datePrtStart = $('#datePrtStart').datebox('getValue'); // ��ǩ��ʼ����
    var datePrtEnd = $('#datePrtEnd').datebox('getValue'); // ��ǩ��ֹ����
    var incId = $('#cmgIncItm').combobox('getValue') || ''; // ҩƷ
    var pivaCat = ''; //$("#cmbPivaCat").combobox("getValue");  // ��Һ����-yunhaibao20180328�ݲ���
    var timePrtStart = $('#timePrtStart').timespinner('getValue'); // ��ǩ��ʼʱ��
    var timePrtEnd = $('#timePrtEnd').timespinner('getValue'); // ��ǩ����ʱ��
    var pivaRefuse = $('#cmbPivaRefuse').combobox('getValue') || ''; // ��Һ�ܾ�
    var timeOrdStart = $('#timeOrdStart').timespinner('getValue'); // ��ҩ��ʼʱ��
    var timeOrdEnd = $('#timeOrdEnd').timespinner('getValue'); // ��ҩ����ʱ��
    var workTypeId = $('#cmbWorkType').combobox('getValue') || ''; // ������
    var packFlag = $('#cmbPack').combobox('getValues') || ''; // �������
    var floor = $('#cmbFloor').combobox('getValue') || ''; // ¥��
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
    paramsArr[28] = floor;

    return paramsArr.join('^');
}

// ��ʼ��Ĭ������
function InitPivasSettings() {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Settings',
            MethodName: 'GetAppProp',
            userId: session['LOGON.USERID'],
            locId: session['LOGON.CTLOCID'],
            appCode: 'Report_WardBat'
        },
        function (jsonData) {
            $('#dateOrdStart').datebox('setValue', jsonData.OrdStDate);
            $('#dateOrdEnd').datebox('setValue', jsonData.OrdEdDate);
            $('#datePrtStart').datebox('setValue', jsonData.PrtStDate);
            $('#datePrtEnd').datebox('setValue', jsonData.PrtEdDate);
        }
    );
}
