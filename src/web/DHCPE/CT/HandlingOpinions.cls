/// 名称:  web.DHCPE.CT.HandlingOpinions.cls
/// 描述:  职业健康体检 - 处理意见模板
/// 编写者： zhongricheng
/// 编写日期:  2021-08-14
/// 产品组： 体检
Class web.DHCPE.CT.HandlingOpinions Extends %RegisteredObject
{

/// Creator：      zhongricheng 
/// CreatDate：    2021-08-14 
/// Description：  保存处理意见模板  包括 新增、修改
/// Table：        DHC_PE_HandlingOpinions
/// Input：        Id (空 新增    非空 修改)  DataStr (代码^检查种类^检查结论^处理意见^顺序^激活^备注)
/// Return：       code -1 失败   msg 原因
/// Others：       w ##class(web.DHCPE.CT.HandlingOpinions).UpdateHandOpts("1","0a0B1^7^13^测试用^1^Y^备注")
ClassMethod UpdateHandOpts(Id, DataStr, SplitChar As %String = "^", LocId, USERID As %String = "") As %String
{
    q:(DataStr="") ..OutInfo(-1,"数据不能为空！")
    
    q:LocId="" ..OutInfo(-1, "未选择有效科室")
    
    s Code=$$ALPHAUP^SSUTIL4($p(DataStr,SplitChar,1))
    q:Code="" ..OutInfo(-1,"代码不能为空！")
    q:((Id="")&&($d(^User.DHCPEHandlingOpinionsI("HOCodeIndex"," "_Code)))) ..OutInfo(-1,"代码已存在！")
    q:((Id'="")&&($o(^User.DHCPEHandlingOpinionsI("HOCodeIndex"," "_Code,0))'=Id)) ..OutInfo(-1,"-1^代码已存在！")
    s Type=$p(DataStr,SplitChar,2)
    s Conclusion=$p(DataStr,SplitChar,3)
    q:Conclusion="" ..OutInfo(-1,"检查结论不能为空！")
    s Desc=$p(DataStr,SplitChar,4)
    q:Desc="" ..OutInfo(-1,"处理意见不能为空！")
    s Sort=$p(DataStr,SplitChar,5)
    q:Desc="" ..OutInfo(-1,"顺序不能为空！")
    s Active=$p(DataStr,SplitChar,6)
    s Remark=$p(DataStr,SplitChar,7)
    s tableName=$p(DataStr,SplitChar,8)
    
    s:USERID="" USERID=%session.Get("LOGON.USERID")
    
    if (Id'="") {
        s obj=##class(User.DHCPEHandlingOpinions).%OpenId(Id)
    } else {
        s obj=##class(User.DHCPEHandlingOpinions).%New()
    }
    
    s obj.HOCode=Code
    d obj.HOOMETypeDRSetObjectId(Type)
    d obj.HOConclusionDRSetObjectId(Conclusion)
    s obj.HODesc=Desc
    s obj.HOSort=Sort
    s obj.HOActive=Active
    s obj.HORemark=Remark
    s obj.HOUpdateDate=+$h
    s obj.HOUpdateTime=$p($h,",",2)
    s obj.HOUpdateUserDR=USERID
    
    TSTART
    s sc=obj.%Save()
    d obj.%Close()
    
    s ret=""
    if ($System.Status.IsError(sc)) {
        s msg=$System.Status.GetErrorText(sc)
        goto UpdateHandOptsErr
        q ret
    } else {
        s:Id="" ret=##class(User.DHCPEHandlingOpinions).SaveDataToPowerControl(obj.%Id(),LocId,USERID)
        i ($p(ret,"^",1)="-1") {
            s msg="插入记录授权表失败"
            goto UpdateHandOptsErr
            q ret
        }
        TCommit
        q ..OutInfo(obj.%Id())
    }
UpdateHandOptsErr
    TROLLBACK
    //s:msg="" msg="程序出错"_$ZE
    s ret=..OutInfo(-1, msg)
    q
}

/// Creator：      zhongricheng 
/// CreatDate：    2021-08-14 
/// Description：  删除处理意见模板  删除可能会导致 总检过的报告取不到处理意见
/// Table：        DHC_PE_HandlingOpinions
/// Input：        Id
/// Return：       
/// Others：       w ##class(web.DHCPE.HandlingOpinions).HODelete("","")
ClassMethod HODelete(ID) As %String
{
    s obj=##class(User.DHCPEHandlingOpinions).%New()
    s sc=obj.%DeleteId(Id)
    d obj.%Close()
    If ($System.Status.IsError(Id)) {
        q "-1^"_$System.Status.GetErrorText(sc)
    } else {
        q obj.%Id()
    }
}

/// Creator：      zhongricheng 
/// CreatDate：    2021-08-14 
/// Description：  处理意见模板
/// Table：        DHC_PE_HandlingOpinions
/// Input：        代码  检查结论  检查种类
/// Return：       
/// Others：       d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HandlingOpinions","SearchHandOpts","","","")
Query SearchHandOpts(Code As %Library.String = "", Conclusion As %Library.String = "", OMEType As %Library.String = "", Active As %Library.String = "Y", LocID As %Library.String = "", tableName As %String = "") As websys.Query(ROWSPEC = "TId:%String,TCode:%String,TOMEType:%String,TOMETypeDesc:%String,TConclusion:%String,TConclusionDesc:%String,TDesc:%String,TSort:%String,TActive:%String,TRemark:%String,Empower,TEffPowerFlag")
{
}

ClassMethod SearchHandOptsExecute(ByRef qHandle As %Binary, Code As %Library.String = "", Conclusion As %Library.String = "", OMEType As %Library.String = "", Active As %Library.String = "", LocID As %Library.String = "", tableName As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    
    s job=$j
    k TempDHCPEHO(job)
    if (Code'="") {
        s iCode=$$ALPHAUP^SSUTIL4(Code)
        i $d(^User.DHCPEHandlingOpinionsI("HOCodeIndex"," "_iCode)) d
        .s HOId=$o(^User.DHCPEHandlingOpinionsI("HOCodeIndex"," "_iCode,0))
        .q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
        .s iConclusion=$lg(^User.DHCPEHandlingOpinionsD(HOId),4)
        .q:((Conclusion'="")&&(Conclusion'=iConclusion))
        .s iOMEType=$lg(^User.DHCPEHandlingOpinionsD(HOId),3)
        .q:((OMEType'="")&&(OMEType'=iOMEType))
        .s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
        .s TempDHCPEHO(job,"Sort",iSort,HOId)=""
        
        s iCode=" "_iCode
        f  s iCode=$o(^User.DHCPEHandlingOpinionsI("HOCodeIndex",iCode)) q:((iCode="")||(("^"_iCode)'[("^ "_Code)))  d
        .s HOId=0
        .f  s HOId=$o(^User.DHCPEHandlingOpinionsI("HOCodeIndex",iCode,HOId)) q:HOId=""  d
        ..q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
        ..s iConclusion=$lg(^User.DHCPEHandlingOpinionsD(HOId),4)
        ..q:((Conclusion'="")&&(Conclusion'=iConclusion))
        ..s iOMEType=$lg(^User.DHCPEHandlingOpinionsD(HOId),3)
        ..q:((OMEType'="")&&(OMEType'=iOMEType))
        ..s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
        ..s TempDHCPEHO(job,"Sort",iSort,HOId)=""
    } elseif (Conclusion'="") {
        s HOId=0
        f  s HOId=$o(^User.DHCPEHandlingOpinionsI("HOConclusionIndex",Conclusion,HOId)) q:HOId=""  d
        .q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
        .s iOMEType=$lg(^User.DHCPEHandlingOpinionsD(HOId),3)
        .q:((OMEType'="")&&(OMEType'=iOMEType))
        .s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
        .s TempDHCPEHO(job,"Sort",iSort,HOId)=""
    } elseif (OMEType'="") {
        s HOId=0
        f  s HOId=$o(^User.DHCPEHandlingOpinionsI("HOOMETypeIndex",OMEType,HOId)) q:HOId=""  d
        .q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
        .s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
        .s TempDHCPEHO(job,"Sort",iSort,HOId)=""
    } else {
        s HOId=0
        f  s HOId=$o(^User.DHCPEHandlingOpinionsD(HOId)) q:HOId=""  d
        .q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
        .s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
        .s TempDHCPEHO(job,"Sort",iSort,HOId)=""
    }
    
    if ('$d(TempDHCPEHO(job))) {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    
    s TSort=""
    f  s TSort=$o(TempDHCPEHO(job,"Sort",TSort)) q:TSort=""  d
    .s TId=0
    .f  s TId=$o(TempDHCPEHO(job,"Sort",TSort,TId)) q:TId=""  d
    ..s TCode=$lg(^User.DHCPEHandlingOpinionsD(TId),2)
    ..s TOMEType=$lg(^User.DHCPEHandlingOpinionsD(TId),3)
    ..s TOMETypeDesc=""
    ..s:TOMEType'="" TOMETypeDesc=$lg(^User.DHCPEOMETypeD(TOMEType),3)
    ..s TConclusion=$lg(^User.DHCPEHandlingOpinionsD(TId),4)
    ..s TConclusionDesc=""
    ..s:TConclusion'="" TConclusionDesc=$lg(^User.DHCPEConclusionD(TConclusion),3)
    ..s TDesc=$lg(^User.DHCPEHandlingOpinionsD(TId),5)
    ..s TSort=$lg(^User.DHCPEHandlingOpinionsD(TId),6)
    ..s TActive=$lg(^User.DHCPEHandlingOpinionsD(TId),7)
    ..s TRemark=$lg(^User.DHCPEHandlingOpinionsD(TId),8)
    ..s LocShowDFlag=##class(User.DHCPEHandlingOpinions).GetLocShowDataFlag(TId,LocID)
    ..q:LocShowDFlag="N"
    ..s EmpowerStr=##class(User.DHCPEHandlingOpinions).GetEmpowerFlag(TId,LocID)
    ..s Empower=$p(EmpowerStr,"^",2)
    ..;s EmpowerLoc=$p(EmpowerStr,"^",3)
    ..s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    ..d OutHandOptsData
    
    k TempDHCPEHO(job)
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutHandOptsData      
    set Data=$lb(TId,TCode,TOMEType,TOMETypeDesc,TConclusion,TConclusionDesc,TDesc,TSort,TActive,TRemark,Empower,EffPowerFlag)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

/// Creator：        zhongricheng
/// CreatDate：      2021-08-04
/// Description：    输出json格式字符串
/// Table：
/// Input：          code 代码  msg 信息
/// Return：     {"code":"1","msg":"成功"}
/// dubug：          w ##class(web.DHCPE.CT.Conclusion).OutInfo("1","3")
ClassMethod OutInfo(code, msg As %String = "")
{
    s json={}
    s json.code=code
    s json.msg=msg
    q json.%ToJSON()
}

/// Creator：      xueying
/// CreatDate：    2022-03-09 
/// Description：  获取有效授权的处理意见模板
/// Table：        DHC_PE_HandlingOpinions
/// Input：        代码  检查结论  检查种类
/// Return：       
/// Others：       d ##class(%ResultSet).RunQuery("web.DHCPE.CT.HandlingOpinions","SearchEffHandOpts","","","")
Query SearchEffHandOpts(Code As %Library.String = "", Conclusion As %Library.String = "", OMEType As %Library.String = "", Active As %Library.String = "Y", LocID As %Library.String = "", tableName As %String = "") As websys.Query(ROWSPEC = "TId:%String,TCode:%String,TOMEType:%String,TOMETypeDesc:%String,TConclusion:%String,TConclusionDesc:%String,TDesc:%String,TSort:%String,TActive:%String,TRemark:%String,Empower,TEffPowerFlag")
{
}

ClassMethod SearchEffHandOptsExecute(ByRef qHandle As %Binary, Code As %Library.String = "", Conclusion As %Library.String = "", OMEType As %Library.String = "", Active As %Library.String = "", LocID As %Library.String = "", tableName As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set ind=1
    if $d(%session) {
        set langId=%session.Get("LOGON.LANGID")
    }
    else
    { s langId=""}
    s ^tempdhcpe("SearchEffHandOpts")=$lb(Code,Conclusion,OMEType,Active,LocID,tableName)
    s job=$j
    k TempEffDHCPEHO(job)
    if (Code'="") {
        s iCode=$$ALPHAUP^SSUTIL4(Code)
        i $d(^User.DHCPEHandlingOpinionsI("HOCodeIndex"," "_iCode)) d
        .s HOId=$o(^User.DHCPEHandlingOpinionsI("HOCodeIndex"," "_iCode,0))
        .q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
        .s iConclusion=$lg(^User.DHCPEHandlingOpinionsD(HOId),4)
        .q:((Conclusion'="")&&(Conclusion'=iConclusion))
        .s iOMEType=$lg(^User.DHCPEHandlingOpinionsD(HOId),3)
        .q:((OMEType'="")&&(OMEType'=iOMEType))
        .s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
        .s TempEffDHCPEHO(job,"Sort",iSort,HOId)=""
        
        s iCode=" "_iCode
        f  s iCode=$o(^User.DHCPEHandlingOpinionsI("HOCodeIndex",iCode)) q:((iCode="")||(("^"_iCode)'[("^ "_Code)))  d
        .s HOId=0
        .f  s HOId=$o(^User.DHCPEHandlingOpinionsI("HOCodeIndex",iCode,HOId)) q:HOId=""  d
        ..q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
        ..s iConclusion=$lg(^User.DHCPEHandlingOpinionsD(HOId),4)
        ..q:((Conclusion'="")&&(Conclusion'=iConclusion))
        ..s iOMEType=$lg(^User.DHCPEHandlingOpinionsD(HOId),3)
        ..q:((OMEType'="")&&(OMEType'=iOMEType))
        ..s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
        ..s TempEffDHCPEHO(job,"Sort",iSort,HOId)=""
    } elseif (Conclusion'="") {
        s HOId=0
        f  s HOId=$o(^User.DHCPEHandlingOpinionsI("HOConclusionIndex",Conclusion,HOId)) q:HOId=""  d
        .q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
        .s iOMEType=$lg(^User.DHCPEHandlingOpinionsD(HOId),3)
        .q:((OMEType'="")&&(OMEType'=iOMEType))
        .s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
        .s TempEffDHCPEHO(job,"Sort",iSort,HOId)=""
    } elseif (OMEType'="") {
        s HOId=0
        f  s HOId=$o(^User.DHCPEHandlingOpinionsI("HOOMETypeIndex",OMEType,HOId)) q:HOId=""  d
        .q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
        .s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
        .s TempEffDHCPEHO(job,"Sort",iSort,HOId)=""
    } else {
        s HOId=0
        f  s HOId=$o(^User.DHCPEHandlingOpinionsD(HOId)) q:HOId=""  d
        .q:((Active'="")&&(Active'=$lg(^User.DHCPEHandlingOpinionsD(HOId),7)))
        .s iSort=$lg(^User.DHCPEHandlingOpinionsD(HOId),6)
        .s TempEffDHCPEHO(job,"Sort",iSort,HOId)=""
    }
    
    if ('$d(TempEffDHCPEHO(job))) {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    
    s TSort=""
    f  s TSort=$o(TempEffDHCPEHO(job,"Sort",TSort)) q:TSort=""  d
    .s TId=0
    .f  s TId=$o(TempEffDHCPEHO(job,"Sort",TSort,TId)) q:TId=""  d
    ..s TCode=$lg(^User.DHCPEHandlingOpinionsD(TId),2)
    ..s TOMEType=$lg(^User.DHCPEHandlingOpinionsD(TId),3)
    ..s TOMETypeDesc=""
    ..s:TOMEType'="" TOMETypeDesc=$lg(^User.DHCPEOMETypeD(TOMEType),3)
    ..s TConclusion=$lg(^User.DHCPEHandlingOpinionsD(TId),4)
    ..s TConclusionDesc=""
    ..s:TConclusion'="" TConclusionDesc=$lg(^User.DHCPEConclusionD(TConclusion),3)
    ..s TDesc=$lg(^User.DHCPEHandlingOpinionsD(TId),5)
    ..s TDesc=##class(User.DHCPEHandlingOpinions).GetTranByDesc("HODesc",TDesc,langId)
    ..s TSort=$lg(^User.DHCPEHandlingOpinionsD(TId),6)
    ..s TActive=$lg(^User.DHCPEHandlingOpinionsD(TId),7)
    ..s TRemark=$lg(^User.DHCPEHandlingOpinionsD(TId),8)
    ..s LocShowDFlag=##class(User.DHCPEHandlingOpinions).GetLocShowDataFlag(TId,LocID)
    ..q:LocShowDFlag'="Y"
    ..s EmpowerStr=##class(User.DHCPEHandlingOpinions).GetEmpowerFlag(TId,LocID)
    ..s Empower=$p(EmpowerStr,"^",2)
    ..s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    ..d OutEffHandOptsData
    
    k TempEffDHCPEHO(job)
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutEffHandOptsData      
    set Data=$lb(TId,TCode,TOMEType,TOMETypeDesc,TConclusion,TConclusionDesc,TDesc,TSort,TActive,TRemark,Empower,EffPowerFlag)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

}
