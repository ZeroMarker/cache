///DHCDoc.OP.BillInfo.js
var BillInfoDataGrid;
var BillInfoDataSelectedRow;
var Chart1;
var LoadStopOrd = "";
var tabExecDetailsDataGrid;
$(function () {
    ///加载本次医嘱的费用信息
    InitBillInfoList();
    InitKeyWord();
    /*
    LoadEchart();
	
    window.setTimeout(function(){
            LoadLocChartData();
        },1000);
    */
});
function InitKeyWord() {
    $("#OrdComStatusKeyWord").keywords({
        singleSelect: true,
        labelCls: 'red',
        items: [
            { text: '全部', id: 'All', selected: true },
            { text: '已撤销', id: 'Stop' },
            { text: '未收费', id: 'UnPay' },
            { text: '已收费', id: 'Payed' },
            { text: '已发药', id: 'Dispensing' },
            { text: '未发药', id: 'UnDispensing' }
        ],
        onClick: function (v) {
            LoadBillInfoList();
        }
    });

}

function ReLoadLabInfo() {
    LoadBillInfoList();
    LoadChartData();
}
var selRowIndex = "";
function InitBillInfoList() {

    var BillInfoColumns = [[
        { field: 'IsCNMedItem', checkbox: true }
        , { field: 'ReportLinkInfo', hidden: true }
        , { field: 'SeqNo', title: '组号', width: 70 }
        , { field: 'OrdBilled', title: '计费状态', width: 70 }
        , { field: 'OrderSum', title: unescape('总价'), width: 70 }
        , { field: 'Desc', title: '医嘱名称', width: 250 }
        , { field: 'DoseQty', title: '单次剂量', width: 80 }
        , { field: 'Instr', title: '用法', width: 60 }
        , { field: 'PHFreq', title: '频次', width: 60 }
        , { field: 'Dura', title: '疗程', width: 50 }
        , { field: 'PackQty', title: '数量', width: 60 }
        , {
            field: 'OrdStatus', title: '医嘱状态', width: 80,
            formatter: function (value, row, index) {
                var btn = "";
                if (row.OrderViewFlag == "Y") {
                    var btn = '<a style="color: #ff7f24;text-decoration: underline;" onclick="OpenOrderView(\'' + row.OEItemID + '\')">' + value + '\</a>';
                } else {
                    btn = value;
                }
                return btn;

            }
        }
        , { field: 'DrugActiveQty', title: '实发数量', width: 80 }
        , { field: 'ReLoc', title: '接收科室', width: 100 }
        , { field: 'OrdDepProcNotes', title: '备注', width: 60 }
        , { field: 'Price', title: '单价', width: 70, align: 'right' }
        , { field: 'PrescNo', title: '处方号', width: 150 }
        , {
            field: 'ExeDetails', title: '执行情况', width: 80, sortable: false, align: 'center', hidden: true,
            formatter: function (value, row, index) {
                if (row.OEItemID == "") {
                    return "";
                }
                var btn = '<a style="color: #ff7f24;text-decoration: underline;" onclick="OpenExeDetails(\'' + row.OEItemID + '\',\'' + row.Desc + '\')">明细</a>';
                return btn;
            }
        }
        , { field: 'UserDep', title: '科室', width: 150 }
        , { field: 'Doctor', title: '医师', width: 80 }

        , { field: 'OrdStartDate', title: '开始时间', width: 180 }
        , { field: 'OEDStatus', title: '发药状态', width: 80 }
        , { field: 'AdmReason', title: '费别', width: 60 }
        , { field: 'MaterialBarCode', title: '高值条码', width: 80 }
        , { field: 'LabNo', title: '检验号', width: 150 }
        , { field: 'OrdLabSpec', title: '标本', width: 60 }
        , { field: 'OrdSkinTest', title: '皮试', width: 60 }
        , { field: 'OrdAction', title: '皮试备注', width: 80 }
        , { field: 'OrdSkinTestResult', title: '皮试结果', width: 80 }
        //,{field: 'OEDStatus', title: '发药状态', width: 60}
        //,{field: 'OEItemID', title: '医嘱编码', width: 150,sortable: true}
        , { field: 'Priority', title: '优先级', width: 100, sortable: true }
        , { field: 'OrdXDate', title: '停止日期', width: 80, sortable: true }
        , { field: 'OrdXTime', title: '停止时间', width: 80, sortable: true }

        , { field: 'OrderUsableDays', title: '可用天数', width: 80, sortable: true }
        , { field: 'OrderNotifyClinician', title: '加急', width: 60, sortable: true }
        , { field: 'OrdSpeedFlowRate', title: '输液流速', width: 80, sortable: true }
        , { field: 'OrderFlowRateUnitdesc', title: '流速单位', width: 80, sortable: true }
        , { field: 'OrderNeedPIVAFlag', title: '需要配液', width: 80, sortable: true }
        , { field: 'OrderLocalInfusionQty', title: '输液次数', width: 60, sortable: true }
        , { field: 'ExceedReasonDesc', title: '疗程超量原因', width: 80, sortable: true }
        , { field: 'OrderStage', title: '医嘱阶段', width: 80, sortable: true }
        , { field: 'OrderPilotPro', title: '药理项目', width: 80, sortable: true }
        , { field: 'OrderOperation', title: '手术列表', width: 80, sortable: true }
        , { field: 'BindSource', title: '绑定来源', width: 160, sortable: true }
        , { field: 'OrderDIACat', title: '特病分类', width: 80, sortable: true }
        , { field: 'OrderViewFlag', hidden: true }
        , { field: 'OrderChronicDiagCode', title: '慢病病种', width: 80, sortable: true }
        , { field: 'OEItemID', title: '编号', width: 80, sortable: true }


    ]];

    BillInfoDataGrid = $('#tabBillInfoList').datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: false,
        fitColumns: false,
        autoRowHeight: false,
        pagination: false,
        rownumbers: false,
        //pageSize: 150,
        //pageList : [150,100,200],
        idField: 'SeqNo', //OEItemID
        columns: BillInfoColumns,
        onClickRow: function (rowIndex, rowData) {
            BillInfoDataSelectedRow = rowIndex;
        },
        rowStyler: function (index, row) {
            if (row.OrdStatus == "停止") {
                return 'background-color:#BDBEC2;color:#000000;';
            } else if (row.OEItemID != "") {
                return '';
            } else {
                return 'background-color:#C8FEC0;color:#000000;';
            }
        }
        , onLoadSuccess: function (data) {
            if (LoadStopOrd == "") {
                BillInfoDataGrid.datagrid('hideColumn', 'OrdXDate');
                BillInfoDataGrid.datagrid('hideColumn', 'OrdXTime');
            } else {
                BillInfoDataGrid.datagrid('showColumn', 'OrdXDate');
                BillInfoDataGrid.datagrid('showColumn', 'OrdXTime');
            }
        },
        onCheck: function (rowIndex, rowData) {
            var OEItemID = rowData.OEItemID;
            if ((selRowIndex !== "") || (OEItemID.indexOf("||") < 0)) {
                return false;
            }
            var SeqNo = rowData.SeqNo;
            var IsCNMedItem = rowData.IsCNMedItem;
            var rows = BillInfoDataGrid.datagrid('getRows');
            //勾选主医嘱
            if (SeqNo.indexOf(".") < 0) {
                for (var idx = rowIndex + 1; idx < rows.length; idx++) {
                    var mySeqNo = rows[idx].SeqNo;
                    var myIsCNMedItem = rows[idx].IsCNMedItem;
                    if (myIsCNMedItem != IsCNMedItem) continue;
                    if (mySeqNo.split(".")[0] == SeqNo) {
                        selRowIndex = idx;
                        BillInfoDataGrid.datagrid('checkRow', idx);
                    }
                }
            } else if (SeqNo.indexOf(".") >= 0) { //勾选子医嘱 存在空行的情况
                var MasterrowIndex = BillInfoDataGrid.datagrid('getRowIndex', SeqNo.split(".")[0]);
                if (MasterrowIndex >= 0) {
                    var myIsCNMedItem = rows[MasterrowIndex].IsCNMedItem;
                    if (myIsCNMedItem == IsCNMedItem) {
                        BillInfoDataGrid.datagrid('checkRow', MasterrowIndex);
                    }
                }
            }
            selRowIndex = "";
        },
        onUncheck: function (rowIndex, rowData) {
            var OEItemID = rowData.OEItemID;
            if ((selRowIndex !== "") || (OEItemID.indexOf("||") < 0)) return false;
            var SeqNo = rowData.SeqNo;
            var IsCNMedItem = rowData.IsCNMedItem;
            var rows = BillInfoDataGrid.datagrid('getRows');
            //取消勾选主医嘱
            if (SeqNo.indexOf(".") < 0) {
                for (var idx = rowIndex + 1; idx < rows.length; idx++) {
                    var mySeqNo = rows[idx].SeqNo;
                    var myIsCNMedItem = rows[idx].IsCNMedItem;
                    if (myIsCNMedItem != IsCNMedItem) continue;
                    if (mySeqNo.split(".")[0] == SeqNo) {
                        selRowIndex = idx;
                        BillInfoDataGrid.datagrid('uncheckRow', idx);
                    }
                }
            } else if (SeqNo.indexOf(".") >= 0) { //勾选子医嘱
                var MasterrowIndex = BillInfoDataGrid.datagrid('getRowIndex', SeqNo.split(".")[0]);
                if (MasterrowIndex >= 0) {
                    var myIsCNMedItem = rows[MasterrowIndex].IsCNMedItem;
                    if (myIsCNMedItem == IsCNMedItem) {
                        BillInfoDataGrid.datagrid('uncheckRow', MasterrowIndex);
                    }
                }
            }
            selRowIndex = "";
        },
        onBeforeLoad: function (param) {
            BillInfoDataGrid.datagrid("uncheckAll");
        }
    });
    LoadBillInfoList();
}

