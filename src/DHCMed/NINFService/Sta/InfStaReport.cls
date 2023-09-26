/// 报表工具使用的Query
Class DHCMed.NINFService.Sta.InfStaReport Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// w ##Class(DHCMed.NINFService.Sta.InfStaReport).Test()
ClassMethod Test()
{
	s %ZIndex=$zn
	s %JIndex=$j
	s %NIndex="Test"
	w %ZIndex,!
	w %JIndex,!
	
	k ^TMP(%ZIndex,%JIndex,%NIndex)
	s flg=##Class(DHCMed.NINFService.Sta.InfStaReport).getMapDiagnos("I63.902","常见疾病","CommonDisease")
	w flg,!
	s flg=##Class(DHCMed.NINFService.Sta.InfStaReport).getMapDiagnos("I63.902","疾病分类","TypeDisease")
	w flg,!
	s flg=##Class(DHCMed.NINFService.Sta.InfStaReport).getMapValue("儿科","科室类别","DepType")
	w flg,!
	//zw ^TMP(%ZIndex,%JIndex,%NIndex)
	k ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit "Over!"
}

/// 取诊断对应 常见疾病,疾病分类
ClassMethod getMapDiagnos(aValue As %String, aConfType As %String, aConfCode As %String)
{
	New (aValue,aConfType,aConfCode,%ZIndex,%JIndex,%NIndex)
	Set return=""
	Quit:(aValue="")||(aConfType="")||(aConfCode="") return
	Quit:(%ZIndex="")||(%JIndex="")||(%NIndex="") return
	
	Set $ZT="getMapDiagnosErr"
	
	//处理基础数据
	If '$d(^TMP(%ZIndex,%JIndex,%NIndex,aConfType,aConfCode)) {
		Set ProductID=$o(^DHCMed.SS.ProductsI("ProductActive","NINF",1,""))
		Set DepGrpConfID=$o(^DHCMed.SS.ReportConfigI("IndexMaster",0,+ProductID," "_aConfType," "_$zcvt(aConfCode,"U"),""))
		Set objDepGrpConf=##class(DHCMed.SS.ReportConfig).GetObjById(DepGrpConfID)
		If $IsObject(objDepGrpConf) {
			If objDepGrpConf.ConfigItems'="" {
				Set ItmCnt=objDepGrpConf.ConfigItems.Count()
				For indItm=1:1:ItmCnt {
					Set objItm=objDepGrpConf.ConfigItems.GetAt(indItm)
					Continue:'$IsObject(objItm)
					Set ItmID=objItm.%Id()
					Set ItmCode=objItm.Code
					Continue:ItmCode=""
					Set Value1=objItm.Value1
					If Value1'="" {
						Set ^TMP(%ZIndex,%JIndex,%NIndex,aConfType,aConfCode,"Value1",Value1,ItmID)=ItmCode
					}
					Set Value2=objItm.Value2
					If Value2'="" {
						Set ^TMP(%ZIndex,%JIndex,%NIndex,aConfType,aConfCode,"Value2",Value2,ItmID)=ItmCode
					}
				}
			}
		}
	}
	
	Set xValue=$o(^TMP(%ZIndex,%JIndex,%NIndex,aConfType,aConfCode,"Value1",aValue),-1)
	Set yValue=$o(^TMP(%ZIndex,%JIndex,%NIndex,aConfType,aConfCode,"Value2",aValue))
	Quit:(xValue="")||(yValue="") return
	Set xItemID=$o(^TMP(%ZIndex,%JIndex,%NIndex,aConfType,aConfCode,"Value1",xValue,""))
	Set yItemID=$o(^TMP(%ZIndex,%JIndex,%NIndex,aConfType,aConfCode,"Value2",yValue,""))
	Quit:xItemID'=yItemID return
	Set return=$g(^TMP(%ZIndex,%JIndex,%NIndex,aConfType,aConfCode,"Value1",xValue,xItemID))
	Quit return
	
getMapDiagnosErr
	Quit ""
}

