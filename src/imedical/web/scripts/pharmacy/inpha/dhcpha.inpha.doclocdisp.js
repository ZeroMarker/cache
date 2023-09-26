/**
 * 模块:住院药房
 * 子模块:住院药房-发药
 * createdate:2016-09-02
 * creator:yunhaibao
 */
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 30 * 1000;
DHCPHA_CONSTANT.VAR.SELECT = "";
DHCPHA_CONSTANT.VAR.DISPCATPID = 0;
DHCPHA_CONSTANT.VAR.DISPCATARR = "";
DHCPHA_CONSTANT.VAR.PHALOCDISPTYPE = "";
DHCPHA_CONSTANT.VAR.WARDIDSTR = "";
DHCPHA_CONSTANT.VAR.PARAMS = "";
DHCPHA_CONSTANT.VAR.MAC = "";
DHCPHA_CONSTANT.VAR.PRIORITY = "";
$(function () {
    InitPhaConfig(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    /* 初始化插件 start*/
    var daterangeoptions = {
        singleDatePicker: true
    }

    $("#date-start").dhcphaDateRange(daterangeoptions);
    $("#date-end").dhcphaDateRange(daterangeoptions);
    InitPhaLoc(); //药房科室
    InitThisLocInci(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    InitGridDispDocLoc();
    //InitGridAdm(); //暂时不用,没写好,如有需求,可参照住院发药,yunhaibao20160929
    InitGridOrdTotal();
    InitGridOrdDetail();
    //InitInDispTab();  //主页面tab
    //$("#monitor-condition").children().not("#div-ward-condition").hide();	
    /* 初始化插件 end*/
    /* 表单元素事件 start*/
    //登记号回车事件
    $('#txt-regno').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patno = $.trim($("#txt-regno").val());
            if (patno != "") {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                KillDetailTmp();
                QueryInDispTotal("");
            }
        }
    });
    //屏蔽所有回车事件
    $("input[type=text]").on("keypress", function (e) {
        if (window.event.keyCode == "13") {
            return false;
        }
    })
    /* 表单元素事件 end*/

    /* 绑定按钮事件 start*/
    $("#a-change").on("click", ChangeDispQuery)
    $("#chk-timer").on("ifChanged", function () {
        if ($(this).is(':checked') == true) {
            DHCPHA_CONSTANT.VAR.TIMER = setInterval("QueryDispDocLocList();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
        } else {
            clearTimeout(DHCPHA_CONSTANT.VAR.TIMER);
        }
    })
    $("#btn-find").on("click", QueryDispDocLocList);
    $("#btn-refuse").on("click", DoRefuse);
    $("#btn-disp").on("click", ConfirmDisp)
    $("#btn-finddetail").on("click", function () {
        KillDetailTmp();
        QueryInDispTotal("");
    });
    /* 绑定按钮事件 end*/
    ;
    InitRefuseReasonModal();
    InitBodyStyle();
    $('#chk-prttotal').iCheck('check');
})
window.onload = function () {
    QueryDispDocLocList();
}
//初始病区发药类别table
function InitGridDispDocLoc() {
    var columns = getPhaLocDispType(DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID)
    var jqOptions = {
        colModel: columns, //列
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=QueryDispDocLocList&style=jqGrid', //查询后台	
        height: DhcphaJqGridHeight(1, 1),
        multiselect: false,
        shrinkToFit: false,
        datatype: 'local',
        // pager: "#jqGridPager1", //分页控件的id  
        onSelectRow: function (id, status) {
            var id = $(this).jqGrid('getGridParam', 'selrow');
            KillDetailTmp();
            $("#grid-dispdetail").jqGrid("clearGridData");
            if (id == null) {
                $('#grid-disptotal').clearJqGrid();
            } else {
                QueryInDispTotal();
            }
        },
        loadComplete: function () {
            $("#grid-wardlist input[type=checkbox]").each(function () {
                $(this).on("click", function () {
                    if (this.name == "") {
                        KillDetailTmp();
                        QueryInDispTotal();
                    }
                })
            });

            /* //yunhaibao,不确定将要发哪个科室的药品,不建议默认选中
            var grid_records = $(this).getGridParam('records');
            if (grid_records==0){
            	$("#grid-dispdetail").clearJqGrid();
            }else{
            	$(this).jqGrid('setSelection',1);
            }*/
            var dispwardrowdata = $(this).jqGrid('getRowData');
            var dispwardgridrows = dispwardrowdata.length;
            //默认发药类别
            var hasQT = "";
            if (dispwardgridrows > 0) {
                var dispWardColModel = $(this).jqGrid('getGridParam', 'colModel');
                for (var rowi = 1; rowi <= dispwardgridrows; rowi++) {
                    var rowidata = $(this).jqGrid('getRowData', rowi);
                    for (var coli = 1; coli < dispWardColModel.length; coli++) {
                        var tmpColObj = dispWardColModel[coli];
                        var tmpIndex = tmpColObj.index;
                        if ((tmpIndex != "TDocLocRowID") && (tmpIndex != "TDocLoc")) {
                            if (rowidata[tmpIndex] == "Yes") {
                                if (tmpIndex == "QT") {
                                    // 其他,默认不勾选
                                    $(this).setCell(rowi, tmpIndex, 'N');
                                    hasQT = "Y";
                                }
                            }
                        }
                    }
                }
            }
            if (hasQT == "Y") {
                $("#grid-wardlist").setGridParam().showCol("QT");
            } else {
                $("#grid-wardlist").setGridParam().hideCol("QT");
            }
        }
    };
    $('#grid-wardlist').dhcphaJqGrid(jqOptions);
}

