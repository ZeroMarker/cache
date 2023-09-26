Import SQLUser

Class web.DHCICUPara Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Careator:dingyanli
/// Date:20120911
/// ICUPara
/// d ##class(%ResultSet).RunQuery("web.DHCICUPara","FindICUPara")
Query FindICUPara() As %Query(ROWSPEC = "TTemplateID,TIcuaID,TDeptID,TFlag,tICUPANCSHDr,TType,TTemplateName,TDeptName") [ SqlProc ]
{
}

ClassMethod FindICUParaExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 
  	s tCtlocId=""
 	f  s tCtlocId=$o(^DHCICUPara(0,"Ctloc",tCtlocId)) q:tCtlocId=""  d
	    .s tIcuParaId=$o(^DHCICUPara(0,"Ctloc",tCtlocId,""))
	    .
	    .q:'$d(^DHCICUPara(tIcuParaId))
	    .s ICUPCtlocDr=$p(^DHCICUPara(tIcuParaId),"^",2)
	    .q:ICUPCtlocDr=""
	    .s ICUPICUADr=$p(^DHCICUPara(tIcuParaId),"^",1)
	    .q:ICUPICUADr'=""
	    .s tDept=$p($g(^CTLOC(+ICUPCtlocDr)),"^",2)
	    .s tDept=$p($g(^CTLOC(+ICUPCtlocDr)),"^",2)
	    .s ICUPIBPFlag=$p(^DHCICUPara(tIcuParaId),"^",3)
	    .s ICUPANCSHDr=$p(^DHCICUPara(tIcuParaId),"^",4)
	    .s ICUPType=$p(^DHCICUPara(tIcuParaId),"^",5)
	    .s ICUPDesc=$p(^DHCICUPara(tIcuParaId),"^",6)
	    .d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tIcuParaId,ICUPICUADr,ICUPCtlocDr,ICUPIBPFlag,ICUPANCSHDr,ICUPType,ICUPDesc,tDept)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindICUParaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUParaExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindICUParaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUParaExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod AddICUPara(LocId, TemplateName) As %String
{
	q:LocId="" "科室不能为空!"
	;判断是否存在，存在就退出
	s ret=0
	i ($d(^DHCICUPara(0,"Ctloc",LocId))>0) s ret=1
	q:ret=1 "该科室已存在模板"
	;----------
	s objICUPara = ##class(User.DHCICUPara).%New()
	s objICUPara.ICUPCtlocDr=LocId
	s objICUPara.ICUPDesc=TemplateName
	s saveStatus=objICUPara.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s IcuParaId=objICUPara.%Id()
	d objICUPara.%Close()
	q 0
}

ClassMethod UpdateICUPara(IcuParaId, LocId, ICUPICUADr, TemplateName) As %String
{
	q:IcuParaId="" "RowId不能为空!"
	q:LocId="" "科室不能为空!"
	;--------------
	s ret=0
	s oldCtlocDr=$p(^DHCICUPara(IcuParaId),"^",2)
	i ($d(^DHCICUPara(0,"Ctloc",LocId))>0)&(oldCtlocDr'=LocId) s ret=1
	q:ret=1 "该科室已存在模板,请重新选择科室或修改另一相同记录"
	;--------------
	q:'##class(User.DHCICUPara).%ExistsId(IcuParaId) "日志码表指针无对应记录!"
	s objICUPara = ##class(User.DHCICUPara).%OpenId(IcuParaId)
	s objICUPara.ICUPCtlocDr=LocId
	s objICUPara.ICUPDesc=TemplateName
	s updateStatus=objICUPara.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s IcuParaId=objICUPara.%Id()
	d objICUPara.%Close()
	q 0
}

ClassMethod DeleteICUPara(IcuParaId) As %String
{
	q:IcuParaId="" "RowId不能为空!"
	q:IcuParaId=1 "不允许删除"
	q:'##class(User.DHCICUPara).%ExistsId(IcuParaId) "码表指针无对应记录!"
	s deleteStatus=##class(User.DHCICUPara).%DeleteId(IcuParaId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

// d ##class(%ResultSet).RunQuery("web.DHCICUPara","FindICUParaItem","40","215","")

Query FindICUParaItem(ctlocId As %String, ICUPIViewCatId As %String = "", ICUPIComOrd As %String = "", desc As %String = "") As %Query(ROWSPEC = "TTemplateID,TID,TComOrdID,TSeqNo,TViewCatID,TItemCode,TItemDesc,TComOrdDesc,TViewCatDesc,TComOrdCode") [ SqlProc ]
{
}

ClassMethod FindICUParaItemExecute(ByRef qHandle As %Binary, ctlocId As %String, ICUPIViewCatId As %String = "", ICUPIComOrd As %String = "", desc As %String = "") As %Status
{
	s ^tempwhl("FindICUParaItem")=ctlocId_ICUPIViewCatId_ICUPIComOrd
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	;{DHC_ICU_Para.ICUP_RowId},"I",tIcuParaItemId
	s tCtlocId=""
	k ^TMPAN("ParaItem",$j)
	f  s tCtlocId=$o(^DHCICUPara(0,"Ctloc",tCtlocId)) q:tCtlocId=""  d
		.q:ctlocId=""
		.q:(ctlocId'="")&(tCtlocId'=ctlocId)
		.s tIcuParaId=$o(^DHCICUPara(0,"Ctloc",tCtlocId,""))
		.q:'$d(^DHCICUPara(tIcuParaId))
		.s tIcuParaItemId=0
		.f  s tIcuParaItemId=$o(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId)) q:tIcuParaItemId=""  d
			..s displayItemId=tIcuParaId_"||"_tIcuParaItemId
			..s tICUPIComOrdDr=$p($g(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId)),"^",4)
			..s tICUPIComOrdDesc=""
			..i tICUPIComOrdDr'="" s tICUPIComOrdDesc=$p($g(^DHCICUC("RecordItem",tICUPIComOrdDr)),"^",2)
			..q:(ICUPIComOrd'="")&(tICUPIComOrdDr'=ICUPIComOrd)
			..q:(desc'="")&(tICUPIComOrdDesc'="")&(($$ALPHAUP^SSUTIL4(tICUPIComOrdDesc))'[($$ALPHAUP^SSUTIL4(desc)))
			..i tICUPIComOrdDr'="" s tICUPIComOrdCode=$p($g(^DHCICUC("RecordItem",tICUPIComOrdDr)),"^",1)
			..s tICUPISeqNo=$p($g(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId)),"^",8)
			..q:tICUPISeqNo=""
			..s tICUPIViewCatDr=$p($g(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId)),"^",11)
			..q:tICUPIViewCatDr=""
			..q:(ICUPIViewCatId'="")&(tICUPIViewCatDr'[ICUPIViewCatId)
			..s tICUPIViewCatDesc=""
			..i tICUPIViewCatDr'="" s tICUPIViewCatDesc=$p($g(^DHCICUC("ViewCat",tICUPIViewCatDr)),"^",2)
			..s tICUPICode=$p($g(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId)),"^",13)
			..s tICUPIDesc=$p($g(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId)),"^",14)
			..s ^TMPAN("ParaItem",$j,tICUPIViewCatDr,tICUPISeqNo,displayItemId)=$lb(tIcuParaId,displayItemId,tICUPIComOrdDr,tICUPISeqNo,tICUPIViewCatDr,tICUPICode,tICUPIDesc,tICUPIComOrdDesc,tICUPIViewCatDesc,tICUPIComOrdCode)
	s tICUPIViewCatDr="" f  s tICUPIViewCatDr=$o(^TMPAN("ParaItem",$j,tICUPIViewCatDr)) q:tICUPIViewCatDr=""  d                                                                                         
	 .s tICUPISeqNo="" f  s tICUPISeqNo=$o(^TMPAN("ParaItem",$j,tICUPIViewCatDr,tICUPISeqNo)) q:tICUPISeqNo=""  d
	  	..s displayItemId="" f  s displayItemId=$o(^TMPAN("ParaItem",$j,tICUPIViewCatDr,tICUPISeqNo,displayItemId)) q:displayItemId=""  d
			...d OutputRow2
	k ^TMPAN("ParaItem",$j)
	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow2
	;s Data=$lb(tIcuParaId,displayItemId,tICUPIComOrdDr,tICUPISeqNo,tICUPIViewCatDr,tICUPICode,tICUPIDesc,tICUPIComOrdDesc,tICUPIViewCatDesc,tICUPIComOrdCode)
 	s ^CacheTemp(repid,ind)=^TMPAN("ParaItem",$j,tICUPIViewCatDr,tICUPISeqNo,displayItemId)
 	s ind=ind+1
	q
}

