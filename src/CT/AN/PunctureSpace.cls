/// 穿刺间隙
Class CT.AN.PunctureSpace Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = PunctureSpace ]
{

/// 穿刺间隙代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 穿刺间隙名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 穿刺间隙代码唯一索引
Index ICode On Code [ Unique ];

Storage Default
{
<Data name="PunctureSpaceDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^CT.AN.PunctureSpaceD</DataLocation>
<DefaultData>PunctureSpaceDefaultData</DefaultData>
<IdLocation>^CT.AN.PunctureSpaceD</IdLocation>
<IndexLocation>^CT.AN.PunctureSpaceI</IndexLocation>
<StreamLocation>^CT.AN.PunctureSpaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
