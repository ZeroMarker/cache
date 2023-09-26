/// CTOR: QP
/// DATE: 2017-05-05
/// DESC: 抗菌药物报表-国家政策等相关类库
Class DHCAnt.QRY.RAQ.NationalPolicy Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator：     cb
/// CreatDate：   2017-04-22
/// Description:  医疗机构碳青霉烯类抗菌药物以及替加环素的使用情况信息表。
/// Table：       
/// Input：开始日期（StDate）、结束日期（EndDate）、科室（Loc）、抗菌药物（Mode）
/// Output:用药病人信息：通用名(ARCIMAbbrev)、姓名(PatName)
///        用药信息：病历号(PatNo)、用药主要诊断(KssDia)、药物用法(KssInstr)、感染性疾病科是否会诊(IsConsultation)、使用前是否微生物送检(IsMicSub)、是否紧急情况下使用(IsEmergency)、处方药师(Prescription)、处方时间(PrescTime)
/// 		   审方药师：(Apothecary) 
///        KssName,PatName,PatNo,KssDia,KssUse,IsConsultation,IsMicSub,IsEmergency,Prescription,PrescTime,Apothecary
/// D ##class(%ResultSet).RunQuery("web.ChkKSS","KSSUseInfo","2017-01-01","2017-01-10","","1")
Query QryCqmxTgc(StDate As %String, EndDate As %String, Loc As %String, Mode As %String) As %Query(ROWSPEC = "ARCIMAbbrev:%String,PatName:%String,PatNo:%String,KssDia:%String,KssInstr:%String,IsConsultation:%String,IsMicSub:%String,IsEmergency:%String,Prescription:%String,PrescTime:%String,Apothecary:%String,label:%String,DoseQty:%String,freqdesc:%String,unitdesc:%String,arcimdesc:%String") [ SqlProc ]
{
}

