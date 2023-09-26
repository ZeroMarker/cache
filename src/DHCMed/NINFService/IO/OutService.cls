/// 名称: 	  DHCMed.NINFService.IO.OutService
/// 描述: 	  医院感染管理对外接口程序
Class DHCMed.NINFService.IO.OutService Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2016-03-31
/// Description:  通过就诊ID判断是否已上报院感报告
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input：       aEpisodeID ：就诊ID
/// Return：      1:是,0：否
/// w ##class(DHCMed.NINFService.IO.OutService).IGetReportByEpisodeID("494")
ClassMethod IGetReportByEpisodeID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID="" return
	
	Set $ZT="GetReportByEpisodeIDErr"
	Quit:'$d(^DHCMed.NINFi("InfRep",0,"IndexPaadm",aEpisodeID)) return  //无报告退出
	Set xRepID=0
	For {
		Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",aEpisodeID,xRepID))
		Quit:xRepID=""
	    Quit:return=1
	    
		Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
		Continue:'$IsObject(objReport)
		Continue:'$IsObject(objReport.ReportStatus)
		Set RepStatus=objReport.ReportStatus.Description
		Set RepStatusCode=objReport.ReportStatus.Code
	    Continue:RepStatusCode=0            //删除状态的无效
	
		Continue:'$IsObject(objReport.ReportType)
		Set RepTypeCode=objReport.ReportType.Code
		Continue:(RepTypeCode'="COMP")&&(RepTypeCode'="NCOM")   //院感报告、新生儿院感报告
		Set return=1
	}
	Quit return
	
GetReportByEpisodeIDErr
    Quit return
}

/// Creator：     mxp
/// CreatDate：   2017-07-31
/// Description:  通过就诊ID取感染诊断
/// Table：       DHCMed.NINF.Rep.InfReport
/// Input：       aEpisodeID ：就诊ID
/// Return：      感染诊断,多个用 ','分割
/// w ##class(DHCMed.NINFService.IO.OutService).IGetInfDiagnoseByEpisodeID(494)
ClassMethod IGetInfDiagnoseByEpisodeID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="IGetInfDiagnoseByEpisodeIDErr"
	
	Quit:'$d(^DHCMed.NINFi("InfRep",0,"IndexPaadm",aEpisodeID)) return  //无报告退出
	
	Set InfDiagList="",InfDiagDesc=""
	Set xRepID=0
	For {
		Set xRepID=$o(^DHCMed.NINFi("InfRep",0,"IndexPaadm",aEpisodeID,xRepID))
		Quit:xRepID=""
	    Quit:return=1
	    
		Set objReport=##class(DHCMed.NINF.Rep.InfReport).GetObjById(xRepID)
		Continue:'$IsObject(objReport)
		Continue:'$IsObject(objReport.ReportStatus)
		Set RepStatus=objReport.ReportStatus.Description
		Set RepStatusCode=objReport.ReportStatus.Code
	    Continue:RepStatusCode=0            //删除状态的无效
	
		Continue:'$IsObject(objReport.ReportType)
		Set RepTypeCode=objReport.ReportType.Code
		Continue:(RepTypeCode'="COMP")&&(RepTypeCode'="NCOM")   //院感报告、新生儿院感报告
		
		Set SubID=""
		For {
			Set SubID=$o(^DHCMed.NINF("InfRep",xRepID,"InfPos",SubID))
			Quit:SubID=""
			Set objInfPos=##class(DHCMed.NINF.Rep.InfReportInfPos).GetObjById(xRepID_"||"_SubID)
			Continue:'$IsObject(objInfPos)
			
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
	}
	Set:InfDiagDesc'="" InfDiagDesc=$e(InfDiagDesc,2,$l(InfDiagDesc))
	Set return=InfDiagDesc
	
	Quit return
	
IGetInfDiagnoseByEpisodeIDErr
    Quit return
}

/// Creator：     mxp
/// CreatDate：   2017-07-31
/// Description:  通过就诊ID取耐药菌及对应耐药抗生素
/// Input：       aEpisodeID ：就诊ID
/// Return：      耐药菌之间$c(1)分割，耐药菌与抗生素之间$c(2)分割，抗生素之间$c(3)分割
/// w ##class(DHCMed.NINFService.IO.OutService).IGetLabResultByEpisodeID(494)
ClassMethod IGetLabResultByEpisodeID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set $ZT="IGetLabResultByEpisodeIDErr"
	
	Set LabOECategory=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("CC-LabOECategory","")
	Quit:LabOECategory="" return
	
	Set LabResult=""	
	Set arrRec=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByAdm(aEpisodeID,"","",LabOECategory)
	Set Num=arrRec.Count()
	For indRec=1:1:Num {
		Set objRec=arrRec.GetAt(indRec)
		Continue:'$IsObject(objRec)
		
		Set TestCodeList=""
		
		//通过药敏试验结果或ESBLs试验结果监测
		If (objRec.IsESBLs=1)||(objRec.IsRBugs=1) {
			Set DataCount=objRec.TestData.Count()
			For indData=1:1:DataCount {
				Set objData=objRec.TestData.GetAt(indData)
				Continue:'$IsObject(objData)
				
				//ESBLs阳性,检验报告下的菌都耐药
				//非ESBLs阳性,需要检查药敏试验（耐药）
				Continue:(objRec.IsESBLs'=1)&&(objData.IsRBugs'=1)
				
				Continue:$listfind(TestCodeList,objData.TestCode)>0
				Set TestCodeList=TestCodeList_$lb(objData.TestCode)
				Continue:objData.DataFormat'="V"
				
				Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check0("LIS-PY",objData.DataValue)
				Continue:checkFlag'=""
				
				Set RAntiList="",SAntiList=""
				Set AntiList=objData.Antibiotics
				For indAnti=1:1:$l(AntiList,$c(1)) {
					Set xAnti=$p(AntiList,$c(1),indAnti)
					Continue:xAnti=""
					
					Set AntiDesc=$p(xAnti,$c(2),2)
					Set SenFlag=$p(xAnti,$c(2),3)
					If SenFlag["R" {
						Set RAntiList=RAntiList_$c(3)_AntiDesc
					}
				}
				Set:RAntiList'="" RAntiList=$e(RAntiList,2,$l(RAntiList))
				Set LabResult=LabResult_$c(1)_objData.DataValue_$c(2)_RAntiList
			}
		}
	}
	
	Set:LabResult'="" LabResult=$e(LabResult,2,$l(LabResult))
	Set return=LabResult
	
	Quit return
	
IGetLabResultByEpisodeIDErr
    Quit return
}

}
