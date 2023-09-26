/// Creator:lulin
/// Descriptions:日志方法
/// Date:2020-08-26
Class web.INMLogComm Extends %RegisteredObject
{

/// Creator:lulin
/// Createdate:2020-08-26
/// Description:操作日志保存
/// Input:parr
/// Output:
/// Other:d ##class(web.INMLogComm).SaveLog("web.INMSetComm","SaveFieldSet")
ClassMethod SaveLog(LogClass As %String = "", LogMethod As %String = "", loginID As %String = "", sourceType As %String = "") As %String
{
	q:((LogClass="")||(LogMethod="")) ""
	q:$zcvt($e(LogMethod,1,4),"U")="FIND" ""
	q:(($zcvt($e(LogMethod,1,3),"U")="GET")&&(LogMethod'="GetPersonByLoginId")) ""
	q:$zcvt($e(LogMethod,1,2),"U")="IS" ""
	s:sourceType="" sourceType="PC"
	s $ZT="ErrorLog"
	s LogUserDR=loginID
	q:LogUserDR="" ""
	s methodObj=##class(%Dictionary.CompiledMethod).%OpenId(LogClass_"||"_LogMethod)
	q:'$IsObject(methodObj) "1"
	s description=methodObj.Description
	s LogDesc=""
	f i=1:1:$L(description,$c(13,10))  d
	.s rowdata=$P(description,$c(13,10),i)
	.q:rowdata=""
	.s rowdata=$TR(rowdata,"：",":")
	.s key=$P(rowdata,":",1)
	.s desc=$P(rowdata,":",2)
	.q:((key="")!(desc=""))
	.s key=$zcvt(key,"U")
	.q:key'="DESCRIPTION"
	.s LogDesc=$tr(desc," ","")
	
	s LogUserName=""
	i LogUserDR=0  d
	.s LogUserName="管理员"
	e  d
	.s userLB=$G(^CF.DHCINM.DB.MgUserD(LogUserDR))
	.s LogUserName=$LG(userLB,2)
	s obj=##class(DHCINM.Log.MgOperateLog).%New()
	s obj.LogClass=LogClass
	s obj.LogMethod=LogMethod
	s obj.LogDesc=LogDesc_"("_sourceType_")"
	s obj.LogUserDR=LogUserDR
	s obj.LogUserName=LogUserName
	s obj.LogDate=+$H
	s obj.LogTime=$P($H,",",2)
	d obj.%Save()
ErrorLog
	q ""
}

}
