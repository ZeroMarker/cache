﻿//===========================================================================================================
var RowDelim=xRowDelim();
var PHCDFRowid="";
var ArcRowid="";
var storeConRowId="";
var userId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var cspname=App_MenuCspName;

var PARA_AllowInputRp="";
var PARA_AllowInputSp="";
var PARA_SameCode="";
var PARA_SameDesc="";
var PARA_InitStatusNotUse="";
var PARA_InciBatchReq="";
var PARA_InciExpReq="";
var PARA_ScMap="";
var PARA_BATSPFLAG="";

var ASP_STATUS="";
var ASP="";
var IncTitle='库存项';

//取参数值
function GetCodeMainPara()
{
	var appName='DHCSTDRUGMAINTAINM';
	var paraObj=GetAppPropValue(appName);
	if (paraObj){
		PARA_AllowInputRp=paraObj.AllowInputRp;
		PARA_AllowInputSp=paraObj.AllowInputSp;
		PARA_SameCode=paraObj.SameCode;
		PARA_SameDesc=paraObj.SameDesc;
		PARA_InitStatusNotUse=paraObj.InitStatusNotUse;
		PARA_ScMap=paraObj.ScMap;
		PARA_InciBatchReq=paraObj.InciBatchReq;
		PARA_InciExpReq=paraObj.InciExpReq;
		PARA_InciBatchReq = PARA_InciBatchReq=='N'?'NONREQUIRED':PARA_InciBatchReq=='O'?PARA_InciBatchReq='OPTIONAL':'REQUIRED';
		PARA_InciExpReq = PARA_InciExpReq=='N'?'NONREQUIRED':PARA_InciExpReq=='O'?PARA_InciExpReq='OPTIONAL':'REQUIRED';
		PARA_ArcimDescAutoMode=	paraObj.ArcimDescAutoMode;
	}
	PARA_BATSPFLAG=isBatSp();
}

function isBatSp()
{	
	var appName='DHCSTCOMMONM';
	var paraStr=GetAppPropValue(appName);
	return paraStr.BatSp;
}
//根据rowid查询
function GetDetail(rowid){
	var url = 'dhcstm.druginfomaintainaction.csp?actiontype=GetDetail&InciRowid=' + rowid;					
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var s = result.responseText;
			//s = s.replace("\r\n", "");// 这才是正确的！
			s=s.replace(/\r/g,"");
			s=s.replace(/\n/g,""); 
			var jsonData = Ext.util.JSON.decode(s);
			if (jsonData.success == 'true') {	
				var ListData = jsonData.info.split(RowDelim);
				SetIncDetail(ListData[0]);
				SetArcDetail(ListData[1]);
				
				//Ext.getCmp("INCICode").fireEvent('blur', Ext.getCmp("INCICode"));
				Ext.getCmp("INCIDesc").fireEvent('blur', Ext.getCmp("INCIDesc"));
				
				SetFormOriginal(ItmMastPanel);

				// addsaveButton.setDisabled(false);
			} else {
				Msg.info("error", "查询错误:"+jsonData.info);
			}
		},
		scope : this
	});
}
//查询库存项信息,zdm,2011-12-23
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
		Ext.getCmp("ArcSpPuruom").setValue(list[18]); //售价(医嘱)
		Ext.getCmp("INCIBRpPuruom").setValue(list[19]); //进价
		Ext.getCmp("ArcimRpPuruom").setValue(list[19]);	//进价(医嘱)
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
		addComboData(null,list[35],list[36],INFOMT);
		Ext.getCmp("INFOMT").setValue(list[35]); //定价类型id
		addComboData(null,list[35],list[36],ArcimINFOMT);
		Ext.getCmp("ArcimINFOMT").setValue(list[35]);	//定价类型(医嘱)
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
		Ext.getCmp("PreExeDate").setValue(list[93]);	//价格生效日期
		Ext.getCmp("ArcPreExeDate").setValue(list[93]);	//价格生效日期(医嘱)
		addComboData(Ext.getCmp("StkGrpType").getStore(),list[94],list[95],StkGrpType);
		Ext.getCmp("StkGrpType").setValue(list[94]);	//类组
		
		ASP_STATUS=list[96];
		ASP=list[97];
		if (drugRowid>0) {
			CheckItmUsed(drugRowid);
		}		
	}
}
//查询医嘱项信息,zdm,2011-12-23
function SetArcDetail(listData) {
	if(listData==null || listData==""){
		//设置医嘱项缺省值
		SetChargeItem();
		return;
	}
	var list=listData.split("^");
	if (list.length > 0) {
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
		Ext.getCmp("ARCIMNoOfCumDays").setValue(list[17]);
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
		addComboData(TarNewMRCateStore,list[45],list[46]);    
		Ext.getCmp("NewMedSubTypeFee").setValue(list[45]);   //新病历首页分类
		addComboData(TarInpatCateStore,list[36],list[37]);
		Ext.getCmp("InSubTypeFee").setValue(list[36]);
		addComboData(TarOutpatCateStore,list[38],list[39]);
		Ext.getCmp("OutSubTypeFee").setValue(list[38]);
		addComboData(TarEMCCateStore,list[40],list[41]);
		Ext.getCmp("AccSubTypeFee").setValue(list[40]);
		//收费项代码
		Ext.getCmp("BillCode").setValue(list[42]);
		//收费项名称
		Ext.getCmp("BillName").setValue(list[43]);
		Ext.getCmp("BillNotActive").setValue(list[44]=='0'?true:false);  //是否维护收费项目
		Ext.getCmp("ChargeBasis").setValue(list[47]);		//收费依据
	}
	//设置医嘱项缺省值
	SetChargeItem();
}

function clearArcim()
{
	//医嘱项
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
	//收费分类
	SubTypeFee.setValue("");
	OutSubTypeFee.setValue("");	
	InSubTypeFee.setValue("");
	AccSubTypeFee.setValue("");
	MedSubTypeFee.setValue("");
	NewMedSubTypeFee.setValue("");
	AccountSubTypeFee.setValue("");
}
			
function clearData(){
	
	//医嘱项目
	clearArcim();
	
	//库存项
	INCICode.setValue("");
	INCIDesc.setValue("");
	INFOSpec.setValue("");
	// Ext.getCmp("INCICTUom").setDisabled(false);
	INCICTUom.setValue("");
	INCICTUom.setRawValue("");
	PUCTUomPurch.setValue("");
	PUCTUomPurch.setRawValue("");
	StkCat.setValue("");
	StkCat.setRawValue("");
	StkGrpType.setValue("");
	StkGrpType.setRawValue("");
	INCAlias.setValue("");
//	INCIBatchReq.setValue("");
//	INCIBatchReq.setRawValue("");
//	INCIExpReqnew.setValue("");
//	INCIExpReqnew.setRawValue("");
	INFOExpireLen.setValue("");
	INFOZeroStk.setValue("");
	INFOPackCharge.setValue("")
	INFOChargeType.setRawValue("");
	INFOChargeType.setValue("");
	INFOMedEqptCat.setValue("");
	Ext.getCmp("INCIBatchReq").setValue('REQUIRED');
	Ext.getCmp("INCIExpReqnew").setValue('REQUIRED');
	Ext.getCmp('INCIIsTrfFlag').setValue('TRANS');

//	INCIIsTrfFlag.setValue("");
//	INCIIsTrfFlag.setRawValue("");
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
	reqType.setValue("");  //设置初始
	ArcRowid="";
	drugRowid="";
	InitDetailForm();
	INFOImplantationMat.setValue(false);
	IRRegCertExpDate.setValue("");
	
	ASP_STATUS="";
	ASP="";
	// addsaveButton.setDisabled(true);
}

