/*
 *模块:			移动药房
 *子模块:		移动药房-请领单查询
 *createdate:	2018-09-11
 *creator:		hulihua
 */
$(function () {
    /* 初始化插件 start*/
    var daterangeoptions = {
        singleDatePicker: true
    }
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    InitPhaLoc(); //药房科室
    SetLogPhaLoc(); //给药房科室赋默认值！
    InitPhaWard(); //病区
    SetLogWardLoc(); //给病区赋初值！
    InitThisLocInci($("#sel-phaloc").val());
    InitInphReqType(); //请领类型
    InitInphReqStatue(); //请领状态
    InitThisLocUser(gLocId); //请领人
    InitBoxStatus(); //物流箱状态
    InitRequsetList();
    InitRequsetDetailList();
    /* 表单元素事件 start*/
    //请领单号回车事件
    $('#txt-inphreqno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var inphreqno = $.trim($("#txt-inphreqno").val());
            if (inphreqno != "") {
                Query();
            }
        }
    });
    //备药单号回车事件
    $('#txt-inphdrawno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var inphdrawno = $.trim($("#txt-inphdrawno").val());
            if (inphdrawno != "") {
                Query();
            }
        }
    });
    //固化单号回车事件
    $('#txt-connectno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var connectno = $.trim($("#txt-connectno").val());
            if (connectno != "") {
                Query();
            }
        }
    });
    //登记号回车事件
    $('#txt-patno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#txt-patno").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                Query();
            }
        }
    });
    //屏蔽所有回车事件
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })

    //屏蔽所有按钮事件
    $("button").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    /* 表单元素事件 end*/

    //联动请领人
    $('#sel-phaward').on('select2:select', function (event) {
        InitThisLocUser($("#sel-phaward").val());
    })
})

window.onload = function () {
    setTimeout("Query()", 500);
}

//初始化请领人
function InitThisLocUser(locrowid) {
    var locincioptions = {
        id: "#sel-inphrequser",
        locid: locrowid,
        placeholder: "请领人...",
        width: '12em'
    }
    InitLocAllUser(locincioptions)
}

//初始化药品选择
function InitThisLocInci(locrowid) {
    var locincioptions = {
        id: "#sel-locinci",
        locid: locrowid,
        width: "270px"
    }
    InitLocInci(locincioptions)
}

//初始化物流箱状态
function InitBoxStatus() {
    var data = [{
            id: "",
            text: ''
        },
        {
            id: 10,
            text: '封箱完成打印装箱贴'
        },
        {
            id: 60,
            text: '物流交接完成'
        },
        {
            id: 70,
            text: '病区接收'
        }
    ];
    var selectoption = {
        data: data,
        width: '12em',
        allowClear: true,
        placeholder: "物流箱状态...",
        minimumResultsForSearch: Infinity
    };
    $("#sel-boxstatus").dhcphaSelect(selectoption);
}

//初始化请领类型
function InitInphReqType() {
    var data = [{
            id: "",
            text: ''
        },
        {
            id: 1,
            text: '送药'
        },
        {
            id: 2,
            text: '取药'
        },
        {
            id: 3,
            text: '毒性'
        },
        {
            id: 4,
            text: '麻醉'
        },
        {
            id: 5,
            text: '精一'
        },
        {
            id: 6,
            text: '精二'
        }
    ];
    var selectoption = {
        data: data,
        width: '10.7em',
        allowClear: true,
        minimumResultsForSearch: Infinity
    };
    $("#sel-inphreqtype").dhcphaSelect(selectoption);
}

//初始化请领单状态
function InitInphReqStatue() {
    var data = [{
            id: "",
            text: ''
        },
        {
            id: '05',
            text: '撤销申请'
        },
        {
            id: '10',
            text: '病区申请'
        },
        {
            id: '20',
            text: '药房备药中'
        },
        {
            id: '30',
            text: '备药完成'
        },
        {
            id: '40',
            text: '药房核对中'
        },
        {
            id: '50',
            text: '核对装箱完成'
        },
        {
            id: '60',
            text: '物流交接完成'
        },
        {
            id: '70',
            text: '病区接收'
        },
        {
            id: '80',
            text: '病区核对'
        }
    ];
    var selectoption = {
        data: data,
        width: '180px',
        allowClear: true,
        placeholder: "请领单状态...",
        minimumResultsForSearch: Infinity
    };
    $("#sel-inphreqstatue").dhcphaSelect(selectoption);
}

