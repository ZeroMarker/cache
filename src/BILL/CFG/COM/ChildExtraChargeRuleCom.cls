Class BILL.CFG.COM.ChildExtraChargeRuleCom Extends %RegisteredObject [ Not ProcedureBlock ]
{

Query QueryAll(HospDr) As websys.Query(ROWSPEC = "RowId,RuleCode,RuleDesc,AgeStart,AgeEnd,ActStartDate,ActEndDate,HospId,AgeUom")
{
}

/// Creator: tangzf
/// CreatDate: 2020-07-27
/// Descript: 查询 儿童加收项目收费项规则
/// Input: HospDr:院区指针 
/// Output: 
/// Return: 
/// Debug:  d ##class(%ResultSet).RunQuery("BILL.CFG.COM.ChildExtraChargeRuleCom","QueryAll","2")
ClassMethod QueryAllExecute(ByRef qHandle As %Binary, HospDr) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	s DefHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_ChildExtraChargeRule", HospDr)
	s RowId=0
	f  s RowId=$o(^CF.BILL.CFG.CHIEXTCHARGERULE(RowId)) quit:(RowId="")  d
	.s RuleData=$g(^CF.BILL.CFG.CHIEXTCHARGERULE(RowId))
	.s HospId=$p(RuleData,"^",8)
	.q:(DefHospId'=HospId)
	.s RuleCode=$p(RuleData,"^",1)
	.s RuleDesc=$p(RuleData,"^",2)
	.s AgeStart=$p(RuleData,"^",3)
	.s AgeEnd=$p(RuleData,"^",4)
	.s ActStartDate=$p(RuleData,"^",5)
	.s ActEndDate=$p(RuleData,"^",6)
	.s ActStartDate=##class(websys.Conversions).DateLogicalToHtml(ActStartDate) 
	.s ActEndDate=##class(websys.Conversions).DateLogicalToHtml(ActEndDate)
	.s AgeUom=$p(RuleData,"^",7)
	.d BuildData

	quit $$$OK
BuildData   
	set Data=$lb(RowId,RuleCode,RuleDesc,AgeStart,AgeEnd,ActStartDate,ActEndDate,HospId,AgeUom)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
 	quit
}

/// Creator: tangzf
/// CreatDate: 2020-07-27
/// Descript: 新增儿童加收项目收费项
/// Input: InpuStr : 	
/// Output: 
/// Return: 
/// Debug:  d ##class(BILL.CFG.COM.ChildExtraChargeRuleCom).RunQuery("BILL.CFG.COM.ChildExtraChargeCom","QueryAll","","0","ZZB","","","")
ClassMethod Insert(InpuStr)
{
	new (InpuStr)
	set RowId=$p(InpuStr,"^",1)
	
	q:($p(InpuStr,"^",4))=""||($p(InpuStr,"^",5))="" "-1001^日期不能为空" 
	s ParamStartDate=##class(websys.Conversions).DateHtmlToLogical($p(InpuStr,"^",4))	
	s ParamEndDate=##class(websys.Conversions).DateHtmlToLogical($p(InpuStr,"^",5))	
	q:(+RowId=0)&&(ParamEndDate<+$h) "-1002^请维护有效数据" //不允许新增无意义的数据
	
	if (+RowId=0) do
	.s PLIST(2)=$p(InpuStr,"^",2)
	.s PLIST(3)=$p(InpuStr,"^",3)
	.s PLIST(4)=$p(InpuStr,"^",4)
	.s:$p(InpuStr,"^",4)'="" PLIST(4)=##class(websys.Conversions).DateHtmlToLogical($p(InpuStr,"^",4))
	.s PLIST(5)=$p(InpuStr,"^",5)
	.s:$p(InpuStr,"^",5)'="" PLIST(5)=##class(websys.Conversions).DateHtmlToLogical($p(InpuStr,"^",5))
	.s PLIST(6)=$p(InpuStr,"^",6)
	.s PLIST(7)=$p(InpuStr,"^",7)
	.s PLIST(8)=$p(InpuStr,"^",8)
	.s PLIST(9)=$p(InpuStr,"^",9)
	.&sql(insert into CF_BILL_CFG.ChildExtraChargeRule values PLIST())
	else  d
	.s SQLCODE=..Update(InpuStr)
	q SQLCODE
}

/// Creator: tangzf
/// CreatDate: 2020-07-27
/// Descript: 修改 儿童加收项目收费项
/// Input:		InpuStr : 	
/// Output: 
/// Return: 
/// Debug:  d ##class(BILL.CFG.COM.ChildExtraChargeRuleCom).Update("")
ClassMethod Update(InpuStr)
{
	new (InpuStr)
	s RowId=$p(InpuStr,"^",1)
	q:+RowId=0 "-2"
	s PLIST(2)=$p(InpuStr,"^",2)
	s PLIST(3)=$p(InpuStr,"^",3)
	s PLIST(4)=$p(InpuStr,"^",4)
	s:$p(InpuStr,"^",4)'="" PLIST(4)=##class(websys.Conversions).DateHtmlToLogical($p(InpuStr,"^",4))
	s PLIST(5)=$p(InpuStr,"^",5)
	s:$p(InpuStr,"^",5)'="" PLIST(5)=##class(websys.Conversions).DateHtmlToLogical($p(InpuStr,"^",5))
	s PLIST(6)=$p(InpuStr,"^",6)
	s PLIST(7)=$p(InpuStr,"^",7)
	s PLIST(8)=$p(InpuStr,"^",8)
	.s PLIST(9)=$p(InpuStr,"^",9)
	&sql(update CF_BILL_CFG.ChildExtraChargeRule values PLIST() where RowId = :RowId)
	q SQLCODE
}

/// Creator: tangzf
/// CreatDate: 2020-07-27
/// Descript: 删除 儿童加收项目收费项
/// Input:		InpuStr : 	
/// Output: 
/// Return: 
/// Debug: 
ClassMethod Delete(InpuStr)
{
	new (InpuStr)
	s RowId=$p(InpuStr,"^",1)
	q:+RowId=0 "-2"
	&sql(delete from CF_BILL_CFG.ChildExtraChargeRule where RowId=:RowId)
	q SQLCODE
}

/// Creator: tangzf
/// CreatDate: 2020-07-27
/// Descript: 校验数据是否合规
/// 				1.校验代码是否重复
/// 				2.校验 在有效日期内 年龄段是否是连续的
/// Input:		InpuStr : 	
/// Return:   0 合规，1^Msg 不合规
/// Debug:  w ##class(BILL.CFG.COM.ChildExtraChargeRuleCom).CheckData("^cs5^dffdfsdaf^2023-01-06^2023-01-13^1^2^^2")
ClassMethod CheckData(InpuStr)
{
	new (InpuStr)
	set rtn=0
	set ^TMP("CheckData")=InpuStr
	set ParamStDate=$p(InpuStr,"^",4)
	set ParamEndDate=$p(InpuStr,"^",5)
	set ParamStDate=##class(websys.Conversions).DateHtmlToLogical(ParamStDate)
	set ParamEndDate=##class(websys.Conversions).DateHtmlToLogical(ParamEndDate)
	set ParamCode=$p(InpuStr,"^",2)

	//quit:(ParamStDate>+$h) rtn
	quit:(ParamEndDate<+$h) rtn    //失效的不判断
	
	set ParamAgeSt=$p(InpuStr,"^",6)
	set ParamAgeEnd=$p(InpuStr,"^",7)
	
	set HospId=$p(InpuStr,"^",9)
	set DefHospId=##class(web.DHCBL.BDP.BDPMappingHOSP).GetDefHospIdByTableName("Bill_Com_ChildExtraChargeRule", HospId)
	set RowId=$p(InpuStr,"^",1)
	
	set id=0
	while($o(^CF.BILL.CFG.CHIEXTCHARGERULE(0,"Code",ParamCode,id))) {
		set id=$o(^CF.BILL.CFG.CHIEXTCHARGERULE(0,"Code",ParamCode,id))
		continue:(id=RowId)
		set rtn=1_"^"_"代码重复"
		quit
	}
	quit:(+rtn) rtn
	
	set RuleId=0
	for  set RuleId=$o(^CF.BILL.CFG.CHIEXTCHARGERULE(RuleId))  quit:(RuleId="")||(+rtn)  do
	.set RuleData=$g(^CF.BILL.CFG.CHIEXTCHARGERULE(RuleId))
	.set Code=$p(RuleData,"^",1)
	.set RuleStart=$p(RuleData,"^",3)
	.set RuleEnd=$p(RuleData,"^",4)
	.set ActStDate=$p(RuleData,"^",5)
	.set ActEndDate=$p(RuleData,"^",6) 
	.set HospDr=$p(RuleData,"^",8)
	.quit:(DefHospId'=HospDr)
	.quit:(ActStDate>+$h)
	.quit:(ActEndDate<+$h)  //失效的不判断
	.if ((ParamAgeSt>RuleStart)||(ParamAgeSt=RuleStart))&&(ParamAgeSt<RuleEnd)  do
	..quit:(ParamAgeSt=RuleStart)||(RuleEnd=ParamAgeEnd)
	..set rtn=2_"^"_"年龄段与其他记录存在重叠年龄段，请核实"
	.if (ParamAgeEnd>RuleStart)&&((ParamAgeEnd<RuleEnd)||(ParamAgeEnd=RuleEnd))  do
	..quit:(RuleId=RowId)
	..set rtn=3_"^"_"年龄段与其他记录存在重叠年龄段，请核实"
	
	quit rtn
}

}
