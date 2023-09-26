/// Creator:lideyuan
/// CreatDate:2020-03-30
/// Description：获取患者模型数据以及处理患者模型相关数据
Class web.CDSS.DiagDecision.RecomSusDiagData Extends %RegisteredObject
{

/// Creator：李得原
/// CreatDate: 2020-03-30
/// Description：把患者模型中的数据转换为对应格式的json
/// Input:info:1.患者主索引和枚举类型拼串 2.类名(枚举类名) 3.获取的字段
/// return:对应格式的json字符串   ExamName   "DH001^te001^1^^^^^^1"
/// w ##class(web.DHCBL.CDSS.PYInterface).ReturnPatientInfoNew("DH001^te001^1^^1^demo^1^内分泌科^Y^检验")
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData("DH001^te001^1^^1^demo^1^内分泌科^Y","既往史","PastDiagnosisName")
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData("DH001^te001^1^^1^demo^1^内分泌科^Y","症状","Duration")
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData("胃肿瘤^胃肿瘤^1^住院^6474^李得原^111^泌尿科^1","药品","DrugName")
ClassMethod ProcessPatientData(PatientInfo As %String, ClassName As %String, FieldName As %String) As %String
{
    s str=""
    s Param=PatientInfo_"^"_ClassName 
 // s PatInfo=##class(web.DHCBL.CDSS.PYInterface).ReturnPatientInfoNew(Param)
    try{
        s PatInfo= ##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(Param)
        s PatInfo=[].%FromJSON(PatInfo)
    }
    catch exp{
        
        return "{"_"""success"""_":"_"""false"""_","_"""info"""_":"_""""_exp.Name_""""_"}"
    }

    if FieldName["^"
    {
        s FieldName=$p(FieldName,"^",1)
    }
    s size=PatInfo.%Size()
    s flag=0 //标记是否含有子json
    for i=0:1:size-1
    {
        s Json=PatInfo.%Get(i)
        s JsonType=PatInfo.%GetTypeOf(i)
        if JsonType="array"             //json串列表是否嵌套列表
        {
            s subsize=Json.%Size()
            for j=0:1:subsize-1
            {
                s subjson=Json.%Get(j)
                s value=subjson.%Get(FieldName)  
                s:str'="" str=$e(str,1,*-1)_"^^"_value_""""
                s:str="" str=""""_value_""""
            }
        }
        elseif JsonType="object"          //列表嵌套对象
        {
            s childstr=""
            if Json.%IsDefined("children")     //此json中是否存在children关键字
            {
                s tempchild=""
                s item=Json.%Get(FieldName)
                s children=Json.%Get("children")
                s subsize=children.%Size()
                k recordTime
                for j=0:1:subsize-1              //遍历children中列表的项目
                {
                    s subjson=children.%Get(j)
                    s childstr=""
                    s Same=""
                    s (tempName,tempTime)=""
                    set iter = subjson.%GetIterator()
                    while iter.%GetNext(.key , .value) 
                    {
                        if key["Name"                   //如果key值包含名称，则记录下来
                        {
                            s tempName=value
                        }
                        if key="ReportTime"               //如果key值包含ReportTime，则记录下来
                        {
                            s tempTime=value
                        }
                    }
                    if ((tempName'="")&&(tempTime'=""))
                    {
                        s recordTime(tempName,tempTime)=""            //把Name和ReportTime 字段加入数组中记录下来，这样，当前组
                    }
                }                                                 //的所有项目都会记录，children下面的都记录下来
                
                for j=0:1:subsize-1              //遍历children中列表的项目
                {
                    s subjson=children.%Get(j)
                    s childstr=""
                    s (tempName,tempTime)=""
                    set iter = subjson.%GetIterator()
                    while iter.%GetNext(.key , .value) 
                    {
                        s:childstr'="" childstr=childstr_","_""""_key_""""_":"_""""_value_""""
                        s:childstr="" childstr=""""_key_""""_":"_""""_value_""""
                        if key["Name"                    //如果key值包含Name  ，记录下来当前Name的名称  
                        {
                            s tempName=value
                        }
                        if key="ReportTime"               //如果key值包含ReportTime  ，记录下来ReportTime的值            
                        {
                            s tempTime=value
                        }

                    }
                    if tempName'=""
                    {
                        if $d(recordTime(tempName))        //如果recordTime中存值当前json中的名称
                        {
                            s LastTime=$o(recordTime(tempName,""),-1)     //取出当前名称中，ReportTime的最大值
                            if tempTime'=LastTime                     //看当前名称对应的ReportTime和记录的当前名称最大值是否相等
                            {                                         // 如果不相等，则把拼串删除，本条数据作废，并直接continue
                                k childstr                            
                                continue
                            }
                        }
                    }
                    s:tempchild'="" tempchild=tempchild_",{"_childstr_"}"
                    s:tempchild="" tempchild="{"_childstr_"}"
                }
                
                s:str'="" str=$e(str,1,*-1)_","_""""_item_""""_":"_"["_tempchild_"]}"
                s:str="" str="{"_""""_item_""""_":"_"["_tempchild_"]}"
            }
            else    //如果不存在children关键字
            {
                s value=Json.%Get(FieldName)
                s:str'="" str=$e(str,1,*-1)_"^^"_value_""""
                s:str="" str=""""_value_""""
            }
        }
        else
        {
        
        }
         
    }
    if str=""
    {
        s str=""""_""""
    }
    s result="{"_""""_ClassName _""""_":"_str_"}"
    s result = ##class(web.BDP.util.String).Replace(result,"\","\\")
    q result
}

/// Creator：李得原
/// CreatDate: 2020-03-30
/// Description：通过诊疗规则推荐疑似疾病
/// Input:info:1.患者主索引拼串 
/// return:对应格式的疾病和症状json   
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).GetSuspectedDiseaseByDiagRule("DH001^te001^1^^^^^^1")
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).GetSuspectedDiseaseByDiagRule("DH001^te001^1^^1^demo^1^内分泌科^Y")
ClassMethod GetSuspectedDiseaseByDiagRule(PatientInfo As %String) As %String
{
    //s args={"症状":[[{"症状名称":"发热","部位":"3","group":"1"}],[{"症状名称":"发热","部位":"3","group":"1"}],[{"症状名称":"发热","部位":"3","group":"1"}]]}

    //s args={"症状": "转移性右下腹痛 失明 反应迟钝", "年龄": "20", "检验": {"血常规": {"血白细胞计数": "10001", "中性粒细胞计数": "4000"}}}
    //s args=[].%FromJSON(args)
    d GetSympArr
    //s tempSym=""
    //k disease
    s AllDiseases=""
    //s symall=""
    s MRRowid=0
    for
    {
        s MRRowid=$o(^User.DHCDSSMedicalRuleI("TypeIndex"," CDD00701",MRRowid))
        q:MRRowid=""
        s RuleDisease=$lg($g(^User.DHCDSSMedicalRuleD(MRRowid)),5)
        
        s RuleResult=$lg($g(^User.DHCDSSMedicalRuleD(MRRowid)),10)
        s RuleRange=$lg($g(^User.DHCDSSMedicalRuleD(MRRowid)),12)
        if RuleRange'=""
        {
            s DeptRowid=$o(^User.DHCDSSDeptDictI("CodeIndex"," "_RuleRange,0))
            s DeptDesc=$lg($g(^User.DHCDSSDeptDictD(DeptRowid)),3)
            //s LocId=$g(%session.Data("LOGON.CTLOCID"))
            s LocDesc=$p(PatientInfo,"^",8)
            continue:DeptDesc'=LocDesc
        }
        s RuleICD=$lg($g(^User.DHCDSSMedicalRuleD(MRRowid)),19)
        s RuleWeight=$select(RuleResult="确诊因子":$FNUMBER(0.9,"+"),RuleResult="关键因子":$FNUMBER(0.6,"+"),RuleResult="主要因子":$FNUMBER(0.3,"+"),RuleResult="伴随因子":$FNUMBER(0.1,"+"),1:0)
        s RuleStar=$select(RuleResult="确诊":"三星",RuleResult="关键":"三星",RuleResult="主要":"二星",RuleResult="伴随":"一星",1:0)
        k Matched
        s NumOfAnd=0    //记录一共的and个数
        s RuleGroup=0   //记录规则匹配成功的and个数
        s NumOfOr=0    //标记or
        s LastRTNum=$o(^User.DHCDSSRuleTriggerI("NumIndex",MRRowid,""),-1)
        s RTNum=0
        for
        {
            s RTNum=$o(^User.DHCDSSRuleTriggerI("NumIndex",MRRowid,RTNum))
            q:RTNum=""
            s RTRowid = $o(^User.DHCDSSRuleTriggerI("NumIndex",MRRowid,RTNum,0))
            s RTLogic = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),9)    //and or
            s RTCalculate = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),6)   //运算符
            s RTItemField = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),5)   //InspectionName^LabResultFlag
            s FieldName  = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),7)    //症状名
            s ClassName  = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),4)   //类型编码
            //s RTChild = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),11)   //是否包含子规则
            s RTChild=$d(^User.DHCDSSChildRuleTriggerI("TriggerIndex",RTRowid))
            //s param=PatientInfo_"^"_ClassName 
            s ClassName=##class(web.CDSS.CMKB.BasicsDict).GetBasicsItemName(ClassName)   //类型转为汉字描述
            
            s args=..ProcessPatientData(PatientInfo,ClassName ,RTItemField)
            
            //s args=##class(web.DHCBL.CDSS.PYInterface).ReturnPatientInfoNew(param)
            continue:args=""
            s args=[].%FromJSON(args)
            if args.%Get("success")="false"  //如果解析的json串有错误，则不再往下执行本条规则
            {
                q
            }
            if RTNum'=LastRTNum  //如果是最后一个
            {
                if RTLogic="AND"           //如果逻辑运算符是AND，用NumOfAnd记录一下
                {
                    s NumOfAnd=NumOfAnd+1
                }
            }

            if $d(arr(ClassName))     //把所有的症状都记录下来
            {
                s Matched(MRRowid,FieldName)=""
            }
            
            //"检验": {"血常规": {"血白细胞计数": "10001", "中性粒细胞计数": "4000"}}
            s items=args.%Get(ClassName)  //items={"血常规": {"血白细胞计数": "10001", "中性粒细胞计数": "4000"}    
            continue:items=""
            
            s itemslength=$l(items,"^^")
            for i=1:1:itemslength
            {
                s exp=""
                s item=$p(items,"^^",i)
                continue:item=""

                s exp=""""_item_""""_RTCalculate_""""_FieldName_""""
            
                if @exp   //规则项匹配成功 
                {
                    if RTChild'=0    //如果存在子规则
                    {
                        s NumOfChildOr=0      //子规则中OR的个数
                        s ChildGroup=0   //子规则组
                        s NumOfChildAnd=0  //子规则一共and
                        s CRTNum=0
                        for
                        {
                            s CRTNum=$o(^User.DHCDSSChildRuleTriggerI("ChildNumIndex",RTRowid,CRTNum))
                            q:CRTNum=""
                            s CRTRowid=$o(^User.DHCDSSChildRuleTriggerI("ChildNumIndex",RTRowid,CRTNum,0))
                            s CRTClass=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),5)  //class编码
                            s CRTClass=##class(web.CDSS.CMKB.BasicsDict).GetBasicsItemName(CRTClass)
                            s CRTItemValue=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),8)
                            s CRTCalculate=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),7)   
                            s CRTItem=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),6) 
                            s CRTLogic=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),10)
                            if CRTLogic="AND"    //记录子规则中and的个数
                            {
                                s NumOfChildAnd=NumOfChildAnd+1
                            }
                            s citems=args.%Get(ClassName)
                            continue:citems=""
                            s citemslength=$l(citems,"^^")
                            
                            for i=1:1:citemslength
                            {
                                if $d(arr(CRTClass))     //把子规则中所有的症状(12类)都记录下来
                                {
                                    s Matched(MRRowid,CRTItemValue)=""
                                }
                                s citem=$p(citems,"^^",i)
                                continue:citem=""
                                s cexp=""""_citem_""""_CRTCalculate_""""_CRTItemValue_""""
                                
                                if @cexp            //当前这条子规则匹配成功
                                {
                                    if CRTLogic="OR"
                                    {
                                        s NumOfChildOr=1
                                    }
                                    if CRTLogic="AND"
                                    {
                                        s ChildGroup=ChildGroup+1
                                        s NumOfChildOr=0
                                    }
                                }
                                else        //当前这条子规则匹配不成功
                                {
                                    if NumOfChildOr=1
                                    {
                                        if CRTLogic="AND"     //如果子规则逻辑运算符为AND
                                        {
                                            s ChildGroup=ChildGroup+NumOfChildOr
                                            s NumOfChildOr=0
                                        }
                                        q
                                    }
                                }
                            }
                            
                        }
                        
                        if (ChildGroup+NumOfChildOr)=(NumOfChildAnd+1)
                        {
                            //子规则完全匹配成功
                            if RTLogic="OR"
                            {
                                s NumOfOr=1
                            }
                            if RTLogic="AND"
                            {
                                s RuleGroup=RuleGroup+1
                                s NumOfOr=0
                            }
                        }
                    }
                    else    //规则匹配成功，没有子规则
                    {
                        
                        if RTLogic="OR"
                        {
                            s NumOfOr=1
                        }
                        if RTLogic="AND"
                        {   
                            s RuleGroup=RuleGroup+1
                            s NumOfOr=0
                        }
                        
                    }
                }
                elseif $IsObject(items)
                {   
                    //FieldName="血常规"
                    //s itemssub=items.%Get(FieldName)  
                    s NumOfChildOr=0   
                    s ChildGroup=0   //子规则组
                    s NumOfChildAnd=0  //子规则一共and
                    s LastCRTNum=$o(^User.DHCDSSChildRuleTriggerI("ChildNumIndex",RTRowid,""),-1)
                    s CRTNum=0
                    for
                    {
                        s CRTNum=$o(^User.DHCDSSChildRuleTriggerI("ChildNumIndex",RTRowid,CRTNum))
                        q:CRTNum=""
                        s CRTRowid=$o(^User.DHCDSSChildRuleTriggerI("ChildNumIndex",RTRowid,CRTNum,0))
                        s CRTClass=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),5)  
                        s CRTItemValue=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),8)
                        s CRTCalculate=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),7)   
                        s CRTItem=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),6)       //中性粒细胞 
                        s CRTLogic=$lg($g(^User.DHCDSSChildRuleTriggerD(CRTRowid)),10)
                        
                        if LastCRTNum'=CRTNum
                        {
                            if CRTLogic="AND"    //记录子规则and的个数
                            {
                                s NumOfChildAnd=NumOfChildAnd+1
                            }
                        }
                            
                        s citems=items.%Get(FieldName)     //citems={"血白细胞计数": "10001", "中性粒细胞计数": "4000"}  
                        continue:citems=""       //array

                        if $d(arr(CRTClass))      //把子规则中所有的12类症状都记录下来
                        {
                            s Matched(MRRowid,CRTItem)=""
                        }
                        s arrlength=citems.%Size()
                        for i=0:1:arrlength          //遍历citems每一项
                        {
                            s childitem=citems.%Get(i)
                            continue:childitem=""
                            s citemvalue=childitem.%Get(CRTItem)   //childitem={"中性粒细胞计数":"4000"}  
                            
                            continue:citemvalue=""
                            s cexp=""""_citemvalue_""""_CRTCalculate_""""_CRTItemValue_""""
                            
                            if @cexp            //当前这条子规则匹配成功
                            {
                                if CRTLogic="OR"
                                {
                                    s NumOfChildOr=1
                                }
                                if CRTLogic="AND"
                                {
                                    s ChildGroup=ChildGroup+1
                                    s NumOfChildOr=0
                                }
                            }
                            else        
                            {
                                if NumOfChildOr=1
                                {
                                    if CRTLogic="AND"    //如果子规则的逻辑运算符为AND
                                    {
                                        s ChildGroup=ChildGroup+NumOfChildOr
                                        s NumOfChildOr=0
                                    }
                                    q
                                }
                            }
                        }
                            
                        
                    }
                    
                    if (ChildGroup+NumOfChildOr)=(NumOfChildAnd+1)
                    {
                        //子规则完全匹配成功
                        if RTLogic="OR"     //子规则匹配成功，同时规则逻辑运算符为OR
                        {
                            s NumOfOr=1
                        } 
                        if RTLogic="AND"     //子规则匹配成功，同时规则逻辑运算符为AND
                        {
                            s RuleGroup=RuleGroup+1
                            s NumOfOr=0
                        }
                        
                    }
                    
                }
                else   //规则项没有匹配成功
                {
                    if NumOfOr=1     //规则中OR记录值为1时
                    {
                        if RTLogic="AND"      //规则中逻辑运算符为AND
                        {
                            s RuleGroup=RuleGroup+NumOfOr
                            s NumOfOr=0
                        }
                        q
                    }
                }
                
            }
            
        }
        s tmpstr=""
        s disjson=""
        if (RuleGroup+NumOfOr)=(NumOfAnd+1)
        {   
            s MatchedSymptoms=""     //遍历出此疾病的规则中所有的症状
            for
            {
                s MatchedSymptoms=$o(Matched(MRRowid,MatchedSymptoms))
                q:MatchedSymptoms=""
                s:tmpstr'="" tmpstr=tmpstr_","_""""_MatchedSymptoms_""""
                s:tmpstr="" tmpstr=""""_MatchedSymptoms_""""
                
            }
            //s disease(RuleDisease)=RuleResult
            s DiseaseJson=""
            s DiseaseJson="""疾病名"""_":"_""""_RuleDisease_""""_","_"""权重"""_":"_""""_RuleWeight_""""_","_"""因子"""_":"_""""_RuleResult_""""_","_"""ICD"""_":"_""""_RuleICD_""""_","_"""星级"""_":"_""""_RuleStar_""""_","_"""症状"""_":"_"["_tmpstr_"]"
            
            s:AllDiseases'="" AllDiseases=AllDiseases_",{"_DiseaseJson_"}"
            s:AllDiseases="" AllDiseases="{"_DiseaseJson_"}"
        }   
    }
    s result="["_AllDiseases_"]"
    q result
GetSympArr
    s arr("体征信息")=""
    s arr("症状")=""
    s arr("个人史")=""
    s arr("婚育史")=""
    s arr("处方")=""
    s arr("检查")=""
    s arr("检验")=""
    s arr("手术")=""
    s arr("护理")=""
    s arr("输血")=""
    s arr("饮食")=""
    s arr("处置")=""
}

/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).GetSuspectedDiseaseByDiagRuleNew("DH001^te001^1^^1^demo^1^内分泌科^Y")
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).GetSuspectedDiseaseByDiagRuleNew("XwhTest^XwhTest^1^住院^13949^伍哲^111^呼吸科^1")
ClassMethod GetSuspectedDiseaseByDiagRuleNew(PatientInfo As %String) As %String
{
    s AllDiseases=""
    s MRRowid=0
    for
    {
        s MRRowid=$o(^User.DHCDSSMedicalRuleI("TypeIndex"," CDD00701",MRRowid))
        q:MRRowid=""
        s RuleDisease=$lg($g(^User.DHCDSSMedicalRuleD(MRRowid)),5)
        
        s RuleResult=$lg($g(^User.DHCDSSMedicalRuleD(MRRowid)),10)
        s RuleRange=$lg($g(^User.DHCDSSMedicalRuleD(MRRowid)),12)
        if RuleRange'=""
        {
            s DeptRowid=$o(^User.DHCDSSDeptDictI("CodeIndex"," "_RuleRange,0))
            s DeptDesc=$lg($g(^User.DHCDSSDeptDictD(DeptRowid)),3)
            //s LocId=$g(%session.Data("LOGON.CTLOCID"))
            s LocDesc=$p(PatientInfo,"^",8)
            continue:DeptDesc'=LocDesc
        }
        s RuleICD=$lg($g(^User.DHCDSSMedicalRuleD(MRRowid)),19)
        s RuleWeight=$select(RuleResult="确诊因子":$FNUMBER(0.9,"+"),RuleResult="关键因子":$FNUMBER(0.6,"+"),RuleResult="主要因子":$FNUMBER(0.3,"+"),RuleResult="伴随因子":$FNUMBER(0.1,"+"),1:0)
        s RuleStar=$select(RuleResult="确诊因子":"三星",RuleResult="关键因子":"三星",RuleResult="主要因子":"二星",RuleResult="伴随因子":"一星",1:0)
        k Matched
        s Flag= ..MatchItemRule(MRRowid,PatientInfo,.Matched)
        if Flag="1"   //匹配成功
        {
	    	s DiseaseJson="""疾病名"""_":"_""""_RuleDisease_""""_","_"""权重"""_":"_""""_RuleWeight_""""_","_"""因子"""_":"_""""_RuleResult_""""_","_"""ICD"""_":"_""""_RuleICD_""""_","_"""星级"""_":"_""""_RuleStar_""""_","_"""症状"""_":"_"["_Matched_"]"
            s:AllDiseases'="" AllDiseases=AllDiseases_",{"_DiseaseJson_"}"
            s:AllDiseases="" AllDiseases="{"_DiseaseJson_"}"
	    }
        
    }
    q "["_AllDiseases_"]"
}

/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).MatchItemRule("683","胃肿瘤^胃肿瘤^1^门诊^6474^李得原^111^信息部^1",.a)
ClassMethod MatchItemRule(RuleDr As %String, PatientInfo As %String, ByRef Matched) As %String
{
	s Matched=""
	s Flag="0"
    s LastRTNum=$o(^User.DHCDSSRuleTriggerI("NumIndex",RuleDr,""),-1)
    s RTNum=0
    for
    {
        s RTNum=$o(^User.DHCDSSRuleTriggerI("NumIndex",RuleDr,RTNum))
        q:RTNum=""
        s RTRowid = $o(^User.DHCDSSRuleTriggerI("NumIndex",RuleDr,RTNum,0))
        s TriggerItemLogic = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),9)    //and or
        s TriggerItemCalculate = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),6)   //运算符
        s TriggerItem = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),5)   //InspectionName^LabResultFlag
        s TriggerItemValue = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),7)    //症状名
        s TriggerClass= $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),4)   //类型编码
        //s RTChild = $lg($g(^User.DHCDSSRuleTriggerD(RTRowid)),11)   //是否包含子规则
        s RTChild=$d(^User.DHCDSSChildRuleTriggerI("TriggerIndex",RTRowid))
        s ClassName=##class(web.CDSS.CMKB.BasicsDict).GetBasicsItemName(TriggerClass)   //类型转为汉字描述
        s PatientInfoString=##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^"_ClassName)
        try
        {
            s PatientInfoJson=[].%FromJSON(PatientInfoString)
        }
        catch exp
        {
	        continue
	    }
	    
	    for i=0:1:PatientInfoJson.%Size()-1
	    {
		    s ItemJson=PatientInfoJson.%Get(i)  //获取其中一个{}
		    if ItemJson.%IsDefined(TriggerItem)
		    {  
			    s ItemValue=ItemJson.%Get(TriggerItem)    //获取Item的值
			    continue:ItemValue=""
			    s Exp=""""_ItemValue_""""_TriggerItemCalculate_""""_TriggerItemValue_""""
			    if @Exp
			    {
				    if RTChild'="0"    //有子规则
				    {
					    k ChildMatched
						s ChildFlag=..MatchChildItemRule(RTRowid,ItemJson.%ToJSON(),.ChildMatched)
						if ChildFlag="1" //子规则匹配成功,则本条规则匹配成功
						{
							s:Matched'="" Matched=Matched_","_""""_ItemValue_""""_","_ChildMatched
							s:Matched="" Matched=""""_ItemValue_""""_","_ChildMatched
							s Flag="1"
							q
						}
						else   //子规则没有匹配成功，则本条规则不成功
						{
							s Flag="0"
							q
						}
					}
					else     //如果没有子规则
					{
						s Flag="1"
						s:Matched'="" Matched=Matched_","_""""_ItemValue_""""
						s:Matched="" Matched=""""_ItemValue_""""
						q
					}
				}
				else
				{
					s Flag="0"
				}
			}
			else
			{
				s Flag="0"
			}
		}
		
		if Flag="1"    //本条规则匹配成功
		{
			if TriggerItemLogic="AND"
			{
				if LastRTNum=RTNum
				{
					s Flag="1"
				}
				else
				{
					s Flag="0"
				}
			}
			else
			{
				s Flag="1"
			}
		}
		else    //本条规则没有匹配成功
		{
			if TriggerItemLogic="AND"
			{
				if Flag="0"
				{
					q
				}
			}
		}
    }
    q Flag
}

/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).MatchChildItemRule("2499","DH001^te001^1^^1^demo^1^内分泌科^Y")
ClassMethod MatchChildItemRule(RTRowid As %String, ItemJsonString As %String, ByRef ChildMatched) As %String
{
	s ChildMatched=""
	s ChildFlag="0"   //用来标记子规则and区间内是否匹配成功
	s ItemJson=[].%FromJSON(ItemJsonString)
	s LastChildNum=$o(^User.DHCDSSChildRuleTriggerI("ChildNumIndex",RTRowid,""),-1)
    s ChildNum=0
    for
    {
	    s ChildNum=$o(^User.DHCDSSChildRuleTriggerI("ChildNumIndex",RTRowid,ChildNum))
	    q:ChildNum=""
	    s ChildRTRowid=$o(^User.DHCDSSChildRuleTriggerI("ChildNumIndex",RTRowid,ChildNum,0))
	    s (CRTItem,CRTLogic,CRTCalculate,CRTClass)=""
        s CRTClass=$lg($g(^User.DHCDSSChildRuleTriggerD(ChildRTRowid)),5)  
        s CRTItemValue=$lg($g(^User.DHCDSSChildRuleTriggerD(ChildRTRowid)),8)
        s CRTCalculate=$lg($g(^User.DHCDSSChildRuleTriggerD(ChildRTRowid)),7)   
        s CRTItem=$lg($g(^User.DHCDSSChildRuleTriggerD(ChildRTRowid)),6)      
        s CRTLogic=$lg($g(^User.DHCDSSChildRuleTriggerD(ChildRTRowid)),10)
        s ChildItemValue=""
        if ItemJson.%IsDefined("children")   //是否有children节点
	    {
		    s ChildItemJson=ItemJson.%Get("children")
		    for j=0:1:ChildItemJson.%Size()-1
		    {
			    if ChildItemJson.%Get(j).%IsDefined(CRTItem)
			    {
				    s ChildItemValue=ChildItemJson.%Get(j).%Get(CRTItem)
				    q
				}
			}
	    }
		else
		{
			s ChildItemValue=ItemJson.%Get(CRTItem)    //如果没有children节点
		}
        continue:ChildItemValue=""
        s ChildExp=""""_ChildItemValue_""""_CRTCalculate_""""_CRTItemValue_""""
        if @ChildExp  //一条子规则匹配成功
        {
	        s:ChildMatched'="" ChildMatched=ChildMatched_","_""""_CRTItem_""""
	        s:ChildMatched="" ChildMatched=""""_CRTItem_""""
            if CRTLogic="AND"      //如果规则到AND匹配成功，则重置0
            {
	            if LastChildNum=ChildNum
	            {
                	s ChildFlag="1"
	            }
	            else
	            {
		            s ChildFlag="0"
		        }
            }
            else                      //如果规则到OR匹配成功，则赋值1
            {
           		s ChildFlag="1"
            }
        }
        else
        {
         	if CRTLogic="AND"
         	{
             	if ChildFlag="0"    //当前没匹配成功
             	{
                 	return "0"
                }
            }
            if LastChildNum=ChildNum
            {
            	return "0"
            }
        }
	}
	q ChildFlag
}

/// Creator:李得原
/// CreatDate:2020-03-30
/// Description：返回当前疾病是否符合相关性规则
/// DiseaseRelation->GetSuspectedDiseaseByCondition    Info->PatientPatientInfo
/// 入参：1.患者主索引拼串 2.疾病名称
/// 返回：1 符合规则  0 不符合规则
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).GetSuspectedDiseaseByCondition("护理test^护理test^1^住院^6474^李得原^111^信息部^1","子宫内膜异位症")
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).GetSuspectedDiseaseByCondition("12345^烧伤测试^1^门诊^13949^伍哲^111^泌尿科^Y","下肢三度烧伤")
ClassMethod GetSuspectedDiseaseByCondition(PatientInfo As %String, Disease As %String) As %String
{
    //w Disease,!
    s Dis=$zstrip(Disease,"<>W")
    s DisRowid=$o(^User.DHCDSSDiseaseDictI("NameIndex"," "_$zconvert(Dis,"U"),0))
    q:DisRowid="" "0"
    //如果不存在此疾病的相关性规则，返回1
    if '$d(^User.DHCDSSDiseVSConditionI("ConditionNumIndex",DisRowid))
    {
        q "1"
    }
    s group=0
    s flag=0
    s and=0
    s Num=0
    for
    {
        s Num=$o(^User.DHCDSSDiseVSConditionI("ConditionNumIndex",DisRowid,Num))
        q:Num=""
        s RelRowid=0
        s RelRowid=$o(^User.DHCDSSDiseVSConditionI("ConditionNumIndex",DisRowid,Num,RelRowid))
        q:RelRowid=""
        s DisName=$lg($g(^User.DHCDSSDiseaseDictD(DisRowid)),3)   //疾病名
        s ConLogic=$lg($g(^User.DHCDSSDiseVSConditionD(RelRowid)),9)   //逻辑运算符
        s ConArith=$lg($g(^User.DHCDSSDiseVSConditionD(RelRowid)),7)   //运算符
        s ConName=$lg($g(^User.DHCDSSDiseVSConditionD(RelRowid)),6)   //名称
        s ConValue=$lg($g(^User.DHCDSSDiseVSConditionD(RelRowid)),8)  //值
        s ConType=$lg($g(^User.DHCDSSDiseVSConditionD(RelRowid)),4)  //正负性
        s ConClass=$lg($g(^User.DHCDSSDiseVSConditionD(RelRowid)),5)  //类型（性别、年龄）
 //     s DbJsonValue=##class(web.DHCBL.CDSS.PYInterface).ReturnPatientInfoNew(PatientInfo_"^"_ConClass)   //患者数据
        s DbJsonValue=##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^"_ConClass)
        continue:DbJsonValue=""
        
        s DbJsonValue=[].%FromJSON(DbJsonValue)
        if ConName'["^"    //非检验检查类
        {
            s Size=DbJsonValue.%Size()    //获取数组的大小
            for i=0:1:Size-1
            {
                s (valuelist,value)=""
                s valuelist=DbJsonValue.%Get(i)    //取数组中第i个
                continue:'$IsObject(valuelist)
                s value=valuelist.%Get(ConName)
                continue:value=""
                
                s ConName=$lg($g(^User.DHCDSSDiseVSConditionD(RelRowid)),6)   //名称  (性别名称)
                
                if @(""""_value_""""_ConArith_""""_ConValue_"""")    // 匹配成功
                {
                    if ConType="正性"     //匹配成功
                    {
                        s flag=1
                        q:flag=1
                    }
                }
                else      //匹配失败
                {
					
                    if ConType="负性"   //负性         //匹配成功
                    {
                        s flag=1
                        q:flag=1   
                    }
                    else
                    {
	                    s flag=0
	                }
                }
            }
            if ConLogic="AND"
            {
                if flag=0  //没匹配成功
                {
                    q
                }
                else    //当前这条规则匹配成功
                {
                    s flag=1
                }
            }
        }
        else     //ConName包含"^"（ExamName^ExamResult）, 为检验检查类
        {   
            s DbJsonValue =..ProcessPatientData(PatientInfo,ConClass,$p(ConName,"^",1))
            s DbJsonValue=[].%FromJSON(DbJsonValue)
            s valuelist=""
            s valuelists=DbJsonValue.%Get(ConClass)
            s FirstNameStr=$p(ConValue,"^",1)
            s valuelist=valuelists.%Get(FirstNameStr)
            continue:valuelist=""
            s NameLength=$l(ConName,"^")  //获取拼串的个数
            s CountFlag=0
            s SeccussFlag=0
            for n=0:1:valuelist.%Size()-1    //valuelist=[{"血白细胞计数":"4000"},{"血红细胞计数":"10000"}]
            {
                continue:'$IsObject(valuelist)
                s OutFlag=0
                for m=2:1:NameLength    
                {
                    s SingleConName=$p(ConName,"^",m)       //从第二个开始取Value，第一个Name在循环外已经取了
                    s SingleConValue=$p(ConValue,"^",m)        //
                    s (value)=""
                    s value=valuelist.%Get(n)    //取列表中的第n个json
                    s Exp=""""_value.%Get(SingleConName)_""""_ConArith_""""_SingleConValue_""""
                    
                    if @(Exp)   //患者模型json串中拿到的值和适用项中拼串的值相等
                    {
                        s OutFlag=1
                        s CountFlag=CountFlag+1  
                        if (NameLength-1=CountFlag)   //完全匹配成功（Name的^拼串每一项都匹配到了）
                        {  
                            s SeccussFlag=1 
                            q
                        }
                    }
                    if (SeccussFlag=1)
                    {
                        q
                    }
                    
                }
                if OutFlag=1
                {
                    q
                }
            }
            if (SeccussFlag=1)  //如果当前规则匹配成功
            {
                if ConType="正性"     //匹配成功
                {
                    s flag=1
                }
            }
            else      //匹配失败
            {

                if ConType="负性"   //负性         //匹配成功
                {
                    s flag=1    
                }
            }
            
        }
    }
    
    if flag=1
    {
        q "1"   //匹配成功，
    }
    else
    {
        q "0"    //匹配不成功，要过滤
    }
}

/// Creator:李得原
/// CreatDate:2020-03-30
/// Description：获取体征信息、症状、个人史、婚育史、处方、检查、检验、手术、护理、输血、饮食、处置等字段的值
/// 入参：1.患者主索引拼串
/// 返回：患者信息中12类症状和带有值的症状组成的json串
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).GetPatientData("护理test^护理test^1^住院^6474^李得原^111^信息部^1")
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).GetPatientData("1234^cdss测试^1^门诊^13949^伍哲^111^泌尿科^Y")
ClassMethod GetPatientData(PatientInfo As %String) As %String
{
    s AllStr=""
    s AllJson={}
    s result=""
    s AllJsonStr=""
    //体征-体温
    s BodyTemperature=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"体温","BodyTemperature")
    s BodyTemperature=[].%FromJSON(BodyTemperature)
    if BodyTemperature.%Get("success")="false"  //如果解析的json串有错误，则不再往下执行本条规则
    {
        q ""
    }
    s temperature=BodyTemperature.%Get("体温")
    if temperature'=""
    {
        s:AllStr'="" AllStr=AllStr_"^^"_"体温"
        s:AllStr="" AllStr="体温"
        d AllJson.%Set("体温",temperature)
    }
    
    //体征-收缩压
    s BloodPressureStr=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"收缩压","SystolicBlood")
    s BloodPressureJson=[].%FromJSON(BloodPressureStr)  
    s SystolicBlood=BloodPressureJson.%Get("收缩压")
    if SystolicBlood'=""
    {
        s:AllStr'="" AllStr=AllStr_"^^"_"收缩压"
        s:AllStr="" AllStr="收缩压"
        d AllJson.%Set("收缩压",SystolicBlood)
    }
    
    //体征-舒张压
    s DiastolicBloodStr=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"舒张压","SystolicBlood")
    s DiastolicBloodJson=[].%FromJSON(DiastolicBloodStr)  
    s DiastolicBlood=DiastolicBloodJson.%Get("收缩压")
    if DiastolicBlood'=""
    {
        s:AllStr'="" AllStr=AllStr_"^^"_"舒张压"
        s:AllStr="" AllStr="舒张压"
        d AllJson.%Set("收缩压",DiastolicBlood)
    }
    
    //体征-脉搏   
    s Pulse=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"脉搏","Pulse")
    s Pulse=[].%FromJSON(Pulse)
    s pulse=Pulse.%Get("脉搏")
    if pulse'=""
    {
        s:AllStr'="" AllStr=AllStr_"^^"_"脉搏"
        s:AllStr="" AllStr="脉搏"
        d AllJson.%Set("脉搏",pulse)
    }
    
    //体征-心率
    s HeartRate=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"心率","HeartRate")
    s HeartRate=[].%FromJSON(HeartRate)
    s heartRate=HeartRate.%Get("心率")        
    if heartRate'=""
    {
        s:AllStr'="" AllStr=AllStr_"^^"_"心率"
        s:AllStr="" AllStr="心率"
        d AllJson.%Set("心率",heartRate)
    }
    
    //体征-血氧饱和度
    s OxygenSaturation=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"血氧饱和度","OxygenSaturation")
    s OxygenSaturation=[].%FromJSON(OxygenSaturation)
    s oxygenSaturation=OxygenSaturation.%Get("血氧饱和度")
    if oxygenSaturation'=""
    {
        s:AllStr'="" AllStr=AllStr_"^^"_"血氧饱和度"
        s:AllStr="" AllStr="血氧饱和度"
        d AllJson.%Set("血氧饱和度",oxygenSaturation)
    }
    
    //体征-身高
    s Height=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"身高","Height")
    s Height=[].%FromJSON(Height)
    s height=Height.%Get("身高")
    if height'=""
    {
        s:AllStr'="" AllStr=AllStr_"^^"_"身高"
        s:AllStr="" AllStr="身高"
        d AllJson.%Set("身高",height)
    }
    
    //体征-体重
    s Weight=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"体重","Weight")
    s Weight=[].%FromJSON(Weight)
    s weight=Weight.%Get("体重")
    if weight'=""
    {
        s:AllStr'="" AllStr=AllStr_"^^"_"体重"
        s:AllStr="" AllStr="体重"
        d AllJson.%Set("体重",weight)
    }
    
    //症状
    s Symptoms=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"症状","Symptom")
    s Durations=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"症状","Duration")
    s Symptoms=[].%FromJSON(Symptoms)
    s Durations=[].%FromJSON(Durations)
    s symptoms=Symptoms.%Get("症状")
    s durations=Durations.%Get("症状")
    s length=$l(symptoms,"^^")
    if Symptoms'=""
    {
        for i=1:1:length
        {
            s symptom=$p(symptoms,"^^",i)
            s duration=$p(durations,"^^",i)
            s duration=$zstrip(duration,"<>W")
            if duration'=""
            {
	            if "早期中期晚期持续" '[ duration
	            {
		            s duration=""
		        }
	        }
            s:AllStr'="" AllStr=AllStr_"^^"_duration_symptom
            s:AllStr="" AllStr=duration_symptom
        }
    }
    
    //个人史
    s PersonalHistoryOverview=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"个人史","PersonalHistoryOverview")
    s PersonalHistoryOverview=[].%FromJSON(PersonalHistoryOverview)
    s personalHistoryOverview=PersonalHistoryOverview.%Get("个人史")
    if personalHistoryOverview'=""
    {
        s:AllStr'="" AllStr=AllStr_"^^"_personalHistoryOverview
        s:AllStr="" AllStr=personalHistoryOverview
    }
    
    //婚育史
    s MarriageOverview=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"婚育史","MarriageOverview")
    s MarriageOverview=[].%FromJSON(MarriageOverview)
    s marriageOverview=MarriageOverview.%Get("婚育史")
    if marriageOverview'=""
    {
        s:AllStr'="" AllStr=AllStr_"^^"_marriageOverview
        s:AllStr="" AllStr=marriageOverview
    }
    
    //处方
    s DrugName=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"药品","DrugName")
    s DrugName=[].%FromJSON(DrugName)
    s drugName=DrugName.%Get("药品")
    if drugName'=""
    {
        s:AllStr'="" AllStr=AllStr_"^^"_drugName
        s:AllStr="" AllStr=drugName
    }
    
    //检查
    s ExamResult=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"检查","ExamName")

    s ExamResult=[].%FromJSON(ExamResult)
    s examResult=ExamResult.%Get("检查")
    if examResult'=""
    {
        set iter = examResult.%GetIterator()
        while iter.%GetNext(.key , .value) {
            s size=value.%Size()
            for i=0:1:size-1
            {
                s ChildExam=value.%Get(i)
                s ItemName=ChildExam.%Get("ExamResult")
                s:AllStr'="" AllStr=AllStr_"^^"_ItemName
                s:AllStr="" AllStr=ItemName
            }
        }
    }
    
    //检验
    s Inspections=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"检验","InspectionName")
    s Inspections=[].%FromJSON(Inspections)
    s Inspection=Inspections.%Get("检验")
    if Inspection'=""
    {
        set iter = Inspection.%GetIterator()
        while iter.%GetNext(.key , .value) {
            s size=value.%Size()
            for i=0:1:size-1
            {
                s ChildInspection=value.%Get(i)
                s ItemName=ChildInspection.%Get("LabItemName")
                s LabResult=ChildInspection.%Get("LabResult")
                s:AllStr'="" AllStr=AllStr_"^^"_ItemName
                s:AllStr="" AllStr=ItemName
                d AllJson.%Set(ItemName,LabResult)
            }
        }
    }
    
    //手术
    s OperName=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"手术","OperName")
    s OperName=[].%FromJSON(OperName)
    s operName=OperName.%Get("手术")
    if '$IsObject(operName)
    {
        s:AllStr'="" AllStr=AllStr_"^^"_operName
        s:AllStr="" AllStr=operName
    }
    else
    {
        set iter = operName.%GetIterator()
        while iter.%GetNext(.key , .value) {
            s size=value.%Size()
            for i=0:1:size-1
            {
                s ChildNursing=value.%Get(i)
                s NurseItemName=ChildNursing.%Get("OperName")
                s:AllStr'="" AllStr=AllStr_"^^"_NurseItemName
                s:AllStr="" AllStr=NurseItemName
            }
        }
    }
    
    //护理 
    s NursingItems=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"护理","NursingItem")
    s NursingItems=[].%FromJSON(NursingItems)
    s NursingItem=NursingItems.%Get("护理")
    if NursingItem'=""
    {
        set iter = NursingItem.%GetIterator()
        while iter.%GetNext(.key , .value) {
            s size=value.%Size()
            for i=0:1:size-1
            {
                s ChildNursing=value.%Get(i)
                s NurseItemName=ChildNursing.%Get("ChildItem")
                s:AllStr'="" AllStr=AllStr_"^^"_NurseItemName
                s:AllStr="" AllStr=NurseItemName
            }
        }
    }
    
    //输血-输血量
    s BloodTransVolume=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"输血","BloodTransVolume")
    s BloodTransVolume=[].%FromJSON(BloodTransVolume)
    s bloodTransVolume=BloodTransVolume.%Get("输血")
    if BloodTransVolume'=""
    {
        s:AllStr'="" AllStr=AllStr_"^^"_"输血量"
        s:AllStr="" AllStr="输血量"
        d AllJson.%Set("输血量",bloodTransVolume)
    }
    
    //输血-血型
    s BloodTransType=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"输血","BloodTransType")
    s BloodTransType=[].%FromJSON(BloodTransType)
    s bloodTransType=BloodTransType.%Get("BloodGroup")
    if BloodTransType'=""
    {
        s:AllStr'="" AllStr=AllStr_"^^"_"血型"
        s:AllStr="" AllStr="血型"
        d AllJson.%Set("血型",bloodTransType)
    }
    
    //饮食-饮食内容
    s DietContent=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"饮食","DietContent")
    s DietContent=[].%FromJSON(DietContent)
    s dietContent=DietContent.%Get("饮食")
    if DietContent'=""
    {
        s:AllStr'="" AllStr=AllStr_"^^"_dietContent
        s:AllStr="" AllStr=dietContent
    }   
    
    
    //处置
    s OrderDesc=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"处置","OrderDesc")
    s OrderDesc=[].%FromJSON(OrderDesc)
    s orderDesc=OrderDesc.%Get("处置")
    if OrderDesc'=""     //如果处置不为空
    {
        s:AllStr'="" AllStr=AllStr_"^^"_orderDesc
        s:AllStr="" AllStr=orderDesc    
    }
    s AllJsonStr=AllJson.%ToJSON()
    //症状->Value     症状加值->KeyValue
    s result="{"_"""Value"""_":"_""""_AllStr_""""_","_"""KeyValue"""_":"_AllJsonStr_"}"
    q result
}

/// Creator:李得原
/// CreatDate:2020-06-29
/// Description：推荐疑似疾病结果保存
/// 入参：
/// 返回：
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).SaveRecomSuspectResult("DH002^te002^1^门诊^^小明^^普外科^1","1","推荐辅助检验检查")
ClassMethod SaveRecomSuspectResult(PatientInfo As %String, RecomDesc As %String, RecomInfoType As %String) As %String
{
    q:PatientInfo="" "{}"
    q:RecomDesc="" "{}"
    //s RecomDescJson=[{"id": "1", "text": "急性阑尾炎", "icd": "K35.900", "star": "三星", "children": [{"id": "sym11", "text": "症状"}, {"id": "check11", "text": "推荐辅助检查检验"}, {"id": "dif11", "text": "推荐鉴别诊断"}, {"id": "12", "text": "阑尾周围脓肿", "icd": "K35.103", "star": "二星", "children": [{"id": "sym121", "text": "症状"}, {"id": "check121", "text": "推荐辅助检 查检验"}, {"id": "dif121", "text": "推荐鉴别诊断"}]}, {"id": "13", "text": "急性阑尾炎伴穿孔", "icd": "K35.002", "star": "二星", "children": [{"id": "sym132", "text": "症状"}, {"id": "check132", "text": "推荐辅助检查检验"}, {"id": "dif132", "text": "推荐鉴别诊断"}]}]}, {"id": "2", "text": "十二指肠溃疡", "icd": "K26.900", "star": "一星", "children": [{"id": "sym21", "text": "症状"}, {"id": "check21", "text": "推荐辅助检查检验"}, {"id": "dif21", "text": "推荐鉴别诊断"}, {"id": "22", "text": "慢性十二指肠溃疡伴出血", "icd": "K26.400", "star": "一星", "children": [{"id": "sym221", "text": "症状"}, {"id": "check221", "text": "推荐辅助检查检验"}, {"id": "dif221", "text": "推荐鉴别诊断"}]}, {"id": "23", "text": "急性十二指肠溃疡伴有出血", "icd": "K26.000", "star": "一星", "children": [{"id": "sym232", "text": "症状"}, {"id": "check232", "text": "推荐辅助检查检验"}, {"id": "dif232", "text": "推荐鉴别诊断"}]}]}, {"id": "3", "text": "子宫平滑肌瘤", "icd": "D25.900", "star": "一星", "children": [{"id": "sym31", "text": "症状"}, {"id": "check31", "text": "推荐辅助检查检验"}, {"id": "dif31", "text": "推荐鉴别诊断"}]}, {"id": "4", "text": "慢性间质性肾炎", "icd": "N11.901", "star": "一星", "children": [{"id": "sym41", "text": "症状"}, {"id": "check41", "text": "推荐辅助检查检验"}, {"id": "dif41", "text": "推荐鉴别诊断"}]}, {"id": "5", "text": "1型糖尿病", "icd": "E10.900", "star": "一星", "children": [{"id": "sym51", "text": "症 状"}, {"id": "check51", "text": "推荐辅助检查检验"}, {"id": "dif51", "text": "推荐鉴别诊断"}, {"id": "52", "text": "成人隐匿性自身免疫性糖尿病", "icd": "E10.901", "star": "一星", "children": [{"id": "sym521", "text": "症状"}, {"id": "check521", "text": "推荐辅助检查检验"}, {"id": "dif521", "text": "推荐鉴别诊断"}]}, {"id": "53", "text": "1型糖尿病性高渗性昏 迷", "icd": "E10.001", "star": "一星", "children": [{"id": "sym532", "text": "症状"}, {"id": "check532", "text": "推荐辅助检查检验"}, {"id": "dif532", "text": "推荐鉴别诊断"}]}]}]
    //s RecomDescJson=[{"id": "1", "text": "线粒体脑肌病", "icd": "G71.301", "star": "一星", "children": [{"id": "raresym11", "text": "症状"}, {"id": "check11", "text": "推荐辅助检查检验"}, {"id": "dif11", "text": "推荐鉴别诊断"}]}, {"id": "2", "text": "进行性肌营养不良", "icd": "G71.001", "star": "一 星", "children": [{"id": "raresym21", "text": "症状"}, {"id": "check21", "text": "推荐辅助检查检验"}, {"id": "dif21", "text": "推荐鉴别诊断"}]}, {"id": "3", "text": "甲基丙二酸血症", "icd": "E71.102", "star": "一星", "children": [{"id": "raresym31", "text": "症状"}, {"id": "check31", "text": "推荐辅助检查检验"}, {"id": "dif31", "text": "推荐鉴别诊断"}]}, {"id": "4", "text": "丙酸血症", "icd": "E71.101", "star": "一星", "children": [{"id": "raresym41", "text": "症状"}, {"id": "check41", "text": "推荐辅助检查检验"}, {"id": "dif41", "text": "推荐鉴别诊断"}]}]
    //s RecomDescJson=[{"disease":"急性阑尾炎","degree":"3","type":"检查","desc":"超声检查","detail":"项目禁忌:"},{"disease":"急性阑尾炎","degree":"2","type":"检查","desc":"CT检查","detail":"项目禁忌:"},{"disease":"急性阑尾炎","degree":"4","type":"检查","desc":"胃镜检查","detail":"项目禁忌:急性穿孔"},{"disease":"急性阑尾炎","degree":"1","type":"检验","desc":"血常规","detail":"项目禁忌:</br>检验明细:血红蛋白"},{"disease":"急性阑尾炎","degree":"5","type":"检验","desc":"尿常规","detail":"项目禁忌:</br>检验明细:尿酮体"},{"disease":"急性阑尾炎","degree":"5","type":"检验","desc":"幽门螺杆菌检测","detail":"项目禁忌:急性穿孔"}]
    //辅助检验检查 """disease"":"""_disease_""",""degree"":"""_degree_""",""type"":""检查"",""desc"":"""_desc_""",""detail"":"""_DetailStr_"""" 
    s IDNO=$p(PatientInfo,"^",1)     
    s PatientDR=$p(PatientInfo,"^",2)
    s VisitID=$p(PatientInfo,"^",3)
    s VisitType=$p(PatientInfo,"^",4)
    s Config=$p(PatientInfo,"^",9)
    s UserName=$p(PatientInfo,"^",6)
    s CTLocDesc=$p(PatientInfo,"^",8)
    try{
        s RecomDescJson=[].%FromJSON(RecomDesc)
    }
    catch exp{
        
        return "{"_"""success"""_":"_"""false"""_","_"""info"""_":"_""""_exp.Name_""""_"}"
    }

    if RecomInfoType'="推荐辅助检验检查"   //推荐疑似疾病、罕见病
    {
        for i=0:1:RecomDescJson.%Size()-1
        {
            s SecondName=""
            s FirstName=""
            s ArrayItem=RecomDescJson.%Get(i)
            s FirstName=ArrayItem.%Get("text")   //父节点的疾病名
            s RecomGrade=""
            s RecomGrade=ArrayItem.%Get("star")
            
            s flag=0
            if ArrayItem.%IsDefined("children")
            {
                s DiseaseChildrenArray=ArrayItem.%Get("children")
                for j=0:1:DiseaseChildrenArray.%Size()-1
                {
                    s DiseaseChildrenItem=DiseaseChildrenArray.%Get(j)
                    s DiseaseChild=DiseaseChildrenItem.%Get("text")
                    
                    continue:DiseaseChild="症状"
                    continue:DiseaseChild="推荐辅助检查检验"
                    continue:DiseaseChild="推荐鉴别诊断"

	                s tempArray=DiseaseChildrenItem.%ToJSON()
	                s tempArray=[].%FromJSON(tempArray)
	                d tempArray.%Remove("children")
	                s tempSql=tempArray.%ToJSON()
                    if $d(^User.DHCDSSRecomDiseaseInfoI("DescIndex",PatientDR))
                    {
                   		if $d(^User.DHCDSSRecomDiseaseInfoI("DescIndex",PatientDR,tempSql))
                   		{
	                   		continue
	                   	}
                    }
                    s flag=1
                    s obj=##class(User.DHCDSSRecomDiseaseInfo).%New()
                    s obj.IDNO=IDNO
                    s obj.FirstName=FirstName
                    s obj.PatientDR=PatientDR
                    s obj.RecomDate=$zdt($h,3)
                    s obj.RecomDept=CTLocDesc
                    s obj.RecomDesc=tempArray.%ToJSON()
                    s obj.RecomGrade=RecomGrade
                    s obj.RecomInfoType=RecomInfoType
                    s obj.RecomUser=UserName
                    s obj.SecondName=DiseaseChild
                    s obj.VisitID=VisitID
                    s obj.VisitType=VisitType
                    
                    s sc=obj.%Save()
                    d obj.%Close()
                    if $$$ISOK(sc)
                    {
                        
                        s result="{success:'true',errorinfo:'保存成功！'}"
                    }
                    else
                    {
                        
                        s result="{success:'false',errorinfo:'"_$system.OBJ.DisplayError(sc)_"'}"  //返回错误信息
                        //w result,!
                        return result
                    }
                }
            }
            if flag=0    //没有子节点的树形结构
            {

                
                s tempArray=ArrayItem.%ToJSON()
                s tempArray=[].%FromJSON(tempArray)
                d tempArray.%Remove("children")
                s tempSql=tempArray.%ToJSON()
                if $d(^User.DHCDSSRecomDiseaseInfoI("DescIndex",PatientDR))
                {
               		if $d(^User.DHCDSSRecomDiseaseInfoI("DescIndex",PatientDR,tempSql))
               		{
                   		continue
                   	}
                }
                s obj=##class(User.DHCDSSRecomDiseaseInfo).%New()
                s obj.IDNO=IDNO
                s obj.FirstName=FirstName
                s obj.PatientDR=PatientDR
                s obj.RecomDate=$zdt($h,3)
                s obj.RecomDept=CTLocDesc
                s obj.RecomDesc=tempArray.%ToJSON()
                s obj.RecomGrade=RecomGrade
                s obj.RecomInfoType=RecomInfoType
                s obj.RecomUser=UserName
                s obj.SecondName=""
                s obj.VisitID=VisitID
                s obj.VisitType=VisitType
                s sc=obj.%Save()
                d obj.%Close()
                if $$$ISOK(sc)
                { 
                    s result="{success:'true',errorinfo:'保存成功！'}"
                }
                else
                {
                    
                    s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                    return result
                }
            }
        }
    }
    else    //推荐辅助检验检查
    {
        for i=0:1:RecomDescJson.%Size()-1
        {
            s SecondName=""
            s FirstName=""
            s ArrayItem=RecomDescJson.%Get(i)
            s FirstName=ArrayItem.%Get("type")   
            s RecomGrade=ArrayItem.%Get("degree")   
            s SecondName=ArrayItem.%Get("desc")
            s tempArray=ArrayItem.%ToJSON()
            if $d(^User.DHCDSSRecomDiseaseInfoI("DescIndex",PatientDR))
            {
           		if $d(^User.DHCDSSRecomDiseaseInfoI("DescIndex",PatientDR,tempArray))
           		{
               		continue
               	}
            }
            
            s obj=##class(User.DHCDSSRecomDiseaseInfo).%New()
            s obj.IDNO=IDNO
            s obj.FirstName=FirstName
            s obj.PatientDR=PatientDR
            s obj.RecomDate=$zdt($h,3)
            s obj.RecomDept=CTLocDesc
            s obj.RecomDesc=ArrayItem.%ToJSON()
            s obj.RecomGrade=RecomGrade
            s obj.RecomInfoType=RecomInfoType
            s obj.RecomUser=UserName
            s obj.SecondName=SecondName
            s obj.VisitID=VisitID
            s obj.VisitType=VisitType
            s sc=obj.%Save()
            d obj.%Close()
            if $$$ISOK(sc)
            {
                
                s result="{success:'true',errorinfo:'保存成功！'}"
            }
            else
            {
                
                s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                return result
            }
        }
    }
    q "sucess"
}

