Class web.DHCEMPatCheckLevStatis Extends (%Persistent, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Description: 急诊分诊与急诊就诊患者例数之比
/// Creator:     qqa
/// CreateDate:  2020-10-12
/// Input:  	 开始时间(stDate)，结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","PatChkPatInEmPatRatio","2020-11-24 10:19:16","2020-11-25 18:19:16")
Query PatChkPatInEmPatRatio(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "ratio,chkPatNum,noChkPatNum,jzrs") [ SqlProc ]
{
}

ClassMethod PatChkPatInEmPatRatioExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	;s ^wxj("PatChkPatInEm")=$lb(stDate,endDate)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	s stTime=$p(stDate," ",2)
	s endTime=$p(endDate," ",2)
	s fromTime = stTime
	s toTime =endTime
	i fromTime'="" s fromTime=$zth(fromTime)
 	i toTime'=""   s toTime= $zth(toTime)
  	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	i (fromDate=toDate)&(fromTime>toTime) Quit $$$OK    //wxj 2020-11-25  开始时间大于结束时间退出
 	s ChkPatNum=0,NoChkPatNum=0,EmAllPat=0,jzrs=0
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)
   	..s PCLRowID=$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
   	..s admTime=$p(^PAADM(EpisodeID),"^",7)
   	..;q:(Date=fromDate)&(admTime<fromTime)      //wxj 2020-11-25 开始日期的时间大于就诊的时间 退出
   	..;q:(Date=toDate)&(admTime>toTime)       //wxj 2020-11-25 结束日期的时间小于就诊的时间 退出
   	..s EmAllPat=EmAllPat+1
   	..s:+PCLRowID=0 NoChkPatNum=NoChkPatNum+1
   	..s:+PCLRowID'=0 ChkPatNum=ChkPatNum+1
   	..s jzrs=ChkPatNum+NoChkPatNum
	
	s:+EmAllPat=0 Ratio="0%"
	s:+EmAllPat'=0 Ratio=$j(ChkPatNum/EmAllPat,1,2)*100_"%"
	
    d OutPutPatChkPatInEmPatRatio

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutPatChkPatInEmPatRatio
	set Data=$lb(Ratio,ChkPatNum,NoChkPatNum,jzrs)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PatChkPatInEmPatRatioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PatChkPatInEmPatRatioExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod PatChkPatInEmPatRatioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PatChkPatInEmPatRatioExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊分诊与急诊就诊患者例数之比：明细
