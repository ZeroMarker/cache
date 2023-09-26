/// Creator: 	hxy
/// CreateDate: 2022-01-18
/// Descript: 	智能审方接口类
Class web.DHCPRESCInterface Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Descript:判断处方或者医嘱是否审核通过(暂停使用)
/// CreateDate:2022-02-22
/// Creator:sufan
/// Input:处方号
/// Output:0,通过,其他：未通过的医嘱Id串，@分隔
/// w ##class(web.DHCPRESCInterface).IsAuditPass("I220921000003")
ClassMethod IsAuditPass(presNo)
{
	s ret = 0
	s ordList = 0
	s auditId = $o(^PHA.PREADT.AuditI("PrescNo",presNo,""))
	Q:auditId="" ret
	s createDate = $lg(^PHA.PREADT.AuditD(auditId),13)			//创建日期
	Q:createDate'=+$h ret
	s createTime = $lg(^PHA.PREADT.AuditD(auditId),14)			//创建时间
	s statusId="",statusCode=""  											
	s resultId = $o(^PHA.PREADT.AuditResultI("Parref",auditId,""),-1)
	s:resultId'="" statusId = $lg(^PHA.PREADT.AuditResultD(resultId),6)
	s:statusId'="" statusCode = $lg(^CT.PHA.PREADT.DicItemD(statusId),2)			//结果代码
	Q:statusCode="STA04" ret
	
	s subId = ""
	for  s subId = $o(^PHA.PREADT.AuditListI("IndexParref",auditId,subId))  Q:subId=""  d
	.s ordItemId = $lg(^PHA.PREADT.AuditListD(subId),17)
	.s itemStatId = $p($g(^OEORD(+ordItemId,"I",$p(ordItemId,"||",2),1)),"^",13)
	.Q:itemStatId=""
	.s exeStatCode=$p(^OEC("OSTAT",itemStatId),"^",1)
	.Q:(exeStatCode="D")||(exeStatCode="C")||(exeStatCode="U") 
	.i ordList=0 s ordList = ordItemId
	.e  s ordList = ordList_"@"_ordItemId
	Q ordList
}

/// Descript:  判断处方是否审核通过(仅仅适用门诊接口)
/// CreateDate:2022-03-11
/// Creator:   hxy
/// Input:     处方号
/// Output:    未进审方：""、未审核："-1"、审核未通过："1"、审核通过："0"
/// w ##class(web.DHCPRESCInterface).IsAuditPassByPresc("MJ22031100005")
ClassMethod IsAuditPassByPresc(prescNo)
{
	s ret = ""
	s auditId = $o(^PHA.PREADT.AuditI("PrescNo",prescNo,""))
	Q:auditId="" ret               //未进审方
	s ret="0"                      //审核通过
	s statusId="",statusCode=""  											
	s resultId = $o(^PHA.PREADT.AuditResultI("Parref",auditId,""),-1)
	s:resultId'="" statusId = $lg(^PHA.PREADT.AuditResultD(resultId),6)
	s:statusId'="" statusCode = $lg(^CT.PHA.PREADT.DicItemD(statusId),2)	 //结果代码
	s:statusCode="STA01" ret="1"   //审核未通过
	s:statusCode="" ret="-1"       //未审核
	Q ret
}

/// Descript:  判断医嘱串是否审核通过
/// CreateDate:2022-03-11
/// Creator:   hxy
/// Input:     医嘱Id串,@分割
/// Output:    0,通过,其他：未通过医嘱Id串,@分割
/// w ##class(web.DHCPRESCInterface).IsAuditPassByOrd("3200||337@3200||330@3200||338")
ClassMethod IsAuditPassByOrd(OrdStr)
{
	s ret=0
	s ordList=""
	s len = $l(OrdStr,"@")
	for i=1:1:len   d
	.s ordItm = $p(OrdStr,"@",i)
	.Q:ordItm=""
	.s auditListId = $o(^PHA.PREADT.AuditListI("ORI",ordItm,""),-1)
	.s auditId=$lg(^PHA.PREADT.AuditListD(auditListId),2)
	.Q:auditId=""
	.s statusId="",statusCode=""
	.s resultId = $o(^PHA.PREADT.AuditResultI("Parref",auditId,""),-1)									
	.s:resultId'="" statusId = $lg(^PHA.PREADT.AuditResultD(resultId),6)
	.s:statusId'="" statusCode = $lg(^CT.PHA.PREADT.DicItemD(statusId),2)  //结果代码
	.Q:statusCode="STA04"
	.s:ordList'="" ordList = ordList_"@"_ordItm
	.s:ordList="" ordList = ordItm
	s:ordList'="" ret=ordList
	Q ret
}

