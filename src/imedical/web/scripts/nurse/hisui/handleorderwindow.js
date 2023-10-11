var GlobalData = {
	// 处理医嘱选项
	seeTypeOptions : [{value:"A",desc:$g("接受")},{value:"R",desc:$g("拒绝")}],
	// 处理执行日期
	handleDate : formatDate(new Date()),
	// 处理执行时间
	handleTime : new Date().toTimeString().slice(0, 5),
	// 刷新页面函数
	func : null,
	// 操作类型
	handleType : null,
	// 弹窗模式("N":不弹框、"W":弹框不签字、"S":弹框单签、"D":弹框双签)
	windowModel : "N",
	// 用户Code
	defaultUserCode : session["LOGON.USERCODE"],
	// 用户ID
	userID: session["LOGON.USERID"],
	// 双签用户ID
	secondUserID: "",
	// 需操作的医嘱ID对象
	orderIDObj: {},
	// 登录科室ID
	locID: session["LOGON.CTLOCID"],
	// 安全组ID
	groupID: session["LOGON.GROUPID"],
	// 是否是ppd医嘱
	ifPPDOrder: false,
	// 皮试结果
	skinTestResult: "",
	// 判断是否ca签名(如果是则单签用户或双签的第一个用户无须验证密码)
	caToInput: false,
	// 医院ID
	hospID: session["LOGON.HOSPID"]
};
/**
 * @description 初始化处理医嘱类型
 */ 
function initSeeType() {
	$("#seeType").combobox({
		valueField: 'value',
		textField: 'desc',
		multiple: false,
		method: 'local',
		editable:false,
		data: GlobalData.seeTypeOptions,
		onSelect:function(rec){
			setHandleNoteRequire();
		},
		onLoadSuccess:function(){
			setHandleNoteRequire();
		}
	})
}
function setHandleNoteRequire(){
	if (GlobalData.handleType === "seeOrder") {
		var seeType=$("#seeType").combobox("getValue");
		if ((seeType=="A")&&(GlobalData.ExecSetting.seeReceiveRequired=="Y")){
			$("label[for=handleNote]").addClass("clsRequired");
		}else if((seeType=="R")&&(GlobalData.ExecSetting.seeRefuseRequired=="Y")){
			$("label[for=handleNote]").addClass("clsRequired");
		}else{
			$("label[for=handleNote]").removeClass("clsRequired");
		}
	}else{
		$("label[for=handleNote]").removeClass("clsRequired");
	}
}
function initStopReason(){
	var stopReason = $cm({ClassName: "web.DHCDocInPatUICommon",MethodName: "GetOECStatusChReason",Type: "S"},false)
	$("#stopReason").combobox({
		mode:'local',
		method:"Get",
		multiple:false,
		selectOnNavigation:true,
		valueField:'id',
		textField:'text',
		data:stopReason
	})
}
/**
 * @description 初始化pc执行原因
 */ 
function initExecReason() {
	$("#execReason").combobox({
		url:$URL+"?ClassName=Nur.NIS.Service.OrderExcute.QueryOrder&QueryName=GetAllPCExecuteReason&rows=99999",
		mode:'local',
		method:"Get",
		multiple:false,
		selectOnNavigation:true,
		valueField:'ID',
		textField:'Desc',
		loadFilter:function(data){
			return data.rows;
		}
	})
}
/**
 * @description 初始化ES6环境
 */
function InitES6(){
	if(websys_isIE){
		$.getScript("../scripts/nurse/bluebird/bluebird.min.js")
	}
}
/**
 * @description 初始化弹窗
 */
function initEditWindow() {
	$("#handleOrder-window").css('display','block');
	$("#handleOrder").window({
	   modal: true,
	   collapsible: false,
	   minimizable: false,
	   maximizable: false,
	   closed: true,
	   onClose: function(){
			resetEditWindow();
	   }
	});
	$("#saveButton").click(confirmFieldValue);
	$("#cancelButton").click(function(){
		$("#handleOrder").window('close');
	});
	InitES6();
}
/**
 * @description 重置弹窗
 */ 
function resetEditWindow() {
	$("#handleDate,#handleDate-ppdSkinTest").datebox('enable');
	$("#handleTime,#handleTime-ppdSkinTest").timespinner('enable');
	$(".ppdSkinTest,.notPPDSkinTest-table").css('display','none');
	$("#seeType-component").css('display','none');
	$(".handleNote-component").css('display','none');
	$("#pcExecReason-component").css('display','none');
	$(".singleSign-component").css('display','none');
	$(".doubleSign-component").css('display','none');
	$(".skinTest-component").css('display','none');
	$("#handleOrder").panel({height:167,width:450});
	$("#handleNote,#handleNote-ppdSkinTest").val("");
	GlobalData.defaultUserCode = session["LOGON.USERCODE"];
	GlobalData.userID = session["LOGON.USERID"];
	GlobalData.secondUserID = "";
	GlobalData.ifPPDOrder = false;
	GlobalData.skinTestResult = "";
	$("#password,#password-ppdSkinTest").val("");
	$("#secondPassword,#secondPassword-ppdSkinTest").val("");
	$("#secondUserCode,#secondUserCode-ppdSkinTest").val("");
	$("#skinTest-normal,#skinTest-allergy,#skinTest-ppdnormal,#skinTest-ppdallergy").radio('setValue',false);
	$("#skinTest-normal").radio({required:true}).radio('enable');
	$("#skinTest-allergy").radio({required:true}).radio('enable');
	$("#skinTest-ppdnormal").radio({required:true}).radio('enable');
	$("#skinTest-ppdallergy").radio({required:true}).radio('enable');
	
	$("#skinTestNum,#skinTestNum-ppdSkinTest").val("");
	
	$("#induration-width").numberbox("setValue","");
	$("#induration-height").numberbox("setValue","");
	$("#blister-width").numberbox("setValue","");
	$("#blister-height").numberbox("setValue","");
	$("#redSwollen-width").numberbox("setValue","");
	$("#redSwollen-height").numberbox("setValue","");
	
	$("#blisterState-sing").radio('setValue',false);
	$("#blisterState-spora").radio('setValue',false);
	
	$("#deadLymphatic-necrosis,#deadLymphatic-inflam,#deadLymphatic-doubleloop").checkbox("setValue",false);
	
	$("#blister-nohave,#redSwollen-nohave,#induration-nohave").checkbox("setValue",false);
	$("#ppdSkinTestResult").val("");
	$("#induration-averageDiameter").html();
	var opt =$("#handleDate").datebox('options');
	opt.maxDate = null;
	opt.minDate = null;
	$("#handleTime").timespinner({max:null});
	
	$("#userCode,#userCode-ppdSkinTest").validatebox("setDisabled",false);
	$("#password,#password-ppdSkinTest").validatebox("setDisabled",false);
	$("#seeType").combobox("setValue","");
	$("label[for=handleNote]").removeClass("clsRequired");
	setHandleNoteRequire();
};


/**
 * @description 处理执行医嘱(外部调用)
 * @param {any} type			  	调用事件		
 * @param {any} desc				弹框描述
 * @param {any} windowModel			弹窗模式("N":不弹框、"W":弹框不签字、"S":弹框单签、"D":弹框双签)
 * @param {any} pcExecReason		电脑执行原因
 * @param {any} orderIDObj			医嘱、执行记录ID对象
 * @param {any} queryOrder			刷新页面调用js函数
 * @param {any} callType			调用类型("NUR":护士、"DOC":医生)
 * @returns  
 */
