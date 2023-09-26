Class User.DHCPESourceTimeVIPManager Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_SourceTimeVIPManager ]
{

Parameter ClassName = "User.DHCPESourceTimeVIPManager";

Relationship STVMParRef As User.DHCPESourceTimeManager [ Cardinality = parent, Inverse = STMVIPType ];

/// VIP等级  8.5之后改成 User.DHCPEVIPLevel
Property STVMVIPLevel As %Integer [ Required, SqlColumnNumber = 2, SqlFieldName = STVM_VIPLevel ];

/// I:个人、G:单位、N:不限
Property STVMType As %String(COLLATION = "AlphaUp", VALUELIST = ",I,G,N") [ Required, SqlColumnNumber = 3, SqlFieldName = STVM_Type ];

/// 总数量
Property STVMNum As %Integer [ SqlColumnNumber = 4, SqlFieldName = STVM_Num ];

/// 男性数量
Property STVMMaleNum As %Integer [ SqlColumnNumber = 5, SqlFieldName = STVM_MaleNum ];

/// 女性数量
Property STVMFemaleNum As %Integer [ SqlColumnNumber = 6, SqlFieldName = STVM_FemaleNum ];

/// 更新人
Property STVMUpdateUserDR As User.SSUser [ Required, SqlColumnNumber = 7, SqlFieldName = STVM_UpdateUser_DR ];

/// 更新日期
Property STVMUpdateDate As %Date [ InitialExpression = {+$H}, Required, SqlColumnNumber = 8, SqlFieldName = STVM_UpdateDate ];

/// 更新时间
Property STVMUpdateTime As %Time [ InitialExpression = {$p($H,",",2)}, Required, SqlColumnNumber = 9, SqlFieldName = STVM_UpdateTime ];

Index IndOfVIPType On (STVMParRef, STVMVIPLevel, STVMType) [ Unique ];

Index IndOfVIPTypeParRef On (STVMVIPLevel, STVMType, STVMParRef) [ Unique ];

Storage Default
{
<Data name="DHCPESourceTimeVIPManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>STVMVIPLevel</Value>
</Value>
<Value name="3">
<Value>STVMType</Value>
</Value>
<Value name="4">
<Value>STVMNum</Value>
</Value>
<Value name="5">
<Value>STVMMaleNum</Value>
</Value>
<Value name="6">
<Value>STVMFemaleNum</Value>
</Value>
<Value name="7">
<Value>STVMUpdateUserDR</Value>
</Value>
<Value name="8">
<Value>STVMUpdateDate</Value>
</Value>
<Value name="9">
<Value>STVMUpdateTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("STMVIPType")</DataLocation>
<DefaultData>DHCPESourceTimeVIPManagerDefaultData</DefaultData>
<IdLocation>^User.DHCPESourceTimeManagerC("STMVIPType")</IdLocation>
<IndexLocation>^User.DHCPESourceTimeVIPManagerI</IndexLocation>
<StreamLocation>^User.DHCPESourceTimeVIPManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
