Class web.DHCANOPRiskAssessment Extends %RegisteredObject
{

/// Creator: YuanLin
/// CreatDate: 2016-06-25
/// Description: 获取病人的基本信息
/// Input： 手术申请ID
/// Return：返回病人姓名^性别^年龄^科室^床号^住院号^手术名称
/// w ##class(web.DHCANOPRiskAssessment).GetPatientInfo(80)
ClassMethod GetPatientInfo(opaId) As %String
{
	q:opaId="" ""
	s PatName="",PatSex="",PatAge="",Locdes="",BedNo="",MedCareNo="",Opdes=""
	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$p(anaId,"||",2)
	s PatientID=+^PAADM(EpisodeID)
	i PatientID'="" d
		.s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)							   //姓名
		.s PatSex=$p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)	   //性别
	    .;s MedCareNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",22)                          //住院号
	    .s paadmtype=$p($g(^PAADM(+EpisodeID)),"^",2)
	    .s MedCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
		.s birth=$p($g(^PAPER(PatientID,"ALL")),"^",6)
		.;i birth'="" d							
	    .;.s PatAge=..CalAge(birth,+$h)	
	    .;新版年龄统一从计费接口走+20160922+dyl
	    .s PatAge=##class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID)				   //年龄
    s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
	s Locdes=$P($g(^CTLOC(appLocId)),"^",2)                                        //科室
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
	i (bedSub'="")&(curWardId'="") d
	.s BedNo=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)                         //床号
	s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")  d
	.s opdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",6)
	.i opdr'="" d
	..s patopdes=$P($g(^ORC("OPER",opdr)),"^",2)
	..i Opdes'="" s Opdes=Opdes_","_patopdes
	..e  s Opdes=patopdes
	s ret=PatName_"^"_PatSex_"^"_PatAge_"^"_Locdes_"^"_BedNo_"^"_MedCareNo_"^"_Opdes
	q ret
}

/// Creator: YuanLin
/// CreatDate: 2016-06-25
/// Description: 获取病人的手术风险评估信息
/// Input： 手术申请ID
/// Return：手术切口清洁度^麻醉分级^手术持续时间^手术类别^切口愈合与感染情况^手术医生签名^麻醉医师签名^巡回护士签名^手术切口清洁度分^麻醉分级分^手术持续时间分^总分^NNIS级数
/// w ##class(web.DHCANOPRiskAssessment).GetRiskAssessmentInfo(55)
ClassMethod GetRiskAssessmentInfo(opaId)
{
	//20161028+dyl
	q:opaId="" ""
	s codeStr="opBladeType^ASAClass^OpTimes^comOPType^Infected^opDocSign^anDocSign^circleNurseSign^Infectedscore^ASAscore^OpTimesScore^SumScore^NNISRate"
	s RetStr=""
	f i=1:1:$l(codeStr,"^") d
		.s code=$p(codeStr,"^",i)
		.q:code=""
		.s extendId=$o(^DHCANOPArrangeExtend(0,"OPACode",opaId,code,""))
		.i extendId="" d
			..i RetStr="" s RetStr=code_":"_""
			..e  s RetStr=RetStr_"^"_code_":"_""
		.e  d
			..s userId=$li(^DHCANOPArrangeExtend(extendId),2)
			..s date=$li(^DHCANOPArrangeExtend(extendId),3)
			..s time=$li(^DHCANOPArrangeExtend(extendId),4)
			..s value=$li(^DHCANOPArrangeExtend(extendId),6)
			..s prevalue=$li(^DHCANOPArrangeExtend(extendId),7)
			..s date=##class(web.DHCANOPCom).ConvertToDateH(date,$H)
			..s time=##class(web.DHCANOPCom).ConvertToTimeH(time,$H)	
			..i RetStr="" s RetStr=code_":"_value
			..e  s RetStr=RetStr_"^"_code_":"_value
	q RetStr
}

/// Creator: YuanLin
/// CreatDate: 2016-06-25
/// Description: 保存手术风险评估信息
/// Input1： opaId:手术申请ID
/// Input2： paraStr:"opBladeType"+"$"+opBladeType+"^"+"ASAClass"+"$"+ASAClass+"^"+"OpTimes"+"$"+OpTimes+"^"+"comOPType"+"$"+comOPType+"^"+"Infected"+"$"+Infected+"^"+"opDocSign"+"$"+opDocSign+"^"+"anDocSign"+"$"+anDocSign+"circleNurseSign"+"$"+circleNurseSign+"Infectedscore"+"$"+Infectedscore+"^"+"ASAscore"+"$"+ASAscore+"^"+"OpTimesScore"+"$"+OpTimesScore+"^"+"SumScore"+"$"+SumScore+"^"+"NNISRate"+"$"+NNISRate"
/// Input3:  userId
/// Return：返回值
/// w ##class(web.DHCANOPRiskAssessment).SaveOrder()
ClassMethod SaveOrder(opaId, paraStr, userId)
{
	q:opaId="" "-1^opaId is null"
	q:userId="" "-2^userId is null"
	
	s result="",tempResult=""
	f i=1:1:$l(paraStr,"^") d
		.s para=$p(paraStr,"^",i)
		.q:para=""
		.s code=$p(para,"$",1)
		.s value=$p(para,"$",2)
		.i code'="" d
			..s rowId=$o(^DHCANC("OPArrangeExtend",0,"Code",code,""))
			..i rowId'="" d
				...s retult=..SaveSingleArrangeExtend(opaId,code,value,userId)
				...i +retult<0 s result=result_retult_"^"
			..e  d
				...s tempResult=tempResult_code_"^"

	q result
}

