/// 接口字典对照数据
/// 创建者：zhufei
/// 创建日期：2015-02-25
Class DHCMed.EPD.IOMapping Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock ]
{

/// 对照类型
Property Category As %String(TRUNCATE = 1);

/// 源值
Property SrcObjectID As %String(TRUNCATE = 1);

/// 源值描述
Property SrcDescription As %String(TRUNCATE = 1);

/// 目标值
Property Target As %String(TRUNCATE = 1);

/// 目标值描述
Property TargetDesc As %String(TRUNCATE = 1);

/// 备注
Property ResumeText As %String(TRUNCATE = 1);

/// 对照类别索引
Index IndexCategory On Category;

/// 对照类别和源ID索引
Index IndexCategorySrcID On (Category, SrcObjectID) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2015-02-25
/// Description:  取接口字典对照
/// Table：       DHCMed.EPD.IOMapping
/// Input：       DHCMed.EPD.IOMapping.ID
/// Return：      返回obj
/// w ##class(DHCMed.EPD.IOMapping).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.EPD.IOMapping
{
	New (aId)
	Set obj=##Class(DHCMed.EPD.IOMapping).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2015-02-25
/// Description:  取接口字典对照
/// Table：       DHCMed.EPD.IOMapping
/// Input：       Category       字典分类
///               SrcObjectID    源数据ID
/// Return：      返回String
/// w ##class(DHCMed.EPD.IOMapping).GetMappingData("","")
ClassMethod GetMappingData(Category As %String, SrcObjectID As %String) As %String
{
	New (Category,SrcObjectID)
	Set return=""
	Quit:(Category="")||(SrcObjectID="") return
	
	Set SrcObjectID=##class(DHCMed.NINFService.Srv.CommonCls).Trim(SrcObjectID)
	Set ID=$o(^DHCMed.EPD.IOMappingI("IndexCategorySrcID"," "_$ZCVT(Category,"U")," "_$ZCVT(SrcObjectID,"U"),""))
	Quit:ID="" return
	
	Set return=..GetObjById(ID)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-02-25
/// Description:  更新接口字典对照
/// Table：       DHCMed.EPD.IOMapping
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.EPD.IOMapping).Update("CombinedMed^5^四联以上^5^四联以上^^","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	Set Category=$p(aInput,aSeparate,2)
	Set SrcID=$p(aInput,aSeparate,3)
	Set SrcID=$tr(SrcID," ","")
	
	If ((Category'="")&&(SrcID'="")) {
		Set tID=$o(^DHCMed.EPD.IOMappingI("IndexCategorySrcID"," "_$ZCVT(Category,"U")," "_$ZCVT(SrcID,"U"),""))
		Quit:tID'=ID -2
	}
	
	If (ID="") {
		Set obj=##class(DHCMed.EPD.IOMapping).%New()
	} Else {
		Set obj=##class(DHCMed.EPD.IOMapping).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Category=$p(aInput,aSeparate,2)
	Set obj.SrcObjectID=SrcID
	Set obj.SrcDescription=$p(aInput,aSeparate,4)
	Set obj.Target=$p(aInput,aSeparate,5)
	Set obj.TargetDesc=$p(aInput,aSeparate,6)
	Set obj.ResumeText=$p(aInput,aSeparate,7)
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

/// Creator：     zhufei
/// CreatDate：   2015-02-25
/// Description:  删除接口字典对照
/// Table：       DHCMed.EPD.IOMapping
/// Input：       DHCMed.EPD.IOMapping.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.EPD.IOMapping).%DeleteId(+aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-06-14
/// Description:  按类别查询传染病字典对照
/// Table：       DHCMed.EPD.IOMapping
/// Input：       
/// Do ##class(%ResultSet).RunQuery("DHCMed.EPD.IOMapping","QryByCategoryNew","EPIDEMICSIMPLESOURCE","","","","")
Query QryByCategoryNew(aCategory As %String, aSrcValue As %String, aSrcDesc As %String, aTargetValue As %String, aTargetDesc As %String) As %Query(ROWSPEC = "ID:%String,Category:%String,SrcObjectID:%String,SrcDescription:%String,Target:%String,TargetDesc:%String,ResumeText:%String")
{
}

ClassMethod QryByCategoryNewExecute(ByRef qHandle As %Binary, aCategory As %String, aSrcValue As %String, aSrcDesc As %String, aTargetValue As %String, aTargetDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aCategory="" $$$OK
 	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMed.EPD.IOMappingI("IndexCategory"," "_$zcvt(aCategory,"U"),xID))
	 	Quit:xID=""
	 	Set objMap=..GetObjById(xID)
	 	Continue:'$IsObject(objMap)
	 	Set Category=objMap.Category
	 	Set SrcValue=objMap.SrcObjectID
	 	Set SrcDesc=objMap.SrcDescription
	 	Set TargetValue=objMap.Target
	 	Set TargetDesc=objMap.TargetDesc
	 	Set ResumeText=objMap.ResumeText
	 	Continue:(aSrcValue'="")&&($zcvt(SrcValue,"U")'[$zcvt(aSrcValue,"U"))
	 	Continue:(aSrcDesc'="")&&($zcvt(SrcDesc,"U")'[$zcvt(aSrcDesc,"U"))
	 	Continue:(aTargetValue'="")&&($zcvt(TargetValue,"U")'[$zcvt(aTargetValue,"U"))
	 	Continue:(aTargetDesc'="")&&($zcvt(TargetDesc,"U")'[$zcvt(aTargetDesc,"U"))
	 	
	 	Set Data=$lb(xID,Category,SrcValue,SrcDesc,TargetValue,TargetDesc,ResumeText)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
 	
	Quit $$$OK
}

ClassMethod QryByCategoryNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryByCategoryNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryByCategoryNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryByCategoryNewExecute ]
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
<Value>Category</Value>
</Value>
<Value name="3">
<Value>SrcObjectID</Value>
</Value>
<Value name="4">
<Value>SrcDescription</Value>
</Value>
<Value name="5">
<Value>Target</Value>
</Value>
<Value name="6">
<Value>TargetDesc</Value>
</Value>
<Value name="7">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMed.EPD.IOMappingD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^DHCMed.EPD.IOMappingI</IdLocation>
<IndexLocation>^DHCMed.EPD.IOMappingI</IndexLocation>
<StreamLocation>^DHCMed.EPD.IOMappingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