ClassMethod FindICUParaItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUParaItemExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindICUParaItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUParaItemExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// d ##class(web.DHCICUPara).AddICUParaItem(5094,"1.00",199,"PH121","PH121",1)
ClassMethod AddICUParaItem(ICUPIComOrdDr, ICUPISeqNo, ICUPIViewCatDr, ICUPICode, ICUPIDesc, ICUPIId) As %String
{
	q:(ICUPIId="") "码表指针不能为空!"
	q:(ICUPISeqNo="") "排序号不能为空!"
	q:'##class(User.DHCICUPara).%ExistsId(ICUPIId) "码表指针无对应记录!"
	s ret=##class(web.DHCICUPara).CheckRepeat(ICUPIDesc,ICUPICode,ICUPIId,ICUPIViewCatDr)
	q:ret=0 "相同显示分类下名称和代码不允许重复!"
	q:ret="-1" "名称不能为空!"
	q:ret="-2" "代码不能为空!"
	s number=$g(^DHCICUPara(ICUPIId,"I",0))
	s number=number+1
	k PLIST
	s PLIST(0)=ICUPIId
	s PLIST(6)=ICUPIComOrdDr
	s PLIST(10)=ICUPISeqNo
	s PLIST(13)=ICUPIViewCatDr
	s PLIST(15)=ICUPICode
	s PLIST(16)=ICUPIDesc
	//insert into DHC_ICU_ParaItem(ICUPI_Parref,ICUPICode) values(16,"aa")
    &sql(INSERT INTO sqluser.DHC_ICU_ParaItem Values :PLIST())
    s ICUPIRowId=%ROWID
    i SQLCODE'=0  TRollBack  q "-2^插入错误!"_"/"_SQLCODE
	q SQLCODE
}

ClassMethod UpdateICUParaItem(RowId3, tICUPIId, ICUPIComOrdDr, ICUPIViewCatDr, ICUPISeqNo, ICUPICode, ICUPIDesc) As %String
{
	q:RowId3="" "RowId不能为空!"
	q:(ICUPISeqNo="") "排序号不能为空!"
	s RowId1=$p(RowId3,"||",1)
	q:'##class(User.DHCICUPara).%ExistsId(RowId1) "码表指针无对应记录!"
	s ret=##class(web.DHCICUPara).CheckRepeat(ICUPIDesc,ICUPICode,tICUPIId,ICUPIViewCatDr,RowId3)
	q:ret=0 "相同显示分类下名称和代码不允许重复!"
	q:ret="-1" "名称不能为空!"
	q:ret="-2" "代码不能为空!"
	;q RowId3_"/"_tICUPIId_"/"_ICUPIComOrdDr_"/"_ICUPIViewCatDr_"/"_ICUPISeqNo_"/"_ICUPICode_"/"_ICUPIDesc
	k PLIST
	&sql(select * into :PLIST() from SQLUSER.DHC_ICU_ParaItem where ICUPI_RowId=:RowId3)
	s PLIST(0)=tICUPIId
	s PLIST(6)=ICUPIComOrdDr
	s PLIST(10)=ICUPISeqNo
	s PLIST(13)=ICUPIViewCatDr
	s PLIST(15)=ICUPICode
	s PLIST(16)=ICUPIDesc
    &sql(update SQLUSER.DHC_ICU_ParaItem Values :PLIST() where ICUPI_RowId=:RowId3)

    i SQLCODE'=0  TRollBack  q "-2^修改错误!"_SQLCODE
	q SQLCODE
}

