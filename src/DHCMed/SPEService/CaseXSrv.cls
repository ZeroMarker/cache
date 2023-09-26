/// ClassName:    DHCMed.SPEService.CaseXSrv
/// Description:  特殊患者筛查 相关服务
/// Creator：     zhufei
/// CreatDate:    2019-03-04
Class DHCMed.SPEService.CaseXSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCMed.SPEService.CaseXSrv).ProcessCaseX("!46^0^11^334^9","^")
ClassMethod ProcessCaseX(aInputStr As %String, aSeparete As %String = "^") As %String
{
	New (aInputStr,aSeparete)
	Set return=0
	Quit:aInputStr="" return
	Set length=$l(aInputStr,"!")
	
	Set Count=0,Num=0
	For index=1:1:length {
		Set InputStrNew=$P(aInputStr,"!",index)
		Set ID          =  	$p(InputStrNew,aSeparete,1)
		Set Status      =   $p(InputStrNew,aSeparete,2)
		Set Opinion	    =   $p(InputStrNew,aSeparete,3)
		Set EvalLoc	    = 	$p(InputStrNew,aSeparete,4)
		Set EvalUser    = 	$p(InputStrNew,aSeparete,5)
		Set EvalDate    =   +$h
		Set EvalTime    =   $p($h,",",2)
		Continue:(ID="")||(Status="")
		//Quit:(ID="")||(Status="") return
	
		Set LnkPatID=""
		If Status=1 {								// Status是特殊患者操作状态
			Set objCaseX=##class(DHCMed.SPE.CaseX).GetObjById(ID)
			Continue:'$IsObject(objCaseX)
			//Quit:'$IsObject(objCaseX) return
			Continue:'$IsObject(objCaseX.CXPatTypeDr)
			//Quit:'$IsObject(objCaseX.CXPatTypeDr) return
			
			Set EpisodeID = objCaseX.CXEpisodeID
			Set PatTypeDr = objCaseX.CXPatTypeDr.%Id()
			Set LnkPatID  = objCaseX.CXLnkPatID
			
			Set InputStr=""
			Set $p(InputStr,"^",1) = LnkPatID     //ID
			Set $p(InputStr,"^",2) = EpisodeID    //就诊号
			Set $p(InputStr,"^",3) = PatTypeDr    //特殊患者类型
			Set $p(InputStr,"^",4) = EvalLoc     //责任科室
			Set $p(InputStr,"^",5) = EvalUser     //责任人
			Set $p(InputStr,"^",6) = ""           //备注信息
			Set $p(InputStr,"^",7) = Opinion      //处置意见
			Set $p(InputStr,"^",8) = EvalDate     //标记日期
			Set $p(InputStr,"^",9) = EvalTime     //标记时间
			Set $p(InputStr,"^",10)= "1"          //标记状态
			Set $p(InputStr,"^",11)= ""     
			Set $p(InputStr,"^",12)= ""         
			Set $p(InputStr,"^",13)= ""
			Set $p(InputStr,"^",14)= ""   
			Set $p(InputStr,"^",15)= ""          
			Set $p(InputStr,"^",16)= ""
			Set $p(InputStr,"^",17)= EvalUser     //操作人
			Set $p(InputStr,"^",18)= 2            //1:临床科室 2:管理科
			Set flg=##class(DHCMed.SPEService.PatientsSrv).SaveSpeOper(InputStr)
			Set:(+flg<1) Count=Count+1
			Set:(+flg)>0 LnkPatID=flg	
			Set:(+flg>0) Num=Num+1	
		}Else{
			
			Set objCaseX=##class(DHCMed.SPE.CaseX).GetObjById(ID)
			Continue:'$IsObject(objCaseX)
			//Quit:'$IsObject(objCaseX) return
			Continue:'$IsObject(objCaseX.CXPatTypeDr)
			//Quit:'$IsObject(objCaseX.CXPatTypeDr) return
			
			Set EpisodeID = objCaseX.CXEpisodeID
			Set PatTypeDr = objCaseX.CXPatTypeDr.%Id()
			Set LnkPatID  = objCaseX.CXLnkPatID
			If (LnkPatID) {
				Set objPat = ##class(DHCMed.SPE.Patients).GetObjById(LnkPatID)
				Continue:'$IsObject(objPat)
				Continue:'$IsObject(objPat.PSCurrStatus)
				Set CurrStatus = objPat.PSCurrStatus.Code
				If (CurrStatus'=0) {
					Set InputStr=""
					Set $p(InputStr,"^",1) = LnkPatID     //ID
					Set $p(InputStr,"^",2) = EpisodeID    //就诊号
					Set $p(InputStr,"^",3) = PatTypeDr    //特殊患者类型
					Set $p(InputStr,"^",4) = EvalLoc     //责任科室
					Set $p(InputStr,"^",5) = EvalUser     //责任人
					Set $p(InputStr,"^",6) = ""           //备注信息
					Set $p(InputStr,"^",7) = Opinion      //处置意见
					Set $p(InputStr,"^",8) = EvalDate     //标记日期
					Set $p(InputStr,"^",9) = EvalTime     //标记时间
					Set $p(InputStr,"^",10)= "0"          //标记状态
					Set $p(InputStr,"^",11)= ""     
					Set $p(InputStr,"^",12)= ""         
					Set $p(InputStr,"^",13)= ""
					Set $p(InputStr,"^",14)= ""   
					Set $p(InputStr,"^",15)= ""          
					Set $p(InputStr,"^",16)= ""
					Set $p(InputStr,"^",17)= EvalUser     //操作人
					Set $p(InputStr,"^",18)= 2            //1:临床科室 2:管理科
					Set flg=##class(DHCMed.SPEService.PatientsSrv).SaveSpeOper(InputStr)
					Set:(+flg<1) Count=Count+1
					Set:(+flg)>0 LnkPatID=flg	
					Set:(+flg>0) Num=Num+1
				}Else {
					Set Num=Num+1
				}
			}Else {
				Set Num=Num+1
			}
			
		}
	
		Set obj=##class(DHCMed.SPE.CaseX).%OpenId(ID)
		Continue:'$IsObject(obj)
		//Quit:'$IsObject(obj) return
		Set obj.CXStatus 	 = Status
		Set obj.CXOpinion    = Opinion
		Set obj.CXEvalDate   = EvalDate
		Set obj.CXEvalTime   = EvalTime
		Set obj.CXEvalLoc    = EvalLoc
		Set obj.CXEvalUser   = EvalUser
		Set obj.CXLnkPatID   = LnkPatID

		Set sc=obj.%Save()
		If $system.Status.IsError(sc) {        //检查Save是否成功
	   		Do $system.OBJ.DisplayError(sc) 
	   		Set return=-1
		}Else{
			Set return=obj.%Id()	
		}
		Do obj.%Close()
		
	}
	Set return=Num_"/"_Count
	Quit return
}

