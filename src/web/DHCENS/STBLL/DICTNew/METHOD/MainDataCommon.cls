Class web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon Extends %RegisteredObject
{

ClassMethod MainDataManager(TableName As %String, InputContent As %String) As %GlobalCharacterStream
{
	set $zt="MsgErr"
	set request=##class(web.DHCENS.STBLL.DICTNew.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.DICTNew.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="SYS0002"
	set request.header=header
	
	set body=##class(web.DHCENS.STBLL.DICTNew.MODEL.Body).%New()
	set MainDataApply=##class(web.DHCENS.STBLL.DICTNew.MODEL.SSMDAApply).%New()
	set MainDataApply.SSMDATableCode=TableName
	set MainDataApply.SSMDAContent=InputContent
	set MainDataApply.SSMDASourceSys="HIS"
	set MainDataApply.SSMDAUserCode="demo"
	set MainDataApply.SSMDAUserName=""
	set MainDataApply.SSMDADate=$zd(+$h,3)
	set MainDataApply.SSMDATime=$zt($p($h,",",2))
	set MainDataApply.SSMDARemarks=""
	d body.SSMainDataApply.Insert(MainDataApply)
	set request.body=body
	d request.XMLExportToStream(.stream)
	quit stream
MsgErr
	set ReturnStream =##class(%GlobalCharacterStream).%New()
	d ReturnStream.Write("-1"_$ze)
	quit ReturnStream
}

ClassMethod JsonToBase64(InputContent As %GlobalCharacterStream) As %String
{
	set len=InputContent.Size
	set JsonString=InputContent.Read(len,.st)
	set JsonString="["_$p($p(JsonString,":[",2),"]}",1)_"]"
	set JsonString=$zcvt(JsonString,"O","UTF8")
	set JsonString=$System.Encryption.Base64Encode(JsonString)
	quit JsonString
}

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).ImportDIcInfo()
ClassMethod ImportDIcInfo() As %String
{
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTHospital).CTHospital("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAllergyCategory).CTAllergyCategory("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBedType).CTBedType("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBodyArea).CTBodyArea("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCategory).CTCategory("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTChildCategory).CTChildCategory("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTProvince).CTProvince("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCity).CTCity("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCountry).CTCountry("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCounty).CTCounty("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTWard).CTWard("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDept).CTDept("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnoseType).CTDiagnoseType("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnose).CTDiagnose("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDischCondit).CTDischCondit("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDoseForms).CTDoseForms("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDoseUnit).CTDoseUnit("")
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDuration).CTDuration("")	
	;d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTFreq).CTFreq("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTIdentifierType).CTIdentifierType("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTInstr).CTInstr("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMarital).CTMarital("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTNation).CTNation("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOccupation).CTOccupation("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrderStatus).CTOrderStatus("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPriority).CTPriority("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRelation).CTRelation("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTResultStatus).CTResultStatus("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRoom).CTCTRoom("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBed).CTBed("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSex).CTSex("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSpecimen).CTSpecimen("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProv).CTCareProv("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTARCItmMast).CTARCItmMast("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSpec).CTSpec("")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTEncounterStatus).CTEncounterStatus("00001")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTEncounterType).CTEncounterType("00001")
	d ##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAddressType).CTAddressType("00001")

 	quit "0"
}

