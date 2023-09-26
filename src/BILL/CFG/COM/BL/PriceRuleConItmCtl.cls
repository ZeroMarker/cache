Class BILL.CFG.COM.BL.PriceRuleConItmCtl Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator: tanfb
/// CreateDate: 2022-12-29
/// Descript: 新增
/// Table : CF_BILL_COM.PriceRuleConItm
/// Input:	InJson
/// Return: 
/// w ##class(BILL.CFG.COM.BL.PriceRuleConItmCtl).Save("^2^2^2023-01-01^2023-1-29^0.2^15^2^Y^^2022-12-29^^^测试")
ClassMethod Save(InStr, UserId) [ ProcedureBlock = 0 ]
{
	new (InStr,UserId)
	s $zt="SaveErr"
	s ^CacheTemp("BILL.CFG.COM.BL.PriceRuleConItmCtl","Save")=$lb(InStr,UserId)
	q:InStr="" "-1^入参InStr不能为空"
	k PLIST
	s PLIST(1)=$p(InStr,"^",1) // ROWID
	s PLIST(2)=$p(InStr,"^",2) // 项目指针
	s PLIST(3)=$p(InStr,"^",3) // 规则指针
	s PLIST(4)=$p(InStr,"^",4) // 有效开始日期
	s:PLIST(4)'="" PLIST(4)=##class(websys.Conversions).DateHtmlToLogical(PLIST(4))
	s PLIST(5)=$p(InStr,"^",5) // 有效结束日期
	s:PLIST(5)'="" PLIST(5)=##class(websys.Conversions).DateHtmlToLogical(PLIST(5))
	s Data=+$h
	;q:(PLIST(4)'="")&&(PLIST(4)<=Data) "-1^生效日期需大于当天"
	;q:(PLIST(5)'="")&&(PLIST(5)<PLIST(4)) "-1^失效日期不能小于生效日期"
	s PLIST(6)=$p(InStr,"^",6) // 调整比例
	s:PLIST(6)'="" PLIST(6)=$fn(PLIST(6),"",2)
	s PLIST(7)=$p(InStr,"^",7) // 调整金额
	s:PLIST(7)'="" PLIST(7)=$fn(PLIST(7),"",2)
	q:(PLIST(6)'="")&&(PLIST(7)'="") "-1^调整比例和调整金额不能同时存在"
	s PLIST(8)=$p(InStr,"^",8) // 院区指针
	s TarActiveFlag=..GetTarActiveFlag(PLIST(2),PLIST(8)) //判断该收费项是否允许优惠
	q:(TarActiveFlag="0") "-1^该收费项目不允许优惠"
	s PLIST(9)=$p(InStr,"^",9) // 审核标志
	s PLIST(10)=$p(InStr,"^",10) // 审核人
	s PLIST(11)=$p(InStr,"^",11) // 审核日期
	s:PLIST(11)'="" PLIST(11)=##class(websys.Conversions).DateHtmlToLogical(PLIST(11))
	s PLIST(12)=$p(InStr,"^",12) // 审核时间
	s:PLIST(12)'="" PLIST(12)=##class(websys.Conversions).TimeHtmlToLogical(PLIST(12))
	s PLIST(13)=$p(InStr,"^",13) // 审核备注
	s PLIST(14)=$p(InStr,"^",14) // 项目类型	
	
	s RowId=PLIST(1)
	if +RowId=0  d
	.&sql(insert into CF_BILL_COM.PriceRuleConItm values PLIST())
	else  d
	.s OldData=^CF.BILL.COM.PriceRuleConItmD(RowId)
	.s $LI(OldData,1)=RowId
	.s OldData=$LTS(OldData,"^",1)
	.&sql(update CF_BILL_COM.PriceRuleConItm values PLIST() where ID=:RowId)
	s rtn=-1
	if +SQLCODE=0  d
	.s rtn=%ROWID
	.s NewData=^CF.BILL.COM.PriceRuleConItmD(rtn)
    .s $LI(NewData,1)=rtn
    .s NewData=$LTS(NewData,"^",1)
    .if +RowId=0  d
    ..d ##class(INSU.COM.Tools).SaveLog("CF.BILL.COM.PriceRuleConItm",rtn,PLIST(2),"INSERT",+$h,$p($h,",",2),UserId,NewData,NewData)	//存日志
    .else  d
    ..d ##class(INSU.COM.Tools).SaveLog("CF.BILL.COM.PriceRuleConItm",rtn,PLIST(2),"UPDATE",+$h,$p($h,",",2),UserId,OldData,NewData) 
	else  d
	.s rtn=SQLCODE
	.s:(+rtn>0) rtn=-rtn_"^"_$g(%msg) // 保证插入失败时 肯定返回负值
	q rtn
SaveErr
	s $zt=""
	q "-2^程序异常："_$ze
}

/// Creator: tanfb
/// CreateDate: 2022-12-29
/// Descript: 删除
/// Table : CF_BILL_COM.PriceRuleConItm
/// Input:	RowId
/// Return: 
/// w ##class(BILL.CFG.COM.BL.PriceRuleConItmCtl).Delete("3")
ClassMethod Delete(RowId)
{
	s $zt="DeleteErr"
	q:RowId="" "-2^入参RowId不能为空"
	s ^CacheTemp("CF_BILL_COM","Save")=$lb(RowId)
	&sql(delete from CF_BILL_COM.PriceRuleConItm where ID=:RowId)
	q SQLCODE_"^"_$g(%msg)
DeleteErr
	s $zt=""
	q "-2^程序异常："_$ze
}

/// Creator: tanfb
/// CreateDate: 2022-12-29
/// Descript: 查询
/// Table : CF_BILL_COM.PriceRuleConItm
/// Input:	KeyCode -非必填 关键字
/// 		rule -非必填 优惠项目关联优惠类型ID 
/// 		type -非必填 优惠项目类型（Tar或Arc）
/// 		ExamineFlag -非必填 优惠项目审核标志
/// Output: 
/// Return: 
/// d ##class(%ResultSet).RunQuery("BILL.CFG.COM.BL.PriceRuleConItmCtl","QueryInfo","",1","Tar")
Query QueryInfo(KeyCode = "", rule = "", type = "", ExamineFlag = "") As websys.Query(ROWSPEC = "ROWID,TarItemId,TarItemCode,TarItemDesc,RuleId,RuleDesc,ActiveStartDate,ActiveEndDate,Rate,Amt,HospId,AuditStatus,AuditUser,AuditDate,AuditTime,Memo,ItemType") [ SqlProc ]
{
}

ClassMethod QueryInfoExecute(ByRef qHandle As %Binary, KeyCode = "", rule = "", type = "", ExamineFlag = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ^CacheTemp("BILL.CFG.COM.BL.PriceRuleConItmCtl","QueryInfo")=$lb(KeyCode,rule,type,ExamineFlag)
	s tCodeAndDesc=$$ALPHAUP^SSUTIL4(KeyCode)
	
	s Rowid=0
	f  s Rowid=$o(^CF.BILL.COM.PriceRuleConItmD(Rowid)) q:Rowid=""  d
	.d BuildData

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
BuildData
    s (TarItemId,TarItemCode,TarItemDesc,RuleId,RuleDesc,ActiveStartDate,ActiveEndDate,Rate,Amt,HospId,AuditStatus,AuditUser,AuditDate,AuditTime,Memo,ItemType)=""
	s TarItemId=$lg(^CF.BILL.COM.PriceRuleConItmD(Rowid),2)
	s RuleId=$lg(^CF.BILL.COM.PriceRuleConItmD(Rowid),3)
	s RuleDesc=$lg(^CF.BILL.COM.PriceRuleD(RuleId),3) //规则名称
	s ActiveStartDate=$lg(^CF.BILL.COM.PriceRuleConItmD(Rowid),4)
	s:ActiveStartDate'="" ActiveStartDate=##class(websys.Conversions).DateLogicalToHtml(ActiveStartDate)
	s ActiveEndDate=$lg(^CF.BILL.COM.PriceRuleConItmD(Rowid),5)
	s:ActiveEndDate'="" ActiveEndDate=##class(websys.Conversions).DateLogicalToHtml(ActiveEndDate)
	s Rate=$lg(^CF.BILL.COM.PriceRuleConItmD(Rowid),6)
	s Amt=$lg(^CF.BILL.COM.PriceRuleConItmD(Rowid),7)
	s HospId=$lg(^CF.BILL.COM.PriceRuleConItmD(Rowid),8)
	s AuditStatus=$lg(^CF.BILL.COM.PriceRuleConItmD(Rowid),9)
	s AuditUser=$lg(^CF.BILL.COM.PriceRuleConItmD(Rowid),10)
	s:AuditUser'="" AuditUser=$p($g(^SSU("SSUSR",AuditUser)),"^",2)
	s AuditDate=$lg(^CF.BILL.COM.PriceRuleConItmD(Rowid),11)
	s:AuditDate'="" AuditDate=##class(websys.Conversions).DateLogicalToHtml(AuditDate)
	s AuditTime=$lg(^CF.BILL.COM.PriceRuleConItmD(Rowid),12)
	s:AuditTime'="" AuditTime=##class(websys.Conversions).TimeLogicalToHtml(AuditTime)
	s Memo=$lg(^CF.BILL.COM.PriceRuleConItmD(Rowid),13)
	s ItemType=$lg(^CF.BILL.COM.PriceRuleConItmD(Rowid),14)
	q:(type'="")&&(type'="ALL")&&(type'[ItemType)
	i ItemType="Tar" d
	.q:TarItemId=""
	.s TarItemCode=$p($g(^DHCTARI(TarItemId)),"^",1)
	.s TarItemDesc=$p($g(^DHCTARI(TarItemId)),"^",2)
	.s PTarItemDesc=##class(web.DHCINSUPort).GetCNCODE(TarItemDesc,4,"")
	i ItemType="Arc" d
	.q:TarItemId=""
	.s ARCIMSubscript=$p(TarItemId,"||",1)
	.s ARCIMVersion=$p(TarItemId,"||",2)
	.s TarItemCode=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)
	.s TarItemDesc=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
	.s PTarItemDesc=##class(web.DHCINSUPort).GetCNCODE(TarItemDesc,4,"")
	
	q:($$ALPHAUP^SSUTIL4(TarItemCode)'[tCodeAndDesc)&&(TarItemDesc'[tCodeAndDesc)&&(PTarItemDesc'[tCodeAndDesc)
	q:(rule'="")&&(RuleId'=rule)
	q:(ExamineFlag'="")&&(ExamineFlag'=+(AuditStatus))
	
	d QueryPortList	
	q
    
QueryPortList
	set Data=$lb(Rowid,TarItemId,TarItemCode,TarItemDesc,RuleId,RuleDesc,ActiveStartDate,ActiveEndDate,Rate,Amt,HospId,AuditStatus,AuditUser,AuditDate,AuditTime,Memo,ItemType)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Creator: Tanfb
/// CreateDate: 2023-01-10
/// Descript: 保存审核人等信息
/// Table : CF_BILL_COM.PriceRuleConItm
/// Input: 
/// Output: 
/// Return: 0 表示 成功 非0表示失败
/// DeBug:  w ##class(BILL.CFG.COM.BL.PriceRuleConItmCtl).SaveAudit("302^Y^审核备注","3334")
ClassMethod SaveAudit(InStr, SessionStr)
{
	new (InStr, SessionStr)
	s $zt="SaveAuditErr"
	s ^CacheTemp("BILL.CFG.COM.BL.PriceRuleConItmCtl","SaveAudit")=$lb(InStr,SessionStr)
	q:InStr="" "-1^入参InStr不能为空"
	k PLIST
	s UserId=+SessionStr
	s PLIST(1)=$p(InStr,"^",1) // ROWID
	s PLIST(9)=$p(InStr,"^",2) // AuditStatus
	s PLIST(13)=$p(InStr,"^",3) // Memo
	s PLIST(10)=UserId  // AuditUser
	s PLIST(11)=+$h // AuditDate
	s PLIST(12)=$p($h,",",2) // AuditTime
	s RowId=PLIST(1)
	q:RowId="" "rowid不能为空"
	&sql(update CF_BILL_COM.PriceRuleConItm  values PLIST() where ID=:RowId)
	s rtn=-1
	if +SQLCODE=0  d
	.s rtn=%ROWID
	else  d
	.s rtn=SQLCODE
	..s:(+rtn>0) rtn=-rtn_"^"_$g(%msg)	//保证插入失败时 肯定返回负值
	q rtn
SaveAuditErr
	s $zt=""
	q "-2^程序异常："_$ze
}

/// Creator: tangzf
/// CreateDate: 2023-2-13
/// Descript: 获取优惠规则信息
/// Table : CF_BILL_COM.PriceRule
/// Input:  Adm   就诊ID  -必填
///         OEORI 
///         ARCIM   
///         HospDr   -必填
///         PriceDate 取价格日期：格式 65543 ,若为空则按当前日期$h
/// Output:json数组对象 RepeatFlag:  Yes 可以重复叠加,Priority：1，2，3，4，5，数字越小优先级越高
///                    [{RuleId:优惠规则ID,RuleCode:优惠规则代码,RepeatFlag:叠加标志,Priority:优先级,RuleType:规则类型}
///                     ,{}
///                    ] 
/// Return: 
/// w ##class(BILL.CFG.COM.BL.PriceRuleConItmCtl).GetPriceRuleInfo("7488","6821||4","11559||1","2",66519)
ClassMethod GetPriceRuleInfo(Adm, OEORI, ARCIM, HospDr, PriceDate) As %DynamicArray
{
    n (Adm, OEORI, ARCIM, HospDr, PriceDate)
    q:(Adm="")||(HospDr="") []
    
	s Papmi=$p(^PAADM(Adm),"^",1)

    s HospDr=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("CF_BILL_COM.PriceRule", HospDr)
    s ArrObj=[]
    
	;k %BillPriceRule(Adm)
    
    i '$d(%BillPriceRule(Adm,"AdmInfo"))  d    //就诊基础信息
    .//就诊规则只取一遍
    .d InitAdmInfo
    .s RuleType="AdmRule"
    .d CheckRule
    
    //医嘱规则每次根据医嘱取
    i (OEORI'="")&&('$d(%BillPriceRule(Adm,"OrdInfo",OEORI)))  d   //医嘱基础信息
    .d InitOrdInfo
    .s RuleType="OrdRule"
    .d CheckRule
    
    //即包含就诊的规则，又包含医嘱的规则
    //也就是一个规则的准入点 同时包含 医嘱相关准入点/就诊相关准入点
    //   如果项目有需要可以放开下2行注释
    //s RuleType="All"
    //d CheckRule
    
	;k %BillPriceRule(Adm)

    q ArrObj
  
InitAdmInfo
    s AdmDate=$p(^PAADM(Adm),"^",6)  //就诊日期
    s %BillPriceRule(Adm,"AdmInfo","AdmAge")=##class(web.UDHCJFPRICE).GetAgeYear(Papmi, AdmDate) //  按就诊年龄
    s %BillPriceRule(Adm,"AdmInfo","AdmLoc")=$p(^PAADM(Adm),"^",4)       //就诊科室
    s %BillPriceRule(Adm,"AdmInfo","AdmType")=$p(^PAADM(Adm),"^",2)      //就诊类型
    s %BillPriceRule(Adm,"AdmInfo","AdmReason")=$p(^PAADM(Adm,1),"^",7)  //就诊费别
    s %BillPriceRule(Adm,"AdmInfo","Sex")=$p(^PAPER(Papmi,"ALL"),"^",7)  //性别  
    
    q
InitOrdInfo
    s %BillPriceRule(Adm,"OrdInfo",OEORI,"OrdAdmReason")=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),11)),"^",18)       // 医嘱费别
    s %BillPriceRule(Adm,"OrdInfo",OEORI,"ArcItm")=$p(^OEORD(+OEORI,"I",$p(OEORI,"||",2),1),"^",2) // 医嘱项
    s %BillPriceRule(Adm,"OrdInfo",OEORI,"Loc")=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),7)),"^",2)  //开单科室
    s %BillPriceRule(Adm,"OrdInfo",OEORI,"RecLoc")=$p($g(^OEORD(+OEORI,"I",$p(OEORI,"||",2),3)),"^",6)  // 接收科室
    s %BillPriceRule(Adm,"OrdInfo",OEORI,"OrdAge")=##class(web.UDHCJFPRICE).GetAgeYear(Papmi, PriceDate) // 按医嘱计算年龄
    q
