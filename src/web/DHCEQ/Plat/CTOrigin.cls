Class web.DHCEQ.Plat.CTOrigin Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified By ZY20230214 bug: 3244707
/// Add By QW20210525 
/// 描述: 资产来源列表query
/// 入参:Desc:名称 Code:代码 EquipFlag:台账标志 FacilityFlag:简易台账标志
/// 访问表：  DHC_EQCOrigin
/// 出参：    TName,TRowID,TCode,TEquipFlag,TFacilityFlag,TEquipFlagDesc,TFacilityFlagDesc
/// 返回值:无
/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTOrigin","GetOrigin","")
Query GetOrigin(Desc As %Library.String = "", Code As %Library.String = "", EquipFlag As %Library.String = "", FacilityFlag As %Library.String = "") As %SQLQuery(ROWSPEC = "TName:%String:描述,TRowID:%String:ID,TCode:%String:代码,TEquipFlag:%String:设备标记,TFacilityFlag:%String:范类标记,TEquipFlagDesc:%String:设备标记,TFacilityFlagDesc:%String:范类标记,TRemark:%String:备注")
{
}

ClassMethod GetOriginExecute(ByRef qHandle As %Binary, Desc As %Library.String = "", Code As %Library.String = "", EquipFlag As %Library.String = "", FacilityFlag As %Library.String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$LB(0,repid,0)
 	Set Desc=##Class(web.DHCEQCommon).UnEscape(Desc)
 	Set Desc=$ZCONVERT(Desc ,"U")
 	
	Set index=1
	Set rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCOrigin",rowid)) q:rowid=""  d
	.Do ResetGetOrigin
	.Set TRowID = rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCOrigin",rowid)),"^",4)
	.q:InvalidFlag="Y"
	.s TEquipFlag=$p($g(^DHCEQCCode("DHCEQCOrigin",rowid)),"^",5)
	.s TFacilityFlag=$p($g(^DHCEQCCode("DHCEQCOrigin",rowid)),"^",6)
	.q:(EquipFlag'="")&&(EquipFlag'=TEquipFlag)
	.q:(FacilityFlag'="")&&(FacilityFlag'=TFacilityFlag)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCOrigin",rowid)),"^",1)
	.s TName=$p($g(^DHCEQCCode("DHCEQCOrigin",rowid)),"^",2)
	.s TEquipFlagDesc=$CASE(TEquipFlag,"Y":"是","N":"否","":"否")
	.s TFacilityFlagDesc=$CASE(TFacilityFlag,"Y":"是","N":"否","":"否")
	.Quit:(Desc'="")&&($ZCONVERT(TCode ,"U")'[Desc)&&($ZCONVERT(TName ,"U")'[Desc)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCOrigin",rowid)),"^",3)  ;Add By QW20210531 BUG:QW0116 1945350 资产来源修改
	.Do OutputGetOrigin
	Quit $$$OK
OutputGetOrigin
	Set Data=$lb(TName,TRowID,TCode,TEquipFlag,TFacilityFlag,TEquipFlagDesc,TFacilityFlagDesc,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetGetOrigin
	Set (TName,TRowID,TCode,TEquipFlag,TFacilityFlag,TEquipFlagDesc,TFacilityFlagDesc,TRemark)=""
	Quit
}

ClassMethod GetOriginFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOriginExecute ]
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

ClassMethod GetOriginClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOriginExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// Add By QW20210525 
/// 描述: 资产来源保存方法
/// 入参:data:保存数据, Dells:0-保存更新 1:删除
/// 访问表：  DHC_EQCOrigin
/// 返回值:RowID(SQLCODE)
ClassMethod SaveData(data, Dells)
{
	new (data, Dells,%session)
	s $ZT="ERROROrigin"
	k PLIST,RowID
	;Add By QW20210525 BUG:QW0115 begin
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s TableName="DHC_EQCOrigin"
	s ClassName="User.DHCEQCOrigin"
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
		s OldObject=##Class(User.DHCEQCOrigin).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		;Add By QW20210525 BUG:QW0115 end
		&SQL(Update SQLUSER.DHC_EQCOrigin set O_InvalidFlag='Y' where O_RowID = :RowID)
		If SQLCODE
		{
			TRollback
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
					
		;Add By QW20210525 BUG:QW0115 保存数据日志
		s RtnCode=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""OInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
		i RtnCode
		{
			TRollback
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(RtnCode,"保存数据日志失败!")
		}
		;Add By QW20210525 BUG:QW0115
	}else{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCOrigin",JsonData,.PLIST)
	    s RowID = JsonData.ORowID
	 	s PLIST(5) = "N"	;O_InvalidFlag
	 	s PLIST(6) = ##Class(web.DHCEQCommon).TransValueFromPage(JsonData.OEquipFlag,"bool")	;O_EquipFlag
		s PLIST(7) = ##Class(web.DHCEQCommon).TransValueFromPage(JsonData.OFacilityFlag,"bool")	;O_FacilityFlag
	   
	    ;Add By QW20210525 BUG:QW0115 begin判断数据是否重复
		s RtnInfo=##class(web.DHCEQ.Util.BDPCommonUtil).CodeDescIsRepeat(TableName,RowID,JsonData.OCode_"^"_JsonData.ODesc,"")
		s Reprowid=$p(RtnInfo,"$",1)
		s ErrMsg=$p(RtnInfo,"$",2)
		i ErrMsg'=""
		{
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrMsg)
		}
		;Add By QW20210525 BUG:QW0115 end
	    if RowID'=""
	    {
		     ;Add By QW20210525 BUG:QW0115 begin
		     s BussID=RowID,OperateType="U"
			 s OldObject=##Class(User.DHCEQCOrigin).%OpenId(BussID)
			 s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
			 ;Add By QW20210525 BUG:QW0115 end
			&SQL(Update SQLUSER.DHC_EQCOrigin Values :PLIST() where O_RowID = :RowID)
		}
		else
		{	s BussID="",OperateType="A"	;Add By QW20210525 BUG:QW0115
			&SQL(insert into SQLUSER.DHC_EQCOrigin Values :PLIST())
			s RowID=$g(%ROWID)
		}
		
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)  ;Add By QW20210525 BUG:QW0115
		}

		;Add By QW20210525 BUG:QW0115 begin数据日志更新
		s OldObject=""	//先关闭对象
		s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCOrigin).%OpenId(RowID))
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
		;Add By QW20210525 BUG:QW0115 end
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERROROrigin
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

}
