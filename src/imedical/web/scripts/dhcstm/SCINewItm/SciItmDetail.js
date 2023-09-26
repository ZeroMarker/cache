//===========================================================================================================
var RowDelim = xRowDelim();
var PHCDFRowid = "";
var ArcRowid = "";
var storeConRowId = "";
var userId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var cspname = App_MenuCspName;

var PARA_AllowInputRp = "";
var PARA_AllowInputSp = "";
var PARA_SameCode = "";
var PARA_SameDesc = "";
var PARA_InitStatusNotUse = "";
var PARA_InciBatchReq = "";
var PARA_InciExpReq = "";
var PARA_ScMap = "";
var PARA_ArcimDescAutoMode = "";
var PARA_SetNotUseFlagEdit = "";
var ASP_STATUS = "";
var ASP = "";
var PARA_BATSPFLAG = "";
var PARA_ModifyBillCode = "";
var PARA_SetChargeFlagEdit = "";
var SciInciRowid="";
//ȡ����ֵ
function GetCodeMainPara() {
	var appName = 'DHCSTDRUGMAINTAINM';
	var paraObj = GetAppPropValue(appName);
	if (paraObj) {
		PARA_AllowInputRp = paraObj.AllowInputRp;
		PARA_AllowInputSp = paraObj.AllowInputSp;
		PARA_SameCode = paraObj.SameCode;
		PARA_SameDesc = paraObj.SameDesc;
		PARA_InitStatusNotUse = paraObj.SetInitStatusNotUse;
		PARA_ScMap = paraObj.ScMap;
		PARA_InciBatchReq = paraObj.InciBatchReq;
		PARA_InciExpReq = paraObj.InciExpReq;
		PARA_InciBatchReq = PARA_InciBatchReq == 'N' ? 'NONREQUIRED' : PARA_InciBatchReq == 'O' ? PARA_InciBatchReq = 'OPTIONAL' : 'REQUIRED';
		PARA_InciExpReq = PARA_InciExpReq == 'N' ? 'NONREQUIRED' : PARA_InciExpReq == 'O' ? PARA_InciExpReq = 'OPTIONAL' : 'REQUIRED';
		PARA_ArcimDescAutoMode = paraObj.ArcimDescAutoMode;
		PARA_SetNotUseFlagEdit = paraObj.SetNotUseFlagEdit;
		PARA_ModifyBillCode = paraObj.ModifyBillCode == 'Y' ? true : false;
		PARA_SetChargeFlagEdit = paraObj.SetChargeFlagEdit;
	}
	PARA_BATSPFLAG = isBatSp();

}

function isBatSp() {
	var appName = 'DHCSTCOMMONM';
	var paraStr = GetAppPropValue(appName);
	return paraStr.BatSp;
}

//����rowid��ѯ
function GetDetail(rowid,SciRowid) {
	SciInciRowid=SciRowid;
	if(rowid==""){
		
		
		
	}else{
		var url = 'dhcstm.druginfomaintainaction.csp?actiontype=GetDetail&InciRowid=' + rowid;
	    Ext.Ajax.request({
		url: url,
		method: 'POST',
		waitMsg: '��ѯ��...',
		success: function (result, request) {
			var s = result.responseText;
			//s = s.replace("\r\n", "");// �������ȷ�ģ�
			s = s.replace(/\r/g, "")
				s = s.replace(/\n/g, "")
				var jsonData = Ext.util.JSON.decode(s);
			if (jsonData.success == 'true') {
				var ListData = jsonData.info.split(RowDelim);
				SetIncDetail(ListData[0]);
				SetFormOriginal(ItmPanel);
				SetArcDetail(ListData[1]);
				SetFormOriginal(ItmMastPanel);

			} else {
				Msg.info("error", "��ѯ����:" + jsonData.info);
			}
		},
		scope: this
	    });
	}
	
}
//���SCI�������Ϣ
function SetSciIncDetail(listData){
	Ext.getCmp("INCICode").setValue("1"); //����
    Ext.getCmp("INCIDesc").setValue("2"); //����
}

//��ѯ�������Ϣ,zdm,2011-12-23
function SetIncDetail(listData) {
	if (listData == null || listData == "") {
		return;
	}
	var list = listData.split("^");
	if (list.length > 0) {
		ArcRowid = list[0];
		Ext.getCmp("INCICode").setValue(list[1]); //����
		Ext.getCmp("INCIDesc").setValue(list[2]); //����
		addComboData(CTUomStore, list[3], list[4]);
		Ext.getCmp("INCICTUom").setValue(list[3]); //������λ
		addComboData(CONUomStore, list[5], list[6]);
		Ext.getCmp("PUCTUomPurch").setValue(list[5]); //��ⵥλ
		addComboData(StkCatStore, list[7], list[8]);
		Ext.getCmp("StkCat").setValue(list[7]); //������
		Ext.getCmp("INCIIsTrfFlag").setValue(list[9]); //ת�Ʒ�ʽ
		Ext.getCmp("INCIBatchReq").setValue(list[10]); //����
		Ext.getCmp("INCIExpReqnew").setValue(list[11]); //��Ч��
		Ext.getCmp("INCAlias").setValue(list[12]); //����
		Ext.getCmp("INCINotUseFlag").setValue(list[13] == 'Y' ? true : false); //�����ñ�־
		Ext.getCmp("INCIReportingDays").setValue(list[14]); //Э����
		Ext.getCmp("INCIBarCode").setValue(list[15]); //����
		Ext.getCmp("INCIBSpPuruom").setValue(list[18]); //�ۼ�
		Ext.getCmp("INCIBRpPuruom").setValue(list[19]); //����
		addComboData(Ext.getCmp("supplyLocField").getStore(), list[20], list[21]); //��Ӧ�ֿ�
		Ext.getCmp("supplyLocField").setValue(list[20]);
		Ext.getCmp("remark").setValue(handleMemo(list[22], xMemoDelim())); //��עhandleMemo(dataArr[10],xMemoDelim())
		Ext.getCmp("INFOImportFlag").setValue(list[23]); //���ڱ�־
		addComboData(INFOQualityLevelStore, list[74], list[24]);
		Ext.getCmp("INFOQualityLevel").setValue(list[74]);
		Ext.getCmp("INFOQualityNo").setValue(list[30]);
		Ext.getCmp("INFOComFrom").setValue(list[31]);
		Ext.getCmp("INFORemark2").setValue(list[32]); //ע��֤��
		Ext.getCmp("INFOHighPrice").setValue(list[33] == 'Y' ? true : false); //��ֵ���־
		Ext.getCmp("INFOMT").setValue(list[35]); //��������id
		Ext.getCmp("INFOMT").setRawValue(list[36]); //��������
		Ext.getCmp("INFOMaxSp").setValue(list[37]); //����ۼ�
		storeConRowId = list[38]; //�洢����id
		Ext.getCmp("INFOISCDR").setValue(getStoreConStr(drugRowid)); //�洢����
		Ext.getCmp("INFOInHosFlag").setValue(list[39] == 'Y' ? true : false); //��Ժ����Ŀ¼
		Ext.getCmp("INFOPbFlag").setValue(list[40] == 'Y' ? true : false); //�б��־
		Ext.getCmp("INFOPbRp").setValue(list[41]); //�б����
		addComboData(INFOPBLevelStore, list[73], list[42]);
		Ext.getCmp("INFOPBLevel").setValue(list[73]); //�б꼶��
		addComboData(INFOPbVendor.getStore(), list[43], list[44]);
		Ext.getCmp("INFOPbVendor").setValue(list[43]);
		addComboData(PhManufacturerStore, list[45], list[46]);
		Ext.getCmp("INFOPbManf").setValue(list[45]);
		addComboData(CarrierStore, list[47], list[48]);
		Ext.getCmp("INFOPbCarrier").setValue(list[47]);
		Ext.getCmp("INFOPBLDR").setValue(list[49]);
		Ext.getCmp("INFOBAflag").setValue(list[51] == 'Y' ? true : false); //һ���Ա�־
		Ext.getCmp("INFOExpireLen").setValue(list[52]);
		Ext.getCmp("INFOPrcFile").setValue(list[53]);
		Ext.getCmp("INFOPriceBakD").setValue(list[54]); //����ļ�����
		Ext.getCmp("INFOBCDr").setValue(list[56]); //�ʲ�����id
		Ext.getCmp("INFOBCDr").setRawValue(list[57]); //�ʲ�����
		Ext.getCmp("INFODrugBaseCode").setValue(list[62]); //���ʱ�λ��
		Ext.getCmp("INFOSpec").setValue(list[64]); //���
		addComboData(ItmNotUseReasonStore, list[65], list[66]);
		Ext.getCmp("ItmNotUseReason").setValue(list[65]); //������ԭ��
		Ext.getCmp("PHCDOfficialType").setValue(list[67]); //ҽ�����
		Ext.getCmp("HighRiskFlag").setValue(list[69] == 'Y' ? true : false); //��Σ��־
		addComboData(CTUomStore, list[70], list[71]);
		Ext.getCmp("PackUom").setValue(list[70]); //���װ��λ
		Ext.getCmp("PackUomFac").setValue(list[72]); //���װ��λϵ��
		Ext.getCmp("INFOBrand").setValue(list[75]); //Ʒ��
		Ext.getCmp("INFOModel").setValue(list[76]); //�ͺ�
		Ext.getCmp("INFOChargeFlag").setValue(list[77] == 'Y' ? true : false); //�շѱ�־
		enableArcItm(Ext.getCmp("INFOChargeFlag").getValue());
		Ext.getCmp("INFOAbbrev").setValue(list[78]); //���
		Ext.getCmp("INFOSupervision").setValue(list[79]); //��ܼ���
		Ext.getCmp("INFOImplantationMat").setValue(list[80] == 'Y' ? true : false); //ֲ���־
		Ext.getCmp("reqType").setValue(list[81]); //������������
		Ext.getCmp("INFONoLocReq").setValue(list[82] == 'Y' ? true : false); //��ֹ�����־
		Ext.getCmp("INFOSterileDateLen").setValue(list[83]); //���ʱ��
		Ext.getCmp("INFOZeroStk").setValue(list[84] == 'Y' ? true : false); //�����־
		addComboData(INFOChargeTypeFlagStore, list[85], list[86]);
		Ext.getCmp("INFOChargeType").setValue(list[85]); //�շ�����
		//Ext.getCmp("INFOMedEqptCat").setValue(list[87]);  //��е����
		Ext.getCmp("IRRegCertExpDate").setValue(list[88]); //ע��֤Ч��
		Ext.getCmp("INFOPackCharge").setValue(list[89]); //����շѱ�־
		Ext.getCmp("PreExeDate").setValue(list[93]); //�۸���Ч����
		addComboData(Ext.getCmp("StkGrpType").getStore(), list[94], list[95], StkGrpType);
		Ext.getCmp("StkGrpType").setValue(list[94]); //����

		ASP_STATUS = list[96];
		ASP = list[97];
		Ext.getCmp("HospZeroStk").setValue(list[98]); //Ժ�������־
		var regData = list[90].split("|");
		var regItmDesc = regData[0];
		var regDateOfIssue = regData[1];
		var regExpExtended = (regData[2] == 'Y' ? true : false);
		Ext.getCmp("SCategory").setValue(list[99]); //�������id
		Ext.getCmp("SCategory").setRawValue(list[100]); //�������
		Ext.getCmp("MatQuality").setValue(list[101]);
		//var regNoFull=regData[3];
		var bidDate = regData[4];
		var firstReqDept = regData[5];
		var firstReqDeptDesc = regData[6];
		var origin = regData[7];
		var originName = regData[8];
		Ext.getCmp("IRRegCertItmDesc").setValue(regItmDesc);
		Ext.getCmp("IRRegCertDateOfIssue").setValue(regDateOfIssue);
		Ext.getCmp("IRRegCertExpDateExtended").setValue(regExpExtended);
		//Ext.getCmp("IRRegCertNoFull").setValue(regNoFull);
		Ext.getCmp('BidDate').setValue(bidDate);
		if ((firstReqDept != "") && (firstReqDept != null)) {
			var ds = Ext.getCmp('FirstReqDept').getStore();
			ds.removeAll();
			addComboData(ds, firstReqDept, firstReqDeptDesc);
		}
		Ext.getCmp('FirstReqDept').setValue(firstReqDept);
		if ((origin != "") && (origin != null)) {
			var ds = Ext.getCmp('Origin').getStore();
			ds.removeAll();
			addComboData(ds, origin, originName);
		}
		Ext.getCmp('Origin').setValue(origin);
		Ext.getCmp('INFOInterMat').setValue(list[91]);
		Ext.getCmp('INFOOrgan').setValue(list[92]);
		if (drugRowid > 0) {
			CheckItmUsed(drugRowid);
		}
	}
}
//��ѯҽ������Ϣ,zdm,2011-12-23
function SetArcDetail(listData) {
	var list = listData.split("^");
	if (list.length > 0) {
		Ext.getCmp("ARCIMCode").setValue(list[1]);
		Ext.getCmp("ARCIMDesc").setValue(list[2]);
		addComboData(CTUomStore, list[3], list[4]);
		Ext.getCmp("ARCIMUomDR").setValue(list[3]);
		addComboData(ArcItemCatStore, list[5], list[6]);
		Ext.getCmp("ARCItemCat").setValue(list[5]);
		var BillGrpId = list[8].split("||")[0];
		addComboData(ArcBillGrpStore, BillGrpId, list[7]);
		Ext.getCmp("ARCBillGrp").setValue(BillGrpId);
		addComboData(ArcBillSubStore, list[8], list[9]);
		Ext.getCmp("ARCBillSub").setValue(list[8]);
		Ext.getCmp("ARCIMOrderOnItsOwn").setValue(list[10] == 'Y' ? true : false); //����ҽ��
		addComboData(OECPriorityStore, list[11], list[12]);
		Ext.getCmp("OECPriority").setValue(list[11]);
		Ext.getCmp("WoStockFlag").setValue(list[13] == 'Y' ? true : false); //�޿��ҽ��
		Ext.getCmp("ARCIMText1").setValue(list[14]);
		Ext.getCmp("ARCIMAbbrev").setValue(list[15]);
		Ext.getCmp("ARCIMNoOfCumDays").setValue(list[17]);
		Ext.getCmp("ARCIMOEMessage").setValue(list[24]);
		Ext.getCmp("ARCIMEffDate").setValue(list[25]);
		Ext.getCmp("ARCIMEffDateTo").setValue(list[26]);
		addComboData(OrderCategoryStore, list[28], list[27]);
		Ext.getCmp("OrderCategory").setValue(list[28]);
		Ext.getCmp("ARCAlias").setValue(list[29]);

		addComboData(TarSubCateStore, list[30], list[31]);
		Ext.getCmp("SubTypeFee").setValue(list[30]);
		addComboData(TarAcctCateStore, list[32], list[33]);
		Ext.getCmp("AccountSubTypeFee").setValue(list[32]);
		addComboData(TarMRCateStore, list[34], list[35]);
		Ext.getCmp("MedSubTypeFee").setValue(list[34]);
		addComboData(TarNewMRCateStore, list[45], list[46]);
		Ext.getCmp("NewMedSubTypeFee").setValue(list[45]); //�²�����ҳ����
		addComboData(TarInpatCateStore, list[36], list[37]);
		Ext.getCmp("InSubTypeFee").setValue(list[36]);
		addComboData(TarOutpatCateStore, list[38], list[39]);
		Ext.getCmp("OutSubTypeFee").setValue(list[38]);
		addComboData(TarEMCCateStore, list[40], list[41]);
		Ext.getCmp("AccSubTypeFee").setValue(list[40]);
		//�շ������
		Ext.getCmp("BillCode").setValue(list[42]);
		//�շ�������
		Ext.getCmp("BillName").setValue(list[43]);
		Ext.getCmp("BillNotActive").setValue(list[44] == '0' ? true : false); //�Ƿ�ά���շ���Ŀ
		Ext.getCmp("ChargeBasis").setValue(list[47]);		//�շ�����
	}
}

