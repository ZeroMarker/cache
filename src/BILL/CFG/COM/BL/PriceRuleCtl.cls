Class BILL.CFG.COM.BL.PriceRuleCtl Extends %RegisteredObject
{

/// Creator: tanfb
/// CreateDate: 2022-11-29
/// Descript: 新增
/// Table : CF_BILL_COM.PriceRule
/// Input:	InJson
/// Output: 
/// Return: 
/// w ##class(BILL.CFG.COM.BL.PriceRuleCtl).Save("1^01^优惠1^2023-01-17^^2^1^Yes^AdmRule^^^")
ClassMethod Save(InStr, UserId) [ ProcedureBlock = 0 ]
{
	new (InStr,UserId) 
	s $zt="SaveErr"
	s ^CacheTemp("BILL.CFG.COM.BL.PriceRuleCtl","Save")=$lb(InStr,UserId)
	q:InStr="" "-1^入参InStr不能为空"
	k PLIST
	s PLIST(1)=$p(InStr,"^",1) // ROWID
	s PLIST(2)=$p(InStr,"^",2) // 优惠代码
	s PLIST(3)=$p(InStr,"^",3) // 优惠名称
	s PLIST(4)=$p(InStr,"^",4) // 有效开始日期
	s:PLIST(4)'="" PLIST(4)=##class(websys.Conversions).DateHtmlToLogical(PLIST(4))
	s PLIST(5)=$p(InStr,"^",5) // 有效结束日期
	s:PLIST(5)'="" PLIST(5)=##class(websys.Conversions).DateHtmlToLogical(PLIST(5))
	s Data=+$h
	s PLIST(6)=$p(InStr,"^",6) // 院区指针
	s PLIST(7)=$p(InStr,"^",7) // 优先级
	s PLIST(8)=$p(InStr,"^",8) // 允许叠加
	s PLIST(9)=$p(InStr,"^",9) // 优惠分类
	s PLIST(10)=$p(InStr,"^",10) // 建议比例
	s:PLIST(10)'="" PLIST(10)=$fn(PLIST(10),"",2)
	s PLIST(11)=$p(InStr,"^",11) // 建议金额
	s:PLIST(11)'="" PLIST(11)=$fn(PLIST(11),"",2)
	s PLIST(12)=$p(InStr,"^",12) // 备注
	if PLIST(1)="" {
		s RowId=$o(^CF.BILL.COM.PriceRuleI("UniqueCode",PLIST(2),PLIST(1))) 
	    q:RowId'="" "-1^该优惠代码已存在"
	    s RowId=$o(^CF.BILL.COM.PriceRuleI("IndexPriority",PLIST(6),PLIST(8),PLIST(7),PLIST(1)))
		q:RowId'="" "-1^是否允许叠加为:"_PLIST(8)_"的优惠类型，优先级不允许重复"
	}
	else {
		s RowId=$o(^CF.BILL.COM.PriceRuleI("UniqueCode",PLIST(2),"")) 
	    q:(RowId'="")&&(RowId'=PLIST(1)) "-1^该优惠代码已存在"
	    s RowId=$o(^CF.BILL.COM.PriceRuleI("IndexPriority",PLIST(6),PLIST(8),PLIST(7),""))
		q:(RowId'="")&&(RowId'=PLIST(1)) "-1^是否允许叠加为:"_PLIST(8)_"的优惠类型，优先级不允许重复"
	}

	s RowId=PLIST(1)
	if +RowId=0  {
		&sql(insert into CF_BILL_COM.PriceRule values PLIST())
	}
	else  {
		s OldData=^CF.BILL.COM.PriceRuleD(RowId)
		s $LI(OldData,1)=RowId
		s OldData=$LTS(OldData,"^",1)
		&sql(update CF_BILL_COM.PriceRule values PLIST() where ID=:RowId)
	}
	s rtn=-1
	if +SQLCODE=0  d
	.s rtn=%ROWID
	.s NewData=^CF.BILL.COM.PriceRuleD(rtn)
    .s $LI(NewData,1)=rtn
    .s NewData=$LTS(NewData,"^",1)
    .if +RowId=0  d
    ..d ##class(INSU.COM.Tools).SaveLog("CF.BILL.COM.PriceRule",rtn,PLIST(2),"INSERT",+$h,$p($h,",",2),UserId,NewData,NewData)	//存日志
    .else  d
    ..d ##class(INSU.COM.Tools).SaveLog("CF.BILL.COM.PriceRule",rtn,PLIST(2),"UPDATE",+$h,$p($h,",",2),UserId,OldData,NewData) 
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
/// Table : CF_BILL_COM.PriceRule
/// Input:	RowId
/// Output: 
/// Return: 
/// w ##class(BILL.CFG.COM.BL.PriceRuleCtl).Delete("3")
ClassMethod Delete(RowId)
{
	s $zt="DeleteErr"
	q:RowId="" "-2^入参RowId不能为空"
	s ^CacheTemp("CT_BILL_DC","Save")=$lb(RowId)
	&sql(delete from CF_BILL_COM.PriceRule where ID=:RowId)
	q SQLCODE_"^"_$g(%msg)
DeleteErr
	s $zt=""
	q "-2^程序异常："_$ze
}

/// Creator: tanfb
/// CreateDate: 2022-11-29
/// Descript: 查询
/// Table : CF_BILL_COM.PriceRule
/// Input:	HospID,KeyCode
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.CFG.COM.BL.PriceRuleCtl","QueryInfo","2","")
Query QueryInfo(HospID = "", KeyCode = "") As websys.Query(ROWSPEC = "ROWID,RuleCode,RuleDesc,ActiveStartDate,ActiveEndDate,HospId,Priority,AllowAddCode,AllowAddDesc,RuleTypeCode,RuleTypeDesc,Rate,Amt,Memo") [ SqlProc ]
{
}

ClassMethod QueryInfoExecute(ByRef qHandle As %Binary, HospID = "", KeyCode = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ^CacheTemp("BILL.CFG.COM.BL.PriceRuleCtl","QueryInfo")=$lb(HospID,KeyCode)
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(KeyCode)
	
	s Rowid=0
	f  s Rowid=$o(^CF.BILL.COM.PriceRuleD(Rowid)) q:Rowid=""  d
	.d BuildData

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
BuildData
    s (RuleCode,RuleDesc,ActiveStartDate,ActiveEndDate,HospId,Priority,AllowAddCode,AllowAddDesc,RuleTypeCode,RuleTypeDesc,Rate,Amt,Memo)=""
	s RuleCode=$lg(^CF.BILL.COM.PriceRuleD(Rowid),2)
	s RuleDesc=$lg(^CF.BILL.COM.PriceRuleD(Rowid),3)
	s PRuleDesc=##class(web.DHCINSUPort).GetCNCODE(RuleDesc,4,"")
	s ActiveStartDate=$lg(^CF.BILL.COM.PriceRuleD(Rowid),4)
	s:ActiveStartDate'="" ActiveStartDate=##class(websys.Conversions).DateLogicalToHtml(ActiveStartDate)
	s ActiveEndDate=$lg(^CF.BILL.COM.PriceRuleD(Rowid),5)
	s:ActiveEndDate'="" ActiveEndDate=##class(websys.Conversions).DateLogicalToHtml(ActiveEndDate)
	s HospId=$lg(^CF.BILL.COM.PriceRuleD(Rowid),6)
	s Priority=$lg(^CF.BILL.COM.PriceRuleD(Rowid),7)
	s AllowAddCode=$lg(^CF.BILL.COM.PriceRuleD(Rowid),8)
	s:AllowAddCode'="" AllowAddDesc=##class(BILL.CFG.COM.DictionaryCtl).GetDicInfoByTypeCode("YesOrNo",AllowAddCode,"2","4")
	s RuleTypeCode=$lg(^CF.BILL.COM.PriceRuleD(Rowid),9)
	s:RuleTypeCode'="" RuleTypeDesc=##class(BILL.CFG.COM.DictionaryCtl).GetDicInfoByTypeCode("PriceManageRuleType",RuleTypeCode,"2","4")
	s Rate=$lg(^CF.BILL.COM.PriceRuleD(Rowid),10)
	s Amt=$lg(^CF.BILL.COM.PriceRuleD(Rowid),11)
	s Memo=$lg(^CF.BILL.COM.PriceRuleD(Rowid),12)
	
	q:($$ALPHAUP^SSUTIL4(RuleCode)'[tCodeAndDesc)&&(RuleDesc'[tCodeAndDesc)&&(PRuleDesc'[tCodeAndDesc)
	q:HospID'=HospId
	d QueryPortList	
	q
    
QueryPortList
	set Data=$lb(Rowid,RuleCode,RuleDesc,ActiveStartDate,ActiveEndDate,HospId,Priority,AllowAddCode,AllowAddDesc,RuleTypeCode,RuleTypeDesc,Rate,Amt,Memo)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator: tanfb
/// CreateDate: 2022-12-27
/// Descript: 停用优惠类型关联优惠条件——弃用
/// Table : CF_BILL_COM.PriceRule、CF_BILL_COM.PriceRuleAllowPoint
/// Input:	RuleId 规则Rowid
/// Output: 
/// Return: 
/// w ##class(BILL.CFG.COM.BL.PriceRuleCtl).Stop("4")
ClassMethod Stop(RuleId)
{
	s $zt="SaveErr"
	s ^CacheTemp("BILL.CFG.COM.BL.PriceRuleCtl","Stop")=$lb(RuleId)
	q:RuleId="" "-1^RuleId不能为空"
	s aRowId=$o(^CF.BILL.COM.PriceRuleAPI("IndexRule",RuleId,"0"))
	q:aRowId="" "-1^该优惠类型未关联优惠条件"
	s aRowId=""
	f  s aRowId=$o(^CF.BILL.COM.PriceRuleAPI("IndexRule",RuleId,aRowId)) q:aRowId=""  d
	.s Data=+$h
	.&sql(UPDATE CF_BILL_COM.PriceRuleAllowPoint SET ActiveEndDate=:Data where ID=:aRowId)
	s rtn=-1
	if +SQLCODE=0  d
	.s rtn=%ROWID
	else  d
	.s rtn=SQLCODE
	.s:(+rtn>0) rtn=-rtn_"^"_$g(%msg) // 保证插入失败时 肯定返回负值
	q rtn
SaveErr
	s $zt=""
	q "-2"
}

/// Creator: tanfb
/// CreateDate: 2023-01-09
/// Descript: 根据准入点名称加载相应的准入值选项
/// Table :
/// Input:	AllowPoint 准入点名称, key 索引关键字, HospId 院区指针
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.CFG.COM.BL.PriceRuleCtl","FindAllowPoint","AdmType","","2")
Query FindAllowPoint(AllowPoint As %String, Key As %String, HospId As %String) As websys.Query(ROWSPEC = "id:%String,code:%String,desc:%String")
{
}

ClassMethod FindAllowPointExecute(ByRef qHandle As %Binary, AllowPoint As %String = "", Key As %String = "", HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ^CacheTemp("BILL.CFG.COM.BL.PriceRuleCtl","FindAllowPoint")=$lb(AllowPoint,Key,HospId)
	
	q:AllowPoint="" $$$OK
	
	if (AllowPoint["Loc"){
		s rtn=##class(%ResultSet).%New("BILL.CFG.COM.CfgRelaQuery:QryData")
		d rtn.Execute("QryDeptList",Key,HospId)
		while(rtn.Next()){
			s id=rtn.Get("id")
			s code=rtn.Get("code")
			s desc=rtn.Get("text")
			d OutPutData			
		}
	}
	if (AllowPoint["AdmReason"){
		s rtn=##class(%ResultSet).%New("BILL.CFG.COM.CfgRelaQuery:QryData")
		d rtn.Execute("QryAdmReasonList",Key,HospId)
		while(rtn.Next()){
			s id=rtn.Get("id")
			s code=rtn.Get("code")
			s desc=rtn.Get("text")
			d OutPutData			
		}
	}
	if (AllowPoint["Sex"){
		s rtn=##class(%ResultSet).%New("BILL.CFG.COM.CfgRelaQuery:QryData")
		d rtn.Execute("QrySexList",Key,HospId)
		while(rtn.Next()){
			s id=rtn.Get("id")
			s code=rtn.Get("code")
			s desc=rtn.Get("text")
			d OutPutData			
		}
	}
	if (AllowPoint["AdmType"){
		s rtn=##class(%ResultSet).%New("BILL.CFG.COM.DictionaryCtl:QueryDicDataInfo")
		d rtn.Execute("AdmType",Key)
		while(rtn.Next()){
			s id=rtn.Get("DicCode")
			s code=rtn.Get("DicCode")
			s desc=rtn.Get("DicDesc")
			d OutPutData			
		}	
	}
	if (AllowPoint["Age"){
		s id=""
		s code="Age"
		s desc="岁"
		d OutPutData	
	}
	if (AllowPoint["ArcItm"){
		s rtn=##class(%ResultSet).%New("DHCBILLConfig.DHCBILLFIND:FindArcItm")
		d rtn.Execute(Key,"","","","",HospId)
		while(rtn.Next()){
			s id=rtn.Get("TArcRowid")
			s code=rtn.Get("TArcCode")
			s desc=rtn.Get("TArcDesc")
			d OutPutData			
		}
	}
	quit $$$OK
OutPutData
    q:(Key'="")&&(desc'[Key)&&(code'[Key)
    set Data=$lb(id,code,desc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

}
