Class web.DHCWLCFDrugInfor Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCWLCFDrugInfor","GetOPCFInfor","2019-02-01","2019-02-10","","")
/// Creator：      wch
/// CreatDate：    2023-2-23
/// Description:   门急诊处方用药明细
/// Input：        startDate:开始日期,endDate：结束日期  发药日期
/// 1医院名称、2处方唯一标识/处方号、3患者唯一标识、4医保号/院内就诊卡号、5患者性别、6出生日期、7特殊人群、8身高(cm)、9体重(kg)、10初复诊、11病人医保分类、12就诊日期
/// 13就诊类型、14就诊科室编码、15就诊科室、16处方医生执业证编号、17处方医生代码、18处方医生级别、19诊断、20描述性诊断、21药品编码（HISID）、22药品名称（商品名）
/// 23 药品名称（通用名）、24剂型、25规格、26包装、27生产厂家、28给药途径、29给药频率、30单次用量、31单次用量单位、32发药数量、33发药数量单位、
/// 34药品分组、35药品顺序、36药品金额（元）、37药品单价（元）、38药品单价单位、39处方金额（元）、40医保报销金额（元）、41报销情况、42药品医保编码  
/// Others：        
Query GetOPCFInfor(startDate As %String, endDate As %String, hospid As %String, admType As %String) As %Query(ROWSPEC = "HospDesc,mPrescNo,djh,mAdm,sex,birth,special,height,weight,admstatus,ybtype,admDate,admtype,loccode,locdesc,cfdocbm,cfdoccode,cfdocjb,diag,diagdesc,phCode,phName,geneName,drugForm,spec,bzunit,phm,instrdesc,freqdesc,doseqty,unitDesc,fyqty:%Float,fyunit,ypfz,ypsx,fyje:%Float,dj,djunit,cfje:%Float,ybbxje,bxqk,drugybbm") [ SqlProc ]
{
}