ClassMethod SaveSingleArrangeExtend(opaId, code, value, userId)
{
	q:opaId="" "-1^opaId is null"
	q:userId="" "-2^userId is null"
	q:code="" "-3^code is null"

	s date=+$h,time=$p($h,",",2)
	s prevalue=""
	s ExtendRowId=$o(^DHCANOPArrangeExtend(0,"OPACode",opaId,code,"")) 
	i ExtendRowId="" s obj=##class(User.DHCANOPArrangeExtend).%New()
	e  d
	.s obj=##class(User.DHCANOPArrangeExtend).%OpenId(ExtendRowId)
	.s prevalue=obj.ANOPAEValue
	
	q:prevalue=value ExtendRowId  //值不改变的 不保存
	
	s obj.ANOPAEANCOPAECode=code
	s obj.ANOPAEOPADr=opaId
	s obj.ANOPAEValue=value
	s obj.ANOPAEUserDr=userId
	s obj.ANOPAEUpdateDate=date
	s obj.ANOPAEUpdateTime=time
	s obj.ANOPAEPreValue=prevalue
	
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "-4^数据保存失败!"_code
	s RowId=obj.%Id()
	d obj.%Close()

	q RowId
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String) As %String
{
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$G(IBirth) ""
    s XBirth=$ZD(IBirth)
    s XToday=$ZD(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $P(AgeYr,"|",12)=AgeYear
	//s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	i $p(AgeYr,"|",12)>0 s reage=$p(AgeYr,"|",12)_"岁"
	e  d
	.i AgeMth>0 s reage=AgeMth_"月"
	.e  d
	..s reage=AgeDay_"天"
	q reage
}

// 手术切口清洁度

Query OPIncisionType() As %Query(ROWSPEC = "TypeId,TypeDesc,TypeValue")
{
}

ClassMethod OPIncisionTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s TypeDesc="Ⅰ类切口",TypeId=1,TypeValue=0
    d outputTy
    s TypeDesc="Ⅱ类切口",TypeId=2,TypeValue=0
    d outputTy
    s TypeDesc="Ⅲ类切口",TypeId=3,TypeValue=1
    d outputTy
    s TypeDesc="Ⅳ类切口",TypeId=4,TypeValue=1
    d outputTy
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputTy
 set Data=$lb(TypeId,TypeDesc,TypeValue)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod OPIncisionTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPIncisionTypeExecute ]
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

ClassMethod OPIncisionTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPIncisionTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 麻醉分级(ASA分级)

/// d ##class(%ResultSet).RunQuery("web.DHCANOPRiskAssessment","OPASAClass")
Query OPASAClass() As %Query(ROWSPEC = "TypeId,TypeDesc,TypeValue")
{
}

ClassMethod OPASAClassExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s TypeDesc="P1",TypeId=1,TypeValue=0
    d outputTy
    s TypeDesc="P2",TypeId=2,TypeValue=0
    d outputTy
    s TypeDesc="P3",TypeId=3,TypeValue=1
    d outputTy
    s TypeDesc="P4",TypeId=4,TypeValue=1
    d outputTy
    s TypeDesc="P5",TypeId=5,TypeValue=1
    d outputTy
    s TypeDesc="P6",TypeId=6,TypeValue=1
    d outputTy
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputTy
 set Data=$lb(TypeId,TypeDesc,TypeValue)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod OPASAClassFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPASAClassExecute ]
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

ClassMethod OPASAClassClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPASAClassExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 手术持续时间

/// d ##class(%ResultSet).RunQuery("web.DHCANOPRiskAssessment","OpTimes")
Query OpTimes() As %Query(ROWSPEC = "Id,Desc,Value")
{
}

ClassMethod OpTimesExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s Desc="T1",Id=1,Value=0
    d outputTy
    s Desc="T2",Id=2,Value=1
    d outputTy
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputTy
 set Data=$lb(Id,Desc,Value)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod OpTimesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OpTimesExecute ]
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

ClassMethod OpTimesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OpTimesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 手术类别

Query GetOPType() As %Query(ROWSPEC = "Id,Desc")
{
}

ClassMethod GetOPTypeExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s Desc="浅层组织手术",Id=1
    d outputop
    s Desc="深部组织手术",Id=2
    d outputop
    s Desc="器官手术",Id=3
    d outputop
    s Desc="腔隙手术",Id=4
    d outputop
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputop
 set Data=$lb(Id,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetOPTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOPTypeExecute ]
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

ClassMethod GetOPTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOPTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 切口愈合与感染情况

Query GetInfected() As %Query(ROWSPEC = "Id,Desc")
{
}

ClassMethod GetInfectedExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s Desc="甲级愈合",Id=1
    d outputInf
    s Desc="浅层感染",Id=2
    d outputInf
    s Desc="深层感染",Id=3
    d outputInf
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputInf
 set Data=$lb(Id,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetInfectedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInfectedExecute ]
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

ClassMethod GetInfectedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInfectedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
