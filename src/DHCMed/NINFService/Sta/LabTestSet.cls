/// 名称: DHCMed.NINFService.Sta.LabTestSet
/// 描述: 病原体,药敏实验相关统计(检验报告数据)
/// 编写者：zhufei
/// 编写日期: 2012-10-31
Class DHCMed.NINFService.Sta.LabTestSet Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2012-10-31
/// Description:  查询细菌培养结果(病原体信息)
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Sta.LabTestSet","QryLabPyDtl","2009-01-01","2009-01-31")
Query QryLabPyDtl(aFromDate As %String, aToDate As %String) As %Query(ROWSPEC = "Paadm:%String,科室:%String,病区:%String,病原体:%String,标本:%String") [ SqlProc ]
{
}

ClassMethod QryLabPyDtlExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For xDate=aFromDate:1:aToDate {
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			
			//科室、病区
			Set (LocDesc,WardDesc)=""
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			If objAdm'="" Do objAdm.%Close()
			Set LocDesc=objAdm.Department
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
			Set WardDesc=objAdm.Ward
			Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
			
			Set arryLabPy=##class(DHCMed.NINF.Srv.LabTestSet).GetLabResults(xPaadm)
			For indLabPy=1:1:arryLabPy.Count() {
				Set objLabPy=arryLabPy.GetAt(indLabPy)
				Continue:'$IsObject(objLabPy)
				Continue:'$IsObject(objLabPy.Specimen)
				Set SpecimenDesc=objLabPy.Specimen.Desc
				For indPy=1:1:objLabPy.TestResults.Count() {
					Set objPy=objLabPy.TestResults.GetAt(indPy)
					Continue:'$IsObject(objPy)
					Set PathogenyID=objPy.PathogenyID
					Set PathogenyDesc=objPy.PathogenyDesc
					
					Set Data=$lb(xPaadm,LocDesc,WardDesc,PathogenyDesc,SpecimenDesc)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLabPyDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabPyDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabPyDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabPyDtlExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-10-31
/// Description:  查询细菌培养+药敏实验结果
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Sta.LabTestSet","QryLabPyAntiDtl","2009-01-01","2009-01-31")
Query QryLabPyAntiDtl(aFromDate As %String, aToDate As %String) As %Query(ROWSPEC = "Paadm:%String,科室:%String,病区:%String,病原体编号:%String,病原体:%String,耐药菌:%String,抗生素:%String,药敏:%String") [ SqlProc ]
{
}

ClassMethod QryLabPyAntiDtlExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryDischargePatient"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set PyNum=0
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引
	For xDate=aFromDate:1:aToDate {
		Set xPaadm=""
		For {
			Set xPaadm=$o(^PAADMi(DischDateIndex,xDate,xPaadm))
			Quit:xPaadm=""
			Set AdmInfo=$g(^PAADM(xPaadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			
			//科室、病区
			Set (LocDesc,WardDesc)=""
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			If objAdm'="" Do objAdm.%Close()
			Set LocDesc=objAdm.Department
			Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
			Set WardDesc=objAdm.Ward
			Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
			
			Set arryLabPy=##class(DHCMed.NINF.Srv.LabTestSet).GetLabResults(xPaadm)
			For indLabPy=1:1:arryLabPy.Count() {
				Set objLabPy=arryLabPy.GetAt(indLabPy)
				Continue:'$IsObject(objLabPy)
				For indPy=1:1:objLabPy.TestResults.Count() {
					Set objPy=objLabPy.TestResults.GetAt(indPy)
					Continue:'$IsObject(objPy)
					Set PathogenyID=objPy.PathogenyID
					Set PathogenyDesc=objPy.PathogenyDesc
					Continue:PathogenyDesc=""
					Set Multires=##Class(DHCMed.NINFService.Sta.InfStaReportNew).getMapValue(PathogenyDesc,"特殊耐药菌","SpecialPYObject")
					Set:Multires="" Multires="其它"
					
					Set PyNum=PyNum+1
					For indPyAnti=1:1:objPy.DrugSenTest.Count() {
						Set objPyAnti=objPy.DrugSenTest.GetAt(indPyAnti)
						Continue:'$IsObject(objPyAnti)
						Set AntibioticsID=objPyAnti.AntibioticsID
						Set AntibioticsDesc=objPyAnti.AntibioticsDesc
						Continue:'$IsObject(objPyAnti.SenTestRst)
						Set SenTest=objPyAnti.SenTestRst.Desc
						
						Set Data=$lb(xPaadm,LocDesc,WardDesc,PyNum,PathogenyDesc,Multires,AntibioticsDesc,SenTest)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
}

ClassMethod QryLabPyAntiDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabPyAntiDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabPyAntiDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabPyAntiDtlExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-10-31
/// Description:  查询细菌培养结果(病原体信息)
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Sta.LabTestSet","QryLabRstByOrd","I","2013-01-01","2013-01-01","")
Query QryLabRstByOrd(aAdmType As %String, aFromDate As %String, aToDate As %String, aLocID As %String) As %Query(ROWSPEC = "EpisodeID:%String,LocDesc:%String,OEOrdID:%String,ArcimDesc:%String,SpecimenDesc:%String,InfectionPosDesc:%String,SubmissionDate:%String,AssayMethodDesc:%String,PathogenTestDesc:%String,PathogenyDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLabRstByOrdExecute(ByRef qHandle As %Binary, aAdmType As %String, aFromDate As %String, aToDate As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	Quit:aAdmType="" $$$OK
	
	Set LabOEItemType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfLabOEItemType","")
 	For xDate=aFromDate:1:aToDate {
		Set xOrdID=""
		For {
			Set xOrdID=$o(^OEORDi(0,"StDt",xDate,xOrdID))
			Quit:xOrdID=""
			
			Set Paadm=$p($g(^OEORD(xOrdID)),"^",1)
			Set AdmType=$p($g(^PAADM(+Paadm)),"^",2)
			Continue:(aAdmType'="")&&(aAdmType'=AdmType)
			
			Set xSubID=""
			For {
				Set xSubID=$o(^OEORDi(0,"StDt",xDate,xOrdID,xSubID))
				Quit:xSubID=""
				
				Set OrdLocID=$p($g(^OEORD(+xOrdID,"I",xSubID,1)),"^",3)
				Continue:(aLocID'="")&&(aLocID'=OrdLocID)
				Set LocDesc=$p($g(^CTLOC(+OrdLocID)),"^",2)
				Continue:LocDesc=""
				Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
				
				Set ArcimID=$p($g(^OEORD(+xOrdID,"I",xSubID,1)),"^",2)
				Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
				Set ARCItemCatID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",10)
				Set ARCItemCatDesc=$p($g(^ARC("IC",+ARCItemCatID)),"^",2)
				Set ARCItemCatType=$p($g(^ARC("IC",+ARCItemCatID)),"^",7)
				Continue:ARCItemCatType'="L"
				Continue:(LabOEItemType'="")&&(LabOEItemType'[ARCItemCatDesc)
				Set ARCICOrdCatID=$p($g(^ARC("IC",+ARCItemCatID)),"^",8)
				Set ARCICOrdCatDesc=$p($g(^OEC("ORCAT",+ARCICOrdCatID)),"^",2)
				
				Set TestSetRow=$p($g(^OEORD(+xOrdID,"I",xSubID,3)),"^",35)
				Continue:TestSetRow=""
				
				Set (SpecimenDesc,InfectionPosDesc,SubmissionDate,AssayMethodDesc,PathogenTestDesc)=""
				Set objLabPy=##class(DHCMed.NINF.Srv.LabTestSet).GetLabRstByTS(TestSetRow)
				Continue:'$IsObject(objLabPy)
				
				If $IsObject(objLabPy.Specimen) {
					Set SpecimenDesc=objLabPy.Specimen.Desc
				}
				If $IsObject(objLabPy.InfectionPos) {
					Set InfectionPosDesc=objLabPy.InfectionPos.Desc
				}
				Set SubmissionDate=objLabPy.SubmissionDate
				If $IsObject(objLabPy.AssayMethod) {
					Set AssayMethodDesc=objLabPy.AssayMethod.Desc
				}
				If $IsObject(objLabPy.PathogenTest) {
					Set PathogenTestDesc=objLabPy.PathogenTest.Desc
				}
				If objLabPy.TestResults.Count()>0 {
					For indPy=1:1:objLabPy.TestResults.Count() {
						Set objPy=objLabPy.TestResults.GetAt(indPy)
						Continue:'$IsObject(objPy)
						Set PathogenyID=objPy.PathogenyID
						Set PathogenyDesc=objPy.PathogenyDesc
						
						Set Data=$lb(xPaadm,LocDesc,xOrdID_"||"_xSubID,ArcimDesc,SpecimenDesc,InfectionPosDesc,SubmissionDate,AssayMethodDesc,PathogenTestDesc,PathogenyDesc)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				} Else {
					Set Data=$lb(xPaadm,LocDesc,xOrdID_"||"_xSubID,ArcimDesc,SpecimenDesc,InfectionPosDesc,SubmissionDate,AssayMethodDesc,PathogenTestDesc,"")
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLabRstByOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabRstByOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabRstByOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabRstByOrdExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-10-31
/// Description:  查询细菌培养+药敏实验结果
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Sta.LabTestSet","QryLabRstTstByOrd","I","2013-01-01","2013-01-01","")
Query QryLabRstTstByOrd(aAdmType As %String, aFromDate As %String, aToDate As %String, aLocID As %String) As %Query(ROWSPEC = "Paadm:%String,LocDesc:%String,OEOrdID:%String,ArcimDesc:%String,SpecimenDesc:%String,InfectionPosDesc:%String,SubmissionDate:%String,AssayMethodDesc:%String,PathogenTestDesc:%String,PathogenyDesc:%String,AntiNum:%Integer,AntibioticsDesc:%String,SenTest:%String") [ SqlProc ]
{
}

ClassMethod QryLabRstTstByOrdExecute(ByRef qHandle As %Binary, aAdmType As %String, aFromDate As %String, aToDate As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	Quit:aAdmType="" $$$OK
	
	Set LabOEItemType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfLabOEItemType","")
 	For xDate=aFromDate:1:aToDate {
		Set xOrdID=""
		For {
			Set xOrdID=$o(^OEORDi(0,"StDt",xDate,xOrdID))
			Quit:xOrdID=""
			
			Set Paadm=$p($g(^OEORD(xOrdID)),"^",1)
			Set AdmType=$p($g(^PAADM(+Paadm)),"^",2)
			Continue:(aAdmType'="")&&(aAdmType'=AdmType)
			
			Set xSubID=""
			For {
				Set xSubID=$o(^OEORDi(0,"StDt",xDate,xOrdID,xSubID))
				Quit:xSubID=""
				
				Set OrdLocID=$p($g(^OEORD(+xOrdID,"I",xSubID,1)),"^",3)
				Continue:(aLocID'="")&&(aLocID'=OrdLocID)
				Set LocDesc=$p($g(^CTLOC(+OrdLocID)),"^",2)
				Continue:LocDesc=""
				Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
				
				Set ArcimID=$p($g(^OEORD(+xOrdID,"I",xSubID,1)),"^",2)
				Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
				Set ARCItemCatID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",10)
				Set ARCItemCatDesc=$p($g(^ARC("IC",+ARCItemCatID)),"^",2)
				Set ARCItemCatType=$p($g(^ARC("IC",+ARCItemCatID)),"^",7)
				Continue:ARCItemCatType'="L"
				Continue:(LabOEItemType'="")&&(LabOEItemType'[ARCItemCatDesc)
				Set ARCICOrdCatID=$p($g(^ARC("IC",+ARCItemCatID)),"^",8)
				Set ARCICOrdCatDesc=$p($g(^OEC("ORCAT",+ARCICOrdCatID)),"^",2)
				
				Set TestSetRow=$p($g(^OEORD(+xOrdID,"I",xSubID,3)),"^",35)
				Continue:TestSetRow=""
				
				Set (SpecimenDesc,InfectionPosDesc,SubmissionDate,AssayMethodDesc,PathogenTestDesc)=""
				Set objLabPy=##class(DHCMed.NINF.Srv.LabTestSet).GetLabRstByTS(TestSetRow)
				Continue:'$IsObject(objLabPy)
				
				If $IsObject(objLabPy.Specimen) {
					Set SpecimenDesc=objLabPy.Specimen.Desc
				}
				If $IsObject(objLabPy.InfectionPos) {
					Set InfectionPosDesc=objLabPy.InfectionPos.Desc
				}
				Set SubmissionDate=objLabPy.SubmissionDate
				If $IsObject(objLabPy.AssayMethod) {
					Set AssayMethodDesc=objLabPy.AssayMethod.Desc
				}
				If $IsObject(objLabPy.PathogenTest) {
					Set PathogenTestDesc=objLabPy.PathogenTest.Desc
				}
				For indPy=1:1:objLabPy.TestResults.Count() {
					Set objPy=objLabPy.TestResults.GetAt(indPy)
					Continue:'$IsObject(objPy)
					Set PathogenyID=objPy.PathogenyID
					Set PathogenyDesc=objPy.PathogenyDesc
					
					Set AntiNum=0
					For indPyAnti=1:1:objPy.DrugSenTest.Count() {
						Set objPyAnti=objPy.DrugSenTest.GetAt(indPyAnti)
						Continue:'$IsObject(objPyAnti)
						Set AntibioticsID=objPyAnti.AntibioticsID
						Set AntibioticsDesc=objPyAnti.AntibioticsDesc
						Continue:'$IsObject(objPyAnti.SenTestRst)
						Set SenTest=objPyAnti.SenTestRst.Desc
						
						Set AntiNum=AntiNum+1
						Set Data=$lb(Paadm,LocDesc,xOrdID_"||"_xSubID,ArcimDesc,SpecimenDesc,InfectionPosDesc,SubmissionDate,AssayMethodDesc,PathogenTestDesc,PathogenyDesc,AntiNum,AntibioticsDesc,SenTest)
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLabRstTstByOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabRstTstByOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLabRstTstByOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabRstTstByOrdExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2013-01-23
/// Description:  查询细菌培养结果(病原体信息)
/// Table：       
/// Input:        IndexType(1:标本采集时间,4:结果录入时间,5:接收时间)
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Sta.LabTestSet","QryLabRstByTS","I","2013-01-01","2013-01-01","",4)
Query QryLabRstByTS(aAdmType As %String, aFromDate As %String, aToDate As %String, aLocID As %String, aIndexType As %String) As %Query(ROWSPEC = "Paadm:%String,AdmitDate:%String,DischDate:%String,AdmLoc:%String,AdmWard:%String,AdmBed:%String,PatientID:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,LocDesc:%String,OEOrdID:%String,ArcimDesc:%String,SpecimenDesc:%String,InfectionPosDesc:%String,SubmissionDate:%String,AssayMethodDesc:%String,PathogenTestDesc:%String,PathogenyDesc:%String") [ SqlProc ]
{
}

ClassMethod QryLabRstByTSExecute(ByRef qHandle As %Binary, aAdmType As %String, aFromDate As %String, aToDate As %String, aLocID As %String, aIndexType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	Quit:aAdmType="" $$$OK    //就诊类型
	//Quit:aIndexType="" $$$OK   //索引类型
	
	Set:aLocID="-" aLocID=""
	//Set:aBugID="-" aBugID=""
	//Set:aSpecID="-" aSpecID=""
	
	Set LabOEItemType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfLabOEItemType","")
 	For xDate=aFromDate:1:aToDate {
		Set xTime=""
		For {
			Set xTime=$o(^DHCMed.DC.LIS.LabReportI("IndexAuthDT",xDate,xTime))
			Quit:xTime=""
			
			Set xLabReportID=""
			For {
				Set xLabReportID=$o(^DHCMed.DC.LIS.LabReportI("IndexAuthDT",xDate,xTime,xLabReportID))
				Quit:xLabReportID=""
			
				Set objLabReport=##class(DHCMed.DC.LIS.LabReport).GetObjById(xLabReportID)
				Continue:'$IsObject(objLabReport)
				Set TestSetNo=objLabReport.TestSetNo
			
				Set EpisodeNo=##class(DHCMed.DC.LIS.LabTestSet).GetEpisodeNoByTSNo(TestSetNo)
				//医嘱主表ID
				Set OrdID=$o(^OEORD(0,"EpisNo",EpisodeNo,0))
				Continue:OrdID=""
				Set Paadm=$p($g(^OEORD(OrdID)),"^",1)
				Set AdmType=$p($g(^PAADM(+Paadm)),"^",2)
				Continue:(aAdmType'="")&&(aAdmType'=AdmType)
				
				//update by zf 20160308 数据池相关程序修改(检验)
				Set xSubID=0
				For {
					Set xSubID=$o(^OEORD(0,"EpisNo",EpisodeNo,OrdID,xSubID))
					Quit:xSubID=""
					
					Set OrdLocID=$p($g(^OEORD(+OrdID,"I",xSubID,1)),"^",3)
					Continue:(aLocID'="")&&(aLocID'=OrdLocID)
					Set LocDesc=$p($g(^CTLOC(+OrdLocID)),"^",2)
					Continue:LocDesc=""
					Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
					
					Set ArcimID=$p($g(^OEORD(+OrdID,"I",xSubID,1)),"^",2)
					Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
					Set ARCItemCatID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",10)
					Set ARCItemCatDesc=$p($g(^ARC("IC",+ARCItemCatID)),"^",2)
					Set ARCItemCatType=$p($g(^ARC("IC",+ARCItemCatID)),"^",7)
					Continue:ARCItemCatType'="L"
					Continue:(LabOEItemType'="")&&(LabOEItemType'[ARCItemCatDesc)
					Set ARCICOrdCatID=$p($g(^ARC("IC",+ARCItemCatID)),"^",8)
					Set ARCICOrdCatDesc=$p($g(^OEC("ORCAT",+ARCICOrdCatID)),"^",2)
					
					Set TestSetRow=$p($g(^OEORD(OrdID,"I",xSubID,3)),"^",35) //检验结果ID
					Continue:TestSetRow=""
			
					Set (SpecimenDesc,InfectionPosDesc,SubmissionDate,AssayMethodDesc,PathogenTestDesc)=""
					Set objLabPy=##class(DHCMed.NINF.Srv.LabTestSet).GetLabRstByTS(TestSetRow)
					Continue:'$IsObject(objLabPy)
					
					If $IsObject(objLabPy.Specimen) {
						Set SpecimenDesc=objLabPy.Specimen.Desc
					}
					If $IsObject(objLabPy.InfectionPos) {
						Set InfectionPosDesc=objLabPy.InfectionPos.Desc
					}
					Set SubmissionDate=objLabPy.SubmissionDate
					If $IsObject(objLabPy.AssayMethod) {
						Set AssayMethodDesc=objLabPy.AssayMethod.Desc
					}
					If $IsObject(objLabPy.PathogenTest) {
						Set PathogenTestDesc=objLabPy.PathogenTest.Desc
					}
					If objLabPy.TestResults.Count()>0 {
						For indPy=1:1:objLabPy.TestResults.Count() {
							Set objPy=objLabPy.TestResults.GetAt(indPy)
							Continue:'$IsObject(objPy)
							Set PathogenyID=objPy.PathogenyID
							Set PathogenyDesc=objPy.PathogenyDesc
							
							Set Data1=..BuildAdmData(Paadm)
							Set Data=Data1_$lb(LocDesc,OrdID_"||"_xSubID,ArcimDesc,SpecimenDesc,InfectionPosDesc,SubmissionDate,AssayMethodDesc,PathogenTestDesc,PathogenyDesc)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					} Else {
						Set Data1=..BuildAdmData(Paadm)
						Set Data=Data1_$lb(LocDesc,OrdID_"||"_xSubID,ArcimDesc,SpecimenDesc,InfectionPosDesc,SubmissionDate,AssayMethodDesc,PathogenTestDesc,"")
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLabRstByTSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabRstByTSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabRstByTSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabRstByTSExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2012-10-31
/// Description:  查询细菌培养+药敏实验结果
/// Table：       
/// Input:        IndexType(1:标本采集时间,4:结果录入时间,5:接收时间)
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Sta.LabTestSet","QryLabRstTestByTS","I","2013-01-01","2013-01-01","",4)
Query QryLabRstTestByTS(aAdmType As %String, aFromDate As %String, aToDate As %String, aLocID As %String, aIndexType As %String, aBugID As %String = "", aSpecID As %String = "") As %Query(ROWSPEC = "Paadm:%String,AdmitDate:%String,DischDate:%String,AdmLoc:%String,AdmWard:%String,AdmBed:%String,PatientID:%String,PapmiNo:%String,PatName:%String,PatSex:%String,PatMrNo:%String,PatAge:%String,LocDesc:%String,OEOrdID:%String,ArcimDesc:%String,SpecimenDesc:%String,InfectionPosDesc:%String,SubmissionDate:%String,AssayMethodDesc:%String,PathogenTestDesc:%String,PathogenyDesc:%String,AntiNum:%Integer,AntibioticsDesc:%String,SenTest:%String") [ SqlProc ]
{
}

ClassMethod QryLabRstTestByTSExecute(ByRef qHandle As %Binary, aAdmType As %String, aFromDate As %String, aToDate As %String, aLocID As %String, aIndexType As %String, aBugID As %String = "", aSpecID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	Quit:aAdmType="" $$$OK    //就诊类型
	//Quit:aIndexType="" $$$OK   //索引类型
	
	Set:aLocID="-" aLocID=""
	Set:(aBugID="-")||(aBugID="全部") aBugID=""
	Set:aSpecID="-" aSpecID=""
	
	Set LabOEItemType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfLabOEItemType","")
 	For xDate=aFromDate:1:aToDate {
		Set xTime=""
		For {
			Set xTime=$o(^DHCMed.DC.LIS.LabReportI("IndexAuthDT",xDate,xTime))
			Quit:xTime=""
			
			Set xLabReportID=""
			For {
				Set xLabReportID=$o(^DHCMed.DC.LIS.LabReportI("IndexAuthDT",xDate,xTime,xLabReportID))
				Quit:xLabReportID=""
			
				Set objLabReport=##class(DHCMed.DC.LIS.LabReport).GetObjById(xLabReportID)
				Continue:'$IsObject(objLabReport)
				Set TestSetNo=objLabReport.TestSetNo
			
				Set EpisodeNo=##class(DHCMed.DC.LIS.LabTestSet).GetEpisodeNoByTSNo(TestSetNo)			
				//医嘱主表ID
				Set OrdID=$o(^OEORD(0,"EpisNo",EpisodeNo,0))
				Continue:OrdID=""
				Set Paadm=$p($g(^OEORD(OrdID)),"^",1)
				Set AdmType=$p($g(^PAADM(+Paadm)),"^",2)
				Continue:(aAdmType'="")&&(aAdmType'=AdmType)
				
				//update by zf 20160308 数据池相关程序修改(检验)
				Set xSubID=0
				For {
					Set xSubID=$o(^OEORD(0,"EpisNo",EpisodeNo,OrdID,xSubID))
					Quit:xSubID=""
					
					Set OrdLocID=$p($g(^OEORD(+OrdID,"I",xSubID,1)),"^",3)
					Continue:(aLocID'="")&&(aLocID'=OrdLocID)
					Set LocDesc=$p($g(^CTLOC(+OrdLocID)),"^",2)
					Continue:LocDesc=""
					Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
					
					Set ArcimID=$p($g(^OEORD(+OrdID,"I",xSubID,1)),"^",2)
					Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)
					Set ARCItemCatID=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",10)
					Set ARCItemCatDesc=$p($g(^ARC("IC",+ARCItemCatID)),"^",2)
					Set ARCItemCatType=$p($g(^ARC("IC",+ARCItemCatID)),"^",7)
					Continue:ARCItemCatType'="L"
					Continue:(LabOEItemType'="")&&(LabOEItemType'[ARCItemCatDesc)
					Set ARCICOrdCatID=$p($g(^ARC("IC",+ARCItemCatID)),"^",8)
					Set ARCICOrdCatDesc=$p($g(^OEC("ORCAT",+ARCICOrdCatID)),"^",2)
					
					Set TestSetRow=$p($g(^OEORD(OrdID,"I",xSubID,3)),"^",35) //检验结果ID
					Continue:TestSetRow=""
					
					Set (SpecimenDesc,InfectionPosDesc,SubmissionDate,AssayMethodDesc,PathogenTestDesc)=""
					Set objLabPy=##class(DHCMed.NINF.Srv.LabTestSet).GetLabRstByTS(TestSetRow)
					Continue:'$IsObject(objLabPy)
					
					If $IsObject(objLabPy.Specimen) {
						Set SpecimenDesc=objLabPy.Specimen.Desc
						Set SpecimenCode=objLabPy.Specimen.Code
						Continue:(aSpecID'="")&&(aSpecID'="-")&&(aSpecID'=SpecimenCode)	//标本过滤
					}
					If $IsObject(objLabPy.InfectionPos) {
						Set InfectionPosDesc=objLabPy.InfectionPos.Desc
					}
					Set SubmissionDate=objLabPy.SubmissionDate
					If $IsObject(objLabPy.AssayMethod) {
						Set AssayMethodDesc=objLabPy.AssayMethod.Desc
					}
					If $IsObject(objLabPy.PathogenTest) {
						Set PathogenTestDesc=objLabPy.PathogenTest.Desc
					}
					For indPy=1:1:objLabPy.TestResults.Count() {
						Set objPy=objLabPy.TestResults.GetAt(indPy)
						Continue:'$IsObject(objPy)
						Set PathogenyID=objPy.PathogenyID
						Set PathogenyDesc=objPy.PathogenyDesc
						//Continue:(aBugID'="")&&(aBugID'="-")&&(aBugID'=PathogenyID)	//病原体过滤
						Continue:(aBugID'="")&&(aBugID'="-")&&(PathogenyDesc'[aBugID)
						
						Set AntiNum=0
						For indPyAnti=1:1:objPy.DrugSenTest.Count() {
							Set objPyAnti=objPy.DrugSenTest.GetAt(indPyAnti)
							Continue:'$IsObject(objPyAnti)
							Set AntibioticsID=objPyAnti.AntibioticsID
							Set AntibioticsDesc=objPyAnti.AntibioticsDesc
							Continue:'$IsObject(objPyAnti.SenTestRst)
							Set SenTest=objPyAnti.SenTestRst.Desc
							
							Set AntiNum=AntiNum+1
							Set Data1=..BuildAdmData(Paadm)
							Set Data=Data1_$lb(LocDesc,OrdID_"||"_xSubID,ArcimDesc,SpecimenDesc,InfectionPosDesc,SubmissionDate,AssayMethodDesc,PathogenTestDesc,PathogenyDesc,AntiNum,AntibioticsDesc,SenTest)
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					}
				}
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLabRstTestByTSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabRstTestByTSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryLabRstTestByTSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabRstTestByTSExecute ]
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

ClassMethod BuildAdmData(aPaadm As %String) As %List
{
	New (aPaadm)
	Set return=""
	Quit:aPaadm="" return
	
	Set objPaadm=##class(DHCMed.Base.PatientAdm).GetObjById(aPaadm)
	Quit:'$IsObject(objPaadm)
	Set AdmitDate=objPaadm.AdmitDate
	Set DischDate=objPaadm.DisDate
	Set AdmLoc=objPaadm.Department
	Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
	Set AdmWard=objPaadm.Ward
	Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
	Set AdmBed=objPaadm.Bed
	Set PatientID=objPaadm.PatientID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient)
	Set PapmiNo=objPatient.PapmiNo
	Set PatName=objPatient.PatientName
	Set PatSex=objPatient.Sex
	Set PatMrNo=objPatient.InPatientMrNo
	//modify by pylian 20150619 修复111177 、111178 病原体药敏结果查询年龄问题
   	Set PatAge=""                           //年龄
	If (objPatient.Age>0) {
		Set PatAge=PatAge_objPatient.Age_"岁"
	} ElseIf (objPatient.AgeMonth>0) {
		Set PatAge=PatAge_objPatient.AgeMonth_"月"
	} ElseIf (objPatient.AgeDay>0) {
		Set PatAge=PatAge_objPatient.AgeDay_"天"
	}
	
	Set return=$lb(aPaadm,AdmitDate,DischDate,AdmLoc,AdmWard,AdmBed)
	Set return=return_$lb(PatientID,PapmiNo,PatName,PatSex,PatMrNo,PatAge)
	Quit return
}

ClassMethod GetSubjectIDByCode(Code As %String) As %String
{
	n (Code)
	
	Set return=""
	Quit:Code="" return
	
	Set Code=$ZCVT(Code,"U")
	
	Set return=$o(^DHCMed.CCi("Subject",0,"CodeIndex"," "_Code,""),-1)
	
	Quit return
}

/// Creator：     liuyh
/// CreatDate：   2013-03-01
/// Description:  通过监控结果查询耐药信息
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Sta.LabTestSet","QryCtlLabDtl","2014-03-10","2014-03-18","INTCC","ResistantBacteria","",0,"MRB")
Query QryCtlLabDtl(aFromDate As %String, aToDate As %String, aSubjectIDCode As %String, aKeyWordCode As %String, aCtloc As %String, aCheckMDR As %String, aMDRKeyWordCode As %String = "MRB") As %Query(ROWSPEC = "ind:%String,xPaadm:%String,PatientName:%String,CheckDate:%String,ActDate:%String,SubmissionDate:%String,tmpResult:%String,AntiFoundList:%String,LocDesc:%String,WardDesc:%String,aSubjectID:%String,PatientID:%String,ObjectID:%String,OEItemID:%String,LastSummaryID:%String,IsMRB:%String") [ SqlProc ]
{
}

ClassMethod QryCtlLabDtlExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String, aSubjectIDCode As %String, aKeyWordCode As %String, aCtloc As %String, aCheckMDR As %String, aMDRKeyWordCode As %String = "MRB") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^Test("QryCtlLabDtlExecute")=aFromDate_","_aToDate_","_aSubjectIDCode_","_aKeyWordCode_","_aCtloc_","_aCheckMDR_","_aMDRKeyWordCode
	
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	k ^TMP("DHCMedObj")
	Set aSubjectIDCode=$ZCVT(aSubjectIDCode,"U")
	Set aKeyWordCode=$ZCVT(aKeyWordCode,"U")
	Set aMDRKeyWordCode=$ZCVT(aMDRKeyWordCode,"U")
	Quit:(aSubjectIDCode="")||(aKeyWordCode="")||(aMDRKeyWordCode="") $$$OK
	//获取感染综合监测主题ID
	Set aSubjectID=$o(^DHCMed.CCi("Subject",0,"CodeIndex"," "_aSubjectIDCode,""),-1)
	Quit:aSubjectID="" $$$OK
	
	//获取检出耐药菌关键字ID
	Set aKeyWord=$o(^DHCMed.CCi("Keyword","IndexCode"," "_aKeyWordCode,""),-1)
	//获取检出多重耐药菌关键字ID
	Set aMDRKeyWord=$o(^DHCMed.CCi("Keyword","IndexCode"," "_aMDRKeyWordCode,""),-1)
	Quit:(aKeyWord="")||(aMDRKeyWord="") $$$OK
	
	For xDate=aFromDate:1:aToDate {
		Set xPaadm=""
		For {
			Set xPaadm=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xPaadm))
			Quit:xPaadm=""
			
			Continue:'$d(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xPaadm,aSubjectID))
			Set rowid=""
			For {
				
				Set rowid=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xPaadm,aSubjectID,rowid))
				Quit:rowid=""
				
				Set obj=##class(DHCMed.CC.CtlResult).GetObjById(rowid)
				Continue:'$IsObject(obj)
				Set ActDate=obj.ActDate
				Set:ActDate'="" ActDate=$zd(ActDate,3)
				Set KeyWord=obj.KeyWord
				
				Continue:KeyWord'=aKeyWord
				
				Set ObjectID=obj.ObjectID
				Continue:ObjectID=""
				Continue:$d(^TMP("DHCMedObj",ObjectID))
				Set ^TMP("DHCMedObj",ObjectID)=""

				//update by zf 20160308 数据池相关程序修改(检验)
				Set TestSetRow=ObjectID
				Continue:TestSetRow=""
				Set objTSReport=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByID(TestSetRow)
				Continue:'$IsObject(objTSReport)
				Set TestSetRow=objTSReport.TestSetRow
				Continue:TestSetRow=""
				Set SubmissionDate=objTSReport.SubmissionDate
				Set SpecimenCode=objTSReport.SpecimenCode
				Set SpecimenDesc=objTSReport.SpecimenDesc
				Set CheckDate=objTSReport.CheckDate
				
				Set IsMRB=0
				//如果存在对应的 监控主题、多重耐药关键字、ObjectID 则表示该细菌为多重耐药菌
				Set IsMRB=($d(^DHCMed.CC.CtlResultI("Detail","IndexSubjectKeywordObjectID",aSubjectID,aMDRKeyWord," "_ObjectID))>0)
				Continue:(aCheckMDR=1)&&(IsMRB'=1)	//过滤不是多重耐药菌
				
				Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
				Continue:'$IsObject(AdmObj)
				
				Set PatientID=AdmObj.PatientID
				Set PatObj=##class(DHCMed.Base.Patient).GetObjById(PatientID)
				Continue:'$IsObject(PatObj)
				Set PatName=PatObj.PatientName
				
				Set xOrdID=$o(^OEORD(0,"Adm",xPaadm,""))
				Continue:xOrdID=""
				
				Set SubID=$o(^OEORDi(0,"LabTS",xOrdID,TestSetRow,""))
				Continue:SubID=""
				Set OEItemID=xOrdID_"||"_SubID
				
				Set OEORIOrdDeptDR=$p($g(^OEORD(+xOrdID,"I",SubID,1)),"^",3)
				Continue:OEORIOrdDeptDR=""
				Continue:(aCtloc'="")&&(aCtloc'=OEORIOrdDeptDR)
				Set objRecDep=##class(DHCMed.Base.Ctloc).GetObjById(OEORIOrdDeptDR)
				Set (LocDesc,WardDesc)=""
				If $IsObject(objRecDep){
					Set LocDesc=objRecDep.Descs
				}
				
				Set LastSummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubject",xPaadm,aSubjectID,""),-1)
				
				Set tmpResult=obj.DataValue
				Continue:(tmpResult["支原体")||(tmpResult["衣原体")
				Set AntiFoundList=obj.Summary
				Set Data=$lb(ind,xPaadm,PatName,CheckDate,ActDate,SubmissionDate,tmpResult,AntiFoundList,LocDesc,WardDesc,aSubjectID,PatientID,TestSetRow,OEItemID,LastSummaryID,IsMRB)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
				
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCtlLabDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlLabDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryCtlLabDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlLabDtlExecute ]
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

/// w ##Class(DHCMed.NINFService.Sta.LabTestSet).PrintAntiDrugInfo("fillxlSheet","329396^393836||D016||1^318324||85")
ClassMethod PrintAntiDrugInfo(itmjs As %String, strArguments As %String) As %String
{
	n (itmjs,strArguments)
    
    s Count=0
	
	s EpisodeID=$p(strArguments,"^",1)
	s TestSetRow=$p(strArguments,"^",2)
	s OEItemID=$p(strArguments,"^",3)
	q:(EpisodeID="")||(TestSetRow="")||(OEItemID="") ""
	s objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	q:'$IsObject(objAdm) ""
	s PatientID=objAdm.PatientID
	s objPat=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	q:'$IsObject(objPat) ""
	
	//update by zf 20160308 数据池相关程序修改(检验)
	//原来这段程序逻辑就有问题？这是按照原来逻辑修改的
	Set objTSReport=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByID(TestSetRow)
	Quit:'$IsObject(objTSReport) return
	Set TestSetRow=objTSReport.TestSetRow
	Quit:TestSetRow="" return
	Set SpecimenDesc=objTSReport.SpecimenDesc
	Set SpecimenDesc="1、"_SpecimenDesc
	Set CheckDate=objTSReport.CheckDate
	Set:CheckDate["-" CheckDate=$zd(CheckDate,3)
	Set Result=""	//病原体
	Set sResult=""	//抗菌药物-敏感
	Set rResult=""	//抗菌药物-耐药
	Set TSResCount=objRec.TestData.Count()
	For indTSRes=1:1:TSResCount {
		Set objTSResult=objRec.TestData.GetAt(indTSRes)
		Continue:'$IsObject(objTSResult)
		
		Set DataFormat=objTSResult.DataFormat
		Continue:DataFormat'="V"
		Set Result=objTSResult.DataText
		Continue:Result=""
		Set TestCode=objTSResult.TestCode
		Set Antibiotics=objTSResult.Antibiotics
		
		For indS=1:1:$l(Antibiotics,$c(1)) {
			Set tSen=$p(Antibiotics,$c(1),indS)
			Continue:tSen=""
			Set AntiCode=$p(Antibiotics,$c(2),1)
			Set AntiDesc=$p(Antibiotics,$c(2),2)
			Set SenTestCode=$p(Antibiotics,$c(2),3)
			Set SenTestDesc=$p(Antibiotics,$c(2),4)
			Continue:(AntiDesc="")||(SenTestDesc="")
			
			If (SenTestDesc="S")||(SenTestDesc["敏感") {
				Set sResult=sResult_"^"_AntiDesc
			}
			If (SenTestDesc="R")||(SenTestDesc["耐药") {
				Set rResult=rResult_"^"_AntiDesc
			}
		}
	}
	
	s PatientName=objPat.PatientName
	s Sex=objPat.Sex
	s Age=objPat.Age
	
	s LocDesc=objAdm.Department
	s AdmitDate=objAdm.AdmitDate
	s MrNo=objAdm.MrNo
	
	s PAADMMainMRADMDR=$p($g(^PAADM(+EpisodeID)),"^",61)
	
	s rowid=$o(^MR(+PAADMMainMRADMDR,"DIA",""),-1)
	s DiagStr=##class(DHCMed.Base.MRDiagnose).GetStringById(PAADMMainMRADMDR_"||"_rowid)
	
	s DiagInfo=$p($g(DiagStr),"^",14)
	
	s xOrdID=$p(OEItemID,"||",1)
	s xSubID=$p(OEItemID,"||",2)
	
	s RepDate=+$p($g(^OEORD(xOrdID,"I",xSubID,1)),"^",9)
	s:RepDate'="" RepDate=$zd(RepDate,3)
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(RepDate,"O","JS")_"',"_"11,5);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(CheckDate,"O","JS")_"',"_"12,5);"
	&javascript<#(retval)#>
	
	s sRow=13,tmpRow=""
	s sLen=$l(sResult,"^")
	f i=1:1:sLen  d
	.s drug=$p(sResult,"^",i)
	.q:drug=""
	.s tmpRow=tmpRow_"、"_drug
	.//s cRow=sRow+i-1
	.//q:cRow>31
	//.s retval=itmjs_"(xlSheet,'"_$ZCVT(drug,"O","JS")_"',"_cRow_",4);"
	//.&javascript<#(retval)#>
	s:tmpRow'="" tmpRow=$e(tmpRow,2,$l(tmpRow))
	s retval=itmjs_"(xlSheet,'"_$ZCVT(tmpRow,"O","JS")_"',"_14_",4);"
	&javascript<#(retval)#>
	
	s rRow=13,tmpRow=""
	s rLen=$l(rResult,"^")
	f i=1:1:rLen  d
	.s drug=$p(rResult,"^",i)
	.q:drug=""
	.s tmpRow=tmpRow_"、"_drug
	//.s cRow=rRow+i-1		//第一列为空
	//.q:cRow>31
	//.s retval=itmjs_"(xlSheet,'"_$ZCVT(drug,"O","JS")_"',"_cRow_",2);"
	//.&javascript<#(retval)#>
	s:tmpRow'="" tmpRow=$e(tmpRow,2,$l(tmpRow))
	s retval=itmjs_"(xlSheet,'"_$ZCVT(tmpRow,"O","JS")_"',"_14_",2);"
	&javascript<#(retval)#>
	
	s ds = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Rep.InfReportAnti:QrySubRec")
	d ds.Execute("",EpisodeID)
	s StartRow=16
	while(ds.Next())
	{
		s ArcimDesc=ds.Data("ArcimDesc")
		s retval=itmjs_"(xlSheet,'"_$ZCVT(ArcimDesc,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s AdminRouteDesc=ds.Data("AdminRouteDesc")
		s DoseQty=ds.Data("DoseQty")
		
		s AdminRouteDesc=AdminRouteDesc_" "_DoseQty
		
		s AdminRouteDesc=$tr(AdminRouteDesc,"*","")
		s retval=itmjs_"(xlSheet,'"_$ZCVT(AdminRouteDesc,"O","JS")_"',"_StartRow_",3);"
		&javascript<#(retval)#>
		
		s StartDate=ds.Data("StartDate")
		s StartTime=ds.Data("StartTime")
		
		s StartDate=StartDate_" "_StartTime
		
		s retval=itmjs_"(xlSheet,'"_$ZCVT(StartDate,"O","JS")_"',"_StartRow_",5);"
		&javascript<#(retval)#>
		
		
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Result,"O","JS")_"',"_"14,1);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(LocDesc,"O","JS")_"',"_"2,2);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(AdmitDate,"O","JS")_"',"_"2,4);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(MrNo,"O","JS")_"',"_"3,2);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(DiagInfo,"O","JS")_"',"_"3,4);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(PatientName,"O","JS")_"',"_"4,2);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',"_"4,4);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_"4,6);"
	&javascript<#(retval)#>
	
	s retval=itmjs_"(xlSheet,'"_$ZCVT(SpecimenDesc,"O","JS")_"',"_"11,2);"
	&javascript<#(retval)#>
	
		
	q Count
}

/// Creator：     liuyuhui
/// CreatDate：   2015-05-20
/// Description:  查询细菌培养结果(病原体信息)
/// Table：       
/// Input:        IndexType(1:标本采集时间,4:结果录入时间,5:接收时间)
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Sta.LabTestSet","QueryLab","2015-05-16","2015-05-20")
Query QueryLab(aFromDate As %String, aToDate As %String) As %Query(ROWSPEC = "LocDesc:%String,LabNum:%Integer,YXNum:%Integer") [ SqlProc ]
{
}

ClassMethod QueryLabExecute(ByRef qHandle As %Binary, aFromDate As %String, aToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Kill ^TMP("DHCMedLab")
	Set:aFromDate["/" aFromDate=$zdh(aFromDate,4)
	Set:aToDate["/" aToDate=$zdh(aToDate,4)
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Quit:(aFromDate="")||(aToDate="") $$$OK
	
	Set aIndexType=1
	Set LabOEItemType=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfLabOEItemType","")
 	For xDate=aFromDate:1:aToDate {
		Set xStatus=""
		For {
			Set xStatus=$o(^TDAY(aIndexType,xDate,xStatus))
			Quit:xStatus=""
			
			Set Epis=""
			For {
				Set Epis=$o(^TDAY(aIndexType,xDate,xStatus,Epis))
				Quit:Epis=""
				
				//医嘱主表ID
				Set OrdID=$o(^OEORD(0,"EpisNo",Epis,0))
				Continue:OrdID=""
				Set Paadm=$p($g(^OEORD(OrdID)),"^",1)
				Set AdmType=$p($g(^PAADM(+Paadm)),"^",2)
				Continue:AdmType'="I"
				
				//update by zf 20160308 数据池相关程序修改(检验)
				Set xSubID=0
				For {
					Set xSubID=$o(^OEORD(0,"EpisNo",Epis,OrdID,xSubID))
					Quit:xSubID=""
					
					Set OrdLocID=$p($g(^OEORD(+OrdID,"I",xSubID,1)),"^",3)
					Continue:OrdLocID=""
					
					Set TestSetRow=$p($g(^OEORD(OrdID,"I",xSubID,3)),"^",35) //检验结果ID
					Continue:TestSetRow=""
					
					Set objTSReport=##Class(DHCMed.DPCustom.Data.LabTestSet).GetDataByID(TestSetRow)
					Continue:'$IsObject(objTSReport)
					Set TestSetRow=objTSReport.TestSetRow
					Continue:TestSetRow=""
					
					Set ^TMP("DHCMedLab",OrdLocID,"送检")=$i(^TMP("DHCMedLab",OrdLocID,"送检"))
					
					Set TSResCount=objRec.TestData.Count()
					For indTSRes=1:1:TSResCount {
						Set objTSResult=objRec.TestData.GetAt(indTSRes)
						Continue:'$IsObject(objTSResult)
						
						Set DataFormat=objTSResult.DataFormat
						Continue:DataFormat'="V"
						Set Result=objTSResult.DataText
						Continue:Result=""
						
						//细菌培养 阳性/阴性/无结果
						Set checkFlag=##Class(DHCMed.DP.Base.ActWards).Check0("LIS-PY",Result)
						If checkFlag'="" {
							Set PathogenTestDesc="阴性"
							Continue
						} Else {
							Set PathogenTestDesc="阳性"
						}
						Set ^TMP("DHCMedLab",OrdLocID,"阳性")=$i(^TMP("DHCMedLab",OrdLocID,"阳性"))
					}
				}
			}
		}
	}
	
	Set OrdLocID=""
	For {
		Set OrdLocID=$o(^TMP("DHCMedLab",OrdLocID))
		Quit:OrdLocID=""
		
		Set LocDesc=$p($g(^CTLOC(+OrdLocID)),"^",2)
		Continue:LocDesc=""
		Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)	
		
		Set LabNum=+$g(^TMP("DHCMedLab",OrdLocID,"送检"))
		Set YXNum=+$g(^TMP("DHCMedLab",OrdLocID,"阳性"))
		
		Set Data=$lb(LocDesc,LabNum,YXNum)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QueryLabClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryLabExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryLabFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryLabExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2013-12-25
/// Description:  多重耐药菌标本类型/科室分布情况
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Sta.LabTestSet","QryLabDtlDis","2015-07-01","2015-08-04")
Query QryLabDtlDis(FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "ind:%String,xPaadm:%String,PapmiNo:%String,MrNo:%String,PatientName:%String,CheckDate:%String,SubmissionDate:%String,SubmissionDoctor:%String,SpecimenDesc:%String,tmpResult:%String,AntiFoundList:%String,LocDesc:%String,WardDesc:%String,aSubjectID:%String,PatientID:%String,ObjectID:%String,OEItemID:%String,LastSummaryID:%String,IsMRB:%String,GroupBy:%String,sum1:%Integer,sum2:%Integer,sum3:%Integer,sum4:%Integer,sum5:%Integer,sum6:%Integer,sum7:%Integer,sum8:%Integer,sum9:%Integer,sum10:%Integer") [ SqlProc ]
{
}

ClassMethod QryLabDtlDisExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK
	
	
	Set aSubjectID="10"

	//获取检出多重耐药菌关键字ID
	Set aMDRKeyWord="51"  //修改为罗湖医院的检出多重耐药菌关键字ID
	
	For xDate=FromDate:1:ToDate {
		Set xPaadm=""
		For {
			Set xPaadm=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xPaadm))
			Quit:xPaadm=""
			
			Set rowid=""
			For {
				Set rowid=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xPaadm,aSubjectID,rowid))
				Quit:rowid=""

				Set obj=##class(DHCMed.CC.CtlResult).GetObjById(rowid)
				Continue:'$IsObject(obj)
				Set KeyWord=obj.KeyWord
				Continue:KeyWord'=aMDRKeyWord
				Set ObjectID=obj.ObjectID
				Continue:ObjectID=""
				Set tmpResult=obj.DataValue
				Set tmpResult=$p($p(tmpResult,"，",1),"：",2) //中文的逗号,冒号//罗湖医院根据备注判断是否是多重耐药
			
				Set AntiFoundList=obj.Summary
				
				If $l(ObjectID,"||")=2 {
					Set xOrdID=+ObjectID
					Set SubID=+$p(ObjectID,"||",2)
					Set TestSetRow=$p($g(^OEORD(xOrdID,"I",SubID,3)),"^",35)
				} Else {
					Set TestSetRow=ObjectID
					Set xOrdID=$o(^OEORD(0,"Adm",xPaadm,""))
					Set SubID=$o(^OEORDi(0,"LabTS",+xOrdID,TestSetRow,""))
				}
				Continue:SubID=""
				Continue:TestSetRow=""
				Set OEItemID=xOrdID_"||"_SubID
				
				Set Epis=$p(TestSetRow,"||",1)
				Set TS=$p(TestSetRow,"||",2)
				Set TSCount=$p(TestSetRow,"||",3)
				Continue:(Epis="")||(TS="")||(TSCount="")
				
				Set CTLocID=$p($g(^TEPI(Epis)),"\",36)
				Set CTLocID=$tr(CTLocID,$c(10),"")
				Set CTLocID=$tr(CTLocID,$c(13),"")
				Set CTLocDesc=$p($g(^TTAB("USLOC",+CTLocID)),"\",1)
				Set:$p(CTLocDesc,"-",2)'="" CTLocDesc=$p(CTLocDesc,"-",2)
				
				
				Set AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
				Continue:'$IsObject(AdmObj)
					
				Set PatientID=AdmObj.PatientID
				Set PatObj=##class(DHCMed.Base.Patient).GetObjById(PatientID)
				Continue:'$IsObject(PatObj)
				
				Set PatName=PatObj.PatientName
				Set PapmiNo=PatObj.PapmiNo
				Set MrNo=PatObj.InPatientMrNo
				Set CheckDate=$zd(xDate,3)	//审核日期
					
				Set SubmissionDate=$p($g(^TEPI(Epis)),"\",10)	//送检日期
				Set:SubmissionDate'="" SubmissionDate=$zd(SubmissionDate,3)
				
				Set SubmissionDoctor=""
				Set DoctorCode=$p($g(^TEPI(Epis)),"\",13)	//送检医生
				Set:DoctorCode'="" SubmissionDoctor=$p($g(^TTAB("DR",DoctorCode)),"\",1)
				
				//取检验系统(LAB) 检验标本
				Set SpecCode="",SpecimenDesc=""
				/* update by zf 修改检验医嘱标本取值方法
				Set SpecDr=$o(^OEORD(+xOrdID,"I",SubID,"SPEC",""),-1)
				Set:SpecDr'="" SpecCode=$p(^OEORD(+xOrdID,"I",SubID,"SPEC",SpecDr),"^",1)
				Set:SpecCode'="" SpecimenDesc=$p(^TTAB("SPEC",SpecCode),"\",1)
				*/
				Set tSpecimenInfo=##class(DHCMed.SSIO.FromHisSrv).GetOrdSpecimen(xOrdID_"||"_SubID)
				Set SpecDr=$p(tSpecimenInfo,"^",1)
				Set SpecCode=$p(tSpecimenInfo,"^",2)
				Set SpecimenDesc=$p(tSpecimenInfo,"^",3)
				
				Set OEORIOrdDeptDR=$p($g(^OEORD(+xOrdID,"I",SubID,1)),"^",3)
				Continue:OEORIOrdDeptDR=""
				//Continue:(aCtloc'="")&&(aCtloc'=OEORIOrdDeptDR)
				Set objRecDep=##class(DHCMed.Base.Ctloc).GetObjById(OEORIOrdDeptDR)
				Set (LocDesc,WardDesc)=""
				If $IsObject(objRecDep){
					Set LocDesc=objRecDep.Descs
				}
				
				Set LastSummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubject",xPaadm,aSubjectID,""),-1)
				Set GroupBy=xPaadm_tmpResult_SpecimenDesc
				Set (sum1,sum2,sum3,sum4,sum5,sum6,sum7,sum8,sum9,sum10)=0
			    //需根据医院的监控条件进行修改
				If (tmpResult["ESBLs大肠埃希菌"){
					Set sum1=1
				}
				ElseIf (tmpResult["ESBLs肺炎克雷伯菌"){
					Set sum2=1
				}
				Elseif (tmpResult["CRE"){
					Set sum3=1
				}
				Elseif (tmpResult["MRS"){
					Set sum4=1
				}
				Elseif (tmpResult["MDR-PA"){
					Set sum5=1
				}
				Elseif (tmpResult["PDR-PA"){
					Set sum6=1
				}
				Elseif (tmpResult["CR-AB"){
					Set sum7=1
				}
				Elseif (tmpResult["VRE"){
					Set sum8=1
				}
				Elseif (tmpResult["CR-PA"){
					Set sum9=1
				}
				Elseif (tmpResult["PDR-AB"){
					Set sum10=1
				}
				
				Set Data=$lb(ind,xPaadm,PapmiNo,MrNo,PatName,CheckDate,SubmissionDate,SubmissionDoctor,SpecimenDesc,tmpResult,AntiFoundList,CTLocDesc,WardDesc,aSubjectID,PatientID,ObjectID,OEItemID,LastSummaryID,IsMRB,GroupBy,sum1,sum2,sum3,sum4,sum5,sum6,sum7,sum8,sum9,sum10)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLabDtlDisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlLabDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabDtlDisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlLabDtlExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2013-12-26
/// Description:  多重耐药菌发生率
/// Table：       
/// Input:        
/// do ##class(%ResultSet).RunQuery("DHCMed.NINFService.Sta.LabTestSet","QryLabDtlOcc","2015-07-01","2015-08-04")
Query QryLabDtlOcc(FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "ind:%String,Groupstr:%String,Sum1:%Integer,Sum2:%Integer,Sum3:%Integer,Sum4:%Integer,Sum5:%Integer,Sum6:%Integer") [ SqlProc ]
{
}

ClassMethod QryLabDtlOccExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK
	
	
	Set aSubjectID="10"

	//获取检出耐药菌关键字ID
	Set aMDRKeyWord="50"
	
	For xDate=FromDate:1:ToDate {
		Set xPaadm=""
		For {
			Set xPaadm=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xPaadm))
			Quit:xPaadm=""
			
			Set rowid=""
			For {
				Set rowid=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",xDate,xPaadm,aSubjectID,rowid))
				Quit:rowid=""

				Set obj=##class(DHCMed.CC.CtlResult).GetObjById(rowid)
				Continue:'$IsObject(obj)
				Set KeyWord=obj.KeyWord
				
				Continue:KeyWord'=aMDRKeyWord
				
				Set ObjectID=obj.ObjectID
				Continue:ObjectID=""
				Set tmpResult=obj.DataValue
				Continue:tmpResult["培养结果"
				Set AntiFoundList=obj.Summary
				
				If $l(ObjectID,"||")=2 {
					Set xOrdID=+ObjectID
					Set SubID=+$p(ObjectID,"||",2)
					Set TestSetRow=$p($g(^OEORD(xOrdID,"I",SubID,3)),"^",35)
				} Else {
					Set TestSetRow=ObjectID
					Set xOrdID=$o(^OEORD(0,"Adm",xPaadm,""))
				
					Set Epis=$p(TestSetRow,"||",1)
					Set TS=$p(TestSetRow,"||",2)
					Set TSCount=$p(TestSetRow,"||",3)
					Continue:(Epis="")||(TS="")||(TSCount="")
					Set TestSetRow=Epis_"||"_TS_"||"_TSCount
					Set SubID=$o(^OEORDi(0,"LabTS",+xOrdID,TestSetRow,""))
					
				}
				Continue:SubID=""
				Continue:TestSetRow=""
				Set OEItemID=xOrdID_"||"_SubID
			
				//取检验系统(LAB) 检验标本
				Set SpecCode="",SpecimenDesc=""
				/* update by zf 修改检验医嘱标本取值方法
				Set SpecDr=$o(^OEORD(+xOrdID,"I",SubID,"SPEC",""),-1)
				Set:SpecDr'="" SpecCode=$p(^OEORD(+xOrdID,"I",SubID,"SPEC",SpecDr),"^",1)
				Set:SpecCode'="" SpecimenDesc=$p(^TTAB("SPEC",SpecCode),"\",1)
				*/
				Set tSpecimenInfo=##class(DHCMed.SSIO.FromHisSrv).GetOrdSpecimen(xOrdID_"||"_SubID)
				Set SpecDr=$p(tSpecimenInfo,"^",1)
				Set SpecCode=$p(tSpecimenInfo,"^",2)
				Set SpecimenDesc=$p(tSpecimenInfo,"^",3)
				
				Set LastSummaryID=$o(^DHCMed.CC.CtlResultI("Summary","IndexEpisodeSubject",xPaadm,aSubjectID,""),-1)
				Set Groupstr=xPaadm_tmpResult_SpecimenDesc
                //需根据医院的监控条件进行修改
				Set (Sum1,Sum2,Sum3,Sum4,Sum5,Sum6)=0
				If (tmpResult["大肠埃希菌"){
					Set Sum1=1
				}
				Elseif (tmpResult["肺炎克雷伯菌"){
					Set Sum2=1
				}
				Elseif (tmpResult["金黄色葡萄球菌"){
					Set Sum3=1
				}
				Elseif (tmpResult["铜绿假单胞菌"){
					Set Sum4=1
				}
				Elseif (tmpResult["鲍曼不动杆菌"){
					Set Sum5=1
				}
				Elseif (tmpResult["肠球菌"){
					Set Sum6=1
				}
				Set Data=$lb(ind,Groupstr,Sum1,Sum2,Sum3,Sum4,Sum5,Sum6)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			
		}
	}
	
	Quit $$$OK
}

ClassMethod QryLabDtlOccClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCtlLabDtlExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabDtlOccFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCtlLabDtlExecute ]
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

/// Creator：     jiangpengpeng
/// CreatDate：   2013-12-27
/// Description:  打印多重耐药菌
/// 
ClassMethod QueryLabDtloPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	s Count=0
	s DateFrom=$p(strArguments,"^",1)
	s DateTo=$p(strArguments,"^",2)
	s SubjectCode=$p(strArguments,"^",3)
	s KeyWordCode=$p(strArguments,"^",4)
	s LocID=$p(strArguments,"^",5)
	s checkMDR=$p(strArguments,"^",6)
	s MRB="MRB"
	s Last=""
	
	s PrintFlag="Y" //$p(strArguments,"^",7) 此标志为"Y"，说明为导出或打印调用Query，Query中write函数不调用
	
	s ds = ##class(%Library.ResultSet).%New("DHCMed.NINFService.Sta.LabTestSet:QryCtlLabDtl")
	d ds.Execute(DateFrom,DateTo,SubjectCode,KeyWordCode,LocID,checkMDR,MRB,Last)
	s StartRow=4
	while(ds.Next())
	{
		s PatientName=ds.Data("PatientName")
		s CheckDate=ds.Data("CheckDate")
		s SubmissionDate=ds.Data("SubmissionDate")
		s LocDesc=ds.Data("LocDesc")
		s tmpResult=ds.Data("tmpResult")
		s IsMRB=ds.Data("IsMRB")
		s IsMRBDesc="否"
		S:IsMRB="1" IsMRBDesc="是"		
		s AntiFoundList=ds.Data("AntiFoundList")
		s MrNo=ds.Data("MrNo")
		s SpecimenDesc=ds.Data("SpecimenDesc")
		s Bed=ds.Data("Bed")
		s StartDate=ds.Data("StartDate")
		
		s valCells=MrNo_$c(1)_PatientName_$c(1)_Bed_$c(1)_CheckDate_$c(1)_SubmissionDate_$c(1)_LocDesc_$c(1)_tmpResult_$c(1)_SpecimenDesc_$c(1)_IsMRBDesc_$c(1)_StartDate_$c(1)_AntiFoundList
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	
	//打印标题
	s valCells="罗湖人民医院多重耐药菌报告统计"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',1,1);"
	&javascript<#(retval)#>
	//打印 ”统计日期：2009-00-00 至 2009-00-00”
	//s valCells="统计日期："_$zd(DateFrom,3)_" 至 "_$zd(DateTo,3)_"    合计:"_Count_"份"
	//$zd($zdh("27/01/2009",4),3)   从“27/11/2009” 到“2009-11-27”
	s valCells="开始日期："_DateFrom_"   结束日期："_ DateTo_"           合计:"_Count_"份"
	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',2,1);"
	&javascript<#(retval)#>
	q Count
}

}
