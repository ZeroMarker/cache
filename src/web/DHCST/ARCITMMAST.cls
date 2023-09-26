Import sqluser

/// Descript:医嘱项信息相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
Class web.DHCST.ARCITMMAST Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	保存医嘱项信息
/// Creater:	ZhangDongmei
/// CreateDate:	2013-04-24
/// Table:ARC_ItmMast
/// Input:医嘱项rowid,药学项子表id^代码^描述^计价单位id^医嘱子类id^费用大类id^费用子类id^独立医嘱标志
/// ^默认医嘱优先级id^无库存医嘱标志^医保名称^别名^缩写
/// ^医保类别^最大量^限制使用天数^每天最大剂量^单次最大剂量^急诊用药^住院用药^门诊用药
/// ^体检用药^医嘱提示^是否维护收费项目标志^是否维护医保项目^收费子分类^住院子分类^门诊子分类
/// ^核算子分类^病历首页子分类^会计子分类^生效日期^截止日期^医嘱大类
/// Output:		
/// Return：成功:医嘱项rowid
/// -20,医嘱项代码不能为空
/// -21，医嘱项名称不能为空
/// -22,计价单位不能为空
/// -23,费用大类不能为空
/// -24,费用子类不能为空
/// -25,医嘱子类不能为空
/// -26,药学项id不能为空
/// -27;无效的医嘱子分类
/// -28;无效的费用大类				
/// -29;无效的费用子类
/// -30;无效的药学项
/// -31;无效的计价单位
/// -32;医嘱项代码已经存在，不能重复
/// -33;医嘱项名称已经存在，不能重复
/// -81   ;插入医嘱项主表失败
/// -82   ;插入医嘱项附加表失败
/// -83	  ;插入医嘱项别名失败
ClassMethod Save(ArcimId As %String, listData As %String) As %Library.String
{
	n (ArcimId,listData,%session)
	//s $p(listData,"^",4)="" 					;医嘱改造,计价单位不再使,这谁改的？请联系yunhaibao,20181127,医生站门诊在用该字段
	q:(ArcimId'="")&(listData="") ArcimId 		;没有需要更新的内容
	s PhcdfId=$p(listData,"^",1)				;药学项子表id
 	s ArcCode=$p(listData,"^",2)     			;代码
 	s ArcDesc=$p(listData,"^",3)				;描述
 	s BillUomId=$p(listData,"^",4)				;计价单位id
 	s ArcSubCatId=$p(listData,"^",5)			;医嘱子类id
 	s BillCatId=$p(listData,"^",6)				;费用大类id
 	s BillSubCatId=$p(listData,"^",7)			;费用子类id
 	;
 	;不能为空项
 	q:ArcCode="" -20
 	q:ArcDesc="" -21
 	//q:BillUomId="" -22
 	q:BillCatId="" -23
 	q:BillSubCatId="" -24
 	q:ArcSubCatId="" -25
 	q:PhcdfId="" -26
 	s PHGenericDesc=""
 	s PHGenericDr=$p($g(^PHCD(+PhcdfId,4)),"^",1) //根据药学项处方通用名更新医嘱项处方通用名
 	s:PHGenericDr'="" PHGenericDesc=$p(^PHCGE("GE",PHGenericDr),"^",2)
 	;
 	q:'$d(^ARC("IC",ArcSubCatId)) -27									;无效的医嘱子分类
 	q:'$d(^ARCBG(BillCatId)) -28										;无效的费用大类				
 	q:'$d(^ARCBG(+BillSubCatId,"SG",$p(BillSubCatId,"||",2))) -29		;无效的费用子类
 	q:'$d(^PHCD(+PhcdfId,"DF",$p(PhcdfId,"||",2))) -30					;无效的药学项
 	//q:'$d(^CT("UOM",BillUomId)) -31										;无效的计价单位
 	s TmpId=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),"")) 
 	q:(TmpId'="")&(TmpId'=+ArcimId) -32									;医嘱项代码已经存在，不能重复
 	s TmpId=$o(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(ArcDesc),"")) 
 	q:(TmpId'="")&(TmpId'=+ArcimId) -33	 								;医嘱项名称已经存在，不能重复
 	;
 	s PhcdfId=$p(listData,"^",1)				;药学项子表id
 	s ArcCode=$p(listData,"^",2)     			;代码
 	s ArcDesc=$p(listData,"^",3)				;描述
 	s BillUomId=$p(listData,"^",4)				;计价单位id
 	s ArcSubCatId=$p(listData,"^",5)			;医嘱子类id
 	s BillCatId=$p(listData,"^",6)				;费用大类id
 	s BillSubCatId=$p(listData,"^",7)			;费用子类id
 	s OwnFlag=$p(listData,"^",8)				;独立医嘱标志
 	s PriorId=$p(listData,"^",9)				;默认医嘱优先级id		
 	s WoStock=$p(listData,"^",10)				;无库存医嘱标志
 	s InsuDesc=$p(listData,"^",11)				;医保名称
 	s AliasStr=$p(listData,"^",12)				;别名
 	s SX=$p(listData,"^",13)					;缩写
 	//s InsuType=$p(listData,"^",14)				;医保类别
 	s MaxQty=$p(listData,"^",15)				;最大量
 	s NoOfCumDays=$p(listData,"^",16)			;限制使用天数
 	s MaxQtyPerDay=$p(listData,"^",17)			;每天最大剂量
 	s MaxCumDose=$p(listData,"^",18)			;单次最大剂量
 	s RestrictEM=$p(listData,"^",19)			;急诊用药
 	s RestrictIP=$p(listData,"^",20)			;住院用药
 	s RestrictOP=$p(listData,"^",21)			;门诊用药
 	s RestrictHP=$p(listData,"^",22)			;体检用药
 	s OeMessage=$p(listData,"^",23)				;医嘱提示
 	s UpdTarFlag=$P(listData,"^",24)
 	S UpInsu=$P(listData,"^",25)				;更新医保项标志
 	S InsuItmType=0  							;药品类型为0
 	s TarCatStr=$p(listData,"^",26,32)				;收费项分类串
 	s TarCatStr=$tr(TarCatStr,"^","#")
 	;
 	s EffDate=$P(listData,"^",33)   ;+$h
 	s EffDateTo=$P(listData,"^",34) 
 	s UserID=$P(listData,"^",35)
 	s LimitQty=$P(listData,"^",36)
 	s WarningUseQty=$P(listData,"^",37)
 	s freeDrugFlag=$P(listData,"^",38)
 	;
 	;保存或更新医嘱项主表
 	s MainInfo=PhcdfId_"^"_ArcCode_"^"_ArcDesc_"^"_BillUomId_"^"_ArcSubCatId_"^"_BillSubCatId
 	s MainInfo=MainInfo_"^"_OwnFlag_"^"_PriorId_"^"_WoStock_"^"_InsuDesc_"^"_MaxQty_"^"_NoOfCumDays
 	s MainInfo=MainInfo_"^"_MaxQtyPerDay_"^"_MaxCumDose_"^"_RestrictEM_"^"_RestrictIP_"^"_RestrictOP
 	s MainInfo=MainInfo_"^"_RestrictHP_"^"_EffDate_"^"_EffDateTo_"^"_PHGenericDr_"^"_PHGenericDesc
 	;保存或更新医嘱项附加表
 	s DHCInfo=MaxQty_"^"_LimitQty_"^"_WarningUseQty_"^"_freeDrugFlag
 	tstart
 	s $ZT="Error^DHCSTERROR"
 	s ret=..SaveItmMast(ArcimId,MainInfo)
 	i +ret<=0 trollback
 	q:+ret<=0 ret
 	s Rowid=ret        ;医嘱项主表id
 	s ret=..SaveOeMessage(Rowid,OeMessage)
 	i ret'=0 trollback
 	q:ret'=0 ret
 	s ret=..SaveDhcItmMast(Rowid,DHCInfo)
 	i ret'=0 trollback
 	q:ret'=0 ret
 	s ListAlias=""
 	i Rowid'=""  d
 	.s ListAlias=..CreateAlias(Rowid)    //新增时自动生成别名
 	.i ListAlias'=""  d
 	..s FormatAliasStr=$$FormatAlias(ListAlias)
 	..s ret=##class(web.DHCST.ARCALIAS).Save(Rowid,FormatAliasStr)
 	..s:ret'=0 ret=-83   ;插入医嘱项别名失败
 	.
 	;
 	i ret'=0 trollback
 	q:ret'=0 ret
 	tcommit
 	q Rowid
 	
FormatAlias(AliasStr)
 n (AliasStr)
 s ResultAliasStr=""
 s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
 f i=1:1:$l(AliasStr,"^")  d
 .s Alias=$p(AliasStr,"^",i)
 .i ResultAliasStr=""  d
 ..s ResultAliasStr="^"_Alias
 .e  d
 ..s ResultAliasStr=ResultAliasStr_rowDelim_"^"_Alias
 .
 q ResultAliasStr
}

