/// creator:周闯
/// date:2022-09-14
/// desc:医生站设置程序->诊断设置->复诊规则配置-复诊规则操作
Class DHCDoc.DHCDocConfig.ReAdmRulesSet Extends DHCDoc.Util.RegisteredObject
{

/// creator:周闯
/// date:2022-09-14
/// desc:复诊规则设置-保存规则
/// w ##class(DHCDoc.DHCDocConfig.ReAdmRulesSet).Save("")
ClassMethod Save(inPara As %String) As %String
{
    s $zt="SaveErr"
    s CheckRtn=..BeforeSave(inPara,.ParamArr)
    q:CheckRtn'="0" CheckRtn
    
    s RuleRowId=ParamArr("RuleRowId")
    s RuleTitle=ParamArr("RuleTitle")
    s RuleDays=ParamArr("RuleDays")
    s RuleByCode=ParamArr("RuleByCode")
    s RuleMainDiagFlag=ParamArr("RuleMainDiagFlag")
    s RuleHosp=ParamArr("RuleHosp")
    s RuleIsDefault=ParamArr("RuleIsDefault")
    if RuleRowId="" {
        s SaveOBJ = ##class(User.DHCDocReAdmRulesSet).%New()
    }else{
        s SaveOBJ = ##class(User.DHCDocReAdmRulesSet).%OpenId(RuleRowId)
    }
	s SaveOBJ.RARTitle=RuleTitle
	d SaveOBJ.RARHospDrSetObjectId(RuleHosp)
	s SaveOBJ.RARJudgeDays=RuleDays
	s SaveOBJ.RARJudgeBy=RuleByCode
	s SaveOBJ.RARJudgeByMainDiaFlag=RuleMainDiagFlag
    s SaveOBJ.RARIsDefault=RuleIsDefault
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		q "-1^保存复诊规则失败！"
	}
    q "0^保存成功"
SaveErr
    s $zt=""
    q "-1^"_$ze
}

/// creator:周闯
/// date:2022-09-14
/// desc:复诊规则设置-保存规则前处理 数据解析和判断
/// w ##class(DHCDoc.DHCDocConfig.ReAdmRulesSet).BeforeSave("")
ClassMethod BeforeSave(inPara As %String, ByRef ParamArr As %String) As %String
{
    d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(inPara,.ParamArr)
    s RuleRowId=$g(ParamArr("RuleRowId"))
    s RuleTitle=$g(ParamArr("RuleTitle"))
    s RuleDays=$g(ParamArr("RuleDays"))
    s RuleByCode=$g(ParamArr("RuleByCode"))
    s RuleMainDiagFlag=$g(ParamArr("RuleMainDiagFlag"))
    s RuleHosp=$g(ParamArr("RuleHosp"))
    s RuleIsDefault=$g(ParamArr("RuleIsDefault"))
    
    if (RuleTitle=""){
        q "-1^规则名称不可为空"
    }
    if (RuleDays=""){
        q "-1^判断天数不可为空"
    }

    if (RuleByCode=""){
        q "-1^判断依据不可为空"
    }

    if (RuleHosp=""){
        q "-1^院区不可为空"
    }

    //唯一性校验
    s RuleStr=RuleTitle_"^"_RuleDays_"^"_RuleByCode_"^"_RuleMainDiagFlag_"^"_RuleIsDefault

    if (RuleRowId'=""){
        s OItemStr=$lts(^User.DHCDocReAdmRulesSetD(RuleRowId),"^")
        s OItemStr=$p(OItemStr,"^",2,5)
        q:RuleStr=OItemStr "-1^未作修改"
    }
    s RuleStr=$p(RuleStr,"^",2,4)

    s CheckStr="",DefaultRuleStr=""
    s RuleDr=0
    f {
        s RuleDr=$o(^User.DHCDocReAdmRulesSetD(RuleDr))
        q:RuleDr=""
        continue:RuleDr=RuleRowId
        s ItemHosp=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),6)
        continue:ItemHosp'=RuleHosp
        s ItemTitle=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),2)
        s:ItemTitle=RuleTitle CheckItem="同名规则已存在" , CheckStr=$s(CheckStr="":CheckItem,1:CheckStr_";"_CheckItem)
        s ItemStr=$lts(^User.DHCDocReAdmRulesSetD(RuleDr),"^")
        s ItemStr=$p(ItemStr,"^",3,5)
        s ItemIsDefault=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),7)
        s:ItemStr=RuleStr CheckItem="相同规则内容已存在:"_ItemTitle , CheckStr=CheckItem
        s:(ItemIsDefault="Y")&&(RuleIsDefault="Y") DefaultRuleStr=ItemTitle
    }
    if (DefaultRuleStr'=""){
        s UnableDefault="当前默认规则为:"_DefaultRuleStr_" 不可再设置默认规则" 
        s CheckStr=$s(CheckStr="":UnableDefault,1:CheckStr_";"_UnableDefault)
    }
    q:CheckStr'="" "-1^"_CheckStr
    q "0"
}

