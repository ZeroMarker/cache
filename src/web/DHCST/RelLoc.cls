Import sqluser

Class web.DHCST.RelLoc Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// w ##class(web.DHCST.RelLoc).GetRelLocDescByID("0","30",102,"R","mz")
ClassMethod GetRelLocDescByID(Start, Limit, ProLoc, reltype = "", locDesc = "") As %String
{
	n (Start, Limit,ProLoc,reltype,locDesc)
	s locDesc=$$ALPHAUP^SSUTIL4(locDesc)
	s json = ##class(Code.JsonObj).%New()
	s count = 0
	;s reltype=""
	i reltype="" d
	.f  s reltype=$o(^DHCLOCREL(0,"PLOC",reltype)) q:reltype=""  d
	..s relrowid=""
	..f  s relrowid=$o(^DHCLOCREL(0,"PLOC",reltype,ProLoc,relrowid)) q:relrowid=""  d
	...s reclocid=$p(^DHCLOCREL(relrowid),"^",2)
	...s recloccode=$p(^CTLOC(reclocid),"^",1)
	...s reclocdesc=$p(^CTLOC(reclocid),"^",2)
	...s reclocconname=$p(^CTLOC(reclocid),"^",43)
	...q:(locDesc'="")&&($$ALPHAUP^SSUTIL4(reclocconname)'[locDesc)&&($$ALPHAUP^SSUTIL4(reclocdesc)'[locDesc)
	...s type=$p(^DHCLOCREL(relrowid),"^",3)
	...s tmp=reclocid_"^"_recloccode_"^"_reclocdesc_"^"_reclocdesc_"^"_relrowid_"^"_type
	...s count = count+1
	...d json.InsertRowData(tmp)
	e  d
	.s relrowid=""
	.f  s relrowid=$o(^DHCLOCREL(0,"PLOC",reltype,ProLoc,relrowid)) q:relrowid=""  d
	..s reclocid=$p(^DHCLOCREL(relrowid),"^",2)
	..s recloccode=$p(^CTLOC(reclocid),"^",1)
	..s reclocdesc=$p(^CTLOC(reclocid),"^",2)
	..s reclocconname=$p(^CTLOC(reclocid),"^",43)
	..q:(locDesc'="")&&($$ALPHAUP^SSUTIL4(reclocconname)'[locDesc)&&($$ALPHAUP^SSUTIL4(reclocdesc)'[locDesc)
	..s type=$p(^DHCLOCREL(relrowid),"^",3)
	..s tmp=reclocid_"^"_recloccode_"^"_reclocdesc_"^"_reclocdesc_"^"_relrowid_"^"_type
	..s count = count+1
	..d json.InsertRowData(tmp)
	s resultString = json.getJsonData("RowId^Code^Desc^Description^RelRowId^Type",count)
	q resultString
}

ClassMethod SaveRelLoc(proloc, listData) As %String
{
	q:proloc="" -1   ;科室不能为空
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s err=""
    f i=1:1:len  d
    .s Detail=$p(listData,rowDelim,i)
    .q:Detail=""
    .s Rowid=$p(Detail,"^",1)
    .s Code=$p(Detail,"^",2)
    .s Desc=$p(Detail,"^",3)
    .s Type=$p(Detail,"^",4)
    .s RelRowId=$p(Detail,"^",5)
    .i RelRowId="" d
    ..s ret=..Insert(proloc,Rowid,Type)
    .e  d
    ..s ret=..Update(RelRowId,Rowid,Type)
    .i +ret=0  d
    ..s err=err_","_Desc
    .e  i +ret="-1" d
    ..s err=err_","_Desc_"已存在"
    .e  d
    ..s NewId=ret
    q:err="" 0
    q -2_":"_err
}

ClassMethod Insert(ProLoc, RecLoc, Type) As %String
{
	n (ProLoc,RecLoc,Type)
	s err=0
	q:$d(^DHCLOCREL(0,"PRLOC",RecLoc,ProLoc)) -1  //已经存在对应关系对出
    &sql(Insert into DHCST_LocRelation(DHCLocRel_Ploc_dr,DHCLocRel_Rloc_dr,DHCLocRel_Type)
    values(:ProLoc,:RecLoc,:Type))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHCST_LocRelation",ProLoc,SQLCODE_":"_%msg)
    .s err=-1
    q:err'=0 ""
    q $p(%ROWID,$c(1))
}

ClassMethod Update(RelRowId, RecLoc, Type) As %String
{
	n (RelRowId,RecLoc,Type)
	s err=0
	&SQL(update DHCST_LocRelation set DHCLocRel_Rloc_dr=:RecLoc,DHCLocRel_Type=:Type where DHCLocRel_RowID=:RelRowId)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHCST_LocRelation",RecLoc,SQLCODE_":"_%msg)
    .s err=-1
    q:err'=0 ""
    q $p(%ROWID,$c(1))
}

/// w ##class(web.DHCST.RelLoc).Delete(20)
ClassMethod Delete(rowid) As %String
{
	n (rowid)
    ;不能为空项
    q:rowid="" ""
    s Err=0  
    i $d(^DHCLOCREL(0,"INCI",rowid)) d
    .&sql(Delete from DHCST_LocRelationItm where LRELI_LocRel_ParRef=:rowid)
    .i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Delete:DHCST_LocRelationItm",rowid,SQLCODE)
    ..s Err=-4
    &sql(Delete from DHCST_LocRelation where DHCLocRel_RowID=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHCST_LocRelation",rowid,SQLCODE)
    .s Err=-3 
    q Err
}

ClassMethod GetProRelLocDescByID(Start, Limit, ReLoc, reltype = "", locDesc = "") As %String
{
	n (Start, Limit,ReLoc,reltype,locDesc)
	s locDesc=$$ALPHAUP^SSUTIL4(locDesc)
	s json = ##class(Code.JsonObj).%New()
	s count = 0
	;s reltype=""
	i reltype=""  d
	.f  s reltype=$o(^DHCLOCREL(0,"RLOC",reltype)) q:reltype=""  d
	..s relrowid=""
	..f  s relrowid=$o(^DHCLOCREL(0,"RLOC",reltype,ReLoc,relrowid)) q:relrowid=""  d
	...s reclocid=$p(^DHCLOCREL(relrowid),"^",1)
	...s recloccode=$p(^CTLOC(reclocid),"^",1)
	...s reclocdesc=$p(^CTLOC(reclocid),"^",2)
	...s reclocconname=$p(^CTLOC(reclocid),"^",43)
	...q:(locDesc'="")&&($$ALPHAUP^SSUTIL4(reclocconname)'[locDesc)&&($$ALPHAUP^SSUTIL4(reclocdesc)'[locDesc)
	...s type=$p(^DHCLOCREL(relrowid),"^",3)
	...s tmp=reclocid_"^"_recloccode_"^"_reclocdesc_"^"_reclocdesc_"^"_relrowid_"^"_type
	...s count = count+1
	...d json.InsertRowData(tmp)
	e  d
	.s relrowid=""
	.f  s relrowid=$o(^DHCLOCREL(0,"RLOC",reltype,ReLoc,relrowid)) q:relrowid=""  d
	..s reclocid=$p(^DHCLOCREL(relrowid),"^",1)
	..s recloccode=$p(^CTLOC(reclocid),"^",1)
	..s reclocdesc=$p(^CTLOC(reclocid),"^",2)
	..s reclocconname=$p(^CTLOC(reclocid),"^",43)
	..q:(locDesc'="")&&($$ALPHAUP^SSUTIL4(reclocconname)'[locDesc)&&($$ALPHAUP^SSUTIL4(reclocdesc)'[locDesc)
	..s type=$p(^DHCLOCREL(relrowid),"^",3)
	..s tmp=reclocid_"^"_recloccode_"^"_reclocdesc_"^"_reclocdesc_"^"_relrowid_"^"_type
	..s count = count+1
	..d json.InsertRowData(tmp)
	s resultString = json.getJsonData("RowId^Code^Desc^Description^RelRowId^Type",count)
	q resultString
}

/// Creator : MYQ 
/// CreatDate : 2014-11-04
/// Description : 保存能申领的药品明细
/// Input : ProLoc-供应科室,RecLoc-申领科室,Detail-药品ID串
/// Output : 药品明细
/// w ##class(web.DHCST.RelLoc).SaveRelLocInciDetail(ProLoc,RecLoc,Detail)
ClassMethod SaveRelLocInciDetail(proloc, recloc, listData) As %String
{
	q:proloc="" -1   ;供给科室不能为空
	q:recloc="" -1   ;请求科室不能为空
	s locrel=$o(^DHCLOCREL(0,"PRLOC",recloc,proloc,""))
    s rowDelim=##class(web.DHCST.Common.UtilCommon).RowDataDelim()
    s len=$l(listData,rowDelim)
    s err=""
    
    tstart
    s $ZT="Error^DHCSTERROR"
    f i=1:1:len  d
    .s Detail=$p(listData,rowDelim,i)
    .q:Detail=""
    .s Rowid=$p(Detail,"^",1)
    .s Inci=$p(Detail,"^",2)
    .s ret=..InsertInci(locrel,Inci)
    .i +ret=0  d
    ..s err=err_","_Desc
    .e  d
    ..s NewId=ret
    
    i err'="" trollback
    tcommit
    
    q:err="" 0
    q -2_":"_err
}

/// w ##class(web.DHCST.RelLoc).InsertInci("13","1893")
ClassMethod InsertInci(locrel, inci) As %String
{
	n (locrel,inci)
	q:locrel="" -1
	q:inci="" -1
	s lreli=$o(^DHCLOCREL(0,"INCI",locrel,inci,""))
	q:lreli'="" -2 ;不能重复添加
	s err=0
	s Sub=1+$o(^DHCLOCREL(locrel,"LRELI",""),-1)
    &sql(Insert into DHCST_LocRelationItm(LRELI_LocRel_ParRef,LRELI_ChildSub,LRELI_INCI_DR)
    values(:locrel,:Sub,:inci))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Insert:DHCST_LocRelationItm",locrel,SQLCODE_":"_%msg)
    .s err=-1
    b ;1
    q:err'=0 ""
    q $p(%ROWID,$c(1))
}

ClassMethod DeleteInci(rowid) As %String
{
	n (rowid)
    ;
    ;不能为空项
    q:rowid="" ""
    ;
    s Err=0
    &sql(Delete from DHCST_LocRelationItm where LRELI_RowID=:rowid)
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Delete:DHCST_LocRelationItm",rowid,SQLCODE_":"_%msg)
    .s Err=-3
    q Err
}

/// Creator : MYQ 
/// CreatDate : 2014-11-04
/// Description : 查询该科室(RecLoc)能向上级科室(ProLoc)申领的药品明细
/// Input : ProLoc-供应科室,RecLoc-申领科室
/// Output : 药品明细
/// w ##class(web.DHCST.RelLoc).GetRelLocInciDetail(0,200,485,484)
ClassMethod GetRelLocInciDetail(Start, Limit, ProLoc, RecLoc) As %String
{
	n (Start,Limit,ProLoc,RecLoc)
	;s ^tmyq("GetRelLocInciDetail")=Start_","_Limit_","_ProLoc_","_RecLoc
	s json = ##class(Code.JsonObj).%New()
	s count = 0
	s locrel=$o(^DHCLOCREL(0,"PRLOC",RecLoc,ProLoc,""))
	q:locrel="" -2 ;两科室之间没有供求关系
	s sub=""
	f  s sub=$o(^DHCLOCREL(locrel,"LRELI",sub)) q:sub=""  d
	.s lreli=locrel_"||"_sub
	.s inci=$p(^DHCLOCREL(locrel,"LRELI",sub),"^",1)
	.s incicode=$p(^INCI(inci,1),"^",1)
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.s tmp=lreli_"^"_inci_"^"_incicode_"^"_incidesc
	.s count = count+1
	.d json.InsertRowData(tmp)
	
	s resultString = json.getJsonData("LreliRowid^Inci^InciCode^InciDesc",count)
	q resultString
}

/// Creator : MYQ 
/// CreatDate : 2014-11-04
/// Description : 查询该科室(RecLoc)能否向向上级科室(ProLoc)申领该药品(Inci)
/// Input : ProLoc-供应科室,RecLoc-申领科室,Inci-药品ID
/// Output : 1-能申领该药品,0-不能申领该药品
/// w ##class(web.DHCST.RelLoc).ChkPRLocFlagByInci(485,484,1784)
ClassMethod ChkPRLocFlagByInci(ProLoc, RecLoc, Inci) As %String
{
	n (ProLoc,RecLoc,Inci)
	
	s locrel=$o(^DHCLOCREL(0,"PRLOC",RecLoc,ProLoc,""))
	q:locrel="" 0  ;两科室间没有供求关系
	s sub=$o(^DHCLOCREL(locrel,"LRELI",""))
	q:sub="" 1 ;两科室间未对科室申领药品做限制
	s childsub=$o(^DHCLOCREL(0,"INCI",locrel,Inci,""))
	q:childsub'="" 1 ;允许申领该药品
	q:childsub="" 0  ;该药品不在维护的药品之内
}

}
