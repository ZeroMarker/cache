/// 名称: DHCMA.Util.IO.EnsSyncRis2Srv
/// 描述: 东华数据中心--检查结果接口服务
/// 编写者：pylian
/// 编写日期: 2020-05-08
Class DHCHAI.DI.DIO.EnsFromRis2Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      pylian
/// CreatDate：    2020-05-08
/// Description:   根据就诊号查询检查报告信息
/// Table：        无
/// Input：        aEpisodeID ：就诊号
///                aDateFrom  ：开始日期
///                aDateTo    ：截止日期
/// Output：       ROWSPEC=检查报告信息
/// d ##class(%ResultSet).RunQuery("DHCHAI.DI.DIO.EnsFromRis2Srv","QueryRBReport","62","2020-04-10","2020-04-28")
Query QueryRBReport(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,StudyNo:%String,StatusCode:%String,StatusDesc:%String,OrdItemCode:%String,OrdItemDesc:%String,ExamDesc:%String,ExamResult:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserDesc:%String,RepDate:%String,RepTime:%String,RepUserCode:%String,RepUserDesc:%String")
{
}

ClassMethod QueryRBReportExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	
	If aEpisodeID'="" {
		Set AdmStr = $g(^PAADM(aEpisodeID))
		Set AdmType= $p(AdmStr,"^",2)       //就诊类型
		Quit:(AdmType'="I")&(AdmType'="E") $$$OK
		
		Set xID=0
		For {
			Set xID=$o(^Busi.ENS.EnsRISReportResultI("RISRVisitNumberIndex",aEpisodeID,xID))
			Quit:xID=""
		
			Set ReportData=$g(^Busi.ENS.EnsRISReportResultD(xID))
			Continue:ReportData=""
			Set ReportDate=$lg(ReportData,10)   //报告日期
			Set CheckDate=$lg(ReportData,14)    //审核日期
			Set UpdateDate=$lg(ReportData,29)   //时间戳 更新日期
			//报告日期和审核日期都不在查询日期范围内
			If (aDateFrom'=""){
				Continue:(CheckDate<aDateFrom)&(ReportDate<aDateFrom)
			}
			If (aDateTo'=""){
				Continue:(CheckDate>aDateTo)&(ReportDate>aDateTo)
			}
	
			Set Data=..BuildRBReport(xID)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	} Else {
		For xDate=aDateFrom:1:aDateTo {
			Set xTime=""    //update 2022-01-20  Time=0，0点病人会遗漏
			For {
				Set xTime=$o(^Busi.ENS.EnsRISReportResultI("RISRUpdateTimeIndex",xDate,xTime))
				Quit:xTime=""
				Set xID=0
				For {
					Set xID=$o(^Busi.ENS.EnsRISReportResultI("RISRUpdateTimeIndex",xDate,xTime,xID))
					Quit:xID=""
			
					Set ReportData=$g(^Busi.ENS.EnsRISReportResultD(xID))
					Continue:ReportData=""
					Set ReportDate=$lg(ReportData,10)   //报告日期
					Set CheckDate=$lg(ReportData,14)    //审核日期
					Set UpdateDate=$lg(ReportData,29)   //时间戳 更新日期
					//报告日期和审核日期都不在查询日期范围内
					If (aDateFrom'=""){
						Continue:(CheckDate<aDateFrom)&(ReportDate<aDateFrom)
					}
					If (aDateTo'=""){
						Continue:(CheckDate>aDateTo)&(ReportDate>aDateTo)
					}
	
					Set Data=..BuildRBReport(xID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	Quit $$$OK
}

ClassMethod QueryRBReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRBReportExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryRBReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRBReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      pylian
/// CreatDate：    2020-05-08
/// Description:  组织Query输出检查报告
/// Input：       aReportID : 检查报告ID
/// Return：      返回List
/// w ##Class(DHCHAI.DI.DIO.EnsFromRis2Srv).BuildRBReport(2)
ClassMethod BuildRBReport(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	New (aReportID,errMsg)
	Set return=""
	Quit:(aReportID="") return
	
	Set $ZT="BuildRBReportErr"
	
	Set ReportData=$g(^Busi.ENS.EnsRISReportResultD(aReportID))
	Quit:ReportData="" return
	Set EpisodeID=$lg(ReportData,6)              //就诊号
	Quit:EpisodeID="" return
		
	Set StudyNo=$lg(ReportData,3)                //检查号
	Set ExamDesc     = $lg(ReportData,24)        // 检查所见
	Set ExamResult   = $lg(ReportData,25)        // 诊断意见
	Set StatusCode   = "V"                       // 报告状态代码
	Set StatusDesc   = "已审核"                  // 报告状态名称
	Set OrdItemID    = $lg(ReportData,4)        // 医嘱ID
	//Set OrdItemDesc  = $lg(ReportData,31)        // 医嘱名称  (不知为何是1,不用该字段) 
 	Set ArcimID=$p(^OEORD(+OrdItemID,"I",+$p(OrdItemID,"||",2),1),"^",2)
 	Quit:ArcimID="" return
	Set OrdItemCode  = $p($g(^ARCIM(+ArcimID,1,1)),"^",1)	 //医嘱代码	    
	Set OrdItemDesc  = $p($g(^ARCIM(+ArcimID,1,1)),"^",2)        // 医嘱名称	
	Set RegUserCode  = ""                        // 登记医师代码
	Set RegUserDesc  = ""                        // 登记医师姓名
	Set RegDate      = ""                        // 登记日期
	Set RegTime      = ""                        // 登记时间
	Set RepDate      = $lg(ReportData,10)        // 报告日期
	Set RepTime      = $lg(ReportData,11)        // 报告时间
	Set RepUserCode  = $lg(ReportData,8)         // 报告医师代码
	Set RepUserDesc  = $lg(ReportData,9)         // 报告医师姓名

	Set CheckDocCode = $lg(ReportData,12)        // 审核医师代码
	Set CheckDocDesc = $lg(ReportData,13)        // 审核医师姓名
	Set CheckDate    = $lg(ReportData,14)        // 审核日期
	Set CheckTime    = $lg(ReportData,15)        // 审核时间
	If $lg(ReportData,16)'="" {
		Set CheckDocCode = $lg(ReportData,16)     // 终审医师代码
		Set CheckDocDesc = $lg(ReportData,17)     // 终审医师姓名
		Set CheckDate    = $lg(ReportData,18)     // 终审日期
		Set CheckTime    = $lg(ReportData,19)     // 终审时间
	}
	Set ExamItem     = $lg(ReportData,20)        // 检查项目描述
	Set Memo         = $lg(ReportData,27)        // 备注信息(报告建议)
	Set RBACode      = $lg(ReportData,21)        // 检查部位代码
	Set RBADesc      = $lg(ReportData,22)        // 检查部位描述
	Set RMethod      = $lg(ReportData,23)        // 检查方法
	Set ACRCode      = $lg(ReportData,26)        // ACR代码
		
	
 	Set return=$lb(aReportID)
	Set return=return_$lb(EpisodeID)
	Set return=return_$lb(StudyNo)
	Set return=return_$lb(StatusCode)
	Set return=return_$lb(StatusDesc)
	Set return=return_$lb(OrdItemCode)
	Set return=return_$lb(ExamItem)  //平台检查名称为医嘱+部位
	Set return=return_$lb(ExamDesc)
	Set return=return_$lb(ExamResult)
	Set return=return_$lb(RegDate)
	Set return=return_$lb(RegTime)
	Set return=return_$lb(RegUserCode)
	Set return=return_$lb(RegUserDesc)
	Set return=return_$lb(RepDate)
	Set return=return_$lb(RepTime)
	Set return=return_$lb(RepUserCode)
	Set return=return_$lb(RepUserDesc)
	Quit return
	
BuildRBReportErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

}