function clearData() {
	//ҽ����
	Ext.getCmp("LinkArcRowid").setValue("");
	SciInciRowid="";
	ARCIMCode.setValue("");
	ARCIMDesc.setValue("");
	ARCIMEffDate.setValue("");
	ARCAlias.setValue("");
	ARCBillGrp.setValue("");
	ARCBillGrp.setRawValue("");
	ARCIMUomDR.setValue("");
	ARCIMUomDR.setRawValue("");
	ARCBillSub.setValue("");
	ARCBillSub.setRawValue("");
	OECPriority.setValue("");
	OECPriority.setRawValue("");
	ARCIMEffDateTo.setValue("");
	ARCIMOEMessage.setValue("");
	OrderCategory.setValue("");
	OrderCategory.setRawValue("");
	ARCItemCat.setValue("");
	ARCItemCat.setRawValue("");
	ARCIMAbbrev.setValue("");
	ARCIMText1.setValue("");
	ARCIMNoOfCumDays.setValue("");
	BillNotActive.setValue(false);
	BillCode.setValue("");
	BillName.setValue("");
	INFOSterileDateLen.setValue("");
	ARCIMOrderOnItsOwn.setValue(false);
	PHCDOfficialType.setValue("");
	MedProMaintain.setValue(false);
	//�շѷ���
	SubTypeFee.setValue("");
	OutSubTypeFee.setValue("");
	InSubTypeFee.setValue("");
	AccSubTypeFee.setValue("");
	MedSubTypeFee.setValue("");
	NewMedSubTypeFee.setValue("");
	AccountSubTypeFee.setValue("");

	//�����
	INCICode.setValue("");
	INCIDesc.setValue("");
	INFOSpec.setValue("");
	Ext.getCmp("INCICTUom").setDisabled(false);
	INCICTUom.setValue("");
	INCICTUom.setRawValue("");
	PUCTUomPurch.setValue("");
	PUCTUomPurch.setRawValue("");
	StkCat.setValue("");
	StkCat.setRawValue("");
	StkGrpType.setValue("");
	StkGrpType.setRawValue("");
	INCAlias.setValue("");

	INFOExpireLen.setValue("");
	INFOZeroStk.setValue("");
	INFOPackCharge.setValue("")
	INFOChargeType.setRawValue("");
	INFOChargeType.setValue("");
	INFOMedEqptCat.setValue("");
	Ext.getCmp("INCIBatchReq").setValue('REQUIRED');
	Ext.getCmp("INCIExpReqnew").setValue('REQUIRED');
	Ext.getCmp('INCIIsTrfFlag').setValue('TRANS');

	INFOPBLevel.setValue("");
	INFOPBLevel.setRawValue("");
	INFOBCDr.setValue("");
	INFOBCDr.setRawValue("");
	INCIBRpPuruom.setValue("");
	INCIBSpPuruom.setValue("");
	PreExeDate.setValue("");
	INFOPrcFile.setValue("");
	INCIBarCode.setValue("");
	INFOPriceBakD.setValue("");
	INFODrugBaseCode.setValue("");
	INCINotUseFlag.setValue(false);
	ItmNotUseReason.setValue("");
	ItmNotUseReason.setRawValue("");
	INFOImportFlag.setValue("");
	INFOQualityNo.setValue("");
	INFOMT.setValue("");
	INFOMT.setRawValue("");
	INFOMaxSp.setValue("");
	INFOComFrom.setValue("");
	INFORemark1.setValue("");
	INFORemark1.setRawValue("");
	INFORemark2.setValue("");
	INFOQualityLevel.setValue("");
	INFOQualityLevel.setRawValue("");
	INCIReportingDays.setValue("");
	INFOPBLDR.setValue("");
	INFOPBLDR.setRawValue("");
	INFOPbVendor.setValue("");
	INFOPbVendor.setRawValue("");
	INFOPbManf.setValue("");
	INFOPbManf.setRawValue("");
	INFOPbCarrier.setValue("");
	INFOPbCarrier.setRawValue("");
	INFOPbRp.setValue("");
	INFOISCDR.setValue("");
	INFOPbFlag.setValue(false);
	INFOBAflag.setValue(false);
	INFOHighPrice.setValue(false);
	INFOChargeFlag.setValue(false);
	INFOInHosFlag.setValue(false);
	HighRiskFlag.setValue(false);
	INFONoLocReq.setValue(false);
	PackUom.setValue("");
	PackUom.setRawValue("");
	PackUomFac.setValue("");
	INFOBrand.setValue("");
	INFOModel.setValue("");
	INFOAbbrev.setValue("");
	INFOSupervision.setValue("");
	remark.setValue("");
	supplyLocField.setValue("");
	reqType.setValue(""); //���ó�ʼ
	ArcRowid = "";
	drugRowid = "";

	INFOImplantationMat.setValue(false);
	IRRegCertExpDate.setValue("");

	ASP_STATUS = "";
	ASP = "";

	IRRegCertItmDesc.setValue("");
	HospZeroStk.setValue(""); //Ժ�������־
	//IRRegCertNoFull.setValue("");
	IRRegCertDateOfIssue.setValue("");
	IRRegCertExpDateExtended.setValue(false);
	BidDate.setValue("");
	FirstReqDept.setValue("");
	Origin.setValue("");
	INFOInterMat.setValue(false);
	INFOOrgan.setValue(false);
	//
	InitDetailForm();
};

//��ʼ������
function InitDetailForm() {

	if (PARA_AllowInputRp == 'Y') {
		Ext.getCmp('INCIBRpPuruom').setDisabled(false);
	} else {
		Ext.getCmp('INCIBRpPuruom').setDisabled(true);
	}
	if (PARA_AllowInputSp == 'Y') {
		Ext.getCmp('INCIBSpPuruom').setDisabled(false);
	} else {
		Ext.getCmp('INCIBSpPuruom').setDisabled(true);
	}
	if (PARA_SameCode == 'Y') {
		Ext.getCmp('INCICode').setDisabled(false);
	} else {
		Ext.getCmp('INCICode').setDisabled(false);
	}
	if (PARA_SameDesc == 'Y') {
		Ext.getCmp('INCIDesc').setDisabled(false);
	} else {
		Ext.getCmp('INCIDesc').setDisabled(false);
	}
	if (PARA_InitStatusNotUse == 'Y') {
		Ext.getCmp('INCINotUseFlag').setValue(true);
	} else {
		Ext.getCmp('INCINotUseFlag').setValue(false);
	}
	if (PARA_SetNotUseFlagEdit == 'Y') {
		Ext.getCmp('INCINotUseFlag').setDisabled(true);
	} else {
		Ext.getCmp('INCINotUseFlag').setDisabled(false);
	}
	if (PARA_SetChargeFlagEdit == 'Y') {
		Ext.getCmp('INFOChargeFlag').setDisabled(true);
	} else {
		Ext.getCmp('INFOChargeFlag').setDisabled(false);
	}
	Ext.getCmp("INCIBatchReq").setValue(PARA_InciBatchReq);
	Ext.getCmp("INCIExpReqnew").setValue(PARA_InciExpReq);
	Ext.getCmp('PreExeDate').setDisabled(false);
	if (PARA_BATSPFLAG == '1') {
		Ext.getCmp('INCIBSpPuruom').setDisabled(false);
	} //�����ۼ�ʱ�ۼ۲�����༭
	var elemidstr = getelemid(); //��ʼ��������
	changeElementInfo(elemidstr, cspname);

	//������һ�����õĶ�������,��Ĭ����ʾ
	MarkTypeStore.load({
		callback: function (r, options, success) {
			if (this.getTotalCount() == 1 && r.length == 1) {
				INFOMT.setValue(r[0].get(INFOMT.valueField));
				INFOMT.originalValue = INFOMT.getValue();
			}
		}
	});

	SetFormOriginal(ItmPanel);
	SetFormOriginal(ItmMastPanel);
}



// ������������Ϣ,zdm,2011-12-20
function saveData() {
	if ((IsFormChanged(ItmPanel) || IsFormChanged(ItmMastPanel)) == false) {
		Msg.info("warning", "������Ϣ����δ�����ı�!");
		return;
	}
	//�շѱ�־
	var chargeFlag = (Ext.getCmp("INFOChargeFlag").getValue() == true ? 'Y' : 'N'); //�շѱ�־
	var elemidstr = getelemid();
	if (getElementInfo(elemidstr, cspname, chargeFlag) == false) {
		return;
	}
	var INCIDesc = Ext.getCmp("INCIDesc").getValue();
	var BuomId = Ext.getCmp("INCICTUom").getValue();
	var PurUomId = Ext.getCmp("PUCTUomPurch").getValue();
	var StkCatId = Ext.getCmp("StkCat").getValue();
	var HighPrice = (Ext.getCmp("INFOHighPrice").getValue() == true ? 'Y' : 'N'); //��ֵ���־
	var TableFlag = Ext.getCmp('HighRiskFlag').getValue()?'Y':'N';
	var WoStockFlag = (Ext.getCmp("WoStockFlag").getValue() == true ? 'Y' : 'N'); //�޿��ҽ��
	if ((HighPrice == "Y" && TableFlag!="Y") && (WoStockFlag == "Y")) {
		Msg.info("warning", "����" + INCIDesc + "Ϊ��ֵ�Ĳı���ȥ��<�޿��ҽ��>�Ĺ�ѡ!");
		return;
	}
	if ((HighPrice == "Y" && TableFlag == "Y") && (WoStockFlag != "Y")) {
		Msg.info("warning", "����" + INCIDesc + "Ϊ��̨��ֵ, �蹴ѡ<�޿��ҽ��>!");
		return;
	}
	var manf = Ext.getCmp("INFOPbManf").getValue();
	var regCertNo = Ext.getCmp("INFORemark2").getValue();
	var regCertExp = Ext.getCmp("IRRegCertExpDate").getValue();
	if ((manf == "") && ((regCertNo != "") || (regCertExp != ""))) {
		Msg.info('warning', '���̲���Ϊ�գ�');
		talPanel.setActiveTab(0);
		Ext.getCmp("INFOPbManf").focus();
		return;
	}

	if (Ext.getCmp("INCICode").isDirty()) {
		Ext.getCmp("INCICode").fireEvent('blur', Ext.getCmp("INCICode"));
	}
	if (Ext.getCmp("INCIDesc").isDirty() || Ext.getCmp("INFOSpec").isDirty()) {
		Ext.getCmp("INCIDesc").fireEvent('blur', Ext.getCmp("INCIDesc"));
	}

	var listArc = "";
	var listInc = "";
	if (chargeFlag == "Y") {
		//�Ƽ۵�λ����Ϊ��
		var BillUomDr = Ext.getCmp("ARCIMUomDR").getValue();
		var BillSubId = Ext.getCmp("ARCBillSub").getValue();
		var ItemCatId = Ext.getCmp("ARCItemCat").getValue();
		var BillGrpId = Ext.getCmp("ARCBillGrp").getValue();
		if ((BillUomDr != BuomId) & (BillUomDr != PurUomId)) {
			talPanel.setActiveTab(1);
			Msg.info("warning", "�Ƽ۵�λ�����ǿ���������λ��");
			Ext.getCmp("ARCIMUomDR").focus();
			return;
		}
		if ((PARA_BATSPFLAG != '1') && (drugRowid == "")) { //�������ۼ�
			var INCIBSpPuruom = Ext.getCmp("INCIBSpPuruom").getValue();
			if (INCIBSpPuruom == null || INCIBSpPuruom === "") {
				talPanel.setActiveTab(0);
				Ext.getCmp("INCIBSpPuruom").focus();
				Msg.info("warning", "���ۼ۲���Ϊ��!");
				return;
			}
		}

		listArc = getArcList();
		if (listArc == '') {
			return;
		}
	}
	
	var TableFlag = Ext.getCmp('HighRiskFlag').getValue();
	var HVFlag = Ext.getCmp('INFOHighPrice').getValue();
	if(TableFlag && !HVFlag){
		Msg.info('warning', '����ֵ�ĲĿ�ά����̨��־!');
		return false;
	}
	
	listInc = getIncList();
	if (listInc == '') {
		return;
	}
	var loadMask = ShowLoadMask(document.body, "������...");
	var url = "dhcstm.druginfomaintainaction.csp?actiontype=SaveData";
	Ext.Ajax.request({
		url: url,
		params: {
			ListArc: listArc,
			ListInc: listInc,
			drugRowid: drugRowid
		},
		method: 'POST',
		waitMsg: '������...',
		failure: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			//loadMask.hide();
			if (jsonData.success == 'true') {
				var InciRowid = jsonData.info;
				//ҽ����rowid^�����rowid
				var arr = InciRowid.split("^");
				Msg.info("success", "����ɹ�!");
				//���ÿ����rowid��ʾ��������ϸ��Ϣ�͵�Ч��λ
				clearData();
				drugRowid = arr[1]; //ΪDrugInfoList.js�б�����ֵ,�����ٴα���ʱ����.ע��clearData()�е����.
				GetDetail(arr[1]);
				//����ɹ���������ť����
				Ext.getCmp("IncAliasButton").setDisabled(false);
				Ext.getCmp("HospZeroStkButton").setDisabled(false);
				//���ñ���
				Ext.getCmp("ArcAliasButton").setDisabled(false);
			} else {
				if (jsonData.info == -61) {
					Msg.info("error", "����Ϊ��!");
				} else if (jsonData.info == -62) {
					Msg.info("error", "����Ϊ��!");
				} else if (jsonData.info == -63) {
					Msg.info("error", "����Ϊ��!");
				} else if (jsonData.info == -64) {
					Msg.info("error", "��λΪ��!");
				} else if (jsonData.info == -65) {
					Msg.info("error", "�÷�Ϊ��!");
				} else if (jsonData.info == -20) {
					Msg.info("error", "ҽ�������Ϊ��!");
				} else if (jsonData.info == -21) {
					Msg.info("error", "ҽ��������Ϊ��!");
				} else if (jsonData.info == -22) {
					Msg.info("error", "�Ƽ۵�λΪ��!");
				} else if (jsonData.info == -23) {
					Msg.info("error", "���ô���Ϊ��!");
				} else if (jsonData.info == -24) {
					Msg.info("error", "��������Ϊ��!");
				} else if (jsonData.info == -25) {
					Msg.info("error", "ҽ������Ϊ��!");
				} else if (jsonData.info == -26) {
					Msg.info("error", "ҩѧ��idΪ��!");
				} else if (jsonData.info == -27) {
					Msg.info("error", "��Ч��ҽ���ӷ���!");
				} else if (jsonData.info == -28) {
					Msg.info("error", "��Ч�ķ��ô���!");
				} else if (jsonData.info == -29) {
					Msg.info("error", "��Ч�ķ�������!");
				} else if (jsonData.info == -30) {
					Msg.info("error", "��Ч��ҩѧ��!");
				} else if (jsonData.info == -31) {
					Msg.info("error", "��Ч�ļƼ۵�λ!");
				} else if (jsonData.info == -32) {
					Msg.info("error", "ҽ��������ظ�!");
				} else if (jsonData.info == -33) {
					Msg.info("error", "ҽ���������ظ�!");
				} else if (jsonData.info == -81) {
					Msg.info("error", "����ҽ��������ʧ��!");
				} else if (jsonData.info == -82) {
					Msg.info("error", "����ҽ����ӱ�ʧ��!");
				} else if (jsonData.info == -83) {
					Msg.info("error", "����ҽ�������ʧ��!");
				} else if (jsonData.info == -16) {
					Msg.info("error", "ʧ��,ҽ����Id����Ϊ��!");
				} else if (jsonData.info == -11) {
					Msg.info("error", "ʧ��,�������벻��Ϊ��!");
				} else if (jsonData.info == -12) {
					Msg.info("error", "ʧ��,��������Ʋ���Ϊ��!");
				} else if (jsonData.info == -13) {
					Msg.info("error", "ʧ��,������λ����Ϊ��!");
				} else if (jsonData.info == -14) {
					Msg.info("error", "ʧ��,��ⵥλ����Ϊ��!");
				} else if (jsonData.info == -15) {
					Msg.info("error", "ʧ��,������Ϊ��!");
				} else if (jsonData.info == -17) {
					Msg.info("error", "ʧ��,ת�Ʒ�ʽ����Ϊ��!");
				} else if (jsonData.info == -18) {
					Msg.info("error", "ʧ��,�Ƿ�Ҫ�����β���Ϊ��!");
				} else if (jsonData.info == -19) {
					Msg.info("error", "ʧ��,�Ƿ�Ҫ��Ч�ڲ���Ϊ��!");
				} else if (jsonData.info == -91) {
					Msg.info("error", "��������ʧ��!");
				} else if (jsonData.info == -92) {
					Msg.info("error", "��������ӱ�ʧ��!");
				} else if (jsonData.info == -93) {
					Msg.info("error", "�����������ʧ��!");
				} else if (jsonData.info == -94) {
					Msg.info("error", "����۸�ʧ��!");
				} else if (jsonData.info == -1) {
					Msg.info("error", "��Ч�Ŀ�����!");
				} else if (jsonData.info == -3) {
					Msg.info("error", "��Ч��ҽ����!");
				} else if (jsonData.info == -4) {
					Msg.info("error", "��Ч�Ļ�����λ!");
				} else if (jsonData.info == -5) {
					Msg.info("error", "��Ч����ⵥλ!");
				} else if (jsonData.info == -6) {
					Msg.info("error", "���������Ѿ����ڣ������ظ�!");
				} else if (jsonData.info == -7) {
					Msg.info("error", "����������Ѿ����ڣ������ظ�!");
				} else if (jsonData.info == -8) {
					Msg.info("error", "������λ����ⵥλ֮�䲻����ת����ϵ!");
				} else if (jsonData.info == -9) {
					Msg.info("error", "����������Ѿ����ڣ������ظ�!");
				} else {
					Msg.info("error", "����ʧ��:" + jsonData.info);
				}
			}
		},
		callback: function () {
			loadMask.hide();
		},
		scope: this
	});
}

