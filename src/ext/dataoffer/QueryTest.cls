Import SQLUser

Class ext.dataoffer.QueryTest Extends %RegisteredObject
{

Query CTLocData(code As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "%ID:%String:RowID,CTLOC_Code:%String:代码,CTLOC_Desc:%String:名称")
{
SELECT %ID,CTLOC_Code,CTLOC_Desc from CT_Loc
where CTLOC_Code %STARTSWITH  :code
}

Query CTLocData2(string As %String, bigint As %BigInt, binary As %Binary, boolean As %Boolean, blank) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,CTLOC_Code,CTLOC_Desc from CT_Loc
where CTLOC_Code %STARTSWITH  :code
}

Query ViewTest() As %SQLQuery(CONTAINID = 1) [ SqlView, SqlViewName = ViewTest ]
{
SELECT %ID,CTLOC_Code,CTLOC_Desc from SQLUser.CT_Loc
}

}
