Import SQLUser

/// 名称: 医院  
/// 描述: 医院，包含增删改查功能
/// 编写者：基础数据平台组 、蔡昊哲
/// 创建日期: 2012-8-17
Class web.DHCBL.CT.CTHospital Extends %RegisteredObject
{

/// Creator：蔡昊哲
/// CreatDate: 2012-8-17
/// Description：查询医院的内容
/// Table：User.CTHospital
/// Input：rowid,code,desc,InternalType,query(用于combox查询)
Query GetList(rowid As %String, code As %String, desc As %String, active As %String, communityid As %String) As %Query(ROWSPEC = "HOSPRowId,HOSPCode,HOSPDesc,HOSPDateFrom,HOSPDateTo,HOSPMandatoryRefHospital,HOSPShortDesc1,HOSPShortDesc2,HOSPAddress,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,HOSPDefaultHospitalDR,HOSPClinDR,HOSPNationalCode,HOSPNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, active As %String, communityid As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
    s AuStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    s HospitalDRs = ##class(web.DHCBL.BDP.BDPGradeManage).GetHospital(communityid)
    if (rowid'="") //根据rowid返回该条记录
    {
        s HOSPRowId=rowid
        s HOSPCode=$p($g(^CT("HOSP",HOSPRowId)),"^",1)
        s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
        s HOSPDateFrom=$p($g(^CT("HOSP",HOSPRowId)),"^",9)
        s HOSPDateTo=$p($g(^CT("HOSP",HOSPRowId)),"^",10)
        s HOSPMandatoryRefHospital=$p($g(^CT("HOSP",HOSPRowId)),"^",20)
        s HOSPShortDesc1=$p($g(^CT("HOSP",HOSPRowId)),"^",39)
        s HOSPShortDesc2=$p($g(^CT("HOSP",HOSPRowId)),"^",40)
        s HOSPDefaultHospitalDR=$p($g(^CT("HOSP",HOSPRowId)),"^",41)    //默认医院  20200429 lkf
        s:HOSPDefaultHospitalDR'="" HOSPDefaultHospitalDR=$p($g(^CT("HOSP",HOSPDefaultHospitalDR)),"^",2)   //默认医院描述
        s:HOSPDefaultHospitalDR="" HOSPDefaultHospitalDR=HOSPDesc   //如果默认医院为空，则显示它本身   20200509    lkf
        s HOSPClinDR=$p($g(^CT("HOSP",HOSPRowId)),"^",42)   //医疗机构 2020-12-10
        s:HOSPClinDR'="" HOSPClinDR=$p($g(^CT("RFC",HOSPClinDR)),"^",2)     //医疗机构描述
        s HOSPNationalCode=$p($g(^CT("HOSP",HOSPRowId)),"^",7)  //定点医疗机构代码
        s HOSPNationalDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",43)  //定点医疗机构名称
        s HOSPAddress=$p($g(^CT("HOSP",HOSPRowId)),"^",18)  // 详细地址
        s HOSPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HOSPDateFrom)
        s HOSPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HOSPDateTo)
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Hospital",HOSPRowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
        d OutputRow
    }
    else
    {
        k OutputList    //清空输出数组
        s HOSPRowId=0
        for  
        {   
            s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""
            s strRowId = "{ID:"_HOSPRowId_"}"
            i ((AuStr[strRowId)||(AuFlag=1))&((AuHospStr="off")||(AuHospStr[strRowId)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s HOSPCode=$p($g(^CT("HOSP",HOSPRowId)),"^",1)
                s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
                s HOSPDefaultHospitalDR=$p($g(^CT("HOSP",HOSPRowId)),"^",41)    //默认医院  20200429 lkf
                s:HOSPDefaultHospitalDR="" HOSPDefaultHospitalDR=HOSPRowId      //如果默认医院为空，则为它本身
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Hospital",HOSPRowId,HOSPDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                } 
                
                s HospitalRowId = "<"_HOSPRowId_">"
                i ($$ALPHAUP^SSUTIL4(HOSPCode)[code)&(AliasFlag=1)
                {
                    if (communityid'="")
                    {
                        if (HospitalDRs[HospitalRowId) //d OutputRow
                        {
                            s OutputList(HOSPDefaultHospitalDR,HOSPRowId)=""
                        }
                    }
                    else
                    {
                        //d OutputRow
                        s OutputList(HOSPDefaultHospitalDR,HOSPRowId)=""
                    }
                }
            }
        }
        //按照医院组默认医院排序 20200509 lkf
        s DefSequence=0
        for
        {
            s DefSequence=$o(OutputList(DefSequence)) q:DefSequence=""
            s HOSPRowId=0
            for
            {
                s HOSPRowId=$o(OutputList(DefSequence,HOSPRowId)) q:HOSPRowId=""
                s HOSPCode=$p($g(^CT("HOSP",HOSPRowId)),"^",1)
                s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
                s HOSPDateFrom=$p($g(^CT("HOSP",HOSPRowId)),"^",9)
                s HOSPDateTo=$p($g(^CT("HOSP",HOSPRowId)),"^",10)
                s HOSPMandatoryRefHospital=$p($g(^CT("HOSP",HOSPRowId)),"^",20)
                s HOSPShortDesc1=$p($g(^CT("HOSP",HOSPRowId)),"^",39)  //简称1
                s HOSPShortDesc2=$p($g(^CT("HOSP",HOSPRowId)),"^",40)  //简称2
                s HOSPDefaultHospitalDR=$p($g(^CT("HOSP",HOSPRowId)),"^",41)    //默认医院  20200429 lkf
                s:HOSPDefaultHospitalDR'="" HOSPDefaultHospitalDR=$p($g(^CT("HOSP",HOSPDefaultHospitalDR)),"^",2)   //默认医院描述
                s:HOSPDefaultHospitalDR="" HOSPDefaultHospitalDR=HOSPDesc   //如果默认医院为空，则显示它本身   20200509    lkf
                s HOSPClinDR=$p($g(^CT("HOSP",HOSPRowId)),"^",42)   //医疗机构 2020-12-10
                s:HOSPClinDR'="" HOSPClinDR=$p($g(^CT("RFC",HOSPClinDR)),"^",2)     //医疗机构描述
                s HOSPNationalCode=$p($g(^CT("HOSP",HOSPRowId)),"^",7)  //定点医疗机构代码
                s HOSPNationalDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",43)  //定点医疗机构名称
                s HOSPAddress=$p($g(^CT("HOSP",HOSPRowId)),"^",18)  // 详细地址
                s HOSPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HOSPDateFrom)
                s HOSPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(HOSPDateTo)
                s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
                s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_Hospital",HOSPRowId)
                s BDPInternalCode =$p($g(resultStr),"^",1)       
                s BDPInternalDesc = $p($g(resultStr),"^",2)  
                s BDPHospNationalCode=$p($g(resultStr),"^",3)         
                s BDPHospNationalDesc = $p($g(resultStr),"^",4)
                d OutputRow
            }
        }
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(HOSPRowId,HOSPCode,HOSPDesc,HOSPDateFrom,HOSPDateTo,HOSPMandatoryRefHospital,HOSPShortDesc1,HOSPShortDesc2,HOSPAddress,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc,HOSPDefaultHospitalDR,HOSPClinDR,HOSPNationalCode,HOSPNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Function:进行数据检索，为combo查询提供接口
/// CreateDate:2012-08-30
/// Creator:基础数据平台  蔡昊哲 
/// Table:User.CTHospital
/// Input: rowid, code 
/// Output:  HOSPRowId,HOSPCode,HOSPDesc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHospital", "GetDataForCmb1","")
/// 获取医院信息
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, active As %String, communityid As %String) As %Query(ROWSPEC = "HOSPRowId,HOSPCode,HOSPDesc")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, active As %String, communityid As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    //获取授权Json
    s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
    s AuStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s HospitalDRs = ##class(web.DHCBL.BDP.BDPGradeManage).GetCurrentHospital(communityid)
     //2021-12-01前台下拉框 增加调翻译接口
    Set langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    s Languages=""
    s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
    if (rowid'="") //根据rowid返回该条记录
    {
        s HOSPRowId=rowid
        s HOSPCode=$p($g(^CT("HOSP",HOSPRowId)),"^",1)
        s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
        s:Languages'="" HOSPDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTHospital","HOSPDesc",Languages,HOSPDesc)
        d OutputRow1
    }
    else
    {
        s AuFlag=0
        if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
        s HOSPRowId=0
        for  
        {   
            s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""
            s strRowId = "{ID:"_HOSPRowId_"}"
            i ((AuStr[strRowId)||(AuFlag=1))&((AuHospStr="off")||(AuHospStr[strRowId)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s HOSPCode=$p($g(^CT("HOSP",HOSPRowId)),"^",1)
                s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
                s:Languages'="" HOSPDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTHospital","HOSPDesc",Languages,HOSPDesc)
                s HOSPDateFrom=$p($g(^CT("HOSP",HOSPRowId)),"^",9)
                s HOSPDateTo=$p($g(^CT("HOSP",HOSPRowId)),"^",10)
                continue:(HOSPDateFrom'="")&&(HOSPDateFrom>+$h)
                continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h)
                /*
                s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Hospital",HOSPRowId,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                }
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(HOSPDesc))
                */
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Hospital",HOSPRowId,HOSPDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                } 
                    
                s HospitalDR = "<"_HOSPRowId_">"
                /*(($$ALPHAUP^SSUTIL4(HOSPDesc)[desc)||(ALIASText1[desc)||(PINYIN[desc))*/  
                i ($$ALPHAUP^SSUTIL4(HOSPCode)[code)&(AliasFlag=1)
                {
                    if (communityid'=""){
                        if (HospitalDRs[HospitalDR) d OutputRow1
                    }else{
                        d OutputRow1
                    }
                }
            }
        }
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow1
    set Data=$lb(HOSPRowId,HOSPCode,HOSPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Function:进行数据检索，为combo查询提供接口，包含未归属医院
/// CreateDate:2023-02-13
/// Creator:基础数据平台  gss 
/// Table:User.CTHospital
/// Input: rowid, code 
/// Output:  HOSPRowId,HOSPCode,HOSPDesc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTHospital", "GetDataForCmb2","")
/// 获取医院信息
Query GetDataForCmb2(rowid As %String, code As %String, desc As %String, active As %String, communityid As %String) As %Query(ROWSPEC = "HOSPRowId,HOSPCode,HOSPDesc")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, active As %String, communityid As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    //获取授权Json
    s AuHospStr=##class(web.DHCBL.Authorize.BDPHospitalAut).GetHospAutFlag()
    s AuStr=##class(web.DHCBL.Authorize.CTHospital).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s HospitalDRs = ##class(web.DHCBL.BDP.BDPGradeManage).GetCurrentHospital(communityid)
     //2021-12-01前台下拉框 增加调翻译接口
    Set langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    s Languages=""
    s:langid'="" Languages=$p($g(^SS("LAN",langid)),"^",1)
    if (rowid'="") //根据rowid返回该条记录
    {
        s HOSPRowId=rowid
        s HOSPCode=$p($g(^CT("HOSP",HOSPRowId)),"^",1)
        s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
        s:Languages'="" HOSPDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTHospital","HOSPDesc",Languages,HOSPDesc)
        d OutputRow2
    }
    else
    {
        s AuFlag=0
        if AuStr="" s AuFlag=1 //判断是否有授权,如果没有则全部显示
        s HOSPRowId=0
        for  
        {   
            s HOSPRowId=$o(^CT("HOSP",HOSPRowId)) q:HOSPRowId=""
            s strRowId = "{ID:"_HOSPRowId_"}"
            i ((AuStr[strRowId)||(AuFlag=1))&((AuHospStr="off")||(AuHospStr[strRowId)||(AuHospStr=1)) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s HOSPCode=$p($g(^CT("HOSP",HOSPRowId)),"^",1)
                s HOSPDesc=$p($g(^CT("HOSP",HOSPRowId)),"^",2)
                s:Languages'="" HOSPDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("User.CTHospital","HOSPDesc",Languages,HOSPDesc)
                s HOSPDateFrom=$p($g(^CT("HOSP",HOSPRowId)),"^",9)
                s HOSPDateTo=$p($g(^CT("HOSP",HOSPRowId)),"^",10)
                continue:(HOSPDateFrom'="")&&(HOSPDateFrom>+$h)
                continue:(HOSPDateTo'="")&&(HOSPDateTo<+$h)
                if (desc'="")
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Hospital",HOSPRowId,HOSPDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                } 
                    
                s HospitalDR = "<"_HOSPRowId_">" 
                i ($$ALPHAUP^SSUTIL4(HOSPCode)[code)&(AliasFlag=1)
                {
                    if (communityid'=""){
                        if (HospitalDRs[HospitalDR) d OutputRow2
                    }else{
                        d OutputRow2
                    }
                }
            }
        }
        s HOSPRowId="0",HOSPDesc="未归属医院"
        d OutputRow2
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow2
    set Data=$lb(HOSPRowId,HOSPCode,HOSPDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching...
        Set AtEnd=1
        Set Row=""
    }
    Else
    {
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

/// Creator:蔡昊哲
/// CreatDate:2013-8-30
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class("web.DHCBL.CT.CTHospital").GetRefFlag(50)
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
    s flag1=0
    s ParRef=0
    f  s ParRef=$o(^SSU("SSUSR",ParRef)) q:ParRef=""  d 
    .s ChildSub =0
    .f  s ChildSub=$o(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)) q:ChildSub=""  d 
    ..s OTHLLHospitalDR=$p($g(^SSU("SSUSR",ParRef,"OTHLL",ChildSub)),"^",3)
    ..i OTHLLHospitalDR=id  s flag1=1
    if (flag1) s myInfo=myInfo_"<其他登录科室表>" ;SSUserOtherLogonLoc
    
    i $d( ^CTLOC(0,"Hosp",+id))  s myInfo=myInfo_"<科室表>"   ;CTLoc
    
    s flag2=0
    S LLRowId=0
    f  s ParRef=$o(^CT("LL",ParRef)) q:ParRef=""  d
    .s ChildSub =0
    .f  s ChildSub=$o(^CT("LL",ParRef,"LOC",ChildSub)) q:ChildSub=""  d 
    ..s HospitalCTDR=$P($g(^CT("LL",ParRef,"LOC",ChildSub)),"^",2)
    ..i OTHLLHospitalDR=id s flag2=1
    if (flag2) s myInfo=myInfo_"<科室列表-关联科室表>"  ;CTLocationListLocations
    
    
    s flag3=0
    s ParRef=0
    f  s ParRef=$o(^OEC("ORCAT",ParRef)) q:ParRef=""  d 
    .s ChildSub =0
    .f  s ChildSub=$o(^OEC("ORCAT",ParRef,"RL",ChildSub)) q:ChildSub=""  d
    ..s RLCTHospitalDR=$p($g(^OEC("ORCAT",ParRef,"RL",ChildSub)),"^",7)
    ..i RLCTHospitalDR=id s flag3=1
    if (flag3) s myInfo=myInfo_"<医嘱大类-接收科室表>"  ;OECOrdCatRecLoc
    
    s flag4=0
    s ParRef=0
    f  s ParRef=$o(^ARC("IC",ParRef)) q:ParRef=""  d 
    .s ChildSub =0
    .f  s ChildSub=$o(^ARC("IC",ParRef,"RL",ChildSub)) q:ChildSub=""  d
    ..s RLCTHospitalDR=$p($g(^ARC("IC",ParRef,"RL",ChildSub)),"^",7)
    ..i RLCTHospitalDR=id s flag4=1
    if (flag4) s myInfo=myInfo_"<医嘱子类-接收科室表>" ;ARCItemCatRecLoc
        
    s flag5=0
    s ParRef=0
    f  s ParRef=$o(^CTPCP(ParRef)) q:ParRef=""  d 
    .s ChildSub =0
    .f  s ChildSub=$o(^CTPCP(ParRef,"HOSP",ChildSub)) q:ChildSub=""  d
    ..s HOSPHospitalDR=$p($g(^CTPCP(ParRef,"HOSP",ChildSub)),"^",1)
    ..i HOSPHospitalDR=id s flag5=1
    if (flag5) s myInfo=myInfo_"<医护人员-医院关联>" ;CTCareProvHospitals
    
    s flag6=0
    s SSUSRRowId=0
    f  s SSUSRRowId=$o(^SSU("SSUSR",SSUSRRowId)) q:SSUSRRowId=""  d
    .s SSUSRHospitalDR=$p($g(^SSU("SSUSR",SSUSRRowId)),"^",98) 
    .i SSUSRHospitalDR=id s flag6=1
    if (flag6) s myInfo=myInfo_"<用户-医院关联>" ;SSUser
    if myInfo=""
    {
	    s flag7=0
	    s ParRef=0
	    f  s ParRef=$o(^SSU("SSGRP",ParRef)) q:ParRef=""  d 
	    .s ChildSub =0
	    .f  s ChildSub=$o(^SSU("SSGRP",ParRef,"HOSP",ChildSub)) q:ChildSub=""  d
	    ..s HOSPHospitalDR=$p($g(^SSU("SSGRP",ParRef,"HOSP",ChildSub)),"^",1)
	    ..i HOSPHospitalDR=id s flag7=1
	    if (flag7) s myInfo=myInfo_"<安全组-医院>" ;SSGroupHospitals
    }
    if myInfo=""
    {
	    s flag8=0
	    s parref=0
	    f  s parref=$o(^ARCIM(parref)) q:parref=""  d
	    .s version=0
	    .f  s version=$o(^ARCIM(parref,version)) q:version=""  d
	    ..s ChildSub =0
	    ..f  s ChildSub=$o(^ARCIM(parref,version,"HOSP",ChildSub)) q:ChildSub=""  d
	    ...s HOSPHospitalDR=$p($g(^ARCIM(parref,version,"HOSP",ChildSub)),"^",1)
	    ...i HOSPHospitalDR=id s flag8=1
	    if (flag8) s myInfo=myInfo_"<医嘱项维护-医院关联>" ;ARCItemHosp
    }
    if myInfo=""
    {
	    
	    s ANCOCRowId=0
	    for
	    {
	        s ANCOCRowId=$o(^ORC("OPER",ANCOCRowId)) q:(ANCOCRowId="")
	        s OPERHospitalDrs=$p($g(^ORC("OPER",ANCOCRowId,"DHC")),"^",24)    ;ORCOperationExtend
	        if (OPERHospitalDrs'=""){
	            s loclength=$Length(OPERHospitalDrs,"|")
	            for i=1:1:loclength
	            {
	                s OPERHospitalDr=$p(OPERHospitalDrs,"|",i)
	                if (OPERHospitalDr=id)
	                {
	                    s myInfo=myInfo_"<手术/过程-扩展信息>" 
	                } 
	            }       
	        }   
	    }
    }
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator：蔡昊哲
/// CreatDate: 2012-10-31
/// Description：根据ID医院内容
/// Table：User.CTHospital
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
    s result = ""
    
    s re=##class(web.DHCBL.CT.CTHospital).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Ts
        s pobj = ##class(User.CTHospital).%OpenId(id)
        s eobj = ##class(web.Entity.CT.CTHospital).%New()
        s eobj.HOSPCode = id
        s eobj.HOSPDesc = pobj.HOSPDesc
        s eobj.HOSPShortDesc1= pobj.HOSPShortDesc1
        s eobj.HOSPShortDesc2= pobj.HOSPShortDesc2
        s eobj.HOSPDateFrom= pobj.HOSPDateFrom
        s eobj.HOSPDateTo= pobj.HOSPDateTo
        S eobj.HOSPMandatoryRefHospital= pobj.HOSPMandatoryRefHospital
        s:pobj.HOSPDefaultHospitalDR'="" eobj.HOSPDefaultHospitalDR = pobj.HOSPDefaultHospitalDR.%Id()  //默认医院 20200429 lkf
        s:pobj.HOSPClinDR'="" eobj.HOSPClinDR = pobj.HOSPClinDR.%Id()   //医疗机构 2020-12-10
        s eobj.HOSPNationalCode= pobj.HOSPNationalCode
        s eobj.HOSPNationalDesc= pobj.HOSPNationalDesc
        s eobj.HOSPAddress=pobj.HOSPAddress 
        s sc=##class(User.CTHospital).%DeleteId(id)
        if $$$ISOK(sc)
        {
            tc
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Hospital","User.CTHospital","医院",id,eobj.HOSPDesc,"D",eobj)
            s result = "{success:'true',info:'删除成功！'}"
        }
        else
        {
            tro
            s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院","web.DHCBL.CT.CTHospital","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    }
    
    q result
}

/// Function:双击时显示弹出窗口的信息
/// CreateDate:2012-08-30
/// Creator:基础数据平台公共产品组 蔡昊哲
/// Input:输入sid
/// Table:User.CTHospital
/// Other:w ##class(web.DHCBL.CT.CTHospital).OpenData(52)
ClassMethod OpenData(id As %String) As %String
{
    s str=""
    s pobj = ##class(User.CTHospital).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTHospital).%New()
    s eobj.HOSPRowId=id
    s eobj.HOSPCode = pobj.HOSPCode
    s eobj.HOSPDesc = pobj.HOSPDesc
    s eobj.HOSPShortDesc1= pobj.HOSPShortDesc1
    s eobj.HOSPShortDesc2= pobj.HOSPShortDesc2
    ;s:pobj.HOSPDateFrom'="" eobj.HOSPDateFrom=$zd(pobj.HOSPDateFrom,1)
    ;s:pobj.HOSPDateTo'="" eobj.HOSPDateTo=$zd(pobj.HOSPDateTo,1)
    s:pobj.HOSPDateFrom'="" eobj.HOSPDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.HOSPDateFrom)
    s:pobj.HOSPDateTo'="" eobj.HOSPDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.HOSPDateTo)
    S:pobj.HOSPMandatoryRefHospital="Y" eobj.HOSPMandatoryRefHospital="true"
    s:pobj.HOSPDefaultHospitalDR'="" eobj.HOSPDefaultHospitalDR = pobj.HOSPDefaultHospitalDR.%Id()  //默认医院  20200429    lkf
    s:pobj.HOSPDefaultHospitalDR="" eobj.HOSPDefaultHospitalDR = id     //如果默认医院为空，则显示它自己   20200509    lkf
    s:pobj.HOSPClinDR'="" eobj.HOSPClinDR = pobj.HOSPClinDR.%Id()   //医疗机构 2020-12-10
    s eobj.HOSPNationalCode= pobj.HOSPNationalCode
    s eobj.HOSPNationalDesc= pobj.HOSPNationalDesc
    s eobj.HOSPAddress=pobj.HOSPAddress
    d pobj.%Close()
    k pobj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 蔡昊哲 
/// CreateDate:2012-12-13
/// Table:CT_Hospital    
/// w ##class(web.DHCBL.CT.CTHospital).FormValidate("50","BJDTYY","北京地坛医院")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag=0
    if $$ALPHAUP^SSUTIL4(code)'=""
    {
        s idc=0
        for
        {
            s idc=$o(^CT("HOSP",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
            if (idc'=id)&&($p($g(^CT("HOSP",idc)),"^",1)=code)
            {
                s flag=1
            }
        }
    }
    
    if $$ALPHAUP^SSUTIL4(desc)'=""
    {
        s idd=0
        for
        {
    
            s idd=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
            if (idd'=id)&&($p($g(^CT("HOSP",idd)),"^",2)=desc)
            {
                s flag=1
            }
        }
    }
    q flag
}

/// Creator：蔡昊哲
/// CreatDate: 2012-10-26
/// Description：保存医院信息
/// Table：User.CTHospital
/// Input：Entity
ClassMethod SaveEntity(eobj As web.Entity.CT.CTHospital) As %String
{
    s result=""
    if $IsObject(eobj)
    {
        s:eobj.HOSPMandatoryRefHospital="" eobj.HOSPMandatoryRefHospital="N"
        s:eobj.HOSPDateFrom'="" eobj.HOSPDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HOSPDateFrom)  //转换日期
        s:eobj.HOSPDateTo'="" eobj.HOSPDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.HOSPDateTo)     //转换日期
        ;s:eobj.HOSPDateFrom'="" eobj.HOSPDateFrom=$zdh(eobj.HOSPDateFrom,15)  //转换日期
        ;s:eobj.HOSPDateTo'="" eobj.HOSPDateTo=$zdh(eobj.HOSPDateTo,15)      //转换日期
        s:eobj.HOSPDateFrom="" eobj.HOSPDateFrom=+$h
        s flag=##class(web.DHCBL.CT.CTHospital).FormValidate(eobj.HOSPRowId,eobj.HOSPCode,eobj.HOSPDesc)
        if (flag=1)
        {
            q "{success:'false',errorinfo:'代码或者描述已经存在，请重新填写！'}"
        }
        if (eobj.HOSPRowId="")       
        {
            //RowId未赋值,增加
            s obj=##class(User.CTHospital).%New()
        }
        else                           
        {
            //RowId已存在,修改
            s obj=##class(User.CTHospital).%OpenId(eobj.HOSPRowId)
            s bobj=##class(web.Entity.CT.CTHospital).%New()
            s bobj.HOSPRowId=eobj.HOSPRowId
            s bobj.HOSPCode = obj.HOSPCode                     
            s bobj.HOSPDesc= obj.HOSPDesc                     
            s bobj.HOSPDateFrom = obj.HOSPDateFrom 
            s bobj.HOSPDateTo=obj.HOSPDateTo
            s bobj.HOSPMandatoryRefHospital=obj.HOSPMandatoryRefHospital 
            s bobj.HOSPShortDesc1= obj.HOSPShortDesc1
            s bobj.HOSPShortDesc2= obj.HOSPShortDesc2
            s:obj.HOSPDefaultHospitalDR'="" bobj.HOSPDefaultHospitalDR = obj.HOSPDefaultHospitalDR.%Id() 
            s:obj.HOSPClinDR'="" bobj.HOSPClinDR = obj.HOSPClinDR.%Id() 
            s bobj.HOSPNationalCode= obj.HOSPNationalCode
            s bobj.HOSPNationalDesc= obj.HOSPNationalDesc
            s bobj.HOSPAddress=obj.HOSPAddress
        }
        s obj.HOSPCode = eobj.HOSPCode                      //修改代码
        s obj.HOSPDesc= eobj.HOSPDesc                      //修改描述
        s obj.HOSPShortDesc1= eobj.HOSPShortDesc1
        s obj.HOSPShortDesc2= eobj.HOSPShortDesc2
        s obj.HOSPDateFrom = eobj.HOSPDateFrom 
        s obj.HOSPDateTo=eobj.HOSPDateTo
        s obj.HOSPMandatoryRefHospital=eobj.HOSPMandatoryRefHospital 
        d obj.HOSPDefaultHospitalDRSetObjectId(eobj.HOSPDefaultHospitalDR)  //默认医院  20200429 lkf
        d obj.HOSPClinDRSetObjectId(eobj.HOSPClinDR)    //医疗机构 2020-12-10
        s obj.HOSPNationalCode= eobj.HOSPNationalCode
        s obj.HOSPAddress=eobj.HOSPAddress
        s obj.HOSPNationalDesc= eobj.HOSPNationalDesc
        Tstart
        s sc=obj.%Save()
        do obj.%Close()
        if $$$ISOK(sc){
            Tcommit
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
            if eobj.HOSPRowId="" d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Hospital","User.CTHospital","医院",id,eobj.HOSPDesc,"A",eobj)
            if eobj.HOSPRowId'="" d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Hospital","User.CTHospital","医院",eobj.HOSPRowId,eobj.HOSPDesc,"U",eobj,bobj)
        
            
        }else{
            Trollback
            s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"    //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("医院","web.DHCBL.CT.CTHospital","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")  
        }   
                            
        
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }   
    q result
}

/// 基础数据平台-李可凡
/// 2020年6月12日
/// 保存时判断是否需要密码校验
/// input：医院代码hospcode，日期date
/// output：1：是  0：其他情况
/// w ##class(web.DHCBL.CT.CTHospital).SavePasswordFlag("105","2020-06-12","105")
ClassMethod SavePasswordFlag(hosprowid As %String, date As %String, defhospdr As %String) As %String
{
    s flag=0
    s HOSPDefaultHospitalDR=$p($g(^CT("HOSP",hosprowid)),"^",41)    //医院组默认医院
    if (HOSPDefaultHospitalDR'="")&&(HOSPDefaultHospitalDR'=defhospdr)
    {
        s date=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(date)  //转换日期
        s:(date'=+$h) flag=1
    }
    q flag
}

/// 基础数据平台-李可凡
/// 2020年6月12日
/// 生成密码，并进行密码校验
/// input：选中医院代码，密码
/// output：1：校验不通过      0：校验通过
/// w ##class(web.DHCBL.CT.CTHospital).CheckPassword("111","9E0B35519B0E4472DAF27187FE3C3BE9")
ClassMethod CheckPassword(hospcode As %String, password As %String) As %String
{
    s flag=0
    s Today=$zd(+$h,3)
    s Password=Today_"+"_hospcode
    //产生密码所需信息：系统日期，选中医院代码
    //w ##class(web.Util.Encryption).MD5HexStr("2020-06-12+111")
    s PasswordMD5=##class(web.Util.Encryption).MD5HexStr(Password)
    s:PasswordMD5'=password flag=1
    q flag
}

/// Function:获取医院信息
/// CreateDate:2020-12-09
/// Creator: sunfengchao
/// Input:    HospId:医院Id   如果入参为空 则返回默认的数据
/// Output:  医院代码^医院名称^机构代码^机构名称^统一社会信用代码^行政区划代码^行政区划名称
/// Debug:  w ##class(web.DHCBL.CT.CTHospital).GetHospInfo("")
ClassMethod GetHospInfo(HospId As %String = "") As %String
{
    s result="^^^^"
    s:HospId="" HospId=$o(^CT("HOSP",0))
    q:HospId="" result
    s OrgId=$p($g(^CT("HOSP",HospId)),"^",42) // 取 医院关联的 医疗机构 id  
    if (OrgId'="")
    {
        s HOSPCode=$p($g(^CT("HOSP",HospId)),"^",1) // 医院代码
        s HOSPDesc=$p($g(^CT("HOSP",HospId)),"^",2) // 医院名称
        s OrgCode=$p($g(^CT("RFC",OrgId)),"^",1) //机构代码  
        s OrgName=$p($g(^CT("RFC",OrgId)),"^",2) // 机构名称  
        s SocialcreditCode = $p($g(^CT("RFC",OrgId,"EXT")),"^",17) /// 统一社会信用代码  
        s CTRFCCityAreaDR=$p($g(^CT("RFC",OrgId)),"^",10) 
        s DistrictsName=""
        s DistrictsCode=""
        if (CTRFCCityAreaDR'="") // 取 城市区域
        {
            s DistrictsCode=$p($g(^CT("CITAREA",CTRFCCityAreaDR)),"^",1)   //行政区划代码   
            s DistrictsName=$p($g(^CT("CITAREA",CTRFCCityAreaDR)),"^",2) // 行政区划名称 
        }     
        else  
        {
           s CTRFCCityDR=$p($g(^CT("RFC",OrgId)),"^",9)  // 取城市
           if (CTRFCCityDR'="")
           {
               s DistrictsCode=$p($g(^CT("CIT",CTRFCCityDR)),"^",1) //行政区划代码   
               s DistrictsName=$p($g(^CT("CIT",CTRFCCityDR)),"^",2)  //行政区划名称
           } 
        }
        s result=HOSPCode_"^"_HOSPDesc_"^"_OrgCode_"^"_OrgName_"^"_SocialcreditCode_"^"_DistrictsCode_"^"_DistrictsName 
    } 
    
    q result
}

/// Function: 根据医院rowid获取定点医疗机构编码
/// Creator:陈莹
/// CreateDate: 2022-06-30
/// Input:RowId:医院rowid
/// Return :定点医疗机构编码
/// Debug: w ##class(web.DHCBL.CT.CTHospital).GetInsuCodeByRowId("1")
ClassMethod GetInsuCodeByRowId(RowId) As %String
{
	q:RowId="" ""
	s OrgCode=$p($g(^CT("HOSP",RowId)),"^",7)  //定点医疗机构代码   HOSPNationalCode
	q OrgCode
}

/// Function: 根据医院rowid获取定点医疗机构名称
/// Creator:陈莹
/// CreateDate:  2022-06-30
/// Input:RowId: 医院rowid
/// Return :定点医疗机构名称
/// Debug: w ##class(web.DHCBL.CT.CTHospital).GetInsuName("1")
ClassMethod GetInsuName(RowId) As %String
{
	q:RowId="" ""
	s OrgName=$p($g(^CT("HOSP",RowId)),"^",43)  //定点医疗机构名称   HOSPNationalDesc
    s:OrgName="" OrgName=$p($g(^CT("HOSP",RowId)),"^",2)
	q OrgName
}

/// Function: 根据医院rowid获取定点医疗机构编码和定点医疗机构名称
/// Creator:陈莹
/// CreateDate: 2022-06-30
/// Input:医院rowid
/// Return:定点医疗机构编码^定点医疗机构名称
/// Debug:w ##class(web.DHCBL.CT.CTHospital).GetStdInsuInfo("2")
ClassMethod GetStdInsuInfo(RowId As %String) As %String
{
	s $ZT="ErrorStd"
	q:RowId="" ""
	s OrgCode="",OrgName=""
	s OrgCode=$p($g(^CT("HOSP",RowId)),"^",7)  //定点医疗机构代码   HOSPNationalCode
	s OrgName=$p($g(^CT("HOSP",RowId)),"^",43)  //定点医疗机构名称   HOSPNationalDesc 
	s:OrgName="" OrgName=$p($g(^CT("HOSP",RowId)),"^",2) 
	s InsuStr=OrgCode_"^"_OrgName
	q InsuStr
ErrorStd
	q "-1^"_$ZE
}

}
