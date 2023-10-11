/**
 * 模块:住院药房
 * 子模块:发药统计
 * createdate:2016-12-14
 * creator:dinghongying
 */
$(function () {
    /* 初始化插件 start*/
    var daterangeoptions = {
        timePicker: true,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + ' HH:mm:ss'
        }
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
    $('#date-start')
        .data('daterangepicker')
        .setStartDate(FormatDateT('T') + ' ' + '00:00:00');
    $('#date-start')
        .data('daterangepicker')
        .setEndDate(FormatDateT('T') + ' ' + '00:00:00');
    $('#date-end')
        .data('daterangepicker')
        .setStartDate(FormatDateT('T') + ' ' + '23:59:59');
    $('#date-end')
        .data('daterangepicker')
        .setEndDate(FormatDateT('T') + ' ' + '23:59:59');
    //屏蔽所有回车事件
    $('input[type=text]').on('keypress', function (e) {
        if (window.event.keyCode == '13') {
            return false;
        }
    });
    /*
    $("button[type=submit]").on("keypress",function(e){
    	if(window.event.keyCode == "13"){
    		return false;
    	}
    })
    */
    InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitPhaLoc();
    InitDispType(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitStkGrp(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitSeekType();
    InitDispWardList();
    InitDispStatList();
    /* 绑定按钮事件 start*/
    $('#btn-find').on('click', Query);
    $('#btn-findselect').on('click', QuerySub);
    $('#btn-print').on('click', BPrintHandler);
    $('#btn-clear').on('click', ClearConditions);
    /* 绑定按钮事件 end*/
    $('#grid-dispstattotal').closest('.panel-body').height(GridCanUseHeight(1));
    $('#grid-dispstatdetail').closest('.panel-body').height(GridCanUseHeight(1));
});

//初始化药品选择
function InitThisLocInci(locrowid) {
    var locincioptions = {
        id: '#sel-locinci',
        locid: locrowid,
        width: '390px'
    };
    InitLocInci(locincioptions);
}

//初始化药房
function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetStockPhlocDs&style=select2&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: false
    };
    $('#sel-phaloc').dhcphaSelect(selectoption);
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>';
    $('#sel-phaloc').append(select2option); //设默认值,没想到好办法,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        InitThisLocInci($(this).val());
        InitDispType($(this).val());
        InitStkGrp($(this).val());
    });
}

//初始化发药类别
function InitDispType(locrowid) {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetLocDispTypeDs&style=select2&locId=' + locrowid,
        allowClear: true,
        minimumResultsForSearch: Infinity
    };
    $('#sel-disptype').dhcphaSelect(selectoption);
}

//初始化类组
function InitStkGrp(locrowid) {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + '?action=GetLocStkGrpDs&style=select2&locId=' + locrowid,
        allowClear: true,
        minimumResultsForSearch: Infinity
    };
    $('#sel-stkgrp').dhcphaSelect(selectoption);
}

//初始化查询方式
function InitSeekType() {
    var data = [
        {
            id: 1,
            text: '按病区'
        },
        {
            id: 0,
            text: '按临床科室'
        }
    ];
    var selectoption = {
        data: data,
        width: 150,
        allowClear: false,
        minimumResultsForSearch: Infinity
    };
    $('#sel-seektype').dhcphaSelect(selectoption);
    $('#sel-seektype').on('select2:select', function (event) {
        var seekVal = $('#sel-seektype').val();
        var seekTitle = seekVal == '1' ? '病区列表' : '临床科室列表';
        $('#locPanelTitle').text(seekTitle);
        Query();
    });
}

