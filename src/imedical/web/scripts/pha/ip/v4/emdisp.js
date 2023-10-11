/**
 * �������۷�ҩ
 * @author  yunhaibao
 * @date    2022-09-21
 */
// PHA_SYS_SET = undefined;
$(function () {
    /** ��ҩ����, �ò��� */
    var settings = PHA.CM(
        {
            pClassName: 'PHA.IP.Disp.Api',
            pMethodName: 'GetDispSettings',
            pJson: JSON.stringify({
                logonLoc: session['LOGON.CTLOCID'],
                logonUser: session['LOGON.USERID'],
                logonGroup: session['LOGON.GROUPID'],
                macAddr: PHAIP_COM.GetMac()
            })
        },
        false
    );
    PHA_COM.App.Csp = 'pha.ip.v4.emdisp.csp';
    var PHA_IP_EMDISP = {
        WardFlag: session['LOGON.WARDID'] != '' ? 'Y' : 'N',
        DefaultData: [settings.defaultData],
        DISPCATARR: settings.dispCatArr,
        DISPCATDEFSELECT: settings.dispCatSelectArr,
        Config: settings.config,
        LocalConfig: settings.localConfig,
        HandleVars: {
            RefuseReason: '', // �ܾ���ҩԭ��
            DispUser: '', // ѡ��ķ�ҩ��
            DispCollateUser: '', // ѡ��ĺ˶���
            DispOperateUser: '', // ѡ�����ҩ��
            Pid: '',
            PhacIDArr: [],
            NeedPrint: true, // ��Ҫ��ӡ��ҩ��,
            PrintTotal: false,
            PrintDetail: false
        },
        // ����������ͬ���ߵ���Ϣ, ʹ�������ݷ��������
        OrderSameRowsHanlder: PHAIP_COM.SameRows('gridOrder', '[field=patNo],[field=sex],[field=patName],[field=bedNo],[field=docLocDesc],[field=age]')
    };

    InitDict();
    InitGridAdm();
    InitGridOrder();
    InitGridInci();
    InitSelectPrintWay();
    $('#patNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $(this).val(PHA_COM.FullPatNo($(this).val()));
            Query();
        }
    });
    PHA_EVENT.Bind('#btnFind', 'click', function () {
        Query();
    });
    PHA_EVENT.Bind('#btnRefresh', 'click', function () {
        QueryDetail();
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        HandleClean();
    });
    $('#btnAllSelect').on('click', function () {
        PHAIP_COM.LocalCheckPage($('#gridOrder'), 'Y', 0, 999999);
        $('#gridOrder').datagrid('checkAll');
    });
    $('#btnAllUnSelect').on('click', function () {
        PHAIP_COM.LocalCheckPage($('#gridOrder'), '', 0, 999999);
        $('#gridOrder').datagrid('uncheckAll');
    });
    PHA_EVENT.Bind('#btnDisp', 'click', function () {
        PHA_IP_EMDISP.HandleVars.NeedPrint = false;
        PHAIP_COM.CACert('PHAIPDisp', HandleDisp);
    });
    PHA_EVENT.Bind('#btnDispPrint', 'click', function () {
        PHA_IP_EMDISP.HandleVars.NeedPrint = true;
        PHAIP_COM.CACert('PHAIPDisp', HandleDisp);
    });
    function InitDict() {
        PHA.ComboBox('dispCat', {
            rowStyle: 'checkbox',
            editable: false,
            multiple: true,
            panelHeight: 'auto',
            url: PHAIP_STORE.StkDrugGroup().url + '&loc=' + session['LOGON.CTLOCID'],
            onHidePanel: function () {
                Query();
            }
        });

        var emLocData = $.cm(
            {
                ClassName: 'PHA.STORE.Org',
                QueryName: 'EMLGLoc',
                HospId: PHA_COM.Session.HOSPID
            },
            false
        );
        var emLocRows = emLocData.rows;
        for (var i = 0, length = emLocRows.length; i < length; i++) {
            var emLocRowData = emLocRows[i];
            if (i === 0) {
                $('#tabsTotal').tabs('add', {
                    id: 'gridAdmTab',
                    title: emLocRowData.Description,
                    emLocID: emLocRowData.RowId,
                    content: '<table id="gridAdm"></table>'
                });
            } else {
                $('#tabsTotal').tabs('add', {
                    title: emLocRowData.Description,
                    emLocID: emLocRowData.RowId
                });
            }
        }
        $('#tabsTotal').tabs({
            onSelect: function () {
                $('#gridAdmTab').parent().show();
                try {
                    Query();
                } catch (e) {}
            }
        });
        $('#tabsDetail').tabs({
            onSelect: function () {
                QueryDetail('tabSelect');
            }
        });
        PHA.SetVals(PHA_IP_EMDISP.DefaultData);
    }

    function InitGridAdm() {
        var frozenColumns = [
            [
                {
                    checkbox: true,
                    field: 'gCheck'
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'adm',
                    title: 'adm',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'reqLocDesc',
                    title: 'ȡҩ����',
                    width: 100,
                    sortable: true,
                    hidden: true
                },
                {
                    field: 'bedNo',
                    title: '����',
                    width: 50,
                    align: 'center'
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
                    field: 'age',
                    title: '����',
                    width: 50
                },
                {
                    field: 'sex',
                    title: '�Ա�',
                    width: 50
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            exportXls: false,
            frozenColumns: frozenColumns,
            columns: columns,
            toolbar: [],
            showPageList: false,
            pageNumber: 1,
            pageSize: 999999,
            pageList: [999999],
            autoSizeColumn: true,
            singleSelect: false,
            selectOnCheck: true,
            checkOnSelect: true,
            queryOnSelect: false,
            fitColumns: true,
            loadFilter: PHAIP_COM.LocalFilter,
            onLoadSuccess: function () {
                $(this).datagrid('loaded');
                $(this).datagrid('clearChecked');
                $('#gridOrder').datagrid('clear');
                $('#gridInci').datagrid('clear');
            },
            onCheck: function () {
                QueryDetail();
            },
            onUncheck: function () {
                QueryDetail();
            },
            onCheckAll: function () {
                QueryDetail();
            },
            onUncheckAll: function () {
                QueryDetail();
            }
        };
        PHA.Grid('gridAdm', dataGridOption);
    }
    function InitGridOrder() {
        var frozenColumns = [
            [
                {
                    field: 'gCheck',
                    checkbox: true
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'warnInfo',
                    title: '����',
                    width: 100,
                    styler: function (value) {
                        if (value !== '') {
                            return { class: 'phaip-datagrid-warn-normal' };
                        }
                    }
                },
                {
                    field: 'dspStr',
                    title: 'dspStr',
                    width: 50,
                    hidden: true
                },

                {
                    field: 'docLocDesc',
                    title: '��������',
                    width: 100
                },
                {
                    field: 'bedNo',
                    title: '����',
                    width: 60,
                    hidden: true
                },
                {
                    field: 'patNo',
                    title: '�ǼǺ�',
                    width: 100,
                    hidden: true
                    //                    ,
                    //                    formatter: function (value, row, index) {
                    //                        return '<a class="pha-grid-a js-grid-patNo">' + value + '</a>';
                    //                    }
                },
                {
                    field: 'patName',
                    title: '����',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'age',
                    title: '����',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'sex',
                    title: '�Ա�',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'orderLinkSign',
                    title: '��',
                    width: 30,
                    formatter: function (value) {
                        return PHAIP_COM.OrderLinkSign(value);
                    }
                },
                {
                    field: 'inciDesc',
                    title: 'ҩƷ����',
                    width: 200,
                    formatter: function (value, rowData, rowIndex) {
                        var pre = '';
                        if (rowData.skinTestDesc !== '') {
                            if (rowData.skinTestValue == -1) {
                                pre = '<span style="color:red;padding-right:0.5rem;">' + rowData.skinTestDesc + '</span>';
                            } else {
                                pre = '<span style="padding-right:0.5rem;">' + rowData.skinTestDesc + '</span>';
                            }
                        }
                        return pre + value;
                    }
                },
                {
                    field: 'qty',
                    title: '����',
                    width: 50,
                    align: 'right'
                },
                {
                    field: 'uomDesc',
                    title: '��λ',
                    width: 50
                },
                {
                    field: 'dosage',
                    title: '����',
                    width: 50
                },
                {
                    field: 'doseDateTime',
                    title: '��ҩʱ��',
                    width: 100,
                    formatter: function (value, rowData) {
                        return rowData.doseDate + ' ' + rowData.doseTimeStr;
                    }
                },
                {
                    field: 'freqDesc',
                    title: 'Ƶ��',
                    width: 75
                },
                {
                    field: 'priDesc',
                    title: 'ҽ������',
                    width: 75,
                    align: 'center'
                },
                {
                    field: 'oeoriRemark',
                    title: 'ҽ����ע',
                    width: 75,
                    showTip: true
                },
                {
                    field: 'instrucDesc',
                    title: '�÷�',
                    width: 75
                },
                {
                    field: 'duraDesc',
                    title: '�Ƴ�',
                    width: 75
                },
                {
                    field: 'oeoriStatDesc',
                    title: 'ҽ��״̬',
                    width: 75
                },
                {
                    field: 'diagDesc',
                    title: '���',
                    width: 150,
                    showTip: true
                },

                {
                    field: 'oeoriDateTime',
                    title: '����ʱ��',
                    width: 155
                },
                {
                    field: 'manfDesc',
                    title: '������ҵ',
                    width: 100
                },
                {
                    field: 'oeori',
                    title: 'ҽ��ID',
                    width: 100,
                    formatter: function (value, row, index) {
                        return '<a class="pha-grid-a">' + value + '</a>';
                    }
                },
                {
                    field: 'inciCode',
                    title: 'ҩƷ����',
                    width: 100,
                    formatter: function (value, row, index) {
                        return '<a class="pha-grid-a">' + value + '</a>';
                    }
                },
                {
                    field: 'sameFlag',
                    title: 'sameFlag',
                    width: 70,
                    hidden: true,
                    styler: function (value, row, index) {
                        if (value === 'Y') {
                            return {
                                class: 'pha-ip-person-toggle'
                            };
                        }
                    }
                },
                {
                    field: 'sortIndex',
                    title: 'sortIndex',
                    width: 100,
                    hidden: true
                }
            ]
        ];

        var dataGridOption = {
            toolbar: '#gridOrderBar',
            singleSelect: false,
            url: '',
            exportXls: false,
            pagination: true,
            frozenColumns: frozenColumns,
            loadFilter: PHAIP_COM.LocalFilterGroup,
            columns: columns,
            linkField: 'sortIndex',
            rownumbers: false,
            view: groupview,
            groupField: 'adm',
            groupFormatter: function (value, rows) {
                var rowData = rows[0];
                var divArr = [];
                divArr.push('<div class="pha-ip-disp-order-group">');
                divArr.push('   <div style="width:100px;" class="pha-tips-group">');
                if (rowData.oweInfo !== '') {
                    divArr.push('   <div class="pha-tips pha-tips-owe">' + $g('Ƿ��') + '</div>');
                }
                divArr.push('   ��</div>');
                divArr.push('   <div style="min-width:50px;">' + rowData.bedNo + '</div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div class="pha-ip-disp-order-patNo"><a style="cursor:pointer;">' + rowData.patNo + '</a></div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div style="min-width:100px;">' + rowData.patName + '</div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div style="min-width:20px;">' + rowData.sex + '</div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div style="min-width:20px;">' + rowData.age + '</div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div style="text-overflow:ellipsis;max-width:1000px">' + rowData.admDiagDesc + '</div>');
                divArr.push('</div>');
                return divArr.join('');
            },
            onLoadSuccess: function (data) {
                $(this).datagrid('loaded');

                //DestroyTooltip();
                var $grid = $(this);
                $grid.datagrid('options').checking = true;
                var row0Data = data.rows[0];
                if (row0Data) {
                    $grid.datagrid('uncheckAll');
                    var rows = $grid.datagrid('getRows');
                    var rowsLen = rows.length;
                    for (var index = rowsLen - 1; index >= 0; index--) {
                        var rowData = rows[index];
                        var check = rowData.check;
                        if (check === 'Y') {
                            $grid.datagrid('checkRow', index);
                        }
                    }
                } else {
                    $grid.datagrid('uncheckAll');
                }
                $grid.datagrid('scrollTo', 0);
                $grid.datagrid('options').checking = '';
                PHA_IP_EMDISP.OrderSameRowsHanlder.Hide();
                BindGridEvents();
                // $('#gridOrder').datagrid('clear');
            },
            onCheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                PHAIP_COM.DataGridLinkCheck($(this), 'checkRow', rowIndex, rowData, function (i, data) {
                    $('#gridOrder').datagrid('updateRow', {
                        index: i,
                        row: { check: 'Y' }
                    });
                    BindGridEvents();
                    if (data.sameFlag === 'Y') {
                        PHA_IP_EMDISP.OrderSameRowsHanlder.HideRow(i);
                    }
                });
            },
            onUncheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                PHAIP_COM.DataGridLinkCheck($(this), 'uncheckRow', rowIndex, rowData, function (i, data) {
                    $('#gridOrder').datagrid('updateRow', {
                        index: i,
                        row: { check: 'N' }
                    });
                    BindGridEvents();
                    if (data.sameFlag === 'Y') {
                        PHA_IP_EMDISP.OrderSameRowsHanlder.HideRow(i);
                    }
                });
            },
            onSelect: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                if (rowData.sameFlag === 'Y') {
                    PHA_IP_EMDISP.OrderSameRowsHanlder.HideRow(rowIndex);
                }
            },
            onUnselect: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                if (rowData.sameFlag === 'Y') {
                    PHA_IP_EMDISP.OrderSameRowsHanlder.HideRow(rowIndex);
                }
            },
            onCheckAll: function (rows) {
                PHAIP_COM.PageCheckHandler($(this), 'Y');
            },
            onUncheckAll: function (rows) {
                PHAIP_COM.PageCheckHandler($(this), 'N');
            },
            onClickCell: function (rowIndex, field, value) {
                if (field === 'patNo' && value !== '') {
                    //DestroyTooltip();
                    PHA_UX.AdmDetail({ modal: true }, { AdmId: $(this).datagrid('getRows')[rowIndex].adm });
                }
                if (field === 'oeori') {
                    //DestroyTooltip();
                    PHA_UX.OrderDetail({ modal: true }, { Oeori: $(this).datagrid('getRows')[rowIndex].oeori });
                }
                if (field === 'inciCode') {
                    //DestroyTooltip();
                    PHA_UX.DrugDetail({ modal: true }, { inci: $(this).datagrid('getRows')[rowIndex].inci });
                }
            }
        };
        PHA.Grid('gridOrder', dataGridOption);

        function BindGridEvents() {
            $('.pha-ip-disp-order-patNo').unbind();
            $('.pha-ip-disp-order-patNo').on('click', function () {
                var rowIndex = $($(event.target).closest('.datagrid-group').next().find('.datagrid-row')[0]).attr('datagrid-row-index');
                var rowData = $('#gridOrder').datagrid('getRows')[rowIndex];
                var adm = rowData.adm || '';
                if (adm === '') {
                    return;
                }
                PHA_UX.AdmDetail({ modal: true }, { AdmId: adm });
            });
            //            $('.pha-ip-disp-order-patNo').hover(function (e) {
            //                try{
            //                    $(e.target).tooltip('options')
            //                }catch(error){
            //                    var rowIndex = $($(event.target).closest('.datagrid-group').next().find('.datagrid-row')[0]).attr('datagrid-row-index');
            //                    var rowData = $('#gridOrder').datagrid('getRows')[rowIndex];
            //                    var tableArr = [];
            //                    tableArr.push('<table class="gridOrderTooltip" style="color:#fff">');
            //                    tableArr.push('<tr><td>�ǼǺ�:</td><td>' + rowData.patNo + '</td></tr>');
            //                    tableArr.push('<tr><td>����:</td><td>' + rowData.patName + '</td></tr>');
            //                    tableArr.push('<tr><td>�Ա�:</td><td>' + rowData.sex + '</td></tr>');
            //                    tableArr.push('<tr><td>����:</td><td>' + rowData.age + '</td></tr>');
            //                    tableArr.push('<tr><td>���:</td><td>' + rowData.admDiagDesc || '' + '</td></tr>');
            //                    tableArr.push('</table>');
            //                    $(e.target).tooltip({
            //                        content: tableArr.join(''),
            //                        showDelay: 500
            //                    })
            //                }finally{
            //
            //                 $(e.target).tooltip('show');;
            //                }
            //            });
        }
    }
    function InitGridInci() {
        var frozenColumns = [
            [
                {
                    checkbox: true,
                    field: 'gCheck',
                    hidden: true
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'inci',
                    title: 'inci',
                    hidden: true,
                    width: 150
                },
                {
                    field: 'warnInfo', // ����ɫ+showTip
                    title: '����',
                    width: 100,
                    styler: function (value) {
                        if (value !== '') {
                            return { class: 'phaip-datagrid-warn-normal' };
                        }
                    }
                },
                {
                    field: 'formDesc',
                    title: '����',
                    width: 100
                },
                {
                    field: 'inciCode',
                    title: 'ҩƷ����',
                    width: 100
                },
                {
                    field: 'inciDesc',
                    title: 'ҩƷ����',
                    width: 200,
                    showTip: true
                },
                {
                    field: 'qty',
                    title: '����',
                    width: 50,
                    align: 'right'
                },
                {
                    field: 'uomDesc',
                    title: '��λ',
                    width: 50,
                    align: 'center'
                },
                {
                    field: 'spec',
                    title: '���',
                    width: 100
                },
                {
                    field: 'manfDesc', // һ��ǰ�����־͹�����, ��˿��100
                    title: '������ҵ',
                    width: 100
                },
                {
                    field: 'bedNoStr',
                    title: '���� / ����',
                    width: 200,
                    showTip: true
                },
                {
                    field: 'sp',
                    title: '�ۼ�',
                    width: 100,
                    align: 'right'
                },
                {
                    field: 'spAmt',
                    title: '�ۼ۽��',
                    width: 100,
                    align: 'right'
                },
                {
                    field: 'insuCode',
                    title: '����ҽ������',
                    width: 100
                },
                {
                    field: 'insuDesc',
                    title: '����ҽ������',
                    width: 100
                },
                {
                    field: 'stkBinDesc',
                    title: '��λ'
                },
                {
                    field: 'dspStr',
                    title: 'dspStr',
                    width: 100,
                    hidden: true
                }
            ]
        ];
        // todo ���������б�Ҫ�޸��¸�ʽ,����Ҫʹ�ù��������ܿ�ȫ
        var dataGridOption = {
            url: null,
            exportXls: false,
            toolbar: '#gridInciBar',
            frozenColumns: frozenColumns,
            singleSelect: true,
            columns: columns,
            exportXls: true,
            pageList: [999999],
            pageSize: 999999,
            pagination: true,
            showPageList: false,
            rownumbers: true,
            onLoadSuccess: function (data) {
                if (data.rows.length > 0) {
                    $('#gridInciBar div').hide();
                } else {
                    $('#gridInciBar div').show();
                }
            }
        };
        PHA.Grid('gridInci', dataGridOption);
    }

    function InitSelectPrintWay() {
        $('#kwPrintWay').keywords({
            singleSelect: false,
            items: [
                { text: '��ӡ����', id: 'total' },
                { text: '��ӡ��ϸ', id: 'detail' }
            ]
        });
        $('#winSelectPrintWay').dialog({
            title: '��ӡ��ʽ',
            collapsible: false,
            iconCls: 'icon-w-list',
            maximizable: false,
            minimizable: false,
            border: false,
            closable: false,
            closed: true,
            modal: true,
            width: 500,
            onOpen: function () {
                $('#winSelectPrintWay')
                    .window('resize', {
                        width: $('#winSelectPrintWay .pha-con-table').width() + 10,
                        height: 'auto'
                    })
                    .window('center');
            },
            buttons: [
                {
                    text: 'ȷ��',
                    handler: function () {
                        var selData = $('#kwPrintWay').keywords('getSelected');
                        if (selData.length === 0) {
                            PHA.Popover({
                                msg: '����ѡ���ӡ��ʽ',
                                type: 'info'
                            });
                            return;
                        }
                        PHA_IP_EMDISP.HandleVars.PrintTotal = false;
                        PHA_IP_EMDISP.HandleVars.PrintDetail = false;
                        
                        for (var i = 0, length = selData.length; i < length; i++) {
                            if (selData[i].id === 'total') {
                                PHA_IP_EMDISP.HandleVars.PrintTotal = true;
                            }
                            if (selData[i].id === 'detail') {
                                PHA_IP_EMDISP.HandleVars.PrintDetail = true;
                            }
                        }
                        $('#winSelectPrintWay').dialog('close');
                        ExecuteDisp();
                    }
                },
                {
                    text: 'ȡ��',
                    handler: function () {
                        $('#winSelectPrintWay').dialog('close');
                    }
                }
            ]
        });
    }
    function Query() {
        var pJson = PHA_COM.Condition('.qCondition', 'get');
        pJson.loc = session['LOGON.CTLOCID'];
        pJson.takeLoc = $('#tabsTotal').tabs('getSelected').panel('options').emLocID;
        pJson.loc = session['LOGON.CTLOCID'];
        pJson.admStr = '';
        PHA_COM.LoadData(
            'gridAdm',
            {
                pClassName: 'PHA.IP.Disp.Api',
                pMethodName: 'GetEMAdmDataRows',
                pJson: JSON.stringify(pJson)
            },
            function (retData) {}
        );
    }
    function QueryDetail(qType) {
        qType = qType || '';
        if (qType === '') {
            $('#tabsDetail').tabs('select', 0);
        }
        var conditionStr;
        var tabCode = $('#tabsDetail').tabs('getSelected').panel('options').code;
        var pJson = GetQueryDetailCondition();
        pJson.qType = 'detail';
        var pJsonStr;
        if (tabCode === 'inci') {
            pJson.dspArr = GetDataCheckedDsp().join(',').split(',');
            pJsonStr = JSON.stringify(pJson);
            conditionStr = GetTargetCondition('#gridInci');
            if (qType === 'tabSelect' && conditionStr !== '' && conditionStr == pJsonStr) {
                return;
            }
            $('#gridInci').datagrid('options').url = PHA.$URL;
            $('#gridInci').datagrid('query', {
                pClassName: 'PHA.IP.Disp.Api',
                pMethodName: 'GetDispInciData',
                pJson: pJsonStr
            });
            SetTargetCondition('#gridInci', pJsonStr);
        } else {
            pJsonStr = JSON.stringify(pJson);
            conditionStr = GetTargetCondition('#gridOrder');
            if (qType === 'tabSelect' && conditionStr !== '' && conditionStr == pJsonStr) {
                return;
            }
            PHA_COM.LoadData(
                'gridOrder',
                {
                    pClassName: 'PHA.IP.Disp.Api',
                    pMethodName: 'GetEMDispOrderDataRows',
                    pJson: pJsonStr
                },
                function () {}
            );

            SetTargetCondition('#gridOrder', pJsonStr);
        }
        return;
    }
    function GetQueryDetailCondition() {
        var pJson = PHA_COM.Condition('.qCondition', 'get');
        pJson.loc = session['LOGON.CTLOCID'];
        pJson.takeLoc = $('#tabsTotal').tabs('getSelected').panel('options').emLocID;
        pJson.loc = session['LOGON.CTLOCID'];
        pJson.admStr = GetDataCheckedAdm().join(',');
        return pJson;
    }
    function GetTargetCondition(target) {
        return $.data($(target)[0], 'condition');
    }
    function SetTargetCondition(target, condition) {
        $.data($(target)[0], 'condition', condition);
    }
    function GetCheckedDsp() {
        var retArr = [];
        var checkRows = $('#gridOrder').datagrid('getChecked');
        for (var i = 0, length = checkRows.length; i < length; i++) {
            retArr.push(checkRows[i].dspStr);
        }
        return retArr;
    }
    function GetDataCheckedDsp() {
        var dspArr = [];
        checkRows = $('#gridOrder').datagrid('getData').originalRows;
        for (var j = 0, j_length = checkRows.length; j < j_length; j++) {
            var rowData = checkRows[j];
            if (rowData.check !== 'Y') {
                continue;
            }
            dspArr.push(rowData.dspStr);
        }
        return dspArr;
    }
    function GetDataCheckedAdm() {
        var admArr = [];
        var checkRows = $('#gridAdm').datagrid('getChecked');
        for (var j = 0, j_length = checkRows.length; j < j_length; j++) {
            admArr.push(checkRows[j].adm);
        }
        return admArr;
    }
    function ValidateCondition() {
        return true;
        var tabCode = $('#tabsDetail').tabs('getSelected').panel('options').code;
        var pJsonStr = JSON.stringify(GetQueryDetailCondition());
        if (tabCode === 'inci') {
            if (GetTargetCondition('#gridInci') !== pJsonStr) {
                return 'ҩƷ��������������ѯ������һ��';
            }
        } else if (tabCode === 'order') {
            if (GetTargetCondition('#gridOrder') !== pJsonStr) {
                return 'ҽ����ϸ����������ѯ������һ��';
            }
        }
        return true;
    }
    function HandleDisp() {
        var dspArr = GetDataCheckedDsp();
        if (dspArr.length === 0) {
            PHA.Popover({
                msg: '���ȹ�ѡ��Ҫ��ҩ������',
                type: 'info'
            });
            return;
        }
        // �������۷�ҩ, ����Ҫѡ��ҩ�˺˶���
        var handleDesc = PHA_IP_EMDISP.HandleVars.NeedPrint === true ? '��ҩ����ӡ' : '��ҩ';
        if (PHA_IP_EMDISP.HandleVars.NeedPrint === true) {
            $('#winSelectPrintWay').dialog('open');
        } else {
            PHA.Confirm('��ʾ', '��ȷ�ϡ�' + handleDesc + '����?', function () {
                ExecuteDisp();
            });
        }
    }

    function ExecuteDisp() {
        var dspArr = GetDataCheckedDsp();
        if (dspArr.length === 0) {
            PHA.Popover({
                msg: '���ȹ�ѡ��Ҫ��ҩ����',
                type: 'info'
            });
            return;
        }
        var valCondition = ValidateCondition();
        if (valCondition !== true) {
            PHA.Popover({
                msg: valCondition,
                type: 'info'
            });
            return;
        }
        var logonUser = session['LOGON.USERID'];
        var pJson = {
            loc: session['LOGON.CTLOCID'],
            logonUser: logonUser,
            dispWay: 'EMDISP',
            dspArr: dspArr
        };

        $.messager.progress('close');
        $.messager.progress({
            title: '��ܰ��ʾ',
            text: '����ҩ��......'
        });
        PHA.CM(
            {
                pClassName: 'PHA.IP.Disp.Api',
                pMethodName: 'HandleDisp4EM',
                pJson: JSON.stringify(pJson)
            },
            function (retData) {
                $.messager.progress('close');
                AfterDispHandler(retData);
            },
            function (retData) {
                $.messager.progress('close');
                PHA.Alert('��ʾ', 'ϵͳ����', 'warning');
            }
        );
    }
    function AfterDispHandler(resultData) {
        $('#btnFind').click();
        var phacIDArr = [];
        try {
            var msgStr = resultData.msg || '';
            if (resultData.data !== '') {
                phacIDArr = resultData.data.split(',');
                if (phacIDArr.length > 0) {
                    // ���
                    //ExecuteReserve(phacIDArr);
                    // ��ӡ
                    if (PHA_IP_EMDISP.HandleVars.NeedPrint === true) {
                        PrintReport(phacIDArr);
                    }
                    // ��ҩ��
                    //Send2Machine(phacIDArr);
                }
            }
        } catch (e) {}
        // ����쳣��ʾ
        if (msgStr !== '') {
            PHA.Alert('��ʾ', msgStr, 'warning');
        } else {
            if (phacIDArr.length === 0) {
                PHA.Alert('��ʾ', 'δ����ҩƷ', 'warning');
            }
        }
    }
    function PrintReport(phacIDArr) {
        var printType = '';
        if (PHA_IP_EMDISP.HandleVars.PrintTotal === true) {
            printType = 2;
        }
        if (PHA_IP_EMDISP.HandleVars.PrintDetail === true) {
            printType = 1;
        }
        if (PHA_IP_EMDISP.HandleVars.PrintTotal === true && PHA_IP_EMDISP.HandleVars.PrintDetail === true) {
            printType = 3;
        }
        IPPRINTCOM.Print({
            phacStr: phacIDArr.join('^'),
            otherStr: '',
            printType: printType,
            reprintFlag: 'N',
            pid: '',
            banConfig: 1
        });
    }
    function HandleClean() {
        PHA_COM.Condition('.qCondition', 'clear');
        $('#gridAdm').datagrid('clear');
        $('#gridOrder').datagrid('clear');
        $('#gridInci').datagrid('clear');
        PHA.SetVals(PHA_IP_EMDISP.DefaultData);
    }
    setTimeout(function () {
        $('#btnFind').click();
    }, 1000);
});