/// Descript:保存/更新医嘱项主表信息
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-29
/// Table:ARC_ItmMast
/// Input:药学项子表id^代码^描述^计价单位id^医嘱子类id^费用子类id^独立医嘱标志
/// ^默认医嘱优先级id^无库存医嘱标志^医保名称^最大量^限制使用天数^每天最大剂量^单次最大剂量^急诊用药^住院用药^门诊用药
/// ^体检用药^生效日期^截止日期
/// Output:		
/// Return：医嘱项rowid,成功
/// -81   ;插入医嘱项主表失败
ClassMethod SaveItmMast(Rowid, listData) As %Library.String
{

	n (Rowid,listData,%session)
	q:listData="" ""
	s PhcdfId=$p(listData,"^",1)				;药学项子表id
	s ArcCode=$p(listData,"^",2)     			;代码
 	s ArcDesc=$p(listData,"^",3)				;描述
 	s BillUomId=$p(listData,"^",4)				;计价单位id
 	s ArcSubCatId=$p(listData,"^",5)			;医嘱子类id
 	s BillSubCatId=$p(listData,"^",6)			;费用子类id
 	s OwnFlag=$p(listData,"^",7)				;独立医嘱标志
 	s PriorId=$p(listData,"^",8)				;默认医嘱优先级id
 	s WoStock=$p(listData,"^",9)				;无库存医嘱标志
 	s InsuDesc=$p(listData,"^",10)				;医保名称 	
 	s MaxQty=$p(listData,"^",11)				;最大量
 	s NoOfCumDays=$p(listData,"^",12)			;限制使用天数 	
 	s MaxQtyPerDay=$p(listData,"^",13)			;每天最大剂量
 	s MaxCumDose=$p(listData,"^",14)			;单次最大剂量
 	s RestrictEM=$p(listData,"^",15)			;急诊用药
 	s RestrictIP=$p(listData,"^",16)			;住院用药
 	s RestrictOP=$p(listData,"^",17)			;门诊用药
 	s RestrictHP=$p(listData,"^",18)			;体检用药
 	;
 	s EffDate=$P(listData,"^",19)   ;+$h
 	s ChgPostFlg="O"
	i EffDate'=""  d
	.s EffDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EffDate)
	e  d
	.s EffDate=+$h
 	s EffTime=$p($h,",",2)
 	s EffDateTime=EffDate_"Z"_EffTime
 	s EffDateTo=$P(listData,"^",20) 
 	i EffDateTo'=""  d
 	.s EffDateTo=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EffDateTo)
 	s Generic=$P(listData,"^",21)
 	s GenericDesc=$P(listData,"^",22)
 	i GenericDesc'="" s SX=GenericDesc
 	e  s SX=$e(ArcDesc,1,20)
 	s ArcimId=Rowid
 	s Err=0
 	i Rowid=""  d    ;新增
 	.&sql(Insert into Arc_ItmMast(ARCIM_Code,ARCIM_Desc,ARCIM_ItemCat_DR,
 	ARCIM_BillSub_DR,ARCIM_PHCDF_DR,ARCIM_EffDate,ARCIM_EffTime,
 	ARCIM_OrderOnItsOwn,ARCIM_AllowOrderWOStockCheck,ARCIM_BillingUOM_DR,
 	ARCIM_DefPriority_DR,ARCIM_MaxCumDose,ARCIM_NoOfCumDays,ARCIM_Text1,ARCIM_MaxQtyPerDay,
 	ARCIM_MaxQty,ARCIM_RestrictEM,ARCIM_RestrictIP,ARCIM_RestrictOP,ARCIM_RestrictHP,ARCIM_EffDateTo,
 	ARCIM_Generic_DR,ARCIM_GenericDesc,ARCIM_ChgPostFlg)
 	values(:ArcCode,:ArcDesc,:ArcSubCatId,:BillSubCatId,:PhcdfId,:EffDate,
 	:EffTime,:OwnFlag,:WoStock,:BillUomId,:PriorId,:MaxCumDose,
 	:NoOfCumDays,:InsuDesc,:MaxQtyPerDay,:MaxQty,:RestrictEM,:RestrictIP,:RestrictOP,
 	:RestrictHP,:EffDateTo,:Generic,:GenericDesc,:ChgPostFlg))
 	.i SQLCODE'=0  d
 	..s rett=$$ErrorRecord^DHCSTERROR("Insert:Arc_ItmMast",ArcDesc,SQLCODE_":"_%msg)
 	..s Err=-81   ;插入医嘱项主表失败
 	.e  d
 	..s ArcimId=$P(%ROWID,$C(1))		;医嘱项主表rowid
 	..s AppName="DHCSTCOMMON"
    ..s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    ..i RecordTraceFlag="Y" d
    ...s JsonStr=##class(web.DHCST.Common.JsonObj).GetValue("Arc_ItmMast",ArcimId)
    ...d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("ARC_ItmMast","User.ARCItmMast","医嘱项主表信息",ArcimId,ArcDesc,"A",JsonStr)
 	e  d     ;更新
 	.s OldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("Arc_ItmMast",Rowid)
 	.&sql(Update Arc_ItmMast set ARCIM_Code=:ArcCode,ARCIM_Desc=:ArcDesc,ARCIM_ItemCat_DR=:ArcSubCatId,
 	ARCIM_BillSub_DR=:BillSubCatId,ARCIM_OrderOnItsOwn=:OwnFlag,
 	ARCIM_AllowOrderWOStockCheck=:WoStock,ARCIM_BillingUOM_DR=:BillUomId,
 	ARCIM_DefPriority_DR=:PriorId,ARCIM_MaxCumDose=:MaxCumDose,ARCIM_NoOfCumDays=:NoOfCumDays,
 	ARCIM_Text1=:InsuDesc,ARCIM_MaxQtyPerDay=:MaxQtyPerDay,ARCIM_MaxQty=:MaxQty,ARCIM_RestrictEM=:RestrictEM,ARCIM_RestrictIP=:RestrictIP,
 	ARCIM_RestrictOP=:RestrictOP,ARCIM_RestrictHP=:RestrictHP,ARCIM_EffDate=:EffDate,ARCIM_EffTime=:EffTime,
 	ARCIM_EffDateTo=:EffDateTo,ARCIM_Generic_DR=:Generic,ARCIM_GenericDesc=:GenericDesc,ARCIM_Abbrev=:SX,ARCIM_ChgPostFlg=:ChgPostFlg 
 	where arcim_rowid=:Rowid)
 	.i SQLCODE'=0  d
 	..s rett=$$ErrorRecord^DHCSTERROR("Update:Arc_ItmMast",Rowid,SQLCODE_":"_%msg)
 	..s Err=-81   ;更新医嘱项主表失败
 	.e  d
 	..s AppName="DHCSTCOMMON"
    ..s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    ..i RecordTraceFlag="Y" d
    ...s JsonStr=##class(web.DHCST.Common.JsonObj).GetValue("Arc_ItmMast",Rowid)
    ...d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("Arc_ItmMast","User.ArcItmMast","医嘱项主表信息",Rowid,ArcDesc,"U",JsonStr,OldJsonStr)
 	q:Err'=0 Err
 	q ArcimId
}

/// Descript:保存/更新医嘱提示信息
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-29
/// Table:ARC_ItmMast
/// Input:医嘱项rowid,提示信息
/// Output:		
/// Return：0,成功
ClassMethod SaveOeMessage(ArcimId, OeMessage) As %Library.String
{
	n (ArcimId,OeMessage)
	q:ArcimId="" 0 
 	s Sub=+ArcimId
 	s Ver=$p(ArcimId,"||",2)
 	s Delim=##class(web.DHCST.Common.UtilCommon).MemoDelim()
 	s Len=$l(OeMessage,Delim)
 	k ^ARCIM(Sub,Ver,"OEM")
 	s ^ARCIM(Sub,Ver,"OEM",0)=Len
 	f i=1:1:Len  d
 	.s Message=$p(OeMessage,Delim,i)
 	.s ^ARCIM(Sub,Ver,"OEM",i)=Message
 	.
 	q 0
}

