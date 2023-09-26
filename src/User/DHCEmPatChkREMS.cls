/// REMS评分主题
Class User.DHCEmPatChkREMS Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_EMPatChkREMS ]
{

/// 预检表 PCS_Chk_Dr
Property PCSChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PCS_Chk_Dr ];

/// 睁眼得分
Property PCSREMSOpenEye As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PCS_REMS_OpenEye ];

/// 语言得分
Property PCSREMSLanguage As %Library.String [ SqlColumnNumber = 4, SqlFieldName = PCS_REMS_Language ];

/// 运动得分
Property PCSREMSSport As %Library.String [ SqlColumnNumber = 5, SqlFieldName = PCS_REMS_Sport ];

/// 脉搏得分
Property PCSREMSPulse As %Library.String [ SqlColumnNumber = 6, SqlFieldName = PCS_REMS_Pulse ];

/// Spo2得分
Property PCSREMSSpo2 As %Library.String [ SqlColumnNumber = 7, SqlFieldName = PCS_REMS_Spo2 ];

/// 收缩压得分
Property PCSREMSSBP As %Library.String [ SqlColumnNumber = 8, SqlFieldName = PCS_REMS_SBP ];

/// 呼吸频率
Property PCSREMSBreathe As %Library.String [ SqlColumnNumber = 9, SqlFieldName = PCS_REMS_Breathe ];

/// 年龄得分
Property PCSREMSAge As %Library.String [ SqlColumnNumber = 10, SqlFieldName = PCS_REMS_Age ];

/// 总体评级
Property PCSREMSLevel As %Library.String [ SqlColumnNumber = 11, SqlFieldName = PCS_REMS_Level ];

/// 激活标志
Property PCSREMSActive As %Library.String [ SqlColumnNumber = 12, SqlFieldName = PCS_REMS_Active ];

Index IndexChk On PCSChkDr;

Storage Default
{
<Data name="DHCEmPatChkREMSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PCSChkDr</Value>
</Value>
<Value name="3">
<Value>PCSREMSOpenEye</Value>
</Value>
<Value name="4">
<Value>PCSREMSLanguage</Value>
</Value>
<Value name="5">
<Value>PCSREMSSport</Value>
</Value>
<Value name="6">
<Value>PCSREMSPulse</Value>
</Value>
<Value name="7">
<Value>PCSREMSSpo2</Value>
</Value>
<Value name="8">
<Value>PCSREMSSBP</Value>
</Value>
<Value name="9">
<Value>PCSREMSBreathe</Value>
</Value>
<Value name="10">
<Value>PCSREMSAge</Value>
</Value>
<Value name="11">
<Value>PCSREMSLevel</Value>
</Value>
<Value name="12">
<Value>PCSREMSActive</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmPatChkREMSD</DataLocation>
<DefaultData>DHCEmPatChkREMSDefaultData</DefaultData>
<IdLocation>^User.DHCEmPatChkREMSD</IdLocation>
<IndexLocation>^User.DHCEmPatChkREMSI</IndexLocation>
<StreamLocation>^User.DHCEmPatChkREMSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
