Import sqluser

/// Descript:入库主表相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-25
Class web.DHCST.DHCINGdRec Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCSTIMPORT";

/// Descript:   保存/更新入库单信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-26
/// Table:DHC_InGdRec,DHC_InGdRecItm
/// Input:入库单号,供应商id^入库科室id^建单人^商业赠送标志^调价换票标志^入库类型id^采购员id^类组id^订单id,
/// 明细id^库存项RowId^批号^效期^厂商RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期^订单明细id,
/// 明细id^库存项RowId^批号^效期^厂商RowId^入库单位RowId^入库数量^进价^New售价^随行单号^发票号^发票日期^订单明细id,
/// Output:     
/// Return：成功：入库主表id；
/// -99  ;加锁失败
/// -2   ;生成入库单号失败
/// -3    ;保存入库单失败
/// -4   ;未找到需更新的入库单
/// -5:保存入库单明细失败
/// -7其它：部分明细保存不成功，提示不成功的药品
/// -8 入库单已完成,-9入库单已审核
/// w ##class(web.DHCST.DHCINGdRec).Save("","","")
ClassMethod Save(IngrNo As %String, MainInfo As %String, ListData As %String) As %Library.String
{
    n (IngrNo,MainInfo,ListData)
    s Ret=0
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    i IngrNo=""  d
    .s IngrId=..Insert(MainInfo)     ;保存入库主表
    e  d
    .s IngrId=$o(^DHCINGR(0,"No",$$ALPHAUP^SSUTIL4(IngrNo),0))
    .s:+IngrId<0 IngrId=-4   ;未找到需更新的入库单
    .q:IngrId<0
    .i $p(^DHCINGR(IngrId),"^",12)="Y" s IngrId=-8 ;入库单已完成
    .q:IngrId<0
    .i $p(^DHCINGR(IngrId),"^",29)="Y" s IngrId=-9 ;入库单已审核
    .q:IngrId<0
    .s Ret=..Update(IngrId,MainInfo)  ;更新入库主表信息
    .s:Ret'=0 IngrId=-3
    .
    ;b ;1
    i +IngrId<=0 trollback
    q:+IngrId<=0 IngrId
    i ListData'=""  d
    .s Ret=##class(web.DHCST.DHCINGdRecItm).Save(IngrId,ListData)
    .//i IngrNo="" d
    .//.s InvNo=$p(ListData,"^",11)
    .//.s RetFlag=##class(web.DHCST.DHCINGdRecItm).CheckInvnoExist(IngrId,InvNo)
    .//.i RetFlag=1 s Ret=-77
    
    i (+Ret=-6)!(+Ret=-5) trollback
    q:(+Ret=-6)!(+Ret=-5) -5 
    //q:(+Ret=-77) -77
    
    /// 更新临购药品相关信息
    s Ret=##Class(PHA.IN.TmpDrugPurIngd.Save).CheckIngdIfFit(IngrId)
    i Ret'=0 tro
    q:Ret'=0 Ret
    
    tcommit    ;只要有入库单明细保存成功，则提交事务
    q:+Ret'=0 Ret   ;存在保存失败的明细
    q IngrId
}

