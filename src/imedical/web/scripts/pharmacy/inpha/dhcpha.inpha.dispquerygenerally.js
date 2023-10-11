/*
 *模块:住院药房
 *子模块:业务查询-发药综合查询
 *createdate:2016-12-12
 *creator:yunhaibao
 */
DHCPHA_CONSTANT.VAR.NEWPHACCAT = "";
$(function () {
    /* 初始化插件 start*/
    var daterangeoptions = {
        timePicker: true,
        timePickerIncrement: 1,
        timePicker24Hour: true,
        timePickerSeconds: true,
        singleDatePicker: true,
        locale: {
            format: DHCPHA_CONSTANT.PLUGINS.DATEFMT + " HH:mm:ss"
        }
    }
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    var tDate = FormatDateT("T");
	$("#date-start").data('daterangepicker').setStartDate(tDate+" 00:00:00");
	$("#date-start").data('daterangepicker').setEndDate(tDate+" 00:00:00");
	$("#date-end").data('daterangepicker').setStartDate(tDate+" 23:59:59");
	$("#date-end").data('daterangepicker').setEndDate(tDate+" 23:59:59");
    //屏蔽所有回车事件
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    InitPhaLoc(); //药房科室
    InitPhaWard(); //病区
    InitDocLoc(); //医生科室
    InitAdmLoc(); //就诊科室
    InitDispCat(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID); //发药类别
    InitPoisonCat(); //管制分类
    InitManaGroup(); //管理组
    InitPhcForm(); //剂型
    InitIncludeDoc(); //是否包含医生科室
    InitIncludeOut(); //是否包含出院带药
    InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitFyUser();
    InitDispMainList();
    InitDispDetailList();
    /*药理分类 start*/
    $("#txt-phccat").next().children("i").on('click', function (event) {
        ShowPHAINPhcCat({},function(catObj){
			if (catObj){
				$("#txt-phccat").val(catObj.text||'');
				DHCPHA_CONSTANT.VAR.NEWPHACCAT=catObj.id||'';
			}
		})
        
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
    /* 绑定按钮事件 start*/
    $("#btn-find").on("click", Query);
    $("#btn-clear").on("click", ClearConditions);
    $("#btn-print").on("click", BtnPrintHandler);
    /* 绑定按钮事件 end*/
    ;
    $("#gird-dispquery").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
    $("#gird-dispquerydetail").closest(".panel-body").height(GridCanUseHeight(1) * 0.5 - 20);
})


//是否包含医生科室
function InitIncludeDoc() {
    var data = [{
            id: 0,
            text: '包含医生科室'
        },
        {
            id: 1,
            text: '仅医生科室'
        },
        {
            id: 2,
            text: '不包含医生科室'
        }
    ];
    var selectoption = {
        data: data,
        allowClear: false,
        minimumResultsForSearch: Infinity
    };
    $("#sel-includedoc").dhcphaSelect(selectoption);
}
//是否包含出院带药
function InitIncludeOut() {
    var data = [{
            id: 0,
            text: '包含出院带药'
        },
        {
            id: 1,
            text: '仅出院带药'
        },
        {
            id: 2,
            text: '不包含出院带药'
        }
    ];
    var selectoption = {
        data: data,
        allowClear: false,
        minimumResultsForSearch: Infinity
    };
    $("#sel-includeout").dhcphaSelect(selectoption);
}
//初始化药品选择
function InitThisLocInci(locrowid) {
    var locincioptions = {
        id: "#sel-locinci",
        locid: locrowid,
        width: "390px"
    }
    InitLocInci(locincioptions)
}
//初始化发药人
function InitFyUser() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetInPhaUser&locId=" +
            DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "&groupId=" + DHCPHA_CONSTANT.SESSION.GROUP_ROWID + "&style=select2",
        allowClear: true,
        placeholder: '发药人...'
    }
    $("#sel-fyuser").dhcphaSelect(selectoption)
    $("#sel-fyuser").on('select2:select', function (event) {
        //alert(event)
    });
}

