/// 创建:zy 2010-08-03    No ZY0026
/// ----------------------------------
Class web.DHCEQDepreSetDetail Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 10;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "DSD_RowID";

Parameter SQLDESCRIPTION = "DSD_RowID";

Parameter SQLROWID = "DSD_RowID";

Query DepreSetDetail(DepreSetDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TExceedFlag:%String,TFromYear:%String,TToYear:%String,TRate:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod DepreSetDetailExecute(ByRef qHandle As %Binary, DepreSetDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetDepreSetDetail
	Quit $$$OK
BuildDataGetDepreSetDetail
	q:DepreSetDR=""
	f  s rowid=$o(^DHCEQDepreSetDetail(0,"DepreSet",DepreSetDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetDepreSetDetail
	.s TRowID = rowid										//rowid
	.s TExceedFlag=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDepreSetDetail(rowid)),"^",2) ,"bool")
	.s TFromYear=$p($g(^DHCEQDepreSetDetail(rowid)),"^",3) 
	.s TToYear=$p($g(^DHCEQDepreSetDetail(rowid)),"^",4) 
	.s TRate=$p($g(^DHCEQDepreSetDetail(rowid)),"^",5)_"%"
	.s THold1=$p($g(^DHCEQDepreSetDetail(rowid)),"^",6) 
	.s THold2=$p($g(^DHCEQDepreSetDetail(rowid)),"^",7) 
	.s THold3=$p($g(^DHCEQDepreSetDetail(rowid)),"^",8) 
	.s THold4=$p($g(^DHCEQDepreSetDetail(rowid)),"^",9) 
	.s THold5=$p($g(^DHCEQDepreSetDetail(rowid)),"^",10) 
	.d OutputRowGetDepreSetDetail
	quit
OutputRowGetDepreSetDetail
    s Data=$lb(TRowID,TExceedFlag,TFromYear,TToYear,TRate,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDepreSetDetail
	s (TRowID,TExceedFlag,TFromYear,TToYear,TRate,THold1,THold2,THold3,THold4,THold5)=""
	quit
	Quit $$$OK
}

ClassMethod DepreSetDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DepreSetDetailExecute ]
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

ClassMethod DepreSetDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DepreSetDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDepreSetDetailByID(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQDepreSetDetail(rowid)
	s resultex=resultex_"^"	//设备2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",2),"bool")
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

ClassMethod SaveData(val As %Library.String = "", vtype As %Library.String = "")
{
	new (val,vtype)
 	s rowid=$p(val,"^",1)
 	s ExceedFlag=##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",3),"bool")
 	if (+vtype=1)  //删除
 	{
 		&SQL(Delete From SQLUSER.DHC_EQDepreSetDetail where DSD_RowID= :rowid)
 		if SQLCODE  q SQLCODE
 		q rowid
 	}
 	elseif  (+vtype=0)  //更新
 	{
 		s PLIST(2) = $p(val,"^",2)				;DepreSetDR
 		s PLIST(3) = ExceedFlag					;超年限
 		s PLIST(4) = $p(val,"^",4)				;开始年
 		s PLIST(5) = $p(val,"^",5)				;结束年
 		s PLIST(6) = $p(val,"^",6)				;月折旧率
 		s PLIST(7) = $p(val,"^",7)				;hold1
 		s PLIST(8) = $p(val,"^",8)				;hold2
 		s PLIST(9) = $p(val,"^",9)				;hold3
 		s PLIST(10) = $p(val,"^",10)			;hold4
 		s PLIST(11) = $p(val,"^",11)			;hold5
 		if (rowid'="")
 		{
 			&SQL(Update SQLUSER.DHC_EQDepreSetDetail Values :PLIST() where DSD_RowID = :rowid)
 		}
 		else
 		{
			&SQL(Insert Into SQLUSER.DHC_EQDepreSetDetail Values :PLIST())
 		}	
	}
 	if SQLCODE  q SQLCODE
 	Set ID=$g(%ROWID)
 	q ID
}

}
