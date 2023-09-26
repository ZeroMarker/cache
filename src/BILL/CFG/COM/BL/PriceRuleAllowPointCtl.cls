Class BILL.CFG.COM.BL.PriceRuleAllowPointCtl Extends %RegisteredObject
{

/// Creator: tanfb
/// CreateDate: 2022-11-29
/// Descript: 新增、更新
/// Table : CF_BILL_COM.PriceRuleAllowPoint
/// Input:	InJson
/// Output: 
/// Return: 
/// w ##class(BILL.CFG.COM.BL.PriceRuleAllowPointCtl).Save("2^1^AdmAge^就诊年龄^0,10^岁^2023-05-06^2023-05-29","1")
ClassMethod Save(InStr, UserId) [ ProcedureBlock = 0 ]
{
	new (InStr,UserId)
	s $zt="SaveErr"
	s ^CacheTemp("BILL.CFG.COM.BL.PriceRuleAllowPointCtl","Save")=$lb(InStr,UserId)
	q:InStr="" "-1^入参InStr不能为空"
	k PLIST
	s PLIST(1)=$p(InStr,"^",1) // ROWID
	s PLIST(2)=$p(InStr,"^",2) // 规则指针
	s PLIST(3)=$p(InStr,"^",3) // 准入点代码
	s PLIST(4)=$p(InStr,"^",4) // 准入点名称
	s PLIST(5)=$p(InStr,"^",5) // 准入值（ID）
	s PLIST(6)=$p(InStr,"^",6) // 准入值描述
	s PLIST(7)=$p(InStr,"^",7) // 有效开始日期
	s:PLIST(7)'="" PLIST(7)=##class(websys.Conversions).DateHtmlToLogical(PLIST(7))
	s PLIST(8)=$p(InStr,"^",8) // 有效结束日期
	s:PLIST(8)'="" PLIST(8)=##class(websys.Conversions).DateHtmlToLogical(PLIST(8))
	
	s RowId=PLIST(1)
	if +RowId=0  d
	.&sql(insert into CF_BILL_COM.PriceRuleAllowPoint values PLIST())
	else  d
	.s OldData=^CF.BILL.COM.PriceRuleAPD(RowId)
	.s $LI(OldData,1)=RowId
	.s OldData=$LTS(OldData,"^",1)
	.&sql(update CF_BILL_COM.PriceRuleAllowPoint values PLIST() where ID=:RowId)
	s rtn=-1
	if +SQLCODE=0  d
	.s rtn=%ROWID
	.s NewData=^CF.BILL.COM.PriceRuleAPD(rtn)
    .s $LI(NewData,1)=rtn
    .s NewData=$LTS(NewData,"^",1)
    .if +RowId=0  d
    ..d ##class(INSU.COM.Tools).SaveLog("CF.BILL.COM.PriceRuleAllowPoint",rtn,PLIST(2),"INSERT",+$h,$p($h,",",2),UserId,NewData,NewData)	//存日志
    .else  d
    ..d ##class(INSU.COM.Tools).SaveLog("CF.BILL.COM.PriceRuleAllowPoint",rtn,PLIST(2),"UPDATE",+$h,$p($h,",",2),UserId,OldData,NewData) 
	else  d
	.s rtn=SQLCODE
	.s:(+rtn>0) rtn=-rtn_"^"_$g(%msg) // 保证插入失败时 肯定返回负值
	q rtn
SaveErr
	s $zt=""
	q "-2^程序异常："_$ze
}

/// Creator: tanfb
/// CreateDate: 2022-11-29
/// Descript: 删除
/// Table : CF_BILL_COM.PriceRuleAllowPoint
/// Input:	RowId
/// Output: 
/// Return: 
/// w ##class(BILL.CFG.COM.BL.PriceRuleAllowPointCtl).Delete("3")
ClassMethod Delete(RowId)
{
	s $zt="DeleteErr"
	q:RowId="" "-2^入参RowId不能为空"
	s ^CacheTemp("CT_BILL_DC","Save")=$lb(RowId)
	&sql(delete from CF_BILL_COM.PriceRuleAllowPoint where ID=:RowId)
	q SQLCODE_"^"_$g(%msg)
DeleteErr
	s $zt=""
	q "-2^程序异常："_$ze
}

/// Creator: tanfb
/// CreateDate: 2022-11-29
/// Descript: 根据规则ROWID查询
/// Table : CF_BILL_COM.PriceRuleAllowPoint
/// Input: rule
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.CFG.COM.BL.PriceRuleAllowPointCtl","QueryInfo","1")
Query QueryInfo(rule = "") As websys.Query(ROWSPEC = "ROWID,RuleId,AllowPointCode,AllowPointDesc,ConfigValue,ConfigDesc,ActiveStartDate,ActiveEndDate") [ SqlProc ]
{
}

ClassMethod QueryInfoExecute(ByRef qHandle As %Binary, rule = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ^CacheTemp("BILL.CFG.COM.BL.PriceRuleAllowPointCtl","QueryInfo")=$lb(rule)
	
	i rule="" d
	.s Rowid=0
	.f  s Rowid=$o(^CF.BILL.COM.PriceRuleAPD(Rowid)) q:Rowid=""  d
	..d BuildData
	e  d
	.s Rowid=""
	.f  s Rowid=$o(^CF.BILL.COM.PriceRuleAPI("IndexRule",rule,Rowid)) q:Rowid=""  d
	..d BuildData

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
BuildData
    s (RuleId,AllowPointCode,AllowPointDesc,ConfigValue,ConfigDesc,ActiveStartDate,ActiveEndDate)=""
	s RuleId=$lg(^CF.BILL.COM.PriceRuleAPD(Rowid),2)
	s AllowPointCode=$lg(^CF.BILL.COM.PriceRuleAPD(Rowid),3)
	s AllowPointDesc=$lg(^CF.BILL.COM.PriceRuleAPD(Rowid),4)
	//s:AllowPointDesc'="" AllowPointDesc=##class(BILL.CFG.COM.DictionaryCtl).GetDicInfoByTypeCode("PriceManageRulePoint",AllowPointDesc,"2","4")
	s ConfigValue=$lg(^CF.BILL.COM.PriceRuleAPD(Rowid),5)
	s ConfigDesc=$lg(^CF.BILL.COM.PriceRuleAPD(Rowid),6)
	s ActiveStartDate=$lg(^CF.BILL.COM.PriceRuleAPD(Rowid),7)
	s:ActiveStartDate'="" ActiveStartDate=##class(websys.Conversions).DateLogicalToHtml(ActiveStartDate)
	s ActiveEndDate=$lg(^CF.BILL.COM.PriceRuleAPD(Rowid),8)
	s:ActiveEndDate'="" ActiveEndDate=##class(websys.Conversions).DateLogicalToHtml(ActiveEndDate)
	
	//q:(rule'="")&&(RuleId'=rule)
	d QueryPortList	
	q
    
QueryPortList
	set Data=$lb(Rowid,RuleId,AllowPointCode,AllowPointDesc,ConfigValue,ConfigDesc,ActiveStartDate,ActiveEndDate)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

}
