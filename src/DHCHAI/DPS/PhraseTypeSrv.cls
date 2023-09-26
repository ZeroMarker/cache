/// 名称: DHCHAI.DPS.PhraseTypeSrv
/// 描述: 常用短语分类相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-07-24
Class DHCHAI.DPS.PhraseTypeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-07-24
/// Description:  查询短语分类信息
/// Table：       DHCHAI.DP.PhraseType
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.DPS.PhraseTypeSrv","QryPhraseType")
Query QryPhraseType() As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,DicTypeID:%String,DicTypeCode:%String,DicTypeDesc:%String")
{
}

ClassMethod QryPhraseTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set xCode = ""
	For {
		Set xCode = $o(^DHCHAI.DP.PhraseTypeI("IndexCode",xCode))
		Quit:xCode=""
		Set xID = ""
		For {
			Set xID = $o(^DHCHAI.DP.PhraseTypeI("IndexCode",xCode,xID))
			Quit:xID=""
			Set objPType = ##class(DHCHAI.DP.PhraseType).GetObjById(xID)
			Continue:'$isobject(objPType)
			
			Set Code        = objPType.BTCode
			Set Desc        = objPType.BTDesc
			Set DicTypeCode = objPType.BTDicType
			Set objDicType  = ##class(DHCHAI.BT.DicType).GetObjByCode(DicTypeCode)
			Set (DicTypeDesc,DicTypeID) = ""
			If ($IsObject(objDicType)) {
				Set DicTypeDesc = objDicType.BTDesc
				Set DicTypeID   = objDicType.%Id()
			}
			Set Data = $lb(xID,Code,Desc,DicTypeID,DicTypeCode,DicTypeDesc)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryPhraseTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPhraseTypeExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPhraseTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPhraseTypeExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2017-07-24
/// Description:  导入短语分类信息
/// Table：       DHCHAI.DP.PhraseType
/// Input：       
/// w ##class("DHCHAI.DPS.PhraseTypeSrv").ImportPType("^1^dsfsggseg^Anesthesia","^")
ClassMethod ImportPType(aInputStr As %String, aSeparate As %String) As %String
{
	New (aInputStr,aSeparate)
	Set return=-1
	Quit:(aInputStr="")||(aSeparate="") return

	Set Code    = $p(aInputStr,aSeparate,2)
	Set Desc    = $p(aInputStr,aSeparate,3)
	Set MapCode = $p(aInputStr,aSeparate,4)
	Set PTypeID = $o(^DHCHAI.DP.PhraseTypeI("IndexCode"," "_$zcvt(Code,"U"),0))
	
	Set InputStr = PTypeID_aSeparate_Code_aSeparate_Desc_aSeparate_MapCode
	Set return=##Class(DHCHAI.DP.PhraseType).Update(InputStr,aSeparate)
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-07-24
/// Description:  删除短语分类信息
/// Table：       DHCHAI.DP.PhraseType
/// Input：       
/// w ##class("DHCHAI.DPS.PhraseTypeSrv").DeletePType("1212122")
ClassMethod DeletePType(aTypeCode As %String) As %String
{
	New (aTypeCode)
	Set return=-1
	Quit:aTypeCode="" return
	
	Set $ZT="DeletePTypeErr"
	
	Set xTypeID=0
	For {
		Set xTypeID = $o(^DHCHAI.DP.PhraseTypeI("IndexCode"," "_$zcvt(aTypeCode,"U"),xTypeID))
		Quit:xTypeID=""
		Set flg=##class(DHCHAI.DP.PhraseType).DeleteById(xTypeID)
		
	}
	Set return=1
	Quit return
	
DeletePTypeErr
	Write "Error:"_$ZError,!
	Quit -999
}

}