function handleOrderCom(type, desc, windowModel, pcExecReason, orderIDObj, queryOrder, callType) {
	/*GlobalData.func = queryOrder;
	GlobalData.handleType = type;
	GlobalData.windowModel = windowModel;
	GlobalData.pcExecReason = pcExecReason;
	GlobalData.orderIDObj = orderIDObj;
	GlobalData.desc = desc;
	GlobalData.callType = callType === "DOC" ? "DOC" : "NUR";
	initExecSetting();
	initHandleDateTime();
	// CA验证
	GlobalData.caToInput = false;
	CASign(handleAction,type);
	*/
	new Promise(function(resolve) {
		if (type=="excuteOrder") {
			if (orderIDObj.execOrderList.length){
				$cm({
					ClassName: "Nur.Interface.OutSide.CDSSInterface",
					MethodName: "getPrecautionsByExecOrders",
					oeordIdStr: getOrdIdByExecId(orderIDObj.execOrderList)
				},function(data){
					if (data.length==0) resolve();
					else {
						$.messager.alert("提示",data.join("</br>"),"info",function(){
							resolve();
						})
					}
				});
			}else{
				resolve();
			}
		}else{
			resolve();
		}
	}).then(function() {
		GlobalData.func = queryOrder;
		GlobalData.handleType = type;
		GlobalData.windowModel = windowModel;
		GlobalData.pcExecReason = pcExecReason;
		GlobalData.orderIDObj = orderIDObj;
		GlobalData.desc = desc;
		GlobalData.callType = callType === "DOC" ? "DOC" : "NUR";
		initExecSetting();
		initHandleDateTime();
		// CA验证
		GlobalData.caToInput = false;
		CASign(handleAction,type);
	});
}
/**
 * @description 执行回调函数
 */
function handleAction() {
	if (GlobalData.windowModel !== "N") {	
		//var windowHeight = 160;
		var windowHeight = 167;
		var windowWidth = 450;
		var windowTitle = GlobalData.desc;
		$(".stopReason-component,.ppdSkinTest").css('display','none');
		$(".dateTime-component").css('display','table-row');
		$(".notPPDSkinTest-table").css('display','table');
		if (GlobalData.handleType === "seeOrder") {
			// 如果处理医嘱弹框，根据配置显示备注文本框
			if (GlobalData.ExecSetting.seeOrdShowNotes=="Y"){
				$(".handleNote-component").css('display','table-row');
				$(".handleNote-component").show();
				windowHeight+=80;
			}else{
				$(".handleNote-component").css('display','none');
				$(".handleNote-component").hide();
				windowHeight+=40;
			}
			// 如果处理医嘱弹框，则显示类型下拉框
			$("#seeType-component").css('display','table-row');
			initSeeType();
			$("#seeType").combobox("setValue","A");
			setHandleNoteRequire();
		}
		if (GlobalData.handleType === "excuteOrder" && GlobalData.pcExecReason === true) {
			// 如果执行医嘱弹框，则显示PC执行原因下拉框
			$("#pcExecReason-component").css('display','table-row');
			initExecReason();
			windowHeight+=40;
		}
		if (GlobalData.handleType === "excuteOrder" || GlobalData.handleType ==="cancelOrder") {
			// 如果执行医嘱弹框、撤销执行医嘱弹框，则显示备注文本框
			$(".handleNote-component").css('display','table-row');
			windowHeight+=40;
		}
		if (GlobalData.handleType ==="stopExcuteOrder"){
			initStopReason();
			$(".stopReason-component").css('display','table-row');
			$(".dateTime-component").css('display','none');
			windowHeight-=40;
		}
		if (GlobalData.windowModel === "S" || GlobalData.windowModel === "D") {
			// 显示单签签名框
			$(".singleSign-component").css('display','table-row');
			$("#userCode,#userCode-ppdSkinTest").val(GlobalData.defaultUserCode);
			windowHeight+=80;
		}
		if (GlobalData.windowModel === "D") {	
			// 显示双签签签名框	
			$(".doubleSign-component").css('display','table-row');
			windowHeight+=80;
		}
		if (GlobalData.handleType === "setSkinTest") {
			// 获取皮试结果
			getSkinTestResult();
			windowHeight+=120;
			$(".skinTest-component").css('display','table-row');
			// 判断是否是ppd皮试
			GlobalData.ifPPDOrder = $m({
				ClassName: "Nur.NIS.Service.Base.OrderHandle",
				MethodName: "IfPPDOrder",
				oeoriId: GlobalData.orderIDObj.skinTestOrder
			},false);
			if (GlobalData.ifPPDOrder === "Y") {
				windowWidth = 660,windowHeight=567;
				$("#skinTest-ppdnormal").radio({required:false}).radio('disable');
				$("#skinTest-ppdallergy").radio({required:false}).radio('disable');
				$(".ppdSkinTest").css('display','table');
				$(".notPPDSkinTest-table").css('display','none');
			}else{
				windowHeight = 408;
			}
			if (GlobalData.ExecSetting.skinTestNotesRequired=="Y"){
				$(".handleNote-component").css('display','table-row');
				$("label[for=handleNote]").addClass("clsRequired");
				windowHeight+=40;
			}
			
		}
		$("#handleOrder-form").css("height",windowHeight-87+"px");
		$("#handleOrder").window({height:windowHeight,width:windowWidth,title:windowTitle}).window("center").window('open');
	}else{
		save();
	}
}
/**
 * @description 获取执行配置
 */
function initExecSetting() {
	GlobalData.ExecSetting = $cm({ClassName: "Nur.NIS.Service.OrderExcute.QueryOrder",MethodName: "GetExecConfig",hospId: GlobalData.hospID},false);
}
/**
 * @description 日期时间框赋值
 */
