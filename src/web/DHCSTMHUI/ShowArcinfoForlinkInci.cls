Import sqluser

/// 查询物资医嘱跟收费信息,以关联库存项
/// 20170413 lihui
/// table ARC_ItmMast;DHC_TarItem 
Class web.DHCSTMHUI.ShowArcinfoForlinkInci Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// OutPut:医嘱id^^医嘱代码^医嘱名称^账单单位id^账单单位名称^费用子类id^费用子类名称^费用大类^费用子类id^费用子类名称
///       ^独立医嘱^默认医嘱优先级id^默认医嘱优先级^无库存医嘱标志^医保名称^缩写^最大量^限制使用天数
///       ^^^^^^^医嘱提示^生效日期^截止日期^医嘱大类描述
///       ^医嘱大类id^收费子分类^住院子分类^门诊子分类^核算子分类^病历首页子分类^会计子分类^新病历首页子分类
/// d ##class(web.DHCSTMHUI.ShowArcinfoForlinkInci).getArcinfo(0,30,"","","^^Y")
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ShowArcinfoForlinkInci","getArcinfo",^tmpxu)
Query getArcinfo(Params As %String) As Query(ROWSPEC = "ArcId,ArcCode,ArcDesc,BillUom,OrdSubCat,OwnFlag,WoStock,InsuDesc,ArcAbbrev,OrdCat,TariCode,TariDesc,TarPrice,Flag")
{
}

ClassMethod getArcinfoExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s pArcCode=PJobj.%Get("ArcCode")
	s pArcDesc=PJobj.%Get("ArcDesc")
	s pOrdCat=PJobj.%Get("OrdCatBox")
	s pOrdSubCat=PJobj.%Get("OrdSubCatBox")
	s pNolink=PJobj.%Get("Nolink")
	s pArcCode=$$ALPHAUP^SSUTIL4(pArcCode)    ;医嘱代码
	s pArcDesc=$$ALPHAUP^SSUTIL4(pArcDesc)    ;医嘱名称
	s paramstr=pArcCode_"^"_pArcDesc_"^"_pOrdCat_"^"_pOrdSubCat
	i pArcCode'="" d
	.s ret=..getArcBycode(paramstr,pNolink)   ;根据代码查询
	e  i pArcDesc'="" d
	.s ret=..getArcBydesc(paramstr,pNolink)   ;根据医嘱名称
	e  i pOrdCat'="" d
	.s ret=..getArcByArcOrdc(paramstr,pNolink) ;根据医嘱大类
	e  i pOrdSubCat'=""  d
	.s ret=..getArcByArcCat(paramstr,pNolink)  ;根据医嘱子类
	e  d 
	.s ret=..getAllArc(pNolink)
	s pid=$p(ret,"^",1)
	s count=$p(ret,"^",2)
	i pid="" q $$$OK	
	s arcid=""
	f  s arcid=$o(^TMPARCTARINFO(pid,"ARCTMP",arcid)) q:arcid=""  d
	.s ArcInfo=##class(web.DHCSTMHUI.ARCITMMAST).Select(arcid)
	.s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	.d PJobj.%FromJSON(ArcInfo)
	.s ArcCode=PJobj.%Get("ArcCode")
	.s ArcDesc=PJobj.%Get("ArcDesc")
	.s BillUom=PJobj.%Get("BillUomDesc")
	.s OrdSubCat=PJobj.%Get("ArcSubCatDesc")
	.s OwnFlag=PJobj.%Get("OwnFlag")
	.s WoStock=PJobj.%Get("WoStock")
	.s InsuDesc=PJobj.%Get("InsuDesc")
	.s ArcAbbrev=PJobj.%Get("ArcAbbrev")
	.s OrdCat=PJobj.%Get("OrdCatDesc")
	.s TariCode=PJobj.%Get("TariCode")
	.s TariDesc=PJobj.%Get("TariDesc")
	.s TarPrice=PJobj.%Get("TarPrice")
	.s EffDateTo=PJobj.%Get("EffDateTo")
	.s Flag="Y"
	.i EffDateTo'=""  d
	..s EffDateTo=..DH2L(EffDateTo)
	..s:EffDateTo<=+$h Flag="N"
	.s TarPrice=..GetTarPrice(arcid)
	.d OutPutRow
	k ^TMPARCTARINFO(pid)
	q $$$OK