function LoadBillInfoList() {
    var SelOrderTypeList = "";
    if ($("#OrdReSubCatKeyWord").has("ul").length > 0) {
        $.each($("#OrdReSubCatKeyWord").keywords("getSelected"), function (i, obj) {
            if (obj.id == "All") {
                return true;
            }
            if (SelOrderTypeList == "") {
                SelOrderTypeList = obj.id;
            } else {
                SelOrderTypeList = SelOrderTypeList + "^" + obj.id;
            }
        });
    }
    var OrdComStatus = "";
    if ($("#OrdComStatusKeyWord").has("ul").length > 0) {
        $.each($("#OrdComStatusKeyWord").keywords("getSelected"), function (i, obj) {
            if (obj.id == "All") {
                return true;
            }
            if (OrdComStatus == "") {
                OrdComStatus = obj.id;
            } else {
                OrdComStatus = OrdComStatus + "^" + obj.id;
            }
        });
    }
    $.q({
        ClassName: "web.DHCDocOPOrdInfo",
        QueryName: "GetOrdByAdm",
        EpisodeID: EpisodeID,
        UserID: "", BillType: "",
        OrdComStatus: OrdComStatus,
        SelOrderTypeList: SelOrderTypeList,
        //Pagerows:BillInfoDataGrid.datagrid("options").pageSize,
        rows: 99999
    }, function (GridData) {
        BillInfoDataGrid.datagrid("unselectAll").datagrid('loadData', GridData);
        InitOrdTypeSeachInfo();
    });
}
function InitOrdTypeSeachInfo() {
    if ($("#OrdReSubCatKeyWord").has("ul").length > 0) {
        return;
    }
    $.cm({
        ClassName: "web.DHCDocOPOrdInfo",
        MethodName: "GetOrdCalInfoByAdm",
        EpisodeID: EpisodeID,
        UserID: ""
    }, function (OrdCalInfo) {
        //医嘱项重分类信息展示
        $("#OrdReSubCatKeyWord").keywords({
            singleSelect: true,
            labelCls: 'red',
            items: OrdCalInfo.OrdTypeList,
            onClick: function (v) {
                LoadBillInfoList();
            }
        });
        //费用区域信息展示
        $("#PatFeeInfoKeyWord").keywords({
            singleSelect: false,
            labelCls: 'blue',
            items: OrdCalInfo.AdmInfo
        }).off("click");
    });
}
function OrderTypeCheckChangeHandler(event, value) {
    LoadBillInfoList();
}
function GetOrdTypeCheckList() {
    var CheckBoxList = $("div.datagrid-toolbar tr .checked", BillInfoDataGrid.datagrid("getPanel"));
    var Length = CheckBoxList.length;
    var CheckBoxID;
    var SelOrderTypeList = "";
    for (var i = 0; i < Length; i++) {
        CheckBoxID = $(CheckBoxList[i]).prev()[0].id;
        //if ($(CheckBoxList[i]).checkbox("getValue")){

        if (SelOrderTypeList == "") {
            SelOrderTypeList = CheckBoxID.split("_")[0];
        } else {
            SelOrderTypeList = SelOrderTypeList + "_" + CheckBoxID.split("_")[0];
        }
        //}
    }
    return SelOrderTypeList;
}
function LoadEchart() {
    /*
    var option = {
        title : {
            text: '费用明细',
            x:'left'
        },
        tooltip : {
            trigger: 'item',
            formatter: "{a} <br/>{b} : {c} ({d}%)"
        },
        legend: {
            x : 'left',
            pading: 10,
            y : 'bottom'
        },
        calculable : true,
        series : [{
                name:'本次病人',
                type:'pie',
                center : ['25%', '50%'],
                startAngle:10,       
                data:[]
            },{
                name:'本日接诊病人',
                type:'pie',
                center : ['75%', '50%'],
                startAngle:10,
                radius: ['70%', '90%'],
                minAngle: 2,
                data:[]
            },{
                name:'本日报销',
                type:'pie',
                center : ['75%', '50%'],
                radius: [0, '55%'],
                label: {
                    normal: {
                        position: 'inner'
                    }
                },
                startAngle:10,
                data:[]
            }
        ]
    };
    */
    //堆叠条形图
    var option = {
        title: {
            text: '',
            textStyle: {
                fontSize: 13
            },
        },
        legend: {
            textStyle: {
                color: "#20CF56"
            }
        },
        tooltip: {
            position: ['50%', '10%'],
            formatter: function (params, ticket, callback) {
                return params.seriesName;
            }
        },
        xAxis: {
            data: [],
            type: 'value',
            max: 1000,
            show: false,
            axisTick: {
                show: false
            }
        },
        yAxis: {
            type: 'category',
            show: false,
            axisTick: {
                show: false
            }
        },
        color: ["#FE4343", "#F59747", "#F5D44E", "#45DAF6", "#4977F3", "#5247F4", "#AD48F1"],
        series: []
    };
    option.title.text = $g("本次病人");
    Chart1 = echarts.init(document.getElementById('BillCat1'), 'macarons');
    Chart1.setOption(option);
    option.title.text = $g("本日接诊");
    Chart2 = echarts.init(document.getElementById('BillCat2'), 'macarons');
    Chart2.setOption(option);
    option.title.text = $g("本日报销");
    Chart3 = echarts.init(document.getElementById('BillCat3'), 'macarons');
    Chart3.setOption(option);
    LoadChartData();
}
function LoadChartData() {
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: '../web.DHCDocAdmBillInfo.cls',
        async: true,
        cache: false,
        data: {
            action: 'GetAdmBillInfo',
            EpisodeID: EpisodeID,
            UserID: ""
        },
        success: function (result) {
            if (result == null) { return }
            if (result) {
                var seriesList = formatData(result);
                var options = Chart1.getOption();
                //options.series[1].data = result;  
                options.series = seriesList;
                Chart1.hideLoading();
                Chart1.setOption(options);
            }
        },
        error: function (errorMsg) {
            $.messager.alert("提示", "图表请求数据失败", "info", function () {
                Chart1.hideLoading();
            });
        }
    });
}
function LoadLocChartData() {
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: '../web.DHCDocAdmBillInfo.cls',
        async: true,
        cache: false,
        data: {
            action: 'GetDateAdmBillInfo',
            UserID: session['LOGON.USERID'],
            LogonLoc: session['LOGON.CTLOCID'],
            StDate: '',
            EdDate: '',
            AdmType: ''
        },
        success: function (result) {
            if (result == null) { return }
            if (result) {
                var seriesList = formatData(result);
                var options = Chart2.getOption();
                //options.series[1].data = result;  
                options.series = seriesList;
                Chart2.hideLoading();
                Chart2.setOption(options);
            }
        },
        error: function (errorMsg) {
            $.messager.alert("提示", "图表请求数据失败", "info", function () {
                Chart2.hideLoading();
            });
        }
    });
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: '../web.DHCDocAdmBillInfo.cls',
        async: true,
        cache: false,
        data: {
            action: 'GetInsunSumInfo',
            UserID: session['LOGON.USERID'],
            LogonLoc: session['LOGON.CTLOCID'],
            StDate: '',
            EdDate: '',
            AdmType: ''
        },
        success: function (result) {
            if (result == null) { return }
            if (result) {
                var seriesList = formatData(result);
                var options = Chart3.getOption();
                //options.series[1].data = result;  
                options.series = seriesList;
                Chart3.hideLoading();
                Chart3.setOption(options);
            }
        },
        error: function (errorMsg) {
            $.messager.alert("提示", "图表请求数据失败", "info", function () {
                Chart1.hideLoading();
            });
        }
    });
}

