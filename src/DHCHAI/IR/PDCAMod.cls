/// 名称: DHCHAI.IR.PDCAMod
/// 描述: PDCA模板定义
/// 编写者：ShenC
/// 编写日期: 2022-07-21
Class DHCHAI.IR.PDCAMod Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 内容扩展
Relationship ChildExt As DHCHAI.IR.PDCAModExt [ Cardinality = children, Inverse = Parref ];

/// 代码
Property PAModCode As %String [ Required ];

/// 名称
Property PAModName As %String [ Required ];

/// 是否有效
Property PAModIsActive As %String;

/// 备注说明
Property PAModResume As %String;

/// 索引-代码
Index IndexCode On PAModCode As Exact;

/// Creator：     ShenC
/// CreatDate：   2022-06-28
/// Description:  根据ID取PDCA模板
/// Table：       DHCHAI.IR.PDCAMod
/// Input：       aID : DHCHAI.IR.PDCAMod.ID
/// Return：      返回obj
/// w ##class(DHCHAI.IR.PDCAMod).GetObjById(1)
ClassMethod GetObjById(aID As %String) As DHCHAI.IR.PDCAMod
{
	New (aID)
	Quit:'##class(DHCHAI.IR.PDCAMod).%ExistsId(aID) ""
	Set obj=##Class(DHCHAI.IR.PDCAMod).%OpenId(aID)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     ShenC
/// CreatDate：   2022-06-28
/// Description:  更新PDCA模板
/// Table：       DHCHAI.IR.PDCAMod
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCAMod).Update("^ZLGL^质量管理问题整改^1^测试")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return

	Set:$g(aSeparete)="" aSeparete=..#SEPARATE
	Set ID			= $p(aInputStr,aSeparete,1)
	Set Code		= $p(aInputStr,aSeparete,2)
	Set Name		= $p(aInputStr,aSeparete,3)
	Set IsActive	= $p(aInputStr,aSeparete,4)
	Set Resume		= $p(aInputStr,aSeparete,5)
	
	Quit:(Code="")||(Name="") return
	//代码唯一判断
	Set tID=$o(^CT.MA.HAI.IR.PDCAModI("IndexCode",Code,0))
	Quit:(tID'="")&(ID'=tID) -2
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.PDCAMod).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.PDCAMod).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
		
	Set obj.PAModCode		= Code
	Set obj.PAModName		= Name
	Set obj.PAModIsActive	= IsActive
	Set obj.PAModResume 	= Resume
	
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
/// Description:  删除PDCA模板
/// Table：       DHCHAI.IR.PDCAMod
/// Input：       aId : DHCHAI.IR.PDCAMod.ID
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.PDCAMod).DeleteById(1)
ClassMethod DeleteById(aID As %String) As %String
{
	New (aID)
	Set sc = ##class(DHCHAI.IR.PDCAMod).%DeleteId(aID)
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
<Data name="PDCAModDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PAModCode</Value>
</Value>
<Value name="3">
<Value>PAModName</Value>
</Value>
<Value name="4">
<Value>PAModIsActive</Value>
</Value>
<Value name="5">
<Value>PAModResume</Value>
</Value>
</Data>
<DataLocation>^CT.MA.HAI.IR.PDCAModD</DataLocation>
<DefaultData>PDCAModDefaultData</DefaultData>
<IdLocation>^CT.MA.HAI.IR.PDCAModD</IdLocation>
<IndexLocation>^CT.MA.HAI.IR.PDCAModI</IndexLocation>
<StreamLocation>^CT.MA.HAI.IR.PDCAModS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
