/**
 * 名称:	 住院移动药房-物流箱查询
 * 编写人:	 yunhaibao
 * 编写日期: 2020-03-14
 */
 var PHA_IP_BOXQUERY = {
    WardFlag: (session['LOGON.WARDID'] || '') != '' ? 'Y' : 'N',
    DefaultData:[{
		conStartDate: 't',
		conEndDate: 't',
		conPhaLoc: (session['LOGON.WARDID'] || '') != '' ? '' : session['LOGON.CTLOCID'],
		conStat: 'Y'
	}]
};
$(function () {
    InitDict();
    InitGridWard();
    InitGridBox();
    $('#btnFind').on('click', Query);
    $('#btnClean').on('click', Clean);
    $('#btnCancel').on('click', Cancel);
    $('#btnPrint').on('click', Print);
    PHA.SetVals(PHA_IP_BOXQUERY.DefaultData);
});
function InitDict() {
    PHA.ComboBox('conPhaLoc', {
        url: PHA_STORE.Pharmacy('IP').url,
        panelHeight: 'auto',
        onLoadSuccess: function (data) {
            if (PHA_IP_BOXQUERY.WardFlag != 'Y') {
                $(this).combobox('selectDefault', session['LOGON.CTLOCID']);
            }
        },
        onSelect: function () {}
    });
    PHA.ComboBox('conStat', {
        data: [
            { RowId: 'Y', Description: $g('是') },
            { RowId: 'N', Description: $g('否') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
    });
}
function InitGridWard() {
    var columns = [
        [
            {
                field: 'wardLoc',
                title: '病区ID',
                width: 200,
                hidden: true
            },
            {
                field: 'wardLocDesc',
                title: '病区',
                width: 250
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        columns: columns,
        fitColumns: true,
        onLoadSuccess: function () {
            $('#gridBox').datagrid('clear');
        },
        onSelect: function () {
            QueryBox();
        }
    };
    PHA.Grid('gridWard', dataGridOption);
}

function InitGridBox() {
    var columns = [
        [
            {
                field: 'phb',
                title: '物流箱ID',
                width: 200,
                hidden: true
            },
            {
                field: 'wardLocDesc',
                title: '病区科室',
                width: 200
            },
            {
                field: 'no',
                title: '箱号',
                width: 200,
                align: 'center'
            },
            {
                field: 'num',
                title: '箱数',
                width: 100,
                align: 'center'
            },
            {
                field: 'inciCnt',
                title: '品种数',
                width: 100,
                align: 'center'
            },
            {
                field: 'createDateTime',
                title: '装箱时间',
                width: 155,
                align: 'center'
            },
            {
                field: 'statusDesc',
                title: '状态',
                width: 150
            },
            {
                field: 'useFlag',
                title: '是否可用',
                width: 100,
                align: 'center',
                formatter: PHAIP_COM.Grid.Formatter.YesNo
            },
            {
                field: 'remark',
                title: '备注',
                width: 200
            }
        ]
    ];
    var dataGridOption = {
        url: '',
        pagination: false,
        columns: columns,
        fitColumns: false,
        toolbar: '#gridBoxBar'
    };
    PHA.Grid('gridBox', dataGridOption);
}

function Query() {
    $('#gridWard').datagrid('clear');
    var pJson = GetQueryParamsJson();
    if (pJson.loc === '') {
        PHA.Popover({
            msg: '请选择药房',
            type: 'alert'
        });
        return;
    }

    $('#gridWard').datagrid('options').url = $URL;
    $('#gridWard').datagrid('query', {
        ClassName: 'PHA.IP.BoxQuery.Query',
        QueryName: 'WardLoc',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
}
function QueryBox() {
    var pJson = GetQueryParamsJson();
    if (pJson.loc === '') {
        PHA.Popover({
            msg: '请选择药房',
            type: 'alert'
        });
        return;
    }

    $('#gridBox').datagrid('options').url = $URL;
    $('#gridBox').datagrid('query', {
        ClassName: 'PHA.IP.BoxQuery.Query',
        QueryName: 'PHBox',
        pJsonStr: JSON.stringify(pJson),
        rows: 999
    });
}
function GetQueryParamsJson() {
    var wardLoc = '';
    var gridSel = $('#gridWard').datagrid('getSelected');
    if (gridSel != null) {
        wardLoc = gridSel.wardLoc;
    }

    var retJson = {
        loc: $('#conPhaLoc').combobox('getValue') || '',
        startDate: $('#conStartDate').datebox('getValue') || '',
        endDate: $('#conEndDate').datebox('getValue') || '',
        startTime: $('#conStartTime').timespinner('getValue') || '',
        endTime: $('#conEndTime').timespinner('getValue') || '',
        useFlag: $('#conStat').combobox('getValue') || '',
        wardLoc: wardLoc
    };
    return retJson;
}

function Cancel() {
    var gridSel = $('#gridBox').datagrid('getSelected');
    if (gridSel === null) {
        PHA.Popover({
            msg: '请先选中需要取消的记录',
            type: 'alert'
        });
        return;
    }
    var pJson = {
        phb: gridSel.phb
    };
    var retJson = $.cm(
        {
            ClassName: 'PHA.IP.Data.Api',
            MethodName: 'HandleInAll',
            pClassName: 'PHA.IP.BoxQuery.Save',
            pMethodName: 'CancelHandler',
            pJsonStr: JSON.stringify([pJson])
        },
        false
    );
    if (retJson.success === 'N') {
        // var msg = PHAIP_COM.DataApi.Msg(retJson);
        var msg = retJson.message;
        PHA.Alert('提示', msg, 'warning');
    } else {
        $('#gridBox').datagrid('reload');
    }
}

function Print(){
    var gridSel = $('#gridBox').datagrid('getSelected');
    if (gridSel === null) {
        PHA.Popover({
            msg: '请先选中需要打印的记录',
            type: 'alert'
        });
        return;
    }

    PHA_IP_MOBPRINT.Box([gridSel.phb], $g("补"));

}
function Clean(){
	PHA.DomData('.js-con-data', {
        doType: 'clear'
    });
    $('#gridWard').datagrid('clear');
    $('#gridBox').datagrid('clear');
    PHA.SetVals(PHA_IP_BOXQUERY.DefaultData);
}