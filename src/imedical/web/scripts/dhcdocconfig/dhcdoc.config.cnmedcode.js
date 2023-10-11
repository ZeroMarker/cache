var AuthObj={
    "m_AuthFlag":tkMakeServerCall("DHCDoc.Interface.Inside.InvokeAuth","GetSwitch"),
    "CheckIPDeposit":"住院欠费控制",
    "OPOrderEntryLock":"门、急诊加锁就诊纪录",
    "UserEMVirtualtLong":"急诊启用虚拟长期医嘱",
    "OPAdmDayLimit":"门诊就诊有效时间",
    "EPAdmDayLimit":"急诊就诊有效时间",
    "OPEntryTreatOrdWhenNotHaveSkinOrd":"(门诊)无阴性结果/用药记录可以开立治疗医嘱",
    "EPEntryTreatOrdWhenNotHaveSkinOrd":"(急诊)无阴性结果/用药记录可以开立治疗医嘱",
    "IPEntryTreatOrdWhenNotHaveSkinOrd":"(住院)无阴性结果/用药记录可以开立治疗医嘱",
    "SkinTestPriorShort":"治疗用途医嘱控制为临时",
    "SkinTestNeedApply":"皮试医嘱需要走申请流程",
    "DisableOrdSkinChange":"按照默认皮试及皮试备注审核,不允许单独修改",
    "SkinTestOPNeedExcutedCur":" 仅将已执行的治疗医嘱算作有效治疗(门急诊)"
}
var arrayLogObj={
    "OPLimitType":"门诊就诊有效天数"
}
//checkbox radio 
var arrayObj1=new Array(
	  new Array("Check_OPLimitTypeDay","OPLimitType"),
	  new Array("Check_OPLimitTypeHour","OPLimitType"),
	  new Array("Check_EPLimitTypeDay","EPLimitType"),
	  new Array("Check_EPLimitTypeHour","EPLimitType"),
      new Array("Check_OrderPhamacyWithDiagnos","OrderPhamacyWithDiagnos"),
      //new Array("Check_AllowChangeRecLoc","AllowChangeRecLoc"),
	  //new Array("Check_LogonShowDefaultLoc","LogonShowDefaultLoc"),
	  new Array("Check_IPOrderPhamacyWithDiagnos","IPOrderPhamacyWithDiagnos"),
	  new Array("Check_ShowPaidOrder","ShowPaidOrder"),
	  //new Array("Check_GetAdmByDocMark","GetAdmByDocMark"),
	  new Array("Check_OrderEntryLock","OrderEntryLock"),
	  new Array("Check_CheckIPDeposit","CheckIPDeposit"),
	  new Array("Check_SpecialAndNormal","SpecialAndNormal"),
	  //new Array("Check_NeedDuration","NeedDuration"),
	  new Array("Check_DirectSave","DirectSave"),
	  //new Array("Check_PriorSameAdmDep","PriorSameAdmDep"),
	  //new Array("Check_OrderAdmLimit","OrderAdmLimit"),
	  new Array("Check_PrescByAuto","PrescByAuto"),
	  //new Array("Check_FindDefaultPrescType","FindDefaultPrescType"),
	  new Array("Check_PracticeDocOrderNeedVerify","PracticeDocOrderNeedVerify"),
	  new Array("Check_JoinPresc","JoinPresc"),
	  //new Array("Check_SocialStatus","CanModifySocialStatus"),
	  new Array("Check_StoreUnSaveData","StoreUnSaveData"),
	  new Array("Check_PrescByLinkOrder","PrescByLinkOrder"),
	  new Array("Check_NewOrderUpdate","NewOrderUpdate"),
	  new Array("Check_NotAlertZeroPrice","NotAlertZeroPrice"),
	  new Array("Check_NewDispensing","NewDispensing"),
	  new Array("Check_PrescByInstr","PrescByInstr"),
	  new Array("Check_NotDisplayZeroStockItem","NotDisplayZeroStockItem"),
	  new Array("Check_OutOrderNeedPackQty","OutOrderNeedPackQty"),
	  //new Array("Check_PrescByInsurType","PrescByInsurType"),
	  new Array("Check_IPDefaultPriorShort","IPDefaultPriorShort"),
	  //new Array("Check_NotDisplayPrescType","NotDisplayPrescType"),
	  //new Array("Check_IPShortOrderPriorST","IPShortOrderPriorST"),
	  new Array("Check_CreateShortOrder","CreateShortOrder"),
	  new Array("Check_SameRecDepForGroup","SameRecDepForGroup"),
	  new Array("Check_StopGroupOrder","StopGroupOrder"),
	  new Array("Check_ForceDealOrder","ForceDealOrder"),
	  new Array("Check_CreateOneOrder","CreateOneOrder"),
	  new Array("Check_CheckRealStock","CheckRealStock"),
	  new Array("Check_ConfirmInsurSYMM","ConfirmInsurSYMM"),
	  new Array("Check_CreateLongOrder","CreateLongOrder"),
	  new Array("Check_NotAutoChangeRecloc","NotAutoChangeRecloc"),
	  new Array("Check_ALLConfirmInsurSYMM","AllConfirmInsurSYMM"),
	  //new Array("DTP_IPLongOrderStartTime","IPLongOrderStartTime"),
	  new Array("Check_NotCheckStock","NotCheckStock"),
	  new Array("Check_SetArriveByCallDoc","SetArriveByCallDoc"),
	  new Array("Check_OutAndOneDefaultPackQty","OutAndOneDefaultPackQty"),
	  new Array("Check_OnePriorOrdControl","OnePriorOrdControl"),
	  new Array("Check_LongOrderNotAllowPackQty","LongOrderNotAllowPackQty"),
	  new Array("Check_SetArriveByOrder","SetArriveByOrder"),
	  new Array("Check_OPNotRepeatGenericName","OPNotRepeatGenericName"),
	  new Array("Check_NotDisplayNoRecLoc","NotDisplayNoRecLoc"),
	  //new Array("Check_UseMedUnit","UseMedUnit"),
	  new Array("Check_ArriveUpdate","ArriveUpdate"),
	  new Array("Check_SetArriveBySwipCard","SetArriveBySwipCard"),
	  //new Array("Check_AddOrdUnActive","AddOrdUnActive"),
	  new Array("Check_BaseContainer","BaseContainer"),
	  new Array("Check_IPNeedDoctor","IPNeedDoctor"),
	  new Array("Check_UseCNMedEntry","UseCNMedEntry"),
	  new Array("Check_AllowUserDiagnos","AllowUserDiagnos"),
	  //new Array("Check_DiagGeneralSearch","DiagGeneralSearch"),
	  new Array("Check_NonDrugCreatNextDayExec","NonDrugCreatNextDayExec"),
	  new Array("Check_StopExecByDCOrder","StopExecByDCOrder"),
	  new Array("Check_SkinTestPriorShort","SkinTestPriorShort"),
	  new Array("Check_AllergyChildNotice","AllergyChildNotice"),
	  //new Array("Check_OrderReadyToBillFlag","OrderReadyToBillFlag"),
	  //new Array("Check_MergeLabNo","MergeLabNo"),
	  new Array("Check_TestCodeGenLabNo","TestCodeGenLabNo"),
	  new Array("Check_SepPrefTypeByLoc","SepPrefTypeByLoc"),
	  new Array("Check_OrderMsgAlert","OrderMsgAlert"),
	  new Array("Check_SwithGlobalPriorUpdate","SwithGlobalPriorUpdate"),
	  new Array("Option_FirstTimesNon","FirstTimes"),
	  new Array("Option_FirstTimesAll","FirstTimes"),
	  new Array("Option_FirstTimesCalcBySttTime","FirstTimes"),
	  new Array("Option_NotInsert","LongDiaInsert"),
	  new Array("Option_LongDiaDocFirst","LongDiaInsert"),
	  new Array("Option_BookDocFirst","LongDiaInsert"),
	  new Array("Option_OPFirstTimesNon","OPFirstTimes"),
	  new Array("Option_OPFirstTimesAll","OPFirstTimes"),
	  new Array("Option_OPFirstTimesCalcBySttTime","OPFirstTimes"),
	  new Array("Check_OEORIRealTimeQuery","OEORIRealTimeQuery"),
	  new Array("IEVersion_Option_8","IEVersion"),
	  new Array("IEVersion_Option_11","IEVersion"),
	  //new Array("Check_UserICDSyndrome","UserICDSyndrome"),
	  new Array("Check_ShortDrugOrdNotAllowPackQty","ShortDrugOrdNotAllowPackQty"),
	  //new Array("Check_UseDKB","UseDDiagnosKB"),
	  new Array("Check_OrderGenericName","OrderEntryNameDisplay"),
	  new Array("Check_OrderItemDesc","OrderEntryNameDisplay"),
	  new Array("Check_OrderSpecifications","OrderSpecifications"),
	  new Array("Check_OrderCompany","OrderCompany"),
	  new Array("Check_CMOrdDirectSave","CMOrdDirectSave"),
	  new Array("Check_MedNotOpenARCOS","MedNotOpenARCOS"),
	  new Array("Check_CMMedNotOpenARCOS","CMMedNotOpenARCOS"),
	  new Array("Check_NurSeeOrdNotStopAndCancel","NurSeeOrdNotStopAndCancel"),
	  new Array("Check_AllowCrossSessTypeTrans","AllowCrossSessTypeTrans"),
	  new Array("Check_ShowOrderOpenForAllHosp","ShowOrderOpenForAllHosp"),
	  new Array("Check_DocCureUseBase","DocCureUseBase"),
	  //new Array("Check_NotEntryNoICDDiag","NotEntryNoICDDiag"),
	  //new Array("Check_OPNotEntryNoICDDiag","OPNotEntryNoICDDiag"),
	  //new Array("Check_IPNotEntryNoICDDiag","IPNotEntryNoICDDiag"),
	  new Array("Check_OrderViewScrollView","OrderViewScrollView"),
	  new Array("Check_OPOrderEntryLock","OPOrderEntryLock"),
	  new Array("Check_OPDiagDelLimit","OPDiagDelLimit"),
	  new Array("Check_IPDiagDelLimit","IPDiagDelLimit"),
	  new Array("Check_OPOrdStopLimit","OPOrdStopLimit"),
	  new Array("Check_AllowDelRegDiag","AllowDelRegDiag"),
	  new Array("Check_ChinaDiagLimit","ChinaDiagLimit"),
	  new Array("Check_IsCanCopyOtherPatOrd","IsCanCopyOtherPatOrd"),
	  new Array("Check_DiagOrderByUserFreq","DiagOrderByUserFreq"),
	  new Array("Check_DiagFromTempOrHisAutoSave","DiagFromTempOrHisAutoSave"),
	  new Array("Check_CNDiagWithSyndrome","CNDiagWithSyndrome"),
	  //new Array("Check_ALGCheckConflictOpen","ALGCheckConflictOpen"),
	  new Array("Check_PatFindMutiSelect","PatFindMutiSelect"),
	  new Array("Check_NotCheckSameLabSpecItem","NotCheckSameLabSpecItem"),
	  new Array("Check_OrderPriorContrlConfig","OrderPriorContrlConfig"),
	  new Array("Check_NotDisplayLockedItem","NotDisplayLockedItem"),
	  new Array("Check_AllowNotSameFeeTrans","AllowNotSameFeeTrans"),
	  new Array("Check_AllowPrintAfterInPat","AllowPrintAfterInPat"),
	  new Array("Check_RegConDisForRapidReg","RegConDisForRapidReg"),
	  new Array("Check_AllocAndArriveUpdateAdmTime","AllocAndArriveUpdateAdmTime"),
	  new Array("Check_UserEMVirtualtLong","UserEMVirtualtLong"),
	  new Array("Check_EMVirtualtLongDrugCreatNextDayOrder","EMVirtualtLongDrugCreatNextDayOrder"),
	  //new Array("Check_EntryTreatOrdWhenNotHaveSkinOrd","EntryTreatOrdWhenNotHaveSkinOrd"),
	  new Array("Check_OPEntryTreatOrdWhenNotHaveSkinOrd","OPEntryTreatOrdWhenNotHaveSkinOrd"),
	  new Array("Check_EPEntryTreatOrdWhenNotHaveSkinOrd","EPEntryTreatOrdWhenNotHaveSkinOrd"),
	  new Array("Check_IPEntryTreatOrdWhenNotHaveSkinOrd","IPEntryTreatOrdWhenNotHaveSkinOrd"),
	  new Array("Check_SkinTestNeedApply","SkinTestNeedApply"),
	  new Array("Check_OrdStausChangeAutoUpdateExec","OrdStausChangeAutoUpdateExec"),
	  new Array("Check_DisableOrdSkinChange","DisableOrdSkinChange"),
	  new Array("Check_SkinTestOPNeedExcutedCur","SkinTestOPNeedExcutedCur"),
	  new Array("Check_OrderViewPoison","OrderViewPoison"),
	  new Array("Check_AllowNoInsuContrast","AllowNoInsuContrast"),
	  //new Array("Check_OrdNeedMMDiag","OrdNeedMMDiag"),
	  new Array("Check_AllowUserEnrtyOwnDMDrug","AllowUserEnrtyOwnDMDrug"),
	  new Array("Check_AlwaysShowAgencyInfoWhenDMDrug","AlwaysShowAgencyInfoWhenDMDrug"),
	  new Array("Check_RequiredAgencyInfoWhenDMDrug","RequiredAgencyInfoWhenDMDrug"),
	  new Array("Check_NotDrugNotAutoChangeRecloc","NotDrugNotAutoChangeRecloc"),
	  new Array("Check_AllowOPQueAgainAdjDoc","AllowOPQueAgainAdjDoc"),
	  new Array("Check_AllowHourOrdUsePrn","AllowHourOrdUsePrn"),
	  new Array("Check_AllowOPDocChangeAddNum","AllowOPDocChangeAddNum"),
	  new Array("Check_NeedDeathTypeDiag","NeedDeathTypeDiag"),
	  new Array("Check_IPDiagOpenDRG","IPDiagOpenDRG"),
	  new Array("Check_EnableInsuBusiness","EnableInsuBusiness"),
	  new Array("Check_StopExecByExecTime","StopExecByExecTime"),
	  new Array("Check_ChangeCoverMainInsOrdGroupSelect","ChangeCoverMainInsOrdGroupSelect"),
	  new Array("Check_OPAllowDbClickStopOrd","OPAllowDbClickStopOrd"),
	  new Array("Check_ConsultAllowLong","ConsultAllowLong")
);
//text数据
var arrayObj2=new Array(
   new Array("Text_OPAdmDayLimit","OPAdmDayLimit"),
   new Array("Text_EPAdmDayLimit","EPAdmDayLimit"),
   new Array("Text_PrescItemCountLimit","PrescItemCountLimit"),
   new Array("Text_QueryItemDayLimit","QueryItemDayLimit"),
   new Array("Text_PrescItemCountJ1","PrescItemCountJ1"),
   new Array("Text_PrescItemCountJ2","PrescItemCountJ2"),
   new Array("Text_PrescItemCountKSS","PrescItemCountKSS"),
   new Array("Text_EntryQueryLimit","EntryQueryLimit"),
   new Array("DTP_IPLongOrderStartTime","IPLongOrderStartTime"),
   new Array("DTP_IPLongOrderRollStartTime","IPLongOrderRollStartTime"),
   new Array("Text_UnSaveOrdDataKeepTime","UnSaveOrdDataKeepTime"),
   new Array("Text_PreStopOrderTime","PreStopOrderTime"),
   new Array("DTP_OPExceedDate","ExceedDate_O"),
   new Array("DTP_EPExceedDate","ExceedDate_E"),
   new Array("DTP_LimitDateSearch","LimitDateSearch")
);
//疗程
var arrayObj3=new Array(
  //new Array("SSDBCombo_Duration","LimitDuration")
  new Array("SSDBCombo_IPDuration","IPDefaultDuration")
);
//其他
var arrayObj4=new Array(
   new Array("Check_GroupOrderOnePage","GroupOrderOnePage"),
   new Array("Check_UpdateHourOrderEndTime","UpdateHourOrderEndTime")
);
var dialog, form;
var dialog1;
var SelBillTypeRowid="";
var editRow=undefined;
var editRow1=undefined;
var editRow2=undefined;
var editRow3=undefined;
var editRow4=undefined;
var BillTypeDurationDataGrid;
var DHCDocSysParamAppDataGrid;
var DHCDocSysParamSetDataGrid;
var SelRangeType=""
var ParaTypeStr=[{"code":"","desc":""},{"code":"ALL","desc":"全院"},{"code":"GRP","desc":"安全组"},{"code":"LOC","desc":"科室"},{"code":"USER","desc":"个人"}];
var PageLogicObj={
	ConfigJsonObj:""	
}
$(function(){
   $(".panel-card").panel('resize',{width: $(window).width()-423});
   InitHospList();
   InitEvent();
})
function InitHospList()
{
	var hospComp = GenHospComp("Doc_BaseConfig_CNMedCode");
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
		InitCache();
	}
}
function InitCache(){
	var hasCache = $.DHCDoc.ConfigHasCache();
	if (hasCache!=1) {
		$.DHCDoc.CacheConfigPage();
		$.DHCDoc.storageConfigPageCache();
	}
}
function Init(){
    LoadAuthHtml();
	//初始化病情诊断 DiagnoseRemarkICDDx
  //InitDiagnose("SSDBCombo_Diagnose");
  $(".panel-card").panel('resize',{width: $(window).width()-423});
  //初始化疗程
  for( var i=0;i<arrayObj3.length;i++) {
	   var param1=arrayObj3[i][0];
	   var param2=arrayObj3[i][1];
       InitDuration(param1,param2);	    
   }
   var DOMConinfo="",Coninfo="";
   //所有的checkbox radio元素初始化 
  for( var i=0;i<arrayObj1.length;i++) {
	   var param1=arrayObj1[i][0];
	   var param2=arrayObj1[i][1];
       //LoadCheckData(param1,param2);
       if (DOMConinfo=="") {
	       DOMConinfo=param1;
	       Coninfo=param2;
	   }else{
		   DOMConinfo=DOMConinfo+"^"+param1;
	       Coninfo=Coninfo+"^"+param2;
	   }
   }
   LoadCheckData(DOMConinfo,Coninfo);
   //所有text元素初始化
   var DOMConinfo="",Coninfo="";
   for( var i=0;i<arrayObj2.length;i++) {
	   var param1=arrayObj2[i][0];
	   var param2=arrayObj2[i][1];
       //LoadTextData(param1,param2);
       if (DOMConinfo=="") {
	       DOMConinfo=param1;
	       Coninfo=param2;
	   }else{
		   DOMConinfo=DOMConinfo+"^"+param1;
	       Coninfo=Coninfo+"^"+param2;
	   }	    
   }
   LoadTextData(DOMConinfo,Coninfo);
   //其他
   for( var i=0;i<arrayObj4.length;i++) {
	   var param1=arrayObj4[i][0];
	   var param2=arrayObj4[i][1];
       LoadOrdBillCheckData(param1,param2);	    
   }
   //初始化便民门诊收费方式
   //InitAdmReason("SSDBCombo_AdmReason","QuickAdmBillType");
   //用法和频次 目前不用
   //LoadDefaultFreqData("Combo_SkinTestFreq","SkinTestFreq");
   //初始化需要审批的收费类别 
   //2020-12-04迁移到费别扩展设置
   //LoadListAdmReason("List_AdmReason","NeedCheckBillType");
   //初始化便捷门诊科室
   //LoadListQuickAdmDep("List_QuickAdmDep","QuickAdmDep");
   //2020-12-04迁移到费别扩展设置
   //InitBillTypeDuration();
   InittabNOICDDiagEntryLimit();
   //初始化医院
   InitCurHos("SSDBCombo_Hospital","CurrentHospital");
   //初始化住院临时医嘱默认频次
   InitIPShortOrderPriorDefFreq("Combo_IPShortOrderPriorDefFreq","IPShortOrderPriorDefFreq");
   //获取已保存的数据初始对象
   PageLogicObj.ConfigJsonObj=GetConfigObj();
}
function InitEvent(){
	//增加医院弹出框
    $("#BAdd").click(ShowAddHosWindow);
	//增加医院
	$("#BAddHos").click(AddHospital);
	 //费别允许的子类保存
	 $("#cmd_OK").click(function(){
		 SaveItemCatSelect(SelBillTypeRowid);
	 });
	 //长期医嘱首日执行次数 radio元素点击事件
	 $("#Option_FirstTimesNon").click(function(){
		$("#Option_FirstTimesAll").attr('checked',false);
		$("#Option_FirstTimesCalcBySttTime").attr('checked',false);
	 });
	 $("#Option_FirstTimesAll").click(function(){
		$("#Option_FirstTimesNon").attr('checked',false);
		$("#Option_FirstTimesCalcBySttTime").attr('checked',false);
	 });
	 $("#Option_FirstTimesCalcBySttTime").click(function(){
		$("#Option_FirstTimesNon").attr('checked',false);
		$("#Option_FirstTimesAll").attr('checked',false);
	 });
	 //长效诊断生成规则 radio元素点击事件
	 $("#Option_NotInsert").click(function(){
		$("#Option_LongDiaDocFirst").attr('checked',false);
		$("#Option_BookDocFirst").attr('checked',false);
	 });
	 $("#Option_LongDiaDocFirst").click(function(){
		$("#Option_NotInsert").attr('checked',false);
		$("#Option_BookDocFirst").attr('checked',false);
	 });
	 $("#Option_BookDocFirst").click(function(){
		$("#Option_NotInsert").attr('checked',false);
		$("#Option_LongDiaDocFirst").attr('checked',false);
	 });
	  //门急诊医嘱首日执行次数
	 $("#Option_OPFirstTimesNon").click(function(){
		$("#Option_OPFirstTimesAll").attr('checked',false);
		$("#Option_OPFirstTimesCalcBySttTime").attr('checked',false);
	 });
	 $("#Option_OPFirstTimesAll").click(function(){
		$("#Option_OPFirstTimesNon").attr('checked',false);
		$("#Option_OPFirstTimesCalcBySttTime").attr('checked',false);
	 });
	 $("#Option_OPFirstTimesCalcBySttTime").click(function(){
		$("#Option_OPFirstTimesNon").attr('checked',false);
		$("#Option_OPFirstTimesAll").attr('checked',false);
	 });
	 //IE版本选项
	 $("#IEVersion_Option_8").click(function(){
		$("#IEVersion_Option_11").attr('checked',false);
	 });
	 $("#IEVersion_Option_11").click(function(){
		$("#IEVersion_Option_8").attr('checked',false);
	 });
	 //保存事件
	 $("#BSave").click(SaveCNMedCode);
	 $("#Check_UserEMVirtualtLong").checkbox({
		 onCheckChange:function(e,value){
			 if (value) {
				 $("#Check_EMVirtualtLongDrugCreatNextDayOrder").checkbox('enable');
			 }else{
				 $("#Check_EMVirtualtLongDrugCreatNextDayOrder").checkbox('uncheck').checkbox('disable');
			 }
		 }
     })
	 //Diagnosedefault();
	 InitDHCDocSysParamApp();
	 InitDHCDocSysParamSet();
}
function SaveCNMedCode()
{
	var DataList="";
        var AuthStr="";
	//所有的check radio的保存
	for( var i=0;i<arrayObj1.length;i++) {
		   var param1=arrayObj1[i][0];
		   var param2=arrayObj1[i][1];
	       var CheckedValue=0;
	       if(param2!="FirstTimes"){
		       if ($("#"+param1).hasClass('hisui-radio')){
			       if ($("#"+param1).radio('getValue')) {
				       CheckedValue=1;
				   }
			   }else{
				   if ($("#"+param1).checkbox('getValue')) {
				       CheckedValue=1;
				   }
			   }
		   }
        if ((param2=="OPLimitType")||(param2=="EPLimitType")) continue;
        if ((AuthObj["m_AuthFlag"]==1)&&(AuthObj[param2])){
            if(AuthStr=="") AuthStr=param2+String.fromCharCode(1)+CheckedValue;
            else  AuthStr=AuthStr+String.fromCharCode(2)+param2+String.fromCharCode(1)+CheckedValue;
        }else{
            if(DataList=="") DataList=param2+String.fromCharCode(1)+CheckedValue;
            else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+CheckedValue;	
        }
   }
   ///长期医嘱首日执行次数
   var CheckedValue=""
   if ($("#Option_FirstTimesNon").is(":checked")) {
		 CheckedValue="Non"
   }
   if ($("#Option_FirstTimesAll").is(":checked")) {
		  CheckedValue="All"
   }
   if ($("#Option_FirstTimesCalcBySttTime").is(":checked")) {
		 CheckedValue="CalcBySttTime"
   }
   if(DataList=="") DataList="FirstTimes"+String.fromCharCode(1)+CheckedValue;
   else  DataList=DataList+String.fromCharCode(2)+"FirstTimes"+String.fromCharCode(1)+CheckedValue;
	//长效诊断生成规则 radio元素点击事件
	var CheckedValue=""
	if ($("#Option_NotInsert").is(":checked")) {
		  CheckedValue="Non"
	}
	if ($("#Option_LongDiaDocFirst").is(":checked")) {
		   CheckedValue="LongDiaDocFirst"
	}
	if ($("#Option_BookDocFirst").is(":checked")) {
		  CheckedValue="BookDocFirst"
	}
	if(DataList=="") DataList="LongDiaInsert"+String.fromCharCode(1)+CheckedValue;
	else  DataList=DataList+String.fromCharCode(2)+"LongDiaInsert"+String.fromCharCode(1)+CheckedValue;
   ///门急诊医嘱首日执行次数
   var CheckedValue=""
   if ($("#Option_OPFirstTimesNon").is(":checked")) {
		 CheckedValue="Non"
   }
   if ($("#Option_OPFirstTimesAll").is(":checked")) {
		  CheckedValue="All"
   }
   if ($("#Option_OPFirstTimesCalcBySttTime").is(":checked")) {
		 CheckedValue="CalcBySttTime"
   }
   if(DataList=="") DataList="OPFirstTimes"+String.fromCharCode(1)+CheckedValue;
   else  DataList=DataList+String.fromCharCode(2)+"OPFirstTimes"+String.fromCharCode(1)+CheckedValue;
   //IE版本选项
   var IEVersionCheckedValue=""
   if ($("#IEVersion_Option_8").is(":checked")) {
		 IEVersionCheckedValue="IE8"
   }
   if ($("#IEVersion_Option_11").is(":checked")) {
		  IEVersionCheckedValue="IE11"
   }
   if(DataList=="") DataList="IEVersion"+String.fromCharCode(1)+IEVersionCheckedValue;
   else  DataList=DataList+String.fromCharCode(2)+"IEVersion"+String.fromCharCode(1)+IEVersionCheckedValue;
   
   var OrderEntryNameDisplay="";
   if ($("#Check_OrderGenericName").is(":checked")) {
		 OrderEntryNameDisplay="GenericName"
   }
   if ($("#Check_OrderItemDesc").is(":checked")) {
		  OrderEntryNameDisplay="ItemDesc"
   }
   if(DataList=="") DataList="OrderEntryNameDisplay"+String.fromCharCode(1)+OrderEntryNameDisplay;
   else  DataList=DataList+String.fromCharCode(2)+"OrderEntryNameDisplay"+String.fromCharCode(1)+OrderEntryNameDisplay;
   
   var OPLimitType="";
    var EPLimitType="";
   if ($("#Check_OPLimitTypeDay").is(":checked")) {
		 OPLimitType="Day"
   }
   if ($("#Check_OPLimitTypeHour").is(":checked")) {
		 OPLimitType="Hour"
   }
   if ($("#Check_EPLimitTypeDay").is(":checked")) {
		 EPLimitType="Day"
   }
   if ($("#Check_EPLimitTypeHour").is(":checked")) {
		 EPLimitType="Hour"
   }
    if (AuthObj["m_AuthFlag"]==1){
        if(AuthStr==""){
            AuthStr="OPLimitType"+String.fromCharCode(1)+OPLimitType;
            AuthStr=AuthStr+String.fromCharCode(2)+"EPLimitType"+String.fromCharCode(1)+EPLimitType;
        }else{
            AuthStr=AuthStr+String.fromCharCode(2)+"OPLimitType"+String.fromCharCode(1)+OPLimitType;
            AuthStr=AuthStr+String.fromCharCode(2)+"EPLimitType"+String.fromCharCode(1)+EPLimitType;
        } 
    }else{
        if(DataList==""){
            DataList="OPLimitType"+String.fromCharCode(1)+OPLimitType;
            DataList=DataList+String.fromCharCode(2)+"EPLimitType"+String.fromCharCode(1)+EPLimitType;
        }else{
            DataList=DataList+String.fromCharCode(2)+"OPLimitType"+String.fromCharCode(1)+OPLimitType;
            DataList=DataList+String.fromCharCode(2)+"EPLimitType"+String.fromCharCode(1)+EPLimitType;
        } 
    }
    var ExptStr=OPLimitType+"^"+EPLimitType;
   
   //所有text的保存
   for( var i=0;i<arrayObj2.length;i++) {
		   var param1=arrayObj2[i][0];
		   var param2=arrayObj2[i][1];
	       var text= $.trim($("#"+param1+"").val()," ","");
		   if ((param1=="DTP_IPLongOrderStartTime")){
			    var time=/^([0-1][0-9]|[2][0-3]):([0-5][0-9])$/ 
			    if (time.test(text) != true) {
		          $.messager.alert("提示", "自动生成明日长期医嘱默认开始时间时间格式不正确", "error");
				  return false;
				}
		   }
		   if ((param1=="DTP_IPLongOrderRollStartTime")){
			    var time=/^([0-1][0-9]|[2][0-3]):([0-5][0-9])$/ 
			    if ((text!="")&&(time.test(text) != true)) {
		          $.messager.alert("提示", "无频次长嘱滚动默认开始时间时间格式不正确", "error");
				  return false;
				}
		   }
		   if (param1=="Text_UnSaveOrdDataKeepTime"){
			   if (text<0){
				   $.messager.alert("提示", "未审核数据保留时长只能录入正数！", "error");
				   return false;
			   }else if (isNaN(Number(text))==true){
				   $.messager.alert("提示","未审核数据保留时长应填写数字!");
				  return false;
			   }
		   }
        if ((AuthObj["m_AuthFlag"]==1)&&(AuthObj[param2])){
            if(AuthStr=="") AuthStr=param2+String.fromCharCode(1)+text;
            else  AuthStr=AuthStr+String.fromCharCode(2)+param2+String.fromCharCode(1)+text;	
        }else{
            if(DataList=="") DataList=param2+String.fromCharCode(1)+text;
            else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+text;	
        }
   }
   //保存当前医院 CurrentHospital
   var CurHosCode=$("#SSDBCombo_Hospital").combobox("getValue");
   var CurHosName=$("#SSDBCombo_Hospital").combobox("getText");         
   var CurHos=CurHosCode+"^"+CurHosName ;
	if(DataList=="") DataList="CurrentHospital"+String.fromCharCode(1)+CurHos;
	else  DataList=DataList+String.fromCharCode(2)+"CurrentHospital"+String.fromCharCode(1)+CurHos;	
	var IPShortOrderPriorDefFreq=$("#Combo_IPShortOrderPriorDefFreq").combobox("getValue");
   DataList=DataList+String.fromCharCode(2)+"IPShortOrderPriorDefFreq"+String.fromCharCode(1)+IPShortOrderPriorDefFreq;
	//保存限制疗程、住院疗程
	for( var i=0;i<arrayObj3.length;i++) {
	   var param1=arrayObj3[i][0];
	   var param2=arrayObj3[i][1];
       var DurationValue=$("#"+param1+"").combobox("getValue");
       var DurData=$("#"+param1+"").combobox("getData");
       if (!DurationValue) DurationValue="";
       if ((DurationValue!="")&&($.hisui.indexOfArray(DurData,"DurRowId",DurationValue)<0)) {
	       $.messager.alert("提示","请选择正确的疗程!","info",function(){
		       $("#"+param1+"").next('span').find('input').focus();
		   });
	       return false;
	   }
	   if(DataList=="") DataList=param2+String.fromCharCode(1)+DurationValue;
       else  DataList=DataList+String.fromCharCode(2)+param2+String.fromCharCode(1)+DurationValue;
   }
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	var value=$.m({
		 ClassName:"web.DHCDocConfig",
		 MethodName:"SaveConfig",
		 Coninfo:DataList,
		 HospId:HospID
	},false);
	if(value=="0"){
		$.messager.popover({msg: '保存成功!',type:'success'});
	}
	var DataList1="";
	for( var i=0;i<arrayObj4.length;i++) {
		   var param1=arrayObj4[i][0];
		   var param2=arrayObj4[i][1];
	       var CheckedValue="N";
	       if ($("#"+param1+"").is(":checked")) {
	         CheckedValue="Y";
           }
           if(DataList1=="") DataList1=param2+String.fromCharCode(1)+CheckedValue;
	       else  DataList1=DataList1+String.fromCharCode(2)+param2+String.fromCharCode(1)+CheckedValue;  
   }
   $.m({
	 ClassName:"DHCDoc.DHCDocConfig.DocConfig",
	 MethodName:"saveOrdBillCheckData",
	 Coninfo:DataList1,
	 node:"Main",
	 HospId:HospID
   },false);
   if (AuthStr!=""){
        var Rtn= $.m({
            ClassName:"DHCDoc.Interface.Inside.InvokeAuth",
            MethodName:"InvokeDHCDocConfigAuth",
            Coninfo:AuthStr,
            HospID:HospID,
            UserID:session["LOGON.USERID"],
            AuthJson:JSON.stringify(AuthObj),
            ExptStr:ExptStr,
            dataType:"text"
        },false);
        var Arr=Rtn.split("^");
        $.messager.alert("提示",Arr[1],"info",function(){
            LoadAuthHtml();
        });
    }
    //获取修改之后的数据值,进行日志保存
    var NewConfigJsonObj = GetConfigObj();
    var ChangeObj = GetChangeObj(PageLogicObj.ConfigJsonObj, NewConfigJsonObj);
    var ChangeJsonStr = JSON.stringify(ChangeObj);
    if (ChangeJsonStr!="{}"){
        var HospDesc = $HUI.combogrid('#_HospList').getText();
        var Ret = tkMakeServerCall("web.DHCDocDataChangeLog","SaveLog","DHCDocConfig","DHCDoc.DHCDocConfig.DocConfig","医生站常规设置","User.CTHospital_"+HospID,HospDesc,"U","","",session['LOGON.USERID'],ChangeJsonStr,"Y");
        PageLogicObj.ConfigJsonObj = NewConfigJsonObj;
    }
    return 
   /*$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.DocConfig","saveOrdBillCheckData","false",function(value){	
   },"","",DataList1,"Main");*/
	
}
function InitCurHos(param1,param2)
{
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	$("#"+param1+"").combobox({ 
	    width: '145',     
    	valueField:'HosCode',   
    	textField:'HosName',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.CNMedCode';
			param.QueryName = 'GetCurHos';
			param.Arg1 =param2;
			param.Arg2=HospID,
			param.ArgCnt =2;
		}  
	});				
}
function InitIPShortOrderPriorDefFreq(param1,param2){
	$("#"+param1+"").combobox({   
    	valueField:'PHCFRRowId',   
    	textField:'PHCFRDesc',
		editable:false,
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.CNMedCode';
			param.QueryName = 'GetIPShortOrderPriorDefFreq';
			param.Arg1 =param2;
			param.Arg2=$HUI.combogrid('#_HospList').getValue()
			param.ArgCnt =2;
		}  
	});	
}
function SaveItemCatSelect(SelBillTypeRowid)
{
	   var CatIDStr="";
	   var size = $("#List_ItemCat"+ " option").size();
	   if(size>0){
			$.each($("#List_ItemCat"+" option:selected"), function(i,own){
              var svalue = $(own).val();
			  if (CatIDStr=="") CatIDStr=svalue;
			  else CatIDStr=CatIDStr+"^"+svalue;
			})
	   }
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}	   
    var value=$.m({
		ClassName:"web.DHCDocConfig",
		MethodName:"SaveConfig1",
	   	Node:"AllowItemCatIDStr",
	   	Node1:SelBillTypeRowid, NodeValue:CatIDStr,
	   	HospId:HospID
	},false);
	if(value=="0"){
		$.messager.popover({msg: '保存成功!',type:'success'});
        dialog1.dialog( "close" );							
	}
}
function AddHospital()
{
	var HosCode=$("#Text_HospCode").val();
	var HosName=$("#Text_HospName").val();
	if ((HosCode=="")||(HosName=="")){
		$.messager.alert("提示", "医院代码或名称不能为空", "error");
		return false;
	}
	var value=$.m({
		 ClassName:"DHCDoc.DHCDocConfig.CNMedCode",
		 MethodName:"SaveHosConfig",
		 HosCode:HosCode,
		 HosName:HosName
	},false);
	if(value=="-1"){
		$.messager.alert("提示", "此医院代码已存在，不允许添加", "error");
        return false;
	}
	dialog.dialog( "close" );
	$("#SSDBCombo_Hospital").empty();
	InitCurHos("SSDBCombo_Hospital","CurrentHospital");
	/*$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.CNMedCode","SaveHosConfig","false",function testget(value){
		               	if(value=="-1"){
							$.messager.alert("提示", "此医院代码已存在，不允许添加", "error");
		                    return false;
						}
						dialog.dialog( "close" );
						$("#SSDBCombo_Hospital").empty();
						InitCurHos("SSDBCombo_Hospital","CurrentHospital");
	},"","",HosCode,HosName);*/
}
function ShowAddHosWindow()
{
	$("#dialog-form").css("display", ""); 
	dialog = $( "#dialog-form" ).dialog({
      autoOpen: false,
      height: 170,
      width: 310,
      modal: true
    });
    $("#Text_HospCode").val('').focus();
    $("#Text_HospName").val('');
    
	dialog.dialog( "open" );	 
}
function ItemCatSelect(BillTypeRowid)
{
	SelBillTypeRowid=BillTypeRowid;
	$("#List_ItemCat").find("option").remove();
	$("#dialog-ItemCatSelect").css("display", ""); 
	dialog1 = $("#dialog-ItemCatSelect" ).dialog({
      autoOpen: false,
      height: 400,
      width: 300,
      modal: true
    });
	dialog1.dialog( "open" );
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	var objScope=$.cm({
		 ClassName:"DHCDoc.DHCDocConfig.CNMedCode",
		 QueryName:"GetAllowItemCatIDList",
		 value:BillTypeRowid,
		 HospId:HospID,
		 rows:99999
	},false);
   var vlist = ""; 
   var selectlist="";
   jQuery.each(objScope.rows, function(i, n) { 
		selectlist=selectlist+"^"+n.selected
		vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
   });
   $("#List_ItemCat").append(vlist); 
   for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#List_ItemCat").get(0).options[j-1].selected = true;
		}
	}
	/*var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.CNMedCode';
	queryParams.QueryName ='GetAllowItemCatIDList';
	queryParams.Arg1 =BillTypeRowid;
	queryParams.ArgCnt =1;
	$.dhc.util.runServerQuery(queryParams,"false",function(objScope){
			   var vlist = ""; 
			   var selectlist="";
			   jQuery.each(objScope.rows, function(i, n) { 
						selectlist=selectlist+"^"+n.selected
						vlist += "<option value=" + n.ARCICRowId + ">" + n.ARCICDesc + "</option>"; 
			   });
			   $("#List_ItemCat").append(vlist); 
			   for (var j=1;j<=selectlist.split("^").length;j++){
						if(selectlist.split("^")[j]==1){
							$("#List_ItemCat").get(0).options[j-1].selected = true;
						}
				}
							
	});*/
}
function LoadListQuickAdmDep(param1,param2)
{
	var objScope=$.cm({
		 ClassName:"DHCDoc.DHCDocConfig.CNMedCode",
		 QueryName:"FindOPLoc",
		 value:param2,
		 rows:99999
	},false);
	var vlist = ""; 
    var selectlist="";
    jQuery.each(objScope.rows, function(i, n) { 
	    selectlist=selectlist+"^"+n.selected
        vlist += "<option value=" + n.LocID + ">" + n.LocDesc + "</option>"; 
    });
    $("#"+param1+"").append(vlist); 
    for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]==1){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
	/*var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.CNMedCode';
	queryParams.QueryName ='FindOPLoc';
	queryParams.Arg1 =param2;
	queryParams.ArgCnt =1;
	$.dhc.util.runServerQuery(queryParams,"false",function(objScope){
       var vlist = ""; 
	   var selectlist="";
	   jQuery.each(objScope.rows, function(i, n) { 
			    selectlist=selectlist+"^"+n.selected
                vlist += "<option value=" + n.LocID + ">" + n.LocDesc + "</option>"; 
       });
       $("#"+param1+"").append(vlist); 
	   for (var j=1;j<=selectlist.split("^").length;j++){
				if(selectlist.split("^")[j]==1){
					$("#"+param1+"").get(0).options[j-1].selected = true;
				}
		}
	});*/
}
function LoadListAdmReason(param1,param2)
{
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	$("#"+param1+"").find("option").remove();
	var objScope=$.cm({
		 ClassName:"DHCDoc.DHCDocConfig.CNMedCode",
		 QueryName:"FindBillTypeConfig",
		 value:param2,
		 HospId:HospID,
		 rows:99999
	},false);
	var vlist = ""; 
    var selectlist="";
    jQuery.each(objScope.rows, function(i, n) { 
		selectlist=selectlist+"^"+n.selected
		vlist += "<option value=" + n.BillTypeRowid + ">" + n.BillTypeDesc + "</option>"; 
    });
    $("#"+param1+"").append(vlist); 
    for (var j=1;j<=selectlist.split("^").length;j++){
		if(selectlist.split("^")[j]=="true"){
			$("#"+param1+"").get(0).options[j-1].selected = true;
		}
	}
	/*var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.CNMedCode';
	queryParams.QueryName ='FindBillTypeConfig';
	queryParams.Arg1 =param2;
	queryParams.ArgCnt =1;
	$.dhc.util.runServerQuery(queryParams,"false",function(objScope){
		   var vlist = ""; 
		   var selectlist="";
		   jQuery.each(objScope.rows, function(i, n) { 
					selectlist=selectlist+"^"+n.selected
					vlist += "<option value=" + n.BillTypeRowid + ">" + n.BillTypeDesc + "</option>"; 
		   });
		   $("#"+param1+"").append(vlist); 
		   for (var j=1;j<=selectlist.split("^").length;j++){
					if(selectlist.split("^")[j]==1){
						$("#"+param1+"").get(0).options[j-1].selected = true;
					}
			}				
	});*/
}
function LoadDefaultFreqData(param1,param2)
{
	$("#"+param1+"").combobox({      
    	valueField:'FreqRowId',   
    	textField:'FreqCode',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.SubCatContral';
			param.QueryName = 'FindFreqList';
			param.Arg1 =param2;
			param.ArgCnt =1;
		}  
	});
}
function InitAdmReason(param1,param2)
{
	$("#"+param1+"").combobox({      
    	valueField:'BillTypeRowid',   
    	textField:'BillTypeDesc',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.CNMedCode';
			param.QueryName = 'FindBillTypeConfig';
			param.Arg1 =param2;
			param.ArgCnt =1;
		}  
	});
}