/// Descript:根据医嘱项名称等自动生成别名
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-29
/// Table:ARC_Alias
/// Input:医嘱项rowid
/// Output:		
/// Return：医嘱项别名串
/// w ##class(web.DHCST.ARCITMMAST).CreateAlias("99||1")
ClassMethod CreateAlias(ArcimId) As %Library.String
{
	n (ArcimId)
	q:ArcimId="" ""
	s ArcCode=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",1)
	q:ArcCode="" ""
	s ArcDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
	q:ArcDesc="" ""
	s PhcdfId=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",12)
	;
	;生成别名
	s ListAlias=""
	s AutoAddAAByDesc=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DrugInfoMaintain).%GetParameter("AppName"),"AutoAddAAByDesc")
	i AutoAddAAByDesc="Y"  d
	.s AliasByDesc=##class(web.DHCST.Common.AppCommon).GetCNCODE(ArcDesc)	//修改"?"等字符的问题
	.q:AliasByDesc=""
	.s ListAlias=AliasByDesc
	.s AliasWBByDesc=##class(web.DHCST.Common.AppCommon).GetCNWBCODE(ArcDesc)
    .i ListAlias'=""  d
    ..s ListAlias=ListAlias_"^"_AliasWBByDesc
    .e  d
    ..s ListAlias=AliasWBByDesc
	s AutoAddAAByGeneric=##class(web.DHCST.Common.AppCommon).GetAppPropValue(##class(web.DHCST.DrugInfoMaintain).%GetParameter("AppName"),"AutoAddAAByGeneric")
 	i AutoAddAAByGeneric="Y"  d
 	.s Generic=##class(web.DHCST.Common.DrugInfoCommon).GetGeneByPhcd(+PhcdfId)
 	.s Generic=$p(Generic,"^",2)
 	.q:Generic=""
	.s AliasByGeneric=##class(web.DHCST.Common.AppCommon).GetCNCODE(Generic)
	.q:AliasByGeneric=""
	.i ListAlias'=""  d
	..s ListAlias=ListAlias_"^"_AliasByGeneric
 	.e  d
 	..s ListAlias=AliasByGeneric
 	.
 	i ListAlias'="" s ListAlias=ArcCode_"^"_ListAlias
 	q ListAlias
}

/// Descript:保存收费项
/// Creater:	ZhangDongmei
/// CreateDate:	2013-04-25
/// Table:DHC_TarItem, DHC_OrderLinkTar
/// Input:医嘱项rowid
/// Output:		
/// Return：0,成功
ClassMethod AddTarItem(ArcimId, TarCatStr, InsuDesc, UserID) As %Library.String
{
	n (ArcimId,TarCatStr,InsuDesc,UserID,%session)
	q:ArcimId="" -103
	;
	s TarItm=""
 	s TarItm=$o(^DHCOLT(0,"ARTTA",ArcimId,""))
 	i TarItm="" d
 	.s ret=..InsertTarItem(ArcimId, TarCatStr, InsuDesc, UserID)
 	e  d
 	.s ret=..UpdateTarItem(ArcimId, TarItm, TarCatStr, InsuDesc,UserID)
 	
 	q ret
}

/// Descript:新增收费项
/// CreateDate:	2013-04-25
/// Table:DHC_TarItem
/// Input:医嘱项rowid
/// Output:		
/// Return：0,成功
ClassMethod InsertTarItem(ArcimId, TarCatStr, InsuDesc, UserID) As %Library.String
{
	n (ArcimId,TarCatStr,InsuDesc,UserID,%session)
	q:ArcimId="" -103
	q:TarCatStr="" -104
	s Sub=+ArcimId
	s Ver=$p(ArcimId,"||",2)
	s Code=$p(^ARCIM(Sub,Ver,1),"^",1)
 	s Desc=$p(^ARCIM(Sub,Ver,1),"^",2)
 	s UOM=$p(^ARCIM(Sub,Ver,8),"^",14)
 	s Phcdf=$p(^ARCIM(Sub,Ver,1),"^",12)    //药学项子表id
 	i Phcdf'="" s UOM=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
 	s BrgDesc=""
 	s Brg=$p(^ARCIM(Sub,Ver,1),"^",9)     //费用子类
 	i Brg'="" s BrgDesc=$p(^ARCBG(+Brg,"SG",$p(Brg,"||",2)),"^",2)
	s TarItm=""
 	s TarItm=$o(^DHCOLT(0,"ARTTA",ArcimId,""))
 	i TarItm'="" q -100
 	;
 	s TarItm=$o(^DHCTARI(0,"Desc",Desc,""))
 	i TarItm'="" q -101
 	;
	 s TarItm=$o(^DHCTARI(0,"Code",Code,""))
 	i TarItm'="" q -102
 	i TarCatStr'="" d
	.s SCRowId=$p(TarCatStr,"#",1)
	.s ICRowId=$p(TarCatStr,"#",2)
	.s OCRowId=$p(TarCatStr,"#",3)
	.s ECRowId=$p(TarCatStr,"#",4)
	.s MCRowId=$p(TarCatStr,"#",5)
	.s ACRowId=$p(TarCatStr,"#",6)
	.s NewMowId=$p(TarCatStr,"#",7)
	e  d
	.&sql(Select TARSC_RowId INTO :SCRowId from DHC_TarSubCate Where TARSC_Desc= :BrgDesc)
	.&sql(Select TARAC_RowId INTO :ACRowId from DHC_TarAcctCate Where TARAC_Desc= :BrgDesc)
	.&sql(Select TARIC_RowId INTO :ICRowId from DHC_TarInpatCate Where TARIC_Desc= :BrgDesc)
	.&sql(Select TARMC_RowId INTO :MCRowId from DHC_TarMRCate Where TARMC_Desc= :BrgDesc)
	.&sql(Select TAREC_RowId INTO :ECRowId from DHC_TarEMCCate Where TAREC_Desc= :BrgDesc)
	.&sql(Select TAROC_RowId INTO :OCRowId from DHC_TarOutpatCate Where TAROC_Desc= :BrgDesc)
 	;
	s SCRowId=$g(SCRowId)
	s ICRowId=$g(ICRowId)
	s OCRowId=$g(OCRowId)
	s ECRowId=$g(ECRowId)
	s MCRowId=$g(MCRowId)
	s ACRowId=$g(ACRowId)
	s NewMowId=$g(NewMowId)
	s Date=+$H-99
	&SQL(INSERT INTO DHC_TARITEM(TARI_Code,TARI_Desc,TARI_UOM,TARI_SubCate,
	TARI_AcctCate,TARI_OutpatCate,TARI_EMCCate,TARI_MRCate,TARI_SpecialFlag,
	TARI_ActiveFlag,TARI_StartDate,TARI_InpatCate,TARI_ExternalCode) VALUES(:Code,:Desc,:UOM,:SCRowId,
	:ACRowId,:OCRowId,:ECRowId,:MCRowId,'N','Y',:Date,:ICRowId,:InsuDesc))
	s taritmdr=+$g(%ROWID)
	i SQLCODE=0  d ..UpdateTarItemBL(+$g(%ROWID),NewMowId,UserID) //新病案首页 bianshuai
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("web.DHCST.ARCITMMAST.InsertTarItem",ArcimId,SQLCODE_":"_%msg)
	q:SQLCODE'=0 SQLCODE
	s TarRowid=taritmdr
	s AppName="DHCSTCOMMON"
    s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    i RecordTraceFlag="Y" d
    .s JsonStr=##class(web.DHCST.Common.JsonObj).GetValue("DHC_TARITEM",TarRowid)
    .d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_TARITEM","User.DHCTARITEM","收费项表信息",TarRowid,Desc,"A",JsonStr)
	s Date=+$h-99
	&SQL(INSERT INTO DHC_OrderLinkTar(OLT_Tariff_DR,OLT_ARCIM_DR,OLT_Qty,OLT_StartDate) 
	VALUES (:TarRowid,:ArcimId,1,:Date))
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("web.DHCST.ARCITMMAST.InsertTarItem:DHC_OrderLinkTar",ArcimId,SQLCODE_":"_%msg)
	e  d
	.s OLTRowId=+$g(%ROWID)
	.i RecordTraceFlag="Y" d
    ..s JsonStr1=##class(web.DHCST.Common.JsonObj).GetValue("DHC_OrderLinkTar",OLTRowId)
    ..d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_OrderLinkTar","User.DHCOrderLinkTar","医嘱项关联收费项表信息",OLTRowId,Desc,"A",JsonStr1)
	q SQLCODE
}

