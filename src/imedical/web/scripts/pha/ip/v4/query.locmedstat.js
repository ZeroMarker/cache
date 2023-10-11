/**
 * ����:	 סԺҩ�� - ������ҩ��ѯ
 * ��д��:	 yunhaibao
 * ��д����: 2021-07-14
 * ˵��:	 ����ҽ��������ݵ�¼, ���������Ҳ�ѯ����, ������Ƶ�
 * 			 ���Բ�����ݵ�¼, ����������������ѯ
 */
var PHA_IP_QUERY_LOCMEDSTAT = {
    DefaultData: [
        {
            conStartDate: 't',
            conEndDate: 't',
            conStatus: 'TC'
        }
    ],
    Pid: tkMakeServerCall('PHA.COM.Base', 'NewPid'),
    Loaded: false
};

var Get = {};

$(function () {
    InitDict();
    InitGridMed();
    InitGridDsp();
    $('#btnFind').on('click', function () {
        Query();
    });
    $('#btnClean').on('click', function () {
        PHA.DomData('.js-con-data', {
            doType: 'clear'
        });
        $('#gridMed').datagrid('clear');
        $('#gridDsp').datagrid('clear');
        $('#conRecLoc').combobox('reload');
        PHA.SetVals(PHA_IP_QUERY_LOCMEDSTAT.DefaultData);
    });
    $('#conPatNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $(this).val(PHA_COM.FullPatNo($(this).val()));
            Query();
        }
    });

    PHA.SetVals(PHA_IP_QUERY_LOCMEDSTAT.DefaultData);

    PHA_EVENT.Key([
        ['btnClean', 'alt+c'],
        ['btnFind', 'alt+f'],
        ['btnFind', 'ctrl+enter']
    ]);
});