ClassMethod GetOPCFInforExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, hospid As %String, admType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	q:startDate="" $$$OK
	q:endDate="" $$$OK
 	k ^TEMPDHCWL($j)
	set startDate=$zdh(startDate,3)
	set endDate=$zdh(endDate,3)
    ;门诊发药
	f date=startDate:1:endDate d
	.s phLoc=0 
	.f  s phLoc=$o(^DHCPHDISPi("FYDATE",date,phLoc)) q:phLoc=""  d  ;DHC_PHDISPEN
	..s phId=0 
	..f  s phId=$o(^DHCPHDISPi("FYDATE",date,phLoc,phId)) q:phId=""  d
	...s PrescNo=$p(^DHCPHDISP(phId,2),"^",1)  //处方号
	...s phSub="" 
	...f  s phSub=$o(^DHCPHDI(phId,"PHDI",phSub)) q:(phSub="")  d
	....s oeori=$p($g(^DHCPHDI(phId,"PHDI",phSub)),"^",5)
	....s ord=+oeori
	....s ordSub=$p(oeori,"||",2)
	....s arcim=$p($g(^OEORD(ord,"I",ordSub,1)),"^",2)  ;医嘱项
	....s admId=$p(^OEORD(ord),"^",1)
	....s paadmType=$p(^PAADM(admId),"^",2)
	....q:(paadmType'="O")&&(paadmType'="E")
	....q:(admType'="")&&($find(","_admType_",",","_paadmType_",")=0)
	....s admLoc=$p($g(^OEORD(ord,"I",ordSub,7)),"^",2) ;开单科室 
    ....s hosp=$p(^CTLOC(admLoc),"^",22)
	....q:(hospid'="")&&($find(","_hospid_",",","_hosp_",")=0)
	....s phchildsub=0
	....f  s phchildsub=$o(^DHCPHDI(phId,"PHDI",phSub,"INCLB",phchildsub)) q:phchildsub=""  d  ;DHC_PHDISITMCLB--门诊配/发药孙表
	.....s qty=$p(^DHCPHDI(phId,"PHDI",phSub,"INCLB",phchildsub),"^",1)  ;发药数量
	.....s price=$p(^DHCPHDI(phId,"PHDI",phSub,"INCLB",phchildsub),"^",8)  ;售价金额
	.....s Sp=$p(^DHCPHDI(phId,"PHDI",phSub,"INCLB",phchildsub),"^",7)     ;批次售价
	.....s ^TEMPDHCWL($j,PrescNo,admId,oeori_"^"_Sp,"qty")=$g(^TEMPDHCWL($j,PrescNo,admId,oeori_"^"_Sp,"qty"))+qty
	.....s ^TEMPDHCWL($j,PrescNo,admId,oeori_"^"_Sp,"fee")=$g(^TEMPDHCWL($j,PrescNo,admId,oeori_"^"_Sp,"fee"))+price
    ;b ;001
    ;门诊退药
	f date1=startDate:1:endDate d
	.s phLoc1=0
	.f  s phLoc1=$o(^DHCPHRETi(date1,phLoc1)) q:phLoc1=""  d
	..;s Prescno=$p(^DHCPHREQ(phLoc1),"^",8)   //处方号
	..s phrId1=0
	..f  s phrId1=$o(^DHCPHRETi(date1,phLoc1,phrId1)) q:phrId1=""  d
	...s phId1=$p(^DHCPHRET(phrId1),"^",6)
	...s phrItem1="",price1=0
	...f  s phrItem1=$o(^DHCPHRTI(phrId1,"RTI",phrItem1)) q:phrItem1=""  d
	....s oeori1=$p(^DHCPHRTI(phrId1,"RTI",phrItem1),"^",2)
	....s ord=+oeori1
	....s ordSub=$p(oeori1,"||",2)
	....s Prescno=$p($g(^OEORD(ord,"I",ordSub,1)),"^",14)
	....s arcim1=$p($g(^OEORD(ord,"I",ordSub,1)),"^",2) ;医嘱项 指向：ARCItmMast
	....s admId=$p(^OEORD(ord),"^",1)  ;20130312 add
	....s paadmType=$p(^PAADM(admId),"^",2) ;20130312 add
	....q:(paadmType'="O")&&(paadmType'="E")
	....q:(admType'="")&&($find(","_admType_",",","_paadmType_",")=0)
	....s admLoc=$p($g(^OEORD(ord,"I",ordSub,7)),"^",2) ;开单科室 
    ....s hosp=$p(^CTLOC(admLoc),"^",22)
	....q:(hospid'="")&&($find(","_hospid_",",","_hosp_",")=0)
	....s price1=$p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",1)  ;退药金额
	....s qty1=$p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",3)  ;退药数量
	....s PRICE=$p($g(^DHCPHRTI(phrId1,"RTI",phrItem1)),"^",6)  
	....s ^TEMPDHCWL($j,Prescno,admId,oeori_"^"_PRICE,"qty")=$g(^TEMPDHCWL($j,Prescno,admId,oeori_"^"_PRICE,"qty"))-qty1
	....s ^TEMPDHCWL($j,Prescno,admId,oeori_"^"_PRICE,"fee")=$g(^TEMPDHCWL($j,Prescno,admId,oeori_"^"_PRICE,"fee"))-price1
	;b ;002	
	s mPrescNo=0
	f  s mPrescNo=$o(^TEMPDHCWL($j,mPrescNo)) q:mPrescNo=""  d ;02处方号
	.s mAdm=0
	.f  s mAdm=$o(^TEMPDHCWL($j,mPrescNo,mAdm)) q:mAdm=""  d  ;04就诊号
    ..s loc=$p(^PAADM(mAdm),"^",4)       ;科室
    ..s mhosp=$p(^CTLOC(loc),"^",22)
    ..s HospDesc=$p(^CT("HOSP",mhosp),"^",2)                        ;01医院名称
	..s papmidr=$p(^PAADM(mAdm),"^",1) 
    ..s djh=$p(^PAPER(papmidr,"PAT",1),"^",2)       ;03登记号
    ..s name=$p(^PAPER(papmidr,"ALL"),"^",1)        ;姓名
    ..s sex=$$GetSex^DHCWLCommon(papmidr)	        ;05性别
    ..s dob=$p(^PAPER(papmidr,"ALL"),"^",6)         ;06生日
    ..s birth=$zd(dob,3)
    ..s age=..CalAge(birth,+$h)
    ..s age=$p(age,"Y",1)			;年龄
    ..s special=""                                  ;07特殊人群
    ..s height=""                                   ;08身高
    ..s weight=""                                   ;09体重
    ..s admstatus=..GetAdmStatus(mAdm)              ;10初复诊
    ..s ybtype=""                                   ;11病人医保类别  
    ..s admDate=$p(^PAADM(mAdm),"^",6)	            ;12就诊日期 
    ..s admtype=$p(^PAADM(mAdm),"^",2)              ;13就诊类型
    ..i admtype="O" s admtype="门诊"
    ..i admtype="E" s admtype="急诊"
    ..s loccode=$p(^CTLOC(loc),"^",1)               ;14就诊科室代码
    ..s locdesc=$p(^CTLOC(loc),"^",2)               ;15就诊科室
    ..i locdesc["-" s locdesc=$p(locdesc,"-",2)
    ..e  s locdesc=locdesc
	..s cfdocbm=""                                  ;16处方医生执业证编号
	..s cfdoccode=""                                ;17处方医生代码
	..s cfdocjb=""                                  ;18处方医生级别
    ..s diag=$$GetMainDiag(mAdm)                    ;19主诊断 
    ..s diagdesc=""                                 ;20描述性诊断                           
    ..s mStr=0
    ..f  s mStr=$o(^TEMPDHCWL($j,mPrescNo,mAdm,mStr)) q:mStr=""  d
    ...s mOeori=$p(mStr,"^",1)
    ...s mArcim=$p($g(^OEORD(+mOeori,"I",$p(mOeori,"||",2),1)),"^",2) 
    ...s phcdf=$p($g(^ARCIM(+mArcim,1,1)),"^",12)
    ...q:+$G(phcdf)=0
    ...s phCode=$P($g(^PHCD(+phcdf,1)),"^",1)         ;21药品编码（HISID）
    ...s phName=$P($g(^PHCD(+phcdf,1)),"^",2)         ;21药品名称（商品名）
	...s genericDR=$P(^PHCD(+phcdf,4),"^",1) 
	...i genericDR'="" s geneName=$P($G(^PHCGE("GE",genericDR)),"^",2)    ;23通用名
	...e  s geneName=""
	...s PHCFiD=$p($g(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1)),"^",1)
 	...i PHCFiD'="" s drugForm=$p(^PHCF(PHCFiD),"^",2)                    ;24剂型
 	...e  s drugForm=""
 	...s spec=$$GetDrugSpec^DHCWLBulidDimDataYGYY001(mArcim)              ;25规格
 	...s bzunit=""                                                        ;26包装单位
 	...s phm=$$GetDrugphm^DHCWLBulidDimDataYGYY001(mArcim)                ;27生产厂家
 	...s instr=$p($g(^OEORD(+mOeori,"I",$P(mOeori,"||",2),2)),"^",7)
    ...i instr'="" s instrdesc=$p(^PHCIN(instr),"^",2)                    ;28给药途径
    ...e  s instrdesc=""
    ...s freq=$p($g(^OEORD(+mOeori,"I",$P(mOeori,"||",2),2)),"^",4)
    ...i freq'="" s freqdesc=$p(^PHCFR(freq),"^",3)                       ;29给药频率
    ...e  s freqdesc="" 
    ...s doseqty=$p($g(^OEORD(+mOeori,"I",$P(mOeori,"||",2),2)),"^",1)    ;30单次剂量
    ...s unit=$p($g(^OEORD(+mOeori,"I",$P(mOeori,"||",2),2)),"^",3)  
    ...i unit'="" s unitDesc=$p($g(^CT("UOM",unit)),"^",2)                ;31单次用量单位
    ...e  s unitDesc=""
    ...s fyqty=$g(^TEMPDHCWL($j,mPrescNo,mAdm,mStr,"qty"))                ;32发药数量
    ...s UnitDR=$p(^PHCD(+phcdf,"DF",1,2),"^",4) 
	...i UnitDR'="" s fyunit=$p(^CT("UOM",UnitDR),"^",2)                  ;33基本单位
	...s ypfz=0                                                           ;34药品分组默认0
	...s ypsx=1                                                           ;35药品顺序默认1
	...s fyje=$g(^TEMPDHCWL($j,mPrescNo,mAdm,mStr,"fee"))                 ;36发药金额
	...s dj=$p(mStr,"^",2)                                                ;37药品单价
	...s djunit=fyunit                                                    ;38药品单价单位
	...s cfje=$g(^TEMPDHCWL($j,mPrescNo,mAdm,mStr,"fee"))                 ;39处方金额
	...s ybbxje=""  ;40医保报销金额
	...s bxqk=""   ;41报销情况
	...s drugybbm=""  ;42药品医保编码 
    ...d OutPutRow
    k ^TEMPDHCWL($j) 
    Quit $$$OK
        
OutPutRow
 
    s Data=$lb(HospDesc,mPrescNo,djh,mAdm,sex,birth,special,height,weight,admstatus,ybtype,$zd(admDate,3),admtype,loccode,locdesc,cfdocbm,cfdoccode,cfdocjb,diag,diagdesc,phCode,phName,geneName,drugForm,spec,bzunit,phm,instrdesc,freqdesc,doseqty,unitDesc,fyqty,fyunit,ypfz,ypsx,fyje,dj,djunit,cfje,ybbxje,bxqk,drugybbm)
    s ^CacheTemp(repid,ind)=Data 
    s ind=ind+1
    q
  
GetMainDiag(mAdmid)
	s mReturn=""
	q:$G(mAdmid)="" $G(mReturn)
	k ^||TEMPDHCWLDrugFirst($j)
	s MRAdm=$p($g(^PAADM(mAdmid)),"^",61)
	q:$g(MRAdm)="" ""
	s Diag=0
	f  s Diag=$O(^MR(MRAdm,"DIA",Diag)) q:(Diag="")  d
	.Set DiagID=$P($g(^MR(MRAdm,"DIA",Diag)),"^",1)
	.s MainDiagFlag=$P($g(^MR(MRAdm,"DIA",Diag,1)),"^",20)
	.;q:MainDiagFlag="N"
	.s DiagTypeID=$o(^MR(MRAdm,"DIA",Diag,"TYP",0))
	.s TypeID="",TypeDesc=""
	.i DiagTypeID'="" s TypeID=$p($g(^MR(MRAdm,"DIA",Diag,"TYP",DiagTypeID)),"^",1)
	.i TypeID'="" s TypeDesc=$p($g(^MRC("DTYP",TypeID)),"^",2)
	.if DiagID'="" Set DiagDesc=$P($g(^MRC("ID",DiagID)),"^",2)
	.else  Set DiagDesc=$g(^MR(MRAdm,"DIA",Diag,"DES",1))  //1  1  2
	.i mReturn="" d
	..s mReturn=DiagDesc  //1
	..s ^||TEMPDHCWLDrugFirst($j,DiagDesc)=1   //1  
	.e  d
	..i '$d(^||TEMPDHCWLDrugFirst($j,DiagDesc)) d
	...s mReturn=mReturn_","_DiagDesc
	..e  d
	...s mReturn=mReturn  //1
	q $G(mReturn)
}

ClassMethod GetOPCFInforClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPCFInforExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetOPCFInforFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPCFInforExecute ]
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

/// 初复诊
ClassMethod GetAdmStatus(AEpisodeID) As %Status
{
	s admstatus = $P(^PAADM(AEpisodeID),"^",40)
	if (admstatus = "Admission")
	{
		s admstatus = "初诊"
	}
	elseif (admstatus = "Readmission")
	{
		s admstatus = "复诊"
	}
	elseif (admstatus = "OpReadmission")
	{
		s admstatus = "术后复诊"
	}
	q admstatus
}

/// 根据出生日计算年龄
ClassMethod CalAge(mIBirth, mIToday) As %Status
{
    s mIBirth=$g(mIBirth),mIToday=$g(mIToday)
    i mIBirth>2980000 s mIBirth=""
    i mIBirth<0 s mIBirth=""
    q:'$g(mIBirth) ""
    s xBirth=$zd(mIBirth)
    s xToday=$zd(mIToday)
    s ageMth=xToday-xBirth
    s ageDay=$p(xToday,"/",2)-$p(xBirth,"/",2)
    s mCurrYear=$p(xToday,"/",3) s:mCurrYear<100 mCurrYear=mCurrYear+1900
    s mBirthYear=$p(xBirth,"/",3) s:mBirthYear<100 mBirthYear=mBirthYear+1900
    s ageYear=mCurrYear-mBirthYear
    i ageDay<0 d
    . s ageMth=ageMth-1
	. s ageDay=ageDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+xToday)
	. q:xToday'=2
	. s:((mCurrYear#4)=0)&(((mCurrYear#100)'=0)!((mCurrYear#400)=0)) ageDay=ageDay+1
	i ageMth<0 s ageMth=ageMth+12,ageYear=ageYear-1
	s $p(AgeYr,"|",12)=ageYear
	s reage=$p(AgeYr,"|",12)_"Y "_ageMth_"M "_ageDay_"D"
	q reage
}

}
