/// 名称: web.DHCEQ.Plat.CTLocaton
/// 描述: 存放地点
/// 编写者：ZX
/// 编写日期: 2018-09-02
/// 产品组：设备管理
Class web.DHCEQ.Plat.CTLocaton Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ZX
/// CreatDate：    2018-08-31
/// Description:   存放地点LookUp所需Query
/// Table：        DHC_EQCLocation
/// Input：        Desc:存放地点描述
///                HospitalDR:医院ID  
///                LocDR:科室ID
/// modify by lmm 2021-06-25 表结构修改相关程序修改
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTLocaton","GetShortLocation","")
Query GetShortLocation(Desc As %String = "", HospitalDR As %String = "", LocDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TName:%String,TType:%String,THospitalDR:%String,THospital:%String,TLocDR:%String,TLoc:%String,TBuildingDR:%String,TBuildName:%String,TBuildingUnitDR:%String,TBuildingUnitName:%String,TPlace:%String,TDateActiveFrom:%String,TDateActiveTo:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod GetShortLocationExecute(ByRef qHandle As %Binary, Desc As %String = "", HospitalDR As %String = "", LocDR As %String = "") As %Status
{
	;new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	Set Desc=$ZCONVERT(Desc,"U")
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId("","")	//CZF0138 2021-05-26
	
	Do BuildDataGetShortLocation
	Quit $$$OK
BuildDataGetShortLocation
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCLocation",rowid))  Quit:rowid=""  Do
	.q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCLocation",rowid,sHospID)'="Y"		//CZF0138 2021-05-26
	.Do ResetVariablesGetShortLocation
	.Set TRowID = rowid
	.Set InvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",14)
	.Quit:InvalidFlag="Y"
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",1)
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",2)
	.Quit:(Desc'="")&&(TDesc'[Desc)&&(TCode'[Desc)
	.Set TType=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",3)
	.Set THospitalDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",4)
	.Quit:(HospitalDR'="")&&(THospitalDR'=HospitalDR)
	.if THospitalDR'="" set THospital=$p($g(^CT("HOSP",THospitalDR)),"^",2)
	.Set TLocDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",5)
	.Quit:(LocDR'="")&&(TLocDR'=LocDR)
	.Set TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.Set TBuildingDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",6) 
	.If TBuildingDR'="" Set TBuildName=$Piece($Get(^DHCEQBuilding(TBuildingDR)),"^",21)  
	.Set TBuildingUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",7)
	.If TBuildingUnitDR'="" Set TBuildingUnitName=$Piece($Get(^DHCEQBuildingUnit(TBuildingUnitDR)),"^",3)  
	.Set TPlace=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",8)
	.Set TDateActiveFrom=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",9)
	.If TDateActiveFrom'="" Set TDateActiveFrom=##class(web.DHCEQCommon).TransValueToPage(TDateActiveFrom,"date")
	.Set TDateActiveTo=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",10)
	.If TDateActiveTo'="" Set TDateActiveTo=##class(web.DHCEQCommon).TransValueToPage(TDateActiveTo,"date")
	.Set TRemark=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",12)
	.Set THold1=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",13)	;hold1
	.Set THold2=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",14)	;hold2
	.Set THold3=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",15)	;hold3
	.Set THold4=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",16)	;hold4
	.Set THold5=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",17)	;hold5	
	.Do OutputRowGetShortLocation
	Quit
OutputRowGetShortLocation
	Set Data=$lb(TRowID,TCode,TDesc,TType,THospitalDR,THospital,TLocDR,TLoc,TBuildingDR,TBuildName,TBuildingUnitDR,TBuildingUnitName,TPlace,TDateActiveFrom,TDateActiveTo,TRemark,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetShortLocation
	Set (TRowID,TCode,TDesc,TType,THospitalDR,THospital,TLocDR,TLoc,TBuildingDR,TBuildName,TBuildingUnitDR,TBuildingUnitName,TPlace,TDateActiveFrom,TDateActiveTo,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	Quit
}

ClassMethod GetShortLocationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShortLocationExecute ]
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
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetShortLocationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShortLocationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// zx 2018-12-11
/// 目的:系统自动录入存放地点
/// 描述:检测存放地点表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// 输入: Data:存放地点: 地点^科室^楼宇^楼层
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
/// modified by WY 2022-9-15 修改自动录入存放地点时保存的信息
/// w ##Class(web.DHCEQ.Plat.CTLocaton).UpdLocation("门诊楼6051")
ClassMethod UpdLocation(Data)
{
	Set (LRowID,Code)=""
	Set Desc=$ZCONVERT($p(Data,"^",1),"U")
	set LocDR=$p(Data,"^",2)
	if LocDR'="" d
	.s HospitalDR=$p(^DHCEQCCode("DHCEQCDepartment",LocDR),"^",8)
	set BuildingDR=$p(Data,"^",3)
	s CodeInfo=##class(web.DHCEQ.Plat.CTCHanZiEncoding).GetEncoding(Desc,4,"","U")
	s CodeInfo=##class(web.DHCEQ.Plat.JsonObject).FromJSON(CodeInfo)	//CZF0131 2020-01-20
	i CodeInfo.%Get("SQLCODE")=0 s Code=CodeInfo.%Get("Data")
	Set SQLCODE=0
	Set GetLocationOperMethod=##class(web.DHCEQCommon).GetSysInfo("201008")
	If (GetLocationOperMethod=0)||(Desc="") Quit ""
	&SQL(Select L_RowID Into :LRowID from SQLUSER.DHC_EQCLocation Where L_InvalidFlag='N' and L_Desc=:Desc)
	if LRowID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQCLocation(L_Code,L_Desc,L_InvalidFlag,L_LocDR,L_BuildingDR,L_HospitalDR) Values(:Code,:Desc,'N',:LocDR,:BuildingDR,:HospitalDR))
		if SQLCODE
		{
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		Set LRowID=$Get(%ROWID)
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,LRowID)
}

/// Add By CJT 2022-07-13
/// 描述: 查询数据(设备存放地点)
Query GetLocationDetails(Code As %String = "", Desc As %String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "", HospitalDR As %Library.String = "", LocDR As %Library.String = "", Hospital As %Library.String = "", Loc As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TType:%String,THospitalDR:%String,THospital:%String,TLocDR:%String,TLoc:%String,TBuildingDR:%String,TBuildName:%String,TBuildingUnitDR:%String,TBuildingUnitName:%String,TPlace:%String,TDateActiveFrom:%String,TDateActiveTo:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod GetLocationDetailsExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "", HospitalDR As %Library.String = "", LocDR As %Library.String = "", Hospital As %Library.String = "", Loc As %Library.String = "") As %Status
{
	;new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	;获取院区Id(多院区) CZF0138
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
	
	;Mozy0206	20180605	优化存放地点查询条件
	Set TRow=1
	Set Code=$ZCONVERT(Code,"U")
	Set Desc=$ZCONVERT(Desc,"U")
	Set rowid=0
	Do BuildDataGetLocationDetails
	Quit $$$OK
BuildDataGetLocationDetails
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCLocation",rowid))  Quit:rowid=""  Do
	.;当前登录人是否有权限查看表数据 CZF0138
	.q:##class(web.DHCEQ.Util.BDPCommonUtil).GetHospShowDataFlag("DHC_EQCLocation",rowid,sHospID)'="Y"
	.Do ResetVariablesGetLocationDetails
	.Set TRowID = rowid
	.Set InvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",11)
	.Quit:InvalidFlag="Y"
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",1)
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",2)
	.Quit:(Code'="")&&($ZCONVERT(TCode,"U")'[Code)&&($ZCONVERT(TDesc,"U")'[Code)
	.Quit:(Desc'="")&&($ZCONVERT(TCode,"U")'[Desc)&&($ZCONVERT(TDesc,"U")'[Desc)
	.Set TType=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",3)
	.Set THospitalDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",4)
	.Quit:(HospitalDR'="")&&(HospitalDR'=THospitalDR)
	.if THospitalDR'="" set THospital=$p($g(^CT("HOSP",THospitalDR)),"^",2)
	.Set TLocDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",5)
    .Quit:(LocDR'="")&&(LocDR'=TLocDR)
	.Set TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.Set TBuildingDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",6) 
	.If TBuildingDR'="" Set TBuildName=$Piece($Get(^DHCEQBuilding(TBuildingDR)),"^",21)  
	.Set TBuildingUnitDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",7)
	.If TBuildingUnitDR'="" Set TBuildingUnitName=$Piece($Get(^DHCEQBuildingUnit(TBuildingUnitDR)),"^",3)  
	.Set TPlace=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",8)
	.Set TDateActiveFrom=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",9)
	.If TDateActiveFrom'="" Set TDateActiveFrom=##class(web.DHCEQCommon).TransValueToPage(TDateActiveFrom,"date")
	.Set TDateActiveTo=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",10)
	.If TDateActiveTo'="" Set TDateActiveTo=##class(web.DHCEQCommon).TransValueToPage(TDateActiveTo,"date")
	.Set TRemark=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",12)
	.Set THold1=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",13)	;hold1
	.Set THold2=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",14)	;hold2
	.Set THold3=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",15)	;hold3
	.Set THold4=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",16)	;hold4
	.Set THold5=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",17)	;hold5
	.
	.Do OutputRowGetLocationDetails
	Quit
OutputRowGetLocationDetails
	Set Data=$lb(TRowID,TCode,TDesc,TType,THospitalDR,THospital,TLocDR,TLoc,TBuildingDR,TBuildName,TBuildingUnitDR,TBuildingUnitName,TPlace,TDateActiveFrom,TDateActiveTo,TRemark,THold1,THold2,THold3,THold4,THold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	Quit
ResetVariablesGetLocationDetails
	Set (TRowID,TCode,TDesc,TType,THospitalDR,THospital,TLocDR,TLoc,TBuildingDR,TBuildName,TBuildingUnitDR,TBuildingUnitName,TPlace,TDateActiveFrom,TDateActiveTo,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	Quit
}

ClassMethod GetLocationDetailsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocationDetailsExecute ]
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
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLocationDetailsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocationDetailsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      CJT
/// CreatDate：    2022-07-15
/// Description:   数据保存
/// Input：        Data:前台获取字符串 Type:操作类型(1:删除,2:增加,3:保存)
/// Return：       ID或SQLCODE
/// w ##Class(web.DHCEQ.Plat.CTLocaton).SaveData("{""_HospList"":""东华标准版数字化口腔医院"",""LCode"":""1L【KQ】"",""LDesc"":""门诊一楼"",""LHospital"":"""",""LPlace"":"""",""LRemark"":"""",""LLoc"":"""",""LRowID"":"""",""LBuilding"":"""",""LBuildingUnitName"":"""",""LType"":"""",""LArea"":"""",""LManageLoc"":"""",""LManageUser"":"""",""LTPurposeType"":"""",""LEquip"":"""",""LFloor"":"""",""LDateActiveFrom"":"""",""LDateActiveTo"":"""",""LPurposeTypeDR"":"""",""LManageUserDR"":"""",""LManageLocDR"":"""",""LEquipDR"":"""",""LLocDR"":"""",""LBuildingUnitDR"":"""",""LHospitalDR"":"""",""LBuildDR"":""""}","2","2","3")
ClassMethod SaveData(Data, Type As %String = "", gHospId As %Library.String = "", BDPHospId As %Library.String = "")
{
	k PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
    s Result=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCLocation",JsonData,.PLIST)
	s RowID = JsonData.LRowID
	s $zt="ErrorSave"
	s TableName="DHC_EQCLocation"
	s ClassName="User.DHCEQCLocation"
 	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
 	s BussID=RowID	
 	s DCRRowID=""
 	s OldObj=##class(web.DHCEQ.Plat.JsonObject).%New()
 	s NewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
 	s FinalObj=##class(web.DHCEQ.Plat.JsonObject).%New()
 	s OperateType="U"
 	;获取院区Id(多院区)
	s sHospID=##class(web.DHCEQ.Util.BDPCommonUtil).GetBDPHospId(BDPHospId,gHospId)
	s HospFlag=##class(web.DHCEQCommon).GetSysInfo("990051")
 	TSTART
	if (Type="1")
	{
		s OldObject=##Class(User.DHCEQCLocation).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)

 		Set PLIST(12)="Y"
 		&SQL(Update SQLUSER.DHC_EQCLocation Values :PLIST() where L_RowID = :RowID)

	 	If SQLCODE
	 	{
		 	TRollback
		 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"删除存放地点失败!错误信息："_$g(%msg))
		}
		/*
		;删除医院对照关系
		s RtnCode=##class(web.DHCEQ.Util.BDPCommonUtil).DeleteHospitals("DHC_EQCLocation",RowID,sHospID)
		if RtnCode<0
		{
			TROLLBACK
			q RtnCode
		}
		*/
		;保存数据日志
	 	s Rtn=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"D","{""LInvalidFlag"":""Y""}",OldObj.%ToJSON(),CurUser,"")
	 	i Rtn
	 	{
		 	TRollback
		 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Rtn,"保存数据日志错误！")
		}
		TCommit
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	}
	else
	{
		;判断数据是否重复
		i HospFlag'=2 s sHospID=PLIST(5)
		s RtnInfo=##class(web.DHCEQ.Util.BDPCommonUtil).CodeDescIsRepeat("DHC_EQCLocation",RowID,PLIST(2)_"^"_PLIST(3),sHospID)
		s rowid=$p(RtnInfo,"$",1)
		s ErrMsg=$p(RtnInfo,"$",2)
		if (rowid="")
		{
			If (RowID="")
	 		{
		 		s PLIST(15) ="N"
		 		Set BussID="",OperateType="A"
				&SQL(Insert Into SQLUSER.DHC_EQCLocation Values :PLIST())
			} 
			Else
			{
				Set BussID=RowID,OperateType="U"
				s OldObject=##Class(User.DHCEQCLocation).%OpenId(BussID)
				s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
				&SQL(Update SQLUSER.DHC_EQCLocation Values :PLIST() where L_RowID = :RowID)
			}
		}
		else
		{
			Quit:RowID="" ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-3003,$p(ErrMsg,"^",2))
		 	Quit:(RowID'="")&&(RowID'=rowid) ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-3003,$p(ErrMsg,"^",2))
		 	Set BussID=RowID,OperateType="U"
			s OldObject=##Class(User.DHCEQCLocation).%OpenId(BussID)
			s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		 	&SQL(Update SQLUSER.DHC_EQCLocation Values :PLIST() where L_RowID = :RowID)
		}
	}
	
	If SQLCODE
 	{
	 	TRollback
	 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存存放地点失败!错误信息："_$g(%msg))
	}
	Set ID=$g(%ROWID)
	
    ;保存医院对照关系
	s RtnCode=##class(web.DHCEQ.Util.BDPCommonUtil).SaveHOSP("DHC_EQCLocation",ID,sHospID)
	if RtnCode<0
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(RtnCode,"保存医院对照关系失败！")
	}
	
	;数据日志更新
	s OldObject=""	//先关闭对象 czf 2021-01-21
	s FinalObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(##Class(User.DHCEQCLocation).%OpenId(ID))
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
		 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Rtn,"保存数据日志失败！")
		}
	}
	TCommit
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ID)
ErrorSave
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

}
