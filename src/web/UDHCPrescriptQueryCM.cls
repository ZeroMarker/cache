Class web.UDHCPrescriptQueryCM Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod CMPRINT(EpisodeID)
{
 s MaxPrescNo=0
 s QUE1RowID="" f  s QUE1RowID=$o(^PAQUE1(0,"QUE1_PAADM_DR",EpisodeID,QUE1RowID)) q:QUE1RowID=""  d
 .q:$d(^PAQUE1(QUE1RowID))'=11
 .s prescno=$p(^PAQUE1(QUE1RowID),"^",14)
 .q:'$d(^PAQUE1(QUE1RowID,"DHC"))
 .s prestype=$p(^PAQUE1(QUE1RowID,"DHC"),"^",2)
 .q:prestype'=3
 .s prescno1=$EXTRACT(prescno,2,11),type=$EXTRACT(prescno,1,1)
 .i prescno1>MaxPrescNo s MaxPrescNo=prescno1
 s info=..getinfo(EpisodeID,type_MaxPrescNo)
 q info
}

/// 通过处方号得到煎药费数量
/// w ##class(web.UDHCPrescriptQueryCM).GetDJFeeNumByPrescNo("O13010600003")
ClassMethod GetDJFeeNumByPrescNo(PrescNo)
{
	s DJFeeNum=0
	s CookFee=..%GetConfig("CNMedCookModeFeeItem")
	q:CookFee="" DJFeeNum
	s ord=0 f  s ord=$O(^OEORD(0,"PrescNo",PrescNo,ord)) q:ord=""  d
	.s chl=0 f  s chl=$O(^OEORD(0,"PrescNo",PrescNo,ord,chl)) q:chl=""  d
	..q:'$d(^OEORDi(0,"OEORI",ord,ord_"||"_chl))
	..s sub="" f  s sub=$o(^OEORDi(0,"OEORI",ord,ord_"||"_chl,sub)) q:sub=""  d
	...s ArcimDr=$p(^OEORD(ord,"I",sub,1),"^",2)
	...q:ArcimDr'=CookFee
	...s DoseQty=$p($g(^OEORD(ord,"I",sub,1)),"^",12)
	...s DJFeeNum=DJFeeNum+DoseQty
	
	q DJFeeNum
}

ClassMethod GetDJFeeM(OrdItem, qty)
{
 s ret=""
 q:'$d(^OEORDi(0,"OEORI",+OrdItem)) ""
 s sub="" f  s sub=$o(^OEORDi(0,"OEORI",+OrdItem,OrdItem,sub)) q:sub=""  d
 .s ret=..GetDJFeeS(+OrdItem,sub,qty)
 .q:ret=""
 q ret
}

ClassMethod GetDJFeeS(ord, chl, qty)
{
 q:ord="" ""
 q:chl="" ""
 q:'$d(^OEORD(ord,"I",chl,1)) ""
 s arcimdr=$p(^OEORD(ord,"I",chl,1),"^",2)
 q:arcimdr="" ""
 s CookFee=..%GetConfig("CNMedCookModeFeeItem")
 i arcimdr'=CookFee q ""
 s sub=$p(arcimdr,"||",2)
 s arcdesc=$p($g(^ARCIM(+arcimdr,sub,1)),"^",2)
 s UnitPrice=##class(web.DHCDocOrderEntry).GetOrderPrice("", "", arcimdr, "", "", "", "", "") 
 s UnitPrice=$p($g(UnitPrice),"^",1)
 s amount=UnitPrice*qty  
 q arcdesc_" "_amount_"元"
}

ClassMethod StopEstimate(presc)
{
 q:presc=""
 s QUE1RowID="" f  s QUE1RowID=$o(^PAQUE1(0,"PrescNo",presc,QUE1RowID)) q:QUE1RowID=""  d
 .q:'$d(^PAQUE1(QUE1RowID))
 .s PharmStatus=$p(^PAQUE1(QUE1RowID),"^",13) //处方状态
 .q:PharmStatus="C"
 q PharmStatus
}

ClassMethod YBFL(RowId)
{
 s childsub=$p(RowId,"||",2),RowId=$p(RowId,"||",1)
 s ItmMastDR=$p(^OEORD(RowId,"I",childsub,1),"^",2)
 i $d(^OEORD(RowId,"I",childsub,"DEP")) s DepProcNotes=^OEORD(RowId,"I",childsub,"DEP",1)
 s Subscript=$p(ItmMastDR,"||",1) s Version=$p(ItmMastDR,"||",2)
 s PHCDFDR=$p(^ARCIM(Subscript,Version,1),"^",12)
 s ARCIMDesc=$p(^ARCIM(Subscript,Version,1),"^",2)
 s OfficialCode=$p(^PHCD($p(PHCDFDR,"||",1),4),"^",2)
 i OfficialCode="1" s YBFL="{甲}"
 i OfficialCode="2" s YBFL="{乙}"
 i OfficialCode="3" s YBFL="{丙}"
 q ARCIMDesc_"^"_DepProcNotes
}

ClassMethod allprint(EpisodeID)
{
 k ^DHCCYPRINT($j)
 S num=1
 s QUE1RowID="" f  s QUE1RowID=$o(^PAQUE1(0,"QUE1_PAADM_DR",EpisodeID,QUE1RowID)) q:QUE1RowID=""  d
 .q:$d(^PAQUE1(QUE1RowID))'=11
 .s PharmStatus=$p(^PAQUE1(QUE1RowID),"^",13) //处方状态
 .q:PharmStatus="C"
 .s prescno=$p(^PAQUE1(QUE1RowID),"^",14)
 .s allinfo=##Class(web.UDHCPrescriptQueryCM).getinfo(EpisodeID,prescno)
 .s ^DHCCYPRINT($j,num)=allinfo
 .s num=num+1
 q $j
}

ClassMethod getallinfo(job, num)
{
 s str= ^DHCCYPRINT(job,num)
 q str
}

ClassMethod getdsy(rowid)
{
 s OEORDRowId=$P(rowid,"||",1),OEORIChildsub=$P(rowid,"||",2)
 s oeoridr=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,11),"^",39)	
 q oeoridr
}

