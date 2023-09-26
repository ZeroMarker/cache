/// 名称: DHCHAI.IR.PDCARepLog
/// 描述: PDCA报告-更新日志
/// 编写者：ShenC
/// 编写日期: 2022-09-14
Class DHCHAI.IR.PDCARepLog Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.PDCARep [ Cardinality = parent, Inverse = ChildLog ];

/// 操作状态
Property PAStatus As %String(MAXLEN = 500, TRUNCATE = 1);

/// 更新日期
Property PAUpdateDate As %Date;

/// 更新时间
Property PAUpdateTime As %Time;

/// 更新人
Property PAUpdateUserDr As DHCHAI.BT.SysUser;

/// 索引 操作状态
Index IndexStatusDate On (Parref, PAStatus As Exact, PAUpdateDate);

/// Creator：     ShenC
/// CreatDate：   2022-09-10
/// Description:  根据ID取PDCA报告更新日志
/// Table：       DHCHAI.IR.PDCARepLog
/// Input：       aID : DHCHAI.IR.PDCARepLog.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.PDCARepLog).GetObjById(1)
ClassMethod GetObjById(aID As %String) As DHCHAI.IR.PDCARepLog
{
	New (aID)
	Quit:'##class(DHCHAI.IR.PDCARepLog).%ExistsId(aID) ""
	Set obj=##Class(DHCHAI.IR.PDCARepLog).%OpenId(aID)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     ShenC
/// CreatDate：   2018-05-10
/// Description:  更新PDCA报告更新日志
/// Table：       DHCHAI.IR.PDCARepLog
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCARepLog).Update("6^^1^^^592")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
    Set Parref       = $p(aInputStr,aSeparete,1)
	Set ChildSub     = $p(aInputStr,aSeparete,2)
	Set Status       = $p(aInputStr,aSeparete,3)
	Set UpdateDate   = $p(aInputStr,aSeparete,4)
	Set UpdateTime   = $p(aInputStr,aSeparete,5)
	Set UpdateUserDr = $p(aInputStr,aSeparete,6)
	Quit:(Parref="")||(Status="") return
	
	Set:UpdateDate'="" UpdateDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(UpdateDate)
	Set:UpdateDate="" UpdateDate=+$h
	Set:UpdateTime[":" UpdateTime = $zth(UpdateTime,1)
	Set:UpdateTime="" UpdateTime=$p($h,",",2)
		
	Set objParref=##class(DHCHAI.IR.PDCARep).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objUser = ##class(DHCHAI.BT.SysUser).GetObjById(UpdateUserDr)

	If (ChildSub="") {
		Set obj=##class(DHCHAI.IR.PDCARepLog).%New()
	} Else {
		Set obj=##class(DHCHAI.IR.PDCARepLog).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref         	= objParref
	Set obj.PAStatus       	= Status    
	Set obj.PAUpdateDate    = UpdateDate     
	Set obj.PAUpdateTime  	= UpdateTime  
	Set obj.PAUpdateUserDr  = objUser  
	
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

/// Creator：     ShenC
/// CreatDate：   2018-05-10
/// Description:  删除PDCA报告更新日志
/// Table：       DHCHAI.IR.PDCARepLog
/// Input：       aID : DHCHAI.IR.PDCARepLog.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCARepLog).DeleteById(1)
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set sc = ##class(DHCHAI.IR.PDCARepLog).%DeleteId(aID)
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
<Data name="PDCARepLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAStatus</Value>
</Value>
<Value name="3">
<Value>PAUpdateDate</Value>
</Value>
<Value name="4">
<Value>PAUpdateTime</Value>
</Value>
<Value name="5">
<Value>PAUpdateUserDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Log")</DataLocation>
<DefaultData>PDCARepLogDefaultData</DefaultData>
<IdLocation>{%%PARENT}("Log")</IdLocation>
<IndexLocation>^MA.HAI.IR.PDCARepI("Log")</IndexLocation>
<StreamLocation>^MA.HAI.IR.PDCARepLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
