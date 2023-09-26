/// 名称: DHCMA.IMP.BT.IMPCateRules
/// 描述: 重点患者判断规则
/// 编写者：fcz
/// 编写日期: 2020-5-15
Class DHCMA.IMP.BT.IMPCateRules Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.IMP.BT.IMPCategory [ Cardinality = parent, Inverse = ChildRules ];

/// 规则代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 规则描述
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 规则函数
Property BTExpress As %String(MAXLEN = 500, TRUNCATE = 1);

/// 规则类型（"IMPRuleType" 筛查规则、排除条件）
Property BTTypeDr As DHCMA.Util.BT.Dictionary;

/// 是否有效
Property BTIsActive As %Boolean;

/// 操作日期
Property BTActDate As %Date;

/// 操作时间
Property BTActTime As %Time;

/// 操作人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String(MAXLEN = 50, TRUNCATE = 1);

/// 规则类型 索引
Index IdxOfType On BTTypeDr;

/// 规则代码 索引
Index IdxOfCode On BTCode;

/// Creator：     zhangdc
/// CreatDate：   2020-05-19
/// Description:  根据ID取重点患者判断规则信息
/// Table：       DHCMA.IMP.BT.IMPCateRules
/// Input：       aId : DHCMA.IMP.BT.IMPCateRules.ID
/// Return：      返回obj
/// w ##class(DHCMA.IMP.BT.IMPCateRules).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.IMP.BT.IMPCateRules
{
	New (aId)
	Quit:'##class(DHCMA.IMP.BT.IMPCateRules).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.IMP.BT.IMPCateRules).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhangdc
/// CreatDate：   2020-05-19
/// Description:  更新重点患者判断规则信息
/// Table：       DHCMA.IMP.BT.IMPCateRules
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.IMPCateRules).Update("12^^test^测试^5555^201^11^1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref		      		= $p(aInputStr,aSeparete,1)
	set ChildSub     			= $p(aInputStr,aSeparete,2)
	Set Code                  	= $p(aInputStr,aSeparete,3)
	Set Desc                  	= $p(aInputStr,aSeparete,4)
	Set Express                 = $p(aInputStr,aSeparete,5)
	Set TypeDr                  = $p(aInputStr,aSeparete,6)
	Set BTIsActive   			= +$p(aInputStr,aSeparete,7)
	Set BTActDate    			= $p(aInputStr,aSeparete,8)
	Set BTActTime    			= $p(aInputStr,aSeparete,9)
	Set BTActUserID  			= $p(aInputStr,aSeparete,10)
	Quit:(Code="")||(Desc="") return
	
	Set:BTActDate'="" BTActDate = ##class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(BTActDate)
	Set:BTActTime[":" BTActTime = $zth(BTActTime,1)
	Set:BTActDate="" BTActDate=+$h
	Set:BTActTime="" BTActTime=+$p($h,",",2)

	Quit:(Parref="") -1
	Set objParref=##class(DHCMA.IMP.BT.IMPCategory).GetObjById(Parref)
	Quit:('$Isobject(objParref)) return
	
	If ChildSub="" {
		Set obj=##class(DHCMA.IMP.BT.IMPCateRules).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCMA.IMP.BT.IMPCateRules).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	set obj.Parref       	= objParref
	Set obj.BTCode       	= Code
	Set obj.BTDesc       	= Desc
	Set obj.BTExpress     	= Express
	Set obj.BTTypeDr      	= ##class(DHCMA.Util.BT.Dictionary).GetObjById(TypeDr)
	Set obj.BTIsActive	 	= BTIsActive
	Set obj.BTActDate    	= BTActDate
	Set obj.BTActTime    	= BTActTime
	Set obj.BTActUserID  	= BTActUserID
	
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

/// Creator：     zhangdc
/// CreatDate：   2020-05-19
/// Description:  删除重点患者判断规则信息
/// Table：       DHCMA.IMP.BT.IMPCateRules
/// Input：       aId : DHCMA.IMP.BT.IMPCateRules.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.IMP.BT.IMPCateRules).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.IMP.BT.IMPCateRules).%DeleteId(aId)
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
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTExpress</Value>
</Value>
<Value name="5">
<Value>BTTypeDr</Value>
</Value>
<Value name="6">
<Value>BTIsActive</Value>
</Value>
<Value name="7">
<Value>BTActDate</Value>
</Value>
<Value name="8">
<Value>BTActTime</Value>
</Value>
<Value name="9">
<Value>BTActUserID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Rules")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("Rules")</IdLocation>
<IndexLocation>^CT.MA.IMP.BTIMPCategoryI("Rules")</IndexLocation>
<StreamLocation>^CT.MA.IMP.BTIMPCateRulesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
