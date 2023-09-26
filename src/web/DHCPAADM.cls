Class web.DHCPAADM Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod ADMInsert(Para As %String) As %String [ ProcedureBlock = 0 ]
{
	;PatientID,AdmType,AdmDate,AdmTime,AdmDep,AdmDoc,AdmReason,CreateUser
	;warddr,roomdr,beddr_"^"_episdr_"^"_admqkdr
	s ^zhou("Para1")=Para
	;s Para=^zhou("Para1")
	s PatientID=$P(Para,"^",1)
	s AdmType=$P(Para,"^",2)
	s AdmDate=$P(Para,"^",3)
	s AdmTime=$P(Para,"^",4)
	s AdmDep=$P(Para,"^",5)
	s AdmDoc=$P(Para,"^",6)
	s AdmReason=$P(Para,"^",7)
	s CreateUser=$P(Para,"^",8)
	s AdmWard=$P(Para,"^",9)
	s AdmRoom=$P(Para,"^",10)
	s AdmBed=$P(Para,"^",11)
	s Epissubtype=$P(Para,"^",12)
	s AdmCate=$P(Para,"^",13)
	s AdmRefDocListDR=$P(Para,"^",14)
	s AdmDiagnosCatRowId=$P(Para,"^",15)
	
	s AdmInPatNo=$P(Para,"^",17)
	s AdmSrcDr=$P(Para,"^",18)   //病人来源PAADMAdmSrcDR / PAADM_AdmSrc_DR
	s FirstOrReadmis=$P(Para,"^",19)
	s InsuCoRowid=$P(Para,"^",20)
	s RegConDisId=$P(Para,"^",21)
	s ReferralPriorityId=$P(Para,"^",22)
	s AccompanyName=$P(Para,"^",23)
	s AccompanySex=$P(Para,"^",24)
	s AccompanyDob=$P(Para,"^",25)
	s AccompanyCredType=$P(Para,"^",26)
	s AccompanyCredNo=$P(Para,"^",27)
	s AccompanyTelPhone=$P(Para,"^",28)
	s RegType=$P(Para,"^",29)
	s RegCardTypeID=$P(Para,"^",30)
	s RegCardNo=$P(Para,"^",31)
	if FirstOrReadmis=""{
		//s FirstOrReadmis="F"
		s FirstOrReadmis="" //此处已做配置 默认为空 不在F 初诊
		;s ReAdmFlag=..GetReAdmFlag(PatientID,AdmDep)
        s GetReAdmParams=##class(%ArrayOfDataTypes).%New()
        d GetReAdmParams.SetAt(PatientID,"PatientID")
        d GetReAdmParams.SetAt(AdmDep,"LocID")
        s ReAdmFlag=##class(DHCDoc.DHCDocConfig.ReAdmRules).GetReAdmFlag(GetReAdmParams)
		if ReAdmFlag=1 s FirstOrReadmis="R"
	}
	s PAADMAdmReadm=""
	s PAADMReadmToRehabDR=""
	if FirstOrReadmis="R" {
		s PAADMAdmReadm="R"
		//默认门诊复诊 id为4
		s PAADMReadmToRehabDR=4
	}
	if (AdmReason=""){
		s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
		s AdmReason=..GetDefaultBillType(PatCatDr)
	}

	Set PatientName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	Set ADMNo=..CompADMNo(AdmType) 
	Set VisitStatus="A"
	s object=##class(User.PAAdm).%New()
	d object.PAADMPAPMIDRSetObjectId(PatientID)
	d object.PAADMDepCodeDRSetObjectId(AdmDep)
	d object.PAADMAdmDocCodeDRSetObjectId(AdmDoc)
	s object.PAADMAdmDate=AdmDate
	s object.PAADMAdmTime=AdmTime
	s object.PAADMType=AdmType
	s object.PAADMVisitStatus=VisitStatus
	s object.PAADMCreateDate=..%SysDate()
	s object.PAADMCreateTime=..%SysTime()
	d object.PAADMCreateUserSetObjectId(CreateUser)
	s object.PAADMShowInFutureEpisode="Y"
	s object.PAADMConfidential="N"
	s object.PAADMPreAdmitted="N"
	s object.PAADMIsolate="N"
	s object.PAADMCurrent="Y"
	s object.PAADMVerified="N"
	d object.PAADMAdmReasonDRSetObjectId(AdmReason)
	s object.PAADMADMNo=ADMNo
	d object.PAADMCurrentWardDRSetObjectId(AdmWard)
	d object.PAADMCurrentRoomDRSetObjectId(AdmRoom)
	d object.PAADMCurrentBedDRSetObjectId(AdmBed)
	d object.PAADMEpissubtypeDRSetObjectId(Epissubtype)
	d object.PAADMRefDocListDRSetObjectId(AdmRefDocListDR)
	d object.PAADMAdmCategDRSetObjectId(AdmCate)
	; BI\综合查询统一数据源之后，统一使用UpdateDate抽取就诊数据
	s object.PAADMUpdateDate=..%SysDate()
	s object.PAADMUpdateTime=..%SysTime()
	d object.PAADMUpdateUserDRSetObjectId(CreateUser)
	s object.PAADMPreAdmitDate=AdmDate
	s object.PAADMPreAdmitTime=AdmTime
	s object.PAADMBillFlag="N"
	s object.PAADMSpecialDocument="N"
	s object.PAADMCompleted="N"
	s object.PAADMRequestMR="N"
	s object.PAADMFrequentAdmissions="N"
	s object.PAADMEstDischConfirmed="N"
	s object.PAADMRelated="N"
	s object.PAADMViewablebyEpCareProv="N"
	s object.PAADMInPatNo=AdmInPatNo
	d object.PAADMAdmSrcDRSetObjectId(AdmSrcDr)
	s object.PAADMFirstOrReadmis=FirstOrReadmis
	d:PAADMReadmToRehabDR'="" object.PAADMReadmToRehabDRSetObjectId(PAADMReadmToRehabDR)
	s object.PAADMAdmReadm=PAADMAdmReadm

	;参考MVBPAADM.INT
	i AdmType="E" s object.PAADMEmergencyStatus="Q"
	i VisitStatus="P" s object.PAADMPreAdmitted="Y"
	;Insert PA_Process
	i " A "[(" "_$p($g(VisitStatus),$c(1))_" ") {
		s ProcessDR=..ProcessInsert($g(PatientID),"")
		d object.PAADMCurrentProcessDRSetObjectId(ProcessDR)
	}
	;s object.PAADMTypeofPatientCalc=""
	i ReferralPriorityId'="" {
		d object.PAADMReferralPriorityDRSetObjectId(ReferralPriorityId)
	}
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		;Do $System.Status.DisplayError()
		Q ""
	}
	s PAADMRowId=object.%Id()
	
	s objectExt=##class(User.PAAdmExt).%OpenId(PAADMRowId)
	d objectExt.PAADMDiagnosCatDRSetObjectId(AdmDiagnosCatRowId)
	d objectExt.PAADMRegConDisDRSetObjectId(RegConDisId)
	s objectExt.PAADMAccompanyName=AccompanyName
	if AccompanySex'="" d objectExt.PAADMAccompanySexSetObjectId(AccompanySex)
	s objectExt.PAADMAccompanyDob=AccompanyDob
	if AccompanySex'="" d objectExt.PAADMAccompanyCredTypeSetObjectId(AccompanyCredType)
	s objectExt.PAADMAccompanyCredNo=AccompanyCredNo
	s objectExt.PAADMAccompanyTelPhone=AccompanyTelPhone
	d:RegType'="" objectExt.PAADMBregTypeSetObjectId(RegType)
	d:RegCardTypeID'="" objectExt.PAADMRegCardTypeDRSetObjectId(RegCardTypeID)
	s:RegCardNo'="" objectExt.PAADMRegCardNo=RegCardNo
	Set sc = objectExt.%Save()
	If $$$ISERR(sc) {
		;Do $System.Status.DisplayError()
		Q ""
	}
	
	//update PA_ADM2
	s object1=##class(User.PAAdm2).%OpenId(PAADMRowId)
	s object1.PAADM2Name=PatientName
	Set sc = object1.%Save()
	If $$$ISERR(sc) {
		;Do $System.Status.DisplayError()
		Q ""
	}
	d object1.%Close()
	
	;insert MR_ADM
	s object1=##class(User.MRAdm).%New()
	d object1.MRADMADMDRSetObjectId(PAADMRowId)
	Set sc = object1.%Save()
	If $$$ISERR(sc) {
		;Do $System.Status.DisplayError()
		Q ""
	}
	d object1.%Close()
	
	//update PA_ADM.PAADM-MainMRADMDR
	s MRADMRowId=object1.%Id()
	d object.PAADMMainMRADMDRSetObjectId(MRADMRowId)
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		Tro
		;Do $System.Status.DisplayError()
		Q ""
	}
	Q PAADMRowId
	/*
	s PaInrowid=EpisodeID_"||"_"1"
	&SQL(Insert into SQLUser.PA_AdmInsurance
	(INS_RowId,INS_ParRef,INS_Childsub,INS_InsType_DR,
	INS_CardholderName,INS_AuxInsType_DR,INS_DateTypeFrom,INS_MainInsuranceFlag)
	Values(:PaInrowid,:refrowid,"1","28",:name,"4",:AdmDate,"Y"))
	if SQLCODE {	 		
		TRollback
		Q "-204"
	}
	*/ 
	i InsuCoRowid'=""{
		&SQL(Insert into SQLUser.PA_AdmInsurance
		(INS_ParRef,INS_InsType_DR,INS_UpdateDate,INS_UpdateTime,INS_UpdateUser_DR)
		values(:PAADMRowId,:InsuCoRowid,:AdmDate,:AdmTime,:CreateUser))
		if SQLCODE {	 		
			TRollback
			Q "-204"
		}
	}
	Q EpisodeID
}