/// Creator:李得原
/// CreatDate:2020-007-01
/// Description：推荐疑似疾病数量统计
/// 入参：
/// 返回：
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).StatisticsSusDiseaseAmount("2020-06-30 14:30:54","","","推荐辅助检验检查","")
ClassMethod StatisticsSusDiseaseAmount(StartTime As %String, EndTime As %String, Loc As %String, Type As %String, UserName As %String, Star As %String) As %String
{
    k SumResult   //推荐疾病数量
    k CountResult   //推荐次数
    s ResultList=""
    k DiseaseDesc   //记录疾病信息
    s DiseaseAmount=0
    s Count=0
    s Sum=0
    if (StartTime'="") & (EndTime'="")   //如果有开始时间、结束时间
    {
        if $d(^User.DHCDSSRecomDiseaseInfoI("DateIndex",StartTime))
        {
            s flag=0
            s RDIRowid=0
            for
            {
                s RDIRowid=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",StartTime,RDIRowid))
                q:RDIRowid=""
                s RealLoc=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),8)  //科室
                s RecomUser=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),7)  //用户
                s RecomType=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),9)  //类型(疑似疾病、辅助检验检查、罕见病)
                s FirstName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),10)  //类目
                s SecondName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),11)  //亚目
                s RecomGrade=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),12)  //推荐指数
                
                s Sum=Sum+1
                s flag=$$EachRow(Sum,FirstName,SecondName)
            }
            if flag=1
            {
                d EachTime
            }
        }
        
        s StopTime=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",EndTime))
        s Start=StartTime
        for
        {
            s Start=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start))
            q:Start=StopTime
            
            s flag=0    //标记是否满足当前条件，如果满足，推荐次数加1
            s RDIRowid=0
            for
            {
                s RDIRowid=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start,RDIRowid))
                q:RDIRowid=""
                s RealLoc=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),8)  //科室
                s RecomUser=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),7)  //用户
                s RecomType=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),9)  //类型(疑似疾病、辅助检验检查、罕见病)
                s FirstName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),10)  //类目
                s SecondName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),11)  //亚目
                s RecomGrade=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),12)  //推荐指数
                s Sum=Sum+1
                s flag=$$EachRow(Sum,FirstName,SecondName)
            }
            if flag=1
            {
                d EachTime
            }
        }
    }
    elseif StartTime'=""    //如果有开始时间，但没有结束时间
    {
        if $d(^User.DHCDSSRecomDiseaseInfoI("DateIndex",StartTime))
        {
            s flag=0
            s RDIRowid=0
            for
            {
                s RDIRowid=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",StartTime,RDIRowid))
                q:RDIRowid=""
                s RealLoc=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),8)  //科室
                s RecomUser=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),7)  //用户
                s RecomType=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),9)  //类型(疑似疾病、辅助检验检查、罕见病)
                s FirstName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),10)  //类目
                s SecondName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),11)  //亚目
                s RecomGrade=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),12)  //推荐指数
                s Sum=Sum+1
                s flag=$$EachRow(Sum,FirstName,SecondName)
            }
            if flag=1
            {
                d EachTime
            }
            
        }
        
        s Start=StartTime
        for
        {
            s Start=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start))
            q:Start=""
            
            s flag=0
            s RDIRowid=0
            for
            {
                s RDIRowid=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start,RDIRowid))
                q:RDIRowid=""
                s RealLoc=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),8)  //科室
                s RecomUser=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),7)  //用户
                s RecomType=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),9)  //类型(疑似疾病、辅助检验检查、罕见病)
                s FirstName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),10)  //类目
                s SecondName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),11)  //亚目
                s RecomGrade=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),12)  //推荐指数
                s Sum=Sum+1
                s flag=$$EachRow(Sum,FirstName,SecondName)
            }
            
            if flag=1
            {
                d EachTime
            }
        }
    }
    elseif EndTime'=""    //如果没有开始时间，但有结束时间
    {
        s StopTime=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",EndTime))
        s Start=""
        for
        {
            s Start=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start))
            q:Start=StopTime
            
            s flag=0
            s RDIRowid=0
            for
            {
                s RDIRowid=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start,RDIRowid))
                q:RDIRowid=""
                s RealLoc=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),8)  //科室
                s RecomUser=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),7)  //用户
                s RecomType=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),9)  //类型(疑似疾病、辅助检验检查、罕见病)
                s FirstName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),10)  //类目
                s SecondName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),11)  //亚目
                s RecomGrade=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),12)  //推荐指数
                s Sum=Sum+1
                s flag=$$EachRow(Sum,FirstName,SecondName)
            }
            if flag=1
            {
                d EachTime
            }
        }
    }
    else   //日期都为空
    {
        s Start=""
        for
        {
            s Start=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start))
            q:Start=""
            
            s flag=0
            s RDIRowid=0
            for
            {
                s RDIRowid=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start,RDIRowid))
                q:RDIRowid=""
                s RealLoc=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),8)  //科室
                s RecomUser=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),7)  //用户
                s RecomType=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),9)  //类型(疑似疾病、辅助检验检查、罕见病)
                s FirstName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),10)  //类目
                s SecondName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),11)  //亚目
                s RecomGrade=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),12)  //推荐指数
                s Sum=Sum+1
                s flag=$$EachRow(Sum,FirstName,SecondName)
            }
            
            if flag=1
            {
                d EachTime
            }
        }
    }
    
    s SumResultJson={}   //记录科室推荐疾病数量
    s CountResultJson={}  //记录科室推荐疾病次数
    s Result={}
    s SumPercent={}     //记录科室推荐疾病数量所占百分比
    s CountPercent={}   //记录科室推荐疾病次数所占百分比
    s AllLocSum=0
    k Percent
    if $d(ResultList)   //如果ResultList有数据
    {
        if Loc=""   //显示所有科室的次数和数量
        {
            s SumResultJson={}   //记录科室推荐疾病数量
            s LocDesc=""
            for
            {
                s LocDesc=$o(SumResult(LocDesc))    //遍历所有科室推荐疾病数量
                q:LocDesc=""
                s LocSum=0
                s UserDesc=""
                for
                {
                    s UserDesc=$o(SumResult(LocDesc,UserDesc))
                    q:UserDesc=""
                    s LocSum=LocSum+SumResult(LocDesc,UserDesc)
                    s AllLocSum=AllLocSum+LocSum
                }
                s Percent(LocSum,LocDesc)=""
                d SumResultJson.%Set(LocDesc,LocSum)
            }

            s RemainTen=0
            s FlagSumTen=0
            s HeadSumTen=""    //取前十个
            for
            {
                s HeadSumTen=$o(Percent(HeadSumTen),-1)    //从大到小取值
                q:HeadSumTen=""
                s LocTen=""
                for
                {
                    s LocTen=$o(Percent(HeadSumTen,LocTen))   //取前十个
                    q:LocTen=""
                    q:FlagSumTen=10
                    s FlagSumTen=FlagSumTen+1
                    s RemainTen=LocSum-HeadSumTen
                    d SumPercent.%Set(LocTen,HeadSumTen/AllLocSum)
                }
                q:FlagSumTen=10
            }
            d SumPercent.%Set("其他",RemainTen/AllLocSum)

            s LocDesc=""
            for
            {
                s LocDesc=$o(CountResult(LocDesc))    //遍历所有科室推荐次数
                q:LocDesc=""
                s LocSum=0
                s UserDesc=""
                for
                {
                    s UserDesc=$o(CountResult(LocDesc,UserDesc))
                    q:UserDesc=""
                    s LocCount=LocSum+CountResult(LocDesc,UserDesc)
                }
                d CountResultJson.%Set(LocDesc,LocCount)
            }
    
        }
        else   //显示当前科室的所有次数和数量
        {
            
            if $d(SumResult(Loc))    //存在当前科室的疾病统计数量
            {
                s UserDesc=""
                for
                {
                    s UserDesc=$o(SumResult(Loc,UserDesc))
                    q:UserDesc=""
                    
                    d SumResultJson.%Set(UserDesc,SumResult(Loc,UserDesc)) //此用户的推荐疾病个数
                }
            }
            else    //当前科室没有疾病数量统计
            {
                d SumResultJson.%Set("无疾病推荐","")
            }
            
            
            if $d(CountResult(Loc))   //存在当前科室的推荐次数
            {
                s UserDesc=""
                for
                {
                    s UserDesc=$o(CountResult(Loc,UserDesc))
                    q:UserDesc=""
                    
                    d CountResultJson.%Set(UserDesc,CountResult(Loc,UserDesc)) //此用户的推荐疾病个数
                }
            }
            else
            {
                d CountResultJson.%Set("未推荐过疾病","")
            }
            
            
            s DisName=""
            for
            {
                s DisName=$o(DiseaseDesc(DisName))
                q:DisName=""
                
                s ReverseDisease(DiseaseDesc(DisName),DisName)=""   //反转次数和疾病名称 进行前十排序  
            }
            
            s RemainCountTen=DiseaseAmount
            s CountTen=0
            s HeadCountTen=""     //疾病前10
            for
            {
                s HeadCountTen=$o(ReverseDisease(HeadCountTen),-1)
                q:HeadCountTen=""
                s DisDesc=""
                for
                {
                    s DisDesc=$o(ReverseDisease(HeadCountTen,DisDesc))
                    q:DisDesc=""
                    q:CountTen=10
                    s CountTen=CountTen+1
                    d CountPercent.%Set(DisDesc,HeadCountTen/DiseaseAmount)
                    s RemainCountTen=RemainCountTen-HeadCountTen
                }
            }
            d CountPercent.%Set("其他",RemainCountTen/DiseaseAmount)
        }
        
        d Result.%Set("推荐疾病次数",CountResultJson)
        d Result.%Set("推荐疾病个数",SumResultJson)
        d Result.%Set("推荐科室个数占比",SumPercent)
        d Result.%Set("推荐疾病占比",CountPercent)
        q Result.%ToJSON()
    }
    else   //无数据
    {
        q ""
    }
    