function initHandleDateTime() {
	$("#handleDate,#handleDate-ppdSkinTest").datebox({});
	var data;
	if (GlobalData.ExecSetting.execDefaultDT === 1 && (GlobalData.handleType === "excuteOrder" || GlobalData.handleType === "setSkinTest")) {
		var oeoreID = ""
		if (GlobalData.handleType === "excuteOrder") {
			if (GlobalData.orderIDObj.execOrderList.length > 0) {
				oeoreID = GlobalData.orderIDObj.execOrderList[0];
			}else{
				oeoreID = GlobalData.orderIDObj.execDisOrderList[0];
			}
			if ((oeoreID)&&(oeoreID.split("^").length > 0)){
				oeoreID = oeoreID.split("^")[0];
			}
			var orderNum = GlobalData.orderIDObj.execOrderList.length + GlobalData.orderIDObj.execDisOrderList.length;
			if (orderNum > 1) {
				$("#handleDate,#handleDate-ppdSkinTest").datebox('disable');
				$("#handleTime,#handleTime-ppdSkinTest").timespinner('disable');
			}else{
				var ordCreateDataTime = $m({ClassName: "Nur.NIS.Service.OrderExcute.OrderInfo",MethodName: "GetCreateDateTime",oeoriId:oeoreID},false);
				var opt = $("#handleDate,#handleDate-ppdSkinTest").datebox('options');
				opt.minDate = ordCreateDataTime.split(" ")[0];
			}
		}else{
			// 置皮试结果
			oeoreID = GlobalData.orderIDObj.skinTestOrder
		}
		data = $m({ClassName: "Nur.NIS.Service.OrderExcute.OrderInfo",MethodName: "GetSttDateTime",oeoreId:oeoreID},false);
		GlobalData.handleDate = data.split(" ")[0];
		GlobalData.handleTime = data.split(" ")[1];

	}else{
		data = $cm({ClassName: "Nur.NIS.Common.SystemConfig",MethodName: "GetCurrentDateTime",timeFormat: "1"},false)
		GlobalData.handleDate = data.date;
		GlobalData.handleTime = data.time;
	}
	// 处理医嘱控制时间不能大于当前时间
	if (GlobalData.handleType === "seeOrder") {
		var dateOpt = $("#handleDate,#handleDate-ppdSkinTest").datebox('options');
		var forMatterDate = formatDate(GlobalData.handleDate) + " " + GlobalData.handleTime;
		forMatterDate =  new Date(Date.parse(forMatterDate.replace(/-/g, "/")));
		dateOpt.maxDate = dateOpt.formatter(forMatterDate);
		setHandleTimeMax();
	}
	$("#handleDate,#handleDate-ppdSkinTest").datebox('setValue', GlobalData.handleDate);
	$("#handleTime,#handleTime-ppdSkinTest").timespinner('setValue', GlobalData.handleTime);
	if (GlobalData.ExecSetting.editeDefaultDT === "N" && (GlobalData.handleType === "excuteOrder" || GlobalData.handleType === "setSkinTest")) {
		$("#handleDate,#handleDate-ppdSkinTest").datebox('disable');
		$("#handleTime,#handleTime-ppdSkinTest").timespinner('disable');
	}
	if (GlobalData.ExecSetting.execDefaultDT === 0 && (GlobalData.ExecSetting.editeDefaultDT === "Y") && (GlobalData.handleType === "excuteOrder" || GlobalData.handleType === "setSkinTest")) {
		var newConcatArr = [],ordNum=0;
		if (GlobalData.handleType === "excuteOrder") {
			var concatArr=GlobalData.orderIDObj.execOrderList.concat(GlobalData.orderIDObj.execDisOrderList);
		}else{
			var concatArr=GlobalData.orderIDObj.skinTestOrder;
		}
		for(var i = 0; i < concatArr.length; i++){
			var oneConcatArr=concatArr[i].split("||");
			var newoneConcatArr=oneConcatArr[0]+"||"+oneConcatArr[1]
			if (!newConcatArr[newoneConcatArr]) {
				newConcatArr[newoneConcatArr]=true;
				ordNum++;			
			}
			if (ordNum>1){
				break;
			}
		}
		if (ordNum==1){
			var oeoreID = ""
			if (GlobalData.handleType === "excuteOrder") {
				if (GlobalData.orderIDObj.execOrderList.length > 0) {
					oeoreID = GlobalData.orderIDObj.execOrderList[0];
				}else{
					oeoreID = GlobalData.orderIDObj.execDisOrderList[0];
				}
				if ((oeoreID)&&(oeoreID.split("^").length > 0)){
					oeoreID = oeoreID.split("^")[0];
				}
			}else{
				// 置皮试结果
				oeoreID = GlobalData.orderIDObj.skinTestOrder
			}
			var ordCreateDataTime = $m({ClassName: "Nur.NIS.Service.OrderExcute.OrderInfo",MethodName: "GetCreateDateTime",oeoriId:oeoreID},false);
			var opt = $("#handleDate,#handleDate-ppdSkinTest").datebox('options');
			opt.minDate = ordCreateDataTime.split(" ")[0];
		}
	}
}
/**
 * @description 处置日期
 */
function changeDate(){
	if (GlobalData.ifPPDOrder === "Y") {
		GlobalData.handleDate=$("#handleDate-ppdSkinTest").datebox('getValue');
	}else{
		GlobalData.handleDate=$("#handleDate").datebox('getValue');
		if (GlobalData.handleType === "seeOrder") {
			setHandleTimeMax();
		}
	}
}
/**
 * @description 处置时间
 */
function changeTime() {
	if (GlobalData.ifPPDOrder === "Y") {
		GlobalData.handleTime=$("#handleTime-ppdSkinTest").timespinner('getValue');
	}else{
		GlobalData.handleTime=$("#handleTime").timespinner('getValue');
	}
}
/**
 * @description 获取皮试结果
 */ 
function getSkinTestResult() {
	$cm({
		ClassName: 'Nur.NIS.Service.Base.OrderHandle',
		MethodName: "GetSkinTestResult",
		oeoreId: GlobalData.orderIDObj.skinTestOrder
	}, function(data) {	
		if (data.ifPPDOrder) {
			if (data.skinTest === "阳性") {
				GlobalData.skinTestResult = "Y";
				$("#skinTest-ppdallergy").radio("check");
				$("#skinTest-ppdnormal").radio("uncheck");
			}else if (data.skinTest === "阴性"){
				GlobalData.skinTestResult = "N";
				$("#skinTest-ppdnormal").radio("check");
				$("#skinTest-ppdallergy").radio("uncheck");
			}else{
				GlobalData.skinTestResult = "";
				$("#skinTest-ppdnormal").radio("uncheck");
				$("#skinTest-ppdallergy").radio("uncheck");		
			}
			$("#skinTestNum-ppdSkinTest").val(data.skinTestBatch);
			$("#induration-width").numberbox("setValue",data.PPDResult.TestSkinSityOne);
			$("#induration-height").numberbox("setValue",data.PPDResult.TestSkinSityTwo);
			
			$("#blister-width").numberbox("setValue",data.PPDResult.TestSkinVclOne);
			$("#blister-height").numberbox("setValue",data.PPDResult.TestSkinVclTwo);
	
			$("#redSwollen-width").numberbox("setValue",data.PPDResult.TestSkinSwoOne);
			$("#redSwollen-height").numberbox("setValue",data.PPDResult.TestSkinSwoTwo);
			
			$("#ppdSkinTestResult").val(data.PPDResult.PPDResult);
			if (String(data.PPDResult.TestSkinSing) === "1") {
				$("#blisterState-sing").radio("check");
            }
            if (String(data.PPDResult.TestSkinSpora) === "1") {
	            $("#blisterState-spora").radio("check");
            }
			if (String(data.PPDResult.TestSkinNecrosis) === "1") {
              $("#deadLymphatic-necrosis").checkbox("check");
            }
            if (String(data.PPDResult.TestSkinInflam) === "1") {
              $("#deadLymphatic-inflam").checkbox("check");
            }
            if (String(data.PPDResult.TestSkinDoubleloop) === "1") {
              $("#deadLymphatic-doubleloop").checkbox("check");
            }
            $("#blister-nohave").checkbox("setValue",data.PPDResult.TestSkinVclNoHave=="Y"?true:false);
            $("#redSwollen-nohave").checkbox("setValue",data.PPDResult.TestSkinSwoNoHave=="Y"?true:false);
            $("#induration-nohave").checkbox("setValue",data.PPDResult.TestSkinSityNoHave=="Y"?true:false);
            if ((data.PPDResult.TestSkinSityOne!="")||(data.PPDResult.TestSkinSityTwo!="")){
           	 $("#induration-averageDiameter").html(Number(data.PPDResult.TestSkinSityOne)+Number(data.PPDResult.TestSkinSityTwo)/2);
            }
		}else{
			if (data.skinTest === "阳性") {
				GlobalData.skinTestResult = "Y";
				$("#skinTest-allergy").radio("check");
				$("#skinTest-normal").radio("uncheck");
			}else if (data.skinTest === "阴性"){
				GlobalData.skinTestResult = "N";
				$("#skinTest-normal").radio("check");
				$("#skinTest-allergy").radio("uncheck");
			}else{
				GlobalData.skinTestResult = "";
				$("#skinTest-normal").radio("uncheck");
				$("#skinTest-allergy").radio("uncheck");		
			}
			// 皮试批号
			$("#skinTestNum").val(data.skinTestBatch);
		}
	})
}
/**
 * @description 皮试阴性
 */ 
