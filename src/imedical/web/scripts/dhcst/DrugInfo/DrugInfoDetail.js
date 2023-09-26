//===========================================================================================================
var RowDelim=xRowDelim();
var PHCDFRowid="";
var ArcRowid="";
var storeConRowId="";
var gNewCatId="";
var NeedAudit=""
var rpdecimal=2;
var spdecimal=2;
//����rowid��ѯ
function GetDetail(rowid){
	var url = 'dhcst.druginfomaintainaction.csp?actiontype=GetDetail&InciRowid=' + rowid;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var s = result.responseText;
			s=s.replace(/\r/g,"");
			s=s.replace(/\n/g,"");
			var jsonData = Ext.util.JSON.decode(s);
			if (jsonData.success == 'true') {	
				var ListData = jsonData.info.split(RowDelim);
				SetIncDetail(ListData[0]);
				SetArcDetail(ListData[1]);
				SetPhcDetail(ListData[2]);
				CheckItmUsed(rowid);
				SetFormOriginal(ItmPanel);
				SetFormOriginal(ItmMastPanel);
				SetFormOriginal(PHCDrgFormPanel);
			} else {
				Ext.MessageBox.alert("��ѯ����",jsonData.info);
			}
		},
		scope : this
	});
}
//��ѯ�������Ϣ,zdm,2011-12-23
function SetIncDetail(listData) {	
	if(listData==null || listData=="")
	{
		return;
	}
	var list=listData.split("^");
	if (list.length > 0) {
		ArcRowid=list[0];
		Ext.getCmp("INCICode").setValue(list[1]); //����
		Ext.getCmp("INCIDesc").setValue(list[2]); //����
		addComboData(CTUomStore,list[3],list[4]);
		Ext.getCmp("INCICTUom").setValue(list[3]);  //������λ
		addComboData(CONUomStore,list[5],list[6]);
		Ext.getCmp("PUCTUomPurch").setValue(list[5]);  //��ⵥλ
		addComboData(IncScStkGrpStore,list[7],list[8]);
		Ext.getCmp("DHCStkCatGroup").setValue(list[7]);  //������
		Ext.getCmp("INCIIsTrfFlag").setValue(list[9]); //ת�Ʒ�ʽ
		Ext.getCmp("INCIBatchReq").setValue(list[10]); //����
		Ext.getCmp("INCIExpReqnew").setValue(list[11]); //��Ч�� 
		Ext.getCmp("INCAlias").setValue(list[12]); //����
		Ext.getCmp("INCINotUseFlag").setValue(list[13]=='Y'?true:false); //�����ñ�־
		Ext.getCmp("INCIReportingDays").setValue(list[14]); //Э����
		Ext.getCmp("INCIBarCode").setValue(list[15]); //����
		Ext.getCmp("INCIBSpPuruom").setValue(list[18]); //�ۼ�
		Ext.getCmp("INCIBRpPuruom").setValue(list[19]); //����
		Ext.getCmp("PreExeDate").setValue(list[73]);	//�۸���Ч����
		Ext.getCmp("INFOImportFlag").setValue(list[20]); //���ڱ�־ 
		addComboData(INFOQualityLevelStore,list[71],list[21]);
		Ext.getCmp("INFOQualityLevel").setValue(list[71]);
		
		addComboData(INFOOTCStore,list[22],list[22]);
		Ext.getCmp("INFOOTC").setValue(list[22]);
		Ext.getCmp("INFOBasicDrug").setValue(list[23]=='Y'?true:false); //����ҩ���־
		Ext.getCmp("INFOCodex").setValue(list[24]=='Y'?true:false); //�й�ҩ���־
		Ext.getCmp("INFOTest").setValue(list[25]=='Y'?true:false); //�ٴ���֤��ҩ��־
		Ext.getCmp("INFOREC").setValue(list[26]=='Y'?true:false); //������ҩ��־
		Ext.getCmp("INFOQualityNo").setValue(list[27]);
		Ext.getCmp("INFOComFrom").setValue(list[28]);
		var InfoRemark=list[29].split("-")[0];
		addComboData(INFORemarkStore,InfoRemark,InfoRemark)
		Ext.getCmp("INFORemark1").setValue(InfoRemark); //��׼�ĺ�ǰ��
		Ext.getCmp("INFORemark2").setValue(list[29].split("-")[1]); //��׼�ĺź��
		Ext.getCmp("INFOHighPrice").setValue(list[30]=='Y'?true:false); //��ֵ���־
		Ext.getCmp("INFOMT").setValue(list[32]); //��������id
		Ext.getCmp("INFOMT").setRawValue(list[33]); //��������
		Ext.getCmp("INFOMaxSp").setValue(list[34]); //����ۼ�
		storeConRowId=list[35];//�洢����id
		Ext.getCmp("INFOISCDR").setValue(getStoreConStr(drugRowid));//�洢����
		Ext.getCmp("INFOInHosFlag").setValue(list[36]=='Y'?true:false); //��ԺҩƷĿ¼
		Ext.getCmp("INFOPbFlag").setValue(list[37]=='Y'?true:false); //�б��־
		Ext.getCmp("INFOPbRp").setValue(list[38]); //�б����		
		addComboData(INFOPBLevelStore,list[70],list[39]);
		Ext.getCmp("INFOPBLevel").setValue(list[70]); //�б꼶��
		addComboData(INFOPbVendor.getStore(),list[40],list[41]);
		Ext.getCmp("INFOPbVendor").setValue(list[40]);
		addComboData(PhManufacturerStore,list[42],list[43]);
		Ext.getCmp("INFOPbManf").setValue(list[42]);
		addComboData(CarrierStore,list[44],list[45]);
		Ext.getCmp("INFOPbCarrier").setValue(list[44]);							
		Ext.getCmp("INFOPBLDR").setValue(list[46]);
		Ext.getCmp("INFOBAflag").setValue(list[48]=='Y'?true:false); //����ɹ���־
		Ext.getCmp("INFOExpireLen").setValue(list[49]);
		Ext.getCmp("INFOPrcFile").setValue(list[50]);
		Ext.getCmp("INFOPriceBakD").setValue(list[51]);    //����ļ�����
		Ext.getCmp("INFOSkinTest").setValue(list[52]=='Y'?true:false); //Ƥ�Ա�־
		Ext.getCmp("INFOBCDr").setValue(list[53]); //�ʲ�����id
		Ext.getCmp("INFOBCDr").setRawValue(list[54]); //�ʲ����� 
		Ext.getCmp("UserOrderInfo").setValue(list[55]); //��ҩ˵��
		Ext.getCmp("INFOBasicDrug2").setValue(list[56]=='1'?true:false); //ʡ������ҩ��
		Ext.getCmp("INFOProvince1").setValue(list[57]=='1'?true:false); //�м�����ҩ��
		Ext.getCmp("INFOProvince2").setValue(list[58]=='1'?true:false); //��(��)����ҩ��
		Ext.getCmp("INFODrugBaseCode").setValue(list[59]); //ҩƷ��λ��
		Ext.getCmp("InDrugInfo").setValue(list[60]); //��ҩ����
		Ext.getCmp("INFOSpec").setValue(list[61]); //���
		addComboData(ItmNotUseReasonStore,list[62],list[63]);
		Ext.getCmp("ItmNotUseReason").setValue(list[62]); //������ԭ��
		//Ext.getCmp("HighRiskFlag").setValue(list[66]=='Y'?true:false); //��Σ��־
		addComboData(CTUomStore,list[67],list[68]);
		Ext.getCmp("PackUom").setValue(list[67]); //���װ��λ
		Ext.getCmp("PackUomFac").setValue(list[69]); //���װ��λϵ��
		Ext.getCmp("refRetTF").setValue(list[72]);
	}
}

//��ѯҩѧ����Ϣ,zdm,2011-12-23
function SetPhcDetail(listData) {			
	if(listData==null || listData==""){
		return;
	}
	var list=listData.split("^");
	if (list.length > 0) {			
		Ext.getCmp("PHCCCode").setValue(list[0]);
		Ext.getCmp("PHCCDesc").setValue(list[1]);
		addComboData(PhcFormStore,list[2],list[3]);
		Ext.getCmp("PHCForm").setValue(list[2]);
		addComboData(CTUomStore,list[4],list[5]);
		Ext.getCmp("PHCDFCTUom").setValue(list[4]);
		addComboData(PhcInStore,list[6],list[7]);
		Ext.getCmp("PHCDFPhCin").setValue(list[6]);
		addComboData(PhcDurationStore,list[8],list[9]);
		Ext.getCmp("PHCDuration").setValue(list[8]);
		Ext.getCmp("PHCDFBaseQty").setValue(list[10]);
		addComboData(PhManufacturerStore,list[11],list[12]);
		Ext.getCmp("PhManufacturer").setValue(list[11]);
		addComboData(PhcPoisonStore,list[13],list[14]);
		Ext.getCmp("PHCDFPhcDoDR").setValue(list[13]);
		//Ext.getCmp("").setValue(list[12]);  �޿��ҽ��
		addComboData(PhcFreqStore,list[15],list[16]);
		Ext.getCmp("PHCFreq").setValue(list[15]);
		//Ext.getCmp("PHCDOfficialType").setValue(list[17]);
		addComboData(PhcGenericStore,list[18],list[19]);
		Ext.getCmp("PHCGeneric").setValue(list[18]);
		addComboData(PhcCatStore,list[20],list[21]);
		Ext.getCmp("PHCCat").setValue(list[20]);
		addComboData(PhcSubCatStore,list[22],list[23]);
		Ext.getCmp("PHCSubCat").setValue(list[22]);
		addComboData(PhcMinCatStore,list[24],list[25]);
		Ext.getCmp("PHCMinCat").setValue(list[24]);
		Ext.getCmp("PHCDLabelName11").setValue(list[26]);
		Ext.getCmp("PHCDLabelName12").setValue(list[27]);								
		Ext.getCmp("PHCDLabelName1").setValue(list[28]);
		Ext.getCmp("PHCDFOfficialCode1").setValue(list[29]);    //�Ƽ�ͨ����
		Ext.getCmp("PHCDFOfficialCode2").setValue(list[30]);	//ԭ��ͨ����
		Ext.getCmp("PHCDFDeductPartially").setValue(list[31]=='Y'?true:false);//סԺ��һ��������						
		Ext.getCmp("OpOneDay").setValue(list[32]=='1'?true:false); //���ﰴһ��������
		Ext.getCmp("OpSkin").setValue(list[33]=='1'?true:false); //����Ƥ��ԭҺ
		Ext.getCmp("IpSkin").setValue(list[34]=='1'?true:false); //סԺƤ��ԭҺ
		Ext.getCmp("DDD").setValue(list[35]);		//DDDֵ	
		Ext.getCmp("EQQty").setValue(list[36]);		//��Ч����	
		Ext.getCmp("EQCTUom").setValue(list[37]);		//��Ч��λ
		Ext.getCmp("PHCDFAntibioticFlag").setValue(list[38]=='Y'?true:false); //����ҩ��־
		Ext.getCmp("PHCDFCriticalFlag").setValue(list[39]=='Y'?true:false); //Σ��ҩ��־
		Ext.getCmp("PHCDFAgeLimit").setValue(list[40]); //��������
		Ext.getCmp("PHCCATALL").setValue(list[41]);  //�༶ҩѧ����  add by ct
		gNewCatId=list[42]
		Ext.getCmp("PHCDFWhonetCode").setValue(list[43]); //WHONET��
	    addComboData(PhcSpecIncStore,list[44],list[45]);
		Ext.getCmp("PHCDFPhSpec").setValue(list[44]); //��ҩ��ע
		
		//add wyx 2014-12-03
		Ext.getCmp("PHCDFWhoDDD").setValue(list[46]); //WhoDDDֵ
		addComboData(PHCDFWhoDDDUomStore,list[47],list[48]);//WhoDDDUom
		Ext.getCmp("PHCDFWhoDDDUom").setValue(list[47]); //
		Ext.getCmp("PHCDFIvgttSpeed").setValue(list[49]); //����
		Ext.getCmp("PHCDFGranulesFact").setValue(list[50]); //������λϵ��
		Ext.getCmp("PHCDFProvinceComm").setValue(list[51]=='Y'?true:false);//ʡ������ҩ��
		Ext.getCmp("PHCPoison").setValue(list[52]);		//������Ʒ���
		addComboData(PHCPivaCatStore,list[53],list[54]);
		Ext.getCmp("PHCPivaCat").setValue(list[53]);	//ҩƷ��Һ����
		Ext.getCmp("HighRiskLevel").setValue(list[55]); // ��Σ����
		Ext.getCmp("PHCDFSingleUseFlag").setValue(list[56]=='Y'?true:false); // ��ζʹ�ñ�ʶ
		Ext.getCmp("PHCDFAllergyFlag").setValue(list[57]=='Y'?true:false); // ����
		Ext.getCmp("PHCDFDietTaboo").setValue(list[58]=='Y'?true:false); // ��ʳ����
		Ext.getCmp("PHCDFTumbleFlag").setValue(list[59]=='Y'?true:false); // ��������
		Ext.getCmp("PHCDFDopeFlag").setValue(list[60]=='Y'?true:false); // �˷ܼ�
		Ext.getCmp("PHCDFCQZTFlag").setValue(list[69]=='Y'?true:false); // ��������
		Ext.getCmp("PHCDFONEFlag").setValue(list[70]=='Y'?true:false); // ��ʱ����
	 }
}	

