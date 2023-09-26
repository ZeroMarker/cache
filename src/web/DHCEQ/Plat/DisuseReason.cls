Import SQLUser

Class web.DHCEQ.Plat.DisuseReason Extends %Library.RegisteredObject
{

/// Add By ZYQ20210525 
/// 描述: 报废原因列表query
/// 入参:Desc:描述 Code:代码 Remark:备注
/// 访问表：  DHC_EQCOrigin
/// 出参：    TRowID,TCode,TDesc,TRemark
/// 返回值:无
///  do ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.DisuseReason","GetReason")
Query GetReason(Desc As %Library.String = "", Code As %Library.String = "", Remark As %Library.String = "") As %SQLQuery(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String")
{
}

ClassMethod GetReasonExecute(ByRef qHandle As %Binary, Desc As %Library.String = "", Code As %Library.String = "", Remark As %Library.String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$LB(0,repid,0)
	Set index=1
	Set rowid=0
	Set Desc=##Class(web.DHCEQCommon).UnEscape(Desc)
 	Set Desc=$ZCONVERT(Desc ,"U")
 	Set Code=##Class(web.DHCEQCommon).UnEscape(Code)
 	Set Code=$ZCONVERT(Code ,"U")
	f  s rowid=$o(^DHCEQCCode("DHCEQCDisuseReason",rowid)) q:rowid=""  d
	.Do ResetGetReason
	.Set TRowID = rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCDisuseReason",rowid)),"^",4)
	.q:InvalidFlag="Y"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCDisuseReason",rowid)),"^",1)
	.s TDesc=$p($g(^DHCEQCCode("DHCEQCDisuseReason",rowid)),"^",2)
	.Quit:(Desc'="")&&($ZCONVERT(TDesc ,"U")'[Desc)
	.Quit:(Code'="")&&($ZCONVERT(TCode ,"U")'[Code)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCDisuseReason",rowid)),"^",3) 
	.Do OutputGetReason
	Quit $$$OK
OutputGetReason
	Set Data=$lb(TRowID,TCode,TDesc,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetGetReason
	Set (TRowID,TCode,TDesc,TRemark)=""
	Quit
}

ClassMethod GetReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetReasonExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$LB(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Add By zyq20220824 
/// 描述: 报废原因保存方法
/// 入参:data:保存数据, Dells:0-保存更新 1:删除
/// 访问表： DHC_EQCDisuseReason
/// 返回值:RowID(SQLCODE)
/// /// do ##Class(web.DHCEQ.Plat.DisuseReason).SaveData("是")
ClassMethod SaveData(data, Dells)
{
	s $ZT="ERRORReason"
	k PLIST,RowID
	;Add By QW20210525 BUG:QW0115 begin
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s TableName="DHC_EQCDisuseReason"
	s ClassName="User.DHCEQCDisuseReason"
	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	
	;Add By QW20210525 BUG:QW0115 end
	TSTART
	if Dells=1
	{
		s RowID=data
		;Add By QW20210525 BUG:QW0115 begin
		s BussID=RowID
		s OldObject=##Class(User.DHCEQCDisuseReason).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		;Add By QW20210525 BUG:QW0115 end
		&SQL(Update SQLUSER.DHC_EQCDisuseReason set DR_InvalidFlag='Y' where DR_RowID = :RowID)
		If SQLCODE
		{
			TRollback
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
					
		;Add By QW20210525 BUG:QW0115 保存数据日志
		s RtnCode=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""DRInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
		i RtnCode
		{
			TRollback
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(RtnCode,"保存数据日志失败!")
		}
		;Add By QW20210525 BUG:QW0115
	}else{
		// modify by zyq 2022-12-08 自动生成字典 begin
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	   	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCDisuseReason",JsonData,.PLIST)
		s RowID = JsonData.DRRowID
		s RtnInfo=##class(web.DHCEQ.Util.BDPCommonUtil).CodeDescIsRepeat(TableName,RowID,JsonData.DRCode_"^"_JsonData.DRDesc,"")
		s Reprowid=$p(RtnInfo,"$",1)
		s ErrMsg=$p($p(RtnInfo,"$",2),"^",2) //modify by zyq 2023-03-01
		i ErrMsg'=""
		{
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrMsg)
		}
		// modify by zyq 2022-12-08 自动生成字典 end 
	 	s PLIST(5) = "N"	;DR_InvalidFlag
	    if RowID'=""
	    {
		     ;Add By QW20210525 BUG:QW0115 begin
		     s BussID=RowID,OperateType="U"
			 s OldObject=##Class(User.DHCEQCDisuseReason).%OpenId(BussID)
			 s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			 ;Add By QW20210525 BUG:QW0115 end
			&SQL(Update SQLUSER.DHC_EQCDisuseReason Values :PLIST() where DR_RowID = :RowID)
		}
		else
		{	s BussID="",OperateType="A"	;Add By QW20210525 BUG:QW0115
			&SQL(insert into SQLUSER.DHC_EQCDisuseReason Values :PLIST())
			s RowID=$g(%ROWID)
		}
		
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)  ;Add By QW20210525 BUG:QW0115
		}

		;Add By QW20210525 BUG:QW0115 begin数据日志更新
		s OldObject=""	//先关闭对象
		s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCDisuseReason).%OpenId(RowID))
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
			s BussID=RowID
			s NewObj=FinalObj
		}
		
		i NewObj.%ToJSON()'="{}"	//本次未更新则不记录
		{
			s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,OperateType,NewObj.%ToJSON(),OldObj.%ToJSON(),CurUser,"")
			If Rtn
		 	{
			 	TRollback
			 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Rtn,"保存数据日志失败!")
			}
		}
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRORReason
	TRollback
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// Add By zyq2022-11-15 
/// 描述: 报废原因保存方法
/// 入参:RowID(SQLCODE)
/// 访问表：DHC_EQCDisuseReason
/// 返回值:报废原因描述Desc
/// w ##Class(web.DHCEQ.Plat.DisuseReason).GetOneReason(19)
ClassMethod GetOneReason(RowId)
{
	Set Desc=""
	if (RowId="")
	{
		q $$$OK
	}
	else{
		s Desc=$p($g(^DHCEQCCode("DHCEQCDisuseReason",RowId)),"^",2)
	}
	q Desc
}

}
