/// Creator:谷雪萍
/// CreatDate:2021-11-10
/// Description：方位词字典表
/// Table：CT_WDT_CDSS.PositionWord
Class CT.WDT.CDSS.PositionWord Extends (%Persistent, User.Abstract)
{

/// 方位词代码（自动生成）
Property PositionCode As %String;

/// 方位词描述
Property PositionDesc As %String(MAXLEN = "");

/// 分类（单纯方位词/特殊方位词/合成方位词）
Property PositionType As %String;

/// 状态0-编辑中，1-已弃用，2-已审核
Property UseFlag As %Integer;

/// 编辑人员
Property UpdateUser As %String;

/// 编辑时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property PositionAlias As %String;

Index CodeIndex On PositionCode;

Index DescIndex On PositionDesc;

Index UpdateDateIndex On UpdateDate;

Storage Default
{
<Data name="PositionWordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PositionCode</Value>
</Value>
<Value name="3">
<Value>PositionDesc</Value>
</Value>
<Value name="4">
<Value>PositionType</Value>
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
<Value name="9">
<Value>PositionAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.PositionWordD</DataLocation>
<DefaultData>PositionWordDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.PositionWordD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.PositionWordI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.PositionWordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
