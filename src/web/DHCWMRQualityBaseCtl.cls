Import SQLUser

/// 质控字典存取方法
Class web.DHCWMRQualityBaseCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 29;

/// 取 1 质控标准字典 DHC_WMR_RuleDic
ClassMethod GetDicRById(RDRowid)
{
	;w ##class(web.DHCWMRQualityBaseCtl).GetDicRById("")
    n (RDRowid)
    s ret=""
    q:'$d(^DHCWMRRDIC(+RDRowid)) ret
    
    s ret=$g(^DHCWMRRDIC(+RDRowid))
    s ret=+RDRowid_"^"_ret
    s:$p(ret,"^",5)'="" $p(ret,"^",5)=$s($p(ret,"^",5)["Y":"Yes",1:"No")
    q ret
}

/// 取 2 质控大类字典 DHC_WMR_SectionDic
ClassMethod GetDicSById(SDRowid)
{
	;w ##class(web.DHCWMRQualityBaseCtl).GetDicSById("")
    n (SDRowid)
    s ret=""
    q:'$d(^DHCWMRSDIC(+SDRowid)) ret
    
    s ret=$g(^DHCWMRSDIC(+SDRowid))
    s ret=+SDRowid_"^"_ret
    s:$p(ret,"^",5)'="" $p(ret,"^",5)=$s($p(ret,"^",5)["Y":"Yes",1:"No")
    q ret
}

/// 取 3 质控项目字典 DHC_WMR_EntryDic
ClassMethod GetDicEById(EDRowid)
{
	;w ##class(web.DHCWMRQualityBaseCtl).GetDicEById("")
    n (EDRowid)
    s ret=""
    q:'$d(^DHCWMREDIC(+EDRowid)) ret
    
    s ret=$g(^DHCWMREDIC(+EDRowid))
    s ret=+EDRowid_"^"_ret
    s:$p(ret,"^",5)'="" $p(ret,"^",5)=$s($p(ret,"^",5)["Y":"Yes",1:"No")
    q ret
}