function formatData(result) {
    var total = 0;
    for (var i = 0; i < result.length; i++) {
        total += parseFloat(result[i].value);
    }
    if (total == 0) {
        total = 1000;
    }
    var seriesList = [];
    var Diff = 0;
    for (var i = 0; i < result.length; i++) {
        var per = parseFloat(result[i].value) / parseFloat(total);
        seriesList.push({
            type: 'bar',
            name: result[i].name + " " + result[i].value + " " + (per * 100).toFixed(2) + "%",
            barMinHeight: 20,
            data: [(function () {
                var data = (per * 1000);
                if (data < 20) {
                    Diff = parseFloat(per * 1000) - 20;
                    data = 20;
                } else {
                    if (data > 300) {
                        data = parseFloat(data) + Diff;
                        Diff = 0;
                    }
                }
                return data;
            })()],
            stack: 'income',
            barWidth: 15,
            itemStyle: {
                emphasis: {
                    shadowColor: 'rgba(0, 0, 0, 0.5)',
                    shadowBlur: 10,
                    opacity: 0.8
                }
            }
        });
    }
    return seriesList
}
function OpenReportLink(ReportLinkInfo) {
    if (ReportLinkInfo == "") { return; }
    var ReportLinkInfoArr = ReportLinkInfo.split("!");
    var ReportType = ReportLinkInfoArr[0];
    var Param = ReportLinkInfoArr[1];
    if (ReportType == "L") {
        //var path = "oeorder.labreport.csp?Param=" + Param; 
        var path = "jquery.easyui.dhclabreport.csp?VisitNumberReportDR=" + Param;
        websys_createWindow(path, "ReportLink", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,top=100,width=800,height=600")
    } else if (ReportType == "Ris") {
        var RptParm = tkMakeServerCall("web.DHCRisCommFunctionEx", "GetReportUrl", ReportLinkInfoArr[1], ReportLinkInfoArr[2], session['LOGON.USERID'])
        if (RptParm != "") {
            var Item = RptParm.split(":")
            if (Item[0] == "http") {
                websys_createWindow(RptParm, "newwindow", "scrollbars=yes,resizable=yes, height=600, width=800, toolbar=no, menubar=no,location=no,status=no,top=100,left=300");
            } else {
                var curRptObject = new ActiveXObject("wscript.shell");
                curRptObject.run(RptParm);
            }
        }
    }
    return
}

///执行记录执行明细
function OpenExeDetails(OEItemID, ItemDesc) {
    destroyDialog("ExecDetailsDiag");
    var Content = "<table id='tabExecDetails' cellpadding='5' style='margin:5px;border:none;'></table>";
    var iconCls = "";
    createModalDialog("ExecDetailsDiag", ItemDesc, 550, 350, iconCls, "", Content, "");

    var ExecFeeColumns = [[
        { field: 'TExStDate', title: '要求执行时间', width: 120 },
        { field: 'TRealExecDate', title: '执行时间', width: 120 },
        {
            field: 'TExecState', title: '状态', width: 80,
            styler: function (value, row, index) {
                if (row.TExecStateCode) {
                    if (["未执行", "D", "C"].indexOf(row.TExecStateCode) > -1) {
                        return "background-color: yellow;"
                    }
                }
            }
        },
        { field: 'TExecRes', title: '执行原因', width: 100 },
        { field: 'TExecUser', title: '处理人', width: 80 },
        { field: 'ExecPart', title: '检查部位', width: 180 },
        { field: 'Notes', title: '备注', width: 100 },
        { field: 'OrderExecId', title: '执行编号', width: 100 }
    ]]
    tabExecDetailsDataGrid = $("#tabExecDetails").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: false,
        fitColumns: false,
        autoRowHeight: false,
        rownumbers: true,
        pagination: true,
        rownumbers: true,
        pageSize: 10,
        pageList: [10, 100, 200],
        idField: 'FeeId',
        columns: ExecFeeColumns
    });
    $.q({
        ClassName: "web.DHCDocInPatPortalCommon",
        QueryName: "FindOrderExecDet",
        orderId: OEItemID,
        Pagerows: tabExecDetailsDataGrid.datagrid("options").pageSize, rows: 99999
    }, function (GridData) {
        tabExecDetailsDataGrid.datagrid('loadData', GridData);
    });
}

