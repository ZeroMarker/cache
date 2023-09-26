/// Creator:李得原
/// CreatDate:2021-03-19
/// Description：评估表关联科室表
/// Table：CT.WDT.CDSS.AssConDept
Class CT.WDT.CDSS.AssConDept Extends (%Persistent, User.Abstract)
{

/// 评估表指针
Property AssDR As CT.WDT.CDSS.AssBase [ Required ];

/// 科室指针（疾病分科字典表）
Property DeptDR As CT.WDT.CDSS.DiseaseDeptDict [ Required ];

Index AssIndex On AssDR;

Index DeptIndex On DeptDR;

Index DeptAssIndex On (DeptDR, AssDR);

Storage Default
{
<Data name="AssConDeptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AssDR</Value>
</Value>
<Value name="3">
<Value>DeptDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.AssConDeptD</DataLocation>
<DefaultData>AssConDeptDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.AssConDeptD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.AssConDeptI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.AssConDeptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
