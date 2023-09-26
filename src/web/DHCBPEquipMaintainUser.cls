Class web.DHCBPEquipMaintainUser Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPEquipMaintainUser","FindEMaintainUser","")
Query FindEMaintainUser(BPEMId) As %Query(ROWSPEC = "tRowId:%String,BPEMUserDr:%String,BPEMUserName:%String")
{
}

ClassMethod FindEMaintainUserExecute(ByRef qHandle As %Binary, BPEMId) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tRowId=0
 	i BPEMId="" d
	.for  s tRowId=$o(^DHCBPEquipMaintainUser(tRowId)) q:tRowId=""  d
	..s tBPEMId=$lg(^DHCBPEquipMaintainUser(tRowId),1)
	..s userId=$lg(^DHCBPEquipMaintainUser(tRowId),2)
	..s userName=$lg(^DHCBPEquipMaintainUser(tRowId),3)
	..d OutputRow1
	e  d
	.s tRowId=0
	.f  s tRowId=$o(^DHCBPEquipMaintainUser(0,"EquipMaintain",BPEMId,tRowId)) q:tRowId=""  d
	..s tBPEMId=$lg(^DHCBPEquipMaintainUser(tRowId),1)
	..s userId=$lg(^DHCBPEquipMaintainUser(tRowId),2)
	..s userName=$lg(^DHCBPEquipMaintainUser(tRowId),3)
	..d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPEMId,userId,userName)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindEMaintainUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEMaintainUserExecute ]
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

ClassMethod FindEMaintainUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEMaintainUserExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 根据检测表ID获取参加人信息
/// w ##class(web.DHCBPEquipMaintainUser).GetEquipMaintainUser("3")
ClassMethod GetEquipMaintainUser(BPEMId) As %String
{
	s useridList=""
	s userNameList=""
	s tRowId=0
	for  s tRowId=$o(^DHCBPEquipMaintainUser(tRowId)) q:tRowId=""  d
	.s tBPEMId=$lg(^DHCBPEquipMaintainUser(tRowId),1)
	.q:(BPEMId'="")&&(BPEMId '=tBPEMId)
	.s userId=$lg(^DHCBPEquipMaintainUser(tRowId),2)
	.q:((userId=$c(0))!(userId=""))
	.i useridList="" s useridList=userId
	.e  d
	..s useridList=useridList_","_userId
	.s userName=$lg(^DHCBPEquipMaintainUser(tRowId),3)
	.i userNameList="" s userNameList=userName
	.e  d
	..s userNameList=userNameList_","_userName
	q useridList_"^"_userNameList
}

/// 根据维护记录id查找维护院外参加人信息
/// w ##class(web.DHCBPEquipMaintainUser).GetEquipMaintainUserOut("3")
ClassMethod GetEquipMaintainUserOut(BPEMId) As %String
{
	s userNameList=""
	s tRowId=0
	i BPEMId="" q:""
	for  s tRowId=$o(^DHCBPEquipMaintainUser(0,"EquipMaintain",BPEMId,tRowId)) q:tRowId=""  d
	.s userid= $lg($g(^DHCBPEquipMaintainUser(tRowId)),2)
	.q:'((userid=$c(0))!(userid=""))
	.s userName=$lg($g(^DHCBPEquipMaintainUser(tRowId)),3)
	.i userNameList="" s userNameList=userName
	.e  d
	..s userNameList=userNameList_","_userName
	q userNameList
}

}
