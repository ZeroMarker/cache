/**
 * @模块:     煎药-门诊发放
 * @编写日期: 2019-07-24
 * @编写人:   pushuangcai
 */
var decNumber = "FF";	//煎药流程标识
var locId = session['LOGON.CTLOCID'];
var opUser = session['LOGON.USERID'];
$(function () {
	InitDict();
	InitGridPresc();
	InitGridDisped();
	$('#txtBarCode').on('keypress', function(event) {
        if (event.keyCode == "13") {
	        var barcode = $.trim($("#txtBarCode").val());
	        if(parseInt(barcode)>0){
	        	$(this).val(PHA_COM.FullPatNo(barcode));
		    }
	        queryPrescList(); 
	       	$("#txtBarCode").val("");
			$("#txtBarCode").focus();
        }
	});
	//登记号回车事件
	$('#txtPatNo').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txtPatNo").val());
			if (patno != "") {
				$(this).val(PHA_COM.FullPatNo(patno));
				queryDispedList();
			}
		}
	});
	$('#readCard').on('click', BtnReadCardHandler) ;
	// 绑定选中事件,切换页签自动查询
	$("#dispTab").tabs({
		onSelect: function(title, index){
			queryDispedList();
		}
	})
});

/**
 * 初始化组件
 * @method InitDict
 */
function InitDict() {
	var ComPropData = $.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.COMMON", 
		AppCode:""
		}, false)
	if(ComPropData.PrescView=="Y") { 
		DEC_PRESC.Layout("mainLayout", {width: ComPropData.PrescWidth});	//显示处方预览panel
	}
	PHA.ComboBox("cmbDecLoc", {
		width: '120',
		url: PHA_DEC_STORE.DecLoc().url,
		onLoadSuccess: function() {
			$("#cmbDecLoc").combobox("setValue", ComPropData.DefaultDecLoc);
		}  
	});
	PHA.ComboBox("cmbPhaLoc", {
		width: '120',
		url: PHA_DEC_STORE.Pharmacy("").url,
		onLoadSuccess: function() {
			$("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultPhaLoc);
		}
	});
	//卡类型
	PHA.ComboBox("cmbCardType", {
		width: '110',
		url: PHA_DEC_STORE.CardType("").url,
		onLoadSuccess: function(data) {
			var data = $("#cmbCardType").combobox("getData")
			$.each(data, function(key, val){
				var defaultflag = val.RowId.split("^")[8];
				if(defaultflag=="Y"){
					$("#cmbCardType").combobox("setValue", val.RowId);
				}
			})	
		} 
	});
	//设置默认值
	$.cm({	
		ClassName: "PHA.DEC.Com.Method", 
		MethodName: "GetAppProp", 
		UserId: gUserID, 
		LocId: gLocId, 
		SsaCode: "DEC.OUTDISP", 
		AppCode:""
		}, function(AppPropData){
			$("#dateStart").datebox("setValue", AppPropData.DispStartDate);
			$("#dateEnd").datebox("setValue", AppPropData.DispEndDate);
			$('#timeStart').timespinner('setValue', "00:00:00");
			$('#timeEnd').timespinner('setValue', "23:59:59");
			$("#txtBarCode").focus();
		});
}
/**
 * 初始化待发放处方列表
 * @method InitGridPresc
 */
function InitGridPresc() {
	var columns = [[ 
		{field:'pdCheck',	checkbox: true,	},
		{field:'pdPst', 	title:'当前流程',	align:'left', width: 70, 
			styler:function(value,row,index){
				return 'background-color:#00e673;';	
			}
		},
		{field:'pdpm',		title:'pdpm',		hidden:'true',	width: 50},
		{field:'patNo',		title:'登记号',		align:'left', width: 100}, 
		{field:'patName',	title:'患者姓名',	align:'left', width: 80}, 
		{field:'prescno', 	title:'处方号',	  	align:'left', width: 130}, 
		{field:'deptLoc', 	title:'科室',	  	align:'left', width: 150}, 
		{field:'pdType', 	title:'煎药类型', 	align:'left', width: 70}, 
		{field:'comFlag',	title:'完成标志', 	align:'left', width: 70}, 
		{field:'pdDate',	title:'生成时间', 	align:'left', width: 150},
		{field:'preFacTor',	title:'付数',		align:'left', width: 45}, 
		{field:'preCount',	title:'味数',		align:'left', width: 45}, 
		{field:'preForm',	title:'处方剂型',	align:'left', width: 80}, 
		{field:'preEmFlag',	title:'是否加急',	align:'left', width: 45}, 
		{field:'phaLoc',	title:'调剂科室',	align:'left', width: 100}, 
		{field:'operUser',	title:'调剂人',		align:'left', width: 80},
		{field:'operDate',	title:'调剂时间',	align:'left', width: 150},
		{field:'cookCost',	title:'煎药费',		align:'left', width: 150,nowrap:false}
	]];
	var dataGridOption = {
		toolbar: '#gridDspBar',
		columns: columns,
		url: $URL,
		singleSelect: false,
		selectOnCheck: true,
		checkOnSelect: true,
		nowrap:false,
		rownumbers: true,
		queryParams: {
			ClassName: "PHA.DEC.DecDisp.Query",
			QueryName: "QueryPrescList",
		},
		onSelect: function(rowIndex, rowData){
			var prescno = rowData.prescno;
			ColPrescView(prescno);
		},
		onLoadSuccess: function(data) {
			if(data.rows.length==0){ return; }
			$("#gridPresc").datagrid("checkAll");
			var row = data.rows[0];
			var prescno = row.prescno;
			ColPrescView(prescno);
		}
	};
	PHA.Grid("gridPresc", dataGridOption);
}
/**
 * 初始化已发放处方列表
 * @method InitGridDisped
 */
