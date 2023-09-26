Class web.NurMgAdvComm Extends %RegisteredObject
{

/// Creator:guozj
/// Description:获取全院病区
/// Date:2018-07-11
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgAdvComm","FindAdvWards","")
Query FindAdvWards(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAdvWardsExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindAdvWards")=parr
	s ret=""
	s spell="" f  s spell=$o(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s row="" f  s row=$o(^DHCNMG.DB.MgWardI("Spell",spell,row)) q:row=""  d
	..s obj=##class(DHCNMG.DB.MgWard).%OpenId(row)
	..s warddesc=obj.WardDesc
	..q:((parr'="")&&(($tr(spell," ","")_warddesc)'[$zcvt($tr(parr," ",""),"U")))
	..s ret="warddesc|"_warddesc_"^wardrow|"_row
	..d AdvWardsData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
AdvWardsData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAdvWardsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdvWardsExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAdvWardsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdvWardsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:guozj
/// Description:按照病区获取全院的护士
/// Date:2018-07-11
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgAdvComm","FindWardNurse","")
Query FindWardNurse(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindWardNurseExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindWardNurse")=parr
	s ward=$p(parr,"^",1)
	s post=$p(parr,"^",2)
	s namestr=$p(parr,"^",3)
	s ret=""
	s spell="" f  s spell=$o(^DHCNMG.DB.MgWardI("Spell",spell)) q:spell=""  d
	.s row="" f  s row=$o(^DHCNMG.DB.MgWardI("Spell",spell,row)) q:row=""  d
	..q:((ward'="")&&(row'=ward))
	..s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(row)
	..s nurseward=wardobj.WardDesc //病区
	..s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsI("DepID"," "_row,rowid)) q:rowid=""  d
	...s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	...s nursename=obj.PerName //姓名
	...s nurseid=obj.PerID //工号
	...q:((namestr'="")&&(((nursename_nurseid)'[namestr)))
	...s nursepost=""
	...s postid="" f  s postid=$O(^DHCNMG.HR.MgPostDutyI("ssid",rowid,postid)) q:postid=""  d
	....s postobj=##class(DHCNMG.HR.MgPostDuty).%OpenId(postid)
	....q:(postobj.PostEndDate'="")
	....s nursepost=postobj.PostDuty
	...q:((post'="")&&(nursepost'="")&&(nursepost'=post))
	...s postdesc=""
	...i nursepost'="" s postdesc=##class(web.NurMgPersonComm).GetCommCode(nursepost) //职务
	...s ret="nurseward|"_nurseward_"^wardid|"_row_"^nurseid|"_nurseid_"^nursename|"_nursename_"^nursepost|"_postdesc_"^rowid|"_rowid
	...do AdvWardNurse
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
AdvWardNurse
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindWardNurseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardNurseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWardNurseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardNurseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Date:2018-07-12
/// Decription:保存安全小组
/// Input:groupName:组名 advType:不良事件类型
ClassMethod SaveSecurityData(groupName As %String, advType As %String, parr As %String) As %String
{
	s ^TMP("SaveAdvRec")=groupName_"%"_advType_"%"_parr
	//肿瘤小组%1||46^1||47^1||48^1||49%^1958!85;50;14;83!true^197!62;43;114;104;115;66!false
	s status=1
	s RowID=$P(groupName,"!",2)
	s SecurityDesc=$p(groupName,"!",1)
	i RowID="" s Obj=##class(DHCNMG.Set.MgSecurityGroup).%New()
	e  s Obj=##class(DHCNMG.Set.MgSecurityGroup).%OpenId(RowID)
	s Obj.SecurityDesc=SecurityDesc
	s TypeLen=$l(advType,"^")
	d Obj.SecurityType.Clear()
	f i=1:1:TypeLen
	{
		s TypeItm=$p(advType,"^",i)
		i TypeItm="" continue
		d Obj.SecurityType.Insert(TypeItm)
	}
	TS
	s sc=Obj.%Save()
	s flag=$$$ISOK(sc)
	s status=(status&&flag)
	i flag=1
	{
		s SubRow="" f  s SubRow=$O(^DHCNMG.Set.MgSecurityGroupSubD(Obj.%Id(),SubRow)) q:SubRow=""  d
		.s SubRowObj=##class(DHCNMG.Set.MgSecurityGroupSub).%OpenId(Obj.%Id()_"||"_SubRow)
		.d SubRowObj.%DeleteId(Obj.%Id()_"||"_SubRow)
		s ParrLen=$l(parr,"^")
		f j=1:1:ParrLen
		{
			////1958!85;50;14;83!true ^197!62;43;114;104;115;66!false
			s ParrItm=$p(parr,"^",j)
			i ParrItm="" continue
			s GroupMember=$p(ParrItm,"!",1)
			s Wards=$p(ParrItm,"!",2)
			s GroupHeader=$p(ParrItm,"!",3)
			s SubObj=##class(DHCNMG.Set.MgSecurityGroupSub).%New()
			s SubObj.Parref=##class(DHCNMG.Set.MgSecurityGroup).%OpenId(Obj.%Id())
			s SubObj.GroupMember=GroupMember
			s WardLen=$l(Wards,";")
			f k=1:1:WardLen
			{
				s WardItm=$p(Wards,";",k)
				i WardItm="" continue
				d SubObj.GroupWards.Insert(WardItm)
			}
			s SubObj.GroupHeader=GroupHeader
			s subsc=SubObj.%Save()
			s flag1=$$$ISOK(subsc)
			s status=(status&&flag1)
			
		}
		i status=1
		{
				TC
		}
		else
		{
			Tro
		}
	}
	else
	{
		Tro
	}
	q status
}

/// Creator:guozj
/// Description:查询安全小组列表
/// Date:2018-07-12
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: w ##class(%ResultSet).RunQuery("web.NurMgAdvComm","FindAdvGroupList","")
Query FindAdvGroupList(parr As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindAdvGroupListExecute(ByRef qHandle As %Binary, parr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ^TMP("FindAdvGroupList")=parr
	s input=$p(parr,"^",1)
	s ret=""
	s RowID="" f  s RowID=$O(^DHCNMG.Set.MgSecurityGroupD(RowID)) q:RowID=""  d
	.s Obj=##class(DHCNMG.Set.MgSecurityGroup).%OpenId(RowID)
	.s SecurityDesc=Obj.SecurityDesc
	.q:((input'="")&&(SecurityDesc'[$zcvt($tr(input," ",""),"U")))
	.s ret="SecurityDesc|"_SecurityDesc_"^Par|"_RowID
	.do AdvListData
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
AdvListData
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindAdvGroupListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdvGroupListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else  {	
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAdvGroupListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdvGroupListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAdvRecData(id As %String) As %String
{
	q:id="" ""
	s obj=##class(DHCNMG.Set.MgSecurityGroup).%OpenId(id)
	s SecurityDesc=obj.SecurityDesc
	s ret="SecurityDesc|"_SecurityDesc_"^RowID|"_id
	q ret
}

/// Creator:gzj
/// Date:2018-07-12
/// Decription:获取安全小组类型
ClassMethod GetAdvTypes(id As %String) As %String
{
	q:id="" ""
	s ret=""
	w "["
	s obj=##class(DHCNMG.Set.MgSecurityGroup).%OpenId(id)
	q:'$IsObject(obj) ""
	s types=obj.SecurityType
	s len=obj.SecurityType.Count()
	f i=1:1:len
	{
		s itm=obj.SecurityType.GetAt(i)
		i itm="" continue
		s advObj=##class(User.DHCMedAdrRepEventItm).%OpenId(itm)
		q:'$IsObject(advObj)
		i i=1 w "{""Desc"":"""_advObj.MADREVIDesc_""",""Code"":"""_advObj.MADREVICode_""",""Par"":"""_advObj.MADREVIParref.%Id()_""",""rw"":"""_advObj.MADREVIChildSub_"""}"
		e  i  w ",{""Desc"":"""_advObj.MADREVIDesc_""",""Code"":"""_advObj.MADREVICode_""",""Par"":"""_advObj.MADREVIParref.%Id()_""",""rw"":"""_advObj.MADREVIChildSub_"""}"
	}
	w "]"
	q ""
}

/// Creator:gzj
/// Date:2018-07-12
/// Decription:获取安全小组人员
ClassMethod GetAdvMember(id As %String) As %String
{
	q:id="" ""
	w "["
	s num=0
	s RowID="" f  s RowID=$O(^DHCNMG.Set.MgSecurityGroupSubD(id,RowID)) q:RowID=""  d
	.s num=num+1
	s m=0
	s RowID="" f  s RowID=$O(^DHCNMG.Set.MgSecurityGroupSubD(id,RowID)) q:RowID=""  d
	.s obj=##class(DHCNMG.Set.MgSecurityGroupSub).%OpenId(id_"||"_RowID)
	.s nursename=""
	.s nurseid=obj.GroupMember
	.s perobj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
	.q:'$IsObject(perobj)
	.s m=m+1
	.s nursename=perobj.PerName
	.s perid=perobj.PerID
	.s wardid=perobj.PerDepDR
	.s nurseheader=obj.GroupHeader
	.i m=1 w "{""nursename"":"""_nursename_""",""nurseid"":"""_perid_""",""wardid"":"""_wardid_""",""nurseheader"":"""_nurseheader_""",""rowid"":"""_nurseid_""""
	.e  i m<=num w ",{""nursename"":"""_nursename_""",""nurseid"":"""_nurseid_""",""wardid"":"""_wardid_""",""nurseheader"":"""_nurseheader_""",""rowid"":"""_nurseid_""""
	.s wardlen=obj.GroupWards.Count()
	.s wardlist=""
	.f j=1:1:wardlen d
	..s itm=obj.GroupWards.GetAt(j)
	..q:itm=""
	..s warddesc=""
	..s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(itm)
	..q:'$IsObject(wardobj)
	..s warddesc=wardobj.WardDesc
	..i j=1 w ",""wardlist"":[{""wardrow"":"""_itm_""",""warddesc"":"""_warddesc_"""}"
	..e  i j<=wardlen w ",{""wardrow"":"""_itm_""",""warddesc"":"""_warddesc_"""}"
	..
	.;i m<num w "]},"
	.;e  i m=num w "]}"
	.w "]}"
	w "]"
	q ""
}

ClassMethod DelAdvRec(id As %String) As %String
{
	q:id="" ""
	s flag=1
	TS
	s Rw="" f  s Rw=$O(^DHCNMG.Set.MgSecurityGroupSubD(id,Rw)) q:Rw=""  d
	.s SubObj=##class(DHCNMG.Set.MgSecurityGroupSub).%DeleteId(id_"||"_Rw)
	.s sc=$$$ISOK(SubObj)
	.s flag=(sc&&flag)
	s obj=##class(DHCNMG.Set.MgSecurityGroup).%DeleteId(id)
	s ret=$$$ISOK(obj)
	s flag=(ret&&flag)
	i flag=1
	{
		TC
	}
	else
	{
		Tro
	}
	q flag
}

ClassMethod GetNurseSecGroup(nurseno As %String) As %String
{
	q:nurseno="" ""
	i nurseno="DEMO"
	{
		s SSUID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt($tr(nurseno," ",""),"U"),""))
		q:SSUID="" ""
		s SSUObj=##class(User.SSUser).%OpenId(SSUID)
		s NurseGroup=SSUObj.SSUSRGroup.SSGRPDesc
		s NursePassword=##class(web.Util.Encryption).MD5HexStr(SSUObj.SSUSRPassword)
		s NurseLocDesc=SSUObj.SSUSRDefaultDeptDR.CTLOCDesc
	}
	else
	{
		s rowid=$o(^DHCNMG.HR.MgPersonsI("hisno"," "_$zcvt($tr(nurseno," ",""),"U"),""))
		q:rowid="" ""
		s Obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
		s nursename=Obj.PerName
		s SSUID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt($tr(nurseno," ",""),"U"),""))
		q:SSUID="" ""
		s SSUObj=##class(User.SSUser).%OpenId(SSUID)
		q:SSUObj.SSUSRName'=nursename ""
		s NurseGroup=SSUObj.SSUSRGroup.SSGRPDesc
		s NursePassword=##class(web.Util.Encryption).MD5HexStr(SSUObj.SSUSRPassword)
		s NurseLocDesc=SSUObj.SSUSRDefaultDeptDR.CTLOCDesc
	}
	
	q NursePassword_"^"_NurseLocDesc_"^"_NurseGroup
}

}