//��ѯҽ������Ϣ,zdm,2011-12-23
function SetArcDetail(listData) {			
	if(listData==null || listData=="")
	{
		return;
	}
	var list=listData.split("^");
	if (list.length > 0) {
		//Ext.getCmp("PHCDFRowid").setValue(list[0]);
		PHCDFRowid=list[0];
		Ext.getCmp("ARCIMCode").setValue(list[1]);
		Ext.getCmp("ARCIMDesc").setValue(list[2]);
		addComboData(CTUomStore,list[3],list[4]);
		Ext.getCmp("ARCIMUomDR").setValue(list[3]);
		addComboData(ArcItemCatStore,list[5],list[6]);
		Ext.getCmp("ARCItemCat").setValue(list[5]);
		var BillGrpId=list[8].split("||")[0];
		addComboData(ArcBillGrpStore,BillGrpId,list[7]);
		Ext.getCmp("ARCBillGrp").setValue(BillGrpId);
		addComboData(ArcBillSubStore,list[8],list[9]);
		Ext.getCmp("ARCBillSub").setValue(list[8]);
		Ext.getCmp("ARCIMOrderOnItsOwn").setValue(list[10]=='Y'?true:false); //����ҽ��
		addComboData(OECPriorityStore,list[11],list[12]);
		Ext.getCmp("OECPriority").setValue(list[11]);
		Ext.getCmp("WoStockFlag").setValue(list[13]=='Y'?true:false); //�޿��ҽ��
		Ext.getCmp("ARCIMText1").setValue(list[14]);
		Ext.getCmp("ARCIMAbbrev").setValue(list[15]);
		Ext.getCmp("ARCIMMaxQty").setValue(list[16]);
		Ext.getCmp("ARCIMNoOfCumDays").setValue(list[17]);
		Ext.getCmp("ARCIMMaxQtyPerDay").setValue(list[18]);
		Ext.getCmp("ARCIMMaxCumDose").setValue(list[19]);
		Ext.getCmp("ARCIMRestrictEM").setValue(list[20]=='Y'?true:false); //������ҩ	
		Ext.getCmp("ARCIMRestrictIP").setValue(list[21]=='Y'?true:false); //סԺ��ҩ						
		Ext.getCmp("ARCIMRestrictOP").setValue(list[22]=='Y'?true:false); //������ҩ
		Ext.getCmp("ARCIMRestrictHP").setValue(list[23]=='Y'?true:false); //�����ҩ	
		Ext.getCmp("ARCIMOEMessage").setValue(list[24]);
		Ext.getCmp("ARCIMEffDate").setValue(list[25]);
		Ext.getCmp("ARCIMEffDateTo").setValue(list[26]);
		addComboData(OrderCategoryStore,list[28],list[27]);
		Ext.getCmp("OrderCategory").setValue(list[28]);
		Ext.getCmp("ARCAlias").setValue(list[29]);
		
		addComboData(TarSubCateStore,list[30],list[31]);
		Ext.getCmp("SubTypeFee").setValue(list[30]);
		addComboData(TarAcctCateStore,list[32],list[33]);
		Ext.getCmp("AccountSubTypeFee").setValue(list[32]);
		addComboData(TarMRCateStore,list[34],list[35]);
		Ext.getCmp("MedSubTypeFee").setValue(list[34]);
		addComboData(TarInpatCateStore,list[36],list[37]);
		Ext.getCmp("InSubTypeFee").setValue(list[36]);
		addComboData(TarOutpatCateStore,list[38],list[39]);
		Ext.getCmp("OutSubTypeFee").setValue(list[38]);
		addComboData(TarEMCCateStore,list[40],list[41]);
		Ext.getCmp("AccSubTypeFee").setValue(list[40]);
                addComboData(TarNewMRCateStore,list[44],list[45]);
		Ext.getCmp("NewMedSubTypeFee").setValue(list[44]);
		//�շ������
		Ext.getCmp("BillCode").setValue(list[42]);
		//�շ�������
		Ext.getCmp("BillName").setValue(list[43]);
	}
}		
function clearData(){
	//ҩѧ��
	PHCCCode.setValue("");
	PHCCDesc.setValue("");
	PHCCat.setValue("");
	PHCCat.setRawValue("");
	PHCSubCat.setValue("");
	PHCSubCat.setRawValue("");
	PHCMinCat.setValue("");
	PHCMinCat.setRawValue("");
	PHCGeneric.setValue("");
	PHCGeneric.setRawValue("");
	PHCDFOfficialCode1.setValue("");
	PHCDFOfficialCode2.setValue("");
	PHCForm.setValue("");
	PHCForm.setRawValue("");	
	PHCDFCTUom.setValue("");
	PHCDFCTUom.setRawValue("");	
	PHCDFCTUom.setDisabled(false)	
	PHCDFBaseQty.setValue("");
	PHCDFPhCin.setValue("");
	PHCDFPhCin.setRawValue("");
	EQCTUom.setValue("");
	EQQty.setValue("");
	PHCDLabelName1.setValue("");
	PhManufacturer.setValue("");
	PhManufacturer.setRawValue("");
	PHCFreq.setValue("");
	PHCFreq.setRawValue("");
	PHCDuration.setValue("");
	PHCDuration.setRawValue("");
	//PHCDOfficialType.setValue("");
	//PHCDOfficialType.setRawValue("");
	PHCDFPhcDoDR.setValue("");
	PHCDFPhcDoDR.setRawValue("");
	PHCDLabelName11.setValue("");
	PHCDLabelName12.setValue("");	
	OpSkin.setValue(false);
	IpSkin.setValue(false);
	OpOneDay.setValue(false);
	PHCDFDeductPartially.setValue(false);	
	DDD.setValue("");
	PHCDFWhonetCode.setValue("");
	PHCDFPhSpec.setValue("");
	//add wxy 2014-12-03
	PHCDFWhoDDD.setValue("");
	PHCDFWhoDDDUom.setValue("");
	PHCDFIvgttSpeed.setValue("");
	PHCDFGranulesFact.setValue("");
	PHCDFProvinceComm.setValue(false);
	PHCPoison.setValue("");
	PHCDFCriticalFlag.setValue(false);	
	PHCDFAntibioticFlag.setValue(false);
	PHCPivaCat.setValue("");	
	Ext.getCmp("HighRiskLevel").setValue("");
	Ext.getCmp("PHCDFSingleUseFlag").setValue(false);
	Ext.getCmp("PHCDFAllergyFlag").setValue(false);
	Ext.getCmp("PHCDFDietTaboo").setValue(false); 
	Ext.getCmp("PHCDFTumbleFlag").setValue(false); 
	Ext.getCmp("PHCDFDopeFlag").setValue(false); 
	Ext.getCmp("PHCDFCQZTFlag").setValue(false); 
	Ext.getCmp("PHCDFONEFlag").setValue(false); 
	//ҽ����
	ARCIMCode.setValue("");
	ARCIMDesc.setValue("");
	ARCIMEffDate.setValue("");
	ARCAlias.setValue("");
	ARCBillGrp.setValue("");
	ARCBillGrp.setRawValue("");
	ARCIMUomDR.setValue("");
	ARCIMUomDR.setRawValue("");
	ARCIMMaxQty.setValue("");
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
	ARCIMMaxQtyPerDay.setValue("");
	ARCIMMaxCumDose.setValue("");
	ARCIMAbbrev.setValue("");
	ARCIMText1.setValue("");
	ARCIMNoOfCumDays.setValue("");
	BillNotActive.setValue(false);
	BillCode.setValue("");
	BillName.setValue("");
	ARCIMOrderOnItsOwn.setValue(false);
	ARCIMRestrictOP.setValue(false);
	ARCIMRestrictEM.setValue(false);
	ARCIMRestrictIP.setValue(false);
	ARCIMRestrictHP.setValue(false);
	SubTypeFee.setValue("");
	OutSubTypeFee.setValue("");	
	InSubTypeFee.setValue("");
	AccSubTypeFee.setValue("");
	MedSubTypeFee.setValue("");
	AccountSubTypeFee.setValue("");
	NewMedSubTypeFee.setValue("");
	Ext.getCmp("PHCCATALL").setValue("");
	WoStockFlag.setValue(false);
	gNewCatId=""
	//�����
	INCICode.setValue("");
	INCIDesc.setValue("");
	INFOSpec.setValue("");
	INCICTUom.setValue("");
	INCICTUom.setRawValue("");
	PUCTUomPurch.setValue("");
	PUCTUomPurch.setRawValue("");
	DHCStkCatGroup.setValue("");
	DHCStkCatGroup.setRawValue("");
	INCAlias.setValue("");
	INCIBatchReq.setValue("");
	INCIBatchReq.setRawValue("");
	INCIExpReqnew.setValue("");
	INCIExpReqnew.setRawValue("");
	INFOExpireLen.setValue("");
	INCIIsTrfFlag.setValue("");
	INCIIsTrfFlag.setRawValue("");
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
	InDrugInfo.setValue("");
	INFOSkinTest.setValue(false);
	INCINotUseFlag.setValue(false);
	ItmNotUseReason.setValue("");
	ItmNotUseReason.setRawValue("");
	INFOImportFlag.setValue("");
	INFOOTC.setValue("");
	INFOOTC.setRawValue("");
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
	UserOrderInfo.setValue("");
	INFOISCDR.setValue("");
	refRetTF.setValue("");
	INFOPbFlag.setValue(false);
	INFOBAflag.setValue(false);
	INFOTest.setValue(false);
	INFOREC.setValue(false);
	INFOBasicDrug.setValue(false);
	INFOHighPrice.setValue(false);
	INFOInHosFlag.setValue(false);
	INFOCodex.setValue(false);
	INFOBasicDrug2.setValue(false);
	INFOProvince1.setValue(false);
	INFOProvince2.setValue(false);
	//HighRiskFlag.setValue(false);
	PackUom.setValue("");
	PackUom.setRawValue("");
	PackUomFac.setValue("");
	
	PHCDFRowid="";
	ArcRowid="";
	drugRowid="";
    changeflag="";
	saveButton.setDisabled(false);
	InitDetailForm();
};

//��ʼ������
function InitDetailForm(){
	Ext.Ajax.request({
		url:'dhcst.druginfomaintainaction.csp',
		method:'post',
		params:{actiontype:'GetParamProp'},
		waitMsg:'��ʼ������...',
		success:function(response,opt){
			var jsonData=Ext.util.JSON.decode(response.responseText);
			if(jsonData.success=='true'){
				var ret=jsonData.info;
				if(ret!=null& ret!=""){
					var propValue=ret.split("^");
					var AllowInputRp=propValue[0];
					var AllowInputSp=propValue[1];
					var SameCode=propValue[2];
					var SameDesc=propValue[3];
					var InitStatusNotUse=propValue[4];
					var ModDocInfoWayByInterface=propValue[5];
				    NeedAudit=propValue[6];
					//Ext.getCmp('PHCDFAntibioticFlag').setDisabled(true);
					if(AllowInputRp=='Y'){
					   if (gParamCommon[7]=='3') {Ext.getCmp('INCIBRpPuruom').setDisabled(true);}
					   else {Ext.getCmp('INCIBRpPuruom').setDisabled(false);}
						
					}else{
						Ext.getCmp('INCIBRpPuruom').setDisabled(true);
					}
					if(AllowInputSp=='Y'){
					   if (gParamCommon[7]=='3') {Ext.getCmp('INCIBSpPuruom').setDisabled(true);}
					   else {Ext.getCmp('INCIBSpPuruom').setDisabled(false);}
					}else{
						Ext.getCmp('INCIBSpPuruom').setDisabled(true);
					}
					if(SameCode=='Y'){
						Ext.getCmp('ARCIMCode').setDisabled(true);
						Ext.getCmp('PHCCCode').setDisabled(false);
						Ext.getCmp('INCICode').setDisabled(true);
					}else{
						Ext.getCmp('ARCIMCode').setDisabled(false);
						Ext.getCmp('PHCCCode').setDisabled(false);
						Ext.getCmp('INCICode').setDisabled(false);
					}					
					if(SameDesc=='Y'){
						Ext.getCmp('ARCIMDesc').setDisabled(true);
						Ext.getCmp('PHCCDesc').setDisabled(false);
						Ext.getCmp('INCIDesc').setDisabled(true);
					}else{
						Ext.getCmp('ARCIMDesc').setDisabled(false);
						Ext.getCmp('PHCCDesc').setDisabled(false);
						Ext.getCmp('INCIDesc').setDisabled(false);
					}
					if(InitStatusNotUse=='Y'){
						Ext.getCmp('INCINotUseFlag').setValue(true);
					}else{
						Ext.getCmp('INCINotUseFlag').setValue(false);
					}
				      if(ModDocInfoWayByInterface=='Y'){
					      //wyx add ����ά����������ά��
						Ext.getCmp('INFORemark1').setDisabled(true);
						Ext.getCmp('INFORemark2').setDisabled(true);
						incApprovalButton.setDisabled(false);
					
					}else{
						//wyx add ���ý���ֱ��ά��
						Ext.getCmp('INFORemark1').setDisabled(false);
						Ext.getCmp('INFORemark2').setDisabled(false);
						incApprovalButton.setDisabled(true);
					}
					
					
					
				}
			}
		}			
	});
}
		
var addButton = new Ext.Toolbar.Button({
	text : '�½�',
	tooltip : '����½�',
	iconCls : 'page_add',
	height:30,
	disabled:false,
	width:70,
	handler : function() {
		var changeInfo="";
	if (drugRowid!="")	{
		if(IsFormChanged(PHCDrgFormPanel)){
			changeInfo=changeInfo+"ҩѧ�� ";
		}
		if(IsFormChanged(ItmMastPanel)){
			changeInfo=changeInfo+"ҽ���� ";
		}
		if(IsFormChanged(ItmPanel)){
			changeInfo=changeInfo+"����� ";
		}
	}
		if(changeInfo!=""){
			var ss=Ext.Msg.show({
			   title:'��ʾ',
			   msg: changeInfo+'��Ϣ�ѸĶ��������������������ĸĶ����Ƿ������',
			   buttons: Ext.Msg.YESNO,
			   fn: function(b,t,o){if (b=='yes')  InitBeforeAdd();	   
			   },
			   icon: Ext.MessageBox.QUESTION
			});	
		}else{
			InitBeforeAdd();
		}
	}
});

///�½�ǰ��ʼ������,liangqiang,2014-01-13
function InitBeforeAdd()
{
			clearData();
			talPanel.setActiveTab(0);	
			setDetailDisabled(0);
		    //var RowidF=OfficeCodeStore.getAt(0).get('RowId');
            //Ext.getCmp("PHCDOfficialType").setValue(RowidF);
}

function setDetailDisabled(input){
	if (input=="0") {
		Ext.getCmp("PHCDFCTUom").setDisabled(false);
		Ext.getCmp("INCICTUom").setDisabled(false);
              if (gParamCommon[7]=='3') {Ext.getCmp('INCIBSpPuruom').setDisabled(true);}
	       else {Ext.getCmp('INCIBSpPuruom').setDisabled(false);}
	       if (gParamCommon[7]=='3') {Ext.getCmp('INCIBRpPuruom').setDisabled(true);}
	       else {Ext.getCmp('INCIBRpPuruom').setDisabled(false);}
		Ext.getCmp("PHCDFBaseQty").setValue(1);
		}
    else{
    	Ext.getCmp("PHCDFCTUom").setDisabled(true);
		Ext.getCmp("INCICTUom").setDisabled(true);
		Ext.getCmp("INCIBSpPuruom").setDisabled(true);
		Ext.getCmp("INCIBRpPuruom").setDisabled(true);
       }

}

// ������������Ϣ,zdm,2011-12-20
function saveData() {
	var listPhc="";
	var listArc="";
	var listInc="";
	var loadMask=ShowLoadMask(document.body,"������...");
	if(SaveAsFlag){
		///���Ϊʱ,ֱ��ȡ���ݲ����ж�(TabPanel�Ƿ񼤻�)
		listPhc=getPhcList();
		if (listPhc==false) {loadMask.hide();return;}
		listArc=getArcList();
		if (listArc==false) {loadMask.hide();return;}
		listInc=getIncList();
		if (listInc==false) {loadMask.hide();return;}
	}else{
		listPhc=getPhcList();
		listArc=getArcList();
		if(listArc==false){	//�շ���δά��
			loadMask.hide();
			return;
		}
		listInc=getIncList();	
	}
	if(listInc==false){loadMask.hide();return;}		
	var url = "dhcst.druginfomaintainaction.csp?actiontype=SaveData";
	Ext.Ajax.request({
		url : url,
		params:{ListPhc:listPhc,ListArc:listArc,ListInc:listInc,drugRowid:drugRowid},
		method : 'POST',
		waitMsg : '������...',
		failure:function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
		},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			loadMask.hide();
			if (jsonData.success == 'true') {
				var InciRowid = jsonData.info;
				//ҩѧ��rowid^ҽ����rowid^�����rowid
				var rowid=InciRowid.split("^")[2]
				CheckManf(rowid);
				var arr = InciRowid.split("^");
				Msg.info("success", "����ɹ�!");
				var tmpDrugRowId=drugRowid;
				//����ҩѧ��rowid��ʾ��������ϸ��Ϣ�͵�Ч��λ
				clearData();
				drugRowid=arr[2];		//ΪDrugInfoList.js�б�����ֵ,�����ٴα���ʱ����.ע��clearData()�е����.
				GetDetail(arr[2]);
				//����ɹ���������ť����
				Ext.getCmp("IncAliasButton").setDisabled(false);
				Ext.getCmp("ArcAliasButton").setDisabled(false);
				Ext.getCmp("PhcEquivButton").setDisabled(false);
				//���õ�Ч��λ
				if(tmpDrugRowId==""){
					DoseEquivEdit("", drugRowid,UpdateEQCTUom);	
				}
				//���ñ���
			} else {
				if(jsonData.info==-61){Msg.info("error", "����Ϊ��!");}
				else if(jsonData.info==-62){Msg.info("error", "����Ϊ��!");}
				else if(jsonData.info==-63){Msg.info("error", "����Ϊ��!");}
				else if(jsonData.info==-64){Msg.info("error", "��λΪ��!");}
				//else if(jsonData.info==-65){Msg.info("error", "�÷�Ϊ��!");}
				else if(jsonData.info==-51){Msg.info("error", "����ҩѧ������ʧ��!");}
				else if(jsonData.info==-62){Msg.info("error", "����ҩѧ���ӱ�ʧ��!");}
				else if(jsonData.info==-66){Msg.info("error", "��Ч��ҩѧ�ӷ���!");}
				else if(jsonData.info==-67){Msg.info("error", "��Ч��ҩѧС����!");}
				else if(jsonData.info==-68){Msg.info("error", "��Ч�Ĺ��Ʒ���!");}
				else if(jsonData.info==-69){Msg.info("error", "��Ч�Ĳ���!");}
				else if(jsonData.info==-70){Msg.info("error", "��Ч��ͨ����!");}
				else if(jsonData.info==-71){Msg.info("error", "��Ч�ļ���!");}
				else if(jsonData.info==-72){Msg.info("error", "��Ч��Ƶ��!");}
				else if(jsonData.info==-73){Msg.info("error", "��Ч���÷�!");}
				else if(jsonData.info==-74){Msg.info("error", "��Ч���Ƴ�!");}
				else if(jsonData.info==-75){Msg.info("error", "��Ч�Ļ�����λ!");}
				else if(jsonData.info==-76){Msg.info("error", "ҩѧ������ظ�!");}
				else if(jsonData.info==-77){Msg.info("error", "ҩѧ�������ظ�!");}
				else if(jsonData.info==-20){Msg.info("error", "ҽ�������Ϊ��!");}
				else if(jsonData.info==-21){Msg.info("error", "ҽ��������Ϊ��!");}
				else if(jsonData.info==-22){Msg.info("error", "�Ƽ۵�λΪ��!");}
				else if(jsonData.info==-23){Msg.info("error", "���ô���Ϊ��!");}
				else if(jsonData.info==-24){Msg.info("error", "��������Ϊ��!");}
				else if(jsonData.info==-25){Msg.info("error", "ҽ������Ϊ��!");}
				else if(jsonData.info==-26){Msg.info("error", "ҩѧ��idΪ��!");}
				else if(jsonData.info==-27){Msg.info("error", "��Ч��ҽ���ӷ���!");}
				else if(jsonData.info==-28){Msg.info("error", "��Ч�ķ��ô���!");}
				else if(jsonData.info==-29){Msg.info("error", "��Ч�ķ�������!");}
				else if(jsonData.info==-30){Msg.info("error", "��Ч��ҩѧ��!");}
				else if(jsonData.info==-31){Msg.info("error", "��Ч�ļƼ۵�λ!");}
				else if(jsonData.info==-32){Msg.info("error", "ҽ��������ظ�!");}
				else if(jsonData.info==-33){Msg.info("error", "ҽ���������ظ�!");}
				else if(jsonData.info==-81){Msg.info("error", "����ҽ��������ʧ��!");}
				else if(jsonData.info==-82){Msg.info("error", "����ҽ����ӱ�ʧ��!");}
				else if(jsonData.info==-83){Msg.info("error", "����ҽ�������ʧ��!");}
				else if(jsonData.info==-16){Msg.info("error", "ʧ��,ҽ����Id����Ϊ��!");}
				else if(jsonData.info==-11){Msg.info("error", "ʧ��,�������벻��Ϊ��!");}
				else if(jsonData.info==-12){Msg.info("error", "ʧ��,��������Ʋ���Ϊ��!");}
				else if(jsonData.info==-13){Msg.info("error", "ʧ��,������λ����Ϊ��!");}
				else if(jsonData.info==-14){Msg.info("error", "ʧ��,��ⵥλ����Ϊ��!");}
				else if(jsonData.info==-15){Msg.info("error", "ʧ��,������Ϊ��!");}
				else if(jsonData.info==-17){Msg.info("error", "ʧ��,ת�Ʒ�ʽ����Ϊ��!");}
				else if(jsonData.info==-18){Msg.info("error", "ʧ��,�Ƿ�Ҫ�����β���Ϊ��!");}
				else if(jsonData.info==-19){Msg.info("error", "ʧ��,�Ƿ�Ҫ��Ч�ڲ���Ϊ��!");}
				else if(jsonData.info==-91){Msg.info("error", "��������ʧ��!");}
				else if(jsonData.info==-92){Msg.info("error", "��������ӱ�ʧ��!");}
				else if(jsonData.info==-93){Msg.info("error", "�����������ʧ��!");}
				else if(jsonData.info==-94){Msg.info("error", "����۸�ʧ��!");}
				else if(jsonData.info==-1){Msg.info("error", "��Ч�Ŀ�����!");}
				else if(jsonData.info==-3){Msg.info("error", "��Ч��ҽ����!");}
				else if(jsonData.info==-4){Msg.info("error", "��Ч�Ļ�����λ!");}
				else if(jsonData.info==-5){Msg.info("error", "��Ч����ⵥλ!");}
				else if(jsonData.info==-6){Msg.info("error", "���������Ѿ����ڣ������ظ�!");}
				else if(jsonData.info==-7){Msg.info("error", "����������Ѿ����ڣ������ظ�!");}
				else if(jsonData.info==-8){Msg.info("error", "������λ����ⵥλ֮�䲻����ת����ϵ!");}
				else if(jsonData.info==-78){Msg.info("error", "��������Ӧ����0!");}
				else if(jsonData.info==-79){Msg.info("error", "��Ч��WHONET�룬������ѡ��!");}
				else if(jsonData.info==-80){Msg.info("error", "��ҩ�����в�ҩ,Ϊ��Ч�Ĳ�ҩ��ע!");}
				else if(jsonData.info==-1001){Msg.info("error", "���������־ʧ��!");}
				else if(jsonData.info==-1002){Msg.info("error", "����ҩѧ�������־ʧ��!");}
				else if(jsonData.info==-1003){Msg.info("error", "����ҽ���������־ʧ��!");}
				else if(jsonData.info==-1004){Msg.info("error", "�������������־ʧ��!");}
				else if(jsonData.info==-1005){Msg.info("error", "������˼�¼ʧ��!");}
				else if(jsonData.info==-1006){Msg.info("error", "����δ��˼�¼,�������!");}
				else{Msg.info("error", "����ʧ��:"+jsonData.info);}
			}
		},
		scope : this
	}); 
}

