Import SQLUser

/// creater:		LYN
/// creatDate:	2015/06/29
/// 
Class web.DHCCLCDiagCat Extends %RegisteredObject
{

/// creater:		LYN
/// creatDate:	2015/06/29
/// descripation:查询诊断与分类的关联信息
/// d ##class(%ResultSet).RunQuery("web.DHCCLCDiagCat","LookUpDiagCatLink")
Query LookUpDiagCatLink(diagCatId As %String = "", hospId As %String = "") As %Query(ROWSPEC = "rowId:%String,Diagnosis:%String,DiagCatDes:%String,DiagId:%String,DiagCatId:%String")
{
}

ClassMethod LookUpDiagCatLinkExecute(ByRef qHandle As %Binary, diagCatId As %String = "", hospId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowId="",i=0 
	s Diagnosis="",DiagCatDes=""
	i diagCatId'="" d
	.f  s rowId=$o(^DHCCLC("DiagCatLink",0,"Cat",diagCatId,rowId)) q:rowId=""  d	
	..s hospitalId=""
	..s DataAttributionDr=$lg($g(^DHCCLC("DiagCatLink",rowId)),4)
	..i DataAttributionDr'="" s hospitalId=$li(^DHCBPC("DataAttribution",DataAttributionDr),1)
	..q:((hospitalId'="")&(hospId'=hospitalId))	
	..s DiagId=$lg($g(^DHCCLC("DiagCatLink",rowId)),1)
	..i DiagId'="" s Diagnosis=$p(^MRC("ID",DiagId),"^",2)
	..s DiagCatId=$lg($g(^DHCCLC("DiagCatLink",rowId)),2)
	..i DiagCatId'="" s DiagCatDes=$lg($g(^DHCCLC("DiagCat",DiagCatId)),2)
	..s ^Lyntmp(DiagCatId)=DiagCatDes_"^"_Diagnosis
 	..Do OutputRow2	 
 	e  d
 	.s diagcatId=""
 	.f  s diagcatId=$o(^DHCCLC("DiagCatLink",0,"Cat",diagcatId)) q:diagcatId=""  d
 	..q:diagcatId=""
 	..f  s rowId=$o(^DHCCLC("DiagCatLink",0,"Cat",diagcatId,rowId)) q:rowId=""  d 	
 	...s hospitalId=""
	...s DataAttributionDr=$lg($g(^DHCCLC("DiagCatLink",rowId)),4)
	...i DataAttributionDr'="" s hospitalId=$li(^DHCBPC("DataAttribution",DataAttributionDr),1)
	...q:((hospitalId'="")&(hospId'=hospitalId))	
	...s DiagId=$lg($g(^DHCCLC("DiagCatLink",rowId)),1)
	...i DiagId'="" s Diagnosis=$p(^MRC("ID",DiagId),"^",2)
	...s DiagCatId=$lg($g(^DHCCLC("DiagCatLink",rowId)),2)
	...i DiagCatId'="" s DiagCatDes=$lg($g(^DHCCLC("DiagCat",DiagCatId)),2)
	...s ^Lyntmp(DiagCatId)=DiagCatDes_"^"_Diagnosis
	...Do OutputRow2
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(rowId,Diagnosis,DiagCatDes,DiagId,DiagCatId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpDiagCatLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpDiagCatLinkExecute ]
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

ClassMethod LookUpDiagCatLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpDiagCatLinkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// creater:		LYN
/// creatDate:	2015/06/29
/// descripation:查询诊断分类信息
/// d ##class(%ResultSet).RunQuery("web.DHCCLCDiagCat","LookUpDiagCat")
Query LookUpDiagCat(code As %String = "", DiagCatDesc As %String = "", hospId As %String = "") As %Query(ROWSPEC = "DiagCatDes:%String,rowId:%String,Code:%String")
{
}

ClassMethod LookUpDiagCatExecute(ByRef qHandle As %Binary, code As %String = "", DiagCatDesc As %String = "", hospId As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowId="",i=0 
	f  s rowId=$o(^DHCCLC("DiagCat",rowId)) q:rowId=""  d
	.s hospitalId=""
	.s DataAttributionDr=$lg($g(^DHCCLC("DiagCat",rowId)),3)
	.i DataAttributionDr'="" s hospitalId=$li(^DHCBPC("DataAttribution",DataAttributionDr),1)
	.q:((hospitalId'="")&(hospId'=hospitalId))
	.s Code=$lg($g(^DHCCLC("DiagCat",rowId)),1)
	.q:(code'="")&&(Code'=code)
	.s DiagCatDes=$lg($g(^DHCCLC("DiagCat",rowId)),2)
	.q:(DiagCatDesc'="")&&(DiagCatDes'[DiagCatDesc)
 	.Do OutputRow2	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(DiagCatDes,rowId,Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpDiagCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpDiagCatExecute ]
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

ClassMethod LookUpDiagCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpDiagCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// creater:		LYN
/// creatDate:	2015/06/29
/// table:		DHC_CLC_DiagCatLink
/// input:		DiagId:诊断；DiagCatId:分类
/// description:	插入诊断与分类的关联信息
ClassMethod InsertDiagCatLink(DiagId As %String, DiagCatId, hospId As %String = "")
{
	q:DiagId="" "诊断不能为空" 
	q:DiagCatId="" "分类ID不能为空"
	k PLIST
	s PLIST(2)=DiagId
	s PLIST(3)=DiagCatId
	&SQL(insert into DHC_CLC_DiagCatLink Values :PLIST())
	s rowid=%ROWID
    i SQLCODE'=0  q "插入诊断分类错误!"
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCCLCDiagCatLink")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCCLCDiagCatLink",rowid,hospId)
    }
    q 0
}

/// creater:		LYN
/// creatDate:	2015/06/29
/// table:		DHC_CLC_DiagCatLink
/// input:		DiagCatLinkId：关联表id，DiagId：诊断id，DiagCatId：诊断分类id
/// description:	更新诊断与分类的关联信息
ClassMethod UpdateDiagCatLink(DiagCatLinkId As %String, DiagId As %String, DiagCatId, hospId As %String = "")
{
	q:DiagCatLinkId="" "ID不能为空"
	q:DiagId="" "诊断不能为空" 
	q:DiagCatId="" "分类ID不能为空"
	k PLIST
	s PLIST(2)=DiagId
	s PLIST(3)=DiagCatId
	&SQL(update DHC_CLC_DiagCatLink set CLCDCL_ICD_Dr=:DiagId,CLCDCL_DiagCat_Dr=:DiagCatId where ID=:DiagCatLinkId )
	s rowid=%ROWID
    i SQLCODE'=0  q "更新诊断分类关联表错误!"
    if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCCLCDiagCatLink")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCCLCDiagCatLink",rowid,hospId)
    }
    q 0
}