/// Description:根据表名返回MDM待处理结构数据
/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).GetMainDataManager("CT_OperationRoom","W3siQ1RPUl9Db2RlIjoiMTEiLCJDVE9SX0NvZGVzeXN0ZW1Db2RlIjoiQ1RfT3BlcmF0aW9uUm9vbSIsIkNUT1JfRGVzYyI6IuaBouWkjeWupDAxIiwiQ1RPUl9SZW1hcmtzIjoi5pegIiwiQ1RPUl9VcGRhdGVVc2VyQ29kZSI6IuaXoCIsIkNUT1JfVXBkYXRlRGF0ZSI6IjIwMTgtMTEtMDIiLCJDVE9SX1VwZGF0ZVRpbWUiOiIxMTo0MDozMCIsIkNUT1JfQ3JlYXREYXRlIjoiIiwiQ1RPUl9DcmVhdFRpbWUiOiIiLCJCdXNpbmVzc0ZpZWxkQ29kZSI6IjAwMDAxIiwiQ1RPUl9PcmlnaW5hbENvZGUiOiIiLCJDVE9SX09yaWdpbmFsRGVzYyI6IiIsIkNUT1JfU3RhcnREYXRlIjoiIiwiQ1RPUl9FbmREYXRlIjoiIiwiQ1RPUl9Ib3NDb2RlIjoiREhTWkhZWVpZIiwiVXBkYXRlRGF0ZSI6IiIsIlVwZGF0ZVRpbWUiOiIiLCJDVE9SX1N0YXR1cyI6IjEifV0=").Read()
ClassMethod GetMainDataManager(TableName As %String, InputContent As %String) As %GlobalCharacterStream
{
	set $zt="MsgErr"
	set request=##class(web.DHCENS.STBLL.DICTNew.MODEL.Request).%New()
	set header=##class(web.DHCENS.STBLL.DICTNew.MODEL.Header).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set request.header=header
	
	set body=##class(web.DHCENS.STBLL.DICTNew.MODEL.Body).%New()
	set MainDataApply=##class(web.DHCENS.STBLL.DICTNew.MODEL.SSMDAApply).%New()
	set MainDataApply.SSMDATableCode=TableName
	set MainDataApply.SSMDAContent=InputContent
	set MainDataApply.SSMDASourceSys="HIS"
	set MainDataApply.SSMDAUserCode="demo"
	set MainDataApply.SSMDAUserName=""
	set MainDataApply.SSMDADate=$zd(+$h,3)
	set MainDataApply.SSMDATime=$zt($p($h,",",2))
	set MainDataApply.SSMDARemarks=""
	d body.SSMainDataApply.Insert(MainDataApply)
	set request.body=body
	set ReturnStream =##class(%GlobalCharacterStream).%New()
	d request.XMLExportToStream(.ReturnStream)
	q ReturnStream
MsgErr
	set ReturnStream =##class(%GlobalCharacterStream).%New()
	d ReturnStream.Write("-1"_$ze)
	quit ReturnStream
}

ClassMethod ParseResponse(TableName As %String, Input As %GlobalCharacterStream) As %String
{
	set $Ztrap="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(Input,.tDocument)
	set resultContent="",ResultCode=""
	if $$$ISERR(tSC) {
		Quit "-1^"_tSC
	}else
	{				
		set tSC=tDocument.EvaluateExpression("/Response/Body/ResultContent","text()",.tRes)		
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set resultContent=$tr(fieldValue,$c(0),"")
			}
		set tSC=tDocument.EvaluateExpression("/Response/Body/ResultCode","text()",.tRes)		
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set ResultCode=$tr(fieldValue,$c(0),"")
			}
		if ResultCode'=0{
			set ^TMPDHCENSDIC(TableName,$h)=resultContent
			}
	}
	Quit ""
Exception
	Quit $ze
}

