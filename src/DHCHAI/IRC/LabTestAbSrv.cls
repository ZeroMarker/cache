/// 名称: DHCHAI.IRC.LabTestAbSrv
/// 描述: 常规检验（血、尿、便）检查规则
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.IRC.LabTestAbSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-05-03
/// Description:  检查规则-常规检验（血、尿、便）
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.LabTestAbSrv).Check(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="CheckErr"
	
	Set xVisitNumber=0
	For {
		Set xVisitNumber=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeDr,xVisitNumber))
		Quit:xVisitNumber=""
		
		Set xDate=aSttDate-1
		For {
			Set xDate=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitAuthDateTime",xVisitNumber,xDate))
			Quit:xDate=""
			Quit:xDate>aEndDate
			
			Set xTime=""    //update 2022-01-20  Time=0，0点病人会遗漏
			For {
				Set xTime=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitAuthDateTime",xVisitNumber,xDate,xTime))
				Quit:xTime=""
				
				Set xID=0
				For {
					Set xID=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitAuthDateTime",xVisitNumber,xDate,xTime,xID))
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
/// Description:  检查规则-常规检验（血、尿、便）
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.LabTestAbSrv).Check2(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check2(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="Check2Err"
	
	Set xVisitNumber=0
	For {
		Set xVisitNumber=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDr",aEpisodeDr,xVisitNumber))
		Quit:xVisitNumber=""
		
		Set xDate=aSttDate-1
		For {
			Set xDate=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitUpdateDate",xVisitNumber,xDate))
			Quit:xDate=""
			Quit:xDate>aEndDate
			
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitUpdateDate",xVisitNumber,xDate,xID))
				Quit:xID=""
				
				// 先取消报告下的监控结果
				Set xRstID=0
				For {
					Set xRstID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xID,xRstID))
					Quit:xRstID=""
					
					Set objRst=##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xRstID)
					If $IsObject(objRst){
						if $IsObject(objRst.LabReportDr){
							Set SCode=objRst.LabReportDr.LabSCode
							Set TSReportID=objRst.LabReportDr.LabReportID  //检验报告号
							Set TestCode = objRst.LabTestCode
							Set ObjectID=TSReportID_"||"_TestCode
							D ##class(DHCHAI.IRC.CtrlResultSrv).CancelCCResult(aEpisodeDr,aItmMastID,SCode,ObjectID)
						}
					}
				}
				//获取筛查结果
				Do ..GetCheck(xID,aItmMastID)
			}
		}
	}
	
	Quit 1
	
Check2Err
	Quit "-999^"_$ZError
}