function InitDuration(param1,param2)
{
	$("#"+param1+"").combobox({      
    	valueField:'DurRowId',   
    	textField:'DurCode',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
			param.ClassName = 'DHCDoc.DHCDocConfig.SubCatContral';
			param.QueryName = 'FindDurList';
			param.Arg1 =param2;
			param.Arg2 ="XY";
			param.Arg3 =$HUI.combogrid('#_HospList').getValue();
			param.ArgCnt =3;
		},
		loadFilter: function(data){
			var NewDataArr=new Array();
			for (var i=0;i<data.length;i++){
				if (data[i].DurationFactor==1) {
					NewDataArr.push(data[i]);
				}
			}
			return NewDataArr;
		}
 
	});
}
/*function InitDiagnose(param1)
{
	/*$("#SSDBCombo_Diagnose").combobox({      
    	valueField:'MRCIDRowId',   
    	textField:'MRCIDDesc',
		panelheight:'auto',
    	url:"./dhcdoc.cure.query.combo.easyui.csp",
    	onBeforeLoad:function(param){
						param.ClassName = 'DHCDoc.DHCDocConfig.CNMedCode';
						param.QueryName = 'FindDiagnoseList';
						param.ArgCnt =0;
		}  
	});
	$("#"+param1+"").combogrid({
		panelWidth:500,
		panelHeight:400,
		delay: 200,    
		mode: 'remote',    
		//url: "./dhcdoc.cure.query.combo.easyui.csp", 
		url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号  	
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 10,//每页显示的记录条数，默认为10   
		pageList: [10],//可以设置每页记录条数的列表   
		method:'post', 
		idField: 'MRCIDRowId',    
		textField: 'MRCIDDesc',    
		columns: [[    
			{field:'MRCIDDesc',title:'诊断名称',width:400,sortable:true},
			{field:'MRCIDRowId',title:'ID',width:120,sortable:true}
		]],
		keyHandler:{
			up: function () {
 
             },
             down: function () {
 
            },            
			enter: function () { 
             },

			query:function(q){
				$('#SSDBCombo_Diagnose').combogrid("grid").datagrid("reload",{'keyword':q});
				$('#SSDBCombo_Diagnose').combogrid("setValue",q);
				LoadDiagnoseData();
            }
		},
		onSelect: function (){
			var selected = $('#SSDBCombo_Diagnose').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  //alert(selected.MRCIDRowId)
			  $('#SSDBCombo_Diagnose').combogrid("options").value=selected.MRCIDRowId
			}
		}
	});
  LoadDiagnoseData();
} 
/*function LoadDiagnoseData()
{
	var val = $('#SSDBCombo_Diagnose').combogrid('getValue'); 
    var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.CNMedCode';
	queryParams.QueryName ='FindDiagnoseList';
	queryParams.Arg1 =val;
	queryParams.ArgCnt =1;
	var opts = $('#SSDBCombo_Diagnose').combogrid("grid").datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	$('#SSDBCombo_Diagnose').combogrid("grid").datagrid('load', queryParams);
};
/*function Diagnosedefault(){
	$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.CNMedCode","getDefaultData","false",function(objScope,value,extraArg){
		  
			$('#SSDBCombo_Diagnose').combogrid('setValue',objScope.result.split("^")[1]);
			$('#SSDBCombo_Diagnose').combogrid("options").value=objScope.result.split("^")[0];
			//alert($('#SSDBCombo_Diagnose').combogrid("options").value)
			//DiagnoseDr=objScope.result.split("^")[0];
	
	},"","");
	
}*/
function LoadOrdBillCheckData(param1,param2){
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	var objScope=$.m({
		 ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		 MethodName:"getOrdBillCheckData",
		 node:"Main",
		 value:param2,
		 HospId:HospID,
		 rows:99999
	},false);
	objScope=eval("(" + objScope + ")")
	if (objScope.result=="Y"){
		$("#"+param1+"").checkbox('check');
	}
	/*$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.DocConfig","getOrdBillCheckData","false",function(objScope,value,extraArg){
		if (objScope.result=="Y"){
			$("#"+param1+"").attr('checked', true);
		}
	  },"","","Main",param2);*/
}
function LoadCheckData(DOMConinfo,Coninfo) //param1,param2
{
	$("#Option_NotInsert").attr('checked',false);
	$("#Option_LongDiaDocFirst").attr('checked',false);
	$("#Option_BookDocFirst").attr('checked',false);
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	
	var objScope=$.cm({
		 ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		 MethodName:"getDefaultDataJson",
		 DOMConinfo:DOMConinfo,
		 Coninfo:Coninfo,
		 HospId:HospID
	},false);
	for (var i=0;i<objScope.length;i++){
		var id=objScope[i]["id"];
		var Node=objScope[i]["Node"];
		var value=objScope[i]["value"];
		if ($("#"+id).length==0) continue;
		if(Node=="FirstTimes"){
			switch (value){
				 case "Non": 
					$("#Option_FirstTimesNon").radio('check');
					break;
				 case "All": 
					$("#Option_FirstTimesAll").radio('check');
					break;
				 case "CalcBySttTime": 
				   $("#Option_FirstTimesCalcBySttTime").radio('check');
					break;
				 default: 
					break;
			}
		}else if(Node=="LongDiaInsert"){
			//长效诊断生成规则
			switch (value){
				 case "Non": 
					$("#Option_NotInsert").radio('check');
					break;
				 case "LongDiaDocFirst": 
					$("#Option_LongDiaDocFirst").radio('check');
					break;
				 case "BookDocFirst": 
				   $("#Option_BookDocFirst").radio('check');
					break;
				 default: 
					break;
			}
		}else if(Node=="OPFirstTimes"){
				switch (value){
					 case "Non": 
						$("#Option_OPFirstTimesNon").radio('check');
						break;
					 case "All": 
						$("#Option_OPFirstTimesAll").radio('check');
						break;
					 case "CalcBySttTime": 
					   $("#Option_OPFirstTimesCalcBySttTime").radio('check');
						break;
					 default: 
						break;
				}
		}else if(Node=="IEVersion"){
			switch (value){
				 case "IE8": 
					$("#IEVersion_Option_8").checkbox('check');
					break;
				 case "IE11": 
					$("#IEVersion_Option_11").checkbox('check');
					break;
				 default: 
					break;
			}
		}else if(Node=="OrderEntryNameDisplay"){
			switch (value){
				 case "GenericName": 
					$("#Check_OrderGenericName").radio('check');
					break;
				 case "ItemDesc": 
					$("#Check_OrderItemDesc").radio('check');
					break;
				 default: 
					break;
			}
		}else if(Node=="OPLimitType"){
			switch (value){
				 case "Day": 
					$("#Check_OPLimitTypeDay").radio('check');
					break;
				 case "Hour": 
					$("#Check_OPLimitTypeHour").radio('check');
					break;
				 default: 
					break;
			}
		}else if(Node=="EPLimitType"){
			switch (value){
				 case "Day": 
					$("#Check_EPLimitTypeDay").radio('check');
					break;
				 case "Hour": 
					$("#Check_EPLimitTypeHour").radio('check');
					break;
				 default: 
					break;
			}
		}else{
			if ($("#"+id).hasClass('hisui-radio')){
				if (value==1) {
					$("#"+id+"").radio('check');
				}else{
					$("#"+id+"").radio('uncheck');
				}
			}else{
				if ((!$("#"+id+"").checkbox("options").disabled)||(Node=="DocCureUseBase")) {
					if (value==1) {
						$("#"+id+"").checkbox('check');
					}else{
						$("#"+id+"").checkbox('uncheck');
					}
				}
			}
		}
	}
}
function LoadTextData(DOMConinfo,Coninfo) //param1,param2
{
	var HospID=$HUI.combogrid('#_HospList').getValue();
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	var objScope=$.cm({
		 ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		 MethodName:"getDefaultDataJson",
		 DOMConinfo:DOMConinfo,
		 Coninfo:Coninfo,
		 HospId:HospID
	},false);
	for (var i=0;i<objScope.length;i++){
		var id=objScope[i]["id"];
		var value=objScope[i]["value"];
		var obj=$("#"+id+"");
		if (obj.hasClass("hisui-numberbox")) {
			obj.numberbox("setValue",value);
		}else {
			obj.val(value);
		}		
	}
}

