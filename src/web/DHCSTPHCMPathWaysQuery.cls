/// Creator: bianshuai
/// CreateDate: 2014-06-20
/// Descript: 临床路径
Class web.DHCSTPHCMPathWaysQuery Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-06-25
/// Description:  临床路径相关信息
/// Return:       $lb() 或 ""
ClassMethod BuildCPWData(argPathWayID As %String, argSelect As %String, argCpwDicID As %String) As %List
{
	New (argPathWayID,argSelect,argCpwDicID)
	Set return=""
	Set obj=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(argPathWayID)
	If $IsObject(obj) {
		Set MRAdm=obj.CPWMRADMDR
		Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
		If $IsObject(obj.CPWPathwayDR)
		{
			Set PathwayDR=obj.CPWPathwayDR.%Id()
			Set PathWayDesc=obj.CPWPathwayDR.CPWDesc
			Set PathWayCode=obj.CPWPathwayDR.CPWCode  //2014-06-25 bianshuai
			Set RefCost=obj.CPWPathwayDR.CPWCost
			Set RefDays=obj.CPWPathwayDR.CPWDays
		}

		Quit:(argCpwDicID'="")&&(argCpwDicID'=PathWayCode) ""  //过滤临床路径 2014-06-25 bianshuai
		If $IsObject(obj.CPWPathwayEpStepDR)
		{
			Set EpStepDR=obj.CPWPathwayEpStepDR.%Id()
			Set EPStepDesc=obj.CPWPathwayEpStepDR.CPWSDesc
			Set PathWayEpDR=$p(EpStepDR,"||",1)_"||"_$p(EpStepDR,"||",2)
			Set objPathWayEp=##class(web.DHCCPW.MRC.PathWayEp).GetObjById(PathWayEpDR)
			If $IsObject(objPathWayEp)
			{
				Set PathWayEpDesc=objPathWayEp.EPDesc
			}
		}
		Set Status=obj.CPWStatus
		Set StatusDesc=$s(Status="I":"入径",Status="O":"出径",Status="C":"完成",1:"ERROR")
		Set InDoctorDR=obj.CPWInDoctorDR
		Set:InDoctorDR'="" InDoctorDesc=$p($g(^CTPCP(InDoctorDR,1)),"^",2)
		Set InDate=obj.CPWInDate
		Set InTime=obj.CPWInTime
		Set:InDate'="" InDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(+InDate) ;$zd(+InDate,3)
		Set:InTime'="" InTime=$zt(+InTime,2)
		Set OutDoctorDR=obj.CPWOutDoctorDR
		Set:OutDoctorDR'="" OutDoctorDesc=$p($g(^CTPCP(OutDoctorDR,1)),"^",2)
		Set OutDate=obj.CPWOutDate
		Set OutTime=obj.CPWOutTime
		Set:OutDate'="" OutDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(+OutDate) ;$zd(+OutDate,3)
		Set:OutTime'="" OutTime=$zt(+OutTime,2)
		If $IsObject(obj.CPWOutReasonDR)
		{
			Set OutReasonDR=obj.CPWOutReasonDR.%Id()
			Set OutReasonDesc=obj.CPWOutReasonDR.VRDesc
		}
		Set UpdateUserDR=obj.CPWUpdateUserDR
		Set:UpdateUserDR'="" UpdateUserDesc=$p($g(^SSU("SSUSR",UpdateUserDR)),"^",2)
		Set UpdateDate=obj.CPWUpdateDate
		Set UpdateTime=obj.CPWUpdateTime
		Set:UpdateDate'="" UpdateDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(+UpdateDate) ;$zd(+UpdateDate,3)
		Set:UpdateTime'="" UpdateTime=$zt(+UpdateTime,2)
		Set Comments=obj.CPWComments
		Set:Comments'="" OutReasonDesc=OutReasonDesc_","_Comments
		Set VarInfo=##Class(web.DHCCPW.MR.ClinPathWaysVariance).GetVarInfo(argPathWayID)
		If VarInfo'="" {
			Set VarCount=$list(VarInfo,1)
			Set VarReason=$list(VarInfo,2)
		}Else{
			Set VarCount=0
			Set VarReason=""
		}
		
		//路径信息
		Set Data=$lb($g(argPathWayID))
		Set Data=Data_$lb($g(Paadm))
		Set Data=Data_$lb($g(PathwayDR))
		Set Data=Data_$lb($g(PathWayDesc))
		Set Data=Data_$lb($g(PathWayEpDR))
		Set Data=Data_$lb($g(PathWayEpDesc))
		Set Data=Data_$lb($g(EpStepDR))
		Set Data=Data_$lb($g(EPStepDesc))
		Set Data=Data_$lb($g(Status))
		Set Data=Data_$lb($g(StatusDesc))
		Set Data=Data_$lb($g(InDoctorDR))
		Set Data=Data_$lb($g(InDoctorDesc))
		Set Data=Data_$lb($g(InDate))
		Set Data=Data_$lb($g(InTime))
		Set Data=Data_$lb($g(OutDoctorDR))
		Set Data=Data_$lb($g(OutDoctorDesc))
		Set Data=Data_$lb($g(OutDate))
		Set Data=Data_$lb($g(OutTime))
		Set Data=Data_$lb($g(OutReasonDR))
		Set Data=Data_$lb($g(OutReasonDesc))
		Set Data=Data_$lb($g(UpdateUserDR))
		Set Data=Data_$lb($g(UpdateUserDesc))
		Set Data=Data_$lb($g(UpdateDate))
		Set Data=Data_$lb($g(UpdateTime))
		Set Data=Data_$lb($g(Comments))
		Set Data=Data_$lb($g(RefCost))
		Set Data=Data_$lb($g(RefDays))
		Set Data=Data_$lb($g(VarCount))
		Set Data=Data_$lb($g(VarReason))
		
		Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
	    If $IsObject(objPaadm)
	    {
		    If $IsObject(objPaadm.PAADMPAPMIDR)
		    {
			    Set objPatient=objPaadm.PAADMPAPMIDR
			    Set PatientID=objPatient.%Id()
			    //Set PapmiNo=objPatient.PAPMINo
			    Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
			    Set PatName=objPatient.PAPMIName
			    Set:$IsObject(objPatient.PAPMISexDR) Sex=objPatient.PAPMISexDR.CTSEXDesc
			    Set Birthday=objPatient.PAPMIDOB
			    ///Set:Birthday'="" Age=##Class(web.DHCCPW.MR.SysBaseSrv).CalAge(+Birthday,+$h)
			    ///Set:Birthday'="" Birthda=$zd(Birthday,3)
			    Set Age=##class(web.DHCBillInterface).GetPapmiAge(PatientID,Paadm) //by qunianpeng 2016/10/14
			    Set PersonalID=objPatient.PAPMIID
			}
			
		    Set AdmitDate=objPaadm.PAADMAdmDate
		    Set AdmitTime=objPaadm.PAADMAdmTime
		    Set DisDate=objPaadm.PAADMDischgDate
		    Set DisTime=objPaadm.PAADMDischgTime
		    If DisDate'="" {
			    Set AdmDays=DisDate-AdmitDate
		    } Else {
				Set AdmDays=+$h-AdmitDate
			}
		    Set:AdmitDate'="" AdmitDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(AdmitDate) ;$zd(AdmitDate,3)
		    Set:AdmitTime'="" AdmitTime=$zt(AdmitTime,1)
		    Set:DisDate'="" DisDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(DisDate) ;$zd(DisDate,3)
		    Set:DisTime'="" DisTime=$zt(DisTime,1)
		    If $IsObject(objPaadm.PAADMDepCodeDR)
		    {
			    Set AdmLoc=objPaadm.PAADMDepCodeDR.CTLOCDesc
			    Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
			}
		    If $IsObject(objPaadm.PAADMCurrentWardDR)
		    {
			    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDDesc
			    Set:$p(AdmWard,"-",2)'="" AdmWard=$p(AdmWard,"-",2)
			}
			If $IsObject(objPaadm.PAADMCurrentRoomDR)
			{
				Set AdmRoom=objPaadm.PAADMCurrentRoomDR.ROOMDesc
			}
			If $IsObject(objPaadm.PAADMCurrentBedDR)
			{
				Set AdmBed=objPaadm.PAADMCurrentBedDR.BEDCode
			}
			If $IsObject(objPaadm.PAADMAdmDocCodeDR)
			{
				Set AdmDoc=objPaadm.PAADMAdmDocCodeDR.CTPCPDesc
			}
			Set AdmStatus=objPaadm.PAADMVisitStatus
		}
		Set strCost=##Class(web.DHCCPW.MR.Interface).GetAdmCateFee(Paadm)
		Set CountCost=+$p(strCost,"^",1)  //住院总费用
		Set DrugCost=+$p(strCost,"^",2)   //药费
		If (CountCost'=0)&&(DrugCost'=0) {                //药费比例
			Set DrugRatio=$fn((DrugCost/CountCost)*100,"",2)_"%"
		} Else {
			Set DrugRatio="00.00%"
		}
		Set:CountCost'="" CountCost=$fn(CountCost,"",2)
		Set:DrugCost'="" DrugCost=$fn(DrugCost,"",2)
		
		Set ErrFlag=""
		Set tmpRefCost=+$p(RefCost,"-",2)
		Set:tmpRefCost=0 tmpRefCost=+RefCost
    	If (tmpRefCost'=0)&&(tmpRefCost<CountCost) {
	    	Set ErrFlag=1
	    }
	    Set tmpRefDays=+$p(RefDays,"-",2)
		Set:tmpRefDays=0 tmpRefDays=+RefDays
    	If (tmpRefDays'=0)&&(tmpRefDays<AdmDays) {
	    	Set ErrFlag=2
	    }
	    
		//Set EpisodeID=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)	// Add by zhaoyu 2013-04-01 更改病案号取值
		//Set InMedicare=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)	// Add by zhaoyu 2013-04-01 更改病案号取值
		Set InMedicare=##class(web.DHCCPW.MR.SysBaseSrv).GetInMedicare("",Paadm)	// Note by zhaoyu 2013-04-01 更改病案号取值
		
		//费用增减率=(实际费用-参考费用)/参考费用
		Set CostRatio="-",CostFlag="-"
		If (CountCost>0) {
			Set RefCostMin=+$p(RefCost,"-",1)
			Set RefCostMax=+$p(RefCost,"-",2)
			If RefCostMin>RefCostMax {
				Set RefCostMin=+$p(RefCost,"-",2)
				Set RefCostMax=+$p(RefCost,"-",1)
			}
			If (RefCostMin>0)&&(CountCost<RefCostMin) {
				Set CostRatio=$fn(((CountCost-RefCostMin)/RefCostMin)*100,"",2)_"%"
				Set CostFlag="↓"
			}
			If (RefCostMax>0)&&(CountCost>RefCostMax) {
				Set CostRatio=$fn(((CountCost-RefCostMax)/RefCostMax)*100,"",2)_"%"
				Set CostFlag="↑"
			}
		}
		//天数增减率=(实际天数-参考天数)/参考天数
		Set DaysRatio="-",DaysFlag="-"
		If (AdmDays>0) {
			Set RefDaysMin=+$p(RefDays,"-",1)
			Set RefDaysMax=+$p(RefDays,"-",2)
			If RefDaysMin>RefDaysMax {
				Set RefDaysMin=+$p(RefDays,"-",2)
				Set RefDaysMax=+$p(RefDays,"-",1)
			}
			If (RefDaysMin>0)&&(AdmDays<RefDaysMin) {
				Set DaysRatio=$fn(((AdmDays-RefDaysMin)/RefDaysMin)*100,"",2)_"%"
				Set DaysFlag="↓"
			}
			If (RefDaysMax>0)&&(AdmDays>RefDaysMax) {
				Set DaysRatio=$fn(((AdmDays-RefDaysMax)/RefDaysMax)*100,"",2)_"%"
				Set DaysFlag="↑"
			}
		}
		
		//就诊信息
	    Set Data=Data_$lb($g(PatientID))
	    Set Data=Data_$lb($g(PapmiNo))
	    Set Data=Data_$lb($g(InMedicare))
	    Set Data=Data_$lb($g(PatName))
	    Set Data=Data_$lb($g(Sex))
	    Set Data=Data_$lb($g(Birthday))
	    //Set Data=Data_$lb($g(Birthda))
	    Set Data=Data_$lb($g(Age))
	    Set Data=Data_$lb($g(PersonalID))
    	Set Data=Data_$lb($g(AdmitDate))
    	Set Data=Data_$lb($g(AdmitTime))
    	Set Data=Data_$lb($g(DisDate))
    	Set Data=Data_$lb($g(DisTime))
    	Set Data=Data_$lb($g(AdmLoc))
    	Set Data=Data_$lb($g(AdmWard))
    	Set Data=Data_$lb($g(AdmRoom))
    	Set Data=Data_$lb($g(AdmBed))
    	Set Data=Data_$lb($g(AdmDoc))
    	Set Data=Data_$lb($g(AdmStatus))
    	Set Data=Data_$lb($g(AdmDays))
    	Set Data=Data_$lb($g(CountCost))
    	Set Data=Data_$lb($g(DrugRatio))
	    Set Data=Data_$lb($g(ErrFlag))
	    Set Data=Data_$lb($g(CostRatio))
	    Set Data=Data_$lb($g(DaysRatio))
	    Set Data=Data_$lb($g(CostFlag))
	    Set Data=Data_$lb($g(DaysFlag))
	    
	    If argSelect["Y" {
		    If (ErrFlag=1)||(ErrFlag=2) {
		    	Set return=Data
		    } Else {
			    Set return=""
			}
		}Else{
			Set return=Data
		}
	}
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2010-06-25
/// Description:  以入径日期为主索引查询临床路径出入径记录
/// Input：       DateFrom(开始日期),DateTo(结束日期),Status(入径:I、出径:O、完成:C),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCSTPHCMPathWaysQuery","QryCPWByInDate","2014-06-1","2014-06-1","","","","N")
Query QryCPWByInDate(argDateFrom As %String, argDateTo As %String, argStatus As %String, argLocID As %String, argWardID As %String, argSelect As %String, argCpwDicID As %String) As %Query(ROWSPEC = "Rowid:%String,Paadm:%String,PathwayDR:%String,PathWayDesc:%String,PathWayEpDR:%String,PathWayEpDesc:%String,EpStepDR:%String,EPStepDesc:%String,Status:%String,StatusDesc:%String,InDoctorDR:%String,InDoctorDesc:%String,InDate:%String,InTime:%String,OutDoctorDR:%String,OutDoctorDesc:%String,OutDate:%String,OutTime:%String,OutReasonDR:%String,OutReasonDesc:%String,UpdateUserDR:%String,UpdateUserDesc:%String,UpdateDate:%String,UpdateTime:%String,Comments:%String,RefCost:%String,RefDays:%String,VarCount:%String,VarReason:%String,PatientID:%String,PapmiNo:%String,InMedicare:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmStatus:%String,AdmDays:%String,CountCost:%String,DrugRatio:%String,ErrFlag:%String,CostRatio:%String,DaysRatio:%String,CostFlag:%String,DaysFlag:%String")
{
}

