/**
 * 模块:     住院基数药管理
 * 编写日期: 2018-06-20
 * 编写人:   yunhaibao
 */
$g('未完成');
$g('大输液补货');
$g('精神毒麻补货');
$g('基数补货');
$g('未完成');
$g('已接收');
$g('已出库');
$g('部分接收');
$g('出库审核不通过');
$g('拒绝接收');
$g('已完成等待出库');
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
    InitDict();
    InitGridTransReq();
    InitGridTransReqItm();
    $('#btnFind').on('click', Query);

    $('#btnEdit').on('click', function () {
        EditReq();
    });
    $('#btnAddByDSY').on('click', function () {
        NewReq();
    });
    $('#btnAddByJSDM').on('click', function () {
        NewReqByConsume('JSDM');
    });
    $('#btnAddByBASE').on('click', function () {
        NewReqByConsume('BASE');
    });
    //window.resizeTo(screen.availWidth, (screen.availHeight));
});

function InitDict() {
    DHCPHA_HUI_COM.ComboBox.Init(
        { Id: 'cmbReqLoc', Type: 'CtLoc' },
        {
            onLoadSuccess: function () {
                $('#cmbReqLoc').combobox('setValue', SessionLoc);
                $('#cmbReqLoc').combobox('readonly');
            },
            width: 200
        }
    );
    DHCPHA_HUI_COM.ComboBox.Init(
        { Id: 'cmbProLoc', Type: 'CtLoc' },
        {
            width: 200,
            onBeforeLoad: function (param) {
                param.inputStr = 'D';
                param.filterText = param.q;
                param.hosp = session['LOGON.HOSPID'];
            }
        }
    );
    $('#dateStart').datebox('setValue', DHCPHA_TOOLS.Today());
    $('#dateEnd').datebox('setValue', DHCPHA_TOOLS.Today());
}
// 申请单列表
function InitGridTransReq() {
    var columns = [
        [
            { field: 'reqId', title: 'reqId', width: 200, halign: 'center', hidden: true },
            {
                field: 'reqStat',
                title: '状态',
                width: 120,
                styler: function (value, row, index) {
                    value = value.replace('部分', '');
                    if (value == '未完成') {
                        return 'background-color:white;color:black;font-weight:normal;';
                    } else if (value == '已完成等待出库') {
                        return 'background-color:#e2ffde;color:#3c763d;font-weight:normal;';
                    } else if (value == '已出库') {
                        return 'background-color:#e3f7ff;color:#1278b8;font-weight:normal;';
                    } else if (value == '已接收') {
                        return 'background-color:#fff3dd;color:#ff7e00;font-weight:normal;';
                    } else if (value == '出库审核不通过') {
                        return 'background-color:#ffe3e3;color:#ff3d2c;font-weight:normal;';
                    }
                    return '';
                }
            },
            { field: 'proLocDesc', title: '供给科室', width: 150 },
            { field: 'reqNo', title: '请求单号', width: 150 },
            { field: 'reqUserName', title: '请求人', width: 75 },
            { field: 'reqDateTime', title: '请求时间', width: 150 },
            { field: 'reqTypeDesc', title: '请求类型', width: 100 },
            { field: 'fromDateTime', title: '开始时间', width: 150 },
            { field: 'toDateTime', title: '结束时间', width: 150 },
            { field: 'printFlag', title: '已打印', width: 60 },
            { field: 'printDateTime', title: '打印时间', width: 150 },
            { field: 'collUserName', title: '出库操作人', width: 90 },
            { field: 'collDateTime', title: '出库操作时间', width: 150 },
            { field: 'dispUserName', title: '接收操作人', width: 90 },
            { field: 'dispDateTime', title: '接收操作时间', width: 150 },
            { field: 'reqLocDesc', title: '请求科室', width: 150 },
            { field: 'reqType', title: '请求类型Id', width: 100, hidden: true }
        ]
    ];
    var dataGridOption = {
        fit: true,
        border: false,
        singleSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        toolbar: [],
        onSelect: function (rowIndex, rowData) {
            if (rowData) {
                QueryDetail();
            }
        },
        onUnselect: function (rowIndex, rowData) {
            if (rowData) {
                QueryDetail();
            }
        },
        onLoadSuccess: function () {
            // $("#gridTransReqItm").datagrid("clear");
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridTransReq', dataGridOption);
}
// 申请单明细列表
function InitGridTransReqItm() {
    var columns = [
        [
            { field: 'reqItmId', title: 'reqItmId', width: 200, hidden: true },
            { field: 'incCode', title: '药品代码', width: 100 },
            { field: 'incDesc', title: '药品名称', width: 300 },
            { field: 'reqQty', title: '数量', width: 75, align: 'right' },
            { field: 'reqUomDesc', title: '单位', width: 100 }
        ]
    ];
    var dataGridOption = {
        fit: true,
        border: false,
        singleSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        toolbar: [],
        onSelect: function (rowIndex, rowData) {},
        onUnselect: function (rowIndex, rowData) {},
        onLoadSuccess: function () {}
    };
    DHCPHA_HUI_COM.Grid.Init('gridTransReqItm', dataGridOption);
}
// 获取参数
function QueryParams() {
    var stDate = $('#dateStart').datebox('getValue');
    var edDate = $('#dateEnd').datebox('getValue');
    var reqLocId = $('#cmbReqLoc').combobox('getValue');
    var proLocId = $('#cmbProLoc').combobox('getValue');
    return stDate + '^' + edDate + '^' + reqLocId + '^' + proLocId;
}
// 查询
function Query() {
    var params = QueryParams();

    $('#gridTransReq').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCINPHA.WardBaseDrug',
            QueryName: 'QueryTransReq',
            inputStr: params
        }
    });
}

