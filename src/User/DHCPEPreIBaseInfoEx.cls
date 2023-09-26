Class User.DHCPEPreIBaseInfoEx Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_PreIBaseInfoEx ]
{

Parameter ClassName = "User.DHCPEPreIBaseInfoEx";

///  基本信息ID
Property BIEBaseInfoID As User.DHCPEPreIBaseInfo [ Required, SqlFieldName = BIE_BaseInfoID ];

///  既往史
Property BIEPastHistory As %String(MAXLEN = 200) [ SqlFieldName = BIE_PastHistory ];

///  家族史
Property BIEFamilyHistory As %String(MAXLEN = 200) [ SqlFieldName = BIE_FamilyHistory ];

///  吸烟史
Property BIESmokingHistory As list Of %String [ SqlFieldName = BIE_SmokingHistory ];

///  饮酒史
Property BIEDrinkingHistory As list Of %String [ SqlFieldName = BIE_DrinkingHistory ];

/// 月经史
Property BIEMenstrualHistory As list Of %String [ SqlFieldName = BIE_MenstrualHistory ];

///  生育史
Property BIEBearingHistory As list Of %String [ SqlFieldName = BIE_BearingHistory ];

///  婚姻史
Property BIEWeddingHistory As list Of %String(MAXLEN = 500) [ SqlFieldName = BIE_WeddingHistory ];

///  职业史
Property BIEOccupationalHistory As list Of %String(MAXLEN = 1000) [ SqlFieldName = BIE_OccupationalHistory ];

///  职业病史
Property BIEOccupationalDiseaseHistory As list Of %String(MAXLEN = 1000) [ SqlFieldName = BIE_OccupationalDiseaseHistory ];

///  主诉
Property BIEChiefComplaint As %String(MAXLEN = 200) [ SqlFieldName = BIE_ChiefComplaint ];

///  备注
Property BIERemark As %String(MAXLEN = 200) [ SqlFieldName = BIE_Remark ];

///  基本信息ID索引
Index BaseInfoID On BIEBaseInfoID As AlphaUp;

Storage Default
{
<Data name="DHCPEPreIBaseInfoExDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BIEBaseInfoID</Value>
</Value>
<Value name="3">
<Value>BIEPastHistory</Value>
</Value>
<Value name="4">
<Value>BIEFamilyHistory</Value>
</Value>
<Value name="5">
<Value>BIEBearingHistory</Value>
</Value>
<Value name="6">
<Value>BIESmokingHistory</Value>
</Value>
<Value name="7">
<Value>BIEDrinkingHistory</Value>
</Value>
<Value name="8">
<Value>BIEOccupationalDiseaseHistory</Value>
</Value>
<Value name="9">
<Value>BIEOccupationalHistory</Value>
</Value>
<Value name="10">
<Value>BIEChiefComplaint</Value>
</Value>
<Value name="11">
<Value>BIERemark</Value>
</Value>
<Value name="12">
<Value>BIEMenstrualHistory</Value>
</Value>
<Value name="13">
<Value>BIEWeddingHistory</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEPreIBaseInfoExD</DataLocation>
<DefaultData>DHCPEPreIBaseInfoExDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEPreIBaseInfoExD</IdLocation>
<IndexLocation>^User.DHCPEPreIBaseInfoExI</IndexLocation>
<StreamLocation>^User.DHCPEPreIBaseInfoExS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
