/// 报表工具使用的Query
Class DHCMed.NINFService.Sta.InfStaReportNew Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// w ##Class(DHCMed.NINFService.Sta.InfStaReportNew).Test()
ClassMethod Test()
{
	s %ZIndex=$zn
	s %JIndex=$j
	s %NIndex="Test"
	w %ZIndex,!
	w %JIndex,!
	
	k ^TMP(%ZIndex,%JIndex,%NIndex)
	s flg=##Class(DHCMed.NINFService.Sta.InfStaReportNew).getMapDiagnos("I63.902","常见疾病","CommonDisease")
	w flg,!
	s flg=##Class(DHCMed.NINFService.Sta.InfStaReportNew).getMapDiagnos("I63.902","疾病分类","TypeDisease")
	w flg,!
	s flg=##Class(DHCMed.NINFService.Sta.InfStaReportNew).getMapValue("儿科","科室类别","DepType")
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
					If Value1'="" {
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
			If objDepGrpConf.ConfigItems'="" {
				If objDepGrpConf.ConfigItems'="" {
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
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.InfStaReportNew","QryDischPatList",1,"2012-10-01","2012-10-30")
Query QryDischPatList(Type As %String, FromDate As %String, ToDate As %String) As %Query(ROWSPEC = "科室:%String,病区:%String,ICD:%String,诊断:%String,疾病类别:%String,是否手术:%Integer,切口等级:%String,科室类别:%String,常见病种:%String,疾病分类:%String,Paadm:%String") [ SqlProc ]
{
}

ClassMethod QryDischPatListExecute(ByRef qHandle As %Binary, Type As %String, FromDate As %String, ToDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryDischPatList"
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
			Set Data=$$BuildQryDischPat(xPaadm,Type)
			Continue:Data=""
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
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
	
	//是否手术、切口等级
	Set IsOperation=0,CuteType=""
	Set OpeInfo=..GetOperation(Paadm)
	Set IsOperation=($p(OpeInfo,"^",2)'="")
	Set CuteType=$p(OpeInfo,"^",3)
	Set:CuteType="" CuteType="无"
	
	Set Data=""
	Set $li(Data,1)=LocDesc            //就诊科室名称
	Set $li(Data,2)=WardDesc           //就诊病区名称
	Set $li(Data,3)=ICD10              //临床诊断ICD10
	Set $li(Data,4)=ICDDesc            //临床诊断名称
	Set $li(Data,5)=ICDType            //临床诊断疾病类别
	Set $li(Data,6)=IsOperation        //是否手术
	Set $li(Data,7)=CuteType           //切口等级
	Set $li(Data,8)=DepGroup           //就诊科室类别
	Set $li(Data,9)=CommDiagnos        //常见疾病
	Set $li(Data,10)=TypeDiagnos       //疾病分类
	Set $li(Data,11)=Paadm             //就诊号
	
	Quit Data
}

ClassMethod QryDischPatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDischPatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDischPatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDischPatListExecute ]
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

/// 查询院内感染部位信息
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.InfStaReportNew","QryInfPosList","2012-10-01","2012-10-30",1)
Query QryInfPosList(FromDate As %String, ToDate As %String, Type As %String) As %Query(ROWSPEC = "Paadm:%String,ReportID:%String,部位:%String,侵害性操作:%String,感染诊断:%String,病原体和药敏:%String,科室:%String,病区:%String,主要诊断ICD:%String,主要诊断名称:%String,易感因素:%String,科室类别:%String,常见病种:%String,疾病分类:%String,是否手术:%Integer,切口等级:%String,是否手术感染:%Integer") [ SqlProc ]
{
}

ClassMethod QryInfPosListExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, Type As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3)
	Quit:(FromDate="")||(ToDate="") $$$OK
	
	Set %ZIndex=$zn,%JIndex=$j,%NIndex="QryInfPosList"
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Set listRep=##class(DHCMed.NINF.Srv.InfReport).GetInfRepList(FromDate,ToDate,"")
	For indRep=1:1:$listlength(listRep) {
		Set ReportID=$list(listRep,indRep)
		Continue:ReportID=""
		
		Set objRep=##class(DHCMed.NINF.Srv.InfReport).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.ReportStatus)
		Set RepStatus=objRep.ReportStatus.Code
		Continue:RepStatus'="3" //已审
		
		Do BuildQryInfPosList(objRep)
	}
	
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
	
