//���ݿ����Rowid��ѯ
var RowDelim=xRowDelim();
var storeConRowId="";
var gspreq="" ;  ///�Ƿ���Ҫά�����ۼ�
var userId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var cspname=App_MenuCspName;

var ASP_STATUS="";
var ASP="";
var gNewItmRowId = '';		//��Ʒ����id,ȫ�ֱ���
var gRegRowId='';
		
function GetDetail(rowid){
	var url = 'dhcstm.druginfomaintainaction.csp?actiontype=GetDetail&InciRowid='+rowid;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var s = result.responseText;
			s=s.replace(/\r/g,"")
			s=s.replace(/\n/g,"") 
			var jsonData = Ext.util.JSON.decode(s);
			if (jsonData.success == 'true') {
				var ListData = jsonData.info.split(RowDelim);
				var ListData1=ListData[0];
				SetIncDetail(ListData1);
				SetFormOriginal(ItmPanel);
				CheckItmUsed(rowid);
			} else {
				Msg.info("error", "��ѯ����:"+jsonData.info);
			}
		},
		scope : this
	});
}
//��ѯ�������Ϣ
function SetIncDetail(listData) {
	if(listData==null || listData==""){
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
		addComboData(StkCatStore,list[7],list[8]);
		Ext.getCmp("StkCat").setValue(list[7]);  //������
		Ext.getCmp("INCIIsTrfFlag").setValue(list[9]); //ת�Ʒ�ʽ
		Ext.getCmp("INCIBatchReq").setValue(list[10]); //����
		Ext.getCmp("INCIExpReqnew").setValue(list[11]); //��Ч�� 
		Ext.getCmp("INCAlias").setValue(list[12]); //����
		Ext.getCmp("INCINotUseFlag").setValue(list[13]=='Y'?true:false); //�����ñ�־
		Ext.getCmp("INCIReportingDays").setValue(list[14]); //Э����
		Ext.getCmp("INCIBarCode").setValue(list[15]); //����
		Ext.getCmp("INCIBSpPuruom").setValue(list[18]); //�ۼ�
		Ext.getCmp("INCIBRpPuruom").setValue(list[19]); //����
		addComboData(Ext.getCmp("supplyLocField").getStore(),list[20],list[21]); //��Ӧ�ֿ�
		Ext.getCmp("supplyLocField").setValue(list[20]);
		Ext.getCmp("remark").setValue(handleMemo(list[22],xMemoDelim())); //��עhandleMemo(dataArr[10],xMemoDelim())
		Ext.getCmp("INFOImportFlag").setValue(list[23]); //���ڱ�־ 
		addComboData(INFOQualityLevelStore,list[74],list[24]);
		Ext.getCmp("INFOQualityLevel").setValue(list[74]);
		Ext.getCmp("INFOQualityNo").setValue(list[30]);
		Ext.getCmp("INFOComFrom").setValue(list[31]);
		Ext.getCmp("INFORemark2").setValue(list[32]);		//ע��֤��
		Ext.getCmp("INFOHighPrice").setValue(list[33]=='Y'?true:false); //��ֵ���־
		Ext.getCmp("INFOMT").setValue(list[35]); //��������id
		Ext.getCmp("INFOMT").setRawValue(list[36]); //��������
		Ext.getCmp("INFOMaxSp").setValue(list[37]); //����ۼ�
		storeConRowId=list[38];//�洢����id
		Ext.getCmp("INFOISCDR").setValue(getStoreConStr(drugRowid));//�洢����
		Ext.getCmp("INFOInHosFlag").setValue(list[39]=='Y'?true:false); //��Ժ����Ŀ¼
		Ext.getCmp("INFOPbFlag").setValue(list[40]=='Y'?true:false); //�б��־
		Ext.getCmp("INFOPbRp").setValue(list[41]); //�б����		
		addComboData(INFOPBLevelStore,list[73],list[42]);
		Ext.getCmp("INFOPBLevel").setValue(list[73]); //�б꼶��
		addComboData(INFOPbVendor.getStore(),list[43],list[44]);
		Ext.getCmp("INFOPbVendor").setValue(list[43]);
		addComboData(PhManufacturerStore,list[45],list[46]);
		Ext.getCmp("INFOPbManf").setValue(list[45]);
		addComboData(CarrierStore,list[47],list[48]);
		Ext.getCmp("INFOPbCarrier").setValue(list[47]);							
		Ext.getCmp("INFOPBLDR").setValue(list[49]);
		Ext.getCmp("INFOBAflag").setValue(list[51]=='Y'?true:false); //һ���Ա�־
		Ext.getCmp("INFOExpireLen").setValue(list[52]);
		Ext.getCmp("INFOPrcFile").setValue(list[53]);
		Ext.getCmp("INFOPriceBakD").setValue(list[54]);    //����ļ�����
		Ext.getCmp("INFOBCDr").setValue(list[56]); //�ʲ�����id
		Ext.getCmp("INFOBCDr").setRawValue(list[57]); //�ʲ����� 
		Ext.getCmp("INFODrugBaseCode").setValue(list[62]); //���ʱ�λ��
		Ext.getCmp("INFOSpec").setValue(list[64]); //���
		addComboData(ItmNotUseReasonStore,list[65],list[66]);
		Ext.getCmp("ItmNotUseReason").setValue(list[65]); //������ԭ��
		Ext.getCmp("PHCDOfficialType").setValue(list[67]); //ҽ�����
		Ext.getCmp("HighRiskFlag").setValue(list[69]=='Y'?true:false); //��Σ��־
		addComboData(CTUomStore,list[70],list[71]);
		Ext.getCmp("PackUom").setValue(list[70]); //���װ��λ
		Ext.getCmp("PackUomFac").setValue(list[72]); //���װ��λϵ��
		Ext.getCmp("INFOBrand").setValue(list[75]); //Ʒ��
		Ext.getCmp("INFOModel").setValue(list[76]); //�ͺ�
		Ext.getCmp("INFOChargeFlag").setValue(list[77]=='Y'?true:false); //�շѱ�־
		Ext.getCmp("INFOAbbrev").setValue(list[78]); //���
		Ext.getCmp("INFOSupervision").setValue(list[79]); //��ܼ���
		Ext.getCmp("INFOImplantationMat").setValue(list[80]=='Y'?true:false); //ֲ���־
		Ext.getCmp("reqType").setValue(list[81]); //������������
		Ext.getCmp("INFONoLocReq").setValue(list[82]=='Y'?true:false); //��ֹ�����־
		Ext.getCmp("INFOSterileDateLen").setValue(list[83]);  //���ʱ��
		Ext.getCmp("INFOZeroStk").setValue(list[84]=='Y'?true:false); //�����־
		addComboData(INFOChargeTypeFlagStore,list[85],list[86]);
		Ext.getCmp("INFOChargeType").setValue(list[85]); //�շ�����
		//Ext.getCmp("INFOMedEqptCat").setValue(list[87]);  //��е����
		Ext.getCmp("IRRegCertExpDate").setValue(list[88]); //ע��֤Ч��
		Ext.getCmp("INFOPackCharge").setValue(list[89]);  //����շѱ�־ 
		Ext.getCmp("PreExeDate").setValue(list[93]);	//�۸���Ч����
		addComboData(Ext.getCmp("StkGrpType").getStore(),list[94],list[95],StkGrpType);
		Ext.getCmp("StkGrpType").setValue(list[94]);	//����
		setgspreq(list[94]) ;
		
		ASP_STATUS=list[96];
		ASP=list[97];
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
		var StandardId=regData[9];
		var StandardDesc=regData[10];
		addComboData(StandardNameStore, StandardId, StandardDesc);
		Ext.getCmp("StandardName").setValue(StandardId); //��׼����
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
		
		addComboData(Ext.getCmp("MatCatSpecial").getStore(),list[102],list[103]);
		Ext.getCmp("MatCatSpecial").setValue(list[102]); //�������
		Ext.getCmp("INFORiskCategory").setValue(list[104]); //�������
		Ext.getCmp("INFOConsumableLevel").setValue(list[105]); //�Ĳļ���
		Ext.getCmp("INFOApplication").setValue(list[106]);//��;
		Ext.getCmp("INFOFunction").setValue(list[107]);//����
		gRegRowId=list[108]
		addsaveButton.setDisabled(false);  //��水ť
	}
}
//��տ������Ϣ
function clearData(){
		drugRowid="";
		gNewItmRowId = '';
		gRegRowId='';
		INCICode.setValue("");
		INCIDesc.setValue("");
		INFOSpec.setValue("");
		INCICTUom.setValue("");
		INCICTUom.setRawValue("");
		PUCTUomPurch.setValue("");
		PUCTUomPurch.setRawValue("");
		StkCat.setValue("");
		StkCat.setRawValue("");
		StkGrpType.setValue("");
		StkGrpType.setRawValue("");
		INCAlias.setValue("");
		/*
		INCIBatchReq.setValue("");
		INCIBatchReq.setRawValue("");
		INCIExpReqnew.setValue("");
		INCIExpReqnew.setRawValue("");
		INFOExpireLen.setValue("");
		INCIIsTrfFlag.setValue("");
		INCIIsTrfFlag.setRawValue("");
		*/
		INFOZeroStk.setValue("");
		INFOPackCharge.setValue("")
		INFOSupervision.setValue("");
		INFOChargeType.setValue("");
		INFOMedEqptCat.setValue("");
		INFOSterileDateLen.setValue("");
		PHCDOfficialType.setValue("");
		
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
		INFOImplantationMat.setValue(false);
		INFONoLocReq.setValue(false);
		PackUom.setValue("");
		PackUom.setRawValue("");
		PackUomFac.setValue("");
		INFOBrand.setValue("");
		INFOModel.setValue("");
		INFOAbbrev.setValue("");
		IRRegCertExpDate.setValue("");
		remark.setValue("");
		supplyLocField.setValue("");
		reqType.setValue("");
		Ext.getCmp("INCIBatchReq").setValue('REQUIRED');
		Ext.getCmp("INCIExpReqnew").setValue('REQUIRED');
		Ext.getCmp('INCIIsTrfFlag').setValue('TRANS');
		
		Ext.getCmp("INCICTUom").setDisabled(false);
		
		HospZeroStk.setValue("");//Ժ�������־
		
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
		SCategory.setValue('');
		MatQuality.setValue('');
		MatCatSpecial.setValue("");
		INFORiskCategory.setValue("");
		INFOConsumableLevel.setValue("");
		INFOApplication.setValue("");
		INFOFunction.setValue("");
		InitDetailForm();
}
//��ʼ������
function InitDetailForm(){
	var Param = gGroupId + "^"+ gLocId + "^" + userId;
	var url='dhcstm.druginfomaintainaction.csp?actiontype=GetParamProp&Param='+Param;
	var result=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(result);
	if(jsonData.success=='true'){
		var ret=jsonData.info;
		if(ret!=null& ret!=""){
			var propValue=ret.split("^");
			var AllowInputRp=propValue[0];
			var AllowInputSp=propValue[1];
			var InitStatusNotUse=propValue[4];
			var InciBatchReq=propValue[8];
			InciBatchReq = InciBatchReq=='N'?'NONREQUIRED':InciBatchReq=='O'?InciBatchReq='OPTIONAL':'REQUIRED';
			var InciExpReq=propValue[9];
			InciExpReq = InciExpReq=='N'?'NONREQUIRED':InciExpReq=='O'?InciExpReq='OPTIONAL':'REQUIRED';
			Ext.getCmp("INCICode").setDisabled(false);
			Ext.getCmp("INCIDesc").setDisabled(false);
			var SetNotUseFlagEdit=propValue[10];
			if(AllowInputRp=='Y'){
				Ext.getCmp('INCIBRpPuruom').setDisabled(false);
			}else{
				Ext.getCmp('INCIBRpPuruom').setDisabled(true);
			}
			if(AllowInputSp=='Y'){
				Ext.getCmp('INCIBSpPuruom').setDisabled(false);
				Ext.getCmp('INFOPrcFile').setDisabled(false);
				Ext.getCmp('INFOPriceBakD').setDisabled(false);			
			}else{
				Ext.getCmp('INCIBSpPuruom').setDisabled(true);
				Ext.getCmp('INFOPrcFile').setDisabled(true);
				Ext.getCmp('INFOPriceBakD').setDisabled(true);		
			}
			if ((AllowInputSp=='Y')||(AllowInputRp=='Y'))
			{Ext.getCmp('PreExeDate').setDisabled(false);}
			else
			{Ext.getCmp('PreExeDate').setDisabled(true);}
			
			if(InitStatusNotUse=='Y'){
				Ext.getCmp('INCINotUseFlag').setValue(true);
			}else{
				Ext.getCmp('INCINotUseFlag').setValue(false);
			}
			if(SetNotUseFlagEdit=='Y'){
				Ext.getCmp('INCINotUseFlag').setDisabled(true);
			}else{
				Ext.getCmp('INCINotUseFlag').setDisabled(false);
			}
			Ext.getCmp("INCIBatchReq").setValue(InciBatchReq);
			Ext.getCmp("INCIExpReqnew").setValue(InciExpReq);
		}
	}
	var elemidstr=getidstr();//��ʼ��������
	changeElementInfo(elemidstr,cspname);
	Ext.getCmp("StkGrpType").setValue("");
	
	//������һ�����õĶ�������,��Ĭ����ʾ
	MarkTypeStore.load({
		callback : function(r, options, success){
			if(this.getTotalCount() == 1 && r.length == 1){
				INFOMT.setValue(r[0].get(INFOMT.valueField));
				INFOMT.originalValue = INFOMT.getValue();
			}
		}
	});

	SetFormOriginal(ItmPanel);
}