function skinTestNormal() {
	debugger;
	GlobalData.skinTestResult = "N";
	console.log(GlobalData.skinTestResult);
}
/**
 * @description 皮试阳性
 */ 
function skinTestAllergy() {
	GlobalData.skinTestResult = "Y";
	console.log(GlobalData.skinTestResult);
}
/**
 * @description 计算ppd皮试结果
 */
function caculateResult() {
	var indurationWidth = $("#induration-width").numberbox("getValue");
	var indurationHeight = $("#induration-height").numberbox("getValue");
	
	var blisterWidth = $("#blister-width").numberbox("getValue");
	var blisterHeight = $("#blister-height").numberbox("getValue");

	var redSwollenWidth = $("#redSwollen-width").numberbox("getValue");
	var redSwollenHeight = $("#redSwollen-height").numberbox("getValue");
	
	var deadLymphatic = 0;
	var deadLymphaticdoubleloop = $("#deadLymphatic-doubleloop").checkbox("getValue");
	if (deadLymphaticdoubleloop) {
		deadLymphatic+=1
	}
	var deadLymphaticNecrosis = $("#deadLymphatic-necrosis").checkbox("getValue");
	if (deadLymphaticNecrosis) {
		deadLymphatic+=1
	}
	var deadLymphaticInflam = $("#deadLymphatic-inflam").checkbox("getValue");
	if (deadLymphaticInflam) {
		deadLymphatic+=1
	}
	
	if (((indurationWidth!="")&&(indurationWidth>0))||((indurationHeight!="")&&(indurationHeight>0))){
		$("#induration-averageDiameter").html((Number(indurationWidth)+Number(indurationHeight))/2);
	}else{
		$("#induration-averageDiameter").html("");
	}
	if (deadLymphatic > 0 || (redSwollenHeight > 0 && redSwollenHeight!=="") || (redSwollenWidth > 0 && redSwollenWidth!=="") || (blisterHeight && blisterHeight !== "") > 0 || (blisterWidth && blisterWidth!=="") > 0) {
		$("#ppdSkinTestResult").val("++++");
		$("#skinTest-ppdallergy").radio("check");
		$("#skinTest-ppdnormal").radio("uncheck");
		GlobalData.skinTestResult = "Y";
	} else if ((indurationHeight < 5 && indurationHeight >= 0 && indurationHeight !== "") ||(indurationWidth < 5 && indurationWidth >= 0 && indurationWidth !== "")) {
		$("#ppdSkinTestResult").val("-");
		$("#skinTest-ppdnormal").radio("check");
		$("#skinTest-ppdallergy").radio("uncheck");
		GlobalData.skinTestResult = "N";
	} else if ((indurationHeight >= 5 && indurationHeight <= 9 && indurationHeigh !== "") || (indurationWidth >= 5 && indurationWidth <= 9 && indurationWidth !== "")) {
		$("#ppdSkinTestResult").val("+");
		$("#skinTest-ppdallergy").radio("check");
		$("#skinTest-ppdnormal").radio("uncheck");
		GlobalData.skinTestResult = "Y";
	} else if ((indurationHeight > 9 && indurationHeight <= 19 && indurationHeigh !== "") || (indurationWidth > 9 && indurationWidth <= 19 && indurationWidth !== "")) {
		$("#ppdSkinTestResult").val("++");
		$("#skinTest-ppdallergy").radio("check");
		$("#skinTest-ppdnormal").radio("uncheck");
		GlobalData.skinTestResult = "Y";
	} else if ((indurationHeight && indurationHeigh !== "") > 19 || (indurationWidth > 19 && indurationWidth !== "")) {
		$("#ppdSkinTestResult").val("+++");
		$("#skinTest-ppdallergy").radio("check");
		$("#skinTest-ppdnormal").radio("uncheck");
		GlobalData.skinTestResult = "Y";
	} else {
		$("#ppdSkinTestResult").val("-");
		$("#skinTest-ppdallergy").radio("uncheck")
		$("#skinTest-ppdnormal").radio("check");
		GlobalData.skinTestResult = "N";
	}
}
/**
 * @description 验证
 */ 
function confirmFieldValue() {
	var firstSignType = "";
	var secondSignType = "";
	if (GlobalData.handleType === "seeOrder") {
		var seeType=$("#seeType").combobox("getValue");
		if (!seeType) {
			$.messager.popover({msg:'处理医嘱类型为空',type:'error'});
			return false;
		}
		if($("label[for=handleNote]").hasClass("clsRequired")){
			var notes=String($("#handleNote").val()).trim();
			if (notes==""){
				$.messager.popover({msg:'请输入备注！',type:'error'});
				$("#handleNote").focus();
				return false;
			}
		}
	}
	if (GlobalData.handleType === "setSkinTest") {
		if (GlobalData.skinTestResult === "") {
			$.messager.popover({msg:'皮试结果为空',type:'error'});
			return false;
		}
		if (GlobalData.ifPPDOrder=="Y"){
			var labelForId="handleNote-ppdSkinTest";
		}else{
			var labelForId="handleNote";
		}
		if($("label[for="+labelForId+"]").hasClass("clsRequired")){
			var notes=String($("#"+labelForId).val()).trim();
			if (notes==""){
				$.messager.popover({msg:'请输入备注！',type:'error'});
				$("#"+labelForId).focus();
				return false;
			}
		}
	}
	if (GlobalData.windowModel === "D" || GlobalData.windowModel === "S") {
		if (GlobalData.ifPPDOrder=="Y"){
			var userCode = $("#userCode-ppdSkinTest").val();
		}else{
			var userCode = $("#userCode").val();
		}
		// 判断是否ca签名
		if (GlobalData.caToInput) {
			if (GlobalData.windowModel === "D") {
				if (GlobalData.ifPPDOrder=="Y"){
					var secondUserCode = $("#secondUserCode-ppdSkinTest").val();
				}else{
					var secondUserCode = $("#secondUserCode").val();
				}
				if (String(userCode).toUpperCase() === String(secondUserCode).toUpperCase()) {
					//判断两次签名是否为同一用户
					$.messager.popover({msg:"两次签名为同一用户",type:'error'});
					return false;
				}else{
					// ca验证通过只验证双签的第二个用户
					$cm({
						ClassName: 'Nur.NIS.Service.Base.User',
						MethodName: "PasswordConfirm",
						userCode: secondUserCode,
						passWord: GlobalData.ifPPDOrder=="Y"?$("#secondPassword-ppdSkinTest").val():$("#secondPassword").val(),
						ctLoc: '',
					}, function(secondSignData) {
						if (0 == secondSignData.result) {
							GlobalData.secondUserID = secondSignData.userID;
							// 双签验证成功
							save();
						} else {
							// 双签验证失败
							$.messager.popover({msg:secondSignData.result,type:'error'});
							return false;
						}
					})		
				}				
			}else{
				// 如果ca验证通过则单签用户无需验证
				save();			
			}
		}else{
			$cm({
				ClassName: 'Nur.NIS.Service.Base.User',
				MethodName: "SignPasswordConfirm",
				userCode: userCode,
				passWord: GlobalData.ifPPDOrder=="Y"?$("#password-ppdSkinTest").val():$("#password").val(),
				ctLoc: GlobalData.locID
			}, function(signData) {
				if (0 == signData.result) {
					GlobalData.userID = signData.userID;
					firstSignType = signData.type;
					// 单签验证成功
					if (GlobalData.windowModel === "D") {
						// 判断是否双签
						if (GlobalData.ifPPDOrder=="Y"){
							var secondUserCode = $("#secondUserCode-ppdSkinTest").val();
						}else{
							var secondUserCode = $("#secondUserCode").val();
						}
						if (String(userCode).toUpperCase() === String(secondUserCode).toUpperCase()) {
							//判断两次签名是否为同一用户
							$.messager.popover({msg:"两次签名为同一用户",type:'error'});

						}else{
							$cm({
								ClassName: 'Nur.NIS.Service.Base.User',
								MethodName: "SignPasswordConfirm",
								userCode: secondUserCode,
								passWord: GlobalData.ifPPDOrder=="Y"?$("#secondPassword-ppdSkinTest").val():$("#secondPassword").val(),
								ctLoc: GlobalData.locID
							}, function(secondSignData) {
								if (0 == secondSignData.result) {
									secondSignType = secondSignData.type;
									if (GlobalData.ExecSetting.permitDosSign === "Y") {
										// 允许医生签名
										if (firstSignType === secondSignType && secondSignType === "DOCTOR") {
											$.messager.popover({msg:"不允许都为医生签名",type:'error'});
										}else{
											// 双签验证成功
											GlobalData.secondUserID = secondSignData.userID;
											save();											
										}
									}else{
										// 不允许医生签名
										if (firstSignType === secondSignType && secondSignType === "NURSE") {
											// 双签验证成功
											GlobalData.secondUserID = secondSignData.userID;
											save();
										}else {
											$.messager.popover({msg:"不允许医生签名",type:'error'});
											return false;
										}
									}
								} else {
									// 双签验证失败
									$.messager.popover({msg:secondSignData.result,type:'alert'});
									return false;
								}
							})
						}
					}else{
						if ((firstSignType === "DOCTOR")&&(!ordExecFlag)) {
							$.messager.popover({msg:"单签不允许医生签名",type:'error'});
							return false;
						}else{
							save();
						}
						
					}
				} else {
					// 单签验证失败
					$.messager.popover({msg:signData.result,type:'alert'});
					return false;
				}
			})		
		}
	}else{
		save();
	}
}
/**
 * @description 保存数据
 */
