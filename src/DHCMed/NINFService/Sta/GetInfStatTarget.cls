/// Creator:liuyh
/// CreateDate:2013-03-15
/// Description:三级医院院感评审指标
Class DHCMed.NINFService.Sta.GetInfStatTarget Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 通过就诊号获取本次就诊感染报告ID列表
ClassMethod GetReportIDByPaadm(Paadm As %String, TypeCode As %String = "", sDate As %String = "") As %String
{
	New (Paadm,TypeCode)
	
	Set return=0
	Quit:Paadm="" return
	
	Set:$g(TypeCode)="" TypeCode=" 1"
	Quit:'$d(^DHCMed.INF.ReportI("TypePaadm",TypeCode,Paadm)) return
	
	Set ReportID=""
    For {
	    Set ReportID=$o(^DHCMed.INF.ReportI("TypePaadm",TypeCode,Paadm,ReportID))
	    Quit:ReportID=""
	    Set objReport=##class(DHCMed.INF.Report).GetObjById(ReportID)
	    Continue:'$IsObject(objReport)
    	Set RepStatusCode=objReport.StatusDr    //报告状态(待审、已审等)
    	Set RepStatusID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(RepStatusCode,"InfectionReportStatus")
    	Set RepStatusDesc=""
    	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(RepStatusID)
	    Set:$IsObject(objDic) RepStatusDesc=objDic.Description
	    
	    Continue:(RepStatusDesc["删除")||(RepStatusDesc["退回")
	    
	    Set RepDate=objReport.RepDate
	    //RepDate:感染报告日期 sDate:手术日期
	    Continue:(sDate'="")&&(RepDate<sDate)&&((RepDate-sDate)>10)
	    Set:return'=0 return=return_"^"_ReportID
	    Set:return=0 return=ReportID
    }
    Quit return
}

/// 通过就诊号获取患者感染例数
ClassMethod GetPatInfCount(Paadm As %String) As %String
{
	New (Paadm)	
	
	Set return=0
	Quit:Paadm="" return
	Set ret=..GetReportIDByPaadm(Paadm)
	Quit:ret=0 return
	
	Set return=$l(ret,"^")
	
	Quit return
}

/// 通过就诊号获取患者手术相关医院感染例数
ClassMethod GetPatOperInfCount(Paadm As %String) As %String
{
	New (Paadm)	
	
	Set return=0
	Quit:Paadm="" return
	Quit:'$d(^DHCANOPArrange(0,"Adm",Paadm)) return
	Set ret=..GetReportIDByPaadm(Paadm)
	Quit:ret=0 return
	Set num=$l(ret,"^")
	
	For i=1:1:num {
		Set ReportID=$p(ret,"^",i)
		Continue:ReportID=""
		Set Flag=0
		Set RepSummaryID=0
		For {
			Set RepSummaryID=$o(^DHCMed.INF.SummaryI("InfRepDr",ReportID,RepSummaryID))
			Quit:RepSummaryID=""
			Set RepPosID=0
			For {
				Set RepPosID=$o(^DHCMed.INF.RepPosI("InfRepDr",RepSummaryID,RepPosID))
				Quit:RepPosID=""
				Set objRepPos=##class(DHCMed.INF.RepPos).GetObjById(RepPosID)
				Continue:'$IsObject(objRepPos)
				Set xInfPosCode=objRepPos.InfPosCode      //感染部位
				Set objDic=##class(DHCMed.INF.InfPosition).GetObjById(xInfPosCode)
				Continue:'$IsObject(objDic)
				Set:$IsObject(objDic) xInfPosCode=objDic.InfPosition
				Set:(xInfPosCode["表浅")||(xInfPosCode["深部")||(xInfPosCode["器官")||(xInfPosCode["腔隙") Flag=1
				}
			}
			Set return=return+Flag	
		}
	
	
	Quit return
}

/// 通过就诊号获取手术患者肺部医院感染例数
ClassMethod GetPatOperFBInfCount(Paadm As %String) As %String
{
	New (Paadm)	
	
	Set return=0
	Quit:Paadm="" return
	Quit:'$d(^DHCANOPArrange(0,"Adm",Paadm)) return
	Set ret=..GetReportIDByPaadm(Paadm)
	Quit:ret=0 return
	
	Set num=$l(ret,"^")
	
	For i=1:1:num {
		Set ReportID=$p(ret,"^",i)
		Continue:ReportID=""
		Set Flag=0
		Set RepSummaryID=0
		For {
			Set RepSummaryID=$o(^DHCMed.INF.SummaryI("InfRepDr",ReportID,RepSummaryID))
			Quit:RepSummaryID=""
			Set RepPosID=0
			For {
				Set RepPosID=$o(^DHCMed.INF.RepPosI("InfRepDr",RepSummaryID,RepPosID))
				Quit:RepPosID=""
				Set objRepPos=##class(DHCMed.INF.RepPos).GetObjById(RepPosID)
			
				Set xInfDiagDR=objRepPos.InfDiagDR        //感染诊断
				Set objDic=##class(DHCMed.INF.InfDiagnose).GetObjById(xInfDiagDR)
				If $IsObject(objDic) {
					Set xInfDiagDR=objDic.DiseaseName
				} Else {
					Set xInfDiagDR=""
				}
				Set:(xInfDiagDR["肺炎") Flag=1
				}
			}
			Set return=return+Flag	
		}
	
	
	Quit return
}

/// 通过就诊号获取手术患者手术部位医院感染例数
ClassMethod GetPatOperSSInfCount(Paadm As %String) As %String
{
	New (Paadm)	
	
	Set return=0
	Quit:Paadm="" return
	Quit:'$d(^DHCANOPArrange(0,"Adm",Paadm)) return
	Set ret=..GetReportIDByPaadm(Paadm)
	Quit:ret=0 return
	
	Set num=$l(ret,"^")
	
	For i=1:1:num {
		Set ReportID=$p(ret,"^",i)
		Continue:ReportID=""
		Set Flag=0
		Set RepSummaryID=0
		For {
			Set RepSummaryID=$o(^DHCMed.INF.SummaryI("InfRepDr",ReportID,RepSummaryID))
			Quit:RepSummaryID=""
			Set RepPosID=0
			For {
				Set RepPosID=$o(^DHCMed.INF.RepPosI("InfRepDr",RepSummaryID,RepPosID))
				Quit:RepPosID=""
				Set objRepPos=##class(DHCMed.INF.RepPos).GetObjById(RepPosID)
				Continue:'$IsObject(objRepPos)
				Set xInfPosCode=objRepPos.InfPosCode      //感染部位
				Set objDic=##class(DHCMed.INF.InfPosition).GetObjById(xInfPosCode)
				Continue:'$IsObject(objDic)
				Set:$IsObject(objDic) xInfPosCode=objDic.InfPosition
				Set:(xInfPosCode["表浅")||(xInfPosCode["深部")||(xInfPosCode["器官")||(xInfPosCode["腔隙") Flag=1
				}
			}
			Set return=return+Flag	
		}
	
	
	Quit return
}

/// 通过就诊号获取与血液透析相关血液感染例数
ClassMethod GetPatBloodInfCount(Paadm As %String) As %String
{
	New (Paadm)	
	
	Set return=0
	Quit:Paadm="" return
	Set ret=..GetReportIDByPaadm(Paadm)
	Quit:ret=0 return
	
	Set num=$l(ret,"^")
	
	For i=1:1:num {
		Set ReportID=$p(ret,"^",i)
		Continue:ReportID=""
		Set Flag=0
		Set RepSummaryID=0
		For {
			Set RepSummaryID=$o(^DHCMed.INF.SummaryI("InfRepDr",ReportID,RepSummaryID))
			Quit:RepSummaryID=""
			Set RepPosID=0
			For {
				Set RepPosID=$o(^DHCMed.INF.RepPosI("InfRepDr",RepSummaryID,RepPosID))
				Quit:RepPosID=""
				Set objRepPos=##class(DHCMed.INF.RepPos).GetObjById(RepPosID)
				Continue:'$IsObject(objRepPos)
				Set xInfPosCode=objRepPos.InfPosCode      //感染部位
				Set objDic=##class(DHCMed.INF.InfPosition).GetObjById(xInfPosCode)
				Continue:'$IsObject(objDic)
				Set:$IsObject(objDic) xInfPosCode=objDic.InfPosition
				Set:(xInfPosCode["血液透析") Flag=1
				}
			}
			Set return=return+Flag	
		}
	
	
	Quit return
}

/// 描述：获取静脉置管日数和感染次数
ClassMethod GetICUPICCOfDays(Paadm As %String)
{
	New (Paadm)
	Set UserDays=..GetICUOfDays(Paadm,"PICC")
	Set PosiDesc=""
	Set InfCount=..GetInfPosiOfCount(Paadm,"血管")
	Set Data=$lb(UserDays,InfCount)
	Quit Data
}

/// 描述：获取导尿管日数和感染次数
ClassMethod GetICUUCOfDays(Paadm As %String)
{
	New (Paadm)
	Set UserDays=..GetICUOfDays(Paadm,"UC")
	Set InfCount=..GetInfPosiOfCount(Paadm,"泌尿")
	Set Data=$lb(UserDays,InfCount)
	Quit Data
}

/// 描述：获取呼吸机日数和感染次数
ClassMethod GetICUVAPOfDays(Paadm As %String)
{
	New (Paadm)
	Set UserDays=..GetICUOfDays(Paadm,"VAP")
	Set InfCount=..GetInfPosiOfCount(Paadm,"下呼吸道")
	Set Data=$lb(UserDays,InfCount)
	Quit Data
}

/// 描述：获取ICU中的使用日数和感染例次
ClassMethod GetICUOfDays(Paadm As %String, Type As %String)
{
	New (Paadm,Type)
	Set DicID=##class(DHCMed.SSService.DictionarySrv).GetIdByTypeCode(Type,"NINFAimReportType"),
	     (UseDays,InfCount)=0
	Quit:(Type'="VAP")&&(Type'="PICC")&&(Type'="UC") ""
	
	Set TranID=0
	For {
		Set TranID=$O(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",VAPDicID,Paadm,TranID))	
		Quit:TranID=""
		
		Set RepID=0
		For {
			Set RepID=$O(^DHCMed.NINFi("AimRep",0,"IndexTypeAdmTrans",VAPDicID,Paadm,TranID,RepID))	
			Quit:RepID=""
			
			Set objRep=##class(DHCMed.NINF.Rep.AimReport).GetObjById(RepID)
			Continue:'$IsObject(objRep)
			
			Set SubID=0
			For {
				Set SubID=$o(^DHCMed.NINF("AimRep",RepID,Type,SubID))	
				Quit:SubID=""
				
				Set ReportID=RepID_"||"_SubID
				Set:Type="VAP" objRepSub=##class(DHCMed.NINF.Rep.AimReportVAP).GetObjById(ReportID)
				Set:Type="PICC" objRepSub=##class(DHCMed.NINF.Rep.AimReportPICC).GetObjById(ReportID)
				Set:Type="UC" objRepSub=##class(DHCMed.NINF.Rep.AimReportUC).GetObjById(ReportID)
				Set Days=0
				Continue:'$IsObject(objRepSub)
				
				Set objRepStatus=objRepSub.RepStatus
				If $IsObject(objRepStatus) {
					Set RepStatusCode=objRepStatus.Code
					Continue:RepStatusCode="0"  //删除的报告不再显示
					Continue:(aIsCommit="Y")&&(RepStatusCode'="2")  //未提交的报告不显示
				}
				Set OutDate=+objRepSub.ExtubateDate
				Set InDate=+objRepSub.IntubateDate
				Set:(OutDate>0)&&(InDate>0) Days=OutDate-InDate
				Set:Days>0 UseDays=UseDays+Days
				Set IsInf=objRepSub.InfDate
				Set:IsInf'="" InfCount=$i(InfCount)
			}
		}
	}
	Set Data=UseDays
	Quit Data
}

ClassMethod GetInfPosiOfCount(Paadm As %String, PosiDesc As %String) As %String
{
	New (Paadm)	
	
	Set return=0
	Quit:Paadm="" return
	Set ret=..GetReportIDByPaadm(Paadm)
	Quit:ret=0 return
	
	Set num=$l(ret,"^")
	
	For i=1:1:num {
		Set ReportID=$p(ret,"^",i)
		Continue:ReportID=""
		Set Flag=0
		Set RepSummaryID=0
		For {
			Set RepSummaryID=$o(^DHCMed.INF.SummaryI("InfRepDr",ReportID,RepSummaryID))
			Quit:RepSummaryID=""
			Set RepPosID=0
			For {
				Set RepPosID=$o(^DHCMed.INF.RepPosI("InfRepDr",RepSummaryID,RepPosID))
				Quit:RepPosID=""
				Set objRepPos=##class(DHCMed.INF.RepPos).GetObjById(RepPosID)
				Continue:'$IsObject(objRepPos)
				Set xInfPosCode=objRepPos.InfPosCode      //感染部位
				Set objDic=##class(DHCMed.INF.InfPosition).GetObjById(xInfPosCode)
				Continue:'$IsObject(objDic)
				Set:$IsObject(objDic) xInfPosCode=objDic.InfPosition
				Set:(xInfPosCode[PosiDesc) Flag=1
				}
			}
			Set return=$i(return)	
		}
	Quit return
}

}