/// Descript:   查询入库单
/// Creater:zhangdongmei
/// CreateDate:2012-06-26
/// Input:开始行,一页显示记录数,排序字段,排序方向,
/// 开始日期^截止日期^入库单号^供应商id^科室id^完成标志^药品id^审核标志^发票号
/// Output:     
/// Return：入库主表id^入库单号^供应商^入库科室^入库类型^采购员^订单号^制单人^
/// 制单日期^完成标志^请求科室^类组^进价金额^售价金额
ClassMethod Query(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String) As %String
{
    n (StrParam,Start,Limit,Sort,Dir)
    q:StrParam="" ""
    s StartDate	= $p(StrParam,"^",1)
    s EndDate  	= $p(StrParam,"^",2) 
    s No		= $p(StrParam,"^",3)
    s VendorId	= $p(StrParam,"^",4)
    s RecLocId	= $p(StrParam,"^",5)
    s CompFlag	= $p(StrParam,"^",6)
    s IncId		= $p(StrParam,"^",7)
    s AuditFlag	= $p(StrParam,"^",8)
    s InvNo		= $p(StrParam,"^",9)
    s MZJYFlag 	= $p(StrParam,"^",10)
    q:StartDate="" ""
    q:EndDate="" ""
    q:RecLocId="" ""
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
    s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    ;
    s sqlStr = "select INGR_RowId as Rowid,INGR_No,INGR_APCVM_DR,INGR_APCVM_DR->APCVM_Name as Vendor,"_
    "INGR_Loc_Dr->CTLOC_Desc as RecLoc, INGR_Type->IPT_Desc as IngrType, INGR_SSUSR_Purch_DR->SSUSR_NAME AS PurchUser,"_
    "INGR_INPO_DR->INPO_No as PoNo, INGR_CreateUser->SSUSR_NAME AS CreateUser, INGR_CreateDate,"_
    "INGR_Completed,INGR_ReqLoc_Dr->CTLOC_Desc as ReqLoc,INGR_SCG_DR->SCG_Desc as StkGrp,INGR_AuditFlag, "_
    "INGR_Date,INGR_SSUSR_DR,INGR_SSUSR_Accept_DR,INGR_StkType stkType  "_
    "from DHC_INGdRec where (INGR_CreateDate between "_StartDate_" and "_EndDate_") and INGR_Loc_Dr="_RecLocId
    ; 
    s OrderField="Rowid"
    ;
    s:Sort="IngrNo" OrderField="INGR_No"
    s:Sort="Vendor" OrderField="Vendor"
    s:Sort="IngrType" OrderField="IngrType"
    s:Sort="PurchUser" OrderField="PurchUser"
    s:Sort="PoNo" OrderField="PoNo"
    s:Sort="CreateUser" OrderField="CreateUser"
    s:Sort="CreateDate" OrderField="INGR_CreateDate"
    s:Sort="Complete" OrderField="INGR_Completed"
    s:Sort="ReqLoc" OrderField="ReqLoc"
    s:Sort="StkGrp" OrderField="StkGrp"
    ;
    s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i OrderField'=""  d
    .s sqlStr=sqlStr_" order by "_OrderField_" "_Dir
    s json = ##class(Code.JsonObj).%New()
    s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(sqlStr)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    If err  q ""
    s count = 0
    s resultString = ""
    s end = Start+Limit
    s json = ##class(Code.JsonObj).%New()
    While(result.Next())
    {
        s IngrId = result.Data("Rowid")
        s IngrNo = result.Data("INGR_No")
        s Vendor = result.Data("Vendor")
        s VenId=result.Data("INGR_APCVM_DR")
        s RecLoc = result.Data("RecLoc")
        s IngrType=result.Data("IngrType")
        s PurchUser=result.Data("PurchUser")
        s PoNo = result.Data("PoNo")
        s CreateUser = result.Data("CreateUser")
        s CreateDate = result.Data("INGR_CreateDate")
        s Complete = result.Data("INGR_Completed")
        s ReqLoc = result.Data("ReqLoc")
        s StkGrp = result.Data("StkGrp")
        s Audit=result.Data("INGR_AuditFlag")
        s:Audit="" Audit="N"
        s AuditUserId=result.Data("INGR_SSUSR_DR")
        s AuditDate=result.Data("INGR_Date")
        s AcceptUserId=result.Data("INGR_SSUSR_Accept_DR")
        s stkType=result.Data("stkType")
        CONTINUE:(stkType'="")&(stkType'=..sssCode())
        CONTINUE:(AuditFlag'="")&(Audit'=AuditFlag)
        CONTINUE:(CompFlag'="")&(Complete'=CompFlag)
        CONTINUE:(No'="")&(IngrNo'=No)
        CONTINUE:(VendorId'="")&(VenId'=VendorId)
        s Chl=""
        s:IncId'="" Chl=$o(^DHCINGR(0,"INCI",IncId,IngrId,0))
        CONTINUE:(IncId'="")&($g(Chl)="") 
        s Sub=""
        s:InvNo'="" Sub=$o(^DHCINGR(0,"INVNO",$$ALPHAUP^SSUTIL4(InvNo),IngrId,0))
        CONTINUE:(InvNo'="")&($g(Sub)="") 
        //总金额
        &sql(select sum(initm_realtotal),sum(initm_SpAmt) 
        into :RpAmt,:SpAmt from dhc_ingdrecitm where ingri_ingr_parref=:IngrId)
        s AuditUser=""
        s AcceptUser=""
        s:CreateDate'="" CreateDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CreateDate,"ST")
        s:AuditDate'="" AuditDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AuditDate,"ST")
        s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
        s:AcceptUserId'="" AcceptUser=$p(^SSU("SSUSR",AcceptUserId),"^",2)
        s Margin=SpAmt-RpAmt
        i Complete="Y"  d
        .s Complete="完成"
        e  d
        .s Complete="未完成"
        .
        i Audit="Y"  d
        .s Audit="已审核"
        e  d
        .s Audit="未审核"
        continue:(MZJYFlag = "Y")&&(..CheckMZJYExsit(IngrId) '= "Y")
        s MZJYAudit1 = ##Class(BS.PHA.IN.Status).GetUser("User.DHCINGdRec" ,IngrId, "MZJY1")
        s MZJYAudit2 = ##Class(BS.PHA.IN.Status).GetUser("User.DHCINGdRec" ,IngrId, "MZJY2")
        
    
        s Data1=IngrId_"^"_IngrNo_"^"_Vendor_"^"_RecLoc_"^"_IngrType_"^"_PurchUser_"^"_PoNo_"^"_CreateUser 
        s Data2=CreateDate_"^"_Complete_"^"_ReqLoc_"^"_StkGrp_"^"_RpAmt_"^"_SpAmt_"^"_AuditDate_"^"_$g(AuditUser)_"^"_Margin_"^"_$g(AcceptUser)_"^"_VenId
        s Data3 = MZJYAudit1_"^"_MZJYAudit2
        s Data=Data1_"^"_Data2_"^"_Data3
        s count = count+1   
        CONTINUE:count<(Start+1)
        CONTINUE:count>end  
        d json.InsertRowData(Data)
    }
    s Title1="IngrId^IngrNo^Vendor^RecLoc^IngrType^PurchUser^PoNo^CreateUser"
    s Title2="CreateDate^Complete^ReqLoc^StkGrp^RpAmt^SpAmt^AuditDate^AuditUser^Margin^AcceptUser^VenId"
    s Title3 = "MZJYAudit1^MZJYAudit2"
    s Title=Title1_"^"_Title2 _"^"_ Title3
    s resultString = json.getJsonData(Title,count)
    k json
    q resultString
}

/// Descript:根据RowId取得入库单主项信息
/// Creater:zhangdongmei
/// CreateDate: 2012-06-25
/// Input:  入库主表id  
/// Output:     
/// Return：入库单号^供应商id^供应商名称^审核日期^审核人id^审核人^审核时间^
/// 订单id^订单号^完成标志^入库科室id^入库科室名称^制单日期^制单时间^制单人id^
/// 制单人^允许付款标志^入库类型id^入库类型^采购员id^采购员^请求科室id^请求科室^
/// 收货人id^收货人^记账人id^记账人^类组id^类组^审核标志^赠药入库标志^调价换票标志
/// w ##class(web.DHCST.DHCINGdRec).Select(7234)
ClassMethod Select(Ingr As %String) As %String
{
    n (Ingr)
    q:+Ingr=0 ""
    S InGrNo =$p(^DHCINGR(Ingr),"^",1)
    S ApcvmDr =$p(^DHCINGR(Ingr),"^",3)
    s:ApcvmDr'="" Vendor=$p(^APC("APCVM",ApcvmDr),"^",3)
    s AuditDate=$p(^DHCINGR(Ingr),"^",4)
    s:+AuditDate'=0 AuditDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AuditDate,"ST")
    s AuditUserId=$p(^DHCINGR(Ingr),"^",8)
    s:AuditUserId'="" AuditUser=$p(^SSU("SSUSR",AuditUserId),"^",2)
    s AuditTime=$p(^DHCINGR(Ingr),"^",9)
    s:+AuditTime'=0 AuditTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(AuditTime,"ST")
    s PoId=$p(^DHCINGR(Ingr),"^",11)
    s:PoId'="" PoNo=$p(^INPO(PoId),"^",1)
    s Complete=$p(^DHCINGR(Ingr),"^",12)
    s LocId=$p(^DHCINGR(Ingr),"^",13)
    s:LocId'="" LocDesc=$p(^CTLOC(LocId),"^",2)
    s CreateDate=$p(^DHCINGR(Ingr),"^",14)
    s:+CreateDate'=0 CreateDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CreateDate,"ST")
    s CreateTime=$p(^DHCINGR(Ingr),"^",15)
    s:+CreateTime'=0 CreateTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(CreateTime,"ST")
    s CreateUserId=$p(^DHCINGR(Ingr),"^",16)
    s:CreateUserId'="" CreateUser=$p(^SSU("SSUSR",CreateUserId),"^",2)
    s PayAllowed=$p(^DHCINGR(Ingr),"^",22)   ;是否允许付款
    s IngrTypeId=$p(^DHCINGR(Ingr),"^",23)
    s:IngrTypeId'="" IngrType=$p($g(^DHCOPTYPE(IngrTypeId)),"^",2)
    s PurUserId=$p(^DHCINGR(Ingr),"^",24)
    s:PurUserId'="" PurUser=$p(^SSU("SSUSR",PurUserId),"^",2)
    s ReqLocId=$p(^DHCINGR(Ingr),"^",25)
    s:ReqLocId'="" ReqLoc=$p(^CTLOC(ReqLocId),"^",2)
    s AcceptUserId=$p(^DHCINGR(Ingr),"^",26)
    s:AcceptUserId'="" AcceptUser=$p(^SSU("SSUSR",AcceptUserId),"^",2)
    s TreasureUserId=$p(^DHCINGR(Ingr),"^",27)
    s:TreasureUserId'="" TreasureUser=$p(^SSU("SSUSR",TreasureUserId),"^",2)
    s StkGrpId=$p(^DHCINGR(Ingr),"^",28)
    s:StkGrpId'="" StkGrp=$p(^DHCSCG(StkGrpId),"^",2)
    s AuditFlag=$p(^DHCINGR(Ingr),"^",29)
    s StkType=$p(^DHCINGR(Ingr),"^",30)
    q:StkType'=..sssCode() ""
    s GiftFlag=$p(^DHCINGR(Ingr),"^",31)
    s AdjCheque=$p(^DHCINGR(Ingr),"^",32)
    ;
    s Data1=InGrNo_"^"_ApcvmDr_"^"_$g(Vendor)_"^"_AuditDate_"^"_AuditUserId_"^"_$g(AuditUser)
    s Data2=AuditTime_"^"_PoId_"^"_$g(PoNo)_"^"_Complete_"^"_LocId_"^"_$g(LocDesc)
    s Data3=CreateDate_"^"_CreateTime_"^"_CreateUserId_"^"_$g(CreateUser)_"^"_PayAllowed_"^"_IngrTypeId
    s Data4=$g(IngrType)_"^"_PurUserId_"^"_$g(PurUser)_"^"_ReqLocId_"^"_$g(ReqLoc)_"^"_AcceptUserId
    s Data5=$g(AcceptUser)_"^"_TreasureUserId_"^"_$g(TreasureUser)_"^"_StkGrpId_"^"_$g(StkGrp)_"^"_AuditFlag
    s Data6=GiftFlag_"^"_AdjCheque
    s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6
    q Data
}

/// Descript:插入入库主表记录
/// Creater:ZhangDongmei
/// CreateDate: 2012-06-26
/// Table:DHC_InGdRec
/// Input:供应商id^入库科室id^建单人^商业赠送标志^调价换票标志^入库类型id^采购员id^类组id  
/// Output:     
/// Return：成功：入库主表id；
/// -99  ;加锁失败
/// -2   ;生成入库单号失败
/// -3    ;保存入库单失败  
ClassMethod Insert(MainInfo) As %Library.String
{
    n (MainInfo)
    s VenId=$P(MainInfo,"^",1)
    s LocId=$p(MainInfo,"^",2)
    s CreateUser=$p(MainInfo,"^",3)
    s CreateDate=+$h
    s CreateTime=$p($h,",",2)
    s PresentFlag=$p(MainInfo,"^",4)
    s ExchangeFlag=$p(MainInfo,"^",5)
    s IngrTypeId=$p(MainInfo,"^",6)
    s PurUserId=$p(MainInfo,"^",7)
    s StkGrpId=$p(MainInfo,"^",8)
    s PoId=$p(MainInfo,"^",9)
    s Complete="N"
    s AuditFlag="N"
    s StkType=..sssCode()
    ;
    s AppName=##class(web.DHCST.DHCINGdRec).%GetParameter("AppName")
    ;生成单号需加锁
    s ret=##class(web.DHCST.Common.AppCommon).Lock("IMPORTNO")  
    q:ret'=0 -99  ;加锁失败
    ;
    s IngrNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,StkGrpId,LocId)
    i IngrNo="" d ##class(web.DHCST.Common.AppCommon).UnLock("IMPORTNO")
    q:IngrNo="" -2   ;生成单号失败
    ;
    s Err=0
    &sql(insert into dhc_ingdrec(INGR_APCVM_DR,INGR_Completed,INGR_CTCUR_DR,
         INGR_ExRate,INGR_HandChg,INGR_No,INGR_Loc_Dr,INGR_CreateUser,
         INGR_CreateDate,INGR_CreateTime,INGR_AdjCheque,INGR_GiftFlag,INGR_Type,
         INGR_SSUSR_Purch_DR,INGR_SCG_DR,INGR_AuditFlag,INGR_StkType,INGR_INPO_DR) 
         values (:VenId,:Complete,1,1,0,:IngrNo,:LocId,:CreateUser,:CreateDate,:CreateTime,
         :ExchangeFlag,:PresentFlag,:IngrTypeId,:PurUserId,:StkGrpId,:AuditFlag,:StkType,:PoId))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:dhc_ingdrec",IngrNo,SQLCODE_":"_%msg)
    .s Err=-3
    .
    d ##class(web.DHCST.Common.AppCommon).UnLock("IMPORTNO")
    q:Err'=0 -3    ;保存入库单失败
    ;
    q $p($g(%ROWID),$c(1))
}

/// Descript:   更新入库主表记录
/// Creater:    zhangyong
/// CreateDate: 2011-12-1
/// Table:DHC_InGdRec
/// Input:rowid,供应商id^入库科室id^建单人^商业赠送标志^调价换票标志^入库类型id^采购员id^类组id
/// Output:     
/// Return：成功：0；
/// -3：更新入库单失败  
ClassMethod Update(IngrId As %String, MainInfo As %String) As %Library.String
{
    n (IngrId,MainInfo)
    q:IngrId="" -1
    s VenId=$P(MainInfo,"^",1)
    s LocId=$p(MainInfo,"^",2)
    s CreateUser=$p(MainInfo,"^",3)
    s CreateDate=+$h
    s CreateTime=$p($h,",",2)
    s PresentFlag=$p(MainInfo,"^",4)
    s ExchangeFlag=$p(MainInfo,"^",5)
    s IngrTypeId=$p(MainInfo,"^",6)
    s PurUserId=$p(MainInfo,"^",7)
    ;INGR_CreateUser=:CreateUser, INGR_CreateDate=:CreateDate, INGR_CreateTime=:CreateTime,
    s Err=0
    &sql(UPDATE dhc_ingdrec SET INGR_APCVM_DR = :VenId, INGR_Loc_Dr=:LocId,
        INGR_Type=:IngrTypeId, INGR_SSUSR_Purch_DR=:PurUserId,INGR_AdjCheque=:ExchangeFlag,
        INGR_GiftFlag=:PresentFlag WHERE INGR_Rowid=:IngrId)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:dhc_ingdrec",IngrId,SQLCODE_":"_%msg)
    .s Err=-3
    .
    q Err
}

/// Descript:   删除入库单
/// Creater:    zhangdongmei
/// CreateDate: 2012-06-27
/// Input:      
/// Output:     
/// Return：0:成功 
///  -1     ;入库单已经完成，不能删除
///  -2     ;入库单已经审核，不能删除
///  -3		;有已审核的明细数据, 不能删除
ClassMethod Delete(IngrId) As %Library.String
{
    n (IngrId)
    ;
    q:IngrId="" ""
    q:'$d(^DHCINGR(IngrId)) 0   ;已经删除
    s CompFlag=$p(^DHCINGR(IngrId),"^",12)
    s AuditFlag=$p(^DHCINGR(IngrId),"^",29)
    q:CompFlag="Y" -1       ;入库单已经完成，不能删除
    q:AuditFlag="Y" -2      ;入库单已经审核，不能删除
    q:..IsIngriAudited(IngrId)=1 -3
    ;
    s Err=0
    &sql(Delete from DHC_InGdRec  where INGR_Rowid=:IngrId) 
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHC_InGdRec",IngrId,SQLCODE_":"_%msg)
    .s Err=-3
    .
    q:Err'=0 -3   ;删除入库单失败
    ;
    q 0
}

/// Descript:   判断是否有已经审核的入库明细
/// Creator:    wangjiabin
/// CreateDate: 2013-08-19
/// 0:没有已审核明细,  1有已审核的明细
/// w ##class(web.DHCST.DHCINGdRec).IsIngriAudited(4553)
ClassMethod IsIngriAudited(IngrId) As %Library.String
{
	n (IngrId)
	q:IngrId="" 0
	
	s flag=0
	s ch=0
	f  s ch=$o(^DHCINGR(IngrId,"GRI",ch)) q:(ch="")!(flag=1)  d
	.s inclb=$p(^(ch),"^",1)
	.q:inclb=""
	.s flag=1
	
	q flag
}

/// Descript:完成入库单
/// Creater:zhangdongmei
/// CreateDate:2012-06-29
/// Input:入库主表rowid,操作人 
/// Output:     
/// Return：0：成功;
/// -1   ;入库单id为空或入库单不存在    
/// -2   ;入库单已经完成
/// -3   ;操作失败
ClassMethod MakeComplete(IngrRowid As %String, User As %String) As %Library.String
{
    n (IngrRowid,User)
    //s ^PHATMP("MYQ", $this, "MakeComplete") = $lb(IngrRowid, User)
    q:IngrRowid="" -1
    q:'$d(^DHCINGR(IngrRowid)) -1               ;入库单id为空或入库单不存在
    q:$p(^DHCINGR(IngrRowid),"^",12)="Y" -2     ;入库单已经完成
    q:$p(^DHCINGR(IngrRowid),"^",29)="Y" -3
    q:..IsIngriAudited(IngrRowid)=1 -3
    // 检查临购药品
    s ret=##Class(PHA.IN.TmpDrugPurIngd.Save).CheckIngdIfFit(IngrRowid)
    q:ret'=0 ret

    s yes="Y"
    s Err=0
    &sql(update dhc_ingdrec set ingr_completed=:yes where ingr_rowid=:IngrRowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("MakeComplete:dhc_ingdrec",IngrRowid,SQLCODE_":"_%msg)
    .s Err=-3   ;操作失败
    .
    q Err
}

/// Descript:取消完成入库单
/// Creater:zhangdongmei
/// CreateDate:2012-06-29
/// Input:入库主表rowid,操作人 
/// Output:     
/// Return：0：成功;
/// -1   ;入库单id为空或入库单不存在    
/// -2   ;入库单尚未完成
/// -3   ;操作失败
ClassMethod CancleComplete(IngrRowid As %String, User As %String) As %Library.String
{
    n (IngrRowid,User)
    q:IngrRowid="" -1
    q:'$d(^DHCINGR(IngrRowid)) -1               ;入库单id为空或入库单不存在
    q:$p(^DHCINGR(IngrRowid),"^",12)'="Y" -2    ;入库单尚未完成
    q:$p(^DHCINGR(IngrRowid),"^",29)="Y" -3 ;入库单已审核 
    q:..IsIngriAudited(IngrRowid)=1 -3
    s Complete="N"
    s Err=0
    &sql(update dhc_ingdrec set ingr_completed=:Complete where ingr_rowid=:IngrRowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("CancleComplete:dhc_ingdrec",IngrRowid,SQLCODE_":"_%msg)
    .s Err=-3   ;操作失败
    .
    q Err
}

/// Descript:根据药品id取药品入库默认信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-29
/// Table:
/// Input:库存项id,安全组id^科室id^用户id
/// Output:     
/// Return：产地id^产地名称^入库单位id^入库单位^进价^售价^批号^效期^定价类型^招标轮次
/// LastUpdate:yunhaibao20151202,添加效期允许为空的设置,允许时默认9999-99-99
/// w ##class(web.DHCST.DHCINGdRec).GetItmInfo(112,"142^320^6423") 
ClassMethod GetItmInfo(IncId As %String, StrParam As %String) As %Library.String
{
    n (IncId,StrParam)
    s GroupId=$p(StrParam,"^",1)
    s LocId=$p(StrParam,"^",2)
    s UserId=$p(StrParam,"^",3)
    s HospId=""
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Params=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
    s ManfInfo=##class(web.DHCST.Common.DrugInfoCommon).GetConfigManf(IncId,##class(web.DHCST.DHCINGdRec).%GetParameter("AppName"),Params)
    s ManfId=$p(ManfInfo,"^",1)
    s ManfDesc=$p(ManfInfo,"^",2)
    ;
    s PurUomId=$p(^INCI(IncId,3),"^",6)
    s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
    s Rp=##class(web.DHCST.Common.PriceCommon).GetConfigRp(IncId,PurUomId,##class(web.DHCST.DHCINGdRec).%GetParameter("AppName"),Params)
    s SpProp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName"),"DefaSp",Params)
    i SpProp=1  d   ;根据定价类型计算售价
    .s Sp=##class(web.DHCST.Common.PriceCommon).GetMtSp(IncId,PurUomId,Rp)
    e  d    ;取当前售价
    .s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,PurUomId,HospId,"G","")
    s BatExp=..GetDefaultBatExp(IncId,Params)
    s BatNo=$p(BatExp,"^",1)
    s ExpDate=$p(BatExp,"^",2)
    s Spec="",Remark=""
    s Info=$o(^DHCITMINFO(0,"INCI",IncId,0))
    i Info'=""  d
    .s MtDr=$p(^DHCITMINFO(Info),"^",15)
    .s:MtDr'="" MtDesc=$p(^DHCINMT(MtDr),"^",2)
    .s MaxSp=$p(^DHCITMINFO(Info),"^",16)
    .s Spec=$p(^DHCITMINFO(Info),"^",27)
    .s Remark=$p(^DHCITMINFO(Info),"^",10)
    .s origin=$p(^DHCITMINFO(Info),"^",100)
    .s originDesc=""
    .s:origin'="" originDesc=$P(^DHCSTORI(origin),"^",2)
    s:Remark["undefined" Remark=""
    s PbLDr=$p(^DHCITMINFO(Info),"^",23) 
    i PbLDr'="" s PbDesc=$p($g(^DHCPBLIST(PbLDr)),"^",2)  //招标名称
    e  s PbDesc=""
    s BUomId=$p(^INCI(IncId,1),"^",10)
    s PurUomId=$p(^INCI(IncId,3),"^",6)
    s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
	s NeedExpDate=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName"),"NoNeedExpDate",Params)
    i NeedExpDate'="" d
    .s StkGrpStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
    .s StkGrpCode=$p(StkGrpStr,"^",1)
    .i $lf($lfs(NeedExpDate),StkGrpCode)>0 s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($ZDH("9999-12-31",3))
    s pbVendorInfo=##class(web.DHCST.Common.DrugInfoCommon).GetPbVendor(IncId)
    s pbVendor=$p(pbVendorInfo,"^",1)
    s pbVenorDesc=$p(pbVendorInfo,"^",2)
    s arcimDr=##class(web.DHCST.Common.DrugInfoCommon).GetArcim(IncId)
    s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(arcimDr)
    s PoisonFlag = ##Class(web.DHCST.Common.DrugInfoCommon).CheckPoisonForVendor(IncId)
    s InsuCode = ##class(PHA.COM.Drug).GetInsuCode(IncId, HospId)
    s InsuDesc = ##class(PHA.COM.Drug).GetInsuDesc(IncId, HospId)
    s setInvDays = ##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName"),"SetInvDate",Params)
    if (setInvDays '= "")  d
    .s invDate = +$H + setInvDays
    .s invDate = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(invDate)
    else  s invDate = ""
    s Data1 = ManfId_"^"_ManfDesc_"^"_PurUomId_"^"_$g(PurUomDesc)_"^"_Rp_"^"_Sp  // 6
    s Data2 = BatNo_"^"_ExpDate_"^"_$g(MtDesc)_"^"_PbDesc_"^"_BUomId_"^"_ConFac_"^"_$g(MtDr)_"^"_$g(MaxSp) //14
    S Data3 = Spec_"^"_$G(Remark)_"^"_IncId_"^"_pbVendor_"^"_pbVenorDesc_"^"_freeDrugFlag_"^"_origin  // 21
    s Data4 = originDesc _"^"_ PoisonFlag_"^"_InsuCode_"^"_InsuDesc _"^"_ invDate //26
    s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
	q ##class(web.DHCST.Common.JsonObj).GetData(Data)
}

/// Descript:根据批号效期，供应商取INC_ItmBat表rowid
/// Creater:    wyx
/// CreateDate: 2014-04-15
/// Table:
/// Input:inci,批号,效期,厂商，默认进价取法，默认售价取法
/// Output:     
/// Return：批号^效期
/// 
ClassMethod GetIncibData(IncId, BatNo, ExpDate, ManfId)
{
   n (IncId,BatNo,ExpDate,ManfId,RpProp,SpProp)
   s ExpDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(ExpDate)
   s ChildSub=""
   s ret=""
   f  s ChildSub=$o(^INCI("IB_NoX",ExpDate,BatNo,IncId,ChildSub)) q:(ChildSub="")||(ret'="")  d
   .s incib=IncId_"||"_ChildSub
   .s dhcincib=""
   .f  s dhcincib=$o(^DHCINCIB(0,"PHMNF",incib,ManfId,dhcincib),-1) q:(dhcincib="")||(ret'="")  d
   ..s ret=incib
   ..
  q ret
}

/// Descript:取某药品最后一次入库的批号和效期
/// Creater:    ZhangDongmei
/// CreateDate: 2012-09-19
/// Table:
/// Input:库存项id
/// Output:     
/// Return：批号^效期
/// 
ClassMethod GetDefaultBatExp(IncId As %String, Params As %String) As %Library.String
{
    n (IncId,Params)
    s BatNo=""
    s ExpDate=""
    s BatnoProp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName"),"DefaBatNo",Params)
    s LastBatExp=..GetLastIngrBatExp(IncId)
    i BatnoProp=1  d     ;取上次入库批号
    .s BatNo=$p(LastBatExp,"^",1)
    e  i BatnoProp=2  d     ;自动生成批号
    .s BatNo=..CreateBatNo(IncId)
    .
    s ExpProp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName"),"DefaExpDate",Params)
    i ExpProp=1  d     ;取上次入库效期
    .s ExpDate=$p(LastBatExp,"^",2)
    e  i ExpProp=2  d     ;自动生成效期
    .s ExpDate=..CreateExpDate()
    . 
    q BatNo_"^"_ExpDate
}

/// Descript:自动生成药品入库批号
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-29
/// Table:
/// Input:库存项id
/// Output:     
/// Return：批号
/// 
ClassMethod CreateBatNo(IncId As %String) As %Library.String
{
    n (IncId)
    s PostFix="01"
    i IncId'=""  d
    .s InciCode=$p(^INCI(IncId,1),"^",1)
    .s PostFix=$e(InciCode,$l(InciCode)-1,$l(InciCode))
    s TmpBatNo=$zd(+$h,8)
    s BatNo=TmpBatNo_PostFix
    q BatNo
}

/// Descript:取某药品最后一次入库的批号和效期
/// Creater:    ZhangDongmei
/// CreateDate: 2012-09-19
/// Table:
/// Input:库存项id
/// Output:     
/// Return：批号^效期
/// 
ClassMethod GetLastIngrBatExp(Inci As %String) As %Library.String
{
    n (Inci)
    s Ingr=$o(^DHCINGR(0,"INCI",Inci,""),-1)
    q:Ingr="" ""
    s Chl=$o(^DHCINGR(0,"INCI",Inci,Ingr,""),-1)
    q:Chl="" ""
    s BatNo=$p(^DHCINGR(Ingr,"GRI",Chl),"^",13)
    s ExpDate=$p(^DHCINGR(Ingr,"GRI",Chl),"^",9)
    s:ExpDate'="" ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
    ;
    q BatNo_"^"_ExpDate
}

/// Descript:自动生成药品效期
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-29
/// Table:
/// Input:
/// Output:     
/// Return：效期
/// w ##class(web.DHCST.DHCINGdRec).CreateExpDate()
ClassMethod CreateExpDate() As %Library.String
{
    
    s ExpDateValue=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName"),"ExpDateValue")
    s Days=+ExpDateValue*365
    s ExpDate=+$h+Days
    s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate,"ST")
    q ExpDate
}

/// Descript:   审核入库单
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-03
/// Table:DHC_InGdRec,DHC_InGdRecItm,INC_ItmBat,INC_ItmLcBt,INC_ItmLoc
/// DHC_LocDailyTotal,DHC_LcBtDailyTotal
/// Input:入库主表id^审核人        
/// Output:     
/// Return：成功：0；
///  -101   ;入库单不存在
///  -100   ;加锁失败
///  -102   ;入库单尚未完成，不能审核
///  -104  ;更新入库主表失败
///  -110   ;药品和科室不能为空
/// -111   ;生成批次信息失败
/// -112   ;保存批次附加信息失败
/// -113   ;处理库存失败
/// -114   ;保存台帐失败
/// -115  ;更新入库明细失败 
/// w ##class(web.DHCST.DHCINGdRec).Audit("306","13609","142^395")
ClassMethod Audit(DhcIngr, Usr, StrParam = "") As %Library.String
{
	//s ^YSJTMP("Audit")=$LB(DhcIngr, Usr, StrParam)
    n (DhcIngr,Usr,StrParam)
    s HospId=""
    s gGroupId=$p(StrParam,"^",1)
    s gLocId=$p(StrParam,"^",2)
    i gLocId'="" s HospId=$p($g(^CTLOC(gLocId)),"^",22)
    s resultString=0
    i DhcIngr="" q -101
    q:DhcIngr="" resultString                   ;入库单不存在
    q:'$d(^DHCINGR(DhcIngr)) -101       ;入库单不存在
    s CheckInfo = ..CheckDetailInfo(DhcIngr)
    q:CheckInfo'="" CheckInfo
    ;
    s ret=##class(web.DHCST.Common.AppCommon).Lock("LOCKREC"_DhcIngr)  
    q:ret'=0 -100  ;加锁失败
    s complete=$p(^DHCINGR(DhcIngr),"^",12)
    i complete'="Y" d ##class(web.DHCST.Common.AppCommon).UnLock("LOCKREC"_DhcIngr)
    q:complete'="Y" -102                ;入库单尚未完成，不能审核
    s AuditFlag=$p(^DHCINGR(DhcIngr),"^",29)
    i AuditFlag="Y" d ##class(web.DHCST.Common.AppCommon).UnLock("LOCKREC"_DhcIngr)
    q:AuditFlag="Y" 0       ;已经审核
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理   
    s AspFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName"),"AllowAspWhileReceive")  
    s configret=##class(web.DHCST.Common.AppCommon).GetParamCommon(gGroupId,gLocId,Usr) //取公共进价规则标志 wyx 2014-04-15
    s RpRule=$p(configret,"^",8)
    s ret=0
    //临购药品判断是否有已经维护禁止管控级别的药品 2021-03-15 yangsj
    i ##class(%Dictionary.ClassDefinition).%ExistsId("PHA.IN.TmpDrugPurAuth.Save") d
    .s iIfDULAllow =##Class(PHA.IN.TmpDrugPurIngd.Save).CheckIngdiIfDULAllow(DhcIngr)
    .i iIfDULAllow="Y" s ret=-202
    q:ret'=0 ret ;临购药品授权使用限制用药时，如果有禁止的管控级别，则不能再维护允许
    
    s CH=0
    s Err=0
    f  s CH=$o(^DHCINGR(DhcIngr,"GRI",CH)) q:CH=""  d
    . s INCLB=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",1) 
    . q:INCLB'=""                          
    . q:$d(^DHCINTR(0,"TypePointer","G",DhcIngr_"||"_CH))
    . s DHCINGRI=DhcIngr_"||"_CH
    . s ingdrecUom=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",10) 
    . s ingdrecInci=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",25) 
    . s ingdrecQty=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",4) 
    . i RpRule'="3" d  //非批次价模式,审核时更新售价以及金额为最新不产生售价损益,yunhaibao,20151211
    . .s cursp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(ingdrecInci,+$h,ingdrecUom,HospId,..sssCode(),"")
    . .s curspamt=cursp*ingdrecQty
    . .s curspamt=##class(web.DHCST.Common.AppCommon).FormatSpAmt(curspamt,HospId)
    . .s $p(^DHCINGR(DhcIngr,"GRI",CH),"^",32)=cursp	//saleprice
    . .s $p(^DHCINGR(DhcIngr,"GRI",CH),"^",45)=cursp	//newsp
    . .s $p(^DHCINGR(DhcIngr,"GRI",CH),"^",46)=curspamt	//newspamt
    . .s $p(^DHCINGR(DhcIngr,"GRI",CH),"^",50)=curspamt //spamt
    . tstart
    . //更新发票记录 2021-05-19 yangsj
    . s ret = ##Class(PHA.IN.InvNoManage.Save).SaveINGD(DHCINGRI,"G")
    . i ret'=0  s Err=ret  d  trollback
    . q:ret'=0
    . ;处理库存及台帐相关
    . ;b ;1
    . s ret=..HandleStock(DHCINGRI,Usr)
    . ;b ;ret
    . i ret'=0 s Err=-99  d  trollback    ;回滚事务
    . q:ret'=0
    .i RpRule="3" d //批次价格
    ..s ret=..HandleAspBatch(DHCINGRI,Usr,StrParam)
    .e  d
    ..i AspFlag="Y" d
    ...s ret=..HandleAsp(DHCINGRI,Usr)   ;处理调价
    ..e  d
    ...s ret=..CreateImpAspA(DHCINGRI,Usr,RpRule)    ;生成入库损益
    . 
    . ;b ;ret2
    . i ret'=0  s Err=ret  d  trollback
    . q:ret'=0
    . tcommit
    . 
    ;b ;err
    
    i Err'=0 d ##class(web.DHCST.Common.AppCommon).UnLock("LOCKREC"_DhcIngr)
    q:Err'=0 Err ;部分明细审核失败，请重新审核
    ;更新主表
    s ret=..UpdateDHCINGdRec(DhcIngr,Usr)
    d ##class(web.DHCST.Common.AppCommon).UnLock("LOCKREC"_DhcIngr)   
    q:ret'=0 -104  ;更新入库主表失败
    i ##class(%Dictionary.ClassDefinition).%ExistsId("PHA.IN.TmpDrugPurAuth.Save") d
    .s ret=##Class(PHA.IN.TmpDrugPurIngd.Save).UpdateTDPSAfterIngdAudit(DhcIngr)
    q:ret'=0 -201 ;更新临购申请单状态失败 2021-01-13 yangsj

    q 0
}

/// Description: 完成后自动审核
/// Author: zhaoxinlong 2022.03.23
/// Input: 
/// Return: 0 -- 成功
ClassMethod CompAutoAudit(ingr As %String, user As %String, strParam As %String = "") As %String
{
	n (ingr, user, strParam)
	q:(ingr = "") -1 
	s hospId=""
    s groupId=$p(strParam, "^", 1)
    s locId=$p(strParam, "^", 2)
    i locId'="" s hospId=$p($g(^CTLOC(locId)), "^", 22)
    s params = groupId _"^"_ locId _"^"_ user _"^"_ hospId
	s appName = ##class(web.DHCST.DHCINGdRec).%GetParameter("AppName")
	s autoAuditFlag = ##class(web.DHCST.Common.AppCommon).GetAppPropValue(appName, "AutoAudit", params)
	ts 
	s ret = ..MakeComplete(ingr, user)
	if (ret '= 0) {
		tro  
		q "C."_ret
	}
	if (autoAuditFlag = "Y") {
		s ret = ..Audit(ingr, user, strParam) 
	}
	if (ret '= 0) {
		tro  
		q ret
	}
	tc
	q 0
}

/// Creator:zhangdongmei
/// CreatDate:2012-09-20
/// Description:处理入库时自动调价
/// Input:入库子表id
/// Table:
/// OutPut:
/// Return:0:成功;
/// -1  ;售价与当前价不一致，但是不允许自动调价
/// -2   ;保存调价记录失败
/// -4  ;审核调价记录失败
ClassMethod HandleAsp(ingri, UserId) As %String
{
    n (ingri,UserId)
    q:ingri="" 0
    s DhcIngr=+ingri
    s CH=$p(ingri,"||",2)
    ;
    s Sp=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",32) 
    s Rp=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",30)
    s Uom=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",10)      ;uom 
    s LocId=$p(^DHCINGR(DhcIngr),"^",13)
    s HospId=$p(^CTLOC(LocId),"^",22)
    s Inclb=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",1) 
    s Inci=+Inclb
    s CurSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,+$h,Uom,HospId,"G","")
    s inciID=$p(Inclb,"||",1)
    s dateh=+$h
    s CurRp=##class(web.DHCSTPRICE).GetRp(Inclb,+$h,Uom,HospId,"") //zhouyg 20141203
    q:(Rp=CurRp)&(Sp=CurSp) 0  ;不需要调价
    //s AspFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName"),"AllowAspWhileReceive")
    //q:AspFlag'="Y" -1  ;售价与当前价不一致，但是不允许自动调价
    s AdjNo=""
    s AspId=""
    s GrpInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
    s GrpId=$p(GrpInfo,"^",5)
    s PreExeDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h+1)   ;第二天生效
    s AspReasonId=""
    s PrcFile=""
    s PrcFileDate=""
    s Remark=""
    s InvNo=""
    s InvDate=""
    s Data1=AspId_"^"_PreExeDate_"^"_Inci_"^"_Uom_"^"_Sp_"^"_Rp_"^"_UserId_"^"_AspReasonId
    s Data2=HospId_"^"_PrcFile_"^"_PrcFileDate_"^"_Remark_"^"_InvNo_"^"_InvDate_"^"_CurRp_"^"_CurSp
    s ListData=Data1_"^"_Data2
    s TodayFlag=##class(web.DHCST.INAdjSalePrice).CheckItmAspToday(Inci,HospId)
    q:TodayFlag=1 -5 ;已存在当天调价生效记录  LiangQiang　20140122
    s AdjNo=##class(web.DHCST.INAdjSalePrice).Save(AdjNo,GrpId,LocId,ListData)
    q:+AdjNo<0 -2   ;保存调价记录失败
    s AspId=$o(^INASP(0,"ASPNO",$$ALPHAUP^SSUTIL4(AdjNo),0))
    q:AspId="" -3   ;保存调价记录失败
    s Ret=##class(web.DHCST.INAdjSalePrice).Audit(AspId,UserId)
    q:Ret'=0 -4  ;审核调价记录失败
    q 0
}

/// Creator:zdm
/// CreatDate:2009-09-07
/// Description:处理inc_itmloc,inc_itmlcbt,
/// dhc_locdailytotal,dhc_locbtdailytotal库存记录
/// Input:入库子表（DHC_InGdRecItm）rowid 
/// Table:inc_itmloc,inc_itmlcbt,dhc_locdailytotal,
/// dhc_locbtdailytotal
/// OutPut:
/// Return:0,成功；
/// -110   ;药品和科室不能为空
/// -111   ;生成批次信息失败
/// -112   ;保存批次附加信息失败
/// -113   ;处理库存失败
/// -114   ;保存台帐失败
/// -115  ;更新入库明细失败 
ClassMethod HandleStock(Dhcingri, auditUser) As %Library.String
{
    
    n (Dhcingri,auditUser)
    s Dhcingr=+Dhcingri
    s Ch=$p(Dhcingri,"||",2)
    s Ret=0      
    s Inci=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",25)  ; rowid of inc_itm
    //s Loc=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",3)   ; receive location
    s Loc=$p(^DHCINGR(Dhcingr),"^",13) //改为取主表入库科室
    s Uom=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",10)      ;uom 
    s Qty=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",4)              ;qty
    s Expdate=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",9)    ; exp date
    s Bat=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",13)     ; batch no
    s Mnf=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",29)      ;manufacturer 
    s RealPrice=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",30)   ; real price
    s IngrNo=$p(^DHCINGR(Dhcingr),"^",1)
    s Sp=$P(^DHCINGR(Dhcingr,"GRI",Ch),"^",32)
    s RpAmt=$P(^DHCINGR(Dhcingr,"GRI",Ch),"^",31)
    s SpAmt=$P(^DHCINGR(Dhcingr,"GRI",Ch),"^",50)
    ;
    q:Inci="" -110   ;药品和科室不能为空
    q:Loc="" -110 
    s LocHosp=$P(^CTLOC(Loc),"^",22)
    q:'$d(^INCI(Inci,1)) -110
    s Buom=$p(^INCI(Inci,1),"^",10)
    s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(Uom,Buom)
    s BQty=Qty*Fac 
    ; 
    s vendor=$p(^DHCINGR(Dhcingr),"^",3)
    ;生成批次信息
    s Incib=..GetBatNo(Inci,Bat,Expdate,RealPrice,Uom,Mnf,vendor,Sp,LocHosp)
    ;
    q:Incib="" -111  ;生成批次信息失败
    s Ret=..InsertDhcItmBat(Incib,Dhcingri)
    q:Ret'=0 -112    ;保存批次附加信息失败                        
    ;处理库存记录
    s Inclb=""
    s Ret=##class(web.DHCST.Common.StockHandle).UpdateStockForImp(Inci,Loc,Incib,BQty)
    i +Ret'>0 d
    .s ret=$$ErrorRecord^DHCSTERROR("HandleStock:UpdateStockForImp","pointer:"_Ret,Ret_":"_Ret)
    .
    i +Ret>0  d
    .s Inclb=Ret
    q:Inclb="" -113  ;处理库存失败
    ;
    ;处理台帐记录
    s ListData="G"_"^"_IngrNo_"^"_Inclb_"^"_Qty_"^"_Uom_"^"_Sp_"^"_auditUser_"^"_Dhcingri_"^"_RealPrice_"^"_RpAmt_"^"_SpAmt
    s Ret=##class(web.DHCST.Common.StockHandle).IntoTrans(ListData)
    i +Ret>0 d
    .s TrId=Ret
    .s Ret=0
    q:Ret'=0 -114  ;保存台帐失败
    ;
    ;更新入库明细批次信息
    s Ret=##class(web.DHCST.DHCINGdRecItm).UpdateDhcRecItm(Dhcingri,Inclb)      
    q:Ret'=0 -115  ;更新入库明细失败
    ;
    q 0
}

/// Creator:zhwh
/// CreatDate:2011-08-04
/// Description:检查inc_itmbat中是否存在空批号、空效期、进价相同的记录
/// Input:库存项rowid，批号，效期，进价，单位,厂家
/// Table:inc_itmbat,dhc_incitmbat
/// OutPut:
/// Return:inc_itmbat的rowid(存在);""(不存在)
ClassMethod CheckNullIncibExist(inci, batno, expdate, rp, uom, mnf, vendor = "", sp) As %String
{
     n (inci,batno,expdate,rp,uom,mnf,vendor,sp)
     q:inci="" ""
     //q:batno="" ""
     //q:expdate="" ""
     s uomflag=..CheckInciUom(inci,uom)
     s incib=""
     ;
     &sql(declare seekBat cursor for  select incib_rowid  From inc_itmbat 
       where incib_inci_parref=:inci and nvl(incib_no,"")=:batno)
      //  and nvl(incib_expdate,"")=:expdate )	//zhouyg 20141118 nvl对有效期不起作用,改到循环内
     &sql(open seekBat)
     s ret=""  
     f  &sql(fetch seekBat into :incib)  q:SQLCODE!(ret'="")  d
     .s ibSub=$p(incib,"||",2)
     .s ibExp=$p(^INCI(inci,"IB",ibSub),"^",2)
     .q:ibExp'=expdate
     .s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
     .q:dhcincib=""
     .s tmprp=0
     .s tmpsp=0
     .i uomflag=1 d
     ..s tmprp=+$P(^DHCINCIB(dhcincib),"^",4)
     ..s tmpsp=+$P(^DHCINCIB(dhcincib),"^",6)
     .e  d
     ..s tmprp=+$P(^DHCINCIB(dhcincib),"^",3)
     ..s tmpsp=+$P(^DHCINCIB(dhcincib),"^",5)
     .//厂家
     .s tmpmnf=$p(^DHCINCIB(dhcincib),"^",7)
     .s tmpvendor=$p(^DHCINCIB(dhcincib),"^",8)
     .i (tmprp=rp)&(tmpmnf=mnf)&(tmpvendor=vendor)&(tmpsp=sp) d
     ..s ret=incib              ;存在相同记录
     .
     &sql(close seekBat)
     q ret
}

/// Creator:zdm
/// CreatDate:2012-07-04
/// Description:生成批次信息
/// Input:库存项rowid，批号，效期，进价，单位,生产厂家ID
/// Table:inc_itmbat,dhc_incitmbat
/// OutPut:
/// Return:inc_itmbat的rowid
ClassMethod GetBatNo(inci, bat, exp, rp, uom, mnf, vendor = "", sp, Hosp = "") As %Library.String
{
    n (inci,bat,exp,rp,uom,mnf,vendor,sp,Hosp)
    q:inci="" ""
    q:rp="" ""
    q:uom="" ""
    s incib=""
    //判断是否按照入库记录生成批次 2020-06-17 yangsj
    s BatRelaIngdFlag=##class(web.DHCSTCOMMPARA).GetCommPropValue("BatRelaIngd","^^^^"_Hosp_"^DHC")
    i BatRelaIngdFlag'="Y" d
    .i exp'="" s exp=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(exp)
    .i (bat="")!(exp="")  d
    ..s incib=..CheckNullIncibExist(inci,bat,exp,rp,uom,mnf,vendor,sp)
    .e  d
    ..s incib=..CheckIncibExist(inci,bat,exp,rp,uom,mnf,vendor,sp)
    
    
    q:incib'="" incib       ;返回已有的批次记录rowid
    //s chl=+$o(^INCI(inci,"IB",""),-1)+1
    s Err=0
    &sql(insert into inc_itmbat(INCIB_INCI_ParRef,INCIB_No,INCIB_ExpDate) values (:inci,:bat,:exp))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("GetBatNo:inc_itmbat","inci:"_inci,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 ""
    s incib=$p($g(%ROWID),$c(1))
    q incib
}

/// Creator:zdm
/// CreatDate:2009-09-07
/// Description:检查inc_itmbat中是否存在批号、效期、进价相同的记录
/// Input:库存项rowid，批号，效期，进价，单位,厂家id
/// Table:inc_itmbat,dhc_incitmbat
/// OutPut:
/// Return:inc_itmbat的rowid(存在);""(不存在)
ClassMethod CheckIncibExist(inci, batno, expdate, rp, uom, mnf, vendor = "", sp) As %Library.String
{
    
    n (inci,batno,expdate,rp,uom,mnf,vendor,sp)
    q:inci="" ""
    q:batno="" ""
    q:expdate="" ""
    s uomflag=..CheckInciUom(inci,uom)
    s ret=""
    s sub=0
    f  s sub=$o(^INCI("IB_NoX",expdate,batno,inci,sub))  q:(sub="")!(ret'="")  d
    .s incib=inci_"||"_sub
    .s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
    .q:dhcincib=""
    .s tmprp=0
    .s tmpsp=0
    .//进价
    .i uomflag=1  d
    ..s tmprp=+$p(^DHCINCIB(dhcincib),"^",4)     ;包装单位对应的进价
    ..s tmpsp=+$P(^DHCINCIB(dhcincib),"^",6)
    .e  i uomflag=0  d
    ..s tmprp=+$p(^DHCINCIB(dhcincib),"^",3)     ;基本单位对应的进价
    ..s tmpsp=+$P(^DHCINCIB(dhcincib),"^",5)
    .//厂家
    .s tmpvendor=$p(^DHCINCIB(dhcincib),"^",8)
    .s tmpmnf=$p(^DHCINCIB(dhcincib),"^",7)
    .i (tmprp=rp)&(tmpmnf=mnf)&(tmpvendor=vendor)&(tmpsp=sp) d
    ..s ret=incib               ;存在相同记录
    .q:ret'=""
    q ret
}

/// Creator:zdm
/// CreatDate:2009-09-07
/// Description:检查该库存项的单位是包装单位还是基本单位
/// Input:库存项rowid，单位rowid
/// Table:inc_itm
/// OutPut:
/// Return:1,包装单位;0,基本单位
ClassMethod CheckInciUom(inci, uom) As %Library.String
{
    
    n (inci,uom)
    s ret=""
    q:inci="" ""
    s buom=$p(^INCI(inci,1),"^",10)
    s puruom=$p(^INCI(inci,3),"^",6)
    i uom=buom  d
    .s ret=0
    e  i uom=puruom  d
    .s ret=1
    q ret
}

/// Creator:zdm
/// CreatDate:2009-09-08
/// Description:插入dhc_incitmbat
/// Input:inc_itmbat表rowid,入库子表id
/// Table:dhc_incitmbat
/// OutPut:
/// Return:0,成功；其它，失败
ClassMethod InsertDhcItmBat(Incib As %String, Dhcingri As %String) As %Library.String
{

    n (Incib,Dhcingri)
    q:Incib="" -1    ;批次id不能为空
    s Ch=$p(Dhcingri,"||",2)
    s Dhcingr=+Dhcingri
    q:Dhcingr=0 -1
    q:Ch="" -1
    s DhcIncib=$o(^DHCINCIB(0,"INCIB",Incib,0))
    q:DhcIncib'="" 0                        ;不需要插入
    s BuomDr=$p(^INCI(+Incib,1),"^",10)
    s PuruomDr=$p(^INCI(+Incib,3),"^",6)
    s Fac=##class(web.DHCST.Common.UtilCommon).UOMFac(PuruomDr,BuomDr)
    s Uom=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",10)      ;uom 
    s ProduceDate=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",49)              ;qty
    s Mnf=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",29)      ;manufacturer 
    s Rp=$p(^DHCINGR(Dhcingr,"GRI",Ch),"^",30)   ; real price
    s Sp=$P(^DHCINGR(Dhcingr,"GRI",Ch),"^",32)
    s Vendor=$p(^DHCINGR(Dhcingr),"^",3)
    i Uom=BuomDr  d
    .s BRp=Rp
    .s PurRp=Rp*Fac
    .s BSp=Sp
    .s PurSp=Sp*Fac
    e  d
    .s BRp=Rp/Fac
    .s PurRp=Rp
    .s BSp=Sp/Fac
    .s PurSp=Sp
    .
    s Date=+$h
    s Time=$p($h,",",2)
    ;
    s Err=0
    &sql(insert into dhc_incitmbat(INCIB_INCIB_Dr,INCIB_ProduceDate,INCIB_Rp,INCIB_RpPuruom,INCIB_Sp,
    INCIB_SpPuruom,INCIB_PHMNF_Dr,INCIB_APCVM_Dr,INCIB_INGRI_Dr,INCIB_DateAdd,INCIB_TimeAdd) 
    values (:Incib,:ProduceDate,:BRp,:PurRp,:BSp,:PurSp,:Mnf,:Vendor,:Dhcingri,:Date,:Time))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("InsertDhcItmBat:dhc_incitmbat","incib:"_Incib,SQLCODE_":"_%msg)
    .s Err=-11  ;保存失败
    q Err
}

/// Creator:zdm
/// CreatDate:2009-06-02
/// Description:更新入库主表的审核相关字段
/// Table:DHC_InGdrec
/// Input:入库主表rowid
/// Return：0，成功；其它,不成功
ClassMethod UpdateDHCINGdRec(dhcingr, user) As %Library.String
{
    
    n (dhcingr,user)
    q:dhcingr="" -1
    s dd=+$h
    s tt=$p($h,",",2)
    s AuditFlag="Y"
    s Err=0
    &sql(select sum(initm_invmoney) into :invtotalamt from dhc_ingdrecitm where ingri_ingr_parref=:dhcingr)
    s invtotalamt=$g(invtotalamt)
    &sql(update dhc_ingdrec
        set ingr_Date=:dd,
            ingr_time=:tt,
            ingr_ssusr_dr=:user,
            ingr_backup1=:invtotalamt,INGR_AuditFlag=:AuditFlag where ingr_rowid=:dhcingr)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("UpdateDHCINGdRec:dhc_ingdrec","dhcingr:"_dhcingr,SQLCODE_":"_%msg)
    .s Err=-3  ;更新失败
    q Err
}

/// Descript:   保存入库验收信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-07-18
/// Table:DHC_InGdRec,DHC_InGdRecItm
/// Input:入库主表id;验收人id;明细id^检测口岸^检测报告^报告日期^注册证号^注册证有效期^摘要,
/// 明细id^检测口岸^检测报告^报告日期^注册证号^注册证有效期^摘要,
/// Output:     
/// Return：成功：0；
/// -5:保存入库单验收信息失败
/// -7其它：部分明细保存不成功，提示不成功的药品
/// 
ClassMethod SaveAcceptInfo(IngrId As %String, UserId As %String, ListData As %String) As %Library.String
{
    n (IngrId,UserId,ListData)
    q:IngrId="" -1
    ;
    s $p(^DHCINGR(IngrId),"^",26)=UserId
    s Ret=##class(web.DHCST.DHCINGdRecItm).SaveAcceptInfo(ListData)
    q:+Ret'=0 Ret   ;存在保存失败的明细
    q 0
}

/// Descript:取入库界面参数配置属性
/// Creater:    ZhangDongmei
/// CreateDate: 2012-09-19
/// Table:
/// Input:安全组id,科室id,用户id
/// Output:     
/// Return：默认批价等于进价^检测发票号^效期提示天数^保存后自动打印^审核后自动打印
/// ^加成率超限提示^允许录入进价金额^采购员不能为空^入库类型不能为空^验证最高售价
/// ^默认查找起始日期^默认查找截止日期^鼠标放药品名称列自动显示历史入库批次列表^打印方式参数
/// ^入库是否允许调价^默认售价方式^验证供应商中标^验证供应商资质
ClassMethod GetParamProp(GroupId As %String, LocId As %String, UserId As %String) As %Library.String
{
    n (GroupId,LocId,UserId)
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s Param=GroupId_"^"_LocId_"^"_UserId_"^"_$g(HospId)
    s AppName=##class(web.DHCST.DHCINGdRec).%GetParameter("AppName")
    s DefaPurPrice=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaPurPrice",Param)
    s CheckInvNo=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"CheckInvNo",Param)
    s ChkExpDateDays=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ChkExpDateDays",Param)
    s AutoPrintAfterSave=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"AutoPrintAfterSave",Param)
    s AutoPrintAfterAudit=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"AutoPrintAfterAudit",Param)
    s MarginWarning=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"MarginWarning",Param)
    s AllowInputRpAmt=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"AllowInputRpAmt",Param)
    s PurchaserNotNull=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"PurchaserNotNull",Param)
    s ImpTypeNotNull=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ImpTypeNotNull",Param)
    s ValidateMaxSp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ValidateMaxSp",Param)
    s DefaStartDate=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaStartDate",Param)
    s DefaEndDate=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaEndDate",Param)
    s ShowInciRecList=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ShowInciRecList",Param)
    s PrintType=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"PrintType",Param)
    s AllowAspWhileReceive=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"AllowAspWhileReceive",Param)
	s DefaSp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"DefaSp",Param)
	s ValVendorPb=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ValVendorPb",Param)
	s ValVendorQualification=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"ValVendorQualification",Param)
	s RpCompareSp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RpCompareSp",Param)
	i RpCompareSp="" s RpCompareSp=1
	s StockAllowDecimal=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"StockAllowDecimal",Param)
    s Data1=DefaPurPrice_"^"_CheckInvNo_"^"_ChkExpDateDays_"^"_AutoPrintAfterSave_"^"_AutoPrintAfterAudit  	// 5
    s Data2=MarginWarning_"^"_AllowInputRpAmt_"^"_PurchaserNotNull_"^"_ImpTypeNotNull_"^"_ValidateMaxSp  	// 10
    s Data3=DefaStartDate_"^"_DefaEndDate_"^"_ShowInciRecList_"^"_PrintType_"^"_AllowAspWhileReceive		// 15
    s Data4=DefaSp_"^"_ValVendorPb_"^"_ValVendorQualification_"^"_RpCompareSp_"^"_StockAllowDecimal			// 20
    q Data1_"^"_Data2_"^"_Data3_"^"_Data4
}

