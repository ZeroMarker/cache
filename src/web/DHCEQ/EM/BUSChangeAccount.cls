/// 名称: web.DHCEQ.EM.BUSChangeAccount
/// 描述: 设备调账管理
/// 编写者：ZY 2854248
/// 编写日期: 2022-08-18
/// 产品组：设备管理
Class web.DHCEQ.EM.BUSChangeAccount Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 根据设备ID取调账记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSChangeAccount","GetChangeAccount","3")
Query GetChangeAccount(EquipDR As %String) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TChangeFee:%String,TChangedOriginalFee:%String,TChangedNetFee:%String,TTotalDepreFee:%String,TChangeItem:%String,TChangeReasonDR:%String,TChangeReason:%String,TChangeDate:%String,TRemark:%String,TStatus:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TSubmitUserDR:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TOriginalFee:%String,TNetFee:%String,TNetRemainFee:%String,TChangedNetRemainFee:%String,TEquip:%String,TChangeReason:%String,TAddUser:%String,TUpdateUser:%String,TSubmitUser:%String,TAuditUser:%String,TChangeDepreTotalFee:%String,THold3:%String")
{
}

ClassMethod GetChangeAccountExecute(ByRef qHandle As %Binary, EquipDR As %String) As %Status
{
    new repid, index,rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    s rowid=0
    Set TRow=0
    d BuildDataGetChangeAccount
    Quit $$$OK
BuildDataGetChangeAccount
    f  s rowid=$o(^DHCEQChangeAccount(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
    .d ResetVariablesGetChangeAccount
    .s TRowID = rowid
    .s TEquipDR = $p($g(^DHCEQChangeAccount(rowid)),"^",1)
    .i TEquipDR '=""  d
    ..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
    .s TChangeFee = $p($g(^DHCEQChangeAccount(rowid)),"^",2)
    .s TChangedOriginalFee = $p($g(^DHCEQChangeAccount(rowid)),"^",3)
    .s TChangedNetFee = $p($g(^DHCEQChangeAccount(rowid)),"^",4)
    .s TTotalDepreFee = $p($g(^DHCEQChangeAccount(rowid)),"^",5)
    .s TChangeItem = $p($g(^DHCEQChangeAccount(rowid)),"^",6)
    .s TChangeReasonDR = $p($g(^DHCEQChangeAccount(rowid)),"^",7)
    .i TChangeReasonDR '=""  d
    ..s TChangeReason = $p($g(^DHCEQCCode("DHCEQCValueChangeReason",TChangeReasonDR)),"^",2)
    .s TChangeReason = $p($g(^DHCEQChangeAccount(rowid)),"^",8)
    .s TChangeDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeAccount(rowid)),"^",9),"date")
    .s TRemark = $p($g(^DHCEQChangeAccount(rowid)),"^",10)
    .s TStatus = $p($g(^DHCEQChangeAccount(rowid)),"^",11)
    .s TStatus = ##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
    .s TAddUserDR = $p($g(^DHCEQChangeAccount(rowid)),"^",12)
    .i TAddUserDR '=""  d
    ..s TAddUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
    .s TAddDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeAccount(rowid)),"^",13),"date")
    .s TAddTime = $p($g(^DHCEQChangeAccount(rowid)),"^",14)
    .s TUpdateUserDR = $p($g(^DHCEQChangeAccount(rowid)),"^",15)
    .i TUpdateUserDR '=""  d
    ..s TUpdateUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
    .s TUpdateDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeAccount(rowid)),"^",16),"date")
    .s TUpdateTime = $p($g(^DHCEQChangeAccount(rowid)),"^",17)
    .s TSubmitUserDR = $p($g(^DHCEQChangeAccount(rowid)),"^",18)
    .i TSubmitUserDR '=""  d
    ..s TSubmitUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
    .s TSubmitDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeAccount(rowid)),"^",19),"date")
    .s TSubmitTime = $p($g(^DHCEQChangeAccount(rowid)),"^",20)
    .s TAuditUserDR = $p($g(^DHCEQChangeAccount(rowid)),"^",21)
    .i TAuditUserDR '=""  d
    ..s TAuditUser = ##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
    .s TAuditDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQChangeAccount(rowid)),"^",22),"date")
    .s TAuditTime = $p($g(^DHCEQChangeAccount(rowid)),"^",23)
    .s TOriginalFee = $p($g(^DHCEQChangeAccount(rowid)),"^",24)
    .s TNetFee = $p($g(^DHCEQChangeAccount(rowid)),"^",25)
    .s TNetRemainFee = $p($g(^DHCEQChangeAccount(rowid)),"^",26)
    .s TChangedNetRemainFee = $p($g(^DHCEQChangeAccount(rowid)),"^",27)
    .Set TChangeDepreTotalFee=$Piece($Get(^DHCEQChangeAccount(rowid)),"^",33)   ///Mozy0148
    .Set THold3=$Piece($Get(^DHCEQChangeAccount(rowid)),"^",34)   //调整折旧月数
    .Set TChangedNetFee=##Class(web.DHCEQCommon).FormatNumber(TChangedNetFee,"",2)  //Modify DJ 2015-09-14 DJ0164 begin
    .Set TTotalDepreFee=##Class(web.DHCEQCommon).FormatNumber(TTotalDepreFee,"",2)
    .Set TChangedOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TChangedOriginalFee,"",2)
    .Set TChangeFee=##Class(web.DHCEQCommon).FormatNumber(TChangeFee,"",2)
    .Set TChangeDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TChangeDepreTotalFee,"",2)  //Modify DJ 2015-09-14 DJ0164 end
    .d OutputRowGetChangeAccount
    quit
