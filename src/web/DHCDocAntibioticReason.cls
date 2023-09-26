Class web.DHCDocAntibioticReason Extends %RegisteredObject
{

ClassMethod GetAntReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAntReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetAntReasonExecute(ByRef qHandle As %Binary, Poisoncode As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCDocAntibioticReason","GetAntReason","KSS2")
	//s ^liyufeng("GetInstrExecute")=code
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	s DTAUPRowid=0
 	for  Set DTAUPRowid=$o(^DTAUP("AUP",DTAUPRowid)) Quit:DTAUPRowid=""  do
 	.Set ActiveFlag=$p(^DTAUP("AUP",DTAUPRowid),"^",4)
 	.Quit:ActiveFlag'="Y"
 	.Set Desc=$p(^DTAUP("AUP",DTAUPRowid),"^",2)
 	.Set Code=$p(^DTAUP("AUP",DTAUPRowid),"^",1)
 	.set Reason=$p(^DTAUP("AUP",DTAUPRowid),"^",3)
 	.;q:(Poisoncode'="")&&(Poisoncode="KSS3")&&(Reason=1)   //特殊使用类抗菌药物仅限于治疗用
   	.Do OutwardRow2
	Quit $$$OK
OutwardRow2
	set Data=$lb(DTAUPRowid,Desc,Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAntReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAntReasonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetAntReason(Poisoncode As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod GetAntIndicationsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAntIndicationsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetAntIndicationsExecute(ByRef qHandle As %Binary, ReasonId As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCDocAntibioticReason","GetAntIndications",1)
	//s ^liyufeng("GetInstrExecute")=code
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	Set DAINDRowid=0
 	Quit:ReasonId="" $$$OK
 	Set AURRowid=$p(^DTAUP("AUP",ReasonId),"^",3)
 	For  Set DAINDRowid=$o(^DAIND("AUR",AURRowid,DAINDRowid)) Quit:DAINDRowid=""  do
 	.Set ActiveFlag=$p(^DAIND("DAIND",DAINDRowid),"^",4)
 	.Quit:ActiveFlag'="Y"
 	.Set Desc=$p(^DAIND("DAIND",DAINDRowid),"^",2)
 	.Set Code=$p(^DAIND("DAIND",DAINDRowid),"^",1)
   	.Do OutwardRow2
	Quit $$$OK
OutwardRow2
	set Data=$lb(DAINDRowid,Desc,Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAntIndicationsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAntIndicationsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetAntIndications(ReasonId As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod GetBodyPartsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBodyPartsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetBodyPartsExecute(ByRef qHandle As %Binary) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCDocAntibioticReason","GetBodyParts")
	//s ^liyufeng("GetInstrExecute")=code
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	Set BODPRowId=0
 	For  Set BODPRowId=$o(^MRC("BODP",BODPRowId)) Quit:BODPRowId=""  do
 	.Set Desc=$p(^MRC("BODP",BODPRowId),"^",2)
 	.Set Code=$p(^MRC("BODP",BODPRowId),"^",1)
   	.Do OutwardRow2 
	Quit $$$OK
OutwardRow2
	set Data=$lb(BODPRowId,Desc,Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetBodyPartsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBodyPartsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetBodyParts() As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod GetOperationsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOperationsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetOperationsExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCDocAntibioticReason","GetOperations",594)
	//s ^liyufeng("GetInstrExecute")=code
	
	Set repid=$I(^CacheTemp)
 	s ind=1
 	Set qHandle=$lb(0,repid,0)
 	s opaId=0
 	//Set EpisodeID=594
 	Set opaAdmDr=EpisodeID
	f  s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
	.s anaId=$P(^DHCANOPArrange(opaId),"^",2) ;手术麻醉Id
	.s OPAStatus=$P(^DHCANOPArrange(opaId),"^",27)
	.q:((OPAStatus="D")||(OPAStatus="A")) ; 状态A表示申请状态，并未安排手术，状态D表示撤销状态
	.s anaSub=$P(anaId,"||",2)
	.s anaopSub=0 
	.Set opName=""   //手术名称
	.Set operLocId=""
	.f  s anaopSub=$O(^OR(opaAdmDr,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d  
	..s curOperId=$P(^OR(opaAdmDr,"ANA",anaSub,"OP",anaopSub),"^",6)       ;ANAOP_Type_DR；手术名称
	..;q:curOperId=""
	..;if $D(^ORC("OPER",curOperId)) d
	...;i opName="" s opName=$P(^ORC("OPER",curOperId),"^",2)
	...;e  s opName=$G(opName)_","_$P(^ORC("OPER",curOperId),"^",2)
	
	..i curOperId="" d
	...i opName="" s opName=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2)),"^",1)
	...e  s opName=$G(opName)_","_$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"REM",2)),"^",1)
	..e  d
	...if $D(^ORC("OPER",curOperId)) d
	....s opName1=$P(^ORC("OPER",curOperId),"^",2)
	....i opName="" s opName=opName1
	....e  s opName=$G(opName)_","_opName1
	
	..s operLocId1=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",10) 
	..if operLocId1'=""  Set operLocId=operLocId1 
	.s opStartDate=$P(^OR(opaAdmDr,"ANA",anaSub),"^",39)
	.s opsttime=$P(^OR(opaAdmDr,"ANA",anaSub),"^",40)
	.s opeSDate=##class(websys.Conversions).DateLogicalToHtml(opStartDate)
	.i opStartDate=""  d
	..s opStartDate=$P(^DHCANOPArrange(opaId),"^",14)
	..s opsttime=$P(^DHCANOPArrange(opaId),"^",15) ;手术开始日期
	..s opeSDate=##class(websys.Conversions).DateLogicalToHtml(opStartDate)
	.i opStartDate'="" s opStartDate=$ZD(opStartDate,3)
	.i opsttime'=""  s opsttime=$ZT(opsttime,2)
	.s openddate=$P(^OR(opaAdmDr,"ANA",anaSub),"^",41)
	.s opendtime=$P(^OR(opaAdmDr,"ANA",anaSub),"^",42)
	.s opeEDate=##class(websys.Conversions).DateLogicalToHtml(openddate)
	.i openddate=""  d
	..s openddate=$P(^DHCANOPArrange(opaId),"^",16),opendtime=$P(^DHCANOPArrange(opaId),"^",17)
	..s opeEDate=##class(websys.Conversions).DateLogicalToHtml(openddate)
	.i openddate'="" s openddate=$zd(openddate,3)	
	.i opendtime'="" s opendtime=$zt(opendtime,2)
	.s StartDateStr=opStartDate_" "_opsttime
	.s EndDateStr=openddate_" "_opendtime
	.s opeSTime=opsttime,opeETime=opendtime
	.s operLocDesc=""
	.i operLocId'="" d
	..s operLocDesc=$p(^CTLOC(operLocId),"^",2)  //手术科室
   	.do OutwardRow2
	Quit $$$OK
OutwardRow2
	set Data=$lb(opaId,opName,StartDateStr,EndDateStr,operLocDesc,opeSDate,opeSTime,opeEDate,opeETime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetOperationsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOperationsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetOperations(EpisodeID As %String) As %Query(ROWSPEC = "OpaId,OpName,StartDateStr,EndDateStr,OperLocDesc,opeSDate,opeSTime,opeEDate,opeETime")
{
}

ClassMethod GetAntReasonData(EpisodeID As %String, ArcimRowid As %String, UserReasonId As %String)
{
	Quit:EpisodeID="" ""
	Quit:ArcimRowid="" ""
	
	Set ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)    //药品名称
	Set SeqNo=$o(^DAUP("DAUP",""),-1)+1
	Quit:UserReasonId="" ArcimDesc_"^"_SeqNo_"!"
	//使用目的
	Set UsePurposeId=$p(^DAUP("DAUP",UserReasonId),"^",20)
	Set UsePurposeDesc="" 
	if UsePurposeId'="" do
	.Set UsePurposeDesc=$p(^DTAUP("AUP",UsePurposeId),"^",2)
	//原因分析
	Set Reason=$p(^DAUP("DAUP",UserReasonId),"^",12)
	//指征
	Set DAUPOPerInd=$p(^DAUP("DAUP",UserReasonId),"^",10)
	Set DAUPOPerDesc=""
	if DAUPOPerInd'="" do
	.Set DAUPOPerDesc=$p(^DAIND("DAIND",DAUPOPerInd),"^",2)
	//经验送检
	Set Submission=$p(^DAUP("DAUP",UserReasonId),"^",15)
	//感染的器官或系统
	Set BodyPart=$p(^DAUP("DAUP",UserReasonId),"^",6)
	//药敏结果
	Set Suscept=$p(^DAUP("DAUP",UserReasonId),"^",11)
	//手术
	Set Operation=$p(^DAUP("DAUP",UserReasonId),"^",9)
	//其它理由
	Set OtherReason=$p(^DAUP("DAUP",UserReasonId),"^",13)
	//序号
	Set SeqNo=$p(^DAUP("DAUP",UserReasonId),"^",8)
	//专家会诊意见
	Set Conscommt=$p(^DAUP("DAUP",UserReasonId),"^",7)
	Set AntReasonData=ArcimDesc_"^"_SeqNo_"!"_UsePurposeId_"^"_Reason_"^"_DAUPOPerInd_"^"_Submission
	Set AntReasonData=AntReasonData_"^"_BodyPart_"^"_Suscept_"^"_Operation_"^"_OtherReason_"^"_Conscommt
	Quit AntReasonData
}

ClassMethod Insert(Para As %String) As %String
{
	//w ##class(web.DHCDocAntibioticReason).Insert("^7^32424^2^N^4^2^54^111^1111111^2890^808||1^755")
	s ^gry("InsertAnt")=Para
	//Para=UserReasonId+"^"+UserReasonValue+"^"+CauseAna+"^"+AntIndications+"^"+Submission+"^"+AntBodyPart+"^"+AntSuscept
	//Para=Para+"^"+AntOperation+"^"+AntOtherReason+"^"+AntConscommt
	Set UserReasonId=$p(Para,"^",1)
	Set UserReasonValue=$p(Para,"^",2)  //使用目的id
	Set CauseAna=$p(Para,"^",3)    //原因分析
	Set AntIndications=$p(Para,"^",4)   //指征
	Set Submission=$p(Para,"^",5)      //经验用药送检
	Set AntBodyPart=$p(Para,"^",6)    //身体部位
	Set AntSuscept=$p(Para,"^",7)     //过敏记录
	Set AntOperation=$p(Para,"^",8)   //手术记录
	Set AntOtherReason=$p(Para,"^",9)    //其它理由
	Set AntConscommt=$p(Para,"^",10)     //专家会诊意见
	
	Set UserId=$p(Para,"^",11)
	Set ArcimRowid=$p(Para,"^",12)
	Set EpisodeID=$p(Para,"^",13)
	Set PatientId=$p(^PAADM(EpisodeID),"^",1)
	Set DAUPNo=""  ;$p(Para,"^",14)
	set SSYFTimeDR=$p(Para,"^",14)
	if UserReasonId=""{
		s Obj=##class(User.DHCAntUsePurpose).%New()
		if $ISObject(Obj) {
			TS
			do Obj.DAUPDTAUPDRSetObjectId(UserReasonValue)   //使用目的
			Set Obj.DAUPReason=CauseAna                      //原因分析
			if AntIndications'="" do Obj.DAUPOPerIndSetObjectId(AntIndications)  //指征
			Set Obj.DAUPSubmission=Submission    //送检
			if AntBodyPart'=""  do Obj.DAUPBodyPartSetObjectId(AntBodyPart)   //身体部位
			Set Obj.DAUPSusceptDR=AntSuscept    //过敏记录
			Set Obj.DAUPOperationDR=AntOperation  //手术记录
			Set Obj.DAUPOtherReason=AntOtherReason    //其它理由
			Set Obj.DAUPConscommt=AntConscommt        //专家会诊
		
			Set Obj.DAUPDate=+$H
			Set Obj.DAUPTime=$p($h,",",2)
			do Obj.DAUPUserSetObjectId(UserId)
			do Obj.DAUPLastUpdateUserSetObjectId(UserId)
			Set Obj.DAUPLastUpdateDate=+$H
			Set Obj.DAUPLastUpdateTime=$p($h,",",2)
			do Obj.DAUPAdmdrSetObjectId(EpisodeID)
			do Obj.DAUPPatDRSetObjectId(PatientId)
			do Obj.DAUPItmMastDRSetObjectId(ArcimRowid)
			Set Obj.DAUPNo=DAUPNo
			;set Obj.DAUPOperaYFTimeDR=SSYFTimeDR
			do Obj.DAUPOperaYFTimeDRSetObjectId(SSYFTimeDR)
			Set sc = Obj.%Save()
			b ;insert finsh
			If $$$ISERR(sc) {
				Trollback
				Quit 100_"^"
			}
			Set AARowid=Obj.%Id()
			TC
			s myrtn=0
		}
	}else{
		s Obj=##class(User.DHCAntUsePurpose).%OpenId(UserReasonId)
		if $ISObject(Obj) {
			TS
			do Obj.DAUPDTAUPDRSetObjectId(UserReasonValue)   //使用目的
			Set Obj.DAUPReason=CauseAna                      //原因分析
			if AntIndications'="" do Obj.DAUPOPerIndSetObjectId(AntIndications)  //指征
			Set Obj.DAUPSubmission=Submission    //送检
			if AntBodyPart'=""  do Obj.DAUPBodyPartSetObjectId(AntBodyPart)   //身体部位
			Set Obj.DAUPSusceptDR=AntSuscept    //过敏记录
			Set Obj.DAUPOperationDR=AntOperation  //手术记录
			Set Obj.DAUPOtherReason=AntOtherReason    //其它理由
			Set Obj.DAUPConscommt=AntConscommt        //专家会诊
			do Obj.DAUPLastUpdateUserSetObjectId(UserId)
			Set Obj.DAUPLastUpdateDate=+$H
			Set Obj.DAUPLastUpdateTime=$p($h,",",2)
			;set Obj.DAUPOperaYFTimeDR=SSYFTimeDR
			do Obj.DAUPOperaYFTimeDRSetObjectId(SSYFTimeDR)
			Set sc = Obj.%Save()
			b ;insert finsh
			If $$$ISERR(sc) {
				Trollback
				Quit 100_"^"
			}
			Set AARowid=Obj.%Id()
			TC
			s myrtn=0
		}
	}
    Q myrtn_"^"_AARowid
}

/// 得到是否需要会诊或者是否需要审核的标志
/// debug: w ##class(web.DHCDocAntibioticReason).GetWantFlag(646,"KSS3")
ClassMethod GetWantFlag(usercode As %String, poisoncode As %String) As %String
{
	q:$g(usercode)="" ""
	q:$g(poisoncode)="" ""
	s ret="",WantFlag=0
	s usercode=$zcvt(usercode,"U")
	S CTCPRowid=$o(^CTPCP(0,"Code",usercode,0))
	q:CTCPRowid="" ""
	S AppFlag=0,Consultation=0
	s CTCPTDr=$p(^CTPCP(CTCPRowid,1),"^",4)
	s CTCPTDesc=$P(^CT("CPT",CTCPTDr),"^",2)
	s ret=AppFlag_"^"_Consultation_"^"_CTCPTDesc
	s Child=0
	for {
		 s Child=$O(^CT("CPT",CTCPTDr,"PHPO",Child)) 
		 Q:Child=""  
		 s PoisonRowId=$P(^CT("CPT",CTCPTDr,"PHPO",Child),"^",1)
		 s PoisonCode=$p(^PHCPO(PoisonRowId),"^",1)
		 q:PoisonCode'=poisoncode
		 if PoisonCode="KSS3" S Consultation=1,AppFlag=1     ;需要会诊的必须需要申请
		 s ControlType=$P(^CT("CPT",CTCPTDr,"PHPO",Child),"^",2)
		 if ControlType="P"  S AppFlag=1
		 s ret=AppFlag_"^"_Consultation_"^"_CTCPTDesc
		}
	q ret
}

/// 得到医嘱信息
/// debug: w ##class(web.DHCDocAntibioticReason).GetArcimDetailByArcim("614||1")
ClassMethod GetArcimDetailByArcim(arcim As %String) As %String
{
	q:arcim="" ""
	s arcimDesc=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)
	s arcic=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
	s ArcicDesc=$p(^ARC("IC",arcic),"^",2)
	s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(arcim)
	s PoisonDesc=""
	i PoisonRowid'="" s PoisonDesc=$P(^PHCPO(PoisonRowid),"^",2)
	s phcdf=$p(^ARCIM(+arcim,1,1),"^",12)
	s phDDD=$p(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),"DHC"),"^",5)
	
	s ret=arcimDesc_"^"_ArcicDesc_"^"_PoisonDesc_"^"_phDDD    //20131218  shp
	q ret
}

/// Creator：     shp
/// CreatDate：   2012-11-08
/// Description:  感染部位
/// Table：       DHCDocInfPos
/// Input：       
/// D ##class(%ResultSet).RunQuery("web.DHCDocAntibioticReason","QryInfPosition","1")
Query QryInfPosition(aIsActive As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod QryInfPositionExecute(ByRef qHandle As %Binary, aIsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set ID=""
 	For {
		 	Set ID=$o(^User.DHCDocInfPartD(ID))
		 	Quit:ID=""
		 	
		 	Set Position=$g(^User.DHCDocInfPartD(ID))
		 	Set IPCode=$li(Position,2)
		 	Set IPDesc=$li(Position,3)
		 	Set IPActive=$li(Position,4)
		 	Continue:(aIsActive'="")&&(IPActive'=aIsActive)
		 	
		 	Set Data=$lb(ID,IPDesc,IPCode)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryInfPositionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPositionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPositionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPositionExecute ]
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

/// 抗菌药物登记表所有信息
/// debug: w ##class(web.DHCDocAntibioticReason).InserAllInfo(^tempshp("para"))
ClassMethod InserAllInfo(Para As %String) As %String
{
	S ^tempshp("para")=Para
	s AARowid=""
	;s ReasonInfo=$p(Para,"&",1)
	s AuditInfo=$p(Para,"&",1)
	s Consultation=$p(Para,"&",2)
	TS
	if AuditInfo'="" {
		S ret=##class(web.DHCDocAntibioticApply).Insert(AuditInfo)
		s rtn1=$p(ret,"^",1)
		s AARowid=$p(ret,"^",2)
		s ^tempshp("aarowid")=AARowid
		if (rtn1) {
			TRO
			Q "-201"
		}
		s retpt=##class(web.DHCAntKSSSend).SendApplyInfo(AARowid)
		if (Consultation'=""){
			S ConsultationDep=$P(Consultation,"^",18),ConsultationDoc=$P(Consultation,"^",19)
			&sql(Update SQLUser.DHC_Doc_AntibioticApply set AA_ConsultationDep_DR=:ConsultationDep,AA_ConsultationDoc_DR=:ConsultationDoc where AA_Rowid=:AARowid)
			B   ;09
			i ('SQLCODE)  {
				s ret2=##class(web.DHCDocAntibioticApply).CreateConsultationApply(AARowid)
				s rtn2=$p(ret2,"^",1)
				s ConsultID=$p(ret2,"^",2)
				b  ;000123
				if ConsultID="" { 
					TRO
					q "-202"
				}
				&SQL(update SQLUser.DHC_Doc_AntibioticApply set AA_DHCConsult_DR =:ConsultID where AA_Rowid=:AARowid)
				if (SQLCODE) {
					TRO
				 	Q "-203"
					}
				}
			}
	}
	TC
	Q 0_"^"_AARowid
}

/// 得到审核后24小时内的医嘱
/// debug:  w ##class(web.DHCDocAntibioticReason).GetAuditApplyInfo("25","")
ClassMethod GetAuditApplyInfo(episodeid As %String, userid As %String) As %String
{
	Q:$G(episodeid)="" ""
	S ret=""
	S AARowid=0,seqno=0
	for  s AARowid=$o(^DHCDAAi("AdmDR",episodeid,AARowid))  q:AARowid=""  d
	.s arcim=$p(^DHCDAA("ANT",AARowid),"^",2)
	.s ArcImName=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)  //医嘱名称
	.s ConsultDR=$p(^DHCDAA("ANT",AARowid,1),"^",22)
	.s AppDate=$p(^DHCDAA("ANT",AARowid),"^",10)
	.;q:AppDate'=+$h
	.s AppUserDr=$p(^DHCDAA("ANT",AARowid),"^",9)
	.q:AppUserDr'=userid
	.s AppTime=$p(^DHCDAA("ANT",AARowid),"^",11)
	.s OeorderID=$p(^DHCDAA("ANT",AARowid,1),"^",6)
	.q:OeorderID'=""
	.S curdate=+$H,curtime=$P($h,",",2)
	.s curTime=..GetAbsTime($h)
	.s applyTime=..GetAbsTime(AppDate_","_AppTime)
	.q:(curTime>(applyTime+86400))             
	.if ConsultDR'=""  d
	..Set ConResult=##class(web.DHCConsult).checktsyhzrowid(arcim,episodeid,curdate,curtime)
	..Q:ConResult'=1         ;未同意的会诊 退出
	.s AppStatus=$p(^DHCDAA("ANT",AARowid),"^",12)
	.b  ;01
	.q:AppStatus'="U"
	.s seqno=seqno+1
	.if ret="" d
	..s ret=ArcImName_"^"_arcim_"^"_seqno
	.e  d  
	..s ret=ret_"&"_ArcImName_"^"_arcim_"^"_seqno
	q ret
}

ClassMethod GetAbsTime(dt As %String) As %String
{
 //将日期时间转换成秒
  //n (dt)
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

/// 描述：通过 EpisodeID ,ARCIMStr 找到24小时内审核医嘱的信息。
/// ItemData 代码可参考 web.DHCDocOrderCommon  : FindOSItems 方法
/// debug; w ##class(web.DHCDocAntibioticReason).GetAddToListArcimInfo("","",25,"614||1")
ClassMethod GetAddToListArcimInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", EpisodeID As %String, AARowidStr As %String) As %String
{
	q:$g(EpisodeID)="" ""
	q:$g(AARowidStr)="" ""
	s jsval=""
	s len=$length(AARowidStr,"^")
	s ^tempshp("1")=AARowidStr_"^"_EpisodeID
	for i=1:1:len {
		s AARowid=$p(AARowidStr,"^",i)
		continue:AARowid=""
		s arcim=$p(^DHCDAA("ANT",AARowid),"^",2)
		s AppDate=$p(^DHCDAA("ANT",AARowid),"^",10)
		s AppTime=$p(^DHCDAA("ANT",AARowid),"^",11)
		s ConsultDR=$p(^DHCDAA("ANT",AARowid,1),"^",22)
		S curdate=+$H,curtime=$P($h,",",2)
		s curTime=..GetAbsTime($h)
		s applyTime=..GetAbsTime(AppDate_","_AppTime)
		;q:curTime>(applyTime+86400)             
		if ConsultDR'=""  d
		.Set ConResult=##class(web.DHCConsult).checktsyhzrowid(arcim,EpisodeID,curdate,curTime)
		.Q:ConResult'=1         ;未同意的会诊 退出
		S InstrucDR=$p(^DHCDAA("ANT",AARowid),"^",8)
		s Instruc="",FormDurDesc="",FormDurRowid="",FormDurFactor=""
		if InstrucDR'="" S Instruc=$p(^PHCIN(InstrucDR),"^",2)    //用法
		s UseReasonID=$p(^DHCDAA("ANT",AARowid,1),"^",20)         //使用目的ID
		s oeori=$p(^DHCDAA("ANT",AARowid,1),"^",6) 
		;抗菌药物申请列表中开过一次的申请，在录入的时候是复制列表中的使用目的   
		if oeori'=""  d 
		.s ret=##class(web.DHCDocAntiCommon).CopyAntUsePurpose(oeori)                                /////
		.s rtn=$p(ret,"^",1)
		.if rtn=0  d
		..s UseReasonID=$p(ret,"^",2)
		..s AARowid=""
		s FormDoseQty="",FormDoseUOMRowid="",FormDoseUOMDesc=""
		s FormFreqRowid="",FormFreqDesc="",FormFreqFactor="",FormFreqInterval=""
		s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcim)
		i DrgformRowid'=""   d
		.s PHCDRowid=$P(DrgformRowid,"||",1)
	  	.s ChildSub=$P(DrgformRowid,"||",2)
		.s FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5) ;Pharmacy base UOM
	  	.s FormDoseUOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
	  	
	  	.;添加取等效单位及默认值
	  	.s eqSub=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",0))
	  	.i eqSub'="" d
	  	..s FormDoseUOMRowid=$p(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",eqSub),"^",1)
	  	..s FormDoseQty=$p(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",eqSub),"^",3)
	  	
	  	.s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
	  	.;添加默认疗程 20130106
	  	.s FormDurRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",8)
	  	.i FormDurRowid'=""  d
		..s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
		..s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
		.;频率
	  	.s FormFreqRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",4)
	    .i FormFreqRowid'=""  d
		..s FormFreqDesc=$P($g(^PHCFR(FormFreqRowid)),"^",3)
		..s FormFreqFactor=$P($g(^PHCFR(FormFreqRowid)),"^",2)
		..s FormFreqInterval=$P($g(^PHCFR(FormFreqRowid)),"^",5)
		s ItemData=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid
		s ItemData=ItemData_"^"_FormFreqDesc_$C(1)_FormFreqRowid_$C(1)_FormFreqFactor_$C(1)_FormFreqInterval
		s ItemData=ItemData_"^"_Instruc_$C(1)_InstrucDR
		s ItemData=ItemData_"^"_FormDurDesc_$C(1)_FormDurRowid_$C(1)_FormDurFactor
		s ItemData=ItemData_"^"_""_$C(1)_""_$C(1)_""
		s ItemData=ItemData_"^"_""_$C(1)_""_$C(1)_""
		s ItemData=ItemData_"^^^^^"
		s ItemData=ItemData_"^"_AARowid_$C(1)_UseReasonID
		s OrderType="",OrderSeqNo="",ID=""
		s SubCatRowId=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
		if SubCatRowId'="" s OrderType=$p(^ARC("IC",SubCatRowId),"^",7)
		s jsval=jsval_"Copyary[Copyary.length]="""_arcim_"!"_OrderSeqNo_"!"_ItemData_"!"_OrderType_"!!!!"_"KSS"_""";"
		 
	}
	if (itmjs'="")&&(jsval'="") {
		s jsval="var Copyary=new Array();"_jsval_itmjs_"(Copyary);"
		&javascript<#(jsval)#>
	}
	q 0
}

/// 描述：通过 EpisodeID ,ARCIMStr 找到24小时内审核医嘱的信息。
/// ItemData 代码可参考 web.DHCDocOrderCommon  : FindOSItems 方法
/// debug; w ##class(web.DHCDocAntibioticReason).GetAddToListArcimInfoNew("","",25,"614||1")
ClassMethod GetAddToListArcimInfoNew(itmjs As %Library.String = "", itmjsex As %Library.String = "", EpisodeID As %String, AARowidStr As %String) As %String
{
	q:$g(EpisodeID)="" ""
	q:$g(AARowidStr)="" ""
	s jsval=""
	s len=$length(AARowidStr,"^")
	s ^tempshp("1")=AARowidStr_"^"_EpisodeID
	for i=1:1:len {
		s AARowid=$p(AARowidStr,"^",i)
		continue:AARowid=""
		s arcim=$p(^DHCDAA("ANT",AARowid),"^",2)
		s AppDate=$p(^DHCDAA("ANT",AARowid),"^",10)
		s AppTime=$p(^DHCDAA("ANT",AARowid),"^",11)
		s ConsultDR=$p(^DHCDAA("ANT",AARowid,1),"^",22)
		S curdate=+$H,curtime=$P($h,",",2)
		s curTime=..GetAbsTime($h)
		s applyTime=..GetAbsTime(AppDate_","_AppTime)
		;q:curTime>(applyTime+86400)             
		if ConsultDR'=""  d
		.Set ConResult=##class(web.DHCConsult).checktsyhzrowid(arcim,EpisodeID,curdate,curTime)
		.Q:ConResult'=1         ;未同意的会诊 退出
		S InstrucDR=$p(^DHCDAA("ANT",AARowid),"^",8)
		s Instruc="",FormDurDesc="",FormDurRowid="",FormDurFactor=""
		if InstrucDR'="" S Instruc=$p(^PHCIN(InstrucDR),"^",2)    //用法
		s UseReasonID=$p(^DHCDAA("ANT",AARowid,1),"^",20)         //使用目的ID
		s oeori=$p(^DHCDAA("ANT",AARowid,1),"^",6) 
		;抗菌药物申请列表中开过一次的申请，在录入的时候是复制列表中的使用目的   
		if oeori'=""  d 
		.s ret=##class(web.DHCDocAntiCommon).CopyAntUsePurpose(oeori)                                /////
		.s rtn=$p(ret,"^",1)
		.if rtn=0  d
		..s UseReasonID=$p(ret,"^",2)
		..s AARowid=""
		s FormDoseQty="",FormDoseUOMRowid="",FormDoseUOMDesc=""
		s FormFreqRowid="",FormFreqDesc="",FormFreqFactor="",FormFreqInterval=""
		s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcim)
		i DrgformRowid'=""   d
		.s PHCDRowid=$P(DrgformRowid,"||",1)
	  	.s ChildSub=$P(DrgformRowid,"||",2)
		.s FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5) ;Pharmacy base UOM
	  	.s FormDoseUOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
	  	
	  	.;添加取等效单位及默认值
	  	.s eqSub=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",0))
	  	.i eqSub'="" d
	  	..s FormDoseUOMRowid=$p(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",eqSub),"^",1)
	  	..s FormDoseQty=$p(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",eqSub),"^",3)
	  	
	  	.s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
	  	.;添加默认疗程 20130106
	  	.s FormDurRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",8)
	  	.i FormDurRowid'=""  d
		..s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
		..s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
		.;频率
	  	.s FormFreqRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",4)
	    .i FormFreqRowid'=""  d
		..s FormFreqDesc=$P($g(^PHCFR(FormFreqRowid)),"^",3)
		..s FormFreqFactor=$P($g(^PHCFR(FormFreqRowid)),"^",2)
		..s FormFreqInterval=$P($g(^PHCFR(FormFreqRowid)),"^",5)
		s ItemData=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid
		s ItemData=ItemData_"^"_FormFreqDesc_$C(1)_FormFreqRowid_$C(1)_FormFreqFactor_$C(1)_FormFreqInterval
		s ItemData=ItemData_"^"_Instruc_$C(1)_InstrucDR
		s ItemData=ItemData_"^"_FormDurDesc_$C(1)_FormDurRowid_$C(1)_FormDurFactor
		s ItemData=ItemData_"^"_""_$C(1)_""_$C(1)_""
		s ItemData=ItemData_"^"_""_$C(1)_""_$C(1)_""
		s ItemData=ItemData_"^^^^^"
		s ItemData=ItemData_"^"_AARowid_$C(1)_UseReasonID
		s OrderType="",OrderSeqNo="",ID=""
		s SubCatRowId=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)
		if SubCatRowId'="" s OrderType=$p(^ARC("IC",SubCatRowId),"^",7)
		;s jsval=jsval_"Copyary[Copyary.length]="""_arcim_"!"_OrderSeqNo_"!"_ItemData_"!"_OrderType_"!!!!"_"KSS"_""";"
		i jsval="" s jsval=arcim_"!"_OrderSeqNo_"!"_ItemData_"!"_OrderType_"!!!!"_"KSS"
		e  s jsval=jsval_","_arcim_"!"_OrderSeqNo_"!"_ItemData_"!"_OrderType_"!!!!"_"KSS" 
	}
	/*
	if (itmjs'="")&&(jsval'="") {
		s jsval="var Copyary=new Array();"_jsval_itmjs_"(Copyary);"
		&javascript<#(jsval)#>
	}*/
	q jsval
}

/// create : shp
/// date   : 2012.11.30
/// debug  : D ##class(%ResultSet).RunQuery("web.DHCDocAntibioticReason","QryAntiAuditInfo","758","")
Query QryAntiAuditInfo(episodeid As %String, userid As %String) As %Query(ROWSPEC = "SeqNo:%String,ArcimName:%String,Status:%String,Rowid:%String,AppStatus:%String,AuditDoc:%String,AudTime:%String,AppUser:%String,AppTi:%String,CheckBoxOk:%String,ConsultDate:%String,ConsultDoc:%String,AppDate1,AppTime1,AuditDate1,AuditTime")
{
}

ClassMethod QryAntiAuditInfoExecute(ByRef qHandle As %Binary, episodeid As %String, userid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Q:$G(episodeid)="" ""
 	
	S ret=""
	S AARowid="",seqno=0
	for  s AARowid=$o(^DHCDAAi("AdmDR",episodeid,AARowid),-1)  q:AARowid=""  d
	.s arcim=$p(^DHCDAA("ANT",AARowid),"^",2)
	.s ArcImName=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",2)  //医嘱名称
	.s ConsultDR=$p(^DHCDAA("ANT",AARowid,1),"^",22)
	.s AppDate=$p(^DHCDAA("ANT",AARowid),"^",10)
	.s AppTime=$p(^DHCDAA("ANT",AARowid),"^",11)
	.s OeorderID=$p(^DHCDAA("ANT",AARowid,1),"^",6)
	.;s AppDate1=$zd(AppDate,3)
	.s AppDate1=##class(websys.Conversions).DateLogicalToHtml(AppDate)
	.s AppTime1=$zt(AppTime,2)
	.s AppTi=AppDate1_" "_AppTime1
	.;q:OeorderID'=""
	.s AppUserDr=$p(^DHCDAA("ANT",AARowid),"^",9)
	.q:AppUserDr'=userid
	.s AppUser=$p(^SSU("SSUSR",AppUserDr),"^",2)
	.S curdate=+$H,curtime=$P($h,",",2)
	.s curTime=..GetAbsTime($h)
	.s applyTime=..GetAbsTime(AppDate_","_AppTime)
	.;q:(curTime>(applyTime+86400))             
	.if ConsultDR'=""  d
	..Set ConResult=##class(web.DHCConsult).checktsyhzrowid(arcim,episodeid,curdate,curtime)
	..Q:ConResult'=1         ;未同意的会诊 退出
	.s AppStatus=$p(^DHCDAA("ANT",AARowid),"^",12)
	.if AppStatus="U"  s Status="已审核"
	.if AppStatus="A"  s Status="未审核"
	.if AppStatus="R"  s Status="拒绝"  //add by qp 2014-04-24
	.s AuditUserDr=$p(^DHCDAA("ANT",AARowid,1),"^",10)     //审核人
	.S AuditDoc=""
	.if AuditUserDr'="" s AuditDoc=$p(^SSU("SSUSR",AuditUserDr),"^",2)
	.s AuditDate=$p(^DHCDAA("ANT",AARowid,1),"^",11)       //审核日期
	.s AuditTime=$p(^DHCDAA("ANT",AARowid,1),"^",12)       //时间
	.;48h内科复制医嘱，现将时间限制设一临时global "^AntTimeLimit("Time")" 以小时为单位
	.s AudTime="",CheckBoxOk=0,AuditDate1="" ;,AuditTime=""
	.s TimeLimit=$g(^AntTimeLimit("Time"))
	.IF TimeLimit'="" s TimeLimitS=TimeLimit*3600
	.if AuditDate'=""  d
	..s AudTime2=..GetAbsTime(AuditDate_","_AuditTime) 
	..if (curTime<(AudTime2+TimeLimitS)) s CheckBoxOk=1  
	..e  d  s CheckBoxOk=0
	..;s AuditDate1=$zd(AuditDate,3)
	..s AuditDate1=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
	..s AuditTime=$zt(AuditTime,2)
	..s AudTime=AuditDate1_" "_AuditTime
	
	.s ConsultDoc="",ConsultDate="",ConsultDate1="",ConsultDate2=""
 
	.if ConsultDR'=""  d
	..;需实际的会诊医生及科室
	..s ConsultDocDr=$list(^User.DHCConsultationD(ConsultDR),12)
	..i ConsultDocDr'="" s ConsultDoc=$P(^CTPCP(ConsultDocDr,1),"^",2) //会诊医生
	..;Set ConResult=##class(web.DHCConsult).checktsyhzrowid(arcim,episodeid,curdate,curtime)
	..;Q:ConResult'=1         ;未同意的会诊 退出
	..s ConsultDate1=$list(^User.DHCConsultationD(ConsultDR),10)
	..i ConsultDate1'="" s ConsultDate1 = ##class(websys.Conversions).DateLogicalToHtml(ConsultDate1)	//$zd(ConsultDate1,3)
	..s ConsultDate2=$list(^User.DHCConsultationD(ConsultDR),13)
	..i ConsultDate2'="" s ConsultDate2 = $zt(ConsultDate2,2)
	..s ConsultDate = ConsultDate1_" "_ConsultDate2
	..;b ;b
	
	
	.s seqno=seqno+1
 	.d output
	Quit $$$OK
output
	Set Data=$lb(seqno,ArcImName,Status,AARowid,AppStatus,AuditDoc,AudTime,AppUser,AppTi,CheckBoxOk,ConsultDate,ConsultDoc,AppDate1,AppTime1,AuditDate1,AuditTime)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryAntiAuditInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiAuditInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntiAuditInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiAuditInfoExecute ]
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

/// Creator：     shp
/// CreatDate：   2013-2-1
/// Description:  手术预防用药时间
/// Table：       User.DHCAntOperaTime
/// Input：       
/// D ##class(%ResultSet).RunQuery("web.DHCDocAntibioticReason","QrySSYFTime")
Query QrySSYFTime(aIsActive As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod QrySSYFTimeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set ID=""
 	For {
		 	Set ID=$o(^User.DHCAntOperaTimeD(ID))
		 	Quit:ID=""
		 	
		 	Set Position=$g(^User.DHCAntOperaTimeD(ID))
		 	Set Code=$li(Position,2)
		 	Set Desc=$li(Position,3)
		 	Set Active=$li(Position,4)
		 	Continue:Active'="Y"
		 	Set Data=$lb(ID,Desc,Code)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QrySSYFTimeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySSYFTimeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySSYFTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySSYFTimeExecute ]
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
