/// 名称: DHCHAI.IRC.RBReportSrv
/// 描述: 检查报告（影像、病理）检查规则
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.IRC.RBReportSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-05-22
/// Description:  检查规则-影像学
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.RBReportSrv).Check(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="CheckErr"
	
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.RBReportI("IndexEpisodeChkItemRepDate",aEpisodeDr,xSCode))
		Quit:xSCode=""
		
		Set xChkItem=""
		For {
			Set xChkItem=$o(^DHCHAI.DP.RBReportI("IndexEpisodeChkItemRepDate",aEpisodeDr,xSCode,xChkItem))
			Quit:xChkItem=""
			
			Set xDate=aSttDate-1
			For {
				Set xDate=$o(^DHCHAI.DP.RBReportI("IndexEpisodeChkItemRepDate",aEpisodeDr,xSCode,xChkItem,xDate))
				Quit:xDate=""
				Quit:xDate>aEndDate
				
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.DP.RBReportI("IndexEpisodeChkItemRepDate",aEpisodeDr,xSCode,xChkItem,xDate,xID))
					Quit:xID=""
					
					//获取筛查结果
					Do ..GetCheck(xID,aItmMastID)
				}
			}
		}
	}
	
	Quit 1
	
CheckErr
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2018-03-26
/// Description:  检查规则-影像学
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.RBReportSrv).Check2(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check2(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="Check2Err"
	
	Set xDate=aSttDate-1
	For {
		Set xDate=$o(^DHCHAI.DP.RBReportI("IndexEpisUpdateDate",aEpisodeDr,xDate))
		Quit:xDate=""
		Quit:xDate>aEndDate
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.RBReportI("IndexEpisUpdateDate",aEpisodeDr,xDate,xID))
			Quit:xID=""
			
			//获取筛查结果
			Set ret = ..GetCheck(xID,aItmMastID)
			If (+ret)<1{
				Set objReport=##class(DHCHAI.DP.RBReport).GetObjById(xID)
				If $IsObject(objReport){
					Set SCode=objReport.RBSCode
					D ##class(DHCHAI.IRC.CtrlResultSrv).CancelCCResult(aEpisodeDr,aItmMastID,SCode,xID)
				}
			}
		}
	}
	Quit 1
	
Check2Err
	Quit "-999^"_$ZError
}

ClassMethod GetCheck(aReportID As %String, aItmMastID As %String) As %String
{
	New (aReportID,aItmMastID)
	Set return=0
	Quit:(aReportID="")||(aItmMastID="") return
	
	//如果有多次报告，取最新一次报告
	Set objReport=##class(DHCHAI.DP.RBReport).GetObjById(aReportID)
	Quit:'$IsObject(objReport) return
	Quit:'$IsObject(objReport.RBEpisodeDr) return
	Set IsActive=objReport.RBIsActive
	Quit:IsActive'=1 return
	
	Set EpisodeDr=objReport.RBEpisodeDr.%Id()
	Set ReportID=objReport.%Id()
	Set SCode=objReport.RBSCode
	
	Set RISThemeCode="INF-RIS"  //主题分类代码
	
	//语义词库版本
	Set VersionDr=""
	Set objVersion=##class(DHCHAI.RME.ThemeType).GetVersionByThCode(RISThemeCode)  //HAI语义分析词库
	If $IsObject(objVersion){
		Set VersionDr=objVersion.%Id()
	}
	Quit:VersionDr="" return
	
	Set DocNumber=SCode_"||"_ReportID
	Set objDocMaster=##class(DHCHAI.RME.DocMaster).GetObjByDocNumber(VersionDr,DocNumber)
	Quit:'$IsObject(objDocMaster) return
	Quit:'$IsObject(objDocMaster.DMVersionDr) return
	Set VersionDr=objDocMaster.DMVersionDr.%Id()
	Set MasterID=objDocMaster.%Id()
	
	//作废原有记录
	Set flg=##class(DHCHAI.IRC.CtrlResultSrv).CancelCCResult(EpisodeDr, aItmMastID,SCode,ReportID)
	
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
					Continue:objThWordMap.BTIsActive'=1  //add by zf 20190731
					Continue:objThWordMap.BTIsCheck'=1  //add by zf 20190731
					Set objThWord=objThWordMap.BTThWordDr
					Continue:'$IsObject(objThWord)
					Continue:'$IsObject(objThWord.BTThemeTypeDr)
					Set ThemeType=objThWord.BTThemeTypeDr.BTCode
					Continue:ThemeType'=RISThemeCode
					
					Set KeyWord=objThWord.BTKeyWord
					Set LimitWord=objThWord.BTLimitWord
					Set:LimitWord'="" KeyWord=KeyWord+LimitWord
					Continue:$listfind(KeyWordList,KeyWord)>0
					Set KeyWordList=KeyWordList_$lb(KeyWord)
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
	Set ActKeyWords=##class(DHCHAI.Utils.CommonSrv).ListToString(KeyWordList,";") //"^"分隔导致update方法报错
	
	Set IsAbFlag=0 //是否包含特异性关键词
	If (ActKeyWords["炎")||(ActKeyWords["感染"){
		Set IsAbFlag=1
	}
	
	Set ChkItem=objReport.RBCheckItem     //检查项目
	Set RegDate=objReport.RBRegDate       //登记日期
	Set RegTime=objReport.RBRegTime       //登记时间
	Set RegUser=objReport.RBRegUser       //登记人
	Set:RegUser'="" RegUser=$p(RegUser,"|",3)
	Set RepDate=objReport.RBRepDate       //报告日期
	Set RepTime=objReport.RBRepTime       //报告时间
	Set RepUser=objReport.RBRepUser       //报告人
	Set:RepUser'="" RepUser=$p(RepUser,"|",3)
	
	Set obj=##class(DHCHAI.IRC.CtrlRecord).GetObj(EpisodeDr,aItmMastID)
	Quit:'$IsObject(obj) return
	
	Set obj.CCResult    = ActKeyWords  //阳性症状或体征
	Set obj.CCTextRes   = ParserWords  //定性结果
	Set obj.CCUnit      = ChkItem      //单位
	Set obj.CCActDate   = RepDate      //update 20230328 登记日期时间没有记录，使用报告日期作登记日期时间
	Set obj.CCActTime   = RepTime      
	Set obj.CCActUser   = RegUser      //登记人
	Set obj.CCRepDate   = RepDate      //报告日期
	Set obj.CCRepTime   = RepTime      //报告时间
	Set obj.CCRepUser   = RepUser      //报告人
	Set obj.CCSCode     = SCode        //子系统代码
	Set obj.CCObjectID  = ReportID
	Set obj.CCParams    = "ReportID="_ReportID
	
	Set obj.CCKeyWord   = ""           //关键词
	Set obj.CCIsAbFlag  = IsAbFlag     //结果异常
	Set obj.CCSummary   = ChkItem_":"_ActKeyWords      //摘要信息
	
	Set return=##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)
	Quit return
}

}
