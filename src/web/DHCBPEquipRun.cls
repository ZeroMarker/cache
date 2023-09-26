Import SQLUser

Class web.DHCBPEquipRun Extends (%RegisteredObject, %XML.Adaptor) [ Inheritance = right ]
{

/// 插入数据
/// 参数
/// w ##class(web.DHCBPEquipRun).InsertBPEquipRun("1^2014-01-01^11:01:01^2014-10-110^11:11:11^把手^1^^^")
ClassMethod InsertBPEquipRun(BPEquipRunInfo) As %String
{
	q:BPEquipRunInfo="" "数据为空，请重新输入"
	k PLIST
	s PLIST(2)=$p(BPEquipRunInfo,"^",1)
	s tStartDate=$p(BPEquipRunInfo,"^",2)
	s PLIST(3)=##class(web.DHCANOPCom).ConvertToDateH(tStartDate)
	s tStartTime=$p(BPEquipRunInfo,"^",3)
	s PLIST(4)=##class(web.DHCANOPCom).ConvertToTimeH(tStartTime)
	s tEndDate=$p(BPEquipRunInfo,"^",4)
	s PLIST(5)=##class(web.DHCANOPCom).ConvertToDateH(tEndDate)
	s tEndTime=$p(BPEquipRunInfo,"^",5)
	s PLIST(6)=##class(web.DHCANOPCom).ConvertToTimeH(tEndTime)
	s PLIST(7)=$p(BPEquipRunInfo,"^",6)
	s PLIST(8)=$p(BPEquipRunInfo,"^",7)
	s tUpdateDate=$p(BPEquipRunInfo,"^",8)
	s PLIST(9)=##class(web.DHCANOPCom).ConvertToDateH(tUpdateDate)
	s tUpdateTime=$p(BPEquipRunInfo,"^",9)
	s PLIST(10)=##class(web.DHCANOPCom).ConvertToTimeH(tUpdateTime)
	//s result=$o(^DHCBPDetection())
	&SQL(insert into DHC_BP_EquipRun Values :PLIST())
	q SQLCODE
}

ClassMethod UpdateBPEquipRun(BPEquipRunInfo) As %String
{
	q:BPEquipRunInfo="" "数据为空，请重新输入"
	k PLIST
	s tRowid=$p(BPEquipRunInfo,"^",1)
	q:tRowid="" "请选中一行要修改的数据"
	s PLIST(2)=$p(BPEquipRunInfo,"^",2)
	s tStartDate=$p(BPEquipRunInfo,"^",3)
	s PLIST(3)=##class(web.DHCANOPCom).ConvertToDateH(tStartDate)
	s tStartTime=$p(BPEquipRunInfo,"^",4)
	s PLIST(4)=##class(web.DHCANOPCom).ConvertToTimeH(tStartTime)
	s tEndDate=$p(BPEquipRunInfo,"^",5)
	s PLIST(5)=##class(web.DHCANOPCom).ConvertToDateH(tEndDate)
	s tEndTime=$p(BPEquipRunInfo,"^",6)
	s PLIST(6)=##class(web.DHCANOPCom).ConvertToTimeH(tEndTime)
	s PLIST(7)=$p(BPEquipRunInfo,"^",7)
	s PLIST(8)=$p(BPEquipRunInfo,"^",8)
	s tUpdateDate=$p(BPEquipRunInfo,"^",9)
	s PLIST(9)=##class(web.DHCANOPCom).ConvertToDateH(tUpdateDate)
	s tUpdateTime=$p(BPEquipRunInfo,"^",10)
	s PLIST(10)=##class(web.DHCANOPCom).ConvertToTimeH(tUpdateTime)
	&SQL(update DHC_BP_EquipRun Values :PLIST() where BPER_RowId=:tRowid)
	q SQLCODE
}

ClassMethod DeleteBPEquipRun(rowid)
{
	q:rowid="" "请选择一条数据"
	&SQL(delete from DHC_BP_EquipRun where BPER_RowId=:rowid)
	q SQLCODE
}

/// 查询血液透析设备运行的基本信息
/// d ##class(%ResultSet).RunQuery("web.DHCBPEquipRun","FindBPEquipRun")
/// return 显示列表 系统id：设备指针：设备描述：开始日期：开始时间：结束日期：结束时间：备注：用户名id
Query FindBPEquipRun() As %Query(ROWSPEC = "tRowId:%String,tDBPCEquipDr:%String,tDBPCEquipDesc:%String,StartDate:%String,StartTime:%String,EndDate:%String,EndTime:%String,Note:%String,UserID:%String")
{
}

ClassMethod FindBPEquipRunExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tBPERowId=0
	for  s tBPERowId=$o(^DHCBPEquipRun(tBPERowId)) q:tBPERowId=""  d
	.s tDBPCEquipDr=$lg(^DHCBPEquipRun(tBPERowId),1)
	.s tDBPCEquipDesc=$lg(^DHCBPC("Equip",tDBPCEquipDr),3) 
	.s tStartDate=$lg(^DHCBPEquipRun(tBPERowId),2)
	.s tStartDate=##class(web.DHCANOPCom).ConvertToDate(tStartDate)
	.s tStartTime=$lg(^DHCBPEquipRun(tBPERowId),3)
	.s tStartTime=##class(web.DHCANOPCom).ConvertToTime(tStartTime)
	.s tEndDate=$lg(^DHCBPEquipRun(tBPERowId),4)
	.s tEndDate=##class(web.DHCANOPCom).ConvertToDate(tEndDate)
	.s tEndTime=$lg(^DHCBPEquipRun(tBPERowId),5)
	.s tEndTime=##class(web.DHCANOPCom).ConvertToTime(tEndTime)
	.s tNote=$lg(^DHCBPEquipRun(tBPERowId),6)
	.s tUserId=$lg(^DHCBPEquipRun(tBPERowId),7)
	.d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tBPERowId,tDBPCEquipDr,tDBPCEquipDesc,tStartDate,tStartTime,tEndDate,tEndTime,tNote,tUserId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindBPEquipRunFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBPEquipRunExecute ]
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

ClassMethod FindBPEquipRunClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBPEquipRunExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

}