/// 取科室对应 科室类别,特殊耐药菌,常见病原体,常见抗生素,药敏结果
ClassMethod getMapValue(aValue As %String, aConfType As %String, aConfCode As %String)
{
	New (aValue,aConfType,aConfCode,%ZIndex,%JIndex,%NIndex)
	Set return=""
	Quit:(aValue="")||(aConfType="")||(aConfCode="") return
	Quit:(%ZIndex="")||(%JIndex="")||(%NIndex="") return
	
	Set $ZT="getMapValueErr"
	
	//处理基础数据
	If '$d(^TMP(%ZIndex,%JIndex,%NIndex,aConfType,aConfCode)) {
		Set ProductID=$o(^DHCMed.SS.ProductsI("ProductActive","NINF",1,""))
		Set DepGrpConfID=$o(^DHCMed.SS.ReportConfigI("IndexMaster",0,+ProductID," "_aConfType," "_$zcvt(aConfCode,"U"),""))
		Set objDepGrpConf=##class(DHCMed.SS.ReportConfig).GetObjById(DepGrpConfID)
		If $IsObject(objDepGrpConf) {
			/*If objDepGrpConf.ConfigItems'="" {
				Set ItmCnt=objDepGrpConf.ConfigItems.Count()
				For indItm=1:1:ItmCnt {
					Set objItm=objDepGrpConf.ConfigItems.GetAt(indItm)
					Continue:'$IsObject(objItm)
					Set Value1=objItm.Value1
					Set LocGrpDesc=objItm.Code
					For indVal=1:1:$l(Value1,",") {
						Set LocDesc=$p(Value1,",",indVal)
						Continue:LocDesc=""
						Set ^TMP(%ZIndex,%JIndex,%NIndex,aConfType,aConfCode,LocDesc)=LocGrpDesc
					}
				}
			}*/
			Set xCfgItemID=0
			For {
				Set xCfgItemID=$o(^DHCMed.SS.ReportConfigD(DepGrpConfID,"ConfigItems",xCfgItemID))
				Quit:xCfgItemID=""
			
				Set objItm=##class(DHCMed.SS.ReportConfigItem).GetObjById(DepGrpConfID_"||"_xCfgItemID)
				Continue:'$IsObject(objItm)
				Set Value1=objItm.Value1
				Set LocGrpDesc=objItm.Code
				For indVal=1:1:$l(Value1,",") {
					Set LocDesc=$p(Value1,",",indVal)
					Continue:LocDesc=""
					Set ^TMP(%ZIndex,%JIndex,%NIndex,aConfType,aConfCode,LocDesc)=LocGrpDesc
				}
			}
		}
	}
	
	Set return=$g(^TMP(%ZIndex,%JIndex,%NIndex,aConfType,aConfCode,aValue))
	Quit return
	
getMapValueErr
	Quit ""
}

/// 查询出院患者
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.InfStaReport","QryDischargePatient","COMP","2013-01-01","2013-08-01")
Query QryDischargePatient(Type As %String, FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "科室:%String,病区:%String,ICD:%String,诊断:%String,是否院内感染:%Integer,感染报告数量:%Integer,疾病类别:%String,易感因素:%String,是否手术:%Integer,切口等级:%String,是否手术感染:%Integer,科室类别:%String,常见病种:%String,疾病分类:%String,Paadm:%String") [ SqlProc ]
{
}

ClassMethod QryDischargePatientExecute(ByRef qHandle As %Binary, Type As %String, FromDate As %String, ToDate As %String) As %Status
{
	Set repid1=$I(^CacheTemp)
	Set ind1=1
	Set qHandle=$lb(0,repid1,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryDischargePatient"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For xDate=FromDate:1:ToDate {
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Continue:$p(AdmInfo,"^",75)'=""     //婴儿不统计
			Set Data=$$BuildQryDischPat(xPaadm,Type)
			Continue:Data=""
			Set ^CacheTemp(repid1,ind1)=Data
			Set ind1=ind1+1
		}
	}
	
	
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
	