ClassMethod getinfo(EpisodeID, presc)
{
 s info1="",je5="",info2="",lyqhj="",lyqdesc="",jybz="",MakeEach="",PHCFRFactor=0,AllMake="",Louyq="",Louyqdesc="",Louyqhj="",CosDesc=""
 s CNMedAppendItem=..%GetConfig("CNMedAppendItem") //药漏
 s QUE1RowID="" f  s QUE1RowID=$o(^PAQUE1(0,"PrescNo",presc,QUE1RowID)) q:QUE1RowID=""  d
 .q:'$d(^PAQUE1(QUE1RowID))
 .s DepartmentLocid=$p(^PAQUE1(QUE1RowID),"^",4)
 .q:'$d(^PAQUE1(QUE1RowID,"DHC"))
 .s MakeEach=$p(^PAQUE1(QUE1RowID,"DHC"),"^",13)   //当次用量
 .s dj=$p(^PAQUE1(QUE1RowID,"DHC"),"^",15)   //PrescCookMode
 .s jybz=$p(^PAQUE1(QUE1RowID,"DHC"),"^",21)
 .i jybz'="" s jybz="备注: "_jybz
 .s ARCOSRowId=$p(^PAQUE1(QUE1RowID,"DHC"),"^",24)      //协定处方ID
 .if ARCOSRowId'="" s CosDesc=$p(^ARCOS(ARCOSRowId),"^",2)
 .s Department=$p(^CTLOC(DepartmentLocid),"^",2)
 .s Department=$p(Department,"-",2)
 s papmi=$p(^PAADM(EpisodeID),"^",1)
 s AdmDepDr=$p($g(^PAADM(EpisodeID)),"^",4)
 s AdmDate=$p($G(^PAADM(EpisodeID)),"^",6)
 s:AdmDate'="" AdmDate=$ZD(AdmDate,3)
 s NewDate=$ZD(+$H,3)
 s AdmDepHos=$p($g(^CTLOC(AdmDepDr)),"^",22)
 s HospName=""
 i AdmDepHos'="" s HospName=$p(^CT("HOSP",AdmDepHos),"^",2)
 s info=##Class(web.DHCDocOrderEntry).GetPatientByRowid(papmi)
 s LinkOrd=""
 s FirstOrd="",BillTypeDesc=""
 s OEORDRowId="" f  s OEORDRowId=$o(^OEORD(0,"PrescNo",presc,OEORDRowId)) q:OEORDRowId=""  d
 .s OEORIChildsub="" f  s OEORIChildsub=$o(^OEORD(0,"PrescNo",presc,OEORDRowId,OEORIChildsub)) q:OEORIChildsub=""  d
 ..q:'$d(^OEORD(OEORDRowId,"I",OEORIChildsub))
 ..s FirstOrd=OEORDRowId_"||"_OEORIChildsub
 ..i LinkOrd="" S LinkOrd=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,11)),"^",39)
 ..s ItmMastrowid=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
 ..s Subscript=$p(ItmMastrowid,"||",1)
 ..s Version=$p(ItmMastrowid,"||",2)
 ..s ARCIMDesc=$p(^ARCIM(Subscript,Version,1),"^",2)
 ..//start
 ..s EQQty=0,EQCTUOMDesc=""
 ..s PhcpfDr=$p(^ARCIM(Subscript,Version,1),"^",12)
 ..s PHCDFChildSub=$p(PhcpfDr,"||",2)
 ..s PhcpfDr=+PhcpfDr
 ..if PHCDFChildSub'="" d
 ...s CTUOMDr=$p(^PHCD(PhcpfDr,"DF",PHCDFChildSub,2),"^",4)
 ...s CTUOMDesc=$p(^CT("UOM",CTUOMDr),"^",2)
 ...s EQChildSub=$O(^PHCD(PhcpfDr,"DF",PHCDFChildSub,"EQ",0))
 ...if EQChildSub'=""  d
 ....s EQCTUOMDr=$p(^PHCD(PhcpfDr,"DF",PHCDFChildSub,"EQ",EQChildSub),"^",1)
 ....s EQQty=$p(^PHCD(PhcpfDr,"DF",PHCDFChildSub,"EQ",EQChildSub),"^",2)
 ....s EQCTUOMDesc=$p($g(^CT("UOM",EQCTUOMDr)),"^",2)
 ....//s EquieNum=..GetEquieNum(CTUOMDr,EQCTUOMDr)
 ..//end
 ..s ItemStat=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
 ..q:ItemStat="4"
 ..s FrequenceRowid=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",4)
 ..s DurationRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",6)
 ..s OEORIDoctorDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",11)
 ..q:'$d(^CTPCP(OEORIDoctorDR,1))
 ..s OEORIDoctor=$p(^CTPCP(OEORIDoctorDR,1),"^",2)
 ..s OEORIOrdDeptDR=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",3)
 ..s OEORIOrdDept=$p(^CTLOC(OEORIOrdDeptDR),"-",2) //科别
 ..s OEORIOrdDept=$p(OEORIOrdDept,"^",1)
 ..s InstructionRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",7)
 ..s DoseQty=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",12) //数量
 ..s PhSpecInstr=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",8) //备注
 ..s SttDat=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",9) //日期
 ..s DoseUOM=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",3) 
 ..s BBExtCode=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,11)),"^",18)
 ..if BBExtCode'="" s BillTypeDesc=$P(^PAC("ADMREA",BBExtCode),"^",2)
 ..i BillTypeDesc="" s BillTypeDesc="自费"
 ..//s UnitPrice=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",4) //单价
 ..s UnitPrice=##class(web.DHCDocOrderEntry).GetOrderPrice("", "", ItmMastrowid, "", "", "", "", "") 
 ..s UnitPrice=$p(UnitPrice,"^",1)
 ..i PhSpecInstr="" s PhSpecInstr="    "
 ..s PhSpecInstr=PhSpecInstr_"/"_$j(UnitPrice,3,2)   ///1129
 ..s PHCINDesc=$p($p(^PHCIN(InstructionRowid),2),"^",2) //用法
 ..i $l(PHCINDesc,"-")>1 s PHCINDesc=$p(PHCINDesc,"-",2,$l(PHCINDesc,"-"))
 ..s DurationFactor=1,lyq=""
 ..i DurationRowid'="" d
 ...s DurationDesc=$p(^PHCDU(DurationRowid),"^",3)  //疗程
 ...s DurationFactor=$p(^PHCDU(DurationRowid),"^",2)
 ..s amount=$j(UnitPrice*DoseQty,3,2)
 ..s je5=je5+amount
 ..s je="%"_($j(amount/DurationFactor,3,2))   
 ..  // _"/"_$j(UnitPrice,3,2)
 ..s CTUOMDesc=$p(^CT("UOM",DoseUOM),"^",2) //剂量单位
 ..s PHCFRDesc=$p(^PHCFR(FrequenceRowid),"^",3) //名称,取频次
 ..s PHCFRFactor=$p(^PHCFR(FrequenceRowid),"^",2)
 ..if (CTUOMDesc'="g")  d
 ...s ARCIMDesc=ARCIMDesc_"("_EQQty_EQCTUOMDesc_")"
 ..i ItmMastrowid=CNMedAppendItem d
 ...s lyq=ARCIMDesc_" ("_DoseQty_") "_CTUOMDesc_" "_UnitPrice
 ...s lyqdesc=ARCIMDesc
 ...s lyqhj=DoseQty*UnitPrice
 ..//add by wangli20081023
 ..i ItmMastrowid=CNMedAppendItem d
 ...//s Louyq=ARCIMDesc_" ("_DoseQty_") "_CTUOMDesc_" "_UnitPrice
 ...s Louyq=$P(ARCIMDesc,"(",1)_" "_(DoseQty/DurationFactor)_CTUOMDesc
 ...s Louyqdesc=ARCIMDesc
 ...s Louyqhj=(DoseQty/DurationFactor)*UnitPrice
 ..e  d
 ...s info1=info1_ARCIMDesc_" "_(DoseQty/DurationFactor)_CTUOMDesc_je_"%"_PhSpecInstr_"|"
 i $g(DurationFactor)="" s DurationFactor=1
 s je6=$j(($j(je5,3,2)-lyqhj)/DurationFactor,3,2) s lyqk=lyqhj i lyqk<1 s lyqk="0"_lyqk
 s je5=$j(($j(je5,3,2)-lyqhj),3,2)
 s AllMake=PHCFRFactor*(+MakeEach)
 s AllMake=AllMake_$tr(MakeEach,+MakeEach)
 s hospitalcode="01151002"
 s PapmiNo=$p(info,"^",2)
 s name=$p(info,"^",3)
 s sex=$p(info,"^",4)
 s age=$p(info,"^",5)
 s PAADMType=$p(^PAADM(EpisodeID),"^",2)
 s GovernCardNo=$p($g(info),"^",24)
 s Medcare=$p($g(info),"^",19)
 if (PAADMType="I") s Medcare=##class(web.DHCDocOrderCommon).GetMrNo("",papmi,"I")
 s PatientCompany=$p($g(info),"^",15)
 s PatientComAdd=$p($g(info),"^",11)
 i PatientCompany'="" s PatientComAdd=PatientCompany
 s PatientName=$p($g(info),"^",7)
 s lyq=""
 i LinkOrd="" s LinkOrd=FirstOrd
 s lyq=..GetDJFeeM(LinkOrd,DurationFactor)                 ;///代煎费
 i (lyq="")&(lyqk'="")  s lyq=lyqdesc_" "_$g(lyqk)_"元"    ;///漏药器
 s Louyq=Louyq_" "_$g(Louyqhj)_"元" 
 i lyq=" 0元" s lyq=""
 //s lyq=""
 s info2=$g(hospitalcode)_"^"_$g(PapmiNo)_"^"_$g(presc)_"^"_$g(name)_"^"_$g(sex)_"^"_$g(age)_"^"_$g(Medcare) _"^"_$g(OEORIOrdDept) _"^"_$g(PatientComAdd)_"^"_$g(BillTypeDesc) //_"^"PatientName
 ;s getinfo=info2_"^"_$g(DurationDesc)_"^"_$g(PHCINDesc)_"^"_$g(OEORIDoctor) _"^"_$g(je5)_"^"_ $g(info1)_"^"_$zd(SttDat,3)_"^"_$g(Department)_"^"_$g(lyq)_"^"_$g(DurationFactor)_"^"_je6_"^"_$g(lyqk)_"^"_jybz_"^"_PHCFRDesc_"^"_MakeEach_"^"_AllMake
 i $g(SttDat)'="" s SttDat=$zd(SttDat,3)
 s getinfo=info2_"^"_$g(DurationDesc)_"^"_$g(PHCINDesc)_"^"_$g(OEORIDoctor) _"^"_$g(je5)_"^"_ $g(info1)_"^"_$g(SttDat)_"^"_$g(Department)_"^"_$g(lyq)_"^"_$g(DurationFactor)_"^"_$g(je6)_"^"_$g(lyqk)_"^"_$g(jybz)_"^"_$g(PHCFRDesc)_"^"_$g(MakeEach)_"^"_$g(AllMake)_"^"_$g(dj)_"^"_$g(Louyq)_"^"_$g(CosDesc)
 s getinfo=getinfo_"^"_HospName_"^"_$G(AdmDate)_"^"_$G(NewDate)
 q getinfo
}

ClassMethod GetEquieNum(CTUOMDr, EQCTUOMDr)
{
	s CTCFRowId="",Factor=0
	f  s CTCFRowId=$o(^CT("CTCF",CTCFRowId)) q:CTCFRowId=""  d
	.s CFFrUOMDr=$p(^CT("CTCF",CTCFRowId),"^",1)
	.s CFToUOMDr=$p(^CT("CTCF",CTCFRowId),"^",2)
	.s ActiveFlag=$p(^CT("CTCF",CTCFRowId),"^",4)
	.q:(ActiveFlag'="Y")
	.q:(CFFrUOMDr'=CTUOMDr)||(CFToUOMDr'=EQCTUOMDr)
	.s Factor=$p(^CT("CTCF",CTCFRowId),"^",3)
	
	Q Factor
}

ClassMethod getname(EpisodeID)
{
	
 s PAADM=EpisodeID
 s papmi=$p(^PAADM(PAADM),"^",1)
 s info=##Class(web.DHCDocOrderEntry).GetPatientByRowid(papmi)
 s PAADMType=$p(^PAADM(PAADM),"^",2)
 if (PAADMType="I") {
	 s IPMedcare=##class(web.DHCDocOrderCommon).GetMrNo("",papmi,"I")
	 s $p(info,"^",19)=IPMedcare
 }
 q info // ret= PapmiRowid_"^"_PapmiNo_"^"_PatientName_"^"_PatientSex_"^"_AgeDesc_"^"_PatientBirthday_"^"_Pattype_"^"_PatientSocialStausDR_"^"_PatientSexDr_"^"_PatientDOB_"^"_PatientCompany_"^"_AgeYear_"^"_AgeMonth_"^"_AgeDay_"^"_PatientComAdd_"^"_EmployeeNO_"^"_PatientMarital_"^"_PatCategoryRowid_"^"_Medcare_"^"_RealName_"^"_RealCard_"^"_SupplyName_"^"_SupplyCard_"^"_GovernCardNo
}

ClassMethod getnum(job)
{
 s gnum=$o(^DHCCYPRINT(job,""),-1)
 q gnum
}

ClassMethod gettype(rowid)
{
 s OEORDRowId=$P(rowid,"||",1),OEORIChildsub=$P(rowid,"||",2)
 s ItmMastrowid=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
 s Subscript=$p(ItmMastrowid,"||",1),Version=$p(ItmMastrowid,"||",2)
 s ItemCat=$p(^ARCIM(Subscript,Version,1),"^",10)
 s fl=##Class(web.DHCDocOrderCommon).GetPHPrescType(ItemCat,"",ItmMastrowid)
 q fl
}

ClassMethod ksClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ksExecute ]
{
		Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.UDHCPrescriptQueryCM","ks","fs")
ClassMethod ksExecute(ByRef qHandle As %Binary, ks As %String, HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=0
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s rowid=0
	Set langid=..%LanguageID()
	&sql(declare kssearch cursor  for 
	select CTLOC_Desc,CTLOC_Rowid from SQLUser.ct_loc) //where CTLOC_Desc like UPPER(:ks)
	&sql(open kssearch)
	f  &sql(fetch kssearch into :ksdesc,:ksrowid) q:SQLCODE  d
	.s LocHospId=$p(^CTLOC(ksrowid),"^",22)
	.Q:LocHospId'=HospID
	.q:##class(web.DHCOPAdmReg).CheckLocDesc(ksrowid,ks)'=1
	.s ksdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ksdesc,langid)
	.q:($P(^CTLOC(ksrowid),"^",14)'="Y")
	.Do OutputRow2	 
	&sql(close kssearch)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow2
	i $f(ksdesc,"-")'=0  d
	.s ksdesc=$p(ksdesc,"-",2)
	set Data=$lb(ksdesc,ksrowid)
	Set ind=ind+1
	Set ^CacheTemp(repid,ind)=Data
	quit
}

ClassMethod ksFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ksExecute ]
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
	s qHandle=$lb(AtEnd,repid,ind) //
	Quit $$$OK
}

