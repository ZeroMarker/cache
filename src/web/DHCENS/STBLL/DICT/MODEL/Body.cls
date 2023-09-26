Class web.DHCENS.STBLL.DICT.MODEL.Body Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLIGNORENULL = 1;

Parameter XMLIGNOREINVALIDTAG = 1;

Parameter XMLNAME = "Body";

Property hospitals As list Of web.DHCENS.STBLL.DICT.MODEL.CTHospital(XMLNAME = "CT_HospitalList");

Property wards As list Of web.DHCENS.STBLL.DICT.MODEL.CTWard(XMLNAME = "CT_WardList");

Property rooms As list Of web.DHCENS.STBLL.DICT.MODEL.CTRoom(XMLNAME = "CT_RoomList");

Property bedTypes As list Of web.DHCENS.STBLL.DICT.MODEL.CTBedType(XMLNAME = "CT_BedTypeList");

Property beds As list Of web.DHCENS.STBLL.DICT.MODEL.CTBed(XMLNAME = "CT_BedList");

Property careProvs As list Of web.DHCENS.STBLL.DICT.MODEL.CTCareProv(XMLNAME = "CT_CareProvList");

Property depts As list Of web.DHCENS.STBLL.DICT.MODEL.CTDept(XMLNAME = "CT_DeptList");

Property diagnoses As list Of web.DHCENS.STBLL.DICT.MODEL.CTDiagnose(XMLNAME = "CT_DiagnoseList");

Property diagnoseTypes As list Of web.DHCENS.STBLL.DICT.MODEL.CTDiagnoseType(XMLNAME = "CT_DiagnoseTypeList");

Property categorys As list Of web.DHCENS.STBLL.DICT.MODEL.CTCategory(XMLNAME = "CT_CategoryList");

Property childCategorys As list Of web.DHCENS.STBLL.DICT.MODEL.CTChildCategory(XMLNAME = "CT_ChildCategoryList");

Property arcItmMasts As list Of web.DHCENS.STBLL.DICT.MODEL.CTARCItmMast(XMLNAME = "CT_ARCItmMastList");

Property priotitys As list Of web.DHCENS.STBLL.DICT.MODEL.CTPriority(XMLNAME = "CT_PriorityList");

Property orderStatuss As list Of web.DHCENS.STBLL.DICT.MODEL.CTOrderStatus(XMLNAME = "CT_OrderStatusList");

Property doseFormss As list Of web.DHCENS.STBLL.DICT.MODEL.CTDoseForms(XMLNAME = "CT_DoseFormsList");

Property doseUnits As list Of web.DHCENS.STBLL.DICT.MODEL.CTDoseUnit(XMLNAME = "CT_DoseUnitList");

Property freqs As list Of web.DHCENS.STBLL.DICT.MODEL.CTFreq(XMLNAME = "CT_FreqList");

Property instrs As list Of web.DHCENS.STBLL.DICT.MODEL.CTInstr(XMLNAME = "CT_InstrList");

Property durations As list Of web.DHCENS.STBLL.DICT.MODEL.CTDuration(XMLNAME = "CT_DurationList");

Property resultStatuss As list Of web.DHCENS.STBLL.DICT.MODEL.CTResultStatus(XMLNAME = "CT_ResultStatusList");

Property specimens As list Of web.DHCENS.STBLL.DICT.MODEL.CTSpecimen(XMLNAME = "CT_SpecimenList");

Property houDocTypes As list Of web.DHCENS.STBLL.DICT.MODEL.CTHouDocType(XMLNAME = "CT_HouDocTypeList");

Property deptCareProvs As list Of web.DHCENS.STBLL.DICT.MODEL.CTDeptCareProv(XMLNAME = "CT_DeptCareProvList");

Property operations As list Of web.DHCENS.STBLL.DICT.MODEL.CTOperation(XMLNAME = "CT_OperationList");

Property tarCates As list Of web.DHCENS.STBLL.DICT.MODEL.CTTarCate(XMLNAME = "CT_ChargeCategoryList");

Property tarSubCates As list Of web.DHCENS.STBLL.DICT.MODEL.CTTarSubCate(XMLNAME = "CT_ChargeChildCategoryList");

Property tarItems As list Of web.DHCENS.STBLL.DICT.MODEL.CTTarItem(XMLNAME = "CT_ChargeItemList");

Property patPositions As list Of web.DHCENS.STBLL.DICT.MODEL.CTPatPosition(XMLNAME = "CT_PatientPositionList");

Property pharmacyWindows As list Of web.DHCENS.STBLL.DICT.MODEL.CTPharmacyWindow(XMLNAME = "CT_PharmacyWindowList");

Property medicineMaterials As list Of web.DHCENS.STBLL.DICT.MODEL.CTMedicineMaterial(XMLNAME = "CT_MedicineMaterialList");

Property bodyAreas As list Of web.DHCENS.STBLL.DICT.MODEL.CTBodyArea(XMLNAME = "CT_BodyAreaList");

Property pharmaCategorys As list Of web.DHCENS.STBLL.DICT.MODEL.CTPharmacologyCategory(XMLNAME = "CT_PharmacologyCategoryList");

Property childPharmaCategorys As list Of web.DHCENS.STBLL.DICT.MODEL.CTPharmacologyChildCategory(XMLNAME = "CT_PharmacologyChildCategoryList");

Property smallPharmaCategorys As list Of web.DHCENS.STBLL.DICT.MODEL.CTPharmacologySmallCategory(XMLNAME = "CT_PharmacologySmallCategoryList");

Property specs As list Of web.DHCENS.STBLL.DICT.MODEL.CTSpec(XMLNAME = "CT_SpecList");

Property RegisterCareProvImages As list Of web.DHCENS.STBLL.DICT.MODEL.CTRegisterCareProvImage(XMLNAME = "RegisterCareProvImageRt", XMLPROJECTION = "ELEMENT");

Property sexs As list Of web.DHCENS.STBLL.DICT.MODEL.CTSex(XMLNAME = "CT_SexList");

Property occs As list Of web.DHCENS.STBLL.DICT.MODEL.CTOccupation(XMLNAME = "CT_OccupationList");

Property maritals As list Of web.DHCENS.STBLL.DICT.MODEL.CTMarital(XMLNAME = "CT_MaritalList");

Property countrys As list Of web.DHCENS.STBLL.DICT.MODEL.CTCountry(XMLNAME = "CT_CountryList");

Property nations As list Of web.DHCENS.STBLL.DICT.MODEL.CTNation(XMLNAME = "CT_NationList");

Property provinces As list Of web.DHCENS.STBLL.DICT.MODEL.CTProvince(XMLNAME = "CT_ProvinceList");

Property citys As list Of web.DHCENS.STBLL.DICT.MODEL.CTCity(XMLNAME = "CT_CityList");

Property countys As list Of web.DHCENS.STBLL.DICT.MODEL.CTCounty(XMLNAME = "CT_CountyList");

Property dischCondits As list Of web.DHCENS.STBLL.DICT.MODEL.CTDischCondit(XMLNAME = "CT_DischConditList");

Property identifierTypes As list Of web.DHCENS.STBLL.DICT.MODEL.CTIdentifierType(XMLNAME = "CT_IdentifierTypeList");

Property relations As list Of web.DHCENS.STBLL.DICT.MODEL.CTRelation(XMLNAME = "CT_RelationList");

Property allergyCategorys As list Of web.DHCENS.STBLL.DICT.MODEL.CTAllergyCategory(XMLNAME = "CT_AllergyCategoryList");

}
