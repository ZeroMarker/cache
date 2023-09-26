/// Description: 儿童早期预警评分
Class User.DHCEmChildEarWarn Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlTableName = DHC_EmChildEarWarn ]
{

/// 预检表 CEW_Chk_Dr
Property CEWChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = CEW_Chk_Dr ];

/// 意识得分
Property CEWAware As %Library.String [ SqlColumnNumber = 3, SqlFieldName = CEW_Aware ];

/// 心血管系统得分
Property CEWCvlSys As %Library.String [ SqlColumnNumber = 4, SqlFieldName = CEW_CvlSys ];

/// 呼吸系统得分
Property CEWRptSys As %Library.String [ SqlColumnNumber = 5, SqlFieldName = CEW_RptSys ];

Index IndexChk On CEWChkDr;

Storage Default
{
<Data name="DHCEmChildEarWarnDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CEWChkDr</Value>
</Value>
<Value name="3">
<Value>CEWAware</Value>
</Value>
<Value name="4">
<Value>CEWCvlSys</Value>
</Value>
<Value name="5">
<Value>CEWRptSys</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmChildEarWarnD</DataLocation>
<DefaultData>DHCEmChildEarWarnDefaultData</DefaultData>
<IdLocation>^User.DHCEmChildEarWarnD</IdLocation>
<IndexLocation>^User.DHCEmChildEarWarnI</IndexLocation>
<StreamLocation>^User.DHCEmChildEarWarnS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
