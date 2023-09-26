Class web.DHCDocAntibioticApply Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod GetPatDetail(Adm As %String) As %String
{
	n (Adm)
	s ret=""
	s AdmIDStr=##class(web.DHCDocOrderEntry).GetPateintIDMethod(Adm)
	s PatientID=$p(AdmIDStr,"^")
	
	s PatDetail=##class(web.DHCDocOrderEntry).GetPatientByRowid(PatientID)
	s PatientName=$p(PatDetail,"^",3)
	s PatientSex=$p(PatDetail,"^",4)
	s AgeDesc=$p(PatDetail,"^",5)
	s Medcare=$p(PatDetail,"^",19)
	s AdmDepID=$p($g(^PAADM(Adm)),"^",4)
	i AdmDepID'="" s AdmDep=$p($g(^CTLOC(AdmDepID)),"^",2)  ;bug  2013-1-6  缺少"^"
	e  s AdmDep=""
	i $l(AdmDep,"-")=2 s AdmDep=$p(AdmDep,"-",2)
	s AdmDocID=$p($g(^PAADM(Adm)),"^",9)
	i AdmDocID'="" s AdmDoc=$p($g(^CTPCP(AdmDocID,1)),"^",2)
	e  s AdmDoc=""
	s Bed=$p($g(^PAADM(Adm)),"^",73)
	i Bed'="" s Bed=$p($g(^PAWARD(+Bed,"BED",$p(Bed,"||",2))),"^",1)
	s ret=PatientName_"^"_PatientSex_"^"_AgeDesc_"^"_Medcare_"^"_AdmDep_"^"_AdmDoc_"^"_Bed_"^"_AdmDepID_"^"_AdmDocID
	
	Q ret
}

/// 得到药品信息
ClassMethod GetEPARCIMDetail(EpisodeID As %String, ArcimRowid As %String) As %String
{
	n (EpisodeID,ArcimRowid)
	s myrtn=""
	s InsType="",OrderDepRowid="",OpenForAllHosp=""
	s ret=##class(web.DHCDocOrderCommon).GetEPARCIMDetail(EpisodeID,InsType,OrderDepRowid,ArcimRowid,OpenForAllHosp)
	s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	s iform=$p(ret,"^",11)
	s iinstr=$p(ret,"^",14)
	
	s FormDesc=$p(iform,$C(1),1)
	s DrgformRowid=$p(iform,$C(1),2)
	s FormInstrDesc=$p(iinstr,$C(1),1)
	s FormInstrRowid=$p(iinstr,$C(1),2)
	
	s myrtn=ArcimDesc_"^"_DrgformRowid_"^"_FormDesc_"^"_FormInstrRowid_"^"_FormInstrDesc
	
	Q myrtn
}

/// 用法
/// w ##class(web.DHCDocAntibioticApply).LookUpInstructionStr()
ClassMethod LookUpInstructionStr(desc As %String = "") As %String
{
	 s ret=""
	 Set rset=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpInstr")
	 s desc=$zcvt(desc,"U")
	 do rset.Execute(desc)
	 While (rset.Next()) {
		s Code=rset.GetData(3)
		s Desc=rset.GetData(2)
		s Rowid=rset.GetData(1)
		if $l(Desc,"-")=2 s Alias=$p(Desc,"-",1),Desc=$p(Desc,"-",2)
		e  s Alias=""
		;i ret="" s ret=Rowid_$C(1)_Code_"-"_Alias
		;e  s ret=ret_"^"_Rowid_$C(1)_Code_"-"_Alias
		s ret=ret_"^"_Rowid_$C(1)_Desc_"-"_Alias
	 }
	 d rset.Close()
	 q ret
}

/// 用药原因
ClassMethod LookUpAntUseReasonStr(desc As %String = "") As %String
{
	 s ret=""
	 s AurRowid=0
	 for {
		 s AurRowid=$O(^DCTAR("AUR",AurRowid)) Q:AurRowid=""
		 s Code=$p($g(^DCTAR("AUR",AurRowid)),"^",1)
		 s Desc=$p($g(^DCTAR("AUR",AurRowid)),"^",2)
		 s ActiveFlag=$p($g(^DCTAR("AUR",AurRowid)),"^",3)
		 i ActiveFlag="N" continue
		 ;i ret="" s ret=AurRowid_$C(1)_Desc
		 ;e  s ret=ret_"^"_AurRowid_$C(1)_Desc
		 s ret=ret_"^"_AurRowid_$C(1)_Desc_"-"_Code
	 }
	 q ret
}

ClassMethod GetExecuteCTLOC() As %String
{
	Set CTLOCRowid=""
	Set RetStr=""
	F  s CTLOCRowid=$O(^CTLOC(CTLOCRowid)) q:CTLOCRowid=""  d
	.Set CTLOCType=$P($G(^CTLOC(CTLOCRowid)),"^",13)
	.Q:CTLOCType'="E"
	.Set CTLOCDesc=$P($G(^CTLOC(CTLOCRowid)),"^",2)
	.Set CTLOCDescQuickCode=$P(CTLOCDesc,"-",1)
	.Set CTLOCCode=$P(CTLOCDesc,"-",2)
	.If CTLOCDesc'="" d
	..If RetStr'="" Set RetStr=RetStr_"^"_CTLOCRowid_$c(1)_CTLOCCode_"-"_CTLOCDescQuickCode
	..If RetStr="" Set RetStr=CTLOCRowid_$c(1)_CTLOCCode_"-"_CTLOCDescQuickCode
	Q RetStr
}

