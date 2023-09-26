Class DHCMA.VTE.DI.Exam Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2017-09-07
/// Description:  查询检查报告记录
/// Table：       DHCRB_Report、DHCPACRegInfo
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.VTE.DI.Exam","QueryRBReport",88,"2020-08-18","2020-08-18")
Query QueryRBReport(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,StudyNo:%String,StatusCode:%String,StatusDesc:%String,OrdItemCode:%String,OrdItemDesc:%String,ExamDesc:%String,ExamResult:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserDesc:%String,RepDate:%String,RepTime:%String,RepUserCode:%String,RepUserDesc:%String") [ SqlProc ]
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
	Set $ZT="AutoTaskErr"
	Set AdmStr = $g(^PAADM(+aEpisodeID))
	Set AdmType= $p(AdmStr,"^",2)       //就诊类型
	Quit:(AdmType'="I")&(AdmType'="E") $$$OK
	Set xID=0
	For {
		Set xID=$o(^DHCRBStudyi("Report-PAADMDR",+aEpisodeID,xID))
		Quit:xID=""
			
		Set ReportData=$g(^DHCRBStudy("Report",xID))
		Continue:ReportData=""
		Set RecDate=$p(ReportData,"^",9)  //报告日期
		Continue:RecDate=""
		Continue:RecDate<aDateFrom
		Continue:RecDate>aDateTo
			
		Set Data=..BuildRBReport(xID)
		Continue:Data=""
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
AutoTaskErr
	Quit $$$OK
}

ClassMethod QueryRBReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRBReportExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QueryRBReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRBReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2017-09-07
/// Description:  组织Query输出检查报告
/// Input：       aReportID : 检查报告ID
/// Return：      返回List
/// w ##Class(DHCHAI.DI.DIO.FromPacsSrv).BuildRBReport(2)
ClassMethod BuildRBReport(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	Set return=""
	Quit:(aReportID="") return
	
	Set $ZT="BuildRBReportErr"
	
	Set ReportData=$g(^DHCRBStudy("Report",aReportID))
	Quit:ReportData="" return
	Set EpisodeID=$p(ReportData,"^",16)     //就诊号
	Quit:EpisodeID="" return
 	Set StudyNo=$p(ReportData,"^",1)        //检查号
 	Set OEItemID=$p(ReportData,"^",15)      //医嘱ID
 	Set ArcimID=$p(^OEORD(+OEItemID,"I",+$p(OEItemID,"||",2),1),"^",2)
 	Quit:ArcimID="" return
	Set OrdItemCode=$p($g(^ARCIM(+ArcimID,1,1)),"^",1)		           //检查项目代码
	Set OrdItemDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)	               //检查项目名称
 	Set Memo=$g(^DHCRBStudy("Report",aReportID,"MemoEx"))              //备注信息
	Set ExamDesc=$g(^DHCRBStudy("Report",aReportID,"ExamDescEx"))      //检查所见
    Set ExamResult=$g(^DHCRBStudy("Report",aReportID,"ResultDescEx"))  //诊断意见
    
    Set RepDate=$p(ReportData,"^",9)        //报告日期
    Set RepTime=$p(ReportData,"^",10)       //报告时间
    Set RepUserDr=$p(ReportData,"^",8)      //报告人
    Set RepUserCode="",RepUserDesc=""
	If RepUserDr'="" {
		Set RepUserCode=$p($g(^SSU("SSUSR",RepUserDr)),"^",1)
		Set RepUserDesc=$p($g(^SSU("SSUSR",RepUserDr)),"^",2)
	}
	
	Set RegDate="",RegTime=""
	Set RepUserCode="",RepUserDesc=""
	Set RegInfoDr=$p(ReportData,"^",14)     //登记信息
	If RegInfoDr'="" {
		Set RegInfo=$g(^DHCPACRegInfo(RegInfoDr))
		Set RegDate=$p(RegInfo,"^",8)       //登记日期
		Set RegTime=$p(RegInfo,"^",9)       //登记时间
		Set RegUserDr=$p(RegInfo,"^",7)     //登记人
		If RegUserDr'="" {
			Set RegUserCode=$p($g(^SSU("SSUSR",RegUserDr)),"^",1)
			Set RegUserDesc=$p($g(^SSU("SSUSR",RegUserDr)),"^",2)
		}
	}
	
 	//报告状态（有效状态V和S）
 	//N^未写报告、I^已有图像、R^已录入、V^已审核、S^已发布、D^全科会诊
 	Set StatusDr=$p(ReportData,"^",4)       
 	Set StatusCode=$p($g(^DHCRBCStatus("ReportStatus",+StatusDr)),"^",1)  //处理StatusDr=0报错情况
 	Set StatusDesc=$p($g(^DHCRBCStatus("ReportStatus",+StatusDr)),"^",2)  //处理StatusDr=0报错情况
 	
	Set return=$lb(aReportID)
	Set return=return_$lb(EpisodeID)
	Set return=return_$lb(StudyNo)
	Set return=return_$lb(StatusCode)
	Set return=return_$lb(StatusDesc)
	Set return=return_$lb(OrdItemCode)
	Set return=return_$lb(OrdItemDesc)
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
