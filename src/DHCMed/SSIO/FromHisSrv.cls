/// 名称: DHCMed.SSIO.FromHisSrv
/// 描述: HIS提供接口服务
/// 编写者：zhufei
/// 编写日期: 2015-01-29
Class DHCMed.SSIO.FromHisSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-01-30
/// Description:  取患者年龄【From计费组】
/// Input：       PatientID : 病人ID
///               EpisodeID : 就诊号
///               Date : 日期（可选，为空按当前日期计算）
///               Time : 时间（可选，为空按当前时间计算）
/// Return:		  返回String 格式：*岁*月*天
/// w ##class(DHCMed.SSIO.FromHisSrv).GetPapmiAge(356,"","","")
ClassMethod GetPapmiAge(aPatientID As %String, aEpisodeID As %String, aDate As %String, aTime As %String) As %String
{
	New (aPatientID,aEpisodeID,aDate,aTime,%session)
	Set $ZT="UDHCJFGetPapmiAgeErr"
	Set return=0
	Quit:(aPatientID="")&&(aEpisodeID="") return
	Set Languages = "CH"
	If ($d(%session)){
		Set langid=+$g(%session.Data("LOGON.LANGID"))
		Set:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
	}
	
	Set:'$Number(aDate) aDate=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDate)
	Set HospID="",AdmDepDr=""
	Set:aEpisodeID'="" AdmDepDr=$p($g(^PAADM(aEpisodeID)),"^",4)
	Set HospID=$p(^CTLOC(+AdmDepDr),"^",22)
	Set:aEpisodeID="" HospID=%session.Get("LOGON.HOSPID")
	Set return=##class(web.DHCBillInterface).GetPapmiAge(aPatientID,aEpisodeID,HospID,aDate,aTime)
	If Languages'="CH" {
		Set return=$$UDHCJFGetPapmiAgeErr
	}
	Set AgeNumber = +return
	Set AgeUnit = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,$p(return,AgeNumber,2))
	Set return = AgeNumber_AgeUnit
	Quit return
UDHCJFGetPapmiAgeErr
	Set return=..CalAge(aPatientID,aEpisodeID,aDate,aTime)
	Set AgeNumber = +return
	Set AgeUnit = ##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("DHCMed.SS.Dictionary","Description",Languages,$p(return,AgeNumber,2))
	Set return = AgeNumber_AgeUnit
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
	q:'$G(IBirth) "未知"
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
/// w ##class(DHCMed.SSIO.FromHisSrv).SendMsg(aContext,aActTypeCode,aFromUser,aEpisodeID,aToUser,aLnkJson)
ClassMethod SendMsg(aContext As %String, aActTypeCode As %String, aFromUser As %String, aEpisodeID As %String, aToUser As %String = "", aLnkJson As %String = "") As %String
{
	New (aContext,aActTypeCode,aFromUser,aEpisodeID,aToUser,aLnkJson)
	
	Set $ZT="DHCMessageSendMsgErr"
	Set return=##class(websys.DHCMessageInterface).Send(aContext,aActTypeCode,aFromUser,aEpisodeID,"",aToUser,aLnkJson)
	Quit return
	
DHCMessageSendMsgErr
	Quit "-999^"_$ZError
}

