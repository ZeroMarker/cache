/// 名称: web.DHCEQ.Plat.LIBBusinessCancel
/// 描述: 资产单据作废操作
/// 编写者：ZY
/// 编写日期: 2023-03-02
/// 产品组：设备管理
Class web.DHCEQ.Plat.LIBBusinessCancel Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##Class(web.DHCEQ.Plat.LIBBusinessCancel).CheckStoreMoveList()
ClassMethod CheckStoreMoveList(SMRowID)
{
    s ReturnFlag=0
    s SMLRowID=0
    f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:(SMLRowID="")||(+ReturnFlag'=0)  d
    .s EQRowIDs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
    .s EQLength=$l(EQRowIDs,",")
    .f i=1:1:EQLength d
    ..s EQRowID=$p(EQRowIDs,",",i)
    ..s LIReturnFlag=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EQRowID,22,BussAuditDate))
    ..i LIReturnFlag'="" s ReturnFlag="-1^存在其他转移业务"
    ..q:+ReturnFlag'=0
    ..s LIReturnFlag=$o(^DHCEQLifeInfo(0,"EquipSourceDate",EQRowID,22,BussAuditDate,""),-1)
    ..i LIReturnFlag'=""  d
    ...s LISourceID=$p($g(^DHCEQLifeInfo(LIReturnFlag)),"^",20)
    ...i SMLRowID'=LISourceID s ReturnFlag="-1^存在其他转移业务"
    ..q:+ReturnFlag'=0
    ..s ReturnFlag=##class(web.DHCEQAbnormalDataDeal).CheckEquipBuss(EQRowID,"01,02,03,04,05,06,07,08,09,10")
    q ReturnFlag
}