/// Creator：     liuzhenhe
/// CreatDate：   2019-01-24
/// Description:  查询筛查的重点病人
/// Table：       DHCMed.SPE.CaseX
/// Input：       aAdmStatus：就诊状态（在院A、出院D）
///               aScreenItems：筛查项目 多个项目逗号分隔
///               aHospIDs：医院IDs
///               aLocID：科室ID
///               aWardID：病区ID
///               aDateFrom：开始日期
///               aDateTo：结束日期
/// Others:  	  返回ROWSPEC
/// D ##class(%ResultSet).RunQuery("DHCMed.SPEService.CaseXSrv","QryCaseXList","2,3","2019-01-01","2019-05-31","CC05","A,D","","")
Query QryCaseXList(aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aScreenItems As %String, aAdmStatus As %String = "", aLocID As %String = "", aWard As %String = "") As %Query(ROWSPEC = "CaseXID:%String,ScreeningID:%String,ScreeningDesc:%String,PatTypeID:%String,PatTypeDesc:%String,StatusCode:%String,StatusDesc:%String,EpisodeID:%String,PatientID:%String,RegNo:%String,PatientName:%String,Sex:%String,Age:%String,AdmType:%String,AdmitDate:%String,LocID:%String,LocDesc:%String,WardID:%String,WardDesc:%String,Room:%String,Bed:%String,DoctorID:%String,DoctorName:%String,SpePatInfo:%String,DischDate:%String,DischTime:%String,VisitStatus:%String,Opinion:%String,PatientStatus:%String")
{
}

