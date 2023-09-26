/// 名称: DHCMA.CPW.BT.PathHosp
/// 描述: 临床路径字典关联医院列表
/// 编写者：jiangpengpeng
/// 编写日期: 2018-11-27
Class DHCMA.CPW.BT.PathHosp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCMA.CPW.BT.PathMast [ Cardinality = parent, Inverse = ChildHosp ];

/// 医院ID （指向DHCMA.Util.EP.Hospital.OID）
Property BTHospID As %String [ Required ];

/// 有效标志 
Property BTIsActive As %Boolean;

/// 处置日期
Property BTActDate As %Date;

/// 处置时间
Property BTActTime As %Time;

/// 处置人ID（指向DHCMA.Util.EP.SSUser.OID）
Property BTActUserID As %String;

Index IdxofParRef On Parref;

Index IdxofHosp On (Parref, BTHospID As Exact);

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-27
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.BT.PathHosp
/// Input：       aId : DHCMA.CPW.BT.PathHosp.ID
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathHosp).GetObjById("1||1")
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathHosp
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathHosp).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathHosp).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-27
/// Description:  更新数据
/// Table：       DHCMA.CPW.BT.PathHosp
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.BT.PathHosp).Update("15^^2!!1^1^9!!2")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set Parref=$p(aInputStr,aSeparete,1)
	Set ChildID=$p(aInputStr,aSeparete,2)
	Set HospID=$p(aInputStr,aSeparete,3)
	Set IsActive=$p(aInputStr,aSeparete,4)
	Set UserID=$p(aInputStr,aSeparete,5)
	
	Set ActDate=+$H
	Set ActTime=$p($H,",",2)
	
	Set objParref=##class(DHCMA.CPW.BT.PathMast).GetObjById(Parref)
	Quit:'$IsObject(objParref) return
	
	If ChildID="" {
		Set xID=$o(^DHCMA.CPW.BT.PathMastI("HOSP","IdxofHosp",Parref,HospID,""))
		Set:xID'="" ChildID=xID
	}
	If ChildID="" {
		Set obj=##class(DHCMA.CPW.BT.PathHosp).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.PathHosp).%OpenId(Parref_"||"_ChildID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Parref=objParref
	Set obj.BTHospID=HospID
	Set obj.BTIsActive=IsActive
	Set obj.BTActUserID=UserID
	Set obj.BTActDate=ActDate
	Set obj.BTActTime=ActTime
	
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

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-27
/// Description:  删除数据
/// Table：       DHCMA.CPW.BT.PathHosp
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.BT.PathHosp).Delete(1||1)
ClassMethod Delete(aID As %String) As %String
{
	New (aID)
	
	Set sc = ##class(DHCMA.CPW.BT.PathHosp).%DeleteId(aID)
	If $system.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=0
	}
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2018-11-27
/// Description:  清除数据
/// Table：       DHCMA.CPW.BT.PathHosp
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.BT.PathHosp).Clear()
ClassMethod Clear(Parref) As %String
{
	New (Parref)
	Set return=""
	Quit:Parref="" return
	
	Set xChild=""
	For {
		Set xChild=$o(^DHCMA.CPW.BT.PathMastD(Parref,"HOSP",xChild))
		Quit:xChild=""
		
		Set ret=..Delete(Parref_"||"_xChild)
		Set return=ret
	}
	Quit return
}

Storage Default
{
<Data name="PathHospDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTHospID</Value>
</Value>
<Value name="3">
<Value>BTIsActive</Value>
</Value>
<Value name="4">
<Value>BTActDate</Value>
</Value>
<Value name="5">
<Value>BTActTime</Value>
</Value>
<Value name="6">
<Value>BTActUserID</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("HOSP")</DataLocation>
<DefaultData>PathHospDefaultData</DefaultData>
<IdLocation>{%%PARENT}("HOSP")</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathMastI("HOSP")</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathHospS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