ClassMethod searchClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = searchExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod searchExecute(ByRef qHandle As %Binary, EpisodeID As %String, loc As %String, strdate As %Date, enddate As %String, PatientID As %String = "", SearchFlag As %String = "", LogonHospDr As %String = "") As %Status
{
 ;d ##class(%ResultSet).RunQuery("web.UDHCPrescriptQueryCM","search",39,"",64474,64477,1,"")
 Set repid=$I(^CacheTemp)
 s ind=1
 s ^tmpguorong("search")=EpisodeID_","_loc_","_strdate_","_enddate_","_PatientID_","_SearchFlag_"*"
 s num=0,m=""
 k PLIST
 i (EpisodeID="")&&(PatientID="") Set qHandle=$lb(0,repid,0)  quit $$$OK
 i strdate="" Set qHandle=$lb(0,repid,0)  quit $$$OK
 i enddate="" Set qHandle=$lb(0,repid,0)  quit $$$OK
 s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospDr)
 s strdate=..%ZDH(strdate)
 s enddate=..%ZDH(enddate)
 Set langid=..%LanguageID()
 if (EpisodeID'=""){
	 s patientId=$p(^PAADM(EpisodeID),"^",1)
	 if (patientId'=PatientID)&&(PatientID'="") s EpisodeID=""
 }
 Set AdmRowidStr=""
 if EpisodeID="" {
	Set PatientRowId=PatientID	 
 }else{
	s PatAdmType=$p(^PAADM(EpisodeID),"^",2)
 	s PatAdmDate=$p(^PAADM(EpisodeID),"^",6)
	s admrowid=EpisodeID
 	s PatientRowId=$p(^PAADM(admrowid),"^",1)
 	if (PatientRowId=PatientID){
 		s PatientID	=PatientRowId 
 	}
 }
 s AddLongArcimStr=##class(DHCDoc.DHCDocConfig.DocConfig).FindAddLongArcim()
 s AddLongArcimStr="!"_AddLongArcimStr_"^"
 k ADMArr
 Set AdmType=0
 for  Set AdmType=$o(^PAPERdr(PatientID,"ADM",AdmType)) Quit:AdmType=""  do
 .Set AdmRowid=0
 .for  Set AdmRowid=$o(^PAPERdr(PatientID,"ADM",AdmType,AdmRowid)) Quit:AdmRowid=""  do
 ..s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(AdmRowid)
 ..Q:LogonHospDr'=AdmHospitalId
 ..Set AdmDate=$p(^PAADM(AdmRowid),"^",6)
 ..//Quit:AdmDate<strdate
 ..//Quit:AdmDate>enddate
 ..s ADMArr(AdmRowid)=""


 b ;AdmRowidStr
 i '$D(ADMArr) Set qHandle=$lb(0,repid,0)  quit $$$OK
 
 s PatientNo="",PatientName=""
 if PatientRowId'="" d
 .s PatientNo=$P($G(^PAPER(PatientRowId,"PAT",1)),"^",2)
 .s PatientName=$P($G(^PAPER(PatientRowId,"ALL")),"^",1)                           //09-02-17 guo end
 s PAADM=""
 for {
	s PAADM=$O(ADMArr(PAADM),-1)
	q:PAADM=""
	s QUE1RowID="" f  s QUE1RowID=$o(^PAQUE1(0,"QUE1_PAADM_DR",PAADM,QUE1RowID),-1) q:QUE1RowID=""  d
	.q:'$d(^PAQUE1(QUE1RowID))
	.s prescno=$p(^PAQUE1(QUE1RowID),"^",14)
	.s prescctpcp=$p(^PAQUE1(QUE1RowID),"^",5)
	.if ($d(^PAQUE1(QUE1RowID,"DHC"))) d
	..s presctransdate=$p(^PAQUE1(QUE1RowID,"DHC"),"^",6)
	.e  s presctransdate=$p(^PAQUE1(QUE1RowID),"^",7)
	.q:(presctransdate<strdate)||(presctransdate>enddate)
	.s doctordr=$p(^PAQUE1(QUE1RowID),"^",5)
	.s doctor=""
	.i doctordr>0 s doctor=$p(^CTPCP(doctordr,1),"^",2)
	.if ($d(^PAQUE1(QUE1RowID,"DHC"))) d
	..s transdate=$p(^PAQUE1(QUE1RowID,"DHC"),"^",6)
	.e  s transdate=$p(^PAQUE1(QUE1RowID),"^",7)
	.q:'$d(^PAQUE1(QUE1RowID,"DHC"))
	.s prestype=$p(^PAQUE1(QUE1RowID,"DHC"),"^",2)
	.q:prestype'=3
	.//非医护人员录入不显示
	.s AddUser=$P(^PAQUE1(QUE1RowID,"DHC"),"^",3)
	.s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(AddUser)
	.s CareProvType=$zcvt(CareProvType,"U")
	.q:CareProvType'="DOCTOR"
	.//---end------------
	.s cookmode=""
	.s cookmodeDr=$p($g(^PAQUE1(QUE1RowID,"DHC")),"^",15)            ;zhaozhiduan 20130109
	.s:cookmodeDr'="" cookmode=$p($g(^DHCDocConfig("HospDr_"_LogonHospDr,"CookMode",cookmodeDr)),"^",2)
	.s cookmode=##class(websys.Translation).Get("opdoc.oeorder.cmpresclist.csp",cookmode)
	.s ARCOSRowId=$p(^PAQUE1(QUE1RowID,"DHC"),"^",24)
	.s ARCOSName=""
	.i ARCOSRowId'="" d
	..s ARCOSName=$P(^ARCOS(ARCOSRowId),"^",2)
	.;s num=num+1
	.s doctor =##class(User.SSUser).GetTranByDesc("SSUSRName",doctor,langid)
	.s b(1)=PatientNo_" "_PatientName_":"_prescno_" "_ARCOSName_" "_doctor_"  "_..%ZD(transdate)_" "_cookmode //$zd(transdate,3)
	.s OEORDRowId="" f  s OEORDRowId=$o(^OEORD(0,"PrescNo",prescno,OEORDRowId)) q:OEORDRowId=""  d
	..s i=16,x=1,y=1,je5=0
	..s OEORIChildsub="" f  s OEORIChildsub=$o(^OEORD(0,"PrescNo",prescno,OEORDRowId,OEORIChildsub)) q:OEORIChildsub=""  d
	...q:'$d(^OEORD(OEORDRowId,"I",OEORIChildsub))
	...s PhSpecInstr="",stopflag="2"
	...s ItmMastrowid=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",2)
	...s OrdUserDep=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,7),"^",2) //OEORI_UserDepartment_Dr 下医嘱科室
	...q:(OrdUserDep'="")&&(OrdUserDep'=loc)&&(SearchFlag'=1)&&(loc'="")
	...q:(AddLongArcimStr[("!"_ItmMastrowid_"^"))
	...s Subscript=$p(ItmMastrowid,"||",1)
	...s Version=$p(ItmMastrowid,"||",2)
	...s ARCIMDesc=$p(^ARCIM(Subscript,Version,1),"^",2)
	...s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
	...s FrequenceRowid=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",4)
	...s DurationRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",6)
	...s InstructionRowid=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",7)
	...s DoseQty=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",12) //数量
	...s ItemStat=$p($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	...s OrdStatus=""
	...s:$g(ItemStat)'="" OrdStatus=$p(^OEC("OSTAT",ItemStat),"^",1)  ;医嘱状态
	...i (OrdStatus="U")||(OrdStatus="D")||(OrdStatus="C") s stopflag="1" e  s stopflag="2"
	...s PhSpecInstr=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",8) //备注
	...s DoseUOM=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",3) 
	...s UnitPrice=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,2)),"^",4) //单价
	...s UnitPrice=##class(web.DHCDocOrderEntry).GetOrderPrice("", "", ItmMastrowid, "", "", "", "", "") 
	...s UnitPrice=$p(UnitPrice,"^",1)
	...s PHCINDesc=""
	...i InstructionRowid'="" s PHCINDesc=$p($p(^PHCIN(InstructionRowid),2),"^",2) //用法
	...s PHCINDesc=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",PHCINDesc,langid)
	...s DurationFactor=1
	...s DurationDesc=""
	...i DurationRowid'="" d
	....s DurationDesc=$p(^PHCDU(DurationRowid),"^",3)  //疗程
	....s DurationFactor=$p(^PHCDU(DurationRowid),"^",2)
	...s DurationDesc=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",DurationDesc,langid)
	...s amount=UnitPrice*DoseQty*DurationFactor
	...s je5=je5+amount
	...s je=amount_"/"_UnitPrice
	...s CTUOMDesc=""
	...if DoseUOM'="" s CTUOMDesc=$p(^CT("UOM",DoseUOM),"^",2) //剂量单位
	...s CTUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",CTUOMDesc,langid)
	...s PHCFRDesc=""
	...i FrequenceRowid'="" s PHCFRDesc=$p(^PHCFR(FrequenceRowid),"^",1) //名称
	...s PHCFRDesc=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",PHCFRDesc,langid)
	...s ArcimARCOSRowId=$p($g(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",10)
	...;q:ItmMastrowid="12558||1" 
	...s a(i)=ARCIMDesc_"!"_stopflag s i=i+1 s a(i)=DoseQty/DurationFactor s i=i+1 s a(i)=CTUOMDesc s i=i+1 s a(i)=ItmMastrowid_"!"_##class(DHCDoc.Util.Base).FormateNumber(a(i-2))_"!"_DoseUOM_"!"_PhSpecInstr_"!"_ArcimARCOSRowId_"!"_ARCOSRowId s i=i+1
	...;s b(2)="用药副数 "_DurationDesc_" 频率 "_PHCINDesc_" "_PHCFRDesc
	...i $g(cookmode)="代煎" d
	....s cookqty=##class(web.UDHCPrescriptQueryCM).GetDJFeeNumByPrescNo(prescno)          ;zhaozhiduan 20130109  获取代煎数
	....s b(2)=##class(websys.Translation).Get("opdoc.oeorder.cmpresclist.csp","用药副数 ")_DurationDesc_##class(websys.Translation).Get("opdoc.oeorder.cmpresclist.csp"," 频率  ")_PHCINDesc_" "_PHCFRDesc_##class(websys.Translation).Get("opdoc.oeorder.cmpresclist.csp"," 代煎 ")_cookqty_##class(websys.Translation).Get("opdoc.oeorder.cmpresclist.csp","付")
	...e  d
	....s b(2)=##class(websys.Translation).Get("opdoc.oeorder.cmpresclist.csp","用药副数 ")_DurationDesc_##class(websys.Translation).Get("opdoc.oeorder.cmpresclist.csp"," 频率 ")_PHCINDesc_" "_PHCFRDesc_" "_cookmode
	..s n4=i#16 
	..s num=1
	..if n4'=0 s m=i-n4/16 
	..i n4=0  s m=i/16-1
	..f y=1:1:m d
	...f n=y*16:1:y+1*16-1 d
	....i num>16 s num=1
	....s c(num)=$g(a(n))
	....s num=num+1
	....s a(n)=""
	...s x=x+1
	...i $p(c(4),"!",4)'="" s bz1="("_$p(c(4),"!",4)_")"
	...e  s bz1=""
	...i $p(c(8),"!",4)'="" s bz2="("_$p(c(8),"!",4)_")"
	...e  s bz2=""
	...i $p(c(12),"!",4)'="" s bz3="("_$p(c(12),"!",4)_")"
	...e  s bz3=""
	...i $p(c(16),"!",4)'="" s bz4="("_$p(c(16),"!",4)_")"
	...e  s bz4=""
	...d ReSetData
	...i c(6)'="" s c(6)=$fn(c(6),"",4)
	...i c(10)'="" s c(10)=$fn(c(10),"",4)
	...i c(14)'="" s c(14)=$fn(c(14),"",4)
	...s b1=$g(b(1)),c1=$p($g(c(1)),"!",1),c2=$fn($g(c(2)),"",4)_$g(c(3))_" "_$g(bz1),c3="",HiddenPara1=c(4),c5=$p($g(c(5)),"!",1),c6=c(6)_c(7)_" "_$g(bz2),c7="",HiddenPara2=c(8),c9=$p($g(c(9)),"!",1),c10=c(10)_c(11)_" "_$g(bz3),c11="",HiddenPara3=c(12),c13=$p($g(c(13)),"!",1),c14=c(14)_c(15)_" "_$g(bz4),c15="",HiddenPara4=c(16),b2=b(2),stopflag1=$p($g(c(1)),"!",2),stopflag2=$p($g(c(5)),"!",2),stopflag3=$p($g(c(9)),"!",2),stopflag4=$p($g(c(13)),"!",2)
	...q:stopflag1="1" //处方已停止
	...d OutputRow
	...s b(1)="",bz1="",bz2="",bz3="",bz4=""
	
	
	
 }
 Set qHandle=$lb(0,repid,0)
 quit $$$OK

OutputRow
	set Data=$lb(b1,c1,c2,c3,HiddenPara1,c5,c6,c7,HiddenPara2,c9,c10,c11,HiddenPara3,c13,c14,c15,HiddenPara4,je5,b2,prescno,$j,EpisodeID,stopflag1,stopflag2,stopflag3,stopflag4,$g(cookmodeDr),$g(cookmode))
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	quit	
ReSetData
   Set (b1,c1,c2,c3,HiddenPara1,c5,c6,c7,HiddenPara2,c9,c10,c11,HiddenPara3,c13,c14,c15,HiddenPara4,stopflag2,stopflag3,stopflag4)=""
   quit
}

