Class User.DHCPEExpress Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_Express ]
{

Parameter ClassName = "User.DHCPEExpress";

Property EType As %String [ SqlFieldName = E_Type ];

Property ESourceID As %Library.Numeric [ SqlFieldName = E_SourceID ];

// Property ESourceID As User.DHCPEExpertDiagnosis [ SqlFieldName = E_SourceID ];

Property EPreBracket As %String [ SqlFieldName = E_PreBracket ];

Property EItemDR As User.DHCPEOrderDetail [ SqlFieldName = E_ItemDR ];

Property EOperator As %String [ SqlFieldName = E_Operator ];

Property EODStandardDR As User.DHCPEODStandard [ SqlFieldName = E_ODStandardDR ];

Property EReference As %String [ SqlFieldName = E_Reference ];

Property EAfterBracket As %String [ SqlFieldName = E_AfterBracket ];

Property ERelation As %String [ SqlFieldName = E_Relation ];

Property ESex As %String [ SqlFieldName = E_Sex ];

/// 非血细项
Property ENoBloodFlag As %String [ SqlFieldName = E_NoBloodFlag ];

/// 年龄范围
Property EAgeRange As %String [ SqlFieldName = E_AgeRange ];

/// 知识库专家建议表达式（外部码）
Property EKBXCode As %String [ SqlFieldName = E_KBXCode ];

/// 知识库站点细项代码
Property EKBItemDtlCode As %String(MAXLEN = 200) [ SqlFieldName = E_KBItemDtlCode ];

/// 知识库站点细项名称
Property EKBItemDtlDesc As %String(MAXLEN = 200) [ SqlFieldName = E_KBItemDtlDesc ];

Index SourceIDIndex On (EType As AlphaUp, ESourceID As AlphaUp);

/// 知识库专家建议表达式（外部码）索引
Index IdxOfKBXCode On (ESourceID As AlphaUp, EKBXCode As AlphaUp);

Storage Default
{
<Data name="DHCPEExpressDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EType</Value>
</Value>
<Value name="3">
<Value>ESourceID</Value>
</Value>
<Value name="4">
<Value>EPreBracket</Value>
</Value>
<Value name="5">
<Value>EItemDR</Value>
</Value>
<Value name="6">
<Value>ETOperator</Value>
</Value>
<Value name="7">
<Value>EODStandardDR</Value>
</Value>
<Value name="8">
<Value>EReference</Value>
</Value>
<Value name="9">
<Value>EAfterBracket</Value>
</Value>
<Value name="10">
<Value>ERelation</Value>
</Value>
<Value name="11">
<Value>EOperator</Value>
</Value>
<Value name="12">
<Value>ESex</Value>
</Value>
<Value name="13">
<Value>ENoBloodFlag</Value>
</Value>
<Value name="14">
<Value>EAgeRange</Value>
</Value>
<Value name="15">
<Value>EKBXCode</Value>
</Value>
<Value name="16">
<Value>EKBItemDtlCode</Value>
</Value>
<Value name="17">
<Value>EKBItemDtlDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEExpressD</DataLocation>
<DefaultData>DHCPEExpressDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEExpressD</IdLocation>
<IndexLocation>^User.DHCPEExpressI</IndexLocation>
<StreamLocation>^User.DHCPEExpressS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