function getIncList(){
	// ��������ݴ�:����^����^������λid^��ⵥλid^������id^ת�Ʒ�ʽ^�Ƿ�Ҫ������^�Ƿ�Ҫ��Ч��^����^�����ñ�־
	// ^Э����^����^������^�ۼ�^����^�۸���Ч����^���^���ڱ�־^�������^����ҩ����
	// ^����ҩ���־^�й�ҩ���־^�ٴ���֤��ҩ��־^������ҩ��־^�������^��/ʡ��^��׼�ĺ�^��ֵ���־^��������id^����ۼ�
	// ^�洢����^��ԺҩƷĿ¼^�б��־^�б����^�б꼶��^�б깩Ӧ��id^�б�������id^�б�������id^�б�����^����ɹ���־
	// ^Ч�ڳ���^����ļ���^����ļ�����ʱ��^Ƥ�Ա�־^�ʲ�����id^��ҩ˵��^ʡ������ҩ��^�м�����ҩ��^��(��)����ҩ��^ҩƷ��λ��
	// ^��ҩ����^���װ��λ^���װ��λϵ��^��Σ��־^������ԭ��^ҽ�����
	//
	//�������Ϣ
	var iNCICode = Ext.getCmp("INCICode").getValue();	 //������
	var iNCIDesc = Ext.getCmp("INCIDesc").getValue();	 //�������
	var BillUomId = Ext.getCmp("INCICTUom").getValue();	//������λ		
	var PurUomId=Ext.getCmp("PUCTUomPurch").getValue(); //��ⵥλ
	var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue(); //������id
	var TransFlag=Ext.getCmp("INCIIsTrfFlag").getValue(); //ת�Ʒ�ʽ
	var BatchFlag=Ext.getCmp("INCIBatchReq").getValue(); //����
	var ExpireFlag=Ext.getCmp("INCIExpReqnew").getValue(); //��Ч��	
	var AliasStr=Ext.getCmp("INCAlias").getValue(); //����
	var NotUseFlag=(Ext.getCmp("INCINotUseFlag").getValue()==true?'Y':'N'); //�����ñ�־
	var XieHeCode=Ext.getCmp("INCIReportingDays").getValue();	//Э����
	var BarCode=Ext.getCmp("INCIBarCode").getValue();//����	
	var Sp=Ext.getCmp("INCIBSpPuruom").getValue(); //���ۼ�
	var Rp=Ext.getCmp("INCIBRpPuruom").getValue(); //����
	var PreExeDate=Ext.getCmp("PreExeDate").getValue(); //�۸���Ч����
	if((PreExeDate!="")&&(PreExeDate!=null)){
		PreExeDate = PreExeDate.format('Y-m-d');
	}
	var Spec=Ext.getCmp("INFOSpec").getValue();//���
	var INFOImportFlag=Ext.getCmp("INFOImportFlag").getValue(); //���ڱ�־
	var QualityLevel=Ext.getCmp("INFOQualityLevel").getValue(); //�������
	var OTC=Ext.getCmp("INFOOTC").getValue(); //����ҩ����
	var BasicDrug=(Ext.getCmp("INFOBasicDrug").getValue()==true?'Y':'N');	//����ҩ���־
	var CodeX=(Ext.getCmp("INFOCodex").getValue()==true?'Y':'N');	//�й�ҩ���־
	var TestFlag=(Ext.getCmp("INFOTest").getValue()==true?'Y':'N');//�ٴ���֤��ҩ��־
	var RecFlag=(Ext.getCmp("INFOREC").getValue()==true?'Y':'N');//������ҩ��־
	var QualityNo=Ext.getCmp("INFOQualityNo").getValue();//�ʱ���
	var ComFrom=Ext.getCmp("INFOComFrom").getValue();//����/ʡ��
	var Remark1=Ext.getCmp("INFORemark1").getValue();//��׼�ĺ�ǰ׺
	var Remark2=Ext.getCmp("INFORemark2").getValue();//��׼�ĺ�
	if(Remark1==""&&Remark2!=""){
		Msg.info("error","����ǰ׺����Ϊ��");
		return false;
	}
	var Remark=Remark1+"-"+Remark2
	var HighPrice=(Ext.getCmp("INFOHighPrice").getValue()==true?'Y':'N');//ҩƷ���ֶ���������ҩ��־
	var MtDr=Ext.getCmp("INFOMT").getValue();//��������
	var MaxSp = Ext.getCmp("INFOMaxSp").getValue();//����ۼ�
	var StoreConDr=storeConRowId;//�洢����
	var InHosFlag=(Ext.getCmp("INFOInHosFlag").getValue()==true?'Y':'N');//��ԺҩƷĿ¼
	var PbFlag=(Ext.getCmp("INFOPbFlag").getValue()==true?'Y':'N');//�б��־	
	var PbRp=Ext.getCmp("INFOPbRp").getValue();//�б����
	var PbLevel=Ext.getCmp("INFOPBLevel").getValue();//�б꼶��
	var PbVendorId=Ext.getCmp("INFOPbVendor").getValue();//�б깩Ӧ��
	var PbManfId=Ext.getCmp("INFOPbManf").getValue();//�б�������
	var PbCarrier=Ext.getCmp("INFOPbCarrier").getValue();//�б�������
	var PbBlDr=Ext.getCmp("INFOPBLDR").getValue();//�б�����
	var BaFlag=(Ext.getCmp("INFOBAflag").getValue()==true?'Y':'N');//����ɹ���־
	var ExpireLen=Ext.getCmp("INFOExpireLen").getValue();//Ч�ڳ���
	var PrcFile=Ext.getCmp("INFOPrcFile").getValue();//����ļ���
	var PrcFileDate=Ext.getCmp("INFOPriceBakD").getValue();//����ļ���������
	if((PrcFileDate!="")&&(PrcFileDate!=null)){
		PrcFileDate = PrcFileDate.format('Y-m-d');
	}
	var SkinFlag=(Ext.getCmp("INFOSkinTest").getValue()==true?'Y':'N');//Ƥ�Ա�־
	var BookCatDr=Ext.getCmp("INFOBCDr").getValue();//�˲�����
	var DrugUse=Ext.getCmp("UserOrderInfo").getValue();//��ҩ˵��
	var BasicDrug2=(Ext.getCmp("INFOBasicDrug2").getValue()==true?'1':'0');//ʡ������ҩ��
	var PBasicDrug=(Ext.getCmp("INFOProvince1").getValue()==true?'1':'0');//�м�����ҩ��
	var PBasicDrug2=(Ext.getCmp("INFOProvince2").getValue()==true?'1':'0');//��(��)����ҩ��
	var StandCode=Ext.getCmp("INFODrugBaseCode").getValue();//ҩƷ��λ��
	if((StandCode!="")&&(StandCode.length<14)){
	   Msg.info("error", "ҩƷ��λ�����С����ӦΪ14���ַ�!");
	   return false;				   
	}
	var InMedBasis=Ext.getCmp("InDrugInfo").getValue();//��ҩ����
	var PackUom=Ext.getCmp("PackUom").getValue();//���װ��λ
	var PackUomFac=Ext.getCmp("PackUomFac").getValue();//���װ��λϵ��
	var HighRiskFlag=""
	//var HighRiskFlag=(Ext.getCmp("HighRiskFlag").getValue()==true?'Y':'N');//��Σ��־	
	var NotUseReason=Ext.getCmp("ItmNotUseReason").getValue();//������ԭ��
	//var InsuType=Ext.getCmp("PHCDOfficialType").getValue(); //ҽ�����
	var listInc=iNCICode+"^"+iNCIDesc+"^"+BillUomId+"^"+PurUomId+"^"+StkCatId+"^"+TransFlag+"^"+BatchFlag+"^"+ExpireFlag+"^"+AliasStr+"^"+NotUseFlag+"^"+
	XieHeCode+"^"+BarCode+"^"+userId+"^"+Sp+"^"+Rp+"^"+PreExeDate+"^"+Spec+"^"+INFOImportFlag+"^"+QualityLevel+"^"+OTC+"^"+
	BasicDrug+"^"+CodeX+"^"+TestFlag+"^"+RecFlag+"^"+QualityNo+"^"+ComFrom+"^"+Remark+"^"+HighPrice+"^"+MtDr+"^"+MaxSp+"^"+
	StoreConDr+"^"+InHosFlag+"^"+PbFlag+"^"+PbRp+"^"+PbLevel+"^"+PbVendorId+"^"+PbManfId+"^"+PbCarrier+"^"+PbBlDr+"^"+BaFlag+"^"+
	ExpireLen+"^"+PrcFile+"^"+PrcFileDate+"^"+SkinFlag+"^"+BookCatDr+"^"+DrugUse+"^"+BasicDrug2+"^"+PBasicDrug+"^"+PBasicDrug2+"^"+StandCode+"^"+
	InMedBasis+"^"+PackUom+"^"+PackUomFac+"^"+HighRiskFlag+"^"+NotUseReason+"^"+""+"^"+gLocId+"^"+gGroupId;

	return listInc;
}

function getArcList(){
	// ҽ�������ݴ�:����^����^�Ƽ۵�λid^ҽ������id^���ô���id^��������id^����ҽ����־^Ĭ��ҽ�����ȼ�id^�޿��ҽ����־^ҽ������
	// ^����^��д^ҽ�����^�����^����ʹ������^ÿ��������^����������^������ҩ^סԺ��ҩ^������ҩ
	// ^�����ҩ^ҽ����ʾ^��ά���շ���Ŀ^�Ƿ�ά��ҽ����Ŀ^�ӷ���^סԺ�ӷ���^�����ӷ���^�����ӷ���^������ҳ�ӷ���^����ӷ���
	// ^�²�����ҳ^��Ч����^��ֹ����^������
	
	//ҽ������Ϣ
	var ARCIMCode = Ext.getCmp("ARCIMCode").getValue(); //����
	var ARCIMDesc = Ext.getCmp("ARCIMDesc").getValue(); //����
	var BillUomId = Ext.getCmp("ARCIMUomDR").getValue(); //�Ƽ۵�λ
	var ItmCatId=Ext.getCmp("ARCItemCat").getValue(); //ҽ������
	//if(ItmCatId==""){Msg.info("error", "ҽ�����಻��Ϊ��!");return false;}
	var BillGrpId=Ext.getCmp("ARCBillGrp").getValue(); //���ô���
	var BillSubId=Ext.getCmp("ARCBillSub").getValue(); //��������
	var OwnFlag=(Ext.getCmp("ARCIMOrderOnItsOwn").getValue()==true?'Y':'N'); //����ҽ��
	var PriorId=Ext.getCmp("OECPriority").getValue();	 //ҽ�����ȼ�	
	var WoStockFlag=(Ext.getCmp("WoStockFlag").getValue()==true?'Y':'N');    //�޿��ҽ��
	var InsuDesc=Ext.getCmp("ARCIMText1").getValue();	 //ҽ������
	var AliasStr=Ext.getCmp("ARCAlias").getValue(); //����
	var SX=Ext.getCmp("ARCIMAbbrev").getValue();	//��д
	//var InsuType=Ext.getCmp("PHCDOfficialType").getValue();//ҽ�����
	var MaxQty=Ext.getCmp("ARCIMMaxQty").getValue(); //�����
	var NoCumOfDays=Ext.getCmp("ARCIMNoOfCumDays").getValue();	//����ʹ������	
	var MaxQtyPerDay = Ext.getCmp("ARCIMMaxQtyPerDay").getValue(); //ÿ��������
	var MaxCumDose=Ext.getCmp("ARCIMMaxCumDose").getValue(); //����������
	var RestrictEM=(Ext.getCmp("ARCIMRestrictEM").getValue()==true?'Y':'N');//������ҩ			
	var RestrictIP=(Ext.getCmp("ARCIMRestrictIP").getValue()==true?'Y':'N');//סԺ��ҩ		
	var RestrictOP=(Ext.getCmp("ARCIMRestrictOP").getValue()==true?'Y':'N');//������ҩ
	var RestrictHP=(Ext.getCmp("ARCIMRestrictHP").getValue()==true?'Y':'N');//�����ҩ				
	var OeMessage=Ext.getCmp("ARCIMOEMessage").getValue();//ҽ����ʾ			
	var UpdTarFlag=(Ext.getCmp("BillNotActive").getValue()==true?'Y':'N');//��ά���շ���
	var subTypeFee="";//�ӷ���
	var inSubTypeFee="";//סԺ�ӷ���
	var outSubTypeFee="";//�����ӷ���
	var accSubTypeFee="";//�����ӷ���
	var medSubTypeFee="";//������ҳ�ӷ���
	var accountSubTypeFee="";//����ӷ���
	var NewMedSubTypeFee="";//�²�����ҳ
	if(UpdTarFlag=="N"){
		//ά���շ���Ŀ����
		var subTypeFee=Ext.getCmp("SubTypeFee").getValue();
		if(subTypeFee==""){Msg.info("error", "�ӷ���Ϊ��!");return false;}
		var inSubTypeFee=Ext.getCmp("InSubTypeFee").getValue();
		if(inSubTypeFee==""){Msg.info("error", "סԺ�ӷ���Ϊ��!");return false;}
		var outSubTypeFee=Ext.getCmp("OutSubTypeFee").getValue();
		if(outSubTypeFee==""){Msg.info("error", "�����ӷ���Ϊ��!");return false;}
		var accSubTypeFee=Ext.getCmp("AccSubTypeFee").getValue();
		if(accSubTypeFee==""){Msg.info("error", "�����ӷ���Ϊ��!");return false;}
		var medSubTypeFee=Ext.getCmp("MedSubTypeFee").getValue();
		if(medSubTypeFee==""){Msg.info("error", "������ҳ�ӷ���Ϊ��!");return false;}
		var accountSubTypeFee=Ext.getCmp("AccountSubTypeFee").getValue();
		if(accountSubTypeFee==""){Msg.info("error", "����ӷ���Ϊ��!");return false;}
		
		var NewMedSubTypeFee=Ext.getCmp("NewMedSubTypeFee").getValue();
		if(NewMedSubTypeFee==""){Msg.info("error", "�²�����ҳΪ��!");return false;}
	}
	var medProMaintain=(Ext.getCmp("MedProMaintain").getValue()==true?'Y':'N');//ά��ҽ����
	var ARCIMEffDate=Ext.getCmp("ARCIMEffDate").getValue();//��Ч����
	if((ARCIMEffDate!="")&&(ARCIMEffDate!=null)){
		ARCIMEffDate = ARCIMEffDate.format('Y-m-d');
	}
	var ARCIMEffDateTo=Ext.getCmp("ARCIMEffDateTo").getValue();//��ֹ����
	if((ARCIMEffDateTo!="")&&(ARCIMEffDateTo!=null)){
		ARCIMEffDateTo = ARCIMEffDateTo.format('Y-m-d');
	}				
	
	var listArc=ARCIMCode+"^"+ARCIMDesc+"^"+BillUomId+"^"+ItmCatId+"^"+BillGrpId+"^"+BillSubId+"^"+OwnFlag+"^"+PriorId+"^"+WoStockFlag+"^"+InsuDesc+"^"+
	AliasStr+"^"+SX+"^"+""+"^"+MaxQty+"^"+NoCumOfDays+"^"+MaxQtyPerDay+"^"+MaxCumDose+"^"+RestrictEM+"^"+RestrictIP+"^"+RestrictOP+"^"+
	RestrictHP+"^"+OeMessage+"^"+UpdTarFlag+"^"+medProMaintain+"^"+subTypeFee+"^"+inSubTypeFee+"^"+outSubTypeFee+"^"+accSubTypeFee+"^"+medSubTypeFee+"^"+accountSubTypeFee+"^"+
	NewMedSubTypeFee+"^"+ARCIMEffDate+"^"+ARCIMEffDateTo+"^"+userId;

	return listArc;
}