/// creater:		LYN
/// creatDate:	2015/06/29
/// table:		DHC_ANC_DiagCat
/// input:		Code:分类代码；Desc:分类名称
/// description:	插入诊断分类信息
ClassMethod InsertDiagCat(Code As %String, Desc As %String, hospId As %String = "") As %String
{
	q:Code="" "分类代码不能为空" 
	q:Desc="" "分类名称不能为空"
	s Code=$$ALPHAUP^SSUTIL4(Code)
	k PLIST
	s PLIST(2)=Code
	s PLIST(3)=Desc
	&SQL(insert into DHC_CLC_DiagCat Values :PLIST())
	s rowid=%ROWID
    i SQLCODE'=0  q "插入诊断分类错误!"
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCCLCDiagCat")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCCLCDiagCat",rowid,hospId)
    }
    q 0
}

/// creater:		LYN
/// creatDate:	2015/06/29
/// table:		DHC_CLC_DiagCat
/// input:		Code:分类代码；Desc:分类名称
/// description:	插入诊断分类信息
ClassMethod UpdateDiagCat(Rowid As %String, Code As %String, Desc As %String, hospId As %String = "") As %String
{
	q:Rowid="" "Id不能为空"
	q:Code="" "分类代码不能为空" 
	q:Desc="" "分类名称不能为空"
	s Code=$$ALPHAUP^SSUTIL4(Code)
	k PLIST
	s PLIST(2)=Code
	s PLIST(3)=Desc
	&SQL(update DHC_CLC_DiagCat Values :PLIST() where ID=:Rowid)
	s Rowid=%ROWID
    i SQLCODE'=0  q "更新诊断分类错误!"
    if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCCLCDiagCat")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCCLCDiagCat",Rowid,hospId)
    }
    q 0
}

/// w ##class(web.DHCCLC)
ClassMethod DeleteDiagCat(Rowid As %String) As %String
{
	q:Rowid="" "Id不能为空"
	&SQL(delete from DHC_CLC_DiagCat  where ID=:Rowid)
    i SQLCODE'=0  q "删除诊断分类错误!"
    if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCCLCDiagCat")
	{
		do ##class(web.DHCBPCTablePermission).UnbindAttribution("User.DHCCLCDiagCat",Rowid)
    }
    q 0
}

ClassMethod DeleteDiagCatLink(Rowid As %String) As %String
{
	q:Rowid="" "Id不能为空"
	&SQL(delete from DHC_CLC_DiagCatLink  where ID=:Rowid)
    i SQLCODE'=0  q "删除诊断与分类关联错误!"
    if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCCLCDiagCatLink")
	{
		do ##class(web.DHCBPCTablePermission).UnbindAttribution("User.DHCCLCDiagCatLink",Rowid)
    }
    q 0
}

