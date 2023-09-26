/// 质量管理类
Class web.DHCPE.CT.QualityManager Extends %RegisteredObject
{

// SaveInfo PAADM^ErrType^ErrDetail^Remark^ErrUserDR^UserDR

// d ##class(web.DHCPE.CT.QualityManager).Save("","213^2^错误信息^备注^933^933")

ClassMethod Save(ID, SaveInfo)
{
    if ID'="" d
    .s Obj=##class(User.DHCPEQualityManager).%OpenId(ID)
    .s Obj.QMUpdateDate=+$H
    .s Obj.QMUpdateTime=$P($H,",",2)
    .d Obj.QMUpdateUserDRSetObjectId($P(SaveInfo,"^",6))
    else  d
    .s Obj=##class(User.DHCPEQualityManager).%New()
    .s Obj.QMCreateDate=+$H
    .s Obj.QMCreateTime=$P($H,",",2)
    .d Obj.QMCreateUserDRSetObjectId($P(SaveInfo,"^",6))
    d Obj.QMPAADMDRSetObjectId($P(SaveInfo,"^",1))
    d Obj.QMErrTypeDRSetObjectId($P(SaveInfo,"^",2))
    s Obj.QMErrDetail=$P(SaveInfo,"^",3)
    s Obj.QMRemark=$P(SaveInfo,"^",4)
    d Obj.QMErrUserDRSetObjectId($P(SaveInfo,"^",5))
    s Obj.QMStatus="N"
    d Obj.QMOrderDRSetObjectId($P(SaveInfo,"^",7))
    
    s sc=Obj.%Save()
    d Obj.%Close()
    If ($System.Status.IsError(sc)) 
    {
        q "-1^"_$System.Status.GetErrorText(sc)
    }else{
        q Obj.%Id()
    }
}

ClassMethod Delete(ID, UserID)
{
    s Obj=##class(User.DHCPEQualityManager).%OpenId(ID)
    s OldStatus=Obj.QMStatus
    q:OldStatus="D" "-1^记录已经是删除状态，不允许操作"
    s Obj.QMUpdateDate=+$H
    s Obj.QMUpdateTime=$P($H,",",2)
    d Obj.QMUpdateUserDRSetObjectId(UserID)
    s Obj.QMStatus="D"
    s sc=Obj.%Save()
    d Obj.%Close()
    If ($System.Status.IsError(sc)) 
    {
        q "-1^"_$System.Status.GetErrorText(sc)
    }else{
        q Obj.%Id()
    }
}

/// Creator：      sxt 
/// CreatDate：    20210808
/// Description: 质量管理错误类型维护
/// Table：       质量管理错误类型表 User.DHCPEQMType  DHC_PE_QMType
/// Input:       ID:rowid,SaveInfo:Code：代码^Desc：描述^Remark：备注^ExpStr:扩展信息^ActiveFlag：激活, GroupID 安全组, Type 0 新增 1 删除,tablename,sessionUser,Active,ID rowid
/// Return：
/// Dubug: w ##class(web.DHCPE.CT.QualityManager).SaveQMType("1","101^科室录入111^^SR^Y","18853")
ClassMethod SaveQMType(ID, SaveInfo, SessionUser)
{
    s ^TMP("DHCPE","SaveQMType")=$LB(ID, SaveInfo, SessionUser)
    s $ZT="SaveQMTypeErr"
    s result=1
    
    S Code=$P(SaveInfo,"^",1)
    S Desc=$P(SaveInfo,"^",2)
    s QMCode="",QMDesc=""
    
    if (ID="") d
    .s Obj=##class(User.DHCPEQMType).%New()
    e  d
    .s OldRecord=$ListToString($g(^User.DHCPEQMTypeD(ID)))
    .s Obj=##class(User.DHCPEQMType).%OpenId(ID)
    .s QMCode=$LG(^User.DHCPEQMTypeD(ID),2)
    .S QMDesc=$LG(^User.DHCPEQMTypeD(ID),3)
    q:(QMCode'=Code)&($d(^User.DHCPEQMTypeI("QMTCodeIndex"," "_Code))) "0^代码重复!"
    q:(QMDesc'=Desc)&($d(^User.DHCPEQMTypeI("QMTDescIndex"," "_Desc))) "0^错误类型重复!"
    
    s Obj.QMTCode=$P(SaveInfo,"^",1)
    s Obj.QMTDesc=$P(SaveInfo,"^",2)
    s Obj.QMTRemark=$P(SaveInfo,"^",3)
    s Obj.QMTExpStr=$P(SaveInfo,"^",4)
    s Obj.QMTActiveFlag=$P(SaveInfo,"^",5)
    s Obj.QMTUpdateDate=+$H
    s Obj.QMTUpdateTime=$P($h,",",2)
    s Obj.QMTUpdateUserDR=SessionUser
    
    TSTART
    s sc=Obj.%Save()
    d Obj.%Close()
    If ($System.Status.IsError(sc))  
    {
        i ID'="" s result="-1^修改数据失败"
        e  s result="-1^新增数据失败"
        goto SaveQMTypeErr
        
    }else{
        s RowID=Obj.%Id()
        if (ID=""){ 
            s result="0^新增成功"
            s OldRecord=""
            s NewRecord=$ListToString($g(^User.DHCPEQMTypeD(RowID)))
            s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_QMType",RowID,"I",OldRecord,NewRecord,SessionUser)
            if ($p(Logret,"^",1)="-1"){
                s result="-1^插入新增数据日志失败"_$p(Logret,"^",2)
                goto SaveQMTypeErr
            }
        }else{
            s result="0^修改成功"
            s NewRecord=$ListToString($g(^User.DHCPEQMTypeD(RowID)))
            if (OldRecord'=NewRecord) {
                s Logret=##class(web.DHCPE.CT.BaseLog).InsertRecordLog("DHC_PE_QMType",RowID,"U",OldRecord,NewRecord,SessionUser)
                if ($p(Logret,"^",1)="-1"){
                    s result="-1^插入更新数据日志失败"_$p(Logret,"^",2)
                    goto SaveQMTypeErr
                }
            }
        }     
                
        
    }
      
    TCommit
      q result  
SaveQMTypeErr
    TROLLBACK 
    //q $ZE
    q result
}

/// Creator：     xy 
/// CreatDate：  20211203
/// Description: 获取质量错误类型编码
/// Input:       ID(质量错误类型ID)
/// Debug: d ##class(web.DHCPE.CT.QualityManager).GetQMTypeCode("")
ClassMethod GetQMTypeCode(ID As %String = "")
{
    q:ID="" ""
    q:'$d(^User.DHCPEQMTypeD(ID)) ""
    S Code=$LG($G(^User.DHCPEQMTypeD(ID)),6)
    q Code
}

/// Creator：     xy 
/// CreatDate：  20211203
/// Description: 根据就诊ID获取对应的项目
/// Input:       PAADM(就诊ID), UserID(用户ID)
/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCPE.CT.QualityManager","FindItemByPAADM","4800","12187")
Query FindItemByPAADM(PAADM As %String = "", UserID As %String = "") As websys.Query(ROWSPEC = "ItemID:%String,ARCIMDesc:%String")
{
}

ClassMethod FindItemByPAADMExecute(ByRef qHandle As %Binary, PAADM As %String = "", UserID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 
    s ^tempdhcpe("FindItemByPAADM")=$lb(PAADM,UserID)
    
    d ##Class(web.DHCPE.ReportGetInfor).GetReportResultQM(PAADM,UserID)
    s STSequence=""
    f  s STSequence=$O(^TMPReport(UserID,"Result","Station",STSequence)) q:STSequence=""  d
    .s STRowId=""
    .f  s STRowId=$O(^TMPReport(UserID,"Result","Station",STSequence,STRowId)) q:STRowId=""  d
    ..s ARCSequence=""
    ..f  s ARCSequence=$O(^TMPReport(UserID,"Result","Station",STSequence,STRowId,ARCSequence)) q:ARCSequence=""  d
    ...s ItemSort=""
    ...f  s ItemSort=$O(^TMPReport(UserID,"Result","Station",STSequence,STRowId,ARCSequence,ItemSort)) q:ItemSort=""  d
    ....s OEOrdItemID=$G(^TMPReport(UserID,"Result","Station",STSequence,STRowId,ARCSequence,ItemSort))
    ....s Info=$G(^TMPReport(UserID,"Result","ARCIM",OEOrdItemID))
    ....s ARCIMDesc=$P(Info,"^",1)
    ....s ARCIMDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.ARCItmMast",ARCIMDesc,"ARCIMDesc","cls")
    ....s ^CacheTemp(repid,ind)=$lb(OEOrdItemID,ARCIMDesc)
    ....s ind=ind+1 
    
    k ^TMPReport(UserID,"Result")
    k ^TMPReport(UserID,"LabSpecNo")
    k ^TMPReport(UserID,"GetResultByLoc")
    k ^TMPReport(UserID,"NoResult")
    k ^TMPReport(UserID,"RefuseCheck")
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
}

/// Description: 得到总检、复检的名字
/// Dubug: w ##class(web.DHCPE.CT.QualityManager).GetGenName("213","GR")
ClassMethod GetGenName(PAADM, ExpStr)
{
    s GSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
    b ;GSID,!
    s UserID="",UserName=""
    q:GSID="" UserID_"^"_UserName
    i ExpStr="GR"{
        s UserID=$P(^DHCPEGS(GSID,1),"^",5)
    }elseif ExpStr="GA"{
        s UserID=$G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM))
        s UserID=$P(UserID,"^",1)
    }
    s:UserID'="" UserName=$P(^SSU("SSUSR",UserID),"^",2)
    q UserID_"^"_UserName
}

/// Creator：      xy 
/// CreatDate：   20211112
/// Description:  显示质量管理错误类型（使用数据，只有授权的科室才显示）
/// Table：       质量错误类型表 DHC_PE_QMType
/// Input:        LocID (科室ID)
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.QualityManager", "SearchQMType","")
Query SearchQMType(LocID) As %Query(ROWSPEC = "Code:%String,Desc:%String,ActiveFlag:%String,Remark:%String,ExpStr:%String,ID:%String,TEffPowerFlag:%String")
{
}

ClassMethod SearchQMTypeExecute(ByRef qHandle As %Binary, LocID) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s ^tempdhcpe("SearchQMType")=$lb(LocID)
    S ID=""
    f  s ID=$O(^User.DHCPEQMTypeD(ID))  Q:ID=""  d
    .s LocShowDFlag = ##class(User.DHCPEQMType).GetLocShowDataFlag(ID,LocID)
    .q:LocShowDFlag'="Y"
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .s Code=$lg($g(^User.DHCPEQMTypeD(ID)),2)
    .s Desc=$lg($g(^User.DHCPEQMTypeD(ID)),3)
    .s Desc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEQMType",Desc,"QMTDesc","cls")
    .S ActiveFlag=$lg($g(^User.DHCPEQMTypeD(ID)),4)
    .S Active="否"
    .i ActiveFlag="Y" S Active="是"
    .s Remark=$lg($g(^User.DHCPEQMTypeD(ID)),5)
    .S QMTExpStr=$lg($g(^User.DHCPEQMTypeD(ID)),6)
    .d FindBuildQMType
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    q
FindBuildQMType  
    set Data=$lb(Code,Desc,Active,Remark,QMTExpStr,ID,EffPowerFlag)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchQMTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchQMTypeExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod SearchQMTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchQMTypeExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      xy 
/// CreatDate：   20211112
/// Description:  查询质量管理错误类型（维护数据，所有数据都显示）
/// Table：       质量错误类型表 DHC_PE_QMType
/// Input:        LocID (科室ID)
/// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.QualityManager", "SearchQMTypeNew","")
Query SearchQMTypeNew(LocID) As %Query(ROWSPEC = "Code:%String,Desc:%String,ActiveFlag:%String,Remark:%String,ExpStr:%String,ID:%String,TEffPowerFlag:%String")
{
}

ClassMethod SearchQMTypeNewExecute(ByRef qHandle As %Binary, LocID) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s ^tempdhcpe("SearchQMTypeNew")=$lb(LocID)
    S ID=""
    f  s ID=$O(^User.DHCPEQMTypeD(ID))  Q:ID=""  d
    .s LocShowDFlag = ##class(User.DHCPEQMType).GetLocShowDataFlag(ID,LocID)
    .q:LocShowDFlag="N"
    .s EffPowerFlag=$s(LocShowDFlag="Y":"Y",1:"N")
    .s Code=$lg($g(^User.DHCPEQMTypeD(ID)),2)
    .s Desc=$lg($g(^User.DHCPEQMTypeD(ID)),3)
    .S ActiveFlag=$lg($g(^User.DHCPEQMTypeD(ID)),4)
    .S Active="否"
    .i ActiveFlag="Y" S Active="是"
    .s Remark=$lg($g(^User.DHCPEQMTypeD(ID)),5)
    .S QMTExpStr=$lg($g(^User.DHCPEQMTypeD(ID)),6)
    .d FindBuildQMTypeNew
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    q
FindBuildQMTypeNew 
    set Data=$lb(Code,Desc,Active,Remark,QMTExpStr,ID,EffPowerFlag)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchQMTypeNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchQMTypeNewExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod SearchQMTypeNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchQMTypeNewExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/*
Query SearchAllErrByPAADM(PAADM As %String = "") As %SQLQuery(ROWSPEC = "TID:%String,TQMTypeID:%String,TQMType:%String,TQMTExpStr:%String,TErrDetail:%String,TRemark:%String,TErrUserID:%String,TErrUser:%String,TCreateUserID:%String,TCreateUser:%String,TCreateDate:%String,TUpdateUser:%String,TUpdateDate:%String,TItemID:%String,TARCIMDesc:%String")
{
 select ID,QM_Type_DR,QM_Type_DR->QMT_Desc,QM_Type_DR->QMT_ExpStr,QM_ErrDetail,QM_Remark,QM_ErrUser_DR,QM_ErrUser_DR->SSUSR_Name,QM_CreateUser_DR,QM_CreateUser_DR->SSUSR_Name,QM_CreateDate,QM_UpdateUser_DR->SSUSR_Name,QM_UpdateDate,QM_Order_DR,QM_Order_DR->OEORI_ItmMast_DR->ARCIM_Desc
 from Sqluser.DHC_PE_QualityManager where QM_Status="N" and QM_PAADM_DR=:PAADM
}
*/
Query SearchAllErrByPAADM(PAADM As %String = "") As %Query(ROWSPEC = "TID:%String,TQMTypeID:%String,TQMType:%String,TQMTExpStr:%String,TErrDetail:%String,TRemark:%String,TErrUserID:%String,TErrUser:%String,TCreateUserID:%String,TCreateUser:%String,TCreateDate:%String,TUpdateUser:%String,TUpdateDate:%String,TItemID:%String,TARCIMDesc:%String,TSatus:%String")
{
}

ClassMethod SearchAllErrByPAADMExecute(ByRef qHandle As %Binary, PAADM As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    S ID=""
    f  s ID=$O(^User.DHCPEQualityManagerI("PAADMIndex",PAADM,ID))  Q:ID=""  D
    .s TQMTypeDR=$LG(^User.DHCPEQualityManagerD(ID),3)
    .q:TQMTypeDR=""
    .q:'$d(^User.DHCPEQMTypeD(TQMTypeDR))
    .s TQMType=$LG(^User.DHCPEQMTypeD(TQMTypeDR),3)
    .S QMTExpStr=$LG(^User.DHCPEQMTypeD(TQMTypeDR),6)
    .s TErrDetail=$LG(^User.DHCPEQualityManagerD(ID),4)
    .s TRemark=$LG(^User.DHCPEQualityManagerD(ID),5)
    .s TErrUserID=$LG(^User.DHCPEQualityManagerD(ID),6)
    .s:TErrUserID'="" TErrUser=$P($g(^SSU("SSUSR",TErrUserID)),"^",2)
    .s TCreateUserID=$LG(^User.DHCPEQualityManagerD(ID),7)
    .s:TCreateUserID'="" TCreateUser=$P($g(^SSU("SSUSR",TCreateUserID)),"^",2)
    .s TCreateDate=$LG(^User.DHCPEQualityManagerD(ID),8)
    .i TCreateDate'="" s TCreateDate=##class(websys.Conversions).DateLogicalToHtml(TCreateDate)
    .s TSatus=""
    .s TSatus=$LG(^User.DHCPEQualityManagerD(ID),10)
    .s:TSatus="N" TSatus="正常"
    .s:TSatus="D" TSatus="删除"
    .s TUpdateUserID=$LG(^User.DHCPEQualityManagerD(ID),11)
    .s:TUpdateUserID'="" TUpdateUser=$P($g(^SSU("SSUSR",TUpdateUserID)),"^",2)
    .s TUpdateDate=$LG(^User.DHCPEQualityManagerD(ID),12)
    .i TUpdateDate'="" s TUpdateDate=##class(websys.Conversions).DateLogicalToHtml(TUpdateDate)
    .s ItemID="",ARCIMDesc=""
    .S ItemID=$LG(^User.DHCPEQualityManagerD(ID),14)
    .I ItemID'="" D
    ..S ItmMastDR=$P($G(^OEORD($P(ItemID,"||",1),"I",$P(ItemID,"||",2),1)),"^",2)
    ..I ItmMastDR'=""  S ARCIMDesc=$p($g(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1)),"^",2)
    .d FindBuildQualityManager
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    q
FindBuildQualityManager   
    set Data=$lb(ID,TQMTypeDR,TQMType,QMTExpStr,TErrDetail,TRemark,TErrUserID,TErrUser,TCreateUserID,TCreateUser,TCreateDate,TUpdateUser,TUpdateDate,ItemID,ARCIMDesc,TSatus)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchAllErrByPAADMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchAllErrByPAADMExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod SearchAllErrByPAADMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchAllErrByPAADMExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.QualityManager", "FindErrDetail","213","SA")

Query FindErrDetail(PAADM As %Library.String = "", ExpStr As %Library.String = "", ItemID As %Library.String = "") As %Query(ROWSPEC = "STDesc:%String:科室,ErrDetail:%String:错误信息,UserID:%String:错误人ID,UserName:%String:错误人")
{
}

ClassMethod FindErrDetailExecute(ByRef qHandle As %Binary, PAADM As %Library.String = "", ExpStr As %Library.String = "", ItemID As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
    s ind=1
    i ExpStr="SR"{
        i IADM=""{
            
        }else{
            s RLTID=0
            f  s RLTID=$O(^DHCPERLT(0,"OEORI",ItemID,RLTID)) q:RLTID=""  d
            .d OutSRInfoBySSID
        }
    }
    i ExpStr="SA"{
        i IADM=""{
            
        }else{
            s STID=""
            f  s STID=$O(^DHCPESS(0,"IADM",IADM,STID)) q:STID=""  d
            .s STDesc=$P(^DHCPEST(STID),"^",2)
            .s SSID=""
            .f  s SSID=$O(^DHCPESS(0,"IADM",IADM,STID,SSID)) q:SSID=""  d
            ..d OutSAInfoBySSID
        }
    }
    i (ExpStr="GA")||((ExpStr="GR")){
        s GSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
        i GSID=""{
            Set qHandle=$lb(0,repid,0)
            Quit $$$OK
        }
        s GSSub=0
        f  s GSSub=$O(^DHCPEGS(GSID,"Diagnosis",GSSub)) q:GSSub=""  d
        .s Status=$P(^DHCPEGS(GSID,"Diagnosis",GSSub),"^",11)
        .q:Status="2"
        .d OutGInfoBySSDID
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutGInfoBySSDID
    q:(ExpStr="GA")&&('$D(^DHCPEDataEx("DHCPEGeneralSummarize","ReCheckDetail",GSID_"||"_GSSub)))
    s Advice=$P(^DHCPEGS(GSID,"Diagnosis",GSSub),"^",9)
    s EDDesc=$g(^DHCPEDataEx("DHCPEGSDiagnosis","DisplayDesc",GSID_"||"_GSSub))
    s ErrDetail=EDDesc_":"_Advice
    s UserID=""
    s UserName=""
    s STDesc=""
    i ExpStr="GR" d
    .i GSID'="" s UserID=$p(^DHCPEGS(GSID,1),"^",5)
    .i UserID'="" s UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)
    
    i ExpStr="GA" d
    .s UserID=$p($G(^DHCPEDataEx("DHCPEGeneralSummarize","MainDoctor",PAADM)),"^",1)
    .i UserID'="" s UserName=$p($g(^SSU("SSUSR",UserID)),"^",2)
    d FindBuild
    q
OutSRInfoBySSID 
    s ARCIMID=$P(^DHCPERLT(RLTID),"^",2)
    s ARCIMDesc=""
    s:ARCIMID'="" ARCIMDesc=$P(^ARCIM(+ARCIMID,1,1),"^",3)
    s STID=$o(^DHCPEST(0,"STORD_ARCIM",ARCIMID,"")) 
    s STDesc=""                   
    s STDesc=$P($g(^DHCPEST(STID)),"^",2)
    s ODID=$P(^DHCPERLT(RLTID),"^",3)
    s ODDesc=""
    s:ODID'="" ODDesc=$P(^DHCPEST(+ODID,"OD",$P(ODID,"||",2)),"^",1)
    s Result=$P(^DHCPERLT(RLTID),"^",4)
    s ErrDetail=ARCIMDesc_":"_ODDesc_":"_Result
    s UserID=$P(^DHCPERLT(RLTID),"^",5)
    s:UserID'="" UserName=$P(^SSU("SSUSR",UserID),"^",2)
    d FindBuild 
    q
OutSAInfoBySSID
    s SDSub=0
    f  s SDSub=$O(^DHCPESS(SSID,"Diagnosis",SDSub)) q:SDSub=""  d
    .s Advice=$P(^DHCPESS(SSID,"Diagnosis",SDSub),"^",7)
    .s EDDesc=$g(^DHCPEDataEx("DHCPESSDiagnosis","DisplayDesc",SSID_"||"_SDSub))
    .s ErrDetail=EDDesc_":"_Advice
    .s UserID=$P(^DHCPESS(SSID,"Diagnosis",SDSub),"^",3)
    .s UserName=$P(^SSU("SSUSR",UserID),"^",2)
    .d FindBuild    
    q
FindBuild      
    set Data=$lb(STDesc,ErrDetail,UserID,$G(UserName))
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod FindErrDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindErrDetailExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindErrDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindErrDetailExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.CT.QualityManager", "FindQualityManager","2015-01-01","2015-05-01")

Query FindQualityManager(StartDate As %Library.String = "", EndDate As %Library.String = "", VIPLevel As %String = "", Type As %String = "", ErrUserID As %String = "", CreateUserID As %String = "", CTLOCID As %String = "") As %Query(ROWSPEC = "TID:%Library.Float,TQMTypeDR:%String,TQMType:%String,TErrDetail:%String,TRemark:%String,TErrUserID:%String,TErrUser:%String,TCreateUserID:%String,TCreateUser:%String,TCreateDate:%String,TUpdateUserID:%String,TUpdateUser:%String,TUpdateDate:%String,TRegNo:%String,TName:%String,TSex:%String,TAge:%String") [ SqlProc ]
{
}

ClassMethod FindQualityManagerExecute(ByRef qHandle As %Binary, StartDate As %Library.String = "", EndDate As %Library.String = "", VIPLevel As %String = "", Type As %String = "", ErrUserID As %String = "", CreateUserID As %String = "", CTLOCID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    i (StartDate="")&&(EndDate="") d
    .s EndDate=+$H
    .s StartDate=+$H
    s:StartDate="" StartDate=1
    s:EndDate="" EndDate=+$H
    s:StartDate[("-") StartDate=$ZDH(StartDate,3)
    s:EndDate[("-") EndDate=$ZDH(EndDate,3)
    s:StartDate[("/") StartDate=$ZDH(StartDate,4)
    s:EndDate[("/") EndDate=$ZDH(EndDate,4)
    s Date=StartDate-1
    f  s Date=$O(^User.DHCPEQualityManagerI("DateIndex",Date)) q:(Date="")||(Date>EndDate)  d
    .s ID=0
    .f  s ID=$O(^User.DHCPEQualityManagerI("DateIndex",Date,ID)) q:ID=""  d
    ..s Satatus=$LG(^User.DHCPEQualityManagerD(ID),10)
    ..q:Satatus="D"
    ..s (TQMTypeDR,TQMType,TErrDetail,TRemark,TErrUserID,TErrUser,TCreateUserID,TCreateUser,TCreateDate,TUpdateUserID,TUpdateUser,TUpdateDate,TRegNo,TName,TSex,TAge)=""
    ..s PAADM=$LG(^User.DHCPEQualityManagerD(ID),2)
    ..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM,CTLOCID) 
    ..q:LocFlag=1
    ..s PaPatID=$P(^PAADM(PAADM),"^",1)
    ..s HospID=$p(^CTLOC(CTLOCID),"^",22)
    ..;s BaseInfo=##class(web.DHCPE.DocPatientFind).GetBaseInfo(PaPatID,HospID)
    ..s BaseInfo=##class(web.DHCPE.Statistic.WorkStatistic).GetBaseInfo("PAADM",PAADM)
    ..s TRegNo=$P(BaseInfo,"^",1)
    ..s TName=$P(BaseInfo,"^",2)
    ..s TSex=$P(BaseInfo,"^",3)
    ..s TAge=$P(BaseInfo,"^",4)
    ..s VIPInfo=+##class(web.DHCPE.PreCommon).GetVIPLevel("PAADM",PAADM)
    ..q:(VIPLevel'="")&&(VIPLevel'=VIPInfo)
    ..s TQMType=$LG(^User.DHCPEQualityManagerD(ID),3)
    ..q:(Type'="")&&(Type'=TQMType)
    ..s TQMTypeDR=TQMType
    ..s TQMType=$LG(^User.DHCPEQMTypeD(TQMTypeDR),3)
    ..s TErrDetail=$LG(^User.DHCPEQualityManagerD(ID),4)
    ..s TRemark=$LG(^User.DHCPEQualityManagerD(ID),5)
    ..s TErrUserID=$LG(^User.DHCPEQualityManagerD(ID),6)
    ..q:(ErrUserID'="")&&(ErrUserID'=TErrUserID)
    ..s:TErrUserID'="" TErrUser=$P(^SSU("SSUSR",TErrUserID),"^",2)
    ..s TCreateUserID=$LG(^User.DHCPEQualityManagerD(ID),7)
    ..q:(CreateUserID'="")&&(CreateUserID'=TCreateUserID)
    ..s:TCreateUserID'="" TCreateUser=$P(^SSU("SSUSR",TCreateUserID),"^",2)
    ..s TCreateDate=$ZD(Date,3)
    ..s TUpdateUserID=$LG(^User.DHCPEQualityManagerD(ID),11)
    ..s:TUpdateUserID'="" TUpdateUser=$P(^SSU("SSUSR",TUpdateUserID),"^",2)
    ..s TUpdateDate=$LG(^User.DHCPEQualityManagerD(ID),12)
    ..s:TUpdateDate'="" TUpdateDate=$ZD(TUpdateDate,3)
    ..d FindBuild
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
    q
FindBuild      
    set Data=$lb(ID,TQMTypeDR,TQMType,TErrDetail,TRemark,TErrUserID,TErrUser,TCreateUserID,TCreateUser,TCreateDate,TUpdateUserID,TUpdateUser,TUpdateDate,TRegNo,TName,TSex,TAge)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod FindQualityManagerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindQualityManagerExecute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    Set ind=$o(^CacheTemp(repid,ind))
    If ind="" {             // if there are no more rows, finish fetching
        Set AtEnd=1
        Set Row=""
    }
    Else      {         
        Set Row=^CacheTemp(repid,ind)
    }
    s qHandle=$lb(AtEnd,repid,ind)
    Quit $$$OK
}

ClassMethod FindQualityManagerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindQualityManagerExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetUserInfo(OEORDItemID, ExpStr)
{
    s UserID="",UserName=""
    s RLTID=$O(^DHCPERLT(0,"OEORI",OEORDItemID,0))
    q:RLTID="" UserID_"^"_UserName
    s UserID=$P(^DHCPERLT(RLTID),"^",5)
    s:UserID'="" UserName=$P($G(^SSU("SSUSR",UserID)),"^",2)
    q UserID_"^"_UserName
}

}
