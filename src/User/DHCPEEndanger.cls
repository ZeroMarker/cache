Class User.DHCPEEndanger Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_Endanger ]
{

Parameter ClassName = "User.DHCPEEndanger";

/// 危害因素代码
Property EDCode As %String(MAXLEN = 20) [ Required, SqlFieldName = ED_Code ];

/// 危害因素描述
Property EDDesc As %String(MAXLEN = 20) [ Required, SqlFieldName = ED_Desc ];

/// 危害因素检查项目维护
Relationship EDItemChild As User.DHCPEEDItem [ Cardinality = children, Inverse = EDIParref ];

/// 危害因素对应的目标疾病
Relationship EDIllnessChild As User.DHCPEEDIllness [ Cardinality = children, Inverse = EDIlParref ];

/// 危害因素的检查周期
Relationship EDCheckCycleChild As User.DHCPEEDCheckCycle [ Cardinality = children, Inverse = EDCParref ];

/// 危害因素的诊断依据
Relationship EDCheckCriteriaChild As User.DHCPEEDCheckCriteria [ Cardinality = children, Inverse = EDCCParref ];

///  激活，Y，N
Property EDActive As %String(MAXLEN = 1) [ SqlFieldName = ED_Active ];

///  危害因素分类
Property EDEDTypeDR As User.DHCPEEndangerType [ Required, SqlFieldName = ED_EDTypeDR ];

///  危害因素扩展信息
Property EDExpInfo As %String(MAXLEN = 10) [ SqlFieldName = ED_ExpInfo ];

///  备注
Property EDRemark As %String(MAXLEN = 200) [ SqlFieldName = ED_Remark ];

/// 代码索引
Index EDCodeIndex On EDCode [ Unique ];

/// 描述索引
Index EDDescIndex On EDDesc [ Unique ];

///  危害分类索引
Index EDTypeIndex On EDEDTypeDR As AlphaUp;

Storage Default
{
<Data name="DHCPEEndangerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EDCode</Value>
</Value>
<Value name="3">
<Value>EDDesc</Value>
</Value>
<Value name="4">
<Value>EDActive</Value>
</Value>
<Value name="5">
<Value>EDEDTypeDR</Value>
</Value>
<Value name="6">
<Value>EDExpInfo</Value>
</Value>
<Value name="7">
<Value>EDRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEEndangerD</DataLocation>
<DefaultData>DHCPEEndangerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEEndangerD</IdLocation>
<IndexLocation>^User.DHCPEEndangerI</IndexLocation>
<StreamLocation>^User.DHCPEEndangerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
