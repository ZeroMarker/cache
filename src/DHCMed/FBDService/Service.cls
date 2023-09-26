/// 名称：DHCMed.FBDService.Service
/// 描述：食源性疾病相关接口
Class DHCMed.FBDService.Service Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     pylian
/// CreatDate：   2020-08-04
/// Description:  To医生站食源性疾病强制或提示报卡接口
///               根据就诊号判断是否食源性疾病未上报患者
///               未上报,弹出食源性疾病报告卡,提示报卡
///               已上报,不提示报卡
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      
/// w ##class(DHCMed.FBDService.Service).CheckDiagnosToFBDNew("256","3","4","")
ClassMethod CheckDiagnosToFBDNew(aEpisodeID As %String, aDiagType As %String, aICDDxID As %String, aDiagNote As %String) As %String
{
	New (aEpisodeID,aDiagType,aICDDxID,aDiagNote,%session)
	Set return=""
	Quit:(aEpisodeID="")||(aDiagType="")||((aICDDxID="")&&(aDiagNote="")) return
	Set Languages = "CH"
	if ($d(%session)){
		set langid=+$g(%session.Data("LOGON.LANGID"))
		s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}	
		
	Set $ZT="CheckDiagnosToFBDNewErr"
	Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRAdm="" return
	Set txtCare = "为食源性疾病,请及时上报"	
	Set txtCare = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,txtCare)	
	
	Set Age=0
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Set BirthDay=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
	Set:BirthDay'="" Age=((+$h)-BirthDay)\365
	
	Set AdmLoc=+$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set HospID=+$p($g(^CTLOC(+AdmLoc)),"^",22)
	//初诊(A)、复诊(R)标记
	Set AdmReadm=$p($g(^PAADM(+aEpisodeID)),"^",56)
	
	//ICD或关键字监控是否食源性疾病
	Set ICD10=$p($g(^MRC("ID",+aICDDxID)),"^",4)
	Set ICDDesc=$p($g(^MRC("ID",+aICDDxID)),"^",2)
	Set:aDiagNote'="" ICDDesc=ICDDesc_" "_aDiagNote
	
	Set DTYPCode = $p(^MRC("DTYP",aDiagType),"^",1)					//诊断类型Code
	Set DTYPDesc = $p(^MRC("DTYP",aDiagType),"^",2)					//诊断类型Desc
	Quit:DTYPDesc="出院诊断" return //出院诊断不做检查
	
    Set CtlRstList=""
	Set ProductID=+##class(DHCMed.SS.Products).GetIDByCode("FBD")
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
	    
			//1通过食源性疾病诊断ICD检索是否食源性疾病
			If ((DisICD'="")&&(ICD10[DisICD)) {	
				Set NeedRepFlg=1
				Set CtlRstList=CtlRstList_$lb(xID)
			}
		
			//2通过ICD检索是否食源性疾病(检索ICD维护在疾病ICD表中)
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
		    
			//3通过关键字检索是否食源性疾病(检索关键字维护在别名表中)
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
  
	//已上报列表
	Set DiagnosList=..getFBDList(aEpisodeID)
	Set RetCode="",RetDesc=""
	For IFIndex=1:1:$listlength(CtlRstList) {
		Continue:IFIndex=""
		Quit:return'=""
		
		Set DiseaseID=$list(CtlRstList,IFIndex)
		Set objDisease=##class(DHCMed.SS.Disease).GetObjById(DiseaseID)
		Continue:'$IsObject(objDisease)
		Set xICD10 =objDisease.IDICD10
		Set xIDDesc =objDisease.IDDesc
		Continue:($listfind(DiagnosList,DiseaseID)>0)  //本次就诊已报不再提示
		Set ICDDesc = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Disease","IDDesc",Languages,ICDDesc)
		
		Set RetDesc=ICDDesc_","_txtCare_"!"	
		Set return=return_"^"_DiseaseID_"^"_RetDesc
	}
	
	Quit return
	
CheckDiagnosToFBDNewErr
	Quit ""
}

