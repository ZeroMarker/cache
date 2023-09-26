Class web.DHCNurEmrComm Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

//根据打印模板取界面模板

// w ##class(web.DHCNurEmrComm).getlinkcode("DHCNurMoudPrn_GX_HLJL")

ClassMethod getlinkcode(PrintCode As %String) As %String
{
	s code=$zcvt(PrintCode,"U")
	s id=$o(^User.DHCNURMoudelLinkI("PrintCode"," "_code,""))
	s ret=""
	b ;
	i id'=""  d
	.s a=##class(User.DHCNURMoudelLink).%OpenId(id)
	.s name=a.Name
	.s code=a.Code
	.s type=a.typ
	.s ret=name_"^"_code_"^"_type
	q ret
}

//关联界面模板和打印模板

// w ##class(web.DHCNurEmrComm).Save(^objcyfddd)

ClassMethod Save(parr As %String, id As %String) As %String
{
	s ^objcyfddd=parr
	s aa=##class(web.DHCMGNurComm).settmp(parr,.tmp)
	q:$g(tmp("Code"))="" "界面模板关键字不能为空"
	s rw=""
	s code=$zcvt(tmp("PrintCode"),"U")
	i id="" s id=$o(^User.DHCNURMoudelLinkI("PrintCode"," "_code,""))
	//q:rw'="" "该界面模板已经保存过"
	q:$g(tmp("PrintCode"))="" "打印模板关键字不能为空"
	q:$g(tmp("typ"))="" "类型不能为空"
	q:$g(tmp("Name"))="" "模板名称不能为空"
	if id=""
	{
	 s a=##class(User.DHCNURMoudelLink).%New()
	}else
	{
	 s a=##class(User.DHCNURMoudelLink).%OpenId(id)
	}
	if $D(tmp("Code")) s a.Code=tmp("Code")
	if $D(tmp("PrintCode")) s a.PrintCode=tmp("PrintCode")
	if $D(tmp("typ")) s a.typ=tmp("typ")
	if $D(tmp("MakePic")) s a.MakePic=tmp("MakePic")
	if $D(tmp("Upload")) s a.Upload=tmp("Upload")
	if $D(tmp("Name")) s a.Name=tmp("Name")
	//if $g(tmp("XuFlag"))="" s a.XuFlag="N"
	//else  s a.XuFlag=tmp("XuFlag")
	s a.RECDate=$p($h,",",1)
	s a.RECTime=$p($h,",",2)
	//s a.UserREC=%session.Get("LOGON.USERNAME")
	d a.%Save()
	q 0
}

//w ##class(%ResultSet).RunQuery("web.DHCNurEmrComm","GetKnCodeDep","")

ClassMethod GetKnCodeDepExecute(ByRef qHandle As %Binary, loc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	//s parr="2^2010-04-10^2010-04-20^WinTmpver211itm21fold2NOD"
 	//s dep=parr
 	s ^oiiei=loc
 	if loc=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
    s rw="" f  s rw=$O(^NurEmr.KnowledgeLocI("Loc"," "_loc,rw)) q:rw=""  d
   .s a=^NurEmr.KnowledgeLocD(rw)
   .s code=$list(a,3)
   .s flag=$listget(a,4)
   .if flag=""  s flag="false"
   .if flag="Y" s flag="true"
   .if flag="N" s flag="false"
   .s depdes=$P($G(^CTLOC(loc)),"^",2)
   .s id=##class(NurEmr.NurEmrSub).getId(code)
   .s knname=""
   .if id'="" d
   ..s b=##class(NurEmr.NurEmrSub).%OpenId(id)
   ..s knname=b.EmrSubDesc
   .s kncode=code
   .d OutRowtyp
   
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowtyp
	set Data=$lb(depdes,knname,kncode,loc,flag,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetKnCodeDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKnCodeDepExecute ]
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

ClassMethod GetKnCodeDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKnCodeDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query GetKnCodeDep(parr As %String) As %Query(ROWSPEC = "depdes,knname,kncode,depid,flag,rw")
{
}

}
