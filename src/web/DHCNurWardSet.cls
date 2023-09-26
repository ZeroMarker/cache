Class web.DHCNurWardSet Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query WardList(name As %String) As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String,singroom:%String,loc:%String,active:%String")
{
}

ClassMethod WardListExecute(ByRef qHandle As %Binary, name As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=2
 	S code=""
    s ^CacheTemp(repid,1)=$lb("","","","","","")
 	f  s code=$o(^PAWARD(0,"WARD_Code",code)) q:code=""  d
 	.s rowid=0
 	.f  s rowid=$o(^PAWARD(0,"WARD_Code",code,rowid)) q:rowid=""  d
 	..s code2=$p(^PAWARD(rowid),"^",1)		// 修改：code改为code2
 	..s desc=$p(^PAWARD(rowid),"^",2)
 	..q:(name'="")&&(desc'=name)
 	..s singroom=$p(^PAWARD(rowid),"^",4)
 	..s loc=$p(^PAWARD(rowid),"^",5)
 	..s active=$p(^PAWARD(rowid),"^",6)
 	..q:active="N"
 	..s dateFrom=$p(^PAWARD(rowid),"^",7)
 	..s timeFrom=$p(^PAWARD(rowid),"^",8)
 	..s dateTo=$p(^PAWARD(rowid),"^",9)
 	..s timeTo=$p(^PAWARD(rowid),"^",10)
 	..s dateTimeFrom=1000000000*dateFrom+timeFrom
 	..s dateTimeTo=1000000000*dateTo+timeTo 
 	..s h=(+$h)*1000000000+$p($h,",",2)
 	..q:((h<dateTimeFrom)&&(dateFrom'=""))!((h>dateTimeTo)&&(dateTo'=""))
 	..s Data=$lb(rowid,code2_"-"_desc,desc,singroom,loc,active)			// 修改：code改为code2
 	..Set ^CacheTemp(repid,ind)=Data
    ..Set ind=ind+1
  
    Set qHandle=$lb(0,repid,0)
    
	Quit $$$OK
}

ClassMethod WardListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WardListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod WardListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WardListExecute ]
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

Query WardProGroupList(wardid As %String = "0", GroupCode = "", GroupDesc = "") As %Query(ROWSPEC = "RowId :%String,GroupCode:%String,GroupDesc:%String,ActivFlag:%String,wardrowid:%String,warddesc:%String")
{
}

ClassMethod WardProGroupListExecute(ByRef qHandle As %Binary, wardid As %String = "0", GroupCode = "", GroupDesc = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s ^tempsc("WardProGroupList")=$lb(wardid ,GroupCode ,GroupDesc)
 	s wardrowid=##class(web.PACWard).GetWardFromLoc(%session.Data("LOGON.CTLOCID"))

 	i wardrowid="" d
 	.s wardrowid=wardid
 
 	I wardrowid=""
 	{
	 	    S wardrowid=""
	 	    f  s wardrowid=$o(^DHCWardProGroup(0,"WardDr",wardrowid)) q:wardrowid=""  d
	 		.d jlaber
	 		s qHandle=$lb(0,repid,0)
	        Quit $$$OK
 	}
 	else
 	{
	 	    d jlaber
	 		s qHandle=$lb(0,repid,0)
	        Quit $$$OK
 	}

    //s ^jack("xxxxx",wardrowid)=wardrowid
    ;d ##class(%ResultSet).RunQuery("web.DHCNurWardSet","WardProGroupList","")
jlaber	
 	s rowid=0
 	f  s rowid=$o(^DHCWardProGroup(0,"WardDr",wardrowid,rowid)) q:rowid=""  d
    .s code=$p(^DHCWardProGroup(rowid),"^",1)
    .q:(GroupCode'="")&&(GroupCode'=code)
    .s desc=$p(^DHCWardProGroup(rowid),"^",2)
    .q:(GroupDesc'="")&&(GroupDesc'=desc)
    .s active=$p(^DHCWardProGroup(rowid),"^",3)
    .s wardrowid=$p(^DHCWardProGroup(rowid),"^",4)
    .s warddesc=$p(^PAWARD(wardrowid),"^",2)
	.b
	.s Data=$lb(rowid,code,desc,active,wardrowid,warddesc)
 	.Set ^CacheTemp(repid,ind)=Data
    .Set ind=ind+1
	q
}