/// Creator：     pylian
/// CreatDate：   2019-01-14
/// Description:  To医生站食源性疾病强制或提示报卡接口
///               根据就诊号判断是否食源性疾病未上报患者
///               未上报,弹出食源性疾病报告卡,提示报卡
///               已上报,弹出食源性疾病报告卡,提示重复报卡
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      
/// w ##class(DHCMed.FBDService.Service).CheckDiagnosToFBD("736","736||7")
ClassMethod CheckDiagnosToFBD(aEpisodeID As %String, aMRDiagnos As %String) As %String
{
	New (aEpisodeID,aMRDiagnos)
	Set return=""
	Quit:(aEpisodeID="")||(aMRDiagnos="") return
	
	Set $ZT="CheckDiagnosToEpdErr"
	Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRAdm="" return
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
    
	Set AdmLoc=+$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set HospID=+$p($g(^CTLOC(+AdmLoc)),"^",22)
	//初诊(A)、复诊(R)标记
	Set AdmReadm=$p($g(^PAADM(+aEpisodeID)),"^",56)

	//ICD或关键字监控是否食源性疾病
	Set MRDiagnos=+$p(aMRDiagnos,"||",2)
	Set ICDDxID=$p($g(^MR(MRAdm,"DIA",MRDiagnos)),"^",1)
	Set ICD10=$p($g(^MRC("ID",+ICDDxID)),"^",4)
	Set ICDDesc=$p($g(^MRC("ID",+ICDDxID)),"^",2)
	Set ICDDES=$g(^MR(MRAdm,"DIA",MRDiagnos,"DES",1))
	Set ICDDHC=$g(^MR(MRAdm,"DIA",MRDiagnos,"DHC",1))
	Set DiagPrefix=$p($g(^MR(MRAdm,"DIA",MRDiagnos,1)),"^",26)    //诊断前缀 add 2020-09-17
	Set:DiagPrefix'="" ICDDesc=DiagPrefix_" "_ICDDesc
	
	Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
	Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
	
	Set DiagTypeID = $o(^MR(MRAdm,"DIA",MRDiagnos,"TYP",""),-1)		//诊断类型ID
	Quit:(+DiagTypeID=0) return
	Set TypeRowID = $g(^MR(MRAdm,"DIA",MRDiagnos,"TYP",DiagTypeID))
	Set DTYPCode = $p(^MRC("DTYP",TypeRowID),"^",1)					//诊断类型Code
	Set DTYPDesc = $p(^MRC("DTYP",TypeRowID),"^",2)					//诊断类型Desc
	Quit:DTYPDesc="出院诊断" return //出院诊断不做检查

    Set CtlRstList=""
	Set ProductID=+##class(DHCMed.SS.Products).GetIDByCode("FBD")
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
	    
			//1通过食源性疾病诊断ICD检索是否食源性疾病
			If ((DisICD'="")&&(ICD10[DisICD)) {	
				Set NeedRepFlg=1
				Set CtlRstList=CtlRstList_$lb(xID)
			}
		
			//2通过ICD检索是否食源性疾病(检索ICD维护在疾病ICD表中)
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
		    
			//3通过关键字检索是否食源性疾病(检索关键字维护在别名表中)
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
  
	//已上报列表
	Set DiagnosList=..getFBDList(aEpisodeID)

	Set RetCode="",RetDesc=""
	For IFIndex=1:1:$listlength(CtlRstList) {
		Quit:return'=""
		
		Set DiseaseID=$list(CtlRstList,IFIndex)
		Set objDisease=##class(DHCMed.SS.Disease).GetObjById(DiseaseID)
		Quit:'$IsObject(objDisease)
		Set xICD10 =objDisease.IDICD10
		Set xIDDesc =objDisease.IDDesc
		
		Set RetDesc=""
		If ($listfind(DiagnosList,DiseaseID) > 0) {
			Set RetCode=0    //提示重复报卡 
			Set RetDesc=ICDDesc_",本次就诊此类食源性疾病已上报过,无需重复上报,您确认需要重复上报吗?"
		}Else{
			Set RetCode=1    //提示报卡
			Set RetDesc=ICDDesc_",为食源性疾病,请及时上报!"	
		}
		
		Continue:RetDesc=""
		Set return=return_RetCode_"^"_DiseaseID_"^"_RetDesc
	}
	
	Quit return
	
CheckDiagnosToEpdErr
	Quit ""
}

/// Creator：     pylian
/// CreatDate：   2019-01-14
/// Description:  To医生站食源性疾病强制未报卡删除诊断接口
/// Table：       
/// Input：       EpisodeID:    User.PAADM
///               MRDiagnosID:  User.MRDiagons
/// Return：      
/// w ##class(DHCMed.FBDService.Service).DeleteDiagnosToFBD(4374)
ClassMethod DeleteDiagnosToFBD(aEpisodeID As %String, aMRDiagnosID As %String) As %String
{
	New (aEpisodeID,aMRDiagnosID)
	Set return=-1
	Quit:(aEpisodeID="")||(aMRDiagnosID="") return
	
	If aMRDiagnosID'="" {
		Set MRAdm=+$p(aMRDiagnosID,"||",1)
		Set ChildSub=+$p(aMRDiagnosID,"||",2)
		Quit:(+ChildSub=0)||(+MRAdm=0) return
	}Else{
		Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)
		Quit:MRAdm="" return
		Set ChildSub=$o(^MR(MRAdm,"DIA",""),-1)
		Quit:(+ChildSub=0) return
	}
	&SQL(DELETE FROM SQLUser.MR_Diagnos WHERE MRDIA_MRADM_ParRef=:MRAdm AND MRDIA_Childsub=:ChildSub)
	Quit SQLCODE
}

