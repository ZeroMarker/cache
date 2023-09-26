Class EPRmeta.ReportCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

Property ResChildCount As %Integer;

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,ParentID:%String,Description:%String,ResChildCount:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_ReportCategory_SELECTALL, SqlProc ]
{
 SELECT ID, Name, ParentID, Description,ResChildCount
 FROM EPRmeta.ReportCategory
 ORDER BY ID
}

Storage Default
{
<Data name="ReportCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>ResChildCount</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.ReportCategoryD</DataLocation>
<DefaultData>ReportCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.ReportCategoryD</IdLocation>
<IndexLocation>^DHCEPRM.ReportCategoryI</IndexLocation>
<StreamLocation>^DHCEPRM.ReportCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