ClassMethod WardProGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WardProGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod WardProGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WardProGroupListExecute ]
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

/// 病区选床位
ClassMethod BedList(itmjs As %Library.String = "", Wardrow As %String, GroupRowId As %String) As %String
{
	;d ##class(web.DHCNurWardSet).BedList("","19")
	s roomid=0
	s str=""
	f  s roomid=$o(^PAWARD(0,"WardRoom",Wardrow,roomid)) q:roomid=""  d
	.s sub=0
	.f  s sub=$o(^PAWARD(0,"WardRoom",Wardrow,roomid,sub)) q:sub=""  d
	..s code=$p($g(^PAWARD(Wardrow,"BED",sub)),"^",1)
	..q:code=""
    ..s bedRowId=Wardrow_"||"_sub
    ..q:bedRowId=""
    ..s profGroupDr=$O(^DHCWardProGroupBed(0,"PacBedDr",bedRowId,""))
    ..s profGroupRowId=""
    ..i profGroupDr'="" d
    ...s profGroupRowId=$P($G(^DHCWardProGroupBed(profGroupDr)),"^",1)
	..q:(profGroupRowId'="")&(profGroupRowId'=GroupRowId)
	..s retval=itmjs_"('"_$ZCVT(code,"O","JS")_"','"_$ZCVT(Wardrow_"||"_sub,"O","JS")_"');"
	..&javascript<#(retval)#>
	q 0
}

// 专业组    ---病区床位

ClassMethod SaveAndUpdateWardProGroup(val As %String) As %String
{
	s error = 0
	s groupCode=$p(val,"^",1)
	s groupDesc=$p(val,"^",2)
	s activFlag=$p(val,"^",3)
	s wardDr=$p(val,"^",4)
	s rowid=$p(val,"^",5)
	s updateUser=$p(val,"^",6)
	s wardGroupID = ""
	for 
	{
		s wardGroupID = $o(^DHCWardProGroup(0,"WardDr",wardDr,wardGroupID))
		s oldGroupCode = $p(^DHCWardProGroup(wardGroupID),"^",1)
		s oldGroupDesc = $p(^DHCWardProGroup(wardGroupID),"^",2)
		if (groupCode=oldGroupCode)!(groupDesc=oldGroupDesc)
		{
			s error = 1
			q
			}
	}
	q:error=1 -200
	if rowid="" 
	{
		s obj=##class(User.DHCWardProGroup).%New()
	}
	else
	{
		s obj=##class(User.DHCWardProGroup).%OpenId(rowid)
	}

	d obj.WPGWardDrSetObjectId(wardDr)
	s obj.WPGGroupCode =groupCode
	s obj.WPGGroupDesc = groupDesc
	s obj.WPGActivFlag = $s(activFlag="true":"Y",1:"N")
	d obj.WPGUpdateUserSetObjectId(updateUser)
	s obj.WPGUpdateDate=+$h
	s obj.WPGUpdateTime=$p($h,",",2)
	b
	set sc=obj.%Save()
	i $$$ISERR(sc) Do $System.Status.DisplayError(sc)
	q:$$$ISERR(sc) -1
	q 1
}

ClassMethod DeletWardProGroup(rowid As %String) As %String
{
	s sc= ##class(User.DHCWardProGroup).%DeleteId(rowid)
	q:$$$ISERR(sc) -1
	q 1
}

ClassMethod DeletWardProGroupBed(rowid As %String) As %String
{
	s sc= ##class(User.DHCWardProGroupBed).%DeleteId(rowid)
	q:$$$ISERR(sc) -1
	q 1
}