BuildQryDischPat(Paadm,Type)
	New (Paadm,Type,%ZIndex,%JIndex,%NIndex)
	
	//科室、病区、科室类别
	Set (LocDesc,WardDesc,DepGroup)=""
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
	If objAdm'="" Do objAdm.%Close()
	Set LocDesc=objAdm.Department
	Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	Set WardDesc=objAdm.Ward
	Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	Set DepDesc=objAdm.Department
	Set DepGroup=..getMapValue(DepDesc,"科室类别","DepType")
	Set:DepGroup="" DepGroup="其它"
	
	//ICD10、诊断名称、诊断类别
	Set (ICD10,ICDDesc,ICDType)=""
	Set AdmDiag=##class(DHCMed.Base.MRDiagnose).GetByPaadm(Paadm)
	Set ICD10=$p(AdmDiag,"^",13)
	Set ICDDesc=$p(AdmDiag,"^",14)
	Set ICDType=$e(ICD10,1,1)
	Set CommDiagnos=..getMapDiagnos(ICD10,"常见疾病","CommonDisease")
	Set:CommDiagnos="" CommDiagnos="其它"
	Set TypeDiagnos=..getMapDiagnos(ICD10,"疾病分类","TypeDisease")
	Set:TypeDiagnos="" TypeDiagnos="其它"
	
	
	//是否感染、感染次数、易感因素、手术感染
	Set (InfFactors,InfPosList)=""
	Set (IsInfection,InfectionTimes,IsOperationInf)=0
	Set arryInfReport=##class(DHCMed.NINF.Srv.InfReport).GetInfRepByAdm(Paadm,Type,"","","")
	Set:'$IsObject(arryInfReport) arryInfReport=##class(%ListOfObjects).%New()
	For indRep=1:1:arryInfReport.Count() {
		Set objRep=arryInfReport.GetAt(indRep)
		Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.ReportStatus)
		Set RepStatus=objRep.ReportStatus.Code
		Continue:RepStatus'="3" //已审
		
		Set IsInfection=1
		
		Set arryInfPos=objRep.GetInfPos(objRep.ReportID)
		For indInfPos=1:1:arryInfPos.Count() {
			Set objInfPos=arryInfPos.GetAt(indInfPos)
			Continue:'$IsObject(objInfPos)
			Set InfPosDesc=""
			If $IsObject(objInfPos.InfPos) {
				Set InfPosDesc=objInfPos.InfPos.Desc
			}
			Set InfDiagDesc=""
			If $IsObject(objInfPos.InfDiag) {
				Set InfDiagDesc=objInfPos.InfDiag.Desc
			}
			Set InfDate=objInfPos.InfDate
			Continue:(InfPosDesc="")||(InfDate="")
			
			If ((InfPosDesc="表浅切口")
				||(InfPosDesc="深部切口")
				||((InfPosDesc["器官")&&(InfPosDesc["腔隙"))
				||(InfPosDesc="手术部位"))
			{
				Set IsOperationInf=1
			}
			
			Set strInfPos=InfPosDesc_","_InfDate
			Continue:$listfind(InfPosList,strInfPos)>0
			Set InfPosList=InfPosList_$lb(strInfPos)
			
			Set InfectionTimes=InfectionTimes+1
		}
		
		Set objSumm=objRep.GetReportSumm(objRep.ReportID)
		If $IsObject(objSumm) {
			For indInfFactors=1:1:objSumm.InfFactors.Count() {
				Set objReasonDic=objSumm.InfFactors.GetAt(indInfFactors)
				Continue:'$IsObject(objReasonDic)
				Set InfFactors=InfFactors_","_objReasonDic.Desc
			}
		}
		
		/* update by zf 20121103
		Set arryOperation=objRep.GetOperations(objRep.ReportID)
		For indOperation=1:1:arryOperation.Count() {
			Set objOpe=arryOperation.GetAt(indOperation)
			Continue:'$IsObject(objOpe)
			Continue:'$IsObject(objOpe.InHospInfFlag)
			If objOpe.InHospInfFlag.Code="Y" {
				Set IsOperationInf=1
			}
		}
		*/
	}
	Set:InfFactors'="" InfFactors=$e(InfFactors,2,$l(InfFactors))
	
	//是否手术、切口等级
	Set IsOperation=0,CuteType=""
	Set OpeInfo=..GetOperation(Paadm)
	//add by likai 2012-12-19
	if ($p(OpeInfo,"^",2)'=""){
		set IsOperation=1
		Set CuteType=$p(OpeInfo,"^",3)
		Set:CuteType="" CuteType="无"
	}
	Set Data=""
	Set $li(Data,1)=LocDesc            //就诊科室名称
	Set $li(Data,2)=WardDesc           //就诊病区名称
	Set $li(Data,3)=ICD10              //临床诊断ICD10
	Set $li(Data,4)=ICDDesc            //临床诊断名称
	Set $li(Data,5)=IsInfection        //是否院内感染
	Set $li(Data,6)=InfectionTimes     //感染报告数量
	Set $li(Data,7)=ICDType            //临床诊断疾病类别
	Set $li(Data,8)=InfFactors         //易感因素
	Set $li(Data,9)=IsOperation        //是否手术
	Set $li(Data,10)=CuteType          //切口等级
	Set $li(Data,11)=IsOperationInf    //是否手术感染
	Set $li(Data,12)=DepGroup          //就诊科室类别
	Set $li(Data,13)=CommDiagnos       //常见病种
	Set $li(Data,14)=TypeDiagnos       //疾病分类
	Set $li(Data,15)=Paadm             //就诊号
	
	Quit Data
}

ClassMethod QryDischargePatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDischargePatientExecute ]
{
	Set repid1=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid1)
 	Quit $$$OK
}

ClassMethod QryDischargePatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDischargePatientExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid1=$LIST(qHandle,2)
 	Set ind1=$LIST(qHandle,3)
 	Set ind1=$o(^CacheTemp(repid1,ind1))
 	If ind1="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid1,ind1)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid1,ind1)
	Quit $$$OK
}