OutputRowGetChangeAccount
    Set TRow=TRow+1
    Set Data=$lb(TRowID,TEquipDR,TChangeFee,TChangedOriginalFee,TChangedNetFee,TTotalDepreFee,TChangeItem,TChangeReasonDR,TChangeReason,TChangeDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TOriginalFee,TNetFee,TNetRemainFee,TChangedNetRemainFee,TEquip,TChangeReason,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TChangeDepreTotalFee,THold3)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
ResetVariablesGetChangeAccount
    Set (TRowID,TEquipDR,TChangeFee,TChangedOriginalFee,TChangedNetFee,TTotalDepreFee,TChangeItem,TChangeReasonDR,TChangeReason,TChangeDate,TRemark,TStatus,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TSubmitUserDR,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditDate,TAuditTime,TOriginalFee,TNetFee,TNetRemainFee,TChangedNetRemainFee,TEquip,TChangeReason,TAddUser,TUpdateUser,TSubmitUser,TAuditUser,TChangeDepreTotalFee)=""
    quit
}

ClassMethod GetChangeAccountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChangeAccountExecute ]
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

ClassMethod GetChangeAccountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChangeAccountExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSChangeAccount).GetOneChangeAccount(17)
ClassMethod GetOneChangeAccount(RowID As %Library.String = "")
{
    s $ZT="ERRORGetOneChangeAccount"
    s Obj=##Class(User.DHCEQChangeAccount).%OpenId(RowID)
    s ObjList=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(Obj)
    d ObjList.%Set("CARowID",RowID)
    d ObjList.%Set("CAPreTotalDepreFee",##class(web.DHCEQCommon).FormatNumber((Obj.CAOriginalFee-Obj.CANetFee),""))
    d ObjList.%Set("CAHold2",##class(web.DHCEQCommon).FormatNumber(Obj.CAHold2,""))
    d ObjList.%Set("CAHold3",##class(web.DHCEQCommon).FormatNumber(Obj.CAHold3,"",0))
    d ObjList.%Set("CAHold4_Desc","")
    if (Obj.CAHold4'="")
    {
        d ObjList.%Set("CAHold4_Desc",$Piece($Get(^DHCEQMMaintRequest(Obj.CAHold4)),"^",1))
    }
    
    s (AddFlag,AffixFee,AffixCount,AFRowID)=0
    s CAAffixIDS=""
    if (Obj.CAChangeFee>0)
    {
        s AddFlag=1
        f  s AFRowID=$o(^DHCEQAffix(0,"ChangeAccountAdd",RowID,AFRowID))  q:AFRowID=""  d
        .s AffixData=$g(^DHCEQAffix(AFRowID))
        .q:$p(AffixData,"^",15)="Y"
        .i CAAffixIDS=""  d
        ..s CAAffixIDS=AFRowID
        .e  d
        ..s CAAffixIDS=CAAffixIDS_","_AFRowID
        .s AffixFee=AffixFee+($p(AffixData,"^",7)*$p(AffixData,"^",11))
        .s AffixCount=AffixCount+1
    }
    elseif (Obj.CAChangeFee<0)
    {
        s AddFlag=0
        f  s AFRowID=$o(^DHCEQAffix(0,"ChangeAccountReduce",RowID,AFRowID))  q:AFRowID=""  d
        .s AffixData=$g(^DHCEQAffix(AFRowID))
        .q:$p(AffixData,"^",15)="Y"
        .i CAAffixIDS=""  d
        ..s CAAffixIDS=AFRowID
        .e  d
        ..s CAAffixIDS=CAAffixIDS_","_AFRowID
        .s AffixFee=AffixFee+($p(AffixData,"^",7)*$p(AffixData,"^",11))
        .s AffixCount=AffixCount+1
        s AffixFee=0-AffixFee
    }
    else
    {
        s AddFlag=0
        s AffixCount=0
        &SQL(Select Count(*) Into:AffixCount From SQLUSER.DHC_EQAffix Where AF_ChangeAccountAddDR=:RowID or AF_ChangeAccountReduceDR=:RowID)
        i AffixCount="" s AffixCount=0
    }
    d ObjList.%Set("CAAddFlag",AddFlag)
    d ObjList.%Set("CAAffixIDS",CAAffixIDS)
    d ObjList.%Set("CAAffixCount",AffixCount)
    d ObjList.%Set("CAAffixFee",AffixFee)
    
    q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,ObjList)
ERRORGetOneChangeAccount
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1000",ErrorMsg)
}

ClassMethod SaveData(data, DelIs, fundsInfo As %Library.String = "")
{
    s $ZT="ERRORChangeAccount"
    k PLIST,RowID
    s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    s Date=+$H
    s Time=$Piece($H,",",2)
    TSTART
    if DelIs=1
    {
        s RowID=data
        &SQL(Update SQLUSER.DHC_EQFunds Set F_InvalidFlag='Y' where F_SourceType=7 and F_SourceID=:RowID )
        if (SQLCODE'=0)&&(SQLCODE'=100)
        {
            TROLLBACK
            q SQLCODE
        }
        &SQL(Update SQLUSER.DHC_EQAffix Set AF_ChangeAccountAddDR=null Where AF_ChangeAccountAddDR=:RowID)
        if (SQLCODE'=0)&&(SQLCODE'=100)
        {
            TROLLBACK
            q SQLCODE
        }
        &SQL(Update SQLUSER.DHC_EQAffix Set AF_ChangeAccountReduceDR=null Where AF_ChangeAccountReduceDR=:RowID)
        if (SQLCODE'=0)&&(SQLCODE'=100)
        {
            TROLLBACK
            q SQLCODE
        }
        
        &SQL(Delete From SQLUSER.DHC_EQChangeAccount where CA_RowID = :RowID and CA_Status<2)
        if SQLCODE=100 s SQLCODE=0
    }
    else
    {
        s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
        
        s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQChangeAccount",JsonData,.PLIST)
        s RowID = JsonData.CARowID
        s CAEquipDR = JsonData.CAEquipDR
        s CAChangeFee = JsonData.CAChangeFee
        s CAAffixIDS = JsonData.CAAffixIDS
        
        i $Data(^DHCEQChangeAccount(0,"Equip",CAEquipDR))
        {
            s LastRowID=$o(^DHCEQChangeAccount(0,"Equip",CAEquipDR,""),-1)
            i (LastRowID'="")&&(LastRowID'=RowID)
            {
                s LastStatus=$p($g(^DHCEQChangeAccount(LastRowID)),"^",11)
                i LastStatus<2 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","尚有调帐记录未审核,不能保存.")
            }
        }
        
        s PLIST(12) = 0
        if (RowID="") 
        {
            s PLIST(13) = User
            s PLIST(14) = +$H
            s PLIST(15) = $P($H,",",2)
            &SQL(Insert Into SQLUSER.DHC_EQChangeAccount Values :PLIST())
            Set RowID=$g(%ROWID)
        }
        else
        {
            s PLIST(16) = User
            s PLIST(17) = +$H
            s PLIST(18) = $P($H,",",2)
            &SQL(Update SQLUSER.DHC_EQChangeAccount Values :PLIST() where CA_RowID = :RowID)
        }
        if SQLCODE
        {
            TROLLBACK
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
        }
        ;Modified by JDL 2012-2-27 JDL0117
        ;先清除历史关联附件信息,避免在增减值转换过程中,残留垃圾关联数据
        if CAAffixIDS'=""
        {
            ;Modified by JDL 2012-2-27 JDL0117
            ;先清除历史关联附件信息,避免在增减值转换过程中,残留垃圾关联数据;
            ;调账金额为0,不能关联附件!
            &SQL(Update SQLUSER.DHC_EQAffix Set AF_ChangeAccountAddDR=null Where AF_ChangeAccountAddDR=:RowID)
            if SQLCODE=100 s SQLCODE=0
            if SQLCODE
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
            }
            &SQL(Update SQLUSER.DHC_EQAffix Set AF_ChangeAccountReduceDR=null Where AF_ChangeAccountReduceDR=:RowID)
            if SQLCODE=100 s SQLCODE=0
            if SQLCODE
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
            }
            s Count=$l(CAAffixIDS,",")
            for i=1:1:Count
            {
                q:SQLCODE'=0
                s AffixID=$p(CAAffixIDS,",",i)
                if CAChangeFee>0
                {
                    &SQL(Update SQLUSER.DHC_EQAffix set AF_ChangeAccountAddDR=:RowID Where AF_RowID=:AffixID)
                }
                elseif CAChangeFee<0
                {
                    &SQL(Update SQLUSER.DHC_EQAffix set AF_ChangeAccountReduceDR=:RowID Where AF_RowID=:AffixID)
                }
                if SQLCODE=100 s SQLCODE=0
            }
            if SQLCODE
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","关联附件失败.")
            }
        }
        if fundsInfo'=""
        {
            s SQLCODE=##Class(web.DHCEQFunds).SaveFunds("7",RowID,fundsInfo,"")
            if SQLCODE'>0
            {
                TROLLBACK
                Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","资金来源信息保存失败,"_SQLCODE)
            }
            else
            {
                s SQLCODE=0
            }
        }
        
    }
    If SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    }
    TCOMMIT
    q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
    
