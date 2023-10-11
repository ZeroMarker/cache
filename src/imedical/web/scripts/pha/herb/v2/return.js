/**
 * 模块:     草药直接退药
 * 编写日期: 2022-09-26
 * 编写人:   MaYuqiang
 */
PHA_COM.Val.CAModelCode = "PHAHERBRETURN"; 
var DefPhaLocInfo = tkMakeServerCall("web.DHCSTKUTIL", "GetDefaultPhaLoc", gLocId);
var DefPhaLocId = DefPhaLocInfo.split("^")[0] || "";
var DefPhaLocDesc = DefPhaLocInfo.split("^")[1] || "";
var ComPropData		// 公共配置
var AppPropData		// 模块配置
var SelAdmType
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	PHA_COM.SetPanel('#pha_herb_v2_return', $('#pha_herb_v2_return').panel('options').title);
    InitDict();
	InitSetDefVal();
    InitGridDisp();
	ResizePanel();
    $('#txtPatNo').on('keypress', function (event) {
        if (window.event.keyCode == "13") {
            var patNo = $.trim($("#txtPatNo").val());
            if (patNo != "") {
				var newPatNo = NumZeroPadding(patNo,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newPatNo);
                var patInfo = tkMakeServerCall("web.DHCSTPharmacyCommon", "GetPatInfoByNo", newPatNo);
                $("#txtPatName").val(patInfo.split("^")[0] || "");
                QueryDispPresc();
            } else {
                $("#txtPatName").val("");
            }
        }
    });
    $("#btnFind").on("click", QueryDispPresc);
    $("#btnPrint").on("click", Print);
    $("#btnReturn").on("click", ClickReturnBtn);
	$("#txtPatName").validatebox("setDisabled",true);
});

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
	/// 药房列表
	PHA.ComboBox("cmbPhaLoc", {
		url: PHA_STORE.Pharmacy().url,
		onLoadSuccess: function(){
			//$("#cmbPhaLoc").combobox("setValue", gLocId);
		},
		onSelect: function (selData) {
            //QueryDispPresc();
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
		panelHeight: "auto"
	});
}

// 已发处方列表
function InitGridDisp() {
    var columns = [
        [	
        	{
                field: 'TPhbdId',
                title: '发药主表Id',
                width: 50,
				hidden:true 
            },{
                field: 'TPmiNo',
				title: '登记号',
				align: 'left',
				width: 100,
				formatter: function (value, row, index) {
                    var qOpts = "{AdmId:'" + row.TAdm + "'}";
                    return '<a class="pha-grid-a" onclick="PHA_UX.AdmDetail({},' + qOpts + ')">' + value + '</a>';
                }
            },{
                field: 'TPatName',
                title: '患者姓名',
                width: 120
            },{
                field: 'TPrescNo',
				title: '处方号',
				align: 'left',
				width: 130
            },{
				field: 'TState',
				title: '当前状态',
				align: 'left',
				width: 90
			},{
                field: 'TPatLoc',
                title: '就诊科室/病区(床号)',
                width: 160
            },{
				field: 'TPrescAmt',
				title: '处方金额',
				align: 'left',
				width: 80
			},{
				field: 'TPrescForm',
				title: '处方剂型',
				align: 'left',
				width: 80
			},{
				field: 'TPreDur',
				title: '疗程(付数)',
				align: 'left',
				width: 100
			},{
				field: 'TCookType',
				title: '煎药方式',
				align: 'left',
				width: 80
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
        toolbar: '#gridDispBar',
        onClickRow: function (rowIndex, rowData) {
			var prescNo = rowData.TPrescNo;
			if (prescNo.indexOf("I")>-1){	
				SelAdmType = "I"	
			}
			else {
				SelAdmType = "O"	
			}
			PrescView(prescNo);
			
		},
        onLoadSuccess: function () {
            var rows = $("#gridDispPresc").datagrid("getRows");
		    if (rows.length > 0) {
				$('#gridDispPresc').datagrid('selectRow', 0);
				var gridSelectRows = $("#gridDispPresc").datagrid("getSelections") ;
				var gridSelect = gridSelectRows[0] ;
				var prescNo = gridSelect.TPrescNo;
				if (prescNo.indexOf("I")>-1){	
					SelAdmType = "I"	
				}
				else {
					SelAdmType = "O"	
				}
				PrescView(prescNo);
			}
        }
    }
	PHA.Grid("gridDispPresc", dataGridOption);
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
	var dispFlag = "OK"
	if (dispFlag !== "OK"){
        var useFlag = "3"       // 未发药
    }
    else {
        var useFlag = "4"       // 已发药
    }

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
	var prescNo = $('#txtPrescNo').val(); 
	if ((patNo == "")&&(prescNo == "")){
		$.messager.alert("提示", "请按照登记号或者处方号查询！", "info");
		return
	}
	if (patNo == ""){
		$("#txtPatName").val("");
	}
	var dispDictId = tkMakeServerCall("PHA.HERB.Com.Method", "GetDictId", "Dispen")
	return {
		startDate: $("#dateColStart").datebox('getValue'),
        endDate: $("#dateColEnd").datebox('getValue'),
        startTime: $('#timeColStart').timespinner('getValue'),
        endTime: $('#timeColEnd').timespinner('getValue'),
        phaLocId: $('#cmbPhaLoc').combobox("getValue"),
        patNo: $('#txtPatNo').val(),
        //patName: $('#txtPatName').val(),
        prescNo: $('#txtPrescNo').val() ,
        curState: dispDictId,
		queryMenu: "return"  
    };
	

}
// 查询
function QueryDispPresc() {
	PrescView("") ;
    var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
    $('#gridDispPresc').datagrid({
        url: $URL,
        queryParams: {
            ClassName: "PHA.HERB.Query.Dispen",
            QueryName: "GetPrescList",
            pJsonStr: JSON.stringify(pJson)
        }
    });
}


/// 打印退药单
function Print() {
	$.messager.alert("提示", "重打退药单请到退药单查询界面打印", "info");
	
}

/// 点击退药按钮
function ClickReturnBtn(){
	var gridSelect = $("#gridDispPresc").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要退药的处方!","info");
		return;
	}
	var prescNo = gridSelect.TPrescNo ;
	// 门诊处方直接退药是需判断计费退费设置
	if (prescNo.indexOf("I")<0) {
		var refAppMode = tkMakeServerCall("PHA.FACE.IN.Com","IGetOPRefAppMode",session['LOGON.HOSPID'])
		if (refAppMode != 0){
			$.messager.alert('提示',"计费设置需退费申请方可退费，药房不能直接退药，请先修改计费配置后重试!","info");
			return;
		}
	}
	PHA_COM.CACert("PHAHERBRETURN", HandleReturn);	
}

function HandleReturn(){
	var gridSelect = $("#gridDispPresc").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需退的处方!","info");
		return;
	}
	var prescNo = gridSelect.TPrescNo ;
	var chkRet = tkMakeServerCall("PHA.HERB.Return.Biz", "CheckReturnState", "", prescNo)
	var chkRetArr = chkRet.split("^")
	if (chkRetArr[0] < 0) {
		$.messager.alert('提示', chkRetArr[1], 'warning');
		return;
	}
	SelRetReason("retReasonWin", ExecuteReturn);
}