function getPhcList(){	
	// ҩѧ�����ݴ�:����^����^����id^������λid^�÷�id^�Ƴ�id^��������^����id^���Ʒ���id^Ƶ��id^
	// ҽ�����^����ͨ����^ҩѧ����id^ҩѧ����id^ҩѧС��id^Ӣ�Ĺ��ʷ�ר��ҩ��^����ר��ҩ��^��Ʒ��^�Ƽ�ͨ����^ԭ��ͨ����^
	// סԺ��һ��������^���ﰴһ��������^����Ƥ����ԭҺ^סԺƤ����ԭҺ^DDDֵ^������^����ҩ��־^Σ��ҩ��־^��������
	
	//ҩѧ����Ϣ
	var PhcCode = Ext.getCmp("PHCCCode").getValue();  //����
	var PhcDesc=Ext.getCmp("PHCCDesc").getValue(); //����
	var FormId=Ext.getCmp("PHCForm").getValue(); //����
	var BuomId=Ext.getCmp("PHCDFCTUom").getValue(); //������λ
	var InstId=Ext.getCmp("PHCDFPhCin").getValue(); //�÷�
	var DuraId=Ext.getCmp("PHCDuration").getValue(); //�Ƴ�
	var BQty=Ext.getCmp("PHCDFBaseQty").getValue(); //��������
	var ManfId=Ext.getCmp("PhManufacturer").getValue(); //����
	var PosionId=Ext.getCmp("PHCDFPhcDoDR").getValue(); //���Ʒ���
	var FreqId=Ext.getCmp("PHCFreq").getValue(); //Ƶ��
	var InsuType="" //Ext.getCmp("PHCDOfficialType").getValue(); //ҽ�����
	var GenericId=Ext.getCmp("PHCGeneric").getValue(); //����ͨ����
	var PhcCatId=Ext.getCmp("PHCCat").getValue(); //ҩѧ����
	var PhcSubCatId = Ext.getCmp("PHCSubCat").getValue(); //ҩѧ����
	var PhcMinCatId=Ext.getCmp("PHCMinCat").getValue(); //ҩѧС��
	var LabelName11=Ext.getCmp("PHCDLabelName11").getValue();			//Ӣ�Ĺ��ʷ�ר��ҩ��
	var LabelName12=Ext.getCmp("PHCDLabelName12").getValue();   	//����ר��ҩ��
	var GoodName=Ext.getCmp("PHCDLabelName1").getValue(); //��Ʒ��
	var FregenName=Ext.getCmp("PHCDFOfficialCode1").getValue();		//�Ƽ�ͨ����
	var FregenName2=Ext.getCmp("PHCDFOfficialCode2").getValue();	//ԭ��ͨ����
	var partially=(Ext.getCmp("PHCDFDeductPartially").getValue()==true?'Y':'N'); //סԺ��һ��������
	
	var OpOneDay=(Ext.getCmp("OpOneDay").getValue()==true?'1':'0'); //���ﰴһ��������
	var OpSkin=(Ext.getCmp("OpSkin").getValue()==true?'1':'0'); //����Ƥ����ԭҺ
	var IpSkin=(Ext.getCmp("IpSkin").getValue()==true?'1':'0'); //סԺƤ����ԭҺ
	var DDD=Ext.getCmp("DDD").getValue(); //DDDֵ
	var PHCDFAntibioticFlag=(Ext.getCmp("PHCDFAntibioticFlag").getValue()==true?'Y':'N'); //����ҩ��־
	var PHCDFCriticalFlag=(Ext.getCmp("PHCDFCriticalFlag").getValue()==true?'Y':'N'); //Σ��ҩ��־
	var PHCDFAgeLimit=Ext.getCmp("PHCDFAgeLimit").getValue(); //��������
	var PHCDFWhonetCode=Ext.getCmp("PHCDFWhonetCode").getValue(); //WHONET��
	var PHCDFPhSpec=Ext.getCmp("PHCDFPhSpec").getValue(); //��ҩ��ע
	//add wyx 2014-12-03
	
	var WhoDDD=Ext.getCmp("PHCDFWhoDDD").getValue(); //PHCDFWhoDDDֵ
	var WhoDDDUom=Ext.getCmp("PHCDFWhoDDDUom").getValue(); //PHCDFWhoDDDֵ��λ
	var IvgttSpeed=Ext.getCmp("PHCDFIvgttSpeed").getValue(); //����
	var GranulesFact=Ext.getCmp("PHCDFGranulesFact").getValue(); //������λϵ��
	var ProvinceComm=(Ext.getCmp("PHCDFProvinceComm").getValue()==true?'Y':'N'); //ʡ������ҩ��
	var PHCDFPivaCatDr=Ext.getCmp("PHCPivaCat").getValue(); //ҩƷ��Һ����
	var HighRiskLevel=Ext.getCmp("HighRiskLevel").getValue(); //��Σ����
	var PHCDFSingleUseFlag=(Ext.getCmp("PHCDFSingleUseFlag").getValue()==true?'Y':'N'); //��ζʹ�ñ�ʶ
	var PHCDFAllergyFlag=(Ext.getCmp("PHCDFAllergyFlag").getValue()==true?'Y':'N'); //����
	var PHCDFDietTaboo=(Ext.getCmp("PHCDFDietTaboo").getValue()==true?'Y':'N'); //��ʳ����
	var PHCDFTumbleFlag=(Ext.getCmp("PHCDFTumbleFlag").getValue()==true?'Y':'N'); //��������
	var PHCDFDopeFlag=(Ext.getCmp("PHCDFDopeFlag").getValue()==true?'Y':'N'); //�˷ܼ�
	var PHCDFCQZTFlag=(Ext.getCmp("PHCDFCQZTFlag").getValue()==true?'Y':'N'); //��������
	var PHCDFONEFlag=(Ext.getCmp("PHCDFONEFlag").getValue()==true?'Y':'N'); //��ʱ����
	var listPhc=PhcCode+"^"+PhcDesc+"^"+FormId+"^"+BuomId+"^"+InstId+"^"+DuraId+"^"+BQty+"^"+ManfId+"^"+PosionId+"^"+FreqId+"^"+
	InsuType+"^"+GenericId+"^"+PhcCatId+"^"+PhcSubCatId+"^"+PhcMinCatId+"^"+LabelName11+"^"+LabelName12+"^"+GoodName+"^"+FregenName+"^"+FregenName2+"^"+
	partially+"^"+OpOneDay+"^"+OpSkin+"^"+IpSkin+"^"+DDD+"^"+userId+"^"+PHCDFAntibioticFlag+"^"+PHCDFCriticalFlag+"^"+PHCDFAgeLimit+"^"+gNewCatId+"^"+PHCDFWhonetCode+"^"+PHCDFPhSpec+"^"+
	WhoDDD+"^"+WhoDDDUom+"^"+IvgttSpeed+"^"+GranulesFact+"^"+ProvinceComm+"^"+PHCDFPivaCatDr+"^"+HighRiskLevel+"^"+PHCDFSingleUseFlag+"^"+PHCDFAllergyFlag+"^"+
	PHCDFDietTaboo+"^"+PHCDFTumbleFlag+"^"+PHCDFDopeFlag+"^"+
	"^^^^^^^^"+
	PHCDFCQZTFlag+"^"+PHCDFONEFlag;
	return listPhc;
	
}

//����ҩƷ�Ƿ��Ѿ����ã��Ӷ������Ƿ������޸ļ۸�ͻ�����λ
function CheckItmUsed(rowid){
	var url = 'dhcst.druginfomaintainaction.csp?actiontype=CheckItmUsed&IncRowid=' + rowid;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var ret = result.responseText;
			var jsonData = Ext.util.JSON.decode(ret);
			if (jsonData.success == 'true') {	
				
				var useflag = jsonData.info;
				if(useflag==1){
					Ext.getCmp("PHCDFCTUom").setDisabled(true);
					Ext.getCmp("INCICTUom").setDisabled(true);
					Ext.getCmp("INCIBSpPuruom").setDisabled(true);
					Ext.getCmp("INCIBRpPuruom").setDisabled(true);
				}else{
					Ext.getCmp("PHCDFCTUom").setDisabled(false);
					Ext.getCmp("INCICTUom").setDisabled(false);
                                   if (gParamCommon[7]=='3') {Ext.getCmp('INCIBSpPuruom').setDisabled(true);}
	                            else {Ext.getCmp('INCIBSpPuruom').setDisabled(false);}
	                            if (gParamCommon[7]=='3') {Ext.getCmp('INCIBRpPuruom').setDisabled(true);}
	                            else {Ext.getCmp('INCIBRpPuruom').setDisabled(false);}
				}
			SetCompEdit();
			}
		},
		scope : this
	});
}


//����ҩƷ������Ϣ
function CheckManf(rowid){
	var url = 'dhcst.druginfomaintainaction.csp?actiontype=CheckManf&IncRowid=' + rowid;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var ret = result.responseText;
			var jsonData = Ext.util.JSON.decode(ret);
			if (jsonData.success == 'true') {
			   	if(jsonData.info==-999){Msg.info("warning", "ҩ�����������Ч���Ѿ�����!");return;}
				else if(jsonData.info==-998){Msg.info("warning", "�������������Ч���Ѿ�����!");return;}
				else if(jsonData.info==-997){Msg.info("warning", "����ִ�������Ч���Ѿ�����!");return;}
			}
			else{
			}
		},
        scope : this
	});
}

