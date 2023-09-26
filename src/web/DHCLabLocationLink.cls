/// 名称:     web.DHCLabLocationLink
/// 描述:     危急报告关联科室查询
/// 编写者：  huhm
/// 编写日期: 20120710
Class web.DHCLabLocationLink Extends %RegisteredObject
{

Query GetLinkLocation(Loc As %String) As %Query(ROWSPEC = "LnkLocID:%String,LnkLocCode:%String,LnkLocName:%String")
{
}

ClassMethod GetLinkLocationExecute(ByRef qHandle As %Binary, Loc As %String) As %Status
{
 	Set Loc=$Get(Loc)
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	If '$Length(Loc) Set qHandle=$lb(0,repid,0)	 Quit $$$OK	
	If '$d(^DHCLABCTLOCLINK(Loc)) Set qHandle=$lb(0,repid,0) Quit $$$OK	
	//^DHCLABCTLOCLINK(1,2)
	s LnkId="" f  s LnkId=$o(^DHCLABCTLOCLINK(Loc,LnkId)) q:LnkId=""  d
	.//	^CTLOC(44)	=	"妇产科门诊^FCKMZ-妇产科门诊
	.s Code=$p(^CTLOC(LnkId),"^",1)
	.s Name=$p(^CTLOC(LnkId),"^",2)
	.d OutputRow
	//
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK
OutputRow
	set Data=$lb(LnkId,Code,Name)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLinkLocationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLinkLocationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)	
	Quit $$$OK
}

ClassMethod GetLinkLocationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLinkLocationExecute ]
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

//未关联科室

ClassMethod GetNoLinkLocation(Loc As %String) As %String
{
 	Set Loc=$Get(Loc)
 	s ^TMPSaveLoc(1)=Loc
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set RetStr=""
	If '$Length(Loc) Quit ""
	s LocFromId=$o(^CTLOC(0,"Desc",$zcvt($tr(Loc,"-"),"U"),""))
	s LocId="" f  s LocId=$o(^CTLOC(LocId)) q:LocId=""  d
	.i $d(^DHCLABCTLOCLINK(LocFromId,LocId)) q
	.s ActiveFlag=$p(^CTLOC(LocId),"^",14)
	.i ActiveFlag="N" q
	.s Type=$p(^CTLOC(LocId),"^",13)
	.i Type'="E" q
	.s Name=$p(^CTLOC(LocId),"^",2)
	.s RetStr=RetStr_LocId_"!"_Name_"^"
	s RetStr=$p(RetStr,"^",1,$l(RetStr,"^")-1)
	q RetStr
}

ClassMethod GetLocation(Loc As %String) As %String
{
	//s ^TMPSaveLoc(3)=Loc
	s LocFromId=$o(^CTLOC(0,"Desc",$zcvt($tr(Loc,"-"),"U"),""))
	s RetStr=""
	s LnkId="" f  s LnkId=$o(^DHCLABCTLOCLINK(LocFromId,LnkId)) q:LnkId=""  d
	.//	^CTLOC(44)	=	"妇产科门诊^FCKMZ-妇产科门诊
	.s Code=$p(^CTLOC(LnkId),"^",1)
	.s Name=$p(^CTLOC(LnkId),"^",2)
	.s RetStr=RetStr_LnkId_"!"_Name_"^"
	s RetStr=$p(RetStr,"^",1,$l(RetStr,"^")-1)
	q RetStr
}

ClassMethod SaveLocation(LocFrom As %String, LocTo As %String) As %String
{
	i '$l(LocFrom) q "100"
	i '$l(LocTo) q "100"
	s LocFromId=$o(^CTLOC(0,"Desc",$zcvt($tr(LocFrom,"-"),"U"),""))
	i '$l(LocFromId) q "101"
	s ^TMPSaveLoc(2)=LocFrom_","_LocTo_","_LocFromId
	Set obj = ##class(User.DHCLabCTLocLink).%New()
	Set obj.DLCLLocDR=LocFromId
	Set obj.DLCLLinkLocDR=LocTo
    Set RetValue = obj.%Save()
	q RetValue
}

ClassMethod DeleteLocation(LocFrom As %String, LocTo As %String) As %String
{
	i '$l(LocFrom) q "100"
	i '$l(LocTo) q "100"
	s LocFromId=$o(^CTLOC(0,"Desc",$zcvt($tr(LocFrom,"-"),"U"),""))
	i '$l(LocFromId) q "101"
	s ^TMPSaveLoc(3)=LocFrom_","_LocTo_","_LocFromId
	If '$d(^DHCLABCTLOCLINK(LocFromId,LocTo)) q 1
	Set id=LocFromId_"||"_LocTo
	Set RetValue=##class(User.DHCLabCTLocLink).%DeleteId(id)
	q RetValue
}

/// Creator：      huhm
/// CreatDate：    20120904
/// Description:： 保存客户端IP地址
/// Table：        DHC_LabCTIP
/// Input：        IP地址
/// Output：       0:成功,非0:失败
/// Return：        
/// Others：        其它说明
ClassMethod SaveIP(IP As %String) As %String
{
	i $d(^DHCLabCTIP(0,"IP",IP)) q 1
	Set obj = ##class(User.DHCLabCTIP).%New()
	Set obj.DLIPIPAddress=IP
	Set obj.DLIPDate=$p($h,",",1)
	Set obj.DLIPTime=$p($h,",",2)
	Set obj.DLIPSequence=$o(^DHCLabCTIP(0,"SEQ",""),-1)+1
    Set RetValue = obj.%Save()
    Quit RetValue
}

//65,535 

/// Creator：      huhm
/// CreatDate：    20120910
/// Description:： 间隔时间
/// Table：        
/// Input：        
/// Output：       间隔时间(单位:S)
/// Return：        
/// Others：      最小为5S,最大为65S
ClassMethod Interval(ip As %String) As %String
{
	s RetVal=5
	Quit RetVal
}

}
