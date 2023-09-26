/// creator:周闯
/// date:2022-09-14
/// desc:医生站设置程序->诊断设置->复诊规则配置-复诊规则关联
Class DHCDoc.DHCDocConfig.ReAdmRules Extends DHCDoc.Util.RegisteredObject
{

/// creator:周闯
/// date:2022-09-14
/// desc:复诊规则设置-保存规则关联ave
ClassMethod Save(inPara As %String) As %String
{
    s $zt="SaveErr"
    s CheckRtn=..BeforeSave(inPara,.ParamArr)
    q:CheckRtn'="0" CheckRtn

    s LocRuleID=ParamArr("LocRuleID")
    s LocID=ParamArr("LocID")
    s RuleID=ParamArr("RuleID")
    s HospID=ParamArr("HospID")

    if LocRuleID="" {
        s SaveOBJ = ##class(User.DHCDocReAdmRulesLoc).%New()
    }else{
        s SaveOBJ = ##class(User.DHCDocReAdmRulesLoc).%OpenId(LocRuleID)
    }
	d SaveOBJ.RARLRuleSetObjectId(RuleID)
	d SaveOBJ.RARLLocSetObjectId(LocID)
	d SaveOBJ.RARHospDrSetObjectId(HospID)

	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		q "-1^保存失败:"_$System.Status.GetOneStatusText(sc,1)
	}

    q "0^保存成功"
SaveErr
    s $zt=""
    q "-1^"_$ze
}

/// creator:周闯
/// date:2022-09-14
/// desc:复诊规则设置-保存规则前处理 数据解析和判断
/// w ##class(DHCDoc.DHCDocConfig.ReAdmRules).BeforeSave("")
ClassMethod BeforeSave(inPara As %String, ByRef ParamArr As %String) As %String
{
    d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(inPara,.ParamArr)
    s LocRuleID=$g(ParamArr("LocRuleID"))
    s LocID=$g(ParamArr("LocID"))
    s RuleID=$g(ParamArr("RuleID"))
    s HospID=$g(ParamArr("HospID"))
    
    if (LocID=""){
        q "-1^科室不可为空"
    }
    if (RuleID=""){
        q "-1^规则不可为空"
    }

    if (HospID=""){
        q "-1^院区不可为空"
    }

    //插入-唯一性校验
    if (LocRuleID=""){
        s FindLocRuleStr=""
        s rs=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.ReAdmRules:LocRuleList")
	    i rs.QueryIsValid() {
            s Status=rs.Execute(HospID,LocID,"")
            If Status {
                While rs.Next() {
                    s FindLocRuleDr=rs.Get("LocRuleId")
                    s FindLocRuleTitle=rs.Get("RuleTitle")
                    s FindLocRuleStr=FindLocRuleDr_"^"_FindLocRuleTitle
                    Quit
                }
            }
        }
        q:FindLocRuleStr'="" "-1^该科室已设定规则: "_$p(FindLocRuleStr,"^",2)
    }else{
        s RuleDr=$lg(^User.DHCDocReAdmRulesLocD(LocRuleID),2)
        s LocDr=$lg(^User.DHCDocReAdmRulesLocD(LocRuleID),3)
        s HospDr=$lg(^User.DHCDocReAdmRulesLocD(LocRuleID),4)
        q:((RuleDr_"^"_LocDr_"^"_HospDr)=(LocID_"^"_RuleID_"^"_HospID)) "-1^未作修改"
    }
    
    q "0"
}

/// creator:周闯
/// date:2022-09-14
/// desc:复诊规则设置-删除记录
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ReAdmRules","Delete",2)
ClassMethod Delete(LocRuleID As %String)
{
	&sql(delete from SQLUser.DHCDocReAdmRulesLoc where ID=:LocRuleID)
    q SQLCODE
}

/// creator:周闯
/// date:2022-09-14
/// desc:复诊规则设置-科室:规则列表
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.ReAdmRulesSet","RuleList",2)
Query LocRuleList(HospID As %String, LocID As %String, RuleID As %String) As %Query(ROWSPEC = "LocRuleId:%String,LocId:%String,LocDesc:%String,RuleRowId:%String,RuleTitle:%String,RuleDays:%String,RuleByCode:%String,RuleByDesc:%String,RuleMainDiagFlag:%String")
{
}

