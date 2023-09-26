Import sqluser

/// Descript:医嘱项别名相关
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-17
Class web.DHCST.ARCALIAS Extends (%RegisteredObject, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:   增加医嘱项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-13
/// Table:INC_Alias
/// Input:库存项id;别名id^别名,别名id2^别名2...
/// Output:
/// Return：0,成功;
/// -2:医嘱项id不能为空
/// 错误数据：保存失败
ClassMethod Save(ArcimId As %String, ListData As %String) As %Library.String
{
    
    n (ArcimId,ListData)
    q:ArcimId="" -1_"^请先保存医嘱项基本信息！"
    s Sub=+ArcimId
    s Ver=$p(ArcimId,"||",2)
    q:(Sub="")||(Ver="")||('$d(^ARCIM(Sub,Ver))) -2_"^医嘱项未维护成功！" 
    s ArcimDesc=$p(^ARCIM(Sub,Ver,1),"^",2)
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s Len=$l(ListData,rowDelim)
    s ErrData=""
    s ResultString=""
    f i=1:1:Len  d
    .s RowData=$p(ListData,rowDelim,i)
    .s AliasId=$p(RowData,"^",1)
    .s Alias=$p(RowData,"^",2)
    .q:Alias=""
    .i AliasId'=""  d
    ..&sql(Update ARC_Alias Set ALIAS_Text=:Alias Where ALIAS_RowId=:AliasId)
    ..i SQLCODE'=0  d
    ...s rett=$$ErrorRecord^DHCSTERROR("Save:ARC_Alias",Alias,SQLCODE_":"_%msg)
    ...s ErrData=ErrData_","_Alias
    .e  d
    ..;保存别名
    ..&SQL(SELECT ALIAS_RowId into :AliasId FROM ARC_Alias WHERE ALIAS_ARCIM_DR=:ArcimId AND ALIAS_Text=:Alias)
	..q:SQLCODE=0
    ..q:AliasId'=""   ;已经存在该别名
    ..;b ;alias
    ..&sql(INSERT INTO ARC_Alias (ALIAS_ARCIM_DR,ALIAS_Desc,ALIAS_Text) VALUES (:ArcimId,:ArcimDesc,:Alias))
    ..i SQLCODE'=0  d
    ...s rett=$$ErrorRecord^DHCSTERROR("SaveAliasForOrd:ARC_Alias",Alias,SQLCODE_":"_%msg)
    ...s ErrData=ErrData_","_Alias
    ..e  d
    ...s AliasId=$p(%ROWID,$c(1))
    ..q:ErrData'=""
    ..
    ..;维护库存项别名
    ..s AutoAddIAByAA=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTDRUGMAINTAIN","AutoAddIAByAA")
    ..i AutoAddIAByAA="Y"  d
    ...s InciId=$o(^INCI(0,"ARCIM_DR",+ArcimId,0))
    ...q:InciId=""
    ...s ret=##class(web.DHCST.INCALIAS).Save(InciId,"^"_Alias)
    .
    s ErrData=##class(web.DHCST.ARCITMMAST).AddTarItmAlias(ArcimId,ListData) //收费项别名
    q:ErrData'="" ErrData 
    q 0
}

/// Descript:   删除医嘱项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-13
/// Table:ARC_Alias
/// Input:别名id
/// Output:
/// Return：0,成功;错误代码
ClassMethod Delete(AliasRowid) As %Library.String
{
    n (AliasRowid)
    q:AliasRowid="" -1
    ;
    s Err=0
    &sql(Delete From ARC_alias Where ALIAS_RowId=:AliasRowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:ARC_alias",AliasRowid,SQLCODE_":"_%msg)
    .s Err=-2
    .
    q Err
}

/// Descript:   删除医嘱项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2012-05-18
/// Table:ARC_Alias
/// Input:医嘱项id
/// Output:
/// Return：0,成功;错误代码
ClassMethod DeleteItmAlias(ArcRowid As %String) As %Library.String
{
    n (ArcRowid)
    q:ArcRowid="" -1
    ;
    s Err=0
    &sql(Delete From ARC_alias Where ALIAS_ARCIM_DR=:ArcRowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:ARC_alias",ArcRowid,SQLCODE_":"_$g(%msg))
    .s Err=-2
    .
    q Err
}

/// Descript:   查询医嘱项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2012-01-13
/// Table:ARC_Alias
/// Input:库存项id
/// Output:
/// Return：别名id^别名
ClassMethod Select(ArcimId As %String) As %Library.String
{

    n (ArcimId)
    q:ArcimId="" ""
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

/// Descript:   查询医嘱项别名
/// Creater:    ZhangDongmei
/// CreateDate: 2011-12-23
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

/// 获取退药原因
ClassMethod GetRefRetReason(Start, Limit, Name) As %Library.String
{
	n (Start,Limit,Name)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "Select RefRet_ROWID As RowID,RefRet_Code As Code,RefRet_Desc As Name From DHC_StkRefuseRetReason"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(Code.JsonObj).%New()
	While(result.Next())
	{
		s Rowid = result.Data("RowID")
		s Code = result.Data("Code")
		s Desc = result.Data("Name")
		continue:(Name'="")&('$f(Desc,Name))
		s tmp=Rowid_"^"_Code_"^"_Desc
		s count = count+1
		i (count>Start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	d result.Close()
	s resultString = json.getJsonData("RowID^Code^Desc",count)
	k json
	Q resultString
}

/// 保存不可退药原因
ClassMethod SaveRefReason(ListData)
{
	N (ListData)
	S Len=$L(ListData,"#")
	s msg=0
    s err=0
	F i=1:1:Len   q:msg'=0  d
	.S mdata=$p(ListData,"#",i)
	.S RowID=$p(mdata,"^",1)
	.S Code=$p(mdata,"^",2)
	.S Desc=$p(mdata,"^",3)
	.q:Code=""
    .q:Desc=""
    .s tmpid=""
    .&SQL(SELECT RefRet_ROWID into :tmpid FROM DHC_StkRefuseRetReason WHERE RefRet_Code=:Code )
    .s:(tmpid'="")&(tmpid'=RowID) msg=-1
    .&SQL(SELECT RefRet_ROWID into :tmpid FROM DHC_StkRefuseRetReason WHERE RefRet_Desc=:Desc )
    .s:(tmpid'="")&(tmpid'=RowID) msg=-2
    .q:msg'=0
	.If RowID="" D
	..S flag=..InsertRetReason(Code,Desc)
	..s:flag'=0 err=err
	.Else  D
	..S flag=..UpdRetReason(RowID,Code,Desc) 
	..s:flag'=0 err=err
	q:msg=-1 msg //code_"重复"
    q:msg=-2 msg //desc_"重复"
    q:msg'=0 msg
    q err
}

ClassMethod InsertRetReason(Code, Desc) As %String
{
	N (Code,Desc)
	k PLIST
	S PLIST(2)=Code
	S PLIST(3)=Desc
	;不能为空项
	q:Code="" ""
    q:Desc="" ""
	&SQL(Insert Into DHC_StkRefuseRetReason values :PLIST())
	s Err=0
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_StkRefuseRetReason",Desc,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 0
    q $p(%ROWID,$c(1))
}

ClassMethod UpdRetReason(RowID, Code, Desc) As %String
{
	N (RowID,Code,Desc)
	k PLIST
	S PLIST(2)=Code
	S PLIST(3)=Desc
	;不能为空项
    q:Code="" ""
    q:Desc="" ""
    q:Rowid="" ""
    ;
    s Err=0
	&SQL(Update DHC_StkRefuseRetReason values :PLIST() where RefRet_ROWID=:RowID )
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_StkRefuseRetReason",Desc,SQLCODE_":"_%msg)
    .s Err=-1
    q Err
}

ClassMethod DelRetReason(RowID) As %String
{
	N (RowID)
	&SQL(Delete DHC_StkRefuseRetReason where RefRet_ROWID=:RowID )
	Q SQLCODE
}

/// 获取药品退药原因
/// w ##class(web.DHCST.ARCALIAS).GetRefReason(6939)
ClassMethod GetRefReason(inci) As %String
{
	N (inci)
	Q:inci="" "^^^"
	S InciCode=$P(^INCI(inci,1),"^",1)
	S InciDesc=$P(^INCI(inci,1),"^",2)
	S InfoDr=+$o(^DHCITMINFO(0,"INCI",inci,""))
	S ret=InciCode_"^"_InciDesc
	Q:InfoDr="" ret_"^^"
	S RefReaDr=$P(^DHCITMINFO(InfoDr),"^",46)
	Q:RefReaDr="" ret_"^^"
	S RefReason=$p(^DHCRFRETREASON(RefReaDr),"^",2) 
	Q ret_"^"_RefReaDr_"^"_RefReason
}

/// 更新药品退药原因
ClassMethod UpdDrgRefReason(InciCode, RefReaDr) As %String
{
	N (InciCode,RefReaDr)
	Q:InciCode="" ""
	S Inci=$o(^INCI(0,"Code1",InciCode_"Z",""))
	Q:Inci="" ""
	S InfoDr=+$o(^DHCITMINFO(0,"INCI",Inci,""))
	Q:InfoDr="" ""
	&SQL(update DHC_ItmAddionInfo set INFO_RefRetReason_Dr=:RefReaDr where INFO_RowId=:InfoDr )
	Q SQLCODE
}

/// 根据代码获取药品退药原因
/// w ##class(web.DHCST.ARCALIAS).GetRefReason(6939)
ClassMethod GetRefReasonByCode(incicode) As %String
{
	N (incicode)
	s inci=$o(^INCI(0,"Code1",incicode_"Z",""))
	q ..GetRefReason(inci)
}

/// creator:    yunhaibao
/// createdate: 2017-06-29
/// description:根据医嘱项ID查询别名列表
/// input:		strParams(医嘱项ID)
/// w ##class(%ResultSet).RunQuery("web.DHCST.ARCALIAS","QueryByRowId","533||1")
Query QueryByRowId(strParams = "") As websys.Query(ROWSPEC = "arcAliasId,arcAliasText")
{
}

ClassMethod QueryByRowIdExecute(ByRef qHandle As %Binary, strParams = "") As %Status
{
	n (qHandle,strParams)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s arcItmRowId=$p(strParams,"^",1)
	q:arcItmRowId="" $$$OK
    s arcAliasId=0
    f  s arcAliasId=$o(^ARC("ALIAS",0,"ARCIM",arcItmRowId,arcAliasId))  q:arcAliasId=""  d
    .s arcAliasText=$p(^ARC("ALIAS",arcAliasId),"^",6)
	.s Data=$lb(arcAliasId,arcAliasText)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	q $$$OK
}

/// creator:    yunhaibao
/// createdate: 2017-06-29
/// description:根据医嘱项ID+别名,匹配别名表
/// input:		arcItmID(医嘱项ID),aliasDesc(别名)
/// return:     +retval<0 不存在
/// w ##class(web.DHCST.ARCALIAS).CheckArcAliasExist("858||1","amxl")
ClassMethod CheckArcAliasExist(arcItmId, inputAlias)
{
	n (inputAlias,arcItmId)
	s inputAlias=$zcvt(inputAlias,"U")
	q:inputAlias="" "-1^入参别名为空"
	q:arcItmId="" -1_"^医嘱项ID为空"
	s aliasId="",exist=-1
	f  s aliasId=$o(^ARC("ALIAS",0,"ARCIM",arcItmId,aliasId)) q:(aliasId="")||(exist'<0)  d
	.q:+aliasId=0
	.s aliasDesc=$p(^ARC("ALIAS",aliasId),"^",6)
	.s aliasDesc=$zcvt(aliasDesc,"U")
	.i aliasDesc[inputAlias s exist=1
	q exist
}

}