ClassMethod GetCheck(aRepID As %String, aItmMastID As %String) As %String
{
	New (aRepID,aItmMastID)
	Set return=0
	Quit:(aRepID="")||(aItmMastID="") return
	
	Set objReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(aRepID)
	Quit:'$IsObject(objReport) return
	Set IsActive=objReport.LabIsActive
	Quit:IsActive'=1 return
	
	Set objVisitNumber=objReport.LabVisitNumberDr
	Quit:'$IsObject(objVisitNumber) return
	Set IsActive=objVisitNumber.LabIsActive
	Quit:IsActive'=1 return
	
	Set SCode=objVisitNumber.LabSCode
	Quit:'$IsObject(objReport.LabTestSetDr) return
	Set TestSetDesc=objReport.LabTestSetDr.LabTestSetDesc
	/*
	Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet(SCode,TestSetDesc)
	Quit:'$IsObject(objTestSetMap) return
	Quit:'$IsObject(objTestSetMap.BTMapItemDr) return
	Quit:'$IsObject(objTestSetMap.BTMapItemDr.BTCatDr) return
	Set MapTSDesc=objTestSetMap.BTMapItemDr.BTTestSet
	Set MapTSCatDesc=objTestSetMap.BTMapItemDr.BTCatDr.BTDesc
	//update 20211129  病毒支原体检测修改为生化免疫检测
	Quit:(MapTSCatDesc'="常规检验")&&(MapTSCatDesc'="微生物送检")&&(MapTSCatDesc'="生化免疫检测") return
	*/
	//判断送检记录是否检验医嘱对照/检验项目对照
	Set checkFlg =0 	 
	Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet(SCode,TestSetDesc)
	Quit:'$IsObject(objTestSetMap) return
	Set objTestSet = objTestSetMap.BTMapItemDr	
	If ($IsObject(objTestSet)) {   //检验医嘱是否对照
		Set MapTSDesc=objTestSet.BTTestSet
		If ($IsObject(objTestSet.BTCatDr)){
			Set MapTSCatDesc=objTestSet.BTCatDr.BTDesc
			//update 20211129  病毒支原体检测修改为生化免疫检测
		    Set:(MapTSCatDesc="常规检验")||(MapTSCatDesc="微生物送检")||(MapTSCatDesc="生化免疫检测") checkFlg=1 
		}
	}
	If (checkFlg=0) {    //检验项目是否对照
		Set xTestCode=""
		For {
			Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",aRepID,xTestCode))
			Quit:xTestCode=""
			Quit:checkFlg=1
			
			Set xMapItemDr=0
			For {
				Set xMapItemDr= $o(^DHCHAI.DP.LabTCMapI("IndexMapCodeDr",xTestCode,xMapItemDr))
				Quit:xMapItemDr=""
				
				Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetD(xMapItemDr))
				Continue:TestSetMapData=""	 //检验医嘱对照
				Continue:'$li(TestSetMapData,5)	//无效判断
				Set MapTSDesc=$li(TestSetMapData,3)
				Set TestSetCatDr=$li(TestSetMapData,4)
				Continue:TestSetCatDr=""
				Set TestSetCatData=$g(^DHCHAI.DP.LabTestSetCatD(TestSetCatDr))				
				Continue:TestSetCatData=""
				Set MapTSCatDesc = $li(TestSetCatData,3)	
				//update 20211129  病毒支原体检测修改为生化免疫检测	
  				Set:(MapTSCatDesc="常规检验")||(MapTSCatDesc="微生物送检")||(MapTSCatDesc="生化免疫检测") checkFlg=1 
  				Quit					
			}
		}
	}
	Quit:checkFlg'=1 return  
	  
	Set EpisodeID=objVisitNumber.LabEpisodeDr.%Id()
	Set Sex=objVisitNumber.LabEpisodeDr.PASex //M男、F女
	Set Specimen=objVisitNumber.LabSpecimen
	
	Set CollDate=objVisitNumber.LabCollDate		//采集日期
	Set CollTime=objVisitNumber.LabCollTime
	Set RecDate=objVisitNumber.LabRecDate		//接受日期
	Set RecTime=objVisitNumber.LabRecTime
	Set RecUser=objVisitNumber.LabRecUser
	Set:RecUser'="" RecUser=$p(RecUser,"|",3)
	
	//申请科室|送检科室
	If $IsObject(objVisitNumber.LabLocDr) {
		Set LocDr=objVisitNumber.LabLocDr.%Id()
	} Else {
		Set LocDr=""
	}
	
	Set ReportID=objReport.%Id()
	Set TSReportID=objReport.LabReportID  //检验报告号
	Set TSRepOrder=objReport.LabRepOrder  //检验序号
	Set AuthDate=objReport.LabAuthDate
	Set AuthTime=objReport.LabAuthTime
	Set AuthUser=objReport.LabAuthUser
	Set:AuthUser'="" AuthUser=$p(AuthUser,"|",3)
	
	Set obj=##class(DHCHAI.IRC.CtrlRecord).GetObj(EpisodeID,aItmMastID)
	Quit:'$IsObject(obj) return
	
	Set SpecMapID=""
	Set objSpecMap=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(SCode,Specimen)
	Set:$IsObject(objSpecMap) SpecMapID=objSpecMap.%Id()
	
	Set xTestCode=""
	For {
		Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",aRepID,xTestCode))
		Quit:xTestCode=""
		
		//筛查检验项目
		Set objTCMap=##class(DHCHAI.DP.LabTCMap).GetObjByTestCode(SCode,xTestCode)
		Continue:'$IsObject(objTCMap)
		Set TCMapID=objTCMap.%Id()
		Continue:'$d(^DHCHAI.IR.CRuleTestAbI("TC","IdxofTestCodeDr",TCMapID))
		
		Set xRstID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",aRepID,xTestCode,0))
		Continue:xRstID=""
		Set objRst=##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xRstID)
		Continue:'$IsObject(objRst)
		Set ResultID=objRst.%Id()
		Set TestCode=objRst.LabTestCode
		Continue:TestCode=""
		Set TestDesc=objRst.LabTestDesc
		//Set RstFormat=objRst.LabRstFormat  //原始的类型 用修改项目类型对照
		Set RstFormat=objTCMap.BTRstFormat
		Continue:RstFormat=""
		Set MapRstFormat=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABRstFormat",RstFormat)
		Continue:MapRstFormat=""
		Set Result=objRst.LabResult
		Continue:Result=""
		Set TextRes=objRst.LabTextRes
		Set Unit=objRst.LabUnit
		Set:Unit["^" Unit=$tr(Unit,"^","~")       //特殊字符处理
		Set:TextRes="" TextRes=Result_" "_Unit
		Set AbFlag=objRst.LabAbFlag
		
		Set TCMapAbID=""
		Set objTCMapAb=##class(DHCHAI.DP.LabTCMapAb).GetObjByTCMapID(TCMapID,AbFlag)
		Set:$IsObject(objTCMapAb) TCMapAbID=objTCMapAb.%Id()
		
		Set TCMapRstID=""
		If (MapRstFormat="S")||(MapRstFormat="T") {  ////add 20210512 比较检验结果为“+/-”或“阴性、阳性”的文本类结果
			Set objTCMapRst=##class(DHCHAI.DP.LabTCMapRst).GetObjByTCMapID(TCMapID,Result)
			Set:$IsObject(objTCMapRst) TCMapRstID=objTCMapRst.%Id()
		}
		
		Set MRBTpDr="",Bacteria="",MRBDesc=""
		Set KeyWord=MapTSDesc  //常规检验 医嘱项（血常规、尿常规、腹水常规）
		Set IsAbFlag=0  //常规检验异常
		Set xRuleID=0
		For {
			Set xRuleID=$o(^DHCHAI.IR.CRuleTestAbI("TC","IdxofTestCodeDr",TCMapID,xRuleID))
			Quit:xRuleID=""
			
			Set objRule=##class(DHCHAI.IR.CRuleTestAb).GetObjById(xRuleID)
			Continue:'$IsObject(objRule)
			Continue:objRule.BTIsActive'=1
			Set TSPFlag=objRule.BTTSPFlag  //筛查标本
			Set TRFFlag=objRule.BTTRFFlag  //比较异常标志
			Set TRFlag=objRule.BTTRFlag    //比较结果标志
			Continue:(TRFFlag'=1)&(TRFlag'=1)
			Set TestSet=objRule.BTTestSet
			
			//筛查标本
			If TSPFlag=1 {
				Continue:SpecMapID=""
				Continue:'$d(^DHCHAI.IR.CRuleTestAbI("TSP","IdxofTestSpecDr2",xRuleID,SpecMapID))
			}
			
			//比较异常标志
			If TRFFlag=1 {
				Continue:TCMapAbID=""
				Continue:'$d(^DHCHAI.IR.CRuleTestAbI("TRF","IdxofAbFlagDr2",xRuleID,TCMapAbID))
			}
			
			//比较结果标志
			If TRFlag=1 {
				If MapRstFormat="S" {
					Continue:TCMapRstID=""
					Continue:'$d(^DHCHAI.IR.CRuleTestAbI("TR","IdxofTestResultDr2",xRuleID,TCMapRstID))  //修改索引错误
				} ElseIf MapRstFormat="T" {    //add 20210512 比较检验结果为“+/-”或“阴性、阳性”的文本类结果
					Continue:TCMapRstID=""
					Continue:'$d(^DHCHAI.IR.CRuleTestAbI("TR","IdxofTestResultDr2",xRuleID,TCMapRstID)) 
				} Else {
					Continue:Result=""
					Set TRVMaxFlag=objRule.BTTRVMaxFlag
					Set TRVMinFlag=objRule.BTTRVMinFlag
					Set MaxValM=objRule.BTMaxValM
					Set MaxValF=objRule.BTMaxValF
					Set MinValM=objRule.BTMinValM
					Set MinValF=objRule.BTMinValF
					
					Set IsError=0
					If TRVMaxFlag=1 {
						Set:(Sex="M")&(Result>MaxValM) IsError=1
						Set:(Sex="F")&(Result>MaxValF) IsError=1
					}
					If TRVMinFlag=1 {
						Set:(Sex="M")&(Result<MinValM) IsError=1
						Set:(Sex="F")&(Result<MinValF) IsError=1
					}
					Continue:IsError<1
				}
			}
			Set IsAbFlag=1
			Set:TestSet'="" KeyWord=TestSet  //检验医嘱作为关键词
			
			Set MRBResult=##class(DHCHAI.IRS.CRuleMRBSrv).CheckMRBRule2(objRst,objRule)
			Set MRBTpDr  = $p(MRBResult,"^",1)
			Set MRBDesc  = $p(MRBResult,"^",2)
			Set Bacteria = $p(MRBResult,"^",5)
		}
		Continue:IsAbFlag<1
		// add by zhoubo 2019-04-23  start 
		//根据系统配置：任务筛查出多耐患者时是否自动向临床发送消息
		Set MsgSendFlag=##class(DHCHAI.BT.Config).GetValByCode("MRBMsgSendFlag")
		If ((MsgSendFlag="1")&&(MRBTpDr'="")) {
			Set CSMsgDtlID = ##class(DHCHAI.IRS.CtlMRBSrv).SendMRBMsg(EpisodeID,MRBTpDr,AuthDate)
			
		}
		// add by zhoubo 2019-04-23  end
		Set ObjectID=TSReportID_"||"_TestCode
		
		Set obj.CCResult    = Result       //细菌名称
		Set obj.CCTextRes   = TextRes      //定性结果
		Set obj.CCUnit      = Unit         //单位
		Set obj.CCActLocDr  = LocDr        //送检科室
		Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
		Set CollTime=$s(CollTime'="":CollTime,1:RecTime)		//送检时间优先用采集时间		
		Set obj.CCActDate   = CollDate     //接收标本日期
		Set obj.CCActTime   = CollTime     //接收标本时间
		Set obj.CCActUser   = RecUser      //接收标本人
		Set obj.CCRepDate   = AuthDate     //审核报告日期
		Set obj.CCRepTime   = AuthTime     //审核报告时间
		Set obj.CCRepUser   = AuthUser     //审核报告人
		Set obj.CCSCode     = SCode        //子系统代码
		Set obj.CCObjectID  = ObjectID
		Set obj.CCParams    = "ResultID="_xRstID
		
		Set obj.CCSpecimen  = Specimen     //标本
		Set obj.CCBacteria  = Bacteria     //细菌检测（例子：难辨梭菌毒素测定->难辨梭菌）
		Set obj.CCMRBTpDr   = MRBTpDr      //多耐分类
		Set obj.CCKeyWord   = KeyWord      //关键词
		Set obj.CCIsAbFlag  = IsAbFlag     //结果异常
		Set obj.CCSummary   = TestDesc_":"_TextRes  //摘要信息
		
		Set flg=##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)
	}
	
	Set return=1
	Quit return
}

}
