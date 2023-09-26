/// 名称: DHCHAI.RMES.ThWordsMapSrv
/// 描述: 主题词映射相关服务
/// 编写者：zhoubo
/// 编写日期: 2017-08-14
Class DHCHAI.RMES.ThWordsMapSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-08-28
/// Description:  审核作废主题词与归一词对照
/// Table：       DHCHAI.RME.ThemeWords、DHCHAI.RME.ThWordsMap
/// Input：      
/// Return：      return>0:成功  return<=0:失败
/// w ##class(DHCHAI.RMES.ThWordsMapSrv).UpdateCheck("2^^2058")
ClassMethod UpdateCheck(aInput As %String, aSeparate As %String) As %String
{
	New (aInput,aSeparate)
	Set return=0
	
	Set:aSeparate="" aSeparate="^"
	Set KeyWord    = $p(aInput,aSeparate,1)    
	Set OneWord    = $p(aInput,aSeparate,2)  
	Set WordGroup  = $p(aInput,aSeparate,3)  
	Set ThemeType  = $p(aInput,aSeparate,4)  	
	Set StatusCdoe = $p(aInput,aSeparate,5)  
	Quit:(KeyWord="")||(OneWord="")||(ThemeType="") return
	Set VersionDr = 1
	
	Set ThemeTypeDr =""
    Set objThemeType =  ##class(DHCHAI.RME.ThemeType).GetObjByCode(ThemeType)
    Quit:'$Isobject(objThemeType) return
	Set ThemeTypeDr = objThemeType.%Id()
	
	Set KeyWordDr=""
	Set KeyWordDr=$o(^DHCHAI.RME.ThemeWordsI("IndexWordGroup",ThemeTypeDr," "_$zcvt(WordGroup,"U"),0))
	Quit:KeyWordDr="" return
	
	Set OneWordDr=""
	Set OneWordDr=$o(^DHCHAI.RME.OneWordsI("IndexOneWord",VersionDr,OneWord,0))
    Quit:OneWordDr="" return
	
	Set ID=$o(^DHCHAI.RME.ThWordsMapI("IndexThWordOneWord",KeyWordDr,OneWordDr,0))
	Quit:ID="" return 
	
	Set InputStr=StatusCdoe_"^^"_ID  
	Set return=##class(DHCHAI.RMES.ThWordsMapSrv).CheckThWordsMap(InputStr)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-07-30
/// Description:  审核主题词与归一词对照
/// Table：       DHCHAI.RME.ThemeWords、DHCHAI.RME.ThWordsMap
/// Input：       aInputStr : 状态^审核人^审核记录ID(多值逗号分隔)
/// Return：      返回String
/// w ##class(DHCHAI.RMES.ThWordsMapSrv).CheckThWordsMap("2^^2058,2693")
ClassMethod CheckThWordsMap(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set StatusCode=$p(aInputStr,"^",1)  //审核通过1、审核不通过2
	Set CheckUserID=$p(aInputStr,"^",2)
	Set ThWordMapIDs=$p(aInputStr,"^",3)
	Quit:(StatusCode="")||(ThWordMapIDs="") return
	
	Set IsCheck=1
	If StatusCode=1 {
		Set IsActive=1
	} Else {
		Set IsActive=0
	}
	
	TStart
	
	For indID=1:1:$l(ThWordMapIDs,",") {
		Set MapID=$p(ThWordMapIDs,",",indID)
		Continue:MapID=""
		Set InputStr=MapID
		Set InputStr=InputStr_"^"_IsActive
		Set InputStr=InputStr_"^"_IsCheck
		Set InputStr=InputStr_"^"_+$h
		Set InputStr=InputStr_"^"_$p($h,",",2)
		Set InputStr=InputStr_"^"_CheckUserID
		Set flg=##class(DHCHAI.RME.ThWordsMap).SetIsCheck(InputStr,"^")
		If (+flg)<1 {
			Set return=-1
			TRollback
			Quit
		}
	}
	
	TCommit
	
	Set return=1
	Quit return
	
CheckThWordsMapErr
	If return<0 TRollback
	Quit -999_"^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2019-07-30
/// Description:  查询主题词库信息
///               比DHCHAI.RMES.ThemeWordsSrv类QryThemeWords多了一列未审核数
/// Table：       DHCHAI.RME.ThemeWords、DHCHAI.RME.ThWordsMap
/// Input：       aThWordDr   主题词ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.ThWordsMapSrv","QryThWordsToCheck",2)
Query QryThWordsToCheck(aThemeTypeDr As %String, aKeyWord As %String = "") As %Query(ROWSPEC = "ID:%String,ThemeTypeDr:%String,ThemeTypeCode:%String,ThemeTypeDesc:%String,KeyWord:%String,WordTypeDr:%String,WordTypeCode:%String,WordTypeDesc:%String,LimitWord:%String,Context:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUser:%String,UnCheckCnt:%String")
{
}

ClassMethod QryThWordsToCheckExecute(ByRef qHandle As %Binary, aThemeTypeDr As %String, aKeyWord As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aThemeTypeDr="" $$$OK
	
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
		Continue:ThemeTypeDr'=aThemeTypeDr
	
		Set KeyWord = objThemeWords.BTKeyWord
		Continue:(aKeyWord'="")&&(KeyWord'[aKeyWord)
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
		
		//未审核记录数
		Set UnCheckCnt=0
		Set xMapID=0
		For {
			Set xMapID=$o(^DHCHAI.RME.ThWordsMapI("IndexThWordIsCheck",xID,0,xMapID))
			Quit:xMapID=""
		
			Set objMap=##class(DHCHAI.RME.ThWordsMap).GetObjById(xMapID)
			Continue:'$IsObject(objMap)
			Set MapIsActive=objMap.BTIsActive
			Continue:MapIsActive<1  //无效记录不计算在未审核中,与上面IsActive区分，否则界面显示可能错误
			
			Set UnCheckCnt=UnCheckCnt+1
		}
		
		Set Data = $lb(xID,ThemeTypeDr,ThemeTypeCode,ThemeTypeDesc,KeyWord,WordTypeDr,WordTypeCode,WordTypeDesc,LimitWord,Context,IsActive,ActDate,ActTime,ActUser,UnCheckCnt)
		Set ^CacheTemp(repid,ind) = Data
		Set ind = ind+1
	}
	Quit $$$OK
}

ClassMethod QryThWordsToCheckClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryThWordsToCheckExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryThWordsToCheckFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryThWordsToCheckExecute ]
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
/// CreatDate：   2017-08-14
/// Description:  根据主题词ID查询主题词映射信息
/// Table：       DHCHAI.RME.ThWordsMap
/// Input：       aThWordDr   主题词ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.ThWordsMapSrv","QryThWordsMap",1,"皮炎")
Query QryThWordsMap(aThWordsDr As %String, aKeyWord As %String = "") As %Query(ROWSPEC = "ID:%String,ThemeTypeDr:%String,ThemeTypeDesc:%String,ThemeWordDr:%String,ThemeWord:%String,LimitWord:%String,IsActive:%String,IsActiveDesc:%String,OneWordDr:%String,OneWord:%String,OneWordCatDr:%String,OneWordCatDesc:%String,DocTypeDr:%String,DocTypeDesc:%String,SectionTypeDr:%String,SectionTypeDesc:%String,PropertyTypeDr:%String,PropertyTypeDesc:%String,DocProperty:%String,ActDate:%String,ActTime:%String,ActUser:%String,IsCheck:%String,CheckStatus:%String,CheckDate:%String,CheckTime:%String,CheckUser:%String")
{
}

ClassMethod QryThWordsMapExecute(ByRef qHandle As %Binary, aThWordsDr As %String, aKeyWord As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aThWordsDr="" $$$OK
	
	Set xIsCheck=""
	For {
		Set xIsCheck=$o(^DHCHAI.RME.ThWordsMapI("IndexThWordIsCheck",aThWordsDr,xIsCheck))
		Quit:xIsCheck=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.RME.ThWordsMapI("IndexThWordIsCheck",aThWordsDr,xIsCheck,xID))
			Quit:xID=""
			
			Set objThWordsMap = ##class(DHCHAI.RME.ThWordsMap).GetObjById(xID)
			Continue:'$isobject(objThWordsMap)
			Continue:'$isobject(objThWordsMap.BTThWordDr)
			Continue:'$isobject(objThWordsMap.BTThWordDr.BTThemeTypeDr)
			Set ThemeTypeDr = objThWordsMap.BTThWordDr.BTThemeTypeDr.%Id()
			Set ThemeTypeDesc = objThWordsMap.BTThWordDr.BTThemeTypeDr.BTDesc
			Set ThemeWordDr = objThWordsMap.BTThWordDr.%Id()
			Set ThemeWord   = objThWordsMap.BTThWordDr.BTKeyWord
			Set LimitWord   = objThWordsMap.BTThWordDr.BTLimitWord
			Continue:'$isobject(objThWordsMap.BTOneWordDr)
			Set OneWordDr      = objThWordsMap.BTOneWordDr.%Id()
			Set OneWord        = objThWordsMap.BTOneWordDr.BTOneWord
			Continue:(aKeyWord'="")&&(OneWord'[aKeyWord)
			Set OneWordCatDr="",OneWordCatDesc=""
			If $IsObject(objThWordsMap.BTOneWordDr.BTCatDr){
				Set OneWordCatDr   = objThWordsMap.BTOneWordDr.BTCatDr.%Id()
				Set OneWordCatDesc = objThWordsMap.BTOneWordDr.BTCatDr.BTDesc
			}
			Set DocTypeDr="",DocTypeDesc=""
			If $IsObject(objThWordsMap.BTDocTypeDr) {
				Set DocTypeDr=objThWordsMap.BTDocTypeDr.%Id()
				Set DocTypeDesc=objThWordsMap.BTDocTypeDr.BTDesc
			}
			Set SectionTypeDr="",SectionTypeDesc=""
			If $IsObject(objThWordsMap.BTSectionTypeDr) {
				Set SectionTypeDr=objThWordsMap.BTSectionTypeDr.%Id()
				Set SectionTypeDesc=objThWordsMap.BTSectionTypeDr.BTDesc
			}
			Set PropertyTypeDr="",PropertyTypeDesc=""
			If $IsObject(objThWordsMap.BTPropertyTypeDr) {
				Set PropertyTypeDr=objThWordsMap.BTPropertyTypeDr.%Id()
				Set PropertyTypeDesc=objThWordsMap.BTPropertyTypeDr.BTDesc
			}
			Set DocProperty=objThWordsMap.BTDocProperty
			
			Set IsActive= objThWordsMap.BTIsActive
			Set IsActiveDesc=$s(IsActive>0:"是",1:"否")
			Set ActDate = objThWordsMap.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime = objThWordsMap.BTActTime
			Set:ActTime'="" ActTime = $zt(ActTime,1)
			Set ActUser = objThWordsMap.BTActUser
			Set objActUser=##class(DHCHAI.BT.SysUser).GetObjById(ActUser)
			If $IsObject(objActUser){
				Set ActUser = objActUser.BTDesc
			}
			
			Set IsCheck = objThWordsMap.BTIsCheck
			Set CheckDate = objThWordsMap.BTCheckDate
			Set:CheckDate'="" CheckDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(CheckDate)
			Set CheckTime = objThWordsMap.BTCheckTime
			Set:CheckTime'="" CheckTime = $zt(CheckTime,1)
			Set CheckUser = objThWordsMap.BTCheckUser
			Set objCheckUser=##class(DHCHAI.BT.SysUser).GetObjById(CheckUser)
			If $IsObject(objCheckUser){
				Set CheckUser = objCheckUser.BTDesc
			}
			Continue:(IsActive<1)&&(IsCheck<1)
			
			Set CheckStatus="未审核"
			Set:(IsCheck>0)&&(IsActive>0) CheckStatus="审核有效"
			Set:(IsCheck>0)&&(IsActive<1) CheckStatus="审核作废"
			
			Set Data=$lb(xID,ThemeTypeDr,ThemeTypeDesc,ThemeWordDr,ThemeWord,LimitWord,
			IsActive,IsActiveDesc,OneWordDr,OneWord,OneWordCatDr,OneWordCatDesc,DocTypeDr,DocTypeDesc,
			SectionTypeDr,SectionTypeDesc,PropertyTypeDr,PropertyTypeDesc,
			DocProperty,ActDate,ActTime,ActUser,IsCheck,CheckStatus,CheckDate,CheckTime,CheckUser)
			Set ^CacheTemp(repid,ind)=Data
			Set ind = ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryThWordsMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryThWordsMapExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryThWordsMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryThWordsMapExecute ]
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
/// CreatDate：   2017-08-11
/// Description:  根据词库版本ID查询归一词信息
/// Table：       DHCHAI.RME.OneWords
/// Input：       aThemeTypeDr:   主题类型ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.ThWordsMapSrv","QryOneWords","1")
Query QryOneWords(aThemeTypeDr As %String, aIsMapFlag As %String) As %Query(ROWSPEC = "ID:%String,VerID:%String,VerCode:%String,VerDesc:%String,OneWord:%String,ThemeWord:%String,ActDate:%String,ActTime:%String,ActUser:%String")
{
}

ClassMethod QryOneWordsExecute(ByRef qHandle As %Binary, aThemeTypeDr As %String, aIsMapFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set objThemeType=##class(DHCHAI.RME.ThemeType).GetObjById(aThemeTypeDr)
	Quit:'$IsObject(objThemeType) $$$OK
	Quit:'$IsObject(objThemeType.BTVersionDr) $$$OK
	Set VersionDr=objThemeType.BTVersionDr.%Id()
	
	Set xOneWds=""
	For {
		Set xOneWds=$o(^DHCHAI.RME.OneWordsI("IndexOneWord",VersionDr,xOneWds))
		Quit:xOneWds=""
		
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.RME.OneWordsI("IndexOneWord",VersionDr,xOneWds,xID))
			Quit:xID=""
			
			Set ThemeWord = ##class(DHCHAI.RME.OneWords).CheckOneWordsIsMap(aThemeTypeDr,xID)
			Continue:(aIsMapFlag=1)&(ThemeWord'="")
			
			Set objOneWds=##class(DHCHAI.RME.OneWords).GetObjById(xID)
			Continue:'$isobject(objOneWds)
			Continue:'$isobject(objOneWds.BTVersionDr)
			Set VerID   = objOneWds.BTVersionDr.%Id()  
			Set VerCode = objOneWds.BTVersionDr.BTCode
			Set VerDesc = objOneWds.BTVersionDr.BTDesc
		    
			Set OneWord = objOneWds.BTOneWord
			Set ActDate = objOneWds.BTActDate
			Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
			Set ActTime = objOneWds.BTActTime
			Set:ActTime'="" ActTime = $zt(ActTime,1)
			Set ActUser = objOneWds.BTActUser
			
			Set Data = $lb(xID,VerID,VerCode,VerDesc,OneWord,ThemeWord,ActDate,ActTime,ActUser)
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
/// CreatDate：   2017-11-19
/// Description:  根据数据对照规则处理主题词与归一词对照
/// w ##Class(DHCHAI.RMES.ThWordsMapSrv).ChangeMapping(149)
ClassMethod ChangeMapping(aThemeWordDr As %String = "") As %String
{
	New (aThemeWordDr)
	Set return=0
	
	//数据对照规则
	Set objCat=##class(DHCHAI.BT.Dictionary).GetObjByCode("MapRule","RMEInfKeyMap")
	Quit:'$IsObject(objCat) return
	Set CatDr=objCat.%Id()
	
	Set aThemeWord=""
	If aThemeWordDr'="" {
		Set objThemeWord=##class(DHCHAI.RME.ThemeWords).GetObjById(aThemeWordDr)
		If $IsObject(objThemeWord) {
			Set aThemeWord=objThemeWord.BTKeyWord
		}
	}
	
	Set Count=0
	Set xThTypeDr=""
	For {
		Set xThTypeDr=$o(^DHCHAI.RME.ThemeTypeD(xThTypeDr))
		Quit:xThTypeDr=""
		
		Set objThemeType=##class(DHCHAI.RME.ThemeType).GetObjById(xThTypeDr)
		Continue:'$IsObject(objThemeType)
		Continue:objThemeType.BTIsActive'=1
		Continue:'$IsObject(objThemeType.BTVersionDr)
		Set VersionDr=objThemeType.BTVersionDr.%Id()
		Set ThemeTypeDr=objThemeType.%Id()
		
		Set xOneWord=""
		For {
			Set xOneWord=$o(^DHCHAI.RME.OneWordsI("IndexOneWord",VersionDr,xOneWord))
			Quit:xOneWord=""
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.RME.OneWordsI("IndexOneWord",VersionDr,xOneWord,xID))
				Quit:xID=""
				
				Set objOneWord=##class(DHCHAI.RME.OneWords).GetObjById(xID)
				Continue:'$IsObject(objOneWord)
				Set OneWord=objOneWord.BTOneWord
				Set OneWordDr=objOneWord.%Id()
				
				//排除
				Set ThemeWordList2=""
				Set xKey=""
				For {
					Set xKey=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",CatDr,2,xKey))
					Quit:xKey=""
					Continue:OneWord'[xKey  //归一词包含关键词
					
					Set xMapID=0
					For {
						Set xMapID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",CatDr,2,xKey,xMapID))
						Quit:xMapID=""
						
						Set objMap=##class(DHCHAI.DP.DataMapRule).GetObjById(xMapID)
						Continue:'$IsObject(objMap)
						Set ThemeWord=objMap.BTDesc  //对应主题词
						Continue:(aThemeWord'="")&&(ThemeWord'=aThemeWord)
						Set ThemeWordList2=ThemeWordList2_$lb(ThemeWord)
					}
				}
				//匹配
				Set ThemeWordList=""
				Set xKey=OneWord
				Set xMapID=0
				For {
					Set xMapID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",CatDr,0,xKey,xMapID))
					Quit:xMapID=""
					
					Set objMap=##class(DHCHAI.DP.DataMapRule).GetObjById(xMapID)
					Continue:'$IsObject(objMap)
					Set ThemeWord=objMap.BTDesc  //对应主题词
					Continue:(aThemeWord'="")&&(ThemeWord'=aThemeWord)
					Continue:$listfind(ThemeWordList2,ThemeWord)>0  //排除
					Continue:$listfind(ThemeWordList,ThemeWord)>0   //重复
					Set ThemeWordList=ThemeWordList_$lb(ThemeWord)
				}
				//包含
				Set xKey=""
				For {
					Set xKey=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",CatDr,1,xKey))
					Quit:xKey=""
					Continue:OneWord'[xKey  //归一词包含关键词
					
					Set xMapID=0
					For {
						Set xMapID=$o(^DHCHAI.DP.DataMapRuleI("IndexCatMapDesc",CatDr,1,xKey,xMapID))
						Quit:xMapID=""
						
						Set objMap=##class(DHCHAI.DP.DataMapRule).GetObjById(xMapID)
						Continue:'$IsObject(objMap)
						Set ThemeWord=objMap.BTDesc  //对应主题词
						Continue:(aThemeWord'="")&&(ThemeWord'=aThemeWord)
						Continue:$listfind(ThemeWordList2,ThemeWord)>0  //排除
						Continue:$listfind(ThemeWordList,ThemeWord)>0   //重复
						Set ThemeWordList=ThemeWordList_$lb(ThemeWord)
					}
				}
				
				//主题词与归一词建立对照
				For indM=1:1:$listlength(ThemeWordList){
					Set ThemeWord=$listget(ThemeWordList,indM)
					Continue:ThemeWord=""
					
					Set ThemeWordDr=""
					Set objThemeWord=##class(DHCHAI.RME.ThemeWords).GetObjByCode(ThemeTypeDr,ThemeWord,"")
					If $IsObject(objThemeWord){
						Set ThemeWordDr=objThemeWord.%Id()
					}
					Continue:ThemeWordDr=""
					
					Set ThWordsMapDr=""
					Set objThWordsMap=##class(DHCHAI.RME.ThWordsMap).GetThWordsMapByThOne(ThemeWordDr,OneWordDr)
					If $IsObject(objThWordsMap){
						Set ThWordsMapDr=objThWordsMap.%Id()
						Set IsActive=objThWordsMap.BTIsActive
						Continue:IsActive>0
						Set IsCheck=objThWordsMap.BTIsCheck
						Continue:IsCheck>0
						
						Set IsActive=1
						Set ActDate=+$h
						Set ActTime=$p($h,",",2)
						Set ActUser=""
						Set IsCheck=0
						Set CheckDate=objThWordsMap.BTCheckDate
						Set CheckTime=objThWordsMap.BTCheckTime
						Set CheckUser=objThWordsMap.BTCheckUser
					} Else {
						Set IsActive=1
						Set ActDate=+$h
						Set ActTime=$p($h,",",2)
						Set ActUser=""
						Set IsCheck=0
						Set CheckDate=""
						Set CheckTime=""
						Set CheckUser=""
					}
					Set InputStr = ThWordsMapDr_"^"_ThemeWordDr_"^"_OneWordDr_"^^^^"
					Set InputStr = InputStr_"^"_ActDate_"^"_ActTime_"^"_ActUser_"^"_IsActive
					Set InputStr = InputStr_"^"_IsCheck_"^"_CheckDate_"^"_CheckTime_"^"_CheckUser
					
					Set flg=##class(DHCHAI.RME.ThWordsMap).Update(InputStr,"^")
					If (+flg)>0 {
						Set Count=Count+1
					}
				}
				
				//主题词与归一词对照作废,原则上还需要重新审核
				For indM=1:1:$listlength(ThemeWordList2){
					Set ThemeWord=$listget(ThemeWordList2,indM)
					Continue:ThemeWord=""
					
					Set ThemeWordDr=""
					Set objThemeWord=##class(DHCHAI.RME.ThemeWords).GetObjByCode(ThemeTypeDr,ThemeWord,"")
					If $IsObject(objThemeWord){
						Set ThemeWordDr=objThemeWord.%Id()
					}
					Continue:ThemeWordDr=""
					
					Set ThWordsMapDr=""
					Set objThWordsMap=##class(DHCHAI.RME.ThWordsMap).GetThWordsMapByThOne(ThemeWordDr,OneWordDr)
					Continue:'$IsObject(objThWordsMap)
					Set ThWordsMapDr=objThWordsMap.%Id()
					Set IsActive=objThWordsMap.BTIsActive
					Continue:IsActive<1
					
					Set IsActive=0
					Set ActDate=+$h
					Set ActTime=$p($h,",",2)
					Set ActUser=""
					Set IsCheck=0
					Set CheckDate=objThWordsMap.BTCheckDate
					Set CheckTime=objThWordsMap.BTCheckTime
					Set CheckUser=objThWordsMap.BTCheckUser
					
					Set InputStr = ThWordsMapDr_"^"_ThemeWordDr_"^"_OneWordDr_"^^^^"
					Set InputStr = InputStr_"^"_ActDate_"^"_ActTime_"^"_ActUser_"^"_IsActive
					Set InputStr = InputStr_"^"_IsCheck_"^"_CheckDate_"^"_CheckTime_"^"_CheckUser
					
					Set flg=##class(DHCHAI.RME.ThWordsMap).Update(InputStr,"^")
					If (+flg)>0 {
						Set Count=Count+1
					}
				}
				
			}
		}
	}
	Set return=Count
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-08-14
/// Description:  根据主题词ID查询主题词映射信息
/// Table：       DHCHAI.RME.ThWordsMap
/// Input：       aThWordsDr   主题词ID
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.RMES.ThWordsMapSrv","QryThWordsKeys",2)
Query QryThWordsKeys(aThWordsDr As %String) As %Query(ROWSPEC = "ThWordsMapDr:%String,ThWordsDr:%String,OneWordDr:%String,ParserWordDr:%String,OneWord:%String,OneWordCatCode:%String,OneWordCatDesc:%String,ParserWord:%String,LimitWord:%String,Context:%String,IsCheck:%String,IsActive:%String,ActDate:%String,ActTime:%String,ActUser:%String")
{
}

ClassMethod QryThWordsKeysExecute(ByRef qHandle As %Binary, aThWordsDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aThWordsDr="" $$$OK
	Set objThemeWord=##class(DHCHAI.RME.ThemeWords).GetObjById(aThWordsDr)
	Quit:'$IsObject(objThemeWord) $$$OK
	Set ThWordsDr=objThemeWord.%Id()
	
	Set xOneWordDr=0
	For {
		Set xOneWordDr=$o(^DHCHAI.RME.ThWordsMapI("IndexThWordOneWord",ThWordsDr,xOneWordDr))
		Quit:xOneWordDr=""
		
		Set ThWordsMapDr=$o(^DHCHAI.RME.ThWordsMapI("IndexThWordOneWord",ThWordsDr,xOneWordDr,0))
		Set objOneWord=##class(DHCHAI.RME.OneWords).GetObjById(xOneWordDr)
		Continue:'$IsObject(objOneWord)
		Continue:'$IsObject(objOneWord.BTVersionDr)
		Set VersionDr=objOneWord.BTVersionDr.%Id()
		Set OneWordDr=objOneWord.%Id()
		Set OneWord=objOneWord.BTOneWord
		Set OneWordCatCode="",OneWordCatDesc=""
		If $IsObject(objOneWord.BTCatDr) {
			Set OneWordCatCode=objOneWord.BTCatDr.BTCode
			Set OneWordCatDesc=objOneWord.BTCatDr.BTDesc
		}
		
		Set xParserWordDr=0
		For {
			Set xParserWordDr=$o(^DHCHAI.RME.ParserWordsI("IndexOneWordDr",VersionDr,OneWordDr,xParserWordDr))
			Quit:xParserWordDr=""
			
			Set objParserWord=##class(DHCHAI.RME.ParserWords).GetObjById(xParserWordDr)
			Continue:'$IsObject(objParserWord)
			Set ParserWordDr=objParserWord.%Id()
			Set ParserWord=objParserWord.BTKeyWord
			Set LimitWord=objParserWord.BTLimitWord
			Set Context=objParserWord.BTContext
			Set IsCheck=objParserWord.BTIsCheck
			Set IsActive=objParserWord.BTIsActive
			Set ActDate=objParserWord.BTActDate
			Set:ActDate'="" ActDate=$zd(ActDate,3)
			Set ActTime=objParserWord.BTActTime
			Set:ActTime'="" ActTime=$zt(ActTime,2)
			Set ActUser=objParserWord.BTActUser
			Continue:IsActive'=1 //无效不显示
			
			Set Data=$lb(ThWordsMapDr,ThWordsDr,OneWordDr,ParserWordDr,OneWord,OneWordCatCode,OneWordCatDesc,ParserWord,LimitWord,Context,IsCheck,IsActive,ActDate,ActTime,ActUser)
			Set ^CacheTemp(repid,ind)=Data
			Set ind = ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryThWordsKeysClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryThWordsKeysExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryThWordsKeysFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryThWordsKeysExecute ]
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

/// 标记语义词
/// w ##class(DHCHAI.RMES.ThWordsMapSrv).UpdateRMEModel("1^2^测试^^^7935")
ClassMethod UpdateRMEModel(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:aInputStr="" return
	
	Set ThTypeDr   = $p(aInputStr,"^",1)
	Set ThWordsDr  = $p(aInputStr,"^",2)
	Set ParserWord = $p(aInputStr,"^",3)
	Set OneWord    = $p(aInputStr,"^",4)
	Set Context    = $p(aInputStr,"^",5)
	Set UserDr     = $p(aInputStr,"^",6)
	Quit:(ThTypeDr="")&&(ThWordsDr="") return
	Quit:(ParserWord="") return
	Set:OneWord="" OneWord=ParserWord
	
	Set objThemeWord=##class(DHCHAI.RME.ThemeWords).GetObjById(ThWordsDr)
	If $IsObject(objThemeWord){
		If $IsObject(objThemeWord.BTThemeTypeDr){
			Set ThTypeDr=objThemeWord.BTThemeTypeDr.%Id()
		}
		Set ThWordsDr=objThemeWord.%Id()
	} Else {
		Set ThWordsDr=""
	}
	Quit:ThTypeDr="" return
	Set objThemeType=##class(DHCHAI.RME.ThemeType).GetObjById(ThTypeDr)
	Quit:'$IsObject(objThemeType) return
	Quit:'$IsObject(objThemeType.BTVersionDr) return
	Set VersionDr=objThemeType.BTVersionDr.%Id()
	
	TStart
	
	Set tOneWord=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(OneWord) //去掉特殊字符
	Set OneWordDr=$o(^DHCHAI.RME.OneWordsI("IndexOneWord",VersionDr,tOneWord,0))
	Set InputStr=""
	Set $p(InputStr,"^",1)=OneWordDr
	Set $p(InputStr,"^",2)=VersionDr
	Set $p(InputStr,"^",3)=OneWord
	Set $p(InputStr,"^",4)=""
	Set $p(InputStr,"^",5)=+$h
	Set $p(InputStr,"^",6)=$p($h,",",2)
	Set $p(InputStr,"^",7)=UserDr
	Set OneWordDr=##class(DHCHAI.RME.OneWords).Update(InputStr,"^")
	If (+OneWordDr)<1 {
		TRollback
		Quit return
	}
	
	Set tParserWord=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(ParserWord) //去掉特殊字符
	Set tWordGroup=tParserWord_"!!"_""
	Set ParserWordsDr=$o(^DHCHAI.RME.ParserWordsI("IndexWordGroup",VersionDr," "_$zcvt(tWordGroup,"U"),0))
	Set InputStr=""
	Set $p(InputStr,"^",1)=ParserWordsDr
	Set $p(InputStr,"^",2)=VersionDr
	Set $p(InputStr,"^",3)=ParserWord
	Set $p(InputStr,"^",4)=""
	Set $p(InputStr,"^",5)=$tr(Context,"^","")
	Set $p(InputStr,"^",6)=OneWordDr
	Set $p(InputStr,"^",7)=0
	Set $p(InputStr,"^",8)=1
	Set $p(InputStr,"^",9)=+$h
	Set $p(InputStr,"^",10)=$p($h,",",2)
	Set $p(InputStr,"^",11)=UserDr
	Set ParserWordsDr=##class(DHCHAI.RME.ParserWords).Update(InputStr,"^")
	If (+ParserWordsDr)<1 {
		TRollback
		Quit return
	}
	
	If ThWordsDr'="" {
		Set ThWordsMapDr=$o(^DHCHAI.RME.ThWordsMapI("IndexThWordOneWord",ThWordsDr,OneWordDr,0))
		Set InputStr=""
		Set $p(InputStr,"^",1)=ThWordsMapDr
		Set $p(InputStr,"^",2)=ThWordsDr
		Set $p(InputStr,"^",3)=OneWordDr
		Set $p(InputStr,"^",4)=""
		Set $p(InputStr,"^",5)=""
		Set $p(InputStr,"^",6)=""
		Set $p(InputStr,"^",7)=""
		Set $p(InputStr,"^",8)=+$h
		Set $p(InputStr,"^",9)=$p($h,",",2)
		Set $p(InputStr,"^",10)=UserDr
		Set $p(InputStr,"^",11)=1  //是否有效
		Set ThWordsMapDr=##class(DHCHAI.RME.ThWordsMap).Update(InputStr,"^")
		If (+ThWordsMapDr)<1 {
			TRollback
			Quit return
		}
	}
	TCommit
	
	//同步更新康夫子归一词库
	If (ParserWord'="")&&(OneWord="") {
		Set IsDynamicObject=##class(DHCHAI.BT.Config).GetValByCode("RMEDynamicObject")
		If IsDynamicObject="yes" {
			//2016库+康夫子语义分析
			Do ##class(DHCHAI.RMES.AnalysisSrv).UpdateRMEModel(ParserWord,OneWord,"SYMPTOM")
		} ElseIf IsDynamicObject="no" {
			//2010库+康夫子语义分析
			Do ##class(DHCHAI.RMES.AnalysisUpSrv).UpdateRMEModel(ParserWord,OneWord,"SYMPTOM")
		}
	}
	
	Set return=ThWordsMapDr
	Quit return
}

/// 标记语义词
/// w ##class(DHCHAI.RMES.ThWordsMapSrv).DeleteRMEModel("19380^42728^7935")
ClassMethod DeleteRMEModel(aInputStr) As %String
{
	New (aInputStr)
	Set return=0
	Quit:(aInputStr="") return
	
	Set aThWordsMapDr   = $p(aInputStr,"^",1)
	Set aParserWordsDr  = $p(aInputStr,"^",2)
	Set aUserDr         = $p(aInputStr,"^",3)
	Quit:(aThWordsMapDr="")||(aParserWordsDr="") return
	
	TStart
	Set objThWordsMap=##class(DHCHAI.RME.ThWordsMap).GetObjById(aThWordsMapDr)
	If $IsObject(objThWordsMap){
		Set flg=##class(DHCHAI.RME.ThWordsMap).DeleteById(aThWordsMapDr)
		If (+flg)<0 {
			TRollback
			Quit return
		}
	}
	
	Set OneWord="",ParserWord=""
	Set objParserWord=##class(DHCHAI.RME.ParserWords).GetObjById(aParserWordsDr)
	If $IsObject(objParserWord){
		If $IsObject(objParserWord.BTOneWordDr){
			Set OneWord=objParserWord.BTOneWordDr.BTOneWord
		}
		Set ParserWord=objParserWord.BTKeyWord
		Set flg=##class(DHCHAI.RME.ParserWords).CancelById(aParserWordsDr,aUserDr)
		If (+flg)<1 {
			TRollback
			Quit return
		}
	}
	TCommit
	
	//同步更新康夫子归一词库
	If (ParserWord'="")&&(OneWord="") {
		Set IsDynamicObject=##class(DHCHAI.BT.Config).GetValByCode("RMEDynamicObject")
		If IsDynamicObject="yes" {
			//2016库+康夫子语义分析
			Do ##class(DHCHAI.RMES.AnalysisSrv).DeleteRMEModel(ParserWord,OneWord,"SYMPTOM")
		} ElseIf IsDynamicObject="no" {
			//2010库+康夫子语义分析
			Do ##class(DHCHAI.RMES.AnalysisUpSrv).DeleteRMEModel(ParserWord,OneWord,"SYMPTOM")
		}
	}
	Set return=1
	Quit return
}

}