/// 得到科室下医师
/// w ##class(web.DHCDocAntibioticApply).GetDocByCTLOC(1)
ClassMethod GetDocByCTLOC(LocId As %String) As %String
{
	;RB_Resource
	q:LocId="" ""
	s ret=""
	s RESRowid=0
	f  s RESRowid=$o(^RB("RES",0,"CTLOC",LocId,RESRowid)) q:RESRowid=""  d
    .s CTPCPDR=$P(^RB("RES",RESRowid),"^",2)
    .s Desc=$P(^CTPCP(CTPCPDR,1),"^",2)
    .s ret=ret_"^"_CTPCPDR_$C(1)_Desc
    
    Q ret
}

/// w ##class(web.DHCDocAntibioticApply).Insert($g(^gry("InsertAnt")))
ClassMethod Insert(Para As %String) As %String
{
	s ^gry("InsertAnt")=Para
	Set $ZT="ERROR^DHCSSERR"
	;Para=EpisodeID+"^"+ArcimRowid+"^"+OrderPriorRowid+"^"+DoseQty+"^"+OrderDoseUomRowid+"^"+OrderFreqRowid;
	;Para+=Para+"^"+OrderDurRowid+"^"+OrderInsterRowID+"^"+ApplyUserID+"^"+ApplyDate+"^"+ApplyTime+"^"+ApplyRemark;
	;Para+=Para+"^"+StopDate+"^"+StopTime+"^"+UseReasonID+"^"+MicrobeSpec+"^"+DrugTest+"^"+ConsultationDepRowID;
	;Para+=Para+"^"+ConsultationDocRowID+"^"+UserAdd+"^"+ApplyTypeControl;
	
	s EpisodeID=$p(Para,"^",1),ArcimRowid=$p(Para,"^",2),OrderPriorRowid=$p(Para,"^",3)
	if OrderPriorRowid=1  s OrderPriorRowid=$O(^OECPR(0,"Code","NORM",0))
	s DoseQty=$p(Para,"^",4),OrderDoseUomRowid=$p(Para,"^",5),OrderFreqRowid=$p(Para,"^",6)
	s OrderDurRowid=$p(Para,"^",7),OrderInsterRowID=$p(Para,"^",8),ApplyUserID=$p(Para,"^",9)
	s StartDate=$p(Para,"^",10),StartTime=$p(Para,"^",11),ApplyRemark=$p(Para,"^",12)
	s StopDate=$p(Para,"^",13),StopTime=$p(Para,"^",14),UseReasonID=$p(Para,"^",15)
	s MicrobeSpec=$p(Para,"^",16),DrugTest=$p(Para,"^",17),ConsultationDepRowID=$p(Para,"^",18)
	s ConsultationDocRowID=$p(Para,"^",19),UserAdd=$p(Para,"^",20),ApplyTypeControl=$p(Para,"^",21)
	i StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)		;s StartDate=$zdh(StartDate,3)
	s ApplyDate=+$h
	s ApplyTime=$p($h,",",2)                  
	i StopDate'="" s StopDate=$zdh(StopDate,3)
	Set AntibApplyRowid=$p(Para,"^",22)
	Set UserReasonId=$p(Para,"^",23)
	set OrderDays=$p(Para,"^",24) //12-10-31
	set isEmergency=$p(Para,"^",25) 
	set ApplyLoc=$p(Para,"^",26) 
	s myrtn="-1"
	if AntibApplyRowid=""{
		s Obj=##class(User.DHCDocAntibioticApply).%New()
		if $ISObject(Obj) {
			TS
			d Obj.AAAdmDRSetObjectId(EpisodeID)
			d Obj.AAArcimDRSetObjectId(ArcimRowid)
			if OrderPriorRowid'="" d Obj.AAPriorDRSetObjectId(OrderPriorRowid)
			s Obj.AADoseQty=DoseQty
			if OrderDoseUomRowid'="" d Obj.AADoseUomDRSetObjectId(OrderDoseUomRowid)
			if OrderFreqRowid'="" d Obj.AAFreqDRSetObjectId(OrderFreqRowid)
			if OrderDurRowid'="" d Obj.AADurDRSetObjectId(OrderDurRowid)    
			if OrderInsterRowID'="" d Obj.AAInstrDRSetObjectId(OrderInsterRowID) 
			if ApplyUserID'="" d Obj.AAApplyUserDRSetObjectId(ApplyUserID)
			s Obj.AAApplyDate=ApplyDate
			s Obj.AAApplyTime=ApplyTime
			s Obj.AAApplyStatus="A"
			s Obj.AAApplyRemark=ApplyRemark
			s Obj.AAEndDate=StopDate
			s Obj.AAEndTime=StopTime
			if UseReasonID'="" d Obj.AAUseReasonDRSetObjectId(UseReasonID)
			s Obj.AAMicrobeSpecFlag=MicrobeSpec
			s Obj.AADrugTestFlag=DrugTest
			if ConsultationDepRowID'="" d Obj.AAConsultationDepDRSetObjectId(ConsultationDepRowID)
			if ConsultationDocRowID'="" d Obj.AAConsultationDocDRSetObjectId(ConsultationDocRowID)   
			d Obj.AAUserAddDRSetObjectId(UserAdd)
			s Obj.AADateAdd=+$H
			s Obj.AATimeAdd=$p($h,",",2)
			s Obj.AAApplyTypeControl=ApplyTypeControl
		
			d Obj.AALastUpdateUserSetObjectId(UserAdd)
			s Obj.AALastUpdateDate=+$H
			s Obj.AALastUpdateTime=$p($h,",",2)
			do Obj.AAPurposeDRSetObjectId(UserReasonId)
			s Obj.AAOrderDays=OrderDays        ;12-10-31
			s Obj.AAisEmergency=isEmergency    ;12-11-28 
			s Obj.AAStDate=StartDate           ;12-11-29
			s Obj.AALocDR=ApplyLoc             ;13-2-4
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
		s Obj=##class(User.DHCDocAntibioticApply).%OpenId(AntibApplyRowid)	
		if $ISObject(Obj) {
			TS
			if OrderPriorRowid'="" d Obj.AAPriorDRSetObjectId(OrderPriorRowid)
			s Obj.AADoseQty=DoseQty
			if OrderDoseUomRowid'="" d Obj.AADoseUomDRSetObjectId(OrderDoseUomRowid)
			if OrderFreqRowid'="" d Obj.AAFreqDRSetObjectId(OrderFreqRowid)
			if OrderDurRowid'="" d Obj.AADurDRSetObjectId(OrderDurRowid)    
			if OrderInsterRowID'="" d Obj.AAInstrDRSetObjectId(OrderInsterRowID) 

			s Obj.AAApplyRemark=ApplyRemark
			s Obj.AAEndDate=StopDate
			s Obj.AAEndTime=StopTime
			if UseReasonID'="" d Obj.AAUseReasonDRSetObjectId(UseReasonID)
			s Obj.AAMicrobeSpecFlag=MicrobeSpec
			s Obj.AADrugTestFlag=DrugTest
			if ConsultationDepRowID'="" d Obj.AAConsultationDepDRSetObjectId(ConsultationDepRowID)
			if ConsultationDocRowID'="" d Obj.AAConsultationDocDRSetObjectId(ConsultationDocRowID)
		
			d Obj.AALastUpdateUserSetObjectId(UserAdd)
			s Obj.AALastUpdateDate=+$H
			s Obj.AALastUpdateTime=$p($h,",",2)
			do Obj.AAPurposeDRSetObjectId(UserReasonId)
			s Obj.AAOrderDays=OrderDays        ;12-10-31 
			s Obj.AAisEmergency=isEmergency
			s Obj.AAStDate=StartDate           ;12-11-29
			s Obj.AALocDR=ApplyLoc             ;13-2-4
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

ClassMethod LoadOther()
{
	s DHTMXPath=##class(ext.websys.DHTMLXLib).BasePath()
	w "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF="""_DHTMXPath_"dhtmlxTabbar/codebase/dhtmlxtabbar.css"">",!
	w "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF="""_DHTMXPath_"dhtmlxTabbar/samples/common/style.css"">",!
	w "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF="""_DHTMXPath_"dhtmlxCalendar/codebase/dhtmlxcalendar.css"">",!
	
	;w "<LINK REL=""stylesheet"" TYPE=""text/css"" HREF="""_DHTMXPath_"tagbox.css"">",!
	w "<SCRIPT SRC='"_DHTMXPath_"dhtmlxCalendar/codebase/dhtmlxcommon.js'></SCRIPT>",!
	w "<SCRIPT SRC='"_DHTMXPath_"dhtmlxCalendar/codebase/dhtmlxcalendar.js'></SCRIPT>",!
	w "<SCRIPT SRC='"_DHTMXPath_"dhtmlxTabbar/codebase/dhtmlxcommon.js'></SCRIPT>",!
	w "<SCRIPT SRC='"_DHTMXPath_"dhtmlxTabbar/codebase/dhtmlxtabbar.js'></SCRIPT>",!
	w "<SCRIPT SRC='"_DHTMXPath_"dhtmlxCombo/codebase/dhtmlxcombo.js'></SCRIPT>",!
}

ClassMethod GetDefaultDate(EpisodeID As %String) As %String
{
 Set DefDate=+$H
 Set DefDate=$ZD(DefDate,3)
 Set AdmDate=$P($G(^PAADM(EpisodeID)),"^",6)
 Set AdmDate=$ZD(AdmDate,3)
 Set FinDate=""
 
 Q DefDate_"^"_AdmDate_"^"_FinDate
}

/// w ##class(web.DHCDocAntibioticApply).VerifyApply("36^38")
ClassMethod VerifyApply(AppItemStr As %String) As %String
{
	s UserID=%session.Get("LOGON.USERID")
	s CurrentDate=+$H
	s CurrentTime=$P($H,",",2)
	s Err=0
	TSTART
 	s Len=$l(AppItemStr,"^")
 	f i=1:1:Len q:Err'=0  d
 	.s AppRowid=$p(AppItemStr,"^",i)
 	.&sql(update SQLUser.DHC_Doc_AntibioticApply set AA_ApplyStatus='U',AA_AuditUser_DR=:UserID,AA_AuditDate=:CurrentDate,
 		AA_AuditTime=:CurrentTime,AA_LastUpdateUser=:UserID,AA_LastUpdateDate=:CurrentDate,AA_LastUpdateTime=:CurrentTime
 	where AA_Rowid=:AppRowid)
 	.i SQLCODE'=0 s Err=SQLCODE Q
 	.s retpt=##class(web.DHCAntKSSSend).SendApplyInfo(AppRowid)
 	i Err'=0 {
		TROLLBACK 	
	}
 	TCOMMIT
 	
 	q Err
}

/// w ##class(web.DHCDocAntibioticApply).AntibApplyListExecute("",+$h,+$h)
/// d ##class(%ResultSet).RunQuery("web.DHCDocAntibioticApply","AntibApplyList",+$h,+$h)
ClassMethod AntibApplyListExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String) As %Status
{
	s ^DHCXPTest("Anti")=StartDate_","_EndDate
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
 	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s LongonDepDR=%session.Get("LOGON.CTLOCID")
	Set LongonUserDR=%session.Get("LOGON.USERID")
	Set DoctorID=##class(web.SSUser).GetDefaultCareProvider(LongonUserDR)
	//s LongonDepDR=9
	Set OrderCode=$g(^AntOrdStaus)
	if OrderCode="" Set OrderCode="U"
	s AppOrderPriorRowid=$o(^OEC("OSTAT",0,"Code",OrderCode,"")) // Pre-Order
	f ApplyDate=StartDate:1:EndDate  d
	.s AppRowid=0
	.f  s AppRowid=$o(^DHCDAAi("ApplyDate",ApplyDate,AppRowid))  q:AppRowid=""  d
	..s ApplyStatus=$p(^DHCDAA("ANT",AppRowid),"^",12)
	..q:ApplyStatus'="A"	//申请
	..s ArcimDR=$p(^DHCDAA("ANT",AppRowid),"^",2)
	..q:ArcimDR=""
	..;2013-1-4
	..s AppUser=$p(^DHCDAA("ANT",AppRowid),"^",9)              ;申请人ID
	..;s ApplyLocID=##class(web.DHCDocAntiCommon).GetDefaultLoc(AppUser)   ;暂取默认科室（应该有一字段存放申请科室ID）
	..s ApplyLocID=$p(^DHCDAA("ANT",AppRowid,1),"^",25)    ;User.DHCDocAntibioticApply已经添加申请科室字段。
	..Q:LongonDepDR'=ApplyLocID
	..s OrderName=$p(^ARCIM($p(ArcimDR,"||",1),$p(ArcimDR,"||",2),1),"^",2)        ;医嘱名称
	..s UseDate=$p(^DHCDAA("ANT",AppRowid,1),"^",24)
	..s UseDate=$zd(UseDate,3)
	..s ApplyDateAdd=$p(^DHCDAA("ANT",AppRowid,1),"^",8)
	..;s ApplyDateAdd=$zd(ApplyDateAdd,3)
	..s ApplyDateAdd=##class(websys.Conversions).DateLogicalToHtml(ApplyDateAdd)
	..s ApplyTimeAdd=$p(^DHCDAA("ANT",AppRowid,1),"^",9)
	..s ApplyTimeAdd=$zt(ApplyTimeAdd)
	..s ApplyDateTimeAdd=ApplyDateAdd_"#"_ApplyTimeAdd  ;QP
	..s ApplyUserAdd=$p(^DHCDAA("ANT",AppRowid,1),"^",7)
	..s DoctorName=$p(^SSU("SSUSR",ApplyUserAdd),"^",2)
	..s FreqDesc="",DurDesc="",InstrDesc=""
	..;s FreqDesc=$p(^PHCFR($p(^OEORD(OrderRowid,"I",ChildSub,2),"^",4)),"^",3)      	;用药频率                
	..;s DurDesc=$p(^PHCDU($p(^OEORD(OrderRowid,"I",ChildSub,2),"^",6)),"^",3)          ;用药疗程
	..s InstrDR=$p(^DHCDAA("ANT",AppRowid),"^",8)
	..if InstrDR'="" s InstrDesc=$p(^PHCIN(InstrDR),"^",2)         ;用法
	..s ApplyAdmDR=$p(^DHCDAA("ANT",AppRowid),"^",1)
	..Set PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(ApplyAdmDR)
	..s PoisonRowid=##class(web.DHCDocOrderEntry).GetDrgFormPoison(ArcimDR)
	..b  ;01
	..Set flag=..GetDoctorTypePoisonFlag(DoctorID,PAAdmType,PoisonRowid)
	..Quit:flag'=1
	..s PapmiDR=$P($G(^PAADM(ApplyAdmDR)),"^",1)
	..s PatName=$p($G(^PAPER(PapmiDR,"ALL")),"^",1)
	..s EmployeeFunction="",SecretLevel=""
	..s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PapmiDR,.ErrMsg)
	..i PatEncryptLevel'="" d
	...s EmployeeFunction=$p(PatEncryptLevel,"^",2)
	...s SecretLevel=$p(PatEncryptLevel,"^",1)
	..s curdate=+$h,curtime=$p($h,",",2)       //12-11-09
	..s ^tempshp("app")=ArcimDR_"^"_ApplyAdmDR
	..Set ConsultationDepDesc="",ConsultationDocDesc=""
	..Set ConsultationDepRowID=$p(^DHCDAA("ANT",AppRowid,1),"^",4)  //会诊科室
	..if ConsultationDepRowID'=""  do
	...Set ConsultationDepDesc=$p(^CTLOC(ConsultationDepRowID),"^",2)
	..Set ConsultationDoc=$p(^DHCDAA("ANT",AppRowid,1),"^",5)    //会诊医生
	..if ConsultationDoc'="" do
	...Set ConsultationDocDesc=$P(^CTPCP(ConsultationDoc,1),"^",2)
	..;Set ConResult=##class(web.DHCConsult).checktsyhzrowid(ArcimDR,ApplyAdmDR,curdate,curtime)
	..s ConResult="",ConResult1="",ConStatus=""
	..s ConsultationID=$p(^DHCDAA("ANT",AppRowid,1),"^",22)     //会诊表DHC_Consultation rowid 
	..if ConsultationID=""  s ConResult="无需会诊"
	..if ConsultationID'=""  d 
	...;****************************2013-1-14
	...s ConResult=$list(^User.DHCConsultationD(ConsultationID),25)
	...s ConStatus=$list(^User.DHCConsultationD(ConsultationID),16)
	...s ConsultationDepRowID=$list(^User.DHCConsultationD(ConsultationID),11)
	...s ConsultationDoc=$list(^User.DHCConsultationD(ConsultationID),12)
	...if ConsultationDepRowID'=""  do
	....Set ConsultationDepDesc=$p(^CTLOC(ConsultationDepRowID),"^",2)       //实际会诊科室
	...if ConsultationDoc'=""   d
	....s ConsultationDocDesc=$p(^CTPCP(ConsultationDoc,1),"^",2)        //实际会诊医生
	...;****************************
	...Set ConResult1=ConResult
	...if (ConResult1=1)&&(ConStatus="E") Set ConResult="同意"
	...e  if (ConResult1=2)&&(ConStatus="E") Set ConResult="不同意"
	...e  Set ConResult="无会诊记录" 
	..s PoisonCode=""
	..i PoisonRowid'="" s PoisonCode=$P(^PHCPO(PoisonRowid),"^",1)
	..d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	s Data=$ListBuild(AppRowid,PatName,OrderName,UseDate,FreqDesc,DurDesc,InstrDesc,ApplyDateTimeAdd,DoctorName,ConResult,ConsultationDepDesc,ConsultationDocDesc,PoisonCode,EmployeeFunction,SecretLevel)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1	
	q
}

