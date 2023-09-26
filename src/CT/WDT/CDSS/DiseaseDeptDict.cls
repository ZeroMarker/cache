/// Creator:丁亚男
/// CreatDate:2020-08-06
/// Description：疾病分科字典表
/// Table：CT.WDT.CDSS.DiseaseDeptDict
Class CT.WDT.CDSS.DiseaseDeptDict Extends (%Persistent, User.Abstract)
{

/// 科室编码
Property DeptCode As %String [ Required ];

/// 科室名称
Property DeptName As %String;

/// 父级科室
Property FatherCodeDR As CT.WDT.CDSS.DiseaseDeptDict;

/// 科室分级（1 一级，2 二级，3 三级）
Property DeptGrade As %Integer;

/// 科室分类
Property DeptClass As %String;

/// 状态（0编辑中，1已弃用，2已审核）
Property UseFlag As %String;

/// 创建时间
Property CreateDate As %TimeStamp;

/// 创建人员
Property CreateUserID As %String;

/// 备注
Property Remarks As %String(MAXLEN = "");

/// 别名
Property DeptAlias As %String;

Index CodeIndex On DeptCode [ Unique ];

Index NameIndex On DeptName;

Index ParentIndex On FatherCodeDR;

Index CreateDateIndex On CreateDate;

Storage Default
{
<Data name="DiseaseDeptDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DeptCode</Value>
</Value>
<Value name="3">
<Value>DeptName</Value>
</Value>
<Value name="4">
<Value>FatherCodeDR</Value>
</Value>
<Value name="5">
<Value>DeptGrade</Value>
</Value>
<Value name="6">
<Value>DeptClass</Value>
</Value>
<Value name="7">
<Value>UseFlag</Value>
</Value>
<Value name="8">
<Value>CreateDate</Value>
</Value>
<Value name="9">
<Value>CreateUserID</Value>
</Value>
<Value name="10">
<Value>Remarks</Value>
</Value>
<Value name="11">
<Value>DeptAlias</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.DiseaseDeptDictD</DataLocation>
<DefaultData>DiseaseDeptDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.DiseaseDeptDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.DiseaseDeptDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.DiseaseDeptDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