ClassMethod QryCPWByInDateExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argStatus As %String, argLocID As %String, argWardID As %String, argSelect As %String, argCpwDicID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,1)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,1)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK

	//Index IndexInDate On (CPWInDate, CPWInTime);
	//^DHCMRi("CPW",0,"IndexInDate",61884,59220,1)
	For InDate=argDateFrom:1:argDateTo {
		Set InTime=0
		For {
			Set InTime=$o(^DHCMRi("CPW",0,"IndexInDate",InDate,InTime))
			Quit:InTime=""
			Set Rowid=0
			For {
				Set Rowid=$o(^DHCMRi("CPW",0,"IndexInDate",InDate,InTime,Rowid))
				Quit:Rowid=""
				
				Set (Paadm,CPWStatus,AdmLoc,AdmWard)=""
				Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(Rowid)

				If $IsObject(objPathWay)
				{
					Set MRAdm=objPathWay.CPWMRADMDR
					Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
					Set CPWStatus=objPathWay.CPWStatus
				}
	
				Continue:(argStatus'="")&&(argStatus'=CPWStatus)

				Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
				If objPaadm'="" Do objPaadm.%Close()
				If $IsObject(objPaadm)
				{
					If $IsObject(objPaadm.PAADMDepCodeDR)
				    {
					    Set AdmLoc=objPaadm.PAADMDepCodeDR.%Id()
					}
				    If $IsObject(objPaadm.PAADMCurrentWardDR)
				    {
					    If $IsObject(objPaadm.PAADMCurrentWardDR.WARDLocationDR)
					    {
						    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDLocationDR.%Id()
						}
					}
				}
				Continue:(argLocID'="")&&(argLocID'=AdmLoc)
				Continue:(argWardID'="")&&(argWardID'=AdmWard)

				Set Data=..BuildCPWData(Rowid,argSelect,argCpwDicID)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCPWByInDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWByInDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWByInDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWByInDateExecute ]
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
/// CreatDate：   2010-07-20
/// Description:  以出径日期为主索引查询临床路径出入径记录
/// Input：       DateFrom(开始日期),DateTo(结束日期),Status(入径:I、出径:O、完成:C),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysQuery","QryCPWByOutDate","2010-01-01","2010-07-20","","","","N")
Query QryCPWByOutDate(argDateFrom As %String, argDateTo As %String, argStatus As %String, argLocID As %String, argWardID As %String, argSelect As %String, argCpwDicID As %String) As %Query(ROWSPEC = "Rowid:%String,Paadm:%String,PathwayDR:%String,PathWayDesc:%String,PathWayEpDR:%String,PathWayEpDesc:%String,EpStepDR:%String,EPStepDesc:%String,Status:%String,StatusDesc:%String,InDoctorDR:%String,InDoctorDesc:%String,InDate:%String,InTime:%String,OutDoctorDR:%String,OutDoctorDesc:%String,OutDate:%String,OutTime:%String,OutReasonDR:%String,OutReasonDesc:%String,UpdateUserDR:%String,UpdateUserDesc:%String,UpdateDate:%String,UpdateTime:%String,Comments:%String,RefCost:%String,RefDays:%String,VarCount:%String,VarReason:%String,PatientID:%String,PapmiNo:%String,InMedicare:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmStatus:%String,AdmDays:%String,CountCost:%String,DrugRatio:%String,ErrFlag:%String,CostRatio:%String,DaysRatio:%String,CostFlag:%String,DaysFlag:%String")
{
}

ClassMethod QryCPWByOutDateExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argStatus As %String, argLocID As %String, argWardID As %String, argSelect As %String, argCpwDicID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,1)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,1)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	//Index IndexOutDate On (CPWOutDate As Exact, CPWOutTime As Exact);
	//^DHCMRi("CPW",0,"IndexOutDate",61884,59220,1)
	For OutDate=argDateFrom:1:argDateTo {
		Set OutTime=0
		For {
			Set OutTime=$o(^DHCMRi("CPW",0,"IndexOutDate",OutDate,OutTime))
			Quit:OutTime=""
			Set Rowid=0
			For {
				Set Rowid=$o(^DHCMRi("CPW",0,"IndexOutDate",OutDate,OutTime,Rowid))
				Quit:Rowid=""
				
				Set (Paadm,CPWStatus,AdmLoc,AdmWard)=""
				Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(Rowid)
				If $IsObject(objPathWay)
				{
					Set MRAdm=objPathWay.CPWMRADMDR
					Set Paadm=##class(web.DHCCPW.MR.PAADMSrv).GetEpisodeID(MRAdm)
					Set CPWStatus=objPathWay.CPWStatus
				}
				Continue:(argStatus'="")&&(argStatus'=CPWStatus)
				
				Set objPaadm=##Class(User.PAAdm).%OpenId(Paadm)
				If objPaadm'="" Do objPaadm.%Close()
				If $IsObject(objPaadm)
				{
					If $IsObject(objPaadm.PAADMDepCodeDR)
				    {
					    Set AdmLoc=objPaadm.PAADMDepCodeDR.%Id()
					}
				    If $IsObject(objPaadm.PAADMCurrentWardDR)
				    {
					    If $IsObject(objPaadm.PAADMCurrentWardDR.WARDLocationDR)
					    {
						    Set AdmWard=objPaadm.PAADMCurrentWardDR.WARDLocationDR.%Id()
						}
					}
				}
				Continue:(argLocID'="")&&(argLocID'=AdmLoc)
				Continue:(argWardID'="")&&(argWardID'=AdmWard)
				
				Set Data=..BuildCPWData(Rowid,argSelect,argCpwDicID)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCPWByOutDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWByOutDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWByOutDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWByOutDateExecute ]
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
/// CreatDate：   2010-09-25
/// Description:  以出院日期为主索引查询临床路径出入径记录
/// Input：       DateFrom(开始日期),DateTo(结束日期),Status(入径:I、出径:O、完成:C),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysQuery","QryCPWByDischDate","2010-09-26","2010-09-26","","","","N")
Query QryCPWByDischDate(argDateFrom As %String, argDateTo As %String, argStatus As %String, argLocID As %String, argWardID As %String, argSelect As %String, argCpwDicID As %String) As %Query(ROWSPEC = "Rowid:%String,Paadm:%String,PathwayDR:%String,PathWayDesc:%String,PathWayEpDR:%String,PathWayEpDesc:%String,EpStepDR:%String,EPStepDesc:%String,Status:%String,StatusDesc:%String,InDoctorDR:%String,InDoctorDesc:%String,InDate:%String,InTime:%String,OutDoctorDR:%String,OutDoctorDesc:%String,OutDate:%String,OutTime:%String,OutReasonDR:%String,OutReasonDesc:%String,UpdateUserDR:%String,UpdateUserDesc:%String,UpdateDate:%String,UpdateTime:%String,Comments:%String,RefCost:%String,RefDays:%String,VarCount:%String,VarReason:%String,PatientID:%String,PapmiNo:%String,InMedicare:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmStatus:%String,AdmDays:%String,CountCost:%String,DrugRatio:%String,ErrFlag:%String,CostRatio:%String,DaysRatio:%String,CostFlag:%String,DaysFlag:%String")
{
}

ClassMethod QryCPWByDischDateExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argStatus As %String, argLocID As %String, argWardID As %String, argSelect As %String, argCpwDicID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,1)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,1)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	//^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})

	For DischDate=argDateFrom:1:argDateTo {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi("DischDate",DischDate,Paadm))
			Quit:Paadm=""
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set AdmLoc=$p(AdmInfo,"^",4)
			Continue:(argLocID'="")&&(AdmLoc'=argLocID)     //科室过滤
			Set AdmWard=$p(AdmInfo,"^",70)
			Set:AdmWard'="" AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)  //add by zf 2012-07-06
			Continue:(argWardID'="")&&(AdmWard'=argWardID)  //病区过滤
			Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
			Continue:MRAdm=""
			Set PathWayID=0
			For {
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID))
				Quit:PathWayID=""
				
				If argStatus'="" {
					Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
					If $IsObject(objPathWay) {
						Set CPWStatus=objPathWay.CPWStatus
					}
					If objPathWay'="" Do objPathWay.%Close()
					Continue:(argStatus'="")&&(argStatus'=CPWStatus)  //路径状态过滤
				}
				
				Set Data=..BuildCPWData(PathWayID,argSelect,argCpwDicID)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCPWByDischDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWByDischDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWByDischDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWByDischDateExecute ]
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
/// CreatDate：   2010-09-25
/// Description:  以入院日期为主索引查询临床路径出入径记录
/// Input：       DateFrom(开始日期),DateTo(结束日期),Status(入径:I、出径:O、完成:C),LocID(科室),WardID(病区)
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysQuery","QryCPWByAdmDate","2010-09-26","2010-09-26","","","","N")
Query QryCPWByAdmDate(argDateFrom As %String, argDateTo As %String, argStatus As %String, argLocID As %String, argWardID As %String, argSelect As %String, argCpwDicID As %String) As %Query(ROWSPEC = "Rowid:%String,Paadm:%String,PathwayDR:%String,PathWayDesc:%String,PathWayEpDR:%String,PathWayEpDesc:%String,EpStepDR:%String,EPStepDesc:%String,Status:%String,StatusDesc:%String,InDoctorDR:%String,InDoctorDesc:%String,InDate:%String,InTime:%String,OutDoctorDR:%String,OutDoctorDesc:%String,OutDate:%String,OutTime:%String,OutReasonDR:%String,OutReasonDesc:%String,UpdateUserDR:%String,UpdateUserDesc:%String,UpdateDate:%String,UpdateTime:%String,Comments:%String,RefCost:%String,RefDays:%String,VarCount:%String,VarReason:%String,PatientID:%String,PapmiNo:%String,InMedicare:%String,PatName:%String,Sex:%String,Birthday:%String,Age:%String,PersonalID:%String,AdmitDate:%String,AdmitTime:%String,DisDate:%String,DisTime:%String,AdmLoc:%String,AdmWard:%String,AdmRoom:%String,AdmBed:%String,AdmDoc:%String,AdmStatus:%String,AdmDays:%String,CountCost:%String,DrugRatio:%String,ErrFlag:%String,CostRatio:%String,DaysRatio:%String,CostFlag:%String,DaysFlag:%String")
{
}

