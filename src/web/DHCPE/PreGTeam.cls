Import SQLUser

Class web.DHCPE.PreGTeam Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 118;

Query SearchPreGTeam(ParRef As %String = "") As %Query(ROWSPEC = "Hidden:%String,PGT_RowId:%String:分组ID,Hidden:%String,Hidden:%String,PGT_Desc:%String:分组名称,Hidden:%String,PGT_Sex_Desc:%String:性别,PGT_UpperLimit:%String:年龄上限,PGT_LowerLimit:%String:年龄下限,Hidden:%String,PGT_Married_Desc:%String:婚姻状况,Hidden:%String,Hidden:%String,Hidden:%String,PGT_AddOrdItem:%String:公费加项,PGT_AddOrdItemLimit:%String:限制加项金额,PGT_AddOrdItemAmount:%String:加项金额,PGT_AddPhcItem:%String:允许开药,PGT_AddPhcItemLimit:%String:限制开药金额,PGT_AddPhcItemAmount:%String:开药金额,Hidden:%String,PGT_GReportSend_Name:%String:团体报告发送,Hidden:%String,PGT_IReportSend_Name:%String:个人报告发送,Hidden:%String,PGT_DisChargedMode_Name:%String:结算方式,PGT_BookDateBegin:%String:预约开始日期,PGT_BookDateEnd:%String:预约截止日期,PGT_BookTime:%String:预约时间,Hidden:%String,PGT_PEDeskClerk_DR_Name:%String:接待人,TTotalPerson:%String:人数")
{
}

