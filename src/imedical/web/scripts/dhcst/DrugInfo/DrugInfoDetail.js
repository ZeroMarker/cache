//===========================================================================================================
var RowDelim=xRowDelim();
var PHCDFRowid="";
var ArcRowid="";
var storeConRowId="";
var gNewCatId="";
var NeedAudit=""
var rpdecimal=2;
var spdecimal=2;
//根据rowid查询
function GetDetail(rowid){
	var url = 'dhcst.druginfomaintainaction.csp?actiontype=GetDetail&InciRowid=' + rowid;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '查询中...',
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
				Ext.MessageBox.alert("查询错误",jsonData.info);
			}
		},
		scope : this
	});
}
//查询库存项信息,zdm,2011-12-23
function SetIncDetail(listData) {	
	if(listData==null || listData=="")
	{
		return;
	}
	var list=listData.split("^");
	if (list.length > 0) {
		ArcRowid=list[0];
		Ext.getCmp("INCICode").setValue(list[1]); //代码
		Ext.getCmp("INCIDesc").setValue(list[2]); //描述
		addComboData(CTUomStore,list[3],list[4]);
		Ext.getCmp("INCICTUom").setValue(list[3]);  //基本单位
		addComboData(CONUomStore,list[5],list[6]);
		Ext.getCmp("PUCTUomPurch").setValue(list[5]);  //入库单位
		addComboData(IncScStkGrpStore,list[7],list[8]);
		Ext.getCmp("DHCStkCatGroup").setValue(list[7]);  //库存分类
		Ext.getCmp("INCIIsTrfFlag").setValue(list[9]); //转移方式
		Ext.getCmp("INCIBatchReq").setValue(list[10]); //批次
		Ext.getCmp("INCIExpReqnew").setValue(list[11]); //有效期 
		Ext.getCmp("INCAlias").setValue(list[12]); //别名
		Ext.getCmp("INCINotUseFlag").setValue(list[13]=='Y'?true:false); //不可用标志
		Ext.getCmp("INCIReportingDays").setValue(list[14]); //协和码
		Ext.getCmp("INCIBarCode").setValue(list[15]); //条码
		Ext.getCmp("INCIBSpPuruom").setValue(list[18]); //售价
		Ext.getCmp("INCIBRpPuruom").setValue(list[19]); //进价
		Ext.getCmp("PreExeDate").setValue(list[73]);	//价格生效日期
		Ext.getCmp("INFOImportFlag").setValue(list[20]); //进口标志 
		addComboData(INFOQualityLevelStore,list[71],list[21]);
		Ext.getCmp("INFOQualityLevel").setValue(list[71]);
		
		addComboData(INFOOTCStore,list[22],list[22]);
		Ext.getCmp("INFOOTC").setValue(list[22]);
		Ext.getCmp("INFOBasicDrug").setValue(list[23]=='Y'?true:false); //基本药物标志
		Ext.getCmp("INFOCodex").setValue(list[24]=='Y'?true:false); //中国药典标志
		Ext.getCmp("INFOTest").setValue(list[25]=='Y'?true:false); //临床验证用药标志
		Ext.getCmp("INFOREC").setValue(list[26]=='Y'?true:false); //处方购药标志
		Ext.getCmp("INFOQualityNo").setValue(list[27]);
		Ext.getCmp("INFOComFrom").setValue(list[28]);
		var InfoRemark=list[29].split("-")[0];
		addComboData(INFORemarkStore,InfoRemark,InfoRemark)
		Ext.getCmp("INFORemark1").setValue(InfoRemark); //批准文号前段
		Ext.getCmp("INFORemark2").setValue(list[29].split("-")[1]); //批准文号后段
		Ext.getCmp("INFOHighPrice").setValue(list[30]=='Y'?true:false); //高值类标志
		Ext.getCmp("INFOMT").setValue(list[32]); //定价类型id
		Ext.getCmp("INFOMT").setRawValue(list[33]); //定价类型
		Ext.getCmp("INFOMaxSp").setValue(list[34]); //最高售价
		storeConRowId=list[35];//存储条件id
		Ext.getCmp("INFOISCDR").setValue(getStoreConStr(drugRowid));//存储条件
		Ext.getCmp("INFOInHosFlag").setValue(list[36]=='Y'?true:false); //本院药品目录
		Ext.getCmp("INFOPbFlag").setValue(list[37]=='Y'?true:false); //招标标志
		Ext.getCmp("INFOPbRp").setValue(list[38]); //招标进价		
		addComboData(INFOPBLevelStore,list[70],list[39]);
		Ext.getCmp("INFOPBLevel").setValue(list[70]); //招标级别
		addComboData(INFOPbVendor.getStore(),list[40],list[41]);
		Ext.getCmp("INFOPbVendor").setValue(list[40]);
		addComboData(PhManufacturerStore,list[42],list[43]);
		Ext.getCmp("INFOPbManf").setValue(list[42]);
		addComboData(CarrierStore,list[44],list[45]);
		Ext.getCmp("INFOPbCarrier").setValue(list[44]);							
		Ext.getCmp("INFOPBLDR").setValue(list[46]);
		Ext.getCmp("INFOBAflag").setValue(list[48]=='Y'?true:false); //阳光采购标志
		Ext.getCmp("INFOExpireLen").setValue(list[49]);
		Ext.getCmp("INFOPrcFile").setValue(list[50]);
		Ext.getCmp("INFOPriceBakD").setValue(list[51]);    //物价文件日期
		Ext.getCmp("INFOSkinTest").setValue(list[52]=='Y'?true:false); //皮试标志
		Ext.getCmp("INFOBCDr").setValue(list[53]); //帐簿分类id
		Ext.getCmp("INFOBCDr").setRawValue(list[54]); //帐簿分类 
		Ext.getCmp("UserOrderInfo").setValue(list[55]); //用药说明
		Ext.getCmp("INFOBasicDrug2").setValue(list[56]=='1'?true:false); //省级基本药物
		Ext.getCmp("INFOProvince1").setValue(list[57]=='1'?true:false); //市级基本药物
		Ext.getCmp("INFOProvince2").setValue(list[58]=='1'?true:false); //区(县)基本药物
		Ext.getCmp("INFODrugBaseCode").setValue(list[59]); //药品本位码
		Ext.getCmp("InDrugInfo").setValue(list[60]); //进药依据
		Ext.getCmp("INFOSpec").setValue(list[61]); //规格
		addComboData(ItmNotUseReasonStore,list[62],list[63]);
		Ext.getCmp("ItmNotUseReason").setValue(list[62]); //不可用原因
		//Ext.getCmp("HighRiskFlag").setValue(list[66]=='Y'?true:false); //高危标志
		addComboData(CTUomStore,list[67],list[68]);
		Ext.getCmp("PackUom").setValue(list[67]); //大包装单位
		Ext.getCmp("PackUomFac").setValue(list[69]); //大包装单位系数
		Ext.getCmp("refRetTF").setValue(list[72]);
	}
}

//查询药学项信息,zdm,2011-12-23
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
		//Ext.getCmp("").setValue(list[12]);  无库存医嘱
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
		Ext.getCmp("PHCDFOfficialCode1").setValue(list[29]);    //制剂通用名
		Ext.getCmp("PHCDFOfficialCode2").setValue(list[30]);	//原料通用名
		Ext.getCmp("PHCDFDeductPartially").setValue(list[31]=='Y'?true:false);//住院按一天量计算						
		Ext.getCmp("OpOneDay").setValue(list[32]=='1'?true:false); //门诊按一天量计算
		Ext.getCmp("OpSkin").setValue(list[33]=='1'?true:false); //门诊皮试原液
		Ext.getCmp("IpSkin").setValue(list[34]=='1'?true:false); //住院皮试原液
		Ext.getCmp("DDD").setValue(list[35]);		//DDD值	
		Ext.getCmp("EQQty").setValue(list[36]);		//等效数量	
		Ext.getCmp("EQCTUom").setValue(list[37]);		//等效单位
		Ext.getCmp("PHCDFAntibioticFlag").setValue(list[38]=='Y'?true:false); //抗菌药标志
		Ext.getCmp("PHCDFCriticalFlag").setValue(list[39]=='Y'?true:false); //危重药标志
		Ext.getCmp("PHCDFAgeLimit").setValue(list[40]); //年龄限制
		Ext.getCmp("PHCCATALL").setValue(list[41]);  //多级药学分类  add by ct
		gNewCatId=list[42]
		Ext.getCmp("PHCDFWhonetCode").setValue(list[43]); //WHONET码
	    addComboData(PhcSpecIncStore,list[44],list[45]);
		Ext.getCmp("PHCDFPhSpec").setValue(list[44]); //草药备注
		
		//add wyx 2014-12-03
		Ext.getCmp("PHCDFWhoDDD").setValue(list[46]); //WhoDDD值
		addComboData(PHCDFWhoDDDUomStore,list[47],list[48]);//WhoDDDUom
		Ext.getCmp("PHCDFWhoDDDUom").setValue(list[47]); //
		Ext.getCmp("PHCDFIvgttSpeed").setValue(list[49]); //滴速
		Ext.getCmp("PHCDFGranulesFact").setValue(list[50]); //颗粒单位系数
		Ext.getCmp("PHCDFProvinceComm").setValue(list[51]=='Y'?true:false);//省属基本药物
		Ext.getCmp("PHCPoison").setValue(list[52]);		//多项管制分类
		addComboData(PHCPivaCatStore,list[53],list[54]);
		Ext.getCmp("PHCPivaCat").setValue(list[53]);	//药品配液分类
		Ext.getCmp("HighRiskLevel").setValue(list[55]); // 高危级别
		Ext.getCmp("PHCDFSingleUseFlag").setValue(list[56]=='Y'?true:false); // 单味使用标识
		Ext.getCmp("PHCDFAllergyFlag").setValue(list[57]=='Y'?true:false); // 过敏
		Ext.getCmp("PHCDFDietTaboo").setValue(list[58]=='Y'?true:false); // 饮食禁忌
		Ext.getCmp("PHCDFTumbleFlag").setValue(list[59]=='Y'?true:false); // 跌倒风险
		Ext.getCmp("PHCDFDopeFlag").setValue(list[60]=='Y'?true:false); // 兴奋剂
		Ext.getCmp("PHCDFCQZTFlag").setValue(list[69]=='Y'?true:false); // 长期嘱托
		Ext.getCmp("PHCDFONEFlag").setValue(list[70]=='Y'?true:false); // 临时嘱托
	 }
}	