function InitPhaLoc() {
    var selectoption = {
        minimumResultsForSearch: Infinity,
        allowClear: false,
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetStockPhlocDs&style=select2&groupId=" +
            DHCPHA_CONSTANT.SESSION.GROUP_ROWID
    }
    $("#sel-phaloc").dhcphaSelect(selectoption)
    var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>'
    $("#sel-phaloc").append(select2option); //设默认值,没想到好办法,yunhaibao20160805
    $('#sel-phaloc').on('select2:select', function (event) {
        $("#sel-locinci").empty();
        InitThisLocInci($(this).val());
        InitDispCat($(this).val());
    });
}

function InitPhaWard() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetWardLocDs&style=select2",
        placeholder: "病区..."
    }
    $("#sel-phaward").dhcphaSelect(selectoption)
}

function InitDocLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
            "?action=GetCtLocDs&style=select2&loctype=E&custtype=DocLoc",
        placeholder: "医生科室..."
    }
    $("#sel-docloc").dhcphaSelect(selectoption);
}

function InitAdmLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
            "?action=GetCtLocDs&style=select2&loctype=E&custtype=DocLoc",
        placeholder: "就诊科室..."
    }
    $("#sel-admloc").dhcphaSelect(selectoption);
}

function InitDispCat(locrowid) {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL +
            "?action=GetLocDispTypeDs&style=select2&locId=" + locrowid,
        placeholder: "发药类别...",
        minimumResultsForSearch: Infinity
        //multiple: true	
    }
    $("#sel-dispcat").dhcphaSelect(selectoption)
}

function InitPoisonCat() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
            "?action=GetPoisonCatDs&style=select2",
        allowClear: true,
        placeholder: "管制分类...",
        minimumResultsForSearch: Infinity
    }
    $("#sel-poison").dhcphaSelect(selectoption)
    $('#sel-poison').on('select2:select', function (event) {
        //alert(event)
    });
}

function InitManaGroup() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
            "?action=GetManaGroupDs&style=select2&gLocId=" + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
        allowClear: true,
        minimumResultsForSearch: Infinity,
        placeholder: "管理组..."
    }
    $("#sel-managroup").dhcphaSelect(selectoption)
    $('#sel-managroup').on('select2:select', function (event) {
        //alert(event)
    });
}

