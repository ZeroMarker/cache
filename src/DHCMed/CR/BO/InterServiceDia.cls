/// 诊断填写上报接口
Class DHCMed.CR.BO.InterServiceDia Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// w ##class(DHCMed.CR.BO.InterServiceDia).IsDiagnoseNeedReport("431||16",431,"DHCMed.CR.ManXingBingDiaoCha")
ClassMethod IsDiagnoseNeedReport(DiagnoseID, EpisodeID, FormCode)
{
		n (DiagnoseID,EpisodeID,FormCode)
		
		Set ret=""
		Set EName=$p(FormCode,".",3)
		Set ICDList=##Class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("CRFCheckICD_"_EName,"")
		Set objEpisode=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
		Set objDia=##class(DHCMed.Base.MRDiagnose).GetObjById(DiagnoseID)
		if $IsObject(objDia){
			For i=1:1:$l(ICDList,",") {
				Set ICD=$p(ICDList,",",i)
				Continue:ICD=""
				Continue:objDia.ICD9CMCode'[ICD
				Set tmpRet=..IsReport(EpisodeID,objEpisode.PatientID,FormCode,ICD)
				Set ret=tmpRet
			}
		}
		Quit ret
}

ClassMethod IsReport(EpisodeID, PatientID, FormCode, ICD)
{
		n (EpisodeID,PatientID,FormCode,ICD)
		
		Set ESchema=" "_$ZConvert($p(FormCode,".",1),"U")
		Set Type=" "_$ZConvert($p(FormCode,".",2),"U")
		Set EName=" "_$ZConvert($p(FormCode,".",3),"U")
		
		Set FrmID=$o(^DHCMed.CR.PO.FormI("IndexTypeName",ESchema,Type,EName,""))
		Quit:FrmID="" 0
		if (EpisodeID'="")
		{
			Set objEpisode=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
			Do objEpisode.%Close()
			Set PatientID=objEpisode.PatientID
		}
		
		Set ret=0
		if (PatientID'="")	{	
			Set FormVerID=""
			For {
				Set FormVerID=$o(^DHCMed.CR.PO.DataI("IndexCustomPK",FormVerID))
				Quit:FormVerID=""
				Set tmpFormID=+$extract(FormVerID,2,$l(FormVerID))
				Continue:tmpFormID'=FrmID //过滤表单
				Set tmpCPK=""
				For {
					Set tmpCPK=$o(^DHCMed.CR.PO.DataI("IndexCustomPK",FormVerID,PatientID,tmpCPK))
					Quit:tmpCPK=""
					Set tCPK=$extract(tmpCPK,2,$l(tmpCPK))
					Continue:tCPK'[ICD
					Set RowID=""
					For {
						Set RowID=$o(^DHCMed.CR.PO.DataI("IndexCustomPK",FormVerID,PatientID,tmpCPK,RowID))
						Quit:RowID=""
						Set objData=##class(DHCMed.CR.PO.Data).%OpenId(RowID)
						Continue:'$IsObject(objData)
						Do objData.%Close()
						Continue:((objData.CurrentStatusCode'="01")&&(objData.CurrentStatusCode'="99"))
						Continue:((objData.EpisodeID'=EpisodeID)&&(EpisodeID'=""))
						Set ret=1						
					}
				}	
			}
		}
		Quit ret
}

}