ClassMethod SaveAndUpdateWardProGroupBed(val As %String, addstr As %String, delstr As %String)
{
	;d ##class(web.DHCNurWardSet).SaveAndUpdateWardProGroupBed("4^16^897","","16||51,16||50,16||49,16||48,16||47,16||46,16||45,16||44,16||43,16||42,16||41,16||40,16||39,16||38,16||37,16||36,16||35,16||34,16||33,16||32,16||31,16||30,16||29,16||28,16||27,16||26,16||25,16||24,16||23,16||22,16||21,16||20,16||19,16||18,16||17,16||16,16||15,16||14,16||13,16||12,16||11,16||10,16||9,16||8,16||7,16||6,16||4,16||3,16||2,16||1")
	s retrnstr=0
	s group=$p(val,"^",1)
	s ward=$p(val,"^",2)
	s updateUser=$p(val,"^",3)
	s addlen=$l(addstr,",")
	s dellen=$l(delstr,",")
	s qstr=0
	SET $ZTRAP="ERR"
	ts
	f i=1:1:addlen d
	.s addrow=$p(addstr,",",i)
	.q:addrow=""
	.s obj=##class(User.DHCWardProGroupBed).%New()
	.d obj.WPGBGroupDrSetObjectId(group)
	.d obj.WPGBWardDrSetObjectId(ward)     
	.d obj.WPGBPacBedDrSetObjectId(addrow) 
	.d obj.WPGBUpdateUserSetObjectId(updateUser)
	.s obj.WPGBUpdateDate=+$H 
	.s obj.WPGBUpdateTime=$p($h,",",2)  
	.s savec=obj.%Save()
	.i $$$ISERR(savec) Do $System.Status.DisplayError(savec)
	f i=1:1:dellen d
	.s delrow=$p(delstr,",",i)
	.q:delrow=""
	.&sql(delete from Sqluser.DHC_WardProGroupBed where WPGB_GroupDr=:group and WPGB_WardDr=:ward and WPGB_PacBedDr=:delrow )
	. ;s delc= ##class(User.DHCWardProGroupBed).%DeleteId(delrow) 
	.;i $$$ISERR(delc) Do $System.Status.DisplayError(delc)
	Tc

	q 1
ERR
 Trollback
	s ^pjf(2)=$ze
 q 0
}

Query WardProGroupBedList(grouprow As %String = "") As %Query(ROWSPEC = "rowid:%String,group:%String,ward:%String,pacBed:%String")
{
}

ClassMethod GetBedByGroup(grouprow As %String) As %String
{
	s ret1=""
	Set rset=##class(%ResultSet).%New("web.DHCNurWardSet:WardProGroupBedList")
	do rset.Execute(grouprow)

	set row=0
	While (rset.Next()) {
		set ret=rset.GetData(4)
	    i ret1="" s ret1=ret
	    e  s ret1=ret_"!"_ret1
	}
	d rset.Close()
	Q ret1
}

ClassMethod WardProGroupBedListExecute(ByRef qHandle As %Binary, grouprow As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCNurWardSet","WardProGroupBedList","3")
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
 	f  s rowid=$o(^DHCWardProGroupBed(0,"GroupDr",grouprow,rowid)) q:rowid=""  d
    .s group=$p(^DHCWardProGroupBed(rowid),"^",1)
    .s group=$s(group'="":$p(^DHCWardProGroup(group),"^",2),1:"")
    .s ward=$p(^DHCWardProGroupBed(rowid),"^",2)
    .s ward=$s(ward'="":$p(^PAWARD(ward),"^",2),1:"")
    .s pacBed=$p(^DHCWardProGroupBed(rowid),"^",3)
    .;s pacBed=$s(pacBed'="":$p(^PAWARD(+pacBed,"BED",$p(pacBed,"||",2)),"^",1),1:"")
	.s Data=$lb(rowid,group,ward,pacBed)
 	.Set ^CacheTemp(repid,ind)=Data
    .Set ind=ind+1
	
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod WardProGroupBedListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = WardProGroupBedListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod WardProGroupBedListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = WardProGroupBedListExecute ]
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

}