//查询医嘱项信息,zdm,2011-12-23
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
		Ext.getCmp("ARCIMOrderOnItsOwn").setValue(list[10]=='Y'?true:false); //独立医嘱
		addComboData(OECPriorityStore,list[11],list[12]);
		Ext.getCmp("OECPriority").setValue(list[11]);
		Ext.getCmp("WoStockFlag").setValue(list[13]=='Y'?true:false); //无库存医嘱
		Ext.getCmp("ARCIMText1").setValue(list[14]);
		Ext.getCmp("ARCIMAbbrev").setValue(list[15]);
		Ext.getCmp("ARCIMMaxQty").setValue(list[16]);
		Ext.getCmp("ARCIMNoOfCumDays").setValue(list[17]);
		Ext.getCmp("ARCIMMaxQtyPerDay").setValue(list[18]);
		Ext.getCmp("ARCIMMaxCumDose").setValue(list[19]);
		Ext.getCmp("ARCIMRestrictEM").setValue(list[20]=='Y'?true:false); //急诊用药	
		Ext.getCmp("ARCIMRestrictIP").setValue(list[21]=='Y'?true:false); //住院用药						
		Ext.getCmp("ARCIMRestrictOP").setValue(list[22]=='Y'?true:false); //门诊用药
		Ext.getCmp("ARCIMRestrictHP").setValue(list[23]=='Y'?true:false); //体检用药	
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
		//收费项代码
		Ext.getCmp("BillCode").setValue(list[42]);
		//收费项名称
		Ext.getCmp("BillName").setValue(list[43]);
	}
}		
function clearData(){
	//药学项
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
	//医嘱项
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
	//库存项
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

//初始化界面
function InitDetailForm(){
	Ext.Ajax.request({
		url:'dhcst.druginfomaintainaction.csp',
		method:'post',
		params:{actiontype:'GetParamProp'},
		waitMsg:'初始化界面...',
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
					      //wyx add 采用维护弹出界面维护
						Ext.getCmp('INFORemark1').setDisabled(true);
						Ext.getCmp('INFORemark2').setDisabled(true);
						incApprovalButton.setDisabled(false);
					
					}else{
						//wyx add 采用界面直接维护
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
	text : '新建',
	tooltip : '点击新建',
	iconCls : 'page_add',
	height:30,
	disabled:false,
	width:70,
	handler : function() {
		var changeInfo="";
	if (drugRowid!="")	{
		if(IsFormChanged(PHCDrgFormPanel)){
			changeInfo=changeInfo+"药学项 ";
		}
		if(IsFormChanged(ItmMastPanel)){
			changeInfo=changeInfo+"医嘱项 ";
		}
		if(IsFormChanged(ItmPanel)){
			changeInfo=changeInfo+"库存项 ";
		}
	}
		if(changeInfo!=""){
			var ss=Ext.Msg.show({
			   title:'提示',
			   msg: changeInfo+'信息已改动，若继续将放弃已做的改动，是否继续？',
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

///新建前初始化界面,liangqiang,2014-01-13
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

// 保存三大项信息,zdm,2011-12-20
function saveData() {
	var listPhc="";
	var listArc="";
	var listInc="";
	var loadMask=ShowLoadMask(document.body,"保存中...");
	if(SaveAsFlag){
		///另存为时,直接取数据不做判断(TabPanel是否激活)
		listPhc=getPhcList();
		if (listPhc==false) {loadMask.hide();return;}
		listArc=getArcList();
		if (listArc==false) {loadMask.hide();return;}
		listInc=getIncList();
		if (listInc==false) {loadMask.hide();return;}
	}else{
		listPhc=getPhcList();
		listArc=getArcList();
		if(listArc==false){	//收费项未维护
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
		waitMsg : '保存中...',
		failure:function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
		},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			loadMask.hide();
			if (jsonData.success == 'true') {
				var InciRowid = jsonData.info;
				//药学项rowid^医嘱项rowid^库存项rowid
				var rowid=InciRowid.split("^")[2]
				CheckManf(rowid);
				var arr = InciRowid.split("^");
				Msg.info("success", "保存成功!");
				var tmpDrugRowId=drugRowid;
				//利用药学项rowid显示三大项明细信息和等效单位
				clearData();
				drugRowid=arr[2];		//为DrugInfoList.js中变量赋值,避免再次保存时报错.注意clearData()中的清除.
				GetDetail(arr[2]);
				//保存成功后下述按钮可用
				Ext.getCmp("IncAliasButton").setDisabled(false);
				Ext.getCmp("ArcAliasButton").setDisabled(false);
				Ext.getCmp("PhcEquivButton").setDisabled(false);
				//设置等效单位
				if(tmpDrugRowId==""){
					DoseEquivEdit("", drugRowid,UpdateEQCTUom);	
				}
				//设置别名
			} else {
				if(jsonData.info==-61){Msg.info("error", "代码为空!");}
				else if(jsonData.info==-62){Msg.info("error", "名称为空!");}
				else if(jsonData.info==-63){Msg.info("error", "剂型为空!");}
				else if(jsonData.info==-64){Msg.info("error", "单位为空!");}
				//else if(jsonData.info==-65){Msg.info("error", "用法为空!");}
				else if(jsonData.info==-51){Msg.info("error", "保存药学项主表失败!");}
				else if(jsonData.info==-62){Msg.info("error", "插入药学项子表失败!");}
				else if(jsonData.info==-66){Msg.info("error", "无效的药学子分类!");}
				else if(jsonData.info==-67){Msg.info("error", "无效的药学小分类!");}
				else if(jsonData.info==-68){Msg.info("error", "无效的管制分类!");}
				else if(jsonData.info==-69){Msg.info("error", "无效的产地!");}
				else if(jsonData.info==-70){Msg.info("error", "无效的通用名!");}
				else if(jsonData.info==-71){Msg.info("error", "无效的剂型!");}
				else if(jsonData.info==-72){Msg.info("error", "无效的频次!");}
				else if(jsonData.info==-73){Msg.info("error", "无效的用法!");}
				else if(jsonData.info==-74){Msg.info("error", "无效的疗程!");}
				else if(jsonData.info==-75){Msg.info("error", "无效的基本单位!");}
				else if(jsonData.info==-76){Msg.info("error", "药学项代码重复!");}
				else if(jsonData.info==-77){Msg.info("error", "药学项名称重复!");}
				else if(jsonData.info==-20){Msg.info("error", "医嘱项代码为空!");}
				else if(jsonData.info==-21){Msg.info("error", "医嘱项名称为空!");}
				else if(jsonData.info==-22){Msg.info("error", "计价单位为空!");}
				else if(jsonData.info==-23){Msg.info("error", "费用大类为空!");}
				else if(jsonData.info==-24){Msg.info("error", "费用子类为空!");}
				else if(jsonData.info==-25){Msg.info("error", "医嘱子类为空!");}
				else if(jsonData.info==-26){Msg.info("error", "药学项id为空!");}
				else if(jsonData.info==-27){Msg.info("error", "无效的医嘱子分类!");}
				else if(jsonData.info==-28){Msg.info("error", "无效的费用大类!");}
				else if(jsonData.info==-29){Msg.info("error", "无效的费用子类!");}
				else if(jsonData.info==-30){Msg.info("error", "无效的药学项!");}
				else if(jsonData.info==-31){Msg.info("error", "无效的计价单位!");}
				else if(jsonData.info==-32){Msg.info("error", "医嘱项代码重复!");}
				else if(jsonData.info==-33){Msg.info("error", "医嘱项名称重复!");}
				else if(jsonData.info==-81){Msg.info("error", "插入医嘱项主表失败!");}
				else if(jsonData.info==-82){Msg.info("error", "插入医嘱项附加表失败!");}
				else if(jsonData.info==-83){Msg.info("error", "插入医嘱项别名失败!");}
				else if(jsonData.info==-16){Msg.info("error", "失败,医嘱项Id不能为空!");}
				else if(jsonData.info==-11){Msg.info("error", "失败,库存项代码不能为空!");}
				else if(jsonData.info==-12){Msg.info("error", "失败,库存项名称不能为空!");}
				else if(jsonData.info==-13){Msg.info("error", "失败,基本单位不能为空!");}
				else if(jsonData.info==-14){Msg.info("error", "失败,入库单位不能为空!");}
				else if(jsonData.info==-15){Msg.info("error", "失败,库存分类为空!");}
				else if(jsonData.info==-17){Msg.info("error", "失败,转移方式不能为空!");}
				else if(jsonData.info==-18){Msg.info("error", "失败,是否要求批次不能为空!");}
				else if(jsonData.info==-19){Msg.info("error", "失败,是否要求效期不能为空!");}
				else if(jsonData.info==-91){Msg.info("error", "插入库存项失败!");}
				else if(jsonData.info==-92){Msg.info("error", "插入库存项附加表失败!");}
				else if(jsonData.info==-93){Msg.info("error", "插入库存项别名失败!");}
				else if(jsonData.info==-94){Msg.info("error", "保存价格失败!");}
				else if(jsonData.info==-1){Msg.info("error", "无效的库存分类!");}
				else if(jsonData.info==-3){Msg.info("error", "无效的医嘱项!");}
				else if(jsonData.info==-4){Msg.info("error", "无效的基本单位!");}
				else if(jsonData.info==-5){Msg.info("error", "无效的入库单位!");}
				else if(jsonData.info==-6){Msg.info("error", "库存项代码已经存在，不能重复!");}
				else if(jsonData.info==-7){Msg.info("error", "库存项名称已经存在，不能重复!");}
				else if(jsonData.info==-8){Msg.info("error", "基本单位和入库单位之间不存在转换关系!");}
				else if(jsonData.info==-78){Msg.info("error", "基本数量应大于0!");}
				else if(jsonData.info==-79){Msg.info("error", "无效的WHONET码，请重新选择!");}
				else if(jsonData.info==-80){Msg.info("error", "此药不是中草药,为无效的草药备注!");}
				else if(jsonData.info==-1001){Msg.info("error", "插入审核日志失败!");}
				else if(jsonData.info==-1002){Msg.info("error", "插入药学项审核日志失败!");}
				else if(jsonData.info==-1003){Msg.info("error", "插入医嘱项审核日志失败!");}
				else if(jsonData.info==-1004){Msg.info("error", "插入库存项审核日志失败!");}
				else if(jsonData.info==-1005){Msg.info("error", "插入审核记录失败!");}
				else if(jsonData.info==-1006){Msg.info("error", "存在未审核记录,请先审核!");}
				else{Msg.info("error", "保存失败:"+jsonData.info);}
			}
		},
		scope : this
	}); 
}

function getIncList(){
	// 库存项数据串:代码^名称^基本单位id^入库单位id^库存分类id^转移方式^是否要求批次^是否要求效期^别名^不可用标志
	// ^协和码^条码^更新人^售价^进价^价格生效日期^规格^进口标志^质量层次^处方药分类
	// ^基本药物标志^中国药典标志^临床验证用药标志^处方购药标志^质量编号^国/省别^批准文号^高值类标志^定价类型id^最高售价
	// ^存储条件^本院药品目录^招标标志^招标进价^招标级别^招标供应商id^招标生产商id^招标配送商id^招标名称^阳光采购标志
	// ^效期长度^物价文件号^物价文件备案时间^皮试标志^帐簿分类id^用药说明^省级基本药物^市级基本药物^区(县)基本药物^药品本位码
	// ^进药依据^大包装单位^大包装单位系数^高危标志^不可用原因^医保类别
	//
	//库存项信息
	var iNCICode = Ext.getCmp("INCICode").getValue();	 //库存代码
	var iNCIDesc = Ext.getCmp("INCIDesc").getValue();	 //库存名称
	var BillUomId = Ext.getCmp("INCICTUom").getValue();	//基本单位		
	var PurUomId=Ext.getCmp("PUCTUomPurch").getValue(); //入库单位
	var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue(); //库存分类id
	var TransFlag=Ext.getCmp("INCIIsTrfFlag").getValue(); //转移方式
	var BatchFlag=Ext.getCmp("INCIBatchReq").getValue(); //批次
	var ExpireFlag=Ext.getCmp("INCIExpReqnew").getValue(); //有效期	
	var AliasStr=Ext.getCmp("INCAlias").getValue(); //别名
	var NotUseFlag=(Ext.getCmp("INCINotUseFlag").getValue()==true?'Y':'N'); //不可用标志
	var XieHeCode=Ext.getCmp("INCIReportingDays").getValue();	//协和码
	var BarCode=Ext.getCmp("INCIBarCode").getValue();//条码	
	var Sp=Ext.getCmp("INCIBSpPuruom").getValue(); //零售价
	var Rp=Ext.getCmp("INCIBRpPuruom").getValue(); //进价
	var PreExeDate=Ext.getCmp("PreExeDate").getValue(); //价格生效日期
	if((PreExeDate!="")&&(PreExeDate!=null)){
		PreExeDate = PreExeDate.format('Y-m-d');
	}
	var Spec=Ext.getCmp("INFOSpec").getValue();//规格
	var INFOImportFlag=Ext.getCmp("INFOImportFlag").getValue(); //进口标志
	var QualityLevel=Ext.getCmp("INFOQualityLevel").getValue(); //质量层次
	var OTC=Ext.getCmp("INFOOTC").getValue(); //处方药分类
	var BasicDrug=(Ext.getCmp("INFOBasicDrug").getValue()==true?'Y':'N');	//基本药物标志
	var CodeX=(Ext.getCmp("INFOCodex").getValue()==true?'Y':'N');	//中国药典标志
	var TestFlag=(Ext.getCmp("INFOTest").getValue()==true?'Y':'N');//临床验证用药标志
	var RecFlag=(Ext.getCmp("INFOREC").getValue()==true?'Y':'N');//处方购药标志
	var QualityNo=Ext.getCmp("INFOQualityNo").getValue();//质标编号
	var ComFrom=Ext.getCmp("INFOComFrom").getValue();//国别/省别
	var Remark1=Ext.getCmp("INFORemark1").getValue();//批准文号前缀
	var Remark2=Ext.getCmp("INFORemark2").getValue();//批准文号
	if(Remark1==""&&Remark2!=""){
		Msg.info("error","批文前缀不能为空");
		return false;
	}
	var Remark=Remark1+"-"+Remark2
	var HighPrice=(Ext.getCmp("INFOHighPrice").getValue()==true?'Y':'N');//药品该字段用作贵重药标志
	var MtDr=Ext.getCmp("INFOMT").getValue();//定价类型
	var MaxSp = Ext.getCmp("INFOMaxSp").getValue();//最高售价
	var StoreConDr=storeConRowId;//存储条件
	var InHosFlag=(Ext.getCmp("INFOInHosFlag").getValue()==true?'Y':'N');//本院药品目录
	var PbFlag=(Ext.getCmp("INFOPbFlag").getValue()==true?'Y':'N');//招标标志	
	var PbRp=Ext.getCmp("INFOPbRp").getValue();//招标进价
	var PbLevel=Ext.getCmp("INFOPBLevel").getValue();//招标级别
	var PbVendorId=Ext.getCmp("INFOPbVendor").getValue();//招标供应商
	var PbManfId=Ext.getCmp("INFOPbManf").getValue();//招标生产商
	var PbCarrier=Ext.getCmp("INFOPbCarrier").getValue();//招标配送商
	var PbBlDr=Ext.getCmp("INFOPBLDR").getValue();//招标名称
	var BaFlag=(Ext.getCmp("INFOBAflag").getValue()==true?'Y':'N');//阳光采购标志
	var ExpireLen=Ext.getCmp("INFOExpireLen").getValue();//效期长度
	var PrcFile=Ext.getCmp("INFOPrcFile").getValue();//物价文件号
	var PrcFileDate=Ext.getCmp("INFOPriceBakD").getValue();//物价文件备案日期
	if((PrcFileDate!="")&&(PrcFileDate!=null)){
		PrcFileDate = PrcFileDate.format('Y-m-d');
	}
	var SkinFlag=(Ext.getCmp("INFOSkinTest").getValue()==true?'Y':'N');//皮试标志
	var BookCatDr=Ext.getCmp("INFOBCDr").getValue();//账簿分类
	var DrugUse=Ext.getCmp("UserOrderInfo").getValue();//用药说明
	var BasicDrug2=(Ext.getCmp("INFOBasicDrug2").getValue()==true?'1':'0');//省级基本药物
	var PBasicDrug=(Ext.getCmp("INFOProvince1").getValue()==true?'1':'0');//市级基本药物
	var PBasicDrug2=(Ext.getCmp("INFOProvince2").getValue()==true?'1':'0');//区(县)基本药物
	var StandCode=Ext.getCmp("INFODrugBaseCode").getValue();//药品本位码
	if((StandCode!="")&&(StandCode.length<14)){
	   Msg.info("error", "药品本位码的最小长度应为14个字符!");
	   return false;				   
	}
	var InMedBasis=Ext.getCmp("InDrugInfo").getValue();//进药依据
	var PackUom=Ext.getCmp("PackUom").getValue();//大包装单位
	var PackUomFac=Ext.getCmp("PackUomFac").getValue();//大包装单位系数
	var HighRiskFlag=""
	//var HighRiskFlag=(Ext.getCmp("HighRiskFlag").getValue()==true?'Y':'N');//高危标志	
	var NotUseReason=Ext.getCmp("ItmNotUseReason").getValue();//不可用原因
	//var InsuType=Ext.getCmp("PHCDOfficialType").getValue(); //医保类别
	var listInc=iNCICode+"^"+iNCIDesc+"^"+BillUomId+"^"+PurUomId+"^"+StkCatId+"^"+TransFlag+"^"+BatchFlag+"^"+ExpireFlag+"^"+AliasStr+"^"+NotUseFlag+"^"+
	XieHeCode+"^"+BarCode+"^"+userId+"^"+Sp+"^"+Rp+"^"+PreExeDate+"^"+Spec+"^"+INFOImportFlag+"^"+QualityLevel+"^"+OTC+"^"+
	BasicDrug+"^"+CodeX+"^"+TestFlag+"^"+RecFlag+"^"+QualityNo+"^"+ComFrom+"^"+Remark+"^"+HighPrice+"^"+MtDr+"^"+MaxSp+"^"+
	StoreConDr+"^"+InHosFlag+"^"+PbFlag+"^"+PbRp+"^"+PbLevel+"^"+PbVendorId+"^"+PbManfId+"^"+PbCarrier+"^"+PbBlDr+"^"+BaFlag+"^"+
	ExpireLen+"^"+PrcFile+"^"+PrcFileDate+"^"+SkinFlag+"^"+BookCatDr+"^"+DrugUse+"^"+BasicDrug2+"^"+PBasicDrug+"^"+PBasicDrug2+"^"+StandCode+"^"+
	InMedBasis+"^"+PackUom+"^"+PackUomFac+"^"+HighRiskFlag+"^"+NotUseReason+"^"+""+"^"+gLocId+"^"+gGroupId;

	return listInc;
}

function getArcList(){
	// 医嘱项数据串:代码^名称^计价单位id^医嘱子类id^费用大类id^费用子类id^独立医嘱标志^默认医嘱优先级id^无库存医嘱标志^医保名称
	// ^别名^缩写^医保类别^最大量^限制使用天数^每天最大剂量^单次最大剂量^急诊用药^住院用药^门诊用药
	// ^体检用药^医嘱提示^不维护收费项目^是否维护医保项目^子分类^住院子分类^门诊子分类^核算子分类^病历首页子分类^会计子分类
	// ^新病案首页^生效日期^截止日期^操作人
	
	//医嘱项信息
	var ARCIMCode = Ext.getCmp("ARCIMCode").getValue(); //代码
	var ARCIMDesc = Ext.getCmp("ARCIMDesc").getValue(); //名称
	var BillUomId = Ext.getCmp("ARCIMUomDR").getValue(); //计价单位
	var ItmCatId=Ext.getCmp("ARCItemCat").getValue(); //医嘱子类
	//if(ItmCatId==""){Msg.info("error", "医嘱子类不能为空!");return false;}
	var BillGrpId=Ext.getCmp("ARCBillGrp").getValue(); //费用大类
	var BillSubId=Ext.getCmp("ARCBillSub").getValue(); //费用子类
	var OwnFlag=(Ext.getCmp("ARCIMOrderOnItsOwn").getValue()==true?'Y':'N'); //独立医嘱
	var PriorId=Ext.getCmp("OECPriority").getValue();	 //医嘱优先级	
	var WoStockFlag=(Ext.getCmp("WoStockFlag").getValue()==true?'Y':'N');    //无库存医嘱
	var InsuDesc=Ext.getCmp("ARCIMText1").getValue();	 //医保名称
	var AliasStr=Ext.getCmp("ARCAlias").getValue(); //别名
	var SX=Ext.getCmp("ARCIMAbbrev").getValue();	//缩写
	//var InsuType=Ext.getCmp("PHCDOfficialType").getValue();//医保类别
	var MaxQty=Ext.getCmp("ARCIMMaxQty").getValue(); //最大量
	var NoCumOfDays=Ext.getCmp("ARCIMNoOfCumDays").getValue();	//限制使用天数	
	var MaxQtyPerDay = Ext.getCmp("ARCIMMaxQtyPerDay").getValue(); //每天最大剂量
	var MaxCumDose=Ext.getCmp("ARCIMMaxCumDose").getValue(); //单次最大剂量
	var RestrictEM=(Ext.getCmp("ARCIMRestrictEM").getValue()==true?'Y':'N');//急诊用药			
	var RestrictIP=(Ext.getCmp("ARCIMRestrictIP").getValue()==true?'Y':'N');//住院用药		
	var RestrictOP=(Ext.getCmp("ARCIMRestrictOP").getValue()==true?'Y':'N');//门诊用药
	var RestrictHP=(Ext.getCmp("ARCIMRestrictHP").getValue()==true?'Y':'N');//体检用药				
	var OeMessage=Ext.getCmp("ARCIMOEMessage").getValue();//医嘱提示			
	var UpdTarFlag=(Ext.getCmp("BillNotActive").getValue()==true?'Y':'N');//不维护收费项
	var subTypeFee="";//子分类
	var inSubTypeFee="";//住院子分类
	var outSubTypeFee="";//门诊子分类
	var accSubTypeFee="";//核算子分类
	var medSubTypeFee="";//病历首页子分类
	var accountSubTypeFee="";//会计子分类
	var NewMedSubTypeFee="";//新病案首页
	if(UpdTarFlag=="N"){
		//维护收费项目分类
		var subTypeFee=Ext.getCmp("SubTypeFee").getValue();
		if(subTypeFee==""){Msg.info("error", "子分类为空!");return false;}
		var inSubTypeFee=Ext.getCmp("InSubTypeFee").getValue();
		if(inSubTypeFee==""){Msg.info("error", "住院子分类为空!");return false;}
		var outSubTypeFee=Ext.getCmp("OutSubTypeFee").getValue();
		if(outSubTypeFee==""){Msg.info("error", "门诊子分类为空!");return false;}
		var accSubTypeFee=Ext.getCmp("AccSubTypeFee").getValue();
		if(accSubTypeFee==""){Msg.info("error", "核算子分类为空!");return false;}
		var medSubTypeFee=Ext.getCmp("MedSubTypeFee").getValue();
		if(medSubTypeFee==""){Msg.info("error", "病历首页子分类为空!");return false;}
		var accountSubTypeFee=Ext.getCmp("AccountSubTypeFee").getValue();
		if(accountSubTypeFee==""){Msg.info("error", "会计子分类为空!");return false;}
		
		var NewMedSubTypeFee=Ext.getCmp("NewMedSubTypeFee").getValue();
		if(NewMedSubTypeFee==""){Msg.info("error", "新病案首页为空!");return false;}
	}
	var medProMaintain=(Ext.getCmp("MedProMaintain").getValue()==true?'Y':'N');//维护医保项
	var ARCIMEffDate=Ext.getCmp("ARCIMEffDate").getValue();//生效日期
	if((ARCIMEffDate!="")&&(ARCIMEffDate!=null)){
		ARCIMEffDate = ARCIMEffDate.format('Y-m-d');
	}
	var ARCIMEffDateTo=Ext.getCmp("ARCIMEffDateTo").getValue();//截止日期
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
	// 药学项数据串:代码^描述^剂型id^基本单位id^用法id^疗程id^基本数量^产地id^管制分类id^频次id^
	// 医保类别^处方通用名^药学分类id^药学子类id^药学小类id^英文国际非专利药名^国际专利药名^商品名^制剂通用名^原料通用名^
	// 住院按一天量计算^门诊按一天量计算^门诊皮试用原液^住院皮试用原液^DDD值^操作人^抗菌药标志^危重药标志^年龄限制
	
	//药学项信息
	var PhcCode = Ext.getCmp("PHCCCode").getValue();  //代码
	var PhcDesc=Ext.getCmp("PHCCDesc").getValue(); //名称
	var FormId=Ext.getCmp("PHCForm").getValue(); //剂型
	var BuomId=Ext.getCmp("PHCDFCTUom").getValue(); //基本单位
	var InstId=Ext.getCmp("PHCDFPhCin").getValue(); //用法
	var DuraId=Ext.getCmp("PHCDuration").getValue(); //疗程
	var BQty=Ext.getCmp("PHCDFBaseQty").getValue(); //基本数量
	var ManfId=Ext.getCmp("PhManufacturer").getValue(); //厂商
	var PosionId=Ext.getCmp("PHCDFPhcDoDR").getValue(); //管制分类
	var FreqId=Ext.getCmp("PHCFreq").getValue(); //频次
	var InsuType="" //Ext.getCmp("PHCDOfficialType").getValue(); //医保类别
	var GenericId=Ext.getCmp("PHCGeneric").getValue(); //处方通用名
	var PhcCatId=Ext.getCmp("PHCCat").getValue(); //药学分类
	var PhcSubCatId = Ext.getCmp("PHCSubCat").getValue(); //药学子类
	var PhcMinCatId=Ext.getCmp("PHCMinCat").getValue(); //药学小类
	var LabelName11=Ext.getCmp("PHCDLabelName11").getValue();			//英文国际非专利药名
	var LabelName12=Ext.getCmp("PHCDLabelName12").getValue();   	//国际专利药名
	var GoodName=Ext.getCmp("PHCDLabelName1").getValue(); //商品名
	var FregenName=Ext.getCmp("PHCDFOfficialCode1").getValue();		//制剂通用名
	var FregenName2=Ext.getCmp("PHCDFOfficialCode2").getValue();	//原料通用名
	var partially=(Ext.getCmp("PHCDFDeductPartially").getValue()==true?'Y':'N'); //住院按一天量计算
	
	var OpOneDay=(Ext.getCmp("OpOneDay").getValue()==true?'1':'0'); //门诊按一天量计算
	var OpSkin=(Ext.getCmp("OpSkin").getValue()==true?'1':'0'); //门诊皮试用原液
	var IpSkin=(Ext.getCmp("IpSkin").getValue()==true?'1':'0'); //住院皮试用原液
	var DDD=Ext.getCmp("DDD").getValue(); //DDD值
	var PHCDFAntibioticFlag=(Ext.getCmp("PHCDFAntibioticFlag").getValue()==true?'Y':'N'); //抗菌药标志
	var PHCDFCriticalFlag=(Ext.getCmp("PHCDFCriticalFlag").getValue()==true?'Y':'N'); //危重药标志
	var PHCDFAgeLimit=Ext.getCmp("PHCDFAgeLimit").getValue(); //年龄限制
	var PHCDFWhonetCode=Ext.getCmp("PHCDFWhonetCode").getValue(); //WHONET码
	var PHCDFPhSpec=Ext.getCmp("PHCDFPhSpec").getValue(); //草药备注
	//add wyx 2014-12-03
	
	var WhoDDD=Ext.getCmp("PHCDFWhoDDD").getValue(); //PHCDFWhoDDD值
	var WhoDDDUom=Ext.getCmp("PHCDFWhoDDDUom").getValue(); //PHCDFWhoDDD值单位
	var IvgttSpeed=Ext.getCmp("PHCDFIvgttSpeed").getValue(); //滴速
	var GranulesFact=Ext.getCmp("PHCDFGranulesFact").getValue(); //颗粒单位系数
	var ProvinceComm=(Ext.getCmp("PHCDFProvinceComm").getValue()==true?'Y':'N'); //省属基本药物
	var PHCDFPivaCatDr=Ext.getCmp("PHCPivaCat").getValue(); //药品配液分类
	var HighRiskLevel=Ext.getCmp("HighRiskLevel").getValue(); //高危级别
	var PHCDFSingleUseFlag=(Ext.getCmp("PHCDFSingleUseFlag").getValue()==true?'Y':'N'); //单味使用标识
	var PHCDFAllergyFlag=(Ext.getCmp("PHCDFAllergyFlag").getValue()==true?'Y':'N'); //过敏
	var PHCDFDietTaboo=(Ext.getCmp("PHCDFDietTaboo").getValue()==true?'Y':'N'); //饮食禁忌
	var PHCDFTumbleFlag=(Ext.getCmp("PHCDFTumbleFlag").getValue()==true?'Y':'N'); //跌倒风险
	var PHCDFDopeFlag=(Ext.getCmp("PHCDFDopeFlag").getValue()==true?'Y':'N'); //兴奋剂
	var PHCDFCQZTFlag=(Ext.getCmp("PHCDFCQZTFlag").getValue()==true?'Y':'N'); //长期嘱托
	var PHCDFONEFlag=(Ext.getCmp("PHCDFONEFlag").getValue()==true?'Y':'N'); //临时嘱托
	var listPhc=PhcCode+"^"+PhcDesc+"^"+FormId+"^"+BuomId+"^"+InstId+"^"+DuraId+"^"+BQty+"^"+ManfId+"^"+PosionId+"^"+FreqId+"^"+
	InsuType+"^"+GenericId+"^"+PhcCatId+"^"+PhcSubCatId+"^"+PhcMinCatId+"^"+LabelName11+"^"+LabelName12+"^"+GoodName+"^"+FregenName+"^"+FregenName2+"^"+
	partially+"^"+OpOneDay+"^"+OpSkin+"^"+IpSkin+"^"+DDD+"^"+userId+"^"+PHCDFAntibioticFlag+"^"+PHCDFCriticalFlag+"^"+PHCDFAgeLimit+"^"+gNewCatId+"^"+PHCDFWhonetCode+"^"+PHCDFPhSpec+"^"+
	WhoDDD+"^"+WhoDDDUom+"^"+IvgttSpeed+"^"+GranulesFact+"^"+ProvinceComm+"^"+PHCDFPivaCatDr+"^"+HighRiskLevel+"^"+PHCDFSingleUseFlag+"^"+PHCDFAllergyFlag+"^"+
	PHCDFDietTaboo+"^"+PHCDFTumbleFlag+"^"+PHCDFDopeFlag+"^"+
	"^^^^^^^^"+
	PHCDFCQZTFlag+"^"+PHCDFONEFlag;
	return listPhc;
	
}

//检测该药品是否已经在用，从而决定是否允许修改价格和基本单位
function CheckItmUsed(rowid){
	var url = 'dhcst.druginfomaintainaction.csp?actiontype=CheckItmUsed&IncRowid=' + rowid;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '查询中...',
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


//检测该药品厂商信息
function CheckManf(rowid){
	var url = 'dhcst.druginfomaintainaction.csp?actiontype=CheckManf&IncRowid=' + rowid;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var ret = result.responseText;
			var jsonData = Ext.util.JSON.decode(ret);
			if (jsonData.success == 'true') {
			   	if(jsonData.info==-999){Msg.info("warning", "药物生产许可有效期已经过期!");return;}
				else if(jsonData.info==-998){Msg.info("warning", "材料生产许可有效期已经过期!");return;}
				else if(jsonData.info==-997){Msg.info("warning", "工商执照许可有效期已经过期!");return;}
			}
			else{
			}
		},
        scope : this
	});
}

var saveButton = new Ext.Button({
		text : '保存',
		tooltip : '点击保存',
		height:30,
		width:70,
		iconCls : 'page_save',
		handler : function() {
				if(drugRowid==""){
					//Msg.info("warning","库存项ID为空,刷新重试!");
					//return;
				}
				if((IsFormChanged(ItmPanel)||IsFormChanged(ItmMastPanel)||IsFormChanged(PHCDrgFormPanel))==false){
					Msg.info("warning","药品信息数据未发生改变!");
					return;
				}
				// 判断代码和名称是否为空
				var PhcCode = Ext.getCmp("PHCCCode").getValue();
				if (PhcCode == null || PhcCode=="") {
					Msg.info("warning","药品代码不能为空!");					
					return;
				}
				var PhcDesc = Ext.getCmp("PHCCDesc").getValue();
				if (PhcDesc == null || PhcDesc =="") {
					Msg.info("warning","药品名称不能为空!");	
					return;
				}
				//剂型不能为空
				var PhcForm = Ext.getCmp("PHCForm").getValue();
				if (PhcForm == null || PhcForm =="") {
					Msg.info("warning","剂型不能为空!");	
					return;
				}
				//基本单位不能为空
				var PhcUom = Ext.getCmp("PHCDFCTUom").getValue();
				if (PhcUom == null || PhcUom =="") {
					Msg.info("warning","基本单位不能为空!");	
					return;
				}
				
				//用法不能为空
				/*var PhcInstru = Ext.getCmp("PHCDFPhCin").getValue();
				if (PhcInstru == null || PhcInstru =="") {
					Msg.info("warning","用法不能为空!");
					return;
				}
				
				//疗程不能为空
				var PhcDura = Ext.getCmp("PHCDuration").getValue();
				if (PhcDura == null || PhcDura =="") {
					Msg.info("warning","疗程不能为空!");
					return;
				}*/
				var AntibioticFlag=Ext.getCmp('PHCDFAntibioticFlag').getValue();
				//管制分类为抗菌药时DDD的值必填
				var PHCDFPhcDoDR=Ext.getCmp('PHCDFPhcDoDR').getRawValue();
				if(PHCDFPhcDoDR.indexOf("抗菌药")!=-1){
					var DDD=Ext.getCmp('DDD').getValue();
					var PHCDFWhonetCode=Ext.getCmp('PHCDFWhonetCode').getValue();
						if(DDD==null||DDD==""){
							Msg.info("warning","管制分类为抗菌药时必须填入DDD的值！");
							return;
						}
						if(AntibioticFlag!=true){
							Msg.info("warning","管制分类为抗菌药时必须维护抗菌药标志！");
							return;
						}
						if(PHCDFWhonetCode==null||PHCDFWhonetCode==""){
							Msg.info("warning","管制分类为抗菌药时必须填入WHONET码值！");
							return;
						};
				}
				//抗菌药勾选时,必须选择管制分类
				if(AntibioticFlag==true){
					if (PHCDFPhcDoDR==""){
						Msg.info("warning","抗菌药必须选择管制分类！");
						return;
					}
					if(PHCDFPhcDoDR.indexOf("抗菌药")<0){
						Msg.info("warning","抗菌药的管制分类必须为抗菌药物的一种！");
						return;
					}
				}
				//计价单位不能为空
				var BillUomDr = Ext.getCmp("ARCIMUomDR").getValue();
				if (BillUomDr == null || BillUomDr =="") {
					Msg.info("warning","计价单位不能为空!");
					return;
				}
				//var PhcSubCatId=Ext.getCmp("PHCSubCat").getValue();
				//if(PhcSubCatId==null || PhcSubCatId==""){
				//	Msg.info("warning","药学项子分类不能为空!");
				//	return;
				//}
				var PhcCatAll=Ext.getCmp("PHCCATALL").getValue();
			     if(PhcCatAll==null || PhcCatAll==""){
					Msg.info("warning","药学分类不能为空!");
					return;
				}
				//医嘱子类不能为空
				var ItemCatId = Ext.getCmp("ARCItemCat").getValue();
				if (ItemCatId == null || ItemCatId =="") {
					Msg.info("warning","医嘱子类不能为空!");
					return;
				}
				
				//费用大类不能为空
				var BillGrpId = Ext.getCmp("ARCBillGrp").getValue();
				if (BillGrpId == null || BillGrpId =="") {
					Msg.info("warning","费用大类不能为空!");
					return;
				}
				
				var BillSubId = Ext.getCmp("ARCBillSub").getValue();
				if (BillSubId == null || BillSubId =="") {
					Msg.info("warning","费用子类不能为空!");
					return;
				}
	
				//库存项基本单位不能为空
				var BuomId = Ext.getCmp("INCICTUom").getValue();
				if (BuomId == null || BuomId =="") {
					Msg.info("warning","库存项基本单位不能为空!");
					return;
				}
				//库存项包装单位不能为空
				var PurUomId = Ext.getCmp("PUCTUomPurch").getValue();
				if (PurUomId == null || PurUomId =="") {
					Msg.info("warning","库存项入库单位不能为空!");
					return;
				}
				//库存项库存分类不能为空
				var StkCatId = Ext.getCmp("DHCStkCatGroup").getValue();
				if (StkCatId == null || StkCatId =="") {
					Msg.info("warning","库存项库存分类不能为空!");
					return;
				}
				//库存项规格不能为空
				var INFOSpec = Ext.getCmp("INFOSpec").getValue();
				if (INFOSpec == null || INFOSpec =="") {
					Msg.info("warning","库存项规格不能为空!");
					return;
				}
				if(PhcUom!=BuomId){
					Msg.info("warning","药学项基本单位须和库存项基本单位一致！");
					return;
				}
				//if((BillUomDr!=BuomId)&(BillUomDr!=PurUomId)){
				//	Msg.info("warning","计价单位必须是库存项基本单位或入库单位！");
				//	return;
				//}
			      var ExistFlag=CheckBillUomDr(BillUomDr,BuomId);
			      if((BillUomDr!=BuomId)&(BillUomDr!=PurUomId)&(ExistFlag==false)){
		              Msg.info("warning","计价单位必须是与基本单位有转换系数的单位！");
		              return;
	                      }
				var PreExeDate=Ext.getCmp("PreExeDate").getValue(); //价格生效日期
				if((PreExeDate!="")&&(PreExeDate!=null)){
					if((PreExeDate<new Date())&(drugRowid=="")){
						Msg.info("warning","价格生效日期不能早于当天!");
						return;
					}
				}

				// 保存三大项信息
				if ((NeedAudit=="2")||(NeedAudit=="1")&&(drugRowid==""))
				{
					Ext.MessageBox.confirm('提示','保存信息后,数据将提交审核,是否继续?',
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
	
	// 删除按钮
	var DeleteBT = new Ext.Toolbar.Button({
				text : '删除',
				tooltip : '点击删除',
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
			Ext.Msg.show({title:'错误',msg:'请选择要删除的药品！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
		else if(rows.length>1){
			Ext.Msg.show({title:'错误',msg:'只允许选择一条记录！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
		else {
			// 选中行
			var row = rows[0];
			var record = gridSelected.getStore().getById(row.id);
			var InciRowid = record.get("InciRowid");
			if (InciRowid == null || InciRowid.length <= 0) {
				gridSelected.getStore().remove(record);
			} else {
				Ext.MessageBox.show({
							title : '提示',
							msg : '是否确定删除该药品信息',
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

			// 删除该行数据
			var url = DictUrl
					+ "druginfomaintainaction.csp?actiontype=DeleteData&InciRowid="
					+ InciRowid;

			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success","删除成功!");
								gridSelected.getStore().remove(record);
								clearData();
							} else {
								var ret=jsonData.info;
								if(ret==-11){
									Msg.info("warning","药品已经在使用，不能删除！");
									return;
								}else{
									Msg.info("error","删除失败:"+ret);
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
				text : '获取最大码',
				tooltip : '获取最大码',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					GetMaxCode(SetMaxCode);
				}
			});
	
	function SetMaxCode(newMaxCode){		
		//clearData(); //获取最大码没必要清空数据
		PHCCCode.setValue(newMaxCode);
		changeflag = changeflag+"C" ;
		PHCCCode.fireEvent('blur');
	}
     //wwl 20160309 皮试关联需求
	var SkinTestInfo = new Ext.Toolbar.Button({
		text : '皮试关联',
		tooltip : '皮试关联',
		width : 50,
		height : 25,
		handler : function() {
			var SkinFlag=Ext.getCmp("INFOSkinTest").getValue()	
			if((ArcRowid!="")&&(SkinFlag==true)){
				SkinTestArc(ArcRowid);	
			}else{
				Msg.info("warning","请选择要维护皮试关联的医嘱项!");
				return;
			}
		}
	});
		// 另存为按钮
	var SaveAsBT = new Ext.Toolbar.Button({
				text : '另存为',
				tooltip : '点击另存为',
				width : 70,
				height : 30,
				iconCls : 'page_save',
                                disabled : true,
				handler : function() {
					SaveAsData();
				}
			});
	/// 另存为
	function SaveAsData()
	{
		if((IsFormChanged(ItmPanel)||IsFormChanged(ItmMastPanel)||IsFormChanged(PHCDrgFormPanel))==false){
			Msg.info("warning","药品信息数据未发生改变!");
			return;
		}
		if(changeflag.indexOf("C")=="-1"){
			Msg.info("warning","药品代码信息未发生变化！");
			return;
		}
		
		if(changeflag.indexOf("D")=="-1"){
			Msg.info("warning","药品名称信息未发生变化！");
			return;
		}
		// 判断代码和名称是否为空
		var PhcCode = Ext.getCmp("PHCCCode").getValue();
		if (PhcCode == null || PhcCode=="") {
			Msg.info("warning","药品代码不能为空!");					
			return;
		}
		var PhcDesc = Ext.getCmp("PHCCDesc").getValue();
		if (PhcDesc == null || PhcDesc =="") {
			Msg.info("warning","药品名称不能为空!");	
			return;
		}
		//剂型不能为空
		var PhcForm = Ext.getCmp("PHCForm").getValue();
		if (PhcForm == null || PhcForm =="") {
			Msg.info("warning","剂型不能为空!");	
			return;
		}
		//基本单位不能为空
		var PhcUom = Ext.getCmp("PHCDFCTUom").getValue();
		if (PhcUom == null || PhcUom =="") {
			Msg.info("warning","基本单位不能为空!");	
			return;
		}
		
		//用法不能为空
		/*var PhcInstru = Ext.getCmp("PHCDFPhCin").getValue();
		if (PhcInstru == null || PhcInstru =="") {
			Msg.info("warning","用法不能为空!");
			return;
		}
		
		//疗程不能为空
		var PhcDura = Ext.getCmp("PHCDuration").getValue();
		if (PhcDura == null || PhcDura =="") {
			Msg.info("warning","疗程不能为空!");
			return;
		}*/
		//管制分类为抗菌药时DDD的值必填
		var PHCDFPhcDoDR=Ext.getCmp('PHCDFPhcDoDR').getRawValue();
		if(PHCDFPhcDoDR.indexOf("抗菌药")!=-1){
			var DDD=Ext.getCmp('DDD').getValue();
			var AntibioticFlag=Ext.getCmp('PHCDFAntibioticFlag').getValue();
			var PHCDFWhonetCode=Ext.getCmp('PHCDFWhonetCode').getValue();
				if(DDD==null||DDD==""){
					Msg.info("warning","管制分类为抗菌药时必须填入DDD的值！");
				return;}
				if(AntibioticFlag!=true){
					Msg.info("warning","管制分类为抗菌药时必须维护抗菌药标志！");
					return;}
				if(PHCDFWhonetCode==null||PHCDFWhonetCode==""){
					Msg.info("warning","管制分类为抗菌药时必须填入WHONET码值！");
				        return;}

				};
		
		//计价单位不能为空
		var BillUomDr = Ext.getCmp("ARCIMUomDR").getValue();
		if (BillUomDr == null || BillUomDr =="") {
			Msg.info("warning","计价单位不能为空!");
			return;
		}
		var PhcCatAll=Ext.getCmp("PHCCATALL").getValue();
	     if(PhcCatAll==null || PhcCatAll==""){
			Msg.info("warning","药学分类不能为空!");
			return;
		}
		//医嘱子类不能为空
		var ItemCatId = Ext.getCmp("ARCItemCat").getValue();
		if (ItemCatId == null || ItemCatId =="") {
			Msg.info("warning","医嘱子类不能为空!");
			return;
		}
		
		//费用大类不能为空
		var BillGrpId = Ext.getCmp("ARCBillGrp").getValue();
		if (BillGrpId == null || BillGrpId =="") {
			Msg.info("warning","费用大类不能为空!");
			return;
		}
		
		var BillSubId = Ext.getCmp("ARCBillSub").getValue();
		if (BillSubId == null || BillSubId =="") {
			Msg.info("warning","费用子类不能为空!");
			return;
		}

		//库存项基本单位不能为空
		var BuomId = Ext.getCmp("INCICTUom").getValue();
		if (BuomId == null || BuomId =="") {
			Msg.info("warning","库存项基本单位不能为空!");
			return;
		}
		//库存项包装单位不能为空
		var PurUomId = Ext.getCmp("PUCTUomPurch").getValue();
		if (PurUomId == null || PurUomId =="") {
			Msg.info("warning","库存项入库单位不能为空!");
			return;
		}
		//库存项库存分类不能为空
		var StkCatId = Ext.getCmp("DHCStkCatGroup").getValue();
		if (StkCatId == null || StkCatId =="") {
			Msg.info("warning","库存项库存分类不能为空!");
			return;
		}
		//库存项规格不能为空
		var INFOSpec = Ext.getCmp("INFOSpec").getValue();
		if (INFOSpec == null || INFOSpec =="") {
			Msg.info("warning","库存项规格不能为空!");
			return;
		}
		if(PhcUom!=BuomId){
			Msg.info("warning","药学项基本单位须和库存项基本单位一致！");
			return;
		}
		/*
		if((BillUomDr!=BuomId)&(BillUomDr!=PurUomId)){
			Msg.info("warning","计价单位必须是库存项基本单位或入库单位！");
			return;
		}
		*/
		var PreExeDate=Ext.getCmp("PreExeDate").getValue(); //价格生效日期
		if((PreExeDate!="")&&(PreExeDate!=null)){
			if(PreExeDate<new Date().format('Y-m-d')){
				Msg.info("warning","价格生效日期不能早于当天!");
				return;
			}
		}

		///库存项ID为空
		drugRowid="";
		Ext.getCmp("InciRowid").setValue("");
		// 另存为三大项信息
		if ((NeedAudit=="2")||(NeedAudit=="1"))
		{
			Ext.MessageBox.confirm('提示','保存信息后,数据将提交审核,是否继续?',
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
			///价格生效日期为空
			PreExeDate.setValue("");
			///设置可编辑
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
//============================药学项=========================================================================

//设置回车光标跳转
function SpecialKeyHandler(e,fieldId){
	var keyCode=e.getKey();
	if(keyCode==e.ENTER){
		Ext.getCmp(fieldId).focus(true);
	}
}

var PHCCCode = new Ext.form.TextField({
	fieldLabel : '<font color=red>*代码</font>',
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
	fieldLabel : '<font color=red>*名称</font>',
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
	fieldLabel : '<font color=red>*分类</font>',
	id : 'PHCCat',
	name : 'PHCCat',
	store : PhcCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PhccDesc'	 //根据录入数据过滤下拉内容的参数名称
});

PHCCat.on('change', function(e) {
	Ext.getCmp("PHCSubCat").setValue("");
	Ext.getCmp("PHCMinCat").setValue("");
});

var PHCSubCat = new Ext.ux.ComboBox({
	fieldLabel : '<font color=red>*子分类</font>',
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
	fieldLabel : '更小分类',
	id : 'PHCMinCat',
	name : 'PHCMinCat',
	store : PhcMinCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	params:{PhcSubCatId:'PHCSubCat'}
});

var PHCGeneric = new Ext.ux.ComboBox({
	fieldLabel : '处方通用名',
	id : 'PHCGeneric',
	name : 'PHCGeneric',
	store : PhcGenericStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PhcGeName',
	width:185
});

var PHCForm = new Ext.ux.ComboBox({
	fieldLabel:'<font color=red>*剂型</font>',
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
	fieldLabel : '<font color=red>*基本单位</font>',
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
				//库存项基本单位和药学项的基本单位一致
				Ext.getCmp('INCICTUom').setValue(phcuom);
			}
		},
		'specialkey':function(field,e){
			SpecialKeyHandler(e,'PHCDFPhCin');			
		}
	}
});

var PHCDFBaseQty = new Ext.form.NumberField({
	//fieldLabel : '基本数量',
	fieldLabel : '<font color=red>*基本数量</font>',
	id : 'PHCDFBaseQty',
	name : 'PHCDFBaseQty',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true,
	value:1
});

var PHCDFOfficialCode1 = new Ext.form.TextField({
	fieldLabel : '制剂通用名',
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
	fieldLabel : '用法',
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
	fieldLabel : '等效单位',
	id : 'EQCTUom',
	name : 'EQCTUom',
	width:150,
	readOnly : true,
	valueNotFoundText : ''
});

var eqCTUomButton = new Ext.Button({
	id:'PhcEquivButton',
	text : '等效单位',
	handler : function() {
		//var IncRowid = Ext.getCmp("InciRowid").getValue();
		if(drugRowid!=""){
			DoseEquivEdit("", drugRowid,UpdateEQCTUom);	
		}else
		{
			Msg.info("warning","请选择需要维护等效单位的药学项!");
			return;
		}
	}
});

///修改等小单位关闭窗口后更新界面值,单位以及默认等效数量
function UpdateEQCTUom(item)
{
	var equomstr=tkMakeServerCall("web.DHCST.PHCDRGMAST","GetDefaultDoseEquiv",item)
	if (equomstr!="")
	{
		var tmpequom=equomstr.split("^")
		Ext.getCmp("EQQty").setValue(tmpequom[0]);		//等效数量	
		Ext.getCmp("EQCTUom").setValue(tmpequom[1]);		//等效单位
	}
}
var PHCPoison = new Ext.form.TextField({
	fieldLabel : '管制分类New',
	id : 'PHCPoison',
	name : 'PHCPoison',
	anchor : '90%',
	readOnly : true,
	valueNotFoundText : ''
});

var PHCPoisonButton = new Ext.Button({
	id:'PHCPoisonButton',
	text : '管制分类',
	handler : function() {
		//var IncRowid = Ext.getCmp("InciRowid").getValue();
		if(drugRowid!=""){
			PhcPoisonEdit("", drugRowid);	
		}else
		{
			Msg.info("warning","请选择需要维护管制分类的药学项!");
			return;
		}
	}
});

// 厂商维护
var PhManufacturerButton = new Ext.Button({
	id:'PhManufacturerButton',
	text : '维护',
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
// 通用名维护按钮
var PhcGenericButton = new Ext.Button({
	id:'PhcGenericButton',
	text : '维护',
	handler : function() {
	  var lnk="dhc.bdp.ext.default.csp?extfilename=App/Pharmacy/Phc_generic";
         //location.href=lnk;
         window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
        //PhcGenericMt();
	}
});
//wyx add 2014-02-24 增加基本单位的维护
var PHCDFCTUomButton = new Ext.Button({
	id:'PHCDFCTUomButton',
	text : '基本单位维护',
	handler : function() {
	  var lnk="dhc.bdp.ext.default.csp?extfilename=App/Stock/CT_UOM";
         //location.href=lnk;
         window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
      
	}
});
//wyx add 2014-02-24 增加单位转换的维护
var CTUomChangeButton = new Ext.Button({
	id:'CTUomChangeButton',
	iconCls : 'page_refresh',
	text : '单位转换维护',
	handler : function() {
	  var lnk="dhc.bdp.ext.default.csp?extfilename=App/Stock/CT_ConFac";
         //location.href=lnk;
         window.open(lnk,"_target","height=600,width=800,menubar=no,status=yes,toolbar=no,resizable=yes") ;
      
	}
});
var EQQty = new Ext.form.NumberField({
	fieldLabel : '等效数量',
	id : 'EQQty',
	name : 'EQQty',
	anchor : '90%',
	readOnly : true,
	allowNegative : false,
	selectOnFocus : true,
	decimalPrecision:4
});

var PHCDFOfficialCode2 = new Ext.form.TextField({
	fieldLabel : '原料通用名',
	id : 'PHCDFOfficialCode2',
	name : 'PHCDFOfficialCode2',
	anchor : '90%',
	valueNotFoundText : ''
});

var PHCFreq = new Ext.ux.ComboBox({
	fieldLabel : '频次',
	id : 'PHCFreq',
	name : 'PHCFreq',
	store : PhcFreqStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PhcFrDesc'
});

var PhManufacturer = new Ext.ux.ComboBox({
	fieldLabel : '厂商',
	id : 'PhManufacturer',
	name : 'PhManufacturer',
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName',
	width:185
});

var PHCDuration = new Ext.ux.ComboBox({
	fieldLabel : '疗程',
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
	fieldLabel : '医保类别',
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
	fieldLabel : '管制分类',
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
		if(PHCDFPhcDoDR.indexOf("抗菌药")!=-1){
			var DDD=Ext.getCmp('DDD').getValue();
			if(DDD==null||DDD==""){
				Msg.info("warning","请输入DDD的值和WHONET码！");
				//Msg.info("warning","管制分类为抗菌药时必须填入DDD的值！");
			return;}
			
			Ext.getCmp('DDD').focus();
			Ext.getCmp('PHCDFWhonetCode').focus();
			Ext.getCmp('PHCDFAntibioticFlag').setValue(true);} 
			});
			
var PHCDLabelName11 = new Ext.form.TextField({
	fieldLabel : '英文国际非专利药名',
	id : 'PHCDLabelName11',
	name : 'PHCDLabelName11',
	anchor : '90%',
	valueNotFoundText : ''
});

var PHCDLabelName12 = new Ext.form.TextField({
	fieldLabel : '国际专利药名',
	id : 'PHCDLabelName12',
	name : 'PHCDLabelName12',
	anchor : '90%',
	valueNotFoundText : ''
});

var PHCDLabelName1 = new Ext.form.TextField({
	fieldLabel : '商品名',
	id : 'PHCDLabelName1',
	name : 'PHCDLabelName1',
	anchor : '90%',
	valueNotFoundText : ''
});

var OpSkin = new Ext.form.Checkbox({
	fieldLabel : '门诊皮试用原液',
	id : 'OpSkin',
	name : 'OpSkin',
	anchor : '90%',
	checked : false
});

var IpSkin = new Ext.form.Checkbox({
	fieldLabel : '住院皮试用原液',
	id : 'IpSkin',
	name : 'IpSkin',
	anchor : '90%',
	checked : false
});

var OpOneDay = new Ext.form.Checkbox({
	fieldLabel : '门诊按一天量计算',
	id : 'OpOneDay',
	name : 'OpOneDay',
	anchor : '90%',
	checked : false
});

var PHCDFDeductPartially = new Ext.form.Checkbox({
	fieldLabel : '住院按一天量计算',
	id : 'PHCDFDeductPartially',
	name : 'PHCDFDeductPartially',
	anchor : '90%',
	checked : false
});
//add wyx 2014-12-03
var PHCDFProvinceComm = new Ext.form.Checkbox({
	fieldLabel : '省属常用药物',
	id : 'PHCDFProvinceComm',
	name : 'PHCDFProvinceComm',
	anchor : '90%',
	checked : false
});

var PHCDFAntibioticFlag=new Ext.form.Checkbox({
			fieldLabel:'抗菌药标志',
			id:'PHCDFAntibioticFlag',
			name : 'PHCDFAntibioticFlag',
			anchor : '90%',
			checked : false
			});
			
var PHCDFCriticalFlag=new Ext.form.Checkbox({
			fieldLabel:'危重药标志',
			id:'PHCDFCriticalFlag',
			name : 'PHCDFCriticalFlag',
			anchor : '90%',
			checked : false
			});
		
var DDD = new Ext.form.NumberField({
	fieldLabel : 'DDD值',
	id : 'DDD',
	name : 'DDD',
	anchor : '90%',
	decimalPrecision:5,
	valueNotFoundText : ''
});
//宜宾由于页面加了回车快捷键，故注释listeners hulihua 2014-9-18
var PHCDFWhonetCode = new Ext.form.TextField({
	fieldLabel : 'WHONET码',
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

//add wyx 2014-12-03 WHODDD值
var PHCDFWhoDDD = new Ext.form.NumberField({
	fieldLabel : 'WHODDD值',
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
				Msg.info("warning", "请选择WHODDD单位!");
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
//add wyx 2014-12-03 滴速
var PHCDFIvgttSpeed = new Ext.form.NumberField({
	fieldLabel : '滴速',
	id : 'PHCDFIvgttSpeed',
	name : 'PHCDFIvgttSpeed',
	anchor : '90%',
	decimalPrecision:5,
	valueNotFoundText : ''
});
//add wyx 2014-12-03 颗粒单位系数
var PHCDFGranulesFact = new Ext.form.NumberField({
	fieldLabel : '颗粒单位系数',
	id : 'PHCDFGranulesFact',
	name : 'PHCDFGranulesFact',
	anchor : '90%',
	valueNotFoundText : ''
});
/**
/**
 * 调用WHONET码窗体并返回结果
 */
function GetPhcWhonetInfo(item) {
				
	if (item != null && item.length > 0) {
		WhonetButEdit(item, getWhonetList);
	}
}
//检查计价单位和基本单位之间是否有倍数关系 //add hulihua 2014-12-29 
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
 * 返回方法
*/
function getWhonetList(AntCode) {
	if (AntCode == null || AntCode == "") {
		return;
	}
	Ext.getCmp("PHCDFWhonetCode").setValue(AntCode);
}

var WhonetButton = new Ext.Button({
	id:'WHONETButton',
	text : 'WHONET码',
	handler : function() {
		var inputText = Ext.getCmp("PHCDFWhonetCode").getValue();
		WhonetButEdit(inputText, getWhonetList); 
	}
});

var PHCDFPhSpec = new Ext.ux.ComboBox({
	fieldLabel : '草药备注',
	id : 'PHCDFPhSpec',
	name : 'PHCDFPhSpec',
	mode:'local',
	store : PhcSpecIncStore,
	valueField : 'RowId', 
	displayField : 'Description',
	filterName:'PHCSpecInDesc'
});

var PHCDFAgeLimit = new Ext.form.TextField({
	fieldLabel : '年龄限制',
	id : 'PHCDFAgeLimit',
	name : 'PHCDFAgeLimit',
	anchor : '90%',
	valueNotFoundText : ''
});

var PHCCATALL = new Ext.form.TextField({
	fieldLabel : '<font color=red>*药学分类</font>',
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
// 药学分类
var PHCCATALLButton = new Ext.Button({
	id:'PHCCATALLButton',
	text : '...',
	handler : function() {	
		PhcCatNewSelect(gNewCatId,GetAllCatNew)

    }
});
var PHCPivaCat = new Ext.ux.ComboBox({
	fieldLabel : '药品配液分类',
	id : 'PHCPivaCat',
	name : 'PHCPivaCat',
	store : PHCPivaCatStore,
	valueField : 'RowId',
	displayField : 'Description'
});
var HighRiskLevel = new Ext.form.ComboBox({
	fieldLabel : '高危级别',
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
	fieldLabel:'跌倒风险',
	id:'PHCDFTumbleFlag',
	name : 'PHCDFTumbleFlag',
	anchor : '90%',
	checked : false
});
var PHCDFDopeFlag=new Ext.form.Checkbox({
	fieldLabel:'兴奋剂',
	id:'PHCDFDopeFlag',
	name : 'PHCDFDopeFlag',
	anchor : '90%',
	checked : false
});
var PHCDFDietTaboo=new Ext.form.Checkbox({
	fieldLabel:'饮食禁忌',
	id:'PHCDFDietTaboo',
	name : 'PHCDFDietTaboo',
	anchor : '90%',
	checked : false
});
var PHCDFAllergyFlag=new Ext.form.Checkbox({
	fieldLabel:'过敏',
	id:'PHCDFAllergyFlag',
	name : 'PHCDFAllergyFlag',
	anchor : '90%',
	checked : false
});
var PHCDFSingleUseFlag=new Ext.form.Checkbox({
	fieldLabel:'单味使用标识',
	id:'PHCDFSingleUseFlag',
	name : 'PHCDFSingleUseFlag',
	anchor : '90%',
	checked : false
});
var PHCDFCQZTFlag=new Ext.form.Checkbox({
	fieldLabel:'长期默认嘱托',
	id:'PHCDFCQZTFlag',
	name : 'PHCDFCQZTFlag',
	anchor : '90%',
	checked : false
});
var PHCDFONEFlag=new Ext.form.Checkbox({
	fieldLabel:'临时默认取药',
	id:'PHCDFONEFlag',
	name : 'PHCDFONEFlag',
	anchor : '90%',
	checked : false
});
// 药学项Panel
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
						{xtype:'compositefield',items:[PhManufacturer,PhManufacturerButton]},PHCDuration,PHCDFPhcDoDR,PHCDLabelName12,{xtype:'compositefield',items:[PHCCATALL,PHCCATALLButton]}, //此处原有年龄限制
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
//============================药学项=========================================================================

//============================医嘱项=========================================================================
var ARCIMCode = new Ext.form.TextField({
		fieldLabel : '<font color=red>*代码</font>',
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
			fieldLabel : '<font color=red>*名称</font>',
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
			fieldLabel : '别名',
		id : 'ARCAlias',
		name : 'ARCAlias',
		anchor : '90%',
		//width : 370,
		emptyText:'多个别名之间用/分隔',
		valueNotFoundText : '',
			disabled:true
		});

var arcAliasButton = new Ext.Button({
			id:'ArcAliasButton',
		text : '别名',
		width : 15,
		handler : function() {
			//var IncRowid = Ext.getCmp("InciRowid").getValue();
			if(ArcRowid!=""){
				OrdAliasEdit("", ArcRowid);	
			}else{
				Msg.info("warning","请选择要维护别名的医嘱项!");
				return;
			}	
		}
	});

var ARCIMEffDate = new Ext.ux.DateField({
			fieldLabel : '生效日期',
		id : 'ARCIMEffDate',
		name : 'ARCIMEffDate',
		anchor : '90%',
		value : ''
		});

//-------------zhaozhdiuan  发药单位
var dispuomButton = new Ext.Button({
		id:'DispUomButton',
		text : '发药单位维护',
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
		fieldLabel : '截止日期',
		id : 'ARCIMEffDateTo',
		name : 'ARCIMEffDateTo',
		anchor : '90%',
		value : ''
		});

var ARCBillGrp = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*费用大类</font>',
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
		fieldLabel : '<font color=red>*费用子类</font>',
		id : 'ARCBillSub',
		name : 'ARCBillSub',
		store : ArcBillSubStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{ARCBGRowId:'ARCBillGrp'}
});

var ARCIMUomDR = new Ext.ux.ComboBox({
		fieldLabel : '<font color=red>*计价单位</font>',
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
		fieldLabel : '<font color=red>*计价单位</font>',
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
					Msg.info("warning","请先维护药学项基本单位!");
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
		fieldLabel : '<font color=red>*医嘱大类</font>',
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
		fieldLabel : '<font color=red>*医嘱子类</font>',
		id : 'ARCItemCat',
		name : 'ARCItemCat',
		store : ArcItemCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'Desc',
		params:{OrderCat:'OrderCategory'}  //OrderCategory为医嘱大类的id
	});

var OECPriority = new Ext.ux.ComboBox({
		fieldLabel : '优先级',
		id : 'OECPriority',
		name : 'OECPriority',
		store : OECPriorityStore,
		valueField : 'RowId',
		displayField : 'Description'
});

var ARCIMMaxQty = new Ext.form.NumberField({
			fieldLabel : '最大量',
		id : 'ARCIMMaxQty',
		name : 'ARCIMMaxQty',
		anchor : '90%',
			allowNegative : false,
			selectOnFocus : true
		});

var ARCIMOEMessage = new Ext.form.TextField({
			fieldLabel : '医嘱提示',
		id : 'ARCIMOEMessage',
		name : 'ARCIMOEMessage',
		anchor : '90%',
		valueNotFoundText : ''
		});

var ARCIMNoOfCumDays = new Ext.form.NumberField({
			fieldLabel : '限制使用天数',
		id : 'ARCIMNoOfCumDays',
		name : 'ARCIMNoOfCumDays',
		anchor : '90%',
			allowNegative : false,
			selectOnFocus : true
		});

var ARCIMMaxQtyPerDay = new Ext.form.NumberField({
			fieldLabel : '每天最大剂量',
		id : 'ARCIMMaxQtyPerDay',
		name : 'ARCIMMaxQtyPerDay',
		decimalPrecision:5,
		anchor : '90%',
			allowNegative : false,
			selectOnFocus : true
		});

var ARCIMMaxCumDose = new Ext.form.NumberField({
			fieldLabel : '单次最大剂量',
		id : 'ARCIMMaxCumDose',
		name : 'ARCIMMaxCumDose',
		anchor : '90%',
		decimalPrecision:5,
			allowNegative : false,
			selectOnFocus : true
		});

var ARCIMRestrictOP = new Ext.form.Checkbox({
			fieldLabel : '门诊用药',
		id : 'ARCIMRestrictOP',
		name : 'ARCIMRestrictOP',
		anchor : '90%',
			height : 10,
			width : 30 ,
			checked : false
		});

var ARCIMRestrictEM = new Ext.form.Checkbox({
			fieldLabel : '急诊用药',
		id : 'ARCIMRestrictEM',
		name : 'ARCIMRestrictEM',
		anchor : '90%',
		height : 10,
		width : 30 ,
		checked : false
		});

var ARCIMRestrictIP = new Ext.form.Checkbox({
			fieldLabel : '住院用药',
		id : 'ARCIMRestrictIP',
		name : 'ARCIMRestrictIP',
		anchor : '90%',
		height : 10,
		width : 30 ,
		checked : false
		});

var ARCIMRestrictHP = new Ext.form.Checkbox({
			fieldLabel : '体检用药',
		id : 'ARCIMRestrictHP',
		name : 'ARCIMRestrictHP',
		anchor : '90%',
		height : 10,
		width : 30 ,
		checked : false
		});


var BillNotActive = new Ext.form.Checkbox({
			fieldLabel : '不维护收费项',
		id:'BillNotActive',
		name:'BillNotActive',
		anchor:'90%',
		checked:false,
		listeners:{
			'check':function(checked){
				if(checked.checked){
					document.getElementById('SubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="子分类:"; 

					SubTypeFee.setValue("");
					SubTypeFee.setRawValue("");
					SubTypeFee.disable();
					
					document.getElementById('InSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="住院子分类:"; 
					InSubTypeFee.setValue("");
					InSubTypeFee.setRawValue("");
					InSubTypeFee.disable();
					
					document.getElementById('OutSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="门诊子分类:"; 
					OutSubTypeFee.setValue("");
					OutSubTypeFee.setRawValue("");
					OutSubTypeFee.disable();
					
					document.getElementById('AccSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="核算子分类:"; 
					AccSubTypeFee.setValue("");
					AccSubTypeFee.setRawValue("");
					AccSubTypeFee.disable();
					
					document.getElementById('MedSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="病历首页分类:"; 
					MedSubTypeFee.setValue("");
					MedSubTypeFee.setRawValue("");
					MedSubTypeFee.disable();
					
					document.getElementById('AccountSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="会计子分类:"; 
					AccountSubTypeFee.setValue("");
					AccountSubTypeFee.setRawValue("");
					AccountSubTypeFee.disable();

					document.getElementById('NewMedSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="病案首页:"; 
					NewMedSubTypeFee.setValue("");
					NewMedSubTypeFee.setRawValue("");
					NewMedSubTypeFee.disable();
				}else{
					document.getElementById('SubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="<font color=red>子分类</font>:"; 
					SubTypeFee.enable();
					document.getElementById('InSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="<font color=red>住院子分类</font>:";
					InSubTypeFee.enable();
					document.getElementById('OutSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="<font color=red>门诊子分类</font>:";
					OutSubTypeFee.enable();
					document.getElementById('AccSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="<font color=red>核算子分类</font>:";
					AccSubTypeFee.enable();
					document.getElementById('MedSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="<font color=red>病历首页分类</font>:";
					MedSubTypeFee.enable();
					document.getElementById('AccountSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="<font color=red>会计子分类</font>:";
						AccountSubTypeFee.enable();
					document.getElementById('NewMedSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="<font color=red>病案首页</font>:";
					NewMedSubTypeFee.enable(); 
					}
				}
			}
		});

var BillCode = new Ext.form.TextField({
			fieldLabel : '收费项代码',
		id : 'BillCode',
		name : 'BillCode',
		anchor : '90%',
		disabled:true,
		valueNotFoundText : ''
		});

var BillName = new Ext.form.TextField({
			fieldLabel : '收费项名称',
		id : 'BillName',
		name : 'BillName',
		anchor : '90%',
		disabled:true,
		valueNotFoundText : ''
		});

var ARCIMAbbrev = new Ext.form.TextField({
			fieldLabel : '缩写',
		id : 'ARCIMAbbrev',
		name : 'ARCIMAbbrev',
		anchor : '90%',
		valueNotFoundText : '',
		disabled:true
		});

var ARCIMText1 = new Ext.form.TextField({
			fieldLabel : '医保名称',
		id : 'ARCIMText1',
		name : 'ARCIMText1',
		anchor : '90%',
		valueNotFoundText : ''
		});

//var DHCArcItemAut = new Ext.Button({
//			text : '限制科室设置',
//			handler : function() {
//			}
//		});

//------------xiaohe 限制科室用药
var RestrictDocButton = new Ext.Button({
		id:'RestrictDocButton',
		text : '限制科室用药',
		iconCls:"drug_limit",
		width : 100,
		handler : function() {
            var ArcimCode = Ext.getCmp("ARCIMCode").getValue(); //代码
			var ArcimDesc = Ext.getCmp("ARCIMDesc").getValue(); //名称
			var Spec=Ext.getCmp("INFOSpec").getValue();   //规格
			var ManfId=Ext.getCmp("PhManufacturer").getValue(); //厂商		
			if(ArcRowid!=""){
				RestrictDocEdit("", ArcRowid,ArcimCode,ArcimDesc,Spec,ManfId);	
			}
		}
	});
//------------


var ARCIMOrderOnItsOwn = new Ext.form.Checkbox({
			fieldLabel : '独立医嘱',
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
		fieldLabel : '无库存医嘱',
		id : 'WoStockFlag',
		name : 'WoStockFlag',
		anchor : '90%',
		height : 10,
		width : 30 ,
		checked : false
	});
	
//子分类
var SubTypeFee = new Ext.ux.ComboBox({
		fieldLabel:(Ext.getCmp('BillNotActive').getValue()==true?'子分类':'<font color=red>子分类</font>'),
		id : 'SubTypeFee',
		name : 'SubTypeFee',
		store : TarSubCateStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'Desc'
	});


//住院子分类
var InSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel:(Ext.getCmp('BillNotActive').getValue()==true?'住院子分类':'<font color=red>住院子分类</font>'),
		id : 'InSubTypeFee',
		name : 'InSubTypeFee',
		store : TarInpatCateStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'Desc'
	});

//门诊子分类		
var OutSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel :(Ext.getCmp('BillNotActive').getValue()==true?'门诊子分类':'<font color=red>门诊子分类</font>') ,
		id : 'OutSubTypeFee',
		name : 'OutSubTypeFee',
		store : TarOutpatCateStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName : 'Desc'
	});

//核算子分类
var AccSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel :(Ext.getCmp('BillNotActive').getValue()==true?'核算子分类':'<font color=red>核算子分类</font>'),
		id : 'AccSubTypeFee',
		name : 'AccSubTypeFee',
		store : TarEMCCateStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName : 'Desc'
	});

//病历首页分类
var MedSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel :(Ext.getCmp('BillNotActive').getValue()==true?'病历首页分类':'<font color=red>病历首页分类</font>'),
		id : 'MedSubTypeFee',
		name : 'MedSubTypeFee',
		store : TarMRCateStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName : 'Desc'
	});

//会计子分类
var AccountSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel :(Ext.getCmp('BillNotActive').getValue()==true?'会计子分类':'<font color=red>会计子分类</font>'),
		id : 'AccountSubTypeFee',
		name : 'AccountSubTypeFee',
		store : TarAcctCateStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName : 'Desc'
	});

//新病案首页
var NewMedSubTypeFee = new Ext.ux.ComboBox({
		fieldLabel :(Ext.getCmp('BillNotActive').getValue()==true?'新病案首页':'<font color=red>新病案首页</font>'),
		id : 'NewMedSubTypeFee',
		name : 'NewMedSubTypeFee',
		store : TarNewMRCateStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName : 'Desc'
	});
	
var MedProMaintain = new Ext.form.Checkbox({
		fieldLabel : '维护医保项',
		id : 'MedProMaintain',
		name : 'MedProMaintain',
		anchor : '90%',
		checked : false,
		hidden:true
	});

// 医嘱项Panel
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
					title : '收费项目分类',
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
//============================医嘱项=========================================================================

//============================库存项=========================================================================
var INCICode = new Ext.form.TextField({
		fieldLabel : '<font color=red>*代码</font>',
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
			fieldLabel : '<font color=red>*名称</font>',
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
			fieldLabel : '<font color=red>*规格</font>',
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
		fieldLabel : '<font color=red>*基本单位</font>',
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
		fieldLabel : '<font color=red>*入库单位</font>',
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
					Msg.info("warning","请先录入库存项基本单位!");					
					return;
				}
			},
			'specialkey':function(field,e){
				SpecialKeyHandler(e,'DHCStkCatGroup');			
			}
			}
		});

var PackUom = new Ext.ux.ComboBox({
		fieldLabel : '大包装单位',
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
	data : [['REQUIRED', '要求'], ['NONREQUIRED', '不要求'], ['OPTIONAL', '随意']]
});

var INCIBatchReq = new Ext.form.ComboBox({
			fieldLabel : '<font color=red>*批次</font>',
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
			fieldLabel : '<font color=red>*有效期要求</font>',
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
			fieldLabel : '效期长度(月)',
		id : 'INFOExpireLen',
		name : 'INFOExpireLen',
		anchor : '90%',
			allowNegative : false,
			selectOnFocus : true
		});

var DHCStkCatGroup = new Ext.ux.ComboBox({
			fieldLabel : '<font color=red>*库存分类</font>',
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
			fieldLabel : '<font color=red>*转移方式</font>',
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
			fieldLabel : '条码',
		id : 'INCIBarCode',
		name : 'INCIBarCode',
		anchor : '90%',
		valueNotFoundText : ''
		});

var INCAlias = new Ext.form.TextField({
			fieldLabel : '别名',
		id : 'INCAlias',
		name : 'INCAlias',
		width : 380,
		anchor : '90%',
		emptyText:'多个别名之间用/分隔',
		disabled:true,
		valueNotFoundText : ''
		});

var incAliasButton = new Ext.Button({
			id:'IncAliasButton',
		text : '别名',
		width : 15,
		handler : function() {
			//var IncRowid = Ext.getCmp("InciRowid").getValue();
			if(drugRowid!=""){
				IncAliasEdit("", drugRowid);	
			}else{
				Msg.info("warning","请选择需要维护别名的库存项！");
				return;
			}					
		}
});
var incApprovalButton = new Ext.Button({
			id:'incApprovalButton',
		text : '维护',
		width : 15,
		//disabled:true,
		handler : function() {
			var drugdesc=Ext.getCmp("INCIDesc").getValue();
			IncApprovalEdit(drugRowid,drugdesc,RegetincApproval);				
		
		}
});
///维护批准文号后更新界面值
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
			fieldLabel : '招标级别',
		id : 'INFOPBLevel',
		name : 'INFOPBLevel',
		store : INFOPBLevelStore,
		valueField : 'RowId',
		displayField : 'Description'
		});
BookCatStore.load();
var INFOBCDr = new Ext.ux.ComboBox({
		fieldLabel : '帐薄分类',
		id : 'INFOBCDr',
		name : 'INFOBCDr',
		store : BookCatStore,
		valueField : 'RowId',
		displayField : 'Description'
});

var INCIBRpPuruom = new Ext.form.NumberField({
		fieldLabel : '进货价',
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
		fieldLabel : '零售价',
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
			fieldLabel : '价格生效日期',
		id : 'PreExeDate',
		name : 'PreExeDate',
		anchor : '90%',
		value : ''
		});

var INFOPrcFile = new Ext.form.TextField({
			fieldLabel : '物价文件号',
		id : 'INFOPrcFile',
		name : 'INFOPrcFile',
		anchor : '90%',
		valueNotFoundText : ''
		});

var INFOSkinTest = new Ext.form.Checkbox({
			fieldLabel : '皮试标志',
		id : 'INFOSkinTest',
		name : 'INFOSkinTest',
		anchor : '90%',
		width : 30 ,  // add by myq 20150910 
		checked : false
		});

var INCINotUseFlag = new Ext.form.Checkbox({
			fieldLabel : '不可用',
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
			text : '大包装维护',
			height : 30,
			handler : function() {
			}
		});
var incBatButton = new Ext.Button({
			id:'IncBatButton',
		text : '可用批次维护',
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
		data : [['国产', '国产'], ['进口', '进口'], ['合资', '合资']]
		});
var INFOImportFlag = new Ext.form.ComboBox({
		fieldLabel : '进口标志',
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
			fieldLabel : '处方药分类',
		id : 'INFOOTC',
		name : 'INFOOTC',
		store : INFOOTCStore,
		valueField : 'RowId',
		displayField : 'Description'
		});

var INFOQualityNo = new Ext.form.TextField({
			fieldLabel : '质标编号',
		id : 'INFOQualityNo',
		name : 'INFOQualityNo',
		anchor : '90%',
		width : 180,
		valueNotFoundText : ''
		});
		
MarkTypeStore.load();
var INFOMT = new Ext.ux.ComboBox({
			fieldLabel : '定价类型',
		id : 'INFOMT',
		name : 'INFOMT',
		store : MarkTypeStore,
		valueField : 'RowId',
		displayField : 'Description'
		});

var INFOMaxSp = new Ext.form.NumberField({
		fieldLabel : '最高售价',
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
			fieldLabel : '批准文号',
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
			fieldLabel : '国(省)别',
		id : 'INFOComFrom',
		name : 'INFOComFrom',
		anchor : '90%',
		width : 180,
		valueNotFoundText : ''
		});
INFOQualityLevelStore.load();
var INFOQualityLevel = new Ext.ux.ComboBox({
			fieldLabel : '质量层次',
		id : 'INFOQualityLevel',
		name : 'INFOQualityLevel',
		anchor : '90%',
		store : INFOQualityLevelStore,
		valueField : 'RowId',
		displayField : 'Description'
	});

var INCIReportingDays = new Ext.form.TextField({
			fieldLabel : '协和码',
		id : 'INCIReportingDays',
		name : 'INCIReportingDays',
		anchor : '90%',
		width : 180,
		valueNotFoundText : ''
		});


PublicBiddingListStore.load();
var INFOPBLDR = new Ext.ux.ComboBox({
		fieldLabel : '招标名称',
		id : 'INFOPBLDR',
		name : 'INFOPBLDR',
		anchor : '90%',
		store : PublicBiddingListStore,
		valueField : 'RowId',
		displayField : 'Description'
});

var INFOPbVendor = new Ext.ux.VendorComboBox({
		fieldLabel : '招标供货商',
		id : 'INFOPbVendor',
		name : 'INFOPbVendor'
});
		
var INFOPbManf = new Ext.ux.ComboBox({
		fieldLabel : '招标生产商',
		id : 'INFOPbManf',
		name : 'INFOPbManf',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName'
});
		
var INFOPbCarrier = new Ext.ux.ComboBox({
		fieldLabel : '招标配送商',
		id : 'INFOPbCarrier',
		name : 'INFOPbCarrier',
		store : CarrierStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'CADesc'
});
		
var INFOPbRp = new Ext.form.NumberField({
			fieldLabel : '招标进价',
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
			fieldLabel : '用药说明',
		id : 'UserOrderInfo',
		name : 'UserOrderInfo',
		anchor : '90%',
		width : 180,
		valueNotFoundText : ''
		});

var INFOPbFlag = new Ext.form.Checkbox({
			fieldLabel : '是否招标',
		id : 'INFOPbFlag',
		name : 'INFOPbFlag',
		anchor : '90%',
			width : 30,
			height : 10,
			checked : false
		});

var INFOBAflag = new Ext.form.Checkbox({
			fieldLabel : '阳光采购',
		id : 'INFOBAflag',
		name : 'INFOBAflag',
		anchor : '90%',
			width : 30,
			height : 10,
			checked : false
		});
		
var INFOBAflag = new Ext.form.Checkbox({
			fieldLabel : '阳光采购',
		id : 'INFOBAflag',
		name : 'INFOBAflag',
		anchor : '90%',
			width : 30,
			height : 10,
			checked : false
		});
		
var INFOTest = new Ext.form.Checkbox({
			fieldLabel : '临床验证用药',
		id : 'INFOTest',
		name : 'INFOTest',
		anchor : '90%',
			width : 30,
			height : 10,
			checked : false
		});
		
var INFOREC = new Ext.form.Checkbox({
			fieldLabel : '处方购药标志',
		id : 'INFOREC',
		name : 'INFOREC',
		anchor : '90%',
			width : 30,
			height : 10,
			checked : false
		});
		
var INFOBasicDrug = new Ext.form.Checkbox({
			fieldLabel : '基本药物标志',
		id : 'INFOBasicDrug',
		name : 'INFOBasicDrug',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});
		
var INFOInHosFlag = new Ext.form.Checkbox({
			fieldLabel : '本院药品目录',
		id : 'INFOInHosFlag',
		name : 'INFOInHosFlag',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});
		
var INFOCodex = new Ext.form.Checkbox({
			fieldLabel : '中国药典标志',
		id : 'INFOCodex',
		name : 'INFOCodex',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});
		
var INFOHighPrice = new Ext.form.Checkbox({
			fieldLabel : '贵重药标志',
		id : 'INFOHighPrice',
		name : 'INFOHighPrice',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});
		
var INFOBasicDrug2 = new Ext.form.Checkbox({
			fieldLabel : '省级基本药物',
		id : 'INFOBasicDrug2',
		name : 'INFOBasicDrug2',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});
		
var INFOProvince1 = new Ext.form.Checkbox({
			fieldLabel : '市级基本药物',
		id : 'INFOProvince1',
		name : 'INFOProvince1',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});
		
var INFOProvince2 = new Ext.form.Checkbox({
			fieldLabel : '区(县)基本药物',
		id : 'INFOProvince2',
		name : 'INFOProvince2',
		anchor : '90%',
			width : 20,
			height : 10,
			checked : false
		});
		
var INFOPriceBakD = new Ext.ux.DateField({
			fieldLabel : '物价备案日期',
		id : 'INFOPriceBakD',
		name : 'INFOPriceBakD',
		anchor : '90%',
		width : 180,
		value : ''
		});

var INFODrugBaseCode = new Ext.form.TextField({
			fieldLabel : '药品本位码',
		id : 'INFODrugBaseCode',
		name : 'INFODrugBaseCode',
		anchor : '90%',
		width : 180,
		minLength : 14,
		valueNotFoundText : ''
		});
		
var InDrugInfo = new Ext.form.TextField({
			fieldLabel : '进药依据',
		id : 'InDrugInfo',
		name : 'InDrugInfo',
		anchor : '90%',
		width : 180,
		valueNotFoundText : ''
	});
var HighRiskFlag = new Ext.form.Checkbox({
			fieldLabel : '高危药品标志',
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
				{ xtype: 'displayfield', value: '-系数'},
				PackUomFac
			]
}
// 库存项Panel
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
									{ xtype: 'displayfield', value: '-系数'},
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
					defaults:{border:false}, // false->true 在IE11版本下不显示边框会导致不可用原因显示不出来  modified by myq 20150910
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

//============================库存项=========================================================================
	
// 页签
var talPanel = new Ext.TabPanel({
	activeTab : 0,
	deferredRender : true,
	region : 'east',
	width: 800, 
	tbar : [addButton,'-',saveButton,'-',DeleteBT,'-',GetMaxCodeBT,'-',SaveAsBT,'-',CTUomChangeButton],
	items : [{
		layout : 'fit',
		title : '药学项',
		items : [PHCDrgFormPanel]
	}, {
		layout : 'fit',
		title : '医嘱项',
		items : [ItmMastPanel]
	}, {
		layout : 'fit',
		title : '库存项',
		items : [ItmPanel]
	}]
});