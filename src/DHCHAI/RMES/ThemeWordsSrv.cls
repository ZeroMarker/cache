/// 名称: DHCHAI.RMES.ThemeWordsSrv
/// 描述: 主题词库相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-14
Class DHCHAI.RMES.ThemeWordsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-08-14
/// Description:  查询主题词库信息
/// Table：       DHCHAI.RME.ThemeWords
/// Input：       
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.ThemeWordsSrv","QryThemeWords",1)
Query QryThemeWords(aThemeTypeID As %String) As %Query(ROWSPEC = "ID:%String,ThemeTypeDr:%String,ThemeTypeCode:%String,ThemeTypeDesc:%String,KeyWord:%String,WordTypeDr:%String,WordTypeCode:%String,WordTypeDesc:%String,LimitWord:%String,Context:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUser:%String,WordAttr:%String,WordAttrDesc:%String")
{
}

ClassMethod QryThemeWordsExecute(ByRef qHandle As %Binary, aThemeTypeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aThemeTypeID="" $$$OK
	
	Set xID=""
 	For {
	 	Set xID=$o(^DHCHAI.RME.ThemeWordsD(xID))
	 	Quit:xID=""
	 	
		Set objThemeWords = ##class(DHCHAI.RME.ThemeWords).GetObjById(xID)
		Continue:'$isobject(objThemeWords)
		Continue:'$IsObject(objThemeWords.BTThemeTypeDr)
		
		Set ThemeTypeDr   = objThemeWords.BTThemeTypeDr.%Id()  
		Set ThemeTypeCode = objThemeWords.BTThemeTypeDr.BTCode
		Set ThemeTypeDesc = objThemeWords.BTThemeTypeDr.BTDesc
		Continue:ThemeTypeDr'=aThemeTypeID
		
		Set KeyWord = objThemeWords.BTKeyWord
		If $IsObject(objThemeWords.BTWordTypeDr) {	
			Set WordTypeDr   = objThemeWords.BTWordTypeDr.%Id()  
			Set WordTypeCode = objThemeWords.BTWordTypeDr.BTCode
			Set WordTypeDesc = objThemeWords.BTWordTypeDr.BTDesc
	    }Else {
			Set (WordTypeDr,WordTypeCode,WordTypeDesc)=""   
		}
		
		Set LimitWord = objThemeWords.BTLimitWord
		Set Context   = objThemeWords.BTContext
		Set IsActive  = objThemeWords.BTIsActive
		Set ActDate = objThemeWords.BTActDate
		Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
		Set ActTime = objThemeWords.BTActTime
		Set:ActTime'="" ActTime = $zt(ActTime,1)
		Set ActUser = objThemeWords.BTActUser
		Set WordAttr =objThemeWords.BTWordAttr
		Set WordAttrDesc=$s(WordAttr="1":"特异指标",WordAttr="2":"一般指标",1:"")
		Set Data = $lb(xID,ThemeTypeDr,ThemeTypeCode,ThemeTypeDesc,KeyWord,WordTypeDr,WordTypeCode,WordTypeDesc,LimitWord,Context,IsActive,ActDate,ActTime,ActUser,WordAttr,WordAttrDesc)
		Set ^CacheTemp(repid,ind) = Data
		Set ind = ind+1
	}
	Quit $$$OK
}

ClassMethod QryThemeWordsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryThemeWordsExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryThemeWordsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryThemeWordsExecute ]
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
/// Description:  导入主体词库
/// w ##Class(DHCHAI.RMES.ThemeWordsSrv).ImportDic("^HAI^发热^^症状或体征^发热(≥38.0℃超过2天)。^1")
ClassMethod ImportDic(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set ThemeCode  = $p(aInputStr,"^",2)
	Set KeyWord    = $p(aInputStr,"^",3)
	Set LimitWord  = $p(aInputStr,"^",4)
	Set WordType   = $p(aInputStr,"^",5)
	Set Context    = $p(aInputStr,"^",6)
	Set IsActive   = +$p(aInputStr,"^",7)
	Set WordAttr   = $p(aInputStr,"^",8)
	Quit:(ThemeCode="")||(KeyWord="") return
	
	Set objThemeType=##class(DHCHAI.RME.ThemeType).GetObjByCode(ThemeCode)
	Quit:'$IsObject(objThemeType) return
	Set ThemeTypeDr=objThemeType.%Id()
	
	Set WordTypeDr=""
	Set objWordType=##class(DHCHAI.RME.ThWordType).GetObjByCode("",WordType)
	If $IsObject(objWordType) {
		Set WordTypeDr=objWordType.%Id()
	}
	
	Set ThemeWordsDr=""
	Set objThemeWords=##class(DHCHAI.RME.ThemeWords).GetObjByCode(ThemeTypeDr,KeyWord,LimitWord)
	If $IsObject(objThemeWords) {
		Set ThemeWordsDr=objThemeWords.%Id()
		If WordTypeDr="" {
			If $IsObject(objThemeWords.BTWordTypeDr) {
				Set WordTypeDr=objThemeWords.BTWordTypeDr.%Id()
			}
		}
		If Context="" {
			Set Context=objThemeWords.BTContext
		}
	}
	Set WordAttr=$s(WordAttr="特异指标":1,WordAttr="一般指标":2,1:"")
	Set InputStr=ThemeWordsDr_"^"_ThemeTypeDr_"^"_KeyWord_"^"_LimitWord_"^"_WordTypeDr_"^"_Context_"^"_IsActive_"^^^^"_WordAttr
	Set return=##Class(DHCHAI.RME.ThemeWords).Update(InputStr,"^")
	Quit return
}

}
