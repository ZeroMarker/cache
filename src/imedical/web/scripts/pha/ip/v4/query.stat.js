/**
 * ����:	 סԺҩ�� - ��ҩͳ��
 * ��д��:	 yunhaibao
 * ��д����: 2020-11-12
 */
 var PHA_IP_QUERY_STAT = {
    WardFlag: session['LOGON.WARDID'] != '' ? 'Y' : 'N',
    Pid: tkMakeServerCall('PHA.COM.Base', 'NewPid')
};
PHAIP_COM.KillTmpOnUnLoad('PHA.IP.Query.Stat', PHA_IP_QUERY_STAT.Pid);
$(function () {
    InitDict();
    InitGridGrp();
    InitGridInci();
    InitGridOrder();
    $('#btnClean').on('click', CleanHandler);
    $('#btnFind').on('click', QueryHandler);
    $('#btnFindInci').on('click', QueryInciHandler);

    PHA_EVENT.Key([
        ['btnClean', 'alt+c'],
        ['btnFind', 'alt+f'],
        ['btnFind', 'ctrl+enter'],
        ['btnFindInci', 'alt+s']
    ]);
});

function InitDict() {
    var combWidth = 160;
    $('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');

    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('IP').url,
        panelHeight: 'auto',
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
        },
        onSelect: function (data) {
            PHA.ComboBox('conDispCat', {
                url: PHAIP_STORE.StkDrugGroup().url + '&loc=' + data.RowId,
                panelHeight: 'auto',
                width: combWidth,
                multiple: true
            });
            PHA.ComboBox('conWardLoc', {
                url: PHA_STORE.WardLocByRecLoc().url+'&RecLocId='+ data.RowId,
                width: combWidth,
            });
        }
    });
    PHA.ComboBox('conWay', {
        data: [
            { RowId: 'WARD', Description: $g('��������') },
            { RowId: 'DOCLOC', Description: $g('���һ���') },
            { RowId: 'STKCAT', Description: $g('������') },
            { RowId: 'ARCCAT', Description: $g('ҽ������') },
            { RowId: 'POISON', Description: $g('���Ʒ���') },
            { RowId: 'PHCFORM', Description: $g('����') },
            { RowId: 'DISPCAT', Description: $g('��ҩ���') },
            { RowId: 'PRIORITY', Description: $g('ҽ�����ȼ�') }
        ],
        panelHeight: 'auto',
        editable: false,
        width: combWidth,
        onSelect: function () {
            QueryHandler();
        }
    });
    $('#conWay').combobox('setValue', 'WARD');

    PHA.ComboBox('conWardLoc', {
        url: PHA_STORE.WardLocByRecLoc().url+'&RecLocId='+session['LOGON.CTLOCID'],
        width: combWidth
    });
    PHA.ComboBox('conDocLoc', {
        url: PHA_STORE.DocLoc().url,
        width: combWidth
    });

    PHA.ComboBox('conPoison', {
        url: PHA_STORE.PHCPoison().url,
        width: combWidth,
        multiple: true
    });

    var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
        width: 220
    });
    PHA.LookUp('conInci', opts);

    PHA.ComboBox('conIntrType', {
        data: [
            { RowId: 'P', Description: $g('סԺ��ҩ') },
            { RowId: 'Y', Description: $g('סԺ��ҩ') },
            { RowId: 'F', Description: $g('���﷢ҩ') },
            { RowId: 'H', Description: $g('������ҩ') },
            { RowId: 'HC', Description: $g('���ﳷ����ҩ') }
        ],
        panelHeight: 'auto',
        multiple: true,
        width: 220,
        editable: false,
        onSelect: function () {}
    });
}
function InitGridGrp() {
    var columns = [
        [
            {
                field: 'grpID',
                title: 'grpID',
                width: 100,
                hidden: true
            },
            {
                field: 'itmChk',
                checkbox: true
            },
            {
                field: 'grpDesc',
                title: '����',
                width: 165,
                sortable: true
            },

            {
                field: 'dispAmt',
                title: '��ҩ���',
                // width: 90,
                align: 'right',
                sortable: true
            },
            {
                field: 'retAmt',
                title: '��ҩ���',
                // width: 90,
                align: 'right',
                sortable: true
            },
            {
                field: 'amt',
                title: '�ϼƽ��',
                //width: 90,
                align: 'right',
                sortable: true
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: true,
        showFooter: true,
        autoSizeColumn: true,
        toolbar: '#gridGrpBar',
        pageNumber: 1,
        pagination: false,
        singleSelect: false,
        onSortColumn: function () {
            QueryHandler();
        },
        queryOnSelect: false,
        loadFilter: PHA.LocalFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            $('#gridOrder').datagrid('clear');
            $('#gridInci').datagrid('clear');
        },
        onClickCell: function (rowIndex, field, value) {
            if (field !== 'itmChk') {
                $(this).datagrid('options').queryOnSelect = true;
            }
        },
        onSelect: SelectHandler,
        onUnselect: SelectHandler
    };
    PHA.Grid('gridGrp', dataGridOption);

    function SelectHandler(rowIndex, rowData) {
        if ($(this).datagrid('options').queryOnSelect == true) {
            $(this).datagrid('options').queryOnSelect = false;
            QueryInciHandler();
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
                width: 100,
                formatter: function (value, row, index) {
                    var inci = row.inci || '';
                    if (inci === '') {
                        return value;
                    }
                    return '<a class="pha-grid-a" onclick="QueryOrderHandler(' + inci + ')">' + value + '</a>';
                }
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
                title: '��λ'
                //width: 50
            },
            {
                field: 'dispQty',
                title: '��ҩ����',
                //width: 70,
                align: 'right'
            },
            {
                field: 'retQty',
                title: '��ҩ����',
                //width: 70,
                align: 'right'
            },
            {
                field: 'qty',
                title: '�ϼ�����',
                //width: 70,
                align: 'right',
                sortable: true
            },
            {
                field: 'sp',
                title: '�ۼ�',
                // width: 70,
                align: 'right',
                sortable: true
            },
            {
                field: 'amt',
                title: '�ϼƽ��',
                // width: 70,
                align: 'right'
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: true,
        showFooter: true,
        toolbar: [],
        pageSize: 100,
        pageNumber: 1,
        autoSizeColumn: true,
        onSortColumn: function () {
            QueryInciHandler();
        },
        loadFilter: PHAIP_COM.LocalFilter,
        onLoadSuccess: function () {
            $(this).datagrid('loaded');
            // $('#gridOrder').datagrid('clear');
        },
        onSelect: function () {
            // QueryOrderHandler();
        }
    };
    PHA.Grid('gridInci', dataGridOption);
}

function InitGridOrder() {
    var columns = [
        [
            {
                field: 'docLocDesc',
                title: '��������'
            },
            {
                field: 'locDesc',
                title: '��ҩ����'
            },
            {
                field: 'bedNo',
                title: '����'
            },
            {
                field: 'patNo',
                title: '�ǼǺ�'
//                ,
//                formatter: function (value, row, index) {
//                    return '<a class="pha-grid-a js-grid-patNo">' + value + '</a>';
//                }
            },
            {
                field: 'patName',
                title: '����'
            },
            {
                field: 'dosage',
                title: '����'
            },
            {
                field: 'freqDesc',
                title: 'Ƶ��'
            },
            {
                field: 'instrucDesc',
                title: '�÷�'
            },
            {
                field: 'busiType',
                title: '����',
                width: 50,
                styler: function (value, row, index) {
                    if (value === 'P' || value === 'F' || value === 'HC') {
                        //return 'background-color:#e3f7ff;color:#1278b8;';
                    } else if (value === 'Y' || value === 'H') {
                        return { class: 'phaip-grid-cell-ret' };
                    } else if (value === 'HC') {
                        return { class: 'phaip-grid-cell-ret' };
                    }
                },
                formatter: function (value, row, index) {
	                if (value === 'HC') return $g("������ҩ")
                    return value === 'P' || value === 'F' ? $g('��ҩ') : $g('��ҩ');
                }
            },
            {
                field: 'qtyUom',
                title: '����'
            },
            {
                field: 'spAmt',
                title: '���',
                align: 'right'
            },
            {
                field: 'oeore',
                title: 'ִ�м�¼ID',
                formatter: function (value, row, index) {
                    var busiType = row.busiType;
                    if (busiType === 'P' || busiType === 'Y') {
                        return '<a class="pha-grid-a js-grid-oeore">' + value + '</a>';
                    } else {
                        return value;
                    }
                }
            },
            {
                field: 'prescNo',
                title: '������',
                align: 'center'
            },
            {
                field: 'oeoriDateTime',
                title: '����ʱ��',
                align: 'center'
            },
            {
                field: 'nurSeeInfo',
                title: '��ʿ����ҽ����Ϣ',
                tipWidth: 'auto'
            },
            {
                field: 'nurAuditInfo',
                title: '��ҩ�����Ϣ'
            },
            {
                field: 'phaInfo',
                title: '������ҩ��Ϣ'
            },
            {
                field: 'phaNo',
                title: 'ҵ�񵥺�'
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: false,
        pageNumber: 1,
        border: true,
        toolbar: null,
        pageSize: 100,
        pageNumber: 1,
        bodyCls: 'panel-body-gray',
        loadFilter: PHAIP_COM.LocalFilter,
        onSortColumn: function () {
            QueryOrderHandler();
        },

        onLoadSuccess: function () {
            $(this).datagrid('loaded');
        }
    };
    PHA.Grid('gridOrder', dataGridOption);
    PHA.GridEvent('gridOrder', 'click', ['pha-grid-a js-grid-oeore', 'pha-grid-a js-grid-patNo'], function (rowIndex, rowData, className) {
        var winOpts = $('#winOrder').window('options');
        var winTop = winOpts.top;
        var winWidth = winOpts.width;
        var winLeft = winOpts.left;
        if (className === 'pha-grid-a js-grid-oeore') {
            PHA_UX.TimeLine(
                {
                    modal: true,
                    modalable:true,
                    width: winWidth - 20,
                    top: null,
                    left: null
                },
                { oeore: rowData.oeore }
            );
        }
//        if (className === 'pha-grid-a js-grid-patNo') {
//            PHA_UX.AdmDetail(
//                {
//                    top: winTop + $('body').height() / 2 - 50 + 10,
//                    height: 420,
//                    width: $('body').width() * 0.6
//                },
//                { AdmId: rowData.adm }
//            );
//        }
    });
}
function QueryHandler() {
    $('#gridGrp').datagrid('clearChecked');
    $('#gridGrp').datagrid('loading');
    setTimeout(Query, 100);
}
function Query() {
    var pJson = GetParamsJson();

    var ret = $.cm(
        {
            ClassName: 'PHA.IP.Query.Stat',
            MethodName: 'Collect',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_IP_QUERY_STAT.Pid,
            dataType: 'text'
        },
        false
    );

    var sort = $('#gridGrp').datagrid('options').sortName;
    var order = $('#gridGrp').datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Stat',
            QueryName: 'TotalGrpData',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_IP_QUERY_STAT.Pid,
            rows: 9999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );

    var footer = $.cm(
        {
            ClassName: 'PHA.IP.Query.Stat',
            MethodName: 'GetFooter',
            pid: PHA_IP_QUERY_STAT.Pid,
            type: 'TotalGrpData'
        },
        false
    );
    rowsData.footer = footer;

    $('#gridGrp').datagrid('loadData', rowsData);
    $('#gridGrp').datagrid('getData').originalRows = rowsData.rows;
}

function QueryInciHandler() {
    $('#gridInci').datagrid('loading');
    setTimeout(QueryInci, 100);
}
function QueryInci() {
    var pJson = GetParamsJson();
    var grpIDArr = [];
    var chkRows = $('#gridGrp').datagrid('getChecked');
    for (var i = 0; i < chkRows.length; i++) {
        grpIDArr.push(chkRows[i].grpID);
    }
    pJson.grpID = grpIDArr.join(',');

    var sort = $('#gridInci').datagrid('options').sortName;
    var order = $('#gridInci').datagrid('options').sortOrder;
    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Stat',
            QueryName: 'TotalInciData',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_IP_QUERY_STAT.Pid,
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );
    var footer = $.cm(
        {
            ClassName: 'PHA.IP.Query.Stat',
            MethodName: 'GetFooter',
            pid: PHA_IP_QUERY_STAT.Pid,
            type: 'TotalInciData'
        },
        false
    );
    rowsData.footer = footer;
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
        poison: $('#conPoison').combobox('getValues').join(','),
        way: $('#conWay').combobox('getValue') || '',
        // uomType: $('#conUomType').combobox('getValue') || '',
        intrType: $('#conIntrType').combobox('getValues').join(','),
        wardLoc: $('#conWardLoc').combobox('getValue'),
        docLoc: $('#conDocLoc').combobox('getValue')
    };
}
function QueryOrderHandler(inci) {
    var pJson = GetParamsJson();
    var grpIDArr = [];
    var chkRows = $('#gridGrp').datagrid('getChecked');
    for (var i = 0; i < chkRows.length; i++) {
        grpIDArr.push(chkRows[i].grpID);
    }
    pJson.grpID = grpIDArr.join(',');
    pJson.inci = inci;
    var sort = $('#gridOrder').datagrid('options').sortName;
    var order = $('#gridOrder').datagrid('options').sortOrder;

    var rowsData = $.cm(
        {
            ClassName: 'PHA.IP.Query.Stat',
            QueryName: 'TotalOrderData',
            pJsonStr: JSON.stringify(pJson),
            pid: PHA_IP_QUERY_STAT.Pid,
            rows: 9999999,
            page: 1,
            sort: sort,
            order: order
        },
        false
    );

    $('#gridOrder').datagrid('loadData', rowsData);

    $('#winOrder')
        .window({
            width: $('body').width()*0.8,
            height: $('body').height() * 0.8,
            //top: 20,
            //left: 20,
            closed: true,
            iconCls: 'icon-w-clock',
            resizable: true,
            modal:function(){
	         	try {
					return $('#winOrder').window('options').modal;
				}catch(e){
					return true
				}
	        }(),
            isTopZindex: true,
            maximizable: false,
            minimizable: false,
            collapsible: false
        })
        .window('open');
     $('#winOrder').window('setModalable');
}

function CleanHandler() {
    $('#conStartDate').datebox('setValue', 't');
    $('#conEndDate').datebox('setValue', 't');
    $('#conStartTime').timespinner('setValue', '');
    $('#conEndTime').timespinner('setValue', '');
    $('#conPhaLoc').combobox('clear');
    $('#conPhaLoc').combobox('select', session['LOGON.CTLOCID']);
    $('#conInci').lookup('clear');
    $('#conDispCat').combobox('clear');
    $('#conPoison').combobox('clear');
    $('#conWay').combobox('setValue', 'WARD');
    // uomType: $('#conUomType').combobox('getValue') || '',
    $('#conIntrType').combobox('clear');
    $('#conWardLoc').combobox('clear');
    $('#conDocLoc').combobox('clear');
    $('#gridGrp').datagrid('clear').datagrid('clearChecked');
    $('#gridInci').datagrid('clear');
    $('#gridOrder').datagrid('clear');
}
