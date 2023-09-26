/// Desc:查询科室
/// Creator:Candy
Class DHCEPRFS.META.QueryUserLoc Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

/// 科室代码
Property LocID As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 科室描述
Property LocDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 查询用户ID
Property QueryUserID As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 顺序
Property Sequence As %Integer [ SqlColumnNumber = 5 ];

Index IdxUserLocID On (QueryUserID, LocID);

Index IdxUserSequence On (QueryUserID, Sequence);

Index IdxUserID On QueryUserID;

Storage Default
{
<Data name="QueryUserLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LocDesc</Value>
</Value>
<Value name="3">
<Value>LocID</Value>
</Value>
<Value name="4">
<Value>QueryUserID</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryUserLocD</DataLocation>
<DefaultData>QueryUserLocDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QueryUserLocD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryUserLocI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryUserLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