ClassMethod LocRuleListExecute(ByRef qHandle As %Binary, HospID As %String, LocID As %String, RuleID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
    s Index=1
    s LocRuleDr=0
    f {
        s LocRuleDr=$o(^User.DHCDocReAdmRulesLocD(LocRuleDr))
        q:LocRuleDr=""
        s LocDr=$lg(^User.DHCDocReAdmRulesLocD(LocRuleDr),3)
        continue:(LocID'="")&&(LocID'=LocDr)
        s RuleDr=$lg(^User.DHCDocReAdmRulesLocD(LocRuleDr),2)
        continue:(RuleID'="")&&(RuleID'=RuleDr)
        s HospDr=$lg(^User.DHCDocReAdmRulesLocD(LocRuleDr),4)
        continue:(HospID'="")&&(HospID'=HospDr)

        s LocDesc=$p(^CTLOC(LocDr),"^",2)
        s ItemTitle=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),2)
        s ItemDays=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),3)
        s ItemByCode=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),4)
        s ItemMainDiagFlag=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),5)
        s ItemByDesc=$case(ItemByCode,
            "DIA":"诊断数据",
            "ADM":"就诊记录"
        )
        
        s ^CacheTemp(repid,Index)=$lb(LocRuleDr,LocDr,LocDesc,RuleDr,ItemTitle,ItemDays,ItemByCode,ItemByDesc,ItemMainDiagFlag)
        s Index=Index+1
    }
    
	Quit $$$OK
}

ClassMethod LocRuleListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LocRuleListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod LocRuleListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LocRuleListExecute ]
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

/// creator:周闯
/// date:2022-09-14
/// desc:复诊规则设置-获取科室配置详情,若科室未配置,则取院区的默认规则,否则返回空
/// d ##class(DHCDoc.DHCDocConfig.ReAdmRules).GetLocRuleDetail()
ClassMethod GetLocRuleDetail(LocID As %String, HospID As %String = "")
{
    s RuleDetail=""
    s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    s:HospID="" HospID=##class(DHCDoc.Common.Hospital).GetLocHospitalId(LocID)
    s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHCDocReAdmRulesLoc",HospID)

    s RuleID=""
    s LocRuleDr=0
    f {
        s LocRuleDr=$o(^User.DHCDocReAdmRulesLocD(LocRuleDr))
        q:(LocRuleDr="")||(RuleID'="")
        s LocDr=$lg(^User.DHCDocReAdmRulesLocD(LocRuleDr),3)
        continue:(LocID'="")&&(LocID'=LocDr)
        s HospDr=$lg(^User.DHCDocReAdmRulesLocD(LocRuleDr),4)
        continue:(HospID'="")&&(HospID'=HospDr)
        s RuleID=$lg(^User.DHCDocReAdmRulesLocD(LocRuleDr),2)
    }

    if (RuleID=""){
        s RuleDr=0
        f {
            s RuleDr=$o(^User.DHCDocReAdmRulesSetD(RuleDr))
            q:RuleDr=""
            s ItemHosp=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),6)
            continue:(HospID'="")&&(HospID'=ItemHosp)
            s ItemIsDefault=$lg(^User.DHCDocReAdmRulesSetD(RuleDr),7)
            continue:ItemIsDefault'="Y"
            s RuleID=RuleDr
        }
    }
    s:RuleID'="" RuleDetail=##class(DHCDoc.DHCDocConfig.ReAdmRulesSet).GetRuleDetail(RuleID)
    //默认按照所有就诊记录判断
    //s LocRuleDetail=Title_"^"_Days_"^"_ByCode_"^"_ByDesc_"^"_MainDiagFlag_"^"_HospID_"^"_IsDefault
    s:RuleDetail="" RuleDetail="默认按照所有就诊记录判断"_"^"_"0"_"^"_"ADM"_"^"_""_"^"_""_"^"_HospID_"^"_""
    
    q RuleDetail
}