function getIncList() {
	// ��������ݴ�:����^����^������λid^��ⵥλid^������id^ת�Ʒ�ʽ^�Ƿ�Ҫ������^�Ƿ�Ҫ��Ч��^����^�����ñ�־^Э����^����^������^�ۼ�^����^�۸���Ч����^���ڱ�־^�������^����ҩ����^����ҩ���־^�й�ҩ���־^�ٴ���֤��ҩ��־
	// ^������ҩ��־^�������^��/ʡ��^��׼�ĺ�^��ֵ���־^��������id^����ۼ�^�洢����^��Ժ����Ŀ¼^�б��־^�б����^�б꼶��^�б깩Ӧ��id^����id^�б�������id^�б�����
	// ^����ɹ���־^Ч�ڳ���^����ļ���^����ļ�����ʱ��^Ƥ�Ա�־^�ʲ�����id^��ҩ˵��^����ҩ���־2
	// ^ʡ����ҩ���־1^ʡ����ҩ���־2^���ʱ�λ��^��ҩ����^���

	//�������Ϣ
	var iNCICode = Ext.getCmp("INCICode").getValue(); //������
	var iNCIDesc = Ext.getCmp("INCIDesc").getValue(); //�������
	var BillUomId = Ext.getCmp("INCICTUom").getValue(); //������λ
	var PurUomId = Ext.getCmp("PUCTUomPurch").getValue(); //��ⵥλ
	var StkCatId = Ext.getCmp("StkCat").getValue(); //������id
	var StkGrpType = Ext.getCmp("StkGrpType").getValue(); //����
	var TransFlag = Ext.getCmp("INCIIsTrfFlag").getValue(); //ת�Ʒ�ʽ
	var BatchFlag = Ext.getCmp("INCIBatchReq").getValue(); //����
	var ExpireFlag = Ext.getCmp("INCIExpReqnew").getValue(); //��Ч��
	var AliasStr = Ext.getCmp("INCAlias").getValue(); //����
	var NotUseFlag = (Ext.getCmp("INCINotUseFlag").getValue() == true ? 'Y' : 'N'); //�����ñ�־
	var XieHeCode = Ext.getCmp("INCIReportingDays").getValue(); //Э����
	var BarCode = Ext.getCmp("INCIBarCode").getValue(); //����
	var Sp = Ext.getCmp("INCIBSpPuruom").getValue(); //���ۼ�
	var SupplyLocField = Ext.getCmp("supplyLocField").getValue(); //��Ӧ�ֿ�
	var reqType = Ext.getCmp("reqType").getValue(); //������������
	var Remarks = Ext.getCmp("remark").getValue(); //��ע
	Remarks = Remarks.replace(/\r/g, '').replace(/\n/g, xMemoDelim());
	var Rp = Ext.getCmp("INCIBRpPuruom").getValue(); //����
	var PreExeDate = Ext.getCmp("PreExeDate").getValue(); //�۸���Ч����
	if ((PreExeDate != "") && (PreExeDate != null)) {
		PreExeDate = PreExeDate.format(ARG_DATEFORMAT);
	}
	var Spec = Ext.getCmp("INFOSpec").getValue(); //���
	var INFOImportFlag = Ext.getCmp("INFOImportFlag").getValue(); //���ڱ�־
	var QualityLevel = Ext.getCmp("INFOQualityLevel").getValue(); //�������
	var QualityNo = Ext.getCmp("INFOQualityNo").getValue(); //�ʱ���
	var ComFrom = Ext.getCmp("INFOComFrom").getValue(); //����/ʡ��
	var Remark = Ext.getCmp("INFORemark2").getValue(); //ע��֤��
	var HighPrice = (Ext.getCmp("INFOHighPrice").getValue() == true ? 'Y' : 'N'); //��ֵ���־
	var MtDr = Ext.getCmp("INFOMT").getValue(); //��������
	var MaxSp = Ext.getCmp("INFOMaxSp").getValue(); //����ۼ�
	var StoreConDr = storeConRowId; //�洢����
	var InHosFlag = (Ext.getCmp("INFOInHosFlag").getValue() == true ? 'Y' : 'N'); //��Ժ����Ŀ¼
	var PbFlag = (Ext.getCmp("INFOPbFlag").getValue() == true ? 'Y' : 'N'); //�б��־
	var PbRp = Ext.getCmp("INFOPbRp").getValue(); //�б����
	var PbLevel = Ext.getCmp("INFOPBLevel").getValue(); //�б꼶��
	var PbVendorId = Ext.getCmp("INFOPbVendor").getValue(); //�б깩Ӧ��
	var PbManfId = Ext.getCmp("INFOPbManf").getValue(); //��
	var PbCarrier = Ext.getCmp("INFOPbCarrier").getValue(); //�̳�
	var PbBlDr = Ext.getCmp("INFOPBLDR").getValue(); //�б�����
	var BaFlag = (Ext.getCmp("INFOBAflag").getValue() == true ? 'Y' : 'N'); //һ���Ա�־
	var ExpireLen = Ext.getCmp("INFOExpireLen").getValue(); //Ч�ڳ���
	var PrcFile = Ext.getCmp("INFOPrcFile").getValue(); //����ļ���
	var PrcFileDate = Ext.getCmp("INFOPriceBakD").getValue(); //����ļ���������
	if ((PrcFileDate != "") && (PrcFileDate != null)) {
		PrcFileDate = PrcFileDate.format(ARG_DATEFORMAT);
	}
	var IRRegCertExpDate = Ext.getCmp("IRRegCertExpDate").getValue(); //ע��֤����
	if ((IRRegCertExpDate != "") && (IRRegCertExpDate != null)) {
		IRRegCertExpDate = IRRegCertExpDate.format(ARG_DATEFORMAT);
	}
	var BookCatDr = Ext.getCmp("INFOBCDr").getValue(); //�˲�����
	var StandCode = Ext.getCmp("INFODrugBaseCode").getValue(); //���ʱ�λ��
	var PackUom = Ext.getCmp("PackUom").getValue(); //���װ��λ
	var PackUomFac = Ext.getCmp("PackUomFac").getValue(); //���װ��λϵ��
	var HighRiskFlag = (Ext.getCmp("HighRiskFlag").getValue() == true ? 'Y' : 'N'); //��Σ��־
	var NotUseReason = Ext.getCmp("ItmNotUseReason").getValue(); //������ԭ��
	var InsuType = Ext.getCmp("PHCDOfficialType").getValue(); //ҽ�����
	var Brand = Ext.getCmp("INFOBrand").getValue(); //Ʒ��
	var Model = Ext.getCmp("INFOModel").getValue(); //�ͺ�
	var chargeFlag = (Ext.getCmp("INFOChargeFlag").getValue() == true ? 'Y' : 'N'); //�շѱ�־
	var Abbrev = Ext.getCmp("INFOAbbrev").getValue(); //���
	var Supervision = Ext.getCmp("INFOSupervision").getValue(); //��ܼ���
	var ImplantationMat = (Ext.getCmp("INFOImplantationMat").getValue() == true ? 'Y' : 'N'); //ֲ���־
	var NoLocReq = (Ext.getCmp("INFONoLocReq").getValue() == true ? 'Y' : 'N'); //��ֹ�����־
	var INFOSterile = Ext.getCmp("INFOSterileDateLen").getValue(); //���ʱ��
	var INFOZeroStk = (Ext.getCmp("INFOZeroStk").getValue() == true ? 'Y' : 'N'); //�����־
	var INFOChargeType = Ext.getCmp("INFOChargeType").getValue(); //�շ�����
	var INFOMedEqptCat = Ext.getCmp("INFOMedEqptCat").getValue(); //��е����
	var INFOPackCharge = (Ext.getCmp("INFOPackCharge").getValue() == true ? 'Y' : 'N'); //�����־

	//var irRegCertNoFull=Ext.getCmp("IRRegCertNoFull").getValue()
	var irRegCertNoFull = "";
	var irRegCertDateOfIssue = Ext.getCmp("IRRegCertDateOfIssue").getValue();
	if ((irRegCertDateOfIssue != "") && (irRegCertDateOfIssue != null)) {
		irRegCertDateOfIssue = irRegCertDateOfIssue.format(ARG_DATEFORMAT);
	}

	var irRegCertItmDesc = Ext.getCmp("IRRegCertItmDesc").getValue();
	var irRegCertExpDateExtended = (Ext.getCmp("IRRegCertExpDateExtended").getValue() == true ? 'Y' : 'N');
	var bidDate = Ext.getCmp('BidDate').getValue();
	if ((bidDate != "") && (bidDate != null)) {
		bidDate = bidDate.format(ARG_DATEFORMAT);
	}
	var Origin = Ext.getCmp('Origin').getValue();
	var firstReqDept = Ext.getCmp('FirstReqDept').getValue(); //���벿��
	var SCategoryId = Ext.getCmp('SCategory').getValue();
	var MatQualitydesc = Ext.getCmp('MatQuality').getValue();
	var INFOInterMat=Ext.getCmp('INFOInterMat').getValue()?'Y':'N';		//�����־
	var INFOOrgan=Ext.getCmp('INFOOrgan').getValue()?'Y':'N';			//�˹�����
	var listInc = iNCICode + "^" + iNCIDesc + "^" + BillUomId + "^" + PurUomId + "^" + StkCatId + "^" + TransFlag + "^" + BatchFlag + "^" + ExpireFlag + "^" + AliasStr + "^" + NotUseFlag + "^"
		+XieHeCode + "^" + BarCode + "^" + userId + "^" + Sp + "^" + Rp + "^" + SupplyLocField + "^" + Remarks + "^" + PreExeDate + "^" + Spec + "^" + INFOImportFlag + "^" + QualityLevel + "^" + "" + "^"
		 + "" + "^" + "" + "^" + "" + "^" + "" + "^" + QualityNo + "^" + ComFrom + "^" + Remark + "^" + HighPrice + "^" + MtDr + "^" + MaxSp + "^"
		+StoreConDr + "^" + InHosFlag + "^" + PbFlag + "^" + PbRp + "^" + PbLevel + "^" + PbVendorId + "^" + PbManfId + "^" + PbCarrier + "^" + PbBlDr + "^" + BaFlag + "^"
		+ExpireLen + "^" + PrcFile + "^" + PrcFileDate + "^" + "" + "^" + BookCatDr + "^" + "" + "^" + "" + "^" + "" + "^" + "" + "^" + StandCode + "^"
		 + "" + "^" + PackUom + "^" + PackUomFac + "^" + HighRiskFlag + "^" + NotUseReason + "^" + InsuType + "^" + Brand + "^" + Model + "^" + chargeFlag + "^" + Abbrev + "^" + Supervision + "^" + ImplantationMat + "^" + reqType + "^" + StkGrpType + "^" + NoLocReq + "^" + INFOSterile + "^" + INFOZeroStk + "^" + INFOChargeType + "^" + INFOMedEqptCat + "^" + IRRegCertExpDate + "^" + INFOPackCharge;
	listInc = listInc + "^" + ASP_STATUS + "^" + ASP;
	listInc = listInc + "^" + irRegCertItmDesc + "^" + irRegCertDateOfIssue + "^" + irRegCertExpDateExtended + "^" + irRegCertNoFull;
	listInc = listInc + "^" + bidDate + "^" + Origin + "^" + firstReqDept + "^" + SCategoryId + "^" + MatQualitydesc;
	listInc = listInc + "^" + INFOInterMat + "^" + INFOOrgan;
	return listInc;
}

