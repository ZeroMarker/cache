/**
 * 模块:     草药申请单退药（处方预览模式）
 * 编写日期: 2022-09-26
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
    PHA_COM.SetPanel('#pha_herb_v2_retbyreqprescmode', $('#pha_herb_v2_retbyreqprescmode').panel('options').title);
    InitDict();
    InitGridRequest();
    InitSetDefVal();
    InitEvent();
    ResizePanel();
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

/* 按钮事件 */
function InitEvent(){
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
    $("#btnReturn").on("click", ClickReturnBtn);
    $("#txtPatName").validatebox("setDisabled",true);
}

// 布局调整
function ResizePanel(){
    setTimeout(function () {    
        var flag = 0.4;
        if(PHA_COM.Window.Width()<1500 ){flag = 0.5}         
        PHA_COM.ResizePanel({
            layoutId: 'layout-herb—grid',
            region: 'west',
            width: flag
        });
        PHA_COM.ResizePanel({
            layoutId: 'layout-herb—grid-list',
            region: 'south',
            height: 0.6 
        });
    }, 0);
}

// 申请单列表
function InitGridRequest() {
    var columns = [
        [	{
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
        onClickRow: function (rowIndex, rowData) {
			var prescNo = rowData.prescNo;
			PrescView(prescNo);
		},
        onLoadSuccess: function () {
            var rows = $("#gridRequest").datagrid("getRows");
		    if (rows.length > 0) {
				$('#gridRequest').datagrid('selectRow', 0);
				var gridSelectRows = $("#gridRequest").datagrid("getSelections") ;
				var gridSelect = gridSelectRows[0] ;
				var prescNo = gridSelect.prescNo;
				PrescView(prescNo);
			}
        }
    }
	PHA.Grid("gridRequest", dataGridOption);
}

/**
 * 处方预览
 * @method PrescView
 */
function PrescView(prescNo){
	if (prescNo == ""){
		$("#ifrm-PreViewPresc").attr("src", "");
		return;
	}

	var phbdType = "OP";
	if(prescNo.indexOf("I")>-1){
		phbdType = "IP";
	}
	var cyFlag = "Y";
	var zfFlag = "底方"
	var useFlag = "4"       // 已发药
    
	PHA_HERB.PREVIEW({
        prescNo: prescNo,           
        preAdmType: phbdType,
        zfFlag: zfFlag,
        prtType: 'DISPPREVIEW',
        useFlag: useFlag,
        iframeID: 'ifrm-PreViewPresc',
        cyFlag: cyFlag
    });
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
    PrescView("");
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


/// 打印退药单
function Print() {
	$.messager.alert("提示", "尚未开发", "info");
	
}

/// 点击退药按钮
function ClickReturnBtn(){
	PHA_COM.CACert("PHAHERBRETURN", DoReturn);	
}

function DoReturn(){
	var gridSelect = $("#gridRequest").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需退药的处方!","info");
		return;
	}
	var phbrrId = gridSelect.phbrrId ;
	var prescNo = gridSelect.prescNo ;
	var userId = gUserID ;
	var reasonId = ""

    $.m({
		ClassName: "PHA.HERB.Return.Biz",
		MethodName: "ReturnPresc",
        phbrrId: phbrrId ,
        prescNo: prescNo ,
        userId: userId,
        reasonId: ''
	}, function (retData) {
		var retArr = retData.split("^")
        var retVal = retArr[0];
		if (retVal < 0) {
			$.messager.alert('提示', retArr[1], 'warning');
			return;
        }
        else {
            if (prescNo.indexOf("I") > -1){
                var intrType = "YH"
            }
            else {
                var intrType = "HH"
            }
            PHA_COM.SaveCACert({
                signVal: retVal,
                type: intrType
            })
            HERB_PRINTCOM.ReturnDoc(retVal, '');
        }
        QueryRetRequest() ;
        PrescView();
	});

}

