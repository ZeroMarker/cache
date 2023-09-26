Class DHCINM.HR.MgSpecialDevelop Extends %Persistent
{

/// 人员档案id
Property SpecialPerDR As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Special_PerDR ];

/// 病区
Property SpecialWard As %String [ SqlColumnNumber = 3, SqlFieldName = Special_Ward ];

/// 专科证书 
Property SpecialBook As %String [ SqlColumnNumber = 4, SqlFieldName = Special_Book ];

/// 认证单位 
Property SpecialDepart As %String [ SqlColumnNumber = 7, SqlFieldName = Special_Depart ];

/// 取得日期 
Property SpecialGetDate As %Date [ SqlColumnNumber = 8, SqlFieldName = Special_GetDate ];

/// 证书附件 
Property CertPic As list Of %String [ SqlColumnNumber = 9, SqlFieldName = Special_BookFile ];

/// 状态：Y-已提交  A-已审核  N-已保存  B-驳回
Property SpecialStatus As %String [ SqlColumnNumber = 5, SqlFieldName = Special_Status ];

Property SpecialUser As %String [ SqlColumnNumber = 6, SqlFieldName = Special_User ];

Index ssid On SpecialPerDR;

Storage Default
{
<Data name="MgSpecialDevelopDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SpecialPerDR</Value>
</Value>
<Value name="3">
<Value>SpecialWard</Value>
</Value>
<Value name="4">
<Value>SpecialBook</Value>
</Value>
<Value name="5">
<Value>SpecialDepart</Value>
</Value>
<Value name="6">
<Value>SpecialGetDate</Value>
</Value>
<Value name="7">
<Value>CertPic</Value>
</Value>
<Value name="8">
<Value>SpecialStatus</Value>
</Value>
<Value name="9">
<Value>SpecialUser</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgSpecialDevelopD</DataLocation>
<DefaultData>MgSpecialDevelopDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgSpecialDevelopD</IdLocation>
<IndexLocation>^DHCINM.HR.MgSpecialDevelopI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgSpecialDevelopS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