/// 取 4 评估标准 DHC_WMR_ExamRule
ClassMethod GetERById(ERRowid)
{
	;w ##class(web.DHCWMRQualityBaseCtl).GetERById("")
	n (ERRowid)
	s ret=""
    q:'$d(^DHCWMRER(+ERRowid)) ret
	
	s ret=$g(^DHCWMRER(+ERRowid))
	s ret=+ERRowid_"^"_ret
	s ScoreMethod=$p(ret,"^",8)
	s:ScoreMethod["A" ScoreMethod="Add"
	s:ScoreMethod["R" ScoreMethod="Reduce"
	s:$p(ret,"^",8)'="" $p(ret,"^",8)=ScoreMethod
	s:$p(ret,"^",9)'="" $p(ret,"^",9)=$s($p(ret,"^",9)["Y":"Yes",1:"No")
	q ret
}

/// 取 4.1 评估大类 DHC_WMR_ExamSection
ClassMethod GetESById(ESRowid)
{
	;w ##class(web.DHCWMRQualityBaseCtl).GetESById("")
	n (ESRowid)
	s ret=""
	s ERRowid=+ESRowid
	s ESSub=$p(ESRowid,"||",2)
	q:ESSub="" ret
    q:'$d(^DHCWMRER(ERRowid,"S",ESSub)) ret
	
	s ret=$g(^DHCWMRER(ERRowid,"S",ESSub))
	s ret=ESRowid_"^"_ret
	s:$p(ret,"^",5)'="" $p(ret,"^",5)=$s($p(ret,"^",5)["Y":"Yes",1:"No")
	
	q ret
}

/// 取 4.1.1 评估项目 DHC_WMR_ExamEntry
ClassMethod GetEEById(EERowid)
{
	;w ##class(web.DHCWMRQualityBaseCtl).GetEEById("")
	n (EERowid)
	s ret=""
	s ERRowid=+EERowid
	s ESSub=$p(EERowid,"||",2)
	s EEChl=$p(EERowid,"||",3)
	q:((ESSub="")||(EEChl="")) ret
    q:'$d(^DHCWMRER(+ERRowid,"S",ESSub,"E",EEChl)) ret
	
	s ret=$g(^DHCWMRER(ERRowid,"S",ESSub,"E",EEChl))
	s ret=EERowid_"^"_ret
	s:$p(ret,"^",6)'="" $p(ret,"^",6)=$s($p(ret,"^",6)["Y":"Yes",1:"No")
	s:$p(ret,"^",7)'="" $p(ret,"^",7)=$s($p(ret,"^",7)["Y":"Yes",1:"No")
	s:$p(ret,"^",11)'="" $p(ret,"^",11)=$s($p(ret,"^",11)["Y":"Yes",1:"No")
	
	;by wuqk 2007-12-10 for Expression
	s:$p(ret,"^",13)="" $p(ret,"^",13)=""
	
	
	q ret
}

/// 取 4.2 评估等级 DHC_WMR_ExamGarde
ClassMethod GetEGById(EGRowid)
{
	;w ##class(web.DHCWMRQualityBaseCtl).GetEGById("")
	n (EGRowid)
	s ret=""
	s ERRowid=+EGRowid
	s EGSub=$p(EGRowid,"||",2)
	q:EGSub="" ret
    q:'$d(^DHCWMRER(ERRowid,"G",EGSub)) ret
	
	s ret=$g(^DHCWMRER(ERRowid,"G",EGSub))
	s ret=EGRowid_"^"_ret
	s:$p(ret,"^",4)'="" $p(ret,"^",4)=$s($p(ret,"^",4)["Y":"Yes",1:"No")
	q ret
}

/// 取 5 评估体系 DHC_WMR_RuleComplex
ClassMethod GetRCById(RCRowid)
{
	;w ##class(web.DHCWMRQualityBaseCtl).GetRCById("")
	n (RCRowid)
	s ret=""
    q:'$d(^DHCWMRRC(+RCRowid)) ret
	
	s ret=$g(^DHCWMRRC(+RCRowid))
	s ret=+RCRowid_"^"_ret
	s:$p(ret,"^",4)'="" $p(ret,"^",4)=$s($p(ret,"^",4)["Y":"Yes",1:"No")
	q ret
}

/// 取 5.1 评估体系内容 DHC_WMR_RuleComplexDtl
ClassMethod GetRCDById(RCDRowid)
{
	;w ##class(web.DHCWMRQualityBaseCtl).GetRCDById("")
	n (RCDRowid)
	s ret=""
	s RCRowid=+RCDRowid
	s RCDSub=$p(RCDRowid,"||",2)
	q:RCDSub="" ret
    q:'$d(^DHCWMRRC(RCRowid,"D",RCDSub)) ret
	
	s ret=$g(^DHCWMRRC(RCRowid,"D",RCDSub))
	s ret=RCDRowid_"^"_ret
	s:$p(ret,"^",4)'="" $p(ret,"^",4)=$s($p(ret,"^",4)["Y":"Yes",1:"No")
	q ret
}

/// 取 6 评估结果 DHC_WMR_ExamResult
ClassMethod GetExRById(ExRRowid)
{
	;w ##class(web.DHCWMRQualityBaseCtl).GetExRById("")
	n (ExRRowid)
	s ret=""
    q:'$d(^DHCWMRERST(+ExRRowid)) ret
	
	s ret=$g(^DHCWMRERST(+ExRRowid))
	s ret=+ExRRowid_"^"_ret
	s:$p(ret,"^",4)'="" $p(ret,"^",4)=$s($p(ret,"^",4)["Y":"Yes",1:"No")
	s:$p(ret,"^",7)'="" $p(ret,"^",7)=$s($p(ret,"^",7)["Y":"Yes",1:"No")
	s:$p(ret,"^",9)'="" $p(ret,"^",9)=$s($p(ret,"^",9)["Y":"Yes",1:"No")
	s:$p(ret,"^",12)'="" $p(ret,"^",12)=$zd($p(ret,"^",12),3)   ;评估日期(2007-01-01)
	s:$p(ret,"^",13)'="" $p(ret,"^",13)=$zt($p(ret,"^",13),2)   ;评估时间(10:10)
	s:$p(ret,"^",14)'="" $p(ret,"^",14)=$s($p(ret,"^",14)["Y":"Yes",1:"No")
	s:$p(ret,"^",16)="" $p(ret,"^",16)=""
	i $p(ret,"^",17)["M" d
	.s $p(ret,"^",17)="Middle"
	e  d
	.s $p(ret,"^",17)="Final"
	q ret
}

/// 通过病案卷的RowID获得评估结果（如果评价多次就是一个列表）
/// Create By LiYang 2008-10-29
ClassMethod GetExamResultByVolID(RuleID, VolumeID)
{
	n (RuleID, VolumeID)
	set ret = ""
	quit:VolumeID="" ret
	set RowID = ""
	while 1
	{
		set RowID = $o( ^DHCWMRERST(0,"RuleVol", RuleID, VolumeID, RowID))
		quit:RowID=""
		set ret = ret _ ..GetExRById(+RowID)
		set:ret'="" ret = ret _ $c(1)
	}
	quit ret
}

/// 取 6.1 评估结果项目内容 DHC_WMR_ExamRDtl
ClassMethod GetExRDById(ExRDRowid)
{
	;w ##class(web.DHCWMRQualityBaseCtl).GetExRDById("")
	n (ExRDRowid)
	s ret=""
	s ExRRowid=+ExRDRowid
	s ExRDSub=$p(ExRDRowid,"||",2)
	q:ExRDSub="" ret
    q:'$d(^DHCWMRERST(ExRRowid,"D",ExRDSub)) ret
	
	s ret=$g(^DHCWMRERST(ExRRowid,"D",ExRDSub))
	s ret=ExRDRowid_"^"_ret
	s:$p(ret,"^",6)'="" $p(ret,"^",6)=$zd($p(ret,"^",6),3)   ;触发日期（2007-01-01）
	s:$p(ret,"^",8)'="" $p(ret,"^",8)=$s($p(ret,"^",8)["Y":"Yes",1:"No")
	q ret
}

/// 取 6.1.1 评估项目 DHC_WMR_ExamRDtlPeople
ClassMethod GetExRDPById(ExRDPRowid)
{
	;w ##class(web.DHCWMRQualityBaseCtl).GetExRDPById("")
	n (ExRDPRowid)
	s ret=""
	s ExRRowid=+ExRDPRowid
	s ExRDSub=$p(ExRDPRowid,"||",2)
	s ExRDPChl=$p(ExRDPRowid,"||",3)
	q:((ExRDSub="")||(ExRDPChl="")) ret
    q:'$d(^DHCWMRERST(ExRRowid,"D",ExRDSub,"P",ExRDPChl)) ret
	
	s ret=$g(^DHCWMRERST(ExRRowid,"D",ExRDSub,"P",ExRDPChl))
	s ret=ExRDPRowid_"^"_ret
	s:$p(ret,"^",5)'="" $p(ret,"^",5)=$s($p(ret,"^",5)["Y":"Yes",1:"No")
	q ret
}

/// 取 DHC_WMR_Dictionary
ClassMethod GetDicById(DicRowid)
{
	;w ##class(web.DHCWMRQualityBaseCtl).GetDicById("")
	n (DicRowid)
	s ret=""
    q:'$d(^DHCWMRDIC(+DicRowid)) ret
	
	s ret=$g(^DHCWMRDIC(+DicRowid))
	s ret=+DicRowid_"^"_ret
	s:$p(ret,"^",5)'="" $p(ret,"^",5)=$zd(+$p(ret,"^",5),3)  ;生效日期
	s:$p(ret,"^",6)'="" $p(ret,"^",6)=$zd(+$p(ret,"^",6),3)  ;废止日期
	s:$p(ret,"^",11)'="" $p(ret,"^",11)=$s($p(ret,"^",11)["Y":"Yes",1:"No")
	q ret
}

/// 取 DHC_WMR_MainVolume
ClassMethod GetVolById(VolRowid)
{
	;w ##class(web.DHCWMRQualityBaseCtl).GetVolById("")
	n (VolRowid)
	s ret=""
    q:'$d(^DHCWMRVOL(+VolRowid)) ret
	
	s ret=$g(^DHCWMRVOL(+VolRowid))
	s ret=+VolRowid_"^"_ret
	s:$p(ret,"^",5)'="" $p(ret,"^",5)=$s($p(ret,"^",5)["Y":"Yes",1:"No")
	s:$p(ret,"^",6)'="" $p(ret,"^",6)=$s($p(ret,"^",6)["Y":"Yes",1:"No")
	s:$p(ret,"^",8)'="" $p(ret,"^",8)=$s($p(ret,"^",8)["Y":"Yes",1:"No")
	s:$p(ret,"^",9)'="" $p(ret,"^",9)=$s($p(ret,"^",9)["Y":"Yes",1:"No")
	q ret
}

}
