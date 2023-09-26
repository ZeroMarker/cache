/// 名称: DHCHAI.IO.FromHisSrv
/// 描述: HIS提供接口服务
/// 编写者：zhufei
/// 编写日期: 2015-01-29
Class DHCHAI.IO.FromHisSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-09-19
/// Description:  根据配置修改日期存储格式【From系统平台】
/// Input：       aDate : 日期
/// Return:		  返回String Cache日期格式
/// w ##Class(DHCHAI.IO.FromHisSrv).GetDateFormat()
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
/// w ##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical("2017-03-12")
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
/// w ##Class(DHCHAI.IO.FromHisSrv).TimeHtmlToLogical("12:12")
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
/// w ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(+$h)
ClassMethod DateLogicalToHtml(aDate As %String) As %String
{
	New (aDate)
	Set return=""
	Quit:aDate="" return
	
	Quit:aDate["-" aDate  //已经转换了，不需要再转换
	Quit:aDate["/" aDate  //已经转换了，不需要再转换
	
	Set $ZT="DateLogicalToHtmlErr"
	Set MethodFalg=##class(DHCHAI.BT.Config).GetValByCode("CUS-DateLogicalToHtml","")
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
/// w ##class(DHCHAI.IO.FromHisSrv).GetPapmiAge(100,"","2015-01-01","")
ClassMethod GetPapmiAge(aPatientID As %String, aEpisodeID As %String, aDate As %String, aTime As %String) As %String
{
	New (aPatientID,aEpisodeID,aDate,aTime)
	Set return=0
	Quit:(aPatientID="")||(aEpisodeID="") return
	Set $ZT="UDHCJFGetPapmiAgeErr"
	//update  2020-06-11 标准版年龄接口增加医院参数后修改
	Set HospID="",AdmDepDr=""
	Set AdmDepDr=$p($g(^PAADM(aEpisodeID)),"^",4)
	Set HospID=$p(^CTLOC(+AdmDepDr),"^",22)
	Set return=##class(web.DHCBillInterface).GetPapmiAge(aPatientID,aEpisodeID,HospID,aDate,aTime)
	Quit return
UDHCJFGetPapmiAgeErr
	Set return=..CalAge(aPatientID,aEpisodeID,aDate,aTime)
	Quit return
}

ClassMethod CalAge(aPatientID As %String, aEpisodeID As %String, aDate As %String, aTime As %String) As %String
{
	New (aPatientID,aEpisodeID,aDate,aTime)
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
/// Return：      return=0:表示发送成功  return<0:表示发送失败
/// w ##class(DHCHAI.IO.FromHisSrv).SendMsg(aContext,aActTypeCode,aFromUser,aEpisodeID,aToUser,aLnkJson)
ClassMethod SendMsg(aContext As %String, aActTypeCode As %String, aFromUser As %String, aEpisodeID As %String, aToUser As %String = "", aLnkJson As %String = "") As %String
{
	New (aContext,aActTypeCode,aFromUser,aEpisodeID,aToUser,aLnkJson)
	
	Set $ZT="DHCMessageSendMsgErr"
	Set return=##class(websys.DHCMessageInterface).Send(aContext,aActTypeCode,aFromUser,aEpisodeID,"",aToUser,aLnkJson)
	Quit return
	
DHCMessageSendMsgErr
	Quit "-999^"_$ZError
}

/// Creator：     pylian
/// CreatDate：   2020-01-17
/// Description:  HIS阅读消息(处理一个人的消息，当前未处理的都处理)
/// Table：       websys.DHCMessageInterface
/// Input：       aActTypeCode ：消息类型代码
///               aMsgDetailsID ：消息明细表 Id
///               aEpisodeID ：就诊号
///               aActUserID ：处理用户 Id（可以为空）
/// Return：      return=0:表示发送成功  return<0:表示发送失败
/// w ##class(DHCHAI.IO.FromHisSrv).ReadMsg("1011","",158,"")
ClassMethod ReadMsg(aActTypeCode As %String, aMsgDetailsID As %String, aEpisodeID As %String, aActUserID As %String = "") As %String
{
	New (aActTypeCode,aMsgDetailsID,aEpisodeID,aActUserID)
	
	Set $ZT="DHCMessageReadMsgErr"	
	
	Set ActTypeID= $o(^websys.DHCMessageActionTypeI("ActionCode"," "_aActTypeCode,""))
	Set xContentID=""
	For {
		Set xContentID=$o(^websys.DHCMessageContentI("TypeOrderObj",ActTypeID," "_aEpisodeID," ",xContentID))   
		Quit:(xContentID="")
		
		Set ContentStatus= $lg(^websys.DHCMessageContentD(xContentID),19)
		Continue:ContentStatus'="N"
		Set xToUserID=""
		For {
			Set xToUserID=$O(^websys.DHCMessageDetailsI("ContentUser",xContentID,xToUserID)) 
			Quit:(xToUserID="")
			Set xDetailsID=""
			For {
				Set xDetailsID=$O(^websys.DHCMessageDetailsI("ContentUser",xContentID,xToUserID,xDetailsID)) 
				Quit:(xDetailsID="")
				
				Set ReadFlag=$lg(^websys.DHCMessageDetailsD(xDetailsID),6)   //消息是否阅读过
				Set ExecFlag=$lg(^websys.DHCMessageDetailsD(xDetailsID),10)  //消息是否处理过 , 处理过则一定读过
		        Continue:ExecFlag'="N"
		        do ##class(websys.DHCMessageInterface).ExecAll(xDetailsID,aActUserID,"","")
		       

			}
		}
	}
	Quit 1
	
DHCMessageReadMsgErr
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2015-03-13
/// Description:  插入医嘱【From医生站】
/// Table：       oe_orditem
/// Input：       Adm ：就诊号
///               OrdItemStr ：医嘱信息
///               User ：下医嘱用户
///               Loc ：下医嘱科室
///               Doc ：下医嘱医生
///               PrescPara ：参数
/// Return：      return<=0:表示发送失败
/// w ##class(DHCHAI.IO.FromHisSrv).SaveOrderItems(aContext,aActTypeCode,aFromUser,aEpisodeID,aToUser,aLnkJson)
ClassMethod SaveOrderItems(aAdm As %String, aOrdItemStr As %String, aUser As %String, aLoc As %String, aDoc As %String, aPrescPara As %String = "") As %String
{
	New (aAdm,aOrdItemStr,aUser,aLoc,aDoc,aPrescPara)
	
	Set $ZT="DHCOESaveOrderItemsErr"
	Set return=##class(web.DHCOEOrdItem).SaveOrderItems(aAdm,aOrdItemStr,aUser,aLoc,aDoc,aPrescPara)
	Quit return
	
DHCOESaveOrderItemsErr
	Quit "-999^"_$ZError
}

/// Creator：     zhufei
/// CreatDate：   2018-07-12
/// Description:  根据科室获取医院ID
/// Table：       CT_Hospital,CT_Loc
/// Input：       aLocID  : 科室ID
/// Return：      返回医院ID
/// w ##class(DHCHAI.IO.FromHisSrv).GetCTHospID(1)
ClassMethod GetCTHospID(aLocID As %String)
{
	new (aLocID)
	set return=""
	quit:(aLocID="") return
	
	quit:'$d(^CTLOC(aLocID)) return
	
	set HospitalID=$p($g(^CTLOC(aLocID)),"^",22)
	if HospitalID="" {
		set xID=0
		for {
			set xID=$o(^DHCHAI.BT.HospitalD(xID))
			quit:xID=""
			
			set objHosp=##class(DHCHAI.BT.Hospital).GetObjById(xID)
			continue:'$IsObject(objHosp)
			continue:objHosp.BTIsActive'=1
			set XCode=objHosp.BTXCode
			set CTHospID=$p(XCode,"||",2)
			continue:CTHospID=""
			continue:'$d(^CT("HOSP",CTHospID))
			set HospitalID=CTHospID
		}
	}
	
	set return=HospitalID
	quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-05-30
/// Description:  取医嘱标本【From医生站】
/// Input：       OEItemID : 医嘱号
/// Return:		  返回String 格式：标本代码_"^"_标本名称
/// w ##class(DHCHAI.IO.FromHisSrv).GetOrdSpecimen("1432||1")
ClassMethod GetOrdSpecimen(aOEItemID As %String) As %String
{
	New (aOEItemID)
	Set return=""
	Quit:(aOEItemID="") return
	
	Set $ZT="GetOrdSpecimenErr"
	Set OrdID=$p(aOEItemID,"||",1)
	Set SubID=$p(aOEItemID,"||",2)
	Quit:(OrdID="")||(SubID="") return
	
	Set SpecimenID="",SpecimenCode="",SpecimenDesc=""
	Set SpecDr=$o(^OEORD(OrdID,"I",SubID,"SPEC",""),-1)
	Set:SpecDr'="" SpecimenCode=$p(^OEORD(OrdID,"I",SubID,"SPEC",SpecDr),"^",1)
	Quit:SpecimenCode="" return
	
	If $d(^DHCLISBSVersion(1)) {
		Set Paadm=$p($g(^OEORD(OrdID)),"^",1)
		Set AdmLoc=$p($g(^PAADM(+Paadm)),"^",4)
		Set CTHospID=..GetCTHospID(AdmLoc)
		Quit:CTHospID="" return
		//Index IndexCode On (HospitalDR, Code)
		Set CTHospCode=$p($g(^CT("HOSP",CTHospID)),"^",1)
		Set HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(CTHospCode),""))
		If '$l(HospitalDR) Set HospitalDR = $o(^dbo.BTHospitalD(""))
		
		
		Set SpecimenID=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData($zcvt(SpecimenCode,"U")),""))
		//总院分院 使用同一套检验系统来，分院未维护标本字典 取总院数据
		If SpecimenID="" {
			Set HospitalDR = $o(^dbo.BTHospitalD(""))
			Set SpecimenID=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData($zcvt(SpecimenCode,"U")),""))
		}
		Set SpecimenDesc=$lg($g(^dbo.BTSpecimenD(+SpecimenID)),3)
	} Else {
		Set SpecimenID=SpecimenCode
		Set SpecimenDesc=$p(^TTAB("SPEC",SpecimenCode),"\",1)
		//Set SpecimenCode=$p($g(^OEORD(OrdID,"I",SubID,8)),"^",16)  //标本 OEORI_Lab1
		//Set:SpecimenCode'="" SpecimenDesc=$p($g(^DHCSpS("SPS",SpecimenCode)),"^",2)
	}
	Set return=SpecimenID_"^"_SpecimenCode_"^"_SpecimenDesc
	Quit return
	
GetOrdSpecimenErr
	Quit "-999^"_$ZError
}

/// Creator：     chenjb
/// CreatDate：   2017-11-06
/// Description:  取两个时间的间隔秒
/// Input：       OEItemID : 医嘱号
/// Return:		  返回String 格式：标本代码_"^"_标本名称
/// w ##class(DHCHAI.IO.FromHisSrv).GetDateTimeDiff("2017-11-06","12:00:59","2017-11-06","12:00:59")
ClassMethod GetDateTimeDiff(aStartDate As %String, aStartTime As %String, aEndDate As %String, aEndTime As %String) As %String
{
	New (aStartDate,aStartTime,aEndDate,aEndTime)
	Set ret =0
	Quit:(aStartDate="")||(aStartTime="")||(aEndDate="")||(aEndTime="") -1
	
	Set dt1 = +##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aStartDate)
	Set dt2 = +##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aEndDate)
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
/// CreatDate：   2018-03-16
/// Description:  获取第一次的生命体征值()【From护理】
/// Input：       aEpisodeID ：就诊ID
///               aItemCode:生命体征代码
/// Return：      
/// w ##class(DHCHAI.IO.FromHisSrv).GetFirstItemValue(17,"weight")
ClassMethod GetFirstItemValue(aEpisodeID As %String, aItemCode As %String = "") As %String
{
	New (aEpisodeID,aItemCode)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set $ZT="GetFirstItemValueErr"
	Set MethodFalg=##class(DHCHAI.BT.Config).GetValByCode("CUS-BabyWeightMethodFalg","")
	If aItemCode="" {
		Set aItemCode=##class(DHCHAI.BT.Config).GetValByCode("CUS-BabyWeightItemCode","")
		Set:aItemCode="" aItemCode="weight"
	}
	If (+MethodFalg)<1 {
		Set return=##Class(DHCHAI.IO.BuildNurSrv).getFirstItemValue(aEpisodeID,aItemCode)
	} Else {
		Set return=##Class(web.DHCNurInterface).getFirstItemValue(aEpisodeID,aItemCode)
	}
	Quit return
	
GetFirstItemValueErr
	Quit ""
}

/// Creator：     pylian
/// CreatDate：   2018-03-23
/// Description:  获取抗菌药物的使用情况信息（SENO：F0005）
/// Input：       oeori ：医嘱项ID
/// Return：      使用目的、其他原因、是否送检、感染部位、申请日期、申请时间
/// EXEC: w ##class(DHCHAI.IO.FromHisSrv).GetAntUseInfo("650||202")
ClassMethod GetAntUseInfo(oeori As %String) As %String
{
	New (oeori)
	Set return=""
	Quit:(oeori="") return
	
	Set $ZT="GetAntUseInfoErr"
	Set MethodFalg=##class(DHCHAI.BT.Config).GetValByCode("CUS-AntiUseMethodFalg","")
	If (+MethodFalg)<1 {
		Set return=##Class(DHCHAI.IO.BuildAntiSrv).GetAntUseInfo(oeori)
	} Else {
		Set return=##class(DHCAnt.Serve.ComOut).GetAntUseInfo(oeori)
	}
	Quit return
	
GetAntUseInfoErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2018-03-29
/// Description:  根据就诊取急诊留观信息
/// Input：       aEpisodeID ：就诊号
/// Return：      status(留观状态:1正在留观,2曾经留观)$入院日期^入院时间$出院日期^出院时间
/// EXEC: w ##class(DHCHAI.IO.FromHisSrv).getEmStayInfo(23026798)
ClassMethod getEmStayInfo(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set $ZT="getEmStayInfoErr"
	Set MethodFalg=##class(DHCHAI.BT.Config).GetValByCode("CUS-EPStayStatus","")
	If (+MethodFalg)<1 {
		Set return=##Class(DHCHAI.IO.BuildNurSrv).getEmStayInfo(aEpisodeID)
	} Else {
		Set return=##Class(web.DHCNurInterface).getEmStayInfo(aEpisodeID)
	}
	Quit return
	
getEmStayInfoErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2018-03-29
/// Description:  根据就诊取急诊留观信息
/// Input：       aEpisodeID ：就诊号
/// Return：      status(留观状态:1正在留观,2曾经留观)$入院日期^入院时间$出院日期^出院时间
/// EXEC: w ##class(DHCHAI.IO.FromHisSrv).GetStayStatus()
ClassMethod GetStayStatus(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:(aEpisodeID="") return
	
	Set $ZT="GetStayStatusErr"
	Set MethodFalg=##class(DHCHAI.BT.Config).GetValByCode("CUS-EPStayStatus","")
	If (+MethodFalg)<1 {
		Set return=##Class(DHCHAI.IO.BuildNurSrv).GetStayStatus(aEpisodeID)
	} Else {
		Set return=##class(web.DHCADMVisitStat).GetStayStatus(aEpisodeID)
	}
	Quit return
	
GetStayStatusErr
	Quit ""
}

/// Creator：     pylian
/// CreatDate：   2020-03-11
/// Description:  判断患者离床日期是否超一天
/// Input：       aEpisodeID:就诊号
/// Return：      1:是 0:否
/// EXEC: w ##class(DHCHAI.IO.FromHisSrv).GetPatOutBedFlag(175)
ClassMethod GetPatOutBedFlag(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return
	
	Set $ZT="GetPatOutBedFlagErr"
	Set return=##Class(DHCHAI.IO.BuildNurSrv).getPatOutBedFlag(aEpisodeID)
	Quit return
	
GetPatOutBedFlagErr
	Quit ""
}

}
