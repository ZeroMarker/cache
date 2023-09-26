/**
 * 模块:     基数药补货
 * 编写日期: 2018-06-22
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId= session['LOGON.HOSPID'];
var ReqUserId = SessionUser;
var ReqId = "";
var BddId = "1";
$(function() {
    InitDict();
    InitGridBddItm();
    SetDefaultData();
    $("#btnSave").on("click", Save)
        //window.resizeTo(screen.availWidth, (screen.availHeight));
});

function InitDict() {
    DHCPHA_HUI_COM.ComboBox.Init({ Id: 'cmbReqLoc', Type: 'CtLoc' }, {
        onLoadSuccess: function() {
            $("#cmbReqLoc").combobox("setValue", SessionLoc);
            $("#cmbReqLoc").combobox("readonly")
        },
        width: 200
    });
    DHCPHA_HUI_COM.ComboBox.Init({ Id: 'cmbProLoc', Type: 'CtLoc' }, {
        width: 200,
        onBeforeLoad: function(param) {
            param.inputStr = "D";
            param.filterText = param.q;
			param.hosp = HospId;
        }
    });
    DHCPHA_HUI_COM.ComboBox.Init({
        Id: 'cmbReqType',
        data: {
            data: [
                { "RowId": "1", "Description": "基数补货" },
                { "RowId": "2", "Description": "精神毒麻补货" },
                { "RowId": "3", "Description": "大输液补货" }
            ]
        }
    }, {
        mode: "local",
        editable: false,
        readonly: true
    });
    if (LoadReqType != "") {
        $("#cmbReqType").combobox("setValue", LoadReqType);
    }
}

/// 设置默认信息
function SetDefaultData() {
    var typeCode = "";
    if (LoadReqType == 2) {
        typeCode = "JSDM";
    } else if (LoadReqType == 1) {
        typeCode = "BASEDRUG";
    }
    var defaultData = tkMakeServerCall("web.DHCSTBASEDRUG", "GetBaseDrugDispDateScope", SessionLoc, typeCode);
    if (defaultData != "") {
        var defaultDataArr = defaultData.split("^");
        $("#dateStart").datebox("setValue", defaultDataArr[0]);
        $("#dateEnd").datebox("setValue", defaultDataArr[1]);
        $("#timeStart").timespinner("setValue", defaultDataArr[2]);
        $("#timeEnd").timespinner("setValue", defaultDataArr[3]);
    }
}

// 申请单明细列表
function InitGridBddItm() {
    var columns = [
        [
            { field: 'bddItmId', title: 'bddItmId', width: 200, halign: 'center', hidden: true },
            { field: 'reqItmId', title: 'reqItmId', width: 200, halign: 'center', hidden: true },
            {
                field: 'incCode',
                title: '药品代码',
                width: 120,
                halign: 'center'
            },
            {
                field: 'incDesc',
                title: '药品名称',
                width: 400,
                halign: 'center'
            },
            {
                field: 'reqQty',
                title: '请求数量',
                width: 75,
                halign: 'center',
                align: 'right'
            },
            {
                field: 'consumeQty',
                title: '销售数量',
                width: 75,
                halign: 'center',
                align: 'right'
            },

            {
                field: 'reqUomDesc',
                title: '单位',
                width: 100,
                halign: 'center'
            },
            {
                field: 'incRowId',
                title: '药品Id',
                width: 400,
                halign: 'center',
                hidden: true
            },
            {
                field: 'reqUomId',
                title: '单位Id',
                width: 100,
                halign: 'center',
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        fit: true,
        border: false,
        singleSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 1000,
        pageList: [1000, 100, 300, 500],
        pagination: false,
        onLoadSuccess: function() {

        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridBddItm", dataGridOption);
}

// 查询明细
function QueryDetail() {
    if (BddId != "") {
        $('#gridBddItm').datagrid({
            url: $URL,
            queryParams: {
                ClassName: "web.DHCINPHA.WardBaseDrug",
                QueryName: "QueryBaseDrugDispItm",
                inputStr: BddId
            }
        });
    }
    if (ReqId != "") {
        $("#txtReqNo").val(tkMakeServerCall("web.DHCSTBASEDRUG", "GetReqNo", ReqId))
    }
}

// 保存补货单
function Save() {
    var proLocId = $("#cmbProLoc").combobox("getValue") || "";
    if (proLocId == "") {
        $.messager.alert("提示", "请先选择供给科室", "warning");
        return;
    }
    var reqLocId = $("#cmbReqLoc").combobox("getValue") || "";
    if (reqLocId == "") {
        $.messager.alert("提示", "请先选择请求科室", "warning");
        return;
    }
    var startDate = $("#dateStart").datebox("getValue");
    var startTime = $("#timeStart").timespinner("getValue");
    var endDate = $("#dateEnd").datebox("getValue");
    var endTime = $("#timeEnd").timespinner("getValue");
    var reqTypeId = $("#cmbReqType").combobox("getValue");
    var reqTypeCode = "";
    if (reqTypeId == 2) {
        reqTypeCode = "JSDM";
    } else if (reqTypeId == 1) {
        reqTypeCode = "BASEDRUG";
    }
    var saveRet = tkMakeServerCall("web.DHCSTBASEDRUG", "CreateBaseDrugDispData", reqLocId, proLocId, startDate, startTime, endDate, endTime, SessionUser, reqTypeCode);
    var saveRetArr = saveRet.split("^")
    if (saveRet == -9) {
        $.messager.alert("提示", "请先处理未完成的基数药请领单", "warning");
        return;
    }
    if (saveRetArr[0] > 0) {
        $.messager.alert("提示", "生成成功", "info ");
        // 刷新明细
        ReqId = saveRetArr[0];
        BddId = saveRetArr[1];
        QueryDetail();

    } else if (saveRetArr[0] == "-1001") {
        $.messager.alert("提示", "条件范围内无可用保存数据", "warning");
    }else if (saveRetArr[0] == "-1002") {
	    if (saveRetArr[1]!=""){
        	$.messager.alert("提示", saveRetArr[1], "warning");
	    }else{
			$.messager.alert("提示", "条件范围内无可用保存数据", "warning");
		}
    }else {
        $.messager.alert("提示", "生成失败" + saveRet, "info");
    }
}