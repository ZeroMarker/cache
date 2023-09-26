Class DHCMA.CPW.SD.QCEntityMatchRule Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.SD.QCEntity [ Cardinality = parent, Inverse = ChildRule ];

/// 规则类型（1-准入  2-排除）
Property RuleType As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 规则名称
Property RuleDesc As %String(MAXLEN = 1000, TRUNCATE = 1) [ Required ];

/// 规则函数
Property RuleMethod As DHCMA.CPW.SD.QCExpress;

/// 规则参数
Property RuleParam As %String(MAXLEN = 1000);

/// 序号
Property IndNo As %String;

/// 是否有效
Property IsActive As %Boolean;

/// 关键字参数
Property RuleKey As %String(MAXLEN = 10000);

Index IndexParref On Parref;

/// 规则描述索引，处理重复规则导入
Index IndexPDesc On (Parref, RuleDesc As Exact);

/// w ##class(DHCMA.CPW.SD.QCEntityMatchRule).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.SD.QCEntityMatchRule
{
	New (aId)
	Quit:'##class(DHCMA.CPW.SD.QCEntityMatchRule).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.SD.QCEntityMatchRule).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// w ##class(DHCMA.CPW.SD.QCEntityMatchRule).Update("7^^2^出生28天的新生儿肺炎^^^9^1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return		
	Set:$g(aSeparete)="" aSeparete="^"
	Set ParrefId		 = $p(aInputStr,aSeparete,1)
	Set ID               = $p(aInputStr,aSeparete,2)	
	Set RuleType         = $p(aInputStr,aSeparete,3)
	Set RuleDesc         = $p(aInputStr,aSeparete,4)
	Set RuleMethod       = $p(aInputStr,aSeparete,5)	
	Set RuleParam        = $p(aInputStr,aSeparete,6)
	Set IndNo            = $p(aInputStr,aSeparete,7)
	Set IsActive         = $p(aInputStr,aSeparete,8)
	Set RuleKey          = $p(aInputStr,aSeparete,9)
	if (ID="") {
			Set SubID=$o(^DHCMA.CPW.SD.QCEntityMatchRuleI("IndexPDesc",ParrefId,RuleDesc,""))
			Set:SubID'="" ID=ParrefId_"||"_SubID
		}
	If ID="" {
		Set obj=##class(DHCMA.CPW.SD.QCEntityMatchRule).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.SD.QCEntityMatchRule).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.Parref        		= ##class(DHCMA.CPW.SD.QCEntity).GetObjById(ParrefId)
	Set obj.RuleType        	= RuleType
	Set obj.RuleDesc        	= RuleDesc	
	Set obj.RuleMethod   		= ##class(DHCMA.CPW.SD.QCExpress).GetObjById(RuleMethod)
	Set obj.RuleParam    		= RuleParam
	Set obj.IndNo				= IndNo
	Set obj.IsActive			= IsActive
	//入组关键字 add by zgz 2020-3-18	
	Set obj.RuleKey				= RuleKey
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

/// w ##class(DHCMA.CPW.SD.QCEntityMatchRule).DeleteById(6)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.SD.QCEntityMatchRule).%DeleteId(aId)
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
<Data name="QCEntityMatchRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleType</Value>
</Value>
<Value name="3">
<Value>RuleDesc</Value>
</Value>
<Value name="4">
<Value>RuleMethod</Value>
</Value>
<Value name="5">
<Value>RuleParam</Value>
</Value>
<Value name="6">
<Value>IndNo</Value>
</Value>
<Value name="7">
<Value>IsActive</Value>
</Value>
<Value name="8">
<Value>RuleKey</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildRule")</DataLocation>
<DefaultData>QCEntityMatchRuleDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildRule")</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCEntityMatchRuleI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCEntityMat63A8S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
