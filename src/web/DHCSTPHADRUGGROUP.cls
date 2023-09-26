Import SQLUser

Class web.DHCSTPHADRUGGROUP Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetDrugOrdCat()
{
 ;all ctloc  
	k PLIST 
	s code="Drug"
	&sql(declare cura cursor for
	select arcic_rowid,arcic_desc,arcic_ordertype from ARC_ItemCat
	                where ARCIC_ORDERTYPE=:code)
	s i=1
	&sql(open cura)
	f  &sql(fetch cura into :arcicdr(i),:arcic(i),:type(i))  q:SQLCODE  d
	.s PLIST=i
	.s type=$p(type(i),$C(1),2)
	.s PLIST(i)=arcicdr(i)_"^"_arcic(i)_"^"_type
	.s i=i+1
	&sql(close cura)
	q i-1                     
 ;form DHCStkDrugGroup
}

ClassMethod GetDrugGroup()
{
 s result=""
 &sql(declare curb cursor for
  select SDG_Code,SDG_Desc,SDG_RowId from DHCStkDrugGroup )
 s i=1
 &sql(open curb)
 f  &sql(fetch curb into :code,:desc,:id)  q:SQLCODE  d
   .i result'="" s result=result_"!"_code_"^"_desc_"^"_+id
   .e   s result=code_"^"_desc_"^"_+id
 &sql(close curb)
 q $g(result)
}

ClassMethod GetRel(mrowid, ordcatdr)
{
	&sql(select SDGI_RowId into :id  from DHCStkDrugGrpItm 
	     where  SDGI_SDG_Parref=:mrowid  and SDGI_OrderCat_DR=:ordcatdr)
	q:SQLCODE'=0 0
	q:SQLCODE=0 1
}

ClassMethod GetCat(ordcatdr)
{
	s cat=""
	s id=$o(^DHCSTDRUGGRP(0,"ORDCAT",ordcatdr,""))
	i id'="" d
	.s cat=$p(^DHCSTDRUGGRP(id),"^",1)
	q cat
	   
	;-->>DHCStkDrugGroup,insert,update,delete
}

ClassMethod InsertMast(code, desc, ConfigStr)
{
	s code=$zcvt(code,"U")
	s code=$g(code),desc=$g(desc),type=code
	s ispack=$p(ConfigStr,"@",2)
	s reserve=$p(ConfigStr,"@",3)
	s reqflag=$p(ConfigStr,"@",4)
	s HospId=$p(ConfigStr,"@",5)
	s configStr=$p(ConfigStr,"@",1) 
	s prtDetail=$p(configStr,"^",2)
	s prtTotal=$p(configStr,"^",3)
	s prtCode=$p(configStr,"^",4)
	s prtReserve=$p(configStr,"^",5)
	s prtPreview=$p(configStr,"^",6)
	s prtNoStock=$p(configStr,"^",7)
	s chkExist=..CheckExistType(code,desc,"",HospId)
	q:chkExist'="" chkExist
    &sql(
		insert into DHCStkDrugGroup
		(
			SDG_Code, SDG_Desc, SDG_Type, SDG_IsPack, SDG_Reserve,
			SDG_ReqFlag, SDG_PrtDetail, SDG_PrtTotal, SDG_PrtCode, SDG_PrtReserve, 
			SDG_PrtPreview, SDG_PrtNoStock
		)
		values
		(
			:code, :desc, :type, :ispack, :reserve,
			:reqflag,:prtDetail, :prtTotal, :prtCode, :prtReserve,
			:prtPreview, :prtNoStock
		)
	) 
	q:SQLCODE'=0 -1
	s Rowid=$p(%ROWID,$c(1))
	i HospId'="" d ##class(PHA.FACE.IN.Com).SaveBasicDataHosp("DHCStkDrugGroup",Rowid,HospId)
	q $p(%ROWID,$c(1))
}

