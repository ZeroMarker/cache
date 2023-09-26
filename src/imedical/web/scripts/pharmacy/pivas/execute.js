/**
 * ģ��: 	 ��Һ״ִ̬��
 * ��д����: 2018-03-16
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var SessionWard = session['LOGON.WARDID'] || '';
var ConfirmMsgInfoArr = [];
var NeedScroll = 'Y'; // �Ƿ���Ҫ������0��
var PrtWardBatPS = ''; // ��ӡ���ӵ����̱�ʶ
$(function () {
    if (SessionWard != '') {
        PIVAStateNumber = '90';
        $('#btnExecuteWBPrt,#btnExecutePrt,#btnPrtWardBat,#btnRefuse').hide();
        $('#btnScanClean').css('width', '376px');
    }
    $('.newScroll').mCustomScrollbar({
        theme: 'inset-2-dark',
        scrollInertia: 100
    });
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridOrdExe();
    //InitGridWardBat(SessionLoc);
    $('#btnFind').on('click', Query);
    $('#btnExecute').on('click', function () {
        if (ValidCanDo('gridOrdExe') == false) {
            return;
        }
        $.messager.confirm('��ʾ', '��ȷ��' + $('#btnExecute').linkbutton('options').text + '��?', function (r) {
            if (r) {
                Execute(1, '');
            }
        });
    });
    $('#btnExecutePrt').on('click', function () {
        if (ValidCanDo('gridOrdExe') == false) {
            return;
        }
        $.messager.confirm('��ʾ', '��ȷ��' + $('#btnExecutePrt').linkbutton('options').text + '��?', function (r) {
            if (r) {
                ConfirmGrpWay(Execute);
            }
        });
    });

    $('#btnExecuteWB').on('click', function () {
        if (ValidCanDo('gridWardBat') == false) {
            return;
        }
        $.messager.confirm('��ʾ', '��ȷ��' + $('#btnExecuteWB').linkbutton('options').text + '��?', function (r) {
            if (r) {
                ExecuteWB(1, '');
            }
        });
    });
    $('#btnExecuteWBPrt').on('click', function () {
        if (ValidCanDo('gridWardBat') == false) {
            return;
        }
        $.messager.confirm('��ʾ', '��ȷ��' + $('#btnExecuteWBPrt').linkbutton('options').text + '��?', function (r) {
            if (r) {
                ConfirmGrpWay(ExecuteWB);
            }
        });
    });
    $('#btnRefuse').on('click', RefusePog);
    $('#btnScanClean').on('click', function (e) {
        $.messager.confirm('��ʾ', '��ȷ��������?', function (r) {
            if (r) {
                PIVASSCAN.Clean();
            }
        });
    });
    $('#btnPrtWardBat').on('click', function () {
        ConfirmGrpWay(ExePrtWardBat);
    });
    $('#txtPatNo').on('keypress', function (event) {
        if (event.keyCode == '13') {
            var patNo = this.value;
            patNo = PIVAS.FmtPatNo(patNo);
            $(this).val(patNo);
            Query();
        }
    });
    $('#txtBarCode').on('keypress', function (event) {
        if (event.keyCode == '13') {
            var barCode = this.value;
            if (barCode == '') {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '����Ϊ��',
                    type: 'alert'
                });
                return;
            }
            var psNumber = $('#cmbPivaStat').combobox('getValue');
            if (psNumber == '') {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '����ѡ��ִ��״̬',
                    type: 'alert'
                });
                $('#txtBarCode').val('');
                return;
            }
            var pivaLocId = $('#cmbPivaLoc').combobox('getValue');
            if (pivaLocId == '') {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '����ѡ����Һ����',
                    type: 'alert'
                });
                $('#txtBarCode').val('');
                return;
            }
            var pogsNo = $('#txtGeneNo').val().trim();
            if (barCode != '' && pogsNo == '') {
                GenerateNo(psNumber, pogsNo);
                pogsNo = $('#txtGeneNo').val().trim();
            }
            if (barCode != '' && pogsNo == '') {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '����Ϊ��,���޷�ɨ��ִ��',
                    type: 'alert'
                });
                return;
            }
            var qParams = QueryParams('QueryScan');
            PIVASSCAN.Execute(barCode, psNumber, pivaLocId, pogsNo, qParams);
            $(this).val('');
        }
    });
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
    $('#btnSelectAll').on('click', function () {
        CheckRowsGlobal('', 'Y', 'Y');
    });
    $('#btnUnSelectAll').on('click', function () {
        CheckRowsGlobal('', 'N', 'Y');
    });
    InitPivasSettings();
    PIVAS.Session.More(session['LOGON.CTLOCID']);
    if (ExecuteWay != '') {
        $('#tabsExecute').tabs('select', ExecuteWay);
    }
    $('#imgScaning').attr('src', '../scripts_lib/hisui-0.1.0/dist/css/icons/scanning.png');
    $('.dhcpha-win-mask').remove();
});
window.onbeforeunload = function () {
    ClearTmpGlobal();
};

function InitDict() {
    var locNotify = PIVAS.Notify();
    // ��Һ����
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaLoc',
            Type: 'PivaLoc'
        },
        {
            editable: false,
            onLoadSuccess: function () {
                var datas = $('#cmbPivaLoc').combobox('getData');
                if (datas.length == 1) {
                    $('#cmbPivaLoc').combobox('select', datas[0].RowId);
                } else {
                    for (var i = 0; i < datas.length; i++) {
                        if (datas[i].RowId == SessionLoc) {
                            $('#cmbPivaLoc').combobox('select', datas[i].RowId);
                            break;
                        }
                    }
                }
            },
            onSelect: function (data) {
                locNotify.trigger();
            }
        }
    );
    // ��Һ����
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaCat',
            Type: 'PivaCat'
        },
        {}
    );
    // ������
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbLocGrp',
            Type: 'LocGrp'
        },
        {}
    );
    // ����
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbWard',
            Type: 'Ward'
        },
        {
            readonly: SessionWard != '' ? true : false,
            onLoadSuccess: function () {
                if (SessionWard != '') {
                    $('#cmbWard').combobox('setValue', SessionWard);
                }
            }
        }
    );
    // ҽ�����ȼ�
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPriority',
            Type: 'Priority'
        },
        {}
    );
    // ������
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbWorkType',
            Type: 'PIVAWorkType'
        },
        {
            onBeforeLoad: function (param) {
                param.inputStr = $('#cmbPivaLoc').combobox('getValue');
                param.filterText = param.q;
            }
        }
    );
    locNotify.listen(function () {
        $('#cmbWorkType').combobox('reload');
    });

    // ҩƷ
    PIVAS.ComboGrid.Init(
        {
            Id: 'cmgIncItm',
            Type: 'IncItm'
        },
        {}
    );
    // ���
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPack',
            Type: 'PackType'
        },
        {}
    );

    // ��Һ״̬
    PIVAS.ComboBox.Init(
        {
            Id: 'cmbPivaStat',
            Type: 'PIVAState'
        },
        {
            editable: false,
            readonly: PIVAStateNumber != '' ? true : false,
            onLoadSuccess: function () {
                if (PIVAStateNumber != '') {
                    var datas = $(this).combobox('getData');
                    for (var i = 0; i < datas.length; i++) {
                        if (datas[i].RowId == PIVAStateNumber) {
                            $(this).combobox('setValue', datas[i].RowId);
                            break;
                        }
                    }
                } else {
                    $(this).combobox('showPanel');
                }
            },
            onSelect: function (data) {
                ClearDetailContent();
                $('#txtGeneNo').val('');
                ChangeDOMByPS();
            },
            onBeforeLoad: function (param) {
                var noPs = '3,10';
                if (SessionWard == '') {
                    noPs += ',90';
                }
                param.inputStr = $('#cmbPivaLoc').combobox('getValue') + '^' + noPs + '^' + 'execute';
                param.filterText = param.q;
            }
        }
    );
    locNotify.listen(function () {
        $('#cmbPivaStat').combobox('reload');
    });
    locNotify.listen(function () {
        var locId = $('#cmbPivaLoc').combobox('getValue');
        $('#DivBatNo').html('��������');
        PIVAS.BatchNoCheckList({
            Id: 'DivBatNo',
            LocId: locId,
            Check: true,
            Pack: false
        });
        InitGridWardBat(locId);
    });
}

//��ʼ����ϸ�б�
function InitGridOrdExe() {
    var columns = [
        [
            {
                field: 'ordExeSelect',
                checkbox: true
            },
            {
                field: 'warnInfo',
                title: '����',
                width: 50,
                hidden: false
            },
            {
                field: 'pid',
                title: 'pid',
                width: 150,
                hidden: true
            },
            {
                field: 'wardDesc',
                title: '����',
                width: 150,
                hidden: false
            },
            {
                field: 'doseDateTime',
                title: '��ҩ����',
                width: 95
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
                width: 100
            },
            {
                field: 'batNo',
                title: '����',
                width: 50,
                styler: function (value, row, index) {
                    var colorStyle = '';
                    if (row.packFlag != '') {
                        colorStyle = PIVAS.Grid.CSS.BatchPack;
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
                title: 'ҩƷ',
                width: 250,
                styler: PIVAS.Grid.Styler.IncDesc
            },
            {
                field: 'incSpec',
                title: '���',
                width: 100
            },
            {
                field: 'dosage',
                title: '����',
                width: 75
            },
            {
                field: 'qty',
                title: '����',
                width: 50,
                halign: 'left',
                align: 'right'
            },
            {
                field: 'freqDesc',
                title: 'Ƶ��',
                width: 75
            },
            {
                field: 'instrucDesc',
                title: '�÷�',
                width: 80
            },
            {
                field: 'bUomDesc',
                title: '��λ',
                width: 50
            },
            {
                field: 'docName',
                title: 'ҽ��',
                width: 75,
				hidden:true
            },
            {
                field: 'passResultDesc',
                title: '��˽��',
                width: 85
            },
            {
                field: 'priDesc',
                title: '���ȼ�',
                width: 75
            },
            {
                field: 'packFlag',
                title: '���',
                width: 85,
                hidden: true
            },
            {
                field: 'ordRemark',
                title: '��ע',
                width: 75
            },
            {
                field: 'barCode',
                title: '����',
                width: 125
            },
            {
                field: 'mDsp',
                title: 'mDsp',
                width: 70,
                hidden: true
            },
            {
                field: 'colColor',
                title: 'colColor',
                width: 50,
                hidden: true
            }, // ����˳��\��治��\������\������װ
            {
                field: 'pogId',
                title: 'pogId',
                width: 70,
                hidden: false
            },
            {
                field: 'incDescStyle',
                title: 'incDescStyle',
                width: 70,
                hidden: true
            },
            {
                field: 'check',
                title: 'check',
                width: 50,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: PIVAS.URL.COMMON + '?action=JsGetExecuteDetail',
        fit: true,
        toolbar: '#gridOrdExeBar',
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 200],
        pagination: true,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        rowStyler: function (index, rowData) {
            return PIVAS.Grid.RowStyler.Person(index, rowData, 'patNo');
        },
        onLoadSuccess: function (data) {
            $(this).datagrid('options').checking = true;
            var row0Data = data.rows[0];
            if (row0Data) {
                $(this).datagrid('checkAll');
                var pid = row0Data.pid;
                $('#gridOrdExe').datagrid('options').queryParams.pid = pid;
                var rows = $(this).datagrid('getRows');
                var rowsLen = rows.length;
                for (var index = rowsLen - 1; index >= 0; index--) {
                    var rowData = rows[index];
                    var check = rowData.check;
                    if (check != 'Y') {
                        $(this).datagrid('uncheckRow', index);
                    }
                }
            } else {
                $(this).datagrid('uncheckAll');
            }
            if (NeedScroll == 'Y') {
                $(this).datagrid('scrollTo', 0);
                NeedScroll = 'Y';
            }
            $(this).datagrid('options').checking = '';
        },
        onClickRow: function (rowIndex, rowData) {},
        /*
        onClickCell: function (rowIndex, field, value) {
            if ((field == "batNo") && (value != "")) {
                var mDsp = $('#gridOrdExe').datagrid('getData').rows[rowIndex].mDsp;
                PIVAS.UpdateBatNoWindow({
                    LocId: SessionLoc,
                    MDsp: mDsp,
                    GridId: "gridOrdExe",
                    Field: "batNo",
                    CurRowIndex: rowIndex
                })
            }
        },
        */
        onCheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            $(this).datagrid('options').checking = true;
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId
            });
            CheckRowsGlobal(rowData.pogId, 'Y');
            $(this).datagrid('options').checking = '';
        },
        onUncheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            $(this).datagrid('options').checking = true;
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: false,
                Value: rowData.pogId
            });
            CheckRowsGlobal(rowData.pogId, 'N');
            $(this).datagrid('options').checking = '';
        },
        onSelect: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId,
                Type: 'Select'
            });
            $(this).datagrid('options').checking = '';
        },
        onUnselect: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'pogId',
                Check: true,
                Value: rowData.pogId,
                Type: 'Select'
            });
            $(this).datagrid('options').checking = '';
        },
        onCheckAll: function (rows) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            CheckPage(rows, 'Y');
        },
        onUncheckAll: function (rows) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            CheckPage(rows, 'N');
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridOrdExe', dataGridOption);
}