ClassMethod searchFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = searchExecute ]
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
	s qHandle=$lb(AtEnd,repid,ind) //
	Quit $$$OK
}

Query ks(ks As %String, HospID As %String = "") As %Query(ROWSPEC = "ksdesc:%Library.String:科室,ksrowid:%Library.String:代码")
{
}

Query search(EpisodeID As %String, loc As %String, strdate As %Date, enddate As %String, PatientID As %String = "", SearchFlag As %String = "", LogonHospDr As %String = "") As %Query(ROWSPEC = "b1:%String,c1:%String,c2:%String,c3:%String,HiddenPara1:%String,c5:%String,c6:%String,c7:%String,HiddenPara2:%String,c9:%String,c10:%String,c11:%String,HiddenPara3:%String,c13:%String,c14:%String,c15:%String,HiddenPara4:%String,je5:%String,b2:%String,prescno:%String,$j:%String,EpisodeID:%String,stopflag1:%String,stopflag2:%String,stopflag3:%String,stopflag4:%String,cookmodeDr:%String,cookmode:%String")
{
}

/// w ##class(web.UDHCPrescriptQueryCM).GetsearchList(8432,194,62702,62702,3879)
ClassMethod GetsearchList(EpisodeID As %String, loc As %String, strdate As %Date, enddate As %String, UserID As %String) As %String
{
	s RtnStr=""
	i strdate="" s strdate=..%SysDate()
	i enddate="" s enddate=..%SysDate()
	
	s CurDocId=$p(^SSU("SSUSR",UserID),"^",14)
	Set rset=##class(%ResultSet).%New("web.UDHCPrescriptQueryCM:search")
	do rset.Execute(EpisodeID,loc,strdate,enddate)
	While (rset.Next()) {
		s b1=rset.Data("b1")
		s PrescNo=rset.Data("prescno")
		if (b1'="")&&(PrescNo'="") {
			s Que1Id=$O(^PAQUE1(0,"PrescNo",PrescNo,0))
			s DocId=$p($g(^PAQUE1(Que1Id)),"^",5)
			continue:CurDocId'=DocId
			i RtnStr="" s RtnStr=PrescNo
			e  s RtnStr=RtnStr_"^"_PrescNo
		}
	}
	d rset.Close()
	q RtnStr
}

