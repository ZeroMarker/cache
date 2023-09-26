Class DHCDoc.Interface.Inside.IOT.AdmInfo Extends DHCDoc.Util.RegisteredObject
{

/// creator:tanjishan
/// date:2019-09-09
/// desc:互联互通共享文档【1.4病人就诊信息表】
/// input：	SttDate&EndDate[YYYY-MM-DD]  门急诊患者检索的是就诊时间范围，住院患者检索的是出院时间范围；
/// 										*需核实是否存在^PAADMi("DischargeDateExt",{PAADM_DischargeDate},{PAADM_RowID})该索引
/// 		HOSPCode院区代码
Query QueryAdmInfo(SttDate As %String, EndDate As %String, HOSPCode As %String) As %Query(ROWSPEC = "PatID:%String:患者ID,AdmID:%String:就诊ID号,VisitTimes:%String:住院次数,InpatientID:%String:住院号,InsureTypeCode:%String:医疗保险类别代码,PayModeCode:%String:医疗付费方式代码,InModeCode:%String:入院途径代码,InsureTypeDesc:%String:医疗保险类别代码描述,PayModeDesc:%String:医疗付费方式描述,InModeDesc:%String:入院途径描述,DisDateTime:%String:出院日期时间,InDateTime:%String:入院日期时间(就诊日期时间),DiseaseDateTime:%String:发病日期时间,BedNo:%String:病床号,RoomNo:%String:病房号,InWardCode:%String:入院病区代码,InWardName:%String:入院病区名称,InDeptCode:%String:入院（就诊）科别代码,InDeptDesc:%String:入院（就诊）科别,OutWardCode:%String:出院病区代码,OutWardName:%String:出院病区名称,OutDeptCode:%String:出院科别代码,OutDeptDesc:%String:出院科别,PatTypeCode:%String:患者类型代码,PatTypeDesc:%String:患者类型描述,TransferDept:%String:转科科别,InDay:%String:实际住院天数,OutModeCode:%String:离院方式代码,OutModeDesc:%String:离院方式描述,HeaderCode:%String:科主任签名代码,HeaderName:%String:科主任签名,DirectorCode:%String:主任（副主任）医师签名代码,DirectorName:%String:主任（副主任）医师签名,AttendingCode:%String:主治医师签名代码,AttendingName:%String:主治医师签名,ResidentCode:%String:住院医师签名代码,ResidentName:%String:住院医师签名,AdmDocCode:%String:主诊医师签名代码,AdmDocName:%String:主诊医师签名,RefresherCode:%String:进修医师签名代码,RefresherName:%String:进修医师签名,InternCode:%String:实习医师签名代码,InternName:%String:实习医师签名,ResponNurseCode:%String:责任护士签名代码,ResponNurseName:%String:责任护士签名,NursingCode:%String:护理等级代码,NursingDesc:%String:护理等级描述,NursingTypeCode:%String:护理类型代码,NursingTypeDesc:%String:护理类型描述,HDSD0006115:%String:体重,OutpatientID:%String:门（急）诊号,RoomNoCode:%String:病房号代码,BabyBornWeight:%String:新生儿出生体重（g）,BabyInWeight:%String:新生儿入院体重（g）") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.Interface.Inside.IOT.AdmInfo","QueryAdmInfo","2019-05-01","2019-09-10","")
ClassMethod QueryAdmInfoExecute(ByRef qHandle As %Binary, SttDate As %String, EndDate As %String, HOSPCode As %String) As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 1
	set qHandle = $lb(0,repid,0)
	s SttDate=$ZDH(SttDate,3)
	s EndDate=$ZDH(EndDate,3)
	///门急诊的按照就诊时间输出
	s mTypeStr="O^E"
	for mi=1:1:$L(mTypeStr,"^"){
		s mPAADMType=$P(mTypeStr,"^",mi)
		for mPAADMAdmDate=SttDate:1:EndDate{
			s mPAADMAdmTime=""
			for {
				s mPAADMAdmTime=$O(^PAADMi("TypeDate",mPAADMType,mPAADMAdmDate,mPAADMAdmTime))
				q:(mPAADMAdmTime="")
				s mEpisodeID=""
				for {
					s mEpisodeID=$O(^PAADMi("TypeDate",mPAADMType,mPAADMAdmDate,mPAADMAdmTime,mEpisodeID))
					q:(mEpisodeID="")
					s mAdmLocDr=$P($G(^PAADM(mEpisodeID)),"^",4)
					continue:mAdmLocDr=""
					s mHospDr=$P($G(^CTLOC(mAdmLocDr)),"^",22)
					s mHospCode=""
					if (mHospDr'=""){
						s mHospCode=$P($G(^CT("HOSP",mHospDr)),"^",1)
					}
					continue:(HOSPCode'="")&&(HOSPCode'=mHospCode)
					d GetAdmInfoData(mEpisodeID)
				}
			}
		}
			
	}
	///住院的按照出院时间输出
	for mPAADMDischargeDate=SttDate:1:EndDate{
		s mEpisodeID=""
		for {
			s mEpisodeID=$O(^PAADMi("DischargeDateExt",mPAADMDischargeDate,mEpisodeID))
			q:(mEpisodeID="")
			s mAdmLocDr=$P($G(^PAADM(mEpisodeID)),"^",4)
			continue:mAdmLocDr=""
			s mHospDr=$P($G(^CTLOC(mAdmLocDr)),"^",22)
			s mHospCode=""
			if (mHospDr'=""){
				s mHospCode=$P($G(^CT("HOSP",mHospDr)),"^",1)
			}
			continue:(HOSPCode'="")&&(HOSPCode'=mHospCode)
			d GetAdmInfoData(mEpisodeID)
		}
	}
	
	
	Q $$$OK
GetAdmInfoData(EpisodeID)
	if (EpisodeID=""){
		Q
	}
	d ReSetAdmInfo
	if '$D(^PAADM(EpisodeID)) {
		Q
	}
	s PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
	s PAADMStr=$G(^PAADM(EpisodeID))
	//患者ID
	s PatID=$P(PAADMStr,"^",1)
	//就诊ID号
	s AdmID=EpisodeID
	//住院次数
	s VisitTimes=$P(PAADMStr,"^",29)
	if (PAADMType="I"){
		//住院号
		s InpatientID=$p($g(^PAADM(EpisodeID)),"^",81)
	}else{
		//门（急）诊号
		s OutpatientID=$p($g(^PAADM(EpisodeID)),"^",81)
	}
	///s PatIPNo=$p($G(^PAPER(PatID,"PAT",1)),"^",1) ;住院号
	//s InpatientID=##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)
	//s OutpatientID=$p($G(^PAPER(PatID,"PAT",1)),"^",2)	;门诊号
	
	//医疗保险类别代码
	s InsureTypeCode=""
	//医疗付费方式代码
	s PayModeCode=""
	
	//医疗保险类别代码描述
	s InsureTypeDesc=""
	//医疗付费方式描述
	s PayModeDesc=""
	s AdmSrcDR=$P(PAADMStr,"^",10)
	if (AdmSrcDR'=""){
		//入院途径代码
		s InModeCode=$P($G(^PAC("ADSOU",AdmSrcDR)),"^",1)
		//入院途径描述
		s InModeDesc=$P($G(^PAC("ADSOU",AdmSrcDR)),"^",2)
	}
	s DisChangeDateInfo=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetDischargeDateTime",EpisodeID)
	//##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID)
	s PAAdmDischgeDateSys=$p(DisChangeDateInfo,"^",1) //$P($g(^PAADM(PAADMRowID)),"^",17)
	s PAAdmDischgeTimeSys=$p(DisChangeDateInfo,"^",2) //$P($g(^PAADM(PAADMRowID)),"^",18)
	if (PAAdmDischgeDateSys '= ""){
		//出院日期时间
		s DisDateTime=$zd(PAAdmDischgeDateSys,3)_" "_..%ZT(PAAdmDischgeTimeSys,3)
	}
	s AdmDate=$P(PAADMStr,"^",6)
	s AdmTime=$P(PAADMStr,"^",7)
	//入院日期时间(就诊日期时间)
	s InDateTime=$zd(AdmDate,3)_" "_..%ZT(AdmTime,3)
	s MRAdm=##Class(web.DHCPAADM).GetMRAdmID(EpisodeID)
	
	if (MRAdm'=""){
		s SubDiagDr=0
		for {
			s SubDiagDr=$O(^MR(MRAdm,"DIA",SubDiagDr))
			q:(SubDiagDr="")
			s MRDiagnosTypeDr=""
			//w MRAdm_"||"_SubDiagDr_","_EpisodeID,!
			S SubRowid=$G(^MR(MRAdm,"DIA",SubDiagDr,"TYP",0))
			if SubRowid'="" s MRDiagnosTypeDr=$G(^MR(MRAdm,"DIA",SubDiagDr,"TYP",SubRowid))
			continue:(MRDiagnosTypeDr="")
			Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
			continue:(MRDiagnosTypeDesc'["入院")
			s OnsetDate=$P($G(^MR(MRAdm,"DIA",SubDiagDr)),"^",35)
			s OnsetTime=$P($G(^MR(MRAdm,"DIA",SubDiagDr)),"^",36)
			if (OnsetDate'=""){
				//发病日期时间
				s DiseaseDateTime=$zd(OnsetDate,3)_" "_..%ZT(OnsetTime,3)
			}
		}
	}
	if (DiseaseDateTime=""){
		s DiseaseDateTime=$zd($P(PAADMStr,"^",6),3)_" "_..%ZT($P(PAADMStr,"^",7),3)
	}
	///----取入院相关内容
	s (InWardCode,InWardName,InDeptCode,InDeptDesc,BedNo,RoomNo)=""
	s (InWardDr,InDeptDr)=""
	s currBedDr=$p($G(^PAADM(EpisodeID)),"^",73)
	i currBedDr'="" {
		s sub=""
		s NoLoopFlag="N"
		for{
			s sub = $O(^PAADM(EpisodeID,"TRANS",sub))
			q:(sub="")
			s mCTLOCDR=$p(^PAADM(EpisodeID,"TRANS",sub),"^",6)
			s mWardDR=$p(^PAADM(EpisodeID,"TRANS",sub),"^",9)
			//转科或转病区之后，都不算是入院首日接诊科室
			if (InDeptDr=""){
				s InDeptDr=mCTLOCDR
			}else{
				if (InDeptDr'=mCTLOCDR){
					if (mCTLOCDR'=""){
						//转科科别
						s TransferDept=$P($G(^CTLOC(mCTLOCDR)),"^",2)
					}
					s NoLoopFlag="Y"
				}
			}
			if (InWardDr=""){
				s InWardDr=mWardDR
			}else{
				if (InWardDr'=mWardDR){
					s NoLoopFlag="Y"
				}
			}
			if (NoLoopFlag="Y"){
				continue
			}
			s bedDr=$p(^PAADM(EpisodeID,"TRANS",sub),"^",8)
			if (bedDr'="")&&(BedNo=""){
				//病床号
				s BedNo=$p(^PAADM(EpisodeID,"TRANS",sub),"^",33)
			}
			s roomDr=$p(^PAADM(EpisodeID,"TRANS",sub),"^",7)
			if (roomDr'="")&&(RoomNo=""){
				//病房号
				s RoomNo=$P($G(^PAROOM(roomDr)),"^",2)
				//病房号代码
				s RoomNoCode=$P($G(^PAROOM(roomDr)),"^",1)
			}
			if (InDeptDr'="")&&(InDeptCode=""){
				//入院（就诊）科别代码
				s InDeptCode=$P($G(^CTLOC(InDeptDr)),"^",1)
				//入院（就诊）科别
				s InDeptDesc=$P($G(^CTLOC(InDeptDr)),"^",2)
			}
			if (InWardDr'="")&&(InWardCode=""){
				//入院病区代码
				s InWardCode=$P($G(^PAWARD(InWardDr)),"^",1)
				//入院病区名称
				s InWardName=$P($G(^PAWARD(InWardDr)),"^",2)
			}
		}
	}
	s AdmPACWardDr=$P(^PAADM(EpisodeID),"^",70)
	if (AdmPACWardDr'=""){
		//出院病区代码
		s OutWardCode=$P($G(^PAWARD(AdmPACWardDr)),"^",1)
		//出院病区名称
		s OutWardName=$P($G(^PAWARD(AdmPACWardDr)),"^",2)
	}
	s DepCodeDR=$P(^PAADM(EpisodeID),"^",4)
	if (DepCodeDR'=""){
		//出院科别代码
		s OutDeptCode=$P($G(^CTLOC(DepCodeDR)),"^",1)
		//出院科别
		s OutDeptDesc=$P($G(^CTLOC(DepCodeDR)),"^",2)
	}
	s AdmReason=$P($G(^PAADM(EpisodeID,1)),"^",7)
	if (AdmReason'=""){
		//患者类型代码
		s PatTypeCode=$P($G(^PAC("ADMREA",AdmReason)),"^",1)
		//患者类型描述
		s PatTypeDesc=$P($G(^PAC("ADMREA",AdmReason)),"^",2)
	}
	set AdmDateInfo=##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID)
	set AdmDate=$p(AdmDateInfo,"^",1)
	
	set DisDateInfo=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.doc.GetDischargeDateTime",EpisodeID)
	set DisDate=$p(DisDateInfo,"^",1)
	if (DisDate'=""){
		//实际住院天数
		set InDay=DisDate-AdmDate	
	}else{
		set InDay=..%SysDate()-AdmDate
	}
	//离院方式代码
	s OutModeCode=""
	//离院方式描述
	s OutModeDesc=""
	
	s PAADMDocCode=$p($g(^PAADM(EpisodeID)),"^",9)
	if (PAADMDocCode '= ""){
		s PAAdmDocCodeDR = $p($g(^CTPCP(PAADMDocCode,1)),"^",2)		;------管床医生
		s PAAdmDocUserDr=$O(^SSU("SSUSR",0,"CTPCP",PAAdmDocCodeDR,0))
		if (PAAdmDocUserDr'=""){
			//主治医师签名代码
			s AttendingCode=$P($G(^SSU("SSUSR",PAAdmDocUserDr)),"^",1)
			//主治医师签名
			s AttendingName=$P($G(^SSU("SSUSR",PAAdmDocUserDr)),"^",2)
		}
		if $D(^oddCOM("web.DHCDocInPatientListNew","m","GetHadeUniteDoc")){
			s HeadUniteDocStr = ##Class(web.DHCDocInPatientListNew).GetHadeUniteDoc(PAAdmDocCodeDR,DepCodeDR)
			s LeaderDoctorDR = $p(HeadUniteDocStr,"^",1)		///-------带组医师  
			if (LeaderDoctorDR'= ""){
				//主任（副主任）医师签名代码
				s DirectorCode=$P($G(^SSU("SSUSR",LeaderDoctorDR)),"^",1)
				//主任（副主任）医师签名
				s DirectorName=$P($G(^SSU("SSUSR",LeaderDoctorDR)),"^",2)
			}
		}
		if $D(^oddCOM("EMRservice.DAL.GetPaAdmDetail","m","GetChiefDoc")){
			s ChiefDocStr = ##class(EMRservice.DAL.GetPaAdmDetail).GetChiefDoc(PAAdmDocCodeDR)
			s ChiefDocCode = $p(ChiefDocStr,"^",1)		///主任医师
			s ChiefDocDesc = $p(ChiefDocStr,"^",2)
			if (ChiefDocDesc '= ""){
				//科主任签名代码
				s HeaderCode=ChiefDocCode
				//科主任签名
				s HeaderName=ChiefDocDesc
			}
		}
	}
	//住院医师签名代码
	s ResidentCode=""
	//住院医师签名
	s ResidentName=""
	//主诊医师签名代码
	s AdmDocCode=""
	//主诊医师签名
	s AdmDocName=""
	//进修医师签名代码
	s RefresherCode=""
	//进修医师签名
	s RefresherName=""
	//实习医师签名代码
	s InternCode=""
	//实习医师签名
	s InternName=""
	//责任护士签名代码---管床护士
	s ResponNurseCode=""
	//责任护士签名
	s ResponNurseName=""
	s NursingStr=$$GetAdmNursing(EpisodeID)
	//护理等级代码
	s NursingCode=$P(NursingStr,"^",1)
	//护理等级描述
	s NursingDesc=$P(NursingStr,"^",2)
	//护理类型代码
	s NursingTypeCode=""
	//护理类型描述
	s NursingTypeDesc=""
	//体重
	s HDSD0006115=$P($G(^MR(MRAdm,"PRO",1)),"^",27)
	//新生儿出生体重（g）
	s BabyBornWeight=""
	//新生儿入院体重（g）
	s BabyInWeight=""
	d OutputRowAdmInfo
	
	
	Q
