/**
 * ����:	 סԺҩ�� - ��ҩ����ѯ
 * ��д��:	 yunhaibao
 * ��д����: 2020-11-19
 */
var PHA_IP_QUERY_DISP = {
    WardFlag: session['LOGON.WARDID'] || '' !== '' ? 'Y' : 'N'
};
$(function () {
    $('#conPatNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $(this).val(PHA_COM.FullPatNo($(this).val()));
            $('#btnFind').trigger('click');
            $('#conPatNo').focus().select();
        }
    });
    $('#conDispNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $('#btnFind').trigger('click');
            $('#conDispNo').focus().select();
        }
    });
    InitDict();
    InitGridPhac();
    InitGridInci();
    InitGridDetail();

    $('#btnPrint').on('click', PrintOpen);
    $('#btnFind').on('click', QueryHandler);
    $('#btnClean').on('click', CleanHandler);
    $('#btn-SendMachine').on('click', sendMachine);

    PHA_EVENT.Key([
        [CleanHandler, 'alt+c'],
        ['btnFind', 'alt+f'],
        ['btnFind', 'ctrl+enter']
    ]);
    setTimeout(function () {
        PHAIP_COM.ToggleMore('moreorless', '.js-pha-moreorless', { width: $($('.js-pha-moreorless .pha-con-table')[0]).outerWidth() });
        PHA_COM.ResizePanel({
            layoutId: 'lyBody',
            region: 'south',
            height: 0.5
        });
    }, 0);
});

