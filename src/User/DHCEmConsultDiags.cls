/// 会诊申请诊断表
/// hxy
/// 2021-04-20
Class User.DHCEmConsultDiags Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_EmConsultDiags ]
{

// 会诊主表Dr

Property ECParRefDr As User.DHCEmConsult [ SqlColumnNumber = 2, SqlFieldName = EC_ParRef_Dr ];

// 诊断代码

Property ECDiagCode As %String [ SqlColumnNumber = 3, SqlFieldName = EC_DiagCode ];

// 诊断描述

Property ECDiagDesc As %String [ SqlColumnNumber = 4, SqlFieldName = EC_DiagDesc ];

Index IndexParRef On ECParRefDr;

Storage Default
{
<Data name="DHCEmConsultDiagsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ECParRefDr</Value>
</Value>
<Value name="3">
<Value>ECDiagCode</Value>
</Value>
<Value name="4">
<Value>ECDiagDesc</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmConsultDiagsD</DataLocation>
<DefaultData>DHCEmConsultDiagsDefaultData</DefaultData>
<IdLocation>^User.DHCEmConsultDiagsD</IdLocation>
<IndexLocation>^User.DHCEmConsultDiagsI</IndexLocation>
<StreamLocation>^User.DHCEmConsultDiagsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
