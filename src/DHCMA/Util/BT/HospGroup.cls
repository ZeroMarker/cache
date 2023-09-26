/// 名称: DHCMA.Util.BT.HospGroup
/// 描述: 医院分组表
/// 编写者：zhufei
/// 编写日期: 2018-07-31
Class DHCMA.Util.BT.HospGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 是否有效
Property BTIsActive As %Boolean;

Index IdxofCode On BTCode;

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  根据ID取医院分组信息
/// Table：       DHCMA.Util.BT.HospGroup
/// Input：       aId : DHCMA.Util.BT.HospGroup.ID
/// Return：      返回obj
/// w ##class(DHCMA.Util.BT.HospGroup).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMA.Util.BT.HospGroup
{
	New (aId)
	Quit:'##class(DHCMA.Util.BT.HospGroup).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.Util.BT.HospGroup).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2018-07-31
/// Description:  更新医院分组信息
/// Table：       DHCMA.Util.BT.HospGroup
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.HospGroup).Update("","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:aSeparete="" aSeparete="^"
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Set IsActive = $p(aInputStr,aSeparete,4)
	Set:IsActive="" IsActive=1
	Quit:(Code="")||(Desc="") return
	
	Set tID=$o(^DHCMA.Util.BT.HospGroupI("IdxofCode"," "_$zcvt(Code,"U"),0))
	Set:ID="" ID=tID
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCMA.Util.BT.HospGroup).%New()
	}Else{
		Set obj=##class(DHCMA.Util.BT.HospGroup).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	Set obj.BTIsActive = IsActive
	
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
/// Description:  删除医院分组信息
/// Table：       DHCMA.Util.BT.HospGroup
/// Input：       aId : DHCMA.Util.BT.HospGroup.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.Util.BT.HospGroup).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.Util.BT.HospGroup).%DeleteId(aId)
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
<Data name="HospGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTIsActive</Value>
</Value>
</Data>
<DataLocation>^DHCMA.Util.BT.HospGroupD</DataLocation>
<DefaultData>HospGroupDefaultData</DefaultData>
<IdLocation>^DHCMA.Util.BT.HospGroupD</IdLocation>
<IndexLocation>^DHCMA.Util.BT.HospGroupI</IndexLocation>
<StreamLocation>^DHCMA.Util.BT.HospGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
