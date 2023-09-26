/// ICU三管医嘱项维护
/// 创建者：zhufei
/// 创建日期：2013-08-21
Class DHCMed.NINF.Dic.ICUIntubate Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 对照类型
Property Category As %String(TRUNCATE = 1);

/// 源值
Property ObjectID As %String(TRUNCATE = 1);

/// 源值描述
Property ObjectDesc As %String(TRUNCATE = 1);

/// 目标值
Property Target01 As %String(TRUNCATE = 1);

/// 目标值描述
Property Target02 As %String(TRUNCATE = 1);

/// 备注
Property ResumeText As %String(TRUNCATE = 1);

/// 对照类别索引
Index IndexCategory On Category;

/// 对照类别和源ID索引
Index IndexCateObjectID On (Category, ObjectID) [ Unique ];

/// Creator：     zhufei
/// CreatDate：   2013-08-21
/// Description:  取ICU三管医嘱项维护数据
/// Table：       DHCMed.NINF.Dic.ICUIntubate
/// Input：       DHCMed.NINF.Dic.ICUIntubate.ID
/// Return：      返回obj
/// w ##class(DHCMed.NINF.Dic.ICUIntubate).GetObjById(1)
ClassMethod GetObjById(aId As %String) As DHCMed.NINF.Dic.ICUIntubate
{
	New (aId)
	Set obj=##Class(DHCMed.NINF.Dic.ICUIntubate).%OpenId(aId)
	Do:obj'="" obj.%Close()
	Quit obj
}

/// Creator：     zhufei
/// CreatDate：   2013-08-21
/// Description:  更新ICU三管医嘱项维护数据
/// Table：       DHCMed.NINF.Dic.ICUIntubate
/// Input：       "^"分隔
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCMed.NINF.Dic.ICUIntubate).Update("CombinedMed^5^四联以上^5^四联以上^^","^")
ClassMethod Update(aInput As %String, aSeparate As %String = "") As %String
{
	New (aInput,aSeparate)
	Set return=0
	Set:aSeparate="" aSeparate=..#SEPARATE
	
	Set ID=$p(aInput,aSeparate,1)
	Set Category=$p(aInput,aSeparate,2)
	Set SrcID=$p(aInput,aSeparate,3)
	If (ID="")&&(Category'="")&&(SrcID'="") {
		Set ID=$o(^DHCMed.NINFDi("ICUIntu",0,"IndexCateObjectID"," "_$ZCVT(Category,"U")," "_$ZCVT(SrcID,"U"),""))
	}
	
	If (ID="") {
		Set obj=##class(DHCMed.NINF.Dic.ICUIntubate).%New()
	} Else {
		Set obj=##class(DHCMed.NINF.Dic.ICUIntubate).%OpenId(ID)
	}
	Quit:'$IsObject(obj) return
	
	Set obj.Category=$p(aInput,aSeparate,2)
	Set obj.ObjectID=$p(aInput,aSeparate,3)
	Set obj.ObjectDesc=$p(aInput,aSeparate,4)
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
/// CreatDate：   2013-08-21
/// Description:  删除ICU三管医嘱项维护数据
/// Table：       DHCMed.NINF.Dic.ICUIntubate
/// Input：       DHCMed.NINF.Dic.ICUIntubate.ID
/// Return：      return>0:成功  return<=0:失败
ClassMethod DeleteById(aId) As %String
{
	New (aId)
	Set return=0
	Set sc = ##class(DHCMed.NINF.Dic.ICUIntubate).%DeleteId(+aId)
	If $System.Status.IsError(sc) {            //检查删除是否成功
   		Do $system.OBJ.DisplayError(sc) 
   		Set return=-1
	} Else {
		Set return=1
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2013-08-21
/// Description:  按类别查询ICU三管医嘱项维护数据
/// Table：       DHCMed.NINF.Dic.ICUIntubate
/// Input：       
/// Do ##class(%ResultSet).RunQuery("DHCMed.NINF.Dic.ICUIntubate","QryICUIntuByCate","MKDiagnos","霍乱","","","")
Query QryICUIntuByCate(aCategory As %String, aSrcValue As %String, aSrcDesc As %String) As %Query(ROWSPEC = "ID:%String,Category:%String,ObjectID:%String,ObjectDesc:%String,Target01:%String,Target02:%String,ResumeText:%String")
{
}

ClassMethod QryICUIntuByCateExecute(ByRef qHandle As %Binary, aCategory As %String, aSrcValue As %String, aSrcDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aCategory="" $$$OK
 	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMed.NINFDi("ICUIntu",0,"IndexCategory"," "_$zcvt(aCategory,"U"),xID))
	 	Quit:xID=""
	 	
	 	Set objMap=##class(DHCMed.NINF.Dic.ICUIntubate).GetObjById(xID)
	 	Continue:'$IsObject(objMap)
	 	Set Category=objMap.Category
	 	Set SrcValue=objMap.ObjectID
	 	Set SrcDesc=objMap.ObjectDesc
	 	Set Target01=objMap.Target01
	 	Set Target02=objMap.Target02
	 	Set ResumeText=objMap.ResumeText
	 	Continue:(aSrcValue'="")&&($zcvt(SrcValue,"U")'[$zcvt(aSrcValue,"U"))
	 	Continue:(aSrcDesc'="")&&($zcvt(SrcDesc,"U")'[$zcvt(aSrcDesc,"U"))
	 	
	 	Set Data=$lb(xID,Category,SrcValue,SrcDesc,Target01,Target02,ResumeText)
	 	Set ^CacheTemp(repid,ind)=Data
	 	Set ind=ind+1
	}
 	
	Quit $$$OK
}

ClassMethod QryICUIntuByCateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUIntuByCateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICUIntuByCateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUIntuByCateExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2014-07-04
/// Description:  获取插管医嘱列表,多值逗号分隔
/// Table：       DHCMed.NINF.Dic.ICUIntubate
/// Input：       导管类型
/// Return：      return'="":成功  return="":失败  多值英文逗号分隔
/// w ##Class(DHCMed.NINF.Dic.ICUIntubate).GetIntuOEList()
ClassMethod GetIntuOEList(aCategory As %String) As %String
{
	New (aCategory)
	Set return=""
	Quit:aCategory="" return
	
 	Set xID=0
 	For {
	 	Set xID=$o(^DHCMed.NINFDi("ICUIntu",0,"IndexCategory"," "_$zcvt(aCategory,"U"),xID))
	 	Quit:xID=""
	 	
	 	Set objMap=##class(DHCMed.NINF.Dic.ICUIntubate).GetObjById(xID)
	 	Continue:'$IsObject(objMap)
	 	Set Category=objMap.Category
	 	Set SrcValue=objMap.ObjectID
	 	Continue:SrcValue=""
	 	Set SrcDesc=objMap.ObjectDesc
	 	Set Target01=objMap.Target01
	 	Set Target02=objMap.Target02
	 	Set ResumeText=objMap.ResumeText
        Set return=return_","_SrcValue
    }
    Set:return'="" return=$e(return,2,$l(return))
 	
	Quit return
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
<Value>ObjectID</Value>
</Value>
<Value name="4">
<Value>ObjectDesc</Value>
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
<DataLocation>^DHCMed.NINFD("ICUIntu")</DataLocation>
<DefaultData>DefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINFD("ICUIntu")</IdLocation>
<IndexLocation>^DHCMed.NINFDi("ICUIntu",0)</IndexLocation>
<StreamLocation>^DHCMed.NINF.Dic.ICUIntubateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
