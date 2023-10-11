/**
 * ģ��:     ��Һ�����ۺϲ�ѯ
 * ��д����: 2018-03-28
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var hisPatNoLen = PIVAS.PatNoLength();
var PersonSameFields = '[field=patNo],[field=patName],[field=bedNo],[field=wardDesc]';
var SameRowsHanlder = PIVAS.Grid.SameRows('gridGenerally', PersonSameFields);
var linkOrderCheck = '';
var GridCmbBatNo;
var SessionInfo = SessionLoc + '^' + SessionUser + '^' + session['LOGON.GROUPID'] + '^' + session['LOGON.HOSPID'];
$(function () {
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridGenerally();
    $('#btnFind').on('click', Query);
    $('#btnPrtLabel').on('click', PrintLabel);
    $('#btnPrtTable').on('click', function () {
        if ($('#gridGenerally').datagrid('getChecked').length === 0) {
            $.messager.popover({
                msg: '�빴ѡ��Ҫ��ӡ�ļ�¼',
                type: 'alert'
            });
            return;
        }
        $.messager.confirm('��ʾ', '��ȷ�ϴ�ӡ�嵥��?', function (r) {
            if (r) {
                PrintTable();
            }
        });
    });
    $('#btnRetYes').on('click', function () {
        SaveRetFlag('Y');
    });
    $('#btnRetNo').on('click', function () {
        SaveRetFlag('N');
    });
    $('#btnPrtStopLabel').on('click', PrintStopLabel);
    // �ǼǺŻس��¼�
    $('#txtPatNo').on('keypress', function (event) {
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
    $('#txtBarCode').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var barCode = $.trim($('#txtBarCode').val());
            if (barCode != '') {
                Query();
            }
        }
    });
    // ���̵���
    $('#txtPrtNo').searchbox({
        searcher: function (value, name) {
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
    $('#txtPrtNo').next().find('input:first').attr('placeholder', $g(' ���̵���...'));
    InitPivasSettings();
    setTimeout(function () {
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
            placeholder: $g('��Һ����') + '...',
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
            onSelect: function (data) {
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
            placeholder: $g('ҽ�����ȼ�') + '...'
        }
    );
    // ����
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbWard',
            Type: 'Ward'
        },
        {
            placeholder: $g('����') + '...'
        }
    );
    // ������
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbLocGrp',
            Type: 'LocGrp'
        },
        {
            placeholder: $g('������') + '...'
        }
    );
    // �������
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPassResult',
            Type: 'PassResult'
        },
        {
            placeholder: $g('�������') + '...',
            editable: false
        }
    );
    // ִ�м�¼״̬
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbOeoreStat',
            Type: 'OrdStatusDetail'
        },
        {
            placeholder: $g('ִ�м�¼״̬') + '...'
        }
    );
    // �÷�
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbInstruc',
            Type: 'Instruc'
        },
        {
            placeholder: $g('�÷�') + '...'
        }
    );
    // Ƶ��
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbFreq',
            Type: 'Freq'
        },
        {
            placeholder: $g('Ƶ��') + '...'
        }
    );
    // ��Һ״̬
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaStat',
            Type: 'PIVAState'
        },
        {
            placeholder: $g('��Һ״̬') + '...'
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
                        Description: $g('�Ѵ�ӡֹͣǩ')
                    },
                    {
                        RowId: 'N',
                        Description: $g('δ��ӡֹͣǩ')
                    }
                ]
            }
        },
        {
            placeholder: $g('ֹͣǩ��ӡ') + '...',
            panelHeight: 'auto'
        }
    );
    // ҩƷ
    PIVAS.ComboGrid.Init(
        {
            Id: 'cmgIncItm',
            Type: 'IncItm'
        },
        {
            placeholder: $g('ҩƷ') + '...'
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
                        Description: $g('����Һ�ܾ�')
                    },
                    {
                        RowId: 'N',
                        Description: $g('δ��Һ�ܾ�')
                    }
                ]
            }
        },
        {
            placeholder: $g('��Һ�ܾ�') + '...',
            panelHeight: 'auto'
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
            placeholder: $g('������') + '...'
        }
    );
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPack',
            Type: 'PackType'
        },
        {
            placeholder: $g('�������') + '...'
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
                width: 125,
                formatter: function (value, row, index) {
                    var retArr = [];
                    if (row.oeoreStatDesc.indexOf('ֹͣ') >= 0) {
                        retArr.push('<div class="pivas-grid-div">' + 'ִ�м�¼' + row.oeoreStatDesc + '</div>');
                    }
                    if (row.passResultDesc.indexOf('�ܾ�') >= 0) {
                        retArr.push('<div class="pivas-grid-div">' + '������˾ܾ�' + '</div>');
                    }
                    if (row.refUser !== '') {
                        retArr.push('<div class="pivas-grid-div">' + '��Һ�ܾ�' + '</div>');
                    }
                    if (row.cPrtUser !== '') {
                        retArr.push('<div class="pivas-grid-div">' + '�Ѵ�ֹͣǩ' + '</div>');
                    }
                    if (row.nurSeeDesc.indexOf('�ܾ�') >= 0) {
                        retArr.push('<div class="pivas-grid-div">' + '��ʿ�ܾ�' + '</div>');
                    }
                    if (retArr.length > 0) {
                        return '<div style="margin-top:-8px;color:#ff584c;font-weight: bold">' + retArr.join('') + '</div>';
                    }
                    return '';
                }
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
                field: 'doseDateTime',
                title: '��ҩʱ��',
                width: 135
            },
            {
                field: 'batNo',
                title: '����',
                width: 75,
                editor: GridCmbBatNo,
                styler: function (value, row, index) {
                    var colorStyle = 'text-decoration:underline;';
                    if (row.packFlag != '') {
                        colorStyle += PIVAS.Grid.CSS.BatchPack;
                    }
                    return colorStyle;
                }
            },
            {
                field: 'drugsArr',
                title: 'ҩƷ��Ϣ',
                width: 300,
                formatter: PIVAS.Grid.Formatter.InciGroup
            },
            {
                field: 'dosage',
                title: '����',
                width: 75,
                align: 'right',
                formatter: PIVAS.Grid.Formatter.DosageGroup
            },
            {
                field: 'qtyUom',
                title: '����',
                width: 50,
                align: 'right',
                formatter: PIVAS.Grid.Formatter.QtyUomGroup
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
                field: 'psName',
                title: '��Һ״̬',
                width: 80,
                styler: PIVAS.Grid.Styler.PivaState
            },
            {
                field: 'linkFeeAmt',
                title: '���÷�',
                align: 'right',
                width: 70,
                formatter: function (value, row, index) {
                    var pog = row.pog;
                    return '<a class="pha-grid-a" onclick="PIVAS.OrdLinkWindow({Params:\'' + pog + '\'} )">' + value + '</a>';
                }
            },
            {
                field: 'barCode',
                title: '����',
                width: 125,
                formatter: function (value, row, index) {
                    var field = 'barCode';
                    return '<a class="pha-grid-a" onclick="PIVASTIMELINE.Init({Params:\'' + value + "',Field:'" + field + "',ClickField:'" + field + '\'} )">' + value + '</a>';
                }
            },
            {
                field: 'pNo',
                title: '��ӡ���',
                align: 'right',
                width: 75
            },
            {
                field: 'passResultInfo',
                title: '���������Ϣ',
                width: 155,
                formatter: function (value, row, index) {
                    var retArr = [];
                    retArr.push('<div>' + row.phaOrdDateTime + '</div>');
                    retArr.push('<div class="pivas-grid-div">');
                    retArr.push('   <div style="float:left">' + row.phaOrdUser + '</div>');
                    retArr.push('   <div style="float:right;font-weight:bold">' + row.passResultDesc + '</div>');
                    retArr.push('</div>');
                    return retArr.join('');
                }
            },
            {
                field: 'printInfo',
                title: '��ǩ��Ϣ',
                width: 155,
                formatter: function (value, row, index) {
                    return '<div>' + row.printDateTime + '</div>' + '<div class="pivas-grid-div">' + row.printUser + '</div>';
                }
            },
            {
                field: 'cPrtInfo',
                title: 'ֹͣǩ��ӡ��Ϣ',
                width: 155,
                formatter: function (value, row, index) {
                    return '<div>' + row.cPrtDateTime + '</div>' + '<div class="pivas-grid-div">' + row.cPrtUser + '</div>';
                }
            },
            {
                field: 'refInfo',
                title: '��Һ�ܾ���Ϣ',
                width: 155,
                formatter: function (value, row, index) {
                    var retHtmlArr = [];
                    if (row.refReasonDesc !== '') {
                        retHtmlArr.push('<div class="pivas-grid-tip">');
                        retHtmlArr.push('  <div>');
                        retHtmlArr.push('      <div>' + row.refDateTime + '</div>');
                        retHtmlArr.push('  </div>');
                        retHtmlArr.push('  <div style="padding-top:8px;overflow: hidden; white-space: nowrap;">');
                        retHtmlArr.push('      <div>' + row.refUser + ' / ' + row.refReasonDesc + '</div>');
                        retHtmlArr.push('      <div style="clear:both"></div>');
                        retHtmlArr.push('  </div>');
                        retHtmlArr.push('</div>');
                    }
                    return retHtmlArr.join('');
                }
            },
            {
                field: 'nurSeeInfo',
                title: 'ҽ��������Ϣ',
                width: 155,
                formatter: function (value, row, index) {
                    var retArr = [];
                    var nurSeeDateTime = row.nurSeeDateTime;
                    if (nurSeeDateTime === '') {
                        nurSeeDateTime = '��';
                    }
                    retArr.push('<div>' + nurSeeDateTime + '</div>');
                    retArr.push('<div class="pivas-grid-div">');
                    retArr.push('   <div style="float:left">' + row.nurSeeUser + '</div>');
                    retArr.push('   <div style="float:right;font-weight:bold">' + row.nurSeeDesc + '</div>');
                    retArr.push('</div>');
                    return retArr.join('');
                }
            },
            {
                field: 'xDateTime',
                title: 'ֹͣʱ��',
                width: 155
            },
            {
                field: 'oeoriStatDesc',
                title: 'ҽ��״̬',
                width: 80
            },
            {
                field: 'oeoreStatDesc',
                title: 'ִ�м�¼״̬',
                width: 100
            },

            {
                field: 'pog',
                title: 'pog',
                width: 70,
                hidden: false
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
            },
            {
                field: 'sameFlag',
                title: 'sameFlag',
                width: 70,
                hidden: true,
                styler: function (value, row, index) {
                    if (value === 'Y') {
                        return {
                            class: 'pivas-person-toggle'
                        };
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        exportXls: false,
        url: '',
        nowrap: false,
        toolbar: '#gridGenerallyBar',
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        pageNumber: 1,
        pageSize: 100,
        pageList: [100, 300, 500, 1000],
        onLoadSuccess: function () {
            var $grid = $(this);
            SameRowsHanlder.Hide();
            $grid.datagrid('loaded');
            $(this).datagrid('options').checking = '';
        },
        rowStyler: PIVAS.Grid.RowStyler.PersonAlt,
        onClickRow: function (rowIndex, rowData) {
            SameRowsHanlder.ShowRow(rowIndex);
        },
        onBeforeSelect: function (rowIndex, rowData) {
            $(this).datagrid('unselectAll');
        },
        onClickCell: function (rowIndex, field, value) {
            if (field !== 'barCode') {
                if ($('#TimeLineWin')) {
                    $('#TimeLineWin').window('close');
                }
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
        onCheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            $(this).datagrid('options').checking = '';
        },
        onUncheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            $(this).datagrid('options').checking = '';
        },
        onUnselect: function (rowIndex, rowData) {
            PIVAS.Grid.ClearSelections(this.id);
        },
        loadFilter: PIVAS.Grid.LoadFilter
    };
    PIVAS.Grid.Init('gridGenerally', dataGridOption);
}

///��ѯ
function Query() {
    var $grid = $('#gridGenerally');
    var pJson = GetParams();
    PIVAS.Grid.PageHandler($grid);
    var rowsData = $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Generally',
            QueryName: 'PogData',
            pJsonStr: JSON.stringify(pJson),
            rows: 99999,
            page: 1
        },
        false
    );
    $grid.datagrid('loading');
    setTimeout(function () {
        $grid.datagrid('loadData', rowsData);
    }, 100);
}

///��ȡ���
function GetParams() {
    var pJson = {};
    pJson.loc = $('#cmbPivaLoc').combobox('getValue') || ''; // ��Һ����
    pJson.ordStartDate = $('#dateOrdStart').datebox('getValue'); // ��ʼ����
    pJson.ordEndDate = $('#dateOrdEnd').datebox('getValue'); // ��ֹ����
    pJson.locGrp = $('#cmbLocGrp').combobox('getValue') || ''; // ������
    pJson.wardStr = $('#cmbWard').combobox('getValue') || ''; // ����
    pJson.priority = $('#cmbPriority').combobox('getValue') || ''; // ҽ�����ȼ�
    pJson.passResult = $('#cmbPassResult').combobox('getValue') || ''; // ҽ�����״̬
    pJson.psNumber = $('#cmbPivaStat').combobox('getValue') || ''; // ��Һ״̬
    pJson.oeoreStat = $('#cmbOeoreStat').combobox('getValue') || ''; // ҽ��״̬
    pJson.patNo = $.trim($('#txtPatNo').val()); // �ǼǺ�
    pJson.pogsNo = $('#txtPrtNo').searchbox('getValue'); // ��ǩ����
    var pNoArr = $('#txtPrtPNo').val().split('-');
    pJson.pNoStart = pNoArr[0] || ''; //$('#txtPrtPNoStart').val().trim(); // ��ǩ���
    pJson.pNoEnd = pNoArr[1] || ''; // $('#txtPrtPNoEnd').val().trim(); // ��ǩ���
    var batNoArr = [];
    $('input[type=checkbox][name=batbox]').each(function () {
        if ($('#' + this.id).is(':checked')) {
            batNoArr.push($('#' + this.id).attr('text'));
        }
    });
    pJson.batNoStr = batNoArr.join(',');

    pJson.prtStoped = $('#cmbPrintStop').combobox('getValue') || ''; // �Ƿ��Ѵ�ӡֹͣ��ǩ
    pJson.barCode = $.trim($('#txtBarCode').val()); // �����
    pJson.instruc = $('#cmbInstruc').combobox('getValue') || ''; // �÷�
    pJson.freq = $('#cmbFreq').combobox('getValue') || ''; // Ƶ��
    pJson.prtStartDate = $('#datePrtStart').datebox('getValue'); // ��ǩ��ʼ����
    pJson.prtEndDate = $('#datePrtEnd').datebox('getValue'); // ��ǩ��ֹ����
    pJson.inci = $('#cmgIncItm').combobox('getValue') || ''; // ҩƷ
    pJson.pivaCat = ''; //$("#cmbPivaCat").combobox("getValue");   // ��Һ����-yunhaibao20180328�ݲ���
    pJson.prtStartTime = $('#timePrtStart').timespinner('getValue'); // ��ǩ��ʼʱ��
    pJson.prtEndTime = $('#timePrtEnd').timespinner('getValue'); // ��ǩ����ʱ��
    pJson.refuseFlag = $('#cmbPivaRefuse').combobox('getValue') || ''; // ��Һ�ܾ�
    pJson.ordStartTime = $('#timeOrdStart').timespinner('getValue'); // ��ҩ��ʼʱ��
    pJson.ordEndTime = $('#timeOrdEnd').timespinner('getValue'); // ��ҩ����ʱ��
    pJson.workType = $('#cmbWorkType').combobox('getValue') || ''; // ������
    pJson.packFlag = $('#cmbPack').combobox('getValue') || ''; // �������
    return pJson;
}

// ��ӡ��ǩ
function PrintLabel() {
    var gridChecked = $('#gridGenerally').datagrid('getChecked');
    if (gridChecked == '') {
        $.messager.popover({
            msg: '����ѡ���¼',
            type: 'alert'
        });
        return;
    }
    var pogArr = GetCheckedPogArr(1);
    var pogLen = pogArr.length;
    if (pogLen == 0) {
        $.messager.popover({
            msg: '��ܰ��ʾ : ��ֹͣ��ִ�м�¼�޷��ش��ǩ',
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
    $.messager.confirm('ѡ����ʾ', '��ȷ�ϴ�ӡֹͣǩ��?', function (r) {
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
                    $("td[field='pog']")
                        .children()
                        .filter(':contains(' + pogId + ')')
                        .closest('tr')
                        .attr('datagrid-row-index') || '';
                if (pogRowIndex != '') {
                    var updData = $.cm(
                        {
                            ClassName: 'web.DHCSTPIVAS.StopPrint',
                            MethodName: 'GetCPrtJsonByPog',
                            PogId: pogId
                        },
                        false
                    );
                    $('#gridGenerally')
                        .datagrid('updateRow', {
                            index: pogRowIndex,
                            row: updData
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
        var pog = gridChecked[cI].pog;
        if (pog == '') {
            continue;
        }
        var oeoreStatDesc = gridChecked[cI].oeoreStatDesc;
        var oeoreStatIndex = oeoreStatDesc.indexOf('ֹͣ');
        var passResult = gridChecked[cI].passResultDesc;
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
        if (pogArr.indexOf(pog) < 0) {
            pogArr.push(pog);
        }
    }
    return pogArr;
}
// �ÿ��˻򲻿���ҩ
function SaveRetFlag(Flag) {
    var msgArr = [];
    msgArr.push('<div>' + $g('��ȷ����Ϊ' + (Flag == 'Y' ? '����ҩ' : '������ҩ') + '��?') + '</div>');
    msgArr.push('<div style="color:#8c8c8c">');
    msgArr.push('<div style="padding-top:15px">' + $g('������Ϣ') + '</div>');
    var packReqNeedAudit = tkMakeServerCall('web.DHCSTPIVAS.Settings', 'GetAppParamProp', '', SessionLoc, '', 'PackReqAudit');
    if (packReqNeedAudit !== 'Y') {
        msgArr.push('<div style="padding-top:10px">1. ' + $g('���޷������ѡ���ҩ���롹�ļ�¼') + '</div>');
        msgArr.push('<div style="padding-top:10px">2. ' + $g('������Ҫ����������ļ�¼') + '</div>');
    } else {
        msgArr.push('<div style="padding-top:10px">' + $g('���޷������ѡ���ҩ���롹�ļ�¼') + '</div>');
    }
    msgArr.push('</div">');
    $.messager.confirm('��ʾ', msgArr.join(''), function (r) {
        if (r) {
            var pogIdArr = GetCheckedPogArr('');
            var pogIdStr = pogIdArr.join('^');
            if (pogIdStr == '') {
                return;
            }
            var saveRet = tkMakeServerCall('web.DHCSTPIVAS.DataHandler', 'SaveRetFlag', pogIdStr, Flag, SessionUser, SessionInfo);
            var saveArr = saveRet.split('^');
            if (saveArr[0] < 0) {
                $.messager.alert('��ʾ', $got(saveArr[1]), 'warning');
            } else {
                if (saveArr[1] || '' !== '') {
                    $.messager.alert('��ʾ', $got(saveArr[1]), 'info');
                } else {
                    $.messager.popover({
                        msg: '�ɹ�',
                        type: 'success'
                    });
                    Query();
                }
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
        function (jsonData) {
            $('#dateOrdStart').datebox('setValue', jsonData.OrdStDate);
            $('#dateOrdEnd').datebox('setValue', jsonData.OrdEdDate);
            $('#datePrtStart').datebox('setValue', jsonData.PrtStDate);
            $('#datePrtEnd').datebox('setValue', jsonData.PrtEdDate);
            var packReqNeedAudit = tkMakeServerCall('web.DHCSTPIVAS.Settings', 'GetAppParamProp', '', SessionLoc, '', 'PackReqAudit');
            if (jsonData.ReqNeedAudit == 'Y' || packReqNeedAudit == 'Y') {
                $('#tdReqNeedAudit').css('display', 'inline-block');
            }
            PIVAS.VAR.MaxDrugCnt = jsonData.MaxDrugCnt;
        }
    );
}

function PrintTable() {
    var title = session['LOGON.CTLOCDESC'] + '��Һ�ۺϲ�ѯ��ӡ�嵥';
    var prtArr = $('#gridGenerally').datagrid('getChecked');
    if (prtArr.length === 0) {
        $.messager.popover({
            msg: '�빴ѡ��Ҫ��ӡ�ļ�¼',
            type: 'alert'
        });
        return;
    }
    var WBLODOP = getLodop();
    WBLODOP.PRINT_INIT('��Һ�ۺϲ�ѯ��ӡ�嵥');

    var htmlArr = [];
    htmlArr.push('<style>');
    htmlArr.push('div{font-size:14px;white-space: nowrap;}');
    htmlArr.push('</style>');

    htmlArr.push('<table  border=0 style="width:190mm;border-collapse:collapse;table-layout:fixed;">');
    htmlArr.push('<tr style="visibility:hidden;">');
    htmlArr.push(' <td style="width:190mm;height:0px;"></td>');
    htmlArr.push('</tr">');
    htmlArr.push('<tr>');
    htmlArr.push('    <td style="font-weight:bold;width:190mm;border:0">');
    htmlArr.push('        <div style="height:20px;line-height: 20px;;text-align:center;padding-top:5mm;">');
    htmlArr.push('            <span style="font-size:16px">' + title + ' </span>');
    htmlArr.push('        </div>');
    htmlArr.push('        <div>');
    htmlArr.push('         <div style="padding:2mm;float:left;">');
    htmlArr.push('            <span>��ҩ���ڣ�' + $('#dateOrdStart').datebox('getValue') + ' �� ' + $('#dateOrdEnd').datebox('getValue') + ' </span>');
    htmlArr.push('         </div>');
    htmlArr.push('         <div style="float:right;;padding:2mm;">');
    htmlArr.push('            <span>��ӡʱ�䣺' + PIVAS.GetDate() + ' </span>' + '<span>����ӡ�ˣ�' + PIVAS.GetTime() + ' </span>');
    htmlArr.push('         </div>');
    htmlArr.push('        </div>');
    htmlArr.push('    </td>');
    htmlArr.push('</tr>');
    for (var i = 0, len = prtArr.length; i < len; i++) {
        var rowData = prtArr[i];
        var doseDateTime = rowData.doseDateTime;
        var pNo = rowData.pNo.trim();
        var wardDesc = rowData.wardDesc;
        var bedNoName = rowData.bedNo + '��' + rowData.patName + '��' + rowData.patNo;
        var batNo = rowData.batNo;
        var freqDesc = rowData.freqDesc;
        var mBarCode = rowData.barCode;
        var batNo = rowData.batNo;
        if (batNo.indexOf('��') < 0) {
            batNo += '��';
        }
        if (rowData.packFlag === 'P') {
            batNo += '�����';
        }
        htmlArr.push('<tr>');
        htmlArr.push('    <td style="font-weight:bold;width:190mm;border:0;border-top:1px solid #000;">');
        htmlArr.push('        <div style="height:20px;line-height: 20px;padding-top:2mm;">');
        htmlArr.push('             <div style="float:left;width:10mm;font-weight:bold;">' + pNo + '</div>');
        htmlArr.push('             <div style="float:left;width:40mm;">' + wardDesc + '</div>');
        htmlArr.push('             <div style="float:left;"> ' + bedNoName + '</div>');
        htmlArr.push('             <div style="float:right;;padding-right:5mm;;"> ' + mBarCode + '</div>');
        htmlArr.push('             <div style="float:right;padding-right:5mm;">' + batNo + '</div>');
        htmlArr.push('             <div style="float:right;padding-right:5mm;"> ' + doseDateTime + '��' + freqDesc + '</div>');
        htmlArr.push('        </div>');
        htmlArr.push('    </td>');
        htmlArr.push('</tr>');
        var drugsArr = JSON.parse(rowData.drugsArr);
        for (var j = 0, jLen = drugsArr.length; j < jLen; j++) {
            var drugRow = drugsArr[j];
            var borderLine = j === 0 ? 'border-top:1px dashed #000;' : '';
            htmlArr.push('<tr>');
            htmlArr.push('    <td style=";width:190mm;border:0;">');
            htmlArr.push('        <div style="height:20px;line-height: 20px;padding-top:2mm;margin-left:10mm;' + borderLine + ';">');
            htmlArr.push('             <div style="float:left;width:100mm;">' + drugRow.inciDesc + '</div>');
            htmlArr.push('             <div style="float:left;width:50mm;">' + drugRow.dosage + '</div>');
            htmlArr.push('             <div style="float:left;width:30mm;">' + drugRow.qtyUom + '</div>');
            htmlArr.push('        </div>');
            htmlArr.push('    </td>');
            htmlArr.push('</tr>');
        }
    }
    htmlArr.push('<tr>');
    htmlArr.push('    <td style="border-top:1px solid #000;">');
    htmlArr.push('    </td>');
    htmlArr.push('</tr>');

    htmlArr.push('</table>');
    var htmlStr = htmlArr.join('');

    WBLODOP.ADD_PRINT_TABLE('2mm', '2mm', '100%', '100%', htmlStr);
    WBLODOP.SET_PRINT_PAGESIZE(3, '200mm', '10mm', '');
    //WBLODOP.PREVIEW();
    WBLODOP.PRINT();
    if (typeof App_MenuCsp !== 'undefined') {
        PHA_LOG.Operate({
            operate: 'P',
            logInput: JSON.stringify({ title: title }),
            // logInput: logParams,
            type: 'page',
            pointer: App_MenuCsp,
            origData: '',
            remarks: App_MenuName
        });
    }
}