/// ��ʼ���������λ���
function InitGridWardBat(locId) {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Execute',
            MethodName: 'ColumnsWardBat',
            locId: locId
        },
        function (retJson) {
            var columnsArr = [
                {
                    field: 'ordExeSelect',
                    checkbox: true
                },
                {
                    field: 'pid',
                    title: 'pid',
                    width: 50,
                    hidden: true
                }
            ];
            for (var i = 0; i < retJson.length; i++) {
                var retJsonI = retJson[i];
                if (retJsonI.field.indexOf('batNo') >= 0) {
                    retJsonI.styler = function (value, row, index) {
                        if (parseInt(value) > 0) {
                            return 'font-weight:bold;';
                        }
                    };
                }
                columnsArr.push(retJsonI);
            }
            var columns = [columnsArr];
            var dataGridOption = {
                url: PIVAS.URL.COMMON + '?action=JsGetExecuteWardBat',
                fit: true,
                toolbar: '#gridWardBatBar',
                rownumbers: true,
                columns: columns,
                pagination: false,
                singleSelect: false,
                showFooter: true,
                onLoadSuccess: function (data) {
                    var row0Data = data.rows[0];
                    if (row0Data) {
                        var pid = row0Data.pid;
                        $('#gridWardBat').datagrid('options').queryParams.pid = pid;
                    }
                }
            };
            DHCPHA_HUI_COM.Grid.Init('gridWardBat', dataGridOption);
        }
    );
}