OutputRowAdmInfo
	Set Data=$LB(PatID,AdmID,VisitTimes,InpatientID,InsureTypeCode,PayModeCode,InModeCode,InsureTypeDesc,PayModeDesc,InModeDesc,DisDateTime,InDateTime,DiseaseDateTime,BedNo,RoomNo,InWardCode,InWardName,InDeptCode,InDeptDesc,OutWardCode,OutWardName,OutDeptCode,OutDeptDesc,PatTypeCode,PatTypeDesc,TransferDept,InDay,OutModeCode,OutModeDesc,HeaderCode,HeaderName,DirectorCode,DirectorName,AttendingCode,AttendingName,ResidentCode,ResidentName,AdmDocCode,AdmDocName,RefresherCode,RefresherName,InternCode,InternName,ResponNurseCode,ResponNurseName,NursingCode,NursingDesc,NursingTypeCode,NursingTypeDesc,HDSD0006115,OutpatientID,RoomNoCode,BabyBornWeight,BabyInWeight)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
ReSetAdmInfo
	s (PatID,AdmID,VisitTimes,InpatientID,InsureTypeCode,PayModeCode,InModeCode,InsureTypeDesc,PayModeDesc,InModeDesc,DisDateTime,InDateTime,DiseaseDateTime,BedNo,RoomNo,InWardCode,InWardName,InDeptCode,InDeptDesc,OutWardCode,OutWardName,OutDeptCode,OutDeptDesc,PatTypeCode,PatTypeDesc,TransferDept,InDay,OutModeCode,OutModeDesc,HeaderCode,HeaderName,DirectorCode,DirectorName,AttendingCode,AttendingName,ResidentCode,ResidentName,AdmDocCode,AdmDocName,RefresherCode,RefresherName,InternCode,InternName,ResponNurseCode,ResponNurseName,NursingCode,NursingDesc,NursingTypeCode,NursingTypeDesc,HDSD0006115,OutpatientID,RoomNoCode,BabyBornWeight,BabyInWeight)=""
	Quit