//��ȡ�������Ϣ
function getIncList(){
	// ��������ݴ�:����^����^������λid^��ⵥλid^������id^ת�Ʒ�ʽ^�Ƿ�Ҫ������^�Ƿ�Ҫ��Ч��^����^�����ñ�־^Э����^����^������^�ۼ�^����^��Ӧ�ֿ�^��ע^�۸���Ч����^���ڱ�־^�������
	// ^�������^��/ʡ��^��׼�ĺ�^��ֵ���־^��������id^����ۼ�^�洢����^��Ժ����Ŀ¼^�б��־^�б����^�б꼶��^�б깩Ӧ��id^�б�������id^�б�������id^�б�����
	// ^����ɹ���־^Ч�ڳ���^����ļ���^����ļ�����ʱ��^�ʲ�����id^���ʱ�λ��^���
	var iNCICode = Ext.getCmp("INCICode").getValue();	 //������
	var iNCIDesc = Ext.getCmp("INCIDesc").getValue();	 //�������
	var BillUomId = Ext.getCmp("INCICTUom").getValue();	//������λ		
	var PurUomId=Ext.getCmp("PUCTUomPurch").getValue(); //��ⵥλ
	var StkCatId=Ext.getCmp("StkCat").getValue(); //������id
	var StkGrpType=Ext.getCmp("StkGrpType").getValue(); //����
	var TransFlag=Ext.getCmp("INCIIsTrfFlag").getValue(); //ת�Ʒ�ʽ
	var BatchFlag=Ext.getCmp("INCIBatchReq").getValue(); //����
	var ExpireFlag=Ext.getCmp("INCIExpReqnew").getValue(); //��Ч��	
	var AliasStr=Ext.getCmp("INCAlias").getValue(); //����
	var NotUseFlag=(Ext.getCmp("INCINotUseFlag").getValue()==true?'Y':'N'); //�����ñ�־
	var XieHeCode=Ext.getCmp("INCIReportingDays").getValue();	//Э����
	var BarCode=Ext.getCmp("INCIBarCode").getValue();//����	
	var Sp=Ext.getCmp("INCIBSpPuruom").getValue(); //���ۼ�
	var Rp=Ext.getCmp("INCIBRpPuruom").getValue(); //����
	var SupplyLocField=Ext.getCmp("supplyLocField").getValue(); //��Ӧ�ֿ�
	var reqType=Ext.getCmp("reqType").getValue(); //������������
	var Remarks=Ext.getCmp("remark").getValue(); //��ע
	Remarks=Remarks.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	var PreExeDate=Ext.getCmp("PreExeDate").getValue(); //�۸���Ч����
	if((PreExeDate!="")&&(PreExeDate!=null)){
		PreExeDate = PreExeDate.format(ARG_DATEFORMAT);
	}
	var Spec=Ext.getCmp("INFOSpec").getValue();//���
	var INFOImportFlag=Ext.getCmp("INFOImportFlag").getValue(); //���ڱ�־
	var QualityLevel=Ext.getCmp("INFOQualityLevel").getValue(); //�������
	var QualityNo=Ext.getCmp("INFOQualityNo").getValue();//�ʱ���
	var ComFrom=Ext.getCmp("INFOComFrom").getValue();//����/ʡ��
	var Remark=Ext.getCmp("INFORemark2").getValue();//ע��֤��
	var HighPrice=(Ext.getCmp("INFOHighPrice").getValue()==true?'Y':'N');//��ֵ���־
	var MtDr=Ext.getCmp("INFOMT").getValue();//��������
	var MaxSp = Ext.getCmp("INFOMaxSp").getValue();//����ۼ�
	var StoreConDr=storeConRowId;//�洢����
	var InHosFlag=(Ext.getCmp("INFOInHosFlag").getValue()==true?'Y':'N');//��Ժ����Ŀ¼
	var PbFlag=(Ext.getCmp("INFOPbFlag").getValue()==true?'Y':'N');//�б��־	
	var PbRp=Ext.getCmp("INFOPbRp").getValue();//�б����
	var PbLevel=Ext.getCmp("INFOPBLevel").getValue();//�б꼶��
	var PbVendorId=Ext.getCmp("INFOPbVendor").getValue();//�б깩Ӧ��
	var PbManfId=Ext.getCmp("INFOPbManf").getValue();//�б�������
	var PbCarrier=Ext.getCmp("INFOPbCarrier").getValue();//�б�������
	var PbBlDr=Ext.getCmp("INFOPBLDR").getValue();//�б�����
	var BaFlag=(Ext.getCmp("INFOBAflag").getValue()==true?'Y':'N');//һ���Ա�־
	var ExpireLen=Ext.getCmp("INFOExpireLen").getValue();//Ч�ڳ���
	var PrcFile=Ext.getCmp("INFOPrcFile").getValue();//����ļ���
	var PrcFileDate=Ext.getCmp("INFOPriceBakD").getValue();//����ļ���������
	if((PrcFileDate!="")&&(PrcFileDate!=null)){
		PrcFileDate = PrcFileDate.format(ARG_DATEFORMAT);
	}
	var IRRegCertExpDate=Ext.getCmp("IRRegCertExpDate").getValue(); //ע��֤����
	if((IRRegCertExpDate!="")&&(IRRegCertExpDate!=null)){
		IRRegCertExpDate = IRRegCertExpDate.format(ARG_DATEFORMAT);
	}
	var BookCatDr=Ext.getCmp("INFOBCDr").getValue();//�˲�����
	var StandCode=Ext.getCmp("INFODrugBaseCode").getValue();//���ʱ�λ��
	var PackUom=Ext.getCmp("PackUom").getValue();//���װ��λ
	var PackUomFac=Ext.getCmp("PackUomFac").getValue();//���װ��λϵ��
	var HighRiskFlag=(Ext.getCmp("HighRiskFlag").getValue()==true?'Y':'N');//��Σ��־	
	var NotUseReason=Ext.getCmp("ItmNotUseReason").getValue();//������ԭ��
	var InsuType=Ext.getCmp("PHCDOfficialType").getValue(); //ҽ�����
	var Brand=Ext.getCmp("INFOBrand").getValue();	//Ʒ��
	var Model=Ext.getCmp("INFOModel").getValue();	//�ͺ�
	var chargeFlag=(Ext.getCmp("INFOChargeFlag").getValue()==true?'Y':'N');	//�շѱ�־
	var Abbrev=Ext.getCmp("INFOAbbrev").getValue();	//���
	var Supervision=Ext.getCmp("INFOSupervision").getValue();	//��ܼ���
	var ImplantationMat=(Ext.getCmp("INFOImplantationMat").getValue()==true?'Y':'N');	//ֲ���־
	var NoLocReq=(Ext.getCmp("INFONoLocReq").getValue()==true?'Y':'N');	//��ֹ�����־
	var INFOSterile=Ext.getCmp("INFOSterileDateLen").getValue();  //���ʱ��
	var INFOZeroStk=(Ext.getCmp("INFOZeroStk").getValue()==true?'Y':'N');	//�����־
	var INFOChargeType=Ext.getCmp("INFOChargeType").getValue(); //�շ�����
	var INFOMedEqptCat=Ext.getCmp("INFOMedEqptCat").getValue();    //��е����
	var INFOPackCharge=(Ext.getCmp("INFOPackCharge").getValue()==true?'Y':'N');	//�����־
	
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
	var StandardNameId=Ext.getCmp('StandardName').getValue();
	var MatCatSpecial=Ext.getCmp("MatCatSpecial").getValue();  ///�������
	var INFORiskCategory = Ext.getCmp("INFORiskCategory").getValue(); 		//�������
	var INFOConsumableLevel = Ext.getCmp("INFOConsumableLevel").getValue(); //�Ĳļ���
	var INFOApplication = Ext.getCmp("INFOApplication").getValue(); 		//��;
	var INFOFunction = Ext.getCmp("INFOFunction").getValue(); 				//����
	var listInc=iNCICode+"^"+iNCIDesc+"^"+BillUomId+"^"+PurUomId+"^"+StkCatId+"^"+TransFlag+"^"+BatchFlag+"^"+ExpireFlag+"^"+AliasStr+"^"+NotUseFlag+"^"
			+XieHeCode+"^"+BarCode+"^"+userId+"^"+Sp+"^"+Rp+"^"+SupplyLocField+"^"+Remarks+"^"+PreExeDate+"^"+Spec+"^"+INFOImportFlag+"^"+QualityLevel+"^"+""+"^"
			+""+"^"+""+"^"+""+"^"+""+"^"+QualityNo+"^"+ComFrom+"^"+Remark+"^"+HighPrice+"^"+MtDr+"^"+MaxSp+"^"
			+StoreConDr+"^"+InHosFlag+"^"+PbFlag+"^"+PbRp+"^"+PbLevel+"^"+PbVendorId+"^"+PbManfId+"^"+PbCarrier+"^"+PbBlDr+"^"+BaFlag+"^"
			+ExpireLen+"^"+PrcFile+"^"+PrcFileDate+"^"+""+"^"+BookCatDr+"^"+""+"^"+""+"^"+""+"^"+""+"^"+StandCode+"^"
			+""+"^"+PackUom+"^"+PackUomFac+"^"+HighRiskFlag+"^"+NotUseReason+"^"+InsuType+"^"+Brand+"^"+Model+"^"+chargeFlag+"^"+Abbrev+"^"+Supervision+"^"+ImplantationMat+"^"+reqType+"^"+StkGrpType+"^"+NoLocReq+"^"+INFOSterile+"^"+INFOZeroStk+"^"+INFOChargeType+"^"+INFOMedEqptCat+"^"+IRRegCertExpDate+"^"+INFOPackCharge;
	listInc=listInc+"^"+ASP_STATUS+"^"+ASP;
	listInc = listInc + "^" + irRegCertItmDesc + "^" + irRegCertDateOfIssue + "^" + irRegCertExpDateExtended + "^" + irRegCertNoFull;
	listInc = listInc + "^" + bidDate + "^" + Origin + "^" + firstReqDept + "^" + SCategoryId + "^" + MatQualitydesc;
	listInc = listInc + "^" + INFOInterMat + "^" + INFOOrgan+"^"+StandardNameId + "^" + MatCatSpecial+"^"+INFORiskCategory+"^"+INFOConsumableLevel;
	listInc = listInc + "^" + INFOApplication + "^" + INFOFunction+ "^" +gRegRowId ;
	return listInc;
}
//��ȡ�ؼ�id��20170325
///�ؼ�id�иĶ�,��Ѵ˷����е�idͬ��;ͬʱ��"�����ֵ������ά��"�˵��еĿؼ�idҲһ��ͬ��
///���治��ʾ���ֶ�,����ֵ
function getidstr(){
	/*�����:����^����^������λid^��ⵥλid^������id^����^ת�Ʒ�ʽ^�Ƿ�Ҫ������^�Ƿ�Ҫ��Ч��^����
	         ^�����ñ�־^Э����^����^�ۼ�^����^��Ӧ�ֿ�^������������^��ע^�۸���Ч����^���
	         ^���ڱ�־^�������^�������^��/ʡ��^ע��֤��^��ֵ���־^��������id^����ۼ�^��Ժ����Ŀ¼^�б��־
	         ^�б����^�б꼶��^�б깩Ӧ��id^�б�������id^�б�������id^�б�����^һ���Ա�־^Ч�ڳ���^����ļ���^����ļ�����ʱ��
	         ^ע��֤����^�ʲ�����id^���ʱ�λ��^���װ��λ^���װ��λϵ��^��Σ��־^������ԭ��^ҽ�����^Ʒ��^�ͺ�
	         ^�շѱ�־^���^��ܼ���^ֲ���־^��ֹ�����־^���ʱ��^�����־^�շ�����^��е����^�����־
	*/
   var eleidstr="INCICode^INCIDesc^INCICTUom^PUCTUomPurch^StkCat^StkGrpType^INCIIsTrfFlag^INCIBatchReq^INCIExpReqnew^INCAlias"
                +"^INCINotUseFlag^INCIReportingDays^INCIBarCode^INCIBSpPuruom^INCIBRpPuruom^supplyLocField^reqType^remark^PreExeDate^INFOSpec"
                +"^INFOImportFlag^INFOQualityLevel^INFOQualityNo^INFOComFrom^INFORemark2^INFOHighPrice^INFOMT^INFOMaxSp^INFOInHosFlag^INFOPbFlag"
                +"^INFOPbRp^INFOPBLevel^INFOPbVendor^INFOPbManf^INFOPbCarrier^INFOPBLDR^INFOBAflag^INFOExpireLen^INFOPrcFile^INFOPriceBakD"
                +"^IRRegCertExpDate^INFOBCDr^INFODrugBaseCode^PackUom^PackUomFac^HighRiskFlag^ItmNotUseReason^^INFOBrand^INFOModel"
                +"^INFOChargeFlag^INFOAbbrev^INFOSupervision^INFOImplantationMat^INFONoLocReq^^INFOZeroStk^^^"
                +"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
   return eleidstr;
}
// ����������Ϣ 
function saveData() {
	if(!IsFormChanged(ItmPanel)){
		Msg.info("warning","������Ϣ����δ�����ı�!");
		return;
	}
	var INCIDesc = Ext.getCmp("INCIDesc").getValue();
	var BuomId = Ext.getCmp("INCICTUom").getValue();
	var PurUomId = Ext.getCmp("PUCTUomPurch").getValue();
	var StkGrpType = Ext.getCmp("StkGrpType").getValue();
	var StkCatId = Ext.getCmp("StkCat").getValue();
	var elemidstrs=getidstr();
	if (getElementInfo(elemidstrs,cspname,"N")==false){
	    return;
	}
	// �ж������Ƿ�Ϊ��
	
	/*if (INCIDesc == null || INCIDesc =="") {
		Msg.info("warning","�������Ʋ���Ϊ��!");	
		return;
	}
	//����������λ����Ϊ��
	
	if (BuomId == null || BuomId =="") {
		Msg.info("warning","����������λ����Ϊ��!");
		return;
	}
	//������װ��λ����Ϊ��
	
	if (PurUomId == null || PurUomId =="") {
		Msg.info("warning","�������ⵥλ����Ϊ��!");
		return;
	}
	//���鲻��Ϊ��
	
	if (StkGrpType == null || StkGrpType =="") {
		Msg.info("warning","���鲻��Ϊ��!");
		return;
	}
	//���������಻��Ϊ��
	
	if (StkCatId == null || StkCatId =="") {
		Msg.info("warning","���������಻��Ϊ��!");
		return;
	}*/
	var INCIBRpPuruom = Ext.getCmp("INCIBRpPuruom").getValue();
	var INCIBSpPuruom = Ext.getCmp("INCIBSpPuruom").getValue();
	if ((INCIBSpPuruom == null || INCIBSpPuruom ==="")&&gspreq=="Y") {
		Msg.info("warning","���ۼ۲���Ϊ��!");
		return;
	}
	
	var TableFlag = Ext.getCmp('HighRiskFlag').getValue();
	var HVFlag = Ext.getCmp('INFOHighPrice').getValue();
	if(TableFlag && !HVFlag){
		Msg.info('warning', '����ֵ�ĲĿ�ά����̨��־!');
		return false;
	}
	
	var MtDr=Ext.getCmp("INFOMT").getValue();	//��������
	if ((INCIBRpPuruom==INCIBSpPuruom & MtDr==="")&&gspreq=="Y") {
		Ext.Msg.show({
			title:'��ʾ',
			msg: '�Ƿ�ȷ�����ۼ۵��ڽ�����?',
			buttons: Ext.Msg.YESNO,
			fn: function(b,t,o){
				if (b=='yes'){Save();}
			},
			icon: Ext.MessageBox.QUESTION
		});
	}else {
		Save();
	}
}
function Save() {
	var listInc="";
	if(ItmPanel.rendered==true){
		listInc=getIncList();
	}	
	
	var url = "dhcstm.basicdruginfoaction.csp?actiontype=SaveDataInci";
	var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");			
	Ext.Ajax.request({
		url : url,
		params : {drugRowid:drugRowid,ListInc:listInc,NewItmRowId:gNewItmRowId},
		method : 'POST',
		waitMsg : '������...',
		failure:function(result, request) {
			 mask.hide();
			var jsonData = Ext.util.JSON.decode(result.responseText);
		},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			 mask.hide();
			if (jsonData.success == 'true') {
				var InciRowid = jsonData.info;
				drugRowid=InciRowid;
				Msg.info("success", "����ɹ�!");
				//���ݿ����ID��ѯ�������ϸ��Ϣ
				GetDetail(drugRowid);	
				//����ɹ���������ť����
				Ext.getCmp("IncAliasButton").setDisabled(false);
				Ext.getCmp("HospZeroStkButton").setDisabled(false);
				
			} else {

			    if(jsonData.info==-11){Msg.info("error", "ʧ��,�������벻��Ϊ��!");}
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
				else if(jsonData.info==-4){Msg.info("error", "��Ч�Ļ�����λ!");}
				else if(jsonData.info==-5){Msg.info("error", "��Ч����ⵥλ!");}
				else if(jsonData.info==-6){Msg.info("error", "���������Ѿ����ڣ������ظ�!");}
				else if(jsonData.info==-7){Msg.info("error", "����������Ѿ����ڣ������ظ�!");}
				else if(jsonData.info==-8){Msg.info("error", "������λ����ⵥλ֮�䲻����ת����ϵ!");}
				else if(jsonData.info==-9){Msg.info("error", "����������Ѿ����ڣ������ظ�!");}
				else if(jsonData.info==-100){Msg.info("error", "�����ʴ���δʹ����ɵĸ�ֵ����, ���ɱ����ֵ���!");}
				else{Msg.info("error", "����ʧ��:"+jsonData.info);}
			}
		},
		scope : this
	}); 
};
//���������Ƿ��Ѿ����ã��Ӷ������Ƿ������޸ļ۸�\������λ�Ͷ�������
function CheckItmUsed(rowid){
	var url = 'dhcstm.druginfomaintainaction.csp?actiontype=CheckItmUsed&IncRowid=' + rowid;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var ret = result.responseText;
			var jsonData = Ext.util.JSON.decode(ret);
			if (jsonData.success == 'true') {
				var useflag = jsonData.info;
				if(useflag==1){   //��ҵ�����ģ���ֹ�༭�۸�
					Ext.getCmp("INCICTUom").setDisabled(true);
					Ext.getCmp("INCIBSpPuruom").setDisabled(true);
					Ext.getCmp("INCIBRpPuruom").setDisabled(true);
					Ext.getCmp("PreExeDate").setDisabled(true);
					Ext.getCmp("INFOPrcFile").setDisabled(true);
					Ext.getCmp("INFOPriceBakD").setDisabled(true);
				}else{
					Ext.getCmp("INCICTUom").setDisabled(false);
					if (ASP_STATUS=='Yes')  //�Ѿ�������Ч�ģ���ֹ�༭�۸�
					{
						Ext.getCmp("INCIBSpPuruom").setDisabled(true);
						Ext.getCmp("INCIBRpPuruom").setDisabled(true);
						Ext.getCmp("PreExeDate").setDisabled(true);
						Ext.getCmp("INFOPrcFile").setDisabled(true);
						Ext.getCmp("INFOPriceBakD").setDisabled(true);
					}
					else
					{
						if (ASP=='')  //û�е��ۼ�¼�ģ���ֹ�༭�۸�
						{
							Ext.getCmp("INCIBSpPuruom").setDisabled(true);
							Ext.getCmp("INCIBRpPuruom").setDisabled(true);
							Ext.getCmp("PreExeDate").setDisabled(true);
							Ext.getCmp("INFOPrcFile").setDisabled(true);
							Ext.getCmp("INFOPriceBakD").setDisabled(true);
						}
						else
						{
							Ext.getCmp("INCIBSpPuruom").setDisabled(false);
							Ext.getCmp("INCIBRpPuruom").setDisabled(false);
							Ext.getCmp("PreExeDate").setDisabled(false);
							Ext.getCmp("INFOPrcFile").setDisabled(false);
							Ext.getCmp("INFOPriceBakD").setDisabled(false);
						}
					}
				}
			}
		},
		scope : this
	});
}
//���水ť
var saveButton = new Ext.Button({
	text : '����',
	tooltip : '�������',
	height:30,
	width:70,
	iconCls : 'page_save',
	handler : function() {
		// ����������Ϣ
		saveData();
	}
});
//��水ť
var addsaveButton = new Ext.Toolbar.Button({
	text : '���',
	tooltip : '������',
	height:30,
	width:70,
	iconCls : 'page_save',
	handler : function(b) {
		if (drugRowid=="")
		{
			Msg.info('warning','���Ȳ���һ���Ѵ�����Ŀ');
			return;
		}		
		else
		{
			drugRowid="";
			Ext.getCmp('INCICode').setValue('');
			Ext.getCmp('INCICTUom').setDisabled(false);
			
			//���ʱ,�۸���Ϣ�ſ�¼�벢���������Ϣ
			Ext.getCmp("INCIBRpPuruom").setDisabled(false);	
			Ext.getCmp("INCIBSpPuruom").setDisabled(false);	
			Ext.getCmp("PreExeDate").setDisabled(false);
			Ext.getCmp("PreExeDate").setValue("");//����۸���Ч����

			INCICode.fireEvent('blur');
			b.setDisabled(true);
			ASP="";
			APS_STATUS="";
		}
	}
});
var addButton = new Ext.Toolbar.Button({
	text : '�½�',
	tooltip : '����½�',
	iconCls : 'page_add',
	height:30,
	width:70,
	handler : function() {
		if(IsFormChanged(ItmPanel)){
			var ss=Ext.Msg.show({
			   title:'��ʾ',
			   msg: '������Ϣ�ѸĶ��������������������ĸĶ����Ƿ������',
			   buttons: Ext.Msg.YESNO,
			   fn: function(b,t,o){if (b=='yes')  clearData();		   
			   },
			   icon: Ext.MessageBox.QUESTION
			});	
		}else{
			clearData();
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
		Ext.Msg.show({title:'����',msg:'��ѡ��Ҫɾ�������ʣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
				msg : '�Ƿ�ȷ��ɾ����������Ϣ',
				buttons : Ext.MessageBox.YESNO,
				fn : showResult,
				icon : Ext.MessageBox.QUESTION
			});
		}							
	}
};
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
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '������...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info("success","ɾ���ɹ�!");
					gridSelected.getStore().remove(record);
					clearData();
				} else {
					var ret=jsonData.info;
					if(ret==-11){
						Msg.info("warning","�����Ѿ���ʹ�ã�����ɾ����");
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
};

//��ȡ����������
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

function SetMaxCode(newMaxCode,Cat,Scg,ScgDesc){
	Ext.MessageBox.confirm('��ʾ','�Ƿ����ý�����Ϣ?',function(btn){
		if (btn=='yes'){
			clearData();
			setV(newMaxCode,Cat,Scg,ScgDesc);
		}else{
			addsaveButton.handler(addsaveButton);
			setV(newMaxCode,Cat,Scg,ScgDesc);
		}
	});
	
	function setV(newMaxCode,Cat,Scg,ScgDesc){
		Ext.getCmp("INCICode").setValue(newMaxCode);
		if ((StkCat != "") && (Scg != "")) {
			Ext.getCmp("StkGrpType").setValue(Scg, ScgDesc);
			Ext.getCmp("StkCat").setValue(Cat);
		}
		INCICode.fireEvent('blur');
	}
}


var viewImage= new Ext.Toolbar.Button({
	text : '��ƷͼƬ',
	tooltip : '�鿴��ƷͼƬ',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		var inci=drugRowid;
		if ((inci=='')||(inci==undefined)) {
			Msg.info("error","��ѡ������!");
			return false;
		}
		var PicStore = new Ext.data.JsonStore({
			url : 'dhcstm.druginfomaintainaction.csp?actiontype=GetProductImage',
			root : 'rows',
			totalProperty : "results",
			fields : ["rowid", "inci","inciDesc", "picsrc","imgtype"]
		});
		var type="'product','productmaster'";
		ShowProductImageWindow(PicStore,inci,type);
	}
});