ClassMethod QryCPWByAdmDateExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argStatus As %String, argLocID As %String, argWardID As %String, argSelect As %String, argCpwDicID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,1)
	Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
	Set:argDateFrom'="" argDateFrom=+argDateFrom
	Set:argDateTo["/" argDateTo=$zdh(argDateTo,1)
	Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
	Set:argDateTo'="" argDateTo=+argDateTo
	Quit:(argDateFrom="")||(argDateTo="") $$$OK
	
	//^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
	For AdmDate=argDateFrom:1:argDateTo {
		Set Paadm=0
		For {
			Set Paadm=$o(^PAADMi("PAADM_AdmDate",AdmDate,Paadm))
			Quit:Paadm=""
			Set AdmInfo=$g(^PAADM(Paadm))
			Continue:$p(AdmInfo,"^",2)'="I"           //就诊类型过滤
			Continue:$p(AdmInfo,"^",20)="C"           //就诊状态过滤
			Set AdmLoc=$p(AdmInfo,"^",4)
			Continue:(argLocID'="")&&(AdmLoc'=argLocID)     //科室过滤
			Set AdmWard=$p(AdmInfo,"^",70)
			Set:AdmWard'="" AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)  //add by zf 2012-07-06
			Continue:(argWardID'="")&&(AdmWard'=argWardID)  //病区过滤
			Set MRAdm=##class(web.DHCCPW.MR.PAADMSrv).GetMRAdm(Paadm)
			Continue:MRAdm=""
			Set PathWayID=0
			For {
				Set PathWayID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MRAdm,PathWayID))
				Quit:PathWayID=""
				
				If argStatus'="" {
					Set objPathWay=##Class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(PathWayID)
					If $IsObject(objPathWay) {
						Set CPWStatus=objPathWay.CPWStatus
					}
					If objPathWay'="" Do objPathWay.%Close()
					Continue:(argStatus'="")&&(argStatus'=CPWStatus)  //路径状态过滤
				}
				
				Set Data=..BuildCPWData(PathWayID,argSelect,argCpwDicID)
				Continue:Data=""
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	
	Quit $$$OK
}