/// b根据维护取库存项进价
ClassMethod GetRPrice(InciId As %String, UomId As %String, StrParam As %String, StkGrpType As %String) As %String
{
	n (InciId,UomId,StrParam,StkGrpType)
	
	s GroupId=$p(StrParam,"^",1)
    s LocId=$p(StrParam,"^",2)
    s UserId=$p(StrParam,"^",3)
    s HospId=""
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
	s Params=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
	s Rp=##class(web.DHCST.Common.PriceCommon).GetConfigRp(InciId,UomId,##class(web.DHCST.DHCINGdRec).%GetParameter("AppName"),Params)
	//s Sp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciId,+$H,UomId,HospId,StkGrpType)
	s Sp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciId,+$H,UomId,HospId,StkGrpType,"")
	q Rp_"^"_Sp
}

/// w ##class(web.DHCST.DHCINGdRec).CreateAdjPrice(1)
ClassMethod CreateAdjPrice(StrParam As %String) As %String
{
	n (StrParam)
	s resultString=0
	s GrpId=$p(StrParam,"^",8)
	s LocId=$p(StrParam,"^",9)
	;生成单号需加锁
    ;s ret=##class(web.DHCST.Common.AppCommon).Lock("ADJNO")  
    ;q:ret'=0 -99  ;加锁失败
    s AppName=##class(web.DHCST.DHCINGdRec).%GetParameter("AppName")
	s AdjNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,GrpId,LocId)
	;i AdjNo="" d ##class(web.DHCST.Common.AppCommon).UnLock("ADJNO")
    s:AdjNo="" resultString=-2   ;生成单号失败
	s:+AdjNo<0 resultString=-3  
	s preexedate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h,"ST")
	s ItmRowid=$p(StrParam,"^",1)
	s AdjUomId=$p(StrParam,"^",2)
	s ResultSp=$p(StrParam,"^",3)
	s ResultRp=$p(StrParam,"^",4)
	s AdjUserId=$p(StrParam,"^",5)
	s PriorRp=$p(StrParam,"^",6)
	s PriorSp=$p(StrParam,"^",7)
	s AdjReasonId=""
	//s HospId="" //入库时设置成入库调价，但是在生成调价的时候记录不存入医院id，导致取药品价格取不到该记录。
	s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(LocId)
    s HospId=$p(CustStr,"^",5)
	s data=preexedate_"^"_ItmRowid_"^"_AdjUomId_"^"_ResultSp_"^"_ResultRp_"^"_AdjUserId_"^"_AdjReasonId_"^"_HospId_"^^^^^^"_PriorRp_"^"_PriorSp
	
	tstart
	s AspId=##class(web.DHCST.INAdjSalePrice).Insert(AdjNo,data,"Y")  //增加入库标志 "Y" 入参 ，方法中不判断计划生效日期
	i AspId<=0 s resultString=-4
	i AspId<=0  trollback  ;d ##class(web.DHCST.Common.AppCommon).UnLock("ADJNO")
	q:AspId<=0 resultString
	s ret=##class(web.DHCST.INAdjSalePrice).Audit(AspId,AdjUserId)
	i ret<0 s resultString=-5
	i ret<0  trollback  ;d ##class(web.DHCST.Common.AppCommon).UnLock("ADJNO")
	tcommit
	;d ##class(web.DHCST.Common.AppCommon).UnLock("ADJNO")
	q resultString
}