ClassMethod SearchPreGTeamExecute(ByRef qHandle As %Binary, ParRef As %String = "") As %Status
{

    Set repid=$I(^CacheTemp)

    s ind=1
    s id="0"
    i ""'=ParRef  d
    .f  s id=$O(^DHCPEPreGADM(ParRef,"Team",id)) q:id=""  d
    ..s CurData=$g(^DHCPEPreGADM(ParRef,"Team",id))
    ..s ParRefName=""
    ..
    ..s iLLoop=1
    ..// 1 PGT_Desc 分组名称 
    ..s PGTDesc=$p(CurData,"^",iLLoop)
    ..s iLLoop=iLLoop+1
    ..
    ..// 17 PGT_BookDateBegin
    ..s PGTBookDateBegin = $p(CurData,"^",iLLoop)
    ..i (""'=PGTBookDateBegin) s PGTBookDateBegin=##class(websys.Conversions).DateLogicalToHtml(PGTBookDateBegin)
    ..s iLLoop=iLLoop+1 
    ..
    ..
    ..// 18 PGT_BookDateEnd
    ..s PGTBookDateEnd=$p(CurData,"^",iLLoop)
    ..i ""'=PGTBookDateEnd s PGTBookDateEnd=##class(websys.Conversions).DateLogicalToHtml(PGTBookDateEnd)
    ..s iLLoop=iLLoop+1
    ..
    ..// 19 PGT_BookTime 预约时间
    ..s PGTBookTime=$p(CurData,"^",iLLoop)
    ..i ""'=PGTBookTime s PGTBookTime=$ZT(PGTBookTime,2)
    ..s iLLoop=iLLoop+1
    ..
    ..// 20 PGT_PEDeskClerk_DR 
    ..s PGTPEDeskClerkDR=$p(CurData,"^",iLLoop)
    ..// 20 PGT_PEDeskClerk_DR_Name 
    ..s PGTPEDeskClerkDR=$p(CurData,"^",iLLoop)
    ..i (""'=PGTPEDeskClerkDR) d // 7
    ...s PGTPEDeskClerkDRName=$p($g(^SSU("SSUSR",PGTPEDeskClerkDR)),"^",2)
    ..e  d
    ...s PGTPEDeskClerkDRName=""
    ..s iLLoop=iLLoop+1
    ..
    ..// 8 PGT_AddOrdItem 公费加项 
    ..s PGTAddOrdItem=$p(CurData,"^",iLLoop)
    ..s iLLoop=iLLoop+1
    ..
    ..// 9 PGT_AddOrdItemLimit 加项金额限制 
    ..s PGTAddOrdItemLimit=$p(CurData,"^",iLLoop)
    ..s iLLoop=iLLoop+1
    ..
    ..// 10 PGT_AddOrdItemAmount 公费加项金额 
    ..s PGTAddOrdItemAmount=$p(CurData,"^",iLLoop)
    ..s iLLoop=iLLoop+1
    ..
    ..// 11 PGT_AddPhcItem 允许加药 
    ..s PGTAddPhcItem=$p(CurData,"^",iLLoop)
    ..s iLLoop=iLLoop+1
    ..
    ..// 12 PGT_AddPhcItemLimit 加药金额限制 
    ..s PGTAddPhcItemLimit=$p(CurData,"^",iLLoop)
    ..s iLLoop=iLLoop+1
    ..
    ..// 13 PGT_AddPhcItemAmount 允许加药金额 
    ..s PGTAddPhcItemAmount=$p(CurData,"^",iLLoop)
    ..s iLLoop=iLLoop+1
    ..
    ..// 2 PGT_Sex 性别
    ..s PGTSex=$p(CurData,"^",iLLoop)
    ..s PGTSexDesc=""
    ..i ("Male"=PGTSex)||("M"=PGTSex) s PGTSexDesc="男"
    ..i ("Female"=PGTSex)||("F"=PGTSex) s PGTSexDesc="女"
    ..i ("No"=PGTSex)||("N"=PGTSex) s PGTSexDesc="不限"
    ..
    ..s iLLoop=iLLoop+1
    ..// 3 PGT_UpperLimit 年龄上限
    ..s PGTUpperLimit=$p(CurData,"^",iLLoop)
    ..
    ..s iLLoop=iLLoop+1
    ..// 4 PGT_LowerLimit 年龄下限
    ..s PGTLowerLimit=$p(CurData,"^",iLLoop)
    ..
    ..s iLLoop=iLLoop+1
    ..// 5 PGT_Married 婚姻状况
    ..s PGTMarried=$p(CurData,"^",iLLoop)
    ..s PGTMarriedDesc=""
    ..i ("Unmarried"=PGTMarried)||("UM"=PGTMarried) s PGTMarriedDesc="未婚"
    ..i ("Married"=PGTMarried)||("M"=PGTMarried) s PGTMarriedDesc="已婚"
    ..i ("Married"=PGTMarried)||("N"=PGTMarried) s PGTMarriedDesc="不限"
    
    ..s PGTDisChargedMode=$p(CurData,"^",19)
    ..s CurData=$g(^DHCPEPreGADM(ParRef))
    .. 
    ..// 14 PGT_GReportSend 团体报告发送 
    ..s PGTGReportSend=$p(CurData,"^",14)
    ..s:(""'=PGTGReportSend) PGTGReportSendName =##Class(web.DHCPE.PreCommon).TransGReportSend(PGTGReportSend)
    ..s:(""=PGTGReportSend) PGTGReportSendName = ""
    ..s iLLoop=iLLoop+1
    ..
    ..// 15 PGT_IReportSend 个人报告发送 
    ..s PGTIReportSend=$p(CurData,"^",15)
    ..s:(""'=PGTIReportSend) PGTIReportSendName =##Class(web.DHCPE.PreCommon).TransIReportSend(PGTIReportSend)
    ..s:(""=PGTIReportSend) PGTIReportSendName = ""
    ..s iLLoop=iLLoop+1
    ..
    ..// 16 PGT_DisChargedMode 结算方式 
    ..s:PGTDisChargedMode="" PGTDisChargedMode=$p(CurData,"^",16)
    ..s:(""'=PGTDisChargedMode) PGTDisChargedModeName =##Class(web.DHCPE.PreCommon).TransDisChargedMode(PGTDisChargedMode)
    ..s:(""=PGTDisChargedMode) PGTDisChargedModeName = ""
    ..s iLLoop=iLLoop+1
    ..
    ..//取得站点名称
    ..s CurData=$g(^DHCPEST(ParRef))
    ..s iParRefName=$p(CurData,"^",2)
    ..s Person=..GetTotalPersonByItem(ParRef_"||"_id)
    ..s TTotalPerson="共"_+Person_"人,已检"_$p(Person,"^",2)_"人"
    ..s CancelPerson=$p(Person,"^",3)
    ..i CancelPerson'=0 s TTotalPerson=TTotalPerson_",取消"_$p(Person,"^",3)_"人"
    ..//s THadCheckTotal=$p(Person,"^",2)
    ..d BuildPreGTeam   
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
BuildPreGTeam
    // PGT_ParRef, PGT_RowId, PGT_ChildSub, PGT_ParRef_Name, PGT_Desc, PGT_Sex, PGT_UpperLimit, PGT_LowerLimit, PGT_Married, PGT_Married_Desc ,PGT_UpdateUser_DR, PGT_UpdateUser_DR_Name, PGT_UpdateDate
    set Data=$lb(ParRef, ParRef_"||"_id, id, ParRefName, PGTDesc, PGTSex, PGTSexDesc, PGTUpperLimit, PGTLowerLimit, PGTMarried, PGTMarriedDesc, PGTUpdateUserDR, PGTUpdateUserDRName, PGTUpdateDate, PGTAddOrdItem, PGTAddOrdItemLimit, PGTAddOrdItemAmount, PGTAddPhcItem, PGTAddPhcItemLimit, PGTAddPhcItemAmount, PGTGReportSend, PGTGReportSendName, PGTIReportSend, PGTIReportSendName, PGTDisChargedMode, PGTDisChargedModeName, PGTBookDateBegin, PGTBookDateEnd, PGTBookTime, PGTPEDeskClerkDR, PGTPEDeskClerkDRName,TTotalPerson)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchPreGTeamFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPreGTeamExecute ]
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

ClassMethod SearchPreGTeamClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPreGTeamExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetSubTeamByID(TeamId)
{
    q:TeamId="" ""
    s SubId=""
    &sql(SELECT PGT_RowId into :SubId FROM SQLUser.DHC_PE_PreGTeam WHERE PGT_Parent_DR=:TeamId)
    q SubId
}

/// d ##class(web.DHCPE.PreGTeam).GetParentTeamByID("117||5",ret)
ClassMethod GetParentTeamByID(NowTeamId, ByRef ret)
{
    s ParentTeamID=$p(^DHCPEPreGADM(+NowTeamId,"Team",$p(NowTeamId,"||",2)),"^",23)
    
    if (ParentTeamID'="")
    {
        s ret=ret_"^"_ParentTeamID
        
        d ..GetParentTeamByID(ParentTeamID,.ret)
        
    }
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreGTeam","SearchGTeam",75,"","A")
Query SearchGTeam(ParRef As %String = "", GTeamName As %String = "", QType As %String = "", TeamID As %String = "") As %Query(ROWSPEC = "GroupID:%String, PGT_RowId:%String:分组ID, PGT_ChildSub:%String, PGT_ParRef_Name:%String:团体名称, PGT_Desc:%String:分组名称, PGTSex:%String, PGT_Sex_Desc:%String:性别, PGT_UpperLimit:%String:年龄上限, PGT_LowerLimit:%String:年龄下限, PGTMarried:%String, PGT_Married_Desc:%String:婚姻, PGTUpdateUserDR:%String, PGT_UpdateUser_DR_Name:%String:更新人, PGT_UpdateDate:%String:更新时间, PGT_AddOrdItem:%String:公费加项, PGT_AddOrdItemLimit:%String:加项金额限制, PGT_AddOrdItemAmount:%String:加项金额, PGT_AddPhcItem:%String:允许加药, PGT_AddPhcItemLimit:%String:开药金额限制, PGT_AddPhcItemAmount:%String:开药金额, PGTGReportSend:%String, PGT_GReportSend_Name:%String:团体报告发送, PGTIReportSend:%String, PGT_IReportSend_Name:%String:个人报告发送, PGTDisChargedMode:%String, PGT_DisChargedMode_Name:%String:结算方式, PGT_BookDateBegin:%String:预约开始日期, PGT_BookDateEnd:%String:预约截止日期, PGT_BookTime:%String:预约时间, PGTPEDeskClerkDR:%String, PGT_PEDeskClerk_DR_Name:%String:接待人,TTotalPerson:%String:人数,_parentId:%String,state:%String")
{
}

ClassMethod SearchGTeamExecute(ByRef qHandle As %Binary, ParRef As %String = "", GTeamName As %String = "", QType As %String = "", TeamID As %String = "") As %Status
{

    Set repid=$I(^CacheTemp)

    s ind=1,state="",ParentSub=""
    s id="0"
    i ""'=ParRef  d
    .f  s id=$O(^DHCPEPreGADM(ParRef,"Team",id)) q:id=""  d
    ..s CurData=$g(^DHCPEPreGADM(ParRef,"Team",id))
    ..q:(TeamID'="")&&(TeamID=(ParRef_"||"_id)) //当前分组不能选自己为父层
    ..s ParRefName="",ParentSub=""
    ..s PGBIDR=$p($g(^DHCPEPreGADM(ParRef)),"^",1)
    ..i PGBIDR'="" s ParRefName=$p($g(^DHCPEPreGBI(PGBIDR)),"^",2)
    ..s ParentTeam=$p(CurData,"^",23)
    ..s AllParent=""
    ..d ##class(web.DHCPE.PreGTeam).GetParentTeamByID(ParRef_"||"_id,.AllParent)
    ..q:(TeamID'="")&&(AllParent[TeamID) //当前分组的所有子分组不能选为父层
    ..i ParentTeam'="" s ParentSub=$p(ParentTeam,"||",2)
    ..i ParentSub="" s state="" //s state="closed"
    ..e  s state=""
    ..i GTeamName'="" d
    ...s state=""
    ...s ParentSub=""
    ..s iLLoop=1
    ..// 1 PGT_Desc 分组名称 
    ..s PGTDesc=$p(CurData,"^",iLLoop)
    ..s:PGTDesc'="" PGTDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGTeam",PGTDesc,"PGTDesc","cls")
    ..q:((GTeamName'="")&&(PGTDesc'[GTeamName))
    ..i (ParentTeam'="")&&(QType="A") d
    ...s ParentDesc=$p($g(^DHCPEPreGADM(+ParentTeam,"Team",$p(ParentTeam,"||",2))),"^",1)
    ...s:ParentDesc'="" ParentDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGTeam",ParentDesc,"PGTDesc","cls")
    ...s PGTDesc=ParentDesc_"-"_PGTDesc
    ..s iLLoop=iLLoop+1
    ..
    ..// 17 PGT_BookDateBegin
    ..s PGTBookDateBegin = $p(CurData,"^",iLLoop)
    ..i (""'=PGTBookDateBegin) s PGTBookDateBegin=##class(websys.Conversions).DateLogicalToHtml(PGTBookDateBegin)
    ..s iLLoop=iLLoop+1 
    ..
    ..
    ..// 18 PGT_BookDateEnd
    ..s PGTBookDateEnd=$p(CurData,"^",iLLoop)
    ..i ""'=PGTBookDateEnd s PGTBookDateEnd=##class(websys.Conversions).DateLogicalToHtml(PGTBookDateEnd)
    ..s iLLoop=iLLoop+1
    ..
    ..// 19 PGT_BookTime    预约时间
    ..s PGTBookTime=$p(CurData,"^",iLLoop)
    ..i ""'=PGTBookTime s PGTBookTime=$ZT(PGTBookTime,2)
    ..s iLLoop=iLLoop+1
    ..
    ..// 20 PGT_PEDeskClerk_DR  
    ..s PGTPEDeskClerkDR=$p(CurData,"^",iLLoop)
    ..// 20 PGT_PEDeskClerk_DR_Name 
    ..s PGTPEDeskClerkDR=$p(CurData,"^",iLLoop)
    ..i (""'=PGTPEDeskClerkDR)  d // 7
    ...s PGTPEDeskClerkDRName=$p($g(^SSU("SSUSR",PGTPEDeskClerkDR)),"^",2)
    ..e  d
    ...s PGTPEDeskClerkDRName=""
    ..s iLLoop=iLLoop+1
    ..
    ..// 8 PGT_AddOrdItem   公费加项 
    ..s PGTAddOrdItem=$p(CurData,"^",iLLoop)
    ..i PGTAddOrdItem="N" s PGTAddOrdItem="否"
    ..e  s PGTAddOrdItem="是"
    ..s iLLoop=iLLoop+1
    ..
    ..// 9 PGT_AddOrdItemLimit  加项金额限制 
    ..s PGTAddOrdItemLimit=$p(CurData,"^",iLLoop)
    ..s iLLoop=iLLoop+1
    ..
    ..// 10 PGT_AddOrdItemAmount    公费加项金额 
    ..s PGTAddOrdItemAmount=$p(CurData,"^",iLLoop)
    ..s iLLoop=iLLoop+1
    ..
    ..// 11 PGT_AddPhcItem  允许加药 
    ..s PGTAddPhcItem=$p(CurData,"^",iLLoop)
    ..i PGTAddPhcItem="N" s PGTAddPhcItem="否"
    ..e  s PGTAddPhcItem="是"
    ..s iLLoop=iLLoop+1
    ..
    ..// 12 PGT_AddPhcItemLimit 加药金额限制 
    ..s PGTAddPhcItemLimit=$p(CurData,"^",iLLoop)
    ..s iLLoop=iLLoop+1
    ..
    ..// 13 PGT_AddPhcItemAmount    允许加药金额 
    ..s PGTAddPhcItemAmount=$p(CurData,"^",iLLoop)
    ..s iLLoop=iLLoop+1
    ..
    ..// 2 PGT_Sex  性别
    ..s PGTSex=$p(CurData,"^",iLLoop)
    ..s PGTSexDesc=""
    ..i ("Male"=PGTSex)||("M"=PGTSex) s PGTSexDesc="男"
    ..i ("Female"=PGTSex)||("F"=PGTSex) s PGTSexDesc="女"
    ..i ("No"=PGTSex)||("N"=PGTSex) s PGTSexDesc="不限"
    ..
    ..s iLLoop=iLLoop+1
    ..// 3 PGT_UpperLimit   年龄上限
    ..s PGTUpperLimit=$p(CurData,"^",iLLoop)
    ..
    ..s iLLoop=iLLoop+1
    ..// 4 PGT_LowerLimit   年龄下限
    ..s PGTLowerLimit=$p(CurData,"^",iLLoop)
    ..
    ..s iLLoop=iLLoop+1
    ..// 5 PGT_Married  婚姻状况
    ..s PGTMarried=$p(CurData,"^",iLLoop)
    ..s PGTMarriedDesc=""
    ..i ("Unmarried"=PGTMarried)||("UM"=PGTMarried) s PGTMarriedDesc="未婚"
    ..i ("Married"=PGTMarried)||("M"=PGTMarried) s PGTMarriedDesc="已婚"
    ..i ("Married"=PGTMarried)||("N"=PGTMarried) s PGTMarriedDesc="不限"
    
    ..s PGTDisChargedMode=$p(CurData,"^",19)
    ..s CurData=$g(^DHCPEPreGADM(ParRef))
    ..  
    ..// 14 PGT_GReportSend 团体报告发送 
    ..s PGTGReportSend=$p(CurData,"^",14)
    ..s:(""'=PGTGReportSend) PGTGReportSendName =##Class(web.DHCPE.PreCommon).TransGReportSend(PGTGReportSend)
    ..s:(""=PGTGReportSend) PGTGReportSendName = ""
    ..s iLLoop=iLLoop+1
    ..
    ..// 15 PGT_IReportSend 个人报告发送 
    ..s PGTIReportSend=$p(CurData,"^",15)
    ..s:(""'=PGTIReportSend) PGTIReportSendName =##Class(web.DHCPE.PreCommon).TransIReportSend(PGTIReportSend)
    ..s:(""=PGTIReportSend) PGTIReportSendName = ""
    ..s iLLoop=iLLoop+1
    ..
    ..// 16 PGT_DisChargedMode  结算方式 
    ..s:PGTDisChargedMode="" PGTDisChargedMode=$p(CurData,"^",16)
    ..s:(""'=PGTDisChargedMode) PGTDisChargedModeName =##Class(web.DHCPE.PreCommon).TransDisChargedMode(PGTDisChargedMode)
    ..s:(""=PGTDisChargedMode) PGTDisChargedModeName = ""
    ..s iLLoop=iLLoop+1
    ..
    ..//取得站点名称
    ..s CurData=$g(^DHCPEST(ParRef))
    ..s iParRefName=$p(CurData,"^",2)
    ..s Person=..GetTotalPersonByItem(ParRef_"||"_id)
    ..s TTotalPerson="共"_+Person_"人,已检"_$p(Person,"^",2)_"人"
    ..s CancelPerson=$p(Person,"^",4)
    ..i CancelPerson'=0 s TTotalPerson=TTotalPerson_",取消"_$p(Person,"^",4)_"人"
    ..//s THadCheckTotal=$p(Person,"^",2)
    ..d Build   
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
Build
    //          PGT_ParRef, PGT_RowId, PGT_ChildSub, PGT_ParRef_Name, PGT_Desc, PGT_Sex, PGT_UpperLimit, PGT_LowerLimit, PGT_Married, PGT_Married_Desc ,PGT_UpdateUser_DR, PGT_UpdateUser_DR_Name, PGT_UpdateDate
    s:ParRefName'="" ParRefName=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEPreGBaseInfo",ParRefName,"PGBIDesc","cls")    
    set Data=$lb(ParRef, ParRef_"||"_id, id, ParRefName, PGTDesc, PGTSex, PGTSexDesc, PGTUpperLimit, PGTLowerLimit, PGTMarried, PGTMarriedDesc, PGTUpdateUserDR, PGTUpdateUserDRName, PGTUpdateDate, PGTAddOrdItem, PGTAddOrdItemLimit, PGTAddOrdItemAmount, PGTAddPhcItem, PGTAddPhcItemLimit, PGTAddPhcItemAmount, PGTGReportSend, PGTGReportSendName, PGTIReportSend, PGTIReportSendName, PGTDisChargedMode, PGTDisChargedModeName, PGTBookDateBegin, PGTBookDateEnd, PGTBookTime, PGTPEDeskClerkDR, PGTPEDeskClerkDRName,TTotalPerson,ParentSub,state)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchGTeamFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchGTeamExecute ]
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

ClassMethod SearchGTeamClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchGTeamExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Description: 存在已执行医嘱就算是一个已检人员
/// Debug: w ##class(web.DHCPE.PreGTeam).GetTotalPersonByItem()
ClassMethod GetTotalPersonByItem(id)
{
    new i,j,k,m,Status
    s i=0
    s j=0
    s k=0
    S m=0
    s iAdm=0
    f  s iAdm=$o(^DHCPEPreIADM(0,"PGTeam",id,iAdm)) q:iAdm=""  d
    .s Status=$p(^DHCPEPreIADM(iAdm),"^",8)
    .;q:Status="CANCELPE"
    .s i=i+1
    .i Status="CANCELPREREG" s k=k+1
    .i Status="CANCELPE"  S m=m+1
    .s PEIADM=$o(^DHCPEIADM(0,"CRMADM",iAdm,0))
    .q:PEIADM=""
    .s PAADM=$p($G(^DHCPEIADM(PEIADM)),"^",1)
    .q:PAADM=""
    .;q:..OrderIsExecByPAAdm(PAADM)=0 //存在已执行项目即算是已检
    .;s RLTDR=$o(^DHCPERLT(0,"ADM",PAADM,0))
    .;q:RLTDR=""
    .//按照"团体已检规则"配置判断
    .s ShowFlag=##class(web.DHCPE.PreGADM).IsOrderExecuted(PAADM)
    .q:ShowFlag="N"
    .s j=j+1
    q i_"^"_j_"^"_k_"^"_m
}

/// Description: 判断一个人的医嘱是否存在已经执行的
/// Debug: w ##class(web.DHCPE.PreGTeam).OrderIsExecByPAAdm()
ClassMethod OrderIsExecByPAAdm(ADM)
{
    new flag,sub,stat
    s flag=0
    s OEOrdId=$o(^OEORD(0,"Adm",ADM,0))
    q:OEOrdId="" flag
    s sub=0
    f  s sub=$o(^OEORD(OEOrdId,"I",sub)) q:(sub="")||(flag=1)  d
    .s stat=$p($G(^OEORD(OEOrdId,"I",sub,1)),"^",13)
    .q:stat="4"
    .s:stat="6" flag=1
    q flag
}

/// 增加组的成员
/// d ##Class(web.DHCPE.PreGTeam).AppendIADM("","","")
ClassMethod AppendIADM(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
    //验证新增人员是否符合组的条件 
    // 个人基本信息表DHC_PE_PreIBaseInfo
    s PIBIDR=$p(InString,"^",1)
    // 团体分组表 DHC_PE_PreGTeam
    s PGTeamDR=$p(InString,"^",3)

    s CurData=$G(^DHCPEPreGADM(PGTRowId,"Team", PGTChildSub))


    s PGTSex=+$P(CurData,"^",2)
    s PGTUpperLimit=+$P(CurData,"^",3)
    s PGTLowerLimit=$P(CurData,"^",4)
    s PGTMarried=$P(CurData,"^",5)

    //  DHC_PE_PreIBaseInfo.{PIBI_Sex_DR}   性别
    s PIBISexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
    
    //  DHC_PE_PreIBaseInfo.{PIBI_DOB}  生日
    s PIBIDOB=$p($g(^DHCPEPreIBI(PIBIDR)),"^",4)

    // DHC_PE_PreIBaseInfo.{PIBI_Married_DR }
    s PIBIDOB=$p($g(^DHCPEPreIBI(PIBIDR)),"^",17)
    
    
    s ret=##Class(web.DHCPE.PreIADM).Save(itmjs,itmjsex,InString)
}

// **********************************************************************

/// w ##class(web.DHCPE.PreGTeam).GetPreGTeam(8,2,"^")
ClassMethod GetPreGTeam(ParRef As %Library.String = "", Childsub As %Library.String = "", Delim As %Library.String = "")
{
    q:ParRef="" ""
    new DataStr,OneData,UserName,GlobalLength
    s GlobalLength=18
    i ""=Delim s Delim="^"
    s ParentTeam=""
    //PGT_PGBI_DR DHC_PE_PreGADM
    s PGTPGBIDR=$p($G(^DHCPEPreGADM(ParRef)),"^",1)
    // DHC_PE_PreGBaseInfo
    s ParRefName=$p($G(^DHCPEPreGBI(PGTPGBIDR)),"^",2)
    
    s DSMode=""
    i ""=ParRefName d
    .s CurData=""   //没有对应的团体
    e  d
    .s CurData=$G(^DHCPEPreGADM(ParRef,"Team",Childsub))
    .s DSMode=$p(CurData,"^",19)
    .s ParentTeam=$p(CurData,"^",23) 
    .s CurData=$p(CurData,"^",1,GlobalLength)
    
    s AddPhcItemAmout=$p(CurData,"^",8)
    i ((AddPhcItemAmout'="")&&($p(AddPhcItemAmout,".",1)="")) s AddPhcItemAmout=0_AddPhcItemAmout
    s $p(CurData,"^",8)=AddPhcItemAmout

    s id=ParRef_"||"_Childsub
    s DataStr=ParRef_"^"_id_"^"_Childsub
    
    i ""'=CurData
    {
        i $p(CurData,"^",2)'="" s $p(CurData,"^",2)=##class(websys.Conversions).DateLogicalToHtml($p(CurData,"^",2))
        i $p(CurData,"^",3)'="" s $p(CurData,"^",3)=##class(websys.Conversions).DateLogicalToHtml($p(CurData,"^",3))
        i $p(CurData,"^",4)'="" s $p(CurData,"^",4)=$ZT($p(CurData,"^",4),2)
        i $p(CurData,"^",5)=""  d
        .s UserName=$p(CurData,"^",5)
        .i UserName="" s UserName=$p($g(^DHCPEPreGADM(ParRef)),"^",5) 
        .i UserName'="" s UserName=$p($G(^SSU("SSUSR",UserName)),"^",2)
        .s $p(CurData,"^",5)=UserName

        s DataStr=DataStr_"^"_CurData
        s DataStr=DataStr_"^"_ParRefName
        s GADMInfo=$g(^DHCPEPreGADM(ParRef))
        s DataStr=DataStr_"^"_$p(GADMInfo,"^",14)
        s DataStr=DataStr_"^"_$p(GADMInfo,"^",15)
        i DSMode="" s DSMode=$p(GADMInfo,"^",16)
        s DataStr=DataStr_"^"_DSMode //$p(GADMInfo,"^",16)
        s UserName=$p(CurData,"^",5)
        i UserName="" s UserName=$p(GADMInfo,"^",5) 
        i UserName'="" s UserName=$p($G(^SSU("SSUSR",UserName)),"^",2)

        s DataStr=DataStr_"^"_UserName
        s VipLevel=$g(^DHCPECBVIPLevel("PGT",id))
        s DataStr=DataStr_"^"_VipLevel
        s TeamLevel=$g(^DHCPEDataEx("DHCPEPreGADM","TeamLevel",id))
        s DataStr=DataStr_"^"_TeamLevel
        s ADMFeeTypes=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",id))
        s DataStr=DataStr_"^"_ADMFeeTypes
        s NoInclude=$g(^DHCPEDataEx("DHCPEPreGTeam","NoInclude",id))
        s DataStr=DataStr_"^"_NoInclude
        s OMEType=$g(^DHCPEDataEx("DHCPEPreGADM","OMEType",id))
        s DataStr=DataStr_"^"_OMEType
        s RoomPlace=$g(^DHCPEDataEx("DHCPEPreGTeam","RoomPlace",id))
        s DataStr=DataStr_"^"_RoomPlace
        s Endanger=$g(^DHCPEDataEx("DHCPEPreGADM","TeamEndanger",id))
        s DataStr=DataStr_"^"_Endanger
        s DataStr=DataStr_"^"_$p($G(^DHCPEPreGADM(ParRef,"Team",Childsub)),"^",20)  //折扣率
        s DataStr=DataStr_"^"_$p($G(^DHCPEPreGADM(ParRef,"Team",Childsub)),"^",21)
        s DataStr=DataStr_"^"_$p($G(^DHCPEPreGADM(ParRef,"Team",Childsub)),"^",22)
        s DataStr=DataStr_"^"_ParentTeam
    }
    else
    {
        s DataStr=""
    }
    q DataStr
}

/// 获取团体信息
/// test w ##Class(web.DHCPE.PreGTeam).DocListBroker("","","5^^4")
ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
    s ParRef=$p(InString,"^",1)
    s RowId=$p(InString,"^",2)
    s Childsub=$p(InString,"^",3)
    Q:(""=Childsub) ""
    i (""'=ParRef)||(""'=Childsub)  d
    .s Data=..GetPreGTeam(ParRef,Childsub,"^")
    e  d
    .s Data="0^"_ParRef_"^"_Childsub_"^"_"未找到记录"
    i ""'=itmjs d
    .s retval=itmjs_"('"_$ZCVT(Data,"O","JS")_"');"
    .&javascript<#(retval)#>
    q Data
}

/// 功能  验证团体组成员是否符合团体组的限制条件
/// 使用  ##class(web.DHCPE.PreIBIUpdate).ISave()
/// 测试 w ##class(web.DHCPE.PreGTeam).IsValidGTeamIADM(3152,"35||7")
ClassMethod IsValidGTeamIADM(PIBIDR As %String = "", PGTeamDR As %String = "", PreIADM As %String = "")
{
    Q:(""=PIBIDR)&(""=PGTeamDR) "0"
    
    s ParRef=$P(PGTeamDR,"||",1)
    s Childsub=$P(PGTeamDR,"||",2)
    s TCurData=$G(^DHCPEPreGADM(ParRef,"Team",Childsub))

    s ICurData=$g(^DHCPEPreIBI(PIBIDR))  

    s ret=""
    
    S VIPLevel=""
    i PreIADM'="" S VIPLevel=$P(^DHCPEPreIADM(PreIADM),"^",18)
    //e  s VIPLevel=$g(^DHCPECBVIPLevel("PIBI",$p($g(^DHCPEPreIBI(PIBIDR)),"^",1) ))

    s TeamVip=$g(^DHCPECBVIPLevel("PGT",PGTeamDR))
    i (""'=TeamVip)&(""'=VIPLevel)&(VIPLevel'=TeamVip) s ret="VIP等级不一致"
    Q:(""'=ret) ret

    // 2 PGT_Sex    性别
    s PGTSex = $p(TCurData,"^",12)
    i '((""=PGTSex)||("N"=PGTSex)||("No"=PGTSex)) d
    .// PIBI_Sex_DR 性别
    .s PIBISexDR=$p(ICurData,"^",3)  
    .i (""=PIBISexDR) s ret="性别为空"
    .//CT_Sex   CTSEX_Desc
    .s PIBISexDRName=$p($G(^CT("SEX",PIBISexDR)),"^",2)
    .i ((("Female"=PGTSex)||("F"=PGTSex))&(PIBISexDRName'["女")) s ret="性别不一致"
    .i ((("Male"=PGTSex)||("M"=PGTSex))&(PIBISexDRName'["男")) s ret="性别不一致"
    Q:(""'=ret) ret
    
    // 3 PGT_UpperLimit 年龄上限
    s PGTUpperLimit = $p(TCurData,"^",13)
    // 4 PGT_LowerLimit 年龄下限
    s PGTLowerLimit = $p(TCurData,"^",14)
    
    
    //  PIBI_DOB    生日
    s PIBIDOB=$p(ICurData,"^",4)
    i (""'=PIBIDOB) d
    .s PIBIDOB=##class(web.DHCLCNUREXCUTE).CalAge(PIBIDOB,+$h)
    .s PIBIDOB=+$P(PIBIDOB,"Y",1)
    
    i (""'=PGTLowerLimit)&(""'=PIBIDOB)&(+PIBIDOB<+PGTLowerLimit) s ret="低于分组年龄下限"
    i (""'=PGTUpperLimit)&(""'=PIBIDOB)&(+PIBIDOB>+PGTUpperLimit) s ret="高于分组年龄上限"
    Q:(""'=ret) ret

    // 5 PGT_Married    婚姻状况
    s PGTMarried = $p(TCurData,"^",15)
    i '((""=PGTMarried)||("N"=PGTMarried)||("No"=PGTMarried)) d
    .// PIBI_Married    婚姻状况
    .s PIBIMarriedDR=$p(ICurData,"^",17)
    .i ""=PIBIMarriedDR s ret="婚姻状况为空"
    .q:PIBIMarriedDR=""
    .//CT_Marital   CTMAR_Desc
    .s PIBIMarriedDRName=$p($G(^CT("MAR",PIBIMarriedDR)),"^",2)
    .i ((("Unmarried"=PGTMarried)||("UM"=PGTMarried))&(PIBIMarriedDRName'["未婚")) s ret="婚姻状况不一致"
    .i ((("Married"=PGTMarried)||("M"=PGTMarried))&(PIBIMarriedDRName'["已婚")) s ret="婚姻状况不一致"
    Q:(""'=ret) ret
    Q ""
}

/// 生成一个页面元素　显示当前的团体组列表 使用组件 DHCPEPreIADM.Team
ClassMethod GTeamList(ParRef As %Library.String = "", width As %Library.String = "") As %String
{
    //下拉列表
    w "<select name='GTeamList' id='GTeamList' style='width:"_width_"' HEIGHT=0>",!
    w "<option value=>  </option>",!
    
    s id=0  
    f  s id=$O(^DHCPEPreGADM(ParRef,"Team",id)) q:id=""  d
    .s CurData=$g(^DHCPEPreGADM(ParRef,"Team",id))
    .s iLLoop=1
    .// PGT_Desc    分组名称 
    .s PGTDesc=$p(CurData,"^",iLLoop)
    .
    .d OutputList
        
    w "</select>",!
    Quit $$$OK
    
OutputList
    w "<option value="_ParRef_"||"_$G(id)_">"_PGTDesc_"</option>",!
    q
}

/// 辅助函数 取得团体组的预约时间或者日期 使用组件 DHCPEPreIADM.Team.PEDate (1) DHCPEPreIADM.Team.PETime (2)
/// w ##Class(web.DHCPE.PreGTeam).GetGTeamBook("","","5||4^Date")
ClassMethod GetGTeamBook(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
    s RowId=$P(InString,"^",1)
    s BookType=$P(InString,"^",2)
    S ParRef=$P(RowId,"||",1)
    s Childsub=$P(RowId,"||",2)
    s CurData=$G(^DHCPEPreGADM(ParRef,"Team",Childsub))
    s ret=""
    
    i "Date"=BookType d
    .s ret=$p(CurData,"^",8)
    .i ""'=ret s ret=$ZD(ret,4)

    
    i "Time"=BookType d
    .s ret=$p(CurData,"^",9)
    .i ""'=ret s ret=$ZT(ret,2)
    
    Q ret
}

/// 删除函数 
/// test w ##Class(web.DHCPE.PreGTeam).Delete("","","955||4")
ClassMethod Delete(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
    s ^sxt("szc")=InString
    s GTeamRowId=$p(InString,"^",1)
    TStart
    i ($d(^DHCPEPreIADM(0,"PGTeam",GTeamRowId)))  d
    .s ret="2"
    .goto DeleteErr
    e  d
    .&sql( delete from DHC_PE_PreGTeam where PGT_RowId = :GTeamRowId)
    .s ret=SQLCODE
    .i (("0"=ret)||("100"=ret))  d
    ..s PGADM=$P(GTeamRowId,"||",1)
    ..s GADM=$o(^DHCPEGADM(0,"CRMGADM",PGADM,0)) 
    ..s GTeamID=GADM_"||"_$P(GTeamRowId,"||",2)
    ..s PIADM=$o(^DHCPEPreIADM(0,"PGTeam",GTeamRowId,0))
    ..i PIADM="" d
    ...&sql( delete from DHC_PE_GTeam where GT_RowId = :GTeamID)

    .e  d
    ..goto DeleteErr
    .   
    .
    .// 删除团体组成员
    .//s ID="3"_"^"_GTeamRowId
    .//s ret=##Class(web.DHCPE.PreIADM).Delete(itmjs,itmjsex,ID)
    i "0"'=ret goto DeleteErr
    /*0331
    // 重新计算团体费用
    s Ret=##Class(web.DHCPE.PreItemList).UpdateAmount(GTeamRowId,"TEAM")
    i ""'=Ret goto DeleteErr
    */
    d ##class(web.DHCPE.GAdmRecordManager).Insert(+GTeamRowId,"P","DeleteTeam","",GTeamRowId) 
    TCOMMIT
    q ret

DeleteErr
    TROLLBACK
    q ret
}

/// 更新函数 具有跟新（修改）和插入的功能 
/// d ##Class(web.DHCPE.PreGTeam).Save2("","","8^8||2^2^kkkk^F^25^10^UM^3565^^N^N^^N^N^^AsCharged^GSend^GD^11/03/2007^15/03/2007^11:00^á?oì")
ClassMethod Save2(itmjs As %Library.String = "", itmjsex As %Library.String = "", InString As %Library.String = "")
{
    s ^sxt("tinfo")=InString
    new Data,User,Time,StartDate,EndDate
    s Date=+$H
    s Time=$p($h,",",2)
    s:($d(%session)) User=%session.Get("LOGON.USERID")
    s:'$d(%session) User=5918
    s VipLevel=$p(InString,"^",19)
    s TeamLevel=$p(InString,"^",20)
    s ADMFeeType=$p(InString,"^",21)
    s NoInCludeGroup=$p(InString,"^",22)
    s DSMode=$p(InString,"^",23)
    s Endanger=$p(InString,"^",24)
    s OMEType=$p(InString,"^",25)
    s RoomPlace=$p(InString,"^",26)
    i DSMode="" s DSMode=$P(^DHCPEPreGADM(+InString),"^",16)
    s ParentTeam=$p(InString,"^",30)
    for i=0:1:17
    {
        s PLIST(i)=$p(InString,"^",i+1)
    }
    i PLIST(2)="" k PLIST(2)
    i PLIST(4)'="" s PLIST(4)=##class(websys.Conversions).DateHtmlToLogical(PLIST(4))
    i PLIST(5)'="" s PLIST(5)=##class(websys.Conversions).DateHtmlToLogical(PLIST(5))
    
    s StartDate=PLIST(4)
    s EndDate=PLIST(5)
    i StartDate="" s StartDate=0
    i EndDate="" s EndDate=0
    i EndDate<StartDate q "Err Date"
    
    i PLIST(6)'="" s PLIST(6)=$ZTH(PLIST(6),2)
    s PLIST(18)=User
    s PLIST(19)=Date
    s PLIST(20)=Time
    s PLIST(21)=DSMode
    
    s PLIST(22)=$p(InString,"^",27)
    s PLIST(23)=$p(InString,"^",28)
    s PLIST(24)=$p(InString,"^",29)
    s PLIST(25)=ParentTeam
    i 0=$D(PLIST(2))
    {
        s SQLCODE=..Insert2()
    }
    else
    {
        s SQLCODE=..Update2()
    }
    q SQLCODE
}

/// 插入新的记录 使用PLIST 实现
ClassMethod Insert2()
{
    k PLIST(1)
    k PLIST(2)
    TSTART
    &SQL(Insert Into SQLUSER.DHC_PE_PreGTeam Values :PLIST())
    i SQLCODE=0
    {
        s GTeamID=$G(%ROWID)
        s ^DHCPECBVIPLevel("PGT",GTeamID)=VipLevel
        s PreGID=+GTeamID
        s GID=$o(^DHCPEGADM(0,"CRMGADM",PreGID,0))
        i GID'=""
        {
            &SQL(insert into SQLUSER.dhc_pe_GTEAM 
            (GT_ParRef, GT_Desc, GT_CRMTeam,GT_AddOrdItem,GT_AddOrdItemLimit,GT_AddOrdItemAmount,GT_AddPhcItem,GT_AddPhcItemLimit,GT_AddPhcItemAmount,GT_Sex,GT_UpperLimit,GT_LowerLimit,GT_Married)
         select :GID,PGT_Desc,PGT_RowId,PGT_AddOrdItem,PGT_AddOrdItemLimit,PGT_AddOrdItemAmount,PGT_AddPhcItem,PGT_AddPhcItemLimit,PGT_AddPhcItemAmount,PGT_Sex,PGT_UpperLimit,PGT_LowerLimit,PGT_Married
          from SQLUSER.DHC_PE_PreGTeam
           Where PGT_RowId=:GTeamID )
        }
        s ^DHCPEDataEx("DHCPEPreGADM","TeamLevel",GTeamID)=TeamLevel
        s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",GTeamID)=ADMFeeType
        s ^DHCPEDataEx("DHCPEPreGTeam","NoInclude",GTeamID)=$G(NoInCludeGroup)
        s ^DHCPEDataEx("DHCPEPreGADM","TeamEndanger",GTeamID)=Endanger
        s ^DHCPEDataEx("DHCPEPreGADM","OMEType",GTeamID)=OMEType
        s ^DHCPEDataEx("DHCPEPreGTeam","RoomPlace",GTeamID)=$G(RoomPlace)
        d ##class(web.DHCPE.GAdmRecordManager).Insert(PreGID,"P","TeamInsert","",GTeamID)
        //插入分组折扣率日志
        i ((PLIST(22)'="")||(PLIST(23)'="")||(PLIST(24)'="")){
            d ##class(web.DHCPE.GAdmRecordManager).Insert(PreGID,"P","InsertTeamDiscount","",GTeamID_"^"_PLIST(22)_"^"_PLIST(23)_"^"_PLIST(24))
        }
    }
    i SQLCODE'=0
    {
        TROLLBACK
        q SQLCODE
    }
    TCOMMIT
    
    q SQLCODE
}

/// 更改数据 使用PLIST 实现
ClassMethod Update2()
{
    new tOldInfo,RowId,iAdm
    s RowId=PLIST(1)
    s tOldInfo=$G(^DHCPEPreGADM(PLIST(0),"Team",PLIST(2)))
    s OldVipLevel=$G(^DHCPECBVIPLevel("PGT",RowId))
    s ADMTypeChangeFlag=""
    s ADMTypeChangeFlag=##class(web.DHCPE.PreGADM).GetADMTypeChargedFlag(RowId,ADMFeeType,"T")
    Q:ADMTypeChangeFlag'="" ADMTypeChangeFlag
    s OldRoomPlace=$G(^DHCPEDataEx("DHCPEPreGTeam","RoomPlace",RowId))
    TStart
    k PLIST(0)
    k PLIST(1)
    k PLIST(2)
    s SQLCODE=0
    i $p(tOldInfo,"^",19)'=PLIST(21) d
    .s SQLCODE=##class(web.DHCPE.PreGADM).UpdateChargedMode(+RowId, PLIST(21),RowId)
    s ret=SQLCODE
    i '(("0"=ret)||("100"=ret)) goto UpdateErr
    
    
    &SQL(Update SQLUSER.DHC_PE_PreGTeam Values :PLIST() 
        where PGT_RowId = :RowId)
    s ret=SQLCODE
    i '(("0"=ret)||("100"=ret)) goto UpdateErr
    i (OldVipLevel'=VipLevel)||($p(tOldInfo,"^",19)'=PLIST(21)) d
    .&SQL(update sqluser.DHC_PE_PreIADM set PIADM_Vip=:VipLevel,PIADM_DisChargedMode=:PLIST(21) where PIADM_PGTeam_DR=:RowId)
    s ret=SQLCODE
    i '(("0"=ret)||("100"=ret)) goto UpdateErr
    
    s ^DHCPECBVIPLevel("PGT",RowId)=VipLevel
    s ^DHCPEDataEx("DHCPEPreGADM","TeamLevel",RowId)=TeamLevel
    s OldGTADMFeeType=^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",RowId)
    s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",RowId)=ADMFeeType
    s ^DHCPEDataEx("DHCPEPreGTeam","NoInclude",RowId)=$G(NoInCludeGroup)
    s ^DHCPEDataEx("DHCPEPreGADM","TeamEndanger",RowId)=Endanger
    s ^DHCPEDataEx("DHCPEPreGADM","OMEType",RowId)=OMEType
    s ^DHCPEDataEx("DHCPEPreGTeam","RoomPlace",RowId)=$G(RoomPlace)
    
    s GTeamID=RowId
    s PreGID=+GTeamID
    s GID=$o(^DHCPEGADM(0,"CRMGADM",PreGID,0))
    i GID'=""
    {
        s GTLIST(3)=PLIST(3)
        s GTLIST(5)=PLIST(8)
        s GTLIST(6)=PLIST(9)
        s GTLIST(7)=PLIST(10)
        s GTLIST(8)=PLIST(11)
        s GTLIST(9)=PLIST(12)
        s GTLIST(10)=PLIST(13)
        s GTLIST(11)=PLIST(14)
        s GTLIST(12)=PLIST(15)
        s GTLIST(13)=PLIST(16)
        s GTLIST(14)=PLIST(17)
        &SQL(update sqluser.dhc_pe_gteam values :GTLIST() where GT_CRMTeam=:GTeamID)
    
    
    }
    s ret=SQLCODE
    i '(("0"=ret)||("100"=ret)) goto UpdateErr
    
    s ret=..GTeamUpdateDate(RowId,tOldInfo)
    i '(("0"=ret)||("100"=ret)) goto UpdateErr  
    s ret=0
    s OldLimitFee=$p(tOldInfo,"^",8)
    s OldAddOrdItem=$p(tOldInfo,"^",6)
    i OldLimitFee'=PLIST(10)||(OldAddOrdItem'=PLIST(8)) d
    .s iAdm=0
    .f  s iAdm=$o(^DHCPEPreIADM(0,"PGTeam",RowId,iAdm)) q:(iAdm="")||(SQLCODE'=0)  d
    ..s SQLCODE=##class(web.DHCPE.PreAudit).UpdateFeeRecord(iAdm,"LimitFee")
    .q:SQLCODE
    .s ret=##class(web.DHCPE.PreIADM).UpdateGroupAuditAmount(+RowId)
    i ("0"'=ret) goto UpdateErr
    //修改就诊类型处理个人和团体费用
    //修改个人体检者项目或套餐对应的就诊类型
    i OldGTADMFeeType'=ADMFeeType  d
    .s SQLCODE=##class(web.DHCPE.PreIADM).UpdateItemFeeType(RowId,"TEAM",ADMFeeType)
    
    i OldRoomPlace'=RoomPlace d
    .d ##class(web.DHCPE.PreIADM).UpdateRoomPlace("TEAM",RowId,RoomPlace)
    
    //更新分组折扣率日志
    //获取分组信息
    s PreGTeamDataStr=##class(web.DHCPE.PreGTeam).DocListBroker("","",$p(RowId,"||",1)_"^^"_$p(RowId,"||",2))
    s OldPreRebate=$p(PreGTeamDataStr,"^",33)
    s OldAddGTRebate=$p(PreGTeamDataStr,"^",34)
    s OldAddITRebate=$p(PreGTeamDataStr,"^",35)
    
    i ((PLIST(22)'=OldPreRebate)||(PLIST(23)'=OldAddGTRebate)||(PLIST(24)'=OldAddITRebate)){
        d ##class(web.DHCPE.GAdmRecordManager).Insert(PreGID,"P","UpdateTeamDiscount","",GTeamID_"^"_PLIST(22)_"^"_PLIST(23)_"^"_PLIST(24)_"^"_OldPreRebate_"^"_OldAddGTRebate_"^"_OldAddITRebate)
    }
    
    TCOMMIT
    Q 0
UpdateErr
    TROLLBACK
    Q ret
}

/// 当团体组更改预约时间，更新其下所有成员的预约时间
ClassMethod GTeamUpdateDate(RowID, tOldInfo)
{
    new Date,Time,User,tInfo,GADM,tSub,iADM,iPLIST
    new EndDate,DelayDate,PEDeskClerk
    new tEndDate,tOldEndDate,tPEDeskClerk,tOldPEDeskClerk
    s SQLCODE=0
    s (EndDate,PEDeskClerk)=0
    s Date=+$H
    s Time=$p($H,",",2)
    s User=%session.Get("LOGON.USERID")
    s GADM=$p(RowID,"||",1)
    s tSub=$p(RowID,"||",2)
    s tInfo=$G(^DHCPEPreGADM(GADM,"Team",tSub))
    s tEndDate=$p(tInfo,"^",3)
    i tEndDate="" s tEndDate=0
    s tOldEndDate=$p(tOldInfo,"^",3)
    i tOldEndDate="" s tOldEndDate=0
    i tEndDate'=tOldEndDate s EndDate=1
    s tPEDeskClerk=$p(tInfo,"^",5)
    s tOldPEDeskClerk=$p(tOldInfo,"^",5)
    i tPEDeskClerk'=tOldPEDeskClerk s PEDeskClerk=1
    s OldLimitFee=$p(tOldInfo,"^",8)
    s OldLimit=$p(tOldInfo,"^",6)
    s iADM=0
    f  s iADM=$o(^DHCPEPreIADM(0,"PGTeam",RowID,iADM)) q:(iADM=""||SQLCODE'=0)  d
    .k iPLIST
    .s iInfo=$g(^DHCPEPreIADM(iADM))
    .s iPLIST(5)=..GetInfoByOrder(tInfo,2) //BeginDate
    .s iEndDate=..GetInfoByOrder(iInfo,5)
    .i iEndDate="" s iEndDate=0
    .i (iEndDate<tEndDate)&&(1=EndDate) s iPLIST(6)=tEndDate //EndDate
    .s iPEDeskClerk=..GetInfoByOrder(iInfo,7)
    .i (tPEDeskClerk'=iPEDeskClerk)&&(1=PEDeskClerk) s iPLIST(8)=tPEDeskClerk
    .if (OldLimitFee'=..GetInfoByOrder(tInfo,8)||(OldLimit'=..GetInfoByOrder(tInfo,6)))  d
    ..s iPLIST(11)=..GetInfoByOrder(tInfo,6)
    ..s iPLIST(12)=..GetInfoByOrder(tInfo,7)
    ..s iPLIST(13)=..GetInfoByOrder(tInfo,8)
    .s iPLIST(14)=..GetInfoByOrder(tInfo,9)
    .s iPLIST(15)=..GetInfoByOrder(tInfo,10)
    .s iPLIST(16)=..GetInfoByOrder(tInfo,11)
    .
    .s iPLIST(23)=Date
    .s iPLIST(22)=User
    .s iPLIST(24)=Time
    .&SQL(update sqluser.DHC_PE_PreIADM values :iPLIST() where PIADM_RowId=:iADM)
    .i SQLCODE=0  d
    ..s ADMFeeType=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",RowID))
    ..s ^DHCPEDataEx("DHCPEPreIADM","ADMFeeType",iADM)=ADMFeeType
    q SQLCODE
    
    
    
    q 0
    s CurData=$G(^DHCPEPreGADM(PLIST(0),"Team",PLIST(2)))
    s OBookDate=$p(CurData,"^",8)   //  旧预约日期
    s OBookTime=$p(CurData,"^",9)   //  旧预约时间
    
    s UBookDate=PLIST(10)           //  新预约日期
    s UBookTime=PLIST(11)           //  新预约时间
    s ret="0"
    i OBookDate'=UBookDate d
    .&sql(update DHC_PE_PreIADM
        set PIADM_BookDateBegin = :UBookDate
        where PIADM_PGTeam_DR = :RowId
        )
    .s ret=SQLCODE
    Q:('(("0"=ret)||("100"=ret))) ret
    
    s ret="0"
    i OBookTime'=UBookTime d
    .&sql(update DHC_PE_PreIADM
        set PIADM_BookTime = :UBookTime
        where PIADM_PGTeam_DR = :RowId
        )
    .s ret=SQLCODE
    Q ret
}

ClassMethod GetInfoByOrder(Info, Order)
{
    i Info="" q ""
    q $p(Info,"^",Order)
}

ClassMethod GTeamUpdateDateOld()
{
    q 0
    s CurData=$G(^DHCPEPreGADM(PLIST(0),"Team",PLIST(2)))
    s OBookDate=$p(CurData,"^",8)   //  旧预约日期
    s OBookTime=$p(CurData,"^",9)   //  旧预约时间
    
    s UBookDate=PLIST(10)           //  新预约日期
    s UBookTime=PLIST(11)           //  新预约时间
    s ret="0"
    i OBookDate'=UBookDate d
    .&sql(update DHC_PE_PreIADM
        set PIADM_BookDateBegin = :UBookDate
        where PIADM_PGTeam_DR = :RowId
        )
    .s ret=SQLCODE
    Q:('(("0"=ret)||("100"=ret))) ret
    
    s ret="0"
    i OBookTime'=UBookTime d
    .&sql(update DHC_PE_PreIADM
        set PIADM_BookTime = :UBookTime
        where PIADM_PGTeam_DR = :RowId
        )
    .s ret=SQLCODE
    Q ret
}

/// 提供给团体分组，团体的预约信息
/// w ##Class(web.DHCPE.PreGTeam).GetPreGTeamInfor("8||1")
ClassMethod GetPreGTeamInfor(id As %Library.String = "")
{
    Q:(""=id) ""
    s ParRef=$P(id,"||",1)
    s id=$P(id,"||",2)
    s CurData=$g(^DHCPEPreGADM(ParRef,"Team",id))

    s Data=""
    
    i ""'=CurData  d
    .
    .// PGT_Desc
    .s PGTDesc = $p(CurData,"^",1)
    .
    .// PGT_PEDeskClerk_DR 预约接待人员
    .s PGTPEDeskClerkDR = $p(CurData,"^",20)
    .i (""'=PGTPEDeskClerkDR)  d // 15.1
    ..s PGTPEDeskClerkDRName=$p($g(^SSU("SSUSR",PGTPEDeskClerkDR)),"^",2)
    .e  d           
    ..s PGTPEDeskClerkDRName=""
    .
    .// PGT_AddOrdItem  允许加项
    .s PGTAddOrdItem=$p(CurData,"^",8)
    .
    .// PGT_AddOrdItemLimit 加项金额限制
    .s PGTAddOrdItemLimit=$p(CurData,"^",9)
    .
    .// PGT_AddOrdItemAmount    允许加项金额
    .s PGTAddOrdItemAmount=$p(CurData,"^",10)
    .
    .// PGT_AddPhcItem  允许加药
    .s PGTAddPhcItem=$p(CurData,"^",11)
    .
    .// PGT_AddPhcItemLimit 加药金额限制
    .s PGTAddPhcItemLimit=$p(CurData,"^",12)
    .
    .// PGT_AddPhcItemAmount    允许加药金额 
    .s PGTAddPhcItemAmount=$p(CurData,"^",13)
    .
    .// PGT_GReportSend 团体报告发送
    .s PGTGReportSend=$p(CurData,"^",14)
    .s:(""'=PGTGReportSend) PGTGReportSendName =##Class(web.DHCPE.PreCommon).TransGReportSend(PGTGReportSend)
    .s:(""=PGTGReportSend) PGTGReportSendName = ""
    .
    .// PGT_IReportSend 个人报告发送
    .s PGTIReportSend=$p(CurData,"^",15)
    .s:(""'=PGTIReportSend) PGTIReportSendName =##Class(web.DHCPE.PreCommon).TransIReportSend(PGTIReportSend)
    .s:(""=PGTIReportSend) PGTIReportSendName = ""
    .
    .// PGT_DisChargedMode  结算方式
    .s PGTDisChargedMode=$p(CurData,"^",16)
    .s:(""'=PGTDisChargedMode) PGTDisChargedModeName =##Class(web.DHCPE.PreCommon).TransDisChargedMode(PGTDisChargedMode)
    .s:(""=PGTDisChargedMode) PGTDisChargedModeName = ""
    .
    .// PGT_BookDateBegin 预约日期
    .s PGTBookDateBegin = $p(CurData,"^",17)
    .i (""'=PGTBookDateBegin) s PGTBookDateBegin=$ZD(PGTBookDateBegin,4)
    .
    .// PGT_BookDateEnd
    .s PGTBookDateEnd = $p(CurData,"^",18)
    .i (""'=PGTBookDateEnd) s PGTBookDateEnd=$ZD(PGTBookDateEnd,4)
    .
    .// PGT_BookTime 预约时间
    .s PGTBookTime = $p(CurData,"^",19)
    .i (""'=PGTBookTime) s PGTBookTime=$ZT(PGTBookTime,2)
    .
    .//     0           1                   2                   3                       4                       5               6                   6.1                     7               8                           9                           10                  11                      12                  13                  13.1                        14                  14.1                            15                  15.1                            16                      16.1    
    .s Data=$G(id)_"^"_""_"^"_PGTDesc_"^"_PGTBookDateBegin_"^"_PGTBookDateEnd_"^"_PGTBookTime_"^"_PGTPEDeskClerkDR_"^"_PGTPEDeskClerkDRName_"^"_PGTAddOrdItem_"^"_PGTAddOrdItemLimit_"^"_PGTAddOrdItemAmount_"^"_PGTAddPhcItem_"^"_PGTAddPhcItemLimit_"^"_PGTAddPhcItemAmount_"^"_PGTGReportSend_"^"_PGTGReportSendName_"^"_PGTIReportSend_"^"_PGTIReportSendName_"^"_PGTDisChargedMode_"^"_PGTDisChargedModeName
    .
    q Data
}

ClassMethod TeamPreOver(TeamId)
{
    new iAdm,Status,Str
    s SQLCODE=0
    s iAdm=0
    f  s iAdm=$o(^DHCPEPreIADM(0,"PGTeam",TeamId,iAdm)) q:(iAdm="")||(SQLCODE'=0)  d
    .s Status=$p(^DHCPEPreIADM(iAdm),"^",8)
    .q:Status'="PREREG"
    .s Str=iAdm_"^PREREGED"
    .s SQLCODE=##class(web.DHCPE.PreIADM).CancelAdm("","",Str)
    q SQLCODE
}

Query PreTeamList(GID As %String) As %SQLQuery(ROWSPEC = "GT_Desc:%String:分组名称,GT_RowId:%String")
{
    select PGT_Desc,PGT_RowId 
    From DHC_PE_PreGTeam 
    where PGT_ParRef=:GID
}

/// ##Class(web.DHCPE.PreGTeam).GetGAdmDesc(GAdm)
ClassMethod GetGAdmDesc(GAdm)
{
    s gAdmDesc=""
    if GAdm="" q gAdmDesc
    s gBaseInfoId=$p($g(^DHCPEPreGADM(GAdm)),"^",1)
    if gBaseInfoId="" q gAdmDesc
    s gAdmDesc=$p($g(^DHCPEPreGBI(gBaseInfoId)),"^",2)
    q gAdmDesc
}

/// ##Class(web.DHCPE.PreGTeam).GetGTeamDesc(GTeam)
ClassMethod GetGTeamDesc(GTeam)
{
    if GTeam="" q ""
    q $p($g(^DHCPEPreGADM($p(GTeam,"||",1),"Team",$p(GTeam,"||",2))),"^",1)
}

ClassMethod CopyTeamData(GTRowId, GRowID As %String = "")
{
    
    s Date=+$h,Time=$p($h,",",2)
    //s UserID=%session.Get("LOGON.USERID")
    s:($d(%session)) UserID=%session.Get("LOGON.USERID")
    s:'$d(%session) UserID=5918
    s Data=$g(^DHCPEPreGADM($p($g(GTRowId),"||",1),"Team", $p($g(GTRowId),"||",2))) 
    i GRowID="" s GRowID=$p(GTRowId,"||",1)
    s PLIST(0)=GRowID
    //s PLIST(0)=$p(GTRowId,"||",1)
    k PLIST(1)
    k PLIST(2)
    //s PLIST(3)="新建分组"
    s PLIST(3)=$p(Data,"^",1)
    //预约开始日期,  结束日期,预约时间，PGT_PEDeskClerk_DR，
   //PGT_AddOrdItem,  GT_AddOrdItemLimi,PGT_AddOrdItemAmou，PGT_AddPhcItem，PGT_AddPhcItemLimit ,PGT_AddPhcItemAmount 
    //PGT_Sex ,  PGT_UpperLimit,PGT_LowerLimit ，PGT_Married ,PGT_UpdateUser_DR ,GT_UpdateDate, PGT_UpdateTime ,
    //s PLIST(4)=Date
    s PLIST(4)=$p(Data,"^",2)
    s PLIST(5)=$p(Data,"^",3) ,PLIST(6)=Time , PLIST(7)=$p(Data,"^",5)
    s PLIST(8)=$p(Data,"^",6),PLIST(9)=$p(Data,"^",7) ,PLIST(10)=$p(Data,"^",8) , PLIST(11)=$p(Data,"^",9),PLIST(12)=$p(Data,"^",10) , PLIST(13)=$p(Data,"^",11)
    s PLIST(14)=$p(Data,"^",12),PLIST(15)=$p(Data,"^",13) ,PLIST(16)=$p(Data,"^",14) , PLIST(17)=$p(Data,"^",15),PLIST(18)=UserID , PLIST(19)=Date, PLIST(20)=Time
    s PLIST(21)=$p(Data,"^",19)
    TSTART
    &SQL(Insert Into SQLUSER.DHC_PE_PreGTeam Values :PLIST())
    i SQLCODE=0
    {
        s GTeamID=$G(%ROWID)
        s PreGID=+GTeamID
        s ^DHCPECBVIPLevel("PGT",GTeamID)=$g(^DHCPECBVIPLevel("PGT",GTRowId))
        s ^DHCPEDataEx("DHCPEPreGTeam","RoomPlace",GTeamID)=$g(^DHCPEDataEx("DHCPEPreGTeam","RoomPlace",GTRowId))
        s ^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",GTeamID)=$g(^DHCPEDataEx("DHCPEPreGADM","ADMFeeType",GTRowId))
        
        s GID=$o(^DHCPEGADM(0,"CRMGADM",PreGID,0))
        i GID'=""
        {
            &SQL(insert into SQLUSER.dhc_pe_GTEAM 
            (GT_ParRef, GT_Desc, GT_CRMTeam,GT_AddOrdItem,GT_AddOrdItemLimit,GT_AddOrdItemAmount,GT_AddPhcItem,GT_AddPhcItemLimit,GT_AddPhcItemAmount,GT_Sex,GT_UpperLimit,GT_LowerLimit,GT_Married)
         select :GID,PGT_Desc,PGT_RowId,PGT_AddOrdItem,PGT_AddOrdItemLimit,PGT_AddOrdItemAmount,PGT_AddPhcItem,PGT_AddPhcItemLimit,PGT_AddPhcItemAmount,PGT_Sex,PGT_UpperLimit,PGT_LowerLimit,PGT_Married
          from SQLUSER.DHC_PE_PreGTeam
           Where PGT_RowId=:GTeamID )
        }
        d ##class(web.DHCPE.GAdmRecordManager).Insert(PreGID,"P","TeamInsert",PLIST(18),GTeamID) 
    }
    i SQLCODE'=0
    {
        TROLLBACK
        q SQLCODE
    }
    TCOMMIT
    s retVal=""
    //复制医嘱
    i SQLCODE=0
    {
    s ChildSub=0
    f  s ChildSub=$o(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub))  q:ChildSub=""  d
    .s OrderSetsDR=""
    .s ItmMastDR=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub),"^",1)
    .s PGTOIItemStat=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub),"^",13)
    .q:PGTOIItemStat'=1
    .s PGTOIOrdEntDR=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub),"^",2)
    .i PGTOIOrdEntDR'=""  s OrderSetsDR=$p(^DHCPEPreGADM($p(PGTOIOrdEntDR,"||",1),"Team", $p(PGTOIOrdEntDR,"||",2),"ORDENT", $p(PGTOIOrdEntDR,"||",3)),"^",1)
    .i OrderSetsDR="" s retVal=##class(web.DHCPE.PreItemList).IInsertItem(GTeamID,"TEAM","PRE",ItmMastDR,"",UserID)
    
    s ChildEntSub=0
    f  s ChildEntSub=$o(^DHCPEPreGADM($p(GTRowId,"||",1),"Team",$p(GTRowId,"||",2),"ORDENT",ChildEntSub))  q:ChildEntSub=""  d
    .s OrderSetsDR=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2),"ORDENT", ChildEntSub),"^",1)
    .s PGTOEItemStat=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2),"ORDENT",ChildEntSub),"^",7)
    .q:PGTOEItemStat'=1
    .q:OrderSetsDR=""
    .s retVal=##class(web.DHCPE.PreItemList).IInsertItem(GTeamID,"TEAM","PRE","",OrderSetsDR,UserID)
  
    }
 q retVal
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreGTeam","SearchGDepart",13,"","PRE")
Query SearchGDepart(GID As %String = "", TeamID As %String = "", Type As %String = "", Depart) As %Query(ROWSPEC = "DepartName:%String")
{
}

ClassMethod SearchGDepartExecute(ByRef qHandle As %Binary, GID As %String = "", TeamID As %String = "", Type As %String = "", Depart As %String = "") As %Status
{
    
    Set repid=$I(^CacheTemp)
    i (GID="")
    {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
    }
    s Job=$J
    s ind=1
    if Type=""
    {
        s teamID=""
        f  s teamID=$O(^DHCPEIADM(0,"GADM",GID,teamID)) q:teamID=""  d
        .q:(TeamID'="")&&(TeamID'=teamID)
        .s id=""
        .f  s id=$O(^DHCPEIADM(0,"GADM",GID,teamID,id)) q:id=""  d
        ..s crmID=$P($g(^DHCPEIADM(id)),"^",4)
        ..s CurDepart=$g(^DHCPEDataEx("DHCPEPreIADM","Position",crmID))
        ..s PreIBID=$p($g(^DHCPEPreIADM(crmID)),"^",1)
        ..i CurDepart="" s CurDepart=$p($g(^DHCPEPreIBI(PreIBID)),"^",11)
        ..q:CurDepart=""
        ..q:(Depart'="")&&(CurDepart'[Depart)
        ..s ^TempDHCPE(Job,CurDepart)=""
    
    }
    else
    {
        s ctype="PGADM"
        s cid=GID
        i TeamID["||" d
        .s ctype="PGTeam"
        .s cid=TeamID
        s id=""
        f  s id=$O(^DHCPEPreIADM(0,ctype,cid,id)) q:id=""  d
        .s CurDepart=$g(^DHCPEDataEx("DHCPEPreIADM","Position",id))
        .s PreIBID=$p($g(^DHCPEPreIADM(id)),"^",1)
        .i CurDepart="" s CurDepart=$p($g(^DHCPEPreIBI(PreIBID)),"^",11)
        .q:CurDepart=""
        .q:(Depart'="")&&(CurDepart'[Depart)
        .s ^TempDHCPE(Job,CurDepart)=""
    }
    s CurDepart=""
    f  s CurDepart=$O(^TempDHCPE(Job,CurDepart)) q:CurDepart=""  d
    .d SearchGDepartBuild
    k ^TempDHCPE(Job)
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
SearchGDepartBuild
    set Data=$lb(CurDepart)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    q
}

ClassMethod SearchGDepartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchGDepartExecute ]
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

ClassMethod SearchGDepartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchGDepartExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// 判断组Team或者个人Person是否出现在团体中
ClassMethod IsIncludeGroup(ID, Type)
{
    ;q:##class(web.DHCPE.PreGTeam).IsIncludeGroup(ID, "Team")="0"
    s Flag=1
    i Type="Team"{
        
    }else{
        s ID=$P($G(^DHCPEPreIADM(ID)),"^",3)
    }
    i ID'=""{
        s NoIncludeFlag=$g(^DHCPEDataEx("DHCPEPreGTeam","NoInclude",ID))
        s:NoIncludeFlag="1" Flag=0
    }
    q Flag
}

/// for team Template
/// Component:DHCPEPreGTeam.Edit
ClassMethod GTeamTempSet(InStr, ID, Type As %Library.String)
{
    s flag=0
    i Type="Set" d
    .;s ^DHCPEDataEX("DHCPEGTeamTemplateRowId")=$G(^DHCPEDataEX("DHCPEGTeamTemplateRowId"))+1
    .s SetRowId=$I(^DHCPEDataEX("DHCPEGTeamTemplateRowId"))
    .s Desc=$P($G(InStr),"^",1)
    .s AgeFrom=$P($G(InStr),"^",2)
    .s AgeTo=$P($G(InStr),"^",3)
    .s Sex=$P($G(InStr),"^",4)
    .s Married=$P($G(InStr),"^",5)
    .s PGTID=$P($G(InStr),"^",6)
    .s ^DHCPEDataEX("DHCPEGTeamTemplate",SetRowId)=Desc_"^"_AgeFrom_"^"_AgeTo_"^"_Sex_"^"_Married_"^^^^^^^^^"_"^"_PGTID
    .s flag=1
    e  i Type="Del"  d
    .k ^DHCPEDataEX("DHCPEGTeamTemplate",ID)
    .s flag=1
    i flag=1 q 0
    e  q "None has been changed"
}

/// d ##class(web.DHCPE.PreGTeam).OutGTeamTempSetBtn()
ClassMethod OutGTeamTempSetBtn(ID)
{
    q:ID=""
    s disabled=""
        w "<button onclick='DelGTeamTemp(this)' id='"_ID_"' name='BtnDel' "_disabled_"  class='i-btn'>删除</button>"
    q $$$OK
}

// Query GetGTeamTempSet(VIP As %Library.String = "") As %Query(ROWSPEC = "TID:%String,TAgeFrom:%String,TAgeTo:%String,TSex:%String,THouse:%String,TDesc:%String")

/// 功能:分组预制模板
/// 测试：d ##class(%ResultSet).RunQuery("web.DHCPE.PreGTeam","GetGTeamTempSet","","","",1)
Query GetGTeamTempSet(VIP As %Library.String = "", ToGID As %Library.String = "", GBID As %Library.String = "", TemplateFlag As %Library.String = "", LocID) As %Query(ROWSPEC = "TID:%String,TAgeFrom:%String,TAgeTo:%String,TSex:%String,THouse:%String,TDesc:%String,TTeamID:%String,GDesc:%String,GTeamDesc:%String,TAgeRange:%String,TTeamSex:%String,TMarried:%String,TAmt:%String,TSexDesc:%String,THouseDesc:%String")
{
}

ClassMethod GetGTeamTempSetExecute(ByRef qHandle As %Binary, VIP As %Library.String = "", ToGID As %Library.String = "", GBID As %Library.String = "", TemplateFlag As %Library.String = "", LocID) As %Status
{

    Set repid=$I(^CacheTemp)
    s ind=1
    
    if ((GBID="")&&(TemplateFlag="")){
        Set qHandle=$lb(0,repid,0)  
        Quit $$$OK
    }
    i GBID=""
    {
    s id=0
    f  s id=$O(^DHCPEDataEX("DHCPEGTeamTemplate",id)) q:id=""  d
    .d Clear
    .s Str=$G(^DHCPEDataEX("DHCPEGTeamTemplate",id))
    .s TID=id
    .s TAgeFrom=$P(Str,"^",2)
    .s TAgeTo=$P(Str,"^",3)
    .s TAgeRange=TAgeFrom_"-"_TAgeTo
    .s TSex=$P(Str,"^",4)
    .s THouse=$P(Str,"^",5)
    .i TSex="M" s TSexDesc="男",TTeamSex=TSexDesc
    .i TSex="F" s TSexDesc="女",TTeamSex=TSexDesc
    .i TSex="N" s TSexDesc="不限",TTeamSex=TSexDesc
    .i THouse="M" s THouseDesc="已婚",TMarried=THouseDesc
    .i THouse="UM" s THouseDesc="未婚",TMarried=THouseDesc
    .i THouse="N" s THouseDesc="不限",TMarried=THouseDesc

    .s TDesc=$P(Str,"^",1)
    .s GTeamDesc=TDesc
    .s TTeamID=$P(Str,"^",$L(Str,"^"))
    .i TTeamID'="" d
    ..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",$p(TTeamID,"||",1),LocID)          
    ..q:LocFlag=1
    ..s obj=##class(User.DHCPEPreGTeam).%OpenId(TTeamID)
    ..s GDesc=obj.PGTParRef.PGADMPGBIDR.PGBIDesc
    ..s GTeamDesc=obj.PGTDesc
    ..s TAgeRange=obj.PGTLowerLimit_"-"_obj.PGTUpperLimit
    ..
    ..s TTeamSex=obj.PGTSex
    ..s TMarried=obj.PGTMarried
    ..
    .d FindBuild
   }else{
        s PreGAdm=""
        f  s PreGAdm=$O(^DHCPEPreGADM(0,"PGBI",GBID,PreGAdm)) q:(PreGAdm="")||(PreGAdm=0)  d
        .s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",PreGAdm,LocID)          
        .q:LocFlag=1 
        .s TeamSub=0
        .f  s TeamSub=$O(^DHCPEPreGADM(PreGAdm,"Team",TeamSub)) q:TeamSub=""  d
        ..d Clear
        ..s TTeamID=PreGAdm_"||"_TeamSub
        ..s obj=##class(User.DHCPEPreGTeam).%OpenId(TTeamID)
        ..s GDesc=obj.PGTParRef.PGADMPGBIDR.PGBIDesc
        ..s GTeamDesc=obj.PGTDesc
        ..s TAgeRange=obj.PGTLowerLimit_"-"_obj.PGTUpperLimit
        ..s TTeamSex=obj.PGTSex
        ..i TTeamSex="M" s TTeamSex="男"
        ..i TTeamSex="F" s TTeamSex="女"
        ..i TTeamSex="N" s TTeamSex="不限"
        ..s TMarried=obj.PGTMarried
        ..i TMarried="M" s TMarried="已婚"
        ..i TMarried="UM" s TMarried="未婚"
        ..i TMarried="N" s TMarried="不限"
        ..d FindBuild
    }
    
    Set qHandle=$lb(0,repid,0)  
    Quit $$$OK
        
Clear
    s (TID,TTeamID,TAgeFrom,TAgeTo,TSex,THouse,TDesc,TSexDesc,THouseDesc)=""
    q 
FindBuild
    s TAmt=""
    s:TTeamID'="" TAmt=..GetTeamAmt(TTeamID)
    i ((""'=TAmt)&&(TAmt[".")) d
    .i $p(TAmt,".",1)="" s TAmt=0_TAmt
    i TAgeRange="-" s TAgeRange=""
    set Data=$lb(TID,TAgeFrom,TAgeTo,TSex,THouse,TDesc,TTeamID,GDesc,GTeamDesc,TAgeRange,TTeamSex,TMarried,$fn(TAmt,"",2),TSexDesc,THouseDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetGTeamTempSetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGTeamTempSetExecute ]
{
    s repid=$List(qHandle,2)
    kill ^CacheTmp(repid)
    Quit $$$OK
}

ClassMethod GetGTeamTempSetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGTeamTempSetExecute ]
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

ClassMethod GetTeamAmt(GTRowId)
{
    s Amt=0
    s ChildSub=0
    f  s ChildSub=$o(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub))  q:ChildSub=""  d
    
    .s ItmMastDR=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub),"^",1)
    .s PGTOIItemStat=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub),"^",13)
    .q:PGTOIItemStat'=1
    .s PGTOIOrdEntDR=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub),"^",2)
    .q:PGTOIOrdEntDR'=""
    .s Amt=Amt+$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDITEM",ChildSub),"^",11)
    s ChildEntSub=0
    f  s ChildEntSub=$o(^DHCPEPreGADM($p(GTRowId,"||",1),"Team",$p(GTRowId,"||",2),"ORDENT",ChildEntSub))  q:ChildEntSub=""  d
    .s OrderSetsDR=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2),"ORDENT", ChildEntSub),"^",1)
    .s PGTOEItemStat=$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2),"ORDENT",ChildEntSub),"^",7)
    .q:PGTOEItemStat'=1
    .s Amt=Amt+$p(^DHCPEPreGADM($p(GTRowId,"||",1),"Team", $p(GTRowId,"||",2) ,"ORDENT",ChildEntSub),"^",6)
    q Amt
}

/// Creator： xy
/// CreatDate： 20220414
/// Description: 判断分组中是否有有效人员级人员的性别 
/// Input: TeamID（分组ID）
/// Dubug: d ##class(web.DHCPE.PreGTeam).IsExistPersonInTeam("21||1")
ClassMethod IsExistPersonInTeam(TeamID)
{
    s Flag=0
    s SexFlag="N"
    s iAdm=0
    f  s iAdm=$o(^DHCPEPreIADM(0,"PGTeam",TeamID,iAdm)) q:(iAdm="")||(Flag=1)  d
    .s Status=$p($g(^DHCPEPreIADM(iAdm)),"^",8)
    .q:Status="CANCELPE"
    .s Flag=1
    .s PIBIDR=$p($g(^DHCPEPreIADM(iAdm)),"^",1)
    .s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
    .s SexDesc="",SexFlag="N"
    .i SexDR'="" s SexDesc=$p($g(^CT("SEX",SexDR)),"^",2)
    .i SexDesc["男" s SexFlag="M"
    .i SexDesc["女" s SexFlag="F"
    q Flag_"^"_SexFlag
}

}