OutPutRow
	s Data=$lb(arcid,ArcCode,ArcDesc,BillUom,OrdSubCat,OwnFlag,WoStock,InsuDesc,ArcAbbrev,OrdCat,TariCode,TariDesc,TarPrice,Flag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 根据医嘱代码获取医嘱收费项信息
ClassMethod getArcBycode(paramstr As %String, nolink As %String) As %Library.String
{
	n (paramstr,nolink)
	s arccode=$p(paramstr,"^",1)
	s arcdesc=$p(paramstr,"^",2)
	s arcordc=$p(paramstr,"^",3)
	s arccat=$p(paramstr,"^",4)
	s pid=..NewPid()
	k ^TMPARCTARINFO(pid)
	
	s sqlstr="SELECT ARCIM_RowId FROM ARC_ItmMast WHERE ARCIM_Code LIKE'%"_arccode_"%'"
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlstr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
    If err  q ""
    s num=0
    While(result.Next())
    {
	   s arcid=result.Data("ARCIM_RowId")
	   continue:arcid=""
	   s ifmat=..IsMaterialArc(arcid)  ;过滤非耗材医嘱
	   continue:ifmat'=1
	   s arccattmp=$p(^ARCIM(+arcid,$p(arcid,"||",2),1),"^",10)
	   continue:arccattmp=""
	   s arcordctmp=$p(^ARC("IC",arccattmp),"^",8)
	   continue:arcordctmp=""
	   continue:(arcordc'="")&&(arcordc'=arcordctmp)
	   continue:(arccat'="")&&(arccattmp'=arccat)
	   s iflinkinci=..IfLinkInci(arcid)   ;判断是否已经关联过库存项
	   continue:(iflinkinci="Y")&&(nolink="Y")
	   s num=num+1
	   s ^TMPARCTARINFO(pid,"ARCTMP",arcid)=""
	}
	q pid_"^"_num
}

/// 根据医嘱名称获取医嘱收费项信息
ClassMethod getArcBydesc(paramstr As %String, nolink As %String) As %Library.String
{
	n (paramstr,nolink)
	s arcdesc=$p(paramstr,"^",2)
	s arcordc=$p(paramstr,"^",3)
	s arccat=$p(paramstr,"^",4)
	s pid=..NewPid()
	k ^TMPARCTARINFO(pid)
	
	s sqlstr="SELECT ARCIM_RowId FROM ARC_ItmMast WHERE %ALPHAUP(ARCIM_Desc) LIKE '%"_arcdesc_"%'"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlstr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	if err q ""
	s num=0
	While(result.Next())
	{
	   s arcid=result.Data("ARCIM_RowId")
	   continue:arcid=""
	   s ifmat=..IsMaterialArc(arcid)
	   continue:ifmat'=1               ;过滤非耗材医嘱
	   s arccattmp=$p(^ARCIM(+arcid,$p(arcid,"||",2),1),"^",10)
	   continue:arccattmp=""
	   s arcordctmp=$p(^ARC("IC",arccattmp),"^",8)
	   continue:arcordctmp=""
	   continue:(arcordc'="")&&(arcordc'=arcordctmp)
	   continue:(arccat'="")&&(arccattmp'=arccat)
	   s iflinkinci=..IfLinkInci(arcid)             ;判断是否已经关联过库存项
	   continue:(iflinkinci="Y")&&(nolink="Y")
	   s num=num+1
	   s ^TMPARCTARINFO(pid,"ARCTMP",arcid)=""
	 
	}
	q pid_"^"_num
}

/// 根据医嘱大类获取医嘱收费项信息
ClassMethod getArcByArcOrdc(paramstr As %String, nolink As %String) As %Library.String
{
	n (paramstr,nolink)
	s arcordc=$p(paramstr,"^",3)
	s arccat=$p(paramstr,"^",4)
	s pid=..NewPid()
	k ^TMPARCTARINFO(pid)
	s num=0
	
	s arccatdr=""
	f  s arccatdr=$o(^ARC("IC",0,"OrdCat",arcordc,arccatdr)) q:arccatdr=""  d
	.q:((arccat'="")&&(arccatdr'=arccat))
	.s Subscript=""
	.f  s Subscript=$o(^ARCIM(0,"ARCIC_DR",arccatdr,Subscript)) q:Subscript=""  d
	..s Version=""
	..f  s Version=$o(^ARCIM(0,"ARCIC_DR",arccatdr,Subscript,Version)) q:Version=""  d
	...s arcid=Subscript_"||"_Version
	...s ifmat=..IsMaterialArc(arcid)            ;过滤非耗材医嘱
	...q:ifmat'=1
	...s iflinkinci=..IfLinkInci(arcid)        ;判断是否已经关联过库存项
	...q:(iflinkinci="Y")&&(nolink="Y")
	...s num=num+1
	...s ^TMPARCTARINFO(pid,"ARCTMP",arcid)=""
	..
	.
	q pid_"^"_num
}

/// 根据医嘱子类获取医嘱收费项信息
ClassMethod getArcByArcCat(paramstr As %String, nolink As %String) As %Library.String
{
	n (paramstr,nolink)
	s arccat=$p(paramstr,"^",4)
	s pid=..NewPid()
	k ^TMPARCTARINFO(pid)
	
	s sqlstr="SELECT ARCIM_RowId FROM ARC_ItmMast WHERE ARCIM_ItemCat_DR="_arccat
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlstr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	if err q ""
	s num=0
	While(result.Next())
	{
	   s arcid=result.Data("ARCIM_RowId")
	   continue:arcid=""
	   s ifmat=..IsMaterialArc(arcid)
	   continue:ifmat'=1                ;过滤非耗材医嘱
	   s iflinkinci=..IfLinkInci(arcid)
	   continue:(iflinkinci="Y")&&(nolink="Y")           ;判断是否已经关联过库存项
	   s num=num+1
	   s ^TMPARCTARINFO(pid,"ARCTMP",arcid)=""
	 
	}
	q pid_"^"_num
}

/// 获取所有物资医嘱收费项信息(Nolink=Y仅显示有医嘱无库存项医嘱收费信息;N 显示所有医嘱收费项信息)
/// w ##class(web.DHCSTMHUI.ShowArcinfoForlinkInci).getAllArc("N")
ClassMethod getAllArc(nolink As %String) As %Library.String
{
	n (nolink)
	s pid=..NewPid()
	k ^TMPARCTARINFO(pid)
	s num=0
	
	s arccode=""
	f  s arccode=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arccode))) q:arccode=""  d
	.s Subscript=""
	.f  s Subscript=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arccode),Subscript)) q:Subscript=""  d
	..s Version=""
	..f  s Version=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(arccode),Subscript,Version)) q:Version=""  d
	...s arcid=Subscript_"||"_Version
	...s ifmatarc=..IsMaterialArc(arcid)
	...q:ifmatarc'=1                      ;过滤非耗材医嘱
	...s iflinkinci=..IfLinkInci(arcid)            ;判断是否已经关联过库存项
	...q:(iflinkinci="Y")&&(nolink="Y")
	...s num=num+1
	...s ^TMPARCTARINFO(pid,"ARCTMP",arcid)=""
	..
	.
	q pid_"^"_num
}

