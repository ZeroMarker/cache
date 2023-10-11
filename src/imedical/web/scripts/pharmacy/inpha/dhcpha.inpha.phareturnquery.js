/*
 *模块:住院药房
 *子模块:业务查询-退药单查询
 *createdate:2016-12-12
 *creator:dinghongying
 */
$(function () {
    /* 初始化插件 start*/
    var daterangeoptions = {
        singleDatePicker: true
    }
    $("#date-end").dhcphaDateRange(daterangeoptions);
    $("#date-start").dhcphaDateRange(daterangeoptions);
    //屏蔽所有回车事件
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    InitPhaLoc();
    InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitRetType();
    InitWardList();
    InitReturnList();
    InitReturnDetailList();
    /* 绑定按钮事件 start*/
    $("#btn-find").on("click", Query);
    $("#btn-print").on('click', BtnPrintHandler);
    $("#btn-clear").on("click", ClearConditions);
    /* 绑定按钮事件 end*/
    /*药房下拉框监听事件,当药房变化时,初始化药品名称 add by qhj*/
    $("#sel-phaloc").on('change', function () {
        var phaloc = $("#sel-phaloc").val();
        InitThisLocInci(phaloc);
    });
    ResizePhaReturnQuery()
})
//初始化药品选择
function InitThisLocInci(phaloc) {
    var locincioptions = {
        id: "#sel-locinci",
        locid: phaloc,
       	width: '13em'
    }
    InitLocInci(locincioptions)
}
//初始化药房
function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetStockPhlocDs&style=select2&groupId=" +
            DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: false,
        placeholder: "药房名称..."
    }
    $("#sel-phaloc").dhcphaSelect(selectoption);
	$('#sel-phaloc').on('select2:select', function (event) {
		InitPhaWard(event.params.data.id)
    });
    if (DHCPHA_CONSTANT.DEFAULT.LOC.type == "D") {
        var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
        $("#sel-phaloc").append(select2option); //设默认值,没想到好办法,yunhaibao20160805
        $('#sel-phaloc').on('select2:select', function (event) {
            InitThisLocInci($(this).val());
        });
    }
}
//改为按接收科室配置取患者病区(可满足跨院区发药的情况)  by zhaoxinlong 2022.04.22
//初始化病区
function InitWardList() {
	if ((recLocId == undefined) || (recLocId == "undefined")) {
        recLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
    }
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetWardLocDsByRecLoc&style=select2"+"&reclocId="+reclocId,
        allowClear: true,
        width: '13em',
        placeholder: "病区..."
    }
    $("#sel-wardloc").dhcphaSelect(selectoption);

    if (DHCPHA_CONSTANT.DEFAULT.LOC.type == "W") {
        var SessionWard = session['LOGON.WARDID'] || "";
        if (SessionWard != "") {
            var select2option = '<option value=' + "'" + SessionWard + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
            $("#sel-wardloc").append(select2option);
        }
    }
}