ClassMethod UpdateMast(id, code, desc, ConfigStr)
{
	s code=$zcvt(code,"U")
	s HospId=$p(ConfigStr,"@",5)
	s chkExist=..CheckExistType(code,desc,id,HospId)
	q:chkExist'="" chkExist
	s type=code
	s ispack=$p(ConfigStr,"@",2)
	s reserve=$p(ConfigStr,"@",3)
	s reqflag=$p(ConfigStr,"@",4)
	s configStr=$p(ConfigStr,"@",1) 
	s prtDetail=$p(configStr,"^",2)
	s prtTotal=$p(configStr,"^",3)
	s prtCode=$p(configStr,"^",4)
	s prtReserve=$p(configStr,"^",5)
	s prtPreview=$p(configStr,"^",6)
	s prtNoStock=$p(configStr,"^",7)
	&sql(
		update DHCStkDrugGroup  
		set SDG_Code = :code, SDG_Desc = :desc, SDG_Type = :type, SDG_IsPack = :ispack, SDG_Reserve=:reserve,
			SDG_ReqFlag = :reqflag, SDG_PrtDetail = :prtDetail, SDG_PrtTotal = :prtTotal, SDG_PrtCode = :prtCode, SDG_PrtReserve = :prtReserve, 
			SDG_PrtPreview = :prtPreview, SDG_PrtNoStock = :prtNoStock
		where SDG_Rowid=:id
	)
	q:SQLCODE'=0 0
	q:SQLCODE=0 1
}

ClassMethod DeleteMast(id, HospId = "")
{
	n (id,HospId)
	&sql(delete from  DHCStkDrugGroup where SDG_Rowid=:id)
	q:SQLCODE'=0 0
	i HospId'="" d ##class(PHA.FACE.IN.Com).DeleteBasicDataHosp("DHCStkDrugGroup",id,HospId)
	q:SQLCODE=0 1
}

ClassMethod InsertItm(parref, ordcatdr)
{
	s ordcatdesc=$p(^ARC("IC",ordcatdr),"^",2)
	s type=$p(^ARC("IC",ordcatdr),"^",7)
	;
	;-->>DHCStkDrugGrpItm
	&sql(select max(SDGI_ChildSub) into :childsub from DHCStkDrugGrpItm where SDGI_SDG_Parref=:parref)
	i $g(childsub)=""  s childsub=0
	s childsub=childsub+1
	&sql(insert into DHCStkDrugGrpItm(SDGI_SDG_Parref,SDGI_ChildSub,SDGI_OrderCat_DR,SDGI_OrderCatDesc,SDGI_Type)
	 values(:parref,:childsub,:ordcatdr,:ordcatdesc,:type))
	q:SQLCODE'=0 -1
	q $p(%ROWID,$c(1))
}

ClassMethod DeleteItm(parref, ordcatdr)
{
	&sql(delete from DHCStkDrugGrpItm where SDGI_SDG_Parref=:parref and SDGI_OrderCat_DR=:ordcatdr)
	q:SQLCODE'=0 0
	q:SQLCODE=0 1
}

