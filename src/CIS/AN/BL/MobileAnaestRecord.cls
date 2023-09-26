Class CIS.AN.BL.MobileAnaestRecord Extends %RegisteredObject
{

/// Creator：      	YGB
/// CreatDate：    	2021-11-08
/// Description： 	查询麻醉记录参数
/// Table：        	CIS_AN.ParaItem
/// Input:			sheetId
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.MobileAnaestRecord","FindParaItems","807")
Query FindParaItems(sheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT a.RowId As RowId,
	   a.RecordSheet As RecordSheet,
	   a.Code As Code,
	   a.Description As Description,
	   a.CategoryItem As CategoryItem,
	   a.CategoryItem->DataItem As DataItem,
	   a.CategoryItem->DataItem->ItemCategory As ItemCategory,
	   a.DataCategory As DataCategory,
	   a.DataCategory->Code As DataCategoryCode,
	   a.DataCategory->MainCategory As MainDataCategory,
	   a.DataCategory->MainCategory->Code As MainDataCategoryCode,
	   a.Seq As Seq,
	   a.UserDefinedItem As UserDefinedItem,
	   b.Unit As Unit,
	   b.Unit -> Description As UnitDesc,
	   b.DoseUnitVisible As DoseUnitVisible,
	   b.SpeedUnitVisible As SpeedUnitVisible,
	   b.ConcentrationVisible As ConcentrationVisible,
	   b.BloodType As BloodType,
	   b.SuspendCollect As SuspendCollect,
	   b.AutoGenerate As AutoGenerate,
	   b.DefaultValue As DefaultValue,
	   CIS_AN_COM.String_PatchFloat(b.Concentration) As Concentration,
	   b.ConcentrationUnit As ConcentrationUnit,
	   b.ConcentrationUnit->Description As ConcentrationUnitDesc,
	   b.Continuous As Continuous,
	   b.Note As Note,
	   b.Duration As Duration,
	   b.Instruction As Instruction,
	   b.Instruction->Description As InstructionDesc,
	   b.InstructionVisible As InstructionVisible
	   from CIS_AN.ParaItem As a 
	   left join CIS_AN.ParaItemAttr As b 
	   on b.ParaItem = a.RowId 
	   where RecordSheet=:sheetId
	   order by Seq
}

/// Creator：      	YGB
/// CreatDate：    	2021-11-8
/// Description： 	查询麻醉记录药品数据
/// Table：        	CIS_AN.DrugData 
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.MobileAnaestRecord","FindDrugDatas","1","N")
Query FindDrugDatas(sheetId As %String, editflag As %String = "D", categoryCode As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	   AnaData->ParaItem As ParaItemId,
	   CIS_AN_COM.String_PatchFloat(DoseQty) As DoseQty,
	   CIS_AN_COM.String_PatchFloat(Speed) As Speed,
	   CIS_AN_COM.String_PatchFloat(Concentration) As Concentration,
	   DoseUnit->Description As DoseUnitDesc,
	   SpeedUnit->Description As SpeedUnitDesc,
	   ConcentrationUnit->Description As ConcentrationUnitDesc,
	   CIS_AN_COM.String_GetDescByID("CT.AN.Instruction","Description",Instruction) As InstructionDesc,
	   CIS_AN_COM.String_GetDescByID("User.ARCItmMast","ARCIMDesc",ArcimID) As ArcimDesc,
	   CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",RecvLoc) As RecvLocDesc,
	   AnaData->ParaItem->CategoryItem->DataCategory->Code As CategoryCode,
	   AnaData->ParaItem->DataCategory->Code As MainCategoryCode,
	   AnaData->ParaItem->DataCategory-> MainCategory->Code As MainDataCategoryCode,
	   AnaData->Continuous As Continuous,
	   %ODBCOUT(AnaData->StartDate)_' '_%ODBCOUT(AnaData->StartTime) As StartDT,
	   %ODBCOUT(AnaData->EndDate)_' '_%ODBCOUT(AnaData->EndTime) As EndDT,
	   ChargeDetail->ChargeRecord As ChargeRecord
	   from CIS_AN.DrugData 
       where AnaData->ParaItem->RecordSheet=:sheetId
       and (AnaData->EditFlag=:editflag or :editflag is null)
       and (:categoryCode is null or AnaData->ParaItem->CategoryItem->DataCategory->Code=:categoryCode or AnaData->ParaItem->DataCategory->Code=:categoryCode)
}

/// Creator：      	YGB
/// CreatDate：    	2021-11-9
/// Description： 	查询麻醉记录数据
/// Table：        	DHCAN.RecordData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// w ##class(%ResultSet).RunQuery("CIS.AN.BL.MobileAnaestRecord","FindAnaDatas","4907","N","V")
Query FindAnaDatas(sheetId As %String, editFlag As %String = "D", itemCategory As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   ParaItem,
	   %ODBCOUT(StartDate) As StartDate,
	   %ODBCOUT(StartTime) As StartTime,
	   %ODBCOUT(EndDate) As EndDate,
	   %ODBCOUT(EndTime) As EndTime,
	   DataValue,
	   EditFlag,
	   FromData,
	   Continuous,
	   CreateUserID,
	   %ODBCOUT(CreateDate)_' '_%ODBCOUT(CreateTime) As CreateDT,
	   %ODBCOUT(StartDate)_' '_%ODBCOUT(StartTime) As StartDT,
	   %ODBCOUT(EndDate)_' '_%ODBCOUT(EndTime) As EndDT,
	   ParaItem->CategoryItem As CategoryItem,
	   DataItem As DataItem,
	   DataItem->Code As DataItemCode,
	   DataItem->Description As DataItemDesc,
	   DataItem->ItemCategory As ItemCategory,
	   UserDefinedItem,
	   UserDefinedItem->Description As UserDefinedItemDesc,
	   ParaItem->DataCategory As DataCategory,
	   ParaItem->Description As ParaItemDesc,
	   Source,
	   CIS_AN_BL.AnaestRecord_CalcSumQty(RowId) As SumQty,
	   CIS_AN_BL.AnaestRecord_GetSumUom(RowId) As SumUom,
	   CIS_AN_BL.AnaestRecord_AbnormalVitalSign(RowId) As AbnormalVitalSign,
	   SignDoctor,
	   SignNurse,
	   CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',SignDoctor,'Y') As SignDoctorDesc,
	   CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',SignNurse,'Y') As SignNurseDesc
	   from CIS_AN.AnaData 
       where ParaItem->RecordSheet=:sheetId
       and (EditFlag=:editFlag or :editFlag is null)
       and (DataItem->ItemCategory=:itemCategory or :itemCategory is null)
       and CIS_AN_BL.AnaestRecord_VitalSignVisible(ParaItem->RecordSheet->OperSchedule,ParaItem->RecordSheet,StartDate,StartTime,DataItem->Code)='Y'
       order by StartDate,StartTime
}

/// Creator：        YGB
/// CreatDate：      2021-11-12
/// Description：    查询数据项的药品信息
/// Table：          CT_AN.DrugItem
/// Input:          dataItemID:数据项ID
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.MobileAnaestRecord","FindDrugItem","丙泊")
Query FindDrugItem(descFilter As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
       DoseUnit -> Description As DoseUnitDesc,
       DataItem->Description AS Description,
       ConcentrationUnit -> Description As ConcentrationUnitDesc,
       CIS_AN_COM.String_GetDescByID("User.ARCItmMast","ARCIMDesc",ArcimID) As ArcimDesc,
       CIS_AN_COM.String_GetDescByID("User.ARCItmMast","ARCIMPHCDFDR",ArcimID) As DrgFormID,
       Instruction->Description As InstructionDesc,
       CIS_AN_COM.String_PatchFloat(DoseQty) As DoseQty
       from CT_AN.DrugItem where (DataItem->Description[:descFilter) or (:descFilter is null)
}

/// Creator：        YGB
/// CreatDate：      2021-11-12
/// Description：    查询数据项分类关联的数据项
/// Table：          DHCAN.DataCategoryItem
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.MobileAnaestRecord","FindDrugCategoryItem","","")
Query FindDrugCategoryItem(filterDesc As %String, filterMainCategory As %String, hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT	b.*, 
	   a.DataCategory->MainCategory As MainCategory,
	   a.DataCategory->MainCategory->Code As MainCategoryCode,
       a.DataCategory As DataCategory,
       a.DataCategory->Code As CategoryCode,
       a.DataCategory->Description As CategoryDesc,
       a.DataItem As DataItem,
       a.DataItem->Code As ItemCode,
       a.DataItem->Description As ItemDesc,
       a.DataItem->DataType As DataType,
       a.DataItem->Alias As Alias,
       %EXTERNAL(a.DataItem->DataType) As DataTypeDesc,
       a.DataItem->Options As Options,
       a.DataItem->ItemCategory As ItemCategory,
       %EXTERNAL(a.DataItem->ItemCategory) As ItemCategoryDesc,
       a.DataItem->ChannelNo As ChannelNo,
       a.SeqNo As SeqNo
       from CT_AN.DataCateItem a,
       CT_AN.DrugItem b 
       where ((a.DataItem->Description [ :filterDesc) or (a.DataItem->Alias [ upper(:filterDesc))or (:filterDesc is null))
       and a.DataItem=b.DataItem
       and ((a.DataCategory->MainCategory->Code=:filterMainCategory) or (:filterMainCategory is null))
       and ((:hospId is null) or (a.DataAttribution is null) or (a.DataAttribution->HospitalID=:hospId))
       order by ItemCategoryDesc,CategoryDesc,SeqNo
}

/// Creator：        YGB
/// CreatDate：      2021-11-12
/// Description：    查询数据项分类关联的数据项
/// Table：          DHCAN.DataCategoryItem
/// Input:          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.MobileAnaestRecord","FindCategoryItem","","OutVolume")
Query FindCategoryItem(filterDesc As %String, filterMainCategory As %String, hospId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT 
	   RowId,
	   DataCategory->MainCategory As MainCategory,
	   DataCategory->MainCategory->Code As MainCategoryCode,
       DataCategory As DataCategory,
       DataCategory->Code As CategoryCode,
       DataCategory->Description As CategoryDesc,
       DataItem As DataItem,
       DataItem->Code As ItemCode,
       DataItem->Description As ItemDesc,
       DataItem->Code As Code,
       DataItem->Description As Description,
       DataItem->DataType As DataType,
       DataItem->Alias As Alias,
       %EXTERNAL(DataItem->DataType) As DataTypeDesc,
       DataItem->Options As Options,
       DataItem->ItemCategory As ItemCategory,
       %EXTERNAL(DataItem->ItemCategory) As ItemCategoryDesc,
       DataItem->ChannelNo As ChannelNo,
       SeqNo As SeqNo
       from CT_AN.DataCateItem
       where ((DataItem->Description [ :filterDesc) or (DataItem->Alias [ upper(:filterDesc))or (:filterDesc is null))
       and ((DataCategory->MainCategory->Code=:filterMainCategory) or (:filterMainCategory is null))
       and ((:hospId is null) or (DataAttribution is null) or (DataAttribution->HospitalID=:hospId))
       order by ItemCategoryDesc,CategoryDesc,SeqNo
}

/// Creator：      	YGB
/// CreatDate：    	2021-11-22
/// Description： 	查询麻醉记录事件明细数据
/// Table：        	CIS_AN.EventData
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.MobileAnaestRecord","FindEventDatas","1","N")
Query FindEventDatas(sheetId As %String, editFlag As %String = "D") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT *,
	   EventDetailItem->Description As Description,
	   EventDetailItem->Unit As Unit,
	   ChargeDetail->ChargeRecord As ChargeRecord
	   from CIS_AN.EventData 
       where AnaData->ParaItem->RecordSheet=:sheetId
       and (AnaData->EditFlag=:editflag or :editflag is null)
}

}