var LogBT = new Ext.ux.Button({
	text : '������־',
	tooltip : '�鿴������־',
	iconCls : 'page_find',
	handler : function() {
		Common_GetLog("User.INCItm", drugRowid);
	}
});

var NewItmInfoBtn = new Ext.ux.Button({
	text : '��Ʒ����',
	iconCls : 'page_gear',
	handler : function(){
		NewItmInfo(SetNewItmDetail);
	}
});

function SetNewItmDetail(NewItmObj){
	Ext.MessageBox.confirm('��ʾ','�Ƿ����ý�����Ϣ?', function(btn){
		if (btn=='yes'){
			clearData();
			SetNewItmInfo(NewItmObj);
		}else{
			SetNewItmInfo(NewItmObj);
		}
	});
	
	function SetNewItmInfo(NewItmObj){
		var NIRowId = NewItmObj.NIRowId;
		gNewItmRowId = NIRowId;
		var InciDesc = NewItmObj.NIDesc, Spec = NewItmObj.NISpec,
			Model = NewItmObj.NIModel, Brand = NewItmObj.NIBrand,
			Abbrev = NewItmObj.NIAbbrev,
			ImportFlag = NewItmObj.NIImportFlag, BAFlag = NewItmObj.NIBAFlag,
			HVFlag = NewItmObj.NIHighRiskFlag, ChargeFlag = NewItmObj.NIChargeFlag,
			ImplantFlag = NewItmObj.NIImplantationMat, ZeroStkFlag = NewItmObj.NIZeroStk;
		
		Ext.getCmp('INCIDesc').setValue(InciDesc);
		Ext.getCmp('INFOSpec').setValue(Spec);
		Ext.getCmp('INFOBrand').setValue(Brand);
		Ext.getCmp('INFOModel').setValue(Model);
		Ext.getCmp('INFOAbbrev').setValue(Abbrev);
		Ext.getCmp('INFOHighPrice').setValue(HVFlag=='Y');
		Ext.getCmp('INFOChargeFlag').setValue(ChargeFlag=='Y');
		Ext.getCmp('INFOImplantationMat').setValue(ImplantFlag=='Y');
		Ext.getCmp('INFOImportFlag').setValue(ImportFlag);
		Ext.getCmp('INFOBAflag').setValue(INFOBAflag=='Y');
		Ext.getCmp("INFOZeroStk").setValue(ZeroStkFlag=='Y');
	}
}