function save() {
	switch (GlobalData.handleType) {
		case "seeOrder":
			seeOrderChunks();
			break;
		case "cancelSeeOrder":
			cancelSeeOrderChunks();
			break;
		case "excuteOrder":
			excuteOrderChunks();
			break;
		case "cancelOrder":
			cancelOrderChunks();
			break;
		case "clearPlacerNo":
			setPlacerNoGroup();
			break;
		case "setSkinTest":
			setSkinTestResult();
			break;
		case "confirmFee":
			confirmFee();
			break;
		case "stopExcuteOrder":
			stopExcuteOrderChunks();
			break;
		
	}
}
/**
 * @description CA验证
 */
function CASign(callBack,type) {
	var ParamObj = {
		"callback" : callBack,
		"modelCode" : type,
		"isHeaderMenuOpen" : false
	};
	var _thisCallBack=ParamObj.callback||function(){};
	ParamObj.callback=function(resultObj){
		if (!resultObj.IsSucc){
			$.messager.alert("警告", "证书登录失败!");
			return;
		}
		
		// 是否CA证书登录(true:须CA证书登录，false:当前无须CA证书登陆)
		IsCA=resultObj.IsCA; 
		if (!IsCA){
			_thisCallBack();
			return;
		}
		//alert(resultObj.ContainerName)
	    if ((resultObj.ContainerName||"")=="") {
		    $.messager.alert("警告", "未开启CA,使用HIS系统签名!");
	        return;
	    }
		console.log(resultObj.UserName);
		GlobalData.defaultUserCode = resultObj.UserName;
		console.log(resultObj.UserID);
		GlobalData.userID = resultObj.UserID;
		GlobalData.caToInput = true;
		
		// CA全局变量
		ca_key = resultObj.ca_key;
		ContainerName = resultObj.ContainerName; 
		CACertNo = resultObj.CACertNo;
		CAUserCertCode = resultObj.CAUserCertCode;

		$("#userCode,#userCode-ppdSkinTest").validatebox("setDisabled",true);
		$("#password,#password-ppdSkinTest").val("******")
		$("#password,#password-ppdSkinTest").validatebox("setDisabled",true);
	    _thisCallBack();
	}
	
	var _thisDefParamObj=$.extend({},ParamObj)
    // 判断当前key是否是登陆时候的key
    dhcsys_getcacert(_thisDefParamObj); 
    return;	
}
/**
 * @description 并发批量请求
 */
function initSignDataChunks(orderIDArr, handleType) {
	var Chunks = splitChunk(orderIDArr, 30);
	Promise.all(Chunks.map(function(item) {
    	return initSignData(item, handleType)
	})).then(function(promiseResult) {
		var errFlag = false
		for (var j=0; j<promiseResult.length; j++) {
			if (String(promiseResult[j]) !== "0") {
				errFlag = true;
				break;
			}
		}
		if (errFlag) {
			$.messager.alert("警告", "数字签名错误");
		}
	})
	
}
/**
 * @description 批量对医嘱数据进行签名
 */
function initSignData(dataIDList, handleType) {
	var itmValData = ""; var itmHashData = ""; var itmSignData = "";
	for (var i=0; i < dataIDList.length; i++) {
		var dataID = dataIDList[i];
		// 获取医嘱数据JSON
		var orderDataJson = $cm({ClassName:"Nur.CA.DigitalSignature",MethodName:"GetOrderDataJson",dataID:dataID},false);
		
		// 对医嘱数据做Hash
		var orderDataJsonStr = JSON.stringify(orderDataJson);
		var jsonHash = ca_key.HashData(orderDataJsonStr);
		// 将多个Hash值拼接
		if (itmHashData === "") {
			itmHashData = jsonHash;
		}else{
			itmHashData = itmHashData + String.fromCharCode(12) +jsonHash 
		}
		
		// 签名
		var signedData = ca_key.SignedData(jsonHash, ContainerName);
		// 将多个签名拼接
		if (itmSignData === "") {
			itmSignData = signedData;
		}else {
			itmSignData = itmSignData + String.fromCharCode(12) + signedData;
		} 	
	}
//	if ((itmValData === "") || (itmHashData === "") || (itmSignData === "")) {
//		return ""
//	}
	return new Promise(function(resolve) {
		$m({
			ClassName: "Nur.CA.DigitalSignature",
			MethodName: "InsertSignRecordChunks",
			handleType: handleType,
			signType: GlobalData.callType,
			dataIDStr: dataIDList.join(String.fromCharCode(12)),
			hashValues: itmHashData,
			mainSignCertCode: CAUserCertCode,
			mainSignValue: itmSignData,
			mainSignCertNo: CACertNo,
			userID: GlobalData.userID
		},function(result) {
			resolve(result);
		})
	})
}
/**
 * @description 批量处理医嘱
 */
