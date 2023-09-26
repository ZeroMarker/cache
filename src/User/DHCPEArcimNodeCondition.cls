/// Description:项目预约管理树节点条件
/// Creator:wangguoying
Class User.DHCPEArcimNodeCondition Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_ArcimNodeCondition ]
{

Parameter ClassName = "User.DHCPEArcimNodeCondition";

Relationship ANCParRef As User.DHCPEArcimPreTree [ Cardinality = parent, Inverse = APTCondition ];

/// 性别
Property APCSexDR As User.CTSex [ SqlColumnNumber = 2, SqlFieldName = APC_Sex_DR ];

/// 年龄最小值
Property APCMinAge As %Integer [ SqlColumnNumber = 3, SqlFieldName = APC_MinAge ];

/// 年龄最大值
Property APCMaxAge As %Integer [ SqlColumnNumber = 4, SqlFieldName = APC_MaxAge ];

/// VIP等级
Property APCVIPLevel As %String [ SqlColumnNumber = 5, SqlFieldName = APC_VIPLevel ];

/// 更新人
Property APCUpdateUserDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = APC_UpdateUser_DR ];

/// 操作日期
Property APCUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = APC_UpdateDate ];

/// 更新时间
Property APCUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = APC_UpdateTime ];

Index ParRefIndex On ANCParRef [ Unique ];

Storage Default
{
<Data name="DHCPEArcimNodeConditionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>APCSexDR</Value>
</Value>
<Value name="3">
<Value>APCMinAge</Value>
</Value>
<Value name="4">
<Value>APCMaxAge</Value>
</Value>
<Value name="5">
<Value>APCVIPLevel</Value>
</Value>
<Value name="6">
<Value>APCUpdateUserDR</Value>
</Value>
<Value name="7">
<Value>APCUpdateDate</Value>
</Value>
<Value name="8">
<Value>APCUpdateTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("APTCondition")</DataLocation>
<DefaultData>DHCPEArcimNodeConditionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEArcimPreTreeC("APTCondition")</IdLocation>
<IndexLocation>^User.DHCPEArcimNodeConditionI</IndexLocation>
<StreamLocation>^User.DHCPEArcimNodeConditionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
