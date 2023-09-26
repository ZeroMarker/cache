Class DHCDoc.Interface.Inside.Drgs.MainPort Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 此两个属性视DIP分配给项目的值，由项目修改
/// 支付类型
Parameter PayType = 1;

/// 标杆年份
Parameter StDate = "2022-11";

/// 获取最新存储的Drgs信息
/// w ##class(DHCDoc.Interface.Inside.Drgs.MainPort).getMesFromDrgs(1593)
ClassMethod getMesFromDrgs(EpisodeID) As %String
{
	s rowid=$O(^Doc.Interface.Drgs.MesageI("ADM",EpisodeID,""),-1)
	if +rowid=0 {
		d ..SendtoDrgs(EpisodeID)
		s rowid=$O(^Doc.Interface.Drgs.MesageI("ADM",EpisodeID,""),-1)
	}
	Q:+rowid=0 ""
	s rtnJson=$listget($G(^Doc.Interface.Drgs.MesageD(rowid)),4)
	q rtnJson
}

/// 获取智能分组详情界面URL
/// w ##class(DHCDoc.Interface.Inside.Drgs.MainPort).GetDrgsDetailUrl(1593)
ClassMethod GetDrgsDetailUrl(EpisodeID As %String) As %String
{
	//智能分组有可能会刷新链接，这里先调用一次
	d ..SendtoDrgs(EpisodeID)
	s rowid=$O(^Doc.Interface.Drgs.MesageI("ADM",EpisodeID,""),-1)
	Q:+rowid=0 ""
	s rtnJson=$listget($G(^Doc.Interface.Drgs.MesageD(rowid)),4)
	q:(rtnJson="") ""
	s jsonResult=##Class(DHCDoc.Util.FromJSON).%FromJSON(rtnJson)
	q:(jsonResult.Data("result_data")="") ""
	s URL=jsonResult.Data("result_data").Data("DETAIL_URL")
	q:(URL="") ""
	s DrgsUrl=##Class(DHCDoc.Interface.Inside.Drgs.PreGroupChsWebServicePort).#LOCATION
	s DrgsUrl=$P(DrgsUrl,"/",1,3)
	s URL=DrgsUrl_URL
	q URL
}

ClassMethod getMesToDrgs(EpisodeID) As %String
{
	s rowid=$O(^Doc.Interface.Drgs.MesageI("ADM",EpisodeID,""),-1)
	Q:+rowid=0 ""
	s rtnJson=$listget($G(^Doc.Interface.Drgs.MesageD(rowid)),3)
	q rtnJson
}