EachRow(Sum,FirstName,SecondName)
    if RecomType[Type
    {
        if RealLoc[Loc
        {
            if RecomUser[UserName
            {
                if RecomGrade[Star
                {
                    s ResultList("HospSum",Sum)=RDIRowid   //记录全院推荐数量
                    if (FirstName="检验") || (FirstName="检查")   //如果类目检验检查 则取亚目数据
                    {
                        if $d(DiseaseDesc(SecondName))
                        {
                            s DiseaseDesc(SecondName)=DiseaseDesc(SecondName)+1
                        }
                        else
                        {
                            s DiseaseDesc(SecondName)=1
                        }
                    }
                    else
                    {
                        if $d(DiseaseDesc(FirstName))
                        {
                            s DiseaseDesc(FirstName)=DiseaseDesc(FirstName)+1
                        }
                        else
                        {
                            s DiseaseDesc(FirstName)=1
                        }
                    }
                    
                    
                    if $d(SumResult(RealLoc,RecomUser))
                    {
                        s SumResult(RealLoc,RecomUser)=SumResult(RealLoc,RecomUser)+1
                    }
                    else
                    {
                        s SumResult(RealLoc,RecomUser)=1
                    }
                    s flag=1
                    s DiseaseAmount=DiseaseAmount+1
                }
            }
        }
    }
    q flag
EachTime
    s Count=Count+1
    s ResultList("HospCount",Count)=""   //记录全院推荐次数
    
    if $d(CountResult(RealLoc,RecomUser))
    {
        s CountResult(RealLoc,RecomUser)=CountResult(RealLoc,RecomUser)+1
    }
    else
    {
        s CountResult(RealLoc,RecomUser)=1
    }
}

/// Creator:李得原
/// CreatDate:2020-007-01
/// Description：推荐疑似疾病质量统计
/// 入参：
/// 返回：
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).StatisticsSusDiseaseQuality("","","","推荐疑似疾病","","三星")                     
ClassMethod StatisticsSusDiseaseQuality(StartTime As %String, EndTime As %String, Loc As %String, Type As %String, UserName As %String, Star As %String) As %String
{
    
    if (StartTime'="") & (EndTime'="")   //如果有开始时间、结束时间
    {
        if $d(^User.DHCDSSRecomDiseaseInfoI("DateIndex",StartTime))
        {
            s flag=0
            s RDIRowid=0
            for
            {
                s RDIRowid=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",StartTime,RDIRowid))
                q:RDIRowid=""
                s PatientDR=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),3)  //病人标识（就诊医院id
                s VisitID=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),4)  //就诊次数编号（第几次）
                s RealLoc=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),8)  //科室
                s RecomUser=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),7)  //用户
                s RecomType=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),9)  //类型(疑似疾病、辅助检验检查、罕见病)
                s FirstName=$lg($g(^User.DHCDsSSRecomDiseaseInfoD(RDIRowid)),10)  //类目
                s SecondName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),11)  //亚目
                s RecomGrade=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),12)  //推荐指数

                s flag=$$EachRow(FirstName,SecondName)
            }

        }
        
        s StopTime=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",EndTime))
        s Start=StartTime
        for
        {
            s Start=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start))
            q:Start=StopTime
            
            s flag=0    //标记是否满足当前条件，如果满足，推荐次数加1
            s RDIRowid=0
            for
            {
                s RDIRowid=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start,RDIRowid))
                q:RDIRowid=""
                s PatientDR=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),3)  //病人标识（就诊医院id
                s VisitID=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),4)  //就诊次数编号（第几次）
                s RealLoc=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),8)  //科室
                s RecomUser=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),7)  //用户
                s RecomType=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),9)  //类型(疑似疾病、辅助检验检查、罕见病)
                s FirstName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),10)  //类目
                s SecondName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),11)  //亚目
                s RecomGrade=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),12)  //推荐指数
                s flag=$$EachRow(FirstName,SecondName)
            }

        }
    }
    elseif StartTime'=""    //如果有开始时间，但没有结束时间
    {
        if $d(^User.DHCDSSRecomDiseaseInfoI("DateIndex",StartTime))
        {
            s flag=0
            s RDIRowid=0
            for
            {
                s RDIRowid=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",StartTime,RDIRowid))
                q:RDIRowid=""
                s PatientDR=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),3)  //病人标识（就诊医院id
                s VisitID=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),4)  //就诊次数编号（第几次）
                s RealLoc=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),8)  //科室
                s RecomUser=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),7)  //用户
                s RecomType=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),9)  //类型(疑似疾病、辅助检验检查、罕见病)
                s FirstName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),10)  //类目
                s SecondName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),11)  //亚目
                s RecomGrade=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),12)  //推荐指数
                s flag=$$EachRow(FirstName,SecondName)
            }
    
        }
        
        s Start=StartTime
        for
        {
            s Start=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start))
            q:Start=""
            
            s flag=0
            s RDIRowid=0
            for
            {
                s RDIRowid=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start,RDIRowid))
                q:RDIRowid=""
                s PatientDR=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),3)  //病人标识（就诊医院id
                s VisitID=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),4)  //就诊次数编号（第几次）
                s RealLoc=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),8)  //科室
                s RecomUser=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),7)  //用户
                s RecomType=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),9)  //类型(疑似疾病、辅助检验检查、罕见病)
                s FirstName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),10)  //类目
                s SecondName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),11)  //亚目
                s RecomGrade=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),12)  //推荐指数

                s flag=$$EachRow(FirstName,SecondName)
            }
            
        }
    }
    elseif EndTime'=""    //如果没有开始时间，但有结束时间
    {
        s StopTime=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",EndTime))
        s Start=""
        for
        {
            s Start=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start))
            q:Start=StopTime
            
            s flag=0
            s RDIRowid=0
            for
            {
                s RDIRowid=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start,RDIRowid))
                q:RDIRowid=""
                s PatientDR=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),3)  //病人标识（就诊医院id
                s VisitID=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),4)  //就诊次数编号（第几次）
                s RealLoc=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),8)  //科室
                s RecomUser=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),7)  //用户
                s RecomType=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),9)  //类型(疑似疾病、辅助检验检查、罕见病)
                s FirstName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),10)  //类目
                s SecondName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),11)  //亚目
                s RecomGrade=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),12)  //推荐指数

                s flag=$$EachRow(FirstName,SecondName)
            }

        }
    }
    else   //日期都为空
    {
        s Start=""
        for
        {
            s Start=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start))
            q:Start=""
            s flag=0
            s RDIRowid=0
            for
            {
                s RDIRowid=$o(^User.DHCDSSRecomDiseaseInfoI("DateIndex",Start,RDIRowid))
                q:RDIRowid=""
                s PatientDR=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),3)  //病人标识（就诊医院id
                s VisitID=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),4)  //就诊次数编号（第几次）
                s RealLoc=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),8)  //科室
                s RecomUser=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),7)  //用户
                s RecomType=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),9)  //类型(疑似疾病、辅助检验检查、罕见病)
                s FirstName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),10)  //类目
                s SecondName=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),11)  //亚目
                s RecomGrade=$lg($g(^User.DHCDSSRecomDiseaseInfoD(RDIRowid)),12)  //推荐指数

                s flag=$$EachRow(FirstName,SecondName)
            }

        }
    }
    
    //////////////////////////获取当前患者的确诊诊断///////////////////////////
    s AllLocScore=0
    s AllLocScoreNum=0
    s ResultJson={}
    s LocArray=[]
    s LocDesc=""
    for
    {
        s LocDesc=$o(DiseaseDesc(LocDesc))
        q:LocDesc=""
        
        s LocJson={}   //用来保存此科室下的用户json
        s UserArray=[]
        s UserDesc=""
        for
        {
            s UserDesc=$o(DiseaseDesc(LocDesc,UserDesc))
            q:UserDesc=""
            
            s PatientScoreNum=0   //用来记录患者个数，用来统计覆盖率
            s PatientScores=0     //用来统计患者覆盖率
            s UserJson={}   //用来记录用户下的患者匹配度
            s PatientArray=[]
            s PatientDR=""
            for
            {
                s PatientDR=$o(DiseaseDesc(LocDesc,UserDesc,PatientDR))    
                q:PatientDR=""
                
                s DiseaseAmount=0   //确诊诊断个数
                s MatchedAmount=0   //匹配成功个数
                

                s PatientJson={}  //用来记录患者疑似疾病匹配度
                s VisitID=""
                for
                {
                    s VisitID=$o(DiseaseDesc(LocDesc,UserDesc,PatientDR,VisitID))   //本次就诊当前患者推荐的疾病
                    q:VisitID=""
                    if $d(^User.DHCDSSDiagnosisInfoI("PatVisDRIndex",PatientDR))  //看是否存在当前患者
                    {
                        if $d(^User.DHCDSSDiagnosisInfoI("PatVisDRIndex",PatientDR,VisitID))  //是否当前就诊
                        {
                            s DIRowid=0
                            for
                            {
                                s DIRowid=$o(^User.DHCDSSDiagnosisInfoI("PatVisDRIndex",PatientDR,VisitID,DIRowid))
                                q:DIRowid=""
                                s DiagnosisName=$lg($g(^User.DHCDSSDiagnosisInfoD(DIRowid)),9)  //就诊信息表中疾病名称
                                s DiseaseAmount=DiseaseAmount+1
                                
                                
                                if $d(DiseaseDesc(LocDesc,UserDesc,PatientDR,VisitID,DiagnosisName))
                                {
                                    s MatchedAmount=MatchedAmount+1
                                }
                            }
                            s PatientScoreNum=PatientScoreNum+1    //统计有多少个病人
                        }
                    }
                }   
                //统计患者
                d PatientJson.%Set(PatientDR,MatchedAmount/DiseaseAmount)
                s PatientScores=PatientScores+MatchedAmount/DiseaseAmount    //统计患者所有的覆盖率
                
                d PatientArray.%Push(PatientJson)
                
            }
            if UserName'=""    //如果检索条件中用户不为空，则返回当前用户下所有患者的匹配度
            {
                return PatientArray.%ToJSON()
            }

            d UserJson.%Set(UserDesc,PatientScores/PatientScoreNum) 
            d UserArray.%Push(UserJson)
            s AllLocScore=AllLocScore+PatientScores/PatientScoreNum
        }
        //统计此科室下用户覆盖率平均值
        if Loc'=""    //如果科室不为空，则返回此科室下所有用户覆盖率的平均值
        {
            return UserArray.%ToJSON()
        }
        d LocJson.%Set(LocDesc,UserArray)
        d LocArray.%Push(LocJson)
        s AllLocScoreNum=AllLocScoreNum+1
        
    }
    //统计科室
    if AllLocScoreNum=0
    {
        q 0
    }
    else
    {
        q AllLocScore/AllLocScoreNum
    }
    