function getPhaLocDispType(phaLocId) {
    phaLocDispCat = ""
    var columns = new Array();
    var column = {};
    column.name = "TDocLocRowID";
    column.index = "TDocLocRowID";
    column.header = "TDocLocRowID";
    column.hidden = true;
    columns.push(column);
    column = {};
    column.header = "医生科室";
    column.name = "TDocLoc";
    column.index = "TDocLoc";
    column.align = "left";
    column.width = 150;
    columns.push(column);
    column = {};
    var phaLocDispCat = "";
    var dispcatsstr = tkMakeServerCall("web.DHCSTPHALOC", "GetPhaLocDispType", phaLocId);
    var dispcatsarr = dispcatsstr.split("^");
    var dispcatslength = dispcatsarr.length;
    var dispcatsi = 0
    for (dispcatsi = 0; dispcatsi < dispcatslength; dispcatsi++) {
        column = {};
        var dispcatsdescarr = dispcatsarr[dispcatsi].split("@");
        var dispcatsdesc = dispcatsdescarr[1];
        if (dispcatsdesc == "") {
            continue;
        }
        var newcatlen = dispcatsdesc.length;
        var newdispcatdesc = "";
        for (var newcati = 0; newcati < newcatlen; newcati++) {
            var onecellcat = dispcatsdesc.charAt(newcati)
            newdispcatdesc = newdispcatdesc = "" ? onecellcat : newdispcatdesc + "\t" + onecellcat;
        }
        var dispcatscode = dispcatsdescarr[0];
        if (phaLocDispCat == "") {
            phaLocDispCat = dispcatscode
        } else {
            phaLocDispCat = phaLocDispCat + "^" + dispcatscode
        }
        column.header = newdispcatdesc;
        column.index = dispcatscode;
        column.name = dispcatscode;
        column.width = 30;
        column.formatter = "checkbox";
        column.formatoptions = {
            disabled: false
        };
        columns.push(column);
    }
    DHCPHA_CONSTANT.VAR.PHALOCDISPTYPE = phaLocDispCat;
    return columns
}