/// Descript:更新医嘱
/// Input:AdtMsgID&
/// w ##class(web.DHCPRESCInterface).UpdAuditOrd("3200||337@3200||330@3200||338")
ClassMethod UpdAuditOrd(auditResList)
{
	s len = $l(auditResList,"!!")
	s ^temptest("auditResList") = auditResList
	s ret = 0
	for i=1:1:len  d
	.s subList = $p(auditResList,"!!",i)
	.s oeordId = $p(subList,"^",1)
	.s unique = $p(subList,"^",2)
	.Q:oeordId=""
	.s prescNo = $p(^OEORD(+oeordId,"I",$p(oeordId,"||",2),1),"^",14)
	.s auditId = $lg(^PHA.PREADT.AuditListD(unique),2)
	.s ^temptest("sxxx") = prescNo
	.&sql(update PHA_PREADT.AuditList set PAL_OEORI_Dr=:oeordId where PAL_RowID=:unique)
	.&sql(update PHA_PREADT.Audit set PA_PrescNo=:prescNo where PA_RowID=:auditId)
	.s ret = SQLCODE
	d ##class(web.DHCPRESCInterface).InsEnsthod(auditResList)
	q ret
}

/// w ##class(web.DHCPRESCInterface).InsEnsthod("28||97^2564^")
ClassMethod InsEnsthod(auditResList)
{
	s auditItmId = $p($p(auditResList,"!!",1),"^",2)
	Q:auditItmId="" 0
	s auditId = $lg(^PHA.PREADT.AuditListD(auditItmId),2)
	s resultId = $o(^PHA.PREADT.AuditResultI("Parref",auditId,""))
	s userId = "",remark=""
	s:resultId'="" userId = $lg($g(^PHA.PREADT.AuditResultD(resultId)),3)
	s userCode = "",userName = ""
	s:userId'="" userCode = $p(^SSU("SSUSR",userId),"^",1)
	s:userId'="" userName = $p(^SSU("SSUSR",userId),"^",2)
	s:resultId'="" remark = $lg($g(^PHA.PREADT.AuditResultD(resultId)),8)
	i userCode = "demo"  d
	.i remark="自动通过" d
	..s userCode = "系统通过"
	..s userName = "系统通过"
	.i remark="超时自动通过" d
	..s userCode = "超时通过"
	..s userName = "超时通过"
	s uptDate = "",uptTime = ""
	s:resultId'="" uptDate = $lg($g(^PHA.PREADT.AuditResultD(resultId)),4)	
	s:resultId'="" uptTime = $lg($g(^PHA.PREADT.AuditResultD(resultId)),5)	
	s:uptDate'="" uptDate = $zd(uptDate,3)
	s:uptTime'="" uptTime = $zt(uptTime,1)
	s:uptDate="" uptDate=$zd(+$h,3)
	s:uptTime="" uptTime=$zt($p($h,",",2),1)
	s updDateTime = uptDate_" "_uptTime
	s sourceSystem = "HIS",position = "",examId = "",notes = ""
	s operateDeptCode = "",operateDept = "",status = "PR"
	s resArr = []
	s len = $l(auditResList,"!!")
	s ret = 0
	for i=1:1:len  d
	.s subList = $p(auditResList,"!!",i)
	.s oeordId = $p(subList,"^",1)
	.s resObj = {}
	.s resObj.OEOrdItemID = oeordId
	.s resObj.Position = position
	.s resObj.ExamID = examId
	.s resObj.Status = status
	.s resObj.UserID = userCode
	.s resObj.UserName = userName
	.s resObj.UpDateTime = updDateTime
	.s resObj.SourceSystem = sourceSystem
	.s resObj.Notes = notes
	.s resObj.OperateDeptCode = operateDeptCode
	.s resObj.OperateDept = operateDept
	.d resArr.%Push(resObj)
	
	s resStream = ##class(%Stream.GlobalCharacter).%New()
	d resArr.%ToJSON(resStream)
	d resStream.%Close()
	s ret = ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",resStream)
	q ret.Read()
}

/// Descript:  科室是否开启了合理用药权限
/// CreateDate:2022-03-11
/// Creator:   sufan
/// Input:     医嘱Id串,@分割
/// Output:    0,通过,其他：未通过医嘱Id串,@分割
/// w ##class(web.DHCPRESCInterface).IsAuditAuth("191")
ClassMethod IsAuditAuth(locId)
{
	s authFlag = "N"
	Q:locId="" authFlag
	s resJson= ##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("GetPrescAuditCompany",locId)
	s resArr = {}.%FromJSON(resJson)
	s resLen = resArr.%Size()
	for i=0:1:resLen-1  Q:authFlag="Y"  d
	.s resObj = resArr.%Get(i)
	.s companyCode = resObj.CompanyCode
	.s moduleCode = resObj.ModuleCode
	.Q:moduleCode'="PrescAudit"
	.s authFlag = "Y"
	Q authFlag
}

}