/// 根据出库单自动生成退库单
ClassMethod AutoStoreMove(RowID)
{
    s $ZT="ERRORAutoStoreMove"
    s USERID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    
    ;检测转移明细设备是否有其他业务
    s result=##Class(web.DHCEQ.Plat.LIBBusinessCancel).CheckStoreMoveList(RowID)
    If result'=0
    {
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson($p(result,"^",1),$p(result,"^",2))
    }
    
    Set DataList=$Get(^DHCEQStoreMove(RowID))
    Kill PLIST,PLISTSML
    ;主表
    Set PLIST(3) = $Piece(DataList,"^",2)  ;FromLocDR
    Set PLIST(4) = $Piece(DataList,"^",3)    ;ToLocDR
    Set PLIST(5) = USERID         ;MakerDR
    Set PLIST(6) = +$H            ;MakeDate
    Set PLIST(13) = "3"           ;MoveType
    Set PLIST(14) = "0"           ;Status
    Set PLIST(15) = "出库单需要作废,自动生成的退库单"    ;_"出库单需要作废,自动生成的退库单"    ;Remark
    Set PLIST(17) = $Piece(DataList,"^",16)    ;EquipTypeDR
    Set PLIST(18) = $Piece(DataList,"^",17)    ;StatCatDR
    Set PLIST(28) = "N"
    Set MoveTypeCode=##Class(web.DHCEQStoreMoveNew).GetMoveTypeCode(3)

    TSTART
    
    Set PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQStoreMove",+$H,PLIST(3),PLIST(17),PLIST(18),"",MoveTypeCode)
    &SQL(insert into sqluser.DHC_EQStoreMove values :PLIST())
    If SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"退库单写入失败!")
    }
    Set SMRowID=$Get(%ROWID)
    Set PLISTSML(2)=SMRowID
    
    ;复制明细表数据
    Set tmpMXRowID=0
    For  Set tmpMXRowID=$Order(^DHCEQStoreMoveList(0,"StoreMove",RowID,tmpMXRowID)) Quit:(tmpMXRowID="")||(SQLCODE)  Do
    .Set MXDataList=$Get(^DHCEQStoreMoveList(tmpMXRowID))
    .f i=3:1:18  d
    ..Set PLISTSML(i)=$p(MXDataList,"^",(i-1))
    .&SQL(Insert Into SQLUSER.DHC_EQStoreMoveList Values :PLISTSML())
    .Set SMLRowID=$Get(%ROWID)
    .q:SQLCODE'=0
    .Set ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")=$g(^DHCEQStoreMoveList(tmpMXRowID,"EX","RowIDs"))
    
    If SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"写入明细表数据失败!")
    }
    
    //提交
    Set val=SMRowID_"^^^^^^^^"_USERID
    Set result = ##Class(web.DHCEQStoreMoveNew).SubmitData(val)
    i SMRowID=result d
    .s SQLCODE=0
    e  d
    .s SQLCODE=result
    
    If SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"提交退库单失败!")
    }
    
    ;审核完成自动生成的入库单    AuditData(val, CurRole, RoleStep, editFieldsInfo)
    Set AppSet=##class(web.DHCEQApproveList).GetApproveSet("14", SMRowID)    
    If AppSet="" Set SQLCODE = -4007
    If SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"退库单没有审核设置!")
    }
    Set afstep=0
    For  Set afstep=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSet,afstep)) Quit:(afstep="")||(SQLCODE)  Do
    .Set afid=0
    .For  Set afid=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSet,afstep,afid)) Quit:(afid="")||(SQLCODE)  Do
    ..Set afrole=$p(^DHCEQCCode("DHCEQCApproveFlow",afid),"^",2)
    ..Set result = ##Class(web.DHCEQStoreMoveNew).AuditData(val,afrole,afstep,"")
    ..i SMRowID=result d
    ...s SQLCODE=0
    ..e  d
    ...s SQLCODE=result
    If SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"退库单在第"_afstep_"步审核失败!")
    }
    TCOMMIT
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,PLIST(2))
ERRORAutoStoreMove
    TROLLBACK
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// w ##Class(web.DHCEQ.Plat.LIBBusinessCancel).CheckInStockList()
ClassMethod CheckInStockList(ISRowID)
{
    s ISStoreLocDR=$p($Get(^DHCEQInStock(RowID)),"^",2)
    s ReturnFlag=0
    
    ;检测对应设备是否存在相关业务
    s ISLRowID=0
    f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID))  q:(ISLRowID="")||(+ReturnFlag'=0)  d
    .s QuantityNum=$p($Get(^DHCEQInStockList(tmpMXRowID)),"^",8)
    .s EquipIDs=""
    .s Num=0
    .s EQRowID=0
    .f  s EQRowID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,ISStoreLocDR,EQRowID))  q:(EQRowID="")  d
    ..
    ..s Num=Num+1
    .i QuantityNum'=Num s ReturnFlag="-1^["_$p($Get(^DHCEQInStockList(tmpMXRowID)),"^",5)_"]在库资产数据与入库单明细的数量不一致,请先把出库的资产退回库房再退货!"
    
    q ReturnFlag
}

