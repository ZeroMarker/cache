/// 名称: DHCHAI.BT.HospGroup
/// 描述: 医院分组表
/// 编写者：zhufei
/// 编写日期: 2017-03-15
Class DHCHAI.BT.HospGroup Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BTCode As %String(TRUNCATE = 1) [ Required ];

/// 名称
Property BTDesc As %String(TRUNCATE = 1) [ Required ];

Index IdxofCode On BTCode As Exact;

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  根据ID取医院分组信息
/// Table：       DHCHAI.BT.HospGroup
/// Input：       aId : DHCHAI.BT.HospGroup.ID
/// Return：      返回obj
/// w ##class(DHCHAI.BT.HospGroup).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCHAI.BT.HospGroup
{
	New (aId)
	Quit:'##class(DHCHAI.BT.HospGroup).%ExistsId(aId) ""
	Set obj=##Class(DHCHAI.BT.HospGroup).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-05-11
/// Description:  根据Code取医院分组信息
/// Table：       DHCHAI.BT.HospGroup
/// Input：       aCode : DHCHAI.BT.HospGroup.Code
/// Return：      返回obj
/// w ##class(DHCHAI.BT.HospGroup).GetObjByCode(1)
ClassMethod GetObjByCode(aCode As %String) As DHCHAI.BT.HospGroup
{
	New (aCode)
	Quit:aCode="" ""
	Set ID=$o(^DHCHAI.BT.HospGroupI("IdxofCode",aCode,0))
	Set obj=..GetObjById(ID)
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2017-03-15
/// Description:  更新医院分组信息
/// Table：       DHCHAI.BT.HospGroup
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.BT.HospGroup).Update("^P01^PDesc^1^1","")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	
	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID       = $p(aInputStr,aSeparete,1)
	Set Code     = $p(aInputStr,aSeparete,2)
	Set Desc     = $p(aInputStr,aSeparete,3)
	Quit:(Code="")||(Desc="") return
	Set Desc = ##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Desc)  //去掉特殊字符
	
	Set tID=$o(^DHCHAI.BT.HospGroupI("IdxofCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.BT.HospGroup).%New()
	}Else{
		Set obj=##class(DHCHAI.BT.HospGroup).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BTCode     = Code
	Set obj.BTDesc     = Desc
	
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
/// CreatDate：   2017-03-15
/// Description:  删除医院分组信息
/// Table：       DHCHAI.BT.HospGroup
/// Input：       aId : DHCHAI.BT.HospGroup.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.BT.HospGroup).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.BT.HospGroup).%DeleteId(aId)
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
<Data name="DicTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
</Data>
<DataLocation>^DHCHAI.BT.HospGroupD</DataLocation>
<DefaultData>DicTypeDefaultData</DefaultData>
<IdLocation>^DHCHAI.BT.HospGroupD</IdLocation>
<IndexLocation>^DHCHAI.BT.HospGroupI</IndexLocation>
<StreamLocation>^DHCHAI.BT.HospGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