function Query() {
    var tabTitle = $('#tabsExecute').tabs('getSelected').panel('options').title;
    if (tabTitle == 'ҽ����ϸ') {
        QueryOrdExe();
    } else if (tabTitle == '��������') {
        QueryWardBat();
    } else if (tabTitle == 'ɨ������') {
        PIVASSCAN.Clean();
        PIVASSCAN.CalcuWard('');
    }
}
// ��ѯҽ����ϸ
function QueryOrdExe() {
    ClearTmpGlobal('gridOrdExe');
    var params = QueryParams('QueryOrdExe');
    if (params == '') {
        return;
    }
    $('#gridOrdExe').datagrid('load', {
        params: params,
        pid: ''
    });
}

// ��ѯ�������λ���
function QueryWardBat() {
    ClearTmpGlobal('gridWardBat');
    var params = QueryParams('QueryWardBat');
    if (params == '') {
        return;
    }
    $('#gridWardBat').datagrid('load', {
        params: params,
        pid: ''
    });
}
// ��ȡ��ѯ����
// flag==QueryOrdExe   flag==QueryScan flag=QueryWardBat
function QueryParams(flag) {
    var pivaLocId = $('#cmbPivaLoc').combobox('getValue') || ''; // 1-��Һ����
    var wardId = $('#cmbWard').combobox('getValue') || ''; // 2-����
    var prtStartDate = $('#datePrtStart').datebox('getValue'); // 3-��ǩ��ʼ����
    var prtEndDate = $('#datePrtEnd').datebox('getValue'); // 4-��ǩ��������
    var ordStartDate = $('#dateOrdStart').datebox('getValue'); // 5-��ҩ��ʼ����
    var ordEndDate = $('#dateOrdEnd').datebox('getValue'); // 6-��ҩ��������
    var psNumber = $('#cmbPivaStat').combobox('getValue') || ''; // 7-��ҺԤִ��״̬
    var locGrpId = $('#cmbLocGrp').combobox('getValue') || ''; // 8-������
    var pivaCat = $('#cmbPivaCat').combobox('getValue') || ''; // 9-��Һ����
    var workType = $('#cmbWorkType').combobox('getValue') || ''; // 10-��������
    var priority = $('#cmbPriority').combobox('getValue') || ''; // 11-ҽ�����ȼ�
    var incId = $('#cmgIncItm').combobox('getValue') || ''; // 12-ҩƷ
    var packFlag = $('#cmbPack').combobox('getValues') || ''; // 13-�������
    var patNo = $('#txtPatNo').val().trim(); // 14-�ǼǺ�
    var prtNo = $('#txtPrtNo').searchbox('getValue'); // 15-��ӡ��ǩ����
    var batNoStr = ''; // 16-����
    $('input[type=checkbox][name=batbox]').each(function () {
        if ($('#' + this.id).is(':checked')) {
            if (batNoStr == '') {
                batNoStr = this.value;
            } else {
                batNoStr = batNoStr + ',' + this.value;
            }
        }
    });
    if (pivaLocId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ����Һ����',
            type: 'alert'
        });
        return '';
    }
    if (psNumber == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ����Һ״̬',
            type: 'alert'
        });
        return '';
    }
    if (batNoStr == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ������',
            type: 'alert'
        });
        return '';
    }
    // tab title
    var tabTitle = $('#tabsExecute').tabs('getSelected').panel('options').title;
    var params =
        pivaLocId +
        '^' +
        wardId +
        '^' +
        prtStartDate +
        '^' +
        prtEndDate +
        '^' +
        ordStartDate +
        '^' +
        ordEndDate +
        '^' +
        psNumber +
        '^' +
        locGrpId +
        '^' +
        pivaCat +
        '^' +
        workType +
        '^' +
        priority +
        '^' +
        incId +
        '^' +
        packFlag +
        '^' +
        patNo +
        '^' +
        prtNo +
        '^' +
        batNoStr;
    return params;
}

