/// 名称: CT.IPMR.BT.WorkFlow
/// 描述: 工作流
/// 创建者：liyi
/// 创建日期: 2019-09-17
Class CT.IPMR.BT.WorkFlow Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildItem As CT.IPMR.BT.WorkFItem [ Cardinality = children, Inverse = Parref ];

/// 代码
Property BWCode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 描述
Property BWDesc As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 备注
Property BWResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexCode On BWCode [ Unique ];

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  取工作流
/// Table：       CT.IPMR.BT.WorkFlow
/// Input：       aCode : CT.IPMR.BT.WorkFlow.BWCode
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.WorkFlow).GetObjByCode("IP")
ClassMethod GetObjByCode(aCode As %String) As CT.IPMR.BT.WorkFlow
{
	New (aCode)
	Quit:'$d(^CT.IPMR.BT.WorkFlowI("IndexCode"," "_$ZCVT(aCode,"U"))) ""
	Set id = $o(^CT.IPMR.BT.WorkFlowI("IndexCode"," "_$ZCVT(aCode,"U"),""))
	Set obj=..GetObjById(id)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     liyi
/// CreatDate：   2019-10-08
/// Description:  取工作流
/// Table：       CT.IPMR.BT.WorkFlow
/// Input：       Id : CT.IPMR.BT.WorkFlow.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.WorkFlow).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.BT.WorkFlow
{
	New (aId)
	Quit:'##class(CT.IPMR.BT.WorkFlow).%ExistsId(aId) ""
	Set obj=##Class(CT.IPMR.BT.WorkFlow).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     WHui
/// CreatDate：   2019-12-23
/// Description:  根据病案类型取工作流
/// Table：       CT.IPMR.BT.WorkFlow
/// Input：       MrTypeID : 病案类型ID
/// Return：      返回Object
/// w ##class(CT.IPMR.BT.WorkFlow).GetWorkFlow(7)
ClassMethod GetWorkFlow(aMrTypeID As %String) As CT.IPMR.BT.WorkFlow
{
	New (aMrTypeID)
	Set return=""
	Quit:aMrTypeID="" return
	
	Set objMrType=##class(CT.IPMR.BT.MrType).GetObjById(aMrTypeID)
	Quit:'$IsObject(objMrType) return
	Quit:'$IsObject(objMrType.BMWorkFlow) return
	set return=objMrType.BMWorkFlow
	quit return
}

/// Creator：     WHui
/// CreatDate：   2019-10-24
/// Description:  更新工作流
/// Table：       CT.IPMR.BT.WorkFlow
/// Input：       InputStr : ID^代码^描述^备注
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(CT.IPMR.BT.WorkFlow).Update("1^Code^顺序工作^备注","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID		= $p(aInputStr,aSeparate,1)
	Set Code	= $p(aInputStr,aSeparate,2)
	Set Desc	= $p(aInputStr,aSeparate,3)
	Set Resume	= $p(aInputStr,aSeparate,4)
	Quit:(Code="")||(Desc="") return
	
	If ID="" {
		Set obj=##class(CT.IPMR.BT.WorkFlow).%New()
	} Else {
		Set obj=##class(CT.IPMR.BT.WorkFlow).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.BWCode    = Code
	Set obj.BWDesc    = Desc
	Set obj.BWResume  = Resume
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	Do obj.%Close()
	
	Quit return
}

/// Creator：     WHui
/// CreatDate：   2019-10-24
/// Description:  删除工作流
/// Table：       CT.IPMR.BT.WorkFlow
/// Input：       Id : CT.IPMR.BT.WorkFlow.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(CT.IPMR.BT.WorkFlow).DeleteById(1)
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(CT.IPMR.BT.WorkFlow).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
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
<DataLocation>^CT.IPMR.BT.WorkFlowD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CT.IPMR.BT.WorkFlowD</IdLocation>
<IndexLocation>^CT.IPMR.BT.WorkFlowI</IndexLocation>
<StreamLocation>^CT.IPMR.BT.WorkFlowS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
