/// 名称: DHCMed.CDService.Service
/// 描述: 慢病报告基础服务
/// 编写者：jiangpengpeng
/// 编写日期: 2015-08-31
Class DHCMed.CDService.Service Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-16
/// Description:  生成报卡编号(YYYYTTNNNN)
/// Input：       RepType
/// Return：      
/// w ##class(DHCMed.CDService.Service).GetNewRepNo("ZLK")
ClassMethod GetNewRepNo(RepType As %String) As %String
{
	New (RepType)
	Set return=""
	Quit:RepType="" return
	
	Set YearCurr=$p($zd(+$H,3),"-",1)
	Set YearLast=$g(^DHCMed.CD.CRReportNo("YearLast"))
	If (YearCurr'=YearLast) {
		Kill ^DHCMed.CD.CRReportNo(RepType)
		Set ^DHCMed.CD.CRReportNo("YearLast")=YearCurr
	}
	
	Set return="-1^无相应报卡类型"
	Set NoHead=..GetTypeNo(RepType)
	Quit:NoHead="" return
	Set NoHead=YearCurr_NoHead
	
	Set RepNo=""
	Set NumCurr=$i(^DHCMed.CD.CRReportNo(RepType))
	Set NoLen=4
	if NoLen>$l(NumCurr) {
		set $p(RepNo,"0",NoLen+1-$l(NumCurr))=NumCurr
	} else {
		set RepNo=NumCurr
	}
	Set ^DHCMed.CD.CRReportNo(RepType)=NumCurr
	Set NewRepNo=NoHead_RepNo
	Set return=NewRepNo
	Quit return
}

/// Creator：     jiangpengpeng
/// CreatDate：   2015-09-16
/// Description:  取报卡类型编号
/// Input：       RepType
/// Return：
/// w ##class(DHCMed.CDService.Service).GetTypeNo("ZLK")
ClassMethod GetTypeNo(RepType As %String) As %String
{
	New (RepType)
	Set return=""
	Quit:RepType="" return
	
	Set TypeNoLB=$lb("ZLK","01")
	Set TypeNoLB=TypeNoLB_$lb("XNXG","02")
	Set TypeNoLB=TypeNoLB_$lb("TNB","03")
	Set TypeNoLB=TypeNoLB_$lb("GWZS","04")
	Set TypeNoLB=TypeNoLB_$lb("NYZD","05")
	Set TypeNoLB=TypeNoLB_$lb("YSZYB","06")
	Set TypeNoLB=TypeNoLB_$lb("SHK","07")
	Set TypeNoLB=TypeNoLB_$lb("FZYCO","08")
	Set TypeNoLB=TypeNoLB_$lb("GXY","09")
	Set TypeNoLB=TypeNoLB_$lb("MBBK","10")
	Set TypeNoLB=TypeNoLB_$lb("CSQX","11")
	Set TypeNoLB=TypeNoLB_$lb("ETSH","12")
	
	Set ind=$ListFind(TypeNoLB,RepType)
	Quit:ind<1 return
	Set TypeNo=$List(TypeNoLB,ind+1)
	Set return=TypeNo
	Quit return
}