/// creator:周闯
/// date:2022-09-14
/// desc:复诊规则设置-删除规则
/// w ##class(DHCDoc.DHCDocConfig.ReAdmRulesSet).BeforeSave("")
ClassMethod Delete(RuleID As %String)
{
    s CheckRtn=..BeforeDelete(RuleID)
    q:CheckRtn'="0" CheckRtn
    
    &sql(delete from SQLUser.DHCDocReAdmRulesSet where ID=:RuleID)
    q SQLCODE
}

/// creator:周闯
/// date:2022-09-14
/// desc:复诊规则设置-删除规则前判断
/// w ##class(DHCDoc.DHCDocConfig.ReAdmRulesSet).BeforeSave("")
ClassMethod BeforeDelete(RuleID As %String)
{
    s FindFlag="0"
    s LocRuleDr=0
    f {
        s LocRuleDr=$o(^User.DHCDocReAdmRulesLocD(LocRuleDr))
        q:LocRuleDr=""
        s RuleDr=$lg(^User.DHCDocReAdmRulesLocD(LocRuleDr),2)
        if (RuleDr=RuleID){
            s FindFlag="1"
            q
        }
    }
    q:FindFlag="1" "存在科室设定了该规则,请先解除设定"
    q "0"
}

/// creator:周闯
/// date:2022-09-14
/// desc:复诊规则设置-规则列表
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ReAdmRulesSet","RuleList",2)
Query RuleList(HospId As %String, Desc As %String = "") As %Query(ROWSPEC = "RuleRowId:%String,RuleTitle:%String,RuleDays:%String,RuleByCode:%String,RuleByDesc:%String,RuleMainDiagFlag:%String,RuleIsDefault:%String")
{
}

ClassMethod RuleListExecute(ByRef qHandle As %Binary, HospId As %String, Desc As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
    s Index=1
    s RuleDr=0
    f {
        s RuleDr=$o(^User.DHCDocReAdmRulesSetD(RuleDr))
        q:RuleDr=""
        s ItemHosp=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),6)
        continue:ItemHosp'=HospId
        s ItemTitle=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),2)
        continue:(Desc'="")&&(ItemTitle'[Desc)
        s ItemDays=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),3)
        s ItemByCode=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),4)
        s ItemMainDiagFlag=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),5)
        s RuleIsDefault=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),7)
        s ItemByDesc=$case(ItemByCode,
            "DIA":"诊断数据",
            "ADM":"就诊记录"
        )
        s ^CacheTemp(repid,Index)=$lb(RuleDr,ItemTitle,ItemDays,ItemByCode,ItemByDesc,ItemMainDiagFlag,RuleIsDefault)
        s Index=Index+1
    }
    
	Quit $$$OK
}

ClassMethod RuleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RuleListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod RuleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RuleListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		Set AtEnd=1
		Set Row=""
	}Else{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRuleDetail(RuleID As %String)
{
    s DetailStr=""
    q:RuleID="" DetailStr
    
    s Title=$lg(^User.DHCDocReAdmRulesSetD(RuleID),2)
    s Days=$lg(^User.DHCDocReAdmRulesSetD(RuleID),3)
    s ByCode=$lg(^User.DHCDocReAdmRulesSetD(RuleID),4)
    s MainDiagFlag=$lg(^User.DHCDocReAdmRulesSetD(RuleID),5)
    s HospID=$lg(^User.DHCDocReAdmRulesSetD(RuleID),6)
    s IsDefault=$lg(^User.DHCDocReAdmRulesSetD(RuleID),7)

    s ByDesc=$case(ByCode,
        "DIA":"诊断数据",
        "ADM":"就诊记录"
    )
    s DetailStr=Title_"^"_Days_"^"_ByCode_"^"_ByDesc_"^"_MainDiagFlag_"^"_HospID_"^"_IsDefault
    
    q DetailStr
}

}