function getArcList() {
	// ҽ�������ݴ�:����^����^�Ƽ۵�λid^ҽ������id^���ô���id^��������id^����ҽ����־^Ĭ��ҽ�����ȼ�id^�޿��ҽ����־^ҽ������^����^��д^ҽ�����
	// ^�����^����ʹ������^ÿ��������^����������^������ҩ^סԺ��ҩ^������ҩ^�����ҩ^ҽ����ʾ^��ά���շ���Ŀ^�Ƿ�ά��ҽ����Ŀ
	// ^�ӷ���^סԺ�ӷ���^�����ӷ���^�����ӷ���^������ҳ�ӷ���^����ӷ���^��Ч����^��ֹ����

	//ҽ������Ϣ
	var ARCIMCode = Ext.getCmp("ARCIMCode").getValue(); //����
	var ARCIMDesc = Ext.getCmp("ARCIMDesc").getValue(); //����
	var BillUomId = Ext.getCmp("ARCIMUomDR").getValue(); //�Ƽ۵�λ
	var ItmCatId = Ext.getCmp("ARCItemCat").getValue(); //ҽ������
	//if(ItmCatId==""){Msg.info("error", "ҽ�����಻��Ϊ��!");return false;}
	var BillGrpId = Ext.getCmp("ARCBillGrp").getValue(); //���ô���
	var BillSubId = Ext.getCmp("ARCBillSub").getValue(); //��������
	var OwnFlag = (Ext.getCmp("ARCIMOrderOnItsOwn").getValue() == true ? 'Y' : 'N'); //����ҽ��
	var PriorId = Ext.getCmp("OECPriority").getValue(); //ҽ�����ȼ�
	var WoStockFlag = (Ext.getCmp("WoStockFlag").getValue() == true ? 'Y' : 'N'); //�޿��ҽ��
	var InsuDesc = Ext.getCmp("ARCIMText1").getValue(); //ҽ������
	var AliasStr = Ext.getCmp("ARCAlias").getValue(); //����
	var SX = Ext.getCmp("ARCIMAbbrev").getValue(); //��д
	var InsuType = Ext.getCmp("PHCDOfficialType").getValue(); //ҽ�����
	var NoCumOfDays = Ext.getCmp("ARCIMNoOfCumDays").getValue(); //����ʹ������
	var OeMessage = Ext.getCmp("ARCIMOEMessage").getValue(); //ҽ����ʾ
	var UpdTarFlag = (Ext.getCmp("BillNotActive").getValue() == true ? 'Y' : 'N'); //��ά���շ���
	var subTypeFee = ""; //�ӷ���
	var inSubTypeFee = ""; //סԺ�ӷ���
	var outSubTypeFee = ""; //�����ӷ���
	var accSubTypeFee = ""; //�����ӷ���
	var medSubTypeFee = ""; //������ҳ�ӷ���
	var newMedSubTypeFee = ""; //�²�����ҳ�ӷ���
	var accountSubTypeFee = ""; //����ӷ���
	var billCode = ""; //�շ������
	var billName = ""; //�շ�������
	if (UpdTarFlag == "N") {
		//ά���շ���Ŀ����
		if (PARA_ModifyBillCode) {
			billCode = Ext.getCmp("BillCode").getValue();
			if (billCode == "") {
				Msg.info("error", "�շ������Ϊ��!");
				talPanel.setActiveTab(1);
				Ext.getCmp("BillCode").focus();
				return false;
			}
			billName = Ext.getCmp("BillName").getValue();
			if (billName == "") {
				Msg.info("error", "�շ�������Ϊ��!");
				talPanel.setActiveTab(1);
				Ext.getCmp("BillName").focus();
				return false;
			}
		} else {
			billCode = ARCIMCode;
			billName = ARCIMDesc;
		}
		var subTypeFee = Ext.getCmp("SubTypeFee").getValue();
		if (subTypeFee == "") {
			Msg.info("error", "�ӷ���Ϊ��!");
			talPanel.setActiveTab(1);
			Ext.getCmp("SubTypeFee").focus();
			return false;
		}
		var inSubTypeFee = Ext.getCmp("InSubTypeFee").getValue();
		if (inSubTypeFee == "") {
			Msg.info("error", "סԺ�ӷ���Ϊ��!");
			talPanel.setActiveTab(1);
			Ext.getCmp("InSubTypeFee").focus();
			return false;
		}
		var outSubTypeFee = Ext.getCmp("OutSubTypeFee").getValue();
		if (outSubTypeFee == "") {
			Msg.info("error", "�����ӷ���Ϊ��!");
			talPanel.setActiveTab(1);
			Ext.getCmp("OutSubTypeFee").focus();
			return false;
		}
		var accSubTypeFee = Ext.getCmp("AccSubTypeFee").getValue();
		if (accSubTypeFee == "") {
			Msg.info("error", "�����ӷ���Ϊ��!");
			talPanel.setActiveTab(1);
			Ext.getCmp("AccSubTypeFee").focus();
			return false;
		}
		var medSubTypeFee = Ext.getCmp("MedSubTypeFee").getValue();
		if (medSubTypeFee == "") {
			Msg.info("error", "������ҳ�ӷ���Ϊ��!");
			talPanel.setActiveTab(1);
			Ext.getCmp("MedSubTypeFee").focus();
			return false;
		}
		var newMedSubTypeFee = Ext.getCmp("NewMedSubTypeFee").getValue();
		if (newMedSubTypeFee == "") {
			Msg.info("error", "�²�����ҳ�ӷ���Ϊ��!");
			talPanel.setActiveTab(1);
			Ext.getCmp("NewMedSubTypeFee").focus();
			return false;
		}
		var accountSubTypeFee = Ext.getCmp("AccountSubTypeFee").getValue();
		if (accountSubTypeFee == "") {
			Msg.info("error", "����ӷ���Ϊ��!");
			talPanel.setActiveTab(1);
			Ext.getCmp("AccountSubTypeFee").focus();
			return false;
		}
	}
	var medProMaintain = (Ext.getCmp("MedProMaintain").getValue() == true ? 'Y' : 'N'); //ά��ҽ����
	var ARCIMEffDate = Ext.getCmp("ARCIMEffDate").getValue(); //��Ч����
	if ((ARCIMEffDate != "") && (ARCIMEffDate != null)) {
		ARCIMEffDate = ARCIMEffDate.format(ARG_DATEFORMAT);
	}
	var ARCIMEffDateTo = Ext.getCmp("ARCIMEffDateTo").getValue(); //��ֹ����
	if ((ARCIMEffDateTo != "") && (ARCIMEffDateTo != null)) {
		ARCIMEffDateTo = ARCIMEffDateTo.format(ARG_DATEFORMAT);
	}
	var BuomId = Ext.getCmp("INCICTUom").getValue(); //����������λ,���ڴ���Ʒ���
	var LinkArcRowid = Ext.getCmp("LinkArcRowid").getValue();
	var ChargeBasis = Ext.getCmp("ChargeBasis").getValue();		//�շ�����
	var listArc = ARCIMCode + "^" + ARCIMDesc + "^" + BillUomId + "^" + ItmCatId + "^" + BillGrpId + "^" + BillSubId + "^" + OwnFlag + "^" + PriorId + "^" + WoStockFlag + "^" + InsuDesc
		 + "^" + AliasStr + "^" + SX + "^" + InsuType + "^" + "" + "^" + NoCumOfDays + "^" + "" + "^" + "" + "^" + "" + "^" + "" + "^" + ""
		 + "^" + "" + "^" + OeMessage + "^" + UpdTarFlag + "^" + medProMaintain + "^" + subTypeFee + "^" + inSubTypeFee + "^" + outSubTypeFee + "^" + accSubTypeFee + "^" + medSubTypeFee + "^" + accountSubTypeFee
		 + "^" + ARCIMEffDate + "^" + ARCIMEffDateTo + "^" + BuomId + "^" + newMedSubTypeFee + "^" + userId + "^^^^^^" + LinkArcRowid + "^" + billCode + "^" + billName + "^" + ChargeBasis;

	return listArc;
}
//��ȡ�ؼ�id20170325
///�ؼ�id�иĶ�,��Ѵ˷����е�idͬ��;ͬʱ��"�����ֵ������ά��"�˵��еĿؼ�idҲһ��ͬ��
///���治��ʾ���ֶ�,����ֵ
function getelemid() {
	/*����^����^������λid^��ⵥλid^������id^����^ת�Ʒ�ʽ^�Ƿ�Ҫ������^�Ƿ�Ҫ��Ч��^����^
	�����ñ�־^Э����^����^�ۼ�^����^��Ӧ�ֿ�^������������^��ע^�۸���Ч����^���^
	���ڱ�־^�������^�������^��/ʡ��^ע��֤��^��ֵ���־^��������id^����ۼ�^��Ժ����Ŀ¼^�б��־^
	�б����^�б꼶��^�б깩Ӧ��id^�б�������id^�б�������id^�б�����^һ���Ա�־^Ч�ڳ���^����ļ���^����ļ�����ʱ��^
	ע��֤����^�ʲ�����id^���ʱ�λ��^���װ��λ^���װ��λϵ��^��Σ��־^������ԭ��^ҽ�����^Ʒ��^�ͺ�^
	�շѱ�־^���^��ܼ���^ֲ���־^��ֹ�����־^���ʱ��^�����־^�շ�����^��е����^�����־^
	ע��֤��֤����^ע��֤����^ע��֤�ӳ�Ч��^�б�����^����^���벿��^�������^�ʵ�^Ժ������^ҽ������^
	ҽ������^�Ƽ۵�λ^ҽ������^ҽ������^���ô���^��������^����ҽ��^ҽ�����ȼ�^�޿��ҽ��^ҽ������^
	����^��д^ҽ�����^����ʹ������^ҽ����ʾ^��ά���շ���^�շ������^�շ�������^�ӷ���^סԺ�ӷ���^
	�����ӷ���^�����ӷ���^������ҳ�ӷ���^�²�����ҳ�ӷ���^����ӷ���^ά��ҽ����^��Ч����^��ֹ����
	 */
	var elemidstr = "INCICode^INCIDesc^INCICTUom^PUCTUomPurch^StkCat^StkGrpType^INCIIsTrfFlag^INCIBatchReq^INCIExpReqnew^INCAlias"
		 + "^INCINotUseFlag^INCIReportingDays^INCIBarCode^INCIBSpPuruom^INCIBRpPuruom^supplyLocField^reqType^remark^PreExeDate^INFOSpec"
		 + "^INFOImportFlag^INFOQualityLevel^INFOQualityNo^INFOComFrom^INFORemark2^INFOHighPrice^INFOMT^INFOMaxSp^INFOInHosFlag^INFOPbFlag"
		 + "^INFOPbRp^INFOPBLevel^INFOPbVendor^INFOPbManf^INFOPbCarrier^INFOPBLDR^INFOBAflag^INFOExpireLen^INFOPrcFile^INFOPriceBakD"
		 + "^IRRegCertExpDate^INFOBCDr^INFODrugBaseCode^PackUom^PackUomFac^HighRiskFlag^ItmNotUseReason^PHCDOfficialType^INFOBrand^INFOModel"
		 + "^INFOChargeFlag^INFOAbbrev^INFOSupervision^INFOImplantationMat^INFONoLocReq^INFOSterileDateLen^INFOZeroStk^INFOChargeType^^INFOPackCharge"
		 + "^IRRegCertDateOfIssue^IRRegCertItmDesc^IRRegCertExpDateExtended^BidDate^Origin^FirstReqDept^SCategory^MatQuality^HospZeroStk^ARCIMCode"
		 + "^ARCIMDesc^ARCIMUomDR^OrderCategory^ARCItemCat^ARCBillGrp^ARCBillSub^ARCIMOrderOnItsOwn^OECPriority^WoStockFlag^ARCIMText1"
		 + "^ARCAlias^ARCIMAbbrev^PHCDOfficialType^ARCIMNoOfCumDays^ARCIMOEMessage^BillNotActive^BillCode^BillName^SubTypeFee^InSubTypeFee"
		 + "^OutSubTypeFee^AccSubTypeFee^MedSubTypeFee^NewMedSubTypeFee^AccountSubTypeFee^^ARCIMEffDate^ARCIMEffDateTo"
		 + "^^^^";
	return elemidstr;
}
//���������Ƿ��Ѿ����ã��Ӷ������Ƿ������޸ļ۸�ͻ�����λ
function CheckItmUsed(rowid) {
	var url = 'dhcstm.druginfomaintainaction.csp?actiontype=CheckItmUsed&IncRowid=' + rowid;
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		waitMsg: '��ѯ��...',
		success: function (result, request) {
			var ret = result.responseText;
			var jsonData = Ext.util.JSON.decode(ret);
			if (jsonData.success == 'true') {
				var useflag = jsonData.info;
				if (useflag == 1) {
					Ext.getCmp("INCICTUom").setDisabled(true);
					Ext.getCmp("INCIBSpPuruom").setDisabled(true);
					Ext.getCmp("INCIBRpPuruom").setDisabled(true);
					Ext.getCmp("PreExeDate").setDisabled(true);
				} else {
					Ext.getCmp("INCICTUom").setDisabled(false);

					if (ASP_STATUS == 'Yes') //�Ѿ���Ч�ģ���ֹ�����κ��޸ġ��༭
					{
						Ext.getCmp("INCIBSpPuruom").setDisabled(true);
						Ext.getCmp("INCIBRpPuruom").setDisabled(true);
						Ext.getCmp("PreExeDate").setDisabled(true);
						return;
					}
					if ((ASP == null) || (ASP == '')) // �޵��ۼ�¼�ģ���ֹ�����κ��޸ġ��༭
					{
						Ext.getCmp("INCIBSpPuruom").setDisabled(true);
						Ext.getCmp("INCIBRpPuruom").setDisabled(true);
						Ext.getCmp("PreExeDate").setDisabled(true);
						return;
					}

					if (PARA_AllowInputSp == 'Y') {
						var exedate = Ext.getCmp("PreExeDate").getValue();
						if ((exedate != null) && (exedate != "")) {
							exedate = exedate.format(ARG_DATEFORMAT);
						} else {
							//û�е��ۼ�¼��
							Ext.getCmp("INCIBSpPuruom").setDisabled(true);
							Ext.getCmp("INCIBRpPuruom").setDisabled(true);
							Ext.getCmp("PreExeDate").setDisabled(true);
							return;
						}

						var today = new Date();
						today = today.format(ARG_DATEFORMAT);

						if (Date.parseDate(exedate, ARG_DATEFORMAT) > Date.parseDate(today, ARG_DATEFORMAT)) {
							Ext.getCmp("INCIBSpPuruom").setDisabled(false);
							Ext.getCmp("INCIBRpPuruom").setDisabled(false);
							Ext.getCmp("PreExeDate").setDisabled(false);
						} else {
							Ext.getCmp("INCIBSpPuruom").setDisabled(true);
							Ext.getCmp("INCIBRpPuruom").setDisabled(true);
							Ext.getCmp("PreExeDate").setDisabled(true);
						}
					} else {
						Ext.getCmp("INCIBSpPuruom").setDisabled(true);
						Ext.getCmp("INCIBRpPuruom").setDisabled(true);
						Ext.getCmp("PreExeDate").setDisabled(true);
					}

				}
			}
		},
		scope: this
	});
}

var saveButton = new Ext.Button({
		text: '����',
		tooltip: '�������',
		height: 30,
		width: 70,
		iconCls: 'page_save',
		handler: function () {
			// ����������Ϣ
			saveData();
		}
	});


// ɾ����ť
var DeleteBT = new Ext.Toolbar.Button({
		text: 'ɾ��',
		tooltip: '���ɾ��',
		width: 70,
		height: 30,
		iconCls: 'page_delete',
		handler: function () {
			deleteData();
		}
	});

function deleteData() {
	var gridSelected = Ext.getCmp("DrugInfoGrid");
	var rows = gridSelected.getSelectionModel().getSelections();
	if (rows.length == 0) {
		Ext.Msg.show({
			title: '����',
			msg: '��ѡ��Ҫɾ�������ʣ�',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
	} else if (rows.length > 1) {
		Ext.Msg.show({
			title: '����',
			msg: 'ֻ����ѡ��һ����¼��',
			buttons: Ext.Msg.OK,
			icon: Ext.MessageBox.ERROR
		});
	} else {
		// ѡ����
		var row = rows[0];
		var record = gridSelected.getStore().getById(row.id);
		var InciRowid = record.get("InciRowid");
		if (InciRowid == null || InciRowid.length <= 0) {
			gridSelected.getStore().remove(record);
		} else {
			Ext.MessageBox.show({
				title: '��ʾ',
				msg: '�Ƿ�ȷ��ɾ����������Ϣ',
				buttons: Ext.MessageBox.YESNO,
				fn: showResult,
				icon: Ext.MessageBox.QUESTION
			});
		}
	}
}

function showResult(btn) {
	if (btn == "yes") {
		var gridSelected = Ext.getCmp("DrugInfoGrid");
		var rows = gridSelected.getSelectionModel().getSelections();
		var row = rows[0];
		var record = gridSelected.getStore().getById(row.id);
		var InciRowid = record.get("InciRowid");

		// ɾ����������
		var url = DictUrl
			 + "druginfomaintainaction.csp?actiontype=DeleteData&InciRowid="
			 + InciRowid;

		Ext.Ajax.request({
			url: url,
			method: 'POST',
			waitMsg: '������...',
			success: function (result, request) {
				var jsonData = Ext.util.JSON
					.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "ɾ���ɹ�!");
					gridSelected.getStore().remove(record);
					clearData();
				} else {
					var ret = jsonData.info;
					if (ret == -11) {
						Msg.info("warning", "�����Ѿ���ʹ�ã�����ɾ����");
						return;
					} else {
						Msg.info("error", "ɾ��ʧ��:" + ret);
						return;
					}
				}
			},
			scope: this
		});
	}
}

//��ȡ����������
var GetMaxCodeBT = new Ext.Toolbar.Button({
		text: '��ȡ�����',
		tooltip: '��ȡ�����',
		width: 70,
		height: 30,
		iconCls: 'page_gear',
		handler: function () {
			GetMaxCode(SetMaxCode);
		}
	});

function SetMaxCode(newMaxCode, Cat, Scg, ScgDesc) {
	// if(confirm('�Ƿ����ý�����Ϣ?')==true){
	// clearData();
	// }

	Ext.MessageBox.confirm('��ʾ', '�Ƿ����ý�����Ϣ?', function (btn) {
		if (btn == 'yes') {
			clearData();
			setV(newMaxCode, Cat, Scg, ScgDesc);
		} else {
			
			setV(newMaxCode, Cat, Scg, ScgDesc);
		}
	})

	function setV(newMaxCode, Cat, Scg, ScgDesc) {
		Ext.getCmp("INCICode").setValue(newMaxCode);
		if ((StkCat != "") && (Scg != "")) {
			Ext.getCmp("StkGrpType").setValue(Scg, ScgDesc);
			Ext.getCmp("StkCat").setValue(Cat);
		}
		SetChargeItem();

		INCICode.fireEvent('blur');
	}

}