function destroyDialog(id) {
    $("body").remove("#" + id); //移除存在的Dialog
    $("#" + id).dialog('destroy');
}

/**
 * 创建一个模态 Dialog
 * @param id divId
 * @param _url Div链接
 * @param _title 标题
 * @param _width 宽度
 * @param _height 高度
 * @param _icon ICON图标
 * @param _btntext 确定按钮text
*/
function createModalDialog(id, _title, _width, _height, _icon, _btntext, _content, _event) {
    if (_btntext == "") {
        var buttons = [{
            text: $g('关闭'),
            iconCls: 'icon-w-close',
            handler: function () {
                destroyDialog(id);
            }
        }]
    } else {
        var buttons = [{
            text: _btntext,
            iconCls: _icon,
            handler: function () {
                if (_event != "") eval(_event);
            }
        }]
    }
    $("body").append("<div id='" + id + "' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;

    $("#" + id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        collapsible: false,
        minimizable: false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content: _content,
        buttons: buttons
    });
}
function OpenOrderView(OEItemID) {
    websys_showModal({
        url: "dhc.orderview.csp?ord=" + OEItemID,
        title: $g('医嘱查看'),
        width: screen.availWidth - 200, height: screen.availHeight - 300
    });
}
function getRefData() {
    var rtnObj = { data: "", toTitle: "", msg: "", success: true };
    var SelRowListRowData = BillInfoDataGrid.datagrid('getSelections');
    if (SelRowListRowData.length == 0) {
        $.extend(rtnObj, { msg: "未选择需要操作的行数据!", success: false });
        return rtnObj;
    }
    var oeoris = "", CMoeoris = "";
    for (var i = 0; i < SelRowListRowData.length; i++) {
        if (SelRowListRowData[i].OEItemID == "") {
            continue;
        }
        var OrderId = SelRowListRowData[i].OEItemID;
        if (SelRowListRowData[i].IsCNMedItem == 1) {
            if (CMoeoris == "") CMoeoris = OrderId;
            else CMoeoris = CMoeoris + "^" + OrderId;
        } else {
            if (oeoris == "") oeoris = OrderId;
            else oeoris = oeoris + "^" + OrderId;
        }
    }
    if ((oeoris == "") && (CMoeoris == "")) {
        $.extend(rtnObj, { msg: "未选择需要操作的行数据!", success: false });
        return rtnObj;
    }
    if ((oeoris != "") && (CMoeoris != "")) {
        $.extend(rtnObj, { msg: "西药和草药不能同时复制!", success: false });
        return rtnObj;
    }
    var toTitle = $g("医嘱录入");
    if (oeoris == "") oeoris = CMoeoris, toTitle = $g("草药录入");
    oeoris = oeoris.split("^").sort(function (num1, num2) {
        return parseFloat(num1.split("||")[1]) - parseFloat(num2.split("||")[1]);
    }).join("^");
    $.extend(rtnObj, { data: oeoris, toTitle: toTitle });
    return rtnObj;
} 
