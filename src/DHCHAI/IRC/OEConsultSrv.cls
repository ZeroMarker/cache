/// 名称: DHCHAI.IRC.OEAntiUseSrv
/// 描述: 请会诊医嘱检查规则
/// 编写者：zhufei
/// 编写日期: 2018-01-26
Class DHCHAI.IRC.OEConsultSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2018-01-26
/// Description:  检查规则-请会诊医嘱
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.OEConsultSrv).Check(823,$zdh("2018-01-01",3),$zdh("2018-01-26",3),12)
ClassMethod Check(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="CheckErr"
	
	Kill arrOEOrdItem
	
	//^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate")
	//^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate")
	//就诊医嘱开始日期索引
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode))
		Quit:xSCode=""
		
		Set xDate=aSttDate-1
		For {
			Set xDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,0,xDate))
			Quit:xDate=""
			Quit:xDate>aEndDate
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeDr,xSCode,0,xDate,xID))
				Quit:xID=""
				
				Continue:$d(arrOEOrdItem(xID))
				Set arrOEOrdItem(xID)=""
				
				//获取筛查结果
				Do ..GetCheck(xID,aItmMastID)
			}
		}
	}
	//就诊医嘱停止日期索引
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate",aEpisodeDr,xSCode))
		Quit:xSCode=""
		
		Set xDate=aSttDate-1
		For {
			Set xDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate",aEpisodeDr,xSCode,0,xDate))
			Quit:xDate=""
			Quit:xDate>aEndDate
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseXDate",aEpisodeDr,xSCode,0,xDate,xID))
				Quit:xID=""
				
				Continue:$d(arrOEOrdItem(xID))
				Set arrOEOrdItem(xID)=""
				
				//获取筛查结果
				Do ..GetCheck(xID,aItmMastID)
			}
		}
	}
	Kill arrOEOrdItem
	
	Quit 1
	
CheckErr
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2018-03-26
/// Description:  检查规则-请会诊医嘱
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.OEConsultSrv).Check2(823,$zdh("2018-01-01",3),$zdh("2018-01-26",3),12)
ClassMethod Check2(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="Check2Err"
	
	//就诊更新日期索引
	Set xDate=aSttDate-1
	For {
		Set xDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisUpdateDate",aEpisodeDr,xDate))
		Quit:xDate=""
		Quit:xDate>aEndDate
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisUpdateDate",aEpisodeDr,xDate,xID))
			Quit:xID=""
			
			//获取筛查结果
			Set ret = ..GetCheck(xID,aItmMastID)
			If (+ret)<1{
				Set objOEItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(xID)
				If $IsObject(objOEItem){
					Set SCode=objOEItem.OESCode
					D ##class(DHCHAI.IRC.CtrlResultSrv).CancelCCResult(aEpisodeDr,aItmMastID,SCode,xID)
				}
			}
		}
	}
	
	Quit 1
	
Check2Err
	Quit "-999^"_$ZError
}

