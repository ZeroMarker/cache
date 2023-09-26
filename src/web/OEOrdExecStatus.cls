Include webimport

IncludeGenerator webimport

Class web.OEOrdExecStatus Extends (%Library.RegisteredObject, websys.Abstract) [ Not Abstract, ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 47;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "STCH_RowId";

Parameter SQLDESCRIPTION = "STCH_RowId";

Parameter SQLROWID = "STCH_RowId";

ClassMethod Insert1(PARREF As %Library.String = "")
{
}

ClassMethod HasChanged(OEExeID As %Library.String = "")
{
}

ClassMethod Insert(PARREF As %Library.String = "", Status As %Library.String = "", User As %Library.String = "", Reason As %Library.String = "")
{
}

ClassMethod Update(compref As %String)
{
}

Query List(PARREF As %String) As %Library.SQLQuery(CONTAINID = 0, ROWSPEC = "id:%String,Status:%String,Reason:%String,Date:%String,Time:%String,User:%String")
{
SELECT 	STCH_RowId,STCH_AdminStatus_DR->STAT_Desc,STCH_Reason_DR->ASCR_Desc,STCH_Date,STCH_Time,STCH_User_DR->SSUSR_Initials
FROM 	SQLUser.OE_OrdExecStatus
WHERE	(STCH_ParRef = :PARREF)
}

Storage Default
{
<Data name="OEOrdExecStatusDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.OEOrdExecStatusD</DataLocation>
<DefaultData>OEOrdExecStatusDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.OEOrdExecStatusD</IdLocation>
<IndexLocation>^web.OEOrdExecStatusI</IndexLocation>
<StreamLocation>^web.OEOrdExecStatusS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