//初始化发药统计列表
function InitDispWardList() {
    //定义columns
    var columns = [
        [
            {
                field: 'ProcessID',
                title: 'ProcessID',
                width: 80,
                hidden: true
            },
            {
                field: 'AdmLocRowid',
                title: 'AdmLocRowid',
                width: 80,
                hidden: true
            },
            {
                field: 'TSelect',
                title: '',
                checkbox: true
            },
            {
                field: 'AdmLocDesc',
                title: '科室',
                width: 250,
                sortable: true
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: true,
        pagination: false,
        singleSelect: true,
        checkOnSelect: true,
        selectOnCheck: false,
        onClickRow: function (rowIndex, rowData) {
            QuerySub();
        }
    };
    //定义datagrid
    $('#grid-dispstattotal').dhcphaEasyUIGrid(dataGridOption);
}

//初始化发药统计药品信息列表
function InitDispStatList() {
    var columns = [
        [
            {
                field: 'PID',
                title: 'PID',
                width: 50,
                hidden: true
            },
            {
                field: 'AdmLocID',
                title: 'AdmLocID',
                width: 50,
                hidden: true
            },
            {
                field: 'Tinci',
                title: 'Tinci',
                width: 100,
                hidden: true
            },
            {
                field: 'DispItmCode',
                title: '药品代码',
                width: 75,
                sortable: true
            },
            {
                field: 'DispItmDesc',
                title: '药品名称',
                width: 220
            },
            {
                field: 'DispQty',
                title: '发药数量',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'RetQty',
                title: '退药数量',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'Total',
                title: '合计数量',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'Uom',
                title: '单位',
                width: 60
            },
            {
                field: 'TPhciPrice',
                title: '单价',
                width: 75,
                align: 'right',
                sortable: true
            },
            {
                field: 'Amount',
                title: '金额',
                width: 100,
                align: 'right',
                sortable: true
            },
            {
                field: 'TBarCode',
                title: '规格',
                width: 80
            },
            {
                field: 'TManf',
                title: '生产企业',
                width: 120
            },
            {
                field: 'TPhcfDesc',
                title: '剂型',
                width: 100
            },
            {
                field: 'Tward',
                title: '病区/科室',
                width: 150
            },
            {
                field: 'Tgeneric',
                title: '通用名',
                width: 100,
                hidden: true
            },
            {
                field: 'TTotalUom',
                title: '数量(单位)',
                width: 100,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: false
    };
    //定义datagrid
    $('#grid-dispstatdetail').dhcphaEasyUIGrid(dataGridOption);
}

///查询
function Query() {
    var startdatetime = $('#date-start').val();
    var enddatetime = $('#date-end').val();
    var startdate = startdatetime.split(' ')[0];
    var starttime = startdatetime.split(' ')[1];
    var enddate = enddatetime.split(' ')[0];
    var endtime = enddatetime.split(' ')[1];
    var phaLoc = $('#sel-phaloc').val();
    if (phaLoc == null) {
        dhcphaMsgBox.alert('请选择科室!');
        return;
    }
    var inciRowId = $('#sel-locinci').val();
    if (inciRowId == null) {
        inciRowId = '';
    }
    var dispType = $('#sel-disptype').val();
    if (dispType == null) {
        dispType = '';
    }
    var stkGrp = $('#sel-stkgrp').val();
    if (stkGrp == null) {
        stkGrp = '';
    }
    var statFlag = '';
    var seekType = $('#sel-seektype').val();
    if (seekType == '请选择' || seekType == 0) {
        statFlag = '0';
    }
    if (seekType == 1) {
        statFlag = '1';
    }
    var phcCat = '',
        includeDisp = '',
        patNo = '';
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params =
        startdate +
        tmpSplit +
        enddate +
        tmpSplit +
        phaLoc +
        tmpSplit +
        dispType +
        tmpSplit +
        starttime +
        tmpSplit +
        endtime +
        tmpSplit +
        inciRowId +
        tmpSplit +
        statFlag +
        tmpSplit +
        phcCat +
        tmpSplit +
        includeDisp +
        tmpSplit +
        patNo +
        tmpSplit +
        stkGrp;
    KillDispStatTMP();
    $('#grid-dispstattotal').datagrid({
        queryParams: {
            ClassName: 'web.DHCSTPCHCOLLS',
            QueryName: 'DispStat',
            Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
        }
    });
    $('#grid-dispstatdetail').clearEasyUIGrid();
}

///查询明细
function QuerySub() {
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var selecteddata = $('#grid-dispstattotal').datagrid('getSelected');
    if (selecteddata == null) {
        //return;
    }
    var checkedItems = $('#grid-dispstattotal').datagrid('getChecked');
    if (checkedItems == null || checkedItems == '') {
        dhcphaMsgBox.alert('请勾选需要统计的科室!');
        return;
    }
    var admLocStr = '',
        pid = '';
    $.each(checkedItems, function (index, item) {
        if (admLocStr == '') {
            admLocStr = item.AdmLocRowid;
        } else {
            admLocStr = admLocStr + '^' + item.AdmLocRowid;
        }
        pid = item.ProcessID;
    });
    var params = pid + tmpSplit + admLocStr;
    $('#grid-dispstatdetail').datagrid({
        queryParams: {
            ClassName: 'web.DHCSTPCHCOLLS',
            QueryName: 'DispStatItm',
            Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
        }
    });
}

///打印
function BPrintHandler() {
    //获取当前界面数据行数
    if ($('#grid-dispstattotal').datagrid('getData').rows.length == 0) {
        dhcphaMsgBox.alert('页面没有数据');
        return;
    }
    if ($('#grid-dispstattotal').datagrid('getChecked') == null) {
        dhcphaMsgBox.alert('请选择需要打印的科室!');
        return;
    }
    if ($('#grid-dispstatdetail').datagrid('getData').rows.length == 0) {
        dhcphaMsgBox.alert('页面没有数据');
        return;
    }
    // 需按病区拆分
    var DispQuerydgOption = $('#grid-dispstatdetail').datagrid('options');
    var DispQuerydgParams = DispQuerydgOption.queryParams.Params;
    var DispQuerydgUrl = DispQuerydgOption.url;
    var DispQuerydgClassName = DispQuerydgOption.queryParams.ClassName;
    var DispQuerydgQueryName = DispQuerydgOption.queryParams.QueryName;
    $.ajax({
        type: 'GET',
        url: DispQuerydgUrl + '?&page=1&rows=9999&ClassName=' + DispQuerydgClassName + '&QueryName=' + DispQuerydgQueryName + '&Params=' + DispQuerydgParams,
        async: false,
        dataType: 'json',
        success: function (dispquerydata) {
            // 按病区拆分
            var rows = dispquerydata.rows;
            var rowsLen = rows.length;
            if (rowsLen == 0) {
                return;
            }
            var wardRowsArr = [];
            for (var i = 0; i < rowsLen; i++) {
                var rowData = rows[i];
                var ward = rowData.Tward;
                if (ward == '') {
                    continue;
                }
                if (!wardRowsArr[ward]) {
                    wardRowsArr[ward] = [];
                }
                wardRowsArr[ward].push(rowData);
            }

            var paraData = GetXmlPrintPara();
            for (var wId in wardRowsArr) {
                var listData = wardRowsArr[wId];
                var paraWard = paraData.ward;
                if (paraWard.indexOf('病  区') >= 0) {
                    paraData.ward = '病  区:' + listData[0].Tward;
                } else if (paraWard.indexOf('科  室') >= 0) {
                    paraData.ward = '科  室:' + listData[0].Tward;
                }
                PRINTCOM.XML({
                    printBy: 'lodop',
                    XMLTemplate: 'PHAIPDispStat',
                    data: {
                        Para: paraData,
                        List: listData
                    },
                    listBorder: { style: 4, startX: 1, endX: 180 },
                    page: { rows: 28, x: 8, y: 8, fontname: '黑体', fontbold: 'false', fontsize: '12', format: '第{1}页/共{2}页' }
                });
            }
        }
    });
}

/*
 * @creator: Huxt 2019-12-24
 * @desc: 获取xml打印Para数据
 */
function GetXmlPrintPara() {
    var HospitalDesc = tkMakeServerCall('web.DHCSTKUTIL', 'GetHospName', session['LOGON.HOSPID']);
    var phaloc = $('#sel-phaloc').select2('data')[0].text;
    var seektype = $('#sel-seektype').select2('data')[0].text;
    if (seektype.indexOf('病区') >= 0) {
        phawardtitle = '病  区:';
    } else {
        phawardtitle = '科  室:';
    }
    var startdatetime = $('#date-start').val();
    var enddatetime = $('#date-end').val();
    var daterange = startdatetime + ' 至 ' + enddatetime;
    return {
        title: HospitalDesc + '发药统计',
        phaloc: phaloc,
        ward: phawardtitle,
        daterange: daterange,
        PrintDate: getPrintDateTime(),
        PrintUserName: session['LOGON.USERNAME']
    };
}

//清空
function ClearConditions() {
    var today = new Date();
    $('#date-start')
        .data('daterangepicker')
        .setStartDate(FormatDateT('T') + ' ' + '00:00:00');
    $('#date-start')
        .data('daterangepicker')
        .setEndDate(FormatDateT('T') + ' ' + '00:00:00');
    $('#date-end')
        .data('daterangepicker')
        .setStartDate(FormatDateT('T') + ' ' + '23:59:59');
    $('#date-end')
        .data('daterangepicker')
        .setEndDate(FormatDateT('T') + ' ' + '23:59:59');
    $('#sel-stkgrp').empty();
    $('#sel-locinci').empty();
    $('#sel-disptype').empty();
    KillDispStatTMP();
    $('#grid-dispstatdetail').clearEasyUIGrid();
    $('#grid-dispstattotal').clearEasyUIGrid();
    $('#grid-dispstattotal').datagrid('uncheckAll');
}
//清空临时global
function KillDispStatTMP() {
    var totalrowsdata = $('#grid-dispstattotal').datagrid('getRows');
    var totalrows = totalrowsdata.length;
    if (totalrows > 0) {
        var firstdata = $('#grid-dispstattotal').datagrid('getData').rows[0];
        var killret = tkMakeServerCall('web.DHCSTPCHCOLLS', 'ClearColl', firstdata['ProcessID']);
    }
}
window.onbeforeunload = function () {
    KillDispStatTMP(); //除非异常关闭清不掉
};