ClassMethod AntibApplyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AntibApplyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod AntibApplyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AntibApplyListExecute ]
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

Query AntibApplyList(StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "AppRowid:%String,PatName:%String,OrderName:%String,ApplyDateDesc:%String,FreqDesc:%String,DurDesc:%String,InstrDesc:%String,ApplyDateTimeAdd:%String,DoctorName:%String,ConResult:%String,ConsultationDepDesc:%String,ConsultationDocDesc:%String,PoisonCode:%String,TPoliticalLevel:%String,TSecretLevel:%String")
{
}

ClassMethod GetExecuteLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExecuteLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetExecuteLocExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCDocOrderCommon","GetInstr","b")
	//s ^liyufeng("GetInstrExecute")=code
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s code=$$ALPHAUP^SSUTIL4(code)
 Set CTLOCRowid=""
	Set RetStr=""
	F  s CTLOCRowid=$O(^CTLOC(CTLOCRowid)) q:CTLOCRowid=""  d
	.Set CTLOCType=$P($G(^CTLOC(CTLOCRowid)),"^",13)
	.Q:CTLOCType'="E"
	.Set CTLOCDesc=$P($G(^CTLOC(CTLOCRowid)),"^",2)
	.Quit:(code'="")&&($p($$ALPHAUP^SSUTIL4(CTLOCDesc),code)'="")
	.Set CTLOCDescQuickCode=$P(CTLOCDesc,"-",1)
	.Set CTLOCCode=CTLOCDesc     //$P(CTLOCDesc,"-",2)
   	.Do OutwardRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutwardRow
	set Data=$lb(CTLOCRowid,CTLOCCode,CTLOCDescQuickCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetExecuteLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExecuteLocExecute ]
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