/// modify wyx 2014-04-14 保存批次调价记录(入库使用)
ClassMethod CreateAdjPriceBatch(StrParam As %String) As %String
{
	n (StrParam)
	s resultString=0
	s GrpId=$p(StrParam,"^",8)
	s LocId=$p(StrParam,"^",9)
	;生成单号需加锁
    ;s ret=##class(web.DHCST.Common.AppCommon).Lock("ADJNO")  
    ;q:ret'=0 -99  ;加锁失败
    s AppName=##class(web.DHCST.INAdjPriceBatch).%GetParameter("AppName")
	s AdjBatNo=##class(web.DHCST.Common.AppCommon).GetAppNo(AppName,GrpId,LocId)
	;i AdjNo="" d ##class(web.DHCST.Common.AppCommon).UnLock("ADJNO")
    s:AdjBatNo="" resultString=-12   ;生成单号失败
	s:+AdjBatNo<0 resultString=-13 
	s preexedate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(+$h,"ST")
	s ItmRowid=$p(StrParam,"^",1)
	s AdjUomId=$p(StrParam,"^",2)
	s ResultSp=$p(StrParam,"^",3)
	s ResultRp=$p(StrParam,"^",4)
	s AdjUserId=$p(StrParam,"^",5)
	s PriorRp=$p(StrParam,"^",6)
	s PriorSp=$p(StrParam,"^",7)
	s Incib=$p(StrParam,"^",11)
	s HospId=$p(StrParam,"^",12)
	i Incib="" s resultString=-16   ;获取batid失败
	q:resultString<0 resultString
	//s Batno=$p(StrParam,"^",11)
	//s ExpDate=$p(StrParam,"^",12)
	//s ManfId=$p(StrParam,"^",13)
	//s Ingri=$p(StrParam,"^",15)
	//s vendor=$p(StrParam,"^",16)
	s AdjReasonId=""
    tstart
    //s data=Incib_"^"_preexedate_"^"_ItmRowid_"^"_AdjUomId_"^"_ResultSp_"^"_ResultRp_"^"_AdjUserId_"^"_AdjReasonId_"^"_HospId_"^^^"_"^"_"入库生成^"_PriorRp_"^"_PriorSp
    s data=Incib_"^"_preexedate_"^"_ItmRowid_"^"_AdjUomId_"^"_ResultSp_"^"_ResultRp_"^"_AdjUserId_"^"_AdjReasonId_"^"_HospId_"^^"_"^"_"入库生成^"_PriorRp_"^"_PriorSp
    s AspBatId=##class(web.DHCST.INAdjPriceBatch).Insert(AdjBatNo,data,"Y")  //增加参数标识"Y"是入库自动插入的
	
	i AspBatId<=0 s resultString=-14
	i AspBatId<=0  trollback  ;d ##class(web.DHCST.Common.AppCommon).UnLock("ADJNO")
	q:AspBatId<=0 resultString
	s Params=GrpId_"^"_LocId
	s ret=##class(web.DHCST.INAdjPriceBatch).Audit(AspBatId,AdjUserId,Params)
	i ret<0 s resultString=-15
	i ret<0  trollback  q resultString ;d ##class(web.DHCST.Common.AppCommon).UnLock("ADJNO")
	tcommit
	;d ##class(web.DHCST.Common.AppCommon).UnLock("ADJNO")
	q resultString
}

