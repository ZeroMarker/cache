/// 名称: DHCHAI.RMES.SectionTypeSrv
/// 描述: 段落分类相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-09
Class DHCHAI.RMES.SectionTypeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-08-09
/// Description:  查询段落分类信息
/// Table：       DHCHAI.RME.SectionType
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.SectionTypeSrv","QrySectionType")
Query QrySectionType(iSearch As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String")
{
}

ClassMethod QrySectionTypeExecute(ByRef qHandle As %Binary, iSearch As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.RME.SectionTypeI("IndexCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.RME.SectionTypeI("IndexCode",xCode,xID))
			Quit:xID=""
			Set objSecType = ##class(DHCHAI.RME.SectionType).GetObjById(xID)
			Continue:'$isobject(objSecType)
			
			Set Code = objSecType.BTCode
			Set Desc = objSecType.BTDesc
			
			Continue:((iSearch'="")&(Code'[iSearch)&(Desc'[iSearch))
			Set Data = $lb(xID,Code,Desc)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QrySectionTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySectionTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QrySectionTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySectionTypeExecute ]
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
/// Description:  导入段落类型
/// w ##Class(DHCHAI.RMES.SectionTypeSrv).ImportDic("^[D:INFO_PATIENT]^患者信息")
ClassMethod ImportDic(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set Code    = $p(aInputStr,"^",2)
	Set Desc    = $p(aInputStr,"^",3)
	Quit:(Code="")||(Desc="") return
	
	Set SectionTypeDr=""
	Set objSectionType=##class(DHCHAI.RME.SectionType).GetObjByCode(Code)
	If $IsObject(objSectionType) {
		Set SectionTypeDr=objSectionType.%Id()
	}
	Set InputStr=SectionTypeDr_"^"_Code_"^"_Desc
	Set return=##Class(DHCHAI.RME.SectionType).Update(InputStr,"^")
	Quit return
}

}
