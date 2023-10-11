/**
 * ģ��:   ������Һ����
 * ��д����: 2018-03-05
 * ��д��:   yunhaibao
 */
 var PIVAS_BATUPDATE_NS = function () {
    var ChangeViewNum = 1;
    var PersonSameFields = '[field=patNo],[field=patName],[field=bedNo],[field=wardDesc]';
    var SameRowsHanlder = PIVAS.Grid.SameRows('gridOrdExe', PersonSameFields);

    var SessionLoc = session['LOGON.CTLOCID'];
    var SessionUser = session['LOGON.USERID'];
    var ConfirmMsgInfoArr = [];
    var GridCmbBatNo;
    var NeedScroll = 'Y'; // �Ƿ���Ҫ������0��

    PIVAS.Grid.Pagination();
    InitDict();
    InitGridWard();
    InitTreePat();
    InitGridOrdExe();

    $('#btnFind').on('click', function () {
        $('#gridWard').datagrid('clear');
        $('#treePat').tree('loadData', []);
        if (Get.CurTab() == 'pat') {
            QueryPat();
        } else {
            Query();
        }
    });
    $('#btnFindDetail').on('click', QueryDetail);
    $('#btnSave').on('click', SaveData);
    $('#btnPack').on('click', function () {
        PackSelectDsp('P');
    });
    $('#btnUnPack').on('click', function () {
        PackSelectDsp('');
    });
    $('#btnUnSave').on('click', DelBatUpdate);
    $('#btnUpdBat').on('click', ConfirmUpdBatUpdate);

    $('#btnSelectAll').on('click', function () {
        PIVAS.CheckAll($('#gridOrdExe'));
    });
    $('#btnUnSelectAll').on('click', function () {
        PIVAS.UnCheckAll($('#gridOrdExe'));
    });
    $('#btnRefuse').on('click', HandleRefuse);
    $('#btnChangeView').on('click', ChangeView);

    InitPivasSettings();
    $('#txtPatNo').searchbox({
        prompt: $g('������ǼǺ�...'),
        width: 250,
        searcher: function () {
            var patNo = $('#txtPatNo').searchbox('getValue');
            patNo = PIVAS.FmtPatNo(patNo);
            $('#txtPatNo').searchbox('setValue', patNo);
            QueryPat();
        }
    });
    $('.js-btn-toggle').on('click', function () {
        $('.js-btn-toggle').toggle();
        $(this)[0].id === 'btnCollapseAll' ? $('#treePat').tree('collapseAll') : $('#treePat').tree('expandAll');
    });
    $('.dhcpha-win-mask').remove();

    /**  */

    function InitDict() {
        // ��Һ����
        PIVAS.ComboBox.Init({ Id: 'cmbPivaCat', Type: 'PivaCat' }, { width: 120 });
        // ������
        PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, {});
        // ����
        PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
        // ҽ�����ȼ�
        PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, { width: 120 });
        // ������
        PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, { width: 120 });
        // ҩƷ
        PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { width: 316 });
        // ���
        PIVAS.ComboBox.Init(
            { Id: 'cmbPack', Type: 'PackType' },
            {
                width: 120
            }
        );
        // ����״̬
        PIVAS.ComboBox.Init(
            { Id: 'cmbUpdated', Type: 'BatUpdateStat' },
            {
                editable: false,
                width: 120,
                onSelect: function () {
                    Query();
                }
            }
        );
        $('#cmbUpdated').combobox('setValue', 'N');
        // ��ǩ״̬
        PIVAS.ComboBox.Init(
            { Id: 'cmbPrt', Type: 'PrtStat' },
            {
                editable: false,
                width: 120,
                onSelect: function () {
                    Query();
                }
            }
        );
        $('#cmbPrt').combobox('setValue', 'N');
        // ����
        PIVAS.BatchNoCheckList({ Id: 'DivBatNo', LocId: SessionLoc, Check: true, Pack: false });
        GridCmbBatNo = PIVAS.UpdateBatNoCombo(
            {
                LocId: SessionLoc,
                GridId: 'gridOrdExe',
                Field: 'batNo',
                BatUp: 'batUp',
                MDspField: 'mDsp'
            },
            function () {
                NeedScroll = '';
                $('#gridOrdExe').datagrid('reload');
            }
        );
    }

    //��ʼ�������б�
    function InitGridWard() {
        //����columns
        var columns = [
            [
                { field: 'select', checkbox: true },
                { field: 'ward', title: 'ward', hidden: true },
                { field: 'wardDesc', title: '����', width: 200 },
                { field: 'cnt', title: '�ϼ�', width: 50, align: 'right' }
            ]
        ];
        var dataGridOption = {
            url: '',
            pagination: false,
            fitColumns: true,
            fit: true,
            rownumbers: false,
            columns: columns,
            queryOnSelect: true,
            toolbar: [],
            singleSelect: false,
            selectOnCheck: true,
            checkOnSelect: true,
            onLoadSuccess: function () {
                $('#gridOrdExe').datagrid('clear');
                $(this).datagrid('uncheckAll');
            },
            onClickCell: function (rowIndex, field, value) {
                if (field !== 'select') {
                    $(this).datagrid('options').queryOnSelect = true;
                }
            },
            onSelect: function (rowIndex, rowData) {
                if ($(this).datagrid('options').queryOnSelect == true) {
                    $(this).datagrid('options').queryOnSelect = false;
                    QueryDetail();
                }
            },
            onUnselect: function (rowIndex, rowData) {
                if ($(this).datagrid('options').queryOnSelect == true) {
                    $(this).datagrid('options').queryOnSelect = false;
                    QueryDetail();
                }
            }
        };
        PIVAS.Grid.Init('gridWard', dataGridOption);
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
                    field: 'wardDesc',
                    title: '����',
                    width: 200
                },
                {
                    field: 'bedNo',
                    title: '����',
                    width: 50
                },
                {
                    field: 'patNo',
                    title: '�ǼǺ�',
                    width: 100,
                    formatter: function (value, row, index) {
                        var adm = row.adm;
                        var startDate = $('#dateStart').datebox('getValue');
                        var endDate = $('#dateEnd').datebox('getValue');
                        var batNoStr = Get.AllBatNoStr().join(',');
                        var updateStat = 'Y';
                        var prtStat = 'A';
                        var Params = startDate+"^"+endDate+"^"+adm+"^"+SessionLoc+"^^^^^^^^"+batNoStr+"^"+updateStat+"^"+prtStat
                        return '<a class="pha-grid-a" onclick="PIVAS.BatUpdatedWindow({Params:\'' + Params + '\'} )">' + value + '</a>';
                    }
                },
                {
                    field: 'patName',
                    title: '����',
                    width: 75
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
                    formatter: function (value, rowData, index) {
                        var styleArr = [];
                        var updHtmlArr = [];
                        var retHtmlArr = [];
                        if (rowData.updateFlag === 'Y') {
                            // ������
                            updHtmlArr.push('<div class="pivas-bat-done"></div>');
                        }

                        if (rowData.packFlag !== '') {
                            styleArr.push(PIVAS.Grid.CSS.BatchPack);
                        }
                        if (rowData.updateType === 'U') {
                            // �û��޸ĵ�,б��
                            styleArr.push('font-style: italic;font-weight: bold');
                        } else if (rowData.updateType === 'N') {
                            // ��ʿ�ӳٵ�,��ɫб��
                            styleArr.push('font-style: italic;font-weight: bold;color: #FF0000');
                        }
                        if (rowData.canUpdate === 'Y') {
                            styleArr.push('text-decoration:underline');
                        }
                        retHtmlArr.push('<div style="' + styleArr.join(';') + '">' + value + '</div>');
                        return updHtmlArr.join('') + retHtmlArr.join('');
                    },
                    styler: function (value, row, index) {
                        return 'position:relative';
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
                    width: 75,
                    align: 'right',
                    formatter: PIVAS.Grid.Formatter.QtyUomGroup
                },
                {
                    field: 'liquid',
                    title: 'Һ����',
                    width: 75,
                    align: 'right'
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
                    field: 'priDesc',
                    title: 'ҽ�����ȼ�',
                    width: 85
                },
                {
                    field: 'workTypeDesc',
                    title: '������',
                    width: 75,
                    styler: function (value, row, index) {
                        if (value === '') {
                            return 'background: #f6704e';
                        }
                    }
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
                    hidden: false
                },
                {
                    field: 'packFlag',
                    title: 'packFlag',
                    width: 70,
                    hidden: true
                },
                {
                    field: 'wardPat',
                    title: '�������߷���',
                    width: 200,
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
                },
                { field: 'updateType', title: '�û��޸�', width: 50, hidden: true }, // ��ָ����ǰ���޸�
                { field: 'canUpdate', title: '�Ƿ���޸�', width: 50, hidden: true },
                { field: 'updateFlag', title: '�Ƿ�������', width: 50, hidden: true },
                { field: 'check', title: '��¼��ѡ', width: 50, hidden: true },
                { field: 'adm', title: 'adm', width: 50, hidden: true }
            ]
        ];
        var dataGridOption = {
            url: '',
            columns: columns,
            fit: true,
            toolbar: '#gridOrdExeBar',
            singleSelect: false,
            selectOnCheck: false,
            checkOnSelect: false,
            pageSize: 100,
            pageList: [100, 300, 500, 1000],
            pageNumber: 1,
            nowrap: false,
            rowStyler: PIVAS.Grid.RowStyler.PersonAlt,
            onClickRow: function (rowIndex, rowData) {
                SameRowsHanlder.ShowRow(rowIndex);
                if (rowData.canUpdate != 'Y') {
                    $(this).datagrid('unselectRow', rowIndex);
                }
            },
            onBeforeSelect: function (rowIndex, rowData) {
                $(this).datagrid('unselectAll');
            },
            onClickCell: function (rowIndex, field, value) {
                var rowData = $(this).datagrid('getRows')[rowIndex];
                var canUpdate = rowData.canUpdate || '';
                if (canUpdate != 'Y') {
                    return;
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
                UnBindChk();
            },
            loadFilter: PIVAS.Grid.LoadFilter,
            groupField: 'wardPat',
            groupFormatter: function (value, rows) {
                var rowData = rows[0];
                // ���˻�����Ϣ / ҽ����Ϣ /
                var viewDiv = '';
                var patDiv = '';
                var ordDiv = '';
                var wardDiv = '';
                patDiv += '<div id="grpViewPat" class="grpViewPat" style="padding-left:0px">';
                patDiv += '<div >' + rowData.patNo + '</div>';
                patDiv += '<div>/</div>';
                patDiv += '<div>' + rowData.bedNo + '</div>';
                patDiv += '<div>/</div>';
                patDiv += '<div>' + rowData.patName + '</div>';
                patDiv += '</div>';
                wardDiv += '<div id="grpViewWard" class="grpViewWard">';
                wardDiv += '<div>' + rowData.wardDesc + '</div>';
                wardDiv += '</div>';
                viewDiv += '<div id="grpViewBase" class="grpViewBase">' + wardDiv + patDiv + '</div>';
                return viewDiv;
            }
        };
        PIVAS.Grid.Init('gridOrdExe', dataGridOption);
    }

    function UnBindChk() {
        var rows = $('#gridOrdExe').datagrid('getRows');
        $.each(rows, function (index, row) {
            var canUpdate = row.canUpdate;
            if (canUpdate != 'Y') {
                //$(".datagrid-row[datagrid-row-index=" + index + "] .datagrid-cell-check")
                // ͨ���Ƴ���ʽ,ʹselectoncheck���¼���������
                var $row = $('#gridOrdExe')
                    .prev()
                    .find('.datagrid-row[datagrid-row-index=' + index + ']');
                $row.removeClass('datagrid-row-selected datagrid-row-checked');
                var $chk = $row.find("input:checkbox[name='ordExeCheck']")[0];
                $chk.disabled = true;
                $chk.checked = false;
                $chk.style = 'display:none';
            }
        });
    }

    ///��ѯ
    function Query() {
        SetSumDetail([]);
        var pJson = Get.QueryParams();
        var $grid = $('#gridWard');
        $grid.datagrid('options').url = $URL;
        $grid.datagrid('query', {
            ClassName: 'web.DHCSTPIVAS.BatUpdate',
            QueryName: 'WardData',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999
        });
    }

    // ��ѯҽ��
    function QueryDetail() {
        SetSumDetail([]);
        var pJson = Get.QueryParams();
        var wardArr = Get.WardChecked();
        var adm = Get.AdmSelected();
        if (adm !== '') {
            wardArr = [];
            pJson.adm = adm;
        }
        var $grid = $('#gridOrdExe');
        $grid.datagrid('clear');
        if (wardArr.length === 0 && adm === '') {
            return;
        }

        pJson.wardStr = wardArr.join(',');
        $grid.datagrid('loading');
        PIVAS.Grid.PageHandler($grid);
        setTimeout(function () {
            var rowsData = $.cm(
                {
                    ClassName: 'web.DHCSTPIVAS.BatUpdate',
                    QueryName: 'OrdExeData',
                    pJsonStr: JSON.stringify(pJson),
                    rows: 9999,
                    page: 1
                },
                false
            );
            var rowsDataStr = JSON.stringify(rowsData.rows);
            $grid.datagrid('loadData', rowsData);
            SumDetail(rowsDataStr);
        }, 100);
    }

    //  ȷ������
    function SaveData() {
        var chkMsg = '';
        if ($('#cmbUpdated').combobox('getValue') == 'Y') {
            chkMsg = $g('ҽ����ϸ����Ϊ����������');
        }

        var dspBatArr = Get.OriginChecked();
        if (dspBatArr.length === 0) {
            chkMsg = $g('�빴ѡ��Ҫ����������');
            if (Get.NullWorkType()) {
                chkMsg = $g('��ѡ���¼�к��С������顿Ϊ�յļ�¼,���ʵ����и���Ϊ��ɫ�ļ�¼');
            }
        }

        if (chkMsg !== '') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: chkMsg,
                type: 'alert'
            });
            return;
        }

        $.messager.confirm($g('��ʾ'), $g('��ȷ��������?'), function (r) {
            if (r) {
                PIVAS.Progress.Show({ type: 'save', interval: 1000 });
                $.m(
                    {
                        ClassName: 'web.DHCSTPIVAS.BatUpdate',
                        MethodName: 'SaveData',
                        dataJsonStr: JSON.stringify(dspBatArr),
                        user: SessionUser
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
                        }
                        QueryDetail();
                    }
                );
            }
        });
    }

    // �������
    function PackSelectDsp(packFlag) {
        $.messager.confirm($g('��ʾ'), $g('��ȷ��' + (packFlag == 'P' ? '���' : 'ȡ�����') + '��?'), function (r) {
            if (r) {
                var mDspArr = Get.OrdExeChecked();
                if (mDspArr.length === 0) {
                    DHCPHA_HUI_COM.Msg.popover({
                        msg: $g('�빴ѡ��Ҫ' + (packFlag == 'P' ? '���' : 'ȡ�����') + '�ļ�¼'),
                        type: 'alert'
                    });
                    return;
                }
                var retData = tkMakeServerCall('web.DHCSTPIVAS.DataHandler', 'UpdateOeDspToPackMulti', mDspArr.join('^'), packFlag);
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
                NeedScroll = '';
                QueryDetail();
            }
        });
    }

    // ȡ������
    function DelBatUpdate() {
        if ($('#cmbUpdated').combobox('getValue') == 'N') {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('δ���������޷�ȡ��'),
                type: 'alert'
            });
            return;
        }
        $.messager.confirm($g('��ʾ'), $g('��ȷ��ȡ��������?'), function (r) {
            if (r) {
                var mDspArr = Get.OrdExeChecked();
                if (mDspArr.length === 0) {
                    DHCPHA_HUI_COM.Msg.popover({
                        msg: $g('�빴ѡ��Ҫȡ�������ļ�¼'),
                        type: 'alert'
                    });
                    return;
                }
                var retData = tkMakeServerCall('web.DHCSTPIVAS.BatUpdate', 'DeleteBatUpdateMulti', mDspArr.join('^'), SessionUser);
                var retArr = retData.split('^');
                if (retArr[0] == -1) {
                    if (retArr[2] > 0) {
                        $.messager.alert($g('��ʾ'), $g('ȡ�������ɹ�</br>�����ּ�¼') + retArr[1], 'warning');
                        QueryDetail();
                    } else {
                        $.messager.alert($g('��ʾ'), retArr[1], 'warning');
                    }
                    return;
                } else if (retArr[0] < -1) {
                    if (retArr[2] > 0) {
                        $.messager.alert($g('��ʾ'), $g('ȡ�������ɹ�</br>�����ּ�¼') + retArr[1], 'error');
                        QueryDetail();
                    } else {
                        $.messager.alert($g('��ʾ'), retArr[1], 'error');
                    }
                    return;
                }
                DHCPHA_HUI_COM.Msg.popover({
                    msg: $g('ȡ�������ɹ�'),
                    type: 'success'
                });
                // ȡ��������,��̨�����ж�,ֱ�����²�ѯ,�漰���¼����ݻ�
                QueryDetail();
            }
        });
    }

    // ȷ��-�����޸�����
    function ConfirmUpdBatUpdate() {
        var mDspArr = Get.OrdExeChecked();
        if (mDspArr.length === 0) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('�빴ѡ��Ҫ�޸����εļ�¼'),
                type: 'alert'
            });
            return;
        }
        PIVAS.UpdateBatNoWindow({ LocId: SessionLoc }, UpdBatUpdate);
    }
    // �����޸�����
    function UpdBatUpdate(batNo) {
        var mDspArr = Get.OrdExeChecked();
        var mDspStr = mDspArr.join('^');
        var retData = tkMakeServerCall('web.DHCSTPIVAS.BatUpdate', 'UpdateBatchMulti', mDspStr, batNo, SessionUser);
        var retArr = retData.split('^');
        if (retArr[0] == -1) {
            $.messager.alert($g('��ʾ'), retArr[1], 'warning');
        } else if (retArr[0] < -1) {
            $.messager.alert($g('��ʾ'), retArr[1], 'error');
        } else {
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('�޸����γɹ�'),
                type: 'success'
            });
        }
        NeedScroll = '';
        QueryDetail();

        // todo �Ǹ����л������²�ѯ
        //$('#gridOrdExe').datagrid('reload');
    }

    /// ��ʼ��Ĭ������
    function InitPivasSettings() {
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Settings',
                MethodName: 'GetAppProp',
                userId: session['LOGON.USERID'],
                locId: session['LOGON.CTLOCID'],
                appCode: 'BatUpdate'
            },
            function (jsonData) {
                $('#dateStart').datebox('setValue', jsonData.OrdStDate);
                $('#dateEnd').datebox('setValue', jsonData.OrdEdDate);
                PIVAS.VAR.PASS = jsonData.Pass;
                PIVAS.VAR.MaxDrugCnt = jsonData.MaxDrugCnt;
            }
        );
    }
    
    function ChangeView() {
        var hsMethod = '';
        var showView = '';
        if (ChangeViewNum % 2 == 1) {
            hsMethod = 'hideColumn';
            showView = groupview;
        } else {
            hsMethod = 'showColumn';
            showView = $.fn.datagrid.defaults.view;
        }
        var gridOpts = $('#gridOrdExe').datagrid('options');
        //$('#gridOrdExe').datagrid(hsMethod, 'patNo');
        $('#gridOrdExe').datagrid(hsMethod, 'patName');
        $('#gridOrdExe').datagrid(hsMethod, 'bedNo');
        $('#gridOrdExe').datagrid(hsMethod, 'wardDesc');
        $('#gridOrdExe').datagrid('options').view = showView;
        QueryDetail();
        ChangeViewNum++;
    }

    function InitTreePat() {
        $('#treePat').tree({
            formatter: function (node) {
                if (node.children) {
                    return '<div style="line-height:35px;font-weight:bold">' + node.text + '</div>';
                } else {
                    var data = node.text;
                    var htmlArr = [];
                    htmlArr.push('<div style="line-height:35px;">');
                    htmlArr.push('  <div class="pivas-tree-pat" style="width:50px;overflow:hidden">' + '<span style="visibility:hidden">1</span>' + data.bedNo + '</div>');
                    htmlArr.push('  <div class="pivas-tree-pat" style="width:100px;padding-left:5px;overflow:hidden">' + data.patNo + '</div>');
                    htmlArr.push('  <div class="pivas-tree-pat" style="width:60px;padding-left:5px;overflow:hidden">' + data.patName + '</div>');
                    htmlArr.push('  <div class="pivas-tree-pat" style="width:40px;text-align:right;font-weight:bold">' + data.cnt + '</div>');
                    htmlArr.push('</div>');
                    return htmlArr.join('');
                }
            },
            lines: true,
            autoNodeHeight: true,
            onClick: function (node) {
                QueryDetail();
            },
            onLoadSuccess: function () {
                $('#btnCollapseAll').css('display') === 'none' ? $('#treePat').tree('collapseAll') : $('#treePat').tree('expandAll');
            }
        });
    }
    function QueryPat() {
        // todo ����
        SetSumDetail([]);
        var pJson = Get.QueryParams();
        pJson.patNo = $('#txtPatNo').searchbox('getValue');
        var rowsData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.BatUpdate',
                MethodName: 'GetPatTreeData',
                rows: 9999,
                page: 1,
                pJsonStr: JSON.stringify(pJson)
            },
            false
        );

        setTimeout(function () {
            $('#treePat').tree('loadData', rowsData);
        }, 100);
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
        AllBatNoStr: function () {
            var batNoArr = [];
            $('input[type=checkbox][name=batbox]').each(function () {
                batNoArr.push($('#' + this.id).attr('text'));
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
            pJson.pivaCat = $('#cmbPivaCat').combobox('getValue') || '';
            pJson.workType = $('#cmbWorkType').combobox('getValue') || '';
            pJson.priority = $('#cmbPriority').combobox('getValue') || '';
            pJson.inci = $('#cmgIncItm').combobox('getValue') || '';
            pJson.packFlag = $('#cmbPack').combobox('getValue');
            pJson.adm = '';
            pJson.batNoStr = Get.BatNoChecked().join(',');
            pJson.updateStat = $('#cmbUpdated').combobox('getValue') || ''; // ����״̬
            pJson.prtStat = $('#cmbPrt').combobox('getValue') || ''; // ��ǩ״̬
            return pJson;
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
                if (rowData.canUpdate !== 'Y') {
                    continue;
                }
                if (rowData.check !== 'Y') {
                    continue;
                }
                if (rowData.workTypeDesc === '') {
                    continue;
                }
                var mDspBat = {
                    mDsp: rowData.mDsp,
                    batNo: rowData.batNo
                };
                retArr.push(mDspBat);
            }
            return retArr;
        },
        NullWorkType: function () {
            var retArr = [];
            var origRows = $('#gridOrdExe').datagrid('getData').originalRows;
            if (typeof origRows === 'undefined') {
                return false;
            }
            var len = origRows.length;
            for (var i = 0; i < len; i++) {
                var rowData = origRows[i];
                if (rowData.canUpdate !== 'Y') {
                    continue;
                }
                if (rowData.check !== 'Y') {
                    continue;
                }
                if (rowData.workTypeDesc === '') {
                    return true;
                }
            }
            return false;
        },
        OrdExeChecked: function () {
            var retArr = [];
            var gridOrdExeChecked = $('#gridOrdExe').datagrid('getChecked');
            for (var i = 0; i < gridOrdExeChecked.length; i++) {
                var rowData = gridOrdExeChecked[i];
                if (rowData.canUpdate !== 'Y') {
                    continue;
                }
                retArr.push(rowData.mDsp);
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
        CurTab: function () {
            return $('#tabsOne').tabs('getSelected').panel('options').code;
            return tabTitle === $g('�����б�') ? 'ward' : 'pat';
        },
        AdmSelected: function () {
            var adm = '';
            if (this.CurTab() === 'ward') {
                return adm;
            }
            var treeSel = $('#treePat').tree('getSelected');
            if (treeSel === null) {
                return adm;
            }
            adm = treeSel.text.adm || '';
            return adm;
        }
    };

    function UpdateRow(rowIndex, rowData) {
        SameRowsHanlder.UpdateRow(rowIndex, rowData);
    }
    function SumDetail(rowsDataStr) {
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.BatUpdate',
                MethodName: 'GetSumDetailData',
                dataJsonStr: rowsDataStr
            },
            function (retData) {
                SetSumDetail(retData);
            }
        );
    }
    function SetSumDetail(rows) {
        var retHtmlArr = [];
        for (var i = 0; i < rows.length; i++) {
            var rowData = rows[i];
            retHtmlArr.push('<div>' + rowData.batNo + '��<b>' + rowData.cnt + '</b></div>');
        }
        $('.pivas-toolbar-context').html(retHtmlArr.join(''));
    }
    function HandleRefuse(){
        var dataArr = [];
        var gridOrdExeChecked = $('#gridOrdExe').datagrid('getChecked');
        for (var i = 0; i < gridOrdExeChecked.length; i++) {
            var rowData = gridOrdExeChecked[i];
            dataArr.push({
                mDsp: rowData.mDsp,
                batNo: rowData.batNo
            });
        }
        if (dataArr.length === 0){
            DHCPHA_HUI_COM.Msg.popover({
                msg: $g('���ȹ�ѡ��Ҫ�ܾ��ļ�¼'),
                type: 'alert'
            });
            return 
        }
        PIVAS.RefuseReasonWindow({ dataArr: dataArr, user: SessionUser }, QueryDetail);
    }
};
$(PIVAS_BATUPDATE_NS);