/// create 审核时处理批次调价/
/// wyx 2014-04-16/
ClassMethod HandleAspBatch(DHCINGRI, Usr, StrParam)
{
    n (DHCINGRI,Usr,StrParam)
    s Ret=0
    s Ingri=DHCINGRI
    s gGroupId=$p(StrParam,"^",1)
    s gLocId=$p(StrParam,"^",2)
    s gUserId=Usr
    s HospId=""
    i gLocId'="" s HospId=$p(^CTLOC(gLocId),"^",22)
    s ingr=+DHCINGRI
    s ingri=$p(DHCINGRI,"||",2)    
    s IncId=$p(^DHCINGR(ingr,"GRI",ingri),"^",25)                                  
    //s IngrUomId=$p(^DHCINGR(ingr,"GRI",ingri),"^",10)   
    s NewSp=$p(^DHCINGR(ingr,"GRI",ingri),"^",45)   
    s Rp=$p(^DHCINGR(ingr,"GRI",ingri),"^",30)  
    //s BatchNo=$p(^DHCINGR(ingr,"GRI",ingri),"^",13)  
    //s ExpDate=$p(^DHCINGR(ingr,"GRI",ingri),"^",9)  
    //s ManfId=$p(^DHCINGR(ingr,"GRI",ingri),"^",29)  
    s StkGrpType=$p(^DHCINGR(ingr),"^",28)
    //s Vendor=$p(^DHCINGR(ingr),"^",3)
    S IncDesc=$P(^INCI(IncId,1),"^",2)
    //s StrParam=gGroupId_"^"_gLocId_"^"_gUserId
    //s BatData=BatchNo_"^"_ExpDate_ "^"_ManfId_"^"_Rp_"^"_IngrUomId_"^"_Vendor
    //s pricestr=##class(web.DHCST.DHCINGdRec).GetRPriceBatch(IncId,StrParam,BatData) //获取之前的价格
    ///20141117 调价时必须传批次ID，不能再去计算生成批次ID
    s Inclb=$p(^DHCINGR(ingr,"GRI",ingri),"^",1)
    s Incib=$$CIBrow^at299(Inclb)
    q:Incib="" -1
    s IngrUomId=$p(^DHCINGR(ingr,"GRI",ingri),"^",10)
    s pricestr=##class(web.DHCSTPRICE).GetPriceByIncib(Incib,+$h,IngrUomId,HospId,"")
    s PriorRp=$p(pricestr,"^",1)
    s PriorSp=$p(pricestr,"^",2)
    i (+PriorRp'=+Rp)||(+PriorSp'=+NewSp) d
    .s pricedata = IncId_"^"_IngrUomId_"^"_NewSp_"^"_Rp_"^"_gUserId_"^"_PriorRp_"^"_PriorSp_"^"_StkGrpType_"^"_gLocId_"^"_IncDesc
    .s pricedata2=Incib_"^"_HospId
    .//s pricedata2=BatchNo_"^"_ExpDate_ "^"_ManfId_"^"_HospId_"^"_Ingri_"^"_Vendor
    .s pricedata3=pricedata_"^"_pricedata2
    .s Ret=##class(web.DHCST.DHCINGdRec).CreateAdjPriceBatch(pricedata3)
    q Ret
}