/// Creator:     qqa
/// CreateDate:  2020-10-12
/// Input:  	 开始时间(stDate),结束时间(endDate),1(已分诊)/2(未分诊)/其他(所有)(type)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","PatChkPatInEmPatRatioData","2020-11-01","2020-11-01","1")
Query PatChkPatInEmPatRatioData(stDate As %String, endDate As %String, type As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PCLCreator,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,PatTemp,PatSDBP,PatPulse,PatBrth,PatSoP2") [ SqlProc ]
{
}

ClassMethod PatChkPatInEmPatRatioDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, type As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,type,HOSPID)
	//S ^yangyongtao("PatChkPatInEmPatRatioData")=$lb(stDate,endDate,type)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s stTime=$p(stDate," ",2)
	s endTime=$p(endDate," ",2)
	s fromTime = stTime
	s toTime =endTime
	i fromTime'="" s fromTime=$zth(fromTime)
 	i toTime'=""   s toTime= $zth(toTime)
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	i (fromDate=toDate)&(fromTime>toTime) Quit $$$OK    //wxj 2020-11-25  开始时间大于结束时间退出
 
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d  
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)
   	..s PCLRowID=$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	..q:(type=1)&&(+PCLRowID=0)
   	..q:(type=2)&&(+PCLRowID'=0)
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..s PCLCreatorDr=$p($g(^DHCEMPCL(+PCLRowID)),"^",3)   
	..s PCLCreator=$p($g(^SSU("SSUSR",+PCLCreatorDr)),"^",2)	;分诊护士
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
	..;q:(Date=fromDate)&(PaAdmTime<fromTime)      //wxj 2020-11-25 开始日期的时间大于就诊的时间 退出
   	..;q:(Date=toDate)&(PaAdmTime>toTime)       //wxj 2020-11-25 结束日期的时间小于就诊的时间 退出
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
	..s PatChkSign = ##class(web.DHCEMPatCheckLevStatis).GetEmPatChkSignItm(EpisodeID) ;##class(web.DHCEMPatCheckLevStatis).GetEmPatChkSignItm(EpisodeID)
	..s PatTemp=$p(PatChkSign,"^",1)   		/// 体温
	..s PatSDBP=$p(PatChkSign,"^",2)    	/// 血压(BP)收缩压/舒张压
	..s PatPulse=$p(PatChkSign,"^",3)  		/// 脉搏R
	..s PatBrth=$p(PatChkSign,"^",4)   		/// 呼吸频率
	..s PatSoP2=$p(PatChkSign,"^",5)   		/// 血氧饱合度SoP2
	..
    ..d OutPutPatChkPatInEmPatRatioData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutPatChkPatInEmPatRatioData
	
	set Data=$lb(PAAdmDoc,PCLCreator,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,PatTemp,PatSDBP,PatPulse,PatBrth,PatSoP2)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod PatChkPatInEmPatRatioDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PatChkPatInEmPatRatioDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod PatChkPatInEmPatRatioDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PatChkPatInEmPatRatioDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊高血压规范化管理项目患者登记人数
/// Creator:     qqa
/// CreateDate:  2020-10-12
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmHypertensionPatData","2020-10-01","2021-10-01",2)
Query EmHypertensionPatData(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,MrNo,UsedDrugsName,ILoc,WardDesc,Doctor") [ SqlProc ]
{
}

ClassMethod EmHypertensionPatDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	
 	;s ArcimIDs="1474||1^1503||1^18344||1^18947||1^24407||1^1473||1^18023||1^23716||1"
 
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","HYPERTENSION",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d 
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID) 
    ..;s UsedDrugsArcimID = ##class(web.DHCEMPatCheckLevStatis).GetPatUsedDrugs(EpisodeID,ArcimIDs)
   	..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
   	..;q:(##class(web.DHCEMPatCheckLevStatis).StringIsContentThis(PatDiag,HypertensionDiag)'="Y")&&(UsedDrugsArcimID="")
   	..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
   	..s HasOrdIDs=""
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..;s PCLCreatorDr=$p(^DHCEMPCL(PCLRowID),"^",3)   
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..
	..
	..s UsedDrugsName=""
	..;s:UsedDrugsArcimID'="" UsedDrugsName=##class(web.DHCEMPatCheckLevStatis).GetArciDesc(UsedDrugsArcimID)  ;使用的药品描述
	..s MrNo="",WardDesc="",Doctor="",ILoc=""
	..s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
	..i IPBKRowID'="" d
	...s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	...q:ToAdmID=""
	...s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(ToAdmID,"","I") 	;住院号
	...s WardID=$p(^PAADM(ToAdmID),"^",70)
	...s WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	...s DoctorID=$P($g(^PAADM(ToAdmID)),"^",9)   ///主管医生
	...s Doctor=$P($g(^CTPCP(+DoctorID,1)),"^",2)
	...s ILocID=$p(^PAADM(ToAdmID),"^",4)
    ...s ILoc=$p(^CTLOC(ILocID),"^",2)
	..d OutPutEmHypertensionPatData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmHypertensionPatData
	
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,MrNo,UsedDrugsName,ILoc,WardDesc,Doctor)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmHypertensionPatDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmHypertensionPatDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmHypertensionPatDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmHypertensionPatDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊危险性上消化道出血患者登记人数
/// Creator:     qqa
/// CreateDate:  2020-10-12
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmDangGastHemorData","2020-10-01","2021-10-01","2")
Query EmDangGastHemorData(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,MrNo,ILoc,WardDesc,Doctor,PatTemp,PatSDBP,PatPulse,PatBrth,PatSoP2") [ SqlProc ]
{
}

ClassMethod EmDangGastHemorDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s stTime=$p(stDate," ",2)
	s endTime=$p(endDate," ",2)
	s fromTime = stTime
	s toTime =endTime
	i fromTime'="" s fromTime=$zth(fromTime)
 	i toTime'=""   s toTime= $zth(toTime)
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	i (fromDate=toDate)&(fromTime>toTime) Quit $$$OK    //wxj 2020-11-25  开始时间大于结束时间退出
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","GASTHEMORRH",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 	
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d 
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID) 
   	..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
   	..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
   	..s HasOrdIDs=""
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..;s PCLCreatorDr=$p(^DHCEMPCL(PCLRowID),"^",3)   
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
	..q:(Date=fromDate)&(PaAdmTime<fromTime)      //wxj 2020-11-25 开始日期的时间大于就诊的时间 退出
   	..q:(Date=toDate)&(PaAdmTime>toTime)       //wxj 2020-11-25 结束日期的时间小于就诊的时间 退出
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..s MrNo="",WardDesc="",Doctor="",ILoc=""
	..s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
	..s PatChkSign = ##class(web.DHCEMPatCheckLevStatis).GetEmPatChkSignItm(EpisodeID)
	..s PatTemp=$p(PatChkSign,"^",1)   		/// 体温
	..s PatSDBP=$p(PatChkSign,"^",2)    	/// 血压(BP)收缩压/舒张压
	..s PatPulse=$p(PatChkSign,"^",3)  		/// 脉搏R
	..s PatBrth=$p(PatChkSign,"^",4)   		/// 呼吸频率
	..s PatSoP2=$p(PatChkSign,"^",5)   		/// 血氧饱合度SoP2
	..i IPBKRowID'="" d
	...s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	...q:ToAdmID=""
	...s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(ToAdmID,"","I")		;住院号
	...s WardID=$p(^PAADM(ToAdmID),"^",70)
	...s WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	...s DoctorID=$P($g(^PAADM(ToAdmID)),"^",9)   	;主管医生
	...s Doctor=$P($g(^CTPCP(+DoctorID,1)),"^",2)
	...s ILocID=$p(^PAADM(ToAdmID),"^",4)
    ...s ILoc=$p(^CTLOC(ILocID),"^",2)
	..d OutPutEmDangGastHemorData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmDangGastHemorData
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,MrNo,ILoc,WardDesc,Doctor,PatTemp,PatSDBP,PatPulse,PatBrth,PatSoP2)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmDangGastHemorDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmDangGastHemorDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmDangGastHemorDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmDangGastHemorDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊中毒患者登记人数
/// Creator:     qqa
/// CreateDate:  2020-10-12
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmPoisoningPatData","2020-09-01","2020-10-01","2")
Query EmPoisoningPatData(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,MrNo,UsedDrugsName,ILoc,WardDesc,Doctor,PatTemp,PatSDBP,PatPulse,PatBrth,PatSoP2") [ SqlProc ]
{
}

ClassMethod EmPoisoningPatDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	s stTime=$p(stDate," ",2)
	s endTime=$p(endDate," ",2)
	s fromTime = stTime
	s toTime =endTime
	i fromTime'="" s fromTime=$zth(fromTime)
 	i toTime'=""   s toTime= $zth(toTime)
	
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	i (fromDate=toDate)&(fromTime>toTime) Quit $$$OK    //wxj 2020-11-25  开始时间大于结束时间退出
 
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","POISONING",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 	
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d  
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)
   	..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
   	..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
   	..s HasOrdIDs=""
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..;s PCLCreatorDr=$p(^DHCEMPCL(PCLRowID),"^",3)   
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
	..q:(Date=fromDate)&(PaAdmTime<fromTime)      //wxj 2020-11-25 开始日期的时间大于就诊的时间 退出
   	..q:(Date=toDate)&(PaAdmTime>toTime)       //wxj 2020-11-25 结束日期的时间小于就诊的时间 退出
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..s PatChkSign = ##class(web.DHCEMPatCheckLevStatis).GetEmPatChkSignItm(EpisodeID)
	..s PatTemp=$p(PatChkSign,"^",1)   		/// 体温
	..s PatSDBP=$p(PatChkSign,"^",2)    	/// 血压(BP)收缩压/舒张压
	..s PatPulse=$p(PatChkSign,"^",3)  		/// 脉搏R
	..s PatBrth=$p(PatChkSign,"^",4)   		/// 呼吸频率
	..s PatSoP2=$p(PatChkSign,"^",5)   		/// 血氧饱合度SoP2 
	..s MrNo="",WardDesc="",Doctor="",ILoc=""
	..s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)  
	..i IPBKRowID'="" d
	...s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	...q:ToAdmID=""
	...s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(ToAdmID,"","I")
	...s WardID=$p(^PAADM(ToAdmID),"^",70)
	...s WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	...s DoctorID=$P($g(^PAADM(ToAdmID)),"^",9)   ///主管医生
	...s Doctor=$P($g(^CTPCP(+DoctorID,1)),"^",2)
	...s ILocID=$p(^PAADM(ToAdmID),"^",4)
    ...s ILoc=$p(^CTLOC(ILocID),"^",2)
	..d OutPutEmPoisoningPatData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmPoisoningPatData
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,MrNo,UsedDrugsName,ILoc,WardDesc,Doctor,PatTemp,PatSDBP,PatPulse,PatBrth,PatSoP2)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmPoisoningPatDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmPoisoningPatDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmPoisoningPatDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmPoisoningPatDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊创伤患者登记人数
/// Creator:     qqa
/// CreateDate:  2020-10-12
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmTraumaPatientsData","2020-09-01","2020-10-01")
Query EmTraumaPatientsData(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,MrNo,UsedDrugsName,ILoc,WardDesc,Doctor,PatTemp,PatSDBP,PatPulse,PatBrth,PatSoP2") [ SqlProc ]
{
}

ClassMethod EmTraumaPatientsDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	s stTime=$p(stDate," ",2)
	s endTime=$p(endDate," ",2)
	s fromTime = stTime
	s toTime =endTime
	i fromTime'="" s fromTime=$zth(fromTime)
 	i toTime'=""   s toTime= $zth(toTime)
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	i (fromDate=toDate)&(fromTime>toTime) Quit $$$OK    //wxj 2020-11-25  开始时间大于结束时间退出
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","TRAUMAPATIENTS",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 	
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)  
   	..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
   	..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..;s PCLCreatorDr=$p(^DHCEMPCL(PCLRowID),"^",3)   
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
	..q:(Date=fromDate)&(PaAdmTime<fromTime)      //wxj 2020-11-25 开始日期的时间大于就诊的时间 退出
   	..q:(Date=toDate)&(PaAdmTime>toTime)       //wxj 2020-11-25 结束日期的时间小于就诊的时间 退出
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..s PatChkSign = ##class(web.DHCEMPatCheckLevStatis).GetEmPatChkSignItm(EpisodeID)
	..s PatTemp=$p(PatChkSign,"^",1)   		/// 体温
	..s PatSDBP=$p(PatChkSign,"^",2)    	/// 血压(BP)收缩压/舒张压
	..s PatPulse=$p(PatChkSign,"^",3)  		/// 脉搏R
	..s PatBrth=$p(PatChkSign,"^",4)   		/// 呼吸频率
	..s PatSoP2=$p(PatChkSign,"^",5)   		/// 血氧饱合度SoP2
	..s MrNo="",WardDesc="",Doctor="",ILoc=""
	..s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
	..i IPBKRowID'="" d
	...s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	...q:ToAdmID=""
	...s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(ToAdmID,"","I")
	...s WardID=$p(^PAADM(ToAdmID),"^",70)
	...s WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	...s DoctorID=$P($g(^PAADM(ToAdmID)),"^",9)   ///主管医生
	...s Doctor=$P($g(^CTPCP(+DoctorID,1)),"^",2)
	...s ILocID=$p(^PAADM(ToAdmID),"^",4)
    ...s ILoc=$p(^CTLOC(ILocID),"^",2)
	..d OutPutEmTraumaPatientsData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmTraumaPatientsData
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,MrNo,UsedDrugsName,ILoc,WardDesc,Doctor,PatTemp,PatSDBP,PatPulse,PatBrth,PatSoP2)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmTraumaPatientsDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmTraumaPatientsDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmTraumaPatientsDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmTraumaPatientsDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊卒中患者登记人数
/// Creator:     qqa
/// CreateDate:  2020-10-12
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmStrokePatientsData","2020-10-01","2020-10-10")
Query EmStrokePatientsData(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,MrNo,UsedDrugsName,ILoc,WardDesc,Doctor,PatTemp,PatSDBP,PatPulse,PatBrth,PatSoP2") [ SqlProc ]
{
}

ClassMethod EmStrokePatientsDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s stTime=$p(stDate," ",2)
	s endTime=$p(endDate," ",2)
	s fromTime = stTime
	s toTime =endTime
	i fromTime'="" s fromTime=$zth(fromTime)
 	i toTime'=""   s toTime= $zth(toTime)
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	i (fromDate=toDate)&(fromTime>toTime) Quit $$$OK    //wxj 2020-11-25  开始时间大于结束时间退出
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","STROKEPAT",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 	
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d 
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID) 
   	..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
   	..;q:PatDiag["脑梗死后遗症"			;2020-11-12 固定
   	..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..;s PCLCreatorDr=$p(^DHCEMPCL(PCLRowID),"^",3)   
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
   	..q:(Date=fromDate)&(PaAdmTime<fromTime)      //wxj 2020-11-25 开始日期的时间大于就诊的时间 退出
   	..q:(Date=toDate)&(PaAdmTime>toTime)       //wxj 2020-11-25 结束日期的时间小于就诊的时间 退出
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..s PatChkSign = ##class(web.DHCEMPatCheckLevStatis).GetEmPatChkSignItm(EpisodeID)
	..s PatTemp=$p(PatChkSign,"^",1)   		/// 体温
	..s PatSDBP=$p(PatChkSign,"^",2)    	/// 血压(BP)收缩压/舒张压
	..s PatPulse=$p(PatChkSign,"^",3)  		/// 脉搏R
	..s PatBrth=$p(PatChkSign,"^",4)   		/// 呼吸频率
	..s PatSoP2=$p(PatChkSign,"^",5)   		/// 血氧饱合度SoP2
	..s MrNo="",WardDesc="",Doctor="",ILoc=""
	..s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
	..i IPBKRowID'="" d
	...s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	...q:ToAdmID=""
	...s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(ToAdmID,"","I")
	...s WardID=$p(^PAADM(ToAdmID),"^",70)
	...s WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	...s DoctorID=$P($g(^PAADM(ToAdmID)),"^",9)   ///主管医生
	...s Doctor=$P($g(^CTPCP(+DoctorID,1)),"^",2)
	...s ILocID=$p(^PAADM(ToAdmID),"^",4)
    ...s ILoc=$p(^CTLOC(ILocID),"^",2)
	..d OutPutEmStrokePatientsData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmStrokePatientsData
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,MrNo,UsedDrugsName,ILoc,WardDesc,Doctor,PatTemp,PatSDBP,PatPulse,PatBrth,PatSoP2)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmStrokePatientsDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmStrokePatientsDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmStrokePatientsDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmStrokePatientsDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊胸痛患者登记人数
/// Creator:     qqa
/// CreateDate:  2020-10-12
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmChestPainData","2020-10-01","2020-10-01")
Query EmChestPainData(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,MrNo,UsedDrugsName,ILoc,WardDesc,Doctor,PatTemp,PatSDBP,PatPulse,PatBrth,PatSoP") [ SqlProc ]
{
}

ClassMethod EmChestPainDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","EMSTROKEPATIENTSDATA",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 	
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d 
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID) 
   	..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
   	..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..;s PCLCreatorDr=$p(^DHCEMPCL(PCLRowID),"^",3)   
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..s PatChkSign = ##class(web.DHCEMPatCheckLevStatis).GetEmPatChkSignItm(EpisodeID)
	..s PatTemp=$p(PatChkSign,"^",1)   		/// 体温
	..s PatSDBP=$p(PatChkSign,"^",2)    	/// 血压(BP)收缩压/舒张压
	..s PatPulse=$p(PatChkSign,"^",3)  		/// 脉搏R
	..s PatBrth=$p(PatChkSign,"^",4)   		/// 呼吸频率
	..s PatSoP2=$p(PatChkSign,"^",5)   		/// 血氧饱合度SoP2
	..s MrNo="",WardDesc="",Doctor="",ILoc=""
	..s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
	..i IPBKRowID'="" d
	...s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	...q:ToAdmID=""
	...s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(ToAdmID,"","I")
	...s WardID=$p(^PAADM(ToAdmID),"^",70)
	...s WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	...s DoctorID=$P($g(^PAADM(ToAdmID)),"^",9)   ///主管医生
	...s Doctor=$P($g(^CTPCP(+DoctorID,1)),"^",2)
	...s ILocID=$p(^PAADM(ToAdmID),"^",4)
    ...s ILoc=$p(^CTLOC(ILocID),"^",2)
	..d OutPutEmChestPainData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmChestPainData
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,MrNo,UsedDrugsName,ILoc,WardDesc,Doctor,PatTemp,PatSDBP,PatPulse,PatBrth,PatSoP)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmChestPainDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmChestPainDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmChestPainDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmChestPainDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊抢救室总人数与死亡例数
/// Creator:     qqa
/// CreateDate:  2020-10-16
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmPatDeathRatio","2022-01-01","2022-10-10")
Query EmPatDeathRatio(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "DeathNum,AllNum,DeathRatio") [ SqlProc ]
{
}

