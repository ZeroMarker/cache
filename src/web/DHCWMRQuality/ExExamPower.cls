Import SQLUser

/// 评估标准树
Class web.DHCWMRQuality.ExExamPower Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 19;

/// 取病案评估标准权限
/// RuleId--质控标准ID(质控字典ID)
/// UserGroupId--用户安全组ID
/// Medtrak中权限配置
/// DHCWMRQuality  病案质控权限  DHCWMRQuality
/// RuleCode—1,RuleCode—2,RuleCode—3     科室权限
/// RuleCode—11,RuleCode—12,RuleCode—13  全院权限
ClassMethod GetRulePower(RuleId, UserGroupId)
{
	n (RuleId,UserGroupId)
	s ret=0
	
	q:(RuleId="")||(UserGroupId="") ret
	s tmpRule=$g(^DHCWMRRDIC(RuleId))
	q:tmpRule="" ret
	s Code=$p(tmpRule,"^",1)
	s Desc=$p(tmpRule,"^",2)
	s IsActive=$p(tmpRule,"^",4)
	q:IsActive'="Y" ret
	s ModuleName="DHCWMRQuality"
	f i=1:1:20 d
	.s MenuName=Code_"-"_i
	.s flg=##Class(web.DHCWMRCommon.UserFunction).UserFunction(UserGroupId,ModuleName,MenuName)
	.s:flg=0 ret=i
	
	q ret
}

/// 根据安全组ID取评估标准
/// UserGroupId--用户安全组ID
ClassMethod GetExamRuleByUserGroup(UserGroupId)
{
	n (UserGroupId)
	s ret=""
	
	//s ret="$"_1_"^"_11_"-"_$P($g(^DHCWMRRDIC(1)),"^",2)
	s RuleRowid=0
	f  s RuleRowid=$o(^DHCWMRRDIC(RuleRowid)) q:RuleRowid=""  d
	.s RulePower=+(..GetRulePower(RuleRowid,UserGroupId))
	.q:RulePower<1
	.;^DHCWMRER(0,"RuleActive",{RuleDr},{IsActive},{Rowid})
	.q:'$d(^DHCWMRER(0,"RuleActive",RuleRowid,"Y"))
	.s ExamRuleRowid=0
	.f  s ExamRuleRowid=$o(^DHCWMRER(0,"RuleActive",RuleRowid,"Y",ExamRuleRowid)) q:ExamRuleRowid=""  d
	..s tmpExamRule=$g(^DHCWMRER(ExamRuleRowid))
	..q:tmpExamRule=""
	..s TMP=ExamRuleRowid_"^"_RulePower_"-"_$P($g(^DHCWMRRDIC(RuleRowid)),"^",2)
	..s ret=ret_"$"_TMP
	
	s:ret'="" ret=$e(ret,2,$l(ret))
	s:ret="" ret="0^1-没权限"
	q ret
}

/// 根据安全组ID取评估标准
/// UserGroupId--用户安全组ID
ClassMethod GetRuleDicByUserGroup(UserGroupId)
{
	n (UserGroupId)
	s ret=""
	
	s RuleRowid=0
	f  s RuleRowid=$o(^DHCWMRRDIC(RuleRowid)) q:RuleRowid=""  d
	.s RulePower=..GetRulePower(RuleRowid,UserGroupId)
	.q:RulePower<1
	.s TMP=RuleRowid_"^"_RulePower_"-"_$P($g(^DHCWMRRDIC(RuleRowid)),"^",2)
	.s ret=ret_"$"_TMP
	
	s:ret'="" ret=$e(ret,2,$l(ret))
	q ret
}

ClassMethod GetExamRuleByRuleDic(RuleRowid)
{
	n (RuleRowid)
	s ret=""
	
	;^DHCWMRER(0,"RuleActive",{RuleDr},{IsActive},{Rowid})
	q:'$d(^DHCWMRER(0,"RuleActive",+RuleRowid,"Y"))
	s ExamRuleRowid=0
	f  s ExamRuleRowid=$o(^DHCWMRER(0,"RuleActive",+RuleRowid,"Y",ExamRuleRowid)) q:ExamRuleRowid=""  d
	.s tmpExamRule=$g(^DHCWMRER(ExamRuleRowid))
	.q:tmpExamRule=""
	.s TMP=ExamRuleRowid_"^"_$P(tmpExamRule,"^",9)
	.s ret=ret_"$"_TMP
	
	s:ret'="" ret=$e(ret,2,$l(ret))
	q ret
}

ClassMethod QueryExamRuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryExamRuleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryExamRuleExecute(ByRef qHandle As %Binary, IsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s ExamRuleID=0
	f  s ExamRuleID=$o(^DHCWMRER(ExamRuleID)) q:ExamRuleID=""  d
	.s tmpExamRule=$g(^DHCWMRER(ExamRuleID))
	.q:(IsActive'="")&&($p(tmpExamRule,"^",8)'=IsActive)
	.s ExamRuleDesc=$p(tmpExamRule,"^",9)
	.s RuleID=$p(tmpExamRule,"^",1)
	.s RuleCode=$p($g(^DHCWMRRDIC(+RuleID)),"^",1)
	.s RuleDesc=$p($g(^DHCWMRRDIC(+RuleID)),"^",2)
	.s Data=$lb(ExamRuleID,RuleCode,RuleDesc,ExamRuleDesc)
    .s ^CacheTemp(repid,ind)=Data
    .s ind=ind+1
	Quit $$$OK
}

ClassMethod QueryExamRuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryExamRuleExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 取评估标准列表
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.ExExamPower","QueryExamRule","Y")
Query QueryExamRule(IsActive As %String) As %Query(ROWSPEC = "ExamRuleID:%String,RuleCode:%String,RuleDesc:%String,ExamRuleDesc")
{
}

}
