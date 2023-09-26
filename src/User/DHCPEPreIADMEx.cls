Class User.DHCPEPreIADMEx Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_PreIADMEx ]
{

Parameter ClassName = "User.DHCPEPreIADMEx";

///  预约ID
Property PIEPreIADMID As User.DHCPEPreIADM [ Required, SqlFieldName = PIE_PreIADMID ];

///  检查种类
Property PIEOMETTypeID As User.DHCPEOMEType [ SqlFieldName = PIE_OMETTypeID ];

///  工号
Property PIEJobNumber As %String(MAXLEN = 20) [ SqlFieldName = PIE_JobNumber ];

///  总工龄 年
Property PIEWorkAgeY As %Integer [ SqlFieldName = PIE_WorkAgeY ];

///  总工龄 月
Property PIEWorkAgeM As %Integer [ SqlFieldName = PIE_WorkAgeM ];

///  行业
Property PIEIndustryID As User.DHCPEIndustry [ SqlFieldName = PIE_IndustryID ];

///  工种
Property PIEWorkTypeID As User.DHCPEWorkType [ SqlFieldName = PIE_WorkTypeID ];

///  危害因素
Property PIEEndangers As list Of %String [ SqlFieldName = PIE_Endangers ];

///  备注
Property PIERemark As %String(MAXLEN = 200) [ SqlFieldName = PIE_Remark ];

///  接害年龄 年
Property PIEEndangerWorkAgeY As %Integer [ SqlFieldName = PIE_EndangerWorkAgeY ];

///  接害年龄 月
Property PIEEndangerWorkAgeM As %Integer [ SqlFieldName = PIE_EndangerWorkAgeM ];

///  症状
Property PIESymptom As list Of %String(MAXLEN = 2048) [ SqlFieldName = PIE_Symptom ];

///  其他工种
Property PIEOthWorkType As %String(MAXLEN = 32) [ SqlFieldName = PIE_OthWorkType ];

///  预约ID索引
Index PreIADMID On PIEPreIADMID As AlphaUp;

Storage Default
{
<Data name="DHCPEPreIADMExDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PIEPreIADMID</Value>
</Value>
<Value name="3">
<Value>PIEOMETTypeID</Value>
</Value>
<Value name="4">
<Value>PIEJobNumber</Value>
</Value>
<Value name="5">
<Value>PIEWorkAgeY</Value>
</Value>
<Value name="6">
<Value>PIEWorkAgeM</Value>
</Value>
<Value name="7">
<Value>PIEIndustryID</Value>
</Value>
<Value name="8">
<Value>PIEWorkTypeID</Value>
</Value>
<Value name="9">
<Value>PIEEndangers</Value>
</Value>
<Value name="10">
<Value>PIERemark</Value>
</Value>
<Value name="11">
<Value>PIEEndangerWorkAgeY</Value>
</Value>
<Value name="12">
<Value>PIEEndangerWorkAgeM</Value>
</Value>
<Value name="13">
<Value>PIESymptom</Value>
</Value>
<Value name="14">
<Value>PIEOthWorkType</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEPreIADMExD</DataLocation>
<DefaultData>DHCPEPreIADMExDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEPreIADMExD</IdLocation>
<IndexLocation>^User.DHCPEPreIADMExI</IndexLocation>
<StreamLocation>^User.DHCPEPreIADMExS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
