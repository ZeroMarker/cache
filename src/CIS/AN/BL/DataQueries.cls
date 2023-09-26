/// 业务数据Query
Class CIS.AN.BL.DataQueries Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-03-27
/// Description： 	查询时间轴信息
/// Table：        	DHCAN.TimeLine
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("DHCAN.DataQuery","FindTimeLines","1")
Query FindTimeLines(sheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RecordSheet,
	   %ODBCOUT(StartDate)_" "_%ODBCOUT(StartTime) As StartDT,
	   ColumnMinutes,
	   %ODBCOUT(EndDate)_" "_%ODBCOUT(EndTime) As EndDT
	   From CIS_AN.TimeLine
	   where RecordSheet=:sheetId
}

/// Creator：      	陈长青
/// CreatDate：    	2017-04-24
/// Description： 	查询手术麻醉交接班信息
/// Table：        	DHCAN.OperShift
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindOperShift","18")
Query FindOperShift(opsId As %String, deptID As %String = "", shiftType As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   OperSchedule,
	   ShiftCareProvID,
	   CIS_AN_COM.String_GetDescByID("User.CTCareProv","CTPCPDesc",ShiftCareProvID) As ShiftCareProvDesc,
	   ReliefCareProvID,
	   CIS_AN_COM.String_GetDescByID("User.CTCareProv","CTPCPDesc",ReliefCareProvID) As ReliefCareProvDesc,
	   ShiftType,
	   %EXTERNAL(ShiftType) As ShiftTypeDesc,
	   ShiftNote,
	   %ODBCOUT(ShiftDate) As ShiftDate,
	   %ODBCOUT(ShiftTime) As ShiftTime,
	   %ODBCOUT(ShiftDate)_" "_%ODBCOUT(ShiftTime) As ShiftDateTime,
	   %ODBCOUT(ShiftDate)_" "_%ODBCOUT(ShiftTime) As ShiftDT
	   from CIS_AN.OperShift 
	   where OperSchedule=:opsId
	   and ((CareProvDept=:deptID) or (:deptID is null))
	   and ((ShiftType=:shiftType) or (:shiftType is null))
}

/// Creator：      	陈长青
/// CreatDate：    	2017-2-15
/// Description： 	查询麻醉记录参数
/// Table：        	DHCAN.RecordPara
/// Input:			opsId:手术明细ID，moduleId:
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindParaItems","807")
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

/// Creator：      	陈长青
/// CreatDate：    	2018-5-17
/// Description： 	查询设备维修记录
/// Table：        	CIS_AN.EquipService
/// Input:			equipId:科室设备ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindEquipService","1")
Query FindEquipService(startDate As %String, endDate As %String, equipId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   Equip,
	   Equip->EquipDesc As EquipDesc,
	   Equip->EquipModel As EquipModel,
	   Equip->EquipModel->Description As EquipModelDesc,
	   Equip->EquipModel->Manufacturer As Manufacturer,
	   Equip->EquipModel->Manufacturer->Description As ManufacturerDesc,
	   Equip->Location As Location,
	   Equip->Location->Description As LocDesc, 
	   %ODBCOUT(ServiceDate) As ServiceDate,
	   Phenomenon,
	   CodeDesc,
	   ServiceMethod,
	   ServiceResult,
	   ServiceProv,
	   CIS_AN_COM.String_GetDescByID("User.CTCareProv","CTPCPDesc",ServiceProv) As ServiceProvDesc,
	   AppProv,
	   CIS_AN_COM.String_GetDescByID("User.CTCareProv","CTPCPDesc",AppProv) As AppProvDesc,
	   Duration,
	   %ODBCOUT(StartDate)_' '_%ODBCOUT(StartTime) As StartDT,
	   %ODBCOUT(EndDate)_' '_%ODBCOUT(EndTime) As EndDT,
	   UpdateUser,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserDesc,
	   %ODBCOUT(UpdateDate)_' '_%ODBCOUT(UpdateTime) As UpdateDT,
	   ServiceDept,
	   CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCCode",ServiceDept) As ServiceDeptDesc
 	   from CIS_AN.EquipService
 	   where (Equip=:equipId or :equipId is null)
 	   and (ServiceDate>=%ODBCIN(:startDate))
 	   and (ServiceDate<=%ODBCIN(:endDate))
}

/// Creator：      	陈长青
/// CreatDate：    	2018-05-27
/// Description： 	查询手术清点记录
/// Table：        	CIS_AN.SurInventory
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindSurInventory","4061")
Query FindSurInventory(sheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RecordSheet,
	   SurgicalMaterial,
	   SurgicalMaterial->Description As SurgicalMaterialDesc,
	   SurgicalMaterial->Unit As Unit,
	   MaterialNote,
	   CIS_AN_COM.String_AlterDesc(SurgicalMaterial->Description,MaterialNote) As MaterialNote,
	   PreopCount,
	   PreCloseCount,
	   PostCloseCount,
	   PostSewCount,
	   OperAddCount,
	   AddCountDesc,
	   PericardialCut,
	   InventoryType,
	   SterilityPack->RowId As SterilityPack
	   From CIS_AN.SurgicalInventory
	   where RecordSheet=:sheetId
	   and InventoryType<>'D'
}