function InitDict() {
    PHA.ComboBox('conStatus', {
        panelHeight: 'auto',
        width: 88,
        editable: false,
        data: [
            { RowId: 'TC,C', Description: $g('ȫ��') },
            { RowId: 'TC', Description: $g('δ��') },
            { RowId: 'C', Description: $g('�ѷ�') }
        ],
        onSelect: function (datdat) {
            if (PHA_IP_QUERY_LOCMEDSTAT.Loaded === true) {
                Query();
            }
        }
    });

    PHA.ComboBox('conPoison', {
        url: PHA_STORE.PHCPoison().url,
        multiple: false
    });
    PHA.ComboBox('conRecLoc', {
        panelHeight: 'auto',
        url: PHA_STORE.Pharmacy('IP').url,
        //url: 'websys.Broker.cls?ResultSetType=Array&ClassName=PHA.IP.Query.LocMedStat&QueryName=LinkLoc&loc=' + session['LOGON.CTLOCID'],
        onLoadSuccess: function (data) {
            //$(this).combobox('setValue', data[0].RowId);
        }
    });
    PHA.LookUp('conArcim', $.extend(PHA_STORE.ArcItmMast('Y'), {
	    width: window.HISUIStyleCode == 'lite' ? 230 : 238
	}));
}
function InitGridMed() {
    var columns = [
        [
            {
                field: 'arcim',
                title: 'arcim',
                hidden: true,
                width: 150
            },
            {
                field: 'arcimDesc',
                title: 'ҩƷ����',
                width: 200
            },
            {
                field: 'tcQty',
                title: 'δ��',
                width: 40,
                align: 'right'
            },
            {
                field: 'cQty',
                title: '�ѷ�',
                width: 40,
                align: 'right'
            },
            {
                field: 'uomDesc',
                title: '��λ',
                width: 25,
                align: 'center'
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        toolbar: '#gridMedBar',
        columns: columns,
        exportXls: false,
        pageList: [100, 300, 500, 1000],
        pageSize: 100,
        striped: true,
        fitColumns: true,
        onSelect: function () {
            QueryDetail();
        },
        onLoadSuccess: function () {
            $('#gridDsp').datagrid('clear');
        }
    };
    PHA.Grid('gridMed', dataGridOption);
}

function InitGridDsp() {
    var columns = [
        [
            {
                field: 'dsp',
                title: '�����ID',
                width: 50,
                hidden: true
            },
            {
                field: 'statusDesc',
                title: '״̬',
                width: 50,
                align: 'center',
                styler: function (value, row, index) {
                    if (value === '�ѷ�') {
                        return 'background-color:#aade5f;color:#ffffff;';
                    }
                }
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
                field: 'dosage',
                title: '����'
            },
            {
                field: 'qtyUom',
                title: '����'
            },
            {
                field: 'doseDateTime',
                title: '�ַ�ʱ��',
                width: 95
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
                field: 'oeoriRemark',
                title: 'ҽ����ע',
                width: 100
            },
            {
                field: 'docLocDesc',
                title: '��������',
                width: 100
            },
            {
                field: 'oeoriDateTime',
                title: '����ʱ��',
                width: 160
            },
            {
                field: 'recLocDesc',
                title: '���տ���'
            },
            {
                field: 'wardLocDesc',
                title: '���ڲ���'
            },
            {
                field: 'oeore',
                title: 'ִ�м�¼ID',
                width: 100,
                formatter: function (value, row, index) {
                    return '<a class="pha-grid-a js-grid-oeore">' + value + '</a>';
                }
            }
        ]
    ];

    var dataGridOption = {
        toolbar: [],
        url: '',
        pageList: [100, 300, 500, 1000],
        pageSize: 100,
        pagination: true,
        columns: columns,
        exportXls: false
    };
    PHA.Grid('gridDsp', dataGridOption);
    PHA.GridEvent('gridDsp', 'click', ['pha-grid-a js-grid-oeore'], function (rowIndex, rowData, className) {
        if (className === 'pha-grid-a js-grid-oeore') {
            PHA_UX.TimeLine(
                {
                    modal: true,
                    top: null,
                    modalable: true
                },
                {
                    oeore: rowData.oeore
                }
            );
        }
    });
}

function Query() {
    PHA_IP_QUERY_LOCMEDSTAT.Loaded = true;
    var pJson = GetQueryParamsJson();
    if (pJson.recLoc === '') {
        PHA.Popover({
            msg: '��ѡ����տ���',
            type: 'info'
        });
        return;
    }
    $('#gridMed').datagrid('options').url = $URL;
    $('#gridMed').datagrid('query', {
        ClassName: 'PHA.IP.Query.LocMedStat',
        QueryName: 'TotalMedData',
        pJsonStr: JSON.stringify(pJson),
        pid: PHA_IP_QUERY_LOCMEDSTAT.Pid,
        rows: 9999
    });
}

function QueryDetail() {
    var pJson = GetQueryParamsJson();
    var gridSel = $('#gridMed').datagrid('getSelected');
    pJson.arcim = gridSel.arcim;

    $('#gridDsp').datagrid('options').url = $URL;
    $('#gridDsp').datagrid('query', {
        ClassName: 'PHA.IP.Query.LocMedStat',
        QueryName: 'TotalDspData',
        pid: PHA_IP_QUERY_LOCMEDSTAT.Pid,
        pJsonStr: JSON.stringify(pJson)
    });
}

function GetQueryParamsJson() {
    return {
        startDate: $('#conStartDate').datebox('getValue') || '',
        endDate: $('#conEndDate').datebox('getValue') || '',
        startTime: $('#conStartTime').timespinner('getValue') || '',
        endTime: $('#conEndTime').timespinner('getValue') || '',
        poison: $('#conPoison').combobox('getValue'),
        arcim: $('#conArcim').lookup('getValue'),
        status: $('#conStatus').combobox('getValue'),
        recLoc: $('#conRecLoc').combobox('getValue'),
        patNo: $('#conPatNo').val(),
        loc: session['LOGON.CTLOCID']
    };
}