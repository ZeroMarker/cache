/// 名称: DHCHAI.IR.CRuleMRBOEOrd
/// 描述: 多重耐药菌-隔离医嘱维护
/// 编写者：zhoubo
/// 编写日期: 2019-04-19
Class DHCHAI.IR.CRuleMRBOEOrd Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.CRuleMRB [ Cardinality = parent, Inverse = ChildOEOrds ];

/// 隔离医嘱
Property BTIsoOEOrdDr As DHCHAI.DP.OEItmMastMap [ Required ];

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 索引 细菌
Index IndexIsoOEOrd On BTIsoOEOrdDr;

Index IndexIsoOEOrd2 On (Parref, BTIsoOEOrdDr);

/// Creator：     zhoubo
/// CreatDate：   2019-04-19
/// Description:  根据ID取多重耐药菌-隔离医嘱维护信息
/// Table：       DHCHAI.IR.CRuleMRBOEOrd
/// Input：       aId : DHCHAI.IR.CRuleMRBOEOrd.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleMRBOEOrd).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleMRBOEOrd
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleMRBOEOrd).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleMRBOEOrd).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2019-04-19
/// Description:  更新多重耐药菌-隔离医嘱维护信息
/// Table：       DHCHAI.IR.CRuleMRBOEOrd
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleMRBOEOrd).Update("2^^4^^^9","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	 
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete = ..#SEPARATE	
	Set Parref		= $p(aInputStr,aSeparete,1)
	Set ChildSub	= $p(aInputStr,aSeparete,2)
	Set OEOrdDr	    = $p(aInputStr,aSeparete,3)
	Set ActDate		= $p(aInputStr,aSeparete,4)
	Set ActTime		= $p(aInputStr,aSeparete,5)
	Set ActUserDr	= $p(aInputStr,aSeparete,6)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	Quit:(Parref="")||(OEOrdDr="") return
	
	//隔离医嘱 不能重复
	Set tChildSub=$o(^DHCHAI.IR.CRuleMRBI("OEORD","IndexIsoOEOrd",OEOrdDr,Parref,0))
	Quit:(tChildSub'="")&&(tChildSub'=ChildSub) -2
		
	Set objParref = ##class(DHCHAI.IR.CRuleMRB).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objActUser = ##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	Quit:'$IsObject(objActUser) return
	Set objOEOrd = ##class(DHCHAI.DP.OEItmMastMap).GetObjById(OEOrdDr)
	Quit:'$IsObject(objOEOrd) return
	
	If ChildSub="" {
		Set obj=##class(DHCHAI.IR.CRuleMRBOEOrd).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleMRBOEOrd).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref		 = objParref
	Set obj.BTIsoOEOrdDr = objOEOrd
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

/// Creator：     zhoubo
/// CreatDate：   2019-04-19
/// Description:  删除多重耐药菌-隔离医嘱维护信息
/// Table：       DHCHAI.IR.CRuleMRBOEOrd
/// Input：       aId : DHCHAI.IR.CRuleMRBOEOrd.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleMRBOEOrd).DeleteById("1||1")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleMRBOEOrd).%DeleteId(aId)
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
<Data name="CRuleMRBOEOrdDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTIsoOEOrdDr</Value>
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
<DataLocation>{%%PARENT}("OEORD")</DataLocation>
<DefaultData>CRuleMRBOEOrdDefaultData</DefaultData>
<IdLocation>{%%PARENT}("OEORD")</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleMRBI("OEORD")</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleMRBOEOrdS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
