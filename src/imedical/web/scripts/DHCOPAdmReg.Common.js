/***
  **Description      :挂号相关的公共方法，比如公共的医保，数据处理、判断等等
  **Author           :tanjishan
  **Time             :2021/08/30
***/


//是否启用挂号医保实时结算
/*params*
*PatientID:患者ID
*ASRowId:出诊记录ID
*UseInsuFlag:界面医保标识(Y/N)【可选】
*[AdmReasonId]:费别ID【可选】
*[InsuReadCardInfo]:读医保卡的返回信息【可选】
*/
function IsEnableInsuBill(PatientID,ASRowId,UseInsuFlag,AdmReasonId,InsuReadCardInfo) {
	var IsEnableInsuBillFlag=false;
	// 【挂号设置】->【科室扩展设定】->医保挂号不能实时结算
	var CFLocInsuNotRealTime=$.cm({
		ClassName:"web.DHCOPAdmReg",
		MethodName:"GetCFLocInsuNotRealTime",
		dataType:"text",
		ASRowId:ASRowId
	},false);
	if (CFLocInsuNotRealTime=="1") return IsEnableInsuBillFlag;
	var InsurFlag=$.cm({
		ClassName:"web.DHCDocOrderCommon",
		MethodName:"GetInsurFlag",
		dataType:"text",
		BillType:AdmReasonId, PAAdmType:"O"
	},false);
	var CFEnableInsuBill=1;
	if ((typeof ServerObj!="undefined")&&(typeof ServerObj.CFEnableInsuBill!="undefined")){
		CFEnableInsuBill=ServerObj.CFEnableInsuBill;
	}
	//1.按费别优先
	if (CFEnableInsuBill==1) {
		if (InsurFlag==1){IsEnableInsuBillFlag=true}else{IsEnableInsuBillFlag=false}
	}
	//2.按界面传入参数优先
	if (CFEnableInsuBill==2) {
		if (UseInsuFlag=='Y') {
			if (InsurFlag==1){IsEnableInsuBillFlag=true}else{IsEnableInsuBillFlag=false}
		}else{
			IsEnableInsuBillFlag=false;
		}
	}
	return IsEnableInsuBillFlag;
}
//获取医保挂号的入参
function CallInsuBill(InsuBillParamsObj) {
	var GHLY="01";// 挂号来源 01窗口
	try {
		var myrtn=$.cm({
			ClassName:"web.DHCOPAdm",
			MethodName:"GetInsuBillPara",
			dataType:"text",
			LocDr:"", DocDr:"", PatId:InsuBillParamsObj.PatientID, UPatientName:InsuBillParamsObj.UPatientName, //1-4
			UserId:InsuBillParamsObj.UserID, ASRowId:InsuBillParamsObj.ASRowId, //5-6
			AdmReason:InsuBillParamsObj.AdmReasonId, FeeStr:InsuBillParamsObj.FeeStr, //7-8
			RegType:InsuBillParamsObj.RegType, InsuJoinType:"", FreeRegFeeFlag:InsuBillParamsObj.FreeRegFeeFlag, //9-11 
			InsuReadCardInfo:InsuBillParamsObj.InsuReadCardInfo, RetInsuGSInfo:InsuBillParamsObj.RetInsuGSInfo, //12-13
			ExpStr:InsuBillParamsObj.AccRowId+"^"+InsuBillParamsObj.PayModeCode+"^"+session['LOGON.GROUPID']+"^"+GHLY+"^"+$("#RegConDisList").combobox("getValue")
			//AccRowId:InsuBillParamsObj.AccRowId,PayModeCode:InsuBillParamsObj.PayModeCode //14-15
		},false);
		myrtn=InsuOPReg(0,InsuBillParamsObj.UserID,"","",InsuBillParamsObj.AdmReasonId,myrtn);
		return myrtn;
	}catch(e) {
		$.messager.alert("提示","医保接口封装函数程序异常,Err:"+e.message)
		return "";
	}
}

//获取医保挂号的出参中的总金额、现金部分的金额
//如果要获取现金部分的金额，需要初始化ServerObj.CashPayModeID现金支付方式
//总费用^现金费用
function GetInsuTotalAmount(InsuPayFeeStr){
	var TotalAmount=0;
	var CashFee=0;
	if (InsuPayFeeStr==""){
		return TotalAmount+"^"+CashFee;
	}
	var CashPayModeID="";
	if ((typeof ServerObj!="undefined")&&(typeof ServerObj.CashPayModeID!="undefined")){
		CashPayModeID=ServerObj.CashPayModeID;
	}

	for (var k=0;k<InsuPayFeeStr.split(String.fromCharCode(2)).length;k++) {
		var InsuPayModeStr=InsuPayFeeStr.split(String.fromCharCode(2))[k];
		var InsuPayModeAry=InsuPayModeStr.split('^');
		var InsuPayModeId=InsuPayModeAry[0];
		var InsuPayModeAmount=InsuPayModeAry[1];
		if ((CashPayModeID!="")&&(CashPayModeID==InsuPayModeId)) {
			CashFee=parseFloat(CashFee)+parseFloat(InsuPayModeAmount);
		}
		TotalAmount=parseFloat(TotalAmount)+parseFloat(InsuPayModeAmount);
	}
	return TotalAmount+"^"+CashFee;
}
//撤销医保交易
function ReturnInsuOPReg(PatientID,InsuAdmInfoDr,ASRowId,AdmReason){
	
	var UserID=session['LOGON.USERID'];
	//交易失败如果是医保的需要回退
	if (InsuAdmInfoDr!=""){
		var InsuRetValue=InsuOPRegStrike(0,UserID,InsuAdmInfoDr,"",AdmReason,"");
		if(InsuRetValue.split("^")[0]!="0"){
			//增加异常订单
			//挂号科室和医生ID根据排班ID获取
			//信息串：病人ID^就诊ID^医保指针^操作人^订单状态^排班ID^是否挂号
			var OPRegINABInfo=PatientID+"^"+""+"^"+InsuAdmInfoDr+"^"+UserID+"^"+"N"+"^"+ASRowId+"^"+"Y"+"^"+AdmReason;
			var ret=$.cm({
				ClassName:"web.DHCOPAdmReg",
				MethodName:"SaveDHCOPAdmINAB",
				dataType:"text",
				InfoStr:OPRegINABInfo
			},false);
			$.messager.alert("提示","回滚医保数据失败!");
		}
	}
}