/// Creator：      	陈长青
/// CreatDate：    	2018-05-27
/// Description： 	查询手术清点记录
/// Table：        	CIS_AN.SurInventory
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindSurInventory","4061")
Query FindDressingInventory(sheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RecordSheet,
	   SurgicalMaterial,
	   SurgicalMaterial->Description As SurgicalMaterialDesc,
	   MaterialNote,
	   CIS_AN_COM.String_AlterDesc(SurgicalMaterial->Description,MaterialNote) As MaterialNote,
	   PreopCount,
	   PreCloseCount,
	   PostCloseCount,
	   PostSewCount,
	   OperAddCount,
	   AddCountDesc,
	   InventoryType
	   From CIS_AN.SurgicalInventory
	   where RecordSheet=:sheetId
	   and InventoryType='D'
}

/// Creator：      	陈长青
/// CreatDate：    	2018-06-13
/// Description： 	手术通用药品数据记录
/// Table：        	CIS_AN.OperDrugData
/// Input:			sheetId:手术麻醉记录表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindOperDrugData","1")
Query FindOperDrugData(sheetId As %String, elementId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RecordSheet,
	   DrugItem,
	   DataOption,
	   DataOption->Description As OptDesc,
	   Qty,
	   Uom,
	   CIS_AN_COM.String_GetDescByID("User.CTUOM","CTUOMDesc",Uom) As UomDesc,
	   UpdateUser,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserDesc,
	   %ODBCOUT(UpdateDate)_" "_%ODBCOUT(UpdateTime) As UpdateDT
	   From CIS_AN.OperDrugData
	   where RecordSheet=:sheetId
	   and (ElementID=:elementId or :elementId is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2018-06-13
/// Description： 	查询患者皮肤情况
/// Table：        	CIS_AN.SkinCondition
/// Input:			sheetId:手术麻醉记录表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindSkinCondition","1")
Query FindSkinCondition(sheetId As %String, elementId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RecordSheet,
	   BodySite,
	   BodySite->Description As BodySiteDesc,
	   Area,
	   Period,
	   UpdateUser,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserDesc,
	   %ODBCOUT(UpdateDate)_" "_%ODBCOUT(UpdateTime) As UpdateDT
	   From CIS_AN.SkinCondition
	   where RecordSheet=:sheetId
	   and (ElementID=:elementId or :elementId is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2018-06-13
/// Description： 	查询患者皮肤情况
/// Table：        	CIS_AN.SkinCondition
/// Input:			sheetId:手术麻醉记录表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindSkinCondition","1")
Query FindSurgicalItems(sheetId As %String, elementId As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RecordSheet,
	   ItemName,
	   DataOption,
	   DataOption->Description As DataOptionDesc,
	   Qty,
	   Uom,
	   ElementID,
	   UpdateUser,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',UpdateUser) As UpdateUserDesc,
	   %ODBCOUT(UpdateDate)_" "_%ODBCOUT(UpdateTime) As UpdateDT
	   From CIS_AN.SurgicalItem
	   where RecordSheet=:sheetId
	   and (ElementID=:elementId or :elementId is null)
}

/// Creator：      	陈长青
/// CreatDate：    	2018-07-13
/// Description： 	查询患者检验数据
/// Table：        	CIS_AN.LabData
/// Input:			EpisodeID:患者就诊ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindLabDatas","6900")
Query FindLabDatas(EpisodeID As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT EpisodeID,
	   TestCode,
	   TestCodeDesc,
	   LabNo,
	   SpecimenCode,
	   %ODBCOUT(CollectDate)_" "_%ODBCOUT(CollectTime) As CollectDT,
	   %ODBCOUT(ReceivedDate)_" "_%ODBCOUT(ReceivedTime) As ReceivedDT,
	   %ODBCOUT(ResultDate)_" "_%ODBCOUT(ResultTime) As ResultDT,
	   TestResult,
	   TestResultUnitCode,
	   TestResultRange,
	   TestConclusion,
	   LabLocCode
	   From CIS_AN.LabData
	   where EpisodeID=:EpisodeID
}

/// Creator：      	陈长青
/// CreatDate：    	2018-07-13
/// Description： 	查询患者检验数据
/// Table：        	CIS_AN.LabData
/// Input:			EpisodeID:患者就诊ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindLabDatas","6900")
Query FindBloodTransfusion(opsId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *
	   From CIS_AN.BloodTransfusion
	   where OperSchedule=:opsId
}

/// Creator：      	陈长青
/// CreatDate：    	2018-07-13
/// Description： 	查询患者检验数据
/// Table：        	CIS_AN.LabData
/// Input:			EpisodeID:患者就诊ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindLabDatas","6900")
Query FindBloodTransRecord(recordSheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *
	   From CIS_AN.BloodTransRecord
	   where RecordSheet=:recordSheetId
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-25
/// Description： 	查询麻醉表
/// Table：        	DHCAN.Anaesthesia
/// Input:			opsId：手术安排ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindAnaesthesia","1")
Query FindAnaesthesia(opsId) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT *,
	CIS_AN_COM.String_GetDescByIDStr("User.ORCAnaestMethod","ANMETDesc",AnaMethod) As AnaMethodDesc,
	CIS_AN_COM.String_GetDescByID('User.ASAClassPhActiv','ORASADesc',ASAClass) As ASAClassDesc,
	%EXTERNAL(PreFasting) As PreFastingDesc
	from CIS_AN.Anaesthesia
	where OperSchedule=:opsId
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-25
/// Description： 	查询麻醉插管(业务数据)
/// Table：        	DHCAN.Module.AnaestCatheter
/// Input:			opsId：手术安排ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindAnaestCatheter","1")
Query FindAnaestCatheter(opsId) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT *,
	CIS_AN_COM.String_GetDescByID('User.ORCAnaestMethod','ANMETDesc',AnaMethod) As AnaMethodDesc,
	Catheter -> Description As CatheterDesc,
	CatheterType -> Description As CatheterTypeDesc,
	(CatheterDepth -> Description)_(CatheterDepth -> Unit) As CatheterDepthDesc,
	CatheterPath -> Description As CatheterPathDesc,
	CatheterTool -> Description As CatheterToolDesc,
	CatheterDirection -> Description As CatheterDirectionDesc,
	PunctureSpace -> Description As PunctureSpaceDesc,
	PositionMethod -> Description As PositionMethodDesc,
	ChargeAnaMethodDetail->ChargeRecord As ChargeAnaMethodRecord,
	ChargeCatheterDetail->ChargeRecord As ChargeCatheterRecord
	from CIS_AN.AnaestCatheter
	where (Anaesthesia -> OperSchedule)=:opsId
}

/// Creator：      	雍阳
/// CreatDate：    	2018-06-21
/// Description： 	查询设备使用记录
/// Table：        	DHCAN.Anaesthesia
/// Input:			sheetId：表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindEquipRecord","1")
Query FindEquipRecord(sheetId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT *,
	%ODBCOUT(StartDate) As StartDate, 
	%ODBCOUT(StartTime) As StartTime,
	%ODBCOUT(StartDate)_" "_%ODBCOUT(StartTime) As StartDT,
	%ODBCOUT(EndDate) As EndDate,
	%ODBCOUT(EndTime) As EndTime,
	%ODBCOUT(EndDate)_" "_%ODBCOUT(EndTime) As EndDT,
	Equip -> EquipDesc As EquipDesc,
	Equip -> SerialNumber As SerialNumber,
	Equip -> EquipModel->EQType As EquipType,
	Equip -> EquipModel->EQType -> Description As EquipTypeDesc,
	Equip -> EquipModel As EquipModel,
	Equip -> EquipModel -> Description As EquipModelDesc
	from CIS_AN.EquipRecord
	where RecordSheet=:sheetId
}

/// Creator：      	雍阳
/// CreatDate：    	2018-06-21
/// Description： 	查询毒麻药登记记录
/// Table：        	CIS.AN.ToxicAnestReg
/// Input:			sheetId：表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindEquipRecord","1")
Query FindToxicAnestReg(careProvID, regDate) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT CareProv,
	CIS_AN_COM.String_GetDescByID("User.CTCareProv","CTPCPDesc",CareProv) As CareProvDesc,
	%ODBCOUT(RegDate) As RegDate,
	%ODBCOUT(ClaimDate) As ClaimDate,
	%ODBCOUT(ClaimTime) As ClaimTime,
	%ODBCOUT(ClaimDate)_" "_%ODBCOUT(ClaimTime) As ClaimDT,
	%ODBCOUT(ApplyDate) As ApplyDate,
	%ODBCOUT(ApplyTime) As ApplyTime,
	%ODBCOUT(ApplyDate)_" "_%ODBCOUT(ApplyTime) As ApplyDT,
	%ODBCOUT(ReturnDate) As ReturnDate,
	%ODBCOUT(ReturnTime) As ReturnTime,
	%ODBCOUT(ReturnDate)_" "_%ODBCOUT(ReturnTime) As ReturnDT,
	ApplyCheckUser,
	CIS_AN_COM.String_GetDescByID("User.SSUser","SSUSRName",ApplyCheckUser) As ApplyCheckUserName,
	ClaimCheckUser,
	CIS_AN_COM.String_GetDescByID("User.SSUser","SSUSRName",ClaimCheckUser) As ClaimCheckUserName,
	ReturnCheckUser,
	CIS_AN_COM.String_GetDescByID("User.SSUser","SSUSRName",ReturnCheckUser) As ReturnCheckUserName
	from CIS_AN.ToxicAnestReg
	where CareProv=:careProvID and RegDate=:regDate
}

/// Creator：      	雍阳
/// CreatDate：    	2018-06-21
/// Description： 	查询毒麻药领用明细
/// Table：        	CIS.AN.ToxicAnestClaim
/// Input:			sheetId：表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindToxicAnestClaim","1")
Query FindToxicAnestClaim(regRecordID) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT *,
	DataItem->Description As DataItemDesc,
	DoseUnit->Description As DoseUnitDesc,
	QtyUnit->Description As QtyUnitDesc,
	%EXTERNAL(Status) As StatusDesc,
	%ODBCOUT(UseDate) As UseDate,
	%ODBCOUT(UseTime) As UseTime,
	%ODBCOUT(UseDate)_" "_%ODBCOUT(UseTime) As UseDT,
	%ODBCOUT(ReturnDate) As ReturnDate,
	%ODBCOUT(ReturnTime) As ReturnTime,
	%ODBCOUT(ReturnDate)_" "_%ODBCOUT(ReturnTime) As ReturnDT,
	RelatedOper->EpisodeID As EpisodeID
	from CIS_AN.ToxicAnestClaim
	where RegRecord=:regRecordID
}

/// Creator：      	雍阳
/// CreatDate：    	2018-8-24
/// Description： 	查询自费药品数据
/// Table：        	CIS_AN.SelfPaidDrugData
/// Input:			recordSheetId:表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindSelfPaidDrugData")
Query FindSelfPaidDrugData(recordSheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	Convert(decimal(8,2),Price) As Price,
	SelfPaidDrug -> Description As DrugDesc
	from CIS_AN.SelfPaidDrugData
	where (RecordSheet=:recordSheetId)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-8-27
/// Description： 	查询一次性自费项目数据
/// Table：        	CIS_AN.SelfPaidMaterialData
/// Input:			recordSheetId:表单ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindSelfPaidMaterialData")
Query FindSelfPaidMaterialData(recordSheetId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	Convert(decimal(8,2),Price) As Price,
	SelfPaidMaterial -> Description As MaterialDesc
	from CIS_AN.SelfPaidMaterialData
	where (RecordSheet=:recordSheetId)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-10-17
/// Description： 	查询麻醉效果评价
/// Table：        	CIS_AN.AnaestEvaluation
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindAnaestEvaluation")
Query FindAnaestEvaluation(opsId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *
	from CIS_AN.AnaestEvaluation
	where (OperSchedule=:opsId)
}

/// Creator：      	雍阳
/// CreatDate：    	2018-11-10
/// Description： 	查询录入的描述历史记录
/// Table：        	CIS_AN.InputTextHistory
/// Input:			module:模块ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindTextHistory","27")
Query FindTextHistory(moduleId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT TOP 50 *,
	%UPPER(Text) As UpperText
	from CIS_AN.InputTextHistory
	where (DataModule=:moduleId)
	order by Counter DESC
}

/// Creator：      	雍阳
/// CreatDate：    	2019-01-24
/// Description： 	查询考勤信息
/// Table：        	CIS.AN.Attendance
/// Input:			attendDate：日期，deptId：科室
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindAttendance","2019-01-25","14")
Query FindAttendance(attendDate As %String, deptId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *,
	   CIS_AN_COM.String_GetDescByID("User.CTCareProv","CTPCPDesc",Member) As MemberName
	   From CIS_AN.Attendance
	   where AttendDate=:attendDate
	   and Dept=:deptId
}

/// Creator：      dyl
/// CreatDate：    	2020-02-13
/// Description： 	查询手术包登记记录
/// Table：        	CIS_AN.MaterialPack
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindMaterialPack","4061")
Query FindMaterialPack(sheetId As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT RowId As MPackRowId,
	   RecordSheet,
	   MaterialPackId,
	   MaterialPackId->Description As MaterialPackNote,
	   MaterialNumber
	   From CIS_AN.MaterialPack
	   where RecordSheet=:sheetId
}

/// Creator：      	雍阳
/// CreatDate：    	2020-05-07
/// Description： 	查询Steward评分数据
/// Table：        	CIS.AN.StewardAssessment
/// Input:			deptId：科室
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.DataQueries","FindStewardAssess","1")
Query FindStewardAssess(rowId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT *
	   From CIS_AN.StewardAssessment
	   where RowId=:rowId
}

}
