/// 影像操作类
/// 创建者：刘宇辉
/// 创建日期：2010-10-13
Class DHCMed.CCService.Lib.RisExamLib Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-10-13
/// Description:  影像诊断意见描述等内容
/// Table：       
/// Input：       TempStr
/// Return：      ret=0:不包含	=1:包含
/// w ##class(DHCMed.CCService.Lib.RisExamLib).ExamRisCompare("原发性肝癌可能性大")
ClassMethod ExamRisCompare(ExamStr As %String)
{
	n (ExamStr, %PAADM, %ExtraData, %ExtraDataCnt,%AutoRunFlag,%CurrentDate) //Modified By LiYang 2012-06-26 增加自动监控支持
	s ret=0,RegNo="",StudyNo="",strOrderName="",strDate = "",ItemStatus="",oeorditemdr="",IsIll="",LocName="",IshasImg="",MediumName=""
	s RptNum = 0
	q:ExamStr="" ret
	s OrderRowid=""
	s OtherParam=""
 	s OrderRowid=$o(^OEORD(0,"Adm",%PAADM,OrderRowid))
 	q:$g(OrderRowid)="" ret
 	
 	s itemsub=0 f  s itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) q:(itemsub="")  d
	.s RegNo="",StudyNo="",strOrderName="",strDate = "",ItemStatus="",oeorditemdr="",IsIll="",LocName="",IshasImg="",MediumName="",ExamResult="",ExamDesc=""
	.s replocdr=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	.q:(replocdr="")
	.s ItemStatusCode=""
	.s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	.i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)
	.q:ItemStatusCode="D"

	.i replocdr'="" s LocName=$p(^CTLOC(replocdr),"^",2)
	.s ClinicRowid=0
	.s ClinicRowid=$o(^DHCRBCi("LocClinicSet",replocdr,ClinicRowid))
	.i ClinicRowid="" q
	.s IsVerify="N"  ;没有审核
	.s resrowid="" 
	.s arcimid=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",2)
	.s ordCatId=$P($G(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1)),"^",10)
	.s ordCatDr=""
	.i ordCatId'="" s ordCatDr=$P($G(^ARC("IC",ordCatId)),"^",8)
	.i ordCatDr'="" s TOrdCat=$P($G(^OEC("ORCAT",ordCatDr )),"^",2)
	.e  s TOrdCat=""
	.s strOrderName=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)
	.s Date1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7)
	.s strDate=$zd(Date1,3)
	.s Time1=$p(^OEORD(OrderRowid,"I",itemsub,3),"^",7) 
	.s strTime=$zt(Time1)
	.q:((%AutoRunFlag=1)&&(Date1'=%CurrentDate)) //Modified By LiYang 2012-06-29 为自动监控作业提供支持
	.s papatmasmdr=$p(^PAADM(%PAADM),"^",1)
	.s RegNo=$p(^PAPER(papatmasmdr,"PAT",1),"^",1) 
	.s Memo=""
	.s oeorditemdr=OrderRowid_"||"_itemsub
	.s ItemStatDR=$p(^OEORD(OrderRowid,"I",itemsub,1),"^",13) ; 医嘱状态
	.i ItemStatDR'="" s ItemStatusCode=$p(^OEC("OSTAT",ItemStatDR),"^",1)

	.s RegDR=$o(^DHCPACRegInfoi("OEORI",oeorditemdr,""))
	.i $g(RegDR)'="" s StudyNo=$p(^DHCPACRegInfo(RegDR),"^",2)
	.i StudyNo'="" d
	..s Imgrowid=0
	..s Imgrowid=$o(^DHCRBStudyi("StudyNo-Images",StudyNo,Imgrowid))
	..i Imgrowid'="" s IshasImg="Y"
	..s RptRowId=0 f  s RptRowId=$o(^DHCRBStudyi("Report","StudyNo",StudyNo,RptRowId)) q:(RptRowId="")  d
	...s ReportID=$p(^DHCRBStudy("Report",RptRowId),"^",2)
	...s StatusDR=$p(^DHCRBStudy("Report",RptRowId),"^",4)
	...s IsIll = $p(^DHCRBStudy("Report",RptRowId),"^",7)
	...s Memo=$g(^DHCRBStudy("Report",RptRowId,"MemoEx"))
	...s ExamDesc=$g(^DHCRBStudy("Report",RptRowId,"ExamDescEx"))
    ...s ExamResult=$g(^DHCRBStudy("Report",RptRowId,"ResultDescEx"))
    ...q:ExamResult'[ExamStr
    ...s ReportDate=$p(^DHCRBStudy("Report",RptRowId),"^",9)
    ...s strReportDate=$zd(ReportDate,3)
    ...s ReportTime=$p(^DHCRBStudy("Report",RptRowId),"^",10)
    ...s strReportTime=$zt(ReportTime)
	...i $g(StatusDR)'="" d
	....s StatusCode=$p(^DHCRBCStatus("ReportStatus",StatusDR),"^",1)
	....i ((StatusCode="S")!(StatusCode="V")) s ItemStatus="Y"
	....s RptFileRowid=0 f  s RptFileRowid=$o(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid))  q:(RptFileRowid="")  d
	.....s FullFileName = $P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",1)
	.....i FullFileName'="" d
	......s MediumDR=$P(^DHCRBStudy(0,"ReportFiles",RptRowId,RptFileRowid),"^",3)
	......s MediumName=$P(^DHCRBCServer("Medium",MediumDR),"^",2)
	..s RegRowID=0
	..s RegRowID=$o(^DHCPACRegInfoi("StudyNo",StudyNo,RegRowID))
	..s OtherParam = $p($g(^DHCPACRegInfo(RegRowID)),"^",22) //RAR_Note2用作西门子看图像存放的参数
	.q:ExamResult'[ExamStr
	.s ret=1
	.s tmp=""
	.s tmp=StudyNo					//	检查号
	.s tmp=tmp_"^"_strOrderName		//	医嘱名称
	.s tmp=tmp_"^"_strDate 			//	医嘱日期
	.s tmp=tmp_"^"_ItemStatus		//	医嘱状态
	.s tmp=tmp_"^"_oeorditemdr		//	医嘱ROWID
	.s tmp=tmp_"^"_IsIll 			//	IsIll
	.s tmp=tmp_"^"_LocName  		//	执行科室名称	
	.s tmp=tmp_"^"_replocdr			//	执行科室名称ROWID	
	.s tmp=tmp_"^"_IshasImg 		//	是否有图像
	.s tmp=tmp_"^"_MediumName		//	介质名称
	.s tmp=tmp_"^"_"Image"			//	"Image"
	.s tmp=tmp_"^"_"Shut" 			//	"Shut"
	.s tmp=tmp_"^"_"Report"			//	"Report"
	.s tmp=tmp_"^"_Memo				//	备注信息
	.s tmp=tmp_"^"_OtherParam 		//	其他调用参数
	.s tmp=tmp_"^"_TOrdCat  		//	医嘱子类
	.s tmp=tmp_"^"_ExamDesc			//	检查所见
	.s tmp=tmp_"^"_ExamResult 		//	诊断意见
	.s tmp=tmp_"^"_strReportDate	//	报告日期
	.s tmp=tmp_"^"_strReportTime    //	报告时间 		
	.s %ExtraDataCnt=%ExtraDataCnt+1
	.s Rst="R"_$C(1)_tmp
	.s Rst=$$BuildExamRisCompareResult(Rst)
	.s $li(%ExtraData,%ExtraDataCnt)=Rst
	
	q ret
BuildExamRisCompareResult(arg0) //Add By LiYang 2012-06-20
	Set tmpDesc=arg0
	If $g(%AutoRunFlag)'=1
	{
		Set tmp=tmpDesc
	}
	else
	{
		//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
		Set objUser=##class(DHCMed.Base.SSUser).GetByCTPCP(+MRICDDoc)
		Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
		Do objUser.%Close()
		Set tmp=""
		Set $p(tmp,$c(3),1)=tmpDesc
		Set $p(tmp,$c(3),2)=+$zdh(strReportDate,3)
		Set $p(tmp,$c(3),3)=+$zth(strReportTime,1)
		Set $p(tmp,$c(3),4)="检查所见:"_ExamDesc_";诊断意见:"_ExamResult
		Set $p(tmp,$c(3),5)=+ReportID
		Set $p(tmp,$c(3),6)=+objUser.Rowid
		Set $p(tmp,$c(3),7)="ExamStr"_ExamStr_";%CurrentDate="_%CurrentDate
	}
	Quit tmp
}

ClassMethod GetDetails(Str As %String) As %String
{
	n (Str)
	s ret=""
	s ret="影像名称:"_$p(Str,"^",2)
	s ret=ret_"  ||报告日期:"_$p(Str,"^",18)
	s ret=ret_"  ||诊断意见:"_$p(Str,"^",17)
	q ret
}

}