ClassMethod EmPatDeathRatioExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
	
 	s AllNum=0,DeathNum=0,DeathRatio=""
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""  s HasOrdIDs=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d 
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)
  	..s IsSalvage=##class(web.DHCEMPatCheckLevStatis).IsSalvagePat(EpisodeID)
   	..q:IsSalvage'="Y"
   	..s AllNum=AllNum+1
   	..s PatientID=+^PAADM(EpisodeID)
   	..s IsDeath = $p(^PAPER(PatientID,"ALL"),"^",12)
   	..s:IsDeath="Y" DeathNum=DeathNum+1
	
	
	s:+AllNum=0 DeathRatio="00%"
	s:+AllNum'=0 DeathRatio=$j(DeathNum/AllNum,1,2)*100_"%"
	d OutPutEmPatDeathRatio

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmPatDeathRatio
	set Data=$lb(DeathNum,AllNum,DeathRatio)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmPatDeathRatioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmPatDeathRatioExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmPatDeathRatioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmPatDeathRatioExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊抢救室总人数与死亡例数:明细
/// Creator:     qqa
/// CreateDate:  2020-10-16
/// Input:  	 开始时间(stDate),结束时间(endDate),1(死亡)/2(未死亡)/其他(所有)(type)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmPatDeathRatioData","2020-10-01","2020-10-01","1")
Query EmPatDeathRatioData(stDate As %String, endDate As %String, type As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,DeceasedDate,DeceasedTime,MrNo,UsedDrugsName,ILoc,WardDesc,Doctor") [ SqlProc ]
{
}

ClassMethod EmPatDeathRatioDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, type As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,type,HOSPID)
		
	;s ^qqa("EmPatDeathRatioData")=$lb(stDate,endDate,type)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	
 	s AllNum=0,DeathNum=0,DeathRatio=""
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)   
   	..s IsSalvage=##class(web.DHCEMPatCheckLevStatis).IsSalvagePat(EpisodeID)
   	..q:IsSalvage'="Y"
   	..s PatientID=+^PAADM(EpisodeID)
   	..s IsDeath = $p(^PAPER(PatientID,"ALL"),"^",12)
   	..q:(type=1)&&(IsDeath'="Y")
	..q:(type=2)&&(IsDeath="Y")
	..s DeceasedDate=$p(^PAPER(PatientID,"ALL"),"^",13)
	..s DeceasedTime=$p(^PAPER(PatientID,"ALL"),"^",8)
	..s:DeceasedDate'="" DeceasedDate=$zd(DeceasedDate,3)
	..s:DeceasedTime'="" DeceasedTime=$zt(DeceasedTime,2)
	..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..;s PCLCreatorDr=$p(^DHCEMPCL(PCLRowID),"^",3)   
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..s MrNo="",WardDesc="",Doctor="",ILoc=""
	..s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
	..i IPBKRowID'="" d
	...s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	...q:ToAdmID=""
	...s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(ToAdmID,"","I")
	...s WardID=$p(^PAADM(ToAdmID),"^",70)
	...s WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	...s DoctorID=$P($g(^PAADM(ToAdmID)),"^",9)   ///主管医生
	...s Doctor=$P($g(^CTPCP(+DoctorID,1)),"^",2)
	...s ILocID=$p(^PAADM(ToAdmID),"^",4)
    ...s ILoc=$p(^CTLOC(ILocID),"^",2)
	..d OutPutEmPatDeathRatioData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmPatDeathRatioData
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,DeceasedDate,DeceasedTime,MrNo,UsedDrugsName,ILoc,WardDesc,Doctor)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmPatDeathRatioDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmPatDeathRatioDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmPatDeathRatioDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmPatDeathRatioDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊年急诊输液病人数统计表
/// Creator:     qqa
/// CreateDate:  2020-10-20
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmPatInfusionData","2020-10-01","2020-10-01","2")
Query EmPatInfusionData(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatDiag,PatNo,XUser") [ SqlProc ]
{
}

ClassMethod EmPatInfusionDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","INFUSIONPAT",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 
 	s AdmList="O^E"
 	s AllNum=0,DeathNum=0,DeathRatio=""
	f Date=fromDate:1:toDate  d 
	.s AdmListLen=$l(AdmList,"^")
	.f i=1:1:AdmListLen d
	..s AdmType=$p(AdmList,"^",i)
	..s EpisodeID=""
    ..f  s EpisodeID=$o(^PAADMi("NNType",AdmType,Date,EpisodeID)) q:EpisodeID=""  d
    ...s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ...q:(HOSPID'="")&&(AdmHospID'=HOSPID)   
   	...s PatientID=+^PAADM(EpisodeID)
	...s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
	...q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
   	...s HasOrdIDs=""
   	...i SetDataOrd'="" d
   	....s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	...q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	...s OrdItmID=$p(HasOrdIDs,"^",1)
   	...s Ord=+OrdItmID
   	...s Itm=$p(OrdItmID,"||",2)
   	...;s XUserDR=$p(^OEORD(Ord,"I",Itm,7),"^",1)
   	...;s XUser=$p($g(^SSU("SSUSR",+XUserDR)),"^",2)
   	...s XUser=""
   	...s ExecCTPCP=$p($g(^OEORD(Ord,"I",Itm,"X",1)),"^",15)
    ...s:ExecCTPCP'="" XUser=$p($g(^CTPCP(ExecCTPCP,1)),"^",2)	//执行人
   	
   	...s PatientID=+^PAADM(EpisodeID)
	...s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
   	...s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	...s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	...s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	...s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
	...s PaAdmDate=$zd(PaAdmDate,3)
	...s PaAdmTime=$zt(PaAdmTime,2)
	...s PatientID=$p(^PAADM(EpisodeID),"^",1)
	...s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	...s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	...s PatSex=""
	...s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	...i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	...s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	...d OutPutEmPatInfusionData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmPatInfusionData
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatDiag,PatNo,XUser)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmPatInfusionDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmPatInfusionDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmPatInfusionDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmPatInfusionDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊清创手术病人总数
/// Creator:     qqa
/// CreateDate:  2020-10-20
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmPatDebridSurgData","2020-10-01","2020-10-01","2")
Query EmPatDebridSurgData(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatDiag,PatNo,UsedDrugsName") [ SqlProc ]
{
}

ClassMethod EmPatDebridSurgDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","DEBRIDSURGPAT",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 	
 	
 	
 	s AllNum=0,DeathNum=0,DeathRatio=""
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)   
   	..s PatientID=+^PAADM(EpisodeID)
	..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
	..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
   	..s HasOrdIDs=""
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s UsedDrugsName=""
	..s:HasOrdIDs'="" UsedDrugsName=##class(web.DHCEMPatCheckLevStatis).GetArciDescByOrd(HasOrdIDs,"^")  ;使用的药品描述
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..d OutPutEmPatDebridSurgData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmPatDebridSurgData
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatDiag,PatNo,UsedDrugsName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmPatDebridSurgDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmPatDebridSurgDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmPatDebridSurgDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmPatDebridSurgDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊住科院
/// Creator:     qqa
/// CreateDate:  2020-10-21
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmPatObsData","2020-10-01","2021-10-01")
Query EmPatObsData(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,LastOrdDate,LastOrdTime,PatName,PatSex,PatAge,PatDiag,PatNo,ILoc,WardDesc") [ SqlProc ]
{
}

ClassMethod EmPatObsDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 
 	s AllNum=0,DeathNum=0,DeathRatio=""
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)   
    ..;s IsHasObsBl=##Class(EMRservice.HISInterface.PatientInfoAssist).GetSavedInfoEMR(EpisodeID,"351","")
   	..;q:IsHasObsBl'=1
   	..s PatientID=+^PAADM(EpisodeID)
   	..s LastOrdDateTime=##class(web.DHCEMPatCheckLevStatis).GetPatLastOrdDateTime(EpisodeID)
   	..s LastOrdDate=$p(LastOrdDateTime,"^",1)
   	..s LastOrdTime=$p(LastOrdDateTime,"^",2)
   	..s:LastOrdDate'="" LastOrdDate=$zd(LastOrdDate,3)
   	..s:LastOrdTime'="" LastOrdTime=$zt(LastOrdTime,2)
	..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..q:'$d(^PAPER(PatientID,"ALL"))
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..s ILoc="",WardDesc=""
	..s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
	..i IPBKRowID'="" d
	...s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	...q:ToAdmID=""
	...s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(ToAdmID,"","I")
	...s WardID=$p(^PAADM(ToAdmID),"^",70)
	...s WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	...s DoctorID=$P($g(^PAADM(ToAdmID)),"^",9)   ///主管医生
	...s Doctor=$P($g(^CTPCP(+DoctorID,1)),"^",2)
	...s ILocID=$p(^PAADM(ToAdmID),"^",4)
    ...s ILoc=$p(^CTLOC(ILocID),"^",2)
    ...;s IPaAdmDate = $p(^PAADM(ToAdmID),"^",6) 				;就诊日期
	...;s IPaAdmTime = $p(^PAADM(ToAdmID),"^",7) 				;就诊时间
	
	
	..d OutPutEmPatObsData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmPatObsData
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,LastOrdDate,LastOrdTime,PatName,PatSex,PatAge,PatDiag,PatNo,ILoc,WardDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmPatObsDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmPatObsDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmPatObsDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmPatObsDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊高危患者绿色通道停留时间收住院比例
/// Creator:     qqa
/// CreateDate:  2020-10-21
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Table:		 产品功能：HIGHRISKPAT
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmPatHighRiskForRadio","2020-09-01","2021-10-01","2")
Query EmPatHighRiskForRadio(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "AllNum,InHospNum,InHospRatio") [ SqlProc ]
{
}

ClassMethod EmPatHighRiskForRadioExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","HIGHRISKPAT",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 
 	s AllNum=0,InHospNum=0,InHospRatio=""
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)   
    ..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
    ..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
    ..s HasOrdIDs=""
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
    ..s AllNum=AllNum+1
	..s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
	..i IPBKRowID'="" d
	...s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	...q:ToAdmID=""
	...s InHospNum=InHospNum+1
	..s:+AllNum=0 InHospRatio="0%"
	..s:+AllNum'=0 InHospRatio=$j(InHospNum/AllNum,1,2)*100_"%"
	d OutPutEmPatHighRiskForRadio

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmPatHighRiskForRadio
	set Data=$lb(AllNum,InHospNum,InHospRatio)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmPatHighRiskForRadioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmPatHighRiskForRadioExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmPatHighRiskForRadioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmPatHighRiskForRadioExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊高危患者绿色通道停留时间重返比例
/// Creator:     qqa
/// CreateDate:  2020-10-21
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmPatHighRiskToReturnRadio","2020-09-01","2020-10-01")
Query EmPatHighRiskToReturnRadio(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "AllNum,ToReturnNum,ToReturnRatio") [ SqlProc ]
{
}