ClassMethod QryCqmxTgcExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, Loc As %String, Mode As %String) As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
 	
 	s StDate=$zdh(StDate,3),EndDate=$zdh(EndDate,3)
	s KssName="",PatName="",PatNo="",KssDia="",KssInstr="",IsConsultation="",IsMicSub="",IsEmergency="",Prescription="",PrescTime="",Apothecary="",AARowid=""
	s KssDiaDr="",Date="",Apothecary1="",PCNTSRowID="",PCNTSIChildSub="",PCNTSLChildSub="",ConLocDr="",ConDocDr="",fyuserdr="",DHCOEDisRowid="",freqdesc=""
	f Date=StDate:1:EndDate d 
	.s DAUPRowid=0
	.f  s DAUPRowid=$o(^DAUP("Date",Date,DAUPRowid)) q:DAUPRowid=""  d
	..s Oeori=$p(^DAUP("DAUP",DAUPRowid),"^",3)
	..q:Oeori=""
	..;s Submission=$p(^DAUP("DAUP",DAUPRowid),"^",15)
	..s Submission=$$ComIsSubmission^DHCANTQryKPICommon(Oeori)
	..i Submission="1" s IsMicSub="是" ;微生物送检
	..e  d  s IsMicSub="否"
	..s ARCItmMastDr=$p(^DAUP("DAUP",DAUPRowid),"^",21)
	..s mRtn=##class(DHCAnt.KSS.Prj.Common).ComIsCqmxOrTgc(ARCItmMastDr,Mode) ;过滤非碳青霉烯类
	..q:mRtn'=1
	..s arcimdesc=$p(^ARCIM(+ARCItmMastDr,$p(ARCItmMastDr,"||",2),1),"^",2)
	..s label=$$PHCCAT(ARCItmMastDr)
	..s ARCIMAbbrev=$$GetGenericName^DHCANTQryKPICommon(Oeori) ;通用名
	..s DoseQty=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),2),"^",1)    ;剂量
	..s unitdr=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),2),"^",3)      ;单位
	..S unitdesc=$p(^CT("UOM",unitdr),"^",2)
	..s freqdr=$p($g(^OEORD(+Oeori,"I",$p(Oeori,"||",2),2)),"^",4)    ;频次
	..if freqdr'=""  s freqdesc=$p(^PHCFR(freqdr),"^",4)
	..s Admdr=$p(^DAUP("DAUP",DAUPRowid),"^",2)
	..s AdmType=$p(^PAADM(Admdr),"^",2)
	..s dep=$p(^PAADM(Admdr),"^",4)
	..Q:(Loc'="")&&(","_Loc'[(","_dep_","))    ;过滤科室
	..s PapmiDr=$p(^PAADM(Admdr),"^",1)
	..s PatName=$p(^PAPER(PapmiDr,"ALL"),"^",1) ;姓名
	..s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(Admdr)
	..s ErrMsg=""
	..s PatNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(Admdr,AdmType,.ErrMsg) ;病历号
	..s InstrDR=$p(^OEORD((+Oeori),"I",($p(Oeori,"||",2)),2),"^",7)
	..s:InstrDR'="" KssInstr=$P($g(^PHCIN(InstrDR)),"^",2) //用法
	..s AARowid=$o(^DHCDAAi(0,"OEORI",Oeori,0))
	..i AARowid'=""  d
	...s IsEmergency=$p(^DHCDAA("ANT",AARowid,1),"^",23) ;越级
	...i IsEmergency=1 s IsEmergency="是"
	...e  d  s IsEmergency="否"
	..s OrderDocDr=$p(^OEORD(+Oeori,"I",($p(Oeori,"||",2)),1),"^",11)
	..s Prescription=$p(^CTPCP(OrderDocDr,1),"^",2)            //处方医师
	..s OrderDate=$p(^OEORD(+Oeori,"I",($p(Oeori,"||",2)),3),"^",7)
	..s PrescTime=$zd(OrderDate,3) ;处方时间
	..//取主要诊断
	..s tmpMainDiag =##class(DHCAnt.QRY.Common.Method).GetMainDiagnos(Admdr)
	..i tmpMainDiag'="" d 
	...i $l(tmpMainDiag,"!")>1
	...s tmpMainDiag=$p($g(tmpMainDiag),"!",$l(tmpMainDiag,"!"))
	...s MainDiagDict=$p($g(tmpMainDiag),"^",1)
	...s MainDiagDesc=$p($g(tmpMainDiag),"^",3)
	...s KssDia=MainDiagDesc
    ..s DSPRowid=$o(^DHCOEDISQTY(0,"OEORI",Oeori,0))
    ..s DSPUser=$P(^DHCOEDISQTY(DSPRowid),"^",10)
    ..s:DSPUser'="" Apothecary=$p(^SSU("SSUSR",DSPUser),"^",2)
	..;是否感染科室会诊
	..s:ConLocDr'="" ConLocDr=$p(^DHCDAA("ANT",AARowid,1),"^",4)
	..s:ConDocDr'="" ConDocDr=$p(^DHCDAA("ANT",AARowid,1),"^",5)
	..s IsConsultation=##class(DHCAnt.KSS.Prj.Common).ComIsInfectDep(ConLocDr,ConDocDr)
	..i IsConsultation'=0 s IsConsultation="是"
	..e  d  s IsConsultation="否"
	..d output
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
PHCCAT(Arcdr)    //取药学项和商品名    Arcdr 医嘱项名称   yx
                 //out  药学分类^药学名
                 //w $$PHCCAT^DHCWLCommon("13||1")
 S ArcSub=$P(Arcdr,"||",1)
 S ArcVer=$P(Arcdr,"||",2)
 Q:ArcSub="" ""
 Q:ArcVer="" ""
 S PhcFormdr=$P(^ARCIM(ArcSub,ArcVer,1),"^",12)
 Q:PhcFormdr="" ""
 S PHCD=$P(PhcFormdr,"||",1)
 Q:PHCD="" ""
 Q:'$D(^PHCD(PHCD)) ""
 S Label1=$P(^PHCD(PHCD,2),"^",7)	//商品名
 s phcname=$P(^PHCD(PHCD,1),"^",2)   //药学项名
 //药学项PHC_DrgMast,PHC_DrgForm
 s phcsc=$P(^PHCD(PHCD,1),"^",3)	//药学子分类PHC_SubCat
 s phccat=$P(phcsc,"||")	//药学分类PHC_Cat
 q Label1
output
	Set Data=$lb(ARCIMAbbrev,PatName,PatNo,KssDia,KssInstr,IsConsultation,IsMicSub,IsEmergency,Prescription,PrescTime,Apothecary,label,DoseQty,freqdesc,unitdesc,arcimdesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryCqmxTgcClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryCqmxTgcExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryCqmxTgcFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryCqmxTgcExecute ]
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

/// 科室信息
/// D ##class(%ResultSet).RunQuery("web.ChkKSS","GetCtloc")
ClassMethod GetCtlocExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
    
    s flag=0
    f  s flag=$o(^PAC("ADMLOC",0,"AdmType",flag))  q:flag=""   d 
    .s loc=0
    .f  s loc=$o(^PAC("ADMLOC",0,"AdmType",flag,loc))  q:loc=""   d 
    ..i $d(^CTLOC(loc)) d
    ...s desc=$P($G(^CTLOC(loc)),"^",2) 
    ...i desc [ "-" s depDesc=$p(desc,"-",2)
    ...e  s depDesc=desc
    ...d OutputRow2
   
 	q $$$OK	

OutputRow2
    i flag="I" s type="住院科室"
    i flag="O" s type="门诊科室"
    i flag="E" s type="急诊科室"
    s Data=$lb(type,loc,depDesc)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCtlocExecute ]
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

ClassMethod GetCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCtlocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetCtloc() As %Query(ROWSPEC = "type:%String,loc:%String,depDesc:%String") [ SqlProc ]
{
}

/// 科室信息
/// D ##class(%ResultSet).RunQuery("web.ChkKSS","GetMode")
ClassMethod GetModeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
  	s Mode=1 s type="碳青霉烯类抗菌药物"  d OutputRow3
  	s Mode=2 s type="替加环素类"          d OutputRow3
  	s Mode=3 s type="碳青霉烯类抗菌药物和替加环素类"  d OutputRow3
   
   
 	q $$$OK	

OutputRow3
    
    s Data=$lb(Mode,type)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetModeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetModeExecute ]
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

ClassMethod GetModeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetModeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetMode() As %Query(ROWSPEC = "Mode:%String,type:%String") [ SqlProc ]
{
}

}