Query GetExecuteLoc(code As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod GetExecuteDocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetExecuteDocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetExecuteDocExecute(ByRef qHandle As %Binary, LocId As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCDocOrderCommon","GetInstr","b")
	//s ^liyufeng("GetInstrExecute")=code
	Set repid=$I(^CacheTemp)
 	s ind=1
 	q:LocId="" $$$OK
	;S UserId=%session.Get("LOGON.USERID")
 	;S DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserId)
	s RESRowid=0
	f  s RESRowid=$o(^RB("RES",0,"CTLOC",LocId,RESRowid)) q:RESRowid=""  d
    .s CTPCPDR=$P(^RB("RES",RESRowid),"^",2)
    .;q:CTPCPDR=DoctorID
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

ClassMethod GetExecuteDocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetExecuteDocExecute ]
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

Query GetExecuteDoc(LocId As %String) As %Query(ROWSPEC = "Rowid:%String,Desc:%String,Code:%String")
{
}

ClassMethod GetOrderSusceptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrderSusceptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetOrderSusceptExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCDocAntibioticApply","GetOrderSuscept",13)
	//d ##class(%ResultSet).RunQuery("web.DHCDocAntibioticApply","GetOrderSuscept",578)
	//s ^liyufeng("GetInstrExecute")=code
	//rowid^序号^报告日期^样本号^^编码^细菌名[中文]^耐药机制^细菌名英文名^抗生素名^备注^whonet
	//Rowid   SeqNo   ReportDate   SampleNo  SpecResource   code  BacterialNameC  Resistance  BacterialNameE  AntName   Note
	;Set SusceptStr="1^1^报告日期^样本号^^编码^细菌名[中文]^耐药机制^细菌名英文名^抗生素名^备注!2^2^报告日期^样本号^^编码^细菌名[中文]^耐药机制^细菌名英文名^抗生素名^备注"
	;Set repid=$I(^CacheTemp)
 	;s ind=1
 	Set repid=$I(^CacheTemp)
	Set ind=1
    Set qHandle=$lb(0,repid,0)
	s SeqNo=0
 	q:EpisodeID="" $$$OK
 	
 	s ^tlsj("VV")=EpisodeID
	Set SusceptStr=##class(web.DHCLabGerm).GetAllSenResbyEpisID(EpisodeID)
	Set len=$l(SusceptStr,"!")
	for i=1:1:len do
	.Set Suscept=$p(SusceptStr,"!",i)
	.q:Suscept=""                     ;2012-1-14
	.Set Rowid=$p(Suscept,"^",1)
	.;Set SeqNo=$p(Suscept,"^",2)
	.Set ReportDate=..GetStrToDate($p(Suscept,"^",3))
	.set ReportDate=##class(websys.Conversions).DateLogicalToHtml(ReportDate)
	.Set SampleNo=$p(Suscept,"^",4)
	.Set SpecResource=$p(Suscept,"^",5)
	.Set code=$p(Suscept,"^",6)
	.Set BacterialNameC=$p(Suscept,"^",7)
	.Set Resistance=$p(Suscept,"^",8)
	.Set BacterialNameE=$p(Suscept,"^",9)
	.Set AntName=$p(Suscept,"^",10)
	.Set Note=$p(Suscept,"^",11)
	.set whoNet=$p(Suscept,"^",12)  ;
	.set TSName=$p(Suscept,"^",13)     ;检验项目
	.set SPName=$p(Suscept,"^",14)      ;标本
	.set RecDate=..GetStrToDate($p(Suscept,"^",15))     ;送检日期
	.set RecDate=##class(websys.Conversions).DateLogicalToHtml(RecDate)
	.s SeqNo=SeqNo+1
   	.Do OutwardRow2
   	
	Quit $$$OK
