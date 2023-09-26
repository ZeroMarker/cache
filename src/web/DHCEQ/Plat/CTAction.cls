/// Description:动作定义查询
/// Creator:	cjc
/// CreateDate:	20220803
Class web.DHCEQ.Plat.CTAction Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: CJC  
/// CreatDate: 2022-07-26 
/// Description:  动作定义页面查询
/// Input: Code，Desc，Remark，SourceTypeID
/// Output: Data:(TRowID,TCode,TDesc,TRemark,TInvalidFlag,TSourceTypeID,TSourceType)
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTAction","Action","","","","")
Query Action(Code As %String = "", Desc As %String = "", Remark As %String = "", SourceTypeID As %String) As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlag:%String,TSourceTypeID:%String,TSourceType:%String")
{
}

ClassMethod ActionExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "", SourceTypeID As %String) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Remark=$ZCONVERT(Remark ,"U")
	s index=1
	
	s rowid=0
	for  s rowid=$o(^DHCEQCCode("DHCEQCAction",rowid)) quit:rowid=""  d
	.d ResetVariablesGetAction
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",2)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",3)
	.q:($ZCONVERT(TCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(TDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(TRemark,"U")'[Remark)&(Remark'="")
	.s TSourceTypeID=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",4)
	.q:(SourceTypeID'="")&(SourceTypeID'=TSourceTypeID)
	.i TSourceTypeID'="" d
	..s TSourceType=$p($g(^DHCEQCCode("DHCEQCApproveType",TSourceTypeID)),"^",2)
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQCAction",rowid)),"^",5)
	.q:TInvalidFlag="Y"
	.d OutputRowGetAction
	
	Quit $$$OK
	
OutputRowGetAction
	s Data=$lb(TRowID,TCode,TDesc,TRemark,TInvalidFlag,TSourceTypeID,TSourceType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
	
ResetVariablesGetAction
	s (TRowID,TCode,TDesc,TRemark,TInvalidFlag,TSourceTypeID,TSourceType)=""
	quit
}

ClassMethod ActionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ActionExecute ]
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

ClassMethod ActionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ActionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:  CJC  
/// CreatDate: 2022-08-03
/// Description: 设备单位数据增删改查
/// Table: DHC_EQCAction
/// Input：data:前台获取字符串 field:value,filed:vale  DelIs:操作类型：（0：新增与修改）,（1：删除）
/// Return： Json
/// w ##class(web.DHCEQ.Plat.CTAction).SaveData("{""ACode"":""1"",""ADesc"":""AA"",""ASourceType"":""27"",""ARemark"":""1"",""ARowId"":""1""}","0")
ClassMethod SaveData(Data, DelIs As %Library.String = "")
{
	new (Data, DelIs, %session)
	s $ZT="ERRORACTION"
	s SQLCODE=0
	k PLIST,RowID
	s TableName="DHC_EQCAction"
	s ClassName="User.DHCEQCAction"
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	
	TSTART
	if DelIs=1
	{
		s RowID=Data
		s BussID=RowID
		s OldObject=##Class(User.DHCEQCAction).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		&SQL(Update SQLUSER.DHC_EQCAction set A_InvalidFlag='Y' where A_RowID = :RowID)
		If SQLCODE
		{
			TRollback
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",SQLCODE)
		}
		s Rtn=##Class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"U","{""AInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
		i Rtn
		{
			TRollback
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",Rtn) 
		}
		
		TCommit
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCAction",JsonData,.PLIST)
	    s RowID = JsonData.ARowID	
	    s PLIST(6) = "N"	;
	    s tmpid=""
		//判断数据是否重复
		if RowID = "" //RowID为空进行新增操作
		{
			//当代码、描述、来源类型数据重复时不能插入
			&SQL(select A_RowID into :tmpid from SQLUSER.DHC_EQCAction where A_Code=:PList(2) and A_Desc=:PList(3) and A_SourceType=:PList(5))
			if (tmpid="")  //添加新数据，并且设置删除标志位为N
			{
			 	s PLIST(6)="N"
			 	s BussID=RowID,OperateType="A"
			 	&SQL(insert into SQLUSER.DHC_EQCAction values :PLIST())
			 	s RowID=$g(%ROWID) // 获取新增rowid
			 	
		 	}
		 	else      //修改删除标志位 Y->N
		 	{
			 	s PLIST(6)="N"
			 	s BussID=RowID,OperateType="D"
			 	s OldObject=##Class(User.DHCEQCAction).%OpenId(BussID)
			    s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			 	&SQL(Update SQLUSER.DHC_EQCAction values :PLIST() where A_RowID=:tmpid)
			 	
	     	}
			
		}
		else
		{
			s BussID=RowID,OperateType="D"
			s OldObject=##Class(User.DHCEQCAction).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			&SQL(Update SQLUSER.DHC_EQCAction Values :PLIST() where A_RowID = :RowID)
		
		}
		s OldObject=""	//先关闭对象
		s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCAction).%OpenId(RowID))
		s BussID=RowID
		s NewObj=FinalObj
		i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
		{
			s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
			If Rtn
		 	{
			 	TRollback
			 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012",Rtn) 
			}
		}
		
		TCommit
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORACTION
	TRollback
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

}