//初始化发药汇总table
function InitGridOrdTotal() {
    var columns = [{
            name: "TPID",
            index: "TPID",
            header: 'TPID',
            width: 100,
            align: 'left',
            hidden: true
        },
        {
            name: 'TCollStat',
            index: 'TCollStat',
            header: '状态',
            width: 65,
            cellattr: addCollStatCellAttr
        },
        {
            name: "TDesc",
            index: "TDesc",
            header: '药品名称',
            width: 200,
            align: 'left'
        },
        {
            name: "TQty",
            name: "TQty",
            header: '数量',
            width: 60,
            align: 'right'
        },
        {
            name: "TUom",
            name: "TUom",
            header: '单位',
            width: 60
        },
        {
            name: "TSp",
            name: "TSp",
            header: '售价',
            width: 80,
            align: 'right'
        },
        {
            name: "TAmt",
            name: "TAmt",
            header: '金额',
            width: 80,
            align: 'right'
        },
        {
            name: "TQtyBed",
            name: "TQtyBed",
            header: '数量/床号',
            width: 80,
            hidden: true
        },
        {
            name: "TBarcode",
            name: "TBarcode",
            header: '规格',
            width: 100
        },
        {
            name: "TManufacture",
            name: "TManufacture",
            header: '厂商',
            width: 150,
            align: 'left'
        },
        {
            name: "TIncstk",
            name: "TIncstk",
            header: '货位',
            width: 100,
            align: 'left'
        },
        {
            name: "TGeneric",
            name: "TGeneric",
            header: '处方通用名',
            width: 150,
            align: 'left'
        },{
            name: "TDrugForm",
            name: "TDrugForm",
            header: '剂型',
            width: 100
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=jsQueryDispDocLoc&style=jqGrid&querytype=total', //查询后台	
        height: DhcphaJqGridHeight(2, 1) - 35,
        multiselect: false,
        shrinkToFit: false,
        // pager: "#jqGridPager", //分页控件的id  
        onSelectRow: function (id, status) {

        }
    };
    $('#grid-disptotal').dhcphaJqGrid(jqOptions);
}

function splitFormatter(cellvalue, options, rowObject) {
    if (cellvalue.indexOf("-") >= 0) {
        cellvalue = cellvalue.split("-")[1];
    }
    return cellvalue;
};
//初始化发药明细table
function InitGridOrdDetail() {
    var columns = [{
            name: 'TSelect',
            index: 'TSelect',
            header: '<a id="TDispSelect" href="#" onclick="SetSelectAll()">全消</a>',
            width: 35,
            editable: true,
            align: 'center',
            edittype: 'checkbox',
            formatter: "checkbox",
            formatoptions: {
                disabled: false
            }
        },
        {
            name: "TPID",
            index: "TPID",
            header: 'TPID',
            width: 80,
            hidden: true
        },
        {
            name: 'TCollStat',
            index: 'TCollStat',
            header: '状态',
            width: 65,
            cellattr: addCollStatCellAttr
        },
        {
            name: "TAdmLoc",
            index: "TAdmLoc",
            header: '科室',
            width: 125,
            formatter: splitFormatter
        },
        {
            name: "TBedNo",
            index: "TBedNo",
            header: '床号',
            width: 80
        },
        {
            name: "TPaName",
            index: "TPaName",
            header: '姓名',
            width: 80
        },
        {
            name: "TRegNo",
            index: "TRegNo",
            header: '登记号',
            width: 100
        },
        {
            name: "TDesc",
            index: "TDesc",
            header: '药品名称',
            width: 200,
            align: 'left'
        },
        {
            name: "TQty",
            index: "TQty",
            header: '数量',
            width: 50,
            align: 'right'
        },
        {
            name: "TUom",
            index: "TUom",
            header: '单位',
            width: 50
        },
        {
            name: "TDoseQty",
            index: "TDoseQty",
            header: '剂量',
            width: 60
        },
        {
            name: "TFreq",
            index: "TFreq",
            header: '频率',
            width: 60
        },
        {
            name: "TInstruction",
            index: "TInstruction",
            header: '用法',
            width: 80
        },
        {
            name: "TDuration",
            index: "TDuration",
            header: '疗程',
            width: 80
        },
        {
            name: "TSalePrice",
            index: "TSalePrice",
            header: '售价',
            width: 70,
            align: 'right'
        },
         {
            name: "Tolp",
            index: "Tolp",
            header: '金额',
            width: 80,
            align: 'right'
        },
        {
            name: "Tbarcode",
            index: "Tbarcode",
            header: '规格',
            width: 80
        },
        {
            name: "Tmanf",
            index: "Tmanf",
            header: '厂商',
            width: 150,
            align: 'left'
        },
        {
            name: "Tgenedesc",
            index: "Tgenedesc",
            header: '处方通用名',
            width: 150,
            align: 'left'
        },
        {
            name: "Tphcform",
            index: "Tphcform",
            header: '剂型',
            width: 100
        },

        {
            name: "Tgoods",
            index: "Tgoods",
            header: '货位',
            width: 100,
            align: 'left'
        },
        {
            name: "TOrdStatus",
            index: "TOrdStatus",
            header: '医嘱状态',
            width: 60
        },
        {
            name: "Toetype",
            index: "Toetype",
            header: '医嘱优先级',
            width: 80
        },
        {
            name: "TPhaCat",
            index: "TPhaCat",
            header: '类别',
            width: 80,
            hidden: true
        },
        {
            name: "TPrescNo",
            index: "TPrescNo",
            header: '处方号',
            width: 110
        },
        {
            name: "Tdoctor",
            index: "Tdoctor",
            header: '开单医生',
            width: 60,
            hidden:true
        },
        {
            name: "Tdatetime",
            index: "Tdatetime",
            header: '开单时间',
            width: 150,
            align: 'left'
        },
        {
            name: "Tdiagnose",
            index: "Tdiagnose",
            header: '诊断',
            width: 200,
            align: 'left'
        }, 
        {
            name: "Taudited",
            index: "Taudited",
            header: '审核',
            width: 80,
            hidden: true
        },
        {
            name: "TPaold",
            index: "TPaold",
            header: '年龄',
            width: 60
        },
        {
            name: "Taction",
            index: "Taction",
            header: '备注',
            width: 80,
            align: 'left'
        },
        {
            name: "TInsuType",
            index: "TInsuType",
            header: '医保类别',
            width: 75
        },
        {
            name: "Tstr",
            index: "Tstr",
            header: 'Tstr',
            width: 80,
            hidden: true
        },
        {
            name: "TDispIdStr",
            index: "TDispIdStr",
            header: 'TDispIdStr',
            width: 80,
            hidden: true
        },
        {
            name: "Toedis",
            index: "Toedis",
            header: 'Toedis',
            width: 80,
            hidden: true
        },
        {
            name: "TBatchNo",
            index: "TBatchNo",
            header: '批号',
            width: 80,
            hidden: true
        }
    ];
    var jqOptions = {
        colModel: columns, //列
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=jsQueryDispDocLoc&querytype=detail&style=jqGrid', //查询后台	
        height: DhcphaJqGridHeight(2, 2) - 42,
        multiselect: false,
        //multiboxonly:false,
        shrinkToFit: false,
        pager: "#jqGridPager1", //分页控件的id  
        onSelectRow: function (id, status) {

        },
        loadComplete: function () {
            $('#grid-disptotal').clearJqGrid();
            $("#TDispSelect").text("全消");
            AddjqGridCheckEvent();
        },
        onPaging: function (pgButton) {
            ReLoadAddPid();
        },
        gridComplete: function () {

        }
    };
    $('#grid-dispdetail').dhcphaJqGrid(jqOptions);
    $("#refresh_grid-dispdetail").hide(); //此处刷新先屏蔽
}

function AddjqGridCheckEvent() {
    $("#grid-dispdetail input[type=checkbox]").each(function () {
        $(this).unbind(); //setrowdata后,click事件失效,每次都需全绑定
        $(this).on("click", function () {
            if (this.name == "") {
                $td = $(event.target).closest("td"); //知道哪个元素,就能定位哪个焦点
                var rowid = $td.closest("tr.jqgrow").attr("id");
                var selectdata = $("#grid-dispdetail").jqGrid('getRowData', rowid)
                Savetofitler(selectdata);
                //SelectLinkOrder(selectdata);	
            }
        })
    })
}

function SetSelectAll() {
    var tmpSelectFlag = ""
    if ($("#TDispSelect").text() == "全选") {
        $("#TDispSelect").text("全消")
        tmpSelectFlag = "Y"
    } else {
        $("#TDispSelect").text("全选")
        tmpSelectFlag = "N"
    }
    var selDspIdArr=[];
    var thisrecords = $("#grid-dispdetail").getGridParam('records');
    if (thisrecords > 0) {
        var ids = $("#grid-dispdetail").getDataIDs();
        for (var i = 0; i < ids.length; i++) {
			var rowData=$("#grid-dispdetail").jqGrid('getRowData',i+1);
			var dspIdStr=rowData.TDispIdStr;
			selDspIdArr.push(dspIdStr);
			var newdata={
		    	TSelect:tmpSelectFlag 
		    };
		    $("#grid-dispdetail").jqGrid('setRowData',i+1,newdata);	
        }
        var tmpRowData=$("#grid-dispdetail").jqGrid('getRowData',1);
		var pid=tmpRowData.TPID;
		var selDspIdStr=selDspIdArr.join("^");
		var selected=(tmpSelectFlag=="Y")?"D":"S";
		if (selDspIdStr!=""){
			tkMakeServerCall("web.DHCSTPCHCOLLSDOCLOC","SaveToFilterMulti",pid,selDspIdStr,selected)
		}
    }
    
    AddjqGridCheckEvent();
}

function Savetofitler(selectrowdata) {
    //暂时保存发药时没有选择的医嘱Rowid
    var tdispstr = selectrowdata["TDispIdStr"];
    var tpid = selectrowdata["TPID"];
    var selected = selectrowdata["TSelect"];
    if (selected == "Yes") {
        selected = "D";
    } else {
        selected = "S";
    }
    if ((tpid != "") && (tpid != undefined)) {
        var saveret = tkMakeServerCall("web.DHCSTPCHCOLLSDOCLOC", "SaveToFilter", tpid, tdispstr, selected)
    }
}
//关联医嘱选中,不调用,医生科室发药不需要
function SelectLinkOrder(selecteddata) {
    var tmpselect = selecteddata["TSelect"]
    var toedis = selecteddata["Toedis"];
    var orderlinkret = CheckOrderLink(toedis).split("%");
    var oeoricnt = orderlinkret[0]
    if (oeoricnt > 0) {
        var mainoeori = selecteddata["TMainOrd"]; //主医嘱id
        var dodisdate = selecteddata["TTimeAdd"]
        var mainindex = mainoeori + "^" + dodisdate
        var quitflag = 0;
        var dispgridrows = $("#grid-dispdetail").getGridParam('records');
        for (var i = 1; i <= dispgridrows; i++) {
            var tmpselecteddata = $("#grid-dispdetail").jqGrid('getRowData', i)
            var tmpmainoeori = tmpselecteddata["TMainOrd"]
            var tmpdodisdate = tmpselecteddata["TTimeAdd"]
            var tmpmainindex = tmpmainoeori + "^" + tmpdodisdate;
            if (mainindex == tmpmainindex) {
                var newdata = {
                    TSelect: tmpselect
                };
                $("#grid-dispdetail").jqGrid('setRowData', i, newdata);
                //$("#grid-dispdetail").jqGrid('setCell',i,'TSelect',tmpselect,"",abc);
                var newselectdata = $("#grid-dispdetail").jqGrid('getRowData', i)
                Savetofitler(newselectdata);
                quitflag = 1;
            }
            if ((quitflag == 1) && (mainindex != tmpmainindex)) {
                break;
            }
        }
    }
    AddjqGridCheckEvent();
}
//判断是否为关联医嘱
function CheckOrderLink(oedisstr) {
    var ret = tkMakeServerCall("web.DHCSTPCHCOLLS", "CheckLinkOeord", oedisstr)
    return ret;
}

function ReLoadAddPid() {
    if ($("#grid-dispdetail").getGridParam('records') > 0) {
        var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
        var Pid = firstrowdata.TPID
        $("#grid-dispdetail").setGridParam({
            postData: {
                Pid: Pid
            }
        })
    }
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
    });
}