/// Creator: ZhangXinying
/// Description：通过字典表名、rowid获取字典信息
/// Table：
/// Input： 
/// Return：
/// Others：w ##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).GetMainDictInfo("2,CT_Hospital").Read()
ClassMethod GetMainDictInfo(InputStream As %Stream.GlobalCharacter) As %Stream.GlobalCharacter
{
	s $zt="Err"
	d InputStream.Rewind()
	s Input=InputStream.Read()
	s Rowid=$p(Input,",",1)
	s TableName=$p(Input,",",2)
	s MainDictStream =##class(%Stream.GlobalCharacter).%New()
	if TableName="CT_Loc"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDept).GetCTDept(Rowid)
	}
	elseif TableName="CT_Hospital"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTHospital).GetCTHospital(Rowid)
	}
	elseif TableName="PAC_Bed"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBed).GetCTBed(Rowid)
	}
	elseif TableName="ARC_ItmMast"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTARCItmMast).GetCTARCItmMast(Rowid)
	}
	elseif TableName="DHC_TarItem"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTTarItem).GetCTTarItem(Rowid)
	}
	/*
	elseif TableName="CT_MEDGroup" ///
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMEDGroup).GetCTMEDGroup(Rowid)
	}
	elseif TableName="CT_SubMajor"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSubMajor).GetCTSubMajor(Rowid)
	}
	*/
	elseif TableName="OEC_OrderCategory"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCategory).GetCTCategory(Rowid)
	}
	elseif TableName="ARC_ItemCat"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTChildCategory).GetCTChildCategory(Rowid)
	}
	elseif TableName="ARC_BillGrp"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBillCat).GetCTBillCat(Rowid)
	}
	elseif TableName="ARC_BillSub"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBillChildCat).GetCTBillChildCat(Rowid)
	}
	
	elseif TableName="DHC_TarEC"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTEMChargeCategory).GetCTEMChargeCategory(Rowid)
	}
	
	elseif TableName="DHC_TarEMCCate"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTEMChargeChildCategory).GetCTEMChargeChildCategory(Rowid)
	}
	
	elseif TableName="DHC_TarCate"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTChargeCategory).GetCTChargeCategory(Rowid)
	}
	elseif TableName="DHC_TarSubCate"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTChargeChildCategory).GetCTChargeChildCategory(Rowid)
	}
	elseif TableName="DHC_TarAC"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTACChargeCategory).GetCTACChargeCategory(Rowid)
	}
	elseif TableName="DHC_TarAcctCate"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTACChargeChildCategory).GetCTACChargeChildCategory(Rowid)
	}
	elseif TableName="DHC_TarIC"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTIPChargeCategory).GetCTIPChargeCategory(Rowid)
	}
	elseif TableName="DHC_TarInpatCate"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTIPChargeChildCategory).GetCTIPChargeChildCategory(Rowid)
	}
	elseif TableName="DHC_TarOC"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOPChargeCategory).GetCTOPChargeCategory(Rowid)
	}
	elseif TableName="DHC_TarOutpatCate"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOPChargeChildCategory).GetCTOPChargeChildCategory(Rowid)
	}
	elseif TableName="DHC_TarMC"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeCategory).GetCTMRChargeCategory(Rowid)
	}
	elseif TableName="DHC_TarMRCate"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeChildCategory).GetCTMRChargeChildCategory(Rowid)
	}
	/*
	elseif TableName="CT_MRChargeCategoryNew"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeCategoryNew).GetCTMRChargeCategoryNew(Rowid)
	}
	elseif TableName="CT_MRChargeChildCategoryNew"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeChildCategoryNew).GetCTMRChargeChildCategoryNew(Rowid)
	}
	*/
	elseif TableName="CT_Title"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTTitleOfTech).GetCTTitleOfTech(Rowid)
	}
	elseif TableName="CT_SocialStatus"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPatientPosition).GetCTPatientPosition(Rowid)
	}
	elseif TableName="CT_Occupation"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOccupation).GetCTOccupation(Rowid)
	}
	elseif TableName="CT_Relation"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRelation).GetCTRelation(Rowid)
	}
	elseif TableName="CT_Marital"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMarital).GetCTMarital(Rowid)
	}
	elseif TableName="CT_Sex"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSex).GetCTSex(Rowid)
	}
	elseif TableName="CT_Country"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCountry).GetCTCountry(Rowid)
	}
	elseif TableName="CT_Nation"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTNation).GetCTNation(Rowid)
	}
	elseif TableName="CT_Province"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTProvince).GetCTProvince(Rowid)
	}
	elseif TableName="CT_City"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCity).GetCTCity(Rowid)
	}
	elseif TableName="CT_County"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCounty).GetCTCounty(Rowid)
	}
	elseif TableName="PHC_Freq"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTFreq).GetCTFreq(Rowid)
	}
	elseif TableName="PHC_Instruc"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTInstr).GetCTInstr(Rowid)
	}
	elseif TableName="PHC_Duration"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDuration).GetCTDuration(Rowid)
	}
	elseif TableName="CT_Religion"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTReligion).GetCTReligion(Rowid)
	}
	elseif TableName="PAC_AdmReason"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCostCategory).GetCTCostCategory(Rowid)
	}
	elseif TableName="RBC_DepartmentGroup"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptDepartmentGroup).GetCTDeptDepartmentGroup(Rowid)
	}
	elseif TableName="SS_User"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTHisUser).GetCTHisUser(Rowid)
	}
	elseif TableName="CT_CareProvType"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvType).GetCTCareProvType(Rowid)
	}
	elseif TableName="CT_EmpJob"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvPosition).GetCTCareProvPosition(Rowid)
	}
	elseif TableName="CT_StaffType"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStaffType).GetCTStaffType(Rowid)
	}
	elseif TableName="DHC_StkCatGroup"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStockCategoryGroup).GetCTStkCatGrp(Rowid)
	}
	elseif TableName="DHC_StkCatSubGroup"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStockCategorySubGroup).GetCTStkCatSubGrp(Rowid)
	}
	elseif TableName="CT_UOM"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHUnit).GetCTPHUnit(Rowid)
	}
	elseif TableName="CT_ConFac"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTConFac).GetCTConFac(Rowid)
	}
	elseif TableName="PHC_Cat"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPharmacologyCategory).GetCTPharmacologyCategory(Rowid)
	}
	elseif TableName="PHC_Poison"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHCPoison).GetCTPHCPoison(Rowid)
	}
	elseif TableName="CT_Zip"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPostCode).GetCTPostCode(Rowid)
	}
	elseif TableName="PHC_Generic"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHCGeneric).GetCTPHCGeneric(Rowid)
	}
	elseif TableName="PH_Manufacturer"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHManufacturer).GetCTPHManufacturer(Rowid)
	}
	elseif TableName="APC_Vendor"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSCVendor).GetCTAPCVendor(Rowid)
	}
	elseif TableName="DHC_STOrigin"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSCOrigin).GetCTSCOrigin(Rowid)
	}
	elseif TableName="DHC_Carrier"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSCCarrier).GetCTSCCarrier(Rowid)
	}
	elseif TableName="MRC_ICDDx"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnose).GetCTDiagnose(Rowid)
	}
	elseif TableName="ORC_Operation"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperation).GetCTOperation(Rowid)
	}
	elseif TableName="PHC_DrgMast"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHDrgMaterialItm).GetCTPHDrgMaterialItm(Rowid)
	}
	elseif TableName="INC_Item"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHDrgMaterialStock).GetCTPHDrgMaterialStock(Rowid)
	}
	elseif TableName="PAC_Ward"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTWard).GetCTWard(Rowid)
	}
	elseif TableName="PAC_BedType"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBedType).GetCTBedType(Rowid)
	}
	elseif TableName="DHC_CardTypeDef"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCardType).GetCTCardType(Rowid)
	}
	elseif TableName="PAC_Room"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRoom).GetCTRoom(Rowid)
	}
	elseif TableName="ORC_OperationRoom"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationRoom).GetCTOperationRoom(Rowid)
	}
	elseif TableName="MRC_AllType"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAllergyCategory).GetCTAllergyCategory(Rowid)
	}
	elseif TableName="PAC_AllergySeverity"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAllergySeverity).GetCTAllergySeverity(Rowid)
	}
	elseif TableName="ORC_ASA_ClassPhActiv"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAnaesthesiaLevel).GetCTAnaesthesiaLevel(Rowid)
	}
	elseif TableName="ORC_AnaestMethod"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAnaesthesiaMethod).GetCTAnaesthesiaMethod(Rowid)
	}
	elseif TableName="ORC_AnaestMethod"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAnaesthesiaType).GetCTAnaesthesiaType(Rowid)
	}
	elseif TableName="DHCAppPart"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBodyArea).GetCTBodyArea(Rowid)
	}
	elseif TableName="DHC_TarItemPrice"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTChargeItemPrice).GetCTChargeItemPrice(Rowid)
	}
	elseif TableName="ORC_BladeType"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCutType).GetCTCutType(Rowid)
	}
	elseif TableName="DHCStkDrugGroup"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDHCStkDrugGroup).GetCTDHCStkDrugGroup(Rowid)
	}
	elseif TableName="MRC_DiagnosType"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnoseType).GetCTDiagnoseType(Rowid)
	}
	elseif TableName="PAC_DischCondit"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDischCondit).GetCTDischCondit(Rowid)
	}
	elseif TableName="PHC_Form"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDoseForms).GetCTDoseForms(Rowid)
	}
	elseif TableName="PAC_CardType"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTIdentifierType).GetCTIdentifierType(Rowid)
	}
	elseif TableName="MRC_ObservationItem"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTObservationItem).GetCTObservationItem(Rowid)
	}
	elseif TableName="ORC_OperationCategory"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationLevel).GetCTOperationLevel(Rowid)
	}
	elseif TableName="OEC_BodySite"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationPart).GetCTOperationPart(Rowid)
	}
	elseif TableName="ORC_OperPosition"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationPosition).GetCTOperationPosition(Rowid)
	}
	elseif TableName="DHC_ANC_OperRoom"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationRoom).GetCTOperationRoom(Rowid)
	}
	
	elseif TableName="ORC_Anaest_Complications"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTORCAnaestComplications).GetCTORCAnaestComplications(Rowid)
	}
	elseif TableName="OEC_OrderStatus"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrderStatus).GetCTOrderStatus(Rowid)
	}
	elseif TableName="OEC_AdminStatusChReason"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrdStatusChReason).GetCTOrdStatusChReason(Rowid)
	}
	elseif TableName="OEC_OrderAdminStatus"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrderAdminStatus).GetCTOrderAdminStatus(Rowid)
	}
	elseif TableName="DHC_PE_StationOrder"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPEItem).GetCTPEItem(Rowid)
	}
	elseif TableName="DHC_PE_OrderDetail"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPEItemDetail).GetCTPEItemDetail(Rowid)
	}
	elseif TableName="RBC_AppointMethod"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRBCAppointMethod).GetCTRBCAppointMethod(Rowid)
	}
	elseif TableName="RBC_SessionType"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRBCSessionType).GetCTRBCSessionType(Rowid)
	}
	elseif TableName="OEC_ResultStatus"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTResultStatus).GetCTResultStatus(Rowid)
	}
	elseif TableName="CT_Spec"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSpec).GetCTSpec(Rowid)
	}
	elseif TableName="CT_Specimen"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSpecimen).GetCTSpecimen(Rowid)
	}
	elseif TableName="CT_Priority"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPriority).GetCTPriority(Rowid)
	}
	elseif TableName="ORC_BladeType"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCutType).GetCTCutType(Rowid)
	}
	elseif TableName="OEC_Order_AdminStatus"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrderAdminStatus).GetCTOrderAdminStatus(Rowid)
	}
	elseif TableName="OEC_AdminStatusChReason"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrdStatusChReason).GetCTOrdStatusChReason(Rowid)
	}
	elseif TableName="CT_CareProv"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProv).GetCTCareProv(Rowid)
	}
	if TableName="SS_Group"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSecurityGroup).GetCTSecurityGroup(Rowid)
	}
	if TableName="SS_UserOtherLogonLoc"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTUserOtherLogonDept).GetCTUserOtherLogonDept(Rowid)
	}
	if TableName="PHC_Poison"
	{
		s MainDictStream=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHCPoison).GetCTPHCPoison(Rowid)
	}
	q MainDictStream
