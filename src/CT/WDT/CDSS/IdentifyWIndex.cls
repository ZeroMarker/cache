/// Creator:丁亚男
/// CreatDate:2021-08-12
/// Description：识别词项目索引表
/// Table：CT_WDT_CDSS.IdentifyWIndex
Class CT.WDT.CDSS.IdentifyWIndex Extends (%Persistent, User.Abstract)
{

/// 识别词id
Property IdentifyWordsDR As CT.WDT.CDSS.IdentifyWords [ Required ];

/// 识别词项目
Property IdentifyWType As %String [ Required ];

/// 识别词名称
Property IdentifyWTypeName As %String(MAXLEN = "");

Index TypeIWIndex On (IdentifyWType As Exact, IdentifyWordsDR);

Index TypeNameIWIndex On (IdentifyWType As Exact, IdentifyWTypeName As Exact, IdentifyWordsDR);

Index WordsDRIndex On IdentifyWordsDR;

Storage Default
{
<Data name="IdentifyWIndexDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IdentifyWordsDR</Value>
</Value>
<Value name="3">
<Value>IdentifyWType</Value>
</Value>
<Value name="4">
<Value>IdentifyWTypeName</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.IdentifyWIndexD</DataLocation>
<DefaultData>IdentifyWIndexDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.IdentifyWIndexD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.IdentifyWIndexI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.IdentifyWIndexS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