/// 获取草药处方十八反信息
/// w ##class(web.UDHCPrescriptQueryCM).CheckCMPrescLimitInfo("")
ClassMethod CheckCMPrescLimitInfo(OrdRowID As %String) As %String
{
	q:OrdRowID="" ""
	s CheckARCIMRowID=$p($g(^OEORD(+OrdRowID,"I",$p(OrdRowID,"||",2),1)),"^",2)
	s FindOrdRowID=OrdRowID
	s LinkOrdRowID=$p($g(^OEORD(+OrdRowID,"I",$p(OrdRowID,"||",2),11)),"^",39)
	i LinkOrdRowID'="" s FindOrdRowID=LinkOrdRowID
	s FindARCIMRowIDALL=""
	s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"OEORI",+FindOrdRowID,FindOrdRowID,OrdSub)) q:OrdSub=""  d
 	.q:'$d(^OEORD(+FindOrdRowID,"I",OrdSub,1))
	.s ARCIMRowIDNew=$p($g(^OEORD(+FindOrdRowID,"I",OrdSub,1)),"^",2)
	.q:ARCIMRowIDNew=""
	.i FindARCIMRowIDALL="" s FindARCIMRowIDALL=ARCIMRowIDNew
	.e  s FindARCIMRowIDALL=FindARCIMRowIDALL_"^"_ARCIMRowIDNew
	q:FindARCIMRowIDALL="" ""
	s LimitFlag="N"
	s LimitInfo=##class(web.DHCDocOrderEntryCM).GetCMLimitInfo(CheckARCIMRowID,FindARCIMRowIDALL)
	i LimitInfo["反" s LimitFlag="Y"
	q LimitFlag
}