function InitBillTypeDuration()
{
	BillTypeDurationColumns=[[    
                    { field: 'BillTypeRowid', title: 'ID',hidden:true
					}, 
        			{ field: 'BillTypeDesc', title: '费别'
					},
					{ field: 'BillTypeDurationDr', title:'药品疗程限制',
					  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.SubCatContral&QueryName=FindDurList",
								valueField:'DurRowId',
								textField:'DurCode',
								required:false,
								onBeforeLoad:function(param){
						            if (param['q']) {
										var desc=param['q'];
									}else{
										var desc="";
									}
									param = $.extend(param,{value:desc,Type:"XY",HospId:$HUI.combogrid('#_HospList').getValue()});
								},
								loadFilter: function(data){
									return data['rows'];
								}
							  }
     					  },
     					  formatter:function(SSRowId,record){
							  return record.BillTypeDuration;
						 }
					},
					{ field: 'BillTypeDuration', title: '', resizable: true,hidden:true
					},
					{ field: 'DiagnosCatArcimAllow', title: '允许非特病项目',align:'center',
					  editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                            }
					},
					{ field: 'NotAllowItemInDuration', title: '不允许疗程内重复开药',align:'center',
					  editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                            }
					},
					{ field: 'AllowItemCatIDStr', title: '允许的子类(项目用)',
                        formatter:function(value,rec){  
                           var btn = '<a class="editcls" onclick="ItemCatSelect(\'' + rec.BillTypeRowid + '\')">请点击</a>';
						   return btn;
                        }  

					}
    			 ]];
	BillTypeDurationDataGrid=$('#tabBillTypeDuration').datagrid({  
		fit : true,
		width : $(window).height()-400,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindBillTypeConfig&value=&HospId="+$HUI.combogrid('#_HospList').getValue(),
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : false,  //
		idField:"BillTypeRowid",
		columns :BillTypeDurationColumns,
		onClickRow:function(rowIndex, rowData){
            if (editRow != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			BillTypeDurationDataGrid.datagrid("beginEdit", rowIndex);
			editRow=rowIndex
			SelBillTypeRowid=rowData.BillTypeRowid
		},
		onLoadSuccess:function(data){  
            $('.editcls').linkbutton({text:'请点击',plain:true});  
        },
        onBeforeLoad:function(param){
	        editRow=undefined;
	        $('#tabBillTypeDuration').datagrid("unselectAll");
	    }
	});
}
function LoadBillTypeDurationDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.CNMedCode';
	queryParams.QueryName ='FindBillTypeConfig';
	queryParams.Arg1 ="";
	queryParams.ArgCnt =1;
	var opts = BillTypeDurationDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	BillTypeDurationDataGrid.datagrid('load', queryParams);
}
function InitDHCDocSysParamApp()
{
	DHCDocSysParamAppColumns=[[    
        { field: 'DSPARowId', title: '用法ID', width: 1, align: 'center', resizable: true,hidden:true},
		{ field: 'DSPACode', title: '代码(细化到菜单)', width: 50, align: 'center', resizable: true},
		{ field: 'DSPADesc', title: '描述', width: 30, align: 'center', resizable: true}
    ]];
     // 频次列表Grid
	DHCDocSysParamAppDataGrid=$('#tabDHCDocSysParamApp').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindDHCDocSysParamApp",
		loadMsg : '加载中..',  
		pagination : true,  
		rownumbers : false,  //
		idField:"DSPARowId",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :DHCDocSysParamAppColumns,
		onClickRow:function(rowIndex, rowData){
			editRow1=rowIndex
			LoadDHCDocSysParamSetList();
		}
	});
}
function InitDHCDocSysParamSet()
{
	var DHCDocSysParamSetBar = [{
            text: '增加',
            iconCls: 'icon-add',
            handler: function() {
	            editRow2 = undefined;
                DHCDocSysParamSetDataGrid.datagrid("rejectChanges");
                DHCDocSysParamSetDataGrid.datagrid("unselectAll");
                if (editRow2 != undefined) {
                    DHCDocSysParamSetDataGrid.datagrid("endEdit", editRow2);
                    return;
                }else{
                    DHCDocSysParamSetDataGrid.datagrid("insertRow", {
                        index: 0,
                        row: {

						}
                    });
                    DHCDocSysParamSetDataGrid.datagrid("beginEdit", 0);
                    editRow2 = 0;
                }
              
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = DHCDocSysParamSetDataGrid.datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
                            var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].DSPSRowId);
                            }
                            var DSPSRowId=ids.join(',');
                            if (DSPSRowId==""){
	                            editRow2 = undefined;
				                DHCDocSysParamSetDataGrid.datagrid("rejectChanges");
				                DHCDocSysParamSetDataGrid.datagrid("unselectAll");
				                return;
	                        }
                            var value=$.m({
								 ClassName:"DHCDoc.DHCDocConfig.CNMedCode",
								 MethodName:"DeleteDHCDocSysParamSet",
								 DSPSRowId:DSPSRowId
							},false);
                            //$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.CNMedCode","DeleteDHCDocSysParamSet","false",function testget(value){
							if(value=="0"){
								if (editRow2 != undefined){
									DHCDocSysParamSetDataGrid.datagrid("endEdit", editRow2);
								}
								DHCDocSysParamSetDataGrid.datagrid('load');
	           					DHCDocSysParamSetDataGrid.datagrid('unselectAll');
	           					$.messager.popover({msg: '删除成功!',type:'success'});
							}else{
								$.messager.alert('提示',"删除失败:"+value);
								return false;
							}
							editRow2 = undefined;
							//},"","",DSPSRowId);
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
	         
            }
        },{
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
               if (editRow2 != undefined)
                {
	                var DSPARowId=""
					var rows=DHCDocSysParamAppDataGrid.datagrid("getSelected"); //.datagrid("selectRow",editRow1)
					if(rows) DSPARowId=rows.DSPARowId 
					if(DSPARowId==""){
						$.messager.alert('提示',"请选择应用程序!");
						return false;
					}
					var rows=DHCDocSysParamSetDataGrid.datagrid("selectRow",editRow2).datagrid("getSelected"); 
                	var editors = DHCDocSysParamSetDataGrid.datagrid('getEditors', editRow2); 
                	var DSPSRangeType=rows.DSPSRangeType
                	if ((DSPSRangeType=="")||(DSPSRangeType==undefined)){
						$.messager.alert('提示',"类型不能为空!");
						return false;
					}
                	var DSPSRangeValue=rows.DSPSRangeValue
                	if ((DSPSRangeValue=="")||(DSPSRangeValue==undefined)){
						$.messager.alert('提示',"类型值不能为空!");
						return false;
					}	
                	var DSPSParamValue=editors[2].target.is(':checked');
                	if(DSPSParamValue) DSPSParamValue="Y";
			        else {DSPSParamValue="N"}
                	var DSPSParamDesc=editors[3].target.val();
                	if(DSPSParamDesc==""){
						$.messager.alert('提示',"参数描述不能为空!");
						return false;
					}
                	var DSPSHospitalDR=editors[4].target.combobox('getValue');
                	var DSPSLocalFlag=editors[5].target.is(':checked');
                	if(DSPSLocalFlag) DSPSLocalFlag="Y";
			        else {DSPSLocalFlag="N"}
					
					var Str=DSPSRangeType+"^"+DSPSRangeValue+"^"+DSPSParamValue+"^"+DSPSParamDesc+"^"+DSPSHospitalDR+"^"+DSPSLocalFlag;
					//此处CS版有判断记录是否重复，但判断没有作用，BS是否也要做控制
					// DHC_DiagnosCat 的DC_Type 只有状态 C S 没有M，此处要在表DHC_DiagnosCat增加M
					if(rows.DSPSRowId){
						var value=$.m({
							 ClassName:"DHCDoc.DHCDocConfig.CNMedCode",
							 MethodName:"SaveDHCDocSysParamSet",
							 DSPSRowId:rows.DSPSRowId,
							 Str:Str
						},false);
						//$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.CNMedCode","SaveDHCDocSysParamSet","false",function testget(value){
						if(value=="0"){
							DHCDocSysParamSetDataGrid.datagrid("endEdit", editRow2);
                			editRow2 = undefined;
							DHCDocSysParamSetDataGrid.datagrid('load');
           					DHCDocSysParamSetDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
						editRow2 = undefined;
						//},"","",rows.DSPSRowId,Str);
					}else{
						var value=$.m({
							 ClassName:"DHCDoc.DHCDocConfig.CNMedCode",
							 MethodName:"InsertDHCDocSysParamSet",
							 DSPARowId:DSPARowId,
							 Str:Str
						},false);
						//$.dhc.util.runServerMethod("DHCDoc.DHCDocConfig.CNMedCode","InsertDHCDocSysParamSet","false",function testget(value){
						if(value=="0"){
							DHCDocSysParamSetDataGrid.datagrid("endEdit", editRow2);
                			editRow2 = undefined;
							DHCDocSysParamSetDataGrid.datagrid('load');
           					DHCDocSysParamSetDataGrid.datagrid('unselectAll');
           					//$.messager.alert({title:"提示",msg:"保存成功"});           					
						}else{
							$.messager.alert('提示',"保存失败:"+value);
							return false;
						}
						editRow2 = undefined;
						//},"","",DSPARowId,Str);
					}
			}
		  }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                editRow2 = undefined;
                DHCDocSysParamSetDataGrid.datagrid("rejectChanges");
                DHCDocSysParamSetDataGrid.datagrid("unselectAll");
            }
        }];
    var DHCDocSysParamSetColumns=[[    
	                { field : 'DSPSRowId',title : '',width : 1,hidden:true  
                    },
                    { field : 'DSPSRangeType',title : '',width : 1,hidden:true  
                    },
        			{ field: 'DSPSRangeTypeDesc', title: '类型', width: 50, align: 'center',
        			  editor:{
					        type:'combobox',
					        options:{
						      valueField:'code',
						      textField:'desc',
							  required:true,
						      data:ParaTypeStr,
						      onSelect: function (rec) {
							      var rows=DHCDocSysParamSetDataGrid.datagrid("selectRow",editRow2).datagrid("getSelected");
	                              rows.DSPSRangeType=rec.code
							      SelRangeType=rec.code
							      var row = DHCDocSysParamSetDataGrid.datagrid("getSelections");
							      var rowIndex = DHCDocSysParamSetDataGrid.datagrid('getRowIndex', row[0]);
							      var ed = DHCDocSysParamSetDataGrid.datagrid('getEditor', { 'index': rowIndex,field:'DSPSRangeValueDesc'})
							      var object1=new Object();
								  object1=$(ed.target)
	                               if(rec.code=="ALL") {
		                               rows.DSPSRangeValue="ALL"
	                                   rows.DSPSRangeValueDesc="ALL"
	                                   ed.target.combogrid("setValue","ALL");
		                           }else{
			                           rows.DSPSRangeValue=""
	                                   rows.DSPSRangeValueDesc=""
	                                   ed.target.combogrid("setValue","");
	                                   ed.target.combogrid('setText',"")
			                       }
			                       ed.target.combogrid("grid").datagrid('load',{"DSPSRangeType":rec.code,"Param":""});
							  }
					        }
				       }
        			},
        			{ field : 'DSPSRangeValue',title : '',width : 1,hidden:true    
                    },
					{ field : 'DSPSRangeValueDesc',title : '类型值',width : 100 , align: 'center', 
                        editor:{
		                         type:'combogrid',
		                         options:{
		                             required: true,
		                             panelWidth:300,
									 panelHeight:300,
		                             idField:'RangeID',
		                             textField:'RangeValue',
		                             value:'',//缺省值 
		                             mode:'remote',
									 pagination : true,//是否分页   
									 rownumbers:true,//序号   
									 collapsible:false,//是否可折叠的   
									 fit: true,//自动大小   
									 pageSize: 10,//每页显示的记录条数，默认为10   
									 pageList: [10],//可以设置每页记录条数的列表  
									 url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindDSPSRangeValue",
		                             columns:[[
		                                {field:'RangeValue',title:'名称',width:150,sortable:true},
					                    {field:'RangeID',title:'ID',width:30,sortable:true},
					                    {field:'selected',title:'ID',width:120,sortable:true,hidden:true}
		                             ]],
		                             onBeforeLoad:function(param){
			                            if (editRow2 != undefined) {
											var rows=DHCDocSysParamSetDataGrid.datagrid("selectRow",editRow2).datagrid("getSelected");
											Type=rows.DSPSRangeType
											param = $.extend(param,{DSPSRangeType:Type,Param:param["q"]});
										}
									 },
									 onSelect : function(rowIndex, rowData) {
										var rows=DHCDocSysParamSetDataGrid.datagrid("selectRow",editRow2).datagrid("getSelected");
                                        if(rows)rows.DSPSRangeValue=rowData.RangeID
				                     }
                        		}
		        			  }
                    },
                    {
                      field : 'DSPSParamValue',title : '参数值',width : 50,align: 'center',
                        editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                          }	
                     },
					{ field: 'DSPSParamDesc', title: '参数描述', width: 100, align: 'center',
					   editor : {
                        type : 'text',
						options:{
							required:true
						}
					  } 	
					},
                    { field: 'DSPSHospitalDR', title: '医院', width: 100, align: 'center',
					  editor :{  
							type:'combobox',  
							options:{
								url:$URL+"?ClassName=DHCDoc.DHCDocConfig.InstrArcim&QueryName=GetHos",
								valueField:'HOSPRowId',
								textField:'HOSPDesc',
								required:true,
								loadFilter:function(data){
									return data['rows'];
								}
							  }
     					  },
						  formatter:function(value,record){
							  return record.DSPSHospital;
						  }
					},
					{ field: 'DSPSHospital', title: '', width: 100, align: 'center',hidden:true
					},
					{ field: 'DSPSLocalFlag', title: '本地化', width: 100, align: 'center',
					  editor : {
                                type : 'icheckbox',
                                options : {
                                    on : 'Y',
                                    off : ''
                                }
                            }
					}					
    			 ]];
	DHCDocSysParamSetDataGrid=$("#tabDHCDocSysParamSet").datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindDHCDocSysParamSet&DSPARowId=",
		loadMsg : '加载中..',  
		pagination : true,  //
		rownumbers : false,  //
		idField:"DSPSRowId",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :DHCDocSysParamSetColumns,
    	toolbar :DHCDocSysParamSetBar,
		onDblClickRow:function(rowIndex, rowData){
			if (editRow2 != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			DHCDocSysParamSetDataGrid.datagrid("beginEdit", rowIndex);
			editRow2=rowIndex
		}
	});
}
function LoadDHCDocSysParamSetList()
{
	editRow2 = undefined;
    DHCDocSysParamSetDataGrid.datagrid("rejectChanges");
    DHCDocSysParamSetDataGrid.datagrid("unselectAll");
	var DSPARowId=""
	var rows=DHCDocSysParamAppDataGrid.datagrid("selectRow",editRow1).datagrid("getSelected");
	if(rows) DSPARowId=rows.DSPARowId
	if(DSPARowId=="") return false;
	var queryParams = new Object();
	queryParams.ClassName ='DHCDoc.DHCDocConfig.CNMedCode';
	queryParams.QueryName ='FindDHCDocSysParamSet';
	queryParams.DSPARowId =DSPARowId;
	//queryParams.ArgCnt =1;
	var opts = DHCDocSysParamSetDataGrid.datagrid("options");
	opts.url = $URL;
	DHCDocSysParamSetDataGrid.datagrid('load', queryParams);
	
}