Err
	set ReturnStream =##class(%Stream.GlobalCharacter).%New()
	do ReturnStream.Write("-1"_$ze)
	quit ReturnStream
}

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).Test()
ClassMethod Test() As %String
{
	s id=""  f  s id=$o(^Config.ENS.EnsInterfaceMethodI(id)) q:id=""  d
	.s item=id
	.s asc=$a(item)
	.if asc<32 d
	..w !,item
	.s id1="" f  s id1=$o(^Config.ENS.EnsInterfaceMethodI(id,id1)) q:id1=""  d
	..s item1=id1
	..s asc1=$a(item1)
	..if asc1<32 d
	...w !,item1
	..s id2="" f  s id2=$o(^Config.ENS.EnsInterfaceMethodI(id,id1,id2)) q:id2=""  d
	...s item2=id2
	...s asc2=$a(item2)
	...w !,item2_"^"_asc2
	...if asc2<32 d
	....w !,item2
	q "0"
}

/// w ##class(web.DHCENS.STBLL.DICTNew.METHOD.MainDataCommon).BatchSync()
ClassMethod BatchSync()
{
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBed).SendCTBed("")                                                        
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTARCItmMast).SendCTARCItmMast("")                                          
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCategory).SendCTCategory("")                                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTChildCategory).SendCTChildCategory("")                                    
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBillCat).SendCTBillCat("")                                                
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBillChildCat).SendCTBillChildCat("")                                      
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTEMChargeCategory).SendCTEMChargeCategory("")                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTEMChargeChildCategory).SendCTEMChargeChildCategory("")                    
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTChargeCategory).SendCTChargeCategory("")                                  
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTChargeChildCategory).SendCTChargeChildCategory("")                       
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTACChargeCategory).SendCTACChargeCategory("")                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTACChargeChildCategory).SendCTACChargeChildCategory("")                    
	
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTIPChargeCategory).SendCTIPChargeCategory("")                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTIPChargeChildCategory).SendCTIPChargeChildCategory("")                    
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOPChargeCategory).SendCTOPChargeCategory("")                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOPChargeChildCategory).SendCTOPChargeChildCategory("")                    
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeCategory).SendCTMRChargeCategory("")                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTMRChargeChildCategory).SendCTMRChargeChildCategory("")                    
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPatientPosition).SendCTPatientPosition("")                                
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTFreq).SendCTFreq("")                                                      
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTInstr).SendCTInstr("")                                                    
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDuration).SendCTDuration("")                                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDoseForms).SendCTDoseForms("")                                            
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDeptDepartmentGroup).SendCTDeptDepartmentGroup("")                        
	//set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProv).SendCTCareProv("")                                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCareProvType).SendCTCareProvType("")                                      
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStockCategoryGroup).SendCTStkCatGrp("")                                   
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTStockCategorySubGroup).SendCTStkCatSubGrp("")                             
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHUnit).SendCTPHUnit("")                                                  
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTConFac).SendCTConFac("")                                                  
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPharmacologyCategory).SendCTPharmacologyCategory("")                      
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPharmacologyChildCategory).SendCTPharmacologyChildCategory("") 
	
	           
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHCPoison).SendCTPHCPoison("")                                            
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHCGeneric).SendCTPHCGeneric("")                                          
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHManufacturer).SendCTSCManufacturer("")                                  
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSCVendor).SendCTSCVendor("")                                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTSCCarrier).SendCTSCCarrier("")                                            
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTBedType).SendCTBedType("")                                                
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCardType).SendCTCardType("")                                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRoomType).SendCTRoomType("")                                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAnaesthesiaMethod).SendCTAnaesthesiaMethod("")                            
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTObservationItem).SendCTObservationItem("")                                
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationLevel).SendCTOperationLevel("")                                  
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationPart).SendCTOperationPart("")                                    
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOperationPosition).SendCTOperationPosition("")                            
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAnaesthesiaLevel).SendCTAnaesthesiaLevel("")                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCutType).SendCTCutType("")                                                
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDischCondit).SendCTDischCondit("")                                        
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDiagnoseType).SendCTDiagnoseType("")                                      
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrderStatus).SendCTOrderStatus("")                                        
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPriority).SendCTPriority("")                                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrderAdminStatus).SendCTOrderAdminStatus("")                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTOrdStatusChReason).SendCTOrdStatusChReason("")                            
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRBCAppointMethod).SendCTRBCAppointMethod("")                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRegistrationCat).SendCTRegistrationCat("")                                
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHDrgMaterialItm).SendCTPHDrgMaterialItm("")                              
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPHDrgMaterialStock).SendCTPHDrgMaterialStock("")
	
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTRHBloodType).SendCTRHBloodType("")
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTDischMeans).SendCTDischMeans("")
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTCutHealGrade).SendCTCutHealGrade("")
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTPayMode).SendCTPayMode("")
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitMeans).SendCTAdmitMeans("")
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAdmitCondit).SendCTAdmitCondit("")
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTABOBloodType).SendCTABOBloodType("")
	set tsc=##class(web.DHCENS.STBLL.DICTNew.METHOD.CTAllergySource).SendCTAllergySource("")
	q "0"
}

}
