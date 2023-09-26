/// 名称: DHCMA.Util.IO.EnsSyncRis2Srv
/// 描述: 东华数据中心--检查结果接口服务
/// 编写者：zhufei
/// 编写日期: 2020-03-06
Class DHCMA.Util.IO.EnsSyncRis2Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      zhufei
/// CreatDate：    2020-03-06
/// Description:   根据就诊号查询检查报告信息
/// Table：        无
/// Input：        aEpisodeID ：就诊号
///                aDateFrom  ：开始日期
///                aDateTo    ：截止日期
/// Output：       ROWSPEC=检查报告信息
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.EnsSyncRis2Srv","QryRisReportInfo","62","2020-04-10","2020-04-28")
Query QryRisReportInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aARCCodes As %String = "") As %Query(ROWSPEC = "ID:%String,StatusCode:%String,StatusDesc:%String,StudyNo:%String,OEItemID:%String,OrdItemCode:%String,OrdItemDesc:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserDesc:%String,RepDate:%String,RepTime:%String,RepUserCode:%String,RepUserDesc:%String,ExamDesc:%String,ExamResult:%String,Memo:%String,RBACode:%String,RBADesc:%String,RMethod:%String,ACRCode:%String")
{
}

ClassMethod QryRisReportInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aARCCodes As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
	Quit:aEpisodeID="" $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aARCCodes=$g(aARCCodes)
	
	Set AdmStr=$g(^PAADM(aEpisodeID))
	Set AdmType= $p(AdmStr,"^",2)	   //就诊类型
	Quit:(AdmType'="I")&(AdmType'="E")&(AdmType'="O")&(AdmType'="H") $$$OK
	
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
		
		Set objReport=##class(User.EnsRISReportResult).%OpenId(xID)
		Continue:'$IsObject(objReport)
		Do objReport.%Close()
		
		Set ReportID     = objReport.RISRReportID       // 报告号
		Set StudyNo      = objReport.RISRExamID         // 检查单号
		Set ExamDesc     = objReport.RISRExamDesc       // 检查所见
		Set ExamResult   = objReport.RISRDiagDesc       // 诊断意见
		Set RegUserCode  = ""                           // 登记医师代码
		Set RegUserDesc  = ""                           // 登记医师姓名
		Set RegDate      = ""                           // 登记日期
		Set RegTime      = ""                           // 登记时间
		Set RepUserCode  = objReport.RISRReportDocCode  // 报告医师代码
		Set RepUserDesc  = objReport.RISRReportDocDesc  // 报告医师姓名
		Set RepDate      = objReport.RISRReportDate     // 报告日期
		Set RepTime      = objReport.RISRReportTime     // 报告时间
		Set CheckDocCode = objReport.RISRCheckDocCode   // 审核医师代码
		Set CheckDocDesc = objReport.RISRCheckDocDesc   // 审核医师姓名
		Set CheckDate    = objReport.RISRCheckDate      // 审核日期
		Set CheckTime    = objReport.RISRCheckTime      // 审核时间
		If objReport.RISRFinalCheckDate'="" {
			Set CheckDocCode = objReport.RISRFinalCheckDocCode  // 终审医师代码
			Set CheckDocDesc = objReport.RISRFinalCheckDocDesc  // 终审医师姓名
			Set CheckDate    = objReport.RISRFinalCheckDate     // 终审日期
			Set CheckTime    = objReport.RISRFinalCheckTime     // 终审时间
		}
		Set ExamItem     = objReport.RISRItemDesc       // 检查项目描述
		Set StatusCode   = "V"                          // 报告状态代码
		Set StatusDesc   = "已审核"                     // 报告状态名称
		Set OEItemID     = ""                           // 医嘱ID
		Set OrdItemCode  = objReport.RISROrderItemID    // 医嘱代码
		Set OrdItemDesc  = objReport.RISROrderItemDesc  // 医嘱名称
		Set Memo         = objReport.RISRAdviseDesc     // 备注信息(报告建议)
		Set RBACode      = objReport.RISRBACode         // 检查部位代码
		Set RBADesc      = objReport.RISRBADesc         // 检查部位描述
		Set RMethod      = objReport.RISRMethod         // 检查方法
		Set ACRCode      = objReport.RISRACRCode        // ACR代码
		
		Set Data=$lb(ReportID,StatusCode,StatusDesc,StudyNo,OEItemID,OrdItemCode,OrdItemDesc,RegDate,RegTime,RegUserCode,RegUserDesc,CheckDate,CheckTime,CheckDocCode,CheckDocDesc,ExamDesc,ExamResult,Memo,RBACode,RBADesc,RMethod,ACRCode)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryRisReportInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRisReportInfoExecute ]
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

