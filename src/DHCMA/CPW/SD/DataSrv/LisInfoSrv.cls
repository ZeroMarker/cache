Class DHCMA.CPW.SD.DataSrv.LisInfoSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCMA.CPW.SD.DataSrv.LisInfoSrv).SynLisInfo(539) 
ClassMethod SynLisInfo(aEpisodeID) As %String
{
	New (aEpisodeID)	
	Set LisVer=##class(DHCMA.Util.BT.Config).GetValueByCode("SDLisVer")
	Set:LisVer="" LisVer="2.0" ;默认2.0
	If (LisVer="2.0" ){
		set ret=..GetV2LisInfo(aEpisodeID)	
	}elseif (LisVer="C2.0"){
		//走平台取检验结果
		set ret=..GetV2CListInfo(aEpisodeID)	
	}else {
		set ret=..GetV1LisInfo(aEpisodeID)	
	}
	Quit ret
}

ClassMethod GetV2LisInfo(aEpisodeID) As %String
{
	New (aEpisodeID)
	Set xReqDate="",VisitCount=0
	For {
		Set xReqDate=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(aEpisodeID),xReqDate))
		Quit:xReqDate=""
		
		Set xVisitNumberDr=0
		For {
			Set xVisitNumberDr=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(aEpisodeID),xReqDate,xVisitNumberDr))
			Quit:xVisitNumberDr=""
			Set VisitNumberData=$g(^dbo.RPVisitNumberD(xVisitNumberDr))
			Continue:VisitNumberData=""
			Set EpisodeID=$listget(VisitNumberData,5)		// 就诊号
			Continue:EpisodeID=""
			Set AdmStr = $g(^PAADM(+EpisodeID))
			Set AdmType= $p(AdmStr,"^",2)	                //就诊类型
			Continue:(AdmType'="I")&(AdmType'="E")
			Set VisitCount=VisitCount+1
			Set xWorkGrpMachDr=""
			For {
				Set xWorkGrpMachDr=$o(^dbo.RPVisitNumberReportI("IndexReportID",xVisitNumberDr,xWorkGrpMachDr))
				Quit:xWorkGrpMachDr=""
				Set xOrderNo=0
				For {
					Set xOrderNo=$o(^dbo.RPVisitNumberReportI("IndexReportID",xVisitNumberDr,xWorkGrpMachDr,xOrderNo))
					Quit:xOrderNo=""
					Set xReportDr=0
					For {
						Set xReportDr=$o(^dbo.RPVisitNumberReportI("IndexReportID",xVisitNumberDr,xWorkGrpMachDr,xOrderNo,xReportDr))
						Quit:xReportDr=""
						
						Set ReportData=$g(^dbo.RPVisitNumberReportD(xReportDr))
						Continue:ReportData=""
						Set VisitNumberDr=$lg(ReportData,2)		   //标本ID
						Continue:VisitNumberDr=""
						Set AuthDate=$lg(ReportData,19)		       //审核日期
						Set AuthTime=$lg(ReportData,20)		       //审核时间
						Set:$l(AuthDate)=8 AuthDate=$zdh(($e(AuthDate,1,4)_"-"_$e(AuthDate,5,6)_"-"_$e(AuthDate,7,8)),3)
						Set Data=..BuildVisitReport(xReportDr)
						Continue:Data=""
						
						Set EpisodeNo=$lg(Data,4)
						Set RepStatus=$lg(Data,22)
						Set OrdID=+$o(^OEORD(0,"EpisNo",EpisodeNo,""))
						Set SubID=+$o(^OEORD(0,"EpisNo",EpisodeNo,OrdID,""))
						Set OEItemID=OrdID_"||"_SubID
						Set TSStr=$lg(Data,19)
						Set TSDesc=$p(TSStr,"^",2)
						Set TSCode=$p(TSStr,"^",1)
						Set SpecDesc=$lg(Data,6)
						Set AppLoc=$lg(Data,7)_"|"_$lg(Data,8)
						Set CollDate=$lg(Data,9)					// 采集日期						
						Set CollTime=$lg(Data,10)					// 采集时间						
						Set CollUser=$lg(Data,11)_"|"_$lg(Data,12)	// 采集者					
						Set RecDate=$lg(Data,13)					// 接收日期
						Set RecTime=$lg(Data,14)					// 接收时间
						Set RecUser=$lg(Data,15)_"||"_$lg(Data,16)	// 接收者
						//保存检验信息
						Set LabInfoStr=aEpisodeID
						Set LabInfoStr=LabInfoStr_$c(1)_xReportDr
						Set LabInfoStr=LabInfoStr_$c(1)_OEItemID
						Set LabInfoStr=LabInfoStr_$c(1)_TSDesc
						Set LabInfoStr=LabInfoStr_$c(1)_TSCode
						Set LabInfoStr=LabInfoStr_$c(1)_EpisodeNo
						Set LabInfoStr=LabInfoStr_$c(1)_SpecDesc
						Set LabInfoStr=LabInfoStr_$c(1)_AppLoc
						
						Set LabInfoStr=LabInfoStr_$c(1)_CollDate
						Set LabInfoStr=LabInfoStr_$c(1)_CollTime
						Set LabInfoStr=LabInfoStr_$c(1)_CollUser
						Set LabInfoStr=LabInfoStr_$c(1)_RecDate
						Set LabInfoStr=LabInfoStr_$c(1)_RecTime
						Set LabInfoStr=LabInfoStr_$c(1)_RecUser
						Set LabInfoStr=LabInfoStr_$c(1)_AuthDate 	// 检验报告日期
						Set LabInfoStr=LabInfoStr_$c(1)_AuthTime 	// 检验报告时间
						Set LabInfoStr=LabInfoStr_$c(1)_RepStatus
						Set Repret=##class(DHCMA.CPW.SD.Data.LisInfo).Update(LabInfoStr,$c(1))
						Continue:Repret<0
						//检验项目结果
						Set ResultLb=..GetRepResult(xReportDr)
						Set xTCID=""
						For xLInd=1:1:$ll(ResultLb){
							Set LabResult=$lg(ResultLb,xLInd)
							Continue:LabResult=""
							Set ItemCode=$p(LabResult,"^",2)    //检验项目代码
							Set ItemDesc=$p(LabResult,"^",3)    //检验项目描述
							Set ItemResult=$p(LabResult,"^",5)  //结果
							Set ItemUnit=$p(LabResult,"^",9)    //检验项目的单位
							Set AbnorFlag=$p(LabResult,"^",8)   //异常标记
							Set ItemRangs=$p(LabResult,"^",10)   //参考范围
							Set Comments=$p(LabResult,"^",7)   	 //项目备注
							Set ResultStr=Repret
							Set ResultStr=ResultStr_$c(1)_ItemCode
							Set ResultStr=ResultStr_$c(1)_ItemResult
							Set ResultStr=ResultStr_$c(1)_Comments
							Set ResultStr=ResultStr_$c(1)_AbnorFlag
							Set ResultStr=ResultStr_$c(1)_ItemDesc
							Set ResultRet=##class(DHCMA.CPW.SD.Data.LisItemInfo).Update(ResultStr,$c(1))
						}
					}
				}
			}
		}
	}
	Quit VisitCount
}

/// Creator：     zhufei
/// CreatDate：   2017-08-21
/// Description:  组织Query输出检验报告
/// Input：       aReportID:检验报告ID
/// Return：      返回List
/// w ##Class(DHCHAI.DI.DIO.FromLisSrv).BuildVisitReport(20)
ClassMethod BuildVisitReport(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	New (aReportID,errMsg)
	Set return=""
	Quit:(aReportID="") return
	
	Set $ZT="BuildVisitReportErr"
	
	Set ReportData=$g(^dbo.RPVisitNumberReportD(aReportID))
	Quit:ReportData="" return
	Set VisitNumberDr=$lg(ReportData,2)			//标本ID
	Quit:VisitNumberDr="" return
	
	Set WorkGrpMachDr   = $lg(ReportData,4)			//WorkGroupMachineDR
	Set Order			= $lg(ReportData,5)			//报告序号
	Set TestSetRow		= ""						//医嘱表OEORI_LabTestSetRow字段
	Set RepStatus  		= $lg(ReportData,22)		//状态
	Set RegDate 		= $lg(ReportData,16)		//录入日期
	Set:RegDate'="" RegDate=$zdh(RegDate,8)
	Set RegTime 		= $lg(ReportData,17)		//录入时间
	Set RegUserDr		= $lg(ReportData,18)		//录入人
	Set (RegUserCode,RegUserName)=""
	Set:RegUserDr'="" RegUserName=$listget($g(^dbo.SYSUserD(RegUserDr)),3)
	Set:RegUserDr'="" RegUserCode=$listget($g(^dbo.SYSUserD(RegUserDr)),2)
	Set AuthDate 		= $lg(ReportData,19)		//审核日期
	Set:AuthDate'="" AuthDate=$zdh(AuthDate,8)
	Set AuthTime 		= $lg(ReportData,20)		//审核时间
	Set AuthUserDr	 	= $lg(ReportData,21)		//审核人
	Set (AuthUserCode,AuthUserName)=""
	Set:AuthUserDr'="" AuthUserName=$listget($g(^dbo.SYSUserD(AuthUserDr)),3)
	Set:AuthUserDr'="" AuthUserCode=$listget($g(^dbo.SYSUserD(AuthUserDr)),2)
	
	Set VisitNumberData=..GetVisitNumber(VisitNumberDr)
	Quit:VisitNumberData="" return
	Quit:$listlength(VisitNumberData)<17 return
	
	//取检验医嘱与HIS医嘱
	Set TestSetStr="",TestSetRow=""
	Set TestSetInfo=..GetVisitTestSet(VisitNumberDr,WorkGrpMachDr)
	Set:TestSetInfo="" TestSetInfo=..GetVisitTestSet(VisitNumberDr)  //如果为空，取全部检验医嘱
	For indTS=1:1:$ll(TestSetInfo) {
		Set tData=$listget(TestSetInfo,indTS)
		Continue:tData=""
		Set TSCode=$listget(tData,2)
		Set TSDesc=$listget(tData,3)
		Continue:TSDesc=""
		Set ArcimCode=$listget(tData,4)
		Set ArcimDesc=$listget(tData,5)
		Set HISOrderID=$listget(tData,7)
		
		If TestSetStr'="" {
			Set TestSetStr=TestSetStr_"!!"_TSCode_"^"_TSDesc_"^"_ArcimCode_"^"_ArcimDesc
		} Else {
			Set TestSetStr=TSCode_"^"_TSDesc_"^"_ArcimCode_"^"_ArcimDesc
		}
		Set:TestSetRow="" TestSetRow=$listget(tData,8)
	}
	Quit:TestSetStr="" return
	
	Set return=$lb(aReportID)
	Set return=return_$list(VisitNumberData,1,17)
	Set return=return_$lb(TestSetStr)
	Set return=return_$lb(TestSetRow)
	Set return=return_$lb(Order)
	Set return=return_$lb(RepStatus)
	Set return=return_$lb(RegDate)
	Set return=return_$lb(RegTime)
	Set return=return_$lb(RegUserCode)
	Set return=return_$lb(RegUserName)
	Set return=return_$lb(AuthDate)
	Set return=return_$lb(AuthTime)
	Set return=return_$lb(AuthUserCode)
	Set return=return_$lb(AuthUserName)
	Quit return
	
BuildVisitReportErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-08-18
/// Description:  通过标本ID取标本信息
/// Input：       aVisitNumberID:标本ID
/// Return：      标本信息
/// w ##Class(DHCHAI.DI.DIO.FromLisSrv).GetVisitNumber(2)
ClassMethod GetVisitNumber(aVisitNumberID As %String) As %List
{
	New (aVisitNumberID)
	Set return=""
	Quit:(aVisitNumberID="") return
	
	Set VisitNumberData=$g(^dbo.RPVisitNumberD(aVisitNumberID))
	Quit:VisitNumberData="" return
	Set EpisodeID=$listget(VisitNumberData,5)		// 就诊号
	Quit:EpisodeID="" return
	
	Set EpisodeNo=$listget(VisitNumberData,2)		// 检验号/标本号
	Set (SpecimenCode,SpecimenDesc)=""
	Set SpecimenDr=$listget(VisitNumberData,56)		// 标本
	Set HospitalDr=$listget(VisitNumberData,21)		// HospitalDr
	Set:SpecimenDr'="" SpecimenCode=$listget($g(^dbo.BTSpecimenD(SpecimenDr)),2)
	Set:SpecimenDr'="" SpecimenDesc=$listget($g(^dbo.BTSpecimenD(SpecimenDr)),3) //修改新版检验同步不到标本等问题
	//检验系统未存标本信息，从医嘱系统取
	If SpecimenDesc="" {
		Set OrdID=+$o(^OEORD(0,"EpisNo",EpisodeNo,""))
		Set SubID=+$o(^OEORD(0,"EpisNo",EpisodeNo,OrdID,""))
		Set tSpecDr=$o(^OEORD(OrdID,"I",SubID,"SPEC",""),-1)
		Set:tSpecDr'="" SpecimenCode=$p(^OEORD(OrdID,"I",SubID,"SPEC",tSpecDr),"^",1)
		If SpecimenCode'="" {
			Set SpecimenDr=$o(^dbo.BTSpecimenI("IndexCode",HospitalDr,##Class(LIS.Util.Common).IndexData(SpecimenCode),""))
			Set:SpecimenDr'="" SpecimenDesc=$listget($g(^dbo.BTSpecimenD(SpecimenDr)),3) //修改新版检验同步不到标本等问题
		}
		If SpecimenDesc="" {
			Set SpecimenCode=$p($g(^OEORD(OrdID,"I",SubID,8)),"^",16)  //标本 OEORI_Lab1
			Set:SpecimenCode'="" SpecimenDesc=$p($g(^DHCSpS("SPS",SpecimenCode)),"^",2)
		}
	}
	Quit:SpecimenDesc="" return
	
	Set (LocationCode,LocationDesc)=""
	Set LocationDr=$listget(VisitNumberData,22)		// 科室
	Set:LocationDr'="" LocationCode=$listget($g(^dbo.BTLocationD(LocationDr)),5)
	Set:LocationDr'="" LocationDesc=$listget($g(^dbo.BTLocationD(LocationDr)),3)
	Set CollDate=$listget(VisitNumberData,51)		// 采集日期
	Set:CollDate'="" CollDate=$zdh(CollDate,8)
	Set CollTime=$listget(VisitNumberData,52)		// 采集时间
	Set CollUserDr=$listget(VisitNumberData,53)		// 采集人
	Set (CollUserCode,CollUserName)=""
	Set:CollUserDr'="" CollUserName=$listget($g(^dbo.SYSUserD(CollUserDr)),3)
	Set:CollUserDr'="" CollUserCode=$listget($g(^dbo.SYSUserD(CollUserDr)),2)
	Set RecDate=$listget(VisitNumberData,66)		// 接受日期
	Set:RecDate'="" RecDate=$zdh(RecDate,8)
	Set RecTime=$listget(VisitNumberData,67)		// 接受时间
	Set RecUserDr=$listget(VisitNumberData,68)		// 接受人
	Set (RecUserCode,RecUserName)=""
	Set:RecUserDr'="" RecUserName=$listget($g(^dbo.SYSUserD(RecUserDr)),3)
	Set:RecUserDr'="" RecUserCode=$listget($g(^dbo.SYSUserD(RecUserDr)),2)
	
	Set (WardCode,WardDesc)=""
	Set WardDr=$listget(VisitNumberData,26)		   // 病区
	Set:WardDr'="" WardCode=$listget($g(^dbo.BTWardD(WardDr)),4)  //病区HISCode
	Set:WardDr'="" WardDesc=$listget($g(^dbo.BTWardD(WardDr)),3)
	Set return=$lb(aVisitNumberID)
	Set return=return_$lb(EpisodeID)       //就诊号
	Set return=return_$lb(EpisodeNo)       //检验号 对应医嘱表OEORI_LabEpisodeNo
	Set return=return_$lb(SpecimenCode)    //标本
	Set return=return_$lb(SpecimenDesc)
	Set return=return_$lb(LocationCode)    //申请科室
	Set return=return_$lb(LocationDesc)
	Set return=return_$lb(CollDate)        //采集日期
	Set return=return_$lb(CollTime)
	Set return=return_$lb(CollUserCode)    //采集用户
	Set return=return_$lb(CollUserName)
	Set return=return_$lb(RecDate)         //接收日期
	Set return=return_$lb(RecTime)
	Set return=return_$lb(RecUserCode)     //接收用户
	Set return=return_$lb(RecUserName)
	Set return=return_$lb(WardCode)        //申请病区
	Set return=return_$lb(WardDesc)
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-08-10
/// Description:  通过标本ID取检验医嘱信息
/// Input：       aVisitNumberID:标本ID
/// Return：      标本信息
/// w ##Class(DHCHAI.DI.DIO.FromLisSrv).GetVisitTestSet(212)
ClassMethod GetVisitTestSet(aVisitNumberID As %String, aWorkGrpMachDr As %String = "") As %List
{
	New (aVisitNumberID,aWorkGrpMachDr)
	Set return=""
	Quit:aVisitNumberID="" return
	
	Set xTestSetID=0
	For {
		Set xTestSetID=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",aVisitNumberID,xTestSetID))
		Quit:xTestSetID=""
		
		Set xID=0
		For {
			Set xID=$o(^dbo.RPVisitNumberTestSetI("IndexMaster",aVisitNumberID,xTestSetID,xID))
			Quit:xID=""
			
			Set tTSInfo=$g(^dbo.RPVisitNumberTestSetD(xID))
			Continue:tTSInfo=""
			Set TestSetDr=$listget(tTSInfo,3)
			Continue:TestSetDr=""
			Set WorkGroupMachineDr=$listget(tTSInfo,5)
			Continue:(aWorkGrpMachDr'="")&(aWorkGrpMachDr'=WorkGroupMachineDr)
			Set HISOrdItemDr=$listget(tTSInfo,10)
			
			//检验医嘱
			Set TSData=$g(^dbo.BTTestSetD(TestSetDr))
			Continue:TSData=""
			Set TSCode=$listget(TSData,2)
			Set TSDesc=$listget(TSData,3)
			Continue:TSDesc=""
			
			//HIS医嘱
			If HISOrdItemDr'="" {
				Set ArcimCode="",ArcimDesc=""
				Set ArcimID=$p($g(^OEORD(+HISOrdItemDr,"I",+$p(HISOrdItemDr,"||",2),1)),"^",2)
				If ArcimID'="" {
					Set ArcimCode=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",1)		//医嘱项代码
					Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)		//医嘱项名称
				}
				Set TestSetRow=$p($g(^OEORD(+HISOrdItemDr,"I",+$p(HISOrdItemDr,"||",2),3)),"^",35)
				Set Data=$lb(xID,TSCode,TSDesc,ArcimCode,ArcimDesc,WorkGroupMachineDr,HISOrdItemDr,TestSetRow)
				Set return=return_$lb(Data)
			} Else {
				Set VisitNumberData=$g(^dbo.RPVisitNumberD(aVisitNumberID))
				If VisitNumberData'="" {
					Set EpisodeNo=$listget(VisitNumberData,2)		// 检验号/标本号
					Set OrdID=+$o(^OEORD(0,"EpisNo",EpisodeNo,""))
					Set SubID=""
					For {
						Set SubID=$o(^OEORD(0,"EpisNo",EpisodeNo,OrdID,SubID))
						Quit:SubID=""
						
						Set HISOrdItemDr=OrdID_"||"_SubID
						Set ArcimCode="",ArcimDesc=""
						Set ArcimID=$p($g(^OEORD(+HISOrdItemDr,"I",+$p(HISOrdItemDr,"||",2),1)),"^",2)
						If ArcimID'="" {
							Set ArcimCode=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",1)		//医嘱项代码
							Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)		//医嘱项名称
						}
						
						Set TestSetRow=""
						Set SubID2=""
						For {
							Set SubID2=$o(^OEORD(0,"EpisNo",EpisodeNo,OrdID,SubID2))
							Quit:SubID2=""
							Set TestSetRow=$p($g(^OEORD(OrdID,"I",SubID2,3)),"^",35)
							Quit:TestSetRow'=""
						}
						
						Set Data=$lb(xID,TSCode,TSDesc,ArcimCode,ArcimDesc,WorkGroupMachineDr,HISOrdItemDr,TestSetRow)
						Set return=return_$lb(Data)
					}
				}
			}
		}
	}
	
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-07-24
/// Description:  通过检验报告ID取检验结果接口
/// Input：       aReportID:检验报告ID
/// Return：      检验结果信息
/// w ##Class(DHCHAI.DI.DIO.FromLisSrv).GetRepResult(22870)
ClassMethod GetRepResult(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	New (aReportID,errMsg)
	Set return=""
	Quit:(aReportID="") return
	
	Set $ZT="GetRepResultErr"
	//调用检验组提供的接口
	/*
	Set ds = ##class(%Library.ResultSet).%New("LISService.Business.ReportResult:QryTestSetResult")
	Do ds.Execute(aReportID)
	while(ds.Next())
	{
		Set TestCode 	= ds.Data("TestCode")		//检验项目名称
		Set TCCode	 	= ds.Data("TCCode")			//检验项目代码
		Continue:(TestCode="")||(TCCode="")
		Set RstFormat 	= ds.Data("RstFormat")		//结果类型
		Set Result 		= ds.Data("Result")			//检测结果
		Set TextRes 	= ds.Data("TextRes")		//定性结果
		Set ResNoes 	= ds.Data("ResNoes")		//结果说明(备注)
		Set AbFlag 		= ds.Data("AbFlag")			//异常提示
		Set Unit 		= ds.Data("Unit")			//单位
		Set RefRanges 	= ds.Data("RefRanges")		//参考范围
		Set MDRResult 	= ds.Data("MDRResult")		//多耐结果
		Set IsActive 	= ds.Data("IsActive")		//有效标志
		Set ResultSenID = ds.Data("ResultSenID")	//药敏结果ID
		Set ResultData = ResultSenID_"^"_TestCode_"^"_TCCode_"^"_RstFormat_"^"_Result_"^"_TextRes
		_"^"_ResNoes_"^"_AbFlag_"^"_Unit_"^"_RefRanges_"^"_MDRResult
		Set return = return_$lb(ResultData)
	}
	Set ResultData ="检验项目名称^检验项目代码D^M^检测结果^定性结果^结果说明(备注)^异常提示^单位^参考范围^多耐结果^1^1"
	Set return = return_$lb(ResultData)
	*/
	
	Set xTestCodeID = ""
 	For {
		Set xTestCodeID = $o(^dbo.RPVisitNumberReportResultI("IndexReportItem",aReportID,xTestCodeID))
		Quit:xTestCodeID=""
		
		Set xResultID = ""
		For {
			Set xResultID = $o(^dbo.RPVisitNumberReportResultI("IndexReportItem",aReportID,xTestCodeID,xResultID))
			Quit:xResultID=""
			
			Set ResultData=$g(^dbo.RPVisitNumberReportResultD(xResultID))
			Continue:ResultData=""
			
			Set TestCodeData    = $g(^dbo.BTTestCodeD(xTestCodeID))
			Set TestCodeCode	= $lg(TestCodeData,2) //检验项目代码
			Set TestCodeDesc	= $lg(TestCodeData,3) //检验项目名称
			Set RstFormat       = $lg(TestCodeData,9) //结果类型
			Set:RstFormat="X" RstFormat = "T" 	//文本格式
			Set Result			= $lg(ResultData,5)	  //检测结果
			Set TextRes			= $lg(ResultData,6)	  //定性结果
			Set ResNoes			= $lg(ResultData,8)	  //结果说明(备注)
			Set AbFlag			= $lg(ResultData,9)	  //异常提示
			Set Unit			= $lg(ResultData,11)  //单位
			Set RefRanges  	 	= $lg(ResultData,12)  //参考范围
			Set MDRResult   	= $lg(ResultData,27)  //多耐结果
			
			Set ResultData = xResultID_"^"_TestCodeCode_"^"_TestCodeDesc_"^"_RstFormat_"^"_Result_"^"_TextRes
			_"^"_ResNoes_"^"_AbFlag_"^"_Unit_"^"_RefRanges_"^"_MDRResult
			
			Set return = return_$lb(ResultData)
		}
 	}
	Quit return
	
GetRepResultErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

ClassMethod GetV1LisInfo(aEpisodeID) As %String
{
	New (aEpisodeID)
	Set return=""
	Set OrdID=$o(^OEORD(0,"Adm",aEpisodeID,0))
	Quit:OrdID="" return
	Set (RepCnt,ResultCnt)=0
	Set xArcimID=""
	For {
		Set xArcimID=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID))
		Quit:xArcimID=""
		
		Set ArcimCatDr=$p($g(^ARCIM(+xArcimID,1,1)),"^",10)
		Set ArcimType=$p($g(^ARC("IC",+ArcimCatDr)),"^",7)
	 	Continue:ArcimType'="L"
	 	
		Set xSttDate=0
		For {
			Set xSttDate=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID,xSttDate))
			Quit:xSttDate=""
			
			Set xSub=0
			For {
				Set xSub=$o(^OEORDi(0,"ARCIM",OrdID,xArcimID,xSttDate,xSub))
				Quit:xSub=""
				
				Set xEpis=$p($g(^OEORD(OrdID,"I",xSub,3)),"^",20)
				Continue:xEpis=""
				Set OEItemID=OrdID_"||"_xSub
				Set xTS=""
				For {
					Set xTS=$o(^TEPI(xEpis,1,xTS))
					Quit:xTS=""
					Set xCnt=0
					For {
						Set xCnt=$o(^TEPI(xEpis,1,xTS,xCnt))
						Quit:xCnt=""
						Set ReportData=$g(^TEPI(xEpis,1,xTS,xCnt))
						Continue:ReportData=""
						Set AuthDate=$p(ReportData,"\",4)
						Continue:AuthDate=""
						
						Set ReportID=xEpis_"||"_xTS
						Set VisitNumberDr=xEpis
						Set Order=xCnt
						
						Set RepStatus       = $p(ReportData,"\",31)
						Continue:RepStatus'="A" //报告未审核
						Set RegDate         = $p(ReportData,"\",1)
						Set RegTime         = $p(ReportData,"\",2)
						Set:$l(RegTime) RegTime=RegTime*60
						Set RegUserCode     = $p(ReportData,"\",3)
						Set RegUserDesc     = ""
						If RegUserCode'="" {
							Set RegUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(RegUserCode,"U"),0))
							Set:RegUserDr'="" RegUserDesc=$p($g(^SSU("SSUSR",RegUserDr)),"^",2)
						}
						Set AuthDate        = $p(ReportData,"\",4)
						Set AuthTime        = $p(ReportData,"\",5)
						Set:$l(AuthTime) AuthTime=AuthTime*60
						Set AuthUserCode    = $p(ReportData,"\",6)
						Set AuthUserDesc    = ""
						If AuthUserCode'="" {
							Set AuthUserDr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(AuthUserCode,"U"),0))
							Set:AuthUserDr'="" AuthUserDesc=$p($g(^SSU("SSUSR",AuthUserDr)),"^",2)
						}
						//取检验医嘱与HIS医嘱
						Set TestSetStr="",ArcimCode="",ArcimDesc=""
						Set TestSetRow=ReportID
						Set TSCode=xTS
						Set TSDesc=$p($g(^TTAB("TS",TSCode)),"\",1)
						//保存检验信息
						Set LabInfoStr=aEpisodeID
						Set LabInfoStr=LabInfoStr_$c(1)_ReportID
						Set LabInfoStr=LabInfoStr_$c(1)_OEItemID
						Set LabInfoStr=LabInfoStr_$c(1)_TSDesc
						Set LabInfoStr=LabInfoStr_$c(1)_TSCode
						Set LabInfoStr=LabInfoStr_$c(1)_xEpis
						Set SpecInfo=..GetSpecInfo(OEItemID)
						Set SpecDesc=$lg(SpecInfo,2)	//标本
						Set LabInfoStr=LabInfoStr_$c(1)_SpecDesc
						Set AppLoc=$lg(SpecInfo,3)	// 申请科室|送检科室
						Set LabInfoStr=LabInfoStr_$c(1)_AppLoc
						Set CollDate=$lg(SpecInfo,5)	// 采集日期
						Set LabInfoStr=LabInfoStr_$c(1)_CollDate
						Set CollTime=$lg(SpecInfo,6)	// 采集时间
						Set LabInfoStr=LabInfoStr_$c(1)_CollTime
						Set CollUser=$lg(SpecInfo,7)	// 采集者
						Set LabInfoStr=LabInfoStr_$c(1)_CollUser
						Set RecDate=$lg(SpecInfo,9)	// 接收日期
						Set LabInfoStr=LabInfoStr_$c(1)_RecDate
						Set RecTime=$lg(SpecInfo,10)	// 接收时间
						Set LabInfoStr=LabInfoStr_$c(1)_RecTime
						Set RecUser=$lg(SpecInfo,11)	// 接收者
						Set LabInfoStr=LabInfoStr_$c(1)_RecUser
						Set LabInfoStr=LabInfoStr_$c(1)_AuthDate 	// 检验报告日期
						Set LabInfoStr=LabInfoStr_$c(1)_AuthTime 	// 检验报告时间
						Set Repret=##class(DHCMA.CPW.SD.Data.LisInfo).Update(LabInfoStr,$c(1))
						Continue:Repret<0
						//检验项目结果
						Set xTCID=""
						For {
							Set xTCID=$o(^TEPI(xEpis,1,xTS,xCnt,"DATA",xTCID))
							Quit:xTCID=""
							
							Set xResultID=xEpis_"||"_xTS_"||"_xCnt_"||"_xTCID
							Set ResultData=$g(^TEPI(xEpis,1,xTS,xCnt,"DATA",xTCID))
							Continue:ResultData=""
							Set LabResult=..GetTestCodeResult(xEpis_"||"_xTS_"||"_xCnt,xTCID)
							Continue:LabResult=""
							Set ItemCode=$p(LabResult,$c(2),1)    //检验项目代码
							Set ItemDesc=$p(LabResult,$c(2),2)    //检验项目描述
							Set ItemResult=$p(LabResult,$c(2),3)  //结果
							Set ItemUnit=$p(LabResult,$c(2),4)    //检验项目的单位
							Set AbnorFlag=$p(LabResult,$c(2),5)   //异常标记
							Set ItemRangs=$p(LabResult,$c(2),6)   //参考范围
							Set Synonym=$p(LabResult,$c(2),7)     //英文缩写
							Set RstFormat=$p(LabResult,$c(2),8)   //输出数据类型
							Set Comments=$g(^TEPI(xEpis,1,xTS,xCnt,"DATA",xTCID,"REM",1))
							Set Comments1=$g(^TEPI(xEpis,1,xTS,xCnt,"DATA",xTCID,"REM",0))  //增加备注取的位置
							Set:Comments1'="" Comments=Comments_Comments1
							Set Comments=$tr(Comments,"^","")
							Set ResultStr=Repret
							Set ResultStr=ResultStr_$c(1)_ItemCode
							Set ResultStr=ResultStr_$c(1)_ItemResult
							Set ResultStr=ResultStr_$c(1)_Comments
							Set ResultStr=ResultStr_$c(1)_AbnorFlag
							Set ResultRet=##class(DHCMA.CPW.SD.Data.LisItemInfo).Update(ResultStr,$c(1))
							
						}
					}
				}
			}
		}
	}
	Quit "完成检验报告+检验结果同步！"
}

