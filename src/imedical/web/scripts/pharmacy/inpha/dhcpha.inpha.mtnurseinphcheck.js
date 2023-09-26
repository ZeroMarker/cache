/**
 * 模块:		移动住院药房
 * 子模块:		移动住院药房-护士药房核对
 * createdate:	2017-04-19
 * creator:		hulihua
 */
var AuditorDr = ""
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
DhcphaTempBarCode = "";

$(function () {
    /* 初始化插件 start*/
    var daterangeoptions = {
        singleDatePicker:true,
    }
    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    //给日期控件赋初始化值！
    startdate = FormatDateT("t-3");
    enddate = FormatDateT("t");
    $("#date-start").data('daterangepicker').setStartDate(startdate);
    $("#date-start").data('daterangepicker').setEndDate(startdate);
    $("#date-end").data('daterangepicker').setStartDate(enddate);
    $("#date-end").data('daterangepicker').setEndDate(enddate);
    InitPhaLoc(); //药房科室
    SetLogPhaLoc(); //给药房科室赋默认值！
    InitGirdPreList();
    InitGridPreIncList();
    InitGirdPreOrderList();
    /* 表单元素事件 start*/
    //卡号失去焦点触发事件
    $('#txt-cardno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            SetUserInfo();
        }
    });

    $('#txt-cardno').focus();

    $("#chk-audit").on("ifChanged", function () {
        QueryGridPre();
    })

    //document.onkeydown = OnKeyDownHandler;
    InitBodyStyle();
})

//扫描或者输入工号之后验证以及填充界面
function SetUserInfo() {
    var cardno = $.trim($("#txt-cardno").val());
    $('#currentnurse').text("");
    $('#currentctloc').text("");
    if (cardno != "") {
        var defaultinfo = tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod", "GetUserDefaultInfo", cardno);
        if (defaultinfo == null || defaultinfo == "") {
            dhcphaMsgBox.alert("输入工号有误，请核实!",'',function(){
				setTimeout(function(){
					$('#txt-cardno').focus(); 
				},500);
			});
            $('#txt-cardno').val("");
            return;
        }
        var ss = defaultinfo.split("^");
        AuditorDr = ss[0];
        $('#currentnurse').text(ss[2]);
        $('#currentctloc').text(ss[4]);
        $('#txt-cardno').val("");
    }else{
		dhcphaMsgBox.alert("请先刷领药人的卡或者输入工号!",'',function(){
			setTimeout(function(){
				$('#txt-cardno').focus();
			},500);
		
		});
		return;
	}
    //QueryGridPre();
}

//药房科室赋默认值！
function SetLogPhaLoc() {
	if (session['LOGON.WARDID']!=""){
		$("#sel-phaloc").empty();
		$('#currentctloc').parent().hide();
		
		return;
	}
}

//初始化发药单列表table
function InitGirdPreList() {
    var columns = [{
            header: 'ID',
            index: 'TPhacID',
            name: 'TPhacID',
            width: 60,
            hidden: true
        },
        {
            header: '发药单号',
            index: 'TPhacNo',
            name: 'TPhacNo',
            width: 120
        },
        {
            header: '发药日期',
            index: 'TPhaDate',
            name: 'TPhaDate',
            width: 140
        },
        {
            header: '发药人',
            index: 'TPhaDispUser',
            name: 'TPhaDispUser',
            width: 100,
            align: 'left'
        },
        {
            header: '取药人',
            index: 'TTakeNuserUser',
            name: 'TTakeNuserUser',
            width: 100,
            align: 'left'
        },
        {
            header: '病区',
            index: 'TWardDesc',
            name: 'TWardDesc',
            width: 200,
            align: 'left'
        }
    ];

    var jqOptions = {
        colModel: columns, //列
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTNurseCheck.NurseCheckQuery&MethodName=GetInPhacList',
        height: OutFYCanUseHeight() + 120,
        recordtext: "",
        pgtext: "",
        shrinkToFit: false,
        onSelectRow: function (id, status) {
            QueryGridPreInc();
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-preparelist").clearJqGrid();
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }

    };
    $("#grid-preparelist").dhcphaJqGrid(jqOptions);
}