//============================�����=========================================================================
//���ûس������ת
function SpecialKeyHandler(e,fieldId){
	var keyCode=e.getKey();
	if(keyCode==e.ENTER){
		Ext.getCmp(fieldId).focus(true);
	}
};
var INCICode = new Ext.form.TextField({
	fieldLabel : '����',
	id : 'INCICode',
	name : 'INCICode',
	anchor : '90%',
	disabled:true,
	valueNotFoundText : '',
	listeners:{
		'specialkey':function(field,e){
		//SpecialKeyHandler(e,'INCIDesc');			
		}
	}
});
var INCIDesc = new Ext.form.TextField({
	fieldLabel : '����',//'<font color=red>*����</font>',
	id : 'INCIDesc',
	name : 'INCIDesc',
	anchor : '90%',
	disabled:true,
	valueNotFoundText : '',
	listeners:{
		'specialkey':function(field,e){
			 //SpecialKeyHandler(e,'INFOSpec');			
		}
	}
});
var INFOSpec = new Ext.form.TextField({
	fieldLabel :'���', // '<font color=red>*���</font>',
	id : 'INFOSpec',
	name : 'INFOSpec',
	anchor : '90%',
	valueNotFoundText : '',
	listeners:{
		'specialkey':function(field,e){
			//SpecialKeyHandler(e,'INCICTUom');			
		}
	}
});
var infoSpecButton = new Ext.Button({
	id:'InfoSpecButton',
	text : '�б�',
	width : 30,
	handler : function() {
		if(drugRowid!=""){
			IncSpecEdit("", drugRowid);	
		}else{
			Msg.info("warning","��ѡ����Ҫά�����Ŀ���");
			return;
		}					
	}
});
var INFOBrand = new Ext.form.TextField({
	fieldLabel : 'Ʒ��',
	id : 'INFOBrand',
	anchor : '90%'
});	
var INFOModel = new Ext.form.TextField({
	fieldLabel : '�ͺ�',
	id : 'INFOModel',
	name : 'INFOModel',
	anchor : '90%'
});	
var INFOAbbrev = new Ext.form.TextField({
	fieldLabel : '���',
	id : 'INFOAbbrev',
	anchor : '90%'
});
var INCICTUom = new Ext.ux.ComboBox({
	fieldLabel :  '������λ',///'<font color=red>*������λ</font>',
	id : 'INCICTUom',
	store : CTUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'CTUomDesc',
	listeners : {
		'specialkey':function(field,e){
			//SpecialKeyHandler(e,'PUCTUomPurch');			
		},
		'select':function(combo,record,index)
		{		
				var id=record.get("RowId");
				var desc=record.get("Description");
				addComboData(CONUomStore,id,desc);
				PUCTUomPurch.setValue(id);
		}
	}
});
var PUCTUomPurch = new Ext.ux.ComboBox({
	fieldLabel : '��ⵥλ',//'<font color=red>*��ⵥλ</font>',
	id : 'PUCTUomPurch',
	store : CONUomStore,
	filterName:'PUCTUomDesc',
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
			//SpecialKeyHandler(e,'StkCat');			
		}
	}
});
var PackUom = new Ext.ux.ComboBox({
	fieldLabel : '���װ��λ',
	id : 'PackUom',
	store : CTUomStore,
	filterName:'CTUomDesc'
});	

