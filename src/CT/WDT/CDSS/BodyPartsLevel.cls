/// Creator:谷雪萍
/// CreatDate:2021-11-09
/// Description：部位层级表
/// Table：CT.WDT.CDSS.BodyPartsLevel
Class CT.WDT.CDSS.BodyPartsLevel Extends (%Persistent, User.Abstract)
{

/// 部位指针
Property BodyPartDR As CT.WDT.CDSS.BodyPartsDict;

/// 上级分类
Property BodyLastLevel As CT.WDT.CDSS.BodyPartsLevel;

/// 层级类型（系统/解剖）
Property LevelType As %String;

/// 使用标志0-编辑中，1-已弃用，2-已审核
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index LevelIndex On (LevelType As Exact, BodyLastLevel As Exact);

Index ParentIndex On BodyLastLevel;

Index BodyPartDRIndex On BodyPartDR;

Index BodyLastLevelIndex On (BodyPartDR As Exact, LevelType As Exact, BodyLastLevel As Exact);

Storage Default
{
<Data name="BodyPartsLevelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BodyPartDR</Value>
</Value>
<Value name="3">
<Value>BodyLastLevel</Value>
</Value>
<Value name="4">
<Value>LevelType</Value>
</Value>
<Value name="5">
<Value>UseFlag</Value>
</Value>
<Value name="6">
<Value>UpdateUser</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.BodyPartsLevelD</DataLocation>
<DefaultData>BodyPartsLevelDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.BodyPartsLevelD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.BodyPartsLevelI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.BodyPartsLevelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