//初始化界面
function InitDetailForm(){
	if(PARA_AllowInputSp=='Y'){
		Ext.getCmp('ArcSpPuruom').setDisabled(false);
	}else{
		Ext.getCmp('ArcSpPuruom').setDisabled(true);
	}
	if(PARA_SameCode=='Y'){
		Ext.getCmp('ARCIMCode').setDisabled(true);
	}else{
		Ext.getCmp('ARCIMCode').setDisabled(false);
	}					
	if(PARA_SameDesc=='Y'){
		Ext.getCmp('ARCIMDesc').setDisabled(true);
	}else{
		Ext.getCmp('ARCIMDesc').setDisabled(false);
	}
	if (PARA_BATSPFLAG=='1'){
		Ext.getCmp('ArcSpPuruom').setDisabled(true);
		Ext.getCmp('ArcPreExeDate').setDisabled(true);
	}
	var elemidstr=getelemid();//初始化必填项
   changeElementInfo(elemidstr,cspname);
	setPanelDisabled(ItmPanel);
	SetFormOriginal(ItmMastPanel);
}

var addButton = new Ext.Toolbar.Button({
	text : '新建',
	tooltip : '点击新建',
	iconCls : 'page_add',
	height:30,
	width:70,
	disabled:true,
	handler : function() {
		var changeInfo="";
		if(IsFormChanged(ItmMastPanel)){
			changeInfo=changeInfo+" 医嘱项";
		}
		if(changeInfo!=""){
			var ss=Ext.Msg.show({
			   title:'提示',
			   msg: changeInfo+'信息已改动，若继续将放弃已做的改动，是否继续？',
			   buttons: Ext.Msg.YESNO,
			   fn: function(b,t,o){if (b=='yes')  clearData();		   
			   },
			   icon: Ext.MessageBox.QUESTION
			});	
		}else{
			clearData();
			talPanel.setActiveTab(0);	
		}
	}
});

// 保存三大项信息,zdm,2011-12-20
function saveData() {
	if(IsFormChanged(ItmMastPanel)==false){
		Msg.info("warning","物资信息数据未发生改变!");
		return;
	}
	var elemidstr=getelemid();
	if (getElementInfo(elemidstr,cspname,"Y")==false){
	    return;
	}
	
	var BillUomDr = Ext.getCmp("ARCIMUomDR").getValue();
	var BuomId = Ext.getCmp("INCICTUom").getValue();
	var PurUomId = Ext.getCmp("PUCTUomPurch").getValue();
	var ItemCatId = Ext.getCmp("ARCItemCat").getValue();
	var BillGrpId = Ext.getCmp("ARCBillGrp").getValue();
	var BillSubId = Ext.getCmp("ARCBillSub").getValue();
	//计价单位不能为空
	/*if (BillUomDr == null || BillUomDr =="") {
		Msg.info("warning","计价单位不能为空!");
		return;
	}*/
	
	if((BillUomDr!=BuomId)&(BillUomDr!=PurUomId)){
		Msg.info("warning","计价单位必须是库存项基本单位！");
		return;
	}
	//医嘱子类不能为空
	
	/*if (ItemCatId == null || ItemCatId =="") {
		Msg.info("warning","医嘱子类不能为空!");
		return;
	}
	//费用大类不能为空
	
	if (BillGrpId == null || BillGrpId =="") {
		Msg.info("warning","费用大类不能为空!");
		return;
	}
	
	if (BillSubId == null || BillSubId =="") {
		Msg.info("warning","费用子类不能为空!");
		return;
	}*/
	
	var ArcSpPuruom = Ext.getCmp("ArcSpPuruom").getValue();
	if (PARA_BATSPFLAG!='1')
	{
		if (ArcSpPuruom == null || ArcSpPuruom ==="") {
			Msg.info("warning","零售价不能为空!");
			return;
		}
	}
	
	var listArc="";
	var listInc="";
	var loadMask=ShowLoadMask(document.body,"保存中...");
	
	listArc=getArcList();
	if(listArc==false){	//收费项未维护
		loadMask.hide();
		return;
	}

	var url = "dhcstm.druginfomaintainaction.csp?actiontype=SaveData";
								
	Ext.Ajax.request({
		url : url,
		params:{ListArc:listArc,ListInc:listInc,drugRowid:drugRowid},
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
				//医嘱项rowid^库存项rowid
				var arr = InciRowid.split("^");
				Msg.info("success", "保存成功!");
				//利用库存项rowid显示三大项明细信息和等效单位
				clearData();
				drugRowid=arr[1];		//为DrugInfoList.js中变量赋值,避免再次保存时报错.注意clearData()中的清除.
				GetDetail(arr[1]);	
				//保存成功后下述按钮可用
				Ext.getCmp("IncAliasButton").setDisabled(false);
				//设置别名
				Ext.getCmp("ArcAliasButton").setDisabled(false);
					
				
			} else {
				if(jsonData.info==-61){Msg.info("error", "代码为空!");}
				else if(jsonData.info==-62){Msg.info("error", "名称为空!");}
				else if(jsonData.info==-63){Msg.info("error", "剂型为空!");}
				else if(jsonData.info==-64){Msg.info("error", "单位为空!");}
				else if(jsonData.info==-65){Msg.info("error", "用法为空!");}
				else if(jsonData.info==-20){Msg.info("error", "医嘱项代码为空!");}
				//else if(jsonData.info==-21){Msg.info("error", "医嘱项名称为空!");}
				else if(jsonData.info==-21){Msg.info("error", "保存失败!");}
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
				else if(jsonData.info==-9){Msg.info("error", "库存项条码已经存在，不能重复!");}
				else{Msg.info("error", "保存失败:"+jsonData.info);}
			}
		},
		scope : this
	}); 
}

function getArcList(){
	// 医嘱项数据串:代码^名称^计价单位id^医嘱子类id^费用大类id^费用子类id^独立医嘱标志^默认医嘱优先级id^无库存医嘱标志^医保名称^别名^缩写^医保类别
	// ^最大量^限制使用天数^每天最大剂量^单次最大剂量^急诊用药^住院用药^门诊用药^体检用药^医嘱提示^不维护收费项目^是否维护医保项目
	// ^子分类^住院子分类^门诊子分类^核算子分类^病历首页子分类^会计子分类^生效日期^截止日期
	
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
	var InsuType=Ext.getCmp("PHCDOfficialType").getValue();//医保类别
	var NoCumOfDays=Ext.getCmp("ARCIMNoOfCumDays").getValue();	//限制使用天数				
	var OeMessage=Ext.getCmp("ARCIMOEMessage").getValue();//医嘱提示			
	var UpdTarFlag=(Ext.getCmp("BillNotActive").getValue()==true?'Y':'N');//不维护收费项
	var subTypeFee="";//子分类
	var inSubTypeFee="";//住院子分类
	var outSubTypeFee="";//门诊子分类
	var accSubTypeFee="";//核算子分类
	var medSubTypeFee="";//病历首页子分类
	var newMedSubTypeFee="";//新病历首页子分类
	var accountSubTypeFee="";//会计子分类
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
		var newMedSubTypeFee=Ext.getCmp("NewMedSubTypeFee").getValue();
		if(newMedSubTypeFee==""){Msg.info("error","新病历首页子分类为空!");return false;}
		var accountSubTypeFee=Ext.getCmp("AccountSubTypeFee").getValue();
		if(accountSubTypeFee==""){Msg.info("error", "会计子分类为空!");return false;}
	}
	var medProMaintain=(Ext.getCmp("MedProMaintain").getValue()==true?'Y':'N');//维护医保项
	var ARCIMEffDate=Ext.getCmp("ARCIMEffDate").getValue();//生效日期
	if((ARCIMEffDate!="")&&(ARCIMEffDate!=null)){
		ARCIMEffDate = ARCIMEffDate.format(ARG_DATEFORMAT);
	}
	var ARCIMEffDateTo=Ext.getCmp("ARCIMEffDateTo").getValue();//截止日期
	if((ARCIMEffDateTo!="")&&(ARCIMEffDateTo!=null)){
		ARCIMEffDateTo = ARCIMEffDateTo.format(ARG_DATEFORMAT);
	}
	var BuomId = Ext.getCmp("INCICTUom").getValue();			//库存项基本单位,用于处理计费项
	
	var ArcSp=Ext.getCmp('ArcSpPuruom').getValue();
	var ArcPreExeDate=Ext.getCmp('ArcPreExeDate').getValue();
	if((ArcPreExeDate!="")&&(ArcPreExeDate!=null)){
		ArcPreExeDate = ArcPreExeDate.format(ARG_DATEFORMAT);
	}
	var ArcimINFOMT = Ext.getCmp('ArcimINFOMT').getValue();
	var ChargeBasis = Ext.getCmp("ChargeBasis").getValue();		//收费依据
	var listArc=ARCIMCode+"^"+ARCIMDesc+"^"+BillUomId+"^"+ItmCatId+"^"+BillGrpId+"^"+BillSubId+"^"+OwnFlag+"^"+PriorId+"^"+WoStockFlag+"^"+InsuDesc
		+"^"+AliasStr+"^"+SX+"^"+InsuType+"^"+""+"^"+NoCumOfDays+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""
		+"^"+""+"^"+OeMessage+"^"+UpdTarFlag+"^"+medProMaintain+"^"+subTypeFee+"^"+inSubTypeFee+"^"+outSubTypeFee+"^"+accSubTypeFee+"^"+medSubTypeFee+"^"+accountSubTypeFee
		+"^"+ARCIMEffDate+"^"+ARCIMEffDateTo+"^"+BuomId+"^"+newMedSubTypeFee+"^"+userId+"^"+ArcSp+"^"+ArcPreExeDate+"^"+ASP_STATUS+"^"+ASP+"^"+ArcimINFOMT + '^^^^' + ChargeBasis;  //40
	
	return listArc;
}

