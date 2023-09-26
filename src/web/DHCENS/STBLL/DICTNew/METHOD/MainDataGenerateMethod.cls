Class web.DHCENS.STBLL.DICTNew.METHOD.MainDataGenerateMethod Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod GetJsonFromObj(inputObj As %RegisteredObject) As %String
{
	set jsonObj=##class(%Library.DynamicObject).%New()
	set className=inputObj.%ClassName(2)
	set classDef=##class(%Dictionary.CompiledClass).%OpenId(className)
	set proCount=classDef.Properties.Count()
	for i=1:1:proCount{
		set proDef=##class(%Dictionary.PropertyDefinition).%New()
		set proDef=classDef.Properties.GetAt(i)
		set XMLName=proDef.SqlFieldName
		set proName=proDef.Name
		continue:$e(proName,1)="%"
		set value=$PROPERTY(inputObj,proName)
		do jsonObj.%Set(XMLName,value)	
	}
	q jsonObj.%ToJSON()
}

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataGenerateMethod).test()
ClassMethod test()
{
	set obj=##class(web.DHCENS.STBLL.DICTNew.MODEL.CTSex).%New()
	set obj.CTSCode="1"
	set obj.CTSDesc="女"
	set tSC=##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataGenerateMethod).GetJsonFromObj(obj)	
	q tSC
}

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataGenerateMethod).SaveEnsInterfaceMethod1()
ClassMethod SaveEnsInterfaceMethod1()
{
	/*
	set ^tmpyr("APC_Vendor")="CT_SCVendor^供应商^web.DHCENS.STBLL.DICTNew.METHOD.CTSCVendor^GetCTAPCVendor^Y^医院信息平台^webMethod"
	set ^tmpyr("ARC_BillGrp")="CT_BillCat^账单大类^web.DHCENS.STBLL.DICTNew.METHOD.CTBillCat^GetCTBillCat^Y^医院信息平台^webMethod"
	set ^tmpyr("ARC_BillSub")="CT_BillChildCat^账单子类^web.DHCENS.STBLL.DICTNew.METHOD.CTBillChildCat^GetCTBillChildCat^Y^医院信息平台^webMethod"
	set ^tmpyr("ARC_ItemCat")="CT_ChildCategory^医嘱子类^web.DHCENS.STBLL.DICTNew.METHOD.CTChildCategory^GetCTChildCategory^Y^医院信息平台^webMethod"
	set ^tmpyr("ARC_ItmMast")="CT_ARCItmMast^医嘱项目^web.DHCENS.STBLL.DICTNew.METHOD.CTARCItmMast^GetCTARCItmMast^Y^医院信息平台^webMethod"
	set ^tmpyr("CT_CarPrvTp")="CT_CareProvType^医护人员类型^web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvType^GetCTCareProvType^Y^医院信息平台^webMethod"
	;set ^tmpyr("CT_CareProv")="CT_CareProv^人员^web.DHCENS.STBLL.DICTNew.METHOD.CTCareProv^GetCTCareProv^Y^医院信息平台^webMethod"
	set ^tmpyr("CT_ConFac")="CT_PHConversionFactor^药品转换系数^web.DHCENS.STBLL.DICTNew.METHOD.CTConFac^GetCTConFac^Y^医院信息平台^webMethod"
	set ^tmpyr("CT_SocialStatus")="CT_PatientPosition^患者身份^web.DHCENS.STBLL.DICTNew.METHOD.CTPatientPosition^GetCTPatientPosition^Y^医院信息平台^webMethod"
	set ^tmpyr("CT_UOM")="CT_PHUnit^药品单位^web.DHCENS.STBLL.DICTNew.METHOD.CTPHUnit^GetCTPHUnit^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_ANC_OPLevel")="CT_OperationLevel^手术级别字典表^^^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_CardTypeDef")="CT_CardType^卡类型^web.DHCENS.STBLL.DICTNew.METHOD.CTCardType^GetCTCardType^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_Carrier")="CT_SCCarrier^配送商^web.DHCENS.STBLL.DICTNew.METHOD.CTSCCarrier^GetCTSCCarrier^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_StkCatGroup")="CT_StockCategoryGroup^库存类组^web.DHCENS.STBLL.DICTNew.METHOD.CTStockCategoryGroup^GetCTStkCatGrp^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_StkCatSubGrp")="CT_StockCategorySubGroup^库存分类^web.DHCENS.STBLL.DICTNew.METHOD.CTStockCategorySubGroup^^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_TarAC")="CT_ACChargeCategory^会计大类^web.DHCENS.STBLL.DICTNew.METHOD.CTACChargeCategory^GetCTACChargeCategory^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_TarAcctCate")="CT_ACChargeChildCategory^会计子类^web.DHCENS.STBLL.DICTNew.METHOD.CTACChargeChildCategory^GetCTACChargeChildCategory^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_TarCate")="CT_ChargeCategory^收费项大类^web.DHCENS.STBLL.DICTNew.METHOD.CTChargeCategory^GetCTChargeCategory^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_TarEC")="CT_EMChargeCategory^核算大类^web.DHCENS.STBLL.DICTNew.METHOD.CTEMChargeCategory^GetCTEMChargeCategory^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_TarEMCCate")="CT_EMChargeChildCategory^核算子类^web.DHCENS.STBLL.DICTNew.METHOD.CTEMChargeChildCategory^GetCTEMChargeChildCategory^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_TarIC")="CT_IPChargeCategory^住院大类^web.DHCENS.STBLL.DICTNew.METHOD.CTIPChargeCategory^GetCTIPChargeCategory^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_TarInpatCate")="CT_IPChargeChildCategory^住院子类^web.DHCENS.STBLL.DICTNew.METHOD.CTIPChargeChildCategory^GetCTIPChargeChildCategory^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_TarMC")="CT_MRChargeCategory^病案大类^web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeCategory^GetCTMRChargeCategory^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_TarMRCate")="CT_MRChargeChildCategory^病案子类^web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeChildCategory^GetCTMRChargeChildCategory^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_TarOC")="CT_OPChargeCategory^门诊大类^web.DHCENS.STBLL.DICTNew.METHOD.CTOPChargeCategory^GetCTOPChargeCategory^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_TarOutpatCate")="CT_OPChargeChildCategory^门诊子类^web.DHCENS.STBLL.DICTNew.METHOD.CTOPChargeChildCategory^GetCTOPChargeChildCategory^Y^医院信息平台^webMethod"
	set ^tmpyr("DHC_TarSubCate")="CT_ChargeChildCategory^收费项子类^web.DHCENS.STBLL.DICTNew.METHOD.CTChargeChildCategory^GetCTChargeChildCategory^Y^医院信息平台^webMethod"
	//set ^tmpyr("HISCode")="CT_RegistrationCat^挂号号别^web.DHCENS.STBLL.DICTNew.METHOD.CTRBCSessionType^GetCTRBCSessionType^Y^医院信息平台^webMethod"
	set ^tmpyr("INC_Itm")="CT_PHDrgMaterialItm^药学项^^^Y^医院信息平台^webMethod"
	set ^tmpyr("MRC_DiagnosType")="CT_DiagnoseType^诊断类型^web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnoseType^GetCTDiagnoseType^Y^医院信息平台^webMethod"
	set ^tmpyr("MRC_ObservationItem")="CT_ObservationItem^生命体征测量项目字典表^web.DHCENS.STBLL.DICTNew.METHOD.CTObservationItem^GetCTObservationItem^Y^医院信息平台^webMethod"
	set ^tmpyr("OEC_AdminStatusChReason")="CT_OrdStatusChReason^医嘱执行状态变化原因^web.DHCENS.STBLL.DICTNew.METHOD.CTOrdStatusChReason^GetCTOrdStatusChReason^Y^医院信息平台^webMethod"
	set ^tmpyr("OEC_BodySite")="CT_OperationPart^手术部位字典表^web.DHCENS.STBLL.DICTNew.METHOD.CTOperationPart^GetCTOperationPart^Y^医院信息平台^webMethod"
	set ^tmpyr("OEC_OrderCategory")="CT_Category^医嘱大类^web.DHCENS.STBLL.DICTNew.METHOD.CTCategory^GetCTCategory^Y^医院信息平台^webMethod"
	set ^tmpyr("OEC_OrderStatus")="CT_OrderStatus^医嘱状态^web.DHCENS.STBLL.DICTNew.METHOD.CTOrderStatus^GetCTOrderStatus^Y^医院信息平台^webMethod"
	set ^tmpyr("OEC_Order_AdminStatus")="CT_OrderAdminStatus^医嘱执行状态^web.DHCENS.STBLL.DICTNew.METHOD.CTOrderAdminStatus^GetCTOrderAdminStatus^Y^医院信息平台^webMethod"
	set ^tmpyr("OEC_Priority")="CT_Priority^医嘱类型^web.DHCENS.STBLL.DICTNew.METHOD.CTPriority^GetCTPriority^Y^医院信息平台^webMethod"
	set ^tmpyr("ORC_ASA_ClassPhActiv")="CT_AnaesthesiaLevel^麻醉级别^web.DHCENS.STBLL.DICTNew.METHOD.CTAnaesthesiaLevel^GetCTAnaesthesiaLevel^Y^医院信息平台^webMethod"
	set ^tmpyr("ORC_AnaestMethod")="CT_AnaesthesiaMethod^麻醉方式^web.DHCENS.STBLL.DICTNew.METHOD.CTAnaesthesiaMethod^GetCTAnaesthesiaMethod^Y^医院信息平台^webMethod"
	set ^tmpyr("ORC_BladeType")="CT_CutType^切口类型^web.DHCENS.STBLL.DICTNew.METHOD.CTCutType^GetCTCutType^Y^医院信息平台^webMethod"
	set ^tmpyr("ORC_OperPosition")="CT_OperationPosition^手术体位字典表^web.DHCENS.STBLL.DICTNew.METHOD.CTOperationPosition^GetCTOperationPosition^Y^医院信息平台^webMethod"
	set ^tmpyr("PAC_Bed")="CT_Bed^床位^web.DHCENS.STBLL.DICTNew.METHOD.CTBed^GetCTBed^Y^医院信息平台^webMethod"
	set ^tmpyr("PAC_BedType")="CT_BedType^床位类型^web.DHCENS.STBLL.DICTNew.METHOD.CTBedType^GetCTBedType^Y^医院信息平台^webMethod"
	set ^tmpyr("PAC_DischCondit")="CT_DischCondit^出院情况^web.DHCENS.STBLL.DICTNew.METHOD.CTDischCondit^GetCTDischCondit^Y^医院信息平台^webMethod"
	set ^tmpyr("PAC_RoomType")="CT_RoomType^房间类型^^^Y^医院信息平台^webMethod"
	set ^tmpyr("PHC_Cat")="CT_PHCCategory^药理学分类^web.DHCENS.STBLL.DICTNew.METHOD.CTPharmacologyCategory^GetCTPharmacologyCategory^Y^医院信息平台^webMethod"
	set ^tmpyr("PHC_Duration")="CT_Duration^疗程^web.DHCENS.STBLL.DICTNew.METHOD.CTDuration^GetCTDuration^Y^医院信息平台^webMethod"
	set ^tmpyr("PHC_Form")="CT_DoseForms^剂型^web.DHCENS.STBLL.DICTNew.METHOD.CTDoseForms^GetCTDoseForms^Y^医院信息平台^webMethod"
	set ^tmpyr("PHC_Freq")="CT_Freq^频次^web.DHCENS.STBLL.DICTNew.METHOD.CTFreq^GetCTFreq^Y^医院信息平台^webMethod"
	set ^tmpyr("PHC_Generic")="CT_PHCGeneric^药品通用名^web.DHCENS.STBLL.DICTNew.METHOD.CTPHCGeneric^GetCTPHCGeneric^Y^医院信息平台^webMethod"
	set ^tmpyr("PHC_Instruc")="CT_Instr^用药途径^web.DHCENS.STBLL.DICTNew.METHOD.CTInstr^GetCTInstr^Y^医院信息平台^webMethod"
	set ^tmpyr("PHC_Poison")="CT_PHCPoison^管制分类^web.DHCENS.STBLL.DICTNew.METHOD.CTPHCPoison^GetCTPHCPoison^Y^医院信息平台^webMethod"
	set ^tmpyr("PHC_SubCat")="CT_PHCCategory^药学分类^^^Y^医院信息平台^webMethod"
	set ^tmpyr("PH_Manufacturer")="CT_SCManufacturer^生产厂商^web.DHCENS.STBLL.DICTNew.METHOD.CTPHManufacturer^GetCTPHManufacturer^Y^医院信息平台^webMethod"
	set ^tmpyr("RBC_AppointMethod")="CT_RBCAppointMethod^预约方式^web.DHCENS.STBLL.DICTNew.METHOD.CTRBCAppointMethod^GetCTRBCAppointMethod^Y^医院信息平台^webMethod"
	set ^tmpyr("RBC_DepartmentGroup")="CT_DeptDepartmentGroup^科室部门组^web.DHCENS.STBLL.DICTNew.METHOD.CTDeptDepartmentGroup^GetCTDeptDepartmentGroup^Y^医院信息平台^webMethod"
	set ^tmpyr("RBC_SessionType")="CT_RegistrationCat^挂号号别^web.DHCENS.STBLL.DICTNew.METHOD.CTRBCSessionType^GetCTRBCSessionType^Y^医院信息平台^webMethod"
	
	
	set ^tmpyr("RH_BloodType")=("CT_RHBloodType^RH血型^web.DHCENS.STBLL.DICTNew.METHOD.CTRHBloodType^GetCTRHBloodType^Y^医院信息平台^webMethod")
	set ^tmpyr("PAC_DepartureMeans")=("CT_DischMeans^离院方式^web.DHCENS.STBLL.DICTNew.METHOD.CTDischMeans^GetCTDischMeans^Y^医院信息平台^webMethod")
	set ^tmpyr("ORC_BladeHealLevel")=("CT_CutHealGrade^切口愈合等级^web.DHCENS.STBLL.DICTNew.METHOD.CTCutHealGrade^GetCTCutHealGrade^Y^医院信息平台^webMethod")
	set ^tmpyr("CT_PayMode")=("CT_PayMode^发票支付方式^web.DHCENS.STBLL.DICTNew.METHOD.CTPayMode^GetCTPayMode^Y^医院信息平台^webMethod")
	set ^tmpyr("PAC_TransferMeans")=("CT_AdmitMeans^入院途径^web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitMeans^GetCTAdmitMeans^Y^医院信息平台^webMethod")
	set ^tmpyr("PAC_ReferralPriority")=("CT_AdmitCondit^入院情况^web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitCondit^GetCTAdmitCondit^Y^医院信息平台^webMethod")
	set ^tmpyr("PAC_BloodType")=("CT_ABOBloodType^ABO血型^web.DHCENS.STBLL.DICTNew.METHOD.CTABOBloodType^GetCTABOBloodType^Y^医院信息平台^webMethod")
	set ^tmpyr("PAC_Allergy")=("CT_AllergySource^过敏源^web.DHCENS.STBLL.DICTNew.METHOD.CTAllergySource^GetCTAllergySource^Y^医院信息平台^webMethod")
	//set ^tmpyr("RBC_SessionType")=("CT_RegistrationCat^挂号号别^web.DHCENS.STBLL.DICTNew.METHOD.CTRegistrationCat^GetCTRegistrationCat^Y^医院信息平台^webMethod")
	*/
	
	//set ^tmpyr("PAC_RoomType")="CT_RoomType^房间类型^web.DHCENS.STBLL.DICTNew.METHOD.CTRoomType^GetCTRoomType^Y^医院信息平台^webMethod"
	
	//set ^tmpyr("PAC_AdmReason")="CT_CostCategory^患者费别^web.DHCENS.STBLL.DICTNew.METHOD.CTCostCategory^GetCTCostCategory^Y^医院信息平台^webMethod"
	//set ^tmpyr("CT_Hospital")="CT_Hospital^获取院区字典信息^web.DHCENS.STBLL.DICTNew.METHOD.CTHospital^GetCTHospital^Y^医院信息平台^webMethod"
	//set ^tmpyr("PAC_Ward")="CT_Ward^获取病区字典信息^web.DHCENS.STBLL.DICTNew.METHOD.CTWard^GetCTWard^Y^医院信息平台^webMethod"
	//set ^tmpyr("CT_Zip")="CT_Postcode^获取邮政编码字典信息^web.DHCENS.STBLL.DICTNew.METHOD.CTPostCode^GetCTPostCode^Y^医院信息平台^webMethod"
	//set ^tmpyr("INC_Itm")="CT_PHDrgMaterialItm^获取药品或材料字典信息^web.DHCENS.STBLL.DICTNew.METHOD.CTPHDrgMaterialItm^GetDrgOrMaterial^Y^医院信息平台^webMethod"
	//set ^tmpyr("OEC_ResultStatus")="CT_ResultStatus^医嘱结果状态字典信息^web.DHCENS.STBLL.DICTNew.METHOD.CTResultStatus^GetCTResultStatus^Y^医院信息平台^webMethod"
#;	set ^tmpyr("MRFHQK")="CT_DiagnoseConformCondit^诊断符合情况[病案]字典信息^web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnoseConformCondit^GetCTDiagnoseConformCondit^Y^医院信息平台^webMethod"
#;	set ^tmpyr("MROperType")="CT_OperationType^手术操作类型[病案]字典信息^web.DHCENS.STBLL.DICTNew.METHOD.CTOperationType^GetCTOperationType^Y^医院信息平台^webMethod"
#;	set ^tmpyr("MRRYBQ")="CT_AdmitConditOfMedicalRcd^入院病情[病案]字典信息^web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitConditOfMedicalRcd^GetCTAdmitConditOfMedicalRcd^Y^医院信息平台^webMethod"
#;	set ^tmpyr("MRZLJG")="CT_TreatmentResult^治疗结果[病案]字典信息^web.DHCENS.STBLL.DICTNew.METHOD.CTTreatmentResult^GetCTTreatmentResult^Y^医院信息平台^webMethod"
	//set ^tmpyr("RBC_CharacteristicClinic")="CT_CharacteristicClinic^排班特色门诊字典信息^web.DHCENS.STBLL.DICTNew.METHOD.CTCharacteristicClinic^GetCTCharacteristicClinic^Y^医院信息平台^webMethod"
	set ^tmpyr("SS_User1")="SS_User^用户字典信息^web.DHCENS.STBLL.DICTNew.METHOD.SSUser^GetSSUser^Y^医院信息平台^webMethod"

	b ;33
	set status="Y",sys="医院信息平台",type="webMethod"
	set id="" for  set id=$o(^tmpyr(id)) q:id=""  do
	.set str=^tmpyr(id)
	.set hisCode=id
	.set mdmCode=$p(str,"^",1)
	.q:mdmCode=""
	.set desc=$p(str,"^",2)
	.set class=$p(str,"^",3)
	.q:class=""
	.set method=$p(str,"^",4)
	.q:method=""
	.set rowId=$o(^User.EnsInterfaceMethodI("MethodCode",type,hisCode,""))
	.;q:rowId'=""
	.if rowId="" do
	..set methodObj=##class(User.EnsInterfaceMethod).%New()
	.else  do
	..set methodObj=##class(User.EnsInterfaceMethod).%OpenId(rowId)
	
	.set methodObj.methodCode=hisCode
	.set methodObj.methodDesc=desc
	.set methodObj.methodStatus=status
	.set methodObj.methodProcuctionTerm=sys
	.set methodObj.methodClassName=class
	.set methodObj.methodName=method
	.set methodObj.methodType=type
	.set methodObj.methodPublishClassName="web.DHCENS.EnsWebService"
	.set methodObj.methodPublishName="DHCWebInterface"
	.set methodObj.methodInput="%String"_$char(2)_"N"_$char(2)_"rowId"
	.set methodObj.methodOutput="%GlobalCharacterStream"
	.;b ;00
	.set tsc=methodObj.%Save()
	.w tsc_":"_hisCode,!
	.;b ;01
	k ^tmpyr
	q "1"
}

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataGenerateMethod).ExportClassNew("D:\WorkData\SVN\","test")
ClassMethod ExportClassNew(package As %String, input As %String) As %String
{
	set $zt="Exception"
	q:input="" "0"
	;k ^TMPDHCENS("lyh","project",input)
	set rs=##class(%Library.ResultSet).%New("%Studio.Project:ProjectItemsList")
	set columns=rs.GetColumnCount()
	set sc=rs.Execute(input)
	set rowData="",i=0	
	for  q:rs.Next()=0  d
	.set name=rs.GetData(2)
	.set type=rs.GetData(3)
	.if type'="CLS" d
	..set className=name
	.e  d
	..set className=name_"."_type
	.set sc=##class(%File).Exists(package_name_".xml")
	.if sc d
	..set sc=##class(%File).Delete(package_name_".xml")
	
	
	.set sc=$SYSTEM.OBJ.Export(className,package_name_".xml","","UTF8")
	.set i=i+1
	.;s ^TMPDHCENS("lyh","project",input,i)=name_".xml"
	.s TMPDHCENS("lyh","project",input,i)=name_".xml"
	Quit "1^"_i
Exception
	Quit "-1^"_$ze
}

}
