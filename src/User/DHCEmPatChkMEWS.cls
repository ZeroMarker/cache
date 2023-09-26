/// MEWS评分主题
Class User.DHCEmPatChkMEWS Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHC_EmPatChkMEWS ]
{

/// 预检表 PCG_Chk_Dr
Property PCGChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 2, SqlFieldName = PCG_Chk_Dr ];

/// 心率得分
Property PCGMEWSHeart As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PCG_MEWS_Heart ];

/// 收缩压得分
Property PCGMEWSSbp As %Library.String [ SqlColumnNumber = 4, SqlFieldName = PCG_MEWS_Sbp ];

/// 呼吸频率得分
Property PCGMEWSBreathe As %Library.String [ SqlColumnNumber = 5, SqlFieldName = PCG_MEWS_Breathe ];

/// 体温得分
Property PCGMEWSTemp As %Library.String [ SqlColumnNumber = 6, SqlFieldName = PCG_MEWS_Temp ];

/// 意识得分
Property PCGMEWSAware As %Library.String [ SqlColumnNumber = 7, SqlFieldName = PCG_MEWS_Aware ];

/// 总体评级
Property PCGMEWSLevel As %Library.String [ SqlColumnNumber = 8, SqlFieldName = PCG_MEWS_Level ];

/// 激活标志
Property PCGMEWSActive As %Library.String [ SqlColumnNumber = 9, SqlFieldName = PCG_MEWS_Active ];

Storage Default
{
<Data name="DHCEmPatChkMEWSDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PCGChkDr</Value>
</Value>
<Value name="3">
<Value>PCGMEWSHeart</Value>
</Value>
<Value name="4">
<Value>PCGMEWSSbp</Value>
</Value>
<Value name="5">
<Value>PCGMEWSBreathe</Value>
</Value>
<Value name="6">
<Value>PCGMEWSTemp</Value>
</Value>
<Value name="7">
<Value>PCGMEWSAware</Value>
</Value>
<Value name="8">
<Value>PCGMEWSLevel</Value>
</Value>
<Value name="9">
<Value>PCGMEWSActive</Value>
</Value>
</Data>
<DataLocation>^User.DHCEmPatChkMEWSD</DataLocation>
<DefaultData>DHCEmPatChkMEWSDefaultData</DefaultData>
<IdLocation>^User.DHCEmPatChkMEWSD</IdLocation>
<IndexLocation>^User.DHCEmPatChkMEWSI</IndexLocation>
<StreamLocation>^User.DHCEmPatChkMEWSS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Index IndexChk On PCGChkDr;

}
