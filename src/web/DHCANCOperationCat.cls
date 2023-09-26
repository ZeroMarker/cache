Import SQLUser

/// Creator:LYN
/// Descripation:手术分类维护
/// 
Class web.DHCANCOperationCat Extends %RegisteredObject
{

/// creater:		LYN
/// creatDate:		2016/04/10
/// Descripation:手术与诊断分类维护
/// Table：DHC_ANC_OperationCat 根据实际情况，当前表为诊断分类和手术分类均使用的表结构
/// 			根据表中的ANCOC_Type 来区分当前诊断是诊断分类还是手术分类，同时这张表又有关联的
/// 			的DHC_ANC_DiagCat  的指针
/// d ##class(%ResultSet).RunQuery("web.DHCANCOperationCat","LookUpOperationCat","","","","","O")
Query LookUpOperationCat(code As %String = "", OperationCatDesc As %String = "", LocId As %String = "", sysCat As %String = "", CatType As %String = "") As %Query(ROWSPEC = "rowId:%String,Code:%String,Desc:%String,LocId:%String,LocDesc:%String,sysCatId:%String,sysCatDesc:%String,catTypeCode:%String,catTypeDesc:%String")
{
}

ClassMethod LookUpOperationCatExecute(ByRef qHandle As %Binary, code As %String = "", OperationCatDesc As %String = "", LocId As %String = "", sysCat As %String = "", CatType As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowId="",i=0 
	f  s rowId=$o(^DHCANC("OperationCat",rowId)) q:rowId=""  d
	.s Code=$lg($g(^DHCANC("OperationCat",rowId)),1)
	.q:(code'="")&&(Code'=code)
	.s OperationCatDes=$lg($g(^DHCANC("OperationCat",rowId)),2)
	.q:(OperationCatDesc'="")&&(OperationCatDes'[OperationCatDesc)
	.s locId=$lg($g(^DHCANC("OperationCat",rowId)),3)
	.q:(LocId'="")&&(locId'=LocId)
	.s LocDesc=""
	.i locId'="" s LocDesc=$p(^CTLOC(locId),"^",2)
	.s sysCatId=$lg($g(^DHCANC("OperationCat",rowId)),4)
	.q:(sysCat'="")&(sysCat'=sysCatId)
	.s sysCatDesc=""
	.i sysCatId'="" s sysCatDesc=$lg($g(^DHCANC("DiagCat",sysCatId)),2)
	.s catTypeCode=$lg($g(^DHCANC("OperationCat",rowId)),5)
	.q:(CatType'="")&(CatType'=catTypeCode)
	.s catTypeDesc=""
	.i catTypeCode="O" s catTypeDesc="手术分类"
	.i catTypeCode="P" s catTypeDesc="诊断分类"
 	.Do OutputRow2	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(rowId,Code,OperationCatDes,locId,LocDesc,sysCatId,sysCatDesc,catTypeCode,catTypeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpOperationCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpOperationCatExecute ]
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

ClassMethod LookUpOperationCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpOperationCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// creater:		LYN
/// creatDate:		2016/04/10
/// table:			DHC_ANC_OperationCat
/// input:			Code:分类代码；Desc:分类名称
/// description:	插入手术分类信息
ClassMethod InsertOperationCat(LocId As %String, Code As %String, Desc As %String, sysCat As %String, CatType As %String) As %String
{
	q:Code="" "分类代码不能为空" 
	q:Desc="" "分类名称不能为空"
	;q:LocId="" "科室不能为空"
	q:CatType="" "分类类别不能为空"
	s Code=$$ALPHAUP^SSUTIL4(Code)
	k PLIST
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=LocId
	s PLIST(5)=sysCat
	s PLIST(6)=CatType
	&SQL(insert into DHC_ANC_OperationCat Values :PLIST())
	s rowid=%ROWID
    i SQLCODE'=0  q "插入分类错误!"
    q 0
}

/// creater:		LYN
/// creatDate:	2016/04/10
/// table:		DHC_ANC_OperationCat
/// input:		Code:分类代码；Desc:分类名称
/// description:	插入手术分类信息
/// W ##class(web.DHCANCOperationCat).UpdateOperationCat(7,"SJJR","神经介入","","9","D")
ClassMethod UpdateOperationCat(Rowid As %String, Code As %String, Desc As %String, LocId As %String, sysCat As %String, CatType As %String) As %String
{
	q:Rowid="" "Id不能为空"
	q:Code="" "分类代码不能为空" 
	q:Desc="" "分类名称不能为空"
	//q:LocId="" "科室不能为空"
	//q:CatType="" "分类类别不能为空"
	s Code=$$ALPHAUP^SSUTIL4(Code)
	k PLIST
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=LocId
	s PLIST(5)=sysCat
	s PLIST(6)=CatType
	&SQL(update DHC_ANC_OperationCat Values :PLIST() where ID=:Rowid)
	s Rowid=%ROWID
	;s ^LYNTMP("OPCAT")=sysCat_"/"_CatType_"/"_SQLCODE_"/"_Rowid
    i SQLCODE'=0  q "更新分类错误!"
    q 0
}

ClassMethod DeleteOperationCat(Rowid As %String) As %String
{
	q:Rowid="" "Id不能为空"
	&SQL(delete from DHC_ANC_OperationCat  where ID=:Rowid)
    i SQLCODE'=0  q "删除手术分类错误!"
    s operId=0
	f  s operId=$o(^ORC("OPER",operId)) q:operId=""  d
		.s operCat=$p($g(^ORC("OPER",operId,"DHC")),"^",16)
		.q:(operCat'=Rowid)
		.s $p(^ORC("OPER",operId,"DHC"),"^",16)=""
    q 0
}

/// W ##class(web.DHCANCOperationCat).killoperlink()
ClassMethod killoperlink()
{
	s rowid=0
	f  s rowid=$o(^ORC("OPER",rowid)) q:rowid=""  d
		.i $g(^ORC("OPER",rowid,"DHC"))'="" d
			..w rowid,!
			..i rowid'="" W $g(^ORC("OPER",rowid)),!
			..K ^ORC("OPER",rowid,"DHC")
			..
			..i rowid=9155 b
			..i rowid'="" S ^LYN("OPER",rowid)=$g(^ORC("OPER",rowid))
}

}
