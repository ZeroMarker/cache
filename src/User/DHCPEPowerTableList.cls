/// 表登记授权管理
Class User.DHCPEPowerTableList Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_PowerTableList ]
{

Parameter ClassName = "User.DHCPEPowerTableList";

/// 表名称/Global
Property PTTabCode As %String [ Required, SqlFieldName = PT_TabCode ];

/// 中文名称
Property PTTabDesc As %String [ Required, SqlFieldName = PT_TabDesc ];

/// 类名称
Property PTClsCode As %String [ SqlFieldName = PT_ClsCode ];

/// 权限分类
Property PTPowerType As %String(DISPLAYLIST = ",公有,私有,管控,绝对私有", TRUNCATE = 1, VALUELIST = ",G,S,C,A") [ SqlFieldName = PT_PowerType ];

/// 父表/父类
Property PTParCode As %String [ SqlFieldName = PT_ParCode ];

/// 备注说明
Property PTRemark As %String [ SqlFieldName = PT_Remark ];

/// 表名称/Global 索引
Index IdxOfCode On PTTabCode [ Unique ];

/// 类名称 索引
Index IdxOfClsCode On PTClsCode As SqlUpper;

/// 父表/父类 索引
Index IdxOfParCode On PTParCode As SqlUpper;

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PTTabCode</Value>
</Value>
<Value name="3">
<Value>PTTabDesc</Value>
</Value>
<Value name="4">
<Value>PTPowerType</Value>
</Value>
<Value name="5">
<Value>PTClsCode</Value>
</Value>
<Value name="6">
<Value>PTParCode</Value>
</Value>
<Value name="7">
<Value>PTRemark</Value>
</Value>
</Data>
<DataLocation>^CT.PE.PowerTableListD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.PE.PowerTableListD</IdLocation>
<IndexLocation>^CT.PE.PowerTableListI</IndexLocation>
<StreamLocation>^User.DHCPEPowerTableListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
