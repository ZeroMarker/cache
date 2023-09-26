/// Creator:高姗姗
/// CreatDate:2020-12-17
/// Description：文献关联科室表
/// Table：CT.WDT.CDSS.DocuJoinDept
Class CT.WDT.CDSS.DocuJoinDept Extends (%Persistent, User.Abstract)
{

/// 文献指向 文献管理表
Property DocuDR As CT.WDT.CDSS.DocuManage [ Required ];

/// 科室指向 疾病分科字典表
Property DeptDR As CT.WDT.CDSS.DiseaseDeptDict [ Required ];

Index DocuIndex On DocuDR;

Index DocuDeptIndex On (DocuDR, DeptDR);

Index DeptDocuIndex On (DeptDR, DocuDR);

Storage Default
{
<Data name="DocuJoinDeptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocuDR</Value>
</Value>
<Value name="3">
<Value>DeptDR</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DocuJoinDeptD</DataLocation>
<DefaultData>DocuJoinDeptDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DocuJoinDeptD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DocuJoinDeptI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DocuJoinDeptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