GetAdmNursing(EpisodeID)
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	;获取护理类型
	;---1、获取护理类医嘱
	s ArcimDrT=$$GetNursingOrd("CRITICALCARE","特级护理",AdmHospitalId)
	s ArcimDr1=$$GetNursingOrd("FIRSTCLSCARE","一级护理",AdmHospitalId)
	i ArcimDr1="" s ArcimDr1=$$GetNursingOrd("FIRSTCLSCARE","Ⅰ级护理",AdmHospitalId)
	s ArcimDr2=$$GetNursingOrd("SECONDCLSCARE","二级护理",AdmHospitalId)
	i ArcimDr2="" s ArcimDr2=$$GetNursingOrd("FIRSTCLSCARE","Ⅱ级护理",AdmHospitalId)
	s ArcimDr3=$$GetNursingOrd("THIRDCLSCARE","三级护理",AdmHospitalId)
	i ArcimDr3="" s ArcimDr3=$$GetNursingOrd("FIRSTCLSCARE","Ⅲ级护理",AdmHospitalId)
	if (ArcimDr3="")||(ArcimDr2="")||(ArcimDr1="")||(ArcimDrT=""){
		q ""
	}
	s AvailOrd=$$CheckAvailOrd(EpisodeID,ArcimDrT)
	if (AvailOrd="Y"){
		q "特级护理^特级护理"
	}
	s AvailOrd=$$CheckAvailOrd(EpisodeID,ArcimDr1)
	if (AvailOrd="Y"){
		q "一级护理^一级护理"
	}
	s AvailOrd=$$CheckAvailOrd(EpisodeID,ArcimDr2)
	if (AvailOrd="Y"){
		q "二级护理^二级护理"
	}
	s AvailOrd=$$CheckAvailOrd(EpisodeID,ArcimDr3)
	if (AvailOrd="Y"){
		q "三级护理^三级护理"
	}
	q ""