Query LookUpMrcDiagnosis(mrcidAlias As %String) As %Query(ROWSPEC = "DiagDes:%String,rowid0:%String")
{
}

ClassMethod LookUpMrcDiagnosisExecute(ByRef qHandle As %Binary, mrcidAlias As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0,i=0 //ypz 060811
	if mrcidAlias'=""
	{
	 // s icdx=""  s icdx=$O(^MRC("IK_Name",$ZCONVERT(mrcidAlias,"U"),icdx),-1)
    	//if (icdx'="")
	//   {
	//	 if $D(^MRC("ID",icdx))
	//	 {
		 // s DiagDes=$p(^MRC("ID",icdx),"^",2)
	     // s rowid0=icdx
	     // d OutputRow2
	     // b
	     // Set qHandle=$lb(0,repid,0)
	     // Quit $$$OK
		// }
     // }
	s type=$$ALPHAUP^SSUTIL4(mrcidAlias)  //ypz 070313 $ZCONVERT(mrcidAlias,"U")
    i type'="" d
		.s flag="N"
		.s OpDiag=$O(^MRC("ID",0,"ALIAS",type),-1) //ypz 070313 保证找到当前串
    	.f  s OpDiag=$O(^MRC("ID",0,"ALIAS",OpDiag)) q:(OpDiag="")!(flag="Y")  d
    		..if $e(OpDiag,1,$L(type))'=type s flag="Y" q
    		..s mrcidId=""
    		..f  s mrcidId=$O(^MRC("ID",0,"ALIAS",OpDiag,mrcidId)) q:(mrcidId="")  d
    			...//s opaId="" s opaId=$O(^MRC("ID",0,"ALIAS",OpDiag,opaId),-1) 
    			...s rowid0=mrcidId
    			...s DiagDes=$p(^MRC("ID",mrcidId),"^",2)
    			...s i=i+1
    			...Do OutputRow2
	}
	if i>0 Set qHandle=$lb(0,repid,0) Quit $$$OK
	f  s rowid=$o(^MRC("ID",rowid)) q:rowid=""  d
	.s DiagDes=$p(^MRC("ID",rowid),"^",2)
	.;s userloc=$p(^SSU("SSUSR",rowid),"^",4)
	.s rowid0=rowid
	.s LinkStr=$ZCONVERT(mrcidAlias,"U")
	.if (DiagDes)[(LinkStr)  do
 	..Do OutputRow2	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow2
	set Data=$lb(DiagDes,rowid0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpMrcDiagnosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpMrcDiagnosisExecute ]
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

ClassMethod LookUpMrcDiagnosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpMrcDiagnosisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// creater:		MFC
/// creatDate:	2016/10/13
/// descripation:根据诊断分类ID或者诊断分类Code，获取诊断与分类的信息
/// inout: diagCatId诊断分类ID,diagCatCode诊断分类Code
/// d ##class(%ResultSet).RunQuery("web.DHCCLCDiagCat","FindDiagCatLink","","PDDIAG")
Query FindDiagCatLink(diagCatId As %String = "", diagCatCode As %String = "") As %Query(ROWSPEC = "rowId:%String,Id:%String,Description:%String,DiagCatDes:%String,DiagCatId:%String")
{
}

ClassMethod FindDiagCatLinkExecute(ByRef qHandle As %Binary, diagCatId As %String = "", diagCatCode As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowId="",i=0 
	s Description="",DiagCatDes=""	
 	s diagcatId=""
 	f  s diagcatId=$o(^DHCCLC("DiagCatLink",0,"Cat",diagcatId)) q:diagcatId=""  d
 	.q:(diagCatId'="")&&(diagcatId'=diagCatId)
 	.f  s rowId=$o(^DHCCLC("DiagCatLink",0,"Cat",diagcatId,rowId)) q:rowId=""  d
	..s Id=$lg($g(^DHCCLC("DiagCatLink",rowId)),1)
	..i Id'="" s Description=$p(^MRC("ID",Id),"^",2)
	..s DiagCatId=$lg($g(^DHCCLC("DiagCatLink",rowId)),2)
	..i DiagCatId'="" d
	...s DiagCatCode=$lg($g(^DHCCLC("DiagCat",DiagCatId)),1)
	...q:(diagCatCode'="")&&(DiagCatCode'=diagCatCode)
	...s DiagCatDes=$lg($g(^DHCCLC("DiagCat",DiagCatId)),2)
	...Do OutputRow3
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK    
OutputRow3
	set Data=$lb(rowId,Id,Description,DiagCatDes,DiagCatId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindDiagCatLinkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDiagCatLinkExecute ]
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

ClassMethod FindDiagCatLinkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindDiagCatLinkExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
