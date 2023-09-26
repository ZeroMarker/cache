/// 名称: DHCMed.NINF.Srv.CSSReport
/// 描述: 横断面调查(Cross-Section Study) 对外接口
/// 编写者：zhufei
/// 编写日期: 2012-11-30
Class DHCMed.NINF.Srv.CSSReport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 报告ID
Property ReportID As %String(TRUNCATE = 1);

/// 就诊号
Property EpisodeID As %String(TRUNCATE = 1);

/// 基本信息ID
Property PatientID As %String(TRUNCATE = 1);

/// 报告类型    电子病历模式/EPR   科研病历模式/待定
Property ReportType As DHCMed.NINF.Srv.Dictionary;

/// 报告状态
Property ReportStatus As DHCMed.NINF.Srv.Dictionary;

/// 报告日期
Property ReportDate As %String(TRUNCATE = 1);

/// 报告时间
Property ReportTime As %String(TRUNCATE = 1);

/// 报告科室
Property ReportLoc As DHCMed.NINF.Srv.Dictionary;

/// 报告病区
Property ReportWard As DHCMed.NINF.Srv.Dictionary;

/// 临床诊断
Property ClinDiagnos As list Of DHCMed.NINF.Srv.Dictionary;

/// 是否感染
Property IsInfection As DHCMed.NINF.Srv.Dictionary;

/// 感染分类(社区感染/医院感染)
Property InfType As DHCMed.NINF.Srv.Dictionary;

/// 感染部位(感染部位+病原体)
Property InfPos As list Of DHCMed.NINF.Srv.CSSReportPos;

/// 是否使用抗菌药物
Property IsUserAnti As DHCMed.NINF.Srv.Dictionary;

/// 用药目的
Property MedPurpose As DHCMed.NINF.Srv.Dictionary;

/// 联合用药
Property CombinedMed As DHCMed.NINF.Srv.Dictionary;

/// 治疗用药是否送检
Property IsSubmission As DHCMed.NINF.Srv.Dictionary;

/// 是否手术
Property IsOperation As DHCMed.NINF.Srv.Dictionary;

/// 手术切口类型
Property OperCuteType As DHCMed.NINF.Srv.Dictionary;

/// 有无泌尿道插管
Property IsHaveUC As DHCMed.NINF.Srv.Dictionary;

/// 是否泌尿道感染前48h内有泌尿道插管
Property Is48HourUC As DHCMed.NINF.Srv.Dictionary;

/// 有无动静脉插管
Property IsHavePICC As DHCMed.NINF.Srv.Dictionary;

/// 是否血流感染前48h内有动静脉插管
Property Is48HourPICC As DHCMed.NINF.Srv.Dictionary;

/// 有无气管切开
Property IsHaveTC As DHCMed.NINF.Srv.Dictionary;

/// 是否肺部感染前48h内有气管切开
Property Is48HourTC As DHCMed.NINF.Srv.Dictionary;

/// 有无使用呼吸机
Property IsHaveVAP As DHCMed.NINF.Srv.Dictionary;

/// 是否肺部感染前48h内有使用呼吸机
Property Is48HourVAP As DHCMed.NINF.Srv.Dictionary;

/// 有无血液透析
Property IsHaveCHD As DHCMed.NINF.Srv.Dictionary;

/// Creator：     zhufei
/// CreatDate：   2012-11-30
/// Description:  根据就诊号取【横断面调查报告】接口
/// Table：       DHCMed.NINF.Srv.CSSReport
/// Input：       EpisodeID 就诊号
/// Return：      返回%List
/// w ##class(DHCMed.NINF.Srv.CSSReport).GetInfRepByAdm(60798)
ClassMethod GetInfRepByAdm(aEpisodeID As %String, aReportType As %String = "", aDateFrom As %String = "", aDateTo As %String = "", aRepLoc As %String = "", aRepStatus As %String = "") As %ListOfObjects
{
	New (aEpisodeID,aReportType,aDateFrom,aDateTo,aRepLoc,aRepStatus)
	Set return=##class(%Library.ListOfObjects).%New()
	Quit:(aEpisodeID="") return
	
	If (aReportType="EPR") {
		Set aProjectID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("ICUEPRProjectID","")
		Quit:aProjectID="" $$$OK
		Set xCRRepID=0
		For {
			Set xCRRepID=$o(^DHCMed.CR.ReportI("EpisodeID"," "_aEpisodeID,xCRRepID))
			Quit:xCRRepID=""
			Set tmpCRRep=$g(^DHCMed.CR.ReportD(xCRRepID))
			Continue:tmpCRRep=""
			Set ProjectID=$listget(tmpCRRep,3)
			Continue:aProjectID'=ProjectID	            //筛选是否"ICU感染监测报告"
			Set RepStatus=$listget(tmpCRRep,5)
			Continue:(RepStatus="R")||(RepStatus="S")	//过滤"删除"或"退回"状态报告
			Set xICURepID=$o(^DHCMed.NINF.Aim.ICUReportI("CRReportDR"," "_xCRRepID,""),-1)
			Continue:xICURepID=""
			
			//取报告对象
			//数据来源：DHCMed.NINF.Aim.ICUReport
			Set objXRep=..GetObjById(xRepID,aReportType)
			Continue:objXRep=""
			
			//Do $system.OBJ.Dump(objXRep)
			Do return.Insert(objXRep)
		}
	} Else {
		Set xRepID=0
		For {
			Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",aEpisodeID,xRepID))
			Quit:xRepID=""
			
			//取报告对象
			//数据来源：DHCMed.NINF.Rep.InfReport
			Set objXRep=..GetObjById(xRepID,aReportType)
			Continue:objXRep=""
			
			//Do $system.OBJ.Dump(objXRep)
			Do return.Insert(objXRep)
		}
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2012-11-30
/// Description:  根据ID取【横断面调查报告】接口
/// Table：       DHCMed.NINF.Srv.CSSReport
/// Input：       ReportID 就诊号
/// Return：      返回%List
/// w ##class(DHCMed.NINF.Srv.CSSReport).GetInfRepByAdm(60798)
ClassMethod GetObjById(aReportID As %String, aRepTypeCode As %String) As DHCMed.NINF.Srv.CSSReport
{
	New (aReportID,aRepTypeCode)
	Set return=""
	
	
	Quit return
}

}
