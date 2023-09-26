Class User.DHCPEGSIllness Extends %Persistent [ SqlTableName = DHC_PE_GSIllness ]
{

Property GSIParref As User.DHCPEGeneralSummarize [ SqlFieldName = GSI_Parref ];

///  疾病
Property GSIIllndessDR As User.DHCPEIllnessStandard [ Required, SqlFieldName = GSI_IllndessDR ];

///  Type:自动关联 S，总检医生 D
Property GSIType As %String [ SqlFieldName = GSI_Type ];

///  操作人
Property GSIUserDR As User.SSUser [ SqlFieldName = GSI_UserDR ];

///  更新日期
Property GSIUpdateDate As %Library.Date [ SqlFieldName = GSI_UpdateDate ];

///  更新时间
Property GSIUpdateTime As %Library.Time [ SqlFieldName = GSD_UpdateTime ];

/// 状态：0正常   2删除  
Property GSIStatus As %String(MAXLEN = 1) [ SqlFieldName = GSI_Status ];

Index IndexParref On GSIParref;

Index IndexParrefStaIll On (GSIParref, GSIStatus, GSIIllndessDR);

Storage Default
{
<Data name="DHCPEGSIllnessDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GSIParref</Value>
</Value>
<Value name="3">
<Value>GSIIllndessDR</Value>
</Value>
<Value name="4">
<Value>GSIType</Value>
</Value>
<Value name="5">
<Value>GSIUserDR</Value>
</Value>
<Value name="6">
<Value>GSIUpdateDate</Value>
</Value>
<Value name="7">
<Value>GSIUpdateTime</Value>
</Value>
<Value name="8">
<Value>GSIStatus</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEGSIllnessD</DataLocation>
<DefaultData>DHCPEGSIllnessDefaultData</DefaultData>
<IdLocation>^User.DHCPEGSIllnessD</IdLocation>
<IndexLocation>^User.DHCPEGSIllnessI</IndexLocation>
<StreamLocation>^User.DHCPEGSIllnessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
