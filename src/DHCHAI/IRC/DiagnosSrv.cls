/// 名称: DHCHAI.IRC.DiagnosSrv
/// 描述: 出院诊断检查规则
/// 编写者：pylian
/// 编写日期: 2019-09-11
Class DHCHAI.IRC.DiagnosSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2019-09-11
/// Description:  检查规则-出院诊断
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.DiagnosSrv).Check(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="CheckErr"
	
	Set xDiagID=""
	For {
		Set xDiagID=$o(^DHCHAI.DP.MRDiagnosI("IndexSourceEpis","E",aEpisodeDr,xDiagID))
		Quit:xDiagID=""	
		
		Set objDig=##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagID)
		Continue:'$isobject(objDig)
		Set IsActive = objDig.MRIsActive
		Continue:IsActive'=1
		Set Admission = objDig.MRAdmission
	    Set DiagDesc =objDig.MRDiagDesc
		Continue:((DiagDesc'["切口")&&(DiagDesc'["伤口"))&&(Admission'="无")
       
		//获取筛查结果
		Do ..GetCheck(xDiagID,aItmMastID)
		
	}
	
	Quit 1
	
CheckErr
	Quit "-999^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2019-12-11
/// Description:  检查规则-出院诊断
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.EmrAbnorSrv).Check2(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check2(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="Check2Err"
	
	Set xDate=aSttDate-1
	For {
		Set xDate=$o(^DHCHAI.DP.MRDiagnosI("IndexEpisUpdateDate",aEpisodeDr,xDate))
		Quit:xDate=""
		Quit:xDate>aEndDate
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.MRDiagnosI("IndexEpisUpdateDate",aEpisodeDr,xDate,xID))
			Quit:xID=""
			
			//获取筛查结果
			Set ret = ..GetCheck(xID,aItmMastID)
			If (+ret)<1{
				Set objRecord=##class(DHCHAI.DP.MRDiagnos).GetObjById(xID)
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

/// Creator：     pylian
/// CreatDate：   2019-09-17
/// Description:  检查规则-入院诊断
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.DiagnosSrv).AdmCheck(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod AdmCheck(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="AdmCheckErr"
	
	Set xDiagID=""
	For {
		Set xDiagID=$o(^DHCHAI.DP.MRDiagnosI("IndexSourceEpis","A",aEpisodeDr,xDiagID))
		Quit:xDiagID=""	
		
		Set objDig=##class(DHCHAI.DP.MRDiagnos).GetObjById(xDiagID)
		Continue:'$isobject(objDig)
		Set IsActive = objDig.MRIsActive
		Continue:IsActive'=1
		Set Admission = objDig.MRAdmission
	    Set DiagDesc =objDig.MRDiagDesc
	   
		//获取筛查结果
		Do ..GetCheck(xDiagID,aItmMastID)
		
	}
	
	Quit 1
	
AdmCheckErr
	Quit "-999^"_$ZError
}

ClassMethod GetCheck(aDiagID As %String, aItmMastID As %String) As %String
{
	New (aDiagID,aItmMastID)
	Set return=0
	Quit:(aDiagID="")||(aItmMastID="") return
	
	Set objDig=##class(DHCHAI.DP.MRDiagnos).GetObjById(aDiagID)
	Quit:'$isobject(objDig) return
	Set IsActive = objDig.MRIsActive
	Quit:IsActive'=1 return

    Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjById(aItmMastID) 
	Quit:'$IsObject(objItmMast) return
	Set ItmMastCode = objItmMast.CCCode
	
	Set EpisodeDr=objDig.MREpisodeDr.%Id()
	Set DiagID=objDig.%Id()
	Set SCode=objDig.MRSCode

	Set HAIThemeCode="INF-HAI"  //主题分类代码
	
	//语义词库版本
	Set VersionDr=""
	Set objVersion=##class(DHCHAI.RME.ThemeType).GetVersionByThCode(HAIThemeCode)  //HAI语义分析词库
	If $IsObject(objVersion){
		Set VersionDr=objVersion.%Id()
	}
	Quit:VersionDr="" return
	
	Set DocNumber=SCode_"||"_DiagID
	Set objDocMaster=##class(DHCHAI.RME.DocMaster).GetObjByDocNumber(VersionDr,DocNumber)
	Quit:'$IsObject(objDocMaster) return
	Quit:'$IsObject(objDocMaster.DMVersionDr) return
	Set VersionDr=objDocMaster.DMVersionDr.%Id()
	Set MasterID=objDocMaster.%Id()
    
	//作废原有记录
	Set flg=##class(DHCHAI.IRC.CtrlResultSrv).CancelCCResult(EpisodeDr,aItmMastID,SCode,DiagID)
   
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
		    //w !,xRstSub
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
			Continue:(tContext["预防")&&(tContext["感染")                    //预防性感染
			Continue:(tContext["易出现")&&(tContext["感染")                  //易出现球菌感染
			Continue:(tContext["感染")&&(tContext["明显好转")                //感染明显好转
			Continue:(tContext["存在")&&(tContext["感染")&&(tContext["可能") //存在新生儿感染可能
			Continue:(tContext["控制")&&(tContext["感染")                    //控制感染
			Continue:(tContext["有无")&&(tContext["感染")&&(tContext["可能") //注意有无呼吸道感染及其他感染可能
			Continue:(tContext["感染")&&(tContext["因素")                    //感染性因素
			Continue:(tContext["感染史")
			
			//Update by zf 20180209
			//处理归一词和上位词对应院感归一词库问题
			Set objOneWord=##class(DHCHAI.RME.OneWords).GetObjByOneWord(VersionDr,DRFormal)
			Continue:'$IsObject(objOneWord)
			Set OneWordDr=objOneWord.%Id()
			
			Set IsInfWordFlag=0
			Set ThWordDr=""
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
					Set ThemeType=objThWord.BTThemeTypeDr.BTCode
					Continue:ThemeType'=HAIThemeCode
					Continue:'$IsObject(objThWord.BTWordTypeDr)
					Set WordType = objThWord.BTWordTypeDr.BTCode
					Continue:(ItmMastCode="RME-Diagnos")&&(WordType'="INF-HAI-03")  //add 20190830 增加出院诊断分析
		            Continue:(ItmMastCode="RME-AdmDiagnos")&&(WordType'="INF-HAI-03")  //add 20190830 增加入院诊断分析
		            
					Set KeyWord=objThWord.BTKeyWord
					Set LimitWord=objThWord.BTLimitWord
					Set:LimitWord'="" KeyWord=KeyWord+LimitWord
					Continue:$listfind(KeyWordList,KeyWord)>0
					Set KeyWordList=KeyWordList_$lb(KeyWord)
					Set IsInfWordFlag=1
				}
			}
			Continue:IsInfWordFlag'=1
		}
	}
	Quit:KeyWordList="" return
    
	Set IsAbFlag=1
	Set DiagDate=objDig.MRDiagDate     //诊断日期
	Set DiagTime=objDig.MRDiagTime     //诊断时间
    Set DiagTpDesc = objDig.MRDiagTpDesc
    
	Set obj=##class(DHCHAI.IRC.CtrlRecord).GetObj(EpisodeDr,aItmMastID)
	Quit:'$IsObject(obj) return
	
	For indList=1:1:$ll(KeyWordList) {
		Set KeyWord=$listget(KeyWordList,indList)
		Continue:KeyWord=""	
		//w !,KeyWord
		If (ItmMastCode="RME-AdmDiagnos") {     //入院诊断特殊处理
			Set:(KeyWord'["切口")&&(KeyWord'["器官") IsAbFlag =0
		} 
				
		Set obj.CCResult    = KeyWord     //感染诊断
		Set obj.CCTextRes   = ParserWords  //归一词 
		Set obj.CCUnit      = DiagTpDesc   //单位
		Set obj.CCActDate   = DiagDate     //诊断日期
		Set obj.CCActTime   = DiagTime     //诊断时间
		Set obj.CCActUser   = ""           //登记人
		Set obj.CCRepDate   = DiagDate     //诊断日期
		Set obj.CCRepTime   = DiagTime     //诊断时间
		Set obj.CCRepUser   = ""           //报告人
		Set obj.CCSCode     = SCode        //子系统代码
		Set obj.CCObjectID  = DiagID
		Set obj.CCParams    = "DiagnosID="_DiagID
		
		Set obj.CCKeyWord   = ""           //关键词
		Set obj.CCIsAbFlag  = IsAbFlag     //结果异常
		Set obj.CCSummary   = DiagTpDesc_":"_KeyWord      //摘要信息
	  
		Set return=##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)	
	}
	
	Quit return
}

}
