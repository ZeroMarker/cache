/**
 * ordcharge.hui.js 批量修改医嘱费别
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2018-08-10
 * 
 * 注解说明
 * TABLE: DHC_Doc_OrdLinked
 */

//页面全局变量
var PageLogicObj = {
    m_AdmBox: "",
    m_AdmBoxGrid: "",
    m_Grid: "",
    m_IDS: "",
    m_Win: "",
    m_BBEX: "",
    m_OrdChgApplyLogTab: "",
    m_OrdLimitInfoGrid: ""
}
$(function() {
    //初始化
    Init();
    //事件初始化
    InitEvent();
    //页面元素初始化
    //PageHandle();
})

function Init() {
    InitSearch();
    InitDataGrid();
}

function InitEvent() {
    $("#i-find").click(findConfig);
    $("#i-edit").click(opDialog);
    $("#i-editOrdDate").click(opOrdDateDialog);
    $("#i-audit").click(opAudit);
    $("#i-patno").keydown(function(e) {
        if (e.which == 13 || event.which == 9) {
            var PatNo = $('#i-patno').val();
            if (PatNo == "") return;
            if (PatNo.length < 10) {
                for (var i = (10 - PatNo.length - 1); i >= 0; i--) {
                    PatNo = "0" + PatNo;
                }
            }
            $('#i-patno').val(PatNo);
            PageLogicObj.m_AdmBox.setValue("");

        }
    })
    $(document.body).bind("keydown", BodykeydownHandler)
}

function PageHandle() {
    //
}

function InitSearch() {

    var comboxOBJ = $HUI.combogrid("#i-adm", {
        panelWidth: 600,
        idField: 'RowID',
        textField: 'AdmDate',
        //method: 'get',
        columns: [
            [
                { field: 'AdmDate', title: '就诊日期', width: 120 },
                { field: 'DepDesc', title: '科室', width: 120 },
                { field: 'DocDesc', title: '医生', width: 120 },
                { field: 'PAAdmWard', title: '病区', width: 120 },
                { field: 'BedNo', title: '床号', width: 50 },
                { field: 'RowID', title: 'ID', width: 50 }
            ]
        ],
        pagination: true,
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCDocOrderMedLeft',
            QueryName: 'GetAdm',
            PapmiNo: ''
        },
        fitColumns: true,
        enterNullValueClear: true,
        onShowPanel: function(rowIndex, rowData) {
            var curInput = $.trim($("#i-patno").val());
            if (curInput == "") {
                return false;
            }
            PageLogicObj.m_AdmBoxGrid.datagrid("reload", {
                ClassName: 'web.DHCDocOrderMedLeft',
                QueryName: 'GetAdm',
                PapmiNo: curInput
            })

        },
        onSelect: function(rowIndex, rowData) {
            PageLogicObj.m_Grid.reload({
                ClassName: "web.DHCDocOrderMedLeft",
                QueryName: "GetOrder",
                AdmId: rowData.RowID,
                HospId: session['LOGON.HOSPID']
            });
        }
    });

    PageLogicObj.m_AdmBox = comboxOBJ;
    PageLogicObj.m_AdmBoxGrid = comboxOBJ.grid();
}
//
function InitDataGrid() {
    var columns = [
        [
            //{field:'ck',checkbox:true},
            { field: 'PatInfo', title: '病人信息', width: 200 },
            { field: 'ArcimDesc', title: '医嘱名称', width: 150 },
            { field: 'PriorityDesc', title: '医嘱类型', width: 80 },
            { field: 'OrdStartDate', title: '开始日期', width: 80 },
            { field: 'OrdStartTime', title: '开始时间', width: 60 },
            { field: 'QtyPackUOM', title: '数量', width: 60 },
            { field: 'OrdPrescNo', title: '处方号', width: 80 }, //该字段移除QP
            { field: 'BBExtCode', title: '费别', width: 60 },
            { field: 'LimitOrdInfo', title: '限制用药信息', width: 120 },
            {
                field: 'CoverMainIns',
                title: '医保标识',
                width: 60,
                formatter: function(value, rec) {
                    if (value == "Y") {
                        value = $g("是")
                    } else {
                        value = $g("否")
                    }
                    return value;
                }
            },
            {
                field: 'OEItemID',
                title: 'OEItemID',
                width: 60,
                formatter: function(value, rec) {
                    var btn = '<a class="editcls" onclick="ordDetailInfoShow(\'' + rec.OEItemID + '\')">' + value + '</a>';
                    return btn;
                }
            }
        ]
    ]

    PageLogicObj.m_Grid = $HUI.datagrid("#i-grid", {
        fit: true,
        border: false,
        striped: true,
        singleSelect: false,
        fitColumns: true,
        rownumbers: true,
        //autoRowHeight : false,
        pagination: true,
        headerCls: 'panel-header-gray',
        //pageSize:14,
        //pageList : [14,20,50],
        url: $URL,
        queryParams: {
            ClassName: "web.DHCDocOrderMedLeft",
            QueryName: "GetOrder",
            AdmId: ""
        },
        columns: columns,
        toolbar: [{
            text: '申请修改费别',
            id: 'i-edit',
            iconCls: 'icon-edit'
        }, {
            text: '申请修改下医嘱时间',
            id: 'i-editOrdDate',
            iconCls: 'icon-edit'
        }, {
            text: '申请修改医嘱医保标识',
            iconCls: 'icon-edit',
            handler: function() { ChangeOrderInsu(); }
        }, '-', {
            text: '申请修改信息审批',
            id: 'i-audit',
            iconCls: 'icon-edit'
        }]
    });
    if (ServerObj.ApplyAuditAuthority != "Y") {
        $("#i-audit").hide();
        $("#i-audit").parent().prev().hide();
    }
}

