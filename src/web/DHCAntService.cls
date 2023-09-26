/// 名称:     web.DHCAntService
/// 描述:     医疗质量对外服务
/// 编写者：  hw
/// 编写日期: 2016-1-26
Class web.DHCAntService Extends %RegisteredObject
{

/// Creator：      hw
/// CreatDate：    2016-1-26
/// Description:： 查询危急报告
/// Table：        DHC_AntCVReport
/// Input：        pa_adm表Rowid,oe_orditem表Rowid,其他信息Json
/// Output：       处理情况 ExecFlag^ExecUserDr^ExecDate^ExecTime
/// Return：        
/// Others：      EcecFlag : 1 已处理 0 未处理
/// Others:       w ##Class(web.DHCAntService).GetAntCVExecFlag(290,"18||223" , "{""link"":""criticalvalue.trans.csp?ReportId=669||1&RepType=3"",""dialogWidth"":""800""}")
ClassMethod GetAntCVExecFlag(EpisodeId, OrdItemId, OtherInfoJson)
{
	s rtn=##Class(web.DHCAntCVService).GetExecFlag(EpisodeId ,OrdItemId , OtherInfoJson)
	q rtn
}

/// Creator：      hw
/// CreatDate：    2016-2-23
/// Description:： 是否需处理的存在危急值报告
/// Table：        DHC_AntCVReport
/// Input：        pa_adm表Rowid
/// Output：       处理情况 ExecFlag^ExecUserDr^ExecDate^ExecTime
/// Return：        
/// Others：      RtnValue :  0:无,1:有
/// Others:       w ##Class(web.DHCAntService).GetReportWarn(290)
ClassMethod GetReportWarn(EpisodeId)
{
	s rtn=##Class(web.DHCAntCVService).GetReportWarn(EpisodeId)
	q rtn
}

/// Creator：      hw
/// CreatDate：    2017-10-26
/// Description:： 需处理的存在危急值报告数
/// Table：        DHC_AntCVReport
/// Input：        pa_adm表Rowid
/// Output：       处理情况 ExecFlag^ExecUserDr^ExecDate^ExecTime
/// Return：        
/// Others：      RtnValue :  报告数
/// Others:       w ##Class(web.DHCAntService)GetReportWarnNum(290)
ClassMethod GetReportWarnNum(EpisodeId)
{
	s rtn=##Class(web.DHCAntCVService).GetReportWarnNum(EpisodeId)
	q rtn
}

/// Creator：      hw
/// CreatDate：    2016-3-2
/// Description:： 保存危急值报告
/// Table：        DHC_AntCVReport
/// Input：        报告类型:ReportType(1:检验,2病理,3心电,4超声,5内镜,6放射),
///                检查号:ExamNo
///                就诊号:Adm
///                医嘱ID:OEOrdId
///                报告审核信息:ReportInfo(审核日期^审核时间^审核人^审核说明)
///                报告结果:Result
///                检验传过来的id：LisRowid
///                后续添加串:OtherInfo  申请人^申请日期时间^采集人^采集日期时间^接收人^接收日期时间^预警日期时间^复核人^复核日期时间^报告人^报告日期时间(审核日期时间)^标本类型^危机说明^备注     (时间格式：YYYY-MM-DD  hh:mm:ss)
/// 			   2020-07-17 TestItems		检验项目结果 $lb($lb(项目代码,项目名称,缩写,结果,单位,结果异常标志,范围,仪器,备注),$lb(项目代码,项目名称,缩写,结果,单位,结果异常标志,范围,仪器,备注))
/// Output：       
/// Return：        0:成功,失败:-1^失败原因
/// Others：      ##Class(web.DHCAntService)SaveCVResult(6,"CS20160122-001",1073,"988||4","2016-1-22^14:11:36^687^","ww")
ClassMethod SaveCVResult(ReportType As %String, ExamNo As %String, Adm As %String, OEOrdId As %String, ReportInfo As %String, Result As %String, LisRowid As %String = "", OrderInfo As %String = "", TestItems = "") As %String
{
	s ret=##Class(web.DHCAntCVService).SaveCVResult(ReportType,ExamNo,Adm,OEOrdId,ReportInfo,Result,LisRowid,OrderInfo,TestItems)
	q ret
}

/// Creator：      cryze
/// CreatDate：    2018-12-14
/// Description:： 判断是否是危急值报告
/// Table：        DHC_AntCVReport
/// Input：        检查/检验号:ExamNo
///                医嘱ID:OEOrdId
/// Output：       
/// Return：       是1^rowid  否0 
/// Others：      ##Class(web.DHCAntService).IsCVReport(ExamNo,OEOrdId)
ClassMethod IsCVReport(ExamNo As %String = "", OEOrdId As %String = "") As %String
{
	s ret=##Class(web.DHCAntCVService).IsCVReport(ExamNo,OEOrdId)
	q ret
}

/// Creator：      hw
/// CreatDate：    2016-3-22
/// Description:： 通过医护人员code获取抗生素审核权限
/// Table：        CT_CareProv,CT_CarPrvTp,CarPrvTpPHPoison
/// Input：        医护人员code
/// Output：       不同情况下抗菌药物审核权限
/// Return：       住院非限制^住院限制^住院特殊^门诊非限制^门诊限制^门诊特殊^急诊非限制^急诊限制^急诊特殊
/// Others：       Y ：具备审核权限  其他： 无审核权限
/// w ##class(web.DHCAntService).GetKSSPermission("298")
ClassMethod GetKSSPermission(UserCode As %String)
{
 s rtn=##class(web.DHCAntKSSService).GetKSSPermission(UserCode)
 q rtn
}

/// Adm 就诊ID Status:状态F已处理 C未处理 空全部  DateFrom:开始日期 DateTo:结束日期 UseType:用途 ReportType危急值报告类型(1:检验,2病理,3心电,4超声,5内镜,6放射  多个以,分割)
/// 返回值 $lb($lb(1危急值报告ID,2检查(检验)号,3医嘱ID,4状态,5报告类型,6报告科室,7报告日期,8报告时间,9报告结果,10处理人,11处理意见,12医嘱名称,13处理日期,14处理时间,15护士处理完成状态,16接收人,17接收备注,18接收日期,19接收时间),$lb(...))
/// s ret= ##class(web.DHCAntService).GetCVByAdm(138583)
/// zw ret   
/// w $ll(ret)  
ClassMethod GetCVByAdm(Adm = "", Status = "", DateFrom = "", DateTo = "", UseType = "", ReportType = "")
{
	s ret=##class(web.DHCAntCVService).GetCVByAdm(Adm,Status,DateFrom,DateTo,UseType, ReportType)
	q ret
}

/// Adm 就诊ID Status:状态F已处理 C未处理未接收 Rec未处理已接收 空全部  DateFrom:开始日期 DateTo:结束日期 UseType:用途 ReportType危急值报告类型(1:检验,2病理,3心电,4超声,5内镜,6放射  多个以,分割)
/// debug:d ##class(%ResultSet).RunQuery("web.DHCAntService","QryCVByAdm","","","","")
/// 输出列 reportID危急值报告ID,examno检查(检验)号,ordItem医嘱ID,repStatus状态(),repTypeDesc报告类型,repLoc报告科室,repDate报告日期,repTime报告时间,repResult报告结果,trUser处理人,trAdvice处理意见,ordItemDesc医嘱名称,trDate处理日期,trTime处理时间,nurseDoneStatus护士处理完成状态,recUser接收人,recAdvice接收备注,recDate接收日期,recTime接收时间
Query QryCVByAdm(Adm = "", Status = "", DateFrom = "", DateTo = "", UseType = "", ReportType = "") As websys.Query(CONTAINID = 0, ROWSPEC = "reportID,examno,ordItem,repStatus,repTypeDesc,repLoc,repDate,repTime,repResult,trUser,trAdvice,ordItemDesc,trDate,trTime,nurseDoneStatus,recUser,recAdvice,recDate,recTime")
{
}

ClassMethod QryCVByAdmExecute(ByRef QHandle As %Library.Binary, Adm = "", Status = "", DateFrom = "", DateTo = "", UseType = "", ReportType = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	set ind=1 s QHandle=$lb(0,repid,0) 
	
	s ret=##class(web.DHCAntCVService).GetCVByAdm(Adm,Status,DateFrom,DateTo,UseType, ReportType)
	s len=$ll(ret)
	for i=1:1:len{
		Set ^CacheTemp(repid,ind)=$lg(ret,i)
		Set ind=ind+1
	}
	
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// 获取危急值数量
/// EpisodeId 就诊ID
/// Status(,C,F) 状态 空全部 C未处理 F已处理 
/// FlagOnly(1,0) 是否仅查标志，即查到一条就退出循环
/// w ##class(web.DHCAntService).GetCVReportNum(1)
ClassMethod GetCVReportNum(EpisodeId, Status = "", FlagOnly = 0)
{
	q ##class(web.DHCAntCVService).GetCVReportNum(EpisodeId,Status,FlagOnly)
}

/// 获取某就诊 是否有未处理的危急值且开单医生是AppUserId
/// EpisodeId 就诊ID
/// AppUserId 开单医生用户ID(SS_User)
/// w ##class(web.DHCAntService).GetDocCVReportWarn("195","12176")
ClassMethod GetDocCVReportWarn(EpisodeId, AppUserId = "")
{
	q ##class(web.DHCAntCVService).GetDocCVReportWarn(EpisodeId,AppUserId)
}

}