var PackUomFac = new Ext.form.NumberField({
	id : 'PackUomFac',
	anchor : '25%',
	valueNotFoundText : ''
});
var localstore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['REQUIRED', 'Ҫ��'], ['NONREQUIRED', '��Ҫ��'], ['OPTIONAL', '����']]
});
var INCIBatchReq = new Ext.form.ComboBox({
	fieldLabel : '����Ҫ��',  //'<font color=red>*����</font>',
	id : 'INCIBatchReq',
	store : localstore,
	valueField : 'RowId',
	displayField : 'Description',
	anchor:'90%',
	mode : 'local',
	triggerAction : 'all'
});
Ext.getCmp("INCIBatchReq").setValue('REQUIRED');
var ExpReqStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['REQUIRED', 'Ҫ��'], ['NONREQUIRED', '��Ҫ��'], ['OPTIONAL', '����']]
});
var INCIExpReqnew = new Ext.form.ComboBox({
	fieldLabel : '��Ч��Ҫ��', //'<font color=red>*��Ч��Ҫ��</font>',
	id : 'INCIExpReqnew',
	store : ExpReqStore,
	valueField : 'RowId',
	displayField : 'Description',
	anchor:'90%',
	mode : 'local',
	triggerAction : 'all'
});
Ext.getCmp("INCIExpReqnew").setValue('REQUIRED');
var INFOExpireLen = new Ext.form.NumberField({
	fieldLabel : 'Ч�ڳ���(��)',
	id : 'INFOExpireLen',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true
});
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
	fieldLabel:'����',//'<font color=red>*����</font>',
	id : 'StkGrpType',
	selectMode : 'leaf',
	isDefaultValue : false,
	StkType:App_StkTypeCode,
	UserId:gUserId,
	LocId:gLocId,
	anchor : '90%',
	//scgset:"'MO'",
	childCombo:'StkCat'
}); 
StkGrpType.on('change',function(field,newValue,oldValue){
	setgspreq(newValue);
});
function setgspreq(newValue){
	gspreq=tkMakeServerCall("web.DHCSTM.INCSTKCAT","GetSpReq",newValue);
	if(gspreq=="Y"){
		var label =Ext.getCmp('INCIBSpPuruom').getEl().parent().parent().first();    
		label.dom.innerHTML="<font color=red>*���ۼ�</font>"
	}else {
		var label =Ext.getCmp('INCIBSpPuruom').getEl().parent().parent().first();    
		label.dom.innerHTML ='���ۼ�:'; 
	}
}
// ������
var StkCat = new Ext.ux.ComboBox({
	fieldLabel : '������',  //'<font color=red>*������</font>',
	id : 'StkCat',
	name : 'StkCat',
	store : StkCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'StkCatName',
	params:{StkGrpId:'StkGrpType'}
});
var TransferStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['TRANS', 'Transfer Only'],
			['ISSUE', 'Issue Only'],
			['BOTH', 'Both Issue & Transfer']]
});
var INCIIsTrfFlag = new Ext.form.ComboBox({
	fieldLabel : 'ת�Ʒ�ʽ',//'<font color=red>*ת�Ʒ�ʽ</font>',
	id : 'INCIIsTrfFlag',
	store : TransferStore,
	valueField : 'RowId',
	displayField : 'Description',
	anchor:'90%',
	mode : 'local',
	hidden:true
});
Ext.getCmp('INCIIsTrfFlag').setValue('TRANS');
var INCIBarCode = new Ext.form.TextField({
	fieldLabel : '����',
	id : 'INCIBarCode',
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
		if(drugRowid!=""){
			IncAliasEdit("", drugRowid,INCAlias);	
		}else{
			Msg.info("warning","��ѡ����Ҫά�������Ŀ���");
			return;
		}					
	}
});
var INFOPBLevel = new Ext.ux.ComboBox({
	fieldLabel : '�б꼶��',
	id : 'INFOPBLevel',
	store : INFOPBLevelStore,
	childCombo: 'INFOPBLDR'
});

