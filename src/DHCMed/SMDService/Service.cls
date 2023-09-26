/// 名称:DHCMed.CDService.Service
/// 描述: 重症精神障碍患者上报相关接口
/// 编写者：zhouruimeng
/// 编写日期: 2014-12-25
Class DHCMed.SMDService.Service Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2020-08-04
/// Description:  To医生站精神疾病强制或提示报卡接口
///               根据就诊号判断是否精神未上报患者
///               未上报,弹出精神疾病报告卡,提示报卡
///               已上报,不提示报卡
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      
/// w ##class(DHCMed.SMDService.Service).CheckDiagnosToSMD("164","3","4886","")
ClassMethod CheckDiagnosToSMD(aEpisodeID As %String, aDiagType As %String, aICDDxID As %String, aDiagNote As %String) As %String
{
	New (aEpisodeID,aDiagType,aICDDxID,aDiagNote)
	Set return=""
	Quit:(aEpisodeID="")||(aDiagType="")||((aICDDxID="")&&(aDiagNote="")) return
		
	Set $ZT="CheckDiagnosToSMDErr"
	Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRAdm="" return
	
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Set CountryDr=$p($g(^PAPER(PatientID,"PER",1)),"^",8)
    Set CountryDesc=""
    Set:CountryDr'="" CountryDesc=$p(^CT("COU",+CountryDr),"^",2) 
	Quit:(CountryDesc'="")&&(CountryDesc'="中国") return		//过滤外籍人员不提示报卡

	Set AdmLoc=+$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set HospID=+$p($g(^CTLOC(+AdmLoc)),"^",22)
	//初诊(A)、复诊(R)标记
	Set AdmReadm=$p($g(^PAADM(+aEpisodeID)),"^",56)
	
	//ICD或关键字监控是否精神疾病
	Set ICD10=$p($g(^MRC("ID",+aICDDxID)),"^",4)
	Set ICDDesc=$p($g(^MRC("ID",+aICDDxID)),"^",2)
	Set:aDiagNote'="" ICDDesc=ICDDesc_" "_aDiagNote
	
	Set AdmType  = $p($g(^PAADM(+aEpisodeID)),"^",2)  //就诊类型
	Set DTYPCode = $p(^MRC("DTYP",aDiagType),"^",1)					//诊断类型Code
	Set DTYPDesc = $p(^MRC("DTYP",aDiagType),"^",2)					//诊断类型Desc
	Set ReportType = 3
    If (AdmType="O")||(AdmType="E")  {//(门/急诊上报 1-重性精神疾病报卡/ 住院上报 3-严重精神障碍报卡/出院诊断上报 4-严重精神障碍出院信息单)
       Set ReportType = 1
    }
    If (AdmType="I")&&(DTYPDesc="出院诊断")  {//4-严重精神障碍出院信息单
       Set ReportType = 4
    }
    
  	Set CtlRstList=""
	Set ProductID=+##class(DHCMed.SS.Products).GetIDByCode("SMD")
	Set DisCode=0 
	For {
		Set DisCode=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductID,DisCode))
		Quit:DisCode="" 
		
		Set NeedRepFlg=0,UnNeedFlg=0
		Set xID=0
		For {
			Set xID=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductID,DisCode,xID))
			Quit:xID=""
			Continue:NeedRepFlg=1  //诊断需上报时退出
		
			Set objDisease=##class(DHCMed.SS.Disease).GetObjById(xID)
			Continue:'$IsObject(objDisease)
			Set IsActive=objDisease.IDIsActive
			Continue:IsActive'=1
			Set DisICD=objDisease.IDICD10
			Set DisICDDesc=objDisease.IDDesc
			Set DisCate=objDisease.IDCateDr.Description
	    
			//1通过精神疾病诊断ICD检索是否精神疾病
			If ((DisICD'="")&&(ICD10[DisICD)) {	
				Set NeedRepFlg=1
				Set CtlRstList=CtlRstList_$lb(xID)
			}
		
			//2通过ICD检索是否精神疾病(检索ICD维护在疾病ICD表中)
			Set xICDSubID = ""
			For {
				Set xICDSubID=$o(^DHCMed.SS.DiseaseD(xID,"I",xICDSubID))
				Quit:xICDSubID=""
		        Continue:NeedRepFlg=1  //诊断需上报时退出
		        Continue:UnNeedFlg=1   //诊断不需上报时退出
		        
				Set ID=xID_"||"_xICDSubID
				Set objICD=##class(DHCMed.SS.DiseaseICD).GetObjById(ID)
				Continue:'$IsObject(objICD)
				Set IDICD10=objICD.IDICD10
				Set IDICDDesc=objICD.IDICDDesc
				Set IDExWords=objICD.IDExWords
			
				If (ICD10[IDICD10)||($ZConvert(ICDDesc,"T")[$ZConvert(IDICDDesc,"T")) {
					Set NeedRepFlg=1
				}
				If (IDExWords'="") {  //排除关键字列表
				    For ind=1:1:$l(IDExWords,"#") {
						Set xIDExWords=$p(IDExWords,"#",ind)
						Continue:xIDExWords=""
						Continue:UnNeedFlg=1
						Set UnNeedFlg=1
				
						Continue:((ICD10[xIDExWords)||($ZConvert(ICDDesc,"T")[$ZConvert(xIDExWords,"T")))
						Set UnNeedFlg=0
					}
			   }
	       
			   If ((UnNeedFlg'=1)&&( NeedRepFlg=1)) {  //诊断需上报
				   Set CtlRstList=CtlRstList_$lb(xID)
			   }
			}
		    Continue:UnNeedFlg=1   //诊断不需上报时退出
		    
			//3通过关键字检索是否精神疾病(检索关键字维护在别名表中)
			Set xAliaSubID = ""
			For {
				Set xAliaSubID=$o(^DHCMed.SS.DiseaseD(xID,"A",xAliaSubID))
				Quit:xAliaSubID=""
		        Continue:NeedRepFlg=1 //诊断需上报时退出
		        
				Set ID=xID_"||"_xAliaSubID
				Set objAlias=##class(DHCMed.SS.DiseaseAlias).GetObjById(ID)
				Continue:'$IsObject(objAlias)
				Set IDAlias=objAlias.IDAlias
				Continue:($ZConvert(ICDDesc,"T")'[$ZConvert(IDAlias,"T"))
		
				Set NeedRepFlg=1
				Set CtlRstList=CtlRstList_$lb(xID)
			}
			
		}
	}
	Set RetCode="",RetDesc="",IsReported = 0
	For IFIndex=1:1:$listlength(CtlRstList) {
		Continue:IFIndex=""
		Quit:return'=""
		
		Set DiseaseID=$list(CtlRstList,IFIndex)
		Set objDisease=##class(DHCMed.SS.Disease).GetObjById(DiseaseID)
		Continue:'$IsObject(objDisease)
	    Set DiseaseDesc=objDisease.IDDesc
		Set RetCode=1
		Set xReportID=""
		For {
			Set xReportID=$o(^DHCMed.SMD.ReportI("IndexPatientID"," "_PatientID,xReportID))
			Quit:xReportID=""
			Set objReport=##class(DHCMed.SMD.Report).GetObjById(xReportID)
			Continue:'$IsObject(objReport)
			Continue:'$IsObject(objReport.SRDiseaseDr)
			Continue:'$IsObject(objReport.SRRepTypeDr)
			Continue:'$IsObject(objReport.SRStatusDr)
			Continue:((objReport.SRStatusDr.Code="0")||(objReport.SRStatusDr.Code="4")) //过滤报告状态：草稿、删除
			Set RepDisID=objReport.SRDiseaseDr.%Id()
			Set RepDisease=objReport.SRDiseaseDr.IDDesc
			Set EpisodeID=objReport.SREpisodeID
		    Set RepType=objReport.SRRepTypeDr.Code                //报告类型 
		    Set IsReported = 1
			Continue:(aEpisodeID=EpisodeID)&&(RepDisID=DiseaseID)&&(ReportType=RepType)  //同次就诊相同诊断相关报告类型 不提示报告
		    If (aEpisodeID'=EpisodeID)&&(RepDisID=DiseaseID) {  //非本次就诊历史已报（没判断报告类型）
		        Set RetCode =0  //提示报告
		        Set IsReported = 0
		        Quit
		    }Else {   //强制报告
			    Set RetCode=1
			    Set IsReported = 0
			    Quit
		    }
		}
		Continue:IsReported=1
		Set Info="<span style='font-weight:600;'><font style='color:red;'></br>注意：首次保存精神疾病类诊断需填报精神疾病报告，否则不允许保存诊断！</font></span>"
		If (RetCode=0){
			Set RetDesc="您填写的["_ICDDesc_"]诊断符合重症精神疾病'"_DiseaseDesc_"',请确认是否要报卡?"
		} Else {
			Set RetDesc="您填写的["_ICDDesc_"]诊断符合重症精神疾病'"_DiseaseDesc_"',请上报报卡！"_Info
		}
		Set return=return_RetCode_"^"_DiseaseID_"^"_RetDesc_"^"_ReportType
	}
	
	Quit return
	
CheckDiagnosToSMDErr
	Quit ""
}

/// w ##class(DHCMed.SMDService.Service).IsDiagnoseNeedReport(431)
ClassMethod IsDiagnoseNeedReport(EpisodeID, arg)
{
	n (EpisodeID)
	
	Set return=""
	Set RepUser="",RepDate=""
	Quit:EpisodeID="" return
	Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	Set StrCountry=##class(EPRservice.HISInterface.PatientInfoAssist).Country(PatientID)
	Set CountryDesc=$p(StrCountry,"^",3) //取国籍信息
	Quit:(CountryDesc'="")&&(CountryDesc'="中国") return		//过滤外籍人员不提示报卡
	Set MRAdm=$p($g(^PAADM(+EpisodeID)),"^",61)
	Quit:MRAdm="" return
	
	Set DiagnosID=$o(^MR(MRAdm,"DIA",""),-1)
	Quit:(+DiagnosID=0) return
	Set tmpDiagnos=$g(^MR(MRAdm,"DIA",DiagnosID))
	Set ICDDxID=$p(tmpDiagnos,"^",1)
	Set ICD10=$p($g(^MRC("ID",+ICDDxID)),"^",4)
	Set ICDDesc=$p($g(^MRC("ID",+ICDDxID)),"^",2)
	Set ICDDES=$g(^MR(MRAdm,"DIA",DiagnosID,"DES",1))
	Set ICDDHC=$g(^MR(MRAdm,"DIA",DiagnosID,"DHC",1))
	Set DiagPrefix=$p($g(^MR(MRAdm,"DIA",DiagnosID,1)),"^",26)    //诊断前缀 add 2020-09-17
	Set:DiagPrefix'="" ICDDesc=DiagPrefix_" "_ICDDesc
	
	Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
	Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
	Set DiagTypeID = $o(^MR(MRAdm,"DIA",DiagnosID,"TYP",""),-1)		//诊断类型ID
	Quit:(+DiagnosID=0) return
	Set TypeRowID = $g(^MR(MRAdm,"DIA",DiagnosID,"TYP",DiagTypeID))
	Set DTYPCode = $p(^MRC("DTYP",TypeRowID),"^",1)					//诊断类型Code
	Set DTYPDesc = $p(^MRC("DTYP",TypeRowID),"^",2)					//诊断类型Desc
	
	Set PreAdm=$g(^DHCIPBill(0,"AdmTransferLink",EpisodeID))	//判断患者是否为周转患者的标记
	
	Set SMDDisCode=0
	///重症精神障碍疾病
	Set ProductID=+##class(DHCMed.SS.Products).GetIDByCode("SMD")
	Set NeedRepFlg=0
	For {
		Set SMDDisCode=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductID,SMDDisCode))
		Quit:SMDDisCode="" 
		
		Set SMDDisId=0
		For {
			Set SMDDisId=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductID,SMDDisCode,SMDDisId))
			Quit:SMDDisId=""
			continue:NeedRepFlg=1
			Set objSMDDisease=##class(DHCMed.SS.Disease).GetObjById(SMDDisId)
			Set DisICD=objSMDDisease.IDICD10
			Set DisICDDesc=objSMDDisease.IDDesc
			Set:$IsObject(objSMDDisease.IDCateDr) DisCatCode=objSMDDisease.IDCateDr.Code
			Continue:+DisCatCode>7
			//Set:ICD10[FormICD NeedRepFlg=1
			If (ICD10=DisICD){
				Set NeedRepFlg=1
			}
			Else{
				If (ICDDesc=DisICDDesc){
					Set NeedRepFlg=1
				}
			}
			If DTYPCode="PRE"{
				Set NeedRepFlg=0
			}
			Continue:NeedRepFlg=0
			//别名^DHCMed.SS.DiseaseI("DA","IndexAlias"
			//判断是否已上报
			Set RetCode=0,RetDesc=""
			Set RowID=""
			For {
				Set RowID=$o(^DHCMed.SMD.ReportI("IndexPatientID"," "_PatientID,RowID))
				Quit:RowID=""
				Set objData=##class(DHCMed.SMD.Report).GetObjById(RowID)
				Continue:'$IsObject(objData)
				Continue:((objData.SRStatusDr.Code="0")||(objData.SRStatusDr.Code="4")) //过滤报告状态：草稿、删除
				//Continue:((objData.PatientID'=PatientID)&&(PatientID'=""))
				Set RepDisDr =objData.SRDiseaseDr
				Set RepDisId=$s(RepDisDr'="":RepDisDr.%Id(),1:"")
				//Set RepDisId = RepDisDr.%Id()
				Continue:RepDisId'=SMDDisId	 //过滤疾病
				Set RepUserID=objData.SRReportUser
				Set objUser=##class(DHCMed.Base.SSUser).GetObjById(RepUserID)
				Continue:'$IsObject(objUser)
				Set RepUser=objUser.Name
				Set RepDate=objData.SRReportDate
				Set RepDate=$zd(RepDate,3)
				Set RetCode=1	//已报告			
			}
			Set RetDesc="您填写的["_ICDDesc_"]诊断符合重症精神疾病'"_objSMDDisease.IDDesc_"',请确认是否要报卡?"
			Set return=return_RetCode_"^"_SMDDisId_"^"_RetDesc_"^"_PreAdm_"^"_RepUser_"^"_RepDate
		}
	}

	Quit return
}

/// Creator：     yukai
/// CreatDate：   2019-01-26
/// Description:  精神疾病未审核报告查询
/// Table：       DHCMed.SMDService.Service
/// Input：       aDateFrom : 开始日期
///               aDateTo   : 开始日期
/// Return：      返回String
/// w ##class(DHCMed.SMDService.Service).GetUnChkSMDReportCnt("2019-03-14","2019-06-20")
/// w ##class(DHCMed.SMDService.Service).GetUnChkSMDReportCnt("","")
ClassMethod GetUnChkSMDReportCnt(aDateFrom As %String, aDateTo As %String, aLoc As %String = "") As %String
{
	New (aDateFrom,aDateTo,aLoc)
	Set return=0
	Set Cnt=0
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom="" aDateFrom=$p($h,",",1)-30
	Set:aDateTo="" aDateTo=$p($h,",",1)
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK
	
	Set aHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(aLoc,"SMD")
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.SMD.ReportI("IndexReportDate",xDate))
		Quit:(xDate="")||(xDate>aDateTo)
		Set xTime=0
		Set xReportID=0
		For {
			Set xReportID=$o(^DHCMed.SMD.ReportI("IndexReportDate",xDate,xReportID))
			Quit:xReportID=""
			Set objReport=##class(DHCMed.SMD.Report).GetObjById(xReportID)
			Continue:'$IsObject(objReport) 
			If (aHospCode'=""){
		    	Set flag=##class(DHCMed.SSService.HospitalSrv).CheckIsHosp(aHospCode,objReport.SREpisodeID,"SMD")
		    	continue:flag<1
		   	}
			Set ReportStatus=objReport.SRStatusDr.Description
			//w ReportStatus,!
			continue:ReportStatus="删除"
			Set:ReportStatus["提交" Cnt=Cnt+1
			}
		}
		Set:Cnt'="" return=Cnt
	Quit return
}