//获取控件id20170325
///控件id有改动,请把此方法中的id同步;同时将"基础字典必填项维护"菜单中的控件id也一起同步
///界面不显示的字段,传空值
function getelemid(){
	/*代码^名称^基本单位id^入库单位id^库存分类id^类组^转移方式^是否要求批次^是否要求效期^别名^
	         不可用标志^协和码^条码^售价^进价^供应仓库^物资请求类型^备注^价格生效日期^规格^
	         进口标志^质量层次^质量编号^国/省别^注册证号^高值类标志^定价类型id^最高售价^本院物资目录^招标标志^
	         招标进价^招标级别^招标供应商id^招标生产商id^招标配送商id^招标名称^一次性标志^效期长度^物价文件号^物价文件备案时间^
	         注册证日期^帐簿分类id^物资本位码^大包装单位^大包装单位系数^高危标志^不可用原因^医保类别^品牌^型号^
	         收费标志^简称^监管级别^植入标志^禁止请领标志^灭菌时间^零库存标志^收费类型^器械分类^打包标志^
	         注册证发证日期^注册证名称^注册证延长效期^招标日期^产地^首请部门^灭菌分类^质地^院区零库存^医嘱代码^
	         医嘱名称^计价单位^医嘱大类^医嘱子类^费用大类^费用子类^独立医嘱^医嘱优先级^无库存医嘱^医保名称^
	         别名^缩写^医保类别^限制使用天数^医嘱提示^不维护收费项^收费项代码^收费项名称^子分类^住院子分类^
	         门诊子分类^核算子分类^病历首页子分类^新病历首页子分类^会计子分类^维护医保项^生效日期^截止日期^售价(医嘱)^价格生效日期(医嘱)^
             定价类型(医嘱)^进价(医嘱)
	*/
	var arcelemidstr="INCICode^INCIDesc^INCICTUom^PUCTUomPurch^StkCat^StkGrpType^INCIIsTrfFlag^INCIBatchReq^INCIExpReqnew^INCAlias^INCINotUseFlag^INCIReportingDays"
                    +"^INCIBarCode^INCIBSpPuruom^INCIBRpPuruom^supplyLocField^reqType^remark^PreExeDate^INFOSpec^INFOImportFlag^INFOQualityLevel"
                    +"^INFOQualityNo^INFOComFrom^INFORemark2^INFOHighPrice^INFOMT^INFOMaxSp^INFOInHosFlag^INFOPbFlag^INFOPbRp^INFOPBLevel"
                    +"^INFOPbVendor^INFOPbManf^INFOPbCarrier^INFOPBLDR^INFOBAflag^INFOExpireLen^INFOPrcFile^INFOPriceBakD^IRRegCertExpDate^INFOBCDr"
                    +"^INFODrugBaseCode^PackUom^PackUomFac^HighRiskFlag^ItmNotUseReason^PHCDOfficialType^INFOBrand^INFOModel^INFOChargeFlag^INFOAbbrev"
                    +"^INFOSupervision^INFOImplantationMat^INFONoLocReq^INFOSterileDateLen^INFOZeroStk^INFOChargeType^INFOMedEqptCat^^^"
                    +"^^^^^^^^ARCIMCode^ARCIMDesc^ARCIMUomDR"
                    +"^OrderCategory^ARCItemCat^ARCBillGrp^ARCBillSub^ARCIMOrderOnItsOwn^OECPriority^WoStockFlag^ARCIMText1^ARCAlias^ARCIMAbbrev"
                    +"^PHCDOfficialType^ARCIMNoOfCumDays^ARCIMOEMessage^BillNotActive^BillCode^BillName^SubTypeFee^InSubTypeFee^OutSubTypeFee^AccSubTypeFee"
                    +"^MedSubTypeFee^NewMedSubTypeFee^AccountSubTypeFee^^ARCIMEffDate^ARCIMEffDateTo^ArcSpPuruom^ArcPreExeDate^ArcimINFOMT^ArcimRpPuruom";
	return arcelemidstr;
}
//检测该物资是否已经在用，从而决定是否允许修改价格和基本单位
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
				if(useflag==1){
					Ext.getCmp("ArcPreExeDate").setDisabled(true);
					Ext.getCmp("ArcSpPuruom").setDisabled(true);
				}else{
					if (ASP_STATUS=='Yes')   //已经生效的，禁止再做任何修改、编辑
					{
						if (ArcRowid!==""){
							Ext.getCmp("ArcPreExeDate").setDisabled(true);
							Ext.getCmp("ArcSpPuruom").setDisabled(true);
						}
						else
						{
							Ext.getCmp("ArcPreExeDate").setDisabled(false);
							Ext.getCmp("ArcSpPuruom").setDisabled(false);
						}
						
						return;
					}	
					if ( (ASP==null)||(ASP=='') ){  // 无调价记录的，禁止再做任何修改、编辑
						Ext.getCmp("ArcSpPuruom").setDisabled(false);
						Ext.getCmp("ArcPreExeDate").setDisabled(false);
						return;
					}	

					if (PARA_AllowInputSp=='Y')
					{
					 var exedate=Ext.getCmp("PreExeDate").getValue();
					 if  ((exedate!=null)&&(exedate!="") ) {
						 exedate=exedate.format(ARG_DATEFORMAT);	
					 }  else{
						 //没有调价记录的
						 Ext.getCmp("ArcPreExeDate").setDisabled(false);
						 Ext.getCmp("ArcSpPuruom").setDisabled(false);
						 return;
					 } 
					 
					 var today=new Date();
					 today=today.format(ARG_DATEFORMAT);
					 
					 if (Date.parseDate(exedate,ARG_DATEFORMAT)>Date.parseDate(today,ARG_DATEFORMAT)){
						 Ext.getCmp("ArcPreExeDate").setDisabled(false);
						 Ext.getCmp("ArcSpPuruom").setDisabled(false);
					 }
					 else
					 {
						Ext.getCmp("ArcPreExeDate").setDisabled(true);
						Ext.getCmp("ArcSpPuruom").setDisabled(true);
					 }	 
					}
					else
					{
						Ext.getCmp("ArcPreExeDate").setDisabled(true);
						Ext.getCmp("ArcSpPuruom").setDisabled(true);
					}	
	
				}			
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
		// 保存库存项信息
		saveData();
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
}
	
	// //获取库存项最大码
	// var GetMaxCodeBT = new Ext.Toolbar.Button({
		// text : '获取最大码',
		// tooltip : '获取最大码',
		// width : 70,
		// height : 30,
		// iconCls : 'page_gear',
		// handler : function() {
			// GetMaxCode(SetMaxCode);
		// }
	// });
	
	// function SetMaxCode(newMaxCode,Cat){
		// if(confirm('是否重置界面信息?')==true){
			// clearData();
		// }else{
			// drugRowid = '';
		// }
		// Ext.getCmp("INCICode").setValue(newMaxCode);
		// Ext.getCmp("StkCat").setValue(Cat);
	// }
	
