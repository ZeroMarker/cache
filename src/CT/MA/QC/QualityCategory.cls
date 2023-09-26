/// 名称:	CT.MA.QC.QualityCategory
/// 描述:	病历范畴维护
/// 编写者：hky
/// 编写日期: 2021-06-08
Class CT.MA.QC.QualityCategory Extends (%Persistent, User.Abstract)
{

Index IdxParentId On ParentId;

Property ParentId As %String(TRUNCATE = 1);

Property Name As %String(TRUNCATE = 1);

Property Score As %String(TRUNCATE = 1);

Property IsActive As %String(TRUNCATE = 1);

Property ResumeText As %String(TRUNCATE = 1);

Storage Default
{
<Data name="QualityCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ParentId</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Score</Value>
</Value>
<Value name="5">
<Value>IsActive</Value>
</Value>
<Value name="6">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^CT.MA.QC.QualityCategoryD</DataLocation>
<DefaultData>QualityCategoryDefaultData</DefaultData>
<IdLocation>^CT.MA.QC.QualityCategoryD</IdLocation>
<IndexLocation>^CT.MA.QC.QualityCategoryI</IndexLocation>
<StreamLocation>^CT.MA.QC.QualityCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