ClassMethod CheckBeforeUpdateCookMode(PrescNo As %String) As %String
{
	s ErrMsg=""
	s QueId=$O(^PAQUE1(0,"PrescNo",PrescNo,0))
	if (QueId="") {
		s ErrMsg=PrescNo_##class(websys.Translation).Get("opdoc.oeorder.cmpresclist.csp"," 处方不是草药处方！")
		Q ErrMsg
	}
	if $o(^BS.PHA.DEC.PMi("PRESCNO",PrescNo,""))'="" {
		s ErrMsg=PrescNo_##class(websys.Translation).Get("opdoc.oeorder.cmpresclist.csp"," 该处方已在煎药室收方，无法修改煎药方式！")
		Q ErrMsg
	}
	s ord=$o(^OEORD(0,"PrescNo",PrescNo,""),-1)
	Q:ord="" ""
	s chl=$o(^OEORD(0,"PrescNo",PrescNo,ord,""),-1)
	Q:chl="" ""
	s DMdsstatus=##class(web.DHCDocQryOEOrder).GetdsStatusDate(ord_"||"_chl)
	if (DMdsstatus="已发"){
		s ErrMsg=PrescNo_##class(websys.Translation).Get("opdoc.oeorder.cmpresclist.csp"," 该处方已发药，无法修改煎药方式！")
		Q ErrMsg
	}
	Q ErrMsg
}