var viewImage= new Ext.Toolbar.Button({
	text : '产品图片',
	tooltip : '查看产品图片',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		var inci=drugRowid   //Ext.getCmp('InciRowid').getValue();
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

//==============================================医嘱项====================================================

var ARCIMCode = new Ext.form.TextField({
	fieldLabel : '代码',//'<font color=red>*代码</font>',
	tabIndex:1,
	id : 'ARCIMCode',
	name : 'ARCIMCode',
	anchor : '90%',
	valueNotFoundText : ''
});

function CopyCode(code){
	if(code!=null||code!=""){
		if(Ext.getCmp("ARCIMCode").disabled==true){
			Ext.getCmp("ARCIMCode").setValue(code);
		}
	}
}

var ARCIMDesc = new Ext.form.TextField({
	fieldLabel : '名称',//'<font color=red>*名称</font>',
	tabIndex:10,
	id : 'ARCIMDesc',
	name : 'ARCIMDesc',
	anchor : '90%',
	valueNotFoundText : ''
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
				arcimDesc = arcimDesc + spec;
			}
			Ext.getCmp("ARCIMDesc").setValue(arcimDesc);
		}
	}
}

var ARCAlias = new Ext.form.TextField({
	fieldLabel : '别名',
	id : 'ARCAlias',
	name : 'ARCAlias',
	anchor : '90%',
	width : 370,
	emptyText:'多个别名之间用/分隔',
	valueNotFoundText : '',
	disabled:true
});

var arcAliasButton = new Ext.Button({
	id:'ArcAliasButton',
	tabIndex:170,
	text : '别名',
	width : 15,
	handler : function() {
		if(ArcRowid!=""){
			OrdAliasEdit("", ArcRowid,ARCAlias);	
		}else{
			Msg.info("warning","请选择要维护别名的医嘱项!");
			return;
		}	
	}
});

var ARCIMEffDate = new Ext.ux.DateField({
	fieldLabel : '生效日期',
	tabIndex:80,
	id : 'ARCIMEffDate',
	name : 'ARCIMEffDate',
	anchor : '90%',
	value : new Date()
});

var ARCIMEffDateTo = new Ext.ux.DateField({
	fieldLabel : '截止日期',
	tabIndex :90,
	id : 'ARCIMEffDateTo',
	name : 'ARCIMEffDateTo',
	anchor : '90%',
	value : ''
});

var ARCBillGrp = new Ext.ux.ComboBox({
	fieldLabel : '费用大类',//'<font color=red>*费用大类</font>',
	tabIndex:40,
	id : 'ARCBillGrp',
	name : 'ARCBillGrp',
	store : ArcBillGrpStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName : 'Desc',
	childCombo : ['ARCBillSub']
});

var ARCBillSub = new Ext.ux.ComboBox({
	fieldLabel : '费用子类',//'<font color=red>*费用子类</font>',
	tabIndex:50,
	id : 'ARCBillSub',
	name : 'ARCBillSub',
	store : ArcBillSubStore,
	valueField : 'RowId',
	displayField : 'Description',
	params:{ARCBGRowId:'ARCBillGrp'}
});

var ARCIMUomDR = new Ext.ux.ComboBox({
	fieldLabel : '计价单位',//'<font color=red>*计价单位</font>',
	tabIndex:60,
	id : 'ARCIMUomDR',
	name : 'ARCIMUomDR',
	store : CTUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'CTUomDesc'
});
var OrderCategory = new Ext.ux.ComboBox({
	fieldLabel : '医嘱大类',//'<font color=red>*医嘱大类</font>',
	tabIndex:20,
	id : 'OrderCategory',
	name : 'OrderCategory',
	store : OrderCategoryStore,
	valueField : 'RowId',
	displayField : 'Description'
});

var ARCItemCat = new Ext.ux.ComboBox({
	fieldLabel : '医嘱子类',//'<font color=red>*医嘱子类</font>',
	tabIndex:30,
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
	tabIndex:70,
	id : 'OECPriority',
	name : 'OECPriority',
	store : OECPriorityStore,
	valueField : 'RowId',
	displayField : 'Description'
});

var ARCIMOEMessage = new Ext.form.TextField({
	fieldLabel : '医嘱提示',
	tabIndex:110,
	id : 'ARCIMOEMessage',
	name : 'ARCIMOEMessage',
	anchor : '90%',
	valueNotFoundText : ''
});

var ARCIMNoOfCumDays = new Ext.form.NumberField({
	fieldLabel : '限制使用天数',
	tabIndex:160,
	id : 'ARCIMNoOfCumDays',
	name : 'ARCIMNoOfCumDays',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true
});

