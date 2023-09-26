/// 名称: DHCMA.CPW.SD.QCItemValidRule
/// 描述: 质控单病种项目检验规则
/// 编写者：zhugz
/// 编写日期: 2020-04-01
Class DHCMA.CPW.SD.QCItemValidRule Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.SD.QCEntityItem [ Cardinality = parent, Inverse = ChildValid ];

/// 校验级别(info,warning,error,stop)
Property RuleType As %String;

/// 校验函数
Property RuleFunction As DHCMA.CPW.SD.QCExpress;

/// 校验表达式
Property RuleExpress As %String(MAXLEN = 1000);

/// 提示内容
Property RuleContent As %String(MAXLEN = 1000);

/// w ##class(DHCMA.CPW.SD.QCItemValidRule).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCItemValidRule
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCItemValidRule).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCItemValidRule).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.QCItemValidRule).Update("")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref           = $p(aInputStr,aSeparete,1)
	Set ID            	 = $p(aInputStr,aSeparete,2)
	Set RuleType         = $p(aInputStr,aSeparete,3)
	Set QCExpressDr      = $p(aInputStr,aSeparete,4)
	Set RuleExpress      = $p(aInputStr,aSeparete,5)
	Set RuleContent      = $p(aInputStr,aSeparete,6)
	
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.QCItemValidRule).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.QCItemValidRule).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref        = ##class(DHCMA.CPW.SD.QCEntityItem).GetObjById(Parref)
	Set obj.RuleType      = RuleType
	Set obj.RuleFunction  = ##class(DHCMA.CPW.SD.QCExpress).GetObjById(QCExpressDr)
	Set obj.RuleExpress   = RuleExpress
	Set obj.RuleContent   = RuleContent
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

/// w ##class(DHCMA.CPW.SD.QCItemValidRule).DeleteById(6)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	
	Set Flg = ##class(DHCMA.Util.BT.DeleteControl).GetAllowDel("DHCMA.CPW.SD.QCItemValidRule")
	Quit:Flg'=1 -777
	
	Set sc = ##class(DHCMA.CPW.SD.QCItemValidRule).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

Storage Default
{
<Data name="QCItemValidRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleType</Value>
</Value>
<Value name="3">
<Value>RuleFunction</Value>
</Value>
<Value name="4">
<Value>RuleExpress</Value>
</Value>
<Value name="5">
<Value>RuleContent</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Rule")</DataLocation>
<DefaultData>QCItemValidRuleDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Rule")</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCItemValidRuleI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCItemValidRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
