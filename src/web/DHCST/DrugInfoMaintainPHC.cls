Import sqluser

Class web.DHCST.DrugInfoMaintainPHC Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   增加药学项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-16
/// Table:PHC_DrgMast,PHC_DrgForm
/// Input:代码^描述^剂型id^基本单位id^用法id^疗程id^基本数量^产地id^管制分类id
/// ^频次id^医保类别^处方通用名^药学分类id^药学子类id^药学小类id^英文国际非专利药名
/// ^国际专利药名^商品名^制剂通用名^原料通用名^类组类型^住院按一天量计算^门诊按一天量计算^门诊皮试用原液
/// ^住院皮试用原液^DDD值
/// Output:     
/// Return：药学项子表rowid
ClassMethod PHCAdd(listData) As %Library.String
{
    n (listData)
    q:listData="" ""
    s PhcCode=$p(listData,"^",1)
    s PhcDesc=$p(listData,"^",2)
    s FormId=$p(listData,"^",3)
    s BuomId=$p(listData,"^",4)
    s InstId=$p(listData,"^",5)
    s DuraId=$p(listData,"^",6)
    s BQty=$p(listData,"^",7)
    s ManfId=$p(listData,"^",8)
    s PoisonId=$p(listData,"^",9)           ;管制分类
    s FreqId=$p(listData,"^",10)
    s OfficalCode=$p(listData,"^",11)
    s Generic=$p(listData,"^",12)
    s PhcCatId=$p(listData,"^",13)
    s PhcSubCatId=$p(listData,"^",14)
    s PhcMinCatId=$p(listData,"^",15)
    s EngName1=$p(listData,"^",16)          ;英文国际非专利药名
    s EngName2=$p(listData,"^",17)          ;国际专利药名
    s LabelName2=EngName1_"||"_EngName2
    s GoodName=$p(listData,"^",18)
    s FregenName=$p(listData,"^",19)        ;制剂通用名
    s FregenName2=$p(listData,"^",20)       ;原料通用名
    s StkType=$p(listData,"^",21)           ;类组类型
    s IpOneDay=$p(listData,"^",22)          ;住院一天量
    s OpOneDay=$p(listData,"^",23)          ;门诊一天量
    s OpSkin=$p(listData,"^",24)            ;门诊皮试用原液
    s IpSkin=$p(listData,"^",25)            ;住院皮试用原液
    s DDD=$p(listData,"^",26)               ;DDD值
    s DateFrom=+$h                          ;开始日期
    ;
    ;不能为空项
    q:PhcCode="" -21
    q:PhcDesc="" -22
    q:FormId="" -23
    q:BuomId="" -24
    q:InstId="" -25
    ;
    s ResultString=""
    i PhcSubCatId'=""  d
    .i '$d(^PHCC(+PhcSubCatId,"SC",$p(PhcSubCatId,"||",2))) d
    ..s ResultString=-1
    q:ResultString'="" ResultString             ;无效的药学子分类
    ;
    i PhcMinCatId'=""  d
    .i '$d(^PHCC(+PhcMinCatId,"SC",$p(PhcMinCatId,"||",2),"MIN",$p(PhcMinCatId,"||",3))) d
    ..s ResultString=-2
    q:ResultString'="" ResultString             ;无效的药学小分类
    ;
    i PoisonId'=""  d
    .i '$d(^PHCPO(PoisonId)) d
    ..s ResultString=-3
    q:ResultString'="" ResultString             ;无效的管制分类
    ;
    i ManfId'=""  d
    .i '$d(^PHMNF(ManfId)) d
    ..s ResultString=-4
    q:ResultString'="" ResultString             ;无效的产地
    ;
    i Generic'=""  d
    .i '$d(^PHCGE("GE",Generic)) d
    ..s ResultString=-5
    q:ResultString'="" ResultString             ;无效的通用名
    ;
    i FormId'=""  d
    .i '$d(^PHCF(FormId)) d
    ..s ResultString=-6
    q:ResultString'="" ResultString             ;无效的剂型
    ;
    i FreqId'=""  d
    .i '$d(^PHCFR(FreqId)) d
    ..s ResultString=-7
    q:ResultString'="" ResultString             ;无效的频次
    ;
    i InstId'=""  d
    .i '$d(^PHCIN(InstId)) d
    ..s ResultString=-8
    q:ResultString'="" ResultString             ;无效的用法
    ;
    i DuraId'=""  d
    .i '$d(^PHCDU(DuraId)) d
    ..s ResultString=-9
    q:ResultString'="" ResultString             ;无效的疗程
    ;
    i BuomId'=""  d
    .i '$d(^CT("UOM",BuomId)) d
    ..s ResultString=-10
    q:ResultString'="" ResultString             ;无效的基本单位
    ;
    i $d(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(PhcCode))) d
    .s ResultString=-11
    q:ResultString'="" ResultString             ;药学项代码已经存在，不能重复
    ;
    i $d(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(PhcDesc)))  d
    .s ResultString=-12
    q:ResultString'="" ResultString             ;药学项名称已经存在，不能重复
    ;
    ;插入药学项主表
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    &sql(Insert into Phc_DrgMast(PHCD_Code,PHCD_Name,PHCD_PHCSC_DR,PHCD_PHCPO_DR,
    PHCD_PHMNF_DR,PHCD_LabelName1,PHCD_LabelName2,PHCD_Generic_DR,PHCD_OfficialCode)
    values(:PhcCode,:PhcDesc,:PhcSubCatId,:PoisonId,:ManfId,:GoodName,:LabelName2,
    :Generic,:OfficalCode))
    i SQLCODE'=0  d
    .trollback
    .s ResultString=-13   ;出入药学项主表失败
    .s ret=$$ErrorRecord^DHCSTERROR("PHCAdd:Phc_DrgMast",PhcDesc,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    s PhcdDR=$P(%ROWID,$C(1))       ;药学项主表rowid
    ;
    ;插入药学项子表
    s NameStr=FregenName_"||"_FregenName2
    ;
    &sql(Insert into Phc_DrgForm(PHCDF_PHCD_ParRef,PHCDF_PHCF_DR,PHCDF_PHCFR_DR,PHCDF_PHCIN_DR,
    PHCDF_PHCDU_DR,PHCDF_CTUOM_DR,PHCDF_BaseQty,PHCDF_DeductPartially,PHCDF_OfficialCode,
    PHCDF_DateFrom) values(:PhcdDR,:FormId,:FreqId,:InstId,:DuraId,:BuomId,:BQty,:IpOneDay,:NameStr,:DateFrom))
    i SQLCODE'=0  d
    .trollback
    .s ResultString=-14   ;插入药学项子表失败
    .s ret=$$ErrorRecord^DHCSTERROR("PHCAdd:Phc_DrgForm",PhcDesc,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    s PhcdfId=$P(%ROWID,$C(1))      ;药学项子表rowid
    ;
    ;向global存入其它值
    s PhcdfSub=$p(PhcdfId,"||",2)
    S $P(^PHCD(PhcdDR,"DF",PhcdfSub,"DHC"),"^",1)=OpOneDay
    S $P(^PHCD(PhcdDR,"DF",PhcdfSub,"DHC"),"^",2)=OpSkin
    S $P(^PHCD(PhcdDR,"DF",PhcdfSub,"DHC"),"^",3)=IpSkin
    S $P(^PHCD(PhcdDR,"DF",PhcdfSub,"DHC"),"^",5)=DDD
    tcommit
    ;
    q PhcdfId   ;返回药学项子表rowid
}

/// Descript:   修改药学项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-27
/// Table:PHC_DrgMast,PHC_DrgForm
/// Input:代码^描述^剂型id^基本单位id^用法id^疗程id^基本数量^产地id^管制分类id
/// ^频次id^医保类别^处方通用名^药学分类id^药学子类id^药学小类id^英文国际非专利药名
/// ^国际专利药名^商品名^制剂通用名^原料通用名^类组类型^住院按一天量计算^门诊按一天量计算^门诊皮试用原液
/// ^住院皮试用原液^DDD值^rowid
/// Output:     
/// Return：0,成功；错误代码
ClassMethod PHCUpd(listData) As %Library.String
{
    n (listData)
    q:listData="" 0
    s PhcCode=$p(listData,"^",1)
    s PhcDesc=$p(listData,"^",2)
    s FormId=$p(listData,"^",3)
    s BuomId=$p(listData,"^",4)
    s InstId=$p(listData,"^",5)
    s DuraId=$p(listData,"^",6)
    s BQty=$p(listData,"^",7)
    s ManfId=$p(listData,"^",8)
    s PoisonId=$p(listData,"^",9)           ;管制分类
    s FreqId=$p(listData,"^",10)
    s OfficalCode=$p(listData,"^",11)
    s Generic=$p(listData,"^",12)
    s PhcCatId=$p(listData,"^",13)
    s PhcSubCatId=$p(listData,"^",14)
    s PhcMinCatId=$p(listData,"^",15)
    s EngName1=$p(listData,"^",16)          ;英文国际非专利药名
    s EngName2=$p(listData,"^",17)          ;国际专利药名
    s LabelName2=EngName1_"||"_EngName2
    s GoodName=$p(listData,"^",18)
    s FregenName=$p(listData,"^",19)        ;制剂通用名
    s FregenName2=$p(listData,"^",20)       ;原料通用名
    s StkType=$p(listData,"^",21)           ;类组类型
    s IpOneDay=$p(listData,"^",22)          ;住院一天量
    s OpOneDay=$p(listData,"^",23)          ;门诊一天量
    s OpSkin=$p(listData,"^",24)            ;门诊皮试用原液
    s IpSkin=$p(listData,"^",25)            ;住院皮试用原液
    s DDD=$p(listData,"^",26)               ;DDD值
    s PhcdfRowid=$p(listData,"^",27)        ;药学项子表rowid
    ;
    ;不能为空项
    q:PhcCode="" -21
    q:PhcDesc="" -22
    q:FormId="" -23
    q:BuomId="" -24
    q:InstId="" -25
    q:PhcdfRowid="" -26
    ;
    s ResultString=""
    i PhcSubCatId'=""  d
    .i '$d(^PHCC(+PhcSubCatId,"SC",$p(PhcSubCatId,"||",2))) d
    ..s ResultString=-1
    q:ResultString'="" ResultString             ;无效的药学子分类
    ;
    i PhcMinCatId'=""  d
    .i '$d(^PHCC(+PhcMinCatId,"SC",$p(PhcMinCatId,"||",2),"MIN",$p(PhcMinCatId,"||",3))) d
    ..s ResultString=-2
    q:ResultString'="" ResultString             ;无效的药学小分类
    ;
    i PoisonId'=""  d
    .i '$d(^PHCPO(PoisonId)) d
    ..s ResultString=-3
    q:ResultString'="" ResultString             ;无效的管制分类
    ;
    i ManfId'=""  d
    .i '$d(^PHMNF(ManfId)) d
    ..s ResultString=-4
    q:ResultString'="" ResultString             ;无效的产地
    ;
    i Generic'=""  d
    .i '$d(^PHCGE("GE",Generic)) d
    ..s ResultString=-5
    q:ResultString'="" ResultString             ;无效的通用名
    ;
    i FormId'=""  d
    .i '$d(^PHCF(FormId)) d
    ..s ResultString=-6
    q:ResultString'="" ResultString             ;无效的剂型
    ;
    i FreqId'=""  d
    .i '$d(^PHCFR(FreqId)) d
    ..s ResultString=-7
    q:ResultString'="" ResultString             ;无效的频次
    ;
    i InstId'=""  d
    .i '$d(^PHCIN(InstId)) d
    ..s ResultString=-8
    q:ResultString'="" ResultString             ;无效的用法
    ;
    i DuraId'=""  d
    .i '$d(^PHCDU(DuraId)) d
    ..s ResultString=-9
    q:ResultString'="" ResultString             ;无效的疗程
    ;
    i BuomId'=""  d
    .i '$d(^CT("UOM",BuomId)) d
    ..s ResultString=-10
    q:ResultString'="" ResultString             ;无效的基本单位
    ;
    s OldCode=$p(^PHCD(+PhcdfRowid,1),"^",1)
    s OldDesc=$p(^PHCD(+PhcdfRowid,1),"^",2)
    i PhcCode'=OldCode  d
    .i $d(^PHCD(0,"Code",$$ALPHAUP^SSUTIL4(PhcCode))) 
    ..s ResultString=-11
    q:ResultString'="" ResultString             ;药学项代码已经存在，不能重复
    ;
    i PhcDesc'=OldDesc  d
    .i $d(^PHCD(0,"Name",$$ALPHAUP^SSUTIL4(PhcDesc)))  d
    ..s ResultString=-12
    q:ResultString'="" ResultString             ;药学项名称已经存在，不能重复
    ;
    ;更新药学项主表
    s PhcdRowid=+PhcdfRowid
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    &sql(Update Phc_DrgMast set PHCD_Code=:PhcCode,PHCD_Name=:PhcDesc,PHCD_PHCSC_DR=:PhcSubCatId,
    PHCD_PHCPO_DR=:PoisonId,PHCD_PHMNF_DR=:ManfId,PHCD_LabelName1=:GoodName,
    PHCD_LabelName2=:LabelName2,PHCD_Generic_DR=:Generic,PHCD_OfficialCode=:OfficalCode
     Where PHCD_Rowid=:PhcdRowid)
    i SQLCODE'=0  d
    .trollback
    .s ResultString=-13   ;更新药学项主表失败
    .s ret=$$ErrorRecord^DHCSTERROR("PHCUpd:Phc_DrgMast",PhcdRowid,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    ;
    ;更新药学项子表
    s NameStr=FregenName_"||"_FregenName2
    &sql(Update Phc_DrgForm set PHCDF_PHCF_DR=:FormId,PHCDF_PHCFR_DR=:FreqId,PHCDF_PHCIN_DR=:InstId,
    PHCDF_PHCDU_DR=:DuraId,PHCDF_CTUOM_DR=:BuomId,PHCDF_BaseQty=:BQty,PHCDF_DeductPartially=:IpOneDay,
    PHCDF_OfficialCode=:NameStr where PHCDF_Rowid=:PhcdfRowid)
    i SQLCODE'=0  d
    .trollback
    .s ResultString=-14   ;更新药学项子表失败
    .s ret=$$ErrorRecord^DHCSTERROR("PHCUpd:Phc_DrgForm",PhcdfRowid,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    ;
    ;向global存入其它值
    s PhcdfSub=$p(PhcdfRowid,"||",2)
    S $P(^PHCD(PhcdRowid,"DF",PhcdfSub,"DHC"),"^",1)=OpOneDay
    S $P(^PHCD(PhcdRowid,"DF",PhcdfSub,"DHC"),"^",2)=OpSkin
    S $P(^PHCD(PhcdRowid,"DF",PhcdfSub,"DHC"),"^",3)=IpSkin
    S $P(^PHCD(PhcdRowid,"DF",PhcdfSub,"DHC"),"^",5)=DDD
    tcommit
    ;
    q 0
}

/// Descript:   删除药学项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-28
/// Table:
/// Input:药学项子表rowid
/// Output:     
/// Return：0，成功；
ClassMethod PhcDelete(PhcdfRowid) As %Library.String
{
    n (PhcdfRowid)
    q:PhcdfRowid="" 0
    s Phcd=+PhcdfRowid
    s Chl=$p(PhcdfRowid,"||",2)
    q:'$d(^PHCD(Phcd)) 0
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    ;删除药学项
    &sql(Delete From PHC_DrgMast where PHCD_Rowid=:Phcd)
    i SQLCODE'=0  d
    .trollback
    .s ResultString=-1   ;删除药学项失败
    .s ret=$$ErrorRecord^DHCSTERROR("PhcDelete:PHC_DrgMast",Phcd,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    ;
    ;删除global
    k ^PHCD(Phcd,"DF",Chl,"DHC")
    tcommit         
    q 0
}

/// Descript:   查询药学项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-23
/// Table:PHC_DrgMast,PHC_DrgForm
/// Input:药学子表rowid
/// Output:     
/// Return：代码^描述^剂型id^剂型^基本单位id^基本单位^用法id^疗程id^基本数量^产地id^管制分类id
/// ^频次id^医保类别^处方通用名^药学分类id^药学子类id^药学小类id^英文国际非专利药名
/// ^国际专利药名^商品名^制剂通用名^原料通用名^住院按一天量计算^门诊按一天量计算^门诊皮试用原液
/// ^住院皮试用原液^DDD值
ClassMethod GetPhcDetailById(PhcdfId) As %Library.String
{
    n (PhcdfId)
    q:PhcdfId="" ""
    s Phcd=+PhcdfId
    s Chl=$p(PhcdfId,"||",2)
    q:Phcd="" ""
    q:Chl="" ""
    q:'$d(^PHCD(Phcd,"DF",Chl)) ""
    ;
    s PhcCode=$p(^PHCD(Phcd,1),"^",1)
    s PhcDesc=$p(^PHCD(Phcd,1),"^",2)
    s FormId=$p(^PHCD(Phcd,"DF",Chl,1),"^",1)
    s BuomId=$p(^PHCD(Phcd,"DF",Chl,2),"^",4)
    s InstrId=$p(^PHCD(Phcd,"DF",Chl,1),"^",5)
    s DuraId=$p(^PHCD(Phcd,"DF",Chl,1),"^",8)
    s BQty=$p(^PHCD(Phcd,"DF",Chl,2),"^",5)
    s ManfId=$p(^PHCD(Phcd,2),"^",4)
    s PoisonId=$p(^PHCD(Phcd,1),"^",4)
    s FreqId=$p(^PHCD(Phcd,"DF",Chl,1),"^",4)
    s OfficeCode=$p(^PHCD(Phcd,4),"^",2)        ;医保类别
    s GenericId=$p(^PHCD(Phcd,4),"^",1)
    s PhcSubCatId=$p(^PHCD(Phcd,1),"^",3)
    s PhcMinCatId=$p(^PHCD(Phcd,1),"^",6)
    s LabelName2=$p(^PHCD(Phcd,2),"^",8)
    s EngName1=$p(LabelName2,"||",1)        ;英文国际非专利药名
    s EngName2=$p(LabelName2,"||",2)        ;英文国际专利药名
    s GoodsName=$p(^PHCD(Phcd,2),"^",7)     ;商品名
    s GenName=$p(^PHCD(Phcd,"DF",Chl,3),"^",4)
    s GenName1=$p(GenName,"||",1)           ;制剂通用名
    s GenName2=$p(GenName,"||",2)           ;原料通用名
    s IpOneDay=$p($g(^PHCD(Phcd,"DF",Chl,2)),"^",6)     ;住院按一天量计算
    s OpOneDay=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",1) ;门诊按一天量计算
    s OpSkin=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",2)       ;门诊皮试用原液
    s IpSkin=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",3)       ;住院皮试用原液
    s DDD=$P($g(^PHCD(Phcd,"DF",Chl,"DHC")),"^",5)          ;DDD值
    ;
    s IpOneDay=$s(IpOneDay="Y":"true",1:"false")
    s OpOneDay=$s(OpOneDay="Y":"true",1:"false")
    s OpSkin=$s(OpSkin="Y":"true",1:"false")
    s IpSkin=$s(IpSkin="Y":"true",1:"false")
    ;
    s:FormId'="" FormDesc=$p(^PHCF(FormId),"^",2)
    s:BuomId'="" BuomDesc=$p(^CT("UOM",BuomId),"^",2)
    s:InstrId'="" InstDesc=$p(^PHCIN(InstrId),"^",2)
    s:DuraId'="" DuraDesc=$p(^PHCDU(DuraId),"^",1)
    s:ManfId'="" ManfDesc=$p(^PHMNF(ManfId),"^",2)
    s:PoisonId'="" PoisonDesc=$p(^PHCPO(PoisonId),"^",2)
    s:FreqId'="" FreqDesc=$p(^PHCFR(FreqId),"^",1)
    s:GenericId'="" GenericDesc=$p(^PHCGE("GE",GenericId),"^",2)
    s PhcCatId=+PhcSubCatId
    s:PhcCatId'="" PhcCatDesc=$p(^PHCC(PhcCatId),"^",2)
    s Sub=$p(PhcSubCatId,"||",2)
    s:(PhcCatId'="")&(Sub'="") PhcSubCatDesc=$p(^PHCC(PhcCatId,"SC",Sub),"^",2)
    s Min=$p(PhcMinCatId,"||",3)
    s:(PhcCatId'="")&(Sub'="")&(Min'="") PhcMinCatDesc=$p(^PHCC(PhcCatId,"SC",Sub,"MIN",Min),"^",2)
    ;
    s Data1=PhcCode_"^"_PhcDesc_"^"_FormId_"^"_$g(FormDesc)_"^"_BuomId_"^"_$g(BuomDesc)_"^"_InstrId
    s Data2=$g(InstDesc)_"^"_DuraId_"^"_$g(DuraDesc)_"^"_BQty_"^"_ManfId_"^"_$g(ManfDesc)_"^"_PoisonId
    s Data3=$g(PoisonDesc)_"^"_FreqId_"^"_$g(FreqDesc)_"^"_OfficeCode_"^"_GenericId_"^"_$g(GenericDesc)
    s Data4=PhcCatId_"^"_$g(PhcCatDesc)_"^"_PhcSubCatId_"^"_$g(PhcSubCatDesc)_"^"_PhcMinCatId_"^"_$g(PhcMinCatDesc)
    s Data5=EngName1_"^"_EngName2_"^"_GoodsName_"^"_GenName1_"^"_GenName2_"^"_IpOneDay_"^"_OpOneDay
    s Data6=OpSkin_"^"_IpSkin_"^"_DDD
    s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6  
    q Data
}

/// Descript:   查询等效数量
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-11
/// Table:PHC_FormDoseEquiv
/// Input:库存项id
/// Output:
/// Return：等效数量表id^等效单位id^等效单位^等效数量^默认等效数量
ClassMethod QueryFormDoseEquiv(InciId) As %Library.String
{

    n (InciId)
    q:InciId="" ""
    q:'$d(^INCI(InciId)) ""
    Set Json = ##class(Code.JsonObj).%New()
    s ArcimId=$p(^INCI(InciId,1),"^",3)
    s Sub=+ArcimId
    s Ver=$p(ArcimId,"||",2)
    q:Sub="" ""
    q:Ver="" ""
    q:'$d(^ARCIM(Sub,Ver)) ""
    s PhcdfId=$p(^ARCIM(Sub,Ver,1),"^",12)
    s PHCD=+PhcdfId
    s DF=$p(PhcdfId,"||",2)
    q:PHCD="" ""
    q:DF="" ""
    s Num=0
    s EQ=0
    f  s EQ=$o(^PHCD(PHCD,"DF",DF,"EQ",EQ))  q:EQ=""  d
    .s DoseQty=$p(^PHCD(PHCD,"DF",DF,"EQ",EQ),"^",2)
    .s DoseUomId=$p(^PHCD(PHCD,"DF",DF,"EQ",EQ),"^",1)
    .s:DoseUomId'="" DoseUomDesc=$p(^CT("UOM",DoseUomId),"^",2)
    .s DefaultDoseQty=$p(^PHCD(PHCD,"DF",DF,"EQ",EQ),"^",3)
    .s Data=PhcdfId_"||"_EQ_"^"_DoseUomId_"^"_$g(DoseUomDesc)_"^"_DoseQty_"^"_DefaultDoseQty
    .d Json.InsertRowData(Data)
    .s Num=Num+1
    .
    s DetailStr=Json.getJsonData("EQRowid^EQUomRowid^EQUom^EQQty^EQDefaultDose",Num)
    k Json 
    q DetailStr
}

/// Descript:   更新等效单位信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-11
/// Table:PHC_FormDoseEquiv
/// Input:库存项id;
/// 等效数量id^等效单位id^等效数量^默认等效数量,等效数量id^等效单位id^等效数量^默认等效数量...
/// Output:
/// Return：0,成功;错误代码
ClassMethod SaveFormDoseEquiv(InciId, ListData) As %Library.String
{
    n (InciId,ListData)
    q:InciId="" "{""success"":""false"",""info"":"""_-1_"""}" 
    q:'$d(^INCI(InciId)) "{""success"":""false"",""info"":"""_-1_"""}" 
    s ArcimId=$p(^INCI(InciId,1),"^",3)
    s Sub=+ArcimId
    s Ver=$p(ArcimId,"||",2)
    q:Sub="" "{""success"":""false"",""info"":"""_-2_"""}" 
    q:Ver="" "{""success"":""false"",""info"":"""_-2_"""}" 
    q:'$d(^ARCIM(Sub,Ver)) "{""success"":""false"",""info"":"""_-2_"""}" 
    s PhcdfId=$p(^ARCIM(Sub,Ver,1),"^",12)
    s PHCD=+PhcdfId
    s DF=$p(PhcdfId,"||",2)
    q:PHCD="" "{""success"":""false"",""info"":"""_-3_"""}" 
    q:DF="" "{""success"":""false"",""info"":"""_-3_"""}" 
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s Len=$l(ListData,rowDelim)
    s ErrData=""
    s ResultString=""
    f i=1:1:Len  d
    .s RowData=$p(ListData,rowDelim,i)
    .s EqId=$p(RowData,"^",1)
    .s EqUomId=$p(RowData,"^",2)
    .s EqQty=$p(RowData,"^",3)
    .s DefaultDoseQty=$p(RowData,"^",4)
    .
    .i EqId'=""  d
    ..&sql(Update PHC_FormDoseEquiv Set EQ_CTUOM_DR=:EqUomId,
      EQ_Qty=:EqQty,EQ_DefaultDose=:DefaultDoseQty Where EQ_Rowid=:EqId)
    ..i SQLCODE'=0  d
    ...s ErrData=ErrData_","_EqQty
    ...s ret=$$ErrorRecord^DHCSTERROR("SaveFormDoseEquiv:Update",EqUomId,SQLCODE_":"_%msg)
    .e  d
    ..;保存等效单位
    ..&sql(INSERT INTO PHC_FormDoseEquiv(EQ_ParRef,EQ_CTUOM_DR,EQ_Qty,EQ_DefaultDose)
     VALUES (:PhcdfId,:EqUomId,:EqQty,:DefaultDoseQty))
    ..i SQLCODE'=0  d
    ...s ErrData=ErrData_","_EqQty
    ...s ret=$$ErrorRecord^DHCSTERROR("SaveFormDoseEquiv:Insert",EqUomId,SQLCODE_":"_%msg)
    ..
    .
    q:ErrData'="" "{""success"":""false"",""info"":"""_ErrData_"""}" 
    q "{""success"":""true"",""info"":"""_0_"""}"
}

/// Descript:   删除等效数量
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-11
/// Table:PHC_FormDoseEquiv
/// Input:等效数量表id
/// Output:
/// Return：0,成功;错误代码
ClassMethod DeleteFormDoseEquiv(EqRowid) As %Library.String
{
    n (EqRowid)
    q:EqRowid="" "{""success"":""false"",""info"":"""_-1_"""}" 
    ;
    &sql(Delete From PHC_FormDoseEquiv Where EQ_Rowid=:EqRowid)
    i SQLCODE'=0  d
    .s ret=$$ErrorRecord^DHCSTERROR("DeleteFormDoseEquiv:",EqRowid,SQLCODE_":"_%msg)
    .
    q:SQLCODE'=0 "{""success"":""false"",""info"":"""_SQLCODE_"""}" 
    q "{""success"":""true"",""info"":"""_0_"""}"
}

}
