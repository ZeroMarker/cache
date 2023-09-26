/// Creator：陈莹
/// CreatDate: 2016-04-12
/// Description：收费类型
Class web.DHCBL.CT.DHCItmChargeType Extends %RegisteredObject
{

/// Creator：陈莹
/// CreatDate: 2016-04-12
/// Description：查询收费类型的数据   
/// Table：User.DHCItmChargeType
/// Input：rowid,code,desc
/// Return：ICTRowId,ICTCode,ICTDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DHCTarItem","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ICTRowId:%String,ICTCode:%String,ICTDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
 
 
	if (rowid'="") //根据rowid返回该条记录
	{
		s ICTRowId=rowid
		s ICTCode=$p($g(^DHCItmChgType(ICTRowId)),"^",1)
		s ICTDesc=$p($g(^DHCItmChgType(ICTRowId)),"^",2)
		d OutputRowCmb1
	}
	else
	{
		s:code'="" code=$ZCVT(code,"U") //转换成大写
		s:desc'="" desc=$ZCVT(desc,"U") //转换成大写   //$$ALPHAUP^SSUTIL4(desc) 
		s ICTRowId=0
		for 
		{
			s ICTRowId=$o(^DHCItmChgType(ICTRowId)) q:ICTRowId=""
  			s ICTCode=$p($g(^DHCItmChgType(ICTRowId)),"^",1)
			s ICTDesc=$p($g(^DHCItmChgType(ICTRowId)),"^",2)
			s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(ICTDesc)
			if (zcvt(ICTCode,"U")[code)&(($ZCVT(ICTDesc,"U")[desc)||(PINYIN[desc))
			{
				d OutputRowCmb1
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb1
    set Data=$lb(ICTRowId,ICTCode,ICTDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 
 Set ind=$o(^CacheTemp(repid,ind))
 If ind=""
 {
  //if there are no more rows,finish fetching...
  Set AtEnd=1
  Set Row=""
 }
 Else
 {
  Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

}