var INFOBCDr = new Ext.ux.ComboBox({
	fieldLabel : '�˲�����',
	id : 'INFOBCDr',
	store : BookCatStore
});
var INCIBRpPuruom = new Ext.ux.NumberField({
	formatType : 'FmtRP',
	fieldLabel : '������',
	id : 'INCIBRpPuruom',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true,
	enableKeyEvents : true,
	listeners : {
		keyup : function(field, e){
			var Rp = field.getValue();
			var MarkType = Ext.getCmp("INFOMT").getValue();
			if(MarkType==""){
				if(gspreq=="Y"){
				Ext.getCmp("INCIBSpPuruom").setValue(Rp);
				}
				return false;
			}
			if(drugRowid!=""){
				return false;
			}
			var MtSp = tkMakeServerCall("web.DHCSTM.Common.PriceCommon","GetMarkTypeSp",MarkType,Rp);
			if(gspreq=="Y"){
			Ext.getCmp("INCIBSpPuruom").setValue(MtSp);
			}
		}
	}
});
var INCIBSpPuruom = new Ext.ux.NumberField({
	formatType : 'FmtSP',
	// fieldLabel : '<font color=red>*���ۼ�</font>',
	fieldLabel : '���ۼ�',
	id : 'INCIBSpPuruom',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true
});
var PreExeDate = new Ext.ux.DateField({
	fieldLabel : '�۸���Ч����',
	id : 'PreExeDate',
	anchor : '90%',
	listeners:{
		'change':function(d,n,o)
		{
			var x=n.format(ARG_DATEFORMAT);
			var today=new Date().format(ARG_DATEFORMAT);
			if ((Date.parseDate(x,ARG_DATEFORMAT))<Date.parseDate(today,ARG_DATEFORMAT))
			{
				Msg.info("error","�۸���Ч���ڲ������ڽ���!");
				d.setValue(o);
			}
		}
	}
	});
var INFOPrcFile = new Ext.form.TextField({
	fieldLabel : '����ļ���',
	id : 'INFOPrcFile',
	anchor : '90%',
	valueNotFoundText : ''
});
var INCINotUseFlag = new Ext.form.Checkbox({
	fieldLabel : '������',
	id : 'INCINotUseFlag',
	anchor : '90%',		
	checked : false,
	listeners:{
		'check':function(c)
		{
			if (c.getValue()==true) {
				Ext.getCmp('ItmNotUseReason').setDisabled(false);
			}
			else
			{
				Ext.getCmp('ItmNotUseReason').setDisabled(true);
				Ext.getCmp('ItmNotUseReason').setValue("");
			}
		}
	}
	});
