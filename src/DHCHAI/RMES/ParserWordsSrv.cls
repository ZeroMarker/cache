/// 名称: DHCHAI.RMES.ParserWordsSrv
/// 描述: 语义词库相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-11
Class DHCHAI.RMES.ParserWordsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-08-11
/// Description:  根据词库版本ID和语义词ID查询语义词信息
/// Table：       DHCHAI.RME.ParserWords
/// Input：       aVersionDr:   语义词库版本ID
///               aVersionDr:   归一词库ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.ParserWordsSrv","QryParserWords","1","")
Query QryParserWords(aVersionDr As %String, aOneWordDr As %String, aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,VerID:%String,VerCode:%String,VerDesc:%String,KeyWord:%String,LimitWord:%String,Context:%String,OneWdsID:%String,OneWord:%String,IsCheck:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUser:%String")
{
}

ClassMethod QryParserWordsExecute(ByRef qHandle As %Binary, aVersionDr As %String, aOneWordDr As %String, aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:(aVersionDr="")||(aOneWordDr="") $$$OK
	
	Set xOneWordDr=""
	For {
		Set xOneWordDr=$o(^DHCHAI.RME.ParserWordsI("IndexOneWordDr",aVersionDr,xOneWordDr))
		Quit:xOneWordDr=""
		Continue:(aOneWordDr'="")&&(aOneWordDr'=xOneWordDr) // 过滤归一词
		
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.RME.ParserWordsI("IndexOneWordDr",aVersionDr,xOneWordDr,xID))
			Quit:xID=""
			
			Set objParserWds = ##class(DHCHAI.RME.ParserWords).GetObjById(xID)
			Continue:'$isobject(objParserWds)
			Continue:'$IsObject(objParserWds.BTVersionDr)
			Set VerID   = objParserWds.BTVersionDr.%Id()  
			Set VerCode = objParserWds.BTVersionDr.BTCode
			Set VerDesc = objParserWds.BTVersionDr.BTDesc
			Set KeyWord   = objParserWds.BTKeyWord     // 语义词
			Set LimitWord = objParserWds.BTLimitWord   // 关联属性
			Set Context   = objParserWds.BTContext     // 语境
			Set (OneWdsID,OneWord)=""
			If $IsObject(objParserWds.BTOneWordDr) {
				Set OneWdsID = objParserWds.BTOneWordDr.%Id()
				Set OneWord = objParserWds.BTOneWordDr.BTOneWord
			}
			Set IsCheck = objParserWds.BTIsCheck    // 是否审核
			Set IsActive = objParserWds.BTIsActive  // 是否有效
			Set ActDate = objParserWds.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime = objParserWds.BTActTime
			Set:ActTime'="" ActTime = $zt(ActTime,1)
			Set ActUser = objParserWds.BTActUser
			Continue:(aAlias'="")&&(xID_"|"_KeyWord_"|"_LimitWord_"|"_Context_"|"_OneWord_"|"_ActDate_"|"_ActUser'[aAlias)
			
			Set Data = $lb(xID,VerID,VerCode,VerDesc,KeyWord,LimitWord,Context,OneWdsID,OneWord,IsCheck,IsActive,ActDate,ActTime,ActUser)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryParserWordsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryParserWordsExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryParserWordsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryParserWordsExecute ]
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

}