//���ҽ���������Ϣ
function clearArcData() {
	//ҽ����
	Ext.getCmp("LinkArcRowid").setValue("");
	ARCIMCode.setValue("");
	ARCIMDesc.setValue("");
	ARCIMEffDate.setValue("");
	ARCAlias.setValue("");
	ARCBillGrp.setValue("");
	ARCBillGrp.setRawValue("");
	ARCIMUomDR.setValue("");
	ARCIMUomDR.setRawValue("");
	ARCBillSub.setValue("");
	ARCBillSub.setRawValue("");
	OECPriority.setValue("");
	OECPriority.setRawValue("");
	ARCIMEffDateTo.setValue("");
	ARCIMOEMessage.setValue("");
	OrderCategory.setValue("");
	OrderCategory.setRawValue("");
	ARCItemCat.setValue("");
	ARCItemCat.setRawValue("");
	ARCIMAbbrev.setValue("");
	ARCIMText1.setValue("");
	ARCIMNoOfCumDays.setValue("");
	BillNotActive.setValue(false);
	BillCode.setValue("");
	BillName.setValue("");
	INFOSterileDateLen.setValue("");
	ARCIMOrderOnItsOwn.setValue(false);
	PHCDOfficialType.setValue("");
	MedProMaintain.setValue(false);
	//�շѷ���
	SubTypeFee.setValue("");
	OutSubTypeFee.setValue("");
	InSubTypeFee.setValue("");
	AccSubTypeFee.setValue("");
	MedSubTypeFee.setValue("");
	NewMedSubTypeFee.setValue("");
	AccountSubTypeFee.setValue("");
	ArcRowid = "";
}

function getArcinfolist(record) {
	if (record == "" || record == null) {
		return;
	}
	var arcimid = record.get("ArcitmId"); //ҽ��id
	var arcCode = record.get("ArcCode"); //ҽ������
	var arcDesc = record.get("ArcDesc"); //ҽ������
	var arcordcid = record.get("OrdCatId"); //ҽ������
	var arcordc = record.get("OrdCat");
	var arccatid = record.get("ArcSubCatId"); //ҽ������
	var arccat = record.get("ArcSubCat");
	var billsubcatid = record.get("BillSubCatId"); //��������
	var billsubcat = record.get("BillSubCat");
	var billcatId = billsubcatid.split("||")[0]; //���ô���
	var billcat = record.get("BillCat");
	var billuomid = record.get("BillUomId"); //�Ƽ۵�λ
	var billuomdesc = record.get("BillUomDesc");
	var priorid = record.get("PriorId"); //ҽ�����ȼ�
	var priority = record.get("Priority");
	var effdate = record.get("EffDate"); //��Ч����
	var effdateto = record.get("EffDateTo"); //��ֹ����
	var insudesc = record.get("InsuDesc"); //ҽ������
	var oemessage = record.get("OeMessage"); //ҽ����ʾ
	var abbrev = record.get("SX"); //��д
	//var phcdofficialtype=record.get("PHCDOfficialType");  //ҽ�����
	var ownflag = record.get("OwnFlag"); //����ҽ��
	var wostock = record.get("WoStock"); //�޿��ҽ��
	var taricode = record.get("tariCode"); //�շѴ���
	var taridesc = record.get("tariDesc"); //�շ�����
	var scdr = record.get("scDr"); //�շ��ӷ���
	var scdesc = record.get("scDesc");
	var icdr = record.get("icDr"); //סԺ�ӷ���
	var icdesc = record.get("icDesc");
	var ocdr = record.get("ocDr"); //�����ӷ���
	var ocdesc = record.get("ocDesc");
	var ecdr = record.get("ecDr"); //�����ӷ���
	var ecdesc = record.get("ecDesc");
	var acdr = record.get("acDr"); //����ӷ���
	var acdesc = record.get("acDesc");
	var mcdr = record.get("mcDr"); //������ҳ����
	var mcdesc = record.get("mcDesc");
	var newmcdr = record.get("newmcDr"); //�²�����ҳ����
	var newmcdesc = record.get("newmcDesc");

	talPanel.activate(ItmMastPanel); //�Զ���ת��ҽ�������
	Ext.MessageBox.confirm('��ʾ', '�Ƿ�����ҽ���������Ϣ?', function (btn) {
		if (btn == 'yes') {
			clearArcData();
			Ext.getCmp("INFOChargeFlag").setValue(true); //�����շѱ�־
			enableArcItm(Ext.getCmp("INFOChargeFlag").getValue()); //����ҽ�������
			Ext.getCmp("LinkArcRowid").setValue(arcimid);
			Ext.getCmp("ARCIMCode").setValue(arcCode); //ҽ������
			Ext.getCmp("ARCIMDesc").setValue(arcDesc); //ҽ������
			addComboData(OrderCategoryStore, arcordcid, arcordc); //ҽ������
			Ext.getCmp("OrderCategory").setValue(arcordcid);
			addComboData(CTUomStore, billuomid, billuomdesc); //�Ƽ۵�λ
			Ext.getCmp("ARCIMUomDR").setValue(billuomid);
			addComboData(ArcItemCatStore, arccatid, arccat); //ҽ������
			Ext.getCmp("ARCItemCat").setValue(arccatid);
			addComboData(ArcBillGrpStore, billcatId, billcat); //���ô���
			Ext.getCmp("ARCBillGrp").setValue(billcatId);
			addComboData(ArcBillSubStore, billsubcatid, billsubcat); //��������
			Ext.getCmp("ARCBillSub").setValue(billsubcatid);
			addComboData(OECPriorityStore, priorid, priority); //ҽ�����ȼ�
			Ext.getCmp("OECPriority").setValue(priorid);
			Ext.getCmp("ARCIMEffDate").setValue(effdate); //��Ч����
			Ext.getCmp("ARCIMEffDateTo").setValue(effdateto); //��ֹ����
			Ext.getCmp("ARCIMText1").setValue(insudesc); //ҽ������
			Ext.getCmp("ARCIMOEMessage").setValue(oemessage); //ҽ����ʾ
			Ext.getCmp("ARCIMAbbrev").setValue(abbrev); //��д
			Ext.getCmp("ARCIMOrderOnItsOwn").setValue(ownflag); //����ҽ��
			Ext.getCmp("WoStockFlag").setValue(wostock); //�޿��ҽ��
			Ext.getCmp("BillCode").setValue(taricode); //�շѴ���
			Ext.getCmp("BillName").setValue(taridesc); //�շ�����

			addComboData(TarSubCateStore, scdr, scdesc); //�շ��ӷ���
			Ext.getCmp("SubTypeFee").setValue(scdr);
			addComboData(TarAcctCateStore, acdr, acdesc); //����ӷ���
			Ext.getCmp("AccountSubTypeFee").setValue(acdr);
			addComboData(TarMRCateStore, mcdr, mcdesc); //������ҳ����
			Ext.getCmp("MedSubTypeFee").setValue(mcdr);
			addComboData(TarNewMRCateStore, newmcdr, newmcdesc); //�²�����ҳ����
			Ext.getCmp("NewMedSubTypeFee").setValue(newmcdr);
			addComboData(TarInpatCateStore, icdr, icdesc); //סԺ�ӷ���
			Ext.getCmp("InSubTypeFee").setValue(icdr);
			addComboData(TarOutpatCateStore, ocdr, ocdesc); //�����ӷ���
			Ext.getCmp("OutSubTypeFee").setValue(ocdr);
			addComboData(TarEMCCateStore, ecdr, ecdesc); //�����ӷ���
			Ext.getCmp("AccSubTypeFee").setValue(ecdr);
		} else {
			Ext.getCmp("INFOChargeFlag").setValue(true); //�����շѱ�־
			enableArcItm(Ext.getCmp("INFOChargeFlag").getValue()); //����ҽ�������
			Ext.getCmp("LinkArcRowid").setValue(arcimid);
			Ext.getCmp("ARCIMCode").setValue(arcCode); //ҽ������
			Ext.getCmp("ARCIMDesc").setValue(arcDesc); //ҽ������
			addComboData(OrderCategoryStore, arcordcid, arcordc); //ҽ������
			Ext.getCmp("OrderCategory").setValue(arcordcid);
			addComboData(CTUomStore, billuomid, billuomdesc); //�Ƽ۵�λ
			Ext.getCmp("ARCIMUomDR").setValue(billuomid);
			addComboData(ArcItemCatStore, arccatid, arccat); //ҽ������
			Ext.getCmp("ARCItemCat").setValue(arccatid);
			addComboData(ArcBillGrpStore, billcatId, billcat); //���ô���
			Ext.getCmp("ARCBillGrp").setValue(billcatId);
			addComboData(ArcBillSubStore, billsubcatid, billsubcat); //��������
			Ext.getCmp("ARCBillSub").setValue(billsubcatid);
			addComboData(OECPriorityStore, priorid, priority); //ҽ�����ȼ�
			Ext.getCmp("OECPriority").setValue(priorid);
			Ext.getCmp("ARCIMEffDate").setValue(effdate); //��Ч����
			Ext.getCmp("ARCIMEffDateTo").setValue(effdateto); //��ֹ����
			Ext.getCmp("ARCIMText1").setValue(insudesc); //ҽ������
			Ext.getCmp("ARCIMOEMessage").setValue(oemessage); //ҽ����ʾ
			Ext.getCmp("ARCIMAbbrev").setValue(abbrev); //��д
			Ext.getCmp("ARCIMOrderOnItsOwn").setValue(ownflag); //����ҽ��
			Ext.getCmp("WoStockFlag").setValue(wostock); //�޿��ҽ��
			Ext.getCmp("BillCode").setValue(taricode); //�շѴ���
			Ext.getCmp("BillName").setValue(taridesc); //�շ�����

			addComboData(TarSubCateStore, scdr, scdesc); //�շ��ӷ���
			Ext.getCmp("SubTypeFee").setValue(scdr);
			addComboData(TarAcctCateStore, acdr, acdesc); //����ӷ���
			Ext.getCmp("AccountSubTypeFee").setValue(acdr);
			addComboData(TarMRCateStore, mcdr, mcdesc); //������ҳ����
			Ext.getCmp("MedSubTypeFee").setValue(mcdr);
			addComboData(TarNewMRCateStore, newmcdr, newmcdesc); //�²�����ҳ����
			Ext.getCmp("NewMedSubTypeFee").setValue(newmcdr);
			addComboData(TarInpatCateStore, icdr, icdesc); //סԺ�ӷ���
			Ext.getCmp("InSubTypeFee").setValue(icdr);
			addComboData(TarOutpatCateStore, ocdr, ocdesc); //�����ӷ���
			Ext.getCmp("OutSubTypeFee").setValue(ocdr);
			addComboData(TarEMCCateStore, ecdr, ecdesc); //�����ӷ���
			Ext.getCmp("AccSubTypeFee").setValue(ecdr);
		}

	})

}



//==============================================ҽ����====================================================
var LinkArcRowid = new Ext.form.TextField({
		id: 'LinkArcRowid',
		name: 'LinkArcRowid'
	});

var ARCIMCode = new Ext.form.TextField({
		fieldLabel: '����', //'<font color=red>*����</font>',
		id: 'ARCIMCode',
		name: 'ARCIMCode',
		anchor: '90%',
		valueNotFoundText: '',
		listeners: {
			'blur': function (e) {
				CopyCode(Ext.getCmp('ARCIMCode').getRawValue());
			}
		}
	});

function CopyCode(code) {
	if (code != null || code != "") {
		if (PARA_SameCode == 'Y') {
			Ext.getCmp("ARCIMCode").setValue(code);
		}
	}
}

var ARCIMDesc = new Ext.form.TextField({
		fieldLabel: '����', //'<font color=red>*����</font>',
		id: 'ARCIMDesc',
		name: 'ARCIMDesc',
		anchor: '90%',
		valueNotFoundText: ''
	});

function CopyDesc() {
	var desc = Ext.getCmp("INCIDesc").getValue();
	if ((desc != null) && (desc != "")) {
		if (PARA_SameDesc == 'Y') {
			var arcimDesc = desc;
			if (PARA_ArcimDescAutoMode == "1") {
				var spec = Ext.getCmp("INFOSpec").getValue();
				if (spec != "") {
					spec = "(" + spec + ")";
				}
				// var manf=Ext.getCmp("INFOPbManf").getValue();
				// if (manf!=""){manf="("+subStr(manf,1,4)+")";}
				arcimDesc = arcimDesc + spec;
				//
			}
			Ext.getCmp("ARCIMDesc").setValue(arcimDesc);
		}
	}
}
var ARCAlias = new Ext.form.TextField({
		fieldLabel: '����',
		id: 'ARCAlias',
		name: 'ARCAlias',
		anchor: '90%',
		width: 370,
		emptyText: '�������֮����/�ָ�',
		valueNotFoundText: '',
		disabled: true
	});

var arcAliasButton = new Ext.Button({
		id: 'ArcAliasButton',
		text: '����',
		width: 15,
		handler: function () {
			if (ArcRowid != "") {
				OrdAliasEdit("", ArcRowid, ARCAlias);
			} else {
				Msg.info("warning", "��ѡ��Ҫά��������ҽ����!");
				return;
			}
		}
	});

var ARCIMEffDate = new Ext.ux.DateField({
		fieldLabel: '��Ч����',
		id: 'ARCIMEffDate',
		name: 'ARCIMEffDate',
		anchor: '90%',
		value: new Date()
	});

var ARCIMEffDateTo = new Ext.ux.DateField({
		fieldLabel: '��ֹ����',
		id: 'ARCIMEffDateTo',
		name: 'ARCIMEffDateTo',
		anchor: '90%',
		value: ''
	});

var ARCBillGrp = new Ext.ux.ComboBox({
		fieldLabel: '���ô���', //'<font color=red>*���ô���</font>',
		id: 'ARCBillGrp',
		name: 'ARCBillGrp',
		store: ArcBillGrpStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'Desc',
		childCombo: ['ARCBillSub']
	});

var ARCBillSub = new Ext.ux.ComboBox({
		fieldLabel: '��������', //'<font color=red>*��������</font>',
		id: 'ARCBillSub',
		name: 'ARCBillSub',
		store: ArcBillSubStore,
		valueField: 'RowId',
		displayField: 'Description',
		params: {
			ARCBGRowId: 'ARCBillGrp'
		}
	});

var ARCIMUomDR = new Ext.ux.ComboBox({
		fieldLabel: '�Ƽ۵�λ', //'<font color=red>*�Ƽ۵�λ</font>',
		id: 'ARCIMUomDR',
		name: 'ARCIMUomDR',
		store: CTUomStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'CTUomDesc',
		listeners: {}
	});
var OrderCategory = new Ext.ux.ComboBox({
		fieldLabel: 'ҽ������', //'<font color=red>*ҽ������</font>',
		id: 'OrderCategory',
		name: 'OrderCategory',
		store: OrderCategoryStore,
		valueField: 'RowId',
		displayField: 'Description',
		childCombo: ['ARCItemCat']
	});

var ARCItemCat = new Ext.ux.ComboBox({
		fieldLabel: 'ҽ������', //'<font color=red>*ҽ������</font>',
		id: 'ARCItemCat',
		name: 'ARCItemCat',
		store: ArcItemCatStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'Desc',
		params: {
			OrderCat: 'OrderCategory'
		} //OrderCategoryΪҽ�������id
	});

var OECPriority = new Ext.ux.ComboBox({
		fieldLabel: '���ȼ�',
		id: 'OECPriority',
		name: 'OECPriority',
		store: OECPriorityStore,
		valueField: 'RowId',
		displayField: 'Description'
	});

