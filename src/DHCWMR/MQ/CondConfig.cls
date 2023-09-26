/// 查询条件配置
Class DHCWMR.MQ.CondConfig Extends (%Persistent, DHCWMR.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

Relationship ChildCol As DHCWMR.MQ.CondColConfig [ Cardinality = children, Inverse = ParRef ];

/// 名称
Property CCDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 日期类型
Property CCDateType As %String(MAXLEN = 100, TRUNCATE = 1);

/// 输入条件
Property CCInputStr As %String(MAXLEN = 5000, TRUNCATE = 1);

Index IndexDesc On CCDesc [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2014-12-23
/// Description:  取查询条件配置
/// Table：       DHCWMR.MQ.CondConfig
/// Input：       ID : DHCWMR.MQ.CondConfig.ID
/// Return：      返回obj
/// w ##class(DHCWMR.MQ.CondConfig).GetObjById()
ClassMethod GetObjById(aId As %String) As DHCWMR.MQ.CondConfig
{
	new (aId)
	set return=""
	quit:aId="" return
	quit:'##class(DHCWMR.MQ.CondConfig).%ExistsId(aId) return
	set obj=##Class(DHCWMR.MQ.CondConfig).%OpenId(aId)
	set return=obj
	do obj.%Close()
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-23
/// Description:  更新查询条件配置
/// Table：       DHCWMR.MQ.CondConfig
/// Input：       InputStr ：查询条件内容
///               Separate : 分隔符（不允许带"^"）
/// Return：      成功：返回id，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.CondConfig).Update("^查询配置1^1^年龄大于1")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Quit:aInputStr="" return
	Set ID=$p(aInputStr,aSeparate,1)
	Set Desc=$p(aInputStr,aSeparate,2)
	Set DateType=$p(aInputStr,aSeparate,3)
	Set InputStr=$p(aInputStr,aSeparate,4)
	Quit:(Desc="")||($tr(Desc," ","")="") return
	//Quit:(InputStr="") return
	
	Set ID=$o(^DHCWMR.MQ.CondConfigI("IndexDesc"," "_$zcvt(Desc,"U"),0))
	
	If (ID="") {
		Set obj=##class(DHCWMR.MQ.CondConfig).%New()
	} Else {
		Set obj=##class(DHCWMR.MQ.CondConfig).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.CCDesc=Desc
	Set obj.CCDateType=DateType
	Set obj.CCInputStr=InputStr
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-23
/// Description:  删除查询条件配置
/// Table：       DHCWMR.MQ.CondConfig
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.CondConfig).DeleteById()
ClassMethod DeleteById(aId As %String) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.MQ.CondConfig).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     liyi
/// CreatDate：   2016-04-03
/// Description:  删除一条配置中第几个条件查询条件
/// Table：       DHCWMR.MQ.CondConfig
/// Input：       Id
/// Return：      成功：返回0，失败：返回<0的代码
/// w ##class(DHCWMR.MQ.CondConfig).DeleteInputStr(1,3)
ClassMethod DeleteInputStr(aCondID As %String, aIndex As %String) As %String
{
	New (aCondID,aIndex)
	Set return=0
	Quit:(aCondID="")||(aIndex="") return
	
	Set obj = ##class(DHCWMR.MQ.CondConfig).%OpenId(aCondID)
	Quit:'$isobject(obj) return
	
	Set InputStr=obj.CCInputStr
	Quit:InputStr="" return
	
	//重新组织输入条件
	Set NewInputStr=""
	For indInput=1:1:$l(InputStr,$c(1)) {
		Continue:indInput=aIndex
		Set tmpInput=$p(InputStr,$c(1),indInput)
		Continue:tmpInput=""
		Set NewInputStr = NewInputStr_$c(1)_tmpInput
	}
	Set obj.CCDesc=obj.CCDesc
	Set obj.CCDateType=obj.CCDateType
	Set obj.CCInputStr=NewInputStr
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {  //检查Save是否成功
   		Do $System.OBJ.DisplayError(sc)
   		Set return=-1
	} Else {
		Set return=obj.%Id()
	}

	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-23
/// Description:  查询条件配置列表
/// Table：       DHCWMR.MQ.CondConfig
/// Input：       
/// Return：      返回Query
/// d ##class(%ResultSet).RunQuery("DHCWMR.MQ.CondConfig","QryCondCfg")
Query QryCondCfg() As %Query(ROWSPEC = "ID:%String,Desc:%String")
{
}

ClassMethod QryCondCfgExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xID=0
	For {
		Set xID=$o(^DHCWMR.MQ.CondConfigD(xID))
		Quit:xID=""
		
		Set obj=##class(DHCWMR.MQ.CondConfig).GetObjById(xID)
		Continue:'$IsObject(obj)
		Set Desc=obj.CCDesc
		
		Set Data=$lb(xID,Desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	if (ind=1){
		Set ^CacheTemp(repid,ind)=$lb("-1","默认样式")
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryCondCfgClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCondCfgExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCondCfgFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCondCfgExecute ]
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
<Value>CCDesc</Value>
</Value>
<Value name="3">
<Value>CCDateType</Value>
</Value>
<Value name="4">
<Value>CCInputStr</Value>
</Value>
<Value name="5">
<Value>CCOutputStr</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.MQ.CondConfigD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.MQ.CondConfigD</IdLocation>
<IndexLocation>^DHCWMR.MQ.CondConfigI</IndexLocation>
<StreamLocation>^DHCWMR.MQ.CondConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
