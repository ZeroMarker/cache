/// 病案分类定义
Class DHCWMR.SS.MrClass Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 代码
Property MCCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 名称
Property MCDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property MCResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 病案分类代码 索引
Index IndexCode On MCCode [ Unique ];

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-22
/// Description:  根据ID取病案分类
/// Table：       DHCWMR.SS.MrClass
/// Input：       Id : DHCWMR.SS.MrClass.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.MrClass).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.MrClass
{
	new (aId)
	quit:'##class(DHCWMR.SS.MrClass).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.MrClass).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-22
/// Description:  更新病案分类
/// Table：       DHCWMR.SS.MrClass
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.SS.MrClass).Update("^I^住院^测试^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	new (aInputStr,aSeparate)
	set return=0
	quit:aInputStr="" return
	
	set ID       = $p(aInputStr,aSeparate,1)
	set Code     = $p(aInputStr,aSeparate,2)
	set Desc     = $p(aInputStr,aSeparate,3)
	set Resume   = $p(aInputStr,aSeparate,4)
	quit:(Desc="")||(Code="") return
	
	//set:ID="" ID=$o(^DHCWMR.SS.MrClassI("IndexCode"," "_$zcvt(Code,"U"),0))
	Quit:(ID="")&&($o(^DHCWMR.SS.MrClassI("IndexCode"," "_$zcvt(Code,"U"),0))) -100
	
	if ID="" {
		set obj=##class(DHCWMR.SS.MrClass).%New()
	}else{
		set obj=##class(DHCWMR.SS.MrClass).%OpenId(ID)
	}
	quit:'$IsObject(obj) return
	
	set obj.MCCode     = Code
	set obj.MCDesc     = Desc
	set obj.MCResume   = Resume
	set sc=obj.%Save()
	if $system.Status.IsError(sc) {        //检查Save是否成功
   		do $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=obj.%Id()
	}
	do obj.%Close()
	
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-22
/// Description:  删除病案分类
/// Table：       DHCWMR.SS.MrClass
/// Input：       Id : DHCWMR.SS.MrClass.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.MrClass).%DeleteId(aId)
	if $system.Status.IsError(sc) {            //检查删除是否成功
   		d $system.OBJ.DisplayError(sc)
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-22
/// Description:  根据Code查询病案分类
/// Table：       DHCWMR.SS.MrClass
/// Input：       aCode
/// Return：      返回Object
/// w ##class(DHCWMR.SS.MrClass).GetObjByCode("I")
ClassMethod GetObjByCode(aCode As %String) As DHCWMR.SS.MrClass
{
	New (aCode)
	Set return=""
	Quit:aCode="" return
	
	Set ID=$o(^DHCWMR.SS.MrClassI("IndexCode"," "_$zcvt(aCode,"U"),0))
	Quit:ID="" return
	
	Set obj=..GetObjById(ID)
	Quit:'$IsObject(obj) return
	Set return=obj
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2014-08-20
/// Description:  查询病案分类
/// Table：       DHCWMR.SS.MrClass
/// Input：       无
/// Return：      返回Query
/// Do ##class(%ResultSet).RunQuery("DHCWMR.SS.MrClass","QryMrClass")
Query QryMrClass() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,Resume:%String")
{
}

ClassMethod QryMrClassExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCWMR.SS.MrClassD(xID))
	 	Quit:xID=""
	 	
	 	Set obj=##class(DHCWMR.SS.MrClass).GetObjById(xID)
	 	Continue:'$IsObject(obj)
	 	
	 	Set ID=xID
	 	Set Code = obj.MCCode
	 	Set Desc = obj.MCDesc
	 	Set Resume = obj.MCResume
	 	
	 	Set Data=$lb(ID,Code,Desc,Resume)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryMrClassClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMrClassExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryMrClassFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMrClassExecute ]
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
<Value>MCCode</Value>
</Value>
<Value name="3">
<Value>MCDesc</Value>
</Value>
<Value name="4">
<Value>MCResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.MrClassD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.MrClassD</IdLocation>
<IndexLocation>^DHCWMR.SS.MrClassI</IndexLocation>
<StreamLocation>^DHCWMR.SS.MrClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
