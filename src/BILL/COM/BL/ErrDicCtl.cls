Class BILL.COM.BL.ErrDicCtl Extends %RegisteredObject
{

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 新增
/// Table : CT_BILL_COM.ERRDIC
/// Input:	InJson,SessionStr="UserId^"
/// Output: 
/// Return: 
/// w ##class(BILL.COM.BL.ErrDicCtl).Save("2^BILLOPSELF^物价表中院区指针为空^1^1^^Y^2^^^^^^^OPCHRG^对账平台^SYS","1")
ClassMethod Save(InStr, SessionStr) [ ProcedureBlock = 0 ]
{
	//s ^TMPErr("GLOBAL123AAA")=(InStr)
	new (InStr, SessionStr)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.COM.BL.ErrDicCtl).Save(InStr, SessionStr)开始:",InStr, SessionStr)
	s $zt="SaveErr"
	s ^CacheTemp("BILL.COM.BL.ErrDicCtl","Save")=$lb(InStr,SessionStr)
	q:InStr="" "-1"
	k PLIST
	s UserId=+SessionStr
	s PLIST(1)=$p(InStr,"^",1) // rowid
	s PLIST(2)=$p(InStr,"^",2) // ErrCode
	s PLIST(3)=$p(InStr,"^",3) // ErrDefaultDesc
	s PLIST(4)=$p(InStr,"^",4) // ErrConfig
	s PLIST(5)=$p(InStr,"^",5) // Demo
	s PLIST(6)=$p(InStr,"^",6) // RuleInfo
	s PLIST(7)=$p(InStr,"^",7) // ActiveFlag
	s PLIST(8)=$p(InStr,"^",8) // HOSPID
	s PLIST(15)=$p(InStr,"^",15) // ProductLine
	s PLIST(16)=$p(InStr,"^",16) // ProductModule
	s PLIST(17)=$p(InStr,"^",17) // ErrType
	q:PLIST(8)="" "-2^HOSPID"
	s RowId=PLIST(1)
	if +RowId=0  d
	.s PLIST(9)= UserId 
	.s PLIST(10)=+$h
	.s PLIST(11)=$p($h,",",2)
	.s PLIST(12)=UserId	
	.s PLIST(13)=+$h
	.s PLIST(14)=$p($h,",",2)
	.&sql(insert into CT_BILL_COM.ErrDic values PLIST())
	else  d
	.s PLIST(12)=UserId
	.s PLIST(13)=+$h
	.s PLIST(14)=$p($h,",",2)
	.&sql(update CT_BILL_COM.ErrDic values PLIST() where RowId=:RowId)
	
	s rtn=-1
	
	if +SQLCODE=0  d
	.s rtn=%ROWID
	else  d
	.s rtn=SQLCODE
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.COM.BL.ErrDicCtl).Save(InStr, SessionStr)结束:",rtn)
	q rtn
SaveErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.COM.BL.ErrDicCtl).Save(InStr,SessionStr)异常:",InStr,SessionStr,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2020-03-09
/// Descript: 更新指定字段
/// Table : 
/// Input:		JsonStr : 字段对应的json串
/// Output: 
/// Return: 0 表示 成功 非0表示失败
/// DeBug:  w ##class(BILL.COM.BL.ErrDicCtl).UpdaeByJson("{name:"a",b:"b"}","3334")
ClassMethod UpdaeByJson(JsonStr, Id) As %String
{
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.COM.BL.ErrDicCtl).UpdaeByJson(JsonStr, Id)开始:",JsonStr, Id)
	s $zt="UpdaeByJsonErr"
	set ^CacheTemp("UpdaDicInfoByJson")=$lb(JsonStr, Id)
	set rtn=0
	set obj=##class(%DynamicAbstractObject).%FromJSON(JsonStr)
	set Data=##class(CT.BILL.COM.ErrDic).%OpenId(Id,0)
	quit:('$IsObject(Data)) "-1"
	
	set iter = obj.%GetIterator()
	while iter.%GetNext(.key , .value ) {
	   set $ZOBJPROPERTY(Data,key)=$ZOBJPROPERTY(obj,key)
	}
	set err=Data.%Save()
    if $$$ISERR(err){
		set rtn="-100^"_$SYSTEM.Status.GetErrorText(err)
	}else{
		set rtn=0
	}
	set obj=""
	set Data=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.COM.BL.ErrDicCtl).UpdaeByJson(JsonStr, Id)结束:",rtn)
	quit rtn
UpdaeByJsonErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.COM.BL.ErrDicCtl).UpdaeByJson(JsonStr,Id)异常:",JsonStr, Id,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2022-05-11
/// Descript: 删除
/// Table : CF_BILL_DataCheck.UnAuditItm
/// Input:	
/// Output: 
/// Return: 
/// w ##class(BILL.COM.BL.ErrDicCtl).Save(InJson)
ClassMethod Delete(RowId)
{
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.COM.BL.ErrDicCtl).Delete(RowId)开始:",RowId)
	s $zt="DeleteErr"
	q:RowId="" "-2"
	s ^CacheTemp("CT_BILL_COM","Save")=$lb(RowId)
	&sql(delete from CT_BILL_COM.ErrDic where RowId=:RowId)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.COM.BL.ErrDicCtl).Delete(RowId)结束:",SQLCODE)
	q SQLCODE
DeleteErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.COM.BL.ErrDicCtl).Delete(RowId)异常:",RowId,$ze)
	q "-2"
}

