/// Creator:丁亚男
/// CreatDate:2020-08-06
/// Description：疾病关联科室表
/// Table：CT.WDT.CDSS.DiseJoinDept
Class CT.WDT.CDSS.DiseJoinDept Extends (%Persistent, User.Abstract)
{

/// 疾病表DR
Property DiseaseDR As CT.WDT.CDSS.DiseaseDict [ Required ];

/// 科室DR
Property DeptCodeDR As CT.WDT.CDSS.DiseaseDeptDict [ Required ];

/// 主属科室标记（0是、1否）
Property FirstDeptFlag As %Integer;

/// 创建时间
Property CreateDate As %TimeStamp;

/// 创建人员
Property CreateUserID As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

Index DiseaseDRIndex On DiseaseDR;

Index DeptCodeDRIndex On (DiseaseDR, DeptCodeDR As Exact);

Index DeptDRIndex On DeptCodeDR;

Storage Default
{
<Data name="DiseJoinDeptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DiseaseDR</Value>
</Value>
<Value name="3">
<Value>DeptCodeDR</Value>
</Value>
<Value name="4">
<Value>FirstDeptFlag</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateUserID</Value>
</Value>
<Value name="7">
<Value>Remarks</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DiseJoinDeptD</DataLocation>
<DefaultData>DiseJoinDeptDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DiseJoinDeptD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DiseJoinDeptI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DiseJoinDeptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