ClassMethod EmPatHighRiskToReturnRadioExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","HIGHRISKPAT",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 
 	s AllNum=0,ToReturnNum=0,ToReturnRatio=""
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)   
    ..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
    ..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
   	..s HasOrdIDs=""
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
    ..s AllNum=AllNum+1
    ..s IsCongFanPatInfo=##class(web.DHCEMPatCheckLevStatis).IsCongFanPatForAdmID(EpisodeID)
	..s:+IsCongFanPatInfo=1 ToReturnNum=ToReturnNum+1
	..s:+AllNum=0 ToReturnRatio="0%"
	..s:+AllNum'=0 ToReturnRatio=$j(ToReturnNum/AllNum,1,2)*100_"%"
	d OutPutEmPatHighRiskToReturnRadio

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmPatHighRiskToReturnRadio
	set Data=$lb(AllNum,ToReturnNum,ToReturnRatio)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmPatHighRiskToReturnRadioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmPatHighRiskToReturnRadioExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmPatHighRiskToReturnRadioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmPatHighRiskToReturnRadioExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊高危患者停留时间
/// Creator:     qqa
/// CreateDate:  2020-10-21
/// Input:  	 开始时间(stDate),结束时间(endDate),(type:1住院/2重返)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmPatHighRiskForData","2020-09-01","2020-10-01","2")
Query EmPatHighRiskForData(stDate As %String, endDate As %String, type As %String = "", HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,LastOrdDate,LastOrdTime,PatName,PatSex,PatAge,PatDiag,PatNo,MrNo,ILoc,WardDesc,Doctor,DeceasedDate,DeceasedTime,ObsLimitDateTime,FirstOpPAAdmDoc,FirstOpAdmDate,FirstOpAdmTime,FirstOpLoc") [ SqlProc ]
{
}

ClassMethod EmPatHighRiskForDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, type As %String = "", HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,type,HOSPID)
	
	s ^qqa("EmPatHighRiskForData")=$lb(stDate,endDate,type,HOSPID)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","HIGHRISKPAT",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 	
 
 	s AllNum=0,DeathNum=0,DeathRatio=""
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)   
    ..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
    ..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
   	..s HasOrdIDs=""
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s PatientID=+^PAADM(EpisodeID)
   	..s DeceasedDate=$p(^PAPER(PatientID,"ALL"),"^",13)
	..s DeceasedTime=$p(^PAPER(PatientID,"ALL"),"^",8)
	..s:DeceasedDate'="" DeceasedDate=$zd(DeceasedDate,3)
	..s:DeceasedTime'="" DeceasedTime=$zt(DeceasedTime,2)
   	..s LastOrdDateTime=##class(web.DHCEMPatCheckLevStatis).GetPatLastOrdDateTime(EpisodeID)
   	..s LastOrdDate=$p(LastOrdDateTime,"^",1)					;最后一次下医嘱日期
   	..s LastOrdTime=$p(LastOrdDateTime,"^",2)					;最后一次下医嘱时间
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..s MrNo="",WardDesc="",Doctor="",ILoc="",IPaAdmDate="",IPaAdmTime=""
	..s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
	..i IPBKRowID'="" d
	...s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	...q:ToAdmID=""
	...s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(ToAdmID,"","I")
	...s WardID=$p(^PAADM(ToAdmID),"^",70)
	...s WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	...s DoctorID=$P($g(^PAADM(ToAdmID)),"^",9)   ///主管医生
	...s Doctor=$P($g(^CTPCP(+DoctorID,1)),"^",2)
	...s ILocID=$p(^PAADM(ToAdmID),"^",4)
    ...s ILoc=$p(^CTLOC(ILocID),"^",2)
    ...s IPaAdmDate = $p(^PAADM(ToAdmID),"^",6) 				;就诊日期
	...s IPaAdmTime = $p(^PAADM(ToAdmID),"^",7) 				;就诊时间
	..s IsCongFanPat="",FirstOpAdmID=""
	..i type=2 d
	...s IsCongFanPatInfo=##class(web.DHCEMPatCheckLevStatis).IsCongFanPatForAdmID(EpisodeID)
	...s IsCongFanPat=$p(IsCongFanPatInfo,"^",1)
	...s FirstOpAdmID=$p(IsCongFanPatInfo,"^",2)
	..q:(type=1)&&(WardDesc="")
	..q:(type=2)&&(IsCongFanPat'=1)
	..s FirstOpAdmDate = $p($g(^PAADM(+FirstOpAdmID)),"^",6) 	;首诊日期
	..s FirstOpAdmTime = $p($g(^PAADM(+FirstOpAdmID)),"^",7) 	;首诊时间
	..s:FirstOpAdmDate'="" FirstOpAdmDate=$zd(FirstOpAdmDate,3)
	..s:FirstOpAdmTime'="" FirstOpAdmTime=$zt(FirstOpAdmTime,2)
	..s FirstOpAdmDoctorID=$P($g(^PAADM(+FirstOpAdmID)),"^",9)
	..s FirstOpPAAdmDoc=$P($g(^CTPCP(+FirstOpAdmDoctorID,1)),"^",2)	;首诊医师姓名
	..s FirstOpLocID=$p($g(^PAADM(+FirstOpAdmDoctorID)),"^",4)
    ..s FirstOpLoc=$p($g(^CTLOC(+FirstOpLocID)),"^",2)				;首诊科室
	..s LiveDate=$case(IPaAdmDate,"":LastOrdDate,:IPaAdmDate)
	..s LiveTime=$case(IPaAdmTime,"":LastOrdTime,:IPaAdmTime)
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
	..
	..;s ObsLimitDate=LiveDate-PaAdmDate
	..;s ObsLimitTime=LiveTime-PaAdmTime
	..s ObsLimitDateTime=##class(web.DHCEMPatCheckLevStatis).GetLimitDateDesc(PaAdmDate,PaAdmTime,LiveDate,LiveTime)
	..;s ObsLimitDateTime=""
	..;s:ObsLimitTime<0 ObsLimitDateTime=(ObsLimitDate-1)_"天"_(24-(ObsLimitTime\3600))_"小时"_(60-(ObsLimitTime#3600\60))_"分钟"
	..;s:ObsLimitTime=0 ObsLimitDateTime=ObsLimitDate_"天"
	..;s:ObsLimitTime>0 ObsLimitDateTime=ObsLimitDate_"天"_(ObsLimitTime\3600)_"小时"_(ObsLimitTime#3600\60)_"分钟"
	..;s:ObsLimitDateTime["-65632" ^qqa("Data")=$lb(PaAdmDate,PaAdmTime,LastOrdDate,LastOrdTime,IPaAdmDate,IPaAdmTime,LiveDate,LiveTime)
	..;b:ObsLimitDateTime["-1" ;err
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)
	..d OutPutEmPatHighRiskForData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmPatHighRiskForData
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,LastOrdDate,LastOrdTime,PatName,PatSex,PatAge,PatDiag,PatNo,MrNo,ILoc,WardDesc,Doctor,DeceasedDate,DeceasedTime,ObsLimitDateTime,FirstOpPAAdmDoc,FirstOpAdmDate,FirstOpAdmTime,FirstOpLoc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmPatHighRiskForDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmPatHighRiskForDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmPatHighRiskForDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmPatHighRiskForDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊急性心肌梗死患者平均门药时间
/// Creator:     qqa
/// CreateDate:  2020-10-21
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmPatMioInfData","2023-05-01","2023-05-18",2)
Query EmPatMioInfData(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,OpenOrdDate,OpenOrdTime,PatName,PatSex,PatAge,PatDiag,PatNo,MrNo,ILoc,WardDesc,Doctor,LimitDateTime,MiAvg,Ratio") [ SqlProc ]
{
}

ClassMethod EmPatMioInfDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","MIOINFPAT",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 	
 	s DrugData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","MIOINFPATDRUG",+$g(HOSPID),"","","")
 	s DrugData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(DrugData)
 	s DrugData = $p(DrugData,"^",2)
	k ^TMP("DHCEM","web.DHCEMPatCheckLevStatis","EmPatMioInfData")
 	s MiAll=0,count=0,MiPass=0
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)   
    ..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
    ..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
   	..s HasOrdIDs=""
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s PatientID=+^PAADM(EpisodeID)
   	..s DeceasedDate=$p(^PAPER(PatientID,"ALL"),"^",13)
	..s DeceasedTime=$p(^PAPER(PatientID,"ALL"),"^",8)
	..s:DeceasedDate'="" DeceasedDate=$zd(DeceasedDate,3)
	..s:DeceasedTime'="" DeceasedTime=$zt(DeceasedTime,2)
   	..s LastOrdDateTime=##class(web.DHCEMPatCheckLevStatis).GetPatLastOrdDateTime(EpisodeID)
   	..s LastOrdDate=$p(LastOrdDateTime,"^",1)					;最后一次下医嘱日期
   	..s LastOrdTime=$p(LastOrdDateTime,"^",2)					;最后一次下医嘱时间
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..s MrNo="",WardDesc="",Doctor="",ILoc="",IPaAdmDate="",IPaAdmTime=""
	..s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
	..i IPBKRowID'="" d
	...s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	...q:ToAdmID=""
	...s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(ToAdmID,"","I")
	...s WardID=$p(^PAADM(ToAdmID),"^",70)
	...s WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	...s DoctorID=$P($g(^PAADM(ToAdmID)),"^",9)   ///主管医生
	...s Doctor=$P($g(^CTPCP(+DoctorID,1)),"^",2)
	...s ILocID=$p(^PAADM(ToAdmID),"^",4)
    ...s ILoc=$p(^CTLOC(ILocID),"^",2)
    ...s IPaAdmDate = $p(^PAADM(ToAdmID),"^",6) 				;就诊日期
	...s IPaAdmTime = $p(^PAADM(ToAdmID),"^",7) 				;就诊时间
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
	..;s ASPLArcims="1543||1^1544||1^23701||1^24310||1" //hxy 2022-05-18 注释 st
	..;s HasOrdItmIDs = ##class(web.DHCEMPatCheckLevStatis).GetPatUsedDrugOrds(EpisodeID,ASPLArcims)
   	..;s OrdItmID=$p(HasOrdItmIDs,"^",1)
   	..s HasOrdIDs=""
   	..i DrugData'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,DrugData)
   	..s OrdItmID=$p(HasOrdIDs,"^",1) //ed
   	..s OpenOrdDate="",OpenOrdTime="",LimitDateTime="",LimitDateTimeSql=0
   	..i OrdItmID'="" d
   	...s Ord=+OrdItmID
   	...s Itm=$p(OrdItmID,"||",2)
   	...s OpenOrdDate=$p($g(^OEORD(Ord,"I",Itm,1)),"^",9) 
   	...s OpenOrdTime=$p($g(^OEORD(Ord,"I",Itm,1)),"^",10) 
   	...s LimitDateTime=##class(web.DHCEMPatCheckLevStatis).GetLimitDateDesc(PaAdmDate,PaAdmTime,OpenOrdDate,OpenOrdTime)
#;	...s LimitDate=OpenOrdDate-PaAdmDate
#;	...s LimitTime=OpenOrdTime-PaAdmTime
#;	...s LimitDateTime=""
#;	...s:LimitTime<0 LimitDateTime=(LimitDate-1)_"天"_(24-(LimitTime\3600))_"小时"_(60-(LimitTime#3600\60))_"分钟"
#;	...s:LimitTime=0 LimitDateTime=LimitDate_"天"
#;	...s:LimitTime>0 LimitDateTime=LimitDate_"天"_(LimitTime\3600)_"小时"_(LimitTime#3600\60)_"分钟"
	...s LimitDateTimeSql=##class(web.DHCEMPatCheckLevStatis).GetLimitDateDescSql(PaAdmDate,PaAdmTime,OpenOrdDate,OpenOrdTime)
   	..s MiAll=MiAll+LimitDateTimeSql
  	..s:(LimitDateTimeSql'=0)&&(LimitDateTimeSql<30) MiPass=MiPass+1
	..s:OpenOrdDate'="" OpenOrdDate=$zd(OpenOrdDate,3)
	..s:OpenOrdTime'="" OpenOrdTime=$zt(OpenOrdTime,2)
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)	
	..s count=count+1
	..s ^TMP("DHCEM","web.DHCEMPatCheckLevStatis","EmPatMioInfData",repid,EpisodeID)=PAAdmDoc_"^"_PaAdmDate_"^"_PaAdmTime_"^"_OpenOrdDate_"^"_OpenOrdTime_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatDiag_"^"_PatNo_"^"_MrNo_"^"_ILoc_"^"_WardDesc_"^"_Doctor_"^"_LimitDateTime

	s MiAvg="",Ratio=""
	s:count'=0 MiAvg=$j(MiAll/count,2,2)
	s:count'=0 Ratio=$j(MiPass/count*100,2,2)_"%"
	s Adm = 0
	f  s Adm = $o(^TMP("DHCEM","web.DHCEMPatCheckLevStatis","EmPatMioInfData",repid,Adm)) q:Adm=""  d
	.s Str=^TMP("DHCEM","web.DHCEMPatCheckLevStatis","EmPatMioInfData",repid,Adm)
	.s PAAdmDoc=$p(Str,"^",1)
	.s PaAdmDate=$p(Str,"^",2)
	.s PaAdmTime=$p(Str,"^",3)
	.s OpenOrdDate=$p(Str,"^",4)
	.s OpenOrdTime=$p(Str,"^",5)
	.s PatName=$p(Str,"^",6)
	.s PatSex=$p(Str,"^",7)
	.s PatAge=$p(Str,"^",8)
	.s PatDiag=$p(Str,"^",9)
	.s PatNo=$p(Str,"^",10)
	.s MrNo=$p(Str,"^",11)
	.s ILoc=$p(Str,"^",12)
	.s WardDesc=$p(Str,"^",13)
	.s Doctor=$p(Str,"^",14)
	.s LimitDateTime=$p(Str,"^",15)
	.d OutPutEmPatMioInfData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmPatMioInfData
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,OpenOrdDate,OpenOrdTime,PatName,PatSex,PatAge,PatDiag,PatNo,MrNo,ILoc,WardDesc,Doctor,LimitDateTime,MiAvg,Ratio)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmPatMioInfDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmPatMioInfDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmPatMioInfDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmPatMioInfDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊患者分诊率(按医师)
/// Creator:     qqa
/// CreateDate:  2020-11-12
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmPatCheckLevDocRadio","2020-09-01","2020-10-01")
Query EmPatCheckLevDocRadio(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmCode,PAAdmDoc,ChkNum,AllNum,ChkRadio") [ SqlProc ]
{
}

ClassMethod EmPatCheckLevDocRadioExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	
 	k ^TMPData("web.DHCEMPatCheckLevStatis","EmPatCheckLevDocRadio",repid)
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d  
	..s PAAdmStatus=$P($g(^PAADM(EpisodeID)),"^",20)  ; 2022-06-22 cy 就诊状态 退号则不统计
	..q:PAAdmStatus="C"  ; 2022-06-22 cy 就诊状态 退号则不统计
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID) 
    ..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
    ..s EmPCLvID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
    ..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
   	..s ^TMPData("web.DHCEMPatCheckLevStatis","EmPatCheckLevDocRadio",repid,"AllNum",AdmDoctorID)=+$g(^TMPData("web.DHCEMPatCheckLevStatis","EmPatCheckLevDocRadio",repid,"AllNum",AdmDoctorID))+1
	..i EmPCLvID'="" d
	...s ^TMPData("web.DHCEMPatCheckLevStatis","EmPatCheckLevDocRadio",repid,"ChkNum",AdmDoctorID)=+$g(^TMPData("web.DHCEMPatCheckLevStatis","EmPatCheckLevDocRadio",repid,"ChkNum",AdmDoctorID))+1
	
	s AdmDoctorID=""
	f  s AdmDoctorID=$o(^TMPData("web.DHCEMPatCheckLevStatis","EmPatCheckLevDocRadio",repid,"AllNum",AdmDoctorID)) q:AdmDoctorID=""  d
	.s AllNum=^TMPData("web.DHCEMPatCheckLevStatis","EmPatCheckLevDocRadio",repid,"AllNum",AdmDoctorID)
	.s ChkNum=+$g(^TMPData("web.DHCEMPatCheckLevStatis","EmPatCheckLevDocRadio",repid,"ChkNum",AdmDoctorID))
	.s PAAdmCode=$P($g(^CTPCP(+AdmDoctorID,1)),"^",1)			;医师工号
	.s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	.s ChkRadio=""
	.s:+AllNum=0 ChkRadio="0%"
	.s:+AllNum'=0 ChkRadio=$j(ChkNum/AllNum,1,2)*100_"%"
	.d OutPutEmPatCheckLevDocRadio

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmPatCheckLevDocRadio
	set Data=$lb(PAAdmCode,PAAdmDoc,ChkNum,AllNum,ChkRadio)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmPatCheckLevDocRadioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmPatCheckLevDocRadioExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmPatCheckLevDocRadioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmPatCheckLevDocRadioExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 急诊患者分诊明细(按医师)
/// Creator:     qqa
/// CreateDate:  2020-10-21
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmPatCheckLevDocData","2020-09-01","2020-10-01","1","JZKZZYSH")
Query EmPatCheckLevDocData(stDate As %String, endDate As %String, type As %String, docCode As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatDiag,PatNo,MrNo,ILoc,WardDesc,Doctor,PCLCreator") [ SqlProc ]
{
}

ClassMethod EmPatCheckLevDocDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, type As %String, docCode As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,type,docCode,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d  
	..s PAAdmStatus=$P($g(^PAADM(EpisodeID)),"^",20)  ; 2022-06-22 cy 就诊状态 退号则不统计
	..q:PAAdmStatus="C"  ; 2022-06-22 cy 就诊状态 退号则不统计
	..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID) 
    ..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
    ..s EmPCLvID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
    ..s PCLCreator=""
    ..i EmPCLvID'="" d
    ...s PCLCreatorID=$p($g(^DHCEMPCL(+EmPCLvID)),"^",3)   
	...s PCLCreator=$p($g(^SSU("SSUSR",+PCLCreatorID)),"^",2)	;分诊护士
    ..q:(type=1)&&(EmPCLvID="")
    ..q:(type=2)&&(EmPCLvID'="")
   	..s PatientID=+^PAADM(EpisodeID)
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
   	..s PAAdmDocCode=$P($g(^CTPCP(+AdmDoctorID,1)),"^",1)		;医师工号
   	..q:(docCode'="")&&(PAAdmDocCode'=docCode)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..s MrNo="",WardDesc="",Doctor="",ILoc="",IPaAdmDate="",IPaAdmTime=""
	..s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
	..i IPBKRowID'="" d
	...s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	...q:ToAdmID=""
	...s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(ToAdmID,"","I")
	...s WardID=$p(^PAADM(ToAdmID),"^",70)
	...s WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	...s DoctorID=$P($g(^PAADM(ToAdmID)),"^",9)   ///主管医生
	...s Doctor=$P($g(^CTPCP(+DoctorID,1)),"^",2)
	...s ILocID=$p(^PAADM(ToAdmID),"^",4)
    ...s ILoc=$p(^CTLOC(ILocID),"^",2)
    ...s IPaAdmDate = $p(^PAADM(ToAdmID),"^",6) 				;就诊日期
	...s IPaAdmTime = $p(^PAADM(ToAdmID),"^",7) 				;就诊时间
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)
	..d OutPutEmPatCheckLevDocData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmPatCheckLevDocData
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatDiag,PatNo,MrNo,ILoc,WardDesc,Doctor,PCLCreator)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmPatCheckLevDocDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmPatCheckLevDocDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmPatCheckLevDocDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmPatCheckLevDocDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Creator:qqa
/// Descript:最后一条医嘱的时间
/// Input:就诊ID
/// w ##class(web.DHCEMPatCheckLevStatis).GetPatLastOrdDateTime("1")
ClassMethod GetPatLastOrdDateTime(AdmID)
{
	n (AdmID)
	s Ret=""
	s Ord=0
	f  s Ord=$o(^OEORD(0,"Adm",AdmID,Ord)) q:Ord=""  d
	.s Itm=$o(^OEORD(Ord,"I",""),-1)
	.q:+Itm=0
	.s OrderDate=$p($g(^OEORD(Ord,"I",Itm,3)),"^",7)	;下医嘱日期
	.;if OrderDate'="" s OrderDate=$zd(OrderDate,3)
	.s OrderTime=$p($g(^OEORD(Ord,"I",Itm,1)),"^",17)	;下医嘱时间
	.;if OrderTime'="" s OrderTime=$zt(OrderTime,2)
	.s Ret=OrderDate_"^"_OrderTime
	q Ret
}

/// Creator:qqa
/// Descript:通过医嘱项ID返回患者使用过的其中医嘱项的ID
/// Input:医嘱项ID，多个用^分隔
/// w ##class(web.DHCEMPatCheckLevStatis).GetPatUsedDrugs("1||1")
ClassMethod GetPatUsedDrugs(AdmID, ArciIDs)
{
	n (AdmID,ArciIDs)
	q:ArciIDs="" ""
	k ^TMPData("web.DHCEMPatCheckLevStatis","GetPatUsedDrugs")
	s ArciIDs="^"_ArciIDs_"^"
	s Ord=0
	f  s Ord=$o(^OEORD(0,"Adm",AdmID,Ord)) q:Ord=""  d
	.s Itm=0
	.f  s Itm=$o(^OEORD(Ord,"I",Itm)) q:Itm=""  d
	..s ArcimID =$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	..s DbArcimID="^"_ArcimID_"^"
	..q:ArciIDs'[DbArcimID
	..s ^TMPData("web.DHCEMPatCheckLevStatis","GetPatUsedDrugs",ArcimID)=""

	s HasArcimID="",ArcimID=""
	f  s ArcimID=$o(^TMPData("web.DHCEMPatCheckLevStatis","GetPatUsedDrugs",ArcimID)) q:ArcimID=""  d
	.s:HasArcimID'="" HasArcimID=HasArcimID_"^"_ArcimID
	.s:HasArcimID="" HasArcimID=ArcimID
	q HasArcimID
}

/// Creator:qqa
/// Descript:通过医嘱项ID返回患者使用过的其中医嘱的ID
/// Input:医嘱项ID，多个用^分隔
/// w ##class(web.DHCEMPatCheckLevStatis).GetPatUsedDrugs("1||1")
ClassMethod GetPatUsedDrugOrds(AdmID, ArciIDs)
{
	n (AdmID,ArciIDs)
	q:ArciIDs="" ""
	k ^TMPData("web.DHCEMPatCheckLevStatis","GetPatUsedDrugOrds")
	s ArciIDs="^"_ArciIDs_"^"
	s Ord=0
	f  s Ord=$o(^OEORD(0,"Adm",AdmID,Ord)) q:Ord=""  d
	.s Itm=0
	.f  s Itm=$o(^OEORD(Ord,"I",Itm)) q:Itm=""  d
	..s ArcimID =$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	..s DbArcimID="^"_ArcimID_"^"
	..q:ArciIDs'[DbArcimID
	..s HasOrdItmID=Ord_"||"_Itm
	..s ^TMPData("web.DHCEMPatCheckLevStatis","GetPatUsedDrugOrds",HasOrdItmID)=""

	s HasOrdItmID="",OrdItmID=""
	f  s OrdItmID=$o(^TMPData("web.DHCEMPatCheckLevStatis","GetPatUsedDrugOrds",OrdItmID)) q:OrdItmID=""  d
	.s:HasOrdItmID'="" HasOrdItmID=HasOrdItmID_"^"_OrdItmID
	.s:HasOrdItmID="" HasOrdItmID=OrdItmID
	q HasOrdItmID
}

/// Creator:qqa
/// Descript:通过医嘱项ID返回医嘱名称描述
/// Input:医嘱项ID，多个用^分隔
/// w ##class(web.DHCEMPatCheckLevStatis).GetArciDesc("1||1")
ClassMethod GetArciDesc(ArciIDs, Limit = ",")
{
	n (ArciIDs,Limit)
	
	s ArciAllDesc=""
	s Len =$l(ArciIDs,"^")
	f i=1:1:Len d
	.s ArciID=$p(ArciIDs,"^",i)
	.q:ArciID="" 
	.s ArcimDesc= $P($G(^ARCIM(+ArciID,$p(ArciID,"||",2),1)),"^",2)
	.s:ArciAllDesc'="" ArciAllDesc=ArciAllDesc_Limit_ArcimDesc
	.s:ArciAllDesc="" ArciAllDesc=ArcimDesc
	q ArciAllDesc
}

/// Creator:qqa
/// Descript:通过医嘱ID返回医嘱名称描述
/// Input:医嘱项ID，多个用^分隔
/// w ##class(web.DHCEMPatCheckLevStatis).GetArciDescByOrd("1||1")
ClassMethod GetArciDescByOrd(OrdIDs, Limit = ",")
{
	n (OrdIDs,Limit)
	q:OrdIDs="" ""
	
	s ArciAllDesc=""
	s Len =$l(OrdIDs,Limit)
	f i=1:1:Len d
	.s OrdItmID=$p(OrdIDs,Limit,i)
	.q:OrdItmID=""
	.s ArciID=$p($g(^OEORD(+OrdItmID,"I",$p(OrdItmID,"||",2),1)),"^",2)
	.q:ArciID="" 
	.s ArcimDesc= $P($G(^ARCIM(+ArciID,$p(ArciID,"||",2),1)),"^",2)
	.s:ArciAllDesc'="" ArciAllDesc=ArciAllDesc_Limit_ArcimDesc
	.s:ArciAllDesc="" ArciAllDesc=ArcimDesc
	q ArciAllDesc
}

/// Creator:qqa
/// Descript:判断字符串是否包含
/// Input:中字符串，子字符串(多个用逗号分隔)
/// Return: Y/N
/// w ##class(web.DHCEMPatCheckLevStatis).StringIsContentThis("","")
ClassMethod StringIsContentThis(AllString, ThisString)
{
	n (AllString,ThisString)
	s Ret="N"
	
	q:AllString="" Ret
	
	s Len =$l(ThisString,",")
	f i=1:1:Len  q:Ret'="N"  d
	.s ItmString=$p(ThisString,",",i)
	.q:AllString'[ItmString
	.
	.s Ret="Y"
	q Ret
}

/// Creator:qqa
/// Descript:判断字符串是否包含
/// Input:中字符串，子字符串(多个用逗号分隔)
/// Return: Y/N
/// w ##class(web.DHCEMPatCheckLevStatis).SetDiagValid("张三","*张")
ClassMethod SetDiagValid(AllString, ThisString)
{
	n (AllString,ThisString)
	q:ThisString="" "Y"
	q:AllString="" "N"
	s Ret="N"
	
	s Len =$l(ThisString,",")
	f i=1:1:Len  q:Ret'="N"  d
	.s ItmString=$p(ThisString,",",i)
	.;b ;errData
	.q:(ItmString["*")&&((","_AllString_",")'[(","_$p(ItmString,"*",2)_",")) ;精确匹配
	.q:(ItmString'["*")&&(AllString'[ItmString)
	.s Ret="Y"
	q Ret
}

/// Creator:qqa
/// Descript:通过医嘱名称返回患者使用过的其中医嘱的ID
/// Input:医嘱名称，多个用,分隔
/// w ##class(web.DHCEMPatCheckLevStatis).SetOrdValid("790","氯化钠")
ClassMethod SetOrdValid(AdmID, OrdNames)
{
	n (AdmID,OrdNames)
	q:OrdNames="" ""
	k ^TMPData("web.DHCEMPatCheckLevStatis","SetOrdValid")
	s Ord=0
	f  s Ord=$o(^OEORD(0,"Adm",AdmID,Ord)) q:Ord=""  d
	.s Itm=0
	.f  s Itm=$o(^OEORD(Ord,"I",Itm)) q:Itm=""  d
	..q:..OrdIsStop(Ord,Itm)="Y"	;已经停止
	..s ArcimID =$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	..q:'$d(^ARCIM(+ArcimID,+$p(ArcimID,"||",2)))
	..s ArcimDesc= $P($G(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
	..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(ArcimDesc,OrdNames)'="Y"
	..s HasOrdItmID=Ord_"||"_Itm
	..s ^TMPData("web.DHCEMPatCheckLevStatis","SetOrdValid",HasOrdItmID)=""

	s HasOrdItmID="",OrdItmID=""
	f  s OrdItmID=$o(^TMPData("web.DHCEMPatCheckLevStatis","SetOrdValid",OrdItmID)) q:OrdItmID=""  d
	.s:HasOrdItmID'="" HasOrdItmID=HasOrdItmID_"^"_OrdItmID
	.s:HasOrdItmID="" HasOrdItmID=OrdItmID
	q HasOrdItmID
}

/// Creator:qqa
/// Descript:判断是否是重返患者：下次就诊时间
/// Input:EpisodeID 就诊ID
/// Return: 0/1^就诊ID 
/// w ##class(web.DHCEMPatCheckLevStatis).IsCongFanPatForAdmID("")
ClassMethod IsCongFanPatForAdmID(EpisodeID)
{
	n (EpisodeID)
	q:EpisodeID="" 0
	s Ret=0
	s PatinetID=$p(^PAADM(EpisodeID),"^",1)
	s UpEmAdmID=$o(^PAPERdr(PatinetID,"ADM","E",EpisodeID),-1)
	s UpOutAdmID=$o(^PAPERdr(PatinetID,"ADM","O",EpisodeID),-1)
	q:(+UpOutAdmID=0)&&(+UpEmAdmID=0) Ret
	s AdmDate= $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	s AdmTime = $p(^PAADM(EpisodeID),"^",7) 			;就诊时间
	s:+UpEmAdmID>+UpOutAdmID UpAdmID=UpEmAdmID
	s:+UpEmAdmID<+UpOutAdmID UpAdmID=UpOutAdmID
	q:+UpAdmID=0 Ret
	s UpAdmDate= $p(^PAADM(UpAdmID),"^",6) 				;Up就诊日期
	s UpAdmTime = $p(^PAADM(UpAdmID),"^",7) 			;Up就诊时间
	s LimitDate=AdmDate-UpAdmDate
	s LimitTime=AdmTime-UpAdmTime
	s LimitHours=LimitDate*3600*24+LimitTime\3600
	s:LimitHours<72 Ret=1
	q Ret_"^"_UpAdmID
}

/// Description: 心肺复苏术后自主呼吸循环恢复成功率统计
/// Creator:     wxj
/// CreateDate:  2021-03-13
/// Input:  	 开始时间(stDate),结束时间(endDate)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmCardResuscRatio","2020-10-11","2020-10-11","2")
Query EmCardResuscRatio(stDate As %String, endDate As %String, HOSPID = "") As %Query(ROWSPEC = "DeathNum,CardResuscNum,ResSuccRate") [ SqlProc ]
{
}

ClassMethod EmCardResuscRatioExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s stTime=$p(stDate," ",2)
	s endTime=$p(endDate," ",2)
	s fromTime = stTime
	s toTime =endTime
	i fromTime'="" s fromTime=$zth(fromTime)
 	i toTime'=""   s toTime= $zth(toTime)
 	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	i (fromDate=toDate)&(fromTime>toTime) Quit $$$OK    //wxj 2020-11-25  开始时间大于结束时间退出
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","CARDRESUSC",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 	
 	
 	s CardResuscNum=0,DeathNum=0,DeathRatio=""
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""  s HasOrdIDs=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d  
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)
    ..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
   	..q:(Date=fromDate)&&(fromTime'="")&&(PaAdmTime<fromTime)   //wxj 2020-11-25 开始日期的时间大于就诊的时间 退出
   	..q:(Date=toDate)&&(toTime'="")&&(PaAdmTime>toTime)       //wxj 2020-11-25 结束日期的时间小于就诊的时间 退出
   	..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid("",SetDataDiag)'="Y"	;验证诊断
   	..s HasOrdIDs=""
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s OrdItmID=$p(HasOrdIDs,"^",1) //ed
   	..s OpenOrdDate="",OpenOrdTime=""
   	..i OrdItmID'="" d
   	...s Ord=+OrdItmID
   	...s Itm=$p(OrdItmID,"||",2)
   	...s OpenOrdDate=$p($g(^OEORD(Ord,"I",Itm,1)),"^",9) 
   	...s OpenOrdTime=$p($g(^OEORD(Ord,"I",Itm,1)),"^",10) 
   	..s CardResuscNum=CardResuscNum+1
   	..s PatientID=+^PAADM(EpisodeID)
   	..s IsDeath = $p(^PAPER(PatientID,"ALL"),"^",12)
   	..s DeceasedDate=$p(^PAPER(PatientID,"ALL"),"^",13)
	..s DeceasedTime=$p(^PAPER(PatientID,"ALL"),"^",8)
	..i IsDeath="Y" d
	...s LimitDateTime=(DeceasedDate-OpenOrdDate)+((DeceasedTime-OpenOrdTime)/60/60/24)
	...s:LimitDateTime<1 DeathNum=DeathNum+1
	
	
	s:+CardResuscNum=0 ResSuccRate="00%"
	s:+CardResuscNum'=0 ResSuccRate=$j(CardResuscNum-DeathNum/CardResuscNum,1,2)*100_"%"
	d OutPutEmCardResuscRatio

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmCardResuscRatio
	set Data=$lb(DeathNum,CardResuscNum,ResSuccRate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmCardResuscRatioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmCardResuscRatioExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmCardResuscRatioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmCardResuscRatioExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
	Quit $$$OK
}

/// Description: 心肺复苏术后自主呼吸循环恢复成功率:明细
/// Creator:     wxj
/// CreateDate:  2021-03-15
/// Input:  	 开始时间(stDate),结束时间(endDate),1(死亡人数)/2(心肺复苏人数)
/// Return: 	 
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","EmCardResRatioData","2020-10-01","2020-10-01","1","2")
Query EmCardResRatioData(stDate As %String, endDate As %String, type As %String, HOSPID = "") As %Query(ROWSPEC = "PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,DeceasedDate,DeceasedTime,MrNo,UsedDrugsName,ILoc,WardDesc,Doctor") [ SqlProc ]
{
}

ClassMethod EmCardResRatioDataExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, type As %String, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,type,HOSPID)
		
	;s ^qqa("EmPatDeathRatioData")=$lb(stDate,endDate,type)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	s stTime=$p(stDate," ",2)
	s endTime=$p(endDate," ",2)
	s fromTime = stTime
	s toTime =endTime
	i fromTime'="" s fromTime=$zth(fromTime)
 	i toTime'=""   s toTime= $zth(toTime)
	
	s fromDate = stDate
	s toDate =endDate
	i fromDate'="" s fromDate=$zdh(fromDate,3)
 	i toDate'="" s toDate= $zdh(toDate,3) 
 	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","CARDRESUSC",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 	
 	s AllNum=0,DeathNum=0,DeathRatio=""
	f Date=fromDate:1:toDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)  
    ..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
   	..q:(Date=fromDate)&(PaAdmTime<fromTime)      //wxj 2020-11-25 开始日期的时间大于就诊的时间 退出
   	..q:(Date=toDate)&(PaAdmTime>toTime)       //wxj 2020-11-25 结束日期的时间小于就诊的时间 退出
   	..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid("",SetDataDiag)'="Y"	;验证诊断
   	..s HasOrdIDs=""
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s PatientID=+^PAADM(EpisodeID)
   	..s IsDeath = $p(^PAPER(PatientID,"ALL"),"^",12)
   	..q:(type=1)&&(IsDeath'="Y")   //未死亡的过滤，留下死亡的人数
	..;q:(type=2)&&(IsDeath="Y")
	..s DeceasedDate=$p(^PAPER(PatientID,"ALL"),"^",13)
	..s DeceasedTime=$p(^PAPER(PatientID,"ALL"),"^",8)
	..s:DeceasedDate'="" DeceasedDate=$zd(DeceasedDate,3)
	..s:DeceasedTime'="" DeceasedTime=$zt(DeceasedTime,2)
	..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
   	..s AdmDoctorID=$P($g(^PAADM(EpisodeID)),"^",9)
	..s PAAdmDoc=$P($g(^CTPCP(+AdmDoctorID,1)),"^",2)			;医师姓名
	..;s PCLCreatorDr=$p(^DHCEMPCL(PCLRowID),"^",3)   
	..s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) 				;就诊日期
	..s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) 				;就诊时间
	..s PaAdmDate=$zd(PaAdmDate,3)
	..s PaAdmTime=$zt(PaAdmTime,2)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     			;登记号
	..s PatSex=""
	..s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       			;姓别
	..i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
	..s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 		;年龄
	..s MrNo="",WardDesc="",Doctor="",ILoc=""
	..s IPBKRowID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeID,""),-1)
	..i IPBKRowID'="" d
	...s ToAdmID=$p($g(^DHCDocIPBK(IPBKRowID)),"^",3)
	...q:ToAdmID=""
	...s MrNo=##class(web.DHCDocOrderCommon).GetMrNo(ToAdmID,"","I")
	...s WardID=$p(^PAADM(ToAdmID),"^",70)
	...s WardDesc=$p($g(^PAWARD(+WardID)),"^",2)
	...s DoctorID=$P($g(^PAADM(ToAdmID)),"^",9)   ///主管医生
	...s Doctor=$P($g(^CTPCP(+DoctorID,1)),"^",2)
	...s ILocID=$p(^PAADM(ToAdmID),"^",4)
    ...s ILoc=$p(^CTLOC(ILocID),"^",2)
	..d OutPutEmPatDeathRatioData

    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutEmCardResRatioData
	set Data=$lb(PAAdmDoc,PaAdmDate,PaAdmTime,PatName,PatSex,PatAge,PatNo,PatDiag,DeceasedDate,DeceasedTime,MrNo,UsedDrugsName,ILoc,WardDesc,Doctor)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod EmCardResRatioDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EmCardResRatioDataExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod EmCardResRatioDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EmCardResRatioDataExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Description: 预检分级病72小时重返率
/// Creator:     qqa
/// CreateDate:  2017-07-18
/// Input:  	 开始时间，结束时间
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","SeventyTwoHoursReturnRatio","2017-03-19","2022-10-20")
Query SeventyTwoHoursReturnRatio(stDate, endDate, HOSPID = "") As %Query(ROWSPEC = "ReturnObsNumber,DispNumber,Ratio") [ SqlProc ]
{
}

ClassMethod SeventyTwoHoursReturnRatioExecute(ByRef qHandle As %Binary, stDate, endDate, HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,HOSPID)
	
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	i stDate'="" s stDate=$zdh(stDate,3)
 	i endDate'="" s endDate= $zdh(endDate,3)
 	i stDate="" s stDate=+$h
 	i endDate="" s endDate= +$h-1
	
	s DispNumber=0,ReturnObsNumber=0
	f Date=stDate:1:endDate {
		s EpisodeID=""
		f {
			s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID))
			q:EpisodeID=""
			s AdmCurrentWardDr=$p(^PAADM(EpisodeID),"^",70)
			continue:AdmCurrentWardDr=""
			s AdmVisit=$p(^PAADM(EpisodeID),"^",20)
			continue:AdmVisit'="D"
			s DispNumber=DispNumber+1
			s DispDateTime="",ReturnObsDateTime=""
			s ReturnObsAdmId=##class(web.DHCEMPatCheckLevStatis).ReturnObsAdmId(EpisodeID,.DispDateTime,.ReturnObsDateTime)	;72小时内重返就诊
			s:ReturnObsAdmId'="" ReturnObsNumber=ReturnObsNumber+1
		}	
	}
	s:+DispNumber=0 Ratio="0%"
	s:+DispNumber'=0 Ratio=$j(ReturnObsNumber/DispNumber,1,2)*100_"%"
	d SeventyTwoHoursReturnRatio
	
	Quit $$$OK
SeventyTwoHoursReturnRatio
	s Data=$lb(ReturnObsNumber,DispNumber,Ratio)       
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod SeventyTwoHoursReturnRatioClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SeventyTwoHoursReturnRatioExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod SeventyTwoHoursReturnRatioFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SeventyTwoHoursReturnRatioExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Description: 预检分级病72小时重返病人明细
/// Creator:     qqa
/// CreateDate:  2017-07-18
/// Input:  	 开始时间，结束时间
/// Return: 	 报告表数据
/// Others:		 d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStatis","SeventyTwoHoursReturn","2017-03-19","2022-10-20")
Query SeventyTwoHoursReturn(stDate, endDate, type = "", HOSPID = "") As %Query(ROWSPEC = "PatName,PatNo,PatSex,PatAge,AdmCurrentWard,PatDiag,DispDate,DispTime,ReturnAdmCurrentWard,ReturnPatDiag,ReturnObsDate,ReturnObsTime") [ SqlProc ]
{
}

ClassMethod SeventyTwoHoursReturnExecute(ByRef qHandle As %Binary, stDate, endDate, type = "", HOSPID = "") As %Status
{
	n (qHandle,stDate,endDate,type,HOSPID)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	i (stDate="")||(endDate="" ) Quit $$$OK
	
	i stDate'="" s stDate=$zdh(stDate,3)
 	i endDate'="" s endDate= $zdh(endDate,3)
 	i stDate="" s stDate=+$h
 	i endDate="" s endDate= +$h-1
	
	f Date=stDate:1:endDate {
		s EpisodeID=""
		f {
			s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID))
			q:EpisodeID=""
			s AdmCurrentWardDr=$p(^PAADM(EpisodeID),"^",70)
			continue:AdmCurrentWardDr=""
			s AdmVisit=$p(^PAADM(EpisodeID),"^",20)
			continue:AdmVisit'="D"
			s DispDateTime="",ReturnObsDateTime=""
			s ReturnObsAdmId=##class(web.DHCEMPatCheckLevStatis).ReturnObsAdmId(EpisodeID,.DispDateTime,.ReturnObsDateTime)	;72小时内重返就诊
			continue:(type'="")&&(ReturnObsAdmId="")
			
			s DispDate=$p(DispDateTime,",",1)							;离院日期
			s DispTime=$p(DispDateTime,",",2)
			s ReturnObsDate="",ReturnObsTime=""
			i ReturnObsDateTime'="" {
				s ReturnObsDate=$p(ReturnObsDateTime,",",1)				;重返日期
				s ReturnObsTime=$p(ReturnObsDateTime,",",2)
			}
			
			s DispDate=$zd(DispDate,3)
			s DispTime=$zt(DispTime,2)
			s ReturnObsDate=$zd(ReturnObsDate,3)
			s ReturnObsTime=$zt(ReturnObsTime,2)
			s PatientID=$p(^PAADM(EpisodeID),"^",1)
			s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)    			;姓名
			s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     		;登记号
			s PatSex=""
			s SexID=$p(^PAPER(PatientID,"ALL"),"^",7)       		;姓别
			i SexID'="" s PatSex=$p(^CT("SEX",SexID),"^",2)
			s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) 	;年龄
			s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
			s AdmCurrentWard=$p(^PAWARD(AdmCurrentWardDr),"^",2)				;病区
			s ReturnAdmCurrentWardDr="",ReturnAdmCurrentWard="",ReturnPatDiag=""
			i ReturnObsAdmId'="" {
				s ReturnAdmCurrentWardDr=$p(^PAADM(ReturnObsAdmId),"^",70)
				s ReturnAdmCurrentWard=$p(^PAWARD(ReturnAdmCurrentWardDr),"^",2)	;重返病区
				s ReturnPatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(ReturnObsAdmId,",")	;重返诊断
			}
			d SeventyTwoHoursReturn
		}	
	}
	
	Quit $$$OK