function InitGridDisped() {
	var columns = [[ 
		{field:'pdpm',		title:'pdpm',		hidden:'true', 	width: 70 },
		{field:'patNo',		title:'登记号',		align:'left', width: 100}, 
		{field:'patName',	title:'患者姓名',	align:'left', width: 80 }, 
		{field:'prescno', 	title:'处方号',	  	align:'left', width: 130}, 
		{field:'deptLoc', 	title:'科室',	  	align:'left', width: 150},
		{field:'dspUser',	title:'发放人',		align:'left', width: 80 },
		{field:'dspDate',	title:'发放时间',	align:'left', width: 150}, 
		{field:'pdPst', 	title:'当前流程',	align:'left', width: 70 }, 
		{field:'pdType', 	title:'煎药类型', 	align:'left', width: 70 }, 
		{field:'comFlag',	title:'完成标志', 	align:'left', width: 70 }, 
		{field:'pdDate',	title:'生成时间', 	align:'left', width: 150},
		{field:'preFacTor',	title:'付数',		align:'left', width: 45 }, 
		{field:'preCount',	title:'味数',		align:'left', width: 45 }, 
		{field:'preForm',	title:'处方剂型',	align:'left', width: 80 }, 
		{field:'preEmFlag',	title:'是否加急',	align:'left', width: 70 }, 
		{field:'phaLoc',	title:'调剂科室',	align:'left', width: 100}, 
		{field:'operUser',	title:'调剂人',		align:'left', width: 80 },
		{field:'operDate',	title:'调剂时间',	align:'left', width: 150},
		{field:'cookCost',	title:'煎药费',		align:'left', width: 150}
	]];
	var dataGridOption = {
		toolbar: '#gridQueryBar',
		columns: columns,
		url: $URL,
		rownumbers: true,
		nowrap:false,
		queryParams: {
			ClassName: "PHA.DEC.DecDisp.Query",
			QueryName: "QueryPrescList"
		},
		onSelect: function(rowIndex, rowData){
			var prescno = rowData.prescno;
			ColPrescView(prescno);
		}
	};
	PHA.Grid("gridDisped", dataGridOption);
}

/**
 * 查询待发放数据
 * @method queryPrtLabList
 */
function queryPrescList(){
	var params = getParams();
	$('#gridPresc').datagrid('query', {
		disped: 'false',
		inputStr: params
	});
}

/**
 * 获取扫码发放界面元素值
 * @method getParams
 */
function getParams(){
	var barCode = $("#txtBarCode").val();
	if (barCode=="") { return null; }
	var params = barCode +"^"+ locId +"^"+ decNumber;
	return params;
}

/**
 * 查询已发放数据
 * @method queryDispedList
 */
function queryDispedList(){
	var params = getDispedParams();
	if(!params) return;
	var tabTitle = $('#dispTab').tabs('getSelected').panel('options').title;
	if (tabTitle == "已发放查询") {
		$('#gridDisped').datagrid('query', {
			disped: 'true',
			inputStr: params
		});
	}else{
		$("#txtBarCode").focus();
	}
}

//读卡
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "",
		CardNoId: "txtCardNo",
		PatNoId: "txtBarCode"
	}
	DhcphaReadCardCommon(readcardoptions, queryPrescList)
}

/**
 * 获取已发放查询界面元素值
 * @method getParams
 */