ClassMethod QryRisReportInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRisReportInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2020-03-09
/// Description:  生成新的检查部位及关联检查项目字典
/// Table：       DHCMA.Util.EPx.AppPart、DHCMA.Util.EPx.AppArcLink
/// Input：       aInputStr    ：检查部位及关联检验项目信息
/// Output：      返回结果类型
/// w ##class(DHCMA.Util.IO.EnsSyncRis2Srv).NewAppPartAndArcDic(3,"")
ClassMethod NewAppPartAndArcDic(aSYSDr As %String, aInputStr As %String) As %String
{
	New (aSYSDr,aInputStr)
	Set return=""
	Quit:(aSYSDr="")||(aInputStr="") return
	
	Set APCode    = $p(aInputStr,"^",1)
	Set APDesc    = $p(aInputStr,"^",2)
	Quit:(APCode="")&&(APDesc="") return
	Set:APDesc="" APDesc=APCode
	Set:APCode="" APCode=APDesc
	Set ARCCode   = $p(aInputStr,"^",3)
	Set ARCDesc   = $p(aInputStr,"^",5)
	Quit:(APCode="") return
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("HIS01")    
	Quit:SYSDr="" return
	
	Set $ZT="NewAppPartAndArcDicErr"
	
	TStart
	
	//生成检查部位字典
	Set APOID=APCode_"!!"_aSYSDr
	Set objAppPart=##class(DHCMA.Util.EP.AppPart).xGetByOID(APOID)
	If $IsObject(objAppPart) {
		Set APDr=objAppPart.%Id()
	} Else {
		Set InputStr=""
		Set $p(InputStr,"^",1)=""         //ID
		Set $p(InputStr,"^",2)=APOID      //OID
		Set $p(InputStr,"^",3)=APCode     //部位代码
		Set $p(InputStr,"^",4)=APDesc     //部位名称
		Set $p(InputStr,"^",5)=""         //父节点（检查部位）
		Set $p(InputStr,"^",6)=1          //是否有效
		Set $p(InputStr,"^",7)=""         //更新人
		Set flg=##class(DHCMA.Util.EPx.AppPart).Update(InputStr,"^")
		
		If (+flg)<1 {
			TRollback
			Quit return
		}
		Set APDr=+flg
	
	}
	
	//取检查项目指针
	Set ARCDr=""
	If ARCCode'="" {
		Set ARCOID=ARCCode_"!!"_SYSDr
		Set objArcim=##class(DHCMA.Util.EP.OrdMast).xGetByOID(ARCOID)
		If $IsObject(objArcim) {  
			Set ARCDr=objArcim.%Id()
		}
	}
	//生成检查部位与检查项目对照关系
	If (APDr'="")&&(ARCDr'="") {
		If '$d(^DHCMA.Util.EPx.AppArcLinkI("IdxOfALPartArc",APDr,ARCDr)){
			Set flg=##class(DHCMA.Util.EPx.AppArcLink).Update("^"_ARCDr_"^"_APDr,"^")
			If (+flg)<1 {
				TRollback
				Quit return
			}
		}
	}
	
	TCommit
	Set return=APDr
	Quit return
	
NewAppPartAndArcDicErr
	TRollback
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2020-03-09
/// Description:  自动批量生成新的检查部位及关联检查项目字典
/// Table：       DHCMA.Util.EPx.AppPart、DHCMA.Util.EPx.AppArcLink
/// Input：       aInputStr    ：检验项目与检验医嘱信息
/// Output：      返回结果类型
/// w ##class(DHCMA.Util.IO.EnsSyncRis2Srv).AutoNewAppPartAndArcDic("2019-09-01","2019-09-26")
ClassMethod AutoNewAppPartAndArcDic(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:(aDateFrom="")||(aDateTo="") return
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	
	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("RIS01")    
	Quit:SYSDr="" return
	
	Set xUpdateDate=aDateFrom-1
	For {
		Set xUpdateDate=$o(^Busi.ENS.EnsRISReportResultI("RISRUpdateTimeIndex",xUpdateDate))
		Quit:xUpdateDate=""
		Quit:xUpdateDate>aDateTo
		
		Set xUpdateTime=""
		For {
			Set xUpdateTime=$o(^Busi.ENS.EnsRISReportResultI("RISRUpdateTimeIndex",xUpdateDate,xUpdateTime))
			Quit:xUpdateTime=""
			
			Set xID=0
			For {
				Set xID=$o(^Busi.ENS.EnsRISReportResultI("RISRUpdateTimeIndex",xUpdateDate,xUpdateTime,xID))
				Quit:xID=""
				
				Set objReport=##class(User.EnsRISReportResult).%OpenId(xID)
				Continue:'$IsObject(objReport)
				Do objReport.%Close()
				
				Set RBACode      = objReport.RISRBACode         // 检查部位代码
				Set RBADesc      = objReport.RISRBADesc         // 检查部位描述
				Set OrdItemCode  = objReport.RISROrderItemID    // 医嘱ID 非医嘱项ID
				Set OrdItemDesc  = objReport.RISROrderItemDesc  // 医嘱名称
	
	
				Set ArcimID=$p($g(^OEORD($p(OrdItemCode,"||",1),"I",$p(OrdItemCode,"||",2),1)),"^",2)
				Quit:ArcimID=""
	
				Set ArcimCode=$p($g(^ARCIM(+ArcimID,1,1)),"^",1)		//医嘱项代码
				Set ArcimDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)		//医嘱项名称
				Set ArcSubCatDr=$p($g(^ARCIM(+ArcimID,1,1)),"^",10)
				Set ArcSubCatDesc=$p($g(^ARC("IC",+ArcSubCatDr)),"^",2)	//医嘱子类
				Set ArcCatDr=$p($g(^ARC("IC",+ArcSubCatDr)),"^",8)
				Set ArcCatDesc=$p($g(^OEC("ORCAT",+ArcCatDr)),"^",2) 	//医嘱大类
				Set ArcOrdType=$p($g(^ARC("IC",+ArcSubCatDr)),"^",7)	//医嘱类型（药品R、检验L）
	
				Set APAndArcInfo=RBACode_"^"_RBADesc_"^"_ArcimID_"^"_ArcimCode_"^"_ArcimDesc
				Set flg=..NewAppPartAndArcDic(SYSDr,APAndArcInfo)
				If (+flg)<1 {
					w APAndArcInfo,!
				} Else {
					Set Count=Count+1
				}
			}
		}
	}
	
	Set return=Count
	Quit return
}

}
