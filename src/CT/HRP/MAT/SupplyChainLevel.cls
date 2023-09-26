Class CT.HRP.MAT.SupplyChainLevel Extends (%Persistent, User.Abstract) [ SqlTableName = SupplyChainLevel ]
{

Relationship SCLParRef As CT.HRP.MAT.SupplyChain [ Cardinality = parent, Inverse = Level, Required, SqlFieldName = SCL_ParRef ];

/// 级别
Property SCLLevel As %Integer [ SqlColumnNumber = 3, SqlFieldName = SCL_Level ];

/// 授权单位类型 （P-生产厂家、V-供应商、D-经销商）
Property SCLFrType As %String(COLLATION = "Exact") [ SqlColumnNumber = 4, SqlFieldName = SCL_FrType ];

/// 授权单位 （生产厂家id、供应商id、经销商id）
Property SCLFrPointer As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = SCL_FrPointer ];

/// 目标单位类型 （P-生产厂家、V-供应商、D-经销商）
Property SCLToType As %String(COLLATION = "Exact") [ SqlColumnNumber = 6, SqlFieldName = SCL_ToType ];

/// 目标单位 （生产厂家id、供应商id、经销商id）
Property SCLToPointer As %String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = SCL_ToPointer ];

/// 开始日期
Property SCLStartDate As %Date [ SqlColumnNumber = 8, SqlFieldName = SCL_StartDate ];

/// 开始日期
Property SCLEndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = SCL_EndDate ];

/// 备注
Property SCLRemarks As %String(COLLATION = "Exact") [ SqlColumnNumber = 10, SqlFieldName = SCL_Remarks ];

Index Level On (SCLParRef As Exact, SCLLevel As Exact);

Storage Default
{
<Data name="SupplyChainLevelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SCLLevel</Value>
</Value>
<Value name="3">
<Value>SCLFrType</Value>
</Value>
<Value name="4">
<Value>SCLFrPointer</Value>
</Value>
<Value name="5">
<Value>SCLToType</Value>
</Value>
<Value name="6">
<Value>SCLToPointer</Value>
</Value>
<Value name="7">
<Value>SCLStartDate</Value>
</Value>
<Value name="8">
<Value>SCLEndDate</Value>
</Value>
<Value name="9">
<Value>SCLRemarks</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Level")</DataLocation>
<DefaultData>SupplyChainLevelDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Level")</IdLocation>
<IndexLocation>^CT.HRP.MAT.SupplyChainLevelI</IndexLocation>
<StreamLocation>^CT.HRP.MAT.SupplyChainLevelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