/// create 当入库建单界面单位改变时避免除不尽从后台取相应单位的价格/
/// wyx 2014-04-16
/// w ##Class(web.DHCST.DHCINGdRec).GetChangRpSp("4251","66","142^165^13609")
ClassMethod GetChangRpSp(IncId, UomId, StrParam)
{
    s GroupId=$p(StrParam,"^",1)
    s LocId=$p(StrParam,"^",2)
    s UserId=$p(StrParam,"^",3)
    s HospId=""
    s:LocId'="" HospId=$p(^CTLOC(LocId),"^",22)
    s BUomId=$p(^INCI(IncId,1),"^",10)
    s Params=GroupId_"^"_LocId_"^"_UserId_"^"_HospId
    s Rp=##class(web.DHCST.Common.PriceCommon).GetConfigRp(IncId,UomId,##class(web.DHCST.DHCINGdRec).%GetParameter("AppName"),Params)
    /*
    i UomId=BUomId d
    .s Rp=##class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospId,2,"G")
    e  d
    .s Rp=##class(web.DHCST.Common.AppCommon).FormatRp(Rp,HospId,1,"G")
    */
    s Rp=##class(web.DHCST.Common.AppCommon).FormatInciRp(Rp,HospId,IncId,UomId)
    s SpProp=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName"),"DefaSp",Params)
    i SpProp=1  d   ;根据定价类型计算售价
    .s Sp=##class(web.DHCST.Common.PriceCommon).GetMtSp(IncId,UomId,Rp)
    e  d    ;取当前售价
    .//s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,PurUomId,HospId)
    .s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(IncId,+$h,UomId,HospId,"G","")
    /*
     I UomId=BUomId d
     .S Sp=##class(web.DHCST.Common.AppCommon).FormatSp(Sp,HospId,2,"G")
     E  D
     .S Sp=##class(web.DHCST.Common.AppCommon).FormatSp(Sp,HospId,1,"G")
     */
     s Sp=##class(web.DHCST.Common.AppCommon).FormatInciSp(Sp,HospId,IncId,UomId)
    q Rp_"^"_Sp
}