ClassMethod GetCheck(aOEItemID As %String, aItmMastID As %String) As %String
{
	New (aOEItemID,aItmMastID)
	Set return=0
	Quit:(aOEItemID="")||(aItmMastID="") return
	
	Set objOEItem=##class(DHCHAI.DP.OEOrdItem).GetObjById(aOEItemID)
	Quit:'$IsObject(objOEItem) return
	Quit:'$IsObject(objOEItem.OEEpisodeDr) return
	Set IsActive=objOEItem.OEIsActive
	Quit:IsActive'=1 return
	
	Set OEItemID=objOEItem.%Id()
	Set EpisodeID=objOEItem.OEEpisodeDr.%Id()
	Set SCode=objOEItem.OESCode             //子系统代码
	Set OrdDesc=objOEItem.OEOrdDesc         //医嘱名称
	Set SttDate=objOEItem.OESttDate         //医嘱开始日期
	Set SttTime=objOEItem.OESttTime         //医嘱开始时间
	Set Doctor=objOEItem.OEDoctor           //开医嘱人
	Set DocName=$p(Doctor,"|",3)
	Set XDate=objOEItem.OEXDate             //停医嘱日期
	Set XTime=objOEItem.OEXTime             //停医嘱时间
	
	Set objItmMap=##class(DHCHAI.DP.OEItmMastMap).GetObjByOrdDesc(SCode,OrdDesc)
	Quit:'$IsObject(objItmMap) return
	Quit:'$IsObject(objItmMap.BTMapItemDr) return
	Set objItmCat=objItmMap.BTMapItemDr.BTCatDr
	Quit:'$IsObject(objItmCat) return
	Quit:'$IsObject(objItmCat.BTTypeDr) return
	Set MapItmCatCode=objItmCat.BTCode
	Set MapItmTypeCode=objItmCat.BTTypeDr.BTCode
	Quit:MapItmTypeCode'="COD" //请会诊医嘱
	
	Set KeyWord="请会诊"
	
	Set IsAbFlag=0
	Set RecLoc=objOEItem.OERecLoc
	If (RecLoc["呼吸")||(RecLoc["感染") {
		Set IsAbFlag=1
	}
	
	Set obj=##class(DHCHAI.IRC.CtrlRecord).GetObj(EpisodeID,aItmMastID)
	Quit:'$IsObject(obj) return
	
	Set obj.CCResult    = OrdDesc      //医嘱名称
	Set obj.CCTextRes   = ""           //定性结果
	Set obj.CCUnit      = ""           //单位
	Set obj.CCActDate   = SttDate      //医嘱开始日期
	Set obj.CCActTime   = SttTime      //医嘱开始时间
	Set obj.CCActUser   = DocName      //开医嘱人
	Set obj.CCRepDate   = XDate        //停止日期
	Set obj.CCRepTime   = XTime        //停止时间
	Set obj.CCRepUser   = ""           //停止人
	Set obj.CCSCode     = SCode        //子系统代码
	Set obj.CCObjectID  = OEItemID
	Set obj.CCParams    = "OEItemID="_OEItemID
	
	Set obj.CCKeyWord   = KeyWord      //关键词
	Set obj.CCIsAbFlag  = IsAbFlag     //是否 请感染/呼吸科会诊
	Set obj.CCSummary   = OrdDesc      //摘要信息
	
	Set return=##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-09-19
/// Description:  检查规则-会诊意见
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.DiagnosSrv).EmcCheck(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod EmcCheck(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="EmcCheckErr"
	
	Set xEmCID=""
	For {
		Set xEmCID=$o(^DHCHAI.DP.EmConsultI("IndexEpisodeDr",aEpisodeDr,xEmCID))
		Quit:xEmCID=""
	
		Set objEmC=##class(DHCHAI.DP.EmConsult).GetObjById(xEmCID)
		Continue:'$Isobject(objEmC)
		Continue:objEmC.ECIsActive'=1
	
		Set Opintion=objEmC.ECOpintion
		Continue:Opintion=""
	 
		//获取筛查结果
		Do ..GetEmcCheck(xEmCID,aItmMastID)
		
	}
	
	Quit 1
	
EmcCheckErr
	Quit "-999^"_$ZError
}

ClassMethod GetEmcCheck(aEmCID As %String, aItmMastID As %String) As %String
{
	New (aEmCID,aItmMastID)
	Set return=0
	Quit:(aEmCID="")||(aItmMastID="") return
	
	Set objEmC=##class(DHCHAI.DP.EmConsult).GetObjById(aEmCID)
	Quit:'$isobject(objEmC) return
	Set IsActive = objEmC.ECIsActive
	Quit:IsActive'=1 return

    Set objItmMast= ##class(DHCHAI.IR.CCItmMast).GetObjById(aItmMastID) 
	Quit:'$IsObject(objItmMast) return
	Set ItmMastCode = objItmMast.CCCode

	Set EpisodeDr=objEmC.ECEpisodeDr.%Id()
	Set EmCID=objEmC.%Id()
	Set SCode=objEmC.ECSCode
    Set IsAbFlag=0 
	Quit:'$IsObject(objEmC.ECCLocDr) return
	Set CLocDesc = objEmC.ECCLocDr.BTDesc
	//w !,CLocDesc
	If (CLocDesc["呼吸")||(CLocDesc["感染") {
		Set IsAbFlag=1
	}
	
	Set HAIThemeCode="INF-HAI"  //主题分类代码

	//语义词库版本
	Set VersionDr=""
	Set objVersion=##class(DHCHAI.RME.ThemeType).GetVersionByThCode(HAIThemeCode)  //HAI语义分析词库
	If $IsObject(objVersion){
		Set VersionDr=objVersion.%Id()
	}
	Quit:VersionDr="" return
	Set DocNumber="OEC"_"||"_SCode_"||"_EmCID
	Set objDocMaster=##class(DHCHAI.RME.DocMaster).GetObjByDocNumber(VersionDr,DocNumber)
	Quit:'$IsObject(objDocMaster) return
	Quit:'$IsObject(objDocMaster.DMVersionDr) return
	Set VersionDr=objDocMaster.DMVersionDr.%Id()
	Set MasterID=objDocMaster.%Id()
   
	//作废原有记录
	Set flg=##class(DHCHAI.IRC.CtrlResultSrv).CancelCCResult(EpisodeDr,aItmMastID,SCode,EmCID)
    
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
		            Continue:(ItmMastCode="RME-Consult")&&(WordType'="INF-HAI-03")  //add 20190830 增加入院诊断分析
		            
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
	
	
	Set RDate=objEmC.ECRDate     //申请日期
	Set RTime=objEmC.ECRTime     //申请日期
	Set NDate=objEmC.ECNDate     //会诊日期
	Set NTime=objEmC.ECNTime     //会诊时间
    Set RUserDr=objEmC.ECRUserDr
	Set obj=##class(DHCHAI.IRC.CtrlRecord).GetObj(EpisodeDr,aItmMastID)
	Quit:'$IsObject(obj) return
   
	Set obj.CCResult    = ActKeyWords      //诊断意见
	Set obj.CCTextRes   = ParserWords      //定性结果
	Set obj.CCUnit      = ""           //单位
	Set obj.CCActDate   = RDate        //申请日期
	Set obj.CCActTime   = RTime        //申请时间
	Set obj.CCActUser   = RUserDr      //申请嘱人
	Set obj.CCRepDate   = NDate        //会诊日期
	Set obj.CCRepTime   = NTime        //会诊时间
	Set obj.CCRepUser   = ""           //会诊人
	Set obj.CCSCode     = SCode        //子系统代码
	Set obj.CCObjectID  = EmCID
	Set obj.CCParams    = "ConsultID="_EmCID
	Set obj.CCKeyWord   = ActKeyWords      //关键词
	Set obj.CCIsAbFlag  = IsAbFlag         //是否 异常
	Set obj.CCSummary   = ActKeyWords      //摘要信息

	Set return=##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)
	Quit return
}

}