BuildQryInfPosList(objRep)
	New (objRep,repid,ind,%ZIndex,%JIndex,%NIndex)
	
	Set Paadm=objRep.EpisodeID
	Set ReportID=objRep.ReportID
	Quit:'$IsObject(objRep.ReportLoc) return
	
	//科室、病区、科室类别
	Set (LocDesc,WardDesc,DepGroup)=""
	Set LocDesc=objRep.ReportLoc.Desc
	Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	Set DepDesc=objRep.ReportLoc.Desc
	Set DepGroup=..getMapValue(DepDesc,"科室类别","DepType")
	Set:DepGroup="" DepGroup="其它"
	If $IsObject(objRep.ReportWard) {
		Set WardDesc=objRep.ReportWard.Desc
		Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	}
	
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
	For indInfFactors=1:1:objRep.InfFactors.Count() {
		Set objInfFactors=objRep.InfFactors.GetAt(indInfFactors)
		Continue:'$IsObject(objInfFactors)
		Set InfFactors=InfFactors_","_objInfFactors.Desc
	}
	Set:InfFactors'="" InfFactors=$e(InfFactors,2,$l(InfFactors))
	
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
		
		Set IsOperInfPat=0
		Set:InfPosDesc["表浅切口" IsOperInfPat=1
		Set:InfPosDesc["深部切口" IsOperInfPat=1
		Set:(InfPosDesc["器官")&&(InfPosDesc["腔隙") IsOperInfPat=1
		Set:InfPosDesc["手术部位" IsOperInfPat=1
		
		//侵害性操作
		For indInfPosOpr=1:1:objInfPos.InfPosOpr.Count() {
			Set objInfPosOpr=objInfPos.InfPosOpr.GetAt(indInfPosOpr)
			Continue:$IsObject(objInfPosOpr)
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
		
		//是否手术、切口等级
		Set IsOperation=0,CuteType=""
		Set OpeInfo=..GetOperation(Paadm)
		Set IsOperation=($p(OpeInfo,"^",2)'="")
		Set CuteType=$p(OpeInfo,"^",3)
		Set:CuteType="" CuteType="无"
		
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
		Set $li(Data,13)=CommDiagnos   //常见疾病
		Set $li(Data,14)=TypeDiagnos   //疾病分类
		Set $li(Data,15)=IsOperation   //是否手术
		Set $li(Data,16)=CuteType      //手术切口
		Set $li(Data,17)=IsOperInfPat  //是否手术感染
		
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit
}

ClassMethod QryInfPosListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPosListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPosListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPosListExecute ]
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
ClassMethod GetOperation(Paadm As %String)
{
	New (Paadm)
	Set return=""
	
	Set strOperation=""
	//获取统计取手术位置
	Set OperTypeFlag=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("NINFInfGetStatOperType","")
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
	}
	Set return=strOperation
	
	Quit return
}

/// 查询某一时间段报告过的易感因素
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.InfStaReportNew","QryInfFactors","2012-01-01","2012-10-31",1)
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
	
	Set listRep=##class(DHCMed.NINF.Srv.InfReport).GetInfRepList(FromDate,ToDate,"")
	For indRep=1:1:$listlength(listRep) {
		Set ReportID=$list(listRep,indRep)
		Continue:ReportID=""
		
		Set objRep=##class(DHCMed.NINF.Srv.InfReport).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.ReportStatus)
		Set RepStatus=objRep.ReportStatus.Code
		Continue:RepStatus'="3" //已审
		
		Do BuildQryInfFactors(objRep)
	}
	
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
	
BuildQryInfFactors(objRep)
	New (objRep,repid,ind,%ZIndex,%JIndex,%NIndex)
	
	Set Paadm=objRep.EpisodeID
	Set ReportID=objRep.ReportID
	Quit:'$IsObject(objRep.ReportLoc) return
	
	//科室、病区、科室类别
	Set (LocDesc,WardDesc,DepGroup)=""
	Set LocDesc=objRep.ReportLoc.Desc
	Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	Set DepDesc=objRep.ReportLoc.Desc
	Set DepGroup=..getMapValue(DepDesc,"科室类别","DepType")
	Set:DepGroup="" DepGroup="其它"
	If $IsObject(objRep.ReportWard) {
		Set WardDesc=objRep.ReportWard.Desc
		Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	}
	
	//易感因素
	For indInfFactors=1:1:objRep.InfFactors.Count() {
		Set objInfFactors=objRep.InfFactors.GetAt(indInfFactors)
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
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.InfStaReportNew","QryInfPosToLabPy","2012-10-01","2012-10-30",1)
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
	
	Set listRep=##class(DHCMed.NINF.Srv.InfReport).GetInfRepList(FromDate,ToDate,"")
	For indRep=1:1:$listlength(listRep) {
		Set ReportID=$list(listRep,indRep)
		Continue:ReportID=""
		
		Set objRep=##class(DHCMed.NINF.Srv.InfReport).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.ReportStatus)
		Set RepStatus=objRep.ReportStatus.Code
		Continue:RepStatus'="3" //已审
		
		Do BuildQryInfPosToLabPy(objRep)
	}
	
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
	
BuildQryInfPosToLabPy(objRep)
	New (objRep,repid,ind,%ZIndex,%JIndex,%NIndex)
	
	Set Paadm=objRep.EpisodeID
	Set ReportID=objRep.ReportID
	Quit:'$IsObject(objRep.ReportLoc) return
	
	//科室、病区、科室类别
	Set (LocDesc,WardDesc,DepGroup)=""
	Set LocDesc=objRep.ReportLoc.Desc
	Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	Set DepDesc=objRep.ReportLoc.Desc
	Set DepGroup=..getMapValue(DepDesc,"科室类别","DepType")
	Set:DepGroup="" DepGroup="其它"
	If $IsObject(objRep.ReportWard) {
		Set WardDesc=objRep.ReportWard.Desc
		Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	}
	
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
/// Do ##class(%Library.ResultSet).RunQuery("DHCMed.NINFService.Sta.InfStaReportNew","QryInfLabPy","2012-10-01","2012-10-31",1)
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
	
	Set listRep=##class(DHCMed.NINF.Srv.InfReport).GetInfRepList(FromDate,ToDate,"")
	For indRep=1:1:$listlength(listRep) {
		Set ReportID=$list(listRep,indRep)
		Continue:ReportID=""
		
		Set objRep=##class(DHCMed.NINF.Srv.InfReport).GetObjById(ReportID)
		Continue:'$IsObject(objRep)
		Continue:'$IsObject(objRep.ReportStatus)
		Set RepStatus=objRep.ReportStatus.Code
		Continue:RepStatus'="3" //已审
		
		Do BuildQryInfLabPy(objRep)
	}
	
	Kill ^TMP(%ZIndex,%JIndex,%NIndex)
	
	Quit $$$OK
	
BuildQryInfLabPy(objRep)
	New (objRep,repid,ind,%ZIndex,%JIndex,%NIndex)
	
	Set Paadm=objRep.EpisodeID
	Set ReportID=objRep.ReportID
	Quit:'$IsObject(objRep.ReportLoc) return
	
	//科室、病区、科室类别
	Set (LocDesc,WardDesc,DepGroup)=""
	Set LocDesc=objRep.ReportLoc.Desc
	Set:LocDesc["-" LocDesc=$p(LocDesc,"-",2)
	Set DepDesc=objRep.ReportLoc.Desc
	Set DepGroup=..getMapValue(DepDesc,"科室类别","DepType")
	Set:DepGroup="" DepGroup="其它"
	If $IsObject(objRep.ReportWard) {
		Set WardDesc=objRep.ReportWard.Desc
		Set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
	}
	
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
