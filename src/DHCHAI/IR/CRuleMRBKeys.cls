/// 名称: DHCHAI.IR.CRuleMRBKeys
/// 描述: 多重耐药菌-关键字维护
/// 编写者：zhufei
/// 编写日期: 2017-03-15
Class DHCHAI.IR.CRuleMRBKeys Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.CRuleMRB [ Cardinality = parent, Inverse = ChildKeys ];

/// 关键词
Property BTKeyWord As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 索引 关键词
Index IndexKeyWord On BTKeyWord As Exact;

/// 索引 关键词
Index IndexKeyWord2 On (Parref, BTKeyWord As Exact);

/// Creator：     maxp
/// CreatDate：   2017-05-05
/// Description:  根据ID取多重耐药菌-关键字维护信息
/// Table：       DHCHAI.IR.CRuleMRBKeys
/// Input：       aId : DHCHAI.IR.CRuleMRBKeys.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleMRBKeys).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleMRBKeys
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleMRBKeys).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleMRBKeys).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     maxp
/// CreatDate：   2017-05-05
/// Description:  更新多重耐药菌-关键字维护信息
/// Table：       DHCHAI.IR.CRuleTSRstFlag
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleMRBKeys).Update("2^^4^^^9","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	 
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete = ..#SEPARATE	
	Set Parref		= $p(aInputStr,aSeparete,1)
	Set ChildSub	= $p(aInputStr,aSeparete,2)
	Set KeyWord		= $p(aInputStr,aSeparete,3)
	Set ActDate		= $p(aInputStr,aSeparete,4)
	Set ActTime		= $p(aInputStr,aSeparete,5)
	Set ActUserDr	= $p(aInputStr,aSeparete,6)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(Parref="")||(KeyWord="") return
	
	Set tChildSub =$o(^DHCHAI.IR.CRuleMRBI("KEYS","IndexKeyWord",KeyWord,Parref,0)) 
	Quit:(tChildSub'="")&&(ChildSub'=tChildSub) -2
	
	Set objParref=##class(DHCHAI.IR.CRuleMRB).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	Quit:'$IsObject(objActUser) return

	If ChildSub="" {
		Set obj=##class(DHCHAI.IR.CRuleMRBKeys).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleMRBKeys).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref		= objParref
	Set obj.BTKeyWord	= KeyWord
	Set obj.BTActDate	= ActDate	
	Set obj.BTActTime	= ActTime 
	Set obj.BTActUserDr	= objActUser	
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

/// Creator：     maxp
/// CreatDate：   2017-05-05
/// Description:  删除多重耐药菌-关键字维护信息
/// Table：       DHCHAI.IR.CRuleMRBKeys
/// Input：       aId : DHCHAI.IR.CRuleMRBKeys.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleMRBKeys).DeleteById("1||1")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleMRBKeys).%DeleteId(aId)
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
<Data name="CRuleMRBKeysDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTKeyWord</Value>
</Value>
<Value name="3">
<Value>BTActDate</Value>
</Value>
<Value name="4">
<Value>BTActTime</Value>
</Value>
<Value name="5">
<Value>BTActUserDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("KEYS")</DataLocation>
<DefaultData>CRuleMRBKeysDefaultData</DefaultData>
<IdLocation>{%%PARENT}("KEYS")</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleMRBI("KEYS")</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleMRBKeysS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