var saveButton = new Ext.Button({
		text : '����',
		tooltip : '�������',
		height:30,
		width:70,
		iconCls : 'page_save',
		handler : function() {
				if(drugRowid==""){
					//Msg.info("warning","�����IDΪ��,ˢ������!");
					//return;
				}
				if((IsFormChanged(ItmPanel)||IsFormChanged(ItmMastPanel)||IsFormChanged(PHCDrgFormPanel))==false){
					Msg.info("warning","ҩƷ��Ϣ����δ�����ı�!");
					return;
				}
				// �жϴ���������Ƿ�Ϊ��
				var PhcCode = Ext.getCmp("PHCCCode").getValue();
				if (PhcCode == null || PhcCode=="") {
					Msg.info("warning","ҩƷ���벻��Ϊ��!");					
					return;
				}
				var PhcDesc = Ext.getCmp("PHCCDesc").getValue();
				if (PhcDesc == null || PhcDesc =="") {
					Msg.info("warning","ҩƷ���Ʋ���Ϊ��!");	
					return;
				}
				//���Ͳ���Ϊ��
				var PhcForm = Ext.getCmp("PHCForm").getValue();
				if (PhcForm == null || PhcForm =="") {
					Msg.info("warning","���Ͳ���Ϊ��!");	
					return;
				}
				//������λ����Ϊ��
				var PhcUom = Ext.getCmp("PHCDFCTUom").getValue();
				if (PhcUom == null || PhcUom =="") {
					Msg.info("warning","������λ����Ϊ��!");	
					return;
				}
				
				//�÷�����Ϊ��
				/*var PhcInstru = Ext.getCmp("PHCDFPhCin").getValue();
				if (PhcInstru == null || PhcInstru =="") {
					Msg.info("warning","�÷�����Ϊ��!");
					return;
				}
				
				//�Ƴ̲���Ϊ��
				var PhcDura = Ext.getCmp("PHCDuration").getValue();
				if (PhcDura == null || PhcDura =="") {
					Msg.info("warning","�Ƴ̲���Ϊ��!");
					return;
				}*/
				var AntibioticFlag=Ext.getCmp('PHCDFAntibioticFlag').getValue();
				//���Ʒ���Ϊ����ҩʱDDD��ֵ����
				var PHCDFPhcDoDR=Ext.getCmp('PHCDFPhcDoDR').getRawValue();
				if(PHCDFPhcDoDR.indexOf("����ҩ")!=-1){
					var DDD=Ext.getCmp('DDD').getValue();
					var PHCDFWhonetCode=Ext.getCmp('PHCDFWhonetCode').getValue();
						if(DDD==null||DDD==""){
							Msg.info("warning","���Ʒ���Ϊ����ҩʱ��������DDD��ֵ��");
							return;
						}
						if(AntibioticFlag!=true){
							Msg.info("warning","���Ʒ���Ϊ����ҩʱ����ά������ҩ��־��");
							return;
						}
						if(PHCDFWhonetCode==null||PHCDFWhonetCode==""){
							Msg.info("warning","���Ʒ���Ϊ����ҩʱ��������WHONET��ֵ��");
							return;
						};
				}
				//����ҩ��ѡʱ,����ѡ����Ʒ���
				if(AntibioticFlag==true){
					if (PHCDFPhcDoDR==""){
						Msg.info("warning","����ҩ����ѡ����Ʒ��࣡");
						return;
					}
					if(PHCDFPhcDoDR.indexOf("����ҩ")<0){
						Msg.info("warning","����ҩ�Ĺ��Ʒ������Ϊ����ҩ���һ�֣�");
						return;
					}
				}
				//�Ƽ۵�λ����Ϊ��
				var BillUomDr = Ext.getCmp("ARCIMUomDR").getValue();
				if (BillUomDr == null || BillUomDr =="") {
					Msg.info("warning","�Ƽ۵�λ����Ϊ��!");
					return;
				}
				//var PhcSubCatId=Ext.getCmp("PHCSubCat").getValue();
				//if(PhcSubCatId==null || PhcSubCatId==""){
				//	Msg.info("warning","ҩѧ���ӷ��಻��Ϊ��!");
				//	return;
				//}
				var PhcCatAll=Ext.getCmp("PHCCATALL").getValue();
			     if(PhcCatAll==null || PhcCatAll==""){
					Msg.info("warning","ҩѧ���಻��Ϊ��!");
					return;
				}
				//ҽ�����಻��Ϊ��
				var ItemCatId = Ext.getCmp("ARCItemCat").getValue();
				if (ItemCatId == null || ItemCatId =="") {
					Msg.info("warning","ҽ�����಻��Ϊ��!");
					return;
				}
				
				//���ô��಻��Ϊ��
				var BillGrpId = Ext.getCmp("ARCBillGrp").getValue();
				if (BillGrpId == null || BillGrpId =="") {
					Msg.info("warning","���ô��಻��Ϊ��!");
					return;
				}
				
				var BillSubId = Ext.getCmp("ARCBillSub").getValue();
				if (BillSubId == null || BillSubId =="") {
					Msg.info("warning","�������಻��Ϊ��!");
					return;
				}
	
				//����������λ����Ϊ��
				var BuomId = Ext.getCmp("INCICTUom").getValue();
				if (BuomId == null || BuomId =="") {
					Msg.info("warning","����������λ����Ϊ��!");
					return;
				}
				//������װ��λ����Ϊ��
				var PurUomId = Ext.getCmp("PUCTUomPurch").getValue();
				if (PurUomId == null || PurUomId =="") {
					Msg.info("warning","�������ⵥλ����Ϊ��!");
					return;
				}
				//���������಻��Ϊ��
				var StkCatId = Ext.getCmp("DHCStkCatGroup").getValue();
				if (StkCatId == null || StkCatId =="") {
					Msg.info("warning","���������಻��Ϊ��!");
					return;
				}
				//���������Ϊ��
				var INFOSpec = Ext.getCmp("INFOSpec").getValue();
				if (INFOSpec == null || INFOSpec =="") {
					Msg.info("warning","���������Ϊ��!");
					return;
				}
				if(PhcUom!=BuomId){
					Msg.info("warning","ҩѧ�������λ��Ϳ���������λһ�£�");
					return;
				}
				//if((BillUomDr!=BuomId)&(BillUomDr!=PurUomId)){
				//	Msg.info("warning","�Ƽ۵�λ�����ǿ���������λ����ⵥλ��");
				//	return;
				//}
			      var ExistFlag=CheckBillUomDr(BillUomDr,BuomId);
			      if((BillUomDr!=BuomId)&(BillUomDr!=PurUomId)&(ExistFlag==false)){
		              Msg.info("warning","�Ƽ۵�λ�������������λ��ת��ϵ���ĵ�λ��");
		              return;
	                      }
				var PreExeDate=Ext.getCmp("PreExeDate").getValue(); //�۸���Ч����
				if((PreExeDate!="")&&(PreExeDate!=null)){
					if((PreExeDate<new Date())&(drugRowid=="")){
						Msg.info("warning","�۸���Ч���ڲ������ڵ���!");
						return;
					}
				}

				// ������������Ϣ
				if ((NeedAudit=="2")||(NeedAudit=="1")&&(drugRowid==""))
				{
					Ext.MessageBox.confirm('��ʾ','������Ϣ��,���ݽ��ύ���,�Ƿ����?',
						function(btn) {
							if(btn == 'yes'){
								saveData();
							}
						}
					)
				}
				else
				{
					saveData();
				}
		}
	});
	
	// ɾ����ť
	var DeleteBT = new Ext.Toolbar.Button({
				text : 'ɾ��',
				tooltip : '���ɾ��',
				width : 70,
				height : 30,
				iconCls : 'page_delete',
				handler : function() {
					deleteData();
				}
			});

	function deleteData() {
		var gridSelected =Ext.getCmp("DrugInfoGrid"); 
		var rows=gridSelected.getSelectionModel().getSelections() ; 
		if(rows.length==0){
			Ext.Msg.show({title:'����',msg:'��ѡ��Ҫɾ����ҩƷ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
		else if(rows.length>1){
			Ext.Msg.show({title:'����',msg:'ֻ����ѡ��һ����¼��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
		else {
			// ѡ����
			var row = rows[0];
			var record = gridSelected.getStore().getById(row.id);
			var InciRowid = record.get("InciRowid");
			if (InciRowid == null || InciRowid.length <= 0) {
				gridSelected.getStore().remove(record);
			} else {
				Ext.MessageBox.show({
							title : '��ʾ',
							msg : '�Ƿ�ȷ��ɾ����ҩƷ��Ϣ',
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});

			}							
		}

	}
	
	function showResult(btn) {
		if (btn == "yes") {
			var gridSelected =Ext.getCmp("DrugInfoGrid"); 
			var rows=gridSelected.getSelectionModel().getSelections();
			var row = rows[0];
			var record = gridSelected.getStore().getById(row.id);
			var InciRowid = record.get("InciRowid");

			// ɾ����������
			var url = DictUrl
					+ "druginfomaintainaction.csp?actiontype=DeleteData&InciRowid="
					+ InciRowid;

			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success","ɾ���ɹ�!");
								gridSelected.getStore().remove(record);
								clearData();
							} else {
								var ret=jsonData.info;
								if(ret==-11){
									Msg.info("warning","ҩƷ�Ѿ���ʹ�ã�����ɾ����");
									return;
								}else{
									Msg.info("error","ɾ��ʧ��:"+ret);
									return;
								}
							}
						},
						scope : this
					});
		}
	}
	
	//
	var GetMaxCodeBT = new Ext.Toolbar.Button({
				text : '��ȡ�����',
				tooltip : '��ȡ�����',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					GetMaxCode(SetMaxCode);
				}
			});
	
	function SetMaxCode(newMaxCode){		
		//clearData(); //��ȡ�����û��Ҫ�������
		PHCCCode.setValue(newMaxCode);
		changeflag = changeflag+"C" ;
		PHCCCode.fireEvent('blur');
	}
     //wwl 20160309 Ƥ�Թ�������
	var SkinTestInfo = new Ext.Toolbar.Button({
		text : 'Ƥ�Թ���',
		tooltip : 'Ƥ�Թ���',
		width : 50,
		height : 25,
		handler : function() {
			var SkinFlag=Ext.getCmp("INFOSkinTest").getValue()	
			if((ArcRowid!="")&&(SkinFlag==true)){
				SkinTestArc(ArcRowid);	
			}else{
				Msg.info("warning","��ѡ��Ҫά��Ƥ�Թ�����ҽ����!");
				return;
			}
		}
	});
		// ���Ϊ��ť
	var SaveAsBT = new Ext.Toolbar.Button({
				text : '���Ϊ',
				tooltip : '������Ϊ',
				width : 70,
				height : 30,
				iconCls : 'page_save',
                                disabled : true,
				handler : function() {
					SaveAsData();
				}
			});
	/// ���Ϊ
	function SaveAsData()
	{
		if((IsFormChanged(ItmPanel)||IsFormChanged(ItmMastPanel)||IsFormChanged(PHCDrgFormPanel))==false){
			Msg.info("warning","ҩƷ��Ϣ����δ�����ı�!");
			return;
		}
		if(changeflag.indexOf("C")=="-1"){
			Msg.info("warning","ҩƷ������Ϣδ�����仯��");
			return;
		}
		
		if(changeflag.indexOf("D")=="-1"){
			Msg.info("warning","ҩƷ������Ϣδ�����仯��");
			return;
		}
		// �жϴ���������Ƿ�Ϊ��
		var PhcCode = Ext.getCmp("PHCCCode").getValue();
		if (PhcCode == null || PhcCode=="") {
			Msg.info("warning","ҩƷ���벻��Ϊ��!");					
			return;
		}
		var PhcDesc = Ext.getCmp("PHCCDesc").getValue();
		if (PhcDesc == null || PhcDesc =="") {
			Msg.info("warning","ҩƷ���Ʋ���Ϊ��!");	
			return;
		}
		//���Ͳ���Ϊ��
		var PhcForm = Ext.getCmp("PHCForm").getValue();
		if (PhcForm == null || PhcForm =="") {
			Msg.info("warning","���Ͳ���Ϊ��!");	
			return;
		}
		//������λ����Ϊ��
		var PhcUom = Ext.getCmp("PHCDFCTUom").getValue();
		if (PhcUom == null || PhcUom =="") {
			Msg.info("warning","������λ����Ϊ��!");	
			return;
		}
		
		//�÷�����Ϊ��
		/*var PhcInstru = Ext.getCmp("PHCDFPhCin").getValue();
		if (PhcInstru == null || PhcInstru =="") {
			Msg.info("warning","�÷�����Ϊ��!");
			return;
		}
		
		//�Ƴ̲���Ϊ��
		var PhcDura = Ext.getCmp("PHCDuration").getValue();
		if (PhcDura == null || PhcDura =="") {
			Msg.info("warning","�Ƴ̲���Ϊ��!");
			return;
		}*/
		//���Ʒ���Ϊ����ҩʱDDD��ֵ����
		var PHCDFPhcDoDR=Ext.getCmp('PHCDFPhcDoDR').getRawValue();
		if(PHCDFPhcDoDR.indexOf("����ҩ")!=-1){
			var DDD=Ext.getCmp('DDD').getValue();
			var AntibioticFlag=Ext.getCmp('PHCDFAntibioticFlag').getValue();
			var PHCDFWhonetCode=Ext.getCmp('PHCDFWhonetCode').getValue();
				if(DDD==null||DDD==""){
					Msg.info("warning","���Ʒ���Ϊ����ҩʱ��������DDD��ֵ��");
				return;}
				if(AntibioticFlag!=true){
					Msg.info("warning","���Ʒ���Ϊ����ҩʱ����ά������ҩ��־��");
					return;}
				if(PHCDFWhonetCode==null||PHCDFWhonetCode==""){
					Msg.info("warning","���Ʒ���Ϊ����ҩʱ��������WHONET��ֵ��");
				        return;}

				};
		
		//�Ƽ۵�λ����Ϊ��
		var BillUomDr = Ext.getCmp("ARCIMUomDR").getValue();
		if (BillUomDr == null || BillUomDr =="") {
			Msg.info("warning","�Ƽ۵�λ����Ϊ��!");
			return;
		}
		var PhcCatAll=Ext.getCmp("PHCCATALL").getValue();
	     if(PhcCatAll==null || PhcCatAll==""){
			Msg.info("warning","ҩѧ���಻��Ϊ��!");
			return;
		}
		//ҽ�����಻��Ϊ��
		var ItemCatId = Ext.getCmp("ARCItemCat").getValue();
		if (ItemCatId == null || ItemCatId =="") {
			Msg.info("warning","ҽ�����಻��Ϊ��!");
			return;
		}
		
		//���ô��಻��Ϊ��
		var BillGrpId = Ext.getCmp("ARCBillGrp").getValue();
		if (BillGrpId == null || BillGrpId =="") {
			Msg.info("warning","���ô��಻��Ϊ��!");
			return;
		}
		
		var BillSubId = Ext.getCmp("ARCBillSub").getValue();
		if (BillSubId == null || BillSubId =="") {
			Msg.info("warning","�������಻��Ϊ��!");
			return;
		}

		//����������λ����Ϊ��
		var BuomId = Ext.getCmp("INCICTUom").getValue();
		if (BuomId == null || BuomId =="") {
			Msg.info("warning","����������λ����Ϊ��!");
			return;
		}
		//������װ��λ����Ϊ��
		var PurUomId = Ext.getCmp("PUCTUomPurch").getValue();
		if (PurUomId == null || PurUomId =="") {
			Msg.info("warning","�������ⵥλ����Ϊ��!");
			return;
		}
		//���������಻��Ϊ��
		var StkCatId = Ext.getCmp("DHCStkCatGroup").getValue();
		if (StkCatId == null || StkCatId =="") {
			Msg.info("warning","���������಻��Ϊ��!");
			return;
		}
		//���������Ϊ��
		var INFOSpec = Ext.getCmp("INFOSpec").getValue();
		if (INFOSpec == null || INFOSpec =="") {
			Msg.info("warning","���������Ϊ��!");
			return;
		}
		if(PhcUom!=BuomId){
			Msg.info("warning","ҩѧ�������λ��Ϳ���������λһ�£�");
			return;
		}
		/*
		if((BillUomDr!=BuomId)&(BillUomDr!=PurUomId)){
			Msg.info("warning","�Ƽ۵�λ�����ǿ���������λ����ⵥλ��");
			return;
		}
		*/
		var PreExeDate=Ext.getCmp("PreExeDate").getValue(); //�۸���Ч����
		if((PreExeDate!="")&&(PreExeDate!=null)){
			if(PreExeDate<new Date().format('Y-m-d')){
				Msg.info("warning","�۸���Ч���ڲ������ڵ���!");
				return;
			}
		}

		///�����IDΪ��
		drugRowid="";
		Ext.getCmp("InciRowid").setValue("");
		// ���Ϊ��������Ϣ
		if ((NeedAudit=="2")||(NeedAudit=="1"))
		{
			Ext.MessageBox.confirm('��ʾ','������Ϣ��,���ݽ��ύ���,�Ƿ����?',
				function(btn) {
					if(btn == 'yes'){
						saveData();
					}
				}
			)
		}
		else
		{
			saveData();
		}

	}

	function SetCompEdit()
	{
		if(SaveAsFlag){
			SaveAsBT.setDisabled(false);
			saveButton.setDisabled(true);
			///�۸���Ч����Ϊ��
			PreExeDate.setValue("");
			///���ÿɱ༭
			Ext.getCmp("PHCDFCTUom").setDisabled(false);
			Ext.getCmp("INCICTUom").setDisabled(false);
                     if (gParamCommon[7]=='3') {Ext.getCmp('INCIBSpPuruom').setDisabled(true);}
	              else {Ext.getCmp('INCIBSpPuruom').setDisabled(false);}
	              if (gParamCommon[7]=='3') {Ext.getCmp('INCIBRpPuruom').setDisabled(true);}
	             else {Ext.getCmp('INCIBRpPuruom').setDisabled(false);}
		   }else{
			SaveAsBT.setDisabled(true);
			saveButton.setDisabled(false);
		};
	}
	
//===========================================================================================================
//============================ҩѧ��=========================================================================

//���ûس������ת
function SpecialKeyHandler(e,fieldId){
	var keyCode=e.getKey();
	if(keyCode==e.ENTER){
		Ext.getCmp(fieldId).focus(true);
	}
}

var PHCCCode = new Ext.form.TextField({
	fieldLabel : '<font color=red>*����</font>',
	id : 'PHCCCode',
	name : 'PHCCCode',
	anchor : '90%',
	valueNotFoundText : '',
	listeners : {
		'blur' : function(e) {
			CopyCode(Ext.getCmp('PHCCCode').getRawValue());
		},
		'specialkey':function(field,e){
			SpecialKeyHandler(e,'PHCCDesc');
		},
		'change':function(e, newValue, oldValue, eOpts ){
			if(newValue!=oldValue){ changeflag = changeflag+"C" ;}
		}
	}
});
function CopyCode(code){
	if(code!=null||code!=""){
		if(Ext.getCmp("INCICode").disabled==true){
			Ext.getCmp("INCICode").setValue(code);
		}
		if(Ext.getCmp("ARCIMCode").disabled==true){
			Ext.getCmp("ARCIMCode").setValue(code);
		}
	}
}

var PHCCDesc = new Ext.form.TextField({
	fieldLabel : '<font color=red>*����</font>',
	id : 'PHCCDesc',
	name : 'PHCCDesc',
	anchor : '90%',
	valueNotFoundText : '',
	listeners : {
		'blur' : function(e) {
			CopyDesc(Ext.getCmp('PHCCDesc').getRawValue());
		},
		'specialkey':function(field,e){
			SpecialKeyHandler(e,'PHCForm');
                },
		'change':function(e, newValue, oldValue, eOpts ){
			if(newValue!=oldValue){ changeflag = changeflag+"D" ;}
		}
	}
});
	
function CopyDesc(desc){
	if(desc!=null||desc!=""){
		if(Ext.getCmp("INCIDesc").disabled==true){
			Ext.getCmp("INCIDesc").setValue(desc);
		}
		if(Ext.getCmp("ARCIMDesc").disabled==true){
			Ext.getCmp("ARCIMDesc").setValue(desc);
		}
	}
}

var PHCCat = new Ext.ux.ComboBox({
	fieldLabel : '<font color=red>*����</font>',
	id : 'PHCCat',
	name : 'PHCCat',
	store : PhcCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PhccDesc'	 //����¼�����ݹ����������ݵĲ�������
});

PHCCat.on('change', function(e) {
	Ext.getCmp("PHCSubCat").setValue("");
	Ext.getCmp("PHCMinCat").setValue("");
});

var PHCSubCat = new Ext.ux.ComboBox({
	fieldLabel : '<font color=red>*�ӷ���</font>',
	id : 'PHCSubCat',
	name : 'PHCSubCat',
	store : PhcSubCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	params : {PhcCatId:'PHCCat'}
});

PHCSubCat.on('change',function(e){
	Ext.getCmp("PHCMinCat").setValue("");
});

var PHCMinCat = new Ext.ux.ComboBox({
	fieldLabel : '��С����',
	id : 'PHCMinCat',
	name : 'PHCMinCat',
	store : PhcMinCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	params:{PhcSubCatId:'PHCSubCat'}
});

var PHCGeneric = new Ext.ux.ComboBox({
	fieldLabel : '����ͨ����',
	id : 'PHCGeneric',
	name : 'PHCGeneric',
	store : PhcGenericStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PhcGeName',
	width:185
});

var PHCForm = new Ext.ux.ComboBox({
	fieldLabel:'<font color=red>*����</font>',
	id:'PHCForm',
	name : 'PHCForm',
	store : PhcFormStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHCFDesc',
	listeners : {
		'specialkey':function(field,e){
			SpecialKeyHandler(e,'PHCDFCTUom');			
		}
	}
});


var PHCDFCTUom = new Ext.ux.ComboBox({
	fieldLabel : '<font color=red>*������λ</font>',
	id : 'PHCDFCTUom',
	name : 'PHCDFCTUom',
	store : CTUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	width:130,
	filterName:'CTUomDesc',
	listeners : {
		'change' : function(e) {
			var phcuom=Ext.getCmp('PHCDFCTUom').getValue();
			var phcuomdesc=Ext.getCmp('PHCDFCTUom').getRawValue();
			if(phcuom!=""){
				//����������λ��ҩѧ��Ļ�����λһ��
				Ext.getCmp('INCICTUom').setValue(phcuom);
			}
		},
		'specialkey':function(field,e){
			SpecialKeyHandler(e,'PHCDFPhCin');			
		}
	}
});

var PHCDFBaseQty = new Ext.form.NumberField({
	//fieldLabel : '��������',
	fieldLabel : '<font color=red>*��������</font>',
	id : 'PHCDFBaseQty',
	name : 'PHCDFBaseQty',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true,
	value:1
});

var PHCDFOfficialCode1 = new Ext.form.TextField({
	fieldLabel : '�Ƽ�ͨ����',
	id : 'PHCDFOfficialCode1',
	name : 'PHCDFOfficialCode1',
	anchor : '90%',
	valueNotFoundText : ''
});

var PhcInStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url : 'dhcst.drugutil.csp?actiontype=PHCInstruc'
	}),
	reader : new Ext.data.JsonReader({
			totalProperty : "results",
			root : 'rows'
		}, ['Description', 'RowId'])
});
var PHCDFPhCin = new Ext.ux.ComboBox({
	fieldLabel : '�÷�',
	id : 'PHCDFPhCin',
	name : 'PHCDFPhCin',
	store : PhcInStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHCInDesc',
	listeners : {
		'specialkey':function(field,e){
			SpecialKeyHandler(e,'PHCDuration');			
		}
	}
});

var EQCTUom = new Ext.form.TextField({
	fieldLabel : '��Ч��λ',
	id : 'EQCTUom',
	name : 'EQCTUom',
	width:150,
	readOnly : true,
	valueNotFoundText : ''
});

var eqCTUomButton = new Ext.Button({
	id:'PhcEquivButton',
	text : '��Ч��λ',
	handler : function() {
		//var IncRowid = Ext.getCmp("InciRowid").getValue();
		if(drugRowid!=""){
			DoseEquivEdit("", drugRowid,UpdateEQCTUom);	
		}else
		{
			Msg.info("warning","��ѡ����Ҫά����Ч��λ��ҩѧ��!");
			return;
		}
	}
});

///�޸ĵ�С��λ�رմ��ں���½���ֵ,��λ�Լ�Ĭ�ϵ�Ч����
function UpdateEQCTUom(item)
{
	var equomstr=tkMakeServerCall("web.DHCST.PHCDRGMAST","GetDefaultDoseEquiv",item)
	if (equomstr!="")
	{
		var tmpequom=equomstr.split("^")
		Ext.getCmp("EQQty").setValue(tmpequom[0]);		//��Ч����	
		Ext.getCmp("EQCTUom").setValue(tmpequom[1]);		//��Ч��λ
	}
}
var PHCPoison = new Ext.form.TextField({
	fieldLabel : '���Ʒ���New',
	id : 'PHCPoison',
	name : 'PHCPoison',
	anchor : '90%',
	readOnly : true,
	valueNotFoundText : ''
});

var PHCPoisonButton = new Ext.Button({
	id:'PHCPoisonButton',
	text : '���Ʒ���',
	handler : function() {
		//var IncRowid = Ext.getCmp("InciRowid").getValue();
		if(drugRowid!=""){
			PhcPoisonEdit("", drugRowid);	
		}else
		{
			Msg.info("warning","��ѡ����Ҫά�����Ʒ����ҩѧ��!");
			return;
		}
	}
});