function InittabNOICDDiagEntryLimit()
{
	var ToolBar = [{
            text: '添加',
            iconCls: 'icon-add',
            handler: function() { 
                if (editRow4 != undefined) {
                    return;
                }else{
                    $('#tabNOICDDiagEntryLimit').datagrid("insertRow", {
                        index: 0,
                        row: {}
                    });
                    $('#tabNOICDDiagEntryLimit').datagrid("beginEdit", 0);
                    editRow4 = 0;
                }
            }
        },{
            text: '删除',
            iconCls: 'icon-cancel',
            handler: function() {
                var rows = $('#tabNOICDDiagEntryLimit').datagrid("getSelections");
                if (rows.length > 0) {
                    $.messager.confirm("提示", "你确定要删除吗?",
                    function(r) {
                        if (r) {
							var ids = [];
                            for (var i = 0; i < rows.length; i++) {
                                ids.push(rows[i].rowid);
                            }
                            var ID=ids.join(',');
                            if (ID==""){
	                            editRow4 = undefined;
				                $('#tabNOICDDiagEntryLimit').datagrid("rejectChanges");
				                $('#tabNOICDDiagEntryLimit').datagrid("unselectAll");
								LimitRowid="";
								return;
	                        }
                            var HospID=$HUI.combogrid('#_HospList').getValue();
                            var PreNoICDDiagObj=GetNoICDDiagObj(ID,"NOICDDiagEntryLimit",HospID);
                            var value=$.m({ 
								ClassName:"DHCDoc.DHCDocConfig.CNMedCode", 
								MethodName:"DelNoICDDiagEntryLimit",
								index:ID,
								HospId:HospID
							},false); 
					        if(value=="0"){
						       $('#tabNOICDDiagEntryLimit').datagrid('unselectAll').datagrid('load');
							   LimitRowid="";
       					       $.messager.show({title:"提示",msg:"删除成功"});
					        }else{
						       $.messager.alert('提示',"删除失败:"+value);
						       return false;
					        }
                            var ChangeJsonStr = JSON.stringify(PreNoICDDiagObj);
                            if (ChangeJsonStr!="{}"){
                                var HospDesc = $HUI.combogrid('#_HospList').getText();
                                var Type="D";
                                var Ret = tkMakeServerCall("web.DHCDocDataChangeLog","SaveLog","DHCDocConfig","DHCDoc.DHCDocConfig.DocConfig","医生站常规设置","User.CTHospital_"+HospID+":"+ID,HospDesc+":非ICD诊断录入限制规则",Type,"","",session['LOGON.USERID'],ChangeJsonStr,"Y");
                            }
					        editRow4 = undefined;
                        }
                    });
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
            }
        },{
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
                //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                editRow4 = undefined;
                $('#tabNOICDDiagEntryLimit').datagrid("rejectChanges");
                $('#tabNOICDDiagEntryLimit').datagrid("unselectAll");
				LimitRowid=""
            }
        },{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
			  if (editRow4 != undefined) {
				var rows=$('#tabNOICDDiagEntryLimit').datagrid("selectRow",editRow4).datagrid("getSelected");
				var editors = $('#tabNOICDDiagEntryLimit').datagrid('getEditors', editRow4);
				var LimitAdmTypeStr=editors[0].target.combobox('getValues').join(',');
				if (!LimitAdmTypeStr) LimitAdmTypeStr="";
				var LimitBilltypeStr=editors[1].target.combobox('getValues').join(',');
				if (!LimitBilltypeStr) LimitBilltypeStr="";
				var LimitDiagnosStr=editors[2].target.combobox('getValues').join(',');
				if (!LimitDiagnosStr) LimitDiagnosStr="";
				if ((!LimitAdmTypeStr)&&(!LimitBilltypeStr)&&(!LimitDiagnosStr)) {
					$.messager.alert('提示',"请选择限制条件!");
					return false;
				}
				var Str=LimitAdmTypeStr+"^"+LimitBilltypeStr+"^"+LimitDiagnosStr;
				var HospID=$HUI.combogrid('#_HospList').getValue();
                var rowid=rows.rowid;
				if (!rowid) {
                    rowid="";
                    var PreNoICDDiagObj={"Code":"NOICDDiagEntryLimit","Id":"","Value":""}
                }else{
                    var PreNoICDDiagObj=GetNoICDDiagObj(rowid,"NOICDDiagEntryLimit",HospID);
                }
				var value=$.m({ 
					ClassName:"DHCDoc.DHCDocConfig.CNMedCode", 
					MethodName:"SaveNoICDDiagEntryLimit",
					index:rowid,
					NodeValue:Str,
					HospId:HospID
				},false); 
				if(value==0){
				   PTRowid="";
				   $('#tabNOICDDiagEntryLimit').datagrid('unselectAll').datagrid('load');
				   $.messager.show({title:"提示",msg:"保存成功"});
				}else if(value=="Repeat"){
					$.messager.alert('提示',"保存失败!记录重复!");
					return false;
				}else{
				   $.messager.alert('提示',"保存失败:"+value);
				   return false;
				}
                var NoICDDiagObj=GetNoICDDiagObj(rowid,"NOICDDiagEntryLimit",HospID);
                var ChangeObj = GetChangeObj(PreNoICDDiagObj, NoICDDiagObj);
                var ChangeJsonStr = JSON.stringify(ChangeObj);
                if (ChangeJsonStr!="{}"){
                    var HospDesc = $HUI.combogrid('#_HospList').getText();
                    var Type=(rowid=="")?"A":"U";
                    var Ret = tkMakeServerCall("web.DHCDocDataChangeLog","SaveLog","DHCDocConfig","DHCDoc.DHCDocConfig.DocConfig","医生站常规设置","User.CTHospital_"+HospID+":"+rowid,HospDesc+":非ICD诊断录入限制规则",Type,"","",session['LOGON.USERID'],ChangeJsonStr,"Y");
                }
				editRow4 = undefined;				
			 }
			}
		}];
	//rowid,LimitAdmTypeStr,LimitBilltypeStr,LimitDiagnosStr,LimitAdmTypeDescStr,LimitBilltypeDescStr,LimitDiagnosDescStr
	var Columns=[[    
		{ field: 'LimitAdmTypeStr', title: '就诊类型',width:150,
			editor :{  
				type:'combobox',  
				options:{
					valueField:'id',
					textField:'text',
					required:false,
					multiple:true,
				    rowStyle:'checkbox',
					data:[{id: 'O',text: '门诊'},
						  {id: 'E',text: '急诊'},
						  {id: 'I',text: '住院'},
						  {id: 'H',text: '体检'}
						 ]
				  }
			 },
			 formatter:function(BillTypeRowid,record){
				  return record.LimitAdmTypeDescStr;
			 }
		},
		{ field: 'LimitBilltypeStr', title:'费别',width:150,
	  		editor :{  
				type:'combobox', 
				options:{
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.OrderItemQtyLimit&QueryName=FindBillTypeConfig&value=&HospId="+$HUI.combogrid('#_HospList').getValue(),
					valueField:'BillTypeRowid',
					textField:'BillTypeDesc',
					multiple:true,
				    rowStyle:'checkbox',
					loadFilter: function(data){
						return data['rows'];
					}
				  }
			},
			formatter:function(BillTypeRowid,record){
				  return record.LimitBilltypeDescStr;
			}
		},
		{ field: 'LimitDiagnosStr', title: '诊断状态',width:150,
			editor :{  
				type:'combobox',  
				options:{
					url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=FindDiagStatus",
					valueField:'DSTATRowId',
					textField:'DSTATDesc',
					multiple:true,
				    rowStyle:'checkbox',
					loadFilter: function(data){
						return data['rows'];
					}
				  }
			},
			formatter:function(BillTypeRowid,record){
				  return record.LimitDiagnosDescStr;
			}
		}
	 ]];
	$('#tabNOICDDiagEntryLimit').datagrid({  
		fit : true,
		width : $(window).height()-400,
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		url:$URL+"?ClassName=DHCDoc.DHCDocConfig.CNMedCode&QueryName=GetNOICDDiagEntryLimitQuery&value=NOICDDiagEntryLimit",
		loadMsg : '加载中..',  
		pagination : false,  //是否分页
		rownumbers : true,  //
		idField:"rowid",
		columns :Columns,
		toolbar:ToolBar,
		onClickRow:function(rowIndex, rowData){
            if (editRow4 != undefined) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存", "error");
		        return false;
			}
			$('#tabNOICDDiagEntryLimit').datagrid("beginEdit", rowIndex);
			editRow4=rowIndex
			//SelBillTypeRowid=rowData.BillTypeRowid
		},
        onBeforeLoad:function(param){
	        editRow4=undefined;
	        $('#tabNOICDDiagEntryLimit').datagrid("unselectAll");
	        param.HospId=$HUI.combogrid('#_HospList').getValue();
	    }
	});
}