function Execute(grpWay, printFlag) {
    grpWay = grpWay || '';
    printFlag = printFlag || '';
    var pogIdStr = GetCheckPOGIdStr('');
    if (pogIdStr == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '�빴ѡ��Ҫȷ��ִ�е�ҽ������',
            type: 'alert'
        });
        return;
    }
    var psNumber = $('#cmbPivaStat').combobox('getValue');
    if (psNumber == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ��ִ��״̬',
            type: 'alert'
        });
        return;
    }
    PIVAS.Progress.Show({
        type: 'save',
        interval: 1000
    });
    $.m(
        {
            ClassName: 'web.DHCSTPIVAS.Execute',
            MethodName: 'SaveDataByPog',
            pogIdStr: pogIdStr,
            userId: SessionUser,
            psNumber: psNumber,
            grpWay: grpWay
        },
        function (retData) {
            PIVAS.Progress.Close();
            if (retData.indexOf('msg') >= 0) {
                $.messager.alert('��ʾ', JSON.parse(retData).msg, 'error');
                return;
            }
            var retArr = retData.split('^');
            if (retArr[0] == -1) {
                $.messager.alert('��ʾ', retArr[1], 'warning');
            } else if (retArr[0] < -1) {
                $.messager.alert('��ʾ', retArr[1], 'error');
            } else {
                if (printFlag == 'Y') {
                    var pogsNoStr = retArr[1];
                    PrintWardBat(pogsNoStr);
                }
            }
            QueryOrdExe();
        }
    );
}

