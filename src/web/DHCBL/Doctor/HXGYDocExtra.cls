Class web.DHCBL.Doctor.HXGYDocExtra Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

ClassMethod CheckOrdItmExec(checkExecString As %String, ModeString As %String = "") As %String
{
	s returnCode="0"
	if ModeString="E"
	{
		for i=1:1:$Length(checkExecString,",")
		{
			s checkorditm=$p(checkExecString,",",i)
			if checkorditm'=""
			{
				s Billed=""
				&SQL(Select OEORI_Billed Into :Billed From SQLUser.OE_OrdItem Where OEORI_RowId=:checkorditm)
				i Billed'="P" 
				{
					s returnCode="-1"
					q
				}
			}
		}
	}
	if ModeString="C"
	{
		for i=1:1:$Length(checkExecString,",")
		{
			s checkorditm=$p(checkExecString,",",i)
			if checkorditm'=""
			{
				s OrdItmStatCode=""
				&SQL(Select OEORI_ItemStat_DR->OSTAT_Code Into :OrdItmStatCode From SQLUser.OE_OrdItem Where OEORI_RowId=:checkorditm)
				if OrdItmStatCode'="V"
				{
					s returnCode="-2"
					q
				}
			}
		}
	}

	if ModeString="CC"
	{
		for i=1:1:$Length(checkExecString,",")
		{
			s checkorditm=$p(checkExecString,",",i)
			if checkorditm'=""
			{
				s OrdItmStatCode=""
				&SQL(Select OEORI_ItemStat_DR->OSTAT_Code Into :OrdItmStatCode From SQLUser.OE_OrdItem Where OEORI_RowId=:checkorditm)
				if OrdItmStatCode'="E"
				{
					s returnCode="-3"
					s ^zTom("OrdItmStatCode")=OrdItmStatCode
					q
				}
			}
		}
	}
	q returnCode
}

/// 确认医嘱
ClassMethod ConfirmOrderItem(confirmString As %String, IsConfirm As %String = "", ProcNotesString As %String = "") As %String
{
	i IsConfirm="N" 
	{
		s mstr="CC"
	}
	else
	{
		s mstr="C"
	}
	
	s checkResult=..CheckOrdItmExec(confirmString,mstr)
	s ^zTom("checkResult")=checkResult
	q:checkResult'="0" checkResult
	
	s retcode=0
	for i=1:1:$Length(confirmString,",")
	{
		s oeordid=$p(confirmString,",",i)
		i oeordid'=""
		{
			s userdr=%session.Get("LOGON.USERID")
			s oeordprocnotes=$p(ProcNotesString,$C(2),i)
			s retStr=0
			i IsConfirm="N" 
			{
				s retStr=##class(web.DHCOEOrdItem).CancelExcute(oeordid,userdr,oeordprocnotes)
			}
			else
			{
				s retStr=##class(web.DHCOEOrdItem).Excute(oeordid,userdr)
			}
			s retcode=retcode+retStr
		}
	}
	quit ""_retcode
}