/// Creator: tangzf
/// CreateDate: 2022-05-23
/// Descript: 查询
/// Table : CT_BILL_COM.ErrDic
/// Input:	HospDr
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.COM.BL.ErrDicCtl","QueryInfo",2)
Query QueryInfo(HospID = "", KeyCode = "", QProductLine = "", QProductModule = "") As websys.Query(ROWSPEC = "ErrCode,ErrDefaultDesc,ErrConfig,Demo,RuleInfo,ActiveFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,ProductLine,ProductModule,ErrType") [ SqlProc ]
{
}

ClassMethod QueryInfoExecute(ByRef qHandle As %Binary, HospID = "", KeyCode = "", QProductLine = "", QProductModule = "") As %Status
{
	s $zt="QueryInfoExecuteErr"
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ^CacheTemp("BILL.COM.BL.ErrDicCtl","QueryInfo")=$lb(HospID,KeyCode,QProductLine,QProductModule)
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(KeyCode)
	s Rowid=0
	f  s Rowid=$o(^CT.BILL.COM.ErrDicD(Rowid)) q:Rowid=""  d
	.s ErrCode=$lg(^CT.BILL.COM.ErrDicD(Rowid),1)
	.s ErrDefaultDesc=$lg(^CT.BILL.COM.ErrDicD(Rowid),2)
	.s ErrConfig=$lg(^CT.BILL.COM.ErrDicD(Rowid),3)
	.s Demo=$lg(^CT.BILL.COM.ErrDicD(Rowid),4)
	.s RuleInfo=$lg(^CT.BILL.COM.ErrDicD(Rowid),5)
	.s ActiveFlag=$lg(^CT.BILL.COM.ErrDicD(Rowid),6)
	.s HospDr=$lg(^CT.BILL.COM.ErrDicD(Rowid),7)
	.s CRTER=$lg(^CT.BILL.COM.ErrDicD(Rowid),8)
	.s CRTEDATE=$lg(^CT.BILL.COM.ErrDicD(Rowid),9)
	.s:CRTEDATE'="" CRTEDATE=##class(websys.Conversions).DateLogicalToHtml(CRTEDATE)
	.s CRTETIME=$lg(^CT.BILL.COM.ErrDicD(Rowid),10)
	.s:CRTETIME'="" CRTETIME=$zt(CRTETIME)
	.s UPDTID=$lg(^CT.BILL.COM.ErrDicD(Rowid),11)
	.s UPDTDATE=$lg(^CT.BILL.COM.ErrDicD(Rowid),12)
	.s:UPDTDATE'="" UPDTDATE=##class(websys.Conversions).DateLogicalToHtml(UPDTDATE)
	.s UPDTTIME=$lg(^CT.BILL.COM.ErrDicD(Rowid),13)
	.s:UPDTTIME'="" UPDTTIME=$zt(UPDTTIME)
	.s ProductLine=$lg(^CT.BILL.COM.ErrDicD(Rowid),14)
	.s ProductModule=$lg(^CT.BILL.COM.ErrDicD(Rowid),15)
	.s ErrType=$lg(^CT.BILL.COM.ErrDicD(Rowid),16)
	.q:(HospID'="")&&(HospID'=HospDr)
	.q:(QProductLine'="")&&(QProductLine'=ProductLine)
	.q:(QProductModule'="")&&(QProductModule'=ProductModule)
	.s HZSPCode=##class(web.DHCINSUPort).GetCNCODE(ErrCode,4,"")
	.s HZPYCode=##class(web.DHCINSUPort).GetCNCODE(ErrDefaultDesc,3,"")
	.q:($$ALPHAUP^SSUTIL4(ErrCode)'[tCodeAndDesc)&&(HZSPCode'[tCodeAndDesc)&&(HZPYCode'[KeyCode)&&(ErrCode'[KeyCode)&&(ErrDefaultDesc'[tCodeAndDesc)
	
	.d QueryPortList	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryInfoExecuteErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(%ResultSet).RunQuery(BILL.COM.BL.ErrDicCtl,QueryInfo,)异常",HospID, KeyCode, QProductLine, QProductModule,$ze)
	q "-2"
QueryPortList
	set Data=$lb(ErrCode,ErrDefaultDesc,ErrConfig,Demo,RuleInfo,ActiveFlag,HospDr,CRTER,CRTEDATE,CRTETIME,UPDTID,UPDTDATE,UPDTTIME,Rowid,ProductLine,ProductModule,ErrType)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator: tangzf
/// CreateDate: 2020-03-09
/// Descript: 更新指定字段
/// Table : 
/// Input:		
/// Output: 
/// Return: 
/// DeBug:  w ##class(BILL.COM.BL.ErrDicCtl).GetErrInfoByErrCode()
ClassMethod GetErrInfoByErrCode(Code, HospDr)
{
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.COM.BL.ErrDicCtl).GetErrInfoByErrCode(Code, HospDr)开始:",Code, HospDr)
	s $zt="GetErrInfoByErrCodeErr"
	q:Code="" -1
	q:HospDr="" -2
	s RowId=$o(^CT.BILL.COM.ErrDicI("IndexErrCodeHospAct",Code,HospDr,"Y",""))
	q:RowId="" -3
	s ErrInfo=^CT.BILL.COM.ErrDicD(RowId)
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Normal,"class(BILL.COM.BL.ErrDicCtl).GetErrInfoByErrCode(Code, HospDr)结束:",ErrInfo)
	q ErrInfo
	//d ##class(CT.BILL.COM.ErrDic).%BuildIndices()
GetErrInfoByErrCodeErr
	s $zt=""
	d ##class(BILL.DC.Common).Log(##class(BILL.DC.Utils.Enum.LogType).#Exceptions,"class(BILL.COM.BL.ErrDicCtl).GetErrInfoByErrCodeErr(Code, HospDr)异常:",Code, HospDr,$ze)
	q "-2"
}

}