function seeOrderChunks() {
	var Chunks = splitChunk(GlobalData.orderIDObj.seeOrderList, 30);
	var errors = [],otherMsgs=[];
	var ajaxConcurrency = function(chunk) {
		return new Promise(function(resolve) {
			$cm({
				ClassName: "Nur.NIS.Service.Base.OrderHandle",
				MethodName: "SeeOrderChunks",
				oeoriIdStr: chunk.join("^"),
				userId: GlobalData.userID,
				type: $("#seeType").combobox("getValue") || "F",
				note: String($("#handleNote").val()).trim(),
				date: GlobalData.handleDate,
				time: GlobalData.handleTime,
				logonLoc: GlobalData.locID
			},function(result){
				resolve(result);
			});
		});
	}
	Promise.all(Chunks.map(function(item) {
    	return ajaxConcurrency(item)
	})).then(function(promiseResult) {
		promiseResult.forEach(function(item) {
			if (String(item.success) !== "0") {
				errors = errors.concat(item.errList);
			}else if(item.alertList && item.alertList.length){
				otherMsgs = otherMsgs.concat(item.alertList);
			}
		})
    	if (errors.length !== 0) {
	    	/*errors.forEach(function(error) {
		    	$.messager.popover({msg:error.errInfo,type:'alert'});
	    	})*/
			var errorMsg=[];
			errors.forEach(function(error) {
				errorMsg.push(error.errInfo);
	    	})
			$.messager.popover({msg:errorMsg.join("</br>"),type:'error'});
    	}else{
			if (IsCA) {
		    	initSignDataChunks(GlobalData.orderIDObj.seeOrderList, "S");
		    }
		    if (otherMsgs.length !==0) {
			    $.messager.alert("提示","处理成功！</br>"+otherMsgs.join("</br>"));
			}else{
				$.messager.popover({msg:"处理成功",type:'success'});
			}
	    }
	    updatePageData();
	})
}
/**
 * @description 批量撤销处理医嘱
 */
function cancelSeeOrderChunks() {
	var Chunks = splitChunk(GlobalData.orderIDObj.cancelSeeOrderList, 30);
	var errors = [];
	var ajaxConcurrency = function(chunk) {
		return new Promise(function(resolve) {
			$cm({
				ClassName: "Nur.NIS.Service.Base.OrderHandle",
				MethodName: "CancelSeeOrderChunks",
				oeoriIdStr: chunk.join("^"),
				userId: GlobalData.userID,
				logonLoc: GlobalData.locID
			},function(result){
				resolve(result);
//				if (String(result.success) !== "0") {
//					errors = errors.concat(result.errList);
//				}
			});
		});
	}
	Promise.all(Chunks.map(function(item) {
    	return ajaxConcurrency(item)
	})).then(function(promiseResult) {
		promiseResult.forEach(function(item) {
			if (String(item.success) !== "0") {
				errors = errors.concat(item.errList);
			}		
		});
    	if (errors.length !== 0) {
	    	/*errors.forEach(function(error) {
		    	$.messager.popover({msg:error.errInfo,type:'alert'});
	    	})*/
			var errorMsg=[];
			errors.forEach(function(error) {
				errorMsg.push(error.errInfo);
	    	})
			$.messager.popover({msg:errorMsg.join("</br>"),type:'error'});
    	}else{
			if (IsCA) {
		    	initSignDataChunks(GlobalData.orderIDObj.cancelSeeOrderList, "CS");
		    }
	    	$.messager.popover({msg:"撤销处理成功",type:'success'});
	    }
		updatePageData();
	})
}
/**
 * @description 批量执行医嘱 
 */
function excuteOrderChunks() {
	var errors = [];
	var promises = [];
	if (GlobalData.orderIDObj.execOrderList.length > 0) {
		var execChunks = splitChunk(GlobalData.orderIDObj.execOrderList, 30);
		var execAjaxConcurrency = function(chunk) {
			return new Promise(function(resolve) {
				$cm({
					ClassName: "Nur.NIS.Service.Base.OrderHandle",
					MethodName: "UpdateOrdGroupChunks",
					setSkinTest: "",
					oeoreIdStr: chunk.join("^"),
					execStatusCode: "F",
					userId: GlobalData.userID,
					userDeptId: GlobalData.locID,
					queryTypeCode: GlobalData.sheetCode,
					execDate: GlobalData.handleDate,
					execTime: GlobalData.handleTime,
					pcExecReasonDr: $("#execReason").combobox("getValue") || "",
					changeReasonDr: String($("#handleNote").val()).trim(),
					groupID: GlobalData.groupID,
					auditUser: GlobalData.secondUserID,
					isSttDateTime: GlobalData.ExecSetting.execDefaultDT === 1 ? "Y" : "N",
					ordExecExecuteFlag:typeof ordExecExecuteFlag === 'undefined'?"N":ordExecExecuteFlag
				},function(result){
					resolve(result);
//					if (String(result.success) !== "0") {
//						errors = errors.concat(result.errList);
//					}
				});
			});
		}
		execChunks.forEach(function(item) {
			promises.push(execAjaxConcurrency(item))
		})	
	}
	if (GlobalData.orderIDObj.execDisOrderList.length > 0) {
		var execDisChunks = splitChunk(GlobalData.orderIDObj.execDisOrderList, 30);
		var execDisAjaxConcurrency = function(chunk) {
			return new Promise(function(resolve) {
				$cm({
					ClassName: "Nur.NIS.Service.Base.OrderHandle",
					MethodName: "SetDisconOrderChunks",
					oeoreIdStr: chunk.join("^"),
					userId: GlobalData.userID
				},function(result){
					resolve(result);
//					if (String(result.success) !== "0") {
//						errors = errors.concat(result.errList);
//					}
				});
			});
		}
		execDisChunks.forEach(function(item) {
			promises.push(execDisAjaxConcurrency(item))
		})		
	}
	Promise.all(promises).then(function(promiseResult) {
		promiseResult.forEach(function(item) {
			if (String(item.success) !== "0") {
				errors = errors.concat(item.errList);
			}		
		});	
		
    	if (errors.length !== 0) {
	    	/*errors.forEach(function(error) {
		    	$.messager.popover({msg:error.errInfo,type:'alert'});
	    	})*/
			var errorMsg=[];
			errors.forEach(function(error) {
				errorMsg.push(error.errInfo);
	    	})
			$.messager.popover({msg:errorMsg.join("</br>"),type:'error'});
    	}else{
			if (IsCA) {
		    	var execOrderList = GlobalData.orderIDObj.execOrderList.concat(GlobalData.orderIDObj.execDisOrderList);
		    	initSignDataChunks(execOrderList, "E");
		    }
	    	$.messager.popover({msg:"执行成功",type:'success'});
	    }
		updatePageData();
	})
}
/**
 * @description 批量停止执行医嘱
 */
function stopExcuteOrderChunks(){
	var ReasonId=$("#stopReason").combobox("getValue");
   	var Reasoncomment=$("#stopReason").combobox("getText");
    if (ReasonId==Reasoncomment) ReasonId="";
    if ((ReasonId=="")&&(Reasoncomment=="")){
	   $.messager.alert("提示","请选择或者填写停止原因!");
	   $('#stopReason').next('span').find('input').focus();
	   return false;
    }
	var Chunks = splitChunk(GlobalData.orderIDObj.stopExecOrderList, 30);
	var errors = [];
	var ajaxConcurrency = function(chunk) {
		return new Promise(function(resolve) {
			$cm({
				ClassName: "Nur.NIS.Service.Base.OrderHandle",
				MethodName: "UpdateOrdGroupChunks",
				setSkinTest: "",
				oeoreIdStr: chunk.join("^"),
				execStatusCode: "D",
				userId: GlobalData.userID,
				userDeptId: GlobalData.locID,
				queryTypeCode: GlobalData.sheetCode,
				execDate: GlobalData.handleDate,
				execTime: GlobalData.handleTime,
				pcExecReasonDr:ReasonId,
				changeReasonDr: Reasoncomment,
				groupID: GlobalData.groupID,
				auditUser: GlobalData.secondUserID,
				isSttDateTime: ""
			},function(result){
				resolve(result);
			});
		});
	}
	Promise.all(Chunks.map(function(item) {
    	return ajaxConcurrency(item)
	})).then(function(promiseResult) {
		promiseResult.forEach(function(item) {
			if (String(item.success) !== "0") {
				errors = errors.concat(item.errList);
			}		
		});	
    	if (errors.length !== 0) {
	    	/*errors.forEach(function(error) {
		    	$.messager.popover({msg:error.errInfo,type:'alert'});
	    	})*/
			var errorMsg=[];
			errors.forEach(function(error) {
				errorMsg.push(error.errInfo);
	    	})
			$.messager.popover({msg:errorMsg.join("</br>"),type:'error'});
    	}else{
	    	if (IsCA) {
		    	initSignDataChunks(GlobalData.orderIDObj.stopExecOrderList, "DE");
		    }
	    	$.messager.popover({msg:"停止执行成功",type:'success'});
	    }
		updatePageData();
	})   
}
/**
 * @description 批量撤销执行医嘱
 */