/// 下载Drg信息
/// w ##class(DHCDoc.Interface.Inside.Drgs.MainPort).SendtoDrgs(302)
ClassMethod SendtoDrgs(EpisodeID) As %String
{
	s $ZT="SendtoDrgsErr"
	s patid=$p($g(^PAADM(EpisodeID)),"^",1)
	s mradm=$p($g(^PAADM(EpisodeID)),"^",61)
	s admtype=$P(^PAADM(EpisodeID),"^",2)
	s admdate=$p($g(^PAADM(EpisodeID)),"^",6)
	s DisChargeDate=+$p($g(^PAADM(EpisodeID)),"^",59) ;结算日期
	s IsDeceased=##Class(web.PAPerson).CheckDeceased(patid) ;死亡标志
	s:DisChargeDate=0 DisChargeDate=+$H
	s AdmDateNum=(DisChargeDate-admdate)
	s:AdmDateNum<=0 AdmDateNum=1
	s MRNo=##class(web.DHCDocOrderCommon).GetMrNo(EpisodeID,"",admtype,"")
	s total=$P(##class(web.DHCNurIpComm).NurPatInfo(EpisodeID),"^",7)
	s outtype=""
	if (DisChargeDate>0){s outtype=1} ;医嘱出院
	if (IsDeceased="Y"){s outtype=5} ;死亡出院
	s Age=+$p(^PAPER(patid,"ALL"),"^",6)
	s Age=$p(((+$H-Age)/365)+0.5,".")
	Set Sex=$p(^CT("SEX",$p(^PAPER(patid,"ALL"),"^",7)),"^",2)
	if (Sex["男"){s Sex=1}else{s Sex=2}
	;d getDia()
	d getOPList()
	s dialist=##class(%DynamicArray).%New()
	s DiagInfo=..GetMRDiagnos(mradm,.dialist)
	s mainmrdia=$lg(DiagInfo,1)
	s mainmrdiaDesc=$lg(DiagInfo,2)
	s diaglength=$lg(DiagInfo,3)
	if (+diaglength=0)&&(mainmrdia="") q "0^"
	
	;入参
	s jsonparam={}
	d jsonparam.%Set("CASE_ID",MRNo)
	d jsonparam.%Set("AGE",Age)
	d jsonparam.%Set("TOTAL_EXPENSE",total) ;费用
	d jsonparam.%Set("ACCTUAL_DAYS","50") ;入院天数
	d jsonparam.%Set("SF0108",outtype) ;离院方式
	d jsonparam.%Set("SF0100","") ;新生儿年龄天
	d jsonparam.%Set("SF0102","") ;新生儿体重克
	d jsonparam.%Set("SF0104","") ;呼吸机使用时间小时
	d jsonparam.%Set("DISEASE_CODE",mainmrdia) ;主诊断
	d jsonparam.%Set("DISEASE_NAME",mainmrdiaDesc) ;主诊断描述
	d jsonparam.%Set("GENDER",Sex) ;性别
	d jsonparam.%Set("DIAGS_CODE",dialist) ;其他诊断
	d jsonparam.%Set("OPERS_CODE",oprationlist) ;手术
	d jsonparam.%Set("ICU","") ;ICU小时数
	d jsonparam.%Set("CRRT","") ;血液净化小时数
	d jsonparam.%Set("PDT","") ;透析次数
	d jsonparam.%Set("STD_YEAR",..#StDate)        ;$P($ZD(+$H,3),"-",1)) ;标杆年份
	d jsonparam.%Set("PAY_TYPE",..#PayType)       ; "01") ;支付类型
	s jsonstr=jsonparam.%ToJSON()
	
	//调用Drgs接口
	s Obj=##Class(DHCDoc.Interface.Inside.Drgs.PreGroupChsWebServicePort).%New()
	s Obj.Timeout=5
	s Obj.SSLConfiguration="SSLECP"
	;s Obj.SSLCheckServerIdentity=0
        s rtndrgsjosn=Obj.group(jsonstr)
	s ^temp("rtndrgsjosn")=rtndrgsjosn
	s rtnjson=##class(%DynamicObject).%New()
	s rtnjson=rtnjson.%FromJSON(rtndrgsjosn)
	s resultcode=rtnjson.%Get("result_code")
	s resultMesag=""
	if resultcode'=0  d
	.s resultMesag=rtnjson.%Get("result_message")
	else  d
	.s resultcode=..insert(EpisodeID,jsonstr,rtndrgsjosn)
	.if resultcode'=0  d
	..s resultMesag="保存Drgs信息失败!"
	.else  d
	..s resultMesag=""
	q resultcode_"^"_resultMesag
getOPList()
	;手术
	s oprationlist=##class(%DynamicArray).%New()
	s opaId=0
	f  s opaId=$O(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
	.s OPAAnaestDr=$p($G(^DHCANOPArrange(opaId)),"^",2)
	.s opstatus=$p($G(^DHCANOPArrange(opaId)),"^",27)
	.Q:((opstatus'="L")&&(opstatus'="F"))
	.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	.s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",chl,"OP",subchl)) q:(subchl="")  d ///ck091117
	..s opdr=$P($g(^OR(EpisodeID,"ANA",chl,"OP",subchl)),"^",6)       		;ANAOP_Type_DR     ；手术名称
	..i opdr'=""  d   //ck091210
	...i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d     ///ck091117
	....s opICD=$P(^ORC("OPER",+opdr),"^",14)
	....s operationdesc=$P(^ORC("OPER",+opdr),"^",2)
	....s one={}
 	....d one.%Set("CODE",opICD)
 	....d one.%Set("DESC",operationdesc)
	....d oprationlist.%Push(one)
	q
getDia()
	k otherDiaList
	s mainmrdia="" s mainmrdiaDesc=""
	s firstdia="" s firstdiadesc=""
	s diaglength=0
	s mricdsub=0 
	f  s mricdsub=$o(^MR(mradm,"DIA",mricdsub)) q:mricdsub=""  d
	.Q:$g(^MR(mradm,"DIA",mricdsub))=""
	.s ICDRowid=$p(^MR(mradm,"DIA",mricdsub),"^",1)
	.Q:ICDRowid=""
	.s ICDCode=$P(^MRC("ID",ICDRowid),"^",4)
	.s ICDDesc=$P(^MRC("ID",ICDRowid),"^",2)
	.if firstdia=""  d
	..s firstdia=ICDCode s firstdiadesc=ICDDesc
	.s diatypedr=""
	.s diatypelistdr=$O(^MR(+mradm,"DIA",mricdsub,"TYP",""),-1) 
	.s:diatypelistdr'="" diatypedr=$P($G(^MR(mradm,"DIA",mricdsub,"TYP",diatypelistdr)),"^",1)
	.;MRC("DTYP",1)="C008^入院诊断^N"
	.s diamian=$p(^MR(mradm,"DIA",mricdsub,1),"^",20)
	.if (diamian="Y"){s mainmrdia=ICDCode s mainmrdiaDesc=ICDDesc}
	.else  s otherDiaList(mricdsub,ICDCode)=ICDDesc
	if mainmrdia="" d 
	.s mainmrdia=firstdia s mainmrdiaDesc=firstdiadesc 
 
	s dialist=##class(%DynamicArray).%New()
	s sub1=0
	f  s sub1=$O(otherDiaList(sub1)) Q:sub1=""  d
	.s sub2=0
	.f  s sub2=$O(otherDiaList(sub1,sub2)) Q:sub2=""  d
	..Q:mainmrdia=sub2
	..s desc=$G(otherDiaList(sub1,sub2))
	..s one={}
	..d one.%Set("CODE",sub2)
	..d one.%Set("DESC",desc)
	..d dialist.%Push(one)
	..s diaglength=diaglength+1
	q
SendtoDrgsErr
	s $ZT=""
	q "-100^调用DRG/DIP失败:"_$ZE
}

/// 通过主诊断表ID，获取诊断xx
/// MRAdm:主诊断表ID、List:[]对象
/// s a=[]
/// w ##class(DHCDoc.Interface.Inside.Drgs.MainPort).GetMRDiagnos(8646,.a)
ClassMethod GetMRDiagnos(MRAdm, ByRef List)
{
	;出院诊断>初步诊断>入院诊断
	;1.有出院诊断时，不传其他两类诊断，主诊按照标识的第一个来，无标识传出院诊断第一个为主诊，其他按照页面序号传
	;2.无出院诊断时，传其他两类诊断，主诊按照标识的第一个来，无标识传初步诊断第一个为主诊，其他按照页面序号传
	;3.主诊段的数据不传入其他诊断中
	
	s (FMainSub,FMainCode,FMainDesc,Length)=""
	k DiagLevel
	s Sub=0
	for {
		s Sub=$o(^MR(MRAdm,"DIA",Sub))
		Q:Sub=""
		s ICDID=$p(^MR(MRAdm,"DIA",Sub),"^",1)
		Continue:ICDID=""
		s ICDCode=$p(^MRC("ID",ICDID),"^",4)
		s ICDDesc=$p(^MRC("ID",ICDID),"^",2)
		s DiagTypeDesc=""
		s DiagTypeID=$O(^MR(MRAdm,"DIA",Sub,"TYP",""),-1) 
		if DiagTypeID'="" {
			s DiagTypeID=$p($g(^MR(MRAdm,"DIA",Sub,"TYP",DiagTypeID)),"^",1)
			s DiagTypeCode=$p(^MRC("DTYP",DiagTypeID),"^",1)
			s DiagTypeDesc=$p(^MRC("DTYP",DiagTypeID),"^",2)
		}
		s MainFlag=$p(^MR(MRAdm,"DIA",Sub,1),"^",20)
		if (FMainCode="")&&(MainFlag="Y"){
			;取第一个主诊断
			s FMainCode=ICDCode
			s FMainDesc=ICDDesc
			s FMainSub=Sub
		}
		s DiagNumber=$p($g(^MR(MRAdm,"DIA",Sub,"EPR")),"^",2)	;顺序号
		s DiagNumber=##class(DHCDoc.Util.System).LeftAutoZero(DiagNumber,3)
		s DiagTypeLevel=$case(DiagTypeDesc,"出院诊断":1,"初步诊断":2,"入院诊断":3,:9)
		
		s DiagLevel(DiagTypeLevel,DiagNumber,Sub)=$lb(ICDCode,ICDDesc,MainFlag)
	}
	if $d(DiagLevel(1)){
		;如果存在出院诊断
		s LevelStr="1^9"
		do GetDiagInfo
	}else{
		;不存在出院诊断
		s LevelStr="2^3^9"
		do GetDiagInfo
	}
	Q $lb(FMainCode,FMainDesc,Length)
	
GetDiagInfo	
	for Len=1:1:$l(LevelStr,"^"){
		s Level=$p(LevelStr,"^",Len)
		Continue:$d(DiagLevel(Level))=0
		s Num=0
		for {
			s Num=$o(DiagLevel(Level,Num))
			Q:Num=""
			s Sub=0
			for {
				s Sub=$o(DiagLevel(Level,Num,Sub))
				Q:Sub=""
				s DiagInfo=$g(DiagLevel(Level,Num,Sub))
				if FMainCode=""{
					s FMainCode=$lg(DiagInfo,1)
					s FMainDesc=$lg(DiagInfo,2)
					s FMainSub=Sub
				}
				Continue:(FMainSub'="")&&(FMainSub=Sub)
				s Obj={}
				d Obj.%Set("CODE",$lg(DiagInfo,1))
				d Obj.%Set("DESC",$lg(DiagInfo,2))
				d List.%Push(Obj)
				s Length=Length+1
			}
		}
	}
	Q ""
}

/// 插入对应的Drgs消息 到HIS
ClassMethod insert(Adm, ParamJson, ReturnJson) As %String
{
	s nowdate=+$H
	s nowtime=$P($H,",",2)
	&sql(
	insert into DHCDoc_Interface_Inside_Drgs.Mesage
	(DrgsAdmDr,DrgsParamJson,DrgsRtnJson,DrgsInsertDate,DrgsInsertTime)
	values
	(:Adm,:ParamJson,:ReturnJson,:nowdate,:nowtime))
	q SQLCODE
}

}
