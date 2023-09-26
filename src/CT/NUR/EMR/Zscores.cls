/// 名称:     Z值分数对照
/// 描述:     用于通过性别、年龄范围和体重来确定Z值【需求来源成都一院】
/// 编写者：  yaojining
/// 编写日期: 2022.6.15
/// 产品组：  护理
Class CT.NUR.EMR.Zscores Extends (%Persistent, User.Abstract) [ SqlTableName = Zscores ]
{

/// 性别
Property ZSSex As %String [ SqlColumnNumber = 2, SqlFieldName = ZS_Sex ];

/// 年龄范围
Property ZSAge As %String [ SqlColumnNumber = 3, SqlFieldName = ZS_Age ];

/// L
Property ZSL As %String [ SqlColumnNumber = 4, SqlFieldName = ZS_L ];

/// M
Property ZSM As %String [ SqlColumnNumber = 5, SqlFieldName = ZS_M ];

/// S
Property ZSS As %String [ SqlColumnNumber = 6, SqlFieldName = ZS_S ];

/// -3SD
Property ZSN3SD As %String [ SqlColumnNumber = 7, SqlFieldName = ZS_N3SD ];

/// -2SD
Property ZSN2SD As %String [ SqlColumnNumber = 8, SqlFieldName = ZS_N2SD ];

/// -1SD
Property ZSN1SD As %String [ SqlColumnNumber = 9, SqlFieldName = ZS_N1SD ];

/// 0SD
Property ZS0SD As %String [ SqlColumnNumber = 10, SqlFieldName = ZS_0SD ];

/// 1SD
Property ZSP1SD As %String [ SqlColumnNumber = 11, SqlFieldName = ZS_P1SD ];

/// 2SD
Property ZSP2SD As %String [ SqlColumnNumber = 12, SqlFieldName = ZS_P2SD ];

/// 3SD
Property ZSP3SD As %String [ SqlColumnNumber = 13, SqlFieldName = ZS_P3SD ];

Index SexAge On (ZSSex, ZSAge);

Storage Default
{
<Data name="ZscoresDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ZSSex</Value>
</Value>
<Value name="3">
<Value>ZSAge</Value>
</Value>
<Value name="4">
<Value>ZSL</Value>
</Value>
<Value name="5">
<Value>ZSM</Value>
</Value>
<Value name="6">
<Value>ZSS</Value>
</Value>
<Value name="7">
<Value>ZSN3SD</Value>
</Value>
<Value name="8">
<Value>ZSN2SD</Value>
</Value>
<Value name="9">
<Value>ZSN1SD</Value>
</Value>
<Value name="10">
<Value>ZS0SD</Value>
</Value>
<Value name="11">
<Value>ZSP1SD</Value>
</Value>
<Value name="12">
<Value>ZSP2SD</Value>
</Value>
<Value name="13">
<Value>ZSP3SD</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.EMR.ZscoresD</DataLocation>
<DefaultData>ZscoresDefaultData</DefaultData>
<IdLocation>^CT.NUR.EMR.ZscoresD</IdLocation>
<IndexLocation>^CT.NUR.EMR.ZscoresI</IndexLocation>
<StreamLocation>^CT.NUR.EMR.ZscoresS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
