Class web.DHCEQTemp Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// w ##Class(web.DHCEQTemp).RestoreReturnData()
/// 恢复退货数据,5月前的7,8,9,10,11退货记录
ClassMethod RestoreReturnData()
{
	s returnid=""
	s data=""
	 
	f  s returnid=$o(^DHCEQReturn1(returnid))  quit:returnid=""  d
	.s data=$g(^DHCEQReturn1(returnid))
	.d GeneralPLIST
	.k ^DHCEQReturn(0,"AckDateStat",PLIST(14),PLIST(9),PLIST(17),returnid)
	.k ^DHCEQReturn(0,"Provider",PLIST(4),returnid)
	.k ^DHCEQReturn(0,"ReturnNo",PLIST(2),returnid)
	.&SQL(insert into sqluser.DHC_EQReturn values :PLIST())
	.s RID=$G(%ROWID)
	.s retrunlistid=""
	.f  s retrunlistid=$o(^DHCEQReturnList1(retrunlistid))  quit:retrunlistid=""  d
	..s data=$g(^DHCEQReturnList1(retrunlistid))
	..d GeneralPLIST
	..q:PLIST(2)'=returnid
	..s PLIST(2)= RID
	..k ^DHCEQReturnList(0,"Return",PLIST(2),retrunlistid)
	..i PLIST(5)'="" k ^DHCEQReturnList(0,"Equip",PLIST(5),retrunlistid)
	..i PLIST(4)'="" k ^DHCEQReturnList(0,"InStockList",PLIST(4),retrunlistid)
	..&SQL(insert into sqluser.DHC_EQReturnList values :PLIST())
	..s RLID=$G(%ROWID)
	..&SQL(Update sqluser.DHC_EQChangeStock set CS_SourceID=:RLID Where cs_changetype=2 and cs_sourceid=:retrunlistid  and cs_changedate<'06/01/2007')
	q
GeneralPLIST
	k PLIST
	s len=$l(data,"^")
	f row=1:1:len  s PLIST(row+1)=$p(data,"^",row)
	q
}

}