/// Descript:修改收费项
/// CreateDate:	2013-05-08
/// Table:DHC_TarItem
/// Input:医嘱项rowid
/// Output:		
/// Return：0,成功
ClassMethod UpdateTarItem(ArcimId, TarItm, TarCatStr, InsuDesc, UserID) As %Library.String
{
	n (ArcimId,TarItm,TarCatStr,InsuDesc,UserID,%session)
	q:ArcimId="" -103
	q:TarItm="" -100
	q:TarCatStr="" -104
	
	s Sub=+ArcimId
	s Ver=$p(ArcimId,"||",2)
	s Code=$p(^ARCIM(Sub,Ver,1),"^",1)
 	s Desc=$p(^ARCIM(Sub,Ver,1),"^",2)
 	s UOM=$p(^ARCIM(Sub,Ver,8),"^",14)
 	s Phcdf=$p(^ARCIM(Sub,Ver,1),"^",12)    //药学项子表id
 	i Phcdf'="" s UOM=$p(^PHCD(+Phcdf,"DF",$p(Phcdf,"||",2),2),"^",4)
	s SCRowId=$p(TarCatStr,"#",1)
	s ICRowId=$p(TarCatStr,"#",2)
	s OCRowId=$p(TarCatStr,"#",3)
	s ECRowId=$p(TarCatStr,"#",4)
	s MCRowId=$p(TarCatStr,"#",5)
	s ACRowId=$p(TarCatStr,"#",6)
	s NewMowId=$p(TarCatStr,"#",7)
	s OldJsonStr=##class(web.DHCST.Common.JsonObj).GetValue("DHC_TARITEM",TarItm)
	&SQL(UPDATE DHC_TARITEM SET TARI_Code=:Code,TARI_UOM=:UOM,TARI_SubCate=:SCRowId,
		TARI_AcctCate=:ACRowId,TARI_OutpatCate=:OCRowId,TARI_EMCCate=:ECRowId,TARI_MRCate=:MCRowId,
		TARI_InpatCate=:ICRowId,TARI_ExternalCode=:InsuDesc,TARI_Desc=:Desc
		WHERE TARI_RowId=:TarItm)
	i SQLCODE=0 d ..UpdateTarItemBL(TarItm,NewMowId,UserID) //新病案首页
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("web.DHCST.ARCITMMAST.UpdateTarItem",ArcimId,SQLCODE_":"_%msg)
	e  d
	.s AppName="DHCSTCOMMON"
    .s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    .i RecordTraceFlag="Y" d
    ..s JsonStr=##class(web.DHCST.Common.JsonObj).GetValue("DHC_TARITEM",TarItm)
    ..d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_TARITEM","User.DHCTARITEM","收费项表信息",TarItm,Desc,"U",JsonStr,OldJsonStr)		
	q SQLCODE
}

/// Descript:更新医保名称
/// Creater:	ZhangDongmei
/// CreateDate:	2013-04-25
/// Table:DHC_TarItem
/// Input:医嘱项rowid,医保名称
/// Output:		
/// Return：0,成功
ClassMethod UpdTarItmExCode(ArcimId, InsuDesc) As %Library.String
{
	n (ArcimId,InsuDesc)
 	q:$g(ArcimId)="" 0
	;
 	s TarItm=""
 	s TarItm=$o(^DHCOLT(0,"ARTTA",ArcimId,""))
 	i TarItm="" q 0
 	;
 	&SQL(UPDATE DHC_TarItem SET tari_externalcode=:InsuDesc WHERE TARI_RowId= :TarItm)
 	;
 	q SQLCODE
}

/// Descript:保存收费项别名
/// Creater:	ZhangDongmei
/// CreateDate:	2013-04-25
/// Table:DHC_TarItem
/// Input:医嘱项rowid,别名1^别名2
/// Output:		
/// Return：0,成功
ClassMethod AddTarItmAlias(ArcimId, TarAliasStr) As %Library.String
{
	n (ArcimId,TarAliasStr,%session)
    q:$g(ArcimId)="" 0
    q:$g(TarAliasStr)="" 0
    s Len=$l(TarAliasStr,"^")
    s TarItm=""
    s TarItm=$o(^DHCOLT(0,"ARTTA",ArcimId,""))
    i TarItm="" q 0
    ;
    s Desc=$p(^DHCTARI(TarItm),"^",2)
    s Err=0
    f i=1:1:Len q:Err'=0  d
    .s Alias=$p(TarAliasStr,"^",i)
    .q:Alias=""
    .q:(Alias'="")&&(TarItm'="")&&($d(^DHCTARAL("A",0,"Desc",$$ALPHAUP^SSUTIL4(Alias),TarItm)))  //yunhaibao,修改,存在则不插入
    .&SQL(INSERT INTO DHC_TarItemAlias(TIA_TARI_DR,TIA_Desc,TIA_Alias) VALUES 
     (:TarItm,:Desc,:Alias))
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("web.DHCST.ARCITMMAST.AddTarItmAlias",ArcimId,SQLCODE_":"_%msg)
    ..s Err=SQLCODE
    q Err
}

/// Descript:保存医嘱项附加表
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-29
/// Table:ARC_Alias
/// Input:医嘱项rowid
/// Output:		
/// Return：0,成功
ClassMethod SaveDhcItmMast(ArcimId, DHCInfo) As %Library.String
{
	n (ArcimId,DHCInfo)
	q:ArcimId="" 0
	s MaxQty=$p(DHCInfo,"^",1)
	s LimitQty=$P(DHCInfo,"^",2)
 	s WarningUseQty=$P(DHCInfo,"^",3)
 	s freeDrugFlag=$P(DHCInfo,"^",4)
	s Err=0
	;保存DHC_ItmMast
	s Rowid=$o(^DHCItmMast("0","ARCIM",ArcimId,0))
	i Rowid=""  d
 	.&SQL(INSERT INTO DHC_ItmMast(DARCIM_ARCIM_DR,DARCIM_MaxQty,DARCIM_LimitQty,DARCIM_WarningUseQty,DARCIM_FreeDrugFlag) 
 	Values(:ArcimId,:MaxQty,:LimitQty,:WarningUseQty,:freeDrugFlag))
 	e  d
 	.&SQL(Update DHC_ItmMast set DARCIM_MaxQty=:MaxQty,DARCIM_LimitQty=:LimitQty,DARCIM_WarningUseQty=:WarningUseQty,
 	DARCIM_FreeDrugFlag=:freeDrugFlag where DARCIM_ARCIM_DR=:ArcimId)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("SaveDhcItmMast:DHC_ItmMast",ArcimId,SQLCODE_":"_%msg)
 	.s Err=-82   ;插入医嘱项附加表失败
 	.
 	q Err
}

/// Descript:	更新医嘱项截止日期
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-14
/// Table:ARC_ItmMast
/// Input:医嘱项id,截止日期
/// Output:		
/// Return：0:成功;
/// <0:失败
ClassMethod UpdateEffDeteTo(ArcimRowid As %String, EffDateTo As %String) As %Library.String
{
	n (ArcimRowid,EffDateTo)
	q:ArcimRowid="" 0
	q:EffDateTo="" 0
 	;
 	s Err=0
 	;更新医嘱项主表
 	&sql(Update Arc_ItmMast set ARCIM_EffDateTo=:EffDateTo where arcim_rowid=:ArcimRowid)
 	i SQLCODE'=0  d
 	.s rett=$$ErrorRecord^DHCSTERROR("UpdateEffDeteTo:Arc_ItmMast",ArcimRowid,SQLCODE_":"_%msg)
 	.s Err=-1  ;更新医嘱项截止日期失败
 	q Err
}

