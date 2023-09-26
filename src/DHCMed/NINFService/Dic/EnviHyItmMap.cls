/// 名称: DHCMed.NINFService.Dic.EnviHyItmMap
/// 描述: 环境卫生学监测报告 检测项目值判定标准的常用操作
/// 编写者：yhb
/// 编写日期: 2013-11-13
Class DHCMed.NINFService.Dic.EnviHyItmMap Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yhb
/// CreatDate：   2013-11-13
/// Description:  保存环境卫生学监测报告检测项目值判定标准
/// Table：       DHCMed.NINF.Dic.EnviHyItmMap
/// Input：       
/// Return：      
/// aSeparate 关联ID^标准ID^项目ID
/// w ##class(DHCMed.NINF.Dic.EnviHyItmMap).SaveRec("","^")
ClassMethod SaveRec(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	Quit:aInput="" return
	Set $ZT="SaveRecErr"
	Set EHNNormID=$p(aInput,aSeparate,2)
	Set EnviHyItemID=$p(aInput,aSeparate,3)
	Quit:(EnviHyItemID="")||(EHNNormID="") return
	Set return=##Class(DHCMed.NINF.Dic.EnviHyItmMap).Update(aInput,aSeparate)
	Quit return
SaveRecErr
	Quit "-999"
}

/// Creator：     yhb
/// CreatDate：   2013-11-19
/// Description:  根据检测项目值判定标准获取检测项目
/// Table：       DHCMed.NINF.Dic.EnviHyItmMap
/// Input：       
/// Return：      
/// w ##class(DHCMed.NINFService.Dic.EnviHyItmMap).getObjItem("1")
ClassMethod getObjItem(normID As %String) As %String
{
	New (normID)
	Set return = 0
	Quit:normID="" return
	Set $ZT="getItemErr"
	Set itemID = ""
	for {
		Set itemID = $o(^DHCMed.NINFDi("EHI",0,"MAP","IndexEHIMNorm",normID,itemID))
		Quit:itemID=""
		Set mapID = $o(^DHCMed.NINFDi("EHI",0,"MAP","IndexEHIMNorm",normID,itemID,""))
		Quit:mapID=""
		Set objMap = ##class(DHCMed.NINF.Dic.EnviHyItmMap).GetObjById(itemID_"||"_mapID)
		If $IsObject(objMap){
			if (objMap.EHIMIsActive){
				Set return = objMap.ParRef
			}
		}
	}
	q return
getItemErr
	Quit "-999"
}

/// Creator：     yhb
/// CreatDate：   2013-11-13
/// Description:  查询环境卫生学监测报告检测项目值判定标准
/// Table：       DHCMed.NINF.Dic.EnviHyItmMap
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Dic.EnviHyItmMap","QryEnviHyItmMap","1")
Query QryEnviHyItmMap(aEHIMNormID As %String) As %Query(ROWSPEC = "SubID:%String,EHIDescID:%String,EHIDesc:%String,EHNRange:%String,EHIMIsActive:%String,EHIMIsActiveDesc:%String,EHIMResume:%String")
{
}

ClassMethod QryEnviHyItmMapExecute(ByRef qHandle As %Binary, aEHIMNormID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Set ItemID=0
 	For {
	 	Set ItemID = $o(^DHCMed.NINFDi("EHI",0,"MAP","IndexEHIMNorm",aEHIMNormID,ItemID))
	 	Quit:ItemID=""
	 	Set SubID = 0
	 	for {
		 	Set SubID = $o(^DHCMed.NINFDi("EHI",0,"MAP","IndexEHIMNorm",aEHIMNormID,ItemID,SubID))
		 	Quit:SubID=""
		 	Set obj=##class(DHCMed.NINF.Dic.EnviHyItmMap).GetObjById(ItemID_"||"_SubID)
		 	Continue:'$IsObject(obj)
		 	Set (EHIDesc,EHNRange,EHIMResume)=""
		 	If $IsObject(obj.EHIMNorm) {
				Set EHNRange=obj.EHIMNorm.EHNRange
			}
		 	Set EHIMIsActive=obj.EHIMIsActive
		 	Set EHIMIsActiveDesc=$s(EHIMIsActive=1:"是",1:"否")
		 	Set EHIMResume=obj.EHIMResume
		 	Set EHIDescID = obj.ParRef.%Id()
		 	Set EHIDesc = obj.ParRef.EHIDesc
		 	Set Data=$lb(SubID,EHIDescID,EHIDesc,EHNRange,EHIMIsActive,EHIMIsActiveDesc,EHIMResume)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}	
	}
	Quit $$$OK
}

ClassMethod QryEnviHyItmMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryEnviHyItmMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryEnviHyItmMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryEnviHyItmMapExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Storage Default
{
<StreamLocation>^DHCMed.NINFSe3F54.EnviHyItmMapS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
