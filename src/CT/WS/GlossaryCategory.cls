Class CT.WS.GlossaryCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 术语范畴名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术语范畴描述	
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术语范畴父类ID
Property ParentID As %String(TRUNCATE = 1);

/// 该术语范畴下的术语数目
Property ResChildCount As %Integer;

/// 内部表示符
Property InternalID As %String(TRUNCATE = 1);

Index IdxOnInternalID On InternalID [ Unique ];

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer, Name:%String, Description:%String, ParentID:%String, ResChildCount:%Integer, InternalID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_GlossaryCategory_SelectAll, SqlProc ]
{
	SELECT ID, Name, Description, ParentID, ResChildCount, InternalID
 	FROM CT_WS.GlossaryCategory
 	ORDER BY ID
}

Storage Default
{
<Data name="GlossaryCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>ResChildCount</Value>
</Value>
<Value name="6">
<Value>InternalID</Value>
</Value>
</Data>
<DataLocation>^DHCCTWS.GlossaryCategoryD</DataLocation>
<DefaultData>GlossaryCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCTWS.GlossaryCategoryD</IdLocation>
<IndexLocation>^DHCCTWS.GlossaryCategoryI</IndexLocation>
<StreamLocation>^DHCCTWS.GlossaryCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
