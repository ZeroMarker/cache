/// 关于报告信息监控
/// 
Class DHCMed.CCService.Lib.GetInfReportInfo Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(DHCMed.CCService.Lib.GetInfReportInfo).Test()
ClassMethod Test()
{
	New
	
	Set %EpisodeID=71657
	Set %AutoRunFlag=1
	Set %CurrentDate=+$h	

	Set %EpisodeID=71657
	Set %PAADM=%EpisodeID
	Set %ExtraData=""
	Set %ErrorData=""
	Set %ExtraDataCnt=1
	Set return=..InfReport(1)
	Write "%ExtraData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ExtraData,"///"),!
	Write "%ErrorData="_##Class(DHCMed.CCService.Lib.Common).GetListToString(%ErrorData,"///"),!
	Write "return="_return,!
	Quit "Over"
}

/// s %PAADM=51104 
/// s %ExtraData=$lb("")
/// 	s %ExtraDataCnt=0
/// bug : w ##class(DHCMed.CCService.Lib.GetInfReportInfo).InfReport(1)
ClassMethod InfReport(TypeCode As %String)
{
		n (TypeCode, %PAADM, %ExtraData, %ExtraDataCnt)
		s ret=0
		s:TypeCode="" TypeCode="1"
		//^OEORD(0,"Adm",{OEORD_Adm_DR},{OEORD_RowId})
		//^OEORDi(0,"ARCIM",{OE_Order.OEORD_RowId},{OEORI_ItmMast_DR},{OEORI_SttDat},{OEORI_Childsub})
		//s TypeCode=$p(TypeCode,"||",2)
		//s TypeCode=+TypeCode_"||1"
		s RepID=##class(DHCMed.INFService.InfReportSrv).GetReportID(%PAADM,TypeCode)
		
		//s detailCnt=1
		i RepID'="" d
		.s objRep=##class(DHCMed.INF.Report).GetObjById(RepID)
		.s Status=objRep.StatusDr
		.i Status'="" d
	    ..s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Status,"InfectionReportStatus")
	    ..s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	    ..s:$IsObject(objDic) Status=objDic.Description
	    .s userInfo=objRep.UserDR
	    .i userInfo'="" d
	    ..s objUser=##class(DHCMed.Base.SSUser).GetObjById(userInfo)
	    ..s:$IsObject(objUser) userInfo=objUser.Name
	    .s repLoc=objRep.CtLoc
	    .i repLoc'="" d
	    ..s objLoc=##class(DHCMed.Base.Ctloc).GetObjById(repLoc)
	    ..i $IsObject(objLoc) d
	    ...s repLoc=objLoc.Descs
	    ...k objLoc
		.q:'$d(^DHCMed.INF.SummaryI("InfRepDr",RepID))
		.s SumID=""
		.f  s SumID=$o(^DHCMed.INF.SummaryI("InfRepDr",RepID,SumID)) q:(+SumID=0)  d
 	    ..s objSumTmp=##class(DHCMed.INF.Summary).GetObjById(SumID)
 	    ..q:'$IsObject(objSumTmp)
 	    ..s InfPlace=objSumTmp.InfPlace
 	    ..i InfPlace'="" d
	    ...s dicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(InfPlace,"InfectionRepPlace")
	    ...s objDic=##class(DHCMed.SS.Dictionary).GetObjById(dicID)
	    ...i $IsObject(objDic)  d
	    ....s InfPlace=objDic.Description
	    ....k objDic
 	    ..s ret=1         
 	    ..;b                              //存在感染报告信息
 	    ..s PosRowid=""
        ..f  s PosRowid=$o(^DHCMed.INF.RepPosI("InfRepDr",+SumID,PosRowid)) q:PosRowid=""  d
		...s objPos=##class(DHCMed.INF.RepPos).GetObjById(PosRowid)
        ...q:'$IsObject(objPos)
        ...s InfPos=objPos.InfPosCode
        ...s objPosDic=##class(DHCMed.INF.InfPosition).GetObjById(InfPos)
        ...s PosDicDesc=""
        ...s:$IsObject(objPosDic) PosDicDesc=objPosDic.InfPosition
        ...s objPosDiaDic=##class(DHCMed.INF.InfDiagnose).GetObjById(objPos.InfDiagDR)
        ...s PosDiaDesc=""
        ...s:$IsObject(objPosDiaDic) PosDiaDesc=objPosDiaDic.DiseaseName
		...s tmp=""
		...s tmp=RepID                                  //报告ID      1
		...s tmp=tmp_"^"_$zd(objRep.RepDate,3)          //报告日期    2
		...s tmp=tmp_"^"_$zt(objRep.RepTime,1)          //报告时间    3
		...s tmp=tmp_"^"_Status                         //报告状态    4
		...s tmp=tmp_"^"_userInfo                       //报告人      5
		...s tmp=tmp_"^"_repLoc                         //报告科室    6
		...s tmp=tmp_"^"_InfPlace                       //感染类型    7
		...s tmp=tmp_"^"_PosDicDesc                     //感染部位    8
		...s tmp=tmp_"^"_PosDiaDesc                     //感染诊断    9      
		...s tmp=$$BuildInfReportResult(tmp,objRep) //Modified By LiYang 2012-06-27 格式化输出，为自动化作业提供支持
		...s %ExtraDataCnt=%ExtraDataCnt+1
		...s $li(%ExtraData,%ExtraDataCnt)=tmp
		q ret
BuildInfReportResult(rst,objRep) //Add By LiYang 2012-06-20
	Set tmpDesc=rst
		//ExtraData=$lb(Summary,ActDate,ActTime,DataValue,ObjectID,UserID,Parameters)
	Set tmp=""
	Set $p(tmp,$c(3),1)=rst
	Set $p(tmp,$c(3),2)=objRep.RepDate
	Set $p(tmp,$c(3),3)=objRep.RepTime
	Set $p(tmp,$c(3),4)=PosDiaDesc
	Set $p(tmp,$c(3),5)=+objRep.%Id()
	Set $p(tmp,$c(3),6)=+objRep.UserDR
	Set $p(tmp,$c(3),7)="TypeCode"_TypeCode
	Quit tmp
}

ClassMethod GetDetails(Str As %String) As %String
{
	n (Str)
	s ret=""
	s ret="报告科室:"_$p(Str,"^",6)
	s ret=ret_"  ||报告时间:"_$p(Str,"^",2)_" "_$p(Str,"^",3)
	s ret=ret_"  ||报告状态:"_$p(Str,"^",4)
	s ret=ret_"  ||报告人:"_$p(Str,"^",5)
	s ret=ret_"  ||感染类型:"_$p(Str,"^",7)
	s ret=ret_"  ||感染部位:"_$p(Str,"^",8)
	q ret
}

}
