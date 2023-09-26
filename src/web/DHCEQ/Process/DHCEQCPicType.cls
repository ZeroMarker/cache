Class web.DHCEQ.Process.DHCEQCPicType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 获取业务可访问图片类型
/// w ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQCPicType","GetPicType","","",0)
Query GetPicType(RowID As %String = "", Desc As %String = "", CurrentSourceType = "", Code As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String")
{
}

ClassMethod GetPicTypeExecute(ByRef qHandle As %Binary, RowID As %String = "", Desc As %String = "", CurrentSourceType As %String = "", Code As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	i CurrentSourceType '="" 
	{
		s PicSourceTypeDR=0
		For  Set PicSourceTypeDR=$Order(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR)) Quit:PicSourceTypeDR=""  Do BuildDataGetPicType
 	
		s TPicTypeDR=""
		for  Set TPicTypeDR=$o(DHCEQTemp(TPicTypeDR)) q:TPicTypeDR=""  d
		.Do ResetVariablesLookUpInfo
		.Set TRowID =TPicTypeDR
		.Quit:(RowID'="")&&(TRowID'=RowID)
		.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowID)),"^",1)
		.q:(Code'="")&&(TCode'[Code)
		.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowID)),"^",2)
		.Quit:(Desc'="")&&(TDesc'[Desc)
		.q:($Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowID)),"^",4)="Y")
		.Do OutputRowLookUpInfo
	}
	else
	{
		s TPicTypeDR=0
		for  Set TPicTypeDR=$o(^DHCEQCCode("DHCEQCPicType",TPicTypeDR)) q:TPicTypeDR=""  d
		.Do ResetVariablesLookUpInfo
		.Set TRowID =TPicTypeDR
		.Quit:(RowID'="")&&(TRowID'=RowID)
		.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowID)),"^",1)
		.q:(Code'="")&&(TCode'[Code)
		.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowID)),"^",2)
		.Quit:(Desc'="")&&(TDesc'[Desc)
		.q:($Piece($Get(^DHCEQCCode("DHCEQCPicType",TRowID)),"^",4)="Y")
		.Do OutputRowLookUpInfo
	}
	
	Quit $$$OK	
BuildDataGetPicType
	s TSourceType=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",1)
	q:(CurrentSourceType'="")&&(CurrentSourceType'=TSourceType)
	s TPicTypeDR=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",2)
	Set TInvalidFlag=$p(^DHCEQCCode("DHCEQCPicSourceType",PicSourceTypeDR),"^",9)
	Quit:TInvalidFlag="Y"
	s DHCEQTemp(TPicTypeDR)=TPicTypeDR
	quit
OutputRowLookUpInfo
	s Data=$lb(TRowID,TCode,TDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesLookUpInfo
	Set (TRowID,TCode,TDesc)=""
	Quit
}

ClassMethod GetPicTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPicTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPicTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPicTypeExecute ]
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

/// 获取业务下所有图片类型及其访问权限
/// w ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQCPicType","GetPicTypeAndAccess","",0)
Query GetPicTypeAndAccess(Desc As %String = "", CurrentSourceType) As %Query(ROWSPEC = "TPicSourceTypeDR:%String,TPicTypeDR:%String,TCode:%String,TDesc:%String,TAccess:%String")
{
}

ClassMethod GetPicTypeAndAccessExecute(ByRef qHandle As %Binary, Desc As %String = "", CurrentSourceType) As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	i CurrentSourceType =""  q
	
	s TPicTypeDR=0
	for  Set TPicTypeDR=$o(^DHCEQCCode("DHCEQCPicType",TPicTypeDR)) q:TPicTypeDR=""  d
	.Do ResetVariablesPicTypeAndAccess
	.//Set TRowId =TPicTypeDR
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TPicTypeDR)),"^",1)
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCPicType",TPicTypeDR)),"^",2)
	.Quit:(Desc'="")&&(TDesc'[Desc)
	.q:($Piece($Get(^DHCEQCCode("DHCEQCPicType",TPicTypeDR)),"^",4)="Y")
	.Set TPicSourceTypeDR=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex",CurrentSourceType,TPicTypeDR,""))
	.s TAccess="Y"
	.s:(TPicSourceTypeDR'="") TAccess=$Piece($Get(^DHCEQCCode("DHCEQCPicSourceType",TPicSourceTypeDR)),"^",9)
	.Do OutputRowPicTypeAndAccess
	
	
	Quit $$$OK	
OutputRowPicTypeAndAccess
	s Data=$lb(TPicSourceTypeDR,TPicTypeDR,TCode,TDesc,TAccess)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesPicTypeAndAccess
	Set (TPicSourceTypeDR,TDesc,TAccess)=""
	Quit
}

ClassMethod GetPicTypeAndAccessClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPicTypeAndAccessExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPicTypeAndAccessFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPicTypeAndAccessExecute ]
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

