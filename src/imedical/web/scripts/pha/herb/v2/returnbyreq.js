/**
 * 模块:     草药申请单退药
 * 编写日期: 2020-12-17
 * 编写人:   MaYuqiang
 */
PHA_COM.Val.CAModelCode = "PHAHERBRETURN"; 
var DefPhaLocInfo = tkMakeServerCall("web.DHCSTKUTIL", "GetDefaultPhaLoc", gLocId);
var DefPhaLocId = DefPhaLocInfo.split("^")[0] || "";
var DefPhaLocDesc = DefPhaLocInfo.split("^")[1] || "";
var ComPropData		// 公共配置
var AppPropData		// 模块配置
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
    PHA_COM.SetPanel('#pha_herb_v2_retbyreq', $('#pha_herb_v2_retbyreq').panel('options').title);
    InitDict();
    InitSetDefVal();
    InitGridRequest();
    InitGridReturnDetail();
    
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
    //$("#btnPrint").on("click", Print);
    $("#btnReturn").on("click", ClickReturnBtn); 
    $("#btnRefReturn").on("click", RefuseReturn);
    $("#txtPatName").validatebox("setDisabled",true);
});

/**
 * 给控件赋初始值
 * @method InitSetDefVal
 */
 function InitSetDefVal() {
	//界面配置
	// 公共设置
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
		}, false)

    $("#dateColStart").datebox("setValue", ComPropData.ReturnStartDate);
    $("#dateColEnd").datebox("setValue", ComPropData.ReturnEndDate);
	$('#timeColStart').timespinner('setValue', "00:00:00");
	$('#timeColEnd').timespinner('setValue', "23:59:59");
	$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultLoc4Req);
}

function InitDict() {
	/// 病区列表
	PHA.ComboBox("cmbWard", {
		url: PHA_STORE.WardLoc().url,
		width: 160,
		onLoadSuccess: function(){
			if (gWardID!==""){
				$("#cmbWard").combobox("setValue", gWardID);
			}
		}		
	});
	/// 药房列表
	PHA.ComboBox("cmbPhaLoc", {
		url: PHA_STORE.Pharmacy().url,
		onLoadSuccess: function(){
			//$("#cmbPhaLoc").combobox("setValue", gLocId);
		},
		onSelect: function (selData) {
            QueryRetRequest();
		}
	});
	/// 就诊类型
	PHA.ComboBox("cmbAdmType", {
		data: [{
			RowId: "O^E",
			Description: $g("门急诊")
		}, {
			RowId: "I",
			Description: $g("住院")
		}],
		panelHeight: "auto"
	});
	
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
                field: 'prescNo',
                title: '处方号',
                width: 130
            },{
                field: 'reqDate',
                title: '申请日期',
                width: 100
            },{
                field: 'wardDesc',
                title: '就诊科室/病区(床号)',
                width: 160
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
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        border: false,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        toolbar: '#gridReturnBar',
        onUncheck: function (rowIndex, rowData) {
            if (rowData) {
                QueryReturnDetail();
            }
        },
        onCheck: function (rowIndex, rowData) {
            if (rowData) {
                QueryReturnDetail();
            }
        },
        onUncheckAll: function () {
            QueryReturnDetail();
        },
        onCheckAll: function () {
            QueryReturnDetail();
        },
        onLoadSuccess: function () {
            $('#gridReturnDetail').datagrid('clear');
            $('#gridReturnDetail').datagrid('uncheckAll');
            $('#gridRequest').datagrid('uncheckAll');
        }
    }
	PHA.Grid("gridRequest", dataGridOption);
}

// 获取参数
function GetQueryParamsJson(){
    var patNo = $('#txtPatNo').val();
    if (patNo == ""){
        $("#txtPatName").val("");
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
        refundFlag: ($('#advrefundflag').checkbox('getValue')==true?'Y':'N')     
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
            ClassName: "PHA.HERB.Return.Query",
            QueryName: "GetRetRequestList",
            pJsonStr: JSON.stringify(pJson)
        }
    });
}