function InitPhcForm() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL +
            "?action=GetPhcFormDs&style=select2",
        allowClear: true,
        placeholder: "剂型..."
    }
    $("#sel-phcform").dhcphaSelect(selectoption)
}
//初始化发药查询列表
function InitDispMainList() {
    //定义columns
    var columns = [
        [{
                field: 'TPID',
                title: 'TPID',
                width: 100,
                align: 'left',
                hidden: true
            },
            {
                field: 'TCode',
                title: '药品代码',
                width: 90,
                align: 'center'
            },
            {
                field: 'TDesc',
                title: '药品名称',
                width: 350
            },
            {
                field: 'Tbcode',
                title: '规格',
                width: 100
            },
            {
                field: 'Tmname',
                title: '生产企业',
                width: 150,
                align: 'left',
				hidden:true
            },
            {
                field: 'TDispQty',
                title: '数量',
                width: 90,
                align: 'right'
            },
            {
                field: 'TUom',
                title: '单位',
                width: 90,
                align: 'center'
            },
            {
                field: 'Tprice',
                title: '售价',
                width: 100,
                align: 'right'
            },
            {
                field: 'TDispAmt',
                title: '金额',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'TQty',
                title: '发药数量',
                width: 100,
                align: 'right'
            },
            {
                field: 'TAmt',
                title: '发药金额',
                width: 100,
                align: 'right'
            },
            {
                field: 'TRetQty',
                title: '退药数量',
                width: 100,
                align: 'right'
            },
            {
                field: 'TRetAmt',
                title: '退药金额',
                width: 100,
                align: 'right'
            },
            {
                field: 'TPackUomQty',
                title: '取整单位数量',
                width: 100
            },
            {
                field: 'TPackPrice',
                title: '整包装价格',
                width: 100,
                align: 'right'
            },
            {
                field: 'Tgname',
                title: '处方通用名',
                width: 150
            },
            {
                field: 'Tfname',
                title: '剂型',
                width: 110,
                algin: 'center'
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: false,
        onClickRow: function (rowIndex, rowData) {
            QueryDetail();
        }
    }
    //定义datagrid	
    $('#gird-dispquery').dhcphaEasyUIGrid(dataGridOption);
}

//初始化发药明细列表
function InitDispDetailList() {
    //定义columns
    var columns = [
        [{
                field: 'TAdmLoc',
                title: '科室',
                width: 150
            },
            {
                field: 'TBedNo',
                title: '床号',
                width: 80
            },
            {
                field: 'TRegNo',
                title: '登记号',
                width: 90,
                align: 'center'
            },
            {
                field: 'TName',
                title: '姓名',
                width: 90
            },
            {
                field: 'TSex',
                title: '性别',
                width: 75,
                align: 'center'
            },
            {
                field: 'Tpaold',
                title: '年龄',
                width: 75,
                align: 'center'
            },
            {
                field: 'TPrescNo',
                title: '处方号',
                width: 110,
                align: 'center'
            },
            {
                field: 'TDoseQty',
                title: '剂量',
                width: 100
            },
            {
                field: 'TQty',
                title: '数量',
                width: 75,
                align: 'right'
            },
            {
                field: 'TUomDesc',
                title: '单位',
                width: 75
            },
            {
                field: 'TSalePrice',
                title: '售价',
                width: 75,
                align: 'right'
            },
            {
                field: 'TAmt',
                title: '金额',
                width: 75,
                align: 'right'
            },
            {
                field: 'Tfreq',
                title: '频次',
                width: 100
            },
            {
                field: 'Tdiag',
                title: '诊断',
                width: 200,
                hidden: true
            },
            {
                field: 'Tptime',
                title: '发药时间',
                width: 150
            },
            {
                field: 'Tdoctor',
                title: '开方医生',
                width: 80,
                align: 'center',
                hidden: true
            },
            {
                field: 'Toedate',
                title: '开方时间',
                width: 150
            },
            {
                field: 'Taction',
                title: '备注',
                width: 100
            },
            {
                field: 'TPackPrice',
                title: '整包装价格',
                width: 100,
                align: 'right',
                hidden: true
            },
            {
                field: 'TEncryptLevel',
                title: '病人密级',
                width: 100
            },
            {
                field: 'TPatLevel',
                title: '病人级别',
                width: 100
            },
            {
                field: 'TDrugForm',
                title: '剂型',
                width: 100
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: false,
        pagination: true
    }
    //定义datagrid	
    $('#gird-dispquerydetail').dhcphaEasyUIGrid(dataGridOption);
}


///查询
function Query() {
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
    var startdate = startdatetime.split(" ")[0];
    var starttime = startdatetime.split(" ")[1];
    var enddate = enddatetime.split(" ")[0];
    var endtime = enddatetime.split(" ")[1];
    var phaloc = $("#sel-phaloc").val();
    var patno = $("#txt-patno").val();
    var patname = "" //$("#txt-patname").val();
    var wardrowid = $("#sel-phaward").val();
    if (wardrowid == null) {
        wardrowid = "";
    }
    var dispuser = $("#sel-fyuser").val();
    if (dispuser == null) {
        dispuser = "";
    }
    dispuser = dispuser + "^id";
    var incirowid = $("#sel-locinci").val();
    if (incirowid == null) {
        incirowid = "";
    }
    var fyuser = $("#sel-fyuser").val();
    if (fyuser == null) {
        fyuser = "";
    }
    var dispcat = $("#sel-dispcat").val();
    if (dispcat == null) {
        dispcat = "";
    }
    var admlocrowid = $("#sel-admloc").val();
    if (admlocrowid == null) {
        admlocrowid = "";
    }
    var doclocrowid = $("#sel-docloc").val();
    if (doclocrowid == null) {
        doclocrowid = "";
    }
    var phcformrowid = $("#sel-phcform").val();
    if (phcformrowid == null) {
        phcformrowid = "";
    }
    var managrouprowid = $("#sel-managroup").val();
    if (managrouprowid == null) {
        managrouprowid = "";
    }
    var poisonrowid = $("#sel-poison").val();
    if (poisonrowid == null) {
        poisonrowid = "";
    }
    var stkcatrowid = "";
    var PhcCatRowidStr = "^^"; //原药学三级分类
    var includedoc = $("#sel-includedoc").val();
    var onlydoc = 0,
        onlyout = 0,
        excludedoc = 0,
        excludeout = 0;
    if (includedoc == 1) {
        onlydoc = "1"
    } else if (includedoc == 2) {
        excludedoc = "1"
    }
    var includeout = $("#sel-includeout").val();
    if (includeout == 1) {
        onlyout = "1"
    } else if (includeout == 2) {
        excludeout = "1"
    }
    if ($("#txt-phccat").val() == "") {
        DHCPHA_CONSTANT.VAR.NEWPHACCAT = "";
    }
    var otherparams = poisonrowid + "^" + stkcatrowid + "^" + onlydoc + "^" + onlyout + "^" + excludedoc + "^" + excludeout + "^" + DHCPHA_CONSTANT.VAR.NEWPHACCAT;
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaloc + tmpSplit + wardrowid + tmpSplit + dispuser +
        tmpSplit + dispcat + tmpSplit + PhcCatRowidStr + tmpSplit + incirowid + tmpSplit + admlocrowid + tmpSplit + starttime +
        tmpSplit + endtime + tmpSplit + doclocrowid + tmpSplit + phcformrowid + tmpSplit + patno + tmpSplit + managrouprowid +
        tmpSplit + otherparams
    $('#gird-dispquery').datagrid({
        queryParams: {
            ClassName: "web.DHCSTDISPSTAT",
            QueryName: "DispStatGenerally",
            Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
        }
    });
    $('#gird-dispquerydetail').clearEasyUIGrid();

}

///发药明细查询
function QueryDetail() {
    var selecteddata = $('#gird-dispquery').datagrid('getSelected');
    if (selecteddata == null) {
        return;
    }
    var pid = selecteddata["TPID"];
    var incicode = selecteddata["TCode"];
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = pid + tmpSplit + incicode;
    $('#gird-dispquerydetail').datagrid({
        queryParams: {
            ClassName: "web.DHCSTDISPSTAT",
            QueryName: "DispStatGenarallyDetail",
            Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
        }
    });
}

//清空
function ClearConditions() {
    var tDate = FormatDateT("T");
    $("#date-start").data('daterangepicker').setStartDate(tDate + " " + "00:00:00");
    $("#date-start").data('daterangepicker').setEndDate(tDate + " " + "00:00:00");
    $("#date-end").data('daterangepicker').setStartDate(tDate + " " + "23:59:59");
    $("#date-end").data('daterangepicker').setEndDate(tDate + " " + "23:59:59");
    //$("#txt-patname").val("");
    $("#txt-patno").val("");
    $("#txt-phccat").val("");
    DHCPHA_CONSTANT.VAR.NEWPHACCAT = "";
    $("#sel-fyuser").empty();
    $("#sel-locinci").empty();
    $("#sel-admloc").empty();
    $("#sel-docloc").empty();
    $("#sel-poison").empty();
    $("#sel-phaward").empty();
    $("#sel-phcform").empty();
    $("#sel-dispcat").empty();
    $("#sel-managroup").empty();
    $("#sel-includedoc").select2('val', '0');
    $("#sel-includeout").select2('val', '0');
    $('#gird-dispquery').clearEasyUIGrid();
    $('#gird-dispquerydetail').clearEasyUIGrid();
}

//打印
function BtnPrintHandler() {
    if ($('#gird-dispquery').datagrid('getData').rows.length == 0) {
        dhcphaMsgBox.alert("页面没有数据,无法打印!");
        return;
    }
    //获取界面数据
    var startdatetime = $("#date-start").val();
    var enddatetime = $("#date-end").val();
	var daterange = startdatetime + " 至 " + enddatetime;
	var phLocDesc = $("#sel-phaloc").select2("data")[0].text;
	var wardData = $("#sel-phaward").select2("data");
	var wardDesc="";
	if (wardData != ""){
		wardDesc = "病区: " + wardData[0].text;
	}
	
	var Para = {
		title: DHCPHA_CONSTANT.SESSION.GHOSP_DESC + "发药综合查询统计",
		countDate: daterange,
		printDate: getPrintDateTime(),
		phLocDesc: phLocDesc,
    	wardDesc: wardDesc
	}
	//打印公共 Huxt 2019-12-25
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: 'PHAIPDispQueryGenerally',
		data: {
			Para: Para,
			Grid: {type:'easyui', grid:'gird-dispquery'}
		},
		preview:false,
		listBorder: {style:2, startX:1, endX:195},
		page: {
			rows:30, 
			x:185, 
			y:2, 
			fontname:'黑体', 
			fontbold:'true',
			fontsize:'12', 
			format:'页码：{1}/{2}'
		}
	});
}
