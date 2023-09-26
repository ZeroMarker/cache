Import sqluser

Class web.DHCST.DrugInfoMaintainORD Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   增加医嘱项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-19
/// Table:ARC_ItmMast
/// Input:药学项子表id^代码^描述^计价单位id^医嘱子类id^费用大类id^费用子类id^独立医嘱标志
/// ^默认医嘱优先级id^无库存医嘱标志^医保名称^收费项分类串^别名^缩写
/// ^医保类别^最大量^限制使用天数^每天最大剂量^单次最大剂量^急诊用药^住院用药^门诊用药
/// ^体检用药^医嘱提示^是否维护收费项目标志^是否维护医保项目^医保项目类型
/// Output:     
/// Return：医嘱项rowid
ClassMethod OrderAdd(listData) As %Library.String
{
    n (listData)
    q:listData="" ""
    s PhcdfId=$p(listData,"^",1)                ;药学项子表id
    s ArcCode=$p(listData,"^",2)                ;代码
    s ArcDesc=$p(listData,"^",3)                ;描述
    s BillUomId=$p(listData,"^",4)              ;计价单位id
    s ArcSubCatId=$p(listData,"^",5)            ;医嘱子类id
    s BillCatId=$p(listData,"^",6)              ;费用大类id
    s BillSubCatId=$p(listData,"^",7)           ;费用子类id
    s OwnFlag=$p(listData,"^",8)                ;独立医嘱标志
    s PriorId=$p(listData,"^",9)                ;默认医嘱优先级id      
    s WoStock=$p(listData,"^",10)               ;无库存医嘱标志
    s InsuDesc=$p(listData,"^",11)              ;医保名称
    s TarCatStr=$p(listData,"^",12)             ;收费项分类串
    s AliasStr=$p(listData,"^",13)              ;别名
    s SX=$p(listData,"^",14)                    ;缩写
    s InsuType=$p(listData,"^",15)              ;医保类别
    s MaxQty=$p(listData,"^",16)                ;最大量
    s NoOfCumDays=$p(listData,"^",17)           ;限制使用天数
    s MaxQtyPerDay=$p(listData,"^",18)          ;每天最大剂量
    s MaxCumDose=$p(listData,"^",19)            ;单次最大剂量
    s RestrictEM=$p(listData,"^",20)            ;急诊用药
    s RestrictIP=$p(listData,"^",21)            ;住院用药
    s RestrictOP=$p(listData,"^",22)            ;门诊用药
    s RestrictHP=$p(listData,"^",23)            ;体检用药
    s OeMessage=$p(listData,"^",24)             ;医嘱提示
    s UpdTarFlag=$P(listData,"^",25)
    S UpInsu=+$P(listData,"^",26)               ;更新医保项标志
    S InsuItmType=+$P(listData,"^",27)
    ;
    ;不能为空项
    q:ArcCode="" -11
    q:ArcDesc="" -12
    q:BillUomId="" -13
    q:BillCatId="" -14
    q:BillSubCatId="" -15
    q:ArcSubCatId="" -16
    q:PhcdfId="" -17
    ;
    s ResultString=""
    i ArcSubCatId'=""  d
    .i '$d(^ARC("IC",ArcSubCatId)) d
    ..s ResultString=-1
    q:ResultString'="" ResultString             ;无效的医嘱子分类
    ;
    i BillCatId'=""  d
    .i '$d(^ARCBG(BillCatId)) d
    ..s ResultString=-2
    q:ResultString'="" ResultString             ;无效的费用大类
    ;
    i BillSubCatId'=""  d
    .i '$d(^ARCBG(+BillSubCatId,"SG",$p(BillSubCatId,"||",2))) d
    ..s ResultString=-3
    q:ResultString'="" ResultString             ;无效的费用子类
    ;
    i PriorId'=""  d
    .i '$d(^OECPR(PriorId)) d
    ..s ResultString=-4
    q:ResultString'="" ResultString             ;无效的医嘱优先级
    ;
    i PhcdfId'=""  d
    .i '$d(^PHCD(+PhcdfId,"DF",$p(PhcdfId,"||",2))) d
    ..s ResultString=-5
    q:ResultString'="" ResultString             ;无效的药学项
    ;
    i BillUomId'=""  d
    .i '$d(^CT("UOM",BillUomId)) d
    ..s ResultString=-6
    q:ResultString'="" ResultString             ;无效的计价单位
    ;
    i $d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode))) d
    .s ResultString=-7
    q:ResultString'="" ResultString             ;医嘱项代码已经存在，不能重复
    ;
    i $d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(ArcDesc)))  d
    .s ResultString=-8
    q:ResultString'="" ResultString             ;医嘱项名称已经存在，不能重复
    ;
    ;
    i SX=""  d
    .s SX=$e(ArcDesc,1,$f(ArcDesc,"-")-2)
    s:SX="" SX="None"
    ;
    ;
    s EffDate=+$h
    s EffTime=$p($h,",",2)
    s EffDateTime=$h
    ;
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    ;插入医嘱项主表
    &sql(Insert into Arc_ItmMast(ARCIM_Code,ARCIM_Desc,ARCIM_Abbrev,ARCIM_ItemCat_DR,
    ARCIM_BillSub_DR,ARCIM_PHCDF_DR,ARCIM_EffDate,ARCIM_EffTime,ARCIM_EffDateTime,
    ARCIM_OrderOnItsOwn,ARCIM_AllowOrderWOStockCheck,ARCIM_BillingUOM_DR,
    ARCIM_DefPriority_DR,ARCIM_MaxCumDose,ARCIM_NoOfCumDays,ARCIM_Text1,ARCIM_MaxQtyPerDay,
    ARCIM_MaxQty,ARCIM_RestrictEM,ARCIM_RestrictIP,ARCIM_RestrictOP,ARCIM_RestrictHP)
    values(:ArcCode,:ArcDesc,:SX,:ArcSubCatId,:BillSubCatId,:PhcdfId,:EffDate,
    :EffTime,:EffDateTime,:OwnFlag,:WoStock,:BillUomId,:PriorId,:MaxCumDose,
    :NoOfCumDays,:InsuDesc,:MaxQtyPerDay,:MaxQty,:RestrictEM,:RestrictIP,:RestrictOP,
    :RestrictHP))
    b
    i SQLCODE'=0  d
    .trollback
    .s ResultString=-21   ;插入医嘱项主表失败
    .s ret=$$ErrorRecord^DHCSTERROR("OrderAdd:Arc_ItmMast",ArcDesc,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    s ArcimId=$P(%ROWID,$C(1))      ;医嘱项主表rowid
    ;
    ;医嘱提示不能用sql更新
    s Sub=+ArcimId
    s Ver=$p(ArcimId,"||",2)
    s ^ARCIM(Sub,Ver,"OEM",0)=1
    s ^ARCIM(Sub,Ver,"OEM",1)=OeMessage
    ;保存DHC_ItmMast
    &SQL(INSERT INTO DHC_ItmMast(DARCIM_ARCIM_DR,DARCIM_MaxQty) Values(:ArcimId,:MaxQty))
    i SQLCODE'=0  d
    .trollback
    .s ResultString=-22   ;插入医嘱项主表失败
    .s ret=$$ErrorRecord^DHCSTERROR("OrderAdd:DHC_ItmMast",ArcDesc,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    ;
    ;保存别名
    s TarAlias=""
    s Len=$L(AliasStr,"/")
    f ii=1:1:Len  q:ResultString'=""  d
    .s AliasItm=$P(AliasStr,"/",ii)
    .q:AliasItm=""
    .i TarAlias="" d
    ..s TarAlias=AliasItm
    .e  d
    ..s TarAlias=TarAlias_"/"_AliasItm
    .
    .&SQL(INSERT INTO ARC_Alias (ALIAS_ARCIM_DR,ALIAS_Text ) VALUES (:ArcimId,:AliasItm))
    .i SQLCODE'=0  d
    ..trollback
    ..s ResultString=-23  ;插入医嘱项别名失败
    ..s ret=$$ErrorRecord^DHCSTERROR("OrderAdd:ARC_Alias",AliasItm,SQLCODE_":"_%msg)
    q:ResultString'="" ResultString
    ;
    ;需要保存收费项的话更新收费项
    i UpdTarFlag=0 d      ; allow insert tar item
    .;收费项目分类串2007-03-17
    .;s err=$$InsertTarItem^DHCSTJFTARITEM(arcim)
    .ZN "DHC-DATA"  //"MEDDATA"
    .s err=$$AddTarItem^DHCSTJFTARITEM(ArcimId,TarCatStr)
    .s:err'=0 ResultString=err   ;插入收费项失败
    .q:err'=0
    .
    .S TariId=$O(^DHCOLT(0,"ARTTA",ArcimId,""))
    .s err2=$$UpdTarItmExCode^DHCSTJFTARITEM(ArcimId,InsuDesc)  ; 更新医保名称
    .s err3=$$InsertTarAlias^DHCSTJFTARITEM(ArcimId,TarAlias)  ;生成收费项别名
    .ZN "DHC-APP"   //"MEDDATA"
    .///更改医保项 珠海 20090702 zhouyg
    .i (UpInsu=1)&(TariId'="")  d
    ..S InsuString=""_"^"_ArcCode_"^"_ArcDesc_"^"_TarAlias_"^"_InsuItmType_"^"_InsuType_"^"_TariId
    ..S RetInsu=##class(web.DHCINSUPort).AddINSUInfo(InsuString)
    .
    .
    tcommit         ;医嘱项增加成功后提交(不管上述医嘱项和收费项是否更新成功)
    q ArcimId   ;返回医嘱项主表rowid
}

/// Descript:   更新医嘱项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-27
/// Table:ARC_ItmMast
/// Input:代码^描述^计价单位id^医嘱子类id^费用大类id^费用子类id^独立医嘱标志
/// ^默认医嘱优先级id^无库存医嘱标志^医保名称^收费项分类串^别名^缩写
/// ^医保类别^最大量^限制使用天数^每天最大剂量^单次最大剂量^急诊用药^住院用药^门诊用药
/// ^体检用药^医嘱提示^是否维护收费项目标志^是否维护医保项目^医保项目类型^rowid
/// Output:     
/// Return：0:成功;错误代码
ClassMethod OrderUpd(listData) As %Library.String
{
    n (listData)
    q:listData="" 0
    s ArcCode=$p(listData,"^",1)                ;代码
    s ArcDesc=$p(listData,"^",2)                ;描述
    s BillUomId=$p(listData,"^",3)              ;计价单位id
    s ArcSubCatId=$p(listData,"^",4)            ;医嘱子类id
    s BillCatId=$p(listData,"^",5)              ;费用大类id
    s BillSubCatId=$p(listData,"^",6)           ;费用子类id
    s OwnFlag=$p(listData,"^",7)                ;独立医嘱标志
    s PriorId=$p(listData,"^",8)                ;默认医嘱优先级id      
    s WoStock=$p(listData,"^",9)                ;无库存医嘱标志
    s InsuDesc=$p(listData,"^",10)              ;医保名称
    s TarCatStr=$p(listData,"^",11)             ;收费项分类串
    s AliasStr=$p(listData,"^",12)              ;别名
    s SX=$p(listData,"^",13)                    ;缩写
    s InsuType=$p(listData,"^",14)              ;医保类别
    s MaxQty=$p(listData,"^",15)                ;最大量
    s NoOfCumDays=$p(listData,"^",16)           ;限制使用天数
    s MaxQtyPerDay=$p(listData,"^",17)          ;每天最大剂量
    s MaxCumDose=$p(listData,"^",18)            ;单次最大剂量
    s RestrictEM=$p(listData,"^",19)            ;急诊用药
    s RestrictIP=$p(listData,"^",20)            ;住院用药
    s RestrictOP=$p(listData,"^",21)            ;门诊用药
    s RestrictHP=$p(listData,"^",22)            ;体检用药
    s OeMessage=$p(listData,"^",23)             ;医嘱提示
    s UpdTarFlag=$P(listData,"^",24)
    S UpInsu=+$P(listData,"^",25)               ;更新医保项标志
    S InsuItmType=+$P(listData,"^",26)
    S ArcimRowid=$P(listData,"^",27)
    ;
    ;不能为空项
    q:ArcCode="" -11
    q:ArcDesc="" -12
    q:BillUomId="" -13
    q:BillCatId="" -14
    q:BillSubCatId="" -15
    q:ArcSubCatId="" -16
    q:ArcimRowid="" -17
    ;
    s ResultString=""
    i ArcSubCatId'=""  d
    .i '$d(^ARC("IC",ArcSubCatId)) d
    ..s ResultString=-1
    q:ResultString'="" ResultString             ;无效的医嘱子分类
    ;
    i BillCatId'=""  d
    .i '$d(^ARCBG(BillCatId)) d
    ..s ResultString=-2
    q:ResultString'="" ResultString             ;无效的费用大类
    ;
    i BillSubCatId'=""  d
    .i '$d(^ARCBG(+BillSubCatId,"SG",$p(BillSubCatId,"||",2))) d
    ..s ResultString=-3
    q:ResultString'="" ResultString             ;无效的费用子类
    ;
    i PriorId'=""  d
    .i '$d(^OECPR(PriorId)) d
    ..s ResultString=-4
    q:ResultString'="" ResultString             ;无效的医嘱优先级
    ;
    i BillUomId'=""  d
    .i '$d(^CT("UOM",BillUomId)) d
    ..s ResultString=-6
    q:ResultString'="" ResultString             ;无效的计价单位
    ;
    s Sub=+ArcimRowid
    s Ver=$p(ArcimRowid,"||",2)
    s OldCode=$p(^ARCIM(Sub,Ver,1),"^",1)
    s OldDesc=$p(^ARCIM(Sub,Ver,1),"^",2)
    i ArcCode'=OldCode  d
    .i $d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode))) d
    ..s ResultString=-7
    q:ResultString'="" ResultString             ;医嘱项代码已经存在，不能重复
    ;
    i ArcDesc'=OldDesc  d
    .i $d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(ArcDesc)))  d
    ..s ResultString=-8
    q:ResultString'="" ResultString             ;医嘱项名称已经存在，不能重复
    ;
    ;
    i SX=""  d
    .s SX=$e(ArcDesc,1,$f(ArcDesc,"-")-2)
    s:SX="" SX="None"
    ;
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    ;更新医嘱项主表
    &sql(Update Arc_ItmMast set ARCIM_Code=:ArcCode,ARCIM_Desc=:ArcDesc,ARCIM_Abbrev=:SX,
    ARCIM_ItemCat_DR=:ArcSubCatId,ARCIM_BillSub_DR=:BillSubCatId,ARCIM_OrderOnItsOwn=:OwnFlag,
    ARCIM_AllowOrderWOStockCheck=:WoStock,ARCIM_BillingUOM_DR=:BillUomId,
    ARCIM_DefPriority_DR=:PriorId,ARCIM_MaxCumDose=:MaxCumDose,ARCIM_NoOfCumDays=:NoOfCumDays,
    ARCIM_Text1=:InsuDesc,ARCIM_MaxQtyPerDay=:MaxQtyPerDay,ARCIM_MaxQty=:MaxQty,ARCIM_RestrictEM=:RestrictEM,ARCIM_RestrictIP=:RestrictIP,
    ARCIM_RestrictOP=:RestrictOP,ARCIM_RestrictHP=:RestrictHP where arcim_rowid=:ArcimRowid)
    i SQLCODE'=0  d
    .trollback
    .s ResultString=-21   ;更新医嘱项主表失败
    .s ret=$$ErrorRecord^DHCSTERROR("OrderUpd:Arc_ItmMast",ArcimRowid,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    ;医嘱提示不能用sql更新
    s ^ARCIM(Sub,Ver,"OEM",0)=1
    s ^ARCIM(Sub,Ver,"OEM",1)=OeMessage
    ;更新DHC_ItmMast
    i $d(^DHCItmMast("0","ARCIM",ArcimRowid))  d
    .&SQL(Update DHC_ItmMast set DARCIM_MaxQty=:MaxQty where DARCIM_ARCIM_DR=:ArcimRowid)
    e  d
    .&SQL(INSERT INTO DHC_ItmMast(DARCIM_ARCIM_DR,DARCIM_MaxQty) Values(:ArcimRowid,:MaxQty))
    i SQLCODE'=0  d
    .trollback
    .s ResultString=-22   ;更新医嘱项附加表失败
    .s ret=$$ErrorRecord^DHCSTERROR("OrderUpd:DHC_ItmMast",ArcimRowid,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    tcommit         
    q 0
}

/// Descript:   删除医嘱项信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-28
/// Table:ARC_ItmMast
/// Input:医嘱项rowid
/// Output:     
/// Return：0，成功；
ClassMethod OrderDelete(ArcimRowid) As %Library.String
{
    n (ArcimRowid)
    q:ArcimRowid="" 0
    s Sub=+ArcimRowid
    s Ver=$p(ArcimRowid,"||",2)
    q:'$d(^ARCIM(Sub,Ver)) 0
    s ResultString=""
    tstart
    s $ZT="Error^DHCSTERROR"                        ;增加错误处理
    ;删除医嘱项主表
    &sql(Delete From Arc_ItmMast where ARCIM_Rowid=:ArcimRowid)
    i SQLCODE'=0  d
    .trollback
    .s ResultString=-1   ;删除医嘱项主表失败
    .s ret=$$ErrorRecord^DHCSTERROR("OrderDelete:Arc_ItmMast",ArcimRowid,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    ;
    ;删除DHC_ItmMast
    i $d(^DHCItmMast("0","ARCIM",ArcimRowid))  d
    .&SQL(Delete From DHC_ItmMast where DARCIM_ARCIM_DR=:ArcimRowid)
    .i SQLCODE'=0  d
    ..trollback
    ..s ResultString=-2   ;删除医嘱项附加表失败
    ..s ret=$$ErrorRecord^DHCSTERROR("OrderDelete:DHC_ItmMast",ArcimRowid,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    ;
    ;删除别名
    i $d(^ARC("ALIAS",0,"ARCIM",ArcimRowid)) d
    .
    .&SQL(Delete From ARC_Alias where ALIAS_ARCIM_DR=:ArcimRowid)
    .i SQLCODE'=0  d
    ..trollback
    ..s ResultString=-3  ;删除医嘱项别名失败
    ..s ret=$$ErrorRecord^DHCSTERROR("OrderDelete:ARC_Alias",ArcimRowid,SQLCODE_":"_%msg)
    q:SQLCODE'=0 ResultString
    ;
    tcommit         
    q 0
}

/// Descript:   查询医嘱项明细信息
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-23
/// Table:Arc_Itm
/// Input:医嘱项id
/// Output:
/// Return：药学项子表id^代码^描述^计价单位id^医嘱子类id^医嘱子类^费用大类^费用子类id^
/// 费用子类^独立医嘱标志^默认医嘱优先级id^默认医嘱优先级^无库存医嘱标志^医保名称^缩写
/// ^最大量^限制使用天数^每天最大剂量^单次最大剂量^急诊用药^住院用药^门诊用药
/// ^体检用药^医嘱提示
ClassMethod GetArcDetailById(ArcimId) As %Library.String
{

    n (ArcimId)
    q:ArcimId="" ""
    s Sub=+ArcimId
    s Ver=$p(ArcimId,"||",2)
    ;
    &sql(Select ARCIM_Code,ARCIM_Desc,ARCIM_Abbrev,ARCIM_ItemCat_DR,
    ARCIM_BillSub_DR,ARCIM_PHCDF_DR,ARCIM_EffDate,ARCIM_EffTime,ARCIM_EffDateTime,
    ARCIM_OrderOnItsOwn,ARCIM_AllowOrderWOStockCheck,ARCIM_BillingUOM_DR,
    ARCIM_DefPriority_DR,ARCIM_MaxCumDose,ARCIM_NoOfCumDays,ARCIM_Text1,ARCIM_MaxQtyPerDay,
    ARCIM_MaxQty,ARCIM_RestrictEM,ARCIM_RestrictIP,ARCIM_RestrictOP,ARCIM_RestrictHP 
    into :ArcCode,:ArcDesc,:SX,:ArcSubCatId,:BillSubCatId,:PhcdfId,:EffDate,
    :EffTime,:EffDateTime,:OwnFlag,:WoStock,:BillUomId,:PriorId,:MaxCumDose,
    :NoOfCumDays,:InsuDesc,:MaxQtyPerDay,:MaxQty,:RestrictEM,:RestrictIP,:RestrictOP,
    :RestrictHP From Arc_ItmMast where ARCIM_Rowid=:ArcimId)
    ;
    q:SQLCODE'=0 ""
    s OeMessage=""
    i $d(^ARCIM(Sub,Ver,"OEM"))'=0 d 
    .s memonum=^ARCIM(Sub,Ver,"OEM",0)
    .f k=1:1:memonum  d
    ..s OeMessage=OeMessage_^ARCIM(Sub,Ver,"OEM",k)
    s InsuDesc=..GetExCode(ArcimId)         ;取医保名称
    s:BillUomId'="" BillUomDesc=$p(^CT("UOM",BillUomId),"^",2)
    s:ArcSubCatId'="" ArcSubCat=$p(^ARC("IC",ArcSubCatId),"^",2)
    s:BillSubCatId'="" BillSubCat=$p(^ARCBG(+BillSubCatId,"SG",$p(BillSubCatId,"||",2)),"^",2)
    s:BillSubCatId'="" BillCat=$p(^ARCBG(+BillSubCatId),"^",2)
    s:PriorId'="" Priority=$p(^OECPR(PriorId),"^",2)
    s Data1=PhcdfId_"^"_ArcCode_"^"_ArcDesc_"^"_BillUomId_"^"_$g(BillUomDesc)_"^"_ArcSubCatId_"^"_$g(ArcSubCat)
    s Data2=BillCat_"^"_BillSubCatId_"^"_$g(BillSubCat)_"^"_OwnFlag_"^"_PriorId_"^"_$g(Priority)_"^"_WoStock
    s Data3=InsuDesc_"^"_SX_"^"_MaxQty_"^"_NoOfCumDays_"^"_MaxQtyPerDay_"^"_MaxCumDose_"^"_RestrictEM
    s Data4=RestrictIP_"^"_RestrictOP_"^"_RestrictHP_"^"_OeMessage
    s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4
    q Data
}

ClassMethod GetExCode(arcim) As %Library.String
{

 ;取收费项的exeternalcode
 n (arcim)
 q:$g(arcim)="" ""
 ;
 s TarItm=""
 s TarItm=$o(^DHCOLT(0,"ARTTA",arcim,""))
 i TarItm="" q ""
 &sql(select tari_externalcode into :excode from dhc_taritem where tari_rowid=:TarItm)
 q $g(excode)
}

/// Descript:   增加医嘱项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-13
/// Table:INC_Alias
/// Input:库存项id;别名id^别名,别名id2^别名2...
/// Output:
/// Return：0,成功;错误代码
ClassMethod SaveAliasForOrd(InciId, ListData) As %Library.String
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
    s ArcimDesc=$p(^ARCIM(Sub,Ver,1),"^",2)
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s Len=$l(ListData,rowDelim)
    s ErrData=""
    s ResultString=""
    f i=1:1:Len  d
    .s RowData=$p(ListData,rowDelim,i)
    .s AliasId=$p(RowData,"^",1)
    .s Alias=$p(RowData,"^",2)
    .
    .i AliasId'=""  d
    ..&sql(Update ARC_Alias Set ALIAS_Text=:Alias Where ALIAS_RowId=:AliasId)
    ..i SQLCODE'=0  d
    ...s ErrData=ErrData_","_Alias
    .e  d
    ..;保存别名
    ..&sql(INSERT INTO ARC_Alias (ALIAS_ARCIM_DR,ALIAS_Desc,ALIAS_Text) VALUES (:ArcimId,:ArcimDesc,:Alias))
    ..i SQLCODE'=0  d
    ...s ErrData=ErrData_","_Alias
    ...s ret=$$ErrorRecord^DHCSTERROR("SaveAliasForOrd:ARC_Alias",Alias,SQLCODE_":"_%msg)
    ..e  d
    ...s AliasId=$p(%ROWID,$c(1))
    ..
    .
    q:ErrData'="" "{""success"":""false"",""info"":"""_ErrData_"""}" 
    q "{""success"":""true"",""info"":"""_0_"""}"
}

/// Descript:   删除医嘱项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-13
/// Table:ARC_Alias
/// Input:别名id
/// Output:
/// Return：0,成功;错误代码
ClassMethod DeleteAliasForOrd(AliasRowid) As %Library.String
{
    n (AliasRowid)
    q:AliasRowid="" "{""success"":""false"",""info"":"""_-1_"""}" 
    ;
    &sql(Delete From ARC_alias Where ALIAS_RowId=:AliasRowid)
    i SQLCODE'=0  d
    .s ret=$$ErrorRecord^DHCSTERROR("DeleteAliasForOrd:ARC_alias",AliasRowid,SQLCODE_":"_%msg)
    .
    q:SQLCODE'=0 "{""success"":""false"",""info"":"""_SQLCODE_"""}" 
    q "{""success"":""true"",""info"":"""_0_"""}"
}

/// Descript:   查询医嘱项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-13
/// Table:ARC_Alias
/// Input:库存项id
/// Output:
/// Return：别名id^别名
ClassMethod GetAliasForOrd(InciId) As %Library.String
{

    n (InciId)
    q:InciId="" ""
    q:'$d(^INCI(InciId)) "" 
    s ArcimId=$p(^INCI(InciId,1),"^",3)
    s Sub=+ArcimId
    s Ver=$p(ArcimId,"||",2)
    q:Sub="" "" 
    q:Ver="" "" 
    q:'$d(^ARCIM(Sub,Ver)) "" 
    Set Json = ##class(Code.JsonObj).%New()
    s Num=0
    s AliasId=0
    f  s AliasId=$o(^ARC("ALIAS",0,"ARCIM",ArcimId,AliasId))  q:AliasId=""  d
    .s Alias=$p(^ARC("ALIAS",AliasId),"^",6)
    .s Data=AliasId_"^"_Alias
    .d Json.InsertRowData(Data)
    .s Num=Num+1
    .
    s DetailStr=Json.getJsonData("ALIASRowid^ALIASText",Num)
    k Json 
    q DetailStr
}

}