OutwardRow2
	set Data=$lb(Rowid,SeqNo,ReportDate,SampleNo,SpecResource,code,BacterialNameC,Resistance,BacterialNameE,AntName,Note,whoNet,TSName,SPName,RecDate)
 	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetOrderSusceptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrderSusceptExecute ]
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

Query GetOrderSuscept(EpisodeID As %String) As %Query(ROWSPEC = "Rowid:%String,SeqNo:%String,ReportDate:%String,SampleNo:%String,SpecResource:%String,code:%String,BacterialNameC:%String,Resistance:%String,BacterialNameE:%String,AntName:%String,Note:%String,whoNet:%String,TSName:%String,SPName:%String,RecDate:%String")
{
}

ClassMethod GetStrToDate(str) As %String
{
	s rtn=""
	s year=$Extract(str,1,4)
	s month=$Extract(str,5,6)
	s day=$Extract(str,7,8)
	s rtn=year_"-"_month_"-"_day
	i rtn'="" s rtn=$zdh(rtn,3)
	q rtn
}

ClassMethod GetOrderAntApplyInfo(AntibApplyRowid As %String)
{
	Quit:AntibApplyRowid="" ""
	s ApplyDate=$p(^DHCDAA("ANT",AntibApplyRowid),"^",10)  //申请日期
	s ApplyDateDesc=$zd(ApplyDate,3)
	s ApplyDateAdd=$p(^DHCDAA("ANT",AntibApplyRowid,1),"^",8)  //申请时间
	s ApplyDateAdd=$zd(ApplyDateAdd,3)
	s ApplyUserAdd=$p(^DHCDAA("ANT",AntibApplyRowid,1),"^",7)  //申请人
	s DoctorName=$p(^SSU("SSUSR",ApplyUserAdd),"^",2)
	Set EndDate=$p(^DHCDAA("ANT",AntibApplyRowid),"^",14)
	Set EndDateDesc=$zd(EndDate,3)
	Set ConsultationDep=$p(^DHCDAA("ANT",AntibApplyRowid,1),"^",4)   //会诊科室
	Set ConsultationDoc=$p(^DHCDAA("ANT",AntibApplyRowid,1),"^",5)   //会诊医生
	Set OrderInstrId=$p(^DHCDAA("ANT",AntibApplyRowid),"^",8)
	Set AntApplyInfo=ApplyDateDesc_"!"_EndDateDesc_"!"_DoctorName_"!"_ConsultationDep_"!"_ConsultationDoc_"!"_ApplyUserAdd_"!"_OrderInstrId
	Quit AntApplyInfo
}

