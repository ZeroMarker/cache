Import sqluser

/// Descript:医嘱项信息相关
/// Creater:	XuChao
/// CreateDate:	2018-07-31
Class web.DHCSTMHUI.ARCITMMAST Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	保存医嘱项信息
/// Creater:	XuChao
/// CreateDate:	2018-08-1
/// Table:ARC_ItmMast
/// Input:医嘱项rowid,医嘱项代码^描述^账单单位id^医嘱子类id^费用大类id^费用子类id^独立医嘱标志^默认医嘱优先级id
/// ^无库存医嘱标志^别名^简称^限制使用天数^医嘱提示^是否维护收费项目标志^生效日期^截止日期^医嘱大类
/// ^收费子分类^住院子分类^门诊子分类^核算子分类^病历首页子分类^会计子分类
ClassMethod Save(ArcimId As %String, listData As %String, ArcCode As %String, Hosp = "") As RtnObj
{
	n (ArcimId,listData,ArcCode,Hosp,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(listData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	
	s OldArcId=ArcimId	
	s UserId=PJObj.%Get("gUserId")
	s ArcDesc=PJObj.%Get("ArcDesc")					;医嘱名称
	s BillUomId=PJObj.%Get("BillUom")				;账单单位id
	s ArcSubCatId=PJObj.%Get("OrdSubCat")			;医嘱子类id
	s BillCatId=PJObj.%Get("BillCat")				;费用大类id
	s BillSubCatId=PJObj.%Get("BillSubCat")			;费用子类id
	s OwnFlag=PJObj.%Get("OwnFlag")					;独立医嘱标志
	s PriorId=PJObj.%Get("Priority")				;默认医嘱优先级id
	s WoStock=PJObj.%Get("WoStock")					;无库存医嘱标志
	s NoOfCumDays=PJObj.%Get("NoOfCumDays")			;限制使用天数
	s OeMessage=PJObj.%Get("OeMessage")				;医嘱提示
	s AliasStr=PJObj.%Get("ArcAlias")				;别名
	s SX=PJObj.%Get("ArcAbbrev")					;医嘱简称
	s EffDate=PJObj.%Get("EffDate")					;生效日期
	s EffDateTo=PJObj.%Get("EffDateTo")				;截止日期
	s UpdTarFlag=PJObj.%Get("FeeFlag")				;不维护收费项

	i ArcCode="" q RtnObj.Err(-1,"","医嘱项代码不能为空!","",0)
	i ArcDesc="" q RtnObj.Err(-1,"","医嘱项名称不能为空!","",0)
	i BillUomId="" q RtnObj.Err(-1,"","账单单位不能为空!","",0)
	i BillCatId="" q RtnObj.Err(-1,"","费用大类不能为空!","",0)
	i BillSubCatId="" q RtnObj.Err(-1,"","费用子类不能为空!","",0)
	i ArcSubCatId="" q RtnObj.Err(-1,"","医嘱子类不能为空!","",0)
	i '$d(^ARC("IC",ArcSubCatId)) q RtnObj.Err(-1,"","无效的医嘱子分类!","",0)
	i '$d(^ARCBG(BillCatId)) q RtnObj.Err(-1,"","无效的费用大类!","",0)
	i '$d(^ARCBG(+BillSubCatId,"SG",$p(BillSubCatId,"||",2))) q RtnObj.Err(-1,"","无效的费用子类","",0)
	i '$d(^CT("UOM",BillUomId)) q RtnObj.Err(-1,"","无效的账单单位!")
	s codeOnlyFlag=##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("CodeOnly")
	i codeOnlyFlag="Y" d
	.s TmpId=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),"")) 
	e  d	
	.s TmpId=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",ArcCode,"ARC_ItmMast",Hosp,ArcimId)	
	i (TmpId'="")&&(+ArcimId'=+TmpId) q RtnObj.Err(-1,"","医嘱项代码已经存在,不能重复!","",0)
		
	i EffDate'=""  d
	.s EffDate=..DH2L(EffDate)
	e  d
	.s EffDate=+$h
	i EffDateTo'=""  d
	.s EffDateTo=..DH2L(EffDateTo)
	s EffTime=$p($h,",",2)
	s MemoDelim=##class(web.DHCSTMHUI.Common.UtilCommon).MemoDelim()
	s OeMessage=$lfs(OeMessage,MemoDelim)	
	//保存医嘱项
	i ArcimId=""  d	;新增
	.s ArcObj=##class(User.ARCItmMast).%New()
	e  d			;更新
	.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("ARC_ItmMast",ArcimId)
	.s ArcObj=##class(User.ARCItmMast).%OpenId(ArcimId)
	.d ArcObj.%Reload()
	s ArcObj.ARCIMCode=ArcCode							;医嘱项代码
	s ArcObj.ARCIMDesc=ArcDesc							;医嘱项名称
	s ArcObj.ARCIMAbbrev=ArcDesc						;医嘱项简称
	d ArcObj.ARCIMItemCatDRSetObjectId(ArcSubCatId)		;医嘱子类
	d ArcObj.ARCIMBillSubDRSetObjectId(BillSubCatId)	;费用子类
	s ArcObj.ARCIMEffDate=EffDate						;生效日期
	s ArcObj.ARCIMEffTime=EffTime						;生效时间
	s ArcObj.ARCIMOrderOnItsOwn=OwnFlag					;独立医嘱
	s ArcObj.ARCIMAllowOrderWOStockCheck=WoStock		;无库存标志
	d ArcObj.ARCIMBillingUOMDRSetObjectId(BillUomId)	;账单单位
	d ArcObj.ARCIMDefPriorityDRSetObjectId(PriorId)		;优先级
	s ArcObj.ARCIMNoOfCumDays=NoOfCumDays				;限制使用天数
	s ArcObj.ARCIMEffDateTo=EffDateTo					;截至日期
	d ArcObj.ARCIMOEMessage.Clear()						;医嘱提示
	d ArcObj.ARCIMOEMessage.InsertList(OeMessage)
	s ArcObj.ARCIMChgPostFlg="O"
	s ArcObj.ARCIMServMaterial="M"						;服务/材料
	s Sc=ArcObj.%Save()
	i $$$ISERR(Sc) d
	.s DataStr1=ArcCode_","_ArcDesc_","_ArcSubCatId_","_BillSubCatId_","_EffDate_","_EffTime_","_OwnFlag
	.s DataStr2=WoStock_","_BillUomId_","_PriorId_","_NoOfCumDays_","_EffDateTo
	.s DataStr=DataStr1_","_DataStr2
	.d RtnObj.Err(-6,"",DataStr_$ClassName()_".Save:")
	e  d
	.i ArcimId="" d
	..s ArcimId=ArcObj.%Id()
	..s RtnObj=##class(Log).SaveLog("ARC_ItmMast","User.ARCItmMast","医嘱项主表信息(物资)",ArcimId,ArcDesc,"A")
	.e  d
	..s RtnObj=##class(Log).SaveLog("ARC_ItmMast","User.ARCItmMast","医嘱项主表信息(物资)",ArcimId,ArcDesc,"U","",OldJsonStr)
	q:RtnObj.success'=0 RtnObj
	//保存别名
	s ListAlias=""
	i OldArcId=""  d
	.s ListAlias=..CreateAlias(ArcimId)    //新增时自动生成别名
	.i ListAlias'=""  d
	..s FormatAliasStr=$$FormatAlias(ListAlias)
	..s RtnObj=##class(web.DHCSTMHUI.ARCALIAS).Save(ArcimId,FormatAliasStr)
	q:RtnObj.success'=0 RtnObj
	s Ret=##class(web.DHCSTMHUI.Common.ServiceCommon).UpdateArcAlias(ArcimId)
	i +Ret<0 q RtnObj.Err(-8,"","更新医嘱项别名表失败!","",0)
	//保存收费项
	i (UpdTarFlag'="Y")&(ArcimId'="") d
	.s RtnObj=..AddTarItem(ArcimId,listData,Hosp)
	.q:RtnObj.success'=0
	.s RtnObj=..AddTarItmAlias(ArcimId,ListAlias)
	.q:RtnObj.success'=0
	q:RtnObj.success'=0 RtnObj
	//关联院区
	s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveArcHOSP(ArcimId,Hosp)
	i ret'=0 d RtnObj.Err(-6,"","关联医院医嘱项失败"_ret)
	q:RtnObj.success'=0 RtnObj
	s TarItm=$o(^DHCOLT(0,"ARTTA",ArcimId,""))
	i TarItm'="" d
	.s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_TarItem",TarItm,Hosp)
	.i +ret<0 d RtnObj.Err(-7,"","关联医院收费项失败"_ret)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
	
