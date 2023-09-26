/// 名称: DHCHAI.RMES.AnalysisKeySrv
/// 描述: 语义分析服务类（关键词筛查）
/// 编写者：zhufei
/// 编写日期: 2018-02-09
Class DHCHAI.RMES.AnalysisKeySrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-02-09
/// Description:  病程语义分析（关键词筛查）
/// Table：       DHCHAI.DP.EmrRecord
/// Input：       患者就诊号,记录索引码 EmrXCode
/// Return：      成功：return>0
/// w ##class(DHCHAI.RMES.AnalysisKeySrv).EmrAnalysisByEpis("5493","2016-10-01","2016-10-12","","1")
ClassMethod EmrAnalysisByEpis(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aDocType As %String = "", aDesenFlag As %String = "0") As %String
{
	New (aEpisodeDr,aSttDate,aEndDate,aDocType,aDesenFlag)
	Set return=0,Count=0
	Quit:aEpisodeDr="" return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set:aSttDate["-" aSttDate=$zdh(aSttDate,3)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	
	Set xDocDate=$s(aSttDate'="":aSttDate-1,1:0)
	For {
		Set xDocDate=$o(^DHCHAI.DP.EmrRecordI("IndexEpisodeDrDocDate",EpisodeDr,xDocDate))
		Quit:xDocDate=""
		Quit:(aEndDate'="")&(xDocDate>aEndDate)
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.EmrRecordI("IndexEpisodeDrDocDate",EpisodeDr,xDocDate,xID))
			Quit:xID=""
			
			Set objRec=##class(DHCHAI.DP.EmrRecord).GetObjById(xID)
			Continue:'$Isobject(objRec)
			Continue:objRec.EmrIsActive'=1
			Continue:'$Isobject(objRec.EmrDocTypeDr)
			Set DocTypeCode=objRec.EmrDocTypeDr.BTCode
			Continue:(aDocType'="")&(aDocType'=DocTypeCode)
			Set SCode=objRec.EmrSCode
			Set DocTitle=objRec.EmrDocTitle
			Set DocHospital=SCode
			Set DocContent=objRec.EmrDocContent
			Set DocNumber=SCode_"||"_objRec.%Id()
			
			//保存关键词筛查结果
			Set flg=..SaveKeyScrResult("INF-HAI",EpisodeDr,DocNumber,DocTitle,DocContent)  //返回最后主记录id
			Continue:(+flg)<1
			Set Count=Count+1
		}
	}
	Quit Count
}

/// Creator：     zhufei
/// CreatDate：   2018-02-09
/// Description:  检查结果语义分析（关键词筛查）
/// Table：       DHCHAI.DP.RBReport
/// Input：       患者就诊号,记录索引码 EmrXCode
/// Return：      成功：return>0
/// w ##class(DHCHAI.RMES.AnalysisKeySrv).RISAnalysisByEpis("4670","2017-08-01","2017-08-15","","1")
ClassMethod RISAnalysisByEpis(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aDocType As %String = "", aDesenFlag As %String = "0") As %String
{
	New (aEpisodeDr,aSttDate,aEndDate,aDocType,aDesenFlag)
	Set return=0,Count=0
	Quit:aEpisodeDr="" return
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeDr)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	Set:aSttDate["-" aSttDate=$zdh(aSttDate,3)
	Set:aEndDate["-" aEndDate=$zdh(aEndDate,3)
	
	Set xRepDate=$s(aSttDate'="":aSttDate-1,1:0)
	For {
		Set xRepDate=$o(^DHCHAI.DP.RBReportI("IndexEpisodeDrRepDate",EpisodeDr,xRepDate))
		Quit:xRepDate=""
		Quit:(aEndDate'="")&(xRepDate>aEndDate)
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.RBReportI("IndexEpisodeDrRepDate",EpisodeDr,xRepDate,xID))
			Quit:xID=""
			
			Set objRep=##class(DHCHAI.DP.RBReport).GetObjById(xID)
			Continue:'$Isobject(objRep)
			Set SCode=objRep.RBSCode
			Set ChkStatus=objRep.RBChkStatus
			Set IsActive=objRep.RBIsActive
			Continue:IsActive=0
			Set CheckItem=objRep.RBCheckItem
			Set ExamDesc=objRep.RBExamDesc
			Set ResultDesc=objRep.RBResultDesc
			Continue:(ExamDesc="")&&(ResultDesc="")
			Set DocTitle=CheckItem
			Set DocHospital=SCode
			Set DocContent=ExamDesc_"!!"_ResultDesc
			Set DocNumber=SCode_"||"_objRep.%Id()
			
			//保存关键词筛查结果
			Set flg=..SaveKeyScrResult("INF-RIS",EpisodeDr,DocNumber,DocTitle,DocContent)  //返回最后主记录id
			Continue:(+flg)<1
			Set Count=Count+1
		}
	}
	Quit Count
}

/// Creator：     zhufei
/// CreatDate：   2018-02-09
/// Description:  存储关键词筛查结果
/// Table：       DHCHAI.RME.DocMaster
/// Input：       原始文本
/// Return：      成功：返回主记录id，失败：返回<0的代码
/// w ##class(DHCHAI.RMES.AnalysisKeySrv).SaveKeyScrResult("INF-HAI",5493,"EMR01||1","测试","患者今日体温正常，一般情况好，右膝创面部分同前，痂皮已脱落，创面周围无明显渗出及红肿，余症状查体同前。赵宇教授、盛林主治医师查房：观察患者一般情况变化。遵嘱执行。")
ClassMethod SaveKeyScrResult(aThemeCode As %String, aEpisodeDr As %String, aDocNumber As %String, aDocTitle As %String, aDocContent As %String) As %String
{
	New (aThemeCode,aEpisodeDr,aDocNumber,aDocTitle,aDocContent)
	Set return=0
	Quit:(aThemeCode="")||(aEpisodeDr="")||(aDocNumber="")||(aDocContent="") return
	
	Set objThemeType=##class(DHCHAI.RME.ThemeType).GetObjByCode(aThemeCode)
	Quit:'$IsObject(objThemeType) return
	Quit:'$IsObject(objThemeType.BTVersionDr) return
	Set VersionDr=objThemeType.BTVersionDr.%Id()
	
	Set DocSectionDr=""
	Set DocContent=aDocContent
	Set DocContent=##class(DHCHAI.Utils.CommonSrv).Replace(DocContent,$c(13,10),"|") //处理回车换行
	Set DocContent=$tr(DocContent,"。","|")
	Set DocContent=$tr(DocContent,"；","|")
	Set DocContent=$tr(DocContent,"？","|")
	Set DocContent=$tr(DocContent,"！","|")
	Set DocContent=$tr(DocContent,"，","|")
	Set DocContent=$tr(DocContent,"：","|")
	For indS=1:1:$l(DocContent,"|") {
		Set tSection=$p(DocContent,"|",indS)
		Continue:tSection=""
		Set tSection=##class(DHCHAI.Utils.CommonSrv).MoveSpaceKey(tSection)
		Continue:tSection=""
		
		Set Keywords=..GetInfKeywords(VersionDr,tSection)
		Continue:Keywords=""
		
		//存储语义分析结果
		If DocSectionDr="" {
			//唯一索引
			Set DocMasterDr=$o(^DHCHAI.RME.DocMasterI("IndexDocNumber",VersionDr," "_aDocNumber,0))
			
			//保存文档
			Set InputStr=""
			Set $p(InputStr,"^",1)=DocMasterDr
			Set $p(InputStr,"^",2)=aDocNumber
			Set $p(InputStr,"^",3)=aEpisodeDr
			Set $p(InputStr,"^",4)=$s($l(aDocContent)>1000:$e(aDocContent,1,1000),1:aDocContent)
			Set $p(InputStr,"^",5)=aDocTitle
			Set $p(InputStr,"^",6)=VersionDr
			Set $p(InputStr,"^",7)=""
			Set $p(InputStr,"^",8)="1"          //是否有效
			Set DocMasterDr=##class(DHCHAI.RME.DocMaster).Update(InputStr)
			Quit:(+DocMasterDr)<1
			Set return=DocMasterDr
			
			//清空原有文档段落
			Set flg=##class(DHCHAI.RME.DocMaster).ClearSection(DocMasterDr)
			
			//保存段落
			Set InputStr=""
			Set $p(InputStr,"^",1)=DocMasterDr
			Set $p(InputStr,"^",2)=""             //ChildSub
			Set $p(InputStr,"^",3)=""
			Set $p(InputStr,"^",4)=$s($l(aDocContent)>1000:$e(aDocContent,1,1000),1:aDocContent)
			Set $p(InputStr,"^",5)=1
			Set DocSectionDr=##class(DHCHAI.RME.DocSection).Update(InputStr)
			Quit:(+DocSectionDr)<1
		}
		
		//保存段落结果
		For indK=1:1:$ll(Keywords) {
			Set tKeyword=$listget(Keywords,indK)
			Continue:tKeyword=""
			Set ParserWord=$p(tKeyword,"!!",1)  //同义词
			Set OneWord=$p(tKeyword,"!!",2)     //归一词
			Set DRFormal=OneWord                //上位词
			
			Set InputStr=""
			Set $p(InputStr,"^",1)=DocSectionDr
			Set $p(InputStr,"^",2)=""             //ChildSub
			Set $p(InputStr,"^",3)=""
			Set $p(InputStr,"^",4)=OneWord
			Set $p(InputStr,"^",5)=tSection
			Set $p(InputStr,"^",6)=""
			Set $p(InputStr,"^",7)=""
			Set $p(InputStr,"^",8)=ParserWord
			Set $p(InputStr,"^",9)=DRFormal
			Set DocResultDr=##class(DHCHAI.RME.DocResult).Update(InputStr)
		}
	}
	Quit return
}

ClassMethod GetInfKeywords(aVersionDr As %String, aSectionStr As %String) As %List
{
	New (aVersionDr,aSectionStr)
	Set return=""
	Quit:(aVersionDr="")||(aSectionStr="") return
	
	Kill arrKeyword
	Set KeywordList=""
	For indK=1:1:$l(aSectionStr) {
		For indLn=($l(aSectionStr)-indK):-1:0 {
			Set tKeyword=$e(aSectionStr,indK,indK+indLn)
			Continue:tKeyword=""
			Continue:$l(tKeyword)>61  //控制最大长度
			Continue:'$d(^DHCHAI.RME.ParserWordsI("IndexKeyWord",aVersionDr,tKeyword))
			Set arrKeyword(indK,indK+indLn)=tKeyword
		}
	}
	Set xIndP=0
	For {
		Set xIndP=$o(arrKeyword(xIndP))
		Quit:xIndP=""
		Set xIndP2=$o(arrKeyword(xIndP,""),-1)
		Quit:xIndP2=""
		Set tKeyword=$g(arrKeyword(xIndP,xIndP2))
		Set KeywordList=KeywordList_$lb(tKeyword)
		Set xIndP=xIndP2
	}
	Quit:KeywordList="" return
	
	//处理非感染相关词
	Set tmpList="",ActKeywordStr=""
	For indK=1:1:$ll(KeywordList) {
		Set tKeyword=$listget(KeywordList,indK)
		Continue:tKeyword=""
		Continue:$l(tKeyword)>61  //控制最大长度
		Continue:$listfind(tmpList,tKeyword)>0
		Set tmpList=tmpList_$lb(tKeyword)
		
		Set xParserWordDr=0
		For {
			Set xParserWordDr=$o(^DHCHAI.RME.ParserWordsI("IndexKeyWord",aVersionDr,tKeyword,xParserWordDr))
			Quit:xParserWordDr=""
			
			Set objParserWord=##class(DHCHAI.RME.ParserWords).GetObjById(xParserWordDr)
			Continue:'$IsObject(objParserWord)
			Continue:'$IsObject(objParserWord.BTOneWordDr)
			Set OneWordDr=objParserWord.BTOneWordDr.%Id()
			Set OneWord=objParserWord.BTOneWordDr.BTOneWord
			Set LimitWord=objParserWord.BTLimitWord
			Set ParserWord=objParserWord.BTKeyWord
			
			Set ActKeyword="",ActOneWord=""
			
			//组合词判定
			If LimitWord'="" {
				Set IsActLimitWord=1
				For indL=1:1:$l(LimitWord,";") {
					Set tLimitWord=$p(LimitWord,";",indL)
					Continue:tLimitWord=""
					If $listfind(KeywordList,tLimitWord)<1 {
						Set IsActLimitWord=0
						Quit
					}
				}
				Continue:IsActLimitWord<1
				Set ActKeyword=LimitWord
			} Else {
				Set ActKeyword=ParserWord
			}
			
			//重复判断过滤
			Continue:$listfind(return,ActKeyword_"!!"_OneWord)>0
			Continue:ActKeywordStr[(";"_ActKeyword_";")
			
			//感染词判定
			Set IsActOneWord=0
			Set xThWordDr=0
			For {
				Set xThWordDr=$o(^DHCHAI.RME.ThWordsMapI("IndexOneWordThWord",OneWordDr,xThWordDr))
				Quit:xThWordDr=""
				
				Set objThWord=##class(DHCHAI.RME.ThemeWords).GetObjById(xThWordDr)
				Continue:'$IsObject(objThWord)
				Continue:objThWord.BTIsActive'=1

				Set IsActOneWord=1
				Quit
			}
			Continue:IsActOneWord<1
			Set ActOneWord=OneWord
			
			Set return=return_$lb(ActKeyword_"!!"_ActOneWord)
			Set ActKeywordStr=ActKeywordStr_";"_ActKeyword_";"
		}
	}
	Quit return
}

/// Do ##class(DHCHAI.RMES.AnalysisKeySrv).Test()
ClassMethod Test()
{
	Set aDocContent="患者今日体温正常，一般情况好，右膝创面部分同前，痂皮已脱落，创面周围无明显渗出及红肿，余症状查体同前。赵宇教授、盛林主治医师查房：观察患者一般情况变化。遵嘱执行。"
	w ..SaveKeyScrResult("HAI",5493,"EMR01||1","测试",aDocContent)
}

/// 创建归一词库
/// w ##class(DHCHAI.RMES.AnalysisKeySrv).CreatOneWords()
ClassMethod CreatOneWords()
{
	New
	
	Set objVersion=##class(DHCHAI.RME.Version).GetObjByCode("RME-HAI")
	Quit:'$IsObject(objVersion) return
	Set VersionDr=objVersion.%Id()
	
	//清归一词库及对照数据
	Kill ^DHCHAI.RME.OneWordsD
	Kill ^DHCHAI.RME.OneWordsI
	Kill ^DHCHAI.RME.ParserWordsD
	Kill ^DHCHAI.RME.ParserWordsI
	Kill ^DHCHAI.RME.ThWordsMapD
	Kill ^DHCHAI.RME.ThWordsMapI
	
	Set xMasterDr=0,Count=0
	For {
		Set xMasterDr=$o(^DHCHAI.RME.DocMasterD(xMasterDr))
		Quit:xMasterDr=""
		w xMasterDr,!
		
		Set xSectionDr=0
		For {
			Set xSectionDr=$o(^DHCHAI.RME.DocMasterD(xMasterDr,"DS",xSectionDr))
			Quit:xSectionDr=""
			
			Set xResultDr=0
			For {
				Set xResultDr=$o(^DHCHAI.RME.DocMasterD(xMasterDr,"DS",xSectionDr,"DR",xResultDr))
				Quit:xResultDr=""
				
				Set objResult=##class(DHCHAI.RME.DocResult).GetObjById(xMasterDr_"||"_xSectionDr_"||"_xResultDr)
				Continue:'$IsObject(objResult)
				
				Set DRName        = objResult.DRName    //归一词
				Set DRFormal      = objResult.DRFormal  //上位词
				Set:DRFormal="" DRFormal=DRName
				If $IsObject(objResult.DRTypeDr) {
					Set DRTypeDr  = objResult.DRTypeDr.%Id()
				} Else {
					Set DRTypeDr  = ""
				}
				Set DRParserWords = objResult.DRParserWords
				Set DRContext     = objResult.DRContext
				Continue:DRFormal=""
				
				Set OneWord=DRFormal,OneWordDr=""
				Set objOnWords=##class(DHCHAI.RME.OneWords).GetObjByVerWord(VersionDr,OneWord)
				If $IsObject(objOnWords) {
					Set OneWordDr=objOnWords.%Id()
				} Else {
					Set InputStr=""_"^"_VersionDr_"^"_OneWord_"^"_DRTypeDr_"^^^"
					Set OneWordDr=##class(DHCHAI.RME.OneWords).Update(InputStr,"^")
					If (+OneWordDr)<1 {
						Set OneWordDr=""
					}
				}
				Continue:OneWordDr=""
				
				Set ParserWords=DRParserWords
				Set LimitWord=$s(ParserWords[";":ParserWords,1:"")
				For indPW=1:1:$l(ParserWords,";") {
					Set ParserWord=$p(ParserWords,";",indPW)
					Continue:ParserWord=""
					
					Set objParserWord=##class(DHCHAI.RME.ParserWords).GetObjByVerKeyWord(VersionDr,ParserWord,LimitWord)
					If '$IsObject(objParserWord){
						Set ParserWordStr=""
						Set ParserWordStr=ParserWordStr_"^"_VersionDr
						Set ParserWordStr=ParserWordStr_"^"_ParserWord
						Set ParserWordStr=ParserWordStr_"^"_LimitWord
						Set ParserWordStr=ParserWordStr_"^"_$tr(DRContext,"^","")
						Set ParserWordStr=ParserWordStr_"^"_OneWordDr
						Set ParserWordStr=ParserWordStr_"^"_0
						Set ParserWordStr=ParserWordStr_"^"_1
						Set ParserWordStr=ParserWordStr_"^^^"
						Set ParserWordDr=##class(DHCHAI.RME.ParserWords).Update(ParserWordStr)
						If (+ParserWordDr)<0 {
							Set Count=Count+1
						}
					}
				}
			}
		}
	}
	//语义词（归一词）与感染症状词（主题词）对照
	Do ##Class(DHCHAI.RMES.ThWordsMapSrv).ChangeMapping()
	Quit Count
}

}
