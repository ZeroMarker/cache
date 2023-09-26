/// 名称: DHCHAI.RMES.OneWordsSrv
/// 描述: 归一词库相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-11
Class DHCHAI.RMES.OneWordsSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2017-08-11
/// Description:  根据词库版本ID查询归一词信息
/// Table：       DHCHAI.RME.OneWords
/// Input：       aVersionDr:   语义词库版本ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.OneWordsSrv","QryOneWords","1")
Query QryOneWords(aVersionDr As %String, aAlias As %String = "") As %Query(ROWSPEC = "ID:%String,VerID:%String,VerCode:%String,VerDesc:%String,OneWord:%String,CatID:%String,CatCode:%String,CatDesc:%String,ActDate:%String,ActTime:%String,ActUser:%String")
{
}

ClassMethod QryOneWordsExecute(ByRef qHandle As %Binary, aVersionDr As %String, aAlias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aVersionDr="" $$$OK
	
	Set xOneWds=""
	For {
		Set xOneWds=$o(^DHCHAI.RME.OneWordsI("IndexOneWord",aVersionDr,xOneWds))
		Quit:xOneWds=""
		
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.RME.OneWordsI("IndexOneWord",aVersionDr,xOneWds,xID))
			Quit:xID=""
			
			Set objOneWds=##class(DHCHAI.RME.OneWords).GetObjById(xID)
			Continue:'$isobject(objOneWds)
			Continue:'$isobject(objOneWds.BTVersionDr)
			Set VerID   = objOneWds.BTVersionDr.%Id()  
			Set VerCode = objOneWds.BTVersionDr.BTCode
			Set VerDesc = objOneWds.BTVersionDr.BTDesc
		    
			Set OneWord = objOneWds.BTOneWord
			Set CatID="",CatCode="",CatDesc=""
			If $IsObject(objOneWds.BTCatDr){
				Set CatID   = objOneWds.BTCatDr.%Id()
				Set CatCode = objOneWds.BTCatDr.BTCode
				Set CatDesc = objOneWds.BTCatDr.BTDesc
			}
			Set ActDate = objOneWds.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime = objOneWds.BTActTime
			Set:ActTime'="" ActTime = $zt(ActTime,1)
			Set ActUser = objOneWds.BTActUser
			Continue:(aAlias'="")&&(xID_"|"_OneWord_"|"_CatDesc_"|"_ActDate'[aAlias)
			Set Data = $lb(xID,VerID,VerCode,VerDesc,OneWord,CatID,CatCode,CatDesc,ActDate,ActTime,ActUser)
			Set ^CacheTemp(repid,ind) = Data
			Set ind = ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryOneWordsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOneWordsExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryOneWordsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOneWordsExecute ]
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
/// Description:  导入归一词库（同义词一起导入）
/// w ##Class(DHCHAI.RMES.OneWordsSrv).ImportDic("^RME-HAI^三叉神经疼^^AAA^三叉神经痛^")
ClassMethod ImportDic(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set Version    = $p(aInputStr,"^",2)
	Set KeyWord    = $p(aInputStr,"^",3)
	Set LimitWord  = $p(aInputStr,"^",4)
	Set Context    = $p(aInputStr,"^",5)
	Set OneWord    = $p(aInputStr,"^",6)
	Set CatCode    = $p(aInputStr,"^",7)
	Quit:(Version="")||(KeyWord="") return
	
	
	Set objVersion=##class(DHCHAI.RME.Version).GetObjByCode(Version)
	Quit:'$IsObject(objVersion) return
	Set VersionDr=objVersion.%Id()
	
	Set CatDr=""
	Set objResultCat=##class(DHCHAI.RME.ResultCat).GetObjByCode(CatCode)
	If $IsObject(objResultCat) {
		Set CatDr=objResultCat.%Id()
	}
	Set OneWordDr=""
	If OneWord'="" {
		Set objOnWords=##class(DHCHAI.RME.OneWords).GetObjByVerWord(VersionDr,OneWord)
		If $IsObject(objOnWords) {
			Set OneWordDr=objOnWords.%Id()
		} Else {
			Set InputStr=""_"^"_VersionDr_"^"_OneWord_"^"_CatDr_"^^^"
			Set OneWordDr=##class(DHCHAI.RME.OneWords).Update(InputStr,"^")
			If (+OneWordDr)<1 {
				Set OneWordDr=""
			}
		}
	}
	
	Set ParserWordsDr="",IsCheck=0
	Set IsActive=1,ActDate="",ActTime="",ActUser=""
	Set objParserWords=##class(DHCHAI.RME.ParserWords).GetObjByVerKeyWord(VersionDr,KeyWord,LimitWord)
	If $IsObject(objParserWords) {
		Set ParserWordsDr=objParserWords.%Id()
		Set IsCheck=objParserWords.BTIsCheck
		Quit:IsCheck=1 ParserWordsDr
		If Context="" {
			Set Context=objParserWords.BTContext
		}
		If OneWordDr="" {
			If $IsObject(objParserWords.BTOneWordDr) {
				Set OneWordDr=objParserWords.BTOneWordDr.%Id()
			}
		}
		Set IsActive=objParserWords.BTIsActive
		Set ActDate=objParserWords.BTActDate
		Set ActTime=objParserWords.BTActTime
		Set ActUser=objParserWords.BTActUser
	}
	
	Set InputStr=ParserWordsDr_"^"_VersionDr_"^"_KeyWord_"^"_LimitWord_"^"_$tr(Context,"^","")
	_"^"_OneWordDr_"^"_IsCheck_"^"_IsActive_"^"_ActDate_"^"_ActTime_"^"_ActUser
	Set return=##Class(DHCHAI.RME.ParserWords).Update(InputStr,"^")
	Quit return
}

