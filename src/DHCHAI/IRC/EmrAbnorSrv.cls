/// 名称: DHCHAI.IRC.EmrAbnorSrv
/// 描述: 病程阳性症状或体征检查规则
/// 编写者：zhufei
/// 编写日期: 2017-10-14
Class DHCHAI.IRC.EmrAbnorSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-10-14
/// Description:  检查规则-阳性症状或体征
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.EmrAbnorSrv).Check(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="CheckErr"
	
	Set xDate=aSttDate-1
	For {
		Set xDate=$o(^DHCHAI.DP.EmrRecordI("IndexEpisodeDrDocDate",aEpisodeDr,xDate))
		Quit:xDate=""
		Quit:xDate>aEndDate
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.EmrRecordI("IndexEpisodeDrDocDate",aEpisodeDr,xDate,xID))
			Quit:xID=""
			
			//获取筛查结果
			Do ..GetCheck(xID,aItmMastID)
		}
	}
	
	Quit 1
	
CheckErr
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2018-02-26
/// Description:  检查规则-阳性症状或体征
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.EmrAbnorSrv).Check(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check2(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="Check2Err"
	
	Set xDate=aSttDate-1
	For {
		Set xDate=$o(^DHCHAI.DP.EmrRecordI("IndexEpisUpdateDate",aEpisodeDr,xDate))
		Quit:xDate=""
		Quit:xDate>aEndDate
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.EmrRecordI("IndexEpisUpdateDate",aEpisodeDr,xDate,xID))
			Quit:xID=""
			
			//获取筛查结果
			Set ret = ..GetCheck(xID,aItmMastID)
			If (+ret)<1{
				Set objRecord=##class(DHCHAI.DP.EmrRecord).GetObjById(xID)
				If $IsObject(objRecord){
					Set SCode=objRecord.EmrSCode
					D ##class(DHCHAI.IRC.CtrlResultSrv).CancelCCResult(aEpisodeDr,aItmMastID,SCode,xID)
				}
			}
		}
	}
	
	Quit 1
	
Check2Err
	Quit "-999^"_$ZError
}