var ItmNotUseReason = new Ext.ux.ComboBox({
	id : 'ItmNotUseReason',
	store : ItmNotUseReasonStore,
	disabled:true
});
var packButton = new Ext.Button({
	text : '���װά��',
	height : 30,
	handler : function() {
	}
});
var ImportStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['����', '����'], ['����', '����'], ['����', '����']]
});
var INFOImportFlag = new Ext.form.ComboBox({
	fieldLabel : '���ڱ�־',
	id : 'INFOImportFlag',
	store : ImportStore,
	valueField : 'RowId',
	displayField : 'Description',
	anchor:'90%',
	mode : 'local'
});
var INFOQualityNo = new Ext.form.TextField({
	fieldLabel : '�ʱ���',
	id : 'INFOQualityNo',
	anchor : '90%',
	valueNotFoundText : ''
});		

var INFOMT = new Ext.ux.ComboBox({
	fieldLabel : '��������',
	id : 'INFOMT',
	store : MarkTypeStore,
	listeners:{
		'select' : function(index){
			var Rp = Ext.getCmp("INCIBRpPuruom").getValue();
			if(Rp===""){return;}
			if(drugRowid!=""){
				return false;
			}
			var MarkType = this.getValue();
			var MtSp = tkMakeServerCall("web.DHCSTM.Common.PriceCommon","GetMarkTypeSp",MarkType,Rp);
			Ext.getCmp("INCIBSpPuruom").setValue(MtSp);
		}
	}
});

var INFOMaxSp = new Ext.ux.NumberField({
	formatType : 'FmtSP',
	fieldLabel : '����ۼ�',
	id : 'INFOMaxSp',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true
});

var INFORemark1 = new Ext.ux.ComboBox({
	fieldLabel : '��׼�ĺ�',
	id : 'INFORemark1',
	anchor : '90%',
	store : INFORemarkStore
});
var INFORemark2 = new Ext.form.TextField({
	fieldLabel : 'ע��֤��',
	id : 'INFORemark2',
	anchor : '90%',
	listeners: {
	"blur" :function(field){
		var regNo=field.getValue();
		setRegInfo(regNo);
		}
}
});

function setRegInfo (regNo){
	var INFOPbManf=Ext.getCmp("INFOPbManf").getValue();
	if(Ext.isEmpty(drugRowid)){
		Msg.info("warning", "����ά������");
		return;
	}
	if(Ext.isEmpty(INFOPbManf)){
		Msg.info("warning", "����ά�����̣�");
		return;
	}
	if(Ext.isEmpty(regNo)){
		Msg.info("warning", "��������ע��֤�ţ�");
		return;
	}
	var regInfo=tkMakeServerCall('web.DHCSTM.DHCMatRegCert', 'getByRegNo',regNo);
	if(regInfo==0){
		RegNoInfo(regNo,setRegInfo,drugRowid,INFOPbManf)
		
	}else{
		var regInfoArr=regInfo.split("^");
		var RegRowId=regInfoArr[0], RegNo=regInfoArr[1],InciDesc=regInfoArr[2],ApprovalDate=regInfoArr[3],ValidUntil=regInfoArr[4];
		//Ext.getCmp('INFORemark2').setValue(certNo);
		gRegRowId=RegRowId
		Ext.getCmp('INFORemark2').setValue(RegNo);
		Ext.getCmp('IRRegCertExpDate').setValue(ApprovalDate);
		Ext.getCmp('IRRegCertItmDesc').setValue(InciDesc);
		Ext.getCmp('IRRegCertDateOfIssue').setValue(ValidUntil);
	}
}
var INFOComFrom = new Ext.form.TextField({
	fieldLabel : '��(ʡ)��',
	id : 'INFOComFrom',
	anchor : '90%'
});

var INFOQualityLevel = new Ext.ux.ComboBox({
	fieldLabel : '�������',
	id : 'INFOQualityLevel',
	anchor : '90%',
	store : INFOQualityLevelStore
});
var INCIReportingDays = new Ext.form.TextField({
	fieldLabel : 'Э����',
	id : 'INCIReportingDays',
	anchor : '90%'
});

var INFOPBLDR = new Ext.ux.ComboBox({
	fieldLabel : '�б�����',
	id : 'INFOPBLDR',
	anchor : '90%',
	store : PublicBiddingListStore,
	filterName: 'Desc',
	params: {PBLevel: 'INFOPBLevel'}
});
var INFOPbVendor = new Ext.ux.VendorComboBox({
	fieldLabel : '�б깩Ӧ��',
	id : 'INFOPbVendor',
	anchor : '90%',
	width:150,
	params : {ScgId : 'StkGrpType'}
});	
//��Ӧ�̸�����Ϣ
var VendorinfoBt = new Ext.Button({
	id : 'VendorinfoBt',
	text : '...',
	tooltip : '��Ӧ����ϸ��Ϣ',
	width : 20,
	tabIndex:390,
	handler : function() {	
		var PbVendor = Ext.getCmp("INFOPbVendor").getValue();
		if (PbVendor!=""){
			CreateEditWin(PbVendor);
		}else{
			Msg.info("warning","����ѡ��Ӧ�̣�")
		}
	}
});
	
var INFOPbManf = new Ext.ux.ComboBox({
	fieldLabel : '����',
	id : 'INFOPbManf',
	store : PhManufacturerStore,
	filterName:'PHMNFName',
	params : {ScgId : 'StkGrpType'}
});		
var INFOPbCarrier = new Ext.ux.ComboBox({
	fieldLabel : '�б�������',
	id : 'INFOPbCarrier',
	store : CarrierStore,
	filterName:'CADesc'
});		
var INFOPbRp = new Ext.ux.NumberField({
	formatType : 'FmtRP',
	fieldLabel : '�б����',
	id : 'INFOPbRp',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true
});
var remark = new Ext.form.TextArea({
	id:'remark',
	fieldLabel:'��ע',
	anchor:'90%',
	width : 330,
	selectOnFocus:true
});
var StandardName = new Ext.ux.ComboBox({
			id : 'StandardName',
			fieldLabel : '��׼����',
			store : StandardNameStore,
			filterName : 'Desc'
	})
var supplyLocField = new Ext.ux.LocComboBox({
	id:'supplyLocField',
	fieldLabel:'��Ӧ�ֿ�',
	anchor:'90%',
	listWidth:210,
	emptyText:'��Ӧ�ֿ�...',
	defaultLoc:{}
});
var TypeStore=new Ext.data.SimpleStore({
	fields:['RowId','Description'],
	data:[['O','��ʱ����'],['C','����ƻ�']]
});

var reqType=new Ext.form.ComboBox({
	id:'reqType',
	fieldLabel:'��������',
	store:TypeStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'������������...',
	triggerAction:'all',
	anchor:'90%',
	minChars:1,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	mode:'local'
});
var INFOPbFlag = new Ext.form.Checkbox({
	fieldLabel : '�Ƿ��б�',
	id : 'INFOPbFlag',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});
var INFOBAflag = new Ext.form.Checkbox({
	fieldLabel : 'һ���Ա�־',
	id : 'INFOBAflag',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});		
var INFOInHosFlag = new Ext.form.Checkbox({
	fieldLabel : '��Ժ����Ŀ¼',
	id : 'INFOInHosFlag',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});
