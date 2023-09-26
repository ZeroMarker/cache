Import SQLUser

Class web.UDHCJFCOMMON Extends BILL.COM.Abstract
{

/// w ##class(web.UDHCJFCOMMON).getpath()
ClassMethod getpath(itmjs As %String = "", itmjsex As %String = "")
{
	&SQL(SELECT pathtoreports INTO :path FROM websys.configuration)
	q path
}

ClassMethod getcurdate()
{
   s curdate=##class(websys.Conversions).DateLogicalToHtml(+$h)
   s curtime=##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2),1)
   q curdate_" "_curtime
}

ClassMethod getdatetime()
{
	s stdate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	s sttime=##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2),1)
	q stdate_"^"_sttime
}

ClassMethod gettoday(itmjs As %String = "", itmjsex As %String = "", val As %String = "")
{
 	s str=##class(websys.Conversions).DateLogicalToHtml(+$h)
 	s retval=itmjs_"('"_$zcvt(str,"O","JS")_"');"
 	i itmjsex'="""" s retval=retval_itmjsex_"('"_$zcvt(str,"O","JS")_"');"
 	&javascript<#(retval)#>
 	q 1
}

/// 根据时间和出生时间计算年龄?不满1岁显示月数?不满1月的显示天数?
/// w ##class(web.UDHCJFCOMMON).GetAge("2021-10-21", +$h)
ClassMethod GetAge(DOB As %String, CalDate As %String) As %String
{
	s Age=##class(web.DHCDTHealthCommon).GetAgeDesc(DOB, CalDate)
	q Age
}

ClassMethod ENCR(x)
{
	s const=37,out=""
	
	f piece=1:1:$l(x) s char=$e(x,piece) d
	.i char="D" s char=$c(2)
	.i char="p" s char=$c(3)
	.i char="d" s char=$c(4)
	.i char="t" s char=$c(5)
	.s num=$a(char)
	.s num=(num-piece+const)#255
	.i num>127 s num=(num+128)#255
	.i num<32 s num=(num+40)#255
	.i $c(num)="^" s num=num+1
	.s $e(out,piece)=$c(num#255)
	//Pad out the length
	s len=$l(out)
	f piece=(len+1):1:12 d
	.s char=$e(out,(piece-len))
	.s num=$a(char)
	.s num=(num*2.345*const*(const-7))#255
	.i num>127 s num=(num+128)#255
	.i num<32 s num=(num+40)#255
	.i $c(num)="^" s num=num+1
	.s $e(out,piece)=$c(num#255)
	q out
}

/// 根据医嘱项RowId 获得药学项名称 ARC_ItmMast --> PHC_Generic
/// w ##class(web.UDHCJFCOMMON).GetDrugCommonNameByArcimId("5505||1")
ClassMethod GetDrugCommonNameByArcimId(arcim As %String, langId As %String = "") As %String
{
	set genericDesc=""
	quit:(+arcim=0) genericDesc
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	set genericDR=$p(^ARCIM(+arcim,$p(arcim,"||",2),8),"^",20)  //ARCIM_Generic_DR	
	quit:(+genericDR=0) genericDesc
	set genericDesc=$p($g(^PHCGE("GE",genericDR)),"^",2)
	set genericDesc=##class(User.PHCGeneric).GetTranByDesc("PHCGEName", genericDesc, langId)
	quit genericDesc
}

/// w ##class(web.UDHCJFCOMMON).GetNationId("汉")
ClassMethod GetNationId(desc As %String) As %String
{
	s nationId=""
	s rowId=0
	f  s rowId=$o(^CT("NAT",rowId)) q:((rowId="")||(nationId'=""))  d
 	.s myDesc=$p(^CT("NAT",rowId),"^",2)
 	.i ($f(myDesc,"-")'=0) d
 	..s myDesc=$p(myDesc,"-",2)
 	.i (##class(BILL.Util.Tools).InStr(myDesc, desc)=1) d
 	..s nationId=rowId
 	
  	q nationId
}

ClassMethod getbabybirday(birstr, admdate, admtime)
{
	s admdate=##class(websys.Conversions).DateHtmlToLogical(admdate)
	s admtime=##class(websys.Conversions).TimeHtmlToLogical(admtime, 1)
 	q:(birstr="") "1"
 	q:(admdate="") "2"
 	q:(admtime="") "3"
 	q:($f(birstr,"年")'=0) "4"
 	q:($f(birstr,"月")'=0) "4"
 	s birthday="", birtime="", birdob=""
 	s birday="", birhour="", birmin=""
 	i $f(birstr,"天")'=0  d
 	.s birday=$p(birstr,"天",1)
 	.s birday=+birday
 	.s birstr1=$p(birstr,"天",2)
 	.i $f(birstr1,"小时")=0  d
 	..s birhour=0
 	..s birmin=0
 	.e  d
 	..s birhour=$p(birstr1,"小时",1)
	..s birhour=+birhour
 	..s birstr2=$p(birstr1,"小时",2)
 	..i $f(birstr2,"分钟")=0  d
 	...s birmin=0
 	..e  d
 	...s birmin=$p(birstr2,"分钟",1)
 	...s birmin=+birmin
 	e  d
 	.s birday=0
 	.i $f(birstr,"小时")=0  d
 	..s birhour=0
 	..s birmin=0
	.e  d
 	..s birhour=$p(birstr,"小时",1)
 	..s birhour=+birhour
 	..s birstr2=$p(birstr,"小时",2)
 	..i $f(birstr2,"分钟")=0  d
 	...s birmin=0
 	..e  d
 	...s birmin=$p(birstr2,"分钟",1)
 	...s birmin=+birmin
 	s birtime1=(birhour*3600)+(birmin*60)
 	s birtime2=$zth("23:59:59",1)
 	i (birday=0)  d
 	.i birtime1>admtime  d
 	..s birthday=admdate-1
 	..s birtime3=birtime1-admtime
 	..s birtime=birtime2-birtime3
 	.e  d
 	..s birtime=admtime-birtime1
 	..s birthday=admdate
 	e  d
 	.s birthday=admdate-birday
 	.i (birtime1>admtime)  d
 	..s birthday=birthday-1
 	..s birtime3=birtime1-admtime
 	..s birtime=birtime2-birtime3
 	.e  d
 	..s birtime=admtime-birtime1
 
 	s birdob=birthday_"^"_birtime_"^"_##class(websys.Conversions).DateLogicalToHtml(birthday)_"^"_##class(websys.Conversions).TimeLogicalToHtml(birtime,1)
 	q birdob
}

ClassMethod GetDrugSpec(arcim As %String) As %String
{
	s spec=""
	q:(arcim="") spec
	s inc=$o(^INCI(0,"ARCIM_DR",$p(arcim,"||",1),""))
	q:(inc="") spec
	s itminf=$o(^DHCITMINFO(0,"INCI",inc,""))
	i (itminf'="") {
		s spec=$p($g(^DHCITMINFO(itminf)),"^",27)
	}
	q spec
}

/// 解密JS加密字符串
ClassMethod UnEscape(InStr As %String) As %String
{
	s num=1, retStr="", tmpNum=1	
	f num=1:1:$l(InStr,"%") d
	.s char=$p(InStr,"%",num)
	.i (num=1) d
	..s retStr=$e(char,1,$l(char))
	.e  d
	..i $e(char,1,1)'="u" d
	...s retStr=retStr_$c($zhex($e(char,1,2)))_$e(char,3,$l(char))
	..e  d
	...s retStr=retStr_$c($zhex($e(char,2,5)))_$e(char,6,$l(char))
	q retStr
}

/// Creator: skl
/// CreateDate: 2012-08-28
/// Description: 判断婴儿的是否有未结算的账单或者未出院，传入母亲的就诊rowid
/// Debug: w ##class(web.UDHCJFCOMMON).CheckBabyAdmDisCharge(241)
ClassMethod CheckBabyAdmDisCharge(MotherAdm As %String) As %String
{
	set rtn="0^0"
	set AdmHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(MotherAdm)
	set cfgId=##class(web.DHCBillCommon).GetTarParaId(AdmHospDR)
	set NewBornToMother=$s((cfgId'=""):$p(^DHCTarC("CF",cfgId),"^",5),1:"Y")
	quit:(NewBornToMother="Y") rtn

	set MAdmStatusCode=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(MotherAdm)
	quit:(" F T "'[(" "_MAdmStatusCode_" ")) rtn
	
	set BabyAdm=0
	while($o(^PAADMi("Mother",MotherAdm,BabyAdm))) {
		set BabyAdm=$o(^PAADMi("Mother",MotherAdm,BabyAdm))
		set pb=0
		while($o(^DHCPB(0,"ADM",BabyAdm,pb))) {
			set pb=$o(^DHCPB(0,"ADM",BabyAdm,pb))
			set prtRowId=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(pb)
			continue:(+prtRowId'=0)
			set rtn="-1^"
			quit
		}
		quit:(+rtn)
		set BabyVisitStatus=$p(^PAADM(BabyAdm),"^",20)
		continue:(BabyVisitStatus="C")
		set BabyAdmStatusCode=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(BabyAdm)
		continue:(" F T "'[(" "_BabyAdmStatusCode_" "))
		set AdmStatusStr=##class(web.UDHCJFBaseCommon).GetOutAdmInOutDateInfo(BabyAdm)
		set AdmStatus=$p(AdmStatusStr,"^",4)
		set rtn="-2^"_AdmStatus
		quit
	}
	
	quit rtn
}

/// 生成业务流水号
ClassMethod BuildHospInvID(HospID, InvType)
{
	s NCurDate=$zd(+$h,8)
	s NCurDate=$E(NCurDate,3,8)
	s BuildNoSt=HospID_NCurDate
	i InvType="I" d
	.l +^DHCIPBill("InvNum","IPINV"):5
	.s BuildNo=$g(^DHCIPBill("InvNum","IPINV",+$h))
	.s BuildLastNo=$e(BuildNo,16,20)
	.i BuildLastNo="" d
	..s BuildLastNo="00001"
	.e  d
	..s BuildLastNo=$e(BuildNo,16,20)
	..s BuildLastNo=$i(BuildLastNo)
	..f i=$l(BuildLastNo)+1:1:5 d
	...s BuildLastNo=0_BuildLastNo
	.s BuildNo=BuildNoSt_BuildLastNo
	.s ^DHCIPBill("InvNum","IPINV",+$h)=BuildNo
	.l -^DHCIPBill("InvNum","IPINV")
	i InvType="O" d
	.l +^DHCIPBill("InvNum","OPINV"):5
	.s BuildNo=$g(^DHCIPBill("InvNum","OPINV",+$h))
	.s BuildLastNo=$e(BuildNo,16,20)
	.i BuildLastNo="" d
	..s BuildLastNo="00001"
	.e  d
	..s BuildLastNo=$e(BuildNo,16,20)
	..s BuildLastNo=$i(BuildLastNo)
	..f i=$l(BuildLastNo)+1:1:5 d
	...s BuildLastNo=0_BuildLastNo
	.s BuildNo=BuildNoSt_BuildLastNo
	.s ^DHCIPBill("InvNum","OPINV",+$h)=BuildNo
	.l -^DHCIPBill("InvNum","OPINV")

	q BuildNo
}

/// Creator: hujunbin
/// Description: 保存新生儿年龄
/// Input: patientId:新生儿id，birthDate:新生儿出生日期，birthTime:出生时间
/// Return:	0:成功，<>0:失败
/// Debug: w ##class(web.UDHCJFCOMMON).SaveNewBabyDob("1","63247","25201")
ClassMethod SaveNewBabyDob(patientId, birthDate, birthTime) As %String
{
	set $zt="ERROR"
	set rtn=0
	
	ts
	if (+birthDate'=0) {
		set rtn=##class(web.UDHCJFCOMMON).SavePatBirthDate(patientId, birthDate)
		if (+rtn) tro  quit rtn
	}
	if (+birthTime'=0) {
		set rtn=##class(web.UDHCJFCOMMON).SavePatBirthTime(patientId, birthTime)
		if (+rtn) tro  quit rtn
	}
	
	if ($tl>0) tc
	
	quit rtn
ERROR
	quit ..AppException()
}

/// Creator: hujunbin @copy from CalAge and Update it
/// Modify: ZhYW
/// Description: 计算年龄，返回包含年月日时分秒的字符串
/// Input:	BirthDate:出生日期，CalDate:当前日期或就诊日期
/// 		BirthTime:出生时间，CalTime:当前时间或就诊时间
/// Return:	retAge:包含年月日时分秒的字符串	
/// Debug:	w ##class(web.UDHCJFCOMMON).CalAge("63223","63247","25201","25200")
ClassMethod CalAge(BirthDate As %String, CalDate As %String, BirthTime As %String = "", CalTime As %String = "") As %String
{
    quit:(BirthDate'>0) ""
    
    set BYear=$SYSTEM.SQL.YEAR(BirthDate)
    set BMth=$SYSTEM.SQL.MONTH(BirthDate)
    set BDay=$SYSTEM.SQL.DAYOFMONTH(BirthDate)
    
    set CYear=$SYSTEM.SQL.YEAR(CalDate)
    set CMth=$SYSTEM.SQL.MONTH(CalDate)
    set CDay=$SYSTEM.SQL.DAYOFMONTH(CalDate)
    
    set AgeYear=CYear-BYear
    set AgeMth=CMth-BMth
    set AgeDay=CDay-BDay
    
    set (AgeHour, AgeMin, AgeSec)=0
    if ((BirthTime'="")&&(CalTime'="")) {
	    set BHour=$SYSTEM.SQL.HOUR(BirthTime)
	    set BMin=$SYSTEM.SQL.MINUTE(BirthTime)
	    set BSec=$SYSTEM.SQL.SECOND(BirthTime)
	    
	    set CHour=$SYSTEM.SQL.HOUR(CalTime)
	    set CMin=$SYSTEM.SQL.MINUTE(CalTime)
	    set CSec=$SYSTEM.SQL.SECOND(CalTime)
		
		set AgeHour=CHour-BHour
		set AgeMin=CMin-BMin
		set AgeSec=CSec-BSec
		
		if (AgeSec<0) {
			set AgeSec=AgeSec+60, AgeMin=AgeMin-1
		}
		if (AgeMin<0) {
			set AgeMin=AgeMin+60, AgeHour=AgeHour-1
		}
		if (AgeHour<0) {
			set AgeHour=AgeHour+24, AgeDay=AgeDay-1
		}
    }
    
	if (AgeDay<0) {
		set AgeMth=AgeMth-1
	   	set MthDays=##class(BILL.Util.Date).GetDaysOfMonth(BirthDate)   //出生月份有多少天
	   	set BirthDays=MthDays-BDay
	   	set AgeDay=BirthDays+CDay
	}
	
	if (AgeMth<0) set AgeMth=AgeMth+12, AgeYear=AgeYear-1
	set $p(AgeYr,"|",12)=AgeYear
	
	if (AgeMth<0) set AgeMth=""
	if (AgeDay<0) set AgeDay=""
	if (AgeHour<0) set AgeHour=""
	if (AgeMin<0) set AgeMin=""
	if (AgeSec<0) set AgeSec=""
	
	set retAge=$p(AgeYr,"|",12)_"^"_AgeMth_"^"_AgeDay_"^"_AgeHour_"^"_AgeMin_"^"_AgeSec
	quit retAge
}

/// Creator: hujunbin
/// CreatDate: 2014-12-04
/// Description: 根据日期和时间获取年龄日期串
/// 			此方法在住院登记和产品组接口时调用，修改请慎重!!!
/// Input:	birthDate: 出生日期, admDate: 就诊日期或当前日期, birthTime: 出生时间, admTime: 就诊时间或当前时间,
///         hospId: CT_Hospital.RowId
/// 		controlFlag: 此标志优先；此标志高于##class(web.UDHCJFAgeConfig).GetAgeConfig()配置
/// 					 如果是Y，则不走这个配置##class(web.UDHCJFAgeConfig).GetAgeConfig()，走传入的日期和时间
/// 				     其他走此配置##class(web.UDHCJFAgeConfig).GetAgeConfig()
///         langId: 语种
///         cusDispPat: 自定义格式(Y:年, YM:年月, YMD:年月天, MD:月天, M:月, D:天)
/// Return:	日期字符串
/// Debug:	w ##class(web.UDHCJFCOMMON).DispPatAge("66035","66127","","60725","2","Y","","D")
ClassMethod DispPatAge(birthDate As %String, admDate As %String, birthTime As %String, admTime As %String, hospId As %String = "", controlFlag As %String = "", langId As %String = "", cusDispPat As %String = "") As %String
{
	set ^TMP("DispPatAge")=$lb(birthDate, admDate, birthTime, admTime, hospId, controlFlag, langId, cusDispPat)
	if (+hospId=0) {
		quit "HospitalNull"
	}
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	//这里调配置，是因为住院登记时单调了这个方法
	set isAdmFlag=##class(web.UDHCJFAgeConfig).GetAgeConfig(hospId)
	if ((admDate="")||((controlFlag'="Y")&&(isAdmFlag=1))) {
		set admDate=+$h
		set admTime=$p($h,",",2)
	}
	
	//calInFlag：是否算满
	//如 1年零一天，显示2年还是1年，1：2年；0:1年
	set calInFlag=0
	
	set birthDate=##class(websys.Conversions).DateHtmlToLogical(birthDate)
	set admDate=##class(websys.Conversions).DateHtmlToLogical(admDate)
	set birthTime=##class(websys.Conversions).TimeHtmlToLogical(birthTime, 1)
	set admTime=##class(websys.Conversions).TimeHtmlToLogical(admTime, 1)
	
	set ageRtn=..CalAge(birthDate, admDate, birthTime, admTime)
	
	set dispUomCode=$s((cusDispPat=""):..GetAgeCfgDispUom(ageRtn, birthDate, admDate, birthTime, admTime, calInFlag, hospId),1:cusDispPat)

	if (dispUomCode'="") {
		set rtn=##class(web.UDHCJFAgeConfig).DispAge(ageRtn, birthDate, admDate, birthTime, admTime, dispUomCode, calInFlag, langId)
		set desc=$p(rtn,"||",1)
		set len=$l(rtn,"||")
		set other=$p(rtn,"||",2,len)
	} else {
		set tmpY=$p(ageRtn,"^",1)
		set tmpM=$p(ageRtn,"^",2)
		set tmpD=$p(ageRtn,"^",3)
		set tmpH=$p(ageRtn,"^",4)
		set tmpMin=$p(ageRtn,"^",5)
		set tmpS=$p(ageRtn,"^",6)
		if (calInFlag=1) {
			if ((tmpM'=0)||(tmpD'=0)||(tmpH'=0)||(tmpMin'=0)||(tmpS'=0)) {
				set tmpY=tmpY+1
			}
		}
		set desc=tmpY_##class(websys.Translation).Get("Bill.Com.Age", "岁", langId)
		set other=tmpY_"||"_""_"||"_""_"||"_""_"||"_""_"||"_""
	}
	
	set tmpY=$p(ageRtn,"^",1)
	set tmpM=$p(ageRtn,"^",2)
	set tmpD=$p(ageRtn,"^",3)
	set tmpH=$p(ageRtn,"^",4)
	set tmpMin=$p(ageRtn,"^",5)
	set tmpS=$p(ageRtn,"^",6)
	
	set rtn=desc_"||"_tmpY_"||"_tmpM_"||"_tmpD_"||"_tmpH_"||"_tmpMin_"||"_tmpS
	set rtn=rtn_"||"_other
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2018-12-29
/// Description: 保存患者出生日期
/// Input:	patientId:患者Id，birthDate:出生日期
/// Return: 0:成功，<>0:失败
/// Debug: w ##class(web.UDHCJFCOMMON).SavePatBirthDate(1, 66318)
ClassMethod SavePatBirthDate(patientId, birthDate) As %String
{
	set rtn=0
	if ((patientId="")||(birthDate="")) quit -1_"^"_"参数错误"
	
	set birthDate=##class(websys.Conversions).DateHtmlToLogical(birthDate)
	
	&SQL(
		UPDATE PA_PatMas
		SET PAPMI_DOB = :birthDate
		WHERE %ID = :patientId
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2018-12-29
/// Description: 保存患者出生时间
/// Input:	patientId:患者Id，birthTime:出生时间
/// Return: 0:成功，<>0:失败
/// Debug: w ##class(web.UDHCJFCOMMON).SavePatBirthTime()
ClassMethod SavePatBirthTime(patientId, birthTime) As %String
{
	set rtn=0
	if ((patientId="")||(birthTime="")) quit -1_"^"_"参数错误"
	
	set birtTime=##class(websys.Conversions).TimeHtmlToLogical(birthTime, 1)
	
	&SQL(
		UPDATE DHC_PA_PatMas
		SET PAPMI_BirthTime = :birthTime
		WHERE %ID = :patientId
	)
	set rtn=SQLCODE
	quit:(+rtn) rtn_"^"_$g(%msg)
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2018-12-29
/// Description: 获取患者出生日期
/// Input: patientId:PA_PatMas.PAPMI_RowId
/// Return: 
/// Debug: w ##class(web.UDHCJFCOMMON).GetPatBirthDate()
ClassMethod GetPatBirthDate(patientId As %String) As %String
{
	set birthDate=""
	quit:(+patientId=0) birthDate
	set birthDate=$p($g(^PAPER(patientId,"ALL")),"^",6)
	quit birthDate
}

/// Creator: ZhYW
/// CreatDate: 2018-12-29
/// Description: 获取患者出生时间
/// Input: patientId:DHC_PA_PatMas.PAPMI_RowId
/// Return: 
/// Debug: w ##class(web.UDHCJFCOMMON).GetPatBirthTime()
ClassMethod GetPatBirthTime(patientId As %String) As %String
{
	set birthTime=""
	quit:(+patientId=0) birthTime
    set birthTime=$p($g(^PAPER(patientId,"DHC")),"^",1)
    quit birthTime
}

/// Creator: ZhYW
/// CreatDate: 2022-04-12
/// Description: 获取年龄配置显示的单位代码
/// Input: 
/// Return: 
/// Debug: w ##class(web.UDHCJFCOMMON).GetAgeCfgDispUom()
ClassMethod GetAgeCfgDispUom(ageStr As %String, birthDate As %String, admDate As %String, birthTime As %String, admTime As %String, calInFlag As %String, hospId As %String) As %String
{
	set dispUomCode=""
	set defHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_AgeCfg", hospId)
	set id=0
	while($o(^DHCJFAGECONFIG(id))) {
		set id=$o(^DHCJFAGECONFIG(id))
		set data=$g(^DHCJFAGECONFIG(id))
		continue:(data="")
		set hospDR=$p(data,"^",20)
		continue:(hospDR'=defHospId)
		set stVal=$p(data,"^",2)
		set endVal=$p(data,"^",5)
		set stUomDR=$p(data,"^",3)
		set endUomDR=$p(data,"^",6)
		set stUomCode=$p(^DHCJFUOMSET(stUomDR),"^",1)
		set endUomCode=$p(^DHCJFUOMSET(endUomDR),"^",1)
		set flag=##class(web.UDHCJFAgeConfig).CheckRangeIn(ageStr, birthDate, admDate, birthTime, admTime, stVal, endVal, stUomCode, endUomCode, calInFlag)
		continue:(flag'=1)
		set dispUomDR=$p(data,"^",7)
		set dispUomCode=$p($g(^DHCJFUOMSET(dispUomDR)),"^",1)
		quit
	}
	
	quit dispUomCode
}

/// creator :zg
/// function:根据收费员和安全组获取所有的可以登录的科室。
/// 门诊收费安全组 5 ，门诊收费组长 6 ，住院收费安全组 8
/// w ##class(web.UDHCJFCOMMON).GetUserLocStr(17275,"238^239^240^241^122^131^119")
ClassMethod GetUserLocStr(USER, GROUP) As %String
{
	
	s LocStr=""
	i +USER=0 q LocStr
	S usrgrp=$p(^SSU("SSUSR",USER),"^",5)
	s UsrLoc=$p(^SSU("SSUSR",USER),"^",4)
	Quit:((GROUP'="")&(GROUP'[usrgrp_"^")) LocStr
	s LocStr=UsrLoc
	Set Sub=0
	For  Set Sub=$o(^SSU("SSUSR",USER,"OTHLL",Sub)) Quit:Sub=""  Do
	.Set usrOtherLoc=$p(^SSU("SSUSR",USER,"OTHLL",Sub),"^",1)
	.Set usrOthergrp=$p(^SSU("SSUSR",USER,"OTHLL",Sub),"^",2)
	.Quit:((GROUP'="")&(GROUP'[usrOthergrp_"^"))
	.s LocStr=LocStr_"^"_usrOtherLoc
	
	q LocStr_"^"
}

}
