Class web.DHCRisResourceApptSchudleInterface Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 函数名称：GetItemAppStatusInterface
/// 功能：查询医嘱的申请状态和预约详情(接口)
/// 输入参数：医嘱id和身体部位id  (每次传数据只能是1条医嘱加1个部位)
/// 返回：
/// 作者：雷
/// 日期：2016-07-15
/// w ##class(web.DHCRisResourceApptSchudleInterface).GetItemAppStatusInterface("305||1","210")
/// ////////////////////////////////////////////////////////
ClassMethod GetItemAppStatusInterface(oeorditemrowid, BodypartDR) As %String
{
	s (Regrowid,DetailRowid,GetStudyNo,ReportRowid,Info,GetPatientStatusCode)=""
	s (BookedDate,BooketTime,ResourceDesc)=""
	s ^DHCRisTemp("GetItemAppStatusInterface",oeorditemrowid)=oeorditemrowid_"^"_BodypartDR
	i oeorditemrowid'="" d
	.s Regrowid=##class(web.DHCRisResApptSchudleSystem).getRegRowid(oeorditemrowid_"^"_BodypartDR)  ;$o(^DHCPACRegInfoi("OEORI",oeorditemrowid,Regrowid))
	.b //1
	.i Regrowid'="" d
    ..s GetPatientStatusCode="登记"  ;登记
	..s GetStudyNo=$p(^DHCPACRegInfo(Regrowid),"^",2)
	..i GetStudyNo'="" d
	...s ReportRowid=$o(^DHCRBStudyi("Report","StudyNo",GetStudyNo,ReportRowid))
	...i ReportRowid'="" d 
	....s GetPatientStatusCode="已写报告"
	.e  d
	..s DetailRowid=##class(web.DHCRisResApptSchudleSystem).getBookDetailRowid(oeorditemrowid_"^"_BodypartDR)  ;$o(^DHCRBCResSchduleDetaili(0,oeorditemrowid,DetailRowid))
	..b //03
	..i DetailRowid'="" d 
	...s ResSchduleID=$p(^DHCRBCResSchduleDetail("Detail",DetailRowid),"^",2)
    ...i (ResSchduleID'="") d
    ....s ResouceId=$p(^DHCRBCResourceSchdule(ResSchduleID),"^",1)
    ....s ResourceDesc="",ResourceCode=""
    ....i ResouceId'="" d
    .....s EqId=$p($g(^RB("RES",ResouceId)),"^",3)
    .....i EqId'="" d
    ......s ResourceDesc=$p(^RBC("EQ",EqId),"^",2) 
    ......s ResourceCode=$p(^RBC("EQ",EqId),"^",1)
    ....s Date=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",2)
    ....i Date'="" d
    .....i ##class(websys.Conversions).IsValidMethodName("websys.Conversions","DateLogicalToHtml") d
    ......s BookedDate=##class(websys.Conversions).DateLogicalToHtml(Date)
    .....e  d
    ......s BookedDate=$zd(Date,3) 
    ....s StartTime=$p($g(^DHCRBCResourceSchdule(ResSchduleID)),"^",5) 
    ....i StartTime'="" s BooketTime=$zt(StartTime)
	....s GetPatientStatusCode="预约"
	....b //04
	..e  d
	...s GetPatientStatusCode="正在申请" 
	s Info=GetPatientStatusCode_"^"_$g(BookedDate)_"^"_$g(BooketTime)_"^"_$g(ResourceDesc)
	q Info
}

/// w ##class(web.DHCRisResourceApptSchudleInterface)GetReportImage("83")
/// 函数:GetReportImage
/// 功能:医嘱id和身体部位id获取图像  (每次传数据只能是1条医嘱加1个部位)
/// 返回值:是否有链接
/// 作者:雷 2016-07-15
ClassMethod IsHaveReport(oeorditemrowid, BodypartDR) As %String
{
	s Report=""
	q:(oeorditemrowid="") ""
	s Regrowid="" f  s Regrowid=$o(^DHCPACRegInfoi("OEORI",oeorditemrowid,Regrowid)) q:(Regrowid="")  d
	.i BodypartDR=""  d
	..s StudyNo=$p(^DHCPACRegInfo(Regrowid),"^",2)
	..s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
	..if RptRowId'="" d
	...s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	...i StatusDR'="" s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	...i $g(StatusCode)="S" s Report="报告"
	.e  d
	..s childsub=0 f  s childsub=$o(^DHCPACRegInfoBD("BODYPARTS",0,Regrowid,childsub)) q:childsub=""  d
    ...s bodydr=$p(^DHCPACRegInfoBD("BODYPARTS",0,Regrowid,childsub),"^",1)
    ...i (BodypartDR'="")&&(bodydr=BodypartDR)  d
    ....s StudyNo=$p(^DHCPACRegInfo(Regrowid),"^",2)
    ....s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,""),-1)
	....if RptRowId'="" d
	.....s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	.....i StatusDR'="" s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	.....i $g(StatusCode)="S" s Report="报告"
    q Report
}

}
