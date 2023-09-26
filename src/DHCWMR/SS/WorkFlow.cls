/// 工作流定义
Class DHCWMR.SS.WorkFlow Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildItem As DHCWMR.SS.WorkFItem [ Cardinality = children, Inverse = Parref ];

/// 代码
Property WFCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 描述
Property WFDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property WFResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  取工作流
/// Table：       DHCWMR.SS.WorkFlow
/// Input：       Id : DHCWMR.SS.WorkFlow.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.WorkFlow).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.WorkFlow
{
	new (aId)
	quit:'##class(DHCWMR.SS.WorkFlow).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.WorkFlow).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-09-18
/// Description:  根据病案类型和操作项取工作流项目
/// Table：       DHCWMR.SS.WorkFItem
/// Input：       MrTypeID : 病案类型ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.WorkFlow).GetWorkFlow(1)
ClassMethod GetWorkFlow(aMrTypeID As %String) As DHCWMR.SS.WorkFlow
{
	new (aMrTypeID)
	set return=""
	quit:aMrTypeID="" return
	
	set objMrType=##class(DHCWMR.SS.MrType).GetObjById(aMrTypeID)
	quit:'$IsObject(objMrType) return
	quit:'$IsObject(objMrType.MTWorkFlow) return
	set return=objMrType.MTWorkFlow
	quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  更新工作流
/// Table：       DHCWMR.SS.WorkFlow
/// Input：       InputStr : ID^代码^描述^备注
///               Separate : 分隔符
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.SS.WorkFlow).Update("1^1^顺序工作^备注","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set Code=$p(aInputStr,aSeparate,2)
	Set Desc=$p(aInputStr,aSeparate,3)
	Set Resume=$p(aInputStr,aSeparate,4)
	Quit:(Code="")||(Desc="") return
	
	If ID="" {
		Set obj=##class(DHCWMR.SS.WorkFlow).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.WorkFlow).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.WFCode    = Code
	Set obj.WFDesc    = Desc
	Set obj.WFResume  = Resume
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

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  删除工作流
/// Table：       DHCWMR.SS.WorkFlow
/// Input：       Id : DHCWMR.SS.WorkFlow.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCWMR.SS.WorkFlow).%DeleteId(aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

///    Creator：     liyi
///    CreatDate：   2014-08-20
///    Description:  查询工作流定义
///    Table：       DHCWMR.SS.WorkFlow
///    Input：       无
///    Return：      返回Query
///    D ##class(%ResultSet).RunQuery("DHCWMR.SS.WorkFlow","QryWorkFlow")
Query QryWorkFlow() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Resume:%String")
{
}

ClassMethod QryWorkFlowExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	For {
	 	Set xID=$o(^DHCWMR.SS.WorkFlowD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCWMR.SS.WorkFlow).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ID=obj.%Id()
	 	Set Code=obj.WFCode
	 	Set Desc=obj.WFDesc
		Set Resume=obj.WFResume
		
		Set Data=$lb(ID,Code,Desc,Resume)
		Set ^CacheTemp(repid,ind)=Data 
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryWorkFlowClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryWorkFlowExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryWorkFlowFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryWorkFlowExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WFCode</Value>
</Value>
<Value name="3">
<Value>WFDesc</Value>
</Value>
<Value name="4">
<Value>WFResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.WorkFlowD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.WorkFlowD</IdLocation>
<IndexLocation>^DHCWMR.SS.WorkFlowI</IndexLocation>
<StreamLocation>^DHCWMR.SS.WorkFlowS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
