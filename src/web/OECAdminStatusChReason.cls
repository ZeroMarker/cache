Class web.OECAdminStatusChReason Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 4;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "ASCR_Code";

Parameter SQLDESCRIPTION = "ASCR_Desc";

Parameter SQLROWID = "ASCR_RowId";

Storage Default
{
<Data name="OECAdminStatusChReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.OECAdminStatusChReasonD</DataLocation>
<DefaultData>OECAdminStatusChReasonDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.OECAdminStatusChReasonD</IdLocation>
<IndexLocation>^web.OECAdminStatusChReasonI</IndexLocation>
<StreamLocation>^web.OECAdminStatusChReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
