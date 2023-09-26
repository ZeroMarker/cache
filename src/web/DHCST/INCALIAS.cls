Import sqluser

/// Descript:库存项别名相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-16
Class web.DHCST.INCALIAS Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   查询库存项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-09
/// Table:INC_Alias
/// Input:库存项id
/// Output:
/// Return：库存项别名
ClassMethod Select(InciId) As %Library.String
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
/// Return：0,成功; -1：库存项为空,-2:不存在该库存项，错误数据串：保存失败
ClassMethod Save(InciId, ListData) As %Library.String
{
    n (InciId,ListData)
    q:InciId="" -1
    q:'$d(^INCI(InciId)) -2
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
    .q:Alias=""
    .i IncaId'=""  d
    ..&sql(Update INC_alias Set inca_text=:Alias Where INCA_Rowid=:IncaId)
    ..i SQLCODE'=0  d
    ...s ErrData=ErrData_","_Alias
    .e  d
    ..;保存别名
    ..s IncaId=$o(^INCALIAS(0,"ALIAS",$$ALPHAUP^SSUTIL4(Alias),$$ALPHAUP^SSUTIL4(ItmDesc),0))
    ..q:IncaId'=""      ;该别名已经存在
    ..&sql(INSERT INTO INC_alias (inca_inci_dr,inca_code,inca_desc,inca_text) VALUES (:InciId,:ItmCode,:ItmDesc,:Alias))
    ..i SQLCODE'=0  d
    ...s ErrData=ErrData_","_Alias
    ...s rett=$$ErrorRecord^DHCSTERROR("SaveAliasForInc:INC_alias",ItmCode,SQLCODE_":"_%msg)
    ..e  d
    ...s IncaId=$p(%ROWID,$c(1))
    ..q:ErrData'=""
    ..;维护医嘱项别名
    ..s AutoAddAAByIA=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTDRUGMAINTAIN","AutoAddAAByIA")
    ..i AutoAddAAByIA="Y"  d
    ...s ArcimId=$p(^INCI(InciId,1),"^",3)
    ...q:ArcimId=""
    ...s ret=##class(web.DHCST.ARCALIAS).Save(ArcimId,"^"_Alias)
    .
    q:ErrData'="" ErrData
    q 0
}

/// Descript:   删除库存项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-10
/// Table:INC_Alias
/// Input:别名id
/// Output:
/// Return：0,成功;-1:没有要删除的记录；-2：操作失败
ClassMethod Delete(IncaRowid) As %Library.String
{
    n (IncaRowid)
    q:IncaRowid="" -1
    ;
    s Err=0
    &sql(Delete From INC_alias Where INCA_Rowid=:IncaRowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("DeleteAliasForInc:INC_alias",IncaRowid,SQLCODE_":"_%msg)
    .s Err=-2
    .
    q Err
}

/// Descript:   删除库存项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-10
/// Table:INC_Alias
/// Input:库存项id
/// Output:
/// Return：0,成功;-1:没有要删除的记录；-2：操作失败
ClassMethod DeleteItmAlias(IncRowid As %String) As %Library.String
{
    n (IncRowid)
    q:IncRowid="" -1
    ;
    s Err=0
    &sql(Delete From INC_alias Where INCA_INCI_DR=:IncRowid)
    i (SQLCODE'=0)&&(SQLCODE'=100)  d
    .s rett=$$ErrorRecord^DHCSTERROR("DeleteItmAlias:INC_alias",IncRowid,SQLCODE_":"_%msg)
    .s Err=-2
    .
    q Err
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

/// creator:    yunhaibao
/// createdate: 2017-07-04
/// description:根据库存项ID查询别名列表
/// input:		strParams(库存项ID)
/// w ##class(%ResultSet).RunQuery("web.DHCST.INCALIAS","QueryByRowId","858")
Query QueryByRowId(strParams = "") As websys.Query(ROWSPEC = "incAliasId,incAliasText")
{
}

ClassMethod QueryByRowIdExecute(ByRef qHandle As %Binary, strParams = "") As %Status
{
	n (qHandle,strParams)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s incItmRowId=$p(strParams,"^",1)
	q:incItmRowId="" $$$OK
    s incAliasId=0
    f  s incAliasId=$o(^INCALIAS(0,"INCI",incItmRowId,incAliasId))  q:(incAliasId="")  d
    .q:+incAliasId=0
    .s incAliasDesc=$p(^INCALIAS(incAliasId),"^",4)
	.s Data=$lb(incAliasId,incAliasDesc)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	q $$$OK
}

/// creator:    yunhaibao
/// createdate: 2017-07-03
/// description:根据库存项ID+别名,匹配别名表
/// input:		incId(医嘱项ID),aliasDesc(别名)
/// return:     +retval<0 不存在
/// w ##class(web.DHCST.INCALIAS).CheckIncAliasExist("858","amxl")
ClassMethod CheckIncAliasExist(incItmId, inputAlias)
{
	n (inputAlias,incItmId)
	s inputAlias=$zcvt(inputAlias,"U")
	q:inputAlias="" "-1^入参别名为空"
	q:incItmId="" -1_"^医嘱项ID为空"
	s aliasId="",exist=-1
    f  s aliasId=$o(^INCALIAS(0,"INCI",incItmId,aliasId))  q:(aliasId="")||(exist'<0)  d
    .q:+aliasId=0
    .s aliasDesc=$p(^INCALIAS(aliasId),"^",4)
	.s aliasDesc=$zcvt(aliasDesc,"U")
	.i aliasDesc[inputAlias s exist=1
	q exist
}

}