function getDispedParams(){
	var stDate = $("#dateStart").datebox('getValue');
	if(stDate==""){
		PHA.Popover({showType: "show", msg: "请选择开始时间！", type: 'alert'});
		return null;
	}
	var enDate = $("#dateEnd").datebox('getValue');
	if(enDate==""){
		PHA.Popover({showType: "show", msg: "请选择截止时间！", type: 'alert'});
		return null;
	}
	var stTime = $('#timeStart').timespinner('getValue');
	var enTime = $('#timeEnd').timespinner('getValue');
	var locId = $('#cmbDecLoc').combobox("getValue")||"";
	if(locId==""){
		PHA.Popover({showType: "show", msg: "请选择煎药室！", type: 'alert'});
		return null;
	}
	var phaLocId = $('#cmbPhaLoc').combobox("getValue")||"";
	var patNo = $('#txtPatNo').val();
	var params = stDate +"^"+ enDate +"^"+ stTime +"^"+ enTime +"^"+ locId +"^"+ patNo +"^"+ phaLocId +"^"+ decNumber;
	return params;
}

/**
 * 确认发放
 * @method dispPresc
 */
function dispPresc() {
	var checkedData = $("#gridPresc").datagrid("getChecked");
	if(checkedData.length==0){
		PHA.Popover({showType: "show", msg: "请先勾选需要发放的处方！", type: 'alert'});
		return;
	}
	var prescnoStr = "";
	for(var i in checkedData){
		var prescno = checkedData[i].prescno;
		prescnoStr = prescnoStr == "" ? prescno : prescnoStr +"!!"+ prescno;
	}
	if(!prescnoStr) return;
	var params = prescnoStr +"^"+ decNumber +"^"+ opUser +"^"+ "" +"^"+ locId;
	$cm({
		ClassName: "PHA.DEC.DecDisp.OperTab",
		MethodName: "SaveDispPstBatch",
		params: params,
		dataType: "text"
	},function(retData) {
		var retArr = retData.split("^");
		var result = parseInt(retArr[0]);
		if (result < 0){ 
			PHA.Popover({ showType: "show",	msg: retData, type: 'error'	});
		}else{
			PHA.Popover({ showType: "show",	msg: "发放成功！", type: 'success' });
			queryPrescList();
			ColPrescView("");
		}
		$("#txtBarCode").focus();
	});	
}

/**
 * 处方预览
 * @method PrescView
 */
function ColPrescView(prescno){
	var phartype = "O";
	DEC_PRESC.Presc("divPreLayout", {
		PrescNo: prescno, 
		AdmType: phartype,
		CY: "Y"
	}); 
}

//@description:读卡调用
//@params:变量对象,回掉函数
//@csp need add:DHCWeb.OPCommonManageCard.JS
DhcphaReadCardCommon_CallBack=null; // 间接记录回调
DhcphaReadCardCommon_ops=null;
function DhcphaReadCardCommon(_options, _fn) {
    if (_fn == undefined) {
        _fn = "";
		DhcphaReadCardCommon_CallBack=_fn;
    }else{
		DhcphaReadCardCommon_CallBack=_fn;
	}
    var txtcardno = _options.CardNoId;
    var txtpatno = _options.PatNoId;
    DhcphaReadCardCommon_ops=_options;
    var patCarNo = $("#" + txtcardno).val();
    var readRet;
	// 回调 
    if (patCarNo != "") {
        readRet=DHCACC_GetAccInfo("", patCarNo, "", "PatInfo", CardTypeCallBack);
    } else {
        readRet=DHCACC_GetAccInfo7(CardTypeCallBack);
    }
	
}


function CardTypeCallBack(rtn) {

	var readRet=rtn;
	if (readRet == false) {
        dhcphaMsgBox.alert("卡无效!");
        return;
    }
    var txtcardno = DhcphaReadCardCommon_ops.CardNoId;
    var txtpatno = DhcphaReadCardCommon_ops.PatNoId;

    var readRetArr = readRet.split("^");
    var readRtn = readRetArr[0];
    switch (readRtn) {
        case "0":
            //卡有效
            PatientID = readRetArr[4];
            PatientNo = readRetArr[5];
            CardNo = readRetArr[1];
            $("#"+txtcardno).val(CardNo);
            $("#"+txtpatno).val(PatientNo);
            //$("#txt-patno").val(PatientNo);
            //$("#txt-cardno").val(CardNo);
			if(typeof DhcphaReadCardCommon_CallBack==='function'){
				DhcphaReadCardCommon_CallBack();
			}
            break;
        case "-200":
            dhcphaMsgBox.alert("卡无效!");
            break;
        case "-201":
            //现金
            PatientID = readRetArr[4];
            PatientNo = readRetArr[5];
            CardNo = readRetArr[1];
            $("#"+txtcardno).val(CardNo);
            $("#"+txtpatno).val(PatientNo);

            //$("#txt-patno").val(PatientNo);
            //$("#txt-cardno").val(CardNo);
			if(typeof DhcphaReadCardCommon_CallBack==='function'){
				DhcphaReadCardCommon_CallBack();
			}
            break;
        default:
    }

}