ClassMethod QryCaseXListExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateFrom As %String, aDateTo As %String, aScreenItems As %String, aAdmStatus As %String = "", aLocID As %String = "", aWard As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)
 	Set:aDateFrom>+$h aDateFrom=+$h
 	Set:aDateTo>+$h aDateTo=+$h
 	Quit:(aDateFrom="")||(aDateTo="") $$$OK
 	Quit:aScreenItems="" $$$OK
 	
 	Set ScreenItemList=$ListFromString(aScreenItems,",")
 	Set xItemID=""
 	For {
	 	Set xItemID=$o(^DHCMed.SPE.CaseXI("IndexScreenDate",xItemID))
	 	Quit:xItemID=""
	 	Set objItem=##class(DHCMed.SPE.Screening).GetObjById(xItemID)
	 	Continue:'$IsObject(objItem)
	 	Set ItemCode=objItem.BTCode
	 	Continue:$listfind(ScreenItemList,ItemCode)<1
	 
		
	 	Set xDate=aDateFrom-1
	 	For {
	 			Set xDate=$o(^DHCMed.SPE.CaseXI("IndexScreenDate",xItemID,xDate))
	 			Quit:xDate=""
	 			Quit:xDate>aDateTo
	 		
	 			Set xID=0
	 			For {
		 			Set xID=$o(^DHCMed.SPE.CaseXI("IndexScreenDate",xItemID,xDate,xID))
		 			Quit:xID=""
		 		
		 			Set objCaseX=##class(DHCMed.SPE.CaseX).GetObjById(xID)
		 			Continue:'$IsObject(objCaseX)
		 			Continue:'$IsObject(objCaseX.CXScreeningDr)
		 			Set Opinion=objCaseX.CXOpinion	 				// 2019
					Set ScreeningID=objCaseX.CXScreeningDr.%Id()
					Set ScreeningDesc=objCaseX.CXScreeningDr.BTDesc
					Set PatTypeID="",PatTypeDesc=""
					If $IsObject(objCaseX.CXPatTypeDr){
						Set PatTypeID=objCaseX.CXPatTypeDr.%Id()
						Set PatTypeDesc=objCaseX.CXPatTypeDr.PTSDesc
					}
		 			Set EpisodeID=objCaseX.CXEpisodeID
		 			Continue:EpisodeID=""
		 			Set VisitStatus=$p($g(^PAADM(EpisodeID)),"^",20)
		 			Continue:(aAdmStatus'="")&&((","_aAdmStatus_",")'[(","_VisitStatus_","))
		 			Set VisitStatus= $s(VisitStatus="D":"出院",VisitStatus="A":"在院",1:"")
		 			//过滤科室、病区、医院
		 			// Set LocID=objCaseX.CXActLoc  //科室ID
					Set LocID=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID).DepartmentID // 不从DHCMed.SPE.CaseX获取科室ID，从DHCMed.Base.PatientAdm获取患者的科室ID
		 			Continue:(aLocID'="")&&(aLocID'=LocID)	//aLocID是传入的科室				

		 			//Set WardID=objCaseX.CXActWard			//病区ID
		 			//Continue:(aWardID'="")&&(aWardID'=WardID)	//aWardID是传入的科室
		 			//统一病区筛查维度
		 			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
					Continue:'$IsObject(objAdm) 
					Continue:objAdm.AdmType'="I" 
					Set PatientID=objAdm.PatientID
					Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
					Continue:'$IsObject(objPatient) 
					Set AdmWard=objAdm.Ward
					Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
					Continue:(aWard'="")&&(aWard'=AdmWard)	//aWard是传入的科室
	
		 			If (aHospIDs'=""){
			 			Set flg=##class(DHCMed.SSService.HospitalSrv).CheckHospital(LocID,aHospIDs)
			 			Continue:flg<1
		 			}
		 		
					Set Data=..BuildCaseXData(objCaseX)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data_$lb(VisitStatus)
					Set ind=ind+1
	 		}
	 	}
	 
	}
 	
	Quit $$$OK
}