var BillNotActive = new Ext.form.Checkbox({
	fieldLabel : '不维护收费项',
	tabIndex:130,
	id:'BillNotActive',
	name:'BillNotActive',
	anchor:'90%',
	checked:false,
	listeners:{
		'check':function(checked){
			if(document.getElementById('SubTypeFee')==null){
				return;
			}
			if(checked.checked){
				document.getElementById('SubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="收费项目子类:"; 
				SubTypeFee.setValue("");
				SubTypeFee.setRawValue("");
				SubTypeFee.disable();
				
				document.getElementById('InSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="住院费用子类:"; 
				InSubTypeFee.setValue("");
				InSubTypeFee.setRawValue("");
				InSubTypeFee.disable();
				
				document.getElementById('OutSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="门诊费用子类:"; 
				OutSubTypeFee.setValue("");
				OutSubTypeFee.setRawValue("");
				OutSubTypeFee.disable();
				
				document.getElementById('AccSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="经济核算子类:"; 
				AccSubTypeFee.setValue("");
				AccSubTypeFee.setRawValue("");
				AccSubTypeFee.disable();
				
				document.getElementById('MedSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="病案首页子类:"; 
				MedSubTypeFee.setValue("");
				MedSubTypeFee.setRawValue("");
				MedSubTypeFee.disable();
				
				document.getElementById('NewMedSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="新病历首页分类:";
				NewMedSubTypeFee.setValue("");
				NewMedSubTypeFee.setRawValue("");
				NewMedSubTypeFee.disable();
				
				document.getElementById('AccountSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="收费会计子类:"; 
				AccountSubTypeFee.setValue("");
				AccountSubTypeFee.setRawValue("");
				AccountSubTypeFee.disable();
				
				ARCIMText1.setValue("");
				ARCIMText1.disable();
				ChargeBasis.disable();
			}else{
				var elemidstr=getelemid();
               changeElementInfo(elemidstr,cspname);
				//document.getElementById('SubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="子分类:";//"<font color=red>子分类</font>:"; 
				SubTypeFee.enable();
				//document.getElementById('InSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="住院子分类:";//"<font color=red>住院子分类</font>:";
				InSubTypeFee.enable();
				//document.getElementById('OutSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="门诊子分类:";//"<font color=red>门诊子分类</font>:";
				OutSubTypeFee.enable();
				//document.getElementById('AccSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="核算子分类:";//"<font color=red>核算子分类</font>:";
				AccSubTypeFee.enable();
				//document.getElementById('MedSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="病历首页分类:";//"<font color=red>病历首页分类</font>:";
				MedSubTypeFee.enable();
				//document.getElementById('NewMedSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="新病历首页分类:"//"<font color=red>新病历首页分类</font>:"
				NewMedSubTypeFee.enable();
				//document.getElementById('AccountSubTypeFee').parentNode.parentNode.previousSibling.innerHTML ="会计子分类:";//"<font color=red>会计子分类</font>:";
				AccountSubTypeFee.enable();
				ARCIMText1.enable();
				ChargeBasis.enable();
			}
		}
	}
});

var BillCode = new Ext.form.TextField({
	fieldLabel : '收费项代码',
	tabIndex:140,
	id : 'BillCode',
	name : 'BillCode',
	anchor : '90%',
	disabled:true,
	valueNotFoundText : ''
});

var BillName = new Ext.form.TextField({
	fieldLabel : '收费项名称',
	tabIndex:150,
	id : 'BillName',
	name : 'BillName',
	anchor : '90%',
	disabled:true,
	valueNotFoundText : ''
});

var ChargeBasis = new Ext.form.TextField({
	fieldLabel : '收费依据',
	id : 'ChargeBasis',
	anchor : '90%'
});

var ARCIMAbbrev = new Ext.form.TextField({
	fieldLabel : '缩写',
	tabIndex:120,
	id : 'ARCIMAbbrev',
	name : 'ARCIMAbbrev',
	anchor : '90%',
	valueNotFoundText : '',
	disabled:true
});
OfficeCodeStore.load();
var PHCDOfficialType = new Ext.ux.ComboBox({
	fieldLabel : '医保类别',
	tabIndex:161,
	id : 'PHCDOfficialType',
	name : 'PHCDOfficialType',
	mode:'local',
	store : OfficeCodeStore,
	valueField : 'RowId',
	displayField : 'Description'
});
var remark = new Ext.form.TextArea({
	id:'remark',
	fieldLabel:'备注',
	anchor:'90%',
	tabIndex:307,
	width : 330,
	selectOnFocus:true
});
var supplyLocField = new Ext.ux.LocComboBox({
	id:'supplyLocField',
	tabIndex:303,
	fieldLabel:'供应仓库',
	anchor:'90%',
	listWidth:210,
	emptyText:'供应仓库...',
	defaultLoc:{}
});

var ARCIMText1 = new Ext.form.TextField({
	fieldLabel : '医保名称',
	tabIndex:100,
	id : 'ARCIMText1',
	name : 'ARCIMText1',
	anchor : '90%',
	valueNotFoundText : '',
	value:''
});

var DHCArcItemAut = new Ext.Button({
	text : '限制科室设置',
	handler : function() {
	}
});

var ARCIMOrderOnItsOwn = new Ext.form.Checkbox({
	fieldLabel : '独立医嘱',
	tabIndex:180,
	id : 'ARCIMOrderOnItsOwn',
	name : 'ARCIMOrderOnItsOwn',
	anchor : '90%',
	checked : false
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
	tabIndex:190,
	id : 'WoStockFlag',
	name : 'WoStockFlag',
	anchor : '90%',
	checked : false
});

var ArcimINFOMT = new Ext.ux.ComboBox({
	fieldLabel : '定价类型',
	id : 'ArcimINFOMT',
	store : MarkTypeStore,
	listeners:{
		'select' : function(index){
			var Rp = Ext.getCmp("ArcimRpPuruom").getValue();
			if(Rp===""){
				return false;
			}
			var MarkType = this.getValue();
			var MtSp = tkMakeServerCall("web.DHCSTM.Common.PriceCommon","GetMarkTypeSp",MarkType,Rp);
			Ext.getCmp("ArcSpPuruom").setValue(MtSp);
		}
	}
});

var ArcimRpPuruom = new Ext.ux.NumberField({
	disabled : true,
	formatType : 'FmtRP',
	fieldLabel : '进货价',
	id : 'ArcimRpPuruom',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true,
	enableKeyEvents : true,
	listeners : {
		keyup : function(field, e){
			var Rp = field.getValue();
			var MarkType = Ext.getCmp("ArcimINFOMT").getValue();
			if(MarkType=="" || drugRowid!=""){
				return false;
			}
			var MtSp = tkMakeServerCall("web.DHCSTM.Common.PriceCommon","GetMarkTypeSp",MarkType,Rp);
			Ext.getCmp("ArcSpPuruom").setValue(MtSp);
		}
	}
});

var ArcSpPuruom = new Ext.ux.NumberField({
	formatType : 'FmtSP',
	fieldLabel : '零售价',//'<font color=red>*零售价</font>',
	tabIndex:130,
	id : 'ArcSpPuruom',
	name : 'ArcSpPuruom',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true
});

var ArcPreExeDate = new Ext.ux.DateField({
	fieldLabel : '价格生效日期',
	tabIndex:140,
	id : 'ArcPreExeDate',
	name : 'ArcPreExeDate',
	anchor : '90%',
	value : new Date(),
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

//收费项目子类
var SubTypeFee = new Ext.ux.ComboBox({
	fieldLabel:'收费项目子类',//(Ext.getCmp('BillNotActive').getValue()==true?'收费项目子类':'<font color=red>收费项目子类</font>'),
	id : 'SubTypeFee',
	tabIndex:210,
	name : 'SubTypeFee',
	store : TarSubCateStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'Desc'
});
//住院费用子类
var InSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel:'住院费用子类',///(Ext.getCmp('BillNotActive').getValue()==true?'住院费用子类':'<font color=red>住院费用子类</font>'),
	id : 'InSubTypeFee',
	tabIndex:220,
	name : 'InSubTypeFee',
	store : TarInpatCateStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'Desc'
});
//门诊费用子类		
var OutSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel :'门诊费用子类',//(Ext.getCmp('BillNotActive').getValue()==true?'门诊费用子类':'<font color=red>门诊费用子类</font>') ,
	id : 'OutSubTypeFee',
	tabIndex:240,
	name : 'OutSubTypeFee',
	store : TarOutpatCateStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName : 'Desc'
});
//经济核算子类
var AccSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel :'经济核算子类',//(Ext.getCmp('BillNotActive').getValue()==true?'经济核算子类':'<font color=red>经济核算子类</font>'),
	id : 'AccSubTypeFee',
	tabIndex:250,
	name : 'AccSubTypeFee',
	store : TarEMCCateStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName : 'Desc'
});
//病案首页子类
var MedSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel :'病案首页子类',//(Ext.getCmp('BillNotActive').getValue()==true?'病案首页子类':'<font color=red>病案首页子类</font>'),
	id : 'MedSubTypeFee',
	tabIndex:230,
	name : 'MedSubTypeFee',
	store : TarMRCateStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName : 'Desc'
});
//新病历首页分类
var NewMedSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel :'新病历首页分类',//(Ext.getCmp('BillNotActive').getValue()==true?'新病历首页分类':'<font color=red>新病历首页分类</font>'),
	id : 'NewMedSubTypeFee',
	tabIndex:230,
	name : 'NewMedSubTypeFee',
	store : TarNewMRCateStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName : 'Desc'
});

//收费会计子类
var AccountSubTypeFee = new Ext.ux.ComboBox({
	fieldLabel :'收费会计子类',//(Ext.getCmp('BillNotActive').getValue()==true?'收费会计子类':'<font color=red>收费会计子类</font>'),
	id : 'AccountSubTypeFee',
	tabIndex:260,
	name : 'AccountSubTypeFee',
	store : TarAcctCateStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName : 'Desc'
});		
var MedProMaintain = new Ext.form.Checkbox({
	fieldLabel : '维护医保项',
	tabIndex:200,
	id : 'MedProMaintain',
	name : 'MedProMaintain',
	anchor : '90%',
	checked : false,
	hidden:true
});

// 医嘱项Panel
var ItmMastPanel = new Ext.form.FormPanel({
	title:'医嘱项',
	labelWidth : 90,
	labelAlign : 'right',
	autoScroll:true,
	frame : true,
	items : [{
			layout : 'column',
			xtype:'fieldset',
			style:'padding:5px 0px 0px 0px',
			defaults:{border:false},
			items : [{
						columnWidth : 0.5,
						xtype:'fieldset',
						items : [ARCIMCode,OrderCategory,ARCItemCat,ARCIMUomDR,ARCIMEffDate,ARCIMText1,
						ARCIMAbbrev,ArcimRpPuruom,ArcSpPuruom,ARCIMNoOfCumDays]
					},{
						columnWidth : 0.5,
						xtype:'fieldset',
						items : [ARCIMDesc,ARCBillGrp,ARCBillSub,OECPriority,ARCIMEffDateTo,
						ARCIMOEMessage,ArcimINFOMT,ArcPreExeDate,PHCDOfficialType]
					}]
		},{
			xtype:'fieldset',
			style:'padding:5px 0px 0px 0px',
			items:[{
				xtype:'compositefield',
				items:[ARCAlias,arcAliasButton]
			
			}]
		},{
			layout : 'column',
			xtype:'fieldset',
			style:'padding:5px 0px 0px 0px',
			defaults:{border:false},
			items : [{
						columnWidth : .33,
						xtype:'fieldset',
						items : [ARCIMOrderOnItsOwn]
					}, {
						columnWidth : .33,
						xtype:'fieldset',
						items : [WoStockFlag]
					}, {
						columnWidth : .33,
						xtype:'fieldset',
						//items : [MedProMaintain]
						items : [BillNotActive]
					}]
		},{
			xtype : 'fieldset',
			title : '收费项目分类',
			layout : 'column',
			style:'padding:5px 0px 0px 0px',
			defaults:{border:false},
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
		}],
	listeners:{
		activate:function(){
		Ext.getCmp('BillNotActive').fireEvent('check',Ext.getCmp('BillNotActive'),Ext.getCmp('BillNotActive').getValue());
		}
	}
});
//============================医嘱项=========================================================================