CheckRule
    s RuleCode=""
    f  s RuleCode=$o(^CF.BILL.COM.PriceRuleI("IndexHospIdRuleType",HospDr,RuleType,RuleCode))  q:(RuleCode="")  d
    .s RuleId=$o(^CF.BILL.COM.PriceRuleI("IndexHospIdRuleType",HospDr,RuleType,RuleCode,""))
    .s RuleData=$g(^CF.BILL.COM.PriceRuleD(RuleId))
    .s StDate=$lg(RuleData,4)
    .s EndDate=$lg(RuleData,5)
    .q:((StDate'="")&&(StDate>PriceDate))
    .q:((EndDate'="")&&(EndDate<PriceDate))
    .q:'$d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId)) //没有维护准入点的
    .s RepeatFlag=$lg(RuleData,8) //是否叠加
    .s Priority=$lg(RuleData,7)   //优先级
    .;可以 根据具体情况 将 某个条件提前 提高效率
    .;还需要补充校验 准入点生效日期--------------------------------------------！！！tangzf
    .//就诊
    . //左闭合区间，左边取等
    .s AgeCfgVal=$o(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"AdmAge",""))
    .s AgeCfgValMin=+AgeCfgVal
    .s AgeCfgValMax=$p(AgeCfgVal,",",2)
    .q:(AgeCfgVal'="")&&($g(%BillPriceRule(Adm,"AdmInfo","AdmAge"))<AgeCfgValMin)
    .q:(AgeCfgVal'="")&&($g(%BillPriceRule(Adm,"AdmInfo","AdmAge"))>=AgeCfgValMax)
    .;;(表示规则配置了准入点)&&(表示业务发生的值符合配置的准入点值)
    .q:($d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"AdmLoc")))&&('$d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"AdmLoc",$g(%BillPriceRule(Adm,"AdmInfo","AdmLoc")))))
    .q:($d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"AdmType")))&&('$d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"AdmType",$g(%BillPriceRule(Adm,"AdmInfo","AdmType")))))
    .q:($d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"AdmReason")))&&('$d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"AdmReason",$g(%BillPriceRule(Adm,"AdmInfo","AdmReason")))))
    .q:($d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"Sex")))&&('$d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"Sex",$g(%BillPriceRule(Adm,"AdmInfo","Sex")))))
    .//医嘱
    .s AgeCfgVal=$o(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"OrdAge",""))
    .s AgeCfgValMin=+AgeCfgVal
    .s AgeCfgValMax=$p(AgeCfgVal,",",2)
    .q:(AgeCfgVal'="")&&($g(%BillPriceRule(Adm,"AdmInfo","OrdAge"))<AgeCfgValMin)
    .q:(AgeCfgVal'="")&&($g(%BillPriceRule(Adm,"AdmInfo","OrdAge"))>=AgeCfgValMax)    
    .q:(OEORI'="")&&($d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"RecLoc")))&&('$d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"RecLoc",$g(%BillPriceRule(Adm,"OrdInfo",OEORI,"RecLoc")))))
    .q:(OEORI'="")&&($d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"Loc")))&&('$d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"Loc",$g(%BillPriceRule(Adm,"OrdInfo",OEORI,"Loc")))))
    .q:(OEORI'="")&&($d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"OrdAdmReason")))&&('$d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"OrdAdmReason",$g(%BillPriceRule(Adm,"OrdInfo",OEORI,"OrdAdmReason")))))
    .q:(ARCIM'="")&&($d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"ArcItm")))&&('$d(^CF.BILL.COM.PriceRuleAPI("IndexRuleCfgVal",RuleId,"ArcItm",ARCIM)))
    .s json={}
    .s json.RuleId=RuleId
    .s json.RuleType=RuleType
    .s json.RuleCode=RuleCode
    .s json.RepeatFlag=RepeatFlag
    .s json.Priority=Priority
    .d ArrObj.%Push(json)
    q
}