FormatAlias(AliasStr)
	n (AliasStr)
	s ResultAliasStr=""
	f i=1:1:$l(AliasStr,"^")  d
	.s Alias=$p(AliasStr,"^",i)
	.i ResultAliasStr=""  d
	..s ResultAliasStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Alias,"Alias")
	.e  d
	..s ResultAliasStr=ResultAliasStr_","_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Alias,"Alias")
	
	q "["_ResultAliasStr_"]"
}

/// Descript:根据医嘱项名称等自动生成别名
/// Creater:	ZhangDongmei
/// CreateDate:	2013-03-29
/// Table:ARC_Alias
/// Input:医嘱项rowid
/// Output:		
/// Return：医嘱项别名串
ClassMethod CreateAlias(ArcimId) As %Library.String
{
	n (ArcimId,%session)
	s paramStr=..sssParamStr()
	q:ArcimId="" ""
	s ArcDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
	q:ArcDesc="" ""
	s ArcCode=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",1)
	q:ArcCode="" ""
	;生成别名
	s ListAlias=""
	s AutoAddAAByDesc=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("AppName"),"AutoAddAAByDesc",paramStr)
	i AutoAddAAByDesc="Y"  d
	.s AliasByDesc=##class(web.DHCSTMHUI.Common.AppCommon).GetCNCODE(ArcDesc)
	.q:AliasByDesc=""
	.s ListAlias=AliasByDesc
	s AutoAddAAByCode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("AppName"),"AutoAddAAByCode",paramStr)
	i AutoAddAAByCode="Y"  d
	.s AliasByCode=ArcCode
	.q:AliasByCode=""
	.i ListAlias'=""  d
	..s ListAlias=ListAlias_"^"_AliasByCode
	.e  d
	..s ListAlias=AliasByCode
	.
	q ListAlias
}