ClassMethod InsertRetA(DataStr As %String) As %String
{
 n (DataStr)
 s inclb=$p(DataStr,"^",1)
 s inci=$p(DataStr,"^",2)
 s locdr=$p(DataStr,"^",3)
 s retSp=$p(DataStr,"^",4)
 s qty=$p(DataStr,"^",5)
 s retSpAmt=$p(DataStr,"^",6)
 s userdr=$p(DataStr,"^",7)
 s rowid=$p(DataStr,"^",8)
 s rettype=$p(DataStr,"^",9)
 s retRp=$p(DataStr,"^",10)
 s retRpAmt=$p(DataStr,"^",11)
 s HospID=$p(DataStr,"^",12)
 s Uom=$p(DataStr,"^",13)
 s CustID=$p(DataStr,"^",14)
 s CurSp=+##Class(web.DHCSTPRICE).GetCurSp(inclb,Uom,HospID)
 s CurRp=+##Class(web.DHCSTPRICE).GetCurRp(inclb,Uom,HospID)
 s buom=$p(^INCI(inci,1),"^",10)
 q:(retSp=CurSp)&(retRp=CurRp) 0
 s adjSp=CurSp-retSp    ;损益价格
 s adjRp=CurRp-retRp
 s CurSpAmt=CurSp*qty
 s CurRpAmt=CurRp*qty
 s CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+inclb)
 s StkTypeDesc=$P(CatGrpStr,"^",4)
 s Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
 s CurSpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(CurSpAmt,Perv,"FmtSA",1)
 s CurRpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(CurRpAmt,Perv,"FmtRA",1)
 s AdjSpAmt=CurSpAmt-retSpAmt
 s AdjRpAmt=CurRpAmt-retRpAmt
 s date=+$h               ;date is the current date
 s time=$p($h,",",2)      ;time is the current time
 i $d(^DHCRETA(0,"TypePointer","G",rowid)) d
 .s retarowid=$o(^DHCRETA(0,"TypePointer","G",rowid,""))
 .&SQL(UPDATE DHC_RetAspAmount SET RETA_RpDiff=:adjRp,RETA_RpAmt=:AdjRpAmt WHERE RETA_RowId=:retarowid)
 e  d
 .&sql(insert into  DHC_RetAspAmount(RETA_INCI_DR,RETA_CTLOC_DR,RETA_AdjPrice,RETA_Qty,
 RETA_Amount,RETA_SSUSR_DR,RETA_Date,RETA_Time,RETA_Pointer,RETA_Type,RETA_RpDiff,RETA_RpAmt,RETA_Uom_Dr,RETA_INCLB_DR) 
  values (:inci,:locdr,:adjSp,:qty,:AdjSpAmt,:userdr,:date,:time,:rowid,:rettype,:adjRp,:AdjRpAmt,:Uom,:inclb))
 i SQLCODE'=0  d
 .s ret=$$SqlErrorRecord^DHCSTERROR("InsertRetA:DHC_RetAspAmount",rowid,SQLCODE_":"_$g(%msg))
 q:SQLCODE'=0 -2
 q 0
}

