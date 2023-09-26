/// 名称: DHCHAI.IR.EnviHyItemObj
/// 描述: 环境卫生学监测项目关联监测对象
/// 编写者：zhufei
/// 编写日期: 2019-09-09
Class DHCHAI.IR.EnviHyItemObj Extends (%Persistent, DHCHAI.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship Parref As DHCHAI.IR.EnviHyItem [ Cardinality = parent, Inverse = ChildObj ];

/// 监测对象
Property EHObjectDr As DHCHAI.IR.EnviHyObject;

/// 是否有效
Property EHIsActive As %Boolean;

/// 更新日期
Property EHActDate As %Date;

/// 更新时间
Property EHActTime As %Time;

/// 更新人
Property EHActUserDr As DHCHAI.BT.SysUser;

Index IdxObjectDr On (Parref, EHObjectDr);

/// Creator：     zhangdc
/// CreatDate：   2019-09-17
/// Description:  根据ID取监测项目关联监测对象
/// Table：       DHCHAI.IR.EnviHyItemObj
/// Input：       
/// Return：      返回Object
/// w ##class(DHCHAI.IR.EnviHyItemObj).GetObjById("30||1")
ClassMethod GetObjById(id As %String) As DHCHAI.IR.EnviHyItemObj
{
	New (id)
	Quit:'##class(DHCHAI.IR.EnviHyItemObj).%ExistsId(id) ""
	Set obj=##Class(DHCHAI.IR.EnviHyItemObj).%OpenId(id)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhangdc
/// CreatDate：   2019-09-18
/// Description:  更新监测项目关联监测对象表
/// Table：       DHCHAI.IR.EnviHyItemObj
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCHAI.IR.EnviHyItemObj).Update("")
ClassMethod Update(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set:$g(aSeparete)="" aSeparete="^"
	Set Parref		         = $p(aInputStr,aSeparete,1)
	Set ID             		 = $p(aInputStr,aSeparete,2)
	Set ObjectID             = $p(aInputStr,aSeparete,3)
	Set IsActive             = $p(aInputStr,aSeparete,4)
	Quit:(Parref="")||(ObjectID="") return
	Set objEnviHyItem =##class(DHCHAI.IR.EnviHyItem).GetObjById(Parref)
	Quit:('$Isobject(objEnviHyItem)) -1
	
	If ID="" {
		Set obj=##class(DHCHAI.IR.EnviHyItemObj).%New()
	}Else{
		Set obj=##class(DHCHAI.IR.EnviHyItemObj).%OpenId(ID)
	}
	
	Quit:'$IsObject(obj) return
	Set obj.Parref           = objEnviHyItem   //对象
	Set obj.EHIsActive       = IsActive
	Set obj.EHObjectDr       = ##class(DHCHAI.IR.EnviHyObject).GetObjById(ObjectID)
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

/// Creator：     zhangdc
/// CreatDate：   2019-09-18
/// Description:  删除监测项目关联监测对象信息
/// Table：       DHCHAI.IR.EnviHyItemObj
/// Input：       
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCHAI.IR.EnviHyItemObj).DeleteById("")
ClassMethod DeleteById(aId As %String) As %String
{
	New (aId)
	Set sc = ##class(DHCHAI.IR.EnviHyItemObj).%DeleteId(aId)
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
<Data name="EnviHyItemObjDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EHObjectDr</Value>
</Value>
<Value name="3">
<Value>EHIsActive</Value>
</Value>
<Value name="4">
<Value>EHActDate</Value>
</Value>
<Value name="5">
<Value>EHActTime</Value>
</Value>
<Value name="6">
<Value>EHActUserDr</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Obj")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>{%%PARENT}("Obj")</IdLocation>
<IndexLocation>^DHCHAI.IR.EnviHyItemI("Obj")</IndexLocation>
<StreamLocation>^DHCHAI.IR.EnviHyItemObjS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
