/// 名称: DHCHAI.IRC.LabBacteriaSrv
/// 描述: 病原菌检验检查规则
/// 编写者：zhufei
/// 编写日期: 2017-03-20
Class DHCHAI.IRC.LabBacteriaSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-05-03
/// Description:  检查规则-检出菌
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.LabBacteriaSrv).Check(8073,64790,64805,1)
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
/// Description:  检查规则-检出菌
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.LabBacteriaSrv).Check2(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
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
	
	// update 20230210 优化调整 
	//根据系统配置：1:检验科那边勾选了多耐标记后，才进行院感多耐分类的判断;0:直接进行院感多耐分类的判断
	Set LabMDRResultFlag=##class(DHCHAI.BT.Config).GetValByCode("LabMDRResultFlag") 
	//根据系统配置：任务筛查出多耐患者时是否自动向临床发送消息
	Set MsgSendFlag=##class(DHCHAI.BT.Config).GetValByCode("MRBMsgSendFlag")

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
	Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet(SCode,TestSetDesc)
	Quit:'$IsObject(objTestSetMap) return
	Quit:'$IsObject(objTestSetMap.BTMapItemDr) return
	Quit:'$IsObject(objTestSetMap.BTMapItemDr.BTCatDr) return
	Set MapTSDesc=objTestSetMap.BTMapItemDr.BTTestSet
	Set MapTSCatDesc=objTestSetMap.BTMapItemDr.BTCatDr.BTDesc
	Quit:MapTSCatDesc'="微生物送检" return
	
	Set EpisodeID=objVisitNumber.LabEpisodeDr.%Id()
	Set Specimen=objVisitNumber.LabSpecimen
	Set CollDate=objVisitNumber.LabCollDate		//采集日期
	Set CollTime=objVisitNumber.LabCollTime		//采集时间
	Set RecDate=objVisitNumber.LabRecDate		//接受日期
	Set RecTime=objVisitNumber.LabRecTime		//接受时间
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
	
	Set xRstID=0
	For {
		Set xRstID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",aRepID,xRstID))
		Quit:xRstID=""
		
		Set objRst=##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xRstID)
		Continue:'$IsObject(objRst)
		Set ResultID=objRst.%Id()
		Set TestCode=objRst.LabTestCode
		Continue:TestCode=""
		Set TestDesc=objRst.LabTestDesc
		Set RstFormat=objRst.LabRstFormat
		Continue:RstFormat=""
		Set MapRstFormat=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABRstFormat",RstFormat)
		Continue:MapRstFormat=""
		Continue:MapRstFormat'="M"
		Set Bacteria=objRst.LabResult
		Set Bacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria)  //去掉特殊字符
		Continue:Bacteria=""
		Set TextRes=Bacteria
		
		Set KeyWord="检出菌"
		Set IsAbFlag=0 //耐药菌
		Set xSenID=0
		For {
			Set xSenID=$o(^DHCHAI.DP.LabVisitRepRstSenI("IndexLabResultDr",ResultID,xSenID))
			Quit:xSenID=""
			
			Set objSen=##class(DHCHAI.DP.LabVisitRepRstSen).GetObjById(xSenID)
			Continue:'$IsObject(objSen)
			Set AntiDesc=objSen.LabAntDesc
			Continue:AntiDesc=""
			Set TestSen=objSen.LabSensitivity
			Set MapTestSen=##class(DHCHAI.DP.PhraseMap).GetMapValue(SCode,"LABTestRstSen",TestSen)
			Continue:MapTestSen'="R"    //是否将耐药改成Continue:MapTestSen="I"？
			
			Set IsAbFlag=1
			Quit //检出ESBLs Quit
		}
		Set MultipleRes = objRst.MultipleResChild   //add 20230423 检验多耐类型
		Set LabMDRResult = +objRst.LabMDRResult // 多耐标记
	    Set MRBResult=""
		If ((LabMDRResultFlag=1)&(LabMDRResult=1))||(LabMDRResultFlag'=1)  {  // 多耐分类筛查
			Set MRBResult=##class(DHCHAI.IRS.CRuleMRBSrv).CheckMRBRule(objRst)
		}
		// 同一种细菌满足两种多耐规则(大肠(ESBL\CRE)、肺克(ESBL\CRE))
		If (MRBResult["#"){
			//调整多耐分类的顺序-兼容历史项目处理只统计一个多耐类型 3285244
			if ((MRBResult_"^")["7^")&((MRBResult_"^")["5^")
			{
				if ($p(MRBResult,"^",5)["ESBLs")
				{
					Set MRBResult1=$p(MRBResult,"#",2)
					Set MRBResult2=$p(MRBResult,"#",1)
				}else {
					Set MRBResult1 = $p(MRBResult, "#",1)
					Set MRBResult2 = $p(MRBResult, "#",2)
				}
			}elseif (MRBResult["4^")&(MRBResult["6^")
			{
				if ($p(MRBResult,"^",5)["ESBLs")
				{
					Set MRBResult1=$p(MRBResult,"#",2)
					Set MRBResult2=$p(MRBResult,"#",1)
				}else {
					Set MRBResult1 =$p(MRBResult,"#",1)
					Set MRBResult2 =$p(MRBResult,"#",2)	
				}
			}
			else {
				Set MRBResult1 = $p(MRBResult,"#",1)
				Set MRBResult2 = $p(MRBResult,"#",2)	
			}
		}Else{
			Set MRBResult1 = MRBResult
			Set MRBResult2 = ""
		}
		Set MRBTpDr  = $p(MRBResult1,"^",1)
		Set MRBDesc  = $p(MRBResult1,"^",2)
		Set MRBTp2Dr = $p(MRBResult2,"^",1)
		Set MRBDesc2 = $p(MRBResult2,"^",2)
		Set:MRBTpDr'="" IsAbFlag =1
		
		If ((MsgSendFlag="1")&&(MRBTpDr'="")) {
			Set CSMsgDtlID = ##class(DHCHAI.IRS.CtlMRBSrv).SendMRBMsg(EpisodeID,MRBTpDr,AuthDate)
			If (MRBTp2Dr'=""){
				Set CSMsgDtlID = ##class(DHCHAI.IRS.CtlMRBSrv).SendMRBMsg(EpisodeID,MRBTp2Dr,AuthDate)
			}
		}
		

		// add by zhoubo 2019-04-23  end
		Set ObjectID=TSReportID_"||"_TestCode
		
		Set obj.CCResult    = Bacteria     //细菌名称
		Set obj.CCTextRes   = ""           //定性结果
		Set obj.CCUnit      = ""           //单位
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
		Set obj.CCBacteria  = Bacteria     //细菌
		Set obj.CCMRBTpDr   = MRBTpDr      //多耐分类
		Set obj.CCKeyWord   = KeyWord      //关键词
		Set obj.CCIsAbFlag  = IsAbFlag     //结果异常
		Set obj.CCSummary   = TestDesc_":"_TextRes  //摘要信息
		Set obj.CCMRBTp2Dr  = MRBTp2Dr     //多耐分类2
		Set obj.MultipleResChild  = MultipleRes   //add 20230423 检验多耐类型
		
		Set flg=##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)
	}
	
	Set return=1
	Quit return
}

}