// ����ά��
var PhManufacturerButton = new Ext.Button({
	id:'PhManufacturerButton',
	text : 'ά��',
	handler : function() {
       var lnk="dhcst.phmanf.csp";
       if (isIE())
       {
       		var retstr=showModalDialog(lnk,'','dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
       }
       else
       {
       		window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
       }
	}
});
// ͨ����ά����ť
var PhcGenericButton = new Ext.Button({
	id:'PhcGenericButton',
	text : 'ά��',
	handler : function() {
	  var lnk="dhc.bdp.ext.default.csp?extfilename=App/Pharmacy/Phc_generic";
         //location.href=lnk;
         window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
        //PhcGenericMt();
	}
});
//wyx add 2014-02-24 ���ӻ�����λ��ά��
var PHCDFCTUomButton = new Ext.Button({
	id:'PHCDFCTUomButton',
	text : '������λά��',
	handler : function() {
	  var lnk="dhc.bdp.ext.default.csp?extfilename=App/Stock/CT_UOM";
         //location.href=lnk;
         window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
      
	}
});
//wyx add 2014-02-24 ���ӵ�λת����ά��
var CTUomChangeButton = new Ext.Button({
	id:'CTUomChangeButton',
	iconCls : 'page_refresh',
	text : '��λת��ά��',
	handler : function() {
	  var lnk="dhc.bdp.ext.default.csp?extfilename=App/Stock/CT_ConFac";
         //location.href=lnk;
         window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
      
	}
});
var EQQty = new Ext.form.NumberField({
	fieldLabel : '��Ч����',
	id : 'EQQty',
	name : 'EQQty',
	anchor : '90%',
	readOnly : true,
	allowNegative : false,
	selectOnFocus : true,
	decimalPrecision:4
});

var PHCDFOfficialCode2 = new Ext.form.TextField({
	fieldLabel : 'ԭ��ͨ����',
	id : 'PHCDFOfficialCode2',
	name : 'PHCDFOfficialCode2',
	anchor : '90%',
	valueNotFoundText : ''
});

var PHCFreq = new Ext.ux.ComboBox({
	fieldLabel : 'Ƶ��',
	id : 'PHCFreq',
	name : 'PHCFreq',
	store : PhcFreqStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PhcFrDesc'
});

var PhManufacturer = new Ext.ux.ComboBox({
	fieldLabel : '����',
	id : 'PhManufacturer',
	name : 'PhManufacturer',
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName',
	width:185
});

var PHCDuration = new Ext.ux.ComboBox({
	fieldLabel : '�Ƴ�',
	id : 'PHCDuration',
	name : 'PHCDuration',
	store : PhcDurationStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PhcDuDesc',
	listeners : {
		'specialkey':function(field,e){
			//talPanel.setActiveTab(1);
			SpecialKeyHandler(e,'ARCBillGrp');			
		}
	}
});

/*OfficeCodeStore.load();
var PHCDOfficialType = new Ext.ux.ComboBox({
	fieldLabel : 'ҽ�����',
	id : 'PHCDOfficialType',
	name : 'PHCDOfficialType',
	mode:'local',
	store : OfficeCodeStore,
	valueField : 'RowId',
	displayField : 'Description'

});
OfficeCodeStore.on('load', function() {
   var RowidF=OfficeCodeStore.getAt(0).get('RowId');
    Ext.getCmp("PHCDOfficialType").setValue(RowidF);
				});
//Ext.getCmp("PHCDOfficialType").setValue("1");*/

var PHCDFPhcDoDR = new Ext.ux.ComboBox({
	fieldLabel : '���Ʒ���',
	id : 'PHCDFPhcDoDR',
	name : 'PHCDFPhcDoDR',
	store : PhcPoisonStore,
	valueField : 'RowId',
	displayField : 'Description'
});

PHCDFPhcDoDR.on('select',function(){
		Ext.getCmp('DDD').setDisabled(false);
		Ext.getCmp('PHCDFWhonetCode').setDisabled(false);
		var PHCDFPhcDoDR=Ext.getCmp('PHCDFPhcDoDR').getRawValue();
		if(PHCDFPhcDoDR.indexOf("����ҩ")!=-1){
			var DDD=Ext.getCmp('DDD').getValue();
			if(DDD==null||DDD==""){
				Msg.info("warning","������DDD��ֵ��WHONET�룡");
				//Msg.info("warning","���Ʒ���Ϊ����ҩʱ��������DDD��ֵ��");
			return;}
			
			Ext.getCmp('DDD').focus();
			Ext.getCmp('PHCDFWhonetCode').focus();
			Ext.getCmp('PHCDFAntibioticFlag').setValue(true);} 
			});
			
var PHCDLabelName11 = new Ext.form.TextField({
	fieldLabel : 'Ӣ�Ĺ��ʷ�ר��ҩ��',
	id : 'PHCDLabelName11',
	name : 'PHCDLabelName11',
	anchor : '90%',
	valueNotFoundText : ''
});

var PHCDLabelName12 = new Ext.form.TextField({
	fieldLabel : '����ר��ҩ��',
	id : 'PHCDLabelName12',
	name : 'PHCDLabelName12',
	anchor : '90%',
	valueNotFoundText : ''
});

var PHCDLabelName1 = new Ext.form.TextField({
	fieldLabel : '��Ʒ��',
	id : 'PHCDLabelName1',
	name : 'PHCDLabelName1',
	anchor : '90%',
	valueNotFoundText : ''
});

var OpSkin = new Ext.form.Checkbox({
	fieldLabel : '����Ƥ����ԭҺ',
	id : 'OpSkin',
	name : 'OpSkin',
	anchor : '90%',
	checked : false
});

var IpSkin = new Ext.form.Checkbox({
	fieldLabel : 'סԺƤ����ԭҺ',
	id : 'IpSkin',
	name : 'IpSkin',
	anchor : '90%',
	checked : false
});

var OpOneDay = new Ext.form.Checkbox({
	fieldLabel : '���ﰴһ��������',
	id : 'OpOneDay',
	name : 'OpOneDay',
	anchor : '90%',
	checked : false
});

var PHCDFDeductPartially = new Ext.form.Checkbox({
	fieldLabel : 'סԺ��һ��������',
	id : 'PHCDFDeductPartially',
	name : 'PHCDFDeductPartially',
	anchor : '90%',
	checked : false
});
//add wyx 2014-12-03
var PHCDFProvinceComm = new Ext.form.Checkbox({
	fieldLabel : 'ʡ������ҩ��',
	id : 'PHCDFProvinceComm',
	name : 'PHCDFProvinceComm',
	anchor : '90%',
	checked : false
});

var PHCDFAntibioticFlag=new Ext.form.Checkbox({
			fieldLabel:'����ҩ��־',
			id:'PHCDFAntibioticFlag',
			name : 'PHCDFAntibioticFlag',
			anchor : '90%',
			checked : false
			});
			
var PHCDFCriticalFlag=new Ext.form.Checkbox({
			fieldLabel:'Σ��ҩ��־',
			id:'PHCDFCriticalFlag',
			name : 'PHCDFCriticalFlag',
			anchor : '90%',
			checked : false
			});
		
var DDD = new Ext.form.NumberField({
	fieldLabel : 'DDDֵ',
	id : 'DDD',
	name : 'DDD',
	anchor : '90%',
	decimalPrecision:5,
	valueNotFoundText : ''
});
//�˱�����ҳ����˻س���ݼ�����ע��listeners hulihua 2014-9-18
var PHCDFWhonetCode = new Ext.form.TextField({
	fieldLabel : 'WHONET��',
	id : 'PHCDFWhonetCode',
	name : 'PHCDFWhonetCode',
	width:130,
	valueNotFoundText : ''
	/**listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var inputText=field.getValue();
							GetPhcWhonetInfo(inputText);
						}
					}
				}**/
});

//add wyx 2014-12-03 WHODDDֵ
var PHCDFWhoDDD = new Ext.form.NumberField({
	fieldLabel : 'WHODDDֵ',
	id : 'PHCDFWhoDDD',
	name : 'PHCDFWhoDDD',
	width:120,
	decimalPrecision:5,
	valueNotFoundText : '',
	enableKeyEvents:true,
	listeners : {
		'keyup' : function(e) {
			var PhcdCode=Ext.getCmp('PHCCCode').getValue();
			var WhoDDD=Ext.getCmp('PHCDFWhoDDD').getValue();
			var WhoDDDUom=Ext.getCmp('PHCDFWhoDDDUom').getValue();
			if(WhoDDDUom==""){
				Msg.info("warning", "��ѡ��WHODDD��λ!");
				return;
			}
			var RetDDD=tkMakeServerCall("web.DHCST.PHCDRGMAST","GetBUomDDD",PhcdCode,WhoDDD,WhoDDDUom);
			Ext.getCmp('DDD').setValue(RetDDD);
		}
	}

});

var PHCDFWhoDDDUom = new Ext.ux.ComboBox({
	id : 'PHCDFWhoDDDUom',
	name : 'PHCDFWhoDDDUom',
	width:100,
	forceSelection : true,  
	store : PHCDFWhoDDDUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHCDFWhoDDDName',
	params:{PHCDFCode:'PHCCCode'},
	listeners : {
		'select' : function(e) {
			var PhcdCode=Ext.getCmp('PHCCCode').getValue();
			var WhoDDD=Ext.getCmp('PHCDFWhoDDD').getValue();
			var WhoDDDUom=Ext.getCmp('PHCDFWhoDDDUom').getValue();
			var RetDDD=tkMakeServerCall("web.DHCST.PHCDRGMAST","GetBUomDDD",PhcdCode,WhoDDD,WhoDDDUom);
			Ext.getCmp('DDD').setValue(RetDDD);
		}
	}
});
//add wyx 2014-12-03 ����
var PHCDFIvgttSpeed = new Ext.form.NumberField({
	fieldLabel : '����',
	id : 'PHCDFIvgttSpeed',
	name : 'PHCDFIvgttSpeed',
	anchor : '90%',
	decimalPrecision:5,
	valueNotFoundText : ''
});
//add wyx 2014-12-03 ������λϵ��
var PHCDFGranulesFact = new Ext.form.NumberField({
	fieldLabel : '������λϵ��',
	id : 'PHCDFGranulesFact',
	name : 'PHCDFGranulesFact',
	anchor : '90%',
	valueNotFoundText : ''
});
/**
/**
 * ����WHONET�봰�岢���ؽ��
 */
function GetPhcWhonetInfo(item) {
				
	if (item != null && item.length > 0) {
		WhonetButEdit(item, getWhonetList);
	}
}
//���Ƽ۵�λ�ͻ�����λ֮���Ƿ��б�����ϵ //add hulihua 2014-12-29 
function CheckBillUomDr(BillUomDr,BuomId){
	var flag=false;
	var Url = "dhcst.druginfomaintainaction.csp?";
	var NewUrl=Url+"actiontype=CheckBillUomDr&BillUomDr="+BillUomDr+"&BuomId="+BuomId;
	var responseText=ExecuteDBSynAccess(NewUrl);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		flag= true;
		}
	return flag;
}
/**
 * ���ط���
*/
function getWhonetList(AntCode) {
	if (AntCode == null || AntCode == "") {
		return;
	}
	Ext.getCmp("PHCDFWhonetCode").setValue(AntCode);
}

var WhonetButton = new Ext.Button({
	id:'WHONETButton',
	text : 'WHONET��',
	handler : function() {
		var inputText = Ext.getCmp("PHCDFWhonetCode").getValue();
		WhonetButEdit(inputText, getWhonetList); 
	}
});

var PHCDFPhSpec = new Ext.ux.ComboBox({
	fieldLabel : '��ҩ��ע',
	id : 'PHCDFPhSpec',
	name : 'PHCDFPhSpec',
	mode:'local',
	store : PhcSpecIncStore,
	valueField : 'RowId', 
	displayField : 'Description',
	filterName:'PHCSpecInDesc'
});

var PHCDFAgeLimit = new Ext.form.TextField({
	fieldLabel : '��������',
	id : 'PHCDFAgeLimit',
	name : 'PHCDFAgeLimit',
	anchor : '90%',
	valueNotFoundText : ''
});

var PHCCATALL = new Ext.form.TextField({
	fieldLabel : '<font color=red>*ҩѧ����</font>',
	id : 'PHCCATALL',
	name : 'PHCCATALL',
	width:200,
	readOnly : true,
	valueNotFoundText : ''
});

//GetAllCatNew("kkk");
function GetAllCatNew(catdescstr,newcatid){
	//if ((catdescstr=="")&&(newcatid=="")) {return;}
	Ext.getCmp("PHCCATALL").setValue(catdescstr);
	gNewCatId=newcatid;
	
	
}
// ҩѧ����
var PHCCATALLButton = new Ext.Button({
	id:'PHCCATALLButton',
	text : '...',
	handler : function() {	
		PhcCatNewSelect(gNewCatId,GetAllCatNew)

    }
});
var PHCPivaCat = new Ext.ux.ComboBox({
	fieldLabel : 'ҩƷ��Һ����',
	id : 'PHCPivaCat',
	name : 'PHCPivaCat',
	store : PHCPivaCatStore,
	valueField : 'RowId',
	displayField : 'Description'
});
var HighRiskLevel = new Ext.form.ComboBox({
	fieldLabel : '��Σ����',
	id : 'HighRiskLevel',
	name : 'HighRiskLevel',
	anchor : '90%',					
	store : HighRiskLevelStore,
	valueField : 'RowId',
	displayField : 'Description',
	mode : 'local',
	allowBlank : true,
	triggerAction : 'all',
	selectOnFocus : true,
	listWidth : 150,
	forceSelection : true
});
var PHCDFTumbleFlag=new Ext.form.Checkbox({
	fieldLabel:'��������',
	id:'PHCDFTumbleFlag',
	name : 'PHCDFTumbleFlag',
	anchor : '90%',
	checked : false
});
var PHCDFDopeFlag=new Ext.form.Checkbox({
	fieldLabel:'�˷ܼ�',
	id:'PHCDFDopeFlag',
	name : 'PHCDFDopeFlag',
	anchor : '90%',
	checked : false
});
var PHCDFDietTaboo=new Ext.form.Checkbox({
	fieldLabel:'��ʳ����',
	id:'PHCDFDietTaboo',
	name : 'PHCDFDietTaboo',
	anchor : '90%',
	checked : false
});
var PHCDFAllergyFlag=new Ext.form.Checkbox({
	fieldLabel:'����',
	id:'PHCDFAllergyFlag',
	name : 'PHCDFAllergyFlag',
	anchor : '90%',
	checked : false
});
var PHCDFSingleUseFlag=new Ext.form.Checkbox({
	fieldLabel:'��ζʹ�ñ�ʶ',
	id:'PHCDFSingleUseFlag',
	name : 'PHCDFSingleUseFlag',
	anchor : '90%',
	checked : false
});
var PHCDFCQZTFlag=new Ext.form.Checkbox({
	fieldLabel:'����Ĭ������',
	id:'PHCDFCQZTFlag',
	name : 'PHCDFCQZTFlag',
	anchor : '90%',
	checked : false
});
var PHCDFONEFlag=new Ext.form.Checkbox({
	fieldLabel:'��ʱĬ��ȡҩ',
	id:'PHCDFONEFlag',
	name : 'PHCDFONEFlag',
	anchor : '90%',
	checked : false
});
// ҩѧ��Panel
var PHCDrgFormPanel = new Ext.form.FormPanel({
		labelWidth : 95,
		labelAlign : 'right',
		frame : true,
		autoScroll:true,
		items : [{
					layout : 'column',
					xtype:'fieldset',
					bodyStyle:'padding:1px 0px 0px 0px',
					defaults:{border:false},
					items : [{
						columnWidth : 0.5,
						xtype:'fieldset',
						items : [PHCCCode,PHCDFOfficialCode1,PHCForm,PHCDFBaseQty,
						{xtype:'compositefield',items:[EQCTUom,eqCTUomButton]},PHCDLabelName1,PHCFreq,
						PHCDLabelName11,DDD,{xtype:'compositefield',items:[PHCDFWhonetCode,WhonetButton]},
						{xtype:'compositefield',items:[PHCDFWhoDDD,PHCDFWhoDDDUom]},PHCDFGranulesFact,PHCPivaCat]
					},{
						columnWidth : 0.5,
						xtype:'fieldset',
						items : [PHCCDesc,{xtype:'compositefield',items:[PHCGeneric,PhcGenericButton]},PHCDFOfficialCode2,{xtype:'compositefield',items:[PHCDFCTUom,PHCDFCTUomButton]},PHCDFPhCin,EQQty,
						{xtype:'compositefield',items:[PhManufacturer,PhManufacturerButton]},PHCDuration,PHCDFPhcDoDR,PHCDLabelName12,{xtype:'compositefield',items:[PHCCATALL,PHCCATALLButton]}, //�˴�ԭ����������
						PHCDFPhSpec,{xtype:'compositefield',items:[PHCDFIvgttSpeed,{ xtype: 'displayfield', value: 'gtt/min'}]},HighRiskLevel]
					}]
		},{
			layout:'column',
			xtype:'fieldset',
			labelWidth:130,
			style:'padding:10px 0px 0px 0px',
			defaults:{border:false},
			items:[{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[PHCDFAntibioticFlag,PHCDFCriticalFlag,PHCDFProvinceComm,PHCDFCQZTFlag]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[OpSkin,IpSkin,PHCDFSingleUseFlag,PHCDFONEFlag]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[OpOneDay,PHCDFDeductPartially,PHCDFAllergyFlag]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[PHCDFDietTaboo,PHCDFTumbleFlag,PHCDFDopeFlag]
			}]
		}]
}); 
//============================ҩѧ��=========================================================================

//============================ҽ����=========================================================================
var ARCIMCode = new Ext.form.TextField({
		fieldLabel : '<font color=red>*����</font>',
		id : 'ARCIMCode',
		name : 'ARCIMCode',
		anchor : '90%',
		disabled:true,
		valueNotFoundText : '',
		listeners:{
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'ARCIMDesc');			
			}
		}
		});

var ARCIMDesc = new Ext.form.TextField({
			fieldLabel : '<font color=red>*����</font>',
		id : 'ARCIMDesc',
		name : 'ARCIMDesc',
		anchor : '90%',
		disabled:true,
		valueNotFoundText : '',
		listeners:{
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'ARCBillGrp');			
			}
		}
	});

var ARCAlias = new Ext.form.TextField({
			fieldLabel : '����',
		id : 'ARCAlias',
		name : 'ARCAlias',
		anchor : '90%',
		//width : 370,
		emptyText:'�������֮����/�ָ�',
		valueNotFoundText : '',
			disabled:true
		});

var arcAliasButton = new Ext.Button({
			id:'ArcAliasButton',
		text : '����',
		width : 15,
		handler : function() {
			//var IncRowid = Ext.getCmp("InciRowid").getValue();
			if(ArcRowid!=""){
				OrdAliasEdit("", ArcRowid);	
			}else{
				Msg.info("warning","��ѡ��Ҫά��������ҽ����!");
				return;
			}	
		}
	});

var ARCIMEffDate = new Ext.ux.DateField({
			fieldLabel : '��Ч����',
		id : 'ARCIMEffDate',
		name : 'ARCIMEffDate',
		anchor : '90%',
		value : ''
		});

//-------------zhaozhdiuan  ��ҩ��λ
var dispuomButton = new Ext.Button({
		id:'DispUomButton',
		text : '��ҩ��λά��',
		iconCls:"drug_maintain",
		width : 110,
		handler : function() {
			var BuomId = Ext.getCmp("INCICTUom").getValue();
			if(ArcRowid!=""){
				DispUomEdit("", ArcRowid,BuomId);	
			}
		}
	});
//------------
var ARCIMEffDateTo = new Ext.ux.DateField({
		fieldLabel : '��ֹ����',
		id : 'ARCIMEffDateTo',
		name : 'ARCIMEffDateTo',
		anchor : '90%',
		value : ''
		});

var ARCBillGrp = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*���ô���</font>',
		id : 'ARCBillGrp',
		name : 'ARCBillGrp',
		store : ArcBillGrpStore,
		valueField : 'RowId',
		displayField : 'Description',
		listeners:{
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'ARCBillSub');			
			}
		}
	});

ARCBillGrp.on('change',function(){
	Ext.getCmp("ARCBillSub").setValue("");
});
	
var ARCBillSub = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*��������</font>',
		id : 'ARCBillSub',
		name : 'ARCBillSub',
		store : ArcBillSubStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{ARCBGRowId:'ARCBillGrp'}
});

var ARCIMUomDR = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*�Ƽ۵�λ</font>',
		id : 'ARCIMUomDR',
		name : 'ARCIMUomDR',
		store : CTUomStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'CTUomDesc',
		listeners : {
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'OrderCategory');			
			}
		}
});

