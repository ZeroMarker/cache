Class DHCDoc.DHCDocCure.Triage Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query QueryTriageResource(DCARowIDStr As %String, LocRowID As %String, LogLocID As %String = "", SessionStr As %String = "") As %Query(ROWSPEC = "DDCTRROWID:%String,DDCTRServiceGroupID:%String,DDCTRServiceGroup:%String,DDCTRCTLocID:%String,DDCTRCTLoc:%String,DDCTRResDr:%String,DDCTRResDesc:%String,CureTriageNum:%String,DDCTRCount:%String,DDCTRLeftCount:%String,DDCTRHistoryRes:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Triage","QueryTriageResource","9","",174)
ClassMethod QueryTriageResourceExecute(ByRef qHandle As %Binary, DCARowIDStr As %String, LocRowID As %String, LogLocID As %String = "", SessionStr As %String = "") As %Status
{
	s ^tmpnk("QueryTriageResource")=DCARowIDStr_","_LocRowID_","_LogLocID
	s ind=0
	if DCARowIDStr=""{
		Quit $$$OK 	
	}
	s HospID=$p(SessionStr,"^",4)
	s langid=$p(SessionStr,"^",6)
	s:(HospID="")&&($D(%session)) HospID=%session.Get("LOGON.HOSPID")
	s:(langid="")&&($D(%session)) langid=%session.Get("LOGON.LANGID")
	s:LogLocID="" LogLocID=%session.Get("LOGON.CTLOCID")
	s LogLocIDStr=##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(LogLocID)
	
	s DCARowIDLen=$l(DCARowIDStr,"!")
	s ServiceGroupDR=""
	k HistoryResArr
	k RelocList
	for myfor=1:1:DCARowIDLen{
		s DCARowID=$p(DCARowIDStr,"!",myfor)
		continue:DCARowID=""
		Set CureData=$g(^DHCDocCure(DCARowID))
		Set OrderId=$p(CureData,"^",2)
		s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
		continue:ArcimId=""
		set OrderAddDeptDr=""
		Set OrderAddDeptDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",2)
		if OrderAddDeptDr'=""{
			s HospID=$p(^CTLOC(OrderAddDeptDr),"^",22)	
		}
		s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ArcimId,HospID)
		continue:DDCISRowid=""
		s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
		s HistoryResStr=..GetHistoryRes(DCARowID,"ALL")
		if HistoryResStr'=""{
			s HistoryResLen=$l(HistoryResStr,"^")
			for mycount=1:1:HistoryResLen{
				s aHistoryRes=$p(HistoryResStr,"^",mycount)
				s HistoryResArr(aHistoryRes)=""
			}
		}
		s OrderRecDepRowid=$P($G(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6) 
		s:OrderRecDepRowid="" OrderRecDepRowid="9999999"
		s RelocList(OrderRecDepRowid)=""
	}
	if ServiceGroupDR=""{
		s DDCTRParRef=""
		for{
			s DDCTRParRef=$o(^DHCDocCureTR(DDCTRParRef)) q:DDCTRParRef=""
			s DDCTRChildSub=0
			for{
				s DDCTRChildSub=$o(^DHCDocCureTR(DDCTRParRef,"TR",DDCTRChildSub)) q:DDCTRChildSub=""
				d OutputTriageResource
			}
		}
	}else{
		s LinkServiceGroupStr=##class(DHCDoc.DHCDocCure.RBCServiceGroupSet).GetLinkServiceGroup(ServiceGroupDR,HospID)
		s LinkServiceGroupStr=ServiceGroupDR_"^"_LinkServiceGroupStr
		for loop=1:1:$l(LinkServiceGroupStr,"^"){
			s ServiceGroupDR=$p(LinkServiceGroupStr,"^",loop)
			continue:ServiceGroupDR=""
			s DDCTRParRef=ServiceGroupDR
			s DDCTRChildSub=0 
			for{
				s DDCTRChildSub=$o(^DHCDocCureTR(DDCTRParRef,"TR",DDCTRChildSub)) q:DDCTRChildSub=""
				d OutputTriageResource
			}
		}
	}
	Quit $$$OK 