function cancelOrderChunks() {
	var Chunks = splitChunk(GlobalData.orderIDObj.cancelExecOrderList, 30);
	var errors = [];
	var ajaxConcurrency = function(chunk) {
		return new Promise(function(resolve) {
			$cm({
				ClassName: "Nur.NIS.Service.Base.OrderHandle",
				MethodName: "UpdateOrdGroupChunks",
				setSkinTest: "",
				oeoreIdStr: chunk.join("^"),
				execStatusCode: "C",
				userId: GlobalData.userID,
				userDeptId: GlobalData.locID,
				queryTypeCode: GlobalData.sheetCode,
				execDate: GlobalData.handleDate,
				execTime: GlobalData.handleTime,
				changeReasonDr: String($("#handleNote").val()).trim(),
				groupID: GlobalData.groupID,
				auditUser: GlobalData.secondUserID,
				isSttDateTime: ""
			},function(result){
				resolve(result);
//				if (String(result.success) !== "0") {
//					errors = errors.concat(result.errList);
//				}
			});
		});
	}
	Promise.all(Chunks.map(function(item) {
    	return ajaxConcurrency(item)
	})).then(function(promiseResult) {
		promiseResult.forEach(function(item) {
			if (String(item.success) !== "0") {
				errors = errors.concat(item.errList);
			}		
		});	
    	if (errors.length !== 0) {
	    	/*errors.forEach(function(error) {
		    	$.messager.popover({msg:error.errInfo,type:'alert'});
	    	})*/
			var errorMsg=[];
			errors.forEach(function(error) {
				errorMsg.push(error.errInfo);
	    	})
			$.messager.popover({msg:errorMsg.join("</br>"),type:'error'});
    	}else{
	    	if (IsCA) {
		    	initSignDataChunks(GlobalData.orderIDObj.cancelExecOrderList, "CE");
		    }
	    	$.messager.popover({msg:"撤销执行成功",type:'success'});
	    }
		updatePageData();
	})
}
/**
 * @description 撤销条码关联
 */
function setPlacerNoGroup() {
	var Chunks = splitChunk(GlobalData.orderIDObj.clearPlacerNo, 30);
	var errors = [];
	var ajaxConcurrency = function(chunk) {
		return new Promise(function(resolve) {
			$m({
				ClassName: "Nur.NIS.Service.Base.OrderHandle",
				MethodName: "setPlacerNo",
				userId: GlobalData.userID,
				oeoreId: chunk.join("^"),
				placerNo: "",
				clearFlag: "Y",
				locID: GlobalData.locID
			},function(result){
				resolve(result)
//				if (String(result) !== "0") {
//					errors.push(result);
//				}
			});
		});
	}
	Promise.all(Chunks.map(function(item) {
    	return ajaxConcurrency(item)
	})).then(function(promiseResult) {
		promiseResult.forEach(function(item) {
			if (String(item) !== "0") {
				errors.push(item);
			}
		});
    	if (errors.length !== 0) {
	    	/*errors.forEach(function(error) {
		    	$.messager.popover({msg:error,type:'alert'});
	    	})*/
			var errorMsg=[];
			errors.forEach(function(error) {
				errorMsg.push(error);
	    	})
			$.messager.popover({msg:errorMsg.join("</br>"),type:'error'});
    	}else{
	    	$.messager.popover({msg:"撤销条码关联成功",type:'success'});
	    }
		updatePageData();
	})
}
/**
 * @description 置皮试结果
 */
function setSkinTestResult() {
	var errors = [];
	$m({
		ClassName: "Nur.NIS.Service.Base.OrderHandle",
		MethodName: "setSkinTestResult",
		oeoreId: GlobalData.orderIDObj.skinTestOrder,
		userId: GlobalData.userID, 
		flag: GlobalData.skinTestResult, 
		execStatusCode: "F", 
		ctlocId: GlobalData.locID, 
		queryTypeCode: GlobalData.sheetCode, 
		skinDate: GlobalData.handleDate, 
		skinTime: GlobalData.handleTime, 
		skinNote: "", 
		changeReasonDr: "", 
		batch: GlobalData.ifPPDOrder=="Y"?$("#skinTestNum-ppdSkinTest").val():String($("#skinTestNum").val()).trim(),
		auditUser: GlobalData.secondUserID,
		groupID: GlobalData.groupID	
	},function(result) {
		if (String(result) !== "0") {
			$.messager.popover({msg:result,type:'alert'});
			updatePageData();
		}else{
			if (GlobalData.ifPPDOrder === "Y") {
				var blisterState = $("input[name='blisterState']:checked").val()
				if (!blisterState) {
					blisterState = "";
				}
				$m({
					ClassName: "Nur.NIS.Service.Base.OrderHandle",
					MethodName: "SavePPDResult",	
					PPDResult: $("#ppdSkinTestResult").val(), 
					RecUser: GlobalData.userID, 
					TestDate: GlobalData.handleDate, 
					TestTime: GlobalData.handleTime, 
					TestOeoreDr: GlobalData.orderIDObj.skinTestOrder, 
					TestSkinSityOne: $("#induration-width").numberbox("getValue"), 
					TestSkinSityTwo: $("#induration-height").numberbox("getValue"), 
					TestSkinVclOne: $("#blister-width").numberbox("getValue"), 
					TestSkinVclTwo: $("#blister-height").numberbox("getValue"), 
					TestSkinSwoOne: $("#redSwollen-width").numberbox("getValue"), 
					TestSkinSwoTwo: $("#redSwollen-height").numberbox("getValue"), 
					TestSkinNecrosis: $("#deadLymphatic-necrosis").checkbox("getValue") ? "坏死" : "", 
					TestSkinInflam: $("#deadLymphatic-inflam").checkbox("getValue") ? "淋巴管炎" : "",
					TestSkinSing: blisterState,
					TestSkinDoubleloop: $("#deadLymphatic-doubleloop").checkbox("getValue") ? "双圈" : "",
					TestSkinVclNoHave: $("#blister-nohave").checkbox("getValue") ? "Y" : "N", //无局部水泡
					TestSkinSwoNoHave: $("#redSwollen-nohave").checkbox("getValue") ? "Y" : "N", //无红肿
					TestSkinSityNoHave: $("#induration-nohave").checkbox("getValue") ? "Y" : "N", //无皮肤硬结
				},function(ppdResult) {
					if (String(ppdResult) === "0") {
						$.messager.popover({msg:"置皮试结果成功",type:'success'});
      				} else {
        				$.messager.popover({msg:ppdResult,type:'error'});
      				}
      				updatePageData();
				})
			}else{
				if (IsCA) {
					var skinTestList = [GlobalData.orderIDObj.skinTestOrder];
		    		initSignDataChunks(skinTestList, "E");
		    	}
				$.messager.popover({msg:"置皮试结果成功",type:'success'});
				updatePageData();
			}
		}
	})
}
/**
 * @description 批量确认医嘱
 */
