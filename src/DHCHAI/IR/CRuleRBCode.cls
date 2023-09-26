/// 名称: DHCHAI.IR.CRuleRBCode
/// 描述: 检查项目维护
/// 编写者：zhufei
/// 编写日期: 2017-05-22
Class DHCHAI.IR.CRuleRBCode Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.CRuleRBAb [ Cardinality = parent, Inverse = ChildRBC ];

/// 检验项目
Property BTRBCodeDr As DHCHAI.DP.RBItmMastMap [ Required ];

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人
Property BTActUserDr As DHCHAI.BT.SysUser;

/// 检验项目 索引
Index IdxofRBCodeDr On BTRBCodeDr;

/// Creator：     zhoubo
/// CreatDate：   2017-08-02
/// Description:  根据ID取检查项目信息
/// Table：       DHCHAI.IR.CRuleRBCode
/// Input：       aId : DHCHAI.IR.CRuleRBCode.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.CRuleRBCode).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.IR.CRuleRBCode
{
	New (aId)
	Quit:'##class(DHCHAI.IR.CRuleRBCode).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.IR.CRuleRBCode).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-02
/// Description:  更新检查项目信息
/// Table：       DHCHAI.IR.CRuleRBCode
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleRBCode).Update("1^^1^^^9","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Parref     = $p(aInputStr,aSeparete,1)
	Set ChildSub   = $p(aInputStr,aSeparete,2)
	Set RBCodeDr   = $p(aInputStr,aSeparete,3)
	Set ActDate    = $p(aInputStr,aSeparete,4)
	Set ActTime    = $p(aInputStr,aSeparete,5)
	Set ActUserDr  = $p(aInputStr,aSeparete,6)
	Quit:(Parref="")||(RBCodeDr="") return
	
	//检查项目 不能重复	
	Set tChildSub=$o(^DHCHAI.IR.CRuleRBI("RBC","IdxofRBCodeDr",RBCodeDr,Parref,0))
	Quit:(tChildSub'="")&&(tChildSub'=ChildSub) -2
	
	Set objParref=##class(DHCHAI.IR.CRuleRBAb).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	Set objCode=##class(DHCHAI.DP.RBItmMastMap).GetObjById(RBCodeDr)
	Quit:'$IsObject(objCode) return
	Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUserDr)
	If ChildSub="" {
		Set obj=##class(DHCHAI.IR.CRuleRBCode).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.CRuleRBCode).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return

	//Set:ActDate["-" ActDate=$zdh(ActDate,3)
	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	Set obj.Parref      = objParref
	Set obj.BTRBCodeDr  = objCode
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

/// Creator：     zhoubo
/// CreatDate：   2017-08-02
/// Description:  删除检查项目信息
/// Table：       DHCHAI.IR.CRuleRBCode
/// Input：       aId : DHCHAI.IR.CRuleRBCode.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.CRuleRBCode).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.CRuleRBCode).%DeleteId(aId)
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
<Data name="CRuleRBCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTRBCodeDr</Value>
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
<DataLocation>{%%PARENT}("RBC")</DataLocation>
<DefaultData>CRuleRBCodeDefaultData</DefaultData>
<IdLocation>{%%PARENT}("RBC")</IdLocation>
<IndexLocation>^DHCHAI.IR.CRuleRBAbI("RBC")</IndexLocation>
<StreamLocation>^DHCHAI.IR.CRuleRBCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