ClassMethod QryCaseXListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCaseXListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCaseXListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCaseXListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 构建特殊患者筛查数据
ClassMethod BuildCaseXData(objCaseX As %String) As %List
{
	New (objCaseX)
	Set return=""
	Quit:'$IsObject(objCaseX) return
	Quit:'$IsObject(objCaseX.CXScreeningDr) return
	
	Set $ZT="BuildDataErr"
	
	
	Set CaseXID=objCaseX.%Id()
	Set Opinion=objCaseX.CXOpinion					//2019
	Set ScreeningID=objCaseX.CXScreeningDr.%Id()
	Set ScreeningDesc=objCaseX.CXScreeningDr.BTDesc
	Set PatTypeID="",PatTypeDesc=""
	If $IsObject(objCaseX.CXPatTypeDr){
		Set PatTypeID=objCaseX.CXPatTypeDr.%Id()
		Set PatTypeDesc=objCaseX.CXPatTypeDr.PTSDesc
	}
	Set EpisodeID=objCaseX.CXEpisodeID
	Set CXStatus=objCaseX.CXStatus
	Set CXStatusDesc=$s(CXStatus=1:"标记",CXStatus=0:"排除",1:"未处置") ///该确认为标记
	
	Set (PatientID,RegNo,PatientName,Sex,PatientAge,AdmitDate,Room,Bed,AdmType,LocDesc,WardDesc)=""
	Set (PatTypes,LocID,WardID,DoctorID,DoctorName)=""
	
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
	Quit:'$IsObject(objAdm) return
	Quit:objAdm.AdmType'="I" return
	Set PatientID=objAdm.PatientID
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	Quit:'$IsObject(objPatient) return
	
	//统一调用年龄计算方法
   	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set AdmDate=$p(AdmDateTime,"^",1)
	Set AdmTime=$p(AdmDateTime,"^",2)
	Set PatientAge=##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,AdmDate,AdmTime)
	Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
	Set:AdmTime'="" AdmTime=$zt(AdmTime,2)
	
	Set DischDateTime= ##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(EpisodeID)
	Set DischDate=$p(DischDateTime,"^",1)
	Set DischTime=$p(DischDateTime,"^",2)
	Set:DischDate'="" DischDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DischDate)
	Set:DischTime'="" DischTime=$zt(DischTime,2)
		
	Set AdmLoc=objAdm.Department
	Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
	Set AdmWard=objAdm.Ward
	Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
	
	Set SepPatInfo=""
	If PatTypeID'="" {
		Set xSPatID=0
		For {
			Set xSPatID=$o(^DHCMed.SPEi("Pat",0,"IndexAdmPatType",EpisodeID,PatTypeID,xSPatID))
			Quit:xSPatID=""
			

			Set objSpe=##class(DHCMed.SPE.Patients).GetObjById(xSPatID)
			Continue:'$IsObject(objSpe)
			Set objStatus=objSpe.PSCurrStatus
			Continue:'$IsObject(objStatus)
			Set StatusCode=objStatus.Code 
			//Continue:StatusCode="0"	//"0"作废
			Set objPatType=objSpe.PSPatTypeDr
			Continue:'$IsObject(objPatType)
			
			Set SepPatRow=""
			Set $p(SepPatRow,"^",1)=xSPatID
			Set $p(SepPatRow,"^",2)=objStatus.Code
			Set $p(SepPatRow,"^",3)=objStatus.Description
			Set $p(SepPatRow,"^",4)=objPatType.PTSDesc  // 名称
			Set CXStatus=objCaseX.CXStatus
			If (CXStatus=1){
				Set $p(SepPatRow,"^",5)=objPatType.PTSIcon	//图标定义
				}
			Elseif (CXStatus=0){
				Set $p(SepPatRow,"^",5)=$P(objPatType.PTSIcon,".",1)_"_N.png"	//图标定义
				}
			
			If SepPatInfo'="" {
				Set SepPatInfo=SepPatInfo_$c(1)_SepPatRow
			} Else {
				Set SepPatInfo=SepPatRow
			}
		}
	}
	Set PatientStatus= $p(SepPatInfo,"^",3)
	
	Set Data=$lb("")
	Set $li(Data,1)  = CaseXID
	Set $li(Data,2)  = ScreeningID
	Set $li(Data,3)  = ScreeningDesc
	Set $li(Data,4)  = PatTypeID
	Set $li(Data,5)  = PatTypeDesc
	Set $li(Data,6)  = CXStatus
	Set $li(Data,7)  = CXStatusDesc
	Set $li(Data,8)  = EpisodeID
	Set $li(Data,9)  = PatientID
	Set $li(Data,10) = objPatient.PapmiNo
	Set $li(Data,11) = objPatient.PatientName
	Set $li(Data,12) = objPatient.Sex
	Set $li(Data,13) = PatientAge
	Set $li(Data,14) = objAdm.AdmType
	Set $li(Data,15) = AdmDate
	Set $li(Data,16) = objAdm.DepartmentID
	Set $li(Data,17) = AdmLoc
	Set $li(Data,18) = objAdm.WardID
	Set $li(Data,19) = AdmWard
	Set $li(Data,20) = objAdm.Room
	Set $li(Data,21) = objAdm.Bed
	Set $li(Data,22) = objAdm.DoctorID
	Set $li(Data,23) = objAdm.DoctorName
	Set $li(Data,24) = SepPatInfo
	Set $li(Data,25) = DischDate
	Set $li(Data,26) = DischTime
	Set $li(Data,27) = Opinion
	Set $li(Data,28) = PatientStatus   
	Quit Data
	
BuildDataErr
	Write "Error:"_$ZERROR,!
	Quit ""
}

}
