/// 操作项目定义
Class DHCWMR.SS.WorkItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property WICode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property WIDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property WIResume As %String(MAXLEN = 500, TRUNCATE = 1);

Index IndexCode On WICode [ Unique ];

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-19
/// Description:  取病案操作项目
/// Table：       DHCWMR.SS.WorkItem
/// Input：       Id : DHCWMR.SS.WorkItem.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.WorkItem).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.WorkItem
{
	new (aId)
	quit:'##class(DHCWMR.SS.WorkItem).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.WorkItem).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-19
/// Description:  更新病案操作项目
/// Table：       DHCWMR.SS.WorkItem
/// Input：       InputStr ：记录信息（1ID、2代码、3描述、4备注）
///               Separate : 分隔符
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.SS.WorkItem).Update("","")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:(aInputStr="")||(aSeparate="") return
	
	Set ID       = $p(aInputStr,aSeparate,1)
	Set Code   = $p(aInputStr,aSeparate,2)
	Set Desc   = $p(aInputStr,aSeparate,3)
	Set Resume = $p(aInputStr,aSeparate,4)
	Quit:(Code="")||(Desc="") return
	
	//Set:ID="" ID=$o(^DHCWMR.SS.WorkItemI("IndexCode"," "_$zcvt(Code,"U"),0))
	Quit:(ID="")&&($o(^DHCWMR.SS.WorkItemI("IndexCode"," "_$zcvt(Code,"U"),0))) -100
	
	If ID="" {
		Set obj=##class(DHCWMR.SS.WorkItem).%New()
	}Else{
		Set obj=##class(DHCWMR.SS.WorkItem).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.WICode   = Code
	Set obj.WIDesc   = Desc
	Set obj.WIResume = Resume
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

/// Creator：     liyi
/// CreatDate：   2014-08-22
/// Description:  取操作项目列表
/// Table：       DHCWMR.SS.WorkItem
/// Input：       无
/// Return：      返回String(操作项目ID $c(2) 操作项目名称 $c(1) ...)
/// Dubug: 		  w ##Class(DHCWMR.SS.WorkItem).GetWorkItems()
ClassMethod GetWorkItems() As %String
{
	New
	Set return=""
	
	Set xID=""
 	For {
	 	Set xID=$o(^DHCWMR.SS.WorkItemD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=..GetObjById(xID)
	 	Quit:'$IsObject(obj)
	 	
	 	Set ItemID=obj.%Id()
	 	Set ItemDesc=obj.WIDesc
	 	
	 	Set return=return_$c(1)_ItemID_$c(2)_ItemDesc
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-08-13
/// Description:  删除病案操作项目
/// Table：       DHCWMR.SS.WorkItem
/// Input：       Id : DHCWMR.SS.WorkItem.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.WorkItem).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

///    Creator：     liyi
///    CreatDate：   2014-08-20
///    Description:  查询操作项目定义
///    Table：       DHCWMR.SS.WorkItem
///    Input：       无
///    Return：      返回Query
///    D ##class(%ResultSet).RunQuery("DHCWMR.SS.WorkItem","QueryWorkItem")
Query QueryWorkItem() As %Query(ROWSPEC = "ID:%String,ItemCode:%String,ItemDesc:%String,ItemResume:%String")
{
}

ClassMethod QueryWorkItemExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=""
 	For {
	 	Set xID=$o(^DHCWMR.SS.WorkItemD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCWMR.SS.WorkItem).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ID=obj.%Id()
	 	Set ItemCode=obj.WICode
	 	Set ItemDesc=obj.WIDesc
		Set ItemResume=obj.WIResume
		
		Set Data=$lb(ID,ItemCode,ItemDesc,ItemResume)
		Set ^CacheTemp(repid,ind)=Data 
		Set ind=ind+1
	} 	
 	
	Quit $$$OK
}

ClassMethod QueryWorkItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryWorkItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryWorkItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryWorkItemExecute ]
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
<Value>WICode</Value>
</Value>
<Value name="3">
<Value>WIDesc</Value>
</Value>
<Value name="4">
<Value>WIResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.WorkItemD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.WorkItemD</IdLocation>
<IndexLocation>^DHCWMR.SS.WorkItemI</IndexLocation>
<StreamLocation>^DHCWMR.SS.WorkItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
