/// 在住院预约中建立PAADM纪录
/// 创建人：李阳
Class web.DHCMedIPBookAdmCtl Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 通过设置生成Paadm纪录
ClassMethod CreateAdm(Para)
{
	
	set Hospital = ##class(web.DHCMedBase01).GetDefaultHosp()
	set HospitalCode = $p(Hospital, "/", 4)
	set retAdm = ""
	set:HospitalCode="BeiJing_YY" retAdm = ..ADMInsertYY(Para)
	set:HospitalCode="ChengDu_HX" retAdm = ..ADMInsertYY(Para) // 这里把ADMInsertYY改为华西医院生成Paadm的函数  ..表示在当前类中，当然你也可以指定另外一个文件里的函数
	
	quit retAdm
}

/// 友谊医院的生成Paadm
ClassMethod ADMInsertYY(Para As %String) As %String [ ProcedureBlock = 0 ]
{
	;PatientID,AdmType,AdmDate,AdmTime,AdmDep,AdmDoc,AdmReason,CreateUser
	;warddr,roomdr,beddr_"^"_episdr_"^"_admqkdr
	;s ^zhou("Para1")=Para
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
	if (AdmReason=""){
		s PatCatDr=$p(^PAPER(PatientID,"PER",1),"^",10)
		s AdmReason=..GetDefaultBillType(PatCatDr)
	}

	Set PatientName=$p(^PAPER(PatientID,"ALL"),"^",1)
	Set ADMNo=..CompADMNo(AdmType) 
	Set VisitStatus="P"  //预接诊
	s object=##class(User.PAAdm).%New()
	d object.PAADMPAPMIDRSetObjectId(PatientID)
	d object.PAADMDepCodeDRSetObjectId(AdmDep)
	d object.PAADMAdmDocCodeDRSetObjectId(AdmDoc)
	s object.PAADMAdmDate=AdmDate
	s object.PAADMAdmTime=AdmTime
	s object.PAADMType=AdmType
	s object.PAADMVisitStatus=VisitStatus
	s object.PAADMCreateDate=+$H
	s object.PAADMCreateTime=$P($H,",",2)
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
	;s object.PAADMUpdateDate=+$H
	;s object.PAADMUpdateTime=$P($H,",",2)
	;d object.PAADMUpdateUserDRSetObjectId(CreateUser)
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

	;参考MVBPAADM.INT
	i AdmType="E" s object.PAADMEmergencyStatus="Q"
	i VisitStatus="P" s object.PAADMPreAdmitted="Y"
	;Insert PA_Process
	i " A "[(" "_$p($g(VisitStatus),$c(1))_" ") {
		s ProcessDR=..ProcessInsert($g(PatientID),"")
		d object.PAADMCurrentProcessDRSetObjectId(ProcessDR)
	}
	;s object.PAADMTypeofPatientCalc=""
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Q ""
	}
	s PAADMRowId=object.%Id()
	;特病类别
	i AdmDiagnosCatRowId'="" {
		s $P(^PAADM(PAADMRowId,"DHC"),"^",3)=AdmDiagnosCatRowId
	}
	
	//update PA_ADM2
	s object1=##class(User.PAAdm2).%OpenId(PAADMRowId)
	s object1.PAADM2Name=PatientName
	Set sc = object1.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Q ""
	}
	d object1.%Close()
	
	;insert MR_ADM
	s object1=##class(User.MRAdm).%New()
	d object1.MRADMADMDRSetObjectId(PAADMRowId)
	Set sc = object1.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		Q ""
	}
	d object1.%Close()
	
	//update PA_ADM.PAADM-MainMRADMDR
	s MRADMRowId=object1.%Id()
	d object.PAADMMainMRADMDRSetObjectId(MRADMRowId)
	Set sc = object.%Save()
	If $$$ISERR(sc) {
		Tro
		Do $System.Status.DisplayError()
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
	 s:'len len=6
nx 
	 s cnt=$zincr(^PAADM(0,"CNT",TYPE))
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
	 s PLIST(2)=pat,PLIST(7)=+$h,PLIST(5)="N",PLIST(4)="O"
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

Storage StorageSQL
{
<Type>%Storage.SQL</Type>
}

}
