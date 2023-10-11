/**
 * ���û���ҩƷά��
 * @creator yunhaibao
 * @date    2023-04-10
 */

PHA_SYS_SET = undefined;
var PHA_IP_BASEDRUG = {
    Config: {}
};
$(function () {
    InitHosp();
    InitEvents();
    InitWinSelectLoc();
    InitWinSelectDrug();
    InitGridBaseLoc();
    InitGridBaseDrug();

    function InitEvents() {
        $('#btnAddBaseLoc').on('click', function () {
            if ($('#mainLoc').combobox('getValue') === '') {
                PHA.Popover({
                    msg: '����ѡ��������',
                    type: 'info'
                });
                return;
            }
            $('#winSelectLoc').window('open');
        });
        $('#btnAddBaseDrug').on('click', function () {
            if ($('#gridBaseLoc').datagrid('getSelected') === null) {
                PHA.Popover({
                    msg: '����ѡ����ҩ����',
                    type: 'info'
                });
                return;
            }
            $('#winSelectDrug').window('open');
        });
        $('#btnDeleteBaseDrug').on('click', function () {
            if ($('#gridBaseDrug').datagrid('getChecked').length === 0) {
                PHA.Popover({
                    msg: '�빴ѡ��Ҫɾ���ļ�¼',
                    type: 'info'
                });
                return;
            }
            PHA.Confirm('��ʾ', '��ȷ��ɾ����?', HandleDeleteBaseDrug);
        });
        $('#btnDeleteBaseLoc').on('click', function () {
            if ($('#gridBaseLoc').datagrid('getChecked').length === 0) {
                PHA.Popover({
                    msg: '�빴ѡ��Ҫɾ���ļ�¼',
                    type: 'info'
                });
                return;
            }
            PHA.Confirm('��ʾ', '��ȷ��ɾ����?', HandleDeleteBaseLoc);
        });
        $('#btnFind').on('click', function () {
            QueryBaseLoc();
        });
    }
    /** ��ʼ������ */
    function InitDict() {
        $('#fileName').filebox({
            prompt: $g('��ѡ���ļ�...'),
            buttonText: $g('ѡ��'),
            width: 250,
            accept: 'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        });
        PHA.ComboBox('departmentGroup', {
            url: PHA_STORE.RBCDepartmentGroup().url,
            width: 361,
            multiple: true,
            editable: false,
            rowStyle: 'checkbox',
            panelHeight: 'auto',
            onHidePanel: LoadSelectLoc
        });
        PHA.SearchBox('locFilterText', {
            width: 361,
            searcher: LoadSelectLoc
        });
        PHA.ComboBox('arcItmCat', {
            width: 558,
            url: PHA_STORE.ARCItemCat().url,
            multiple: true,
            rowStyle: 'checkbox',
            // panelHeight:'auto',
            onHidePanel: LoadSelectDrug
        });
        $('#arcItmCat')
            .next()
            .on('click', function () {
                $('#arcItmCat').combobox('showPanel');
            });
        PHA.SearchBox('drugFilterText', {
            width: 558,
            searcher: LoadSelectDrug
        });
        PHA.ComboBox('mainLoc', {
            url: PHA_STORE.CTLoc().url,
            onHidePanel: function () {
                $('#btnFind').click();
            }
        });
        PHA_IP_BASEDRUG.Config = PHA.CM(
            {
                pClassName: 'PHA.IP.BaseDrug.Api',
                pMethodName: 'GetSettings',
                pJson: JSON.stringify({
                    logonLoc: session['LOGON.CTLOCID'],
                    logonUser: session['LOGON.USERID'],
                    logonGroup: session['LOGON.GROUPID'],
                    logonHosp: session['LOGON.HOSPID']
                })
            },
            false
        );
        $('#btnFind').click();
    }
    /** ��ʼ���������� */
    function InitGridBaseLoc() {
        var columns = [
            [
                {
                    field: 'rowID',
                    title: 'rowID',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'locID',
                    title: 'locID',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'locID',
                    title: 'locID',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'mainLocID',
                    title: 'mainLocID',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'mainLocDesc',
                    title: '������',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'locDesc',
                    title: '����',
                    width: 200
                },

                {
                    field: 'inciCnt',
                    title: 'Ʒ����',
                    width: 50,
                    align: 'right'
                },
                {
                    field: 'makeOrderBaseFlag',
                    title: '������ҽ��Ϊ����ҩ',
                    width: 120,
                    align: 'center',
                    formatter: function (value, rowData, rowIndex) {
                        var chkValue = value === 0 ? false : true;
                        return '<div class="hisui-switchbox" data-options="checked:' + chkValue + '"></div>';
                    }
                }
            ]
        ];
        var dataGridOption = {
            exportXls: false,
            url: null,
            fitColumns: true,
            toolbar: '#gridBaseLocBar',
            columns: columns,
            rownumbers: true,
            singleSelect: true,
            checkOnSelect: true,
            selectOnCheck: true,
            pagination: true,
            pageSize: 1000,
            pageList: [1000],
            pageNumber: 1,
            loadFilter: PHAIP_COM.LocalFilter,
            onSelect: function (rowIndex, rowData) {
                // QueryDetail();
                QueryBaseDrug();
            },
            onLoadSuccess: function () {
                // Clear();
                $(this).datagrid('loaded');
                $('#gridBaseDrug').datagrid('loadData', { total: 0, rows: [] }).datagrid('clearChecked');
                LocSwitchHandler();
            }
        };
        PHA.Grid('gridBaseLoc', dataGridOption);
    }
    function LocSwitchHandler() {
        $('#gridBaseLoc')
            .parent()
            .find('td[field="makeOrderBaseFlag"] .hisui-switchbox')
            .switchbox({
                offClass: 'gray',
                onText: '��',
                offText: '����',
                size: 'small',
                animated: true,
                disabled: PHA_IP_BASEDRUG.Config.baseMedManagementMode === '1' ? false : true,
                onSwitchChange: function (e, obj) {
                    HandleMakeOrderBase(e, obj, $('#gridBaseLoc'));
                }
            });
    }
    function DrugSwitchHandler() {
        $('#gridBaseDrug')
            .parent()
            .find('td[field="makeOrderBaseFlag"] .hisui-switchbox')
            .switchbox({
                offClass: 'gray',
                onText: '��',
                offText: '����',
                size: 'small',
                animated: true,
                disabled: PHA_IP_BASEDRUG.Config.baseMedManagementMode === '1' ? false : true,
                onSwitchChange: function (e, obj) {
                    HandleMakeOrderBase(e, obj, $('#gridBaseDrug'));
                }
            });
    }
    /** ��ʼ����������ҩƷ */
    function InitGridBaseDrug() {
        var columns = [
            [
                {
                    field: 'rowID',
                    title: 'rowID',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'gCheck',
                    checkbox: true
                },
                {
                    field: 'locID',
                    title: 'locID',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'inci',
                    title: 'inci',
                    width: 50,
                    hidden: true
                },

                {
                    field: 'inciDesc',
                    title: 'ҩƷ',
                    width: 300
                },
                {
                    field: 'repQty',
                    title: '����',
                    width: 100,
                    align: 'right',
                    editor: PHA_GridEditor.NumberBox({
                        precision: 0
                    }),
                    hidden: true
                },
                {
                    field: 'pUomDesc',
                    title: '��λ',
                    width: 100
                },
                {
                    field: 'arcItmCatDesc',
                    title: 'ҽ������',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'makeOrderBaseFlag',
                    title: '������ҽ��Ϊ����ҩ',
                    width: 140,
                    align: 'center',
                    formatter: function (value, rowData, rowIndex) {
                        var chkValue = value === 0 ? false : true;
                        return '<div class="hisui-switchbox" data-options="checked:' + chkValue + '"></div>';
                    }
                }
            ]
        ];
        var dataGridOption = {
            exportXls: false,
            url: null,
            fitColumns: false,
            toolbar: '#gridBaseDrugBar',
            columns: columns,
            rownumbers: true,
            singleSelect: true,
            checkOnSelect: false,
            selectOnCheck: false,
            pagination: true,
            pageSize: 1000,
            pageList: [1000],
            pageNumber: 1,
            loadFilter: PHAIP_COM.LocalFilter,
            onClickCell: function (index, field, value) {
                if (field !== 'repQty') {
                    return;
                }
                $(this).datagrid('uncheckRow', index);
                PHA_GridEditor.Edit({
                    gridID: 'gridBaseDrug',
                    index: index,
                    field: field,
                    forceEnd: true
                });
            },
            onEndEdit: function (rowIndex, rowData) {
                UpdateDrugRow(rowIndex, rowData);
            },
            onClickRow: function (rowIndex, rowData) {
                // QueryDetail();
            },
            onLoadSuccess: function () {
                // Clear();
                $(this).datagrid('loaded');
                $('#gridBaseDrug').datagrid('clearChecked');
                DrugSwitchHandler();
            }
        };
        PHA.Grid('gridBaseDrug', dataGridOption);
    }
    function InitWinSelectLoc() {
        var columns = [
            [
                {
                    field: 'locID',
                    title: 'locID',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'gCheck',
                    checkbox: true
                },
                {
                    field: 'locDesc',
                    title: '����',
                    width: 100
                }
            ]
        ];
        var dataGridOption = {
            exportXls: false,
            url: null,
            fitColumns: true,
            toolbar: '#gridSelectLocBar',
            columns: columns,
            pagination: false,
            rownumbers: true,
            border: true,
            singleSelect: false,
            checkOnSelect: true,
            selectOnCheck: true,
            pageNumber: 1,
            pageSize: 99999,
            pageList: [99999],
            headerCls: 'panel-header-gray',
            bodyCls: 'panel-body-gray',
            loadFilter: PHAIP_COM.LocalFilter,
            onClickRow: function (rowIndex, rowData) {
                // QueryDetail();
            },
            onLoadSuccess: function () {
                $(this).datagrid('loaded');
                $(this).datagrid('clearChecked');
                // Clear();
            }
        };
        PHA.Grid('gridSelectLoc', dataGridOption);
        /** ���� */
        var winId = 'winSelectLoc';
        var $win = $('#' + winId);
        $win.dialog({
            title: 'ѡ�����',
            collapsible: true,
            iconCls: 'icon-w-list',
            border: false,
            resizable: true,
            minimizable: false,
            maximizable: false,
            collapsible: false,
            closed: true,
            modal: true,
            width: 403,
            height: $('#lyCenterCenter').height(),
            // left: $('#lyCenterCenter').offset().left,
            // top: $('#lyCenterCenter').offset().top,
            onOpen: function () {
                LoadSelectLoc();
            },
            buttons: [
                {
                    text: '����',
                    handler: function () {
                        HandleSaveBaseLoc(function (ret) {
                            if (ret === true) {
                                $win.window('close');
                                QueryBaseLoc();
                            }
                        });
                    }
                },
                {
                    text: '��������',
                    handler: function () {
                        HandleSaveBaseLoc(function (ret) {
                            if (ret === true) {
                                QueryBaseLoc();
                                LoadSelectLoc();
                                $('#locFilterText').next().children().select().focus();
                            }
                        });
                    }
                },
                {
                    text: '�ر�',
                    handler: function () {
                        $win.window('close');
                    }
                }
            ]
        });
        $win.window('setModalable');
        // $win.window('open');
    }
    function InitWinSelectDrug() {
        var columns = [
            [
                {
                    field: 'inci',
                    title: 'inci',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'gCheck',
                    checkbox: true
                },
                {
                    field: 'inciDesc',
                    title: '����',
                    width: 200
                },
                {
                    field: 'spec',
                    title: '���',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'repQty',
                    title: '����',
                    width: 50,
                    align: 'right',
                    editor: PHA_GridEditor.NumberBox({
                        precision: 0
                    }),
                    hidden: true
                },
                {
                    field: 'pUomDesc',
                    title: '��λ',
                    width: 50
                }
            ]
        ];
        var dataGridOption = {
            exportXls: false,
            url: null,
            fitColumns: true,
            toolbar: '#gridSelectDrugBar',
            columns: columns,
            pagination: true,
            pageNumber: 1,
            pageSize: 100,
            pageList: [100, 300, 500, 1000],
            rownumbers: false,
            border: true,
            singleSelect: false,
            headerCls: 'panel-header-gray',
            bodyCls: 'panel-body-gray',
            loadFilter: PHAIP_COM.LocalFilter,
            onClickCell: function (index, field, value) {
                if (field !== 'repQty') {
                    return;
                }
                $(this).datagrid('uncheckRow', index);
                PHA_GridEditor.Edit({
                    gridID: 'gridSelectDrug',
                    index: index,
                    field: field,
                    forceEnd: true
                });
            },
            onClickRow: function (rowIndex, rowData) {
                // QueryDetail();
            },
            onLoadSuccess: function () {
                // Clear();
                $(this).datagrid('loaded');
                $(this).datagrid('clearChecked');
            }
        };
        PHA.Grid('gridSelectDrug', dataGridOption);
        /** ���� */
        var winId = 'winSelectDrug';
        var $win = $('#' + winId);
        $win.dialog({
            title: 'ѡ��ҩƷ',
            collapsible: true,
            iconCls: 'icon-w-list',
            border: false,
            resizable: true,
            minimizable: false,
            maximizable: false,
            collapsible: false,
            closed: true,
            modal: true,
            width: 600,
            height: $('#lyCenterCenter').height(), // @todo �߶�����Ӧ����
            toolbar: null,
            buttons: [
                {
                    text: '����',
                    handler: function () {
                        HandleSaveBaseDrugMulti(function (ret) {
                            if (ret === true) {
                                $win.window('close');
                                QueryBaseDrug();
                            }
                        });
                    }
                },
                {
                    text: '��������',
                    handler: function () {
                        HandleSaveBaseDrugMulti(function (ret) {
                            if (ret === true) {
                                QueryBaseDrug();
                                LoadSelectDrug();
                                $('#drugFilterText').next().children().select().focus();
                            }
                        });
                    }
                },
                {
                    text: '�ر�',
                    handler: function () {
                        $win.window('close');
                    }
                }
            ],
            onBeforeClose: function () {}
        });
        // $win.window('open');
    }
    function LoadSelectLoc() {
        $('#gridSelectLoc').datagrid('loading');
        $.cm(
            {
                ClassName: 'PHA.IP.BaseDrug.Api',
                MethodName: 'GetSelectLocRows',
                pJson: JSON.stringify({
                    hospID: $('#_HospList').combobox('getValue'),
                    mainLocID: $('#mainLoc').combobox('getValue'),
                    filterText: $('#locFilterText').searchbox('getValue'),
                    departmentGroup: $('#departmentGroup').combobox('getValues').join(',')
                })
            },
            function (retData) {
                if ($.type(retData) === 'object' && typeof retData.msg !== 'undefined') {
                    PHA.Alert('��ʾ', retData.msg, 'error');
                    $('#gridSelectLoc').datagrid('loaded');
                }
                $('#gridSelectLoc').datagrid('loadData', { rows: retData, total: retData.length });
            }
        );
    }
    function LoadSelectDrug() {
        $('#gridSelectDrug').datagrid('loading');
        $.cm(
            {
                ClassName: 'PHA.IP.BaseDrug.Api',
                MethodName: 'GetSelectDrugRows',
                pJson: JSON.stringify({
                    hospID: $('#_HospList').combobox('getValue'),
                    filterText: $('#drugFilterText').searchbox('getValue'),
                    arcItmCat: $('#arcItmCat').combobox('getValues').join(','),
                    mainLocID: $('#mainLoc').combobox('getValue'),
                    locID: $('#gridBaseLoc').datagrid('getSelected').locID
                })
            },
            function (retData) {
                if ($.type(retData) === 'object' && typeof retData.msg !== 'undefined') {
                    PHA.Alert('��ʾ', retData.msg, 'error');
                    $('#gridSelectDrug').datagrid('loaded');
                }
                $('#gridSelectDrug').datagrid('loadData', { rows: retData, total: retData.length });
            }
        );
    }
    /** ��ѯ����ҩ�����б� */
    function QueryBaseLoc() {
        $('#gridBaseLoc').datagrid('loading');
        $.cm(
            {
                ClassName: 'PHA.IP.BaseDrug.Api',
                MethodName: 'GetBaseLocRows',
                pJson: JSON.stringify({
                    mainLocID: $('#mainLoc').combobox('getValue')
                })
            },
            function (retData) {
                if ($.type(retData) === 'object' && typeof retData.msg !== 'undefined') {
                    PHA.Alert('��ʾ', retData.msg, 'error');
                    $('#gridBaseLoc').datagrid('loaded');
                }
                $('#gridBaseLoc').datagrid('loadData', { rows: retData, total: retData.length });
            }
        );
    }
    /** ��ѯ����ҩƴ�б� */
    function QueryBaseDrug() {
        $('#gridBaseDrug').datagrid('loading');

        $.cm(
            {
                ClassName: 'PHA.IP.BaseDrug.Api',
                MethodName: 'GetBaseDrugRows',
                pJson: JSON.stringify({
                    mainLocID: $('#mainLoc').combobox('getValue'),
                    locID: $('#gridBaseLoc').datagrid('getSelected').locID
                })
            },
            function (retData) {
                if ($.type(retData) === 'object' && typeof retData.msg !== 'undefined') {
                    PHA.Alert('��ʾ', retData.msg, 'error');
                    $('#gridBaseDrug').datagrid('loaded');
                }
                $('#gridBaseDrug').datagrid('loadData', { rows: retData, total: retData.length });
            }
        );
    }
    /** ������� */
    function HandleSaveBaseLoc(callback) {
        var checkedData = GetCheckedLoc();
        if (checkedData.length === 0) {
            PHA.Popover({
                msg: '�빴ѡ��Ҫ����ļ�¼',
                type: 'info'
            });
            return false;
        }
        $.cm(
            {
                ClassName: 'PHA.IP.BaseDrug.Api',
                MethodName: 'HandleSaveBaseLoc',
                pJson: JSON.stringify(checkedData)
            },
            function (retData) {
                if (retData.code == 0) {
                    callback(true);
                }
            },
            function (retData) {
                callback(false);
            }
        );
    }
    function GetCheckedLoc() {
        var dataRows = $('#gridSelectLoc').datagrid('getChecked');
        var retRows = [];
        dataRows.forEach(function (data) {
            retRows.push({
                locID: data.locID,
                mainLocID: $('#mainLoc').combobox('getValue'),
                makeOrderBaseFlag: PHA_IP_BASEDRUG.Config.baseMedManagementMode === '1' ? 0 : 1
            });
        });
        return retRows;
    }
    /** ����ҩƷ */
    function HandleSaveBaseDrugMulti(callback) {
        var baseLocRows = $('#gridBaseLoc').datagrid('getChecked');
        var drugCheckedRows = JSON.parse(JSON.stringify($('#gridSelectDrug').datagrid('getChecked')));
        var drugRows = [];
        drugCheckedRows.forEach(function (row, index) {
            drugRows.push({
                inci: row.inci
            });
        });
        if (PHA_IP_BASEDRUG.Config.baseMedManagementMode !== '1') {
            $.each(drugRows, function (indexInArray, valueOfElement) {
                valueOfElement.makeOrderBaseFlag = 1;
            });
        }
        if (baseLocRows.length === 0 || drugRows.length === 0) {
            PHA.Popover({
                msg: '�빴ѡ��Ҫ����ļ�¼',
                type: 'info'
            });
            return false;
        }
        $.cm(
            {
                ClassName: 'PHA.IP.BaseDrug.Api',
                MethodName: 'HandleSaveBaseDrug',
                pJson: JSON.stringify({
                    locRows: baseLocRows,
                    drugRows: drugRows
                })
            },
            function (retData) {
                if (retData.code == 0) {
                    callback(true);
                } else {
                    PHA.Alert('��ʾ', JSON.stringify(retData.msg), 'error');
                }
            },
            function (retData) {
                PHA.Alert('��ʾ', JSON.stringify(retData.msg), 'error');
            }
        );
    }

    /** ɾ��ҩƷ */
    function HandleDeleteBaseDrug() {
        var rows = $('#gridBaseDrug').datagrid('getChecked');
        var data4save = [];
        rows.forEach(function (row, index) {
            data4save.push({
                rowID: row.rowID
            });
        });
        $.cm(
            {
                ClassName: 'PHA.IP.BaseDrug.Api',
                MethodName: 'HandleDeleteBaseDrug',
                pJson: JSON.stringify({ rows: data4save })
            },
            function (retData) {
                if (retData.code === 0) {
                    PHA.Popover({
                        msg: 'ɾ���ɹ�',
                        type: 'success'
                    });
                    QueryBaseDrug();
                    return;
                }
                PHA.Alert('��ʾ', retData.msg, 'error');
            },
            function (retData) {
                PHA.Alert('��ʾ', JSON.stringify(retData), 'error');
            }
        );
    }
    /** ɾ������ */
    function HandleDeleteBaseLoc() {
        var rows = $('#gridBaseLoc').datagrid('getChecked');
        $.cm(
            {
                ClassName: 'PHA.IP.BaseDrug.Api',
                MethodName: 'HandleDeleteBaseLoc',
                pJson: JSON.stringify({ rows: rows })
            },
            function (retData) {
                if (retData.code === 0) {
                    PHA.Popover({
                        msg: 'ɾ���ɹ�',
                        type: 'success'
                    });
                    QueryBaseLoc();
                    return;
                }
                PHA.Alert('��ʾ', retData.msg, 'error');
            },
            function (retData) {
                PHA.Alert('��ʾ', JSON.stringify(retData), 'error');
            }
        );
    }
    function UpdateDrugRow(rowIndex, rowData) {
        $.cm(
            {
                ClassName: 'PHA.IP.BaseDrug.Api',
                MethodName: 'HandleUpdateBaseDrug',
                pJson: JSON.stringify(rowData)
            },
            function (retData) {
                if (retData.code == 0) {
                    PHA.Popover({
                        msg: '�޸ĳɹ�',
                        type: 'success'
                    });
                    $('#gridBaseDrug').datagrid('updateRow', {
                        index: rowIndex,
                        row: retData.data
                    });
                    return;
                }
                PHA.Alert('��ʾ', retData.msg, 'error');
            },
            function (retData) {
                PHA.Alert('��ʾ', JSON.stringify(retData), 'error');
            }
        );
    }
    function HandleMakeOrderBase(e, obj, $grid) {
        var $target = $(e.target);
        var rowIndex = $target.closest('tr').attr('datagrid-row-index');
        var rowData = $grid.datagrid('getRows')[rowIndex];
        var rowID = rowData.rowID;
        var makeOrderBaseFlag = obj.value === true ? 1 : 0;
        var saveData = {
            rows: [
                {
                    rowID: rowID,
                    makeOrderBaseFlag: makeOrderBaseFlag
                }
            ]
        };

        $.cm(
            {
                ClassName: 'PHA.IP.BaseDrug.Api',
                MethodName: 'HandleMakeOrderBase',
                pJson: JSON.stringify(saveData)
            },
            function (retData) {
                if (retData.code == 0) {
                    PHA.Popover({
                        msg: '�޸ĳɹ�',
                        type: 'success',
                        timeout: 500
                    });
                    $grid.datagrid('reload');
                } else {
                    PHA.Alert('��ʾ', retData.msg, 'error');
                    $grid.datagrid('reload');
                }
            },
            function (retData) {
                PHA.Alert('��ʾ', retData.msg, 'error');
                $grid.datagrid('reload');
            }
        );
    }

    function ClearDataGrid() {
        $('#gridBaseLoc, #gridBaseDrug').datagrid('loadData', { total: 0, rows: [] });
        $('#gridBaseLoc, #gridBaseDrug').datagrid('clearChecked');
    }
    function InitHosp() {
        var hospComp = GenHospComp('CF_PHA_IN.BaseDrug', '', { width: 245 });
        hospComp.options().onSelect = function (rowIndex, rowData) {
            PHA_COM.Session.HOSPID = rowData.HOSPRowId;
            PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
            InitDict();
        };
        var defHosp = $.cm(
            {
                dataType: 'text',
                ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
                MethodName: 'GetDefHospIdByTableName',
                tableName: 'CF_PHA_IN.BaseDrug',
                HospID: PHA_COM.Session.HOSPID
            },
            false
        );
        PHA_COM.Session.HOSPID = defHosp;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        InitDict();
        $('#mainLoc').combobox('setValue', PHA_COM.Session.CTLOCID);
    }
});