EachRow(FirstName,SecondName)
    if RecomType[Type
    {
        if RealLoc[Loc
        {
            if RecomUser[UserName
            {
                if RecomGrade[Star
                {
                    if (FirstName="检验") || (FirstName="检查")   //如果类目检验检查 则取亚目数据
                    {

                        s DiseaseDesc(RealLoc,RecomUser,PatientDR,VisitID,SecondName)=1

                    }
                    else
                    {
                        s DiseaseDesc(RealLoc,RecomUser,PatientDR,VisitID,FirstName)=1
                        s DiseaseDesc(RealLoc,RecomUser,PatientDR,VisitID,SecondName)=1
                    }
                    s flag=1
                }
            }
        }
    }
    q flag
}

/// Creator:李得原
/// CreatDate:2020-11-04
/// Description：推荐疑似疾病单一疾病逻辑
/// 入参：
/// 返回：
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).SingleSymptomLogic("胃肿瘤^胃肿瘤^1^门诊^13934^陈代雷^111^泌尿科^1") 
ClassMethod SingleSymptomLogic(PatientInfo As %String) As %String
{
	//20220304 wz 患者信息串传错（容错）+错误日志（先不加）
	try
	{
		s SymptomsString=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"症状","Symptom")
		s AgeJsonString=##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^"_"年龄")
		s GenderJsonString=##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^"_"性别")
	}
	catch e
	{
		return "0"
	}
	
	/*s SymptomsString=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"症状","Symptom")
	s AgeJsonString=##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^"_"年龄")
	s GenderJsonString=##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^"_"性别")*/
	
	if GenderJsonString'="[]"
	{
		s GenderJson=[].%FromJSON(GenderJsonString)
		s Gender=GenderJson.%Get(0).%Get("Sex")
	}
	else
	{
		s Gender=""
	}
	
	if AgeJsonString'="[]"
	{
		s AgeJson=[].%FromJSON(AgeJsonString)
		s Age=AgeJson.%Get(0).%Get("Age")
	}
	else
	{
		s Age=""
	}
	s SymptomsJson=[].%FromJSON(SymptomsString)
	s Symptoms=SymptomsJson.%Get("症状")
	if Symptoms=""
	{
		return "0"	
	}
	
	s SymList=""
	s Count=0
	for i=0:1:$l(Symptoms,"^^")
	{
		s TempSym=$p(Symptoms,"^^",i)
		continue:TempSym=""
		continue:TempSym="空"
		s Count=Count+1
		s SymList(TempSym)=""
	}
	if Count>2
	{
		return "0"     //多于两个症状 不走此逻辑
	}
	
	S RuleCode=0
	for
	{
		s RuleCode=$o(^User.DHCDSSSingleSymptomRuleI("TotalIndex",Count,RuleCode))    //获取症状个数为Count个的索引
		q:RuleCode=""
		
		s RuleRowid=$o(^User.DHCDSSSingleSymptomRuleI("TotalIndex",Count,RuleCode,0))
		s RuleGender=$lg($g(^User.DHCDSSSingleSymptomRuleD(RuleRowid)),9)    //性别
		if RuleGender'=""
		{
			continue:RuleGender'=Gender   //性别不匹配
		}
		s MinAge=$lg($g(^User.DHCDSSSingleSymptomRuleD(RuleRowid)),5)
		s MinAgeOpera=$lg($g(^User.DHCDSSSingleSymptomRuleD(RuleRowid)),6)
		
		s MaxAge=$lg($g(^User.DHCDSSSingleSymptomRuleD(RuleRowid)),7)
		s MaxAgeOpera=$lg($g(^User.DHCDSSSingleSymptomRuleD(RuleRowid)),8)
		if MinAge'=""
		{
			continue:Age=""              //如果当前患者年龄没获取到
			s Exp=Age_MinAgeOpera_MinAge
			if @Exp
			{
				
			}
			else
			{
				continue
			}
		}
		if MaxAge'=""
		{
			continue:Age=""           //如果当前患者年龄没获取到
			s Exp=Age_MaxAgeOpera_MaxAge
			if @Exp
			{}
			else
			{
				continue
			}
		}
		
		s flag="1"
		s SymptomList=$lg($g(^User.DHCDSSSingleSymptomRuleD(RuleRowid)),4)
		for j=1:1:$listlength(SymptomList)
		{
			s RuleSymptom=$lg(SymptomList,j) 
			//b:RuleSymptom="急性腹痛"
			
			continue:RuleSymptom=""
			if '$d(SymList(RuleSymptom)) 
			{
				s flag="0"
				q
			}
		}
		
		continue:flag="0"
		
		s RuleDiseases=$lg($g(^User.DHCDSSSingleSymptomRuleD(RuleRowid)),10)
		
		s Result=""
		for m=1:1:$listlength(RuleDiseases)
		{
			s Disease=$lg(RuleDiseases,m)
			
			s DiseaseName=$lg($g(^User.DHCDSSDiseaseDictD(Disease)),3)
			s DiseaseCode=$lg($g(^User.DHCDSSDiseaseDictD(Disease)),2)
			s:Result'="" Result=Result_"[N]"_DiseaseName_"[A]"_DiseaseCode
			s:Result="" Result=DiseaseName_"[A]"_DiseaseCode
		}
		return Result   //前面都没过滤掉，那你就赢了
	}
	return "0"
}

/// Creator:李得原
/// CreatDate:2020-11-04
/// Description：推荐疑似疾病单一疾病逻辑
/// 入参：
/// 返回：
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).SingleSymptomLogic2("测试用勿动-mao^测试用勿动^1^住院^6474^李得原^111^信息部^1") 
ClassMethod SingleSymptomLogic2(PatientInfo As %String) As %String
{
	s SymptomsString=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"症状","Symptom")
	s AgeJsonString=##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^"_"年龄")
	s GenderJsonString=##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^"_"性别")
	
	if GenderJsonString'="[]"
	{
		s GenderJson=[].%FromJSON(GenderJsonString)
		s Gender=GenderJson.%Get(0).%Get("Sex")
	}
	else
	{
		s Gender=""
	}
	
	if AgeJsonString'="[]"
	{
		s AgeJson=[].%FromJSON(AgeJsonString)
		s Age=AgeJson.%Get(0).%Get("Age")
	}
	else
	{
		s Age=""
	}
	s SymptomsJson=[].%FromJSON(SymptomsString)
	s Symptoms=SymptomsJson.%Get("症状")
	if Symptoms=""
	{
		return "0"	
	}
	
	s SymList=""
	s Count=0
	for i=0:1:$l(Symptoms,"^^")
	{
		s TempSym=$p(Symptoms,"^^",i)
		continue:TempSym=""
		continue:TempSym="空"
		s Count=Count+1
		s SymList(TempSym)=""
	}
	if Count>2
	{
		return "0"     //多于两个症状 不走此逻辑
	}
	
	S RuleCode=0
	for
	{
		s RuleCode=$o(^User.DHCDSSSingleSymptomRuleI("TotalIndex",Count,RuleCode))    //获取症状个数为Count个的索引
		q:RuleCode=""
		
		s RuleRowid=$o(^User.DHCDSSSingleSymptomRuleI("TotalIndex",Count,RuleCode,0))
		s RuleGender=$lg($g(^User.DHCDSSSingleSymptomRuleD(RuleRowid)),9)    //性别
		if RuleGender'=""
		{
			continue:RuleGender'=Gender   //性别不匹配
		}
		s MinAge=$lg($g(^User.DHCDSSSingleSymptomRuleD(RuleRowid)),5)
		s MinAgeOpera=$lg($g(^User.DHCDSSSingleSymptomRuleD(RuleRowid)),6)
		
		s MaxAge=$lg($g(^User.DHCDSSSingleSymptomRuleD(RuleRowid)),7)
		s MaxAgeOpera=$lg($g(^User.DHCDSSSingleSymptomRuleD(RuleRowid)),8)
		if MinAge'=""
		{
			continue:Age=""              //如果当前患者年龄没获取到
			s Exp=Age_MinAgeOpera_MinAge
			if @Exp
			{
				
			}
			else
			{
				continue
			}
		}
		if MaxAge'=""
		{
			continue:Age=""           //如果当前患者年龄没获取到
			s Exp=Age_MaxAgeOpera_MaxAge
			if @Exp
			{}
			else
			{
				continue
			}
		}
		
		s flag="1"
		s SymptomList=$lg($g(^User.DHCDSSSingleSymptomRuleD(RuleRowid)),4)
		for j=1:1:$listlength(SymptomList)
		{
			s RuleSymptom=$lg(SymptomList,j) 
			//b:RuleSymptom="急性腹痛"
			
			continue:RuleSymptom=""
			if '$d(SymList(RuleSymptom)) 
			{
				s flag="0"
				q
			}
		}
		
		continue:flag="0"
		
		s RuleDiseases=$lg($g(^User.DHCDSSSingleSymptomRuleD(RuleRowid)),10)
		
		s Result=""
		for m=1:1:$listlength(RuleDiseases)
		{
			s Disease=$lg(RuleDiseases,m)
			
			s DiseaseName=$lg($g(^User.DHCDSSDiseaseDictD(Disease)),3)
			s DiseaseCode=$lg($g(^User.DHCDSSDiseaseDictD(Disease)),2)
			s:Result'="" Result=Result_"[N]"_DiseaseName_"[A]"_DiseaseCode
			s:Result="" Result=DiseaseName_"[A]"_DiseaseCode
		}
		s Res = Result_"**"_Symptoms
		return Res   //前面都没过滤掉，那你就赢了  //前面都没过滤掉，那你就赢了
	}
	return "0"
}