SeventyTwoHoursReturn
	s Data=$lb(PatName,PatNo,PatSex,PatAge,AdmCurrentWard,PatDiag,DispDate,DispTime,ReturnAdmCurrentWard,ReturnPatDiag,ReturnObsDate,ReturnObsTime)       
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod SeventyTwoHoursReturnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SeventyTwoHoursReturnExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod SeventyTwoHoursReturnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SeventyTwoHoursReturnExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
 }
 Else {			
 		Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// 获取离院时间
/// w ##class(web.DHCEMPatCheckLevStatis).DispMDateTime(291)
ClassMethod DispMDateTime(EpisodeID)
{
	q ##class(web.DHCEMPatCheckLevStatis).AdmVisitMDateTime(EpisodeID,"Discharge",-1)
}

/// AdmVisitStatusCode: 要查哪个状态的时间
/// DateCat:查第一次出现状态还是最后一次 1,-1
/// Return:时间
ClassMethod AdmVisitMDateTime(EpisodeID, AdmVisitStatusCode, DateCat = 1)
{
	
	s AdmVisitMDateTime=""
	s AvsID=""
	f {
		s AvsID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,AvsID),DateCat)
		q:(AvsID="")||(AdmVisitMDateTime'="")
		s PvsID=$P(^DHCADMVisitStatus(AvsID),"^",2)
		s WalkStatusCode=$p(^DHCPACVisitStatus(PvsID),"^",1)
		continue:("^"_AdmVisitStatusCode_"^")'[WalkStatusCode
		s AdmVisitMDateTime=$p(^DHCADMVisitStatus(AvsID),"^",5,6)
	}

	q AdmVisitMDateTime
}