var ARCIMOEMessage = new Ext.form.TextField({
		fieldLabel: 'ҽ����ʾ',
		id: 'ARCIMOEMessage',
		name: 'ARCIMOEMessage',
		anchor: '90%',
		valueNotFoundText: ''
	});

var ARCIMNoOfCumDays = new Ext.form.NumberField({
		fieldLabel: '����ʹ������',
		id: 'ARCIMNoOfCumDays',
		name: 'ARCIMNoOfCumDays',
		anchor: '90%',
		allowNegative: false,
		selectOnFocus: true
	});

var BillNotActive = new Ext.form.Checkbox({
		fieldLabel: '��ά���շ���',
		id: 'BillNotActive',
		name: 'BillNotActive',
		anchor: '90%',
		checked: false,
		listeners: {
			'check': function (checked) {
				if (document.getElementById('SubTypeFee') == null) {
					return;
				}
				if (checked.checked) {
					document.getElementById('BillCode').parentNode.previousSibling.innerHTML = "�շ������";
					BillCode.setValue("");
					BillCode.setRawValue("");
					BillCode.disable();

					document.getElementById('BillName').parentNode.previousSibling.innerHTML = "�շ�������";
					BillName.setValue("");
					BillName.setRawValue("");
					BillName.disable();

					document.getElementById('SubTypeFee').parentNode.parentNode.previousSibling.innerHTML = "�շ���Ŀ����";
					SubTypeFee.setValue("");
					SubTypeFee.setRawValue("");
					SubTypeFee.disable();

					document.getElementById('InSubTypeFee').parentNode.parentNode.previousSibling.innerHTML = "סԺ��������";
					InSubTypeFee.setValue("");
					InSubTypeFee.setRawValue("");
					InSubTypeFee.disable();

					document.getElementById('OutSubTypeFee').parentNode.parentNode.previousSibling.innerHTML = "�����������";
					OutSubTypeFee.setValue("");
					OutSubTypeFee.setRawValue("");
					OutSubTypeFee.disable();

					document.getElementById('AccSubTypeFee').parentNode.parentNode.previousSibling.innerHTML = "���ú�������";
					AccSubTypeFee.setValue("");
					AccSubTypeFee.setRawValue("");
					AccSubTypeFee.disable();

					document.getElementById('MedSubTypeFee').parentNode.parentNode.previousSibling.innerHTML = "������ҳ����";
					MedSubTypeFee.setValue("");
					MedSubTypeFee.setRawValue("");
					MedSubTypeFee.disable();

					document.getElementById('NewMedSubTypeFee').parentNode.parentNode.previousSibling.innerHTML = "�²�����ҳ����";
					NewMedSubTypeFee.setValue("");
					NewMedSubTypeFee.setRawValue("");
					NewMedSubTypeFee.disable();

					document.getElementById('AccountSubTypeFee').parentNode.parentNode.previousSibling.innerHTML = "�շѻ������";
					AccountSubTypeFee.setValue("");
					AccountSubTypeFee.setRawValue("");
					AccountSubTypeFee.disable();

					ARCIMText1.setValue("");
					ARCIMText1.disable();
					ChargeBasis.disable();
				} else {
					var elemidstr = getelemid();
					changeElementInfo(elemidstr, cspname);
					SubTypeFee.enable();
					InSubTypeFee.enable();
					OutSubTypeFee.enable();
					AccSubTypeFee.enable();
					MedSubTypeFee.enable();
					NewMedSubTypeFee.enable();
					AccountSubTypeFee.enable();
					ARCIMText1.enable();
					ChargeBasis.enable();
					if (PARA_ModifyBillCode) {
						BillCode.enable();
						BillName.enable();
					}
				}
			}
		}
	});

var BillCode = new Ext.form.TextField({
		fieldLabel: '�շ������',
		id: 'BillCode',
		name: 'BillCode',
		anchor: '90%',
		disabled: !PARA_ModifyBillCode,
		valueNotFoundText: ''
	});

var BillName = new Ext.form.TextField({
		fieldLabel: '�շ�������',
		id: 'BillName',
		name: 'BillName',
		anchor: '90%',
		disabled: !PARA_ModifyBillCode,
		valueNotFoundText: ''
	});

var ChargeBasis = new Ext.form.TextField({
	fieldLabel : '�շ�����',
	id : 'ChargeBasis',
	anchor : '90%'
});

var ARCIMAbbrev = new Ext.form.TextField({
		fieldLabel: '��д',
		id: 'ARCIMAbbrev',
		name: 'ARCIMAbbrev',
		anchor: '90%',
		valueNotFoundText: '',
		disabled: true
	});

var PHCDOfficialType = new Ext.ux.ComboBox({
		fieldLabel: 'ҽ�����',
		id: 'PHCDOfficialType',
		name: 'PHCDOfficialType',
		mode: 'local',
		store: OfficeCodeStore,
		valueField: 'RowId',
		displayField: 'Description'
	});
var remark = new Ext.form.TextArea({
		id: 'remark',
		fieldLabel: '��ע',
		anchor: '90%',
		width: 330,
		selectOnFocus: true
	});
var supplyLocField = new Ext.ux.LocComboBox({
		id: 'supplyLocField',
		fieldLabel: '��Ӧ�ֿ�',
		anchor: '90%',
		listWidth: 230,
		emptyText: '��Ӧ�ֿ�...',
		defaultLoc: {}
	});

var ARCIMText1 = new Ext.form.TextField({
		fieldLabel: 'ҽ������',
		id: 'ARCIMText1',
		name: 'ARCIMText1',
		anchor: '90%',
		valueNotFoundText: '',
		value: ''
	});

var DHCArcItemAut = new Ext.Button({
		text: '���ƿ�������',
		handler: function () {}
	});

var ARCIMOrderOnItsOwn = new Ext.form.Checkbox({
		fieldLabel: '����ҽ��',
		id: 'ARCIMOrderOnItsOwn',
		name: 'ARCIMOrderOnItsOwn',
		anchor: '90%',
		checked: false
	});
var ARCIMRowid = new Ext.form.TextField({
		fieldLabel: 'ARCIMRowid',
		id: 'ARCIMRowid',
		name: 'ARCIMRowid',
		anchor: '90%',
		hidden: true,
		valueNotFoundText: ''
	});
var WoStockFlag = new Ext.form.Checkbox({
		fieldLabel: '�޿��ҽ��',
		id: 'WoStockFlag',
		name: 'WoStockFlag',
		anchor: '90%',
		checked: false
	});
//�շ���Ŀ����
var SubTypeFee = new Ext.ux.ComboBox({
		fieldLabel: '�շ���Ŀ����'	,	//(Ext.getCmp('BillNotActive').getValue() == true ? '�շ���Ŀ����' : '<font color=red>�շ���Ŀ����</font>'),
		id: 'SubTypeFee',
		name: 'SubTypeFee',
		store: TarSubCateStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'Desc'
	});
//סԺ��������
var InSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel: 'סԺ��������', //(Ext.getCmp('BillNotActive').getValue()==true?'סԺ��������':'<font color=red>סԺ��������</font>'),
		id: 'InSubTypeFee',
		name: 'InSubTypeFee',
		store: TarInpatCateStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'Desc'
	});
//�����������
var OutSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel: '�����������', //(Ext.getCmp('BillNotActive').getValue()==true?'�����������':'<font color=red>�����������</font>') ,
		id: 'OutSubTypeFee',
		name: 'OutSubTypeFee',
		store: TarOutpatCateStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'Desc'
	});
//���ú�������
var AccSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel: '���ú�������', //(Ext.getCmp('BillNotActive').getValue()==true?'���ú�������':'<font color=red>���ú�������</font>'),
		id: 'AccSubTypeFee',
		name: 'AccSubTypeFee',
		store: TarEMCCateStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'Desc'
	});
//������ҳ����
var MedSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel: '������ҳ����', //(Ext.getCmp('BillNotActive').getValue()==true?'������ҳ����':'<font color=red>������ҳ����</font>'),
		id: 'MedSubTypeFee',
		name: 'MedSubTypeFee',
		store: TarMRCateStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'Desc'
	});
//�²�����ҳ����
var NewMedSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel: '�²�����ҳ����', //(Ext.getCmp('BillNotActive').getValue()==true?'�²�����ҳ����':'<font color=red>�²�����ҳ����</font>'),
		id: 'NewMedSubTypeFee',
		name: 'NewMedSubTypeFee',
		store: TarNewMRCateStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'Desc'
	});

//�շѻ������
var AccountSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel: '�շѻ������', //(Ext.getCmp('BillNotActive').getValue()==true?'�շѻ������':'<font color=red>�շѻ������</font>'),
		id: 'AccountSubTypeFee',
		name: 'AccountSubTypeFee',
		store: TarAcctCateStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'Desc'
	});
var MedProMaintain = new Ext.form.Checkbox({
		fieldLabel: 'ά��ҽ����',
		id: 'MedProMaintain',
		name: 'MedProMaintain',
		anchor: '90%',
		checked: false,
		hidden: true
	});

// ҽ����Panel
var ItmMastPanel = new Ext.form.FormPanel({
		title: 'ҽ����',
		disabled: true,
		labelWidth: 90,
		labelAlign: 'right',
		autoScroll: true,
		frame: true,
		items: [{
				layout: 'column',
				xtype: 'fieldset',
				style: 'padding:5px 0px 0px 0px',
				defaults: {
					border: false
				},
				items: [{
						columnWidth: 0.5,
						xtype: 'fieldset',
						items: [ARCIMCode, OrderCategory, ARCItemCat, ARCIMUomDR, ARCIMEffDate, ARCIMText1,
							ARCIMAbbrev, ARCIMNoOfCumDays]
					}, {
						columnWidth: 0.5,
						xtype: 'fieldset',
						items: [ARCIMDesc, ARCBillGrp, ARCBillSub, OECPriority, ARCIMEffDateTo,
							ARCIMOEMessage, PHCDOfficialType]
					}
				]
			}, {
				xtype: 'fieldset',
				style: 'padding:5px 0px 0px 0px',
				items: [{
						xtype: 'compositefield',
						items: [ARCAlias, arcAliasButton]

					}
				]
			}, {
				layout: 'column',
				xtype: 'fieldset',
				style: 'padding:5px 0px 0px 0px',
				defaults: {
					border: false
				},
				items: [{
						columnWidth: .33,
						xtype: 'fieldset',
						items: [ARCIMOrderOnItsOwn]
					}, {
						columnWidth: .33,
						xtype: 'fieldset',
						items: [WoStockFlag]
					}, {
						columnWidth: .33,
						xtype: 'fieldset',
						items: [BillNotActive]
						//items : [MedProMaintain]
					}
				]
			}, {
				xtype: 'fieldset',
				title: '�շ���Ŀ����',
				layout: 'column',
				style: 'padding:5px 0px 0px 0px',
				defaults: {
					border: false
				},
				labelWidth: 100,
				items: [{
						columnWidth: .5,
						xtype: 'fieldset',
						items: [BillCode, ChargeBasis, OutSubTypeFee, InSubTypeFee, MedSubTypeFee]
					}, {
						columnWidth: .5,
						xtype: 'fieldset',
						items: [BillName, SubTypeFee, AccSubTypeFee, AccountSubTypeFee, NewMedSubTypeFee]
					}
				]
			}
		],
		listeners: {
			activate: function () {
				Ext.getCmp('BillNotActive').fireEvent('check', Ext.getCmp('BillNotActive'), Ext.getCmp('BillNotActive').getValue());
			}
		}
	});
//============================ҽ����=========================================================================

//============================�����=========================================================================
var INCICode = new Ext.form.TextField({
		fieldLabel: '����', //'<font color=red>*����</font>',
		id: 'INCICode',
		name: 'INCICode',
		anchor: '90%',
		//disabled:true,
		valueNotFoundText: '',
		listeners: {
			'blur': function (f) {
				CopyCode(Ext.getCmp("INCICode").getValue());
			}
		}
	});

var INCIDesc = new Ext.form.TextField({
		fieldLabel: '����', //'<font color=red>*����</font>',
		id: 'INCIDesc',
		name: 'INCIDesc',
		anchor: '90%',
		//disabled:true,
		valueNotFoundText: '',
		listeners: {
			'blur': function (f) {
				CopyDesc();
			}
		}
	});

var INFOSpec = new Ext.form.TextField({
		fieldLabel: '���',
		id: 'INFOSpec',
		name: 'INFOSpec',
		anchor: '90%',
		valueNotFoundText: '',
		listeners: {
			'blur': function (f) {
				CopyDesc();
			}
		}
	});
var infoSpecButton = new Ext.Button({
		id: 'InfoSpecButton',
		text: '�б�',
		width: 10,
		handler: function () {
			if (drugRowid != "") {
				IncSpecEdit("", drugRowid);
			} else {
				Msg.info("warning", "��ѡ����Ҫά�����Ŀ���");
				return;
			}
		}
	});

var INFOBrand = new Ext.form.TextField({
		fieldLabel: 'Ʒ��',
		id: 'INFOBrand',
		name: 'INFOBrand',
		anchor: '90%'
	});

var INFOModel = new Ext.form.TextField({
		fieldLabel: '�ͺ�',
		id: 'INFOModel',
		name: 'INFOModel',
		anchor: '90%'
	});

var INFOAbbrev = new Ext.form.TextField({
		fieldLabel: '���',
		id: 'INFOAbbrev',
		name: 'INFOAbbrev',
		anchor: '90%'
	});

var INFOSupervision = new Ext.form.ComboBox({
		fieldLabel: '��ܼ���',
		id: 'INFOSupervision',
		name: 'INFOSupervision',
		store: SupervisionStore,
		valueField: 'RowId',
		displayField: 'Description',
		anchor: '90%',
		mode: 'local',
		triggerAction: 'all'
	});

var INCICTUom = new Ext.ux.ComboBox({
		fieldLabel: '������λ', //'<font color=red>*������λ</font>',
		id: 'INCICTUom',
		name: 'INCICTUom',
		store: CTUomStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'CTUomDesc',
		listeners: {
			'select': function (combo, record, index) {
				var id = record.get("RowId");
				var desc = record.get("Description");
				addComboData(CONUomStore, id, desc);
				PUCTUomPurch.setValue(id);
				ARCIMUomDR.setValue(id);
			}
		}
	});

var PUCTUomPurch = new Ext.ux.ComboBox({
		fieldLabel: '��ⵥλ', //'<font color=red>*��ⵥλ</font>',
		id: 'PUCTUomPurch',
		name: 'PUCTUomPurch',
		store: CONUomStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'PUCTUomDesc',
		params: {
			UomId: 'INCICTUom'
		},
		listeners: {
			'focus': function (e) {
				var buom = Ext.getCmp('INCICTUom').getRawValue();
				if (buom == "") {
					Msg.info("warning", "����¼�����������λ!");
					return;
				}
			}
		}
	});

var PackUom = new Ext.ux.ComboBox({
		fieldLabel: '���װ��λ',
		id: 'PackUom',
		name: 'PackUom',
		store: CTUomStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'CTUomDesc'
	});

var PackUomFac = new Ext.form.NumberField({
		id: 'PackUomFac',
		name: 'PackUomFac',
		anchor: '25%',
		valueNotFoundText: ''
	});

var localstore = new Ext.data.SimpleStore({
		fields: ['RowId', 'Description'],
		data: [['REQUIRED', 'Ҫ��'], ['NONREQUIRED', '��Ҫ��'], ['OPTIONAL', '����']]
	});

var INCIBatchReq = new Ext.form.ComboBox({
		fieldLabel: '����Ҫ��',
		id: 'INCIBatchReq',
		name: 'INCIBatchReq',
		store: localstore,
		valueField: 'RowId',
		displayField: 'Description',
		anchor: '90%',
		mode: 'local',
		triggerAction: 'all'
	});
Ext.getCmp("INCIBatchReq").setValue('REQUIRED');

var ExpReqStore = new Ext.data.SimpleStore({
		fields: ['RowId', 'Description'],
		data: [['REQUIRED', 'Ҫ��'], ['NONREQUIRED', '��Ҫ��'], ['OPTIONAL', '����']]
	});
