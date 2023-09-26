/**
 * ģ��:     ��Һ�����ۺϲ�ѯ
 * ��д����: 2018-03-28
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var hisPatNoLen = PIVAS.PatNoLength();
var linkOrderCheck = '';
var GridCmbBatNo;
$(function() {
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridGenerally();
    $('#btnFind').on('click', Query);
    $('#btnPrtLabel').on('click', PrintLabel);
    $('#btnRetYes').on('click', function() {
        SaveRetFlag('Y');
    });
    $('#btnRetNo').on('click', function() {
        SaveRetFlag('N');
    });
    $('#btnPrtStopLabel').on('click', PrintStopLabel);
    // �ǼǺŻس��¼�
    $('#txtPatNo').on('keypress', function(event) {
        if (window.event.keyCode == '13') {
            var patNo = $.trim($('#txtPatNo').val());
            if (patNo != '') {
                patNo = PIVAS.FmtPatNo(patNo);
                $('#txtPatNo').val(patNo);
                Query();
            }
        }
    });
    // ����Żس��¼�
    $('#txtBarCode').on('keypress', function(event) {
        if (window.event.keyCode == '13') {
            var barCode = $.trim($('#txtBarCode').val());
            if (barCode != '') {
                Query();
            }
        }
    });
    // ���̵���
    $('#txtPrtNo').searchbox({
        searcher: function(value, name) {
            if (event.keyCode == 13) {
                Query();
                return;
            }
            var pivaLocId = $('#cmbPivaLoc').combobox('getValue');
            var psNumber = $('#cmbPivaStat').combobox('getValue');
            PIVAS.PogsNoWindow({
                TargetId: 'txtPrtNo',
                PivaLocId: pivaLocId,
                PsNumber: psNumber
            });
        }
    });
    $('#txtPrtNo')
        .next()
        .find('input:first')
        .attr('placeholder', ' ���̵���...');
    InitPivasSettings();
    setTimeout(function() {
        getLodop();
    }, 2000);
    $('.dhcpha-win-mask').remove();
});

function InitDict() {
    // ��Һ����
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaLoc',
            Type: 'PivaLoc'
        },
        {
            placeholder: '��Һ����...',
            editable: false,
            onLoadSuccess: function() {
                var datas = $('#cmbPivaLoc').combobox('getData');
                for (var i = 0; i < datas.length; i++) {
                    if (datas[i].RowId == SessionLoc) {
                        $('#cmbPivaLoc').combobox('setValue', datas[i].RowId);
                        break;
                    }
                }
            },
            onSelect: function(data) {
                var locId = data.RowId;
                $('#DivBatNo').html('');
                PIVAS.BatchNoCheckList({
                    Id: 'DivBatNo',
                    LocId: locId,
                    Check: true,
                    Pack: false
                });
            }
        }
    );
    // ҽ�����ȼ�
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPriority',
            Type: 'Priority'
        },
        {
            placeholder: 'ҽ�����ȼ�...'
        }
    );
    // ����
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbWard',
            Type: 'Ward'
        },
        {
            placeholder: '����...'
        }
    );
    // ������
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbLocGrp',
            Type: 'LocGrp'
        },
        {
            placeholder: '������...'
        }
    );
    // �������
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPassResult',
            Type: 'PassResult'
        },
        {
            placeholder: '�������...',
            editable: false
        }
    );
    // ִ�м�¼״̬
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbOeoreStat',
            Type: 'OrdStatus'
        },
        {
            placeholder: 'ִ�м�¼״̬...'
        }
    );
    // �÷�
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbInstruc',
            Type: 'Instruc'
        },
        {
            placeholder: '�÷�...'
        }
    );
    // Ƶ��
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbFreq',
            Type: 'Freq'
        },
        {
            placeholder: 'Ƶ��...'
        }
    );
    // ��Һ״̬
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaStat',
            Type: 'PIVAState'
        },
        {
            placeholder: '��Һ״̬...'
        }
    );
    // �Ƿ��Ѵ�ӡֹͣǩ
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPrintStop',
            Type: 'YesOrNo',
            data: {
                data: [
                    {
                        RowId: 'Y',
                        Description: '�Ѵ�ӡֹͣǩ'
                    },
                    {
                        RowId: 'N',
                        Description: 'δ��ӡֹͣǩ'
                    }
                ]
            }
        },
        {
            placeholder: 'ֹͣǩ��ӡ...'
        }
    );
    // ҩƷ
    PIVAS.ComboGrid.Init(
        {
            Id: 'cmgIncItm',
            Type: 'IncItm'
        },
        {
            placeholder: 'ҩƷ...'
        }
    ); // width: 315
    // ����
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbBatNo',
            Type: 'Batch'
        },
        {
            multiple: true
        }
    );
    // �Ƿ�ܾ���Һ
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaRefuse',
            Type: 'YesOrNo',
            data: {
                data: [
                    {
                        RowId: 'Y',
                        Description: '����Һ�ܾ�'
                    },
                    {
                        RowId: 'N',
                        Description: 'δ��Һ�ܾ�'
                    }
                ]
            }
        },
        {
            placeholder: '��Һ�ܾ�...'
        }
    );
    PIVAS.BatchNoCheckList({
        Id: 'DivBatNo',
        LocId: SessionLoc,
        Check: true,
        Pack: false
    });
    // ������
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbWorkType',
            Type: 'PIVAWorkType'
        },
        {
            placeholder: '������...'
        }
    );
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPack',
            Type: 'PackType'
        },
        {
            placeholder: '�������...'
        }
    );
    GridCmbBatNo = PIVAS.UpdateBatNoCombo({
        LocId: SessionLoc,
        GridId: 'gridGenerally',
        Field: 'batNo',
        BatUp: 'batUp',
        MDspField: 'mDsp'
    });
}

function InitGridGenerally() {
    var columns = [
        [
            {
                field: 'gridGenerallySelect',
                checkbox: true
            },
            {
                field: 'warnInfo',
                title: '����',
                width: 75,
                styler: function(value, row, index) {
                    if (value.indexOf('ֹͣ') >= 0) {
                        return 'color:white;background-color:#ffba42;';
                    } else if (value.indexOf('��Һ�ܾ�') >= 0) {
                        return 'color:white;background-color:#F4868E;';
                    } else if (value.indexOf('��˾ܾ�') >= 0) {
                        return 'color:white;background-color:#C33A30;';
                    }
                    return '';
                }
            },
            {
                field: 'doseDateTime',
                title: '��ҩʱ��',
                width: 135
            },
            {
                field: 'wardDesc',
                title: '����',
                width: 125
            },
            {
                field: 'bedNo',
                title: '����',
                width: 75
            },
            {
                field: 'patNo',
                title: '�ǼǺ�',
                width: 100
            },
            {
                field: 'patName',
                title: '����',
                width: 70
            },
            {
                field: 'batNo',
                title: '����',
                width: 75,
                editor: GridCmbBatNo,
                styler: function(value, row, index) {
                    var colorStyle = 'text-decoration:underline;';
                    if (row.packFlag != '') {
                        colorStyle += PIVAS.Grid.CSS.BatchPack;
                    }
                    return colorStyle;
                }
            },
            {
                field: 'oeoriSign',
                title: '��',
                width: 30,
                halign: 'left',
                align: 'center',
                formatter: PIVAS.Grid.Formatter.OeoriSign
            },
            {
                field: 'incDesc',
                title: 'ҩƷ����',
                width: 250,
				styler: PIVAS.Grid.Styler.IncDesc
            },
            {
                field: 'dosage',
                title: '����',
                width: 75
            },
            {
                field: 'freqDesc',
                title: 'Ƶ��',
                width: 75
            },
            {
                field: 'instrucDesc',
                title: '�÷�',
                width: 100
            },
            {
                field: 'priDesc',
                title: 'ҽ�����ȼ�',
                width: 90
            },
            {
                field: 'oeoreStat',
                title: 'ҽ��״̬',
                width: 70,
                hidden: true
            },
            {
                field: 'qty',
                title: '����',
                width: 50,
                halign: 'left',
                align: 'right'
            },
            {
                field: 'bUomDesc',
                title: '��λ',
                width: 60
            },
            {
                field: 'xDateTime',
                title: 'ֹͣʱ��',
                width: 155
            },
            {
                field: 'pivaStat',
                title: '��Һ״̬',
                width: 80,
                styler: PIVAS.Grid.Styler.PivaState
            },
            {
                field: 'passResult',
                title: '��˽��',
                width: 70
            },
            {
                field: 'incSpec',
                title: '���',
                width: 70
            },
            {
                field: 'barCode',
                title: '����',
                width: 125
            },
            {
                field: 'pNo',
                title: '��ӡ���',
                width: 70,
                hidden: true
            },
            {
                field: 'printUser',
                title: '��ǩ��',
                width: 90
            },
            {
                field: 'printDateTime',
                title: '��ǩʱ��',
                width: 155
            },
            {
                field: 'refUser',
                title: '�ܾ���',
                width: 90
            },
            {
                field: 'refDateTime',
                title: '�ܾ�ʱ��',
                width: 155
            },
            {
                field: 'cPrtDateTime',
                title: 'ֹͣǩ��ӡʱ��',
                width: 155,
                formatter: function(value, row, index) {
                    if (value == 'U') {
                        var cPrtDt = tkMakeServerCall('web.DHCSTPIVAS.StopPrint', 'GetCPrtTimeByPog', row.pogId);
                        return cPrtDt;
                    } else {
                        return value;
                    }
                }
            },
            {
                field: 'pogId',
                title: 'pogId',
                width: 70,
                hidden: false
            },
            {
                field: 'colColor',
                title: 'colColor',
                width: 75,
                hidden: true
            },
            {
                field: 'durationDesc',
                title: '�Ƴ�',
                width: 50,
                hidden: true
            },
            {
                field: 'packFlag',
                title: '���',
                width: 50,
                hidden: true
            },
            {
                field: 'mDsp',
                title: 'mDsp',
                width: 50,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        exportXls: true,
        url: '',
        toolbar: '#gridGenerallyBar',
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        striped: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageSize: 50,
        pageList: [50, 100, 200],
        onLoadSuccess: function() {
            PIVAS.Grid.CellTip({
                TipArr: ['ordRemark', 'incDesc', 'wardDesc']
            });
            $(this).datagrid('options').checking = '';
            // $(".datagrid-btable td[field=oeoriSign]>div").css(PIVAS.Grid.CSS.OeoriSign);
        },
        rowStyler: function(index, rowData) {
            return PIVAS.Grid.RowStyler.Person(index, rowData, 'patNo');
        },
        onClickRow: function(rowIndex, rowData) {},
        onClickCell: function(rowIndex, field, value) {
            if (field == 'oeoriSign') {
                var barCode = $(this).datagrid('getRows')[rowIndex].barCode;
                PIVASTIMELINE.Init({
                    Params: barCode,
                    Field: 'oeoriSign',
                    ClickField: field
                });
            }
            if (field == 'pivaStat') {
                PIVAS.OrdLinkWindow({
                    Params: $(this).datagrid('getRows')[rowIndex].pogId
                });
            }
            if (field == 'batNo' && value != '') {
                $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'batNo'
                });
            } else {
                $(this).datagrid('endEditing');
            }
        },
        onCheck: function(rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridGenerally',
                Field: 'barCode',
                Check: true,
                Value: rowData.barCode
            });
            $(this).datagrid('options').checking = '';
        },
        onUncheck: function(rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridGenerally',
                Field: 'barCode',
                Check: false,
                Value: rowData.barCode
            });
            $(this).datagrid('options').checking = '';
        },
        onSelect: function(rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridGenerally',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId,
                Type: 'Select'
            });
            $(this).datagrid('options').checking = '';
        },
        onUnselect: function(rowIndex, rowData) {
            PIVAS.Grid.ClearSelections(this.id)
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridGenerally', dataGridOption);
}

///��ѯ
function Query() {
    var params = GetParams();
    $('#gridGenerally').datagrid({
        url: PIVAS.URL.COMMON + '?action=JsGenerallyQuery',
        queryParams: {
            params: params
        }
    });
}

///��ȡ���
function GetParams() {
    var paramsArr = [];
    var pivaLocId = $('#cmbPivaLoc').combobox('getValue') || ''; // ��Һ����
    var dateOrdStart = $('#dateOrdStart').datebox('getValue'); // ��ʼ����
    var dateOrdEnd = $('#dateOrdEnd').datebox('getValue'); // ��ֹ����
    var locGrpId = $('#cmbLocGrp').combobox('getValue') || ''; // ������
    var wardId = $('#cmbWard').combobox('getValue') || ''; // ����
    var priority = $('#cmbPriority').combobox('getValue') || ''; // ҽ�����ȼ�
    var passResult = $('#cmbPassResult').combobox('getValue') || ''; // ҽ�����״̬
    var pivaStat = $('#cmbPivaStat').combobox('getValue') || ''; // ��Һ״̬
    var oeoreStat = $('#cmbOeoreStat').combobox('getValue') || ''; // ҽ��״̬
    var patNo = $.trim($('#txtPatNo').val()); // �ǼǺ�
    var prtNo = $('#txtPrtNo').searchbox('getValue'); // ��ǩ����
    var prtPNo = $('#txtPrtPNo')
        .val()
        .trim(); // ��ǩ���
    var batNoStr = ''; // ����
    $('input[type=checkbox][name=batbox]').each(function() {
        if ($('#' + this.id).is(':checked')) {
            if (batNoStr == '') {
                batNoStr = this.value;
            } else {
                batNoStr = batNoStr + ',' + this.value;
            }
        }
    });
    var printStop = $('#cmbPrintStop').combobox('getValue') || ''; // �Ƿ��Ѵ�ӡֹͣ��ǩ
    var barCode = $.trim($('#txtBarCode').val()); // �����
    var instruc = $('#cmbInstruc').combobox('getValue') || ''; // �÷�
    var freq = $('#cmbFreq').combobox('getValue') || ''; // Ƶ��
    var datePrtStart = $('#datePrtStart').datebox('getValue'); // ��ǩ��ʼ����
    var datePrtEnd = $('#datePrtEnd').datebox('getValue'); // ��ǩ��ֹ����
    var incId = $('#cmgIncItm').combobox('getValue') || ''; // ҩƷ
    var pivaCat = ''; //$("#cmbPivaCat").combobox("getValue"); 	// ��Һ����-yunhaibao20180328�ݲ���
    var timePrtStart = $('#timePrtStart').timespinner('getValue'); // ��ǩ��ʼʱ��
    var timePrtEnd = $('#timePrtEnd').timespinner('getValue'); // ��ǩ����ʱ��
    var pivaRefuse = $('#cmbPivaRefuse').combobox('getValue') || ''; // ��Һ�ܾ�
    var timeOrdStart = $('#timeOrdStart').timespinner('getValue'); // ��ҩ��ʼʱ��
    var timeOrdEnd = $('#timeOrdEnd').timespinner('getValue'); // ��ҩ����ʱ��
    var workTypeId = $('#cmbWorkType').combobox('getValue') || ''; // ������
    var packFlag = $('#cmbPack').combobox('getValues') || ''; // �������
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
    paramsArr[20] = prtNo;
    paramsArr[21] = pivaRefuse;
    paramsArr[22] = patNo;
    paramsArr[23] = prtPNo;
    paramsArr[24] = timeOrdStart;
    paramsArr[25] = timeOrdEnd;
    paramsArr[26] = workTypeId;
    paramsArr[27] = packFlag;
    return paramsArr.join('^');
}

// ��ӡ��ǩ
function PrintLabel() {
    var pogArr = GetCheckedPogArr(1);
    var pogLen = pogArr.length;
    if (pogLen == 0) {
        $.messager.popover({
            msg: '��ܰ��ʾ : ��ֹͣҽ���޷��ش��ǩ',
            type: 'alert'
        });
        return;
    }
    PIVASPRINT.LabelsJsonByPogStr({
        pogStr: pogArr.join('^')
    });
}
// ��ӡֹͣǩ
function PrintStopLabel() {
    $.messager.confirm('ѡ����ʾ', '��ȷ�ϴ�ӡֹͣǩ��?', function(r) {
        if (r) {
            var pogArr = GetCheckedPogArr(2);
            var pogLen = pogArr.length;
            if (pogLen == 0) {
                return;
            }
            // ����ֹͣǩ��¼��
            var pCPRet = tkMakeServerCall('web.DHCSTPIVAS.StopPrint', 'SaveCPrint', pogArr.join('^'), SessionUser);
            var pCPRetArr = pCPRet.split('^');
            var pCPId = pCPRetArr[0];
            if (pCPId < 0) {
                $.messager.alert('��ʾ', pCPRetArr[1], 'warning');
                return;
            }
            PIVASPRINT.LabelsJsonByPogStr({
                pogStr: pogArr.join('^')
            });
            var count = 0;
            var printNum = PIVASPRINT.PrintNum;
            for (var pogI = 0; pogI < pogLen; pogI++) {
                var pogId = pogArr[pogI];
                var pogRowIndex =
                    $("td[field='pogId']")
                        .children()
                        .filter(':contains(' + pogId + ')')
                        .closest('tr')
                        .attr('datagrid-row-index') || '';
                if (pogRowIndex != '') {
                    $('#gridGenerally')
                        .datagrid('updateRow', {
                            index: pogRowIndex,
                            row: {
                                cPrtDateTime: 'U'
                            }
                        })
                        .datagrid('checkRow', pogRowIndex);
                }
            }
        }
    });
}

// ��ȡѡ�м�¼��pog
// pFlag:1-��ȡ����,2-��ȡֹͣ
function GetCheckedPogArr(pFlag) {
    var pogArr = [];
    var gridChecked = $('#gridGenerally').datagrid('getChecked');

    if (gridChecked == '') {
        $.messager.alert('��ʾ', '����ѡ���¼', 'warning');
        return pogArr;
    }
    var cLen = gridChecked.length;
    for (var cI = 0; cI < cLen; cI++) {
        var pogId = gridChecked[cI].pogId;
        if (pogId == '') {
            continue;
        }
        var oeoreStat = gridChecked[cI].oeoreStat;
        var oeoreStatIndex = oeoreStat.indexOf('ֹͣ');
        var passResult = gridChecked[cI].passResult;
        var passResultIndex = passResult.indexOf('���');
        if (pFlag == 2) {
            // ��ȡֹͣ��
            if (oeoreStatIndex < 0) {
                continue;
            }
            if (passResultIndex < 0) {
                //continue;
            }
        } else if (pFlag == 1) {
            // ��ȡ������
            if (oeoreStatIndex >= 0) {
                continue;
            }
        }
        if (pogArr.indexOf(pogId) < 0) {
            pogArr.push(pogId);
        }
    }
    return pogArr;
}
// �ÿ��˻򲻿���ҩ
function SaveRetFlag(Flag) {
    $.messager.confirm('��ʾ', '��ȷ����Ϊ' + (Flag == 'Y' ? '����ҩ' : '������ҩ') + '��?', function(r) {
        if (r) {
            var pogIdArr = GetCheckedPogArr('');
            var pogIdStr = pogIdArr.join('^');
            if (pogIdStr == '') {
                return;
            }
            var saveRet = tkMakeServerCall('web.DHCSTPIVAS.DataHandler', 'SaveRetFlag', pogIdStr, Flag, SessionUser);
            var saveArr = saveRet.split('^');
            if (saveArr[0] < 0) {
                $.messager.alert('��ʾ', saveArr[1], 'warning');
            } else {
                $.messager.popover({
                    msg: '�ɹ�',
                    type: 'success'
                });
            }
        }
    });
}
// ��ʼ��Ĭ������
function InitPivasSettings() {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Settings',
            MethodName: 'GetAppProp',
            userId: session['LOGON.USERID'],
            locId: session['LOGON.CTLOCID'],
            appCode: 'Generally',
            morePropStr: 'ReqNeedAudit'
        },
        function(jsonData) {
            $('#dateOrdStart').datebox('setValue', jsonData.OrdStDate);
            $('#dateOrdEnd').datebox('setValue', jsonData.OrdEdDate);
            $('#datePrtStart').datebox('setValue', jsonData.PrtStDate);
            $('#datePrtEnd').datebox('setValue', jsonData.PrtEdDate);
            if (jsonData.ReqNeedAudit == 'Y') {
                $('#tdReqNeedAudit').css('display', 'block');
            }
        }
    );
}
// ������,����,IE����Ҫ��������,�ݲ�����,2019-04-11
function PrintLabelLodop() {
    PIVASLODOP = getLodop();
    var taskNum = 0;
    PIVASLODOP.On_Return = function(TaskID, Value) {
        var taskCnt = PIVASPRINT.TaskCnt;
        taskNum++;
        if (taskNum == 1) {
            //$.messager.progress("close");
            $.messager.progress({
                title: '��  ��  ��  ӡ  ��  ��  ��...',
                text: '<b>{value}%</b>',
                interval: 100000
            });
        }
        $('body>div.messager-window')
            .find('div.messager-p-msg')
            .text(taskNum + ' / ' + taskCnt);
        $.messager.progress('bar').progressbar('setValue', parseInt((taskNum / taskCnt) * 100));
        if (taskNum == taskCnt) {
            $.messager.progress('close');
        }
    };
    PIVASPRINT.LabelsJsonByPogsNo({
        pogsNo: 'S10P20190219001',
        sortWay: '15^1'
    });
}