ClassMethod ReturnObsAdmId(EpisodeID, ByRef DispDateTime, ByRef ReturnObsDateTime)
{
	
	s DispMDateTime=##class(web.DHCEMPatCheckLevStatis).DispMDateTime(EpisodeID)	;离院时间
	q:DispMDateTime="" ""
	
	s DispDateTime=DispMDateTime
	s DispMDateTime=$tr(DispMDateTime,"^",",")

	s ReturnObsAdmId=""
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s NextEpisodeID=EpisodeID
	f {
		s NextEpisodeID=$o(^PAPERdr(PatientID,"ADM","E",NextEpisodeID))
		q:(NextEpisodeID="")||(ReturnObsAdmId'="")
		s NextAdmCurrentWardDr=$p(^PAADM(NextEpisodeID),"^",70)
		continue:NextAdmCurrentWardDr=""
		s NextAdmDateTime = $p($g(^PAADM(NextEpisodeID)),"^",6,7)
		s NextAdmDateTime = $tr(NextAdmDateTime,"^",",")
		q:'($SYSTEM.SQL.DATEDIFF("hh",DispMDateTime,NextAdmDateTime)<72)	;离院时间72小时后的挂号停止遍历
		s NextObsMDateTime = ##class(web.DHCEMPatCheckLevStatis).AdmVisitMDateTime(NextEpisodeID,"Stay^Salvage")
		continue:NextObsMDateTime=""
		s NextObsMDateTime=$tr(NextObsMDateTime,"^",",")
		if $SYSTEM.SQL.DATEDIFF("hh",DispMDateTime,NextObsMDateTime)<72 d
		.s ReturnObsAdmId=NextEpisodeID
		.s ReturnObsDateTime=DispMDateTime_"^"_NextObsMDateTime
	}

	q ReturnObsAdmId
}

/// 
/// Return:;时间@体温@心率HR@脉搏R@收缩压@舒张压@血氧饱合度SoP2@呼吸频率@血糖
/// Other:w ##class(web.DHCEMPatCheckLevStatis).GetEmPatChkSignItm(1)
ClassMethod GetEmPatChkSignItm(EpisodeID)
{
	s EmPCLvID=""
	s:$d(^DHCEMPCA(0,"AdmChkLev",EpisodeID))>=10 EmPCLvID =$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
	q:+EmPCLvID=0 ""
	
	s EmPcsID="",PcsID=""
	f  s PcsID=$o(^DHCEMPCS(0,"PatCheckLev",EmPCLvID,PcsID),-1) q:(PcsID="")!(EmPcsID'="")  d
	.s PcsTime=$p(^DHCEMPCS(PcsID),"^",2)
	.s EmPcsID=PcsID
	
	s EmPcsTime=$p(^DHCEMPCS(EmPcsID),"^",2)   /// 时间
	s:EmPcsTime'="" EmPcsTime=$zt(EmPcsTime,2)
	s EmPcsTemp=$p(^DHCEMPCS(EmPcsID),"^",3)   /// 体温
	s EmPcsHeart=$p(^DHCEMPCS(EmPcsID),"^",4)  /// 心率HR
	s EmPcsPulse=$p(^DHCEMPCS(EmPcsID),"^",5)  /// 脉搏R
	s EmPcsSBP=$p(^DHCEMPCS(EmPcsID),"^",6)    /// 血压(BP)收缩压
	s EmPcsDBP=$p(^DHCEMPCS(EmPcsID),"^",7)    /// 舒张压
	s EmPcsSoP2=$p(^DHCEMPCS(EmPcsID),"^",8)   /// 血氧饱合度SoP2
	s EmPcsBreath=$p(^DHCEMPCS(EmPcsID),"^",9)   /// 呼吸频率
	s EmPcsGLU=$p(^DHCEMPCS(EmPcsID),"^",10)   ///血糖
	;时间@体温@心率HR@脉搏R@收缩压@舒张压@血氧饱合度SoP2@呼吸频率@血糖
	;S ListData=EmPcsTime_"@"_EmPcsTemp_"@"_EmPcsHeart_"@"_EmPcsPulse_"@"_EmPcsSBP_"@"_EmPcsDBP_"@"_EmPcsSoP2_"@"_EmPcsBreath_"@"_EmPcsGLU
	s ListData=EmPcsTemp_"^"_EmPcsSBP_"/"_EmPcsDBP_"^"_EmPcsPulse_"^"_EmPcsBreath_"^"_EmPcsSoP2
	q ListData
}

/// w ##class(web.DHCEMPatCheckLevStatis).GetLimitDateDesc()
ClassMethod GetLimitDateDesc(BeginDate, BeginTime, EndDate, EndTime)
{
	n (BeginDate,BeginTime,EndDate,EndTime)
	s NowDate=+$H
	s NowTime=$p($H,",",2)
	s:BeginDate="" BeginDate=NowDate
	s:EndDate="" EndDate=NowDate
	s:BeginTime="" BeginTime=NowTime
	s:EndTime="" EndTime=NowTime
	i $SYSTEM.SQL.DATEDIFF("ss",BeginDate_","_BeginTime,EndDate_","_EndTime)<0 d
	.s EndDate=NowDate
	.s EndTime=NowTime
	
	s LimitDate=(EndDate-BeginDate*24*60*60)+(EndTime-BeginTime)
	s LimitDay=LimitDate\86400
	s LimitHours=LimitDate#86400\3600
	s LimitMins=LimitDate#3600\60
	q LimitDay_"天"_LimitHours_"小时"_LimitMins_"分钟"
}

/// w ##class(web.DHCEMPatCheckLevStatis).GetLimitDateDescSql()
ClassMethod GetLimitDateDescSql(BeginDate, BeginTime, EndDate, EndTime)
{
	n (BeginDate,BeginTime,EndDate,EndTime)
	s NowDate=+$H
	s NowTime=$p($H,",",2)
	s:BeginDate="" BeginDate=NowDate
	s:EndDate="" EndDate=NowDate
	s:BeginTime="" BeginTime=NowTime
	s:EndTime="" EndTime=NowTime
	s Mi=$SYSTEM.SQL.DATEDIFF("n",BeginDate_","_BeginTime,EndDate_","_EndTime)
	q Mi
}

/// w ##class(web.DHCEMPatCheckLevStatis).IsSalvagePat(3369)
ClassMethod IsSalvagePat(EpisodeID)
{
	n (EpisodeID)
	s IsSalvage=""
	s AvsID=""
	f  s AvsID=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,AvsID)) q:(AvsID="")||(IsSalvage'="")  d
	.s PvsID=$P(^DHCADMVisitStatus(AvsID),"^",2)
   	.s WalkStatus=$p(^DHCPACVisitStatus(PvsID),"^",1)
   	.s:WalkStatus="Salvage" IsSalvage="Y"
   	q IsSalvage
}

/// w ##class(web.DHCEMPatCheckLevStatis).FormatSettingData("[12]{2}")
ClassMethod FormatSettingData(SetData)
{
	n (SetData)
	q:SetData="" ""
	s SetDataDiag=$p(SetData,"]",1)
	s SetDataDiag=$p(SetDataDiag,"[",2)
	s SetDataOrd=$p(SetData,"}",1)
	s SetDataOrd=$p(SetDataOrd,"{",2)
	q SetDataDiag_"^"_SetDataOrd
}

/// Creator:qqa
/// Descript:医嘱已经作废
/// Input:医嘱id
/// Return: Y/N
/// w ##class(web.DHCEMPatCheckLevStatis).IsCongFanPatForAdmID("")
ClassMethod OrdIsStop(Ord, Itm)
{
	s OrdStatusId=$p($g(^OEORD(Ord,"I",Itm,1)),"^",13)  
    s OrdStatusCode = $p($g(^OEC("OSTAT",OrdStatusId)),"^",1)
    q:(OrdStatusCode="U")||(OrdStatusCode="C")||(OrdStatusCode="D") "Y" //作废 撤销 停止	
    q "N"
}

Storage Default
{
<Data name="DHCEMPatCheckLevStatisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMPatCheckLevStatisD</DataLocation>
<DefaultData>DHCEMPatCheckLevStatisDefaultData</DefaultData>
<IdLocation>^web.DHCEMPatCheckLevStatisD</IdLocation>
<IndexLocation>^web.DHCEMPatCheckLevStatisI</IndexLocation>
<StreamLocation>^web.DHCEMPatCheckLevStatisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