/// 过滤非物资医嘱信息	1:材料, 0:非材料
ClassMethod IsMaterialArc(Arcid As %String) As %Library.String
{
	n (Arcid)
	s Ret=0
	q:Arcid="" Ret
	s Arcsub=$p(Arcid,"||",1)
	s Arcver=$p(Arcid,"||",2)
	q:(+Arcsub=0)||(+Arcver=0) Ret
	q:'$d(^ARCIM(Arcsub,Arcver)) Ret
	s (OrdType,ORCATDesc,ArcCatDr)=""
	s ArcItemCatDr=$p($g(^ARCIM(Arcsub,Arcver,1)),"^",10)
	s:ArcItemCatDr'="" OrdType=$p($g(^ARC("IC",ArcItemCatDr)),"^",7)
	s:ArcItemCatDr'="" ArcCatDr=$p($g(^ARC("IC",ArcItemCatDr)),"^",8)
	s:ArcCatDr'="" ORCATDesc=$p(^OEC("ORCAT",ArcCatDr),"^",2)
	i $o(^ARC("IC",0,"OrderType","M",""))>0 d
	.s:OrdType="M" Ret=1
	e  d
	.;考虑未分配材料医嘱子类type的情况
	.s:ORCATDesc["材料" Ret=1
	q Ret
}

/// 判断是否有关联库存项
ClassMethod IfLinkInci(arcid As %String) As %Library.String
{
	n (arcid)
	s flag="N"
	q:arcid="" flag
	s inci=$o(^INCI(0,"ARCIM_DR",+arcid,""))
	s:+inci>0 flag="Y"
	q flag
}

/// 判断库存项是否关联了医嘱项
/// w ##class(web.DHCSTMHUI.ShowArcinfoForlinkInci).IfInciLinkArc()
ClassMethod IfInciLinkArc(inci As %String) As %Library.String
{
	n (inci)
	s flag="N"
	q:inci="" flag
	q:'$d(^INCI(inci,1)) flag
	s arcid=$p(^INCI(inci,1),"^",3)
	s:+arcid>0 flag="Y"
	q flag
}

/// 关联库存项
ClassMethod LinkInci(arcid As %String, inci As %String) As %Library.String
{
	n (arcid,inci)
	q:arcid="" ""
	q:inci="" ""
	s Err=0
	ts
	&sql(UPDATE INC_Itm SET INCI_ARCIM_DR=:arcid,INCI_OriginalARCIM_DR=:arcid WHERE INCI_RowId=:inci)
	i SQLCODE'=0  tro  q SQLCODE
	&sql(UPDATE DHC_ItmAddionInfo SET INFO_ChargeFlag='Y' WHERE INFO_INCI_DR=:inci)
	i SQLCODE'=0 tro  q SQLCODE
	&sql(UPDATE DHC_ItmAddionInfo SET INFO_ChargeFlag='Y' WHERE INFO_INCI_DR=:inci)
	i SQLCODE'=0 tro  q SQLCODE
	s Params=..sssParamStr()
	s CancelArcimSetArcimEffDateTo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("AppName"),"CancelArcimSetArcimEffDateTo",Params)
	i CancelArcimSetArcimEffDateTo="Y" d
	.s EffDateTo=""
	.&sql(UPDATE ARC_ItmMast SET ARCIM_EffDateTo=:EffDateTo WHERE ARCIM_RowId=:arcid)
	.i SQLCODE'=0 s Err=-1 q
	i Err'=0 tro  q Err
	tc
	q Err
}

