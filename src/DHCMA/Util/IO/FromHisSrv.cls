/// 名称: DHCMA.Util.IO.FromHisSrv
/// 描述: HIS提供接口服务
/// 编写者：chenjb
/// 编写日期: 2018-06-25
Class DHCMA.Util.IO.FromHisSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-09-19
/// Description:  根据配置修改日期存储格式【From系统平台】
/// Input：       aDate : 日期
/// Return:		  返回String Cache日期格式
/// w ##Class(DHCMA.Util.IO.FromHisSrv).GetDateFormat()
ClassMethod GetDateFormat() As %String
{
	Set $ZT="GetDateFormatErr"
	Set return= "yyyy-mm-dd"		//默认 yyyy-mm-dd
	Set dateformat=$lg(^websys.ConfigurationD(1),10)
	If dateformat="DMY" {Set return="dd/mm/yyyy"}
	elseif dateformat="MDY" {Set return="mm/dd/yyyy"}
	elseif dateformat="YMD" {Set return="yyyy-mm-dd"}
	Quit return
GetDateFormatErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-03-21
/// Description:  根据配置修改日期存储格式【From系统平台】
/// Input：       aDate : 日期
/// Return:		  返回String Cache日期格式
/// w ##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical("2017-03-12")
ClassMethod DateHtmlToLogical(aDate As %String) As %String
{
	New (aDate)
	Set return=""
	Quit:aDate="" return
	
	Set $ZT="DateHtmlToLogicalErr"
	Set return=##class(websys.Conversions).DateHtmlToLogical(aDate)
	If return="ERROR!"{		// 处理公司接口返回值为错误
		Set return = Error
	} Else {
		Set return=..GetDateHtmlToLogical(aDate)
	}
	Quit return
	
DateHtmlToLogicalErr
	Set return=..GetDateHtmlToLogical(aDate)
	Quit return
}

/// 显示格式转换为数据库存储格式
ClassMethod GetDateHtmlToLogical(aDate As %String) As %String
{
	New (aDate)
	Set return=""
	Quit:aDate="" return
	
	Set $ZT="GetDateHtmlToLogicalErr"
	Set:aDate["-" return=$zdh(aDate,3)
	Set:aDate["/" return=$zdh(aDate,4)
	Set:return="" return=+aDate
	Set:return=0 return=""
	Quit return
	
GetDateHtmlToLogicalErr
	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2017-12-14
/// Description:  根据配置修改时间存储格式
/// Input：       aTime : 日期
/// Return:		  返回String Cache时间格式
/// w ##Class(DHCMA.Util.IO.FromHisSrv).TimeHtmlToLogical("12:12")
ClassMethod TimeHtmlToLogical(aTime As %String) As %String
{
	New (aTime)
	Set return=""
	Quit:aTime="" return
	
	Set $ZT="TimeHtmlToLogicalErr"
	Set return=##class(websys.Conversions).TimeHtmlToLogical(aTime)
	If return="ERROR!"{		// 处理公司接口返回值为错误
		Set return = Error
	} Else {
		Set return=..GetTimeHtmlToLogical(aTime)
	}
	Quit return
	
TimeHtmlToLogicalErr
	Set return=..GetTimeHtmlToLogical(aTime)
	Quit return
}

/// 显示格式转换为数据库存储格式
ClassMethod GetTimeHtmlToLogical(aTime As %String) As %String
{
	New (aTime)
	Set return=""
	Quit:aTime="" return
	
	Set $ZT="GetTimeHtmlToLogicalErr"
	Set:aTime[":" return=$zth(aTime,1)
	Set:return="" return=+aTime
	Set:return=0 return=""
	Quit return
	
GetTimeHtmlToLogicalErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-03-21
/// Description:  根据配置修改日期输出格式【From系统平台】
/// Input：       aDate : 日期
/// Return:		  返回String 日期格式：2017-01-01
/// w ##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(+$h)
ClassMethod DateLogicalToHtml(aDate As %String) As %String
{
	New (aDate)
	Set return=""
	Quit:aDate="" return
	
	Quit:aDate["-" aDate  //已经转换了，不需要再转换
	Quit:aDate["/" aDate  //已经转换了，不需要再转换
	Set $ZT="DateLogicalToHtmlErr"
	Set MethodFalg=1	//=##class(DHCMA.Util.BT.Config).GetValueByCode("HISIODateLogicalToHtml")
	If (+MethodFalg)<1 {
		Set return=..GetDateLogicalToHtml(aDate)
	} Else {
		Set return=##class(websys.Conversions).DateLogicalToHtml(aDate)
	}
	Quit return
	
DateLogicalToHtmlErr
	Set return=..GetDateLogicalToHtml(aDate)
	Quit return
}

/// 数据库存储格式转换为显示格式
ClassMethod GetDateLogicalToHtml(aDate As %String) As %String
{
	New (aDate)
	Set return=""
	Quit:aDate="" return
	
	Set $ZT="GetDateLogicalToHtmlErr"
	Set:aDate["-" return=$zdh(aDate,3)
	Set:aDate["/" return=$zdh(aDate,4)
	Set:return="" return=+aDate
	Set:return=0 return=""
	Set:return'="" return=$zd(aDate,3)
	Quit return
	
GetDateLogicalToHtmlErr
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-01-30
/// Description:  取患者年龄【From计费组】
/// Input：       PatientID : 病人ID
///               EpisodeID : 就诊号
///               Date : 日期（可选，为空按当前日期计算）
///               Time : 时间（可选，为空按当前时间计算）
/// Return:		  返回String 格式：*岁*月*天
/// w ##class(DHCMA.Util.IO.FromHisSrv).GetPapmiAge(100,"","2015-01-01","")
ClassMethod GetPapmiAge(aPatientID As %String, aEpisodeID As %String, aDate As %String, aTime As %String, aTmpCnt As %String = "0") As %String
{
	New (aPatientID,aEpisodeID,aDate,aTime,aTmpCnt)
	Set return=0
	Quit:(aPatientID="")||(aEpisodeID="") return
	
	Set $ZT="UDHCJFGetPapmiAgeErr"
	
	Set aTmpCnt=+aTmpCnt
	If aTmpCnt<1 {    //update  2020-06-11 标准版年龄接口增加医院参数后修改
	    Set HospID="",AdmDepDr=""
		Set AdmDepDr=$p($g(^PAADM(aEpisodeID)),"^",4)
		Set HospID=$p(^CTLOC(+AdmDepDr),"^",22)
		Set return=##class(web.DHCBillInterface).GetPapmiAge(aPatientID,aEpisodeID,HospID,aDate,aTime)
	} ElseIf aTmpCnt=1 {
		Set return=..CalAge(aPatientID,aEpisodeID,aDate,aTime)
	} Else {
		Quit:aTmpCnt>1 return
	}
	Quit return
	
UDHCJFGetPapmiAgeErr
	Set aTmpCnt=aTmpCnt+1
	Set return=..GetPapmiAge(aPatientID,aEpisodeID,aDate,aTime,aTmpCnt)
	Quit return
}

ClassMethod CalAge(aPatientID As %String, aEpisodeID As %String, aDate As %String, aTime As %String) As %String
{
	New (aPatientID,aEpisodeID,aDate,aTime)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	Set return=""
	Quit:(aPatientID="")&&(aEpisodeID="") return
	
	Set $ZT="CalAgeErr"
	
	Set:aDate["-" aDate=$zdh(aDate,3)
	Set:aDate["/" aDate=$zdh(aDate,4)
	
	Set:aEpisodeID'="" aPatientID=$p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:aPatientID="" return
	Set IBirth=$p($g(^PAPER(aPatientID,"ALL")),"^",6)
	Set IToday=$s(aDate'="":aDate,1:+$h)
	
	n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
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
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	i $p(AgeYr,"|",12)>0  d
	.s reage=$p(AgeYr,"|",12)_"岁"
	e  d
	.i AgeMth>0 d
	..s reage=AgeMth_"月"
	.e  d
	..s reage=AgeDay_"天"
	i AgeYear>0 d
	.s AgeMth=0
	.s AgeDay=0
	i AgeMth>0 d // add by zhoubo 2016-01-20  处理年龄为月份的时候不显示月份而是天数
	.s AgeDay=0
	Set:AgeYear>0 return=AgeYear_"岁"
	Set:AgeMth>0 return=AgeMth_"月"
	Set:AgeDay>0 return=AgeDay_"天"
	Quit return
CalAgeErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2014-12-18
/// Description:  往消息平台发送消息【From基础平台组】
/// Table：       websys.DHCMessageInterface
/// Input：       Context ：消息内容
///               ActTypeCode ：消息类型代码
///               FromUser ：发送人
///               EpisodeID ：就诊号
///               ToUser ：接收人（可以为空）
///               LnkJson ：消息链接（可以为空）
/// 				  aToLocRowId ：接收消息的科室ID（可以为空）
/// Return：      return=0:表示发送成功  return<0:表示发送失败
/// w ##class(DHCMA.Util.IO.FromHisSrv).SendMsg(aContext,aActTypeCode,aFromUser,aEpisodeID,aToUser,aLnkJson)
ClassMethod SendMsg(aContext As %String, aActTypeCode As %String, aFromUser As %String, aEpisodeID As %String, aToUser As %String = "", aLnkJson As %String = "", aToLocRowId As %String = "") As %String
{
	New (aContext,aActTypeCode,aFromUser,aEpisodeID,aToUser,aLnkJson,aToLocRowId)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	
	Set $ZT="DHCMessageSendMsgErr"
	Set return=##class(websys.DHCMessageInterface).Send(aContext,aActTypeCode,aFromUser,aEpisodeID,"",aToUser,aLnkJson,aToLocRowId)
	Quit return
	
DHCMessageSendMsgErr
	Quit "-999^"_$ZError
}

/// Creator：     chenjb
/// CreatDate：   2017-11-06
/// Description:  取两个时间的间隔秒
/// Input：       OEItemID : 医嘱号
/// Return:		  返回String 格式：标本代码_"^"_标本名称
/// w ##class(DHCMA.Util.IO.FromHisSrv).GetDateTimeDiff("2017-11-06","12:00:59","2017-11-06","12:00:59")
ClassMethod GetDateTimeDiff(aStartDate As %String, aStartTime As %String, aEndDate As %String, aEndTime As %String) As %String
{
	New (aStartDate,aStartTime,aEndDate,aEndTime)
	Set ret =0
	Quit:(aStartDate="")||(aStartTime="")||(aEndDate="")||(aEndTime="") -1
	
	Set dt1 = +##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aStartDate)
	Set dt2 = +##Class(DHCMA.Util.IO.FromHisSrv).DateHtmlToLogical(aEndDate)
	Quit:(dt1)>(dt2) -99
	
	Set DtDiff = (dt2 - dt1) * 24 * 60 * 60  //秒
	
	Set tt1 = $zth(aStartTime,3)
	Set tt2 = $zth(aEndTime,3)
	Quit:(DtDiff=0)&&(tt1>tt2) -99   //如果同一天 时间反差 
	
	Set DtDiff = DtDiff + (tt2-tt1)
	Set ret = DtDiff
	Quit ret
}

/// Creator：     pylian
/// CreatDate：   2016-1-21
/// Description:  取入院时间接口
/// Table：       Pa_Adm、User.PAAdmExt
/// Input：       aEpisodeID : 就诊号
/// Return：      return=AdmDate_"^"_AdmTime
/// w ##Class(DHCMA.Util.IO.FromHisSrv).GetAdmDateTime(21)
ClassMethod GetAdmDateTime(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	Set return=""
	
	Set AdmDate="",AdmTime="",AdmType=""
	Set AdmType=$p($g(^PAADM(aEpisodeID)),"^",2)

	If ($d(^DHCDishChargeSet("Disch","ifGetAdmDateTimeByBed"))&&(AdmType="I")){
		Set AdmDate=$p($g(^PAADM(aEpisodeID,"DHC")),"^",31)
		Set AdmTime=$p($g(^PAADM(aEpisodeID,"DHC")),"^",32)
		//add pylian 20160301 按分床日期为入院日期时，若为空，计算住院日期时导致问题 
		If (AdmDate="")&&(AdmTime=""){
			Set AdmDate=$p($g(^PAADM(aEpisodeID)),"^",6)
			Set AdmTime=$p($g(^PAADM(aEpisodeID)),"^",7)
		}
	}Else{
		Set AdmDate=$p($g(^PAADM(aEpisodeID)),"^",6)
		Set AdmTime=$p($g(^PAADM(aEpisodeID)),"^",7)
	}
	Set return=AdmDate_"^"_AdmTime
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-07-12
/// Description:  取出院时间接口
/// Table：       Pa_Adm、User.PAAdmExt
/// Input：       aEpisodeID : 就诊号
/// Return：      return=DischDate_"^"_DischTime
/// w ##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateTime(849)
ClassMethod GetDischDateTime(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	Set return=""
	
	Set DischDate="",DischTime=""
	//If $d(^PAADMi("DischargeDateExt")) {
	If $d(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc")){
		Set DischDate=$p($g(^PAADM(aEpisodeID,"DHC")),"^",29)
		Set DischTime=$p($g(^PAADM(aEpisodeID,"DHC")),"^",30)
	}Else{
		Set DischDate=$p($g(^PAADM(aEpisodeID)),"^",17)
		Set DischTime=$p($g(^PAADM(aEpisodeID)),"^",18)
	}
	Set return=DischDate_"^"_DischTime
	Quit return
}

/// Creator:		yankai
/// Desc：   		取患者指针病人ID(PatientID)
/// Table:  		PA_Adm.PAADM_PAPMI_DR
/// Input：       	aEpisodeID : 就诊号
/// Return：      	return : PatientID
/// w ##Class(DHCMA.Util.IO.FromHisSrv).GetPatientID(23379132)
ClassMethod GetPatientID(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	Set return=""
    Quit:aEpisodeID="" return
    
    Set return = $p($g(^PAADM(aEpisodeID)),"^",1)
    Quit:(return '= "") return
    
    //华西医院：global节点中的数据丢失，但sql语句可以查询出数据
    &sql(select PAADM_PAPMI_DR into :return from SQLUser.PA_Adm where PAADM_RowId = :aEpisodeID)
    Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-9-29
/// Description:  取病案号接口
/// Table：       PA_PatMas
/// Input：       EpisodeID
/// Return：      return=病案号
/// w ##Class(DHCMA.Util.IO.FromHisSrv).GetMrNoByAdm()
ClassMethod GetMrNoByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set PatientID = $p($g(^PAADM(+aEpisodeID)),"^",1)
	Quit:PatientID="" return
	//Set MrNo = $p($g(^PAPER(PatientID,"PAT",1)),"^",22)  //病人基本信息表取病案号
	Set MrNo = "" //update 20200511 按产品部要求修改
	
	Set $ZT="GetMrNoByAdmErr"
	Set return=##class(DHCWMR.IO.ToOutService).IGetMrNoByEpisodeID(+aEpisodeID,"I")  //参数缺少实际取值是病人基本信息表病案号
	Quit return
	
GetMrNoByAdmErr
	Set return=MrNo
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2018-03-29
/// Description:  根据就诊取急诊留观信息
/// Input：       aEpisodeID ：就诊号
/// Return：      status(留观状态:1正在留观,2曾经留观)$入院日期^入院时间$出院日期^出院时间
/// EXEC: w ##class(DHCMA.Util.IO.FromHisSrv).getEmStayInfo(23026798)
ClassMethod getEmStayInfo(aEpisodeID As %String, aTmpCnt As %String = "0") As %String
{
	New (aEpisodeID,aTmpCnt)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set $ZT="getEmStayInfoErr"
	
	Set aTmpCnt=+aTmpCnt
	If aTmpCnt<1 {
		Set return=##Class(web.DHCNurInterface).getEmStayInfo(aEpisodeID)
	} ElseIf aTmpCnt=1 {
		Set stayStatus=..GetStayStatus(aEpisodeID)
		Set admDateTime=..GetAdmDateTime(aEpisodeID)
		Set dischargeDateTime=..GetDischDateTime(aEpisodeID)
		Set return=stayStatus_"$"_admDateTime_"$"_dischargeDateTime
	} Else {
		Quit:aTmpCnt>1 return
	}
	Quit return
	
getEmStayInfoErr
	Set aTmpCnt=aTmpCnt+1
	Set return=..getEmStayInfo(aEpisodeID,aTmpCnt)
	Quit return
}

/// 医生站/计费接口
/// 返回值 1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观
/// w ##class(DHCMA.Util.IO.FromHisSrv).GetStayStatus(14402247)
ClassMethod GetStayStatus(Adm) As %String
{
	n (Adm)
	s ii=0
    s rtn=-1
    q:(Adm="") rtn
   
    s Admtype=$p($g(^PAADM(Adm)),"^",2)
    ;b
    q:(Admtype'="E" ) rtn
    s AdmRea=$p($g(^PAADM(Adm,1)),"^",7)
    q:$g(AdmRea)="" rtn		//PAC_AdmReason收费类型
    s InsurFlag=+$p($g(^PAC("ADMREA",+AdmRea)),"^",9)
    ;q:(InsurFlag=0) rtn		//非医保
	s BedCodeDr=$p($g(^PAADM(Adm)),"^",73)
	;s ^TmpWudan(Adm,2)=Adm
	;b  //非医保
	q:(BedCodeDr="")!(BedCodeDr=0) rtn	//	无床位
	;s ^TmpWudan(Adm,3)=Adm
	;b ;BedCodeDr
     s PatAllStatusCode=""
    s PatCurStatusDr=""
	f  s PatCurStatusDr=$o(^DHCADMVisitStatus(0,"PAADM",Adm,PatCurStatusDr)) q:(PatCurStatusDr="")  d
	.s PatCurStatusCTid=$p($g(^DHCADMVisitStatus(PatCurStatusDr)),"^",2)
	.q:PatCurStatusCTid=""
	.s PatCurStatusCode=$p($g(^DHCPACVisitStatus(PatCurStatusCTid)),"^",1)
	.s PatCurStatusCode=$zcvt(PatCurStatusCode,"U")
	.s ii=ii+1
	.i PatAllStatusCode="" d
	..s PatAllStatusCode=PatCurStatusCode
	.e  d
	..s PatAllStatusCode=PatAllStatusCode_"^"_PatCurStatusCode
	//b ;;
	q:((PatAllStatusCode'["STAY")&(PatAllStatusCode'["SALVAGE")) rtn  //状态变更中不包含留观或抢救
	
	i (($p(PatAllStatusCode,"^",ii)="STAY")!($p(PatAllStatusCode,"^",ii)="SALVAGE")) s rtn=1   //留观状态,当前为留观或抢救
	e  s rtn=2 //曾经留观	
	q rtn
}

/// Creator：     zhufei
/// CreatDate：   2016-1-19
/// Description:  取出院时间索引
/// Table：       Pa_Adm、User.PAAdmExt
/// Input：       
/// Return：      return=出院时间索引
/// w ##Class(DHCMA.Util.IO.FromHisSrv).GetDischDateIndex()
ClassMethod GetDischDateIndex() As %String
{
	New
	//If $d(^PAADMi("DischargeDateExt")) {
	If $d(^DHCDishChargeSet("Disch","ifGetDischgDateTimeByDoc")){
		Set return="DischargeDateExt"
	} Else {
		Set return="DischDate"
	}
	Quit return
}

/// 转换日期格式
/// w ##Class(DHCMA.Util.IO.FromHisSrv).ChangeDateFormat(+$h,3)
ClassMethod ChangeDateFormat(aValue As %String, aFormat As %String = "3") As %String
{
	New (aValue,aFormat)
	Set return=""
	Quit:aValue="" return
	Set aFormat=+aFormat
	Quit:(aFormat'=3)&&(aFormat'=4) return
	Set:aValue["-" aValue=$zdh(aValue,3)
	Set:aValue["/" aValue=$zdh(aValue,4)
	Set return=$zd(aValue,aFormat)
	Quit return
}

/// 转换时间格式
/// w ##Class(DHCMA.Util.IO.FromHisSrv).ChangeTimeFormat($p($h,",",2),1)
ClassMethod ChangeTimeFormat(aValue As %String, aFormat As %String = "1") As %String
{
	New (aValue,aFormat)
	Set return=""
	Quit:aValue="" return
	Set aFormat=+aFormat
	Quit:(aFormat'=1)&&(aFormat'=2) return
	Set:aValue[":" aValue=$zth(aValue,1)
	Set return=$zt(+aValue,aFormat)
	Quit return
}

/// Desc：		取患者就诊类型
/// Table:  		
/// Input：     aEpisodeID : 就诊号
/// Return：      	
/// w ##Class(DHCMA.Util.IO.FromHisSrv).GetPAAdmType(23379132)
ClassMethod GetPAAdmType(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	Set return=""
    Quit:aEpisodeID="" return
    
    Set return = $p($g(^PAADM(aEpisodeID)),"^",2)  			//就诊类型
    Quit return
}

/// Desc: 用于JSON向前台输出时特殊字符转义
/// w ##class(DHCMA.Util.IO.FromHisSrv).ReplaceSpecialChar("DH东华动画好的好的还很多"_$c(8)_"hdh"_$c(12)_"哈哈哈哈的")
ClassMethod ReplaceSpecialChar(aStr As %String) As %String
{
	New (aStr)
	
	set aStr = $replace(aStr,"\","\\")  		//必须放第一个
	set aStr = $replace(aStr,$c(8) ,"\b")		//退格符 		\u0008
	set aStr = $replace(aStr,$c(9) ,"\t")		//水平制表符 	\u0009
	set aStr = $replace(aStr,$c(10),"\n")		//换行符 		\u000A
	set aStr = $replace(aStr,$c(11),"\v")		//垂直制表符 	\u000B
	set aStr = $replace(aStr,$c(12),"\f")		//换页符		\u000C
	set aStr = $replace(aStr,$c(13),"\r")		//回车			\u000D
	set aStr = $replace(aStr,$c(34),"\""")		//双引号
	set aStr = $replace(aStr,$c(39),"\'")		//单引号
	quit aStr
}

/// Description:		获取患者出院状态和出院日期
/// Inputs:				aEpisodeID:就诊RowID
/// 					aFlg:返回日期格式（1：前端显示格式；2：M语言日期格式）
/// w ##class(DHCMA.Util.IO.FromHisSrv).GetDischInfo(50,1)
ClassMethod GetDischInfo(aEpisodeID As %String, aFlg As %String = 1) As %String
{
	New (aEpisodeID,aFlg)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set (VistStatus,DischDate,DischTime)=""
	Set VistStatus=$p($g(^PAADM(+aEpisodeID)),"^",20)
	Set DateTime=..GetDischDateTime(+aEpisodeID)
	Set DischDate=$p(DateTime,"^",1)
	Set DischTime=$p(DateTime,"^",2)
	If (aFlg=1)&&(DischDate'="")&&(DischTime'=""){
		Set DischDate=..DateLogicalToHtml(DischDate)
		Set DischTime=$zt(DischTime,1)	
	}
	Set return=VistStatus_"^"_DischDate_"^"_DischTime
	Quit return
}

/// Creator:			yankai
/// Description:		封装demo(护理组)配置出院医嘱
/// Inputs:				
/// Return:
/// w ##class(DHCMA.Util.IO.FromHisSrv).GetDischNeedArcim()
ClassMethod GetDischNeedArcim(aHospID As %String = "") As %String
{
	New (aHospID,%session)
	Set return=""
	Set:(aHospID="")&&($d(%session)) aHospID=$g(%session.Data("LOGON.HOSPID"))
	
	Set $ZT="GetDischNeedArcimErr"
	Set retVal=##Class(Nur.Interface.OutSide.Order).GetDischargeNeedArcim("dischargeNeedArcim", +aHospID)
	For indx=1:1:$l(retVal,"^"){
		Continue:$p(retVal,"^",indx)=""
		Set return=return_"^"_$p(retVal,"^",indx)
	}
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
	
GetDischNeedArcimErr
	Quit ""
}

/// Creator:			yankai
/// Description:		封装demo(护理组)配置转科医嘱
/// Inputs:				
/// Return:
/// w ##class(DHCMA.Util.IO.FromHisSrv).GetTransNeedArcim()
ClassMethod GetTransNeedArcim(aHospID As %String = "") As %String
{
	New (aHospID,%session)
	Set return=""
	Set:(aHospID="")&&($d(%session)) aHospID=$g(%session.Data("LOGON.HOSPID"))
	
	Set $ZT="GetTransNeedArcimErr"
	Set retVal=##Class(Nur.Interface.OutSide.Order).GetArcimBeforeTrans("",+aHospID)
	For indx=1:1:$l(retVal,"^"){
		Continue:$p(retVal,"^",indx)=""
		Set return=return_"^"_$p(retVal,"^",indx)
	}
	
	Set:return'="" return=$e(return,2,$l(return))
	Quit return
	
GetTransNeedArcimErr
	Quit ""
}

}