ERRORChangeAccount
    TROLLBACK
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ErrorMsg)
}

/// ;Modified By JDL 2012-2-15 JDL0116
/// Modified By HZY 2012-02-09 HZY0022 
/// d ##class(web.DHCEQ.EM.BUSChangeAccount).AuditData("","",4,1,5)
ClassMethod AuditData(rowid As %Library.String = "", changetype As %Library.String = "")
{
    ///Mozy0148
    new updDate,updTime,EQStatus,NetFee,OriginalFee,DepreTotal,DepreSetID,DSDepreTotalFee
    new EQDepreTotalFee,ChangeDepreTotalFee,Fee,CADepreTotal
    s user=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    s updDate=+$H
    s updTime=$P($H,",",2)
    s RemainFeeRate=##class(web.DHCEQCommon).GetSysInfo("990029")       //2014-12-16 DJ DJ0131
    if (changetype'="")  s changetype=$o(^DHCEQCCode("DHCEQCChangeType",0,"CTType",changetype,0))
    ;Modified by JDL 2012-1-4 JDL0108
    k ^DHCEQTemp("ChangeAccount","Audit",$j,rowid)
    Set $ZT="ERRORAudit"
    
    //通过附件调账,并且有附件有资金来源
    s ChangeFee=$p($g(^DHCEQChangeAccount(rowid)),"^",2)
    s ChangeEquipDR=$p($g(^DHCEQChangeAccount(rowid)),"^",1)
    Set CADepreTotal=+$Piece($Get(^DHCEQChangeAccount(rowid)),"^",33)   ;CA_Hold2   调账进行调整累计折旧值 Mozy0148
    s OriginalFee=$p($g(^DHCEQEquip(ChangeEquipDR)),"^",27)
    s NetFee=$p($g(^DHCEQEquip(ChangeEquipDR)),"^",28)
    Set EQDepreTotalFee=+$Piece($Get(^DHCEQEquip(ChangeEquipDR)),"^",35)
    
    s EQStatus=$p($g(^DHCEQEquip(ChangeEquipDR)),"^",38)
    if (EQStatus=3) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","该记录已经审核,不能再审核!")
    if ($p($g(^DHCEQChangeAccount(rowid)),"^",11)=2) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","该设备已经报废,不能操作!")
    s SQLCODE=0
    TStart  
    //Function:Funds    2012-2-16 生成资金来源信息
    s SQLCODE=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(7,rowid,ChangeFee)
    if SQLCODE
    {
        TROLLBACK
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    }
    
    k PLIST
    s PLIST(15)="1"         ;SourceType
    s PLIST(16)=ChangeEquipDR       ;SourceID
    s PLIST(2)=ChangeEquipDR
    s PLIST(7)="0"
    s PLIST(8)=user
    s PLIST(9)=updDate
    s PLIST(10)=updTime
    s PLIST(11)="N"
        
    s CAFundsRowID=0
    f  s CAFundsRowID=$o(^DHCEQFunds("0","Source","7",rowid,CAFundsRowID))  q:((CAFundsRowID="")||(SQLCODE'=0))  d
    .q:$p($g(^DHCEQFunds(CAFundsRowID)),"^",10)="Y"
    .s TFundsRowID=""  //Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
    .s FTypeDR=$p($g(^DHCEQFunds(CAFundsRowID)),"^",2)  ;FundsType
    .s PLIST(3)=FTypeDR ;FundsType
    .//Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
    .s FinaceItemDR = $Piece($Get(^DHCEQFunds(CAFundsRowID)),"^",20)    
    .s FunctionCatDR = $Piece($Get(^DHCEQFunds(CAFundsRowID)),"^",21)
    .s EQFundsRowID=0
    .f  s EQFundsRowID=$o(^DHCEQFunds("0","Source","1",ChangeEquipDR,EQFundsRowID))  q:((EQFundsRowID="")||(SQLCODE'=0))  d
    ..q:$p($g(^DHCEQFunds(EQFundsRowID)),"^",10)="Y"
    ..q:FTypeDR'=$p($g(^DHCEQFunds(EQFundsRowID)),"^",2)
    ..q:FinaceItemDR'=$Piece($Get(^DHCEQFunds(EQFundsRowID)),"^",20)
    ..q:FunctionCatDR'=$Piece($Get(^DHCEQFunds(EQFundsRowID)),"^",21)
    ..s TFundsRowID=EQFundsRowID
    ..  
    .//End By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
    .Set TFee=+$Piece($Get(^DHCEQFunds(CAFundsRowID)),"^",3)    ;Mozy0077   2012-2-22   调账审核时更新设备资金来源信息取值错误
    .Set TDepreTotalFee=+$Piece($Get(^DHCEQFunds(CAFundsRowID)),"^",13)     ///Mozy0148
    .;Modify by zx 2020-02-24 调整错误修复
    .i TFundsRowID'=""  d
    ..Set TFee=+$Piece($Get(^DHCEQFunds(TFundsRowID)),"^",3)+TFee
    ..Set TDepreTotalFee=+$p($g(^DHCEQFunds(TFundsRowID)),"^",13)+TDepreTotalFee
    .i TFee<0 s SQLCODE=-3001
    .q:SQLCODE'=0
    .s PLIST(4)=TFee
    .Set PLIST(14)=TDepreTotalFee           ///Mozy0148
    .Set PLIST(21) =FinaceItemDR    //Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
    .Set PLIST(22) =FunctionCatDR   //Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
    .i TFundsRowID'=""  d
    ..&SQL(Update SQLUSER.DHC_EQFunds Values :PLIST() where F_RowID = :TFundsRowID)
    .e  d
    ..&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLIST())
    if SQLCODE 
    {
        TRollback
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    }
    
    ;Mozy0088   2012-9-10   在进行调账后按资金比例重新均分各资金来源的累计折旧
    ;当进行增值和减值调账后,各资金来源的累计折旧会增多和减少一部分
    If (ChangeFee=0)&(CADepreTotal=0)
    {
        Set FundsRowID=0
        For  Set FundsRowID=$Order(^DHCEQFunds("0","Equip",ChangeEquipDR,FundsRowID)) Quit:((FundsRowID="")||(SQLCODE'=0))  Do
        .Quit:$Piece($Get(^DHCEQFunds(FundsRowID)),"^",10)="Y"
        .Set TFee=+$Piece($Get(^DHCEQFunds(FundsRowID)),"^",3)
        .Set TDepreTotalFee=+$Piece($Get(^DHCEQFunds(FundsRowID)),"^",13)
        .Set ChangeDepreTotalFee=TFee*EQDepreTotalFee/OriginalFee
        .Set ChangeDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(ChangeDepreTotalFee,"",2)
        .s FinaceItemDR=$Piece($Get(^DHCEQFunds(FundsRowID)),"^",20)   //Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
        .s FunctionCatDR=$Piece($Get(^DHCEQFunds(FundsRowID)),"^",21)  //Add By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
        .;存储变动的累计折旧值
        .Set FTypeDR=$Piece($Get(^DHCEQFunds(FundsRowID)),"^",2)
        .Set id=""
        .//Modified By QW 20190410 BUG:QW0027 资金来源核算项目及功能分类
        .&SQL(Select f_rowid into :id from SQLUSER.DHC_EQFunds where F_FundsTypeDR=:FTypeDR and F_SourceType=7 and F_SourceID=:rowid and F_Hold4=:FinaceItemDR and F_Hold5=:FunctionCatDR)
        .If (SQLCODE=100) Set SQLCODE=0
        .If (id'="") Do
        ..Set ChangeDepreTotalFee=+$Piece($Get(^DHCEQFunds(id)),"^",13)
        ..If (ChangeDepreTotalFee=0) Do
        ...;调整资金来源
        ...Set TFee=+$Piece($Get(^DHCEQFunds(FundsRowID)),"^",3)
        ...Set TDepreTotalFee=+$Piece($Get(^DHCEQFunds(FundsRowID)),"^",13)
        ...Set ChangeDepreTotalFee=TFee*EQDepreTotalFee/OriginalFee
        ...Set ChangeDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(ChangeDepreTotalFee,"",2)
        ...
        ...Set Fee=ChangeDepreTotalFee-TDepreTotalFee
        ...&SQL(Update SQLUSER.DHC_EQFunds Set F_DepreTotal=:Fee where F_RowID = :id)
        ...Quit:SQLCODE'=0
        ...&SQL(Update SQLUSER.DHC_EQFunds Set F_DepreTotal=:ChangeDepreTotalFee where F_RowID = :FundsRowID)
        
        If SQLCODE 
        {
            TRollback
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
        }
    }
    //modified by wy 2021-3-4 更新调账计算方式 WY0085
    Set OriginalFee=OriginalFee+ChangeFee
    Set DepreTotal=EQDepreTotalFee+CADepreTotal
    Set NetFee=OriginalFee-DepreTotal
    Set NetRemainFee=##Class(web.DHCEQCommon).FormatNumber(OriginalFee*RemainFeeRate/100,"",2)  //2014-12-16 DJ DJ0131
    i (NetFee<0)||(OriginalFee<0)||(DepreTotal<0) s SQLCODE=-3004
    If SQLCODE 
     {
            TRollback
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
     }
    ;Modified by JDL 2011-6-17 JDL0084
    &SQL(Update SQLUSER.DHC_EQChangeAccount set CA_Status=2,CA_AuditUserDR=:user,CA_AuditDate=:updDate,CA_AuditTime=:updTime,CA_Hold1=:EQStatus where CA_RowID = :rowid)
    if SQLCODE 
    {
        TRollback
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    }
    
    
    /**************************************************************/ //2009-08-10 党军 begin DJ0023
    s LI(2)=ChangeEquipDR  //设备
    s LI(4)=$p($g(^DHCEQEquip(LI(2))),"^",19)   //原使用科室
    s LI(5)=$p($g(^DHCEQEquip(LI(2))),"^",17) //原管理科室
    s LI(6)=$p($g(^DHCEQEquip(LI(2))),"^",67)  //原库房
    s LI(7)=$p($g(^DHCEQEquip(LI(2))),"^",27)  //原值
    s LI(8)=$p($g(^DHCEQEquip(LI(2))),"^",28)  //原净值
    s LI(14)=$p($g(^DHCEQChangeAccount(rowid)),"^",8)  //变动原因
    s LI(15)=$p($g(^DHCEQChangeAccount(rowid)),"^",6)  //变动描述
    s LI(16)=updDate    //变动日期
    s LI(17)=updTime    //变动时间
    s LI(19)="C"    //生命周期类型
    s LI(20)=51 //来源类型
    s LI(21)=rowid  //来源ID
    s LI(23)=$p($g(^DHCEQChangeAccount(rowid)),"^",10)  //备注
    s LI(27)=user   //更新人
    s LI(28)=updDate    //更新日期
    s LI(29)=updTime    //更新时间
    /**************************************************************/
    //2014-12-16 DJ DJ0131
    &SQL(Update SQLUSER.DHC_EQEquip set EQ_NetFee=:NetFee,EQ_OriginalFee=:OriginalFee,EQ_NetRemainFee=:NetRemainFee,EQ_DepreTotalFee=:DepreTotal where EQ_RowID = :ChangeEquipDR)
    if SQLCODE 
    {
        TRollback
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    }
    /**************************************************************/
    s LI(9)=$p($g(^DHCEQEquip(LI(2))),"^",19)   //变动后使用科室
    s LI(10)=$p($g(^DHCEQEquip(LI(2))),"^",17) //变动后管理科室
    s LI(11)=$p($g(^DHCEQEquip(LI(2))),"^",67)  //变动后库房
    s LI(12)=$p($g(^DHCEQEquip(LI(2))),"^",27)  //变动后原值
    s LI(13)=$p($g(^DHCEQEquip(LI(2))),"^",28)  //变动后净值
    &sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
    ///Mozy0148
    if SQLCODE
    {
        TRollBack
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    }
    
    Set DepreSetID=$Order(^DHCEQDepreSet(0,"Source",1,0,ChangeEquipDR,0))
    Set DSDepreTotalFee=CADepreTotal+$Piece($Get(^DHCEQDepreSet(DepreSetID)),"^",23)
    &SQL(update sqluser.DHC_EQDepreSet set DS_DepreTotalFee=:DSDepreTotalFee where DS_RowID=:DepreSetID)
    if SQLCODE
    {
        TRollBack
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    }
    ;Mozy0089   2012-10-17
    Set SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(7, rowid)
    If SQLCODE
    {
        TRollBack
        Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
    }
    TCommit
    q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,rowid)

ERRORAudit
    TROLLBACK       // MZY0159	3500357		2023-05-06
    s ErrorMsg=$ZE
    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ErrorMsg)
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSChangeAccount","ChangeAccountAffix","3","5","")
Query ChangeAccountAffix(EquipDR As %Library.String = "", ChangeAccountDR As %Library.String = "", CAAffixIDS As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TProvider:%String,TOtherInfo:%String")
{
}

ClassMethod ChangeAccountAffixExecute(ByRef qHandle As %Binary, EquipDR As %Library.String = "", ChangeAccountDR As %Library.String = "", CAAffixIDS As %Library.String = "") As %Status
{
    new repid, index, rowid
    Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s index=1
    i EquipDR="" Quit $$$OK
    s rowid=0
    f  s rowid=$o(^DHCEQAffix(0,"Equip",EquipDR,rowid))  quit:rowid=""  d
    .s AffixData=$g(^DHCEQAffix(rowid))
    .q:$p(AffixData,"^",15)="Y"    //InvalidFlag
    .s TRowID=rowid
    .s CARowAddID=$p(AffixData,"^",22)
    .s CARowReduceID=$p(AffixData,"^",23)
    .q:(ChangeAccountDR'="")&&(((CARowAddID'="")&&(ChangeAccountDR'=CARowAddID))||((CARowReduceID'="")&&(ChangeAccountDR'=CARowReduceID)))
    .s TName=$p(AffixData,"^",4)
    .s TModel=$p(AffixData,"^",5)
    .s TManuFacturer=##class(web.DHCEQCommon).GetTrakNameByID("manufacture",$p(AffixData,"^",6))    //modified by myl 20210917 1875522     
    .s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",$p(AffixData,"^",13))
    .s TLeaveFactoryNo=$p(AffixData,"^",9)
    .i $d(^DHCEQAffix(rowid,"EX")) s TLeaveFactoryNo=$g(^DHCEQAffix(rowid,"EX"))    //Add By DJ 2016-11-30
    .s TPrice=$p(AffixData,"^",11)
    .s TNum=$p(AffixData,"^",7)
    .s TAmount=##Class(web.DHCEQCommon).FormatNumber(TPrice*TNum,"",2)
    .s TRemark=$p(AffixData,"^",12)
    .s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",$p(AffixData,"^",24))
    .s TOtherInfo=TModel_","_TManuFacturer_","_TLeaveFactoryNo_","_TNum_","_TUnit_","_TPrice
    .d OutputRowGetChangeAccountAffix
    Quit $$$OK
    
OutputRowGetChangeAccountAffix
    s Data=$lb(TRowID,TName,TProvider,TOtherInfo)
    Set ^CacheTemp(repid,index)=Data
    Set index=index+1
    quit
}

ClassMethod ChangeAccountAffixFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ChangeAccountAffixExecute ]
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

ClassMethod ChangeAccountAffixClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ChangeAccountAffixExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