ClassMethod GetDepAndWard(objRep)
{
	New (objRep)
	Set return=""
	Quit:'$IsObject(objRep) return
	
	Set objSumm=##class(DHCMed.NINF.Srv.InfReport).GetReportSumm(objRep.ReportID)
	If $IsObject(objSumm) {
		If $IsObject(objSumm.TransLoc) {
			Set LocID=objSumm.TransLoc.Code
			Set LocDesc=objSumm.TransLoc.Desc
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
			Set return=LocDesc_"^"_LocDesc_"^"_LocID_"^"_LocID
		} Else {
			Set LocID=objSumm.TransLoc
			Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(LocID)
			If $IsObject(objLoc) {
				Set LocDesc=objLoc.Descs
				Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
				Set return=LocDesc_"^"_LocDesc_"^"_LocID_"^"_LocID
			}
			If objLoc'="" Do objLoc.%Close()
		}
	}
	
	Quit return
	
	/* update by zf 2013-07-31
	Set ret=""
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objRep.EpisodeID)
	If objAdm'="" Do objAdm.%Close()	
	Set objSumm=##class(DHCMed.NINF.Srv.InfReport).GetReportSumm(objRep.ReportID)
	Set locID=""
	Set wardID=""
	Set RepDate=objRep.ReportDate
	Set:RepDate'="" RepDate=$zdh(RepDate,3)
	Set RepTime=objRep.ReportTime
	Set:RepTime'="" RepTime=$zth(RepTime,1)
	if (objSumm.TransID'="") 
	{
		Set EpisodeID=$p(objSumm.TransID,"||",1)
		Set ChildSub=$p(objSumm.TransID,"||",2)
		For {
			Set ChildSub=$o(^PAADM(EpisodeID,"TRANS",ChildSub))
			Quit:ChildSub=""
			Set transData=$g(^PAADM(EpisodeID,"TRANS",ChildSub))
			Set StartDate=$p(transData,"^",1) 
			Set StartTime=$p(transData,"^",2)
			Set locID=$p(transData,"^",6)
			Continue:((locID'=objSumm.TransLoc)&&(locID'="")) //科室不再是上报科室
			Continue:StartDate>RepDate //Modified By LiYang 2013-05-27 通过日期判断上报报告时到底在哪个病区
			Continue:((StartDate=RepDate)&&(StartTime>RepTime)) //Modified By LiYang 2013-05-27 通过日期判断上报报告时到底在哪个病区
			Set wardID=$p(transData,"^",9)
		}
		Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(objSumm.TransLoc)
		Do objLoc.%Close()
		Set objWard=##class(DHCMed.Base.PacWard).GetObjById(wardID)
		Set:'$IsObject(objWard) objWard=##class(DHCMed.Base.PacWard).%New()		
		Set LocDesc=objLoc.Descs
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		Set WardDesc=objWard.Descs
		Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
		Set DepDesc=objLoc.Descs
		Set LocID=objSumm.TransLoc
		Set WardID=wardID
	}
	else
	{
		Set LocDesc=objAdm.Department
		Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
		Set WardDesc=objAdm.Ward
		Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
		Set DepDesc=objAdm.Department
		Set LocID=objAdm.DepartmentID
		Set WardID=objAdm.WardID			
	}	
	Set ret=LocDesc_"^"_WardDesc_"^"_LocID_"^"_WardID
	Quit ret
	*/
}