// 查询明细
function QueryDetail() {
    var gridSelect = $('#gridTransReq').datagrid('getSelected');
    var reqId = gridSelect.reqId;
    $('#gridTransReqItm').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCINPHA.WardBaseDrug',
            QueryName: 'QueryTransReqItm',
            inputStr: reqId
        }
    });
}

/// 请求单编辑
function EditReq() {
    // 判断是否为完成状态
    var ifFinish = '';
    if (ifFinish == 'Y') {
        $.messager.alert('提示', '该请求单已经完成,无法编辑', 'warning');
        return;
    }
    var gridSelect = $('#gridTransReq').datagrid('getSelected');
    if ((gridSelect == null) | (gridSelect == '')) {
        $.messager.alert('提示', '请先选择需要编辑的请求单', 'warning');
        return;
    }
    var reqType = gridSelect.reqType || '';
    if (reqType == '2') {
        $.messager.alert('提示', '精神毒麻补货请求单不允许编辑', 'warning');
        return;
    }
    var reqId = gridSelect.reqId;

    var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=dhcpha.transferreq&Rowid=' + reqId;
    var lnk = 'dhcpha.inpha.hisui.createtransreq.csp?reqId=' + reqId;
    var editType = '';
    if (reqType == 3) {
        // 大输液补货
        var editType = 'ADD';
    }
    websys_createWindow(lnk, '请求单编辑', 'width=95%,height=75%');
    //window.open(lnk,"_target","width="+(document.body.clientWidth-6)+",height="+(document.body.clientHeight-40)+ ",menubar=no,status=yes,toolbar=no,resizable=yes,top=100,left=3") ;
}

// 新单
function NewReq() {
    var lnk = 'dhcpha.inpha.hisui.createtransreq.csp?reqId=' + '' + '&reqType=3';
    websys_createWindow(lnk, '补货', 'width=95%,height=75%');
    //window.open(lnk,"_target","width="+(document.body.clientWidth-6)+",height="+(document.body.clientHeight-40)+ ",menubar=no,status=yes,toolbar=no,resizable=yes,top=100,left=3") ;
}

// 依据消耗
function NewReqByConsume(type) {
    var reqType = '';
    if (type == 'JSDM') {
        reqType = 2;
    } else if ((type = 'BASE')) {
        reqType = 1;
    }
    if (reqType == '') {
        $.messager.alert('提示', '该类型无法依据消耗补货', 'warning');
        return;
    }
    var lnk = 'dhcpha.inpha.hisui.createtransreqbyconsume.csp?reqType=' + reqType;
    websys_createWindow(lnk, '补货', 'width=95%,height=75%');
    //window.open(lnk, "_blank", "width=1100,height=650,menubar=no,status=yes,toolbar=no,scrollbars=yes,resizable=yes");
    //window.open(lnk,"_target","width="+(document.body.clientWidth-6)+",height="+(document.body.clientHeight-40)+ ",menubar=no,status=yes,toolbar=no,resizable=yes,top=100,left=3") ;
}
