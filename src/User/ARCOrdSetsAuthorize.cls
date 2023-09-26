Class User.ARCOrdSetsAuthorize Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_OrdSetsAuthorize, StorageStrategy = NewStorage1 ]
{

Index AuthARCOSDR On AuthARCOSDR;

Index AuthLocDr On (AuthARCOSDR, AuthLocDr);

Index AuthLocARCOSDr On (AuthLocDr, AuthARCOSDR);

/// 医嘱套ID
Property AuthARCOSDR As ARCOrdSets [ SqlColumnNumber = 2 ];

/// 科室ID
Property AuthLocDr As CTLoc [ SqlColumnNumber = 3 ];

Storage NewStorage1
{
<Data name="ARCOrdSetsAuthorizeDefaultData">
<Subscript>"1"</Subscript>
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="Node1">
<Value name="1">
<Value>AuthARCOSDR</Value>
</Value>
<Value name="2">
<Value>AuthLocDr</Value>
</Value>
</Data>
<DataLocation>^User.ARCOrdSetsAuthorizeD</DataLocation>
<DefaultData>ARCOrdSetsAuthorizeDefaultData</DefaultData>
<IdLocation>^User.ARCOrdSetsAuthorizeD</IdLocation>
<IndexLocation>^User.ARCOrdSetsAuthorizeI</IndexLocation>
<StreamLocation>^User.ARCOrdSetsAuthorizeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