/// 修改煎药方式
ClassMethod UpdateCookMode(PrescNo As %String, NewCookModeDr As %String, LogonInfo As %String, ByRef ErrMsg As %String = "") As %String
{
	//s logonInfo=LocId_"^"_GroupId_"^"_UserId_"^"_HospId 
	s ErrCode=0
	Q:PrescNo="" 0
	s QueId=$O(^PAQUE1(0,"PrescNo",PrescNo,0))
	if (QueId="") {
		s ErrCode=-1
		s ErrMsg=PrescNo_" 处方不是草药处方！"
		Q ErrCode_"^"_ErrMsg
	}
	if $o(^BS.PHA.DEC.PMi("PRESCNO",PrescNo,""))'="" {
		s ErrCode=-1
		s ErrMsg=PrescNo_" 该处方已在煎药室收方，无法修改煎药方式！"
		Q ErrCode_"^"_ErrMsg
	}
	/*s phd=##class(PHA.OP.COM.Method).GetPhdByPresc(PrescNo,"",Phl)
	s phdretid=$s(phd'="":$o(^DHCPHRETi(Phl,phd,""),-1),1:"")
	q:phdretid'="" "-4^该处方已存在退药信息，无需转换！"*/
	s ord=$o(^OEORD(0,"PrescNo",PrescNo,""),-1)
	Q:ord="" 0
	s AdmDr=$p(^OEORD(ord),"^",1)
	s chl=$o(^OEORD(0,"PrescNo",PrescNo,ord,""),-1)
	Q:chl="" 0
	s Moeori=##class(PHA.COM.Order).GetMainOeori(ord_"||"_chl)
	Q:Moeori="" 0
	s DMdsstatus=##class(web.DHCDocQryOEOrder).GetdsStatusDate(ord_"||"_chl)
	if (DMdsstatus="已发"){
		s ErrCode=-1
		s ErrMsg=PrescNo_" 该处方已发药，无法修改煎药方式！"
		Q ErrCode_"^"_ErrMsg
	}
	;判断是否是先发药后交费模式
	//s PayDispFlag=##class(PHA.OP.COM.Method).GetDispBeforePay(Moeori)
	s prescStr=##class(PHA.COM.Order).GetPaQueInfo(PrescNo)
	s Factor=+$p(prescStr,"^",2)
	s PrescForm=$p(prescStr,"^",8)
	s OrdBillTypeDr=$p(^OEORD(ord,"I",chl,11),"^",18)
	;插入新的煎药费之前将其他煎药费停止或者做退费申请
	s cookFeeOeoriStr=##class(PHA.FACE.IN.Method).GetHMCookLinkOrdStr(PrescNo)
	if cookFeeOeoriStr'="" {
		for feeNum=1:1:$l(cookFeeOeoriStr,"^") {
			s feeOrdItm=$p(cookFeeOeoriStr,"^",feeNum)
			s feeOrdId=+feeOrdItm
			s feeItm=$p(feeOrdItm,"||",2)
			s orderStat=$p($g(^OEORD(+feeOrdId,"I",feeItm,1)),"^",13)
			if orderStat'="" s statcode=$p($g(^OEC("OSTAT",orderStat)),"^",1)
			continue:(statcode'="V")&&(statcode'="E")&&(statcode'="")
			s billFlag=$p($g(^OEORD(+feeOrdId,"I",feeItm,3)),"^",5)
			i billFlag="P" {
				;已退费申请标志
				s reqFeeFlag=##class(web.DHCBillInterface).ICheckOrderIsRefAudit(feeOrdItm)
			    continue:reqFeeFlag="Y"	
				s ret=##class(PHA.FACE.IN.Com).HMFeeRefundRequest(feeOrdItm,LogonInfo)
				s err=+$p(ret,"^",1)
				i err'=0 {
					s ErrCode=-1
					s ErrMsg=PrescNo_ " 煎药费退费申请提交失败:"_$p(ret,"^",2)  
					Q
				}
			}elseif (billFlag="TB")||(billFlag="B") {	// 未缴费医嘱需停止
				s ret=##class(PHA.FACE.IN.Com).HMFeeStopOrder(feeOrdItm,LogonInfo)
				s err=+$p(ret,"^",1)
				i +err'=0 {
					s ErrCode=-1
					s ErrMsg=PrescNo_" 停煎药费医嘱失败:"_$p(ret,"^",2)
					Q 
				}
			}
		}
	}
	s StartDate=$p(^OEORD(ord,"I",chl,1),"^",9)
	s StartTime=$p(^OEORD(ord,"I",chl,1),"^",10)
	s preFeeArcimStr=##class(PHA.DEC.Com.Method).GetCookTypeAppendItm(NewCookModeDr,PrescNo)
	if (preFeeArcimStr'="") {
		s preFeeArim=$p($p(preFeeArcimStr,$c(1),1),"^",1)
		i preFeeArim'="" {
			s DocLocId=$$GetRecloc^DHCDocOrderCommonNew(AdmDr,preFeeArim)
		}
		s:$g(DocLocId)="" DocLocId=LocId
		s aricimLen=$l(preFeeArcimStr,$c(1))
		for j=1:1:aricimLen {
			s cookFeeStr=$p(preFeeArcimStr,$c(1),j)
			s arcimDr=$p(cookFeeStr,"^",1)
			continue:arcimDr=""
			s arcimQty=+$p(cookFeeStr,"^",2)
			i arcimQty=0 s arcimQty=1
			s bindSource=$p(cookFeeStr,"^",14)		//绑定来源
			s DoseUOMRowid=$p($g(^ARCIM(+arcimDr,$p(arcimDr,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
			if DoseUOMRowid="" {
				s Phcdf=$P($g(^ARCIM(+arcimDr,$P(arcimDr,"||",2),1)),"^",12)
				if Phcdf'="" s DoseUOMRowid=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
			}
			s DoseQtySum=arcimQty
			if (bindSource ="CMPTCMA") {
				//通过草药加工方式绑定的医嘱数量已做过换算不再乘疗程
				s DoseQty=arcimQty
			}else{
				s DoseQty=arcimQty/Factor
			}
			s ItemCatRowid=$p($g(^ARCIM(+arcimDr,$p(arcimDr,"||",2),1)),"^",10)
			s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
			if (OrderType'="R") {
				s INCIrow=##class(appcom.OEDispensing).GetINCI(+arcimDr)
				i INCIrow="" s arcimQty=""
			}
			s OrdItemStr=arcimDr_"^"_arcimQty_"^"_DocLocId_"^^^"_OrdBillTypeDr_"^^^^^"_bindSource_"^"_DoseQty_"^"_DoseUOMRowid_"^"_DoseQtySum_"^"_StartDate_"^"_StartTime
			s UserId=$p(LogonInfo,"^",3)
			s LocId=$p(LogonInfo,"^",1)
			s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserId)
			s CookStr=..InsertOrdItem(AdmDr,OrdItemStr,UserId,LocId,DoctorID,"")
			s Ret=$p(CookStr,"^$")
			if (Ret=0)||(Ret=100){
				s ErrCode=-1
				s ErrMsg=PrescNo_" 插入新的煎药费医嘱失败！"
				Q
			}
			s CookOeori=$p(CookStr,"*",2)
			s Ret=##class(PHA.OP.HMDisp.OperTab).UpdateCookOeori(CookOeori,Moeori)
			if (Ret'=0)  {
				s ErrCode=-1
				s ErrMsg=PrescNo_" 煎药费关联处方失败！"
				Q
			}
			
		}
	}
	s $p(^PAQUE1(QueId,"DHC"),"^",15)=NewCookModeDr
	Q ErrCode_"^"_ErrMsg
}

ClassMethod InsertOrdItem(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, DocUserId As %String, OSRID As %String = "") As %Status
{
	Set Ret=0, CMRet=0
	Set HospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(Loc)
	
	;区分草药医嘱及非草药医嘱
	Set OrdStr="",CMOrdStr=""
	Set Count=$l(OrdItemStr,$c(1))
	For ind=1:1:Count {
		Set OrdItem=$p(OrdItemStr,$c(1),ind)
		If (+OrdItem=0) Continue	
		Set OrderARCIMRowid=$p(OrdItem,"^",1)	;是	医嘱项指针(ARC_ItmMast)	aryEName[1]="OPOrdItemRowID"
		Set ItemCatDR=$p(^ARCIM($p(OrderARCIMRowid,"||",1),$p(OrderARCIMRowid,"||",2),1),"^",10)
		Set OrderType=$p(^ARC("IC",ItemCatDR),"^",7)	            //是	医嘱项类型代码(ARC_ItemCat->ARCIC_OrderType)	各级医嘱项取
		Set PriorityCode=$$ALPHAUP^SSUTIL4("NORM")
		Set OrderPriorRowid=$o(^OECPR(0,"Code",PriorityCode,""))	//医嘱优先级(OEC_Priority)
		
		;判断是否是草药医嘱
		Set IsHerbFlag=##class(web.DHCDocOrderCommon).IsCNMedItem(OrderARCIMRowid, HospId)
		If (IsHerbFlag=1){
			;草药
			//处方信息串
			Set OrderPriorRowid=OrderPriorRowid	//医嘱优先级(OEC_Priority)
			Set PrescDurRowid=""	//		疗程指针(PHC_Duration),指的草药副数
			Set PrescInstrRowid=""	//		用法指针(PHC_Instruc),指的草药使用方式
			Set PrescFreqRowid=""	//		频次指针(PHC_Freq)
			Set PrescCookMode=""	//		煎药方式(01 自煎, 02 代煎),传01或02
			Set PrescOrderQty=""	//		一次用量
			Set OrderRecDepRowid=$p(OrdItem,"^",3)	//	是	接收科室指针(CT_Loc)
			Set OrderBillTypeRowid=$p(OrdItem,"^",6)	//	是	费别指针(PAC_AdmReason)
			Set PrescNotes=""	     //备注
			Set PrescEmergency=""	 //加急
			Set PrescStartDate=$zd(CurrDate,4)	   //开始日期
			Set PrescStartTime=$zt(CurrTime,1)	   //开始时间
			Set ARCOSRowId=$p(OrdItem,"^",7)	   //医嘱套(ARC_OrdSets)
			Set OrderBindSource=$p(OrdItem,"^",11)   //绑定来源
			Set PrescWeight=""
			Set AddLongOrder=""
			set CMPrescTypeCode=""                 //草药处方类型
			
			//医嘱信息串
			Set OrderARCIMRowid=OrderARCIMRowid	//	是	医嘱项指针(ARC_ItmMast)
			Set OrderDoseQty=$p(OrdItem,"^",2)	//	是	单次剂量
			Set UOM=$p(OrdItem,"^",5) 
			Set OrderDoseUOMRowid=$s((UOM'=""):$o(^CT("UOM",0,"Code",$$UPPER^SSUTIL4(UOM),"")),1:"")   //单次剂量单位
			Set OrderPhSpecInstr=""	  //草药用法备注
			Set Phcdf=$p($g(^ARCIM(+OrderARCIMRowid,$P(OrderARCIMRowid,"||",2),1)),"^",12)
			Set billuomDr=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
			Set ConFac=##class(PHA.FACE.OUT.Com).UOMFac(OrderDoseUOMRowid, billuomDr)
			Set SumQty=OrderDoseQty*ConFac
			Set INCIPackCombStr=##class(web.DHCDocOrderEntryCM).CheckINCIPackSum(Adm, OrderARCIMRowid, OrderRecDepRowid, SumQty)
			Set INCIPackCombStr=$p(INCIPackCombStr,$c(2),2)
			//处方信息
			Set CFStr=OrderPriorRowid_"^"_PrescDurRowid_"^"_PrescInstrRowid_"^"_PrescFreqRowid_"^"_PrescCookMode	   ;1--5
			Set CFStr=CFStr_"^"_PrescOrderQty_"^"_OrderRecDepRowid_"^"_OrderBillTypeRowid_"^"_PrescNotes_"^"_PrescEmergency   ;6--10
			Set CFStr=CFStr_"^"_PrescStartDate_"^"_PrescStartTime_"^"_ARCOSRowId_"^"_PrescWeight_"^"_AddLongOrder       ;11--15
			Set CFStr=CFStr_"^"_CMPrescTypeCode    ;16
			
			//医嘱信息
			Set SingleOrderItemStr=OrderARCIMRowid_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid_"^"_OrderPhSpecInstr_"^^^"_INCIPackCombStr
			Set $p(SingleOrderItemStr,"^",14)=OrderBindSource
			
			If (CMOrdStr="") {
				Set CMOrdStr=CFStr_$c(2)_SingleOrderItemStr
			}Else{
				Set CMOrdStr=CMOrdStr_$c(1)_SingleOrderItemStr
			}
		}Else{
			;非草药
			Set OrderPriorRowid=OrderPriorRowid	;	是	医嘱优先级(OEC_Priority)	计费界面录入的默认均为“NORM 临时医嘱”
			Set OrderStartDate=$p(OrdItem,"^",15) ;	是	开始日期(格式: DD/MM/YYYY)	计费界面录入的医嘱日期默认当前日期
			Set OrderStartTime=$p(OrdItem,"^",16)	;	是	开始时间(格式: HH:MM)	计费界面录入的医嘱日期默认当前时间
			Set OrderPackQty=$p(OrdItem,"^",2)	;		医嘱数量	aryEName[4]="OPOrdQty"
			Set OrderPrice=$p(OrdItem,"^",4)	;		自定义价格	aryEName[3]="OPOrdPrice"
			Set OrderRecDepRowid=$p(OrdItem,"^",3)	;	是	接收科室指针(CT_Loc)	aryEName[11]="OPOrdItemRecLocRID"
			Set BillTypeRowid=$p(OrdItem,"^",6)	;	是	费别指针(PAC_AdmReason)	aryEName[17]="OPOrdInsRowId"
			Set OrderDrugFormRowid=""	;		药学关联指针(PHC_DrgForm) 	
			Set OrderDepProcNotes=""	;		备注	
			Set OrderDoseQty=$p(OrdItem,"^",12)	;		单次剂量	
			Set OrderDoseUOMRowid=$p(OrdItem,"^",13)	;		单次剂量单位	
			Set OrderQtySum=$p(OrdItem,"^",14)	    ;基本单位总数量	
			Set OrderFreqRowid=""	  ;频次指针(PHC_Freq)	
			Set OrderDurRowid=""	  ;疗程指针(PHC_Duration)	
			Set OrderInstrRowid	=""	  ;用法指针(PHC_Instruc)	
			Set PHPrescType	=""	     ;处方类型	
			Set OrderMasterSeqNo=""	  ;关联的主医嘱序号，数字型	
			Set OrderSeqNo=ind	      ;是	医嘱序号，数字型，根据OrderItemStr以$c(1)分割的顺序从1开始累加	计费组默认顺序号
			Set OrderSkinTest=""	    ;是否皮试（Y/N）	
			Set OrderPhSpecInstr=""	    ;草药用法备注	
			Set OrderCoverMainIns=""	;是否医保	
			Set OrderActionRowid=""	    ;皮试备注	
			Set OrderARCOSRowid=$p(OrdItem,"^",7)	 ;医嘱套(ARC_OrdSets)	aryEName[18]="OPOrdEnt"
			Set OrderBindSource=$p(OrdItem,"^",11)   ;绑定来源
			Set OrderEndDate=""	   ;预停日期(格式: DD/MM/YYYY)	
			Set OrderEndTime=""	   ;预停时间(格式: HH:MM)	
			Set SpecDesc=##class(web.DHCDocOrderCommon).GetLabSpec(OrderARCIMRowid)
			Set SpecDesc=$p(SpecDesc,$c(3),1)
			Set OrderLabSpecRowid=SpecDesc	;		标本指针(LAB.CT_TestSetSpecimen-> CTTSS_Specimen_DR)	
		 	Set SingleOrderItemStr=OrderARCIMRowid_"^"_OrderType_"^"_OrderPriorRowid_"^"_OrderStartDate_"^"_OrderStartTime	;1--5
		 	Set SingleOrderItemStr=SingleOrderItemStr_"^"_OrderPackQty_"^"_OrderPrice_"^"_OrderRecDepRowid_"^"_BillTypeRowid_"^"_OrderDrugFormRowid	;6--10
		 	Set SingleOrderItemStr=SingleOrderItemStr_"^"_OrderDepProcNotes_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid_"^"_OrderQtySum_"^"_OrderFreqRowid ;11-15
		 	Set SingleOrderItemStr=SingleOrderItemStr_"^"_OrderDurRowid_"^"_OrderInstrRowid_"^"_PHPrescType_"^"_OrderMasterSeqNo_"^"_OrderSeqNo ;16--20
		 	Set SingleOrderItemStr=SingleOrderItemStr_"^"_OrderSkinTest_"^"_OrderPhSpecInstr_"^"_OrderCoverMainIns_"^"_OrderActionRowid_"^"_OrderARCOSRowid ;21--25
		 	Set SingleOrderItemStr=SingleOrderItemStr_"^"_OrderEndDate_"^"_OrderEndTime_"^"_OrderLabSpecRowid ;26--28
			Set $p(SingleOrderItemStr,"^",58)=OrderBindSource
			
			If (OrdStr="") {
				Set OrdStr=SingleOrderItemStr
			}Else {
				Set OrdStr=OrdStr_$c(1)_SingleOrderItemStr
			}
		}
	}
	If (OrdStr'=""){
		Set Ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(Adm, OrdStr, User, Loc, DocUserId)	
	}
	If (CMOrdStr'=""){
		Set CMRet=##class(web.DHCOEOrdItem).SaveOrderItemsCM(Adm, CMOrdStr, User, Loc, DocUserId)	
	}
	If (Ret'=100)&&(CMRet=100){
		Set Ret=Ret	
	}
	If (Ret=100)&&(CMRet'=100){
		Set Ret=CMRet	
	}
	If (Ret'=100)&&(CMRet'=100){
		Set Ret=Ret_"^"_CMRet
	}
	
	Quit Ret
}

}
