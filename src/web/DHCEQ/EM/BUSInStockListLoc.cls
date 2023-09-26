/// creator  by ZY0252 20210301
Class web.DHCEQ.EM.BUSInStockListLoc Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by ZY260 2021-04-28
/// 描述：入库明细对应的科室申购明细
/// 入参：InStockListID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInStockListLoc","GetInStockListLoc",50)
Query GetInStockListLoc(InStockListID As %Library.String = "") As %Query(ROWSPEC = "ISLLRowID:%String,ISLLInStockListDR:%String,ISLLOpenCheckListLocDR:%String,ISLLBuyLocDR:%String,ISLLBuyLocDR_CTLOCDesc:%String,ISLLQuantity:%String,ISLLLeaveFactoryNo:%String,ISLLFileNo:%String,ISLLRemark:%String,ISLLHold1:%String,ISLLHold2:%String,ISLLHold3:%String,ISLLHold4:%String,ISLLHold5:%String")
{
}

ClassMethod GetInStockListLocExecute(ByRef qHandle As %Binary, InStockListID As %Library.String = "") As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    if '$Data(^DHCEQInStockListLoc(0,"InStockList",InStockListID))
    {
        d OutputRowGetInStockListLoc
    }
    else
    {
        s rowid=0
        f  s rowid=$o(^DHCEQInStockListLoc(0,"InStockList",InStockListID,rowid)) quit:rowid=""  d
        .d ResetVariablesGetInStockListLoc
        .s DataList=$g(^DHCEQInStockListLoc(rowid))
        .s ISLLRowID=rowid
        .s ISLLInStockListDR=$p(DataList,"^",1)
        .s ISLLOpenCheckListLocDR=$p(DataList,"^",2)
        .s ISLLBuyLocDR=$p(DataList,"^",3)
        .s ISLLBuyLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",ISLLBuyLocDR)
        .s ISLLQuantity=$p(DataList,"^",4)
        .s ISLLLeaveFactoryNo=$p(DataList,"^",5)
        .s ISLLFileNo=$p(DataList,"^",6)
        .s ISLLRemark=$p(DataList,"^",7)
        .s ISLLHold1=$p(DataList,"^",8)
        .s ISLLHold2=$p(DataList,"^",9)
        .s ISLLHold3=$p(DataList,"^",10)
        .s ISLLHold4=$p(DataList,"^",11)
        .s ISLLHold5=$p(DataList,"^",12)
        .d OutputRowGetInStockListLoc
    }
    Quit $$$OK
OutputRowGetInStockListLoc
    s Data=$lb(ISLLRowID,ISLLInStockListDR,ISLLOpenCheckListLocDR,ISLLBuyLocDR,ISLLBuyLoc,ISLLQuantity,ISLLLeaveFactoryNo,ISLLFileNo,ISLLRemark,ISLLHold1,ISLLHold2,ISLLHold3,ISLLHold4,ISLLHold5)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetInStockListLoc
    s (DataList,ISLLRowID,ISLLInStockListDR,ISLLOpenCheckListLocDR,ISLLBuyLocDR,ISLLBuyLoc,ISLLQuantity,ISLLLeaveFactoryNo,ISLLFileNo,ISLLRemark,ISLLHold1,ISLLHold2,ISLLHold3,ISLLHold4,ISLLHold5)=""
    quit
}

ClassMethod GetInStockListLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockListLocExecute ]
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

