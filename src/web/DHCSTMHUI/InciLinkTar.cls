Import sqluser

/// Description:	计费项关联库存项相关方法
Class web.DHCSTMHUI.InciLinkTar Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:检索计费项信息
/// Creator:	wangjiabin
/// CreateDate:	2015-03-27
/// Table:		DHC_TarItem
/// Input:		Params(代码^描述^未关联库存项^子分类^住院子分类^门诊子分类^核算子分类^病历首页子分类^会计子分类)
/// Output:
/// Return：""：成功，非空：保存失败
Query QueryTar(Params As %String) As Query(ROWSPEC = "RowId,TARICode,TARIDesc,UomId,UomDesc,ActiveFlag")
{
}

ClassMethod QueryTarExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s Type=..sssCode()
	s Code=PJobj.%Get("Code")
	s Desc=PJobj.%Get("Desc")
	s NoInciFlag=PJobj.%Get("NoInciFlag")
	s SubTypeFee=PJobj.%Get("TarSubCat")
	s InSubTypeFee=PJobj.%Get("TarInpatCat")
	s OutSubTypeFee=PJobj.%Get("TarOutpatCat")
	s AccSubTypeFee=PJobj.%Get("TarAcctCat")
	s MedSubTypeFee=PJobj.%Get("TarMRCat")
	s AccountSubTypeFee=PJobj.%Get("TarNewMRCat")
	s TarEMCCat=PJobj.%Get("TarEMCCat")
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=PJobj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s StrSql="select %id TARIRowId,TARI_Code TARICode,TARI_Desc TARIDesc,TARI_UOM UomId,TARI_UOM->CTUOM_Desc UomDesc,"
		_"TARI_ActiveFlag ActiveFlag"
		_" from DHC_TarItem where 1=1"
	s:Code'="" StrSql=StrSql_" and TARI_Code like '%"_Code_"%'"
	s:Desc'="" StrSql=StrSql_" and TARI_Desc like '%"_Desc_"%'"
	s:SubTypeFee'="" StrSql=StrSql_" and TARI_SubCate="_SubTypeFee
	s:InSubTypeFee'="" StrSql=StrSql_" and TARI_InpatCate="_InSubTypeFee
	s:OutSubTypeFee'="" StrSql=StrSql_" and TARI_OutpatCate="_OutSubTypeFee
	s:TarEMCCat'="" StrSql=StrSql_" and TARI_EMCCate="_TarEMCCat
	s:MedSubTypeFee'="" StrSql=StrSql_" and TARI_MRCate="_MedSubTypeFee
	s:AccountSubTypeFee'="" StrSql=StrSql_" and TARI_MCNew"_AccountSubTypeFee
	s:AccSubTypeFee'="" StrSql=StrSql_" and TARI_AcctCate"_AccSubTypeFee
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err q $$$OK
	While(result.Next())
	{
		s TARIRowId=result.Data("TARIRowId")
		s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_TarItem",TARIRowId,pHospId)
		continue:ShowDataFlag'="Y"
		
		s DrugTarFlag=##class(web.DHCSTMHUI.Common.ServiceCommon).GetDrugTarFlag(TARIRowId)
		i DrugTarFlag="Y" s ^templxt(TARIRowId)=TARIRowId_"^"_DrugTarFlag
		continue:DrugTarFlag="Y"
		
		s InciId=""
		;ps: 有一个计费项关联多个医嘱项的情况, 这个咋处理?
		i NoInciFlag="Y" d
		.s StartDate=$o(^DHCOLT(0,"TAR",TARIRowId,""))
		.q:StartDate=""
		.s OltId=$o(^DHCOLT(0,"TAR",TARIRowId,StartDate,""))
		.q:OltId=""
		.s ArcimId=$p(^DHCOLT(OltId),"^",1)
		.s InciId=$o(^INCI(0,"ARCIM_DR",+ArcimId,""))
		continue:(NoInciFlag="Y")&&(InciId'="")
		
		s TARICode=result.Data("TARICode")
		s TARIDesc=result.Data("TARIDesc")
		s UomId=result.Data("UomId")
		s UomDesc=result.Data("UomDesc")
		s ActiveFlag=result.Data("ActiveFlag")
		d OutPutRowTar
	}
	Quit $$$OK

OutPutRowTar
	s Data=$lb(TARIRowId,TARICode,TARIDesc,UomId,UomDesc,ActiveFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:获取计费项关联的库存项信息
/// Creator:	wangjiabin
/// CreateDate:	2015-03-27
/// Table:		DHC_InciLinkTar
/// Input:		StrParam:(计费项rowid)
/// Output:	
Query GetLinkData(Tariff As %String) As Query(ROWSPEC = "RowId,Inci,InciCode,InciDesc,Spec,LinkQty,UomId,UomDesc,LinkGroup")
{
}

ClassMethod GetLinkDataExecute(ByRef qHandle As %Binary, Tariff As %String) As %Status
{
	n (qHandle,Tariff)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Tariff="" $$$OK
	s StrSql="select ILT_RowId RowId,ILT_INCI_DR InciDr,ILT_INCI_DR->Inci_Code InciCode,ILT_INCI_DR->Inci_Desc InciDesc,ILT_Qty LinkQty,"
		_"ILT_Uom UomId,ILT_Uom->CTUOM_Desc UomDesc,ILT_Group LinkGroup"
		_" from DHC_InciLinkTar where ILT_Tariff_DR="_Tariff
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err q $$$OK
	While(result.Next())
	{
		s RowId=result.Data("RowId")
		s InciDr=result.Data("InciDr")
		s InciCode=result.Data("InciCode")
		s InciDesc=result.Data("InciDesc")
		s LinkQty=result.Data("LinkQty")
		s UomId=result.Data("UomId")
		s UomDesc=result.Data("UomDesc")
		s LinkGroup=result.Data("LinkGroup")
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciDr)
		d OutPutRowLinkTar
	}
	Quit $$$OK

OutPutRowLinkTar
	s Data=$lb(RowId,InciDr,InciCode,InciDesc,Spec,LinkQty,UomId,UomDesc,LinkGroup)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:保存计费项和库存项关联信息
/// Creator:	wangjiabin
/// CreateDate:	2015-03-27
/// Table:		DHC_InciLinkTar
/// Input:		计费项rowid, ListData(rowid^inci^qty^uom_$c(1)_...)
/// Return：	0:成功, 其他:保存失败
ClassMethod Save(Tariff As %String, ListData As %String) As %Library.String
{
	n (Tariff,ListData)
	s $zt=..sssError()
	s RtnObj=##class(RtnObj).%New()
	i Tariff="" d RtnObj.Err(-1,"","收费项Id不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		s Inci=Obj.%Get("Inci")
		s UomId=Obj.%Get("UomId")
		s Qty=Obj.%Get("LinkQty")
		s LinkGroup=Obj.%Get("LinkGroup")
		i RowId="" d
		.&sql(select %id into :tmpRowId from DHC_InciLinkTar
			where ILT_INCI_DR=:Inci and ILT_Tariff_DR=:Tariff)
		.i SQLCODE=0 d	;存在关联
		..d RtnObj.Err(-1,"","存在关联!","",0)
		.q:RtnObj.success'=0
		.&sql(insert into DHC_InciLinkTar (ILT_INCI_DR,ILT_Tariff_DR,ILT_Qty,ILT_Uom,ILT_Group)
			values (:Inci,:Tariff,:Qty,:UomId,:LinkGroup))
		.i SQLCODE d
		..d RtnObj.Err(-1,"",$ClassName()_".Insert:SQLCODE"_SQLCODE_":"_$g(%msg))
		e   d
		.&sql(update DHC_InciLinkTar set ILT_INCI_DR=:Inci,ILT_Qty=:Qty,ILT_Uom=:UomId,ILT_Group=:LinkGroup
		 where %id=:RowId)
		.i SQLCODE d
		..d RtnObj.Err(-1,"",$ClassName()_".Update:SQLCODE"_SQLCODE_":"_$g(%msg))
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Description:删除某计费项关联库存项明细
/// Creator:	wangjiabin
/// CreateDate:	2015-03-30
/// Table:		DHC_InciLinkTar
/// Return：	0:成功, 其他:保存失败
ClassMethod Delete(Params As %String)
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
 	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		q:RowId=""
		&sql(delete from DHC_InciLinkTar where %id=:RowId)
		i SQLCODE d
		.d RtnObj.Err(-1,"",$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

}
