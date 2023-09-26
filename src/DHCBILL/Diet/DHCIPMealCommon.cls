Import sqluser

/// DHCBILL.Diet.DHCIPMealCommon.cls
/// 工具类
/// Lid
/// 2010-05-14
Class DHCBILL.Diet.DHCIPMealCommon Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 根据给定日期计算该日期下周某天的日期
/// Lid
/// 2010-05-14
/// flag:"F"上一周，"L"本周，"N"下一周，默认是"N"
/// date:给定日期,默认是当前日期
/// week:要算星期几的日期,默认是周一
ClassMethod getWeedDateByDate(flag As %String = "", date As %String = "", week As %String = "")
{
	;w ##class(DHCBILL.Diet.DHCIPMealCommon).getWeedDateByDate()
    i flag="" s flag="N"
    i date["-" s date=$zdh(date,3)
    i date="" s date=+$h
    i week="" s week=1
    s m=0
    s currentWeek=$zd(date,10)
    i currentWeek=0 s currentWeek=7  ;习惯把周日看做一周的最后一天
    i flag="N" s m=7-currentWeek+week
    i flag="F" s m=-currentWeek-7+week
    i flag="L" s m=-currentWeek+week
    s rtnDate=date+m
    
    q rtnDate
}

/// Creator:yyx
/// CreateDate:2010-05-17
/// Function  :当前病区显示
ClassMethod FindPacWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPacWardExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPacWardExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
    s WardDesc="",WardID=""
    d OutputRow
    s WardID=0
    f  s WardID=$o(^PAWARD(WardID)) q:(WardID="")!(WardID="BED_BedType_DR")  d
    .s WardDesc=$p($p(^PAWARD(WardID),"^",2),"-",2)
    .d OutputRow
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
	set Data=$lb(WardDesc,WardID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindPacWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPacWardExecute ]
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
	Quit $$$OK
}

Query FindPacWard() As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

/// @Author:wanghc
/// @find ward by pingyin
Query FindWardDescByCode(Code As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "rowid:%String,desc:%String")
{
	
	Select Ward_rowid , Ward_Code  from PAC_Ward where Ward_Desc %STARTSWITH  :Code
}

//;(ARCIM_GenericDesc %STARTSWITH  :Code) and

/// d ##class(%ResultSet).RunQuery("DHCBILL.Diet.DHCIPMealCommon","FindItmMastDescByCode","","147")
Query FindItmMastDescByCode(Code As %String = "", itemCatRowid As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "rowid:%String,desc:%String")
{
	Select distinct ARCIM_rowid , ARCIM_Desc  
	from ARC_ItmMast,ARC_Alias 
	where (ALIAS_ARCIM_DR=ARCIM_rowid) 
	and (alias_text %STARTSWITH :Code) 
	and ((ARCIM_ItemCat_DR=147) or (ARCIM_ItemCat_DR=200)) 
	and (((ARCIM_EffDateTo='')or(ARCIM_EffDateTo is null)) or (ARCIM_EffDateTo>={fn CURDATE()}))
}

Query FindMealUserDescByCode(Code As %String = "") As %SQLQuery(CONTAINID = 1, ROWSPEC = "rowid:%String,desc:%String")
{
	Select ssusr_rowid , ssusr_Name
	from ss_user
	where ssusr_group=76 and ((ssusr_initials %STARTSWITH :Code) or (ssusr_name %STARTSWITH :Code ))
}

}
