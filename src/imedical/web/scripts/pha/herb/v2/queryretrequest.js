/**
 * 模块:     草药退药申请单查询
 * 编写日期: 2020-11-30
 * 编写人:   MaYuqiang
 */
var DefPhaLocInfo = tkMakeServerCall("web.DHCSTKUTIL", "GetDefaultPhaLoc", gLocId);
var DefPhaLocId = DefPhaLocInfo.split("^")[0] || "";
var DefPhaLocDesc = DefPhaLocInfo.split("^")[1] || "";
var AppPropData;	// 模块配置
var ComPropData;	// 公共配置
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
var comWidth = 160 ;
DHCPHA_CONSTANT.VAR.SELECT = "";
DHCPHA_CONSTANT.VAR.UNSELECT = "";

$(function () {
    InitDict();
    InitSetDefVal();
    InitGridRequest();
    InitGridRequestDetail();
    $('#txtPatNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#txtPatNo").val());
            if (patNo != "") {
                var newPatNo = NumZeroPadding(patNo,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newPatNo);
                var patInfo = tkMakeServerCall("web.DHCSTPharmacyCommon", "GetPatInfoByNo", newPatNo);
                $("#txtPatName").val(patInfo.split("^")[0] || "");
                QueryRetRequest();
            } else {
                $("#txtPatName").val("");
            }
        }
    });
    $("#btnFind").on("click", QueryRetRequest);
    $("#btnPrint").on("click", Print);
    $("#btnDefaultLoc").on("click", SetDefaultLoc);
    $("#btnDelReqItm").on("click", DeleteReqItm);
    if (LoadAdmId != "") {
        var patInfo = tkMakeServerCall("web.DHCINPHA.Request", "PatInfo", LoadAdmId);
        $("#txtPatNo").val(patInfo.split("^")[0] || "");
        $("#txtPatName").val(patInfo.split("^")[1] || "");
    }
    $("#txtPatName").validatebox("setDisabled",true);
    //window.resizeTo(screen.availWidth - 6, (screen.availHeight - 100));
    //window.moveTo(3, 90);
});

function InitDict() {
    if (session['LOGON.WARDID'] == ""){
        var disableState = false
    }
    else {
        var disableState = true
    }
    /// 病区列表
    PHA.ComboBox("cmbWard", {
        url: PHA_STORE.WardLoc().url,
        width: comWidth,
        disabled: disableState,
        onLoadSuccess: function(){
            if (gWardID!==""){
                $("#cmbWard").combobox("setValue", gLocId);
            }
        }       
    });
    /// 药房列表
    PHA.ComboBox("cmbPhaLoc", {
        url: PHA_STORE.Pharmacy().url,
        width: comWidth,
        onLoadSuccess: function(){
            
        },
        onSelect: function (selData) {
            //QueryData();
        }
    });
    /// 就诊类型
    PHA.ComboBox("cmbAdmType", {
        data: [{
            RowId: "O",
            Description: $g("门急诊")
        }, {
            RowId: "I",
            Description: $g("住院")
        }],
        panelHeight: "auto",
        width:comWidth
    });
    
}

/**
 * 患者列表, 勾选或者取消勾选时
 */
function patientTreeCheckChangeHandle() {
    LoadAdmId = EpisodeIDStr;
    QueryRetRequest();
}

/**
 * 给控件赋初始值
 * @method InitSetDefVal
 */
