/**
 * ģ��:	סԺ��Һ - ��Һ��ǩ
 * ��д����:2018-02-27
 * ��д��:  yunhaibao
 */
var PIVAS_LABELPRINT_NS = function () {
    var PrintWithArrFlag;
    var SessionLoc = session['LOGON.CTLOCID'];
    var SessionUser = session['LOGON.USERID'];
    var PersonSameFields = '[field=patNo],[field=patName],[field=bedNo],[field=wardDesc]';
    var SameRowsHanlder = PIVAS.Grid.SameRows('gridOrdExe', PersonSameFields);
    var GridCmbBatNo;
    var CanMultiAddData = ['��ҩ', '��ý', 'ҩƷ', '��ҩ', '����'];
    var QtyNeedLinkData = ['��ҩ', '��ý', 'ҩƷ', '��ҩ'];
    var PrtDictData = {
        rows: [
            {
                prtWayDesc: '����'
            },
            {
                prtWayDesc: '����'
            },
            {
                prtWayDesc: '����'
            },
            {
                prtWayDesc: '�ǼǺ�'
            },
            {
                prtWayDesc: '��ҩ'
            },
            {
                prtWayDesc: '��ý'
            },
            {
                prtWayDesc: '����'
            },
            {
                prtWayDesc: '��Һ����'
            }
        ]
    };

    /* =============================================================================*/

    InitDict();
    InitPivasSettings();
    InitGridWard();
    InitGridAdm();
    InitGridWorkType();
    InitGridOrdExe();
    InitGridPrtDict();
    InitGridPrtWay();
    InitGridTotal();
    $('#btnFind').on('click', Query);
    $('#btnFindDetail').on('click', QueryOrdExe);
    $('#btnPrint,#btnPrintWithArr').on('click', ConfirmSaveData);
    $('#btnSavePrint').on('click', SaveData);

    $('#btnPack').on('click', function () {
        PackSelectDsp('P');
    });
    $('#btnUnPack').on('click', function () {
        PackSelectDsp('');
    });
    $('#txtPatNo').searchbox({
        prompt: $g('������ǼǺ�...'),
        width: 268,
        searcher: GetPatAdmList
    });

    $('#btnSelectAll').on('click', function () {
        PIVAS.CheckAll($('#gridOrdExe'));
    });
    $('#btnUnSelectAll').on('click', function () {
        PIVAS.UnCheckAll($('#gridOrdExe'));
    });
    setTimeout(function () {
        getLodop();
    }, 2000);

    // $('#btnSum').on('click', SumHandler);

    $('#btnPrtConfig').on('click', PrtConfigHandler);
    $('#btnCfgDefault').on('click', function () {
        $('#gridWorkType').datagrid('reload');
    });
    $('#btnCfgOk').on('click', function () {
        UpdateWorkTypePrtWay();
    });
    $('#btnCfgCancel').on('click', function () {
        $('#gridWorkType').datagrid('reload');
        $('#gridWorkTypeWin').window('close');
    });

    /* =============================================================================*/

    function InitDict() {
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
            {}
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
            {}
        );
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
        // �÷�
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbInstruc',
                Type: 'Instruc'
            },
            {}
        );
        // ����
        PIVAS.BatchNoCheckList({
            Id: 'DivBatNo',
            LocId: SessionLoc,
            Check: true,
            Pack: false
        });
        // ��Ա
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbNeedUser30',
                Type: 'LocUser'
            },
            {}
        );
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbNeedUser40',
                Type: 'LocUser'
            },
            {}
        );
        PIVAS.ComboBox.Init(
            {
                Id: 'cmbNeedUser50',
                Type: 'LocUser'
            },
            {}
        );
        GridCmbBatNo = PIVAS.UpdateBatNoCombo({
            LocId: SessionLoc,
            GridId: 'gridOrdExe',
            Field: 'batNo',
            BatUp: 'batUp',
            MDspField: 'mDsp',
            CallBack: function (rowIndex, rowData) {
                UpdateRow(rowIndex, rowData);
            }
        });
    }

    function InitGridWard() {
        var columns = [
            [
                {
                    field: 'wardSelect',
                    checkbox: true
                },
                {
                    field: 'wardId',
                    title: 'wardId',
                    hidden: true
                },
                {
                    field: 'wardDesc',
                    title: '����',
                    width: 200
                },
                {
                    field: 'cnt',
                    title: '�ϼ�',
                    align: 'right',
                    width: 50
                }
            ]
        ];
        var dataGridOption = {
            pagination: false,
            fitColumns: true,
            columns: columns,
            singleSelect: false,
            selectOnCheck: true,
            checkOnSelect: true,
            queryOnSelect: false,
            toolbar: [],
            onLoadSuccess: function () {
                $('#gridWard').datagrid('uncheckAll');
                $('#gridOrdExe').datagrid('clear');
            },
            onClickCell: function (rowIndex, field, value) {
                if (field == 'wardDesc') {
                    $(this).datagrid('options').queryOnSelect = true;
                }
            },
            onSelect: SelectQuery,
            onUnselect: SelectQuery
        };
        DHCPHA_HUI_COM.Grid.Init('gridWard', dataGridOption);
        function SelectQuery(rowIndex, rowData) {
            var $grid = $('#gridWard');
            if ($grid.datagrid('options').queryOnSelect == true) {
                $grid.datagrid('options').queryOnSelect = false;
                QueryOrdExe();
            }
        }
    }

    function InitGridAdm() {
        var options = {
            toolbar: '#gridAdmBar',
            onClickRow: function (rowIndex, rowData) {
                QueryOrdExe();
            }
        };
        PIVAS.InitGridAdm(
            {
                Id: 'gridAdm'
            },
            options
        );
    }

    function InitGridWorkType() {
        var columns = [
            [
                {
                    field: 'pwt',
                    title: '������',
                    width: 1,
                    hidden: true
                },
                {
                    field: 'pwtDesc',
                    title: '����������',
                    width: 100
                },
                {
                    field: 'pwtPrtWay',
                    title: '��ӡ����ʽ',
                    width: 200
                }
            ]
        ];
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'web.DHCSTPIVAS.LabelPrint',
                QueryName: 'WorkType',
                loc: SessionLoc
            },
            fitColumns: true,
            columns: columns,
            pagination: false,
            onClickRow: function (rowIndex, rowData) {
                var prtWay = rowData.pwtPrtWay;
                var prtWayRows = [];
                if (prtWay !== '') {
                    var prtWayArr = prtWay.split('>');
                    for (var i = 0; i < prtWayArr.length; i++) {
                        prtWayRows.push({
                            prtWayDesc: prtWayArr[i]
                        });
                    }
                }
                $('#gridPrtWay').datagrid('loadData', {
                    total: 0,
                    rows: prtWayRows
                });
            },
            onLoadSuccess: function () {
                $('#gridPrtWay').datagrid('loadData', {
                    total: 0,
                    rows: []
                });
            }
        };
        DHCPHA_HUI_COM.Grid.Init('gridWorkType', dataGridOption);
    }
    function InitGridTotal() {
        var columns = [
            [
                // {
                //     field: 'workTypeSelect',
                //     checkbox: true
                // },
                {
                    field: 'workType',
                    title: '������',
                    width: 1,
                    hidden: true
                },
                {
                    field: 'workTypeCode',
                    title: '���������',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'workTypeDesc',
                    title: '����������',
                    width: 100
                },
                {
                    field: 'prtWayDesc',
                    title: '��ӡ����ʽ',
                    width: 200,
                    hidden: true,
                    styler: function (value, row, index) {
                        return 'cursor:pointer';
                    },
                    formatter: function (value, row, index) {
                        return value;
                    }
                },
                {
                    field: 'cnt',
                    title: '�ϼ�',
                    width: 50,
                    align: 'center'
                },
                {
                    field: 'pivasCnt',
                    title: '��Һ',
                    width: 50,
                    align: 'center'
                },
                {
                    field: 'packCnt',
                    title: '���',
                    width: 50,
                    align: 'center'
                },

                {
                    field: 'batCntData',
                    title: '��������',
                    width: 300,
                    formatter: FmtBatCntData
                }
            ]
        ];
        var dataGridOption = {
            columns: columns,
            pagination: false,
            bodyCls: 'panel-body-gray',
            fitColumns: true,
            singleSelect: true,
            selectOnCheck: false,
            checkOnSelect: false,
            border: true,
            onLoadSuccess: function () {
                var $grid = $(this);
                if ($grid.datagrid('getRows') != '') {
                    $grid.datagrid('checkAll');
                } else {
                    $grid.datagrid('uncheckAll');
                }
            }
        };
        DHCPHA_HUI_COM.Grid.Init('gridTotal', dataGridOption);
    }

    //��ʼ����ϸ�б�
    function InitGridOrdExe() {
        var columns = [
            [
                {
                    field: 'ordExeCheck',
                    checkbox: true
                },
                {
                    field: 'check',
                    title: 'check',
                    width: 70,
                    hidden: true
                },
                {
                    field: 'wardDesc',
                    title: '����',
                    width: 100
                },
                {
                    field: 'bedNo',
                    title: '����',
                    width: 50
                },
                {
                    field: 'patNo',
                    title: '�ǼǺ�',
                    width: 100
                },
                {
                    field: 'patName',
                    title: '����',
                    width: 75
                },
                {
                    field: 'seqNo',
                    title: '���',
                    width: 45,
                    align: 'center',
                    hidden: false
                },
                {
                    field: 'doseDateTime',
                    title: '��ҩ����',
                    width: 98
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
                    field: 'useInfoObj',
                    title: '�÷�',
                    width: 300,
                    // formatter: FmtUseInfoData,
                    hidden: true
                },
                {
                    field: 'instrucDesc',
                    title: '�÷�',
                    width: 75
                },
                {
                    field: 'freqDesc',
                    title: 'Ƶ��',
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
                    field: 'pog',
                    title: 'pog',
                    width: 70,
                    hidden: true
                },
                {
                    field: 'mDsp',
                    title: 'mDsp',
                    width: 70,
                    hidden: true
                },
                {
                    field: 'packFlag',
                    title: 'packFlag',
                    width: 70,
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
            toolbar: '#gridOrdExeBar',
            columns: columns,
            singleSelect: false,
            selectOnCheck: false,
            checkOnSelect: false,
            pageSize: 200,
            pageList: [200, 500, 1000],
            pageNumber: 1,
            nowrap: false,
            rowStyler: PIVAS.Grid.RowStyler.PersonAlt,
            onClickRow: function (rowIndex, rowData) {
                SameRowsHanlder.ShowRow(rowIndex);
            },
            onBeforeSelect: function (rowIndex, rowData) {
                $(this).datagrid('unselectAll');
            },
            onClickCell: function (rowIndex, field, value) {
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
                UpdateRow(rowIndex, {
                    check: 'Y'
                });
            },
            onUncheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                UpdateRow(rowIndex, {
                    check: 'N'
                });
            },
            onCheckAll: PIVAS.Grid.onCheckAll,
            onUncheckAll: PIVAS.Grid.onUncheckAll,
            // view: scrollview,
            // view:bufferview,
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
            loadFilter: PIVAS.Grid.LoadFilter
        };
        PIVAS.Grid.Init('gridOrdExe', dataGridOption);
    }

    function GetPatAdmList() {
        var patNo = $('#txtPatNo').searchbox('getValue').trim();
        patNo = PIVAS.FmtPatNo(patNo);
        $('#txtPatNo').searchbox('setValue', patNo);
        var params = patNo + '^' + session['LOGON.HOSPID'];
        $('#gridAdm').datagrid('query', {
            inputParams: params,
            rows: 9999
        });
    }

    function Query() {
        $('#gridAdm').datagrid('clear');
        var pJson = Get.QueryParams();
        var $grid = $('#gridWard');
        $grid.datagrid('options').url = $URL;
        $grid.datagrid('query', {
            ClassName: 'web.DHCSTPIVAS.LabelPrint',
            QueryName: 'WardData',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999
        });
    }

    function QueryOrdExe() {
        var $grid = $('#gridOrdExe');
        $grid.datagrid('clear');
        var pJson = Get.QueryParams();
        var wardArr = Get.WardChecked();
        var adm = Get.Adm();
        if (wardArr.length === 0 && adm === '') {
            return;
        }
        var prtWayArr = Get.PrtWay();
        pJson.wardStr = wardArr.join(',');
        pJson.prtWayArr = prtWayArr;
        pJson.adm = adm;
        PIVAS.Grid.PageHandler($grid);

        var rowsData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.LabelPrint',
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

    /// ��������ǰ����
    function ConfirmSaveData() {
        PrintWithArrFlag = this.id === 'btnPrintWithArr' ? true : false;
        var validRet = ValidNeedUser();
        if (validRet !== '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: validRet,
                type: 'alert'
            });
            return;
        }

        var pogArr = Get.OriginChecked();
        if (pogArr.length === 0) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('����ѡ����Ҫ��ӡ�ļ�¼'),
                type: 'alert'
            });
            return;
        }
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.LabelPrint',
                QueryName: 'WorkTypeData',
                pJsonStr: JSON.stringify(pogArr)
            },
            function (data) {
                $('#gridTotal').datagrid('loadData', data);
            }
        );
        $('#gridTotalWin').dialog('open');
    }

    /// ��������
    function SaveData() {
        var pogArr = Get.OriginChecked();
        if (pogArr.length === 0) {
            return;
        }
        var prtWayArr = Get.PrtWay();
        if (prtWayArr.length === 0) {
            $.messager.alert($g('��ʾ'), $g('��ȡ������ӡ����ʽ'), 'warning');
            return;
        }
        var userJson = Get.User();
        PIVAS.Progress.Show({
            type: 'save',
            interval: 1000
        });
        $.m(
            {
                ClassName: 'web.DHCSTPIVAS.LabelPrint',
                MethodName: 'SaveData',
                pogJsonStr: JSON.stringify(pogArr),
                // prtJsonStr: JSON.stringify(prtWayArr), // ! ����ûɶ��,Ҳ���ǹ�����,����ѡ��,����
                user: SessionUser,
                user30: userJson.user30,
                user40: userJson.user40,
                user50: userJson.user50
            },
            function (retData) {
                PIVAS.Progress.Close();
                var retArr = retData.split('^');
                if (retArr[0] == -1) {
                    $.messager.alert($g('��ʾ'), retArr[1], 'warning');
                    return;
                } else if (retArr[0] < -1) {
                    $.messager.alert($g('��ʾ'), retArr[1], 'error');
                    return;
                } else {
                    if (PrintWithArrFlag === true) {
                        PIVASPRINT.Arrange(retArr[0], '', '');
                    }
                    PIVASPRINT.CallBack = function () {
                        $('#gridTotalWin').dialog('close');
                        QueryOrdExe();
                    };
                    PIVASPRINT.LabelsJsonByPogsNo({
                        pogsNo: retArr[0],
                        sortWay: ''
                    });
                }
            }
        );
    }

    // �������
    function PackSelectDsp(packFlag) {
        $.messager.confirm($g('��ʾ'), $g('��ȷ��' + (packFlag == 'P' ? '���' : 'ȡ�����') + '��?'), function (r) {
            if (r) {
                var mDspStr = Get.OrdExeChecked().join('^');
                if (mDspStr == '') {
                    $.messager.alert($g('��ʾ'), $g('�빴ѡ��Ҫ' + (packFlag == 'P' ? '���' : 'ȡ�����') + '�ļ�¼'), 'warning');
                    return;
                }
                var retData = tkMakeServerCall('web.DHCSTPIVAS.DataHandler', 'UpdateOeDspToPackMulti', mDspStr, packFlag);
                var retArr = retData.split('^');
                if (retArr[0] == -1) {
                    $.messager.alert($g('��ʾ'), retArr[1], 'warning');
                    return;
                } else if (retArr[0] < -1) {
                    $.messager.alert($g('��ʾ'), retArr[1], 'error');
                    return;
                }
                DHCPHA_HUI_COM.Msg.popover({
                    msg: $g((packFlag == 'P' ? '���' : 'ȡ�����') + '�ɹ�'),
                    type: 'success'
                });
                var $grid = $('#gridOrdExe');
                var gridOrdExeChecked = $grid.datagrid('getChecked');
                for (var i = 0; i < gridOrdExeChecked.length; i++) {
                    var rowIndex = $grid.datagrid('getRowIndex', gridOrdExeChecked[i]);
                    UpdateRow(rowIndex, {
                        packFlag: packFlag
                    });
                }
                $('#gridOrdExe').datagrid('reload');
            }
        });
    }
    /// ��ʼ��Ĭ������
    function InitPivasSettings() {
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Settings',
                MethodName: 'GetAppProp',
                userId: session['LOGON.USERID'],
                locId: session['LOGON.CTLOCID'],
                appCode: 'LabelPrint'
            },
            function (jsonData) {
                $('#dateStart').datebox('setValue', jsonData.OrdStDate);
                $('#dateEnd').datebox('setValue', jsonData.OrdEdDate);
                PIVAS.VAR.MaxDrugCnt = jsonData.MaxDrugCnt;
                var needUserArr = [];
                if (jsonData.NeedUser30 == 'Y') {
                    needUserArr.push('NeedUser30');
                }
                if (jsonData.NeedUser40 == 'Y') {
                    needUserArr.push('NeedUser40');
                }
                if (jsonData.NeedUser50 == 'Y') {
                    needUserArr.push('NeedUser50');
                }
                var len = needUserArr.length;
                if (len > 0) {
                    $('.pivas-user-select-line').show();
                    for (var i = 0; i < len; i++) {
                        $('#cmb' + needUserArr[i])
                            .closest('tr')
                            .show();
                    }
                }
            }
        );
    }

    /// �������б�
    function InitGridPrtDict() {
        //����columns
        var columns = [
            [
                {
                    field: 'prtWayDesc',
                    title: '��ǩ˳���ֵ�',
                    width: 3,
                    hidden: false
                },
                {
                    field: 'dictOperate',
                    title: '����',
                    width: 1,
                    align: 'center',
                    formatter: function (value, rowData, rowIndex) {
                        return '<span class="icon pha-icon-blue icon-add js-a-add" style="cursor:pointer"></span>'
                        return '<span title="��Ȩ" class="pha-img-a-add" style="border:0px;cursor:pointer"></span>';
                    }
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            data: PrtDictData,
            pagination: false,
            columns: columns,
            rownumbers: false,
            fitColumns: true
        };
        DHCPHA_HUI_COM.Grid.Init('gridPrtDict', dataGridOption);
        $('#gridPrtDict')
            .closest('.datagrid-view')
            .find('.datagrid-body')
            .on('click', '.js-a-add', function (e) {
                AddPrtWay();
            });
    }
    /// �������б�
    function InitGridPrtWay() {
        //����columns
        var columns = [
            [
                {
                    field: 'prtWayDesc',
                    title: '��ǩ��ӡ˳��',
                    width: 3,
                    hidden: false
                },
                {
                    field: 'wayOperate',
                    title: '����',
                    width: 1,
                    align: 'center',
                    formatter: function (value, rowData, rowIndex) {
                        return '<span class="icon pha-icon-blue icon-cancel js-a-delete" style="cursor:pointer"></span>'
                        return '<img title="ɾ��" src="../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png" style="border:0px;cursor:pointer">';
                    }
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            data: {
                rows: []
            },
            pagination: false,
            columns: columns,
            fitColumns: true,
            onLoadSuccess: function () {
                $('#gridPrtWay').datagrid('enableDnd');
            }
        };
        DHCPHA_HUI_COM.Grid.Init('gridPrtWay', dataGridOption);
        $('#gridPrtWay')
            .closest('.datagrid-view')
            .find('.datagrid-body')
            .on('click', '.js-a-delete', function (e) {
                DeletePrtWay();
            });
    }

    function AddPrtWay() {
        if ($('#gridWorkType').datagrid('getSelected') === null) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('����ѡ����๤����'),
                type: 'alert'
            });
            return;
        }
        var $target = $(event.target);
        var rowIndex = $target.closest('tr[datagrid-row-index]').attr('datagrid-row-index');
        var rowData = $('#gridPrtDict').datagrid('getRows')[rowIndex];
        var prtWayDesc = rowData.prtWayDesc;
        var gridPrtWayRows = $('#gridPrtWay').datagrid('getRows');
        for (var i = 0; i < gridPrtWayRows.length; i++) {
            var tmpPrtWay = gridPrtWayRows[i].prtWayDesc;
            if (tmpPrtWay == prtWayDesc && CanMultiAddData.indexOf(prtWayDesc) < 0) {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: $g('�Ѵ��ڸ�˳��,����Ҫ������'),
                    type: 'alert'
                });
                return;
            }
        }
        var newData = {
            prtWayDesc: prtWayDesc
        };

        $('#gridPrtWay').datagrid('appendRow', newData).datagrid('loadData', $('#gridPrtWay').datagrid('getRows'));
        UpdateWorkType();
    }

    function DeletePrtWay() {
        var $target = $(event.target);
        var rowIndex = $target.closest('tr[datagrid-row-index]').attr('datagrid-row-index');
        $('#gridPrtWay').datagrid('deleteRow', rowIndex).datagrid('loadData', $('#gridPrtWay').datagrid('getRows'));
        UpdateWorkType();
    }

    function UpdateWorkType() {
        var $grid = $('#gridWorkType');
        var selected = $grid.datagrid('getSelected');
        var rowIndex = $grid.datagrid('getRowIndex', selected);
        var rows = $('#gridPrtWay').datagrid('getRows');
        var prtWayArr = [];
        for (var i = 0; i < rows.length; i++) {
            prtWayArr.push(rows[i].prtWayDesc);
        }
        $grid.datagrid('updateRow', {
            index: rowIndex,
            row: {
                pwtPrtWay: prtWayArr.join('>')
            }
        });
    }

    function UpdateWorkTypePrtWay() {
        var rows = $('#gridWorkType').datagrid('getRows');
        for (var i = 0; i < rows.length; i++) {
            var prtWay = rows[i].pwtPrtWay || '';
            if (prtWay === '') {
                DHCPHA_HUI_COM.Msg.popover({
                    msg: $g('�������ӡ˳����Ϊ��'),
                    type: 'alert'
                });
                return;
            }
        }
        $('#gridWorkTypeWin').window('close');
        QueryOrdExe();
    }

    function PrtConfigHandler() {
        $('#gridWorkTypeWin').window('open');
    }
    function FmtBatCntData(value, row, index) {
        var valJson = JSON.parse(value);
        var len = valJson.length;

        var retHtml = '';
        for (var i = 0; i < len; i++) {
            var valData = valJson[i];
            var batCntHtml = '<div style="float:left;width:25%;">' + valData.batNo + '<span style="padding:5px">:</span>' + valData.cnt + '</div>';
            retHtml += batCntHtml;
        }
        return retHtml;
    }

    function ValidNeedUser() {
        var userJson = Get.User();
        if (userJson.user30 === '' && $('#cmbNeedUser30').closest('tr').css('display') !== 'none') {
            return $g('��ѡ����ҩ�˶���');
        }
        if (userJson.user40 === '' && $('#cmbNeedUser40').closest('tr').css('display') !== 'none') {
            return $g('��ѡ����ǩ�˶���');
        }
        if (userJson.user50 === '' && $('#cmbNeedUser50').closest('tr').css('display') !== 'none') {
            return $g('��ѡ��˶Ժ˶���');
        }
        return '';
    }

    var Get = {
        BatNoChecked: function () {
            var batNoArr = [];
            $('input[type=checkbox][name=batbox]').each(function () {
                if ($('#' + this.id).is(':checked')) {
                    batNoArr.push($('#' + this.id).attr('text'));
                }
            });
            return batNoArr;
        },
        QueryParams: function () {
            var pJson = {};
            pJson.loc = SessionLoc;
            pJson.startDate = $('#dateStart').datebox('getValue');
            pJson.endDate = $('#dateEnd').datebox('getValue');
            pJson.locGrp = $('#cmbLocGrp').combobox('getValue') || '';
            pJson.wardStr = $('#cmbWard').combobox('getValue') || '';
            pJson.cat = $('#cmbPivaCat').combobox('getValue') || '';
            pJson.workType = $('#cmbWorkType').combobox('getValue') || '';
            pJson.priority = $('#cmbPriority').combobox('getValue') || '';
            pJson.inci = $('#cmgIncItm').combobox('getValue') || '';
            pJson.packFlag = $('#cmbPack').combobox('getValues').join(',');
            pJson.instruc = $('#cmbInstruc').combobox('getValue') || '';
            pJson.adm = '';
            pJson.batNoStr = Get.BatNoChecked().join(',');
            return pJson;
        },
        User: function () {
            return {
                user30: $('#cmbNeedUser30').combobox('getValue') || '',
                user40: $('#cmbNeedUser40').combobox('getValue') || '',
                user50: $('#cmbNeedUser50').combobox('getValue') || ''
            };
        },
        OriginChecked: function () {
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
        },
        OrdExeChecked: function () {
            var retArr = [];
            var gridOrdExeChecked = $('#gridOrdExe').datagrid('getChecked');
            for (var i = 0; i < gridOrdExeChecked.length; i++) {
                retArr.push(gridOrdExeChecked[i].mDsp);
            }
            return retArr;
        },
        WardChecked: function () {
            var retArr = [];
            var gridChecked = $('#gridWard').datagrid('getChecked');
            for (var i = 0; i < gridChecked.length; i++) {
                retArr.push(gridChecked[i].ward);
            }
            return retArr;
        },
        PrtWay: function () {
            var retArr = [];
            var rows = $('#gridWorkType').datagrid('getRows');
            for (var i = 0; i < rows.length; i++) {
                retArr.push({
                    pwt: rows[i].pwt,
                    prtWay: rows[i].pwtPrtWay
                });
            }
            return retArr;
        },
        Adm: function () {
            var adm = '';
            var tabTitle = $('#tabsTotal').tabs('getSelected').panel('options').title;
            if (tabTitle === $g('���ǼǺ�')) {
                var admSelected = $('#gridAdm').datagrid('getSelected');
                if (admSelected == null) {
                    return '';
                }
                adm = admSelected.admId;
            }
            return adm;
        }
    };

    function UpdateRow(rowIndex, rowData) {
        SameRowsHanlder.UpdateRow(rowIndex, rowData);
    }

    $('.dhcpha-win-mask').remove();
};
$(PIVAS_LABELPRINT_NS);