function InitRetType() {
    var data = [{
            id: "",
            text: ''
        },{
            id: 1,
            text: '直接退药'
        }, {
            id: 2,
            text: '申请单退药'
        },{
            id: 3,
            text: '冲减退药'
        }
    ];
    var selectoption = {
        data: data,
        width: 125,
        allowClear: true,
        minimumResultsForSearch: Infinity,
        placeholder:"退药类型"
    };
    $("#sel-rettype").dhcphaSelect(selectoption);

}
//初始化退药单列表
function InitReturnList() {
    //定义columns
    var columns = [
        [   {
                field: 'tRetWay',
                title: '退药方式',
                width: 80
            },{
                field: "tPhaRetNo",
                title: '退药单号',
                width: 250
            },
            {
                field: 'tWard',
                title: '病区',
                width: 200
            },
            {
                field: 'tAdmLoc',
                title: '就诊科室',
                width: 80,
                hidden: true
            },
            {
                field: 'tReturnOper',
                title: '退药人',
                width: 90
            },
            {
                field: 'tReturnDate',
                title: '退药日期',
                width: 90
            },
            {
                field: 'tReturnTime',
                title: '退药时间',
                width: 70
            },
            {
                field: 'tReqNo',
                title: '申请单号',
                width: 250
            },
            {
                field: 'trquser',
                title: '申请人',
                width: 90
            },
            {
                field: 'tReqDate',
                title: '申请日期',
                width: 90
            },
            {
                field: 'tReqTime',
                title: '申请时间',
                width: 70
            },
            {
                field: 'tAckUser',
                title: '审核人',
                width: 90
            },
            {
                field: 'tAckDate',
                title: '审核日期',
                width: 90
            },
            {
                field: 'tAckTime',
                title: '审核时间',
                width: 70
            },            {
                field: 'tPhaRet',
                title: 'ID',
                width: 70,
				hidden:true
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: false,
        onSelect: function (rowIndex, rowData) {
            QuerySub();
        },
        onLoadSuccess: function () {
            if ($(this).datagrid("getRows").length > 0) {
                $(this).datagrid("selectRow", 0)
            }
        }
    }
    //定义datagrid	
    $('#grid-returntotal').dhcphaEasyUIGrid(dataGridOption);
}

//初始化退药单详细信息列表
function InitReturnDetailList() {
    //定义columns
    var columns = [
        [{
                field: "tPhaRetNo",
                title: '退药单号',
                width: 100,
                hidden: true
            },
            {
                field: 'tRegNo',
                title: '登记号',
                width: 100
            },
            {
                field: 'tName',
                title: '姓名',
                width: 90
            },
            {
                field: 'tWard',
                title: '病区',
                width: 150
            },
            {
                field: 'tBedNo',
                title: '床号',
                width: 75
            },
            {
                field: 'tAdmLoc',
                title: '就诊科室',
                width: 150
            },
            {
                field: 'tDoctor',
                title: '医生',
                width: 70
            },
            {
                field: 'tPrescNo',
                title: '处方号',
                width: 110
            },
            {
                field: 'tDesc',
                title: '名称',
                width: 200
            },
            {
                field: "tUom",
                title: '单位',
                width: 60
            },
            {
                field: 'tReturnPrice',
                title: '退药价格',
                width: 75,
                align: 'right'
            },
            {
                field: 'tReturnQty',
                title: '退药数量',
                width: 75,
                align: 'right'
            },
            {
                field: 'tReturnAmt',
                title: '退药金额',
                width: 75,
                align: 'right'
            },
            {
                field: 'tDispQty',
                title: '原发药数量',
                width: 90,
                align: 'right'
            },
            {
                field: 'tRetReqQty',
                title: '申请退药数量',
                width: 90,
                align: 'right'
            },
            {
                field: 'tReturnDate',
                title: '退药日期',
                width: 100
            },
            {
                field: 'tReturnTime',
                title: '退药时间',
                width: 100
            },
            {
                field: 'tReturnOper',
                title: '退药人',
                width: 80
            },
            {
                field: 'TGeneric',
                title: '处方通用名',
                width: 150
            },
            {
                field: 'TBarcode',
                title: '规格',
                width: 70
            },
            {
                field: 'TForm',
                title: '剂型',
                width: 100
            },
            {
                field: 'TManf',
                title: '生产企业',
                width: 120
            },
            {
                field: 'TResPatName',
                title: '被冲减姓名',
                width: 80
            },
            {
                field: 'TResPatNo',
                title: '被冲减登记号',
                width: 90
            },
            {
                field: 'TResBedNo',
                title: '被冲减床号',
                width: 80
            },
            {
                field: 'TResPatQty',
                title: '被冲减数量',
                width: 80
            },
            {
                field: 'TEncryptLevel',
                title: '病人密级',
                width: 100,
                hidden:true
            },
            {
                field: 'TPatLevel',
                title: '病人级别',
                width: 100,
                hidden:true
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: false
    }
    //定义datagrid	
    $('#grid-returndetail').dhcphaEasyUIGrid(dataGridOption);
}

///查询
function Query() {
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    var selInci=$("#sel-locinci").select2('data');
    var inciRowId=selInci!=""?selInci[0].id:"";
    var selPhaLoc=$("#sel-phaloc").select2('data');
    var phaLoc=selPhaLoc!=""?selPhaLoc[0].id:"";
    if (phaLoc==""){
	    dhcphaMsgBox.alert("请选择药房!");
        return;
	}
	var selWardLoc=$("#sel-wardloc").select2('data');
    var wardLoc=selWardLoc!=""?selWardLoc[0].id:"";
    var selRetType=$("#sel-rettype").select2('data');
    var rettype=selRetType!=""?selRetType[0].id:"";
    var incstkcatrowid = "";
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaLoc + tmpSplit + inciRowId + tmpSplit + incstkcatrowid + tmpSplit + wardLoc+tmpSplit+rettype;
    $('#grid-returntotal').datagrid({
        queryParams: {
            ClassName: "web.DHCSTPHARETURN",
            QueryName: "PhaRet",
            Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
        }
    });
    $('#grid-returndetail').clearEasyUIGrid();

}

///查询明细
function QuerySub() {
    var selecteddata = $('#grid-returntotal').datagrid('getSelected');
    if (selecteddata == null) {
        return;
    }
    var inciRowId = $("#sel-locinci").val();
    if (inciRowId == null) {
        inciRowId = "";
    }
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var pharetno = selecteddata["tPhaRetNo"];
	var pharet = selecteddata["tPhaRet"];
    var params = pharetno + tmpSplit + inciRowId + tmpSplit + pharet;
    $('#grid-returndetail').datagrid({
        queryParams: {
            ClassName: "web.DHCSTPHARETURN",
            QueryName: "RetItm",
            Params: params
        }
    });
}

function BtnPrintHandler() {
    if ($('#grid-returntotal').datagrid('getData').rows.length == 0) {
        dhcphaMsgBox.alert("页面没有数据");
        return;
    }
    if ($('#grid-returntotal').datagrid('getSelected') == null) {
        dhcphaMsgBox.alert("请选择需要打印的数据!");
        return;
    }
    var selecteddata = $('#grid-returntotal').datagrid('getSelected');
    if (selecteddata == null) {
        return;
    }
    var pharet = selecteddata["tPhaRet"];
    PrintReturnCom(pharet, "补");
}
//清空
function ClearConditions() {
    var today = new Date();
    $("#date-start").data('daterangepicker').setStartDate(today);
    $("#date-start").data('daterangepicker').setEndDate(today);
    $("#date-end").data('daterangepicker').setStartDate(today);
    $("#date-end").data('daterangepicker').setEndDate(today);
    $("#sel-locinci").empty();
    $("#sel-wardloc").empty();
    $("#sel-rettype").val("").trigger('change');
    $('#grid-returntotal').clearEasyUIGrid();
    $('#grid-returndetail').clearEasyUIGrid();
}
window.onresize = ResizePhaReturnQuery;

function ResizePhaReturnQuery() {
    $("#grid-returntotal").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
    $("#grid-returndetail").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 12);
    $("#grid-returntotal,#grid-returndetail").datagrid('resize')
}
