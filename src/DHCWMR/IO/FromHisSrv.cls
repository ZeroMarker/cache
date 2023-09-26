/// 名称: DHCWMR.IO.FromHisSrv
/// 描述: HIS提供接口服务
/// 编写者：zhufei
/// 编写日期: 2015-01-29
Class DHCWMR.IO.FromHisSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-01-28
/// Description:  财务审核方法（From计费组）
/// Input：       EpisodeID : 就诊号
///               UserID : 用户ID
/// Return:		  返回String
/// w ##class(DHCWMR.IO.FromHisSrv).UpdateCodingFlag()
ClassMethod UpdateCodingFlag(aEpisodeID As %String, aUserID As %String, aBillNo As %String = "", aComputerName As %String = "") As %String
{
	New (aEpisodeID,aUserID,aBillNo,aComputerName)
	Set return=0
	Quit:(aEpisodeID="")||(aUserID="") return
	Set $ZT="UDHCJFUpdateCodingFlagErr"
	Set flg=##Class(web.UDHCJFBaseCommon).Bill("","",aEpisodeID,aUserID,aBillNo,aComputerName)
	Set flg=##Class(web.UDHCJFORDCHK).UpdateCodingFlag(aEpisodeID,aUserID)
	Set return=1
	Quit return
UDHCJFUpdateCodingFlagErr
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2015-01-28
/// Description:  撤销财务审核（From计费组）
/// Input：       EpisodeID : 就诊号
///               UserID : 用户ID
/// Return:		  返回String
/// w ##class(DHCWMR.IO.FromHisSrv).Cconfirm()
ClassMethod Cconfirm(aEpisodeID As %String, aUserID As %String) As %String
{
	New (aEpisodeID,aUserID)
	Set return=0
	Quit:(aEpisodeID="")||(aUserID="") return
	Set $ZT="UDHCJFCconfirmErr"
	Set return=##Class(web.UDHCJFDischQuery).Cconfirm(aEpisodeID,aUserID)
	Quit return
UDHCJFCconfirmErr
	Quit 0
}

/// Creator：     zhufei
/// CreatDate：   2015-01-30
/// Description:  取患者年龄（From计费组）
/// Input：       PatientID : 病人ID
///               EpisodeID : 就诊号
///               Date : 日期（可选，为空按当前日期计算）
///               Time : 时间（可选，为空按当前时间计算）
/// Return:		  返回String 格式：*岁*月*天
/// w ##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(100,"","2015-01-01","")
ClassMethod GetPapmiAge(aPatientID As %String, aEpisodeID As %String, aDate As %String, aTime As %String) As %String
{
	New (aPatientID,aEpisodeID,aDate,aTime)
	Set return=0
	Quit:(aPatientID="")&&(aEpisodeID="") return
	Set $ZT="UDHCJFGetPapmiAgeErr"
	// add
	Set:(aPatientID="")&&(aEpisodeID'="") aPatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	if (aPatientID'="")&&(aEpisodeID=""){
		Set aEpisodeID=$o(^PAPERdr(aPatientID,"ADM","I",""),-1)
		Set:aEpisodeID="" aEpisodeID=$o(^PAPERdr(aPatientID,"ADM","O",""),-1)
	}
	
	Set Birthday		= $p($g(^PAPER(aPatientID,"ALL")),"^",6)		; 生日
	Set Birthday		= $zd(Birthday,3)
	Set tmpDateTime		= ##Class(DHCWMR.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set AdmitDate		= $p(tmpDateTime,"^",1)
	Set AdmitDate		= $zd(AdmitDate,3)							; 就诊日期
	Set tmpDeptWard		= ##Class(DHCWMR.SSService.CommonSrv).GetAdmitDept(aEpisodeID)
	Set AdmitDept		= $p(tmpDeptWard,",",1)						; 就诊科室
	Set CTHospID		= ##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(AdmitDept)
	
	Set return=##class(web.UDHCJFCOMMON).DispPatAge(Birthday,AdmitDate,"","",CTHospID)
	// end
	;Set return=##class(web.DHCBillInterface).GetPapmiAge(aPatientID,aEpisodeID,aDate,aTime)
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

	Set:aDate="" aDate=$p($g(^PAADM(+aEpisodeID)),"^",6)
	Set:aTime="" aTime=$p($g(^PAADM(+aEpisodeID)),"^",7)
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
	e  d
	.i AgeMth>0 d           // update by pylian 20150512 修改小于1岁的病人显示的年龄是天数
	..s AgeDay=0
	
	Set:AgeYear>0 return=AgeYear_"岁"
	Set:AgeMth>0 return=AgeMth_"月"
	Set:AgeDay>0 return=AgeDay_"天"
	Quit return
CalAgeErr
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2015-04-02
/// Description:  Medtrak中原有转换大写方法
/// Input：       Value : 值
/// Return:		  返回String
/// w ##class(DHCWMR.IO.FromHisSrv).ALPHAUP("aaa-")
ClassMethod ALPHAUP(aValue As %String) As %String
{
	New (aValue)
	Set return=$$ALPHAUP^SSUTIL4(aValue)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-04-02
/// Description:  就诊取出院转归情况
/// Input：       Value : 值
/// Return:		  返回String
/// w ##Class(DHCWMR.IO.FromHisSrv).GetDischCondit(10053325)
ClassMethod GetDischCondit(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set MRAdmId=$p($g(^PAADM(aEpisodeID)),"^",61)
	Quit:MRAdmId="" return
	Set DisConId=$p(^MR(+MRAdmId,"PRO",1),"^",10)
	Set return=$p($g(^PAC("DISCON",+DisConId)),"^",2)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2016-06-20
/// Description:  用户权限验证方法
/// Input：       UserCode : 用户名
///               Password ：密码
/// Return:		  返回String
/// w ##Class(DHCWMR.IO.FromHisSrv).ValidatePassword("med","1")
ClassMethod ValidatePassword(aUserCode As %String, aPassword As %String) As %String
{
	New (aUserCode,aPassword)
	Quit:(aUserCode="")||(aPassword="") 0
	Set aUserCode=$$ALPHAUP^SSUTIL4(aUserCode)
	Set aPassword=$$ENCR^SSUTIL2(aPassword)
	Set UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",aUserCode,""))
	Quit:UserID="" 0
	Set Password=$p($g(^SSU("SSUSR",UserID)),"^",3)
	Quit (Password=aPassword)
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
/// w ##class(DHCWMR.IO.FromHisSrv).SendMsg(aContext,aActTypeCode,aFromUser,aEpisodeID,aToUser,aLnkJson)
ClassMethod SendMsg(aContext As %String, aActTypeCode As %String, aFromUser As %String, aEpisodeID As %String, aToUser As %String = "", aLnkJson As %String = "") As %String
{
	New (aContext,aActTypeCode,aFromUser,aEpisodeID,aToUser,aLnkJson)
	
	Set $ZT="DHCMessageSendMsgErr"
	Set return=##class(websys.DHCMessageInterface).Send(aContext,aActTypeCode,aFromUser,aEpisodeID,"",aToUser,aLnkJson)
	Quit return
	
DHCMessageSendMsgErr
	Quit "-999^"_$ZError
}

/// Creator：     maxp
/// CreatDate：   2018-03-05
/// Description:  返回日期段中节假日数量【From基础平台组】
/// Table：       User.BDPHoliday
/// Input：       datefrom:开始日期，格式与HIS系统配置里的日期格式保持一致 ，开始日期不能为空
/// 			  dateto:结束日期，格式与HIS系统配置里的日期格式保持一致 ，结束日期不能为空，且不得早于开始日期
/// 			  serviceid：特殊业务id (在User.BDPSpecialService表中维护)，如果取公共节假日，特殊业务id传空即可
/// Return：	  Num
/// w ##class(DHCWMR.IO.FromHisSrv).CountHolidayDays("2018-01-01","2018-02-01")
ClassMethod CountHolidayDays(aDateFrom As %String, aDateTo As %String, aServicedr As %String = "") As %String
{
	New (aDateFrom,aDateTo,aServicedr)
	Set return=0
	Quit:(aDateFrom="")||(aDateTo="") return
	
	Set $ZT="CountHolidayDaysErr"
	Set return=##class(web.DHCBL.CT.BDPHoliday).GetHolidayDateNum(aDateFrom,aDateTo,aServicedr)
	
	Quit return
	
CountHolidayDaysErr
	Quit "-999^"_$ZError
}

/// Creator：     maxp
/// CreatDate：   2018-03-05
/// Description:  返回日期节假日标识【From基础平台组】
/// Table：       User.BDPHoliday
/// Input：		  date:日期，格式与HIS系统配置里的日期格式保持一致 ，日期不能为空
///        		  serviceid：特殊业务id (在User.BDPSpecialService表中维护)，如果取公共节假日，特殊业务id传空即可。
///        		  timerangedr:时段id（在User. DHCTimeRange表中维护）
/// Return：	  节日2/假日1/非节假日0 /错误-1
/// w ##class(DHCWMR.IO.FromHisSrv).IsHolidayDate("2018-01-01")
ClassMethod IsHolidayDate(aDate As %String, aServicedr As %String = "", aTimerangedr As %String = "") As %String
{
	New (aDate,aServicedr,aTimerangedr)
	Set return=-1
	Quit:(aDate="") return
	
	Set $ZT="IsHolidayDateErr"
	Set return=##class(web.DHCBL.CT.BDPHoliday).IsHolidayDate(aDate,aServicedr,aTimerangedr)
	
	Quit return
	
IsHolidayDateErr
	Quit "-999^"_$ZError
}

}
