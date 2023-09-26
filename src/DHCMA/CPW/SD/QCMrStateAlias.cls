Class DHCMA.CPW.SD.QCMrStateAlias Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.SD.QCMrListState [ Cardinality = parent, Inverse = ChildAlias ];

/// 操作依据
Property OperRule As list Of DHCMA.CPW.SD.QCEntityMatchRule;

/// 操作备注
Property OperResume As %String(MAXLEN = 5000);

Index IndexParref On Parref;

/// w ##class(DHCMA.CPW.SD.QCMrStateAlias).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCMrStateAlias
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCMrStateAlias).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCMrStateAlias).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.QCMrStateAlias).Update("1742||2^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ParrefID		= $p(aInputStr,aSeparete,1)		
	Set OperRuleDr      = $p(aInputStr,aSeparete,2)
	Set OperResume   	= $p(aInputStr,aSeparete,3)
	Set obj=##class(DHCMA.CPW.SD.QCMrStateAlias).%New()
	Quit:'$IsObject(obj) return	
	Set obj.Parref		= ##class(DHCMA.CPW.SD.QCMrListState).GetObjById(ParrefID)
	Set OperRuleLB=$lb("")
	For ind=1:1:$length(OperRuleDr,"&") {
		Set OperRuleIndID=$p(OperRuleDr,"&",ind)
		Continue:($listfind(OperRuleLB,OperRuleIndID)>0)
		Set OperRuleLB=OperRuleLB_$lb(OperRuleIndID)
		Set OperRuleObj=##class(DHCMA.CPW.SD.QCEntityMatchRule).GetObjById(OperRuleIndID)
		Continue:'$IsObject(OperRuleObj)
		Do obj.OperRule.Insert(OperRuleObj)
	}
	Set obj.OperResume	= OperResume
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {        //检查Save是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	Quit return
}

Storage Default
{
<Data name="QCMrStateAliasDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OperRule</Value>
</Value>
<Value name="3">
<Value>OperResume</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildAlias")</DataLocation>
<DefaultData>QCMrStateAliasDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildAlias")</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCMrStateAliasI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCMrStateAliasS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
