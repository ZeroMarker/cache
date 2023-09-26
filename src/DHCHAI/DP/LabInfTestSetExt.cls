/// 名称: DHCHAI.DP.LabInfTestSetExt
/// 描述: 院感检验医嘱外部码
/// 编写者：zhufei
/// 编写日期: 2020-10-28
Class DHCHAI.DP.LabInfTestSetExt Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.DP.LabInfTestSet [ Cardinality = parent, Inverse = ChildExt ];

/// 外部码（检验医嘱/检验组套）
Property BTExtCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 更新日期
Property BTActDate As %Date;

/// 更新时间
Property BTActTime As %Time;

/// 更新人（ID|Code|Desc）
Property BTActUser As %String(MAXLEN = 100, TRUNCATE = 1);

Index IdxofParRef On Parref;

Index IdxofParCode On (Parref, BTExtCode As Exact);

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  根据ID取院感检验医嘱外部码信息
/// Table：       DHCHAI.DP.LabInfTestSetExt
/// Input：       aId : DHCHAI.DP.LabInfTestSetExt.ID
/// Return：      返回obj
/// w ##class(DHCHAI.DP.LabInfTestSetExt).GetObjById("5||1")
ClassMethod GetObjById(aId As %String) As DHCHAI.DP.LabInfTestSetExt
{
	New (aId)
	Quit:'##class(DHCHAI.DP.LabInfTestSetExt).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.DP.LabInfTestSetExt).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhoubo
/// CreatDate：   2020-12-02
/// Description:  更新院感检验医嘱外部码信息
/// Table：       DHCHAI.DP.LabInfTestSetExt
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.DP.LabInfTestSetExt).Update("12^^透析液内毒素^^^","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set Parref    = $p(aInputStr,aSeparete,1)
	Set ChildSub  = $p(aInputStr,aSeparete,2)
	Set ExtCode   = $p(aInputStr,aSeparete,3)
	Set ActDate   = $p(aInputStr,aSeparete,4)
	Set ActTime   = $p(aInputStr,aSeparete,5)
	Set ActUser   = $p(aInputStr,aSeparete,6)
	Quit:(Parref="")||(ExtCode="") return
	
	Set objParref=##class(DHCHAI.DP.LabInfTestSet).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	Set tChildSub=$o(^DHCHAI.DP.LabInfTestSetExtI("IdxofParCode",Parref,ExtCode,0))
	Quit:(tChildSub'="")&(ChildSub'=tChildSub) -2

	Set:ActDate'="" ActDate = ##class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(ActDate)
	Set:ActDate="" ActDate=+$h
	Set:ActTime[":" ActTime=$zth(ActTime,1)
	Set:ActTime="" ActTime=$p($h,",",2)
	
	If ChildSub="" {
		Set obj=##class(DHCHAI.DP.LabInfTestSetExt).%New()
	}Else{
		Set obj=##class(DHCHAI.DP.LabInfTestSetExt).%OpenId(Parref_"||"_ChildSub)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref     = objParref
	Set obj.BTExtCode  = ExtCode
	Set obj.BTActDate  = ActDate
	Set obj.BTActTime  = ActTime
	Set obj.BTActUser  = ActUser
	
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
/// CreatDate：   2020-12-02
/// Description:  删除院感检验医嘱外部码信息
/// Table：       DHCHAI.DP.LabInfTestSetExt
/// Input：       aId : DHCHAI.DP.LabInfTestSetExt.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.InfPosExt).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.DP.LabInfTestSetExt).%DeleteId(aId)
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
<Data name="LabInfTestSetExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTExtCode</Value>
</Value>
<Value name="3">
<Value>BTActDate</Value>
</Value>
<Value name="4">
<Value>BTActTime</Value>
</Value>
<Value name="5">
<Value>BTActUser</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildExt")</DataLocation>
<DefaultData>LabInfTestSetExtDefaultData</DefaultData>
<IdLocation>^DHCHAI.DP.LabInfTestSetC("ChildExt")</IdLocation>
<IndexLocation>^DHCHAI.DP.LabInfTestSetExtI</IndexLocation>
<StreamLocation>^DHCHAI.DP.LabInfTestSetExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
