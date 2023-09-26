Class EPRmeta.KBCategory Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

Property ResChildCount As %Integer;

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,ParentID:%String,Description:%String,ResChildCount:%Integer", SELECTMODE = "RUNTIME") [ SqlName = SP_KBCategory_SELECTALL, SqlProc ]
{
 SELECT ID, Name, ParentID, Description,ResChildCount
 FROM EPRmeta.KBCategory
 ORDER BY ID
}

Storage Default
{
<Data name="KBCategoryDefaultData">
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
<Value>ChildCount</Value>
</Value>
<Value name="6">
<Value>ResChildCount</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.KBCategoryD</DataLocation>
<DefaultData>KBCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.KBCategoryD</IdLocation>
<IndexLocation>^DHCEPRM.KBCategoryI</IndexLocation>
<StreamLocation>^DHCEPRM.KBCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