/// Creator:李得原
/// CreatDate:2020-11-04
/// Description：推荐疑似疾病单一疾病逻辑
/// 入参：
/// 返回：
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).SingleSymptomLogicV2("测试用勿动-mao^测试用勿动^1^住院^6474^李得原^111^信息部^1") 
ClassMethod SingleSymptomLogicV2(PatientInfo As %String) As %String
{
	s SymptomsString=##class(web.CDSS.DiagDecision.RecomSusDiagData).ProcessPatientData(PatientInfo,"症状","Symptom")
	s AgeJsonString=##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^"_"年龄")
	s GenderJsonString=##class(web.CDSS.Public.PatientModelInterface).GetPatientEnumInfo(PatientInfo_"^"_"性别")

	if (GenderJsonString'="[]")&(GenderJsonString'="")
	{
		s GenderJson=[].%FromJSON(GenderJsonString)
		s Gender=GenderJson.%Get(0).%Get("Sex")
	}
	else
	{
		s Gender=""
	}
	
	if (AgeJsonString'="[]")&(AgeJsonString'="")
	{
		s AgeJson=[].%FromJSON(AgeJsonString)
		s Age=AgeJson.%Get(0).%Get("Age")
	}
	else
	{
		s Age=""
	}
	s SymptomsJson=[].%FromJSON(SymptomsString)
	s Symptoms=SymptomsJson.%Get("症状")
	if Symptoms=""
	{
		return "0"	
	}
	
	s SymList=""
	s Count=0
	for i=0:1:$l(Symptoms,"^^")
	{
		s TempSym=$p(Symptoms,"^^",i)
		continue:TempSym=""
		continue:TempSym="空"
		s Count=Count+1
		s SymList(TempSym)=""
	}
	if Count>2
	{
		return "0"     //多于两个症状 不走此逻辑
	}
	
	S RuleCode=0
	for
	{
		s RuleCode=$o(^CT.WDT.CDSS.SingleSymptomRuleI("TotalIndex",Count,RuleCode))    //获取症状个数为Count个的索引
		q:RuleCode=""
		
		s RuleRowid=$o(^CT.WDT.CDSS.SingleSymptomRuleI("TotalIndex",Count,RuleCode,0))
		s RuleGender=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),9)    //性别
		if RuleGender'=""
		{
			continue:RuleGender'=Gender   //性别不匹配
		}
		s MinAge=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),5)
		s MinAgeOpera=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),6)
		
		s MaxAge=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),7)
		s MaxAgeOpera=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),8)
		if MinAge'=""
		{
			continue:Age=""              //如果当前患者年龄没获取到
			s Exp=Age_MinAgeOpera_MinAge
			if @Exp
			{
				
			}
			else
			{
				continue
			}
		}
		if MaxAge'=""
		{
			continue:Age=""           //如果当前患者年龄没获取到
			s Exp=Age_MaxAgeOpera_MaxAge
			if @Exp
			{}
			else
			{
				continue
			}
		}
		
		s flag="1"
		s SymptomList=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),4)
		for j=1:1:$listlength(SymptomList)
		{
			s RuleSymptom=$lg(SymptomList,j) 
			//b:RuleSymptom="急性腹痛"
			
			continue:RuleSymptom=""
			if '$d(SymList(RuleSymptom)) 
			{
				s flag="0"
				q
			}
		}
		
		continue:flag="0"
		
		s RuleDiseases=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(RuleRowid)),10)
		
		s Result=""
		for m=1:1:$listlength(RuleDiseases)
		{
			s Disease=$lg(RuleDiseases,m)
			
			s DiseaseName=$lg($g(^CT.WDT.CDSS.DiseaseDictD(Disease)),3)
			s DiseaseCode=$lg($g(^CT.WDT.CDSS.DiseaseDictD(Disease)),2)
			s:Result'="" Result=Result_"[N]"_DiseaseName_"[A]"_DiseaseCode
			s:Result="" Result=DiseaseName_"[A]"_DiseaseCode
		}
		s Res = Result_"**"_Symptoms
		return Res   //前面都没过滤掉，那你就赢了  //前面都没过滤掉，那你就赢了
	}
	return "0"
}