//初始化发药单药品汇总table
function InitGridPreIncList() {
    var columns = [{
            header: 'TPhacSub',
            index: 'TPhacSub',
            name: 'TPhacSub',
            width: 60,
            hidden: true
        },
        {
            header: '药品名称',
            index: 'TInciDesc',
            name: 'TInciDesc',
            width: 300,
            align: 'left'
        },
        {
            header: '规格',
            index: 'TSpec',
            name: 'TSpec',
            width: 100
        },
        {
            header: '单位',
            index: 'TPhacUom',
            name: 'TPhacUom',
            width: 100
        },
        {
            header: '应发数量',
            index: 'TQtyTotal',
            name: 'TQtyTotal',
            width: 80
        },
        {
            header: '实发数量',
            index: 'TQtyActual',
            name: 'TQtyActual',
            width: 80
        },
        {
            header: '数量(包装)',
            index: 'TPackQtyActual',
            name: 'TPackQtyActual',
            width: 80
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTNurseCheck.NurseCheckQuery&MethodName=GetInPhacIncList',
        height: OutFYCanUseHeight() * 0.7,
        multiselect: false,
        pager: "#jqGridPager", //分页控件的id 
        multiselect: false,
        //datatype:"local",
        shrinkToFit: false,
        onSelectRow: function (id, status) {
            QueryGridPreOrder();
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#grid-preorderlist").clearJqGrid();
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }
    };
    $("#grid-preinclist").dhcphaJqGrid(jqOptions);
}

//发药单病人明细table
function InitGirdPreOrderList() {
    var columns = [{
            header: '登记号',
            index: 'TPatNo',
            name: 'TPatNo',
            width: 80,
            align: 'left'
        },
        {
            header: '姓名',
            index: 'TPatName',
            name: 'TPatName',
            width: 150,
            align: 'left'
        },
        {
            header: '床位号',
            index: 'TBed',
            name: 'TBed',
            width: 80,
            align: 'right'
        },
        {
            header: '用药日期',
            index: 'TDspDate',
            name: 'TDspDate',
            width: 80,
            align: 'right'
        },
        {
            header: '单位',
            index: 'TDspUom',
            name: 'TDspUom',
            width: 60
        },
        {
            header: '应发数',
            index: 'TDspQty',
            name: 'TDspQty',
            width: 100
        },
        {
            header: '发药数',
            index: 'TQty',
            name: 'TQty',
            width: 100
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: LINK_CSP + '?ClassName=web.DHCINPHA.MTNurseCheck.NurseCheckQuery&MethodName=GetInPhacOrderList',
        height: OutFYCanUseHeight() * 0.3,
        shrinkToFit: false
    };
    $("#grid-preorderlist").dhcphaJqGrid(jqOptions);
}

//查询发药单列表
function QueryGridPre() {
    $("#grid-preparelist").jqGrid("clearGridData");
    $("#grid-preinclist").jqGrid("clearGridData");
    $("#grid-preorderlist").jqGrid("clearGridData");
    var currentnurse = $.trim($("#currentnurse").text());
    var currentctloc = $.trim($("#currentctloc").text());
    if (currentnurse == null || currentnurse == "" || currentctloc == null || currentctloc == "") {
        dhcphaMsgBox.alert("请先刷领药人的卡或者输入工号!",'',function(){
			return false
		});
        return;
    }
    var stdate = $("#date-start").val();
    var enddate =$("#date-end").val();
    var phaloc = $('#sel-phaloc').val();
 	if (phaloc===null){
        dhcphaMsgBox.alert("请先选择药房!");
        return;		
	}
    var chkauit = "N";
    if ($("#chk-audit").is(':checked')) {
        chkauit = "Y";
    }
    var checkflag = 0
    if (phaloc != gLocId) {
        checkflag = 1
    }
    var params = stdate + tmpSplit + enddate + tmpSplit + phaloc + tmpSplit + AuditorDr + tmpSplit + chkauit + tmpSplit + checkflag + tmpSplit + gLocId + tmpSplit + gWardID;

    $("#grid-preparelist").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
}

//查询发药单药品汇总
function QueryGridPreInc() {
    var selectid = $("#grid-preparelist").jqGrid('getGridParam', 'selrow');
    var selrowdata = $("#grid-preparelist").jqGrid('getRowData', selectid);
    var phacid = selrowdata.TPhacID;
    var params = phacid;

    $("#grid-preinclist").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
    $("#grid-preorderlist").jqGrid("clearGridData");
}

//查询发药单病人明细
function QueryGridPreOrder() {
    var selectid = $("#grid-preinclist").jqGrid('getGridParam', 'selrow');
    var selrowdata = $("#grid-preinclist").jqGrid('getRowData', selectid);
    var phacsub = selrowdata.TPhacSub;
    if (typeof (phacsub) == "undefined") {
        $("#grid-preorderlist").jqGrid("clearGridData");
        return;
    }
    var params = phacsub;
    $("#grid-preorderlist").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
}

//护士核对通过
function PhacAuitPass() {
    var selectid = $("#grid-preparelist").jqGrid('getGridParam', 'selrow');
    var selrowdata = $("#grid-preparelist").jqGrid('getRowData', selectid);
    var phacid = selrowdata.TPhacID;
    var params = phacid;
    runClassMethod("web.DHCINPHA.MTNurseCheck.NurseCheckQuery", "SaveAuditPass", {
            'params': params
        },
        function (data) {
            if (data == -1) {
                dhcphaMsgBox.alert("未选中需要通过的发药单，请核实!");
                return;
            } else if (data == -2) {
                dhcphaMsgBox.alert("该发药单已经核对，请核实!");
                return;
            } else if (data == -3) {
                dhcphaMsgBox.alert("更新表数据失败，请核实!");
                return;
            } else {
                dhcphaMsgBox.alert("核对成功!");
                QueryGridPre();
                return;
            }
        });
}

//清空
function ClearConditions() {
    $('#currentnurse').text("");
    $('#currentctloc').text("");
    $("#grid-preparelist").clearJqGrid();
    $("#grid-preinclist").clearJqGrid();
    $("#grid-preorderlist").clearJqGrid();
    var tmpstartdate = FormatDateT("t-2")
    $("#date-start").data('daterangepicker').setStartDate(tmpstartdate);
    $("#date-start").data('daterangepicker').setEndDate(tmpstartdate);
    $("#date-end").data('daterangepicker').setStartDate(new Date());
    $("#date-end").data('daterangepicker').setEndDate(new Date());
    return
    if ($("#col-right").is(":hidden") == false) {
        $("#col-right").hide();
        $("#col-left").removeClass("col-lg-9 col-md-9 col-sm-9")
    } else {
        $("#col-right").show()
        $("#col-left").addClass("col-lg-9 col-md-9 col-sm-9")
    }
    $("#grid-preparelist").setGridWidth("")
    $("#grid-preinclist").setGridWidth("")
    $("#grid-preorderlist").setGridWidth("")
}

//本页面table可用高度
function OutFYCanUseHeight() {
    var height1 = $("[class='container-fluid dhcpha-condition-container']").height();
    var height3 = parseFloat($("[class='panel div_content']").css('margin-top'));
    var height4 = parseFloat($("[class='panel div_content']").css('margin-bottom'));
    var height5 = parseFloat($("[class='panel-heading']").height());
    var tableheight = $(window).height() - height1 * 2 - 2 * height3 - 2 * height4 - 2 * height5 - 125;
    return tableheight;
}

function CheckTxtFocus() {
    var txtfocus = $("#txt-cardno").is(":focus");
    if (txtfocus != true) {
        return false;
    }
    return true;
}

//监听keydown,用于定位扫描枪扫完后给值
function OnKeyDownHandler() {
    if (CheckTxtFocus() != true) {
        if (event.keyCode == 13) {
            $("#txt-usercode").val(DhcphaTempBarCode);
            QueryGridPre();
            DhcphaTempBarCode = "";
        } else {
            DhcphaTempBarCode += String.fromCharCode(event.keyCode)
        }
    }
    if (event.keyCode == 113) {
        PhacAuitPass();
    }
}

function InitBodyStyle() {
    $("#grid-preparelist").setGridWidth("")
}