function InitSetDefVal() {
	// 公共设置
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
		}, false)

    $("#dateColStart").datebox("setValue", ComPropData.QueryStartDate);
    $("#dateColEnd").datebox("setValue", ComPropData.QueryEndDate);
    $('#timeColStart').timespinner('setValue', ComPropData.QueryStartTime);
    $('#timeColEnd').timespinner('setValue', ComPropData.QueryEndTime);
    $("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultLoc4Req);

}
// 申请单列表
function InitGridRequest() {
    var columns = [
        [{
                field: 'reqSelect',
                checkbox: true
            },{
                field: 'phbrrId',
                title: '草药退药申请单Id',
                width: 50,
                hidden:true 
            },{
                field: 'status',
                title: '状态',
                width: 80,
                styler: function (value, row, index) {
                    var status = row.retStatus;
                    if (status == $g("退药完成")) {
                        return 'background-color:#47CE27;color:#FFFFFF;';
                    } else if (status == $g("尚未退药")) {
                        return 'background-color:#F68300;color:#FFFFFF;';
                    }
                },
                formatter: function (value, row, index) {
                    var status = row.retStatus;
                    return status;
                }
            },{
                field: 'reqNo',
                title: '处方号',
                width: 130
            },{
                field: 'reqDate',
                title: '申请日期',
                width: 100
            },{
                field: 'wardDesc',
                title: '就诊科室/病区(床号)',
                width: 140
            },{
                field: 'reqUserName',
                title: '申请人',
                width: 75
            },{
                field: 'patNo',
                title: '患者登记号',
                width: 120
            },{
                field: 'patName',
                title: '患者姓名',
                width: 80
            },{
                field: 'reqTime',
                title: '申请时间',
                width: 100
            },{
                field: 'retStatus',
                title: '退药状态',
                width: 100,
                hidden: true
            }
            /*,
            {
                field: 'refundStatus',
                title: '退费状态',
                width: 100,
                hidden: true
            }
            */
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        toolbar: [],
        onUncheck: function (rowIndex, rowData) {
            if (rowData) {
                QueryRetReqDetail();
            }
        },
        onCheck: function (rowIndex, rowData) {
            if (rowData) {
                QueryRetReqDetail();
            }
        },
        onUncheckAll: function () {
            QueryRetReqDetail();
        },
        onCheckAll: function () {
            QueryRetReqDetail();
        },
        onLoadSuccess: function () {
            $('#gridRequestDetail').datagrid('clear');
            $('#gridRequest').datagrid('uncheckAll');
        }
    }
    PHA.Grid("gridRequest", dataGridOption);
}

// 获取参数
function GetQueryParamsJson(){
    var admIdStr = EpisodeIDStr.split('^').join(',');
    var patNo = $('#txtPatNo').val()
    if (patNo !== '') {
        admIdStr = '';
    }
    return {
        startDate: $("#dateColStart").datebox('getValue'),
        endDate: $("#dateColEnd").datebox('getValue'),
        startTime: $('#timeColStart').timespinner('getValue'),
        endTime: $('#timeColEnd').timespinner('getValue'),
        loc: $('#cmbPhaLoc').combobox("getValue"),
        patNo: patNo,
        wardLocId: $('#cmbWard').combobox("getValue"),
        admType: $('#cmbAdmType').combobox("getValue"),
        refundFlag: ($('#advrefundflag').checkbox('getValue')==true?'Y':'N'), 
        admIdStr: admIdStr    
    };
    

}
// 查询
function QueryRetRequest() {
    var pJson = GetQueryParamsJson();
    if (pJson == "") {
        return;
    }
    $('#gridRequest').datagrid({
        url: $URL,
        queryParams: {
            ClassName: "PHA.HERB.Request.Query",
            QueryName: "GetRetRequestList",
            pJsonStr: JSON.stringify(pJson)
        }
    });
}

// 申请单明细列表
function InitGridRequestDetail() {
    var columns = [
        [{
                field: 'detailCheck',
                checkbox: true
            },{
                field: 'reqItmRowId',
                title: 'reqItmRowId',
                width: 80,
                halign: 'center',
                hidden: true
            },{
                field: 'status',
                title: '状态',
                width: 80,
                styler: function (value, row, index) {
                    var status = row.retiStatus;
                    if (status == $g("退药完成")) {
                        return 'background-color:#47CE27;color:#FFFFFF;';
                    } else if (status == $g("尚未退药")) {
                        return 'background-color:#F68300;color:#FFFFFF;';
                    }
                },
                formatter: function (value, row, index) {
                    var status = row.retiStatus;
                    return status;
                }
            },{
                field: 'inciDesc',
                title: '药品名称',
                width: 180
            },{
                field: 'bUomDesc',
                title: '单位',
                width: 50
            },{
                field: 'reqQty',
                title: '申请数量',
                width: 70,
                halign: 'left',
                align: 'right',
                hidden: false
            },{
                field: 'reasonDesc',
                title: '退药原因',
                width: 140
            },{
                field: 'retiStatus',
                title: '退药状态',
                width: 80,
                hidden: true
            },{
                field: 'batNo',
                title: '发药批号',
                width: 80,
                hidden: true
            },{
                field: 'expDate',
                title: '效期',
                width: 80,
                hidden: true
            },{
                field: 'retQty',
                title: '已退数量',
                width: 70,
                halign: 'left',
                align: 'right'
            },{
                field: 'surQty',
                title: '未退数量',
                width: 70,
                halign: 'left',
                align: 'right'
            },{
                field: 'sp',
                title: '售价',
                width: 70,
                halign: 'left',
                align: 'right'
            },{
                field: 'spAmt',
                title: '售价金额',
                width: 70,
                halign: 'left',
                align: 'right'
            },{
                field: 'manfDesc',
                title: '生产企业',
                width: 200,
                align: 'left'
            },{
                field: 'reqDate',
                title: '申请日期',
                width: 100,
                align: 'center'
            },{
                field: 'reqTime',
                title: '申请时间',
                width: 100
            },{
                field: 'prescNo',
                title: '处方号',
                width: 120,
                hidden: false
            },{
                field: 'encryptLevel',
                title: '病人密级',
                width: 80,
                align: 'left',
                hidden: true
            },{
                field: 'patLevel',
                title: '病人级别',
                width: 80,
                align: 'left',
                hidden: true
            },{
                field: 'dspBatch',
                title: 'dspBatch',
                width: 80,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 999,
        pageList: [999],
        pagination: false,
        toolbar: "#gridRequestDetailBar",
        onSelect: function (rowIndex, rowData) {

        },
        onUnselect: function (rowIndex, rowData) {

        },
        onLoadSuccess: function () {
            $('#gridRequestDetail').datagrid('uncheckAll');
        },
        onCheck: function (rowIndex, rowData) {
            if (DHCPHA_CONSTANT.VAR.UNSELECT != "") {
                return;
            }
            DHCPHA_CONSTANT.VAR.UNSELECT = 1;
            SelectLinkOrder(rowIndex);
            DHCPHA_CONSTANT.VAR.UNSELECT = "";
        },
        onUncheck: function (rowIndex, rowData) {
            if (DHCPHA_CONSTANT.VAR.UNSELECT != "") {
                return;
            }
            DHCPHA_CONSTANT.VAR.UNSELECT = 1;
            UnSelectLinkOrder(rowIndex);
            DHCPHA_CONSTANT.VAR.UNSELECT = "";
        }
    }
    PHA.Grid("gridRequestDetail", dataGridOption);
}
// 查询明细
function QueryRetReqDetail() {
    var reqIdStr = GetCheckedReqId();
    if ((reqIdStr == null) || (reqIdStr == "")) {
        //$.messager.alert("提示", "请先选择记录", "warning");
        //return;
    }
    $('#gridRequestDetail').datagrid({
        url: $URL,
        queryParams: {
            ClassName: "PHA.HERB.Request.Query",
            QueryName: "GetRetRequestDetail",
            params: reqIdStr
        }
    });
}

// 获取选中记录的申请单Id
function GetCheckedReqId() {
    var reqIdArr = [];
    var gridRequestChecked = $('#gridRequest').datagrid('getChecked');
    for (var i = 0; i < gridRequestChecked.length; i++) {
        var checkedData = gridRequestChecked[i];
        var reqId = checkedData.phbrrId;
        if (reqIdArr.indexOf(reqId) < 0) {
            reqIdArr.push(reqId);
        }
    }
    return reqIdArr.join(",");
}
// 获取选中记录的申请明细的id
function GetCheckedReqItmArr() {
    var reqItmArr = [];
    var gridReqDetailChecked = $('#gridRequestDetail').datagrid('getChecked');
    for (var i = 0; i < gridReqDetailChecked.length; i++) {
        var checkedData = gridReqDetailChecked[i];
        var reqItmRowId = checkedData.reqItmRowId;
        if (reqItmArr.indexOf(reqItmRowId) < 0) {
            reqItmArr.push(reqItmRowId);
        }
    }
    return reqItmArr.join("^");
}

function DeleteReqItm() {
    var reqItmIdStr = GetCheckedReqItmArr();
    if (reqItmIdStr == "") {
        $.messager.alert("提示", "请先勾选需要删除的记录", "warning");
        return;
    }
    $.messager.confirm("删除提示", "您确认删除明细吗?", function (r) {
        if (r) {
            var delRet = tkMakeServerCall("PHA.HERB.Request.Save","DelReqDetailData", reqItmIdStr);
            var delRetArr = delRet.split("^");
            var delVal = delRetArr[0];
            var delInfo = delRetArr[1];
            if (delVal < 0) {
                $.messager.alert("提示", delInfo, "warning");
                //return;
            }
            QueryRetRequest();
            QueryRetReqDetail();
        }
    });


}

function SetDefaultLoc() {
    $.messager.alert("提示", "尚未开发", "info");
    /*
    var PhaLoc = $('#cmbPhaLoc').combobox("getValue") || "";
    var PhaLocDesc = $('#cmbPhaLoc').combobox("getText") || "";
    if (PhaLoc == "") {
        //$.messager.alert("提示", "请先选择发药科室", "warning");
        //return;
    }
    if (SessionLoc == "") {
        return;
    }
    var confirmText = "确认将 " + PhaLocDesc + " 设置成默认科室吗?";
    if (PhaLoc == "") {
        confirmText = "确认默认科室设置为空吗?";
    }
    $.messager.confirm("确认提示", confirmText, function (r) {
        if (r) {
            var saveRet = tkMakeServerCall("web.DHCSTRETREQUEST", "SetDefaultPhaLoc", PhaLoc, SessionLoc);
            var saveArr = saveRet.split("^");
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal == 0) {
                $.messager.alert("提示", "设置成功", "info");
                return;
            }
        }
    });
    */
}

/// 打印申请单
function Print() {
    var gridRequestChecked = $('#gridRequest').datagrid('getChecked');
    if (gridRequestChecked.length == 0){
        $.messager.alert("提示", "请先选中需要打印的申请单", "info");
         return;
    }
    for (var i = 0; i < gridRequestChecked.length; i++) {
        var checkedData = gridRequestChecked[i];
        var reqId = checkedData.phbrrId;
        HERB_PRINTCOM.RequestDoc(reqId, '补');
    }
    
    
}



//关联医嘱选中
function SelectLinkOrder(id) {
    var rows = $("#gridRequestDetail").datagrid("getRows");
    if (rows.length == 0) {
        return;
    }
    var prescNo = rows[id].prescNo;
    for (var i = 0; i < rows.length; i++) {
        if (id == i) {
            continue;
        }
        var tmpPrescNo = rows[i].prescNo;
        if (tmpPrescNo == prescNo) {
            $("#gridRequestDetail").datagrid("selectRow", i);
        }
    }
    DHCPHA_CONSTANT.VAR.SELECT = "";
}

//关联医嘱取消选中
function UnSelectLinkOrder(sRowIndex) {
    var rows = $("#gridRequestDetail").datagrid("getRows");
    if (rows.length == 0) {
        return;
    }
    var prescNo = rows[sRowIndex].prescNo;
    for (var num = 0; num < rows.length; num++) {
        if (sRowIndex === num) {
            continue;
        }
        var tmpPrescNo = rows[num].prescNo;
        if (tmpPrescNo == prescNo) {
        	$("#gridRequestDetail").datagrid("unselectRow", num);
        }
    }
    DHCPHA_CONSTANT.VAR.UNSELECT = "";
    
}
