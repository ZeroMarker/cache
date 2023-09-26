/// 名称:DHCMed.SSService.AutoTask
/// 描述: 疾病筛查 自动任务
/// 编写者：liuzhenhe
/// 编写日期: 2020-08-04
Class DHCMed.SSService.AutoTask Extends %RegisteredObject
{

/// 疾病筛查自动任务入口
/// w ##class(DHCMed.SSService.AutoTask).InitTask("2022-01-01","2022-09-30")
ClassMethod InitTask(aDateFrom As %String, aDateTo As %String) As %String
{
	Set ret="Error"
	Set ret1=..StartTask(aDateFrom,aDateTo,"","CD")
	Set ret2=..StartTask(aDateFrom,aDateTo,"","FBD")
	Set:(ret1_ret2'["Error") ret="OK"
	
	Quit ret
}

/// 疾病筛查入口
/// w ##class(DHCMed.SSService.AutoTask).StartTask("2022-01-01","2022-09-30","","FBD")
ClassMethod StartTask(aDateFrom As %String, aDateTo As %String, aEpisodeID As %String = "", aProductCode As %String = "") As %String
{
	Set $ZT="AutoTaskErr"
	//Quit:aProductCode="" "OK"
	if (aEpisodeID'=""){
		Write "EpisodeID="_aEpisodeID,!
		if (aProductCode=""){
			Do CheckMRDiagnos(aEpisodeID,"CD")
			Do CheckMRDiagnos(aEpisodeID,"FBD")
		}else{
			Do CheckMRDiagnos(aEpisodeID,aProductCode)
		}
		Quit "OK"
	}
	
	Set return=""
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") "OK"
	//记录执行任务日志
	Set Date=$zd(+$h,3),Time=$zt($p($h,",",2),1)
	Set YY=$p(Date,"-",1),MM=$p(Date,"-",2),DD=+$p(Date,"-",3) 
	Set NUM=$i(^DHCMed.SSService.AutoTask(YY_"-"_MM,DD))
	Set ^DHCMed.SSService.AutoTask(YY_"-"_MM,DD,NUM,"命令")="AutoTask("_aDateFrom_","_aDateTo_",,"_aProductCode_")"
	Set ^DHCMed.SSService.AutoTask(YY_"-"_MM,DD,NUM,"开始")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	
	//就诊列表
	Set arrEpisodeID=..GetAdmList(aDateFrom,aDateTo)
	Set Count=arrEpisodeID.Count()
	For indEpis=1:1:Count {
		Set xEpisodeID=arrEpisodeID.GetAt(indEpis)
		Continue:xEpisodeID=""

		Set ^DHCMed.SSService.AutoTask(YY_"-"_MM,DD,NUM,"计数")=indEpis_"/"_Count_"("_xEpisodeID_")"
		Write "EpisodeID="_xEpisodeID,!
		if (aProductCode=""){
			Do CheckMRDiagnos(xEpisodeID,"CD")
			Do CheckMRDiagnos(xEpisodeID,"FBD")
		}else{
			Do CheckMRDiagnos(xEpisodeID,aProductCode)
		}
		//Set ret = ##class(DHCMed.EPDService.AutoTask).GetCtrlResult(xEpisodeID,aDateFrom,aDateTo)			
	}
	
	//记录执行任务日志（成功标记）
	Set ^DHCMed.SSService.AutoTask(YY_"-"_MM,DD,NUM,"结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	Quit "OK"
AutoTaskErr
	//记录执行任务日志（失败标记）
	Set ^DHCMed.SSService.AutoTask(YY_"-"_MM,DD,NUM,"异常结束")=$zd(+$h,3)_" "_$zt($p($h,",",2),1)

	Quit "Error"
		
CheckMRDiagnos(EpisodeID,ProductCode)
	Set MRADMDR=$p($g(^PAADM(+EpisodeID)),"^",61)
	Quit:MRADMDR="" return
	Quit:'$d(^MR(MRADMDR,"DIA")) return
	Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
	Set AdmLoc=$p($g(^PAADM(+EpisodeID)),"^",4)
	Set AdmReadm=$p($g(^PAADM(+EpisodeID)),"^",56)
	Set:AdmReadm="" AdmReadm="A"
	Set ProductID=##class(DHCMed.SS.Products).GetIDByCode(ProductCode)
	Quit:ProductID=""
	Set CtlRstList=""

	kill tmpList
	///根据就诊号遍历诊断判断是否属于该疾病
	Set xSubID=0
	For {
		Set xSubID=$o(^MR(+MRADMDR,"DIA",xSubID))
		
		Quit:xSubID=""
		Set tmpDignos = $g(^MR(+MRADMDR,"DIA",xSubID))

		Continue:tmpDignos=""
		Set DiagDate = $p(tmpDignos,"^",19)
		Set DiagTime = $p(tmpDignos,"^",20)
	
		Continue:DiagDate=""
		
		Set ICDDR	= $p(tmpDignos,"^",1)
		Set ICD		= $p($g(^MRC("ID",+ICDDR)),"^",4)
		Set ICDDesc	= $p($g(^MRC("ID",+ICDDR)),"^",2)
		Set ICDDate	= $p(tmpDignos,"^",7)
		Set ICDTime	= $p(tmpDignos,"^",8)
		Set ICDDES=$g(^MR(MRADMDR,"DIA",xSubID,"DES",1))
		Set ICDDHC=$g(^MR(MRADMDR,"DIA",xSubID,"DHC",1))
		Set:(ICDDES'="")&&(ICDDES'=ICDDesc) ICDDesc=ICDDesc_" "_ICDDES
		Set:(ICDDHC'="")&&(ICDDHC'=ICDDesc) ICDDesc=ICDDesc_" "_ICDDHC
		
		Set CtlRstList=""
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
				If ((DisICD'="")&&(ICD[DisICD)) {	
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
			
					If (ICD[IDICD10)||($ZConvert(ICDDesc,"T")[$ZConvert(IDICDDesc,"T")) {
						Set NeedRepFlg=1
					}
					If (IDExWords'="") {  //排除关键字列表
				   		For ind=1:1:$l(IDExWords,"#") {
							Set xIDExWords=$p(IDExWords,"#",ind)
							Continue:xIDExWords=""
							Continue:UnNeedFlg=1
							Set UnNeedFlg=1
				
							Continue:((ICD[xIDExWords)||($ZConvert(ICDDesc,"T")[$ZConvert(xIDExWords,"T")))
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
		/// //一次就诊同一诊断只有一条疾病诊断
		for IFIndex=1:1:$listlength(CtlRstList){
			
			Set DiseaseID=$listGet(CtlRstList,IFIndex)
			Set objDisease=##class(DHCMed.SS.Disease).GetObjById(DiseaseID)
			Continue:'$IsObject(objDisease)
			Continue:objDisease.IDIsActive'=1
			Set ActDiagnosDesc=objDisease.IDDesc
			Set ActDiagnosCode=objDisease.IDCode
			Set RepTypeCode=""
			Set:$IsObject(objDisease.IDCateDr) RepTypeCode=objDisease.IDCateDr.Code
			Set (CXStatus,CXDiagnos,CXOpinion,CXEvalDate,CXEvalTime,CXEvalLoc,CXEvalUser)=""
			Set CasesXId=$o(^MA.SS.CasesXI("IndexActDiagnos",ProductCode,EpisodeID," "_$zcvt(DiseaseID,"U"),0))
			
			If CasesXId'="" {
				Set objCase=##class(DHCMed.SS.CasesX).GetObjById(CasesXId)
				If $IsObject(objCase) {
					Set CXStatus	= objCase.CXStatus
					//Set CXDiagnos	= objCase.CXDiagnos
					Set CXOpinion     = objCase.CXOpinion
					Set CXEvalDate    = objCase.CXEvalDate
					Set CXEvalTime    = objCase.CXEvalTime
					Set CXEvalLoc     = objCase.CXEvalLoc
					Set CXEvalUser    = objCase.CXEvalUser
				}
			}
			Set:CXStatus="" CXStatus="-1"
			If (ProductCode="CD")&&(RepTypeCode'=""){
				If $g(tmpList("CD",EpisodeID))=""{
					Set tmpList("CD",EpisodeID,"ThisTimeList")=..getCDThisTimeList(EpisodeID)  //本次就诊慢性非传染性疾病列表
					Set tmpList("CD",EpisodeID,"HistoryList")=..getCDHistoryList(EpisodeID)    //除本次就诊外历史就诊已上报慢性非传染性疾病列表
					Set tmpList("CD",EpisodeID)=1
				}
				Set ThisTimeList=$g(tmpList("CD",EpisodeID,"ThisTimeList"))
				Set HistoryList = $g(tmpList("CD",EpisodeID,"HistoryList"))
				//判断是否未操作，
				If (CXStatus="-1"){
					//之后判断是否上报，已上报自动确认
					Set:($listfind(ThisTimeList,RepTypeCode)>0) CXStatus="1"  //本次就诊已报告的类型自动确认
					Set:($listfind(HistoryList,RepTypeCode)>0) CXStatus="0"   //历史已报的自动排除
				}
			}ElseIf (ProductCode="FBD"){
				If $g(tmpList("FBD",EpisodeID))=""{
					Set tmpList("FBD",EpisodeID,"FBDList")=..getFBDList(EpisodeID)   //本次食源性疾病就诊列表
					Set tmpList("FBD",EpisodeID)=1
				}
				Set FBDList=$g(tmpList("FBD",EpisodeID,"FBDList"))
				If (CXStatus="-1"){
					Set:($listfind(FBDList,DiseaseID)>0) CXStatus="1"
				}
			}

			//更新病例筛查日志 
			Set inputStr=CasesXId
			Set inputStr=inputStr_"^"_ProductCode
			Set inputStr=inputStr_"^"_EpisodeID
			Set inputStr=inputStr_"^"_DiagDate
			Set inputStr=inputStr_"^"_DiagDate           //结果日期 
			Set inputStr=inputStr_"^"_AdmLoc
			Set inputStr=inputStr_"^"_DiseaseID          //疾病字典ID
			Set inputStr=inputStr_"^"_AdmReadm
			Set inputStr=inputStr_"^"_CXStatus
			Set:CXStatus'="1" DiseaseID=""
			Set inputStr=inputStr_"^"_DiseaseID
			Set inputStr=inputStr_"^"_CXOpinion
			Set inputStr=inputStr_"^"_CXEvalDate
			Set inputStr=inputStr_"^"_CXEvalTime
			Set inputStr=inputStr_"^"_CXEvalLoc
			Set inputStr=inputStr_"^"_CXEvalUser
			Set inputStr=inputStr_"^"_1
			Set inputStr=inputStr_"^"_""
			set flg=##class(DHCMed.SS.CasesX).Update(inputStr,"^")

			If (+flg)>0 {
				//保存筛查明细
				Set xDtlId = ""
				Set xDtlId=$o(^MA.SS.CasesXI("Dtl","IndexScreenDateTime",flg,"K",DiagDate,DiagTime,xDtlId))
				Set inputSub=flg
				Set inputSub=inputSub_"^"_xDtlId
				Set inputSub=inputSub_"^"_"K"
				Set inputSub=inputSub_"^"_"MRICD:"_MRADMDR_"||"_xSubID_"#"_ICD_"#"_ICDDesc
				Set inputSub=inputSub_"^"_DiagDate
				Set inputSub=inputSub_"^"_DiagTime
				Set inputSub=inputSub_"^"_1
				Set inputSub=inputSub_"^"_+$h
				Set inputSub=inputSub_"^"_$p($h,",",2)
				Set inputSub=inputSub_"^"_"" 
				Set inputSub=inputSub_"^"_MRADMDR_"||"_xSubID
			
				Set flg=##class(DHCMed.SS.CasesXDtl).Update(inputSub,"^")	
			}
			Quit
		}
	}
}

/// Creator：     pylian
/// CreatDate：   2019-02-02
/// Description:  就诊列表
/// Table：       PA_Adm
/// Input：       aDateFrom : 开始日期
/// Input：       aDateTo : 结束日期
/// Return：      返回String
/// w ##class(DHCMed.EPDService.AutoTask).GetAdmList("2019-01-01","2019-02-28")
ClassMethod GetAdmList(aDateFrom As %String, aDateTo As %String) As %Library.ArrayOfDataTypes
{
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set $ZT="GetAdmListErr"
  
    Set Count=0 
    //门、急诊患者
	For xDate=aDateFrom:1:aDateTo {
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAADMi("PAADM_AdmDate",xDate,xPaadm))
			Quit:xPaadm=""
			
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:($p(AdmInfo,"^",2)'="O")&&($p(AdmInfo,"^",2)'="E")      //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
			
			Set Count=Count+1
			Do return.SetAt(xPaadm,Count)
		}
	}
  
	//在院患者列表、急诊留观列表
	Set xWardID=""
	For {
		Set xWardID=$o(^PAADMi("CurrWard",xWardID))
		Quit:xWardID=""
		Set xRoomID=""
		For {
			Set xRoomID=$o(^PAADMi("CurrWard",xWardID,xRoomID))
			Quit:xRoomID=""
			Set xPaadm=""
			For {
				Set xPaadm=$o(^PAADMi("CurrWard",xWardID,xRoomID,xPaadm))
				Quit:xPaadm=""
				
				Set AdmInfo=$g(^PAADM(xPaadm))
				Continue:($p(AdmInfo,"^",2)'="I")&&($p(AdmInfo,"^",2)'="E")      //就诊类型过滤
				Continue:$p(AdmInfo,"^",20)="C"      //就诊状态过滤
			
				Set Count=Count+1
			    Do return.SetAt(xPaadm,Count)
			}
		}
	}
	
	//出院患者列表
	Set CurrDate=+$h
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  
	For xDate=aDateFrom:1:CurrDate {
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:($p(AdmInfo,"^",2)'="I")&&($p(AdmInfo,"^",2)'="E")      //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"         //就诊状态过滤
    		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(xPaadm)
    		Continue:$p(AdmDateTime,"^",1)>aDateTo   //就诊时间过滤
    		
			Set Count=Count+1
			Do return.SetAt(xPaadm,Count)
		}
	}
	
	Quit return
	
GetAdmListErr
	Do return.Clear()
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-08-14
/// Description:  取患者除本次就诊外的历史就诊慢性非传染性疾病分类列表
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      %List
ClassMethod getCDHistoryList(aEpisodeID As %String) As %String
{
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
				Continue:objRep.CRReportStatus.Code="2"   //删除状态报告无效
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
				Set ReportList = RepTypeCode  //xRepID_"^"_RepTypeCode_"^"_RepTypeDesc_"^"_Content_"^"_ReportDate
				Set LastDiagList=LastDiagList_$lb(ReportList)

				Continue:$listfind(DiagnosList,DiagList)>0   //重复报卡过滤
				Set DiagnosList=DiagnosList_$lb(DiagList)
			}		
		}
	}
	Set return=DiagnosList_LastDiagList
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2020-08-14
/// Description:  取患者本次就诊慢性非传染性疾病分类列表
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      %List
ClassMethod getCDThisTimeList(aEpisodeID As %String) As %String
{
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
		Continue:objRep.CRReportStatus.Code="2"   //删除状态报告无效
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
/// CreatDate：   2019-01-18
/// Description:  取患者食源性疾病列表
/// Table：       
/// Input：       EpisodeID:    User.PAADM
/// Return：      %List
ClassMethod getFBDList(aEpisodeID As %String) As %String
{
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

}