//编辑
function opDialog() {
    var selected = PageLogicObj.m_Grid.getSelections();
    if ((!selected) || (selected == "")) {
        $.messager.alert("提示", "请选择一条记录...", "info")
        return false;
    }
    var ids = [];
    for (var i = 0; i < selected.length; i++) {
        ids.push(selected[i].OEItemID)
    }
    PageLogicObj.m_IDS = ids;
    $("#i-label").html(PageLogicObj.m_IDS.length);
    if ($('#i-dialog').hasClass("c-hidden")) {
        $('#i-dialog').removeClass("c-hidden");
    };
    //i-bbex
    PageLogicObj.m_BBEX = $HUI.combobox("#i-bbex", {
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.CommonFunction&QueryName=QryFeeType&ResultSetType=array",
        valueField: 'id',
        textField: 'desc',
        onSelect: function(rec) {
            PageLogicObj.m_OrdLimitInfoGrid.reload({
                ClassName: "web.DHCDocOrderMedLeft",
                QueryName: "GetOrderLimit",
                OrderStr: PageLogicObj.m_IDS.join("^"),
                AdmReasonDr: rec.id,
                HospId: session['LOGON.HOSPID']

            });

        }
    })
    initOrdLimitInfoGrid()
    var cWin = $HUI.window('#i-dialog', {
        title: "修改费别",
        iconCls: "icon-w-edit",
        modal: true,
        minimizable: false,
        maximizable: false,
        maximizable: false,
        collapsible: false,
        onClose: function() {
            //$(this).window('destroy');
            $('#i-dialog').addClass("c-hidden");
        }
    });
    PageLogicObj.m_Win = cWin;
}
//保存字典信息
function saveCfg() {
    var result = 0,
        oeori = "";
    var bbex = PageLogicObj.m_BBEX.getValue();
    if (bbex == "") {
        $.messager.alert('提示', '请选择费别，谢谢！', "info");
        return false;
    }
    /*for (var j=0; j<PageLogicObj.m_IDS.length; j ++) {
    	oeori = PageLogicObj.m_IDS[j];
    	result = tkMakeServerCall("web.DHCDocOrderMedLeft","UpdateBBExtCode", oeori, bbex);
    	if (result != 0) {
    		$.messager.alert('提示','保存失败！医嘱ID为：' + oeori,"info");
    		return false;
    	}
    }
    PageLogicObj.m_Win.close();
    PageLogicObj.m_Grid.reload();
    $.messager.alert('提示','保存成功',"info");*/
    var result = tkMakeServerCall("web.DHCDocOrderMedLeft", "BBExtCodeChgApply", PageLogicObj.m_IDS.join("^"), bbex, session['LOGON.USERID']);
    if (result != 0) {
        $.messager.alert('提示', '保存失败！' + result, "info");
        return false;
    }
    PageLogicObj.m_Win.close();
    $.messager.popover({ msg: '申请成功！', type: 'success', timeout: 1000 });
}

