Class web.DHCEQCApproveCondition Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by sjh SJH0042 2020-12-04 增加数据修改日志
ClassMethod UpdateData(Val, Type)
{
	//Type=0,更新
	//Type＝1，删除
	Set $ZT="ERROR"
	s RowID=$P(Val,"^",1)
	s TableName="DHC_EQCApproveCondition"
	s ClassName="User.DHCEQCApproveCondition"
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	s BussID=RowID	
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	TStart
	i +Type=0
	{
		s PLIST(2)=$P(Val,"^",2)
		s PLIST(3)=$P(Val,"^",3)
		s PLIST(4)=$P(Val,"^",4)
		s PLIST(5)=$P(Val,"^",5)
		if RowID=""
		{
			Set BussID="",OperateType="A"
			&SQL(insert into sqluser.DHC_EQCApproveCondition values :PLIST())
			s RowID=$G(%ROWID)
		}
		else
		{
			Set BussID=RowID,OperateType="U"
			s OldObject=##Class(User.DHCEQCApproveCondition).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			&SQL(update sqluser.DHC_EQCApproveCondition values :PLIST() where AC_RowID=:RowID)
		}
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	else
	{
		s OldObject=##Class(User.DHCEQCApproveCondition).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

		&SQL(delete from sqluser.DHC_EQCApproveCondition where AC_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D",NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TROLLBACK
		 	q Rtn
		}
		TCOMMIT
	 	Quit RowID
	}
	if SQLCODE  
	{
		TRollback
		q SQLCODE
	}
	Set ID=$g(%ROWID)
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCApproveCondition).%OpenId(ID))
	i BussID'=""	//更新数据获取更新字段Json串
	{
		s key=""
		For
		{
			s value=FinalObj.GetNext(.key)
			q:key=""
    		i (value'=OldObj.%Get(key)) d NewObj.%Set(key,value)
		}
	}
	else			//插入数据
	{
		s BussID=ID
		s NewObj=FinalObj
	}
	
	i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
	{
		s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
		If Rtn
	 	{
		 	TROLLBACK
		 	q Rtn
		}
	}
 	TCOMMIT
 	q ID
ERROR
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERROR"_ErrorMsg     //返回错误消息 ;
}

ClassMethod GetOneApproveCondition(RowID)
{
	new result,ApproveRole
	s (result,ApproveRole)=""
	s result=^DHCEQCCode("DHCEQCApproveCondition",RowID)
	s ConditionFieldsDR=$P(result,"^",2)
	i ConditionFieldsDR'=""  d
	.s Name=$P(^DHCEQCCode("DHCEQCConditionFields",ConditionFieldsDR),"^",1)
	.s TableName=$P(^DHCEQCCode("DHCEQCConditionFields",ConditionFieldsDR),"^",2)
	.s Type=$P(^DHCEQCCode("DHCEQCConditionFields",ConditionFieldsDR),"^",3)
	q result_"^"_Name_"^"_TableName_"^"_Type
}

/// Modified By QW-2018-0914 需求号:598468 修改query并增加输出序号
/// d ##class(%ResultSet).RunQuery("web.DHCEQCApproveCondition","GetApproveCondition")
Query GetApproveCondition(ApproveSetDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TApproveSet:%String,TField:%String,TTableName:%String,TType:%String,TValue:%String,TToValue:%String,TRow:%String")
{
}

ClassMethod GetApproveConditionExecute(ByRef qHandle As %Binary, ApproveSetDR As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i ApproveSetDR="" QUIT $$$OK
 	s TRow=0
	s index=1
	s rowid=0
	d BuildDataApproveCondition
	Quit $$$OK
BuildDataApproveCondition
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCApproveCondition",rowid))  quit:rowid=""  d
	.d ResetVariablesApproveCondition
	.s TRowID = rowid
	.s TApproveSet=$p($g(^DHCEQCCode("DHCEQCApproveCondition",rowid)),"^",1)
	.q:TApproveSet'=ApproveSetDR
	.i TApproveSet'="" s TApproveSet=$p($g(^DHCEQCCode("DHCEQCApproveSet",TApproveSet)),"^",2)
	.s TConditionFieldsDR=$p($g(^DHCEQCCode("DHCEQCApproveCondition",rowid)),"^",2)
	.i TConditionFieldsDR'=""  d
	..s TField=$P(^DHCEQCCode("DHCEQCConditionFields",TConditionFieldsDR),"^",1)
	..s TTableName=$P(^DHCEQCCode("DHCEQCConditionFields",TConditionFieldsDR),"^",2)
	..s TType=$P(^DHCEQCCode("DHCEQCConditionFields",TConditionFieldsDR),"^",3)
	.s TValue=$p($g(^DHCEQCCode("DHCEQCApproveCondition",rowid)),"^",3)
	.s TToValue=$p($g(^DHCEQCCode("DHCEQCApproveCondition",rowid)),"^",4)
	.d OutputRowApproveCondition
	quit
OutputRowApproveCondition
    s TRow=TRow+1
	s Data=$lb(TRowID,TApproveSet,TField,TTableName,TType,TValue,TToValue,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesApproveCondition
	s (TRowID,TApproveSet,TField,TTableName,TType,TValue,TToValue)=""
	quit
}

ClassMethod GetApproveConditionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetApproveConditionExecute ]
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

ClassMethod GetApproveConditionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetApproveConditionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
