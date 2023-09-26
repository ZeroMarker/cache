/// 名称: DHCHAI.RMES.DocTypeSrv
/// 描述: 文档类型相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-09
Class DHCHAI.RMES.DocTypeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  查询文档类型信息
/// Table：       DHCHAI.RME.DocType
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.DocTypeSrv","QryDocType")
Query QryDocType() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String")
{
}

ClassMethod QryDocTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.RME.DocTypeI("IndexCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.RME.DocTypeI("IndexCode",xCode,xID))
			Quit:xID=""
			Set objDocType = ##class(DHCHAI.RME.DocType).GetObjById(xID)
			Continue:'$isobject(objDocType)
			
			Set Code = objDocType.BTCode
			Set Desc = objDocType.BTDesc
			
			Set Data = $lb(xID,Code,Desc)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryDocTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDocTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDocTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDocTypeExecute ]
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
/// Description:  导入文档类型
/// w ##Class(DHCHAI.RMES.DocTypeSrv).ImportDic("^[D:TYPE_ADMINSSION_RECORD]^入院记录")
ClassMethod ImportDic(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set Code    = $p(aInputStr,"^",2)
	Set Desc    = $p(aInputStr,"^",3)
	Quit:(Code="")||(Desc="") return
	
	Set DocTypeDr=""
	Set objDocType=##class(DHCHAI.RME.DocType).GetObjByCode(Code)
	If $IsObject(objDocType) {
		Set DocTypeDr=objDocType.%Id()
	}
	Set InputStr=DocTypeDr_"^"_Code_"^"_Desc
	Set return=##Class(DHCHAI.RME.DocType).Update(InputStr,"^")
	Quit return
}

}
