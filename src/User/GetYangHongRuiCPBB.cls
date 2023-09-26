Class User.GetYangHongRuiCPBB Extends %Persistent [ SqlTableName = Get_YangHongRuiCPBB ]
{

Property D As %String [ Required, SqlColumnNumber = 2, SqlFieldName = D_ate ];

Property T As %String [ SqlColumnNumber = 3, SqlFieldName = T_ime ];

Property H As %String [ SqlColumnNumber = 4, SqlFieldName = H_our ];

Property Min As %String [ SqlColumnNumber = 5, SqlFieldName = Min_ute ];

Property Sec As %String [ SqlColumnNumber = 6, SqlFieldName = Sec_ond ];

Storage Default
{
<Data name="GetYangHongRuiCPBBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>D</Value>
</Value>
<Value name="3">
<Value>T</Value>
</Value>
<Value name="4">
<Value>H</Value>
</Value>
<Value name="5">
<Value>Min</Value>
</Value>
<Value name="6">
<Value>Sec</Value>
</Value>
</Data>
<DataLocation>^User.GetYangHongRuiCPBBD</DataLocation>
<DefaultData>GetYangHongRuiCPBBDefaultData</DefaultData>
<IdLocation>^User.GetYangHongRuiCPBBD</IdLocation>
<IndexLocation>^User.GetYangHongRuiCPBBI</IndexLocation>
<StreamLocation>^User.GetYangHongRuiCPBBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