//============================库存项=========================================================================
var INCICode = new Ext.form.TextField({
	fieldLabel : '代码',
	tabIndex:1,
	id : 'INCICode',
	name : 'INCICode',
	anchor : '90%',
	//disabled:true,
	valueNotFoundText : ''
});

var INCIDesc = new Ext.form.TextField({
	fieldLabel : '名称',
	tabIndex:10,
	id : 'INCIDesc',
	name : 'INCIDesc',
	anchor : '90%',
	listeners: {
		'blur': function (f) {
			CopyDesc();
		}
	}
});

var INFOSpec = new Ext.form.TextField({
	fieldLabel : '规格',
	id : 'INFOSpec',
	tabIndex:20,
	name : 'INFOSpec',
	anchor : '90%',
//	width:250,
	valueNotFoundText : ''
});
var infoSpecButton = new Ext.Button({
	id:'InfoSpecButton',
	text : '规格',
	width : 10,
	tabIndex:390,
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
	tabIndex:23,
	name : 'INFOBrand',
	anchor : '90%'
});
	
var INFOModel = new Ext.form.TextField({
	fieldLabel : '型号',
	id : 'INFOModel',
	tabIndex:21,
	name : 'INFOModel',
	anchor : '90%'
});

var INFOAbbrev = new Ext.form.TextField({
	fieldLabel : '简称',
	id : 'INFOAbbrev',
	tabIndex:300,
	name : 'INFOAbbrev',
	anchor : '90%'
});	

var INFOSupervision = new Ext.form.ComboBox({
	fieldLabel : '监管级别',
	tabIndex:305,
	id : 'INFOSupervision',
	name : 'INFOSupervision',
	store : SupervisionStore,
	valueField : 'RowId',
	displayField : 'Description',
	anchor:'90%',
	mode : 'local',
	triggerAction : 'all'
});
	
var INCICTUom = new Ext.ux.ComboBox({
	fieldLabel : '基本单位',
	tabIndex:30,
	id : 'INCICTUom',
	name : 'INCICTUom',
	store : CTUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'CTUomDesc',
	listeners : {
		'select':function(combo,record,index)
		{		
			var id=record.get("RowId");
			var desc=record.get("Description");
			addComboData(CONUomStore,id,desc);
			PUCTUomPurch.setValue(id);
			ARCIMUomDR.setValue(id);
		}
	}
});

var PUCTUomPurch = new Ext.ux.ComboBox({
	fieldLabel : '入库单位',
	tabIndex:40,
	id : 'PUCTUomPurch',
	name : 'PUCTUomPurch',
	store : CONUomStore,
	valueField : 'RowId',
	displayField : 'Description',
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
		}
	}
});

var PackUom = new Ext.ux.ComboBox({
	fieldLabel : '大包装单位',
	tabIndex:310,
	id : 'PackUom',
	name : 'PackUom',
	store : CTUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'CTUomDesc'
});
	
var PackUomFac = new Ext.form.NumberField({
	id : 'PackUomFac',
	tabIndex:320,
	name : 'PackUomFac',
	anchor : '25%',
	valueNotFoundText : ''
});
		
var localstore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['REQUIRED', '要求'], ['NONREQUIRED', '不要求'], ['OPTIONAL', '随意']]
});

var INCIBatchReq = new Ext.form.ComboBox({
	fieldLabel : '批号要求',
	tabIndex:60,
	id : 'INCIBatchReq',
	name : 'INCIBatchReq',
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
	fieldLabel : '有效期要求',
	id : 'INCIExpReqnew',
	tabIndex:70,
	name : 'INCIExpReqnew',
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
	tabIndex:80,
	id : 'INFOExpireLen',
	name : 'INFOExpireLen',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true
});
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
	fieldLabel:'类组',
	id : 'StkGrpType',
	name : 'StkGrpType',
	StkType:App_StkTypeCode,
	UserId:userId,
	LocId:gLocId,
	//scgset:"'MM'",
	anchor : '90%',
	childCombo : ['StkCat']
}); 

