Class web.DHCEQ.Plat.CTApproveRole Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query GetRole(Code As %String = "", Desc As %String = "", LocFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TName:%String,TRemark:%String,TLocFlagDR:%String,TLocFlag:%String")
{
}

ClassMethod GetRoleExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", LocFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s RowID=0
	f  s RowID=$o(^DHCEQCCode("DHCEQCApproveRole",RowID))  quit:RowID=""  d
	.d ResetVariablesGetRole
	.q:$p($g(^DHCEQCCode("DHCEQCApproveRole",RowID)),"^",4)="Y"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCApproveRole",RowID)),"^",1)
	.q:(Code'="")&&(TCode'[Code)
	.s TName =$p($g(^DHCEQCCode("DHCEQCApproveRole",RowID)),"^",2)
	.q:(Desc'="")&&(TName'[Desc)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCApproveRole",RowID)),"^",3)
	.s TLocFlagDR =$p($g(^DHCEQCCode("DHCEQCApproveRole",RowID)),"^",5)
	.q:(LocFlag'="")&&(TLocFlagDR'=LocFlag)
	.s TLocFlag=$CASE(TLocFlagDR,"":"","0":"所有","1":"根据权限","2":"本科","3":"本院","4":"本组","5":"本人")
	.s TRowID=RowID
	.d OutputRowGetRole
	quit $$$OK
OutputRowGetRole
	s Data=$lb(TRowID,TCode,TName,TRemark,TLocFlagDR,TLocFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRole
	s (TRowID,TCode,TName,TRemark,TLocFlagDR,TLocFlag)=""
	quit
}

ClassMethod GetRoleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRoleExecute ]
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

ClassMethod GetRoleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRoleExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录 
ClassMethod SaveRole(RowId As %String, Code As %String, Desc As %String, Remark As %String, LocFlag As %String)
{
	k PLIST,rowid
	s rowid=RowId
	s $zt="ErrorSave"
 	s TableName="DHC_EQCApproveRole"
	s ClassName="User.DHCEQCApproveRole"
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	s BussID=rowid	
	s DCRRowID=""
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	TSTART
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=Remark
	s PLIST(5)="N"
	s PLIST(6)=LocFlag
	s tmpid=""
	&SQL(select AR_RowID into :tmpid from sqluser.DHC_EQCApproveRole where AR_Code=:Code and AR_Desc=:Desc and AR_InvalidFlag='N' and AR_LocFlag=:LocFlag)
	if ((tmpid'="")&&(tmpid'=rowid)) q "-3001"	;重复记录
	
	s OldObject=##Class(User.DHCEQCApproveRole).%OpenId(BussID)
	s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
	&SQL(Update sqluser.DHC_EQCApproveRole Values :PLIST() where AR_RowID = :rowid) 
	if SQLCODE  
	{
		TRollback
		q SQLCODE
	}
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCApproveRole).%OpenId(BussID))
	
	i BussID'=""	//更新数据获取更新字段Json串
	{
		s key=""	//CZF0131 2020-01-20
		For
		{
			s value=FinalObj.GetNext(.key)
			q:key=""
			i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
		}
	}
	i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
	{
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"U",NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
		If Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
	}
	TCommit
	q SQLCODE //add by sjh SJH0041 2020-12-04
ErrorSave
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录 
ClassMethod DeleteRole(OPRRowid As %String)
{
	i (OPRRowid'="")
	{
		s $zt="ErrorDel"
 		s TableName="DHC_EQCApproveRole"
		s ClassName="User.DHCEQCApproveRole"
		s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
		s BussID=OPRRowid	//modified by sjh SJH0041 2020-12-03
		s DCRRowID=""
 		s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 		s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 		s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 		TSTART
		s OldObject=##Class(User.DHCEQCApproveRole).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

		&SQL(Update sqluser.DHC_EQCApproveRole set AR_InvalidFlag='Y' where AR_RowID = :OPRRowid)

	 	If SQLCODE
	 	{
		 	TRollback
		 	q SQLCODE
		}
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""ARInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
		TCommit
	 	Quit SQLCODE  // add by sjh SJH0041 2020-12-04
		
	}
ErrorDel
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// modified by sjh SJH0038 2020-11-10 添加数据修改日志记录 
ClassMethod AddRole(Code As %String, Desc As %String, Remark As %String, LocFlag As %String)
{
	k PLIST
	s $zt="ErrorAdd"
 	s TableName="DHC_EQCApproveRole"
	s ClassName="User.DHCEQCApproveRole"
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	s BussID=""	
	s DCRRowID=""
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	TSTART	
	
	s PLIST(2)=Code
	s PLIST(3)=Desc
	s PLIST(4)=Remark
	s PLIST(5)="N"
	s PLIST(6)=LocFlag
	s tmpid=""
	&SQL(select AR_RowID into :tmpid from sqluser.DHC_EQCApproveRole where AR_Code=:Code and AR_Desc=:Desc and AR_InvalidFlag='N')
	if (tmpid'="") q "-3001"	;重复记录
	&SQL(Insert into sqluser.DHC_EQCApproveRole Values :PLIST())
	if SQLCODE  q SQLCODE
	Set ID=$g(%ROWID)
	s NewObj.ARCode=Code
	s NewObj.ARDesc=Desc
	s NewObj.ARRemark=Remark
	s NewObj.ARInvalidFlag="N" 
	s NewObj.ARLocFlag=LocFlag
	i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
	{
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,ID,"A",NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
		If Rtn
	 	{
		 	TRollback
		 	q Rtn
		}
	}
	TCommit
	q ID
ErrorAdd
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

}
