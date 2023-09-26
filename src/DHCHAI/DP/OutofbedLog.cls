/// 名称: DHCHAI.DP.OutofbedLog
/// 描述: 离床超过一日患者操作日志
/// 编写者：pylian
/// 编写日期: 2020-03-11
Class DHCHAI.DP.OutofbedLog Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.DP.Outofbed [ Cardinality = parent, Inverse = ChildLog ];

/// 标记状态（0未标记、1标记、2取消标记）
Property OprStatus As %Integer;

/// 标记出院日期
Property DischDate As %Date;

/// 标记出院时间
Property DischTime As %Time;

/// 更新日期
Property UpdateDate As %Date;

/// 更新时间
Property UpdateTime As %Time;

/// 标记人
Property UpdateUserDr As DHCHAI.BT.SysUser;

/// Creator：     pylian
/// CreatDate：   2020-03-11
/// Description:  根据ID离床超过一日患者操作日志
/// Table：       DHCHAI.DP.OutofbedLog
/// Input：       DHCHAI.DP.OutofbedLog.ID
/// Return：      返回obj
/// w ##class(DHCHAI.DP.OutofbedLog).GetObjById("1||3")
ClassMethod GetObjById(aId As %String) As DHCHAI.DP.OutofbedLog
{
	New (aId)
	Set obj=##Class(DHCHAI.DP.OutofbedLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     pylian
/// CreatDate：   2020-03-11
/// Description:  更新离床超过一日患者操作日志
/// Table：       DHCHAI.DP.OutofbedLog
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.DP.OutofbedLog).Update("","^")
ClassMethod Update(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=""
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Quit:(aSeparete="") return
	
	Set Parref       = $p(aInput,aSeparete,1)
	Set ChildSub     = $p(aInput,aSeparete,2)
	Set OprStatus    = $p(aInput,aSeparete,3)
	Set DischDate    = $p(aInput,aSeparete,4)
	Set DischTime    = $p(aInput,aSeparete,5)
	Set UpdateDate   = $p(aInput,aSeparete,6)
	Set UpdateTime   = $p(aInput,aSeparete,7)
	Set UpdateUserDr = $p(aInput,aSeparete,8)
	Quit:(Parref="")||(OprStatus="") return
	
	Set objParref = ##class(DHCHAI.DP.Outofbed).GetObjById(Parref)
    Set:DischDate'="" DischDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(DischDate)
	Set:DischTime[":" DischTime = $zth(DischTime,1)
	Set:UpdateDate'="" UpdateDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UpdateDate)
	Set:UpdateDate="" UpdateDate=+$h   //当前日期
	Set:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
	Set objUser=##class(DHCHAI.BT.SysUser).GetObjById(UpdateUserDr)
	
	If ChildSub="" {
		Set obj=##class(DHCHAI.DP.OutofbedLog).%New()
	}Else{
		Set ID = Parref_"||"_ChildSub
		Set obj=##class(DHCHAI.DP.OutofbedLog).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	Set obj.Parref        = objParref
	Set obj.OprStatus    = OprStatus   
	Set obj.DischDate    = DischDate   
	Set obj.DischTime    = DischTime   
	Set obj.UpdateDate   = UpdateDate  
	Set obj.UpdateTime   = UpdateTime  
	Set obj.UpdateUserDr = objUser
		
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-03-11
/// Description:  删除离床超过一日患者操作日志
/// Table：       DHCHAI.DP.OutofbedLog
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCHAI.DP.OutofbedLog).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.DP.OutofbedLog).%DeleteId(aId)
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
<Data name="OutofbedLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OprStatus</Value>
</Value>
<Value name="3">
<Value>DischDate</Value>
</Value>
<Value name="4">
<Value>DischTime</Value>
</Value>
<Value name="5">
<Value>UpdateDate</Value>
</Value>
<Value name="6">
<Value>UpdateTime</Value>
</Value>
<Value name="7">
<Value>UpdateUserDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Log")</DataLocation>
<DefaultData>OutofbedLogDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Log")</IdLocation>
<IndexLocation>^DHCHAI.DP.OutofbedI("Log")</IndexLocation>
<StreamLocation>^DHCHAI.DP.OutofbedLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