var INCIExpReqnew = new Ext.form.ComboBox({
		fieldLabel: 'Ч��Ҫ��',
		id: 'INCIExpReqnew',
		name: 'INCIExpReqnew',
		store: ExpReqStore,
		valueField: 'RowId',
		displayField: 'Description',
		anchor: '90%',
		mode: 'local',
		triggerAction: 'all'
	});
Ext.getCmp("INCIExpReqnew").setValue('REQUIRED');

var INFOExpireLen = new Ext.form.NumberField({
		fieldLabel: 'Ч�ڳ���(��)',
		id: 'INFOExpireLen',
		name: 'INFOExpireLen',
		anchor: '90%',
		allowNegative: false,
		selectOnFocus: true
	});
var StkGrpType = new Ext.ux.StkGrpComboBox({
		fieldLabel: '����', //'<font color=red>*����</font>',
		id: 'StkGrpType',
		selectMode: 'leaf',
		isDefaultValue: false,
		StkType: App_StkTypeCode,
		UserId: userId,
		LocId: gLocId,
		//scgset:"'MM'",
		anchor: '90%',
		childCombo: ['StkCat']
	});

// ������
var StkCat = new Ext.ux.ComboBox({
		fieldLabel: '������', //'<font color=red>*������</font>',
		id: 'StkCat',
		name: 'StkCat',
		store: StkCatStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'StkCatName',
		params: {
			StkGrpId: 'StkGrpType'
		},

		listeners: {
			'select': function () {
				SetChargeItem();
			}
		}
	});
var TransferStore = new Ext.data.SimpleStore({
		fields: ['RowId', 'Description'],
		data: [['TRANS', 'Transfer Only'],
			['ISSUE', 'Issue Only'],
			['BOTH', 'Both Issue & Transfer']]
	});
var INCIIsTrfFlag = new Ext.form.ComboBox({
		fieldLabel: 'ת�Ʒ�ʽ', //'<font color=red>*ת�Ʒ�ʽ</font>',
		id: 'INCIIsTrfFlag',
		name: 'INCIIsTrfFlag',
		store: TransferStore,
		valueField: 'RowId',
		displayField: 'Description',
		anchor: '90%',
		mode: 'local',
		hidden: true
	});
Ext.getCmp('INCIIsTrfFlag').setValue('TRANS');

var INCIBarCode = new Ext.form.TextField({
		fieldLabel: '����',
		id: 'INCIBarCode',
		name: 'INCIBarCode',
		anchor: '90%',
		valueNotFoundText: ''
	});

var INCAlias = new Ext.form.TextField({
		fieldLabel: '����',
		id: 'INCAlias',
		name: 'INCAlias',
		width: 380,
		anchor: '90%',
		emptyText: '�������֮����/�ָ�',
		disabled: true,
		valueNotFoundText: ''
	});

var incAliasButton = new Ext.Button({
		id: 'IncAliasButton',
		text: '����',
		width: 15,
		handler: function () {
			if (drugRowid != "") {
				IncAliasEdit("", drugRowid, INCAlias);
			} else {
				Msg.info("warning", "��ѡ����Ҫά�������Ŀ���");
				return;
			}
		}
	});

var INFOPBLevel = new Ext.ux.ComboBox({
		fieldLabel: '�б꼶��',
		id: 'INFOPBLevel',
		name: 'INFOPBLevel',
		store: INFOPBLevelStore,
		valueField: 'RowId',
		displayField: 'Description',
		childCombo: 'INFOPBLDR'
	});

var INFOBCDr = new Ext.ux.ComboBox({
		fieldLabel: '�˲�����',
		id: 'INFOBCDr',
		name: 'INFOBCDr',
		store: BookCatStore,
		valueField: 'RowId',
		displayField: 'Description'
	});

var INCIBRpPuruom = new Ext.ux.NumberField({
		formatType: 'FmtRP',
		fieldLabel: '������',
		id: 'INCIBRpPuruom',
		name: 'INCIBRpPuruom',
		anchor: '90%',
		allowNegative: false,
		selectOnFocus: true,
		enableKeyEvents: true,
		listeners: {
			keyup: function (field, e) {
				var Rp = field.getValue();
				var MarkType = Ext.getCmp("INFOMT").getValue();
				if (MarkType == "" || drugRowid != "") {
					return false;
				}
				var MtSp = tkMakeServerCall("web.DHCSTM.Common.PriceCommon", "GetMarkTypeSp", MarkType, Rp);
				Ext.getCmp("INCIBSpPuruom").setValue(MtSp);
			}
		}
	});

var INCIBSpPuruom = new Ext.ux.NumberField({
		formatType: 'FmtSP',
		//fieldLabel : '<font color=red>*���ۼ�</font>',
		fieldLabel: '���ۼ�',
		id: 'INCIBSpPuruom',
		name: 'INCIBSpPuruom',
		anchor: '90%',
		allowNegative: false,
		selectOnFocus: true
	});

var PreExeDate = new Ext.ux.DateField({
		fieldLabel: '�۸���Ч����',
		id: 'PreExeDate',
		name: 'PreExeDate',
		anchor: '90%',
		value: new Date(),
		listeners: {
			'change': function (d, n, o) {
				if (n == "")
					return;
				var x = n.format(ARG_DATEFORMAT);
				var today = new Date().format(ARG_DATEFORMAT);
				if ((Date.parseDate(x, ARG_DATEFORMAT)) < Date.parseDate(today, ARG_DATEFORMAT)) {
					Msg.info("error", "�۸���Ч���ڲ������ڽ���!");
					d.setValue(o);
				}
			}
		}
	});

var INFOPrcFile = new Ext.form.TextField({
		fieldLabel: '����ļ���',
		id: 'INFOPrcFile',
		name: 'INFOPrcFile',
		anchor: '90%',
		valueNotFoundText: ''
	});

var INCINotUseFlag = new Ext.form.Checkbox({
		fieldLabel: '������',
		id: 'INCINotUseFlag',
		name: 'INCINotUseFlag',
		anchor: '90%',
		checked: false,
		listeners: {
			'check': function (c) {
				if (c.getValue() == true) {
					Ext.getCmp('ItmNotUseReason').setDisabled(false);
				} else {
					Ext.getCmp('ItmNotUseReason').setDisabled(true);
					Ext.getCmp('ItmNotUseReason').setValue("");
				}
			}
		}
	});

var ItmNotUseReason = new Ext.ux.ComboBox({
		id: 'ItmNotUseReason',
		name: 'ItmNotUseReason',
		store: ItmNotUseReasonStore,
		valueField: 'RowId',
		displayField: 'Description'
	});

var packButton = new Ext.Button({
		text: '���װά��',
		height: 30,
		handler: function () {}
	});

var ImportStore = new Ext.data.SimpleStore({
		fields: ['RowId', 'Description'],
		data: [['����', '����'], ['����', '����'], ['����', '����']]
	});
var INFOImportFlag = new Ext.form.ComboBox({
		fieldLabel: '���ڱ�־',
		id: 'INFOImportFlag',
		name: 'INFOImportFlag',
		store: ImportStore,
		valueField: 'RowId',
		displayField: 'Description',
		anchor: '90%',
		mode: 'local'
	});
var INFOQualityNo = new Ext.form.TextField({
		fieldLabel: '�ʱ���',
		id: 'INFOQualityNo',
		name: 'INFOQualityNo',
		anchor: '90%',
		width: 180,
		valueNotFoundText: ''
	});

var INFOMT = new Ext.ux.ComboBox({
		fieldLabel: '��������',
		id: 'INFOMT',
		name: 'INFOMT',
		store: MarkTypeStore,
		valueField: 'RowId',
		displayField: 'Description',
		listeners: {
			'blur': function (cb) {
				chkInputOfCombo(cb);
			},
			'select': function (index) {
				var Rp = Ext.getCmp("INCIBRpPuruom").getValue();
				if (Rp === "" || drugRowid != "") {
					return false;
				}
				var MarkType = this.getValue();
				var MtSp = tkMakeServerCall("web.DHCSTM.Common.PriceCommon", "GetMarkTypeSp", MarkType, Rp);
				Ext.getCmp("INCIBSpPuruom").setValue(MtSp);
			}
		}
	});
var INFOMaxSp = new Ext.ux.NumberField({
		formatType: 'FmtSP',
		fieldLabel: '����ۼ�',
		id: 'INFOMaxSp',
		name: 'INFOMaxSp',
		anchor: '90%',
		width: 180,
		allowNegative: false,
		selectOnFocus: true
	});

var INFORemark1 = new Ext.ux.ComboBox({
		fieldLabel: '��׼�ĺ�',
		id: 'INFORemark1',
		name: 'INFORemark1',
		anchor: '90%',
		store: INFORemarkStore,
		valueField: 'RowId',
		displayField: 'Description'
	});
var INFORemark2 = new Ext.form.TextField({
		fieldLabel: 'ע��֤��',
		id: 'INFORemark2',
		name: 'INFORemark2',
		anchor: '90%',
		valueNotFoundText: ''
	});
var certNoButton = new Ext.Button({
		id: 'certNoButton',
		text: '...',
		tooltip: 'ע��֤�б�',
		width: 20,
		handler: function () {
			var manf = Ext.getCmp('INFOPbManf').getValue();
			var manfName = Ext.getCmp('INFOPbManf').getRawValue();
			if (manf != '') {
				certEdit(drugRowid, manf, setManfCert, manfName);
			} else {
				Msg.info("warning", "���̲���Ϊ�գ�");
				return;
			}
		}
	});

//���õ�ǰ��ע��֤�š�ע��֤Ч��
function setManfCert(certNo, certExpDate,ItmCertDesc, RegCertDateOfIssue, ImportFlag, OriginId, Origin) {
	Ext.getCmp('INFORemark2').setValue(certNo);
	Ext.getCmp('IRRegCertExpDate').setValue(certExpDate);
	if(!Ext.isEmpty(ItmCertDesc)){
		Ext.getCmp('IRRegCertItmDesc').setValue(ItmCertDesc);
		Ext.getCmp('IRRegCertDateOfIssue').setValue(RegCertDateOfIssue);
		Ext.getCmp('INFOImportFlag').setValue(ImportFlag);
		addComboData(null,OriginId,Origin,Ext.getCmp('Origin'));
		Ext.getCmp('Origin').setValue(OriginId);
	}
}

var INFOComFrom = new Ext.form.TextField({
		fieldLabel: '��(ʡ)��',
		id: 'INFOComFrom',
		name: 'INFOComFrom',
		anchor: '90%',
		width: 180,
		valueNotFoundText: ''
	});

var INFOQualityLevel = new Ext.ux.ComboBox({
		fieldLabel: '�������',
		id: 'INFOQualityLevel',
		name: 'INFOQualityLevel',
		anchor: '90%',
		store: INFOQualityLevelStore,
		valueField: 'RowId',
		displayField: 'Description'
	});
var INCIReportingDays = new Ext.form.TextField({
		fieldLabel: 'Э����',
		id: 'INCIReportingDays',
		name: 'INCIReportingDays',
		anchor: '90%',
		width: 180,
		valueNotFoundText: ''
	});

var INFOPBLDR = new Ext.ux.ComboBox({
		fieldLabel: '�б�����',
		id: 'INFOPBLDR',
		name: 'INFOPBLDR',
		anchor: '90%',
		store: PublicBiddingListStore,
		params: {PBLevel: 'INFOPBLevel'},
		filterName: 'Desc',
		valueField: 'RowId',
		displayField: 'Description'
	});
var INFOPbVendor = new Ext.ux.VendorComboBox({
		fieldLabel: '�б깩Ӧ��',
		id: 'INFOPbVendor',
		anchor: '90%',
		width: 150,
		name: 'INFOPbVendor',
		params: {
			ScgId: 'StkGrpType'
		}
	});
//��Ӧ�̸�����Ϣ
var VendorinfoBt = new Ext.Button({
		id: 'VendorinfoBt',
		text: '...',
		tooltip: '��Ӧ����ϸ��Ϣ',
		anchor: '90%',
		width: 20,
		handler: function () {
			var PbVendor = Ext.getCmp("INFOPbVendor").getValue();
			if (PbVendor != "") {
				CreateEditWin(PbVendor);
			} else {
				Msg.info("warning", "����ѡ��Ӧ�̣�");
			}
		}
	});

var INFOPbManf = new Ext.ux.ComboBox({
		fieldLabel: '����',
		id: 'INFOPbManf',
		name: 'INFOPbManf',
		store: PhManufacturerStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'PHMNFName',
		params: {
			ScgId: 'StkGrpType'
		},
		listeners: {
			'change': function (c, n, o) {
				if (o != "") {
					if (Ext.getCmp('INFORemark2').getValue() != "") {
						Msg.info('warning', '������ά��ע��֤�š�ע��֤Ч��!');
					}
				}
			}
		}
	});
var INFOPbCarrier = new Ext.ux.ComboBox({
		fieldLabel: '�б�������',
		id: 'INFOPbCarrier',
		name: 'INFOPbCarrier',
		store: CarrierStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'CADesc'
	});
var INFOPbRp = new Ext.ux.NumberField({
		formatType: 'FmtRP',
		fieldLabel: '�б����',
		id: 'INFOPbRp',
		name: 'INFOPbRp',
		anchor: '90%',
		allowNegative: false,
		selectOnFocus: true
	});
var INFOPbFlag = new Ext.form.Checkbox({
		fieldLabel: '�Ƿ��б�',
		id: 'INFOPbFlag',
		name: 'INFOPbFlag',
		anchor: '90%',
		checked: false,
		disabled: true
	});
var INFOBAflag = new Ext.form.Checkbox({
		fieldLabel: 'һ���Ա�־',
		id: 'INFOBAflag',
		name: 'INFOBAflag',
		anchor: '90%',
		checked: false
	});
var INFOInHosFlag = new Ext.form.Checkbox({
		fieldLabel: '��Ժ����Ŀ¼',
		id: 'INFOInHosFlag',
		name: 'INFOInHosFlag',
		anchor: '90%',
		checked: false
	});
var INFOHighPrice = new Ext.form.Checkbox({
		fieldLabel: '��ֵ���־',
		id: 'INFOHighPrice',
		name: 'INFOHighPrice',
		anchor: '90%',
		checked: false,
		listeners: {
			'check': function(checkBox, checked) {
				if(drugRowid != '' && checked == false){
					var Ret = tkMakeServerCall('web.DHCSTM.INCITM', 'CheckItmTrack', drugRowid);
					if(Ret == 'Y'){
						Msg.info('warning', '�����ʴ���δʹ����ɵĸ�ֵ����, ���ɱ����ֵ���!');
						checkBox.setValue(!checked);
						return;
					}
				}
				
				SetChargeItem();
				/*
				var TableFlag = Ext.getCmp('HighRiskFlag').getValue();
				if(!checked && TableFlag){
					Msg.info('warning', '��̨�����ȥ��,������!');
					Ext.getCmp('HighRiskFlag').setValue(false);
				}
				*/
			}
		}
	});
var INFOChargeFlag = new Ext.form.Checkbox({
		fieldLabel: '�շѱ�־',
		id: 'INFOChargeFlag',
		name: 'INFOChargeFlag',
		anchor: '90%',
		checked: false,
		listeners: {
			'check': function (c, v) {
				enableArcItm(v);
				SetChargeItem();
			}
		}

	});
var INFOImplantationMat = new Ext.form.Checkbox({
		fieldLabel: 'ֲ���־',
		id: 'INFOImplantationMat',
		name: 'INFOImplantationMat',
		anchor: '90%',
		checked: false
	});

var INFOInterMat = new Ext.form.Checkbox({
	fieldLabel : '�����־',
	id : 'INFOInterMat',
	anchor : '90%',
	checked : false
});

var INFOOrgan = new Ext.form.Checkbox({
	fieldLabel : '�˹�����',
	id : 'INFOOrgan',
	anchor : '90%',
	checked : false
});

var TypeStore = new Ext.data.SimpleStore({
		fields: ['RowId', 'Description'],
		data: [['O', '��ʱ����'], ['C', '����ƻ�']]
	});