function ExecuteWB(grpWay, printFlag) {
    grpWay = grpWay || '';
    printFlag = printFlag || '';
    var wardIdStr = GetWardIdStr();
    if (wardIdStr == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '�빴ѡ��Ҫȷ��ִ�еĲ���',
            type: 'alert'
        });
        return;
    }
    var pid = $('#gridWardBat').datagrid('getRows')[0].pid;
    if (pid == '') {
        $.messager.alert('��ʾ', '��ȡ��������,���ѯ������', 'warning');
        return;
    }
    var psNumber = $('#cmbPivaStat').combobox('getValue');
    if (psNumber == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '��ѡ��ִ��״̬',
            type: 'alert'
        });
        return;
    }
    PIVAS.Progress.Show({
        type: 'save',
        interval: 1000
    });
    $.m(
        {
            ClassName: 'web.DHCSTPIVAS.Execute',
            MethodName: 'SaveDataByPid',
            pid: pid,
            wardIdStr: wardIdStr,
            userId: SessionUser,
            psNumber: psNumber,
            grpWay: grpWay
        },
        function (retData) {
            PIVAS.Progress.Close();
            if (retData.indexOf('msg') >= 0) {
                $.messager.alert('��ʾ', JSON.parse(retData).msg, 'error');
                return;
            }
            var retArr = retData.split('^');
            if (retArr[0] == -1) {
                $.messager.alert('��ʾ', retArr[1], 'warning');
            } else if (retArr[0] < -1) {
                $.messager.alert('��ʾ', retArr[1], 'error');
            } else {
                if (printFlag == 'Y') {
                    var pogsNoStr = retArr[1];
                    PrintWardBat(pogsNoStr);
                }
            }
            QueryWardBat();
        }
    );
}

