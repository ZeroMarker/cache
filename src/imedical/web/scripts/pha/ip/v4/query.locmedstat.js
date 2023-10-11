/**
 * 名称:	 住院药房 - 科室领药查询
 * 编写人:	 yunhaibao
 * 编写日期: 2021-07-14
 * 说明:	 当以医生科室身份登录, 按开单科室查询数据, 如麻醉科等
 * 			 当以病区身份登录, 按患者所属病区查询
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
            { RowId: 'TC,C', Description: $g('全部') },
            { RowId: 'TC', Description: $g('未发') },
            { RowId: 'C', Description: $g('已发') }
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
                title: '药品名称',
                width: 200
            },
            {
                field: 'tcQty',
                title: '未发',
                width: 40,
                align: 'right'
            },
            {
                field: 'cQty',
                title: '已发',
                width: 40,
                align: 'right'
            },
            {
                field: 'uomDesc',
                title: '单位',
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
                title: '打包表ID',
                width: 50,
                hidden: true
            },
            {
                field: 'statusDesc',
                title: '状态',
                width: 50,
                align: 'center',
                styler: function (value, row, index) {
                    if (value === '已发') {
                        return 'background-color:#aade5f;color:#ffffff;';
                    }
                }
            },
            {
                field: 'patNo',
                title: '登记号',
                width: 100
            },
            {
                field: 'patName',
                title: '姓名',
                width: 100
            },
            {
                field: 'dosage',
                title: '剂量'
            },
            {
                field: 'qtyUom',
                title: '数量'
            },
            {
                field: 'doseDateTime',
                title: '分发时间',
                width: 95
            },
            {
                field: 'freqDesc',
                title: '频次',
                width: 75
            },
            {
                field: 'instrucDesc',
                title: '用法',
                width: 100
            },
            {
                field: 'oeoriRemark',
                title: '医嘱备注',
                width: 100
            },
            {
                field: 'docLocDesc',
                title: '开单科室',
                width: 100
            },
            {
                field: 'oeoriDateTime',
                title: '开单时间',
                width: 160
            },
            {
                field: 'recLocDesc',
                title: '接收科室'
            },
            {
                field: 'wardLocDesc',
                title: '所在病区'
            },
            {
                field: 'oeore',
                title: '执行记录ID',
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
            msg: '请选择接收科室',
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