/// Creator:		maxp
/// CreatDate:		2016-04-10
/// Description:	取报告的状态
/// Input:			ReportID
/// Return:			StatusCode
/// w ##class(DHCMed.CDService.Service).GetReportStatus(1)
ClassMethod GetReportStatus(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Quit:aReportID="" return
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(+aReportID)
	Quit:'$IsObject(objRep) return

	Set RepStatusID=objRep.CRReportStatus.%Id()
	Set RepStatusCode=objRep.CRReportStatus.Code
	
	Set return=RepStatusCode
	
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-08-14
/// Description:  To医生站慢性非传染性疾病强制或提示报卡接口
///               根据就诊号判断是否慢性非传染性疾病未上报患者
///               未上报,弹出慢性非传染性疾病报告卡强制报卡
///               已上报,本次就诊已报，不提示报卡，超出上报期限弹出报告卡,强制报卡
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      
/// w ##class(DHCMed.CDService.Service).CheckDiagnosToCD("43","3","4178","")
ClassMethod CheckDiagnosToCD(aEpisodeID As %String, aDiagType As %String, aICDDxID As %String, aDiagNote As %String) As %String
{
	New (aEpisodeID,aDiagType,aICDDxID,aDiagNote)
	Set return=""
	Quit:(aEpisodeID="")||(aDiagType="")||((aICDDxID="")&&(aDiagNote="")) return
		
	Set $ZT="CheckDiagnosToCDErr"
	Set MRAdm=$p($g(^PAADM(+aEpisodeID)),"^",61)
	Quit:MRAdm="" return
	Set AdmType = $p($g(^PAADM(+aEpisodeID)),"^",2)
	If AdmType="I" {
		Set RepTypeList=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SSClinRepToAdmIP","")
	} ElseIf AdmType="O" {
		Set RepTypeList=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SSClinRepToAdmOP","")
	} ElseIf AdmType="E" {
		Set RepTypeList=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHosp("SSClinRepToAdmEP","")
	} Else {
		Set RepTypeList=""
	}
	Quit:RepTypeList'["CD" return
	Set Age=0
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Set BirthDay=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
	Set:BirthDay'="" Age=((+$h)-BirthDay)\365
	
	Set AdmLoc=+$p($g(^PAADM(+aEpisodeID)),"^",4)
	Set HospID=+$p($g(^CTLOC(+AdmLoc)),"^",22)
	//初诊(A)、复诊(R)标记
	Set AdmReadm=$p($g(^PAADM(+aEpisodeID)),"^",56)
	
	//ICD或关键字监控是否慢性非传染性疾病
	Set ICD10=$p($g(^MRC("ID",+aICDDxID)),"^",4)
	Set ICDDesc=$p($g(^MRC("ID",+aICDDxID)),"^",2)
	Set:aDiagNote'="" ICDDesc=ICDDesc_" "_aDiagNote
	
	Set AdmType=$p($g(^PAADM(+aEpisodeID)),"^",2)  //就诊类型
	Set DTYPCode = $p(^MRC("DTYP",aDiagType),"^",1)					//诊断类型Code
	Set DTYPDesc = $p(^MRC("DTYP",aDiagType),"^",2)					//诊断类型Desc
	Quit:DTYPDesc="出院诊断" return //出院诊断不做检查
	Set CDAdmType=##class(DHCMed.SS.Config).GetValueByKeyHosp("CDAdmType")  //首次就诊强制报卡就诊类型
	Set ForceType=##class(DHCMed.SS.Config).GetValueByKeyHosp("FirstVisitForceType")  //首次就诊强制报卡报卡类型
	
    Set CtlRstList=""
	Set ProductID=+##class(DHCMed.SS.Products).GetIDByCode("CD")
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
	        Continue:(DisICD["J")  // 过滤掉慢阻肺诊断的慢病疾病
	        
			//1通过慢性非传染性疾病诊断ICD检索是否慢性非传染性疾病
			If ((DisICD'="")&&(ICD10[DisICD)) {	
				Set NeedRepFlg=1
				Set CtlRstList=CtlRstList_$lb(xID)
			}
		
			//2通过ICD检索是否慢性非传染性疾病(检索ICD维护在疾病ICD表中)
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
		    
			//3通过关键字检索是否慢性非传染性疾病(检索关键字维护在别名表中)
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

	Set ThisTimeList=..getCDThisTimeList(aEpisodeID)  //本次就诊慢性非传染性疾病列表
	Set HistoryList=..getCDHistoryList(aEpisodeID)    //除本次就诊外历史就诊已上报慢性非传染性疾病列表
	
	Set RetCode="",RetDesc=""
	For IFIndex=1:1:$listlength(CtlRstList) {
		Continue:IFIndex=""
		Quit:return'=""
		
		Set DiseaseID=$list(CtlRstList,IFIndex)
		Set objDisease=##class(DHCMed.SS.Disease).GetObjById(DiseaseID)
		Continue:'$IsObject(objDisease)
		Continue:'$IsObject(objDisease.IDCateDr)
		Set ICD10 =objDisease.IDICD10
		Set IDDesc =objDisease.IDDesc
		Set CateCode =objDisease.IDCateDr.Code
		Set CateDesc =objDisease.IDCateDr.Description
		Set:CateDesc="" CateDesc="慢性非传染性疾病"
		Continue:($listfind(ThisTimeList,CateCode)>0)  //本次就诊已报告的类型不重复提示
		If ($listfind(HistoryList,CateCode)>0) {  //历史就诊已报告
			Set RetCode=0
			Set (ReportID,RepTypeCode,RepTypeDesc,Content,ReportDate)=""
			For ind=1:1:$ll(HistoryList) {
				Set ReportList=$lg(HistoryList,ind)
				Continue:(ReportList="")||(ReportList'[CateCode)
				Continue:($l(ReportList,"^")'=5)
				Set ReportID = $p(ReportList,"^",1)
				Set RepTypeCode = $p(ReportList,"^",2)
				Set RepTypeDesc = $tr($p(ReportList,"^",3),"报卡","")
				Set Content = $p(ReportList,"^",4)
				Set ReportDate =$p(ReportList,"^",5)
				Quit:ReportID'=""
			}
			Set ReportList="<font style='color:blue'>("_"报告ID："_ReportID_" 报告类型："_RepTypeDesc_" 诊断类型："_Content_" 报告日期："_ReportDate_")</font>"
			Set RetDesc=ICDDesc_"，为"_CateDesc_"，最近一次报告信息:"_ReportList_"，请确认是否再次上报相同报告类型的报告卡?"	
		}Else {
			If (CDAdmType'[AdmType) ||(ForceType'[CateCode){ //就诊类型无需强制报告的报告/首次就诊无需强制报告的报告
				Set RetCode=0
				Set RetDesc=ICDDesc_"，为"_CateDesc_"，请确认是否上报相关报告卡？"
			}Else {
				Set RetCode=1
				Set Info="<span style='font-weight:600;'><font style='color:red;'></br>注意：先保存对应的报告，否则不允许保存诊断！</font></span>"
				Set RetDesc=ICDDesc_"，为"_CateDesc_"，请及时上报!"_Info
			}	
		}
		Set return=return_RetCode_"^"_DiseaseID_"^"_CateCode_"^"_CateDesc_"^"_RetDesc
	}
	
	Quit return
	
CheckDiagnosToCDErr
	Quit ""
}

/// Creator：     pylian
/// CreatDate：   2020-08-14
/// Description:  取患者本次就诊慢性非传染性疾病分类列表
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      %List
/// w ##class(DHCMed.CDService.Service).getCDThisTimeList(43)
ClassMethod getCDThisTimeList(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return

	Set DiagnosList=""
	Set xRepID=""
	For {
		Set xRepID=$o(^DHCMed.CD.CRReportI("IndexEpisodeID"," "_aEpisodeID,xRepID),-1)
		Quit:xRepID=""
		Set objRep=##Class(DHCMed.CD.CRReport).GetObjById(xRepID)
		Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.CRReportStatus)
		Continue:'$IsObject(objRep.CRReportType)
		Continue:objRep.CRReportStatus.Code="3"   //删除状态报告无效
		Set ReportDate=objRep.CRReportDate
		Set RepTypeCode=objRep.CRReportType.CRFCode
		Set RepTypeDesc=objRep.CRReportType.CRFDesc
	
		Continue:$listfind(DiagnosList,RepTypeCode)>0   //重复报卡过滤
		Set DiagnosList=DiagnosList_$lb(RepTypeCode)
	}	
	Set return=DiagnosList
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-08-14
/// Description:  取患者除本次就诊外的历史就诊慢性非传染性疾病分类列表
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      %List
/// w ##class(DHCMed.CDService.Service).getCDHistoryList(aEpisodeID)
ClassMethod getCDHistoryList(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set PatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:PatientID="" return
	
	Set DiagnosList="",LastDiagList=""	
	Set AdmType=""
	For {
		Set AdmType=$o(^PAPERdr(PatientID,"ADM",AdmType))
		Quit:AdmType=""
		
		Set Paadm=0
		For {
			Set Paadm=$o(^PAPERdr(PatientID,"ADM",AdmType,Paadm))
			Quit:Paadm=""
			Set VisitStatus=$p($g(^PAADM(Paadm)),"^",20)
			Continue:VisitStatus="C"  //取消就诊
			Continue:Paadm=aEpisodeID   //本次就诊不计入
			
			Set xRepID=""
			For {
				Set xRepID=$o(^DHCMed.CD.CRReportI("IndexEpisodeID"," "_Paadm,xRepID),-1)
				Quit:xRepID=""
				Set objRep=##Class(DHCMed.CD.CRReport).GetObjById(xRepID)
				Continue:'$IsObject(objRep)
				Continue:'$IsObject(objRep.CRReportStatus)
				Continue:'$IsObject(objRep.CRReportType)
				Continue:objRep.CRReportStatus.Code="3"   //删除状态报告无效
				Set ReportDate=objRep.CRReportDate
				Set:ReportDate'="" ReportDate=$zd(ReportDate,3)
				Set RepTypeCode=objRep.CRReportType.CRFCode
				Set RepTypeDesc=objRep.CRReportType.CRFDesc
				
				Set Content=""
			   	If (RepTypeCode="ZLK") {
					Set objChild=##class(DHCMed.CD.CRReportZLK).GetObjByParRef(xRepID)
					Continue:'$IsObject(objChild) 
					Set Content =objChild.CRZDBW   //肿瘤报告判断诊断部位
				} ElseIf (RepTypeCode="XNXG") {
					Set objChild=##class(DHCMed.CD.CRReportXNXG).GetObjByParRef(xRepID)
					Continue:'$IsObject(objChild) 
					Set Content =objChild.CRZDMC   //心脑血管报卡判断诊断类型
				}ElseIf (RepTypeCode="TNB") {
					Set objChild=##class(DHCMed.CD.CRReportTNB).GetObjByParRef(xRepID)
					Continue:'$IsObject(objChild) 
					Continue:'$IsObject(objChild.CRZDLX) 
					Set Content =objChild.CRZDLX.Code   //糖尿病报卡判断诊断类型
				}ElseIf (RepTypeCode="MBBK") { //四种疾病报卡判断诊断类型(四种报告单独报卡可以区分)
					Set objChild=##class(DHCMed.CD.CRReportMBBK).GetObjByParRef(xRepID)
					Continue:'$IsObject(objChild) 
				}
				Set DiagList = RepTypeCode
				Set ReportList = xRepID_"^"_RepTypeCode_"^"_RepTypeDesc_"^"_Content_"^"_ReportDate
				Set LastDiagList=LastDiagList_$lb(ReportList)

				Continue:$listfind(DiagnosList,DiagList)>0   //重复报卡过滤
				Set DiagnosList=DiagnosList_$lb(DiagList)
			}		
		}
	}
	Set return=DiagnosList_LastDiagList
	Quit return
}

/// w ##class(DHCMed.SSService.DiseaseSrv).CheckMRDiagnos("CD","12810423||18")
/// w ##class(DHCMed.CDService.Service).CheckMRDiagnos("CD","4||13")
ClassMethod CheckMRDiagnos(aProCode As %String, aMRDiagnosID As %String) As %String
{
	New (aProCode,aMRDiagnosID)
	Set return=""
	Quit:(aProCode="")||(aMRDiagnosID="") return
	
	
	Set DiagnosDescList="",CtlRstList=""
	s ^XXX=aMRDiagnosID
	Set MRAdm=$p(aMRDiagnosID,"||",1)
	Set SubID=$p(aMRDiagnosID,"||",2)
	Quit:(MRAdm="")||(SubID="") return
	
	Set ProductID=##class(DHCMed.SS.Products).GetIDByCode(aProCode)
	Quit:ProductID="" return
		
	
	Set ICDDxID=$p($g(^MR(MRAdm,"DIA",SubID)),"^",1)
	Quit:ICDDxID="" return
	Set ICD10=$p($g(^MRC("ID",+ICDDxID)),"^",4)
	Set ICDDesc=$p($g(^MRC("ID",+ICDDxID)),"^",2)
	Set ICDDES=$g(^MR(MRAdm,"DIA",ICDDxID,"DES",1))
	Set ICDDHC=$g(^MR(MRAdm,"DIA",ICDDxID,"DHC",1))
	Set DiagPrefix=$p($g(^MR(MRAdm,"DIA",SubID,1)),"^",26)    //诊断前缀 add 2020-09-17
	Set:DiagPrefix'="" ICDDesc=DiagPrefix_" "_ICDDesc
	Set:ICDDES'="" ICDDesc=ICDDesc_" "_ICDDES
	Set:ICDDHC'="" ICDDesc=ICDDesc_" "_ICDDHC
	
	Set EpisodeID=$p($g(^MR(+MRAdm,"PRO",1)),"^",9)
	Quit:EpisodeID="" return

	Set xDiaCode=""
	For {
		Set xDiaCode=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductID,xDiaCode))
		Quit:xDiaCode="" 
	
		
		Set xID=0
		For {
			Set xID=$o(^DHCMed.SS.DiseaseI("IndexCode",ProductID,xDiaCode,xID))
			Quit:xID=""
			Set objDisease=##class(DHCMed.SS.Disease).GetObjById(xID)
			Quit:'$IsObject(objDisease)
			set Product=objDisease.IDProductDr
			
			continue:'$isobject(Product)
			continue:Product.ProCode'="CD"
			
			Set xICD10 =objDisease.IDICD10
			Set xIDDesc10 =objDisease.IDDesc
			Continue:$listfind(CtlRstList,xICD10)>0
			
			//1通过慢性疾病诊断ICD检索是否慢性疾病
			Set:ICD10=xICD10 CtlRstList=CtlRstList_$lb(xID)
			//2通过关键字检索是否慢性疾病(检索关键字维护在别名表中,类型为1)
			Set xAliaSubID = ""
			For {
				Set xAliaSubID=$o(^DHCMed.SS.DiseaseD(xID,"A",xAliaSubID))
				Quit:xAliaSubID=""
				
				
				Set objDisease=##class(DHCMed.SS.Disease).GetObjById(xID)
				Quit:'$IsObject(objDisease)
				set Product=objDisease.IDProductDr
				continue:'$isobject(Product)
				continue:Product.ProCode'="CD"
		
				Set ID=xID_"||"_xAliaSubID
				Set objAlias=##class(DHCMed.SS.DiseaseAlias).GetObjById(ID)
				Continue:'$IsObject(objAlias)
				Set IDAlias=objAlias.IDAlias
				Continue:($ZConvert(ICDDesc,"T")'[$ZConvert(IDAlias,"T"))
				Set CtlRstList=CtlRstList_$lb(xID)
			}
			//3通过ICD检索是否慢性疾病(检索ICD维护在疾病ICD表中,类型为2)
			Set xICDSubID = ""
			For {
				Set xICDSubID=$o(^DHCMed.SS.DiseaseD(xID,"I",xICDSubID))
				Quit:xICDSubID=""
				Set objDisease=##class(DHCMed.SS.Disease).GetObjById(xID)
				Quit:'$IsObject(objDisease)
				set Product=objDisease.IDProductDr
				continue:'$isobject(Product)
				continue:Product.ProCode'="CD"
		
				Set ID=xID_"||"_xICDSubID
				Set objICD=##class(DHCMed.SS.DiseaseICD).GetObjById(ID)
				Continue:'$IsObject(objICD)
				Set IDICD10=objICD.IDICD10
				Set tICDDesc=objDisease.IDDesc
				Set tCateDesc=objDisease.IDCateDr.Description
				
				Set IDICDDesc=objICD.IDICDDesc
				Set IDExWords=objICD.IDExWords
			
				Set:ICD10=IDICD10 CtlRstList=CtlRstList_$lb(xID)
			}	
				
		}
		
	}
	
	Set DiagnosList=""
	Set DiagnosTypeList=""
	//Set DiagnosDescList=DiagnosList
	Set RetCode="",RetDesc=""
	For IFIndex=1:1:$listlength(CtlRstList) {
		Quit:return'=""
		
		Set DiseaseID=$list(CtlRstList,IFIndex)
		Set objDisease=##class(DHCMed.SS.Disease).GetObjById(DiseaseID)
		
		Quit:'$IsObject(objDisease)
		Set xICD10 =objDisease.IDICD10
		Set xICDDesc =objDisease.IDDesc
		Set tCateDesc=objDisease.IDCateDr.Description
		Set tCateCode=objDisease.IDCateDr.Code
		Set RetDesc=""
		If tCateDesc="肿瘤"{
			Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
			Quit:PatientID="" 
			Set AdmType=""
			For {
				Set AdmType=$o(^PAPERdr(PatientID,"ADM",AdmType))
				Set CDAdmType=##class(DHCMed.SS.Config).GetValueByKeyHosp("CDAdmType")
				Quit:AdmType=""
				Continue:CDAdmType'[AdmType
				Set Paadm=0
				For {
					Set Paadm=$o(^PAPERdr(PatientID,"ADM",AdmType,Paadm))
					Quit:Paadm=""
					Set VisitStatus=$p($g(^PAADM(Paadm)),"^",20)
					Continue:VisitStatus="C"  
					Set xID=""
					For {
						Set xID=$o(^DHCMed.CD.CRReportI("IndexEpisodeID"," "_Paadm,xID),-1)
						Quit:(xID="")
						Set objReport=##class(DHCMed.CD.CRReport).GetObjById(xID)
						Continue:'$IsObject(objReport)
						Set DiseaseDesc=objReport.CRReportType.CRFDesc
						Set DiseaseCode=objReport.CRReportType.CRFCode
						Continue:DiseaseDesc'="肿瘤报卡"
						Set ReportDate=objReport.CRReportDate
						Set ZLIsActiveDate=##class(DHCMed.SS.Config).GetValueByKeyHosp("ZLKIsActiveDate")
						Continue:($p($h,",",1)-ZLIsActiveDate)>ReportDate
						Set objZLKReport=##class(DHCMed.CD.CRReportZLK).GetObjByParRef(xID)
						Continue:'$IsObject(objZLKReport)
						Set CZDICD=objZLKReport.CRZDICD
						Continue:$listfind(DiagnosList, CZDICD)>0   
						Set DiagnosList=DiagnosList_$lb(CZDICD)
					}
				}
			}
			If ($listfind(DiagnosList,xICD10) > 0) {
				Set RetCode=0    //提示报卡 
				Set RetDesc=xICDDesc_",此慢性疾病已上报过,无需重复上报,您确认需要重复上报吗?"
			}Else{
				Set RetCode=1    //强制报卡¨
				Set RetDesc=ICDDesc_",为慢性疾病,请及时上报!"	
			}
		}else{
			Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
			Quit:PatientID=""
			Set DiagnosList=""
			Set AdmType=""
			For {
				Set AdmType=$o(^PAPERdr(PatientID,"ADM",AdmType))
				Set CDAdmType=##class(DHCMed.SS.Config).GetValueByKeyHosp("CDAdmType")
				Quit:AdmType=""
				Continue:CDAdmType'[AdmType
				Set Paadm=0
				For {
					Set Paadm=$o(^PAPERdr(PatientID,"ADM",AdmType,Paadm))
					Quit:Paadm=""
					Set VisitStatus=$p($g(^PAADM(Paadm)),"^",20)
					Continue:VisitStatus="C" 
					Set xID=""
					For {
						Set xID=$o(^DHCMed.CD.CRReportI("IndexEpisodeID"," "_Paadm,xID),-1)
						Quit:(xID="")
						Set objReport=##class(DHCMed.CD.CRReport).GetObjById(xID)
						Continue:'$IsObject(objReport)
						Set DiseaseDr=objReport.CRReportType
						Set ReportDate=objReport.CRReportDate
						Set IsActiveDate=##class(DHCMed.SS.Config).GetValueByKeyHosp(tCateCode_"IsActiveDate")
						Continue:($p($h,",",1)-IsActiveDate)>ReportDate
						If $IsObject(DiseaseDr) {
							Set DiseaseID=DiseaseDr.%Id()
							If ((tCateDesc="冠心病")||(tCateDesc="脑卒中")){
								Set objXNXGReport=##class(DHCMed.CD.CRReportXNXG).GetObjByParRef(xID)
								Continue:'$IsObject(objXNXGReport)
								Set ZDMCFL=$p(objXNXGReport.CRZDMC,"-",2)
								}
							else{
								Set ZDMCFL=objReport.CRReportType.CRFCode
								}
							Continue:$listfind(DiagnosTypeList, ZDMCFL)>0   
							Set DiagnosTypeList=DiagnosTypeList_$lb(ZDMCFL)
						}
					}
				}
			}
			If ($listfind(DiagnosTypeList,tCateCode) > 0) {
				Set RetCode=0    //提示报卡 
				Set RetDesc=xICDDesc_",此慢性疾病已上报过,无需重复上报,您确认需要重复上报吗?"
			}Else{
				Set RetCode=1    //强制报卡¨
				Set RetDesc=ICDDesc_",为慢性疾病,请及时上报!"
			}	
			
		}
		
		Set RetDesc=$tr(RetDesc,";","")		
		Continue:RetDesc=""
		Set return=return_RetCode_"^"_DiseaseID_"^"_RetDesc_"^"_tCateDesc
	}
	
	Quit return
	
CheckDiagnosToEpdErr
	Quit ""
}

/// Creator：     yukai
/// CreatDate：   2019-01-26
/// Description:  慢病报告未审核数量
/// Table：       DHCMed.CDService.Service
/// Input：       aDateFrom : 开始日期
///               aDateTo   : 开始日期
/// Return：      返回String
/// w ##class(DHCMed.CDService.Service).GetUnChkCDReportCnt("2019-03-14","2019-06-20")
/// w ##class(DHCMed.CDService.Service).GetUnChkCDReportCnt("","")
ClassMethod GetUnChkCDReportCnt(aDateFrom As %String, aDateTo As %String, aLoc As %String = "") As %String
{
	New (aDateFrom,aDateTo,aLoc)
	Set return=""
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Set:aDateFrom="" aDateFrom=$p($h,",",1)-30
	Set:aDateTo="" aDateTo=$p($h,",",1)
	Quit:((aDateFrom="")||(aDateTo="")) $$$OK
	
	Set aHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCodeByLoc(aLoc,"CD")
	
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate))
		Quit:(xDate="")||(xDate>aDateTo)
		Set xLocID=0
		For{
			Set xLocID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLocID))
			Quit:xLocID=""
			Set xReportID=0
			For {
				Set xReportID=$o(^DHCMed.CD.CRReportI("IndexDateLoc",xDate,xLocID,xReportID))
				Quit:xReportID=""
				Set objReport=##class(DHCMed.CD.CRReport).GetObjById(xReportID)
				Continue:'$IsObject(objReport)
				If (aHospCode'=""){
		    		Set flag=##class(DHCMed.SSService.HospitalSrv).CheckIsHosp(aHospCode,objReport.CREpisodeID,"CD")
		    		Continue:flag<1
		   		}
				Set ReportType=objReport.CRReportType.CRFCode
				Continue:ReportType="" 
				Set ReportStatus=objReport.CRReportStatus.Description
				continue:(ReportStatus="删除")||(ReportStatus="作废")
				If ReportStatus="上报" {
					Set CDReport(ReportType)=+$g(CDReport(ReportType))+1
				}
			}
		}
	}
	
	If $d(return) {
		Set xReportType=""
		For {
			Set xReportType=$o(CDReport(xReportType))
			Quit:xReportType=""
			
			Set Cnt=+$g(CDReport(xReportType))
			Set return=return_"^"_xReportType_":"_Cnt
		}
		Set:return'="" return=$e(return,2,$l(return))
	}
	Quit return
}

/// Creator：     chenrui
/// CreatDate：   2022-04-14
/// Description:  获取报告状态描述
/// Input：       aICDDxID : ICD表的RowID
/// Return：      返回String
/// w ##class(DHCMed.CDService.Service).GetReportStatusDesc("1")
ClassMethod GetReportStatusDesc(aReportID As %String) As %String
{
	New (aReportID)
	Set return=""
	Set objRep=##class(DHCMed.CD.CRReport).GetObjById(aReportID)
	Quit:'$IsObject(objRep) return
	Set RepStatusDesc=objRep.CRReportStatus.Description
	Set return = RepStatusDesc
	
	Quit return
}

}