ClassMethod FindLocDocCurrentAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocDocCurrentAdmExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// 检查科室病人列表,未完善
ClassMethod FindLocDocCurrentAdmExecute(ByRef qHandle As %Binary, LocID As %String = "", UserID As %String = "", IPAddress As %String = "", AllPatient As %String = "", PatientNo As %String = "", SurName As %String = "", StartDate As %Date = "", EndDate As %Date = "", ArrivedQue As %String = "", RegQue As %String = "") As %Status
{
	If LocID="" Set LocID=%session.Get("LOGON.CTLOCID")
	If LocID="" Quit $$$OK
	if (StartDate="" && EndDate) Quit $$$OK
	//过滤非检查科室的
	If StartDate="" Set StartDate=+$H
	If EndDate="" Set EndDate=+$H
	
	Kill ^TMP("DHCDocWorkBench",$j)
	Set Count=0
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	;s StartDate=+$h-360
	;s EndDate=+$h
	
	;s StartDate=61007
	;s EndDate=61010
	;s LocID="1"
	
	for i=StartDate:1:EndDate {
		;if (i<(StartDate+100)) {
		s AdmTimeDR=""
		s AdmTimeDR=$O(^PAADMi("PAADM_LocDateTime",LocID,i,AdmTimeDR))
		;b ;AdmTime
		while (AdmTimeDR'=""){
			s PAAdmDR=""
			s PAAdmDR=$O(^PAADMi("PAADM_LocDateTime",LocID,i,AdmTimeDR,PAAdmDR))
			;b ;PAAdmDr
			while (PAAdmDR'=""){
				//过滤已经做过检查的
				do OutputAdmRow
				s PAAdmDR=$O(^PAADMi("PAADM_LocDateTime",LocID,i,AdmTimeDR,PAAdmDR))
			}
			s AdmTimeDR=$O(^PAADMi("PAADM_LocDateTime",LocID,i,AdmTimeDR))
		}
		;}
	}
	Set L1="" For  Set L1=$O(^TMP("DHCDocWorkBench",$j,L1)) Quit:L1=""  Do
	.Set L2=0 For  Set L2=$O(^TMP("DHCDocWorkBench",$j,L1,L2)) Quit:L2=""  Do
	..Set ^CacheTemp(repid,ind)=^TMP("DHCDocWorkBench",$j,L1,L2)
	..Set ind=ind+1 
	Set qHandle=$lb(0,repid,0)
	Kill ^TMP("DHCDocWorkBench",$j)
	Quit $$$OK
	
	
OutputAdmRow
	Set (PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr)=""
	
	;b ;1
	//PatientID,EpisodeID,mradm
	Set PatientID=$P(^PAADM(PAAdmDR),"^",1)
	Set EpisodeID=PAAdmDR
	Set mradm=$P(^PAADM(PAAdmDR),"^",61)
	
	;b ;2
	//PAPMINO,PAPMIName,PAPMIDOB,PAPMISex
	Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	Set PAPMIName=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	If DobDate'="" Do
	.Set PAPMIDOB=$ZD($P(^PAPER(PatientID,"ALL"),"^",6),3)
	.Set PAPMIAge=$fn((+$H-DobDate)/365,"",0)
	Else  Do
	.Set PAPMIDOB="",PAPMIAge=""
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	If Sex'="" Set PAPMISex=$P($g(^CT("SEX",Sex)),"^",2)
	Else  Set PAPMISex=""
	
	;b ;3
	//PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,
	//PAAdmWard,PAAdmBed
	Set PAAdmDate=$ZD($P($g(^PAADM(PAAdmDR)),"^",6),3)
	Set PAAdmTime=$ZT($P($g(^PAADM(PAAdmDR)),"^",7),3)
	//
	Set PAAdmNo=$P($g(^PAADM(PAAdmDR)),"^",81)
	Set Loc=$P($g(^PAADM(PAAdmDR)),"^",4)
	If Loc'="" Set PAAdmDepCodeDR=$P($g(^CTLOC(Loc)),"^",2)
	Else  Set PAAdmDepCodeDR=""
	Set Doctor=$P($g(^PAADM(PAAdmDR)),"^",9)
	If Doctor'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doctor,1)),"^",2)
	Else  Set PAAdmDocCodeDR=""
	Set PAAdmType=$P($g(^PAADM(PAAdmDR)),"^",2)
	Set Hosp=$P($g(^CTLOC(Loc)),"^",22)
	If Hosp'="" Set Hospital=$P($g(^CT("HOSP",Hosp)),"^",2)
	Set Ward=$P($g(^PAADM(PAAdmDR)),"^",70)
	if Ward'="" Set PAAdmWard=$P($g(^PAWARD(Ward)),"^",2)
	else  Set PAAdmWard=""
	Set Bed=$P($g(^PAADM(PAAdmDR)),"^",73)
	if Bed'="" Set PAAdmBed=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	else  Set PAAdmBed="" 
	
	//FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,Diagnosis
	Set PAAdmStatus=$P($g(^PAADM(PAAdmDR)),"^",20)
	Set AdmReason=$P($g(^PAADM(PAAdmDR,1)),"^",7)
	If AdmReason'="" Set PAAdmReason=$P($g(^PAC("ADMREA",AdmReason)),"^",2),PAAdmReasonCode=$P($g(^PAC("ADMREA",AdmReason)),"^",5)
	Else  Set PAAdmReason="",PAAdmReasonCode=""
	Set DischargeDate=$P($g(^PAADM(PAAdmDR)),"^",17)
	If $g(mradm)'="" Set Diagnosis=..GetMRAdmDiagnosis(mradm)
	Else  Set Diagnosis=""
	//RegDoctor,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority
	Set QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",PAAdmDR,""))
	Set SeqNo="0"
	Set RegDocCode=""
	If QueRowId'="" Do
	;.Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowId)
	.Set LocSeqNo=0 ;QueObj.QueNo
	.If $L(LocSeqNo)'<3 Set SeqNo=$E(LocSeqNo,1,3) 
	.If $L(LocSeqNo)=2 Set SeqNo="0"_LocSeqNo
	.If $L(LocSeqNo)=1 Set SeqNo="00"_LocSeqNo
	.If $L(LocSeqNo)=0 Set SeqNo="999"
	;.Set Doc=QueObj.QueDocDr
	.Set Doc=$P($g(^PAADM(PAAdmDR)),"^",9)
	.If Doc'="" Set PAAdmDocCodeDR=$P($g(^CTPCP(Doc,1)),"^",2)
	.Else  Set PAAdmDocCodeDR=""
	;.Set PAAdmPriority=QueObj.QueFirstDr.FirstcName
	;.Set PriorityCode=QueObj.QueFirstDr.FirstcCode
	.Set PAAdmPriority=""
	.Set PriorityCode=""

	.If PriorityCode="" Set PriorityCode="XX"
	.//
	.Set RegDocCode=""
	;.Set RegDocDr=QueObj.QueMarkDr
	.Set RegDocDr=""
	.If RegDocDr'="" Set RegDoctor=$P($g(^CTPCP(RegDocDr,1)),"^",2),RegDocCode=$P($g(^CTPCP(RegDocDr,1)),"^",1)
	.Else  Set RegDoctor=""
	.Set DHCRegDr=$O(^User.DHCRegistrationFeeI("ADM"," "_PAAdmDR,""))
	.Set DHCRegObj=##Class(User.DHCRegistrationFee).%OpenId(DHCRegDr)
	.If ($IsObject(DHCRegObj)) Set RBASDr=DHCRegObj.RegfeeRBASDr ;	.w "RBASDr:",$g(RBASDr),!
	.Quit:$g(RBASDr)=""
	.Set StartTime=+$P($G(^RBAS(+RBASDr,$P(RBASDr,"||",2))),"^",4)
	.s TRRowId=##class(web.DHCRBResSession).GetTimeRangeByTime(StartTime)
	.if TRRowId'="" s TRDesc=$P(^DHCTimeRange(TRRowId),"^",2)
	.Set RegDoctor=RegDoctor_"("_$g(TRDesc)_")"
	.//
	;.Set Called=QueObj.QueCompDr
	.Set Called=""
	;.Set WalkStatus=QueObj.QueStateDr.PersName
	.Set WalkStatus=""
	;.Set StatusCode=QueObj.QueStateDr.PersCode
	.Set StatusCode=""
	.If StatusCode="" Set StatusCode="XX"
	;.Set ConsultRoom=QueObj.QueRoomDr.ExarName
	.Set ConsultRoom=""
	;.Set ConsultArea=QueObj.QueExabDr.ExabName
	.Set ConsultArea=""
	;.Do QueObj.%Close()
	Else  Do
	.Set StatusCode="XX"
	.Set PriorityCode="XX"
	.Set SeqNo="999"
	.Set RegDocCode=""
	.Set Called=""
	.Set RegDocDr=""
	//
	
	Set Count=Count+1
	Set Seq=PriorityCode_StatusCode_RegDocCode_SeqNo
	set Data=$LB(PatientID,EpisodeID,mradm,PAPMINO,PAPMIName,PAPMIDOB,PAPMISex,PAAdmDate,PAAdmTime,PAAdmNo,PAAdmDepCodeDR,PAAdmDocCodeDR,PAAdmType,Hospital,PAAdmWard,PAAdmBed,FinancialDischargeFlag,MedicalDischargeFlag,FinalDischargeFlag,PAAdmReason,DischargeDate,RegDoctor,Diagnosis,ArrivedDate,ArrivedTime,LeavedDate,LeavedTime,LocSeqNo,PAAdmPriority,WalkStatus,ConsultRoom,ConsultArea,PAAdmReasonCode,StatusCode,PAPMIAge,PriorityCode,Called,RegDocDr)
	;w Count,":",Seq,!
	;b
 Set ^TMP("DHCDocWorkBench",$j,Seq,Count)=Data
	Quit
}

