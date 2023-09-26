Class DHCEPRFS.INST.CreatePageInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 集中打印方案ID
Property SchemeID As %String(TRUNCATE = 1);

/// 当前用户ID
Property UserID As %String(TRUNCATE = 1);

/// 页码
Property PageNumber As %String(TRUNCATE = 1);

/// 页码信息，形式为ID|起始页码|结束页码
Property PageInfo As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 是否启用页码排队
Property IsQueue As %String(TRUNCATE = 1);

Index IdxSchemeID On SchemeID;

Index IdxUserID On UserID;

Storage Default
{
<Data name="CreatePageInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IsQueue</Value>
</Value>
<Value name="3">
<Value>PageInfo</Value>
</Value>
<Value name="4">
<Value>PageNumber</Value>
</Value>
<Value name="5">
<Value>SchemeID</Value>
</Value>
<Value name="6">
<Value>UserID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.INST.CreatePageInfoD</DataLocation>
<DefaultData>CreatePageInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.INST.CreatePageInfoD</IdLocation>
<IndexLocation>^DHCEPRFS.INST.CreatePageInfoI</IndexLocation>
<StreamLocation>^DHCEPRFS.INST.CreatePageInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
