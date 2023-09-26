Class web.DHCQCCalRules Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      DaiYi
/// CreatDate：    20120314
/// Description:： 根据点计算质控规则
/// Table：        DHCQC_ItemValue:质控项目结果,DHCQCMat_Rul:质控物项目规则
/// Input：        RowId:质量结果RowId.
/// Output：       SQLCODE
/// Return：       0
/// Others：
/// d ##class(web.DHCQCCalRules).AddQCRule("AC1500||63400||9001||A1130||1^63400^1","MEDDATA","WEBSRC")
ClassMethod AddQCRule(RowId As %String, HISNameSpace, HISAPPNameSpace) As %String
{
	Set RowId=$Get(RowId)
	Set Ret=0
	//ZN HISNameSpace
	//Set Ret=$$QcRules^DHCLabQCRules(RowId)
	//ZN HISAPPNameSpace
	s Ret=##class(web.DHCQCRules).QcRules(RowId)
	Quit Ret
}

Storage Default
{
<Data name="DHCQCCalRulesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCQCCalRulesD</DataLocation>
<DefaultData>DHCQCCalRulesDefaultData</DefaultData>
<IdLocation>^web.DHCQCCalRulesD</IdLocation>
<IndexLocation>^web.DHCQCCalRulesI</IndexLocation>
<StreamLocation>^web.DHCQCCalRulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
