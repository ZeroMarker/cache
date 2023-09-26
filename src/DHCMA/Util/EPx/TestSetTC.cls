/// 检验医嘱与检验项目关联表
Class DHCMA.Util.EPx.TestSetTC Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 检验医嘱指针
Property TestSetDr As DHCMA.Util.EPx.TestSet [ Required ];

/// 检验项目指针
Property TestCodeDr As DHCMA.Util.EPx.TestCode [ Required ];

/// 检验医嘱+检验项目 索引
Index IdxOfTestSetTC On (TestSetDr, TestCodeDr) [ Unique ];

/// 检验项目+检验医嘱 索引
Index IdxOfTestCodeTS On (TestCodeDr, TestSetDr);

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据ID取检验医嘱检验项目关联信息
/// Table：       DHCMA.Util.EPx.TestSetTC
/// Input：       aId : DHCMA.Util.EPx.TestSetTC.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.EPx.TestSetTC).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.EPx.TestSetTC
{
	New (aId)
	Quit:'##class(DHCMA.Util.EPx.TestSetTC).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.EPx.TestSetTC).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新检验医嘱检验项目关联信息
/// Table：       DHCMA.Util.EPx.TestSetTC
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.TestSetTC).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)
	Set TSDr     = $p(aInputStr,aSeparete,2)
	Set TCDr     = $p(aInputStr,aSeparete,3)
	Quit:(TSDr="")||(TCDr="") return
	
	Set objTS=##class(DHCMA.Util.EPx.TestSet).GetObjById(TSDr)
	Quit:'$IsObject(objTS) return
	Set objTC=##class(DHCMA.Util.EPx.TestCode).GetObjById(TCDr)
	Quit:'$IsObject(objTC) return
	
	Set tID=$o(^DHCMA.Util.EPx.TestSetTCI("IdxOfTestSetTC",TSDr,TCDr,0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMA.Util.EPx.TestSetTC).%New()
	}Else{
		Set obj=##class(DHCMA.Util.EPx.TestSetTC).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.TestSetDr   = objTS
	Set obj.TestCodeDr  = objTC
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
/// CreatDate：   2018-07-31
/// Description:  删除检验医嘱检验项目关联信息
/// Table：       DHCMA.Util.EPx.TestSetTC
/// Input：       aId : DHCMA.Util.EPx.TestSetTC.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.EPx.TestSetTC).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.Util.EPx.TestSetTC).%DeleteId(aId)
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
<Data name="TestSetTCDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDr</Value>
</Value>
<Value name="3">
<Value>TestCodeDr</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.EPx.TestSetTCD</DataLocation>
<DefaultData>TestSetTCDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.EPx.TestSetTCD</IdLocation>
<IndexLocation>^DHCMA.Util.EPx.TestSetTCI</IndexLocation>
<StreamLocation>^DHCMA.Util.EPx.TestSetTCS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