function LoadAuthHtml() {
    $m({
        ClassName: "BSP.SYS.SRV.AuthItemApply",
        MethodName: "GetStatusHtml",
        AuthCode: "HIS-DOC-CONFIG"
    }, function (rtn) {
        if (rtn != "") {
            //此处是放在相应的按钮后还是只放在保存信息处
            //$(rtn).insertAfter('#Check_CheckIPDeposit');
            //放在label之后
            $(rtn).insertAfter("[for='Check_CheckIPDeposit']");
            $(rtn).insertAfter("[for='Check_OPOrderEntryLock']");
            $(rtn).insertAfter("[for='Check_UserEMVirtualtLong']");
            
            $("#Text_OPAdmDayLimit,#Text_EPAdmDayLimit").css({"width":"58px"});
            $(rtn).insertAfter("[for='Check_OPLimitTypeHour']");
            $(rtn).insertAfter("[for='Check_EPLimitTypeHour']");
            $('#SkinTitle').panel('setTitle',"<label>皮试流程</label>"+rtn);
        }
    })
}

/// 获取界面的配置数据
function GetConfigObj() {
    var HospID = $HUI.combogrid('#_HospList').getValue();
    if ((!HospID) || (HospID == "")) {
        HospID = session['LOGON.HOSPID'];
    }
    var ConfigObj = new Array();
    var LogDescObj = new Array();
    var LogObj = arrayObj1.concat(arrayObj2,arrayObj3,arrayObj4);
    $.each(LogObj, function (index, OneObj) {
        ConfigObj.push(OneObj[1]);
        var LogDesc=$("[for='"+OneObj[0]+"']").html()||"";
        LogDescObj[OneObj[1]]=LogDesc
    });
    arrayLogObj=$.extend(LogDescObj,arrayLogObj);
    ConfigObj.push("CurrentHospital");
    ConfigObj.push("IPShortOrderPriorDefFreq");
    arrayLogObj["CurrentHospital"]="当前医院";
    arrayLogObj["IPShortOrderPriorDefFreq"]="住院临时医嘱默认频次";

    var Coninfo = ConfigObj.join("^");
    var ConfigJsonObj = $.cm({
        ClassName: "DHCDoc.DHCDocConfig.DocConfig",
        MethodName: "getDefaultDataJson1",
        Coninfo: Coninfo,
        HospId: HospID
    }, false);
    return ConfigJsonObj;
}
function GetNoICDDiagObj(ID,Code,HospID){
    var ConfigJsonObj = $.cm({
        ClassName: "DHCDoc.DHCDocConfig.CNMedCode",
        MethodName: "GetNoICDDiagEntryLimit",
        Index:ID,
        NodeValue:Code, 
        HospID:HospID
    }, false);
    return ConfigJsonObj;
}
/// 对比两个对象的差异值 {"a":1,"b":2}
function GetChangeObj(OldObj, NewObj) {
    var ChangeObj = {};
    $.each(OldObj, function (key, Val) {
        var NewVal = NewObj[key];
        if (Val == NewVal) return true;
        var ChangeVal = Val + "->" + NewVal;
        var LogDesc=arrayLogObj[key]||key
        ChangeObj[LogDesc] = ChangeVal;
    });
    return ChangeObj;
}