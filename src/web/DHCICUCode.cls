Import SQLUSER

Class web.DHCICUCode Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

Query FindICUCSItem(ctlocId As %String) As %Query(ROWSPEC = "tIcucsiId,tIcucsiCode,tIcucsiDesc,tIcucsiTypeDesc,tAncoDesc,tAncvcDesc,tIcucsiActiveDesc,tCtlocDesc,tIcucsiType,tAncoId,tAncvcId,tIcucsiActive,tCtlocId") [ SqlProc ]
{
}

// D ##class(%ResultSet).RunQuery("web.DHCICUCode","FindICUCSItem","")

// 查找

ClassMethod FindICUCSItemExecute(ByRef qHandle As %Binary, ctlocId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s tIcucsiId=0
	f  s tIcucsiId=$o(^DHCICUC("SItem",tIcucsiId))  q:tIcucsiId=""  d
	.s tIcucsiCode=$p(^DHCICUC("SItem",tIcucsiId),"^",1) //tIcucsiCode:"代码"
	.s tIcucsiDesc =$p(^DHCICUC("SItem",tIcucsiId),"^",2)  //tIcucsiDesc:"名称"
    .s tIcucsiType =$p(^DHCICUC("SItem",tIcucsiId),"^",3) //类型
	.s tIcucsiTypeDesc=##class(web.DHCCLCom).GetComDescByCode("InputOutput", tIcucsiType)
	.S tAncoId=$p(^DHCICUC("SItem",tIcucsiId),"^",4)
	.S tAncoDesc=""
	.I tAncoId'=""  s tAncoDesc=$p($g(^DHCICUC("RecordItem",tAncoId)),"^",2)
	.s tAncvcId=$p(^DHCICUC("SItem",tIcucsiId),"^",5)
	.I tAncvcId'="" S tAncvcDesc=$p($g(^DHCICUC("ViewCat",tAncvcId)),"^",2)
	.e  s tAncvcDesc=""
	.//s t=$p(^DHCICUC("SItem",tIcucsiId),"^",6)	
	.//s tPDesc=""
	.//i t'="" s tPDesc=$p($g(^PHCIN(t)),"^",2)
	.s tIcucsiActive=$p(^DHCICUC("SItem",tIcucsiId),"^",6)
	.s tIcucsiActiveDesc=##class(web.DHCCLCom).GetComDescByCode("YesNo", tIcucsiActive)
	.s tCtlocId=$p(^DHCICUC("SItem",tIcucsiId),"^",7)
    .q:(ctlocId'="")&(ctlocId'=tCtlocId)
	.s tCtlocDesc=$p(^CTLOC(+tCtlocId),"^",2)
	.d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	//set Data=$lb(tIcucsiId,tIcucsiCode,tIcucsiDesc,tIcucsiTypeDesc,tIcucsiActiveDesc,tIcucsiActive) 
	set Data=$lb(tIcucsiId,tIcucsiCode,tIcucsiDesc,tIcucsiTypeDesc,tAncoDesc,tAncvcDesc,tIcucsiActiveDesc,tCtlocDesc,tIcucsiType,tAncoId,tAncvcId,tIcucsiActive,tCtlocId) 
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUCSItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUCSItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod FindICUCSItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUCSItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// 插入数据

// D ##class(web.DHCICUCode).InsertICUCSItem()

ClassMethod InsertICUCSItem(icucsiCode, icucsiDesc, icucsiType, ancoId, ancvcId, icucsiActive, ctlocId) As %String
{
	//在上面的方法中赋值，再执行语句。
	q:icucsiCode="" "代码不能为空!"
	q:icucsiDesc="" "描述不能为空!"
	//q:ancvcId="" "显示分类不能为空!"
	//q:icucsiType="" "出入量类型不能为空!"
	s icucsiId=0,retStr=0
	f  s icucsiId=$o(^DHCICUC("SItem",icucsiId)) q:(icucsiId="")!(retStr'=0)  d
	    .i icucsiCode=$p(^(icucsiId),"^",1),ctlocId=$p(^(icucsiId),"^",7) s retStr="代码相同!"
	q:retStr'=0 retStr
	i icucsiActive="1" s icucsiActive="Y"
	i icucsiActive="0" s icucsiActive="N"
	
	//s ^tmpYpz("insSItem")=icucsiCode_"/"_icucsiDesc_"/"_icucsiType_"/"_ancoId_"/"_ancvcId_"/"_icucsiActive_"/"_ctlocId
	TSTART
	k PLIST
	s PLIST(2)=icucsiCode
	s PLIST(3)=icucsiDesc
	s PLIST(4)=icucsiType
	s PLIST(5)=ancoId
	s PLIST(6)=ancvcId	
	s PLIST(7)=icucsiActive
	s PLIST(8)=ctlocId
	
	&SQL(insert into DHC_ICUC_ShiftItem Values :PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

// 更新数据

// D ##class(web.DHCICUCode).UpdateICUCSItem()

ClassMethod UpdateICUCSItem(icucsiId, icucsiCode, icucsiDesc, icucsiType, ancoId, ancvcId, icucsiActive, ctlocId) As %String
{
  
 	q:icucsiId="" "记录Id为空!"
 	q:icucsiCode="" "代码不能为空!"
	q:icucsiDesc="" "描述不能为空!"
	//q:ancvcId="" "显示分类不能为空!"
	//q:icucsiType="" "出入量类型不能为空!"
	i icucsiActive="1" s icucsiActive="Y"
	i icucsiActive="0" s icucsiActive="N"
	
	s tmpIcucsiId=0,retStr=0
	f  s tmpIcucsiId=$o(^DHCICUC("SItem",tmpIcucsiId)) q:(tmpIcucsiId="")!(retStr'=0)  d
	    .q:icucsiId=tmpIcucsiId
	    .i icucsiCode=$p(^(tmpIcucsiId),"^",1),ctlocId=$p(^(tmpIcucsiId),"^",7) s retStr="代码相同!"
	q:retStr'=0 retStr

	i (icucsiId'="")&&(icucsiCode'="")&&(icucsiDesc'="") d
	.k PLIST
	.s PLIST(2)=icucsiCode
	.s PLIST(3)=icucsiDesc
	.s PLIST(4)=icucsiType
	.s PLIST(5)=ancoId
	.s PLIST(6)=ancvcId
	.//s PLIST(7)=phcinId
	.s PLIST(7)=icucsiActive
	.s PLIST(8)=ctlocId
	.w ctlocId,!
	.&SQL(update DHC_ICUC_ShiftItem Values :PLIST() where ICUCSI_RowId=:icucsiId)
	.s retStr=SQLCODE
	Q retStr
}

// 删除数据

// D ##class(web.DHCICUCode）.DeleteICUCSItem()

ClassMethod DeleteICUCSItem(icucsiId As %String) As %String
{
	q:icucsiId="" "输入Id错!"
	&SQL(delete from  DHC_ICUC_ShiftItem  where ICUCSI_RowId=:icucsiId)
	Q SQLCODE
}

// 保存常用医嘱关联用药途径数据

/// 编写者：wulingling
/// 日期：2012年8月31日
/// 功能：常用药品医嘱关联用药途径维护
/// d ##class(web.DHCICUCode).SaveOrdPhcinData("5054","11^12")
ClassMethod SaveOrdPhcinData(ancorowid, phcinrowid)
{
	q:ancorowid="" "常用医嘱ID不能为空"
	s ancoId=ancorowid
	s dupiPhcinId=0
	s len=$l(phcinrowid,"^")
	s retStr=0
	for i=1:1:len d
		.q:retStr'=0
		.s phcinId=$p(phcinrowid,"^",i)
		.q:phcinId=""
		.s phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)
		.;保存或修改时任一用药途径id不能与不关联常用医嘱的用药途径id重复
		.i ("^"_$g(^DHCCLSet("ICU","Oeore","ExcludedInstruct"))_"^")[("^"_phcinId_"^")  s retStr=phcinDesc_" 与不关联常用医嘱用药途径重复!" q
		.q:retStr'=0
		.s ancoId=""
	    .f  s ancoId=$o(^DHCCLSet("ICU","Oeore","Instruct",ancoId)) q:(ancoId="")!(retStr'=0)  d
    		..q:ancoId=ancorowid
    		..i ("^"_^DHCCLSet("ICU","Oeore","Instruct",ancoId)_"^")[("^"_phcinId_"^")  s retStr=phcinDesc_" 与常用医嘱Id为"_ancoId_"中的用药途径重复!" q
    q:retStr'=0 retStr
	s ^DHCCLSet("ICU","Oeore","Instruct",ancorowid)=phcinrowid
	q retStr
}

// 保存默认常用医嘱

ClassMethod SaveDefaultOrdData(defaultId)
{
	s ^DHCCLSet("ICU","Oeore","DefaultDrugComOrd")=defaultId
	q 0
}

// 删除常用医嘱关联用药途径数据

ClassMethod DelOrdPhcinData(ancorowid)
{
	q:ancorowid="" "常用医嘱ID不能为空"
	s ancoId=ancorowid
	k ^DHCCLSet("ICU","Oeore","Instruct",ancoId)
	q "0"
}

// 根据常用医嘱ID或用药途径ID查找数据

Query FindOrdPhcin(dancoRowid, dphcin) As %Query(ROWSPEC = "dancoRowid:%String,dancoDesc:%String,dphcinRowid:%String,dphcinDesc:%String") [ SqlProc ]
{
}

ClassMethod FindOrdPhcinExecute(ByRef qHandle As %Binary, dancoRowid, dphcin) As %Status
{
    ;Set ^TMPCCQ("Order")=dphcin
    Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
    s phcinRowid=""
    if ($g(dphcin)'="")  d
    .s ancoRowid=0
    .f  s ancoRowid=$o(^DHCCLSet("ICU","Oeore","Instruct",ancoRowid))  q:ancoRowid=""  d
    ..s phcinRowid=^DHCCLSet("ICU","Oeore","Instruct",ancoRowid)
    ..q:("^"_phcinRowid_"^")'[("^"_dphcin_"^")
    ..s dancoDesc=$p($g(^DHCICUC("RecordItem",ancoRowid)),"^",2)
    ..;s dphcinRowid=$p(^DHCCLSet("ICU","Oeore","Instruct",ancorowid),"^",2)
    ..s dphcinDesc=""
    ..f i=1:1:$l(phcinRowid,"^") d
    ...s phcinid=$p(phcinRowid,"^",i)
    ...q:+phcinid=0
    ...i dphcinDesc'="" s dphcinDesc=dphcinDesc_";"
    ...s dphcinDesc=dphcinDesc_$p($g(^PHCIN(phcinid)),"^",2)
    ..d OutputRowOrd
    
    else  if ($g(dancoRowid)'="")  d
    .s ancoRowid=dancoRowid
    .s dancoDesc=$p($g(^DHCICUC("RecordItem",ancoRowid)),"^",2)
    .s phcinRowid=^DHCCLSet("ICU","Oeore","Instruct",ancoRowid)
    .s dphcinDesc=""
    .f i=1:1:$l(phcinRowid,"^") d
    ..s phcinid=$p(phcinRowid,"^",i)
    ..q:+phcinid=0
    ..i dphcinDesc'="" s dphcinDesc=dphcinDesc_";"
    ..s dphcinDesc=dphcinDesc_$p($g(^PHCIN(phcinid)),"^",2)
    .d OutputRowOrd
    
    else  d
    .s ancoRowid=0
    .f  s ancoRowid=$o(^DHCCLSet("ICU","Oeore","Instruct",ancoRowid)) q:ancoRowid=""  d
    ..s dancoDesc=$p($g(^DHCICUC("RecordItem",ancoRowid)),"^",2)
    ..s phcinRowid=^DHCCLSet("ICU","Oeore","Instruct",ancoRowid)
    ..s dphcinDesc=""
    ..f i=1:1:$l(phcinRowid,"^") d
    ...s phcinid=$p(phcinRowid,"^",i)
    ...q:+phcinid=0
    ...i dphcinDesc'="" s dphcinDesc=dphcinDesc_";"
    ...s dphcinDesc=dphcinDesc_$p($g(^PHCIN(phcinid)),"^",2)
    ..d OutputRowOrd

   
	Quit $$$OK
OutputRowOrd
	set Data=$lb(ancoRowid,dancoDesc,phcinRowid,dphcinDesc)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
}

ClassMethod FindOrdPhcinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdPhcinExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOrdPhcinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

// 获取常用药品医嘱值

Query GetDrugOrd(ancoDesc) As %Query(ROWSPEC = "ancoDesc:%String,ancoRowid:%Integer") [ SqlProc ]
{
}

ClassMethod GetDrugOrdExecute(ByRef qHandle As %Binary, ancoDesc) As %Status
{
  
    Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
    
	s ancotype="D"
	s ancocode=""
	f  s ancocode=$o(^DHCICUC("RecordItem",0,"Code",ancocode)) q:ancocode=""  d
	.s ancorowid=0
	.f  s ancorowid=$o(^DHCICUC("RecordItem",0,"Code",ancocode,ancorowid)) q:ancorowid=""  d
	..q:'$d(^DHCICUC("RecordItem",ancorowid))
	..q:$p(^DHCICUC("RecordItem",ancorowid),"^",10)'="Y"
	..q:$p(^DHCICUC("RecordItem",ancorowid),"^",23)'=""
	..s dancoDesc=$p(^DHCICUC("RecordItem",ancorowid),"^",2)
	..q:dancoDesc'[ancoDesc
    ..s ancoRowID=ancorowid
    ..s tancoDesc=dancoDesc
    ..;s ancoDesc=$p(^DHCICUC("RecordItem",ancorowid),"^",2)
    ..d OutputRowOrd
    

	Quit $$$OK
OutputRowOrd
	set Data=$lb(tancoDesc,ancoRowID)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
}

ClassMethod GetDrugOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDrugOrdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDrugOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/*Query GetDrugOrdDefault(defaultOrd) As %SQLQuery(CONTAINID = 1, ROWSPEC = "defaultOrd:%String,defaultOrdId:%Integer")
{
	select ANCO_Desc,ANCO_RowId from DHC_ANC_CommonOrd where ANCO_Type="D" and ANCO_Desc like nvl(:defaultOrd,'')||'%'
}*/

// 获取默认常用医嘱值

/// d ##class(%ResultSet).RunQuery("web.DHCICUCode","GetDrugOrdDefault","")
Query GetDrugOrdDefault(defaultOrd) As %Query(ROWSPEC = "defaultOrd:%String,defaultOrdId:%Integer") [ SqlProc ]
{
}

ClassMethod GetDrugOrdDefaultExecute(ByRef qHandle As %Binary, defaultOrd) As %Status
{
  
    Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	
    //s tancoDesc=" "
	//s ancoRowID=" "
	//d OutputRowOrd
	
	s ancotype="D"
	s ancocode=""
	f  s ancocode=$o(^DHCICUC("RecordItem",0,"Code",ancocode)) q:ancocode=""  d
	.s defaultOrdId=0
	.f  s defaultOrdId=$o(^DHCICUC("RecordItem",0,"Code",ancocode,defaultOrdId)) q:defaultOrdId=""  d
	..q:'$d(^DHCICUC("RecordItem",defaultOrdId))
	..q:$p(^DHCICUC("RecordItem",defaultOrdId),"^",10)'="Y"
	..q:$p(^DHCICUC("RecordItem",defaultOrdId),"^",23)'=""
	..s dancoDesc=$p(^DHCICUC("RecordItem",defaultOrdId),"^",2)
			..q:(dancoDesc'[defaultOrd)&(defaultOrd'="")
    ..s ancoRowID=defaultOrdId
    ..s tancoDesc=dancoDesc
    ..d OutputRowOrd
    

	Quit $$$OK
OutputRowOrd
	set Data=$lb(tancoDesc,ancoRowID)
 	Set ^CacheTemp(repid,index)=Data
 	Set index=index+1
	quit
}

ClassMethod GetDrugOrdDefaultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDrugOrdDefaultExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDrugOrdDefaultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDrugOrdDefaultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetOrdDefault() As %String
{
	s defaultOrdId=$g(^DHCCLSet("ICU","Oeore","DefaultDrugComOrd"))
	s defaultOrd=$p($g(^DHCICUC("RecordItem",+defaultOrdId)),"^",2)
	q defaultOrd
}

// 获取用药途径

Query GetPhcinDesc() As %Query(ROWSPEC = "phcinrowid:%Integer,phcinDesc:%String") [ SqlProc ]
{
}

ClassMethod GetPhcinDescExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
 	
 	s phcinrowid=0
 	f  s phcinrowid=$o(^PHCIN(phcinrowid)) q:phcinrowid=""  d
 	.s phcinDesc=$p(^PHCIN(phcinrowid),"^",2)
 	.d OutRow1

    s qHandle=$lb(0,repid,0)
    q $$$OK
OutRow1
	s Data=$lb(phcinrowid,phcinDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetPhcinDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPhcinDescExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetPhcinDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPhcinDescExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

// SQL取用药途径

Query GetPhcin() As %SQLQuery(CONTAINID = 1, ROWSPEC = "phcin_rowid:%Integer,phcin_Desc1:%String")
{
	select Phcin_rowId,Phcin_desc1 from PHC_Instruc
}

/*ClassMethod SaveUnusePhcin(PHCINIdStr As %String)
{
	s ^DHCCLSet("ICU","Oeore","ExcludedInstruct")=PHCINIdStr
	q 0
}*/

// 保存不关联常用医嘱的用药途径到^DHCCLSet("ICU","Oeore","ExcludedInstruct")节点下

ClassMethod SaveUnusePhcin(PHCINIdStr As %String)
{
	s len=$l(PHCINIdStr,"^")
	s retStr=0
	for i=1:1:len d
		.q:retStr'=0
		.s phcinId=$p(PHCINIdStr,"^",i)
		.q:phcinId=""
		.s phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)
		.;保存或修改时任一用药途径id不能与不关联常用医嘱的用药途径id重复
		.s ancoId=""
	    .f  s ancoId=$o(^DHCCLSet("ICU","Oeore","Instruct",ancoId)) q:(ancoId="")!(retStr'=0)  d
    		..i ("^"_^DHCCLSet("ICU","Oeore","Instruct",ancoId)_"^")[("^"_phcinId_"^")  d
    			...s retStr=phcinDesc_" 与常用医嘱Id为"_ancoId_"中的用药途径重复!" q
	q:retStr'=0 retStr
	s ^DHCCLSet("ICU","Oeore","ExcludedInstruct")=PHCINIdStr
	i PHCINIdStr="" k ^DHCCLSet("ICU","Oeore","ExcludedInstruct")	;20160831+dyl
	q 0
}

// 取不关联常用医嘱的用药途径

Query FindUnusePhcin() As %Query(ROWSPEC = "unusephcinid,unusephcindesc") [ SqlProc ]
{
}

ClassMethod FindUnusePhcinExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	s ind=1
 	;20160831+dyl
 	i $d(^DHCCLSet("ICU","Oeore","ExcludedInstruct"))<1 s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
 	s UnusePhcinNum=$l($g(^DHCCLSet("ICU","Oeore","ExcludedInstruct")),"^")
 	f I=1:1:UnusePhcinNum d
	 	.s UnusePhcinId=$p($g(^DHCCLSet("ICU","Oeore","ExcludedInstruct")),"^",I)
	 	.i UnusePhcinId'="" s UnusePhcinDesc=$p($g(^PHCIN(UnusePhcinId)),"^",2)
	 	.e  s UnusePhcinDesc=""
	 	.d OutRow3
    s qHandle=$lb(0,repid,0)
    q $$$OK
OutRow3
	s Data=$lb(UnusePhcinId,UnusePhcinDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindUnusePhcinFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindUnusePhcinExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindUnusePhcinClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindUnusePhcinExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod InsertOrdMapping(ViewSuperCat As %String, ViewCat As %String, arcim As %String, speedUnit As %String, anco As %String, oeoriNote As %String, uom As %String, density As %String, qty As %String, prepareVolume As %String, abbreviate As %String, defSpeed As %String)
{
    s QCode=1    
    i ViewSuperCat="" q QCode
    i (ViewCat="")&&(arcim="")&&(oeoriNote="") s ^DHCICUC("OrdMapping",ViewSuperCat)=anco
    i (ViewCat'="")&&(arcim="")&&(oeoriNote="") s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)=anco
    i (ViewCat'="")&&(arcim'="")&&(oeoriNote="") s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)=anco_"^"_speedUnit_"^"_uom_"^"_density_"^"_qty_"^"_prepareVolume_"^"_abbreviate_"^"_defSpeed
	i (ViewCat'="")&&(arcim'="")&&(oeoriNote'="") s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,oeoriNote)=anco_"^"_speedUnit_"^"_uom_"^"_density_"^"_qty_"^"_prepareVolume_"^"_abbreviate_"^"_defSpeed
	s QCode=0
	q QCode
}

ClassMethod UpdateOrdMapping(ViewSuperCat As %String, ViewCat As %String, arcim As %String, speedUnit As %String, anco As %String, oeoriNote As %String, uom As %String, density As %String, qty As %String, prepareVolume As %String, abbreviate As %String, defSpeed As %String)
{
    s QCode=1
    i ViewSuperCat="" q QCode
    i (ViewCat="")&&(arcim="")&&(oeoriNote="") s ^DHCICUC("OrdMapping",ViewSuperCat)=anco
    i (ViewCat'="")&&(arcim="")&&(oeoriNote="") s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)=anco
    i (ViewCat'="")&&(arcim'="")&&(oeoriNote="") s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)=anco_"^"_speedUnit_"^"_uom_"^"_density_"^"_qty_"^"_prepareVolume_"^"_abbreviate_"^"_defSpeed
	i (ViewCat'="")&&(arcim'="")&&(oeoriNote'="") s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,oeoriNote)=anco_"^"_speedUnit_"^"_uom_"^"_density_"^"_qty_"^"_prepareVolume_"^"_abbreviate_"^"_defSpeed
	s QCode=0
	q QCode
}

ClassMethod DeleteOrdMapping(ViewSuperCat As %String, ViewCat As %String, arcim As %String, oeoriNote As %String)
{
    s QCode=1
    i ViewSuperCat="" q QCode
    i (ViewCat="")&&(arcim="")&&(oeoriNote="") s ^DHCICUC("OrdMapping",ViewSuperCat)=""
    i (ViewCat'="")&&(arcim="")&&(oeoriNote="") s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)=""
    i (ViewCat'="")&&(arcim'="")&&(oeoriNote="") s ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)=""
	i (ViewCat'="")&&(arcim'="")&&(oeoriNote'="") k ^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,oeoriNote)
	s QCode=0
	q QCode
}

Query FindViewSuperCat(ViewSuperCat As %String) As %Query(ROWSPEC = "ORCatDesc:%String,RowId:%String") [ SqlProc ]
{
}

ClassMethod FindViewSuperCatExecute(ByRef qHandle As %Binary, ViewSuperCat As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^OEC("ORCAT",RowId))  q:RowId=""  d
	.s ORCatID=$p(^OEC("ORCAT",RowId),"^",1)	
	.s ORCatDesc=$p(^OEC("ORCAT",RowId),"^",2)
	.i (ViewSuperCat'="")&&((ViewSuperCat=RowId)||(ORCatDesc[ViewSuperCat)) d OutputRow6
	.i (ViewSuperCat="") d OutputRow6
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(ORCatDesc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindViewSuperCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindViewSuperCatExecute ]
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

ClassMethod FindViewSuperCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindViewSuperCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCICUCode","FindICUOrdMap","1","","","")	

/// Creator：      	MFC
/// CreatDate：    	2012-12-11
/// Description： 	
/// Table：        	
/// Input：        	ViewSuperCatID医嘱大类，ViewCatID医嘱分类
/// Output：       
/// Return：    
Query FindICUOrdMap(ViewSuperCatID As %String, ViewCatID As %String, arcimID As %String, oeoriNote As %String) As %Query(ROWSPEC = "tAncoId:%String,tAncoDesc:%String,tSpeedUnitId:%String,tSpeedUnitDesc:%String,tUomId:%String,tUomDesc:%String,tDensity:%String,tQty:%String,tPrepareVolume:%String,tAbbreviate:%String,tDefSpeed:%String,tViewSuperCatIDT:%String,tViewSuperCatDescT:%String,tViewCatIDT:%String,tViewCatDescT:%String,tArcimIDT:%String,tArcimDescT:%String ,tOeoriNoteT:%String,tDeptId:%String,tDeptDesc:%String") [ SqlProc ]
{
}

ClassMethod FindICUOrdMapExecute(ByRef qHandle As %Binary, ViewSuperCatID As %String, ViewCatID As %String, arcimID As %String, oeoriNote As %String) As %Status
{
	B	;IN
	Set repid=$I(^CacheTemp)
	i $g(ind)="" Set ind=1
	s ViewSuperCat="" ,ViewCat="",arcim="",Desc=""
	s tancoId="",tancoDesc="",tspeedUnitId="",tspeedUnitDesc="",tuomId="",tuomtDesc="",tdensity="",tqty="",tprepareVolume="",tabbreviate="",tdefSpeed=""
	s tViewSuperCatIDT="",tViewSuperCatDescT="",tViewCatIDT="",tViewCatDescT="",arcimIDT="",tarcimDescT="",toeoriNoteT="",speedUnit="",uom=""
	
	//b ;"1"
    s tarcimID1="",tarcimID2=""
    s ViewSuperCat="" f  s ViewSuperCat=$O(^DHCICUC("OrdMapping",ViewSuperCat)) q:(ViewSuperCat="")  d
	    .q:(ViewSuperCatID'="")&&(ViewSuperCat'=ViewSuperCatID)	;20160809
	    .b	; ViewSuperCat_"/"_1_":"_20160809_":",!
	    .s tancoId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat)),"^",1)
	    .q:(tancoId="")
	    .s tancoDesc=$p($g(^DHCICUC("RecordItem",tancoId)),"^",2)
	    .s tViewSuperCatIDT=ViewSuperCat
		.s tViewSuperCatDescT=$p($g(^OEC("ORCAT",ViewSuperCat)),"^",2)	
		.s tDeptId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat)),"^",9)
		
		.s tspeedUnitId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat)),"^",2)
		.s tuomId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat)),"^",3)
		.s tdensity=$p($g(^DHCICUC("OrdMapping",ViewSuperCat)),"^",4)
		.s tqty=$p($g(^DHCICUC("OrdMapping",ViewSuperCat)),"^",5)
		.s tprepareVolume=$p($g(^DHCICUC("OrdMapping",ViewSuperCat)),"^",6)
		.s tabbreviate=$p($g(^DHCICUC("OrdMapping",ViewSuperCat)),"^",7)
		.s tdefSpeed=$p($g(^DHCICUC("OrdMapping",ViewSuperCat)),"^",8)
		
		.d Output1
	s ViewSuperCat="" f  s ViewSuperCat=$O(^DHCICUC("OrdMapping",ViewSuperCat)) q:(ViewSuperCat="")  d	
		.q:(ViewSuperCatID'="")&&(ViewSuperCat'=ViewSuperCatID)	;20160809
		.b	; ViewSuperCat_"/"_2_":",!
		.s ViewCat="" f  s ViewCat=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)) q:(ViewCat="")  d
		    ..q:(ViewCatID'="")&&(ViewCat'=ViewCatID)	;20160809
		    ..s tancoId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)),"^",1)
		    ..q:(tancoId="")
		    ..s tancoDesc=$p($g(^DHCICUC("RecordItem",tancoId)),"^",2)
		    ..s tViewSuperCatIDT=ViewSuperCat
			..s tViewSuperCatDescT=$p($g(^OEC("ORCAT",ViewSuperCat)),"^",2)
			..s tViewCatIDT=ViewCat
			..s tViewCatDescT=$p($g(^ARC("IC",ViewCat)),"^",2)
			..s tspeedUnitId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat)),"^",2)
			..s tuomId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat)),"^",3)
			..s tdensity=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)),"^",4)
			..s tqty=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)),"^",5)
			..s tprepareVolume=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)),"^",6)
			..s tabbreviate=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)),"^",7)
			..s tdefSpeed=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)),"^",8)
			..s tDeptId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)),"^",9)
			..d Output5
	s ViewSuperCat="" f  s ViewSuperCat=$O(^DHCICUC("OrdMapping",ViewSuperCat)) q:(ViewSuperCat="")  d
		.q:(ViewSuperCatID'="")&&(ViewSuperCat'=ViewSuperCatID)	;20160809
		.b	; ViewSuperCat_"/"_3_":",!
		.s ViewCat="" f  s ViewCat=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)) q:(ViewCat="")  d
			..q:(ViewCatID'="")&&(ViewCat'=ViewCatID)	;20160809
			..f  s arcim=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)) q:(arcim="")  d	
				...q:(arcimID'="")&&(arcim'=arcimID)	;20160809
				...s tancoId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",1)
				...q:(tancoId="")
				...s tancoDesc=$p($g(^DHCICUC("RecordItem",tancoId)),"^",2)
				...s tspeedUnitId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",2)
				...s speedUnit=""
				...;q:(tspeedUnitId="")
				...&SQL(select ICUCSU_Desc into :speedUnit from SQLUSER.DHC_ICUC_SpeedUnit where ICUCSU_RowId=:tspeedUnitId)
				...i (speedUnit'="") d
					....s tspeedUnitDesc=speedUnit
				...s tuomId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",3)
				...s uom=""
				...;q:(tuomId="")
				...&SQL(select CTUOM_Desc into :uom from SQLUSER.ct_uom where CTUOM_RowId=:tuomId)
				...i (uom'="") d
					....s tuomtDesc=uom
				...s tdensity=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",4)
				...s tqty=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",5)
				...s tprepareVolume=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",6)
				...s tabbreviate=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",7)
				...s tdefSpeed=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",8)
				...s tViewSuperCatIDT=ViewSuperCat
				...s tViewSuperCatDescT=$p($g(^OEC("ORCAT",ViewSuperCat)),"^",2)
				...s tViewCatIDT=ViewCat
				...s tViewCatDescT=$p($g(^ARC("IC",ViewCat)),"^",2)
				...s tarcimIDT=arcim
				...s tarcimID1=$p($g(tarcimIDT),"||",1)
				...s tarcimID2=$p($g(tarcimIDT),"||",2)	
				...i (tarcimID1'="")&&(tarcimID2'="") d
					....s tarcimDescT=$p($g(^ARCIM(tarcimID1,tarcimID2,1)),"^",2)
				...s tDeptId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)),"^",9)	
				...d Output7
    s ViewSuperCat="",ViewCat=""
	f  s ViewSuperCat=$O(^DHCICUC("OrdMapping",ViewSuperCat)) q:(ViewSuperCat="")  d	
		.q:(ViewSuperCatID'="")&&(ViewSuperCat'=ViewSuperCatID)	;20160809
		.b	;w ViewSuperCat_"/"_1_":",!
		.f  s ViewCat=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat)) q:(ViewCat="")  d	
			..;s ^tempmfc("2012")=ViewCat
			..q:(ViewCatID'="")&&(ViewCat'=ViewCatID)	;20160809
			..f  s arcim=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim)) q:(arcim="")  d
				...q:(arcimID'="")&&(arcim'=arcimID)	
				...f  s Desc=$O(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)) q:(Desc="")  d
					....q:(oeoriNote'="")&&(Desc'=oeoriNote)
					....s tancoId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",1)
					....s tancoDesc=$p($g(^DHCICUC("RecordItem",tancoId)),"^",2)
					....s tspeedUnitId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",2)
					....s speedUnit=""
					....&SQL(select ICUCSU_Desc into :speedUnit from SQLUSER.DHC_ICUC_SpeedUnit where ICUCSU_RowId=:tspeedUnitId)
					....i (speedUnit'="") d
						.....s tspeedUnitDesc=speedUnit
					....s tuomId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",3)
					....s uom=""
					....&SQL(select CTUOM_Desc into :uom from SQLUSER.ct_uom where CTUOM_RowId=:tuomId)
					....i (uom'="") d
						.....s tuomtDesc=uom
					....s tdensity=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",4)
					....s tqty=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",5)
					....s tprepareVolume=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",6)
					....s tabbreviate=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",7)
					....s tdefSpeed=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",8)
					....s tViewSuperCatIDT=ViewSuperCat
					....s tViewSuperCatDescT=$p($g(^OEC("ORCAT",ViewSuperCat)),"^",2)
					....s tViewCatIDT=ViewCat
					....s tViewCatDescT=$p($g(^ARC("IC",ViewCat)),"^",2)
					....s tarcimIDT=arcim
					....s tarcimID1=$p($g(tarcimIDT),"||",1)
					....s tarcimID2=$p($g(tarcimIDT),"||",2)
					....;s ^tempmfc("2011")=tarcimID1_"^"_tarcimID2
					....i (tarcimID1'="")&&(tarcimID2'="") d
						.....s tarcimDescT=$p($g(^ARCIM(tarcimID1,tarcimID2,1)),"^",2)
					....s toeoriNoteT=Desc
					....s tDeptId=$p($g(^DHCICUC("OrdMapping",ViewSuperCat,ViewCat,arcim,Desc)),"^",9)	
					....d Output
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	i toeoriNoteT["CaGlu" b
	s tDeptDesc=$$GetDeptStr(tDeptId)
	set Data=$lb(tancoId,tancoDesc,tspeedUnitId,tspeedUnitDesc,tuomId,tuomtDesc,tdensity,tqty,tprepareVolume,tabbreviate,tdefSpeed,tViewSuperCatIDT,tViewSuperCatDescT,tViewCatIDT,tViewCatDescT,tarcimIDT,tarcimDescT,toeoriNoteT,tDeptId,tDeptDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
Output1
	s tDeptDesc=$$GetDeptStr(tDeptId)
	set Data=$lb(tancoId,tancoDesc,tspeedUnitId,tspeedUnitDesc,tuomId,tuomtDesc,tdensity,tqty,tprepareVolume,tabbreviate,tdefSpeed,tViewSuperCatIDT,tViewSuperCatDescT,tViewCatIDT,tViewCatDescT,tarcimIDT,tarcimDescT,toeoriNoteT,tDeptId,tDeptDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
Output5
	s tDeptDesc=$$GetDeptStr(tDeptId)
	set Data=$lb(tancoId,tancoDesc,tspeedUnitId,tspeedUnitDesc,tuomId,tuomtDesc,tdensity,tqty,tprepareVolume,tabbreviate,tdefSpeed,tViewSuperCatIDT,tViewSuperCatDescT,tViewCatIDT,tViewCatDescT,tarcimIDT,tarcimDescT,toeoriNoteT,tDeptId,tDeptDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
Output7
	s tDeptDesc=$$GetDeptStr(tDeptId)
	set Data=$lb(tancoId,tancoDesc,tspeedUnitId,tspeedUnitDesc,tuomId,tuomtDesc,tdensity,tqty,tprepareVolume,tabbreviate,tdefSpeed,tViewSuperCatIDT,tViewSuperCatDescT,tViewCatIDT,tViewCatDescT,tarcimIDT,tarcimDescT,toeoriNoteT,tDeptId,tDeptDesc)
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
GetDeptStr(deptIds)
 	s count=$L(deptIds,";")
 	s deptDescStr=""
 	f i=1:1:count  d
	 	.s deptId=$p(deptIds,";",i)
	 	.s deptDesc=$p($g(^CTLOC(+deptId)),"^",2)
	 	.q:deptDesc=""
	 	.s deptDescStr=deptDescStr_deptDesc_";"
	q deptDescStr
}

ClassMethod FindICUOrdMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUOrdMapExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindICUOrdMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUOrdMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindViewCat(ViewCat As %String, ViewSuperCat As %String) As %Query(ROWSPEC = "ARCICatDesc:%String,RowId:%String") [ SqlProc ]
{
}

ClassMethod FindViewCatExecute(ByRef qHandle As %Binary, ViewCat As %String, ViewSuperCat As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s RowId=0
	f  s RowId=$o(^ARC("IC",RowId))  q:RowId=""  d
	.s ARCICatID=$p(^ARC("IC",RowId),"^",1)
	.s ARCICatDesc=$p(^ARC("IC",RowId),"^",2)
	.s ARCViewSuperCatID=$p(^ARC("IC",RowId),"^",8)
	.i (ViewCat'="")&&((ViewCat=RowId)||(ARCICatDesc[ViewCat))&&(ViewSuperCat'="")&&(ViewSuperCat=ARCViewSuperCatID) d OutputRow2
	.i (ViewCat'="")&&((ViewCat=RowId)||(ARCICatDesc[ViewCat))&&(ViewSuperCat="") d OutputRow2
	.i (ViewCat="")&&(ViewSuperCat'="")&&(ViewSuperCat=ARCViewSuperCatID) d OutputRow2
	.i (ViewCat="")&&(ViewSuperCat="") d OutputRow2	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(ARCICatDesc,RowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindViewCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindViewCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindViewCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindViewCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCICUCode","FindOrcItmMast","","")

Query FindOrcItmMast(OrcItmMast As %String, ViewCat As %String) As %Query(ROWSPEC = "ARCIMastDesc:%String,ARCIMastRowID:%String") [ SqlProc ]
{
}

ClassMethod FindOrcItmMastExecute(ByRef qHandle As %Binary, OrcItmMast As %String, ViewCat As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ARCIMastRowID=""
	s RowId=0,subID=0
	f  s RowId=$o(^ARCIM(RowId)) q:RowId=""  d
	.f  s subID=$o(^ARCIM(RowId,subID)) q:subID=""  d
	  ..s ARCIMastDesc=$p($g(^ARCIM(RowId,subID,1)),"^",2)
	  ..s ARCViewCatID=$p($g(^ARCIM(RowId,subID,1)),"^",10)	  
	  ..s ARCIMastRowID=RowId_"||"_subID
	  ..;i (OrcItmMast'="")&&((OrcItmMast=ARCIMastRowID)||(ARCIMastDesc[OrcItmMast))&&(ViewCat'="")&&(ViewCat=ARCViewCatID) d OutputRow3
	  ..;i (OrcItmMast'="")&&((OrcItmMast=ARCIMastRowID)||(ARCIMastDesc[OrcItmMast))&&(ViewCat'="") d OutputRow3
	  ..;i (OrcItmMast="")&&(ViewCat'="")&&(ViewCat=ARCViewCatID) d OutputRow3
	  ..;i (OrcItmMast="")&&(ViewCat="") d OutputRow3
	  ..i ViewCat="" i ((ARCIMastDesc[OrcItmMast)) d OutputRow3
	  ..e  i ((ARCIMastDesc[OrcItmMast)&&(ViewCat=ARCViewCatID)) d OutputRow3
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(ARCIMastDesc,ARCIMastRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindOrcItmMastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrcItmMastExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOrcItmMastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrcItmMastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query FindCommonOrd(CommonOrd As %String, ViewCat As %String) As %Query(ROWSPEC = "ComOrdRowDesc:%String,rowid:%String") [ SqlProc ]
{
}

ClassMethod FindCommonOrdExecute(ByRef qHandle As %Binary, CommonOrd As %String, ViewCat As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	s rowid=0
	f  s rowid=$o(^DHCICUC("RecordItem",rowid)) q:rowid=""  d	 
	  .s ComOrdRowDesc=$p($g(^DHCICUC("RecordItem",rowid)),"^",2)
	  .s ANCEViewCatId=$p($g(^DHCICUC("RecordItem",rowid)),"^",5)	
	  .;i (CommonOrd'="")&&((CommonOrd=rowid)||(ComOrdRowDesc[CommonOrd))&&(ViewCat'="")&&(ViewCat=ANCEViewCatId) d OutputRow4
	  .;i (CommonOrd'="")&&((CommonOrd=rowid)||(ComOrdRowDesc[CommonOrd))&&(ViewCat'="") d OutputRow4
	  .;i (CommonOrd="")&&(ViewCat'="")&&(ViewCat=ANCEViewCatId) d OutputRow4
	  .;i (CommonOrd="")&&(ViewCat="") d OutputRow4	  
	  .i ViewCat'="" 	
	  .i (ComOrdRowDesc[CommonOrd) d OutputRow4
	  .e  i ((ComOrdRowDesc[CommonOrd)&&(ViewCat=ANCEViewCatId)) d OutputRow4
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(ComOrdRowDesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindCommonOrdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCommonOrdExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCommonOrdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCommonOrdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query Findspeedunit(OrcItmMast As %String, ViewCat As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
  select ICUCSU_Desc As ANCSUDesc,%ID As ANCSURowId From SQLUSER.DHC_ICUC_SpeedUnit
}

Query FindUom(OrcItmMast As %String, ViewCat As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
 select CTUOM_Desc As ANCSUDesc,%ID As ANCSURowId From SQLUSER.ct_uom
}

}
