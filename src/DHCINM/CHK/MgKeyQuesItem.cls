/// Creater:lulin
/// Descriptions:重点问题子表
/// Date:2021-12-26
Class DHCINM.CHK.MgKeyQuesItem Extends %Persistent
{

/// 描述
Property ItemDesc As %String(MAXLEN = 500) [ SqlColumnNumber = 2, SqlFieldName = ItemDesc ];

/// 制度分析
Property AnalyseP As %String(MAXLEN = 500) [ SqlColumnNumber = 3, SqlFieldName = AnalyseP ];

/// 培训分析
Property AnalyseT As %String(MAXLEN = 500) [ SqlColumnNumber = 4, SqlFieldName = AnalyseT ];

/// 制度意见
Property PoinionP As %String(MAXLEN = 500) [ SqlColumnNumber = 5, SqlFieldName = PoinionP ];

/// 培训意见
Property PoinionT As %String(MAXLEN = 500) [ SqlColumnNumber = 6, SqlFieldName = PoinionT ];

/// indexlib
Property indexLibDR As %String [ SqlColumnNumber = 7, SqlFieldName = indexLibDR ];

/// quesDR
Property KeyQuesDR As DHCINM.CHK.MgKeyQues [ SqlColumnNumber = 8, SqlFieldName = KeyQuesDR ];

Index indexLib On indexLibDR;

Index KeyQuesDR On KeyQuesDR;

Index Keyindex On (KeyQuesDR, indexLibDR);

Storage Default
{
<Data name="MgKeyQuesItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ItemDesc</Value>
</Value>
<Value name="3">
<Value>AnalyseP</Value>
</Value>
<Value name="4">
<Value>AnalyseT</Value>
</Value>
<Value name="5">
<Value>PoinionP</Value>
</Value>
<Value name="6">
<Value>PoinionT</Value>
</Value>
<Value name="7">
<Value>indexLibDR</Value>
</Value>
<Value name="8">
<Value>KeyQuesDR</Value>
</Value>
</Data>
<DataLocation>^DHCINM.CHK.MgKeyQuesItemD</DataLocation>
<DefaultData>MgKeyQuesItemDefaultData</DefaultData>
<IdLocation>^DHCINM.CHK.MgKeyQuesItemD</IdLocation>
<IndexLocation>^DHCINM.CHK.MgKeyQuesItemI</IndexLocation>
<StreamLocation>^DHCINM.CHK.MgKeyQuesItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