/// modified by sjh SJH0040 2020-11-26 添加数据修改日志记录
ClassMethod SaveData(PTData)
{
	new PList
	s rowid=$p($G(PTData),"^",1)	
	s TableName="DHC_EQCPicType"
 	s ClassName="User.DHCEQCPicType"
	s $zt="ErrorDel"
 	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	s BussID=rowid
	s DCRRowID=""
	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	
	s PList(1)=$p($G(PTData),"^",1)
	s PList(2)=$p($G(PTData),"^",2)
	s PList(3)=$p($G(PTData),"^",3)
	s PList(5)=$p($G(PTData),"^",5)

 	TSTART
	s tmpid=""      //add by czf 550193
	&SQL(select PT_RowID into tmpid from SQLUser.DHC_EQCPicType where PT_Code=:PList(2) and PT_Desc=:PList(3) and PT_InvalidFlag='N')
	if (tmpid'="") q "数据有重复"
	
	i (PList(1)="")&&(PList(5)="N")
	{
		k PList(1)
		//注意提交后要刷新
		//&SQL(select PT_RowID from SQLUser.DHC_EQCPicType where PT_Code=:PList(2) or PT_Desc=:PList(3))  ///modify by lmm 2017-04-06 359392
		//if (SQLCODE'=100) q -1   ///modify by lmm 2017-04-06 359392
		Set BussID="",OperateType="A"
		s PList(5)="N"
		&SQL(insert into SQLUser.DHC_EQCPicType values :PList())
		
	}
	else
	{
		//&SQL(select PT_RowID from SQLUser.DHC_EQCPicType where (PT_Code=:PList(2) or PT_Desc=:PList(3)) and PT_RowID!=:PList(1))
		//if (SQLCODE'=100) q -1	///modify by lmm 2017-04-11 361681
		s PTRowID=PList(1)
		k PList(1)
		Set BussID=rowid,OperateType="U"
		s OldObject=##Class(User.DHCEQCPicType).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		&SQL(Update SQLUser.DHC_EQCPicType values :PList() where PT_RowID=:PTRowID)

	}
	if SQLCODE  
	{
		TRollback
		q SQLCODE
	}
	Set ID=$g(%ROWID)
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCPicType).%OpenId(ID))

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
		 	TRollback
		 	q Rtn
		}
	}
	TCommit
	q ID
ErrorSave
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

// 需求号：266171  start    add by csy 2016-10-17 

/// modified by sjh SJH0040 2020-11-26 添加数据修改日志记录
ClassMethod DeletePTData(PTRowID)
{
	q:PTRowID=""
	//modify by mwz 2017-10-27需求号467118
	s TableName="DHC_EQCPicType"
 	s ClassName="User.DHCEQCPicType"
	s $zt="ErrorDel"
 	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	s BussID=PTRowID	
	s DCRRowID=""
	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
 	TSTART
	
	new SQLCODE
	s count=0
	&SQL(select count(*) into :count from SQLUser.DHC_EQCPicSourceType where (PST_PicTypeDR=:PTRowID) and PST_Invalidflag='N' )
	i count'=0 q -1

	s OldObject=##Class(User.DHCEQCPicType).%OpenId(BussID)
	s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

	&SQL(Update SQLUSER.DHC_EQCPicType Set PT_InvalidFlag='Y' where PT_RowID=:PTRowID)
	
	 If SQLCODE
	 {
		 TRollback
		 q SQLCODE
	 }
	 s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""PTInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
	 i Rtn
	 {
		 TRollback
		 q Rtn
	 }
	TCommit
	Quit SQLCODE
ErrorDel
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ErrorDel"_ErrorMsg     //返回错误消息 ;
}

//  需求号：266171  end  add by csy 2016-10-17  

/// Add By DJ 2017-04-27
/// 描述:根据业务类型获取图片类型  
ClassMethod GetPicTypeBySourceType(vSourceType As %String = "")
{
	i vSourceType="" q ""
	s ReturnInfo=""
	s PicTypeDR=0
	f  s PicTypeDR=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex",vSourceType,PicTypeDR))  q:PicTypeDR=""  d
	.s PicType=$p($g(^DHCEQCCode("DHCEQCPicType",PicTypeDR)),"^",2)
	.s PSTRowID=0
	.s InvalidFlag="N"
	.f  s PSTRowID=$o(^DHCEQCCode("DHCEQCPicSourceType",0,"SourceTypeIndex",vSourceType,PicTypeDR,PSTRowID))  q:(PSTRowID="")||(InvalidFlag="Y")  d
	..s InvalidFlag=$p(^DHCEQCCode("DHCEQCPicSourceType",PSTRowID),"^",9)
	.q:InvalidFlag="Y"
	.i ReturnInfo=""  d
	..s ReturnInfo="^..........&"_PicTypeDR_"^"_PicType
	.e  d
	..s ReturnInfo=ReturnInfo_"&"_PicTypeDR_"^"_PicType
	
	q ReturnInfo
}

}