/// 获取收费项的价格(仅供医嘱关联的价格显示参考使用)
/// lihui
/// 20170521
/// w ##class(web.DHCSTMHUI.ShowArcinfoForlinkInci).GetTarPrice("1||1")
ClassMethod GetTarPrice(arcid As %String) As %Library.String
{
	n (arcid)
	q:arcid="" ""
	s Tarid="",ExecuDate="",tarprice=0
	s date=+$h
	&sql(SELECT OLT_Tariff_DR,OLT_StartDate into:Tarid,:ExecuDate FROM DHC_OrderLinkTar WHERE OLT_ARCIM_DR=:arcid) ;默认取第一个收费项信息,没有对应可用的索引进行遍历所有收费项信息
	if (Tarid'="")&&$d(^DHCTARI(Tarid)) d
	.q:+ExecuDate>date
	.s TarEnddate=$p(^DHCTARI(Tarid),"",12)  ;收费项截止日期
	.q:(TarEnddate'="")&&(TarEnddate<date)
	.s Tarchl="",TarFlag=0
	.f  s Tarchl=$o(^DHCTARI(Tarid,"P",Tarchl),-1) q:((Tarchl="")||(TarFlag=1))  d   ;收费项价格明细
	..s TariEnddate=$p(^DHCTARI(Tarid,"P",Tarchl),"^",4) ;价格明细截止日期
	..q:(TariEnddate'="")&&(TariEnddate<date)
	..s tarprice=$p(^DHCTARI(Tarid,"P",Tarchl),"^",5)
	..s:+tarprice>0 TarFlag=1
	.
	q tarprice
}

/// Descript:	取消医嘱项关联
/// 对象类型数据
ClassMethod jsCancelLinkInci(InciId As %String) As %String
{
	n (InciId)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..CancelLinkInci(InciId)
	q RtnObj.Json()
}

/// Descript:	取消医嘱项关联
/// Creator:	lxt
/// CreateDate:	20201022
/// Table:		INC_Itm，DHC_ItmAddionInfo
/// Input:		inci
/// Return：	订单信息
ClassMethod CancelLinkInci(InciId As %String) As RtnObj
{
	n (InciId)
	s RtnObj=##class(RtnObj).%New()
	q:InciId="" RtnObj.Err(-1,"","请选择要取消关联的库存项")
	s Params=..sssParamStr()
	s ArcId=$p(^INCI(InciId,1),"^",3)
	q:ArcId="" RtnObj.Err(-2,"","此库存项未关联医嘱项")
	ts
	&sql(UPDATE INC_Itm SET INCI_ARCIM_DR=NULL,INCI_OriginalARCIM_DR=NULL WHERE INCI_RowId=:InciId)
	i SQLCODE'=0  tro  d RtnObj.Err(-3,"","取消关联失败")
	q:RtnObj.success'=0 RtnObj
	&sql(UPDATE DHC_ItmAddionInfo SET INFO_ChargeFlag='N' WHERE INFO_INCI_DR=:InciId)
	i SQLCODE'=0  tro  d RtnObj.Err(-4,"","设置库存项不收费失败")
	q:RtnObj.success'=0 RtnObj
	s CancelArcimSetArcimEffDateTo=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("AppName"),"CancelArcimSetArcimEffDateTo",Params)
	i CancelArcimSetArcimEffDateTo="Y" d
	.s EffDateTo=""
	.&sql(SELECT ARCIM_EffDateTo INTO:EffDateTo FROM ARC_ItmMast WHERE ARCIM_RowId=:ArcId)
	.i (EffDateTo>+$h)||(EffDateTo="") d
	..s RtnObj=##class(web.DHCSTMHUI.ARCITMMAST).UpdateEffDeteTo(ArcId,"N")
	..q:RtnObj.success'=0
	i RtnObj.success'=0 tro  q RtnObj
	tc
	q RtnObj
}

}