/// Creator:      李宇峰
/// CreatDate:    2012.07.30
/// Description:  审核抗菌素申请单
/// Input:        OEORIRowid:医嘱RowId
/// Return:       审核是否成功,0 审核成功,-1审核失败
/// Others:
ClassMethod AntibioticVerify(OEORIRowid As %String, UserID As %String)
{
	Quit:OEORIRowid="" -1
	Set AppRowid=$o(^DHCDAAi("OEORI",OEORIRowid,0))
	Quit:AppRowid="" -1
	Set VerifyFlag=##class(web.DHCDocAntibioticApply).VerifyApply(AppRowid)
	Quit VerifyFlag
}

/// Creator:      李宇峰
/// CreatDate:    2012.07.30
/// Description:  拒绝抗菌素申请单
/// Input:        OEORIRowid:医嘱RowId
/// Return:       拒绝是否成功,0 拒绝成功,-1拒绝失败
/// Others:
ClassMethod AntibioticRefuse(OEORIRowid As %String, UserID As %String)
{
	Quit:OEORIRowid="" -1
	Set AppRowid=$o(^DHCDAAi("OEORI",OEORIRowid,0))
	Quit:AppRowid="" -1
	//s UserID=%session.Get("LOGON.USERID")
	s CurrentDate=+$H
	s CurrentTime=$P($H,",",2)
	TSTART
 	&sql(update SQLUser.DHC_Doc_AntibioticApply set AA_ApplyStatus='R',AA_AuditUser_DR=:UserID,AA_AuditDate=:CurrentDate,
 		AA_AuditTime=:CurrentTime,AA_LastUpdateUser=:UserID,AA_LastUpdateDate=:CurrentDate,AA_LastUpdateTime=:CurrentTime
 	where AA_Rowid=:AppRowid)
 	i SQLCODE'=0{
	 	Set Err=SQLCODE
		TROLLBACK
		Quit Err 	
	}
	TCOMMIT
	Quit 0
}

ClassMethod VerifyApply1(AppItemStr As %String, UserID As %String) As %String
{
	//s UserID=%session.Get("LOGON.USERID")
	s CurrentDate=+$H
	s CurrentTime=$P($H,",",2)
	s Err=0
	TSTART
 	s Len=$l(AppItemStr,"^")
 	f i=1:1:Len q:Err'=0  d
 	.s AppRowid=$p(AppItemStr,"^",i)
 	.&sql(update SQLUser.DHC_Doc_AntibioticApply set AA_ApplyStatus='U',AA_AuditUser_DR=:UserID,AA_AuditDate=:CurrentDate,
 		AA_AuditTime=:CurrentTime,AA_LastUpdateUser=:UserID,AA_LastUpdateDate=:CurrentDate,AA_LastUpdateTime=:CurrentTime
 	where AA_Rowid=:AppRowid)
 	.i SQLCODE'=0 s Err=SQLCODE Q
 	.s OEORIRowid=$p(^DHCDAA("ANT",AppRowid,1),"^",6)
	.q:OEORIRowid=""
	.&sql(update SQLUser.OE_OrdItem set OEORI_ItemStat_DR=1 where (OEORI_Rowid=:OEORIRowid ))
	.i SQLCODE'=0 s Err=SQLCODE Q
	.&SQL(Update SQLUser.OE_OrdExecExt Set OEORE_OrderStatus_DR=1 Where OEORE_OEORI_ParRef=:OEORIRowid)
	.i SQLCODE'=0 s Err=SQLCODE Q
	.s FillerNo=$p(^OEORD(+OEORIRowid,"I",+$p(OEORIRowid,"||",2),9),"^",12)
	.s FirstOEORIRowid=$p(FillerNo,"!!",1)
	.q:FirstOEORIRowid=""
	.&sql(update SQLUser.OE_OrdItem set OEORI_ItemStat_DR=1 where (OEORI_Rowid=:FirstOEORIRowid ))
	.i SQLCODE'=0 s Err=SQLCODE Q
	.&SQL(Update SQLUser.OE_OrdExecExt Set OEORE_OrderStatus_DR=1 Where OEORE_OEORI_ParRef=:FirstOEORIRowid)
	.i SQLCODE'=0 s Err=SQLCODE Q
 	i Err'=0 {
		TROLLBACK 	
	}
 	TCOMMIT
 	q Err
}