ClassMethod CreateImpAspA(ingri, UserId, RpRule)
{
	q:ingri="" 0
    s DhcIngr=+ingri
    s CH=$p(ingri,"||",2)
    s Sp=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",32) 
    s Rp=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",30)
    s Uom=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",10)      ;uom 
    s LocId=$p(^DHCINGR(DhcIngr),"^",13)
    s HospId=$p(^CTLOC(LocId),"^",22)
    s Inclb=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",1) 
    s Inci=+Inclb
    s CurSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(Inclb,+$h,Uom,HospId,"G","")
    s inciID=$p(Inclb,"||",1)
    s dateh=+$h
    s CurRp=##class(web.DHCSTPRICE).GetRp(Inclb,+$h,Uom,HospId,"") //zhouyg 20141203
    //i (RpRule=2)&(Rp=CurRp)&(Sp=CurSp) d
    i $d(^DHCRETA(0,"TypePointer","G",ingri)) d
    .s retarowid=$o(^DHCRETA(0,"TypePointer","G",ingri,""))
    .&SQL(delete from DHC_RetAspAmount WHERE RETA_RowId=:retarowid)
    q:(RpRule=2)&(Rp=CurRp)&(Sp=CurSp) 0  ;不需要调价
    q:(RpRule=1)&(Sp=CurSp) 0   
    //s AspFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DHCINGdRec).%GetParameter("AppName"),"AllowAspWhileReceive")
    //q:AspFlag'="Y" -1  ;售价与当前价不一致，但是不允许自动调价    
    s ret=0
    s CustStr=##Class(web.DHCSTCOMMO).GetLocCust(LocId)
    s CustID=$p(CustStr,"^",1)
    S CatGrpStr=##Class(web.DHCSTCOMINC).GetIncStkCatGrp(+Inclb)
	S StkTypeDesc=$P(CatGrpStr,"^",4)
    S Perv="^^^"_StkTypeDesc_"^"_CustID_"^DHC"
    s sQty=$p(^DHCINGR(DhcIngr,"GRI",CH),"^",4)
    s SpAmt=Sp*sQty
    s SpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(SpAmt,Perv,"FmtSA",1)
    s RpAmt=Rp*sQty
    s RpAmt=##Class(web.DHCSTCOMMPARA).GetNumbDec(RpAmt,Perv,"FmtRA",1)
    s sType="G"
    s DataStr=Inclb_"^"_Inci_"^"_LocId_"^"_Sp_"^"_+sQty_"^"_+SpAmt_"^"_UserId_"^"_ingri_"^"_sType_"^"_Rp_"^"_RpAmt_"^"_HospId_"^"_Uom_"^"_CustID
    s ret=..InsertRetA(DataStr)
    q:ret<0 -1
    q 0
}

/// Decription: 验证入库单明细信息（验证内容:单位）
/// Creator:	yangsj
/// CreateDate:	2021-05-10
/// InPut:		Ingd
/// Tabal:		DHC_INGdRecItm
/// Debugger:	w ##Class(web.DHCST.DHCINGdRec).CheckDetailInfo(147)
ClassMethod CheckDetailInfo(Ingd)
{
	n (Ingd)
	s Ret = ""
	s chl = 0
	f  s chl = $O(^DHCINGR(Ingd,"GRI",chl)) q:(chl="")||(Ret'="")  d
	.s Data  = ^DHCINGR(Ingd,"GRI",chl)
	.s Uom   = $P(Data,"^",10)
	.s inci  = $P(Data,"^",25)
	.s Buom  = $P(^INCI(inci,1),"^",10)
	.s Puom  = $P(^INCI(inci,3),"^",6)
	.i (Uom'=Buom)&&(Uom'=Puom) s Ret=$P(^INCI(inci,1),"^",2)_..Trans("的(单位)不是(基本单位)或(入库单位)")
	
	q Ret
}

/// Decription:	判断入库单是否存在麻醉精一药品
/// Creator   :	yangsj
/// CreateDate:	2021-07-19
/// Input     :
/// Output    : Y/N
/// Table     : 
/// Debugger  : w ##Class(web.DHCST.DHCINGdRec).CheckMZJYExsit(2)
ClassMethod CheckMZJYExsit(INGD)
{
	s Exsit ="N"
	s Itm = $O(^DHCINGR(0,"POISON","Y",INGD,0)) 
	i Itm '= "" s Exsit = "Y"
	q Exsit
}

/// Decription:	保存麻醉精一操作状态
/// Creator   :	yangsj
/// CreateDate:	2021-07-19
/// Input     :
/// Output    : Y/N
/// Table     : 
/// Debugger  : w ##Class(web.DHCST.DHCINGdRec).SaveStatus(2,4,5)
ClassMethod SaveStatus(Type, Pointer, Status, User, Remark = "", CheckRepeat = "N")
{
	s MZJYFlag = ..CheckMZJYExsit(Pointer)
	q:(MZJYFlag '= "Y") "-1^入库单中不包含麻醉精一药品"
	q ##Class(BS.PHA.IN.Status).Save(Type, Pointer, Status, User, Remark, CheckRepeat)
}

/// 翻译 
/// yangsj 2020-11-05
ClassMethod Trans(Text)
{
	n (Text)
	q:##class(%Dictionary.MethodDefinition).%ExistsId("websys.Translation||Get")'=1 Text
	s newText = ##class(websys.Translation).Get("dhcst.ingdrecaudit.csp",Text)
	q:newText="" Text
	q newText
}

}
