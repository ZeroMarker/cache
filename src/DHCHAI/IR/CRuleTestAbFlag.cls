/// 名称: DHCHAI.IR.CRuleTestAbFlag
/// 描述: 常规检验-异常标志维护
/// 编写者：zhufei
/// 编写日期: 2017-03-15
Class DHCHAI.IR.CRuleTestAbFlag Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.CRuleTestAb [ Cardinality = parent, Inverse = ChildTRF ];

/// 异常标志
Property BTAbFlagDr As DHCHAI.DP.LabTCMapAb [ Required ];

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人
Property BTActUserDr As DHCHAI.BT.SysUser;

Index IdxofAbFlagDr On BTAbFlagDr;

Index IdxofAbFlagDr2 On (Parref, BTAbFlagDr);

/// Creator：     pylian
/// CreatDate：   2017-05-05
/// Description:  根据ID取常规检验-异常标志维护信息
/// Table：       DHCHAI.IR.CRuleTestAbFlag
/// Input：       aId : DHCHAI.IR.CRuleTestAbFlag.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleTestAbFlag).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleTestAbFlag
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleTestAbFlag).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleTestAbFlag).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2017-05-05
/// Description:  更新常规检验-异常标志维护信息
/// Table：       DHCHAI.IR.CRuleTestAbFlag
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleTestAbFlag).Update("2^^1^^^9","^")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	 
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete=..#SEPARATE	
	Set Parref        = $p(aInputStr,aSeparete,1)
	Set ChildSub      = $p(aInputStr,aSeparete,2)
	Set AbFlagDr      = $p(aInputStr,aSeparete,3)
	Set ActDate	      = $p(aInputStr,aSeparete,4)
	Set ActTime       = $p(aInputStr,aSeparete,5)
	Set ActUserDr     = $p(aInputStr,aSeparete,6)
	Quit:(Parref="")||(AbFlagDr="") return
	//Quit:(ChildSub="")&&($d(^DHCHAI.IR.CRuleTestAbI("TRF","IdxofAbFlagDr",AbFlagDr))) -2	

	//异常标志唯一
	Set tChildSub =$o(^DHCHAI.IR.CRuleTestAbI("TRF","IdxofAbFlagDr",AbFlagDr,Parref,0)) 
	Quit:(ChildSub="")&&(tChildSub'="") -2  
	Quit:(ChildSub'="")&(tChildSub'="")&(ChildSub'=tChildSub) -2  
	
	Set objParref=##class(DHCHAI.IR.CRuleTestAb).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	Quit:'$IsObject(objActUser) return
	Set objTestRstFlag=##class(DHCHAI.DP.LabTCMapAb).GetObjById(AbFlagDr)
	Quit:'$IsObject(objTestRstFlag) return
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActTime[":" ActTime = $zth(ActTime,1)
	Set:ActDate="" ActDate=+$h
	Set:ActTime="" ActTime=$p($h,",",2)
	
	If ChildSub="" {
		Set obj=##class(DHCHAI.IR.CRuleTestAbFlag).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleTestAbFlag).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         = objParref
    Set obj.BTAbFlagDr     = objTestRstFlag
	Set obj.BTActDate	   = ActDate	
	Set obj.BTActTime      = ActTime 
	Set obj.BTActUserDr    = objActUser	
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

/// Creator：     pylian
/// CreatDate：   2017-05-05
/// Description:  删除常规检验-异常标志维护信息
/// Table：       DHCHAI.IR.CRuleTestAbFlag
/// Input：       aId : DHCHAI.IR.CRuleTestAbFlag.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleTestAbFlag).DeleteById("1||1")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleTestAbFlag).%DeleteId(aId)
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
<Data name="CRuleTestAbFlagDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTAbFlagDr</Value>
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
<DataLocation>{%%PARENT}("TRF")</DataLocation>
<DefaultData>CRuleTestAbFlagDefaultData</DefaultData>
<IdLocation>{%%PARENT}("TRF")</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleTestAbI("TRF")</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleTestAbFlagS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