OutputTriageResource
	s TRData=$g(^DHCDocCureTR(DDCTRParRef,"TR",DDCTRChildSub))
	s RowID=DDCTRParRef_"||"_DDCTRChildSub
	s DDCTRServiceGroup=$p(^DHCDocCureRBCServiceGroupSet(DDCTRParRef),"^",2)
	s DDCTRCTLocDr=$p(TRData,"^",1)
	Q:(LocRowID'="")&&(LocRowID'=DDCTRCTLocDr)
	Q:(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_DDCTRCTLocDr_"^"))
	s DDCTRCTLoc=$p($G(^CTLOC(DDCTRCTLocDr)),"^",2)
	s DDCTRCTLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",DDCTRCTLoc,langid)
	s DDCTRResDr=$p(TRData,"^",2)
	s DDCTRCTPCPDr=$p($G(^RB("RES",DDCTRResDr)),"^",2)
	s DDCTRCTPCP=$p($G(^CTPCP(DDCTRCTPCPDr,1)),"^",2)
	s DDCTRCTPCP=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",DDCTRCTPCP,langid)
	s DDCTRActive=$p(TRData,"^",3)
	q:DDCTRActive'="Y"
	if DDCTRActive="Y" s DDCTRActive=""
	else  s DDCTRActive="已失效"
	s CureTriageNum=+(..GetTriagedCount(RowID,"T"))
	s DDCTRCount=$p(TRData,"^",4)
	if DDCTRCount'="" s DDCTRLeftCount=(+DDCTRCount)-CureTriageNum
	else  s DDCTRCount="-",DDCTRLeftCount="-"
	s sortCode="09"
	s DDCTRHistoryRes=""
	if $D(RelocList(DDCTRCTLocDr)) s sortCode="02"
	if $d(HistoryResArr(RowID)){
		s DDCTRHistoryRes=##class(websys.Translation).Get("doccure.cureapplist.hui.csp","是")
		s sortCode="01"
	}
	set qHandle(sortCode,RowID,$I(ind))=$lb(RowID,DDCTRParRef,DDCTRServiceGroup,DDCTRCTLocDr,DDCTRCTLoc,DDCTRResDr,DDCTRCTPCP,CureTriageNum,DDCTRCount,DDCTRLeftCount,DDCTRHistoryRes)
	quit
}

ClassMethod QueryTriageResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTriageResourceExecute ]
{
	s sortCode=$O(qHandle(""))
	if sortCode'=""{
		s rowID=$O(qHandle(sortCode,""))
		if rowID'=""{
			s ind=$O(qHandle(sortCode,rowID,""))
			if ind'=""{
				s Row=qHandle(sortCode,rowID,ind)
				k qHandle(sortCode,rowID,ind)
				Quit $$$OK
			}
		}
	}
	s AtEnd=1
	Quit $$$OK
}

