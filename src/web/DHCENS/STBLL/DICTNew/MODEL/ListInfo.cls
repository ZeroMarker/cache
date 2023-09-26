Class web.DHCENS.STBLL.DICTNew.MODEL.ListInfo Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "ListInfo";

// Property CareProvList As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCareProv(XMLPROJECTION = "ELEMENT");

Property CTCareProv As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCareProv(XMLPROJECTION = "ELEMENT");

Property CTDeptList As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTDept(XMLPROJECTION = "ELEMENT");

Property CTHospital As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTHospital(XMLPROJECTION = "ELEMENT");

Property CTAllergyCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTAllergyCategory(XMLPROJECTION = "ELEMENT");

Property CTBodyArea As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTBodyArea(XMLPROJECTION = "ELEMENT");

Property CTCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCategory(XMLPROJECTION = "ELEMENT");

Property CTChildCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTChildCategory(XMLPROJECTION = "ELEMENT");

Property CTARCItmMast As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTARCItmMast(XMLPROJECTION = "ELEMENT");

Property CTProvince As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTProvince(XMLPROJECTION = "ELEMENT");

Property CTCity As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCity(XMLPROJECTION = "ELEMENT");

Property CTCountry As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCountry(XMLPROJECTION = "ELEMENT");

Property CTCounty As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCounty(XMLPROJECTION = "ELEMENT");

Property CTDiagnoseType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTDiagnoseType(XMLPROJECTION = "ELEMENT");

Property CTWard As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTWard(XMLPROJECTION = "ELEMENT");

Property CTDischCondit As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTDischCondit(XMLPROJECTION = "ELEMENT");

Property CTDoseForms As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTDoseForms(XMLPROJECTION = "ELEMENT");

Property CTDoseUnit As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTDoseUnit(XMLPROJECTION = "ELEMENT");

Property CTDuration As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTDuration(XMLPROJECTION = "ELEMENT");

Property CTBedType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTBedType(XMLPROJECTION = "ELEMENT");

Property CTFreq As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTFreq(XMLPROJECTION = "ELEMENT");

Property CTIdentifierType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTIdentifierType(XMLPROJECTION = "ELEMENT");

Property CTInstr As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTInstr(XMLPROJECTION = "ELEMENT");

Property CTMarital As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTMarital(XMLPROJECTION = "ELEMENT");

Property CTNation As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTNation(XMLPROJECTION = "ELEMENT");

Property CTOccupation As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTOccupation(XMLPROJECTION = "ELEMENT");

Property CTOrderStatus As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTOrderStatus(XMLPROJECTION = "ELEMENT");

Property CTPriority As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTPriority(XMLPROJECTION = "ELEMENT");

Property CTRelation As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTRelation(XMLPROJECTION = "ELEMENT");

Property CTResultStatus As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTResultStatus(XMLPROJECTION = "ELEMENT");

Property CTRoom As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTRoom(XMLPROJECTION = "ELEMENT");

Property CTBed As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTBed(XMLPROJECTION = "ELEMENT");

Property CTSex As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTSex(XMLPROJECTION = "ELEMENT");

Property CTSpecimen As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTSpecimen(XMLPROJECTION = "ELEMENT");

Property CTSpec As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTSpec(XMLPROJECTION = "ELEMENT");

Property CTDiagnose As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTDiagnose(XMLPROJECTION = "ELEMENT");

Property CTObservationItem As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTObservationItem(XMLPROJECTION = "ELEMENT");

Property CTOperation As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTOperation(XMLPROJECTION = "ELEMENT");

Property CTOperationLevel As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTOperationLevel(XMLPROJECTION = "ELEMENT");

Property CTOperationPart As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTOperationPart(XMLPROJECTION = "ELEMENT");

Property CTOperationPosition As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTOperationPosition(XMLPROJECTION = "ELEMENT");

Property CTMedicineMaterial As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTMedicineMaterial(XMLPROJECTION = "ELEMENT");

Property CTBillCat As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTBillCat(XMLPROJECTION = "ELEMENT");

Property CTBillChildCat As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTBillChildCat(XMLPROJECTION = "ELEMENT");

/// 以下字段为2018.9新增,根据<主数据表结构说明V1.4.doc>
Property CTOperationRoom As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTOperationRoom(XMLPROJECTION = "ELEMENT");

Property CTAnaesthesiaMethod As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTAnaesthesiaMethod(XMLPROJECTION = "ELEMENT");

