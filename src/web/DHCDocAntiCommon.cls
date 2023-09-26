Class web.DHCDocAntiCommon Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：     shp
/// CreatDate：   2012-11-29
/// Description:  抗菌药物使用情况。
/// Table：       DHCDocInfPos
/// Input：       
/// D ##class(%ResultSet).RunQuery("web.DHCDocAntiCommon","QryAntiUseInfo","62780","92790","")
Query QryAntiUseInfo(stdate As %String, enddate As %String, loc As %String) As %Query(ROWSPEC = "PatNo:%String,patName:%String,OrderLoc:%String,ArcimDesc:%String,FormInstrDesc:%String,FormFreqDesc:%String,FormDurDesc:%String,OrdDoctor:%String,OrdTime:%String,AuditDoctor:%String,auditTime:%String,ConsultDep:%String,ConsultDoctor:%String")
{
}

ClassMethod QryAntiUseInfoExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, loc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s PatNo="",patName="",AuditDoctor="",auditTime="",ConsultDep="",ConsultDoctor="",FormInstrDesc="",FormDurDesc="",FormFreqDesc=""
	s date=""
	for date=stdate:1:enddate d 
		.s ow=0
		.for  s ow=$o(^OEORDi(0,"ItemDate",date,ow)) q:ow=""  d
			..s adm=$p(^OEORD(ow),"^",1)
			..s papmi=$p(^PAADM(adm),"^",1)
			..s patName=$p(^PAPER(papmi,"ALL"),"^",1)
			..s PatNo=""
			..s PatNo=$P(^PAPER(papmi,"PAT",1),"^",1)                //住院
			..i PatNo=""  s PatNo=$P(^PAPER(papmi,"PAT",1),"^",2)    //门诊
			..s chl=0
			..for  s chl=$o(^OEORDi(0,"ItemDate",date,ow,chl))  q:chl=""  d
				...s ArcimRowid=$p(^OEORD(ow,"I",chl,1),"^",2)
				...s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ArcimRowid)
				...q:PoisonRowid=""
	  			...s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
	  			...q:(PoisonCode'="KSS1")&&(PoisonCode'="KSS2")&&(PoisonCode'="KSS3")
				...s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
				...s OrderDocDr=$p(^OEORD(ow,"I",chl,1),"^",11)
				...s OrdDoctor=$p(^CTPCP(OrderDocDr,1),"^",2)            //医嘱医生
				...s OrderDep=$p(^OEORD(ow,"I",chl,1),"^",3)
				...s OrderLoc=$p(^CTLOC(OrderDep),"^",2)           //科室
				...s PHFreqDR=$p(^OEORD(ow,"I",chl,2),"^",4)
				...i PHFreqDR'=""  s FormFreqDesc=$P($g(^PHCFR(PHFreqDR)),"^",3)   //频次
				...s DuratDR=$p(^OEORD(ow,"I",chl,2),"^",6)
				...i DuratDR'="" s FormDurDesc=$P($g(^PHCDU(DuratDR)),"^",3)   //疗程
				...s InstrDR=$p(^OEORD(ow,"I",chl,2),"^",7)
				...i InstrDR'="" s FormInstrDesc=$P($g(^PHCIN(InstrDR)),"^",2) //用法
				...s OrderDate=$p(^OEORD(ow,"I",chl,3),"^",7)     
				...s OrderTime=$p(^OEORD(ow,"I",chl,3),"^",15)
				...s OrderDate=$zd(OrderDate,3)
				...s OrderTime=$zt(OrderTime,2)
				...s OrdTime=OrderDate_"#"_OrderTime                //开医嘱时间
				...s oeori=ow_"||"_chl
				...s AARowid=$o(^DHCDAAi("OEORI",oeori,0))
				...if AARowid'=""  d
					....s AuditAdd=$p(^DHCDAA("ANT",AARowid,1),"^",7)  
					....s AuditDoctor=$p(^CTPCP(AuditAdd,1),"^",2)        //审核医生
					....s AuditDate=$p(^DHCDAA("ANT",AARowid,1),"^",8)
					....s AuditTime=$p(^DHCDAA("ANT",AARowid,1),"^",9)
					....s AuditDate=$zd(AuditDate,3)
					....s AuditTime=$zt(AuditTime,2)
					....s auditTime=AuditDate_"#"_AuditTime
					....S ConsultationDep=$p(^DHCDAA("ANT",AntibApplyRowid,1),"^",4)   //会诊科室
					....s ConsultDep=$p(^CTLOC(ConsultationDep),"^",2)
					....S ConsultationDoc=$p(^DHCDAA("ANT",AntibApplyRowid,1),"^",5)   //会诊医生
					....S ConsultDoctor=$p(^CTPCP(ConsultationDoc,1),"^",2)
					....;完成会诊时间
					....s ConsultID=$p(^DHCDAA("ANT",AntibApplyRowid,1),"^",22)   //指向DHC_Consultation
					....S ConsultDate=$list(^User.DHCConsultationD(ConsultID),10)
					....S ConsultTime=$list(^User.DHCConsultationD(ConsultID),13)
					....s ConTime=ConsultDate_"^"_ConsultTime
				...d output
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output
	Set Data=$lb(PatNo,patName,OrderLoc,ArcimDesc,FormInstrDesc,FormFreqDesc,FormDurDesc,OrdDoctor,OrdTime,AuditDoctor,auditTime,ConsultDep,ConsultDoctor)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryAntiUseInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntiUseInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAntiUseInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntiUseInfoExecute ]
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

