/// Creator: 阮成林
/// CreatDate: 2011-3-2
/// Description: 
Class dhc.bonus.report.uBonusSubExpendRate Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// other:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusTargetCollect","GetScheme")
Query GetItemType() As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT BonusSubItemID,SubItemName FROM dhc_bonus_subs.BonusSubItem where LastStage=0 and IsValid=1
}

ClassMethod GetSubExpendRateInfoExecute(ByRef qHandle As %Binary, itemType As %String, subitemcode As %String, subitemname As %String) As %Status
{
	n (qHandle,itemType,subitemcode,subitemname)
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select SuperiorItemID->SubItemName as ItemName,SubItemCode,b.SubItemName,(CalculateRate*a.ItemPrice) as CalculateRate,(ExecuteRate*a.ItemPrice) as ExecuteRate"
	s sqlStr =sqlStr_"  from dhc_bonus_subs.BonusSubExpendRate a,dhc_bonus_subs.BonusSubItem b"
	s sqlStr =sqlStr_" where a.BonusSubItem ='D' _ b.BonusSubItemID and b.IsValid=1 and BonusUnit='G1' "
	
	 
	i itemType'="" s sqlStr =sqlStr_"  and b.SuperiorItemID= '"_itemType_"' "
	i subitemcode'="" s sqlStr = sqlStr_" and SubItemCode like '%"_subitemcode_"%'"
	i subitemname'="" s sqlStr = sqlStr_" and subitemname like '%"_subitemname_"%'"
	d result.Prepare(sqlStr)
	d result.Execute()
	;s ^lwhhhh=itemType
    ;w sqlStr,!
	;s whouseName=""
	While(result.Next()){
	s itemname=result.Data("ItemName")	
	s subitemcode = result.Data("SubItemCode")
	s subitemname=result.Data("SubItemName")
	s calculaterate = $fn(result.Data("CalculateRate"),"",2)
	s executerate=$fn(result.Data("ExecuteRate"),"",2)
	s summ =calculaterate+executerate
	i summ > 0 d
	.d OutputSubExpendRateInfo
	}
	d result.Close()
	/**
	i userDr'="" d
	.i $D(^SSU("SSUSR",userDr)) d
	..i $G(^SSU("SSUSR",userDr))'="" d
	...s userName=$P(^SSU("SSUSR",userDr),"^",2)
	**/
 	q $$$OK
OutputSubExpendRateInfo
	
 	s Data=$lb(itemname,subitemcode,subitemname,calculaterate,executerate)
 	s ^CacheTemp(repid,ind)=Data	
 	s ind=ind+1
	q
}

ClassMethod GetSubExpendRateInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSubExpendRateInfoExecute ]
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

ClassMethod GetSubExpendRateInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSubExpendRateInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Others:d ##class(%ResultSet).RunQuery("dhc.bonus.report.uBonusSubExpendRate","GetSubExpendRateInfo","","","")
Query GetSubExpendRateInfo(itemType As %String, subitemcode As %String, subitemname As %String) As %Query(ROWSPEC = "itemname:%String,subitemcode:%String,subitemname:%String,calculaterate:%Float,executerate:%Float") [ SqlProc ]
{
}

Storage Default
{
<StreamLocation>^dhc.bonus.r64E.uBonusSubExp796S</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
