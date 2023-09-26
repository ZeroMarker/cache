/// 名称: DHCHAI.RMES.ResultTypeSrv
/// 描述: 实体类型相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-09
Class DHCHAI.RMES.ResultTypeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  查询实体类型信息
/// Table：       DHCHAI.RME.ResultType
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.ResultTypeSrv","QryResultType")
Query QryResultType() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,CatID:%String,CatCode:%String,CatDesc:%String")
{
}

ClassMethod QryResultTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.RME.ResultTypeI("IndexCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.RME.ResultTypeI("IndexCode",xCode,xID))
			Quit:xID=""
			Set objRltType = ##class(DHCHAI.RME.ResultType).GetObjById(xID)
			Continue:'$isobject(objRltType)
			
			Set Code = objRltType.BTCode
			Set Desc = objRltType.BTDesc
			Set CatID="",CatCode="",CatDesc=""
			If $IsObject(objRltType.BTCatDr){
				Set CatID   = objRltType.BTCatDr.%Id()
				Set CatCode = objRltType.BTCatDr.BTCode
				Set CatDesc = objRltType.BTCatDr.BTDesc
			}
			Set Data = $lb(xID,Code,Desc,CatID,CatCode,CatDesc)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryResultTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryResultTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryResultTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryResultTypeExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2018-08-26
/// Description:  导入实体类型
/// w ##Class(DHCHAI.RMES.ResultTypeSrv).ImportDic("^<SYMPTOM(+)>^症状(+)^<SYMPTOM>^症状")
ClassMethod ImportDic(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set Code    = $p(aInputStr,"^",2)
	Set Desc    = $p(aInputStr,"^",3)
	Set CatCode = $p(aInputStr,"^",4)
	Set CatDesc = $p(aInputStr,"^",5)
	Quit:(Code="")||(Desc="") return
	
	Set CatDr=""
	Set objResultCat=##class(DHCHAI.RME.ResultCat).GetObjByCode(CatCode)
	If $IsObject(objResultCat) {
		Set CatDr=objResultCat.%Id()
	}
	Set InputStr=CatDr_"^"_CatCode_"^"_CatDesc
	Set CatDr=##Class(DHCHAI.RME.ResultCat).Update(InputStr,"^")
	
	Set ResultTypeDr=""
	Set objResultType=##class(DHCHAI.RME.ResultType).GetObjByCode(Code)
	If $IsObject(objResultType) {
		Set ResultTypeDr=objResultType.%Id()
	}
	Set InputStr=ResultTypeDr_"^"_Code_"^"_Desc_"^"_CatDr
	Set return=##Class(DHCHAI.RME.ResultType).Update(InputStr,"^")
	Quit return
}

}