//药房科室赋默认值！
function SetLogPhaLoc() {
    var LogLocid = ""
    if (gHospID == "1") {
        LogLocid = "102"; //中医院院区默认为中心药房！
    }
    if ((LogLocid == "") || (LogLocid == gLocId)) {
        return;
    }
    var LogLocArr = tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod", "GetLocInfoById", LogLocid);
    var LogLocDesc = LogLocArr.split("^")[1];
    var select2option = '<option value=' + "'" + LogLocid + "'" + 'selected>' + LogLocDesc + '</option>'
    $("#sel-phaloc").append(select2option);
}

//病区赋默认值！
function SetLogWardLoc() {
    if ((gWardID == "") || (gWardID == null)) {
        return;
    }
    var select2option = '<option value=' + "'" + gLocId + "'" + 'selected>' + gLocDesc + '</option>'
    $("#sel-phaward").append(select2option);
}

//初始化请领单列表table
function InitRequsetList() {
    var columns = [{
            name: "TInphrNo",
            index: "TInphrNo",
            header: '请领单单号',
            width: 80
        },
        {
            name: "TWardLocDesc",
            index: "TWardLocDesc",
            header: '病区',
            width: 160,
            align: 'left'
        },
        {
            name: "TDispLocDesc",
            index: "TDispLocDesc",
            header: '发药科室',
            width: 120
        },
        {
            name: "TAlertDarwUserDesc",
            index: "TAlertDarwUserDesc",
            header: '提示药房备药人',
            width: 130
        },
        {
            name: "TAlertDrawDateTime",
            index: "TAlertDrawDateTime",
            header: '提示药房备药时间',
            width: 140
        },
        {
            name: "TReqUserDesc",
            index: "TReqUserDesc",
            header: '请领人',
            width: 130
        },
        {
            name: "TReqDateTime",
            index: "TReqDateTime",
            header: '请领时间',
            width: 140
        },
        {
            name: "TReqTypeDesc",
            index: "TReqTypeDesc",
            header: '请领类型',
            width: 70
        },
        {
            name: "TPhrStatusDesc",
            index: "TPhrStatusDesc",
            header: '请领单状态',
            width: 100
        },
        {
            name: "TBoxStatus",
            index: "TBoxStatus",
            header: '物流箱状态',
            width: 100
        },
        {
            name: "TPhDrawNo",
            index: "TPhDrawNo",
            header: '备药单号',
            width: 120
        },
        {
            name: "TCancelUserDesc",
            index: "TCancelUserDesc",
            header: '撤销人',
            width: 130
        },
        {
            name: "TCancelDateTime",
            index: "TCancelDateTime",
            header: '撤销时间',
            width: 140
        },
        {
            name: "TConnectNo",
            index: "TConnectNo",
            header: '固化单号',
            width: 120,
            align: 'left'
        },
        {
            name: "TPHRRowID",
            index: "TPHRRowID",
            header: '请领单ID',
            width: 10,
            hidden: true
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.MTInPhReq.InPhReqQuery&MethodName=jsQuaryInphreqInfo', //查询后台	
        height: GridCanUseHeight(2) * 0.5 - 7,
        fit: true,
        multiselect: false,
        shrinkToFit: false,
        rownumbers: true,
        autoScroll: true,
        datatype: "local",
        pager: "#jqGridPager", //分页控件的id 
        onSelectRow: function (id) {
            QuerySub(id);
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#ifrm-presc").attr("src", "");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }
    };
    $('#grid-requsttotal').dhcphaJqGrid(jqOptions);
}

//初始化请领单明细列表table
function InitRequsetDetailList() {
    //定义columns
    var columns = [{
            header: 'TphmbiId',
            index: 'TphmbiId',
            name: 'TphmbiId',
            width: 5,
            hidden: true
        },
        {
            header: '药品代码',
            index: 'TInciCode',
            name: 'TInciCode',
            width: 60
        },
        {
            header: '药品描述',
            index: 'TInciDesc',
            name: 'TInciDesc',
            width: 200,
            align: 'left'
        },
        {
            header: '数量',
            index: 'TQty',
            name: 'TQty',
            width: 40
        },
        {
            header: '单位',
            index: 'TUomDesc',
            name: 'TUomDesc',
            width: 60
        },
        {
            header: '请领单状态',
            index: 'TItmstatusDesc',
            name: 'TItmstatusDesc',
            width: 80
        },
        {
            header: '撤销人',
            index: 'TCancelUserDesc',
            name: 'TCancelUserDesc',
            width: 100
        },
        {
            header: '撤销日期',
            index: 'TCancelDateTime',
            name: 'TCancelDateTime',
            width: 130,
            align: 'left'
        },
        {
            header: '打包子表ID',
            index: 'TDspBatchId',
            name: 'TDspBatchId',
            width: 80
        },
        {
            header: '请领子表ID',
            index: 'TInphreqSubID',
            name: 'TInphreqSubID',
            width: 80
        }
    ];
    var dataGridOption = {
        colModel: columns, //列
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=web.DHCINPHA.MTInPhReq.InPhReqQuery&MethodName=jsQuaryInphreqItmInfo',
        height: GridCanUseHeight(2) * 0.5 ,
        shrinkToFit: false,
        rownumbers: true,
        autoScroll: true
    }
    //定义datagrid	
    $('#grid-requstdetail').dhcphaJqGrid(dataGridOption);
}

///查询
function Query() {
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    var inciRowId = $("#sel-locinci").val();
    if (inciRowId == null) {
        inciRowId = ""
    }
    var phaLoc = $("#sel-phaloc").val();
    if (phaLoc == null) {
        dhcphaMsgBox.alert("请选择药房科室!");
        return;
    }
    var wardLoc = $("#sel-phaward").val();
    if (wardLoc == null) {
        wardLoc = "";
    }
    var inphrequser = $.trim($("#sel-inphrequser").val());
    var inphreqtype = $.trim($("#sel-inphreqtype").val());
    var inphreqstatue = $.trim($("#sel-inphreqstatue").val());
    var boxstatus = $.trim($("#sel-boxstatus").val());
    var inphreqno = $.trim($("#txt-inphreqno").val());
    var drawno = $.trim($("#txt-inphdrawno").val());
    var connectno = $.trim($("#txt-connectno").val());
    var patno = $.trim($("#txt-patno").val());

    var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaLoc + tmpSplit + wardLoc + tmpSplit + inphreqtype + tmpSplit +
        inphreqstatue + tmpSplit + drawno + tmpSplit + connectno + tmpSplit + inphrequser + tmpSplit + boxstatus + tmpSplit +
        inphreqno + tmpSplit + inciRowId + tmpSplit + patno;
    $("#grid-requsttotal").setGridParam({
        datatype: 'json',
        page: 1,
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
    $("#grid-requstdetail").jqGrid("clearGridData");
}

///查询明细
function QuerySub(selectid) {
    var selrowdata = $("#grid-requsttotal").jqGrid('getRowData', selectid);
    var phrid = selrowdata.TPHRRowID;
    if ((phrid == null) || (phrid == "")) {
        return;
    }
    var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
    var params = phrid;
    $("#grid-requstdetail").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
}
//清空
function ClearConditions() {
    var today = new Date();
    $("#date-start").data('daterangepicker').setStartDate(today);
    $("#date-start").data('daterangepicker').setEndDate(today);
    $("#date-end").data('daterangepicker').setStartDate(today);
    $("#date-end").data('daterangepicker').setEndDate(today);
    $("#sel-locinci").empty();
    $("#sel-phaward").empty();
    $("#sel-inphrequser").empty();
    $("#sel-inphreqtype").empty();
    InitInphReqType();
    $("#sel-inphreqstatue").empty();
    InitInphReqStatue();
    $("#sel-boxstatus").empty();
    InitBoxStatus();
    $('#txt-inphreqno').val("");
    $('#txt-connectno').val("");
    $('#txt-inphdrawno').val("");
    $('#txt-patno').val("");
    $("#grid-requstdetail").jqGrid("clearGridData");
    $("#grid-requstdetail").jqGrid("clearGridData");
}