function InitPhaConfig(locRowId) {
    $.ajax({
        type: 'POST', //提交方式 post 或者get  
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetInPhaConfig&gLocId=' + locRowId, //提交到那里 后他的服务  
        data: "",
        success: function (value) {
            if (value != "") {
                SetPhaLocConfig(value)
            }
        },
        error: function () {
            alert("获取住院药房配置数据失败!");
        }
    });
}
//加载药房配置
function SetPhaLocConfig(configstr) {
    DHCPHA_CONSTANT.VAR.PARAMS = configstr;
    var configarr = configstr.split("^");
    var startdate = configarr[2];
    var enddate = configarr[3];
    var notwardrequired = configarr[0];
    var auditneed = configarr[10];
    var retflag = configarr[11];
    var dispuserflag = configarr[17];
    var operaterflag = configarr[21];
    var aduitBillflag = configarr[22];
    var disptypelocalflag = configarr[23];
    var displayemyflag = configarr[24];
    var displayoutflag = configarr[25];
    var lsflag = configarr[26];
    var reqwardflag = configarr[27];
    var dispdefaultflag = configarr[28];
    startdate = FormatDateT(startdate);
    enddate = FormatDateT(enddate);
    $("#date-start").data('daterangepicker').setStartDate(startdate);
    $("#date-start").data('daterangepicker').setEndDate(startdate);
    $("#date-end").data('daterangepicker').setStartDate(enddate);
    $("#date-end").data('daterangepicker').setEndDate(enddate);
    //InitDispUserModal(DHCPHA_CONSTANT.VAR.PARAMS);
}

