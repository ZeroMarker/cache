Class User.DHCPEDiagnosticCriteria Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, User.Abstract) [ SqlTableName = DHC_PE_DiagnosticCriteria ]
{

Parameter ClassName = "User.DHCPEDiagnosticCriteria";

/// 标准代码
Property DCCode As %String(MAXLEN = 100) [ Required, SqlFieldName = DC_Code ];

/// 国家职业卫生标准
Property DCDesc As %String(MAXLEN = 200) [ Required, SqlFieldName = DC_Desc ];

/// 是否使YN
Property DCActive As %String(DISPLAYLIST = ",Y,N", VALUELIST = ",Y,N") [ SqlFieldName = DC_Active ];

/// 扩展信息
Property DCExpInfo As %String(MAXLEN = 200) [ SqlFieldName = DC_ExpInfo ];

/// 备注
Property DCRemark As %String(MAXLEN = 500) [ SqlFieldName = DC_Remark ];

/// 【加】被代替标准代码
Property DCReplacedCode As %String(MAXLEN = 100) [ SqlFieldName = DC_ReplacedCode ];

/// 【加】发布时间
Property DCPublicDate As %Date [ SqlFieldName = DC_PublicDate ];

/// 【加】实施时间
Property DCEffectDate As %Date [ SqlFieldName = DC_EffectDate ];

/// 【加】更新日期
Property DCUpdateDate As %Date [ SqlFieldName = DC_UpdateDate ];

/// 【加】更新时间
Property DCUpdateTime As %Time [ SqlFieldName = DC_UpdateTime ];

/// 【加】更新人 指向SS_User
Property DCUpdateUserDR As %String [ SqlFieldName = DC_UpdateUserDR ];

Index DCCodeIndex On DCCode [ Unique ];

Index DCDescIndex On DCDesc;

Index IdxOfReplacedCode On DCReplacedCode;

Storage Default
{
<Data name="DHCPEDiagnosticCriteriaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DCCode</Value>
</Value>
<Value name="3">
<Value>DCDesc</Value>
</Value>
<Value name="4">
<Value>DCActive</Value>
</Value>
<Value name="5">
<Value>DCExpInfo</Value>
</Value>
<Value name="6">
<Value>DCRemark</Value>
</Value>
<Value name="7">
<Value>DCReplacedCode</Value>
</Value>
<Value name="8">
<Value>DCPublicDate</Value>
</Value>
<Value name="9">
<Value>DCEffectDate</Value>
</Value>
<Value name="10">
<Value>DCUpdateDate</Value>
</Value>
<Value name="11">
<Value>DCUpdateTime</Value>
</Value>
<Value name="12">
<Value>DCUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEDiagnosticCriteriaD</DataLocation>
<DefaultData>DHCPEDiagnosticCriteriaDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEDiagnosticCriteriaD</IdLocation>
<IndexLocation>^User.DHCPEDiagnosticCriteriaI</IndexLocation>
<StreamLocation>^User.DHCPEDiagnosticCriteriaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
