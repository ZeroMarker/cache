/// Creator:赵文伟
/// CreatDate:2022-05-23
/// Description：手术关联科室字典表 
/// Table：CT.WDT.CDSS.OperJoinDept
Class CT.WDT.CDSS.OperJoinDept Extends (%Persistent, User.Abstract)
{

/// 手术 指向手术字典
Property OperationDR As CT.WDT.CDSS.OperationDict [ Required ];

/// 科室 指向科室字典
Property DiseaseDeptDR As CT.WDT.CDSS.DiseaseDeptDict [ Required ];

/// 手术分级[一级/二级/三级/四级]
Property OperationGrade As CT.WDT.CDSS.CommonDict;

/// 手术分类[一类/二类/三类/四类]
Property OperationCategory As %String;

Index OperationIndex On OperationDR;

Index DiseaseDeptIndex On DiseaseDeptDR;

Index OperatDeptIndex On (OperationDR, DiseaseDeptDR);

Storage Default
{
<Data name="OperJoinDeptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OperationDR</Value>
</Value>
<Value name="3">
<Value>DiseaseDeptDR</Value>
</Value>
<Value name="4">
<Value>OperationGrade</Value>
</Value>
<Value name="5">
<Value>OperationCategory</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.OperJoinDeptD</DataLocation>
<DefaultData>OperJoinDeptDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.OperJoinDeptD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.OperJoinDeptI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.OperJoinDeptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