function ExecuteReturn(ReasonJson){
	var gridSelect = $("#gridDispPresc").datagrid("getSelected");
	var phbdId = gridSelect.TPhbdId ;
	var prescNo = gridSelect.TPrescNo ;
	var userId = gUserID ;
	var reasonId = ReasonJson.reasonId ;
	if (reasonId == null){
		$.messager.alert('提示',"请先选择退药原因!","info");
		return;
	}

    $.m({
		ClassName: "PHA.HERB.Return.Biz",
		MethodName: "ReturnPresc",
        phbrrId: "" ,
        prescNo: prescNo ,
        userId: userId,
        reasonId: reasonId
	}, function (retData) {
		var retArr = retData.split("^")
		if (retArr[0] < 0) {
			$.messager.alert('提示', retArr[1], 'warning');
			return;
        }
		if (prescNo.indexOf("I") > -1){
			var intrType = "YH"
		}
		else {
			var intrType = "HH"
		}
		PHA_COM.SaveCACert({
			signVal: phbdId,
			type: intrType
		})
        QueryDispPresc() ;
	});

}

function SelRetReason(winId, _fn){
    var $widow = $('#' + winId);
	var marLeft = 10;
	var idText = $g("退药原因")
	var id = "retReasonId"
	var storeUrl = PHA_HERB_STORE.RetReasonStore(SelAdmType, gHospID).url; 
    if ($widow.length === 0){
        var $widow = $('<div id="'+ winId +'"></div>').appendTo('body');
        $widow.empty();
    }else{
        $('#'+ winId).dialog('open');
        return
    }

    var htmlStr = '<div class = "pha-row" style="margin-top:10px;text-align:center" >'
            +           '<div class="pha-col" style="margin-left:0px;padding-left:0px;">'+idText+'</div>'     
            +           '<div class="pha-col" style="margin-left:0px"><input id = "'+id+'" class = "hisui-combobox" ></div>'
            + '</div>'

    var $toolbar = $(htmlStr).prependTo('#'+ winId);
    PHA_COM.Window.Proportion = 1;
    $widow.dialog({
        collapsible: false,
        minimizable: false,
        maximizable: false,
        closable: true,
        closed: true,               
        modal: true,
        title:  "请选择"+idText,
        width: 300, 
        height: 150,                
        top: (PHA_COM.Window.Height()-250)/2 ,
        left:(PHA_COM.Window.Width()-400)/2 ,
        iconCls:'icon-w-paper',
        buttons:[{
            text:'确定',
            handler:function(){
                var reasonId = $("#"+id).combobox("getValue")||""
                if(reasonId == ""){
					$.messager.alert('提示', "请选择"+idText, 'warning');
                    return
                }
                var retJson = {reasonId:reasonId,reasonDesc:$("#"+id).combobox("getText")||""}
                $('#'+ winId ).dialog('close');
                _fn(retJson);
                
            }
        },{
            text:'关闭',
            handler:function(){$('#'+ winId ).dialog('close');}
        }],
		onOpen: function(){
            // 退药原因
            PHA.ComboBox(id,{
                editable:false, 
                url: PHA_HERB_STORE.RetReasonStore(SelAdmType, gHospID).url
            });
        }
    }); 
    $('#'+ winId ).dialog('open');
}

function RefuseReturn(){
    $.messager.alert("提示", "尚未开发", "info");

}
