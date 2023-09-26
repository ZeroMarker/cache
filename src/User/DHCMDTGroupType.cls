Class User.DHCMDTGroupType Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = MG_RowID, SqlTableName = DHC_MDTGroupType ]
{

/// 分组指针  MG_Group_Dr
Property MGGroupDr As User.DHCMDTGroup [ SqlColumnNumber = 2, SqlFieldName = MG_Group_Dr ];

/// 专家组类别  MG_CType 
Property MGCType As %String [ SqlColumnNumber = 3, SqlFieldName = MG_CType ];

Index IndexGroup On MGGroupDr;

Storage Default
{
<Data name="DHCMDTGroupTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MGGroupDr</Value>
</Value>
<Value name="3">
<Value>MGCType</Value>
</Value>
</Data>
<DataLocation>^User.DHCMDTGroupTypeD</DataLocation>
<DefaultData>DHCMDTGroupTypeDefaultData</DefaultData>
<IdLocation>^User.DHCMDTGroupTypeD</IdLocation>
<IndexLocation>^User.DHCMDTGroupTypeI</IndexLocation>
<StreamLocation>^User.DHCMDTGroupTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
