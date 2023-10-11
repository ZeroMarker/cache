/**
 * ����:  סԺҩ�� - ���뵥��ҩ(����ͨ��)
 * ��д��:   yunhaibao
 * ��д����: 2022-09-14
 */
// PHA_SYS_SET = undefined;
PHA_COM.Val.CAModelCode = 'PHAIPReturn';
$(function () {
    var settings = PHA.CM(
        {
            pClassName: 'PHA.IP.Return.Api',
            pMethodName: 'GetSettings',
            pJson: JSON.stringify({
                logonLoc: session['LOGON.CTLOCID'],
                logonUser: session['LOGON.USERID'],
                logonGroup: session['LOGON.GROUPID'],
                macAddr: PHAIP_COM.GetMac()
            })
        },
        false
    );
    PHA_COM.App.Csp = 'pha.ip.v4.returnbyreq.csp';

    var PHA_IP_RETURNBYREQ = {
        WardFlag: session['LOGON.WARDID'] || '' != '' ? 'Y' : 'N',
        DefaultData: [
            {
                startDate: settings.defaultData.startDate, // Ĭ��ǰ��һ��, ����©
                endDate: 't',
                loc: session['LOGON.CTLOCID'],
                patNo: ''
            }
        ],
        ReqRows: [],
        HandleVars: {
            ReturnReason: '',
            RefuseReason: '',
            RetIDStr: ''
        },
        Config: settings.config
    };
    InitDict();
    InitGridLoc();
    InitGridReq();
    InitGridInci();
    InitGridReqItm();
    InitRefuseReason();
    InitSelectPrintWay();
    PHA_EVENT.Bind('#btnFind', 'click', Query);
    PHA_EVENT.Bind('#btnReturn', 'click', function () {
        PHAIP_COM.CACert('PHAIPReturn', HandleReturn);
    });
    PHA_EVENT.Bind('#btnRefuse', 'click', HandleRefuse);
    PHA_EVENT.Bind('#btnRefuseCancel', 'click', HandleRefuseCancel);
    PHA_EVENT.Bind('#btnClean', 'click', HandleClean);
    PHA.SetVals(PHA_IP_RETURNBYREQ.DefaultData);
    $('#tabsDetail').tabs({
        onSelect: function () {
            var tabCode = $('#tabsDetail').tabs('getSelected').panel('options').code;
            if (tabCode === 'inci') {
                QueryInci();
            }
        }
    });
    $('#tabsTotal').tabs({
        onSelect: function () {
            LoadReq(PHA_IP_RETURNBYREQ.ReqRows);
        }
    });

    function InitDict() {
        PHA.ComboBox('loc', {
            url: PHA_STORE.Pharmacy('IP').url + '&OnlyLogon=1',
            panelHeight: 'auto',
            onLoadSuccess: function (data) {
                $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
            }
        });
        PHA.ComboBox('takeLoc', {
            url: PHA_STORE.CTLoc().url
        });
        var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
            // width: 230
            panelWidth: 500,
            fitColumns: true
        });
        PHA.LookUp('inci', opts);
        $('#patNo').on('keypress', function (event) {
            if (window.event.keyCode == '13') {
                $(this).val(PHA_COM.FullPatNo($(this).val()));
                $('#btnFind').click();
                setTimeout(function () {
                    $('#patNo').focus().select();
                }, 500);
            }
        });
    }
    function InitGridLoc() {
        var columns = [
            [
                {
                    field: 'reqLocID',
                    title: 'reqLocID',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'reqLocDesc',
                    title: '�������',
                    width: 100,
                    sortable: false
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            exportXls: false,
            columns: columns,
            toolbar: [], // searchbox
            pageNumber: 1,
            pageSize: 999999,
            pageList: [999999],
            pagination: false,
            singleSelect: true,
            rownumbers: false,
            fitColumns: true,
            loadFilter: PHAIP_COM.LocalFilter,
            onLoadSuccess: function () {
                $(this).datagrid('loaded');
                LoadReq([]);
            },
            onSelect: function () {
                LoadReq(PHA_IP_RETURNBYREQ.ReqRows);
            }
        };
        PHA.Grid('gridLoc', dataGridOption);
    }
    function InitGridReq() {
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
                    field: 'reqID',
                    title: 'reqID',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'no',
                    title: '����',
                    width: 140,
                    formatter: function (value) {
                        return '<div style="direction: rtl;overflow:hidden;">' + value + '</div>';
                    }
                },
                {
                    field: 'reqLocDesc',
                    title: '�������',
                    width: 100,
                    sortable: true,
                    hidden: true
                },

                {
                    field: 'reqDate',
                    title: '��������',
                    width: 95,
                    align: 'center',
                    sortable: false
                },
                {
                    field: 'reqTime',
                    title: '����ʱ��',
                    width: 75,
                    align: 'center',
                    sortable: false
                },
                {
                    field: 'reqUserName',
                    title: '������',
                    width: 100,
                    sortable: true
                },
                {
                    field: 'bedNo',
                    title: '����'
                },
                {
                    field: 'patNo',
                    title: '�ǼǺ�',
                    width: 100
                },
                {
                    field: 'patName',
                    title: '����'
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            exportXls: false,
            frozenColumns: frozenColumns,
            columns: columns,
            toolbar: [],
            pageNumber: 1,
            pageSize: 999999,
            pageList: [999999],
            pagination: false,
            autoSizeColumn: true,
            singleSelect: false,
            selectOnCheck: true,
            checkOnSelect: true,
            queryOnSelect: false,
            loadBeforeClearSelect: true,
            loadFilter: PHAIP_COM.LocalFilter,
            onLoadSuccess: function () {
                $(this).datagrid('loaded');
                $(this).datagrid('clearChecked');
                RefreshGridTabTitle(this.id);
                $('#tabsDetail').tabs('select', 0);
            },
            onCheck: function () {
                QueryItm();
            },
            onUncheck: function () {
                QueryItm();
            },
            onCheckAll: function () {
                QueryItm();
            },
            onUncheckAll: function () {
                QueryItm();
            }
        };
        PHA.Grid('gridReq', dataGridOption);
        PHA.Grid('gridRefund', dataGridOption);
        PHA.Grid('gridRefuse', dataGridOption);
    }
    function InitGridInci() {
        var columns = [
            [
                {
                    field: 'inci',
                    title: 'inci',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'formDesc',
                    title: '����',
                    width: 100
                },
                {
                    field: 'inciCode',
                    title: '����'
                },
                {
                    field: 'inciDesc',
                    title: '����',
                    width: 300,
                    sortable: true
                },

                {
                    field: 'qty',
                    title: '��ҩ����',
                    width: 100,
                    align: 'right',
                    styler: function () {
                        return 'font-weight:bold;';
                    }
                },
                {
                    field: 'uomDesc',
                    title: '��λ',
                    width: 100
                },
                {
                    field: 'reqQty',
                    title: '��������',
                    width: 100,
                    align: 'right'
                },
                {
                    field: 'spAmt',
                    title: '���',
                    width: 100,
                    align: 'right'
                },
                {
                    field: 'manfDesc',
                    title: '������ҵ',
                    width: 200
                }
            ]
        ];
        var dataGridOption = {
            url: '',
            exportXls: false,
            columns: columns,
            fitColumns: false,
            showFooter: true,
            toolbar: '#gridInciBar',
            pageList: [999999],
            pageSize: 999999,
            pageNumber: 1,
            pagination: false,
            rownumbers: true,
            loadFilter: PHAIP_COM.LoadFilter,
            onLoadSuccess: function (data) {
                $(this).datagrid('loaded');
                if (data.rows.length > 0) {
                    $('#gridInciBar div').hide();
                } else {
                    $('#gridInciBar div').show();
                }
                //$($('.js-pha-ip-hide-pagination .pagination table')[0]).hide()
            },
            onSelect: function () {}
        };
        PHA.Grid('gridInci', dataGridOption);
    }

    function InitGridReqItm() {
        var frozenColumns = [[]];
        var columns = [
            [
                {
                    checkbox: true,
                    field: 'gCheck'
                },
                {
                    field: 'reqItmID',
                    title: '������ϸID',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'warnInfo',
                    title: '��ܰ��ʾ',
                    width: 100,
                    showTip: true,
                    tipPosition: 'left',
                    styler: function (value) {
                        if (value !== '') {
                            return { class: 'phaip-datagrid-warn-normal' };
                        }
                    }
                },
                {
                    field: 'reasonDesc',
                    title: '����ԭ��',
                    width: 100
                },
                {
                    field: 'doseDateTime',
                    title: '��ҩʱ��',
                    width: 95,
                    formatter: function (rowIndex, rowData) {
                        return rowData.doseDate + ' ' + rowData.doseTime;
                    }
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
                    title: '����',
                    width: 200,
                    sortable: true
                },
                {
                    field: 'qty',
                    title: '��ҩ����',
                    width: 75,
                    align: 'right',
                    editor: PHA_GridEditor.NumberBox(
                        $.extend({}, $.fn.numberbox.defaults.phaOptions, {
                            required: false,
                            min: 0,
                            minPrecision: 0,
                            onBeforeNext: function (data, rowData, rowIndex) {
                                debugger;
                            },
                            checkValue: function (val, checkRet) {
                                var msg = '���������0������';
                                if (_.isLikeNumber(val) === false) {
                                    checkRet.msg = msg;
                                    return false;
                                }
                                if (parseFloat(val) <= 0) {
                                    checkRet.msg = msg;
                                    return false;
                                }
                                return true;
                            }
                        })
                    ),
                    styler: function () {
                        return 'font-weight:bold;';
                    }
                },
                {
                    field: 'uomDesc',
                    title: '��λ'
                },

                {
                    field: 'reqQty',
                    title: '��������',
                    width: 75,
                    align: 'right'
                },
                {
                    field: 'canRetQty',
                    title: '��������',
                    width: 75,
                    align: 'right'
                },

                {
                    field: 'refuseInfo',
                    title: '�ܾ���ҩ��Ϣ'
                },
                {
                    field: 'requestInfo',
                    title: '������ҩ��Ϣ'
                },
                {
                    field: 'mOeore',
                    title: 'ִ�м�¼ID'
                },
                {
                    field: 'insuCode',
                    title: '����ҽ������'
                },
                {
                    field: 'insuDesc',
                    title: '����ҽ������'
                }
            ]
        ];
        var dataGridOption = {
            exportXls: false,
            url: '',
            frozenColumns: frozenColumns,
            columns: columns,
            fitColumns: false,
            autoSizeColumn: true,
            pageNumber: 1,
            toolbar: [],
            pageList: [999999],
            pageSize: 999999,
            pageNumber: 1,
            pagination: false,
            singleSelect: false,
            linkField: 'mOeore',
            loadFilter: PHAIP_COM.LocalFilter,
            view: groupview,
            groupField: 'reqID',
            groupFormatter: function (value, rows) {
                var rowData = rows[0];
                var divArr = [];
                divArr.push('<div class="pha-ip-return-order-group">');
                divArr.push('   <div style="width:100px;" class="pha-tips-group">��');
                divArr.push('   </div>');
                divArr.push('   <div style="max-width:1000px;">' + rowData.no + '</div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div style="min-width:50px;">' + rowData.bedNo + '</div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div>' + rowData.patNo + '</div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div style="min-width:100px;">' + rowData.patName + '</div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div style="min-width:20px;">' + rowData.sex + '</div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div style="min-width:20px;">' + rowData.age + '</div>');
                divArr.push('</div>');
                return divArr.join('');
            },
            onBeforeSelect: function (rowIndex, rowData) {
                // var cantReturnInfo = rowData.cantReturnInfo || '';
                // if (cantReturnInfo !== '') {
                //     return false;
                // }
            },
            onBeforeCheck: function (rowIndex, rowData) {
                // var cantReturnInfo = rowData.cantReturnInfo || '';
                // if (cantReturnInfo !== '') {
                //     return false;
                // }
            },
            onCheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                PHAIP_COM.DataGridLinkCheck($(this), 'checkRow', rowIndex, rowData, function (i, data) {});
            },
            onUncheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                PHAIP_COM.DataGridLinkCheck($(this), 'uncheckRow', rowIndex, rowData, function (i, data) {});
                $(this).datagrid('options').checking = '';
            },
            onAfterEdit: function (rowIndex, rowData, changes) {
                var qty = rowData.qty;
                var canRetQty = rowData.canRetQty;
                if (qty !== '' && canRetQty !== '') {
                    if (qty * 1 > canRetQty * 1) {
                        PHA.Popover({
                            msg: '��' + (rowIndex + 1) + '��,��ҩ��������ʣ���������',
                            type: 'alert'
                        });
                    }
                }
            },
            onClickCell: function (index, field, value) {
                if (field !== 'qty') {
                    return;
                }
                var tabCode = $('#tabsTotal').tabs('getSelected').panel('options').code;
                if (tabCode !== 'normal') {
                    return;
                }
                var rowData = $(this).datagrid('getRows')[index];

                if (rowData.cantEditInfo !== '') {
                    PHA.Popover({
                        msg: rowData.cantReturnInfo,
                        type: 'info'
                    });
                    return;
                }
                if (rowData.cantReturnInfo !== '') {
                    PHA.Popover({
                        msg: rowData.cantReturnInfo,
                        type: 'info'
                    });
                    return;
                }
                $('#gridReqItm').datagrid('uncheckRow', index);
                PHA_GridEditor.Edit({
                    gridID: 'gridReqItm',
                    index: index,
                    field: field,
                    forceEnd: true
                });
            },
            onCheckAll: function (rows) {
                // UnBindChk();
            },
            onUncheckAll: function (rows) {
                // UnBindChk();
            },
            onLoadSuccess: function (data) {
                $(this).datagrid('loaded');
                $(this).datagrid('clearChecked');
                if (PHA_IP_RETURNBYREQ.Config.checkAllRetReqItm === 'Y') {
                    if (data.rows.length > 0) {
                        $(this).datagrid('checkAll');
                    }
                }
                //$($('.js-pha-ip-hide-pagination .pagination table')[0]).hide()
                // UnBindChk();
            },
            layout: []
        };
        PHA.Grid('gridReqItm', dataGridOption);
        /**
         * ���ô˷�ʽ����, ��Ϊ�ܾ�Ӧ������ѡ��
         */
        function UnBindChk() {
            var rows = $('#gridReqItm').datagrid('getRows');
            $.each(rows, function (index, row) {
                var cantReturnInfo = row.cantReturnInfo;
                if (cantReturnInfo !== '') {
                    //$(".datagrid-row[datagrid-row-index=" + index + "] .datagrid-cell-check")
                    // ͨ���Ƴ���ʽ,ʹselectoncheck���¼���������
                    var $row = $('#gridReqItm')
                        .prev()
                        .find('.datagrid-row[datagrid-row-index=' + index + ']');
                    $row.removeClass('datagrid-row-selected datagrid-row-checked');
                    // datagrid-row datagrid-row-selected datagrid-row-checked
                    var $chk = $row.find("input:checkbox[name='gCheck']")[0];
                    $chk.disabled = true;
                    $chk.checked = false;
                    // $chk.remove()
                    // $chk.style = 'display:none';
                }
            });
        }
    }
    function InitRefuseReason() {
        PHA.Grid('gridRefuseReason', {
            toolbar: null,
            headerCls: 'panel-header-gray',
            bodyCls: 'panel-body-gray',
            border: true,
            url: $URL,
            queryParams: {
                ClassName: 'PHA.IP.COM.Store',
                QueryName: 'ReturnRefuseReason',
                pHosp: session['LOGON.HOSPID']
            },
            pagination: false,
            fitColumns: true,
            rownumbers: true,
            columns: [
                [
                    {
                        field: 'RowId',
                        title: 'RowId',
                        width: 100,
                        hidden: true
                    },
                    {
                        field: 'Description',
                        title: 'ԭ��',
                        width: 1000
                    }
                ]
            ],
            onDblClickRow: function () {
                $('#winRefuseReason-ok').click();
            }
        });
        $('#winRefuseReason').dialog({
            title: '�ܾ���ҩԭ�򣨿���˫��ȷ����',
            collapsible: false,
            iconCls: 'icon-w-list',
            maximizable: false,
            minimizable: false,
            border: false,
            closable: true,
            closed: true,
            modal: true,
            width: 500,
            height: 500,
            buttons: [
                {
                    id: 'winRefuseReason-ok',
                    text: 'ȷ��',
                    handler: function () {
                        var selData = $('#gridRefuseReason').datagrid('getSelected');
                        if (selData === null) {
                            PHA.Popover({ type: 'info', msg: '����ѡ��ԭ��' });
                            return;
                        }
                        PHA_IP_RETURNBYREQ.HandleVars.RefuseReason = selData.RowId;
                        $('#winRefuseReason').window('close');
                        $('#gridRefuseReason').datagrid('reload');
                        ExecuteRefuse();
                    }
                },
                {
                    text: 'ȡ��',
                    handler: function () {
                        $('#winRefuseReason').window('close');
                        $('#gridRefuseReason').datagrid('reload');
                    }
                }
            ]
        });
    }
    function InitSelectPrintWay() {
        $('#kwPrintWay').keywords({
            singleSelect: true,
            items: [
                { text: $g('Ĭ�ϴ�ӡ'), id: 'default', selected: true },
                { text: $g('��ӡҩƷ����'), id: 'total' },
                { text: $g('��ӡ����ҩƷ����'), id: 'detail' }
            ],
            onSelect: function (rowData) {
                if (rowData.id === 'default') {
                    PHAIP_COM.UnSelectKeyWords('#kwPrintWay', ['total', 'detail']);
                } else {
                    PHAIP_COM.UnSelectKeyWords('#kwPrintWay', ['default']);
                }
            }
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
                        $('#winSelectPrintWay').dialog('close');
                        PrintReturnCom(PHA_IP_RETURNBYREQ.HandleVars.RetIDStr, '', $('#kwPrintWay').keywords('getSelected')[0].id);
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
        $('#gridReq').datagrid('clearChecked');
        var pJson = PHA_COM.Condition('.qCondition', 'get');
        if (!pJson) {
            return;
        }
        pJson.loc = session['LOGON.CTLOCID'];
        PHA.Loading('Show');
        PHA.CM(
            {
                pPlug: 'datagrid',
                rows: 9999999,
                page: 1,
                sort: '',
                order: '',
                pClassName: 'PHA.IP.ReturnByReq.Api',
                pMethodName: 'GetRequestRows',
                pJson: JSON.stringify(pJson)
            },
            function (retData) {
                PHA.Loading('Hide');
                if (retData.success === 0) {
                    PHA.Alert('', retData.msg, 'error');
                }
                PHA_IP_RETURNBYREQ.ReqRows = retData.rows;
                LoadGridLoc(PHA_IP_RETURNBYREQ.ReqRows);
            },
            function (failData) {
                PHA.Loading('Hide');
                if (callback) {
                    callback(retData);
                }
            }
        );
    }
    function LoadGridLoc(rows) {
        var locRows = [];
        var uniqueArr = [];
        for (var i = 0, length = rows.length; i < length; i++) {
            var rowData = rows[i];
            if (uniqueArr.indexOf(rowData.reqLocDesc) < 0) {
                locRows.push({
                    reqLocID: rowData.reqLocID,
                    reqLocDesc: rowData.reqLocDesc
                });
                uniqueArr.push(rowData.reqLocDesc);
            }
        }
        $('#gridLoc').datagrid('loadData', { total: locRows.length, rows: locRows });
    }
    function LoadReq(rows) {
        if (typeof rows !== 'object') {
            PHA.Alert('ϵͳ����', '�޷���������, �볢��ˢ��ҳ��', 'error');
            return;
        }
        var locSelected = $('#gridLoc').datagrid('getSelected') || {};
        var reqLocID = locSelected.reqLocID || '';
        $('#gridReq').datagrid('loading');
        $('#gridRefund').datagrid('loading');
        $('#gridRefuse').datagrid('loading');
        $('#gridReq').datagrid(
            'loadData',
            DataRowsFilter(rows, function (rowData) {
                if (reqLocID === '' || rowData.reqLocID !== reqLocID) {
                    return false;
                }
                console.log(rowData.reqLocDesc + ':' + rowData.showTabs);
                if (rowData.showTabs.indexOf('|normal|') >= 0) {
                    return true;
                }
                return false;
            })
        );

        $('#gridRefund').datagrid(
            'loadData',
            DataRowsFilter(rows, function (rowData) {
                if (reqLocID === '' || rowData.reqLocID !== reqLocID) {
                    return false;
                }
                if (rowData.showTabs.indexOf('|refund|') >= 0) {
                    return true;
                }
                return false;
            })
        );
        $('#gridRefuse').datagrid(
            'loadData',
            DataRowsFilter(rows, function (rowData) {
                if (reqLocID === '' || rowData.reqLocID !== reqLocID) {
                    return false;
                }
                if (rowData.showTabs.indexOf('|refuse|') >= 0) {
                    return true;
                }
                return false;
            })
        );
    }
    function QueryItm() {
        var pJson = PHA_COM.Condition('.qCondition', 'get');
        if (!pJson) {
            return;
        }
        pJson.loc = session['LOGON.CTLOCID'];
        var qGrid = $('#tabsTotal').tabs('getSelected').panel('options').grid;
        var reqArr = [];
        var checkedRows = $('#' + qGrid).datagrid('getChecked');
        for (var i = 0, length = checkedRows.length; i < length; i++) {
            reqArr.push({
                reqID: checkedRows[i].reqID
            });
        }
        pJson.reqRows = reqArr;
        pJson.showType = $('#tabsTotal').tabs('getSelected').panel('options').code;
        PHA_COM.LoadData(
            'gridReqItm',
            {
                pClassName: 'PHA.IP.ReturnByReq.Api',
                pMethodName: 'GetRequestItmRows',
                pJson: JSON.stringify(pJson)
            },
            function (retData) {}
        );
    }
    function QueryInci() {
        var reqItmArr = [];
        var checkedRows = $('#gridReqItm').datagrid('getChecked');
        for (var i = 0, length = checkedRows.length; i < length; i++) {
            var rowData = checkedRows[i];
            //            �����Ƿ���ʾ������ҩ������, ����ʵ��
            //            if (rowData.cantReturnInfo !== '') {
            //                continue;
            //            }
            reqItmArr.push({
                reqItmID: rowData.reqItmID,
                qty: rowData.qty
            });
        }
        var pJson = {
            reqItmRows: reqItmArr
        };
        PHA_COM.LoadData(
            'gridInci',
            {
                pClassName: 'PHA.IP.ReturnByReq.Api',
                pMethodName: 'GetRequestInciRows',
                pJson: JSON.stringify(pJson)
            },
            function (retData) {
                PHA_COM.SumGridFooter('#gridInci', ['spAmt']);
            }
        );
    }

    /**
     * ��ҩ
     */
    function HandleReturn() {
        if (!PHA_GridEditor.End('gridReqItm')) {
            return;
        }
        var returnData = GetDataReturn();
        if (returnData.rows.length === 0) {
            PHA.Popover({ type: 'info', msg: '���ȹ�ѡ������ҩ�����ļ�¼' });
            return;
        }
        PHA.Confirm('��ʾ', '��ȷ�ϡ���ҩ����?', function () {
            PHA.Loading('Show');
            returnData.user = session['LOGON.USERID'];
            PHA.CM(
                {
                    pClassName: 'PHA.IP.ReturnByReq.Api',
                    pMethodName: 'HandleReturn',
                    dataJson: JSON.stringify(returnData)
                },
                function (retJson) {
                    PHA.Loading('Hide');
                    if (retJson.msg !== '') {
                        PHA.Alert('��ʾ', retJson.msg, 'warning');
                        return;
                    }
                    PHA_IP_RETURNBYREQ.HandleVars.RetIDStr = retJson.data;
                    PHA_COM.SaveCACert({
                        signVal: retJson.data,
                        type: 'Y'
                    });
                    $('#winSelectPrintWay').window('open');
                    // if (PHA_IP_RETURNBYREQ.Config.needSelectPrintWay === 'Y') {
                    // } else {

                    //     PrintReturnCom(PHA_IP_RETURNBYREQ.HandleVars.RetIDStr, '');
                    // }
                    $('#btnFind').trigger('click-i');
                },
                function (retData) {
                    PHA.Loading('Hide');
                    PHA.Alert('��ʾ', '�����쳣' + retData, 'error');
                }
            );
        });
    }

    function GetDataReturn() {
        var retArr = [];
        var checkRows = $('#gridReqItm').datagrid('getChecked');
        for (var i = 0, length = checkRows.length; i < length; i++) {
            var rowData = checkRows[i];
            if (rowData.cantReturnInfo !== '') {
                continue;
            }
            retArr.push({
                reqItmID: rowData.reqItmID,
                qty: rowData.qty
            });
        }
        return {
            main: {
                user: session['LOGON.USERID'],
                loc: session['LOGON.CTLOCID']
            },
            rows: retArr
        };
    }
    /**
     * �ܾ���ҩ
     */
    function HandleRefuse() {
        var refuseData = GetData4Refuse();
        if (refuseData.rows.length === 0) {
            PHA.Popover({
                msg: '���ȹ�ѡ���Ͼܾ���ҩ�����ļ�¼',
                type: 'info'
            });
            return;
        }
        $('#winRefuseReason').dialog('open');
    }
    function ExecuteRefuse() {
        PHA.Loading('Show');
        var refuseData = GetData4Refuse();
        refuseData.user = session['LOGON.USERID'];
        refuseData.reason = PHA_IP_RETURNBYREQ.HandleVars.RefuseReason;
        PHA.CM(
            {
                pClassName: 'PHA.IP.ReturnByReq.Api',
                pMethodName: 'HandleRefuse',
                pJson: JSON.stringify(refuseData)
            },
            function (retJson) {
                PHA.Loading('Hide');
                if (retJson.msg !== '') {
                    PHA.Alert('��ʾ', retJson.msg, 'warning');
                    return;
                }
                $('#btnFind').trigger('click-i');
            },
            function (retData) {
                PHA.Loading('Hide');
                PHA.Alert('��ʾ', '�����쳣' + retData, 'error');
            }
        );
    }
    function GetData4Refuse() {
        var retArr = [];
        var checkRows = $('#gridReqItm').datagrid('getChecked');
        for (var i = 0, length = checkRows.length; i < length; i++) {
            var rowData = checkRows[i];
            if (rowData.refuseInfo !== '') {
                continue;
            }
            retArr.push({
                reqItmID: rowData.reqItmID
            });
        }
        return {
            rows: retArr
        };
    }

    /**
     * ȡ���ܾ���ҩ
     */
    function HandleRefuseCancel() {
        var refuseData = GetData4RefuseCancel();
        if (refuseData.rows.length === 0) {
            PHA.Popover({
                msg: '���ȹ�ѡ�Ѿ��ܾ��ļ�¼',
                type: 'info'
            });
            return;
        }
        PHA.Confirm('��ʾ', '��ȷ�ϡ�ȡ���ܾ���ҩ����?', function () {
            PHA.Loading('Show');
            var refuseData = GetData4RefuseCancel();
            refuseData.user = session['LOGON.USERID'];
            refuseData.reason = '';
            PHA.CM(
                {
                    pClassName: 'PHA.IP.ReturnByReq.Api',
                    pMethodName: 'HandleRefuseCancel',
                    pJson: JSON.stringify(refuseData)
                },
                function (retJson) {
                    PHA.Loading('Hide');
                    if (retJson.msg !== '') {
                        PHA.Alert('��ʾ', msg, 'warning');
                        return;
                    }
                    $('#btnFind').trigger('click-i');
                },
                function (retData) {
                    PHA.Loading('Hide');
                    PHA.Alert('��ʾ', '�����쳣' + retData, 'error');
                }
            );
        });
    }

    function GetData4RefuseCancel() {
        var retArr = [];
        var checkRows = $('#gridReqItm').datagrid('getChecked');
        for (var i = 0, length = checkRows.length; i < length; i++) {
            var rowData = checkRows[i];
            if (rowData.refuseInfo === '') {
                continue;
            }
            retArr.push({
                reqItmID: rowData.reqItmID
            });
        }
        return {
            rows: retArr
        };
    }
    function DataRowsFilter(data, filterFunc) {
        var retDataRows = [];
        var rows = data;
        for (var i = 0, length = rows.length; i < length; i++) {
            var row = rows[i];
            if (filterFunc(row) == false) {
                continue;
            }
            retDataRows.push(row);
        }
        return {
            total: retDataRows.length,
            rows: retDataRows
        };
    }
    function RefreshGridTabTitle(gridID) {
        var tabIndex = '';
        var tabs = $('#tabsTotal').tabs('tabs');
        for (var i = 0, length = tabs.length; i < length; i++) {
            var tab = tabs[i];
            if (tab.panel('options').grid === gridID) {
                tabIndex = i;
                break;
            }
        }
        var cnt = $('#' + gridID).datagrid('getRows').length;
        var tabTitle = $('#tabsTotal').tabs('getTab', tabIndex).panel('options').title;
        tabTitle = tabTitle.split('<')[0];
        if (cnt > 0) {
            // ���Ϊƴ������, tabs �в��ᷭ��
            tabTitle = $g(tabTitle) + '<span style=""> ( ' + cnt + ' )</span>';
        }
        $('#tabsTotal').tabs('update', {
            tab: $('#tabsTotal').tabs('getTab', tabIndex),
            options: {
                title: tabTitle
            }
        });
    }
    function HandleClean() {
        PHA_COM.Condition('.qCondition', 'clear');
        PHA.SetVals(PHA_IP_RETURNBYREQ.DefaultData);

        $('#gridLoc').datagrid('clear');
        $('#gridReq').datagrid('clear');
        $('#gridRefuse').datagrid('clear');
        $('#gridRefund').datagrid('clear');
        $('#gridReqItm').datagrid('clear');
        $('#gridInci').datagrid('clear');
    }
    setTimeout(function () {
        $('#btnFind').click();
        $('#btnMoreCondition').popover({
            trigger: 'click',
            placement: 'bottom',
            content: 'content',
            dismissible: false,
            width: $($('.js-pha-moreorless .pha-con-table')[0]).outerWidth(),
            padding: false,
            url: '.js-pha-moreorless'
        });
    }, 500);
});