function findConfig() {
    var admid = PageLogicObj.m_AdmBox.getValue();
    if (admid == "") {
        $.messager.alert('提示', '请选择就诊记录', "info");
        return false;
    }

    PageLogicObj.m_Grid.reload({
        ClassName: "web.DHCDocOrderMedLeft",
        QueryName: "GetOrder",
        AdmId: admid,
        HospId: session['LOGON.HOSPID']
    });
}

function BodykeydownHandler(e) {
    if (window.event) {
        var keyCode = window.event.keyCode;
        var type = window.event.type;
        var SrcObj = window.event.srcElement;
    } else {
        var keyCode = e.which;
        var type = e.type;
        var SrcObj = e.target;
    }
    //浏览器中Backspace不可用  
    var keyEvent;
    if (e.keyCode == 8) {
        var d = e.srcElement || e.target;
        if (d.tagName.toUpperCase() == 'INPUT' || d.tagName.toUpperCase() == 'TEXTAREA') {
            keyEvent = d.readOnly || d.disabled;
        } else {
            keyEvent = true;
        }
    } else {
        keyEvent = false;
    }
    if (keyEvent) {
        e.preventDefault();
    }
}

function opOrdDateDialog() {
    var selected = PageLogicObj.m_Grid.getSelections();
    if ((!selected) || (selected == "")) {
        $.messager.alert("提示", "请选择一条记录...", "info")
        return false;
    }
    var ids = [];
    for (var i = 0; i < selected.length; i++) {
        ids.push(selected[i].OEItemID)
    }
    PageLogicObj.m_IDS = ids;
    $("#i-label1").html(PageLogicObj.m_IDS.length);
    $("#i-datetime").datetimeboxq('setValue', "");
    $("#i-OrdDateDialog").dialog("open");
}

function OrdDateChagApply() {
    var result = 0,
        oeori = "";
    var dateTime = $("#i-datetime").datetimeboxq('getValue');
    if (dateTime == "") {
        $.messager.alert('提示', '请选择修改后的下医嘱时间!', "info");
        return false;
    }
    var result = tkMakeServerCall("web.DHCDocOrderMedLeft", "OrdDateChgApply", PageLogicObj.m_IDS.join("^"), dateTime, session['LOGON.USERID']);
    if (result != 0) {
        $.messager.alert('提示', '保存失败！' + result, "info");
        return false;
    }
    $("#i-OrdDateDialog").dialog("close");
    $.messager.popover({ msg: '申请成功！', type: 'success', timeout: 1000 });
}

function opAudit() {
    websys_showModal({
        url: "dhcdoc.datachangeapplyaudit.hui.csp?ApplyTableName=User.OEOrdItem",
        title: '医嘱信息修改申请审核',
        width: ((top.screen.width - 100)),
        height: (top.screen.height - 120),
        onClose: function() {
            PageLogicObj.m_Grid.reload();
        }
    })
}

