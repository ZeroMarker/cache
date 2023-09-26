/// Creator:谷雪萍
/// CreatDate:2023-05-06
/// Description：知识库检验医嘱和检验项目关联表
/// Table：CT_WDT_CDSS.LabConItemDict
Class CT.WDT.CDSS.LabConItemDict Extends (%Persistent, User.Abstract)
{

/// 检验医嘱ID
Property LabOrderDR As CT.WDT.CDSS.LabOrdersDict [ Required ];

/// 检验项目ID
Property LabItemDR As CT.WDT.CDSS.LabInspectionDict [ Required ];

/// 检验医嘱状态（0或空-已关联，1-已确认）
Property LabOrderUseFlag As %Integer;

/// 检验项目状态（0或空-已关联，1-已确认）
Property LabItemUseFlag As %Integer;

/// 操作人员
Property UpdateUser As %String;

/// 操作时间
Property UpdateDate As %TimeStamp;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index UniqueIndex On (LabOrderDR, LabItemDR) [ Unique ];

Index LabOrderIndex On LabOrderDR;

Index LabItemDRIndex On LabItemDR;

Storage Default
{
<Data name="LabConItemDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LabOrderDR</Value>
</Value>
<Value name="3">
<Value>LabItemDR</Value>
</Value>
<Value name="4">
<Value>LabOrderUseFlag</Value>
</Value>
<Value name="5">
<Value>LabItemUseFlag</Value>
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
<DataLocation>^CT.WDT.CDSS.LabConItemDictD</DataLocation>
<DefaultData>LabConItemDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.LabConItemDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.LabConItemDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.LabConItemDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
