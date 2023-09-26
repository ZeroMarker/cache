Class web.DHCDocDataChangeApplyLog Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// desc			插入/更新DHC_DocDataChangeApply表记录,状态改变调用的触发程序
/// date			2013.09.22
ClassMethod OnTrigger(parref As %String, type As %String) As %Status
{
	b //66
	s rtn=1
	s ParObj=##class(User.DHCDocDataChangeApply).%OpenId(parref)
	if $ISOBJECT(ParObj) {
		s ApplyStatus=ParObj.ApplyStatus
		s ApplyUserDr=ParObj.ApplyUserDrGetObjectId()
		s param=parref_"^"_ApplyStatus_"^"_ApplyUserDr
		s rtn=..Insert(param)
		i rtn=0 s rtn=1
		else  s rtn="ERROR"_rtn
	}
	Q rtn
}

ClassMethod Insert(insertinfo)
{
 s DCAParRef=$p(insertinfo,"^",1)
 i DCAParRef="" Q -1
 s ApplyStatus=$p(insertinfo,"^",2)
 s ApplyUserDr=$p(insertinfo,"^",3)
 s DCADate=$P($H,",",1)
 s DCATime=$P($H,",",2)
 TStart
   &sql(insert into sqluser.DHC_DocDataChangeApplyLog(DCA_ParRef,DCA_Date,DCA_Time,DCA_Status,DCA_UpUserID) 
   values(:DCAParRef,:DCADate,:DCATime,:ApplyStatus,:ApplyUserDr))
   i SQLCODE=0 D
	.TCommit  
   e  d
	.Trollback
   Q SQLCODE
}

}