ClassMethod QryCPWByAdmDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCPWByAdmDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCPWByAdmDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCPWByAdmDateExecute ]
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

/// 描述：根据EpisodeID获取病案号
/// 入参：EpisodeID 就诊ID
/// 正确返回值：病案号
/// 异常返回值：-10:入参为空 -1:错误信息 -2:病案卷不存在 -3:非住院病人 -4:无效病案 -5:卷无效 -7:就诊不存在 -8:病案号为空 -9:卷病案号为空
/// Debug:w ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)
/// Modified by wuqk 2013-05-15
/// 增加入参，用于返回错误信息
/// 入参：EpisodeID: 就诊ID
///       ErrMsg   : 返回错误信息
/// 返回值：病案号,如果出现错误，返回空
/// Debug:Set MrNo = ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID,.ErrMsg)
ClassMethod IGetMrNoByEpisodeID(EpisodeID As %String, ByRef ErrMsg As %String) As %String
{
	New (EpisodeID,ErrMsg)
	
	Set ErrMsg = "-10:入参为空"
	Set MrNo = ""
	Quit:EpisodeID="" MrNo
	
	Set ErrMsg = "-7:就诊不存在"
	Quit:'$d(^PAADM(EpisodeID)) MrNo ;就诊不存在
	
	Set $ZT="IGetMrNoByEpisodeIDError"
	
	//add by zf 2013-12-04
	//增加新生儿的病案号取值
	Set MotherDr=$p($g(^PAADM(EpisodeID)),"^",75)  //母亲分娩记录对应就诊号
	If MotherDr'="" {
		Set MrNo=##class(web.DHCWMRService).GetNewBabyMrNo(EpisodeID)
		Quit MrNo
	}
	
	Set VolID=$o(^DHCWMRVOL(0,"PaadmDr",EpisodeID,""),-1)
	Set ErrMsg = "-2:病案卷不存在"
	Quit:VolID="" MrNo  ;病案卷不存在
	
	Set AdmType=$p(^PAADM(EpisodeID),"^",2)
	Set ErrMsg = "-3:非住院病人"
	Quit:AdmType'="I" MrNo  ;非住院病人
	
	Set VolIsActive=$p(^DHCWMRVOL(VolID),"^",7)
	Set ErrMsg = "-5:卷无效"
	Quit:VolIsActive="N" MrNo ;卷无效
	
	Set MainID=$p(^DHCWMRVOL(VolID),"^",1)
	Set MrType=$p(^DHCWMRMAIN(MainID),"^",1)
	Set LeadingFactor=##class(web.DHCWMRGroup.DHCWMRGroupReceipt).GetLeadingFactor(MrType)
	Set MrNo=$p(^DHCWMRMAIN(MainID),"^",2)
	Set IsActive=$p(^DHCWMRMAIN(MainID),"^",6)
	
	Set ErrMsg = "-4:无效病案"
	Quit:IsActive="N" MrNo ;无效病案
	Set ErrMsg="-8:病案号为空"
	Set:$ZCVT(LeadingFactor,"U")="V" MrNo=$p(^DHCWMRVOL(VolID),"^",10),ErrMsg = "-9:卷病案号为空"
	Quit:MrNo="" MrNo
	Set ErrMsg = ""
	Quit MrNo