/// Creator:      李宇峰
/// CreatDate:    2012.08.07
/// Description:  根据申请单里的会诊科室产生会诊申请
/// Input:        AppRowid:申请单Rowid
/// Return:       0 申请成功,-1 申请失败
/// Others:
/// w ##class(web.DHCDocAntibioticApply).CreateConsultationApply(29)
ClassMethod CreateConsultationApply(AppRowid As %String)
{
	Quit:AppRowid="" -1
	//会诊科室
	Set ConsultDep=$p(^DHCDAA("ANT",AppRowid,1),"^",4)
	Quit:ConsultDep="" 0
	//RequestConDoc   要求会诊医生
	Set RequestConDoc=$p(^DHCDAA("ANT",AppRowid,1),"^",5)
	Quit:RequestConDoc="" 0
	//AppDate    申请日期
	Set AppDate=$zd(+$h,3)
	//AppTime    申请时间
	Set AppTime=$zt($p($h,",",2))
	//ConType    类别：一般|C 急|E
	Set ConType="E"
	//InOut      院内(I)|院外(O)
	Set InOut="I"
	//EpisdeID        病人Adm
	Set EpisdeID=$p(^DHCDAA("ANT",AppRowid),"^",1)
	//Specordid       医嘱id  140_62  用下划线分割
	s ArcIM=$p(^DHCDAA("ANT",AppRowid),"^",2)
	//ConDestination  会诊理由   会诊申请时，构造描述=医嘱项+使用目的/指征/用法/使用时间
	s arcimDesc=$p(^ARCIM(+ArcIM,$p(ArcIM,"||",2),1),"^",2)
	s UseReasonID=$p(^DHCDAA("ANT",AppRowid,1),"^",20)
	s UsePurpseDesc="",OPerIndDesc=""
	if UseReasonID'=""  D
	.S ReasonID=$P(^DAUP("DAUP",UseReasonID),"^",20)
	.S UsePurpseDesc=$p(^DTAUP("AUP",ReasonID),"^",2)
	.s OPerIndDr=$P(^DAUP("DAUP",UseReasonID),"^",10)
	.s OPerIndDesc=$p(^DAIND("DAIND",OPerIndDr),"^",2)
	Set ConDestination="本病人建议使用【"_arcimDesc_"】，使用目的为："_UsePurpseDesc_"，指征："_OPerIndDesc
	Set Specordid=$p(ArcIM,"||",1)_"_"_$p(ArcIM,"||",2)
	//DocGrade  医生级别:主任医师--D 副主任医师--A  普通医师--C
	Set ConDocType=$p(^CTPCP(RequestConDoc,1),"^",4)
	Set ConDocTypeDesc=$p(^CT("CPT",ConDocType),"^",2)
	Set DocGrade="C"
	if ConDocTypeDesc="主任医师" Set DocGrade="D"
	if ConDocTypeDesc="副主任医师" Set DocGrade="A"
	//AppDep      申请科室
	//AppDoc      申请医生     2013-1-14   插入 SS_User表的ID
	s AppDoc=$p(^DHCDAA("ANT",AppRowid,1),"^",7)
	s AppDep=%session.Get("LOGON.CTLOCID")   ;$p(^SSU("SSUSR",AppDoc),"^",4)
	//Status      申请状态(V)
	Set Status ="V"
	//"ConsultDep|13^AppDate|2012-07-31^AppTime|10:35^ConType|C^InOut|I^ConDestination|哈111哈哈^EpisdeID|149^Status|V^AppDep|13^AppDoc|3473^id|^RequestConDoc|348^DocGrade|D^Specordid|140_62")
	Set parr="ConsultDep"_"|"_ConsultDep_"^"_"AppDate"_"|"_AppDate_"^"_"AppTime"_"|"_AppTime_"^"_"ConType"_"|"_ConType_"^"_"InOut"_"|"_InOut
 	Set parr=parr_"^"_"ConDestination"_"|"_ConDestination_"^"_"EpisdeID"_"|"_EpisdeID_"^"_"Status"_"|"_Status_"^"_"AppDep"_"|"_AppDep
 	Set parr=parr_"^"_"AppDoc"_"|"_AppDoc_"^"_"id|"_"^"_"RequestConDoc"_"|"_RequestConDoc_"^"_"DocGrade"_"|"_DocGrade_"^"_"Specordid"_"|"_Specordid
 	s ^liyufeng("CreateConsultationApply")=parr
 	Set flag=##class(web.DHCConsult).savetskjy(parr)
 	
 	Q flag
}

