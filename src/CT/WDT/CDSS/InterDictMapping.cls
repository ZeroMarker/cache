/// Creator:钟荣枫
/// CreatDate:2020-06-15
/// Description：实施综合管理平台-字典对照表
/// Table：CT.WDT.CDSS.InterDictMapping
Class CT.WDT.CDSS.InterDictMapping Extends (%Persistent, User.Abstract)
{

/// 对接方字典分类
Property DictMapType As CT.WDT.CDSS.ConClassDict [ Required ];

/// CDSS字典代码
Property DictCode As %String(MAXLEN = "");

/// CDSS字典描述
Property DictDesc As %String(MAXLEN = "");

/// 对接方字典代码
Property IntDictCode As %String(MAXLEN = "");

/// 对接方字典描述
Property IntDictDesc As %String(MAXLEN = "");

/// 所属医院
Property DictHosp As CT.WDT.CDSS.CustomerHosp [ Required ];

/// 是否已对照（0已对照，1未对照））	//暂时不用
Property MatchFlag As %Integer;

/// 使用标志(0在用，1停用)
Property UseFlag As %Integer;

/// 备注
Property Remarks As %String;

/// CDSS字典DR	2021-5-13 zrf 增加知识库id和对接方id，以确定唯一
Property DictDR As %String [ Required ];

/// 对接方字典DR
Property IntDictDR As %String [ Required ];

Index UniqueIndex On (DictMapType As Exact, DictHosp As Exact, DictDR As Exact, IntDictDR As Exact);

Index IntDictDRIndex On (DictMapType As Exact, DictHosp As Exact, IntDictDR As Exact);

Index IntDictDescIndex On (DictMapType As Exact, DictHosp As Exact, IntDictDesc As Exact);

Index IntDictCodeIndex On (DictMapType As Exact, DictHosp As Exact, IntDictCode As Exact);

Index DictDescIndex On (DictMapType As Exact, DictHosp As Exact, DictDesc As Exact);

Index DictCodeIndex On (DictMapType As Exact, DictHosp As Exact, DictCode As Exact);

Index DictDRIndex On (DictMapType As Exact, DictHosp As Exact, DictDR As Exact);

Storage Default
{
<Data name="InterDictMappingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DictMapType</Value>
</Value>
<Value name="3">
<Value>DictCode</Value>
</Value>
<Value name="4">
<Value>DictDesc</Value>
</Value>
<Value name="5">
<Value>IntDictCode</Value>
</Value>
<Value name="6">
<Value>IntDictDesc</Value>
</Value>
<Value name="7">
<Value>DictHosp</Value>
</Value>
<Value name="8">
<Value>MatchFlag</Value>
</Value>
<Value name="9">
<Value>UseFlag</Value>
</Value>
<Value name="10">
<Value>Remarks</Value>
</Value>
<Value name="11">
<Value>DictDR</Value>
</Value>
<Value name="12">
<Value>IntDictDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.InterDictMappingD</DataLocation>
<DefaultData>InterDictMappingDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.InterDictMappingD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.InterDictMappingI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.InterDictMappingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