function InitDict() {
    var combWidth = 160;
    $('#conStartDate').datebox('setValue', PHA_UTIL.GetDate('t'));
    $('#conEndDate').datebox('setValue', PHA_UTIL.GetDate('t'));

    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('IP').url,
        panelHeight: 'auto',
        loaded: false,
        onLoadSuccess: function (data) {
            if ($(this).combobox('options').loaded === false) {
                $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
            }
            $(this).combobox('options').loaded = true;
            InitSendMachine();
        },
        onSelect: function (data) {
            PHA.ComboBox('conDispCat', {
                url: PHAIP_STORE.StkDrugGroup().url + '&loc=' + data.RowId,
                panelHeight: 'auto',
                width: combWidth,
                multiple: true
            });
            PHA.ComboBox('conWardLoc', {
                url: PHA_STORE.WardLocByRecLoc().url + '&RecLocId=' + data.RowId, //�������������������ѡ�д������� ,�޸�Ϊ�����տ���ȡ���� By zhaoxinlong 2022.04.24
                width: combWidth,
                recordLog: {
                    csp: PAGE_CSP,
                    label: '����'
                }
            });
            InitSendMachine();
        }
    });

    PHA.ComboBox('conDispCat', {
        url: PHAIP_STORE.StkDrugGroup().url + '&loc=' + session['LOGON.CTLOCID'],
        panelHeight: 'auto',
        width: combWidth,
        multiple: true
    });

    PHA.ComboBox('conWay', {
        data: [
            { RowId: 'WARD', Description: $g('������ҩ') },
            { RowId: 'DOCLOC', Description: $g('ҽ�����ҷ�ҩ') }
        ],
        panelHeight: 'auto',
        width: combWidth,
        onSelect: function () {
            // QueryHandler();
        }
    });

    PHA.ComboBox('conWardLoc', {
        url: PHA_STORE.WardLocByRecLoc().url + '&RecLocId=' + session['LOGON.CTLOCID'], //�������������������ѡ�д������� ,�޸�Ϊ�����տ���ȡ���� By zhaoxinlong 2022.04.24
        width: combWidth,
        recordLog: {
            csp: PAGE_CSP,
            label: '����'
        },
        onLoadSuccess: function () {
            if (PHA_IP_QUERY_DISP.WardFlag === 'Y') {
                $(this).combobox('setValue', session['LOGON.CTLOCID']).combobox('disable');
            }
        }
    });
    /// ����ۼ�ѡ���¼� - ԭʼģʽ
    $('#conWardLoc').combobox({
        onSelect: function (data) {
            var WardLoc = data.RowId;
            var WardLocDesc = data.Description;
            var ret = tkMakeServerCall('PHA.SYS.SelectRecordLog.Save', 'Save', PAGE_CSP, 'conWardLoc', '����', WardLoc, WardLocDesc);
            var newUrl = PHA_STORE.WardLoc(PAGE_CSP, 'conWardLoc').url;
            $('#conWardLoc').combobox('reload', newUrl);
        }
    });
    PHA.ComboBox('conDocLoc', {
        recordLog: {
            csp: PAGE_CSP,
            label: 'ҽ������'
        },
        url: PHA_STORE.DocLoc().url,
        width: combWidth
    });

    PHA.ComboBox('conPoison', {
        url: PHA_STORE.PHCPoison().url,
        width: combWidth,
        multiple: true
    });

    var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
        width: combWidth
    });
    PHA.LookUp('conInci', opts);

    $('#kwPrintWay').keywords({
        singleSelect: false,
        items: [
            { text: 'Ĭ�ϴ�ӡ', id: 'default' },
            { text: '��ӡ����', id: 'total' },
            { text: '��ӡ��ϸ', id: 'detail' },
            { text: '��ӡ�����ϸ', id: 'resdetail' },
            { text: '��ӡ�ڷ�ҩ��ǩ', id: 'kflabel' }
        ],
        onSelect: function (rowData) {
            if (rowData.id === 'default') {
                PHAIP_COM.UnSelectKeyWords('#kwPrintWay', ['total', 'detail', 'resdetail', 'kflabel']);
            } else {
                PHAIP_COM.UnSelectKeyWords('#kwPrintWay', ['default']);
            }
        }
    });
    $('#winPrt').dialog({
        title: '��ӡ��ʽ',
        collapsible: false,
        iconCls: 'icon-w-print',
        maximizable: false,
        minimizable: false,
        border: false,
        closable: false,
        closed: true,
        modal: true,
        onOpen: function () {
            $('#winPrt')
                .window('resize', {
                    width: $('#winPrt .pha-con-table').width() + 10,
                    height: 'auto'
                })
                .window('center');
            if ($('#kwPrintWay').keywords('getSelected').length === 0) {
                $('#kwPrintWay').keywords('select', 'default');
            }
        },
        buttons: [
            {
                text: 'ȷ��',
                handler: function () {
                    PrintHandler();
                }
            },
            {
                text: 'ȡ��',
                handler: function () {
                    $('#winPrt').dialog('close');
                }
            }
        ]
    });
}
function InitGridPhac() {
    var columns = [
        [
            {
                field: 'phac',
                title: '��ҩ����ID',
                width: 100,
                hidden: true
            },
            {
                field: 'itmChk',
                checkbox: true
            },

            {
                field: 'dispNo',
                title: '����',
                width: 250,
                sortable: true,
                formatter: function (value) {
                    return '<div style="direction: rtl;overflow:hidden;">' + value + '</div>';
                }
            },

            {
                field: 'phaLocDesc',
                title: 'ҩ��',
                width: 150,
                hidden: PHA_IP_QUERY_DISP.WardFlag === 'Y' ? false : true,
                sortable: true
            },
            {
                field: 'locDesc',
                title: '����',
                width: 150,
                sortable: true
            },
            {
                field: 'dispCatDesc',
                title: '��ҩ���',
                width: 75,
                sortable: true
            },
            {
                field: 'doseRange',
                title: '��ҩ���ڷ�Χ',
                width: 120,
                align: 'center'
            },

            {
                field: 'printDateTime',
                title: '����ʱ��',
                width: 155,
                align: 'center',
                sortable: true,
                formatter: function (value, row, index) {
                    return row.printDate + ' ' + row.printTime;
                }
            },
            {
                field: 'printUserName',
                title: '������',
                width: 100,
                sortable: true
            },
            {
                field: 'operateDateTime',
                title: '��ҩʱ��',
                width: 155,
                align: 'center',
                sortable: true,
                formatter: function (value, row, index) {
                    return row.operateDate + ' ' + row.operateTime;
                }
            },
            {
                field: 'operateUserName',
                title: '��ҩ��',
                width: 100,
                sortable: true
            },
            {
                field: 'collectDateTime',
                title: '��ҩʱ��',
                width: 155,
                align: 'center',
                sortable: true,
                formatter: function (value, row, index) {
                    return row.collectDate + ' ' + row.collectTime;
                }
            },
            {
                field: 'collectUserName',
                title: '��ҩ��',
                width: 100,
                sortable: true
            },
            {
                field: 'collateUserName',
                title: '�˶���',
                width: 100,
                sortable: true
            },

            {
                field: 'resFlag',
                title: '���',
                width: 50,
                sortable: true,
                align: 'center',
                formatter: function (value, row, index) {
                    if (value === 'Y') {
                        return $g('��');
                    }
                    return '';
                }
            },
            {
                field: 'way',
                title: '��ҩ��ʽ',
                sortable: true,
                hidden: true,
                styler: function (value, row, index) {
                    if (value == 'DOCLOC') {
                        return 'color:#1278b8;';
                    }
                    return '';
                },
                formatter: function (value, row, index) {
                    if (value == 'WARD') {
                        return '������ҩ';
                    } else if (value == 'DOCLOC') {
                        return 'ҽ�����ҷ�ҩ';
                    }
                }
            },
            {
                field: 'status',
                title: '״̬',
                formatter: function (value, row, index) {
                    if (value == 'Print') {
                        return $g('�Ѵ�ӡ');
                    } else if (value == 'Confirm') {
                        return $g('����ҩȷ��');
                    } else if (value == 'Collect') {
                        return $g('��ҩ���');
                    }
                },
                sortable: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        exportXls: false,
        columns: columns,
        fitColumns: false,
        // showFooter: true,
        toolbar: '#panelCondition',
        pageNumber: 1,
        pageSize: 100,
        autoSizeColumn: true,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        queryOnSelect: false,
        onSortColumn: function () {
            QueryHandler();
        },
        loadFilter: PHAIP_COM.LocalFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            $('#gridDetail').datagrid('clear');
            $('#gridInci').datagrid('clear');
        },
        onSelect: SelectHandler,
        onUnselect: SelectHandler
    };
    PHA.Grid('gridPhac', dataGridOption);
    function SelectHandler(rowIndex, rowData) {
        if ($(this).datagrid('options').queryOnSelect === false) {
            $(this).datagrid('options').queryOnSelect = true;
            $(this).datagrid('unselectAll');
            $(this).datagrid('selectRow', rowIndex);

            QueryDetailHandler();
            QueryInciHandler();

            $(this).datagrid('options').queryOnSelect = false;
        }
    }
}
function InitGridInci() {
    var columns = [
        [
            {
                field: 'inci',
                title: '�����ID',
                width: 100,
                hidden: true
            },
            {
                field: 'inciCode',
                title: '����',
                width: 100
            },
            {
                field: 'inciDesc',
                title: '����',
                width: 300,
                sortable: true
            },
            {
                field: 'manfDesc',
                title: '������ҵ',
                width: 200
            },
            {
                field: 'uomDesc',
                title: '��λ',
                width: 100
            },
            {
                field: 'dispQty',
                title: '��ҩ����',
                width: 100,
                align: 'right'
            },
            {
                field: 'resQty',
                title: '�������',
                width: 100,
                align: 'right'
            },
            {
                field: 'qty',
                title: 'ʵ������',
                width: 100,
                align: 'right'
            },
            {
                field: 'sp',
                title: '�ۼ�',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'spAmt',
                title: '���',
                width: 100,
                align: 'right'
            },
            {
                field: 'insuCode',
                title: '����ҽ������'
            },
            {
                field: 'insuDesc',
                title: '����ҽ������',
                width: 300
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        exportXls: false,
        columns: columns,
        fitColumns: true,
        //showFooter: true,
        toolbar: [],
        pageSize: 100,
        pageNumber: 1,
        onSortColumn: function () {
            QueryInciHandler();
        },
        loadFilter: PHAIP_COM.LoadFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
        },
        onSelect: function () {}
    };
    PHA.Grid('gridInci', dataGridOption);
}

function InitGridDetail() {
    var columns = [
        [
            {
                field: 'docLocDesc',
                title: '��������',
                width: 150
            },
            {
                field: 'bedNo',
                title: '����',
                width: 70
            },
            {
                field: 'patNo',
                title: '�ǼǺ�',
                width: 100,
                formatter: function (value, row, index) {
                    var qOpts = "{AdmId:'" + row.adm + "'}";
                    return '<a class="pha-grid-a" onclick="PHA_UX.AdmDetail({},' + qOpts + ')">' + value + '</a>';
                }
            },
            {
                field: 'patName',
                title: '����',
                width: 100
            },
            {
                field: 'doseDate',
                title: '��ҩ����',
                width: 75,
                align: 'center'
            },
            {
                field: 'doseTime',
                title: '��ҩʱ��',
                width: 80,
                align: 'center',
                formatter: function (value, row, index) {
                    var arr = JSON.parse(row.doseArr);
                    if (arr.length === 0) {
                        return '';
                    }
                    var cntTag = '<div class="pha-tag pha-tag-success tag-cnt">' + arr.length + '</div>';
                    return FormatDoseHtml([arr[0]], cntTag);
                }
            },
            {
                field: 'prescNo',
                title: '������',
                width: 120,
                formatter: function (value, row, index) {
                    var phacilStr = row.phacilStr;
                    if (phacilStr.indexOf(',')) phacilStr = phacilStr.split(',')[0];
                    var phacId = '';
                    if (phacilStr != '') phacId = phacilStr.split('||')[0];
                    var params = row.prescNo + '!!' + row.sysDspDate + '!!' + phacId;
                    return '<a onclick=\'showViewPresc("' + params + '")\'>' + value + '</a>';
                }
            },
            {
                field: 'freqDesc',
                title: 'Ƶ��'
            },
            {
                field: 'instrucDesc',
                title: '�÷�',
                width: 75
            },
            {
                field: 'priDesc',
                title: '����',
                width: 75
            },
            {
                field: 'inciCode',
                title: '����',
                width: 100,
                sortable: true
            },
            {
                field: 'inciDesc',
                title: '����',
                width: 300,
                sortable: true
            },
            {
                field: 'manfDesc',
                title: '������ҵ',
                width: 150
            },

            {
                field: 'uomDesc',
                title: '��λ',
                width: 75
            },

            {
                field: 'dispQty',
                title: '��ҩ',
                width: 50,
                align: 'right'
            },
            {
                field: 'resQty',
                title: '���',
                width: 50,
                align: 'right'
            },
            {
                field: 'qty',
                title: 'ʵ��',
                width: 50,
                align: 'right'
            },
            {
                field: 'sp',
                title: '�ۼ�',
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
                field: 'resArr',
                title: '�����Ϣ',
                sortable: true,
                formatter: function (value, row, index) {
                    var arr = JSON.parse(row.resArr);
                    if (arr.length === 0) {
                        return '';
                    }
                    var cntTag = '<div class="pha-tag pha-tag-success tag-cnt">' + arr.length + '</div>';
                    return FormatResHtml(arr, cntTag);
                }
            },
            {
                field: 'insuCode',
                title: '����ҽ������'
            },
            {
                field: 'insuDesc',
                title: '����ҽ������'
            },
            {
                field: 'sysDspDate',
                title: '��ҩ����',
                hidden: true
            },
            {
                field: 'phacilStr',
                title: '��ҩ�ӱ�ID��',
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        exportXls: false,
        url: '',
        columns: columns,
        fitColumns: false,
        autoSizeColumn: true,
        pageNumber: 1,
        toolbar: [],
        pageSize: 100,
        pageNumber: 1,
        loadFilter: PHAIP_COM.LocalFilter,
        onSortColumn: function () {
            QueryDetailHandler();
        },

        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            $('.pha-res-body .pha-tag').hover(
                function (e) {
                    var rowIndex = $(e.target).closest('tr').attr('datagrid-row-index') * 1;
                    var rowData = $('#gridDetail').datagrid('getRows')[rowIndex];
                    if ($(e.target).closest('td').attr('field') === 'doseTime') {
                        ShowDoseDetail(rowData);
                    } else {
                        ShowResDetail(rowData);
                    }
                },
                function () {
                    WebuiPopovers.hideAll();
                }
            );
        }
    };
    PHA.Grid('gridDetail', dataGridOption);
}

function ShowDoseDetail(rowData) {
    var doseData = JSON.parse(rowData.doseArr);
    var info = FormatDoseHtml(doseData, '');

    WebuiPopovers.show($(event.target), { title: '��ҩ��Ϣ', content: info, animated: 'pop', closeable: false });
    //    $('#winDoseInfo').html(info);
    //    $('#winDose')
    //        .window('open')
    //        .window('resize', { width: $('#winDose')[0].scrollWidth });
}
function ShowResDetail(rowData) {
    //    $('#winResInfo').html('');
    var $target = $(event.target);
    var phacilStr = rowData.phacilStr;
    $.cm(
        {
            ClassName: 'PHA.IP.Query.Disp',
            MethodName: 'GetResDetailData',
            phacilStr: phacilStr
        },
        function (rowsData) {
            var htmlArr = [];
            for (var i = 0; i < rowsData.length; i++) {
                var rowData = rowsData[i];
                var rowHtmlArr = [];
                rowHtmlArr.push('<div>' + rowData.patNo + '</div>');
                rowHtmlArr.push('<div style="width:50px;padding-left:5px;">' + rowData.patName + '</div>');
                rowHtmlArr.push('<div style="padding-left:5px;"> ' + rowData.doseDateTime + ' </div>');
                rowHtmlArr.push('<div style="font-style: italic;padding-left:5px;padding-right:5px;">' + rowData.qtyUom + '</div>');
                rowHtmlArr.push('<div class="split"> | </div>');
                rowHtmlArr.push('<div> ' + rowData.reqNo + ' </div>');
                rowHtmlArr.push('<div style="padding-left:5px"> ' + rowData.reqDateTime + ' </div>');
                rowHtmlArr.push('<div class="split"> | </div>');
                rowHtmlArr.push('<div style="padding-right:10px;"> ' + rowData.oeore + ' </div>');
                var paddstyle = '';
                if (i > 0) {
                    paddstyle += 'padding-top:5px;border-top:1px solid #ccc;';
                }
                paddstyle += 'padding-bottom:5px;';
                htmlArr.push('<div class="pha-res-body" style="' + paddstyle + ';white-space: nowrap;">' + rowHtmlArr.join('') + '</div>');
            }
            WebuiPopovers.show($target, { title: '�����Ϣ', content: htmlArr.join(''), animated: 'pop', closeable: false });
            //            $('#winResInfo').html(htmlArr.join(''));
            //            $('#winRes').window('open');
            //            // ���ÿ��
            //            $('#winRes').window('resize', { width: $('#winRes')[0].scrollWidth });
        }
    );
}
function FormatDoseHtml(rowsData, cntTag) {
    var htmlArr = [];
    for (var i = 0; i < rowsData.length; i++) {
        var rowData = rowsData[i];
        var rowHtmlArr = [];
        rowHtmlArr.push('<div style="min-width:50px">' + rowData.doseTime + '</div>');

        var paddstyle = '';
        if (cntTag === '') {
            paddstyle += 'padding-bottom:5px;';
            rowHtmlArr.push('<div style="font-style: italic;padding-left:5px;padding-right:5px;">' + rowData.qtyUom + '</div>');
            rowHtmlArr.push('<div class="split"> | </div>');
            rowHtmlArr.push('<div style="padding-right:10px;">' + rowData.oeore + '</div>');
        } else {
        }
        if (i > 0) {
            paddstyle += 'padding-top:5px;border-top:1px solid #ccc;';
        }
        htmlArr.push('<div class="pha-res-body" style="' + paddstyle + ';white-space: nowrap;">' + cntTag + rowHtmlArr.join('') + '</div>');
    }
    return '<div class="js-grid-doseTime">' + htmlArr.join('') + '</div>';
}
function FormatResHtml(rowsData, cntTag) {
    var htmlArr = [];
    for (var i = 0; i < rowsData.length; i++) {
        var rowData = rowsData[i];
        if (i > 0) {
            htmlArr.push('<div style="padding-left:10px;padding-right:10px;font-weight:bold;">/</div>');
        }
        htmlArr.push('<div>' + rowData.patName + '</div>');
        htmlArr.push('<div style="padding-left:5px; font-style: italic;"> ' + rowData.qtyUom + '</div>');
    }
    var htmlStr = '<div class="pha-res-body">' + cntTag + htmlArr.join('') + '</div>';
    return htmlStr;
}
function QueryHandler() {
    $('#gridPhac').datagrid('clearChecked');
    $('#gridPhac').datagrid('loading');
    setTimeout(Query, 100);
}
function Query() {
    var $grid = $('#gridPhac');
    $grid.datagrid('clear');
    var pJson = GetParamsJson();

    var sort = $grid.datagrid('options').sortName;
    var order = $grid.datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Disp',
            QueryName: 'PHACollected',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );

    $grid.datagrid('loadData', rowsData);
}

function QueryInciHandler() {
    $('#gridInci').datagrid('loading');
    setTimeout(QueryInci, 100);
}
function QueryInci() {
    var gridSel = $('#gridPhac').datagrid('getSelected') || '';
    if (gridSel === '') {
        $('#gridInci').datagrid('clear');
    }
    var pJson = GetParamsJson();
    pJson.phac = gridSel.phac;

    var sort = $('#gridInci').datagrid('options').sortName;
    var order = $('#gridInci').datagrid('options').sortOrder;

    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Disp',
            QueryName: 'PHACollectedInci',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );
    $('#gridInci').datagrid('loadData', rowsData);
}
function GetParamsJson() {
    return {
        startDate: $('#conStartDate').datebox('getValue') || '',
        endDate: $('#conEndDate').datebox('getValue') || '',
        startTime: $('#conStartTime').timespinner('getValue') || '',
        endTime: $('#conEndTime').timespinner('getValue') || '',
        phaLoc: $('#conPhaLoc').combobox('getValue') || '',
        inci: $('#conInci').lookup('getValue') || '',
        dispCat: $('#conDispCat').combobox('getValues').join(','),
        way: $('#conWay').combobox('getValue') || '',
        docLoc: $('#conDocLoc').combobox('getValue'),
        wardLoc: $('#conWardLoc').combobox('getValue'),
        patNo: $('#conPatNo').val() || '',
        dispNo: $('#conDispNo').val(),
        longFlag: $('#conLong').checkbox('getValue') === true ? 'Y' : 'N',
        shortFlag: $('#conShort').checkbox('getValue') === true ? 'Y' : 'N'
    };
}

function QueryDetailHandler() {
    $('#gridDetail').datagrid('loading');
    setTimeout(QueryDetail, 100);
}

function QueryDetail() {
    var gridSel = $('#gridPhac').datagrid('getSelected') || '';
    if (gridSel === '') {
        $('#gridDetail').datagrid('clear');
    }
    var pJson = GetParamsJson();
    pJson.phac = gridSel.phac;
    var $grid = $('#gridDetail');
    var sort = $grid.datagrid('options').sortName;
    var order = $grid.datagrid('options').sortOrder;

    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Disp',
            QueryName: 'PHACollectedDetail',
            pJsonStr: JSON.stringify(pJson),
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );

    $grid.datagrid('loadData', rowsData);
}