/// Creator		: zhouruimeng
/// CreateDate	: 2015-01-16
/// Descrption	: 根据病人ID,判断出院信息单是否填写
/// Input		: EpisodeID
/// OutPut		: 未填写-0/已填写-1
/// w ##class(DHCMed.SMDService.Service).CheckUnReport(33)
ClassMethod CheckUnReport(aEpisodeID As %String)
{
	New (aEpisodeID)
	
	Set return="",num=0
	Quit:aEpisodeID="" return
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Quit:PatientID="" return
	
	//w如果为1-重性发病卡,3-严重发病卡.则需要提示填写出院信息单
	Set ReportID=""
	For {
		Set ReportID = $o(^DHCMed.SMD.ReportI("IndexPatientID"," "_PatientID,ReportID),-1)
		Quit:ReportID=""
		
		Set objRep = ##class(DHCMed.SMD.Report).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		Set RepTypeCode = objRep.SRRepTypeDr.Code
		Quit:((RepTypeCode="2")||(RepTypeCode="4"))
		If RepTypeCode="1"{
		Set:return'="" return = return_"#"
			Set return = return_"0"_"^"_"2"_"^"_"重性精神疾病出院信息单"
			Set num = num+1
		}Else{
			Set:return'="" return = return_"#"
			Set return = return_"0"_"^"_"4"_"^"_"严重精神障碍出院信息单"
			Set num = num+1
		}
	}
	
	Set:return'="" return = num_"#"_return
	Quit return
}

Storage Default
{
<Data name="ServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.SMDService.ServiceD</DataLocation>
<DefaultData>ServiceDefaultData</DefaultData>
<IdLocation>^DHCMed.SMDService.ServiceD</IdLocation>
<IndexLocation>^DHCMed.SMDService.ServiceI</IndexLocation>
<StreamLocation>^DHCMed.SMDService.ServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
