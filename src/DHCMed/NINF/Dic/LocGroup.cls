/// 目标科室分组维护
/// 创建者：zhufei
/// 创建日期：2014-07-14
Class DHCMed.NINF.Dic.LocGroup Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 目标科室类型
Property Category As %String(TRUNCATE = 1);

/// 科室代码（CTLoc.ID）
Property DeptCode As %String(TRUNCATE = 1);

/// 科室名称
Property DeptDesc As %String(TRUNCATE = 1);

/// 目标值1
Property Target01 As %String(TRUNCATE = 1);

/// 目标值2
Property Target02 As %String(TRUNCATE = 1);

/// 备注
Property ResumeText As %String(TRUNCATE = 1);

/// 科室类别索引
Index IndexCategory On Category;

/// 科室类别和科室代码索引
Index IndexCateDeptCode On (Category, DeptCode) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2014-07-14
/// Description:  取目标科室分组维护数据
/// Table：       DHCMed.NINF.Dic.LocGroup
/// Input：       DHCMed.NINF.Dic.LocGroup.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.LocGroup).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.LocGroup
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.LocGroup).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2014-07-14
/// Description:  更新目标科室分组维护数据
/// Table：       DHCMed.NINF.Dic.LocGroup
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.LocGroup).Update("CombinedMed^5^四联以上^5^四联以上^^","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	Set Category=$p(aInput,aSeparate,2)
	Set DeptCode=$p(aInput,aSeparate,3)
	If (ID="")&&(Category'="")&&(DeptCode'="") {
		Set ID=$o(^DHCMed.NINFDi("LocGrp",0,"IndexCateDeptCode"," "_$ZCVT(Category,"U")," "_$ZCVT(DeptCode,"U"),""))
	}
	
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.LocGroup).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.LocGroup).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Category=$p(aInput,aSeparate,2)
	Set obj.DeptCode=$p(aInput,aSeparate,3)
	Set obj.DeptDesc=$p(aInput,aSeparate,4)
	Set obj.Target01=$p(aInput,aSeparate,5)
	Set obj.Target02=$p(aInput,aSeparate,6)
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
/// CreatDate：   2014-07-14
/// Description:  删除目标科室分组维护数据
/// Table：       DHCMed.NINF.Dic.LocGroup
/// Input：       DHCMed.NINF.Dic.LocGroup.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.LocGroup).%DeleteId(+aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-07-14
/// Description:  按类别查询目标科室分组维护数据
/// Table：       DHCMed.NINF.Dic.LocGroup
/// Input：       
/// Do ##class(%ResultSet).RunQuery("DHCMed.NINF.Dic.LocGroup","QryLocGrpByCate","","","")
Query QryLocGrpByCate(aCategory As %String, aDeptCode As %String, aDeptDesc As %String) As %Query(ROWSPEC = "ID:%String,Category:%String,DeptCode:%String,DeptDesc:%String,Target01:%String,Target02:%String,ResumeText:%String")
{
}

ClassMethod QryLocGrpByCateExecute(ByRef qHandle As %Binary, aCategory As %String, aDeptCode As %String, aDeptDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aCategory="" $$$OK
 	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMed.NINFDi("LocGrp",0,"IndexCategory"," "_$zcvt(aCategory,"U"),xID))
	 	Quit:xID=""
	 	
	 	Set objMap=##class(DHCMed.NINF.Dic.LocGroup).GetObjById(xID)
	 	Continue:'$IsObject(objMap)
	 	Set Category=objMap.Category
	 	Set DeptCode=objMap.DeptCode
	 	Set DeptDesc=objMap.DeptDesc
	 	Set Target01=objMap.Target01
	 	Set Target02=objMap.Target02
	 	Set ResumeText=objMap.ResumeText
	 	Continue:(aDeptCode'="")&&($zcvt(DeptCode,"U")'[$zcvt(aDeptCode,"U"))
	 	Continue:(aDeptDesc'="")&&($zcvt(DeptDesc,"U")'[$zcvt(aDeptDesc,"U"))
	 	
	 	Set Data=$lb(xID,Category,DeptCode,DeptDesc,Target01,Target02,ResumeText)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
 	
	Quit $$$OK
}

ClassMethod QryLocGrpByCateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocGrpByCateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLocGrpByCateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocGrpByCateExecute ]
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
<Value>DeptCode</Value>
</Value>
<Value name="4">
<Value>DeptDesc</Value>
</Value>
<Value name="5">
<Value>Target01</Value>
</Value>
<Value name="6">
<Value>Target02</Value>
</Value>
<Value name="7">
<Value>ResumeText</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINFD("LocGrp")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("LocGrp")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("LocGrp",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.LocGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
