Import sqluser

Class web.DHCST.DrugInfoMaintainINC Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   增加库存项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-20
/// Table:INC_Itm
/// Input:医嘱项rowid^代码^描述^基本单位id^入库单位id^库存分类id^转移方式
/// ^是否要求批次^是否要求效期^别名^不可用标志
/// ^协和码^条码^更新人^售价^进价^价格生效日期^库存项id^规格
/// Output:     
/// Return：库存项rowid
ClassMethod INCIAdd(listData) As %Library.String
{
    n (listData)
    q:listData="" ""
    s ArcimId=$p(listData,"^",1)                ;医嘱项rowid
    s InciCode=$p(listData,"^",2)               ;代码
    s InciDesc=$p(listData,"^",3)               ;描述
    s BUomId=$p(listData,"^",4)                 ;基本单位id
    s PurUomId=$p(listData,"^",5)               ;入库单位id
    s StkCatId=$p(listData,"^",6)               ;库存分类id
    s TranFlag=$p(listData,"^",7)               ;转移方式
    s BatFlag=$p(listData,"^",8)                ;是否要求批次     
    s ExpireFlag=$p(listData,"^",9)             ;是否要求效期
    s AliasStr=$p(listData,"^",10)              ;别名
    s NotUseFlag=$p(listData,"^",11)            ;不可用标志
    s XieHeCode=$p(listData,"^",12)             ;协和码
    s BarCode=$p(listData,"^",13)               ;条码
    s UpdateUserId=$p(listData,"^",14)          ;更新人
    s Spec=$p(listData,"^",19)                  ;规格
    ;
    ;不能为空项
    q:InciCode="" -11
    q:InciDesc="" -12
    q:BUomId="" -13
    q:PurUomId="" -14
    q:StkCatId="" -15
    q:ArcimId="" -16
    ;
    s ResultString=""
    i StkCatId'=""  d
    .i '$d(^INC("SC",StkCatId)) d
    ..s ResultString=-1
    q:ResultString'="" ResultString             ;无效的库存分类
    ;   ;
    i ArcimId'=""  d
    .i '$d(^ARCIM(+ArcimId,$p(ArcimId,"||",2))) d
    ..s ResultString=-3
    q:ResultString'="" ResultString             ;无效的医嘱项
    ;
    i BUomId'=""  d
    .i '$d(^CT("UOM",BUomId)) d
    ..s ResultString=-4
    q:ResultString'="" ResultString             ;无效的基本单位
    ;
    i PurUomId'=""  d
    .i '$d(^CT("UOM",PurUomId)) d
    ..s ResultString=-5
    q:ResultString'="" ResultString             ;无效的入库单位
    ;
    i $d(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(InciCode)_"Z")) d
    .s ResultString=-6
    q:ResultString'="" ResultString             ;库存项代码已经存在，不能重复
    ;
    i $d(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(InciDesc)))  d
    .s ResultString=-7
    q:ResultString'="" ResultString             ;库存项名称已经存在，不能重复
    ;
    i '$d(^CT("CTCF",0,"UOM",PurUomId,BUomId))  d
    .s ResultString=-8
    q:ResultString'="" ResultString             ;基本单位和入库单位之间不存在转换关系
    ;
    s TranFlag=$$ALPHAUP^SSUTIL4(TranFlag)
    s TranFlag=$s(TranFlag["TRANS":"T",TranFlag["ISSUE":"I",TranFlag["BOTH":"B",1:"")
    ;
    s BatFlag=$$ALPHAUP^SSUTIL4(BatFlag)
    s BatFlag=$s(BatFlag="REQUIRED":"R",BatFlag="OPTIONAL":"O",BatFlag="NONREQUIRED":"N",1:"")
    ;
    s ExpireFlag=$$ALPHAUP^SSUTIL4(ExpireFlag)
    s ExpireFlag=$s(ExpireFlag="REQUIRED":"R",ExpireFlag="OPTIONAL":"O",ExpireFlag="NONREQUIRED":"N",1:"")
    s UpdateDate=+$h
    s UpdateTime=$p($h,",",2)
    ;
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    ;插入库存项主表
    &sql(Insert into INC_Itm(INCI_Code,INCI_Desc,INCI_CTUOM_DR,INCI_INCSC_DR,
    INCI_CTUOM_Purch_DR,INCI_NotUseFlag,INCI_IsTrfFlag,INCI_OriginalARCIM_DR,INCI_BatchReq,
    INCI_ExpReq,INCI_UpdateDate,INCI_UpdateTime,INCI_UpdateUser,INCI_BarCode,
    INCI_ReportingDays)
    values(:InciCode,:InciDesc,:BUomId,:StkCatId,:PurUomId,:NotUseFlag,:TranFlag,
    :ArcimId,:BatFlag,:ExpireFlag,:UpdateDate,:UpdateTime,:UpdateUserId,:BarCode,
    :XieHeCode))
    i SQLCODE'=0  d
    .trollback
    .s ResultString=-9   ;插入库存项失败
    .s ret=$$ErrorRecord^DHCSTERROR("INCIAdd:INC_Itm",InciDesc,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    s InciRowid=$P(%ROWID,$C(1))        ;库存项主表rowid
    ;
    ;保存别名
    &sql(INSERT INTO INC_alias (inca_inci_dr,inca_code,inca_desc,inca_text) VALUES (:InciRowid,:InciCode,:InciDesc,:InciCode))
    i SQLCODE'=0  d
    .trollback
    .s ResultString=-10   ;插入库存项别名失败
    .s ret=$$ErrorRecord^DHCSTERROR("INCIAdd:INC_alias",InciCode,SQLCODE_":"_%msg)
    q:ResultString'="" ResultString
    ;
    S Len=$L(AliasStr,"/")
    F ii=1:1:Len q:ResultString'=""  D
    .S AliasItm=$P(AliasStr,"/",ii)
    .q:AliasItm=""
    .&SQL(INSERT INTO INC_alias (inca_inci_dr,inca_code,inca_desc,inca_text) VALUES (:InciRowid,:InciCode,:InciDesc,:AliasItm))
    .i SQLCODE'=0  d
    ..trollback
    ..s ResultString=-10   ;插入库存项别名失败
    ..s ret=$$ErrorRecord^DHCSTERROR("INCIAdd:INC_alias",AliasItm,SQLCODE_":"_%msg)
    q:ResultString'="" ResultString
    ;保存规格
    s ret=..SaveSpec(InciRowid,Spec)
    q:ret'=0 -11   ;更新规格失败
    tcommit
    q InciRowid
}

/// Descript:更新规格
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-11
/// Table:DHC_ItmAddionInfo
/// Input:库存项id^规格
/// Output:     
/// Return：0：成功;
ClassMethod SaveSpec(InciId, Spec) As %Library.String
{
    n (InciId,Spec)
    q:InciId="" -1
    ;
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,""))
    i Info'=""  d
    .&sql(update DHC_ItmAddionInfo set INFO_Spec=:Spec where INFO_Rowid=:Info)
    e  d
    .&sql(Insert into DHC_ItmAddionInfo(INFO_Spec) values (:Spec))
    .
    q SQLCODE
}

/// Descript:   更新库存项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-27
/// Table:INC_Itm
/// Input:代码^描述^基本单位id^入库单位id^库存分类id^转移方式
/// ^是否要求批次^是否要求效期^别名^不可用标志
/// ^协和码^条码^更新人^售价^进价^价格生效日期^rowid
/// Output:     
/// Return：0：成功;
ClassMethod INCIUpd(listData) As %Library.String
{
    n (listData)
    q:listData="" 0
    s InciCode=$p(listData,"^",1)               ;代码
    s InciDesc=$p(listData,"^",2)               ;描述
    s BUomId=$p(listData,"^",3)                 ;基本单位id
    s PurUomId=$p(listData,"^",4)               ;入库单位id
    s StkCatId=$p(listData,"^",5)               ;库存分类id
    s TranFlag=$p(listData,"^",6)               ;转移方式
    s BatFlag=$p(listData,"^",7)                ;是否要求批次     
    s ExpireFlag=$p(listData,"^",8)             ;是否要求效期
    s AliasStr=$p(listData,"^",9)               ;别名
    s NotUseFlag=$p(listData,"^",10)            ;不可用标志
    s XieHeCode=$p(listData,"^",11)             ;协和码
    s BarCode=$p(listData,"^",12)               ;条码
    s UpdateUserId=$p(listData,"^",13)          ;更新人
    s IncRowid=$p(listData,"^",17)
    s Spec=$p(listData,"^",18)          
    ;
    ;不能为空项
    q:InciCode="" -11
    q:InciDesc="" -12
    q:BUomId="" -13
    q:PurUomId="" -14
    q:StkCatId="" -15
    q:IncRowid="" -16
    ;
    s ResultString=""
    i StkCatId'=""  d
    .i '$d(^INC("SC",StkCatId)) d
    ..s ResultString=-1
    q:ResultString'="" ResultString             ;无效的库存分类
    ;
    i BUomId'=""  d
    .i '$d(^CT("UOM",BUomId)) d
    ..s ResultString=-4
    q:ResultString'="" ResultString             ;无效的基本单位
    ;
    i PurUomId'=""  d
    .i '$d(^CT("UOM",PurUomId)) d
    ..s ResultString=-5
    q:ResultString'="" ResultString             ;无效的入库单位
    ;
    s OldCode=$p(^INCI(IncRowid,1),"^",1)
    s OldDesc=$p(^INCI(IncRowid,1),"^",2)
    i InciCode'=OldCode d
    .i $d(^INCI(0,"Code1",$$ALPHAUP^SSUTIL4(InciCode)_"Z")) d
    ..s ResultString=-6
    q:ResultString'="" ResultString             ;库存项代码已经存在，不能重复
    ;
    i InciDesc'=OldDesc  d
    .i $d(^INCI(0,"Desc",$$ALPHAUP^SSUTIL4(InciDesc)))  d
    ..s ResultString=-7
    q:ResultString'="" ResultString             ;库存项名称已经存在，不能重复
    ;
    i '$d(^CT("CTCF",0,"UOM",PurUomId,BUomId))  d
    .s ResultString=-8
    q:ResultString'="" ResultString             ;基本单位和入库单位之间不存在转换关系
    ;
    s TranFlag=$$ALPHAUP^SSUTIL4(TranFlag)
    s TranFlag=$s(TranFlag["TRANS":"T",TranFlag["ISSUE":"I",TranFlag["BOTH":"B",1:"")
    ;
    s BatFlag=$$ALPHAUP^SSUTIL4(BatFlag)
    s BatFlag=$s(BatFlag="REQUIRED":"R",BatFlag="OPTIONAL":"O",BatFlag="NONREQUIRED":"N",1:"")
    ;
    s ExpireFlag=$$ALPHAUP^SSUTIL4(ExpireFlag)
    s ExpireFlag=$s(ExpireFlag="REQUIRED":"R",ExpireFlag="OPTIONAL":"O",ExpireFlag="NONREQUIRED":"N",1:"")
    s UpdateDate=+$h
    s UpdateTime=$p($h,",",2)
    ;
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    ;更新库存项主表
    &sql(Update INC_Itm set INCI_Code=:InciCode,INCI_Desc=:InciDesc,INCI_CTUOM_DR=:BUomId,
    INCI_INCSC_DR=:StkCatId,INCI_CTUOM_Purch_DR=:PurUomId,INCI_NotUseFlag=:NotUseFlag,
    INCI_IsTrfFlag=:TranFlag,INCI_BatchReq=:BatFlag,INCI_ExpReq=:ExpireFlag,
    INCI_UpdateDate=:UpdateDate,INCI_UpdateTime=:UpdateTime,INCI_UpdateUser=:UpdateUserId,
    INCI_BarCode=:BarCode,INCI_ReportingDays=:XieHeCode where INCI_Rowid=:IncRowid)
    ;
    i SQLCODE'=0  d
    .trollback
    .s ResultString=-9   ;更新库存项失败
    .s ret=$$ErrorRecord^DHCSTERROR("INCIUpd:INC_Itm",IncRowid,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    ;
    s ret=..SaveSpec(IncRowid,Spec)
    q:ret'=0 -10   ;更新规格失败
    tcommit
    q 0
}

/// Descript:   删除库存项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-28
/// Table:INC_Itm
/// Input:库存项rowid
/// Output:     
/// Return：0，成功
/// -2  ;删除库存项失败
/// -3  ;删除库存项附加信息失败
/// -4  ;删除库存项别名失败
ClassMethod INCIDelete(InciRowid) As %Library.String
{
    n (InciRowid)
    q:InciRowid="" 0
    q:'$d(^INCI(InciRowid)) 0
    s ResultString=""
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    ;删除库存项
    &sql(Delete From Inc_Itm Where INCI_Rowid=:InciRowid)
    i SQLCODE'=0  d
    .trollback
    .s ResultString=-2                  ;删除库存项失败
    .s ret=$$ErrorRecord^DHCSTERROR("INCIDelete:Inc_Itm",InciRowid,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    ;
    ;删除附加信息
    s InfoRowid=$o(^DHCITMINFO(0,"INCI",InciRowid,0))
    i InfoRowid'=""  d
    .&sql(Delete From DHC_ItmAddionInfo Where INFO_Rowid=:InfoRowid)
    .i SQLCODE'=0  d
    ..trollback
    ..s ResultString=-3                 ;删除库存项附加信息失败
    ..s ret=$$ErrorRecord^DHCSTERROR("INCIDelete:DHC_ItmAddionInfo",InfoRowid,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    ;删除别名   ;
    i $d(^INCALIAS(0,"INCI",InciRowid))  d
    .&sql(Delete From INC_alias Where inca_inci_dr=:InciRowid)
    .i SQLCODE'=0  d
    ..trollback
    ..s ResultString=-4   ;删除库存项别名失败
    ..s ret=$$ErrorRecord^DHCSTERROR("INCIDelete:INC_alias",InciRowid,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    ;
    tcommit
    q 0
}

/// Descript:   保存附加信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-22
/// Table:DHC_ItmAddionInfo
/// Input:库存项id,进口标志^质量层次^处方药分类^基本药物标志^中国药典标志^临床验证用药标志
/// ^处方购药标志^质量编号^国/省别^批准文号^高值类标志^院长签字^定价类型id^最高售价^存储条件
/// ^本院药品目录^招标标志^招标进价^招标级别^招标供应商id^招标生产商id^招标配送商id^招标名称^
/// ^阳光采购标志^效期长度^物价文件号^物价文件备案时间^皮试标志^帐簿分类id^用药说明^基本药物标志2
/// ^省增补药物标志1^省增补药物标志2^药品本位码^进药依据
/// Output:     
/// Return：0,成功
ClassMethod SaveAddionInfo(InciId, listData) As %Library.String
{
    n (InciId, listData)
    q:listData="" 0
    q:InciId="" -1
    s InfoId=$o(^DHCITMINFO(0,"INCI",InciId,0))
    i InfoId=""  d
    .s ret=..InsertAddionInfo(InciId,listData)
    .i +ret>0  d
    ..s ret=0
    e  d
    .s ret=..UpdateAddionInfo(InfoId,listData)
    q ret
}

/// Descript:   增加库存项附加信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-22
/// Table:DHC_ItmAddionInfo
/// Input:库存项id,进口标志^质量层次^处方药分类^基本药物标志^中国药典标志^临床验证用药标志
/// ^处方购药标志^质量编号^国/省别^批准文号^高值类标志^院长签字^定价类型id^最高售价^存储条件
/// ^本院药品目录^招标标志^招标进价^招标级别^招标供应商id^招标生产商id^招标配送商id^招标名称^
/// ^阳光采购标志^效期长度^物价文件号^物价文件备案时间^皮试标志^帐簿分类id^用药说明^基本药物标志2
/// ^省增补药物标志1^省增补药物标志2^药品本位码^进药依据^规格
/// Output:     
/// Return：附加表rowid
ClassMethod InsertAddionInfo(InciId, listData) As %Library.String
{
    n (InciId,listData)
    q:InciId="" ""
    s ImpFlag=$p(listData,"^",1)                ;进口标志
    s QualityLev=$p(listData,"^",2)             ;质量层次
    s OTC=$p(listData,"^",3)                    ;处方药分类
    s BasicDrug=$p(listData,"^",4)              ;基本药物标志
    s CodeX=$p(listData,"^",5)                  ;中国药典标志
    s TestFlag=$p(listData,"^",6)               ;临床验证用药标志
    s RecFlag=$p(listData,"^",7)                ;处方购药标志 
    s QualityNo=$p(listData,"^",8)              ;质量编号
    s ComFrom=$p(listData,"^",9)                ;国/省别
    s BatNo=$p(listData,"^",10)                 ;批准文号
    s HighPrice=$p(listData,"^",11)             ;高值类标志
    s BackUp=$p(listData,"^",12)                ;院长签字
    s MarkTypeDr=$p(listData,"^",13)            ;定价类型id
    s MaxSp=$p(listData,"^",14)                 ;最高售价
    s StoreCon=$p(listData,"^",15)              ;存储条件
    s InHosFlag=$p(listData,"^",16)             ;本院药品目录
    s PbFlag=$p(listData,"^",17)                ;招标标志
    s PbRp=$p(listData,"^",18)                  ;招标进价
    s PbLevel=$p(listData,"^",19)               ;招标级别
    s PbVendorId=$p(listData,"^",20)            ;招标供应商id
    s PbManfId=$p(listData,"^",21)              ;招标生产商id
    s PbCarriorId=$p(listData,"^",22)           ;招标配送商id
    s PbLDr=$p(listData,"^",23)                 ;招标名称,DHC_PublicBiddingList
    s BaFlag=$p(listData,"^",24)                ;阳光采购标志
    s ExpireLen=$p(listData,"^",25)             ;效期长度
    s PrcFile=$p(listData,"^",26)               ;物价文件号
    s PrcFileDate=$p(listData,"^",27)           ;物价文件备案时间
    s SkinFlag=$p(listData,"^",28)              ;皮试标志
    s BookCatId=$p(listData,"^",29)             ;帐簿分类id
    s DrugUse=$p(listData,"^",30)               ;用药说明
    s BasicDrug2=$p(listData,"^",31)            ;基本药物标志2
    s PDrugBase1=$p(listData,"^",32)            ;省增补药物标志1
    s PDrugBase2=$p(listData,"^",33)            ;省增补药物标志2
    s StanderCode=$p(listData,"^",34)           ;药品本位码
    s InMedBasis=$p(listData,"^",35)            ;进药依据
    ;
    i BasicDrug="true"  d
    .s BasicDrug="Y"
    e  d
    .s BasicDrug="N"
    ;
    ;CodeX
    i CodeX="true"  d
    .s CodeX="Y"
    e  d
    .s CodeX="N"
    ;
    i TestFlag="true"  d
    .s TestFlag="Y"
    e  d
    .s TestFlag="N"
    ;RecFlag
    i RecFlag="true"  d
    .s RecFlag="Y"
    e  d
    .s RecFlag="N"
    ;HighPrice
    i HighPrice="true"  d
    .s HighPrice="Y"
    e  d
    .s HighPrice="N"
    ;BackUp
    i BackUp="true"  d
    .s BackUp="Y"
    e  d
    .s BackUp="N"
    ;InHosFlag
    i InHosFlag="true"  d
    .s InHosFlag="Y"
    e  d
    .s InHosFlag="N"
    ;BaFlag
    i BaFlag="true"  d
    .s BaFlag="Y"
    e  d
    .s BaFlag="N"
    ;
    s:PrcFileDate'="" PrcFileDate=$zdh(PrcFileDate,3)
    ;SkinFlag
    i SkinFlag="true"  d
    .s SkinFlag="Y"
    e  d
    .s SkinFlag="N"
    ;
    ;BasicDrug2
    i BasicDrug2="true"  d
    .s BasicDrug2="Y"
    e  d
    .s BasicDrug2="N"
    ;
    ;PDrugBase1
    i PDrugBase1="true"  d
    .s PDrugBase1="Y"
    e  d
    .s PDrugBase1="N"
    ;
    ;PDrugBase2
    i PDrugBase2="true"  d
    .s PDrugBase2="Y"
    e  d
    .s PDrugBase2="N"
    ;
    ;插入库存项附加表
    &sql(Insert into DHC_ItmAddionInfo(INFO_INCI_DR,INFO_ImportFlag,INFO_QualityLevel,INFO_BasicDrug,
    INFO_OTC,INFO_Codex,INFO_Test,INFO_REC,INFO_QualityNo,INFO_ComFrom,INFO_Remark,INFO_HighPrice,
    INFO_BackUp,INFO_MT_DR,INFO_MaxSp,INFO_InHos_Flag,INFO_PbRp,INFO_PBL_DR,INFO_PbVendor_DR,
    INFO_PbManf_DR,INFO_PbCarrier_DR,INFO_ISC_DR,INFO_BA_flag,INFO_PBLevel,INFO_ExpireLen,
    INFO_PrcFile,INFO_PrcFileD,INFO_SkinTest,INFO_BC_Dr,INFO_DrugUse,INFO_Drugbase2,INFO_PDrugbase1,
    INFO_PDrugbase2,INFO_StandardCode,INFO_InMedBasis)
    values(:InciId,:ImpFlag,:QualityLev,:BasicDrug,:OTC,:CodeX,:TestFlag,:RecFlag,:QualityNo,
    :ComFrom,:BatNo,:HighPrice,:BackUp,:MarkTypeDr,:MaxSp,:InHosFlag,:PbRp,:PbLDr,:PbVendorId,
    :PbManfId,:PbCarriorId,:StoreCon,:BaFlag,:PbLevel,:ExpireLen,:PrcFile,:PrcFileDate,
    :SkinFlag,:BookCatId,:DrugUse,:BasicDrug2,:PDrugBase1,:PDrugBase2,:StanderCode,:InMedBasis))
    i SQLCODE'=0  d
    .s ResultString=-10   ;插入库存项附加表失败
    .s ret=$$ErrorRecord^DHCSTERROR("InsertAddionInfo:",InciId,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    s InfoId=$P(%ROWID,$C(1))       ;库存项附加表rowid
    q InfoId
}

/// Descript:   修改库存项附加信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-22
/// Table:DHC_ItmAddionInfo
/// Input:库存项id,进口标志^质量层次^处方药分类^基本药物标志^中国药典标志^临床验证用药标志
/// ^处方购药标志^质量编号^国/省别^批准文号^高值类标志^院长签字^定价类型id^最高售价^存储条件
/// ^本院药品目录^招标标志^招标进价^招标级别^招标供应商id^招标生产商id^招标配送商id^招标名称^
/// ^阳光采购标志^效期长度^物价文件号^物价文件备案时间^皮试标志^帐簿分类id^用药说明^基本药物标志2
/// ^省增补药物标志1^省增补药物标志2^药品本位码^进药依据
/// Output:     
/// Return：附加表rowid
ClassMethod UpdateAddionInfo(InfoId, listData) As %Library.String
{
    n (InfoId,listData)
    q:InfoId="" ""
    s ImpFlag=$p(listData,"^",1)                ;进口标志
    s QualityLev=$p(listData,"^",2)             ;质量层次
    s OTC=$p(listData,"^",3)                    ;处方药分类
    s BasicDrug=$p(listData,"^",4)              ;基本药物标志
    s CodeX=$p(listData,"^",5)                  ;中国药典标志
    s TestFlag=$p(listData,"^",6)               ;临床验证用药标志
    s RecFlag=$p(listData,"^",7)                ;处方购药标志 
    s QualityNo=$p(listData,"^",8)              ;质量编号
    s ComFrom=$p(listData,"^",9)                ;国/省别
    s BatNo=$p(listData,"^",10)                 ;批准文号
    s HighPrice=$p(listData,"^",11)             ;高值类标志
    s BackUp=$p(listData,"^",12)                ;院长签字
    s MarkTypeDr=$p(listData,"^",13)            ;定价类型id
    s MaxSp=$p(listData,"^",14)                 ;最高售价
    s StoreCon=$p(listData,"^",15)              ;存储条件
    s InHosFlag=$p(listData,"^",16)             ;本院药品目录
    s PbFlag=$p(listData,"^",17)                ;招标标志
    s PbRp=$p(listData,"^",18)                  ;招标进价
    s PbLevel=$p(listData,"^",19)               ;招标级别
    s PbVendorId=$p(listData,"^",20)            ;招标供应商id
    s PbManfId=$p(listData,"^",21)              ;招标生产商id
    s PbCarriorId=$p(listData,"^",22)           ;招标配送商id
    s PbLDr=$p(listData,"^",23)                 ;招标名称,DHC_PublicBiddingList
    s BaFlag=$p(listData,"^",24)                ;阳光采购标志
    s ExpireLen=$p(listData,"^",25)             ;效期长度
    s PrcFile=$p(listData,"^",26)               ;物价文件号
    s PrcFileDate=$p(listData,"^",27)           ;物价文件备案时间
    s SkinFlag=$p(listData,"^",28)              ;皮试标志
    s BookCatId=$p(listData,"^",29)             ;帐簿分类id
    s DrugUse=$p(listData,"^",30)               ;用药说明
    s BasicDrug2=$p(listData,"^",31)            ;基本药物标志2
    s PDrugBase1=$p(listData,"^",32)            ;省增补药物标志1
    s PDrugBase2=$p(listData,"^",33)            ;省增补药物标志2
    s StanderCode=$p(listData,"^",34)           ;药品本位码
    s InMedBasis=$p(listData,"^",35)            ;进药依据
    ;
    i CodeX="true"  d
    .s CodeX="Y"
    e  d
    .s CodeX="N"
    ;
    i BasicDrug="true"  d
    .s BasicDrug="Y"
    e  d
    .s BasicDrug="N"
    ;
    i TestFlag="true"  d
    .s TestFlag="Y"
    e  d
    .s TestFlag="N"
    ;RecFlag
    i RecFlag="true"  d
    .s RecFlag="Y"
    e  d
    .s RecFlag="N"
    ;HighPrice
    i HighPrice="true"  d
    .s HighPrice="Y"
    e  d
    .s HighPrice="N"
    ;BackUp
    i BackUp="true"  d
    .s BackUp="Y"
    e  d
    .s BackUp="N"
    ;InHosFlag
    i InHosFlag="true"  d
    .s InHosFlag="Y"
    e  d
    .s InHosFlag="N"
    ;BaFlag
    i BaFlag="true"  d
    .s BaFlag="Y"
    e  d
    .s BaFlag="N"
    ;
    s:PrcFileDate'="" PrcFileDate=$zdh(PrcFileDate,3)
    ;SkinFlag
    i SkinFlag="true"  d
    .s SkinFlag="Y"
    e  d
    .s SkinFlag="N"
    ;
    ;BasicDrug2
    i BasicDrug2="true"  d
    .s BasicDrug2="Y"
    e  d
    .s BasicDrug2="N"
    ;
    ;PDrugBase1
    i PDrugBase1="true"  d
    .s PDrugBase1="Y"
    e  d
    .s PDrugBase1="N"
    ;
    ;PDrugBase2
    i PDrugBase2="true"  d
    .s PDrugBase2="Y"
    e  d
    .s PDrugBase2="N"
    ;
    ;插入库存项附加表
    &sql(Update DHC_ItmAddionInfo set INFO_ImportFlag=:ImpFlag,INFO_QualityLevel=:QualityLev,
    INFO_BasicDrug=:BasicDrug,INFO_OTC=:OTC,INFO_Codex=:CodeX,INFO_Test=:TestFlag,
    INFO_REC=:RecFlag,INFO_QualityNo=:QualityNo,INFO_ComFrom=:ComFrom,INFO_Remark=:BatNo,
    INFO_HighPrice=:HighPrice,INFO_BackUp=:BackUp,INFO_MT_DR=:MarkTypeDr,INFO_MaxSp=:MaxSp,
    INFO_InHos_Flag=:InHosFlag,INFO_PbRp=:PbRp,INFO_PBL_DR=:PbLDr,INFO_PbVendor_DR=:PbVendorId,
    INFO_PbManf_DR=:PbManfId,INFO_PbCarrier_DR=:PbCarriorId,INFO_ISC_DR=:StoreCon,
    INFO_BA_flag=:BaFlag,INFO_PBLevel=:PbLevel,INFO_ExpireLen=:ExpireLen,INFO_PrcFile=:PrcFile,
    INFO_PrcFileD=:PrcFileDate,INFO_SkinTest=:SkinFlag,INFO_BC_Dr=:BookCatId,INFO_DrugUse=:DrugUse,
    INFO_Drugbase2=:BasicDrug2,INFO_PDrugbase1=:PDrugBase1,INFO_PDrugbase2=:PDrugBase2,
    INFO_StandardCode=:StanderCode,INFO_InMedBasis=:InMedBasis where info_rowid=:InfoId)
    i SQLCODE'=0  d
    .s ResultString=-11   ;更新库存项附加表失败
    .s ret=$$ErrorRecord^DHCSTERROR("UpdateAddionInfo:",InfoId,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    q 0
}

/// Descript:   查询库存项明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-23
/// Table:INC_Itm
/// Input:库存项id
/// Output:医嘱项rowid^代码^描述^基本单位id^基本单位^入库单位id^入库单位^库存分类id^库存分类^
/// 转移方式^是否要求批次^是否要求效期^别名^不可用标志^协和码^条码^更新人id^更新人^售价^进价
/// Return：
ClassMethod GetIncDetailById(InciId) As %Library.String
{

    n (InciId)
    q:InciId="" ""
    q:'$d(^INCI(InciId)) ""
    ;
    s ArcimId=$p(^INCI(InciId,1),"^",3)
    s InciCode=$p(^INCI(InciId,1),"^",1)
    s InciDesc=$p(^INCI(InciId,1),"^",2)
    s BuomId=$p(^INCI(InciId,1),"^",10)
    s PurUomId=$p(^INCI(InciId,3),"^",6)
    s StkCatId=$p(^INCI(InciId,2),"^",2)
    s TransFlag=$p(^INCI(InciId,2),"^",6)
    s BatReqFlag=$p(^INCI(InciId,2),"^",10)
    s ExpReqFlag=$p(^INCI(InciId,2),"^",11)
    s AliasStr=..GetIncAlias(InciId)
    s NotUseFlag=$p(^INCI(InciId,2),"^",9)
    s XieHe=$p(^INCI(InciId,3),"^",11)
    s BarCode=$p(^INCI(InciId,3),"^",9)
    s UpdUserId=$p(^INCI(InciId,3),"^",3)
    ;
    s:BuomId'="" BuomDesc=$p(^CT("UOM",BuomId),"^",2)
    s:PurUomId'="" PurUomDesc=$p(^CT("UOM",PurUomId),"^",2)
    s:StkCatId'="" StkCatDesc=$p(^INC("SC",StkCatId),"^",2)
    s:UpdUserId'="" UpdUserName=$p(^SSU("SSUSR",UpdUserId),"^",2)
    s TransFlag=$s(TransFlag["T":"TRANS",TransFlag["I":"ISSUE",TransFlag["B":"BOTH",1:"")
    s BatReqFlag=$s(BatReqFlag="R":"REQUIRED",BatReqFlag="O":"OPTIONAL",BatReqFlag="N":"NONREQUIRED",1:"")
    s ExpReqFlag=$s(ExpReqFlag="R":"REQUIRED",ExpReqFlag="O":"OPTIONAL",ExpReqFlag="N":"NONREQUIRED",1:"")
    //s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(InciId,+$h,PurUomId,"")
    //s Rp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(InciId,+$h,PurUomId,"")
    s Sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(InciId,+$h,PurUomId,"","G","")
    s Rp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(InciId,+$h,PurUomId,"","G","")
    ;
    ;Set json = ##class(Code.JsonObj).%New()
    s Data1=ArcimId_"^"_InciCode_"^"_InciDesc_"^"_BuomId_"^"_$g(BuomDesc)_"^"_PurUomId_"^"_$g(PurUomDesc)
    s Data2=StkCatId_"^"_$g(StkCatDesc)_"^"_TransFlag_"^"_BatReqFlag_"^"_ExpReqFlag_"^"_AliasStr_"^"_NotUseFlag
    s Data3=XieHe_"^"_BarCode_"^"_UpdUserId_"^"_$g(UpdUserName)_"^"_Sp_"^"_Rp
    s Data=Data1_"^"_Data2_"^"_Data3
    ;
    ;s Title1="ArcimId_^_InciCode_^_InciDesc_^_BuomId_^_BuomDesc_^_PurUomId_^_PurUomDesc"
    ;s Title2="StkCatId_^_StkCatDesc_^_TransFlag_^_BatReqFlag_^_ExpReqFlag_^_AliasStr_^_NotUseFlag"
    ;s Title3="XieHe_^_BarCode_^_UpdUserId_^_UpdUserName^Sp^Rp"
    ; 
    q Data
}

/// Descript:   查询库存项附加信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-23
/// Table:DHC_ItmAddionInfo
/// Input:库存项表rowid
/// Output:     
/// Return：进口标志^质量层次^处方药分类^基本药物标志^中国药典标志^临床验证用药标志
/// ^处方购药标志^质量编号^国/省别^批准文号^高值类标志^院长签字^定价类型id^定价类型^最高售价^存储条件
/// ^本院药品目录^招标标志^招标进价^招标级别^招标供应商id^招标生产商id^招标配送商id^招标名称^
/// ^阳光采购标志^效期长度^物价文件号^物价文件备案时间^皮试标志^帐簿分类id^用药说明^基本药物标志2
/// ^省增补药物标志1^省增补药物标志2^药品本位码^进药依据^规格
ClassMethod GetIncAddionDetail(InciId) As %Library.String
{
    n (InciId)
    q:InciId="" ""
    s Info=$o(^DHCITMINFO(0,"INCI",InciId,0))
    q:Info="" ""
    ;
    s ImpFlag=$p(^DHCITMINFO(Info),"^",2)
    s QualityLev=$p(^DHCITMINFO(Info),"^",3)
    s OTC=$p(^DHCITMINFO(Info),"^",5)               ;处方药分类
    s BasicDrug=$p(^DHCITMINFO(Info),"^",4)
    s CodeX=$p(^DHCITMINFO(Info),"^",7)
    s TestFlag=$p(^DHCITMINFO(Info),"^",6)
    s RecFlag=$p(^DHCITMINFO(Info),"^",11)
    s QualityNo=$p(^DHCITMINFO(Info),"^",8)
    s ComFrom=$p(^DHCITMINFO(Info),"^",9)
    s Remark=$p(^DHCITMINFO(Info),"^",10)
    s HighPrice=$p(^DHCITMINFO(Info),"^",12)
    s Signature=$p(^DHCITMINFO(Info),"^",13)
    s MtDr=$p(^DHCITMINFO(Info),"^",15)
    s MaxSp=$p(^DHCITMINFO(Info),"^",16)
    s StoreConId=$p(^DHCITMINFO(Info),"^",28)
    s InHosFlag=$p(^DHCITMINFO(Info),"^",21)
    ;s PbFlag=$p(^DHCITMINFO(Info),"^",3)
    s PbRp=$p(^DHCITMINFO(Info),"^",22)
    s PbLevel=$p(^DHCITMINFO(Info),"^",30)
    s PbVendorId=$p(^DHCITMINFO(Info),"^",24)
    s PbManfId=$p(^DHCITMINFO(Info),"^",25)
    s PbCarrierId=$p(^DHCITMINFO(Info),"^",26)
    s PbLDr=$p(^DHCITMINFO(Info),"^",23)        ;招标名称
    i +PbRp'=0!PbLevel'=""!PbVendorId'=""!PbManfId'=""!PbCarrierId'=""!PbLDr'="" d
    .s PbFlag="true"
    e  d
    .s PbFlag="false"
    s BaFlag=$p(^DHCITMINFO(Info),"^",29)
    s ExpireLen=$p(^DHCITMINFO(Info),"^",32)
    s PrcFile=$p(^DHCITMINFO(Info),"^",33)
    s PrcFileD=$p(^DHCITMINFO(Info),"^",34)
    s SkinFlag=$p(^DHCITMINFO(Info),"^",35)
    s BookCatId=$p(^DHCITMINFO(Info),"^",36)
    s DrugUse=$p(^DHCITMINFO(Info),"^",38)
    s BasicDrug2=$p(^DHCITMINFO(Info),"^",40)
    s PBasicDrug=$p(^DHCITMINFO(Info),"^",41)
    s PBasicDrug2=$p(^DHCITMINFO(Info),"^",42)
    s StanderCode=$p(^DHCITMINFO(Info),"^",44)
    s InMedBasis=$p(^DHCITMINFO(Info),"^",45)
    s Spec=$p(^DHCITMINFO(Info),"^",27)
    ;
    s ImpFlag=$s(ImpFlag="Y":"true",1:"false")
    s BasicDrug=$s(BasicDrug="Y":"true",1:"false")
    s CodeX=$s(CodeX="Y":"true",1:"false")
    s TestFlag=$s(TestFlag="Y":"true",1:"false")
    s RecFlag=$s(RecFlag="Y":"true",1:"false")
    s HighPrice=$s(HighPrice="Y":"true",1:"false")
    s Signature=$s(Signature="Y":"true",1:"false")
    s InHosFlag=$s(InHosFlag="Y":"true",1:"false")
    s BaFlag=$s(BaFlag="Y":"true",1:"false")
    s SkinFlag=$s(SkinFlag="Y":"true",1:"false")
    s BasicDrug2=$s(BasicDrug2="Y":"true",1:"false")
    s PBasicDrug=$s(PBasicDrug="Y":"true",1:"false")
    s PBasicDrug2=$s(PBasicDrug2="Y":"true",1:"false")
    ;
    s:MtDr'="" MtDesc=$p(^DHCINMT(MtDr),"^",2)
    s:PbVendorId'="" PbVendorDesc=$p(^APC("APCVM",PbVendorId),"^",2)
    s:PbManfId'="" PbManfDesc=$p(^PHMNF(ManfId),"^",2)
    s:PbCarrierId'="" PbCarrierDesc=$p(^DHCCARR(PbCarrierId),"^",1)
    s:PbLDr'="" PbLDesc=$p(^DHCPBLIST(PbLDr),"^",2)
    s:BookCatId'="" BookCatDesc=$p(^DHCSTBC(BookCatId),"^",2)
    //s:StoreConId'="" StoreCon=$p(^DHCItemSC(StoreConId),"^",2)
    ;
    s Data1=ImpFlag_"^"_QualityLev_"^"_OTC_"^"_BasicDrug_"^"_CodeX_"^"_TestFlag_"^"_RecFlag
    s Data2=QualityNo_"^"_ComFrom_"^"_Remark_"^"_HighPrice_"^"_Signature_"^"_MtDr_"^"_$g(MtDesc)
    s Data3=MaxSp_"^"_StoreConId_"^"_InHosFlag_"^"_PbFlag_"^"_PbRp_"^"_PbLevel
    s Data4=PbVendorId_"^"_$g(PbVendorDesc)_"^"_PbManfId_"^"_$g(PbManfDesc)_"^"_PbCarrierId_"^"_$g(PbCarrierDesc)
    s Data5=PbLDr_"^"_$g(PbLDesc)_"^"_BaFlag_"^"_ExpireLen_"^"_PrcFile_"^"_PrcFileD_"^"_SkinFlag
    s Data6=BookCatId_"^"_$g(BookCatDesc)_"^"_DrugUse_"^"_BasicDrug2_"^"_PBasicDrug_"^"_PBasicDrug2
    s Data7=StanderCode_"^"_InMedBasis_"^"_Spec
    s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6_"^"_Data7
    q Data
}

/// Descript:   查询库存项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-23
/// Table:INC_Itm
/// Input:库存项id
/// Output:别名1/别名2
/// Return：
ClassMethod GetIncAlias(InciId) As %Library.String
{

    n (InciId)
    q:InciId="" ""
    s AliasStr=""
    s IncaId=0
    f  s IncaId=$o(^INCALIAS(0,"INCI",InciId,IncaId))  q:IncaId=""  d
    .s Alias=$p(^INCALIAS(IncaId),"^",4)
    .q:Alias=""
    .i AliasStr=""  d
    ..s AliasStr=Alias
    .e  d
    ..s AliasStr=AliasStr_"/"_Alias
    .
    q AliasStr
}

/// Descript:   查询库存项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-09
/// Table:INC_Alias
/// Input:库存项id
/// Output:
/// Return：库存项别名
ClassMethod GetAliasForInc(InciId) As %Library.String
{

    n (InciId)
    q:InciId="" ""
    Set Json = ##class(Code.JsonObj).%New()
    s Num=0
    s IncaId=0
    f  s IncaId=$o(^INCALIAS(0,"INCI",InciId,IncaId))  q:IncaId=""  d
    .s Alias=$p(^INCALIAS(IncaId),"^",4)
    .s Data=IncaId_"^"_Alias
    .d Json.InsertRowData(Data)
    .s Num=Num+1
    .
    s DetailStr=Json.getJsonData("INCARowid^INCAText",Num)
    k Json 
    q DetailStr
}

/// Descript:   增加库存项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-09
/// Table:INC_Alias
/// Input:库存项id,别名id^别名,别名id2^别名2...
/// Output:
/// Return：0,成功;错误代码
ClassMethod SaveAliasForInc(InciId, ListData) As %Library.String
{
    n (InciId,ListData)
    q:InciId="" "{""success"":""false"",""info"":"""_-1_"""}" 
    q:'$d(^INCI(InciId)) "{""success"":""false"",""info"":"""_-2_"""}" 
    s ItmCode=$p(^INCI(InciId,1),"^",1)
    s ItmDesc=$p(^INCI(InciId,1),"^",2)
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s Len=$l(ListData,rowDelim)
    s ErrData=""
    s ResultString=""
    f i=1:1:Len  d
    .s RowData=$p(ListData,rowDelim,i)
    .s IncaId=$p(RowData,"^",1)
    .s Alias=$p(RowData,"^",2)
    .
    .i IncaId'=""  d
    ..&sql(Update INC_alias Set inca_text=:Alias Where INCA_Rowid=:IncaId)
    ..i SQLCODE'=0  d
    ...s ErrData=ErrData_","_Alias
    .e  d
    ..;保存别名
    ..&sql(INSERT INTO INC_alias (inca_inci_dr,inca_code,inca_desc,inca_text) VALUES (:InciId,:ItmCode,:ItmDesc,:Alias))
    ..i SQLCODE'=0  d
    ...s ErrData=ErrData_","_Alias
    ...s ret=$$ErrorRecord^DHCSTERROR("SaveAliasForInc:INC_alias",ItmCode,SQLCODE_":"_%msg)
    ..e  d
    ...s IncaId=$p(%ROWID,$c(1))
    ..
    .
    q:ErrData'="" "{""success"":""false"",""info"":"""_ErrData_"""}" 
    q "{""success"":""true"",""info"":"""_0_"""}"
}

/// Descript:   删除库存项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-10
/// Table:INC_Alias
/// Input:别名id
/// Output:
/// Return：0,成功;错误代码
ClassMethod DeleteAliasForInc(IncaRowid) As %Library.String
{
    n (IncaRowid)
    q:IncaRowid="" "{""success"":""false"",""info"":"""_-1_"""}" 
    ;
    &sql(Delete From INC_alias Where INCA_Rowid=:IncaRowid)
    i SQLCODE'=0  d
    .s ret=$$ErrorRecord^DHCSTERROR("DeleteAliasForInc:INC_alias",IncaRowid,SQLCODE_":"_%msg)
    .
    q:SQLCODE'=0 "{""success"":""false"",""info"":"""_SQLCODE_"""}" 
    q "{""success"":""true"",""info"":"""_0_"""}"
}

}
