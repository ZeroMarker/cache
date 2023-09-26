/// 名称: DHCHAI.IRC.LabSubmitSrv
/// 描述: 微生物送检、常规送检（血、尿、便）检查规则
/// 编写者：zhufei
/// 编写日期: 2017-05-13
Class DHCHAI.IRC.LabSubmitSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-05-13
/// Description:  检查规则-微生物送检、常规送检（血、尿、便）
/// Table：       DHCHAI.IR.CCResult
/// Input：       aEpisodeDr : 就诊号（DHCHAI.DP.PAAdm.ID）
///               aSttDate : 开始日期
///               aEndDate : 截止日期
///               aItmMastID : 监控项目（DHCHAI.IR.CCItmMast.ID）
/// Return：      返回String
/// w ##class(DHCHAI.IRC.LabBacteriaSrv).Check(aEpisodeDr,aSttDate,aEndDate,aItmMastID)
ClassMethod Check(aEpisodeDr As %String, aSttDate As %String, aEndDate As %String, aItmMastID As %String) As %String
{
	new (aEpisodeDr,aSttDate,aEndDate,aItmMastID)
	Set return=0
	Quit:(aSttDate="")||(aEndDate="")||(aItmMastID="") return
	Quit:aEpisodeDr="" return
	
	Set $ZT="CheckErr"
	
	Set xSCode=""
	For {
		Set xSCode=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDrRecDate",aEpisodeDr,xSCode))
		Quit:xSCode=""
		
		Set xDate=aSttDate-1
		For {
			Set xDate=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDrRecDate",aEpisodeDr,xSCode,xDate))
			Quit:xDate=""
			Quit:xDate>aEndDate
			
			Set xVisitNumberID=0
			For {
				Set xVisitNumberID=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDrRecDate",aEpisodeDr,xSCode,xDate,xVisitNumberID))
				Quit:xVisitNumberID=""
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberDr",xVisitNumberID,xID))
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
/// Description:  检查规则-微生物送检、常规送检（血、尿、便）
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
	
	Set xDate=aSttDate-1
	For {
		Set xDate=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisUpdateDate",aEpisodeDr,xDate))
		Quit:xDate=""
		Quit:xDate>aEndDate
		
		Set xVisitNumberID=0
		For {
			Set xVisitNumberID=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisUpdateDate",aEpisodeDr,xDate,xVisitNumberID))
			Quit:xVisitNumberID=""
			
			Set xID=""
			For {
				Set xID=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberDr",xVisitNumberID,xID))
				Quit:xID=""
				
				//获取筛查结果
				Set ret = ..GetCheck(xID,aItmMastID)
				If (+ret)<1{
					Set objVisitTestSet=##class(DHCHAI.DP.LabVisitTestSet).GetObjById(xID)
					If $IsObject(objVisitTestSet){
						If $IsObject(objVisitTestSet.LabVisitNumberDr){
							Set SCode=objVisitTestSet.LabVisitNumberDr.LabSCode
							D ##class(DHCHAI.IRC.CtrlResultSrv).CancelCCResult(aEpisodeDr,aItmMastID,SCode,xID)
						}
					}
				}
			}
		}
	}
	
	Quit 1
	
Check2Err
	Quit "-999^"_$ZError
}

ClassMethod GetCheck(aVisitTestSetID As %String, aItmMastID As %String) As %String
{
	New (aVisitTestSetID,aItmMastID)
	Set return=0
	Quit:(aVisitTestSetID="")||(aItmMastID="") return
	
	//如果有多次报告，取最新一次报告
	Set objVisitTestSet=##class(DHCHAI.DP.LabVisitTestSet).GetObjById(aVisitTestSetID)
	Quit:'$IsObject(objVisitTestSet) return
	Set objVisitNumber=objVisitTestSet.LabVisitNumberDr
	Quit:'$IsObject(objVisitNumber) return
	Quit:'$IsObject(objVisitNumber.LabEpisodeDr) return
	Set IsActive=objVisitNumber.LabIsActive
	Quit:IsActive'=1 return
	
	Set EpisodeID=objVisitNumber.LabEpisodeDr.%Id()
	Set SCode=objVisitNumber.LabSCode               //子系统代码
	Set TestSetDesc=objVisitTestSet.LabTestSetDesc  //检验医嘱
	Set OrdTSDesc=objVisitTestSet.LabOrdTSDesc      //检验医嘱代码
	
	//判断送检记录是否检验医嘱对照/检验项目对照
	Set TestSet="",TestSetCatDesc="",checkFlg =0 	 
	Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet(SCode,TestSetDesc)
	Quit:'$IsObject(objTestSetMap) return
	Set objTestSet = objTestSetMap.BTMapItemDr	
	If ($IsObject(objTestSet)) {   //检验医嘱是否对照
		Set TestSet =objTestSet.BTTestSet
		If ($IsObject(objTestSet.BTCatDr)){
			Set TestSetCatDesc=objTestSet.BTCatDr.BTDesc
			//update 20211129  病毒支原体检测修改为生化免疫检测
		    Set:(TestSetCatDesc="常规检验")||(TestSetCatDesc="微生物送检")||(TestSetCatDesc="生化免疫检测") checkFlg=1 
		}
	}
	If (checkFlg=0) {    //检验项目是否对照
		Set VisitNumberID = objVisitNumber.%Id()
		//最新检验报告
		Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",VisitNumberID,aVisitTestSetID,""),-1)
		Quit:xOrder="" return
		Set xVisitReportDr=0
		For {
			Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",VisitNumberID,aVisitTestSetID,xOrder,xVisitReportDr))
			Quit:xVisitReportDr=""
			
			Set xTestCode=""
			For {
				Set xTestCode=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabTCCode",xVisitReportDr,xTestCode))
				Quit:xTestCode=""
				Quit:checkFlg=1
				
				Set xMapItemDr=0
				For {
					Set xMapItemDr= $o(^DHCHAI.DP.LabTCMapI("IndexMapCodeDr",xTestCode,xMapItemDr))
					Quit:xMapItemDr=""
					
					Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetD(xMapItemDr))
					Continue:TestSetMapData=""	 //检验医嘱对照
					Continue:'$li(TestSetMapData,5)	//无效判断
					Set TestSet=$li(TestSetMapData,3)
					Set TestSetCatDr=$li(TestSetMapData,4)
					Continue:TestSetCatDr=""
					Set TestSetCatData=$g(^DHCHAI.DP.LabTestSetCatD(TestSetCatDr))				
					Continue:TestSetCatData=""
					Set TestSetCatDesc	= $li(TestSetCatData,3)	
					//update 20211129  病毒支原体检测修改为生化免疫检测
	  				Set:(TestSetCatDesc="常规检验")||(TestSetCatDesc="微生物送检")||(TestSetCatDesc="生化免疫检测") checkFlg=1 
	  				Quit					
				}
			}
		}
	}
	Quit:checkFlg'=1 return    
	
	Set Specimen=objVisitNumber.LabSpecimen	  //标本
	Set LocDr=""                          //送检科室
	If $IsObject(objVisitNumber.LabLocDr) {
		Set LocDr=objVisitNumber.LabLocDr.%Id()
	}
	Set CollDate=objVisitNumber.LabCollDate		//采集日期
	Set CollTime=objVisitNumber.LabCollTime
	Set RecDate=objVisitNumber.LabRecDate    	//接收标本日期
	Set RecTime=objVisitNumber.LabRecTime    	//接收标本时间
	Set RecUser=objVisitNumber.LabRecUser    	//接收标本人
	Set:RecUser'="" RecUser=$p(RecUser,"|",3)
	
	Set KeyWord=""
	If TestSetCatDesc="常规检验" {
		Set KeyWord=TestSet
	} ElseIf TestSetCatDesc="微生物送检" {
		Set KeyWord="细菌培养"
	}Else {
		Set KeyWord=TestSet
	}
	
	Set obj=##class(DHCHAI.IRC.CtrlRecord).GetObj(EpisodeID,aItmMastID)
	Quit:'$IsObject(obj) return
	
	Set obj.CCResult    = TestSetDesc  //送检
	Set obj.CCTextRes   = ""           //定性结果
	Set obj.CCUnit      = ""           //单位
	Set obj.CCActLocDr  = LocDr        //送检科室
	Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
	Set CollTime=$s(CollTime'="":CollTime,1:RecTime)		//送检时间优先用采集时间		
	Set obj.CCActDate   = CollDate     //接收标本日期
	Set obj.CCActTime   = CollTime     //接收标本时间
	Set obj.CCActUser   = RecUser      //接收标本人
	Set obj.CCRepDate   = ""           //审核报告日期
	Set obj.CCRepTime   = ""           //审核报告时间
	Set obj.CCRepUser   = ""           //审核报告人
	Set obj.CCSCode     = SCode        //子系统代码
	Set obj.CCObjectID  = aVisitTestSetID
	Set obj.CCParams    = "VisitTestSetID="_aVisitTestSetID
	
	Set obj.CCSpecimen  = Specimen     //标本
	Set obj.CCKeyWord   = KeyWord      //关键词
	Set obj.CCSummary   = TestSetDesc  //摘要信息
	
	Set return=##class(DHCHAI.IRC.CtrlResultSrv).SaveResult(obj)
	Quit return
}

}
