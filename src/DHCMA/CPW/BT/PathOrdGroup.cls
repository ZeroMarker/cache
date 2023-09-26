/// 名称：DHCMA.CPW.BT.PathOrdGroup
/// 描述：关联医嘱划分方案（多组套）
/// 编写者：yankai
/// 编写日期：2020-12-21
Class DHCMA.CPW.BT.PathOrdGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 方案名称
Property CPOrdGroupDesc As %String [ Required ];

/// 方案备注
Property CPOrdGroupNote As %String;

/// 路径阶段指针
Property CPFormEpDr As DHCMA.CPW.BT.PathFormEp [ Required ];

Index IdxofFormEpDr On CPFormEpDr;

/// Creator：     yankai
/// CreatDate：   2020-12-21
/// Description:  根据ID取对象
/// Table：       DHCMA.CPW.BT.PathOrdGroup
/// Input：       aId
/// Return：      返回obj
/// w ##class(DHCMA.CPW.BT.PathOrdGroup).GetObjById(1||1)
ClassMethod GetObjById(aId As %String) As DHCMA.CPW.BT.PathOrdGroup
{
	New (aId)
	Quit:'##class(DHCMA.CPW.BT.PathOrdGroup).%ExistsId(aId) ""
	Set obj=##Class(DHCMA.CPW.BT.PathOrdGroup).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     yankai
/// CreatDate：   2020-12-21
/// Description:  更新数据
/// Table：       DHCMA.CPW.BT.PathOrdGroup
/// Input：       
/// Return：      
/// w ##class(DHCMA.CPW.BT.PathOrdGroup).Update("^方案一^方案描述测试^17||1")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=""
	Quit:aInputStr="" return
	
	Set OrdGroupID	 = $p(aInputStr,aSeparete,1)
	Set OrdGroupDesc = $p(aInputStr,aSeparete,2)
	Set OrdGroupNote = $p(aInputStr,aSeparete,3)
	Set FormEpDr 	 = $p(aInputStr,aSeparete,4)
	Set objFormEp = ##class(DHCMA.CPW.BT.PathFormEp).GetObjById(FormEpDr)

	Quit:'$IsObject(objFormEp) return
	If OrdGroupID="" {
		Set obj=##class(DHCMA.CPW.BT.PathOrdGroup).%New()
	}Else{
		Set obj=##class(DHCMA.CPW.BT.PathOrdGroup).%OpenId(OrdGroupID)
	}
	Quit:'$IsObject(obj) return

	Set obj.CPOrdGroupDesc = OrdGroupDesc
	Set obj.CPOrdGroupNote = OrdGroupNote
	Set obj.CPFormEpDr	   = objFormEp
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

/// Creator：     yankai
/// CreatDate：   2020-12-21
/// Description:  删除对象信息
/// Table：       DHCMA.CPW.BT.PathOrdGroup
/// Input：       aId 
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCMA.CPW.BT.PathOrdGroup).DeleteById("1")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCMA.CPW.BT.PathOrdGroup).%DeleteId(aId)
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
<Data name="PathOrdGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CPOrdGroupDesc</Value>
</Value>
<Value name="3">
<Value>CPOrdGroupNote</Value>
</Value>
<Value name="4">
<Value>CPFormEpDr</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.BT.PathOrdGroupD</DataLocation>
<DefaultData>PathOrdGroupDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.BT.PathOrdGroupD</IdLocation>
<IndexLocation>^DHCMA.CPW.BT.PathOrdGroupI</IndexLocation>
<StreamLocation>^DHCMA.CPW.BT.PathOrdGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
