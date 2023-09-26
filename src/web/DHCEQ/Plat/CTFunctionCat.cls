Class web.DHCEQ.Plat.CTFunctionCat Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:	CZF0138
/// CreateDate:	2021-05-22
/// Descript:	获取功能分类数据
/// Input: 		gHospId:医院ID
/// 			BDPHospId:平台医院ID
/// Output: 	
/// Command:	do ##Class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTFunctionCat","GetFunctionCat","")
Query GetFunctionCat(Code As %Library.String = "", Desc As %Library.String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "") As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TRemark:%String")
{
}

ClassMethod GetFunctionCatExecute(ByRef qHandle As %Binary, Code As %Library.String = "", Desc As %Library.String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$LB(0,repid,0)
 	Set Desc=##Class(web.DHCEQCommon).UnEscape(Desc)
 	Set Desc=$ZCONVERT(Desc ,"U")
 	Set index=1
	;获取院区Id(多院区) CZF0138
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
	
	Set rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCFunctionCat",rowid)) q:rowid=""  d
	.Do ResetGetFunctionCat
	.;当前登录人是否有权限查看表数据 CZF0138
	.q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCFunctionCat",rowid,sHospID)'="Y"
	.Set TRowID = rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCFunctionCat",rowid)),"^",4)
	.q:InvalidFlag="Y"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCFunctionCat",rowid)),"^",1)
	.s TName=$p($g(^DHCEQCCode("DHCEQCFunctionCat",rowid)),"^",2)
	.Quit:(Desc'="")&&($ZCONVERT(TCode ,"U")'[Desc)&&($ZCONVERT(TName ,"U")'[Desc)
	.s TRemark=$p($g(^DHCEQCCode("DHCEQCFunctionCat",rowid)),"^",3)
	.Do OutputGetFunctionCat
	Quit $$$OK
OutputGetFunctionCat
	Set Data=$lb(TName,TRowID,TCode,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetGetFunctionCat
	Set (TName,TRowID,TCode,TRemark)=""
	Quit
}

ClassMethod GetFunctionCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFunctionCatExecute ]
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

ClassMethod GetFunctionCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFunctionCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// Creator:	CZF0138
/// CreateDate:	2021-05-22
/// Descript:	保存或删除功能分类数据
/// Input: 		data:医院ID
/// 			DelIs:删除标志 1：删除
/// 	 		gHospId:医院ID
/// 			BDPHospId:平台医院ID
/// Output: 	
/// Command:	w ##Class(web.DHCEQ.Plat.CTFunctionCat).SaveData()
ClassMethod SaveData(data, DelIs, gHospId As %Library.String = "", BDPHospId As %Library.String = "")
{
	new (data, DelIs,%session,gHospId,BDPHospId)
	s $ZT="ERRORSave"
	k PLIST,RowID
	;获取院区Id(多院区)
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
	
	s TableName="DHC_EQCFunctionCat"
	s ClassName="User.DHCEQCFunctionCat"
	s BussID=""
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	
	TSTART
	if DelIs=1
	{
		s RowID=data
		s BussID=RowID
		s OldObject=##Class(User.DHCEQCFunctionCat).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		
		&SQL(Update SQLUSER.DHC_EQCFunctionCat set FC_InvalidFlag='Y' where FC_RowID = :RowID)
		If SQLCODE
		{
			TRollback
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"删除功能分类失败!错误信息："_$g(%msg))
		}
		
		/*
		;删除医院对照关系
		s RtnCode=##class(web.DHCEQ.Util.BDPCommonUtil).DeleteHospitals("DHC_EQCFunctionCat",RowID,sHospID)
		if RtnCode<0
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(RtnCode,"保存医院对照失败!")
		}
		*/
		
		;保存数据日志
		s RtnCode=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""FCInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
		i RtnCode
		{
			TRollback
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(RtnCode,"保存数据日志失败!")
		}
		
		TCommit
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	}else{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCFunctionCat",JsonData,.PLIST)
	    s RowID = JsonData.FCRowID
	 	s PLIST(5) = "N"	;FC_InvalidFlag
	 	s PLIST(6) = sHospID	;FC_Hold1
	 	
	 	;判断数据是否重复
		s RtnInfo=##class(web.DHCEQ.Util.BDPCommonUtil).CodeDescIsRepeat("DHC_EQCFunctionCat",RowID,JsonData.FCCode_"^"_JsonData.FCDesc,sHospID)
		s Reprowid=$p(RtnInfo,"$",1)
		s ErrMsg=$p($p(RtnInfo,"$",2),"^",2)
		i ErrMsg'=""
		{
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrMsg)
		}
		if (Reprowid="")
		{
	 		if RowID'=""
		    {
			    s BussID=RowID,OperateType="U"
			    s OldObject=##Class(User.DHCEQCFunctionCat).%OpenId(BussID)
			    s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
				&SQL(Update SQLUSER.DHC_EQCFunctionCat Values :PLIST() where FC_RowID = :RowID)
			}
			else
			{
				s BussID="",OperateType="A"
				&SQL(insert into SQLUSER.DHC_EQCFunctionCat Values :PLIST())
				s RowID=$g(%ROWID)
			}
		}
	    else
	    {
		    q:RowID="" ""
		 	q:(RowID'=Reprowid) ""
		    s BussID=RowID,OperateType="U"
		    s OldObject=##Class(User.DHCEQCFunctionCat).%OpenId(BussID)
		    s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		 	&SQL(Update SQLUSER.DHC_EQCFunctionCat Values :PLIST() where FC_RowID = :RowID)
		}
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存功能分类失败!错误信息："_$g(%msg))
		}
	
		;保存医院对照关系
		s RtnCode=##class(web.DHCEQ.Util.BDPCommonUtil).SaveHOSP("DHC_EQCFunctionCat",RowID,sHospID)
	    if RtnCode<0
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(RtnCode,"保存医院对照失败!")
		}
		
		;数据日志更新
		s OldObject=""	//先关闭对象
		s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCFunctionCat).%OpenId(RowID))
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
			 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Rtn,"保存数据日志失败！")
			}
		}
	}
	
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRORSave
	TROLLBACK 
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

}