ClassMethod GetInStockListLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockListLocExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// modified by ZY20221115 Bug:3086173
/// w ##Class(web.DHCEQ.EM.BUSInStockListLoc).SaveData("{\"CLLRowID\":\"\",\"CLLContractListDR\":\"28\",\"CLLBuyPlanListLocDR\":\"\",\"CLLBuyRequestListDR\":\"\",\"CLLBuyLocDR\":\"3\",\"CLLBuyLoc_CTLOCDesc\":\"X线室\",\"CLLQuantity\":\"3\",\"CLLArrivedQuantity\":\"\",\"CLLRemark\":\"\",\"CLLHold1\":\"\",\"CLLHold2\":\"\",\"CLLHold3\":\"\",\"CLLHold4\":\"\",\"CLLHold5\":\"\"}",0)
ClassMethod SaveData(dataList, DelIs, SaveFlag As %Library.String = "")
{
    s $ZT="ERRORSave"
    k PLIST,RowID
    TSTART
    if DelIs=1
    {
        s RowID=dataList
        &SQL(delete from SQLUSER.DHC_EQInStockListLoc where ISLL_RowID = :RowID)
        s RowID=""
    }
    else
    {
        s SQLCODE=0
        Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")  //add by zx 2019-07-24 分隔符号处理
        s ISLRowID=""
        s Length=$L(dataList,SplitRowCode)
        for i=1:1:Length
        {
            q:SQLCODE'=0
            s valList=  $p(dataList,SplitRowCode,i)  //add by zx 2019-07-24 分隔符号处理
            q:valList=""
            k PLIST,ISLLRowID
            s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
            s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQInStockListLoc",JsonData,.PLIST)
            s ISLLRowID = JsonData.ISLLRowID
            s ISLRowID=JsonData.ISLLInStockListDR
            if ISLLRowID'=""
            {
                &SQL(Update SQLUSER.DHC_EQInStockListLoc Values :PLIST() where ISLL_RowID = :ISLLRowID)
            }
            else
            {
                &SQL(insert into SQLUSER.DHC_EQInStockListLoc Values :PLIST())
                s ISLLRowID=$g(%ROWID)
            }
        }
        q:SQLCODE'=0
        i (SaveFlag=1)&&(ISLRowID'="")
        {
            s SQLCODE=##Class(web.DHCEQ.EM.BUSInStockListLoc).SaveLeaveFactoryNoByISLLRowID(ISLRowID)
        }
    }
    i SQLCODE
    {
        TROLLBACK
        q SQLCODE
    }
    TCOMMIT
    q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    
ERRORSave
    TROLLBACK
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSInStockListLoc).CheckInStockListLoc(54)
ClassMethod CheckInStockListLoc(ISRowID, InStockListID As %Library.String = "")
{
    i ISRowID="" q ""
    s result=""
    s rowid=0
    f  s rowid=$o(^DHCEQInStockList(0,"InStock",ISRowID,rowid)) quit:(rowid="")||(result'="")  d
    .q:(InStockListID'="")&&(InStockListID'=rowid)
    .s TotalQuantityNum = $p($g(^DHCEQInStockList(rowid)),"^",8)
    .s EquipName=$p($g(^DHCEQInStockList(rowid)),"^",5)
    .s tmpQuantity=0
    .s Locrowid=0
    .f  s Locrowid=$o(^DHCEQInStockListLoc(0,"InStockList",rowid,Locrowid)) quit:(Locrowid="")||(result'="")  d
    ..s CLLQuantity=$p($g(^DHCEQInStockListLoc(Locrowid)),"^",4)
    ..s tmpQuantity=tmpQuantity+CLLQuantity
    .i (TotalQuantityNum'=tmpQuantity) s result=EquipName_"科室明细的总数量和入库明细数量不一致"
    q result
}

/// Creator：      ZY
/// CreatDate：    2021-04-28
/// Description:   入库保存时存验收明细子表数据
/// Input：        OCLRowID:验收明细ID
/// Return：       SQLCODE
/// w ##Class(web.DHCEQ.EM.BUSInStockListLoc).SaveInStockListLoc(53)
ClassMethod SaveInStockListLoc(ISLRowID)
{
    new OCLLRowID,SQLCODE,SourceType,SourceID
    s (OCLLRowID,SQLCODE)=0
    k ISLLPIST
    s SourceType=$p($g(^DHCEQInStockList(ISLRowID)),"^",18)
    s SourceID=$p($g(^DHCEQInStockList(ISLRowID)),"^",19)
    if SourceType=2
    {
        f  s OCLLRowID=$o(^DHCEQOpenCheckListLoc(0,"OpenCheckList",SourceID,OCLLRowID)) quit:(OCLLRowID="")||(SQLCODE'=0)  d
        .s ISLLPIST(2)=ISLRowID
        .s ISLLPIST(3)=OCLLRowID
        .s ISLLPIST(4)=$p($g(^DHCEQOpenCheckListLoc(OCLLRowID)),"^",3)
        .s ISLLPIST(5)=$p($g(^DHCEQOpenCheckListLoc(OCLLRowID)),"^",4)
        .s ISLLPIST(6)=$p($g(^DHCEQOpenCheckListLoc(OCLLRowID)),"^",5)
        .s ISLLPIST(7)=$p($g(^DHCEQOpenCheckListLoc(OCLLRowID)),"^",6)
        .&SQL(insert into SQLUSER.DHC_EQInStockListLoc Values :ISLLPIST())
    }
    q SQLCODE
}

/// add by ZY20221115 Bug:3086173
/// 根据入库明细获取入库明细对应科室明细中的出厂编号和档案号
/// ISLRowID:入库明细ID
/// type:    1:出厂编号;  2:档案号
/// num:     明细中第几个设备
/// w ##Class(web.DHCEQ.EM.BUSInStockListLoc).GetLeaveFactoryNoOrFileNo(44,"1",1)
ClassMethod GetLeaveFactoryNoOrFileNo(ISLRowID, type, num As %Library.String = "")
{
    new ISLLRowID,ISLLQuantity,LeaveFactoryNo,FileNo,LeaveFactoryNos,FileNos,MXNum
    s (LeaveFactoryNos,FileNos)=""
    s EquipNum=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
    
    s (ISLLRowID,MXNum)=0
    f  s ISLLRowID=$o(^DHCEQInStockListLoc(0,"InStockList",ISLRowID,ISLLRowID)) quit:(ISLLRowID="")  d
    .s (ISLLQuantity,LeaveFactoryNo,FileNo)=""
    .s ISLLQuantity=+$p($g(^DHCEQInStockListLoc(ISLLRowID)),"^",4)
    .s LeaveFactoryNo=$p($g(^DHCEQInStockListLoc(ISLLRowID)),"^",5)
    .s LeaveFactoryNo=##class(web.DHCEQCommon).Replace(LeaveFactoryNo,$C(13,10),"")
    .s LeaveFactoryNo=##class(web.DHCEQCommon).Replace(LeaveFactoryNo,$C(65292),",")
    .s FileNo=$p($g(^DHCEQInStockListLoc(ISLLRowID)),"^",6)
    .s FileNo=##class(web.DHCEQCommon).Replace(FileNo,$C(13,10),"")
    .s FileNo=##class(web.DHCEQCommon).Replace(FileNo,$C(65292),",")
    .f i=1:1:ISLLQuantity  d
    ..s MXNum=MXNum+1
    ..i LeaveFactoryNos="" d
    ...s LeaveFactoryNos=$p(LeaveFactoryNo,",",i)
    ..e  d
    ...s LeaveFactoryNos=LeaveFactoryNos_","_$p(LeaveFactoryNo,",",i)
    ..i FileNos="" d
    ...s FileNos=$p(FileNo,",",i)
    ..e  d
    ...s FileNos=FileNos_","_$p(FileNo,",",i)
    
    if MXNum<EquipNum
    {
        s EndNum=EquipNum-EndNum
        f i=1:1:EndNum  d
        .i LeaveFactoryNos="" d 
        ..s LeaveFactoryNos=$p(LeaveFactoryNo,",",i)
        .e  d
        ..s LeaveFactoryNos=LeaveFactoryNos_","_$p(LeaveFactoryNo,",",i)
        .i FileNos="" d
        ..s FileNos=$p(FileNo,",",i)
        .e  d
        ..s FileNos=FileNos_","_$p(FileNo,",",i)
    }
    if type=1
    {
        i num'="" q $p(LeaveFactoryNos,",",num)
        q LeaveFactoryNos
    }
    elseif type=2
    {
        i num'="" q $p(FileNos,",",num)
        q FileNos
    }
    else
    {
        q ""
    }
}

/// add by ZY20221115 Bug:3086173
/// 根据入库明细获取入库明细对应科室明细中的出厂编号和档案号更新到台账上
/// ISLRowID:入库明细ID
/// w ##Class(web.DHCEQ.EM.BUSInStockListLoc).SaveLeaveFactoryNoByISLLRowID(47)
ClassMethod SaveLeaveFactoryNoByISLLRowID(ISLRowID)
{
    new EquipID,SourceType,Num,SourceID,SQLCODE
    s SQLCODE=0
    s SourceType=$p(^DHCEQInStockList(ISLRowID),"^",18)
    s SourceID=$p(^DHCEQInStockList(ISLRowID),"^",19)
    i (SourceType="2")
    {
        s Num=1
        
        s EquipID=0
        f  s EquipID=$o(^DHCEQEquip(0,"OpenCheckList",SourceID,EquipID))  q:EquipID=""  d
        .k EQPL
        .s EQPL(11)=##Class(web.DHCEQ.EM.BUSInStockListLoc).GetLeaveFactoryNoOrFileNo(ISLRowID,"1",Num)
        .s EQPL(86)=##Class(web.DHCEQ.EM.BUSInStockListLoc).GetLeaveFactoryNoOrFileNo(ISLRowID,"2",Num)
        .&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_RowID=:EquipID)
        .s Num=Num+1
    }
    q SQLCODE
}

}