/// Description:得到分配资源下的已分配申请单数量
/// Debug:w ##class(DHCDoc.DHCDocCure.Triage).GetTriagedCount("5")
ClassMethod GetTriagedCount(DDCTRResID As %String, Status As %String = "")
{
	s count=0
	s DDCTParRef=""
	f  s DDCTParRef=$O(^DHCDocCureTRIi(0,"StatuRBAS","T",DDCTRResID,DDCTParRef)) Q:DDCTParRef=""  d
	.s DDCTChildSub=0
	.f  s DDCTChildSub=$o(^DHCDocCureTRIi(0,"StatuRBAS","T",DDCTRResID,DDCTParRef,DDCTChildSub)) Q:DDCTChildSub=""  d
	..s count=count+1
	/*
	s DDCTParRef=""
	f  s DDCTParRef=$o(^DHCDocCureTRIi(0,"RBAS",DDCTRResID,DDCTParRef)) Q:DDCTParRef=""  d
	.s DDCTChildSub=0
	.f  s DDCTChildSub=$o(^DHCDocCureTRIi(0,"RBAS",DDCTRResID,DDCTParRef,DDCTChildSub)) Q:DDCTChildSub=""  d
	..s DDCTStatus=$p(^DHCDocCureTRI(DDCTParRef,"Triage",DDCTChildSub),"^",5)
	..Q:(Status'="")&&(DDCTStatus'=Status)
	..Q:(Status="")&&(DDCTStatus'="T")
	..s count=count+1
	*/
	s DDCTRLeftCount=""
	s DDCTRParRef=+DDCTRResID
	s DDCTRChildSub=$p(DDCTRResID,"||",2)
	s TRData=$g(^DHCDocCureTR(DDCTRParRef,"TR",DDCTRChildSub))
	s DDCTRCount=$p(TRData,"^",4)
	if DDCTRCount'="" s DDCTRLeftCount=(+DDCTRCount)-count
	else  s DDCTRLeftCount=""
	q count_"^"_DDCTRLeftCount
}

/// w ##class(DHCDoc.DHCDocCure.Triage).CureTriaged("43||1","")
ClassMethod CureTriaged(DDCTRResID As %String, Para As %String, Type As %String = "")
{
	s ^tmpnk("CureTriaged")=DDCTRResID_","_Para
	if Para="" Q 100
	if DDCTRResID="" Q 101
	Set DCARowID=$p(Para,"^",1)
	Set UserID=$p(Para,"^",2)
	s rtn=..CheckDHACureTriaged("A",DCARowID,DDCTRResID)
	if rtn'=""{
		s PatientName="",ArcimDesc=""
		s ApplyInfo=##class(DHCDoc.DHCDocCure.Apply).GetSimpleCureApply(DCARowID)
		if ApplyInfo'="" {
			s CureAppInfo=$p(ApplyInfo,$c(1),2)
			s ArcimDesc=$p(CureAppInfo,"^")
			s PatientInfo=$p(ApplyInfo,$c(1),1)
			s PatientNo=$p(PatientInfo,"^",2)
			s PatientName=$p(PatientInfo,"^",3)
		}
		s rtn=PatientName_"-"_ArcimDesc_" "_rtn
		Q rtn
	}
	Ts
	K PLIST
	s PLIST(3)=DDCTRResID
	s PLIST(4)=UserID
	s PLIST(5)=+$H
	s PLIST(6)=$P($H,",",2)
	s PLIST(7)="T"
	s PLIST(0)=DCARowID
 	&sql(insert into SQLUser.DHC_DocCureTriage values :PLIST())
	if 'SQLCODE{
		s DCAStatus="D"
		&sql(update SQLUser.DHC_DocCureApp set DCA_Status=:DCAStatus where DCA_RowId=:DCARowID)
		if SQLCODE{
			Tro
			Q "-300"
		}
	}else{
		Tro	
		Q "-301"
	}
	Tc
	Q 0
}

/// w ##class(DHCDoc.DHCDocCure.Triage).CancelTriaged("4||2","600")
ClassMethod CancelTriaged(DDCTRRowID As %String, UserID As %String)
{
	s ^tmpnk("CancelTriaged")=DDCTRRowID_","_UserID
	if DDCTRRowID="" Q 100
	s DDCTParRef=+DDCTRRowID
	s DDCTChildSub=$p(DDCTRRowID,"||",2)
	if '$d(^DHCDocCureTRI(DDCTParRef,"Triage",DDCTChildSub)) Q 101
	s DDCTStatus=$p(^DHCDocCureTRI(DDCTParRef,"Triage",DDCTChildSub),"^",5)
	s rtn=..CheckDHACureTriaged("C",DDCTRRowID)
	Q:rtn'="" rtn
	
	Ts
	s curdate=+$H
	s curetime=$P($H,",",2)
	s DDCTStatus="C"
 	&sql(update SQLUser.DHC_DocCureTriage set DDCT_CancelTriageUser_DR=:UserID,DDCT_CancelTriageDate=:curdate,DDCT_CancelTriageTime=:curetime,
 	DDCT_Status=:DDCTStatus where DHCDocCureTRI_RowID=:DDCTRRowID)
	if 'SQLCODE{
		s DCARowID=+DDCTRRowID
		s DCAStatus="A"
		&sql(update SQLUser.DHC_DocCureApp set DCA_Status=:DCAStatus where DCA_RowId=:DCARowID)
		if SQLCODE{
			Tro
			Q "-300"	
		}
	}else{
		Tro	
		Q "-301"
	}
	Tc
	q 0
}