CheckAvailOrd(EpisodeID,ArcimStr)
	s AvailOrd="N"
	s ordid=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:(ordid="") AvailOrd
	for i=1:1:$L(ArcimStr,"^"){
		q:(AvailOrd="Y")
		s ArcimDr=$P(ArcimStr,"^",i)
		s sttdat=""
		for {
			s sttdat=$O(^OEORDi(0,"ARCIM",ordid,ArcimDr,sttdat))
			q:(sttdat="")||(AvailOrd="Y")
			s ordsubid=0
			for {
				s ordsubid=$O(^OEORDi(0,"ARCIM",ordid,ArcimDr,sttdat,ordsubid))
				q:(ordsubid="")||(AvailOrd="Y")
				s ExecID=0
				for {
					s ExecID=$O(^OEORD(ordid,"I",ordsubid,"X",ExecID))
					q:(ExecID="")||(AvailOrd="Y")
					s StatusRowId=$P(^OEORD(ordid,"I",ordsubid,"X",ExecID),"^",16)
					s StatusCode=""
					if (StatusRowId'=""){
						s StatusCode=$P($G(^OEC("STAT",StatusRowId)),"^",1)
					}
					continue:(StatusCode="D")
					s AvailOrd="Y"
				}
			}
			
		}
	}
	q AvailOrd
GetNursingOrd(ARCIMTypeCode,ArcimTypeDesc,AdmHospitalId)
	if $D(^oddCOM("Nur.ImageSet","m","GetArcCode")){
		s ArcimCode=##class(Nur.ImageSet).GetArcCode(ARCIMTypeCode,AdmHospitalId)
	}else{
		s ArcimCode=""
	}
	s NursingOrdS=""
	for i=1:1:$L(ArcimCode,"^") {
		s code=$p(ArcimCode,"^",i)
		continue:code=""
		s rowidm=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(code),""))
		continue:rowidm=""
		if (NursingOrdS=""){
			s NursingOrdS=rowidm_"||1"
		}else{
			s NursingOrdS=NursingOrdS_"^"_rowidm_"||1"
		}
	}
	if (NursingOrdS=""){
		s rowidm=$O(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(ArcimTypeDesc),0))
		if (rowidm'=""){
			s NursingOrdS=rowidm_"||1"
		}
	}
	q NursingOrdS
}

ClassMethod QueryAdmInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAdmInfoExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QueryAdmInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAdmInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

}