function RefusePog() {
    if (ValidCanDo('gridOrdExe') == false) {
        return;
    }
    $.messager.confirm('��ʾ', '��ȷ����Һ�ܾ���?', function (r) {
        if (r) {
            var pogIdStr = GetPogIdStr('RefusePog');
            if (pogIdStr == '') {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: '�빴ѡ��Ҫ��Һ�ܾ���ҽ������',
                    type: 'alert'
                });
                return;
            }
            PIVAS.RefuseReasonWindow(
                {
                    pogIdStr: pogIdStr,
                    userId: SessionUser
                },
                QueryOrdExe
            );
        }
    });
}

// ����������漰��������ʱglobal
function ClearTmpGlobal(type) {
    type = type || '';
    if (type == 'gridOrdExe' || type == '') {
        var pid = $('#gridOrdExe').datagrid('options').queryParams.pid || '';
        tkMakeServerCall('web.DHCSTPIVAS.Execute', 'KillCollectExecuteData', pid);
    }
    if (type == 'gridWardBat' || type == '') {
        var pid = $('#gridWardBat').datagrid('options').queryParams.pid || '';
        tkMakeServerCall('web.DHCSTPIVAS.Execute', 'KillSaveData', pid);
    }
}

function ClearDetailContent() {
    ClearTmpGlobal('');
    $('#gridOrdExe').datagrid('clear');
    $('#gridWardBat').datagrid('clear');
    $('#scan-total').text(0);
    $('#unscan-total').text(0);
    $('#scaned-total').text(0);
    $('#scan-ward').text('');
}