/// Creator:伍哲
/// CreatDate:2022-03-04
/// Description：1.2推荐疑似疾病结果保存
/// Table：User.DHCDSSRecomDiseaseInfo
/// 入参：患者信息串，推荐疑似疾病结果 "[[],[]...]"
/// 返回： False: 患者信息串为空/疑似疾病为空/
/// w ##class(web.CDSS.DiagDecision.RecomSusDiagData).SaveSuspectResult("DH002^te002^1^门诊^^小明^^普外科^1","[['阑尾炎','伴随因子','I63.801','0.4','二星','','']]")
ClassMethod SaveSuspectResult(PatientInfo As %String, SuspectStr As %String) As %String
{
    q:(PatientInfo="")||(SuspectStr="")||(SuspectStr="[]") "False"
    //s SuspectStr=$REPLACE(SuspectStr,"'","""") //python列表中是 '
    //s SuspectStr=$REPLACE(SuspectStr,"None","""空""") //python""传入cache是None
    
    /*s IDNO=$p(PatientInfo,"^",1)     
    s PatientDR=$p(PatientInfo,"^",2)
    s VisitID=$p(PatientInfo,"^",3)
    s VisitType=$p(PatientInfo,"^",4)
    q:(IDNO="")||(PatientDR="")||(VisitID="")||(VisitType="") "False"
    s UserName=$p(PatientInfo,"^",6)
    s CTLocDesc=$p(PatientInfo,"^",8)
    s Config=$p(PatientInfo,"^",9)*/
    try
    {
	    s IDNO=$p(PatientInfo,"^",1)   //主索引  
	    s PatientDR=$p(PatientInfo,"^",2) //病人标识
	    s VisitID=$p(PatientInfo,"^",3) //就诊次数
	    s VisitType=$p(PatientInfo,"^",4) //就诊类型
	    return:(IDNO="")||(PatientDR="")||(VisitID="")||(VisitType="") "False"
	    
	    s UserName=$p(PatientInfo,"^",6) //医生性名
	    s CTLocDesc=$p(PatientInfo,"^",8) //科室
	    s Config=$p(PatientInfo,"^",9)
	    s RecomDescJson=[].%FromJSON(SuspectStr)
	}
	catch e
	{
		return "False"
	}
    
    s result=""
    //循环列表
    for i=0:1:RecomDescJson.%Size()-1
    {
        s ArrayItem=RecomDescJson.%Get(i)

        s FirstName=ArrayItem.%Get(0)   //疾病名称
        s ID=$o(^User.DHCDSSDiseaseDictI("NameIndex"," "_$ZCONVERT(FirstName,"U"),0)) //疾病ID
        continue:ID=""
        
        s SecondName=""
        s ICD=ArrayItem.%Get(2)  //疾病ICD编码
        s RecomGrade=ArrayItem.%Get(4)   //星级
        s RecomInfoType="推荐疑似疾病"   
        
        s tempArray={}
        d tempArray.%Set("id",ID) 
        d tempArray.%Set("text",FirstName) 
        d tempArray.%Set("icd",ICD) 
        d tempArray.%Set("star",RecomGrade)
        
        s obj=##class(User.DHCDSSRecomDiseaseInfo).%New()
        s obj.IDNO=IDNO  //主索引
        s obj.FirstName=FirstName
        s obj.PatientDR=PatientDR  //登记号
        s obj.RecomDate=$zdt($h,3)  //推荐时间
        s obj.RecomDept=CTLocDesc  //科室
        s obj.RecomDesc=tempArray.%ToJSON()
        s obj.RecomGrade=RecomGrade
        s obj.RecomInfoType=RecomInfoType
        s obj.RecomUser=UserName
        s obj.SecondName=SecondName
        s obj.VisitID=VisitID
        s obj.VisitType=VisitType
        
        s sc=obj.%Save()
        d obj.%Close()
        if $$$ISOK(sc)
        {
            
            s result="{success:'true',errorinfo:'保存成功！'}"
        }
        else
        {
            s result="False"
            continue
            //s result="{success:'false',errorinfo:'"_$system.OBJ.DisplayError(sc)_"'}"  //返回错误信息
        }
    }
    q result
}

}
