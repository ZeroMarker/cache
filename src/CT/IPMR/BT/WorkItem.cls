/// 名称: CT.IPMR.BT.WorkItem
/// 描述: 操作项目
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BT.WorkItem Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property BWCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 名称
Property BWDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 备注
Property BWResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexCode On BWCode [ Unique ];

Index IndexDesc On BWDesc [ Unique ];

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  取操作项目
/// Table：       CT.IPMR.BT.WorkItem
/// Input：       aCode : CT.IPMR.BT.WorkItem.BWCode
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.WorkItem).GetObjByCode("1")
ClassMethod GetObjByCode(aCode As %String) As CT.IPMR.BT.WorkItem
{
	New (aCode)
	Quit:'$d(^CT.IPMR.BT.WorkItemI("IndexCode"," "_$ZCVT(aCode,"U"))) ""
	Set id = $o(^CT.IPMR.BT.WorkItemI("IndexCode"," "_$ZCVT(aCode,"U"),""))
	Set obj=..GetObjById(id)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  取操作项目
/// Table：       CT.IPMR.BT.WorkItem
/// Input：       aCode : CT.IPMR.BT.WorkItem.BWDesc
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.WorkItem).GetObjByDesc("初始状态")
ClassMethod GetObjByDesc(aCode As %String) As CT.IPMR.BT.WorkItem
{
	New (aCode)
	Quit:'$d(^CT.IPMR.BT.WorkItemI("IndexDesc"," "_$ZCVT(aCode,"U"))) ""
	Set id = $o(^CT.IPMR.BT.WorkItemI("IndexDesc"," "_$ZCVT(aCode,"U"),""))
	Set obj=..GetObjById(id)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhouyang
/// CreatDate：   2019-10-16
/// Description:  取操作项目对象
/// Table：       CT.IPMR.BT.WorkItem
/// Input：       Id : CT.IPMR.BT.WorkItem.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.WorkItem).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.BT.WorkItem
{
	new (aId)
	quit:'##class(CT.IPMR.BT.WorkItem).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.BT.WorkItem).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhouyang
/// CreatDate：   2019-10-16
/// Description:  更新操作项目
/// Table：       CT.IPMR.BT.WorkItem
/// Input：       InputStr ：操作对象数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.BT.WorkItem).Update("","^")
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
	set tID=$o(^CT.IPMR.BT.WorkItemI("IndexCode"," "_$zcvt(Code,"U"),0))
	Quit:(tID'="")&&(tID'=ID) return
	
	If ID="" {
		Set obj=##class(CT.IPMR.BT.WorkItem).%New()
	}Else{
		Set obj=##class(CT.IPMR.BT.WorkItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BWCode		= Code
	Set obj.BWDesc		= Desc
	Set obj.BWResume	= Resume
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
/// CreatDate：   2019-10-16
/// Description:  删除操作项目
/// Table：       CT.IPMR.BT.WorkItem
/// Input：       Id : CT.IPMR.BT.WorkItem.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.BT.WorkItem).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.BT.WorkItem).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BWCode</Value>
</Value>
<Value name="3">
<Value>BWDesc</Value>
</Value>
<Value name="4">
<Value>BWResume</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.BT.WorkItemD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.BT.WorkItemD</IdLocation>
<IndexLocation>^CT.IPMR.BT.WorkItemI</IndexLocation>
<StreamLocation>^CT.IPMR.BT.WorkItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