ClassMethod GetCheck(aRecordID As %String, aItmMastID As %String) As %String
{
	New (aRecordID,aItmMastID)
	Set return=0
	Quit:(aRecordID="")||(aItmMastID="") return
	
	Set objRecord=##class(DHCHAI.DP.EmrRecord).GetObjById(aRecordID)
	Quit:'$IsObject(objRecord) return
	Quit:'$IsObject(objRecord.EmrEpisodeDr) return
	Set IsActive=objRecord.EmrIsActive
	Quit:IsActive'=1 return
	
	Quit:'$IsObject(objRecord.EmrDocTypeDr) return
	Set DocTypeDesc=objRecord.EmrDocTypeDr.BTDesc
	Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjById(aItmMastID) 
	Quit:'$IsObject(objItmMast) return
	Set ItmMastCode = objItmMast.CCCode
	Quit:(DocTypeDesc'="首程")&&(DocTypeDesc'="日常病程") return
	Set EpisodeDr=objRecord.EmrEpisodeDr.%Id()
	Set RecordID=objRecord.%Id()
	Set SCode=objRecord.EmrSCode
	Set DocTitleSub = objRecord.EmrDocTitleSub  //文档子标题
	Quit:(DocTitleSub["鉴别诊断") return   //update 20190924 鉴别诊断不做语义分析
	Set HAIThemeCode="INF-HAI"  //主题分类代码
	
	//语义词库版本
	Set VersionDr=""
	Set objVersion=##class(DHCHAI.RME.ThemeType).GetVersionByThCode(HAIThemeCode)  //HAI语义分析词库
	If $IsObject(objVersion){
		Set VersionDr=objVersion.%Id()
	}
	Quit:VersionDr="" return
	
	Set DocNumber=SCode_"||"_RecordID
	Set objDocMaster=##class(DHCHAI.RME.DocMaster).GetObjByDocNumber(VersionDr,DocNumber)
	Quit:'$IsObject(objDocMaster) return
	Quit:'$IsObject(objDocMaster.DMVersionDr) return
	Set VersionDr=objDocMaster.DMVersionDr.%Id()
	Set MasterID=objDocMaster.%Id()
	
	//作废原有记录
	Set flg=##class(DHCHAI.IRC.CtrlResultSrv).CancelCCResult(EpisodeDr, aItmMastID, SCode, RecordID)
	
	Set MapKeyWords=""
	Set ParserWords=""
	Set KeyWordList=""
	Set xSecSub=0
	For {
		Set xSecSub=$o(^DHCHAI.RME.DocMasterD(MasterID,"DS",xSecSub))
		Quit:xSecSub=""
		
		Set xRstSub=0
		For {
			Set xRstSub=$o(^DHCHAI.RME.DocMasterD(MasterID,"DS",xSecSub,"DR",xRstSub))
			Quit:xRstSub=""
			
			Set objResult=##class(DHCHAI.RME.DocResult).GetObjById(MasterID_"||"_xSecSub_"||"_xRstSub)
			Continue:'$IsObject(objResult)
			Continue:'$IsObject(objResult.DRTypeDr)
			Set TypeCode=objResult.DRTypeDr.BTCode
			Continue:(TypeCode["-")     //||(TypeCode["?") -表示阴性   ?表示疑似阳性
			Set OneWord=objResult.DRName      //归一词
			Continue:OneWord=""
			Set DRFormal=objResult.DRFormal   //上位词
			Set:DRFormal="" DRFormal=OneWord
			Set tParserWords=objResult.DRParserWords
			Continue:tParserWords=""
			
			Set tContext=objResult.DRContext
			Continue:tContext["无"                                           //无反应
			Continue:tContext["未"                                           //未闻及干湿啰音
			Continue:tContext["不肿"                                         //不肿
			Continue:tContext["痛经"                                         //痛经
			Continue:tContext["痛苦"                                         //痛苦
			Continue:tContext["痛风"                                         //痛风
			Continue:tContext["痛触觉"                                       //痛触觉
			Continue:tContext["痛温觉"                                       //痛温觉
			Continue:(tContext["预防")&&(tContext["感染")                    //预防性感染
			Continue:(tContext["易出现")&&(tContext["感染")                  //易出现球菌感染
			Continue:(tContext["感染")&&(tContext["明显好转")                //感染明显好转
			Continue:(tContext["存在")&&(tContext["感染")&&(tContext["可能") //存在新生儿感染可能
			Continue:(tContext["目前")&&(tContext["胸痛")                    //目前胸痛
			
			//Update by zf 20180209
			//处理归一词和上位词对应院感归一词库问题
			Set objOneWord=##class(DHCHAI.RME.OneWords).GetObjByOneWord(VersionDr,DRFormal)
			Continue:'$IsObject(objOneWord)
			Set OneWordDr=objOneWord.%Id()
			
			Set IsInfWordFlag=0
			Set ThWordDr=0
			For {
				Set ThWordDr=$o(^DHCHAI.RME.ThWordsMapI("IndexOneWordThWord",OneWordDr,ThWordDr))
				Quit:ThWordDr=""
				
				Set xThWordMapDr=0
				For {
					Set xThWordMapDr=$o(^DHCHAI.RME.ThWordsMapI("IndexOneWordThWord",OneWordDr,ThWordDr,xThWordMapDr))
					Quit:xThWordMapDr=""
					
					Set objThWordMap=##class(DHCHAI.RME.ThWordsMap).GetObjById(xThWordMapDr)
					Continue:'$IsObject(objThWordMap)
					Continue:objThWordMap.BTIsActive'=1
					Continue:objThWordMap.BTIsCheck'=1  //add by zf 20190731
					Set objThWord=objThWordMap.BTThWordDr
					Continue:'$IsObject(objThWord)
					Continue:'$IsObject(objThWord.BTThemeTypeDr)
					Continue:objThWord.BTIsActive'=1     //update 20190924将医院不要的主题词去掉
					Set ThemeType=objThWord.BTThemeTypeDr.BTCode
					Continue:ThemeType'=HAIThemeCode
					Continue:'$IsObject(objThWord.BTWordTypeDr)
					Set WordType = objThWord.BTWordTypeDr.BTCode
					
					Set KeyWord=objThWord.BTKeyWord
					Set LimitWord=objThWord.BTLimitWord
					Set:LimitWord'="" KeyWord=KeyWord+LimitWord
					Continue:$listfind(KeyWordList,KeyWord)>0
					Set KeyWordList=KeyWordList_$lb(KeyWord)
					Set MapKeyWords=MapKeyWords_";"_KeyWord_"-"_OneWord
					Set IsInfWordFlag=1
				}
			}
			Continue:IsInfWordFlag'=1
			
			If tParserWords'="" {
				If ParserWords="" {
					Set ParserWords=tParserWords
				} Else {
					Set ParserWords=ParserWords_";"_tParserWords
				}
			}
		}
	}
	Quit:KeyWordList="" return
	Set ActKeyWords=##class(DHCHAI.Utils.CommonSrv).ListToString(KeyWordList,";")
	Set:MapKeyWords'="" MapKeyWords=$e(MapKeyWords,2,$l(MapKeyWords))
	Set IsAbFlag =1
	/*
	Set IsAbFlag=0 //是否包含特异性关键词
	If (ActKeyWords["炎")||(ActKeyWords["感染"){
		Set IsAbFlag=1
	}
	*/
	Set DocTitle=objRecord.EmrDocTitle
	Set DocDate=objRecord.EmrDocDate
	Set DocTime=""
	Set DocUser=objRecord.EmrActUser
	Set:DocUser'="" DocUser=$p(DocUser,"|",3)
	Set RegDate=objRecord.EmrActDate
	Set RegTime=objRecord.EmrActTime
	Set RegUser=objRecord.EmrActUser
	Set:RegUser'="" RegUser=$p(RegUser,"|",3)
	
	Set obj=##class(DHCHAI.IRC.CtrlRecord).GetObj(EpisodeDr,aItmMastID)
	Quit:'$IsObject(obj) return
	
	Set obj.CCResult    = ActKeyWords  //阳性症状或体征
	Set obj.CCTextRes   = MapKeyWords  //定性结果
	Set obj.CCUnit      = DocTitle     //单位
	Set obj.CCActLocDr  = ""           //病程科室
	Set obj.CCActDate   = DocDate      //病程日期
	Set obj.CCActTime   = DocTime      //病程时间
	Set obj.CCActUser   = DocUser      //病程记录人
	Set obj.CCRepDate   = RegDate      //病程记录日期
	Set obj.CCRepTime   = RegTime      //病程记录时间
	Set obj.CCRepUser   = RegUser      //病程记录人
	Set obj.CCSCode     = SCode        //子系统代码
	Set obj.CCObjectID  = RecordID
	Set obj.CCParams    = "RecordID="_RecordID
	
	Set obj.CCKeyWord   = ""           //关键词
	Set obj.CCIsAbFlag  = IsAbFlag     //结果异常
	Set obj.CCSummary   = DocTitle_":"_ActKeyWords  //摘要信息
	
	Set return=##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)
	Quit return
}

}
