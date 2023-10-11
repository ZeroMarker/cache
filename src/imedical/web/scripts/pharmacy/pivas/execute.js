/**
 * ģ��: 	 ��Һ״ִ̬��
 * ��д����: 2018-03-16
 * ��д��:   yunhaibao
 */
var PIVAS_EXECUTE_NS = function () {
    var SessionLoc = session['LOGON.CTLOCID'];
    var SessionUser = session['LOGON.USERID'];
    var SessionWard = session['LOGON.WARDID'] || '';
    var DispPsArr = tkMakeServerCall('web.DHCSTPIVAS.Common', 'GetDispPsStr', SessionLoc, 'I').split('^');
    var PrtWardBatPS = ''; // ��ӡ���ӵ����̱�ʶ
    var PersonSameFields = '[field=patNo],[field=patName],[field=bedNo],[field=wardDesc]';
    var SameRowsHanlder = PIVAS.Grid.SameRows('gridOrdExe', PersonSameFields);
    if (SessionWard != '') {
        PIVAStateNumber = '90';
        $('#btnExecutePrt,#btnRefuse').hide();
    }
    PIVAS.Grid.Pagination();

    InitDict();
    InitGridOrdExe();
    $('#btnFind').on('click', Query);
    $('#btnRefresh').on('click', QueryOrdExe);
    $('#btnExecute').on('click', function () {
        SaveHandler(ExecuteHandler);
    });
    $('#btnExecutePrt').on('click', function () {
        SaveHandler(ExecutePrtHandler);
    });
    $('#btnPrtSelectDivOk').on('click', PrintHandler);
    $('#btnRefuse').on('click', RefusePog);

    $('#txtPatNo').on('keypress', function (event) {
        if (event.keyCode == '13') {
            var patNo = this.value;
            patNo = PIVAS.FmtPatNo(patNo);
            $(this).val(patNo);
            Query();
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
        PIVAS.CheckAll($('#gridOrdExe'));
    });
    $('#btnUnSelectAll').on('click', function () {
        PIVAS.UnCheckAll($('#gridOrdExe'));
    });
    InitPivasSettings();
    PIVAS.Session.More(session['LOGON.CTLOCID']);

    $('.dhcpha-win-mask').remove();

    // ======================================================== //

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
                    ChangeDOMByPS();
                    Query();
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
            // $('#DivBatNo').html('����' + $g('����'));
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
                    field: 'warnInfo', // todo �޸���ʾ��ʽ����
                    title: '����',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'wardDesc',
                    title: '����',
                    width: 150,
                    hidden: false
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
                    field: 'doseDateTime',
                    title: '��ҩ����',
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
                    field: 'ordRemark',
                    title: '��ע',
                    width: 75,
                    formatter: PIVAS.Grid.Formatter.OrdRemarkGroup
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
                    field: 'priDesc',
                    title: '���ȼ�',
                    width: 75
                },
                {
                    field: 'workTypeDesc',
                    title: '������',
                    width: 75
                },
                {
                    field: 'pivaCatDesc',
                    title: '��Һ����',
                    width: 100
                },

                {
                    field: 'packFlag',
                    title: '���',
                    width: 85,
                    hidden: true
                },

                {
                    field: 'barCode',
                    title: '����',
                    width: 125
                },
                {
                    field: 'psDesc',
                    title: '��ǰ״̬',
                    width: 75
                },
                {
                    field: 'passResultDesc',
                    title: '��˽��',
                    width: 85
                },
                {
                    field: 'mDsp',
                    title: 'mDsp',
                    width: 70,
                    hidden: true
                },
                {
                    field: 'pog',
                    title: 'pog',
                    width: 70,
                    hidden: true
                },
                {
                    field: 'check',
                    title: 'check',
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
            url: '',
            fit: true,
            toolbar: '#gridOrdExeBar',
            rownumbers: false,
            columns: columns,
            pageSize: 300,
            pageList: [300, 500, 1000],
            pagination: true,
            singleSelect: false,
            selectOnCheck: false,
            checkOnSelect: false,
            pageNumber: 1,
            nowrap: false,
            rowStyler: PIVAS.Grid.RowStyler.PersonAlt,
            onLoadSuccess: function (data) {
                var $grid = $(this);
                $grid.datagrid('options').checking = true;
                var row0Data = data.rows[0];
                if (row0Data) {
                    $grid.datagrid('checkAll');
                    var rows = $grid.datagrid('getRows');
                    var rowsLen = rows.length;
                    for (var index = rowsLen - 1; index >= 0; index--) {
                        var rowData = rows[index];
                        var check = rowData.check;
                        if (check != 'Y') {
                            $grid.datagrid('uncheckRow', index);
                        }
                    }
                } else {
                    $grid.datagrid('uncheckAll');
                }
                $grid.datagrid('scrollTo', 0);
                $grid.datagrid('options').checking = '';
                SameRowsHanlder.Hide();
                $grid.datagrid('loaded');
            },
            onClickRow: function (rowIndex, rowData) {
                SameRowsHanlder.ShowRow(rowIndex);
            },
            onBeforeSelect: function (rowIndex, rowData) {
                $(this).datagrid('unselectAll');
            },
            onCheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                SameRowsHanlder.UpdateRow(rowIndex, { check: 'Y' });
            },
            onUncheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                SameRowsHanlder.UpdateRow(rowIndex, { check: 'N' });
            },
            onCheckAll: PIVAS.Grid.onCheckAll,
            onUncheckAll: PIVAS.Grid.onUncheckAll,
            loadFilter: PIVAS.Grid.LoadFilter
        };
        PIVAS.Grid.Init('gridOrdExe', dataGridOption);
    }

    /// ��ʼ���������λ���
    function InitGridWardBat(locId) {
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Execute',
                MethodName: 'GetWardBatColumns',
                loc: locId
            },
            function (retJson) {
                var columnsArr = [
                    {
                        field: 'wardSelect',
                        checkbox: true
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
                    url: '',
                    border: false,
                    fit: true,
                    toolbar: [],
                    rownumbers: false,
                    columns: columns,
                    pagination: false,
                    singleSelect: false,
                    showFooter: true,
                    queryOnSelect: false,
                    onSelect: SelectQuery,
                    onUnselect: SelectQuery,
                    onClickCell: function (rowIndex, field, value) {
                        if (field !== 'wardSelect') {
                            $(this).datagrid('options').queryOnSelect = true;
                        }
                    },
                    onLoadSuccess: function (data) {
                        $(this).datagrid('loaded');
                        $(this).datagrid('uncheckAll');
                        $('#gridOrdExe').datagrid('clear');
                    }
                };
                PIVAS.Grid.Init('gridWardBat', dataGridOption);
                function SelectQuery(rowIndex, rowData) {
                    var $grid = $('#gridWardBat');
                    if ($grid.datagrid('options').queryOnSelect == true) {
                        $grid.datagrid('options').queryOnSelect = false;
                        QueryOrdExe();
                    }
                }
            }
        );
    }

    function Query() {
        var $grid = $('#gridWardBat');
        $grid.datagrid('clear');

        var pJson = Get.QueryParams();
        if (pJson.psNumber === '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('����ѡ��Ԥִ�е���Һ״̬'),
                type: 'alert'
            });
            return;
        }
        PIVAS.Grid.PageHandler($grid);
        var rowsData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Execute',
                MethodName: 'GetWardData',
                pJsonStr: JSON.stringify(pJson),
                rows: 9999,
                page: 1
            },
            false
        );
        $grid.datagrid('loading');
        setTimeout(function () {
            $grid.datagrid('loadData', rowsData);
        }, 100);
    }
    // ��ѯҽ����ϸ
    function QueryOrdExe() {
        var $grid = $('#gridOrdExe');
        $grid.datagrid('clear');

        var pJson = Get.QueryParams();
        var wardArr = Get.WardChecked();
        if (wardArr.length === 0) {
            return;
        }
        pJson.wardStr = wardArr.join(',');

        PIVAS.Grid.PageHandler($grid);
        var rowsData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Execute',
                QueryName: 'OrdExeData',
                pJsonStr: JSON.stringify(pJson),
                rows: 9999,
                page: 1
            },
            false
        );
        $grid.datagrid('loading');
        setTimeout(function () {
            $grid.datagrid('loadData', rowsData);
        }, 100);
    }

    var Get = {
        QueryParams: function () {
            var pJson = {};
            pJson.loc = $('#cmbPivaLoc').combobox('getValue') || '';
            pJson.wardStr = $('#cmbWard').combobox('getValue') || '';
            pJson.locGrp = $('#cmbLocGrp').combobox('getValue') || '';
            pJson.prtStartDate = $('#datePrtStart').datebox('getValue');
            pJson.prtEndDate = $('#datePrtEnd').datebox('getValue');
            pJson.ordStartDate = $('#dateOrdStart').datebox('getValue');
            pJson.ordEndDate = $('#dateOrdEnd').datebox('getValue');
            pJson.psNumber = $('#cmbPivaStat').combobox('getValue');
            pJson.pivaCat = $('#cmbPivaCat').combobox('getValue') || '';
            pJson.workType = $('#cmbWorkType').combobox('getValue') || '';
            pJson.priority = $('#cmbPriority').combobox('getValue') || '';
            pJson.inci = $('#cmgIncItm').combobox('getValue') || '';
            pJson.packFlag = $('#cmbPack').combobox('getValues').join(',');
            pJson.patNo = $('#txtPatNo').val().trim();
            pJson.batNoStr = this.BatNoChecked().join(',');
            pJson.pogsNo = $('#txtPrtNo').searchbox('getValue');
            return pJson;
        },
        WardChecked: function () {
            var retArr = [];
            var gridChecked = $('#gridWardBat').datagrid('getChecked');
            for (var i = 0; i < gridChecked.length; i++) {
                retArr.push(gridChecked[i].ward);
            }
            return retArr;
        },
        BatNoChecked: function () {
            var batNoArr = [];
            $('input[type=checkbox][name=batbox]').each(function () {
                if ($('#' + this.id).is(':checked')) {
                    batNoArr.push($('#' + this.id).attr('text'));
                }
            });
            return batNoArr;
        },
        PogChecked: function () {
            var retArr = [];
            var origRows = $('#gridOrdExe').datagrid('getData').originalRows;
            if (typeof origRows === 'undefined') {
                return retArr;
            }
            var len = origRows.length;
            for (var i = 0; i < len; i++) {
                var rowData = origRows[i];
                if (rowData.check === 'Y') {
                    retArr.push(origRows[i].pog);
                }
            }
            return retArr;
        }
    };

    function Execute(grpWay, printFlag) {
        grpWay = grpWay || '';
        printFlag = printFlag || '';
        var pogArr = Get.PogChecked();
        var psNumber = $('#cmbPivaStat').combobox('getValue');
        PIVAS.Progress.Show({
            type: 'save',
            interval: 1000
        });
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Execute',
                MethodName: 'SaveData',
                pogJsonStr: JSON.stringify(pogArr),
                user: SessionUser,
                psNumber: psNumber,
                grpWay: grpWay,
                dataType: 'text'
            },
            function (retData) {
                PIVAS.Progress.Close();
                if (retData.indexOf('msg') >= 0) {
                    $.messager.alert($g('��ʾ'), JSON.parse(retData).msg, 'error');
                    return;
                }
                var retArr = retData.split('^');
                if (retArr[0] == -1) {
                    $.messager.alert($g('��ʾ'), retArr[1], 'warning');
                } else if (retArr[0] < -1) {
                    $.messager.alert($g('��ʾ'), retArr[1], 'error');
                } else {
                    if (printFlag !== '') {
                        var pogsNoStr = retArr[1];
                        PrintWardBat(pogsNoStr, printFlag);
                    }
                }
                QueryOrdExe();
            }
        );
    }

    function RefusePog() {
        var pogArr = Get.PogChecked();
        if (pogArr.length == 0) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('�빴ѡ��Ҫ��Һ�ܾ��ļ�¼'),
                type: 'alert'
            });
            return;
        }
        $.messager.confirm($g('��ʾ'), $g('��ȷ����Һ�ܾ���?'), function (r) {
            if (r) {
                PIVAS.RefuseReasonWindow(
                    {
                        pogArr: pogArr,
                        user: SessionUser
                    },
                    QueryOrdExe
                );
            }
        });
    }

    // ���ݵ���ִ�в���ӡ���ӵ�
    function ExePrtWardBat(grpWay) {
        var geneNo = $('#txtGeneNo').val();
        if (geneNo == '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('δ��ѯ��ɨ���¼,�޷���ӡ'),
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
                    $.messager.alert($g('��ʾ'), JSON.parse(retData).msg, 'error');
                    return;
                }
                var retArr = retData.split('^');
                if (retArr[0] == -1) {
                    $.messager.alert($g('��ʾ'), retArr[1], 'warning');
                } else if (retArr[0] < -1) {
                    $.messager.alert($g('��ʾ'), retArr[1], 'error');
                } else {
                    PrintWardBat(retArr[1]);
                }
            }
        );
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
                //$('[name=genePOGSNo][value=' + jsonData.GeneWay + ']').radio('setValue', true);
                $('[name=prtPOGSWay][value=' + jsonData.PrtWay + ']').radio('setValue', true);
                PrtWardBatPS = 85;
                PIVAS.VAR.MaxDrugCnt = jsonData.MaxDrugCnt;
            }
        );
    }

    function ChangeDOMByPS() {
        var psNumber = $('#cmbPivaStat').combobox('getValue') || '';
        var psName = $('#cmbPivaStat').combobox('getText') || '';
        if (PrtWardBatPS != '' && PrtWardBatPS == psNumber) {
            $('#btnExecutePrt').show();
            $('#btnExecute').hide();
        } else {
            $('#btnExecutePrt').hide();
            $('#btnExecute').show();
        }
        $('#btnExecute .l-btn-text').text($g('ִ��') + psName);
        $('#btnExecute').linkbutton('options').text = $g('ִ��') + psName;
    }
    function SaveHandler(callFunc) {
        if (Get.PogChecked().length === 0) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('���ȹ�ѡԤִ�еļ�¼'),
                type: 'alert'
            });
            return;
        }
        var psNumber = $('#cmbPivaStat').combobox('getValue');
        if (psNumber == '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('��ѡ��ִ��״̬'),
                type: 'alert'
            });
            return;
        }
        if (DispPsArr.indexOf(psNumber) >= 0) {
            PIVAS.CACert('PHAPIVASExecute', callFunc);
        } else {
            callFunc();
        }
    }
    function PrintHandler() {
        var geneWay = 1; //$("input[name='genePOGSNo']:checked").val() || '';
        var prtWay = $("input[name='prtPOGSWay']:checked").val() || '';
        if (geneWay === '' || prtWay === '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('����ѡ���Ӧ��ʽ'),
                type: 'alert'
            });
            return;
        }
        Execute(geneWay, prtWay);
    }
    function ExecuteHandler() {
        $.messager.confirm($g('��ʾ'), $g('��ȷ��' + $('#btnExecute').linkbutton('options').text + '��?'), function (r) {
            if (r) {
                Execute(1, '');
            }
        });
    }
    function ExecutePrtHandler() {
        $('#prtSelectDiv').window('open');
    }
    function PrintWardBat(pogsNoStr, prtWay) {
        var printType = '';
        if (prtWay == 1) {
            printType = 'Inci';
        } else if (prtWay == 0) {
            printType = 'Total';
        }
        PIVASPRINT.WardBat.Handler({
            pogsNoArr: pogsNoStr.split('!!'),
            loc: $('#cmbPivaLoc').combobox('getValue'),
            rePrint: '',
            printType: printType
        });
        $('#prtSelectDiv').window('close');
    }
};
$(PIVAS_EXECUTE_NS);