// 库存分类
var StkCat = new Ext.ux.ComboBox({
	fieldLabel : '库存分类',
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
	fieldLabel : '转移方式',
	tabIndex:90,
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
	tabIndex:160,
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
	tabIndex:330,
	text : '别名',
	width : 15,
	handler : function() {
		//var IncRowid = Ext.getCmp("InciRowid").getValue();
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
	tabIndex:290,
	id : 'INFOPBLevel',
	name : 'INFOPBLevel',
	store : INFOPBLevelStore,
	valueField : 'RowId',
	displayField : 'Description',
	childCombo: 'INFOPBLDR'
});
BookCatStore.load();
var INFOBCDr = new Ext.ux.ComboBox({
	fieldLabel : '账簿分类',
	tabIndex:110,
	id : 'INFOBCDr',
	name : 'INFOBCDr',
	store : BookCatStore,
	valueField : 'RowId',
	displayField : 'Description'
});

var INCIBRpPuruom = new Ext.ux.NumberField({
	formatType : 'FmtRP',
	fieldLabel : '进货价',
	tabIndex:120,
	id : 'INCIBRpPuruom',
	name : 'INCIBRpPuruom',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true,
	enableKeyEvents : true,
	listeners : {
		keyup : function(field, e){
			var Rp = field.getValue();
			var MarkType = Ext.getCmp("INFOMT").getValue();
			if(MarkType=="" || drugRowid!=""){
				return false;
			}
			var MtSp = tkMakeServerCall("web.DHCSTM.Common.PriceCommon","GetMarkTypeSp",MarkType,Rp);
			Ext.getCmp("INCIBSpPuruom").setValue(MtSp);
		}
	}
});

var INCIBSpPuruom = new Ext.ux.NumberField({
	formatType : 'FmtSP',
	fieldLabel : '零售价',//'<font color=red>*零售价</font>',
	hidden:true,
	tabIndex:130,
	id : 'INCIBSpPuruom',
	name : 'INCIBSpPuruom',
	anchor : '90%',
	allowNegative : false,
	selectOnFocus : true
});

var PreExeDate = new Ext.ux.DateField({
	fieldLabel : '价格生效日期',
	tabIndex:140,
	hidden:true,
	id : 'PreExeDate',
	name : 'PreExeDate',
	anchor : '90%',
	value : new Date(),
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
	tabIndex:150,
	id : 'INFOPrcFile',
	name : 'INFOPrcFile',
	anchor : '90%',
	valueNotFoundText : ''
});

var INCINotUseFlag = new Ext.form.Checkbox({
	fieldLabel : '不可用',
	tabIndex:450,
	id : 'INCINotUseFlag',
	name : 'INCINotUseFlag',
	anchor : '90%',		
	checked : false
});
		
var ItmNotUseReason = new Ext.ux.ComboBox({
	id : 'ItmNotUseReason',
	name : 'ItmNotUseReason',
	tabIndex:460,
	store : ItmNotUseReasonStore,
	valueField : 'RowId',
	displayField : 'Description'
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
	tabIndex:200,
	id : 'INFOImportFlag',
	name : 'INFOImportFlag',
	store : ImportStore,
	valueField : 'RowId',
	displayField : 'Description',
	anchor:'90%',
	mode : 'local'
});
var INFOQualityNo = new Ext.form.TextField({
	fieldLabel : '质标编号',
	tabIndex:220,
	id : 'INFOQualityNo',
	name : 'INFOQualityNo',
	anchor : '90%',
	width : 180,
	valueNotFoundText : ''
});		
MarkTypeStore.load();
var INFOMT = new Ext.ux.ComboBox({
	fieldLabel : '定价类型',
	tabIndex:190,
	id : 'INFOMT',
	name : 'INFOMT',
	store : MarkTypeStore,
	valueField : 'RowId',
	displayField : 'Description',
	listeners:{			
		'blur':function(cb){chkInputOfCombo(cb);},
		'select' : function(index){
			var Rp = Ext.getCmp("INCIBRpPuruom").getValue();
			if(Rp==="" || drugRowid!=""){
				return false;
			}
			var MarkType = this.getValue();
			var MtSp = tkMakeServerCall("web.DHCSTM.Common.PriceCommon","GetMarkTypeSp",MarkType,Rp);
			Ext.getCmp("INCIBSpPuruom").setValue(MtSp);
		}
	}
});
var INFOMaxSp = new Ext.form.NumberField({
	fieldLabel : '最高售价',
	tabIndex:240,
	id : 'INFOMaxSp',
	name : 'INFOMaxSp',
	anchor : '90%',
	width : 180,
	allowNegative : false,
	selectOnFocus : true
});

INFORemarkStore.load();
var INFORemark1 = new Ext.ux.ComboBox({
			fieldLabel : '批准文号',
		id : 'INFORemark1',
		tabIndex:340,
		name : 'INFORemark1',
		anchor : '90%',
		store : INFORemarkStore,
		valueField : 'RowId',
		displayField : 'Description'
		});
var INFORemark2 = new Ext.form.TextField({
	fieldLabel : '注册证号',
	id : 'INFORemark2',
	tabIndex:350,
	name : 'INFORemark2',
	anchor : '90%',
	width : 370,
	valueNotFoundText : ''
});
var INFOComFrom = new Ext.form.TextField({
	fieldLabel : '国(省)别',
	tabIndex:210,
	id : 'INFOComFrom',
	name : 'INFOComFrom',
	anchor : '90%',
	width : 180,
	valueNotFoundText : ''
});
INFOQualityLevelStore.load();
var INFOQualityLevel = new Ext.ux.ComboBox({
	fieldLabel : '质量层次',
	tabIndex:260,
	id : 'INFOQualityLevel',
	name : 'INFOQualityLevel',
	anchor : '90%',
	store : INFOQualityLevelStore,
	valueField : 'RowId',
	displayField : 'Description'
});
var INCIReportingDays = new Ext.form.TextField({
	fieldLabel : '协和码',
	tabIndex:230,
	id : 'INCIReportingDays',
	name : 'INCIReportingDays',
	anchor : '90%',
	width : 180,
	valueNotFoundText : ''
});

var INFOPBLDR = new Ext.ux.ComboBox({
		fieldLabel : '招标名称',
		tabIndex:280,
		id : 'INFOPBLDR',
		name : 'INFOPBLDR',
		anchor : '90%',
		store : PublicBiddingListStore,
		params: {PBLevel: 'INFOPBLevel'},
		filterName: 'Desc',
		valueField : 'RowId',
		displayField : 'Description'
});
var INFOPbVendor = new Ext.ux.VendorComboBox({
	fieldLabel : '招标供应商',
	tabIndex:250,
	id : 'INFOPbVendor',
	name : 'INFOPbVendor',
	params : {ScgId : 'StkGrpType'}
});	
//供应商附加信息
var VendorinfoBt = new Ext.Button({
	id : 'VendorinfoBt',
    text : '附加信息',
	tooltip : '附加信息',
	width : 30,
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
	tabIndex:100,
	id : 'INFOPbManf',
	name : 'INFOPbManf',
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'PHMNFName',
	params : {ScgId : 'StkGrpType'}

});		
var INFOPbCarrier = new Ext.ux.ComboBox({
	fieldLabel : '招标配送商',
	tabIndex:270,
	id : 'INFOPbCarrier',
	name : 'INFOPbCarrier',
	store : CarrierStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'CADesc'
});		
var INFOPbRp = new Ext.form.NumberField({
	fieldLabel : '招标进价',
	tabIndex:300,
	id : 'INFOPbRp',
	name : 'INFOPbRp',
	anchor : '90%',
	width : 180,
	allowNegative : false,
	selectOnFocus : true
});
var INFOPbFlag = new Ext.form.Checkbox({
	fieldLabel : '是否招标',
	id : 'INFOPbFlag',
	tabIndex:400,
	name : 'INFOPbFlag',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false,
	disabled:true
});
var INFOBAflag = new Ext.form.Checkbox({
	fieldLabel : '一次性标志',
	id : 'INFOBAflag',
	name : 'INFOBAflag',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});		
var INFOInHosFlag = new Ext.form.Checkbox({
	fieldLabel : '本院物资目录',
	id : 'INFOInHosFlag',
	tabIndex:420,
	name : 'INFOInHosFlag',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});
var INFOHighPrice = new Ext.form.Checkbox({
	fieldLabel : '高值类标志',
	tabIndex:410,
	id : 'INFOHighPrice',
	name : 'INFOHighPrice',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});
var INFOChargeFlag = new Ext.form.Checkbox({
	fieldLabel : '收费标志',
	tabIndex:441,
	id : 'INFOChargeFlag',
	name : 'INFOChargeFlag',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});
var INFOImplantationMat = new Ext.form.Checkbox({
	fieldLabel : '植入标志',
	tabIndex:441,
	id : 'INFOImplantationMat',
	name : 'INFOImplantationMat',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});

var TypeStore=new Ext.data.SimpleStore({
	fields:['RowId','Description'],
	data:[['O','临时请求'],['C','申领计划']]
})
var reqType=new Ext.form.ComboBox({
	id:'reqType',
	fieldLabel:'物资请求类型',
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
		
var INFOPriceBakD = new Ext.ux.DateField({
	fieldLabel : '物价备案日期',
	tabIndex:170,
	id : 'INFOPriceBakD',
	name : 'INFOPriceBakD',
	anchor : '90%',
	width : 180,
	value : ''
});

var INFODrugBaseCode = new Ext.form.TextField({
	fieldLabel : '物资本位码',
	tabIndex:180,
	id : 'INFODrugBaseCode',
	name : 'INFODrugBaseCode',
	anchor : '90%',
	width : 180,
	valueNotFoundText : ''
});

var HighRiskFlag = new Ext.form.Checkbox({
	fieldLabel : '高危物资标志',
	id : 'HighRiskFlag',
	tabIndex:440,
	name : 'HighRiskFlag',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});
var INFONoLocReq = new Ext.form.Checkbox({
	fieldLabel : '禁止请领标志',
	tabIndex:441,
	id : 'INFONoLocReq',
	name : 'INFONoLocReq',
	anchor : '90%',
	width : 20,
	height : 10,
	checked : false
});

var INFOSterileDateLen = new Ext.form.NumberField({
	fieldLabel : '灭菌时间长度',
	id : 'INFOSterileDateLen',
	name : 'INFOSterileDateLen',
	tabIndex:210,
	anchor : '90%',
	width : 180
	//valueNotFoundText : ''
});
INFOZeroStk = new Ext.form.Checkbox({
	fieldLabel : '零库存标志',
	tabIndex:441,
	id : 'INFOZeroStk',
	name : 'INFOZeroStk',
	anchor : '90%',
	checked : false
});
INFOPackCharge = new Ext.form.Checkbox({
	fieldLabel : '打包收费标志',
	tabIndex:442,
	id : 'INFOPackCharge',
	name : 'INFOPackCharge',
	anchor : '90%',
	checked : false
});
//INFOChargeTypeFlagStore.load();
var INFOChargeType = new Ext.ux.ComboBox({
	fieldLabel : '收费类型',
	id : 'INFOChargeType',
	name : 'INFOChargeType',
	tabIndex:310,
	anchor : '90%',
	store : INFOChargeTypeFlagStore,
	valueField : 'RowId',
	displayField : 'Description',
	listeners:{
        'select':function(combo,record,index )
        {
	        var desc=record.get("Description");
	        if(desc=="加成收费"){
	         	INFOChargeFlag.setValue(true);
	        }
	        else{
				INFOChargeFlag.setValue(false);
		    }
	    }
    }	
});

var INFOMedEqptCat = new Ext.ux.ComboBox({
	fieldLabel : '器械分类',
	tabIndex:200,
	id : 'INFOMedEqptCat',
	name : 'INFOMedEqptCat',
	store:MedEqptCatStore,
	filterName : 'Desc',	
	//valueField : 'RowId',
	//displayField : 'Description',
	anchor:'90%'
	
});
var IRRegCertExpDate = new Ext.ux.DateField({
	fieldLabel : '注册证效期',
	id : 'IRRegCertExpDate',
	name : 'IRRegCertExpDate',
	tabIndex:200,
	anchor : '90%',
	width : 180,
	value : ''
});
var ItemPackUom={
	xtype: 'compositefield',								
	items : [
			PackUom,
			{ xtype: 'displayfield', value: '-系数'},
			PackUomFac
			]
};
// 库存项Panel
var ItmPanel = new Ext.form.FormPanel({
	title : IncTitle,
	labelWidth : 90,
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
						items : [INCICode,{xtype : 'compositefield',items:[INFOSpec/*,infoSpecButton*/]},INFOBrand,PUCTUomPurch,INCIBatchReq,INFOExpireLen,INFOPbManf,INCIBRpPuruom,PreExeDate,INCIBarCode,INFODrugBaseCode,INFOImportFlag,
						INFOQualityNo,INFOMaxSp,INFOQualityLevel,INFOPBLDR,
						INFOPbRp,supplyLocField,INFOSupervision,reqType,INFORemark2,IRRegCertExpDate,INFOSterileDateLen]
					},{
						columnWidth : 0.5,
						xtype:'fieldset',
						items : [INCIDesc,INFOModel,INCICTUom,StkGrpType,StkCat,INCIExpReqnew,INCIIsTrfFlag,INFOBCDr,INCIBSpPuruom,INFOPrcFile,INFOPriceBakD,
						INFOMT,INFOComFrom,INCIReportingDays,{xtype : 'compositefield',items:[INFOPbVendor/*,VendorinfoBt*/]},INFOPbCarrier,INFOPBLevel,INFOAbbrev,remark]
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
					items:[INCAlias/*,incAliasButton*/]
				
				},{
					xtype : 'compositefield',
					items : [INFOISCDR/*,iscButton*/]
				}]
		}, {
			layout : 'column',
			labelWidth : 100,
			xtype:'fieldset',
			style:'padding:5px,0px,0px,0px',
			defaults:{border:false},
			items : [{
					columnWidth : .25,
					xtype:'fieldset',		
					items : [INFOPbFlag,INFOBAflag]
				}, {
					columnWidth : .25,
					xtype:'fieldset',
					items : [INFOHighPrice,HighRiskFlag]
				}, {
					columnWidth : .25,
					xtype:'fieldset',
					items : [INFOInHosFlag,INFOChargeFlag]
				}, {
					columnWidth : .25,
					xtype:'fieldset',
					items : [INFOImplantationMat,INFONoLocReq]
				}]
		},{
			layout : 'column',
			xtype:'fieldset',
			style:'padding:5px,0px,0px,0px',
			defaults:{border:false},
			items:[{
				columnWidth:0.5,
				xtype:'fieldset',
				items:[{
					xtype : 'compositefield',
					items : [INCINotUseFlag,ItmNotUseReason]
				},{
					xtype : 'compositefield',
					items : [INFOMedEqptCat]
				}]
			},{
				columnWidth:0.5,
				xtype:'fieldset',
				items:[{
					xtype : 'compositefield',
					items : [INFOZeroStk]
				},{
					xtype : 'compositefield',
					items : [INFOChargeType]
				}]
			}]
		}]
});
//根据库存分类等条件设置医嘱项页面缺省值
function SetChargeItem(){
	var chargeFlag=(Ext.getCmp("INFOChargeFlag").getValue()==true?'Y':'N');
	var StkCat=Ext.getCmp("StkCat").getValue();
	if(ArcRowid!=''){
		return;
	}
	if(PARA_ScMap=="G"){
		var HvFlag = Ext.getCmp("INFOHighPrice").getValue()==true?'Y':'N';
		setChargeItemDefault('dhcstm.hvmaparcaction.csp?actiontype=GetItem&HvFlag=' + HvFlag);
	}else if(PARA_ScMap=="Y" && StkCat!=''){
		setChargeItemDefault('dhcstm.druginfomaintainaction.csp?actiontype=GetChargeItem&StkCat=' + StkCat);
	}
}
//为医嘱项页面分类赋默认值
function setChargeItemDefault(url)
{
	//收费标志的才执行默认值处理
	//if (INFOChargeFlag.getValue()==false){return;}
	//
    Ext.Ajax.request({
        url : url,
        method : 'POST',
        waitMsg : '查询中...',
        success : function(result, request) {
            var s = result.responseText;
            s=s.replace(/\r/g,"")
            s=s.replace(/\n/g,"") 
            var jsonData = Ext.util.JSON.decode(s);
            if (jsonData.success == 'true'&&jsonData.info!="") {
                var ListData = jsonData.info
                var list=ListData.split("^");
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
					Msg.info('warning', '已设置医嘱项缺省值,请核实!');
                    addComboData(OrderCategoryStore,list[0],list[1]);
                    Ext.getCmp("OrderCategory").setValue(list[0]);
                    addComboData(ArcItemCatStore,list[2],list[3]);
                    Ext.getCmp("ARCItemCat").setValue(list[2]);
                    var BillGrpId=list[5].split("||")[0];
                    addComboData(ArcBillGrpStore,BillGrpId,list[4]);
                    Ext.getCmp("ARCBillGrp").setValue(BillGrpId);
                    addComboData(ArcBillSubStore,list[5],list[6]);
                    Ext.getCmp("ARCBillSub").setValue(list[5]);
                    addComboData(TarSubCateStore,list[7],list[8]);
                    Ext.getCmp("SubTypeFee").setValue(list[7]);
                    addComboData(TarAcctCateStore,list[11],list[12]);
                    Ext.getCmp("AccountSubTypeFee").setValue(list[11]);
                    addComboData(TarMRCateStore,list[13],list[14]);
                    Ext.getCmp("MedSubTypeFee").setValue(list[13]);
                    addComboData(TarNewMRCateStore,list[19],list[20]);    
                    Ext.getCmp("NewMedSubTypeFee").setValue(list[19]);   //新病历首页分类
                    addComboData(TarInpatCateStore,list[9],list[10]);
                    Ext.getCmp("InSubTypeFee").setValue(list[9]);
                    addComboData(TarOutpatCateStore,list[17],list[18]);
                    Ext.getCmp("OutSubTypeFee").setValue(list[17]);
                    addComboData(TarEMCCateStore,list[15],list[16]);
                    Ext.getCmp("AccSubTypeFee").setValue(list[15]);
                }
            }
			else if(jsonData.success == 'false'){
                Msg.info("error", "查询错误:"+jsonData.info);
            }
        },
        scope : this
    });
}
//============================库存项=========================================================================	
// 页签
var talPanel = new Ext.TabPanel({
	activeTab : 1,
	title:'物资维护(医嘱)',
	deferredRender : true,
	split:true,
	region : 'east',
	width: 660, 
	tbar : [/*addButton,'-',*/saveButton/*,'-',addsaveButton,'-',GetMaxCodeBT,'-',viewImage*/],		//'-',DeleteBT,
	items : [ItmPanel,ItmMastPanel]
});		
GetCodeMainPara();
setEnterTab(ItmPanel);
setEnterTab(ItmMastPanel);
setPanelDisabled(ItmPanel);
ItmPanel.setTitle(IncTitle+"(只读)");