function ChangeOrderInsu() {
    var selected = PageLogicObj.m_Grid.getSelections();
    if ((!selected) || (selected == "")) {
        $.messager.alert("提示", "请选择一条记录...", "info")
        return false;
    }
    var admid = PageLogicObj.m_AdmBox.getValue();
    var ret = tkMakeServerCall("web.DHCDocOrderMedLeft", "CheckPatYBType", admid);
    if (ret != "") {
        $.messager.alert("提示", ret, "info")
        return false;
    }

    var ids = [];
    for (var i = 0; i < selected.length; i++) {
        ids.push(selected[i].OEItemID)
    }
    PageLogicObj.m_IDS = ids;
    $HUI.combobox("#i-orderinsuflag", {
        valueField: 'id',
        textField: 'text',
        editable: false,
        data: eval("(" + ServerObj.OrdISYBListJson + ")"),
    });
    $("#i-label2").html(PageLogicObj.m_IDS.length);
    $("#i-datetime").datetimeboxq('setValue', "");
    $("#i-CoverMainInsDialog").dialog("open");
}

function OrdCoverMainInsChagApply() {
    var result = 0,
        oeori = "";
    var orderinsuflag = $("#i-orderinsuflag").combobox('getValue');
    if (orderinsuflag == "") {
        $.messager.alert('提示', '请选择修改后的医保标识!', "info");
        return false;
    }
    var result = tkMakeServerCall("web.DHCDocOrderMedLeft", "OrdinsufChgApply", PageLogicObj.m_IDS.join("^"), orderinsuflag, session['LOGON.USERID']);
    if (result != 0) {
        $.messager.alert('提示', '保存失败！' + result, "info");
        return false;
    }
    $("#i-CoverMainInsDialog").dialog("close");
    $.messager.popover({ msg: '申请成功！', type: 'success', timeout: 1000 });
}

function ordDetailInfoShow(OrdRowID) {
    /*websys_showModal({
    	url:"dhc.orderdetailview.csp?ord=" + OrdRowID,
    	title:'医嘱明细',
    	width:400,height:screen.availHeight-200
    });*/
    var columns = [
        [
            { field: 'ApplyUser', title: '申请人', width: 100 },
            { field: 'ApplyDate', title: '申请日期', width: 90 },
            { field: 'ApplyTime', title: '申请时间' },
            { field: 'ApplyStatus', title: '申请状态' },
            { field: 'ApplyInfoDetail', title: '申请修改信息' },
            { field: 'UpdateDate', title: '审核/拒绝/撤销日期' },
            { field: 'UpdateTime', title: '审核/拒绝/撤销时间' },
            { field: 'UpdateUser', title: '审核/拒绝/撤销人' },
            { field: 'RefuseReason', title: '拒绝原因' }
        ]
    ]
    PageLogicObj.m_OrdChgApplyLogTab = $HUI.datagrid("#OrdChgApplyLogTab", {
        fit: true,
        border: false,
        striped: true,
        width: 'auto', //
        singleSelect: false,
        fitColumns: false,
        rownumbers: false,
        pagination: true,
        headerCls: 'panel-header-gray',
        url: $URL,
        queryParams: {
            ClassName: "web.DHCDocOrderMedLeft",
            QueryName: "GetOrdChgApplyInfoList",
            ApplyObjectReference: OrdRowID
        },
        columns: columns
    });
    $("#i-OrdChgApplyLogDialog").dialog("open");
}

function initOrdLimitInfoGrid() {
    var columns = [
        [
            { field: 'ArcimDesc', title: '医嘱', width: 160 },
            { field: 'LimitOrdInfo', title: '限制用药信息', width: 120 },
        ]
    ]
    PageLogicObj.m_OrdLimitInfoGrid = $HUI.datagrid("#i-OrdLimitInfogrid", {
        fit: false,
        border: false,
        striped: true,
        singleSelect: false,
        fitColumns: true,
        rownumbers: true,
        autoRowHeight: false,
        pagination: true,
        headerCls: 'panel-header-gray',

        url: $URL,
        queryParams: {
            ClassName: "web.DHCDocOrderMedLeft",
            QueryName: "GetOrderLimit",
            OrderStr: PageLogicObj.m_IDS.join("^"),
            HospId: session['LOGON.HOSPID']
        },
        columns: columns,
    });
}