//查询待发药医生科室
function QueryDispDocLocList() {
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaLoc = ""
    }
    if (phaloc == "") {
        dhcphaMsgBox.alert("药房不允许为空!");
        return;
    }
    var params = startdate + "!!" + enddate + "!!" + phaloc;
    $("#grid-wardlist").setGridParam({
        datatype: 'json',
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
    KillDetailTmp();
    $('#grid-disptotal').clearJqGrid();
    $('#grid-dispdetail').clearJqGrid();
}
//查询就诊记录
function QueryDispAdmList() {
    var patno = $("#txt-patno").val();
    var params = patno;
    $("#grid-admlist").setGridParam({
        postData: {
            'params': params
        }
    }).trigger("reloadGrid");
}
//查询待发药列表
function QueryInDispTotal(Pid) {
    if (Pid == undefined) {
        Pid = "";
    }
	if (Pid == '') {
        $('#grid-dispdetail').jqGrid('clearGridData');
        $('#grid-disptotal').jqGrid('clearGridData');
    }
    var params = GetQueryDispParams();
    if (params != "") {
        if ($("#div-detail").is(":hidden") == false) {
            $("#grid-dispdetail").setGridParam({
                postData: {
                    params: params,
                    Pid: Pid
                }
            }).trigger("reloadGrid");
        } else {
            $("#grid-disptotal").setGridParam({
                postData: {
                    params: params,
                    Pid: Pid
                }
            }).trigger("reloadGrid");
        }
    }
}

function GetQueryDispParams() {
    var dispcatlist = "";
    var doclocrowid = "";
    if ($("#div-ward-condition").is(":hidden") == false) {
        var selectid = $("#grid-wardlist").jqGrid('getGridParam', 'selrow');
        if ((selectid == "") || (selectid == null)) {
            dhcphaMsgBox.alert("请先选择需要发药的医生科室!");
            $('#grid-disptotal').clearJqGrid();
            $('#grid-dispdetail').clearJqGrid();
            return "";
        }
        var selrowdata = $("#grid-wardlist").jqGrid('getRowData', selectid);
        doclocrowid = selrowdata.TDocLocRowID;
        dispcatlist = GetDispCatList(selrowdata);

    } else {
        dhcphaMsgBox.alert("请刷新界面后重试!");
        return "";
    }
    var startdate = $("#date-start").val();
    var enddate = $("#date-end").val();
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaloc = ""
    }
    if (phaloc == "") {
        dhcphaMsgBox.alert("药房不允许为空!");
        return "";
    }
    var incirowid = $("#sel-locinci").val()
    if (incirowid == null) {
        incirowid = ""
    }
    var patno = $("#txt-regno").val();
    var params = phaloc + "!!" + startdate + "!!" + enddate + "!!" + DHCPHA_CONSTANT.SESSION.GUSER_ROWID + "!!" + dispcatlist + "!!" + doclocrowid + "!!" + patno + "!!" + incirowid
    return params;

}
//获取选中科室的发药类别
function GetDispCatList(selectrowdata) {
    var colModel = $("#grid-wardlist").jqGrid('getGridParam', 'colModel');
    var dispcatsstr = "";
    var collength = colModel.length;
    for (var columni = 0; columni < collength; columni++) {
        var colmodali = colModel[columni];
        var colnamei = colmodali.name;
        if ((colnamei == "TDocLocRowID") || (colnamei == "TDocLoc") || (colnamei == "cb")) {
            continue;
        }
        if (selectrowdata[colnamei] == "Yes") {
            if (dispcatsstr == "") {
                dispcatsstr = colnamei
            } else {
                dispcatsstr = dispcatsstr + "^" + colnamei
            }
        }
    }
    return dispcatsstr;
}
//发药
function ConfirmDisp() {
    if ($("#sp-title").text() == "发药明细") {
        if (DhcphaGridIsEmpty("#grid-dispdetail") == true) {
            return;
        }
    } else if ($("#sp-title").text() == "发药汇总") {
        if (DhcphaGridIsEmpty("#grid-disptotal") == true) {
            return;
        }
    }
    if (DHCPHA_CONSTANT.VAR.PHALOCDISPTYPE == "") {
        dhcphaMsgBox.alert("发药类别为空!")
        return;
    }
    dhcphaMsgBox.confirm("是否确认发药?", DoDisp);
}