Property CTAnaesthesiaLevel As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTAnaesthesiaLevel(XMLPROJECTION = "ELEMENT");

// Property CTORCAnaestType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTORCAnaestType(XMLPROJECTION = "ELEMENT");

Property CTChargeItemPrice As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTChargeItemPrice(XMLPROJECTION = "ELEMENT");

Property CTRoomType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTRoomType(XMLPROJECTION = "ELEMENT");

Property CTDeptLinkWard As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTDeptLinkWard(XMLPROJECTION = "ELEMENT");

Property CTCareProvLinkDept As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCareProvLinkDept(XMLPROJECTION = "ELEMENT");

Property CTCostCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCostCategory(XMLPROJECTION = "ELEMENT");

Property CTCardType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCardType(XMLPROJECTION = "ELEMENT");

Property CTPatientPosition As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTPatientPosition(XMLPROJECTION = "ELEMENT");

Property CTPHDrgMaterialStock As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTPHDrgMaterialStock(XMLPROJECTION = "ELEMENT");

Property CTChargeItem As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTTarItem(XMLPROJECTION = "ELEMENT");

Property CTPHDrgMaterialItm As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTPHDrgMaterialItm(XMLPROJECTION = "ELEMENT");

Property CTDeptDepartmentGroup As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTDeptDepartmentGroup(XMLPROJECTION = "ELEMENT");

Property CTDeptHierarchy As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTDeptHierarchy(XMLPROJECTION = "ELEMENT");

Property CTSCCarrier As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTSCCarrier(XMLPROJECTION = "ELEMENT");

Property CTSCVendor As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTSCVendor(XMLPROJECTION = "ELEMENT");

Property CTSCManufacturer As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTPHManufacturer(XMLPROJECTION = "ELEMENT");

Property CTSCOrigin As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTSCOrigin(XMLPROJECTION = "ELEMENT");

Property CTPHCGeneric As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTPHCGeneric(XMLPROJECTION = "ELEMENT");

Property CTPostCode As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTPostCode(XMLPROJECTION = "ELEMENT");

Property CTPHCPoison As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTPHCPoison(XMLPROJECTION = "ELEMENT");

Property CTPHCCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTPharmacologyCategory(XMLPROJECTION = "ELEMENT");

Property CTPHConversionFactor As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTConFac(XMLPROJECTION = "ELEMENT");

Property CTPHUnit As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTPHUnit(XMLPROJECTION = "ELEMENT");

Property CTStockCategorySubGroup As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTStockCategorySubGroup(XMLPROJECTION = "ELEMENT");

Property CTStockCategoryGroup As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTStockCategoryGroup(XMLPROJECTION = "ELEMENT");

Property CTStaffType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTStaffType(XMLPROJECTION = "ELEMENT");

Property CTEMChargeCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTEMChargeCategory(XMLPROJECTION = "ELEMENT");

Property CTEMChargeChildCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTEMChargeChildCategory(XMLPROJECTION = "ELEMENT");

Property CTChargeCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTChargeCategory(XMLPROJECTION = "ELEMENT");

Property CTChargeChildCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTChargeChildCategory(XMLPROJECTION = "ELEMENT");

Property CTACChargeCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTACChargeCategory(XMLPROJECTION = "ELEMENT");

Property CTACChargeChildCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTACChargeChildCategory(XMLPROJECTION = "ELEMENT");

Property CTIPChargeCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTIPChargeCategory(XMLPROJECTION = "ELEMENT");

Property CTIPChargeChildCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTIPChargeChildCategory(XMLPROJECTION = "ELEMENT");

Property CTOPChargeCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTOPChargeCategory(XMLPROJECTION = "ELEMENT");

Property CTOPChargeChildCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTOPChargeChildCategory(XMLPROJECTION = "ELEMENT");

Property CTMRChargeCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTMRChargeCategory(XMLPROJECTION = "ELEMENT");

Property CTMRChargeChildCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTMRChargeChildCategory(XMLPROJECTION = "ELEMENT");

Property CTMRChargeCategoryNew As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTMRChargeCategoryNew(XMLPROJECTION = "ELEMENT");

Property CTMRChargeChildCategoryNew As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTMRChargeChildCategoryNew(XMLPROJECTION = "ELEMENT");

Property CTTitleOfTech As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTTitleOfTech(XMLPROJECTION = "ELEMENT");

Property CTReligion As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTReligion(XMLPROJECTION = "ELEMENT");