/// Descript:	删除医嘱项信息
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-28
/// Table:ARC_ItmMast
/// Input:医嘱项rowid
/// Output:		
/// Return：0，成功；
/// -81   ;删除医嘱项主表失败
/// -82   ;删除医嘱项附加表失败
/// -83  ;删除医嘱项别名失败
/// Debug:w ##class(web.DHCST.ARCITMMAST).Delete("11921||1")
ClassMethod Delete(ArcimRowid) As %Library.String
{
	n (ArcimRowid,%session)
	q:ArcimRowid="" 0
	s Sub=+ArcimRowid
	q:Sub'>0 0
	s Ver=$p(ArcimRowid,"||",2)
	q:'$d(^ARCIM(Sub,Ver)) 0
	q:$D(^INCI(0,"ARCIM_DR",Sub)) "-1^该医嘱项已关联库存项，不能删除" // yunhaibao20181115,先控制不能删
	s Inci="",UseFlag=0
	f  s Inci=$o(^INCI(0,"ARCIM_DR",Sub,Inci)) q:(Inci="")||(UseFlag'=0)  d
	.q:'$d(^INCI(Inci))
	.s UseFlag=##class(web.DHCST.INCITM).CheckUsed(Inci)
	q:UseFlag'=0 "-1^该医嘱项关联药品已发生业务，不能删除！"
	s ResultString=""
	&sql(SELECT ARCIM_Code, ARCIM_Desc into :ARCIMCode,:ARCIMDesc FROM Arc_ItmMast WHERE ARCIM_Rowid=:ArcimRowid)
    s JsonStr="{药品代码:"""_ARCIMCode_""",药品名称:"""_ARCIMDesc_"""}"
	s Err=0
 	tstart
 	s $ZT="Error^DHCSTERROR"						;增加错误处理
 	s PhcdfRowid=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",12)
 	;删除医嘱项主表
 	&sql(Delete From Arc_ItmMast where ARCIM_Rowid=:ArcimRowid)
 	i SQLCODE'=0  d
 	.trollback
 	.s rett=$$ErrorRecord^DHCSTERROR("OrderDelete:Arc_ItmMast",ArcimRowid,SQLCODE_":"_%msg)
 	.s Err="-2^删除医嘱项主表失败!"   
 	q:Err'=0 Err
 	;
 	;删除DHC_ItmMast
 	i $d(^DHCItmMast("0","ARCIM",ArcimRowid))  d
 	.&SQL(Delete From DHC_ItmMast where DARCIM_ARCIM_DR=:ArcimRowid)
 	.i SQLCODE'=0  d
 	..trollback
 	..s rett=$$ErrorRecord^DHCSTERROR("OrderDelete:DHC_ItmMast",ArcimRowid,SQLCODE_":"_%msg)
 	..s Err="-3^删除医嘱项附加表失败!"
 	q:Err'=0 Err
	;
	;删除别名
	i $d(^ARC("ALIAS",0,"ARCIM",ArcimRowid))  d
	.s Err=##class(web.DHCST.ARCALIAS).DeleteItmAlias(ArcimRowid)
 	i Err'=0 trollback
 	q:Err'=0 "-4^删除医嘱项别名失败!"
 	&SQL(UPDATE INC_Itm SET INCI_ARCIM_DR=NULL WHERE INCI_ARCIM_DR=:ArcimRowid)
 	;
 	;删除药学项
 	i PhcdfRowid'=""  d
 	.s Phcd=$p(PhcdfRowid,"||",1)
 	.s Chl=$p(PhcdfRowid,"||",2)
 	.&sql(Delete From PHC_DrgMast where PHCD_Rowid=:Phcd)
 	.i SQLCODE'=0  d
 	..trollback
 	..s rett=$$ErrorRecord^DHCSTERROR("Delete:PHC_DrgMast",Phcd,SQLCODE_":"_%msg)
 	..s Err="-5^删除药学项失败"
 	.q:Err'=0
 	.;删除global
 	.k ^PHCD(Phcd,"DF",Chl,"DHC")
 	q:Err'=0 Err
 	
	tcommit
	s AppName="DHCSTCOMMON"
    s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    i RecordTraceFlag="Y" d
 	.d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("Arc_ItmMast","User.ARCItmMast","医嘱项主表信息",ArcimRowid,ARCIMCode,"D",JsonStr)			
 	.d:PhcdfRowid'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("PHC_DrgMast","User.PHCDrgMast","药学项主表信息",Phcd,ARCIMCode,"D",JsonStr)
 	q 0
}

/// Descript:	查询医嘱项明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-23
/// Table:Arc_Itm
/// Input:医嘱项id
/// Output:
/// Return：药学项子表id^代码^描述^计价单位id^医嘱子类id^医嘱子类^费用大类^费用子类id^
/// 费用子类^独立医嘱标志^默认医嘱优先级id^默认医嘱优先级^无库存医嘱标志^医保名称^缩写
/// ^最大量^限制使用天数^每天最大剂量^单次最大剂量^急诊用药^住院用药^门诊用药
/// ^体检用药^医嘱提示^生效日期^截止日期^医嘱大类描述^医嘱大类id
/// ^收费子分类^住院子分类^门诊子分类^核算子分类^病历首页子分类^会计子分类
/// w ##class(web.DHCST.ARCITMMAST).Select("524||1")
ClassMethod Select(ArcimId) As %Library.String
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
 	ARCIM_MaxQty,ARCIM_RestrictEM,ARCIM_RestrictIP,ARCIM_RestrictOP,ARCIM_RestrictHP,ARCIM_EffDate,ARCIM_EffDateTo
 	into :ArcCode,:ArcDesc,:SX,:ArcSubCatId,:BillSubCatId,:PhcdfId,:EffDate,
 	:EffTime,:EffDateTime,:OwnFlag,:WoStock,:BillUomId,:PriorId,:MaxCumDose,
 	:NoOfCumDays,:InsuDesc,:MaxQtyPerDay,:MaxQty,:RestrictEM,:RestrictIP,:RestrictOP,
 	:RestrictHP,:EffDate,:EffDateTo From Arc_ItmMast where ARCIM_Rowid=:ArcimId)
	;
	q:SQLCODE'=0 ""
	s OeMessage=""
	i $d(^ARCIM(Sub,Ver,"OEM"))'=0 d 
 	.s memonum=^ARCIM(Sub,Ver,"OEM",0)
 	.f k=1:1:memonum  d
 	..s OeMessage=OeMessage_^ARCIM(Sub,Ver,"OEM",k)
	//s InsuDesc=..GetExCode(ArcimId)			;取医保名称  
	s:BillUomId'="" BillUomDesc=$p(^CT("UOM",BillUomId),"^",2)
	i ArcSubCatId'=""  d
	.s ArcSubCat=$p(^ARC("IC",ArcSubCatId),"^",2)
	.s OrdCatId=$p(^ARC("IC",ArcSubCatId),"^",8)
	.s:OrdCatId'="" OrdCat=$p(^OEC("ORCAT",OrdCatId),"^",2)
	s:BillSubCatId'="" BillSubCat=$p(^ARCBG(+BillSubCatId,"SG",$p(BillSubCatId,"||",2)),"^",2)
	s:BillSubCatId'="" BillCat=$p(^ARCBG(+BillSubCatId),"^",2)
	s:PriorId'="" Priority=$p(^OECPR(PriorId),"^",2)
	s:EffDate'="" EffDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(EffDate)
	s:EffDateTo'="" EffDateTo=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(EffDateTo)
	s ArcAlias=##class(web.DHCST.ARCALIAS).GetArcAlias(ArcimId)
	
	s (scDr,scDesc,acDr,acDesc,mcDr,mcDesc,icDr,icDesc,ocDr,ocDesc,ecDr,ecDesc,newmcDr,newmcdesc)=""
	s tariffdr=$o(^DHCOLT(0,"ARTTA",ArcimId,""))
	s tariCode="",tariDesc=""
	i tariffdr'="" d
	.
	.s tariCode=$p($g(^DHCTARI(tariffdr)),"^",1)  //收费代码
	.s tariDesc=$p($g(^DHCTARI(tariffdr)),"^",2)  //收费名称
	.s tariDesc=##class(web.DHCSTEXTCOMMON).GetValue(tariDesc)
	.s scDr=$p($g(^DHCTARI(tariffdr)),"^",4)					;子分类
	.i scDr'="" s scDesc=$p($g(^DHCTarC("SC",scDr)),"^",2)
	.s acDr=$p($g(^DHCTARI(tariffdr)),"^",5)					;会计子分类
	.i acDr'="" s acDesc=$p(^DHCTarC("AC",acDr),"^",2)
	.s mcDr=$p($g(^DHCTARI(tariffdr)),"^",6)					;病历首页分类
	.i mcDr'="" s mcDesc=$p($g(^DHCTarC("MC",mcDr)),"^",2)
	.s icDr=$p($g(^DHCTARI(tariffdr)),"^",14)					;住院子分类
	.i icDr'="" s icDesc=$p($g(^DHCTarC("IC",icDr)),"^",2)
	.s ocDr=$p($g(^DHCTARI(tariffdr)),"^",15)					;门诊子分类
	.i ocDr'="" s ocDesc=$p($g(^DHCTarC("OC",ocDr)),"^",2)
	.s ecDr=$p($g(^DHCTARI(tariffdr)),"^",16)					;核算子分类
	.i ecDr'="" s ecDesc=$p($g(^DHCTarC("EC",ecDr)),"^",2)
	.s newmcDr=$p($g(^DHCTARI(tariffdr)),"^",30)               ;新病案首页
	.i newmcDr'="" s newmcdesc=$p($g(^DHCTarC("MCNew",newmcDr)),"^",2)
	s DHCArcimId=$O(^DHCItmMast("0","ARCIM",ArcimId,""),-1)
	;医嘱项附加表信息（医生站表）
	s LimitQty=$s(DHCArcimId'="":$p($g(^DHCItmMast(DHCArcimId)),"^",10),1:"")
	s WarningUseQty=$s(DHCArcimId'="":$p($g(^DHCItmMast(DHCArcimId)),"^",12),1:"")
	s freeDrugFlag=##class(web.DHCST.Common.DrugInfoCommon).CheckIfFreeDrug(ArcimId)
	;
	s ArcDesc=##class(web.DHCSTEXTCOMMON).GetValue(ArcDesc)
	s Data1=PhcdfId_"^"_ArcCode_"^"_ArcDesc_"^"_BillUomId_"^"_$g(BillUomDesc)_"^"_ArcSubCatId_"^"_$g(ArcSubCat) // 7
	s Data2=BillCat_"^"_BillSubCatId_"^"_$g(BillSubCat)_"^"_OwnFlag_"^"_PriorId_"^"_$g(Priority)_"^"_WoStock  // 14
	s Data3=InsuDesc_"^"_SX_"^"_MaxQty_"^"_NoOfCumDays_"^"_MaxQtyPerDay_"^"_MaxCumDose_"^"_RestrictEM //21
	s Data4=RestrictIP_"^"_RestrictOP_"^"_RestrictHP_"^"_OeMessage_"^"_EffDate_"^"_EffDateTo_"^"_$g(OrdCat)_"^"_$g(OrdCatId)_"^"_ArcAlias //30
	s Data5=scDr_"^"_scDesc_"^"_acDr_"^"_acDesc_"^"_mcDr_"^"_mcDesc_"^"_icDr_"^"_icDesc_"^"_ocDr_"^"_ocDesc			//40
	s Data6=ecDr_"^"_ecDesc_"^"_tariCode_"^"_tariDesc_"^"_newmcDr_"^"_newmcdesc_"^"_LimitQty_"^"_WarningUseQty_"^"_freeDrugFlag
	s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6
	
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

/// Descript:新病案首页
/// BianShuai
ClassMethod UpdateTarItemBL(TariRowID, BLNew, UpUser = "")
{

	 S UpOldInfo=$p(^DHCTARI(TariRowID),"^",30)
	 s $p(^DHCTARI(TariRowID),"^",30)=BLNew
	 K PLIST
	 s ItemCodeDr=$o(^DHCTARITEMFIELDCONFIG(0,"Plist","dhc_taritem","PLIST(22)",""),-1)
	 s PLIST(2)=TariRowID
	 s PLIST(3)=ItemCodeDr
	 s PLIST(4)=UpOldInfo
	 s PLIST(5)=BLNew
	 s UpDate=+$h,PLIST(6)=UpDate
	 s UpTime=$p($h,",",2),PLIST(7)=UpTime
	 s PLIST(8)=UpUser
	 &SQL(insert into DHCTaritemUpdInfo values PLIST())
	 q ""
}

/// Descript:   检查计价单位和基本单位之间是否存在转换关系
/// Creator:	hulihua
/// CreateDate:	2014-12-29
/// Table:      CT_UOM
/// Input:
/// Output:		
/// Return：    0不存在,1存在
/// W ##class(web.DHCST.ARCITMMAST).CheckBillUomDr("30","19")
ClassMethod CheckBillUomDr(BillUomDr, BuomId) As %String
{
	n (BillUomDr,BuomId)
	q:BillUomDr="" 0
	q:BuomId="" 0
	s Flag=0
	s rowid=""
	s rowid=$o(^CT("CTCF",0,"UOM",BillUomDr,BuomId,rowid))
	i rowid'="" d       
	.s fac=$p(^CT("CTCF",rowid),"^",3)
	.s fac=$p(fac,$c(1))
	.s Flag=1
	e  d
	.s Flag=0 
	q Flag
}

/// Descript: 增加皮试关联医嘱项
/// Creater: wwl
/// CreateDate: 2016-03-07
/// Table:ARC_SKININFO
/// Input:医嘱项id,id^库存id2^医嘱项ID2,...
/// Output:
/// Return：0,成功;错误数据串：保存失败
/// ##class(web.DHCST.INCALIAS).SaveSktInfo("397||1","^409")
ClassMethod SaveSktInfo(Arcimdr, ListData, StrParam = "") As %Library.String
{
    n (Skindr,Arcimdr,ListData,StrParam,%session)
    q:Arcimdr="" -1
    q:(Arcimdr'="")&(ListData="") Arcimdr 
    s ArcDesc=$p(^ARCIM(+Arcimdr,$p(Arcimdr,"||",2),1),"^",2) 
    s AppName="DHCSTCOMMON"
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s Len=$l(ListData,rowDelim)
    s ErrData=""
    s ResultString=""
    f i=1:1:Len  d
    .s RowData=$p(ListData,rowDelim,i)
    .s Skindr=$p(RowData,"^",1)
    .s Inci=$p(RowData,"^",2)
    .s LinkArcItm=$p(RowData,"^",3)
    .i LinkArcItm'="" d
    ..s SkArc=LinkArcItm
    ..s InciCode=$p(^ARCIM(+SkArc,$p(SkArc,"||",2),1),"^",1) 
    ..s InciDesc=$p(^ARCIM(+SkArc,$p(SkArc,"||",2),1),"^",2) 
    .e  d
    ..s InciCode=$p(^INCI(Inci,1),"^",1)
    ..s InciDesc=$p(^INCI(Inci,1),"^",2)
    ..s SkArc=$p(^INCI(Inci,1),"^",3)
    .i Skindr'=""  d
    ..s tmpArc=$p(^ARCSKT(Skindr),"^",2)
    ..s tmpArcDesc=$p(^ARCIM(+tmpArc,$p(tmpArc,"||",2),1),"^",2) 
    ..s OldJsonStr="{皮试关联id:"""_Skindr_""",药品名称:"""_tmpArcDesc_"""}"
    ..&sql(Update ARC_SKTINFO Set SKT_REARCIM_DR=:SkArc Where SKT_ROWID=:Skindr)
    ..i SQLCODE'=0 d
    ...s ErrData=ErrData_","_Skindr_"&"_SkArc
    ..e  d
    ...s JsonStr="{皮试关联id:"""_Skindr_""",药品名称:"""_InciDesc_"""}"
    ...s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    ...i RecordTraceFlag="Y" d
 	....d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("ARC_SKTINFO","User.ARCSKTINFO","皮试关联医嘱项",Arcimdr,ArcDesc,"U",JsonStr,OldJsonStr)
    .e  d
    ..;保存
    ..s rowid=$o(^ARCSKTi("SKINTEST",Arcimdr,SkArc,""))
    ..q:rowid'=""
    ..&sql(INSERT INTO ARC_SKTINFO (SKT_ARCIM_DR,SKT_REARCIM_DR) VALUES (:Arcimdr,:SkArc))
    ..i SQLCODE'=0 d
    ...s ErrData=ErrData_","_Skindr_"&"_SkArc
    ...s rett=$$ErrorRecord^DHCSTERROR("SaveSkinTestArc:arc",Arcimdr,SQLCODE_":"_%msg)
    ..e  d
    ... s tmpSkdr=$P(%ROWID,$C(1)) 
    ... s JsonStr="{皮试关联id:"""_tmpSkdr_""",药品名称:"""_InciDesc_"""}"
    ... s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    ... i RecordTraceFlag="Y" d
 	.... d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("ARC_SKTINFO","User.ARCSKTINFO","皮试关联医嘱项",Arcimdr,ArcDesc,"A",JsonStr)
    ..q:ErrData'=""
    .
    q:ErrData'="" ErrData
    q 0
}

/// Descript: 查询皮试关联医嘱项
/// Creater: wwl
/// CreateDate: 2016-03-07
/// Table:ARC_SKININFO
/// Input:医嘱项id
/// Output:
/// Return：关联皮试医嘱信息
/// .i SkinStr="" d
/// ..s SkinStr=Skindr_"^"_SkArccode_"^"_SkArcdesc
/// .e d
/// ..s SkinStr=SkinStr_"/"_Skindr_"^"_SkArccode_"^"_SkArcdesc
/// w ##class(web.DHCST.ARCITMMAST).GetSktInfo("858||1")
ClassMethod GetSktInfo(Arcimdr) As %Library.String
{

    n (Arcimdr)
    //q:inci="" ""
    //s Arcimdr=$p(^INCI(inci,1),"^",3)
    q:Arcimdr="" ""
    s json = ##class(Code.JsonObj).%New()
    //s SkinRowid="",InciDr="",InciCode="",InciDesc=""
    s SkinStr=""
    s count=0
    s SkArc=0
    f  s SkArc=$o(^ARCSKTi("SKINTEST",Arcimdr,SkArc)) q:SkArc=""  d
    .s Skindr=""
    .f  s Skindr=$o(^ARCSKTi("SKINTEST",Arcimdr,SkArc,Skindr)) q:Skindr=""  d
    ..s SkArcdesc=$p(^ARCIM(+SkArc,$p(SkArc,"||",2),1),"^",2)
    ..s SkArccode=$p(^ARCIM(+SkArc,$p(SkArc,"||",2),1),"^",1)
    ..s Inci=$o(^INCI(0,"ARCIM_DR",$p(SkArc,"||",1),"")) 
    ..s SkinStr=Skindr_"^"_Inci_"^"_SkArccode_"^"_SkArcdesc
    ..d json.InsertRowData(SkinStr)
    ..s count = count+1 
    s Title="SkinRowid^InciDr^InciCode^InciDesc"
    s resultString = json.getJsonData(Title,count)
    k json
    q resultString
}

/// Descript: 删除皮试关联
/// Creater: wwl
/// CreateDate: 2016-03-7
/// Table:ARC_SKININFO
/// Input:皮试关联医嘱id
/// Output:
/// Return：0,成功;-1:没有要删除的记录；-2：操作失败
ClassMethod DeleteSktInfo(SkinRowid, StrParam = "") As %Library.String
{
    n (SkinRowid,StrParam,%session)
    q:SkinRowid="" -1
    s AppName="DHCSTCOMMON"
    s Err=0
    s tmpArc=$p(^ARCSKT(SkinRowid),"^",1)
    s tmpArcCode=$p(^ARCIM(+tmpArc,$p(tmpArc,"||",2),1),"^",1) 
    s tmpArcDesc=$p(^ARCIM(+tmpArc,$p(tmpArc,"||",2),1),"^",2) 
    &sql(Delete From ARC_SKTINFO Where SKT_ROWID=:SkinRowid)
    i SQLCODE'=0 d
    .s rett=$$ErrorRecord^DHCSTERROR("DeleteSkinTestArc:arc",SkinRowid,SQLCODE_":"_%msg)
    .s Err=-2
    .
    e  d
    . s JsonStr="{皮试关联id:"""_SkinRowid_"""}"
    . s RecordTraceFlag=##class(web.DHCST.Common.AppCommon).GetAppPropValue(AppName,"RecordTraceFlag","")
    . i RecordTraceFlag="Y" d
 	..d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("ARC_SKTINFO","User.ARCSKTINFO","皮试关联医嘱项",tmpArc,tmpArcDesc,"D",JsonStr)
    q Err
}

/// creator:    yunhaibao
/// createdate: 2017-06-27
/// description:查询医嘱项query
/// input:strParams(处方通用名ID^代码^描述^别名)
/// w ##class(%ResultSet).RunQuery("web.DHCST.ARCITMMAST","QueryArcItmMast","225^^^^93")
Query QueryArcItmMast(strParams) As websys.Query(ROWSPEC = "arcItmRowId:%String,arcItmCode:%String,arcItmDesc:%String,genericId:%String,genericDesc:%String,billUom,arcItmCat,ordCategory,arcItmStopDate,phcForm,phcInstu,phcDura,phcFreq,phcManf,phcBasicDrug,phcPoison")
{
}

ClassMethod QueryArcItmMastExecute(ByRef qHandle As %Binary, strParams) As %Status
{
	n (qHandle,strParams)
	//s ^hlh($this)=strParams
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:strParams="needNull" $$$OK
	s inputGeneId=$p(strParams,"^",1)
	s inputCode=$zcvt($p(strParams,"^",2),"U")
	s inputDesc=$zcvt($p(strParams,"^",3),"U")
	s inputAlias=$zcvt($p(strParams,"^",4),"U")
	s inputPhcCat=$p(strParams,"^",5)
	s phcCatList=##class(web.DHCST.PHCCATMAINTAIN).GetChildrenNodes(inputPhcCat)
	i inputPhcCat'="" d
	.i phcCatList'="" s phcCatList=inputPhcCat_","_phcCatList
	.e  s phcCatList=inputPhcCat
	s phcCatList=$lfs(phcCatList,",")
	i inputGeneId'="" d
	.s arcItmSub=""
	.f  s arcItmSub=$o(^ARCIM(0,"Gener",inputGeneId,arcItmSub)) q:arcItmSub=""  d
	..q:+arcItmSub=0
	..s arcItmVer=""
	..f  s arcItmVer=$o(^ARCIM(0,"Gener",inputGeneId,arcItmSub,arcItmVer)) q:arcItmVer=""  d
	...q:+arcItmVer=0
	...d getDetailData
	e  d
	.s arcOrderType="R"
	.s arcItemCatId=""
	.f  s arcItemCatId=$o(^ARC("IC",0,"OrderType",arcOrderType,arcItemCatId)) q:arcItemCatId=""  d
	..q:+arcItemCatId=0
	..s arcItmSub=""
	..f  s arcItmSub=$o(^ARCIM(0,"ARCIC_DR",arcItemCatId,arcItmSub)) q:arcItmSub=""  d
	...q:+arcItmSub=0
	...s arcItmVer=""
	...f  s arcItmVer=$o(^ARCIM(0,"ARCIC_DR",arcItemCatId,arcItmSub,arcItmVer)) q:arcItmVer=""  d
	....q:+arcItmVer=0
	....d getDetailData
	Quit $$$OK
getDetailData
	s arcItmRowId=arcItmSub_"||"_arcItmVer
	s arcItmObj=##class(User.ARCItmMast).%OpenId(arcItmRowId,0)
	q:(inputAlias'="")&&(+##class(web.DHCST.ARCALIAS).CheckArcAliasExist(arcItmRowId,inputAlias)<0)
	s arcItmCode=arcItmObj.ARCIMCode
	s arcItmDesc=arcItmObj.ARCIMDesc
	q:(inputCode'="")&&($zcvt(arcItmCode,"U")'[inputCode)
	q:(inputDesc'="")&&($zcvt(arcItmDesc,"U")'[inputDesc)
	s genericObj=arcItmObj.ARCIMGenericDR
	q:(inputPhcCat'="")&&(genericObj="")
	s quitFlag="",phcCatId=""
	i genericObj'="" d
	.s genericId=genericObj.%Id()
	.s genericDesc=genericObj.PHCGEName
	.s chemicalId=$p($g(^PHCGE("GE",genericId,"DHC")),"^",3)
	.i (inputPhcCat'="")&&(chemicalId="") s quitFlag=1
	.i chemicalId'="" d 
	..s phcCatId=$p($g(^DHCPHCM(chemicalId)),"^",3)
	..i (inputPhcCat'="")&&($lf(phcCatList,phcCatId)=0) s quitFlag=1
	e  s (genericId,genericDesc)=""
	q:quitFlag'=""
	q:(inputGeneId'="")&&(inputGeneId'=genericId)
	s arcItmMastData=##class(web.DHCST.ARCITMMAST).Select(arcItmRowId)
	/// 医嘱大类
	s ordCategory=$p(arcItmMastData,"^",28)
	/// 医嘱子类
	s arcItmCat=$p(arcItmMastData,"^",7)
	/// 计价单位
	s billUom=$p(arcItmMastData,"^",5)
	/// 截止日期
	s arcItmStopDate=$p(arcItmMastData,"^",27)
	s phcdfRowId=##class(web.DHCST.Common.DrugInfoCommon).GetPhcdfByArcim(arcItmRowId)
	q:phcdfRowId=""
	s phcMastData=##class(web.DHCST.PHCDRGMAST).Select(phcdfRowId)
	/// 剂型
	s phcForm=$p(phcMastData,"^",4)
	/// 用法
	s phcInstu=$p(phcMastData,"^",8)
	/// 疗程
	s phcDura=$p(phcMastData,"^",10)
	/// 频次
	s phcFreq=$p(phcMastData,"^",17)
	/// 厂商
	s phcManf=$p(phcMastData,"^",13)
	/// 基本药物
	s phcBasicDrug=$p(phcMastData,"^",62)
	/// 管制分类
	s phcPoison=$p(phcMastData,"^",15)
	d outputRow
	q
outputRow   
	s Data=$lb(arcItmRowId,arcItmCode,arcItmDesc,genericId,genericDesc,billUom,arcItmCat,ordCategory,arcItmStopDate,phcForm,phcInstu,phcDura,phcFreq,phcManf,phcBasicDrug,phcPoison)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// creator:    yunhaibao
/// createdate: 2017-06-27
/// description:根据医嘱项ID查询医嘱项相关信息,用于药品维护初始化显示
/// input:		strParams(医嘱项ID)
/// w ##class(%ResultSet).RunQuery("web.DHCST.ARCITMMAST","QueryArcByArcim","1410||1")
Query QueryArcByArcim(strParams = "") As websys.Query(ROWSPEC = "txtArcCode,txtArcDesc,cmbArcBillGrp,cmbArcBillSub,cmbOrdCategory,cmbArcCat,cmbOECPriority,cmbBillUom,dtArcEffDate,dtArcEffDateTo,txtArcMaxQty,txtArcMaxCumDose,txtArcMaxQtyPerDay,chkOrderOnItsOwn,chkWoStock,chkRestrictOP,chkRestrictEM,chkRestrictIP,chkRestrictHP,txtOeMessage,txtArcNoOfCumDays,txtLimitQty,txtWarningUseQty,chkFreeDrugFlag")
{
}

ClassMethod QueryArcByArcimExecute(ByRef qHandle As %Binary, strParams = "") As %Status
{
	n (qHandle,strParams)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s arcItmRowId=$p(strParams,"^",1)
	q:arcItmRowId="" $$$OK
	s arcItmMastData=..Select(arcItmRowId)
	/// 医嘱项代码
	s arcItmCode=$p(arcItmMastData,"^",2)
	/// 医嘱项描述
	s arcItmDesc=$p(arcItmMastData,"^",3)
	/// 费用子类
	s arcBillSub=$p(arcItmMastData,"^",9)
	/// 费用大类
	s arcBillGrp=$p(arcBillSub,"||",1)
	/// 医嘱大类
	s ordCategory=$p(arcItmMastData,"^",29)
	/// 医嘱子类
	s arcCat=$p(arcItmMastData,"^",6)
	/// 医嘱优先级
	s oecPriority=$p(arcItmMastData,"^",12)
	/// 计价单位
	s billUom=$p(arcItmMastData,"^",4)
	/// 生效日期
	s arcEffDate=$p(arcItmMastData,"^",26)
	/// 截止日期
	s arcEffDateTo=$p(arcItmMastData,"^",27)
	/// 最大量
	s arcMaxQty=$p(arcItmMastData,"^",17)
	s arcMaxQty=##class(web.DHCST.Common.UtilCommon).AddZero(arcMaxQty)
	/// 单次最大量
	s arcMaxCumDose=$p(arcItmMastData,"^",20)
	s arcMaxCumDose=##class(web.DHCST.Common.UtilCommon).AddZero(arcMaxCumDose)
	/// 每天最大量
	s arcMaxQtyPerDay=$p(arcItmMastData,"^",19)
	s arcMaxQtyPerDay=##class(web.DHCST.Common.UtilCommon).AddZero(arcMaxQtyPerDay)
	/// 独立医嘱
	s orderOnItsOwn=$p(arcItmMastData,"^",11)
	/// 无库存医嘱
	s woStock=$p(arcItmMastData,"^",14)
	/// 门诊用药
	s restrictOP=$p(arcItmMastData,"^",23)
	/// 急诊用药
	s restrictEM=$p(arcItmMastData,"^",21)
	/// 住院用药
	s restrictIP=$p(arcItmMastData,"^",22)
	/// 体检用药
	s restrictHP=$p(arcItmMastData,"^",24)
	/// 医嘱提示
	s oeMessage=$p(arcItmMastData,"^",25)
	/// 限制使用天数
    s arcNoOfCumDays=$p(arcItmMastData,"^",18)
    s arcNoOfCumDays=##class(web.DHCST.Common.UtilCommon).AddZero(arcNoOfCumDays)
    /// 限制用量
    s LimitQty=$p(arcItmMastData,"^",47)
    /// 极限用量
	s WarningUseQty=$p(arcItmMastData,"^",48)
	/// 免费药
	s freeDrugFlag=$p(arcItmMastData,"^",49)
	s Data=$lb(arcItmCode,arcItmDesc,arcBillGrp,arcBillSub,ordCategory,arcCat,oecPriority,billUom,arcEffDate,arcEffDateTo,arcMaxQty,arcMaxCumDose,arcMaxQtyPerDay,orderOnItsOwn,woStock,restrictOP,restrictEM,restrictIP,restrictHP,oeMessage,arcNoOfCumDays,LimitQty,WarningUseQty,freeDrugFlag)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q $$$OK
}

/// creator:    yunhaibao
/// createdate: 2017-07-03
/// description:保存医嘱项返回错误代码的汉字描述
/// input:		errCode
/// return:     错误信息
/// w ##class(web.DHCST.ARCITMMAST).ErrCodeToDesc("-82")
ClassMethod ErrCodeToDesc(errCode = "")
{
	n (errCode)
	q:errCode=-20 "代码不能为空"
	q:errCode=-21 "描述不能为空"
	q:errCode=-21 "计价单位不能为空"
	q:errCode=-23 "费用大类不能为空"
	q:errCode=-24 "费用子类不能为空"
	q:errCode=-25 "医嘱子类不能为空"
	q:errCode=-26 "药学ID不能为空"
	q:errCode=-27 "无效的医嘱子类"
	q:errCode=-28 "无效的费用大类"
	q:errCode=-29 "无效的费用子类"
	q:errCode=-30 "无效的药学项"
	q:errCode=-31 "无效的计价单位"
	q:errCode=-32 "代码重复"
	q:errCode=-33 "名称重复"
	q:errCode=-81 "插入医嘱项主表失败"
	q:errCode=-82 "插入医嘱项附加表失败"
	q:errCode=-83 "插入医嘱项别名失败"
	q ""
}

/// creator:    yunhaibao
/// createdate: 2017-07-11
/// description:查询医嘱项下拉的query
/// input:strParams
/// w ##class(%ResultSet).RunQuery("web.DHCST.ARCITMMAST","GetArcItmMast","","2||1")
Query GetArcItmMast(strParams = "", arcimId = "", HospId = "") As websys.Query(ROWSPEC = "arcItmRowId:%String,arcItmCode:%String,arcItmDesc:%String")
{
}

ClassMethod GetArcItmMastExecute(ByRef qHandle As %Binary, strParams = "", arcimId = "", HospId = "") As %Status
{
	n (qHandle,strParams,arcimId,HospId)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:(strParams="")&&(arcimId="") $$$OK
	s inputAlias=$zcvt($p(strParams,"^",1),"U")
	i arcimId'="" d
	.s arcItmSub=+arcimId
	.s arcItmVer=1
	.d GetArcItmMastData
	e  d
	.s arcItmSub=""
	.f  s arcItmSub=$o(^ARCIM(arcItmSub)) q:arcItmSub=""  d
	..q:+arcItmSub=0
	..s arcItmVer=""
	..f  s arcItmVer=$o(^ARCIM(arcItmSub,arcItmVer)) q:arcItmVer=""  d
	...q:+arcItmVer=0
	...d GetArcItmMastData
	q $$$OK	
GetArcItmMastData
	s arcItmRowId=arcItmSub_"||"_arcItmVer
	s effDate = $p($g(^ARCIM(arcItmSub,arcItmVer,1)),"^",13)
	s effDate = $p(effDate,"Z",1)
	q:(effDate'="")&&(effDate>+$h) // 未开始
	s effDateTo = $p($g(^ARCIM(arcItmSub,arcItmVer,7)),"^",1)
	q:(effDateTo'="")&&(effDateTo<+$h) // 已截止
	s flag=##class(PHA.FACE.IN.Com).GetShowDataFlag("ARC_ItmMast",arcItmRowId,HospId) //医院级别授权
	q:flag="N"
	s arcItmObj=##class(User.ARCItmMast).%OpenId(arcItmRowId,0)
	s arcItmCatObj=arcItmObj.ARCIMItemCatDR
	s arcItmCatType=""
	i arcItmCatObj'="" d
	.s arcItmCatType=arcItmCatObj.ARCICOrderType
	q:arcItmCatType'="R"
	q:(inputAlias'="")&&(+##class(web.DHCST.ARCALIAS).CheckArcAliasExist(arcItmRowId,inputAlias)<0)
	s arcItmCode=arcItmObj.ARCIMCode
	s arcItmDesc=arcItmObj.ARCIMDesc 
	s Data=$lb(arcItmRowId,arcItmCode,arcItmDesc,genericId,genericDesc)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// creator:    yunhaibao
/// createdate: 2017-07-11
/// description:查询医嘱皮试关联列表
/// input:strParams
/// w ##class(%ResultSet).RunQuery("web.DHCST.ARCITMMAST","GetSktInfo","41||1")
Query GetSktInfo(strParams) As websys.Query(ROWSPEC = "sktId,arcItmId,arcItmCode,arcItmDesc")
{
}

ClassMethod GetSktInfoExecute(ByRef qHandle As %Binary, strParams) As %Status
{
	n (qHandle,strParams)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:strParams="" $$$OK
	s arcItmId=$p(strParams,"^",1)
    s skArc=0
    f  s skArc=$o(^ARCSKTi("SKINTEST",arcItmId,skArc)) q:skArc=""  d
    .s skinDr=""
    .f  s skinDr=$o(^ARCSKTi("SKINTEST",arcItmId,skArc,skinDr)) q:skinDr=""  d
    ..s arcItmDesc=$p(^ARCIM(+skArc,$p(skArc,"||",2),1),"^",2)
    ..s arcItmCode=$p(^ARCIM(+skArc,$p(skArc,"||",2),1),"^",1)
	..s Data=$lb(skinDr,skArc,arcItmCode,arcItmDesc)
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	q $$$OK
}

}
