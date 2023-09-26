/// 服务级别表
Class User.DHCHMCServiceClass Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CServiceClass ]
{

Parameter ClassName = "User.DHCHMCServiceClass";

/// 编码
Property SCCode As %String [ SqlFieldName = SC_Code ];

/// 描述
Property SCDesc As %String [ SqlFieldName = SC_Desc ];

/// 建议价格
Property SCPrice As %Float [ SqlFieldName = SC_Price ];

/// 激活	Y/N
Property SCActive As %String [ SqlFieldName = SC_Active ];

/// 随访间隔时间 单位月
Property SCMonths As %Integer [ SqlFieldName = SC_Months ];

/// 备注
Property SCRemark As %String(MAXLEN = 200) [ SqlFieldName = SC_Remark ];

/// 更新日期
Property SCUpdateDate As %Date [ SqlFieldName = SC_UpdateDate ];

/// 更新时间
Property SCUpdateTime As %Time [ SqlFieldName = SC_UpdateTime ];

/// 更信人 指向SS_User
Property SCUpdateUserDR As %String [ SqlFieldName = SC_UpdateUserDR ];

/// 代码 索引
Index SCCodeIndex On SCCode;

/// 描述 索引
Index SCDescIndex On SCDesc;

Relationship DHCHMCSCQLink As DHCHMCSCQLink [ Cardinality = children, Inverse = SCQLParRef ];

Storage Default
{
<Data name="DHCHMCServiceClassDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SCActive</Value>
</Value>
<Value name="3">
<Value>SCCode</Value>
</Value>
<Value name="4">
<Value>SCDesc</Value>
</Value>
<Value name="5">
<Value>SCPrice</Value>
</Value>
<Value name="6">
<Value>SCRemark</Value>
</Value>
<Value name="7">
<Value>SCTime</Value>
</Value>
<Value name="8">
<Value>SCMonths</Value>
</Value>
<Value name="9">
<Value>SCUpdateDate</Value>
</Value>
<Value name="10">
<Value>SCUpdateTime</Value>
</Value>
<Value name="11">
<Value>SCUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCServiceClassD</DataLocation>
<DefaultData>DHCHMCServiceClassDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCServiceClassD</IdLocation>
<IndexLocation>^User.DHCHMCServiceClassI</IndexLocation>
<StreamLocation>^User.DHCHMCServiceClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