/// Creator：     pylian
/// CreatDate：   2019-01-18
/// Description:  取患者食源性疾病列表
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      %List
/// w ##class(DHCMed.FBDService.Service).getFBDList(4374)
ClassMethod getFBDList(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:PatientID="" return
	
	Set DiagnosList=""
	Set xID=""
	For {
		Set xID=$o(^DHCMed.FBD.ReportI("IndexEpisodeID"," "_$ZCVT(aEpisodeID,"U"),xID),-1)
		Quit:(xID="")
		Set objReport=##class(DHCMed.FBD.Report).GetObjById(xID)
		Continue:'$IsObject(objReport)
		
		Set (StatusID,StatusCode,StatusDesc)=""
		Set StatusDr=objReport.FRStatusDr
		If $IsObject(StatusDr) {
			Set StatusID=StatusDr.%Id()
			Set StatusCode=StatusDr.Code
			Set StatusDesc=StatusDr.Description
		}
		Continue:StatusCode="4" //草稿状态报告无效
		Continue:StatusCode="5" //删除状态报告无效
		Set (DiseaseID,DiseaseDesc)=""
		Set DiseaseDr=objReport.FRDiseaseDr
		If $IsObject(DiseaseDr) {
			Set DiseaseID=DiseaseDr.%Id()
			Set DiseaseDesc=DiseaseDr.IDDesc
		}
		
		Continue:$listfind(DiagnosList,DiseaseID)>0   //重复报卡过滤
		Set DiagnosList=DiagnosList_$lb(DiseaseID)
	}
	
	Set return=DiagnosList
	Quit return
}

/// Creator：     yukai
/// CreatDate：   2019-01-26
/// Description:  食源性疾病未审核报告查询
/// Table：       DHCMed.FBDService.Service
/// Input：       aDateFrom : 开始日期
///               aDateTo   : 开始日期
/// Return：      返回String
/// w ##class(DHCMed.FBDService.Service).GetUnChkFBDReportCnt("2019-03-14","2019-06-20")
/// w ##class(DHCMed.FBDService.Service).GetUnChkFBDReportCnt("","")
ClassMethod GetUnChkFBDReportCnt(aDateFrom As %String, aDateTo As %String, aLoc As %String = "") As %String
{
	New (aDateFrom,aDateTo,aLoc)
	Set return=0
	Set Cnt=0
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom="" aDateFrom=$p($h,",",1)-30
	Set:aDateTo="" aDateTo=$p($h,",",1)
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK
	
	Set aHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(aLoc,"FBD")
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.FBD.ReportI("IndexReportDate",xDate))
		Quit:(xDate="")||(xDate>aDateTo)
		Set xTime=0
		For{
			Set xTime=$o(^DHCMed.FBD.ReportI("IndexReportDate",xDate,xTime))
			Quit:xTime=""
			Set xReportID=0
			For {
				Set xReportID=$o(^DHCMed.FBD.ReportI("IndexReportDate",xDate,xTime,xReportID))
				Quit:xReportID=""
				Set objReport=##class(DHCMed.FBD.Report).GetObjById(xReportID)
				Continue:'$IsObject(objReport) 
				If (aHospCode'=""){
		    		Set flag=##class(DHCMed.SSService.HospitalSrv).CheckIsHosp(aHospCode,objReport.FREpisodeID,"FBD")
		    		continue:flag<1
		   		 }
				Set ReportStatus=objReport.FRStatusDr.Description
				continue:ReportStatus="作废"
				Set:ReportStatus="待审" Cnt=Cnt+1
				}
			}
		}
		Set:Cnt'="" return=Cnt
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-09-19
/// Description:  根据参数配置获取字典
/// Table：       
/// Input：       
/// Return：      %String
/// w ##class(DHCMed.FBDService.Service).GetDictionary("GetAreaInfo!!FBD-InitAddressByLocalHospital")
ClassMethod GetDictionary(aConfigList As %String) As %String
{
	New (aConfigList,%session)
	Set return=""
	Set Method = $p(aConfigList,"!!",1)
	Set Config = $p(aConfigList,"!!",2)
	Set Dictionary = $p(aConfigList,"!!",3)
	Set HospID=""
	Set:$d(%session) HospID=%session.Get("LOGON.HOSPID")
	Set DataValue= ""
	//基础字典
	If Method="GetDictionary" {
		Set DicCode=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp(Config,HospID)
		Set objDic=##class(DHCMed.SS.Dictionary).GetByTypeCode(Dictionary,DicCode,1)
		If $IsObject(objDic){
			Set DataValue=objDic.%Id()_"^"_objDic.Code_"^"_objDic.Description
		}
	} ElseIf Method="GetAreaInfo" {  //省市详细
		Set AreaIds=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp(Config,HospID)
		Quit:AreaIds="" return
		For indA=1:1:$l(AreaIds,"`") {
			Set tAreaId=+$p(AreaIds,"`",indA)
			Set tAreaDesc=##class(DHCMed.SS.AreaDic).GetShordDescById(tAreaId)
			If DataValue'="" {
				Set DataValue=DataValue_"`"_tAreaId_"^"_tAreaDesc
			} Else {
				Set DataValue=tAreaId_"^"_tAreaDesc
			}
		}
	} Else {
		Set DataValue=""
	}
	Set return = DataValue
	
	Quit return
}

}