var INFOHighPrice = new Ext.form.Checkbox({
	fieldLabel : '��ֵ���־',
	id : 'INFOHighPrice',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false,
	listeners: {
		'check': function(checkBox, checked) {
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
	fieldLabel : '�շѱ�־',
	id : 'INFOChargeFlag',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});

var INFOImplantationMat = new Ext.form.Checkbox({
	fieldLabel : 'ֲ���־',
	id : 'INFOImplantationMat',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
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

var INFONoLocReq = new Ext.form.Checkbox({
	fieldLabel : '��ֹ�����־',
	id : 'INFONoLocReq',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});
var INFOPriceBakD = new Ext.ux.DateField({
	fieldLabel : '��۱�������',
	id : 'INFOPriceBakD',
	anchor : '90%'
});
var INFODrugBaseCode = new Ext.form.TextField({
	fieldLabel : '���ʱ�λ��',
	id : 'INFODrugBaseCode',
	anchor : '90%'
});
var HighRiskFlag = new Ext.form.Checkbox({
	//fieldLabel : '��Σ���ʱ�־',
	//2016-11-16 ���ֶμ�¼'��̨��־'
	fieldLabel : '��̨��־',
	id : 'HighRiskFlag',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false,
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
var ItemPackUom={
	xtype: 'compositefield',								
	items : [
		PackUom,
		{ xtype: 'displayfield', value: '-ϵ��'},
		PackUomFac
	]
};

INFOZeroStk = new Ext.form.Checkbox({
	fieldLabel : '�����־',
	id : 'INFOZeroStk',
	anchor : '90%',
	checked : false
});
var HospZeroStk = new Ext.form.TextField({
	fieldLabel : 'Ժ������',
	id : 'HospZeroStk',
	name : 'HospZeroStk',
	width : 370,
	anchor : '90%',
	emptyText:'Ժ�������־��/����',
	disabled:true,
	valueNotFoundText : ''
});
var HospZeroStkButton = new Ext.Button({
	id:'HospZeroStkButton',
	tabIndex:441,
	text : 'ά��',
	width : 15,
	handler : function() {
		
		if(drugRowid!=""){
			HospZeroStkEdit("", drugRowid,HospZeroStk);	
		}else{
			Msg.info("warning","��ѡ����Ҫά�������־�Ŀ���");
			return;
		}					
	}
	
});
var IRRegCertExpDate = new Ext.ux.DateField({
	fieldLabel : 'ע��֤����',
	id : 'IRRegCertExpDate',
	anchor : '90%'
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


var PHCDOfficialType = new Ext.ux.ComboBox({
	fieldLabel : 'ҽ�����',
	id : 'PHCDOfficialType',
	mode:'local',
	store : OfficeCodeStore
});

var INFOSupervision = new Ext.form.ComboBox({
	fieldLabel : '��ܼ���',
	id : 'INFOSupervision',
	store : SupervisionStore,
	valueField : 'RowId',
	displayField : 'Description',
	anchor:'90%',
	mode : 'local',
	triggerAction : 'all'
});

var INFOSterileDateLen = new Ext.form.NumberField({
	fieldLabel : '���ʱ�䳤��',
	id : 'INFOSterileDateLen',
	anchor : '90%'
});

var INFOChargeType = new Ext.ux.ComboBox({
	fieldLabel : '�շ�����',
	id : 'INFOChargeType',
	anchor : '90%',
	store : INFOChargeTypeFlagStore,
	listeners:{
		'select':function(combo,record,index){
			var desc=record.get("Description")
			if(desc=="�ӳ��շ�"){
				INFOChargeFlag.setValue(true)
			}else{
				INFOChargeFlag.setValue(false)
			}
		}
	}
});

var INFOMedEqptCat = new Ext.ux.ComboBox({
	fieldLabel : '��е����',
	id : 'INFOMedEqptCat',
	store:MedEqptCatStore,
	filterName : 'Desc'
});

INFOPackCharge = new Ext.form.Checkbox({
	fieldLabel : '����շѱ�־',
	id : 'INFOPackCharge',
	anchor : '90%',
	checked : false
});

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
//�������
var MatCatSpecial=new Ext.ux.MatCatComboBox({ 
	fieldLabel : '�������',
	id:'MatCatSpecial',
	url : 'dhcstm.mulmatcataction.csp?actiontype=GetSpecialChildNode',
	rootId : 'AllMCS',
	rootParam : 'NodeId',
	selectMode : 'leaf',
	anchor: '90%'
});
//�������
var INFORiskCategory = new Ext.form.ComboBox({
		fieldLabel: '�������',
		id: 'INFORiskCategory',
		name: 'INFORiskCategory',
		store: RiskCategoryStore,
		valueField: 'RowId',
		displayField: 'Description',
		anchor: '90%',
		mode: 'local',
		triggerAction: 'all'
	});
//�Ĳļ���
var INFOConsumableLevel = new Ext.form.ComboBox({
		fieldLabel: '�Ĳļ���',
		id: 'INFOConsumableLevel',
		name: 'INFOConsumableLevel',
		store: ConsumableLevelStore,
		valueField: 'RowId',
		displayField: 'Description',
		anchor: '90%',
		mode: 'local',
		triggerAction: 'all'
	});
//��;
var INFOApplication = new Ext.form.TextField({
		fieldLabel: '��;',
		id: 'INFOApplication',
		name: 'INFOApplication',
		anchor: '90%',
		width: 370,
		valueNotFoundText: ''
	});
//����
var INFOFunction = new Ext.form.TextField({
		fieldLabel: '����',
		id: 'INFOFunction',
		name: 'INFOFunction',
		anchor: '90%',
		width: 370,
		valueNotFoundText: ''
	});
//�����Panel 
 var ItmPanel = new Ext.form.FormPanel({
	labelWidth : 100,
	labelAlign : 'right',
	autoScroll:true,
	frame : true,
	defaults:{style:'padding:0px,0px,0px,0px',border:true},
	items : [{
		layout : 'column',
		xtype:'fieldset',
		style:'padding:5px,0px,0px,0px',
		defaults:{border:false},
		items : [{
			columnWidth : 0.5,
			xtype:'fieldset',
			items : [INCICode,{xtype : 'compositefield',items:[INFOSpec,infoSpecButton]},INFOBrand,PUCTUomPurch,INCIBatchReq,INFOExpireLen,INFOPbManf,INCIBRpPuruom,PreExeDate,INCIBarCode,
			INFODrugBaseCode,INFOImportFlag,INFOQualityNo,INFOMaxSp,INFOQualityLevel,INFOPBLDR,
			INFOPbRp,supplyLocField,INFOSupervision,INFORemark2,IRRegCertExpDate,IRRegCertItmDesc,IRRegCertDateOfIssue,IRRegCertExpDateExtended,
			INFORiskCategory,INFOConsumableLevel]
		},{ 
			columnWidth : 0.5,
			xtype:'fieldset',
			items : [INCIDesc,INFOModel,INCICTUom,StkGrpType,StkCat,MatCatSpecial,INCIExpReqnew,INCIIsTrfFlag,INFOBCDr,INCIBSpPuruom,INFOPrcFile,INFOPriceBakD,
			INFOMT,INFOComFrom,INCIReportingDays,{xtype : 'compositefield',items:[INFOPbVendor,VendorinfoBt]},INFOPbCarrier,BidDate,INFOPBLevel,INFOAbbrev,reqType,
			Origin,SCategory,MatQuality,remark]
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
			items : [INFOISCDR,iscButton]
		},{
			xtype: 'compositefield',
			items: [INFOApplication]
		},{
			xtype: 'compositefield',
			items: [INFOFunction]
		}]
	}, {
		layout : 'column',
		xtype:'fieldset',
		style:'padding:5px,0px,0px,0px',
		defaults:{border:false},
		items : [{
			columnWidth : .2,
			xtype:'fieldset',
			items : [INFOPbFlag,INFOBAflag]
		}, {
			columnWidth : .2,
			xtype:'fieldset',
			items : [INFOHighPrice,HighRiskFlag]
		}, {
			columnWidth : .2,
			xtype:'fieldset',
			items : [INFOInHosFlag,INFOChargeFlag]
		}, {
			columnWidth : .2,
			xtype:'fieldset',
			items : [INFOImplantationMat,INFONoLocReq]
		}, {
			columnWidth: .2,
			xtype: 'fieldset',
			items: [INFOInterMat, INFOOrgan]
		}]
	},{
		layout : 'column',
		xtype:'fieldset',
		style:'padding:5px,0px,0px,0px',
		defaults:{border:false},
		items:[{
			columnWidth:1,
			xtype:'fieldset',
			items:[{
				xtype : 'compositefield',
				items : [INCINotUseFlag,ItmNotUseReason]
			},{
				xtype : 'compositefield',
				items : [INFOZeroStk,FirstReqDept]
				
			},{
				columnWidth:1,
				xtype:'compositefield',
				items:[HospZeroStk,HospZeroStkButton]
			}]
		}]
	}]
});

/*����Ƿ����ĳ�����ĳ����-������Ŀ*/
function ItmCheck(code,desc,spec)
{
 var cls="web.DHCSTM.INCITM";
 var method="ItmCheck";
 var exists=tkMakeServerCall(cls,method,code,desc,spec);
 return exists;
}
//============================�����===================================//
var talPanel = new Ext.TabPanel({
	activeTab : 0,
	deferredRender : true,
	split:true,
	region : 'east',
	width: 660,
	tbar : [addButton,'-',saveButton,'-',GetMaxCodeBT,'-',viewImage,'-',addsaveButton,'-',LogBT,'-',NewItmInfoBtn],	///DeleteBT
	items : [ {
		layout : 'fit',
		title : '�����',
		items : [ItmPanel]
	}]
});


setEnterTab(ItmPanel);