/// 检查病人是否对【arcim】该药品耐药
/// return：'0'或"" 否，'1' 是
/// debug :  w ##class(web.DHCDocAntiCommon).CheckIsSuscept("25","614||1")
ClassMethod CheckIsSuscept(Episodeid As %String, Arcim As %String)
{
	Q:$g(Episodeid)="" ""
	s find=0
	Set SusceptStr=##class(web.DHCLabGerm).GetAllSenResbyEpisID(Episodeid)
	Set len=$l(SusceptStr,"!")
	for i=1:1:len do
	.s Suscept=$p(SusceptStr,"!",i)
	.s code=$p(Suscept,"^",12)
	.s SenDesc=$p(Suscept,"^",8)
	.q:SenDesc'["耐药"
	.s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(Arcim)
	.if DrgformRowid'="" d
	..s whonet=$p(^PHCD(+DrgformRowid,"DF",$P(DrgformRowid,"||",2),"DHC"),"^",10)
	..q:whonet'=code
	..s find=1
	q find
}

/// 在疗程内的抗菌药物不在弹出登记表 同时建立使用目的
/// debug : w ##class(web.DHCDocAntiCommon).CheckInDurSameIM("25","870||1")
ClassMethod CheckInDurSameIM(Episodeid As %String, Arcim As %String)
{
	Q:$g(Episodeid)="" 0_"^"
	s flag=0_"^"
	s AArowid=""
	f  s AArowid=$O(^DHCDAAi("AdmDR",Episodeid,AArowid))  Q:AArowid=""  D
	.s OrderDays=$p(^DHCDAA("ANT",AArowid,1),"^",21)    ;预计疗程
	.s IMRowid=$p(^DHCDAA("ANT",AArowid),"^",2)
	.q:IMRowid'=Arcim
	.s oeori=$p(^DHCDAA("ANT",AArowid,1),"^",6) 
	.b  ;
	.i oeori=""  s flag=1_"^"
	.if (oeori'="")  d
	..s OrderDate=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",7)    
	..s date=OrderDate+OrderDays
	..s curdate=+$h
	..;s OrderTime=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",15) 
	..if curdate<date  s flag=2
	..if flag=2  d 
	...s ret=..CopyAntUsePurpose(oeori)
	...s flag=2_"^"_$p(ret,"^",2)
	q flag
}

/// 描述 ： 复制医嘱时同时复制使用目的
/// debug:  w ##class(web.DHCDocAntiCommon).CopyAntUsePurpose("",258)
ClassMethod CopyAntUsePurpose(oeori As %String)
{
	quit:$g(oeori)="" 100_"^"
	quit:'$d(^DAUP("OEORI",$g(oeori))) 101_"^"
	s UseReasonID=$o(^DAUP("OEORI",oeori,""))
	quit:$g(UseReasonID)="" 102_"^"
	s Obj=##class(User.DHCAntUsePurpose).%OpenId(UseReasonID)
	if $ISObject(Obj){
		s date=Obj.DAUPDate+1
		s time=Obj.DAUPTime
		s H=date_","_time
		s OldH=..GetAbsTime(H)
		s CurH=..GetAbsTime($h)
		q:CurH>OldH 103_"^"
		TS
		s ObjNew=##class(User.DHCAntUsePurpose).%New()
		if $ISObject(ObjNew){
			S ObjNew.DAUPDTAUPDR=Obj.DAUPDTAUPDR
			S ObjNew.DAUPReason=Obj.DAUPReason
			S ObjNew.DAUPOPerInd=Obj.DAUPOPerInd
			s ObjNew.DAUPSubmission=Obj.DAUPSubmission
			s ObjNew.DAUPBodyPart=Obj.DAUPBodyPart
			s ObjNew.DAUPSusceptDR=Obj.DAUPSusceptDR
			s ObjNew.DAUPOperationDR=Obj.DAUPOperationDR
			s ObjNew.DAUPOtherReason=Obj.DAUPOtherReason
			s ObjNew.DAUPConscommt=Obj.DAUPConscommt
			s ObjNew.DAUPUser=Obj.DAUPUser
			s ObjNew.DAUPLastUpdateUser=Obj.DAUPLastUpdateUser
			s ObjNew.DAUPDate=+$h
			s ObjNew.DAUPTime=$p($h,",",2)
			s ObjNew.DAUPLastUpdateDate=+$h
			s ObjNew.DAUPLastUpdateTime=$p($h,",",2)
			s ObjNew.DAUPAdmdr=Obj.DAUPAdmdr
			s ObjNew.DAUPPatDR=Obj.DAUPPatDR
			S ObjNew.DAUPItmMastDR=Obj.DAUPItmMastDR
			S ObjNew.DAUPNo=Obj.DAUPNo
			set sc=ObjNew.%Save()
			b  ;insert finish
			if $$$ISERR(sc){
				Trollback
				quit 200_"^"
				}
			set AArowid=ObjNew.%Id()
			TC
			S rtn=0
		}
		do Obj.%Close()
	}
	quit rtn_"^"_AArowid
}

ClassMethod GetAbsTime(dt As %String) As %String
{
 //将日期时间转换成秒
  //n (dt)
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

ClassMethod GetConsultLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsultLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetConsultLocExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCDocAntiCommon","GetConsultLoc","")
	//s ^liyufeng("GetInstrExecute")=code
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s code=$$ALPHAUP^SSUTIL4(code)
 	Set rowid=""
	F  s rowid=$O(^User.DHCAntiConsultLocInfoD(rowid)) q:rowid=""  d
	.s CTLOCRowid=$list(^User.DHCAntiConsultLocInfoD(rowid),2)
	.s Active=$list(^User.DHCAntiConsultLocInfoD(rowid),6)
	.s IsConsultLoc=$list(^User.DHCAntiConsultLocInfoD(rowid),4)
	.s sepecialloc=$list(^User.DHCAntiConsultLocInfoD(rowid),5)
	.q:((Active'=1)||(IsConsultLoc'=1))
	.;q:$G(^tempshp("LocID",CTLOCRowid))=CTLOCRowid
	.;s ^tempshp("LocID",CTLOCRowid)=CTLOCRowid
	.Set CTLOCDesc=$P($G(^CTLOC(CTLOCRowid)),"^",2)
	.Quit:(code'="")&&($p($$ALPHAUP^SSUTIL4(CTLOCDesc),code)'="")
	.Set CTLOCDescQuickCode=$P(CTLOCDesc,"-",1)
	.Set CTLOCCode=CTLOCDesc     //$P(CTLOCDesc,"-",2)
   	.Do OutwardRow
   	;k ^tempshp("LocID")
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(CTLOCRowid,CTLOCCode,CTLOCDescQuickCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetConsultLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsultLocExecute ]
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

Query GetConsultLoc(code As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod GetConsultDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConsultDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetConsultDocExecute(ByRef qHandle As %Binary, LocId As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCDocAntiCommon","GetConsultDoc","")
	//s ^liyufeng("GetInstrExecute")=code
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if LocId="" Set qHandle=$lb(0,repid,0)  Quit $$$OK
	s ret=""
	s Rowid=0
	f  s Rowid=$O(^User.DHCAntiConsultDocInfoI("ConLocDR"," "_LocId,Rowid)) q:Rowid=""  d
    .s CTPCPDR=$list(^User.DHCAntiConsultDocInfoD(Rowid),3)
    .s Active=$list(^User.DHCAntiConsultDocInfoD(Rowid),4)
	.q:Active'=1
    .s Desc=$P(^CTPCP(CTPCPDR,1),"^",2)
   	.Do OutwardRow1
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow1
	set Data=$lb(CTPCPDR,Desc,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetConsultDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConsultDocExecute ]
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

Query GetConsultDoc(LocId As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

/// create: shp
/// 描述：  为提高设置会诊科室的自由度。会诊科室有后台维护，分为3种【会诊科室】、【非会诊科室】、【其他】
///         【会诊科室】  :可请求会诊以及会诊
/// 			【非会诊科室】:该类型科室不用请求会诊
/// 			【其他】      :该类型科室不可会诊但可请求会诊
/// output: “1”为会诊科室，“0”不是会诊科室。
/// debug:  w ##class(web.DHCDocAntiCommon).IsNeedConsult(9)
ClassMethod IsNeedConsult(Locid As %String)
{
	n (Locid)
	s rowid=0,IsNeed=1
	f  s rowid=$o(^User.DHCAntiConsultLocInfoI("ANTLoc"," "_Locid,rowid)) q:rowid=""  d
	.;s Active=$list(^User.DHCAntiConsultLocInfoD(rowid),4)
	.s IsSpecConLoc=$list(^User.DHCAntiConsultLocInfoD(rowid),5)    ;是否为发送会诊科室
	.i IsSpecConLoc=1  s IsNeed=0
	q IsNeed
}

/// DATE  :2012-12-27
/// OUTPUT: "1"可以     "0"不可以
ClassMethod ReasonCanBeDeleted(UserReasonID As %String)
{
	n (UserReasonID)
	s DelFlag=1
	s Episodeid=$p(^DAUP("DAUP",UserReasonID),"^",2)
	Q:Episodeid="" DelFlag
	S AArowid=""
	f  s AArowid=$o(^DHCDAAi("AdmDR",Episodeid,AArowid))  Q:AArowid=""  D
	.S reasonid=$p(^DHCDAA("ANT",AArowid,1),"^",20)
	.I reasonid=UserReasonID  S DelFlag=0
	Q DelFlag
}

/// date        :2013-1-4
/// Description :得到默认科室ID
/// w ##class(web.DHCDocAntiCommon).GetDefaultLoc(162)
ClassMethod GetDefaultLoc(Userid As %String)
{
	n Obj
	Quit:$g(Userid)="" ""
	s Obj=##class(User.SSUser).%OpenId(Userid)
	b
	i $IsObject(Obj) {
		Q:$IsObject(Obj.SSUSRDefaultDeptDR) Obj.SSUSRDefaultDeptDR.%Id()
	}
	Q ""
}

/// date       :  2013-1-24
/// Description:  得到医护类型。
/// w ##class(web.DHCDocAntiCommon).GetCareType(162)
ClassMethod GetCareType(Userid As %String)
{
	n (Userid)
	s find=0
	s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(Userid)
	s CareProvType=$zcvt(CareProvType,"U")
	i (CareProvType="DOCTOR") s find=1
	q find
}

/// date       :  2013-1-24
/// Description:  得到抗菌素申请单的状态
/// input      :  approwid
/// output     :  0: 未审核   1: 已审核    -1:不存在
ClassMethod GetAntibioSta(AARowid As %String)
{
	Quit:AARowid="" -1
	Set Status=$p(^DHCDAA("ANT",AARowid),"^",12)
	if Status="A" do
	.Set AuditFlag=0
	else  do
	.Set AuditFlag=1
	Quit AuditFlag
}

/// creator:  huxin
/// w ##class(web.DHCDocAntiCommon).ContrOPOrde(6,30,"863||1")
ClassMethod ContrOPOrde(EpisodeID, OperationNum, ArcimRowid)
{
	//s ^templsj("20160307")=EpisodeID_"!"_OperationNum_"!"_ArcimRowid
	s flag=0,CheckFlag=0
    s anaId=$P(^DHCANOPArrange(OperationNum),"^",2) ;手术麻醉Id
    s anaSub=$P(anaId,"||",2)
    s anaopSub=0
    f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d  
    .s curOperIdStr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",24)       ;部位代码
    .q:$g(curOperIdStr)=""
    .s curOperlen=$l(curOperIdStr,"|")
    .f i=1:1:curOperlen d
    ..s curOperId=$p(curOperIdStr,"|",i)
    ..q:$g(curOperId)=""
    ..;s CheckFlag=CheckFlag+curOperId
    ..q:'$d(^DHCANC("SPA",0,"BodySite",curOperId))
    ..s DHCANCRowid=0
    ..f  s DHCANCRowid=$O(^DHCANC("SPA",0,"BodySite",curOperId,DHCANCRowid)) q:DHCANCRowid=""  d
    ...s DHCANCRArcimid=$list(^DHCANC("SPA",DHCANCRowid),2)
    ...s Activation=$list(^DHCANC("SPA",DHCANCRowid),3)
    ...q:Activation="N"
    ...i DHCANCRArcimid=ArcimRowid s flag=1
    ;i CheckFlag=0 s flag=0
    q flag
	
	/*
	s DHCANCROpNum="",DHCANCRArcimid="",Activation=""
	s flag=0,DHCANCRArcimidlen=0,DHCANCRArcimidStr="",anaId="",anaSub=""
	s DHCANCRowid=0  f  s DHCANCRowid=$o(^DHCANC("SPA",DHCANCRowid)) q:DHCANCRowid=""  d
	.s DHCANCROpNum=$list(^DHCANC("SPA",DHCANCRowid),1)
	.s anaId=$P(^DHCANOPArrange(OperationNum),"^",2) ;手术麻醉Id
	.s anaSub=$P(anaId,"||",2)
	.s anaopSub=0
	.f  s anaopSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:(anaopSub="")  d  
	..s curOperId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",24)       ;部位代码
	..i DHCANCROpNum=+curOperId d
	...s DHCANCRArcimidStr=$list(^DHCANC("SPA",DHCANCRowid),2)
	...s Activation=$list(^DHCANC("SPA",DHCANCRowid),3)
	...q:Activation="N"
	...s DHCANCRArcimidlen=$l(DHCANCRArcimidStr,"~")
	...f i=1:1:DHCANCRArcimidlen d
	....b  ;1
	....s DHCANCRArcimid=$p(DHCANCRArcimidStr,"~",i)
	....i (DHCANCRArcimid=ArcimRowid)&&(flag=0) d
	.....s flag=1

	q flag
	*/
}

/// D ##class(%ResultSet).RunQuery("web.DHCDocAntiCommon","GetOrderFlag","10")
Query GetKSSOrderStopInfo(episodeid As %String) As %Query(ROWSPEC = "EpisodeID:%String,PAPMIName:%String,ARCICDesc:%String,ORSDate:%String")
{
}

ClassMethod GetKSSOrderStopInfoExecute(ByRef qHandle As %Binary, episodeid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	s EpisodeID=episodeid
	s ARCIMSubscript="",ARCIMVersion="",ORSDate="",OerStatus="",NameStr=""
	s AAAdmDR="",AAArcimDR="",PAADMPAPMIDR="",PAPMIName="",ArcNameStr="所用抗菌药",DateFlag=""
	s oeori="" f  s oeori=$o(^DAUP("ADM",EpisodeID,oeori)) q:oeori=""  d
	.s PurposeRowid="" f  s PurposeRowid=$o(^DAUP("ADM",EpisodeID,oeori,PurposeRowid)) q:PurposeRowid=""  d
	..s oeroid=$p(oeori,"||",1)
	..s childSub=$p(oeori,"||",2)
	..;***************
	..s ReasonDr=$p(^DAUP("DAUP",PurposeRowid),"^",20)
	..i ReasonDr'="" s Reason=$p(^DTAUP("AUP",ReasonDr),"^",2)
	..;Q:Reason'["预防-手术"
	..;***************
	..s OEORIPriorityDR=$p(^OEORD(oeroid,"I",childSub,1),"^",8)         ///医嘱类型id
	..s OEORIPriorityDesc=$p(^OECPR(OEORIPriorityDR),"^",1)
	..q:OEORIPriorityDesc'="S"                                         //长期医嘱
	..s OerStatusId=$p(^OEORD(oeroid,"I",childSub,1),"^",13)            ///医嘱状态id
	..s OerStatusDesc=$p(^OEC("OSTAT",OerStatusId),"^",2)
	..q:(OerStatusDesc'="核实")&&(OerStatusDesc'="执行")
	..s AAAdmDR=$p(^DAUP("DAUP",PurposeRowid),"^",2)
	..s AAArcimDR=$p(^OEORD(oeroid,"I",childSub,1),"^",2)
	..s ARCIMSubscript=$p(AAArcimDR,"||",1)
	..s ARCIMVersion=$p(AAArcimDR,"||",2)
	..s ORSDate1=$p(^OEORD(oeroid,"I",childSub,3),"^",7)   ///下医嘱日期
	..s ORSDateT=ORSDate1*24        
	..s NowDate=+$h*24
	..s DateFlag=NowDate-ORSDateT                              
	..i DateFlag>72 d                                                        ///根据医院要求相应修改小时数                                                   
	...s ORSDate=$zd(ORSDate1,3)                                                
	...s ARCICDesc=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)
	...s PAADMPAPMIDR=$p(^PAADM(AAAdmDR),"^",1)
	...s PAPMIName=$p(^PAPER(PAADMPAPMIDR,"ALL"),"^",1)
 	...d Output101
	Quit $$$OK
Output101
	Set Data=$lb(EpisodeID,PAPMIName,ARCICDesc,ORSDate)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod GetKSSOrderStopInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKSSOrderStopInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetKSSOrderStopInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKSSOrderStopInfoExecute ]
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
