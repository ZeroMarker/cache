Import SQLUser

/// 评估体系存取方法
Class web.DHCWMRRuleComplexCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 18;

/// 存 5 评估体系 DHC_WMR_RuleComplex
ClassMethod UpdateRuleComplex(Instring)
{
    n (Instring)
    s ret=""  
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateRuleComplex^DHCWMRRuleComplex(Instring)
	zn CurrentNS
	q ret
}

/// 存 5.1 评估体系内容 DHC_WMR_RuleComplexDtl
ClassMethod UpdateRuleComplexDtl(Instring)
{
    n (Instring)
    s ret=""
    s ExamRuleDr=+$p(Instring,"^",3)
    q:'$d(^DHCWMRER(ExamRuleDr)) -1
    
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    s ret=$$UpdateRuleComplexDtl^DHCWMRRuleComplex(Instring)
	zn CurrentNS
	q ret
}

/// 取 5 评估体系 DHC_WMR_RuleComplex
ClassMethod ByIdGetRuleComplex(RCRowid)
{
	n (RCRowid)
	
	s retString=##class(web.DHCWMRQualityBaseCtl).GetRCById(RCRowid)
	q retString
	/*
	s retString=""
    q:'$d(^DHCWMRRC(+RCRowid)) retString
	
	s retString=$g(^DHCWMRRC(+RCRowid))
	s retString=+RCRowid_"^"_retString
	s:$p(retString,"^",4)'="" $p(retString,"^",4)=$s($p(retString,"^",4)["Y":"Yes",1:"No")
	q retString
	*/
}

/// 取 5.1 评估体系内容 DHC_WMR_RuleComplexDtl
ClassMethod ByIdGetRComplexDtl(RCDtlRowid)
{
	n (RCDtlRowid)
	
	s retString=##class(web.DHCWMRQualityBaseCtl).GetRCDById(RCDtlRowid)
	
	i retString'="" d
	.;DHC_WMR_ExamRule
	.s ExamRuleDr=$p(retString,"^",2)
	.s ExamRule=##class(web.DHCWMRQualityBaseCtl).GetERById(ExamRuleDr)
	.i ExamRule'="" d
	..;DHC_WMR_RuleDic
	..s tmpRuleDicDr=$p(ExamRule,"^",2)
	..s tmpRuleDic=##class(web.DHCWMRQualityBaseCtl).GetDicRById(tmpRuleDicDr)
	.s ExamRule=ExamRule_$c(2)_$g(tmpRuleDic)
	.s retString=retString_$c(2)_ExamRule
	q retString
	/*
	s retString=""
	s RCRowid=+RCDtlRowid
	s RCDtlSub=$p(RCDtlRowid,"||",2)
    q:'$d(^DHCWMRRC(+RCRowid,"D",RCDtlSub)) retString
	
	s retString=$g(^DHCWMRRC(+RCRowid,"D",RCDtlSub))
	s retString=RCDtlRowid_"^"_retString
	s:$p(retString,"^",4)'="" $p(retString,"^",4)=$s($p(retString,"^",4)["Y":"Yes",1:"No")
	
	;^DHCWMRER({Rowid})
	s ExamRuleDr=$p(retString,"^",2)
	i ExamRuleDr'="" d
	.s ExamRuleDr=+ExamRuleDr
	.s ExamRule=ExamRuleDr_"^"_$g(^DHCWMRER(ExamRuleDr))
	.;^DHCWMRRDIC({Rowid})
	.s RuleDicDr=+$p(ExamRule,"^",2)
	.s:RuleDicDr'=0 RuleDic=RuleDicDr_"^"_$g(^DHCWMRRDIC(RuleDicDr))
	s ExamRule=$g(ExamRule)_$c(2)_$g(RuleDic)
	
	s retString=retString_$c(2)_$g(ExamRule)
	q retString
	*/
}

}