function DoDisp(result) {
    if (result == true) {
        var dispflag = "";
        //取是否录入发药人配置
        /*if (DHCPHA_CONSTANT.VAR.PARAMS!=""){
        	var paramsarr=DHCPHA_CONSTANT.VAR.PARAMS.split("^");
        	var dispuserflag=paramsarr[17];
        	var operaterflag=paramsarr[21];
        	if ((dispuserflag=="Y")||(operaterflag=="Y")){
        		dispflag=1;
        		$('#modal-inphaphauser').modal('show');
        	}
        }*/
        if (dispflag == "") {
            ExecuteDisp({});
        }
    }
}

function ExecuteDisp(dispoptions) {
    var pid = "";
    if ($("#sp-title").text() == "发药明细") {
        var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
        pid = firstrowdata.TPID
    } else if ($("#sp-title").text() == "发药汇总") {
        var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
        pid = firstrowdata.TPID
    }
    var phaloc = $("#sel-phaloc").val();
    var selectid = $("#grid-wardlist").jqGrid('getGridParam', 'selrow');
    if ((selectid == "") || (selectid == null)) {
        dhcphaMsgBox.alert("请先选择需要发药的医生科室!");
        return "";
    }
    var selrowdata = $("#grid-wardlist").jqGrid('getRowData', selectid);
    doclocrowid = selrowdata.TDocLocRowID;
    dispcatlist = GetDispCatList(selrowdata);
    if (dispcatlist == "") {
        dhcphaMsgBox.alert("发药类别为空!");
        return "";
    }
    var phacrowidStr = ""
    var dispcatarr = dispcatlist.split("^");
    for (var cati = 0; cati < dispcatarr.length; cati++) {
        var dispcat = dispcatarr[cati];
        var PhacRowid = SaveDispensing(dispcat, pid,doclocrowid);
        if (PhacRowid > 0) {
            if (phacrowidStr != "") {
                phacrowidStr = phacrowidStr + "A" + PhacRowid;
            } else {
                phacrowidStr = PhacRowid;
            }
        } else if (PhacRowid < 0) {
            alert(getDispCatName(cat) + "发药失败!");
        }
    }
    // 调用满整支
    if ((phacrowidStr == "") || (phacrowidStr == 0)) {
        dhcphaMsgBox.alert("未发出药品,您可以在发药明细中查具体原因");
        tkMakeServerCall("web.DHCINPHA.Disp.Global", "KillSaveDataNoStock", pid)
        return;
    }
    var reserveret = tkMakeServerCall("web.DHCINPHA.Reserve", "SaveReserveForWhole", phacrowidStr, DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
    dhcphaMsgBox.confirm("是否打印？", function (rtn) {
        if (rtn == true) {
            PrintReport(phacrowidStr, pid);
        }
        KillDetailTmp();
        QueryDispDocLocList();
    });

}

function SaveDispensing(dispcat, pid,doclocrowid) {
    var PhacRowid = tkMakeServerCall("web.DHCSTPCHCOLLSDOCLOC", "SaveDisp", "", "", dispcat, pid, DHCPHA_CONSTANT.SESSION.GUSER_ROWID,doclocrowid);
    return PhacRowid;
}
//拒绝发药
function DoRefuse() {
    if ($("#sp-title").text() == "发药汇总") {
        dhcphaMsgBox.alert("请切换到发药明细进行拒绝!");
        return;
    }
    if (DhcphaGridIsEmpty("#grid-dispdetail") == true) {
        return;
    }
    var dispgridrows = $("#grid-dispdetail").getGridParam('records');
    var canrefuse = 0;
    for (var i = 1; i <= dispgridrows; i++) {
        var tmpselecteddata = $("#grid-dispdetail").jqGrid('getRowData', i)
        var tmpselect = tmpselecteddata["TSelect"];
        if (tmpselect != "Yes") {
            continue;
        }
        canrefuse = 1;
        break;
    }
    if (canrefuse == 0) {
        dhcphaMsgBox.alert("请选择需要拒绝发药的明细!");
        return;
    }
    $('#modal-inpharefusedispreason').modal('show');
}

function ExecuteRefuse(refusereason) {
    var ordArr = new Array();
    var dispgridrows = $("#grid-dispdetail").getGridParam('records');
    for (var i = 1; i <= dispgridrows; i++) {
        var tmpselecteddata = $("#grid-dispdetail").jqGrid('getRowData', i)
        var tmpselect = tmpselecteddata["TSelect"];
        if (tmpselect != "Yes") {
            continue;
        }
        var tmpdispidstr = tmpselecteddata["TDispIdStr"];
        if (!ordArr.contains(tmpdispidstr)) {
            ordArr.push(tmpdispidstr)
        }
    }
    tkMakeServerCall("web.DHCSTPCHCOLLS", "InsertDrugRefuse", ordArr.join("^"), DHCPHA_CONSTANT.SESSION.GUSER_ROWID, refusereason)
    KillDetailTmp();
    QueryInDispTotal();
}

function InitInDispTab() {
    $("#tab-ipmonitor a").on('click', function () {
        ;
        var tabId = $(this).attr("id");
        var tmpTabId = "#div-" + tabId.split("-")[1] + "-condition";
        $(tmpTabId).show();
        $("#monitor-condition").children().not(tmpTabId).hide();
        if (tabId != "tab-patno") {
            $("#txt-patno").val("");
            if ($("#grid-admlist").getGridParam('records') > 0) {
                KillDetailTmp();
                $('#grid-admlist').clearJqGrid();
                $('#grid-disptotal').clearJqGrid();
                $('#grid-dispdetail').clearJqGrid();
                QueryInDispTotal("");
            }
        }
    })

}
//初始化药品选择
function InitThisLocInci(locrowid) {
    var locincioptions = {
        id: "#sel-locinci",
        locid: locrowid
    }
    InitLocInci(locincioptions)
}

function ChangeDispQuery() {
    var Pid = "";
    if ($("#sp-title").text() == "发药汇总") {
        $("#sp-title").text("发药明细");
        $("#div-total").hide();
        $("#div-detail").show();
        if ($("#grid-dispdetail").getGridParam('records') == 0) {
            if ($("#grid-disptotal").getGridParam('records') > 0) {
                var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
                Pid = firstrowdata.TPID
            }
            QueryInDispTotal(Pid);
        }
    } else {
        $("#sp-title").text("发药汇总")
        $("#div-detail").hide();
        $("#div-total").show(); //每次点击汇总都要重新汇总
        if ($("#grid-dispdetail").getGridParam('records') > 0) {
            var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
            Pid = firstrowdata.TPID
        }
        QueryInDispTotal(Pid);
    }
}

function KillDetailTmp() {
    var Pid = "";
    if ($("#sp-title").text() == "发药汇总") {
        if ($("#grid-disptotal").getGridParam('records') > 0) {
            var firstrowdata = $("#grid-disptotal").jqGrid("getRowData", 1);
            Pid = firstrowdata.TPID;
        }
    } else {
        if ($("#grid-dispdetail").getGridParam('records') > 0) {
            var firstrowdata = $("#grid-dispdetail").jqGrid("getRowData", 1);
            Pid = firstrowdata.TPID
        }
    }
    KillInDispTmp(Pid)
}

function KillInDispTmp(pid) {
    if (pid != "") {
        tkMakeServerCall("web.DHCINPHA.DispDocLoc", "KillTmp", pid);
    }
}

function GetDispCatNameByCode(catcode) {
    var dispcatname = tkMakeServerCall("web.DHCINPHA.InfoCommon", "GetDispCatDescByCode", catcode)
    return dispcatname;
}

function PrintReport(phacstr, pid) {
    var printtype = "";
    if ($("#chk-prttotal").is(':checked') == true) {
        printtype = 2;
    }
    if ($("#chk-prtdetail").is(':checked') == true) {
        printtype = 1;
    }
    if (($("#chk-prttotal").is(':checked') == true) && ($("#chk-prtdetail").is(':checked') == true)) {
        printtype = 3;
    }
    var phacStr = phacstr.split("A").join("^");
    IPPRINTCOM.Print({
        phacStr: phacStr,
        otherStr: "",
        printType: printtype,
        reprintFlag: "N",
        pid: ''
    });
}

function InitRefuseReasonModal() {
    $('#modal-inpharefusedispreason').on('show.bs.modal', function () {
        var option = {
            url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + "?action=GetRefuseDispReason&style=select2",
            minimumResultsForSearch: Infinity,
            width: 200,
            allowClear: false
        }
        $("#sel-refusedispreason").dhcphaSelect(option);
        $("#sel-refusedispreason").empty();
    })
    $("#btn-refusereason-sure").on("click", function () {
        var refusereason = $("#sel-refusedispreason").val();
        if ((refusereason == "") || (refusereason == null)) {
            dhcphaMsgBox.alert("请选择拒绝发药原因!");
            return;
        }
        $("#modal-inpharefusedispreason").modal('hide');
        ExecuteRefuse(refusereason);
    });

}
//发药人,摆药人选择
function InitDispUserModal(params) {
    var paramsarr = params.split("^");
    var dispuserflag = paramsarr[17];
    var operaterflag = paramsarr[21];
    if (dispuserflag != "Y") {
        $("#sel-phauser").closest("div").hide();
    }
    if (operaterflag != "Y") {
        $("#sel-operateuser").closest("div").hide();
    }
    $('#modal-inphaphauser').on('show.bs.modal', function () {
        var option = {
            url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + "?action=GetInPhaUser&style=select2&groupId=" + DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
            //minimumResultsForSearch: Infinity,
            width: 200,
            allowClear: false
        }
        $("#sel-phauser").dhcphaSelect(option);
        $("#sel-phauser").empty();
        $("#sel-operateuser").dhcphaSelect(option);
        $("#sel-operateuser").empty();
    })
    $("#btn-phauser-sure").on("click", function () {
        var phauser = $("#sel-phauser").val();
        var operateuser = $("#sel-operateuser").val();
        if ((dispuserflag == "Y") && ((phauser == "") || (phauser == null))) {
            dhcphaMsgBox.alert("请选择发药人!");
            return;
        }
        if ((operaterflag == "Y") && ((operateuser == "") || (operateuser == null))) {
            dhcphaMsgBox.alert("请选择摆药人!");
            return;
        }
        $("#modal-inphaphauser").modal('hide');
        var dispoptions = {
            phauser: phauser,
            operateuser: operateuser
        }
        ExecuteDisp(dispoptions);
    });
}

function InitBodyStyle() {
    $('#div-conditions').collapse('show');
    $('#div-conditions').on('hide.bs.collapse', function () {
        var tmpheight = DhcphaJqGridHeight(2, 1) - 40;
        tmpheight = tmpheight + $("#div-conditions").height();
        $("#grid-disptotal").setGridHeight(tmpheight);
    })
    $('#div-conditions').on('show.bs.collapse', function () {
        var tmpheight = DhcphaJqGridHeight(2, 1) - 40;
        $("#grid-disptotal").setGridHeight(tmpheight);
    })
    $("#grid-disptotal").setGridWidth(""); //yunhaibao20160906,设空后填满空间,不知道为啥
    $("#grid-dispdetail").setGridWidth("");
    $("#div-detail").hide();
    var wardtitleheight = $("#gview_grid-wardlist .ui-jqgrid-hbox").height();
    var wardheight = DhcphaJqGridHeight(1, 0) - wardtitleheight - 10;
    $("#grid-wardlist").setGridHeight(wardheight);
    $("#grid-wardlist").setGridWidth("");
    $("#tab-patno").hide();

}

function addCollStatCellAttr(rowId, val, rawObject, cm, rdata) {
    if (val.indexOf("欠费") >= 0) {
        return "class=dhcpha-record-owefee";
    } else if (val.indexOf("库存不足") >= 0) {
        return "class=dhcpha-record-nostock";
    } else {
        return "";
    }
}
window.onbeforeunload = function () {
    KillDetailTmp();
}