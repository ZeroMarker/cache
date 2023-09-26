Class BILL.CFG.COM.ChildExtraChargeCom Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator: ZhYW
/// CreatDate: 2020-09-04
/// Description: 查询 儿童加收项目收费项规则
/// Input: HospId:院区指针
/// Output: 
/// Debug:  d ##class(%ResultSet).RunQuery("BILL.CFG.COM.ChildExtraChargeCom","QueryRules","2")
Query QueryRules(HospId As %String) As websys.Query(ROWSPEC = "RowId:%String,RuleDesc:%String")
{
}

ClassMethod QueryRulesExecute(ByRef qHandle As %Binary, HospId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	set DefHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_ChildExtraChargeRule", HospId)
	set Today=+$h
	set RowId=0
	for  set RowId=$o(^CF.BILL.CFG.CHIEXTCHARGERULE(RowId)) quit:(RowId="")  do
	.set Data=$g(^CF.BILL.CFG.CHIEXTCHARGERULE(RowId))
	.quit:(Data="")
	.set HospDR=$p(Data,"^",8)
	.quit:(HospDR'=DefHospId)
	.set DateFrom=$p(Data,"^",5)
	.quit:((DateFrom'="")&&(DateFrom>Today))
	.set DateTo=$p(Data,"^",6)
	.quit:((DateTo'="")&&(DateTo<Today))
	.set RuleDesc=$p(Data,"^",2)
	.do OutputRules

	quit $$$OK
OutputRules   
	set Data=$lb(RowId,RuleDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

Query QueryAll(Rule As %String, TarItem As %String, HospDr As %String) As websys.Query(ROWSPEC = "RowId,RuleCode,RuleDesc,TarId,TarCode,TarDesc,ActStartDate,ActEndDate,Rate,Amt,RuleId")
{
}

/// Creator: tangzf
/// CreatDate: 2020-07-27
/// Descript: 查询 儿童加收项目收费项
/// Input:		txt : 	检索关键字	
/// 			Class : 检索类型(例如 按类型)
/// 			Rule : 	规则
///             HospDr:院区指针 
/// Output: 
/// Debug: d ##class(%ResultSet).RunQuery("BILL.CFG.COM.ChildExtraChargeCom","QueryAll","","","")
ClassMethod QueryAllExecute(ByRef qHandle As %Binary, Rule As %String, TarItem As %String, HospDr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^CacheTemp("INSUTarItem")=$lb(Rule, TarItem, HospDr)
	
	s HospDr=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_ChildExtraCharge", HospDr)
	s RowId=0
	f  s RowId=$o(^CF.BILL.CFG.CHIEXTCHARGE(RowId)) quit:(RowId="")  d
	.s HospId=$p($G(^CF.BILL.CFG.CHIEXTCHARGE(RowId)),"^",7)
	.q:(HospDr'=HospId)
	.s RuleId=$p(^CF.BILL.CFG.CHIEXTCHARGE(RowId),"^",2)
	.q:(RuleId="")
	.q:(Rule'="")&&(Rule'=RuleId)
	.s RuleCode=$p($g(^CF.BILL.CFG.CHIEXTCHARGERULE(RuleId)),"^",1)
	.s RuleDesc=$p($g(^CF.BILL.CFG.CHIEXTCHARGERULE(RuleId)),"^",2)
	.s TarId=$p($g(^CF.BILL.CFG.CHIEXTCHARGE(RowId)),"^",1)
	.q:(TarId="")
	.q:(TarItem'="")&&(TarItem'=TarId)
	.s TarCode=$p($g(^DHCTARI(TarId)),"^",1)
	.s TarDesc=$p($g(^DHCTARI(TarId)),"^",2)
	.s Rate=$p($g(^CF.BILL.CFG.CHIEXTCHARGE(RowId)),"^",5)
	.s Amt=$p($G(^CF.BILL.CFG.CHIEXTCHARGE(RowId)),"^",6)
	.s ActStartDate=$p($g(^CF.BILL.CFG.CHIEXTCHARGE(RowId)),"^",3)
	.s ActStartDate=##class(websys.Conversions).DateLogicalToHtml(ActStartDate)
	.s ActEndDate=$p($g(^CF.BILL.CFG.CHIEXTCHARGE(RowId)),"^",4)
	.s ActEndDate=##class(websys.Conversions).DateLogicalToHtml(ActEndDate)
	.d BuildData

	quit $$$OK
BuildData   
	set Data=$lb(RowId,RuleCode,RuleDesc,TarId,TarCode,TarDesc,ActStartDate,ActEndDate,$fn(Rate,"",2),$fn(Amt,"",2),RuleId)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

/// Creator: tangzf
/// CreatDate: 2020-07-27
/// Descript: 判断同一规则，同一院区下，是否存在同一收费项目(在同一院区同一规则下 不能存在重复收费项目)
/// Input: InpuStr : 	
/// Return: 0 : 无重复  ， -1 : 存在重复
/// Debug:  w ##class(BILL.CFG.COM.ChildExtraChargeCom).CheckData(""")
ClassMethod CheckData(InpuStr)
{
	new (InpuStr)
	s ^CacheTemp("CCheckData")=InpuStr
	s HospId=$p(InpuStr,"^",8)
	q:+HospId<1 "-1"
	s rtn=0
	s RowId=$p(InpuStr,"^",1)
	i +RowId=0  d
	.s TarId=$p(InpuStr,"^",2)
	.s RuleId=$p(InpuStr,"^",3)
	.s DataActStDate=##class(websys.Conversions).DateHtmlToLogical($p(InpuStr,"^",4))
	.s DataActEndDate=##class(websys.Conversions).DateHtmlToLogical($p(InpuStr,"^",5))
	.s tmpActFlag=""
	.s tmpFlag=..CheckDataValid(TarId,RuleId,HospId,"",DataActStDate,DataActEndDate)
	.s:+tmpFlag=0 rtn="-1"
	else  d
	.s OldTarId=$p($g(^CF.BILL.CFG.CHIEXTCHARGE(RowId)),"^",1)
	.s OldRuleId=$p($g(^CF.BILL.CFG.CHIEXTCHARGE(RowId)),"^",2)
	.s TarId=$p(InpuStr,"^",2)
	.;q:(TarId=OldTarId)&&(OldRuleId=$p(InpuStr,"^",3)) // 收费项未改变时不校验
	.s RuleId=$p(InpuStr,"^",3)
	.s DataActStDate=##class(websys.Conversions).DateHtmlToLogical($p(InpuStr,"^",4))
	.s DataActEndDate=##class(websys.Conversions).DateHtmlToLogical($p(InpuStr,"^",5))
	.s ConfigAcStartDate=$p($g(^CF.BILL.CFG.CHIEXTCHARGE(RowId)),"^",3)
	.s ConfigAcEndDate=$p($g(^CF.BILL.CFG.CHIEXTCHARGE(RowId)),"^",4)
	..// 当前数据的日期未发生变化时 不进行数据校验
	.;q:(OldTarId=TarId)&&(OldRuleId=RuleId)&&(ConfigAcStartDate=DataActStDate)&&(DataActEndDate=ConfigAcEndDate)
	.s tmpActFlag=""
	.;s:+$h<DataActStDate tmpActFlag="1" // 传入的日期为无效日期段时 不进行数据校验
	.;s:+$h>DataActEndDate tmpActFlag="1"
	.;i tmpActFlag'="1" d
	.s tmpFlag=..CheckDataValid(TarId,RuleId,HospId,RowId,DataActStDate,DataActEndDate)
	.s:+tmpFlag=0 rtn="-1"
	q rtn
}

/// Creator: tangzf
/// CreatDate: 2020-07-27
/// Descript: 判断维护的加收项目是否有效
/// Input:		InpuStr : 	
/// 		RuleId 儿童加收规则Id
/// 		ConfigId="儿童加收的Id"
/// Return: 0 : 有效  ， -1 :无效
/// Debug:  w ##class(BILL.CFG.COM.ChildExtraChargeCom).CheckDataValid() 2021-9-1  2021-12-1
ClassMethod CheckDataValid(TarDr, RuleId, HospDr, ConfigId, ParamStDate, ParamEndDate)
{
	new (TarDr,RuleId,HospDr,ConfigId,ParamStDate,ParamEndDate)
	s ^CacheTemp("CheckData")=$lb(TarDr,RuleId,HospDr,ConfigId,ParamStDate,ParamEndDate)
	s HospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_ChildExtraCharge",HospDr,+$h)
	q:+HospId<1 "-1"
	s tmpRowId="",rtn="-1"
	for  s tmpRowId=$o(^CF.BILL.CFG.CHIEXTCHARGE(0,"Hosp",HospId,"TarItem",TarDr,"Rule",RuleId,tmpRowId)) q:(tmpRowId="")||(rtn=0)  d
	.s ConfigAcStartDate=$p($g(^CF.BILL.CFG.CHIEXTCHARGE(tmpRowId)),"^",3) //2022-8-3
	.s ConfigAcEndDate=$p($g(^CF.BILL.CFG.CHIEXTCHARGE(tmpRowId)),"^",4) // 2023-8-11
	.;s:(ParamStDate>ConfigAcStartDate)||(ParamEndDate<ConfigAcEndDate) rtn=0 //传入的新日期和旧日期不能嵌套
	.q:(ParamEndDate<ConfigAcStartDate) //传入日期的结束日期不在当前数据的范围内 作为无效数据
	.q:(ParamStDate>ConfigAcEndDate)
	.q:(ConfigId'="")&&(ConfigId=tmpRowId) ;修改本身数据不进行判断
	.;q:ConfigStDate>ConfigAcStartDate //传入日期不能在数据有效日期范围内
	.;q:ConfigEndDate<ConfigAcEndDate
	.;q:+$h<ConfigAcStartDate  
	.;q:+$h>ConfigAcEndDate //找有效数据
	.s rtn="0" //找有效数据 不能重复添加
	q rtn
}

/// Creator: tangzf
/// CreatDate: 2020-07-27
/// Descript: 新增 儿童加收项目收费项
/// Input: InpuStr : 	
/// Return: -1004 存在重复项目 ； 0：成功
/// Debug: d ##class(BILL.CFG.COM.ChildExtraChargeCom).RunQuery("BILL.CFG.COM.ChildExtraChargeCom","QueryAll","","0","ZZB","","","")
ClassMethod Insert(InpuStr)
{
	new (InpuStr)
	q:+$p(InpuStr,"^",8)<1 "-1003^院区不能为空" 
	s RowId=$p(InpuStr,"^",1)
	
	q:($p(InpuStr,"^",4))=""||($p(InpuStr,"^",5))="" "-1001^日期不能为空" 
	
	s ParamStartDate=##class(websys.Conversions).DateHtmlToLogical($p(InpuStr,"^",4))
	s ParamEndDate=##class(websys.Conversions).DateHtmlToLogical($p(InpuStr,"^",5))
	q:((+RowId=0)&&(ParamStartDate<+$h)) "-1002^开始日期不能小于当日"
	
	if (ParamEndDate'="") {
		q:(ParamEndDate<+$h) "-1002^结束日期不能小于当日"
		q:(ParamEndDate<ParamStartDate) "-1002^结束日期不能小于开始日期"
	}
	
	s rtn=..CheckData(InpuStr)
	q:(+rtn) "-1004^数据重复"

	i (+RowId=0)  d
	.s PLIST(2)=$p(InpuStr,"^",2)
	.s PLIST(3)=$p(InpuStr,"^",3)
	.s PLIST(4)=$p(InpuStr,"^",4)
	.s:(PLIST(4)'="") PLIST(4)=##class(websys.Conversions).DateHtmlToLogical(PLIST(4))
	.s PLIST(5)=$p(InpuStr,"^",5)
	.s:(PLIST(5)'="") PLIST(5)=##class(websys.Conversions).DateHtmlToLogical(PLIST(5))
	.s PLIST(6)=$p(InpuStr,"^",6)
	.s PLIST(7)=$p(InpuStr,"^",7)
	.s PLIST(8)=$p(InpuStr,"^",8)
	.&sql(insert into CF_BILL_CFG.ChildExtraCharge values PLIST())
	else  d
	.s SQLCODE=..Update(InpuStr)
	q SQLCODE_"^"
}

/// Creator: tangzf
/// CreatDate: 2020-07-27
/// Descript: 修改 儿童加收项目收费项
/// Input: InpuStr : 	
/// Return: 
/// Debug:  d ##class(BILL.CFG.COM.ChildExtraChargeCom).RunQuery("web.INSUTarItemsCom","QueryAll","","0","ZZB","","","")
ClassMethod Update(InpuStr)
{
	new (InpuStr)
	s RowId=$p(InpuStr,"^",1)
	q:+RowId=0 "-2"
	s PLIST(2)=$p(InpuStr,"^",2)
	s PLIST(3)=$p(InpuStr,"^",3)
	s PLIST(4)=$p(InpuStr,"^",4)
	s:PLIST(4)'="" PLIST(4)=##class(websys.Conversions).DateHtmlToLogical(PLIST(4))
	s PLIST(5)=$p(InpuStr,"^",5)
	s:PLIST(5)'="" PLIST(5)=##class(websys.Conversions).DateHtmlToLogical(PLIST(5))
	s PLIST(6)=$p(InpuStr,"^",6)
	s PLIST(7)=$p(InpuStr,"^",7)
	s PLIST(8)=$p(InpuStr,"^",8)
	&sql(update CF_BILL_CFG.ChildExtraCharge values PLIST() where RowId=:RowId)
	q SQLCODE
}

/// Creator: tangzf
/// CreatDate: 2020-07-27
/// Descript: 删除 儿童加收项目收费项
/// Input:		InpuStr : 	
/// Return: 
/// DebBug: 
ClassMethod Delete(InpuStr)
{
	new (InpuStr)
	s RowId=$p(InpuStr,"^",1)
	q:+RowId=0 "-2"
	&sql(delete from CF_BILL_CFG.ChildExtraCharge where RowId=:RowId)
	q SQLCODE
}

/// Creator: tangzf
/// CreatDate: 2020-07-27
/// Descript:  获取儿童加收 信息
/// Input:		Adm : 就诊Id 必填
/// 				TarItem : 收费项目Id 必填
/// 				CalDate : 年龄计算日期 必填
/// 				HospId : 院区 必填
/// Return: rate ^ LimtiPrice 加收比例^加收价格
/// Debug: w ##class(BILL.CFG.COM.ChildExtraChargeCom).GetChildExtraChargeConfig("759","7090","2020-7-28","2")
ClassMethod GetChildExtraChargeConfig(Adm, TarItem, CalDate, HospId)
{
	new (Adm, TarItem, CalDate, HospId)
	s $zt="GetChildExtraChargeConfigErr"
	s rtn="0^0"
	q:(+Adm=0) rtn
	q:HospId="" rtn
	s Age=..GetPatAge(Adm, CalDate)
	q:Age="" rtn
	s RuleId=0,TmpRuleId=""
	s RuleDate=+$h
	
	s TmpHospDr=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_ChildExtraChargeRule",HospId,+$h)
	f  s RuleId=$o(^CF.BILL.CFG.CHIEXTCHARGERULE(RuleId))  quit:(RuleId="")||(TmpRuleId'="")  d
	.s RuleStart=$p(^CF.BILL.CFG.CHIEXTCHARGERULE(RuleId),"^",3)
	.s RuleEnd=$p(^CF.BILL.CFG.CHIEXTCHARGERULE(RuleId),"^",4)
	.s ActStDate=$p(^CF.BILL.CFG.CHIEXTCHARGERULE(RuleId),"^",5)
	.s ActEndDate=$p(^CF.BILL.CFG.CHIEXTCHARGERULE(RuleId),"^",6)
	.q:Age<RuleStart  
	.q:Age>RuleEnd  
	.q:RuleDate<ActStDate  
	.q:RuleDate>ActEndDate  
	.s TmpRuleId=RuleId
		
	q:+TmpRuleId=0 rtn	
	
	s TmpHospDr=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_ChildExtraCharge",HospId,+$h)
	s ConfigId=$o(^CF.BILL.CFG.CHIEXTCHARGE(0,"Hosp",TmpHospDr,"TarItem",TarItem,"Rule",TmpRuleId,""))
	q:+ConfigId=0 rtn
	
	s ConfigAcStartDate=$p($g(^CF.BILL.CFG.CHIEXTCHARGE(ConfigId)),"^",3)
	s ConfigAcEndDate=$p($g(^CF.BILL.CFG.CHIEXTCHARGE(ConfigId)),"^",4)
	
	q:RuleDate<ConfigAcStartDate rtn 
	q:RuleDate>ConfigAcEndDate rtn 
	
	s rtn=+$p($g(^CF.BILL.CFG.CHIEXTCHARGE(ConfigId)),"^",5)_"^"_+$p($g(^CF.BILL.CFG.CHIEXTCHARGE(ConfigId)),"^",6)
	q rtn
GetChildExtraChargeConfigErr
	s $zt=""
	q "0^0"
}

/// Creator: ZhYW
/// CreatDate: 2020-07-28
/// Description: 根据病人ID和就诊ID获取病人年龄
/// Input:	adm: PA_Adm.RowId
/// Return:	年龄-岁
/// Debug: w ##class(BILL.CFG.COM.ChildExtraChargeCom).GetPatAge(398,"")
ClassMethod GetPatAge(adm As %String, calDate As %String) As %String
{
	new (adm, calDate)
	
	set papmi=$p($g(^PAADM(adm)),"^",1)
	quit:(papmi="") 0
	set birthDate=##class(web.UDHCJFCOMMON).GetPatBirthDate(papmi)
	quit:(birthDate="") 0
	set calDate=##class(websys.Conversions).DateHtmlToLogical(calDate)
	set ageStr=$$CalAge^at182(birthDate, calDate, "", "", "")
	set ageYear=$p(ageStr,"|",12)
	quit ageYear
}

}