/// Description:  通过医嘱ID取标本信息
/// Input：       OEItemID：医嘱ID
/// Return：      标本信息
/// w ##Class(DHCMA.CPW.SD.DataSrv.LisInfoSrv).GetSpecInfo(40110)
ClassMethod GetSpecInfo(OEItemID As %String) As %List
{
	New (OEItemID)
	Set return=""
	Quit:(OEItemID="") return
		
	Set OrdID=$p(OEItemID,"||",1)
	Set SubID=$p(OEItemID,"||",2)
	Quit:(OrdID="")||(SubID="") return
	
	//标本
	Set SpecDr=$o(^OEORD(OrdID,"I",SubID,"SPEC",""),-1)
	Set:SpecDr'="" SpecCode=$p(^OEORD(OrdID,"I",SubID,"SPEC",SpecDr),"^",1)
	Set:SpecCode'="" SpecDesc=$p(^TTAB("SPEC",SpecCode),"\",1)
	If SpecDesc="" {
		Set SpecCode=$p($g(^OEORD(OrdID,"I",SubID,8)),"^",16)  //标本 OEORI_Lab1
		Set:SpecCode'="" SpecDesc=$p($g(^DHCSpS("SPS",SpecCode)),"^",2)
	}
	
	//采集日期时间
	Set CollDateTime=..GetCollDateTime(OEItemID)
	Set CollDate=$p(CollDateTime,"^",1)
	Set CollTime=$p(CollDateTime,"^",2)
	Set CollUser=$p(CollDateTime,"^",3)
	If CollDate="" {
		Set OrdExecId=$o(^DHCOrdExec(0,"DHCOEORI",OEItemID,""),-1)
		If $l(OrdExecId){
			Set CollDate=$p($g(^DHCOrdExec(OrdExecId)),"^",13)
			Set CollTime=$p($g(^DHCOrdExec(OrdExecId)),"^",14)
		}
	}
	
	//接收日期时间
	Set RecDateTime=..GetRecDateTime(OEItemID)
	Set RecDate=$p(RecDateTime,"^",1)
	Set RecTime=$p(RecDateTime,"^",2)
	Set RecUser=$p(RecDateTime,"^",3)
	If RecDate="" {
		Set LabTestSetRow=$p($g(^OEORD(OrdID,"I",SubID,3)),"^",35)
		If (LabTestSetRow'="")&&((+LabTestSetRow)>0) {
			Set LabNo=+LabTestSetRow
			Set TS=$p(LabTestSetRow,"||",2)		//updae by liuyh 2018-03-20 bug修复
			Set TSCnt=+$p(LabTestSetRow,"||",3)
			Set RecDate=$p($g(^TEPI(LabNo,1,TS,TSCnt)),"\",21)
			If $l(RecDate) Set RecDate=RecDate
			Set RecTime=$p($g(^TEPI(LabNo,1,TS,TSCnt)),"\",22)
			If $l(RecTime) Set RecTime=RecTime*60
		}
	}
	
	//申请科室
	Set LocDr=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",3)
	Set:LocDr'="" LocCode=$p($g(^CTLOC(LocDr)),"^",1)
	Set:LocDr'="" LocDesc=$p($g(^CTLOC(LocDr)),"^",2)
	
	//开医嘱时病人所在病区
	Set WardDr=$p($g(^OEORD(OrdID,"I",SubID,9)),"^",2)
	Set:WardDr'="" WardCode=$p($g(^CTLOC(WardDr)),"^",1)
	Set:WardDr'="" WardDesc=$p($g(^CTLOC(WardDr)),"^",2)

	Set CollUserCode=$p(CollUser,"|",2)
	Set CollUserName=$p(CollUser,"|",3)
	Set RecUserCode=$p(RecUser,"|",2)
	Set RecUserName=$p(RecUser,"|",3)
	

	Set return=return_$lb(SpecCode)        //标本
	Set return=return_$lb(SpecDesc)
	Set return=return_$lb(LocDr)         //申请科室
	Set return=return_$lb(LocDesc)
	Set return=return_$lb(CollDate)        //采集日期
	Set return=return_$lb(CollTime)
	Set return=return_$lb(CollUserCode)    //采集用户
	Set return=return_$lb(CollUserName)
	Set return=return_$lb(RecDate)         //接收日期
	Set return=return_$lb(RecTime)
	Set return=return_$lb(RecUserCode)     //接收用户
	Set return=return_$lb(RecUserName)
	Set return=return_$lb(WardDr)        //申请病区
	Set return=return_$lb(WardDesc)

	Quit return
}

/// 取标本采集日期时间
/// OEItemID为医嘱ID
ClassMethod GetCollDateTime(aOEItemID As %String) As %String
{
	New (aOEItemID)
	Set return=""
	Quit:aOEItemID="" return
	
	Set OrdID=$p(aOEItemID,"||",1)
	Set SubID=$p(aOEItemID,"||",2)
	Quit:(OrdID="")||(SubID="") return
	
    Set OrdXSub=$o(^OEORD(OrdID,"I",SubID,"X",0))
    Quit:OrdXSub="" return
    Set OEItemXID=OrdID_"||"_SubID_"||"_OrdXSub
    Set OrdExecID=$o(^DHCOrdExec(0,"OEOREDR",OrdID_"||"_SubID_"||"_OrdXSub,""))
    Quit:OrdExecID="" return
	
	Set (CollUserCode,CollUserDesc)=""
	Set CollUserID=$p(^DHCOrdExec(OrdExecID),"^",12)
	If CollUserID'="" {
		Set CollUserCode=$p($g(^SSU("SSUSR",CollUserID)),"^",1)
		Set CollUserDesc=$p($g(^SSU("SSUSR",CollUserID)),"^",2)
	}
	Set CollDate=$p(^DHCOrdExec(OrdExecID),"^",13)
	Set CollTime=$p(^DHCOrdExec(OrdExecID),"^",14)
	Quit:CollDate="" return
	
	Set return=CollDate_"^"_CollTime_"^"_CollUserID_"|"_CollUserCode_"|"_CollUserDesc
    Quit return
}

/// 取标本接受日期时间
/// OEItemID为医嘱ID，Flag标本状态（R）
ClassMethod GetRecDateTime(aOEItemID As %String, aFlag As %String = "R") As %String
{
	New (aOEItemID, aFlag)
	Set return=""
	Quit:(aOEItemID="")||(aFlag="") return
	
	Set OrdID=$p(aOEItemID,"||",1)
	Set SubID=$p(aOEItemID,"||",2)
	Quit:(OrdID="")||(SubID="") return
	
	Set RESSTID=$o(^OEC("RESST",0,"Code",aFlag,""))
	
	Set (RecDate,RecTime,RecUserID,RecUserCode,RecUserDesc)=""
	Set xRES=""
	For {
		Set xRES=$O(^OEORD(OrdID,"I",SubID,"RES",xRES))
		Quit:xRES=""
		Set Values=$p($g(^OEORD(OrdID,"I",SubID,"RES",xRES)),"^",2)
		If RESSTID=Values {
			Set RecDate=$p($g(^OEORD(OrdID,"I",SubID,"RES",xRES)),"^",4)
			Set RecTime=$p($g(^OEORD(OrdID,"I",SubID,"RES",xRES)),"^",5)
			Set RecUserID=$p($g(^OEORD(OrdID,"I",SubID,"RES",xRES)),"^",3)
			If RecUserID'="" {
				Set RecUserCode=$p($g(^SSU("SSUSR",RecUserID)),"^",1)
				Set RecUserDesc=$p($g(^SSU("SSUSR",RecUserID)),"^",2)
			}
		}
	}
	Quit:RecDate="" return
	
	Set return=RecDate_"^"_RecTime_"^"_RecUserID_"|"_RecUserCode_"|"_RecUserDesc
	Quit return
}

