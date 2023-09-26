Import SQLUser

/// 疾病统计
Class web.DHCPE.Report.IllnessStatistic Extends %Library.RegisteredObject [ ClassType = "" ]
{

Parameter BUILD = 166;

/// 疾病统计
/// 查询类型：QueryType
/// 		QueryType 当 患者"^2256^"," "," "," 62068"," "," "
/// d ##Class(%ResultSet).RunQuery("web.DHCPE.Report.IllnessStatistic","IllnessStatistic","^2256^","","","62075","","")
Query IllnessStatistic(EDIDs As %Library.String = "", PatName As %Library.String = "", RegNo As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", QueryType As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", SexDR As %Library.String = "") As %Query(ROWSPEC = "ED_RowId:%String, ED_DiagnoseConclus:%String, PAADM_RowId:%String, PAPMI_IPNo:%String, PAPMI_Name:%String, PAPMI_Sex_DR_Name:%String, PAPMI_DOB:%String,IAge:%String,TTel:%String")
{
}

ClassMethod IllnessStatisticExecute(ByRef qHandle As %Binary, EDIDs As %Library.String = "", PatName As %Library.String = "", RegNo As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "", QueryType As %Library.String = "", AgeFrom As %Library.String = "", AgeTo As %Library.String = "", SexDR As %Library.String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	s User=%session.Get("LOGON.USERID")
 	k ^DHCPETMPIllness(User,"Illness")

	k ^DHCPETMPIS
	s ^DHCPETMPIS("IllnessStatistic")=""""_EDIDs_""","" "_PatName_""","" "_RegNo_""","" "_DateFrom_""","" "_DateTo_""","" "_QueryType_""""
	i ""=EDIDs {
 		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i DateFrom'=""  s DateFrom=##class(websys.Conversions).DateHtmlToLogical(DateFrom)
 	i DateTo'=""   s DateTo=##class(websys.Conversions).DateHtmlToLogical(DateTo)
 	
	i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s:("on"=QueryType) QueryType="A"	// And
 	s:(""=QueryType) QueryType="O"		// Or
 	s DateBegin=DateFrom
 	s DateEnd=DateTo
    
    // 按到达时间统计
 	s:(0'=+DateBegin) DateBegin=$O(^DHCPEIADM(0,"AdmDateTime",DateBegin),-1)
 	
 	// DHC_PE_IADM.{ IADM_AdmDate }
	s IADMAdmDate=+DateBegin
	f  s IADMAdmDate=$O(^DHCPEIADM(0, "AdmDateTime", IADMAdmDate)) q:((""'=DateEnd)&(IADMAdmDate>+DateEnd)||(""=IADMAdmDate))  d
	.
	.// DHC_PE_IADM.{ IADM_AdmTime }
	.s IADMAdmTime=0
	.f  s IADMAdmTime=$O(^DHCPEIADM(0, "AdmDateTime", IADMAdmDate, IADMAdmTime)) q:(""=IADMAdmTime)  d
	..
	..s IAdmRowId=0
	..f  s IAdmRowId=$O(^DHCPEIADM(0, "AdmDateTime", IADMAdmDate, IADMAdmTime,IAdmRowId)) q:(""=IAdmRowId)  d
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmRowId)          //add 2009-07-07 
  	...q:LocFlag=1
	...// DHC_PE_IADM.{ IADM_Status }
	...s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	...Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	...// DHC_PE_IADM.{ IADM_GADM_DR }
	...s ADM=$P($g(^DHCPEIADM(IAdmRowId)),"^",1)
	...q:ADM=""
	...s PapmiNo=$p($g(^PAADM(ADM)),"^",1)	// 取患者信息
	...q:PapmiNo=""
	...// 登记号	PA_PatMas.{PAPMI_IPNo}
	...s PAPMIIPNo=$p($g(^PAPER(PapmiNo,"PAT",1)),"^",1)
	...Q:(""'=RegNo)&(RegNo'=PAPMIIPNo)
	...
	...// 姓名		PA_PatMas.{PAPMI_Name}
	...s PAPMIName=$p($g(^PAPER(PapmiNo,"ALL")),"^",1)	
    ...Q:(""'=PatName)&(PAPMIName'[PatName)
    ...
    ...// 性别 PA_PatMas.{PAPMI_Sex_DR}(CT_Sex)
    ...s Sex=$p($g(^PAPER(PapmiNo,"ALL")),"^",7)
    ...q:(SexDR'="")&&(SexDR'=Sex)
    ...i ""'=Sex s Sex=$p($g(^CT("SEX",Sex)),"^",2)
	...i Sex="" s Sex="未知"
	...// 出生日期 PA_PatMas.{PAPMI_DOB}
	...s PAPMIDOB=$p($g(^PAPER(PapmiNo,"ALL")),"^",6)
	...i ""'=PAPMIDOB s PAPMIDOB=##class(websys.Conversions).DateLogicalToHtml(PAPMIDOB)
	...If (""'=PAPMIDOB) d                                
	....;Set IAge=$p($zd(+$h,3),"-",1)-$p(PAPMIDOB,"-",1)
	...S Age="0"
	...S IAge=##class(web.DHCBillInterface).GetPapmiAge(PapmiNo)
	...i IAge["岁" s Age=$p(IAge,"岁",1)
    ...q:(AgeFrom'="")&&(AgeFrom>Age)
	...q:(AgeTo'="")&&(AgeTo<Age)
	...//移动电话
	...s CRMADM=$p($g(^DHCPEIADM(IAdmRowId)),"^",4)
	...S PIBIDR=$P($g(^DHCPEPreIADM(CRMADM)),"^",1)
	...s Tel=""
	...i PIBIDR'="" s Tel=##class(web.DHCPE.PreCommon).GetTelNo("PIBI",PIBIDR)

	...s GSRowId=0
	...s ^DHCPETMPIS("TotalPerson")=+$G(^DHCPETMPIS("TotalPerson"))+1
	...s ^DHCPETMPIS("TotalPerson",Sex)=+$G(^DHCPETMPIS("TotalPerson",Sex))+1
	...f  s GSRowId=$O(^DHCPEGS(0, "IADM", IAdmRowId, GSRowId)) Q:(""=GSRowId)  d
 	....s ^DHCPETMPIS("Illness", GSRowId)=PAPMIName
 	....s IshaveIllness=..vaildIllness(GSRowId, EDIDs, QueryType)
 	....Q:(0=IshaveIllness)
 	....
 	....s ^DHCPETMPIS("Person",ADM)=PAPMIName
	....s ^DHCPETMPIS("Total")=+$G(^DHCPETMPIS("Total"))+1
	....s ^DHCPETMPIS("Total",Sex)=+$G(^DHCPETMPIS("Total",Sex))+1
	....
	....d IllnessStatistic
	....

     // 统计查询出人数
	s ind=1
	s EDID=""
	s EDDiagnoseConclus=""
	s ADM=""
	s PAPMIIPNo="此次查询数据"
	s PAPMIName="人数"
	s Sex="患病率"
	s PAPMIDOB=""
	;d IllnessStatistic
	// 统计查询出人数
	s EDID=""
	s EDDiagnoseConclus=""
	s ADM=""
	s PAPMIName=0
	s PAPMIIPNo="检查总人数:"
	s PAPMIName=$G(^DHCPETMPIS("TotalPerson"))_"人"
	s Sex=""
	s PAPMIDOB=""
	
	;d IllnessStatistic
	// 统计性别人数
	s EDID=""
	s EDDiagnoseConclus=""
	s ADM=""
	s PAPMIIPNo=""
	s PAPMIDOB=""
	s Sex=""
	s SexStr=""
	s SexName=0
	f  s SexName=$o(^DHCPETMPIS("TotalPerson",SexName))  q:SexName=""  d
	.s PAPMIName=$G(^DHCPETMPIS("TotalPerson",SexName))_"人"
	.s PAPMIIPNo=SexName_"性检查人数:"
	.i SexStr="" s SexStr=PAPMIIPNo_""_PAPMIName
	.e  s SexStr=SexStr_","_PAPMIIPNo_""_PAPMIName
	.;d IllnessStatistic
	// 统计查询出人数
	s EDID=""
	s EDDiagnoseConclus=""
	s ADM=""
	s PAPMIIPNo="患病总人数:"
	s PAPMIName="",Percent=""
	s PAPMIName=$G(^DHCPETMPIS("Total"))_"人"
	s Person=$G(^DHCPETMPIS("TotalPerson"))
	i Person'=""  s Percent=$FN(PAPMIName/Person*100,"",2)_"%"
	s Sex=Percent
	s PAPMIDOB=""
	
	;d IllnessStatistic
	// 统计性别患病人数
	s EDID=""
	s EDDiagnoseConclus=""
	s ADM=""
	s PAPMIIPNo=""
	s PAPMIDOB=""
	s Sex=""
	s SexILLStr=""
	s Percent=""
	s SexName=0
	f  s SexName=$o(^DHCPETMPIS("Total",SexName))  q:SexName=""  d
	.s PAPMIName=$G(^DHCPETMPIS("Total",SexName))_"人"
	.s PAPMIIPNo=SexName_"性患病人数:"
	.s Person=$G(^DHCPETMPIS("TotalPerson",SexName))
	.s HasILLPerson=$G(^DHCPETMPIS("Total",SexName))
	.i HasILLPerson  s Percent=$FN(HasILLPerson/Person*100,"",2)_"%"
	.s Sex=Percent
	.i SexILLStr="" s SexILLStr=SexName_"性患病人数:"_$G(^DHCPETMPIS("Total",SexName))_"人,"_SexName_"性患病率:"_$FN(HasILLPerson/Person*100,"",2)_"%"
	.e  s SexILLStr=SexILLStr_","_SexName_"性患病人数:"_$G(^DHCPETMPIS("Total",SexName))_"人,"_SexName_"性患病率:"_$FN(HasILLPerson/Person*100,"",2)_"%"
	.;d IllnessStatistic
	i '$d(^DHCPETMPIS("TotalPerson")) s TotalPerson=0
	i $d(^DHCPETMPIS("TotalPerson")) s TotalPerson=$g(^DHCPETMPIS("TotalPerson"))
	i '$d(^DHCPETMPIS("Total")) s TotalIllness=0
	i $d(^DHCPETMPIS("Total")) s TotalIllness=$g(^DHCPETMPIS("Total"))
	i (TotalIllness=0) s TotalIllnessPercent=0_"%"
	e  s TotalIllnessPercent=$FN(TotalIllness/TotalPerson*100,"",2)_"%"
    w "此次检查总人数"_TotalPerson_"人,"_SexStr_",患病总人数:"_TotalIllness_"人,患病率:"_TotalIllnessPercent_","_SexILLStr
	s ^DHCPETMPIllness(User,"Illness","Total")="此次检查总人数"_TotalPerson_"人,"_SexStr_",患病总人数:"_TotalIllness_"人,患病率:"_TotalIllnessPercent_","_SexILLStr
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
IllnessStatistic
	set Data=$lb(EDID,EDDiagnoseConclus, ADM,PAPMIIPNo, PAPMIName, Sex, PAPMIDOB,IAge,Tel)
	s ^DHCPETMPIllness(User,"Illness","List",ind)=PAPMIIPNo_"^"_PAPMIName_"^"_Sex_"^"_PAPMIDOB_"^"_IAge_"^"_Tel
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetIllnessRows(User)
{
 
 s iLLoop=0 ,Rows=0
 f  s iLLoop=$O(^DHCPETMPIllness(User,"Illness","List",iLLoop)) Q:(""=iLLoop)  d
 .s Rows=Rows+1
 q Rows_"^"_$g(^DHCPETMPIllness(User,"Illness","Total"))
}

ClassMethod GetIllnessData(User, i)
{
	
	q:'$d(^DHCPETMPIllness(User,"Illness","List",i)) ""
	q $g(^DHCPETMPIllness(User,"Illness","List",i))
}

/// 验证是否符合所给疾病条件
/// w ##class(web.DHCPE.Report.IllnessStatistic).vaildIllness("17","^11897^11898^11899^","O")
ClassMethod vaildIllness(GSDR As %Library.String = "", ISIDs As %Library.String = "", QueryType As %Library.String = "")
{
	 S PAAdmRowid=$p($g(^DHCPEGS(GSDR,1)),"^",8)
     s CurLoc=$P($G(^PAADM(PAAdmRowid)),"^",4)

	s IsHaveIllness=0
	//S RDiagnosisType=$P($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	S RDiagnosisType=$P($G(^DHCPESetting("DHCPE","GRDiagnosisType",CurLoc)),"^",1)
	s GSDChildSub=0
	f  s GSDChildSub=$O(^DHCPEGS(GSDR, "Diagnosis", GSDChildSub)) Q:(""=GSDChildSub)  d
	.Q:("A"'=QueryType)&(1=IsHaveIllness)
	.s GSDEDDR=$P($G(^DHCPEGS(GSDR, "Diagnosis", GSDChildSub)), "^", 1)
    .i RDiagnosisType="Y"  d
	..s IDRRowId=0
	..f  s IDRRowId=$O(^DHCPEIDR(0,"EDDR", GSDEDDR, IDRRowId)) Q:(""=IDRRowId)  d
	...Q:("A"'=QueryType)&(1=IsHaveIllness)
	...s IDRILLSDR=$P($G(^DHCPEIDR(IDRRowId)), "^", 2)
	...q:IDRILLSDR=""
	...i "A"=QueryType d
	....s ^DHCPETMPIS("Illness", GSDR, IDRILLSDR)=0
	...e  d
	....Q:(ISIDs'[("^"_IDRILLSDR_"^"))
	....s IsHaveIllness=1
	....s ^DHCPETMPIS("Illness", GSDR, IDRILLSDR)=0
	.else  d
	..i "A"=QueryType d
	...s ^DHCPETMPIS("Illness", GSDR, GSDEDDR)=0
	..e  d
	...Q:(ISIDs'[("^"_GSDEDDR_"^"))
	...s IsHaveIllness=1
	...s ^DHCPETMPIS("Illness", GSDR, GSDEDDR)=0


	Q:("A"'=QueryType) IsHaveIllness
	s IsHaveIllness=1 // 默认记录为真
	// 循环项目
	s iLoop=1
	do{
		s ISID=$P(ISIDs, "^", iLoop)
		i (""'=ISID) d
		.s:(0=$D(^DHCPETMPIS("Illness", GSDR, ISID))) IsHaveIllness=0
		s iLoop=1+iLoop
	}while (+iLoop<=+$l(ISIDs,"^"))&(IsHaveIllness=1)
	Q IsHaveIllness
}

/*
/// 未修改疾病表前的函数 2007.12.19
/// 
ClassMethod SearchADMIllnessExecute(ByRef qHandle As %Binary, ADMID As %Library.String = "", EDIDs As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "") As %Status
{

	Set repid=$I(^CacheTemp)

	i (""=ADMID) {
 		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}

	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	k ^DHCPETMPSAI
	s ^DHCPETMPSAI("SearchADMIllness")=""""_ADMID_""","""_EDIDs_""","""_DateFrom_""","""_DateTo_""""

	s IAdmRowId="0"
	// DHC_PE_IADM
	f  s IAdmRowId=$O(^DHCPEIADM(0,"PAADM", ADMID, IAdmRowId)) Q:(""=IAdmRowId)  d
	.
	.// IADM_Status
	.s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	.Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	.
	.// DHC_PE_IADM.{ IADM_PAADM_DR }
	.//s IADMPAADMDR=$P($G(^DHCPEIADM(IAdmRowId)),"^",1)
	.
	.// DHC_PE_GADM.{ IADM_AdmDate }	体检日期
	.//s AdmDate=$P($G(^DHCPEIADM(IAdmRowId)),"^",5)
	.//Q:(""=AdmDate)
	.//Q:(""'=DateFrom)&(""'=AdmDate)&(DateFrom>AdmDate)
	.//Q:(""'=DateTo)&(""'=AdmDate)&(DateTo<AdmDate)
	.//s AdmDate=$ZD(AdmDate,3)
	.
	.s GSRowId=0
	.// DHC_PE_GeneralSummarize.{ GS_RowId }
	.f  s GSRowId=$O(^DHCPEGS(0,"IADM", IAdmRowId, GSRowId)) Q:(""=GSRowId)  d
	..
	..s GSDChildSub=0
	..// DHC_PE_GSDiagnosis.{ GSDChildSub }
	..f  s GSDChildSub=$O(^DHCPEGS(GSRowId, "Diagnosis", GSDChildSub)) Q:(""=GSDChildSub)  d
	...
	...// DHC_PE_GSDiagnosis.{ GSD_ED_DR } -> DHC_PE_ExpertDiagnosis
	...s GSDEDDR=$P($G(^DHCPEGS(GSRowId, "Diagnosis", GSDChildSub)),"^",1)
	...
	...s IsSelect="*"
	...s:(""'=EDIDs)&(EDIDs'[("^"_GSDEDDR_"^")) IsSelect=""
	...
	...// DHC_PE_ExpertDiagnosis.{ ED_Code }
	...s EDCode=$P($G(^DHCPEED(GSDEDDR,1)),"^",6)
	...// DHC_PE_ExpertDiagnosis.{ ED_DiagnoseConclus }
	...s EDDiagnoseConclus=$P($G(^DHCPEED(GSDEDDR,1)),"^",1)
	...
	...
	...set Data=$lb(EDCode,EDDiagnoseConclus, IsSelect)
	...
	...d SearchADMIllness
	...
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
SearchADMIllness
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}
*/
ClassMethod IllnessStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = IllnessStatisticExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod IllnessStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = IllnessStatisticExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 查找指定患者的疾病 
/// DHCPEIllnessStatistic.IllnessList ^DHCPETMPSAI("SearchADMIllness")="720880","^2297^2298^","62083",""
/// d ##Class(%ResultSet).RunQuery("web.DHCPE.StatisticQuery","SearchADMIllness","720880","^2297^2298^","62083","")
Query SearchADMIllness(ADMID As %Library.String = "", EDIDs As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "") As %Query(ROWSPEC = "ILLS_Code:%String, ILLS_Desc:%String, SAI_IsSelect:%String")
{
}

ClassMethod SearchADMIllnessExecute(ByRef qHandle As %Binary, ADMID As %Library.String = "", EDIDs As %Library.String = "", DateFrom As %Library.String = "", DateTo As %Library.String = "") As %Status
{

	Set repid=$I(^CacheTemp)

	i (""=ADMID) {
 		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}

	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	k ^DHCPETMPSAI
	s ^DHCPETMPSAI("SearchADMIllness")=""""_ADMID_""","""_EDIDs_""","""_DateFrom_""","""_DateTo_""""
    S RDiagnosisType=$P($G(^DHCPESetting("DHCPE","GRDiagnosisType")),"^",1)
	s IAdmRowId="0"
	// DHC_PE_IADM
	f  s IAdmRowId=$O(^DHCPEIADM(0,"PAADM", ADMID, IAdmRowId)) Q:(""=IAdmRowId)  d
	.
	.// IADM_Status
	.s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	.Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	.
	.s GSRowId=0
	.// DHC_PE_GeneralSummarize.{ GS_RowId }
	.f  s GSRowId=$O(^DHCPEGS(0,"IADM", IAdmRowId, GSRowId)) Q:(""=GSRowId)  d
	..
	..s GSDChildSub=0
	..// DHC_PE_GSDiagnosis.{ GSDChildSub }
	..f  s GSDChildSub=$O(^DHCPEGS(GSRowId, "Diagnosis", GSDChildSub)) Q:(""=GSDChildSub)  d
	...
	...// DHC_PE_GSDiagnosis.{ GSD_ED_DR } -> DHC_PE_ExpertDiagnosis
	...s GSDEDDR=$P($G(^DHCPEGS(GSRowId, "Diagnosis", GSDChildSub)),"^",1)
	...i RDiagnosisType="Y"  d
	....s IDRRowId=0
	....f  s IDRRowId=$O(^DHCPEIDR(0,"EDDR", GSDEDDR, IDRRowId)) Q:(""=IDRRowId)  d
	.....// DHC_PE_IDRelate.{ IDR_ILLS_DR } = DHC_PE_IllnessStandard.{ ILLS_RowId } 疾病标准表
	.....s IDRILLSDR=$P($G(^DHCPEIDR(IDRRowId)), "^", 2)
	.....Q:(0'=$D(^DHCPETMPSAI("SearchADMIllness", IDRILLSDR)))
	.....s:(""'=EDIDs)&(EDIDs'[("^"_IDRILLSDR_"^")) ^DHCPETMPSAI("SearchADMIllness", IDRILLSDR)=""
	.....s:(""'=EDIDs)&(EDIDs[("^"_IDRILLSDR_"^")) ^DHCPETMPSAI("SearchADMIllness", IDRILLSDR)="*"
	...else  d
    ....Q:(0'=$D(^DHCPETMPSAI("SearchADMIllness", GSDEDDR)))
	....s:(""'=EDIDs)&(EDIDs'[("^"_GSDEDDR_"^")) ^DHCPETMPSAI("SearchADMIllness", GSDEDDR)=""
	....s:(""'=EDIDs)&(EDIDs[("^"_GSDEDDR_"^")) ^DHCPETMPSAI("SearchADMIllness", GSDEDDR)="*"
	
	s ILLSRowId=0
	f  s ILLSRowId=$O(^DHCPETMPSAI("SearchADMIllness", ILLSRowId)) Q:(""=ILLSRowId)  d
	.i RDiagnosisType="Y"  d
	..s ILLSCode=$P($G(^DHCPEILLS(ILLSRowId)),"^",1)
	..// DHC_PE_IllnessStandard.{ ILLS_Desc }
	..s ILLSDesc=$P($G(^DHCPEILLS(ILLSRowId)),"^",2)
	..s IsSelect=^DHCPETMPSAI("SearchADMIllness", ILLSRowId)
	..set Data=$lb(ILLSCode,ILLSDesc, IsSelect)
	..d SearchADMIllness
	.else  d
	..s EDRowID=ILLSRowId
	..s EDCode=$p($G(^DHCPEED(EDRowID,1)),"^",6)
	..s EDDiagnoseConclus=$p($G(^DHCPEED(EDRowID,1)),"^",1)
	..s IsSelect=^DHCPETMPSAI("SearchADMIllness", EDRowID)
	..set Data=$lb(EDCode,EDDiagnoseConclus, IsSelect)
	..d SearchADMIllness
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
SearchADMIllness
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchADMIllnessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchADMIllnessExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else{			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchADMIllnessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchADMIllnessExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