// ��ȡѡ�е�ҽ����ϸPog��
function GetPogIdStr(getType) {
    var pogIdArr = [];
    var gridOrdExeChecked = $('#gridOrdExe').datagrid('getChecked');
    for (var i = 0; i < gridOrdExeChecked.length; i++) {
        var checkedData = gridOrdExeChecked[i];
        var pogId = checkedData.pogId;
        if (pogIdArr.indexOf(pogId) < 0) {
            pogIdArr.push(pogId);
        }
    }
    return pogIdArr.join('^');
}
// ��ȡѡ�еĲ���Id��
function GetWardIdStr() {
    var wardIdArr = [];
    var gridWardBatChecked = $('#gridWardBat').datagrid('getChecked');
    for (var i = 0; i < gridWardBatChecked.length; i++) {
        var checkedData = gridWardBatChecked[i];
        var wardId = checkedData.wardId;
        if (wardIdArr.indexOf(wardId) < 0) {
            wardIdArr.push(wardId);
        }
    }
    return wardIdArr.join('^');
}
// ���ɵ���
function ConfirmGenerateNo() {
    var psNumber = $('#cmbPivaStat').combobox('getValue');
    if (psNumber == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '����ѡ������״̬',
            type: 'alert'
        });
        return;
    }
    var pivaLocId = $('#cmbPivaLoc').combobox('getValue');
    if (pivaLocId == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '����ѡ����Һ����',
            type: 'alert'
        });
        return;
    }
    $.messager.confirm('��ʾ', '��ȷ�� <b>' + '����' + ' </b>��?', function (r) {
        if (r) {
            $('#txtGeneNo').val('');
            // GenerateNo(psNumber, pivaLocId);
        }
    });
}

function GenerateNo(psNumber, pivaLocId) {
    var geneNoRet = tkMakeServerCall('web.DHCSTPIVAS.Common', 'GetAppNo', psNumber, pivaLocId);
    var geneNoArr = geneNoRet.split('^');
    var geneNo = geneNoArr[0];
    if (geneNo == '-1') {
        $.messager.alert('��ʾ', geneNoArr[0], 'error');
        return;
    }
    $('#txtGeneNo').val(geneNo);
}

// ���ݵ���ִ�в���ӡ���ӵ�
function ExePrtWardBat(grpWay) {
    var geneNo = $('#txtGeneNo').val();
    if (geneNo == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: 'δ��ѯ��ɨ���¼,�޷���ӡ',
            type: 'alert'
        });
        return;
    }
    PIVAS.Progress.Show({
        type: 'save',
        interval: 1000
    });
    $.m(
        {
            ClassName: 'web.DHCSTPIVAS.Execute',
            MethodName: 'SaveDataByPOGSNo',
            pogsNo: geneNo,
            userId: SessionUser,
            psNumber: PrtWardBatPS
        },
        function (retData) {
            PIVAS.Progress.Close();
            if (retData.indexOf('msg') >= 0) {
                $.messager.alert('��ʾ', JSON.parse(retData).msg, 'error');
                return;
            }
            var retArr = retData.split('^');
            if (retArr[0] == -1) {
                $.messager.alert('��ʾ', retArr[1], 'warning');
            } else if (retArr[0] < -1) {
                $.messager.alert('��ʾ', retArr[1], 'error');
            } else {
                PrintWardBat(retArr[1]);
            }

            //������ӡ
        }
    );
}

function PrintWardBat(pogsNoStr) {
    var paramsArr = PIVASPRINT.DefaultParams.WardBat();
    paramsArr[0] = $('#cmbPivaLoc').combobox('getValue');
    paramsArr[20] = pogsNoStr;
    var raqObj = {
        raqName: 'DHCST_PIVAS_�������ӵ�.raq',
        raqParams: {
            startDate: $('#dateOrdStart').datebox('getValue'),
            endDate: $('#dateOrdEnd').datebox('getValue'),
            userName: session['LOGON.USERNAME'],
            pivaLoc: session['LOGON.CTLOCID'],
            hospDesc: PIVAS.Session.HOSPDESC,
            locDesc: $('#cmbPivaLoc').combobox('getText'),
            inputStr: paramsArr.join('^'),
            pid: ''
        },
        isPreview: 1
    };
    PIVASPRINT.RaqPrint(raqObj);
}
// ��ʼ��Ĭ������
function InitPivasSettings() {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Settings',
            MethodName: 'GetAppProp',
            userId: session['LOGON.USERID'],
            locId: session['LOGON.CTLOCID'],
            appCode: 'Execute'
        },
        function (jsonData) {
            $('#dateOrdStart').datebox('setValue', jsonData.OrdStDate);
            $('#dateOrdEnd').datebox('setValue', jsonData.OrdEdDate);
            $('#datePrtStart').datebox('setValue', jsonData.PrtStDate);
            $('#datePrtEnd').datebox('setValue', jsonData.PrtEdDate);
            PrtWardBatPS = jsonData.PrtWardBatPS;
        }
    );
}