function confirmFee() {
	var Chunks = splitChunk(GlobalData.orderIDObj.confirmFeeList, 30);	
	var errors = [];
	var ajaxConcurrency = function(chunk) {
		return new Promise(function(resolve) {
			$cm({
				ClassName: "Nur.NIS.Service.Base.OrderHandle",
				MethodName: "ConfirmFeeChunks",
				oeoriIdStr: chunk.join("^"),
				userId: GlobalData.userID,
				date: GlobalData.handleDate,
				time: GlobalData.handleTime
			},function(result){
				resolve(result);
//				if (String(result.success) !== "0") {
//					errors = errors.concat(result.errList);
//				}
			});
		});
	}
	Promise.all(Chunks.map(function(item) {
    	return ajaxConcurrency(item)
	})).then(function(promiseResult) {
		promiseResult.forEach(function(item) {
			if (String(item.success) !== "0") {
				errors = errors.concat(item.errList);
			}		
		});
    	if (errors.length !== 0) {
	    	/*errors.forEach(function(error) {
		    	$.messager.popover({msg:error.errInfo,type:'alert'});
	    	})*/
			var errorMsg=[];
			errors.forEach(function(error) {
				errorMsg.push(error.errInfo);
	    	})
			$.messager.popover({msg:errorMsg.join("</br>"),type:'error'});
    	}else{
	    	$.messager.popover({msg:"确费成功",type:'success'});
	    }
	    updatePageData();
	})
}
/**
 * @description 把数组按照size分割成多维数组
 * @param {any} arr			  	待分割数组
 * @param {any} size			分割长度
 */
function splitChunk(arr, size) {
	var retArr=[];
	for(var i=0;i<arr.length;i=i+size){
		retArr.push(arr.slice(i, i+size));
	}
	return retArr;
}
/**
 * @description 刷新页面数据并关闭弹窗
 */
function updatePageData() {
	if (GlobalData.func) {
		GlobalData.func();
	}else{
		console.log("未执行刷新页面数据方法!")
	}
	$("#handleOrder").window('close'); 
}
/**
 * @description 关闭弹窗
 */
function closeEditWindow() {
	if ($("#handleOrder")) {
		$("#handleOrder").window('close'); 
	}
}
/**
 * @description 日期格式化
 */
function formatDate(date) {
    if (date && typeof date === 'object') {
        var day = date.getDate();
        day = day < 10 ? ('0' + day) : day;
        var monthIndex = date.getMonth() + 1;
        monthIndex = monthIndex < 10 ? ('0' + monthIndex) : monthIndex;
        var year = date.getFullYear();
        return year + '-' + monthIndex + '-' + day;
    } else if (date && typeof date === 'string') {
        var reg = /((^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(10|12|0?[13578])([-\/\._])(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(11|0?[469])([-\/\._])(30|[12][0-9]|0?[1-9])$)|(^((1[8-9]\d{2})|([2-9]\d{3}))([-\/\._])(0?2)([-\/\._])(2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([3579][26]00)([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][0][48])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][2468][048])([-\/\._])(0?2)([-\/\._])(29)$)|(^([1][89][13579][26])([-\/\._])(0?2)([-\/\._])(29)$)|(^([2-9][0-9][13579][26])([-\/\._])(0?2)([-\/\._])(29)$))/gi;
        if (reg.test(date)) {
            return date;
        }
        else {
            var regDDMMYYY = /(0[1-9]|[12][0-9]|3[01])[/](0[1-9]|1[012])[/](19|20)[0-9]{2}/gi;
            if (regDDMMYYY.test(date)) {
                var yyyy = date.split('/')[2];
                var MM = date.split('/')[1];
                var dd = date.split('/')[0];
                date = yyyy + '-' + MM + '-' + dd;;
                if (reg.test(date)) {
                    return date;
                }
            }
        }
    }
    return '';
}
function setHandleTimeMax(){
	if (!CompareDate(GlobalData.handleDate,myformatter(new Date()))){
		var oldHandleTime = GlobalData.handleTime;
		var data = $cm({ClassName: "Nur.NIS.Common.SystemConfig",MethodName: "GetCurrentDateTime",timeFormat: "1"},false)
		GlobalData.handleTime = data.time;
		$("#handleTime").timespinner({max:GlobalData.handleTime});
		if (oldHandleTime.replace(/:/g, "")>GlobalData.handleTime.replace(/:/g, "")){
			$("#handleTime").timespinner('setValue', GlobalData.handleTime);
		}
	}else{
		$("#handleTime").timespinner({max:null});
	}
}
function CompareDate(date1, date2) {
    var date1 = myparser(date1);
    var date2 = myparser(date2);
    if ( date1 < date2 ) {
        return true;
    }
    return false;
}
function myparser(s) {
    if (!s) return new Date();
    if (dtseparator == "/") {
        var ss = s.split('/');
        var y = parseInt(ss[2], 10);
        var m = parseInt(ss[1], 10);
        var d = parseInt(ss[0], 10);
    } else {
        var ss = s.split('-');
        var y = parseInt(ss[0], 10);
        var m = parseInt(ss[1], 10);
        var d = parseInt(ss[2], 10);
    }
    if (!isNaN(y) && !isNaN(m) && !isNaN(d)) {
        return new Date(y, m - 1, d);
    } else {
        return new Date();
    }
}
function myformatter(date) {
    var y = date.getFullYear();
    var m = date.getMonth() + 1;
    var d = date.getDate();
    if (dtseparator == "-") return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
    else if (dtseparator == "/") return (d < 10 ? ('0' + d) : d) + "/" + (m < 10 ? ('0' + m) : m) + "/" + y
    else return y + '-' + (m < 10 ? ('0' + m) : m) + '-' + (d < 10 ? ('0' + d) : d);
}
function getOrdIdByExecId(execOrderArr){
	var execOrderIDStr="";
	for (var i=0;i<execOrderArr.length;i++){
		var execID=execOrderArr[i];
		var execIDArr=execID.split("||");
		var ordId=execIDArr[0]+"||"+execIDArr[1];
		if (execOrderIDStr=="") execOrderIDStr=ordId;
		else if(("^"+execOrderIDStr+"^").indexOf("^"+ordId+"^")<0) execOrderIDStr=execOrderIDStr+"^"+ordId;
	}
	return execOrderIDStr;
}
function blisterNoHaveChange(e,value){
	if (value){
		$("#blister-width,#blister-height").numberbox("setValue","").numberbox("disable");
		$("#blisterState-sing,#blisterState-spora").radio("uncheck").radio("disable");
		caculateResult();
	}else{
		$("#blister-width,#blister-height").numberbox("enable");
		$("#blisterState-sing,#blisterState-spora").radio("enable");
	}
}
function redSwollenNoHaveChange(e,value){
	if (value){
		$("#redSwollen-width,#redSwollen-height").numberbox("setValue","").numberbox("disable");
		$("#deadLymphatic-doubleloop,#deadLymphatic-necrosis,#deadLymphatic-inflam").radio("uncheck").radio("disable");
		caculateResult();
	}else{
		$("#redSwollen-width,#redSwollen-height").numberbox("enable");
		$("#deadLymphatic-doubleloop,#deadLymphatic-necrosis,#deadLymphatic-inflam").radio("enable");
	}
}
function indurationNoHaveChange(e,value){
	if (value){
		$("#induration-width,#induration-height").numberbox("setValue","").numberbox("disable");
		caculateResult();
	}else{
		$("#induration-width,#induration-height").numberbox("enable");
	}
}