ClassMethod ChangeAdm(AdmRowId As %String, NewPatientID As %String) As %String
{
	&SQL(Update SQLUser.PA_Adm Set PAADM_PAPMI_Dr=:NewPatientID Where PAADM_RowId=:AdmRowId)
	Q SQLCODE
}

/// Computed Value for field number PAADMN_No
ClassMethod CompADMNo(TYPE As %String) As %String
{
	 S TYPE=$P($G(TYPE),$C(1))
	 ;if they pass something wrong instead of type
	 i " I E O H "'[(" "_TYPE_" ") s TYPE="O"
	 f j=1:1:9 s patcf(j)=$g(^CF("PATCF",1,j))
	 i TYPE="I" D
	 .s pref=$p(patcf(1),"^",17),suf=$p(patcf(1),"^",18),len=$p(patcf(3),"^",3)
	 i TYPE="E" D
	 .s pref=$p(patcf(1),"^",13),suf=$p(patcf(1),"^",14),len=$p(patcf(3),"^",1)
	 i " O "[TYPE D
	 .s pref=$p(patcf(1),"^",23),suf=$p(patcf(1),"^",24),len=$p(patcf(3),"^",4)
	 i " H "[TYPE D
	 .;s pref=$p(patcf(8),"^",12),suf=$p(patcf(8),"^",13),len=$p(patcf(8),"^",14)
	 .s pref=$p(patcf(9),"^",3),suf=$p(patcf(9),"^",4),len=$p(patcf(9),"^",15)
	 s:'len len=10
nx 
	 s cnt=$zincr(^PAADM(0,"CNT",TYPE))
	 i $length(cnt)>len s len=$length(cnt)
	 s num=pref_..LPAD(cnt,"0",len)_suf
	 i num'="",$d(^PAADMi("No",$ZCVT(num,"U"))) s err=$$znum(num) g nx
	 q num
znum(num) ;set trap
	 ;n i
	 s i=$zincr(^znum(0)),^znum(i)=$g(num)_"^"_$h
	 q 0
}

ClassMethod GetDefaultBillType(PatCatDr As %String)
{
	s AdmReason=""
	i PatCatDr'="" set DHCPACADMDr=$o(^DHCPACADM(0,"Social",PatCatDr,""))
	i $g(DHCPACADMDr)'="" set AdmReason=$p(^DHCPACADM(DHCPACADMDr),"^",2)
	Q AdmReason
}

ClassMethod GetMRAdmID(AdmRowId As %String) As %String
{
	s MRAdmID=$p($g(^PAADM(AdmRowId)),"^",61)
	Q MRAdmID
}

ClassMethod LPAD(STRING, SUB, LENGTH) As %String
{
	 ;N RES
	 q:'$g(LENGTH) ""
	 i '$g(LENGTH) s LENGTH=6
	 S $P(RES,SUB,LENGTH)=SUB
	 Q $E(RES,1,LENGTH-$L(STRING))_$E(STRING,1,LENGTH)
}

ClassMethod ProcessInsert(pat, proc) As %String
{
	 ;insert patient process
	 q:proc proc
	 ;check configuration
	 i $p($g(^CF("PATCF",1,5)),"^",6)'["Y" q ""
	 k PLIST
	 s PLIST(2)=pat,PLIST(7)=..%SysDate(),PLIST(5)="N",PLIST(4)="O"
	 s PLIST(6)=$$Counter()
	 &SQL(Insert into SQLUser.PA_Process Values :PLIST())
	 ;s err=$$insert^MVBPAPRC()
	 q $g(%ROWID)
Counter()  ; Next sequence number
	 ;n No,Prefix,Suffix,Length 
	 ; 
	 s Suffix=$p($g(^CF("PATCF",1,5)),"^",9)
	 s Prefix=$p($g(^CF("PATCF",1,5)),"^",8)
	 s Length=$p($g(^CF("PATCF",1,5)),"^",10)
	 s:'Length Length=8
	 ;s No=+$$NEXT("^PAPER(0,""CNT"",""PROC"")")
	 s No=+$i(^PAPER(0,"CNT","PROC"))
	 q Prefix_..LPAD(No,"0",Length)_Suffix
}

/// 在表PAC_AdmSource中获得srcDesc,srcRowid
Query GetAdmSource() As %SQLQuery(CONTAINID = 1, ROWSPEC = "TsrcDesc:%String,TsrcRowid:%Integer")
{
	select ADSOU_Desc,ADSOU_RowId from SQLUser.PAC_AdmSource
}

/// w ##class(web.DHCPAADM).CurrAdm(2)
ClassMethod CurrAdm(adm As %String) As %String
{
	q:adm="" ""
	s papmi=$P(^PAADM(adm),"^",1)
	q:papmi="" ""
 	&SQL(Select PAADM_RowId into :curradm From SQLUser.PA_Adm Where PAADM_PAPMI_DR=:papmi And PAADM_Current='Y')
	i SQLCODE=0 Q curradm
	Q ""
}

}
