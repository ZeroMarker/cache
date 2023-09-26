/// add by zy 2013-05-30 zy0107
/// 测试用Soap调用Cache数据的存储过程
Class web.DHCEQProcedure Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*
/// This procedure returns a set of persons ordered by name
Query ListPersons(name As %String = "") As %SQLQuery [ SqlProc ]
{
    SELECT ID, Name
    FROM Person
    ORDER BY Name
}
*/
/// w ##Class(web.DHCEQProcedure).Test(1)
Query Test(ID As %String = "") As %SQLQuery(ROWSPEC = "URS_RowID:%String,URS_ServiceItem:%String") [ SqlProc ]
{
	select URS_RowID,URS_ServiceItemDR->SI_Desc as URS_ServiceItem
	FROM SQLUSER.DHC_EQUseRecordStat
	WHERE URS_RowID < :ID
}

/// w ##Class(web.DHCEQProcedure).Test(1)
ClassMethod Test1(ID As %String = "") As %String [ SqlProc ]
{
	q ID
}

}
