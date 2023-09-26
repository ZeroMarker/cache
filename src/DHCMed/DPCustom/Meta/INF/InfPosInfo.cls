/// 名称:DHCMed.DPCustom.Meta.INF.InfPosInfo
/// 描述: 感染部位信息 数据抽取
/// 编写者：zhufei
/// 编写日期: 2013-11-28
Class DHCMed.DPCustom.Meta.INF.InfPosInfo Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// 抽取感染部位信息
/// FromDate:感染报告开始日期
/// ToDate：感染报告结束日期
ClassMethod ExtractData(aDateFrom As %Date, aDateTo As %Date) As %String
{
		n (aDateFrom,aDateTo)
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xTime=0
			For {
				Set xTime=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime))
				Quit:xTime=""
								
				Set xLoc=0
				For {
					Set xLoc=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime,xLoc))
					Quit:xLoc=""
					
					Set xRepID=0
					For {
						Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexRepDateLoc",xDate,xTime,xLoc,xRepID))
						Quit:xRepID=""
						Set ReportID=xRepID
						Set xPaadm=""
						Do BuildReportInfPosData
					}
				}
			}
		}
BuildReportInfPosData
	Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(ReportID)
	Quit:'$IsObject(objReport)
	//获取病人科室、病区信息
	Set EpisodeID=objReport.EpisodeID  //就诊号
	Set ReportDate=objReport.ReportDate
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objPaadm)
	Set AdmLoc=objPaadm.Department
	Set AdmWard=objPaadm.Ward

	//感染日期、感染部位、感染诊断、感染相关侵害性操作
	Set InfPosList=""
	Set (InfDiagList,tInfPosOprName)=""
	Set SubID=0
	For {
		Set SubID=$o(^DHCMed.NINF("InfRep",ReportID,"InfPos",SubID))
		Quit:SubID=""
		Set objInfPos=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(ReportID_"||"_SubID)
		Continue:'$IsObject(objInfPos)
		Set InfDate=$zd(objInfPos.InfDate,3) //感染日期
			
		//感染相关侵害性操作
		set IndInfPosOpr=""
		for IndInfPosOpr=1:1:objInfPos.InfPosOpr.Count()
			{
				Set objInfPosOpr=objInfPos.InfPosOpr.GetAt(IndInfPosOpr)
				Continue:'$IsObject(objInfPosOpr)
				Set objInfPosOprDic=objInfPosOpr.InvasiveOper
				Set InfPosOprName=objInfPosOprDic.Description
				set:tInfPosOprName'="" tInfPosOprName=tInfPosOprName_","_InfPosOprName
				set:tInfPosOprName="" tInfPosOprName=InfPosOprName
			}
		//感染部位
		If $IsObject(objInfPos.InfPos) {
			Set xInfPosDesc=objInfPos.InfPos.IPDesc
			If xInfPosDesc'="" {
				If $listfind(InfPosList,xInfPosDesc)<1 {
					Set InfPosList=InfPosList_$lb(xInfPosDesc)
					Set InfPosDesc=InfPosDesc_","_xInfPosDesc
				}
			}
		}
		//感染诊断
	    If $IsObject(objInfPos.InfDiag) {
			Set xInfDiagDesc=objInfPos.InfDiag.IDDesc
			If xInfDiagDesc'="" {
				If $listfind(InfDiagList,xInfDiagDesc)<1 {
					Set InfDiagList=InfDiagList_$lb(xInfDiagDesc)
					Set InfDiagDesc=InfDiagDesc_","_xInfDiagDesc
				}
			}
	    }
	}
	Set:InfPosDesc'="" InfPosDesc=$e(InfPosDesc,2,$l(InfPosDesc))
	Set:InfDiagDesc'="" InfDiagDesc=$e(InfDiagDesc,2,$l(InfDiagDesc))

	//易感因素、侵入性操作
	set (tInfFactorDesc,tOperationDesc)=""
	Set SubID=0
	For {
		
		Set SubID=$o(^DHCMed.NINF("InfRep",ReportID,"Summ",SubID))
		Quit:SubID=""
		Set objSumm=##class(DHCMed.NINF.Rep.InfReportSumm).GetObjById(ReportID_"||"_SubID)
		Continue:'$Isobject(objSumm)

		
		set IndInfFactor=""
		for IndInfFactor=1:1:objSumm.InfFactors.Count()
			{
				Set objInfFactors=objSumm.InfFactors.GetAt(IndInfFactor)
				Continue:'$IsObject(objInfFactors)
				Set objInfFactorDesc=objInfFactors.Code
				
				set:tInfFactorDesc'="" tInfFactorDesc=tInfFactorDesc_","_objInfFactorDesc
				set:tInfFactorDesc="" tInfFactorDesc=objInfFactorDesc
			}
		set IndInfOpr=""
		for IndInfOpr=1:1:objSumm.InvasiveOperation.Count()
			{
				Set objInvasiveOperation=objSumm.InvasiveOperation.GetAt(IndInfOpr)
				Continue:'$IsObject(objInvasiveOperation)
				Set objInvasiveOperationDesc=objInvasiveOperation.Code
				set:tOperationDesc'="" tOperationDesc=tOperationDesc_","_objInvasiveOperationDesc
				set:tOperationDesc="" tOperationDesc=objInvasiveOperationDesc
			}

	
	}
	Set (SubID,OprInf)=0
	For {
		Set SubID=$o(^DHCMed.NINF("InfRep",ReportID,"Opr",SubID))
		Quit:SubID=""
		Set objInfReportOpr=##class(DHCMed.NINF.Rep.InfReportOpr).GetObjById(ReportID_"||"_SubID)
		Continue:'$IsObject(objInfReportOpr)
		Set:objInfReportOpr.CuteInfFlag'="" OprInf=1
	}

	Set mainstr=""_"^"_xPaadm_"^"_"IF"_"^"_"IF-IFR-INFPOS"_"^"_ReportDate_"^"_ReportID_"^"_ReportID_"^"_""_"^"_"1"_"^"_+$h_"^"_$p($h,",",2)_"^"_""
	Set MainID=##Class(DHCMed.DP.Meta.ActMain).Update(mainstr)
	q:MainID<=0
	Set SubStr=""_"^"_MainID_"^"_"IF-IFR-INFPOS"_"^"_ReportID_"^"_AdmLoc_"^"_AdmWard_"^"_"COMP"_"^"_InfDate_"^"_InfPosDesc_"^"_InfDiagDesc_"^"_tInfFactorDesc_"^"_tOperationDesc_"^"_tInfPosOprName_"^^^^"_OprInf
	Set SubID=##Class(DHCMed.DP.Meta.InfPosInfo).Update(SubStr)
}

}