/*
var ARCIMUomDR = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*�Ƽ۵�λ</font>',
		id : 'ARCIMUomDR',
		name : 'ARCIMUomDR',
		store : CONUomStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{Buom:'PHCDFCTUom'},
		filterName:'CTUomDesc',
		listeners : {
			'focus':function(combox){
				var uom=Ext.getCmp("PHCDFCTUom").getValue();
				if(uom==null||uom==""){
					Msg.info("warning","����ά��ҩѧ�������λ!");
					return;
				}
			},
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'OrderCategory');			
			}
		}
});
*/
var OrderCategory = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*ҽ������</font>',
		id : 'OrderCategory',
		name : 'OrderCategory',
		store : OrderCategoryStore,
		valueField : 'RowId',
		displayField : 'Description',
		listeners:{
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'ARCItemCat');			
			}
		}
});

var ARCItemCat = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*ҽ������</font>',
		id : 'ARCItemCat',
		name : 'ARCItemCat',
		store : ArcItemCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'Desc',
		params:{OrderCat:'OrderCategory'}  //OrderCategoryΪҽ�������id
	});

var OECPriority = new Ext.ux.ComboBox({
		fieldLabel : '���ȼ�',
		id : 'OECPriority',
		name : 'OECPriority',
		store : OECPriorityStore,
		valueField : 'RowId',
		displayField : 'Description'
});

var ARCIMMaxQty = new Ext.form.NumberField({
			fieldLabel : '�����',
		id : 'ARCIMMaxQty',
		name : 'ARCIMMaxQty',
		anchor : '90%',
			allowNegative : false,
			selectOnFocus : true
		});

var ARCIMOEMessage = new Ext.form.TextField({
			fieldLabel : 'ҽ����ʾ',
		id : 'ARCIMOEMessage',
		name : 'ARCIMOEMessage',
		anchor : '90%',
		valueNotFoundText : ''
		});

var ARCIMNoOfCumDays = new Ext.form.NumberField({
			fieldLabel : '����ʹ������',
		id : 'ARCIMNoOfCumDays',
		name : 'ARCIMNoOfCumDays',
		anchor : '90%',
			allowNegative : false,
			selectOnFocus : true
		});

var ARCIMMaxQtyPerDay = new Ext.form.NumberField({
			fieldLabel : 'ÿ��������',
		id : 'ARCIMMaxQtyPerDay',
		name : 'ARCIMMaxQtyPerDay',
		decimalPrecision:5,
		anchor : '90%',
			allowNegative : false,
			selectOnFocus : true
		});

var ARCIMMaxCumDose = new Ext.form.NumberField({
			fieldLabel : '����������',
		id : 'ARCIMMaxCumDose',
		name : 'ARCIMMaxCumDose',
		anchor : '90%',
		decimalPrecision:5,
			allowNegative : false,
			selectOnFocus : true
		});

var ARCIMRestrictOP = new Ext.form.Checkbox({
			fieldLabel : '������ҩ',
		id : 'ARCIMRestrictOP',
		name : 'ARCIMRestrictOP',
		anchor : '90%',
			height : 10,
			width : 30 ,
			checked : false
		});

var ARCIMRestrictEM = new Ext.form.Checkbox({
			fieldLabel : '������ҩ',
		id : 'ARCIMRestrictEM',
		name : 'ARCIMRestrictEM',
		anchor : '90%',
		height : 10,
		width : 30 ,
		checked : false
		});

var ARCIMRestrictIP = new Ext.form.Checkbox({
			fieldLabel : 'סԺ��ҩ',
		id : 'ARCIMRestrictIP',
		name : 'ARCIMRestrictIP',
		anchor : '90%',
		height : 10,
		width : 30 ,
		checked : false
		});

var ARCIMRestrictHP = new Ext.form.Checkbox({
			fieldLabel : '�����ҩ',
		id : 'ARCIMRestrictHP',
		name : 'ARCIMRestrictHP',
		anchor : '90%',
		height : 10,
		width : 30 ,
		checked : false
		});


var BillNotActive = new Ext.form.Checkbox({
			fieldLabel : '��ά���շ���',
		id:'BillNotActive',
		name:'BillNotActive',
		anchor:'90%',
		checked:false,
		listeners:{
			'check':function(checked){
				if(checked.checked){
					document.getElementById('SubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="�ӷ���:"; 

					SubTypeFee.setValue("");
					SubTypeFee.setRawValue("");
					SubTypeFee.disable();
					
					document.getElementById('InSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="סԺ�ӷ���:"; 
					InSubTypeFee.setValue("");
					InSubTypeFee.setRawValue("");
					InSubTypeFee.disable();
					
					document.getElementById('OutSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="�����ӷ���:"; 
					OutSubTypeFee.setValue("");
					OutSubTypeFee.setRawValue("");
					OutSubTypeFee.disable();
					
					document.getElementById('AccSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="�����ӷ���:"; 
					AccSubTypeFee.setValue("");
					AccSubTypeFee.setRawValue("");
					AccSubTypeFee.disable();
					
					document.getElementById('MedSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="������ҳ����:"; 
					MedSubTypeFee.setValue("");
					MedSubTypeFee.setRawValue("");
					MedSubTypeFee.disable();
					
					document.getElementById('AccountSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="����ӷ���:"; 
					AccountSubTypeFee.setValue("");
					AccountSubTypeFee.setRawValue("");
					AccountSubTypeFee.disable();

					document.getElementById('NewMedSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="������ҳ:"; 
					NewMedSubTypeFee.setValue("");
					NewMedSubTypeFee.setRawValue("");
					NewMedSubTypeFee.disable();
				}else{
					document.getElementById('SubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="<font color=red>�ӷ���</font>:"; 
					SubTypeFee.enable();
					document.getElementById('InSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="<font color=red>סԺ�ӷ���</font>:";
					InSubTypeFee.enable();
					document.getElementById('OutSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="<font color=red>�����ӷ���</font>:";
					OutSubTypeFee.enable();
					document.getElementById('AccSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="<font color=red>�����ӷ���</font>:";
					AccSubTypeFee.enable();
					document.getElementById('MedSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="<font color=red>������ҳ����</font>:";
					MedSubTypeFee.enable();
					document.getElementById('AccountSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="<font color=red>����ӷ���</font>:";
						AccountSubTypeFee.enable();
					document.getElementById('NewMedSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="<font color=red>������ҳ</font>:";
					NewMedSubTypeFee.enable(); 
					}
				}
			}
		});

var BillCode = new Ext.form.TextField({
			fieldLabel : '�շ������',
		id : 'BillCode',
		name : 'BillCode',
		anchor : '90%',
		disabled:true,
		valueNotFoundText : ''
		});

var BillName = new Ext.form.TextField({
			fieldLabel : '�շ�������',
		id : 'BillName',
		name : 'BillName',
		anchor : '90%',
		disabled:true,
		valueNotFoundText : ''
		});

var ARCIMAbbrev = new Ext.form.TextField({
			fieldLabel : '��д',
		id : 'ARCIMAbbrev',
		name : 'ARCIMAbbrev',
		anchor : '90%',
		valueNotFoundText : '',
		disabled:true
		});

var ARCIMText1 = new Ext.form.TextField({
			fieldLabel : 'ҽ������',
		id : 'ARCIMText1',
		name : 'ARCIMText1',
		anchor : '90%',
		valueNotFoundText : ''
		});

//var DHCArcItemAut = new Ext.Button({
//			text : '���ƿ�������',
//			handler : function() {
//			}
//		});

//------------xiaohe ���ƿ�����ҩ
var RestrictDocButton = new Ext.Button({
		id:'RestrictDocButton',
		text : '���ƿ�����ҩ',
		iconCls:"drug_limit",
		width : 100,
		handler : function() {
            var ArcimCode = Ext.getCmp("ARCIMCode").getValue(); //����
			var ArcimDesc = Ext.getCmp("ARCIMDesc").getValue(); //����
			var Spec=Ext.getCmp("INFOSpec").getValue();   //���
			var ManfId=Ext.getCmp("PhManufacturer").getValue(); //����		
			if(ArcRowid!=""){
				RestrictDocEdit("", ArcRowid,ArcimCode,ArcimDesc,Spec,ManfId);	
			}
		}
	});
//------------


var ARCIMOrderOnItsOwn = new Ext.form.Checkbox({
			fieldLabel : '����ҽ��',
		id : 'ARCIMOrderOnItsOwn',
		name : 'ARCIMOrderOnItsOwn',
		anchor : '90%',
		height : 10,
		width : 30 ,
		checked : true
		});
var ARCIMRowid = new Ext.form.TextField({
			fieldLabel : 'ARCIMRowid',
		id : 'ARCIMRowid',
		name : 'ARCIMRowid',
		anchor : '90%',
		hidden:true,
		valueNotFoundText : ''
		});
		
var WoStockFlag = new Ext.form.Checkbox({
		fieldLabel : '�޿��ҽ��',
		id : 'WoStockFlag',
		name : 'WoStockFlag',
		anchor : '90%',
		height : 10,
		width : 30 ,
		checked : false
	});
	
//�ӷ���
var SubTypeFee = new Ext.ux.ComboBox({
		fieldLabel:(Ext.getCmp('BillNotActive').getValue()==true?'�ӷ���':'<font color=red>�ӷ���</font>'),
		id : 'SubTypeFee',
		name : 'SubTypeFee',
		store : TarSubCateStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'Desc'
	});


//סԺ�ӷ���
var InSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel:(Ext.getCmp('BillNotActive').getValue()==true?'סԺ�ӷ���':'<font color=red>סԺ�ӷ���</font>'),
		id : 'InSubTypeFee',
		name : 'InSubTypeFee',
		store : TarInpatCateStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'Desc'
	});

//�����ӷ���		
var OutSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel :(Ext.getCmp('BillNotActive').getValue()==true?'�����ӷ���':'<font color=red>�����ӷ���</font>') ,
		id : 'OutSubTypeFee',
		name : 'OutSubTypeFee',
		store : TarOutpatCateStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName : 'Desc'
	});

//�����ӷ���
var AccSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel :(Ext.getCmp('BillNotActive').getValue()==true?'�����ӷ���':'<font color=red>�����ӷ���</font>'),
		id : 'AccSubTypeFee',
		name : 'AccSubTypeFee',
		store : TarEMCCateStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName : 'Desc'
	});

//������ҳ����
var MedSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel :(Ext.getCmp('BillNotActive').getValue()==true?'������ҳ����':'<font color=red>������ҳ����</font>'),
		id : 'MedSubTypeFee',
		name : 'MedSubTypeFee',
		store : TarMRCateStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName : 'Desc'
	});

//����ӷ���
var AccountSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel :(Ext.getCmp('BillNotActive').getValue()==true?'����ӷ���':'<font color=red>����ӷ���</font>'),
		id : 'AccountSubTypeFee',
		name : 'AccountSubTypeFee',
		store : TarAcctCateStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName : 'Desc'
	});

//�²�����ҳ
var NewMedSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel :(Ext.getCmp('BillNotActive').getValue()==true?'�²�����ҳ':'<font color=red>�²�����ҳ</font>'),
		id : 'NewMedSubTypeFee',
		name : 'NewMedSubTypeFee',
		store : TarNewMRCateStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName : 'Desc'
	});
	
var MedProMaintain = new Ext.form.Checkbox({
		fieldLabel : 'ά��ҽ����',
		id : 'MedProMaintain',
		name : 'MedProMaintain',
		anchor : '90%',
		checked : false,
		hidden:true
	});

// ҽ����Panel
var ItmMastPanel = new Ext.form.FormPanel({
		labelWidth : 100,
		labelAlign : 'right',
		autoScroll:true,
		frame : true,
		items : [{
					layout : 'column',
					xtype:'fieldset',
					style : DHCSTFormStyle.FrmPaddingV,
					defaults:{border:false},
					items : [{
								columnWidth : .2,
								xtype:'fieldset',
								items : [dispuomButton]
							}, {
								columnWidth : .2,
								xtype:'fieldset',
								items : [RestrictDocButton]
							}]
				},{
					layout : 'column',
					xtype:'fieldset',
					style : DHCSTFormStyle.FrmPaddingV,
					defaults:{border:false},
					items : [{
								columnWidth : 0.5,
								xtype:'fieldset',
								items : [ARCIMCode,ARCIMEffDate,ARCIMUomDR,ARCIMMaxQty,ARCIMEffDateTo,OrderCategory,
								ARCIMMaxQtyPerDay,ARCIMAbbrev,ARCIMNoOfCumDays,BillCode]
							},{
								columnWidth : 0.5,
								xtype:'fieldset',
								items : [ARCIMDesc,ARCBillGrp,ARCBillSub,OECPriority,ARCIMOEMessage,ARCItemCat,
								ARCIMMaxCumDose,ARCIMText1,BillNotActive,BillName]
							}]
				},{
					layout : 'column',
					xtype:'fieldset',
					bodyStyle:'padding:1px 0px 0px 0px',
					defaults:{border:false},
					items : [{
								columnWidth : .5,
								xtype:'fieldset',
								items : [ARCAlias]
							}, {
								columnWidth : .1,
								xtype:'fieldset',
								items : [arcAliasButton]
							}]
				},{
					layout : 'column',
					xtype:'fieldset',
					bodyStyle:'padding:1px 0px 0px 0px',
					defaults:{border:false},
					items : [{
								columnWidth : .25,
								xtype:'fieldset',
								items : [ARCIMOrderOnItsOwn,ARCIMRestrictHP]
							}, {
								columnWidth : .25,
								xtype:'fieldset',
								items : [ARCIMRestrictOP,WoStockFlag]
							}, {
								columnWidth : .25,
								xtype:'fieldset',
								items : [ARCIMRestrictEM,MedProMaintain]
							}, {
								columnWidth : .25,
								xtype:'fieldset',
								items : [ARCIMRestrictIP]
							}]
				},{
					xtype : 'fieldset',
					title : '�շ���Ŀ����',
					layout : 'column',
					bodyStyle:'padding:1px 0px 0px 0px',
					defaults:{border:false},
					items : [{
							columnWidth : .34,
							xtype:'fieldset',
							items : [SubTypeFee,OutSubTypeFee,NewMedSubTypeFee]
						}, {
							columnWidth : .33,
							xtype:'fieldset',
							items : [InSubTypeFee,AccSubTypeFee]
						}, {
							columnWidth : .33,
							xtype:'fieldset',
							items : [MedSubTypeFee,AccountSubTypeFee]
						}]
				}]
	});
//============================ҽ����=========================================================================

//============================�����=========================================================================
var INCICode = new Ext.form.TextField({
		fieldLabel : '<font color=red>*����</font>',
		id : 'INCICode',
		name : 'INCICode',
		anchor : '90%',
		disabled:true,
		valueNotFoundText : '',
		listeners:{
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'INCIDesc');			
			}
		}
		});

var INCIDesc = new Ext.form.TextField({
			fieldLabel : '<font color=red>*����</font>',
		id : 'INCIDesc',
		name : 'INCIDesc',
		anchor : '90%',
		disabled:true,
		valueNotFoundText : '',
		listeners:{
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'INFOSpec');			
			}
		}
		});

var INFOSpec = new Ext.form.TextField({
			fieldLabel : '<font color=red>*���</font>',
		id : 'INFOSpec',
		name : 'INFOSpec',
		anchor : '90%',
		valueNotFoundText : '',
		listeners:{
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'INCICTUom');			
			}
		}
	});

var INCICTUom = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*������λ</font>',
		id : 'INCICTUom',
		name : 'INCICTUom',
		store : CTUomStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'CTUomDesc',
		listeners : {
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'PUCTUomPurch');			
			}
		}
});

var PUCTUomPurch = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*��ⵥλ</font>',
		id : 'PUCTUomPurch',
		name : 'PUCTUomPurch',
		store : CONUomStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{UomId:'INCICTUom'},
		listeners : {
			'focus' : function(e) {
				var buom=Ext.getCmp('INCICTUom').getRawValue();
				if(buom=="")
				{
					Msg.info("warning","����¼�����������λ!");					
					return;
				}
			},
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'DHCStkCatGroup');			
			}
			}
		});

var PackUom = new Ext.ux.ComboBox({
		fieldLabel : '���װ��λ',
		id : 'PackUom',
		name : 'PackUom',
		store : CTUomStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'CTUomDesc'
		});
	
var PackUomFac = new Ext.form.NumberField({
		id : 'PackUomFac',
		name : 'PackUomFac',
		anchor : '25%',
		valueNotFoundText : ''
		});
		
var localstore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['REQUIRED', 'Ҫ��'], ['NONREQUIRED', '��Ҫ��'], ['OPTIONAL', '����']]
});

var INCIBatchReq = new Ext.form.ComboBox({
			fieldLabel : '<font color=red>*����</font>',
		id : 'INCIBatchReq',
		name : 'INCIBatchReq',
		store : localstore,
		valueField : 'RowId',
		displayField : 'Description',
		anchor:'90%',
		mode : 'local'
		});
Ext.getCmp("INCIBatchReq").setValue('REQUIRED');
var INCIExpReqnew = new Ext.form.ComboBox({
			fieldLabel : '<font color=red>*��Ч��Ҫ��</font>',
		id : 'INCIExpReqnew',
		name : 'INCIExpReqnew',
		store : localstore,
		valueField : 'RowId',
		displayField : 'Description',
		anchor:'90%',
		mode : 'local'
		});
Ext.getCmp("INCIExpReqnew").setValue('REQUIRED');

var INFOExpireLen = new Ext.form.NumberField({
			fieldLabel : 'Ч�ڳ���(��)',
		id : 'INFOExpireLen',
		name : 'INFOExpireLen',
		anchor : '90%',
			allowNegative : false,
			selectOnFocus : true
		});

var DHCStkCatGroup = new Ext.ux.ComboBox({
			fieldLabel : '<font color=red>*������</font>',
		id : 'DHCStkCatGroup',
		name : 'DHCStkCatGroup',
		store : IncScStkGrpStore,
		valueField : 'RowId',
		displayField : 'Description'
});

var TransferStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['TRANS', 'Transfer Only'],
				['ISSUE', 'Issue Only'],
				['BOTH', 'Both Issue & Transfer']]
		});
var INCIIsTrfFlag = new Ext.form.ComboBox({
			fieldLabel : '<font color=red>*ת�Ʒ�ʽ</font>',
		id : 'INCIIsTrfFlag',
		name : 'INCIIsTrfFlag',
		store : TransferStore,
		valueField : 'RowId',
		displayField : 'Description',
		anchor:'90%',
		mode : 'local'
		});
