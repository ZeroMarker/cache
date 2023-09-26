Import sqluser

/// Descript:医嘱项别名相关
/// Creater:	ZhangDongmei
/// CreateDate:	2012-05-17
Class web.DHCSTMHUI.ARCALIAS Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	增加医嘱项别名
/// Creater:	ZhangDongmei
/// CreateDate:	2012-01-13
/// Table:INC_Alias
/// Input:库存项id;别名id^别名,别名id2^别名2...
/// Output:
/// Return：0,成功;
/// -2:医嘱项id不能为空
/// 错误数据：保存失败
/// W ##class(web.DHCSTMHUI.ARCALIAS).jsSave("2||1","[{""Alias"":""abcdefgabcdefg""}]")
ClassMethod jsSave(ArcimId, ListData) As %Library.String
{
	n (ArcimId,ListData)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	i ArcimId="" d RtnObj.Err(-1,"","医嘱项不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json() 
	ts
	s RtnObj=..Save(ArcimId,ListData)
	i RtnObj.success=0 d
	.tc 
	else  d
	.tro
	q RtnObj.Json()
}

/// ParamFlag: 参数标记,默认为空,参数调用传Y,避免循环调用
ClassMethod Save(ArcimId As %String, ListData As %String, ParamFlag = "") As RtnObj
{
	n (ArcimId,ListData,ParamFlag,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(ListData)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s paramStr=..sssParamStr()
	s Sub=+ArcimId
	s Ver=$p(ArcimId,"||",2)
	q:(Sub="")||(Ver="") RtnObj.Err(-1,"","医嘱项有问题","",0) 
	q:'$d(^ARCIM(Sub,Ver)) RtnObj.Err(-1,"","医嘱项有问题","",0)
	s ArcimDesc=$p(^ARCIM(Sub,Ver,1),"^",2)
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s AliasId=Obj.%Get("RowId")
		s Alias=Obj.%Get("Alias")
		i AliasId'=""  d
		.&sql(Update ARC_Alias Set ALIAS_Text=:Alias Where ALIAS_RowId=:AliasId)
		.i SQLCODE'=0  d
		..d RtnObj.Err(-1,"",$ClassName()_".Save:SQLCODE"_SQLCODE_":"_$g(%msg))
		..q:RtnObj.success'=0
		e  d
		.;保存别名
		.s IsExistFlag=$$IsExistAlias(ArcimId,Alias)
		.q:IsExistFlag="Y"
		.;i IsExistFlag="Y" d RtnObj.Err(-1,"","存在重复的医嘱项别名!") q   ;已经存在该别名
		.&sql(INSERT INTO ARC_Alias (ALIAS_ARCIM_DR,ALIAS_Desc,ALIAS_Text,ALIAS_DateFrom) VALUES (:ArcimId,:ArcimDesc,:Alias,+$h))
		.i SQLCODE'=0  d
		..d RtnObj.Err(-1,"",$ClassName()_".Save:SQLCODE"_SQLCODE_":"_$g(%msg))
		..q:RtnObj.success'=0
		.e  d
		..s AliasId=$p(%ROWID,$c(1))
		..//自动维护收费项别名
		..s AutoAddTAByAA=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("AppName"),"AutoAddTAByAA",paramStr)
		..i AutoAddTAByAA="Y" d
		...s ret=##class(web.DHCSTMHUI.ARCITMMAST).AddTarItmAlias(ArcimId,Alias)
		..
		..;维护库存项别名
		..s AutoAddIAByAA=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(##class(web.DHCSTMHUI.DrugInfoMaintain).%GetParameter("AppName"),"AutoAddIAByAA",paramStr)
		..i (ParamFlag'="Y")&&(AutoAddIAByAA="Y") d
		...s InciId=$o(^INCI(0,"ARCIM_DR",+ArcimId,0))
		...q:InciId=""
		...s Params=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Alias,"Alias")
		...s RtnObj=##class(web.DHCSTMHUI.INCALIAS).Save(InciId,"["_Params_"]","Y")
		
		q:RtnObj.success'=0
	}
	q RtnObj
IsExistAlias(ArcimId,Alias)
	n (ArcimId,Alias)
	q:(ArcimId="")||(Alias="") ""
	s Flag="N"
	s AliasId=0
	f  s AliasId=$o(^ARC("ALIAS",0,"ARCIM",ArcimId,AliasId)) q:(AliasId="")||(Flag="Y")  d
	.s AliasText=$p(^ARC("ALIAS",AliasId),"^",6)
	.i AliasText=Alias s Flag="Y" q
	q Flag
}

/// Descript:	删除医嘱项别名
/// Creater:	ZhangDongmei
/// CreateDate:	2012-01-13
/// Table:ARC_Alias
/// Input:别名id
/// Output:
/// Return：0,成功;错误代码
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
		&sql(Delete From ARC_alias Where ALIAS_RowId=:RowId)
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

/// Descript:	查询医嘱项别名
/// Creater:	ZhangDongmei
/// CreateDate:	2012-01-13
/// Table:ARC_Alias
/// Input:库存项id
/// Output:
/// Return：别名id^别名
Query SelectAlias(ArcimId As %String) As Query(ROWSPEC = "RowId,Alias") [ SqlProc ]
{
}

ClassMethod SelectAliasExecute(ByRef qHandle As %Binary, ArcimId As %String) As %Status
{
	n (qHandle,ArcimId)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:ArcimId="" $$$OK
	s Sub=+ArcimId
	s Ver=$p(ArcimId,"||",2)
	q:Sub="" $$$OK
	q:Ver="" $$$OK
	q:'$d(^ARCIM(Sub,Ver)) $$$OK 
	s AliasId=0
	f  s AliasId=$o(^ARC("ALIAS",0,"ARCIM",ArcimId,AliasId))  q:AliasId=""  d
	.s Alias=$p(^ARC("ALIAS",AliasId),"^",6)
	.d OutPutRowAlias
	
 Quit $$$OK
OutPutRowAlias
 s Data=$lb(AliasId,Alias)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:	查询医嘱项别名
/// Creater:	ZhangDongmei
/// CreateDate:	2011-12-23
/// Table:INC_Itm
/// Input:库存项id
/// Output:别名1/别名2
/// Return：
ClassMethod GetArcAlias(ArcimId) As %Library.String
{

	n (ArcimId)
	q:ArcimId="" ""
	s AliasStr=""
	s ArcaId=0
	f  s ArcaId=$o(^ARC("ALIAS",0,"ARCIM",ArcimId,ArcaId))  q:ArcaId=""  d
	.s Alias=$p(^ARC("ALIAS",ArcaId),"^",6)
	.q:Alias=""
	.i AliasStr=""  d
	..s AliasStr=Alias
	.e  d
	..s AliasStr=AliasStr_"/"_Alias
	.
	q AliasStr
}

}
