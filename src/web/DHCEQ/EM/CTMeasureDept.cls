Class web.DHCEQ.EM.CTMeasureDept Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by lmm 2018-10-17
/// 描述：获取计量部门信息
/// 入参：MeasureDept：计量部门
Query GetMeasureDept(MeasureDept) As %SQLQuery(ROWSPEC = "TDescription:%String,TRowID:%String,TCode:%String,TContPerson:%String,TTel:%String")
{
SELECT MD_Name,
	   MD_RowID,
	   MD_Code,
	   MD_ContPerson,
	   MD_Tel
FROM sqluser.DHC_EQCMeasureDept
where MD_InvalidFlag = 'N' and MD_Name like nvl(:MeasureDept,'')||'%'
}

}