Query QueryTriageList(DCARowIDStr As %String, DDCTRIRowID As %String, Status As %String = "", SessionStr As %String = "") As %Query(ROWSPEC = "Rowid:%String,PatientNo:%String,PatientName:%String,ArcimDesc:%String,DDCTRCTLoc:%String,DDCTRCTPCP:%String,DDCTRUser:%String,DDCTRDate:%String,DDCTRStatus:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Triage","QueryTriageList","129","")
ClassMethod QueryTriageListExecute(ByRef qHandle As %Binary, DCARowIDStr As %String, DDCTRIRowID As %String, Status As %String = "", SessionStr As %String = "") As %Status
{
	s ^tmpnk("QueryTriageResource")=DCARowIDStr_","_DDCTRIRowID_","_Status_","_Status
	s ind=1
	s repid=$I(^CacheTemp)
	if (DCARowIDStr="")&&(DDCTRIRowID=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK 	
	}
	s langid="20"
	if SessionStr'=""{
		s langid=$p(langid,"^",6)	
	}
	if DCARowIDStr'=""{
		s DCARowIDLen=$l(DCARowIDStr,"!")
		for myfor=1:1:DCARowIDLen{
			s DCARowID=$p(DCARowIDStr,"!",myfor)
			continue:DCARowID=""
			Set CureData=$g(^DHCDocCure(DCARowID))
			Set OrderId=$p(CureData,"^",2)
			s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
			continue:ArcimId=""
			set OrderAddDeptDr="",HospID=""
			Set OrderAddDeptDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",2)
			if OrderAddDeptDr'=""{
				s HospID=$p(^CTLOC(OrderAddDeptDr),"^",22)	
			}
			s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ArcimId,HospID)
			continue:DDCISRowid=""
			s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
			s DDCTChildSub=0
			for  s DDCTChildSub=$o(^DHCDocCureTRI(DCARowID,"Triage",DDCTChildSub)) Q:DDCTChildSub=""  d
			.s TRIRowID=DCARowID_"||"_DDCTChildSub
			.s TRIResRowID=$p(^DHCDocCureTRI(DCARowID,"Triage",DDCTChildSub),"^",1)
			.Q:(DDCTRIRowID'="")&&(TRIResRowID'=DDCTRIRowID)
			.d OutTriageList
		}
	}else{
		s DDCTRParRef=0 f  s DDCTRParRef=$o(^DHCDocCureTRIi(0,"RBAS",DDCTRIRowID,DDCTRParRef)) q:DDCTRParRef=""  d
		.s DDCTChildSub=""
		.s DDCTChildSub=0 f  s DDCTChildSub=$o(^DHCDocCureTRIi(0,"RBAS",DDCTRIRowID,DDCTRParRef,DDCTChildSub)) q:DDCTChildSub=""  d
		..s TRIRowID=DDCTRParRef_"||"_DDCTChildSub
		..d OutTriageList
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK 
OutTriageList
	s CureData=##class(DHCDoc.DHCDocCure.Apply).GetCureApply(+TRIRowID)
	Q:CureData=""
	s PatientInfo=$p(CureData,$c(1),1)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s CureAppInfo=$p(CureData,$c(1),2)
	s ArcimDesc=$p(CureAppInfo,"^")
	s DDCTRParRef=+TRIRowID
	s DDCTChildSub=$p(TRIRowID,"||",2)
	Q:'$D(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub))
	s TRIStatus=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",5)
	Q:(Status'="")&(TRIStatus'=Status)
	;Q:(Status="")&(TRIStatus'="T")
	s TRIResRowID=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",1)
	s TRIUser=""
	s TRIUserDr=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",2)
	s TRIDate=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",3)
	s TRITime=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",4)
	if TRIStatus="C"{
		s TRIUserDr=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",6)
		s TRIDate=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",7)
		s TRITime=$p(^DHCDocCureTRI(DDCTRParRef,"Triage",DDCTChildSub),"^",8)
	}
	if TRIUserDr'=""{
		s TRIUser=$p(^SSU("SSUSR",TRIUserDr),"^",2)
		s TRIUser =##class(User.SSUser).GetTranByDesc("SSUSRName",TRIUser,langid)
	}
	s TRIDate=##class(websys.Conversions).DateLogicalToHtml(TRIDate) ;$zd(TRIDate,3)
	s TRITime=$zt(TRITime,2)
	;s TRIStatus=$case(TRIStatus,"T":"已分配","C":"取消分配","A":"已接收",:"")
	s TRIStatus=$case(TRIStatus,
	"T":##class(websys.Translation).Get("doccure.cureapplist.hui.csp","已分配"),
	"C":##class(websys.Translation).Get("doccure.cureapplist.hui.csp","取消分配"),
	"A":##class(websys.Translation).Get("doccure.cureapplist.hui.csp","已接收"),
	:"")
	s TRIDate=TRIDate_" "_TRITime
	s TRData=$g(^DHCDocCureTR(+TRIResRowID,"TR",$p(TRIResRowID,"||",2)))
	s DDCTRCTLocDr=$p(TRData,"^",1)
	s DDCTRCTLoc=$p($G(^CTLOC(DDCTRCTLocDr)),"^",2)
	s DDCTRCTLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",DDCTRCTLoc,langid)
	s DDCTRResDr=$p(TRData,"^",2)
	s DDCTRCTPCPDr=$p($G(^RB("RES",DDCTRResDr)),"^",2)
	s DDCTRCTPCP=$p($G(^CTPCP(DDCTRCTPCPDr,1)),"^",2)
	s DDCTRCTPCP=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",DDCTRCTPCP,langid)
	set Data=$lb(TRIRowID,PatientNo,PatientName,ArcimDesc,DDCTRCTLoc,DDCTRCTPCP,TRIUser,TRIDate,TRIStatus)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1 
	quit
}

