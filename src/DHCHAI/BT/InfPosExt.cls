/// 名称: DHCHAI.BT.InfPosExt
/// 描述: 感染诊断（部位）分类对照表
/// 编写者：chenjb
/// 编写日期: 2017-01-10
Class DHCHAI.BT.InfPosExt Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.BT.InfPos [ Cardinality = parent, Inverse = ChildExt ];

/// 感染诊断分类
Property BTInfSubDr As DHCHAI.BT.InfSub;

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人
Property BTActUserDr As DHCHAI.BT.SysUser;

Index IdxofInfSubDr On BTInfSubDr;

Index IdxofParRef On Parref;

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  根据ID取感染诊断（部位）分类对照信息
/// Table：       DHCHAI.BT.InfPosExt
/// Input：       aId : DHCHAI.BT.InfPosExt.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.InfPosExt).GetObjById("5||1")
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.InfPosExt
{
	New (aId)
	Quit:'##class(DHCHAI.BT.InfPosExt).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.InfPosExt).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  更新感染诊断（部位）分类对照信息
/// Table：       DHCHAI.BT.InfPosExt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.InfPosExt).Update("^1^1","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Parref    = $p(aInputStr,aSeparete,1)
	Set ChildSub  = $p(aInputStr,aSeparete,2)
	Set InfSubDr  = $p(aInputStr,aSeparete,3)
	Set ActDate   = $p(aInputStr,aSeparete,4)
	Set ActTime   = $p(aInputStr,aSeparete,5)
	Set ActUserDr = $p(aInputStr,aSeparete,6)
	Quit:(Parref="")||(InfSubDr="") return
	
	Set objParref=##class(DHCHAI.BT.InfPos).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objInfSub=##class(DHCHAI.BT.InfSub).GetObjById(InfSubDr)
	Quit:'$IsObject(objInfSub) return
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	If ChildSub="" {
		Set obj=##class(DHCHAI.BT.InfPosExt).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.InfPosExt).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref     = objParref
	Set obj.BTInfSubDr = objInfSub
	Set obj.BTActDate   = ActDate
	Set obj.BTActTime   = ActTime
	Set obj.BTActUserDr = objActUser
	
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

/// Creator：     chenjb
/// CreatDate：   2017-01-10
/// Description:  删除感染诊断（部位）分类对照信息
/// Table：       DHCHAI.BT.InfPosExt
/// Input：       aId : DHCHAI.BT.InfPosExt.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.InfPosExt).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set Flg = ##class(DHCHAI.BT.DeleteControl).GetAllowDel("DHCHAI.BT.InfPosExt")
	Quit:Flg'=1 -777
	Set sc = ##class(DHCHAI.BT.InfPosExt).%DeleteId(aId)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     xuwj
/// CreatDate：   2017-12-1
/// Description:  判断感染诊断是否关联诊断分类
/// Table：       DHCHAI.BT.InfPosExt
/// Input：       aId : DHCHAI.BT.InfPosExt.ID
/// Return：      返回Object
/// w ##class(DHCHAI.BT.InfPosExt).CheckIsRelat(1)
ClassMethod CheckIsRelat(aId As %String) As %String
{
	Set return=""
	Quit:aId="" return
	Set return=$d(^DHCHAI.BT.InfPosI("EXT","IdxofParRef",aId)) //感染诊断是否关联诊断分类
	Quit return
}

Storage Default
{
<Data name="InfPosExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTInfSubDr</Value>
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
<DataLocation>{%%PARENT}("EXT")</DataLocation>
<DefaultData>InfPosExtDefaultData</DefaultData>
<IdLocation>{%%PARENT}("EXT")</IdLocation>
<IndexLocation>^DHCHAI.BT.InfPosI("EXT")</IndexLocation>
<StreamLocation>^DHCHAI.BT.InfPosExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