/// 获取检验项目的描述，结果，单位，异常值，参考范围信息，英文缩写
/// [Previously private]
ClassMethod GetTestCodeResult(aReportID As %String, aTC As %String) As %String
{
	
	New (aReportID,aTC)
	Set return=""
	Quit:(aReportID="")||(aTC="") return
	
	Set Epis=$p(aReportID,"||",1)
	Set TS=$p(aReportID,"||",2)
	Set Cnt=$p(aReportID,"||",3)
	Set:Cnt="" Cnt=$o(^TEPI(Epis,1,TS,""),-1)
	Quit:(Epis="")||(TS="") return
	Quit:'$d(^TTAB("TC",aTC)) return
	
	Set ResultID=Epis_"||"_TS_"||"_Cnt_"||"_aTC
	Set ReportData=$g(^TEPI(Epis,1,TS,Cnt,"DATA",aTC))
	Quit:ReportData="" return
	Set tResult=$p(ReportData,"\",1)

	Set ItemName=$p(^TTAB("TC",aTC),"\",1)        //项目名称
	Set ItemDate=$p(^TEPI(Epis),"\",10)
	Set Synonym=$p(^TTAB("TC",aTC),"\",12)        //英文缩写
	Set ItemUnits=..GetTCUnitByDate(aTC,ItemDate) //项目单位
	Set ItemType=$p(^TTAB("TC",aTC),"\",3)        //输出数据类型
	Set ItemResult=tResult
	If ItemType="V" {         //微生物 Micro Pathogen||V
		If ItemResult'="" {
			set xItemResult=ItemResult
			set xItemResult=$ZCVT($g(xItemResult),"U")
			set xItemResult=$tr(xItemResult," ","")
			Set:$d(^TTAB("BUG",xItemResult)) ItemResult=$p($g(^TTAB("BUG",xItemResult)),"\",1)
		}
	}
	If ItemType["N" {         //??
		Set Decimal=$e(ItemType,2)
		Set:Decimal="" Decimal="0"
		Set ItemResult=$$CheckResDecimal(ItemResult,Decimal)
	}
	If ItemType["S" {         //Standard Comment标准意见
		If ItemResult'="" {
			Set:$d(^TTAB("TC",aTC,2,ItemResult,1)) ItemResult=$p($g(^TTAB("TC",aTC,2,ItemResult,1)),"\",1)
		}
	}
	If ItemType="B2" {        //血型结果
		If ItemResult'="" {
			Set:$d(^TTAB("BB-BG",ItemResult)) ItemResult=$p($g(^TTAB("BB-BG",ItemResult)),"\",1)
		}
	}
	
	Set ResFlag=..GetAbnorFlag(aTC ,ItemResult)  //异常标志
	Set RefRanges=..GetTCRanges(aTC)             //参考范围
	Set RefRanges=$tr(RefRanges,$C(1),"~")      //参考范围高低值之间用“~”分隔
	Set:'$l(RefRanges) RefRanges=..GetMultiScope(aTC)
	
	//异常标志特殊字符处理
	Set ResFlag=$tr(ResFlag,$c(28),"")
	
	Set Comments=$g(^TEPI(Epis,1,TS,Cnt,"DATA",aTC,"REM",1))
	Set Comments1=$g(^TEPI(Epis,1,TS,Cnt,"DATA",aTC,"REM",0))  //增加备注取的位置
	Set:Comments1'="" Comments=Comments_Comments1

	Set $p(return,$c(2),1)=aTC
	Set $p(return,$c(2),2)=ItemName
	Set $p(return,$c(2),3)=$tr(ItemResult,$c(13,10),"")
	Set $p(return,$c(2),4)=ItemUnits
	Set $p(return,$c(2),5)=ResFlag
	Set $p(return,$c(2),6)=RefRanges
	Set $p(return,$c(2),7)=Synonym
	Set $p(return,$c(2),8)=ItemType
	Set $p(return,$c(2),9)=Comments
	
	//特殊不可见字符处理
	Set return=$tr(return,$c(0),"")
	Set return=$tr(return,$c(1),"")
	Set return=$tr(return,$c(10),"")
	Set return=$tr(return,$c(13),"")
	Quit return
	
CheckResDecimal(res,dec)
	Set res=$Get(res),dec=+$Get(dec)
	Set ret=""
	If res="" Quit ret
	If dec="" Quit ret
	Set flag=""
	If ($Extract(res)="<")!($Extract(res)=">") s flag=$Extract(res),res=$TRanslate(res,"<>")
	Set res=+res
	Set ret=$fn(res,"",dec)
	Quit flag_ret
}

/// 获取检验项目的异常标记
/// TestCode:检验项代码，TCResult:检验结果，TCRanges：检验项范围值（默认为空）
/// [Previously private]
ClassMethod GetAbnorFlag(TestCode As %String, TCResult As %String, TCRanges As %String = "") As %String
{
	Set FormatFlag=""
	//Set currNS=$znspace
	Set:$Data(^TTAB("TC",TestCode))'=0 FormatFlag=$Piece(^TTAB("TC",TestCode),"\",3)
	Quit:FormatFlag=""!TCResult=""!TestCode="" ""
	Set:TCRanges="" PType="0",TCRanges=..GetTCRanges(TestCode, "","", "", PType, "", "", "", "1","")
	Set:'$l(TCRanges) TCRanges=..GetMultiScope(TestCode)
	Set AbnorFlag=$Select(FormatFlag["N":$$GetAbnorFlagByNum(TCResult,TCRanges),FormatFlag["S":$$GetAbnorFlagByStCommen(TestCode,TCResult),FormatFlag["X":$$GetAbnorFlagByFreeText(TestCode,TCResult),1:"")
	//Set $znspace=currNS
	Quit AbnorFlag
	
	 ;数据型
GetAbnorFlagByNum(TCResult,TCRanges)
	s TCResult=$g(TCResult),TCRanges=$g(TCRanges)
	s (retvalue,retranges,retcolor)=""
	s retflag="N",lowflag="L",highflag="H"
	s reslow=$p(TCRanges,$c(1),1),reshigh=$p(TCRanges,$c(1),2)
	;panic unaccept
	s resPaniclow=$p(TCRanges,$c(1),3),resPanichigh=$p(TCRanges,$c(1),4)
	s resUnAcceptlow=$p(TCRanges,$c(1),9),resUnAccepthigh=$p(TCRanges,$c(1),10)
	;i TCRanges="" q ""
	i $l(TCRanges,$c(10))>1 q retvalue_$c(28)_retflag
	Set TCResult=$tr(TCResult,"><")
	;
	/*
	Set $znspace="LABDATA"
	Set lowflag=$p(^CF("LAB",1),"^",18),highflag=$p(^CF("LAB",1),"^",19)
	s rangsta=$p(^CF("LAB",1),"^",16),rangend=$p(^CF("LAB",1),"^",17)
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    s iBelowBColor=$P(^CF("LAB",1,"COLOUR",12),"^",1)
    s iBelowFcolor=$P(^CF("LAB",1,"COLOUR",12),"^",2)
    ;
    s iUnAcceptBColor=$P(^CF("LAB",1,"COLOUR",2),"^",1)
    s iUnAcceptFColor=$P(^CF("LAB",1,"COLOUR",2),"^",2)
    s iPanicColor=$P($tr(^CF("LAB",1,"COLOUR",15),$c(13,10)),"^",11)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    i TCRanges="" q retvalue_$c(28)_retranges_$c(28)_retcolor_$c(28)_retflag
	 
	i TCRanges="" q retvalue_$c(28)_retflag
	
	;---------add 20070914  修改范围值的显示
	i reslow="",reshigh="" d 
	.s retranges="" 
	i "<>"[$e(reslow) d ;($e(reslow,1)="<")!($e(reslow,1)=">") d
	.s retranges=rangsta_reslow_rangend
	e  d
	.s retranges=rangsta_reslow_"-"_reshigh_rangend
	;-----------
	*/
	i TCRanges="" q retvalue_$c(28)_retflag
	i '$ISVALIDNUM(TCResult) q retvalue_$c(28)_retflag
	;UnAccept check
	s rang=resUnAcceptlow_resUnAccepthigh
	i $l(rang) d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<resUnAcceptlow s retvalue=lowflag,retflag="U" q
	..i TCResult>resUnAccepthigh s retvalue=highflag,retflag="U" q
	.i (rang["<") d
	..s lowvalue=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowvalue s retvalue=highflag,retflag="U" q
	.i (rang["<") d
	..s highvlaue=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highvlaue s retvalue=lowflag,retflag="U" q
	;Panic check
	s rang=resPaniclow_resPanichigh
	i $l(rang),retflag="N" d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<resPaniclow s retvalue=lowflag,retflag="M" q
	..i TCResult>resPanichigh s retvalue=highflag,retflag="M" q
	.i (rang["<") d
	..s lowvalue=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowvalue s retvalue=highflag,retflag="M" q
	.i (rang[">") d
	..s highvlaue=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highvlaue s retvalue=lowflag,retflag="M" q
	;normal check
	s rang=reslow_reshigh
	i $l(rang),retflag="N" d
	.i (rang'["<")&(rang'[">") d
	..i TCResult<reslow s retvalue=lowflag,retflag="L" q
	..i TCResult>reshigh s retvalue=highflag,retflag="H" q
	.i (rang["<") d
	..s lowflag=$$res(rang) ;$p(rang,"<",2) modify 20070914
	..i TCResult>lowflag s retvalue=highflag,retflag="H" 
	.i (rang[">") d
	..s highflag=$$res(rang) ;$p(rang,">",2) modify 20070914
	..i TCResult<highflag s retvalue=lowflag,retflag="L"	
	q retvalue_$c(28)_retflag
	//q retflag
	
	;标准备注型	
GetAbnorFlagByStCommen(TestCode,TCResult)
	Set TestCode=$g(TestCode),TCResult=$g(TCResult)
	i '$l(TCResult) q $c(28,28,28)
	;
	/*
	Set $znspace="LABDATA"
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    */
    s retflag="N",retvalue=""
    ;s retvalue=TCResult
    ;s ^aareflag=TestCode_":"_TCResult
    i $d(^TTAB("TC",TestCode,2,TCResult)) d
    .s retflag=$p(^TTAB("TC",TestCode,2,TCResult),"\",1)
    .i retflag="A" s retvalue="*"
    q retvalue_$c(28)_retflag
    //q retflag
    
	;文本类型
GetAbnorFlagByFreeText(TestCode,TCResult)
	Set TestCode=$g(TestCode),TCResult=$g(TCResult)
	;
	/*
	Set $znspace="LABDATA"
	s iNormalBColor=$P(^CF("LAB",1,"COLOUR",0),"^",1)
	s iNormalFColor=$P(^CF("LAB",1,"COLOUR",0),"^",2)
    s iAboveBColor=$P(^CF("LAB",1,"COLOUR",11),"^",1)
    s iAboveFColor=$P(^CF("LAB",1,"COLOUR",11),"^",2)
    Set $znspace=currNS
    ;
    s retcolor=iNormalBColor_$c(1)_iNormalFColor
    */
    s retflag="N",retvalue=""
    ;s retvalue=TCResult
    s temstr=""
    s std="" f  s std=$o(^TTAB("TC",TestCode,2,std)) q:std=""  d
    .i $p(^TTAB("TC",TestCode,2,std),"\",1)="A" d
    ..i $d(^TTAB("TC",TestCode,2,std,1)),TCResult[$g(^TTAB("TC",TestCode,2,std,1)) ,retvalue="*",retflag="A"
    q retvalue_$c(28)_retflag
    // q retflag
    
res(rang) ; check < >
 i rang[">" s rang=$tr(rang,">")+.00000001
 i rang["<" s rang=$tr(rang,"<")-.00000001
 q rang
}

/// 获取项目的范围值
/// TestCode:项目代码,Age:年龄,Species:性别,Pregn:怀孕(0),PatientType:病人类型(0\0-IN),Date:日期,Cond:临床条件(0),Loc:0,mi:1\2,Weeks:周(0)
/// [Previously private]
ClassMethod GetTCRanges(TestCode As %String, Age As %Integer = "", Species As %String = "", Pregn As %String = "", PatientType As %String = "0", Date As %String = "", Cond As %String = "", Loc As %String = "", mi As %String = "1", Weeks As %Integer = "") As %String
{
 Set (j,x,xf,age0,type,exist,result,format)=""
 Set result=""
 Set tc=$g(TestCode),age=$g(Age),spec=$g(Species),pregn=$g(Pregn),ptype=$g(PatientType),date=$g(Date),cond=$g(Cond),loc=$g(Loc),mi=$g(mi),weeks=$g(Weeks)
 ;
 If '$l(age) Set age=0
 If '$l(spec) Set spec="M"
 ;;
 Set format=$p($g(^TTAB("TC",tc)),"\",3)
 i '$l(date) s date=+$h
 i '$d(^TTAB("TC",tc,4,date)) s date=$o(^TTAB("TC",tc,4,date),-1)
 i $l(date) d
 .For type=ptype,$e(ptype) i $d(^TTAB("TC",tc,4,date,type)) d  q
 ..k xf s x="" f  s x=$o(^TTAB("TC",tc,4,date,type,x)) q:x=""  d
 ...i $l($p(^(x),"\",23)),'$l(age) q
 ...i $l($p(^(x),"\",23)),$l($p(^(x),"\",23),"-")'>1 Set $p(^(x),"\",23)="0-"_$p(^(x),"\",23) //如果年龄只有最大值，则改为“0-最大值”的格式
 ...i $l($p(^(x),"\",23)),age<$p($p(^(x),"\",23),"-",1) q
 ...i $l($p(^(x),"\",23)),age>$p($p(^(x),"\",23),"-",2) q
 ...i $l($p(^(x),"\",22)),$p(^(x),"\",22)'=spec q
 ...i $l($p(^(x),"\",21)),$p(^(x),"\",21)'=cond q
 ...i $l($p(^(x),"\",24)),$p(^(x),"\",24)'=loc q
 ...i $l($p(^(x),"\",25)),'$l(age) q
 ...i $l($p(^(x),"\",25)),weeks<$p($p(^(x),"\",25),"-",1) q
 ...i $l($p(^(x),"\",25)),weeks>$p($p(^(x),"\",25),"-",2) q
 ...s xf=(''$l($p(^(x),"\",21)))+(''$l($p(^(x),"\",22)))+(''$l($p(^(x),"\",23)))+(''$l($p(^(x),"\",24)))+(''$l($p(^(x),"\",25))),xf(xf,x)=^(x)
 ..s xf=$o(xf(""),-1) i $l(xf) s x=$o(xf(xf,"")) i $l(x) d
 ...s (aaLow,aaHigh,aaPLow,aaPHigh)=""
 ...//i $l(mi) s rowid=tc_"||"_date_"||"_type_"||"_x_"||"_mi i '$$select^LVBCTTCG(rowid) d
 ...//.s aaLow=PLIST(3),aaHigh=PLIST(4),aaPLow=PLIST(5),aaPHigh=PLIST(6)
 ...i $l(mi) d Select 
 ...s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
 ...i $l(aaLow)!$l(aaHigh) s $p(xx,"\",3)=aaLow,$p(xx,"\",4)=aaHigh
 ...i pregn["Y" s xx=$p(xf(xf,x),"\",9,16)_"\"_$p(xf(xf,x),"\",19,20) d
 ....s exist="" f j=1:1:10 i $l($p(xx,"\",j)) s exist=1 q
 ....i 'exist d
 .....s xx=$p(xf(xf,x),"\",1,8)_"\"_$p(xf(xf,x),"\",17,18)
 .....i $l(aaPLow)!$l(aaPHigh) s $p(xx,"\",3)=aaPLow,$p(xx,"\",4)=aaPHigh
 ...s result=$p(xx,"\",1)_$c(1)_$p(xx,"\",2)_$c(1)_$p(xx,"\",5)_$c(1)_$p(xx,"\",6)_$c(1)_$p(xx,"\",7)_$c(1)_$p(xx,"\",8)_$c(1)_$p(xx,"\",3)_$c(1)_$p(xx,"\",4)_$c(1)_$p(xx,"\",9)_$c(1)_$p(xx,"\",10)
 For j=1:1:$l(result,$c(1)) s x=$p(result,$c(1),j) i $l(x) d
 .i ($e(x)="<")!($e(x)=">") d  q
 ..s $p(result,$c(1),j)=$e(x)_$j($e(x,2,$l(x)),0,$e(format,2,4))
 ..i $e(x,2)="." s $p(result,$c(1),j)=$e(x)_0_$e(x,2,$l(x))
 .s $p(result,$c(1),j)=$j(x,0,$e(format,2,4))
 .i $e($p(result,$c(1),j))="." s $p(result,$c(1),j)=0_$p(result,$c(1),j)
  //w !,"@Debug Start-------------------------------------",!
  //w "result:"_result
  //w !,"@Debug End---------------------------------------",!
 Quit result
 
Select
 set tc=$g(tc),date=$g(date), type=$g(type),x=$g(x),mi=$g(mi),ValDeli="\"
 If $Data(^TTAB("TC",tc,4,date,type,x,mi))=0 Quit
 Set rangesAAStr=^TTAB("TC",tc,4,date,type,x,mi)
 Set aaLow=$Piece(rangesAAStr,ValDeli,1)
 Set aaHigh=$Piece(rangesAAStr,ValDeli,2)
 Set aaPLow=$Piece(rangesAAStr,ValDeli,3)
 Set aaPHigh=$Piece(rangesAAStr,ValDeli,4)
 Quit
}

/// 检验项目结果多范围值的获取
/// [Previously private]
ClassMethod GetMultiScope(ItemCode, LabNo, date) As %String
{
   
   ;先判断有没有临床条件?若有临床条件则不需要返回多范围了
   s ItemCode=$g(ItemCode),LabNo=$g(LabNo),date=$g(date)
   ;s conditions=""    ?????  Liuzf-20090422
   ;s conditions=$P($g(^TEPI(LabNo,0)),"\",17)  ???? Liuzf-20090422
   ;i conditions'="" q ""        ???? Liuzf-20090422
   s Scopy=""
   i '$l(date) s date=+$h
   i '$d(^TTAB("TC",ItemCode,4,date)) s date=$o(^TTAB("TC",ItemCode,4,date),-1)
   i $l(date) d
   .s num=1
   .s ord="" f  s ord=$o(^TTAB("TC",ItemCode,4,date,0,ord)) q:ord=""  d
   ..i $p(^TTAB("TC",ItemCode,4,date,0,ord),"\",21)'="" d
   ...s clc=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",21)
   ...s temL=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",1)
   ...s temH=$p(^TTAB("TC",ItemCode,4,date,0,ord),"\",2)
   ...i $l(temH) s temrange=^TTAB("CLC",clc)_"("_$j(temL,3,2)_"-"_$j(temH,3,2)_")"
   ...i '$l(temH) s temrange=^TTAB("CLC",clc)_"("_temL_")"
   ...;s temrange=^TTAB("CLC",clc)_"("_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",1),3,2)_"-"_$j($p(^TTAB("TC",ItemCode,4,date,0,ord),"\",2),3,2)_")"
   ...i (num#2)=0 d
   ....s Scopy=Scopy_temrange_$c(10,13)
   ...e  d
   ....s Scopy=Scopy_temrange_$c(32)
   ...s num=num+1
   q Scopy
}

/// 根据日期获取检验项目的单位 //$$Units^DHCCTTCU(TC,recdate) ;
/// [Previously private]
ClassMethod GetTCUnitByDate(tc, date) As %String
{
  ;table CT_TestCodePrevUnits
  s tc=$g(tc),date=$g(date)
  i '$l(tc) q ""
  i '$l(date) s date=+$h
  s date=date+1
  s last=$o(^TTAB("TC",tc,6,""),-1)
  q:($Data(^TTAB("TC",tc))'=1)&($Data(^TTAB("TC",tc))'=11) ""
  s unit=$p(^TTAB("TC",tc),"\",2)
  i date>last s last="" q unit
  i $d(^TTAB("TC",tc,6,date)) q $p(^TTAB("TC",tc,6,date),"\",1) 
  s last=date s last=$o(^TTAB("TC",tc,6,last)) ; q:(last<date)!(last="")
  ;i last="" s last=$o(^TTAB("TC",tc,6,""))
  q $p(^TTAB("TC",tc,6,last),"\",1)
}

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SD.DataSrv.LisInfoSrv","QryLisInfo","185","15","1||262")
Query QryLisInfo(aEpisodeID As %String, aMrListID As %String, aItemID As %String) As %Query(ROWSPEC = "RowID,LisRepID,LabOrdTSDesc,LisRepStatus,LabSpecimen,LabRecDate,LisRepDateT,OEItemID")
{
}

ClassMethod QryLisInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aMrListID As %String, aItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aEpisodeID="") $$$OK
 	Set ^tmpzgz10202=$lb(aEpisodeID,aMrListID,aItemID)
 	Set return="",aDicID="",aOEItemID="",SourceField="",ResultFlg=0
 	If (aItemID'="") {
	 	//根据配置信息，获取关联信息
	 	Set ConfigID=$o(^DHCMA.CPW.SD.QCItemDataConfigI("IdxItem",aItemID,0))
	 	Set objConfig=##class(DHCMA.CPW.SD.QCItemDataConfig).GetObjById(ConfigID)
	 	If ($IsObject(objConfig)) {
		 	Set StandDic=objConfig.StandDic
		 	Set StandDicSub=objConfig.StandDicSub
		 	Set:$IsObject(StandDic) aDicID=StandDic.%Id()
		 	//检验信息 标准字典子项为结果相关
		 	Set:$IsObject(StandDicSub) ResultFlg=1
	 	}
	 	//获取项目值对应的ObjectID
		Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",aMrListID,aItemID,""),-1)
 		If (ESubID'="") {
			Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(aMrListID_"||"_ESubID)
		 	Set ObjectID=ItemExecObj.ObjectID	
		 	Set:ObjectID["OE" aOEItemID=$p(ObjectID,":",2)
		 	Set:$IsObject(objConfig) SourceField=objConfig.SourceField
		}
 	}
 	Set LinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(aDicID)
 	Quit:LinkOrder="" $$$OK
 	For OrdInd=1:1:$l(LinkOrder,"^") {
		Set EPOrderID=$P(LinkOrder,"^",OrdInd)
		Continue:EPOrderID=""
		Set objEPOrder=##class(DHCMA.Util.EPx.OrdMast).GetObjById(EPOrderID)
		Set ARCMastID=$p(objEPOrder.OID,"!!",1)
		Continue:ARCMastID=""
		Set xOrdID="",EpisodeID=$p(aEpisodeID,"!!",1)
		For {
			Set xOrdID=$o(^DHCMA.CPW.SD.Data.OrderInfoI("IdxAdmARC",EpisodeID,ARCMastID,xOrdID))
			Quit:xOrdID=""
			Set objOrder=##class(DHCMA.CPW.SD.Data.OrderInfo).GetObjById(xOrdID)
			Set OEStatus=objOrder.OEStatus	
			Set OEPriority=objOrder.OEPriority
			Set:OEPriority="" OEPriority="NORM"
			Continue:("CU"[OEStatus)
			Set xOEItem=objOrder.OEItemID
		 	Set xRowID=""
		 	For {
				Set xRowID=$o(^DHCMA.CPW.SD.Data.LisInfoI("IdxAdmOEItem",EpisodeID,xOEItem,xRowID))
				Quit:xRowID=""
				Set xobjLab=##class(DHCMA.CPW.SD.Data.LisInfo).GetObjById(xRowID)
				Set xobjLab.LabRecDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(xobjLab.LabRecDate)
				Set LisRepDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(xobjLab.LisRepDate)
				Set LisRepTime=$zt(xobjLab.LisRepTime)
				Set xobjLab.LisRepDateT=LisRepDate_" "_LisRepTime 
				Set LisRepStatus=xobjLab.LisRepStatus
				Set xobjLab.LisRepStatus=$S(LisRepStatus="3":"审核",1:"未审核")
				//根据执行医嘱、输出字段，标记输出内容
				If (SourceField'="")&&(aOEItemID=xOEItem) {
					If (ResultFlg) {
						//如果是显示结果而非报告记录中的信息，则选中整条报告记录
						Set xOEItem="#"_xOEItem	
					}else {
						Set $property(xobjLab,SourceField)="*"_$property(xobjLab,SourceField)
					}	
				}elseif(aOEItemID=xOEItem) {
					//没有具体字段输出内容，应当标记整条医嘱记录
					Set xOEItem="*"_xOEItem
				}
				Set LabOrdTSDesc=xobjLab.LabOrdTSDesc
				Set LisRepStatus=xobjLab.LisRepStatus
				Set LabSpecimen=xobjLab.LabSpecimen
				Set LabRecDate=xobjLab.LabRecDate
				Set LisRepID=xobjLab.LisRepID
				Set LisRepDateT=xobjLab.LisRepDateT
				Set Data=$lb(xRowID,LisRepID,LabOrdTSDesc,LisRepStatus,LabSpecimen,LabRecDate,LisRepDateT,xOEItem)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		
 	}
	Quit $$$OK
}

ClassMethod QryLisInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLisInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLisInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLisInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.SD.DataSrv.LisInfoSrv","QryLisResult","1","1||262")
Query QryLisResult(aLabInfoDr As %String, aItemID As %String) As %Query(ROWSPEC = "RowID,LItemCode,LItemDesc,LItemVal,LabResNoes,LabAbFlag")
{
}

ClassMethod QryLisResultExecute(ByRef qHandle As %Binary, aLabInfoDr As %String, aItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aLabInfoDr="") $$$OK
 	Set ^tmpzgz10204=$lb(aLabInfoDr,aItemID)
 	Set (aDicID,SourceField)=""
 	If (aItemID'="") {
	 	Set ConfigID=$o(^DHCMA.CPW.SD.QCItemDataConfigI("IdxItem",aItemID,0))
	 	Set objConfig=##class(DHCMA.CPW.SD.QCItemDataConfig).GetObjById(ConfigID)
	 	If ($IsObject(objConfig)) {
		 	//根据配置信息，标记特定信息
		 	Set StandDicSub=objConfig.StandDicSub
		 	Set:$IsObject(StandDicSub) aDicID=StandDicSub.%Id()
		 	Set SourceField=objConfig.SourceField
	 	}
	 	Set LinkItemCodeStr=""
	 	Set LinkItemID=##class(DHCMA.CPW.SD.StandSrv.LabStandSrv).GetLinkCode(aDicID)
	 	For xIDInd=1:1:$l(LinkItemID,"^") {
		 	Set xID=$p(LinkItemID,"^",xIDInd)
		 	Continue:xID=""
	 		Set xItemObj=##class(DHCMA.Util.EPx.TestCode).GetObjById(xID)
	 		Continue:'$IsObject(xItemObj)
	 		Set xCode=xItemObj.BTCode
	 		Set LinkItemCodeStr=LinkItemCodeStr_","_xCode
	 	}
 	}
 	Set xItemCode=""
 	For {
	 	Set xItemCode=$o(^DHCMA.CPW.SD.Data.LisItemInfoI("IdxItemCode",aLabInfoDr,xItemCode))
	 	Quit:xItemCode=""
	 	Set xRowID=$o(^DHCMA.CPW.SD.Data.LisItemInfoI("IdxItemCode",aLabInfoDr,xItemCode,0))
	 	Set xobjResult=##class(DHCMA.CPW.SD.Data.LisItemInfo).GetObjById(xRowID)
	 	Set LItemCode=xobjResult.LItemCode
	 	//根据配置数据，标记输出内容
		If (SourceField'="")&&(LinkItemCodeStr[LItemCode) {
			Set $property(xobjResult,SourceField)="*"_$property(xobjResult,SourceField)	
		}
	 	Set LItemDesc=xobjResult.LItemDesc
	 	Set LItemVal=xobjResult.LItemVal
	 	Set LabResNoes=xobjResult.LabResNoes
	 	Set LabAbFlag=xobjResult.LabAbFlag
		Set Data=$lb(xRowID,xItemCode,LItemDesc,LItemVal,LabResNoes,LabAbFlag)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryLisResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLisResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLisResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLisResultExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 通过平台取检验相关信息
/// w ##class(DHCMA.CPW.SD.DataSrv.LisInfoSrv).GetV2CListInfo(2546987) 
ClassMethod GetV2CListInfo(aEpisodeID As %String)
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set xReportDr=0,VisitCount=0
	For {
		Set xReportDr=$o(^Busi.ENS.EnsLISReportResultI("LISRRVisitNumberIndex",aEpisodeID,xReportDr))
		Quit:xReportDr=""
		
		Set RecDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),65)
		Set AuthorDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),107)
		
		Set ReportID=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),2) // 报告号
		Set Order=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),122)
		Set:Order="" Order=1   //add 20201109 解决第三方检验无此项目导致同步无法保存内容修改
		Set VisitCount=VisitCount+1
		//标本号、医嘱ID、医嘱信息（检验代码+检验名称+医嘱代码+医嘱名称）
		Set LabNo=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_ReportID,""))
		Set (OEItemID,TestSetStr,ArcimCode,ArcimDesc,TestCode,TestDesc)=""
		If LabNo'="" {
			Set xOEItemID=0
			For {
				Set xOEItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_ReportID,LabNo,xOEItemID))
		        Quit:xOEItemID=""
		        Set OEItemID = xOEItemID
				If OEItemID'="" {
					Set ArcimID=$p($g(^OEORD(+OEItemID,"I",+$p(OEItemID,"||",2),1)),"^",2)
					Set ArcimCode=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",1)
					Set ArcimDesc=$p(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1),"^",2)
					Set ExtInfo=..GetExCode(ArcimID)
					Set ExtCode=$p(ExtInfo,"^",1)
					Set ExtDesc=$p(ExtInfo,"^",2)
					Set TestCode=TestCode_"!!"_ExtCode
					Set TestDesc=TestDesc_"!!"_ExtDesc
				}
			}
			Set:TestCode'="" TestCode=$e(TestCode,3,$l(TestCode))
			Set:TestDesc'="" TestDesc=$e(TestDesc,3,$l(TestDesc))
		}
		Set LabNo = $tr(LabNo," ","")   //标本号前面有空格
		//标本代码、标本名称
		Set SpeCode=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),123)
		Set SpeDesc=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),147)
		//采集标本日期、时间、采集人
		Set CollectDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),48)
		Set CollectTime=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),49)
		Set CollectUserName=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),51)
		//接收标本日期、时间、接收人
		Set RecDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),65)
		Set RecTime=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),66)
		Set ReceiveUserName=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),68)
		//审核报告日期、时间、审核人
		Set AuthorDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),107)
		Set AuthorTime=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),108)
		Set AuthUserName=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),110)
		//登记日期、时间、登记人
		Set RegDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),111)
		Set RegTime=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),112)
		Set RegUserName=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),114)
		//申请日期、时间
		Set ReqDate=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),22)
		Set ReqTime=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),23)
		//送检科室代码、名称
		Set LocCode=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),20)
		Set LocDesc=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),21)
		//根据医嘱取申请科室 合管医嘱 LISSROrderItemID 为医嘱ID1,医嘱ID2
		If (LocCode="") {
			Set LocID=$p($g(^OEORD(+OEItemID,"I",+$p(OEItemID,"||",2),7)),"^",2)
			Set:LocID'="" LocCode = $p($g(^CTLOC(LocID)),"^",1)
			Set:LocID'="" LocDesc = $p($g(^CTLOC(LocID)),"^",2)
		}
	
		//病区代码、名称
		Set WardCode=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),24)
		Set WardDesc=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),25)
		//主要评价
		Set MajorConclusion=$lg($g(^Busi.ENS.EnsLISReportResultD(xReportDr)),143)
		
		//保存检验信息
		Set LabInfoStr=aEpisodeID
		Set LabInfoStr=LabInfoStr_$c(1)_ReportID
		Set LabInfoStr=LabInfoStr_$c(1)_OEItemID
		Set LabInfoStr=LabInfoStr_$c(1)_TestDesc
		Set LabInfoStr=LabInfoStr_$c(1)_TestCode
		Set LabInfoStr=LabInfoStr_$c(1)_LabNo
		Set LabInfoStr=LabInfoStr_$c(1)_SpeDesc
		Set LabInfoStr=LabInfoStr_$c(1)_LocDesc
		
		Set LabInfoStr=LabInfoStr_$c(1)_CollectDate
		Set LabInfoStr=LabInfoStr_$c(1)_CollectTime
		Set LabInfoStr=LabInfoStr_$c(1)_CollectUserName
		Set LabInfoStr=LabInfoStr_$c(1)_RecDate
		Set LabInfoStr=LabInfoStr_$c(1)_RecTime
		Set LabInfoStr=LabInfoStr_$c(1)_RegUserName
		Set LabInfoStr=LabInfoStr_$c(1)_AuthorDate 	// 检验报告日期
		Set LabInfoStr=LabInfoStr_$c(1)_AuthorTime 	// 检验报告时间
		
		Set Repret=##class(DHCMA.CPW.SD.Data.LisInfo).Update(LabInfoStr,$c(1))
		Continue:Repret<0
		
		Set ResultLb=..GetRepResultEns(ReportID)
		For xLInd=1:1:$ll(ResultLb){
			Set LabResult=$lg(ResultLb,xLInd)
			Continue:LabResult=""
			Set ItemCode=$p(LabResult,"^",2)    //检验项目代码
			Set ItemDesc=$p(LabResult,"^",3)    //检验项目描述
			Set ItemResult=$p(LabResult,"^",5)  //结果
			Set ItemUnit=$p(LabResult,"^",9)    //检验项目的单位
			Set AbnorFlag=$p(LabResult,"^",8)   //异常标记
			Set ItemRangs=$p(LabResult,"^",10)   //参考范围
			Set Comments=$p(LabResult,"^",7)   	 //项目备注
			Set ResultStr=Repret
			Set ResultStr=ResultStr_$c(1)_ItemCode
			Set ResultStr=ResultStr_$c(1)_ItemResult
			Set ResultStr=ResultStr_$c(1)_Comments
			Set ResultStr=ResultStr_$c(1)_AbnorFlag
			Set ResultStr=ResultStr_$c(1)_ItemDesc
			Set ResultRet=##class(DHCMA.CPW.SD.Data.LisItemInfo).Update(ResultStr,$c(1))
		}
	}
	Quit VisitCount
}

/// 获得医嘱项目对应的检验医嘱关联代码ExtCode, ExtDesc
ClassMethod GetExCode(ARCIMId As %String) As %String
{
	Quit:ARCIMId'["||" ""
	Set ItemId=$P(ARCIMId,"||",1) Quit:ItemId="" ""
	Set ItemSub=$P(ARCIMId,"||",2) Quit:ItemSub="" ""
	Set ExtCode="",ExtDesc=""
	Set chl=""
	For {
		Set chl=$o(^ARCIM(ItemId,ItemSub,"EXT",chl))
		Quit:chl=""
		Set DateTo=$p(^ARCIM(ItemId,ItemSub,"EXT",chl),"^",2)
		Set DateFrom=$p(^ARCIM(ItemId,ItemSub,"EXT",chl),"^",1)
		Quit:(DateFrom'="")&(DateFrom>+$h)
		Quit:(DateTo'="")&(DateTo<+$h)
		Set ExtCode=$p(^ARCIM(ItemId,ItemSub,"EXT",chl),"^",4)
		Set ExtDesc=$p(^ARCIM(ItemId,ItemSub,"EXT",chl),"^",6)
	}
	Quit ExtCode_"^"_ExtDesc
}

/// 获取检验结果
ClassMethod GetRepResultEns(aReportID As %String) As %List
{
	New (aReportID)
	Set return=""
	Quit:(aReportID="") return
	
	Set xShowSeq=""
	For {
		Set xShowSeq=$o(^Busi.ENS.EnsLISItemResultI("LISIRReportIDIndex",aReportID,xShowSeq))
		Quit:xShowSeq=""
		
		Set xResultID=""
		For {
			Set xResultID=$o(^Busi.ENS.EnsLISItemResultI("LISIRReportIDIndex",aReportID,xShowSeq,xResultID))
			Quit:xResultID=""
			
			Set ResultData=$g(^Busi.ENS.EnsLISItemResultD(xResultID))
			Continue:ResultData=""
			
			Set ResultID        = $lg(ResultData,2)   //检验项目结果ID
			Set TestCodeID	    = $lg(ResultData,6)   //检验项目代码
			Set TestCodeDesc	= $lg(ResultData,7)   //检验项目名称
			Set TestCodeData    = $g(^dbo.BTTestCodeD(TestCodeID))
			Set TestCodeCode	= $lg(TestCodeData,2) //检验项目代码
			Set TestCodeDesc	= $lg(TestCodeData,3) //检验项目名称
			Set RstFormat       = $lg(TestCodeData,9) //结果类型
			Set:RstFormat="X" RstFormat = "T" 	//文本格式
			
			Set Result			= $lg(ResultData,8)	  //检测结果
			Set:(RstFormat="M")&&(Result="") Result=TestCodeDesc
			Set TextRes			= $lg(ResultData,10)  //定性结果
			Set ResNoes			= $lg(ResultData,12)  //结果说明(备注)
			Set AbFlag			= $lg(ResultData,13)  //异常提示
			Set Unit			= $lg(ResultData,9)   //单位
			Set:Unit["^" Unit=$tr(Unit,"^","~")       //特殊字符处理
			Set RefRanges  	 	= $lg(ResultData,14)  //参考范围
			Set MDRResult   	= $lg(ResultData,34)  //多耐结果
			
			Set RstResItems=..GetRepRstResItem(xResultID) //根据检验结果获取耐药机制阳性结果
			For indItem=1:1:$listlength(RstResItems) {
				Set RstResItem=$listget(RstResItems,indItem)
				Continue:RstResItem=""
				Set MDRResult=MDRResult_","_RstResItem
			}
			
			Set ResultData = ResultID_"^"_TestCodeCode_"^"_TestCodeDesc_"^"_RstFormat_"^"_Result_"^"_TextRes
			_"^"_ResNoes_"^"_AbFlag_"^"_Unit_"^"_RefRanges_"^"_MDRResult
			
			Set return = return_$lb(ResultData)
		}
	}
	Quit return
}

/// 获取耐药机制阳性结果
/// w ##Class(DHCMA.CPW.SD.DataSrv.LisInfoSrv).GetRepRstResItem(1296)
ClassMethod GetRepRstResItem(aResultID As %String, ByRef errMsg As %String = "") As %List
{
	New (aResultID,errMsg)
	Set return=""
	Quit:(aResultID="") return
	
	Set $ZT="GetRepRstResItemErr"
	
	Set xShowSeq=""
	For {
		Set xShowSeq=$o(^Busi.ENS.EnsLISItemResRstI("LISIRResultSeqIndex",aResultID,xShowSeq))
		Quit:xShowSeq=""
		
		Set xRstResID=""
		For {
			Set xRstResID=$o(^Busi.ENS.EnsLISItemResRstI("LISIRResultSeqIndex",aResultID,xShowSeq,xRstResID))
			Quit:xRstResID=""
			
			Set ResRstData=$g(^Busi.ENS.EnsLISItemResRstD(xRstResID))
			Continue:ResRstData=""
			Set ResItemCode=$lg(ResRstData,4)
			Set ResItemName=$lg(ResRstData,5)
			//排除非多重耐药菌项目
		    Continue:(ResItemCode="A0001")||(ResItemCode="A0004")||(ResItemCode="A0005")||(ResItemCode="A0006")||(ResItemCode="A0007")
			Set ResRstDr=$lg(ResRstData,6)
			Continue:ResRstDr=""
            Continue:(ResRstDr'["阳性")&&(ResRstDr'["MRSA")
			Set return = return_$lb(ResItemName)
		}
	}
	Quit return
	
GetRepRstResItemErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

}