IGetMrNoByEpisodeIDError
    Set ErrMsg = $ZE
    Quit MrNo
}

/// Creator: bianshuai
/// Descript:临床路径  PathWaysQuery 为 QryCPWByDischDate /QryCPWByAdmDate /QryCPWByOutDate /QryCPWByInDate
/// D ##Class(web.DHCSTPHCMPathWaysQuery).QueryClinPathWay("2016-10-02","2016-10-18","O","","","N","","QryCPWByInDate")
ClassMethod QueryClinPathWay(DateFrom As %String, DateTo As %String, Status As %String, LocID As %String, WardID As %String, Select As %String, CpwDicID As %String, PathWaysQuery As %String) As %String
{
	N (DateFrom,DateTo,Status,LocID,WardID,Select,CpwDicID,PathWaysQuery)
	Set Query="web.DHCSTPHCMPathWaysQuery:"_PathWaysQuery
 	Set result=##class(%Library.ResultSet).%New(Query)
 	//Set result=##class(%Library.ResultSet).%New("web.DHCST.INRequestAuxByConsume:LocItmForReq")
 	Set sc=result.Execute(DateFrom,DateTo,Status,LocID,WardID,Select,CpwDicID)
 	If $$$ISERR(sc) Quit ""
    Set colNum=result.GetColumnCount() //列数
    Set count = 0
    Set del=""""
 	Set tmp=""
 	;Write ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(0) //输出json前缀串
 	Set StartSign="{"_del_"rows"_del_":["  //qunianpeng 2016/10/18 拼前缀rows串
 	write StartSign
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.
		Set count = count+1
		If count=1 Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }	 
	; Write ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	 Write "],"
	 Set EndSign=""_del_"total"_del_":"_count_"}" //qunianpeng 2016/10/18 拼后缀total串
	 write EndSign
	 Do result.Close()
	 Quit ""
}

}
