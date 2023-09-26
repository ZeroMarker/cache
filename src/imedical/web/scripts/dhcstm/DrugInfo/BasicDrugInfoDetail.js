//根据库存项Rowid查询
var RowDelim=xRowDelim();
var storeConRowId="";
var gspreq="" ;  ///是否需要维护零售价
var userId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var cspname=App_MenuCspName;

var ASP_STATUS="";
var ASP="";
var gNewItmRowId = '';		//新品立项id,全局变量
var gRegRowId='';
		
function GetDetail(rowid){
	var url = 'dhcstm.druginfomaintainaction.csp?actiontype=GetDetail&InciRowid='+rowid;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '查询中...',
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
				Msg.info("error", "查询错误:"+jsonData.info);
			}
		},
		scope : this
	});
}
//查询库存项信息
function SetIncDetail(listData) {
	if(listData==null || listData==""){
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
		addComboData(StkCatStore,list[7],list[8]);
		Ext.getCmp("StkCat").setValue(list[7]);  //库存分类
		Ext.getCmp("INCIIsTrfFlag").setValue(list[9]); //转移方式
		Ext.getCmp("INCIBatchReq").setValue(list[10]); //批次
		Ext.getCmp("INCIExpReqnew").setValue(list[11]); //有效期 
		Ext.getCmp("INCAlias").setValue(list[12]); //别名
		Ext.getCmp("INCINotUseFlag").setValue(list[13]=='Y'?true:false); //不可用标志
		Ext.getCmp("INCIReportingDays").setValue(list[14]); //协和码
		Ext.getCmp("INCIBarCode").setValue(list[15]); //条码
		Ext.getCmp("INCIBSpPuruom").setValue(list[18]); //售价
		Ext.getCmp("INCIBRpPuruom").setValue(list[19]); //进价
		addComboData(Ext.getCmp("supplyLocField").getStore(),list[20],list[21]); //供应仓库
		Ext.getCmp("supplyLocField").setValue(list[20]);
		Ext.getCmp("remark").setValue(handleMemo(list[22],xMemoDelim())); //备注handleMemo(dataArr[10],xMemoDelim())
		Ext.getCmp("INFOImportFlag").setValue(list[23]); //进口标志 
		addComboData(INFOQualityLevelStore,list[74],list[24]);
		Ext.getCmp("INFOQualityLevel").setValue(list[74]);
		Ext.getCmp("INFOQualityNo").setValue(list[30]);
		Ext.getCmp("INFOComFrom").setValue(list[31]);
		Ext.getCmp("INFORemark2").setValue(list[32]);		//注册证号
		Ext.getCmp("INFOHighPrice").setValue(list[33]=='Y'?true:false); //高值类标志
		Ext.getCmp("INFOMT").setValue(list[35]); //定价类型id
		Ext.getCmp("INFOMT").setRawValue(list[36]); //定价类型
		Ext.getCmp("INFOMaxSp").setValue(list[37]); //最高售价
		storeConRowId=list[38];//存储条件id
		Ext.getCmp("INFOISCDR").setValue(getStoreConStr(drugRowid));//存储条件
		Ext.getCmp("INFOInHosFlag").setValue(list[39]=='Y'?true:false); //本院物资目录
		Ext.getCmp("INFOPbFlag").setValue(list[40]=='Y'?true:false); //招标标志
		Ext.getCmp("INFOPbRp").setValue(list[41]); //招标进价		
		addComboData(INFOPBLevelStore,list[73],list[42]);
		Ext.getCmp("INFOPBLevel").setValue(list[73]); //招标级别
		addComboData(INFOPbVendor.getStore(),list[43],list[44]);
		Ext.getCmp("INFOPbVendor").setValue(list[43]);
		addComboData(PhManufacturerStore,list[45],list[46]);
		Ext.getCmp("INFOPbManf").setValue(list[45]);
		addComboData(CarrierStore,list[47],list[48]);
		Ext.getCmp("INFOPbCarrier").setValue(list[47]);							
		Ext.getCmp("INFOPBLDR").setValue(list[49]);
		Ext.getCmp("INFOBAflag").setValue(list[51]=='Y'?true:false); //一次性标志
		Ext.getCmp("INFOExpireLen").setValue(list[52]);
		Ext.getCmp("INFOPrcFile").setValue(list[53]);
		Ext.getCmp("INFOPriceBakD").setValue(list[54]);    //物价文件日期
		Ext.getCmp("INFOBCDr").setValue(list[56]); //帐簿分类id
		Ext.getCmp("INFOBCDr").setRawValue(list[57]); //帐簿分类 
		Ext.getCmp("INFODrugBaseCode").setValue(list[62]); //物资本位码
		Ext.getCmp("INFOSpec").setValue(list[64]); //规格
		addComboData(ItmNotUseReasonStore,list[65],list[66]);
		Ext.getCmp("ItmNotUseReason").setValue(list[65]); //不可用原因
		Ext.getCmp("PHCDOfficialType").setValue(list[67]); //医保类别
		Ext.getCmp("HighRiskFlag").setValue(list[69]=='Y'?true:false); //高危标志
		addComboData(CTUomStore,list[70],list[71]);
		Ext.getCmp("PackUom").setValue(list[70]); //大包装单位
		Ext.getCmp("PackUomFac").setValue(list[72]); //大包装单位系数
		Ext.getCmp("INFOBrand").setValue(list[75]); //品牌
		Ext.getCmp("INFOModel").setValue(list[76]); //型号
		Ext.getCmp("INFOChargeFlag").setValue(list[77]=='Y'?true:false); //收费标志
		Ext.getCmp("INFOAbbrev").setValue(list[78]); //简称
		Ext.getCmp("INFOSupervision").setValue(list[79]); //监管级别
		Ext.getCmp("INFOImplantationMat").setValue(list[80]=='Y'?true:false); //植入标志
		Ext.getCmp("reqType").setValue(list[81]); //物资请求类型
		Ext.getCmp("INFONoLocReq").setValue(list[82]=='Y'?true:false); //禁止请领标志
		Ext.getCmp("INFOSterileDateLen").setValue(list[83]);  //灭菌时间
		Ext.getCmp("INFOZeroStk").setValue(list[84]=='Y'?true:false); //零库存标志
		addComboData(INFOChargeTypeFlagStore,list[85],list[86]);
		Ext.getCmp("INFOChargeType").setValue(list[85]); //收费类型
		//Ext.getCmp("INFOMedEqptCat").setValue(list[87]);  //器械分类
		Ext.getCmp("IRRegCertExpDate").setValue(list[88]); //注册证效期
		Ext.getCmp("INFOPackCharge").setValue(list[89]);  //打包收费标志 
		Ext.getCmp("PreExeDate").setValue(list[93]);	//价格生效日期
		addComboData(Ext.getCmp("StkGrpType").getStore(),list[94],list[95],StkGrpType);
		Ext.getCmp("StkGrpType").setValue(list[94]);	//类组
		setgspreq(list[94]) ;
		
		ASP_STATUS=list[96];
		ASP=list[97];
		Ext.getCmp("HospZeroStk").setValue(list[98]); //院区零库存标志
		
		var regData = list[90].split("|");
		var regItmDesc = regData[0];
		var regDateOfIssue = regData[1];
		var regExpExtended = (regData[2] == 'Y' ? true : false);
		Ext.getCmp("SCategory").setValue(list[99]); //灭菌分类id
		Ext.getCmp("SCategory").setRawValue(list[100]); //灭菌分类
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
		Ext.getCmp("StandardName").setValue(StandardId); //标准名称
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
		Ext.getCmp("MatCatSpecial").setValue(list[102]); //特殊分类
		Ext.getCmp("INFORiskCategory").setValue(list[104]); //风险类别
		Ext.getCmp("INFOConsumableLevel").setValue(list[105]); //耗材级别
		Ext.getCmp("INFOApplication").setValue(list[106]);//用途
		Ext.getCmp("INFOFunction").setValue(list[107]);//功能
		gRegRowId=list[108]
		addsaveButton.setDisabled(false);  //另存按钮
	}
}
//清空库存项信息
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
		
		HospZeroStk.setValue("");//院区零库存标志
		
		IRRegCertItmDesc.setValue("");
		HospZeroStk.setValue(""); //院区零库存标志
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
//初始化界面
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
	var elemidstr=getidstr();//初始化必填项
	changeElementInfo(elemidstr,cspname);
	Ext.getCmp("StkGrpType").setValue("");
	
	//若仅有一个可用的定价类型,则默认显示
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