ClassMethod DeleteICUParaItem(IcuParaItemId) As %String
{
	q:IcuParaItemId="" "RowId不能为空!"
	q:'##class(User.DHCICUParaItem).%ExistsId(IcuParaItemId) "码表指针无对应记录!"
	s deleteStatus=##class(User.DHCICUParaItem).%DeleteId(IcuParaItemId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

Query FindANCComOrd(ANCEViewCatId As %String = "", ComDesc As %String = "", IcuApply As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod FindANCComOrdExecute(ByRef qHandle As %Binary, ANCEViewCatId As %String = "", ComDesc As %String = "", IcuApply As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ANCComOrdId=0
	f  s ANCComOrdId=$o(^DHCICUC("RecordItem",ANCComOrdId))  q:ANCComOrdId=""  d
	    .s ANCComOrdCode=$p(^DHCICUC("RecordItem",ANCComOrdId),"^",1)
	    .s ANCComOrdDesc=$p(^DHCICUC("RecordItem",ANCComOrdId),"^",2)
	    .s tANCEViewCatId=$p(^DHCICUC("RecordItem",ANCComOrdId),"^",5)
	    .q:(ANCEViewCatId'="")&(tANCEViewCatId'[ANCEViewCatId)
	    .s tANCEViewCatIcuApply=""
	    .i tANCEViewCatId'="" s tANCEViewCatIcuApply=$p($g(^DHCICUC("ViewCat",tANCEViewCatId)),"^",8)
	    .q:tANCEViewCatIcuApply'="Y"
	    .s tIcuApply=$p(^DHCICUC("RecordItem",ANCComOrdId),"^",10)
    	.q:(tIcuApply'="")&(tIcuApply'="Y")
	    .;q:(ANCEViewCat'="")&(tANCEViewCat'[ANCEViewCat)
	    .s ANCComOrdDesc=$$UPPER^SSUTIL4(ANCComOrdDesc)
	    .s ComDesc=$$UPPER^SSUTIL4(ComDesc)
	    .s ANCComOrdCode=$$UPPER^SSUTIL4(ANCComOrdCode)
	    .q:(ComDesc'="")&((ANCComOrdDesc'[ComDesc)&&(ANCComOrdCode'[ComDesc))
		.d OutputRow4
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(ANCComOrdId,ANCComOrdCode,ANCComOrdDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANCComOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANCComOrdExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindANCComOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANCComOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindANCEViewCat(ANCEViewCat As %String = "") As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String") [ SqlProc ]
{
}

ClassMethod FindANCEViewCatExecute(ByRef qHandle As %Binary, ANCEViewCat As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tANCEViewCatId=0
	f  s tANCEViewCatId=$o(^DHCICUC("ViewCat",tANCEViewCatId))  q:tANCEViewCatId=""  d
	    .s tIcuApply=$p(^DHCICUC("ViewCat",tANCEViewCatId),"^",8)
	    .s tAnApply=$p(^DHCICUC("ViewCat",tANCEViewCatId),"^",7)  
	    .q:(tIcuApply'="Y")
	    .;q:(tIcuApply'="")&(tIcuApply'="Y")
	    .s tANCEViewCat=$p(^DHCICUC("ViewCat",tANCEViewCatId),"^",2)
	    .q:(ANCEViewCat'="")&(tANCEViewCat'[ANCEViewCat)
	    .s tANCEViewCatCode=$p(^DHCICUC("ViewCat",tANCEViewCatId),"^",1)
		.d OutputRow5
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(tANCEViewCatId,tANCEViewCatCode,tANCEViewCat)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindANCEViewCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANCEViewCatExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindANCEViewCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANCEViewCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindICUParaItemDetails(DisplayItemID As %String) As %Query(ROWSPEC = "TTemplateID,TDisplayItemID,TPropertyValueID,TPropertyItemID,TPropertyValue,TPropertyItemDesc,TDisplayItemDesc") [ SqlProc ]
{
}

ClassMethod FindICUParaItemDetailsExecute(ByRef qHandle As %Binary, DisplayItemID As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tIcuParaId=$p(DisplayItemID,"||",1)
 	i tIcuParaId'="" {	
	s tIcuParaItemId="" f  s tIcuParaItemId=$o(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId)) q:tIcuParaItemId=""  d
		.s paraItemID=tIcuParaId_"||"_tIcuParaItemId
		.q:(paraItemID'=DisplayItemID)
		.s paraItemDesc=$p($g(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId)),"^",14)
		.s tIcuParaItemDetailsId=0 f  s tIcuParaItemDetailsId=$o(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId,"D",tIcuParaItemDetailsId)) q:tIcuParaItemDetailsId=""  d
			..s paraItemDetailID=paraItemID_"||"_tIcuParaItemDetailsId
			..s ICUPIDICUCPDr=$p(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId,"D",tIcuParaItemDetailsId),"^",1)
			..s ICUPIDICUCPCode=""
			..i ICUPIDICUCPDr'="" s ICUPIDICUCPCode=$li(^DHCICUC("Property",ICUPIDICUCPDr),1)
			..s ICUPIDICUCPDesc=""
			..i ICUPIDICUCPDr'="" s ICUPIDICUCPDesc=$li(^DHCICUC("Property",ICUPIDICUCPDr),2)
			..s ICUPIDValue=$p(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId,"D",tIcuParaItemDetailsId),"^",2)
			..d OutputRow6
 	}
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow6
	s Data=$lb(tIcuParaId,paraItemID,paraItemDetailID,ICUPIDICUCPDr,ICUPIDValue,ICUPIDICUCPDesc,paraItemDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindICUParaItemDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUParaItemDetailsExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindICUParaItemDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUParaItemDetailsExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod AddICUParaItemDetails(ICUPIDICUCPDr As %String, ICUPIDValue As %String, IcuParaItemId) As %String
{
	q:(IcuParaItemId="") "码表指针不能为空!"
	q:(ICUPIDICUCPDr="") "指针不能为空!"
	q:'##class(User.DHCICUParaItem).%ExistsId(IcuParaItemId) "码表指针无对应记录!"
	k PLIST
	s PLIST(0)=IcuParaItemId
	s PLIST(3)=ICUPIDICUCPDr
	s PLIST(4)=ICUPIDValue
	//insert into DHC_ICU_ParaItem(ICUPI_Parref,ICUPICode) values(16,"aa")
    &sql(INSERT INTO sqluser.DHC_ICU_ParaItemDetail Values :PLIST())
    s ICUPIRowId=%ROWID
    ;q ICUPIRowId
    i SQLCODE'=0  TRollBack  q "-3^插入错误!"_"/"_SQLCODE
	q SQLCODE
}

ClassMethod UpdateICUParaItemDetails(IcuParaItemDetailsId, IcuParaItemId, ICUPIDICUCPDr, ICUPIDValue) As %String
{
	q:IcuParaItemId="" "RowId不能为空!"
	;s RowId1=$p(RowId3,"||",1)
	q:'##class(User.DHCICUParaItem).%ExistsId(IcuParaItemId) "码表指针无对应记录!"
	k PLIST
	&sql(select * into :PLIST() from SQLUSER.DHC_ICU_ParaItemDetail where ICUPID_RowId=:IcuParaItemDetailsId)
	s PLIST(3)=ICUPIDICUCPDr
	s PLIST(4)=ICUPIDValue
    &sql(update SQLUSER.DHC_ICU_ParaItemDetail Values :PLIST() where ICUPID_RowId=:IcuParaItemDetailsId)
    i SQLCODE'=0  TRollBack  q "-2^修改错误!"_SQLCODE
	q SQLCODE
}

ClassMethod DeleteICUParaItemDetails(IcuParaItemDetailsId) As %String
{
	q:IcuParaItemDetailsId="" "RowId不能为空!"
	s deleteStatus=##class(User.DHCICUParaItemDetail).%DeleteId(IcuParaItemDetailsId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

ClassMethod SaveParaItems(paraItemList As %String) As %String
{
	s result=""
	f i=1:1:$l(paraItemList,"^")  d
	.s paraItem=$p(paraItemList,"^",i)
	.s itemObj=..SetParaItem(paraItem)
	.q:itemObj=""
	.d itemObj.%Save()
	.i result'="" s result=result_"^"
	.s result=result_itemObj.%Id()
	.d itemObj.%Close()
	q result
}

ClassMethod SetParaItem(paraItem As %String) As User.DHCICUParaItem
{
	s paraItemObj=""
	s paraItemId=$p(paraItem,$c(3),1)
	s paraId=$p(paraItem,$c(3),2)
	
	i paraItemId="" s paraItemObj=##class(User.DHCICUParaItem).%New(paraId)
	e  s paraItemObj=##class(User.DHCICUParaItem).%OpenId(paraItemId)
	
	s paraItemObj.ICUPIType=$p(paraItem,$c(3),3)
	s paraItemObj.ICUPIViewSuperCatDr=##class(User.DHCICUCViewSuperCat).%OpenId($p(paraItem,$c(3),4))
	q:paraItemObj.ICUPIViewSuperCatDr="" ""
	s paraItemObj.ICUPIOeoreDr=$p(paraItem,$c(3),5)
	s paraItemObj.ICUPIComOrdDr=##class(User.DHCICUCRecordItem).%OpenId($p(paraItem,$c(3),6))
	q:paraItemObj.ICUPIComOrdDr="" ""
	s paraItemObj.ICUPIFlag=$p(paraItem,$c(3),7)
	s paraItemObj.ICUPISource=$p(paraItem,$c(3),8)
	
	s iconId=$p(paraItem,$c(3),9)
	i iconId'="" s paraItemObj.ICUPIIconDr=##class(User.DHCANCIcon).%OpenId(iconId)
	
	s paraItemObj.ICUPISeqNo=+$p(paraItem,$c(3),10)
	s paraItemObj.ICUPIColor=$p(paraItem,$c(3),11)
	
	s scaleId=$p(paraItem,$c(3),12)
	i scaleId'="" s paraItemObj.ICUPIScaleDr=##class(User.DHCANCScale).%OpenId(scaleId)
	
	s paraItemObj.ICUPIViewCatDr=##class(User.DHCICUCViewCat).%OpenId($p(paraItem,$c(3),13))
	s paraItemObj.ICUPIUomDr=$p(paraItem,$c(3),14)
	s paraItemObj.ICUPICode=$p(paraItem,$c(3),15)
	s paraItemObj.ICUPIDesc=$p(paraItem,$c(3),16)
	s paraItemObj.ICUPIStartDate=##class(web.DHCClinicCom).ConvertToDateH($p(paraItem,$c(3),17))
	s paraItemObj.ICUPIStartTime=##class(web.DHCClinicCom).ConvertToTimeH($p(paraItem,$c(3),18))
	s paraItemObj.ICUPIEndDate=##class(web.DHCClinicCom).ConvertToDateH($p(paraItem,$c(3),19))
	s paraItemObj.ICUPIEndTime=##class(web.DHCClinicCom).ConvertToTimeH($p(paraItem,$c(3),20))
	s relateItemId=$p(paraItem,$c(3),21)
	i relateItemId'="" s paraItemObj.ICUPIICUPIDr=##class(User.DHCICUParaItem).%OpenId(relateItemId)
	
	s paraItemObj.ICUPIParref=##class(User.DHCICUPara).%OpenId(paraId)
	q paraItemObj
}

/// 功能：按icuaId找日期为date的病人参数。ifAccordCtloc数据同步科室模板
/// 如果是新病人，则取科室中取模板参数，此时取开始日期为当前日期，结束日期为9999-12-31
/// 返回值：tIcupId病人参数Id,tIcupDesc病人参数描述,tIcupiId项目Id,tIcupiCode项目代码,tIcupiDesc项目描述,
/// tIcupiViewSuperCatDr显示大类Id,tIcupiViewCatDr显示分类Id,tIcupiComOrdDr常用医嘱Id,tIcupiOeoreDr医嘱执行项Id,
/// tIcupiSeqNo项目序号,tIcupiStartDate项目开始日期,tIcupiStartTime开始时间,tIcupiEndDate项目结束日期,tIcupiEndTime结束时间,
/// tIcupidId属性Id,tIcupidValue属性值,tIcucpCode属性码表代码,tIcucpDesc属性码表描述,tIcucpDefaultValue属性码表默认值
/// d ##class(%ResultSet).RunQuery("web.DHCICUPara","FindIcuaPara","3","2018-12-26")
Query FindIcuaPara(icuaId As %String, date As %String = "", ifAccordCtloc As %String = "Y") As %Query(ROWSPEC = "ParaId,ParaDesc,Id,Code,Description,RecordDocumentId,RecordCatId,RecordItemId,OEOreId,SeqNo,StartDate,StartTime,EndDate,EndTime,ItemDetailId,ItemDetailValue,PropertyCode,PropertyDesc,PropertyDefaultValue,ParaItemId") [ SqlProc ]
{
}

ClassMethod FindIcuaParaExecute(ByRef qHandle As %Binary, icuaId As %String, date As %String = "", ifAccordCtloc As %String = "Y") As %Status
{
	// d ##class(%ResultSet).RunQuery("web.DHCICUPara","FindIcuaPara","2105")
	s repid=$i(^CacheTemp)
	i $g(ind)="" s ind=1
	i icuaId="" s qHandle=$lb(0,repid,0) q $$$OK

	// 查找icuaId对应的科室
	s deptTempId=""
	s episodeID=$p($g(^DHCICUArrange(icuaId)),"^",1)
	s bedId=$p($g(^DHCICUArrange(icuaId)),"^",4)
	s papmiId=$p($g(^PAADM(episodeID)),"^",1)
	i bedId'="" d
	.s wardId=$p(bedId,"||",1)
	.s tCtlocId=$p(^PAWARD(+wardId),"^",5)
	// 查找科室模板ID
	s deptTempId=$O(^DHCICUPara(0,"Ctloc",tCtlocId,deptTempId))
	i deptTempId="" s qHandle=$lb(0,repid,0) q $$$OK
	// 建立索引
	s tempRowId="",sub="",tName=""
	
	f  s tempRowId=$O(^DHCICUPara(deptTempId,"I",tempRowId)) q:(tempRowId="")  d
	.s recordItemId=$p($g(^DHCICUPara(deptTempId,"I",tempRowId)),"^",4)
	.;q:recordItemId'=tRowId
	.f  s sub=$O(^DHCICUPara(deptTempId,"I",tempRowId,"D",sub)) q:(sub="")  d
	..s itemStr=$g(^DHCICUPara(deptTempId,"I",tempRowId,"D",sub))
	..;b "xx"
	..s type=""
	..s typeDr=$p(itemStr,"^",1)
	..i typeDr'="" d
	...i $d(^DHCICUC("Property",typeDr)) s type=$LIST($g(^DHCICUC("Property",typeDr)),1)
	..s enable=$p(itemStr,"^",2)
	..q:((type'="IsTemplate")||(enable'="true"))
	..s isTemplate=1
	..s tName=$p($g(^DHCICUPara(deptTempId,"I",tempRowId)),"^",14)
	..s viewCatDr=$p($g(^DHCICUPara(deptTempId,"I",tempRowId)),"^",11)
	..s seqNo=$p($g(^DHCICUPara(deptTempId,"I",tempRowId)),"^",8)
	..s TempRecordItem(recordItemId)=tName
	..s TempRecordItem(recordItemId,"ViewCatDr")=viewCatDr
	..;w recordItemId," ",viewCatDr,!
	..s TempRecordItem(recordItemId,"SeqNo")=seqNo
	
	s date=##class(web.DHCClinicCom).ConvertToDateH(date)
	s tIcupId=$o(^DHCICUPara(0,"ICUA",icuaId,""))
	k oldParaMain
	s ifHaveOldPara=0
	i tIcupId'="" s ifHaveOldPara=1
	i (tIcupId'="")&(ifAccordCtloc="Y") d
		.s icupiSub=10000
		.f  s icupiSub=$o(^DHCICUPara(tIcupId,"I",icupiSub)) q:(icupiSub="")  d //根据科室sub找，病人的会变
			..q:$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",19)=""
			..s mainIcupiSub=$p($p(^DHCICUPara(tIcupId,"I",icupiSub),"^",19),"||",2)
			..s icucriId=$p($g(^DHCICUPara(tIcupId,"I",mainIcupiSub)),"^",4)
			..q:icucriId=""
			..s ancvcId=$p(^DHCICUPara(tIcupId,"I",mainIcupiSub),"^",11)
			..s oldParaMain(tIcupId_"||"_icupiSub)=ancvcId_"^"_icucriId
	
	s wardId=+$p($g(^DHCICUArrange(+icuaId)),"^",4)
	s wardCtlocId=$p($g(^PAWARD(wardId)),"^",5)
	s locParaId=$o(^DHCICUPara(0,"Ctloc",+wardCtlocId,""))
	
	i (tIcupId="") d //完全复制科室模板
		.q:locParaId=""
		.i tIcupId="" d
		.s icupDesc=$p(^DHCICUPara(locParaId),"^",6)
		.k PLIST
		.s PLIST(2)=icuaId
		.s PLIST(7)=icupDesc
		.&sql(insert into DHC_ICU_Para Values :PLIST())
		.q:SQLCODE
		.s tIcupId=$g(%ROWID)
		.k ^DHCICUPara(tIcupId,"I")
		.m ^DHCICUPara(tIcupId,"I")=^DHCICUPara(locParaId,"I")
		.s ^DHCICUPara(tIcupId,"I",0)=$o(^DHCICUPara(tIcupId,"I",""),-1)
		.s icupiSub=0
		.f  s icupiSub=$o(^DHCICUPara(tIcupId,"I",icupiSub)) q:(icupiSub="")!(icupiSub>10000) 
			..s $p(^DHCICUPara(tIcupId,"I",icupiSub),"^",15)=""

	//w "ifHaveOldPara="_ifHaveOldPara_"/"_locParaId_"/"_tIcupId,!
	s status=$p($g(^DHCICUArrange(icuaId)),"^",18) ; 当状态为停止时不再更新个人模板
    i ((ifHaveOldPara)&&(status'="T")) d //调整个人参数与科室模板一致 : i ifHaveOldPara d //调整个人参数与科室模板一致
		.s icupiSub=0
		.f  s icupiSub=$o(^DHCICUPara(locParaId,"I",icupiSub)) q:icupiSub=""  d //修改起止时间
			..i '$d(^DHCICUPara(tIcupId,"I",icupiSub)) d //科室模板增加项
				...s ^DHCICUPara(tIcupId,"I",icupiSub)=^DHCICUPara(locParaId,"I",icupiSub)
			..e  d
				...i $p(^DHCICUPara(tIcupId,"I",icupiSub),"^",1,14)'=$p(^DHCICUPara(locParaId,"I",icupiSub),"^",1,14) d
					....s $p(^DHCICUPara(tIcupId,"I",icupiSub),"^",1,14)=$p(^DHCICUPara(locParaId,"I",icupiSub),"^",1,14)
					....//w icupiSub_": "_$p(^DHCICUPara(locParaId,"I",icupiSub),"^",1,14),!
					....//w "     "_$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",1,14),!
			..k ^DHCICUPara(tIcupId,"I",icupiSub,"D") //同步属性项
			..m ^DHCICUPara(tIcupId,"I",icupiSub,"D")=^DHCICUPara(locParaId,"I",icupiSub,"D")
		.q:tIcupId=""
		.s icupiSub=0
		.f  s icupiSub=$o(^DHCICUPara(tIcupId,"I",icupiSub)) q:(icupiSub="")!(icupiSub>10000)  d //科室模板删除项
			..q:$d(^DHCICUPara(locParaId,"I",icupiSub))
			..q:$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",17)'=""
			..s $p(^DHCICUPara(tIcupId,"I",icupiSub),"^",17)=+$h
			..s $p(^DHCICUPara(tIcupId,"I",icupiSub),"^",18)=$p($h,",",2)
	
	i ('ifHaveOldPara)!(ifAccordCtloc="Y") d //新病人参数，加扩展项
		.q:tIcupId=""
		.s icupiSub=0
		.f  s icupiSub=$o(^DHCICUPara(tIcupId,"I",icupiSub)) q:(icupiSub="")!(icupiSub>10000)  d //修改起止时间
			..s icucriId=$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",4)
			..s ancvcId=$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",11)
			..q:(icucriId="")!(ancvcId="")
			..i $d(tmpList(ancvcId,icucriId)) s ^tmpICU("dupParaItem",tIcupId_"||"_icupiSub)=$h_" "_tIcupId_"||"_tmpList(ancvcId,icucriId)
			..e  d 
				...s tmpList(ancvcId,icucriId)=icupiSub
			..q:'$d(^DHCICUPara(locParaId,"I",icupiSub))
			..s itemPara(ancvcId_"^"_icucriId)=tIcupId_"||"_icupiSub
			..i (icucriId=$p(^DHCICUPara(locParaId,"I",icupiSub),"^",4))&(ancvcId=$p(^DHCICUPara(locParaId,"I",icupiSub),"^",11)) d
				...s $p(^DHCICUPara(tIcupId,"I",icupiSub),"^",1,14)=$p(^DHCICUPara(locParaId,"I",icupiSub),"^",1,14)
		.s ^DHCICUPara(tIcupId,"I",0)=$o(^DHCICUPara(tIcupId,"I",""),-1)
		.i ^DHCICUPara(tIcupId,"I",0)<10000 s ^DHCICUPara(tIcupId,"I",0)=10000
		.k templateList,mainList
		.s icucriId=4999
		.f  s icucriId=$o(^DHCICUC("RecordItem",icucriId)) q:icucriId=""  d
		..i $p(^DHCICUC("RecordItem",icucriId),"^",28)'="" s templateList($p(^DHCICUC("RecordItem",icucriId),"^",28),icucriId)=""
			..i $p(^DHCICUC("RecordItem",icucriId),"^",23)'="" s mainList($p(^DHCICUC("RecordItem",icucriId),"^",23),icucriId)=""
		.s icupiSub=0
		.f  s icupiSub=$o(^DHCICUPara(locParaId,"I",icupiSub)) q:(icupiSub="")!(icupiSub>10000)  d //根据科室sub找，病人的会变
			..//i '$d(^DHCICUPara(tIcupId,"I",icupiSub)) w "q:"_icupiSub
			..q:'$d(^DHCICUPara(tIcupId,"I",icupiSub))
			..s icucriId=$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",4)
			..i (icupiSub>0)&(icucriId="") k ^DHCICUPara(tIcupId,"I",icupiSub) q //删除无意义数据
			..q:'$d(^DHCICUC("RecordItem",icucriId))
			..s ancvcId=$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",11)
			..q:ancvcId=""
			..s mainIcucriId=$p(^DHCICUC("RecordItem",icucriId),"^",23)
			..i (+mainIcucriId'=0) d //根据相同分类和主项，赋主项参数指向
				...q:'$d(tmpList(ancvcId,mainIcucriId))
				...s $p(^DHCICUPara(tIcupId,"I",icupiSub),"^",19)=tIcupId_"||"_tmpList(ancvcId,mainIcucriId)
			..
			..i ($p(^DHCICUPara(tIcupId,"I",icupiSub),"^",15)="") d //新项
				...s $p(^DHCICUPara(tIcupId,"I",icupiSub),"^",15)=+$h-1
				...s $p(^DHCICUPara(tIcupId,"I",icupiSub),"^",16)=$p($h,",",2)
				...s $p(^DHCICUPara(tIcupId,"I",icupiSub),"^",17)=""
				...s $p(^DHCICUPara(tIcupId,"I",icupiSub),"^",18)=""
				...s icucriTemplateIcucriDr=$p(^DHCICUC("RecordItem",icucriId),"^",28)
				...q:icucriTemplateIcucriDr=""
				...i (+mainIcucriId=0) s tmpList(ancvcId,icucriTemplateIcucriDr)=icupiSub
				...q:'$d(tmpList(ancvcId,icucriTemplateIcucriDr)) //模板主项未加入
				...//添加模板子项
				...//w mainIcucriId_"/add "_ancvcId_"/"_icucriTemplateIcucriDr,!
				...s icucriTemplateSubICUCRIDr=$p(^DHCICUC("RecordItem",icucriId),"^",29)
				...s subIcucriId=0
				...f  s subIcucriId=$o(mainList(icucriTemplateIcucriDr,subIcucriId)) q:subIcucriId=""  d
					....q:(icucriTemplateSubICUCRIDr'="")&(("|"_icucriTemplateSubICUCRIDr_"|")'[("|"_subIcucriId_"|"))
					....s ^DHCICUPara(tIcupId,"I",0)=$g(^DHCICUPara(tIcupId,"I",0))+1
					....s curIcupiSub=^DHCICUPara(tIcupId,"I",0)
					....q:$d(^DHCICUPara(tIcupId,"I",curIcupiSub))
					....s ^DHCICUPara(tIcupId,"I",curIcupiSub)=^DHCICUPara(tIcupId,"I",tmpList(ancvcId,icucriTemplateIcucriDr))
					....s $p(^DHCICUPara(tIcupId,"I",curIcupiSub),"^",4)=subIcucriId
					....i $p(^DHCICUC("RecordItem",subIcucriId),"^",14)'="" d
						.....s $p(^DHCICUPara(tIcupId,"I",curIcupiSub),"^",8)=$p(^DHCICUC("RecordItem",subIcucriId),"^",14)
					....s $p(^DHCICUPara(tIcupId,"I",curIcupiSub),"^",13)=$p(^DHCICUC("RecordItem",subIcucriId),"^",1)_icucriId
					....s $p(^DHCICUPara(tIcupId,"I",curIcupiSub),"^",14)=$p(^DHCICUC("RecordItem",subIcucriId),"^",2)
					....s $p(^DHCICUPara(tIcupId,"I",curIcupiSub),"^",19)=tIcupId_"||"_icupiSub
	;b
	i tIcupId'="" d 
		.q:'$d(^DHCICUPara(tIcupId))
		.s tIcupDesc=$p(^DHCICUPara(tIcupId),"^",6)
		.k resList
		.s icupiSub=0
		.f  s icupiSub=$o(^DHCICUPara(tIcupId,"I",icupiSub)) q:icupiSub=""  d
			..s tIcupiComOrdDr=$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",4)
			..s tIcupiOeoreDr=$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",3)
			..s ICUPIIsActive=$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",20)
			..;ICUPIIsActive为N时为删除状态
			..q:ICUPIIsActive="N"
			..q:(tIcupiComOrdDr="")&(tIcupiOeoreDr="")
			..q:(icupiSub<10000)&&($d(^DHCICUPara(locParaId,"I",icupiSub))<1)
			..s tIcupiId=tIcupId_"||"_icupiSub
			..s tIcupiCode=$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",13)
			..s tIcupiDesc=$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",14)
			..s tIcupiViewSuperCatDr=$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",2)
			..s tIcupiViewCatDr=$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",11)
			..;如果是模块项目从科室模板获取显示分类ID(用于医嘱项分类,从显示模板添加的项显示分类从常用医嘱获取)
			..s vCat=$g(TempRecordItem(tIcupiComOrdDr,"ViewCatDr"))
			..i ((vCat'="")&&(icupiSub>10000)) d
			...s tIcupiViewCatDr=vCat
			..;i "5931^5932^6351^6352^6353^6354"[tIcupiComOrdDr w tIcupiComOrdDr," ",vCat,!
			..s tIcupiSeqNo=$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",8)
			..;如果是模块项目从科室模板获取序号
			..s seqNo=$g(TempRecordItem(tIcupiComOrdDr,"SeqNo"))
			..i seqNo'="" s tIcupiSeqNo=seqNo
			..s tIcupiStartDate=$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",15)
			..s tIcupiEndDate=$p(^DHCICUPara(tIcupId,"I",icupiSub),"^",17)
			..;EndDate为0是删除项目
			..q:tIcupiEndDate=0
			..//q:(tIcupiStartDate'="")&(tIcupiStartDate>date)
			..//q:(tIcupiEndDate'="")&(tIcupiEndDate<date)
			..s tIcupiStartDate=$zd(tIcupiStartDate,3) //##class(web.DHCClinicCom).ConvertToDate(tIcupiStartDate)
			..s tIcupiStartTime=##class(web.DHCClinicCom).ConvertToTime($p(^DHCICUPara(tIcupId,"I",icupiSub),"^",16))
			..i tIcupiEndDate="" s tIcupiEndDate="9999-12-31"
			..e  s tIcupiEndDate=$zd(tIcupiEndDate,3) //##class(web.DHCClinicCom).ConvertToDate(tIcupiEndDate)
			..s tIcupiEndTime=##class(web.DHCClinicCom).ConvertToTime($p(^DHCICUPara(tIcupId,"I",icupiSub),"^",18))
			..s tIcupipiId=$p($g(^DHCICUPara(tIcupId,"I",icupiSub)),"^",19)
			..s tIcupidId="",tIcupidValue="",tIcucpCode="",tIcucpDesc="",tIcucpDefaultValue=""
			..s mainIcupiSub=$p(tIcupipiId,"||",2)
			..i mainIcupiSub="" s mainIcupiSub=icupiSub
			..e  d
			...;子项的显示分类与主项一至
			...s mViewCatDr=$p($g(^DHCICUPara(tIcupId,"I",mainIcupiSub)),"^",11)
			...i mViewCatDr'="" s tIcupiViewCatDr=mViewCatDr
			..s resList(mainIcupiSub,+tIcupiSeqNo,icupiSub_",0")=$lb(tIcupId,tIcupDesc,tIcupiId,tIcupiCode,tIcupiDesc,tIcupiViewSuperCatDr,tIcupiViewCatDr,tIcupiComOrdDr,tIcupiOeoreDr,tIcupiSeqNo,tIcupiStartDate,tIcupiStartTime,tIcupiEndDate,tIcupiEndTime,tIcupidId,tIcupidValue,tIcucpCode,tIcucpDesc,tIcucpDefaultValue,tIcupipiId)
			..//w mainIcupiSub_","_icupiSub
			..s icupidSub=0
			..f  s icupidSub=$o(^DHCICUPara(tIcupId,"I",icupiSub,"D",icupidSub)) q:icupidSub=""  d
				...s icucpId=$p(^DHCICUPara(tIcupId,"I",icupiSub,"D",icupidSub),"^",1)
				...q:icucpId=""
				...q:$ll($g(^DHCICUC("Property",icucpId)))<2
				...s tIcupidId=tIcupId_"||"_icupiSub_"||"_icupidSub
				...s tIcupidValue=$p(^DHCICUPara(tIcupId,"I",icupiSub,"D",icupidSub),"^",2)
				...s tIcucpCode="",tIcucpDesc=""
				...i icucpId'="" s tIcucpCode=$li(^DHCICUC("Property",icucpId),1)
				...i icucpId'="" s tIcucpDesc=$li(^DHCICUC("Property",icucpId),2)
				...s tIcucpDefaultValue=""
				...i $ld(^DHCICUC("Property",icucpId),3) s tIcucpDefaultValue=$li(^DHCICUC("Property",icucpId),3)
				...
				...s resList(mainIcupiSub,+tIcupiSeqNo,icupiSub_","_icupidSub)=$lb(tIcupId,tIcupDesc,tIcupiId,tIcupiCode,tIcupiDesc,tIcupiViewSuperCatDr,tIcupiViewCatDr,tIcupiComOrdDr,tIcupiOeoreDr,tIcupiSeqNo,tIcupiStartDate,tIcupiStartTime,tIcupiEndDate,tIcupiEndTime,tIcupidId,tIcupidValue,tIcucpCode,tIcucpDesc,tIcucpDefaultValue,tIcupipiId)
				...//w tIcupId,"/"_mainIcupiSub_","_icupiSub_","_icupidSub,!
		.s mainIcupiSub=""
		.f  s mainIcupiSub=$o(resList(mainIcupiSub)) q:mainIcupiSub=""  d
			..s tIcupiSeqNo=""
			..f  s tIcupiSeqNo=$o(resList(mainIcupiSub,tIcupiSeqNo)) q:tIcupiSeqNo=""  d
				...s icupiSub=""
				...f  s icupiSub=$o(resList(mainIcupiSub,tIcupiSeqNo,icupiSub)) q:icupiSub=""  d
					....s Data=resList(mainIcupiSub,tIcupiSeqNo,icupiSub)
					....d OutputRowPara
	;b
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRowPara
	//s Data=$lb(tIcupId,tIcupDesc,tIcupiId,tIcupiCode,tIcupiDesc,tIcupiViewSuperCatDr,tIcupiViewCatDr,tIcupiComOrdDr,tIcupiOeoreDr,tIcupiSeqNo,tIcupiStartDate,tIcupiStartTime,tIcupiEndDate,tIcupiEndTime,tIcupidId,tIcupidValue,tIcucpCode,tIcucpDesc,tIcucpDefaultValue,tIcupipiId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindIcuaParaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindIcuaParaExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindIcuaParaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindIcuaParaExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod UpdateICUParaItemReqNo(RowId3, reqNo) As %String
{
	q:RowId3="" "RowId不能为空!"	
    &sql(update SQLUSER.DHC_ICU_ParaItem set ICUPI_SeqNo=:reqNo where ICUPI_RowId=:RowId3)
	q SQLCODE
}

Query FindICUParaDept() As %Query(ROWSPEC = "TTemplateID,TDeptName") [ SqlProc ]
{
}

ClassMethod FindICUParaDeptExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 
  	s tCtlocId=""
 	f  s tCtlocId=$o(^DHCICUPara(0,"Ctloc",tCtlocId)) q:tCtlocId=""  d
	    .s tIcuParaId=$o(^DHCICUPara(0,"Ctloc",tCtlocId,""))
	    .q:'$d(^DHCICUPara(tIcuParaId))
	    .s ICUPCtlocDr=$p(^DHCICUPara(tIcuParaId),"^",2)
	    .q:ICUPCtlocDr=""
	    .s ICUPICUADr=$p(^DHCICUPara(tIcuParaId),"^",1)
	    .q:ICUPICUADr'=""
	    .s tDept=$p($g(^CTLOC(+ICUPCtlocDr)),"^",2)
	    .s tDept=$p($g(^CTLOC(+ICUPCtlocDr)),"^",2)
	    .s ICUPIBPFlag=$p(^DHCICUPara(tIcuParaId),"^",3)
	    .s ICUPANCSHDr=$p(^DHCICUPara(tIcuParaId),"^",4)
	    .s ICUPType=$p(^DHCICUPara(tIcuParaId),"^",5)
	    .s ICUPDesc=$p(^DHCICUPara(tIcuParaId),"^",6)
	    .d OutputRowDept
	s tCtlocId="-1",tDept="禁用"
	d OutputRowDept
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRowDept
	s Data=$lb(tCtlocId,tDept)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindICUParaDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUParaExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindICUParaDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUParaExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

// 用户操作修改项目名称

ClassMethod EditICUParaItem(arg) As %String
{
	s IcuParaItemId=$p(arg,"^",1)
	s itemName=$p(arg,"^",2)
	s userId=$p(arg,"^",3)
	
	q:itemName="" "项目名称不能为空"
	q:'##class(User.DHCICUParaItem).%ExistsId(IcuParaItemId) "码表指针无对应记录!"
	
	s paraItemObj=##class(User.DHCICUParaItem).%OpenId(IcuParaItemId)
	s oldDesc=paraItemObj.ICUPIDesc
	s paraItemObj.ICUPIDesc=itemName
	d paraItemObj.%Save()
	
	s date=$p($h,",",1)
	s time=$p($h,",",1)
	s icuParaId=$p(IcuParaItemId,"||",1)
	s icuaId=$p($g(^DHCICUPara(icuParaId)),"^",1)
	
	s ret=##class(web.DHCICUPara).Log("EditDisplayItem",icuaId,IcuParaItemId,oldDesc_"^"_itemName,userId)
	s ^tmpiculog(icuaId,IcuParaItemId,"E",date,time)=oldDesc_"^"_itemName_"^"_userId_"^"_ret
	q 0
}

// 用户操作删除项目(前台用)

ClassMethod DeleteICUParaItemByUser(arg) As %String
{
	s IcuParaItemId=$p(arg,"^",1)
	s userId=$p(arg,"^",2)
	q:IcuParaItemId="" "RowId不能为空!"
	q:'##class(User.DHCICUParaItem).%ExistsId(IcuParaItemId) "码表指针无对应记录!"
	s paraItemObj=##class(User.DHCICUParaItem).%OpenId(IcuParaItemId)
	s oldDesc=paraItemObj.ICUPIDesc
	s paraItemObj.ICUPIEndDate=0
	s paraItemObj.ICUPIIsActive="N"
	d paraItemObj.%Save()
	
	s date=$p($h,",",1)
	s time=$p($h,",",1)
	s icuParaId=$p(IcuParaItemId,"||",1)
	s icuaId=$p($g(^DHCICUPara(icuParaId)),"^",1)
	
	s ret=##class(web.DHCICUPara).Log("DeleteDisplayItem",icuaId,IcuParaItemId,oldDesc,userId)
	s ^tmpiculog(icuaId,IcuParaItemId,"D",date,time)=paraItemObj.ICUPIDesc_"^"_userId_"^"_ret
	
	q 0
}

// 记录项目(DisplayItem)日志

ClassMethod Log(type, icuaId, paraItemId, value, userId)
{
	// w ##class(web.DHCICUPara).Log(type,iucaId,paraItemId,value,userId)
	q:type="" "类型不能为空"
	q:icuaId="" "iucaId不能为空"
	q:paraItemId="" "paraItemId不能为空"
	q:userId="" "不能为空"
	
	s clclogId="",sub=""
	f  s sub=$O(^DHCCLC("Log",sub)) q:sub=""  d
	.s itemStr=$g(^DHCCLC("Log",sub))
	.s code=$lg(itemStr,1)
	.i code=type s clclogId=sub
	q:clclogId="" "类型有误"
	
	s logRecordId=icuaId
	s preValue=paraItemId
	s preAddNote=value
	s postValue=type
	s postAddNote=""
	
	s ret=##class(web.DHCCLLog).InsertCLLog(clclogId, logRecordId, preValue, preAddNote, postValue, postAddNote, userId)
	q ret
}

/// w ##class(web.DHCICUPara).CheckRepeat("PH1","PH1","1")
ClassMethod CheckRepeat(Desc, Code, tICUPIId, ICUPIViewCatDr, RowId3 = "")
{
	q:Desc="" "-1"
	q:Code="" "-2"
	s ret=1
	s IcuParaItemId=""
	i RowId3'="" s IcuParaItemId=$p(RowId3,"||",2)
	s tCtlocId=""
	f  s tCtlocId=$o(^DHCICUPara(0,"Ctloc",tCtlocId)) q:tCtlocId=""  d
	   .s tIcuParaId=$o(^DHCICUPara(0,"Ctloc",tCtlocId,""))
	   .q:(tICUPIId'="")&(tICUPIId'=tIcuParaId)
	   .q:'$d(^DHCICUPara(tIcuParaId))
	   .s tIcuParaItemId=0
	   .f  s tIcuParaItemId=$o(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId)) q:tIcuParaItemId=""  d
		   ..s tICUPIViewCatDr=$p($g(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId)),"^",11)
		   ..q:(ICUPIViewCatDr'="")&(ICUPIViewCatDr'=tICUPIViewCatDr)
		   ..s tICUPICode=$p($g(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId)),"^",13)
		   ..s tICUPIDesc=$p($g(^DHCICUPara(tIcuParaId,"I",tIcuParaItemId)),"^",14)
		   ..i Desc=tICUPIDesc d
		   ...i ((IcuParaItemId'="")&&(IcuParaItemId'=tIcuParaItemId)) s ret=0
		   ...i (IcuParaItemId="") s ret=0
		   ..q:ret=0
		   ..i (Code=tICUPICode) d
		   ...i ((IcuParaItemId'="")&&(IcuParaItemId'=tIcuParaItemId)) s ret=0
		   ...i (IcuParaItemId="") s ret=0
		   ..q:ret=0
	q ret
}

}