ClassMethod InserConApply(Reg As %String)
{
	//w ##class(web.DHCDocAntibioticApply).InserConApply()
	Set Ret="808||1*674||6*V*^"
	if (Ret'=0)&&(Ret'=100){
		Set RetLen=$l(Ret,"^")
		for i=1:1:RetLen{
			Set OrderStr=$p(Ret,"^",i)
			continue:OrderStr=""
			Set OrderId=$p(OrderStr,"*",2)
			Set AARowid=$o(^DHCDAAi(0,"OEORI",OrderId,0))
			continue:AARowid=""
			Set rtn=##class(web.DHCDocAntibioticApply).CreateConsultationApply(AARowid)
		} 	
	}
	q 0
}

/// Creator:      李宇峰
/// CreatDate:    2012.08.22
/// Description:: 得到医护人员对某个管制分类是否有权限
/// Table:        CT_CareProv,CT_CarPrvTp,CarPrvTpPHPoison
/// Input:        
/// Output:        
ClassMethod GetDoctorTypePoisonFlag(DoctorID As %String, PAAdmType As %String, PoisonId) As %String
{
	s ^TMPgry("GetDoctorTypePoisonStr")=DoctorID_","_PAAdmType_","_PoisonId
	s Flag=0
	if DoctorID="" Q ""
	s DoctorTypeRowId=$P($G(^CTPCP(DoctorID,1)),"^",4)
	if DoctorTypeRowId="" Q ""
	s ret=""
	s Child=0 f  s Child=$O(^CT("CPT",DoctorTypeRowId,"PHPO",Child)) Q:(Child="")||(Flag=1)  d
	.s PoisonRowId=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",1)
	.Quit:PoisonRowId'=PoisonId
	.s ControlType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",2)
	.s TPPEpisodeType=$P(^CT("CPT",DoctorTypeRowId,"PHPO",Child),"^",3)
	.q:TPPEpisodeType'=PAAdmType
	.s TPPChkVerify=$p($g(^CT("CPT",DoctorTypeRowId,"PHPO",Child)),"^",4) 
	.if TPPChkVerify="Y" do
	..Set Flag=1
	Q Flag
}

/// Creator:      李宇峰
/// CreatDate:    2012.08.28
/// Description:  得到抗菌素申请单的状态
/// Input:        OEORIRowid:医嘱RowId
/// Return:       审核是否成功,0 审核成功,-1审核失败
/// Others:       1  申请状态  0 已审核    -1  此医嘱没有对应的申请单
/// w ##class(web.DHCDocAntibioticApply).GetAntibioticSta(OEORIRowid)
ClassMethod GetAntibioticSta(OEORIRowid As %String)
{
	Quit:OEORIRowid="" -1
	Set AppRowid=$o(^DHCDAAi(0,"OEORI",OEORIRowid,0))
	Quit:AppRowid="" -1
	Set Status=$p(^DHCDAA("ANT",AppRowid),"^",12)
	if Status="A" do
	.Set VerifyFlag=1
	else  do
	.Set VerifyFlag=0
	Quit VerifyFlag
}

/// Creator:      SHP
/// CreatDate:    2014.05.07
/// Description:  得到抗菌素申请单的状态
/// Input:        ConsultDR:会诊ID
/// Return:       审核是否成功,0 审核成功,-1审核失败
/// Others:       1  申请状态  0 已审核    -1  此医嘱没有对应的申请单
ClassMethod GetAntStaNew(ConsultDR As %String)
{
	Quit:ConsultDR="" -1
	Set AppRowid=$o(^DHCDAAi("Consult",ConsultDR,0))
	Quit:AppRowid="" -1
	Set Status=$p(^DHCDAA("ANT",AppRowid),"^",12)
	if Status="A" do
	.Set VerifyFlag=1
	else  do
	.Set VerifyFlag=0
	Quit VerifyFlag
}

/// w ##class(web.DHCDocAntibioticApply).CancelApply("31")
ClassMethod CancelApply(AppStr As %String) As %String
{
	Quit:AppStr="" -1
	s UserID=%session.Get("LOGON.USERID")
	s CurrentDate=+$H
	s CurrentTime=$P($H,",",2)
	s Err=0
	TSTART
	s Len=$l(AppStr,"^")
 	f i=1:1:Len q:Err'=0  d
 	.s AppRowid=$p(AppStr,"^",i)
 	.s consultid=$p(^DHCDAA("ANT",AppRowid,1),"^",22) 
 	.s Emergency=$p(^DHCDAA("ANT",AppRowid,1),"^",23)
 	.i Emergency=1 d
 	..s PurposeId=$p(^DHCDAA("ANT",AppRowid,1),"^",20) 
 	..s oeori=$P(^DAUP("DAUP",PurposeId),"^",3)
 	..q:oeori=""  // qp add 2014-04-24
 	..s oeordId=$p(oeori,"||",1)
 	..s oeoriSub=$p(oeori,"||",2)
 	..s ststat=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)    ;医嘱状态
 	..i ((ststat'=1)&&(ststat'=6)) s Emergency=0
 	..e  s Err="越级申请,不允许撤销"
 	.q:Emergency=1
 	.S adm=$p(^DHCDAA("ANT",AppRowid),"^",1)
 	.&sql(update SQLUser.DHC_Doc_AntibioticApply set AA_ApplyStatus='R',AA_AuditUser_DR=:UserID,AA_AuditDate=:CurrentDate,
 		AA_AuditTime=:CurrentTime,AA_LastUpdateUser=:UserID,AA_LastUpdateDate=:CurrentDate,AA_LastUpdateTime=:CurrentTime
 	where AA_Rowid=:AppRowid)
 	.i SQLCODE'=0 s Err=SQLCODE_"^"_"撤销失败" Q
	.s retpt=##class(web.DHCAntKSSSend).SendApplyInfo(AppRowid)
 	.q:consultid=""
 	.;s ret=##class(User.DHCConsultation).ChangeStatus(consultid,"C","Y",UserID,adm,"")
 	.;i ret'="" s Err=ret
 	i Err'=0 {
		TROLLBACK 	
	}else {
 	TCOMMIT
	}
 	q Err
}

}