function CheckPage(rows, flag) {
    if (rows == '') {
        return;
    }
    var pogIdArr = [];
    var pogId = '';
    for (var i in rows) {
        pogId = rows[i].pogId;
        if (pogId == '') {
            continue;
        }
        if (pogIdArr.indexOf(pogId) >= 0) {
            continue;
        }
        pogIdArr.push(pogId);
    }
    var pogIdStr = pogIdArr.join('^');
    if (pogIdStr == '') {
        return;
    }
    CheckRowsGlobal(pogIdStr, flag);
}

function CheckRowsGlobal(pogIdStr, flag, all) {
    $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Execute',
            MethodName: 'CheckRows',
            POGIdStr: pogIdStr,
            Flag: flag,
            Pid: $('#gridOrdExe').datagrid('options').queryParams.pid || '',
            All: all || '',
            dataType: 'text'
        },
        false
    );
    if (all == 'Y') {
        NeedScroll = '';
        $('#gridOrdExe').datagrid('reload');
    }
}

function GetCheckPOGIdStr(allFlag) {
    var pogIdStr = $.cm(
        {
            ClassName: 'web.DHCSTPIVAS.Execute',
            MethodName: 'GetSavePOGIdStr',
            Pid: $('#gridOrdExe').datagrid('options').queryParams.pid || '',
            dataType: 'text'
        },
        false
    );
    return pogIdStr;
}

function ConfirmGrpWay(callBack) {
    var winId = 'PIVAS_UX_ConfirmGrpWay';
    var html = '';
    html += '<div id=' + winId + ' style="padding:20px;text-align:center">';
    html += '   <div><a class="hisui-linkbutton" style="width:100%">��������ӡ</a></div>';
    html += '   <div style="padding-top:20px"><a class="hisui-linkbutton" style="width:100%">�����������δ�ӡ</a></div>';
    html += '</div>';
    $('body').append(html);
    $('#' + winId)
        .window({
            title: ' ��ӡ��ʽ',
            collapsible: false,
            iconCls: 'icon-w-print',
            border: false,
            closed: false,
            modal: true,
            width: 300,
            height: 160,
            minimizable: false,
            maximizable: false,
            onClose: function () {
                $(this).window('destroy');
            }
        })
        .window('open');
    $('#' + winId + ' a').linkbutton({
        onClick: function () {
            $('#' + winId).window('close');
            if (this.text.indexOf('����') >= 0) {
                callBack('2', 'Y');
            } else {
                callBack('1', 'Y');
            }
        }
    });
}

function ChangeDOMByPS() {
    var psNumber = $('#cmbPivaStat').combobox('getValue') || '';
    var psName = $('#cmbPivaStat').combobox('getText') || '';
    if (PrtWardBatPS != '' && PrtWardBatPS == psNumber) {
        $('#btnExecuteWBPrt,#btnExecutePrt').show();
    } else {
        $('#btnExecuteWBPrt,#btnExecutePrt').hide();
    }
    $('#btnExecuteWB .l-btn-text,#btnExecute .l-btn-text').text('ִ��' + psName);
    $('#btnExecuteWB,#btnExecute').linkbutton('options').text = 'ִ��' + psName;
}

function ValidCanDo(gridId) {
    if ($('#' + gridId).datagrid('getRows') == '') {
        DHCPHA_HUI_COM.Msg.popover({
            msg: '������������',
            type: 'alert'
        });
        return false;
    }
    return true;
}
