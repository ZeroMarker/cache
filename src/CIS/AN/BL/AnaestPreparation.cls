Class CIS.AN.BL.AnaestPreparation Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2019-01-04
/// Description： 	查询自动生成医嘱规则
/// Table：        	CF_AN.ArcimRule
/// Input:			filterDesc:筛选字符串
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.AnaestPreparation","FindAnaestPreparation","362","2019-01-14","6463")
Query FindAnaestPreparation(deptId As %String, targetDate As %String, userId As %String = "", operRoomId As %String = "", opsId As %String = "") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   OperSchedule,
	   AnaDoctor,
	   CIS_AN_COM.String_GetDescByID("User.SSUser","SSUSRName",AnaDoctor) As AnaDoctorDesc,
	   %ODBCOUT(TargetDate) As TargetDate,
	   ArcimID,
	   CIS_AN_COM.String_GetDescByID("User.ARCItmMast","ARCIMDesc",ArcimID) As ArcimDesc,
	   PackQty,
	   PackUom,
	   CIS_AN_COM.String_GetDescByID("User.CTUOM","CTUOMDesc",PackUom) As PackUomDesc,
	   Instruction,
	   CIS_AN_COM.String_GetDescByID("User.PHCInstruc","PHCINDesc1",Instruction) As InstrDesc,
	   RecvLoc,
	   CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",RecvLoc) As RecvLocDesc,
	   Dept,
	   CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",Dept) As DeptDesc,
	   OrderSetItem,
	   DoseQty,
	   DoseUom,
	   CIS_AN_COM.String_GetDescByID("User.CTUOM","CTUOMDesc",DoseUom) As DoseUomDesc,
	   Freq,
	   Duration,
	   Status,
	   %External(Status) As StatusDesc,
	   OperRoom,
	   OperRoom->Description As OperRoomDesc
	   from CIS_AN.AnaPreparation
	   where Dept=:deptId
	   and TargetDate=%ODBCIN(:targetDate)
	   and (AnaDoctor=:userId or :userId is null)
	   and (OperRoom=:operRoomId or :operRoomId is null)
	   and (OperSchedule=:opsId or :opsId is null)
}

}