ClassMethod QueryTriageListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryTriageListExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod QueryTriageListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryTriageListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {
	 // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/// Creator：      nikang
/// CreatDate：    2018-03-26
/// Description:   根据本次治疗申请获取历史的最近一次分配资源
/// Table: 		   DHC_DocCureTriage
/// Input：        DCARowID:申请单ID
/// OutPut: 	   
/// Debug:		   w ##class(DHCDoc.DHCDocCure.Triage).GetHistoryRes(100)
ClassMethod GetHistoryRes(DCARowID As %String, AllFlag As %String = "")
{
	n (DCARowID,AllFlag)
	Set CureData=$g(^DHCDocCure(DCARowID))
	set order=$p(CureData,"^",2)
	Set Adm=$p(CureData,"^",1)
	;找到申请医嘱
	set Arcimdr=""
	set:order'="" Arcimdr=$p($g(^OEORD(+order,"I",$p(order,"||",2),1)),"^",2)
	Q:Adm="" ""
	s findResRowID=""
	Set PatientId=$P($G(^PAADM(Adm)),"^",1)
	s ADMType=""
	for{ 
		set ADMType=$o(^PAPERdr(PatientId,"ADM",ADMType)) Q:(ADMType="")!((findResRowID'="")&&(AllFlag=""))
		continue:ADMType="H"
		set AdmID=""
		for{
			set AdmID=$o(^PAPERdr(PatientId,"ADM",ADMType,AdmID),-1) Q:(AdmID="")!((findResRowID'="")&&(AllFlag=""))
			s DCARowIDs=""
			for{
				s DCARowIDs=$o(^DHCDocCure(0,"Adm",AdmID,DCARowIDs),-1) Q:(DCARowIDs="")!((findResRowID'="")&&(AllFlag=""))  d
				continue:DCARowID=DCARowIDs
				s FindArcim=""
				s OrderFind=$P($G(^DHCDocCure(DCARowIDs)),"^",2)
				s:OrderFind'="" FindArcim=$p($g(^OEORD(+OrderFind,"I",$p(OrderFind,"||",2),1)),"^",2)
				Continue:((FindArcim'="")&(Arcimdr'="")&(FindArcim'=Arcimdr)) 
				s DDCTChildSub=""
				for {
					s DDCTChildSub=$o(^DHCDocCureTRI(DCARowIDs,"Triage",DDCTChildSub),-1) Q:(DDCTChildSub="")!((findResRowID'="")&&(AllFlag=""))  d	
					continue:(DDCTChildSub=0)
					s DDCTStatus=$p(^DHCDocCureTRI(DCARowIDs,"Triage",DDCTChildSub),"^",5)
					continue:(DDCTStatus="C")
					s TRIResRowID=$p(^DHCDocCureTRI(DCARowIDs,"Triage",DDCTChildSub),"^",1)
					continue:TRIResRowID=""
					s TRData=$g(^DHCDocCureTR(+TRIResRowID,"TR",$p(TRIResRowID,"||",2)))
					s DDCTRActive=$p(TRData,"^",3)
				 	continue:DDCTRActive'="Y"
				 	if findResRowID="" s findResRowID=TRIResRowID
				 	else  s findResRowID=findResRowID_"^"_TRIResRowID
				}
			}
		}
	}
 	Q findResRowID
}

ClassMethod UpdateTriageStatus(DCARowID, UserID, Status As %String = "")
{
	n (DCARowID,UserID,Status,%session)
	;是否启用分诊配置
	s DHCDocCureNeedTriage=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig(DCARowID,"CureLocNeedTriage")
	Q:DHCDocCureNeedTriage'=1 0
	s FindRowid=""
	s DDCTChildSub=0
	for  s DDCTChildSub=$o(^DHCDocCureTRI(DCARowID,"Triage",DDCTChildSub)) Q:(DDCTChildSub="")!(FindRowid'="")  d
	.s myStatus=$p(^DHCDocCureTRI(DCARowID,"Triage",DDCTChildSub),"^",5)
	.q:myStatus'="T"
	.s FindRowid=DCARowID_"||"_DDCTChildSub
	;Q:findrec="" "-300"
	s curdate=+$H
	s curetime=$P($H,",",2)
	
	if Status="" s Status="A"
	if FindRowid'=""{
		s obj=##class(User.DHCDocCureTriage).%OpenId(FindRowid)
		if $IsObject(obj){
			s obj.DDCTStatus=Status
			s obj.DDCTArriveDate=curdate
			s obj.DDCTArriveTime=curetime
			do obj.DDCTArriveUserDRSetObjectId(UserID)
			s sc=obj.%Save()
		    If $$$ISERR(sc){
			    Quit "-301"
		    }
		    d obj.%Close()
		    s obj=""
		}else{
			Quit "-302"	
		}
	}
	Q 0
}

/// Desc:检测单子是否可以被分配/取消分配
/// Input:CancelType A/C A验证分配 C验证取消 DCARowID A-申请单ID C-分配记录ID
/// Output: 不为空为提示信息
/// w ##class(DHCDoc.DHCDocCure.Triage).CheckDHACureTriaged(129,"A","76||1")
ClassMethod CheckDHACureTriaged(CheckType As %String, DCRowID As %String, DDCTRResID As %String = "")
{
	n (CheckType,DCRowID,DDCTRResID)
	s DCARowID=+DCRowID
	s CureData=$g(^DHCDocCure(DCARowID))
	//进行新增认证
	if (CheckType="A"){
		Q:CureData="" "不存在治疗申请信息,不能进行分配!"
		
		s ApplyStatus=$p(CureData,"^",3)
		if ApplyStatus'="A"{
			Q "该治疗申请的申请单状态非申请状态,不能进行分配"
		}
		s Adm=$P(CureData,"^",1)
		s OrderId=$p(CureData,"^",2)
		
		s myrtn=##class(DHCDoc.DHCDocCure.Appointment).CheckAdmType(Adm,OrderId)
		if ("^1081^1082^")[("^"_myrtn_"^"){
			q "患者就诊状态异常,不能进行分配,请核实!"
		}elseif myrtn="108"{
			q "该治疗申请医嘱未缴费,不能进行分配!"
		}
		
		if (OrderId'=""){
			s StatusCode="",StatusDesc=""
			s StatusRowId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",13)
			s:StatusRowId'="" StatusCode=$p(^OEC("OSTAT",StatusRowId),"^",1),StatusDesc=$p(^OEC("OSTAT",StatusRowId),"^",2)
			Q:((StatusCode'="V")&(StatusCode'="E")) "该治疗申请医嘱状态异常为【"_StatusDesc_"】!不能进行分配!"
		}
		
		s FindRowid=""
		s DDCTChildSub=0
		for  s DDCTChildSub=$o(^DHCDocCureTRI(DCARowID,"Triage",DDCTChildSub)) Q:(DDCTChildSub="")!(FindRowid'="")  d
		.s status=$p(^DHCDocCureTRI(DCARowID,"Triage",DDCTChildSub),"^",5)
		.q:status="C"
		.s FindRowid=DCARowID_"||"_DDCTChildSub
		Q:FindRowid'="" "该治疗申请已分配,不能再次分配"
		
		set LeftCount=..GetTriagedCount(DDCTRResID)
		set LeftCount=$p(LeftCount,"^",2)
		Q:(LeftCount'="")&&(+LeftCount=0) "该分配资源可分配数量为0,不能继续分配."
	}elseif (CheckType="C"){
		Q:CureData="" "不存在申请信息,不能取消分配!"
		s statu=$P(CureData,"^",3) //申请单状态 A 申请 C 撤销 F 完成 D 分配
		Q:statu'="D" "该治疗申请的申请单状态不是【分配状态】,不能取消分配!" ;
		s triageDr=0
		s triageDr=$P(DCRowID,"||",2)
		if triageDr'=""{
			s triageStatu=$P($G(^DHCDocCureTRI(DCARowID,"Triage",triageDr)),"^",5)
			s statu=$case(triageStatu,"T":"已分配","A":"已接收","C":"取消分配","F":"已完成",:"")
			Q:(triageStatu'="T")&&((triageStatu'="A")) "该分配记录的状态为"_statu_",不能取消分配!"
		}
		
		s OrderId=$p(CureData,"^",2)
		s ApplyAppInfo=##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowID)
		s ApplyAppNum=+ApplyAppInfo
		Q:ApplyAppNum>0 "该治疗申请存在正常的治疗预约记录,不能取消分配!"
		s FindExec=0
		s Sub=0
		for  s Sub=$o(^OEORD(+OrderId,"I",$P(OrderId,"||",2),"X",Sub)) Q:(Sub="")!(FindExec=1)  d
		.s StatusRowId=$P(^OEORD(+OrderId,"I",$P(OrderId,"||",2),"X",Sub),"^",16)
		.s StatusCode=""
		.if StatusRowId'="" s StatusCode=$P($G(^OEC("STAT",StatusRowId)),"^",1)
		.if (StatusCode="F") s FindExec=1
		Q:FindExec=1 "该治疗申请存在正常已治疗的记录,不能取消分配!"
	}
	q ""
}

}
