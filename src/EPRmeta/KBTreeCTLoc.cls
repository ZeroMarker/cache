Class EPRmeta.KBTreeCTLoc Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property CTLocID As %String(TRUNCATE = 1) [ Required ];

Property KBTreeID As %String(TRUNCATE = 1) [ Required ];

Property ActiveFlag As %String(TRUNCATE = 1);

Index IdxCTLocKBTreeID On (CTLocID, KBTreeID) [ Unique ];

Index IdxKBTreeCTLocID On (KBTreeID, CTLocID);

Index IdxKBTreeID On KBTreeID;

Storage Default
{
<Data name="KBTreeCTLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CTLocID</Value>
</Value>
<Value name="3">
<Value>KBTreeID</Value>
</Value>
<Value name="4">
<Value>ActiveFlag</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.KBTreeCTLocD</DataLocation>
<DefaultData>KBTreeCTLocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.KBTreeCTLocD</IdLocation>
<IndexLocation>^DHCEPRM.KBTreeCTLocI</IndexLocation>
<StreamLocation>^EPRmeta.KBTreeCTLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
