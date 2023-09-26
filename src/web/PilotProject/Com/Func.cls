/// CTOR: QP
/// DATE: 2020-12-28
/// DESC: 临床药理公共类
Class web.PilotProject.Com.Func Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-12-28
/// DESC: 判断是否为临床药理医嘱
/// IN  : 
/// OUT : 1:是，0：否
/// EXEC: w ##class(web.PilotProject.Com.Func).IsGCPOrder()
ClassMethod IsGCPOrder(oeori)
{
	s mRtn=0
	s PPRowID=$p($G(^OEORD(+oeori,"I",$p(oeori,"||",2),"DHC")),"^",10)
	i PPRowID'="" s mRtn=1
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-01-18
/// DESC: 判断日期大小
/// IN  : 
/// OUT : 1:d1 0:= -1:d2
/// EXEC: w ##class(web.PilotProject.Com.Func).CompareDate(65762,65762,37327,37328)
ClassMethod CompareDate(d1, d2, t1 = "", t2 = "")
{
	s mRtn=""
	Q:(d1="")||(d2="") mRtn
	s d1=##class(websys.Conversions).DateHtmlToLogical(d1)
	s d2=##class(websys.Conversions).DateHtmlToLogical(d2)
	i (t1'="")&&(t2'="") {
		s dt1=..GetAbsTime(d1_","_t1)
		s dt2=..GetAbsTime(d2_","_t2)
		i dt1>dt2 {
			s mRtn=1
		}elseif dt1=dt2 {
			s mRtn=0
		} else {
			s mRtn=-1
		} 
		
	} else {
		i d1>d2 {
			s mRtn=1
		}elseif d1=d2 {
			s mRtn=0
		} else {
			s mRtn=-1
		} 
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-01-18
/// DESC: 将日期转换成定量数值(秒)
/// IN  : 
/// OUT : 
/// 
/// EXEC: 
ClassMethod GetAbsTime(dt As %String) As %String
{
  
  s dat=$P(dt,",",1),tim=$P(dt,",",2)
  q ((dat*86400)+tim)
}

/// CTOR: QP
/// DATE: 2020-12-28
/// DESC: 得到医院描述
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Com.Func).GetHospName(2)
ClassMethod GetHospName(id)
{
	s mRtn=""
	q:id="" mRtn
	s mRtn=$p(^CT("HOSP",id),"^",2)
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2021-12-09
/// DESC: 是否不显示临床免费医嘱
/// IN  : 
/// OUT : 
/// EXEC: w ##class(web.PilotProject.Com.Func).IsGCPOrder()
ClassMethod NoFreeGcp()
{
	s USERID=%session.Get("LOGON.USERID")
	s GROUPID=%session.Get("LOGON.GROUPID")
	s HOSPID=%session.Get("LOGON.HOSPID")
	s NoFreeGcp=+$g(^DHCDocConfig("HospDr_"_HOSPID,"NoFreeGcp",GROUPID))
	i NoFreeGcp=1 {
		Q 1	;显示
	} else {
		Q 0
	}
}

/// CTOR: QP
/// DATE: 2021-12-10
/// DESC: 判断项目是否配置了阶段
/// IN  : 
/// OUT : 1：已经配置，-1：没有配置，-2：没有配置第一个阶段
/// EXEC: w ##class(web.PilotProject.Com.Func).HasStage()
ClassMethod HasStage(PPRowId)
{
	s id=""
	s num=0,hasOne=0
	f  s id=$o(^CF.DOC.Pilot.OEStageI("Prj",PPRowId,id)) q:id=""  d
	.s active=$p(^CF.DOC.Pilot.OEStageD(id),"^",8)
	.Q:active'=1
	.s order=$p(^CF.DOC.Pilot.OEStageD(id),"^",3)
	.i order=1 s hasOne=1
	.s num=num+1
	
	q:num=0 "-122"
	q:hasOne=0 "-123"
	
	Q 1
}

/// CTOR: QP
/// DATE: 2022-01-11
/// DESC: 清除配置数据
/// IN  : 
/// OUT : 1
/// EXEC: w ##class(web.PilotProject.Com.Func).ClearCfg()
ClassMethod ClearCfg()
{
	k ^UDHCDocPilotProConfig
	k ^DHCDocPilotSeting
	
	&SQL(delete SQLUser.DHCDocPilotAuth)
	&SQL(delete SQLUser.DHCDocPilotAuthSub)
	
	
	Q 1
}

/// CTOR: QP
/// DATE: 2022-01-11
/// DESC: 清除业务数据
/// IN  : 
/// OUT : 1
/// EXEC: w ##class(web.PilotProject.Com.Func).ClearBS()
ClassMethod ClearBS()
{
	&SQL(delete SQLUser.DHC_DocPilotProPatAdmOrd)
	&SQL(delete SQLUser.DHC_DocPilotProPatAdm)
	&SQL(delete SQLUser.DHC_DocPilotProPat)
	&SQL(delete SQLUser.DHC_DocPilotProAccount)
	&SQL(delete SQLUser.DHC_DocPilotProCare)
	&SQL(delete SQLUser.DHC_DocPilotProECRecord)
	&SQL(delete SQLUser.DHCDoc_PilotProFileLog)
	&SQL(delete SQLUser.DHC_DocPilotProGCP)
	&SQL(delete SQLUser.DHC_DocPilotProQCZYZ)
	&SQL(delete SQLUser.DHC_DocPilotProQualityControl)
	&SQL(delete SQLUser.DHC_DocPilotProRemBefore)
	&SQL(delete SQLUser.DHC_DocPilotProSAE)
	&SQL(delete SQLUser.DHC_DocPilotProSOP)
	&SQL(delete SQLUser.DHC_DocPilotProSettle)
	&SQL(delete SQLUser.DHC_DocPilotProTrain)
	&SQL(delete SQLUser.DHC_DocPilotProYearCheck)
	&SQL(delete SQLUser.DHCDocPilotSAE)
	&SQL(delete SQLUser.DHCDocPilotSAEPat)
	&SQL(delete SQLUser.DHCDocPilotSAEStatus)
	&SQL(delete SQLUser.DHCDocPilotProDrug)
	&SQL(delete SQLUser.DHC_DocPilotProStage)
	&SQL(delete SQLUser.DHC_DocPilotProState)
	&SQL(delete SQLUser.DHC_DocPilotProRem)
	&SQL(delete SQLUser.DHC_DocPilotProject)
	&SQL(delete SQLUser.DHCDocPilotProFreeOrdLog)
	&SQL(delete SQLUser.DHC_DocPilotProFreeOrd)
	
	Q 1
}

}
