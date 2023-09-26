/// 名称: CT.IPMR.FP.AT.Adapter
/// 描述: 适配项目表
/// 创建者：zhouyang
/// 创建日期: 2022-04-21
Class CT.IPMR.FP.AT.Adapter Extends (%Persistent, MA.IPMR.Abstract, User.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 适配器编码
Property FACode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 适配器节点
Property FANode As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 适配器描述
Property FADesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 主表指针
Property FASourceDr As CT.IPMR.FP.AT.Source;

/// 备注
Property FAResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexCode On (FASourceDr, FACode);

/// Creator：     zhouyang
/// CreatDate：   2022-04-21
/// Description:  取适配器项目
/// Table：       CT.IPMR.FP.AT.Adapter
/// Input：       Id : CT.IPMR.FP.AT.Adapter.ID
/// Return：      返回Object
/// w ##class(CT.IPMR.FP.AT.Adapter).GetObjById()
ClassMethod GetObjById(aId As %String) As CT.IPMR.FP.AT.Adapter
{
	new (aId)
	quit:'##class(CT.IPMR.FP.AT.Adapter).%ExistsId(aId) ""
	set obj=##Class(CT.IPMR.FP.AT.Adapter).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhouyang
/// CreatDate：   2022-04-21
/// Description:  更新适配器项目
/// Table：       CT.IPMR.FP.AT.Adapter
/// Input：       InputStr ：适配器数据
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(CT.IPMR.FP.AT.Adapter).Update("1^3^5^131^141","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID		= $p(aInputStr,aSeparate,1)
	Set Code 		= $p(aInputStr,aSeparate,2)
	Set Node		= $p(aInputStr,aSeparate,3)
	Set Desc 		= $p(aInputStr,aSeparate,4)
	Set SourceID	= $p(aInputStr,aSeparate,5)
	Set Resume	= $p(aInputStr,aSeparate,6)
	Quit:(Node="")||(SourceID="")||(Code="") return
	
	Set objSource = ##class(CT.IPMR.FP.AT.Source).GetObjById(SourceID)
	Quit:'$IsObject(objSource) return
		
	Set tID=$o(^CT.IPMR.FP.AT.AdapterI("IndexCode",SourceID," "_$zcvt(Code,"U"),0))
	Quit:(ID'="")&&(ID'=tID) -100
	Set ID = tID
	
	If ID="" {
		Set obj=##class(CT.IPMR.FP.AT.Adapter).%New()
	}Else{
		Set obj=##class(CT.IPMR.FP.AT.Adapter).%OpenId(ID)
	}
	Set obj.FACode			= Code
	Set obj.FANode			= Node
	Set obj.FADesc			= Desc
	Set obj.FASourceDr 		= objSource
	Set obj.FAResume		= Resume
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
/// CreatDate：   2022-04-21
/// Description:  删除适配器项目
/// Table：       CT.IPMR.FP.AT.Adapter
/// Input：       Id : CT.IPMR.FP.AT.Adapter.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##class(CT.IPMR.FP.AT.Adapter).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(CT.IPMR.FP.AT.Adapter).%DeleteId(aId)
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
<Data name="AdapterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FACode</Value>
</Value>
<Value name="3">
<Value>FANode</Value>
</Value>
<Value name="4">
<Value>FADesc</Value>
</Value>
<Value name="5">
<Value>FASourceDr</Value>
</Value>
<Value name="6">
<Value>FAResume</Value>
</Value>
</Data>
<DataLocation>^CT.IPMR.FP.AT.AdapterD</DataLocation>
<DefaultData>AdapterDefaultData</DefaultData>
<IdLocation>^CT.IPMR.FP.AT.AdapterD</IdLocation>
<IndexLocation>^CT.IPMR.FP.AT.AdapterI</IndexLocation>
<StreamLocation>^CT.IPMR.FP.AT.AdapterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
