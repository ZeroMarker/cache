/// 名称: CT.IPMR.BT.MrClass
/// 描述: 病案分类
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BT.MrClass Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BMCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BMDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 备注
Property BMResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 病案分类代码 索引
Index IndexCode On BMCode [ Unique ];

/// Creator：     zhouyang
/// CreatDate：   2019-10-18
/// Description:  取病案分类对象
/// Table：       CT.IPMR.BT.MrClass
/// Input：       Id : CT.IPMR.BT.MrClass.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.MrClass).GetObjById(1)
ClassMethod GetObjById(aId As %String) As CT.IPMR.BT.MrClass
{
	new (aId)
	quit:'##class(CT.IPMR.BT.MrClass).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.BT.MrClass).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhouyang
/// CreatDate：   2019-10-18
/// Description:  更新病案分类
/// Table：       CT.IPMR.BT.MrClass
/// Input：       InputStr ：病案分类数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.BT.MrClass).Update("^I^住院病历^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID		= $p(aInputStr,aSeparate,1)
	Set Code 	= $p(aInputStr,aSeparate,2)
	Set Desc 	= $p(aInputStr,aSeparate,3)
	Set Resume 	= $p(aInputStr,aSeparate,4)

	Set return=-100
	set tID=$o(^CT.IPMR.BT.MrClassI("IndexCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&&(tID'=ID) return
	
	If ID="" {
		Set obj=##class(CT.IPMR.BT.MrClass).%New()
	}Else{
		Set obj=##class(CT.IPMR.BT.MrClass).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BMCode		= Code
	Set obj.BMDesc		= Desc
	Set obj.BMResume	= Resume
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

/// Creator：     zhouyang
/// CreatDate：   2019-10-18
/// Description:  删除病案类型
/// Table：       CT.IPMR.BT.WorkItem
/// Input：       Id : CT.IPMR.BT.WorkItem.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.BT.MrClass).DeleteById(1)
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.BT.MrClass).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     WHui
/// CreatDate：   2019-10-29
/// Description:  根据Code查询病案分类
/// Table：       CT.IPMR.BT.MrClass
/// Input：       aCode
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.MrClass).GetObjByCode("I")
ClassMethod GetObjByCode(aCode As %String) As CT.IPMR.BT.MrClass
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^CT.IPMR.BT.MrClassI("IndexCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	
	Set obj=..GetObjById(ID)
	Quit:'$IsObject(obj) return
	Set return=obj
	Quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BMCode</Value>
</Value>
<Value name="3">
<Value>BMDesc</Value>
</Value>
<Value name="4">
<Value>BMResume</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.BT.MrClassD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.BT.MrClassD</IdLocation>
<IndexLocation>^CT.IPMR.BT.MrClassI</IndexLocation>
<StreamLocation>^CT.IPMR.BT.MrClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
