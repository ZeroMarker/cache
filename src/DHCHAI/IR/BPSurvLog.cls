/// 名称: DHCHAI.IR.BPSurvLog
/// 描述: 更新日志
/// 编写者: zhoubo
/// 编写日期: 2022-10-14
Class DHCHAI.IR.BPSurvLog Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.BPSurvery [ Cardinality = parent, Inverse = ChildLog ];

/// 操作状态
Property OEStatusDr As DHCHAI.BT.Dictionary;

/// 操作意见
Property OEOpinion As %String(MAXLEN = 500, TRUNCATE = 1);

/// 更新日期
Property OEUpdateDate As %Date;

/// 更新时间
Property OEUpdateTime As %Time;

/// 更新人
Property OEUpdateUserDr As DHCHAI.BT.SysUser;

/// 索引 操作状态
Index IndexStatusDate On (Parref, OEStatusDr As Exact, OEUpdateDate);

/// Creator：     zhoubo
/// CreatDate：   2022-10-14
/// Description:  根据ID取更新日志
/// Table：       DHCHAI.IR.BPSurvLog
/// Input：       aId : DHCHAI.IR.BPSurvLog.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.BPSurvLog).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.BPSurvLog
{
	New (aId)
	Quit:'##class(DHCHAI.IR.BPSurvLog).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.BPSurvLog).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2022-10-14
/// Description:  更新日志
/// Table：       DHCHAI.IR.BPSurvLog
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.BPSurvLog).Update("")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
    Set Parref       = $p(aInputStr,aSeparete,1)
	Set ChildSub     = $p(aInputStr,aSeparete,2)
	Set StatusDr     = $p(aInputStr,aSeparete,3)
	Set Opinion      = $p(aInputStr,aSeparete,4)
	Set UpdateUserDr = $p(aInputStr,aSeparete,5)
	Set UpdateDate   = $p(aInputStr,aSeparete,6)
	Set UpdateTime   = $p(aInputStr,aSeparete,7)
	
	Quit:(Parref="")||(StatusDr="") return
	
	Set:UpdateDate'="" UpdateDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UpdateDate)
	Set:UpdateDate="" UpdateDate=+$h
	Set:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
		
	Set objParref=##class(DHCHAI.IR.BPSurvery).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objStatus = ##class(DHCHAI.BT.Dictionary).GetObjById(StatusDr)
	Quit:'$IsObject(objStatus) return
	Set objUser = ##class(DHCHAI.BT.SysUser).GetObjById(UpdateUserDr)

	If (ChildSub="") {
		Set obj=##class(DHCHAI.IR.BPSurvLog).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.BPSurvLog).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         = objParref
	Set obj.OEStatusDr     = objStatus    
	Set obj.OEOpinion      = Opinion     
	Set obj.OEUpdateDate   = UpdateDate  
	Set obj.OEUpdateTime   = UpdateTime  
	Set obj.OEUpdateUserDr = objUser
	
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
/// CreatDate：   2022-10-14
/// Description:  删除更新日志
/// Table：       DHCHAI.IR.BPSurvLog
/// Input：       aId : DHCHAI.IR.BPSurvLog.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.BPSurvLog).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.BPSurvLog).%DeleteId(aId)
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
<Data name="BPSurvLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OEStatusDr</Value>
</Value>
<Value name="3">
<Value>OEOpinion</Value>
</Value>
<Value name="4">
<Value>OEUpdateDate</Value>
</Value>
<Value name="5">
<Value>OEUpdateTime</Value>
</Value>
<Value name="6">
<Value>OEUpdateUserDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("LOG")</DataLocation>
<DefaultData>BPSurvLogDefaultData</DefaultData>
<IdLocation>{%%PARENT}("LOG")</IdLocation>
<IndexLocation>^MA.HAI.IR.BPSurveryI("LOG")</IndexLocation>
<StreamLocation>^MA.HAI.IR.BPSurvLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