/// Creator: tangzf
/// CreateDate: 2023-2-13
/// Descript: 获取优惠项目明细
/// Table : CF_BILL_COM.PriceRule
/// Input:  PriceRuleId     -必填 优惠规则ID
///         TarId           -必填 收费项目ID
///         PriceDate       -必填 取价格日期
/// 
/// Return:  Rate_"^"_Price
/// w ##class(BILL.CFG.COM.BL.PriceRuleConItmCtl).GetPriceRuleDetInfo(3, 7997, 66519)
ClassMethod GetPriceRuleDetInfo(PriceRuleId, TarId, PriceDate)
{
    n (PriceRuleId, TarId, PriceDate)
    s rtn=""
	s RuldDetId=""
    f  s RuldDetId=$o(^CF.BILL.COM.PriceRuleConItmI("IndexRuleTarItem",PriceRuleId,"Tar",TarId,RuldDetId))  q:(RuldDetId="")  d
    .s RuldDetData=$g(^CF.BILL.COM.PriceRuleConItmD(RuldDetId))
    .s StDate=$lg(RuldDetData,4)
    .s EndDate=$lg(RuldDetData,5)
    .q:((StDate'="")&&(StDate>PriceDate))
    .q:((EndDate'="")&&(EndDate<PriceDate))
	.s Rate=$lg(RuldDetData,6)
    .s Price=$lg(RuldDetData,7)
    .s rtn=Rate_"^"_Price
    q rtn
}

/// Creator: tanfb
/// CreateDate: 2023-03-15
/// Descript: 查询符合通用配置的收费项
/// Table : DHC_TarItem
/// Input:	KeyCode -非必填 收费项别名
/// 		HospId  -必填 院区ID
/// Output: 
/// d ##class(%ResultSet).RunQuery("BILL.CFG.COM.BL.PriceRuleConItmCtl","QueryTarItm","大","2")
Query QueryTarItm(KeyCode As %String, HospId As %String) As websys.Query(ROWSPEC = "id,code,desc") [ SqlProc ]
{
}

ClassMethod QueryTarItmExecute(ByRef qHandle As %Binary, KeyCode As %String = "", HospId As %String = "") As %Status [ ProcedureBlock = 1 ]
{
	set repid=$I(^CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	s ^CacheTemp("BILL.CFG.COM.BL.PriceRuleConItmCtl","QueryTarItm")=$lb(KeyCode,HospId)

	q:HospId="" $$$OK
	s rtnvalue=##class(%ResultSet).%New("DHCBILLConfig.DHCBILLFIND:FindTarItem")
	d rtnvalue.Execute(KeyCode,"",HospId)
		while(rtnvalue.Next()){
			s id=rtnvalue.Get("rowid")
			s code=rtnvalue.Get("code")
			s desc=rtnvalue.Get("desc")
			s TarActiveFlag=..GetTarActiveFlag(id, HospId) //判断该收费项是否允许优惠
			continue:(TarActiveFlag="0")			
			d OutPutData
		}

	quit $$$OK  
OutPutData
	set Data=$lb(id,code,desc)
	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

/// Creator: tanfb
/// CreateDate: 2023-3-16
/// Descript: 判断该收费项是否允许优惠
/// Table : 
/// Input:  TarId  -必填 收费项目ID
/// 		HospId -必填 院区ID
/// Output:  1 允许
/// 		 0 不允许
/// w ##class(BILL.CFG.COM.BL.PriceRuleConItmCtl).GetTarActiveFlag(5147,2)
ClassMethod GetTarActiveFlag(TarId, HospId)
{
    n (TarId,HospId)
    q:HospId="" "-1^院区ID不能为空"
    q:TarId="" "-1^收费项目ID不能为空"
    s rtn=""
    s rtn1=##class(%ResultSet).%New("BILL.CFG.COM.GeneralCfg:GetResultForQuery") 
	d rtn1.Execute("PROMGT.PriceConcessionsItm.BYXYHDSFX","",TarId,HospId)  //判断该收费项是否属于不允许优惠的收费项
	q:rtn1.Next() "0"
	s SubCate=$p($g(^DHCTARI(TarId)),"^",4)
	s myTarCate=$s((+SubCate'=0):$p($g(^DHCTarC("SC",SubCate)),"^",3)) //收费项目大类
	s rtn2=##class(%ResultSet).%New("BILL.CFG.COM.GeneralCfg:GetResultForQuery")
	d rtn2.Execute("PROMGT.PriceConcessionsItm.BYXYHDSFXDL","",myTarCate,HospId) //判断该收费项是否属于不允许优惠的收费项大类
	q:rtn2.Next() "0"
	s rtn="1"
		
    q rtn
}

}
