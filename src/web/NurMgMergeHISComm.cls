/// Creator:
/// Descriptions:同步HIS信息公共类
/// Date:2017-11-22
/// 
Class web.NurMgMergeHISComm Extends %RegisteredObject
{

/// Creator:gzj
/// Description:查询人员同步信息
/// Date:2017-11-22
/// Table:
/// Input:
/// Output：
/// Return:
/// Others: d ##class(%ResultSet).RunQuery("web.NurMgMergeHISComm","FindMergeInfos")
Query FindMergeInfos(ward As %String = "", input As %String = "", nursetype As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindMergeInfosExecute(ByRef qHandle As %Binary, ward As %String = "", input As %String = "", nursetype As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsD(rowid)) q:rowid=""  d
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	.q:'$IsObject(obj)
	.q:obj.PerTypeDR'="N"
	.q:((ward'="")&&(obj.PerDepDR'=$tr(ward," ","")))
	.s nursename=obj.PerName
	.q:((input'="")&&(nursename'[$tr(input," ","")))
	.s nurseno="",hisno="",nursedep="",nursedepdr=""
	.i obj.PerTypeDR="N" d
	..s nurseno=obj.PerID
	.e  i obj.PerTypeDR="P" s nurseno=obj.PerNo
	.s nurtype=""
	.i obj.PerDepDR'="" d
	..s depobj=##class(DHCNMG.DB.MgWard).%OpenId(obj.PerDepDR)
	..i '$IsObject(depobj) s nursedep=""
	..e  d
	...s nursedep=depobj.WardDesc
	...s nursedepdr=obj.PerDepDR
	.s state=""
	.s mergeRw=$O(^DHCNMG.DB.MgMergeHisInfoI("ssid"," "_rowid,""))
	.i mergeRw'="" d
	..s mergeObj=##class(DHCNMG.DB.MgMergeHisInfo).%OpenId(mergeRw)
	..i mergeObj.MergeType="Y" d
	...s state="HIS用户"
	...s nurtype="Y"
	..;e  s state="本地用户"
	..s hisno=mergeObj.MergeHISNo
	.e  d
	..s nurtype="N"
	..s state="本地用户"
	..s hisno=obj.HISNO
	.q:(nursetype'="")&&(nurtype'=nursetype)
	.s ret="nursename|"_nursename_"^nurseno|"_nurseno_"^hisno|"_hisno_"^perrowid|"_rowid_"^state|"_state_"^hisno|"_hisno_"^nursedep|"_nursedep_"^nursedepdr|"_nursedepdr
	.do OutputMergeInfos
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputMergeInfos
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindMergeInfosFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMergeInfosExecute ]
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

ClassMethod FindMergeInfosClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMergeInfosExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:gzj
/// Description:获取同步人员信息
/// Date:2018-06-30
/// Input:
/// Output:
/// Table:
/// Other:
ClassMethod GetMergeNurseInfo(rowid As %String) As %String
{
	s ^TMP("mergenurseinfo")=rowid
	s ret=""
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	q:'$IsObject(obj) ""
	s nursecardno=$zcvt($tr(obj.PerCardId," ",""),"U") //获取身份证号码
	s hgname=$tr(obj.PerName," ","")
	s hgHISNO=obj.HISNO
	s hgdepdesc=""
	s hgnursedep=""
	s dep=obj.PerDepDR
	i dep'="" d
	.s wardobj=##class(DHCNMG.DB.MgWard).%OpenId(dep)
	.s hgdepdesc=wardobj.WardDesc
	.i wardobj.CTLocDR'="" d
	..s hgnursedep=wardobj.CTLocDR.%Id()
	
	s defaultdep="",username="",defaultdepdesc=""
	i hgHISNO'="" d
	.s userid=$O(^SSU("SSUSR",0,"SSUSR_Initials",$zcvt(hgHISNO,"U"),""))
	.i userid'="" d
	..s userobj=##class(User.SSUser).%OpenId(userid)
	..s defaultdep=userobj.SSUSRDefaultDeptDR.%Id()
	..s defaultdepdesc=userobj.SSUSRDefaultDeptDR.CTLOCDesc
	..s username=$tr(userobj.SSUSRName," ","")
	s ret="hisno|"_hgHISNO_"^hgname|"_hgname_"^hgdepdesc|"_hgdepdesc_"^hisname|"_username_"^hisdepdesc|"_defaultdepdesc_"^nurseid|"_rowid
	;i ((name=username)&&(nursedep=defaultdep)) d
	;.s ret="hisno|"_HISNO_"^hisname|"_username
	;s ret=..GetHISNurseInfo(nursecardno)_"^nurseid|"_rowid
	q ret
}

ClassMethod GetHISNurseInfo(identify As %String) As %String
{
	///安贞医院护管工号和HIS工号一致 此处取工号
	s RowID=$O(^SSU("SSUSR",0,"SSUSR_Initials",identify,""))
	q:RowID="" ""
	s obj=##class(User.SSUser).%OpenId(RowID)
	s name=obj.SSUSRName
	s hisno=obj.SSUSRInitials
	s ret="^hisname|"_name_"^hisno|"_hisno
	q ret
}

ClassMethod IsCheckInfo(nurseid As %String, hisname As %String, hisno As %String) As %String
{
	;s ^TMP("ischeckinfo")=nurseid_"%"_hisname_"%"_hisno
	s ret=0
	q:nurseid="" 0
	s obj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
	q:'$IsObject(obj) 0
	s nursename=obj.PerName
	i nursename=hisname s ret=1
	q ret
}

ClassMethod SaveMergeNurseInfo(parr As %String) As %String
{
	;s ^TMP("savemergeparr")=parr //MergeNurseID|1^MergeHISNo|LIAOL
	s tmp=""
	s aa=##class(web.NurMgVueComm).SplitStr(parr,"^","|",.tmp)
	s nurseid=tmp("MergeNurseID")
	s hisno=tmp("MergeHISNo")
	s rowid=$O(^DHCNMG.DB.MgMergeHisInfoI("ssid"," "_nurseid,""))
	i rowid="" s obj=##class(DHCNMG.DB.MgMergeHisInfo).%New()
	e  s obj=##class(DHCNMG.DB.MgMergeHisInfo).%OpenId(rowid)
	s obj.MergeHISNo=hisno
	s obj.MergeNurseID=nurseid
	s obj.MergeType="Y"
	s sc=obj.%Save()
	i $$$ISOK(sc)=1
	{
		s PerObj=##class(DHCNMG.HR.MgPersons).%OpenId(nurseid)
		i PerObj.HISNO="" s PerObj.HISNO=hisno
		s psc=PerObj.%Save()
		i $$$ISOK(psc)=1
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
		tro
	}
}

ClassMethod IsMergeFlag(nurseid As %String) As %String
{
	s ret=""
	s rowid=$O(^DHCNMG.DB.MgMergeHisInfoI("ssid"," "_nurseid,""))
	q:rowid="" ""
	s obj=##class(DHCNMG.DB.MgMergeHisInfo).%OpenId(rowid)
	s ret=obj.MergeType
	q ret
}

Query FindHISUSER(ward As %String = "", input As %String = "", nursetype As %String = "") As %Query(ROWSPEC = "aa")
{
}

ClassMethod FindHISUSERExecute(ByRef qHandle As %Binary, ward As %String = "", input As %String = "", nursetype As %String = "") As %Status
{
	s ^TMP("FindHISUSER")=ward_"%"_input_"%"_nursetype
	s repid=$I(^CacheTemp)
	s ind=1
	s ret=""
	
	s rowid="" f  s rowid=$O(^DHCNMG.HR.MgPersonsD(rowid)) q:rowid=""  d
	.s nursename="",hisno="",nurseid="",HISName="",HISNO=""
	.s obj=##class(DHCNMG.HR.MgPersons).%OpenId(rowid)
	.q:obj.PerTypeDR'="N"
	.
	.s nursename=obj.PerName
	.s nurseid=obj.PerID
	.s hisno=obj.HISNO
	.s ward=obj.PerDepDR
	.s warddesc=""
	.i ward'="" d
	..s WardObj=##class(DHCNMG.DB.MgWard).%OpenId(ward)
	..s warddesc=WardObj.WardDesc
	.s rw=$O(^DHCNMG.DB.MgMergeHisInfoI("HIS"," "_hisno,""))
	.q:rw'=""
	.s RowID=$O(^SSU("SSUSR",0,"SSUSR_Initials",hisno,""))
	.i RowID'="" d
	..s UOBJ=##class(User.SSUser).%OpenId(RowID)
	..s HISName=UOBJ.SSUSRName
	..s HISNO=UOBJ.SSUSRInitials
	.s ret=warddesc_":"_nursename_":"_nurseid_":"_hisno_":"_HISName_":"_HISNO
	.do OutputMergeInfos
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputMergeInfos
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHISUSERFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHISUSERExecute ]
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

ClassMethod FindHISUSERClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHISUSERExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