Ext.getCmp('INCIIsTrfFlag').setValue('TRANS');

var INCIBarCode = new Ext.form.TextField({
			fieldLabel : '����',
		id : 'INCIBarCode',
		name : 'INCIBarCode',
		anchor : '90%',
		valueNotFoundText : ''
		});

var INCAlias = new Ext.form.TextField({
			fieldLabel : '����',
		id : 'INCAlias',
		name : 'INCAlias',
		width : 380,
		anchor : '90%',
		emptyText:'�������֮����/�ָ�',
		disabled:true,
		valueNotFoundText : ''
		});

var incAliasButton = new Ext.Button({
			id:'IncAliasButton',
		text : '����',
		width : 15,
		handler : function() {
			//var IncRowid = Ext.getCmp("InciRowid").getValue();
			if(drugRowid!=""){
				IncAliasEdit("", drugRowid);	
			}else{
				Msg.info("warning","��ѡ����Ҫά�������Ŀ���");
				return;
			}					
		}
});
var incApprovalButton = new Ext.Button({
			id:'incApprovalButton',
		text : 'ά��',
		width : 15,
		//disabled:true,
		handler : function() {
			var drugdesc=Ext.getCmp("INCIDesc").getValue();
			IncApprovalEdit(drugRowid,drugdesc,RegetincApproval);				
		
		}
});
///ά����׼�ĺź���½���ֵ
function RegetincApproval(drugrowid)
{
	var remarkstr=tkMakeServerCall("web.DHCST.Common.DrugInfoCommon","GetInciRemark",drugrowid)
	if (remarkstr!="")
	{
		var tmpremark=remarkstr.split("-")
		addComboData(INFORemarkStore,tmpremark[0],tmpremark[0])
		Ext.getCmp("INFORemark1").setValue(tmpremark[0]);		
		Ext.getCmp("INFORemark2").setValue(tmpremark[1]);		
	}
}

var INFOPBLevel = new Ext.ux.ComboBox({
			fieldLabel : '�б꼶��',
		id : 'INFOPBLevel',
		name : 'INFOPBLevel',
		store : INFOPBLevelStore,
		valueField : 'RowId',
		displayField : 'Description'
		});
BookCatStore.load();
var INFOBCDr = new Ext.ux.ComboBox({
		fieldLabel : '�ʱ�����',
		id : 'INFOBCDr',
		name : 'INFOBCDr',
		store : BookCatStore,
		valueField : 'RowId',
		displayField : 'Description'
});

var INCIBRpPuruom = new Ext.form.NumberField({
		fieldLabel : '������',
		id : 'INCIBRpPuruom',
		name : 'INCIBRpPuruom',
		anchor : '90%',
		allowNegative : false,
		selectOnFocus : true,
		disabled:true,
		listeners : {
			'focus' : function(e) {
				ChangePriceDecimal();
			}
		}

		});
//(gParamCommon[7]=='3'?true:false)
var INCIBSpPuruom = new Ext.form.NumberField({
		fieldLabel : '���ۼ�',
		id : 'INCIBSpPuruom',
		name : 'INCIBSpPuruom',
		disabled:(gParamCommon[7]=='3'?true:false),
		anchor : '90%',
		allowNegative : false,
		selectOnFocus : true,
		listeners : {
			'focus' : function(e) {
				ChangePriceDecimal();
			}
		}
		});
function ChangePriceDecimal()
{
	  var baseuomdr=Ext.getCmp('INCICTUom').getValue();
	  var purchuomdr=Ext.getCmp('PUCTUomPurch').getValue();
	  var decimalstr=tkMakeServerCall("web.DHCST.Common.AppCommon","GetDecimalCommon",gGroupId,gLocId,userId,"",purchuomdr,baseuomdr);
	  var decimalarr=decimalstr.split("^");
	  Ext.getCmp("INCIBRpPuruom").decimalPrecision=decimalarr[0];
	  Ext.getCmp("INFOPbRp").decimalPrecision=decimalarr[0];
	  Ext.getCmp("INCIBSpPuruom").decimalPrecision=decimalarr[2];
	  Ext.getCmp("INFOMaxSp").decimalPrecision=decimalarr[2];	  
	  
}
var PreExeDate = new Ext.ux.DateField({
			fieldLabel : '�۸���Ч����',
		id : 'PreExeDate',
		name : 'PreExeDate',
		anchor : '90%',
		value : ''
		});

var INFOPrcFile = new Ext.form.TextField({
			fieldLabel : '����ļ���',
		id : 'INFOPrcFile',
		name : 'INFOPrcFile',
		anchor : '90%',
		valueNotFoundText : ''
		});

var INFOSkinTest = new Ext.form.Checkbox({
			fieldLabel : 'Ƥ�Ա�־',
		id : 'INFOSkinTest',
		name : 'INFOSkinTest',
		anchor : '90%',
		width : 30 ,  // add by myq 20150910 
		checked : false
		});

var INCINotUseFlag = new Ext.form.Checkbox({
			fieldLabel : '������',
		id : 'INCINotUseFlag',
		name : 'INCINotUseFlag',
		anchor : '90%',	
		width : 30 ,	
		checked : false
		});

var ItmNotUseReason = new Ext.ux.ComboBox({
		id : 'ItmNotUseReason',
		name : 'ItmNotUseReason',
		store : ItmNotUseReasonStore,
		valueField : 'RowId',
		width : 100 ,
		displayField : 'Description'
});
		
var packButton = new Ext.Button({
			text : '���װά��',
			height : 30,
			handler : function() {
			}
		});
var incBatButton = new Ext.Button({
			id:'IncBatButton',
		text : '��������ά��',
		width : 30,
		handler : function() {
			var gridSelected =Ext.getCmp("DrugInfoGrid"); 
			var rows=gridSelected.getSelectionModel().getSelections();
			var row = rows[0];
			var record = gridSelected.getStore().getById(row.id);
			var InciRowid = record.get("InciRowid");
 			IncBatSearch(InciRowid);		
		}
});

var InciRowid = new Ext.form.TextField({
	fieldLabel : 'InciRowid',
id : 'InciRowid',
name : 'InciRowid',
anchor : '90%',
width : 100,
hidden:true,
valueNotFoundText : ''
});

var ImportStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
		data : [['����', '����'], ['����', '����'], ['����', '����']]
		});
var INFOImportFlag = new Ext.form.ComboBox({
		fieldLabel : '���ڱ�־',
		id : 'INFOImportFlag',
		name : 'INFOImportFlag',
		store : ImportStore,
		valueField : 'RowId',
		displayField : 'Description',
		anchor:'90%',
		mode : 'local'
});

INFOOTCStore.load();
var INFOOTC = new Ext.ux.ComboBox({
			fieldLabel : '����ҩ����',
		id : 'INFOOTC',
		name : 'INFOOTC',
		store : INFOOTCStore,
		valueField : 'RowId',
		displayField : 'Description'
		});

var INFOQualityNo = new Ext.form.TextField({
			fieldLabel : '�ʱ���',
		id : 'INFOQualityNo',
		name : 'INFOQualityNo',
		anchor : '90%',
		width : 180,
		valueNotFoundText : ''
		});
		
MarkTypeStore.load();
var INFOMT = new Ext.ux.ComboBox({
			fieldLabel : '��������',
		id : 'INFOMT',
		name : 'INFOMT',
		store : MarkTypeStore,
		valueField : 'RowId',
		displayField : 'Description'
		});

var INFOMaxSp = new Ext.form.NumberField({
		fieldLabel : '����ۼ�',
		id : 'INFOMaxSp',
		name : 'INFOMaxSp',
		anchor : '90%',
		width : 180,
		allowNegative : false,
		selectOnFocus : true,
		listeners : {
			'focus' : function(e) {
				ChangePriceDecimal();
			}
		}
		});

INFORemarkStore.load();
var INFORemark1 = new Ext.ux.ComboBox({
			fieldLabel : '��׼�ĺ�',
		id : 'INFORemark1',
		name : 'INFORemark1',
		anchor : '90%',
		store : INFORemarkStore,
		valueField : 'RowId',
		displayField : 'Description'//,
		//disabled:false
		});
var INFORemark2 = new Ext.form.TextField({
			id : 'INFORemark2',
		name : 'INFORemark2',
		anchor : '90%',
		width : 300,
		valueNotFoundText : ''//,
		//disabled:false
		});

var INFOComFrom = new Ext.form.TextField({
			fieldLabel : '��(ʡ)��',
		id : 'INFOComFrom',
		name : 'INFOComFrom',
		anchor : '90%',
		width : 180,
		valueNotFoundText : ''
		});
INFOQualityLevelStore.load();
var INFOQualityLevel = new Ext.ux.ComboBox({
			fieldLabel : '�������',
		id : 'INFOQualityLevel',
		name : 'INFOQualityLevel',
		anchor : '90%',
		store : INFOQualityLevelStore,
		valueField : 'RowId',
		displayField : 'Description'
	});

var INCIReportingDays = new Ext.form.TextField({
			fieldLabel : 'Э����',
		id : 'INCIReportingDays',
		name : 'INCIReportingDays',
		anchor : '90%',
		width : 180,
		valueNotFoundText : ''
		});


PublicBiddingListStore.load();
var INFOPBLDR = new Ext.ux.ComboBox({
		fieldLabel : '�б�����',
		id : 'INFOPBLDR',
		name : 'INFOPBLDR',
		anchor : '90%',
		store : PublicBiddingListStore,
		valueField : 'RowId',
		displayField : 'Description'
});

var INFOPbVendor = new Ext.ux.VendorComboBox({
		fieldLabel : '�б깩����',
		id : 'INFOPbVendor',
		name : 'INFOPbVendor'
});
		
var INFOPbManf = new Ext.ux.ComboBox({
		fieldLabel : '�б�������',
		id : 'INFOPbManf',
		name : 'INFOPbManf',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName'
});
		
var INFOPbCarrier = new Ext.ux.ComboBox({
		fieldLabel : '�б�������',
		id : 'INFOPbCarrier',
		name : 'INFOPbCarrier',
		store : CarrierStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'CADesc'
});
		
var INFOPbRp = new Ext.form.NumberField({
			fieldLabel : '�б����',
			id : 'INFOPbRp',
			name : 'INFOPbRp',
			anchor : '90%',
			width : 180,
			allowNegative : false,
			selectOnFocus : true,
			listeners : {
				'focus' : function(e) {
					ChangePriceDecimal();
				}
			}
		});

var UserOrderInfo = new Ext.form.TextField({
			fieldLabel : '��ҩ˵��',
		id : 'UserOrderInfo',
		name : 'UserOrderInfo',
		anchor : '90%',
		width : 180,
		valueNotFoundText : ''
		});

var INFOPbFlag = new Ext.form.Checkbox({
			fieldLabel : '�Ƿ��б�',
		id : 'INFOPbFlag',
		name : 'INFOPbFlag',
		anchor : '90%',
			width : 30,
			height : 10,
			checked : false
		});

var INFOBAflag = new Ext.form.Checkbox({
			fieldLabel : '����ɹ�',
		id : 'INFOBAflag',
		name : 'INFOBAflag',
		anchor : '90%',
			width : 30,
			height : 10,
			checked : false
		});
		
var INFOBAflag = new Ext.form.Checkbox({
			fieldLabel : '����ɹ�',
		id : 'INFOBAflag',
		name : 'INFOBAflag',
		anchor : '90%',
			width : 30,
			height : 10,
			checked : false
		});
		
var INFOTest = new Ext.form.Checkbox({
			fieldLabel : '�ٴ���֤��ҩ',
		id : 'INFOTest',
		name : 'INFOTest',
		anchor : '90%',
			width : 30,
			height : 10,
			checked : false
		});
		
var INFOREC = new Ext.form.Checkbox({
			fieldLabel : '������ҩ��־',
		id : 'INFOREC',
		name : 'INFOREC',
		anchor : '90%',
			width : 30,
			height : 10,
			checked : false
		});
		
var INFOBasicDrug = new Ext.form.Checkbox({
			fieldLabel : '����ҩ���־',
		id : 'INFOBasicDrug',
		name : 'INFOBasicDrug',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});
		
var INFOInHosFlag = new Ext.form.Checkbox({
			fieldLabel : '��ԺҩƷĿ¼',
		id : 'INFOInHosFlag',
		name : 'INFOInHosFlag',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});
		
var INFOCodex = new Ext.form.Checkbox({
			fieldLabel : '�й�ҩ���־',
		id : 'INFOCodex',
		name : 'INFOCodex',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});
		
var INFOHighPrice = new Ext.form.Checkbox({
			fieldLabel : '����ҩ��־',
		id : 'INFOHighPrice',
		name : 'INFOHighPrice',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});
		
var INFOBasicDrug2 = new Ext.form.Checkbox({
			fieldLabel : 'ʡ������ҩ��',
		id : 'INFOBasicDrug2',
		name : 'INFOBasicDrug2',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});
		
var INFOProvince1 = new Ext.form.Checkbox({
			fieldLabel : '�м�����ҩ��',
		id : 'INFOProvince1',
		name : 'INFOProvince1',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});
		
var INFOProvince2 = new Ext.form.Checkbox({
			fieldLabel : '��(��)����ҩ��',
		id : 'INFOProvince2',
		name : 'INFOProvince2',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});
		
var INFOPriceBakD = new Ext.ux.DateField({
			fieldLabel : '��۱�������',
		id : 'INFOPriceBakD',
		name : 'INFOPriceBakD',
		anchor : '90%',
		width : 180,
		value : ''
		});

var INFODrugBaseCode = new Ext.form.TextField({
			fieldLabel : 'ҩƷ��λ��',
		id : 'INFODrugBaseCode',
		name : 'INFODrugBaseCode',
		anchor : '90%',
		width : 180,
		minLength : 14,
		valueNotFoundText : ''
		});
		
var InDrugInfo = new Ext.form.TextField({
			fieldLabel : '��ҩ����',
		id : 'InDrugInfo',
		name : 'InDrugInfo',
		anchor : '90%',
		width : 180,
		valueNotFoundText : ''
	});
var HighRiskFlag = new Ext.form.Checkbox({
			fieldLabel : '��ΣҩƷ��־',
		id : 'HighRiskFlag',
		name : 'HighRiskFlag',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});


var ItemPackUom={
	xtype: 'compositefield',								
	items : [
				PackUom,
				{ xtype: 'displayfield', value: '-ϵ��'},
				PackUomFac
			]
}
// �����Panel
var ItmPanel = new Ext.form.FormPanel({
		labelWidth : 100,
		labelAlign : 'right',
		autoScroll:true,
		frame : true,
		defaults:{style:'padding:5px,0px,0px,0px',border:true},
		items : [{
					layout : 'column',
					xtype:'fieldset',
					//bodyStyle : 'padding:1px;',
					defaults:{border:false},
					items : [{
								columnWidth : 0.5,
								xtype:'fieldset',
								items : [INCICode,INFOSpec,PUCTUomPurch,INCIBatchReq,INFOExpireLen,INFOPBLevel,INCIBRpPuruom,PreExeDate,INCIBarCode,
								INFODrugBaseCode,INFOImportFlag,INFOQualityNo,INFOMaxSp,INFOQualityLevel,INFOPBLDR,
								INFOPbManf,INFOPbRp]
							},{
								columnWidth : 0.5,
								xtype:'fieldset',
								items : [INCIDesc,INCICTUom,DHCStkCatGroup,INCIExpReqnew,INCIIsTrfFlag,INFOBCDr,INCIBSpPuruom,INFOPrcFile,INFOPriceBakD,
								InDrugInfo,INFOOTC,INFOMT,INFOComFrom,INCIReportingDays,INFOPbVendor,INFOPbCarrier,
								UserOrderInfo]
							}]
				},{
					xtype:'fieldset',
					style:'padding:5px,0px,0px,0px',
					items:[{
						xtype: 'compositefield',								
						items : [
									PackUom,
									{ xtype: 'displayfield', value: '-ϵ��'},
									PackUomFac
								]
					},{
						xtype:'compositefield',
						items:[INCAlias,incAliasButton]
					
					},{
								xtype : 'compositefield',
								items : [INFORemark1,INFORemark2,incApprovalButton]
					},{
								xtype : 'compositefield',
								items : [INFOISCDR,iscButton]
					},{
								xtype : 'compositefield',
								items : [refRetTF,refRetBT]
					}]
				}, {
					layout : 'column',
					xtype:'fieldset',
					bodyStyle:'padding:1px;',
					defaults:{border:false},
					items : [{
								columnWidth : .25,
								xtype:'fieldset',		
								items : [INFOPbFlag,INFOBasicDrug,INFOBasicDrug2]
							}, {
								columnWidth : .25,
								xtype:'fieldset',
								items : [INFOBAflag,INFOProvince1,INFOProvince2]
							}, {
								columnWidth : .25,
								xtype:'fieldset',
								items : [INFOTest,INFOInHosFlag,INFOHighPrice]
							}, {
								columnWidth : .25,
								xtype:'fieldset',
								items : [INFOREC,INFOCodex]
							}]
				},{
					layout : 'column',
					xtype:'fieldset',
					bodyStyle:'padding:1px;',
					defaults:{border:false}, // false->true ��IE11�汾�²���ʾ�߿�ᵼ�²�����ԭ����ʾ������  modified by myq 20150910
					items : [{
						columnWidth : 0.3,
						xtype:'fieldset',
						labelWidth:50,
						items : [
						{xtype:'compositefield',items:[INCINotUseFlag,ItmNotUseReason]}]
					},{
						columnWidth : 0.5,
						xtype:'fieldset',
						items : [{xtype:'compositefield',items:[INFOSkinTest,SkinTestInfo]}]
					}]				
					}]
	});

//============================�����=========================================================================
	
// ҳǩ
var talPanel = new Ext.TabPanel({
	activeTab : 0,
	deferredRender : true,
	region : 'east',
	width: 800, 
	tbar : [addButton,'-',saveButton,'-',DeleteBT,'-',GetMaxCodeBT,'-',SaveAsBT,'-',CTUomChangeButton],
	items : [{
		layout : 'fit',
		title : 'ҩѧ��',
		items : [PHCDrgFormPanel]
	}, {
		layout : 'fit',
		title : 'ҽ����',
		items : [ItmMastPanel]
	}, {
		layout : 'fit',
		title : '�����',
		items : [ItmPanel]
	}]
});