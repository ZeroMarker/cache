Import sqluser

/// Descript:库存项别名相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-16
Class web.DHCSTMHUI.INCALIAS Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询库存项别名
/// Creater:	ZhangDongmei
/// CreateDate:	2012-01-09
/// Table:INC_Alias
/// Input:库存项id
/// Output:
/// Return：库存项别名
/// w ##class(web.DHCSTMHUI.INCALIAS).Select(13)
Query SelectAlias(Inci As %String) As Query(ROWSPEC = "RowId,Alias") [ SqlProc ]
{
}

ClassMethod SelectAliasExecute(ByRef qHandle As %Binary, Inci As %String) As %Status
{
	n (qHandle,Inci)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inci="" $$$OK

	s IncaId=0
	f  s IncaId=$o(^INCALIAS(0,"INCI",Inci,IncaId)) q:IncaId=""  d
	.s Alias=$p(^INCALIAS(IncaId),"^",4)
	.d OutPutRowAlias
	
	Quit $$$OK
OutPutRowAlias
	s Data=$lb(IncaId,Alias)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	增加库存项别名
/// Creater:	ZhangDongmei
/// CreateDate:	2012-01-09
/// Table:INC_Alias
/// Input:库存项id,别名id^别名,别名id2^别名2...
/// Output:
/// Return：0,成功; -1：库存项为空,-2:不存在该库存项，错误数据串：保存失败
/// w ##class(web.DHCSTMHUI.INCALIAS).Save(832,^tmpxuxjc)
ClassMethod jsSave(Inci, ListData) As %Library.String
{
	n (Inci,ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	i Inci="" d RtnObj.Err(-1,"","库存项不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json() 
	ts
	s RtnObj=..Save(Inci,ListData)
	i RtnObj.success=0 d
	.tc 
	else  d
	.tro
	q RtnObj.Json()
}

/// ParamFlag: 参数标记,默认为空,参数调用传Y,避免循环调用
ClassMethod Save(Inci, ListData, ParamFlag = "") As RtnObj
{
	n (Inci,ListData,ParamFlag)
	s paramStr=..sssParamStr()
	s RtnObj=##class(RtnObj).%New()
	s ItmCode=$p(^INCI(Inci,1),"^",1)
	s ItmDesc=$p(^INCI(Inci,1),"^",2)
	q:RtnObj.success'=0 RtnObj 
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s IncaId=Obj.%Get("RowId")
		s Alias=Obj.%Get("Alias")
		i IncaId'=""  d
		.&sql(Update INC_alias Set inca_text=:Alias Where INCA_ROWID=:IncaId)
		.i SQLCODE'=0  d
		..d RtnObj.Err(-1,"","插入失败!")
		e  d
		.s aliasRet=..CheckAlias(Inci,Alias)
		.q:+aliasRet=1
		.&sql(INSERT INTO INC_alias (inca_inci_dr,inca_code,inca_desc,inca_text) VALUES (:Inci,:ItmCode,:ItmDesc,:Alias))
		.i SQLCODE'=0  d
		..d RtnObj.Err(-1,"",$ClassName()_".Save:SQLCODE"_SQLCODE_":"_$g(%msg))
		.e  d
		..s AutoAddAAByIA=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("AppName"),"AutoAddAAByIA",paramStr)
		..i (ParamFlag'="Y")&&(AutoAddAAByIA="Y")  d
		...s ArcimId=$p(^INCI(Inci,1),"^",3)
		...q:ArcimId=""
		...s Params=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Alias,"Alias")
		...s RtnObj=##class(web.DHCSTMHUI.ARCALIAS).Save(ArcimId,"["_Params_"]","Y")
	}
	q RtnObj
}

/// Descript:	删除库存项别名
/// Creater:	ZhangDongmei
/// CreateDate:	2012-01-10
/// Table:INC_Alias
/// Input:别名id
/// Output:
/// Return：0,成功;-1:没有要删除的记录；-2：操作失败
ClassMethod Delete(Params) As %Library.String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		q:RowId=""
		&sql(Delete From INC_alias Where INCA_Rowid=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	查询库存项别名
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-23
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
	f  s IncaId=$o(^INCALIAS(0,"INCI",InciId,IncaId)) q:IncaId=""  d
	.s Alias=$p(^INCALIAS(IncaId),"^",4)
	.q:Alias=""
	.i AliasStr=""  d
	..s AliasStr=Alias
	.e  d
	..s AliasStr=AliasStr_"/"_Alias
	.
	q AliasStr
}

/// Descript:	若库存项有包含alias的别名, 返回0; 
/// Creater:	wangjiabin
/// CreateDate:	2014-01-11
/// Table:
/// Input:库存项id, aliasDesc
/// Output:		
/// Return："":不存在包含alias的别名, 1:存在包含alias的别名, 2^aliasID:存在包含于alias中的别名
ClassMethod CheckAlias(inci As %String, alias As %String) As %Library.String
{
	n (inci,alias)
	q:inci="" ""
	q:alias="" ""
	s alias=$$ALPHAUP^SSUTIL4(alias)
	s ret2=0
	s Flag=0
	s rowid=0
	f  s rowid=$o(^INCALIAS(0,"INCI",inci,rowid)) q:(rowid="")!(Flag=1)  d
	.s incaText=$p(^INCALIAS(rowid),"^",4)
	.s incaText=$$ALPHAUP^SSUTIL4(incaText)
	.i incaText[alias d
	..s Flag=1
	.e  i alias[incaText d
	..s ret2=rowid
	.
	
	s ret=$s(Flag=1:1,ret2>0:2_"^"_ret2,1:"")
	q ret
}

/// Descript:	查询库存项规格
/// Creater:	ZhangDongmei
/// CreateDate:	2012-01-09
/// Table:DHC_ItmSpecList
/// Input:库存项id
/// Output:
/// Return：库存项规格
/// w ##class(web.DHCSTMHUI.INCALIAS).Selectspec(13)
Query SelectSpec(Inci As %String) As Query(ROWSPEC = "RowId,Spec") [ SqlProc ]
{
}

ClassMethod SelectSpecExecute(ByRef qHandle As %Binary, Inci As %String) As %Status
{
	n (qHandle,Inci)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Inci="" $$$OK
	s sqlStr="select SPEC_RowId,SPEC_Desc "
		_"from DHC_ItmSpecList where SPEC_INCI_DR='"_Inci_"' order by SPEC_SeqNo asc"
	
	s result=##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	d result.Execute()
	while(result.Next())
	{
		s SpecId=result.Data("SPEC_RowId")
		s SPECDesc=result.Data("SPEC_Desc")
		d OutPutRow
	}
	d result.Close()
	
	Quit $$$OK
OutPutRow
	s Data=$lb(SpecId,SPECDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:增加规格
/// Creater:LH
/// Input:库存项ID
/// Return：0,成功; -1：库存项为空,-2:不存在该库存项，错误数据串：保存失败
/// w ##class(web.DHCSTMHUI.INCALIAS).jsSaveSpec(3,^tmpxu)
ClassMethod jsSaveSpec(Inci, ListData) As %Library.String
{
	n (Inci, ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..SaveSpec(Inci,ListData)
	q RtnObj.Json()
}

/// Descript:增加规格
/// Creater:LH
/// Input:库存项ID
/// Return：0,成功; -1：库存项为空,-2:不存在该库存项，错误数据串：保存失败
/// w ##class(web.DHCSTMHUI.INCALIAS).SaveSpec(3,^tmpxu)
ClassMethod SaveSpec(Inci, ListData) As %Library.String
{
	n (Inci,ListData)

	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	i Inci="" d RtnObj.Err(-1,"","库存项不能为空!","",0)
	q:RtnObj.success'=0 RtnObj
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s SpecId=Obj.%Get("RowId")
		s SpecDesc=Obj.%Get("Spec")
		s tmpRowId=""
		&sql(select SPEC_Rowid into :tmpRowId from DHC_ItmSpecList where SPEC_INCI_DR=:Inci and SPEC_Desc=:SpecDesc)
		continue:'SQLCODE
		;i 'SQLCODE d
		.;d RtnObj.Err(-1,"","具体规格重复","",0)
		;q:RtnObj.success'=0
		i SpecId'=""  d
		.&sql(Update DHC_ItmSpecList Set SPEC_Desc=:SpecDesc Where SPEC_Rowid=:SpecId)
		.i SQLCODE'=0  d
		..d RtnObj.Err(-1,"","更新失败!")
		e  d
		.s SpecNo=""
		.&sql(select nvl(max(SPEC_SeqNo),0)+1 into :SpecNo from SQLUser.DHC_ItmSpecList where SPEC_INCI_DR=:Inci)
		.&sql(INSERT INTO DHC_ItmSpecList (SPEC_INCI_DR,SPEC_Desc,SPEC_SeqNo) VALUES (:Inci,:SpecDesc,:SpecNo))
		.i SQLCODE'=0  d
		..d RtnObj.Err(-1,"",$ClassName()_".Save:SQLCODE"_SQLCODE_":"_$g(%msg))
	}
	i RtnObj.success=0 d
	.tc 
	else  d
	.tro
	q RtnObj
}

/// Descript:	删除库存项规格
/// Table:DHC_ItmSpecList
/// Input:规格id
/// Output:
/// Return：0,成功;-1:没有要删除的记录；-2：操作失败
ClassMethod DeleteSpec(Params) As %Library.String
{
	
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	ts
	s $ZT=..sssError()
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s RowId=Obj.%Get("RowId")
		q:RowId=""
		&sql(Delete From DHC_ItmSpecList Where SPEC_Rowid=:RowId)
		i SQLCODE'=0  d
		.s sc=RtnObj.Err(-2,RowId,$ClassName()_".Delete:SQLCODE"_SQLCODE_":"_$g(%msg))
		q:RtnObj.success'=0
	}
	i RtnObj.success=0 d
	.tc
	e  d
	.tro
	q RtnObj.Json()
}

/// Descript:	若库存项有包含spno的规格, 返回0; 
/// Creater:	liuhui
/// CreateDate:	2015-03-17
/// Table:
/// Input:库存项id, SPECSeqNo
/// Output:		
/// w ##class(web.DHCSTMHUI.INCALIAS).Checkspec(13,"大护肤")
ClassMethod Checkspec(inci As %String, specdesc As %String) As %Library.String
{
	n (inci,specdesc)
	q:inci="" ""
	q:specdesc="" ""
	s specdesc=$$ALPHAUP^SSUTIL4(specdesc)
	s ret2=0
	s Flag=0
	s rowid=0
	f  s rowid=$o(^DHCItmSpecList(0,"INCI",inci,rowid)) q:(rowid="")!(Flag=1)  d
	.s SPECDesc=$p(^DHCItmSpecList(rowid),"^",2)
	.s specdesc=$$ALPHAUP^SSUTIL4(specdesc)
	.i SPECDesc[specdesc d
	..s Flag=1
	.e  i specdesc [SPECDesc d
	..s ret2=rowid
	.
	s ret=$s(Flag=1:1,ret2>0:2_"^"_ret2,1:"")
	q ret
}

/// Descript:	查询库存项规格
/// Table:INC_Itm
/// Input:库存项id
/// Return：
/// w ##class(web.DHCSTMHUI.INCALIAS).GetIncSpec(13)
ClassMethod GetIncSpec(InciId) As %Library.String
{
	n (InciId)
	q:InciId="" ""
	s SPECDescStr=""
	s SpecId=0
	f  s SpecId=$o(^DHCItmSpecList(0,"INCI",InciId,SpecId))  q:SpecId=""  d
	.s SPECDesc=$p(^DHCItmSpecList(SpecId),"^",2)
	.q:SPECDesc=""
	.i SPECDescStr=""  d
	..s SPECDescStr=SPECDesc
	.e  d
	..s SPECDescStr=SPECDescStr_"/"_SPECDesc
	.
	q SPECDescStr
}

}
