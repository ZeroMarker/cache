/// 字典对照表
Class DHCWMR.SS.DicMapping Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 对照字典
Property DMTypeCode As %String(MAXLEN = 100, TRUNCATE = 1);

/// 源值
Property DMSrvVal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 源值-文本
Property DMSrvText As %String(MAXLEN = 100, TRUNCATE = 1);

/// 目标值
Property DMTargetVal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 目标值-文本
Property DMTargetText As %String(MAXLEN = 100, TRUNCATE = 1);

/// 备注
Property DMResume As %String(MAXLEN = 500, TRUNCATE = 1);

/// 对照类别索引
Index IndexTypeCode On DMTypeCode;

/// 对照类别和源ID索引
Index IndexTypeCodeSrvVal On (DMTypeCode, DMSrvVal) [ Unique ];

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-19
/// Description:  取字典对照
/// Table：       DHCWMR.SS.DicMapping
/// Input：       Id : DHCWMR.SS.DicMapping.ID
/// Return：      返回Object
/// w ##class(DHCWMR.SS.DicMapping).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCWMR.SS.DicMapping
{
	new (aId)
	quit:'##class(DHCWMR.SS.DicMapping).%ExistsId(aId) ""
	set obj=##Class(DHCWMR.SS.DicMapping).%OpenId(aId)
	do:obj'="" obj.%Close()
	quit obj
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-22
/// Description:  更新字典对照
/// Table：       DHCWMR.Srv.DicMapping
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCWMR.SS.DicMapping).Update("^Test^5^四联以上^5^四联以上^^","^")
ClassMethod Update(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate="^"
	
	Set ID=$p(aInputStr,aSeparate,1)
	Set Type=$p(aInputStr,aSeparate,2)
	Set SrvVal=$p(aInputStr,aSeparate,3)
	Set SrvVal=$tr(SrvVal," ","")
	Quit:(Type="")||(SrvVal="") return
	
	Set:ID="" ID=$o(^DHCWMR.SS.DicMappingI("IndexTypeCodeSrvVal"," "_$ZCVT(Type,"U")," "_$ZCVT(SrvVal,"U"),""))
	
	If (ID="") {
		Set obj=##class(DHCWMR.SS.DicMapping).%New()
	} Else {
		Set obj=##class(DHCWMR.SS.DicMapping).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.DMTypeCode   = Type
	Set obj.DMSrvVal     = SrvVal
	Set obj.DMSrvText    = $p(aInputStr,aSeparate,4)
	Set obj.DMTargetVal  = $p(aInputStr,aSeparate,5)
	Set obj.DMTargetText = $p(aInputStr,aSeparate,6)
	Set obj.DMResume     = $p(aInputStr,aSeparate,7)
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

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-22
/// Description:  删除字典对照
/// Table：       DHCWMR.SS.DicMapping
/// Input：       Id : DHCWMR.SS.DicMapping.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	new (aId)
	set return=0
	quit:aId="" return
	set sc = ##class(DHCWMR.SS.DicMapping).%DeleteId(aId)
	if $system.Status.IsError(sc) {  //检查删除是否成功
   		d $system.OBJ.DisplayError(sc) 
   		set return=-1
	}else{
		set return=1
	}
	quit return
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-22
/// Description:  按类别查询字典对照
/// Table：       DHCWMR.SS.DicMapping
/// Input：       
/// Do ##class(%ResultSet).RunQuery("DHCWMR.SS.DicMapping","QryByTypeCode","")
Query QryByTypeCode(TypeCode As %String) As %SQLQuery(ROWSPEC = "ID:%String,Type:%String,SrvValID:%String,SrvDesc:%String,Target:%String,TargetDesc:%String,Resume:%String")
{
	SELECT %ID,DMTypeCode,DMSrvVal,DMSrvText,DMTargetVal,DMTargetText,DMResume 
	FROM DHCWMR_SS.DicMapping 
	WHERE (DMTypeCode = :TypeCode) 
	ORDER BY DMSrvText
}

/// Creator：     zhouruimeng
/// CreatDate：   2014-08-22
/// Description:  按类别查询字典对照
/// Table：       DHCWMR.SS.DicMapping
/// Input：       
/// Do ##class(%ResultSet).RunQuery("DHCWMR.SS.DicMapping","QryByTypeCodeNew","Test","","","","")
Query QryByTypeCodeNew(aTypeCode As %String, aSrcValue As %String, aSrcDesc As %String, aTargetValue As %String, aTargetDesc As %String) As %Query(ROWSPEC = "ID:%String,SrcType:%String,SrcValID:%String,SrcValDesc:%String,Target:%String,TargetDesc:%String,Resume:%String")
{
}

ClassMethod QryByTypeCodeNewExecute(ByRef qHandle As %Binary, aTypeCode As %String, aSrcValue As %String, aSrcDesc As %String, aTargetValue As %String, aTargetDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aTypeCode="" $$$OK
 	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCWMR.SS.DicMappingI("IndexTypeCode"," "_$zcvt(aTypeCode,"U"),xID))
	 	Quit:xID=""
	 	
	 	Set objMap=##class(DHCWMR.SS.DicMapping).GetObjById(xID)
	 	Continue:'$IsObject(objMap)
	 	Set TypeCode    = objMap.DMTypeCode
	 	Set SrcValue    = objMap.DMSrvVal
	 	Set SrcDesc     = objMap.DMSrvText
	 	Set TargetValue = objMap.DMTargetVal
	 	Set TargetDesc  = objMap.DMTargetText
	 	Set ResumeText  = objMap.DMResume
	 	Continue:(aSrcValue'="")&&($zcvt(SrcValue,"U")'[$zcvt(aSrcValue,"U"))
	 	Continue:(aSrcDesc'="")&&($zcvt(SrcDesc,"U")'[$zcvt(aSrcDesc,"U"))
	 	Continue:(aTargetValue'="")&&($zcvt(TargetValue,"U")'[$zcvt(aTargetValue,"U"))
	 	Continue:(aTargetDesc'="")&&($zcvt(TargetDesc,"U")'[$zcvt(aTargetDesc,"U"))
	 	
	 	Set Data=$lb(xID,TypeCode,SrcValue,SrcDesc,TargetValue,TargetDesc,ResumeText)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
 	
	Quit $$$OK
}

ClassMethod QryByTypeCodeNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByTypeCodeNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryByTypeCodeNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByTypeCodeNewExecute ]
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
<Value>DMTypeCode</Value>
</Value>
<Value name="3">
<Value>DMSrvVal</Value>
</Value>
<Value name="4">
<Value>DMSrvText</Value>
</Value>
<Value name="5">
<Value>DMTargetVal</Value>
</Value>
<Value name="6">
<Value>DMTargetText</Value>
</Value>
<Value name="7">
<Value>DMResume</Value>
</Value>
</Data>
<DataLocation>^DHCWMR.SS.DicMappingD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWMR.SS.DicMappingD</IdLocation>
<IndexLocation>^DHCWMR.SS.DicMappingI</IndexLocation>
<StreamLocation>^DHCWMR.SS.DicMappingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
