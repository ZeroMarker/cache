/// 检查医嘱与检查部位关联表
Class DHCMA.Util.EPx.AppArcLink Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检查医嘱指针
Property ALArcDr As DHCMA.Util.EPx.OrdMast [ Required ];

/// 检查部位指针
Property ALPartDr As DHCMA.Util.EPx.AppPart [ Required ];

/// 检查医嘱+检查部位 索引
Index IdxOfALArcPart On (ALArcDr, ALPartDr) [ Unique ];

/// 检查部位+检查医嘱 索引
Index IdxOfALPartArc On (ALPartDr, ALArcDr);

/// Creator：     zhufei
/// CreatDate：   2020-03-06
/// Description:  根据ID取检查医嘱检查部位关联信息
/// Table：       DHCMA.Util.EPx.AppArcLink
/// Input：       aId : DHCMA.Util.EPx.AppArcLink.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.EPx.AppArcLink).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.EPx.AppArcLink
{
	New (aId)
	Quit:'##class(DHCMA.Util.EPx.AppArcLink).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.EPx.AppArcLink).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2020-03-06
/// Description:  更新检查医嘱检查部位关联信息
/// Table：       DHCMA.Util.EPx.AppArcLink
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.AppArcLink).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)
	Set ArcDr    = $p(aInputStr,aSeparete,2)
	Set PartDr   = $p(aInputStr,aSeparete,3)
	Quit:(ArcDr="")||(PartDr="") return
	
	Set objArc=##class(DHCMA.Util.EPx.OrdMast).GetObjById(ArcDr)
	Quit:'$IsObject(objArc) return
	Set objPart=##class(DHCMA.Util.EPx.AppPart).GetObjById(PartDr)
	Quit:'$IsObject(objPart) return
	
	Set tID=$o(^DHCMA.Util.EPx.AppArcLinkI("IdxOfALArcPart",ArcDr,PartDr,0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMA.Util.EPx.AppArcLink).%New()
	}Else{
		Set obj=##class(DHCMA.Util.EPx.AppArcLink).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.ALArcDr   = objArc
	Set obj.ALPartDr  = objPart
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

/// Creator：     zhufei
/// CreatDate：   2020-03-06
/// Description:  删除检查医嘱检查部位关联信息
/// Table：       DHCMA.Util.EPx.AppArcLink
/// Input：       aId : DHCMA.Util.EPx.AppArcLink.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.AppArcLink).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.Util.EPx.AppArcLink).%DeleteId(aId)
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
<Data name="AppArcLinkDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ALArcDr</Value>
</Value>
<Value name="3">
<Value>ALPartDr</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.EPx.AppArcLinkD</DataLocation>
<DefaultData>AppArcLinkDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.EPx.AppArcLinkD</IdLocation>
<IndexLocation>^DHCMA.Util.EPx.AppArcLinkI</IndexLocation>
<StreamLocation>^DHCMA.Util.EPx.AppArcLinkS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