/// Descript:保存收费项
/// Creater:	ZhangDongmei
/// CreateDate:	2013-04-25
/// Table:DHC_TarItem, DHC_OrderLinkTar
/// Input:		医嘱项rowid,TarCatStr, BUomId(基本单位)
/// Output:		
/// Return：0,成功
ClassMethod AddTarItem(ArcimId, listData, Hosp = "") As RtnObj
{
	n (ArcimId,listData,Hosp,%session)
	s RtnObj=##class(RtnObj).%New()
	i ArcimId="" d RtnObj.Err(-1,"","医嘱项Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(listData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s paramStr=..sssParamStr()
	s UserId=PJObj.%Get("gUserId")
	s BillUomId=PJObj.%Get("BillUom")			;账单单位id
	s TarSubCat=PJObj.%Get("TarSubCat")			;子分类
	s TarInpatCat=PJObj.%Get("TarInpatCat")		;住院子分类
	s TarOutpatCat=PJObj.%Get("TarOutpatCat")	;门诊子分类    
	s TarEMCCat=PJObj.%Get("TarEMCCat")			;核算子分类
	s TarAcctCat=PJObj.%Get("TarAcctCat")		;会计子分类
	s TarMRCat=PJObj.%Get("TarMRCat")			;病例首页
	s TarNewMRCat=PJObj.%Get("TarNewMRCat")		;新病历首页分类
	s TariCode=PJObj.%Get("TariCode")			;收费项代码
	s TariDesc=PJObj.%Get("TariDesc")			;收费项名称
	s ChargeBasis=PJObj.%Get("ChargeBasis")		;收费依据
	s TarDateTo=PJObj.%Get("TarDateTo")			;收费项结束日期
	i BillUomId="" q RtnObj.Err(-1,"","账单单位不能为空!","",0)
	i TarSubCat="" q RtnObj.Err(-1,"","子分类不能为空","",0)
	i TarInpatCat="" q RtnObj.Err(-1,"","住院子分类不能为空","",0)
	i TarOutpatCat="" q RtnObj.Err(-1,"","门诊子分类不能为空","",0)
	i TarEMCCat="" q RtnObj.Err(-1,"","核算子分类不能为空","",0)
	i TarAcctCat="" q RtnObj.Err(-1,"","会计子分类不能为空","",0)
	i TarMRCat="" q RtnObj.Err(-1,"","病案首页不能为空","",0)
	i TarNewMRCat="" q RtnObj.Err(-1,"","新病案首页不能为空","",0)
	s:TarDateTo'="" TarDateTo=..DH2L(TarDateTo)
	s ArcSub=+ArcimId
	s ArcVer=$p(ArcimId,"||",2)
	s:TariCode="" TariCode=$p(^ARCIM(ArcSub,ArcVer,1),"^",1)
	s:TariDesc="" TariDesc=$p(^ARCIM(ArcSub,ArcVer,1),"^",2)
	s Date=+$h
	
	s TarItm=$o(^DHCOLT(0,"ARTTA",ArcimId,""))
	s TmpTarItm=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("CODE",TariCode,"DHC_TarItem",Hosp,TarItm)
	i TmpTarItm'="" q RtnObj.Err(-1,"","收费项代码重复!"_TmpTarItm,"",0)
	;s TmpTarItm=##class(web.DHCSTMHUI.MatForBDPData).CodeDescIfRepeat("DESC",TariDesc,"DHC_TarItem",Hosp,TarItm)
	;i TmpTarItm'="" q RtnObj.Err(-1,"","收费项名称重复!"_TmpTarItm)
	s UpdateTarFollowArc=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTDRUGMAINTAINM","UpdateTarFollowArc",paramStr)
	i TarItm=""  d	;新增
	.s TarObj=##class(User.DHCTarItem).%New()
	e  d			;更新
	.s OldJsonStr=##class(web.DHCSTMHUI.Common.JsonObj).GetValue("DHC_TarItem",TarItm)
	.s TarObj=##class(User.DHCTarItem).%OpenId(TarItm)
	.d TarObj.%Reload()
	i ((UpdateTarFollowArc="Y"&&TarItm'="")||(TarItm="")) d	
	.s TarObj.TARICode=TariCode
	.s TarObj.TARIDesc=TariDesc
	d TarObj.TARIUOMSetObjectId(BillUomId)
	d TarObj.TARISubCateSetObjectId(TarSubCat)
	d TarObj.TARIAcctCateSetObjectId(TarAcctCat)
	d TarObj.TARIOutpatCateSetObjectId(TarOutpatCat)
	d TarObj.TARIEMCCateSetObjectId(TarEMCCat)
	d TarObj.TARIMRCateSetObjectId(TarMRCat)
	s TarObj.TARISpecialFlag="Y"
	s TarObj.TARIActiveFlag="Y"	
	d TarObj.TARIInpatCateSetObjectId(TarInpatCat)
	s TarObj.TARIMCNew=TarNewMRCat
	s TarObj.TARIChargeBasis=ChargeBasis
	s TarObj.TARIStartDate=Date
	s TarObj.TARIEndDate=TarDateTo
	s Sc=TarObj.%Save()
	i $$$ISERR(Sc) d
	.s DataStr=TariCode_","_TariDesc_","_BillUomId_","_TarSubCat_","_TarAcctCat_","_TarOutpatCat_","_TarEMCCat_","_TarMRCat_","_"Y"_","_"Y"_","_Date_","_TarInpatCat_","_TarNewMRCat_","_ChargeBasis
	.s Sc=$tr($System.Status.GetErrorText(Sc),$c(13,10,0,9))
	.d RtnObj.Err(-1,ArcimId,DataStr_$ClassName()_"保存收费项失败"_Sc)
	q:RtnObj.success'=0 RtnObj
	s Taritmdr=TarObj.%Id()
	//保存新病案首页
	d ..UpdateTarItemBL(Taritmdr,TarNewMRCat,UserId)
	i TarItm="" d
	.&SQL(INSERT INTO DHC_OrderLinkTar(OLT_Tariff_DR,OLT_ARCIM_DR,OLT_Qty,OLT_StartDate) 
		VALUES (:Taritmdr,:ArcimId,1,:Date))
	.i SQLCODE'=0  d
	..s DataStr=Taritmdr_","_ArcimId_","_1_","_Date
	..d RtnObj.Err(-2,ArcimId,DataStr_$ClassName()_"保存收费项失败:SQLCODE"_SQLCODE)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:保存收费项别名
/// Creater:	ZhangDongmei
/// CreateDate:	2013-04-25
/// Table:DHC_TarItem
/// Input:医嘱项rowid,别名1^别名2
/// Output:		
/// Return：0,成功
ClassMethod AddTarItmAlias(ArcimId, TarAliasStr) As RtnObj
{
	n (ArcimId,TarAliasStr)
	s RtnObj=##class(RtnObj).%New()
	q:$g(ArcimId)="" RtnObj
	q:$g(TarAliasStr)="" RtnObj
	s Len=$l(TarAliasStr,"^")
	s TarItm=""
	s TarItm=$o(^DHCOLT(0,"ARTTA",ArcimId,""))
	i TarItm="" q RtnObj
	;
	s Desc=$p(^DHCTARI(TarItm),"^",2)
	f i=1:1:Len q:RtnObj.success'=0  d
	.s Alias=$p(TarAliasStr,"^",i)
	.&SQL(INSERT INTO DHC_TarItemAlias(TIA_TARI_DR,TIA_Desc,TIA_Alias) VALUES
	(:TarItm,:Desc,:Alias))
	.i SQLCODE'=0  d
	..d RtnObj.Err(-1,"",TarItm_","_Desc_","_Alias_","_$ClassName()_".AddTarItmAlias:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// Descript:	更新医嘱项截止日期
/// Creater:	ZhangDongmei
/// CreateDate:	2012-09-14
/// Table:ARC_ItmMast
/// Input:医嘱项id,截止日期
/// Output:		
/// Return：0:成功;<0:失败
/// Remark: web.DHCSTMHUI.INCITM调用
ClassMethod UpdateEffDeteTo(ArcimRowid As %String, OldNotUseFlag As %String) As %Library.String
{
	n (ArcimRowid,OldNotUseFlag)
	s RtnObj=##class(RtnObj).%New()
	q:ArcimRowid="" RtnObj
	q:OldNotUseFlag="" RtnObj
	s EffDateTo=""
	s:OldNotUseFlag="N" EffDateTo=+$h
	;更新医嘱项主表
	&sql(Update Arc_ItmMast set ARCIM_EffDateTo=:EffDateTo where arcim_rowid=:ArcimRowid)
	i SQLCODE'=0  d
	.d RtnObj.Err(-11,ArcimRowid,"更新医嘱项截止日期失败"_$ClassName()_".UpdateEffDeteTo:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	q RtnObj
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
ClassMethod Delete(ArcimRowid) As %Library.String
{
	n (ArcimRowid,%session)
	s Sub=+ArcimRowid
	q:Sub'>0 0
	s Ver=$p(ArcimRowid,"||",2)
	q:'$d(^ARCIM(Sub,Ver)) 0
	s ArcimCode=$p(^ARCIM(Sub,Ver,1),"^",1)
	s ArcimDesc=$p(^ARCIM(Sub,Ver,1),"^",2)
	s JsonStr="{医嘱项代码:"_ArcimCode_",医嘱项名称:"_ArcimDesc_"}"
	s ResultString=""
	s Err=0
	tstart
	s $ZT=..sssError()						;增加错误处理
	;删除收费项
	s ret=..DeleteTarItem(ArcimRowid)
	i ret'=0 trollback
	q:ret'=0 -84 ;删除收费项失败
	;删除医嘱项主表
	&sql(Delete From Arc_ItmMast where ARCIM_Rowid=:ArcimRowid)
	i SQLCODE'=0  d
	.trollback
	.s Err=-81   ;删除医嘱项主表失败
	q:Err'=0 -81
	;
	;删除别名
	s ret=##class(web.DHCSTMHUI.ARCALIAS).DeleteItmAlias(ArcimRowid)
	i ret'=0 trollback
	q:ret'=0 -83  ;删除医嘱项别名失败
	tcommit
	q 0
}

/// Descript:	删除医嘱项对应收费项
/// Creater:	Zhangxiao
/// CreateDate:	2014-02-12
/// Table:Arc_ItmMast,DHC_TarItem
/// Input:医嘱项id
/// Output:
/// Return：0,成功;错误代码
/// w ##class(web.DHCSTMHUI.ARCITMMAST).DeleteTarItem("13466||1")
ClassMethod DeleteTarItem(ArcRowid As %String) As %Library.String
{
	n (ArcRowid)
	q:ArcRowid="" -1
	
	s Code=$p(^ARCIM($p(ArcRowid,"||",1),$p(ArcRowid,"||",2),1),"^",1)
	q:Code="" -1
	
	s tmpid=$o(^DHCTARI(0,"Code",$$ALPHAUP^SSUTIL4(Code),""))
	q:tmpid="" 0
	s Err=0
	&sql(Delete From DHC_TarItem Where TARI_Code=:Code)
	i SQLCODE'=0  d
	.s Err=-2
	q Err
}

/// Descript:	查询医嘱项明细信息
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-23
/// Table:Arc_Itm
/// Input:医嘱项id
/// Output:
/// Return：药学项子表id^代码^描述^账单单位id^医嘱子类id^医嘱子类^费用大类^费用子类id^
/// 费用子类^独立医嘱标志^默认医嘱优先级id^默认医嘱优先级^无库存医嘱标志^医保名称^缩写
/// ^最大量^限制使用天数^每天最大剂量^单次最大剂量^急诊用药^住院用药^门诊用药
/// ^体检用药^医嘱提示^生效日期^截止日期^医嘱大类描述^医嘱大类id
/// ^收费子分类^住院子分类^门诊子分类^核算子分类^病历首页子分类^会计子分类^新病历首页子分类
/// w ##class(web.DHCSTMHUI.ARCITMMAST).Select("11842||1","")
ClassMethod Select(ArcimId, RtnObj) As %Library.String
{
	n (ArcimId,RtnObj)
	i ArcimId="" q RtnObj.Err(-1,"","医嘱项ID不能为空!","",0)
	s ArcSub=+ArcimId
	s ArcVer=$p(ArcimId,"||",2)
	i '$d(^ARCIM(ArcSub,ArcVer)) q RtnObj.Err(-2,"","医嘱项不存在!","",0)
	i '$d(^ARCIM(ArcSub,ArcVer,1)) q RtnObj.Err(-2,"","医嘱项不存在!","",0)
	//医嘱项信息
	s (EffDateTo,OwnFlag,WoStock,BillUomId,PriorId,NoOfCumDays,OeMessage)=""
	s ArcCode=$p(^ARCIM(ArcSub,ArcVer,1),"^",1)					;医嘱项代码
	s ArcDesc=$p(^ARCIM(ArcSub,ArcVer,1),"^",2)					;医嘱项名称
	s ArcAbbrev=$p(^ARCIM(ArcSub,ArcVer,1),"^",3)				;医嘱简称
	s BillSubCatId=$p(^ARCIM(ArcSub,ArcVer,1),"^",9)			;费用子类ID
	s OrdSubCatId=$p(^ARCIM(ArcSub,ArcVer,1),"^",10)			;医嘱子类ID
	s EffDate=+$P($p(^ARCIM(ArcSub,ArcVer,1),"^",13),"Z",1)		;生效日期
	s EffTime=+$P($p(^ARCIM(ArcSub,ArcVer,1),"^",13),"Z",2)		;生效时间
	i $d(^ARCIM(ArcSub,ArcVer,7)) d
	.s EffDateTo=$p(^ARCIM(ArcSub,ArcVer,7),"^",1)				;截至日期
	.s OwnFlag=$p(^ARCIM(ArcSub,ArcVer,7),"^",13)				;独立医嘱标志
	i $d(^ARCIM(ArcSub,ArcVer,8)) d
	.s WoStock=$p(^ARCIM(ArcSub,ArcVer,8),"^",11)				;无库存标志
	.s BillUomId=$p(^ARCIM(ArcSub,ArcVer,8),"^",14)				;账单单位ID
	.s PriorId=$p(^ARCIM(ArcSub,ArcVer,8),"^",22)				;医嘱优先级ID
	i $d(^ARCIM(ArcSub,ArcVer,9)) d
	.s NoOfCumDays=$p(^ARCIM(ArcSub,ArcVer,9),"^",31)			;限制使用天数
	i $d(^ARCIM(ArcSub,ArcVer,"OEM"))'=0 d 
 	.s memonum=^ARCIM(ArcSub,ArcVer,"OEM",0)
 	.f k=1:1:memonum  d
 	..s OeMessage=OeMessage_^ARCIM(ArcSub,ArcVer,"OEM",k)		;医嘱提示
	s (BillUomDesc,OrdSubCatDesc,OrdCatId,OrdCatDesc,BillSubCatDesc,BillCatId,BillCatDesc,PriorityDesc)=""
	s:BillUomId'="" BillUomDesc=$p(^CT("UOM",BillUomId),"^",2)	;账单单位描述
	i OrdSubCatId'=""  d
	.s OrdSubCatDesc=$p(^ARC("IC",OrdSubCatId),"^",2)			;医嘱子类描述
	.s OrdCatId=$p(^ARC("IC",OrdSubCatId),"^",8)				;医嘱大类ID
	.s:OrdCatId'="" OrdCatDesc=$p(^OEC("ORCAT",OrdCatId),"^",2)	;医嘱大类描述
	i BillSubCatId'="" d
	.s BillCatId=+BillSubCatId													;费用大类ID
	.s BillCatDesc=$p(^ARCBG(BillCatId),"^",2)									;费用大类描述
	.s BillSubCatDesc=$p(^ARCBG(BillCatId,"SG",$p(BillSubCatId,"||",2)),"^",2)	;费用子类描述
	s:PriorId'="" PriorityDesc=$p(^OECPR(PriorId),"^",2)		;优先级
	s:EffDate'="" EffDate=..DL2H(EffDate)						;生效日期
	s:EffDateTo'="" EffDateTo=..DL2H(EffDateTo)					;截至日期
	s ArcAlias=##class(web.DHCSTMHUI.ARCALIAS).GetArcAlias(ArcimId)				;别名
	s FeeFlag=..feeFlag(ArcimId)
	
	s BillUom=..sssComboStr(BillUomId,BillUomDesc)
	s OrdSubCat=..sssComboStr(OrdSubCatId,OrdSubCatDesc)
	s OrdCat=..sssComboStr(OrdCatId,OrdCatDesc)
	s BillCat=..sssComboStr(BillCatId,BillCatDesc)
	s BillSubCat=..sssComboStr(BillSubCatId,BillSubCatDesc)
	s Priority=..sssComboStr(PriorId,PriorityDesc)
	//收费项信息
	s (TarSubCatID,TarSubCatDesc,TarAcctCatID,TarAcctCatDesc,TarMRCatID,TarMRCatDesc,TarOutpatCatID,TarOutpatCatDesc)=""
	s (TarInpatCatId,TarInpatCatDesc,TarEMCCatID,TarEMCCatDesc,TarNewMRCatID,TarNewMRCatDesc)=""
	s (TariCode,TariDesc,ChargeBasis,TARIInsuCode,TARIInsuName,TarDate,TarDateTo,TarActFlag)=""
	s tariffdr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTARIByArcim(ArcimId)
	i tariffdr'="" d
	.s TariCode=$p(^DHCTARI(tariffdr),"^",1)				;收费代码
	.s TariDesc=$p(^DHCTARI(tariffdr),"^",2)				;收费名称
	.s ChargeBasis=$p(^DHCTARI(tariffdr),"^",20)			;收费依据
	.s TarSubCatID=$p(^DHCTARI(tariffdr),"^",4)				;子分类
	.i TarSubCatID'="" s TarSubCatDesc=$p(^DHCTarC("SC",TarSubCatID),"^",2)
	.s TarAcctCatID=$p(^DHCTARI(tariffdr),"^",5)			;会计子分类
	.i TarAcctCatID'="" s TarAcctCatDesc=$p(^DHCTarC("AC",TarAcctCatID),"^",2)
	.s TarMRCatID=$p(^DHCTARI(tariffdr),"^",6)				;病历首页分类
	.i TarMRCatID'="" s TarMRCatDesc=$p(^DHCTarC("MC",TarMRCatID),"^",2)
	.s TarNewMRCatID=$p(^DHCTARI(tariffdr),"^",30)			;新病历首页分类
	.i TarNewMRCatID'="" s TarNewMRCatDesc=$p(^DHCTarC("MCNew",TarNewMRCatID),"^",2)
	.s TarInpatCatId=$p(^DHCTARI(tariffdr),"^",14)			;住院子分类
	.i TarInpatCatId'="" s TarInpatCatDesc=$p(^DHCTarC("IC",TarInpatCatId),"^",2)
	.s TarOutpatCatID=$p(^DHCTARI(tariffdr),"^",15)			;门诊子分类
	.i TarOutpatCatID'="" s TarOutpatCatDesc=$p(^DHCTarC("OC",TarOutpatCatID),"^",2)
	.s TarEMCCatID=$p(^DHCTARI(tariffdr),"^",16)			;核算子分类
	.i TarEMCCatID'="" s TarEMCCatDesc=$p(^DHCTarC("EC",TarEMCCatID),"^",2)
	.s TarDate=$p(^DHCTARI(tariffdr),"^",11)				;开始日期
	.s TarDateTo=$p(^DHCTARI(tariffdr),"^",12)				;结束日期
	.s TarActFlag=$p(^DHCTARI(tariffdr),"^",7)				;活跃标志
	s:TarDate'="" TarDate=..DL2H(TarDate)
	s:TarDateTo'="" TarDateTo=..DL2H(TarDateTo)
	s InciId=$o(^INCI(0,"ARCIM_DR",ArcSub,0))
	s TARIPrice=##class(web.DHCSTMHUI.Common.PriceCommon).GetTarPrice(InciId,+$h,BillUomId)
	s TarMRCat=..sssComboStr(TarMRCatID,TarMRCatDesc)
	s TarSubCat=..sssComboStr(TarSubCatID,TarSubCatDesc)
	s TarAcctCat=..sssComboStr(TarAcctCatID,TarAcctCatDesc)
	s TarInpatCat=..sssComboStr(TarInpatCatId,TarInpatCatDesc)
	s TarOutpatCat=..sssComboStr(TarOutpatCatID,TarOutpatCatDesc)
	s TarEMCCat=..sssComboStr(TarEMCCatID,TarEMCCatDesc)
	s TarNewMRCat=..sssComboStr(TarNewMRCatID,TarNewMRCatDesc)

	s Data=ArcimId_"^"_ArcCode_"^"_ArcDesc_"^"_BillUom_"^"_OrdCat
		_"^"_OrdSubCat_"^"_BillCat_"^"_BillSubCat_"^"_OwnFlag_"^"_Priority
		_"^"_WoStock_"^"_ArcAbbrev_"^"_NoOfCumDays_"^"_OeMessage_"^"_EffDate
		_"^"_EffDateTo_"^"_ArcAlias_"^"_FeeFlag
		_"^"_TarSubCat_"^"_TarAcctCat_"^"_TarMRCat_"^"_TarInpatCat_"^"_TarOutpatCat
		_"^"_TarEMCCat_"^"_TariCode_"^"_TariDesc_"^"_TarNewMRCat_"^"_BillUomDesc
		_"^"_OrdCatDesc_"^"_OrdSubCatDesc_"^"_ChargeBasis_"^"_TARIPrice_"^"_TarDate_"^"_TarDateTo_"^"_TarActFlag
	s Title="Arc^ArcCode^ArcDesc^BillUom^OrdCat"
		_"^OrdSubCat^BillCat^BillSubCat^OwnFlag^Priority"
		_"^WoStock^ArcAbbrev^NoOfCumDays^OeMessage^EffDate"
		_"^EffDateTo^ArcAlias^FeeFlag"
		_"^TarSubCat^TarAcctCat^TarMRCat^TarInpatCat^TarOutpatCat"
		_"^TarEMCCat^TariCode^TariDesc^TarNewMRCat^BillUomDesc"
		_"^OrdCatDesc^ArcSubCatDesc^ChargeBasis^TARIPrice^TarDate^TarDateTo^TarActFlag"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// 取收费项
/// author:zhwh
/// date:2013-12-30
/// arguments:
///   arcim - rowid of Arc_itmmast
/// Return:
///   Y - 不维护收费项
///   N - 维护收费项
ClassMethod feeFlag(arcim As %String) As %Library.String
{
	n (arcim)
	s TarItm=""
	s TarItm=$o(^DHCOLT(0,"ARTTA",arcim,""))
	q:TarItm'="" "N"
	q "Y"
}

/// 记录新病案首页
ClassMethod UpdateTarItemBL(TariRowID, BLNew, UpUser = "")
{
	n (TariRowID, BLNew, UpUser)
	S UpOldInfo=$p(^DHCTARI(TariRowID),"^",30)
	s $p(^DHCTARI(TariRowID),"^",30)=BLNew
	K PLIST
	s ItemCodeDr=$o(^DHCTARITEMFIELDCONFIG(0,"Plist","dhc_taritem","PLIST(22)",""),-1)
	s PLIST(2)=TariRowID
	s PLIST(3)=ItemCodeDr
	s PLIST(4)=UpOldInfo
	s PLIST(5)=BLNew
	s PLIST(6)=+$h
	s PLIST(7)=$p($h,",",2)
	s PLIST(8)=UpUser
	&SQL(insert into DHCTaritemUpdInfo values PLIST())
	q ""
}

/// Descript:	更新医嘱项不可用(收费标志,独立医嘱,无库存医嘱,截止日期)
/// Creater:	lxt
/// CreateDate:	2017-07-17
/// Table:ARC_ItmMast
/// Input:医嘱项id,截止日期
/// Output:		
/// Return：0:成功;<0:失败
/// Remark:web.DHCSTMHUI.INCITM调用
ClassMethod UpdateArcitmNotUse(IncRowid As %String, ArcimRowid As %String) As %Library.String
{
	n (IncRowid,ArcimRowid)
	s RtnObj=##class(RtnObj).%New()
	q:IncRowid="" RtnObj
	q:ArcimRowid="" RtnObj
	
	s OrderOnItsOwn="N"
	s WOStockCheck="N"
	s ChargeFlag="N"
	
	&sql(update DHC_ItmAddionInfo set INFO_ChargeFlag=:ChargeFlag
	where INFO_INCI_DR=:IncRowid)
	i SQLCODE'=0  d
	.d RtnObj.Err(-21,ArcimRowid,"更新收费标志失败"_$ClassName()_".UpdateArcitmNotUse:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	
	;更新医嘱项主表
	&sql(Update Arc_ItmMast set ARCIM_OrderOnItsOwn=:OrderOnItsOwn,
	ARCIM_AllowOrderWOStockCheck=:WOStockCheck where arcim_rowid=:ArcimRowid)
	i SQLCODE'=0  d
	.d RtnObj.Err(-22,ArcimRowid,"更新医嘱项不可用失败"_$ClassName()_".UpdateArcitmNotUse:SQLCODE"_SQLCODE_":"_$g(%msg))
	q:RtnObj.success'=0 RtnObj
	
	q RtnObj
}

/// Descript:   根据库存项医保分类代码,更新计费项字典
/// Creator:    wangjiabin
/// CreateDate: 2021-08-10
/// Table:
/// Input:		Inci
/// Output:		RtnObj
/// w ##class(web.DHCSTMHUI.ARCITMMAST).HandleTARIInsu(2)
ClassMethod HandleTARIInsu(Inci, Hosp) As RtnObj
{
	n (Inci,Hosp)
	s RtnObj=##class(RtnObj).%New()
	s TarItmId=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTARI(Inci)
	q:TarItmId="" RtnObj
	s InsuConfig=##class(web.DHCSTMHUI.Common.ServiceCommon).GetInsuConfig(Hosp)
	q:InsuConfig="INSU" RtnObj
	s MatInsuCode="",MatInsuDesc=""
	s Info=$o(^DHCITMINFO(0,"INCI",Inci,""))
	s:Info'="" MatInsuCode=$p($g(^DHCITMINFO(Info,1)),"^",39)
	s:Info'="" MatInsuDesc=$p($g(^DHCITMINFO(Info,1)),"^",54)
	q:(MatInsuCode="")&&(MatInsuDesc="") RtnObj
	
	s TARIInsuName=$p(^DHCTARI(TarItmId),"^",18)
	s TARIInsuCode=$p(^DHCTARI(TarItmId),"^",59)
	q:(TARIInsuCode=MatInsuCode)&&(TARIInsuName=MatInsuDesc) RtnObj
	s Obj=##class(User.DHCTarItem).%OpenId(TarItmId)
	s Obj.TARIInsuCode=MatInsuCode
	s Obj.TARIInsuName=MatInsuDesc
	s Sc=Obj.%Save()
	i $$$ISERR(Sc) q RtnObj.Err(-1,"","HandleTARIInsu计费项更新错误")
	
	q RtnObj
}

}