/// w ##class(DHCHAI.RMES.OneWordsSrv).SyncCorpusTagging(1)
ClassMethod SyncCorpusTagging(aVersionDr As %String) As %String
{
	New (aVersionDr)
	Set return="",Count=0
	
	Set objVersion=##class(DHCHAI.RME.Version).GetObjById(aVersionDr)
	Quit:'$IsObject(objVersion) return
	
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.RME.CorpusTaggingD(xID))
		Quit:xID=""
		
		Set TagInfo=$g(^DHCHAI.RME.CorpusTaggingD(xID))
		Continue:TagInfo=""
		Set Phrase=$lg(TagInfo,2)
		Set TagCat=$lg(TagInfo,3)
		Set IsActive=$lg(TagInfo,4)
		Continue:IsActive'=1
		
		Set CatDr=""
		If TagCat'="" {
			Set objCat=##class(DHCHAI.RME.ResultCat).GetObjByCode(TagCat)
			If $IsObject(objCat){
				Set CatDr=objCat.%Id()
			} Else {
				Set InputStr="^"_TagCat_"^"_TagCat
				Set CatDr=##class(DHCHAI.RME.ResultCat).Update(InputStr,"^")
				Continue:+CatDr<1
			}
		}
		
		Set objOneWord=##class(DHCHAI.RME.OneWords).GetObjByOneWord(aVersionDr,Phrase)
		Continue:$IsObject(objOneWord)
		
		Set InputStr=""
		Set InputStr=InputStr_"^"_aVersionDr
		Set InputStr=InputStr_"^"_Phrase
		Set InputStr=InputStr_"^"_CatDr
		Set InputStr=InputStr_"^"_+$h
		Set InputStr=InputStr_"^"_$p($h,",",2)
		Set InputStr=InputStr_"^"_""
		Set flg=##class(DHCHAI.RME.OneWords).Update(InputStr,"^")
		If (+flg)>0 {
			Set Count=Count+1
		}
	}
	
	Set return=Count
	Quit return
}

}
