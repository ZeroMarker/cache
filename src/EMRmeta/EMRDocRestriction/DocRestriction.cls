/// 名称: 权限规则明细
/// 描述: 用于新框架模板权限
/// 编写者：chenwenjun
/// 编写日期: 09/07/28
Class EMRmeta.EMRDocRestriction.DocRestriction Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//模板组ID

Property GroupID As %String(TRUNCATE = 1);

//规则条件的项目ID组成的串(如 DEPT:10^PATTYPE:21^SEX:1)

Property RuleItemIDs As %String(TRUNCATE = 1);

Property RuleItemDesc As %String(MAXLEN = 1024, TRUNCATE = 1);

Index GroupIDIdx On GroupID;

Query SelectAll(parGroupID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,GroupID:%String,RuleItemIDs:%String,RuleItemNames:%String")
{
	SELECT ID,GroupID,RuleItemIDs,RuleItemDesc
	FROM EMRmeta_EMRDocRestriction.DocRestriction
	WHERE GroupID=:parGroupID ORDER BY ID
}

Storage Default
{
<Data name="DocRestrictionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupID</Value>
</Value>
<Value name="3">
<Value>RuleItemIDs</Value>
</Value>
<Value name="4">
<Value>RuleItemDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DocRes.DocRestrictionD</DataLocation>
<DefaultData>DocRestrictionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.DocRes.DocRestrictionD</IdLocation>
<IndexLocation>^DHCEMRM.DocRes.DocRestrictionI</IndexLocation>
<StreamLocation>^DHCEMRM.DocRes.DocRestrictionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
