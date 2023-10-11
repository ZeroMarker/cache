/***
  **Description      :�Һ���صĹ������������繫����ҽ�������ݴ����жϵȵ�
  **Author           :tanjishan
  **Time             :2021/08/30
***/


//�Ƿ����ùҺ�ҽ��ʵʱ����
/*params*
*PatientID:����ID
*ASRowId:�����¼ID
*UseInsuFlag:����ҽ����ʶ(Y/N)����ѡ��
*[AdmReasonId]:�ѱ�ID����ѡ��
*[InsuReadCardInfo]:��ҽ�����ķ�����Ϣ����ѡ��
*/
function IsEnableInsuBill(PatientID,ASRowId,UseInsuFlag,AdmReasonId,InsuReadCardInfo) {
	var IsEnableInsuBillFlag=false;
	// ���Һ����á�->��������չ�趨��->ҽ���ҺŲ���ʵʱ����
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
	//1.���ѱ�����
	if (CFEnableInsuBill==1) {
		if (InsurFlag==1){IsEnableInsuBillFlag=true}else{IsEnableInsuBillFlag=false}
	}
	//2.�����洫���������
	if (CFEnableInsuBill==2) {
		if (UseInsuFlag=='Y') {
			if (InsurFlag==1){IsEnableInsuBillFlag=true}else{IsEnableInsuBillFlag=false}
		}else{
			IsEnableInsuBillFlag=false;
		}
	}
	return IsEnableInsuBillFlag;
}
//��ȡҽ���Һŵ����
function CallInsuBill(InsuBillParamsObj) {
	var GHLY="01";// �Һ���Դ 01����
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
		$.messager.alert("��ʾ","ҽ���ӿڷ�װ���������쳣,Err:"+e.message)
		return "";
	}
}

//��ȡҽ���Һŵĳ����е��ܽ��ֽ𲿷ֵĽ��
//���Ҫ��ȡ�ֽ𲿷ֵĽ���Ҫ��ʼ��ServerObj.CashPayModeID�ֽ�֧����ʽ
//�ܷ���^�ֽ����
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
//����ҽ������
function ReturnInsuOPReg(PatientID,InsuAdmInfoDr,ASRowId,AdmReason){
	
	var UserID=session['LOGON.USERID'];
	//����ʧ�������ҽ������Ҫ����
	if (InsuAdmInfoDr!=""){
		var InsuRetValue=InsuOPRegStrike(0,UserID,InsuAdmInfoDr,"",AdmReason,"");
		if(InsuRetValue.split("^")[0]!="0"){
			//�����쳣����
			//�Һſ��Һ�ҽ��ID�����Ű�ID��ȡ
			//��Ϣ��������ID^����ID^ҽ��ָ��^������^����״̬^�Ű�ID^�Ƿ�Һ�
			var OPRegINABInfo=PatientID+"^"+""+"^"+InsuAdmInfoDr+"^"+UserID+"^"+"N"+"^"+ASRowId+"^"+"Y"+"^"+AdmReason;
			var ret=$.cm({
				ClassName:"web.DHCOPAdmReg",
				MethodName:"SaveDHCOPAdmINAB",
				dataType:"text",
				InfoStr:OPRegINABInfo
			},false);
			$.messager.alert("��ʾ","�ع�ҽ������ʧ��!");
		}
	}
}
