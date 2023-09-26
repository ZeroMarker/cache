/// 名称: DHCWL.MRIPDay.ZCRSExec
/// 描述: “在院在床人数核对”报表要使用的query
/// 编写者： 王峥
/// 编写日期:2014-9-29
/// d ##class(%ResultSet).RunQuery("DHCWL.MRIPDay.ZCRSExec","GetAllWardOrLoc","WARD")
Class DHCWL.MRIPDay.ZCRSExec Extends %RegisteredObject
{

/// Creator：     	王峥
/// CreatDate：   	2014-9-29
/// Description:：   得到所有科室或病区的ID和描述
/// Table：       	ct_loc,pac_ward
/// Input：          type:LOC-科室；WARD:-病区
/// Output：         typeID：科室或病区ID;typeDesc:科室或病区描述
/// Return：         
/// Others：        
Query GetAllWardOrLoc(type As %String) As %Query(ROWSPEC = "typeID:%String,typeDesc:%String") [ SqlProc ]
{
}

ClassMethod GetAllWardOrLocExecute(ByRef qHandle As %Binary, type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	//k ^TEMPDHCWL($j)
 
 	i ($g(type)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	;b
 	i type="LOC" d 				//得到科室数据
 	.s locID=0
 	.f  s locID=$o(^CTLOC(locID)) q:locID=""  d
 	..s locData=$g(^CTLOC(locID))
 	..q:locData=""
 	..s wardFlag=$p(locData,"^",5)
 	..q:$g(wardFlag)="Y"				
 	..s ctlocType=$p(locData,"^",13)
 	..q:$g(ctlocType)'="E"
 	..s typeDesc=$p(locData,"^",2)
 	..i typeDesc [ "-" s typeDesc=$p(typeDesc,"-",2) 
  	..s Data=$lb($g(locID),$g(typeDesc))
  	..d OuputRow
	e  i type="WARD" d			//得到病区数据
 	.s wardID=0
 	.f  s wardID=$o(^PAWARD(wardID)) q:wardID=""  d
 	..s wardData=$g(^PAWARD(wardID))
 	..q:wardData=""
 	..s typeDesc=$p(wardData,"^",2)
 	..i typeDesc [ "-" s typeDesc=$p(typeDesc,"-",2) 
  	..s Data=$lb($g(wardID),$g(typeDesc))
  	..d OuputRow
 
 	k ^TEMPDHCWL($j)
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK

OuputRow
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetAllWardOrLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAllWardOrLocExecute ]
{
		Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetAllWardOrLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAllWardOrLocExecute ]
{
		Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

/// Creator：     	王峥
/// CreatDate：   	2014-9-29
/// Description:：   与“在院在床人数核对-明细”表关联的query
/// Table：       	
/// Input：          startDate:开始日期；endDate:结束日期；type:LOC-科室；WARD:-病区;dimValue:科室或病区的ID
/// Output：         admID:就诊表ID,admDesc:患者姓名,ZYRS:1-存在，0-不存在；ZCRS:1-存在，0-不存在
/// Return：         
/// Others：        
Query GetZYZCDetail(startDate As %String, endDate As %String, type As %String, dimValue As %String) As %Query(ROWSPEC = "admID:%String,admDesc:%String,ZYRS:%Integer,ZCRS:%Integer,admDate:%String,disDate:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("DHCWL.MRIPDay.ZCRSExec","GetZYZCDetail","2014-9-28","2014-9-28","WARD",2)
ClassMethod GetZYZCDetailExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, type As %String, dimValue As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	k ^TEMPDHCWL($j)
 
 	i ($g(type)="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
 	s date=$zdh(startDate,3)
 	
 	//1、从dhcmripdetail中取出在院人数的就诊ID
 	s mripParRef=""
 	s stopFlag=0
 	s mripRowID=0
 	//1.1取dhcmripday的rowid
 	f  s mripRowID=$o(^MRIPdaily("MRIP_DATE",date,mripRowID))  q:((mripRowID="") || (stopFlag=1))  d
 	.s mripdailyData=$g(^MRIPdaily(mripRowID))
 	.q:mripdailyData=""
 	.s mripLocID=$p(mripdailyData,"^",7)
 	.s mripWardID=$p(mripdailyData,"^",19)
 	.i ((type="LOC") && (mripLocID=dimValue)) d
 	..s mripParRef=mripRowID
 	..s stopFlag=1
 	.i ((type="WARD") && (mripWardID=dimValue)) d
 	..s mripParRef=mripRowID
 	..s stopFlag=1
 	//1.2取dhcmripdetail中在院人数的就诊号
 	;使用索引：^DHCMRIPDetail(0,"IPType",{IPDE_MRIPDay_Dr},{IPDE_Type},{IPDE_Rowid})
 	i mripParRef'="" d
 	.s ipdeRowID=0
 	.f  s ipdeRowID=$o(^DHCMRIPDetail(0,"IPType",mripParRef,"ZYRS",ipdeRowID)) q:ipdeRowID=""  d
 	..s detailData=$g(^DHCMRIPDetail(ipdeRowID))
 	..q:detailData=""
 	..s admID=$p(detailData,"^",1)
 	..s ^TEMPDHCWL($j,"ADMID",admID)="1"
 	
 	//2、从“在床人数表”及明细表中取出在院人数的就诊ID
 	s ZCRSRowID=""
 	s ZCRSRowID=$o(^DHCWL.MRIPDay.ZCRSDefI("ZCRSDefDateIndex",date,ZCRSRowID))
 	i $g(ZCRSRowID)'="" d
 	.s ZCRSDetailRowID=0
 	.f  s ZCRSDetailRowID=$o(^DHCWL.MRIPDay.ZCRSDetailDefI("ZCRSDetailParRefIndex",ZCRSRowID,ZCRSDetailRowID)) q:ZCRSDetailRowID=""  d
	..s detailData=$g(^DHCWL.MRIPDay.ZCRSDetailDefD(ZCRSDetailRowID))
	..q:detailData=""
	..s locID=$lg(detailData,3,"")
	..s wardID=$lg(detailData,4,"")
	..q:((type="LOC") && (locID'=dimValue))
	..q:((type="WARD") && (wardID'=dimValue))	
	..s admID=$lg(detailData,2,"")
 	..s strData=$g(^TEMPDHCWL($j,"ADMID",admID))
 	..s $p(strData,"^",2)=1
 	..s ^TEMPDHCWL($j,"ADMID",admID)=strData
 	
 	//3、输出“在床在院”明细
 	s admID=""
 	f  s admID=$o(^TEMPDHCWL($j,"ADMID",admID)) q:admID=""  d
 	.s strData=$g(^TEMPDHCWL($j,"ADMID",admID))
 	.s ZYRS=$p(strData,"^",1)
 	.s ZCRS=$P(strData,"^",2)
 	.s mPapmiDr=$p($G(^PAADM(admID)),"^",1)
 	.i $g(mPapmiDr)="" s mPatName="Null"
 	.e  i '$d(^PAPER(mPapmiDr,"ALL")) s mPatName="Null"
 	.e  s mPatName=$p($G(^PAPER(mPapmiDr,"ALL")),"^",1)
 	.s admDate=$p(^PAADM(admID),"^",6)
 	.s disDate=$p(^PAADM(admID),"^",17)
 	.i $g(admDate)="" s strAdmDate=""
 	.else  s strAdmDate=$zd(admDate,3)
 	.i $g(disDate)="" s strDisDate=""
 	.else  s strDisDate=$zd(disDate,3)
 	.s Data=$lb($g(admID),$g(mPatName),+ZYRS,+ZCRS,strAdmDate,strDisDate)
  	.d OuputRow
 
 	k ^TEMPDHCWL($j)
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK

OuputRow
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetZYZCDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetZYZCDetailExecute ]
{
		Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetZYZCDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetZYZCDetailExecute ]
{
		Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
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

}