// 申请单明细列表
function InitGridReturnDetail() {
    var columns = [
        [	/*{
                field: 'detailCheck',
                checkbox: true
            },
            */{
                field: 'reqItmRowId',
                title: 'reqItmRowId',
                width: 80,
                halign: 'center',
                hidden: true
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
                field: 'reasonDesc',
                title: '退药原因',
                width: 140
            },{
                field: 'reasonId',
                title: '退药原因',
                width: 140,
                hidden: true
            },{
                field: 'batNo',
                title: '发药批号',
                width: 100
            },{
                field: 'expDate',
                title: '效期',
                width: 100
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
                align: 'center',
                hidden: true
            },{
                field: 'reqTime',
                title: '申请时间',
                width: 100,
                hidden: true
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
            },{
                field: 'phbdicId',
                title: '草药业务孙表',
                width: 80,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: "",
        fit: true,
        border: false,
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 999,
        pageList: [999],
        pagination: true,
        toolbar: '', 	//'#gridReturnDetailBar',
        onLoadSuccess: function () {
	        var rows = $("#gridReturnDetail").datagrid("getRows");
	        if (rows.length>0){
            	$('#gridReturnDetail').datagrid('checkAll');
	        }
        }
    }
	PHA.Grid("gridReturnDetail", dataGridOption);
}
// 查询明细
function QueryReturnDetail() {
    var reqIdStr = GetCheckedReqId();
    if ((reqIdStr == null) || (reqIdStr == "")) {
        //$.messager.alert("提示", "请先选择记录", "warning");
        //return;
    }
    $('#gridReturnDetail').datagrid({
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
function GetCheckedReturnItmArr() {
    var retItmArr = [];
    //var gridReqDetailChecked = $('#gridReturnDetail').datagrid('getChecked');
    var gridReqDetailRows = $("#gridReturnDetail").datagrid("getRows");
    for (var i = 0; i < gridReqDetailRows.length; i++) {
        var checkedData = gridReqDetailRows[i] ;
        var reqItmRowId = checkedData.reqItmRowId ;
        var dspBatchId = checkedData.dspBatch ;
        var retQty = checkedData.reqQty ;
        var retReasonId = checkedData.reasonId ;
        var phbdicId = checkedData.phbdicId ;
        var sp = checkedData.sp ;
        var spAmt = checkedData.spAmt ;
        var prescNo = checkedData.prescNo ;
        var detail = reqItmRowId +"^"+ dspBatchId +"^"+ retQty +"^"+ retReasonId +"^"+ phbdicId +"^"+ sp +"^"+ spAmt +"^"+ prescNo
        if (retItmArr.indexOf(detail) < 0) {
            retItmArr.push(detail);
        }
    }
    return retItmArr.join(",");
}

/// 点击退药按钮
function ClickReturnBtn(){
	PHA_COM.CACert("PHAHERBRETURN", DoReturn);	
}

function DoReturn(){
    var returnItmArr = GetCheckedReturnItmArr()
    if ((returnItmArr == null) || (returnItmArr == "")) {
        $.messager.alert("提示", "请先选择需要退药的记录", "warning");
        return;
    }
    var phaLocId = $('#cmbPhaLoc').combobox("getValue") ;
    var userId = gUserID ;

    $.m({
		ClassName: "PHA.HERB.Return.Save",
		MethodName: "SaveMulti",
        paramsStr: returnItmArr ,
        phaLocId: phaLocId ,
        userId: userId
	}, function (retData) {
		var retArr = retData.split("^")
        var retVal = retArr[0];
		if (retVal < 0) {
			$.messager.alert('提示', retArr[1], 'warning');
			return;
        }
        else {
            var intrType = "YH"
            PHA_COM.SaveCACert({
                signVal: retVal,
                type: intrType
            })
            HERB_PRINTCOM.ReturnDoc(retVal, '');
        }
        QueryRetRequest() ;
		QueryReturnDetail() ;
	});

}

function RefuseReturn(){
    $.messager.alert("提示", "尚未开发", "info");

}