ClassMethod FindLocDocCurrentAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocDocCurrentAdmExecute ]
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
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// use in GetOrdItem ,override
ClassMethod GetArcimById(ArcimId As %String) As %String
{
	q:$g(ArcimId)="" ""
	s del="^"
	s ArcCode="",ArcDesc="",subcat="",drug="",startdate="",enddate="",Priority=""
	s ArcimId1=+$p(ArcimId,"||",1),ArcimId2=+$p(ArcimId,"||",2)
	q:'$d(^ARCIM(ArcimId1,ArcimId2)) ""
	s ArcCatCode=""
	s ArcCatCode=$p(^ARCIM(ArcimId1,ArcimId2,1),del,10)
	s ArcCatDR=""
	s ArcCatDR=+$o(^ARC("IC",0,"Code",ArcCatCode,0))
	s ArcICOrderType=""
	s ArcICOrderType=$p(^ARC("IC",ArcCatDR),"^",7)
	
	s Unit=""
	s ArcCode=$p(^ARCIM(ArcimId1,ArcimId2,1),del,1)
	s ArcDesc=$p(^ARCIM(ArcimId1,ArcimId2,1),del,2)
	s subcat=$p(^ARCIM(ArcimId1,ArcimId2,1	),del,10)
	s:subcat'="" subcat=$p(^ARC("IC",subcat),del,2)
	s UnitDr=$p(^ARCIM(ArcimId1,ArcimId2,1),del,14)
	s:$g(UnitDr)'="" Unit=$p(^CT("UOM",UnitDr),del,2)
	s drug=$p(^ARCIM(ArcimId1,ArcimId2,1),del,12)
	i $g(drug)'="" d
	.s drug1=$p(drug,"||",1),drug2=$p(drug,"||",2),drug=$p(^PHCD(drug1,drug2),del,2)
	s startdate=$P($p(^ARCIM(ArcimId1,ArcimId2,1),del,13),"Z",1)
	if $g(startdate)'="" s startdate=$zd(startdate,3)
	s enddate=$p(^ARCIM(ArcimId1,ArcimId2,7),del,1)
	if $g(enddate)'="" s enddate=$zd(enddate,3)
	q:(($g(stopflag)'="")&(enddate<$zd($h,3))) ""
	s Priority=$p(^ARCIM(ArcimId1,ArcimId2,8),del,22)
	IF $G(Priority)'="" S Priority=$p(^OECPR(Priority),del,2)
	s RetStr=ArcimId_del_ArcCode_del_ArcDesc_del_subcat_del_drug_del_startdate_del_enddate_del_Priority_del_Unit_del_ArcICOrderType
	q RetStr
}

/// use in FindLocDocCurrentAdmExecute:OutputAdmRow
ClassMethod GetMRAdmDiagnosis(MRAdm As %String) As %String
{
	 Quit:$g(MRAdm)="" ""
	 Set DiagStr=""
	 Set Diag=0
	 For  Set Diag=$O(^MR(MRAdm,"DIA",Diag)) Quit:(Diag="")!(DiagStr'="")  Do
	 .Set DiagID=$P($g(^MR(MRAdm,"DIA",Diag)),"^",1)
	 .Quit:$g(DiagID)=""
	 .Set DiagDesc=$P($g(^MRC("ID",DiagID)),"^",2)
	 .If DiagDesc["-" Set DiagDesc=$P(DiagDesc,"_",2)
	 .If DiagStr="" Set DiagStr=DiagDesc
	 .Else  Set DiagStr=DiagStr_","_DiagDesc
	 Quit DiagStr
}

ClassMethod GetOrdByAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrdByAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOrdByAdmExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", ModifyMode As %String = "") As %Status
{
	s RecLocDR=%session.Get("LOGON.CTLOCID")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if EpisodeID=""
	{
		Set qHandle=$lb(0,repid,0)
		k ^CacheTempFHQ(repid)
		quit $$$OK
	}
	s del="^"
	s RetNum=..GetOrdItem(repid,EpisodeID,"","",ModifyMode,RecLocDR)
	s i=0
	f  s i=$o(^CacheTempFHQ(repid,i)) q:i=""  d
	.s Data=^CacheTempFHQ(repid,i)
	.s ^CacheTemp(repid,ind)=Data
	.S ind=ind+1
	Set qHandle=$lb(0,repid,0)
	k ^CacheTempFHQ(repid)
	quit $$$OK
}

ClassMethod GetOrdByAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrdByAdmExecute ]
{
	 s Row= ##Class(web.DHCFBASICINFO).QueryFetch(qHandle,AtEnd)
	 Quit $$$OK
}

/// use in GetOrdByAdmExecute
ClassMethod GetOrdItem(ByRef repid As %Integer = 0, AdmId As %String = "", OrdCatSubId As %String = "", ArcId As %String = "", QueryMode As %String = "", RecLocDR As %String = "") As %Integer
{
	s:QueryMode="CC" QueryMode="C"
	s stopCode=$o(^OEC("OSTAT",0,"Code","D",0))
	s del="^",AdmType="",RetNum=0
	q:($g(AdmId)="") RetNum
	q:'$d(^OEORD(0,"Adm",AdmId)) RetNum
	s OrdId1=$o(^OEORD(0,"Adm",+AdmId,0))
	q:OrdId1="" RetNum
	s OrdId2=0
	s ii=0
	s OrdCreateDate="",OrdCreateTime="",OrdStartDate="",OrdStartTime="",ArcimDesc=""
	f  s OrdId2=$o(^OEORD(OrdId1,"I",OrdId2)) q:OrdId2=""  d
	.s ii=ii+1
	.s ordstr1=$g(^OEORD(OrdId1,"I",OrdId2,1))
	.s ordstr2=$g(^OEORD(OrdId1,"I",OrdId2,2))
	.s ordstr3=$g(^OEORD(OrdId1,"I",OrdId2,3))
	.s ordstr4=$g(^OEORD(OrdId1,"I",OrdId2,11))
	.s Billed=$p(ordstr3,del,5)
	.s ArcimId=$p(ordstr1,del,2)
	.s orditmRecLocDR=""
	.s oerow=OrdId1_"||"_OrdId2
	.s excutable=##class(web.DHCDocOrderCommon).CheckItemExcutable(AdmId,oerow,RecLocDR) ;s orditmRecLocDR=$p($p(orditmRecLocstr,$C(2),1),$C(1),1)
	.q:((QueryMode="C")&&(excutable=0)) //登录科室与接收科室的判别
	.q:((ArcId'="")&(ArcimId'=ArcId))
	.s ArcStr=##class(web.DHCBL.Doctor.HXGYDocExtra).GetArcimById(""_ArcimId)
	.q:ArcStr=""
	.s ArcType=""
	.s ArcType=$p(ArcStr,del,10)	
	.q:((QueryMode="C")&&(ArcType="R")) //确认医嘱功能过滤药品医嘱
	.s ArcimCode=$p(ArcStr,del,2),ArcimDesc=$p(ArcStr,del,3)
	.q:($Find(ArcimDesc,"挂号费")>0)
	.s OrdCreateDate=$p(ordstr3,del,7),OrdCreateDate=$zd(OrdCreateDate,3)
	.s OrdCreateTime=$p(ordstr1,del,17),OrdCreateTime=$zt(OrdCreateTime,2)
	.s OrdStartDate=$p(ordstr1,del,9),OrdStartDate=$zd(OrdStartDate,3)
	.s OrdStartTime=$p(ordstr1,del,10),OrdStartTime=$zt(OrdStartTime,2)
	.s DoseQty=$p(ordstr2,del,1),DoseUnit=$p(ordstr2,del,3)
	.s:DoseUnit'="" DoseUnit=$p(^CT("UOM",DoseUnit),del,2)
	.s Priority=$p(ordstr1,del,8)
	.s:$g(Priority)="" Priority=""
	.s:$g(Priority)'="" Priority=$p(^OECPR(Priority),del,2)
	.s PHFreq=$p(ordstr2,del,4)
	.s:$g(PHFreq)'="" PHFreq=$p(^PHCFR(PHFreq),del,1)
	.s:$g(PHFreq)="" PHFreq=""
	.s Instr=$p(ordstr2,del,7)
	.s:$g(Instr)'="" Instr=$p(^PHCIN(Instr),del,1)
	.s:$g(Instr)="" Instr=""
	.s OrdStatus=$p(ordstr1,del,13)
	.q:((stopCode=OrdStatus)&&(QueryMode="C"))
	.s:$g(OrdStatus)'="" OrdStatusCode=$p(^OEC("OSTAT",OrdStatus),del,1)
	.s:$g(OrdStatus)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatus),del,2)
	.s:$g(OrdStatus)="" OrdStatus=$g(OrdStatus)
	.s Dura=$p(ordstr2,del,6)
	.s:$g(Dura)'="" Dura=$p(^PHCDU(Dura),del,3)
	.s:$g(Dura)="" Dura=""
	.s doctor=$p(ordstr1,del,11)
	.s:$g(doctor)'="" doctor=$p(^CTPCP(doctor,1),del,2)
	.s:$g(doctor)="" doctor=""
	.s:ordstr4'="" myAdmType=$p(ordstr4,del,18)
	.s:myAdmType'="" AdmType=$p(^PAC("ADMREA",myAdmType),del,2)
	.s OrdItemDR=OrdId1_"^"_$p(ordstr1,"^",2)
	.s OrdItemRowId=OrdId1_"||"_OrdId2
	.s execCount=..getOrdItmExecCount(OrdItemRowId)
	.S RetNum=RetNum+1
	.S ^CacheTempFHQ(repid,RetNum)=$LB(OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,Priority,PHFreq,Instr,doctor,OrdStatus,Dura,AdmType,OrdItemDR,OrdItemRowId,Billed,execCount,OrdStatusCode) ;.;W OrdCreateDate,OrdCreateTime,OrdStartDate,OrdStartTime,ArcimDesc,DoseQty,DoseUnit,PHFreq,Instr,doctor,!
	q RetNum
}

ClassMethod GetPAAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPAAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPAAdmExecute(ByRef qHandle As %Binary, PAPerRowId As %String = "", CardNo As %String = "", StartDate As %String = "", EndDate As %String = "", saveLocation As %String = "", saveDoc As %String = "", RegNo As %String = "", EpisodeID As %String = "") As %Status
{
	s ^zTom("EpisodeID")=EpisodeID
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s PatName=""
	If (PAPerRowId="")
	{
		do GetPAPerRowId
	}
	
	If ((PAPerRowId="")&&(saveDoc'=""))
	{
		s PAPerRowId=saveDoc
		do GetADMByDoctor
	}
	elseif ((PAPerRowId="")&&(saveLocation'="")) 
	{
		do GetADMByLocation
	}
 elseif ((PAPerRowId="")&&(EpisodeID'="")) 
	{
		do GetADMByPAADMNo(EpisodeID)
	}
	else
	{
		do GetADMBySinglePAPer
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetADMByLocation
	s:StartDate="" StartDate=+$p($h,",",1)
	s:EndDate="" EndDate=+$p($h,",",2)
	s StartDate=0+StartDate
	s EndDate=0+EndDate
	s admDate=0
	s admDate=+$o(^PAADMi("PAADM_LocDateTime",saveLocation,admDate))
	While (admDate'=0)
	{
		If ((admDate'<StartDate)&&(admDate'>EndDate))
		{
			s admTime=0
			s admTime=+$o(^PAADMi("PAADM_LocDateTime",saveLocation,admDate,admTime))
			While (admTime'=0)
			{
				s PAADMNo=0
				s PAADMNo=+$o(^PAADMi("PAADM_LocDateTime",saveLocation,admDate,admTime,PAADMNo))
				While (PAADMNo'=0)
				{
					do GetADMByPAADMNo(PAADMNo)
					s PAADMNo=+$o(^PAADMi("PAADM_LocDateTime",saveLocation,admDate,admTime,PAADMNo))
				}
				s admTime=+$o(^PAADMi("PAADM_LocDateTime",saveLocation,admDate,admTime))
			}
		}
		s admDate=+$o(^PAADMi("PAADM_LocDateTime",saveLocation,admDate))
	}
	Quit
	
GetADMByDoctor
	s:StartDate="" StartDate=+$p($h,",",1)
	s:EndDate="" EndDate=+$p($h,",",2)
	s StartDate=0+StartDate
	s EndDate=0+EndDate
	s admDate=0
	s admDate=+$o(^PAADMi("PAADM_DocDateTime",saveDoc,admDate))
	While (admDate'=0)
	{
		If ((admDate'<StartDate)&&(admDate'>EndDate))
		{
			s admTime=0
			s admTime=+$o(^PAADMi("PAADM_DocDateTime",saveDoc,admDate,admTime))
			While (admTime'=0)
			{
				s PAADMNo=0
				s PAADMNo=+$o(^PAADMi("PAADM_DocDateTime",saveDoc,admDate,admTime,PAADMNo))
				While (PAADMNo'=0)
				{
					do GetADMByPAADMNo(PAADMNo)
					s PAADMNo=+$o(^PAADMi("PAADM_DocDateTime",saveDoc,admDate,admTime,PAADMNo))
				}
				s admTime=+$o(^PAADMi("PAADM_DocDateTime",saveDoc,admDate,admTime))
			}
		}
		s admDate=+$o(^PAADMi("PAADM_DocDateTime",saveDoc,admDate))
	}
	Quit
GetADMByPAADMNo(PAADMNo)
	s TPAAdmNo=$p(^PAADM(PAADMNo),"^",81)
	s PAPerRowId=$p(^PAADM(PAADMNo),"^",1)
	s:PAPerRowId'="" PatName=$p(^PAPER(PAPerRowId,"ALL"),"^",1)
	s TPatientID=PAPerRowId
	s EpisodeDR=$o(^OEORD(0,"Adm",PAADMNo,0))
	s TRegNo=PAADMNo
	s TEpisodeId=PAADMNo
	s admDate=+$p(^PAADM(PAADMNo),"^",6)
	s sDate=$p($h,",",1)
	s eDate=$p($h,",",1)
	s:StartDate'="" sDate=StartDate
	s:EndDate'="" eDate=EndDate
	s TAdmDate=$zd($p(^PAADM(PAADMNo),"^",6),3)
	s TAdmTime=$zt($p(^PAADM(PAADMNo),"^",7),2)
	
	s tLocDR=$p(^PAADM(PAADMNo),"^",4)
	s TLocDesc=$p(^CTLOC(tLocDR),"^",2)
		s tPCPDR=$p(^PAADM(PAADMNo),"^",9)
	s TPcpName=$p(^CTPCP(tPCPDR,1),"^",2)
		s tVisitStatusDR=$p(^PAADM(PAADMNo),"^",20)
	s TVisitStatus=tVisitStatusDR
		s tAdmTypeDr=$p(^PAADM(PAADMNo),"^",2)
	s TAdmType=tAdmTypeDr
	s TPatName=PatName
	s:$p(^PAADM(PAADMNo),"^",17)'="" TDisDate=$zd($p(^PAADM(PAADMNo),"^",17),3)
	s:$p(^PAADM(PAADMNo),"^",18)'="" TDisTime=$zt($p(^PAADM(PAADMNo),"^",18),2)
		s tRefDocDr=$p(^PAADM(PAADMNo),"^",15)
	s:tRefDocDr'="" TRefDocDesc=$p(^CTPCP(tRefDocDr,1),"^",2)
	if ((saveLocation="")||((tLocDR=saveLocation)&&(saveLocation'="")))
	{
		if ((admDate'<sDate)&&(admDate'>eDate))
		{
			set Data=$ListBuild(TEpisodeId,TRegNo,TAdmDate,TAdmTime,TLocDesc,TPcpName,TVisitStatus,TAdmType,TDisDate,TDisTime,TRefDocDesc,TPatName,TPatientID,TPAAdmNo)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}

	Quit

GetADMBySinglePAPer
	s:PAPerRowId'="" PatName=$p(^PAPER(PAPerRowId,"ALL"),"^",1)
	s res=##class(%Library.ResultSet).%New("web.PAAdm:FindEpisodeWithPayor")
	do res.Execute("","",PAPerRowId,"","","","","","","")
	while (res.Next())
	{
		s TPatientID=PAPerRowId
		s TPAAdmNo=res.Data("PAADMADMNo")
		s TRegNo=res.Data("EpisodeID")
		s TEpisodeId=res.Data("EpisodeID")
		s admDate=+res.Data("PAADMAdmDate")
		s sDate=$p($h,",",1)
		s eDate=$p($h,",",1)
		s:StartDate'="" sDate=StartDate
		s:EndDate'="" eDate=EndDate
		s TAdmDate=$zd(res.Data("PAADMAdmDate"),3)
		s TAdmTime=$zt(res.Data("PAADMAdmTime"),2)
		s TLocDesc=res.Data("CTLOCDesc")
		s tLocDR=$o(^CTLOC(0,"Desc",TLocDesc,0))
			s tPcpDR=res.Data("CTPCPCode")
		s TPcpName=res.Data("CTPCPDesc")
		s TVisitStatus=res.Data("PAADMVisitStatus")
		s TAdmType=res.Data("PAADMType")
		s TPatName=PatName
		s:res.Data("PAADMDischgDate")'="" TDisDate=$zd(res.Data("PAADMDischgDate"),3)
		s:res.Data("PAADMDischgTime")'="" TDisTime=$zt(res.Data("PAADMDischgTime"),2)
		s TRefDocDesc=res.Data("REFTDesc")

		if ((admDate'<sDate)&&(admDate'>eDate))
		{
			set Data=$ListBuild(TEpisodeId,TRegNo,TAdmDate,TAdmTime,TLocDesc,TPcpName,TVisitStatus,TAdmType,TDisDate,TDisTime,TRefDocDesc,TPatName,TPatientID,TPAAdmNo)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit

GetPAPerRowId
	s PAPerRowId=""
	i CardNo=""
	{
		i RegNo'=""
		{
			s iPAPMINo=RegNo
			s iPAPMIDR = $o(^PAPERi("PAPMI_PatNo",iPAPMINo,0))
			s PAPerRowId=iPAPMIDR
		}
	}
	else
	{
		s res2=##class(%Library.ResultSet).%New("web.DHCBL.Doctor.HXGYDocExtra:GetPerson")
		do res2.Execute(CardNo)
		s PAPerCount=0
		while (res2.Next())
		{
			s PAPerRowId=res2.Data("TPAPerRowId")
			s PAPerCount=PAPerCount+1
		}
		If (PAPerCount'=1)
		{
			s PAPerRowId=""
		}
	}
	Quit
}

ClassMethod GetPAAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPAAdmExecute ]
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

ClassMethod GetPersonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPersonExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPersonExecute(ByRef qHandle As %Binary, CardNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	if (CardNo'=""){
		s TPAPerRowId=""
		s TName=""
		s TRegNo=""
		s TBirthday=""
		s TAge=""
		s TBirthday=""
		s TGender=""
		s TAddress=""
		s TCity=""
		s TPostNo=""

		s CardID=""
		s CardID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardID))
		s myCardID=""
		while (CardID'="")
		{
			s CardStatus=$p(^DHCCARD("CF",CardID),"^",10)
			i CardStatus="N"
			{
				s myCardID=CardID
			}
			s CardID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardID))
		}
		s CardID=myCardID
		if (CardID'="")
		{
			s PersonRowId=$p(^DHCCARD("CF",CardID),"^",4)
			if (PersonRowId'="")
			{
				s TPAPerRowId=PersonRowId
				s TName=$p(^PAPER(PersonRowId,"ALL"),"^",1)
				s TRegNo=$p(^PAPER(PersonRowId,"PAT",1),"^",1)
				s TBirthday=$p(^PAPER(PersonRowId,"ALL"),"^",6)
				s TAge=($p($h,",",1)-TBirthday)\365.5
				s TBirthday=$zd(TBirthday,3)
				s TGender=$p(^CT("SEX",$p(^PAPER(PersonRowId,"ALL"),"^",7)),"^",2)
				s TAddress=^PAPER(TPAPerRowId,"PER","ADD",1)
				s tCityDR=""
				s:$g(^PAPER(TPAPerRowId,"PER",4))'="" tCityDR=$p(^PAPER(TPAPerRowId,"PER",4),"^",9)
				s:tCityDR'="" TCity=$p($p(^CT("CITAREA",tCityDR),"^",2),"-",2)
				
				s TPostNo=""
				s:$g(^PAPER(TPAPerRowId,"PER",2))'="" TPostNo=$p(^PAPER(TPAPerRowId,"PER",2),"^",8)

				set Data=$ListBuild(TPAPerRowId,TName,TRegNo,TBirthday,TAge,TGender,TAddress,TCity,TPostNo) ;$ListBuild(Name,IDCardNo,CardNO,ActivedFlag,ID,CardTypeDesc,myCredNo,myCredTypeDesc)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
			//s CardID=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardID))
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetPersonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPersonExecute ]
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

/// 队列状态转换
ClassMethod GetQueStatus(JSFunName As %String = "", ListName As %String = "") As %String
{
	s myBMRowid=0
	s mydes=""
	s myval=""
	s mySelFlag=0
	s myIdx=0
	f  s myBMRowid=$o(^User.DHCPerStateD(myBMRowid)) q:(myBMRowid="")  d
	.s mydes=$ListGet(^User.DHCPerStateD(myBMRowid), 4)
	.s myval=myBMRowid
	.s myval=myval_"^"_$ListGet(^User.DHCPerStateD(myBMRowid), 2)
	.i mydes="等候" d 
	..s mySelFlag=1
	.e  d
	..s mySelFlag=0
	.s rtnval=JSFunName_"('"_ListName_"','"_$ZCVT($g(mydes),"O","JS")_"','"_$ZCVT($g(myval),"O","JS")_"','"_$ZCVT($g(myIdx),"O","JS")
	.s rtnval=rtnval_"','"_$ZCVT(mySelFlag,"O","JS")_"');"
	.&javascript<#(rtnval)#>
	.s myIdx=myIdx+1
	q 0
}

/// 修改医嘱项费别
ClassMethod ModifyOrderItem(OrdItemList As %String, ToStatus As %String, ModifyUser As %String) As %String
{
	s retStr="0"
	q:OrdItemList="" "-1"
	q:ToStatus="" "-2"
	q:ModifyUser="" "-3"
	
	//判断权限
	s retCode=0
	for i=1:1:$l(OrdItemList,",")
	{
		s modiId=$p(OrdItemList,",",i)
		s modiParRowId=$p(modiId,"^",1)
		s modiRowId=$p(modiId,"^",2)
		if ((modiParRowId'="")&&(modiRowId'=""))
		{
			&sql(Update sqluser.OE_OrdItem set OEORI_BBExtCode=:ToStatus where OEORI_ItmMast_DR=:modiRowId and OEORI_OEORD_ParRef=:modiParRowId )
			s retCode=retCode+SQLCODE
		}
	}
	s retStr=retStr+retCode
	q retStr
}

/// 执行医嘱
ClassMethod UpdateOrdItmExec(execString As %String) As %String
{
	s checkResult=..CheckOrdItmExec(execString,"E")
	q:checkResult'="0" checkResult
	
	s retCode=0
	s userID=%session.Get("LOGON.USERID")
	for i=1:1:$Length(execString,",")
	{
		s orditmexecdr=$p(execString,",",i)
		i orditmexecdr'=""
		{
			s rt=##class(web.DHCOEOrdItem).UpdateExec(orditmexecdr,userID)
			s retCode=retCode+rt
		}
	}
	q retCode
}

/// 在病人列表中增加状态筛选标签
ClassMethod WriteStatusList()
{
	w "<input type='button' id='filterbtn0' onclick='StatusListClick("""")' value='所有'>    "
	for i=1:1:^User.DHCPerStateD
	{
		if (i=1)||(i=2)||(i=4) ;只显示"复诊","等候","到达"
		{
			w "<input type='button' id='filterbtn"_i_"' onclick='StatusListClick("""_$ListGet(^User.DHCPerStateD(i), 2)_""")' value='"_$ListGet(^User.DHCPerStateD(i), 4)_"'>    "
		}
	}
}

/// use in GetOrdItem
ClassMethod getOrdItmExecCount(orditm As %String) As %String
{
	q:orditm="" 0
	s execDR=0
	s execCount=0
	s OrdId1=+$p(orditm,"||",1)
	s OrdId2=+$p(orditm,"||",2)
	q:OrdId1+OrdId2=0 0
	s execDR=+$o(^OEORD(OrdId1,"I",OrdId2,"X",execDR))
	While (+execDR'=0)
	{
		s execTime=""
		s execstr=$g(^OEORD(OrdId1,"I",OrdId2,"X",execDR))
		s:execstr'="" execTime=$p(execstr,"^",20)
		s execCount=execCount+1
		s execDR=+$o(^OEORD(OrdId1,"I",OrdId2,"X",execDR))
	}
	q execCount
}

Query FindLocDocCurrentAdm(LocID As %String = "", UserID As %String = "", IPAddress As %String = "", AllPatient As %String = "", PatientNo As %String = "", SurName As %String = "", StartDate As %Date = "", EndDate As %Date = "", ArrivedQue As %String = "", RegQue As %String = "") As %Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,mradm:%String,PAPMINO:%String,PAPMIName:%String,PAPMIDOB:%String,PAPMISex:%String,PAAdmDate:%Date,PAAdmTime:%Time,PAAdmNo:%String,PAAdmDepCodeDR:%String,PAAdmDocCodeDR:%String,PAAdmType:%String,Hospital:%String,PAAdmWard:%String,PAAdmBed:%String,FinancialDischargeFlag:%String,MedicalDischargeFlag:%String,FinalDischargeFlag:%String,PAAdmReason:%String,DischargeDate:%String,RegDoctor:%String,Diagnosis:%String,ArrivedDate:%String,ArrivedTime:%String,LeavedDate:%String,LeavedTime:%String,LocSeqNo:%String,PAAdmPriority:%String,WalkStatus:%String,ConsultRoom:%String,ConsultArea:%String,PAAdmReasonCode:%String,StatusCode:%String,Age:%String,PriorityCode:%String,Called:%String,RegDocDr:%String")
{
}

/// override
Query GetOrdByAdm(EpisodeID As %String = "", ModifyMode As %String = "") As %Query(ROWSPEC = "OrdCreateDate:%String,OrdCreateTime:%String,OrdStartDate:%String,OrdStartTime:%String,ArcimDesc:%String,DoseQty:%String,DoseUnit:%String,Priority:%String,PHFreq:%String,Instr:%String,Doctor:%String,OrdStatus:%String,Dura,AdmType:%String,OrdItemDR:%String,OrdItemRowId:%String,Billed:%String,execCount:%String,OrdStatusCode:%String")
{
}

Query GetPAAdm(PAPerRowId As %String = "", CardNo As %String = "", StartDate As %String = "", EndDate As %String = "", saveLocation As %String = "", saveDoc As %String = "", RegNo As %String = "", EpisodeID As %String = "") As %Query(ROWSPEC = "TEpisodeId:%String,TRegNo:%String,TAdmDate:%String,TAdmTime:%String,TDocDesc:%String,TPcpName:%String,TVisitStatus:%String,TAdmType:%String,TDisDate:%String,TDisTime:%String,TRefDocDesc:%String,TPatName:%String,TPatientID:%String,TPAAdmNo:%String")
{
}

/// Use By GetPAADM:GetPAPerRowId
Query GetPerson(CardNo As %String = "") As %Query(ROWSPEC = "TPAPerRowId:%String,TName:%String,TRegNo:%String,TBirthday:%String,TAge:%String,TGender:%String,TAddress:%String,TCity:%String,TPostNo:%String")
{
}

}