/// Creator：     mxp
/// CreatDate：   2017-07-07
/// Description:  撤销发到往消息平台的消息【to基础平台组】
/// Table：       websys.DHCMessageInterface
/// Input：       aToUserId ：单个用户Id
///               aActionType ：消息类型代码
///               aEpisodeId ：就诊号
/// 				  aObjectId: 发送消息时OtherJson内包含的串
///               aExecUserDr ：处理用户Id（可以为空）
/// 				  aExecDate：处理日期（可以为空）
///               aExecTime ：处理时间（可以为空）
/// Return：      return=0:表示发送成功  return<0:表示发送失败
/// w ##class(DHCMed.SSIO.FromHisSrv).CancelMsg(aContext,aActTypeCode,aFromUser,aEpisodeID,aToUser,aLnkJson)
ClassMethod CancelMsg(aToUserId As %String, aActionType As %String, aEpisodeId As %String, aObjectId As %String, aExecUserDr As %String = "", aExecDate As %String = "", aExecTime As %String = "") As %String
{
	New (aToUserId, aActionType, aEpisodeId, aObjectId, aExecUserDr, aExecDate, aExecTime)
	
	Set $ZT="DHCMessageCancelMsgErr"
	Set return=##class(websys.DHCMessageInterface).Cancel(aToUserId,aActionType,aEpisodeId,"",aObjectId,aExecUserDr,aExecDate,aExecTime)
	Quit return
	
DHCMessageCancelMsgErr
	Quit "-999^"_$ZError
}

/// Creator：     mxp
/// CreatDate：   2017-07-23
/// Description:  消息平台 医生读取特殊患者消息后同步医务组业务数据【to基础平台组】
/// Table：      
/// Input：       aNewID ：发送消息时传递的业务ID
///               aActUserId ：单个用户Id
/// Return：      return=0:表示发送成功  return<0:表示发送失败
/// w ##class(DHCMed.SSIO.FromHisSrv).ReadSPENews(EpisodeId,OrdItemId,BizObjId,ReadUserRowId,ReadDate,ReadTime)
ClassMethod ReadSPENews(EpisodeId As %String, OrdItemId As %String, BizObjId As %String, ReadUserRowId As %String, ReadDate As %String = "", ReadTime As %String = "") As %String
{
	New (EpisodeId,OrdItemId,BizObjId,ReadUserRowId,ReadDate,ReadTime)
	
	Set $ZT="DHCMessageReadSPENewsErr"
	Set aNewID=BizObjId
	Set return=##class(DHCMed.SPEService.PatientsSrv).ReadNews("",ReadUserRowId,1,aNewID,"Y")
	Quit return
	
DHCMessageReadSPENewsErr
	Quit "-999^"_$ZError
}

/// Creator：     mxp
/// CreatDate：   2017-07-23
/// Description:  消息处理通知消息平台 【from基础平台组】
/// Table：      
/// Input：       ToUserId ：单个用户Id
///               ActionType ：消息类型代码
///               EpisodeId ：就诊号
/// 			  ObjectId: 发送消息时OtherJson内包含的串
///               ExecUserDr ：处理用户Id（可以为空）
/// 			  ExecDate：处理日期（可以为空）
///               ExecTime ：处理时间（可以为空）
/// Return：      return>0:表示处理成功  return<0:表示发送失败
/// w ##class(DHCMed.SSIO.FromHisSrv).Exec(ToUserId,ActionType,EpisodeId,ObjectId,ExecUserDr,ExecDate,ExecTime)
ClassMethod Exec(ToUserId As %String, ActionType As %String, EpisodeId As %String, ObjectId As %String, ExecUserDr As %String = "", ExecDate As %String = "", ExecTime As %String = "") As %String
{
	New (ToUserId,ActionType,EpisodeId,ObjectId,ExecUserDr,ExecDate,ExecTime)

	Set $ZT="DHCMessageExecMsgErr"
	Set return=##class(websys.DHCMessageInterface).Exec(ToUserId, ActionType,EpisodeId,"",ObjectId,ExecUserDr,ExecDate,ExecTime)
	Quit return
	
DHCMessageExecMsgErr
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
/// w ##class(DHCMed.SSIO.FromHisSrv).SaveOrderItems(aContext,aActTypeCode,aFromUser,aEpisodeID,aToUser,aLnkJson)
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
/// CreatDate：   2016-05-30
/// Description:  取医嘱标本【From医生站】
/// Input：       OEItemID : 医嘱号
/// Return:		  返回String 格式：标本代码_"^"_标本名称
/// w ##class(DHCMed.SSIO.FromHisSrv).GetOrdSpecimen("1432||1")
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
		Set CTHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
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

}