Property CTCareProvPosition As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCareProvPosition(XMLPROJECTION = "ELEMENT");

Property CTCareProvType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCareProvType(XMLPROJECTION = "ELEMENT");

Property CTAllergySeverity As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTAllergySeverity(XMLPROJECTION = "ELEMENT");

Property CTOrderAdminStatus As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTOrderAdminStatus(XMLPROJECTION = "ELEMENT");

Property CTRBCAppointMethod As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTRBCAppointMethod(XMLPROJECTION = "ELEMENT");

Property CTORCAnaestType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTAnaesthesiaType(XMLPROJECTION = "ELEMENT");

Property CTORCAnaestComplications As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTORCAnaestComplications(XMLPROJECTION = "ELEMENT");

Property CTCutType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCutType(XMLPROJECTION = "ELEMENT");

/// add by lhm
Property CTEncounterStatus As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTEncounterStatus(XMLPROJECTION = "ELEMENT");

Property CTEncounterType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTEncounterType(XMLPROJECTION = "ELEMENT");

Property CTAddressType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTAddressType(XMLPROJECTION = "ELEMENT");

/// 20190708 zhangxinying
Property CTPHCChildCategory As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTPharmacologyChildCategory(XMLPROJECTION = "ELEMENT");

Property SSUser As list Of web.DHCENS.STBLL.DICTNew.MODEL.SSUser(XMLPROJECTION = "ELEMENT");

Property CTPayMode As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTPayMode(XMLPROJECTION = "ELEMENT");

Property CTAdmitMeans As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTAdmitMeans(XMLPROJECTION = "ELEMENT");

Property CTAdmitCondit As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTAdmitCondit(XMLPROJECTION = "ELEMENT");

Property CTABOBloodType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTABOBloodType(XMLPROJECTION = "ELEMENT");

Property CTAllergySource As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTAllergySource(XMLPROJECTION = "ELEMENT");

Property CTRegistrationCat As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTRegistrationCat(XMLPROJECTION = "ELEMENT");

Property CTRHBloodType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTRHBloodType(XMLPROJECTION = "ELEMENT");

Property CTDischMeans As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTDischMeans(XMLPROJECTION = "ELEMENT");

Property CTCutHealGrade As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCutHealGrade(XMLPROJECTION = "ELEMENT");

Property CTOrdStatusChReason As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTOrdStatusChReason(XMLPROJECTION = "ELEMENT");

Property CTCustomer As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCustomer(XMLPROJECTION = "ELEMENT");

Property CTTreatmentResult As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTTreatmentResult(XMLPROJECTION = "ELEMENT");

Property CTAdmitConditOfMedicalRcd As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTAdmitConditOfMedicalRcd(XMLPROJECTION = "ELEMENT");

Property CTOperationType As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTOperationType(XMLPROJECTION = "ELEMENT");

Property CTDiagnoseConformCondit As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTDiagnoseConformCondit(XMLPROJECTION = "ELEMENT");

Property CTCharacteristicClinic As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTCharacteristicClinic(XMLPROJECTION = "ELEMENT");

Property CTSecurityGroup As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTSecurityGroup(XMLPROJECTION = "ELEMENT");

Property CTUserOtherLogonDept As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTUserOtherLogonDept(XMLPROJECTION = "ELEMENT");

Property CTConsGroup As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTConsGroup(XMLPROJECTION = "ELEMENT");

Property CTConsGroupDetail As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTConsGroupDetail(XMLPROJECTION = "ELEMENT");

Property CTHisUser As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTHisUser(XMLPROJECTION = "ELEMENT");

Property CTPEItem As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTPEItem(XMLPROJECTION = "ELEMENT");

Property CTPEItemDetail As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTPEItemDetail(XMLPROJECTION = "ELEMENT");

Property CTDeptClass As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTDeptClass(XMLPROJECTION = "ELEMENT");

Property CTSystemCat As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTSystemCat(XMLPROJECTION = "ELEMENT");

Property CTSystems As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTSystems(XMLPROJECTION = "ELEMENT");

Property CTStatus As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTStatus(XMLPROJECTION = "ELEMENT");

Property CTStatusLinkSystem As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTStatusLinkSystem(XMLPROJECTION = "ELEMENT");

Property CTDHCPHCCat As list Of web.DHCENS.STBLL.DICTNew.MODEL.CTDHCPHCCat(XMLPROJECTION = "ELEMENT");

}
