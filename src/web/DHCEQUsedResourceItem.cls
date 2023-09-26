Class web.DHCEQUsedResourceItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetDetailList(UsedResourceDR) As %SQLQuery(ROWSPEC = "TRowID:%String,TResourceType:%String,TUsedFee:%String,TRemark:%String,TResourceTypeDR:%String")
{
	select URI_RowID TRowID,
		   URI_ResourceTypeDR->RT_Desc TResourceType,
		   URI_UsedFee TUsedFee,
		   URI_Remark TRemark,
		   URI_ResourceTypeDR TResourceTypeDR
	from sqluser.DHC_EQUsedResourceItem
	where URI_UsedResourceDR=:UsedResourceDR
}

/// -------Detail Sql method[typeStr: 0-add,1-update,2-del]
ClassMethod DetailExecSql(typeStr As %Library.String = "", recordID As %Library.String = "", valStr As %Library.String = "", UsedResourceID)
{
 s errMsg="" ,sqlStr=""
 s Rowid=0
 s URID=""
 TSTART
 i typeStr="0"
 {
	s PLIST(2)=$p(valStr,"^",1)
 	s PLIST(3)=$p(valStr,"^",2)
 	s PLIST(4)=$p(valStr,"^",3)
 	s PLIST(5)=$p(valStr,"^",4)
 	s URID=PLIST(2)
 	&SQL(insert into SqlUser.DHC_EQUsedResourceItem values :PLIST())
 }
 i typeStr="1"
 {
	s PLIST(3)=$p(valStr,"^",1)
 	s PLIST(4)=$p(valStr,"^",2)
 	s PLIST(5)=$p(valStr,"^",3)
 	&SQL(update SqlUser.DHC_EQUsedResourceItem values :PLIST() where URI_RowID=:recordID)
 	s URID=$P(^DHCEQUsedResourceItem(recordID),"^",1)
 }
 i typeStr="2"
 {
	 s URID=$P(^DHCEQUsedResourceItem(recordID),"^",1)
	 &SQL(delete from SqlUser.DHC_EQUsedResourceItem where URI_RowID=:recordID)
 }
 i SQLCODE
 {
	 TROLLBACK
	 q "操作没有成功"
 }
 s SQLCODE=..UpdateTotalFee(URID)
 i SQLCODE
 {
	 TROLLBACK
	 q "操作没有成功"
 }
 TCOMMIT
 q SQLCODE
}

ClassMethod UpdateTotalFee(UsedResourceDR)
{
	s TotalFee=0
	;&SQL(select sum(URI_UsedFee) into :TotalFee from sqluser.DHC_EQUsedResourceItem where URI_UsedResourceDR=:UsedResourceDR)
	i TotalFee="" s TotalFee=0
	;&SQL(update sqluser.DHC_EQUsedResource set UR_TotalFee=:TotalFee where UR_RowID=:UsedResourceDR)
	q SQLCODE
}

}