/// 根据出库单自动生成退库单
ClassMethod AutoReturn(ISRowID)
{
    s $ZT="ERRORAutoReturn"
    s USERID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    ;生成出库业务信息
    
    ;检测入库明细设备是否都在库房
    s result=##Class(web.DHCEQ.Plat.LIBBusinessCancel).CheckInStockList(ISRowID)
    If result'=0
    {
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson($p(result,"^",1),$p(result,"^",2))
    }
    
    Set DataList=$Get(^DHCEQInStock(RowID))
    Kill PLIST,PLISTML
    s ROutTypeDR=1
    ;主表
    s PLIST(3) = $p(DataList,"^",2)     ;ReturnLocDR
    s PLIST(4) = $p(DataList,"^",17)    ;ProviderDR
    s PLIST(5) = +$H                    ;ReturnDate
    s PLIST(6) = USERID                 ;MakerDR
    s PLIST(7) = +$H                    ;MakeDate
    s PLIST(14)="0"                     ;Status
    s PLIST(15) = "入库单需要作废,自动生成的退货单"    ;Remark
    s PLIST(16) = $p(DataList,"^",20)   ;EquipTypeDR
    s PLIST(17) = $p(DataList,"^",21)   ;StatCatDR
    s PLIST(18) = ROutTypeDR    ;OutTypeDR
    s PLIST(19) = ""                    ;ToDeptDR
    s PLIST(29) = "N"
    
    s OutTypeCode=$p(^DHCEQCCode("DHCEQCOutType",ROutTypeDR),"^",1)    
    TSTART
    
    s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQReturn",+$H,"",PLIST(16),"","","",OutTypeCode)
    &SQL(insert into sqluser.DHC_EQReturn values :PLIST())
    If SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"退货单写入失败!")
    }
    Set RRowID=$Get(%ROWID)
    Set PLISTML(2)=RRowID
    
    ;复制明细表数据
    Set tmpMXRowID=0
    For  Set tmpMXRowID=$Order(^DHCEQInStockList(0,"InStock",ISRowID,tmpMXRowID)) Quit:(tmpMXRowID="")||(SQLCODE)  Do
    .Set MXDataList=$Get(^DHCEQInStockList(tmpMXRowID))
    .Set PLISTML(3)="N" //BatchFlag
    .i $p(MXDataList,"^",8)>1 Set PLISTML(3)="Y"
    .Set PLISTML(4)=tmpMXRowID      //InStockListDR
    .Set PLISTML(5)=$p(MXDataList,"^",2)    //EquipDR
    .Set PLISTML(6)=$p(MXDataList,"^",8)    //quantityNum
    .Set PLISTML(7)=$p(MXDataList,"^",7)*$p(MXDataList,"^",8)    //ReturnFee
    .Set PLISTML(8)=$p(MXDataList,"^",8)    //InvoiceNo
    .Set PLISTML(9)=$p(##Class(web.DHCEQInvoice).GetInvoiceInfos(1,tmpMXRowID),"^",1)    //ReasonDR
    .
    .&SQL(Insert Into SQLUSER.DHC_EQReturnList Values :PLISTML())
    .Set RLRowID=$Get(%ROWID)
    .q:SQLCODE'=0
    .s EquipIDs=""
    .s EQRowID=0
    .f  s EQRowID=$o(^DHCEQEquip(0,"InStockList",tmpMXRowID,PLIST(3),EQRowID))  q:(EQRowID="")  d
    ..i EquipIDs=""  d
    ...s EquipIDs=EQRowID
    ..e  d
    ...s EquipIDs=EquipIDs_","_EQRowID
    .s ^DHCEQReturnList(RLRowID,"EX","RowIDs")=EquipIDs
    
    If SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"写入明细表数据失败!")
    }
    
    //提交
    s ReturnData=$Get(^DHCEQReturn(RRowID))
    s val=RRowID_"^"_$p(ReturnData,"^",2)_"^^^^"_$p(ReturnData,"^",15)_"^"_$p(ReturnData,"^",16)_"^^^^^^"_USERID
    s result = ##Class(web.DHCEQ.EM.BUSReturn).SubmitData(val)
    s result=##class(web.DHCEQ.Plat.LIBCommon).StringToJson(result)
    i result.SQLCODE'=0
    {
        s SQLCODE=result.SQLCODE
    }
    else
    {
        s SQLCODE=result.Data
    }
    If SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"提交退货单失败!")
    }
    
    ;审核完成自动生成的入库单    AuditData(val, CurRole, RoleStep, editFieldsInfo)
    Set AppSet=##class(web.DHCEQApproveList).GetApproveSet("15", RRowID)   
    If AppSet="" Set SQLCODE = -4007
    If SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"退货单没有审核设置!")
    }
    Set afstep=0
    For  Set afstep=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSet,afstep)) Quit:(afstep="")||(SQLCODE)  Do
    .Set afid=0
    .For  Set afid=$Order(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSet,afstep,afid)) Quit:(afid="")||(SQLCODE)  Do
    ..s afrole=$p(^DHCEQCCode("DHCEQCApproveFlow",afid),"^",2)
    ..s result = ##Class(web.DHCEQ.EM.BUSReturn).AuditData(val,afrole,afstep,"")
    ..s result=##class(web.DHCEQ.Plat.LIBCommon).StringToJson(result)
    ..i result.SQLCODE'=0  d
    ...s SQLCODE=result.SQLCODE
    
    If SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"退货单在第"_afstep_"步审核失败!")
    }
    TCOMMIT
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,PLIST(2))
ERRORAutoReturn
    TROLLBACK
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

}
