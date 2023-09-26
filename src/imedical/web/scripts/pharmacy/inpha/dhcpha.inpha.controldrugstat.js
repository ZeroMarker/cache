/**
 * 模块:住院药房
 * 子模块:侧菜单-管制药品统计
 * createdate:2016-12-15
 * creator:dinghongying
 */
$(function () {
    /* 初始化插件 start*/
    var daterangeoptions = {
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + ' HH:mm:ss'
        }
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
    //屏蔽所有回车事件
    $('input[type=text]').on('keypress', function (e) {
        if (window.event.keyCode == '13') {
            return false;
        }
    });
    InitPhaLoc();
    InitLoc();
    InitStkCat();
    InitPoisonCat();
    InitControlDrugList();
    /* 绑定按钮事件 start*/
    $('#btn-find').on('click', Query);
    $('#btn-print').on('click', BPrintHandler);
    $('#btn-clear').on('click', ClearConditions);
    /* 绑定按钮事件 end*/ $('#grid-controldrug').closest('.panel-body').height(GridCanUseHeight(1));
});

//初始化发药科室
function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetStockPhlocDs&style=select2&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: false
    };
    $('#sel-phaloc').dhcphaSelect(selectoption);
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>';
    $('#sel-phaloc').append(select2option); //设默认值,没想到好办法,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        //alert(event)
    });
}

//初始化就诊科室
function InitLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=GetCtLocDs&style=select2&custtype=DocLoc',
        allowClear: true,
        width: 150
    };
    $('#sel-admloc').dhcphaSelect(selectoption);
    $('#sel-admloc').on('select2:select', function (event) {
        //alert(event)
    });
}
//初始化库存分类
function InitStkCat() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + '?action=GetStkCatDs&style=select2',
        allowClear: true,
        width: 270
    };
    $('#sel-stk').dhcphaSelect(selectoption);
}

//初始化管制分类
function InitPoisonCat() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + '?action=GetPoisonCatDs&style=select2',
        allowClear: true,
        width: 150,
        minimumResultsForSearch: Infinity
    };
    $('#sel-poison').dhcphaSelect(selectoption);
}

//初始化管制药品统计列表
function InitControlDrugList() {
    //定义columns
    var columns = [
        [
            { field: 'TDate', title: '日期', width: 100, align: 'center' },
            { field: 'TPrescNo', title: '处方号', width: 120, align: 'center' },
            { field: 'TRegNo', title: '登记号', width: 100, align: 'center' },
            { field: 'TPaName', title: '患者姓名', width: 100 },
            { field: 'TSex', title: '性别', width: 80, align: 'center' },
            { field: 'TAge', title: '年龄', width: 80 },
            { field: 'TIDNO', title: '患者（代办人）证件号码', width: 120 },
            { field: 'TPRNO', title: '病历号', width: 100 },
            { field: 'TDiagNose', title: '诊断', width: 200 },
            { field: 'TDrugDesc', title: '药品名称', width: 120 },
            { field: 'TQty', title: '数量', width: 80, align: 'right' },
            { field: 'TDoctor', title: '医生', width: 80 },
            { field: 'TDispUser', title: '发药人', width: 80 },
            { field: 'TAuditor', title: '复核人', width: 80 },
            { field: 'TDrugBatchNo', title: '药品批号', width: 120 },
            { field: 'TAdmLoc', title: '科别', width: 80 },
            { field: 'TAmt', title: '金额', width: 80, align: 'right' },
            { field: 'TFreq', title: '频率', width: 80 },
            { field: 'TDoseQty', title: '剂量', width: 80 },
            { field: 'TRem', title: '备注', width: 80 },
            { field: 'TInstruction', title: '用法', width: 80 },
            { field: 'Tuom', title: '单位', width: 80, hidden: true },
            { field: 'TBarCode', title: '规格', width: 80 },
            { field: 'Tpid', title: 'Tpid', width: 10, hidden: true }
        ]
    ];

    var dataGridOption = {
        url: '',
        columns: columns,
        fitColumns: false
    };
    //定义datagrid
    $('#grid-controldrug').dhcphaEasyUIGrid(dataGridOption);
}

///查询
function Query() {
    var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
    var phaLoc = $('#sel-phaloc').val();
    if (phaLoc == null) {
        dhcphaMsgBox.alert('请选择科室!');
        return;
    }
    var locId = $('#sel-admloc').val();
    if (locId == null) {
        locId = '';
    }
    var stkCatId = $('#sel-stk').val();
    if (stkCatId == null) {
        stkCatId = '';
    }
    var poisonCatId = $('#sel-poison').val();
    if (poisonCatId == null) {
        dhcphaMsgBox.alert('管制分类为必选项！');
        return;
    }
    var chkdocloc = '';
    if ($('#chk-docloc').is(':checked')) {
        chkdocloc = 'on';
    }
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = phaLoc + tmpSplit + startdate + tmpSplit + enddate + tmpSplit + stkCatId + tmpSplit + poisonCatId + tmpSplit + chkdocloc + tmpSplit + locId;

    $('#grid-controldrug').datagrid('options').url = DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL;
    $('#grid-controldrug').datagrid({
        queryParams: {
            ClassName: 'web.DHCSTDISPSTATDM',
            QueryName: 'DispStatDM',
            Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
        }
    });
}

///打印
function BPrintHandler() {
    //获取当前界面数据行数
    if ($('#grid-controldrug').datagrid('getData').rows.length == 0) {
        dhcphaMsgBox.alert('页面没有数据');
        return;
    }
    //获取界面数据
    var seleclocdata = $('#sel-phaloc').select2('data')[0];
    var phLocDesc = seleclocdata.text;
    var daterange = $('#date-start').val().split(' ')[0] + ' 至 ' + $('#date-end').val().split(' ')[0];
    var Para = {
        phLocDesc: phLocDesc,
        CountDate: daterange,
        PrintUserName: DHCPHA_CONSTANT.SESSION.GUSER_NAME
    };
    //打印公共 Huxt 2019-12-25
    PRINTCOM.XML({
        printBy: 'lodop',
        XMLTemplate: 'PHAIPControlDrug',
        data: {
            Para: Para,
            Grid: { type: 'easyui', grid: 'grid-controldrug' }
        },
        preview: false,
        listBorder: { style: 4, startX: 1, endX: 275 },
        page: { rows: 15, x: 245, y: 2, fontname: '黑体', fontbold: 'true', fontsize: '12', format: '页码：{1}/{2}' }
    });
}

//清空
function ClearConditions() {
    var today = new Date();
    $('#date-start').data('daterangepicker').setStartDate(new Date());
    $('#date-end').data('daterangepicker').setEndDate(new Date());
    $('#sel-admloc').empty();
    $('#sel-stk').empty();
    $('#sel-poison').empty();
    $('#chk-docloc').iCheck('uncheck');
    $('#grid-controldrug').clearEasyUIGrid();
}