function CleanHandler() {
    $('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
    $('#conStartTime').timespinner('setValue', '');
    $('#conEndTime').timespinner('setValue', '');
    $('#conPhaLoc').combobox('clear');
    $('#conWardLoc').combobox('clear');
    if (PHA_IP_QUERY_DISP.WardFlag !== 'Y') {
        $('#conPhaLoc').combobox('select', session['LOGON.CTLOCID']);
    } else {
        $('#conWardLoc').combobox('select', session['LOGON.CTLOCID']);
    }
    $('#conDispCat').combobox('clear');
    $('#conWay').combobox('clear');
    $('#conDocLoc').combobox('clear');
    $('#conDispNo').val('');
    $('#conPatNo').val('');
    $('#gridPhac').datagrid('clear').datagrid('clearChecked');
    $('#gridInci').datagrid('clear');
    $('#gridDetail').datagrid('clear');
    $('#kwLong').keywords('clearAllSelected');
    $('#kwLong').keywords('select', 'LONG');
    $('#kwShort').keywords('clearAllSelected');
    $('#kwShort').keywords('select', 'SHORT');
    $('#PHA_UX_AdmDetail, #PHA_UX_TimeLine, #winRes, #winDose').window('close');
    $('#conInci').lookup('clear');
}

function PrintOpen() {
    var gridChked = $('#gridPhac').datagrid('getChecked') || '';
    if (gridChked.length === 0) {
        PHA.Popover({
            msg: '���ȹ�ѡ��Ҫ��ӡ�ķ�ҩ��',
            type: 'alert'
        });
        return;
    }
    if (GetCheckedPhac4Pc().length === 0) {
        PHA.Popover({
            msg: '�ƶ��˲��������ݲ���Ҫ��ӡ',
            type: 'alert'
        });
        return;
    }
    $('#winPrt').window('open');
}
function PrintHandler() {
    var prtArr = [];
    var data = $('#kwPrintWay').keywords('getSelected');
    for (var i = 0, length = data.length; i < length; i++) {
        prtArr.push(data[i].id);
    }
    var prtType = '';
    if (prtArr.indexOf('detail') >= 0) {
        prtType = 1;
    }
    if (prtArr.indexOf('total') >= 0) {
        prtType = 2;
    }
    if (prtArr.indexOf('detail') >= 0 && prtArr.indexOf('total') >= 0) {
        prtType = 3;
    }

    var gridChked = GetCheckedPhac4Pc();
    var phacArr = [];
    $.each(gridChked, function (index, rowData) {
        phacArr.push(rowData.phac);
    });
    var printResRet = '',
        printOther = '';
    if (prtArr.indexOf('resdetail') >= 0) {
        printResRet = 1;
        if (prtType === '') {
            prtType = -1;
        }
    }
    if (prtArr.indexOf('kflabel') >= 0) {
        printOther = 'PrintKFYBag';
        if (prtType === '') {
            prtType = -1;
        }
    }
    IPPRINTCOM.Print({
        phacStr: phacArr.join('^'),
        otherStr: session['LOGON.GROUPID'] + '^' + session['LOGON.USERID'],
        printType: prtType,
        reprintFlag: 1,
        pid: '',
        printResRet: printResRet,
        printOther: printOther
    });
    $('#winPrt').window('close');
}

function showViewPresc(params) {
    var prescNo = params.split('!!')[0];
    var prescTitle = tkMakeServerCall('PHA.OP.COM.Method', 'GetPrescTitle', prescNo);
    if (prescTitle.indexOf('��') < 0 && (prescTitle.indexOf('��') < 0) & (prescTitle.indexOf('��') < 0)) {
        PHA.Popover({
            msg: '��ѡ������ҩƷԤ��������ϸ��',
            type: 'alert'
        });
        return;
    }
    var lnk = 'pha.ip.v4.dmprescview.csp?ViewDMParamStr=' + params;
    websys_createWindow(lnk, '���鴦��Ԥ��', 'width=95%,height=75%');
}

function InitSendMachine() {
    var sendMachineFlag = '';
    var phaLocId = $('#conPhaLoc').combobox('getValue') || '';
    if (phaLocId != '') {
        var phaConfig = tkMakeServerCall('web.DHCSTPHALOC', 'GetPhaflag', phaLocId);
        if (phaConfig != '') {
            sendMachineFlag = phaConfig.split('^')[31];
        }
    }
    if (sendMachineFlag != 'Y') $('#SendMachine').css('display', 'none');
}
/** ��ȡ�ƶ��˲�����¼ */
function GetCheckedPhac4Mob() {
    return GetCheckedPhac(function (rowData) {
        return rowData.mobileFlag === 'Y';
    });
}
/** ��ȡ���Զ˲�����¼ */
function GetCheckedPhac4Pc() {
    return GetCheckedPhac(function (rowData) {
        return rowData.mobileFlag !== 'Y';
    });
}
function GetCheckedPhac(filterFunc) {
    var retRows = [];
    var checked = $('#gridPhac').datagrid('getChecked') || '';
    $.each(checked, function (index, rowData) {
        if (filterFunc) {
            if (filterFunc(rowData) === true) {
                retRows.push(rowData);
            }
        }else{
            retRows.push(rowData);
        }
    });
    return retRows;
}
function sendMachine() {
    PHA.Popover({
        msg: '����ʹ�ð�ҩ���ӿڣ���Ҫ�ж�Ӧ�ĺ�ͬģ�飬����Ӻ�ͬģ�����ϵ��Ʒ�飡',
        type: 'alert'
    });
    return;
    var gridChked = $('#gridPhac').datagrid('getChecked') || '';
    if (gridChked.length === 0) {
        PHA.Popover({
            msg: '���ȹ�ѡ��Ҫ���͵ķ�ҩ��',
            type: 'alert'
        });
        return;
    }
    var phacArray = [];
    $.each(gridChked, function (index, rowData) {
        phacArray.push(rowData.phac);
    });
    var phacStr = phacArray.join('^');
    var phacArr = phacStr.split('^');
    for (var phaci = 0; phaci < phacArr.length; phaci++) {
        var pharowid = phacArr[phaci];
        var sendret = tkMakeServerCall('web.DHCSTInterfacePH', 'SendOrderToMechine', pharowid);
        if (sendret != 0) {
            var retString = sendret;
            var senderr = 1;
            if (senderr == '1') {
                PHA.Popover({
                    msg: '���Ͱ�ҩ��ʧ��,�������:' + retString,
                    type: 'alert'
                });
                return;
            }
        }
    }
}