/// creator:周闯
/// date:2022-09-14
/// desc:判断患者是否是复诊患者,判断规则:科室规则>默认规则>按所有就诊记录
/// para: json字符串 或者 %ArrayOfDataTypes
///         PatientID:登记id        EpisodeID:就诊id (PatientID,EpisodeID 不可同时为空)
///         LocID:判断就诊科室(可空)       HospID:判断院区(可空,取session)
///         DIAICDr:按诊断规则时,判断的ICD诊断      CheckDate:判断日期
/// 规则说明:1.判断复诊有两个点 挂号 和 开诊断
///         2.按就诊记录判断时,会判断设置的天数内是否有传入科室的有效就诊
///         3.按诊断记录判断时, 挂号默认按初诊,录入诊断后判断设置天数内的就诊日期中是否有对应历史诊断,可跨科室
/// w ##class(DHCDoc.DHCDocConfig.ReAdmRules).GetReAdmFlag()
ClassMethod GetReAdmFlag(inPara)
{
    s flag="0"
    s $zt="GetReAdmFlagErr"
    if $ISOBJECT(inPara){
        s PatientID=inPara.GetAt("PatientID")
        s EpisodeID=inPara.GetAt("EpisodeID")
        s LocID=inPara.GetAt("LocID")
        s HospID=inPara.GetAt("HospID")
        s DiaICDDr=inPara.GetAt("DiaICDDr")
        s CheckDate=inPara.GetAt("CheckDate")
    }else{
        d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(inPara,.ParamArr)
        s PatientID=$g(ParamArr("PatientID"))
        s EpisodeID=$g(ParamArr("EpisodeID"))
        s LocID=$g(ParamArr("LocID"))
        s HospID=$g(ParamArr("HospID"))
        s DiaICDDr=$g(ParamArr("DIAICDr"))
        s CheckDate=$g(ParamArr("CheckDate"))
    }
    s:CheckDate="" CheckDate=+$h
    s:(PatientID="")&&(EpisodeID'="") PatientID=$p(^PAADM(EpisodeID),"^",1)
    q:PatientID="" flag
    s SessionStr=..%SessionStr()
    s:LocID="" LocID=$p(SessionStr,"^",3)
    s:HospID="" HospID=$p(SessionStr,"^",4)
    s:HospID="" HospID=##class(DHCDoc.Common.Hospital).GetLocHospitalId(LocID)
    s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    s LocRuleDetail=..GetLocRuleDetail(LocID,HospID)
    q:LocRuleDetail="" flag

    s RuleByCode=$p(LocRuleDetail,"^",3)
    s RuleDays=+$p(LocRuleDetail,"^",2)
    s MainDiagFlag=$p(LocRuleDetail,"^",5)
    q:(DiaICDDr="")&&(RuleByCode="DIA") flag
    s Adm=""
    f {
        s Adm=$o(^PAPERdr(PatientID,"ADM","O",Adm),-1)
        q:(Adm="")||(flag="1")
        continue:(EpisodeID'="")&&(EpisodeID=Adm)
        s VisitStatus=$p($g(^PAADM(Adm)),"^",20)
        continue:VisitStatus'="A"
        s AdmDate=$p($g(^PAADM(Adm)),"^",6)
        s DateDur=CheckDate-AdmDate
        continue:(RuleDays'=0)&&(RuleDays<DateDur)
        
        d $CASE(RuleByCode,
            "DIA":RuleByDIA,
            "ADM":RuleByADM
        )
    }
    q flag
RuleByDIA
    //按诊断判断规则:患者挂号默认是初诊,当录入诊断后,根据诊断调整是否复诊
    s Params=##class(%ArrayOfDataTypes).%New()
    d Params.SetAt(Adm,"EpisodeID")
    d Params.SetAt("1","IDCFlag")

    s AdmHosp=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(Adm)
    q:AdmHosp'=HospID

    f ICDInd=1:1:$l(DiaICDDr,","){
        s Item=$p(DiaICDDr,",",ICDInd)
        s ItemICDDr=$p(Item,"!",1)
        s ItemMainFlag=$p(Item,"!",2)
        s:ItemMainFlag'="1" ItemMainFlag=""
        ;规则判断主诊断时,需要将是否是主诊断明确标出
        s:(MainDiagFlag="Y")&&(ItemMainFlag="") ItemMainFlag="0"
        d Params.SetAt(ItemMainFlag,"MainFlag")
        continue:ItemICDDr=""
        d Params.SetAt(ItemICDDr,"ICDCodeID")
        s AdmHaveDiag=##class(web.DHCDocDiagnosEntryV8).CheckAdmHaveDiag(Params)
        if (AdmHaveDiag="1"){
            s flag="1"
            q
        }
    }
    q
RuleByADM
    //按就诊记录判断规则:根据就诊记录时长判断挂号默认是否复诊,后期不做判断
    s AdmLoc=$P(^PAADM(Adm),"^",4)
    q:(LocID'="")&&(LocID'=AdmLoc)
    s flag="1"
    q
GetReAdmFlagErr
    s $zt=""
    q "0"
}

}