/// 查询院内感染部位信息
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.InfStaReport","QryInfPosInfo","2013-01-01","2013-08-05","COMP")
Query QryInfPosInfo(FromDate As %String, ToDate As %String, Type As %String) As %Query(ROWSPEC = "Paadm:%String,ReportID:%String,部位:%String,侵害性操作:%String,感染诊断:%String,病原体和药敏:%String,科室:%String,病区:%String,主要诊断ICD:%String,主要诊断名称:%String,易感因素:%String,科室类别:%String,常见病种:%String,疾病分类:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosInfoExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, Type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK

	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryInfPosInfo"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set lstReportID=##class(DHCMed.NINF.Srv.InfReport).GetInfRepList(FromDate,ToDate,"")
	for i=1:1:$ll(lstReportID) {
		Set ReportID=$lg(lstReportID,i)
		Continue:ReportID=""
		
		Set objRep=##class(DHCMed.NINF.Srv.InfReport).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		Set RepStatus=objRep.ReportStatus.Code
		Continue:RepStatus'="3" //已审
		
		Set ReportID=objRep.ReportID
		Set Paadm=objRep.EpisodeID
		
		//科室、病区、科室类别
		Set (LocDesc,WardDesc,DepGroup)=""
		Set tmp=..GetDepAndWard(objRep)
		Set LocDesc=$p(tmp,"^",1)
		Set WardDesc=$p(tmp,"^",2)
		Set DepGroup=..getMapValue(LocDesc,"科室类别","DepType")
		Set:DepGroup="" DepGroup="其它"
		
		//ICD10、诊断名称、诊断类别
		Set (ICD10,ICDDesc,ICDType)=""
		Set AdmDiag=##class(DHCMed.Base.MRDiagnose).GetByPaadm(Paadm)
		Set ICD10=$p(AdmDiag,"^",13)
		Set ICDDesc=$p(AdmDiag,"^",14)
		Set ICDType=$e(ICD10,1,1)
		Set CommDiagnos=..getMapDiagnos(ICD10,"常见疾病","CommonDisease")
		Set:CommDiagnos="" CommDiagnos="其它"
		Set TypeDiagnos=..getMapDiagnos(ICD10,"疾病分类","TypeDisease")
		Set:TypeDiagnos="" TypeDiagnos="其它"
		
		//易感因素
		Set InfFactors=""
		Set objSumm=objRep.GetReportSumm(objRep.ReportID)
		If $IsObject(objSumm) {
			For indInfFactors=1:1:objSumm.InfFactors.Count() {
				Set objInfFactors=objSumm.InfFactors.GetAt(indInfFactors)
				Continue:'$IsObject(objInfFactors)
				Set InfFactors=InfFactors_","_objInfFactors.Desc
			}
		}
		Set:InfFactors'="" InfFactors=$e(InfFactors,2,$l(InfFactors))	
		
		//感染部位信息
		Set InfPosList=""
		Set arryRepPos=objRep.GetInfPos(ReportID)
		Set:'$IsObject(arryRepPos) arryRepPos=##class(%ListOfObjects).%New()
		For indInfPos=1:1:arryRepPos.Count() {
			Set objInfPos=arryRepPos.GetAt(indInfPos)
			Continue:'$IsObject(objInfPos)
			
			//检查感染日期
			Set InfDate=objInfPos.InfDate
			Continue:InfDate=""
			Set:InfDate["-" InfDate=$zdh(InfDate,3)
			Continue:(InfDate>ToDate)||(InfDate<FromDate)
			
			Set (InfPosCode,InfPosDesc,InfDiagDesc,InfPosOpr,DrugSenResult)=""
			
			If $IsObject(objInfPos.InfPos) {
				Set InfPosDesc=objInfPos.InfPos.Desc
				Set InfPosCode=objInfPos.InfPos.Code
			}
			If $IsObject(objInfPos.InfDiag) {
				Set InfDiagDesc=objInfPos.InfDiag.Desc
			}
			Set InfDate=objInfPos.InfDate
			Continue:(InfPosDesc="")||(InfDate="")
			
			Set strInfPos=InfPosDesc_","_InfDate
			Continue:$listfind(InfPosList,strInfPos)>0
			Set InfPosList=InfPosList_$lb(strInfPos)
			
			//侵害性操作
			For indInfPosOpr=1:1:objInfPos.InfPosOpr.Count() {
				Set objInfPosOpr=objInfPos.InfPosOpr.GetAt(indInfPosOpr)
				Continue:'$IsObject(objInfPosOpr) //Modified By LiYang 2013-05-25 FixBug:应该是不是对象才跳过
				Set InfPosOpr=InfPosOpr_","_objInfPosOpr.Desc
			}
			Set:InfPosOpr'="" InfPosOpr=$e(InfPosOpr,2,$l(InfPosOpr))
			
			//感染部位对应 病原体+抗生素+药敏
			Set arryLabResult=objRep.GetLabResults(ReportID)
			Set:'$IsObject(arryLabResult) arryLabResult=##class(%ListOfObjects).%New()
			For indLabRst=1:1:arryLabResult.Count() {
				Set objLabResult=arryLabResult.GetAt(indLabRst)
				Continue:'$IsObject(objLabResult)
				Continue:'$IsObject(objLabResult.TestResults)
				Continue:'$IsObject(objLabResult.InfectionPos)
				Set LabInfPosCode=objLabResult.InfectionPos.Code
				//如果病原学检验部分的感染部位为空,取感染信息感染部位
				Set:LabInfPosCode="" LabInfPosCode=InfPosCode
				Continue:(LabInfPosCode'=InfPosCode)
			
				For indTestRst=1:1:objLabResult.TestResults.Count() {
					Set objPy=objLabResult.TestResults.GetAt(indTestRst)
					Continue:'$IsObject(objPy)
					Set PathogenyDesc=objPy.PathogenyDesc
				
					If objPy.DrugSenTest.Count()>0 {
						For indSenTest=1:1:objPy.DrugSenTest.Count() {
							Set objSenResult=objPy.DrugSenTest.GetAt(indSenTest)
							Continue:'$IsObject(objSenResult)
							Set AntibioticsDesc=objSenResult.AntibioticsDesc
							Set SenTestRst=""
							If $IsObject(objSenResult.SenTestRst) {
								Set SenTestRst=objSenResult.SenTestRst.Desc
							}
							Set DrugSenResult=DrugSenResult_";"_PathogenyDesc_":"_AntibioticsDesc_":"_SenTestRst
						}
					} Else {
						Set DrugSenResult=DrugSenResult_";"_PathogenyDesc_"::"
					}
				}
			}
			Set:DrugSenResult'="" DrugSenResult=$e(DrugSenResult,2,$l(DrugSenResult))
						
			Set Data=""
			Set $li(Data,1)=Paadm          //就诊号
			Set $li(Data,2)=ReportID       //感染报告ID
			Set $li(Data,3)=InfPosDesc     //感染部位
			Set $li(Data,4)=InfPosOpr      //侵害性操作
			Set $li(Data,5)=InfDiagDesc    //感染诊断
			Set $li(Data,6)=DrugSenResult  //病原体+抗生素+药敏
			Set $li(Data,7)=LocDesc        //就诊科室
			Set $li(Data,8)=WardDesc       //就诊病区
			Set $li(Data,9)=ICD10          //临床诊断ICD10
			Set $li(Data,10)=ICDDesc       //临床诊断名称
			Set $li(Data,11)=InfFactors    //易感因素
			Set $li(Data,12)=DepGroup      //科室分类
			Set $li(Data,13)=CommDiagnos   //就诊科室类别
			Set $li(Data,14)=TypeDiagnos   //就诊科室类别
			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
}

ClassMethod QryInfPosInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 取手术申请单/病案首页手术信息
/// 参数：Paadm 就诊号
/// 输出：手术ICD码^手术名称^切口愈合等级（I,II,III）
/// w ##Class(DHCMed.NINFService.Sta.InfStaReport).GetOperation(19906369)
ClassMethod GetOperation(Paadm As %String)
{
	New (Paadm)
	Set return=""
	
	Set strOperation=""
	//获取统计取手术位置
	Set OperTypeFlag=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfOperDataSource","")
	Set OperTypeFlag=+OperTypeFlag
	If OperTypeFlag=0 {
		Set indOperation=0
		Set currCuteType=-1
		For {
			Set indOperation=indOperation+1
			//病案系统接口调用：就诊号取手术信息接口
			Set tmpOperation=##class(DHCWMR.IO.OutService).IGetFrontPageICD(Paadm,"O/1",indOperation)
			Quit:tmpOperation=""
			Quit:indOperation>10
			
			Set OperationID=$p(tmpOperation,$c(2),1)
			Set OperationDesc=$p(tmpOperation,$c(2),2)
			Continue:OperationDesc=""
			Set CuteTypeDesc=$p(tmpOperation,$c(2),8)
			Set:CuteTypeDesc'="" CuteTypeDesc=$p(CuteTypeDesc,"/",1)
			If CuteTypeDesc="I" {
				Set CuteTypeCode=1
			} ElseIf CuteTypeDesc="II" {
				Set CuteTypeCode=2
			} ElseIf CuteTypeDesc="III" {
				Set CuteTypeCode=3
			} Else {
				Set CuteTypeCode=0
			}
			If (CuteTypeCode>currCuteType)||(currCuteType<0) {
				Set currCuteType=CuteTypeCode
				Set strOperation=""_"^"_OperationDesc_"^"_$s(CuteTypeCode=1:"I",CuteTypeCode=2:"II",CuteTypeCode=3:"III",1:"无")
			}
		}
	} Else {
		Set CurrCuteType=0
		Set rs=##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportOpr:QrySubRec")
		Do rs.Execute("",Paadm)
		While (rs.Next()) {
			Set OperationID=rs.GetDataByName("OperationID")
			Set OperationDesc=rs.GetDataByName("OperationDesc")
			Set CuteTypeDesc=rs.GetDataByName("CuteTypeDesc")
			If CuteTypeDesc="I" {
				Set CuteTypeCode=1
			} ElseIf CuteTypeDesc="II" {
				Set CuteTypeCode=2
			} ElseIf CuteTypeDesc="III" {
				Set CuteTypeCode=3
			} Else {
				Set CuteTypeCode=0
			}
			If (CurrCuteType<CuteTypeCode)||(strOperation="") {
				Set CurrCuteType=CuteTypeCode
				Set strOperation=OperationID_"^"_OperationDesc_"^"_$s(CuteTypeCode=1:"I",CuteTypeCode=2:"II",CuteTypeCode=3:"III",1:"无")
			}
		}
		Do rs.%Close()
	}
	Set return=strOperation
	
	Quit return
}

/// 查询某一时间段报告过的易感因素
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.InfStaReport","QryInfFactors","2013-01-01","2013-08-01","COMP")
Query QryInfFactors(FromDate As %String, ToDate As %String, Type As %String) As %Query(ROWSPEC = "Paadm:%String,ReportID:%String,科室:%String,病区:%String,科室类别:%String,易感因素:%String") [ SqlProc ]
{
}

ClassMethod QryInfFactorsExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, Type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryInfFactors"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set lstReportID=##class(DHCMed.NINF.Srv.InfReport).GetInfRepList(FromDate,ToDate,"")
	for i=1:1:$ll(lstReportID) {
		Set ReportID=$lg(lstReportID,i)
		Continue:ReportID=""
		//w "->"_ReportID,!
		Set objRep=##class(DHCMed.NINF.Srv.InfReport).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		Set RepStatus=objRep.ReportStatus.Code
		Continue:RepStatus'="3" //已审
		Do BuildQryInfFactors(objRep.EpisodeID,objRep)
	}	
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
	
BuildQryInfFactors(Paadm,objRep)
	New (Paadm,objRep,repid,ind,%ZIndex,%JIndex,%NIndex)
	
	Set ReportID=objRep.ReportID
	
	//科室、病区、科室类别
	Set (LocDesc,WardDesc,DepGroup)=""
	Set tmp=..GetDepAndWard(objRep)
	Set LocDesc=$p(tmp,"^",1)
	Set WardDesc=$p(tmp,"^",2)
	
	Set DepGroup=..getMapValue(LocDesc,"科室类别","DepType")
	Set:DepGroup="" DepGroup="其它"
	//易感因素
	Set objSumm=objRep.GetReportSumm(objRep.ReportID)
	If $IsObject(objSumm) {
		For indInfFactors=1:1:objSumm.InfFactors.Count() {
			Set objInfFactors=objSumm.InfFactors.GetAt(indInfFactors)
			Continue:'$IsObject(objInfFactors)
			Set InfFactors=objInfFactors.Desc
			Set Data=""
			Set $li(Data,1)=Paadm          //就诊号
			Set $li(Data,2)=ReportID       //感染报告ID
			Set $li(Data,3)=LocDesc        //就诊科室
			Set $li(Data,4)=WardDesc       //就诊病区
			Set $li(Data,5)=DepGroup       //科室分类
			Set $li(Data,6)=InfFactors     //易感因素
		
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit
}

ClassMethod QryInfFactorsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfFactorsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfFactorsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfFactorsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询院内感染部位病原体信息
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.InfStaReport","QryInfPosToLabPy","2013-01-01","2013-08-01",1)
Query QryInfPosToLabPy(FromDate As %String, ToDate As %String, Type As %String) As %Query(ROWSPEC = "Paadm:%String,ReportID:%String,科室:%String,病区:%String,科室类别:%String,部位:%String,感染诊断:%String,病原体:%String,耐药菌:%String") [ SqlProc ]
{
}

ClassMethod QryInfPosToLabPyExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, Type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryInfPosToLabPy"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	Set lstReportID=##class(DHCMed.NINF.Srv.InfReport).GetInfRepList(FromDate,ToDate,"")
	for i=1:1:$ll(lstReportID) {
		Set ReportID=$lg(lstReportID,i)
		Continue:ReportID=""
		//w "->"_ReportID,!
		Set objRep=##class(DHCMed.NINF.Srv.InfReport).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		Set RepStatus=objRep.ReportStatus.Code
		Continue:RepStatus'="3" //已审
		Do BuildQryInfPosToLabPy(objRep.EpisodeID,objRep)
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
	
BuildQryInfPosToLabPy(Paadm,objRep)
	New (Paadm,objRep,repid,ind,%ZIndex,%JIndex,%NIndex)
	
	Set ReportID=objRep.ReportID
	
	//科室、病区、科室类别
	Set (LocDesc,WardDesc,DepGroup)=""
	Set tmp=..GetDepAndWard(objRep)
	Set LocDesc=$p(tmp,"^",1)
	Set WardDesc=$p(tmp,"^",2)
	
	Set DepGroup=..getMapValue(LocDesc,"科室类别","DepType")
	Set:DepGroup="" DepGroup="其它"
	
	//感染部位信息
	Set InfPosList=""
	Set arryRepPos=objRep.GetInfPos(ReportID)
	Set:'$IsObject(arryRepPos) arryRepPos=##class(%ListOfObjects).%New()
	For indInfPos=1:1:arryRepPos.Count() {
		Set objInfPos=arryRepPos.GetAt(indInfPos)
		Continue:'$IsObject(objInfPos)
		
		Set (InfPosCode,InfPosDesc,InfDiagDesc,InfPosOpr,DrugSenResult)=""
		
		If $IsObject(objInfPos.InfPos) {
			Set InfPosDesc=objInfPos.InfPos.Desc
			Set InfPosCode=objInfPos.InfPos.Code
		}
		If $IsObject(objInfPos.InfDiag) {
			Set InfDiagDesc=objInfPos.InfDiag.Desc
		}
		Set InfDate=objInfPos.InfDate
		Continue:(InfPosDesc="")||(InfDate="")
		
		Set strInfPos=InfPosDesc_","_InfDate
		Continue:$listfind(InfPosList,strInfPos)>0
		Set InfPosList=InfPosList_$lb(strInfPos)
		
		//感染部位对应 病原体+抗生素+药敏
		Set arryLabResult=objRep.GetLabResults(ReportID)
		Set:'$IsObject(arryLabResult) arryLabResult=##class(%ListOfObjects).%New()
		For indLabRst=1:1:arryLabResult.Count() {
			Set objLabResult=arryLabResult.GetAt(indLabRst)
			Continue:'$IsObject(objLabResult)
			Continue:'$IsObject(objLabResult.TestResults)
			Continue:'$IsObject(objLabResult.InfectionPos)
			Set LabInfPosCode=objLabResult.InfectionPos.Code
			//如果病原学检验部分的感染部位为空,取感染信息感染部位
			Set:LabInfPosCode="" LabInfPosCode=InfPosCode
			Continue:(LabInfPosCode'=InfPosCode)
			
			For indTestRst=1:1:objLabResult.TestResults.Count() {
				Set objPy=objLabResult.TestResults.GetAt(indTestRst)
				Continue:'$IsObject(objPy)
				Set PathogenyDesc=objPy.PathogenyDesc
				Set PyGroup=..getMapValue(PathogenyDesc,"特殊耐药菌","SpecialPYObject")
				
				Set Data=""
				Set $li(Data,1)=Paadm          //就诊号
				Set $li(Data,2)=ReportID       //感染报告ID
				Set $li(Data,3)=LocDesc        //就诊科室
				Set $li(Data,4)=WardDesc       //就诊病区
				Set $li(Data,5)=DepGroup       //科室分类
				Set $li(Data,6)=InfPosDesc     //感染部位
				Set $li(Data,7)=InfDiagDesc    //感染诊断
				Set $li(Data,8)=PathogenyDesc  //病原体
				Set $li(Data,9)=PyGroup        //耐药菌
				
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit
}

ClassMethod QryInfPosToLabPyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosToLabPyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosToLabPyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosToLabPyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 查询某一时间段报告过的病原体
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.InfStaReport","QryInfLabPy","2013-07-01","2013-07-31",1)
Query QryInfLabPy(FromDate As %String, ToDate As %String, Type As %String) As %Query(ROWSPEC = "Paadm:%String,ReportID:%String,科室:%String,病区:%String,科室类别:%String,病原体:%String,耐药菌:%String") [ SqlProc ]
{
}

ClassMethod QryInfLabPyExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, Type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryInfLabPy"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	Set lstReportID=##class(DHCMed.NINF.Srv.InfReport).GetInfRepList(FromDate,ToDate,"")
	for i=1:1:$ll(lstReportID) {
		Set ReportID=$lg(lstReportID,i)
		Continue:ReportID=""
		//w "->"_ReportID,!
		Set objRep=##class(DHCMed.NINF.Srv.InfReport).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		Set RepStatus=objRep.ReportStatus.Code
		Continue:RepStatus'="3" //已审
		Do BuildQryLabPy(objRep.EpisodeID,objRep)
	}	
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
	
BuildQryLabPy(Paadm,objRep)
	New (Paadm,objRep,repid,ind,%ZIndex,%JIndex,%NIndex)
	
	Set ReportID=objRep.ReportID
	
	//科室、病区、科室类别
	Set (LocDesc,WardDesc,DepGroup)=""
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(Paadm)
	If objAdm'="" Do objAdm.%Close()
	Set tmp=..GetDepAndWard(objRep)
	Set DepDesc=$p(tmp,"^",1)
	Set WardDesc=$p(tmp,"^",2)
	Set LocDesc=DepDesc
	//Set DepDesc=objAdm.Department
	Set DepGroup=..getMapValue(DepDesc,"科室类别","DepType")
	Set:DepGroup="" DepGroup="其它"
	
	//病原体
	Set arryLabResult=objRep.GetLabResults(ReportID)
	Set:'$IsObject(arryLabResult) arryLabResult=##class(%ListOfObjects).%New()
	For indLab=1:1:arryLabResult.Count() {
		Set objLabResult=arryLabResult.GetAt(indLab)
		Continue:'$IsObject(objLabResult)
		Continue:'$IsObject(objLabResult.TestResults)
		
		For indTestRst=1:1:objLabResult.TestResults.Count() {
			Set objPy=objLabResult.TestResults.GetAt(indTestRst)
			Continue:'$IsObject(objPy)
			Set PathogenyDesc=objPy.PathogenyDesc
			Set PyGroup=..getMapValue(PathogenyDesc,"特殊耐药菌","SpecialPYObject")
			
			Set Data=""
			Set $li(Data,1)=Paadm          //就诊号
			Set $li(Data,2)=ReportID       //感染报告ID
			Set $li(Data,3)=LocDesc        //就诊科室
			Set $li(Data,4)=WardDesc       //就诊病区
			Set $li(Data,5)=DepGroup       //科室分类
			Set $li(Data,6)=PathogenyDesc  //病原体
			Set $li(Data,7)=PyGroup        //耐药菌
			
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit
}

ClassMethod QryInfLabPyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfLabPyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfLabPyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfLabPyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