ClassMethod DrugOrdCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DrugOrdCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod DrugOrdCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DrugOrdCatExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod DrugOrdCatExecute(ByRef qHandle As %Binary, distype As %String, arccatonly = "", HospID = "") As %Status
{
	;
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	;
	q:distype="" $$$OK
	s code="R"
	&sql(declare xx1 cursor for select arcic_rowid,arcic_code,arcic_desc from ARC_ItemCat where ARCIC_ORDERTYPE=:code)
	&sql(open xx1)
	f  &sql(fetch xx1 into :rowid,:code,:desc) q:SQLCODE  d
	.s inselect=..GetRel(distype,rowid)
	.q:(arccatonly=1)&&(inselect'=1)
	.s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("ARC_ItemCat",rowid,HospID) //医院级别授权
	.q:flag="N"
	.s dispcat=..getDisp(rowid)
	.s wholeflag=""
	.s chl=$o(^DHCSTDRUGGRP(0,"ORDCAT",rowid,distype,""))
	.i chl'="" s wholeflag=$p(^DHCSTDRUGGRP(distype,"I",chl),"^",4)
	.d OutputRow
	&sql(close xx1)
 //	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow
	Set Data=$lb(rowid,code,desc,inselect,$g(dispcat),wholeflag)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	q
}

Query DrugOrdCat(distype As %String, arccatonly = "", HospID = "") As %Query(ROWSPEC = "tOrdCatRowid:%String,tOrdCatCode:%String,tOrdCatDesc:%String,tSelect:%String,tDispCat:%String,tWholeDisp:%String")
{
}

Query GetDisType() As %SQLQuery(ROWSPEC = "tCode:%String,tDesc:%String,tRowid:%String,tOrdType:%String")
{
	select sdg_code,sdg_desc,sdg_rowid,sdg_type from dhcstkdruggroup
}

ClassMethod DispCatDesc(catcode As %String) As %String
{
 n (catcode)
 &sql( select sdg_desc into :catdesc from DHCStkDrugGroup where sdg_code=:catcode)
 q:SQLCODE ""
 q $g(catdesc)
}

ClassMethod getDisp(rowid)
{
 s druggroup=$o(^DHCSTDRUGGRP(0,"ORDCAT",rowid,""))
 q:druggroup="" ""
 q:'$d(^DHCSTDRUGGRP(druggroup)) ""
 s drggrpdesc=$p(^DHCSTDRUGGRP(druggroup),"^",2)
 q $g(drggrpdesc)
}

Query GetLookUpDisType() As %SQLQuery
{
	select sdg_desc,sdg_rowid from dhcstkdruggroup
}

ClassMethod GetDispTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDispTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDispTypeExecute(ByRef qHandle As %Binary, HospId = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
    //
	s Rowid=0 f  s Rowid=$o(^DHCSTDRUGGRP(Rowid)) q:Rowid=""  d
	. s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("DHCStkDrugGroup",Rowid,HospId) //医院级别授权
	. q:flag="N"
	. s drugGrpData=$g(^DHCSTDRUGGRP(Rowid))
	. s Code=$p(drugGrpData,"^",1)
	. s Desc=$p(drugGrpData,"^",2)
	. s Type=$p(drugGrpData,"^",3)
	. s IsPack=$p(drugGrpData,"^",4)
	. s Reserve=$p(drugGrpData,"^",5)
	. s ReqFlag=$p(drugGrpData,"^",6)
	. s PrintDetail=$p(drugGrpData,"^",9)
	. s PrintTotal=$p(drugGrpData,"^",10)
	. s PrintOther=$p(drugGrpData,"^",11)
	. s PrintResRet=$p(drugGrpData,"^",12)
	. s PrintIsPreView=$p(drugGrpData,"^",13)
	. s PrintNoStock=$p(drugGrpData,"^",14)
	. d OutputRows
	. 
	Quit $$$OK
	
OutputRows

	s Data=$lb(Code,Desc,Rowid,Type,+PrintDetail,+PrintTotal,PrintOther,+IsPack,+Reserve,+ReqFlag,PrintResRet,PrintIsPreView,PrintNoStock)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

ClassMethod GetDispTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDispTypeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetDispType(HospId) As %Query(ROWSPEC = "tCode:%String,tDesc:%String,tRowid:%String,tOrdType:%String,tPrtDetail:%String,tPrtTotal:%String,tPrtOther:%String,tIsPack:%String,tReserve:%String,tReqFlag:%String,tPrtResRet:%String,tIsPreView:%String,tPrtNoStock:%String")
{
}

/// 保存药品类别明细配置
/// Creator:LiangQiang
/// CreatDate:2013-04-19
ClassMethod SaveConfig(mrowid, ordcatdr, flag)
{
	
  n (mrowid,ordcatdr,flag)
  s chl=$o(^DHCSTDRUGGRP(0,"ORDCAT",ordcatdr,mrowid,""))
  q:chl="" -1
  s $p(^DHCSTDRUGGRP(mrowid,"I",chl),"^",4)=flag
  q 0
}

/// creator:    yunhaibao
/// createdate: 2017-11-22
/// description:验证发药类别代码是否已存在
/// return:		-11:代码存在,-12:名称存在
/// w ##class(web.DHCSTPHADRUGGROUP).CheckExistType("ZCY","ZZZ")
ClassMethod CheckExistType(code, desc, id = "", HospId = "")
{
	n (code,desc,id,HospId)
	s ret=""
	i id="" d
	.&SQL(declare curdg cursor for SELECT SDG_rowId FROM DHCStkDrugGroup WHERE SDG_Code=:code)
	.&sql(open curdg)
	.f  &sql(fetch curdg into :Rowid) q:SQLCODE  d
	..s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("DHCStkDrugGroup",Rowid,HospId) //医院级别授权
	..q:flag="N"
	..s ret="-1^代码已存在"
	.&sql(close curdg)
	.q:ret'=""
	.&SQL(declare curdg2 cursor for SELECT SDG_rowId FROM DHCStkDrugGroup WHERE SDG_Desc=:desc)
	.&sql(open curdg2)
	.f  &sql(fetch curdg2 into :Rowid) q:SQLCODE  d
	..s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("DHCStkDrugGroup",Rowid,HospId) //医院级别授权
	..q:flag="N"
	..s ret="-1^名称已存在"
	.&sql(close curdg2)
	e  d
	.&SQL(declare curdg3 cursor for SELECT SDG_rowId FROM DHCStkDrugGroup WHERE SDG_Code=:code and SDG_rowId!=:id)
	.&sql(open curdg3)
	.f  &sql(fetch curdg3 into :Rowid) q:SQLCODE  d
	..s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("DHCStkDrugGroup",Rowid,HospId) //医院级别授权
	..q:flag="N"
	..s ret="-1^代码已存在"
	.&sql(close curdg3)
	.q:ret'=""
	.&SQL(declare curdg4 cursor for SELECT SDG_rowId FROM DHCStkDrugGroup WHERE SDG_Desc=:desc and SDG_rowId!=:id)
	.&sql(open curdg4)
	.f  &sql(fetch curdg4 into :Rowid) q:SQLCODE  d
	..s flag =##class(PHA.FACE.IN.Com).GetShowDataFlag("DHCStkDrugGroup",Rowid,HospId) //医院级别授权
	..q:flag="N"
	..s ret="-1^名称已存在"
	.&sql(close curdg4)
	q ret
}

/// w ##class(web.DHCSTPHADRUGGROUP).SynGlobalToTable()
ClassMethod SynGlobalToTable()
{
	s id = 0
	for {
		s id = $o(^DHCSTPHACONFIG("PrintType",id))
		q:(id = "")
		s gData = ^DHCSTPHACONFIG("PrintType",id)
		s prtDetail=$p(gData,"^",2)
		s prtTotal=$p(gData,"^",3)
		s prtCode=$p(gData,"^",4)
		s prtReserve=$p(gData,"^",5)
		s prtPreview=$p(gData,"^",6)
		s prtNoStock=$p(gData,"^",7)
		&sql(
			update DHCStkDrugGroup  
			set SDG_PrtDetail = :prtDetail, SDG_PrtTotal = :prtTotal, SDG_PrtCode = :prtCode, SDG_PrtReserve = :prtReserve, 
				SDG_PrtPreview = :prtPreview, SDG_PrtNoStock = :prtNoStock
			where SDG_Rowid=:id
		)
		
		w $p(gData,"^",1)_":完成,"_SQLCODE,!
	}
	q ""
}

}