//获取库存项信息
function getIncList(){
	// 库存项数据串:代码^名称^基本单位id^入库单位id^库存分类id^转移方式^是否要求批次^是否要求效期^别名^不可用标志^协和码^条码^更新人^售价^进价^供应仓库^备注^价格生效日期^进口标志^质量层次
	// ^质量编号^国/省别^批准文号^高值类标志^定价类型id^最高售价^存储条件^本院物资目录^招标标志^招标进价^招标级别^招标供应商id^招标生产商id^招标配送商id^招标名称
	// ^阳光采购标志^效期长度^物价文件号^物价文件备案时间^帐簿分类id^物资本位码^规格
	var iNCICode = Ext.getCmp("INCICode").getValue();	 //库存代码
	var iNCIDesc = Ext.getCmp("INCIDesc").getValue();	 //库存名称
	var BillUomId = Ext.getCmp("INCICTUom").getValue();	//基本单位		
	var PurUomId=Ext.getCmp("PUCTUomPurch").getValue(); //入库单位
	var StkCatId=Ext.getCmp("StkCat").getValue(); //库存分类id
	var StkGrpType=Ext.getCmp("StkGrpType").getValue(); //类组
	var TransFlag=Ext.getCmp("INCIIsTrfFlag").getValue(); //转移方式
	var BatchFlag=Ext.getCmp("INCIBatchReq").getValue(); //批次
	var ExpireFlag=Ext.getCmp("INCIExpReqnew").getValue(); //有效期	
	var AliasStr=Ext.getCmp("INCAlias").getValue(); //别名
	var NotUseFlag=(Ext.getCmp("INCINotUseFlag").getValue()==true?'Y':'N'); //不可用标志
	var XieHeCode=Ext.getCmp("INCIReportingDays").getValue();	//协和码
	var BarCode=Ext.getCmp("INCIBarCode").getValue();//条码	
	var Sp=Ext.getCmp("INCIBSpPuruom").getValue(); //零售价
	var Rp=Ext.getCmp("INCIBRpPuruom").getValue(); //进价
	var SupplyLocField=Ext.getCmp("supplyLocField").getValue(); //供应仓库
	var reqType=Ext.getCmp("reqType").getValue(); //物资请求类型
	var Remarks=Ext.getCmp("remark").getValue(); //备注
	Remarks=Remarks.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	var PreExeDate=Ext.getCmp("PreExeDate").getValue(); //价格生效日期
	if((PreExeDate!="")&&(PreExeDate!=null)){
		PreExeDate = PreExeDate.format(ARG_DATEFORMAT);
	}
	var Spec=Ext.getCmp("INFOSpec").getValue();//规格
	var INFOImportFlag=Ext.getCmp("INFOImportFlag").getValue(); //进口标志
	var QualityLevel=Ext.getCmp("INFOQualityLevel").getValue(); //质量层次
	var QualityNo=Ext.getCmp("INFOQualityNo").getValue();//质标编号
	var ComFrom=Ext.getCmp("INFOComFrom").getValue();//国别/省别
	var Remark=Ext.getCmp("INFORemark2").getValue();//注册证号
	var HighPrice=(Ext.getCmp("INFOHighPrice").getValue()==true?'Y':'N');//高值类标志
	var MtDr=Ext.getCmp("INFOMT").getValue();//定价类型
	var MaxSp = Ext.getCmp("INFOMaxSp").getValue();//最高售价
	var StoreConDr=storeConRowId;//存储条件
	var InHosFlag=(Ext.getCmp("INFOInHosFlag").getValue()==true?'Y':'N');//本院物资目录
	var PbFlag=(Ext.getCmp("INFOPbFlag").getValue()==true?'Y':'N');//招标标志	
	var PbRp=Ext.getCmp("INFOPbRp").getValue();//招标进价
	var PbLevel=Ext.getCmp("INFOPBLevel").getValue();//招标级别
	var PbVendorId=Ext.getCmp("INFOPbVendor").getValue();//招标供应商
	var PbManfId=Ext.getCmp("INFOPbManf").getValue();//招标生产商
	var PbCarrier=Ext.getCmp("INFOPbCarrier").getValue();//招标配送商
	var PbBlDr=Ext.getCmp("INFOPBLDR").getValue();//招标名称
	var BaFlag=(Ext.getCmp("INFOBAflag").getValue()==true?'Y':'N');//一次性标志
	var ExpireLen=Ext.getCmp("INFOExpireLen").getValue();//效期长度
	var PrcFile=Ext.getCmp("INFOPrcFile").getValue();//物价文件号
	var PrcFileDate=Ext.getCmp("INFOPriceBakD").getValue();//物价文件备案日期
	if((PrcFileDate!="")&&(PrcFileDate!=null)){
		PrcFileDate = PrcFileDate.format(ARG_DATEFORMAT);
	}
	var IRRegCertExpDate=Ext.getCmp("IRRegCertExpDate").getValue(); //注册证日期
	if((IRRegCertExpDate!="")&&(IRRegCertExpDate!=null)){
		IRRegCertExpDate = IRRegCertExpDate.format(ARG_DATEFORMAT);
	}
	var BookCatDr=Ext.getCmp("INFOBCDr").getValue();//账簿分类
	var StandCode=Ext.getCmp("INFODrugBaseCode").getValue();//物资本位码
	var PackUom=Ext.getCmp("PackUom").getValue();//大包装单位
	var PackUomFac=Ext.getCmp("PackUomFac").getValue();//大包装单位系数
	var HighRiskFlag=(Ext.getCmp("HighRiskFlag").getValue()==true?'Y':'N');//高危标志	
	var NotUseReason=Ext.getCmp("ItmNotUseReason").getValue();//不可用原因
	var InsuType=Ext.getCmp("PHCDOfficialType").getValue(); //医保类别
	var Brand=Ext.getCmp("INFOBrand").getValue();	//品牌
	var Model=Ext.getCmp("INFOModel").getValue();	//型号
	var chargeFlag=(Ext.getCmp("INFOChargeFlag").getValue()==true?'Y':'N');	//收费标志
	var Abbrev=Ext.getCmp("INFOAbbrev").getValue();	//简称
	var Supervision=Ext.getCmp("INFOSupervision").getValue();	//监管级别
	var ImplantationMat=(Ext.getCmp("INFOImplantationMat").getValue()==true?'Y':'N');	//植入标志
	var NoLocReq=(Ext.getCmp("INFONoLocReq").getValue()==true?'Y':'N');	//禁止请领标志
	var INFOSterile=Ext.getCmp("INFOSterileDateLen").getValue();  //灭菌时间
	var INFOZeroStk=(Ext.getCmp("INFOZeroStk").getValue()==true?'Y':'N');	//零库存标志
	var INFOChargeType=Ext.getCmp("INFOChargeType").getValue(); //收费类型
	var INFOMedEqptCat=Ext.getCmp("INFOMedEqptCat").getValue();    //器械分类
	var INFOPackCharge=(Ext.getCmp("INFOPackCharge").getValue()==true?'Y':'N');	//打包标志
	
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
	var firstReqDept = Ext.getCmp('FirstReqDept').getValue(); //首请部门
	var SCategoryId = Ext.getCmp('SCategory').getValue();
	var MatQualitydesc = Ext.getCmp('MatQuality').getValue();
	var INFOInterMat=Ext.getCmp('INFOInterMat').getValue()?'Y':'N';		//介入标志
	var INFOOrgan=Ext.getCmp('INFOOrgan').getValue()?'Y':'N';			//人工器官
	var StandardNameId=Ext.getCmp('StandardName').getValue();
	var MatCatSpecial=Ext.getCmp("MatCatSpecial").getValue();  ///特殊分类
	var INFORiskCategory = Ext.getCmp("INFORiskCategory").getValue(); 		//风险类别
	var INFOConsumableLevel = Ext.getCmp("INFOConsumableLevel").getValue(); //耗材级别
	var INFOApplication = Ext.getCmp("INFOApplication").getValue(); 		//用途
	var INFOFunction = Ext.getCmp("INFOFunction").getValue(); 				//功能
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
//获取控件id串20170325
///控件id有改动,请把此方法中的id同步;同时将"基础字典必填项维护"菜单中的控件id也一起同步
///界面不显示的字段,传空值
function getidstr(){
	/*库存项:代码^名称^基本单位id^入库单位id^库存分类id^类组^转移方式^是否要求批次^是否要求效期^别名
	         ^不可用标志^协和码^条码^售价^进价^供应仓库^物资请求类型^备注^价格生效日期^规格
	         ^进口标志^质量层次^质量编号^国/省别^注册证号^高值类标志^定价类型id^最高售价^本院物资目录^招标标志
	         ^招标进价^招标级别^招标供应商id^招标生产商id^招标配送商id^招标名称^一次性标志^效期长度^物价文件号^物价文件备案时间
	         ^注册证日期^帐簿分类id^物资本位码^大包装单位^大包装单位系数^高危标志^不可用原因^医保类别^品牌^型号
	         ^收费标志^简称^监管级别^植入标志^禁止请领标志^灭菌时间^零库存标志^收费类型^器械分类^打包标志
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
// 保存库存项信息 
function saveData() {
	if(!IsFormChanged(ItmPanel)){
		Msg.info("warning","物资信息数据未发生改变!");
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
	// 判断名称是否为空
	
	/*if (INCIDesc == null || INCIDesc =="") {
		Msg.info("warning","物资名称不能为空!");	
		return;
	}
	//库存项基本单位不能为空
	
	if (BuomId == null || BuomId =="") {
		Msg.info("warning","库存项基本单位不能为空!");
		return;
	}
	//库存项包装单位不能为空
	
	if (PurUomId == null || PurUomId =="") {
		Msg.info("warning","库存项入库单位不能为空!");
		return;
	}
	//类组不能为空
	
	if (StkGrpType == null || StkGrpType =="") {
		Msg.info("warning","类组不能为空!");
		return;
	}
	//库存项库存分类不能为空
	
	if (StkCatId == null || StkCatId =="") {
		Msg.info("warning","库存项库存分类不能为空!");
		return;
	}*/
	var INCIBRpPuruom = Ext.getCmp("INCIBRpPuruom").getValue();
	var INCIBSpPuruom = Ext.getCmp("INCIBSpPuruom").getValue();
	if ((INCIBSpPuruom == null || INCIBSpPuruom ==="")&&gspreq=="Y") {
		Msg.info("warning","零售价不能为空!");
		return;
	}
	
	var TableFlag = Ext.getCmp('HighRiskFlag').getValue();
	var HVFlag = Ext.getCmp('INFOHighPrice').getValue();
	if(TableFlag && !HVFlag){
		Msg.info('warning', '仅高值耗材可维护跟台标志!');
		return false;
	}
	
	var MtDr=Ext.getCmp("INFOMT").getValue();	//定价类型
	if ((INCIBRpPuruom==INCIBSpPuruom & MtDr==="")&&gspreq=="Y") {
		Ext.Msg.show({
			title:'提示',
			msg: '是否确定零售价等于进货价?',
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
	var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");			
	Ext.Ajax.request({
		url : url,
		params : {drugRowid:drugRowid,ListInc:listInc,NewItmRowId:gNewItmRowId},
		method : 'POST',
		waitMsg : '保存中...',
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
				Msg.info("success", "保存成功!");
				//根据库存项ID查询库存项明细信息
				GetDetail(drugRowid);	
				//保存成功后下述按钮可用
				Ext.getCmp("IncAliasButton").setDisabled(false);
				Ext.getCmp("HospZeroStkButton").setDisabled(false);
				
			} else {

			    if(jsonData.info==-11){Msg.info("error", "失败,库存项代码不能为空!");}
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
				else if(jsonData.info==-4){Msg.info("error", "无效的基本单位!");}
				else if(jsonData.info==-5){Msg.info("error", "无效的入库单位!");}
				else if(jsonData.info==-6){Msg.info("error", "库存项代码已经存在，不能重复!");}
				else if(jsonData.info==-7){Msg.info("error", "库存项名称已经存在，不能重复!");}
				else if(jsonData.info==-8){Msg.info("error", "基本单位和入库单位之间不存在转换关系!");}
				else if(jsonData.info==-9){Msg.info("error", "库存项条码已经存在，不能重复!");}
				else if(jsonData.info==-100){Msg.info("error", "该物资存在未使用完成的高值条码, 不可变更高值标记!");}
				else{Msg.info("error", "保存失败:"+jsonData.info);}
			}
		},
		scope : this
	}); 
};
//检测该物资是否已经在用，从而决定是否允许修改价格\基本单位和定价类型
function CheckItmUsed(rowid){
	var url = 'dhcstm.druginfomaintainaction.csp?actiontype=CheckItmUsed&IncRowid=' + rowid;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var ret = result.responseText;
			var jsonData = Ext.util.JSON.decode(ret);
			if (jsonData.success == 'true') {
				var useflag = jsonData.info;
				if(useflag==1){   //有业务发生的，禁止编辑价格
					Ext.getCmp("INCICTUom").setDisabled(true);
					Ext.getCmp("INCIBSpPuruom").setDisabled(true);
					Ext.getCmp("INCIBRpPuruom").setDisabled(true);
					Ext.getCmp("PreExeDate").setDisabled(true);
					Ext.getCmp("INFOPrcFile").setDisabled(true);
					Ext.getCmp("INFOPriceBakD").setDisabled(true);
				}else{
					Ext.getCmp("INCICTUom").setDisabled(false);
					if (ASP_STATUS=='Yes')  //已经调价生效的，禁止编辑价格
					{
						Ext.getCmp("INCIBSpPuruom").setDisabled(true);
						Ext.getCmp("INCIBRpPuruom").setDisabled(true);
						Ext.getCmp("PreExeDate").setDisabled(true);
						Ext.getCmp("INFOPrcFile").setDisabled(true);
						Ext.getCmp("INFOPriceBakD").setDisabled(true);
					}
					else
					{
						if (ASP=='')  //没有调价记录的，禁止编辑价格
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
//保存按钮
var saveButton = new Ext.Button({
	text : '保存',
	tooltip : '点击保存',
	height:30,
	width:70,
	iconCls : 'page_save',
	handler : function() {
		// 保存库存项信息
		saveData();
	}
});
//另存按钮
var addsaveButton = new Ext.Toolbar.Button({
	text : '另存',
	tooltip : '点击另存',
	height:30,
	width:70,
	iconCls : 'page_save',
	handler : function(b) {
		if (drugRowid=="")
		{
			Msg.info('warning','请先查找一个已存在项目');
			return;
		}		
		else
		{
			drugRowid="";
			Ext.getCmp('INCICode').setValue('');
			Ext.getCmp('INCICTUom').setDisabled(false);
			
			//另存时,价格信息放开录入并清除调价信息
			Ext.getCmp("INCIBRpPuruom").setDisabled(false);	
			Ext.getCmp("INCIBSpPuruom").setDisabled(false);	
			Ext.getCmp("PreExeDate").setDisabled(false);
			Ext.getCmp("PreExeDate").setValue("");//处理价格生效日期

			INCICode.fireEvent('blur');
			b.setDisabled(true);
			ASP="";
			APS_STATUS="";
		}
	}
});
var addButton = new Ext.Toolbar.Button({
	text : '新建',
	tooltip : '点击新建',
	iconCls : 'page_add',
	height:30,
	width:70,
	handler : function() {
		if(IsFormChanged(ItmPanel)){
			var ss=Ext.Msg.show({
			   title:'提示',
			   msg: '物资信息已改动，若继续将放弃已做的改动，是否继续？',
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
		Ext.Msg.show({title:'错误',msg:'请选择要删除的物资！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
				msg : '是否确定删除该物资信息',
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
		// 删除该行数据
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=DeleteData&InciRowid="
				+ InciRowid;
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '处理中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				mask.hide();
				if (jsonData.success == 'true') {
					Msg.info("success","删除成功!");
					gridSelected.getStore().remove(record);
					clearData();
				} else {
					var ret=jsonData.info;
					if(ret==-11){
						Msg.info("warning","物资已经在使用，不能删除！");
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
};

//获取库存项最大码
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

function SetMaxCode(newMaxCode,Cat,Scg,ScgDesc){
	Ext.MessageBox.confirm('提示','是否重置界面信息?',function(btn){
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
	text : '产品图片',
	tooltip : '查看产品图片',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		var inci=drugRowid;
		if ((inci=='')||(inci==undefined)) {
			Msg.info("error","请选择物资!");
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
	text : '数据日志',
	tooltip : '查看数据日志',
	iconCls : 'page_find',
	handler : function() {
		Common_GetLog("User.INCItm", drugRowid);
	}
});

var NewItmInfoBtn = new Ext.ux.Button({
	text : '新品立项',
	iconCls : 'page_gear',
	handler : function(){
		NewItmInfo(SetNewItmDetail);
	}
});

function SetNewItmDetail(NewItmObj){
	Ext.MessageBox.confirm('提示','是否重置界面信息?', function(btn){
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

//============================库存项=========================================================================
//设置回车光标跳转
function SpecialKeyHandler(e,fieldId){
	var keyCode=e.getKey();
	if(keyCode==e.ENTER){
		Ext.getCmp(fieldId).focus(true);
	}
};
var INCICode = new Ext.form.TextField({
	fieldLabel : '代码',
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
	fieldLabel : '名称',//'<font color=red>*名称</font>',
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
	fieldLabel :'规格', // '<font color=red>*规格</font>',
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
	text : '列表',
	width : 30,
	handler : function() {
		if(drugRowid!=""){
			IncSpecEdit("", drugRowid);	
		}else{
			Msg.info("warning","请选择需要维护规格的库存项！");
			return;
		}					
	}
});
var INFOBrand = new Ext.form.TextField({
	fieldLabel : '品牌',
	id : 'INFOBrand',
	anchor : '90%'
});	
var INFOModel = new Ext.form.TextField({
	fieldLabel : '型号',
	id : 'INFOModel',
	name : 'INFOModel',
	anchor : '90%'
});	
var INFOAbbrev = new Ext.form.TextField({
	fieldLabel : '简称',
	id : 'INFOAbbrev',
	anchor : '90%'
});
var INCICTUom = new Ext.ux.ComboBox({
	fieldLabel :  '基本单位',///'<font color=red>*基本单位</font>',
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
	fieldLabel : '入库单位',//'<font color=red>*入库单位</font>',
	id : 'PUCTUomPurch',
	store : CONUomStore,
	filterName:'PUCTUomDesc',
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
			//SpecialKeyHandler(e,'StkCat');			
		}
	}
});
var PackUom = new Ext.ux.ComboBox({
	fieldLabel : '大包装单位',
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
	data : [['REQUIRED', '要求'], ['NONREQUIRED', '不要求'], ['OPTIONAL', '随意']]
});
var INCIBatchReq = new Ext.form.ComboBox({
	fieldLabel : '批号要求',  //'<font color=red>*批次</font>',
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
	data : [['REQUIRED', '要求'], ['NONREQUIRED', '不要求'], ['OPTIONAL', '随意']]
});
var INCIExpReqnew = new Ext.form.ComboBox({
	fieldLabel : '有效期要求', //'<font color=red>*有效期要求</font>',
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
	fieldLabel : '效期长度(月)',
	id : 'INFOExpireLen',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true
});
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
	fieldLabel:'类组',//'<font color=red>*类组</font>',
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
		label.dom.innerHTML="<font color=red>*零售价</font>"
	}else {
		var label =Ext.getCmp('INCIBSpPuruom').getEl().parent().parent().first();    
		label.dom.innerHTML ='零售价:'; 
	}
}
// 库存分类
var StkCat = new Ext.ux.ComboBox({
	fieldLabel : '库存分类',  //'<font color=red>*库存分类</font>',
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
	fieldLabel : '转移方式',//'<font color=red>*转移方式</font>',
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
	fieldLabel : '条码',
	id : 'INCIBarCode',
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
		if(drugRowid!=""){
			IncAliasEdit("", drugRowid,INCAlias);	
		}else{
			Msg.info("warning","请选择需要维护别名的库存项！");
			return;
		}					
	}
});
var INFOPBLevel = new Ext.ux.ComboBox({
	fieldLabel : '招标级别',
	id : 'INFOPBLevel',
	store : INFOPBLevelStore,
	childCombo: 'INFOPBLDR'
});

var INFOBCDr = new Ext.ux.ComboBox({
	fieldLabel : '账簿分类',
	id : 'INFOBCDr',
	store : BookCatStore
});
var INCIBRpPuruom = new Ext.ux.NumberField({
	formatType : 'FmtRP',
	fieldLabel : '进货价',
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
	// fieldLabel : '<font color=red>*零售价</font>',
	fieldLabel : '零售价',
	id : 'INCIBSpPuruom',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true
});
var PreExeDate = new Ext.ux.DateField({
	fieldLabel : '价格生效日期',
	id : 'PreExeDate',
	anchor : '90%',
	listeners:{
		'change':function(d,n,o)
		{
			var x=n.format(ARG_DATEFORMAT);
			var today=new Date().format(ARG_DATEFORMAT);
			if ((Date.parseDate(x,ARG_DATEFORMAT))<Date.parseDate(today,ARG_DATEFORMAT))
			{
				Msg.info("error","价格生效日期不能早于今天!");
				d.setValue(o);
			}
		}
	}
	});
var INFOPrcFile = new Ext.form.TextField({
	fieldLabel : '物价文件号',
	id : 'INFOPrcFile',
	anchor : '90%',
	valueNotFoundText : ''
});
var INCINotUseFlag = new Ext.form.Checkbox({
	fieldLabel : '不可用',
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
	text : '大包装维护',
	height : 30,
	handler : function() {
	}
});
var ImportStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['国产', '国产'], ['进口', '进口'], ['合资', '合资']]
});
var INFOImportFlag = new Ext.form.ComboBox({
	fieldLabel : '进口标志',
	id : 'INFOImportFlag',
	store : ImportStore,
	valueField : 'RowId',
	displayField : 'Description',
	anchor:'90%',
	mode : 'local'
});
var INFOQualityNo = new Ext.form.TextField({
	fieldLabel : '质标编号',
	id : 'INFOQualityNo',
	anchor : '90%',
	valueNotFoundText : ''
});		

var INFOMT = new Ext.ux.ComboBox({
	fieldLabel : '定价类型',
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
	fieldLabel : '最高售价',
	id : 'INFOMaxSp',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true
});

var INFORemark1 = new Ext.ux.ComboBox({
	fieldLabel : '批准文号',
	id : 'INFORemark1',
	anchor : '90%',
	store : INFORemarkStore
});
var INFORemark2 = new Ext.form.TextField({
	fieldLabel : '注册证号',
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
		Msg.info("warning", "请先维护库存项！");
		return;
	}
	if(Ext.isEmpty(INFOPbManf)){
		Msg.info("warning", "请先维护厂商！");
		return;
	}
	if(Ext.isEmpty(regNo)){
		Msg.info("warning", "请先输入注册证号！");
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
	fieldLabel : '国(省)别',
	id : 'INFOComFrom',
	anchor : '90%'
});

var INFOQualityLevel = new Ext.ux.ComboBox({
	fieldLabel : '质量层次',
	id : 'INFOQualityLevel',
	anchor : '90%',
	store : INFOQualityLevelStore
});
var INCIReportingDays = new Ext.form.TextField({
	fieldLabel : '协和码',
	id : 'INCIReportingDays',
	anchor : '90%'
});

var INFOPBLDR = new Ext.ux.ComboBox({
	fieldLabel : '招标名称',
	id : 'INFOPBLDR',
	anchor : '90%',
	store : PublicBiddingListStore,
	filterName: 'Desc',
	params: {PBLevel: 'INFOPBLevel'}
});
var INFOPbVendor = new Ext.ux.VendorComboBox({
	fieldLabel : '招标供应商',
	id : 'INFOPbVendor',
	anchor : '90%',
	width:150,
	params : {ScgId : 'StkGrpType'}
});	
//供应商附加信息
var VendorinfoBt = new Ext.Button({
	id : 'VendorinfoBt',
	text : '...',
	tooltip : '供应商详细信息',
	width : 20,
	tabIndex:390,
	handler : function() {	
		var PbVendor = Ext.getCmp("INFOPbVendor").getValue();
		if (PbVendor!=""){
			CreateEditWin(PbVendor);
		}else{
			Msg.info("warning","请先选择供应商！")
		}
	}
});
	
var INFOPbManf = new Ext.ux.ComboBox({
	fieldLabel : '厂商',
	id : 'INFOPbManf',
	store : PhManufacturerStore,
	filterName:'PHMNFName',
	params : {ScgId : 'StkGrpType'}
});		
var INFOPbCarrier = new Ext.ux.ComboBox({
	fieldLabel : '招标配送商',
	id : 'INFOPbCarrier',
	store : CarrierStore,
	filterName:'CADesc'
});		
var INFOPbRp = new Ext.ux.NumberField({
	formatType : 'FmtRP',
	fieldLabel : '招标进价',
	id : 'INFOPbRp',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true
});
var remark = new Ext.form.TextArea({
	id:'remark',
	fieldLabel:'备注',
	anchor:'90%',
	width : 330,
	selectOnFocus:true
});
var StandardName = new Ext.ux.ComboBox({
			id : 'StandardName',
			fieldLabel : '标准名称',
			store : StandardNameStore,
			filterName : 'Desc'
	})
var supplyLocField = new Ext.ux.LocComboBox({
	id:'supplyLocField',
	fieldLabel:'供应仓库',
	anchor:'90%',
	listWidth:210,
	emptyText:'供应仓库...',
	defaultLoc:{}
});
var TypeStore=new Ext.data.SimpleStore({
	fields:['RowId','Description'],
	data:[['O','临时请求'],['C','申领计划']]
});

var reqType=new Ext.form.ComboBox({
	id:'reqType',
	fieldLabel:'请求类型',
	store:TypeStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'物资请求类型...',
	triggerAction:'all',
	anchor:'90%',
	minChars:1,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	mode:'local'
});
var INFOPbFlag = new Ext.form.Checkbox({
	fieldLabel : '是否招标',
	id : 'INFOPbFlag',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});
var INFOBAflag = new Ext.form.Checkbox({
	fieldLabel : '一次性标志',
	id : 'INFOBAflag',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});		
var INFOInHosFlag = new Ext.form.Checkbox({
	fieldLabel : '本院物资目录',
	id : 'INFOInHosFlag',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});
var INFOHighPrice = new Ext.form.Checkbox({
	fieldLabel : '高值类标志',
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
				Msg.info('warning', '跟台标记已去除,请留意!');
				Ext.getCmp('HighRiskFlag').setValue(false);
			}
			*/
		}
	}
});
var INFOChargeFlag = new Ext.form.Checkbox({
	fieldLabel : '收费标志',
	id : 'INFOChargeFlag',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});

var INFOImplantationMat = new Ext.form.Checkbox({
	fieldLabel : '植入标志',
	id : 'INFOImplantationMat',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});

var INFOInterMat = new Ext.form.Checkbox({
	fieldLabel : '介入标志',
	id : 'INFOInterMat',
	anchor : '90%',
	checked : false
});

var INFOOrgan = new Ext.form.Checkbox({
	fieldLabel : '人工器官',
	id : 'INFOOrgan',
	anchor : '90%',
	checked : false
});

var INFONoLocReq = new Ext.form.Checkbox({
	fieldLabel : '禁止请领标志',
	id : 'INFONoLocReq',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});
var INFOPriceBakD = new Ext.ux.DateField({
	fieldLabel : '物价备案日期',
	id : 'INFOPriceBakD',
	anchor : '90%'
});
var INFODrugBaseCode = new Ext.form.TextField({
	fieldLabel : '物资本位码',
	id : 'INFODrugBaseCode',
	anchor : '90%'
});
var HighRiskFlag = new Ext.form.Checkbox({
	//fieldLabel : '高危物资标志',
	//2016-11-16 此字段记录'跟台标志'
	fieldLabel : '跟台标志',
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
					Msg.info('warning', '仅高值耗材可维护跟台标志!');
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
		{ xtype: 'displayfield', value: '-系数'},
		PackUomFac
	]
};

INFOZeroStk = new Ext.form.Checkbox({
	fieldLabel : '零库存标志',
	id : 'INFOZeroStk',
	anchor : '90%',
	checked : false
});
var HospZeroStk = new Ext.form.TextField({
	fieldLabel : '院区零库存',
	id : 'HospZeroStk',
	name : 'HospZeroStk',
	width : 370,
	anchor : '90%',
	emptyText:'院区零库存标志用/隔开',
	disabled:true,
	valueNotFoundText : ''
});
var HospZeroStkButton = new Ext.Button({
	id:'HospZeroStkButton',
	tabIndex:441,
	text : '维护',
	width : 15,
	handler : function() {
		
		if(drugRowid!=""){
			HospZeroStkEdit("", drugRowid,HospZeroStk);	
		}else{
			Msg.info("warning","请选择需要维护零库存标志的库存项！");
			return;
		}					
	}
	
});
var IRRegCertExpDate = new Ext.ux.DateField({
	fieldLabel : '注册证日期',
	id : 'IRRegCertExpDate',
	anchor : '90%'
});

var IRRegCertItmDesc = new Ext.form.TextField({
		fieldLabel: '注册证名称',
		id: 'IRRegCertItmDesc',
		name: 'IRRegCertItmDesc',
		anchor: '90%'
	});

var IRRegCertExpDateExtended = new Ext.form.Checkbox({
		fieldLabel: '注册证延长效期',
		id: 'IRRegCertExpDateExtended',
		name: 'IRRegCertExpDateExtended',
		anchor: '90%',
		checked: false
	});

var IRRegCertDateOfIssue = new Ext.ux.DateField({
		fieldLabel: '注册证发证日期',
		id: 'IRRegCertDateOfIssue',
		name: 'IRRegCertDateOfIssue',
		anchor: '90%',
		value: ''
	});

//招标日期
var BidDate = new Ext.ux.DateField({
		fieldLabel: '招标日期',
		id: 'BidDate',
		name: 'BidDate',
		anchor: '90%',
		width: 180,
		value: ''
	});

//  首请部门
var FirstReqDept = new Ext.ux.LocComboBox({
		id: 'FirstReqDept',
		fieldLabel: '首请部门',
		anchor: '90%',
		listWidth: 210,
		emptyText: '首请部门...',
		defaultLoc: {}
	});

var Origin = new Ext.ux.ComboBox({
		fieldLabel: '产地',
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
	fieldLabel : '医保类别',
	id : 'PHCDOfficialType',
	mode:'local',
	store : OfficeCodeStore
});

var INFOSupervision = new Ext.form.ComboBox({
	fieldLabel : '监管级别',
	id : 'INFOSupervision',
	store : SupervisionStore,
	valueField : 'RowId',
	displayField : 'Description',
	anchor:'90%',
	mode : 'local',
	triggerAction : 'all'
});

var INFOSterileDateLen = new Ext.form.NumberField({
	fieldLabel : '灭菌时间长度',
	id : 'INFOSterileDateLen',
	anchor : '90%'
});

var INFOChargeType = new Ext.ux.ComboBox({
	fieldLabel : '收费类型',
	id : 'INFOChargeType',
	anchor : '90%',
	store : INFOChargeTypeFlagStore,
	listeners:{
		'select':function(combo,record,index){
			var desc=record.get("Description")
			if(desc=="加成收费"){
				INFOChargeFlag.setValue(true)
			}else{
				INFOChargeFlag.setValue(false)
			}
		}
	}
});

var INFOMedEqptCat = new Ext.ux.ComboBox({
	fieldLabel : '器械分类',
	id : 'INFOMedEqptCat',
	store:MedEqptCatStore,
	filterName : 'Desc'
});

INFOPackCharge = new Ext.form.Checkbox({
	fieldLabel : '打包收费标志',
	id : 'INFOPackCharge',
	anchor : '90%',
	checked : false
});

var SCategory = new Ext.ux.ComboBox({
		fieldLabel: '灭菌分类',
		id: 'SCategory',
		name: 'SCategory',
		store: SCategoryStore,
		valueField: 'RowId',
		displayField: 'Desc'
	});
var MatQuality = new Ext.form.TextField({
		fieldLabel: '质地',
		id: 'MatQuality',
		name: 'MatQuality',
		anchor: '90%',
		width: 180,
		valueNotFoundText: ''
	});
//特殊分类
var MatCatSpecial=new Ext.ux.MatCatComboBox({ 
	fieldLabel : '特殊分类',
	id:'MatCatSpecial',
	url : 'dhcstm.mulmatcataction.csp?actiontype=GetSpecialChildNode',
	rootId : 'AllMCS',
	rootParam : 'NodeId',
	selectMode : 'leaf',
	anchor: '90%'
});
//风险类别
var INFORiskCategory = new Ext.form.ComboBox({
		fieldLabel: '风险类别',
		id: 'INFORiskCategory',
		name: 'INFORiskCategory',
		store: RiskCategoryStore,
		valueField: 'RowId',
		displayField: 'Description',
		anchor: '90%',
		mode: 'local',
		triggerAction: 'all'
	});
//耗材级别
var INFOConsumableLevel = new Ext.form.ComboBox({
		fieldLabel: '耗材级别',
		id: 'INFOConsumableLevel',
		name: 'INFOConsumableLevel',
		store: ConsumableLevelStore,
		valueField: 'RowId',
		displayField: 'Description',
		anchor: '90%',
		mode: 'local',
		triggerAction: 'all'
	});
//用途
var INFOApplication = new Ext.form.TextField({
		fieldLabel: '用途',
		id: 'INFOApplication',
		name: 'INFOApplication',
		anchor: '90%',
		width: 370,
		valueNotFoundText: ''
	});
//功能
var INFOFunction = new Ext.form.TextField({
		fieldLabel: '功能',
		id: 'INFOFunction',
		name: 'INFOFunction',
		anchor: '90%',
		width: 370,
		valueNotFoundText: ''
	});
//库存项Panel 
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
				{ xtype: 'displayfield', value: '-系数'},
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

/*检查是否存在某代码或某名称-规格的项目*/
function ItmCheck(code,desc,spec)
{
 var cls="web.DHCSTM.INCITM";
 var method="ItmCheck";
 var exists=tkMakeServerCall(cls,method,code,desc,spec);
 return exists;
}
//============================库存项===================================//
var talPanel = new Ext.TabPanel({
	activeTab : 0,
	deferredRender : true,
	split:true,
	region : 'east',
	width: 660,
	tbar : [addButton,'-',saveButton,'-',GetMaxCodeBT,'-',viewImage,'-',addsaveButton,'-',LogBT,'-',NewItmInfoBtn],	///DeleteBT
	items : [ {
		layout : 'fit',
		title : '库存项',
		items : [ItmPanel]
	}]
});


setEnterTab(ItmPanel);