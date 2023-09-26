Class DHCMA.VTE.DI.LabReport10 Extends %RegisteredObject [ Not ProcedureBlock ]
{

// 获取检验报告

/// Creator：     zhufei
/// CreatDate：   2017-08-18
/// Description:  查询检验报告记录
/// Table：       dbo.RPVisitNumber、dbo.RPVisitNumberTestSet、dbo.RPVisitNumberReport
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.VTE.DI.LabReport10","QryLabVisitReport",88,"2020-08-17","2020-08-18")	
Query QryLabVisitReport(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "LabItemID:%String,EpisodeID:%String,ReportID:%String,AuthDate:%String,AuthTime:%String,TCCode:%String,TCDesc:%String,Result:%String,RstFormat:%String,TextRes:%String,ResNoes:%String,AbFlag:%String,Unit:%String,RefRanges:%String") [ SqlProc ]
{
}

ClassMethod QryLabVisitReportExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Set $ZT="AutoTaskErr"
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set OrdID=$o(^OEORD(0,"Adm",+aEpisodeID,0))
	Quit:OrdID="" $$$OK
	Set AdmStr=$g(^PAADM(+aEpisodeID))
	Set AdmType= $p(AdmStr,"^",2)	   //就诊类型
	Quit:(AdmType'="I")&(AdmType'="E") $$$OK 
	Set xReqDate=""
	For {
		Set xReqDate=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(+aEpisodeID),xReqDate))
		Quit:xReqDate="" 
		Set xVisitNumberDr=0
		For {
			Set xVisitNumberDr=$o(^dbo.RPVisitNumberI("IndexAdmNo",##Class(LIS.Util.Common).IndexData(+aEpisodeID),xReqDate,xVisitNumberDr))
			Quit:xVisitNumberDr=""
			
			Set VisitNumberData=$g(^dbo.RPVisitNumberD(xVisitNumberDr))
			Continue:VisitNumberData=""
			Set EpisodeID=$listget(VisitNumberData,5)		// 就诊号
			Continue:EpisodeID=""
			Set AdmStr = $g(^PAADM(+EpisodeID))
			Set AdmType= $p(AdmStr,"^",2)	                //就诊类型
			Continue:AdmType'="I" 
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
						Set:AuthDate'="" AuthDate=$zdh(AuthDate,8)
						Set ReAuthDate=$lg(ReportData,23)		   //复审日期
						Set:ReAuthDate'="" ReAuthDate=$zdh(ReAuthDate,8)
						
						Set IsAct=0
						If (AuthDate'="")&(AuthDate>=aDateFrom)&(AuthDate<=aDateTo) {
							Set IsAct=1
						}
						If (ReAuthDate'="")&(ReAuthDate>=aDateFrom)&(ReAuthDate<=aDateTo) {
							Set IsAct=1
						}
						Continue:IsAct<1
						//xReportDr
						
						Set ReportData=$g(^dbo.RPVisitNumberReportD(xReportDr))
						Quit:ReportData=""
						Set VisitNumberDr=$lg(ReportData,2)			//标本ID
						Quit:VisitNumberDr=""
						
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
												
						Set xTestCodeID = ""
 						For {
	 						Set xTestCodeID = $o(^dbo.RPVisitNumberReportResultI("IndexReportItem",xReportDr,xTestCodeID))
							Quit:xTestCodeID=""
							
							Set xResultID = ""
							For {
								Set xResultID = $o(^dbo.RPVisitNumberReportResultI("IndexReportItem",xReportDr,xTestCodeID,xResultID))
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
								
								Set Data = $lb(xReportDr,aEpisodeID,xReportDr,AuthDate,AuthTime,TestCodeCode,TestCodeDesc,Result,RstFormat,TextRes,ResNoes,AbFlag,Unit,RefRanges)
								Continue:Data=""
								Set ^CacheTemp(repid,ind)=Data
								Set ind=ind+1
							}
						}
					}
				}
			}
		}
	}	
	Quit $$$OK
AutoTaskErr
	Quit $$$OK
}

ClassMethod QryLabVisitReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabVisitReportExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabVisitReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabVisitReportExecute ]
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

}