var reqType = new Ext.form.ComboBox({
		id: 'reqType',
		fieldLabel: '������������',
		store: TypeStore,
		valueField: 'RowId',
		displayField: 'Description',
		emptyText: '������������...',
		triggerAction: 'all',
		anchor: '90%',
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true,
		editable: true,
		mode: 'local'
	});

var INFOPriceBakD = new Ext.ux.DateField({
		fieldLabel: '��۱�������',
		id: 'INFOPriceBakD',
		name: 'INFOPriceBakD',
		anchor: '90%',
		width: 180,
		value: ''
	});

var INFODrugBaseCode = new Ext.form.TextField({
		fieldLabel: '���ʱ�λ��',
		id: 'INFODrugBaseCode',
		name: 'INFODrugBaseCode',
		anchor: '90%',
		width: 180,
		valueNotFoundText: ''
	});

var HighRiskFlag = new Ext.form.Checkbox({
		//fieldLabel : '��Σ���ʱ�־',
		//2016-11-16 ���ֶμ�¼'��̨��־'
		fieldLabel: '��̨��־',
		id: 'HighRiskFlag',
		name: 'HighRiskFlag',
		anchor: '90%',
		checked: false,
		listeners: {
			check:function(checkBox, checked){
				if(checked){
					var HVFlag = Ext.getCmp('INFOHighPrice').getValue();
					if(!HVFlag){
						Msg.info('warning', '����ֵ�ĲĿ�ά����̨��־!');
						checkBox.setValue(false);
						return false;
					}
				}
			}
		}
	});
var INFONoLocReq = new Ext.form.Checkbox({
		fieldLabel: '��ֹ�����־',
		id: 'INFONoLocReq',
		name: 'INFONoLocReq',
		anchor: '90%',
		checked: false
	});

var INFOSterileDateLen = new Ext.form.NumberField({
		fieldLabel: '���ʱ�䳤��',
		id: 'INFOSterileDateLen',
		name: 'INFOSterileDateLen',
		anchor: '90%',
		width: 180
	});
var INFOZeroStk = new Ext.form.Checkbox({
		fieldLabel: '�����־',
		id: 'INFOZeroStk',
		name: 'INFOZeroStk',
		anchor: '90%',
		checked: false
	});
var HospZeroStk = new Ext.form.TextField({
		fieldLabel: 'Ժ������',
		id: 'HospZeroStk',
		name: 'HospZeroStk',
		width: 150,
		anchor: '90%',
		emptyText: 'Ժ�������־��/����',
		disabled: true,
		valueNotFoundText: ''
	});
var HospZeroStkButton = new Ext.Button({
		id: 'HospZeroStkButton',
		text: 'ά��',
		width: 15,
		handler: function () {

			if (drugRowid != "") {
				HospZeroStkEdit("", drugRowid, HospZeroStk);
			} else {
				Msg.info("warning", "��ѡ����Ҫά�������־�Ŀ���");
				return;
			}
		}

	});

var INFOPackCharge = new Ext.form.Checkbox({
		fieldLabel: '����շѱ�־',
		id: 'INFOPackCharge',
		name: 'INFOPackCharge',
		anchor: '90%',
		checked: false
	});

var INFOChargeType = new Ext.ux.ComboBox({
		fieldLabel: '�շ�����',
		id: 'INFOChargeType',
		name: 'INFOChargeType',
		anchor: '90%',
		store: INFOChargeTypeFlagStore,
		valueField: 'RowId',
		displayField: 'Description',
		listeners: {
			'select': function (combo, record, index) {
				var desc = record.get("Description")
					if (desc == "�ӳ��շ�") {
						INFOChargeFlag.setValue(true)
					} else {
						INFOChargeFlag.setValue(false)
					}
			}
		}
	});
var INFOMedEqptCat = new Ext.ux.ComboBox({
		fieldLabel: '��е����',
		id: 'INFOMedEqptCat',
		name: 'INFOMedEqptCat',
		store: MedEqptCatStore,
		filterName: 'Desc',
		anchor: '90%'
	});
var IRRegCertExpDate = new Ext.ux.DateField({
		fieldLabel: 'ע��֤Ч��',
		id: 'IRRegCertExpDate',
		name: 'IRRegCertExpDate',
		anchor: '90%',
		width: 180,
		value: ''
	});

var IRRegCertItmDesc = new Ext.form.TextField({
		fieldLabel: 'ע��֤����',
		id: 'IRRegCertItmDesc',
		name: 'IRRegCertItmDesc',
		anchor: '90%'
	});

var IRRegCertExpDateExtended = new Ext.form.Checkbox({
		fieldLabel: 'ע��֤�ӳ�Ч��',
		id: 'IRRegCertExpDateExtended',
		name: 'IRRegCertExpDateExtended',
		anchor: '90%',
		checked: false
	});

var IRRegCertDateOfIssue = new Ext.ux.DateField({
		fieldLabel: 'ע��֤��֤����',
		id: 'IRRegCertDateOfIssue',
		name: 'IRRegCertDateOfIssue',
		anchor: '90%',
		value: ''
	});

//�б�����
var BidDate = new Ext.ux.DateField({
		fieldLabel: '�б�����',
		id: 'BidDate',
		name: 'BidDate',
		anchor: '90%',
		width: 180,
		value: ''
	});

//  ���벿��
var FirstReqDept = new Ext.ux.LocComboBox({
		id: 'FirstReqDept',
		fieldLabel: '���벿��',
		anchor: '90%',
		listWidth: 210,
		emptyText: '���벿��...',
		defaultLoc: {}
	});

var Origin = new Ext.ux.ComboBox({
		fieldLabel: '����',
		id: 'Origin',
		name: 'Origin',
		store: StoriginStore,
		valueField: 'RowId',
		displayField: 'Description',
		anchor: '90%',
		triggerAction: 'all'

	});

StoriginStore.on('beforeload', function (ds) {
	var alias = Ext.getCmp('Origin').getRawValue();
	ds.setBaseParam("Alias", alias);
});

var ItemPackUom = {
	xtype: 'compositefield',
	items: [
		PackUom, {
			xtype: 'displayfield',
			value: '-ϵ��'
		},
		PackUomFac
	]
};
var SCategory = new Ext.ux.ComboBox({
		fieldLabel: '�������',
		id: 'SCategory',
		name: 'SCategory',
		store: SCategoryStore,
		valueField: 'RowId',
		displayField: 'Desc'
	});
var MatQuality = new Ext.form.TextField({
		fieldLabel: '�ʵ�',
		id: 'MatQuality',
		name: 'MatQuality',
		anchor: '90%',
		width: 180,
		valueNotFoundText: ''
	});
// �����Panel
var ItmPanel = new Ext.form.FormPanel({
		title: '�����',
		labelWidth: 90,
		labelAlign: 'right',
		autoScroll: true,
		frame: true,
		defaults: {
			style: 'padding:0px,0px,0px,0px',
			border: true
		},
		items: [{ // ����
				layout: 'column',
				xtype: 'fieldset',
				style: 'padding:5px,0px,0px,0px',
				defaults: {
					border: false
				},
				items: [{
						columnWidth: 0.5,
						xtype: 'fieldset',
						items: [INCICode, {
								xtype: 'compositefield',
								items: [INFOSpec, infoSpecButton]
							}, INFOBrand, INCICTUom, PUCTUomPurch, INCIBatchReq, INFODrugBaseCode, INCIReportingDays, INFOSupervision, INFOAbbrev]
					}, {
						columnWidth: 0.5,
						xtype: 'fieldset',
						items: [INCIDesc, INFOModel, INFOChargeFlag, StkGrpType, StkCat, INCIExpReqnew, INCIIsTrfFlag, INFOBCDr, remark]
					}
				]
			}, { // �۸�
				layout: 'column',
				xtype: 'fieldset',
				style: 'padding:5px,0px,0px,0px',
				defaults: {
					border: false
				},
				items: [{
						columnWidth: 0.5,
						xtype: 'fieldset',
						items: [INCIBRpPuruom, PreExeDate, INFOMT, INFOChargeType]
					}, {
						columnWidth: 0.5,
						xtype: 'fieldset',
						items: [INCIBSpPuruom, INFOPrcFile, INFOPriceBakD
						]
					}
				]
			}, { //
				layout: 'column',
				xtype: 'fieldset',
				labelWidth: 100,
				style: 'padding:5px,0px,0px,0px',
				defaults: {
					border: false
				},
				items: [{
						columnWidth: 0.5,
						xtype: 'fieldset',
						items: [INFOPbManf, INCIBarCode, {
								xtype: 'compositefield',
								items: [INFORemark2, certNoButton]
							}, IRRegCertExpDate, IRRegCertItmDesc, IRRegCertDateOfIssue, IRRegCertExpDateExtended, Origin, INFOImportFlag,
							INFOQualityNo, SCategory]
					}, {
						columnWidth: 0.5,
						xtype: 'fieldset',
						items: [INFOPBLevel, INFOPBLDR, INFOPbRp, {
								xtype: 'compositefield',
								items: [INFOPbVendor, VendorinfoBt]
							}, INFOPbCarrier, BidDate, INFOComFrom, INFOExpireLen, INFOSterileDateLen, INFOMaxSp, INFOQualityLevel, MatQuality]
					}
				]
			}, {
				layout: 'column',
				labelWidth: 90,
				xtype: 'fieldset',
				style: 'padding:5px,0px,0px,0px',
				defaults: {
					border: false
				},
				items: [{
						columnWidth: .2,
						xtype: 'fieldset',
						items: [INFOBAflag, INFOPackCharge]
					}, {
						columnWidth: .2,
						xtype: 'fieldset',
						items: [INFOHighPrice, INFOInHosFlag]
					}, {
						columnWidth: .2,
						xtype: 'fieldset',
						items: [HighRiskFlag, INFOPbFlag]
					}, {
						columnWidth: .2,
						xtype: 'fieldset',
						items: [INFOImplantationMat, INFONoLocReq]
					}, {
						columnWidth: .2,
						xtype: 'fieldset',
						items: [INFOInterMat, INFOOrgan]
					}
				]
			}, {
				xtype: 'fieldset',
				style: 'padding:5px,0px,0px,0px',
				items: [{
						xtype: 'compositefield',
						items: [INCAlias, incAliasButton]

					}, {
						xtype: 'compositefield',
						items: [
							PackUom, {
								xtype: 'displayfield',
								value: '-ϵ��'
							},
							PackUomFac
						]
					}, {
						xtype: 'compositefield',
						items: [INFOISCDR, iscButton]
					}
				]
			}, {
				layout: 'column',
				xtype: 'fieldset',
				style: 'padding:5px,0px,0px,0px',
				defaults: {
					border: false
				},
				items: [{
						columnWidth: 0.5,
						xtype: 'fieldset',
						items: [{
								xtype: 'compositefield',
								items: [INCINotUseFlag, ItmNotUseReason]
							},
							reqType,
							supplyLocField
							// ,{
							// xtype : 'compositefield',
							// items : [INFOMedEqptCat]
							// }  	 //��ʱ���ε�����Ϣ�ֶ� zhwh 20160323
						]
					}, {
						columnWidth: 0.5,
						xtype: 'fieldset',
						items: [{
								xtype: 'compositefield',
								items: [INFOZeroStk]
							}, {
								xtype: 'compositefield',
								items: [HospZeroStk, HospZeroStkButton]
							}, {
								xtype: 'compositefield',
								items: [FirstReqDept]
							}

						]
					}
				]
			}
		]
	});

//���ݿ��������������ҽ����ҳ��ȱʡֵ
function SetChargeItem() {
	var chargeFlag = (Ext.getCmp("INFOChargeFlag").getValue() == true ? 'Y' : 'N');
	var StkCat = Ext.getCmp("StkCat").getValue();
	if (ArcRowid != '' || chargeFlag != 'Y') {
		return;
	}
	if (PARA_ScMap == "G") {
		var HvFlag = Ext.getCmp("INFOHighPrice").getValue() == true ? 'Y' : 'N';
		setChargeItemDefault('dhcstm.hvmaparcaction.csp?actiontype=GetItem&HvFlag=' + HvFlag);
	} else if (PARA_ScMap == "Y" && StkCat != '') {
		setChargeItemDefault('dhcstm.druginfomaintainaction.csp?actiontype=GetChargeItem&StkCat=' + StkCat);
	}
}
//Ϊҽ����ҳ����ำĬ��ֵ
function setChargeItemDefault(url) {
	//�շѱ�־�Ĳ�ִ��Ĭ��ֵ����
	if (INFOChargeFlag.getValue() == false) {
		return;
	}
	//
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		waitMsg: '��ѯ��...',
		success: function (result, request) {
			var s = result.responseText;
			s = s.replace(/\r/g, "")
				s = s.replace(/\n/g, "")
				var jsonData = Ext.util.JSON.decode(s);
			if (jsonData.success == 'true' && jsonData.info != "") {
				var ListData = jsonData.info
					var list = ListData.split("^");
				if (list.length > 0) {

					SubTypeFee.setValue("");
					OutSubTypeFee.setValue("");
					InSubTypeFee.setValue("");
					AccSubTypeFee.setValue("");
					MedSubTypeFee.setValue("");
					NewMedSubTypeFee.setValue("");
					AccountSubTypeFee.setValue("");
					ARCBillGrp.setValue("");
					ARCBillSub.setValue("");
					OrderCategory.setValue("");
					ARCItemCat.setValue("");

					Msg.info('warning', '������ҽ����ȱʡֵ,���ʵ!');
					addComboData(OrderCategoryStore, list[0], list[1]);
					Ext.getCmp("OrderCategory").setValue(list[0]);
					addComboData(ArcItemCatStore, list[2], list[3]);
					Ext.getCmp("ARCItemCat").setValue(list[2]);
					var BillGrpId = list[5].split("||")[0];
					addComboData(ArcBillGrpStore, BillGrpId, list[4]);
					Ext.getCmp("ARCBillGrp").setValue(BillGrpId);
					addComboData(ArcBillSubStore, list[5], list[6]);
					Ext.getCmp("ARCBillSub").setValue(list[5]);
					addComboData(TarSubCateStore, list[7], list[8]);
					Ext.getCmp("SubTypeFee").setValue(list[7]);
					addComboData(TarAcctCateStore, list[11], list[12]);
					Ext.getCmp("AccountSubTypeFee").setValue(list[11]);
					addComboData(TarMRCateStore, list[13], list[14]);
					Ext.getCmp("MedSubTypeFee").setValue(list[13]);
					addComboData(TarNewMRCateStore, list[19], list[20]);
					Ext.getCmp("NewMedSubTypeFee").setValue(list[19]); //�²�����ҳ����
					addComboData(TarInpatCateStore, list[9], list[10]);
					Ext.getCmp("InSubTypeFee").setValue(list[9]);
					addComboData(TarOutpatCateStore, list[17], list[18]);
					Ext.getCmp("OutSubTypeFee").setValue(list[17]);
					addComboData(TarEMCCateStore, list[15], list[16]);
					Ext.getCmp("AccSubTypeFee").setValue(list[15]);
				}
			} else if (jsonData.success == 'false') {
				Msg.info("error", "��ѯ����:" + jsonData.info);
			}
		},
		scope: this
	});
}

function enableArcItm(b) {
	ItmMastPanel.setDisabled(!b);
	Ext.getCmp('ARCIMAbbrev').setDisabled(true);
	Ext.getCmp('ARCAlias').setDisabled(true);
	Ext.getCmp('BillCode').setDisabled(!PARA_ModifyBillCode);
	Ext.getCmp('BillName').setDisabled(!PARA_ModifyBillCode);
}

//============================�����=========================================================================
// ҳǩ
var talPanel = new Ext.TabPanel({
		activeTab: 0,
		deferredRender: false,
		split: true,
		region: 'east',
		width: 660,
		tbar: [saveButton, '-', GetMaxCodeBT], //'-',DeleteBT,
		items: [ItmPanel, ItmMastPanel]
	});
GetCodeMainPara(); // ȡ������ά���Ĳ���
setEnterTab(ItmPanel);
setEnterTab(ItmMastPanel);
